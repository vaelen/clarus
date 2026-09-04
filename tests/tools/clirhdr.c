/* tests/tools/clirhdr.c -- print a 'CLIR' bake artifact's header and
 * section framing, or write a one-byte-flipped copy of it.
 *
 * usage: clirhdr FILE                   -- print the header (below)
 *        clirhdr --flip-stamp FILE OUT  -- copy, first stamp byte ^= 0xFF
 *        clirhdr --flip-body  FILE OUT  -- copy, first body  byte ^= 0xFF
 *
 * A field-for-field port of internal/bake/bake.go's ParseHeader (every
 * need(n) bounds check and the trailing-byte accounting included) over
 * clarusc/bake.cla's format:
 *
 *   magic 'CLIR' | formatVersion(4) | laneTag(1) | stampLen(2) | stamp |
 *   bodyHash(4) | moduleCount(2) | [keyLen(1) key]... |
 *   sectionCount(2) | [id(2) len(4) payload]...
 *
 * All multi-byte fields are big-endian.  The section table must account
 * for every remaining byte -- a structural well-formedness check, not a
 * section-content decode, which is the loader's job.
 *
 * Print form: one header line of space-separated key=value pairs
 *
 *   version=7 lane=68k stamp=001bd50d bodyhash=05369397 modules=23 \
 *       sections=46 body_off=17
 *
 * then one `module <key>` line per module in manifest order, then one
 * `section <id> <len> <off>` line per section in table order.  A framing
 * error prints `parse error at N: reason` on stderr and exits 1; the
 * flip modes mirror bake.go's CorruptStampFixture/CorruptBodyFixture,
 * which parse the artifact before patching it in place.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned char *data;
static long dlen;
static long pos;

static void parse_error(const char *reason) {
    fprintf(stderr, "parse error at %ld: %s\n", pos, reason);
    exit(1);
}

/* need(n) mirrors ParseHeader's own closure: n more bytes must be
 * available at pos, or the artifact is truncated. */
static void need(long n) {
    char m[128];
    if (n < 0 || pos + n > dlen) {
        snprintf(m, sizeof m, "truncated, need %ld more bytes, have %ld", n, dlen - pos);
        parse_error(m);
    }
}

static unsigned long take32(void) {
    unsigned long v;
    need(4);
    v = ((unsigned long)data[pos] << 24) | ((unsigned long)data[pos + 1] << 16) |
        ((unsigned long)data[pos + 2] << 8) | (unsigned long)data[pos + 3];
    pos += 4;
    return v;
}

static unsigned long take16(void) {
    unsigned long v;
    need(2);
    v = ((unsigned long)data[pos] << 8) | (unsigned long)data[pos + 1];
    pos += 2;
    return v;
}

static unsigned long take8(void) {
    unsigned long v;
    need(1);
    v = data[pos];
    pos += 1;
    return v;
}

static void *xalloc(size_t n) {
    void *p = malloc(n ? n : 1);
    if (!p) {
        fprintf(stderr, "clirhdr: out of memory\n");
        exit(2);
    }
    return p;
}

static unsigned char *slurp(const char *path, long *out) {
    FILE *f = fopen(path, "rb");
    unsigned char *buf;
    long n;
    if (!f) {
        fprintf(stderr, "clirhdr: cannot open %s\n", path);
        exit(2);
    }
    if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0) {
        fprintf(stderr, "clirhdr: cannot size %s\n", path);
        exit(2);
    }
    rewind(f);
    buf = xalloc((size_t)n);
    if (n > 0 && fread(buf, 1, (size_t)n, f) != (size_t)n) {
        fprintf(stderr, "clirhdr: short read on %s\n", path);
        exit(2);
    }
    fclose(f);
    *out = n;
    return buf;
}

static void spew(const char *path, const unsigned char *buf, long n) {
    FILE *f = fopen(path, "wb");
    if (!f) {
        fprintf(stderr, "clirhdr: cannot create %s\n", path);
        exit(2);
    }
    if ((n > 0 && fwrite(buf, 1, (size_t)n, f) != (size_t)n) || fclose(f) != 0) {
        fprintf(stderr, "clirhdr: write failed on %s\n", path);
        exit(2);
    }
}

int main(int argc, char **argv) {
    const char *mode = NULL, *path, *outp = NULL;
    unsigned long version, lane, stamp_len, body_hash, module_count, section_count;
    long stamp_off, body_off, *mod_off, *mod_len, *sec_id, *sec_len, *sec_off;
    unsigned long i;
    char m[160];

    if (argc == 2) {
        path = argv[1];
    } else if (argc == 4 && (!strcmp(argv[1], "--flip-stamp") || !strcmp(argv[1], "--flip-body"))) {
        mode = argv[1];
        path = argv[2];
        outp = argv[3];
    } else {
        fprintf(stderr, "usage: clirhdr FILE | clirhdr --flip-stamp|--flip-body FILE OUT\n");
        return 2;
    }

    data = slurp(path, &dlen);

    need(4);
    if (memcmp(data + pos, "CLIR", 4) != 0) {
        snprintf(m, sizeof m, "bad magic \"%.4s\", want \"CLIR\"", (const char *)data + pos);
        parse_error(m);
    }
    pos += 4;

    version = take32();
    lane = take8();
    stamp_len = take16();
    need((long)stamp_len);
    stamp_off = pos;
    pos += (long)stamp_len;
    body_hash = take32();
    body_off = pos;

    module_count = take16();
    mod_off = xalloc(module_count * sizeof *mod_off);
    mod_len = xalloc(module_count * sizeof *mod_len);
    for (i = 0; i < module_count; i++) {
        mod_len[i] = (long)take8();
        need(mod_len[i]);
        mod_off[i] = pos;
        pos += mod_len[i];
    }

    section_count = take16();
    sec_id = xalloc(section_count * sizeof *sec_id);
    sec_len = xalloc(section_count * sizeof *sec_len);
    sec_off = xalloc(section_count * sizeof *sec_off);
    for (i = 0; i < section_count; i++) {
        need(6);
        sec_id[i] = (long)take16();
        sec_len[i] = (long)take32();
        need(sec_len[i]);
        sec_off[i] = pos;
        pos += sec_len[i];
    }

    if (pos != dlen) {
        snprintf(m, sizeof m, "%ld trailing bytes after the last section (consumed %ld of %ld)",
                 dlen - pos, pos, dlen);
        parse_error(m);
    }

    if (mode) {
        long at;
        if (!strcmp(mode, "--flip-stamp")) {
            if (stamp_len == 0) {
                fprintf(stderr, "clirhdr: empty stamp, cannot corrupt\n");
                return 1;
            }
            at = stamp_off;
        } else {
            if (body_off >= dlen) {
                fprintf(stderr, "clirhdr: empty body, cannot corrupt\n");
                return 1;
            }
            at = body_off;
        }
        data[at] ^= 0xFF;
        spew(outp, data, dlen);
        return 0;
    }

    printf("version=%lu lane=", version);
    if (lane == 0)      printf("68k");
    else if (lane == 1) printf("c");
    else                printf("%lu", lane);
    printf(" stamp=");
    for (i = 0; i < stamp_len; i++) printf("%02x", data[stamp_off + (long)i]);
    printf(" bodyhash=%08lx modules=%lu sections=%lu body_off=%ld\n",
           body_hash, module_count, section_count, body_off);
    for (i = 0; i < module_count; i++)
        printf("module %.*s\n", (int)mod_len[i], (const char *)data + mod_off[i]);
    for (i = 0; i < section_count; i++)
        printf("section %ld %ld %ld\n", sec_id[i], sec_len[i], sec_off[i]);
    return 0;
}
