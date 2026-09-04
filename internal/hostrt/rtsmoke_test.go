// internal/hostrt/rtsmoke_test.go
package hostrt

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// smokeSrc reads one of the C smoke mains. They used to be Go string
// constants in this file; go-retirement Task 2 moved them to
// runtime/host/rt_smoke*_test.c so this test and tests/hostrt/*.sh compile
// one shared copy.
func smokeSrc(t *testing.T, name string) []byte {
	t.Helper()
	data, err := os.ReadFile(filepath.Join("..", "..", "runtime", "host", name))
	if err != nil {
		t.Fatalf("read %s: %v", name, err)
	}
	return data
}

func TestRuntimeSmokeCollections(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, smokeSrc(t, "rt_smoke_collections_test.c"), 0o644); err != nil {
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
	if string(out) != "OK\n" {
		t.Fatalf("output: %q", out)
	}
}

func cc() string { return claruscboot.CCPath() }

func TestRuntimeSmokeSliceIndexAppend(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, smokeSrc(t, "rt_smoke_slice_index_append_test.c"), 0o644); err != nil {
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
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
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
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
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

// TestRuntimeSmokeLog captures stderr separately from stdout: rt_log writes
// to stderr with a trailing newline, rendering embedded CR bytes as LF
// (mirroring rt_alert's stdout behavior, per Ch12).
func TestRuntimeSmokeLog(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, smokeSrc(t, "rt_smoke_log_test.c"), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
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

func TestRuntimeSmokeArgs(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, smokeSrc(t, "rt_smoke_args_test.c"), 0o644); err != nil {
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
	if string(out) != "OK\n" {
		t.Fatalf("output: %q", out)
	}
}

// TestSliceOverflowPanics covers the int32 overflow vulnerability in slice
// bounds checking: start=INT32_MAX, len=5 would cause start+len to wrap
// negative in the old code, bypassing the bounds check. The reordered check
// (start > srclen-len) avoids the addition entirely.
func TestSliceOverflowPanics(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	src := `
#include "rt.h"
#include <stdint.h>
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } s = {10, {'a','b','c','d','e','f','g','h','i','j'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_slice((uint8_t*)&out, (uint8_t*)&s, INT32_MAX, 5);
    return 0;
}
`
	if err := os.WriteFile(main, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
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

func TestRuntimeSmokeStrings(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, smokeSrc(t, "rt_smoke_test.c"), 0o644); err != nil {
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
