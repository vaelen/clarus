// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// conntest_test.go: the serial-connection phase's own host end-to-end
// proof (Task 5, design spec §5 "Host end-to-end echo"). Builds
// testdata/echo.cla (and its listen-mode sibling, testdata/echo_listen.cla
// -- see that file's own doc comment for why it exists separately) with a
// CURRENT-source clarusc (claruscboot.CurrentExe, the two-stage
// snapshot-emits-current-source-then-cc-compiles-it bootstrap): the
// COMMITTED clarusc/clarusc.c snapshot cannot parse the `serial` keyword
// at all (Task 8 regenerates it), so scripts/clarus-run.sh's cached
// snapshot recipe is the wrong tool here.
package conntest

import (
	"bytes"
	"fmt"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
	"time"

	"clarus/internal/claruscboot"
)

// repoRoot walks up from the package's own directory (go test's cwd) to
// the directory containing go.mod.
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// buildConnFixture emits claPath's C with the CURRENT-source clarusc and
// compiles it with cc against the on-disk host runtime -- the same
// compose recipe internal/mactest/suite_host_test.go's
// buildHostFromFixtures uses (same bootstrap, same -I runtime/host link),
// duplicated here rather than imported since it's unexported there and
// this is a different package.
func buildConnFixture(t *testing.T, claPath, binName string) string {
	t.Helper()
	root := repoRoot(t)
	claruscExe := claruscboot.CurrentExe(t)
	work := t.TempDir()
	outC := filepath.Join(work, binName+".c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	emit := exec.Command(claruscExe, "emit", "--rtdir", rtDir, "-o", outC, claPath)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %s: %v\n%s", claPath, err, out)
	}

	exe := filepath.Join(work, binName)
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "runtime", "host"),
		outC, filepath.Join(root, "runtime", "host", "rt.c"), "-o", exe)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %s: %v\n%s", claPath, err, out)
	}
	return exe
}

// pickFreePort binds a throwaway socket on port 0 to learn an unused port
// number, then closes it -- the same "find a free port" trick
// runtime/host/rt_serial_test.c's own pick_free_port uses: rt_ext_ConnHOpen's
// listen mode takes a literal port, it has no ephemeral-port query of its
// own, so listen: mode needs a real number chosen up front.
func pickFreePort(t *testing.T) int {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("pick free port: %v", err)
	}
	port := ln.Addr().(*net.TCPAddr).Port
	ln.Close()
	return port
}

// waitExit waits (up to timeout) for cmd to exit on its own -- the
// lifetime-rule proof (spec §3, "Program lifetime": exits once nothing is
// open and no event is pending), NOT something the test kills. Fails the
// test if the deadline passes first.
func waitExit(t *testing.T, cmd *exec.Cmd, timeout time.Duration) error {
	t.Helper()
	done := make(chan error, 1)
	go func() { done <- cmd.Wait() }()
	select {
	case err := <-done:
		return err
	case <-time.After(timeout):
		cmd.Process.Kill()
		<-done
		t.Fatalf("process did not exit on its own within %v (lifetime rule violated)", timeout)
		return nil
	}
}

// readExact reads exactly n bytes from conn (or fails the test).
func readExact(t *testing.T, conn net.Conn, n int) []byte {
	t.Helper()
	buf := make([]byte, n)
	if _, err := readFull(conn, buf); err != nil {
		t.Fatalf("read %d bytes: %v", n, err)
	}
	return buf
}

func readFull(conn net.Conn, buf []byte) (int, error) {
	got := 0
	for got < len(buf) {
		n, err := conn.Read(buf[got:])
		got += n
		if err != nil {
			return got, err
		}
	}
	return got, nil
}

// sweepBytes is every possible byte value, 0-255 -- the design spec's own
// "full 0-255 byte sweep" requirement, binary-safe (received/send never
// translate CR/LF or clamp on a NUL/high-bit byte).
func sweepBytes() []byte {
	b := make([]byte, 256)
	for i := range b {
		b[i] = byte(i)
	}
	return b
}

// TestConnectMode is the design spec's own "Host end-to-end echo" case
// (§5): connect-mode sweep, a second write (multiple `received` firings),
// the close-driven lifetime rule (process exits on its own, no kill
// needed).
func TestConnectMode(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "echo.cla"), "echo")

	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("listen: %v", err)
	}
	defer ln.Close()
	port := ln.Addr().(*net.TCPAddr).Port

	cmd := exec.Command(exe)
	cmd.Env = append(os.Environ(), fmt.Sprintf("CLARUS_SERIAL_MODEM=connect:127.0.0.1:%d", port))
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Start(); err != nil {
		t.Fatalf("start: %v", err)
	}

	ln.(*net.TCPListener).SetDeadline(time.Now().Add(5 * time.Second))
	conn, err := ln.Accept()
	if err != nil {
		t.Fatalf("accept: %v", err)
	}
	defer conn.Close()
	conn.SetDeadline(time.Now().Add(5 * time.Second))

	// "READY\n" arrives (opened fired). Host wire-byte finding (probe
	// Amendment 3, confirmed empirically for the HOST lane too, not just
	// native): a Clarus `"\n"` string literal is CR (0x0D) on the wire on
	// BOTH lanes -- no lane divergence, so this asserts the exact observed
	// byte, CR, not LF.
	ready := readExact(t, conn, 6)
	if want := []byte("READY\r"); !bytes.Equal(ready, want) {
		t.Fatalf("READY preamble: got %q want %q", ready, want)
	}

	// 0-255 sweep round-trips byte-exact (binary-safe received/send).
	sweep := sweepBytes()
	if _, err := conn.Write(sweep); err != nil {
		t.Fatalf("write sweep: %v", err)
	}
	got := readExact(t, conn, len(sweep))
	if !bytes.Equal(got, sweep) {
		t.Fatalf("sweep echo mismatch")
	}

	// A second write also echoes (multiple `received` firings, not just
	// the first).
	second := []byte("a second write, after the sweep")
	if _, err := conn.Write(second); err != nil {
		t.Fatalf("write second: %v", err)
	}
	got2 := readExact(t, conn, len(second))
	if !bytes.Equal(got2, second) {
		t.Fatalf("second echo mismatch: got %q want %q", got2, second)
	}

	// "QQQ" -> three consecutive 'Q's -> conn.close() from the PROGRAM
	// side (echoed back first, since send(data) runs before the byte scan
	// that finds quit3==3).
	if _, err := conn.Write([]byte("QQQ")); err != nil {
		t.Fatalf("write QQQ: %v", err)
	}
	qq := readExact(t, conn, 3)
	if !bytes.Equal(qq, []byte("QQQ")) {
		t.Fatalf("QQQ echo mismatch: got %q", qq)
	}

	// Lifetime rule: close leaves nothing open -> rtConnAlive() false ->
	// main() returns on its own. The process EXITS, unkilled.
	err = waitExit(t, cmd, 5*time.Second)
	if err != nil {
		t.Fatalf("process should exit 0 on its own, got error: %v (stderr: %s)", err, stderr.String())
	}
}

// TestListenMode proves the listen: transport path (bind, deferred
// accept, byte-exact echo, the same close-driven lifetime rule) using
// echo_listen.cla -- which, per the controller's fix-round ruling, now
// carries the SAME `on conn.opened { conn.send("READY\n") }` greeting
// echo.cla's connect-mode fixture has (rt_ext_ConnHWrite no longer fails
// a write to a still-listening slot; it discards and reports success,
// mirroring an unattached serial line). This test deliberately dials
// AFTER giving the child time to have already fired `opened` and
// discarded that greeting (see the sleep below) -- proving the discard
// path is harmless to LATER real traffic, not just that it doesn't
// crash: the post-peer sweep still round-trips byte-exact, with no
// leftover "READY\n" bytes ahead of it in the stream.
func TestListenMode(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "echo_listen.cla"), "echo_listen")

	port := pickFreePort(t)
	cmd := exec.Command(exe)
	cmd.Env = append(os.Environ(), fmt.Sprintf("CLARUS_SERIAL_MODEM=listen:%d", port))
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Start(); err != nil {
		t.Fatalf("start: %v", err)
	}

	// Give the child a head start past its own first pump pass (no idle
	// wait at all before that first pass -- see cpEmitMain's pump loop),
	// so `opened`'s greeting has already been sent-and-discarded into the
	// pre-peer void before we ever dial -- otherwise a peer that connects
	// mid-greeting could actually RECEIVE "READY\n" ahead of the echo
	// stream this test reads, which is a real (if equally valid) racing
	// outcome this test isn't set up to also assert on.
	time.Sleep(50 * time.Millisecond)

	// The program's own bind+listen happens synchronously inside
	// `conn.open` (App.startCLI), before main() ever reaches the pump
	// loop, but that's still some (small, unbounded from here) amount of
	// process-startup time after Start() returns -- retry the dial with a
	// bounded deadline rather than a fixed sleep.
	var conn net.Conn
	deadline := time.Now().Add(5 * time.Second)
	var dialErr error
	for time.Now().Before(deadline) {
		conn, dialErr = net.DialTimeout("tcp", fmt.Sprintf("127.0.0.1:%d", port), 200*time.Millisecond)
		if dialErr == nil {
			break
		}
		time.Sleep(20 * time.Millisecond)
	}
	if dialErr != nil {
		t.Fatalf("dial listen:%d: %v", port, dialErr)
	}
	defer conn.Close()
	conn.SetDeadline(time.Now().Add(5 * time.Second))

	sweep := sweepBytes()
	if _, err := conn.Write(sweep); err != nil {
		t.Fatalf("write sweep: %v", err)
	}
	got := readExact(t, conn, len(sweep))
	if !bytes.Equal(got, sweep) {
		t.Fatalf("sweep echo mismatch")
	}

	if _, err := conn.Write([]byte("QQQ")); err != nil {
		t.Fatalf("write QQQ: %v", err)
	}
	qq := readExact(t, conn, 3)
	if !bytes.Equal(qq, []byte("QQQ")) {
		t.Fatalf("QQQ echo mismatch: got %q", qq)
	}

	if err := waitExit(t, cmd, 5*time.Second); err != nil {
		t.Fatalf("process should exit 0 on its own, got error: %v (stderr: %s)", err, stderr.String())
	}
}

// TestEnvUnsetFailedPath is the `failed(err)` route: CLARUS_SERIAL_MODEM
// unset makes `open` fail environmentally (never a panic), the
// `failed` handler logs and `quit 1`s.
func TestEnvUnsetFailedPath(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "echo.cla"), "echo")

	cmd := exec.Command(exe)
	// Explicitly drop any CLARUS_SERIAL_MODEM/_PRINTER the test process's
	// own environment might carry, rather than trusting os.Environ() to
	// already lack them.
	env := os.Environ()
	filtered := env[:0]
	for _, e := range env {
		if len(e) >= len("CLARUS_SERIAL_MODEM=") && e[:len("CLARUS_SERIAL_MODEM=")] == "CLARUS_SERIAL_MODEM=" {
			continue
		}
		if len(e) >= len("CLARUS_SERIAL_PRINTER=") && e[:len("CLARUS_SERIAL_PRINTER=")] == "CLARUS_SERIAL_PRINTER=" {
			continue
		}
		filtered = append(filtered, e)
	}
	cmd.Env = filtered

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	runErr := cmd.Run()

	exitErr, ok := runErr.(*exec.ExitError)
	if !ok {
		t.Fatalf("expected the program to exit nonzero via *exec.ExitError, got: %v", runErr)
	}
	if got := exitErr.ExitCode(); got != 1 {
		t.Errorf("exit code: got %d want 1 (stdout: %s, stderr: %s)", got, stdout.String(), stderr.String())
	}
	if !bytes.Contains(stderr.Bytes(), []byte("failed:")) {
		t.Errorf("stderr missing %q: got %q", "failed:", stderr.String())
	}
}
