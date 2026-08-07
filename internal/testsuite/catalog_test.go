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
	filepath.Join("toolbox", "standardfile.cla"),
	filepath.Join("toolbox", "files.cla"),
}

// catalogDriver references >=1 symbol per catalog file: TickCount/
// EventAvail/everyEvent/EventRecord (events), NewPtr/DisposePtr (memory),
// GestaltErr/GestaltValue/SysBeep (osutils), ZeroScrap (scrap), SFReply/SFTypeList/
// Str255/SFGetFile/SFPutFile (standardfile), VolumeParam/PBSetVolSync/
// FileParam/PBGetFInfoSync/PBSetFInfoSync (files, task-6a's FInfo-stamp
// addition).
const catalogDriver = `on App.startCLI(args: list of string) {
    var ev: EventRecord
    var t0: int
    var p: ptr
    var err: int
    var rep: SFReply
    var tl: SFTypeList
    var vp: VolumeParam
    var pr: Str255
    var fp: FileParam

    t0 = TickCount()
    p = NewPtr(4)
    err = ZeroScrap()
    err = GestaltErr(0x73797376)
    t0 = t0 + GestaltValue(0x73797376)
    if EventAvail(everyEvent, ev) {
        t0 = t0 + ev.what
    }
    DisposePtr(p)
    SysBeep(1)
    if t0 < 0 {
        t0 = 0
    }

    tl.t0 = 0x54455854
    pr.s = "Save as:"
    vp.ioNamePtr = ptr(0)
    vp.ioVRefNum = 0
    err = PBSetVolSync(vp)
    SFGetFile((100 << 16) | 100, pr, ptr(0), 1, tl, ptr(0), rep)
    SFPutFile((100 << 16) | 100, pr, pr, ptr(0), rep)
    if rep.good {
        t0 = t0 + rep.vRefNum
    }

    fp.ioNamePtr = ptr(0)
    fp.ioVRefNum = 0
    fp.ioFDirIndex = 0
    err = PBGetFInfoSync(fp)
    fp.fdType = 0x54455854
    fp.fdCreator = 0x4D505320
    err = PBSetFInfoSync(fp)
    if err != 0 {
        t0 = t0 + 1
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
