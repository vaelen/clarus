/* runtime/host/rt_ser_test.c -- hand-written C harness for the
 * record serializer (Task 1, mac-target-4d): rt_file_save/load, REC/LIST/
 * MAP containers, and the documented failure modes (short read, bad magic,
 * bad enum value). Compiled + run host-side by sertest_c_test.go in a temp
 * cwd, so every path here is relative (no test-only cwd assumptions leak
 * into rt_ser.inc itself).
 *
 * Test record layout (declaration order matters -- it IS the file order):
 *   a:     RT_FT_INT    int32
 *   f:     RT_FT_FIXED  int32 (raw 16.16 representation)
 *   flag:  RT_FT_BOOL   uint8_t in memory (cprint.cla's emitted C type for
 *          `bool` as a record field, small-scalar-width phase, 2026-08-05),
 *          1 byte on disk -- same width both places now, no endianness.
 *   ch:    RT_FT_CHAR   1 byte (genuinely uint8_t, cprint.cla)
 *   name:  RT_FT_STR    strCap=8 (1 len byte + 8 data bytes)
 *   color: RT_FT_ENUM   int32, members {0,1,2}
 */
#include "rt.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

typedef struct {
    int32_t a;
    int32_t f;
    uint8_t flag;
    uint8_t ch;
    uint8_t name[1 + 8];
    int32_t color;
} test_rec;

static const int32_t colorVals[3] = { 0, 1, 2 };

static const rt_field_desc test_fields[] = {
    { RT_FT_INT,   0, (long)offsetof(test_rec, a),     0, NULL,      NULL },
    { RT_FT_FIXED, 0, (long)offsetof(test_rec, f),     0, NULL,      NULL },
    { RT_FT_BOOL,  0, (long)offsetof(test_rec, flag),  0, NULL,      NULL },
    { RT_FT_CHAR,  0, (long)offsetof(test_rec, ch),    0, NULL,      NULL },
    { RT_FT_STR,   8, (long)offsetof(test_rec, name),  0, NULL,      NULL },
    { RT_FT_ENUM,  0, (long)offsetof(test_rec, color), 3, colorVals, NULL },
};
static const rt_layout_desc test_layout = { sizeof(test_rec), 6, test_fields };

/* Expected bytes for the record built by mkrec1() below, per the format:
 * header (CLRS, version 1, container REC=0), then fields in order. */
static const uint8_t rec1_expected[] = {
    'C','L','R','S', 1, 0,                       /* header */
    0x01, 0x02, 0x03, 0x04,                       /* a */
    0x00, 0x01, 0x80, 0x00,                       /* f (1.5 in 16.16) */
    0x01,                                          /* flag = true */
    0x58,                                          /* ch = 'X' */
    0x02, 'H', 'i', 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* name = "Hi", strCap 8 */
    0x00, 0x00, 0x00, 0x01,                       /* color = 1 (green) */
};

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

static void mkpath(uint8_t *out255, const char *s) {
    size_t n = strlen(s);
    out255[0] = (uint8_t)n;
    memcpy(out255 + 1, s, n);
}

static test_rec mkrec1(void) {
    test_rec r;
    memset(&r, 0, sizeof(r));
    r.a = 0x01020304;
    r.f = 0x00018000; /* 1.5 */
    r.flag = 1;
    r.ch = 'X';
    r.name[0] = 2;
    r.name[1] = 'H';
    r.name[2] = 'i';
    r.color = 1;
    return r;
}

static test_rec mkrec2(void) {
    test_rec r;
    memset(&r, 0, sizeof(r));
    r.a = -7;
    r.f = -65536; /* -1.0 */
    r.flag = 0;
    r.ch = 'Y';
    r.name[0] = 3;
    r.name[1] = 'B';
    r.name[2] = 'y';
    r.name[3] = 'e';
    r.color = 2;
    return r;
}

static void readFile(const char *path, uint8_t **buf, long *len) {
    FILE *f = fopen(path, "rb");
    long sz;
    if (!f) { *buf = NULL; *len = -1; return; }
    fseek(f, 0, SEEK_END);
    sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    *buf = malloc((size_t)sz);
    fread(*buf, 1, (size_t)sz, f);
    fclose(f);
    *len = sz;
}

static void writeFile(const char *path, const uint8_t *buf, long len) {
    FILE *f = fopen(path, "wb");
    fwrite(buf, 1, (size_t)len, f);
    fclose(f);
}

static void test_rec_roundtrip(void) {
    uint8_t path[256];
    test_rec r1, loaded;
    uint8_t *filebuf;
    long filelen;

    mkpath(path, "rec.dat");
    r1 = mkrec1();

    CHECK(rt_file_save(path, RT_SER_REC, &r1, &test_layout), "rec save should succeed");

    readFile("rec.dat", &filebuf, &filelen);
    CHECK(filelen == (long)sizeof(rec1_expected), "rec file length matches expected");
    if (filelen == (long)sizeof(rec1_expected)) {
        CHECK(memcmp(filebuf, rec1_expected, (size_t)filelen) == 0, "rec file bytes match expected hex layout");
    }
    free(filebuf);

    /* zero-init (not e.g. 0xAA): mkrec1() zero-inits too, and struct
       padding bytes (never touched by field-wise load) must match for the
       whole-struct memcmp below to be a meaningful field-by-field check. */
    memset(&loaded, 0, sizeof(loaded));
    CHECK(rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "rec load should succeed");
    CHECK(memcmp(&loaded, &r1, sizeof(test_rec)) == 0, "loaded rec equals saved rec field-by-field");
}

static void test_list_roundtrip(void) {
    uint8_t path[256];
    rt_list *l;
    rt_list *l2;
    test_rec r1, r2, got;

    mkpath(path, "list.dat");
    l = rt_list_new(sizeof(test_rec));
    r1 = mkrec1();
    r2 = mkrec2();
    rt_list_push(l, &r1);
    rt_list_push(l, &r2);

    CHECK(rt_file_save(path, RT_SER_LIST, l, &test_layout), "list save should succeed");

    l2 = rt_list_new(sizeof(test_rec));
    rt_list_push(l2, &r1); /* pre-seed with junk to prove clear-first */
    CHECK(rt_file_load(path, RT_SER_LIST, l2, &test_layout), "list load should succeed");
    CHECK(rt_list_count(l2) == 2, "list load restores exact count");
    if (rt_list_count(l2) == 2) {
        memcpy(&got, rt_list_at(l2, 0), sizeof(test_rec));
        CHECK(memcmp(&got, &r1, sizeof(test_rec)) == 0, "list[0] round-trips");
        memcpy(&got, rt_list_at(l2, 1), sizeof(test_rec));
        CHECK(memcmp(&got, &r2, sizeof(test_rec)) == 0, "list[1] round-trips");
    }

    rt_list_free(l);
    rt_list_free(l2);
}

static void test_map_roundtrip(void) {
    uint8_t path[256];
    rt_map *m;
    rt_map *m2;
    test_rec r1, r2, got;
    uint8_t keyFoo[256], keyBar[256];

    mkpath(path, "map.dat");
    mkpath(keyFoo, "foo");
    mkpath(keyBar, "bar");
    m = rt_map_new(sizeof(test_rec));
    r1 = mkrec1();
    r2 = mkrec2();
    rt_map_set(m, keyFoo, &r1);
    rt_map_set(m, keyBar, &r2);

    CHECK(rt_file_save(path, RT_SER_MAP, m, &test_layout), "map save should succeed");

    m2 = rt_map_new(sizeof(test_rec));
    rt_map_set(m2, keyFoo, &r2); /* pre-seed with junk to prove clear-first */
    CHECK(rt_file_load(path, RT_SER_MAP, m2, &test_layout), "map load should succeed");
    CHECK(rt_map_count(m2) == 2, "map load restores exact count");
    if (rt_map_count(m2)) {
        /* map-hashtable phase Task 5: map is now a hashtable, not sorted --
           save/load preserves insertion order ("foo" then "bar", the order
           `m` was originally built in), not ascending byte-wise order. */
        uint8_t key255[256];
        rt_map_key_at(m2, 0, key255);
        CHECK(key255[0] == 3 && memcmp(key255 + 1, "foo", 3) == 0, "map key order: foo first (insertion order)");
        rt_map_get(m2, keyBar, &got);
        CHECK(memcmp(&got, &r2, sizeof(test_rec)) == 0, "map[bar] round-trips");
        rt_map_get(m2, keyFoo, &got);
        CHECK(memcmp(&got, &r1, sizeof(test_rec)) == 0, "map[foo] round-trips");
    }

    rt_map_free(m);
    rt_map_free(m2);
}

static void test_failure_modes(void) {
    uint8_t path[256];
    test_rec r1, loaded;
    uint8_t *filebuf;
    long filelen;

    mkpath(path, "bad.dat");
    r1 = mkrec1();
    CHECK(rt_file_save(path, RT_SER_REC, &r1, &test_layout), "setup save should succeed");
    readFile("bad.dat", &filebuf, &filelen);

    /* truncated file: chop off the last byte */
    {
        rt_lasterr_code = 0;
        writeFile("trunc.dat", filebuf, filelen - 1);
        mkpath(path, "trunc.dat");
        memset(&loaded, 0, sizeof(loaded));
        CHECK(!rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "truncated file load should fail");
        CHECK(rt_lasterr_code == 2, "truncated file sets lastError code 2");
        CHECK(rt_str_cmp(rt_lasterr_msg, (const uint8_t *)"\x0f""bad file format") == 0, "truncated file lastError message");
    }

    /* bad magic: corrupt the first byte */
    {
        uint8_t *corrupt = malloc((size_t)filelen);
        memcpy(corrupt, filebuf, (size_t)filelen);
        corrupt[0] = 'X';
        rt_lasterr_code = 0;
        writeFile("badmagic.dat", corrupt, filelen);
        mkpath(path, "badmagic.dat");
        memset(&loaded, 0, sizeof(loaded));
        CHECK(!rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "bad magic load should fail");
        CHECK(rt_lasterr_code == 2, "bad magic sets lastError code 2");
        CHECK(rt_str_cmp(rt_lasterr_msg, (const uint8_t *)"\x0f""bad file format") == 0, "bad magic lastError message");
        free(corrupt);
    }

    /* bad enum value: color is the last field (last 4 bytes of the file) */
    {
        uint8_t *corrupt = malloc((size_t)filelen);
        memcpy(corrupt, filebuf, (size_t)filelen);
        corrupt[filelen - 1] = 99; /* not in {0,1,2} */
        rt_lasterr_code = 0;
        writeFile("badenum.dat", corrupt, filelen);
        mkpath(path, "badenum.dat");
        memset(&loaded, 0, sizeof(loaded));
        CHECK(!rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "bad enum value load should fail");
        CHECK(rt_lasterr_code == 2, "bad enum value sets lastError code 2");
        CHECK(rt_str_cmp(rt_lasterr_msg, (const uint8_t *)"\x0f""bad file format") == 0, "bad enum value lastError message");
        free(corrupt);
    }

    free(filebuf);
}

/* str len > strCap: hand-build a file whose STR field's length byte claims
 * more than the declared strCap -- must fail the same way. */
static void test_str_len_overflow(void) {
    uint8_t path[256];
    test_rec loaded;
    uint8_t buf[6 + 4 + 4 + 1 + 1 + 9 + 4];
    int i, off;

    off = 0;
    buf[off++] = 'C'; buf[off++] = 'L'; buf[off++] = 'R'; buf[off++] = 'S';
    buf[off++] = 1; buf[off++] = 0; /* header */
    for (i = 0; i < 4; i++) buf[off++] = 0; /* a */
    for (i = 0; i < 4; i++) buf[off++] = 0; /* f */
    buf[off++] = 0; /* flag */
    buf[off++] = 0; /* ch */
    buf[off++] = 9; /* len byte: claims 9 > strCap 8 */
    for (i = 0; i < 8; i++) buf[off++] = 0; /* strCap data bytes */
    for (i = 0; i < 4; i++) buf[off++] = 0; /* color */

    writeFile("strover.dat", buf, (long)sizeof(buf));
    mkpath(path, "strover.dat");
    rt_lasterr_code = 0;
    memset(&loaded, 0, sizeof(loaded));
    CHECK(!rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "str len > strCap load should fail");
    CHECK(rt_lasterr_code == 2, "str len > strCap sets lastError code 2");
    CHECK(rt_str_cmp(rt_lasterr_msg, (const uint8_t *)"\x0f""bad file format") == 0, "str len > strCap lastError message");
}

/* Historical regression, superseded by the small-scalar-width phase
 * (2026-08-05): bool's emitted C field used to be int32_t, and this test
 * caught an endian bug in reading it (base address == LSB on a little-
 * endian host, masking a wrong-byte read that surfaced only on the big-
 * endian 68k Mac). Now that the field is uint8_t -- one byte, no
 * endianness -- that bug class cannot recur; this test instead pins the
 * two properties that still matter: any nonzero byte canonicalizes to
 * disk byte 1, and a load fully overwrites stale bytes (no leftover
 * garbage). */
static void test_bool_endian(void) {
    uint8_t path[256];
    test_rec r, loaded;
    uint8_t *filebuf;
    long filelen, boolOff;

    mkpath(path, "boolendian.dat");
    r = mkrec1();
    r.flag = 0x42; /* nonzero, not literally 1 */
    CHECK(rt_file_save(path, RT_SER_REC, &r, &test_layout), "bool-endian save should succeed");

    readFile("boolendian.dat", &filebuf, &filelen);
    boolOff = 6 + 4 + 4; /* header(6) + a(4) + f(4) precede flag's 1-byte slot */
    CHECK(filelen > boolOff, "bool-endian file has a flag byte");
    if (filelen > boolOff) {
        CHECK(filebuf[boolOff] == 1, "bool field serializes to canonical byte 1 for any nonzero byte, not just literal 1");
    }
    free(filebuf);

    loaded = mkrec1();
    loaded.flag = 0xFF; /* stale garbage before load */
    CHECK(rt_file_load(path, RT_SER_REC, &loaded, &test_layout), "bool-endian load should succeed");
    CHECK(loaded.flag == 1, "bool field loads to exactly 1 -- no stale garbage byte survives");
}

int main(void) {
    test_rec_roundtrip();
    test_list_roundtrip();
    test_map_roundtrip();
    test_failure_modes();
    test_str_len_overflow();
    test_bool_endian();
    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
