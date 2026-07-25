/* pbm2icn.c -- convert a 32x32 1-bit PBM (P1 or P4) into Rez 'ICN#' and
 * 'ICON' resources (128, purgeable): the icon bitmap plus a derived
 * transparency mask ('ICN#', used by the Finder), and the bare icon
 * bitmap alone ('ICON', what the Dialog Manager's DITL Icon item actually
 * draws via GetIcon -- no mask). Output goes to stdout; Task 6 shells
 * this and appends the text verbatim into a generated .r file.
 *
 * Usage: pbm2icn ICON.pbm
 * Exit 1 with a one-line stderr message on: unreadable file, not P1/P4,
 * or dimensions != 32x32.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 32
#define BYTES 128 /* SIZE*SIZE/8 */

static void die(const char *msg) {
    fprintf(stderr, "pbm2icn: %s\n", msg);
    exit(1);
}

typedef struct {
    const unsigned char *buf;
    size_t len, pos;
} Reader;

static int rd_byte(Reader *r) {
    if (r->pos >= r->len) return -1;
    return r->buf[r->pos++];
}

static void rd_unget(Reader *r) {
    if (r->pos > 0) r->pos--;
}

/* Skip whitespace and '#'-to-end-of-line comments; may appear anywhere
 * between header/bitmap tokens. */
static void skip_ws(Reader *r) {
    for (;;) {
        int c = rd_byte(r);
        if (c < 0) return;
        if (isspace(c)) continue;
        if (c == '#') {
            while ((c = rd_byte(r)) >= 0 && c != '\n') {}
            continue;
        }
        rd_unget(r);
        return;
    }
}

/* Read a whitespace/comment-delimited decimal integer; -1 if none found. */
static int rd_int(Reader *r) {
    skip_ws(r);
    int v = 0, any = 0, c;
    while ((c = rd_byte(r)) >= 0 && isdigit(c)) {
        v = v * 10 + (c - '0');
        any = 1;
    }
    if (c >= 0) rd_unget(r);
    return any ? v : -1;
}

static int get_bit(const unsigned char *bmp, int row, int col) {
    int i = row * SIZE + col;
    return (bmp[i / 8] >> (7 - i % 8)) & 1;
}

static void set_bit(unsigned char *bmp, int row, int col, int v) {
    int i = row * SIZE + col;
    unsigned char m = (unsigned char)(0x80 >> (i % 8));
    if (v) bmp[i / 8] |= m;
    else bmp[i / 8] &= (unsigned char)~m;
}

/* Flood fill from every white border pixel (4-connectivity); everything
 * reached is exterior. Mask = opaque (1) everywhere except reachable
 * exterior white -- i.e. black pixels and any enclosed white "holes" stay
 * opaque.
 * ponytail: 4-connectivity silhouette mask; add an explicit mask:
 * property if an icon ever needs designed transparency. */
static void compute_mask(const unsigned char *icon, unsigned char *mask) {
    memset(mask, 0xFF, BYTES);
    unsigned char visited[SIZE][SIZE];
    memset(visited, 0, sizeof visited);
    int qx[SIZE * SIZE], qy[SIZE * SIZE], qh = 0, qt = 0;

    for (int c = 0; c < SIZE; c++) {
        for (int rr = 0; rr < SIZE; rr += SIZE - 1) {
            if (!visited[rr][c] && !get_bit(icon, rr, c)) {
                visited[rr][c] = 1;
                qx[qt] = c; qy[qt] = rr; qt++;
            }
        }
    }
    for (int row = 0; row < SIZE; row++) {
        for (int cc = 0; cc < SIZE; cc += SIZE - 1) {
            if (!visited[row][cc] && !get_bit(icon, row, cc)) {
                visited[row][cc] = 1;
                qx[qt] = cc; qy[qt] = row; qt++;
            }
        }
    }

    static const int dx[4] = {1, -1, 0, 0};
    static const int dy[4] = {0, 0, 1, -1};
    while (qh < qt) {
        int x = qx[qh], y = qy[qh]; qh++;
        set_bit(mask, y, x, 0);
        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d], ny = y + dy[d];
            if (nx < 0 || nx >= SIZE || ny < 0 || ny >= SIZE) continue;
            if (visited[ny][nx] || get_bit(icon, ny, nx)) continue;
            visited[ny][nx] = 1;
            qx[qt] = nx; qy[qt] = ny; qt++;
        }
    }
}

static void print_block(const unsigned char *bytes, int trailing_comma) {
    for (int line = 0; line < 8; line++) {
        printf("\t\t$\"");
        for (int b = 0; b < 16; b++) {
            if (b > 0 && b % 2 == 0) printf(" ");
            printf("%02X", bytes[line * 16 + b]);
        }
        printf("\"");
        if (trailing_comma && line == 7) printf(",");
        printf("\n");
    }
}

int main(int argc, char **argv) {
    if (argc != 2) die("usage: pbm2icn ICON.pbm");

    FILE *fp = fopen(argv[1], "rb");
    if (!fp) die("cannot open file");

    unsigned char *data = NULL;
    size_t cap = 0, len = 0, n;
    unsigned char tmp[4096];
    while ((n = fread(tmp, 1, sizeof tmp, fp)) > 0) {
        if (len + n > cap) {
            cap = (cap + n) * 2 + 4096;
            data = realloc(data, cap);
            if (!data) die("out of memory");
        }
        memcpy(data + len, tmp, n);
        len += n;
    }
    fclose(fp);
    if (!data || len == 0) die("empty or unreadable file");

    Reader r = {data, len, 0};
    int c1 = rd_byte(&r), c2 = rd_byte(&r);
    if (c1 != 'P' || (c2 != '1' && c2 != '4')) die("not a P1/P4 PBM");
    int p4 = (c2 == '4');

    int w = rd_int(&r), h = rd_int(&r);
    if (w != SIZE || h != SIZE) die("PBM must be exactly 32x32");

    unsigned char icon[BYTES];
    memset(icon, 0, sizeof icon);

    if (p4) {
        int ws = rd_byte(&r);
        if (ws < 0 || !isspace(ws)) die("malformed P4 header");
        if (r.len - r.pos < BYTES) die("truncated P4 raster data");
        memcpy(icon, r.buf + r.pos, BYTES);
    } else {
        for (int i = 0; i < SIZE * SIZE; i++) {
            skip_ws(&r);
            int c = rd_byte(&r);
            if (c != '0' && c != '1') die("malformed P1 raster data");
            if (c == '1') icon[i / 8] |= (unsigned char)(0x80 >> (i % 8));
        }
    }

    unsigned char mask[BYTES];
    compute_mask(icon, mask);

    printf("resource 'ICN#' (128, purgeable) {\n");
    printf("\t{\n");
    print_block(icon, 1);
    print_block(mask, 0);
    printf("\t}\n");
    printf("};\n");

    /* 'ICON' is a bare hex string[128], not an array -- no mask, no inner
     * braces (unlike ICN#'s `array { hex string[128] }`). */
    printf("\n");
    printf("resource 'ICON' (128, purgeable) {\n");
    print_block(icon, 0);
    printf("};\n");

    free(data);
    return 0;
}
