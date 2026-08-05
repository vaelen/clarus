/* runtime/host/rt_ser.inc -- shared-source big-endian record
 * serializer (Task 1, mac-target-4d). #included at the BOTTOM of both
 * runtimes' .c files (host rt.c; Mac rt_mac.c) -- never a separate
 * translation unit. Uses ONLY the public rt.h API (rt_text_*, rt_list_*,
 * rt_map_*, rt_file_read_text, rt_set_lasterr) plus one primitive each
 * runtime defines BEFORE this include:
 *   static int rt_file_write_data(const uint8_t *path, const rt_text *t);
 * Never touches rt_text/rt_list/rt_map struct internals -- those differ
 * (malloc'd pointer vs. Handle) between the two runtimes.
 *
 * File format, byte-exact on both platforms because every byte is written
 * one at a time through this shared code:
 *   'C' 'L' 'R' 'S', version byte 1, container byte, then the payload.
 *   REC:  fields in layout order --
 *         INT/FIXED/ENUM: 4 bytes big-endian; BOOL/CHAR: 1 byte (BOOL's
 *         emitted C field is uint8_t, small-scalar-width phase, 2026-08-05
 *         -- one byte at the field's base address, endian-neutral, both on
 *         disk and in memory);
 *         STR: 1 length byte + strCap data bytes (zero-padded).
 *   LIST: 4-byte BE count, then that many records.
 *   MAP:  4-byte BE count, then (1 length byte + key bytes + record)
 *         entries in natural (ascending) key order.
 * Any load failure -> rt_set_lasterr(2, "bad file format"), return 0;
 * LIST/MAP targets are cleared before the read is attempted and re-cleared
 * on any failure, so they always end up empty rather than half-filled; a
 * REC target is only touched once the header has validated, so a header
 * failure leaves it untouched (a body-field failure may have already
 * written the fields preceding the bad one).
 */

#define RT_SER_MAGIC0 'C'
#define RT_SER_MAGIC1 'L'
#define RT_SER_MAGIC2 'R'
#define RT_SER_MAGIC3 'S'
#define RT_SER_VERSION 1

/* ponytail: bounds the scratch record buffer used while iterating list/map
 * elements -- rt_map_val_at and list-load construction are copy-out only
 * (no direct pointer into storage), so a fixed record-sized stack buffer
 * is unavoidable without VLAs (this file must stay C89-friendly for the
 * Mac cross-compiler). 2KB covers every record shape this phase defines
 * with wide margin; if a future record type needs more, raise this.
 */
#define RT_SER_MAX_REC 2048

/* ==================== write ==================== */

static void ser_put_i32(rt_text *out, int32_t v)
{
    rt_text_append_char(out, (uint8_t)((v >> 24) & 0xFF));
    rt_text_append_char(out, (uint8_t)((v >> 16) & 0xFF));
    rt_text_append_char(out, (uint8_t)((v >> 8) & 0xFF));
    rt_text_append_char(out, (uint8_t)(v & 0xFF));
}

static void ser_put_field(rt_text *out, const uint8_t *rec, const rt_field_desc *fd)
{
    const uint8_t *p;
    int32_t i;
    p = rec + fd->offset;
    switch (fd->ftype) {
    case RT_FT_INT:
    case RT_FT_FIXED:
    case RT_FT_ENUM: {
        int32_t v;
        v = *(const int32_t *)p;
        ser_put_i32(out, v);
        break;
    }
    case RT_FT_BOOL:
        /* bool's emitted C field type is uint8_t (small-scalar-width phase)
           -- one byte at the field's base address, endian-neutral. */
        rt_text_append_char(out, (uint8_t)(*p != 0 ? 1 : 0));
        break;
    case RT_FT_CHAR:
        rt_text_append_char(out, *p);
        break;
    case RT_FT_STR:
        rt_text_append_char(out, p[0]);
        for (i = 0; i < fd->strCap; i++) {
            rt_text_append_char(out, (i < p[0]) ? p[1 + i] : 0);
        }
        break;
    }
}

static void ser_put_rec(rt_text *out, const uint8_t *rec, const rt_layout_desc *ld)
{
    int i;
    for (i = 0; i < ld->nFields; i++) {
        ser_put_field(out, rec, &ld->fields[i]);
    }
}

int rt_file_save(const uint8_t *path, short container, const void *data, const rt_layout_desc *ld)
{
    rt_text *out;
    int ok;

    if (ld->recSize > RT_SER_MAX_REC) rt_panic("record too large for serializer");

    out = rt_text_new();
    rt_text_append_char(out, RT_SER_MAGIC0);
    rt_text_append_char(out, RT_SER_MAGIC1);
    rt_text_append_char(out, RT_SER_MAGIC2);
    rt_text_append_char(out, RT_SER_MAGIC3);
    rt_text_append_char(out, RT_SER_VERSION);
    rt_text_append_char(out, (uint8_t)container);

    if (container == RT_SER_REC) {
        ser_put_rec(out, (const uint8_t *)data, ld);
    } else if (container == RT_SER_LIST) {
        rt_list *l;
        int32_t count, i;
        uint8_t tmp[RT_SER_MAX_REC];
        l = (rt_list *)data;
        count = rt_list_count(l);
        ser_put_i32(out, count);
        for (i = 0; i < count; i++) {
            /* Copy out to a stack tmp BEFORE ser_put_rec, same as the MAP
               branch below -- ser_put_rec calls rt_text_append_char in a
               loop, each of which can grow `out`'s storage. On the Handle-
               backed core (4e) that growth is a Memory Manager call, and on
               real hardware the Memory Manager may compact/relocate ANY
               other unlocked handle -- including l's own data handle -- on
               ANY allocation, not just one affecting l. Holding the raw
               rt_list_at pointer across those calls (the previous code)
               reads through a handle that can have moved out from under it
               partway through the record; the host's CLARUS_MEM_PARANOID
               shim (which relocates every unlocked handle on every resize)
               catches exactly this and was how it was found. */
            memmove(tmp, rt_list_at(l, i), (size_t)ld->recSize);
            ser_put_rec(out, tmp, ld);
        }
    } else { /* RT_SER_MAP */
        rt_map *m;
        int32_t count, i;
        uint8_t key255[256];
        uint8_t tmp[RT_SER_MAX_REC];
        m = (rt_map *)data;
        count = rt_map_count(m);
        ser_put_i32(out, count);
        for (i = 0; i < count; i++) {
            rt_map_key_at(m, i, key255);
            /* rt_text_append_str only appends the DATA bytes (key255[0] of
               them), not the length prefix -- write that byte ourselves so
               the file gets the documented "1 len byte + key bytes". */
            rt_text_append_char(out, key255[0]);
            rt_text_append_str(out, key255);
            rt_map_val_at(m, i, tmp);
            ser_put_rec(out, tmp, ld);
        }
    }

    ok = rt_file_write_data(path, out);
    rt_text_free(out);
    return ok;
}

/* ==================== read ==================== */

typedef struct { const rt_text *t; int32_t pos; int bad; } ser_reader;

static uint8_t ser_get_byte(ser_reader *r)
{
    if (r->bad || r->pos >= rt_text_len(r->t)) {
        r->bad = 1;
        return 0;
    }
    return rt_text_index(r->t, r->pos++);
}

static int32_t ser_get_i32(ser_reader *r)
{
    uint8_t b0, b1, b2, b3;
    b0 = ser_get_byte(r);
    b1 = ser_get_byte(r);
    b2 = ser_get_byte(r);
    b3 = ser_get_byte(r);
    return ((int32_t)b0 << 24) | ((int32_t)b1 << 16) | ((int32_t)b2 << 8) | (int32_t)b3;
}

static void ser_get_field(ser_reader *r, uint8_t *rec, const rt_field_desc *fd)
{
    uint8_t *p;
    p = rec + fd->offset;
    switch (fd->ftype) {
    case RT_FT_INT:
    case RT_FT_FIXED: {
        int32_t v;
        v = ser_get_i32(r);
        if (!r->bad) memmove(p, &v, sizeof(int32_t));
        break;
    }
    case RT_FT_ENUM: {
        int32_t v;
        int i, ok;
        v = ser_get_i32(r);
        if (r->bad) break;
        ok = 0;
        for (i = 0; i < fd->enumCount; i++) {
            if (fd->enumValues[i] == v) { ok = 1; break; }
        }
        if (!ok) { r->bad = 1; break; }
        memmove(p, &v, sizeof(int32_t));
        break;
    }
    case RT_FT_BOOL: {
        uint8_t b;
        b = ser_get_byte(r);
        if (!r->bad) *p = (uint8_t)(b != 0 ? 1 : 0);
        break;
    }
    case RT_FT_CHAR: {
        uint8_t v;
        v = ser_get_byte(r);
        if (!r->bad) *p = v;
        break;
    }
    case RT_FT_STR: {
        int32_t slen;
        int i;
        slen = ser_get_byte(r);
        if (r->bad) break;
        if (slen > fd->strCap) { r->bad = 1; break; }
        for (i = 0; i < fd->strCap; i++) {
            uint8_t c;
            c = ser_get_byte(r);
            if (!r->bad) p[1 + i] = c;
        }
        if (!r->bad) p[0] = (uint8_t)slen;
        break;
    }
    }
}

static void ser_get_rec(ser_reader *r, uint8_t *rec, const rt_layout_desc *ld)
{
    int i;
    for (i = 0; i < ld->nFields; i++) {
        ser_get_field(r, rec, &ld->fields[i]);
        if (r->bad) return;
    }
}

int rt_file_load(const uint8_t *path, short container, void *data, const rt_layout_desc *ld)
{
    rt_text *in;
    ser_reader r;
    uint8_t b0, b1, b2, b3, cbyte;

    if (ld->recSize > RT_SER_MAX_REC) rt_panic("record too large for serializer");

    /* Cleared before anything else is attempted, so any failure below
       (including "could not open file") leaves an empty collection. */
    if (container == RT_SER_LIST) rt_list_clear((rt_list *)data);
    else if (container == RT_SER_MAP) rt_map_clear((rt_map *)data);

    in = rt_text_new();
    if (!rt_file_read_text(path, in)) { rt_text_free(in); return 0; } /* rt_file_read_text already set lastError */

    r.t = in;
    r.pos = 0;
    r.bad = 0;

    b0 = ser_get_byte(&r);
    b1 = ser_get_byte(&r);
    b2 = ser_get_byte(&r);
    b3 = ser_get_byte(&r);
    if (r.bad || b0 != RT_SER_MAGIC0 || b1 != RT_SER_MAGIC1 || b2 != RT_SER_MAGIC2 || b3 != RT_SER_MAGIC3) goto fail;
    if (ser_get_byte(&r) != RT_SER_VERSION || r.bad) goto fail;
    cbyte = ser_get_byte(&r);
    if (r.bad || cbyte != (uint8_t)container) goto fail;

    if (container == RT_SER_REC) {
        ser_get_rec(&r, (uint8_t *)data, ld);
    } else if (container == RT_SER_LIST) {
        int32_t count, i;
        uint8_t tmp[RT_SER_MAX_REC];
        count = ser_get_i32(&r);
        for (i = 0; i < count && !r.bad; i++) {
            memset(tmp, 0, (size_t)ld->recSize); /* no stack garbage in unused struct padding */
            ser_get_rec(&r, tmp, ld);
            if (!r.bad) rt_list_push((rt_list *)data, tmp);
        }
    } else { /* RT_SER_MAP */
        int32_t count, i;
        uint8_t tmp[RT_SER_MAX_REC];
        count = ser_get_i32(&r);
        for (i = 0; i < count && !r.bad; i++) {
            uint8_t key255[256];
            int32_t klen, j;
            klen = ser_get_byte(&r);
            if (r.bad || klen > 255) { r.bad = 1; break; }
            key255[0] = (uint8_t)klen;
            for (j = 0; j < klen; j++) {
                key255[1 + j] = ser_get_byte(&r);
            }
            if (r.bad) break;
            memset(tmp, 0, (size_t)ld->recSize); /* no stack garbage in unused struct padding */
            ser_get_rec(&r, tmp, ld);
            if (!r.bad) rt_map_set((rt_map *)data, key255, tmp);
        }
    }

    if (r.bad || r.pos != rt_text_len(in)) goto fail; /* trailing bytes, or an earlier failure */
    rt_text_free(in);
    return 1;

fail:
    rt_text_free(in); /* r.t aliases in; free in exactly once, not r.t too */
    if (container == RT_SER_LIST) rt_list_clear((rt_list *)data);
    else if (container == RT_SER_MAP) rt_map_clear((rt_map *)data);
    rt_set_lasterr(2, "bad file format");
    return 0;
}
