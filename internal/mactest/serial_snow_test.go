// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// serial_snow_test.go: Task 7 (serial-connection phase) -- the phase's
// acceptance gate: examples/serialecho.cla talking over a real Mac serial
// port (SCC channel A / the modem port), emulated by Snow, bridged to a
// TCP port on the host. Gated CLARUS_SNOW_TESTS=1, same as every other
// Snow test in this package (see snow_test.go's own file header for why
// Snow gets its own env var, separate from CLARUS_MAC_TESTS).
//
// Build path: the committed clarusc/clarusc.c snapshot cannot parse the
// `serial` keyword at all (Task 8 regenerates it) -- scripts/build-68k.sh
// bootstraps from that snapshot, so it cannot build serialecho.cla yet.
// This test instead mirrors native_test.go's own buildNative68k: the
// CURRENT-source two-stage compiler (claruscboot.CurrentExe) invoked
// directly with `emit68k`, no --events (the REAL event loop -- WaitNextEvent
// + rtConnPump, not the scripted gVirtualTicks lane -- has to actually pump
// the connection; that's part of what this test proves, the same reasoning
// TestRealEventLoopTickOn68k's own header gives for its own no-events
// boot). Once Task 8 regenerates the snapshot, scripts/build-68k.sh will
// build serialecho.cla directly too; this test doesn't need to change then,
// it just becomes redundant with the (still faster, still preferred for
// day-to-day use) snapshot-bootstrapped path.
package mactest

import (
	"bytes"
	"fmt"
	"io"
	"net"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func isTimeoutErr(err error) bool {
	ne, ok := err.(net.Error)
	return ok && ne.Timeout()
}

// pickFreeTCPPort binds a throwaway listener on 127.0.0.1:0 to learn an
// unused port, then closes it -- the same "find a free port" trick
// internal/conntest's own pickFreePort and runtime/host/rt_serial_test.c's
// bind_ephemeral use (that task's own port-hygiene fix, cross-task
// ledgered onto this one). Unlike those two call sites, Snow's own
// --serial-bridge-a tcp:PORT flag is the one true consumer of the port
// this picks, and this test is CLARUS_SNOW_TESTS-gated (opt-in, never
// part of the default parallel `go test` matrix those two fixes were
// guarding against) -- a bare probe-then-hand-off is low-risk enough here
// that a retry-on-collision loop (their fix) would be effort spent on a
// race this test's own gating already makes very unlikely to hit.
func pickFreeTCPPort(t *testing.T) int {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("pick free port: %v", err)
	}
	port := ln.Addr().(*net.TCPAddr).Port
	ln.Close()
	return port
}

// serialSnowDialBudget bounds the connect-then-app-retry wait: Task 1's
// probe found the bridge's TCP listener accepts in well under a second
// after Snow's process starts (independent of guest boot), but the guest
// booting far enough for the app to open the port and write its greeting
// ranged 4.7-22.2s across four clean boots in that session -- its own
// recommendation was "at least 60s", which this doubles for headroom
// (this harness's own historical Snow-boot timing has never been as tight
// as that probe session's small sample).
const serialSnowDialBudget = 120 * time.Second

// serialSnowOpBudget bounds each ordinary read/write once the connection
// is up and the app is running: Task 1 found the bridge is a raw byte
// pipe at TCP speed, not paced to the configured baud rate (a 2000-byte
// block echoed in ~0.2s, not the ~2.08s true 9600bps would take), so once
// READY has arrived, every further exchange should be near-instant --
// generous anyway for emulator-load variance.
const serialSnowOpBudget = 30 * time.Second

// serialSnowQuitSettle is how long done() waits after QQQ's echo comes
// back before telling runSnow to quit Snow -- enough slack for the
// guest's own `quit` statement (window closeRequest cascade, then
// natQuit's exit-trailer write) to actually finish, so the post-quit disk
// extraction below sees a real "##CLARUS-EXIT## 0" trailer rather than a
// half-finished shutdown.
const serialSnowQuitSettle = 5 * time.Second

// dialSerialBridge retries a TCP dial to Snow's serial bridge port until
// it connects or budget elapses -- Task 1's own finding that the bridge's
// listener comes up almost immediately (well before the guest finishes
// booting) means an early failure here means Snow itself failed to
// launch, not "still booting"; the retry loop tolerates that brief
// process-startup window the same way every other Snow/conntest dial loop
// in this repo already does.
func dialSerialBridge(t *testing.T, port int, budget time.Duration) net.Conn {
	t.Helper()
	deadline := time.Now().Add(budget)
	var lastErr error
	for time.Now().Before(deadline) {
		conn, err := net.DialTimeout("tcp", fmt.Sprintf("127.0.0.1:%d", port), 500*time.Millisecond)
		if err == nil {
			return conn
		}
		lastErr = err
		time.Sleep(250 * time.Millisecond)
	}
	t.Fatalf("dial Snow serial bridge tcp:%d: exhausted %s budget: %v", port, budget, lastErr)
	return nil
}

// readExactSerial reads exactly n bytes (or fails the test), with a
// per-call deadline already set by the caller.
func readExactSerial(t *testing.T, conn net.Conn, n int) []byte {
	t.Helper()
	buf := make([]byte, n)
	if _, err := io.ReadFull(conn, buf); err != nil {
		t.Fatalf("read %d bytes: %v", n, err)
	}
	return buf
}

// readGreeting reads until "READY\r" has been seen, tolerating a small
// amount of leading noise before it rather than assuming the greeting is
// the very first bytes on the wire. A debug probe (this task) found Snow's
// serial bridge emits exactly one spurious byte (observed: 0x80) on the
// FIRST-EVER TCP client connection to a freshly-launched bridge instance,
// arriving under a second after Snow's process starts -- long before the
// guest even finishes booting, so it cannot be serialecho.cla's own
// output. Reconnecting to the same still-running bridge does not
// reproduce it (probed 4x), and READY\r itself always arrives byte-exact
// once the guest actually boots and opens the port -- an artifact of the
// bridge/emulated-SCC attach path, not of the connection runtime or this
// app. Scans a capped read window for "READY\r" as a substring rather
// than requiring it at a fixed offset, so this one-time artifact (or its
// total absence, if a future Snow build stops emitting it) doesn't need
// a magic-number byte count here.
func readGreeting(t *testing.T, conn net.Conn, deadline time.Time) {
	t.Helper()
	want := []byte("READY\r")
	var buf bytes.Buffer
	tmp := make([]byte, 64)
	for !bytes.Contains(buf.Bytes(), want) {
		if time.Now().After(deadline) {
			t.Fatalf("greeting: timed out waiting for %q, got %q so far", want, buf.Bytes())
		}
		conn.SetReadDeadline(deadline)
		n, err := conn.Read(tmp)
		buf.Write(tmp[:n])
		if err != nil && !isTimeoutErr(err) {
			t.Fatalf("greeting: read: %v (got %q so far)", err, buf.Bytes())
		}
		if buf.Len() > 4096 {
			t.Fatalf("greeting: exceeded noise budget without finding %q: got %q", want, buf.Bytes())
		}
	}
}

// echoRoundTrip writes data, reads back len(data) bytes, and requires a
// byte-exact match -- serialecho.cla's own contract (`on
// conn.received(data: text) { ...; conn.send(data); ... }`, no CR/LF
// translation, every byte 0-255 passing through unchanged per the
// language reference's own "### Serial" section).
func echoRoundTrip(t *testing.T, conn net.Conn, data []byte, label string) {
	t.Helper()
	conn.SetDeadline(time.Now().Add(serialSnowOpBudget))
	if _, err := conn.Write(data); err != nil {
		t.Fatalf("%s: write %d bytes: %v", label, len(data), err)
	}
	got := readExactSerial(t, conn, len(data))
	if !bytes.Equal(got, data) {
		i := 0
		for i < len(data) && i < len(got) && data[i] == got[i] {
			i++
		}
		t.Fatalf("%s: echo mismatch at byte %d: want %#02x got %#02x", label, i, data[i], got[i])
	}
}

// sweep256 is the 0-255 byte-exact sweep the brief asks for.
func sweep256() []byte {
	b := make([]byte, 256)
	for i := range b {
		b[i] = byte(i)
	}
	return b
}

// sustainedSweep is a larger, repeated-pattern block (8x the 0-255 sweep,
// 2048 bytes) for the second "sustained" echo pass -- closer to Task 1's
// own 2000-byte sustained-echo probe than a second bare 256-byte sweep
// would be, so this pass actually exercises something the first one
// didn't (a burst well past the driver's un-enlarged default receive
// queue, the exact case Task 1's Amendment 2 found silently dropped data
// before conn_68k.cla's rtConnDevOpen grew it to 8KB via SerSetBuf).
func sustainedSweep() []byte {
	one := sweep256()
	b := make([]byte, 0, len(one)*8)
	for i := 0; i < 8; i++ {
		b = append(b, one...)
	}
	return b
}

// serialEchoSnowTimeout is runSnow's own hard bound -- generous headroom
// above the sum of done()'s own internal budgets (dial + greeting +
// two echo passes + QQQ + settle), which together bound done() to well
// under this regardless: done() runs to completion (or t.Fatalf) on its
// own budgets, this is only the outer safety margin runSnow's own
// contract expects (see its doc comment).
const serialEchoSnowTimeout = 6 * time.Minute

// TestSerialEchoOnSnow is Task 7's own acceptance test: builds
// examples/serialecho.cla for native 68k (no --events -- the real,
// non-scripted event loop has to pump the connection), boots it on a
// scratch Snow clone with the SCC channel A bridge enabled on a free TCP
// port, and drives the whole spec surface over that one TCP connection
// while Snow is still running: the READY\r greeting, a byte-exact 0-255
// sweep, a second larger sustained sweep, and finally QQQ (three
// consecutive 'Q' bytes) to make the guest app quit itself. Once that
// exchange finishes, runSnow's own quit/extract machinery is reused
// exactly like every other Snow test in this package: quit Snow
// gracefully, then check the extracted capture trace for a clean
// "##CLARUS-EXIT## 0" exit trailer. (No separate "no alert() text" check,
// unlike TestMacResidentClaruscOnSnow's own analogous assertion: a
// serial open/transport failure would route through `on conn.failed`
// instead of `on conn.opened`, so READY\r would simply never arrive --
// already a hard t.Fatalf above, and a strictly stronger signal than
// scanning the trace for the failure message's exact wording.)
func TestSerialEchoOnSnow(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	fixture := filepath.Join(root, "examples", "serialecho.cla")
	bin := buildNative68k(t, fixture, "SerialEcho")

	port := pickFreeTCPPort(t)

	d := newSnowDisk(t)
	d.putMacBinary(t, bin, "SerialEcho")

	bootStart := time.Now()
	done := func() bool {
		conn := dialSerialBridge(t, port, serialSnowDialBudget)
		defer conn.Close()
		t.Logf("dialed Snow serial bridge after %s", time.Since(bootStart))

		readGreeting(t, conn, time.Now().Add(serialSnowDialBudget))
		t.Logf("READY received after %s", time.Since(bootStart))

		echoRoundTrip(t, conn, sweep256(), "0-255 sweep")
		echoRoundTrip(t, conn, sustainedSweep(), "sustained sweep")

		conn.SetDeadline(time.Now().Add(serialSnowOpBudget))
		if _, err := conn.Write([]byte("QQQ")); err != nil {
			t.Fatalf("write QQQ: %v", err)
		}
		qEcho := readExactSerial(t, conn, 3)
		if string(qEcho) != "QQQ" {
			t.Fatalf("QQQ echo: got %q, want %q", qEcho, "QQQ")
		}
		t.Logf("QQQ echoed after %s; settling for the guest's own quit", time.Since(bootStart))

		time.Sleep(serialSnowQuitSettle)
		return true
	}

	runSnow(t, d, serialEchoSnowTimeout, done, "--serial-bridge-a", fmt.Sprintf("tcp:%d", port))

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer:\n%s", appOut)
	}
}
