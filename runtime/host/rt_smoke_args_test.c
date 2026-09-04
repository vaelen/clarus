
#include "rt.h"
#include <stdio.h>
#include <string.h>
int main(void) {
    char *fake_argv[] = {"prog", "alpha", "beta"};
    rt_args_init(3, fake_argv);
    rt_list *args = rt_args_list();
    if (rt_list_count(args) != 2) { printf("args count FAIL\n"); return 1; }
    uint8_t elem[256];
    memmove(elem, rt_list_at(args, 0), 256);
    if (elem[0] != 5 || memcmp(elem + 1, "alpha", 5) != 0) { printf("args[0] FAIL\n"); return 1; }
    memmove(elem, rt_list_at(args, 1), 256);
    if (elem[0] != 4 || memcmp(elem + 1, "beta", 4) != 0) { printf("args[1] FAIL\n"); return 1; }
    if (rt_args_list() != args) { printf("args memo FAIL\n"); return 1; } /* built once */
    printf("OK\n");
    return 0;
}
