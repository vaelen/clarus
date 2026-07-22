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
    if (rt_str_index((uint8_t*)&hello, 1) != 'e') { printf("index FAIL\n"); return 1; }
    rt_alert((uint8_t*)&hello);
    printf("OK\n");
    return 0;
}
`

func cc() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}

func TestRuntimeSmokeStrings(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeMain), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
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
