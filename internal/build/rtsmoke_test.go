// internal/build/rtsmoke_test.go
package build

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
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
    /* iteration is ascending key order: "bar" < "foo" even though "foo" was inserted first */
    uint8_t key255[256];
    rt_map_key_at(m, 0, key255);
    if (key255[0] != 3 || key255[1] != 'b') { printf("map key_at sorted FAIL\n"); return 1; }
    rt_map_key_at(m, 1, key255);
    if (key255[0] != 3 || key255[1] != 'f') { printf("map key_at sorted2 FAIL\n"); return 1; }

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

const smokeSliceIndexAppendMain = `
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
`

func TestRuntimeSmokeSliceIndexAppend(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeSliceIndexAppendMain), 0o644); err != nil {
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

// TestRuntimeSmokeSliceOutOfRange covers the strict-bounds panic for a
// string slice whose start+len exceeds the source length (Ch3: "slice out
// of range").
func TestRuntimeSmokeSliceOutOfRange(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	src := `
#include "rt.h"
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } hello = {5, {'h','e','l','l','o'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_slice((uint8_t*)&out, (uint8_t*)&hello, 3, 5); /* start+len=8 > length 5 */
    return 0;
}
`
	if err := os.WriteFile(main, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", main, "rt/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	var stderr bytes.Buffer
	run := exec.Command(exe)
	run.Stderr = &stderr
	err := run.Run()
	ee, ok := err.(*exec.ExitError)
	if !ok || ee.ExitCode() != 3 {
		t.Fatalf("want exit 3, got %v (stderr=%q)", err, stderr.String())
	}
	if !strings.Contains(stderr.String(), "slice out of range") {
		t.Fatalf("stderr = %q, want it to mention slice out of range", stderr.String())
	}
}

// TestRuntimeSmokeTextSliceLenTooLong covers the len>255 half of the
// strict-bounds check, which only bites text (unbounded, so start+len can
// stay within the source while len alone still exceeds what a str255 result
// can hold).
func TestRuntimeSmokeTextSliceLenTooLong(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	src := `
#include "rt.h"
int main(void) {
    rt_text *t = rt_text_new();
    for (int i = 0; i < 300; i++) rt_text_append_char(t, 'a');
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_text_slice((uint8_t*)&out, t, 0, 260); /* within t's length but len>255 */
    return 0;
}
`
	if err := os.WriteFile(main, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", main, "rt/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	var stderr bytes.Buffer
	run := exec.Command(exe)
	run.Stderr = &stderr
	err := run.Run()
	ee, ok := err.(*exec.ExitError)
	if !ok || ee.ExitCode() != 3 {
		t.Fatalf("want exit 3, got %v (stderr=%q)", err, stderr.String())
	}
	if !strings.Contains(stderr.String(), "slice out of range") {
		t.Fatalf("stderr = %q, want it to mention slice out of range", stderr.String())
	}
}

const smokeLogMain = `
#include "rt.h"
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } msg = {6, {'h','i',13,'y','o','u'}}; /* embedded CR */
    rt_log((uint8_t*)&msg);
    return 0;
}
`

// TestRuntimeSmokeLog captures stderr separately from stdout: rt_log writes
// to stderr with a trailing newline, rendering embedded CR bytes as LF
// (mirroring rt_alert's stdout behavior, per Ch12).
func TestRuntimeSmokeLog(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeLogMain), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", main, "rt/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	var stdout, stderr bytes.Buffer
	run := exec.Command(exe)
	run.Stdout = &stdout
	run.Stderr = &stderr
	if err := run.Run(); err != nil {
		t.Fatalf("run: %v\nstderr=%s", err, stderr.String())
	}
	if stdout.Len() != 0 {
		t.Fatalf("unexpected stdout: %q", stdout.String())
	}
	if stderr.String() != "hi\nyou\n" {
		t.Fatalf("stderr = %q, want %q", stderr.String(), "hi\nyou\n")
	}
}

const smokeArgsMain = `
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
`

func TestRuntimeSmokeArgs(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeArgsMain), 0o644); err != nil {
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
