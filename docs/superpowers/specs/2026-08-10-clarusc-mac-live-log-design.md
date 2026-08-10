# ClarusC.APPL live Log-window updates (deferred phase)

Status: **deferred requirement — split out of
`2026-08-10-datetime-instrumentation-design.md` §7.** Not scheduled yet:
runs after the next round of Layer-1 compiler performance work, before
the next attempt to compile on the emulator (an on-Mac compile is
currently hours long; instrumenting it live is not worth emulator time
until compiles are faster).

## Requirement

During a compile in `ClarusC.APPL`, each `feProgress` line must
**visibly appear in the Log window while the compile is still
running** — the user must be able to tell a working compile from a hang.
This is the Mac half of the "is it even running?" fix; the host half
(stderr logging) ships with the datetime/instrumentation phase.

## Context (as of the datetime/instrumentation phase)

- drive.cla emits timestamped progress lines through the front-end seam
  `feProgress(line: string)`.
- `macgui.cla` defines `feProgress` by appending to the Log window's
  `Output` textview via the existing `gcLog` read-mutate-reassign path
  (`macgui.cla:155-162`).
- The compile runs **synchronously inside an event handler**
  (`gcCompile`), so the appended text renders only when events next
  process — i.e. after the compile finishes. Lines accumulate correctly;
  they just don't paint.

## Work sketch (design pending at scheduling time)

Investigate what the widget layer needs to flush a textview append to
the screen mid-handler — likely a synchronous invalidate + draw of the
`Output` widget (TE update path in `runtime/clarus/uitext.cla` /
`ui.cla`), possibly a bounded `feProgress`-side yield. Constraints to
respect:

- No event-loop reentrancy surprises (the compile must not become
  interruptible by accident).
- Cost per line must be negligible against compile time.
- Behavior under `--events` scripted boots must stay deterministic
  (scripted suites drive the same GUI).

## Acceptance

A compile started in `ClarusC.APPL` on the emulator shows progress
lines appearing live in the Log window while the compile runs, and the
existing toolbox-suite GUI boot stays green.
