# Correctness-Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix every known wrong-behavior/memory bug that needs no real
input, pin div-by-zero (and INT_MIN/-1) semantics in both lanes, restore
the About box, and make the stale-master-pointer bug class
deterministically testable.

**Architecture:** Runtime fixes land in `runtime/clarus/*.cla` (shared
by both lanes); compiler fixes land in `clarusc/*.cla` (check/lower/
cg68k/cprint). A new scripted-lane "jiggle" stress mode forces Memory
Manager compaction at dispatch and allocation boundaries so
stale-master-pointer bugs stop depending on heap-layout luck.

**Tech Stack:** Clarus (self-hosted clarusc), C host runtime
(`runtime/host`), Go test harness (`internal/*`), Mini vMac native lane.

**Spec:** `docs/superpowers/specs/2026-08-17-correctness-cleanup-design.md`

## Global Constraints

- Branch: `correctness-cleanup`. One commit per task minimum. Merge only on request.
- T1 after every task: `scripts/test-task.sh` — add `--smoke` for every task touching `runtime/` or `clarusc/` (that is Tasks 1–10).
- T2 (`scripts/test-merge.sh`) at phase close (Task 12), not per task.
- `internal/selfhost` runs need `-timeout 30m` if invoked directly.
- Never edit `.cla` files containing high-bit MacRoman bytes with the Edit tool — use `LC_ALL=C sed` + byte-diff (project memory rule). The files in this plan are ASCII, but verify with `grep -P '[\x80-\xff]'` before editing any `.cla` you touch.
- Never delete `.superpowers/sdd/` workspaces.
- clarusc source changes do NOT regen the snapshot per task; snapshot regen is Task 12 (T1 does not run `internal/selfhost`, so per-task T1 stays green).
- emitui/frozen-scenario goldens: if a task shifts emitted bytes/text, rebless within that task (`CLARUS_MAC_BLESS=1` only affects the native scenario lane; emitui goldens have their own bless flag — check `internal/emitui`'s test header) and eyeball the diff before committing.
- Panic message text is exactly `division by zero` (the runtime adds the `runtime error: ` prefix).
- Model policy (SDD): implementation + review subagents `sonnet`; mechanical rebless `haiku`; escalate a stuck debugging task to `opus`. Never Fable for subagents.

---

### Task 1: About box — real display path

**Files:**
- Modify: `runtime/clarus/ui.cla:1192-1215` (`rtUiAppleSelect`)
- Test: existing golden scenarios (trace branch unchanged); manual Snow/Mini vMac acceptance by controller after review

**Interfaces:**
- Consumes: `rtUiScripted` (`runtime/clarus/uiscript.cla:59`, set at `:1315` before any dispatch — sound to read here), `rtUiTraceAbout()` (`uiscript.cla:532`), `uidHasApp()`/`uidAppName()`/`uidAppVersion()`/`uidAppAuthor()`/`uidAppAbout()` (`uidesc.cla:568-609` — each returns a Pascal-string `ptr` or `ptr(0)` when absent), `rtUiEmptyPStrGet()` (`ui.cla:1142`), `UiParamText`/`UiNoteAlert` externs (`ui.cla:331-332`).
- Produces: no new names; behavior change only.

**Background:** ALRT/DITL 129 is already emitted on both lanes for
app-declared programs (`clarusc/cg68k.cla:12386-12393` native;
`scripts/build-mac.sh:103-110` Rez). DITL 129's ParamText slots:
`^0`=name, `^1`=version, `^2`=author, `^3`=about. The OOM-alert
geometry bug from the spec was ALREADY fixed (attempt-abort Task 10;
DITL 129/130 verified in-frame in that pass) — no resource change here.

- [ ] **Step 1:** In `rtUiAppleSelect`, change the item-1 branch: scripted goes to trace, real goes to a display. Replace the current `if uidHasApp() and peekb(uidAppName()) != 0 { rtUiTraceAbout() } else { ...NoteAlert(128)... }` with:

```
if itemNum == 1 {
    if rtUiScripted {
        rtUiTraceAbout()
        return
    }
    if uidHasApp() and uidAppName() != ptr(0) and peekb(uidAppName()) != 0 {
        rtUiAboutAlert()
    } else {
        empty = rtUiEmptyPStrGet()
        UiParamText(ptr(0x910), empty, empty, empty) // LMGetCurApName == ptr(0x910) directly
        UiNoteAlert(128, ptr(0))
    }
    return
}
```

New helper in `ui.cla` next to `rtUiAppleSelect` (each `uidApp*` can be `ptr(0)` when the property is absent — substitute the empty Pascal string):

```
func rtUiAboutParam(p: ptr): ptr {
    if p == ptr(0) {
        return rtUiEmptyPStrGet()
    }
    return p
}

func rtUiAboutAlert() {
    UiParamText(rtUiAboutParam(uidAppName()), rtUiAboutParam(uidAppVersion()), rtUiAboutParam(uidAppAuthor()), rtUiAboutParam(uidAppAbout()))
    UiNoteAlert(129, ptr(0))
}
```

Note `rtUiScripted` lives in `uiscript.cla` — ui.cla already cross-references uiscript symbols at whole-program check time; if the splice order rejects it, mirror how `ui.cla` reads other uiscript state (grep `rtUiScripted` consumers).
- [ ] **Step 2:** Run T1 with smoke: `scripts/test-task.sh --smoke`. Expected: green — every scenario is scripted, so traces/snaps are unchanged. If any emitui golden shifts (runtime module bytes moved), rebless within this task and inspect the diff.
- [ ] **Step 3:** Commit: `fix(ui): About box shows the real ALRT 129 in unscripted runs`
- [ ] **Step 4 (controller, post-review):** Build `examples/mandelbrot.cla` native (`scripts/build-68k.sh`), boot in Mini vMac via LaunchAPPL WITHOUT events, click Apple menu → About via `swift scripts/click.swift`, screenshot: alert shows name/version/author/about. Also boot a no-`app`-section UI program (`testdata/valid/bounce.cla`) and confirm the generic NoteAlert(128) fallback.

---

### Task 2: Popup label-lane width fix

**Files:**
- Modify: `runtime/clarus/uiwidgets.cla:508-515` region (layout width chain), `runtime/clarus/uitable.cla:286-292` (`rtUiPopupBoxInto`)
- Test: new toolbox-suite case `NarrowPopup` in `testsuite/toolbox/` (new `cases_narrowpopup.cla`, enum+dispatch in `runner.cla`), toolbox capture count bumped in `internal/mactest/coresuite_test.go:379-415`

**Interfaces:**
- Consumes: `rtUiFieldLabelW` (`uiwidgets.cla:202`, value 70), `rtUiKindPopup`, `uidWidgetWidth(winIdx, i)`, `rtUiLabelAt(w, i)`, the labeled-field layout branch at `uiwidgets.cla:508-515` (quoted in the exploration report) as the exact pattern.
- Produces: `ToolboxTest` case name `NarrowPopup`.

**Root cause:** a labeled FIELD gets `rtUiFieldLabelW` ADDED to its
declared width at layout time (`uiwidgets.cla:508-515`), so the later
label-lane subtraction can't go negative. A labeled POPUP has no such
branch — `rtUiPopupBoxInto` subtracts the label lane from the raw
declared width, so `width:` ≤ 70px yields a zero/negative-width box.

- [ ] **Step 1:** In `uiwidgets.cla`'s layout width chain, add a `rtUiKindPopup`-with-label arm mirroring the field arm (declared `width:` = the popup box; label lane added on top; same default-width fallback using the popup's kind width).
- [ ] **Step 2:** In `rtUiPopupBoxInto`, add the defensive floor after the label shift, with a `ponytail:` comment naming it a backstop:

```
if peekw(out + 2) > peekw(out + 6) - 16 {
    pokew(out + 2, peekw(out + 6) - 16) // ponytail: floor at 16px; layout-side fix is the real guarantee
}
```
- [ ] **Step 3:** Add `NarrowPopup` toolbox case: a window declaring `popup` with `label:` and `width: 60`, case calls `rtUiPopupBoxInto` on it and asserts box right − left ≥ 16 and the control rect stays inside the window. Wire into `runner.cla` enum + dispatch; bump the expected TOTAL in `checkToolboxSuiteCapture` (31 → 32) and the suite-count doc comments it flags.
- [ ] **Step 4:** T1 `--smoke`; commit: `fix(ui): labeled popup gets the label lane added at layout time; NarrowPopup case`

---

### Task 3: Heap-jiggle stress mode

**Files:**
- Modify: `toolbox/memory.cla` (new externs), `runtime/clarus/uiscript.cla` (verb + flag + tick), `runtime/clarus/ui.cla` (`UiNewPtr` waist hook), host `rt_ext` glue (no-op stub beside the existing `UiNewPtr` host stub — locate via `grep -rn UiNewPtr runtime/host/`)
- Create: `testdata/ui/toolboxsuite_jiggle.events`
- Test: new `TestToolboxSuiteJiggleOn68k` in `internal/mactest/coresuite_test.go`

**Interfaces:**
- Consumes: dispatch loop `rtUiRunScripted` (`uiscript.cla:1314-1330` — hook between `rtUiScriptTokenize()` and `rtUiScriptDispatchLine()`), verb chain `rtUiScriptDispatchLine` (`uiscript.cla:1338-1397`, returns false at `:1394` for unknown verbs), `UiTestVerb` pattern (`uitest.cla:115-128`), `toolboxFiles`/`checkToolboxSuiteCapture`/`buildNative68kUI` (`coresuite_test.go:240/379/312-322`).
- Produces: scripted verb `jiggle on|off`; `rtUiJiggleTick()` callable from later audit verification; `UiCompactMem` extern.

- [ ] **Step 1:** Add Memory Manager externs to `toolbox/memory.cla` following the file's citation discipline (verify trap words + register contracts against `Retro68/InterfacesAndLibraries` — decode the inline glue words per the project's trap-verification rule, do NOT trust this plan's words unverified): `CompactMem` (0xA04C reg, D0=cbNeeded → D0), `PurgeMem` (0xA049), `MoveHHi` (0xA064, A0=h), `FreeMem` (0xA01C → D0), `MaxMem` (0xA11D). The runtime uses only CompactMem; the rest fill out the manager per the standing 80/20 principle.
- [ ] **Step 2:** In `uiscript.cla`: `var rtUiJiggle: bool = false`, a local extern `UiCompactMem(cbNeeded: int): int = trap 0xA04C reg` (runtime convention: runtime files declare their own externs), and:

```
var rtUiJiggleBusy: bool = false

// rtUiJiggleTick: when jiggle mode is on, force a full-heap compaction so
// every unlocked relocatable block that CAN move DOES move -- turns the
// stale-master-pointer-across-compaction class from heap-layout luck into
// a deterministic failure. Recursion guard: CompactMem itself must not
// re-enter through an allocating wrapper.
func rtUiJiggleTick() {
    if not rtUiJiggle or rtUiJiggleBusy {
        return
    }
    rtUiJiggleBusy = true
    UiCompactMem(0x7FFFFFF0)
    rtUiJiggleBusy = false
}
```

Verb branch in `rtUiScriptDispatchLine` (mirror an existing one-arg verb):
`jiggle` with arg1 `on`/`off` sets `rtUiJiggle`. Call `rtUiJiggleTick()`
in `rtUiRunScripted` right before `rtUiScriptDispatchLine()`.
- [ ] **Step 3:** Hook the allocation waist: in `ui.cla`, rename the raw extern to `UiNewPtrRaw` (same trap) and add `func UiNewPtr(n: int): ptr { rtUiJiggleTick() return UiNewPtrRaw(n) }` so within-handler allocations also move memory under jiggle. (Within-handler staleness is the historical bug shape; dispatch-boundary jiggle alone cannot catch it.) Host lane: add the `UiCompactMem` no-op stub (return 0) beside the existing host `Ui*` glue. If `UiNewPtr` is consumed by non-UI-spliced modules, keep the wrapper in the same module as the extern.
- [ ] **Step 4:** `testdata/ui/toolboxsuite_jiggle.events`:

```
jiggle on
click 86 194
quit
```
- [ ] **Step 5:** `TestToolboxSuiteJiggleOn68k`: copy `TestToolboxSuiteOn68k` (`coresuite_test.go:312-322`), swap the events file, keep `checkToolboxSuiteCapture`. Give it a doc comment saying failures here and green in the twin = a stale-master-pointer bug made deterministic, with longer timeout (CompactMem per dispatch+alloc is slow — start 15m, tune on measurement; if runtime is unacceptable, stride the tick to every Nth call, N a const, deterministic).
- [ ] **Step 6:** T1 `--smoke` (jiggle off by default — default boots byte-identical except the UiNewPtr wrapper; rebless emitui goldens if they shift). Run the new jiggle test once: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteJiggleOn68k -count=1 -timeout 30m`. Expected: it very plausibly FAILS — that is Task 4's input, not this task's failure. Record the per-case results in the ledger either way.
- [ ] **Step 7:** Commit: `test(ui): heap-jiggle stress mode -- jiggle verb, CompactMem waist hook, gated suite boot`

---

### Task 4: Stale-master-pointer audit + fixes

**Files:**
- Modify: `runtime/clarus/uitable.cla`, `ui.cla`, `uiwidgets.cla`, `uitext.cla` (as the audit finds)
- Test: `TestToolboxSuiteJiggleOn68k` green; frozen scenarios unchanged

**Interfaces:**
- Consumes: Task 3's jiggle test as oracle. Audit list (from the exploration report; function — deref line): uitable `rtUiMakeLdefStub` (:496/:556), `rtUiTableRelayout` (:667), `rtUiTableGetSelected` (:694), `rtUiTableClick` (:793), `rtUiTableSyncOne` (:844/:856 — ALREADY re-derives, use as the control/pattern); ui `rtUiHandleUpdate` (:1630/:1641), `rtUiHandleGrow` (:1947), `rtUiApplyZoom` (:2018); uiwidgets `rtUiLayout` (:439), `rtUiMakeWidgets` (:623-627), `rtUiWidgetGetStr` (:852), `rtUiWidgetGetText` (:885), `rtUiWidgetSetText` (:908); uitext `rtUiTeWidestLine` (:248/:255), `rtUiTeScrollSync` (:315), `rtUiTeClamp` (:375/:377), `rtUiTeRelayout` (:499), `rtUiTeHit` (:725/:732), `rtUiHandleScrollbarClick` (:818), `rtUiStdEditPaste` (:899).
- Produces: no new names.

- [ ] **Step 1:** For each listed function: trace every statement between the `UiHandleDeref` (or equivalent) and the last use of the derived pointer. If ANY intervening call can allocate or move memory (Toolbox call, `UiNewPtr`, list/text op, another runtime call that allocates), re-derive after it (pattern: `uitable.cla:856`'s `// re-derive: LAddRow/LDelRow can move memory`). Where the pointer is used only for reads immediately after deref with no intervening call, leave it and move on — do not churn safe code.
- [ ] **Step 2:** `rtUiTableClick` stays UNCLAMPED (deliberate tripwire, runtime-ir-bake T2 decision) — fix any staleness by re-derivation only.
- [ ] **Step 3:** Iterate against the oracle: run `TestToolboxSuiteJiggleOn68k` until green. Every failure it produces is in-scope; if the tail exceeds the task budget, STOP, record remaining failures in the ledger as blocking follow-ups, and surface to the controller (spec §4 timebox rule).
- [ ] **Step 4:** Full T1 `--smoke` + one ordinary (non-jiggle) `TestToolboxSuiteOn68k` run. Commit: `fix(ui): re-derive master pointers across moving calls (jiggle-verified)`

---

### Task 5: Div/mod by zero panics; INT_MIN/-1 pinned

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgReservePanicMsgs:1547`, `cgEmitDiv32:11923`, `cgEmitMod32:11960`), `clarusc/cprint.cla` (`fpBin:1766-1786`), host runtime header where `CLAR_MUL32` lives (grep `runtime/host` for `CLAR_MUL32`), `docs/clarus-language-reference.md` (Ch3 runtime-error list `:425-434`, Ch4 operator table `:446` notes)
- Create: `testdata/runerr/divzero.cla` + `.err` + `.behavior`, `testdata/runerr/modzero.cla` + `.err` + `.behavior`, `testdata/run/divedge.cla` + `.behavior`
- Modify: `internal/mactest/native_test.go:457-481` (`TestRunErrOn68k` files list += divzero)

**Interfaces:**
- Consumes: `cgEmitPanic(msgLitIdx)` (`cg68k.cla:4001` — inline expansion, callable from glue; pool literal resolves per-segment, same reasoning as `cgListAddrFromRegs:5909`), `irAddStrLit`/`intern` (registration pattern `cgReservePanicMsgs:1547-1549`), `rt_panic` (`runtime/host/rt.c:18`, prints `runtime error: %s`, exit 3).
- Produces: `cgDivZeroMsgIdx` (cg68k global, registered beside `cgListOobMsgIdx`); C macros `CLAR_DIV32(x,y)`/`CLAR_MOD32(x,y)`.

- [ ] **Step 1 (fixtures first):** `testdata/runerr/divzero.cla`: read a value that the optimizer cannot fold (e.g. compute divisor from `args`-independent runtime state — mirror how existing runerr fixtures defeat folding; simplest: `var d: int = 0` at top level, divide by the global), print nothing, divide. `.err` = `division by zero`; `.behavior` = `exit=3` + empty stdout + `runtime error: division by zero` stderr (copy `listindex.behavior`'s exact shape). Same for `modzero.cla` with `mod`.
- [ ] **Step 2 (native):** register `cgDivZeroMsgIdx = irAddStrLit(intern("division by zero"))` in `cgReservePanicMsgs`. In `cgEmitDiv32` AND `cgEmitMod32`, at entry (before the D2–D7 saves so the stack is clean for `cgEmitPanic`'s scratch): `TST.L D0` / `BNE ok` / `cgEmitPanic(cgDivZeroMsgIdx)` / bind `ok` — local labels, exactly the `cgListAddrFromRegs:5909-5930` shape. rtPanic never returns, so no register-restore concern on the panic arm.
- [ ] **Step 3 (bake interplay verification):** the check lives ONLY in backend-synthesized glue (never baked function bodies), so the single-panic-message hardcode in the object linker (`cgRelClsPanicMsg`/`cgObjRecordHole:13425`, `cgObjResolveLabel:13913` — both hardcode `cgListOobMsgIdx`) should not bite. PROVE it: run the `internal/bake` byte-identity tests (T1 covers them) and grep the emitted `.s` of a div-using program compiled via the bake path vs from-source for identical glue. If a baked function DOES reference the new literal, stop and surface — that is a design-boundary hit, not something to hack around.
- [ ] **Step 4 (host):** add to the `CLAR_MUL32` macro family:

```c
/* Integer division: divisor 0 is a Clarus runtime error; INT_MIN/-1
   wraps to INT_MIN (quotient) / 0 (remainder), matching the 68k
   restoring-division glue. Both are UB in bare C, hence the macros. */
#define CLAR_DIV32(x, y) clar_div32((x), (y))
#define CLAR_MOD32(x, y) clar_mod32((x), (y))
static inline int32_t clar_div32(int32_t x, int32_t y) {
    if (y == 0) rt_panic("division by zero");
    if (y == -1 && x == INT32_MIN) return INT32_MIN;
    return x / y;
}
static inline int32_t clar_mod32(int32_t x, int32_t y) {
    if (y == 0) rt_panic("division by zero");
    if (y == -1) return 0;
    return x % y;
}
```

Route `fpBin`'s `/` and `mod` arms through them (add explicit cases beside the existing `CLAR_MUL32` special-case instead of the generic fall-through). Match the surrounding macro family's actual naming/placement conventions over this sketch.
- [ ] **Step 5 (68k INT_MIN edge, verify-then-pin):** `testdata/run/divedge.cla` printing `intMin / -1`, `intMin mod -1`, and a couple of ordinary signed cases; `.behavior` golden with the expected values (INT_MIN and 0). Build native and run once under Mini vMac (one-off, like `TestRunErrOn68k` does) to CONFIRM the restoring-division glue actually yields INT_MIN/0 before blessing the golden — if it differs, match the host macros to the measured 68k behavior instead (68k is the semantics anchor), and record the measured values in the reference.
- [ ] **Step 6 (reference):** Ch3 runtime-error bullet: "Dividing an `int` by zero, or taking `mod` by zero". Ch4 `/` note appends: "division or `mod` by zero is a runtime error (Chapter 3); the quotient of the most negative `int` and −1 is the most negative `int`, and the remainder is 0". Mirror the shift-count prose precedent at `:490`.
- [ ] **Step 7:** Add `divzero.cla` to `TestRunErrOn68k`'s files list. Run T1 `--smoke` (emitui goldens WILL shift — every program with div/mod gets the guard; rebless and eyeball). Commit: `feat: division/mod by zero is a runtime error on both lanes; INT_MIN/-1 pinned`

---

### Task 6: `func f(): error` — KErr hidden-return ABI

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgRetNeedsHidden:5560`, `cgCallFnScalar:9560-9564`, `cgReturnStmt:11563-11567`, `cgEmitStoreErr:6119`, new `cgEmitReturnErr` beside `cgEmitReturnRec:6196`
- Create: `testsuite/core/cases_errret.cla` (`ErrReturn` case), `testdata/run/errret.cla` + `.behavior`
- Modify: `testsuite/core/runner.cla` (enum+dispatch), core-count literals in `internal/mactest/suite_host_test.go` + `coresuite_test.go` — and per the recorded TODO, replace the duplicated count literals with ONE shared const while touching them

**Interfaces:**
- Consumes: KErr layout (code int32 @0, message str255 @4, 260 bytes — `cg68k.cla:1826-1838`), `cgEmitStoreRec`'s ECallFn fast-path shape (`:6048-6050`), `cgEmitReturnRec`/`cgEmitReturnStr` as the mirror sources, param-side KErr handling already done (`:5041`, `:9426`).
- Produces: `CoreTest` case `ErrReturn`; `cgEmitReturnErr(x: int)`.

- [ ] **Step 1 (failing fixture first):** `testdata/run/errret.cla`:

```
func makeError(c: int, m: string): error {
    var e: error
    e.code = c
    e.message = m
    return e
}

func main() {
    var e: error
    e = makeError(7, "boom")
    print(e.code)
    print(e.message)
}
```

(Adjust to the reference's actual `error` field spelling/print idioms — check Ch on `error`.) `.behavior`: exit 0, stdout `7` / `boom`. Confirm TODAY: host lane passes, native `clarusc emit68k` fails loud with the `EVarRef non-scalar` error (Probe 6's repro) — that failure is the baseline.
- [ ] **Step 2:** `cgRetNeedsHidden` += `or irtKind(retTy) == KErr`. Add KErr arms: `cgCallFnScalar`'s discard dispatch → `cgEmitStoreErr`; `cgReturnStmt`'s hidden dispatch → new `cgEmitReturnErr` (mirror `cgEmitReturnRec`, sizes from the KErr layout). Add the `ECallFn` fast-path to `cgEmitStoreErr` mirroring `cgEmitStoreRec:6048-6050`.
- [ ] **Step 3:** `ErrReturn` core-suite case exercising the same shape in-process (returns pass/fail bool per suite convention); wire enum+dispatch; consolidate the core-count literals into one const and bump it.
- [ ] **Step 4:** Native proof: compile `errret.cla` with `emit68k` (must now succeed) and run the core suite native boot once (`TestCoreSuiteGUIOn68k`) locally if the emulator is available; otherwise rely on T2 at phase close. T1 `--smoke`; rebless emitui goldens if shifted. Commit: `fix(cg68k): error-returning functions use the hidden-pointer return ABI`

---

### Task 7: `get(k, dv)` evaluation order — native matches host

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgIntrMapGetDv:7414-7462` (and `cgIntrIntMapGetDv` + sorted variants reached from `:6076-6093`/`:10757-10774`)
- Create: `testsuite/core/cases_evalorder.cla` (`EvalOrder` case), `testdata/run/getdvorder.cla` + `.behavior`
- Modify: `testsuite/core/runner.cla`, the (now-const) core count, `docs/clarus-language-reference.md` (map `get` entry: pin left-to-right argument evaluation)

**Interfaces:**
- Consumes: current native order m(:7432), dv(:7436), k(:7453); host order m,k,dv (`cprint.cla:3250-3252`).
- Produces: `CoreTest` case `EvalOrder`.

- [ ] **Step 1 (failing fixture first):** `getdvorder.cla`: three functions with side effects (each appends its letter to a global `text` and returns the map/key/default), call `get(m(), k(), d())`-shaped expression, print the global. `.behavior` expects `mkd`. Host passes today; native (if runnable pre-fix via suite case) shows `mdk` — capture baseline in the ledger.
- [ ] **Step 2:** Reorder `cgIntrMapGetDv`: evaluate `a1e` (k) into a temp (materialize the key's ADDRESS-source value to a scratch slot, or evaluate-and-spill per surrounding conventions) BETWEEN m and dv so source order is m, k, dv; same for the intmap/sorted twins. Preserve the final push sequence the callee ABI expects — only OBSERVABLE evaluation order changes.
- [ ] **Step 3:** `EvalOrder` core case with the same three-side-effect shape asserting `mkd`. Reference: add one sentence to the `get` method entry: "arguments are evaluated left to right".
- [ ] **Step 4:** T1 `--smoke`; rebless emitui goldens if shifted. Commit: `fix(cg68k): get(k, dv) evaluates arguments left to right, matching host`

---

### Task 8: Memory-bug pair — bare-EIntr arg release + conn fd overwrite

**Files:**
- Modify: `clarusc/cprint.cla:1416-1428` (`fpCallFnArg`), `clarusc/cg68k.cla:9470-9481` (`cgPushArgs` scalar-slot arm), `runtime/host/rt_serial.inc` (`rt_ext_ConnHOpen`)
- Create: `testdata/run/popargleak.cla` + `.behavior`
- Test: host leak measurement (reuse the memory-leak-fix phase's seam — grep `internal/` for the growth/leak harness that phase added; `runtime/host/rt_serial_test.c` for the conn side)

**Interfaces:**
- Consumes: `lowIntrIsOwningContainerRead` (`lower.cla:1032-1045` — its doc comment names this exact gap), `fpNeedsRelease`/`fpNewTrackedTmp` (host), `cgPendingArgReleases` + the KRec sub-branch pattern (`cg68k.cla:9459-9465`) (native).
- Produces: no new names.

- [ ] **Step 1 (failing leak test first):** `popargleak.cla`: a loop that builds a `list of text`, then repeatedly calls a function `f(t: text)` as `f(l.pop())` — each popped `text` is the owning reference; today neither lane releases it. Assert observable behavior in `.behavior` (values correct); the LEAK assertion runs via the host leak seam (whatever the memory-leak-fix phase measures — live-block count or growth across iterations). Verify the test FAILS (leak detected) before the fix.
- [ ] **Step 2 (host):** in `fpCallFnArg` BEFORE the `k != KStr and k != KRec` early-return: if the arg is `EIntr` + `lowIntrIsOwningContainerRead` + `fpNeedsRelease(type)`, route through `fpNewTrackedTmp` so end-of-statement release fires.
- [ ] **Step 3 (native):** in `cgPushArgs`' final scalar-slot else arm, add the same `ak == EIntr and lowIntrIsOwningContainerRead(...)` case as `:9459-9465`, scheduling the release for handle kinds (KText/KList/KMap/KSortedMap/KIntMap).
- [ ] **Step 4:** `rt_ext_ConnHOpen`: before overwriting an open slot's fd, `close()` it; comment that the caller gate makes this currently-unreachable (belt for a loosened invariant). Run the host serial tests (`runtime/host/rt_serial_test.c` harness — see its header for how it runs under T1).
- [ ] **Step 5:** T1 `--smoke`; leak test green; rebless if shifted. Commit: `fix: release popped/shifted container elements passed directly as call args; close fd before conn slot reuse`

---

### Task 9: Checker guards — widget-property out-arg, toBytes, irXRecFieldSize

**Files:**
- Modify: `clarusc/check.cla` (`checkRejectParamFill:3970-3982`, file-method dispatch `:1857-1878`, toBytes guard `:1884-1897`), `clarusc/ir.cla` (`irXRecFieldSize:2445-2467`)
- Create: three diagnostic fixtures (follow the existing checker-diagnostic fixture convention — find it by grepping testdata/ for an existing diagnostic string, e.g. the `lowTypeAt` message `is not declared before this use`)

**Interfaces:**
- Consumes: `isWidgetPropSelect` shape (`lower.cla:3913-3921` — replicate in check.cla; no dedicated expr kind exists, it is `ExSelect` over a `TyWidget` base), `lowTypeAt`'s guard pattern (`lower.cla:378-400`), `emitDiag`.
- Produces: check.cla helper `checkIsWidgetPropSelect(e: int): bool`.

- [ ] **Step 1 (fixtures first, each verified failing/mis-diagnosing today):** (a) `file.readText(p, d.Body.text)` inside a window handler — today compiles silently; (b) a `toBytes` mis-fire probe is NOT constructible today (no non-string type has toBytes) so instead pin the CORRECT rejection still fires for the string case — regression fixture only; (c) nested-xrec forward reference: outer `extern record` whose field's element record is declared later in the file — today panics the compiler; expect a diagnostic naming declare-before-use.
- [ ] **Step 2:** check.cla: add `checkIsWidgetPropSelect` (ExSelect + TyWidget base); extend `checkRejectParamFill` to reject a widget-property root with a message like `cannot fill a widget property in place; read into a text variable first`; wire `checkRejectParamFill` onto `file.readText`/`file.readResource`'s out-args in the dispatch at `:1857-1878` (same shape as `file.load`'s at `:1874-1876`).
- [ ] **Step 3:** toBytes guard: move inside/behind a `typeKind(xt) == TyStr or typeKind(xt) == TyText` condition so it keys on receiver kind, not name alone.
- [ ] **Step 4:** `irXRecFieldSize`: guard `irFindRecordLayoutByName` == −1 with the `lowTypeAt` pattern (diagnose + safe fallback size 0) — thread line/col from the nearest field-slot context the same way neighboring ir.cla diagnostics do.
- [ ] **Step 5:** T1 `--smoke`. Commit: `fix(check): widget-property out-args rejected; toBytes guard keyed on receiver; xrec forward-ref diagnosed`

---

### Task 10: PBM icon parser accepts CR/CRLF

**Files:**
- Modify: the P1 parser used by `app68BuildIcnFamily` (locate in `clarusc/res68k.cla` — grep `P1`)
- Create: Go test beside the existing resource-parity tests that needs NO emulator: compile (emit68k on host) the same app once with an LF PBM and once with a byte-identical-except-CR PBM, assert identical `ICN#` resource bytes (reuse `internal/mactest`'s resparity helpers if they run un-gated; otherwise put it in the package that owns `res68k` coverage — find via `grep -rln app68BuildIcnFamily internal/`)

**Interfaces:**
- Consumes: lexer CR-byte fix as the precedent (treat a lone CR and CRLF as the line terminator, byte-level).
- Produces: none.

- [ ] **Step 1:** Write the failing test with a CR-ending PBM fixture (bytes built in the test, not a committed file, to dodge editor line-ending mangling). Expected today: warn-and-continue fallback (no icon) → resource sets differ.
- [ ] **Step 2:** Fix the parser: token/line scanning treats `\r`, `\r\n`, `\n` uniformly. Keep the warn-and-continue fallback for genuinely malformed files.
- [ ] **Step 3:** T1 `--smoke`; commit: `fix(res68k): PBM icon parser accepts CR/CRLF line endings`

---

### Task 11: Appendix C erratum — Remove.click selection guard

**Files:**
- Modify: `docs/clarus-language-reference.md` (Appendix C Bookmark Manager, `Remove.click`), `examples/bookmarks.cla` (ships the appendix verbatim — keep them identical)

**Interfaces:** none.

- [ ] **Step 1:** Add the guard at the top of `Remove.click` in both files (match the appendix's own style for early return):

```
if Marks.selected == -1 {
    return
}
```
- [ ] **Step 2:** Verify the `bookmarks` frozen scenario still passes without rebless (its script selects before removing — if the trace shifts anyway, inspect why before blessing). Plain T1 (no `--smoke`: touches only docs + the example); commit: `docs+examples: Remove.click guards empty selection (Appendix C erratum)`

---

### Task 12: Phase close — snapshot, T2, docs

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `STATUS.md`, `docs/ROADMAP.md`, `docs/TODO.md` (prune every item this phase fixed; move the jiggle limitation notes in), `docs/HISTORY.md` untouched (merge-time)

- [ ] **Step 1:** Regenerate the bootstrap snapshot per `TestSnapshotFixedPoint`'s printed instructions; commit separately: `chore: regenerate clarusc.c bootstrap snapshot`
- [ ] **Step 2:** Full T2: `scripts/test-merge.sh` (includes selfhost + native lane + the new jiggle boot). All green, twice if any flake is suspected.
- [ ] **Step 3:** Prune `docs/TODO.md` of: popup clamp, KErr return gap, widget-property gap, get(k,dv) order, toBytes guard, irXRecFieldSize, PBM endings, EIntr release gap, ConnHOpen fd, Appendix C erratum. Add any new debt recorded during the phase (jiggle stride, waist-coverage limits, audit leftovers). Update `STATUS.md` §0 as the handoff; ROADMAP "Where we are".
- [ ] **Step 4:** Commit docs; report phase complete with per-task commit list. Merge only on request.
