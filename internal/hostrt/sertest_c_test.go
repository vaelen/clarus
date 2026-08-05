// internal/build/sertest_c_test.go
package hostrt

import (
	"bytes"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"testing"
)

// TestSerC compiles runtime/host/rt_ser_test.c against runtime/host/rt.c (the
// host runtime) and runs the resulting binary in a temp cwd, so its
// relative-path file.save/load round trips (rec.dat, list.dat, map.dat,
// the corrupted-file failure-mode fixtures) don't touch the repo. Exercises
// the shared-source serializer (rt_ser.inc) purely through the public
// rt_file_save/rt_file_load/rt_list_/rt_map_ API -- byte-exact goldens for
// the file format live in rt_ser_test.c itself (rec1_expected).
//
// Also a strict leak gate (Task 4): CLARUS_MEM_STRICT+PARANOID make the
// host Memory Manager shim report "##CLARUS-MEM## live=<N>" on stderr at
// exit (CLARUS_MEM_REPORT unset), and rt_ser_test.c must exit with live=0
// -- the worst repeatable leak was rt_file_save/rt_file_load leaking a
// whole rt_text per call.
var serLiveRE = regexp.MustCompile(`##CLARUS-MEM## live=(\d+)`)

func TestSerC(t *testing.T) {
	dir := t.TempDir()
	exe := dir + "/sertest"
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", "../../runtime/host/rt_ser_test.c", "../../runtime/host/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	run := exec.Command(exe)
	run.Dir = dir
	run.Env = append(os.Environ(), "CLARUS_MEM_STRICT=1", "CLARUS_MEM_PARANOID=1")
	var stdout, stderr bytes.Buffer
	run.Stdout = &stdout
	run.Stderr = &stderr
	if err := run.Run(); err != nil {
		t.Fatalf("run: %v\nstdout:\n%sstderr:\n%s", err, stdout.String(), stderr.String())
	}
	if stdout.String() != "OK\n" {
		t.Fatalf("output: %q", stdout.String())
	}

	m := serLiveRE.FindStringSubmatch(stderr.String())
	if m == nil {
		t.Fatalf("no ##CLARUS-MEM## live= line in stderr:\n%s", stderr.String())
	}
	live, err := strconv.Atoi(m[1])
	if err != nil {
		t.Fatalf("bad live count %q: %v", m[1], err)
	}
	if live != 0 {
		t.Fatalf("leaked %d block(s):\n%s", live, stderr.String())
	}
}
