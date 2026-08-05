// internal/build/memtest_c_test.go
package hostrt

import (
	"os/exec"
	"testing"
)

// TestMemC compiles runtime/host/rt_mem_test.c alone (it #includes
// rt_mem.h then rt_mem_host.inc directly -- no rt.c link, since the host
// Memory Manager shim isn't wired into rt.c until a later task) and runs
// the resulting binary in a temp cwd. The test re-execs itself with
// CLARUS_MEM_PARANOID=1 to exercise the paranoid relocation sweep, so
// cmd.Dir matters: the child is spawned via a relative "./<argv[0]>" when
// argv[0] isn't absolute.
func TestMemC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/memtest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", "../../runtime/host/rt_mem_test.c", "-o", exe)
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
