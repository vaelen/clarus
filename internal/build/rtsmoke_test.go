// internal/build/rtsmoke_test.go
package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

const smokeMain = `
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
`

const smokeCollectionsMain = `
#include "rt.h"
#include <stdio.h>
int main(void) {
    /* list of int32 */
    rt_list *l = rt_list_new(sizeof(int32_t));
    int32_t v;
    for (v = 1; v <= 3; v++) rt_list_push(l, &v);
    if (rt_list_count(l) != 3) { printf("list count FAIL\n"); return 1; }
    int32_t popped;
    rt_list_pop(l, &popped);
    if (popped != 3) { printf("list pop FAIL\n"); return 1; }
    if (rt_list_count(l) != 2) { printf("list count2 FAIL\n"); return 1; }

    /* map string -> int32 */
    rt_map *m = rt_map_new(sizeof(int32_t));
    struct { uint8_t len; uint8_t b[255]; } k1 = {3, {'f','o','o'}};
    struct { uint8_t len; uint8_t b[255]; } k2 = {3, {'b','a','r'}};
    int32_t val = 10;
    rt_map_set(m, (uint8_t*)&k1, &val);
    val = 20;
    rt_map_set(m, (uint8_t*)&k2, &val);
    if (rt_map_count(m) != 2) { printf("map count FAIL\n"); return 1; }
    int32_t got = 0;
    if (!rt_map_get_dv(m, (uint8_t*)&k1, &got) || got != 10) { printf("map getdv FAIL\n"); return 1; }
    int32_t missing = -1;
    if (rt_map_get_dv(m, (uint8_t*)"\x03""baz", &missing) || missing != -1) { printf("map getdv default FAIL\n"); return 1; }
    uint8_t key255[256];
    rt_map_key_at(m, 0, key255);
    if (key255[0] != 3 || key255[1] != 'f') { printf("map key_at order FAIL\n"); return 1; }
    rt_map_key_at(m, 1, key255);
    if (key255[0] != 3 || key255[1] != 'b') { printf("map key_at order2 FAIL\n"); return 1; }

    /* text */
    rt_text *t = rt_text_new();
    rt_text_store(t, (uint8_t*)&k1); /* "foo" */
    rt_text *t2 = rt_text_new();
    rt_text_store(t2, (uint8_t*)&k2); /* "bar" */
    rt_text_concat(t, t, NULL, t2); /* "foobar" */
    if (rt_text_len(t) != 6) { printf("text concat len FAIL\n"); return 1; }
    if (rt_text_index(t, 3) != 'b') { printf("text index FAIL\n"); return 1; }
    if (rt_text_cmp_str(t, (uint8_t*)"\x06""foobar") != 0) { printf("text cmp FAIL\n"); return 1; }

    /* list and map of 16-byte struct */
    typedef struct { int64_t a; int64_t b; } pair16;
    rt_list *pl = rt_list_new(sizeof(pair16));
    pair16 p1 = {111, 222}, p2 = {333, 444}, po;
    rt_list_push(pl, &p1);
    rt_list_push(pl, &p2);
    rt_list_remove(pl, 0);
    rt_list_first(pl, &po);
    if (po.a != 333 || po.b != 444) { printf("pair16 list FAIL\n"); return 1; }
    rt_map *pm = rt_map_new(sizeof(pair16));
    rt_map_set(pm, (const uint8_t*)"\001k", &p1);
    rt_map_set(pm, (const uint8_t*)"\001k", &p2);   /* overwrite */
    if (rt_map_count(pm) != 1) { printf("pair16 map count FAIL\n"); return 1; }
    rt_map_get(pm, (const uint8_t*)"\001k", &po);
    if (po.a != 333) { printf("pair16 map FAIL\n"); return 1; }

    printf("OK\n");
    return 0;
}
`

func TestRuntimeSmokeCollections(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeCollectionsMain), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", main, "rt/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	out, err := exec.Command(exe).CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, out)
	}
	if string(out) != "OK\n" {
		t.Fatalf("output: %q", out)
	}
}

func cc() string { return CCPath() }

func TestRuntimeSmokeStrings(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeMain), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", main, "rt/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	out, err := exec.Command(exe).CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, out)
	}
	if string(out) != "hello\nOK\n" {
		t.Fatalf("output: %q", out)
	}
}
