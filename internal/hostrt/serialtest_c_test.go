// internal/hostrt/serialtest_c_test.go
package hostrt

import (
	"os/exec"
	"testing"
)

// TestSerialC compiles runtime/host/rt_serial_test.c against runtime/host/rt.c
// (the host runtime, which #includes rt_serial.inc) and runs the resulting
// binary. Exercises the `connection` type's host TCP glue purely through its
// public rt_ext_ConnH* API: listen mode (glue as server) and connect mode
// (glue as client), 256 bytes each direction in both, plus ConnHGone
// detecting an orderly peer close. See rt_serial_test.c's own header comment
// for the full scenario breakdown and the hand-run compile line.
func TestSerialC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/serialtest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", "../../runtime/host/rt_serial_test.c", "../../runtime/host/rt.c", "-o", exe)
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
