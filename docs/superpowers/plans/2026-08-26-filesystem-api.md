# Filesystem API Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the `file` namespace `makeDir`/`delete`/`list`/`exists`/`info`/`setInfo`/`rename`/`move` on both lanes, a predeclared `FileInfo` record, HFS-path handling on the host lane, and host C twins for the public `SecondsToDate`/`DateToSeconds`/`ReadDateTime` catalog externs.

**Architecture:** A probe wave first settles the three unknowns on real (emulated) hardware and in `drive.cla` (nested/full-path opens, `PBGetCatInfo` index enumeration under `ioVRefNum = 0`, and where a prelude module can be spliced ahead of the standalone user check). Then feature by feature, each task leaving a tested surface: the `toolbox/files.cla` catalog fill; the `FileInfo` prelude + `exists`/`info` end to end on the host (the only novel compiler shapes — a by-name record return spec and a prelude splice); the six remaining calls on the host + HFS path translation; the native `fileh_68k.cla` lane for all eight, proved by the core suite's native boot; the host date glue; close-out. Every call follows the `filehandle` template: `fileFuncs` entry → `lowFileCall` arm → `rtFh*` in `fileh.cla` → lane-neutral `rtFhDev*` in `fileh_c.cla` (C bodies in `rt_fileh.inc`) and `fileh_68k.cla` (PB traps).

**Tech Stack:** Clarus (`clarusc/*.cla` compiler, `runtime/clarus/*.cla` runtime), C host glue (`runtime/host/*.inc`, `rt.c`), Go test harness (`internal/*`), Mini vMac (System 6 suite lane) and Snow (System 7 Mac II) emulators, Universal Interfaces 3.4 (`Retro68/InterfacesAndLibraries`) as the sole trap-verification source.

**Spec:** `docs/superpowers/specs/2026-08-26-filesystem-api-design.md` — read it first; every task below argues from it. Section references (`§3`, `§4.3`, …) are to the spec.

## Global Constraints

- Branch: all work on `filesystem-api` (already created from `main`; the spec is its first commit, `563fe7f`). Merge only on Andrew's explicit request; `main` stays green.
- SDD ledger: `.superpowers/sdd/2026-08-26-filesystem-api/` (`progress.md` + per-task briefs/reports/reviews). Never delete it (project memory rule: SDD workspaces are phase records).
- After every task: `scripts/test-task.sh --smoke` (every task touches `runtime/` or `clarusc/`; `--smoke` is mandatory per CLAUDE.md). Go tests always `-count=1`. `internal/selfhost` only at phase close, `-count=1 -timeout 30m`.
- Emulator-gated tests need `CLARUS_MAC_TESTS=1`. Snow (`CLARUS_SNOW_TESTS=1`) only where a task says so; the standing `TestClarusCBakePathOnSnow` rerun (~55 min) happens once at close-out because a runtime module is added (Task 3) — controller-run.
- Trap words and PB field offsets are NEVER trusted from memory or this plan: verify each against `Retro68/InterfacesAndLibraries/Interfaces/CIncludes/Files.h` (corroborate `AIncludes/Files.a`), decoding inline words per `toolbox/files.cla`'s provenance-comment convention (`files.cla:58-97` is the model block). Both headers are CR-delimited: reflow with `LC_ALL=C tr '\r' '\n' < FILE > /tmp/x` and cite the reflowed line numbers (the spec's §4.6 numbers are reflowed numbers). Values in this plan are labeled *expected*; the headers are authoritative.
- Before editing any `.cla` file, check for non-ASCII bytes (`LC_ALL=C grep -nP '[\x80-\xff]' FILE`); if any, do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (project memory rule). `grep` in this repo's shell may be aliased; use `/usr/bin/grep -a` when output looks empty.
- The Go harness builds a stage-2 clarusc from `clarusc/*.cla` (`internal/claruscboot`), so compiler edits take effect without a snapshot regen; `scripts/clarus-run.sh`/`scripts/build-68k.sh` use the committed `clarusc/clarusc.c` snapshot and will NOT see new `file.*` calls until Task 7 regenerates it. For manual native runs mid-branch, build a stage-2 compiler by hand: `cc -O1 -I runtime/host -o build-run/clarusc0 clarusc/clarusc.c runtime/host/rt.c && build-run/clarusc0 emit --rtdir runtime/clarus/ -o build-run/clarusc2.c clarusc/*.cla && cc -O1 -I runtime/host -o build-run/clarusc2 build-run/clarusc2.c runtime/host/rt.c` (check `scripts/build-68k.sh` for the exact file list it passes — `clarusc/*.cla` positionally is the documented shape).
- Golden policy: Tasks 2–6 are expected to produce ZERO emit68k/emitui golden churn. New runtime routines are tree-shaken out of programs that don't call them, and `fileh*.cla` has no globals except `rtFh68kLastErr` (already present) plus the two new module-level cursors this plan adds in Task 5 — those ARE new runtime globals on the native lane and WILL renumber later globals' A5 offsets in every cg68k/emitui golden (the transfer-crcs phase's lesson: two new globals → full rebless). Task 5 therefore avoids module-level globals (its cursor state lives in a lazily-`SerNewPtr`'d block reached through `rtFh68kLastErr`'s existing neighbour — see Task 5 Step 3) so no rebless is planned. If a golden churns anyway, STOP and explain the churn in the task report before touching it.
- The prelude (Task 3) adds a record type to every program. `cpEmitRecords` emits every `irRecords` entry, so host C output changes for every program (acceptable — the C printer is not a golden lane), but `emit68k` output must stay byte-identical for programs that never touch `FileInfo`. Task 1 measures this before Task 3 commits to the approach.
- reftest: new ```` ``` ```` fences in the reference shift every later fence's `Index`; `internal/reftest/manifest.go` may go red mid-branch and its regeneration is ALWAYS the branch's final step (Task 7).
- Counts drift: `testsuite/core/runner.cla`'s `nCoreCases` + `SelfCheck`, `internal/mactest/coresuite_test.go:34`'s `wantCoreSuiteCases`, `internal/mactest/suite_host_test.go`'s `coreCLIFiles` (~line 131), and `internal/bake/bakeidentity_test.go`'s `coreSuiteGUIFiles` (~line 1402) must ALL move together every time a `cases_*.cla` file or case is added. Read the CURRENT literals before editing; trust the files, not this plan's numbers.
- Subagent models: `sonnet` for implementation and review tasks, `haiku` only for mechanical batch edits, `opus` for a hard debugging detour; never Fable. State each subagent's model at dispatch.
- Commit after every task (prefix `feat:`/`fix:`/`test:`/`docs:`).

## File map (who owns what)

- `toolbox/files.cla` — `PBGetCatInfoSync`/`PBSetCatInfoSync`/`PBDirCreateSync`/`PBCatMoveSync` (HFSDispatch, selector in D0), `PBHDeleteSync`/`PBHRenameSync`/`PBHGetFInfoSync`/`PBHSetFInfoSync`/`PBHOpenRFSync`, records `HFileParam`/`CInfoPBRec`/`CMovePBRec`, consts (Task 2). `internal/testsuite/catalog_test.go` — driver symbols (Task 2). `docs/clarus-toolbox-cookbook.md` — HFSDispatch walkthrough (Task 2).
- `runtime/clarus/prelude.cla` (new: `record FileInfo`) — Task 3. `clarusc/drive.cla` — prelude splice (Task 3). `clarusc/bake.cla` — module list (Task 3). `clarusc/check.cla` — `psRecNamed`, eight `fileFuncs` entries, `usesFileh` widening (Tasks 3, 4). `clarusc/lower.cla` — eight `lowFileCall` arms (Tasks 3, 4).
- `runtime/clarus/fileh.cla` — `rtFhExists`/`rtFhInfo` (Task 3), `rtFhMakeDir`/`rtFhDelete`/`rtFhList`/`rtFhSetInfo`/`rtFhRename`/`rtFhMove` (Task 4). `runtime/clarus/fileh_c.cla` + `runtime/host/rt_fileh.inc` — host `rtFhDev*`/`FhH*` twins (Tasks 3, 4); `rt_fileh.inc` also gains `rt_fh_posix_path` and `runtime/host/rt.c`'s `path_to_cstr` routes through it (Task 4). `runtime/host/rt_fileh_test.c` — C harness additions (Tasks 3, 4).
- `runtime/clarus/fileh_68k.cla` — native `rtFhDev*` for all eight (Task 5).
- `runtime/host/rt_ext_host.inc` — `rt_ext_ReadDateTime`/`rt_ext_SecondsToDate`/`rt_ext_DateToSeconds` (Task 6). `testdata/run/datecat.cla` + `.behavior` (Task 6).
- `testsuite/core/cases_dirops.cla` (new: `DirOps`) + `testsuite/core/runner.cla` + the three Go count/file-list mirrors (Task 4; extended Task 5). `testdata/run/dirops_host.cla` + `.behavior` (Task 4). `testdata/errors/file_*.cla` + `.expect` (Task 3, 4).
- `docs/clarus-language-reference.md` (Tasks 3, 4, 6), `clarusc/clarusc.c` snapshot, `STATUS.md`, `docs/ROADMAP.md`, `docs/HISTORY.md`, `docs/TODO.md`, `CLAUDE.md`, `internal/reftest/manifest.go` (Task 7); `../68kbbs/docs/language-gaps.md` (Task 7, separate repo commit).

---

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

### Task 2: `toolbox/files.cla` — HFS catalog/directory traps + records

**Files:**
- Modify: `toolbox/files.cla` (append after the `fsFromMark` const block at the end).
- Modify: `internal/testsuite/catalog_test.go` (the `catalogDriver` handler body, ~lines 95-110, already references `PBGetFInfoSync`/`PBCreateSync`/`PBOpenRFSync`).
- Modify: `docs/clarus-toolbox-cookbook.md` (new §7 walkthrough after `## 6. Walkthrough: selector dispatch — LAddRow`, ~line 454).

**Interfaces:**
- Produces (used verbatim by Task 5): `extern record HFileParam`, `extern record CInfoPBRec`, `extern record CMovePBRec`; `external func PBGetCatInfoSync(paramBlock: ptr, selector: int): int`, `PBSetCatInfoSync(paramBlock: ptr, selector: int): int`, `PBDirCreateSync(paramBlock: ptr, selector: int): int`, `PBCatMoveSync(paramBlock: ptr, selector: int): int`, `PBHDeleteSync(paramBlock: ptr): int`, `PBHRenameSync(paramBlock: ptr): int`, `PBHGetFInfoSync(paramBlock: ptr): int`, `PBHSetFInfoSync(paramBlock: ptr): int`, `PBHOpenRFSync(paramBlock: ptr): int`; consts `hfsSelCatMove = 5`, `hfsSelDirCreate = 6`, `hfsSelGetCatInfo = 9`, `hfsSelSetCatInfo = 10`, `ioDirMask = 0x10`, `fsRtDirID = 2`, `dupFNErr = -48`, `fnfErr = -43`, `fBsyErr = -47`.

- [ ] **Step 1: Write the failing catalog check**

Extend `catalogDriver` in `internal/testsuite/catalog_test.go` so it binds at least one new symbol of each new kind. Insert after the existing `iop`-using lines:

```
    var ci: CInfoPBRec
    var hp: HFileParam
    var cm: CMovePBRec
    ci.ioNamePtr = ptr(0)
    ci.ioVRefNum = 0
    ci.ioFDirIndex = 0
    ci.ioDirID = 0
    err = PBGetCatInfoSync(ci, hfsSelGetCatInfo)
    hp.ioNamePtr = ptr(0)
    hp.ioDirID = 0
    err = PBDirCreateSync(hp, hfsSelDirCreate)
    err = PBHDeleteSync(hp)
    err = PBHRenameSync(hp)
    err = PBHGetFInfoSync(hp)
    err = PBHSetFInfoSync(hp)
    err = PBHOpenRFSync(hp)
    cm.ioNamePtr = ptr(0)
    cm.ioNewDirID = 0
    err = PBCatMoveSync(cm, hfsSelCatMove)
    if (ci.ioFlAttrib & ioDirMask) != 0 {
        t0 = t0 + 1
    }
```

(Match the surrounding code's variable-declaration placement — Clarus requires `var` lines at the top of the handler; move the three `var`s up.)

- [ ] **Step 2: Run to verify it fails**

Run: `go test -count=1 ./internal/testsuite -run 'TestCatalogChecks|TestCatalogComposesWithUIRuntime' -v 2>&1 | tail -20`
Expected: FAIL — `undefined: CInfoPBRec` (or the first unknown name).

- [ ] **Step 3: Append the declarations to `toolbox/files.cla`**

Follow the file's provenance-comment discipline exactly (every trap: the `#pragma parameter` line, the `EXTERN_API`/`INLINE` line with reflowed `Files.h` line numbers from Task 1's report, the `Files.a` macro corroboration, the bit-11 test, the convention conclusion; every record: the layout walk with offsets). The HFSDispatch block's comment must explain: `_HFSDispatch` (`0xA260`) is ONE trap word shared by the HFS routines, distinguished by a selector the glue preloads into D0 (`moveq #N,D0` — the `TWOWORDINLINE(0x70NN, 0xA260)` first word IS that `moveq`); bit 11 is clear so it is the register convention, so the selector is simply one more `reg`-bound parameter (`reg(a0: paramBlock, d0: selector) ret d0`) that the caller passes as a literal constant — NOT `seld0` (which is the Pascal-convention D0-selector shape, mutually exclusive with `reg`, reference ~line 1807). Declarations (offsets to be re-verified against Task 1's table; names of unused fields become `pad`):

```
// ---- HFS directory / catalog family (filesystem-api phase, Task 2) ...

extern record HFileParam {
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
    ioFlVersNum: byte
    fdType: int
    fdCreator: int
    fdFlags: word
    fdLocationV: word
    fdLocationH: word
    fdFldr: word
    ioDirID: int
    ioFlStBlk: word
    ioFlLgLen: int
    ioFlPyLen: int
    ioFlRStBlk: word
    ioFlRLgLen: int
    ioFlRPyLen: int
    ioFlCrDat: int
    ioFlMdDat: int
}

extern record CInfoPBRec {
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
    ioFlBkDat: int
    pad[16]
    ioFlParID: int
    ioFlClpSiz: int
}

extern record CMovePBRec {
    qLink: ptr
    qType: word
    ioTrap: word
    ioCmdAddr: ptr
    ioCompletion: ptr
    ioResult: word
    ioNamePtr: ptr
    ioVRefNum: word
    filler1: int
    ioNewName: ptr
    filler2: int
    ioNewDirID: int
    pad[8]
    ioDirID: int
}

external func PBGetCatInfoSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBSetCatInfoSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBDirCreateSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBCatMoveSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBHDeleteSync(paramBlock: ptr): int = trap 0xA209 reg
external func PBHRenameSync(paramBlock: ptr): int = trap 0xA20B reg
external func PBHGetFInfoSync(paramBlock: ptr): int = trap 0xA20C reg
external func PBHSetFInfoSync(paramBlock: ptr): int = trap 0xA20D reg
external func PBHOpenRFSync(paramBlock: ptr): int = trap 0xA20A reg

const hfsSelCatMove: int = 5
const hfsSelDirCreate: int = 6
const hfsSelGetCatInfo: int = 9
const hfsSelSetCatInfo: int = 10

const ioDirMask: int = 0x10
const fsRtDirID: int = 2

const fnfErr: int = -43
const fBsyErr: int = -47
const dupFNErr: int = -48
```

`CInfoPBRec` is declared as its `HFileInfo` variant; the comment lists the `DirInfo` overlaps a caller reads for a folder (`ioDrDirID` = `ioDirID`@48, `ioDrNmFls`@52 = `ioFlStBlk`'s slot, `ioDrCrDat`@76 = `ioFlCrDat`'s slot? — NO: verify; `DirInfo` has `filler3[9]` after `ioDrNmFls`, so `ioDrCrDat` is @72 = `ioFlCrDat`'s slot only if the arithmetic in Task 1's report says so; cite the report). `PBHRename`'s new name travels in `ioMisc`@28 — declare it on `HFileParam` by naming the `ioFDirIndex`/`ioFlAttrib`/`ioFlVersNum` slots… no: `ioMisc` lives in the `HIOParam` variant at offset 28 overlapping `ioFDirIndex`+`ioFlAttrib`+`ioFlVersNum`. Rather than a second record, add a separate small `extern record HIOParamRename { ... ioNamePtr: ptr  ioVRefNum: word  ioRefNum: word  ioVersNum: byte  ioPermssn: byte  ioMisc: ptr  pad[16]  ioDirID: int }` sized 52 — confirm offsets (`ioMisc`@28, `ioDirID`@48) against Task 1's table.

Also update the file's header comment: it says "DELIBERATELY THIN"; replace that paragraph with one sentence noting the filesystem-api phase filled the HFS directory/catalog family and pointing at this block.

- [ ] **Step 4: Run the catalog tests**

Run: `go test -count=1 ./internal/testsuite -run 'TestCatalogChecks|TestCatalogComposesWithUIRuntime' -v 2>&1 | tail -20`
Expected: PASS (both lanes compose).

- [ ] **Step 5: Cookbook walkthrough**

Add `## 7. Walkthrough: _HFSDispatch — a selector in D0 under the register convention` to `docs/clarus-toolbox-cookbook.md` after §6: quote `PBGetCatInfoSync`'s `TWOWORDINLINE(0x7009, 0xA260)`, decode `0x7009` as `MOVEQ #9,D0`, apply the bit-11 test, show the resulting `reg(a0: paramBlock, d0: selector) ret d0` declaration and a call `PBGetCatInfoSync(ci, hfsSelGetCatInfo)`, and contrast with §6's `sel` and the reference's `seld0` (why neither applies: both are Pascal-convention shapes). ~40 lines.

- [ ] **Step 6: T1 + commit**

Run: `scripts/test-task.sh --smoke 2>&1 | tail -15`
Expected: all PASS.

```bash
git add toolbox/files.cla internal/testsuite/catalog_test.go docs/clarus-toolbox-cookbook.md
git commit -m "feat: toolbox/files.cla HFS catalog/directory family (GetCatInfo/DirCreate/CatMove via _HFSDispatch, HDelete/HRename/HGetFInfo/HSetFInfo/HOpenRF)"
```

---

### Task 3: `FileInfo` prelude + `file.exists`/`file.info` on the host

The novel compiler shapes live here: a runtime prelude spliced ahead of the standalone check, and a `fileFuncs` return type resolved by name. Host lane only; Task 5 adds the native `rtFhDev*` bodies.

**Files:**
- Create: `runtime/clarus/prelude.cla`.
- Modify: `clarusc/drive.cla` (splice point from Task 1's report; `neededMods` region ~1515-1595 for the full build), `clarusc/bake.cla:415-450` (module list mirror), `scripts/build-clarusc-mac.sh` (no change — globs `runtime/clarus/*.cla`; verify).
- Modify: `clarusc/check.cla` — `record ParamSpec` (~407), a `psRecNamed(nameIdx: int): int` constructor next to `psAnyRecordish` (~460), the matcher (~1802), `sigEnd`/`newMethodSig` return handling, `fileFuncs` init after `file.create` (~1698), the `x == cnFile` arm (~2019: widen `usesFileh`).
- Modify: `clarusc/lower.cla` — `lowFileCall` (~1714, after the `"create"` arm).
- Modify: `runtime/clarus/fileh.cla` (append), `runtime/clarus/fileh_c.cla` (externs + wrappers), `runtime/host/rt_fileh.inc` (C bodies), `runtime/host/rt_fileh_test.c`.
- Create: `testdata/run/dirops_info.cla` + `.behavior`; `testdata/errors/file_info_dup.cla` + `.expect`; `testdata/errors/file_exists_arity.cla` + `.expect`.
- Modify: `docs/clarus-language-reference.md` — Chapter 3 predeclared types (find the `error` type's paragraph, ~line 190-200 region or wherever `lastError`'s type is introduced) and the `### Files` table (~1440-1450).

**Interfaces:**
- Consumes: nothing from Task 2 (host lane).
- Produces: `record FileInfo { size: int  rsrcSize: int  type: string  creator: string  created: int  modified: int  isDir: bool }`; runtime `func rtFhExists(path: string): bool`, `func rtFhInfo(path: string): FileInfo`; lane contract `func rtFhDevStat(path: string): bool` (caches the last catalog record), `func rtFhDevStatSize(): int`, `rtFhDevStatRsrcSize(): int`, `rtFhDevStatType(): string`, `rtFhDevStatCreator(): string`, `rtFhDevStatCreated(): int`, `rtFhDevStatModified(): int`, `rtFhDevStatIsDir(): bool`; host externs `FhHStat(path: string): int` (0 ok / -1), `FhHStatField(which: int): int` (0 size, 1 rsrcSize, 2 created, 3 modified, 4 isDir); checker helper `psRecNamed`.

- [ ] **Step 1: Write the failing run fixture**

`testdata/run/dirops_info.cla` (host-only fixture; the harness is `internal/lowlevel`/`internal/mactest`'s `testdata/run` runner — read `testdata/run/fileh_basic.cla`'s header for the print idiom and `.behavior` format):

```
// filesystem-api Task 3: file.exists / file.info on the host lane, plus
// FileInfo as an ordinary value (copy, field access, list element).
record Holder {
    fi: FileInfo
    n: int
}

func show(fi: FileInfo) {
    if fi.isDir {
        print("dir")
    } else {
        print("file size " + string(fi.size))
    }
}

on App.startCLI(args: list of string) {
    var f: filehandle
    var fi: FileInfo
    var h: Holder
    var l: list of FileInfo
    var before: int

    before = now()
    if file.exists("dirops_info_missing.dat") {
        print("exists(missing) wrong")
    } else {
        print("exists(missing) ok")
    }
    fi = file.info("dirops_info_missing.dat")
    if fi.size == 0 and not fi.isDir and lastError.message == "info failed" {
        print("info(missing) ok")
    } else {
        print("info(missing) wrong")
    }

    f = file.create("dirops_info.dat", "TEXT", "CLRS")
    f.writeAt(0, "hello")
    f.close()

    if file.exists("dirops_info.dat") {
        print("exists ok")
    }
    fi = file.info("dirops_info.dat")
    show(fi)
    if fi.modified >= before and fi.created >= before {
        print("dates ok")
    } else {
        print("dates wrong")
    }
    if fi.rsrcSize == 0 and fi.type == "" {
        print("host fields ok")
    }
    h.fi = fi
    h.n = 1
    l.add(fi)
    show(h.fi)
    show(l[0])

    fi = file.info(".")
    show(fi)
}
```

`.behavior` (exact lines, matching the harness's `exit=0` / `--- stdout ---` header shown by `testdata/run/fileh_basic.behavior`):

```
exit=0
--- stdout ---
exists(missing) ok
info(missing) ok
exists ok
file size 5
dates ok
host fields ok
file size 5
file size 5
dir
```

Also `testdata/errors/file_info_dup.cla`: a program declaring `record FileInfo { x: int }` — `.expect`: `<file>:<line>:<col>: duplicate declaration FileInfo` (copy the exact wording from `checkRecordDecl`'s duplicate diagnostic; read it). And `testdata/errors/file_exists_arity.cla` with `file.exists()` → `.expect` `... wrong number of arguments` (same wording as `abort_arity.expect`).

- [ ] **Step 2: Run to verify they fail**

Run: `go test -count=1 ./internal/lowlevel -run 'TestRun/dirops_info|TestErrors/file_' -v 2>&1 | tail -20` (find the actual test names: `grep -n "func Test" internal/lowlevel/lowlevel_test.go`, and which package owns `testdata/run` per Global Constraints' grep — `internal/mactest/native_test.go` also reads `testdata/run`).
Expected: FAIL — `unknown file function exists` / `undefined: FileInfo`.

- [ ] **Step 3: Create the prelude and splice it**

`runtime/clarus/prelude.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// prelude.cla: predeclared PUBLIC types (filesystem-api phase, Task 3).
// Spliced by drive.cla ahead of the user program in BOTH the standalone
// user-code check and the full runtime-spliced build, on every lane and
// in check-only mode -- the one runtime module whose names user code may
// spell. Types only, never functions: the "clean standalone" gate's
// purpose (user code cannot name runtime functions) is untouched.
// FileInfo is what file.info(path) returns (reference Ch12: Files).

record FileInfo {
    size: int
    rsrcSize: int
    type: string
    creator: string
    created: int
    modified: int
    isDir: bool
}
```

`drive.cla`: at the splice point Task 1's report names, read `prelude.cla` through the same reader the other runtime modules use (`rtdir` / baked `'CLFS'`) and prepend its decl chain to `combined` (standalone) and ensure it is ALSO first in `combined2` (or simply always part of the user chain, so it flows into `combined2` naturally — whichever the report found). Add `"prelude.cla"` to `bake.cla`'s module list (the list `--bake-ir` mirrors, ~421-448) in the same position. If Task 1's Step 5 found emit68k output grows for an unused record, add the "referenced records only" gate to cg68k's layout emission here (report says where) — otherwise no cg68k change.

- [ ] **Step 4: Checker: `psRecNamed` and the two signatures**

In `check.cla`:

```
record ParamSpec {
    t: int
    anyCharArray: bool
    anyRecordish: bool
    recNameIdx: int
    kindCount: int
    ...
}
```

(set `recNameIdx = -1` in every existing constructor). Add:

```
// psRecNamed: a parameter/return spec naming a record TYPE by name,
// resolved at check time (filesystem-api Task 3) -- for the predeclared
// FileInfo, whose type index does not exist yet when this table is built.
func psRecNamed(nameIdx: int): int {
    var p: ParamSpec

    p.t = -1
    p.anyCharArray = false
    p.anyRecordish = false
    p.recNameIdx = nameIdx
    p.kindCount = 0
    p.kind1 = TyInvalid
    p.kind2 = TyInvalid
    p.kind3 = TyInvalid
    p.next = -1
    paramSpecs.add(p)
    return paramSpecs.count - 1
}
```

Return types: `sigEnd(ret)` takes a type index; add a parallel `sigEndNamed(retNameIdx: int)` that stores `-2` as `ret` and the name in a new `methodSigs` field `retNameIdx` (read `newMethodSig`'s record; add the field), and in `checkTableMethod` where the sig's return type is produced, resolve `retNameIdx` via `scopeLookup(universeScope, retNameIdx)` → `symbols[i].typeIdx` (the prelude has declared it by then). Signatures, after `fileFuncs["create"]`:

```
    // file.exists(path) / file.info(path) (filesystem-api spec %3).
    sigStart()
    sigAdd(psPlain(strT(255)))
    fileFuncs["exists"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    fileFuncs["info"] = sigEndNamed(intern("FileInfo"))
```

Widen `usesFileh` in the `x == cnFile` arm: `if name == "open" or name == "create" or name == "exists" or name == "info" { usesFileh = true }` (Task 4 extends the list again).

- [ ] **Step 5: Lowering**

In `lowFileCall`, after the `"create"` arm:

```
    } else if nm == "exists" {
        return newIRCallFn(intern("rtFhExists"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "info" {
        // file.info(path): FileInfo -- an ordinary record-returning runtime
        // call (prelude.cla declares FileInfo; fileh.cla's rtFhInfo returns
        // it by value, the same shape as any user function returning a record).
        return newIRCallFn(intern("rtFhInfo"), lowArgs(callArgsHead(e)), ty)
```

- [ ] **Step 6: Runtime, shared + host**

Append to `fileh.cla`:

```
// rtFhExists: true for an existing file or folder; never touches
// lastError (spec %3 -- existence is a question, not a failure).
func rtFhExists(path: string): bool {
    return rtFhDevStat(path)
}

// rtFhInfo: one device stat, then the seven scalar getters -- the device
// layer never sees FileInfo (spec %4.3), so fileh_c.cla/fileh_68k.cla
// stay layout-blind. On failure every field keeps its zero default and
// lastError is set.
func rtFhInfo(path: string): FileInfo {
    var fi: FileInfo

    if not rtFhDevStat(path) {
        rtSetLastErr(rtFhDevLastOSErr(), "info failed")
        return fi
    }
    fi.size = rtFhDevStatSize()
    fi.rsrcSize = rtFhDevStatRsrcSize()
    fi.type = rtFhDevStatType()
    fi.creator = rtFhDevStatCreator()
    fi.created = rtFhDevStatCreated()
    fi.modified = rtFhDevStatModified()
    fi.isDir = rtFhDevStatIsDir()
    return fi
}
```

`fileh_c.cla`: add `external func FhHStat(path: string): int` and `external func FhHStatField(which: int): int`, then:

```
func rtFhDevStat(path: string): bool {
    return FhHStat(path) == 0
}
func rtFhDevStatSize(): int { return FhHStatField(0) }
func rtFhDevStatRsrcSize(): int { return 0 }
func rtFhDevStatType(): string { return "" }
func rtFhDevStatCreator(): string { return "" }
func rtFhDevStatCreated(): int { return FhHStatField(2) }
func rtFhDevStatModified(): int { return FhHStatField(3) }
func rtFhDevStatIsDir(): bool { return FhHStatField(4) != 0 }
```

(one function per line only if the project's `.cla` style already does that — otherwise expand to the multi-line form the file uses.) `rt_fileh.inc`:

```
static struct stat rt_fh_stat_buf;

/* rt_ext_FhHStat: stat by path; 0 on success (fields via FhHStatField),
 * -1 + rt_fh_errno otherwise. */
int32_t rt_ext_FhHStat(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (stat(cpath, &rt_fh_stat_buf) != 0) {
        rt_fh_errno = errno;
        return -1;
    }
    return 0;
}

/* rt_ext_FhHStatField: 0 size, 2 created, 3 modified, 4 isDir -- from the
 * last successful FhHStat. Mac-epoch seconds via RT_MAC_EPOCH_DELTA and
 * the local-time offset, the same convention rt_dt_now_mac uses. */
int32_t rt_ext_FhHStatField(int32_t which) {
    switch (which) {
    case 0: return (int32_t)rt_fh_stat_buf.st_size;
    case 2:
#if defined(__APPLE__)
        return rt_fh_mac_time(rt_fh_stat_buf.st_birthtime);
#else
        return rt_fh_mac_time(rt_fh_stat_buf.st_ctime);
#endif
    case 3: return rt_fh_mac_time(rt_fh_stat_buf.st_mtime);
    case 4: return S_ISDIR(rt_fh_stat_buf.st_mode) ? 1 : 0;
    default: return 0;
    }
}
```

with `static int32_t rt_fh_mac_time(time_t t)` = `localtime_r` + `tm_gmtoff` + `RT_MAC_EPOCH_DELTA`, mirroring `rt_dt_now_mac` in `rt_ext_host.inc:380-387` (`rt_fileh.inc` is included after it in `rt.c`? — check include order; if `RT_MAC_EPOCH_DELTA` is defined in `rt_ext_host.inc`, `rt_fileh.inc` must come after it, else move the macro to `rt.h`). `path_to_cstr` is `static` in `rt.c` above the `#include`s at the bottom, so it is visible.

- [ ] **Step 7: Host C harness**

Add to `rt_fileh_test.c` (prototypes + a block after the existing round trip): `FhHStat` on the scratch file → 0, `FhHStatField(0) == <written size>`, `FhHStatField(4) == 0`; `FhHStat(".")` → 0, field 4 == 1; `FhHStat("nope")` → -1, `FhHErrno() == ENOENT`.

Run: `go test -count=1 ./internal/hostrt -run TestFilehC -v 2>&1 | tail -5`
Expected: PASS.

- [ ] **Step 8: Run the fixtures**

Run: the same command as Step 2.
Expected: PASS for `dirops_info` and both error fixtures. If `TestErrors`' duplicate-record wording differs, fix the `.expect`, not the compiler.

- [ ] **Step 9: Reference**

`### Files` table: add the `exists` and `info` rows from spec §3 verbatim. Chapter 3: after the paragraph introducing `error`/`lastError`'s type (find it), add a `FileInfo` paragraph: predeclared record, the seven fields with the spec's comments, "returned by `file.info` (Chapter 12); a program may not declare its own `FileInfo`". No new code fence (reftest), or note the fence shift for Task 7.

- [ ] **Step 10: Golden identity check, T1, commit**

Run: `go test -count=1 ./internal/cg68k ./internal/emitui 2>&1 | tail -5` — Expected: PASS with no golden diffs (the prelude must be output-neutral on the native lane; see Global Constraints).
Run: `scripts/test-task.sh --smoke 2>&1 | tail -15` — Expected: all PASS.

```bash
git add runtime/clarus/prelude.cla clarusc/drive.cla clarusc/bake.cla clarusc/check.cla clarusc/lower.cla runtime/clarus/fileh.cla runtime/clarus/fileh_c.cla runtime/host/rt_fileh.inc runtime/host/rt_fileh_test.c testdata/run/dirops_info.* testdata/errors/file_info_dup.* testdata/errors/file_exists_arity.* docs/clarus-language-reference.md
git commit -m "feat: FileInfo prelude record + file.exists/file.info (host lane)"
```

---

### Task 4: `makeDir`/`delete`/`list`/`setInfo`/`rename`/`move` on the host + HFS path translation + `DirOps` core case

**Files:**
- Modify: `clarusc/check.cla` (six `fileFuncs` entries after `info`; `usesFileh` list), `clarusc/lower.cla` (six arms), `runtime/clarus/fileh.cla`, `runtime/clarus/fileh_c.cla`, `runtime/host/rt_fileh.inc`, `runtime/host/rt.c:105-109` (`path_to_cstr`), `runtime/host/rt_fileh_test.c`.
- Create: `testsuite/core/cases_dirops.cla`; `testdata/errors/file_setinfo_4cc.cla` + `.expect`.
- Modify: `testsuite/core/runner.cla` (four sites + `nCoreCases`), `internal/mactest/coresuite_test.go:34`, `internal/mactest/suite_host_test.go` (`coreCLIFiles`), `internal/bake/bakeidentity_test.go` (`coreSuiteGUIFiles`), `docs/clarus-language-reference.md`.

**Interfaces:**
- Consumes: Task 3's `rtFhDevStat*` family, `FileInfo`.
- Produces: runtime `rtFhMakeDir(path): bool`, `rtFhDelete(path): bool`, `rtFhList(path: string, names: list of string): bool`, `rtFhSetInfo(path, ftype, fcreator: string, created, modified: int): bool`, `rtFhRename(path, newName: string): bool`, `rtFhMove(path, dirPath: string): bool`; lane contract `rtFhDevMakeDir(path): int` (OSErr/errno, 0 ok), `rtFhDevDelete(path): int`, `rtFhDevListBegin(path): bool`, `rtFhDevListNext(): string` (`""` = done), `rtFhDevListEnd()`, `rtFhDevSetInfo(path, ftype, fcreator: string, created, modified: int): int`, `rtFhDevRename(path, newName): int`, `rtFhDevMove(path, dirPath): int`; host externs `FhHMakeDir(path): int`, `FhHDelete(path): int`, `FhHListBegin(path): int`, `FhHListNext(buf: ptr): int` (writes a Pascal string into a 256-byte buffer; 0 = got one, 1 = done, -1 = error), `FhHListEnd()`, `FhHSetTimes(path, created, modified): int`, `FhHRename(path, newName): int`, `FhHMove(path, dirPath): int`.

- [ ] **Step 1: Write the failing `DirOps` core case**

`testsuite/core/cases_dirops.cla` (register per the four `FileHandleRW` sites in `runner.cla`: enum member before `SelfCheck` ~203, `case DirOps { return "DirOps" }` ~450, `l.add(DirOps)` ~549 before `SelfCheck`, dispatch block ~892; bump `nCoreCases` 78→79 and its comment; mirror in the three Go files per Global Constraints). Names use a `dirops_` prefix so the boot disk / cwd stays readable:

```
// cases_dirops.cla (filesystem-api Task 4): the directory/catalog surface
// end to end on both lanes -- makeDir, list, exists/info, setInfo, rename,
// move, delete -- in one case so the folder it makes is torn down by the
// same steps it proves.
func caseDirOps(): TestResult {
    var f: filehandle
    var names: list of string
    var fi: FileInfo
    var before: int
    var detail: string

    before = now()
    if file.exists(":DirOpsT") {
        // a previous aborted run: best-effort teardown so the case is rerunnable
        file.delete(":DirOpsT:Sub:b.dat")
        file.delete(":DirOpsT:Sub")
        file.delete(":DirOpsT:a.dat")
        file.delete(":DirOpsT:c.dat")
        file.delete(":DirOpsT")
    }
    if not file.makeDir(":DirOpsT") {
        return tkFail("DirOps", "makeDir failed " + tkIntToStr(lastError.code))
    }
    if file.makeDir(":DirOpsT") {
        return tkFail("DirOps", "makeDir twice succeeded")
    }
    if not file.makeDir(":DirOpsT:Sub") {
        return tkFail("DirOps", "makeDir Sub failed")
    }

    f = file.create(":DirOpsT:a.dat", "TEXT", "CLRS")
    if f == nil {
        return tkFail("DirOps", "create a.dat failed " + tkIntToStr(lastError.code))
    }
    f.writeAt(0, "hello")
    f.close()
    f = file.create(":DirOpsT:b.dat", "TEXT", "CLRS")
    if f == nil {
        return tkFail("DirOps", "create b.dat failed")
    }
    f.writeAt(0, "hi")
    f.close()

    if not file.list(":DirOpsT", names) {
        return tkFail("DirOps", "list failed " + tkIntToStr(lastError.code))
    }
    if names.count != 3 {
        return tkFail("DirOps", "list count " + tkIntToStr(names.count))
    }
    if not dirOpsHas(names, "a.dat") or not dirOpsHas(names, "b.dat") or not dirOpsHas(names, "Sub") {
        return tkFail("DirOps", "list names " + names[0] + "," + names[1] + "," + names[2])
    }

    fi = file.info(":DirOpsT:a.dat")
    if fi.size != 5 or fi.isDir {
        return tkFail("DirOps", "info a.dat size " + tkIntToStr(fi.size))
    }
    if fi.modified < before {
        return tkFail("DirOps", "info modified before now")
    }
    fi = file.info(":DirOpsT:Sub")
    if not fi.isDir {
        return tkFail("DirOps", "info Sub not dir")
    }

    if not file.setInfo(":DirOpsT:a.dat", "BINA", "68BB", 0, before - 86400) {
        return tkFail("DirOps", "setInfo failed " + tkIntToStr(lastError.code))
    }
    fi = file.info(":DirOpsT:a.dat")
    if fi.modified > before - 86400 + 5 or fi.modified < before - 86400 - 5 {
        return tkFail("DirOps", "setInfo modified not applied " + tkIntToStr(fi.modified))
    }

    if not file.move(":DirOpsT:b.dat", ":DirOpsT:Sub") {
        return tkFail("DirOps", "move failed " + tkIntToStr(lastError.code))
    }
    if not file.exists(":DirOpsT:Sub:b.dat") or file.exists(":DirOpsT:b.dat") {
        return tkFail("DirOps", "move not reflected")
    }
    if not file.rename(":DirOpsT:a.dat", "c.dat") {
        return tkFail("DirOps", "rename failed " + tkIntToStr(lastError.code))
    }
    if not file.exists(":DirOpsT:c.dat") or file.exists(":DirOpsT:a.dat") {
        return tkFail("DirOps", "rename not reflected")
    }

    if file.delete(":DirOpsT:Sub") {
        return tkFail("DirOps", "delete non-empty folder succeeded")
    }
    if not file.delete(":DirOpsT:Sub:b.dat") {
        return tkFail("DirOps", "delete b.dat failed")
    }
    if not file.delete(":DirOpsT:Sub") {
        return tkFail("DirOps", "delete Sub failed " + tkIntToStr(lastError.code))
    }
    if not file.delete(":DirOpsT:c.dat") {
        return tkFail("DirOps", "delete c.dat failed")
    }
    if not file.list(":DirOpsT", names) or names.count != 0 {
        return tkFail("DirOps", "list after delete count " + tkIntToStr(names.count))
    }
    if not file.delete(":DirOpsT") {
        return tkFail("DirOps", "delete DirOpsT failed")
    }
    if file.exists(":DirOpsT") {
        return tkFail("DirOps", "exists after delete")
    }
    if file.list(":DirOpsT", names) {
        return tkFail("DirOps", "list on missing folder succeeded")
    }
    return tkPass("DirOps")
}

func dirOpsHas(names: list of string, want: string): bool {
    var i: int

    i = 0
    while i < names.count {
        if names[i] == want {
            return true
        }
        i = i + 1
    }
    return false
}
```

Native-only assertions (`fi.type == "BINA"` after `setInfo`) are added in Task 5 behind a lane check if the kit exposes one (`tkIsNative()` or similar — read `testsuite/kit.cla`); otherwise they go in a separate toolbox-suite case in Task 5. Also `testdata/errors/file_setinfo_4cc.cla`: `file.setInfo("x", "TOOLONG", "CLRS", 0, 0)` → `.expect` = the literal-4CC diagnostic `lowCheckLiteral4CCArg` emits (copy `file.create type`'s wording from an existing `testdata/errors/*create*` fixture, substituting `file.setInfo type`). Note: that check fires only under `emit`, so the fixture belongs to whichever `testdata/` family exercises emit-time diagnostics (grep `lowCheckLiteral4CCArg`'s message in `testdata/`).

- [ ] **Step 2: Run to verify it fails**

Run: `cc -O1 -I runtime/host -o build-run/clarusc2 …` (stage-2 per Global Constraints), then the host CLI recipe from CLAUDE.md with `DirOps` as the arg.
Expected: compile error `unknown file function makeDir`.

- [ ] **Step 3: Checker + lowering**

`check.cla`, after `fileFuncs["info"]`:

```
    sigStart()
    sigAdd(psPlain(strT(255)))
    fileFuncs["makeDir"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    fileFuncs["delete"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(listT(strT(255))))
    fileFuncs["list"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(IntT))
    sigAdd(psPlain(IntT))
    fileFuncs["setInfo"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(strT(255)))
    fileFuncs["rename"] = sigEnd(BoolT)

    sigStart()
    sigAdd(psPlain(strT(255)))
    sigAdd(psPlain(strT(255)))
    fileFuncs["move"] = sigEnd(BoolT)
```

In the `x == cnFile` arm: replace the `usesFileh` condition with `if fileFuncs.has(name) and name != "readText" and name != "writeText" and name != "readResource" and name != "writeRes" and name != "save" and name != "load" and name != "name" { usesFileh = true }` (or a small helper `fileNameNeedsFileh(name)`); and `if name == "list" { checkRejectParamFill(exprNext(argsHead)) }` next to the existing `readText` guard (~2045).

`lower.cla`, after the `"info"` arm:

```
    } else if nm == "makeDir" {
        return newIRCallFn(intern("rtFhMakeDir"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "delete" {
        return newIRCallFn(intern("rtFhDelete"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "list" {
        return newIRCallFn(intern("rtFhList"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "setInfo" {
        lowCheckLiteral4CCArg(lowArgAt(callArgsHead(e), 1), "file.setInfo type")
        lowCheckLiteral4CCArg(lowArgAt(callArgsHead(e), 2), "file.setInfo creator")
        return newIRCallFn(intern("rtFhSetInfo"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "rename" {
        return newIRCallFn(intern("rtFhRename"), lowArgs(callArgsHead(e)), ty)
    } else if nm == "move" {
        return newIRCallFn(intern("rtFhMove"), lowArgs(callArgsHead(e)), ty)
```

- [ ] **Step 4: Shared runtime**

Append to `fileh.cla`:

```
func rtFhMakeDir(path: string): bool {
    if rtFhDevMakeDir(path) != 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "makeDir failed")
        return false
    }
    return true
}

func rtFhDelete(path: string): bool {
    if rtFhDevDelete(path) != 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "delete failed")
        return false
    }
    return true
}

// rtFhList: names is a reference (list), so filling it here reaches the
// caller (Ch7). One listing at a time -- the device cursor is a single
// module-level slot on each lane (spec %4.3).
func rtFhList(path: string, names: list of string): bool {
    var name: string

    names.clear()
    if not rtFhDevListBegin(path) {
        rtSetLastErr(rtFhDevLastOSErr(), "list failed")
        return false
    }
    name = rtFhDevListNext()
    while name != "" {
        names.add(name)
        name = rtFhDevListNext()
    }
    rtFhDevListEnd()
    return true
}

func rtFhSetInfo(path: string, ftype: string, fcreator: string, created: int, modified: int): bool {
    if rtFhDevSetInfo(path, ftype, fcreator, created, modified) != 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "setInfo failed")
        return false
    }
    return true
}

func rtFhRename(path: string, newName: string): bool {
    if rtFhDevRename(path, newName) != 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "rename failed")
        return false
    }
    return true
}

func rtFhMove(path: string, dirPath: string): bool {
    if rtFhDevMove(path, dirPath) != 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "move failed")
        return false
    }
    return true
}
```

- [ ] **Step 5: Host lane**

`fileh_c.cla` externs + wrappers (the `ListNext` wrapper builds a `string` from the Pascal buffer the same way `rtFh68kName` does in reverse — a 256-byte `SerNewPtr` block allocated in `ListBegin`, freed in `ListEnd`; copy bytes out with `peekb` into a `string` via `s.append(char(...))` or the `str.cla` idiom the runtime already uses for Pascal→string — grep `UiStrFromPascal`/`rtStrFromPStr` in `runtime/clarus/` and reuse it if present):

```
external func FhHMakeDir(path: string): int
external func FhHDelete(path: string): int
external func FhHListBegin(path: string): int
external func FhHListNext(buf: ptr): int
external func FhHListEnd()
external func FhHSetTimes(path: string, created: int, modified: int): int
external func FhHRename(path: string, newName: string): int
external func FhHMove(path: string, dirPath: string): int

func rtFhDevMakeDir(path: string): int { return FhHMakeDir(path) }
func rtFhDevDelete(path: string): int { return FhHDelete(path) }
func rtFhDevListBegin(path: string): bool {
    if FhHListBegin(path) != 0 {
        return false
    }
    rtFhListBuf = SerNewPtr(256)
    return true
}
func rtFhDevListNext(): string {
    var s: string
    var n: int
    var i: int

    if FhHListNext(rtFhListBuf) != 0 {
        return ""
    }
    n = peekb(rtFhListBuf)
    i = 0
    while i < n {
        s.append(char(peekb(rtFhListBuf + 1 + i)))
        i = i + 1
    }
    return s
}
func rtFhDevListEnd() {
    FhHListEnd()
    SerDisposePtr(rtFhListBuf)
    rtFhListBuf = ptr(0)
}
func rtFhDevSetInfo(path: string, ftype: string, fcreator: string, created: int, modified: int): int {
    return FhHSetTimes(path, created, modified)
}
func rtFhDevRename(path: string, newName: string): int { return FhHRename(path, newName) }
func rtFhDevMove(path: string, dirPath: string): int { return FhHMove(path, dirPath) }
```

`rtFhListBuf: ptr` is a module-level `var` in `fileh_c.cla` — host lane only, so it never touches native goldens. `rt_fileh.inc` bodies:

```
#include <dirent.h>
#include <sys/time.h>
#include <libgen.h>

/* rt_fh_posix_path: HFS spelling -> POSIX (spec %4.4): a leading ':' is
 * dropped, every other ':' becomes '/'. A path with no colon is unchanged;
 * a full path "Vol:a:b" becomes the relative "Vol/a/b". */
static void rt_fh_posix_path(char *buf) {
    char *s = buf;
    char *d = buf;
    if (*s == ':') s++;
    for (; *s; s++, d++) *d = (*s == ':') ? '/' : *s;
    *d = '\0';
}

int32_t rt_ext_FhHMakeDir(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (mkdir(cpath, 0777) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHDelete(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (remove(cpath) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

static DIR *rt_fh_dir = NULL;

int32_t rt_ext_FhHListBegin(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (cpath[0] == '\0') { cpath[0] = '.'; cpath[1] = '\0'; }
    if (rt_fh_dir) closedir(rt_fh_dir);
    rt_fh_dir = opendir(cpath);
    if (!rt_fh_dir) { rt_fh_errno = errno; return -1; }
    return 0;
}

/* 0 = wrote a Pascal-string name into buf (<= 255 bytes), 1 = done. */
int32_t rt_ext_FhHListNext(void *buf) {
    struct dirent *de;
    size_t n;
    if (!rt_fh_dir) return 1;
    for (;;) {
        errno = 0;
        de = readdir(rt_fh_dir);
        if (!de) return 1;
        if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0) continue;
        n = strlen(de->d_name);
        if (n > 255) n = 255;
        ((uint8_t *)buf)[0] = (uint8_t)n;
        memcpy((uint8_t *)buf + 1, de->d_name, n);
        return 0;
    }
}

void rt_ext_FhHListEnd(void) {
    if (rt_fh_dir) { closedir(rt_fh_dir); rt_fh_dir = NULL; }
}

/* created is ignored on POSIX (birth time is not settable); modified 0 =
 * leave unchanged. */
int32_t rt_ext_FhHSetTimes(const uint8_t *path, int32_t created, int32_t modified) {
    char cpath[256];
    struct timeval tv[2];
    (void)created;
    path_to_cstr(cpath, path);
    if (modified == 0) return 0;
    if (stat(cpath, &rt_fh_stat_buf) != 0) { rt_fh_errno = errno; return -1; }
    tv[0].tv_sec = rt_fh_stat_buf.st_atime; tv[0].tv_usec = 0;
    tv[1].tv_sec = rt_fh_unix_time(modified); tv[1].tv_usec = 0;
    if (utimes(cpath, tv) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHRename(const uint8_t *path, const uint8_t *newName) {
    char cpath[256], cnew[256], target[512], dirbuf[256];
    path_to_cstr(cpath, path);
    path_to_cstr(cnew, newName);
    strcpy(dirbuf, cpath);
    snprintf(target, sizeof target, "%s/%s", dirname(dirbuf), cnew);
    if (rename(cpath, target) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHMove(const uint8_t *path, const uint8_t *dirPath) {
    char cpath[256], cdir[256], target[512], basebuf[256];
    path_to_cstr(cpath, path);
    path_to_cstr(cdir, dirPath);
    if (cdir[0] == '\0') { cdir[0] = '.'; cdir[1] = '\0'; }
    strcpy(basebuf, cpath);
    snprintf(target, sizeof target, "%s/%s", cdir, basename(basebuf));
    if (rename(cpath, target) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}
```

`rt_fh_unix_time(int32_t mac)` is the inverse of Task 3's `rt_fh_mac_time` (subtract `RT_MAC_EPOCH_DELTA` and the local `tm_gmtoff`). **Path translation hook:** change `rt.c`'s `path_to_cstr` (line 105) to call `rt_fh_posix_path(buf)` after the memmove — but `rt_fileh.inc` is included BELOW; so move `rt_fh_posix_path` into `rt.c` directly above `path_to_cstr` (with the same comment), and every path-taking function in both files (`rt_file_read_text`, `rt_file_write_text`, `rt_file_save`, `rt_file_load`, `rt_file_name`, `FhHOpen`, `FhHCreate`, and the new ones) gets the translation for free through the ONE helper. Check `rt_file_name` — it returns a display name; after translation, take the last `/` component (it may already take the last `:`; make it do the POSIX split on the translated string).

- [ ] **Step 6: Host C harness**

`rt_fileh_test.c` additions: the translation table (`":a:b"`→`"a/b"`, `"a"`→`"a"`, `"Vol:x"`→`"Vol/x"` — test through `rt_ext_FhHMakeDir(":t1:sub")` after `mkdir("t1")`-equivalent calls, then `stat("t1/sub")`), `FhHListBegin("t1")`/`FhHListNext` sees `sub` exactly once then returns 1, `FhHRename`/`FhHMove` round trip, `FhHDelete` of a non-empty dir fails with `ENOTEMPTY`/`EEXIST`, then succeeds when empty; `FhHSetTimes` with `modified = <mac time>` then `FhHStat` field 3 matches.

Run: `go test -count=1 ./internal/hostrt -run TestFilehC -v 2>&1 | tail -5`
Expected: PASS.

- [ ] **Step 7: Run the core case on the host**

Run: the CLAUDE.md host-CLI recipe (stage-2 compiler; include `cases_dirops.cla` in the file list — it is `cases_*.cla` so the glob has it), `/tmp/core_cli DirOps` then `/tmp/core_cli all`.
Expected: `DirOps PASS`; `all` passes including `SelfCheck` (which needs `nCoreCases` bumped).

Run: `go test -count=1 ./internal/mactest -run TestCoreSuiteHost -v 2>&1 | tail -8` (the host suite test in `suite_host_test.go` — find its exact name) and `go test -count=1 ./internal/bake -run Identity 2>&1 | tail -3`.
Expected: PASS (file lists + counts consistent).

- [ ] **Step 8: Reference**

`### Files` table: add the six rows from spec §3 verbatim, plus the **Paths** and **Host behaviour** paragraphs from §3 after the existing `readResource`/`writeRes` paragraph.

- [ ] **Step 9: T1 + commit**

Run: `scripts/test-task.sh --smoke 2>&1 | tail -15` — Expected: all PASS, no golden churn.

```bash
git add clarusc/check.cla clarusc/lower.cla runtime/clarus/fileh.cla runtime/clarus/fileh_c.cla runtime/host/rt_fileh.inc runtime/host/rt.c runtime/host/rt_fileh_test.c testsuite/core/cases_dirops.cla testsuite/core/runner.cla internal/mactest/coresuite_test.go internal/mactest/suite_host_test.go internal/bake/bakeidentity_test.go testdata/errors/file_setinfo_4cc.* docs/clarus-language-reference.md
git commit -m "feat: file.makeDir/delete/list/setInfo/rename/move (host lane), HFS->POSIX host paths, DirOps core case"
```

---

### Task 5: Native lane — `fileh_68k.cla` for all eight calls, proved on Mini vMac

**Files:**
- Modify: `runtime/clarus/fileh_68k.cla` (append after `rtFhDevLastOSErr`, ~line 368).
- Modify: `testsuite/core/cases_dirops.cla` (native-only type/creator assertion).
- Read: Task 1's report (enumeration recipe, offsets), `toolbox/files.cla` (Task 2's declarations), `runtime/clarus/fileh_68k.cla:59-71` (`rtFh68kName`), `:145-211` (`rtFhDevCreate`'s `PBSetFInfoSync` stamp and `rtFourCC(UiStrAddr(...))` packing).

**Interfaces:**
- Consumes: Task 2's externs/records/consts; Task 3/4's `rtFhDev*` contract (identical names and signatures — this file must define every one of them or the native splice fails to check).
- Produces: nothing new; the lane is complete.

- [ ] **Step 1: Extend `DirOps` with the native-only assertion**

After the `setInfo` modified check, add:

```
    if fi.type != "" and fi.type != "BINA" {
        return tkFail("DirOps", "setInfo type not applied " + fi.type)
    }
    if fi.type != "" and fi.creator != "68BB" {
        return tkFail("DirOps", "setInfo creator not applied " + fi.creator)
    }
```

(`""` is the host's answer, so the assertion is lane-neutral without a lane flag.) Also assert `fi.rsrcSize == 0` for `a.dat` on both lanes.

- [ ] **Step 2: Run natively to verify it fails**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run TestCoreSuiteGUIOn68k -v 2>&1 | tail -30`
Expected: the build fails to check (`undefined: rtFhDevStat` — `fileh_68k.cla` lacks the new names).

- [ ] **Step 3: Implement the native device layer**

Append to `fileh_68k.cla`. Cursor state WITHOUT new module-level globals (Global Constraints: a new native runtime global renumbers every A5 offset → golden rebless): keep ONE existing-style global? No — `fileh_68k.cla` already has exactly one (`rtFh68kLastErr`). Adding `var`s here WOULD churn goldens. Instead allocate a 16-byte state block lazily with `SerNewPtr` on the first `ListBegin`/`Stat`, and hold its address in… a global is unavoidable for the pointer itself. Therefore: **one** new global `rtFh68kState: ptr` is the minimum (state block: `+0` cached-stat CInfoPBRec address (108 bytes, separately allocated once), `+4` list DirID, `+8` list index, `+12` list name buffer address). If Task 1's Step 5 measurement showed the prelude is output-neutral but this one global churns goldens, the task report explains the churn and reblesses ONCE with a normalization-diff proof (the transfer-crcs phase's procedure) — a planned exception to the zero-churn rule, confined to this task. Code:

```
var rtFh68kState: ptr

// rtFh68kStat: the lazily-allocated 108-byte CInfoPBRec every stat/list
// call reuses (+ the 256-byte name buffer for index enumeration).
func rtFh68kEnsureState() {
    if rtFh68kState == ptr(0) {
        rtFh68kState = SerNewPtr(16)
        pokel(rtFh68kState, int(SerNewPtr(108)))
        pokel(rtFh68kState + 12, int(SerNewPtr(256)))
    }
}

func rtFh68kZeroCInfo(p: ptr) {
    var i: int
    i = 0
    while i < 108 {
        pokel(p + i, 0)
        i = i + 4
    }
}

// rtFhDevStat: PBGetCatInfoSync by name (ioFDirIndex = 0, ioDirID = 0 =
// the default folder's own catalog, ioVRefNum = 0 = default volume).
// ioACUser cleared first (Files.a's own warning). The record stays in
// the state block for the seven getters below.
func rtFhDevStat(path: string): bool {
    var ci: CInfoPBRec
    var namePtr: ptr

    rtFh68kEnsureState()
    ci = CInfoPBRec(ptr(peekl(rtFh68kState)))
    rtFh68kZeroCInfo(ptr(peekl(rtFh68kState)))
    namePtr = rtFh68kName(path)
    ci.ioNamePtr = namePtr
    ci.ioVRefNum = 0
    ci.ioFDirIndex = 0
    ci.ioDirID = 0
    ci.ioACUser = 0
    rtFh68kLastErr = PBGetCatInfoSync(ci, hfsSelGetCatInfo)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr == 0
}
```

(`CInfoPBRec(ptr)` is the extern-record-overlay-from-address form — confirm the exact spelling in the reference's extern record section, ~line 1600-1640, "overlay"; if an extern record local `var ci: CInfoPBRec` is the only supported form, use the local and copy the seven scalars into the state block after the call instead.) Getters read the overlay: `rtFhDevStatIsDir` = `(ci.ioFlAttrib & ioDirMask) != 0`; `rtFhDevStatSize` = `ci.ioFlLgLen` if not dir else 0; `rtFhDevStatRsrcSize` = `ci.ioFlRLgLen` if not dir else 0; type/creator = 4-char strings from `fdType`/`fdCreator` (big-endian bytes → `string` via `char((v >> 24) & 0xFF)` etc.; `""` for a dir); created/modified = `ioFlCrDat`/`ioFlMdDat` (a dir's `ioDrCrDat`/`ioDrMdDat` sit at the offsets Task 1's table gives — if they differ from the file variant's, branch on isDir).

```
func rtFhDevListBegin(path: string): bool {
    if not rtFhDevStat(path) {
        return false
    }
    if not rtFhDevStatIsDir() {
        rtFh68kLastErr = -120    // dirNFErr: not a directory
        return false
    }
    pokel(rtFh68kState + 4, CInfoPBRec(ptr(peekl(rtFh68kState))).ioDirID)
    pokel(rtFh68kState + 8, 1)
    return true
}

func rtFhDevListNext(): string {
    var ci: CInfoPBRec
    var buf: ptr
    var s: string
    var n: int
    var i: int

    buf = ptr(peekl(rtFh68kState + 12))
    rtFh68kZeroCInfo(ptr(peekl(rtFh68kState)))
    ci = CInfoPBRec(ptr(peekl(rtFh68kState)))
    ci.ioNamePtr = buf
    ci.ioVRefNum = 0
    ci.ioDirID = peekl(rtFh68kState + 4)
    ci.ioFDirIndex = peekl(rtFh68kState + 8)
    ci.ioACUser = 0
    rtFh68kLastErr = PBGetCatInfoSync(ci, hfsSelGetCatInfo)
    if rtFh68kLastErr != 0 {
        return ""
    }
    pokel(rtFh68kState + 8, peekl(rtFh68kState + 8) + 1)
    n = peekb(buf)
    i = 0
    while i < n {
        s.append(char(peekb(buf + 1 + i)))
        i = i + 1
    }
    return s
}

func rtFhDevListEnd() {
}

func rtFhDevMakeDir(path: string): int {
    var hp: HFileParam
    var namePtr: ptr

    namePtr = rtFh68kName(path)
    hp.ioNamePtr = namePtr
    hp.ioVRefNum = 0
    hp.ioDirID = 0
    rtFh68kLastErr = PBDirCreateSync(hp, hfsSelDirCreate)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr
}

func rtFhDevDelete(path: string): int {
    var hp: HFileParam
    var namePtr: ptr

    namePtr = rtFh68kName(path)
    hp.ioNamePtr = namePtr
    hp.ioVRefNum = 0
    hp.ioDirID = 0
    rtFh68kLastErr = PBHDeleteSync(hp)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr
}

func rtFhDevSetInfo(path: string, ftype: string, fcreator: string, created: int, modified: int): int {
    var hp: HFileParam
    var namePtr: ptr

    namePtr = rtFh68kName(path)
    hp.ioNamePtr = namePtr
    hp.ioVRefNum = 0
    hp.ioFDirIndex = 0
    hp.ioDirID = 0
    rtFh68kLastErr = PBHGetFInfoSync(hp)
    if rtFh68kLastErr != 0 {
        SerDisposePtr(namePtr)
        return rtFh68kLastErr
    }
    hp.fdType = rtFourCC(UiStrAddr(ftype))
    hp.fdCreator = rtFourCC(UiStrAddr(fcreator))
    if created != 0 {
        hp.ioFlCrDat = created
    }
    if modified != 0 {
        hp.ioFlMdDat = modified
    }
    hp.ioDirID = 0
    rtFh68kLastErr = PBHSetFInfoSync(hp)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr
}

func rtFhDevRename(path: string, newName: string): int {
    var hp: HIOParamRename
    var namePtr: ptr
    var newPtr: ptr

    namePtr = rtFh68kName(path)
    newPtr = rtFh68kName(newName)
    hp.ioNamePtr = namePtr
    hp.ioVRefNum = 0
    hp.ioMisc = newPtr
    hp.ioDirID = 0
    rtFh68kLastErr = PBHRenameSync(hp)
    SerDisposePtr(newPtr)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr
}

func rtFhDevMove(path: string, dirPath: string): int {
    var cm: CMovePBRec
    var namePtr: ptr
    var dirPtr: ptr

    namePtr = rtFh68kName(path)
    dirPtr = rtFh68kName(dirPath)
    cm.ioNamePtr = namePtr
    cm.ioVRefNum = 0
    cm.ioNewName = dirPtr
    cm.ioNewDirID = 0
    cm.ioDirID = 0
    rtFh68kLastErr = PBCatMoveSync(cm, hfsSelCatMove)
    SerDisposePtr(dirPtr)
    SerDisposePtr(namePtr)
    return rtFh68kLastErr
}
```

`PBHGetFInfo` re-reads `ioDirID` as an output (the file's parent DirID) — `PBHSetFInfo` must be given the same name + `ioDirID = 0` (or the returned parent); the `hp.ioDirID = 0` reset before Set is deliberate. Comment every trap per the file's existing style (one paragraph per `rtFhDev*`, citing Task 1's report sections).

- [ ] **Step 4: Run natively**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run 'TestCoreSuiteGUIOn68k' -v 2>&1 | tail -30`
Expected: every subtest PASS including `DirOps`. If `DirOps` fails, the `tkFail` detail carries the OSErr — compare against Task 1's probe numbers before changing code.

- [ ] **Step 5: Snow spot check (System 7)**

Build the core GUI natively (stage-2 `build-68k.sh` with `--events` as `TestCoreSuiteGUIOn68k` does), boot on Snow per the serial-connection phase's `internal/mactest/*_snow_test.go` procedure, confirm `DirOps PASS` in the log. Record in the task report. (Not gated; a report line is the deliverable.)

- [ ] **Step 6: T1 + golden check + commit**

Run: `scripts/test-task.sh --smoke 2>&1 | tail -15`
Expected: PASS. If cg68k/emitui goldens churn from `rtFh68kState`, follow the Global Constraints rebless procedure and say so in the commit message.

```bash
git add runtime/clarus/fileh_68k.cla testsuite/core/cases_dirops.cla
git commit -m "feat: native fileh_68k lane for makeDir/delete/list/exists/info/setInfo/rename/move (PBGetCatInfo/DirCreate/CatMove/HDelete/HRename/HGet+SetFInfo)"
```

---

### Task 6: Host date glue for the public catalog externs

**Files:**
- Modify: `runtime/host/rt_ext_host.inc` (before the closing `#endif`, after `rt_ext_DtSecs2Date`).
- Create: `testdata/run/datecat.cla` + `.behavior`.
- Modify: `docs/clarus-language-reference.md` (the sentence at ~line 1722 naming `_SecondsToDate`/`_DateToSeconds` as register-based exceptions — add "both, plus `ReadDateTime`, have host C twins, so a host build that calls them links").

**Interfaces:**
- Produces: `int32_t rt_ext_ReadDateTime(void *t)`, `void rt_ext_SecondsToDate(int32_t secs, void *d)`, `int32_t rt_ext_DateToSeconds(void *d)` — the signatures cprint already emits for `toolbox/osutils.cla:134-146`'s externs (verify by compiling the fixture and reading the generated `extern` prototypes).

- [ ] **Step 1: Write the failing fixture**

`testdata/run/datecat.cla`:

```
// filesystem-api Task 6: the PUBLIC osutils date externs link and agree
// on the host lane. Vector: 1904-01-01 00:00:00 = 0; 2000-02-29 12:34:56.
include "toolbox/osutils.cla"

// the address ReadDateTime writes through (mirrors datetime_c.cla's DtSecsBox)
extern record SecsBox {
    secs: int
}

on App.startCLI(args: list of string) {
    var rec: DateTimeRec
    var box: SecsBox
    var secs: int
    var back: int

    SecondsToDate(0, rec)
    print(string(rec.year) + "-" + string(rec.month) + "-" + string(rec.day) + " dow " + string(rec.dayOfWeek))

    rec.year = 2000
    rec.month = 2
    rec.day = 29
    rec.hour = 12
    rec.minute = 34
    rec.second = 56
    secs = DateToSeconds(rec)
    print(string(secs))
    SecondsToDate(secs, rec)
    print(string(rec.year) + "-" + string(rec.month) + "-" + string(rec.day) + " " + string(rec.hour) + ":" + string(rec.minute) + ":" + string(rec.second))

    secs = now()
    SecondsToDate(secs, rec)
    back = DateToSeconds(rec)
    if back == secs {
        print("now round trip ok")
    } else {
        print("now round trip wrong")
    }
    if ReadDateTime(box) == 0 and box.secs != 0 {
        print("readdatetime ok")
    }
}
```

`.behavior` (exact; `1904-01-01` is a Friday = `dayOfWeek` 6; the vector is 3034672496 seconds, which as a signed Clarus `int` is `-1260294800`):

```
exit=0
--- stdout ---
1904-1-1 dow 6
-1260294800
2000-2-29 12:34:56
now round trip ok
readdatetime ok
```

- [ ] **Step 2: Run to verify it fails**

Run: the `testdata/run` harness for `datecat`.
Expected: link error `undefined symbol rt_ext_SecondsToDate`.

- [ ] **Step 3: Implement**

```
/* Host twins of the PUBLIC toolbox/osutils.cla date externs (filesystem-api
 * Task 6, spec %4.5) -- so a host build that calls the catalog names links.
 * ReadDateTime/SecondsToDate delegate to the private Dt* bodies above;
 * DateToSeconds is the inverse: Hinnant days-from-civil, day 0 = 1904-01-01.
 * Pinned on hardware by the toolbox suite's DateTimeRoundTrip and on the
 * host by testdata/run/datecat. */
int32_t rt_ext_ReadDateTime(void *t) {
    return rt_ext_DtReadDateTime(t);
}

void rt_ext_SecondsToDate(int32_t secs, void *d) {
    rt_ext_DtSecs2Date(secs, d);
}

int32_t rt_ext_DateToSeconds(void *d) {
    const int16_t *f = (const int16_t *)d;
    long y = f[0], m = f[1], day = f[2];
    long yy = m <= 2 ? y - 1 : y;
    long era = (yy >= 0 ? yy : yy - 399) / 400;
    long yoe = yy - era * 400;
    long mp = m > 2 ? m - 3 : m + 9;
    long doy = (153 * mp + 2) / 5 + day - 1;
    long doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
    long days = era * 146097 + doe - 695361L;      /* 719468 - 24107, DtSecs2Date's own shift */
    uint32_t secs = (uint32_t)days * 86400u + (uint32_t)f[3] * 3600u + (uint32_t)f[4] * 60u + (uint32_t)f[5];
    return (int32_t)secs;
}
```

- [ ] **Step 4: Run the fixture and the C-lane vector check**

Run: the `datecat` fixture; also add the 2000-02-29 vector as two `CHECK`s to `runtime/host/rt_rc_test.c`'s nearest sibling harness if one covers `rt_ext_host.inc` (`grep -l DtSecs2Date runtime/host/*_test.c`; if none, the fixture is the check).
Expected: PASS, output matches `.behavior` exactly.

- [ ] **Step 5: Reference + T1 + commit**

Edit the reference sentence per Files above.
Run: `scripts/test-task.sh --smoke 2>&1 | tail -15` — Expected: PASS.

```bash
git add runtime/host/rt_ext_host.inc testdata/run/datecat.* docs/clarus-language-reference.md
git commit -m "feat: host C twins for ReadDateTime/SecondsToDate/DateToSeconds catalog externs"
```

---

### Task 7: Close-out — snapshot, docs, ledger, 68kBBS gaps

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `internal/reftest/manifest.go` (regen), `STATUS.md`, `docs/ROADMAP.md`, `docs/HISTORY.md`, `docs/TODO.md`, `CLAUDE.md`, `docs/clarus-language-reference.md` (final read-through), `../68kbbs/docs/language-gaps.md` (separate repo, separate commit).

- [ ] **Step 1: Regenerate the bootstrap snapshot**

Run: `go test -count=1 -timeout 30m ./internal/selfhost -run TestSnapshotFixedPoint -v 2>&1 | tail -20` — it FAILS and prints the Go-free regeneration instructions; follow them exactly (stage-1 from the old snapshot → stage-2 from `clarusc/*.cla` → stage-3 → byte-compare stage-2/3 → copy into `clarusc/clarusc.c`). Re-run: Expected PASS.

- [ ] **Step 2: reftest manifest**

Run: `go test -count=1 ./internal/reftest 2>&1 | tail -5`. If red from fence shifts, regenerate per `internal/reftest/manifest.go:128`'s own note and re-run: Expected PASS.

- [ ] **Step 3: Docs**

- `docs/TODO.md`: new `### filesystem-api phase (2026-08-26)` subsections under "Language features" (resource-fork-as-bytes / `file.openRF`; `list of string(31)` element capacity — 256 B/entry ceiling; recursive makeDir; combined rename+move; `PBSetCatInfo` unused) and "Test coverage gaps" (Snow-only spot check not gated; full-path form verified only on the boot volume).
- `docs/ROADMAP.md`: "Where we are" paragraph + mark the filesystem-api item done; `docs/HISTORY.md`: the phase entry (what shipped, the `FileInfo` prelude mechanism, `psRecNamed`, the HFSDispatch `reg(d0: selector)` shape, host HFS path translation, the one global `rtFh68kState` and whether it reblessed, Task 1's findings incl. the full-path answer).
- `CLAUDE.md`: the `core` suite count line (78→79 with `DirOps`), the `toolbox/files.cla` catalog description (no longer thin), one sentence in the binary-files paragraph pointing at the filesystem-api surface, `runtime/clarus/prelude.cla` mention next to `--bake`.
- `STATUS.md`: rewrite the header for this phase (branch, base commit, per-task state, T2 result, NOT merged).
- `docs/clarus-language-reference.md`: read the whole `### Files` section once end to end for consistency (`info` returns, `exists` never sets `lastError`, paths paragraph).

- [ ] **Step 4: T2 gate**

Run: `scripts/test-merge.sh 2>&1 | tail -20` — Expected: PASS (selfhost + native mactest lane). Then the controller runs `CLARUS_SNOW_TESTS=1 go test -count=1 -timeout 90m ./internal/mactest -run TestClarusCBakePathOnSnow` once (runtime module added).

- [ ] **Step 5: Commit close-out; 68kBBS follow-up**

```bash
git add clarusc/clarusc.c internal/reftest/manifest.go STATUS.md docs/ROADMAP.md docs/HISTORY.md docs/TODO.md CLAUDE.md docs/clarus-language-reference.md
git commit -m "docs: filesystem-api close-out (snapshot regen, STATUS, ROADMAP, HISTORY, TODO, CLAUDE.md)"
```

Then in `../68kbbs`: edit `docs/language-gaps.md` — §1, §2, §3, §5, §6, §7 each get a "**Shipped** (2026-08-26) — as shipped: …" paragraph with the exact signatures (`file.list(path, names: list of string)` names-only, `file.info(path): FileInfo` returns, `file.exists`, `rename(path, newName)` + `move(path, dirPath)`), the Summary table rows marked shipped, the "One open question … spike" paragraph replaced with Task 1's full-path answer, and the fidonet.md spike list updated (nested partial paths: verified; `DateToSeconds` host glue: shipped). Commit there with `docs: language-gaps -- filesystem API shipped in Clarus (2026-08-26)`. Leave the pinned-toolchain bump to Andrew (the vendored runtime/toolbox copies under `vendor/` are his call).

---

## Self-review (done at plan time)

- Spec coverage: §3 rows → Tasks 3 (`exists`/`info`), 4 (the six); `FileInfo` text → Task 3 Step 9; Paths/Host behaviour → Task 4 Step 8; §4.1 → Task 3 Step 3 (+ Task 1 Step 5 measurement); §4.2 → Tasks 3/4; §4.3 → Tasks 3/4/5; §4.4 → Task 4 Step 5 (`path_to_cstr` hook, `rt_file_name` note); §4.5 → Task 6; §4.6 → Task 2; §4.7 → Task 7 (+ golden checks per task); §5 probe → Task 1, `DirOps` → Task 4/5, C harness → Tasks 3/4, catalog → Task 2, gates → each task + Task 7; §6 risks → Task 1 Step 5 (prelude), Task 5 Step 3 (global churn exception), Task 3 Step 6 (`st_birthtime`).
- Type consistency: `rtFhDev*` names/signatures listed identically in Task 3/4 Interfaces, Task 4 Step 5 (host) and Task 5 Step 3 (native); `FhH*` names identical between `fileh_c.cla` and `rt_fileh.inc`; `hfsSel*`/record names identical between Task 2 and Task 5; `HIOParamRename` is declared in Task 2 Step 3's trailing note and consumed in Task 5.
- Known plan-time uncertainty, deliberately delegated to Task 1: exact `drive.cla` splice point; `CInfoPBRec(ptr)` overlay spelling; whether `PBHRename`'s new name is `ioMisc` on the H variant (expected yes, `HIOParam.ioMisc`@28); `DirInfo` date offsets; whether `rtFh68kState` reblesses.
