/* Copyright 2026, Andrew C. Young <andrew@vaelen.org>
 * SPDX-License-Identifier: MIT
 *
 * resfork.c -- an INDEPENDENT MacBinary + resource-fork reader for the
 * test harness (go-retirement phase, Task 7). Port of
 * internal/cg68k/image_test.go's crc16Xmodem/parseResourceFork and
 * internal/mactest/resparity_test.go's resparParseFork; the same format
 * Retro68's ResourceFork.cc::Resources(istream&) reads. Deliberately NOT
 * derived from clarusc/app68k.cla's writer -- it exists to disagree with
 * it when the writer is wrong. libc only; no compiler code linked.
 *
 * Usage:
 *   resfork header FILE           MacBinary header fields, one line
 *   resfork list FILE             TYPE ID "NAME" OFFSET LEN per resource
 *   resfork get FILE TYPE ID OUT  extract one resource's raw data
 *   resfork code0 FILE            CODE 0's A5 world + jump table
 *   resfork size FILE             SIZE(-1)'s 10 bytes as hex
 *
 * Exit 0 on success, 1 with "parse error: reason" on malformed input.
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXRES 4096

typedef unsigned char u8;
typedef unsigned int u32;

struct resource {
    char typ[5];
    int id;         /* signed 16-bit */
    char name[256]; /* "" if unnamed */
    u32 off;        /* offset within the data area */
    u32 len;
    const u8 *data;
};

static u8 *img;
static long imglen;
static const u8 *rfork; /* raw (unpadded) resource fork */
static u32 rforklen;
static u32 data_off, map_off, data_len, map_len;
static struct resource reslist[MAXRES];
static int nres;

static void die(const char *fmt, ...) __attribute__((format(printf, 1, 2), noreturn));
static void die(const char *fmt, ...)
{
    va_list ap;
    fputs("parse error: ", stderr);
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fputc('\n', stderr);
    exit(1);
}

/* --- CRC-16/XMODEM (poly 0x1021, init 0, MSB-first, no final XOR) --- */
static unsigned crc16_xmodem(const u8 *p, size_t n)
{
    unsigned crc = 0;
    size_t i;
    int b;
    for (i = 0; i < n; i++) {
        crc ^= (unsigned)p[i] << 8;
        for (b = 0; b < 8; b++)
            crc = (crc & 0x8000) ? ((crc << 1) ^ 0x1021) & 0xFFFF : (crc << 1) & 0xFFFF;
    }
    return crc & 0xFFFF;
}

static void crc_selftest(void)
{
    unsigned got = crc16_xmodem((const u8 *)"123456789", 9);
    if (got != 0x31C3) {
        fprintf(stderr, "resfork: CRC-16/XMODEM self-test failed: \"123456789\" = %#04x, want 0x31c3\n", got);
        exit(2);
    }
}

/* --- big-endian readers ---------------------------------------------- */
static u32 be16(const u8 *p) { return ((u32)p[0] << 8) | p[1]; }
static u32 be32(const u8 *p) { return ((u32)p[0] << 24) | ((u32)p[1] << 16) | ((u32)p[2] << 8) | p[3]; }

/* at(off, n): rfork+off, having checked n bytes are really there. */
static const u8 *at(u32 off, u32 n)
{
    if (off > rforklen || n > rforklen - off)
        die("resource fork read of %u bytes at offset %u exceeds the fork's %u bytes", n, off, rforklen);
    return rfork + off;
}

static void read_file(const char *path)
{
    FILE *f = fopen(path, "rb");
    long n;
    if (!f)
        die("cannot open %s", path);
    if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0 || fseek(f, 0, SEEK_SET) != 0)
        die("cannot size %s", path);
    img = malloc((size_t)n + 1);
    if (!img)
        die("out of memory reading %s", path);
    if (n > 0 && fread(img, 1, (size_t)n, f) != (size_t)n)
        die("short read on %s", path);
    fclose(f);
    imglen = n;
}

/* --- MacBinary header ------------------------------------------------
 * image_test.go: length >= 128 and a multiple of 128, header[0] == 0,
 * name length in 1..63, the resource fork must fit in the remaining
 * bytes, and every byte past it must be zero padding.
 */
static void parse_macbinary(void)
{
    const u8 *h = img;
    u32 rsrclen;
    long i;
    if (imglen < 128)
        die("image too short: %ld bytes", imglen);
    if (imglen % 128 != 0)
        die("image length %ld is not a multiple of 128", imglen);
    if (h[0] != 0)
        die("header[0] (version byte) = %d, want 0", h[0]);
    if (h[1] == 0 || h[1] > 63)
        die("header[1] (name length) = %d, out of range", h[1]);
    rsrclen = be32(h + 87);
    if ((long)rsrclen > imglen - 128)
        die("resource fork length %u exceeds remaining image bytes %ld", rsrclen, imglen - 128);
    for (i = 128 + (long)rsrclen; i < imglen; i++)
        if (img[i] != 0)
            die("non-zero padding byte at image offset %ld", i);
    rfork = img + 128;
    rforklen = rsrclen;
}

/* --- resource fork ---------------------------------------------------
 * Walks the real type-list/ref-list/data-offset chain generically, and
 * decodes each entry's name from the name list (Inside Macintosh: the
 * ref-list entry's 2-byte name-offset field is 0xFFFF if unnamed, else an
 * offset from the name list's own start to a Pascal string -- length byte
 * followed by that many bytes).
 */
static void parse_fork(void)
{
    const u8 *m;
    u32 type_off, name_off;
    int num_types, ti, ri, any_named = 0;

    if (rforklen < 16)
        die("resource fork too short: %u bytes", rforklen);
    data_off = be32(at(0, 4));
    map_off = be32(at(4, 4));
    data_len = be32(at(8, 4));
    map_len = be32(at(12, 4));

    if (data_off != 256)
        die("resource fork data offset = %u, want 256", data_off);
    if (map_off != data_off + data_len)
        die("resource fork map offset = %u, want dataOffset+dataLength = %u", map_off, data_off + data_len);
    if (map_off + map_len != rforklen)
        die("resource fork map end (%u) != fork length (%u)", map_off + map_len, rforklen);

    m = at(map_off, 30); /* also proves the map is >= 30 bytes */
    type_off = be16(m + 24);
    name_off = be16(m + 26);
    num_types = (int)be16(at(map_off + type_off, 2)) + 1;

    for (ti = 0; ti < num_types; ti++) {
        const u8 *th = at(map_off + type_off + 2 + (u32)ti * 8, 8);
        u32 ref_off = be16(th + 6);
        int count = (int)be16(th + 4) + 1;
        for (ri = 0; ri < count; ri++) {
            const u8 *re = at(map_off + type_off + ref_off + (u32)ri * 12, 12);
            u32 noff = be16(re + 2);
            u32 packed = be32(re + 4);
            u32 attr = packed >> 24;
            u32 off = packed & 0x00FFFFFF;
            struct resource *r;
            if (nres == MAXRES)
                die("more than %d resources", MAXRES);
            r = &reslist[nres++];
            memcpy(r->typ, th, 4);
            r->typ[4] = '\0';
            r->id = (int)(short)(unsigned short)be16(re);
            r->name[0] = '\0';
            if (noff != 0xFFFF) {
                u32 nlen = *at(map_off + name_off + noff, 1);
                any_named = 1;
                memcpy(r->name, at(map_off + name_off + noff + 1, nlen), nlen);
                r->name[nlen] = '\0';
            }
            if (attr != 0)
                die("resource %s %d: attr byte = %#x, want 0", r->typ, r->id, attr);
            r->off = off;
            r->len = be32(at(data_off + off, 4));
            r->data = at(data_off + off + 4, r->len);
        }
    }
    /* With no --bake flag no resource is ever named -- the name list stays
     * empty and sits right at the map's own end. */
    if (!any_named && name_off != map_len)
        die("resource map name list offset = %u, want %u (map length -- no names, so the name list is empty and sits right at the end)",
            name_off, map_len);
}

static struct resource *find_one(const char *typ, int id)
{
    struct resource *found = NULL;
    int i, n = 0;
    for (i = 0; i < nres; i++)
        if (strcmp(reslist[i].typ, typ) == 0 && reslist[i].id == id) {
            found = &reslist[i];
            n++;
        }
    if (n == 0)
        die("resource %s %d not found", typ, id);
    if (n > 1)
        die("resource %s %d found %d times, want 1", typ, id, n);
    return found;
}

/* --- commands -------------------------------------------------------- */

static void cmd_header(void)
{
    const u8 *h = img;
    char name[64];
    unsigned want_crc = crc16_xmodem(h, 124);
    unsigned got_crc = (unsigned)be16(h + 124);
    memcpy(name, h + 2, h[1]);
    name[h[1]] = '\0';
    printf("name=%s type=%.4s creator=%.4s datalen=%u rsrclen=%u ver=%d/%d crc=%s dates=%s\n",
           name, (const char *)h + 65, (const char *)h + 69, be32(h + 83), be32(h + 87),
           h[122], h[123], got_crc == want_crc ? "ok" : "bad",
           (be32(h + 91) == 0 && be32(h + 95) == 0) ? "0" : "nonzero");
}

static void cmd_list(void)
{
    int i;
    for (i = 0; i < nres; i++)
        printf("%s %d \"%s\" %u %u\n", reslist[i].typ, reslist[i].id,
               reslist[i].name[0] ? reslist[i].name : "-", reslist[i].off, reslist[i].len);
}

static void cmd_get(const char *typ, const char *ids, const char *out)
{
    struct resource *r = find_one(typ, atoi(ids));
    FILE *f = fopen(out, "wb");
    if (!f)
        die("cannot create %s", out);
    if (r->len > 0 && fwrite(r->data, 1, r->len, f) != r->len)
        die("short write on %s", out);
    if (fclose(f) != 0)
        die("cannot close %s", out);
}

/* cmd_code0 prints CODE 0's A5-world header then one line per jump-table
 * slot. A slot line gets " BAD" appended when its filler word isn't
 * 0x3F3C, its trailer word isn't 0xA9F0, its owning segment has no CODE
 * resource, or its offset falls outside that segment's own code range
 * (len-4: _LoadSeg skips the segment's own 4-byte header itself, so
 * nothing may be added to the entry's offset field). */
static void cmd_code0(void)
{
    struct resource *c0 = find_one("CODE", 0);
    u32 jt_len, jt_off;
    int n, i, j;
    if (c0->len < 16)
        die("CODE 0 length = %u, too short for its 16-byte header", c0->len);
    jt_len = be32(c0->data + 8);
    jt_off = be32(c0->data + 12);
    if (jt_len % 8 != 0)
        die("CODE 0 JT length = %u, not a multiple of 8", jt_len);
    n = (int)(jt_len / 8);
    if (n == 0)
        die("CODE 0 has no jump-table entries");
    /* Written as a subtraction on the KNOWN-larger side: `16 + jt_len`
     * wraps in u32, so a jt_len near UINT_MAX would pass that form and the
     * loop below would read past the buffer. c0->len >= 16 above. */
    if (jt_len > c0->len - 16)
        die("CODE 0 length %u cannot hold a %u-byte jump table at offset 16", c0->len, jt_len);
    printf("above_a5=%u below_a5=%u jt_size=%u jt_off=%u\n",
           be32(c0->data), be32(c0->data + 4), jt_len, jt_off);
    for (i = 0; i < n; i++) {
        const u8 *e = c0->data + 16 + i * 8;
        u32 off = be16(e), filler = be16(e + 2), trailer = be16(e + 6);
        int seg = (int)(short)(unsigned short)be16(e + 4);
        int bad = (filler != 0x3F3C) || (trailer != 0xA9F0);
        struct resource *sr = NULL;
        for (j = 0; j < nres; j++)
            if (strcmp(reslist[j].typ, "CODE") == 0 && reslist[j].id == seg)
                sr = &reslist[j];
        if (!sr || sr->len < 4 || off > sr->len - 4)
            bad = 1;
        printf("slot %d %u filler=%04X trailer=%04X%s\n", seg, off, filler, trailer, bad ? " BAD" : "");
    }
}

static void cmd_size(void)
{
    struct resource *r = find_one("SIZE", -1);
    u32 i;
    if (r->len != 10)
        die("SIZE resource length = %u, want 10", r->len);
    for (i = 0; i < r->len; i++)
        printf("%02x", r->data[i]);
    putchar('\n');
}

int main(int argc, char **argv)
{
    const char *cmd;
    crc_selftest();
    if (argc < 3) {
        fprintf(stderr, "usage: resfork header|list|code0|size FILE\n"
                        "       resfork get FILE TYPE ID OUT\n");
        return 2;
    }
    cmd = argv[1];
    read_file(argv[2]);
    parse_macbinary();
    if (strcmp(cmd, "header") == 0) {
        cmd_header();
        return 0;
    }
    parse_fork();
    if (strcmp(cmd, "list") == 0)
        cmd_list();
    else if (strcmp(cmd, "code0") == 0)
        cmd_code0();
    else if (strcmp(cmd, "size") == 0)
        cmd_size();
    else if (strcmp(cmd, "get") == 0) {
        if (argc != 6)
            die("get needs FILE TYPE ID OUT");
        cmd_get(argv[3], argv[4], argv[5]);
    } else
        die("unknown command %s", cmd);
    return 0;
}
