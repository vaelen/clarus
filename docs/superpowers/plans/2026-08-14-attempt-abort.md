# attempt/abort Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Recoverable compile failures via a new `attempt`/`aborted` +
`abort(msg)` language feature (cooperative flag propagation, both lanes),
convert clarusc's ~150 fatal `quit 1` sites to it, and fix ClarusC.APPL's
silent pre-compile window and fatal missing-icon path.

**Architecture:** `abort(msg)` sets a global flag+message and bails through
its function's normal epilogue (ARC releases run — no leaks); codegen
inserts a flag check after every user-function call that either bails
onward or, inside an `attempt` body, enters the `aborted` block. No runtime
mark stack. Emission is gated: programs that don't use the feature compile
byte-identically. See the spec for full semantics.

**Tech Stack:** Clarus (clarusc self-hosted compiler: lex/parse/check/
lower/cg68k/cprint), Go test harness, Retro68/Mini vMac (deferred lanes),
Snow (deferred lane).

**Spec:** `docs/superpowers/specs/2026-08-14-attempt-abort-design.md`
(normative; argue from it, and record any narrowing as spec annotations).

## Global Constraints

- Branch: `attempt-abort` off `main` (`500d992`). Main stays green; merge
  only on Andrew's request.
- **EMULATORS ARE OFF-LIMITS this phase until Andrew frees them**: no
  `--smoke`, no `CLARUS_MAC_TESTS=1`, no `CLARUS_SNOW_TESTS=1`, no
  LaunchAPPL/Mini vMac/Snow boots. Every task runs host-side gates only
  (`scripts/test-task.sh` WITHOUT `--smoke`); emulator-lane obligations
  accumulate in Task 8's deferred checklist. Andrew is using the display.
- Byte-identity: any program not using `attempt`/`abort` must emit
  byte-identically on both lanes. The existing goldens + `CLARUS_BAKE_FULL`
  corpus are the proof; run them per task as listed.
- `runtime/clarus/*.cla` and `toolbox/*.cla` must NOT use `attempt`/
  `abort` (spec §3.4). Baked CLIR (v6) stays format-unchanged: the new IR
  forms never appear in baked runtime IR, so no version bump.
- Bootstrap ordering (self-hosting): clarusc's OWN source may not use the
  new syntax until the committed snapshot `clarusc/clarusc.c` has been
  regenerated with a feature-capable compiler. Snapshot regen #1 is Task
  5's last step; only Task 6 onward may put `attempt`/`abort` in
  `clarusc/*.cla`.
- `internal/selfhost` always gets `-timeout 30m -count=1`.
- MacRoman `.cla` files: never edit with the Edit tool if the file
  contains MacRoman bytes — use `LC_ALL=C sed` + byte-diff (memory:
  macroman-cla-editing). The files this plan touches are ASCII; check
  with `file`/`iconv` if unsure.
- Subagents: state the model at dispatch; implementation/review =
  sonnet, mechanical batch edits = haiku, never Fable.

---

### Task 1: Probe wave (no tree commits)

**Files:**
- Create: `.superpowers/sdd/2026-08-14-attempt-abort/probe-report.md`
- Read-only: `clarusc/cg68k.cla`, `clarusc/cprint.cla`, `clarusc/lower.cla`,
  `clarusc/ir.cla`, `clarusc/drive.cla`, `internal/mactest/leakgate_test.go`

**Interfaces:**
- Produces: probe-report.md with a PASS/FAIL + evidence per probe below,
  and amendment notes for Tasks 3-5 where reality differs from the plan.

Every probe is a load-bearing assumption of a later task. For each,
record file:line evidence, not opinion. FAIL on any probe = STOP, report
back with the amendment before any later task is dispatched.

- [ ] **P1 (Task 4's SP-safety):** Confirm cg68k function frames use
  `LINK A6` / `UNLK A6` (or equivalent frame-pointer discipline) such
  that (a) a bail sequence can jump to the epilogue from ANY expression
  stack depth safely, and (b) an `aborted`-block entry inside a live
  function can restore SP to the statement-boundary level from A6 plus a
  compile-time frame size (`LEA -frame(A6),SP` shape). Identify the
  exact epilogue-emission site in `cgEmitFunc` (or its callee) and how
  per-function local-release code is emitted around it, and whether a
  reusable label already exists for "release locals then return".
- [ ] **P2 (Task 4's check insertion):** Confirm `cgCallFunc` is the
  single chokepoint that emits user-function calls, and identify a
  correct compile-time predicate for "callee is a user function, not a
  runtime function" (candidate: the runtime-prefix function-index
  boundary the object-code phase uses; verify against
  `bkRuntimeFuncBoundary`'s documented caveats). Then confirm the
  object-code paste path's call-reloc re-emission (`cgCallFunc` from the
  link pass, object-code-linker phase) can NEVER target a user function
  from a baked runtime body — i.e. baked runtime bodies only call
  runtime functions/glue (evidence: the capture-side reloc data or the
  A1-amendment notes in the object-code-linker spec). This is what makes
  "checks only after user calls" safe for the paste path.
- [ ] **P3 (Task 3's check insertion):** Confirm cprint materializes
  user-function call results into statement-level C temporaries (the
  statement-temp tracker), so `if (rt_aborting) goto <bail>;` can be
  emitted textually after each user call, before the value is consumed.
  Identify how cprint emits the release-before-return sequence and
  whether a per-function bail label can reuse it (name the emission
  site).
- [ ] **P4 (Task 3/4's top-level defaults):** Locate (a) the non-UI
  startup stub each lane synthesizes (the code that calls
  `App.startCLI`), (b) the synthesized UI event dispatcher's
  handler-call site on the 68k lane, (c) what `log(msg)` lowers to on
  each lane (exact runtime function names), and (d) what `alert(msg)`
  lowers to natively. These are where the spec §3.5 defaults get
  emitted.
- [ ] **P5 (Task 5's leak assertion):** Identify the host-side
  allocation-counting seam `internal/mactest/leakgate_test.go` uses for
  the `DoubleCompile` 0-growth assertion, and confirm it can be reused
  for a new "abort through retained frames returns to baseline" test
  (name the counters/functions and the package where the new test fits).
- [ ] **P6 (Task 4's measure/emit consistency):** Confirm the Measure
  pass and the per-segment emit pass produce function sizes via the SAME
  emission code path for user functions (so inserted checks are counted
  identically in both), and note any Measure-skip interaction with
  `--rtbake` (baked runtime functions are size-substituted — fine, they
  never contain checks; verify nothing else caches user-function sizes
  across the gating flag).
- [ ] **Step 7: Write probe-report.md** with per-probe verdicts +
  evidence + any Task 3-5 amendments. No tree commits (report lives in
  the SDD workspace, committed with the ledger at task boundaries per
  SDD convention).

---

### Task 2: Front end — lexer, AST, parser, checker, IR, lowering

**Files:**
- Modify: `clarusc/lex.cla` (keywords), `clarusc/ast.cla` (statement
  arena), `clarusc/parse.cla` (statement parsing), `clarusc/check.cla`
  (typing/scoping rules), `clarusc/ir.cla` (structured node + intrinsic
  name), `clarusc/lower.cla` (lowering + program flag), `clarusc/drive.cla`
  (flag reset)
- Create: `testdata/errs/attempt_missing_aborted.cla` + `.err`,
  `testdata/errs/abort_arg_type.cla` + `.err`,
  `testdata/errs/abort_arity.cla` + `.err` (match the existing
  `testdata/errs` fixture conventions — read two existing pairs first,
  e.g. the param-abi phase's `param_assign` fixture, and mirror their
  exact format)
- Test: `internal/selfhost` `TestErrorGoldens` picks up `testdata/errs`
  by glob; plus a positive check-only fixture under
  `testdata/check/` if that directory convention exists (verify; else a
  compile of the Task 5 core-suite fixture file serves as the positive
  case later — minimum bar for THIS task: bare `clarusc FILE` check
  passes on a valid attempt/abort program)

**Interfaces:**
- Consumes: nothing from other tasks.
- Produces (names later tasks rely on):
  - AST: statement kind + accessors for `attempt` (body block, binder
    name index, handler block) and `abort` (arg expr) — follow the
    file's existing statement-kind naming EXACTLY as neighboring
    statements do (read `if`'s statement representation first and mirror
    it; record the chosen names in the task report for Tasks 3/4).
  - IR: structured node with accessors `irAttemptBody(i)`,
    `irAttemptBinder(i)`, `irAttemptHandler(i)` (mirroring
    `irIfCond`/`irIfThen`/`irIfElse` at `ir.cla:1485-1495`), plus
    intrinsic `IAbort()` = `intern("abort")` following the
    `IAlert()`/`IQuit()` pattern at `ir.cla:3923-3937`.
  - Lowering: global `lowUsesAbort: bool` (or the file's naming
    convention for program-level flags), set TRUE when any attempt/abort
    lowers; reset per compile alongside the existing per-compile lowering
    state (find where lower.cla's per-compile globals reset — the
    driveReset doc comment in `macgui.cla:430-447` enumerates the reset
    conventions); exposed to both backends.

Language rules to implement (spec §3.1):
- New reserved keywords `attempt`, `aborted`; `abort` handled exactly the
  way `alert` is handled at the front end (statement-position builtin,
  one argument; find alert's parse path and mirror it).
- Grammar: `attempt { stmts } aborted IDENT { stmts }` — the `aborted`
  clause is REQUIRED; its IDENT binds a fresh `string` local scoped to
  the handler block (normal shadowing rules).
- Checker: `abort(expr)` requires `expr` string-typed (same coercion set
  as `alert`'s argument); `attempt` without `aborted` is a parse error;
  `abort` with 0 or 2+ args is an error. Diagnostic wording matches the
  fixtures you create.
- Lowering: attempt → the structured IR node; abort → `IAbort` intrinsic
  with the arg. Backends will reject the new forms until Tasks 3/4 —
  verify each backend's existing unknown-intrinsic path fails LOUDLY
  (message naming the intrinsic), and if it doesn't, add an explicit
  "attempt/abort: codegen not yet implemented" fatal in each backend as
  part of THIS task so a mid-plan tree never miscompiles silently.

- [ ] **Step 1:** Read the neighboring patterns: `if`/`while` in lex/
  ast/parse/check/lower, `alert` end-to-end, `irIf*` accessors,
  two existing `testdata/errs` fixture pairs.
- [ ] **Step 2:** Write the three error fixtures (failing first —
  `go test ./internal/selfhost -run TestErrorGoldens -count=1 -timeout 30m`
  must FAIL with "no such fixture handling" / wrong-diagnostic before
  the feature exists; capture the exact pre-change failure mode).
- [ ] **Step 3:** Implement lexer + AST + parser. Verify a hand-run:
  `scripts/clarus-run.sh` a tiny attempt/abort program — expect it to
  now FAIL at the checker or backend (not the parser).
- [ ] **Step 4:** Implement checker rules; error fixtures now produce
  their goldens. Run `TestErrorGoldens`: PASS.
- [ ] **Step 5:** Implement IR node + `IAbort` + lowering +
  `lowUsesAbort` (+ its per-compile reset). Verify the loud
  backend-rejection path on both lanes (emit + emit68k of the tiny
  program each fail with the named message).
- [ ] **Step 6:** Run `scripts/test-task.sh` (NO --smoke): PASS.
- [ ] **Step 7:** Commit (`feat: attempt/aborted + abort(msg) front end
  (lex/parse/check/IR/lowering; backends reject pending codegen)`).

---

### Task 3: C lane codegen (cprint)

**Files:**
- Modify: `clarusc/cprint.cla`
- Create: `testdata/runerr/abort_uncaught.cla` + `.err` + `.behavior`
  (mirror `testdata/runerr/listindex.*`'s exact format — read it first;
  it is the file set the runtime-ir-bake phase added for panic-text
  assertions, host glob + native `TestRunErrOn68k`)
- Test: host behavior glob (`behavior_test.go`'s package — locate it;
  T2-tier per CLAUDE.md) + in-task `scripts/clarus-run.sh` runs

**Interfaces:**
- Consumes: Task 2's IR accessors + `IAbort` + `lowUsesAbort`; P3/P4
  probe findings.
- Produces: C-lane semantics for Tasks 5/6 fixtures; the generated-C
  globals are named `clar_aborting` / `clar_abort_msg` (or the
  generated-code prefix convention cprint already uses — match it and
  record the chosen names in the task report).

Emission rules (all gated on `lowUsesAbort`; a no-feature program's
generated C must be BYTE-IDENTICAL to pre-task output):
- Program preamble: emit the flag (int, 0-init) + message buffer
  (Str255-sized) as generated-code globals.
- `IAbort`: evaluate arg → copy into message global → set flag → `goto`
  the current bail target (the statically enclosing `attempt`'s handler
  entry if any, else the function's bail label).
- After every USER-function call statement-temp assignment (P3 site):
  `if (flag) goto <bail-target>;` — same target selection rule. No
  checks after runtime calls/intrinsics.
- Per-function bail label: zero/NULL the function's return slot if
  handle-typed, then fall into the existing release-before-return
  sequence (P3's named site). Functions containing no user calls and no
  abort get NO bail label (dead-label-free output).
- `attempt` handler entry: clear flag, copy message global into the
  binder local, then the handler block's statements.
- Top-level default (P4 site, non-UI): after `App.startCLI` returns:
  `if (flag) { <same call log() lowers to>(msg); exit(1); }` — output
  format must be byte-identical to today's `log(msg)` + `quit 1` (the
  Task 6 conversion depends on this equivalence for golden stability).

- [ ] **Step 1:** Write `testdata/runerr/abort_uncaught.cla`: a non-UI
  program whose `App.startCLI` calls a helper that calls `abort("boom")`
  with no enclosing attempt; `.behavior`/`.err` assert the exact
  uncaught-default message + exit code 1, in listindex.*'s format. Run
  the host behavior test: FAIL (feature not emitted yet — backend
  rejection from Task 2).
- [ ] **Step 2:** Write a THROWAWAY local script fixture (not committed
  or committed under the SDD workspace, implementer's choice) covering:
  catch one frame down; propagation through 3 frames with a retained
  `text` local in the middle frame; nested attempt (inner catches);
  re-abort from handler caught by outer. Drive with
  `scripts/clarus-run.sh`, asserting printed output via `log`.
- [ ] **Step 3:** Implement the emission rules above. Iterate until the
  script fixture passes all four scenarios and `abort_uncaught` behaves.
- [ ] **Step 4:** Byte-identity check: `clarusc emit` of 3 no-feature
  programs (e.g. `testdata/emitui/every.cla`, `clarusc/main.cla`,
  `examples/texteditor.cla`) before/after the change — diff the .c
  outputs; MUST be byte-identical. (Generate "before" from a scratch
  build of the pre-task commit.)
- [ ] **Step 5:** Run `scripts/test-task.sh` (no --smoke) + the host
  behavior glob test: PASS.
- [ ] **Step 6:** Commit (`feat: cprint lane for attempt/abort (flag
  propagation, gated emission)`).

---

### Task 4: 68k lane codegen (cg68k)

**Files:**
- Modify: `clarusc/cg68k.cla`
- Test: existing goldens/corpus (below) + `testdata/runerr/
  abort_uncaught.*` native halves (asserted later on the deferred lane)

**Interfaces:**
- Consumes: Task 2's IR forms; P1/P2/P4/P6 probe findings; Task 3's
  semantics as the cross-lane oracle.
- Produces: native attempt/abort for Tasks 5/6.

Emission rules (all gated on `lowUsesAbort`; no-feature programs emit
byte-identical binaries):
- Synthesized globals: 1-byte flag + Str255 message, allocated the way
  codegen-synthesized globals already are (P2/P6 report names the
  mechanism; `cgListOobMsgIdx` is the analogous synthesized-literal
  precedent for the message side).
- `IAbort`: evaluate arg → store to message global (existing KStr store
  machinery) → `ST flag` → `BRA` to bail target (statically enclosing
  attempt's handler entry, else function bail label).
- Post-call check in `cgCallFunc`'s result path, ONLY when the callee is
  a user function (P2 predicate) AND `lowUsesAbort`: `TST.B flag` +
  `BNE bail-target`, emitted after arg-pop, before result consumption.
  The object-code paste path's reloc re-emission must be provably
  unaffected (P2) — assert in review that the re-emitted call sites are
  runtime→runtime only.
- Function bail label: null handle-typed result register(s), then the
  existing release-locals + `UNLK`/`RTS` epilogue (P1's site). SP-safe
  from any expression depth per P1.
- `attempt` handler entry: restore SP to statement-boundary level
  (P1's `LEA -frame(A6),SP` shape), clear flag, copy message global →
  binder local.
- Top-level defaults (P4 sites): non-UI startup stub — call `log`'s
  runtime lowering with the message, then the existing quit-1 path; UI
  dispatcher — after each handler call: check flag; if set:
  `SysBeep(30)` (inline trap `0xA9C8`, word 30 on stack), call `alert`'s
  runtime lowering with the message, then quit-1 path.
- Measure/emit: checks flow through the same emission path both passes
  (P6); no size caching may straddle the gate.

- [ ] **Step 1:** Implement per the rules; keep the Task 3 throwaway
  scenario fixture, now compiled with `clarusc emit68k --listing` — eyeball
  the listing for: check sequences after user calls only, bail label
  before epilogue, handler-entry SP restore. Save the listing excerpt to
  the SDD workspace as evidence.
- [ ] **Step 2:** Byte-identity, the load-bearing gate: run the emitui
  golden suite and the `CLARUS_BAKE_FULL=1 go test ./internal/bake -run
  TestBakeFullCorpus -count=1` corpus, plus `TestSelfEmit68k` (clarusc
  source doesn't use the feature yet, so self-emit must be UNCHANGED):
  all PASS with zero churn.
- [ ] **Step 3:** Cross-lane behavior oracle, host-runnable half: the
  Task 3 script scenarios still pass on the C lane; the native halves
  are deferred (Task 8 checklist) — note this in the task report
  explicitly rather than claiming native verification.
- [ ] **Step 4:** Run `scripts/test-task.sh` (no --smoke): PASS.
- [ ] **Step 5:** Commit (`feat: cg68k lane for attempt/abort (SP-safe
  bail, gated checks, top-level defaults)`).

---

### Task 5: Core-suite cases + leak assertion + snapshot regen #1

**Files:**
- Create: `testsuite/core/cases_abort.cla`
- Modify: `testsuite/core/runner.cla` (enum + dispatch + case count —
  follow the file's own hand-maintained convention; `SelfCheck`'s
  casesRun arithmetic must track the new total)
- Create/Modify: the P5-named package gets `TestAbortLeakBaseline` (Go),
  leakgate-style
- Modify: `clarusc/clarusc.c` (snapshot regen #1)

**Interfaces:**
- Consumes: Tasks 3+4 codegen; P5 seam.
- Produces: `CoreTest` cases `AbortCatch`, `AbortDeep`, `AbortNested`,
  `AbortReabort`, `AbortRelease`; a feature-capable committed snapshot
  (the precondition for Task 6's source conversion).

Case semantics (each an ordinary pass/fail-returning Clarus function per
suite convention — read `cases_*.cla` neighbors first):
- `AbortCatch`: helper aborts; caller's attempt catches; msg equals the
  aborted string; code after abort in the helper did not run.
- `AbortDeep`: abort 3 frames down; intermediate frames' post-call code
  provably skipped (each frame sets a side global AFTER its call; assert
  unset).
- `AbortNested`: inner attempt catches; outer handler not entered;
  normal flow resumes after inner handler.
- `AbortReabort`: handler aborts again; outer attempt catches the new
  message.
- `AbortRelease`: middle frame holds a retained `text`/`list` local when
  the abort unwinds through it; case passes if execution continues
  correctly (the numeric leak assertion lives in the Go test, which can
  actually count).
- `TestAbortLeakBaseline` (host): compile+run (via the P5 harness
  pattern) a program that runs the AbortRelease shape in a loop N times;
  assert allocation-count growth per iteration == 0.

- [ ] **Step 1:** Write `cases_abort.cla` + runner wiring. Run the host
  core CLI (CLAUDE.md's compose recipe) with the five case names +
  `all`: PASS. (Native suite boot: deferred, Task 8 checklist.)
- [ ] **Step 2:** Write + run `TestAbortLeakBaseline`: PASS with 0
  growth.
- [ ] **Step 3:** Run `scripts/test-task.sh` (no --smoke): PASS.
- [ ] **Step 4:** Snapshot regen #1: follow `TestSnapshotFixedPoint`'s
  printed Go-free regeneration instructions to a fixed point (expect 1-2
  rounds); then `go test ./internal/selfhost -count=1 -timeout 30m`:
  PASS including `TestSnapshotFixedPoint`.
- [ ] **Step 5:** Commit (`test: attempt/abort core-suite cases + leak
  baseline; build: snapshot regen #1 (feature-capable bootstrap)`).

---

### Task 6: clarusc conversion (~150 sites) + gcCompile catch

**Files:**
- Modify: `clarusc/cg68k.cla` (~100 sites), `clarusc/cprint.cla` (7),
  `clarusc/uiblob.cla` (7), `clarusc/bake.cla` (2), `clarusc/drive.cla`
  (2), `clarusc/lower.cla` (2), `clarusc/macgui.cla` (attempt wrap +
  SysBeep extern)
- Create: `.superpowers/sdd/2026-08-14-attempt-abort/site-classification.md`

**Interfaces:**
- Consumes: the full feature (Tasks 2-5) + regenerated snapshot.
- Produces: a clarusc where compile failures abort, not exit;
  `main.cla` untouched.

Conversion rule per site: `log(MSG)` immediately followed by `quit 1`
becomes `abort(MSG)` (MSG expression moved verbatim into the abort call);
a bare `quit 1` whose message context is a preceding `log` in the same
block follows the same rule; a bare `quit 1` with NO adjacent message
gets `abort("<file>: <short context>")` naming its site. `main.cla` and
`macgui.cla`'s user-chosen quit paths are EXCLUDED. Do NOT convert
`quit 0` or any non-error quit.

`gcCompile` wrap (`clarusc/macgui.cla:507-599`): the body from
`ok = driveCompile(entries, false)` through the final `gcLog(w, "BUILT
...")` moves inside `attempt { ... } aborted msg { ... }`, with the
handler being exactly:

```
gcFlushProgress(w)
gcLog(w, msg)
SysBeep(30)
alert(msg)
gcLiveActive = false
```

(`gcFlushProgress` rebuilds `w.Output.text` from `gcBaseLog` + progress
— prior window content preserved, per spec §4. Verify `gcLiveActive`'s
existing exit-path handling and mirror whatever else every existing
error-return in `gcCompile` does — read those branches first.)
`SysBeep` declared in `macgui.cla` verbatim from `toolbox/osutils.cla:96`:
`external func SysBeep(duration: word) = trap 0xA9C8`.

- [ ] **Step 1:** Mechanical conversion pass, one file at a time,
  `LC_ALL=C sed`-assisted but individually eyeballed (messages move
  verbatim; ~150 judgment calls on bare sites). After each file:
  `scripts/clarus-run.sh` a trivial program (compiler still works).
- [ ] **Step 2:** Write `site-classification.md`: every converted site,
  one line — path:line, message, INTERNAL-INVARIANT vs USER-REACHABLE
  (best judgment + one-clause rationale for USER-REACHABLE ones). This
  is the spec §4 audit deliverable.
- [ ] **Step 3:** `gcCompile` wrap + SysBeep extern per above.
- [ ] **Step 4:** Full host gates: `scripts/test-task.sh` (no --smoke);
  emitui goldens; `CLARUS_BAKE_FULL` corpus; `TestSelfEmit68k` (clarusc
  now USES the feature — self-emit output legitimately changes size;
  the test's own segment-budget assertions are the check);
  `TestErrorGoldens` (host CLI fatal output must be UNCHANGED via the
  §3.5 default — this proves the conversion is behavior-preserving on
  the CLI).
- [ ] **Step 5:** Measure the check overhead now that clarusc itself
  pays it: 10-pair interleaved medians, host self-compile
  (`emit clarusc/main.cla`) and `emit68k clarusc/macgui.cla`, old
  snapshot binary vs new working-tree compiler. Record in the task
  report (spec §7 expects low single digits; materially worse = finding,
  not silent acceptance).
- [ ] **Step 6:** Commit (`refactor: convert ~150 fatal quit sites to
  abort(msg); gcCompile catches with beep+alert+idle`).

---

### Task 7: ClarusC.APPL feedback + icon warning + `out` TEXT stamp (spec §5, §6, §6b)

**Files:**
- Modify: `clarusc/macgui.cla` (gcCompile prologue reorder + pre-compile
  messages), `clarusc/bake.cla` (`bkHashTextFrom` tick), `clarusc/cg68k.cla`
  (icon block `cg68k.cla:11698-11711`), `runtime/clarus/native.cla`
  (natInit `out` FInfo stamp)
- Create: `testdata/cg68k/iconmissing.cla` (or the fixture dir the chosen
  test package conventionally reads — a minimal UI program with
  `icon: "no-such-file.pbm"`)

**Interfaces:**
- Consumes: nothing feature-specific (independent of Tasks 2-6 except
  merge order); Task 6's converted `gcCompile` shape.
- Produces: the spec §5/§6 behavior.

- [ ] **Step 1 (§5):** In `gcCompile`, move the live-progress arming
  block (`gcProgressBuf` reset, `gcBaseLog` capture, `gcTickerRing.clear()`,
  `gcLiveActive = true`, `want68k = true`, `hostPaths`/`wantEmit`)
  ABOVE `bakeMsg = gcResolveBakePath()`; keep the bakeMsg log/append
  behavior itself (order of its two channels unchanged relative to each
  other). Inside `gcResolveBakePath`: before `file.readResource` emit
  `feProgressStep(0, 10, "Loading Baked Runtime")` + `feProgress` with a
  `"[" + dateTimeStr(now()) + "] Loading Baked Runtime"` line; before
  `bkCheckRtbakeHeader` emit the same pair with "Verifying Baked
  Runtime".
- [ ] **Step 2 (§5):** In `bkHashTextFrom`'s loop, add
  `if (i & 0x7FFF) == 0 { driveProgressTick() }`. Confirm host `--rtbake`
  and `--bake-ir` paths still behave (run one of each; ticks are
  cosmetic).
- [ ] **Step 3 (§6):** Icon block: replace both `quit 1` arms with:
  warning on both channels (`log(...)` AND `driveProgress(...)`), message
  `"warning: cannot read app icon " + cgAppIconPath + ": " +
  lastError.message + "; using default icon"` (and the malformed-PBM
  variant `"warning: app icon " + cgAppIconPath + " is not a well-formed
  32x32 P1/P4 PBM; using default icon"`), then `hasIcon = false` and
  fall through — the emitted fork must be byte-identical to the same
  source with no `icon:` property.
- [ ] **Step 4:** Test: host-side Go test (package per Task 3's behavior
  glob or `internal/bake` — implementer picks the least-novel home,
  states it in the report): `clarusc emit68k` of `iconmissing.cla`
  SUCCEEDS, stderr contains the warning, and the output bytes equal an
  emit of the same fixture with the `icon:` line stripped. Also
  re-verify one icon-PRESENT fixture emits unchanged
  (`examples/mandelbrot.cla` from repo root, where the pbm resolves).
- [ ] **Step 5 (§6b):** `out` FInfo stamp in `natInit`
  (`runtime/clarus/native.cla:364-409`): after the successful `NatOpen`,
  stamp `fdType='TEXT'`, `fdCreator='ttxt'` via the file's own direct
  `PBSetFInfoSync` pattern (`native.cla:658-696` — read its full doc
  comment; the no-`PBGetFInfoSync`-first rule is a real-hardware hang
  avoidance, keep it). Differences from that site, per spec §6b:
  stamp UNCONDITIONALLY (also when `NatCreate` returned `dupFNErr` —
  `out` is the runtime's own file, not a user file whose overwrite
  preserves FInfo); explicitly zero `ioFDirIndex` + the full 16-byte
  FInfo region first (`natPb` is `NatNewPtr`, NOT cleared — poke zeros
  before the type/creator pokes); verify `natPbSize` covers the
  FileParam field offsets used and grow it if it only covers IOParam +
  name today (`native.cla:88`'s own sizing comment). Host lanes have no
  FInfo — no host assertion possible; add the emulator-lane check
  ("extract `out` after any native boot, assert `TEXT`/`ttxt` via
  hfsutils `hdir`") to Task 8's deferred checklist. In-task
  verification: `scripts/test-task.sh` still green (behavioral no-op on
  host), plus a listing/byte sanity that only `native.cla`-touching
  outputs changed.
- [ ] **Step 6:** `scripts/test-task.sh` (no --smoke) + emitui goldens:
  PASS. (emitui is C-lane — `native.cla` is a 68k-lane module, so §6b
  must not churn these goldens at all; churn here = a bug.)
- [ ] **Step 7:** Commit (`feat: pre-compile progress + hash liveness
  ticks; icon failures warn with default-icon fallback; out file stamped
  TEXT/ttxt`).

---

### Task 8: Close-out — docs, snapshot regen #2, deferred-lane checklist

**Files:**
- Modify: `docs/clarus-language-reference.md` (normative feature entry:
  surface, semantics, §3.5 defaults, §3.6 callback-boundary note,
  runtime-modules-must-not-use rule), `docs/ROADMAP.md` (phase entry),
  `STATUS.md` (section 0), the spec (annotations where any task narrowed
  a claim), `clarusc/clarusc.c` (regen #2)
- Create: `.superpowers/sdd/2026-08-14-attempt-abort/deferred-gates.md`

- [ ] **Step 1:** Reference entry (reference wins over spec on
  disagreement — write it to match shipped behavior exactly).
- [ ] **Step 2:** Snapshot regen #2 to a Go-free fixed point (the
  converted clarusc now bootstraps itself through the feature);
  full `go test ./internal/selfhost -count=1 -timeout 30m`: PASS.
- [ ] **Step 3:** Full host-side gate sweep: `scripts/test-task.sh` (no
  --smoke), `CLARUS_BAKE_FULL` corpus, emitui goldens, error goldens,
  host core CLI `all`.
- [ ] **Step 4:** Write `deferred-gates.md` — the emulator checklist to
  run THE MOMENT Andrew frees the display, before any merge decision:
  1. `scripts/test-task.sh --smoke` (Mini vMac smoke pair);
  2. full `scripts/test-merge.sh` (T2: native mactest lane incl.
     `TestRunErrOn68k` with the new `abort_uncaught` fixture,
     `TestCoreSuiteGUIOn68k` with the five new cases,
     `TestToolboxSuiteOn68k`);
  3. `TestAbortLeakBaseline`'s native twin if P5 produced one (else
     note host-only, why);
  4. **`TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`, ~55m)** —
     MANDATORY, `bake.cla`/`macgui.cla` changed (standing rule);
  5. the NEW Snow-gated failed-compile-stays-alive test (spec §7): a
     macresident-harness events script compiling a fixture with a
     missing include; assert alert text in trace, NO `##CLARUS-EXIT##`,
     and a subsequent successful compile in the SAME app session.
     (Write the test in this task — host-compiled, committed, marked
     for the deferred run.)
  6. `out` FInfo assertion (spec §6b): after any native boot, extract
     `out`'s catalog info via hfsutils `hdir` and assert type/creator
     `TEXT`/`ttxt` (one-line addition to an existing native-lane
     extraction, or a manual check recorded in the run log).
- [ ] **Step 5:** ROADMAP entry + STATUS section 0 rewrite (phase state,
  deferred gates prominent) + spec annotations.
- [ ] **Step 6:** Commit (`docs: attempt-abort close-out; build:
  snapshot regen #2` — split commits if regen churn is large).

---

## Self-review notes (already applied)

- Spec §3.4 gating is proven three ways (Task 3 Step 4 C-diff, Task 4
  Step 2 corpus/goldens, Task 6 Step 4 error-golden stability).
- Spec §5/§6/§7 test obligations each map to a task step; the four
  emulator-dependent obligations map to Task 8 Step 4's checklist
  instead of silently dropping.
- Bootstrap ordering hazard (snapshot can't compile source using syntax
  it doesn't know) is handled by regen #1 (Task 5) before conversion
  (Task 6) and regen #2 (Task 8) after.
