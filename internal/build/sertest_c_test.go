// internal/build/sertest_c_test.go
package build

import (
	"os/exec"
	"testing"
)

// TestSerC compiles internal/build/rt/rt_ser_test.c against rt/rt.c (the
// host runtime) and runs the resulting binary in a temp cwd, so its
// relative-path file.save/load round trips (rec.dat, list.dat, map.dat,
// the corrupted-file failure-mode fixtures) don't touch the repo. Exercises
// the shared-source serializer (rt_ser.inc) purely through the public
// rt_file_save/rt_file_load/rt_list_/rt_map_ API -- byte-exact goldens for
// the file format live in rt_ser_test.c itself (rec1_expected).
func TestSerC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/sertest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "rt", "rt/rt_ser_test.c", "rt/rt.c", "-o", exe)
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
