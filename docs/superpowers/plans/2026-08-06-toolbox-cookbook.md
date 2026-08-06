# Toolbox Cookbook Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the IM→Clarus transcription docs (Ch13 mapping table + cookbook doc), a four-file hardware-proven `toolbox/` extern catalog, and two runtime riders (UiFlushEvents bit-11 fix, real native desk-scrap bridge).

**Architecture:** Pure additive docs + declaration files; the only runtime code changes are the two riders in `runtime/clarus/ui.cla`/`uitext.cla` plus `rt_ext_mac.inc` wrappers. No compiler changes. Catalog files are ordinary user-side `.cla` declaration files (NOT runtime modules — they join builds positionally or via `include`).

**Tech Stack:** Clarus (`.cla`), Go test harnesses (`internal/testsuite`, `internal/mactest`), Retro68/Mini vMac for the gated suite boots.

**Spec:** `docs/superpowers/specs/2026-08-06-toolbox-cookbook-design.md`

## Global Constraints

- Branch: `toolbox-cookbook` off `main`. Merge only on Andrew's request.
- T1 (`scripts/test-task.sh`) after every task; `--smoke` for tasks touching `runtime/` (Tasks 3, 4). T2 (`scripts/test-merge.sh`) before merge.
- NO bootstrap-snapshot regeneration is expected: no task touches `clarusc/*.cla`. If `TestSnapshotFixedPoint` fails, something is wrong — stop and investigate, don't regenerate.
- All new `.cla` files are plain ASCII (the MacRoman/Edit-tool corruption rule is moot for new ASCII-only files, but do NOT paste curly quotes/em-dashes into `.cla` files).
- Catalog declarations use REAL Inside Macintosh names (`NewPtr`, not `TbNewPtr`). Runtime code keeps its `Ui*` prefixes this phase (the sunset is a recorded follow-on, spec §"Recorded follow-on").
- Every trap word and register clause in the catalog must be either (a) copied verbatim from a proven in-repo declaration (cite it in the header comment) or (b) verified against Retro68's `multiversal/defs/*.yaml` and/or `Retro68/InterfacesAndLibraries` CIncludes (cite file + entry). No trap word enters the catalog on memory alone.
- `Retro68/` and `toolchain/` are symlinks at repo root (see CLAUDE.md). Multiversal defs: `toolchain/../multiversal/defs/` or `Retro68/multiversal/defs/` — locate with `ls` first.
- Gated suite runs: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuite' -count=1 -v` (needs toolchain + emulator, present on this machine). LaunchAPPL boots BLOCK — run in background if invoked directly; the go test harness handles this itself.

---

### Task 1: Catalog files + T1 check test

**Files:**
- Create: `toolbox/memory.cla`, `toolbox/events.cla`, `toolbox/osutils.cla`, `toolbox/scrap.cla`
- Create: `internal/testsuite/catalog_test.go`

**Interfaces:**
- Produces: the four catalog files with these exact declaration names (Task 2's case and Task 6's cookbook cite them): `NewPtr(byteCount: int): ptr`, `DisposePtr(p: ptr)`, `NewHandle(byteCount: int): ptr`, `DisposeHandle(h: ptr)`, `GetHandleSize(h: ptr): int`, `SetHandleSize(h: ptr, newSize: int): int`, `HLock(h: ptr)`, `HUnlock(h: ptr)`, `BlockMoveData(srcPtr: ptr, destPtr: ptr, byteCount: int)`, `MoreMasters()`; extern records `Point`, `EventRecord`; consts `nullEvent`..`osEvt`, `everyEvent`, mask/modifier consts; `GetNextEvent`, `EventAvail`, `PostEvent`, `TickCount`, `Button`, `StillDown`, `GetMouse`; `Gestalt`, `Delay`, `SysBeep`; `ZeroScrap`, `PutScrap`, `GetScrap`, `InfoScrap`, `LoadScrap`, `UnloadScrap`.
- Produces: Go test `TestCatalogChecks` + package var `catalogFiles` (Task 2 reuses the list shape).

- [ ] **Step 1: Collision sweep.** For every name above, verify no `runtime/clarus/*.cla` declaration shares it (runtime modules are spliced into `--testapi` suite builds): `grep -nE "func (NewPtr|DisposePtr|NewHandle|DisposeHandle|GetHandleSize|SetHandleSize|HLock|HUnlock|BlockMoveData|MoreMasters|GetNextEvent|EventAvail|PostEvent|TickCount|Button|StillDown|GetMouse|Gestalt|Delay|SysBeep|ZeroScrap|PutScrap|GetScrap|InfoScrap|LoadScrap|UnloadScrap)\b|record (Point|EventRecord)\b" runtime/clarus/*.cla` — expect ZERO hits (prefixed `Ui*`/`Nat*` names don't count). Any hit: stop, report; the catalog name must then be dedup-identical or the plan revised.
- [ ] **Step 2: Write the failing test** — `internal/testsuite/catalog_test.go`:

```go
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
```

(If the driver trips a check rule — e.g. an unused-variable or handler-shape diagnostic — adjust the DRIVER, not the catalog, and keep one bound symbol per file. `on App.startCLI` with no `app` block is the proven minimal shape: `testsuite/core/cli.cla` has no `app` declaration either.)

- [ ] **Step 3: Run it — expect FAIL** (`cannot open` the four missing files): `go test ./internal/testsuite -run TestCatalogChecks -count=1 -v`
- [ ] **Step 4: Write the four catalog files.** Every declaration below marked *(proven: X)* is copied verbatim (name aside) from that in-repo declaration; every one marked *(verify)* MUST be checked against multiversal defs / CIncludes before commit and the citation added to the file's header comment. Each file starts with the standard copyright header plus a header comment naming its IM source (e.g. "Inside Macintosh II, Memory Manager") and, for scrap.cla, the ScrapStuff peek-offset table.

`toolbox/memory.cla`:

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// toolbox/memory.cla: curated Memory Manager declarations (Inside
// Macintosh II, "The Memory Manager"), toolbox-cookbook phase. Register
// (OS) convention throughout -- bit 11 clear on every trap word below
// (trap & 0x0800 == 0), per the Ch13 trap-table reading rule. Safe to
// redeclare identically in user code (Ch13 dedup rule).

external func NewPtr(byteCount: int): ptr = trap 0xA11E reg
external func DisposePtr(p: ptr) = trap 0xA01F reg
external func NewHandle(byteCount: int): ptr = trap 0xA122 reg
external func DisposeHandle(h: ptr) = trap 0xA023 reg
external func GetHandleSize(h: ptr): int = trap 0xA025 reg
external func SetHandleSize(h: ptr, newSize: int): int = trap 0xA024 reg memerr
external func HLock(h: ptr) = trap 0xA029 reg
external func HUnlock(h: ptr) = trap 0xA02A reg
external func BlockMoveData(srcPtr: ptr, destPtr: ptr, byteCount: int) = trap 0xA22E reg
external func MoreMasters() = trap 0xA036 reg
```

Provenance: NewPtr/DisposePtr/NewHandle/DisposeHandle/SetHandleSize/BlockMoveData *(proven: `runtime/clarus/list.cla`'s ListNewPtr family + `testsuite/toolbox/cases_gestalt.cla`'s TbNewPtr/TbDisposePtr)*; HLock/HUnlock *(proven: NatHLock/NatHUnlock)*; GetHandleSize 0xA025 *(verify)*; MoreMasters 0xA036 *(proven trap word: NatMoreMasters — note it is declared plain-pascal there, harmless for a zero-arg void trap; the catalog uses `reg` per the bit-11 rule)*.

`toolbox/events.cla`:

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// toolbox/events.cla: curated Event Manager declarations (Inside
// Macintosh I, "The Toolbox Event Manager"; PostEvent from II's OS Event
// Manager). Pascal convention except PostEvent (bit 11 clear -> OS/reg).

extern record Point {
    v: word
    h: word
}

extern record EventRecord {
    what: word
    message: int
    when: int
    where: Point
    modifiers: word
}

// Event codes (EventRecord.what)
const nullEvent: int = 0
const mouseDown: int = 1
const mouseUp: int = 2
const keyDown: int = 3
const keyUp: int = 4
const autoKey: int = 5
const updateEvt: int = 6
const diskEvt: int = 7
const activateEvt: int = 8
const osEvt: int = 15

// Event masks
const everyEvent: int = 0xFFFF

// Modifier flags (EventRecord.modifiers)
const activeFlag: int = 0x0001
const btnState: int = 0x0080
const cmdKey: int = 0x0100
const shiftKey: int = 0x0200
const alphaLock: int = 0x0400
const optionKey: int = 0x0800
const controlKey: int = 0x1000

// Message masks (EventRecord.message, key events)
const charCodeMask: int = 0x000000FF
const keyCodeMask: int = 0x0000FF00

external func GetNextEvent(eventMask: word, theEvent: ptr): bool = trap 0xA970
external func EventAvail(eventMask: word, theEvent: ptr): bool = trap 0xA971
external func PostEvent(eventNum: word, eventMsg: int): word = trap 0xA02F reg(a0: eventNum, d0: eventMsg) ret d0
external func TickCount(): int = trap 0xA975
external func Button(): bool = trap 0xA974
external func StillDown(): bool = trap 0xA973
external func GetMouse(mouseLoc: ptr) = trap 0xA972
```

Provenance: GetNextEvent/StillDown/GetMouse *(proven: UiGetNextEvent/UiStillDown/UiGetMouse, `runtime/clarus/ui.cla`)*; EventAvail *(proven: TbEventAvail)*; PostEvent *(proven verbatim: TbPostEvent, `testsuite/toolbox/cases_uitest.cla:86` — including the a0/d0 binding, empirically verified by PostEventClick)*; TickCount *(proven: TbTickCount + reference Ch13 example)*; Button 0xA974 *(verify)*; event/mask/modifier const values *(verify against CIncludes Events.h)*. Per-mask event masks (mDownMask etc.) are deliberately omitted — `everyEvent` covers the curated use cases; add on demand.

`toolbox/osutils.cla`:

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// toolbox/osutils.cla: curated OS Utilities / Gestalt declarations
// (Inside Macintosh II "OS Utilities"; Gestalt from IM VI ch3).

const gestaltSystemVersion: int = 0x73797376

external func Gestalt(selector: int, response: ptr): word = trap 0xA1AD reg(d0: selector, a1: response) ret d0
external func Delay(numTicks: int): int = trap 0xA03B reg(a0: numTicks) ret d0
external func SysBeep(duration: word) = trap 0xA9C8
```

Provenance: Gestalt *(proven verbatim: TbGestalt/UiGestalt)*; SysBeep *(proven: UiSysBeep)*; Delay 0xA03B + register binding *(verify — the a0/d0 binding above is provisional; correct it from multiversal `defs` OSUtils entry and cite)*.

`toolbox/scrap.cla`:

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// toolbox/scrap.cla: curated Scrap Manager (desk scrap) declarations
// (Inside Macintosh I, "The Scrap Manager"). All pascal-convention
// (bit 11 set). TEFromScrap/TEToScrap are deliberately ABSENT: they are
// glue routines with no trap word (see the cookbook's copy/paste
// walkthrough), not Scrap Manager traps.
//
// InfoScrap returns a pointer to the ScrapStuff record; read it with
// peek at these offsets (no extern-record conversion exists for a
// returned ptr):
//   +0  scrapSize    long   (peekl)
//   +4  scrapHandle  Handle (peekl)
//   +8  scrapCount   word   (peekw)
//   +10 scrapState   word   (peekw)
//   +12 scrapName    ptr    (peekl)

external func ZeroScrap(): int = trap 0xA9FC
external func PutScrap(length: int, theType: int, source: ptr): int = trap 0xA9FE
external func GetScrap(hDest: ptr, theType: int, offset: ptr): int = trap 0xA9FD
external func InfoScrap(): ptr = trap 0xA9F9
external func LoadScrap(): int = trap 0xA9FB
external func UnloadScrap(): int = trap 0xA9FA
```

Provenance: ZeroScrap *(proven: UiZeroScrap)*; trap words 0xA9FC/0xA9FD/0xA9FE *(already verified against multiversal `defs/ScrapMgr.yaml` per `uitext.cla:144-145`'s comment — re-confirm and cite)*; InfoScrap/LoadScrap/UnloadScrap + ScrapStuff offsets *(verify)*.

- [ ] **Step 5: Do the (verify) pass.** Locate multiversal defs (`ls Retro68/multiversal/defs/ 2>/dev/null || find toolchain/.. -maxdepth 3 -name defs -type d 2>/dev/null | head`), then check every *(verify)* item; fix any wrong word/binding and add citations to the header comments.
- [ ] **Step 6: Run the test — expect PASS:** `go test ./internal/testsuite -run TestCatalogChecks -count=1 -v`
- [ ] **Step 7: T1:** `scripts/test-task.sh` — expect green.
- [ ] **Step 8: Commit:** `git add toolbox/ internal/testsuite/catalog_test.go && git commit -m "feat(toolbox): 4-file curated extern catalog + T1 check test"`

---

### Task 2: `Catalog` toolbox-suite case (hardware proof)

**Files:**
- Create: `testsuite/toolbox/cases_catalog.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum + `nTbCases` + `tbCaseName` + `tbAllCases` + dispatch arm)
- Modify: `testsuite/toolbox/cases_event.cla` (DELETE its local `Point`/`EventRecord` extern records — extern records have NO dedup rule; the catalog's copies would collide in the composed build. Its `Tb*` externs and case logic stay.)
- Modify: `internal/mactest/coresuite_test.go` (`toolboxFiles` += 4 catalog files + `cases_catalog.cla`)
- Modify: `runtime/mac/rt_ext_mac.inc` (cprint-lane wrappers for catalog externs)

**Interfaces:**
- Consumes: Task 1's catalog declarations (exact names above).
- Produces: `ToolboxTest` member `Catalog`, case func `caseCatalog(): TestResult` in `cases_catalog.cla`; suite grows 22→23 real cases, 23→24 total (`nTbCases` const 23→24 — its count includes SelfCheck). Task 4 extends `caseCatalog` — keep it one function with clearly-separated sections.

- [ ] **Step 1: Wire the case red-first.** Add `Catalog` to the enum (before `SelfCheck`), `nTbCases` 23→24, `tbCaseName` arm returning `"Catalog"`, `tbAllCases()` entry (before SelfCheck), and a dispatch arm in `runToolboxTests` mirroring the `GestaltNamed` arm shape (each arm increments `casesRun` and appends `caseCatalog()`'s result — copy the exact statement shape of an existing arm). Add `cases_catalog.cla` + the four `toolbox/*.cla` files to `toolboxFiles` in `coresuite_test.go` (catalog files right after `kit.cla`; order is immaterial — lowering pre-pass — but keep them grouped).
- [ ] **Step 2: Write `cases_catalog.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_catalog.cla: Catalog (toolbox-cookbook Task 2) -- hardware-proves
// the shipped toolbox/ extern catalog (memory/events/osutils/scrap) by
// calling it against real ROM, in-process. Unlike every other case file,
// the externs here are NOT declared locally: the whole point is that the
// toolbox/*.cla files in the build supply them. Task 4 extends this case
// with a TE<->desk-scrap bridge roundtrip (see the section markers).

func caseCatalog(): TestResult {
    var detail: string
    var p1: ptr
    var p2: ptr
    var h: ptr
    var off: ptr
    var mp: ptr
    var ev: EventRecord
    var err: int
    var n: int
    var i: int
    var ok: bool

    // -- osutils: Gestalt (named-reg, ret d0), same selector rtUiStartup
    // proves on every boot.
    p1 = NewPtr(4)
    err = Gestalt(gestaltSystemVersion, p1)
    n = peekl(p1)
    DisposePtr(p1)
    if err != 0 or n == 0 {
        detail = "gestalt err " + tkIntToStr(err)
        return tkFail("Catalog", detail)
    }

    // -- memory: NewPtr/BlockMoveData/DisposePtr roundtrip.
    p1 = NewPtr(16)
    p2 = NewPtr(16)
    i = 0
    while i < 16 {
        pokeb(p1 + i, 0x40 + i)
        pokeb(p2 + i, 0)
        i = i + 1
    }
    BlockMoveData(p1, p2, 16)
    ok = true
    i = 0
    while i < 16 {
        if peekb(p2 + i) != 0x40 + i {
            ok = false
        }
        i = i + 1
    }
    DisposePtr(p1)
    DisposePtr(p2)
    if not ok {
        return tkFail("Catalog", "blockmove mismatch")
    }

    // -- memory: handle sizing.
    h = NewHandle(8)
    if GetHandleSize(h) != 8 {
        DisposeHandle(h)
        return tkFail("Catalog", "newhandle size")
    }
    err = SetHandleSize(h, 32)
    n = GetHandleSize(h)
    DisposeHandle(h)
    if err != 0 or n != 32 {
        detail = "sethandlesize err " + tkIntToStr(err)
        detail = detail + " size " + tkIntToStr(n)
        return tkFail("Catalog", detail)
    }

    // -- events: EventAvail through the catalog's EventRecord (extern
    // record decay at the ptr parameter). Result is environment-dependent
    // (usually no event pending); calling it without crashing and getting
    // a sane what-code IS the assertion.
    ok = EventAvail(everyEvent, ev)
    if ok and (ev.what < nullEvent or ev.what > osEvt) {
        detail = "eventavail what " + tkIntToStr(ev.what)
        return tkFail("Catalog", detail)
    }

    // -- events: TickCount sanity (nonzero on a booted system).
    if TickCount() == 0 {
        return tkFail("Catalog", "tickcount zero")
    }

    // -- scrap: ZeroScrap/PutScrap/GetScrap roundtrip ('TEXT' flavor).
    err = ZeroScrap()
    if err != 0 {
        detail = "zeroscrap err " + tkIntToStr(err)
        return tkFail("Catalog", detail)
    }
    p1 = NewPtr(8)
    pokeb(p1, 0x43)     // C
    pokeb(p1 + 1, 0x41) // A
    pokeb(p1 + 2, 0x54) // T
    pokeb(p1 + 3, 0x4C) // L
    pokeb(p1 + 4, 0x47) // G
    err = PutScrap(5, 0x54455854, p1)
    DisposePtr(p1)
    if err != 0 {
        detail = "putscrap err " + tkIntToStr(err)
        return tkFail("Catalog", detail)
    }
    h = NewHandle(0)
    off = NewPtr(4)
    n = GetScrap(h, 0x54455854, off)
    DisposePtr(off)
    if n != 5 {
        DisposeHandle(h)
        detail = "getscrap len " + tkIntToStr(n)
        return tkFail("Catalog", detail)
    }
    HLock(h)
    mp = ptr(peekl(h))
    ok = peekb(mp) == 0x43 and peekb(mp + 4) == 0x47
    HUnlock(h)
    DisposeHandle(h)
    if not ok {
        return tkFail("Catalog", "getscrap content")
    }

    // -- scrap: InfoScrap peek-offset read (scrapSize just written).
    mp = InfoScrap()
    if mp == ptr(0) or peekl(mp) < 5 {
        return tkFail("Catalog", "infoscrap")
    }

    // (Task 4 appends the TE<->desk-scrap bridge section here.)

    return tkPass("Catalog")
}
```

(`tkIntToStr`/`tkPass`/`tkFail` come from `testsuite/kit.cla` — same as every other case file. Match existing case files' exact usage. If `ev.what`'s zero-init read before any event trips a checker rule, initialize per the reference: extern records zero-initialize by definition, so it won't.)

- [ ] **Step 3: Add cprint-lane wrappers** to `runtime/mac/rt_ext_mac.inc` (one section, commented as toolbox-cookbook Task 2). Every catalog extern the case calls needs one (cprint emits `rt_ext_NAME(...)` and ignores trap clauses). Follow the file's existing wrapper style exactly; the set: `rt_ext_NewPtr`, `rt_ext_DisposePtr`, `rt_ext_NewHandle`, `rt_ext_DisposeHandle`, `rt_ext_GetHandleSize`, `rt_ext_SetHandleSize` (call `SetHandleSize` then return `MemError()` — mirror how the existing `memerr`-shaped wrapper for `ListSetHandleSize`/kin is written; grep `rt_ext_ListSetHandleSize`), `rt_ext_HLock`, `rt_ext_HUnlock`, `rt_ext_BlockMoveData`, `rt_ext_EventAvail`, `rt_ext_TickCount`, `rt_ext_Gestalt`, `rt_ext_ZeroScrap`, `rt_ext_PutScrap`, `rt_ext_GetScrap`, `rt_ext_InfoScrap`. Example shapes:

```c
void *rt_ext_NewPtr(int32_t byteCount) { return (void *)NewPtr((Size)byteCount); }
void rt_ext_DisposePtr(void *p) { DisposePtr((Ptr)p); }
int32_t rt_ext_GetHandleSize(void *h) { return (int32_t)GetHandleSize((Handle)h); }
int16_t rt_ext_Gestalt(int32_t selector, void *response) { return (int16_t)Gestalt((OSType)selector, (long *)response); }
int32_t rt_ext_GetScrap(void *hDest, int32_t theType, void *offset) { return (int32_t)GetScrap((Handle)hDest, (ResType)theType, (long *)offset); }
int32_t rt_ext_PutScrap(int32_t length, int32_t theType, void *source) { return (int32_t)PutScrap((long)length, (ResType)theType, (Ptr)source); }
void *rt_ext_InfoScrap(void) { return (void *)InfoScrap(); }
int32_t rt_ext_TickCount(void) { return (int32_t)TickCount(); }
```

(Check each signature against how existing wrappers marshal `word`/`bool` — e.g. `EventAvail` returns bool: mirror `rt_ext_TbEventAvail` if present, else the file's bool-returning wrapper convention. Uncalled catalog externs — Button/StillDown/GetMouse/PostEvent/GetNextEvent/Delay/SysBeep/MoreMasters/LoadScrap/UnloadScrap — are tree-shaken from the suite build and need no wrapper yet; add a one-line comment saying so.)

- [ ] **Step 4: Delete `cases_event.cla`'s local `Point`/`EventRecord`** (lines ~62-75) and add a header-comment line noting they now come from `toolbox/events.cla` (toolbox-cookbook Task 2). Its `Tb*` externs stay untouched.
- [ ] **Step 5: Run the gated suite, both lanes:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuite' -count=1 -v` — expect 24/24 per lane including the new `Catalog` subtest.
- [ ] **Step 6: T1:** `scripts/test-task.sh` — green.
- [ ] **Step 7: Commit:** `git add -A && git commit -m "test(toolbox): Catalog suite case hardware-proves the extern catalog (23->24)"`

---

### Task 3: Rider 1 — UiFlushEvents bit-11 fix

**Files:**
- Modify: `runtime/clarus/ui.cla:263` (declaration) and `ui.cla:1380` (sole call site)
- Modify: `runtime/mac/rt_ext_mac.inc:332` (wrapper signature)

**Interfaces:**
- Consumes/Produces: nothing cross-task — self-contained runtime fix.

- [ ] **Step 1: Verify the real register contract** from multiversal defs (Events/OSEvents entry for FlushEvents) — expected: OS trap 0xA032, D0 in = stop mask in high word + which mask in low word, D0 out = 0 or the stopping event's map... cite what the defs actually say in the new comment.
- [ ] **Step 2: Fix declaration + call site.** Replace:

```rust
external func UiFlushEvents(whichMask: word, stopMask: word) = trap 0xA032
```

with (packed single-arg register form — the two 16-bit masks share D0, which the two-word pascal shape could never express; this was the filed toolbox-integration hazard):

```rust
external func UiFlushEvents(masks: int) = trap 0xA032 reg
```

and the call site `UiFlushEvents(0xFFFF, 0)` → `UiFlushEvents(0x0000FFFF)` (whichMask 0xFFFF in the low word, stopMask 0 in the high word). Keep/extend the surrounding comment: name the bit-11 rule and the packed-D0 layout, cite the defs entry from Step 1. If Step 1's defs contradict the packed-D0 layout, STOP and report before coding.

- [ ] **Step 3: Fix the cprint wrapper** (`rt_ext_mac.inc:332`):

```c
void rt_ext_UiFlushEvents(int32_t masks) { FlushEvents((EventMask)(masks & 0xFFFF), (EventMask)((masks >> 16) & 0xFFFF)); }
```

- [ ] **Step 4: Sweep for other callers:** `grep -rn "UiFlushEvents" runtime/ clarusc/ testsuite/ examples/ testdata/` — expect only the declaration, the one call site, and the wrapper. Any other hit: update it the same way.
- [ ] **Step 5: T1 with smoke:** `scripts/test-task.sh --smoke` — green (the two native smoke boots exercise startup's FlushEvents path on real ROM).
- [ ] **Step 6: Run the 4 frozen scenario goldens** (native lane): `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounce|TestSmokeMandel|TestTexteditor|TestBookmarks' -count=1 -v` — expect PASS with NO golden diffs (the fix changes which events get flushed at startup, before any traced activity; a diff means investigate, not re-bless).
- [ ] **Step 7: Commit:** `git commit -am "fix(runtime): UiFlushEvents OS-trap register convention (bit-11 rule, packed-D0 masks)"`

---

### Task 4: Rider 2 — real native desk-scrap bridge + TE roundtrip check

**Files:**
- Modify: `runtime/clarus/uitext.cla` (new `UiPutScrap`/`UiGetScrap` externs; replace the `nat_UiTEFromScrap`/`nat_UiTEToScrap` stub bodies at lines ~157-163; new small extern record for the GetScrap VAR-offset slot)
- Modify: `runtime/mac/rt_ext_mac.inc` (wrappers `rt_ext_UiPutScrap`/`rt_ext_UiGetScrap`)
- Modify: `testsuite/toolbox/cases_catalog.cla` (append the TE↔desk-scrap section)
- Modify: `testsuite/toolbox/harness.cla` ONLY if the drive pattern below needs a new window — it should not (reuse EditMain).

**Interfaces:**
- Consumes: Task 1's scrap catalog names (for the case side), Task 2's `caseCatalog` (extends it), `uitext.cla`'s existing `UiHandleDeref`/`UiHLock`/`UiHGetState`/`UiHSetState`/`UiZeroScrap`.
- Produces: working native-lane `TEToScrap`/`TEFromScrap` equivalents; inter-app clipboard on native builds.

- [ ] **Step 1: Read first:** `testsuite/toolbox/cases_editmenu.cla` in full (menu-driving consts + `UiTestVerb` readback lines), `runtime/clarus/uitest.cla`'s verb table, and `uitext.cla:109-167` (the stub block + its doc comments). The case code below is shape-normative; match verb strings and const derivations to what you read.
- [ ] **Step 2: Runtime — externs + bodies** in `uitext.cla`. Add next to `UiZeroScrap` (trap words from `toolbox/scrap.cla`, Task 1 — cite it):

```rust
external func UiPutScrap(length: int, theType: int, source: ptr): int = trap 0xA9FE
external func UiGetScrap(hDest: ptr, theType: int, offset: ptr): int = trap 0xA9FD

// rtUiScrapOff: 4-byte slot for GetScrap's VAR offset parameter --
// extern-record decay is the only address-of in the language.
extern record RtUiScrapOff {
    off: int
}
```

Replace the two stub bodies (keep `nat_UiTEGetScrapLength` as is; rewrite the block's doc comment — the "DEFERRED STUBS" story is over, cite this phase):

```rust
// nat_UiTEFromScrap/nat_UiTEToScrap (toolbox-cookbook rider 2): REAL
// desk-scrap bridge for the monostyled TE records this runtime uses.
// TEScrpHandle ($0AB4) / TEScrpLength ($0AB0) are the documented TE
// low-memory scrap globals (nat_UiTEGetScrapLength below already reads
// $0AB0). 'TEXT' == 0x54455854. TE scrap length is a 16-bit global:
// clamp an oversized desk scrap at 32767 -- rtUiStdEditPaste's own
// overflow guard re-checks against the textview limit downstream.
func nat_UiTEFromScrap(): int {
    var th: ptr
    var offSlot: RtUiScrapOff
    var n: int

    th = ptr(peekl(ptr(0xAB4)))
    if th == ptr(0) {
        return -102 // noTypeErr: no TE scrap handle to fill
    }
    n = UiGetScrap(th, 0x54455854, offSlot)
    if n < 0 {
        return n // no 'TEXT' in the desk scrap: TE scrap untouched
    }
    if n > 32767 {
        n = 32767
    }
    pokew(ptr(0xAB0), n)
    return 0
}

func nat_UiTEToScrap(): int {
    var th: ptr
    var st: int
    var err: int

    th = ptr(peekl(ptr(0xAB4)))
    if th == ptr(0) {
        return 0 // empty TE scrap: nothing to publish
    }
    st = UiHGetState(th)
    UiHLock(th)
    err = UiPutScrap(nat_UiTEGetScrapLength(), 0x54455854, UiHandleDeref(th))
    UiHSetState(th, st)
    return err
}
```

(Contract notes, verify while implementing: GetScrap resizes `hDest` itself and returns the length or a negative OSErr; passing the TE scrap handle directly is the documented pattern. The HLock around PutScrap guards the source block against compaction while the desk scrap grows. Callers: `rtUiStdEditDispatch` already calls `UiZeroScrap()` before `UiTEToScrap()` — do NOT ZeroScrap inside the bridge, matching real TEToScrap semantics.)

- [ ] **Step 3: cprint wrappers** in `rt_ext_mac.inc`, next to `rt_ext_UiZeroScrap`:

```c
int32_t rt_ext_UiPutScrap(int32_t length, int32_t theType, void *source) { return (int32_t)PutScrap((long)length, (ResType)theType, (Ptr)source); }
int32_t rt_ext_UiGetScrap(void *hDest, int32_t theType, void *offset) { return (int32_t)GetScrap((Handle)hDest, (ResType)theType, (long *)offset); }
```

(On the cprint lane `UiTEFromScrap`/`UiTEToScrap` still route to the REAL `TEFromScrap`/`TEToScrap` via their existing wrappers — the new bodies are native-lane-only fallbacks, reached only where clause-less externs resolve to `nat_*`. The new wrappers exist because the new bodies call `UiPutScrap`/`UiGetScrap`, and those bodies are still compiled on the cprint lane even though unreached there... verify: if the cprint lane tree-shakes `nat_*` fallbacks (unreferenced there), the wrappers are dead code — add them anyway, two lines, or confirm shaking and note it.)

- [ ] **Step 4: Extend `caseCatalog`** (replace the `(Task 4 appends...)` marker) — drive EditMain exactly as `cases_editmenu.cla` does (its consts are file-local; redeclare the ones needed under `tbCat*` names):

```rust
    // -- TE <-> desk-scrap bridge (toolbox-cookbook rider 2): Copy in a
    // real TE via the std Edit menu, then read the DESK scrap back
    // through the catalog's GetScrap -- proves nat_UiTEToScrap publishes
    // (native lane) / TEToScrap publishes (cprint lane). Then the
    // reverse: PutScrap fresh text, Paste it into the TE, read the
    // widget back -- proves nat_UiTEFromScrap fills the TE scrap.
    // Drive pattern (open/click/type/drag-select/menu/readback/close)
    // copied from cases_editmenu.cla -- see its header for the const
    // derivations reused here.
```

Assertions (concrete flow; match verbs/consts to Step 1's reading): open EditMain → click field A → `UiTestType("BRIDGE")` → drag-select all of A → `UiTestMenu(<Edit bar>, <Copy item>)` → `GetScrap` into a fresh `NewHandle(0)` with a `NewPtr(4)` offset slot → expect length 6 and bytes `B`(0x42)…`E`(0x45 at +5) → then `ZeroScrap` + `PutScrap(3, 'TEXT', "XYZ" bytes)` → select all of A again → `UiTestMenu(<Edit bar>, <Paste item>)` → read A's content back (the same readback `cases_editmenu.cla` uses) → expect exactly `XYZ` → `UiTestClose()` and clean up handles/ptrs. Every FAIL returns a distinct `detail` string.

- [ ] **Step 5: Run the gated suite, both lanes:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuite' -count=1 -v` — 24/24 both lanes. The native lane is the one that would have failed before this task's runtime fix.
- [ ] **Step 6: T1 with smoke:** `scripts/test-task.sh --smoke` — green.
- [ ] **Step 7: Frozen scenario goldens** (texteditor's script exercises edit paths): `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounce|TestSmokeMandel|TestTexteditor|TestBookmarks' -count=1 -v`. A trace/snap diff here is EXPECTED only if a scenario's script actually cuts/copies (check the events file before concluding); investigate any diff, and re-bless (`CLARUS_MAC_BLESS=1`, native lane) only with a written justification in the commit message.
- [ ] **Step 8: Commit:** `git add -A && git commit -m "feat(runtime): real native TE<->desk-scrap bridge (rider 2) + Catalog case roundtrip"`

---

### Task 5: Ch13 — "Transcribing Inside Macintosh Declarations"

**Files:**
- Modify: `docs/clarus-language-reference.md` (new subsection AFTER "Field Palette"'s closing paragraphs at ~line 1447, BEFORE the `waitClick` example block; also add the subsection to the Contents list at the top)

**Interfaces:**
- Consumes: settled mapping inputs (ROADMAP item 3 block, lines ~1116-1135) and the spec's §1 table.
- Produces: the normative subsection Task 6's cookbook cites.

- [ ] **Step 1: Write the subsection.** Content = spec §1 verbatim in reference prose: the IM→Clarus mapping table (all 10 rows from the spec — INTEGER/OSErr→`word`; LONGINT/OSType/Fixed→`int`; Boolean→`bool` with the aggregate/1-byte + high-byte-marshaling cross-references; CHAR→`word` never `char` with the MenuKey lesson stated normatively, citing the low-byte-of-a-plain-INTEGER vs high-byte-padded-`char` mismatch; SignedByte/Byte→`byte`; Str255→`str`/`str[N]`; VAR→`ptr` + decay; Point-by-value→4-byte extern record in `int` position; Ptr/Handle/ProcPtr→`ptr`; ProcPtr-you-implement→`callback func`), then one paragraph making the bit-11 rule normative: `trap & 0x0800` set → Toolbox/pascal convention, clear → OS/register convention (`reg`), with `TickCount 0xA975` (set) and `BlockMoveData 0xA22E` (clear) as the worked pair. Terse; every row cross-references the Ch13 section that owns the mechanics; NO tutorial prose (that's Task 6).
- [ ] **Step 2: Consistency sweep.** The new table must not contradict: the Field Palette table, the trap-clause `bool`/`char` high-byte paragraph, the `word` extern-type section, or ROADMAP's settled-inputs block. Read each; fix any wording drift IN THE NEW SUBSECTION (the reference wins conflicts — don't edit settled sections).
- [ ] **Step 3: T1** (docs-only, but cheap insurance): `scripts/test-task.sh` — green.
- [ ] **Step 4: Commit:** `git add docs/clarus-language-reference.md && git commit -m "docs(ref): Ch13 IM->Clarus transcription subsection (mapping table + bit-11 rule)"`

---

### Task 6: Cookbook doc

**Files:**
- Create: `docs/clarus-toolbox-cookbook.md`

**Interfaces:**
- Consumes: Ch13 (incl. Task 5's subsection — cite, never restate normatively), the catalog files (Task 1), the suite case (Tasks 2/4) as living examples.

- [ ] **Step 1: Write the doc.** Structure (spec §2 — this is the required outline):
  1. Header: what this doc is (how-to companion; Ch13 is normative and wins conflicts).
  2. **Reading an IM page** — anatomy of a declaration: name, params, trap word, where to find the trap word (IM appendix / Retro68 multiversal defs), then the bit-11 test deciding pascal vs `reg`.
  3. Walkthrough: **pascal trap** — MenuKey end to end, INCLUDING the broken `char` version and its silent failure mode (key equivalents never match), citing `testsuite/toolbox/cases_events.cla`'s TbMenuKey as the live proof.
  4. Walkthrough: **register trap + `memerr`** — SetHandleSize (cite `toolbox/memory.cla`).
  5. Walkthrough: **named-register form** — Gestalt (cite `toolbox/osutils.cla` + `cases_gestalt.cla`'s historical response-never-written bug as the motivation for `ret d0`).
  6. Walkthrough: **extern-record transcription** — EventRecord/Point against the field palette, field by field with offsets (cite `toolbox/events.cla`).
  7. Walkthrough: **selector dispatch** — LAddRow through `trap 0xA9E7 sel 0x0008` (cite the reference's own example).
  8. Walkthrough: **callback** — a control action procedure (cite the reference's `callback func` section; restate the no-interrupt-time rule as a warning).
  9. Walkthrough: **copy/paste, the two-scrap protocol** — desk scrap vs TE private scrap; Cut/Copy = TECut/TECopy + ZeroScrap + TEToScrap; Paste = TEFromScrap + TEPaste; the glue-vs-trap lesson (TEToScrap/TEFromScrap have NO trap word — `uitext.cla`'s verified-absent citation); how the Clarus runtime implements the bridge on each lane (rider 2); note Clarus programs get this free via `standard edit`.
  10. **Hard-won lessons:** (a) Mini vMac doesn't model 68000 address errors — a native PASS doesn't prove alignment; eyeball odd `.W`/`.L` bases in listings; (b) using the catalog — build-list or `include` usage, and the dedup rule making identical redeclaration safe; what happens when a redeclaration DIFFERS (compile error naming both sites).
  Every code block that declares a trap must show a trap word that exists in the repo's verified set (catalog files, runtime, suite) — no fresh unverified trap words in doc examples.
- [ ] **Step 2: Self-check vs Ch13.** Grep each trap word/type claim in the doc against the reference + catalog; zero contradictions allowed.
- [ ] **Step 3: Commit:** `git add docs/clarus-toolbox-cookbook.md && git commit -m "docs: Clarus Toolbox cookbook (worked IM transcription walkthroughs)"`

---

### Task 7: Re-baseline ROADMAP + CLAUDE.md

**Files:**
- Modify: `docs/ROADMAP.md` (item 3 block ~lines 1116-1135: mark the docs cookbook DONE with outcome summary; record the starter catalog as shipped, the riders, the ScrapStuff/no-snapshot plan-stage corrections, and the `Ui*` sunset follow-on as the new open item)
- Modify: `CLAUDE.md` (toolbox suite case count 23→24 real? NO — check: spec says 23 real + SelfCheck = 24 total... CLAUDE.md today says "23 `ToolboxTest` cases: 22 real + `SelfCheck`" → becomes "24 cases: 23 real + SelfCheck"; add a short `toolbox/` catalog bullet in the build/test section pointing at the cookbook doc)

**Interfaces:** consumes everything above; keeper of the phase record.

- [ ] **Step 1: ROADMAP edit.** Follow the existing DONE-block style (see item 2b's Outcome paragraph as the model): date, what shipped, deviations (ScrapStuff→peek offsets; no snapshot regen needed and why), riders' outcomes, sunset follow-on filed under the open-items list.
- [ ] **Step 2: CLAUDE.md edit.** Case-count strings, `toolbox/` catalog mention (2-3 lines max — CLAUDE.md is an operating manual, not a changelog), cookbook doc pointer next to the language-reference pointer.
- [ ] **Step 3: Stale-reference sweep:** `grep -rn "22 real\|23 cases\|nTbCases" CLAUDE.md docs/ROADMAP.md internal/ testsuite/` — fix every stale count the previous steps didn't catch.
- [ ] **Step 4: T1:** `scripts/test-task.sh` — green.
- [ ] **Step 5: Commit:** `git add CLAUDE.md docs/ROADMAP.md && git commit -m "docs: toolbox-cookbook re-baseline (ROADMAP item 3 DONE, suite counts, catalog pointers)"`

---

## Final gate (before requesting merge)

- [ ] Full T2: `scripts/test-merge.sh` — green (includes both gated suite boots at 24/24 and the 30m selfhost suite; `TestSnapshotFixedPoint` must pass WITHOUT regeneration).
- [ ] Whole-branch review (superpowers:requesting-code-review), most capable model, per house convention.
