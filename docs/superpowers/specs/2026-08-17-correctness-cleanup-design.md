# Correctness-cleanup phase — design

**Date:** 2026-08-17
**Status:** approved (Andrew, 2026-08-17, in-session)
**Branch:** `correctness-cleanup`

## Why now

A field run of `examples/bookmarks.cla` on a real PowerMac G4 under
Mac OS 9's 68k emulation crashed twice: once with system error 10
(F-line / unimplemented instruction) and once with a divide-by-zero.
System 9/PPC is NOT a supported target (nice-to-have only), but the
crashes are evidence of real bugs that our supported lanes have been
passing on heap-layout luck — the stale-master-pointer-across-compaction
class the ROADMAP standing rules already warn about (found six times to
date). Separately, the About box displays nothing on ANY machine —
emulators or hardware — a genuine port regression, root-caused during
this design (see §2).

This phase fixes every known wrong-behavior and memory bug that does
not require real-input (live mouse/keyboard) testing, pins one
previously-unspecified language semantic (integer division by zero),
and adds the missing lever: a way to exercise the stale-master-pointer
class deterministically instead of by luck.

Scope decisions (Andrew, in-session): buckets 1–4 below are IN.
Diagnostics-quality items (lexer escape messages, `edit sm[k]`
diagnostic, transport-tag fall-through), bake-machinery robustness,
odd-C-size record-layout divergences, and real-input coverage stay in
`docs/TODO.md`, untouched. Div-by-zero semantics decision: **runtime
panic**, same error class as list index out of range.

## 1. Symptom → cause map (what we believe, and how confident)

- **Bookmarks divide-by-zero (G4):** `runtime/clarus/uitable.cla:795`
  divides by `peekw(lhMp + rtUiListCellSizeV)` — a peek through a
  cached List-record master pointer. A stale `lhMp` after compaction
  reads garbage; garbage 0 → divide-by-zero. CONFIRMED-PLAUSIBLE, not
  reproduced (no G4 repro budget this phase; the heap-jiggle harness in
  §4 is how we get local confirmation).
- **Bookmarks error 10 (G4):** same class — garbage state from a stale
  master pointer leading to a wild jump or corrupted dispatch.
  PLAUSIBLE; the audit + harness either finds it or narrows it.
- **Also noted:** the reference's own Appendix C `Remove.click` lacks a
  `Marks.selected == -1` guard (recorded TODO erratum) — a second,
  independent Bookmarks crash candidate, fixed this phase (§6).
- **About box shows nothing anywhere:** CONFIRMED root cause, §2.

## 2. About box: regression fix + real display

**Root cause.** `rtUiAppleSelect` (`runtime/clarus/ui.cla:1197`)
branches on `uidHasApp() and peekb(uidAppName()) != 0` — i.e. "app has
a name" — into `rtUiTraceAbout()` (`runtime/clarus/uiscript.cla:532`),
which only appends a `T ABOUT name|version|author|about` line to the
scripted trace and displays nothing. The rt_ui.c original gated that
branch on scripted/test mode; the port replaced the mode gate with the
name gate, so every real app lost its About display on every machine.
The scripted goldens kept passing because they assert the trace line.

**Both lanes already ship the About resources.** For app-declared
programs, ALRT/DITL 129 is emitted by `cg68ResourceParitySet`
(`clarusc/cg68k.cla`, native lane) and by `scripts/build-mac.sh`'s
appres.r generation (Retro68 lane). The runtime simply never calls
them.

**Fix (runtime-side, plus one alert-template repair):**

- `rtUiAppleSelect` item 1 branches on **`rtUiScripted`**
  (`uiscript.cla:59`), not on the app name. Scripted boots keep
  emitting `T ABOUT` — goldens unchanged byte-for-byte.
- Real path, app-declared program: `ParamText` with the four descriptor
  strings (`uidAppName/Version/Author/About`, converted to the DITL's
  `^0`–`^3` convention — match whatever the existing DITL 129 text item
  actually uses, both lanes emit the same bytes) then `UiNoteAlert(129,
  ptr(0))`.
- Real path, no `app` section: keep the existing generic
  `NoteAlert(128)` + CurApName fallback (already correct; ALRT 128 is
  unconditionally emitted for UI programs).
- While in the alert templates: fix the attempt-abort field-test's
  known **OOM-alert button-overrun geometry bug** (button outside the
  ALRT frame) in `app68BuildAlrt`/DITL geometry — same builder family,
  one task.

**Acceptance:** boot one app-declared example (`mandelbrot`) and one
bare-UI program in Snow WITHOUT `--events`, click Apple menu → About,
screenshot both alerts. (This is a manual acceptance boot, not a new
automated gate — real menu clicks are the display carve-out; the
scripted lane continues to cover the trace branch automatically.)

## 3. Div-by-zero: pin the semantic, guard both lanes

**Reference change (normative):** integer `/` and `mod` with a zero
divisor is a runtime error, same class and machinery as list index out
of range. Message: `division by zero`. (`fixed` division via `FixDiv`
is out of scope — Toolbox-defined behavior.)

**Native lane:** divisor test at the top of the shared
`cg_div32`/`cg_mod32` glue (`clarusc/cg68k.cla:11923` region), branch
to the existing panic path (`cgEmitPanic` family / `rtPanic`) — one
site, every division in every program inherits it. Expect a broad
golden rebless (every `.s` with a div/mod changes) plus a
`clarusc/clarusc.c` snapshot regen — one mechanical commit, exactly
like prior codegen phases.

**Host lane:** the emitted C for `/` and `mod` gets the same check
routed to the C runtime's panic (today it inherits C UB / SIGFPE).
Keep the emission shape small (helper or inline ternary-with-panic —
implementer's choice, byte-stable across the corpus).

**Tests:** `testdata/runerr/divzero.cla` fixture asserting the exact
panic text, wired the same way as `listindex.cla` (the regression
fixture added by the runtime-ir-bake T2 blocker fix), both lanes.

## 4. Stale-master-pointer class: audit + deterministic harness

**Audit.** Sweep the UI runtime for master pointers cached across
allocating/moving calls, fixing by re-derivation from the handle after
any such call (the ROADMAP standing rule). Priority order:

1. `runtime/clarus/uitable.cla` — click/relayout/scroll paths first
   (`:795`'s divide is the prime suspect; `rtUiTableRelayout` already
   had one such bug found and fixed);
2. `runtime/clarus/ui.cla`, `uiwidgets.cla`, `uitext.cla`;
3. anything the harness below flushes out elsewhere.

`rtUiTableClick`'s scripted row math stays UNCLAMPED — it is a
deliberate tripwire (runtime-ir-bake T2 blocker decision); the fix for
anything it catches is re-derivation, never a clamp.

**Heap-jiggle harness (the new lever).** Six findings by layout luck is
the problem; make the class deterministic:

- A scripted-lane stress mode: when enabled, force a compaction-and-
  move storm (`CompactMem(maxSize)` + purge/`MoveHHi`-style pressure on
  the app zone) immediately before each scripted event dispatch, so any
  cached master pointer that can go stale does go stale, every run.
- Exposure: a `UiTest` wrapper / scripted verb (uitest.cla +
  uiscript.cla), OFF by default, enabled by the suite boot that wants
  it.
- Gate: one additional toolbox-suite native boot under jiggle mode in
  T2 (`internal/mactest`), fanning out per-case like the existing
  suite boots. T1 untouched (no emulator).
- Exit criterion: toolbox suite green under jiggle mode. Any failure it
  produces is a real bug of exactly the class we're hunting; fix as
  found (timebox: if the tail is long, remaining findings get recorded
  as blocking follow-ups rather than silently deferred).

## 5. Memory bugs

- **Bare-`EIntr` arg release gap (both lanes, pre-param-abi):**
  `list_pop`/`list_shift` results passed DIRECTLY as borrowed call
  arguments get no scheduled release — wire the transfer-convention
  discard release (`fpDiscardExprIdx` machinery) for the direct-arg
  shape. Leak-check fixture on host (the memory-leak-fix phase's
  growth-measurement pattern) + native suite still green.
- **`rt_ext_ConnHOpen` fd overwrite** (`runtime/host/rt_serial.inc`):
  close the existing fd before overwriting an already-open slot.
  Latent (unreachable today), 2 lines + a comment.

## 6. Known-location wrong-behavior fixes (batched)

Each is small, with the location already pinned by a prior phase's
review; each gets a fixture or fixture-equivalent where one is missing:

1. **Popup label-lane width clamp** — `rtUiPopupBoxInto`
   (`runtime/clarus/uitable.cla:286`) and the popup draw branch use raw
   `rtUiFieldLabelW`; a labeled `popup` with `width:` under ~90px gets
   a zero-width unclickable box. Clamp in the layout width computation
   (mirror the labeled-field branch, `ui.cla:1708/1721` region). New
   fixture declaring a narrow labeled popup.
2. **`cgRetNeedsHidden` extended to `KErr`** (`clarusc/cg68k.cla`) so
   `func f(): error` compiles on the native lane (today: loud
   `EVarRef non-scalar` emit-time failure, reproduced by the
   serial-connection final fix-wave's Probe 6). Regression fixture =
   Probe 6's throwaway `makeError` shape, kept this time.
3. **Widget-property out-param misuse** — `file.readText(p,
   d.Body.text)` compiles and silently fills a discarded temporary;
   make it a loud compile-time error naming the shape (checker-side;
   the real fill-in-place binding remains future binding-walker work).
4. **`get(k, dv)` argument evaluation order** — align native lowering
   to host's `(m, k, dv)` order and pin the order in the reference
   (observable only with side-effecting arguments; divergence is
   map-hashtable-phase debt).
5. **PBM icon parser line endings** — `app68BuildIcnFamily`'s P1
   parser accepts CR/CRLF/LF (same treatment as the lexer's CR fix);
   un-defers the attempt-abort field-test finding. Fixture: CR-ending
   PBM bytes.
6. **`irXRecFieldSize` forward-reference guard** — same
   guard-plus-diagnostic treatment as the fixed `lowTypeAt` path, for
   the nested-xrec forward-reference shape (currently an unguarded
   panic; no fixture reaches it — add the fixture that does).
7. **Appendix C erratum** — `Remove.click` guards
   `Marks.selected == -1`; fix in BOTH the reference appendix and
   `examples/bookmarks.cla` (the example ships the appendix verbatim;
   it is also a live crash candidate on real hardware).
8. **`toBytes` name-only mutation guard** (`clarusc`, param-abi Task 2
   debt) — move the guard behind the receiver-kind check so it fires
   on receiver kind, not method name alone.

## 7. Out of scope (recorded, deliberately untouched)

- System 9 / PPC as a target; no G4 repro work (machine is in use).
- Real-input coverage (TrackControl/modal SF halves, `UiLaunchReal`).
- Diagnostics-quality: lexer escape message/cascade, `edit sm[k]`
  checker message, `transportName` tag fall-through, transport-misuse
  column.
- Bake/CLIR robustness items; `natLogCap`; layout divergences;
  `KArr` param ABI; RSS profiling; connection carrier-detect.
- The 3-way connection-dispatcher builder fold and other pure-tidiness
  items from the serial phase.

## 8. Execution, gates, risks

- SDD per project convention: subagent-driven, `model: sonnet` for
  implementation and per-task review, `haiku` for mechanical batches
  (golden rebless), opus reserved for a debugging task that goes
  sideways. Fable designs/dispatches/reviews/integrates.
- Feature branch `correctness-cleanup`; T1 (`scripts/test-task.sh`)
  after every task, `--smoke` for every task here that touches
  `runtime/` or `clarusc/` (most of them); T2 (`scripts/test-merge.sh`)
  before merge. Merge only on request.
- Bytes WILL move: the div-guard (every div-site `.s`), possibly the
  ALRT geometry fix (alert resource bytes). Golden rebless + snapshot
  regen are their own mechanical commits, per convention.
- `bake.cla`/`macgui.cla` are NOT expected to be touched; if any task
  ends up touching them, the standing rule applies (manual
  `TestClarusCBakePathOnSnow` re-run, ~55m, CLARUS_SNOW_TESTS=1).
- Risk: the jiggle harness may flush out MORE stale-pointer bugs than
  the audit finds by reading — that is its job; the timebox rule in §4
  keeps the phase from ballooning silently.
- Risk: `CompactMem`-before-every-dispatch may be too slow for the
  full toolbox suite in T2; fallback is jiggling on a sampled subset
  of dispatches (deterministic stride), which still breaks layout
  luck. Decide on measurement during the task.
