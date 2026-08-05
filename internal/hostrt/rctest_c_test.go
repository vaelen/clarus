// internal/hostrt/rctest_c_test.go
package hostrt

import (
	"os/exec"
	"testing"
)

// TestRcC compiles runtime/host/rt_rc_test.c alone (it #includes rt.h,
// rt_mem.h, rt_mem_host.inc, then rt_core.inc directly -- no rt.c link) and
// runs the resulting binary in a temp cwd. Exercises the counted-box
// retain/release API (ARC Task 1): rc field, retain/release, free-aliased-
// to-release, and the host-only over-release abort guard.
func TestRcC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/rctest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", "../../runtime/host/rt_rc_test.c", "-o", exe)
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
