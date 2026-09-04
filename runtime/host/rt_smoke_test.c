
#include "rt.h"
#include <stdio.h>
int main(void) {
    struct { uint8_t len; uint8_t b[3]; } s3 = {0};
    struct { uint8_t len; uint8_t b[255]; } hello = {5, {'h','e','l','l','o'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_concat((uint8_t*)&out, (uint8_t*)&hello, (uint8_t*)&hello);
    if (rt_str_len((uint8_t*)&out) != 10) { printf("concat len FAIL\n"); return 1; }
    rt_str_store((uint8_t*)&s3, 3, (uint8_t*)&hello);        /* clamps to "hel", sets lastError */
    if (s3.len != 3 || rt_lasterr_code == 0) { printf("clamp FAIL\n"); return 1; }
    if (rt_fix_mul(98304, 131072) != 196608) { printf("fixmul FAIL\n"); return 1; } /* 1.5*2.0=3.0 */
    if (rt_fix_div(-65536, 65536) != -65536) { printf("fixdiv neg FAIL\n"); return 1; } /* -1.0/1.0=-1.0 */
    if (rt_str_index((uint8_t*)&hello, 1) != 'e') { printf("index FAIL\n"); return 1; }
    rt_alert((uint8_t*)&hello);
    printf("OK\n");
    return 0;
}
