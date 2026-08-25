### Task 1: Probe wave — paths, catalog enumeration, prelude splice point (NO tree commits)

Per the established probe pattern (binary-files Task 1): everything here is throwaway; the deliverable is `.superpowers/sdd/2026-08-26-filesystem-api/task-1-report.md` plus amendments to Tasks 2–5.

**Files:**
- Create (scratch, reverted before finishing): `testsuite/toolbox/cases_probe.cla` + a temporary LAST registration in `testsuite/toolbox/runner.cla` (enum member, name map, default list, dispatch — copy the four `NarrowPopup` sites), and a throwaway `/private/tmp/.../probe_rec.cla`.
- Read: `runtime/clarus/fileh_68k.cla:28-100` (`rtFh68kName`, the `var pb: IOParam` local + direct field-write PB idiom), `testsuite/toolbox/cases_finfo.cla` (a complete PB-trap test case), `clarusc/drive.cla:1640-1830` and `:2080-2110` (the standalone check: `combined`/`combined2` chain assembly, `checkProgram(combined)` at ~2104 for the user-only pass, `checkProgram(combined2)` at ~1808 for the whole program), `clarusc/drive.cla:1515-1595` (`neededMods`), `clarusc/bake.cla:415-450` (the mirrored module list).

**Interfaces:**
- Produces: `task-1-report.md` with (a) the VERIFIED trap/selector/offset table for Task 2, (b) path-form results (nested partial, full), (c) the enumeration recipe that worked (`ioVRefNum`/`ioDirID`/`ioFDirIndex` values, the `""`-means-default-folder question), (d) the exact `drive.cla` splice point + the emit68k byte-identity measurement, (e) amendments.

- [ ] **Step 1: Transcribe and verify the trap set**

Reflow both headers (`LC_ALL=C tr '\r' '\n'`). Record with reflowed line numbers, for each: the `#pragma parameter` line, the `EXTERN_API` line's `ONEWORDINLINE`/`TWOWORDINLINE`, and the `Files.a` `Macro` body. Expected (spec §4.6): `PBGetCatInfoSync` `moveq #9,D0; dc.w $A260` (Files.h ~2879-2881, Files.a ~3368), `PBSetCatInfoSync` `#10` (~2907-2909), `PBDirCreateSync` `#6` (~2792-2794, Files.a ~3210), `PBCatMoveSync` `#5` (~2764-2766, Files.a ~3158), `PBHDeleteSync` `0xA209` (~3187-3189), `PBHRenameSync` `0xA20B` (~3215-3217), `PBHGetFInfoSync` `0xA20C` (~3299-3301), `PBHSetFInfoSync` `0xA20D` (~3327-3329), `PBHOpenRFSync` `0xA20A` (~3103-3105). Also `PBGetVolSync` `0xA014` (~1382-1384; probe-only, to learn the boot volume's name for the full-path test). Record the struct layouts from `struct HFileInfo` (~557), `struct DirInfo` (~588), `struct HFileParam` (~832), `struct CMovePBRec` (~1117), computing offsets by hand with MPW 68k packing (2-byte alignment for `short`/`long`/pointers, 1 for `SInt8`): expected `ioFDirIndex`@28:2, `ioFlAttrib`@30:1, `ioACUser`@31:1, `ioFlFndrInfo`@32:16 (`fdType`@32, `fdCreator`@36), `ioDirID`/`ioDrDirID`@48:4, `ioDrNmFls`@52:2, `ioFlLgLen`@54:4, `ioFlRLgLen`@64:4, `ioFlCrDat`@72:4, `ioFlMdDat`@76:4, `ioFlParID`@100:4, total 108; `CMovePBRec`: `ioNewName`@28:4, `ioNewDirID`@36:4, `ioDirID`@48:4, total 52; `HFileParam`: `ioMisc` does NOT exist in the H file variant — for `PBHRename` the new name goes in `ioMisc` of the `HIOParam`/`HFileParam` union at offset 28 (`ioMisc`@28:4 in `struct HIOParam` ~811; confirm) and `ioDirID`@48. Also `ioDirMask = 0x10` (Files.a ~247), `fsRtDirID = 2`.

- [ ] **Step 2: Write the throwaway probe case**

`testsuite/toolbox/cases_probe.cla`, registered LAST. Declare the probe's own externs locally (do NOT touch `toolbox/files.cla` yet — Task 2 owns it), using the names/records Task 2 will ship so the probe doubles as a transcription check:

```
extern record PbCInfo {
    qLink: ptr
    qType: word
    ioTrap: word
    ioCmdAddr: ptr
    ioCompletion: ptr
    ioResult: word
    ioNamePtr: ptr
    ioVRefNum: word
    ioFRefNum: word
    ioFVersNum: byte
    filler1: byte
    ioFDirIndex: word
    ioFlAttrib: byte
    ioACUser: byte
    fdType: int
    fdCreator: int
    pad[8]
    ioDirID: int
    ioDrNmFls: word
    ioFlLgLen: int
    ioFlPyLen: int
    ioFlRStBlk: word
    ioFlRLgLen: int
    ioFlRPyLen: int
    ioFlCrDat: int
    ioFlMdDat: int
    pad[32]
}
external func PbGetCatInfo(pb: ptr, sel: int): int = trap 0xA260 reg(a0: pb, d0: sel) ret d0
external func PbDirCreate(pb: ptr, sel: int): int = trap 0xA260 reg(a0: pb, d0: sel) ret d0
external func PbCatMove(pb: ptr, sel: int): int = trap 0xA260 reg(a0: pb, d0: sel) ret d0
external func PbHDelete(pb: ptr): int = trap 0xA209 reg
external func PbHRename(pb: ptr): int = trap 0xA20B reg
external func PbGetVol(pb: ptr): int = trap 0xA014 reg
```

(`ioFlStBlk`@52 overlaps `ioDrNmFls` — one `word` named `ioDrNmFls` covers both; `pad[8]` after `fdCreator` covers `fdFlags`/`fdLocation`/`fdFldr`; trailing `pad[32]` reaches 108. Verify the total with `sizeof`-style arithmetic in the report.) The probe sequence, each step logging OSErr + values via `tkFail` detail strings so the log carries the numbers even on success (mirror `cases_finfo.cla`'s `detail` building):

1. `PbDirCreate` `":ProbeA"` (`ioNamePtr` → `rtFh68kName`-style buffer built with `SerNewPtr`/`pokeb` — copy the 10-line function into the probe, `ioVRefNum = 0`, `ioDirID = 0`, sel 6) → expect 0; read back `ioDirID` (DirCreate returns the new DirID there).
2. `PbDirCreate` `":ProbeA:B"` → 0. `PbDirCreate` `":ProbeA"` again → expect `dupFNErr` (-48).
3. `file.create(":ProbeA:B:x.dat", "TEXT", "CLRS")`, `writeAt(0, "hello")`, `close`; `file.open(":ProbeA:B:x.dat")`, `size()` → 5. **This is the nested-partial-path spike.**
4. `PbGetVol` (`ioNamePtr` → 256-byte buffer, `ioVRefNum = 0`) → volume name; `file.open(volName + ":ProbeA:B:x.dat")` → **full-path spike**; record success/OSErr.
5. `PbGetCatInfo` by name on `":ProbeA:B"` (`ioFDirIndex = 0`, `ioDirID = 0`, `ioACUser = 0`, sel 9) → expect `ioFlAttrib & 0x10 != 0`, `ioDrNmFls == 1`, record `ioDirID`.
6. Enumerate: loop `ioFDirIndex = 1, 2, …` with `ioVRefNum = 0`, `ioDirID = <step-5 DirID>`, `ioNamePtr` → a fresh 256-byte buffer (the trap WRITES the name there) → expect one hit `x.dat` (`ioFlLgLen == 5`, `ioFlAttrib & 0x10 == 0`) then `fnfErr` (-43). Then the same loop with `ioDirID = 0` and `ioVRefNum = 0` → does it enumerate the DEFAULT folder (expect `ProbeA` and the suite's own files among the hits)? Record.
7. `PbHRename` `":ProbeA:B:x.dat"` → `ioMisc` = buffer `"y.dat"`, `ioDirID = 0` → 0; `file.open(":ProbeA:B:y.dat")` succeeds.
8. `PbCatMove` `ioNamePtr` = `":ProbeA:B:y.dat"`, `ioNewName` = `":ProbeA"`, `ioNewDirID = 0`, `ioDirID = 0`, sel 5 → 0; `file.open(":ProbeA:y.dat")` succeeds.
9. `PbHDelete` `":ProbeA:B"` (empty now) → 0; `PbHDelete` `":ProbeA"` (non-empty) → expect `fBsyErr` (-47); `PbHDelete` `":ProbeA:y.dat"` → 0; `PbHDelete` `":ProbeA"` → 0.

- [ ] **Step 3: Run on Mini vMac (System 6)**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run TestToolboxSuiteOn68k -v 2>&1 | tail -60`
Expected: the probe subtest's detail line carries every step's numbers. If any step hangs the boot, bisect by disabling steps (the toolbox boot is the busy-heap environment the binary-files phase found matters).

- [ ] **Step 4: Run on Snow (System 7)**

Build the toolbox suite GUI as a native app (`scripts/build-68k.sh` with the stage-2 compiler per Global Constraints, `testsuite/kit.cla testsuite/toolbox/runner.cla testsuite/toolbox/cases_*.cla testsuite/toolbox/gui.cla --events <the events file TestToolboxSuiteOn68k uses — find it in internal/mactest/coresuite_test.go>`), copy onto the Snow playground disk the way `internal/mactest/serial_snow_test.go` documents, boot, and read the `tkReport` log. Use a distinct `--serial-bridge-a` port per session and `pgrep -f Snow` before any screenshot-driven boot (project memory). Record System 7 differences (expected: none).

- [ ] **Step 5: Locate the prelude splice point and measure emit68k identity**

In `clarusc/drive.cla`, trace how `combined` (user-only chain, checked at ~2104 as the standalone gate) and `combined2` (runtime-spliced chain, ~1808) are built. Identify the ONE place a `prelude.cla` module read via the same runtime-module reader (`rtdir`/`'CLFS'` path, `drive.cla:587-700`) can be prepended to BOTH chains so `record FileInfo` is in scope for the standalone check AND the whole-program check without being declared twice. Then measure: write `/private/tmp/.../probe_rec.cla` = `examples/bounce.cla` (or any frozen-scenario program) with an unused `record ProbeInfo { size: int  rsrcSize: int  type: string  creator: string  created: int  modified: int  isDir: bool }` added at top; `emit68k` both variants with the stage-2 compiler; `cmp` the `.bin`s. Also `emit` (C) both and note the diff is only the typedef + retain/release helpers. Record: byte-identical or not; if not, which cg68k table grew (this becomes a Task 3 sub-step).

- [ ] **Step 6: Confirm a record-returning runtime call shape**

Write a 15-line throwaway program: `record R { a: int  b: bool  s: string }`, `func mk(): R { var r: R  r.a = 7  r.s = "x"  return r }`, `on App.launch { var r: R  r = mk()  print(r.a) }` (use whatever the harness's print/log idiom is — `testdata/run/fileh_basic.cla` shows it). Build with `scripts/clarus-run.sh`-equivalent stage-2 on the host AND `emit68k` + a vMac boot (a `testdata/run`-style run on the native lane is what `internal/mactest/native_test.go`'s runerr/run fixtures do — reuse that harness by hand). Expected: `7` on both lanes. This proves `newIRCallFn` with a `KRec` result type needs nothing new for Task 3.

- [ ] **Step 7: Write the report and revert scratch**

`task-1-report.md` sections (a)–(e) per Interfaces. Then `git checkout -- testsuite/toolbox/runner.cla && rm testsuite/toolbox/cases_probe.cla`; `git status` must be clean except `.superpowers/sdd/`. Commit ONLY the ledger: `git add .superpowers/sdd && git commit -m "docs: filesystem-api Task 1 probe report"`.

---

