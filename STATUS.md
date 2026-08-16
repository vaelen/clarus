# Session status — 2026-08-16 (serial-connection: all gates GREEN on tip 0907364; two Snow finals pending; merge on Andrew's word)

Handoff summary. **The `serial-connection` phase is IMPLEMENTATION DONE
and gated — T1 throughout every task, T2 PASS end-to-end (268s) on the
branch tip, and the echo acceptance app has PASSED on Snow hardware 4
times across development. The branch is NOT merged — merge is Andrew's
call, and two hardware finals still need the controller to run them
post-final-review (see §2).** The local checkout works on `serial-connection`
directly (no-worktree convention), 16 commits ahead of `main` at `f8c15a1`.

## 0. START HERE next session

**Remaining before merge-eligible:**
1. Controller runs the two Snow finals (§2) — not this phase's task-8
   job by design.
2. Andrew's word to merge (fast-forward `f8c15a1..0907364`).

No further implementation work is expected. If Andrew wants the next
roadmap item picked up, it's AppleTalk (`docs/ROADMAP.md`'s "Next:
language usability" list, item 3 — serial is now marked done).

## 1. What landed

The reference's fenced `connection` type is real end to end, with the
Macintosh serial ports as its first working transport
(`conn.open(serial "modem:9600")`), event-driven (`opened`/`received`/
`closed`/`failed`), on both lanes:

- **Toolbox catalog**: `toolbox/devices.cla` + `toolbox/serial.cla` —
  Device Manager + Serial Driver, hardware-proved by the toolbox suite's
  `SerialOpenWrite` case (opens `.AOut`/`.AIn`, configures 9600-8N1,
  exercises the load-bearing `SerSetBuf` call, writes/reads real bytes).
- **Language surface**: `serial "modem:9600"` / `"printer:9600"` parses
  and checks; `docs/clarus-language-reference.md`'s "Connections" +
  "Serial" sections (Ch12) are normative and verified this task to still
  match shipped behavior exactly (baud table, env var names/shapes, 8KB
  buffer, closed-never-fires — no drift, no edit needed).
- **Runtime**: a shared `conn.cla` dispatch layer + host TCP glue
  (`conn_c.cla`, dev-lane substitute for real hardware via
  `CLARUS_SERIAL_MODEM`/`CLARUS_SERIAL_PRINTER` env vars) and a native
  SCC/Serial-Driver lane (`conn_68k.cla`), both reachable through the
  same `connection` methods and events.
- **Acceptance**: `examples/serialecho.cla` — a small UI program that
  opens the modem port at 9600 baud, echoes every byte back, and quits
  on three consecutive `Q` bytes — passed on real Snow (Mac II) hardware
  4 times across the phase (most recent 3 consecutive clean runs:
  dial ~253ms, READY ~26.7s, QQQ ~28.88s, total ~34.1s wall clock,
  remarkably consistent run to run).

**Controller rulings this phase (reflected here, not re-litigated):**
- **Opened-at-bind semantics**: `opened` fires on open success, which
  for a pre-peer TCP-listen slot means bind succeeded, not that a peer
  has connected — correct by spec, because a raw serial line has no
  peer-arrival signal either (carrier detect is out of scope). The
  companion fix: a write to a still-listening slot with no accepted peer
  succeeds and discards, mirroring an unattached physical serial line
  rather than failing.
- **Contract-vs-environment error split**: `send` on a never-opened or
  already-closed connection is a runtime error (program bug); a bad port
  spec or driver I/O error arrives as `failed(err)` (environmental).
- **UiConnPump lane seam**: verdicted sound+discoverable — the cprint/
  Retro68 Mac lane's no-op pump stub fails loud (a link error) in every
  reachable bad configuration, never silently; that lane never actually
  needs connection support (suite/scenario programs don't use them), so
  no real stub implementation was required by construction.

**Notable bugs found and fixed by review** (none reachable by any gate
before a human/opus review caught them — recorded so the next serial/
network phase knows where to look first):
- **SIGPIPE crash risk** (Task 4 review): a peer hangup mid-write to the
  host TCP glue killed the process (no `SIG_IGN`/`SO_NOSIGPIPE`
  anywhere). Fixed: ignore SIGPIPE, surface write failures as
  `failed(err)` instead of a process death.
- **`KErr` callee-side ABI gap** (Task 7 review, Critical): `cgPushArgs`/
  `cgArgSlotSize` had been widened for by-address `error` params, but
  `frameIsRef` at cg68k.cla:5030 hadn't — a native `on conn.failed(err:
  error)` handler read stack garbage for `err.message`. Unexercised by
  every existing gate (nothing called a native `failed(err)` handler);
  fixed with a real native test that fires `failed(err)` and asserts the
  message text (`TestConnFailedHandlerOn68k`).
- **Listen-mode write semantics** (Task 5 review): `rt_ext_ConnHWrite`
  failed outright when listening with no accepted peer yet, instead of
  accepting-and-discarding like a real unattached serial line — see the
  opened-at-bind ruling above.
- **Pump abort-awareness** (Task 5 review, Important): the emitted host
  pump loop never tested `clar_aborting`, so an uncaught abort while a
  connection was open was silently swallowed instead of following
  Ch5's default (log+exit 1). Fixed: the loop condition became
  `while (!clar_aborting && clar_fn_rtConnAlive())`.

## 2. Two controller-run finals — NOT run by this task, by design

- **`TestClarusCBakePathOnSnow`** (`CLARUS_SNOW_TESTS=1`, ~55m, standing
  rule) — the runtime source manifest changed this phase (new `conn*.cla`
  + `toolbox/{devices,serial}.cla` modules are now part of every native
  build's include set), so the standing rule fires: re-run it after any
  change reachable from `ClarusC.APPL`'s own bake path. Last known-PASS
  predates this phase.
- **A final `TestSerialEchoOnSnow`** at the true branch tip (`0907364`,
  post snapshot-regen + bake-fix) — every prior Snow PASS in this phase
  was against an earlier commit; the tip has moved since (the snapshot
  regen and the bake file-list fix, neither of which touch runtime or
  native codegen, but the standing discipline is a fresh run at the true
  tip before merge-eligible).

Both are the controller's to run post-final-review; then the phase is
merge-eligible on Andrew's word.

## 3. Gate results (this task, tip `0907364`)

- **Snapshot regen** (`clarusc/clarusc.c`, Go-free per
  `internal/selfhost/fixedpoint_test.go`'s own instructions): converged
  and re-verified twice — 4,742,723 bytes (+30,924 over the prior
  snapshot), byte-identical across three independent stage-1/stage-2
  builds. Makes `serial` syntax parseable by the committed snapshot for
  the first time. Commit `5203368`.
- **`go test ./internal/selfhost -count=1 -timeout 30m`**: PASS, 117.4s.
  Includes `TestSnapshotFixedPoint`, `TestClarusModules` (8/8),
  `TestErrorGoldens` (17/17, incl. `conn_serial_badarg.cla`),
  `TestBehaviorGoldens`/`TestCrossGenDifferential` (incl.
  `conn_send_closed.cla`, the expected red→green flip — the golden file
  itself was never edited, only its runtime status changed once `serial`
  became parseable), `TestSnapshotBuilds` (3/3).
- **`scripts/test-merge.sh` (T2)** — run TWICE this task, honestly:
  - **Run 1 (tip `5203368`, before the bake fix): RED.** Everything
    through the native-lane Mac gate passed clean (T1 body 24s,
    `internal/selfhost` 88s, `CLARUS_MAC_TESTS=1 go test ./internal/mactest`
    133s — all 4 frozen golden scenarios, codegen tests, event-loop tick
    test, and both suites' native GUI boots including
    `TestToolboxSuiteOn68k`). T2's last leg failed:
    `CLARUS_BAKE_FULL=1 go test ./internal/bake` —
    `TestBakeFullCorpusSuiteToolbox` couldn't compile
    (`testsuite/toolbox/runner.cla:452:40: undefined: caseSerialOpenWrite`).
    Root cause: `internal/bake/bakeidentity_test.go`'s
    `toolboxSuiteGUIFiles` file list (a hand-maintained twin of
    `internal/mactest/coresuite_test.go`'s `toolboxFiles`) was never
    updated when Task 2 added `toolbox/devices.cla`/`toolbox/serial.cla`/
    `testsuite/toolbox/cases_serial.cla` — undetected until now because
    `CLARUS_BAKE_FULL=1` isn't part of T1, only T2's last leg, and this
    was the first T2 run on the branch since Task 2 landed. Full log:
    `.superpowers/sdd/2026-08-15-serial-connection/task8-t2-run1-red.log`.
  - **Fix**: commit `0907364` adds the same 3 entries at the same
    relative positions to `toolboxSuiteGUIFiles`, making the two lists
    identical in content and order.
  - **Run 2 (tip `0907364`, after the fix): CLEAN.** `test-merge.sh:
    PASS in 268s` — T1 body 24s, `internal/selfhost` 105s, native-lane
    `internal/mactest` 133s, `internal/bake` full-corpus gate 6s. Zero
    FAILs. Log: `.superpowers/sdd/2026-08-15-serial-connection/task8-t2.log`.
- **Manual-demo sanity check**: `scripts/build-68k.sh SerialEcho
  examples/serialecho.cla` builds clean (`build-68k/SerialEcho/SerialEcho.bin`,
  114KB) — confirms both `scripts/build-68k.sh` and (transitively)
  `scripts/clarus-run.sh` can build serial programs directly now that the
  snapshot parses `serial` syntax.

## 4. Manual-demo recipe (Andrew's own convention, port 1984)

```sh
scripts/build-68k.sh SerialEcho examples/serialecho.cla
snow/Snow snow/Clarus.snoww --serial-bridge-a tcp:1984
```

Then, once Snow has booted and `SerialEcho.bin` is running on the guest
(drag/launch as usual on the Snow disk image): connect a terminal —
`nc localhost 1984` — and type at it. Every byte typed echoes back
(binary-safe, no CR/LF translation); typing `QQQ` (three consecutive `Q`
bytes, can be split across sends) quits the guest app.

## 5. Prior phases (all merged; recap pointers only)

- **clir-load-perf** (CLIR load-path perf: header re-verify skip, once-
  per-session parse memo, bulk `text` range-read methods) — merged
  2026-08-15/16 (`42c7265` → `main` at `f8c15a1`, via the same
  fast-forward-on-request convention this phase now waits on). Both
  Snow gates (`TestClarusCBakePathOnSnow` 1206s,
  `TestMacResidentFailedCompileStaysAliveOnSnow` 1201s) PASSED on final
  tip `1d88846`. Full detail: HISTORY's `clir-load-perf` entry.
- **attempt-abort** (`attempt { } aborted msg { }` + `abort(msg)`,
  cooperative unwinding, both lanes) — merged 2026-08-15. Full detail:
  HISTORY's `attempt-abort` entry.
- **object-code-linker** (stage 3.5, CLIR v6 baked object code) — merged
  2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Standing rules (unchanged):** re-run `TestClarusCBakePathOnSnow`
(`CLARUS_SNOW_TESTS=1`) after ANY change to `clarusc/bake.cla`,
`clarusc/macgui.cla`, OR (as of this phase) the native runtime source
manifest (new `.cla` modules that join every native build's include set)
— it is the only proof of the `ClarusC.APPL` default bake path (fires
for serial-connection; NOT yet satisfied — see §2 above).
`internal/selfhost` always gets `-count=1 -timeout 30m`. Merge only on
Andrew's request; main stays green.
