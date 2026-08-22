// internal/hostrt/filehtest_c_test.go
package hostrt

import (
	"os/exec"
	"testing"
)

// TestFilehC compiles runtime/host/rt_fileh_test.c against runtime/host/rt.c
// (the host runtime, which #includes rt_fileh.inc) and runs the resulting
// binary in a temp cwd. Exercises the `filehandle` type's host pread/pwrite
// glue purely through its public rt_ext_FhH* API: create/write/read/size/
// setSize/flush/close round trip, plus the documented short-read-at-EOF and
// append (pos == -1) cases and the open-failure/create-truncates paths. See
// rt_fileh_test.c's own header comment for the full scenario breakdown.
func TestFilehC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/filehtest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", "../../runtime/host/rt_fileh_test.c", "../../runtime/host/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	run := exec.Command(exe)
	run.Dir = dir
	out, err := run.CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, out)
	}
	if string(out) != "OK\n" {
		t.Fatalf("output: %q", out)
	}
}
