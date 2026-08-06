// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// catalog_test.go (toolbox-cookbook Task 1): check-passes the shipped
// toolbox/ extern catalog. A bare catalog file has no app/on handler, so
// it cannot be checked alone -- the test composes a minimal driver that
// references at least one symbol from each catalog file (so the
// declarations must actually bind, not merely parse) and runs clarusc in
// check-only mode (bare positional files) over driver + all four files.
package testsuite

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// catalogFiles: repo-root-relative, the shipped declaration catalog.
var catalogFiles = []string{
	filepath.Join("toolbox", "memory.cla"),
	filepath.Join("toolbox", "events.cla"),
	filepath.Join("toolbox", "osutils.cla"),
	filepath.Join("toolbox", "scrap.cla"),
}

// catalogDriver references >=1 symbol per catalog file: TickCount/
// EventAvail/everyEvent/EventRecord (events), NewPtr/DisposePtr (memory),
// Gestalt/SysBeep (osutils), ZeroScrap (scrap).
const catalogDriver = `on App.startCLI(args: list of string) {
    var ev: EventRecord
    var t0: int
    var p: ptr
    var err: int

    t0 = TickCount()
    p = NewPtr(4)
    err = ZeroScrap()
    err = Gestalt(0x73797376, p)
    if EventAvail(everyEvent, ev) {
        t0 = t0 + ev.what
    }
    DisposePtr(p)
    SysBeep(1)
    if t0 < 0 {
        t0 = 0
    }
}
`

func TestCatalogChecks(t *testing.T) {
	exe := bootstrapClarusc(t)
	root := repoRoot(t)
	work := t.TempDir()
	driver := filepath.Join(work, "driver.cla")
	if err := os.WriteFile(driver, []byte(catalogDriver), 0o644); err != nil {
		t.Fatal(err)
	}
	args := []string{driver}
	for _, f := range catalogFiles {
		args = append(args, filepath.Join(root, f))
	}
	if out, err := exec.Command(exe, args...).CombinedOutput(); err != nil {
		t.Fatalf("clarusc check failed: %v\n%s", err, out)
	}
}
