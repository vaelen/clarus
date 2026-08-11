# ClarusC.APPL live Log-window updates + compile progress bar

Status: **implemented 2026-08-11 (this branch).** Originally a deferred
requirement split out of `2026-08-10-datetime-instrumentation-design.md`
§7; scheduled now that the layer1-compiler-perf phase has made on-Mac
compiles fast enough to be worth instrumenting live (host-measured ~4.9x
on the frozen macgui fixture).

## Requirement

During a compile in `ClarusC.APPL`, progress must **visibly appear in
the Log window while the compile is still running** — the user must be
able to tell a working compile from a hang. This is the Mac half of the
"is it even running?" fix; the host half (stderr logging) shipped with
the datetime-instrumentation phase. Amended at design time (2026-08-11):
also show a cheap determinate progress indicator for the codegen stretch
(where most wall-clock lives), via a text bar in a label — NOT a new
progress-bar widget kind.

## Context

- drive.cla emits timestamped progress lines through the front-end seam
  `feProgress(line: string)`; the two implementers are `main.cla`
  (stderr) and `macgui.cla` (buffered into `gcProgressBuf`, flushed to
  the Log textview at `gcCompile`'s exit points).
- The compile runs synchronously inside an event handler (`gcCompile`),
  so textview appends only paint when events next process — after the
  compile finishes. `rtUiWidgetSetText` (runtime/clarus/uiwidgets.cla)
  does `TESetText` + `TECalText` + `UiInvalRect` + scroll-sync; the
  actual drawing waits for an update event that can't arrive
  mid-handler. Same deferred-paint shape in `rtUiWidgetSetStr`'s label
  branch (`rtUiPstrcpy` + `UiInvalRect`).
- Line volume: a real compile emits ~50–100 progress lines (per-file
  "Included" lines, per-phase marks, per-segment cg68k lines). The Log
  window shows ~20 lines and there is no user-facing scroll API — live
  painting alone still ends with lines landing below the fold, so the
  window would look frozen again mid-compile. Two problems: painting,
  and tail visibility.

## Design decisions (with Andrew, 2026-08-11)

1. **Paint mechanism: synchronous draw inside the programmatic set
   paths** (chosen over an update-only event pump in `feProgress`, and
   over new explicit refresh surface). No event-loop involvement, so no
   reentrancy risk and `--events` boots stay deterministic; applies
   uniformly to all programs.
2. **Tail visibility: rolling-tail ticker in macgui** (chosen over a
   runtime auto-scroll — unconditional auto-scroll would break
   texteditor's openPath, which must show a file's top — and over
   accepting off-screen lines, which fails the requirement for any real
   compile). Pure macgui-side string work; the post-compile window
   state stays byte-identical to today.
3. **Progress bar: the cheap version.** A `label` in the Log window
   updated with an ASCII text bar, fed by a new counted seam
   `feProgressStep(cur, total)`. A real `progressbar` widget kind
   (parser/checker DSL + uidesc + uiblob + both-lane draw paths) is
   explicitly out of scope — nothing else needs one yet. The counted
   seam is expected to be reused by future compiler-UI work.

## Components

### 1. Runtime: synchronous paint on programmatic sets
(`runtime/clarus/uiwidgets.cla`)

- `rtUiWidgetSetText` (textview): after the existing `UiInvalRect` +
  `rtUiTeMutated`, draw immediately — `UiTEUpdate(viewRect, te)` (the
  port is already set to the widget's window), then `ValidRect`
  (new local trap decl, 0xA92A) on the view rect to cancel the
  now-redundant pending update. Scrollbar range/value changes already
  self-draw via the Control Manager inside `rtUiTeScrollSync`.
- `rtUiWidgetSetStr`, label branch: after `rtUiPstrcpy` +
  `UiInvalRect`, draw immediately — `UiTextBox` of the new pstring into
  the widget rect (TETextBox erases the box first, so shorter text
  leaves no residue; this is exactly the update-path draw in ui.cla),
  then `ValidRect` on the rect.
- Safety: a hidden or covered window is clipped by the port's visRgn —
  the sync draw is a no-op there. Cost for existing programs is one
  extra draw per programmatic set (e.g. BigText's 32KB set: one
  TEUpdate), negligible.
- No behavior change to event/trace semantics: both paths keep their
  existing `userEdit=false` (no `change` event) contract; the label
  branch's existing `rtUiTraceSetStr` line is unchanged (see Testing
  for the trace-volume watch item).

### 2. macgui: rolling-tail live ticker (`clarusc/macgui.cla`)

- `feProgress` keeps appending to `gcProgressBuf` (unchanged — still
  the authoritative log), and additionally maintains a fixed-size ring
  of the last ~18 lines (circular `list of string`, modulo write index;
  no list shifting, no text back-scanning). Each call rebuilds the
  ticker text from the ring and assigns `w.Output.text` on the front
  Log window. Nil-guarded: no Log window → buffer-only, today's
  behavior.
- `gcCompile` at compile start: captures the current `w.Output.text`
  into a base-log global (the ticker overwrites the on-screen text
  during the compile) and resets the ring + write index.
- `gcFlushProgress` becomes `w.Output.text = base + gcProgressBuf` — so
  the post-compile window is byte-identical to today: full accumulated
  log, prior compiles' lines included, subject to the same existing
  32KB `rtUiTeMax` clamp.
- Ring size is a fixed constant (~18 lines fits the default 480×300
  window), not computed from window height — no widget-geometry
  surface exists and a user-shrunk window merely crops the ticker.

### 3b. Whole-pipeline progress + spinner (amendment, 2026-08-11 evening)

Added after the first Snow boots: the bar tracked only codegen segments,
leaving e.g. a 35-minute `Measured` stretch bar-silent. Amended shape
(supersedes §3's two-int seam):

- **Seam:** `feProgressStep(cur: int, total: int, label: string)` —
  drive.cla announces the START of each stage, present-tense label,
  rendered as `[#####---------------] Loading Runtime (Step 4/10)`
  (bar width 20 — Andrew's sizing, filling more of the label lane).
  The timestamped log lines are untouched; log and bar are separate
  consumers (looking ahead to a future bar-first UI with a collapsible
  log — not built now).
- **Steps:** 10 fixed (Starting Compilation, Parsing, Checking, Loading
  Runtime, Checking Whole Program, Lowering, Shaking, Measuring,
  Packing, Building Fork) plus one per segment ("Writing Segment s"),
  inserted between Packing and Building Fork. `total` starts at 10 and
  grows by the segment count once Packing knows it — the bar may jump
  backwards at that moment, accepted by design (Andrew, 2026-08-11).
- **Spinner:** new seam `feProgressTick()` — called from the
  long-running inner loops (per-function in cg68k's measure and emit
  loops, per-file in drive's include expansion, per-decl in the whole-
  program check), no-op on the host CLI. macgui throttles by
  `TickCount()` (repaint at most ~every 30 ticks) and rotates an ASCII
  glyph appended to the status line, so long stages visibly stay alive.
  Callers never throttle; the seam stays cheap enough to call per
  function.
- Both new calls sit behind the same `want68k` gate as the rest of the
  progress machinery — emit/check-only/appinfo stay byte-silent.

### 3. Counted progress seam + label bar (original shape — superseded by 3b's label/step model; the label, gating, and no-op-host structure below still stand)

- **drive.cla:** new front-end seam `feProgressStep(cur, total)` plus a
  `driveProgressStep(cur, total)` wrapper (same `want68k` gate as
  `driveProgress` — the C `emit` lane and check-only/appinfo modes stay
  byte-silent). Called from cg68k's per-segment emission loop (the
  counted loop where most wall-clock lives), with `total` = the planned
  segment count known after the Measured phase. Phases before codegen
  show no bar — the ticker's per-phase lines cover them.
- **main.cla:** `feProgressStep` is a no-op (the host CLI already
  prints per-segment lines to stderr).
- **macgui.cla:** window Log gains a bottom-anchored status label
  (existing DSL, same shape as testsuite/toolbox/harness.cla's
  `label Status { at: next, bottom; text: "" }`); the textview keeps
  `fill: both` above it. `feProgressStep` renders an ASCII bar —
  `[######----] 12/32` style, plain `#`/`-` characters only (no
  MacRoman high bytes, avoiding the known Edit-tool corruption hazard)
  — into the label, nil-guarded like the ticker. `gcCompile` clears the
  label at its exit points.

## Out of scope (deliberate)

- No event pump / yield: the compile stays uninterruptible by design.
- No auto-scroll or scroll API surface.
- No `progressbar` widget kind, no other new language syntax.
- No changes to progress-line content or timestamps.
- The spec's original "bounded feProgress-side yield" sketch is
  dropped — the sync draw produces the same pixels with less machinery.

## Testing / acceptance

- Existing gates stay green: T1 (`scripts/test-task.sh --smoke`, since
  runtime/ and clarusc/ are both touched) and the toolbox-suite GUI
  boot (`TestToolboxSuiteOn68k`).
- Frozen-scenario PBM goldens may churn: a snap that previously
  captured stale pixels (set before an update event) now sees fresh
  ones. If so, re-bless via the native lane (`CLARUS_MAC_BLESS=1`) and
  eyeball the PBM diffs.
- Watch item: per-segment label sets add `rtUiTraceSetStr` lines to
  scripted-boot traces. `internal/mactest/macresident_test.go`'s trace
  parsing must be checked (and, if it asserts on trace shape, updated)
  at plan time.
- Byte-identity: runtime/clarus and macgui.cla changes alter emitted
  programs by design — the layer1 phase's frozen-source byte-identity
  gate does not apply here; the snapshot fixed-point
  (`TestSnapshotFixedPoint`) is unaffected (clarusc.c's composition
  does not include macgui.cla or the UI runtime).
- Per-line cost: one TESetText of ≤18 short lines + one TEUpdate per
  progress line; one TextBox per segment for the bar — microseconds
  against a multi-second compile.
- Acceptance (unchanged from the deferred spec, plus the bar): a
  compile started in `ClarusC.APPL` on the emulator shows progress
  lines appearing live in the Log window while the compile runs, the
  status label shows an advancing bar during codegen, and the existing
  toolbox-suite GUI boot stays green. Verified by eye during the Snow
  acceptance rerun this feature exists to support.
