# Compiler-cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close all 29 open entries of `docs/TODO.md`'s "Compiler correctness / diagnostics" section in one phase, with the cg68k goldens blessed twice and the `clarusc.c` snapshot regenerated once.

**Architecture:** Two waves. Wave 1 touches only the runtime (`runtime/clarus/*.cla`, `runtime/mac/`) and the test harness, ending in bless #1. Wave 2 touches only the compiler (`clarusc/*.cla`) in three parallel tracks — one serialized codegen task that owns the `.s` goldens, two diagnostics tasks, one driver task — ending in the snapshot regeneration and close-out. Three TODO entries are dispositioned without code (already fixed / obsolete / closed with a guard fixture).

**Tech Stack:** Clarus (the compiler and runtime are Clarus; `clarusc/*.cla`, `runtime/clarus/*.cla`), C host runtime (`runtime/host`), Retro68 C shims (`runtime/mac`), POSIX-sh test harness (`tests/**/*.sh`, `tests/lib.sh` vocabulary), Mini vMac for native suite boots.

**Spec:** `docs/superpowers/specs/2026-09-05-compiler-cleanup-design.md` — every task below cites its spec section; read that section before starting the task.

## Global Constraints

- Branch `compiler-cleanup` off `main` (`62b1401` or later). Feature branch per plan; `main` stays green; merge only on Andrew's request.
- Implementation is subagent-driven (`model: sonnet` for implementation and review; `haiku` only for mechanical batch edits). The top-level session does not write implementation code.
- `.cla` files may contain MacRoman bytes (the `�` in comments). NEVER use the Edit tool on a `.cla` file that contains them; use `LC_ALL=C sed` or a Python script writing bytes, and byte-diff afterwards (`git diff --stat` + `cmp`). Check first: `LC_ALL=C grep -c $'[\x80-\xff]' FILE`.
- Test scripts are `#!/bin/sh`, POSIX only (no arrays, `[[ ]]`, `local`, `echo -e`), start with `. "$(dirname "$0")/../lib.sh" || exit 2`, print `PASS <name>`/`FAIL <name>: <detail>` via `t_pass`/`t_fail`, end with `t_done`, exit 77 via `skip`/`require_env`/`require_tool` for a missing gate. `tests/lib.sh` is FROZEN — never edit it.
- There is no test result cache; every `make test T=...` re-runs the selected scripts. `make -j tools bootstrap` first in a fresh checkout.
- Per-task gate: `scripts/test-task.sh` (T1). Add `--smoke` when the task touches `runtime/` or `clarusc/`. Emulator boots own the screen: **only one Mini vMac boot at a time on this machine.** Before any `CLARUS_MAC_TESTS=1` run, check `pgrep -x minivmac`; if one is running, wait or defer that proof to the wave-end task (Tasks 5 and 10), and say so in the task report.
- **Blessing:** only Task 5 blesses in wave 1 (`CLARUS_CG68K_BLESS=1`, `CLARUS_MAC_BLESS=1` if a trace/snap golden moved) and only Task 6 blesses `testdata/cg68k/*.s` in wave 2. Every other task that sees a golden diff REPORTS it (paste `first_diff` output) and does not bless. Each bless value must be exactly `1`.
- `.expect` goldens under `testdata/errors/` embed the path `../../testdata/errors/<f>.cla:L:C: <msg>`; generate them by running `clarusc emit` FROM `tests/selfhost/` exactly as `tests/selfhost/diag.sh` does.
- Snapshot regeneration happens ONCE, in Task 10, with the recipe `tests/selfhost/fixedpoint.sh` prints. Wave-2 tasks compile with the current snapshot-built compiler and run tests against `build-run/clarusc-current` (which `make bootstrap` rebuilds from source); they do not touch `clarusc/clarusc.c`.
- `clarusc/bake.cla` is NOT edited anywhere in this plan (keeps the 55-minute Snow `clarusc_bake` rule from firing).
- Commit messages end with the two attribution lines given in the session's system reminder.
- Task reports go to `.superpowers/sdd/2026-09-05-compiler-cleanup/task-N-report.md` (the SDD workspace is a phase record; never delete it).

---

## Wave 1 — runtime and harness (Tasks 1–4 in parallel, then Task 5)

### Task 1: Stale master pointers passed into allocating traps (spec §3.1)

**Files:**
- Modify: `runtime/clarus/uitable.cla` (~396-414 `rtUiTableDrawField`; ~880-889 `rtUiTableSyncOne`)
- Modify: `runtime/clarus/uiwidgets.cla` (~846-856 string-field setter; ~948-995 textview live-paint setter; ~1150-1158 `table.selected` setter)
- Read first: `runtime/clarus/uitable.cla:505-514` (`rtUiMakeLdefStub`, the `UiHLock` precedent), `runtime/clarus/ui.cla:204-205` (`UiHLock`/`UiHUnlock` externs), `runtime/clarus/uitext.cla:237-238` (`UiHGetState`/`UiHSetState` externs), `git show bff3268` (the rule this task extends).

**Interfaces:**
- Consumes: `UiHGetState(h: ptr): int`, `UiHSetState(h: ptr, flag: int)`, `UiHLock(h: ptr)`, `UiHandleDeref(h: ptr): ptr` — all existing runtime externs/helpers.
- Produces: nothing new. No signature changes.

The rule: at each site, the handle whose master pointer is passed into `UiDrawText`/`UiInvalRect`/`UiTEUpdate`/`UiValidRect` is locked for the duration of the call(s), with the handle's prior state restored afterwards (`UiHGetState`/`UiHSetState`, so an already-locked handle stays locked — do NOT use bare `UiHUnlock`, which would unlock a handle the caller had locked).

- [ ] **Step 1: Confirm the four sites still match the survey**

Run:
```sh
grep -n 'UiDrawText(base + 1, 0, peekb(base))' runtime/clarus/uitable.cla
grep -n 'UiInvalRect(lhMp + rtUiListRView)' runtime/clarus/uitable.cla
grep -n 'UiInvalRect(UiHandleDeref(te) + rtUiTeViewRect)' runtime/clarus/uiwidgets.cla
grep -n 'UiInvalRect(UiHandleDeref(lh) + rtUiListRView)' runtime/clarus/uiwidgets.cla
```
Expected: 1, 1, 2, 1 hits. If a count differs, stop and report.

- [ ] **Step 2: `rtUiTableDrawField` — determine what `rec` derives from**

Read `rtUiTableDrawField`'s callers (`grep -n 'rtUiTableDrawField(' runtime/clarus/uitable.cla`) back to where `rec` is computed. Two possible outcomes, both acceptable, both must be written into the task report:
  - `rec` is a master-pointer-relative address of a relocatable block (the row list's storage handle, or a `UiHandleDeref` result): apply Step 3.
  - `rec` is inside a non-relocatable `UiNewPtr` block: the site is NOT a hazard; add a one-line comment at the call saying so (`// rec is NewPtr storage -- not relocatable, no lock needed (compiler-cleanup)`) and skip Step 3.

- [ ] **Step 3: Lock around `UiDrawText`** (only if Step 2 found a relocatable source; `recH` is whatever handle Step 2 identified — pass it in or re-derive it the way the caller does)

```
    if ftype == rtUiFtStr {
        // compiler-cleanup: DrawText itself can allocate (font strike load)
        // while `base` -- a master-pointer-relative address -- is already
        // evaluated as its argument: the relocation window is INSIDE the
        // trap, the one shape bff3268's re-derive-before-the-call rule
        // cannot cover. Lock the block for the call; restore its prior
        // state (not a bare HUnlock -- a caller may hold it locked).
        hstate = UiHGetState(recH)
        UiHLock(recH)
        UiDrawText(base + 1, 0, peekb(base))
        UiHSetState(recH, hstate)
    } else if ftype == rtUiFtInt {
```
Declare `var hstate: int` (and `var recH: ptr` if needed) in the function's var block.

- [ ] **Step 4: `rtUiTableSyncOne` (~886-887)**

Replace
```
    lhMp = UiHandleDeref(lh) // re-derive: LAddRow/LDelRow can move memory
    UiInvalRect(lhMp + rtUiListRView)
```
with
```
    // compiler-cleanup: InvalRect can allocate (update region growth) while
    // holding the ListRec master pointer as its argument -- lock lh across
    // the call. Prior state restored, not blindly unlocked.
    hstate = UiHGetState(lh)
    UiHLock(lh)
    UiInvalRect(UiHandleDeref(lh) + rtUiListRView)
    UiHSetState(lh, hstate)
```
Add `var hstate: int`. If `lhMp` has no remaining use in the function, delete its declaration.

- [ ] **Step 5: `uiwidgets.cla` string-field setter (~853)** — same shape with `te`:

```
        UiTECalText(te)
        hstate = UiHGetState(te)
        UiHLock(te)
        UiInvalRect(UiHandleDeref(te) + rtUiTeViewRect)
        UiHSetState(te, hstate)
        rtUiTeMutated(instV, wIdx, false) // PROGRAMMATIC set -- no trace/event
```

- [ ] **Step 6: `uiwidgets.cla` textview live-paint setter (~955-994)** — lock across the whole InvalRect..ValidRect region:

Insert before the `UiInvalRect(UiHandleDeref(te) + rtUiTeViewRect)` at ~955:
```
    // compiler-cleanup: te's master pointer is handed into InvalRect here
    // and, after rtUiTeMutated's own scroll sync, into TEUpdate and
    // ValidRect below (teMp) -- lock the TERec for the whole region. The
    // TERec's TEXT lives in its own handle, so TEUpdate/TECalText growing
    // the text are unaffected by locking the record itself.
    hstate = UiHGetState(te)
    UiHLock(te)
```
and after `UiValidRect(teMp + rtUiTeViewRect)` (~994), before `UiSetPort(savedPort)`:
```
    UiHSetState(te, hstate)
```
Keep the existing `teMp = UiHandleDeref(te) // AFTER the NewPtr` line (harmless; the block no longer moves). Add `var hstate: int`.

- [ ] **Step 7: `uiwidgets.cla` `table.selected` setter (~1155)** — same shape as Step 4 with `lh`.

- [ ] **Step 8: Byte-safety check and build**

Run: `LC_ALL=C grep -c $'[\x80-\xff]' runtime/clarus/uitable.cla runtime/clarus/uiwidgets.cla` and compare the counts against `git stash`-free baseline (`git show HEAD:runtime/clarus/uitable.cla | LC_ALL=C grep -c $'[\x80-\xff]'`). Counts must be unchanged.
Run: `make -j tools bootstrap && make test T=cg68k/goldens T=emitui/goldens`
Expected: golden DIFFS in fixtures that splice the UI runtime (expected — the runtime changed). Paste the `first_diff` summary for two of them into the task report and confirm the diff is only the new lock/state calls. Do NOT bless.

- [ ] **Step 9: Native proof (if the emulator is free)**

Run: `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k T=mactest/coresuite_68k T=mactest/smoke_bounce`
Expected: PASS for every case (35 toolbox cases at this point). If the emulator was busy, write "native proof deferred to Task 5" in the report.

- [ ] **Step 10: Commit**

```sh
git add runtime/clarus/uitable.cla runtime/clarus/uiwidgets.cla
git commit -m "fix(runtime): lock handles whose master pointers are passed into allocating traps (4 sites)"
```

### Task 2: Textview 16-bit clamp + cprint-lane FreeMem shims (spec §3.2, §3.3)

**Files:**
- Modify: `runtime/clarus/uitext.cla:340-372` (`rtUiTeScrollSync`)
- Modify: `runtime/mac/rt_ext_mac.inc` (~43, beside `rt_ext_GetHandleSize`)
- Read first: `testsuite/toolbox/cases_leak.cla:25`, `testsuite/toolbox/cases_clearwarm.cla:16` (the two externs), `scripts/build-mac.sh:245-260`.

**Interfaces:**
- Produces: C symbols `int32_t rt_ext_TbFreeMem(void)`, `int32_t rt_ext_TbClearWarmFreeMem(void)`.

- [ ] **Step 1: Clamp both branches of `rtUiTeScrollSync`**

Vertical (~347-350): after
```
        if maxScroll < 0 {
            maxScroll = 0
        }
```
add
```
        // compiler-cleanup: UiTEScroll's dv and the control traps' values
        // are `word` -- an int above 32767 truncates at the trap boundary.
        // Straight clamp (no proportional remap): no user has hit it.
        if maxScroll > 32767 {
            maxScroll = 32767
        }
```
Horizontal (~368-371): the same four lines after the horizontal `maxScroll < 0` clamp. The existing `offset > maxScroll` clamps then bound `offset` transitively — verify by reading that both branches still compare `offset` against `maxScroll` AFTER the new clamp.

- [ ] **Step 2: Add the two shims**

In `runtime/mac/rt_ext_mac.inc`, immediately after the `rt_ext_GetHandleSize` line:
```c
/* compiler-cleanup: testsuite/toolbox's LeakCheck/ClearWarm cases bind
   FreeMem (trap 0xA01C) under two Clarus extern names; cprint emits one
   rt_ext_<Name> call per extern, so each needs its own shim. */
int32_t rt_ext_TbFreeMem(void) { return (int32_t)FreeMem(); }
int32_t rt_ext_TbClearWarmFreeMem(void) { return (int32_t)FreeMem(); }
```

- [ ] **Step 3: Host-side checks**

Run: `make test T=cg68k/goldens T=emitui/goldens`
Expected: `.s` diffs limited to fixtures splicing `uitext.cla` (report, do not bless).
Run: `ls toolchain/bin/m68k-apple-macos-gcc && toolchain/bin/m68k-apple-macos-gcc -fsyntax-only -I runtime/mac -I runtime/host runtime/mac/rt_mac.c` — Expected: no errors (skip with a note if the toolchain symlink is absent).

- [ ] **Step 4: Link proof for the cprint twin (if the emulator is free)**

Run: `pgrep -x minivmac || CLARUS_MAC_TESTS=1 CLARUS_CPRINT_MAC_TESTS=1 make -j1 test T=mactest/toolbox_mac`
Expected: the build LINKS (no `undefined reference to rt_ext_TbFreeMem`). The boot's per-case result is reported as observed; any pre-existing cprint-lane case failure is recorded in the report, not fixed (spec §3.3).

- [ ] **Step 5: Commit**

```sh
git add runtime/clarus/uitext.cla runtime/mac/rt_ext_mac.inc
git commit -m "fix(runtime): clamp textview scroll range to 16 bits; add cprint FreeMem shims for the toolbox twin"
```

### Task 3: `CasesTable` toolbox suite case (spec §3.4)

**Files:**
- Create: `testsuite/toolbox/cases_casestable.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum ~136-172, `nTbCases` ~181, `tbCaseName`, `tbAllCases` ~298, dispatch ~353, the stale "32 real cases here" comment ~354)
- Modify: `tests/mactest/toolbox_files.txt` (append the new file before `testsuite/toolbox/gui.cla`)
- Modify: `tests/mactest/toolbox_68k.sh:19`, `tests/mactest/toolbox_jiggle.sh:28`, `tests/mactest/toolbox_mac.sh:26` (`suite_report_check ... 35` → `36`) and each script's header comment that says "35".
- Read first: `testsuite/toolbox/cases_popuptable.cla:20-62,117-125` (the three-checksum shape and its geometry constants), `testsuite/toolbox/gui.cla:1-60` (the `Cases` table geometry), `runtime/clarus/uitest.cla:264` (`UiTestChecksum(x, y, w, h): int`; `x` and `w` must be multiples of 8, else it returns -1).

**Interfaces:**
- Consumes: `UiTestChecksum(x: int, y: int, w: int, h: int): int`, `tkPass(name: string): TestResult`, `tkFail(name: string, detail: string): TestResult`, `tkIntToStr(n: int): string` (all existing).
- Produces: `func caseCasesTable(): TestResult`; enum member `ToolboxTest.CasesTable`; `nTbCases = 36`.

Geometry: `gui.cla`'s `table Cases` is local (10,10)-(310,130) → global (46,54)-(346,174). List Manager row pitch is 16 px (cases_popuptable.cla: `tbPtRow0Y = 82`, `tbPtRow1Y = 98`). Row `r`'s cell spans global y `55 + 16r` .. `70 + 16r`; the table shows 7 rows. Band per row: `x0 = 48` (multiple of 8, inside the cell), `w = 288` (multiple of 8, ends at 336 < 346), `y0 = 57 + 16r`, `h = 12`.

- [ ] **Step 1: Write the case**

`testsuite/toolbox/cases_casestable.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_casestable.cla (compiler-cleanup phase): the suite GUI's OWN
// `Cases` table is drawn through the same List-Manager LDEF path as every
// other table widget. During the 68k-call-result-release phase a heap
// probe caught it reading a zeroed record (lastLen 0, lastCount 33) in a
// failing build -- every row name drew EMPTY -- and nothing went red,
// because no case looked at those pixels. This case does: every visible
// row band must contain ink (a checksum of 0 is an all-white band), and
// a second read of row 0 must equal the first (the table is not being
// repainted with different content between two reads).
//
// Geometry (gui.cla's own header derivation): table global rect
// (46,54)-(346,174); List Manager row pitch 16 (cases_popuptable.cla's
// tbPtRow0Y/tbPtRow1Y); 7 visible rows. Band x0/w are multiples of 8 per
// UiTestChecksum's alignment contract.
const tbCtRowX0: int = 48
const tbCtRowW: int = 288
const tbCtRowY0: int = 57
const tbCtRowPitch: int = 16
const tbCtRowH: int = 12
const tbCtVisibleRows: int = 7

func caseCasesTable(): TestResult {
    var r: int
    var c: int
    var c0: int
    var again: int

    r = 0
    while r < tbCtVisibleRows {
        c = UiTestChecksum(tbCtRowX0, tbCtRowY0 + r * tbCtRowPitch, tbCtRowW, tbCtRowH)
        if c == -1 {
            return tkFail("CasesTable", "checksum alignment rejected at row " + tkIntToStr(r))
        }
        if c == 0 {
            return tkFail("CasesTable", "row " + tkIntToStr(r) + " band is blank")
        }
        if r == 0 {
            c0 = c
        }
        r = r + 1
    }
    again = UiTestChecksum(tbCtRowX0, tbCtRowY0, tbCtRowW, tbCtRowH)
    if again != c0 {
        return tkFail("CasesTable", "row 0 unstable: " + tkIntToStr(c0) + " then " + tkIntToStr(again))
    }
    return tkPass("CasesTable")
}
```

- [ ] **Step 2: Wire the runner**

In `runner.cla`: add `CasesTable` to `enum ToolboxTest` immediately before `SelfCheck`; change `const nTbCases: int = 35` to `36` and its doc comment's "34 real cases" to "35 real cases"; add the `tbCaseName` arm (`case CasesTable { return "CasesTable" }` in the same shape as its neighbours); add `l.add(CasesTable)` to `tbAllCases()` before `SelfCheck`'s own line; add the dispatch arm in `runToolboxTests` mirroring the `ClearWarm` arm but calling `caseCasesTable()`. Replace the comment fragment `-- 32 real cases here,` with `-- one arm per real case,` so the comment carries no count.

- [ ] **Step 3: Wire the file lists and counts**

Append `testsuite/toolbox/cases_casestable.cla` to `tests/mactest/toolbox_files.txt` immediately before the `testsuite/toolbox/gui.cla` line. Change `suite_report_check "$WORK/cap.out" 35` → `36` in the three scripts and update each header comment's "35".

- [ ] **Step 4: Host-side compile check**

The toolbox suite has no host CLI, but it must still compile on the host. Check-only mode does not accept `--testapi` (CLAUDE.md), so use the native emit form:
```sh
build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ -o "$WORK/tb.bin" $(cat tests/mactest/toolbox_files.txt)
```
Expected: exit 0, no diagnostics.

- [ ] **Step 5: Native proof (if the emulator is free)**

Run: `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k`
Expected: `PASS CasesTable` among 36 PASS lines and `TOTAL 36 PASS 36 FAIL 0`. If `CasesTable` fails on `blank`, capture a snap (`testdata/ui/toolboxsuite.events` + a `snap` verb, see `tests/lib_mac.sh`) and adjust `tbCtRowY0` by ±2 once; if it still fails, stop and report the snap.

- [ ] **Step 6: Commit**

```sh
git add testsuite/toolbox/cases_casestable.cla testsuite/toolbox/runner.cla tests/mactest/toolbox_files.txt tests/mactest/toolbox_68k.sh tests/mactest/toolbox_jiggle.sh tests/mactest/toolbox_mac.sh
git commit -m "test(toolbox): CasesTable case pins the suite GUI's own table pixels (36 cases)"
```

### Task 4: Emitted-C pump-loop golden + `--rtbake` datetime smoke (spec §3.5, §3.6)

**Files:**
- Create: `testdata/emitui/connpump_abort.cla`, `testdata/emitui/connpump_abort.c.golden`
- Create: `tests/bake/datetime.sh`
- Read first: `tests/emitui/goldens.sh` (whole), `tests/bake/connfileh.sh` (whole — the template), `tests/lib_bake.sh` (`bake_ir`, `emit68k_pair`), `clarusc/cprint.cla:7596-7604` (the loop being pinned), `docs/clarus-language-reference.md` §"Attempt and Abort" (~755) for the `attempt { } aborted msg { }` / `abort("...")` syntax.

- [ ] **Step 1: Write the pump-loop fixture**

`testdata/emitui/connpump_abort.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// connpump_abort.cla (compiler-cleanup phase): pins cpEmitMain's host-lane
// pump loop TEXT -- `while (!clar_aborting && clar_fn_rtConnAlive())` --
// which only emits when the program uses BOTH a connection (irUsesConn)
// and abort (lowUsesAbort). tests/conntest/abort.sh proves the loop's
// BEHAVIOR; this golden is the byte-level tripwire a cprint.cla refactor
// that dropped the clar_aborting short-circuit would otherwise slip past.
var conn: connection

on App.startCLI(args: list of string) {
    attempt {
        conn.open(serial "modem:9600")
        conn.send("hello")
        abort("stop")
    } aborted msg {
        conn.close()
    }
}
```

- [ ] **Step 2: Generate and inspect the golden**

```sh
build-run/clarusc-current emit --rtdir runtime/clarus/ -o testdata/emitui/connpump_abort.c.golden testdata/emitui/connpump_abort.cla
grep -n 'while (!clar_aborting && clar_fn_rtConnAlive())' testdata/emitui/connpump_abort.c.golden
```
Expected: exactly one hit. If zero, the fixture did not trigger both flags — fix the fixture, not the expectation.

- [ ] **Step 3: Run the goldens script**

Run: `make test T=emitui/goldens`
Expected: `PASS connpump_abort.cla` (and the compile-check of the golden passes; SKIP as a whole only if the m68k gcc is absent — then note it).

- [ ] **Step 4: Write the datetime `--rtbake` smoke**

`tests/bake/datetime.sh`:
```sh
#!/bin/sh
# compiler-cleanup phase: T1-speed `emit68k --rtbake` byte-identity for the
# datetime runtime split (datetime_68k.cla / datetime_c.cla) -- the one
# per-lane value-typed runtime module tests/bake/connfileh.sh and
# identity.sh do not touch. Standing rule (CLAUDE.md): a phase that adds a
# value-typed runtime module adds its tests/bake/<module>.sh twin in the
# same task; a --rtbake-only bug in that module then fails HERE in T1, not
# in the opt-in full-corpus sweep.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/datetime.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var a: int
    var b: int
    var span: int

    a = now()
    b = now()
    span = b - a
    if span < 0 {
        quit 1
    }
    quit 0
}
CLA

if detail=$(emit68k_pair datetime "$WORK/datetime.cla"); then
    t_pass datetime.cla
else
    t_fail datetime.cla "$detail"
fi
t_done
```
`chmod +x tests/bake/datetime.sh`.

- [ ] **Step 5: Run it and the harness self-checks**

Run: `make test T=bake/datetime T=runner/`
Expected: `PASS datetime.cla`; `runner/syntax` still passes (`sh -n` over every script).

- [ ] **Step 6: Commit**

```sh
git add testdata/emitui/connpump_abort.cla testdata/emitui/connpump_abort.c.golden tests/bake/datetime.sh
git commit -m "test: pin cpEmitMain's abort-aware pump loop; add the datetime --rtbake T1 twin"
```

### Task 5: Wave-1 bless #1 and native gate (spec §5)

Runs after Tasks 1–4 are merged to the branch. Serial (owns the emulator).

**Files:**
- Modify (bless only): `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden`, and — only if a trace/snap moved — `testdata/uisnaps/*`.

- [ ] **Step 1: Baseline the diff before blessing**

Run: `make test T=cg68k/goldens T=emitui/goldens 2>&1 | tail -40`
For two failing `.s` fixtures and one `.c.golden`, run the script's `first_diff` output and confirm every hunk is one of: `UiHGetState`/`UiHLock`/`UiHSetState` call sequences (Task 1), the two `32767` clamps (Task 2). Anything else → stop and report.

- [ ] **Step 2: Bless**

Run: `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`. The emitui goldens have no bless variable; regenerate them with the SAME `clarusc emit` invocation `tests/emitui/goldens.sh` uses (read its emit line first and copy any flags it passes):
```sh
for f in testdata/emitui/*.cla; do
    g=${f%.cla}.c.golden
    [ -f "$g" ] || continue
    build-run/clarusc-current emit -o "$g" "$f" || echo "FAILED $f"
done
make test T=emitui/goldens
```
Expected: green.
Run: `git diff --stat testdata/ | tail -3` — record the file count in the report.

- [ ] **Step 3: T1**

Run: `scripts/test-task.sh --smoke`
Expected: green.

- [ ] **Step 4: Native gate**

Run: `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/`
Expected: green, including `PASS CasesTable` and `TOTAL 36 PASS 36 FAIL 0` in `toolbox_68k` and `toolbox_jiggle`. If a scenario's trace/snap golden legitimately moved (it should not — no scenario draws a textview near 32767 px or changes table drawing), investigate before considering `CLARUS_MAC_BLESS=1`.

- [ ] **Step 5: Opt-in cprint twin**

Run: `CLARUS_MAC_TESTS=1 CLARUS_CPRINT_MAC_TESTS=1 make -j1 test T=mactest/toolbox_mac`
Expected: links; boots; report the per-case outcome verbatim.

- [ ] **Step 6: Commit**

```sh
git add testdata/
git commit -m "test: bless #1 -- runtime-ripple goldens after the wave-1 lock/clamp fixes"
```

---

## Wave 2 — compiler (Tasks 6–9 in parallel, then Task 10)

### Task 6: Codegen track (spec §4.1 a–h) — ONE task, owns the `.s` bless

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgMaterializeToTemp` ~5811; `cgIntrListPopLike` ~7435; pop/shift dispatch ~8591; `cgReturnStmt` ~12227/12232; small-temp pool: `cgTmpSlots` ~1402, `cgAllocTmpOff` ~4143, frame layout ~5251-5258, plus new `cgFuncSmallTmpNeed`/`cgFuncSmallTmpHigh` beside `cgFuncBigTmpNeed` ~1155/`cgFuncBigTmpHigh` ~1466 and wherever `cgFuncBigTmpNeed[f]` is written at the end of the measure pass)
- Modify: `clarusc/cprint.cla` (pop/shift arm ~3003-3057)
- Modify: `clarusc/lower.cla` (`lowMethodCall` ~1326-1353; `lowSynthConnFireOpened`/`Closed` ~7413-7471; `lowSynthConnFireFailed` ~7537-7582; `lowSynthConnDispatchers` ~7586; `lowUiSynthExternName` ~7625-7628; the `usesConn or want68k` call site ~7827)
- Modify: `runtime/clarus/native.cla:1465-1476` (`nat_UiConnPump`)
- Modify: `testdata/cg68k/smalltmp_ceiling.cla`
- Modify: `testsuite/toolbox/cases_leak.cla` (`caseLeakCheck`, ~44-110)
- Bless: `testdata/cg68k/*.s` (this task only, at Step 12)
- Read first: spec §4.1 in full; `clarusc/cg68k.cla:4134-4200` (both pool allocators), `5244-5300` (frame layout), `1140-1160` and `1400-1470` (pool state doc comments); `clarusc/cprint.cla:1541-1554` (`fpCallFn`'s tracked-KRec shape, the host precedent for item a); `clarusc/lower.cla:7385-7412` (why the dispatchers are unconditional under `want68k`) and `7618-7630` (`lowUiSynthExternName`).

**Interfaces:**
- Produces: synthesized IR function `clar_conn_pump()` (no params, `irVoidT`), rooted, with a `lowUiSynthExternName` identity entry; `runtime/clarus/native.cla` declares `external func clar_conn_pump()`.
- Produces: `lowSynthConnFireSimple(eventKey: string, cName: string)` replacing the Opened/Closed builders.
- Produces: `var cgFuncSmallTmpNeed: list of int`, `var cgFuncSmallTmpHigh: int` (cg68k module state).

Order matters: commit after each lettered item so a reviewer can bisect. Run `make test T=cg68k/goldens` after each item and record (do not bless) which fixtures moved — the final bless (Step 12) must be attributable item by item.

- [ ] **Step 1 (a): tracked temp for handle-bearing call results in `cgMaterializeToTemp`**

Replace `off = cgAllocTmpOff(t)` with:
```
    // compiler-cleanup (TODO: makeRec().field leak): a handle-bearing
    // call result materialized here (cgExprAddr's generic fallback for a
    // KRec-returning call used as a receiver) must be TRACKED so its
    // handle fields are released at end of statement -- the native mirror
    // of cprint.cla fpCallFn's fpNewTrackedTmp shape.
    if irExprKind(e) == ECallFn and cgNeedsRelease(t) {
        off = cgNewTrackedTmp(t)
    } else {
        off = cgAllocTmpOff(t)
    }
```
Run `make test T=cg68k/goldens`; record moved fixtures. Commit: `fix(cg68k): track handle-bearing call results materialized as receivers`.

- [ ] **Step 2 (b): pop/shift always tracked, both lanes**

`cg68k.cla` `cgIntrListPopLike`: replace
```
    if e == cgDiscardExprIdx and cgNeedsRelease(elemT) {
        off = cgNewTrackedTmp(elemT)
    } else {
        off = cgAllocTmpOff(elemT)
    }
```
with
```
    // compiler-cleanup: pop/shift TRANSFER a freshly-owned handle out of the
    // list. Track it in EVERY position, not just the bare-discard statement
    // -- a consumer that takes ownership (assign dst, return, call arg)
    // hands it off (cgHandoff), exactly as cgIntrListFirstLast does; an
    // operand/receiver use (`lst.pop().length`) then gets released at end
    // of statement instead of leaking.
    if cgNeedsRelease(elemT) {
        off = cgNewTrackedTmp(elemT)
        cgLastTrackedOff = off
    } else {
        off = cgAllocTmpOff(elemT)
    }
```
Check the assign/return/call-arg consumers already hand off via `cgLastTrackedOff` (they do for `cgIntrListFirstLast`'s results — grep `cgLastTrackedOff` consumers; if `cgPushArgs`'s pop/shift-specific branch (~9917-9958) now double-tracks, delete that branch's own `cgNewTrackedTmp` and let the generic path handle it).

`cprint.cla` pop/shift arm: delete the `if x == fpDiscardExprIdx and fpNeedsRelease(...)` special case and make the ordinary path:
```
        if fpNeedsRelease(irExprType(x)) {
            t = fpNewTrackedTmp(irExprType(x))
        } else {
            t = fpNewTmp(cpCType(irExprType(x)))
        }
        if cpListPorted { ... same emission ... } else { ... }
        return t
```
removing the trailing `fpHandoff(t)` (a tracked temp is handed off by its consumer — `fpCallFnArg`, assignment, return — exactly as an `ECallFn` result is; verify by reading `fpHandoff`'s callers and `fpCallFnArg` ~1416-1493, and delete `fpCallFnArg`'s pop/shift-specific branch if it now double-tracks).
Run `make test T=cg68k/goldens T=lowlevel/ T=emitui/goldens`; record. Run the host leak fixtures: `make test T=cg68k/release` and any `tests/` script whose name contains `leak` (`ls tests/*/ | grep -i leak`). Commit: `fix(codegen): track pop/shift results in every position on both lanes`.

- [ ] **Step 3 (c): one predicate for the transfer intrinsics**

`cg68k.cla` ~8591: `if nm == IListPop() or nm == IListShift() {` → `if lowIntrIsOwningContainerRead(nm) {`. `cprint.cla` ~3003: same replacement. Add to `lowIntrIsOwningContainerRead`'s doc comment: "Both backends' pop/shift dispatch arms call THIS predicate — a third transfer intrinsic is added here and nowhere else." `grep -n 'IListPop() or nm == IListShift()' clarusc/*.cla` must return only the predicate itself. No golden change expected. Commit: `refactor(codegen): route pop/shift dispatch through lowIntrIsOwningContainerRead`.

- [ ] **Step 4 (h): `cgReturnStmt` single type computation**

```
        cgExpr(x)
        retT = irExprType(x)
        rk = irtKind(retT)
        ...
        if cgStmtTmpOffs.count > 0 {
            // (retT already computed above)
```
Delete the second `retT = irExprType(x)`. No golden change. Commit: `refactor(cg68k): compute the return type once in cgReturnStmt`.

- [ ] **Step 5 (f): kind-based textview dispatch**

Replace the `TyWidget` arm's name test with:
```
    if xk == TyWidget {
        // compiler-cleanup: dispatch on the WIDGET KIND, not the method
        // name -- a second textview method no longer falls into
        // lowCanvasMethod's misleading "canvas method X" lowUnsupported.
        wr = lowWidgetRecv(selectX(fn))
        wkind = findWidgetKind(wr.winNameIdx, wr.wgName)
        if wkind == "textview" {
            return lowTextviewMethod(e, fn, ty)
        }
        if wkind == "canvas" {
            return lowCanvasMethod(e, fn, ty)
        }
        lowUnsupported("method on " + wkind + " widget")
        return -1
    }
```
with `var wr: LowWidgetRecv` and `var wkind: string`. CAUTION: `lowWidgetRecv` calls `lowExpr(selectX(recvAst))` and so emits the receiver's instance IR; `lowTextviewMethod`/`lowCanvasMethod` peel the receiver themselves and would lower it a second time. Read both; if they call `lowWidgetRecv` internally, pass `wr` in (add a parameter) rather than computing it twice — duplicated receiver lowering is a correctness bug, not just waste. Run `make test T=emitui/ T=cg68k/goldens`; `scrollend_*.expect` unchanged. Commit: `fix(lower): dispatch widget methods by widget kind`.

- [ ] **Step 6 (g): fold Opened/Closed; declare `err` only when needed**

Replace `lowSynthConnFireOpened` and `lowSynthConnFireClosed` with one builder:
```
// lowSynthConnFireSimple builds clar_conn_fire_<eventKey>(slot: int) for
// the two argument-less events (opened/closed) -- compiler-cleanup folded
// the two former copies; Received/Failed carry extra params and stay
// separate.
func lowSynthConnFireSimple(eventKey: string, cName: string) {
    var paramsHead: int
    var conds: list of int
    var bodies: list of int
    var i: int
    var fnName: int
    var chain: int
    var fnameIdx: int

    paramsHead = newIRLocal(intern("slot"), irIntT)
    i = 0
    while i < 4 {
        fnName = lowConnHandlerFn.get(numToStr(i) + "|" + eventKey, -1)
        conds.add(lowSynthEqInt("slot", i))
        if fnName != -1 {
            bodies.add(newIRExprStmt(newIRCallFn(fnName, -1, irVoidT)))
        } else {
            bodies.add(-1)
        }
        i = i + 1
    }
    chain = lowSynthFoldIfChain(conds, bodies, -1)
    fnameIdx = intern(cName)
    newIRFunc(fnameIdx, paramsHead, irVoidT, -1, chain)
    shakeAddRoot(fnameIdx)
}
```
and in `lowSynthConnDispatchers`: `lowSynthConnFireSimple("opened", "clar_conn_fire_opened")` / `lowSynthConnFireSimple("closed", "clar_conn_fire_closed")` in the same ORDER as before (Opened, Received, Closed, Failed — IR function order affects emission order and thus goldens; keep it).

In `lowSynthConnFireFailed`: compute `anyFailed` first (loop `i` 0..3, `lowConnHandlerFn.has(numToStr(i) + "|failed")`), and call `lowAddLocal(intern("err"), irErrT)` only `if anyFailed`. The per-slot loop is unchanged (it only references `err` when `fnName != -1`).
Run `make test T=cg68k/goldens`: Opened/Closed fixtures byte-identical; the `err` elision moves goldens whose programs have no `failed` handler (frame shrinks by 260) — record which. Commit: `refactor(lower): fold the opened/closed dispatcher builders; elide the unused err local`.

- [ ] **Step 7 (e): synthesized `clar_conn_pump`**

`runtime/clarus/native.cla`: replace `nat_UiConnPump`'s body:
```
// ... (existing comment, then:)
// compiler-cleanup: forwards through the compiler-synthesized
// clar_conn_pump() (lower.cla lowSynthConnPump), whose body is
// rtConnPump() only when the program uses a connection and EMPTY
// otherwise -- so a conn-less native build no longer carries rtConnPump
// and everything under it (the +5-7% .s the serial-connection review
// measured). Same seam as the four clar_conn_fire_* stubs conn.cla calls.
external func clar_conn_pump()

func nat_UiConnPump() {
    clar_conn_pump()
}
```
`lower.cla`: add beside the other builders:
```
// lowSynthConnPump builds clar_conn_pump(): the UI event loop's pump hook
// (native.cla nat_UiConnPump). Body is rtConnPump() when usesConn, else
// empty -- the one place a conn-less native build is cut off from the
// conn runtime's reachability.
func lowSynthConnPump() {
    var fnameIdx: int
    var body: int

    body = -1
    if usesConn {
        body = newIRExprStmt(newIRCallFn(intern("rtConnPump"), -1, irVoidT))
    }
    fnameIdx = intern("clar_conn_pump")
    newIRFunc(fnameIdx, -1, irVoidT, -1, body)
    shakeAddRoot(fnameIdx)
}
```
Call it from `lowSynthConnDispatchers()` (last). Add `if nm == "clar_conn_pump" { return intern("clar_conn_pump") }` to `lowUiSynthExternName`. Check `newIRCallFn(intern("rtConnPump"), ...)`: if `newIRCallFn` takes an IR function INDEX rather than a name, use `findIRFuncIdxByName(intern("rtConnPump"))` and abort with a clear message if it returns -1 while `usesConn` (it cannot — `conn.cla` is spliced whenever `usesConn`). Host lane: `lowSynthConnDispatchers` runs there only when `usesConn`; `cpEmitMain` never calls `clar_conn_pump`, so the extra function is dead but harmless C. If the host emitted-C goldens (`emitui/goldens`) move because of the new function, that is expected — record it for Task 10 (emitui goldens are NOT blessed by this task; see Step 12 note).

Acceptance: 
```sh
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o "$WORK/nonconn.bin" testdata/cg68k/globals.cla   # any non-conn UI fixture
```
then the `.s` for that fixture (from `make test T=cg68k/goldens`'s work dir, or `emit68k`'s `-S`-style output if the backend has one — check `clarusc/main.cla`'s flags) must contain NO `rtConnPump`/`rtConnAlive` label. Record `wc -l` of the whole `testdata/cg68k/*.s` set before and after in the report (the TODO's +5-7%). Commit: `feat(lower): synthesized clar_conn_pump cuts the conn runtime out of conn-less native builds`.

- [ ] **Step 8 (d): per-function small-temp pool**

Mirror the big pool exactly:
1. State (beside `cgFuncBigTmpNeed`/`cgFuncBigTmpHigh`): `var cgFuncSmallTmpNeed: list of int` and `var cgFuncSmallTmpHigh: int`, with doc comments modelled on the big pool's (~1143-1160, ~1459-1466).
2. Pre-size `cgFuncSmallTmpNeed` to 0 per function wherever `cgFuncBigTmpNeed` is pre-sized in `cg68Measure` (grep `cgFuncBigTmpNeed.add`), and write `cgFuncSmallTmpNeed[f] = cgFuncSmallTmpHigh` wherever `cgFuncBigTmpNeed[f] = cgFuncBigTmpHigh` is written at the end of the measure pass.
3. Frame layout (~5251-5258): replace the `while i < cgTmpSlots` loop's bound with `smallTmpCount`, computed as `cgFuncSmallTmpNeed[f]` (floor 0; on the measure pass this is 0 and the allocator grows the list), and reset `cgStmtTmpNext = 0` / `cgFuncSmallTmpHigh = 0` beside the big pool's resets.
4. `cgAllocTmpOff`: replace the `if cgStmtTmpNext >= cgTmpSlots { abort(...) }` ceiling with the big pool's grow-on-measure/abort-on-emit shape:
```
    if cgStmtTmpNext >= cgTmpBaseOffs.count {
        if cgRecMode != 1 {
            abort("cg68k: small-temp need mismatch between measure and emit passes")
        }
        if cgTmpBaseOffs.count == 0 {
            newOff = cgSmallTmpFirstOff   // the offset the layout would have used for slot 0 -- see step 5
        } else {
            newOff = cgTmpBaseOffs[cgTmpBaseOffs.count - 1] - 4
        }
        cgTmpBaseOffs.add(newOff)
    }
    off = cgTmpBaseOffs[cgStmtTmpNext]
    cgStmtTmpNext = cgStmtTmpNext + 1
    if cgStmtTmpNext > cgFuncSmallTmpHigh {
        cgFuncSmallTmpHigh = cgStmtTmpNext
    }
    return off
```
5. The growth needs a starting offset when the pool is empty: record `cgSmallTmpFirstOff = runningNeg - 4` in the frame layout at the point where slot 0 would go (the big pool never has this problem because `cgBigTmpFloor = 4`). Layout ORDER must be identical on both passes: small pool, then `cgRetSaveOff`, then big pool, then deep scratch — the measure pass lays out 0 small slots, and the emit pass lays out `need` slots, so `cgRetSaveOff`/big-pool offsets DIFFER between passes for any function with temps. Read how the big pool copes with the same shift today (its own size differs between passes too, and everything below it — deep scratch — shifts): the measure pass's bytes are discarded, so only the emit pass's offsets matter, PROVIDED nothing caches an offset across passes. Grep for module-level `var`s holding frame offsets (`cgRetSaveOff`, `cgDeep*`) and confirm they are re-assigned per function in `cgEmitFunc`.
6. Delete `const cgTmpSlots` and its doc comment; fix every comment that names it (`grep -n cgTmpSlots clarusc/cg68k.cla` must return nothing).
7. `testdata/cg68k/smalltmp_ceiling.cla`: change the header comment to describe the pin as "no per-statement ceiling — 30 concurrent small temps", make `sum14` a `sum30` with 30 `int` params, push 30 values, call it with 30 `nums.pop()` arguments, and expect total `465`.

Run `make test T=cg68k/ T=selfhost/` — selfhost's self-compile must still fit the frame cap (`frameSize > 32767` abort). Record the `.s` churn (every fixture with a function that uses fewer than 24 temps moves). Commit: `perf(cg68k): size the small-temp pool per function (no flat 24-slot tax, no ceiling)`.

- [ ] **Step 9: Extend `LeakCheck` (hardware proof for a and b)**

In `testsuite/toolbox/cases_leak.cla`, add a record + maker beside `tlkMake`:
```
// tlkRec/tlkMakeRec: a handle-bearing record returned by value and
// consumed as a RECEIVER (`tlkMakeRec().body`) -- the makeRec().field
// shape cgMaterializeToTemp now tracks (compiler-cleanup).
record TlkRec {
    n: int
    body: text
}

func tlkMakeRec(): TlkRec {
    var r: TlkRec
    r.n = 1
    r.body = "rec body"
    return r
}
```
and inside the 1500-iteration loop, after the existing shapes:
```
        // handle-bearing record call result as receiver (compiler-cleanup)
        n = n + tlkMakeRec().body.length
        // pop/shift as receiver and operand (compiler-cleanup): each
        // iteration pushes one fresh text and pops it back in a
        // non-argument position
        pool.push(tlkMake())
        n = n + pool.pop().length
        pool.push(tlkMake())
        n = n + (pool.pop() + "x").length
```
with `var pool: list of text` declared. Pre-fix these three shapes leak one text handle per iteration each (~3 × 1500 blocks); the existing 8 KB slack cleanly separates pass from fail. Keep the case name `LeakCheck`.

- [ ] **Step 10: Host-side gates**

Run: `scripts/test-task.sh --smoke` (everything except the un-blessed `.s`/emitui goldens must be green; list the golden failures and confirm each is attributable to items a, b, d, e, or g).

- [ ] **Step 11: Native proof**

Run (emulator free): `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k T=mactest/toolbox_jiggle T=mactest/coresuite_68k`
Expected: `PASS LeakCheck`, `PASS ClearWarm`, `TOTAL 36 PASS 36 FAIL 0`. A `LeakCheck` failure here with a FreeMem delta means a leak path a/b did not cover — stop and report the delta, do not widen the slack.

- [ ] **Step 12: Bless the `.s` goldens (this task only)**

Run: `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`, then `make test T=cg68k/` un-blessed → green. Do NOT regenerate `testdata/emitui/*.c.golden` here: if Step 7 moved them, note it for Task 10 (which regenerates emitui goldens together with the snapshot so Tasks 7–9's diagnostic/driver changes are included once).

```sh
git add testdata/cg68k/
git commit -m "test(cg68k): bless #2 (codegen) -- tracked temps, per-function small pool, clar_conn_pump, err elision"
```

### Task 7: Diagnostics A — lexer, conversions, duplicate const, `edit` target (spec §4.2)

**Files:**
- Modify: `clarusc/lex.cla` (`lexString` ~522-566; new `lexResyncStringLit` beside `lexResyncCharLit` ~470-481)
- Modify: `clarusc/check.cla` (`checkConversion` ~5609-5648; `checkConstDecl` ~2800-2840; `checkEditStmt` ~4985-5047)
- Modify: `clarusc/lower.cla` (`name == "string"` arm ~1270-1275)
- Modify: `testsuite/core/cases_textbinary.cla` (`caseIntToStr` ~151)
- Modify: `docs/clarus-language-reference.md` (~205-213, Numeric Conversions)
- Create: `testdata/errors/lex_str_badescape.cla` + `.expect`, `testdata/errors/int_conv_identity.cla` + `.expect`, `testdata/errors/const_dup.cla` + `.expect`, `testdata/errors/edit_sortedmap_elem.cla` + `.expect`, `testdata/errors/edit_intmap_elem.cla` + `.expect`
- Modify: `testdata/errors/string_conv_arg.expect` (rebless to the new wording)
- Delete: `testdata/diag/lex_badescape.cla`, `testdata/diag/lex_untermstr.cla`, `testdata/diag/chk_convto.cla`, `testdata/diag/chk_convfromto.cla`, `testdata/diag/chk_convargs.cla` (inert: empty `.expect`, referenced by no runner — confirm with `grep -rn <name> tests/ clarusc/` before each `git rm`)
- Read first: `tests/selfhost/diag.sh`, `tests/emitui/popupguards.sh:28-48`, `clarusc/lower.cla:3440-3481` (`lowEditStmt` and its doc comment listing the four supported shapes), `clarusc/check.cla:3343-3349` (`emitConflictingExtern`).

**Interfaces:**
- Produces: `lexResyncStringLit()`; diagnostic texts (exact): `invalid escape sequence`; `<name>() expects <accepted>, got <actual>`; `redeclaration of X (also declared at L:C)` (two lines); `edit target must be a variable, list element, or map element`.
- Produces: `string(c)` for `c: char` → the one-character string (lowered as `IStrConcatChar("" , c)`).

- [ ] **Step 1: Write the five error fixtures FIRST (they fail today)**

`testdata/errors/lex_str_badescape.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// compiler-cleanup: a bad escape inside a double-quoted string is ONE
// `invalid escape sequence` diagnostic -- not `unterminated string
// literal`, and no second cascaded diagnostic scanning to EOF.
func f() {
    var s: string
    s = "a\qb"
    s = "second literal, must not become a phantom unterminated string"
}
```
`testdata/errors/int_conv_identity.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// compiler-cleanup: an identity conversion is still an error, and the
// message names what int() expects instead of "cannot convert int to int".
func f() {
    var i: int
    var j: int
    i = 1
    j = int(i)
}
```
`testdata/errors/const_dup.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// compiler-cleanup: a mismatched duplicate const cites BOTH declarations,
// the same two-diagnostic shape emitConflictingExtern uses.
const limit: int = 10
const limit: int = 20
func f(): int {
    return limit
}
```
`testdata/errors/edit_sortedmap_elem.cla` (mirror `testdata/emitui/formedit.cla`'s form window declaration for a `form for` record; copy its `record`/`window ... form for` shape verbatim, then):
```
var sm: sortedmap of NoteRec
func f() {
    edit NoteForm, sm["k"]
}
```
`testdata/errors/edit_intmap_elem.cla`: same with `var im: intmap of NoteRec` and `edit NoteForm, im[3]`.

Run from `tests/selfhost/`: for each fixture, `"$CLARUSC" emit -o /dev/null ../../testdata/errors/<f>.cla; echo rc=$?`. Record the CURRENT output in the report (lexer: two diagnostics; int: `cannot convert int to int`; const: one line; edit: `clarusc emit: unsupported construct ...` exit 3). These are the "red" observations.

- [ ] **Step 2: Lexer fix**

Add after `lexResyncCharLit`:
```
// lexResyncStringLit advances past a malformed string literal's closing
// quote on the current line -- or to end of line/EOF if there is none --
// so a bad escape ("a\qb") never leaves the rest of the literal to be
// re-lexed as tokens and its closing quote to open a phantom string that
// runs unterminated to EOF (the old cascade). Mirrors lexResyncCharLit.
func lexResyncStringLit() {
    while lexOff < lexLen and not lexIsNewline(lexSrc[lexOff]) {
        if lexSrc[lexOff] == '"' {
            lexAdvance()
            return
        }
        lexAdvance()
    }
}
```
In `lexString`'s escape branch:
```
            ok = lexDecodeEscape('"')
            if not ok {
                emitDiag(line, col, "invalid escape sequence")
                lexResyncStringLit()
                break
            }
```
Generate the `.expect` (from `tests/selfhost/`): `"$CLARUSC" emit -o /dev/null ../../testdata/errors/lex_str_badescape.cla > ../../testdata/errors/lex_str_badescape.expect 2>&1`. It must be exactly ONE line ending in `invalid escape sequence`. Commit: `fix(lex): invalid escape sequence diagnostic with string-literal resync (no cascade)`.

- [ ] **Step 3: Conversion wording + `string(char)`**

In `checkConversion`, build the accepted-list string per arm and change the failure line:
```
    ok = false
    accepted = ""
    if name == "string" {
        accepted = "an int or char"
        ok = typeKind(at) == TyInt or typeKind(at) == TyChar
    } else if target == IntT {
        accepted = "a fixed, char, enum, or ptr"
        ok = ...unchanged...
    } else if target == FixedT {
        accepted = "an int"
        ok = typeKind(at) == TyInt
    } else if target == CharT {
        accepted = "an int"
        ok = typeKind(at) == TyInt
    } else if target == PtrT {
        accepted = "an int or overlay"
        ok = ...unchanged...
    } else if typeKind(target) == TyEnum {
        accepted = "an int"
        ok = typeKind(at) == TyInt
    } else if typeKind(target) == TyOverlay {
        accepted = "a ptr"
        ok = typeKind(at) == TyPtr
    }
    if not ok {
        emitDiag(exprLine(e), exprCol(e), name + "() expects " + accepted + ", got " + typeName(at))
        return InvalidT
    }
```
(`var accepted: string`.) In `lower.cla`'s `name == "string"` arm:
```
        } else if name == "string" {
            if typeKind(exprTypeGet(callArgsHead(e))) == TyChar {
                // compiler-cleanup: string(c) is the one-character string --
                // the SAME IR `"" + c` produces (IStrConcatChar over an empty
                // literal), so no new intrinsic, runtime function, or
                // backend arm.
                emptyIR = newIRStrConst(lowInternStr(""), irStrType(255))
                argIR = lowExpr(callArgsHead(e))
                return newIRIntr(IStrConcatChar(), <two-element IR arg list of emptyIR, argIR>, ty)
            }
            return newIRIntr(IIntToStr(), lowArgs(callArgsHead(e)), ty)
```
The `<two-element IR arg list>` is built exactly the way `lowBin2Args(binLeft(e), binRight(e))` (~line 810's caller) builds its list from two already-lowered IR exprs — read `lowBin2Args` and reuse its list-append call (it is an IR expr list; the AST-index arguments are lowered inside it). If `lowBin2Args` cannot take pre-lowered IR, add a two-line `lowPair(aIR: int, bIR: int): int` beside it that does only the append, and have `lowBin2Args` call it. Regenerate `string_conv_arg.expect` (now `string() expects an int or char, got string`) and `int_conv_identity.expect`. Add to `caseIntToStr` in `cases_textbinary.cla`:
```
    var c: char
    c = 'q'
    if string('a') != "a" {
        return tkFail("IntToStr", "string('a') wrong")
    }
    if string(c) != "q" {
        return tkFail("IntToStr", "string(c) wrong")
    }
```
(before the final `return tkPass`; move the `var` to the top of the function). Run the host core CLI: `make test T=testsuite/core_cli` → `PASS IntToStr`. Reference (`docs/clarus-language-reference.md` ~211): add `var s2: string = string(c)    // char to string, "a"` after the `string(i)` line (declare `var c: char = 'a'` above it in the example block), and in the paragraph below change "`string(n)` renders an `int` in decimal" to "`string()` takes an `int` (rendered in decimal, negative values included, e.g. `string(-7)` is `\"-7\"`) or a `char` (the one-character string)". Commit: `feat(check): "X() expects ..., got ..." conversion diagnostics; string(char)`.

- [ ] **Step 4: Duplicate `const` cites both declarations**

In `checkConstDecl`'s `else` branch:
```
    } else {
        symIdx = scopeLookup(curScope, sym.nameIdx)
        if symIdx == -1 or not constSymMatches(symbols[symIdx], sym) {
            // compiler-cleanup: cite BOTH sites, emitConflictingExtern's
            // shape (Diag carries one position, so two diagnostics).
            emitDiag(declLine(firstDecl), declCol(firstDecl), "redeclaration of " + poolGet(sym.nameIdx) + " (also declared at " + numToStr(declLine(d)) + ":" + numToStr(declCol(d)) + ")")
            emitDiag(declLine(d), declCol(d), "redeclaration of " + poolGet(sym.nameIdx) + " (also declared at " + numToStr(declLine(firstDecl)) + ":" + numToStr(declCol(firstDecl)) + ")")
        }
    }
```
Generate `const_dup.expect` (two lines). Check `testdata/errors/file_info_dup.expect` is unchanged (`make test T=selfhost/diag`). Commit: `fix(check): duplicate const cites both declarations`.

- [ ] **Step 5: `edit` target shape in the checker**

In `checkEditStmt`, after the parameter check and BEFORE `tt = checkExpr(target, formRecType)`, when the target is not the `new` form:
```
    // compiler-cleanup: the SHAPE restriction lowEditStmt used to enforce
    // via a hard abort -- a variable, a list element, or a (plain) map
    // element -- is a checker diagnostic now. sortedmap/intmap elements and
    // nested fields are rejected here, at the target's own position.
    shapeOk = exprKind(target) == ExIdent
    if exprKind(target) == ExIndex {
        xk = typeKind(exprTypeGet(indexX(target)))   // requires the container checked first -- see note
        shapeOk = xk == TyList or xk == TyMap
    }
    if not shapeOk {
        emitDiag(exprLine(target), exprCol(target), "edit target must be a variable, list element, or map element")
        return
    }
```
Note: `exprTypeGet` is only valid after `checkExpr`; reorder so the container sub-expression is checked before the shape test (call `checkExpr(indexX(target), -1)` first, or run the shape test after the existing `tt = checkExpr(target, formRecType)` line and return after emitting). Keep `lowEditStmt`'s `lowUnsupported` as the defensive fallback (add `// unreachable: checkEditStmt rejects every other shape (compiler-cleanup)`). Generate both `edit_*_elem.expect` files. Run `make test T=emitui/popupguards` — `edit_bad_target.cla` must still PASS (nonzero exit + the same substring, now from the checker). Commit: `fix(check): reject unsupported edit targets in the checker, not a lowering abort`.

- [ ] **Step 6: Delete the inert diag fixtures**

For each of the five `testdata/diag/*` files: `grep -rn "$(basename f .cla)" tests/ clarusc/ | grep -v '^testdata'` must be empty, then `git rm` the `.cla` and its `.expect`. Commit: `test: drop inert testdata/diag conversion/lexer fixtures (no runner references them)`.

- [ ] **Step 7: Gates**

Run: `scripts/test-task.sh --smoke` (T1; all green except `.s`/emitui goldens Task 6 owns — none of this task's changes should move a `.s` golden; if one moves, stop and report). `make test T=selfhost/diag` green with the five new + one reblessed `.expect`.

### Task 8: Diagnostics B — transport position, `transportName`, `usesConn`, guard fixture (spec §4.3)

**Files:**
- Modify: `clarusc/parse.cla` (`parseArgsTransport` ~52-60; `parseArgs` ~613-648; the `newCall` call ~558)
- Modify: `clarusc/ast.cla` (`newCall` ~664; `callTransport` ~688; new `callTransportLine`/`callTransportCol` accessors — pick two unused `ExprNode` fields or a side table, see Step 2)
- Modify: `clarusc/check.cla` (`checkCall` ~5822-5848; `transportName` ~5799-5804; `resolveType` `TxNamed` arm ~2296-2302; `checkTopDeclPhase1` `DkVar` arm ~6098-6124)
- Create: `testdata/errors/transport_misuse_col.cla` + `.expect`; `tests/conntest/fieldonly.sh`; `tests/cg68k/unspliced_guard.sh`
- Read first: `tests/conntest/connect.sh` and `tests/lib_conntest.sh` (`conn_build`), `clarusc/drive.cla:1612-1618` (the host-lane `usesConn` splice gate), `clarusc/cg68k.cla:10026-10037,11825-11833` (the guard family), `clarusc/ir.cla:2271` (`findIRFuncIdxByName`).

**Interfaces:**
- Produces: `parseArgsTransportLine: int`, `parseArgsTransportCol: int` (parser out-globals); `callTransportLine(i): int`, `callTransportCol(i): int` (AST accessors); `newCall(fn, argsHead, transport, tLine, tCol, line, col)` — 7 params (update its one caller).
- Produces: `usesConn` set from `resolveType` (any type position).

- [ ] **Step 1: Fixture first — transport column**

`testdata/errors/transport_misuse_col.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// compiler-cleanup: the transport-misuse diagnostic points at the
// `serial` keyword itself (col 13 below), not the call's `(`.
func f(a: string, b: string) {
}
func g() {
    f(serial "modem:9600", "x")
}
```
Record the current output (column of `(`). Expected after the fix: `...:9:7: serial is only valid on connection.open with a single string argument` — count the column of `s` in `serial` on that line (1-based; adjust the comment to match).

- [ ] **Step 2: Carry the keyword position**

`parse.cla`: add `var parseArgsTransportLine: int` and `var parseArgsTransportCol: int` beside `parseArgsTransport` (extend its doc comment: "…and the keyword's own line/col, for the checker's diagnostic"). In `parseArgs`, before each `advance()` that consumes the keyword:
```
        if curIsIdentIdx(cwAppletalk) {
            parseArgsTransportLine = curLine()
            parseArgsTransportCol = curCol()
            advance()
            transport = 1
        } else if curIsIdentIdx(cwSerial) {
            parseArgsTransportLine = curLine()
            parseArgsTransportCol = curCol()
            advance()
            transport = 2
        }
```
(and set both to 0 where `parseArgsTransport = 0`). `ast.cla`: `newCall` gains `tLine: int, tCol: int` and stores them; read `ExprNode`'s fields — `intVal` already holds the transport tag; if two spare int fields exist (e.g. `c`/`d`), use them, otherwise add `tLine`/`tCol` fields to `ExprNode` (every `ExprNode` grows 8 bytes — acceptable, note it). Add:
```
func callTransportLine(i: int): int { return exprs[i].tLine }
func callTransportCol(i: int): int { return exprs[i].tCol }
```
(`tLine`/`tCol` are the names to use whether they are new fields or renamed spares; `newCall` stores `tLine`/`tCol` into them.)
`parse.cla:558`: `x = newCall(x, argsHead, parseArgsTransport, parseArgsTransportLine, parseArgsTransportCol, line, col)`. `check.cla` `checkCall`: both `emitDiag(exprLine(e), exprCol(e), transportName(transport) + ...)` → `emitDiag(callTransportLine(e), callTransportCol(e), ...)`. Generate the `.expect`. Commit: `fix(check): transport-misuse diagnostic points at the transport keyword`.

- [ ] **Step 3: `transportName` exhaustive**

```
func transportName(tag: int): string {
    if tag == 1 {
        return "appletalk"
    }
    if tag == 2 {
        return "serial"
    }
    abort("clarusc: unknown transport tag " + numToStr(tag))
    return ""
}
```
(If `abort` in check.cla is not the process-abort helper `lowUnsupported` uses, use whatever `check.cla` uses for internal invariants — grep `abort(` in check.cla.) Commit: `fix(check): transportName is exhaustive`.

- [ ] **Step 4: `usesConn` in `resolveType`**

In the `TxNamed` arm, beside the `fileHandleT` hook:
```
        if symbols[symIdx].typeIdx == fileHandleT {
            usesFileh = true
        }
        // compiler-cleanup: same rule for connection -- ANY type position
        // (local, param, field, return, list/map element) pulls conn.cla in
        // on the host lane. Was global-var-only (checkTopDeclPhase1), so a
        // field/param/local-only program failed at link time.
        if symbols[symIdx].typeIdx == connectionT {
            usesConn = true
        }
```
Delete the `DkVar`-arm setter in `checkTopDeclPhase1` (keep `checkVarDecl(d)`; remove the `symIdx = scopeLookup(...)` / `usesConn = true` lines and their comment). Confirm `lower.cla` ~7765-7775's slot assignment loop still only assigns slots to GLOBAL connection vars (it iterates `declHead` `DkVar`s — unchanged, correct: a field-only program has `usesConn` true and zero slots, which the `connCount == 0` paths must tolerate; grep `connCount` consumers and read them).

- [ ] **Step 5: Host fixture — field-only and param-only connection programs build and link**

`tests/conntest/fieldonly.sh` (model on `tests/conntest/connect.sh`'s use of `conn_build`; read that script first for the exact helper signature):
```sh
#!/bin/sh
# compiler-cleanup: a program whose ONLY connection-typed things are a
# record field and a parameter (no global) must still splice conn.cla on
# the host lane (usesConn is set from resolveType now, not only from a
# global var decl) -- it used to fail at link time.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_conntest.sh" || die "helper lib failed to load"

cat > "$WORK/fieldonly.cla" <<'CLA'
record Session {
    id: int
    link: connection
}

func describe(c: connection): string {
    return "conn"
}

on App.startCLI(args: list of string) {
    var s: Session
    s.id = 1
    alert(describe(s.link))
    quit 0
}
CLA

if conn_build fieldonly "$WORK/fieldonly.cla" "$WORK/fieldonly"; then
    t_pass fieldonly_builds
else
    t_fail fieldonly_builds "host build/link failed: $(tail -20 "$WORK/fieldonly.build.log" 2>/dev/null)"
fi
t_done
```
Adjust the `conn_build` call and log path to the helper's real contract. Run: `make test T=conntest/fieldonly`. Also confirm the native lane: `build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o "$WORK/fo.bin" "$WORK/fieldonly.cla"` exits 0. Commit: `fix(check): usesConn set from any connection type position; fieldonly conntest`.

- [ ] **Step 6: Unspliced-function guard fixture (TODO entry 13's evidence)**

`tests/cg68k/unspliced_guard.sh`:
```sh
#!/bin/sh
# compiler-cleanup (TODO "STILL LIVE unspliced-runtime-function crash"): a
# native build whose program reaches a runtime function that is NOT in the
# build must fail with a NAMED diagnostic and a nonzero exit -- never
# `runtime error: list index out of range` / exit 3. Shape: a copy of
# runtime/clarus with datetime_68k.cla removed, and a program calling now()
# (which lowers to the datetime runtime). drive.cla's missing-module check
# or cg68k's cgJsrByName/cgCallFnScalar guard must fire; either is a PASS
# as long as the function or module is NAMED in the output.
. "$(dirname "$0")/../lib.sh" || exit 2

RT=$WORK/rt
mkdir -p "$RT"
cp "$ROOT"/runtime/clarus/*.cla "$RT"/
rm -f "$RT/datetime_68k.cla"

cat > "$WORK/needs_dt.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var t: int
    t = now()
    quit 0
}
CLA

"$CLARUSC" emit68k --rtdir "$RT/" -o "$WORK/needs_dt.bin" "$WORK/needs_dt.cla" > "$WORK/out.txt" 2>&1
rc=$?
if [ $rc -eq 0 ]; then
    t_fail unspliced_guard "want nonzero exit, got 0"
elif grep -q 'list index out of range' "$WORK/out.txt"; then
    t_fail unspliced_guard "crashed instead of diagnosing: $(cat "$WORK/out.txt")"
elif grep -Eq 'datetime|rtDt|not found|not spliced' "$WORK/out.txt"; then
    t_pass unspliced_guard
else
    t_fail unspliced_guard "nonzero exit but no named diagnostic: $(cat "$WORK/out.txt")"
fi
t_done
```
Run: `make test T=cg68k/unspliced_guard`. If it FAILS with `list index out of range`, the crash IS live: find the unguarded lookup (the survey found none — the likely path is a `findIRFuncIdxByName` result used as an index without the `-1` check; `grep -n 'findIRFuncIdxByName' clarusc/cg68k.cla clarusc/shake.cla` and audit each), guard it with `abort("cg68k: <name> not found/reachable")`, and re-run until PASS. Record which outcome occurred. Commit: `test(cg68k): pin the unspliced-runtime-function guard`.

- [ ] **Step 7: Gates**

Run: `scripts/test-task.sh --smoke`. Green except Task 6's golden set; `make test T=selfhost/diag T=conntest/ T=cg68k/unspliced_guard` all PASS.

### Task 9: Driver track — provenance, `seenPaths`, prelude comment (spec §4.4)

**Files:**
- Modify: `clarusc/drive.cla` (`expand()` ~861-1100: the stamping loop ~1012-1016 and the `seenPaths` marks ~976-978; new `drvRuntimeFiles` beside `drvSpliceActive` ~765; the two prelude comments ~1506-1522 and ~1989-2077)
- Modify: `clarusc/lower.cla` (`declIsRuntimeOrigin` ~5077-5100)
- Create: `tests/selfhost/rtdir_symlink.sh`, `tests/selfhost/include_retry.sh`
- Read first: `clarusc/drive.cla:1296-1302, 1698-1702, 2068-2078` (the three `drvSpliceActive` regions), `clarusc/drive.cla:930-1000` (the `--rtbake` manifest read INSIDE `expand()` — it happens before the stamping loop, under the same `drvSpliceActive` value, so it is covered), `clarusc/lower.cla:4991-5049` (the three prior fix rounds' history — keep that comment, append round 4).

**Interfaces:**
- Produces: `var drvRuntimeFiles: intmap of bool` (keyed by the pool index `setDeclFile` stores); `declIsRuntimeOrigin(d): bool` unchanged signature, new implementation.

- [ ] **Step 1: Audit the `drvSpliceActive` precondition**

For each of the three set/clear pairs, confirm every `expand(...)` call between them is a runtime module and every `expand` outside them is user code or a `toolbox/` include. `grep -n 'expand(' clarusc/drive.cla` and classify each call in the task report. If any runtime module is read with the flag false, wrap it; if any user/toolbox file is read with it true, stop and report (the design assumes the flag is exact).

- [ ] **Step 2: Fixture first — symlinked `--rtdir` byte identity**

`tests/selfhost/rtdir_symlink.sh`:
```sh
#!/bin/sh
# compiler-cleanup: runtime-origin classification is recorded when the
# driver splices a module (drvRuntimeFiles), not derived from comparing
# path strings -- so two --rtdir spellings that coincide only via a
# symlink (which the old lexical normalizePath prefix test could not see)
# produce byte-identical output.
. "$(dirname "$0")/../lib.sh" || exit 2

ln -s "$ROOT/runtime/clarus" "$WORK/rtlink" || die "symlink"
SRC=$ROOT/testdata/cg68k/globals.cla
[ -f "$SRC" ] || die "missing fixture $SRC"

"$CLARUSC" emit --rtdir "$ROOT/runtime/clarus/" -o "$WORK/a.c" "$SRC" > "$WORK/a.log" 2>&1 || die "emit (direct) failed: $(cat "$WORK/a.log")"
"$CLARUSC" emit --rtdir "$WORK/rtlink/" -o "$WORK/b.c" "$SRC" > "$WORK/b.log" 2>&1 || die "emit (symlink) failed: $(cat "$WORK/b.log")"
if cmp -s "$WORK/a.c" "$WORK/b.c"; then
    t_pass rtdir_symlink_identity
else
    t_fail rtdir_symlink_identity "$(first_diff "$WORK/a.c" "$WORK/b.c")"
fi
t_done
```
Run it BEFORE the change and record the result (it may already pass — the residual only bites when the DECL path and `rtDir` are spelled differently within one run; that is fine: the fixture is the tripwire for the new mechanism, and the report says whether it was red or green before).

- [ ] **Step 3: Provenance by construction**

`drive.cla`, beside `var drvSpliceActive: bool`:
```
// drvRuntimeFiles (compiler-cleanup): the pool index of every source file
// read while drvSpliceActive was true -- i.e. every runtime module.
// lower.cla's declIsRuntimeOrigin consults THIS instead of comparing a
// decl's path string against rtDir (lexical normalizePath could not see
// through a symlink; there is nothing to compare now).
var drvRuntimeFiles: intmap of bool
```
In `expand()`, immediately before the stamping loop:
```
    if drvSpliceActive {
        drvRuntimeFiles[pathIdx] = true
    }
    d = head
    while d != -1 {
        setDeclFile(d, pathIdx)
```
`lower.cla`:
```
func declIsRuntimeOrigin(d: int): bool {
    var p: int

    p = getDeclFile(d)
    return p != -1 and drvRuntimeFiles.has(p)
}
```
Append to the fix-round history comment (~4991-5049): "Round 4 (compiler-cleanup, 2026-09-05): no path comparison at all — origin is recorded by drive.cla at splice time (drvRuntimeFiles). Symlinks, relative spellings, and Mac aliases are all irrelevant." Delete the now-unused `var`s (`want`, `normRtDir`, `path`) and check `normalizePath` still has other callers (`grep -n 'normalizePath(' clarusc/*.cla`; if none remain, keep it — `expand()` uses it — but confirm). If `drvRuntimeFiles` must be reset between compiles (a `checkReset`-style function exists for `seenPaths`? grep `seenPaths.clear\|seenPaths = ` in drive.cla), reset it in the same place.
Run: `make test T=selfhost/rtdir_symlink T=selfhost/diag T=cg68k/goldens T=bake/` — no golden movement expected (classification results are identical for every existing build). Commit: `fix(drive): record runtime-module provenance at splice time; declIsRuntimeOrigin stops comparing paths`.

- [ ] **Step 4: `seenPaths` marked on success only**

Move
```
    seenPaths[path] = 0
    if altPath != "" {
        seenPaths[altPath] = 0
    }
```
to AFTER the `if not ok { ... return true }` block that follows `feReadSource`, with the comment `// compiler-cleanup: marked only once the read SUCCEEDED -- a failed attempt must not make a later include of the same path dedupe against a file never loaded.` Verify the `--rtbake` early-read branch above (~940-960) does not rely on the early mark (it checks `not seenPaths.has(path)` BEFORE the mark; unchanged).

`tests/selfhost/include_retry.sh`:
```sh
#!/bin/sh
# compiler-cleanup: seenPaths is marked only after a SUCCESSFUL read. The
# observable: two includers naming the same missing path each get their own
# diagnostic (the second attempt is a real attempt, not a silent dedupe
# against a path that was never loaded). One compile cannot watch a file
# appear, so the negative half is what this pins.
. "$(dirname "$0")/../lib.sh" || exit 2

mkdir -p "$WORK/p"
cat > "$WORK/p/a.cla" <<'CLA'
include "lib/missing.cla"
CLA
cat > "$WORK/p/b.cla" <<'CLA'
include "lib/missing.cla"
CLA
cat > "$WORK/p/main.cla" <<'CLA'
include "a.cla"
include "b.cla"
on App.startCLI(args: list of string) {
    quit 0
}
CLA

"$CLARUSC" emit --rtdir "$ROOT/runtime/clarus/" -o "$WORK/out.c" "$WORK/p/main.cla" > "$WORK/out.txt" 2>&1
n=$(grep -c 'missing.cla' "$WORK/out.txt")
if [ "$n" -ge 2 ]; then
    t_pass include_retry_diags
else
    t_fail include_retry_diags "want >=2 diagnostics naming missing.cla, got $n: $(cat "$WORK/out.txt")"
fi
t_done
```
Run it before and after; record. If the driver already dedupes diagnostics per path by design (read `expand()`'s `entryFailed`/diagnostic emission for a failed non-entry read), adapt the assertion to the observable difference the task report documents — the point is one observable per-path behavior that differs between mark-before and mark-after. Commit: `fix(drive): mark seenPaths only after a successful read`.

- [ ] **Step 5: Prelude comment consolidation**

Keep `drive.cla` ~60-74 (mechanism) and `bake.cla` ~403-417 (UNTOUCHED). Of the two driver-internal retellings (~1506-1522 in `driveManifestSplice`, ~1989-2077 in `driveCompile`), keep the longer `driveCompile` one and reduce `driveManifestSplice`'s to a two-line pointer: `// prelude.cla is spliced first and detached/re-prepended -- see driveCompile's prelude splice comment (the one telling of why) and drvPreludeHead's own doc comment.` Ensure nothing in the deleted text was unique (diff the two before deleting; move any unique sentence into the surviving comment). `bake.cla` diff must be empty: `git diff --stat clarusc/bake.cla` → nothing. Commit: `docs(drive): one telling of the prelude-splice rationale`.

- [ ] **Step 6: Gates**

Run: `scripts/test-task.sh --smoke`; `make test T=selfhost/ T=bake/` green (selfhost's `snapshot_fresh` will FAIL until Task 10 regenerates the snapshot — that one failure is expected in every wave-2 task and must be the ONLY selfhost failure).

### Task 10: Wave-2 integration — snapshot, emitui goldens, docs, TODO, T2 (spec §5)

Runs after Tasks 6–9 are merged to the branch. Serial.

**Files:**
- Modify: `clarusc/clarusc.c` (regenerate), `testdata/emitui/*.c.golden` (regenerate if moved), `docs/TODO.md`, `docs/HISTORY.md`, `docs/ROADMAP.md`, `CLAUDE.md`, `STATUS.md` (if present — check `ls STATUS.md`)

- [ ] **Step 1: Regenerate the snapshot**

```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
make -j tools bootstrap
make test T=selfhost/fixedpoint
```
Expected: `PASS snapshot_fresh`, `PASS fixed_point`.

- [ ] **Step 2: emitui goldens**

Run: `make test T=emitui/goldens`. For each failing fixture confirm the diff is the `clar_conn_pump` function (Task 6 Step 7) or a diagnostic-wording change; regenerate those goldens with `clarusc emit` exactly as `goldens.sh` invokes it; re-run → green.

- [ ] **Step 3: T1 + selfhost + bake**

Run: `scripts/test-task.sh --smoke` and `make test T=selfhost/ T=bake/` — all green (including `CLARUS_BAKE_FULL=1 make test T=bake/` — the full-corpus sweep must follow the `native.cla` change).

- [ ] **Step 4: `docs/TODO.md`**

Delete every entry listed in spec §1 from the "Compiler correctness / diagnostics" section (the FIXED `--rtbake` record row stays). For the three dispositioned entries, move a one-paragraph record each into `docs/HISTORY.md`'s new phase entry: already-fixed (`cgLastTrackedOff`, with the 68k-call-result-release attribution), obsolete (escape precision, `e4b592f`), closed-with-evidence (unspliced guard, `tests/cg68k/unspliced_guard.sh`'s outcome from Task 8). If the section is now empty except the FIXED record, keep the heading and the record.

- [ ] **Step 5: `HISTORY.md`, `ROADMAP.md`, `CLAUDE.md`**

`HISTORY.md`: a "compiler-cleanup phase (2026-09-05)" entry in the existing shape: the 29 entries by disposition, the `.s` line delta from Task 6 Step 7, the two bless points, the honest note that the four stale-pointer sites have no red-to-green (spec §3.1). `ROADMAP.md` "Where we are": a paragraph in the usual bold-led shape, "COMPLETE — full T2 green, NOT YET merged". `CLAUDE.md`: toolbox count "35 `ToolboxTest` cases: 34 real + `SelfCheck`" → "36 … 35 real", with the `CasesTable` clause appended to the growth history in the same style; in the test section add the standing rule sentence: "A phase that adds a new value-typed runtime module (the `connection`/`filehandle`/datetime shape) adds its `tests/bake/<module>.sh` `emit68k_pair` twin in the same task — `--rtbake` byte-identity for that module then fails in T1, not only in the opt-in full-corpus sweep."; note the conversion-diagnostic wording (`X() expects ..., got ...`) and `string(char)` in the binary-files paragraph that mentions `string(n)`.

- [ ] **Step 6: Full T2**

Run: `scripts/test-merge.sh` (T1 body, perfgate alone, `selfhost/`, gated `mactest/` at `-j1`, `bake/` full corpus). Expected: every stage prints `PASS`. Paste each stage's `test-merge.sh: <stage> PASS in Ns` line into the report.

- [ ] **Step 7: Commit**

```sh
git add clarusc/clarusc.c testdata/emitui/ docs/ CLAUDE.md
git commit -m "chore: snapshot regen + emitui goldens + docs for the compiler-cleanup phase"
```

- [ ] **Step 8: Final whole-branch review**

Dispatch the most capable available model (per CLAUDE.md, final review may use it) with the spec, this plan, and `git log main..compiler-cleanup`; fix findings in a fix wave; re-run T2 if any `clarusc/` or `runtime/` file changed. Merge only on Andrew's request.

---

## Parallelism summary

| Wave | Parallel | Serial after |
|------|----------|--------------|
| 1 | Tasks 1, 2, 3, 4 (disjoint files; 1/2/3 need at most one emulator boot each — serialize those boots or defer to Task 5) | Task 5 (bless #1, native gate) |
| 2 | Tasks 6, 7, 8, 9 (Task 6 is itself serial internally and is the longest; 7/8 both edit `check.cla` in different functions — expect a trivial merge; 6/7/9 all edit `lower.cla` in different regions) | Task 10 (snapshot, emitui goldens, docs, T2, final review) |

Critical path: Task 6 (eight lettered items, one native boot, one bless) — roughly the length of the other three wave-2 tasks combined. Start it first.
