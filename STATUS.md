# Session status — 2026-08-15 (attempt-abort DONE + MERGED to origin/main, all gates green)

Handoff summary for the next session. **The `attempt-abort` phase is
COMPLETE, fully gated (host + emulator + Snow), field-tested by Andrew
on Snow, and MERGED to `main` (fast-forward `97d043c..d299b72`,
Andrew's instruction, 2026-08-15 01:34 JST) and pushed to origin**
(plus docs commits `3d141a9`+). The local checkout is on `main`; the
`attempt-abort` branch pointer equals it. Everything through this phase
is on `origin/main`.

## 0. START HERE next session

Nothing is unmerged and nothing is owed on `attempt-abort`. The next
phase per the roadmap is **stage 4 of the precompiled-artifacts
staging: the user-module artifact cache** (standalone object files +
keying, generalizing the object-code-linker phase's runtime-only object
sections to arbitrary user modules —
`docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`'s
own Staging section). **No spec or plan exists yet — the first job is
speccing it**, same design-first process as the prior phases. After
stage 4, the 5f decomposition's last sub-phase is Retro68 retirement.

Smaller candidate items (not scheduled, Andrew's call on priority; all
recorded in the ROADMAP attempt-abort entry's debt list):

- **PBM icon parser rejects CR line endings on the Mac** (field find,
  deferred per Andrew — "worry about that later"): both example icons
  warn "not a well-formed 32x32 P1/P4 PBM" on-Mac while parsing fine on
  host; `app68BuildIcnFamily`'s P1 parser likely splits on LF only,
  and Mac-side files (or anything staged via `hcopy -t`) have CR
  endings. Give it the lexer's own CR/CRLF/LF treatment.
- **`rt_ext_UiValidRect` Retro68 link gap** (surfaced during Task 10):
  a real `scripts/build-mac.sh --test` rebuild fails to link
  (`uiwidgets.cla` references it; no C shim exists) — blocks any fresh
  Retro68/cprint-lane rebuild, including Rez re-extraction of the
  resparity goldens. Pre-existing, unrelated to attempt-abort.
- **cprint-lane UI dispatcher abort-default gap** (parked by ruling):
  the C lane's synthesized UI dispatch has no per-handler abort check
  (native lane does, full-strength). Acceptable on the demoted
  diagnostic lane; becomes relevant only if that lane is ever
  re-promoted (it is slated for retirement instead).

## 0a. attempt-abort close-out (DONE, MERGED — this session)

Full detail: ROADMAP's `attempt-abort` entry (task ledger, rulings,
perf, debt). Design:
`docs/superpowers/specs/2026-08-14-attempt-abort-design.md` (annotated
where the landed design differs). Plan:
`docs/superpowers/plans/2026-08-14-attempt-abort.md`. Ledger + reports:
`.superpowers/sdd/2026-08-14-attempt-abort/` (retained, incl.
`deferred-gates.md` — every item now marked run/green). Reference:
`docs/clarus-language-reference.md` Ch5 ("Attempt and Abort"), Ch12,
Ch13.

**What it is:** `attempt { } aborted msg { }` + `abort(msg)` —
cooperative flag-propagated unwinding on both lanes (no mark stack, no
setjmp; per-function bail blocks synthesized in LOWERING run every
frame's ARC releases — leak-proven; interprocedural `canAbort`
analysis keeps the happy path fast). clarusc's ~121 fatal
`log+quit 1` pipeline sites became `abort(msg)`; `ClarusC.APPL`'s
`gcCompile` catches with beep + real alert + return-to-idle, Log
window preserved. `alert()` and runtime panics are now actually
user-visible on the native lane (both were headless trace writes —
panics additionally got the beep+alert-before-exit treatment, Task 9,
after Andrew field-diagnosed a silent OOM exit from the `out` file).
Plus: pre-compile progress ("Loading/Verifying Baked Runtime" + hash
spinner ticks), missing-icon warn+default fallback, `out` stamped
`TEXT`/`ttxt`, ALRT 128's OK button inset fixed (first-ever render
exposed a flush-edge DITL rect).

**Scale:** 11 tasks (8 planned + ruled-in 6b perf follow-up, 9 panic
fix, 10 dialog geometry, 11 golden split), ~36 commits, 2 snapshot
regens, every task subagent-implemented and independently reviewed;
the final whole-branch opus review caught a wrong-dialog-ID Critical
(ALRT 130 vs 128) no scripted gate could ever see.

**Numbers that matter:** host self-compile **−11.5% vs pre-feature**
(the naive scheme's +26.3% was recovered net-positive by the `canAbort`
fixpoint); native emit68k ~0%; `TestSelfEmit68k` 51→54 segments; two
real unwind leak classes found by probe and fixed (4000→0, 12000→0
blocks, pinned by `TestAbortLeakBaseline`); site audit 84
internal-invariant / 40 user-reachable; core suite 64→69 cases.

**Gates, all green:** T1 throughout; full T2 **PASS 249s** (native
lane incl. suite 69/69, `TestAbortOn68k` with Task 11's lane-specific
`.out68k` expectation); **`TestClarusCBakePathOnSnow` PASS 1201s**
(standing rule satisfied for this phase's `bake.cla`/`macgui.cla`
changes; zero fallback/drift lines, forks byte-identical);
**`TestMacResidentFailedCompileStaysAliveOnSnow` PASS 1201s** (NEW —
the phase's own field defect regression-gated: failed compile alerts,
app survives, second compile in the same session builds and
byte-verifies); scenario-golden rebless proved UNNECESSARY (zero churn
— behavior-level goldens); `out` FInfo `TEXT/ttxt` + both alert-dialog
visuals field-confirmed by Andrew (screenshots, 2026-08-14/15); merged
result re-verified with T1 before push.

**Operational note that changed the economics:** both Snow tests ran at
a **20m settle under toolbar fast-forward (~7x)** — Andrew's sizing —
instead of the historical 55m. Procedure: boot at 1x, click the
toolbar ▶▶ AFTER the app is up (never `start_fastforward` at boot),
keep a move-only CGEvent nudger running against the display idle-lock.

**Field-test data (Andrew, Snow):** all five example programs compiled
on-Mac; a real mid-segment-write OOM at a 12MB partition first exposed
the silent-panic gap (fixed, Task 9, then field-confirmed with the
dialog); bookmarks.cla's partition floor is 12-16MB (Measure 5m52s at
16MB vs 9m14s at 12MB — compaction-thrash signature); 48MB default
partition keeps its headroom rationale.

**Debt carried (full list in the ROADMAP entry):** the three items in
section 0 above, plus: no automated dispatcher-default test on either
lane; `declIsRuntimeOrigin`'s symlink-equivalence residual (shared,
pre-existing); native non-UI stub lacks inter-entry abort checks
(behavior still correct); `__retN` overhead in abort-enabled programs
(ordering-forced); duplicated lowering idioms; host `--rtbake` path
lacks the pre-compile progress messages; `TestRunErrOn68k` can't boot
`App.startCLI`-shaped fixtures (pre-existing native-compat gap — the
two new abort runerr fixtures are host-covered only).

## 0b. Prior phases (all merged; recap pointers only)

- **object-code-linker** (stage 3.5, CLIR v6 baked object code,
  −41%/−35% emit68k) — merged 2026-08-14 (`e143af1..6009c65`). Its
  Snow saga (C-lane signed-overflow UB hash bug, CLAR_*32 fix, re-run
  PASS) is recorded in ROADMAP; debt list in its entry.
- **fallback-trigger-narrowing** (CLIR v5 per-module source hash,
  include-dedup by construction) — merged 2026-08-13.
- **runtime-ir-bake / param-abi / memory-leak-fix /
  layer1-compiler-perf / datetime-instrumentation / map-hashtable /
  mac-resident-clarusc** — the 2026-08-12/13 stack, all merged
  (`322765a..b16e8f0`). Highlights that remain operationally relevant:
  the leak fix made per-compile growth 0 and compile #2 ≈ compile #1
  on hardware; `cgEmitPanic`'s empty-message bug is fixed and
  regression-tested (`TestRunErrOn68k`); the ~5x compiler speedup and
  hashtable maps underlie current perf.

**Standing rules (unchanged):** re-run `TestClarusCBakePathOnSnow`
(`CLARUS_SNOW_TESTS=1`) after ANY change to `clarusc/bake.cla` or
`clarusc/macgui.cla` — it is the only proof of the `ClarusC.APPL`
default bake path (satisfied for attempt-abort; 20m settle suffices
with fast-forward, see 0a). `internal/selfhost` always gets
`-count=1 -timeout 30m`. Merge only on Andrew's request; main stays
green.
