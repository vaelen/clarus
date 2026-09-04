
#include "rt.h"
#include <stdio.h>
#include <string.h>
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } hello = {5, {'h','e','l','l','o'}};
    struct { uint8_t len; uint8_t b[255]; } world11 = {11, {'h','e','l','l','o',' ','w','o','r','l','d'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    struct { uint8_t len; uint8_t b[255]; } needle_lo = {2, {'l','o'}};
    struct { uint8_t len; uint8_t b[255]; } needle_xyz = {3, {'x','y','z'}};
    struct { uint8_t len; uint8_t b[255]; } needle_empty = {0, {0}};

    /* ---- string slice: happy, edge (start+len==length), zero-len ---- */
    rt_str_slice((uint8_t*)&out, (uint8_t*)&world11, 6, 5);
    if (out.len != 5 || memcmp(out.b, "world", 5) != 0) { printf("str slice happy FAIL\n"); return 1; }
    rt_str_slice((uint8_t*)&out, (uint8_t*)&hello, 0, 5);
    if (out.len != 5 || memcmp(out.b, "hello", 5) != 0) { printf("str slice edge FAIL\n"); return 1; }
    rt_str_slice((uint8_t*)&out, (uint8_t*)&hello, 2, 0);
    if (out.len != 0) { printf("str slice zero FAIL\n"); return 1; }

    /* ---- string indexOf: str hit/miss, empty needle, char hit/miss ---- */
    if (rt_str_index_of_str((uint8_t*)&hello, (uint8_t*)&needle_lo) != 3) { printf("str idx str FAIL\n"); return 1; }
    if (rt_str_index_of_str((uint8_t*)&hello, (uint8_t*)&needle_xyz) != -1) { printf("str idx miss FAIL\n"); return 1; }
    if (rt_str_index_of_str((uint8_t*)&hello, (uint8_t*)&needle_empty) != 0) { printf("str idx empty FAIL\n"); return 1; }
    if (rt_str_index_of_char((uint8_t*)&hello, 'l') != 2) { printf("str idx char FAIL\n"); return 1; }
    if (rt_str_index_of_char((uint8_t*)&hello, 'z') != -1) { printf("str idx char miss FAIL\n"); return 1; }

    /* ---- text slice / indexOf, mirroring string ---- */
    rt_text *t = rt_text_new();
    rt_text_store(t, (uint8_t*)&world11); /* "hello world" */
    rt_text_slice((uint8_t*)&out, t, 6, 5);
    if (out.len != 5 || memcmp(out.b, "world", 5) != 0) { printf("text slice happy FAIL\n"); return 1; }
    rt_text_slice((uint8_t*)&out, t, 0, 11);
    if (out.len != 11 || memcmp(out.b, "hello world", 11) != 0) { printf("text slice edge FAIL\n"); return 1; }
    rt_text_slice((uint8_t*)&out, t, 3, 0);
    if (out.len != 0) { printf("text slice zero FAIL\n"); return 1; }
    if (rt_text_index_of_str(t, (uint8_t*)&needle_lo) != 3) { printf("text idx str FAIL\n"); return 1; }
    if (rt_text_index_of_str(t, (uint8_t*)&needle_xyz) != -1) { printf("text idx miss FAIL\n"); return 1; }
    if (rt_text_index_of_str(t, (uint8_t*)&needle_empty) != 0) { printf("text idx empty FAIL\n"); return 1; }
    if (rt_text_index_of_char(t, 'w') != 6) { printf("text idx char FAIL\n"); return 1; }
    if (rt_text_index_of_char(t, 'z') != -1) { printf("text idx char miss FAIL\n"); return 1; }

    /* ---- append: 1000-iteration char loop (amortized growth; must finish instantly), then str/text append ---- */
    rt_text *acc = rt_text_new();
    for (int i = 0; i < 1000; i++) rt_text_append_char(acc, 'x');
    if (rt_text_len(acc) != 1000) { printf("append char loop FAIL\n"); return 1; }
    rt_text_append_str(acc, (uint8_t*)&hello);
    if (rt_text_len(acc) != 1005) { printf("append str FAIL\n"); return 1; }
    rt_text *more = rt_text_new();
    rt_text_store(more, (uint8_t*)&hello);
    rt_text_append_text(acc, more);
    if (rt_text_len(acc) != 1010) { printf("append text FAIL\n"); return 1; }

    /* ---- self-append (doubles; src may alias t) ---- */
    rt_text *self = rt_text_new();
    rt_text_store(self, (uint8_t*)&hello); /* "hello" */
    rt_text_append_text(self, self);
    if (rt_text_len(self) != 10) { printf("self append len FAIL\n"); return 1; }
    uint8_t selfbuf[16] = {0};
    rt_text_to_bytes(self, selfbuf, 16);
    if (memcmp(selfbuf, "hellohello", 10) != 0) { printf("self append content FAIL\n"); return 1; }

    printf("OK\n");
    return 0;
}
