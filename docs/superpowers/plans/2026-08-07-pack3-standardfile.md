# _Pack3 Standard File + cprint-Mac demotion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the real Open/Save dialogs work on native 68k builds via a new `toolbox/standardfile.cla` catalog file, demote the cprint/Retro68 Mac test lane to an opt-in diagnostic, and add include-path dedup to clarusc.

**Architecture:** Spec: `docs/superpowers/specs/2026-08-07-pack3-standardfile-design.md`. Part A (Task 1) teaches clarusc's include-once set to key on lexically normalized paths. Part B (Task 2) moves seven Retro68-gcc-path tests behind `CLARUS_CPRINT_MAC_TESTS=1`. Part C (Tasks 3–4) ships the _Pack3 catalog + minimal File Manager catalog and rewrites the two `nat_UiSF*` stubs as real trap calls. Tasks 5–6 are gate rehearsal and live-drive acceptance.

**Tech Stack:** Clarus (clarusc self-hosted compiler), Go test harnesses, Retro68 toolchain + Mini vMac (gated tests only).

## Global Constraints

- Branch: `pack3-standardfile` off `main`; merge only on explicit request.
- Clarus syntax rules that bite: ALL `var` declarations go at the top of a function body (mid-body `var` is a check error); `include` lines must be the leading declarations of a file (only comments and other `include`s may precede them).
- Every commit message ends with the standard Co-Authored-By/Claude-Session trailer.
- T1 (`scripts/test-task.sh`) after every task; it covers every package EXCEPT `internal/selfhost` (run selfhost tests directly with `-timeout 30m` when a task touches clarusc).
- clarusc bootstrap for manual commands (once per fresh tree):
  `cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c`
- Editing `clarusc/*.cla` makes `TestSnapshotFixedPoint` fail until the snapshot is regenerated (Task 1 Step 8).
- Editing `runtime/clarus/uidialogs.cla` makes `internal/cg68k` (listing goldens: `bounce.seg4.s`, `tickprobe.seg4.s`) and `internal/emitui` (every UI fixture's `.c.golden` embeds the spliced runtime) fail until re-blessed (Task 4 Steps 5–7).
- Do not edit any file under `Retro68/`, `toolchain/`, `macplus/` (symlinked toolchain trees).

---

### Task 1: clarusc include dedup by normalized path (Part A)

**Files:**
- Modify: `clarusc/main.cla` (new `normalizePath` next to `joinPath` ~line 96; hook at the top of `expand` ~line 152; retire the stale `ponytail:` comment on `seenPaths` ~line 38)
- Create: `testdata/incdedup/main.cla`, `testdata/incdedup/sub/a.cla`, `testdata/incdedup/sub/b.cla`, `testdata/incdedup/sub/common.cla`
- Create: `internal/lowlevel/incdedup_test.go`
- Modify: `docs/clarus-language-reference.md` (~line 89, include-once identity wording)
- Modify: `clarusc/clarusc.c` (regenerated snapshot, Step 8)

**Interfaces:**
- Produces: `func normalizePath(path: string): string` in clarusc/main.cla — lexical clean only. Later tasks rely on the *behavior*: `runtime/clarus/../../toolbox/standardfile.cla` and `toolbox/standardfile.cla` become one include-once identity.

- [ ] **Step 1: Write the failing test + fixtures**

`testdata/incdedup/sub/common.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// common.cla: shared leaf reached via two spellings by a.cla/b.cla --
// the incdedup fixture's whole point. One func; duplicated inclusion
// is a duplicate-declaration check error.
func common42(): int {
    return 42
}
```

`testdata/incdedup/sub/a.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

include "common.cla"
```

`testdata/incdedup/sub/b.cla` (same header comment style):
```
include "../sub/common.cla"
```

`testdata/incdedup/main.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// main.cla: includes common.cla through two path spellings (via a/b).
// Checks clean only if clarusc's include-once set keys on the
// NORMALIZED path (sub/common.cla == sub/../sub/common.cla).
include "sub/a.cla"
include "sub/b.cla"

on App.startCLI(args: list of string) {
    if common42() != 42 {
        quit 1
    }
    quit 0
}
```

`internal/lowlevel/incdedup_test.go` — mirror `internal/lowlevel/rtinc_test.go`'s exe-bootstrap and emit-invocation pattern EXACTLY (same helper to build/locate clarusc, same relative-path conventions). Two subtests:

```go
// TestIncludeDedup (pack3-standardfile Task 1): include-once identity is
// the lexically normalized path, not the raw spelling. main.cla reaches
// sub/common.cla as both "sub/common.cla" and "sub/../sub/common.cla";
// pre-fix that double-includes and fails the duplicate-decl check.
func TestIncludeDedup(t *testing.T) {
	// subtest "TwoSpellings": emit testdata/incdedup/main.cla -> must
	// succeed; emitted C must contain exactly ONE definition of
	// clar_fn_common42 (strings.Count(got, "clar_fn_common42(") over the
	// definition marker used by rtinc_test.go's own assertion style).
	// subtest "EntryFileDedup": emit with the SAME fixture named twice,
	// second spelling "testdata/incdedup/./main.cla" -> must succeed
	// (pre-fix: duplicate decls of everything in main.cla).
}
```
Write the real code following rtinc_test.go — the comment block above states the two subtests' exact assertions.

- [ ] **Step 2: Run to verify both subtests fail**

Run: `go test ./internal/lowlevel -run TestIncludeDedup -count=1 -v`
Expected: FAIL — clarusc exits nonzero with a duplicate-declaration diagnostic for `common42` (TwoSpellings) and for `main.cla`'s decls (EntryFileDedup).

- [ ] **Step 3: Implement `normalizePath` in clarusc/main.cla**

Place directly after `joinPath` (~line 103). All vars at top of body (check rule). `list of string` supports `.add`, `.pop()` (panics only on empty — guarded), `.count`, indexing.

```
// normalizePath lexically cleans a path for the include-once identity
// (seenPaths) and diagnostics: collapses "//" and "./" segments and
// resolves each "seg/.." pair, preserving a leading "/" and any leading
// "../" run. Purely lexical -- no symlink, case, or cwd resolution: an
// absolute and a relative spelling of the same file stay distinct
// (documented in the reference's include section).
func normalizePath(path: string): string {
    var segs: list of string
    var work: string
    var cur: string
    var junk: string
    var out: string
    var i: int
    var abs: bool

    abs = path.length > 0 and path[0] == '/'
    work = path + "/"
    cur = ""
    i = 0
    while i < work.length {
        if work[i] == '/' {
            if cur == ".." {
                if segs.count > 0 and segs[segs.count - 1] != ".." {
                    junk = segs.pop()
                } else if not abs {
                    segs.add("..")
                }
            } else if cur != "" and cur != "." {
                segs.add(cur)
            }
            cur = ""
        } else {
            cur = cur + work[i]
        }
        i = i + 1
    }
    out = ""
    if abs {
        out = "/"
    }
    i = 0
    while i < segs.count {
        if i > 0 {
            out = out + "/"
        }
        out = out + segs[i]
        i = i + 1
    }
    return out
}
```

Hook it in `expand` by renaming the parameter (do NOT assign to a parameter — rename it and derive the local):
```
func expand(rawPath: string, entry: bool): bool {
    var path: string
    ... (existing vars) ...

    path = normalizePath(rawPath)
    if seenPaths.has(path) {
```
Everything below the hook keeps using `path` unchanged (reads, `intern(path)`, `dirOf(path)`). Also replace the stale `ponytail:` comment block on `seenPaths` (main.cla:38-44) — it predicted exactly this upgrade ("Task 11 territory"); the new comment: keyed by `normalizePath`-cleaned path string, abs-vs-rel spellings still distinct by design.

- [ ] **Step 4: Rebuild the bootstrap compiler and run the test**

```sh
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
```
Wait — the committed snapshot does NOT contain the new code yet. The Go tests bootstrap clarusc from the SNAPSHOT, so `TestIncludeDedup` would still fail. Order of operations: first regenerate the snapshot from the edited source (this is safe — the OLD snapshot compiler compiles the NEW main.cla):
```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```
Then: `go test ./internal/lowlevel -run TestIncludeDedup -count=1 -v`
Expected: PASS (both subtests).

- [ ] **Step 5: Amend the language reference**

`docs/clarus-language-reference.md` ~line 89, the include-once sentence "(identity is the file's path, so two different files that both include a third common file each see its declarations exactly once, not duplicated)" — change to "(identity is the file's **lexically normalized** path — `.`/`..`/`//` segments are resolved textually, so two spellings of the same file dedup; an absolute and a relative spelling remain distinct — ...)" keeping the rest of the paragraph intact.

- [ ] **Step 6: Run the selfhost gates that pin clarusc**

Run: `go test ./internal/selfhost -run 'TestSnapshotFixedPoint|TestSnapshotBuilds|TestErrorGoldens|TestBehaviorGoldens' -count=1 -timeout 30m`
Expected: PASS. (`TestErrorGoldens` invokes fixtures as `../../testdata/errors/x.cla` — a leading-`..` run, preserved verbatim by normalizePath, so diagnostic paths in goldens are unchanged.)

- [ ] **Step 7: Full T1**

Run: `scripts/test-task.sh`
Expected: PASS (no runtime/*.cla touched yet, so no golden churn).

- [ ] **Step 8: Commit**

```sh
git add clarusc/main.cla clarusc/clarusc.c testdata/incdedup internal/lowlevel/incdedup_test.go docs/clarus-language-reference.md
git commit -m "feat(clarusc): include dedup by lexically normalized path"
```

---

### Task 2: cprint-Mac lane demotion (Part B)

**Files:**
- Modify: `internal/mactest/mac_test.go` (add `requireCprintMac` beside `requireMac` ~line 18; swap into `TestRunErrOnMac`, `TestAbortAppsOnMac`)
- Modify: `internal/mactest/coresuite_test.go` (swap in `TestCoreSuiteGUIOnMac` ~line 70, `TestToolboxSuiteOnMac` ~line 265)
- Modify: `internal/mactest/appres_test.go` (swap in `TestAppResNaming`/`TestAppResResources`/`TestAppResBundleBit`, lines 63/78/143)
- Modify: `scripts/test-merge.sh` (comment block only), `CLAUDE.md`, `docs/ROADMAP.md`

**Interfaces:**
- Produces: `requireCprintMac(t *testing.T)` — skips unless `CLARUS_CPRINT_MAC_TESTS` is non-empty. Standalone gate: a diagnostic run needs ONLY this var, not `CLARUS_MAC_TESTS` too.

- [ ] **Step 1: Add the gate helper**

In `internal/mactest/mac_test.go`, directly under `requireMac`:

```go
// requireCprintMac gates the cprint/Retro68 gcc build-path tests,
// demoted from the per-merge gate to an on-demand diagnostic oracle
// (pack3-standardfile phase, 2026-08-07): every case they cover still
// runs on the native emit68k lane (TestCoreSuiteGUIOn68k /
// TestToolboxSuiteOn68k / TestRunErrOn68k / TestAbortOn68k). Set
// CLARUS_CPRINT_MAC_TESTS=1 when a native-lane failure needs cross-lane
// localization (cg68k codegen bug vs runtime-logic bug) -- this lane
// compiling the same runtime through gcc is the triangulation tool that
// isolated the trailing-bool ABI, 2B<->4B form-hang, and CharParameter
// marshaling bugs. Standalone: a diagnostic run needs only this var.
// Lane deletion (rt_ext_mac.inc, build-mac.sh) is 5f Retro68-retirement
// work, not this phase's.
func requireCprintMac(t *testing.T) {
	if os.Getenv("CLARUS_CPRINT_MAC_TESTS") == "" {
		t.Skip("set CLARUS_CPRINT_MAC_TESTS=1 (cprint-Mac diagnostic lane; needs Retro68 toolchain + Mini vMac + display)")
	}
}
```

Swap `requireMac(t)` → `requireCprintMac(t)` in exactly these seven tests: `TestRunErrOnMac`, `TestAbortAppsOnMac` (mac_test.go), `TestCoreSuiteGUIOnMac`, `TestToolboxSuiteOnMac` (coresuite_test.go), `TestAppResNaming`, `TestAppResResources`, `TestAppResBundleBit` (appres_test.go). Touch NO native-lane test (`*On68k`, `TestNative*`, `TestUiScenariosOn68k`, `TestPbm2Icn*`, `TestApp68kResourceParity` all stay as they are).

- [ ] **Step 2: Verify skip behavior both ways**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'OnMac|AppRes' -count=1 -v 2>&1 | grep -E 'SKIP|PASS|FAIL|ok'`
Expected: all seven SKIP with the new message; no FAIL. (This run must not launch the emulator at all — it should finish in seconds.)
Run: `go test ./internal/mactest -run 'AppRes' -count=1 -v 2>&1 | grep SKIP`
Expected: same skips without CLARUS_MAC_TESTS either.

- [ ] **Step 3: Update docs**

- `scripts/test-merge.sh` comment block (lines ~7-8): note the Mac/cprint-lane boots now SKIP here by design; `CLARUS_CPRINT_MAC_TESTS=1` re-enables them as a diagnostic lane.
- `CLAUDE.md`: in the tiered-gates section, amend the T2 description ("full gated `internal/mactest`" → native lane; cprint-Mac lane opt-in via `CLARUS_CPRINT_MAC_TESTS=1`, kept as a cross-lane localization oracle); in the suite section, replace "the two untouchable Retro68/cprint suite gates" wording accordingly; note the C printer's remaining first-class role is HOST builds.
- `docs/ROADMAP.md`: one paragraph in the current-phase area recording the demotion decision + rationale (Andrew, 2026-08-07: cprint-68k was a stop-gap; host is the C printer's job) and that deletion remains with 5f. Full phase record comes in Task 6.

- [ ] **Step 4: T1 + commit**

Run: `scripts/test-task.sh` — expected PASS.
```sh
git add internal/mactest scripts/test-merge.sh CLAUDE.md docs/ROADMAP.md
git commit -m "test(mactest): demote cprint-Mac lane behind CLARUS_CPRINT_MAC_TESTS (diagnostic oracle)"
```

---

### Task 3: `toolbox/standardfile.cla` + `toolbox/files.cla` catalogs (Part C, declarations)

**Files:**
- Create: `toolbox/standardfile.cla`, `toolbox/files.cla`
- Modify: `internal/testsuite/catalog_test.go` (add both to `catalogFiles`, extend `catalogDriver`)

**Interfaces:**
- Produces (consumed by Task 4's runtime bodies — exact declarations):
  - `extern record SFReply { good: bool  copy: bool  fType: int  vRefNum: word  version: word  fName: str[63] }` (74 bytes)
  - `extern record SFTypeList { t0: int  t1: int  t2: int  t3: int }`
  - `extern record Str255 { s: str[255] }`
  - `external func SFPutFile(where: int, prompt: ptr, origName: ptr, dlgHook: ptr, reply: ptr) = trap 0xA9EA sel 0x0001`
  - `external func SFGetFile(where: int, prompt: ptr, fileFilter: ptr, numTypes: word, typeList: ptr, dlgHook: ptr, reply: ptr) = trap 0xA9EA sel 0x0002`
  - `external func SFPPutFile(where: int, prompt: ptr, origName: ptr, dlgHook: ptr, reply: ptr, dlgID: word, filterProc: ptr) = trap 0xA9EA sel 0x0003`
  - `external func SFPGetFile(where: int, prompt: ptr, fileFilter: ptr, numTypes: word, typeList: ptr, dlgHook: ptr, reply: ptr, dlgID: word, filterProc: ptr) = trap 0xA9EA sel 0x0004`
  - `extern record VolumeParam { qLink: ptr  qType: word  ioTrap: word  ioCmdAddr: ptr  ioCompletion: ptr  ioResult: word  ioNamePtr: ptr  ioVRefNum: word  pad[40] }` (64 bytes)
  - `external func PBSetVolSync(paramBlock: ptr): int = trap 0xA015 reg`

- [ ] **Step 1: Extend catalog_test.go first (failing test)**

In `internal/testsuite/catalog_test.go`: append `filepath.Join("toolbox", "standardfile.cla")` and `filepath.Join("toolbox", "files.cla")` to `catalogFiles`; extend `catalogDriver` so every new file has ≥1 bound symbol (check-only — nothing executes, modal safety is irrelevant):

```
    var rep: SFReply
    var tl: SFTypeList
    var vp: VolumeParam
    var pr: Str255

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
```
(New vars go at the top of the existing driver's handler with the others; statements after the existing ones.)

- [ ] **Step 2: Run to verify it fails**

Run: `go test ./internal/testsuite -run TestCatalogChecks -count=1`
Expected: FAIL — `cannot open included file`/missing positional file for `toolbox/standardfile.cla`.

- [ ] **Step 3: Write `toolbox/standardfile.cla`**

Follow the established house style precisely (copy the structure of `toolbox/scrap.cla`/`toolbox/memory.cla`): copyright + SPDX; `// toolbox/standardfile.cla: curated Standard File Package (_Pack3) declarations (Inside Macintosh I, "The Standard File Package").`; convention statement (selector-dispatched Pascal traps — `0xA9EA` bit 11 set, each routine `trap 0xA9EA sel N`, the uitable.cla List Manager `sel`-clause precedent); a per-symbol citation table verified DIRECTLY against Apple Universal Interfaces (the multiversal yaml is untrusted when cited alone — do not cite it at all here):

- `CIncludes/StandardFile.h:494-500` SFPutFile `THREEWORDINLINE(0x3F3C, 0x0001, 0xA9EA)`; `:511-519` SFGetFile `... 0x0002 ...`; `:530-538` SFPPutFile `... 0x0003 ...`; `:549-559` SFPGetFile `... 0x0004 ...` (quote each routine's full C parameter list in the comment); `:130-138` SFReply struct; `:476` `typedef OSType SFTypeList[4]`.
- Also check `AIncludes/` for the assembly-side corroboration (`LC_ALL=C tr '\r' '\n' < Retro68/InterfacesAndLibraries/Interfaces/AIncludes/<file> | grep -n ...` — try Packages.a / StandardFile.a for `_Pack3`/`$A9EA`); cite the real file:line found, or note "CIncludes only" honestly if absent.
- Field-offset anchor comment for SFReply: `good@0(1) copy@1(1) fType@2(4) vRefNum@6(2) version@8(2) fName@10(64), total 74` — same anchor style as `testsuite/core/cases_xrec.cla:16-18` (whose `XRSFReply` is a deliberate mirror of this record; leave that test file alone).
- `where: int` — Point by value, packed `(v << 16) | h`; note callers may pass a 4-byte `Point` var directly (extern-record→`int` decay). `prompt`/`origName`: `ptr` to Pascal string (`Str255` record below, or `UiStrAddr` in runtime code). Hooks/filters: `ptr(0)` = none.
- `Str255` buffer record with a comment: generic Pascal-string buffer for prompt/origName arguments; lives here as its first consumer, moves to a shared types file when a second consumer appears.
- Declarations exactly as in **Interfaces** above.
- Note: SFGetFile/SFPutFile are hardware-proven by the runtime's askOpen/askSave live-drive (this phase); SFPPutFile/SFPGetFile are declaration-only, citation-verified (System 6 modal dialogs cannot be auto-driven). System 7 StandardGetFile family (sel 5–8) deliberately out — S6-first.

- [ ] **Step 4: Write `toolbox/files.cla`**

Same style. Header: curated File Manager declarations, DELIBERATELY THIN — only what Standard File's SetVol step needs; the full manager fill belongs to a future file-abstraction phase. Citations:
- `CIncludes/Files.h:1409-1412`: `#pragma parameter __D0 PBSetVolSync(__A0)` + `ONEWORDINLINE(0xA015)` — pb in A0, OSErr in D0, bit 11 clear (`0xA015 & 0x0800 == 0`) → OS/register convention, bare `reg` (default a0-in/d0-out, same shape as `toolbox/memory.cla`'s NewPtr/DisposePtr comments). Corroborate in AIncludes (grep `_SetVol`/`$A015` in Files.a) and cite.
- `VolumeParam` layout from `CIncludes/Files.h:470-494`: qLink@0(4) qType@4(2) ioTrap@6(2) ioCmdAddr@8(4) ioCompletion@12(4) ioResult@16(2) ioNamePtr@18(4) ioVRefNum@22(2), then `pad[40]` filler to the full 64-byte volume-variant size (fields beyond ioVRefNum — filler2/ioVolIndex/dates/counts — not needed by PBSetVol; add on demand). State in the comment that only ioNamePtr(=0)+ioVRefNum are read by _SetVol.

- [ ] **Step 5: Run the catalog test**

Run: `go test ./internal/testsuite -run TestCatalogChecks -count=1 -v`
Expected: PASS.

- [ ] **Step 6: T1 + commit**

Run: `scripts/test-task.sh` — expected PASS (catalog files aren't in any build yet; no golden churn).
```sh
git add toolbox/standardfile.cla toolbox/files.cla internal/testsuite/catalog_test.go
git commit -m "feat(toolbox): _Pack3 Standard File + minimal File Manager catalogs"
```

---

### Task 4: real `nat_UiSFGetFile`/`nat_UiSFPutFile` bodies + golden re-bless (Part C, port)

**Files:**
- Modify: `runtime/clarus/uidialogs.cla` (two `include` lines at the very top of the declarations; rewrite the stub doc comments + bodies at lines ~75-122)
- Re-bless: `testdata/emitui/*.c.golden` (UI fixtures — the spliced runtime is embedded), `testdata/cg68k/bounce.seg4.s` + `testdata/cg68k/tickprobe.seg4.s` (listing goldens), possibly `testdata/emitui/app_info.c.golden`/`uiblob_probe.*` if they churn.

**Interfaces:**
- Consumes: Task 3's catalog declarations (exact signatures in Task 3's Interfaces block); existing helpers `rtUiPstrcpy(dst: ptr, src: ptr)` (uiwidgets.cla:389), `UiStrAddr(s: string): ptr` (uiscript.cla:31 — marshals the address of the caller's Str255, literals included).
- Produces: working real halves of `rtUiAskOpen`/`rtUiAskSave` on the native lane. Waist externs `UiSFGetFile`/`UiSFPutFile` keep their exact declarations (cprint lane structurally untouched).

- [ ] **Step 1: Add the includes**

At the top of `runtime/clarus/uidialogs.cla`, after the header comment block, BEFORE any other declaration (include-placement rule):
```
include "../../toolbox/standardfile.cla"
include "../../toolbox/files.cla"
```
With a comment: catalog-first per ROADMAP item 3's GUIDING PRINCIPLE — resolved relative to this file, i.e. `<rtdir>/../../toolbox/`; a user program composing the same catalog positionally dedups via Task 1's normalized include-once identity.

- [ ] **Step 2: Rewrite the two stub bodies**

Replace `nat_UiSFGetFile`/`nat_UiSFPutFile` (uidialogs.cla:116-122) and their DEFERRED-STUB doc comment (:92-115) — the "not a plain trap this language's `= trap` clause can express" rationale is stale since the `sel` clause landed; the new comment records the real port (transcription of rt_ext_mac.inc:625-653, native lane only). Also update the waist externs' own stale comment block (:75-88) the same way. New bodies:

```
// nat_UiSFGetFile / nat_UiSFPutFile (pack3-standardfile phase): the real
// native _Pack3 port -- a transcription of the cprint lane's C wrappers
// (rt_ext_mac.inc rt_ext_UiSFGetFile/rt_ext_UiSFPutFile), through the
// toolbox/standardfile.cla + toolbox/files.cla catalog declarations.
// where is the fixed {v=100, h=100} corner packed (v << 16) | h (System 6
// has no auto-center convention; the C reference hard-codes the same).
// On a good reply: PBSetVolSync makes the picked volume/working directory
// the default (result ignored, matching C -- a failed SetVol just means
// the follow-up file.readText/writeText fails on its own), then fName
// (Str63) is copied into the caller's Str255 via the string round-trip:
// rep.fName reads out as a Clarus string, UiStrAddr takes its Str255
// address, rtUiPstrcpy writes length byte + bytes. Cancel returns false
// with path255Out untouched -- byte-identical net behavior to the old
// deferred stubs, so no caller regresses on the cancel path.
func nat_UiSFGetFile(path255Out: ptr): bool {
    var rep: SFReply
    var types: SFTypeList
    var vp: VolumeParam
    var s: string
    var junk: int

    types.t0 = 0x54455854
    SFGetFile((100 << 16) | 100, UiStrAddr(""), ptr(0), 1, types, ptr(0), rep)
    if not rep.good {
        return false
    }
    vp.ioNamePtr = ptr(0)
    vp.ioVRefNum = rep.vRefNum
    junk = PBSetVolSync(vp)
    s = rep.fName
    rtUiPstrcpy(path255Out, UiStrAddr(s))
    return true
}

func nat_UiSFPutFile(suggested255: ptr, path255Out: ptr): bool {
    var rep: SFReply
    var vp: VolumeParam
    var s: string
    var junk: int

    SFPutFile((100 << 16) | 100, UiStrAddr("Save as:"), suggested255, ptr(0), rep)
    if not rep.good {
        return false
    }
    vp.ioNamePtr = ptr(0)
    vp.ioVRefNum = rep.vRefNum
    junk = PBSetVolSync(vp)
    s = rep.fName
    rtUiPstrcpy(path255Out, UiStrAddr(s))
    return true
}
```
Notes for the implementer: `0x54455854` = `'TEXT'`; extern-record vars are zero-initialized storage, and they DECAY to `ptr` when passed to an `external func`'s `ptr` parameter (`types`, `rep`, `vp` above) — that decay does NOT work for ordinary functions, which is why the fName copy round-trips through `s`/`UiStrAddr` instead of taking an address. If the check pass rejects any of these shapes, STOP and report — do not invent a workaround; that's a spec-level finding.

- [ ] **Step 3: Rebuild + spot-check emission before any golden work**

```sh
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c   # unchanged snapshot, just ensure it exists
build-run/clarusc emit68k -o /tmp/probe.bin --listing testdata/cg68k/bounce.cla
grep -n -A2 -B2 'A9EA\|A015' /tmp/probe.seg*.s | head -40
```
Expected in the listing: for each SF call site, `MOVE.W #$0002,-(SP)` (Get) / `MOVE.W #$0001,-(SP)` (Put) immediately before `DC.W $A9EA`, and a `DC.W $A015` register-convention call for PBSetVolSync. THE EYEBALL CHECK IS MANDATORY BEFORE ANY EMULATOR BOOT — a wrong selector or slot order crashes real hardware (the List Manager selector-bug class). Compare argument push order against StandardFile.h's parameter order quoted in toolbox/standardfile.cla.

- [ ] **Step 4: Run T1 to enumerate golden fallout**

Run: `scripts/test-task.sh 2>&1 | grep -E 'FAIL|ok ' | head -30`
Expected failures ONLY in: `internal/cg68k` (bounce/tickprobe listing goldens), `internal/emitui` (UI fixtures' .c.golden). Any OTHER failure = real regression, stop and fix before blessing.

- [ ] **Step 5: Re-bless cg68k listing goldens**

Run: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`
Then: `git diff --stat testdata/cg68k/` — only `bounce.seg*.s`/`tickprobe.seg*.s` should change; eyeball `git diff testdata/cg68k/bounce.seg4.s | grep -E '^\+' | grep -E 'A9EA|A015|3F3C|MOVE.W #\$000[12]' ` to re-confirm the Step 3 shapes landed in the goldens.

- [ ] **Step 6: Regenerate emitui goldens**

For each `testdata/emitui/*.cla` whose `.c.golden` now mismatches (Step 4's list): regenerate with the exact invocation the test uses (`clarusc emit -o <out> <fixture>`; run from the repo root first — if the byte-compare still fails on path-bearing content, rerun from `internal/emitui/` with `../../testdata/...` paths to match the goldens' embedded spelling):
```sh
for f in testdata/emitui/*.cla; do
  g="${f%.cla}.c.golden"; [ -f "$g" ] || continue
  build-run/clarusc emit -o "$g" "$f"
done
go test ./internal/emitui -count=1
```
Expected: PASS — including the m68k-gcc compile-check of every regenerated golden (this is the T1-side proof that cprint's `sel`-trap emission for the new catalog externs still compiles against the real Toolbox headers, which matters extra now the Mac boots are demoted).

- [ ] **Step 7: Full T1 with native smoke**

Run: `scripts/test-task.sh --smoke`
Expected: PASS — the two native emulator smokes (`TestSmokeBounceOn68k`, `TestRealEventLoopTickOn68k`) boot programs whose builds now contain the catalog decls + real bodies; green here proves nothing crashes at startup and the scripted/real fork still routes scripted.

- [ ] **Step 8: Commit**

```sh
git add runtime/clarus/uidialogs.cla testdata/cg68k testdata/emitui
git commit -m "feat(runtime): real native _Pack3 SFGetFile/SFPutFile via toolbox catalog"
```

---

### Task 5: gate rehearsals (T2 + diagnostic lane)

**Files:** none modified — verification only. Run from repo root.

- [ ] **Step 1: T2 (the merge gate as it will run from now on)**

Run: `scripts/test-merge.sh` (background it; ~30-40 min)
Expected: PASS end-to-end. In the mactest section, the seven demoted tests SKIP (grep the output for `CLARUS_CPRINT_MAC_TESTS` skip messages — all seven present); all native-lane gates green, `internal/selfhost` green (proves Task 1's clarusc change through the full bootstrap suite). Note the wall-time delta vs the ~2428s pre-demotion rehearsal in the task report.

- [ ] **Step 2: Diagnostic-lane rehearsal (proves the demoted lane still works when asked)**

Run: `CLARUS_CPRINT_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOnMac|TestToolboxSuiteOnMac|TestRunErrOnMac|TestAbortAppsOnMac|TestAppRes' -count=1 -timeout 90m`
Expected: PASS — the Retro68/cprint lane compiles the edited uidialogs.cla (real SF bodies, catalog includes) through gcc and boots green. This is deliberately AFTER Task 4 so the diagnostic lane is proven against the phase's own runtime change, not the pre-change tree.

- [ ] **Step 3: Record results**

No commit (nothing changed); paste both run summaries into the task report for the ledger.

---

### Task 6: live-drive acceptance + phase records (top-level session, NOT a subagent)

**Files:**
- Modify: `docs/ROADMAP.md` (phase record), `CLAUDE.md` (if any final wording), spec's Outcome section.

- [ ] **Step 1: Build the native texteditor (no --events — real input mode)**

```sh
scripts/build-68k.sh examples/texteditor.cla
```

- [ ] **Step 2: Live-drive in Mini vMac (the 4c acceptance standard)**

Boot via `toolchain/bin/LaunchAPPL -e minivmac <bin>` (background; blocks until quit). Drive with `scripts/click.swift` + osascript keystrokes + `screencapture` per CLAUDE.md's emulator-control section (sleep ~10s post-launch; nudge with synthetic mouseMoved during waits — idle-lock):
1. Type text; File▸Save → REAL SFPutFile dialog appears (screenshot-verify: "Save as:" prompt, suggested name); type a filename, click Save.
2. Quit; relaunch; File▸Open → REAL SFGetFile dialog (screenshot-verify file list shows the saved file); select + Open; verify content roundtrip on screen.
3. Cancel path, both dialogs: File▸Open → Cancel → clean no-op (no crash, no state change); File▸Save on a dirty doc → Cancel → same.

- [ ] **Step 3: Phase records + final commit**

ROADMAP: phase entry (all three parts, decisions, gate results, live-drive outcome); spec Outcome section; commit.

---

## Self-Review Notes (done at write time)

- Spec coverage: Part A → Task 1; Part B → Task 2 (+5.1); Part C → Tasks 3-4 (+5.2 cprint compile proof, 6 live-drive); verification §1-6 → Tasks 1, 3, 4.3-4.7, 5, 6.
- The composed-ordering item (spec "Task-1 verification item") is covered by Task 1's EntryFileDedup subtest + Task 3's catalog check (user-side composition) + Task 4's includes (runtime-side); a dedicated combined fixture is deliberately omitted — Task 4 Step 7's --smoke and Task 5 boot the real combination on both lanes.
- Types cross-checked: SFReply/SFTypeList/VolumeParam/Str255 field spellings identical in Task 3 Interfaces, Task 3 Step 1 driver, and Task 4 Step 2 bodies; `UiStrAddr(s: string): ptr` and `rtUiPstrcpy(dst, src)` argument orders verified against uiscript.cla:31 / uiwidgets.cla:389-399.
