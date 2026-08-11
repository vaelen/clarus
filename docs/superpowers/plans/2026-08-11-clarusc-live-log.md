# ClarusC.APPL Live Log + Progress Bar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Progress lines and a determinate segment-progress bar visibly appear in ClarusC.APPL's Log window while a compile is still running.

**Architecture:** Three layers, per the approved spec (`docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md`): (1) the UI runtime's programmatic set paths (textview text, label text) gain a synchronous draw so pixels land mid-handler; (2) macgui.cla shows a rolling ~18-line ticker during the compile and restores the full accumulated log at compile end; (3) a new counted front-end seam `feProgressStep(cur, total)` feeds an ASCII bar in a new bottom-anchored Status label from cg68k's per-segment loop.

**Tech Stack:** Clarus (`.cla`) only — no Go, no C changes. Gates: `scripts/test-task.sh --smoke` per task (runtime/ and clarusc/ are touched), plus targeted emulator boots where a task says so.

## Global Constraints

- The C `emit` lane, check-only mode, and `appinfo` mode must stay **byte-silent** (existing `want68k` gate in drive.cla — every new seam call must sit behind it or behind `feProgress`-equivalent front-end no-ops).
- `clarusc/clarusc.c` is the committed bootstrap snapshot; any change to `clarusc/*.cla` files in main.cla's include set (drive.cla, cg68k.cla, main.cla itself) requires regenerating the snapshot until `internal/selfhost -run TestSnapshotFixedPoint` passes.
- `.cla` files may contain MacRoman bytes; NEVER use the Edit tool on a region containing them — but all edits in this plan are pure-ASCII additions, and every string literal added must stay pure ASCII (`#`, `-`, digits — no high bytes).
- Piecewise string building in native-lane code: build strings in small single-concatenation steps (`bar = bar + "#"`), never one long chained expression (kit.cla's documented per-statement temp-slot budget).
- Comment density/style: match the surrounding files (heavily documented; new functions get a doc comment naming the phase: "live-log phase").
- Do not `cd` out of the worktree; run everything from the repo root of this worktree.

---

### Task 1: Runtime synchronous paint + hardware-proof toolbox case

**Files:**
- Modify: `runtime/clarus/uiwidgets.cla` (extern block near line 71; `rtUiWidgetSetStr` label branch near line 811; `rtUiWidgetSetText` near line 896)
- Modify: `testsuite/toolbox/cases_textwidgets.cla` (new case function at end)
- Modify: `testsuite/toolbox/runner.cla` (enum member, `tbCaseName` arm, dispatch arm, `tbAllCases`, `nTbCases` comment — follow the existing per-case pattern exactly; grep any existing case name like `BigText` to find every touch point)
- Regenerate: `testdata/emitui/*.c.golden` (every UI fixture's emitted C embeds the spliced runtime, so uiwidgets.cla edits churn them all)

**Interfaces:**
- Produces: `UiValidRect(goodRect: ptr)` extern (trap 0xA92A) in uiwidgets.cla; sync-paint behavior that Task 3's ticker/label rely on. No new cross-file function surface.

- [ ] **Step 1: Verify the ValidRect trap word against the Universal Interfaces**

Run: `grep -rn "ValidRect" Retro68/InterfacesAndLibraries/ --include="*.h" | grep -i "A92A\|ONEWORDINLINE" | head -5`
Expected: `ValidRect` with `ONEWORDINLINE(0xA92A)`. If the word differs, use the header's word and note it in the commit message. (Per the project's trap-verification rule: the inline glue word is the authority.)

- [ ] **Step 2: Write the failing toolbox case (TDD — this is the test)**

Append to `testsuite/toolbox/cases_textwidgets.cla` (adjust the two checksum regions using the geometry constants and derivations already in this file and harness.cla — the constraints are: `x` and `w` multiples of 8, `h * w/8 <= 8192`, region inside the target widget's on-screen rect):

```
// tbCaseLivePaint (live-log phase): programmatic textview/label sets
// must paint SYNCHRONOUSLY, mid-handler, before any update event can
// run -- the mechanism ClarusC.APPL's live compile log depends on
// (rtUiWidgetSetText / rtUiWidgetSetStr's label branch draw + ValidRect
// immediately). Proven the same before/after UiTestChecksum-inequality
// way the retired ButtonsPanel Status proxy worked: this case runs
// entirely inside one handler dispatch, so WITHOUT the sync draw the
// framebuffer cannot change between the two checksums.
func tbCaseLivePaint(): bool {
    var w: TextWin
    var t: text
    var before: int
    var after: int
    var beforeL: int
    var afterL: int
    var p: ButtonsPanel

    w = open TextWin
    // Region inside Body's TE view rect; x/w multiples of 8.
    before = UiTestChecksum(184, 80, 64, 32)
    t = "LIVE PAINT PROBE LINE ONE"
    w.Body.text = t
    after = UiTestChecksum(184, 80, 64, 32)
    close w
    if before == after {
        return false
    }

    p = open ButtonsPanel
    // Region inside Status's label rect (bottom lane of the 300x160
    // window at content top-left (106,44) -- same derivation as
    // harness.cla's own geometry comment); x/w multiples of 8.
    beforeL = UiTestChecksum(112, 176, 80, 16)
    p.Status.text = "LivePaintProbe"
    afterL = UiTestChecksum(112, 176, 80, 16)
    close p
    return beforeL != afterL
}
```

Wire `LivePaint` into `testsuite/toolbox/runner.cla` following the existing pattern for every touch point (enum member in `ToolboxTest`, `tbCaseName` arm returning `"LivePaint"`, dispatch arm calling `tbCaseLivePaint()`, `tbAllCases` entry, and the `nTbCases`/SelfCheck count comments — the count goes up by one).

- [ ] **Step 3: Run the suite boot to verify the case FAILS**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -timeout 20m -v 2>&1 | tail -30`
Expected: the `LivePaint` subtest FAILS (checksums equal — no paint without an update event); every other subtest PASSES. If `LivePaint` unexpectedly PASSES, STOP — the checksum regions are outside the widgets (fix coordinates) or something already paints; investigate before touching the runtime.

- [ ] **Step 4: Implement the sync paint in uiwidgets.cla**

Add to the extern block (near line 71, next to `UiInvalRect`):

```
external func UiValidRect(goodRect: ptr) = trap 0xA92A
```

In `rtUiWidgetSetText` (line ~896), after the existing `rtUiTeMutated(instV, wIdx, false)` call and before `UiSetPort(savedPort)`:

```
    // Live paint (live-log phase): draw the fresh content NOW. The
    // update event UiInvalRect just queued cannot arrive while a user
    // handler is still running (ClarusC.APPL compiles synchronously
    // inside one), so TEUpdate here -- after rtUiTeMutated's own
    // clamp/scroll-sync settles the final state -- then ValidRect to
    // cancel the now-redundant queued repaint. A hidden or covered
    // window clips to the port's visRgn, making this a safe no-op.
    UiTEUpdate(UiHandleDeref(te) + rtUiTeViewRect, te)
    UiValidRect(UiHandleDeref(te) + rtUiTeViewRect)
```

In `rtUiWidgetSetStr`'s label branch (line ~811), after the existing `UiInvalRect(rtUiRectAt(w, wIdx))`:

```
        // Live paint (live-log phase): same sync draw as
        // rtUiWidgetSetText's, in the update path's own TextBox form
        // (TETextBox erases the rect first, so shorter text leaves no
        // residue). Draw the STORED pstring, not `s` -- identical
        // bytes, but it is what the update path itself would draw.
        UiTextBox(rtUiLabelAt(w, wIdx) + 1, peekb(rtUiLabelAt(w, wIdx)), rtUiRectAt(w, wIdx), 0)
        UiValidRect(rtUiRectAt(w, wIdx))
```

(`UiTEUpdate` and `UiTextBox` are declared in sibling runtime modules — uitext.cla / ui.cla — and are visible here the same cross-module way `UiTESetText` already is. If `UiTextBox` turns out to be declared with a different name, use the update path's own draw call in ui.cla:1644 as the authority.)

- [ ] **Step 5: Re-run the suite boot to verify it PASSES**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -timeout 20m -v 2>&1 | tail -30`
Expected: ALL subtests pass, including `LivePaint`. If a DIFFERENT case regressed, the sync paint changed pixels some existing checksum assertion depends on — read that case and fix the interaction (do not weaken the case).

- [ ] **Step 6: Regenerate the emitui C goldens**

```bash
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
for g in testdata/emitui/*.c.golden; do
  build-run/clarusc emit -o "$g" "${g%.c.golden}.cla"
done
git diff --stat testdata/emitui/
```

Expected: UI fixtures' goldens change (the spliced uiwidgets.cla code changed); `git diff` on one golden shows ONLY the new UiValidRect/TEUpdate/TextBox code, nothing unrelated. Non-UI fixtures (`app_nonui`) should be unchanged.

- [ ] **Step 7: Run T1**

Run: `scripts/test-task.sh --smoke`
Expected: PASS (includes `internal/emitui` against the fresh goldens and the two emulator smoke tests).

- [ ] **Step 8: Commit**

```bash
git add runtime/clarus/uiwidgets.cla testsuite/toolbox/cases_textwidgets.cla testsuite/toolbox/runner.cla testdata/emitui/
git commit -m "feat: sync paint on programmatic textview/label sets; LivePaint toolbox case (live-log phase)"
```

---

### Task 2: Counted progress seam (feProgressStep) + snapshot regen

**Files:**
- Modify: `clarusc/drive.cla` (new `driveProgressStep` next to `driveProgress`, line ~661)
- Modify: `clarusc/main.cla` (no-op `feProgressStep` next to `feProgress`, line ~65)
- Modify: `clarusc/cg68k.cla` (one call in the per-segment loop, line ~12251)
- Regenerate: `clarusc/clarusc.c` (main.cla/drive.cla/cg68k.cla are all in the snapshot composition)

**Interfaces:**
- Consumes: nothing from Task 1.
- Produces: front-end seam contract `feProgressStep(cur: int, total: int)` — EVERY front end that includes drive.cla must define it (today: main.cla, macgui.cla; macgui's real implementation is Task 3, and until Task 3 lands macgui.cla does not compile — Task 3 must land before any ClarusC.APPL build). `driveProgressStep(cur: int, total: int)` in drive.cla for pipeline callers.

- [ ] **Step 1: Add the seam**

In `clarusc/drive.cla`, immediately after `driveProgress` (line ~661):

```
// driveProgressStep (live-log phase): the counted-progress front-end
// seam -- "cur of total" for a counted loop, today cg68k's per-segment
// emission. Same want68k gate as driveProgress: the C emit lane and
// check-only/appinfo modes stay byte-silent. Front ends: main.cla
// no-op (its per-segment feProgress lines already cover it);
// macgui.cla renders the Log window's Status-label bar.
func driveProgressStep(cur: int, total: int) {
    if not want68k {
        return
    }
    feProgressStep(cur, total)
}
```

In `clarusc/main.cla`, immediately after `feProgress` (line ~67):

```
// feProgressStep (live-log phase): counted-progress seam -- a no-op on
// the host CLI; the per-segment driveProgressPhase lines land on
// stderr via feProgress already.
func feProgressStep(cur: int, total: int) {
}
```

In `clarusc/cg68k.cla`, in the segment loop (line ~12251), directly before the existing `progressLine = "Emitted segment " + numToStr(s)`:

```
        driveProgressStep(s, cgSegCount)
```

- [ ] **Step 2: Verify host behavior is unchanged**

```bash
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c   # OLD snapshot still
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/before.c testdata/emitui/every.cla
```

Then build the NEW compiler from source via the old snapshot compiler and byte-compare a host emit:

```bash
build-run/clarusc emit -o /tmp/newclarusc.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/newclarusc /tmp/newclarusc.c runtime/host/rt.c
/tmp/newclarusc emit --rtdir runtime/clarus/ -o /tmp/after.c testdata/emitui/every.cla
cmp /tmp/before.c /tmp/after.c
/tmp/newclarusc testdata/emitui/every.cla && echo CHECK-SILENT-OK
```

Expected: `cmp` silent (emit output byte-identical — the seam is dead code on the emit lane), check-only prints nothing but `CHECK-SILENT-OK`. Also confirm stderr of an `emit68k` run still shows the per-segment lines exactly as before:

```bash
/tmp/newclarusc emit68k --rtdir runtime/clarus/ -o /tmp/tick.bin testdata/cg68k/tickprobe.cla 2>&1 | grep -c "Emitted segment"
```

Expected: same count as with `build-run/clarusc` (the no-op seam adds no lines).

- [ ] **Step 3: Regenerate the snapshot to the fixed point**

Run: `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m`
Expected: FAIL, printing the Go-free regeneration instructions. Follow them verbatim (bootstrap from the committed snapshot, emit main.cla, iterate to the fixed point, replace `clarusc/clarusc.c`). Then re-run the same test.
Expected: PASS.

- [ ] **Step 4: Run T1**

Run: `scripts/test-task.sh --smoke`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add clarusc/drive.cla clarusc/main.cla clarusc/cg68k.cla clarusc/clarusc.c
git commit -m "feat: feProgressStep counted-progress seam from cg68k's segment loop (live-log phase)"
```

---

### Task 3: macgui rolling ticker, Status label, progress bar, gcCompile rework

**Files:**
- Modify: `clarusc/macgui.cla` (ticker state + `feProgress` + new `feProgressStep` + `window Log` label + `gcFlushProgress` + `gcCompile`)

**Interfaces:**
- Consumes: Task 1's sync paint (`w.Output.text =` and `Status.text =` now draw mid-handler); Task 2's seam contract (`feProgressStep(cur: int, total: int)` MUST be defined here or ClarusC.APPL no longer compiles).
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Declaration-order check (read before writing)**

macgui.cla's header documents the rule: a top-level func whose PARAMETER TYPES name `Log` must appear after `window Log`; a func BODY referencing `Log.front` resolves in phase 2 and may appear anywhere. Keep the new ticker helpers parameter-free (use `Log.front` in the body) so they can sit next to `feProgress`, before the window declaration, where the existing buffer code lives.

- [ ] **Step 2: Implement the macgui changes**

Replace the `gcProgressBuf`/`feProgress` block (lines ~123-133) with:

```
// gcProgressBuf accumulates drive.cla's compile-progress lines during
// the synchronous compile; gcFlushProgress restores base-log +
// accumulated lines at gcCompile's exit points. The LIVE view during
// the compile is gcTickerRing below -- the last gcTickerLines lines,
// repainted into the Log textview on every feProgress call (the
// runtime's sync-paint path, live-log phase, makes the assignment
// visible mid-handler).
var gcProgressBuf: text

// Rolling ticker state (live-log phase). gcLiveActive gates both the
// ticker and the Status bar: false outside gcCompile, so a stray
// feProgress can never repaint the restored log.
const gcTickerLines: int = 18
const gcBarWidth: int = 10

var gcTickerRing: list of string
var gcBaseLog: text
var gcLiveActive: bool

// gcTickerAdd: push line into the ring (ponytail: O(N) shift, N=18 --
// a real ring index isn't worth it at this size) and repaint the Log
// textview with the ring's contents, oldest first.
func gcTickerAdd(line: string) {
    var w: Log
    var t: text
    var i: int

    if not gcLiveActive {
        return
    }
    if gcTickerRing.count < gcTickerLines {
        gcTickerRing.add(line)
    } else {
        i = 0
        while i < gcTickerLines - 1 {
            gcTickerRing[i] = gcTickerRing[i + 1]
            i = i + 1
        }
        gcTickerRing[gcTickerLines - 1] = line
    }
    w = Log.front
    if w == nil {
        return
    }
    i = 0
    while i < gcTickerRing.count {
        t.append(gcTickerRing[i])
        t.append("\n")
        i = i + 1
    }
    w.Output.text = t
}

func feProgress(line: string) {
    gcProgressBuf.append(line)
    gcProgressBuf.append("\n")
    gcTickerAdd(line)
}

// feProgressStep (live-log phase): drive.cla's counted-progress seam.
// Renders an ASCII bar -- [######----] 12/32 -- into the Log window's
// Status label; the runtime's sync-paint label path makes it visible
// mid-handler. Pure ASCII by constraint (no MacRoman bytes).
func feProgressStep(cur: int, total: int) {
    var w: Log
    var bar: string
    var filled: int
    var i: int

    if not gcLiveActive {
        return
    }
    w = Log.front
    if w == nil {
        return
    }
    filled = 0
    if total > 0 {
        filled = (cur * gcBarWidth) / total
    }
    bar = "["
    i = 0
    while i < gcBarWidth {
        if i < filled {
            bar = bar + "#"
        } else {
            bar = bar + "-"
        }
        i = i + 1
    }
    bar = bar + "] "
    bar = bar + numToStr(cur)
    bar = bar + "/"
    bar = bar + numToStr(total)
    w.Status.text = bar
}
```

In `window Log`, add the label after the textview:

```
window Log {
    title: "ClarusC"
    size: 480, 300
    resizable: min(320, 160)

    textview Output { fill: both; scrollbar: both }
    label Status { at: next, bottom; text: "" }
}
```

Replace `gcFlushProgress` (lines ~160-172) with (unconditional restore — the ticker overwrote the on-screen text, so the empty-buffer early-return is gone):

```
// gcFlushProgress: end the live-ticker view and restore the full log --
// the base text captured at compile start plus every accumulated
// progress line. Called at every gcCompile exit point; after it, gcLog
// appends diags/results exactly as before the live-log phase.
func gcFlushProgress(w: Log) {
    var buf: text

    gcLiveActive = false
    w.Status.text = ""
    buf = gcBaseLog
    buf.append(gcProgressBuf)
    w.Output.text = buf
    gcProgressBuf = ""
    gcBaseLog = ""
}
```

In `gcCompile`: after the existing `gcProgressBuf = ""` reset (line ~221), start the live view:

```
    gcProgressBuf = ""
    gcBaseLog = w.Output.text
    gcTickerRing.clear()
    gcLiveActive = true
```

Then restructure the flush points so the ticker stays live through codegen (the single behavior change to this function): DELETE the unconditional `gcFlushProgress(w)` at line ~238 (between the entryFailed check and the diag loop), and move the diag loop inside the failure branch — on a clean compile diags is empty (the loop's own comment), so this is behavior-preserving:

```
    if entryFailed {
        gcFlushProgress(w)
        gcLog(w, "cannot open entry file: " + p)
        alert("cannot open entry file: " + p)
        return
    }

    if not ok {
        gcFlushProgress(w)
        i = 0
        while i < diags.count {
            gcLog(w, formatDiag(poolGet(diagPaths[i]), diags[i]))
            i = i + 1
        }
        alert(formatDiag(poolGet(diagPaths[0]), diags[0]))
        return
    }
```

The `built`/`wrote` failure paths and the success path keep their existing `gcFlushProgress(w)` calls exactly where they are (each already flushes before logging; the success path flushes after `driveProgressDone()`).

- [ ] **Step 3: Check the compile**

Run: `build-run/clarusc clarusc/macgui.cla` (check-only; from the repo root so includes resolve)
Expected: exit 0, no output. (This catches declaration-order and type errors cheaply before the full app build.)

- [ ] **Step 4: Build ClarusC.APPL and boot it on the emulator with a scripted compile**

Locate the existing events script the macresident test bakes (grep for `clarusc.events` under `internal/mactest/`), then:

```bash
scripts/build-clarusc-mac.sh --events <path-to-clarusc.events>
```

Stage the fixtures the script's answer-open lines name (read the script; the macresident test stages `tickprobe.cla`/`catprobe.cla` at the volume root — mirror its staging), then boot in the background:

```bash
toolchain/bin/LaunchAPPL -e minivmac build-68k/ClarusC/ClarusC.bin &
```

While the compile runs, screenshot the emulator window every ~3s (geometry via the osascript recipe in CLAUDE.md; `screencapture -x -R...`). READ the screenshots.
Expected evidence, in at least one mid-compile shot: multiple timestamped progress lines visible in the Log window AND a `[##...]` bar in the bottom Status label. After the boot exits 0: a final shot shows the full restored log (Included/phase lines + BUILT), empty Status label.
If the label overlaps the textview (both painted over each other): the layout fallback is to give Output an explicit size instead of `fill: both`, reserving a bottom lane — copy the geometry approach of any existing window that mixes fill and bottom-anchored widgets (harness.cla's ButtonsPanel is the label-at-bottom precedent). Apply, rebuild, re-verify.

- [ ] **Step 5: Run T1**

Run: `scripts/test-task.sh --smoke`
Expected: PASS. (macgui.cla is not in the snapshot composition and not in any golden fixture — no regen expected this task. The macresident Snow test only asserts FIRE/ASKOPEN pairs and alert-absence in the trace; the new per-segment `SET` trace lines don't touch either assertion.)

- [ ] **Step 6: Commit**

```bash
git add clarusc/macgui.cla
git commit -m "feat: live rolling-tail compile log + segment progress bar in ClarusC.APPL (live-log phase)"
```

---

### Task 4: Frozen-scenario golden verification + docs

**Files:**
- Possibly regenerate: `testdata/uisnaps/*` (only if the native lane shows churn)
- Modify: `docs/ROADMAP.md` (phase entry), `docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md` (status line → implemented), `STATUS.md` (next-steps item 3 → done)

**Interfaces:**
- Consumes: everything prior.
- Produces: phase record.

- [ ] **Step 1: Boot the four frozen golden scenarios on the native lane**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounceOn68k|TestRealEventLoopTickOn68k|TestSmokeBounceUIScenarioNative|TestSmokeMandelUIScenarioNative|TestTexteditorUIScenarioNative|TestBookmarksUIScenarioNative' -count=1 -timeout 40m -v 2>&1 | tail -40`

(First grep `internal/mactest/native_test.go` for the actual native-lane scenario test names and use those — the names above are the expected shape, not verified.)

Expected: PASS, or PBM/trace golden mismatches from the sync paint (a snap that used to capture stale pixels now sees fresh ones).

- [ ] **Step 2: If (and only if) goldens churned, re-bless and eyeball**

Run: `CLARUS_MAC_BLESS=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -run '<same names>' -count=1 -timeout 40m`
Then READ each changed `testdata/uisnaps/*.pbm` (they are viewable images) and confirm the delta is content appearing EARLIER (text present where it was blank), never content wrong or missing. Re-run without BLESS: PASS. Commit the goldens with a message stating exactly which snaps changed and why.

- [ ] **Step 3: Docs**

- `docs/ROADMAP.md`: add the live-log phase entry (pattern: recent phase entries; include the spec path, the three components, the LivePaint case addition, the toolbox-suite count change, and the golden churn outcome from Step 2).
- Spec: flip the Status line to `implemented YYYY-MM-DD (this branch)`.
- `STATUS.md`: mark recommended-next-step 3 done, pointing at the ROADMAP entry.

- [ ] **Step 4: Run T1 one last time and commit**

Run: `scripts/test-task.sh --smoke`
Expected: PASS.

```bash
git add docs/ROADMAP.md docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md STATUS.md testdata/uisnaps/
git commit -m "docs: live-log phase record (ROADMAP entry, spec status, STATUS)"
```
