// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// conntest_test.go: the serial-connection phase's own host end-to-end
// proof (Task 5, design spec §5 "Host end-to-end echo"). Builds
// testdata/echo.cla (both connect- and listen-mode subtests use the SAME
// fixture, different env var / binName -- fix round, minor 1: a separate
// echo_listen.cla used to exist purely to omit `on conn.opened`, working
// around a since-fixed host-glue bug, see TestListenMode's own comment)
// and testdata/echo_abort.cla with a CURRENT-source clarusc
// (claruscboot.CurrentExe, the two-stage
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
	"strings"
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
// accept, byte-exact echo, the same close-driven lifetime rule) using the
// SAME echo.cla fixture TestConnectMode does (fix round, minor 1: the
// standalone echo_listen.cla this used to point at was a byte-duplicate
// modulo comments -- deleted).
//
// echo.cla's `on conn.opened { conn.send("READY\n") }` greeting may or
// may not survive to reach this test's peer: `rt_ext_ConnHWrite`
// discards (rather than fails) a write to a still-listening slot,
// mirroring an unattached serial line, so the greeting is silently
// dropped unless a peer happened to already be accepted by the time
// `opened` fires. Rather than a fixed sleep to force one outcome or the
// other (fix round, minor 4: a flake surface under load either way),
// this test dials immediately and treats the greeting as OPTIONAL,
// data-driven: if it's ever going to arrive at all, it's the first bytes
// this connection ever sends (echo.cla's own `App.startCLI` opens
// exactly once, and `opened` fires exactly once), so peeking the first
// len("READY\r") bytes right after writing the sweep -- and only
// treating them as the greeting if they actually match it -- is
// order-independent with no added latency in the (expected) common case
// where nothing is waiting to peek at all.
func TestListenMode(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "echo.cla"), "echo_listen")

	// pickFreePort's own probe-close-reopen gap (its own doc comment)
	// is a real race under a parallel `go test` run -- another package
	// (e.g. internal/hostrt's TestSerialC) can grab the very port this
	// picked between the probe closing and the subprocess's own bind
	// inside conn.open. Root-caused as this test's historical flake
	// surface, same task as runtime/host/rt_serial_test.c's identical
	// fix (open_listen_retrying there). Retrying the whole
	// pick-port+spawn+dial sequence with a freshly re-probed port on a
	// lost race makes it self-heal instead of failing outright.
	var conn net.Conn
	var cmd *exec.Cmd
	var stderr bytes.Buffer
	var port int
	for attempt := 0; attempt < 5 && conn == nil; attempt++ {
		port = pickFreePort(t)
		cmd = exec.Command(exe)
		cmd.Env = append(os.Environ(), fmt.Sprintf("CLARUS_SERIAL_MODEM=listen:%d", port))
		stderr.Reset()
		cmd.Stderr = &stderr
		if err := cmd.Start(); err != nil {
			t.Fatalf("start: %v", err)
		}

		// The program's own bind+listen happens synchronously inside
		// `conn.open` (App.startCLI), before main() ever reaches the pump
		// loop, but that's still some (small, unbounded from here) amount
		// of process-startup time after Start() returns -- retry the dial
		// with a bounded deadline rather than a fixed sleep.
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
			cmd.Process.Kill()
			cmd.Wait()
		}
	}
	if conn == nil {
		t.Fatalf("dial listen:%d: exhausted retries", port)
	}
	defer conn.Close()
	conn.SetDeadline(time.Now().Add(5 * time.Second))

	greeting := []byte("READY\r")
	sweep := sweepBytes()
	if _, err := conn.Write(sweep); err != nil {
		t.Fatalf("write sweep: %v", err)
	}
	head := readExact(t, conn, len(greeting))
	var got []byte
	if bytes.Equal(head, greeting) {
		// The greeting survived (a peer already accepted before `opened`
		// fired) -- the echoed sweep is still to come, in full.
		got = readExact(t, conn, len(sweep))
	} else {
		// No greeting arrived -- `head` IS the first len(greeting) bytes
		// of the echoed sweep itself (sweepBytes()'s own leading bytes,
		// 0x00..0x05, can never collide with "READY\r"'s).
		got = append(append([]byte{}, head...), readExact(t, conn, len(sweep)-len(greeting))...)
	}
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

// TestAbortDuringPump pins the fix-round Important finding:
// cpEmitMain's host pump loop must test `!clar_aborting`, not just
// `rtConnAlive()`. echo_abort.cla opens a connection then aborts
// uncaught, in the SAME `App.startCLI` call, before the pump loop is
// ever entered -- without the fix, `rtConnAlive()` alone would stay true
// forever (this test's peer never disconnects, never sends, never
// closes), so the old loop shape would spin serving events indefinitely
// instead of falling into the existing post-loop abort check. Env
// connect-mode (per the finding): the process must exit 1 PROMPTLY, on
// the abort alone, never depending on the peer.
func TestAbortDuringPump(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "echo_abort.cla"), "echo_abort")

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

	// Accept so connect-mode's blocking connect() succeeds -- but never
	// read, write, or close from this side. If the process only exits
	// because of THIS peer going away, waitExit's own deadline below
	// catches it (it never will, deliberately) rather than this test
	// silently passing for the wrong reason.
	ln.(*net.TCPListener).SetDeadline(time.Now().Add(5 * time.Second))
	conn, err := ln.Accept()
	if err != nil {
		t.Fatalf("accept: %v", err)
	}
	defer conn.Close()

	start := time.Now()
	runErr := waitExit(t, cmd, 3*time.Second)
	elapsed := time.Since(start)

	exitErr, ok := runErr.(*exec.ExitError)
	if !ok {
		t.Fatalf("expected the program to exit nonzero via *exec.ExitError, got: %v (stderr: %s)", runErr, stderr.String())
	}
	if got := exitErr.ExitCode(); got != 1 {
		t.Errorf("exit code: got %d want 1 (stderr: %s)", got, stderr.String())
	}
	if !bytes.Contains(stderr.Bytes(), []byte("boom")) {
		t.Errorf("stderr missing abort message %q: got %q", "boom", stderr.String())
	}
	// Prompt: the fixed loop condition short-circuits on `clar_aborting`
	// before ever calling rtConnPump/ConnHIdle, so this should be near-
	// instant -- generous bound to stay non-flaky under load while still
	// being far tighter than "wait for a peer that never disconnects".
	if elapsed > 2*time.Second {
		t.Errorf("abort exit took %v, expected prompt (not peer-disconnect-dependent)", elapsed)
	}
}

// TestConnShadowedLocalIsNil (Task 4, binary-files phase -- flipped from
// the old TestConnShadowedLocalRejected pin now that `connection` is an
// ordinary VALUE, not a compile-time slot alias: a local `var conn:
// connection` shadowing a global of the same name is a perfectly legal
// receiver shape now, same as any other local variable shadowing a
// global). testdata/conn_shadow_local.cla's `useLocal` declares such a
// local, never assigns it, and calls `.send` on it -- this must BUILD
// clean (no lowUnsupported rejection) and PANIC at runtime with "use of
// nil connection" (runtime/clarus/conn.cla's `h == 0` guard), since a
// never-assigned connection local is nil (0) by construction, exactly
// like any other never-assigned int-shaped local. No CLARUS_SERIAL_MODEM
// is set: `conn.open(serial "modem:9600")` on the GLOBAL in App.startCLI
// takes the synchronous env-unset `failed` path (TestEnvUnsetFailedPath's
// own contract -- never blocks, never panics) before useLocal() ever
// runs, so this needs no TCP peer at all, unlike TestAbortDuringPump.
func TestConnShadowedLocalIsNil(t *testing.T) {
	exe := buildConnFixture(t, filepath.Join(repoRoot(t), "internal", "conntest", "testdata", "conn_shadow_local.cla"), "conn_shadow_local")

	cmd := exec.Command(exe)
	cmd.Env = os.Environ()
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	runErr := cmd.Run()

	exitErr, ok := runErr.(*exec.ExitError)
	if !ok {
		t.Fatalf("expected the program to exit nonzero via *exec.ExitError, got: %v (stdout: %s, stderr: %s)", runErr, stdout.String(), stderr.String())
	}
	// rt.c's panic path (runtime/host/rt.c) exits 3 -- the host-lane
	// panic-exit convention (distinct from `quit N`/abort's exit 1).
	if got := exitErr.ExitCode(); got != 3 {
		t.Errorf("exit code: got %d want 3 (stdout: %s, stderr: %s)", got, stdout.String(), stderr.String())
	}
	const want = "use of nil connection"
	if !strings.Contains(stderr.String(), want) {
		t.Errorf("stderr %q missing %q", stderr.String(), want)
	}
}
