// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// pagefile_snow_test.go: Task 9 (binary-files phase) -- the phase's own
// hardware acceptance gate: examples/pagefile.cla, a vDB-shaped page-store
// demo, talking over a real Mac serial port (SCC channel A / the modem
// port) emulated by Snow, bridged to a TCP port on the host. Gated
// CLARUS_SNOW_TESTS=1, same as every other Snow test in this package.
// Reuses serial_snow_test.go's own scratch-workspace clone,
// --serial-bridge-a wiring, and dial-with-retry machinery verbatim
// (pickFreeTCPPort, dialSerialBridge, serialSnowDialBudget,
// serialSnowQuitSettle, isTimeoutErr) rather than duplicating any of it --
// this test only adds its own read-the-result-line step, since pagefile's
// wire protocol (one "PASS N\r" or "FAIL <what>\r" line, then the app
// quits on its own) is simpler than serialecho's own echo/QQQ exchange
// and doesn't need sweep256/echoRoundTrip at all.
//
// Tasks 5-6 (this same phase) already proved `filehandle` end to end on
// System 6 via the native-suite Mini vMac boot (FileHandleRW,
// TestCoreSuiteGUIOn68k); this test is the design doc's own %5 System 7
// hardware acceptance line for the SAME feature set (filehandle, the text
// binary accessors, crc16, string(n), connection-as-a-value), proved on
// Snow instead of Mini vMac.
package mactest

import (
	"bytes"
	"fmt"
	"net"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// pageFileResultBudget bounds the wait for the one result line, measured
// from a successful dial. pagefile.cla's whole write-ahead-journal pass
// (16 pages, each a writeAt plus two real durability barriers on both
// the data file and the journal) runs synchronously inside `App.launch`,
// before the event loop -- and so the connection pump -- ever starts, so
// this has to cover guest boot plus that whole file pass, not just boot.
// A Mini vMac probe of the SAME native build (internal/mactest's own
// throwaway TestZZPageFileDebug, this task) found the entire pass --
// create both files, all 16 pages, verify, `conn.opened`, quit -- takes
// well under 5 seconds of guest time; this budget is dominated by Snow's
// own boot-time variance (TestSerialEchoOnSnow's own doc comment:
// 4.7-22.2s across four clean boots), same order of magnitude as
// serialSnowDialBudget (120s, tuned for serialecho's own near-instant
// greeting) -- kept at that same value rather than narrowed further,
// since Snow's SCSI-disk emulation timing for 32 real flushes hasn't
// been probed directly the way Mini vMac's was here.
//
// (An EARLIER version of this test used an 8-minute budget while
// chasing what turned out to be a different, structural bug: pagefile.cla
// had no window/menu/`every`, so cg68k classified it non-UI -- and the
// native lane only wires the connection pump into the UI-classified
// event loop (Task 6 of the serial-connection phase); a non-UI native
// program's `on conn.*` handlers simply never fire, at any budget. Fixed
// by giving the app a one-window UI shape, same as serialecho.cla; see
// examples/pagefile.cla's own doc comment for the full story, confirmed
// with a throwaway window-free probe that starved for 8+ minutes and a
// windowed twin that succeeded in ~27s.)
const pageFileResultBudget = serialSnowDialBudget

// pageFileSnowTimeout is runSnow's own hard bound: pageFileResultBudget
// plus the post-result settle plus headroom, the same
// budget-plus-margin reasoning serialEchoSnowTimeout's own doc comment
// gives (done() itself is bounded well under this by its own internal
// budgets regardless).
const pageFileSnowTimeout = 4 * time.Minute

// readResultLine reads bytes off conn until a CR (0x0D) is seen --
// pagefile.cla's own wire format is one line, CR-terminated (Clarus
// string literals' `\n` escape emits CR, the Mac newline, per the
// language reference's own Literals table -- NOT LF), tolerating a small
// amount of leading noise the same way readGreeting does, for the same
// reason (Snow's serial bridge emits one spurious byte on a freshly
// launched bridge's very first client connection; see readGreeting's own
// doc comment). Returns the line's bytes with the trailing CR stripped.
func readResultLine(t *testing.T, conn net.Conn, deadline time.Time) string {
	t.Helper()
	var buf bytes.Buffer
	tmp := make([]byte, 64)
	for {
		if idx := bytes.IndexByte(buf.Bytes(), '\r'); idx >= 0 {
			line := buf.Bytes()[:idx]
			// Strip any leading noise bytes (the one known spurious
			// artifact is non-ASCII, e.g. 0x80 -- see the doc comment
			// above) up to the actual "PASS "/"FAIL " result, the same
			// tolerance readGreeting applies via its own substring scan.
			for len(line) > 0 && line[0] != 'P' && line[0] != 'F' {
				line = line[1:]
			}
			return string(line)
		}
		if time.Now().After(deadline) {
			t.Fatalf("result line: timed out waiting for CR, got %q so far", buf.Bytes())
		}
		conn.SetReadDeadline(deadline)
		n, err := conn.Read(tmp)
		buf.Write(tmp[:n])
		if err != nil && !isTimeoutErr(err) {
			t.Fatalf("result line: read: %v (got %q so far)", err, buf.Bytes())
		}
		if buf.Len() > 4096 {
			t.Fatalf("result line: exceeded noise budget without a CR: got %q", buf.Bytes())
		}
	}
}

// TestPageFileOnSnow is Task 9's own acceptance test: builds
// examples/pagefile.cla for native 68k (no --events -- the real,
// non-scripted event loop has to pump the connection, same reasoning
// TestSerialEchoOnSnow's own doc comment gives), boots it on a scratch
// Snow clone with the SCC channel A bridge enabled on a free TCP port,
// dials in (before the guest even finishes booting, same as
// TestSerialEchoOnSnow -- this is what makes the exchange race-free: the
// peer is already attached by the time the guest's own `conn.open` fires
// `opened` and sends its result line), reads the one result line, and
// requires it to be exactly "PASS 16". Once that arrives, runSnow's own
// quit/extract machinery is reused exactly like every other Snow test in
// this package: quit Snow, then check the extracted capture trace for a
// clean "##CLARUS-EXIT## 0" exit trailer.
func TestPageFileOnSnow(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	fixture := filepath.Join(root, "examples", "pagefile.cla")
	bin := buildNative68k(t, fixture, "PageFile")

	port := pickFreeTCPPort(t)

	d := newSnowDisk(t)
	d.putMacBinary(t, bin, "PageFile")

	bootStart := time.Now()
	done := func() bool {
		conn := dialSerialBridge(t, port, serialSnowDialBudget)
		defer conn.Close()
		t.Logf("dialed Snow serial bridge after %s", time.Since(bootStart))

		line := readResultLine(t, conn, time.Now().Add(pageFileResultBudget))
		t.Logf("result line %q received after %s", line, time.Since(bootStart))

		if line != "PASS 16" {
			t.Fatalf("pagefile result: got %q, want %q", line, "PASS 16")
		}

		time.Sleep(serialSnowQuitSettle)
		return true
	}

	runSnow(t, d, pageFileSnowTimeout, done, "--serial-bridge-a", fmt.Sprintf("tcp:%d", port))

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer:\n%s", appOut)
	}
}
