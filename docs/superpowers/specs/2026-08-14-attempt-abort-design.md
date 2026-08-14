# attempt/abort: recoverable compile failures + ClarusC.APPL feedback hardening

Date: 2026-08-14. Status: DESIGNED (Andrew-approved direction; this doc is
the normative spec). Prior discussion: this session's Snow field test of
`ClarusC.APPL` (object-code-linker tip, `6009c65`).

## 1. Motivation (field evidence)

Andrew's first real interactive session with `ClarusC.APPL` on Snow
(2026-08-14) surfaced three defects:

1. **~7.5 minutes of zero feedback** between choosing a file in the
   "Compile..." dialog and the first Status-bar update. Root cause: ALL of
   `gcCompile`'s prologue runs before the first `driveProgressStage`
   ("Starting Compilation", `drive.cla:1801`) — dominated by
   `gcResolveBakePath()`'s 1.2MB CLIR resource read plus the format-v4
   body-integrity hash (`bkHashTextFrom`, a per-byte loop with a runtime
   call and a 32-bit multiply per byte, on a 16MHz 68020). The live-log
   machinery (`gcLiveActive`) isn't even armed yet when it runs.
2. **A failed compile killed the whole app with no visible error.**
   `examples/mandelbrot.cla` declares `icon: "mandelbrot.pbm"`; the icon
   file wasn't staged on the disk; `cg68Program`'s icon block
   (`cg68k.cla:11704`) does `log(...)` + `quit 1`. On the Mac that's
   ExitToShell: window gone, no alert, no output file. The trace-capture
   `out` file was the only witness.
3. That site is one of **~150 `log(msg)` + `quit 1` aborts in shared
   pipeline code** (~100 in `cg68k.cla`, rest in `bake.cla`, `drive.cla`,
   `cprint.cla`, `lower.cla`, `uiblob.cla`) — every one of them kills
   `ClarusC.APPL` the same way if reached. (`main.cla`'s own ~48 quit
   sites are the host CLI's user-facing arg/usage handling and are NOT
   part of this problem.)

Andrew's requirements (2026-08-14 session, verbatim intent):

- Pre-compile work must show log output and a status message.
- A missing icon file must be a warning + default-icon fallback, not a
  compile failure.
- A failure during a compile must NOT exit the app: it must print an
  error in the log, beep, show an alert, and abort the compilation,
  leaving the Log window's content intact. Exits are legitimate only when
  the user chooses to quit.
- Mechanism (Andrew's own proposal, adopted after comparing against a
  longjmp-style unwind): a global `aborting` flag set by `abort()`, with
  generated code checking the flag after calls and returning up the chain
  — cooperative error propagation, Swift-`throws`-style, so every frame
  exits through its normal epilogue and **ARC releases run** (no leaks,
  unlike longjmp).

## 2. Scope

Three deliverables, one phase:

- **A. Language feature `attempt`/`aborted` + `abort(msg)`** — cooperative
  flag-propagated unwinding, both lanes (cg68k + cprint), reference
  chapter, tests. (§3)
- **B. clarusc conversion** — the ~150 pipeline `log`+`quit 1` sites
  become `abort(msg)`; `gcCompile` catches with log + beep + alert +
  return-to-idle. (§4)
- **C. ClarusC.APPL feedback** — pre-compile status/log lines + hash-loop
  liveness ticks (§5); missing-icon warning + default-icon fallback (§6).

## 3. The `attempt`/`abort` language feature

### 3.1 Surface

Two new reserved keywords (`attempt`, `aborted`) and one new builtin
statement (`abort`). Corpus scan 2026-08-14: no `.cla` file in the repo
uses any of the three as an identifier (comments only), so reserving them
breaks nothing.

```
attempt {
    // statements; arbitrarily deep calls
} aborted msg {
    // runs iff abort(...) fired dynamically below; msg: string
}

abort(expr)   // expr: string; statement, like alert(expr)
```

- `attempt` REQUIRES the `aborted` block (no bare attempt). The binder
  identifier (`msg` above) is a fresh `string` local scoped to the
  `aborted` block; the usual shadowing rules apply.
- `abort(expr)` is a statement, valid anywhere a statement is (function
  bodies, handlers, the `aborted` block itself). Checker rule: the
  argument must be `string`-typed (same coercions as `alert`).
- Nesting is allowed. The dynamically innermost `attempt` catches.
- `return` inside an `attempt` body is an ordinary return (the "mark" is
  compile-time control flow — there is nothing to pop).
- Re-abort inside an `aborted` block propagates outward to the next
  enclosing `attempt` (or the top-level default).

### 3.2 Semantics

`abort(msg)`:

1. stores `msg` in a runtime global (`Str255`-sized) and sets a global
   one-byte `aborting` flag;
2. returns through its own function's NORMAL epilogue (all ARC releases
   for that frame run);
3. every call site in an abort-enabled program checks the flag
   immediately after the callee returns, BEFORE the return value is
   consumed: if set, null any handle-typed result register, then jump to
   the enclosing function's epilogue (releases run) — or, if the call
   site is statically inside an `attempt` body, jump to that `attempt`'s
   `aborted` block instead, clearing the flag and binding the stored
   message;
4. propagation therefore walks the dynamic call chain frame by frame,
   running every frame's releases, until an `attempt` catches it or it
   reaches the synthesized top level (§3.5).

Because `abort` is itself an ordinary call followed by the same check,
an `abort` written directly inside an `attempt` body is caught by that
`attempt` — no special case.

**No runtime mark stack exists.** The entire runtime state is one flag
byte + one message global. "Nearest enclosing attempt" is resolved
per-call-site at compile time (the statically enclosing `attempt` of the
call site in the frame the propagation is currently unwinding — which is
exactly the dynamically innermost mark).

### 3.3 Lowering

- **Check placement:** after every call to a USER-defined function (and
  after `abort` itself). Calls to runtime functions and externs/traps
  need NO check — the runtime never aborts (§3.7) — which roughly halves
  the check count in clarusc and keeps baked runtime IR (CLIR) untouched
  and valid.
- **68k lane:** flag + message are runtime globals; the check is
  `TST.B flag` + `BNE` to a per-function bail label (nulls handle-typed
  result regs, falls into the epilogue) or to the `aborted` block's
  entry (which clears the flag and copies the message into the binder
  local). ~6-10 bytes per checked call site.
- **C lane (cprint):** identical semantics — a global flag/message in
  `rt.c`-adjacent generated code, `if (rt_aborting) goto bail;` after
  each checked call, reusing cprint's existing release-before-return
  discipline for the bail path. No setjmp.
- **Synthesized top level:** the non-UI startup stub (after
  `App.startCLI` returns) and the synthesized UI event dispatcher (after
  each handler call) get one check each, implementing the §3.5 defaults.
  Both are per-program synthesized code, so this is gateable (§3.4).

### 3.4 Emission gating and byte-identity

If the post-expansion program contains no `attempt` and no `abort`,
codegen emits ZERO new instructions and no new globals — output is
byte-identical to today, on both lanes. Existing goldens (emitui, cg68k
fixtures, frozen scenarios) plus the full-corpus byte-identity gate are
the proof. Only programs using the feature pay for it; today that is
clarusc itself and the new test fixtures.

Runtime modules (`runtime/clarus/*.cla`) MUST NOT use `attempt`/`abort`
(checker-enforced is not required; convention + review is enough for
now, recorded here). This keeps baked runtime function bodies (CLIR v6
object code) valid unmodified: no checks are ever needed inside runtime
code.

### 3.5 Top-level default (uncaught abort)

- Non-UI program (host CLI shape): write the message on the same channel
  `log()` uses, then exit with code 1 — byte-identical to today's
  `log(msg)` + `quit 1` behavior. This is why the ~150-site conversion
  does not change host CLI behavior or error goldens at all.
- UI program: `SysBeep`, `alert(msg)`, then quit with code 1. (This
  covers Andrew's "any remaining exit must beep and alert first" — e.g.
  an abort raised outside any `attempt` in a UI app.)

### 3.6 External-callback boundary rule (documentation note)

If `abort` fires inside a `callback` function invoked by the Toolbox,
propagation pauses at the glue boundary: the callback returns a default
value to the Toolbox, which completes its own call normally; propagation
resumes at the first checked call site after the original external call
returns. Deferred but safe. The compile pipeline contains no such
callbacks; this is a reference-manual note, not new machinery.

### 3.7 Relationship to runtime panics (out of scope)

`rtPanic` (list bounds, etc.) remains fatal and does NOT route through
`attempt`. A panic can fire mid-runtime-operation with runtime-internal
state half-mutated; recovering there is not safe to promise. Since the
param-abi fix, native panics display their real message before exiting.
Routing panics through the nearest `attempt` is recorded as a possible
future extension, deliberately not in this phase.

### 3.8 Reference & docs

`docs/clarus-language-reference.md` gains the feature's normative entry
(surface, semantics, the §3.5 defaults, the §3.6 boundary note, and the
"runtime modules must not use it" rule). The reference wins over this
spec if they ever disagree.

## 4. clarusc conversion (`abort` at the ~150 sites, catch in `gcCompile`)

- Every `log(msg)` + `quit 1` pair (and the handful of bare `quit 1`
  with adjacent context) in `cg68k.cla`, `bake.cla`, `drive.cla`,
  `cprint.cla`, `lower.cla`, `uiblob.cla` becomes `abort(msg)` with the
  site's existing message text. `main.cla`'s CLI quit sites stay.
- During conversion, each site gets a quick classification pass
  (internal invariant vs user-input-reachable); the classification lands
  in the task report. User-reachable sites STILL become `abort` (that is
  the point — they now abort the compile, not the app); the
  classification is information for future per-site improvements (better
  diagnostics), not a gate.
- `gcCompile` (`macgui.cla`) wraps its pipeline body — `driveCompile`
  through `driveEmit68kFork` through `file.writeRes` — in `attempt`. The
  `aborted msg` block: `gcFlushProgress(w)` (which REBUILDS
  `w.Output.text` from `gcBaseLog` + accumulated progress — prior
  window content is preserved, nothing is cleared), `gcLog(w, msg)`,
  `SysBeep(30)`, `alert(msg)`, `gcLiveActive = false`, return to idle.
  The next Compile... action proceeds normally (per-compile state is
  fully reset at `gcCompile`'s top already).
- `SysBeep` comes from `toolbox/osutils.cla`'s proven extern
  (`trap 0xA9C8`); `macgui.cla` declares it the same way (or includes
  the catalog file — implementer's choice, cookbook conventions apply).
- Host CLI (`main.cla`): NO changes needed. It never enters an
  `attempt`, so every converted site hits the §3.5 non-UI default =
  today's exact output + exit code. Error goldens must stay green
  unchanged; that is the acceptance proof for this claim.

## 5. Pre-compile feedback in `gcCompile` (Andrew item 1)

- `gcCompile`'s live-progress arming (`gcProgressBuf` reset, `gcBaseLog`
  capture, ticker clear, `gcLiveActive = true`, `want68k = true`) moves
  ABOVE the `gcResolveBakePath()` call.
- New pre-compile stage messages, both channels (Status bar via
  `feProgressStep`, log via `feProgress` with the `driveProgress`
  timestamp format). They deliberately use step 0 of the fixed total
  (`drvFixedSteps` = 10) since `driveCompile` resets the stage counter
  at its own top (`drive.cla:1799`):
  - before `file.readResource`: `feProgressStep(0, 10, "Loading Baked
    Runtime")` + a timestamped log line;
  - before `bkCheckRtbakeHeader`: `feProgressStep(0, 10, "Verifying
    Baked Runtime")` + a timestamped log line.
- `bkHashTextFrom` gains a liveness pulse: `driveProgressTick()` once
  every 32KB of hashed input (`(i & 0x7FFF) == 0` shape). macgui
  throttles ticks by TickCount already; the host CLI's tick channel is
  the existing spinner. This makes the long hash visibly alive on the
  Status bar's spinner.
- The CLFS-source fallback path and host `--rtbake` path get the same
  messages for free (same seams). No caching of the acceptance verdict
  across compiles — the "install re-parses from scratch every call"
  discipline stands; making repeat compiles skip re-verification is
  recorded as deferred (§8).

## 6. Missing icon = warning + default icon (Andrew item 2)

In `cg68Program`'s icon block (`cg68k.cla:11698-11711`), both failure
arms (unreadable file; malformed PBM) stop failing the compile:

- emit a warning on BOTH channels — `log(...)` (host stderr / native
  trace log) and `driveProgress(...)` (Log window + CLI progress):
  `warning: cannot read app icon PATH: REASON; using default icon` (and
  the malformed-PBM variant);
- proceed exactly as if no `icon:` had been declared (`hasIcon = false`
  path — generic Finder application icon, the path every icon-less app
  already takes).

Both lanes, same behavior. A compile with a missing icon now succeeds
and writes its output; byte-wise its fork is identical to compiling the
same source with no `icon:` property.

## 7. Testing & gates

- **Feature tests (core suite, host + native):** new `CoreTest` cases —
  basic catch (abort in a callee, caught one frame up); deep
  propagation (several frames); nesting (inner catches, outer clean);
  re-abort from an `aborted` block; abort with retained handle locals in
  intermediate frames (exercises the release-on-unwind claim).
- **Leak proof:** a host-lane check in the `DoubleCompile`/leak-gate
  style: run an abort-through-retained-frames scenario, assert
  allocation-count return-to-baseline. (This is the load-bearing
  advantage over longjmp; it gets its own assertion.)
- **Uncaught-abort defaults:** a `testdata/runerr`-style fixture
  asserting the non-UI default's message + exit code on both lanes
  (native boot via `TestRunErrOn68k`, host via behavior goldens).
- **Byte-identity:** full-corpus gate + all existing goldens prove the
  §3.4 no-feature gating. `TestSelfEmit68k` proves the converted clarusc
  still fits its segment budgets.
- **Perf snapshot:** 10-pair medians of host self-compile and
  `emit68k` of frozen `macgui.cla`, before/after conversion, recorded in
  the task report (expected: low-single-digit % from the checks; if it
  is materially worse, that is a finding to bring back, not silently
  accept).
- **GUI behavior:** `TestToolboxSuiteOn68k`/suite GUI paths stay green;
  plus a scripted-events check that a failing compile (missing include,
  e.g.) leaves ClarusC.APPL alive (alert visible in trace, no
  `##CLARUS-EXIT## 1`) — the exact field failure, automated. This boots
  ClarusC.APPL, so it lives in the Snow-gated macresident harness
  (`CLARUS_SNOW_TESTS=1`), same gate as the standing bake-path re-run.
- **Gates:** T1 per task; T2 before merge; snapshot regen
  (`clarusc/clarusc.c`) to a Go-free fixed point; **standing rule: the
  full `TestClarusCBakePathOnSnow` re-run** (`CLARUS_SNOW_TESTS=1`) —
  REQUIRED because `bake.cla` and `macgui.cla` change. NOTE: Snow (the
  emulator) is currently occupied by Andrew's manual testing; all
  emulator-lane gates (T1 `--smoke`, T2 native lane, Snow re-run) are
  deferred until the emulator is free. Host-side gates run per task as
  usual.

## 8. Deferred / out of scope

- Reducing the CLIR verification cost itself (the 7.5 minutes): hashing
  once per process / caching the acceptance verdict across compiles in
  one `ClarusC.APPL` session. Deliberately out — it changes the
  "install re-parses from scratch every call" discipline; this phase
  makes the cost visible and attributable instead.
- Routing runtime panics (`rtPanic`) through `attempt` (§3.7).
- Checker enforcement of the "runtime modules must not use
  attempt/abort" rule (convention + review for now).
- Per-site diagnostic quality upgrades for user-reachable aborts (the
  §4 classification is the input for that future work).
- An interprocedural "can this call abort?" analysis to shrink check
  count (whole-program, no closures — cheap fixpoint) — only if the §7
  perf snapshot shows the naive scheme actually hurts.
