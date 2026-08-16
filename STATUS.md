# Session status — 2026-08-16 (serial-connection: all gates GREEN on the branch tip, post final-review fix wave; two Snow finals pending; merge on Andrew's word)

Handoff summary. **The `serial-connection` phase is IMPLEMENTATION DONE
and gated — T1 throughout every task, T2 PASS end-to-end on the
branch tip (both Task 8's own run and the final-review fix wave's own
re-run, §3/§3b), and the echo acceptance app has PASSED on Snow hardware 4
times across development. The branch is NOT merged — merge is Andrew's
call, and two hardware finals still need the controller to run them
post-final-review (see §2), now against the fix wave's own tip.** The
local checkout works on `serial-connection` directly (no-worktree
convention), 19 commits ahead of `main` at `f8c15a1`.

## 0. START HERE next session

**Remaining before merge-eligible:**
1. Controller runs the two Snow finals (§2) — not this phase's task-8
   job by design.
2. Andrew's word to merge (fast-forward `f8c15a1..<branch tip>`).

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
- **Unbounded pump drain / livelock** (final whole-branch review,
  Important 1): `rtConnPump`'s received-drain loop re-queried
  `rtConnDevAvail(i)` every iteration, so a sender producing bytes at
  least as fast as the drain (2 traps/byte natively) never let it exit —
  livelock of the whole event loop at the reference's own documented top
  rates. Fixed: snapshot the count once (`n = rtConnDevAvail(i)`) before
  the drain loop; bytes arriving during the drain wait for the next pass,
  matching "fires once per event-loop pass" exactly.
- **Name-keyed connection slot lookup** (final whole-branch review,
  Important 2): `lowConnSlotOf` was keyed by the receiver's source NAME;
  a local `var conn: connection` shadowing a same-named global silently
  operated the GLOBAL's slot instead of hitting the spec-mandated
  not-yet-implemented rejection. The straightforward-looking fix
  (`scopeLookup`-based symbol resolution, as `lowTopHandler` already
  uses) turned out NOT to work: `curScope` is pinned at the program's
  TOP scope for the whole lowering pass (check.cla's block/function
  scopes are pushed and popped during CHECKING only, and don't survive
  into lowering — see `lowConnSlotOf`'s own doc comment), so a
  `scopeLookup` from inside a function body can never see that
  function's own locals and just re-resolves to the global every time,
  reproducing the exact same bug through a different path. The real fix
  uses `lowIsLocal` (lowering's own local-scope tracker, the same
  mechanism `isBareWindowTitleIdent`/`lowIdent` already use for this
  exact kind of shadow guard): a receiver identifier that `lowIsLocal`
  reports as locally shadowed is excluded from the connection-slot
  lookup regardless of the name collision. Regression pin:
  `internal/conntest`'s `TestConnShadowedLocalRejected`
  (`testdata/conn_shadow_local.cla`).
- **Unguarded `SerNewPtr` in `rtConnSendText`** (final whole-branch
  review, Fix 5 — same treatment as Task 6's `SerSetBuf` guard): a null
  return from the per-send scratch-buffer allocation sent the pokeb
  marshal loop writing at low memory. Fixed: null → stage the slot's
  pending-`failed` with `-108` (keep-first, matching the write-error
  path's own discipline) and return without writing.

## 2. Two controller-run finals — NOT run by this task, by design

- **`TestClarusCBakePathOnSnow`** (`CLARUS_SNOW_TESTS=1`, ~55m, standing
  rule) — the runtime source manifest changed this phase (new `conn*.cla`
  + `toolbox/{devices,serial}.cla` modules are now part of every native
  build's include set), so the standing rule fires: re-run it after any
  change reachable from `ClarusC.APPL`'s own bake path. Last known-PASS
  predates this phase.
- **A final `TestSerialEchoOnSnow`** at the true branch tip — every prior
  Snow PASS in this phase was against an earlier commit, and the tip has
  moved twice since: Task 8's own snapshot-regen + bake-fix (tip
  `0907364`), and now the final-review fix wave (§3b) on top of that
  (`rtConnPump`'s drain loop and `rtConnSendText`'s guard DO touch
  runtime/native codegen this time, unlike Task 8's own docs-only move —
  a fresh run at the true tip is not optional this round).

Both are the controller's to run post-final-review; then the phase is
merge-eligible on Andrew's word.

## 3. Gate results (Task 8, tip `0907364` — historical)

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

## 3b. Final fix-wave gate re-run (this wave, branch tip)

The final whole-branch review returned "merge with fixes" (2 Important +
STATUS numeric slips + 3 rt_serial_test.c comment checks + an unguarded
`SerNewPtr` consistency fix + a `func f(): error` failure-mode probe +
2 TODO additions). All landed in one wave; full detail:
`.superpowers/sdd/2026-08-15-serial-connection/final-fixwave-report.md`.

- **Code fixes**: `rtConnPump`'s drain-loop snapshot (Important 1),
  `lowConnMethod`'s `lowIsLocal`-guarded receiver lookup (Important 2,
  plus the `TestConnShadowedLocalRejected` regression pin closing Task 5's
  own deferred fixture gap), `rtConnSendText`'s `SerNewPtr` null guard
  (Fix 5) — see §1's "Notable bugs found and fixed by review" above for
  the full account of each, including the `scopeLookup`-doesn't-work
  structural surprise Important 2's fix uncovered.
- **`go test ./internal/conntest -count=1 -v -timeout 5m`**: PASS, all 5
  subtests (`TestConnectMode`, `TestListenMode`, `TestEnvUnsetFailedPath`,
  `TestAbortDuringPump`, `TestConnShadowedLocalRejected`) — the echo
  suite's burst semantics survive Fix 1's drain-loop change intact.
- **`testdata/cg68k/*.s` rebless** (`CLARUS_CG68K_BLESS=1`): 52 golden
  files churn (every native fixture carries `rtConnPump` unconditionally
  — the very TODO item this wave also records, §7 below). Normalization
  proof: label/A5-offset/A6-offset renumbering stripped from both old and
  new `arith.s`, then `arithDemo` (a pure user-code function, nothing to
  do with connections) extracted and diffed in isolation — byte-identical
  except the `(JT slot N)` comment number, same taxonomy Task 6's own
  rebless proof used. Smaller fixtures' full diffs (e.g.
  `arr_whole_assign.s`) are, in their entirety, exactly the two new `n`/
  `j` locals and the snapshot-based loop shape — nothing else.
- **Snapshot regen** (`clarusc/clarusc.c`, Go-free): converged and
  re-verified twice, 4,742,784 bytes (+61 over Task 8's 4,742,723 —
  `lowConnMethod`'s doc-comment/guard growth), byte-identical across two
  independent stage-1/stage-2 builds; `TestSnapshotFixedPoint` itself
  also reports gen1 == gen2 and matches the committed snapshot.
- **`go test ./internal/selfhost -count=1 -timeout 30m`**: PASS, 104s.
- **`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run
  'TestToolboxSuiteOn68k|TestConnFailedHandlerOn68k|TestSmokeBounceOn68k'
  -count=1 -timeout 20m`**: PASS, 52.7s — all 30 toolbox-suite cases
  (incl. `SerialOpenWrite`/`SelfCheck`), the native `failed(err)`
  regression pin, and the bounce smoke scenario.
- **`scripts/test-merge.sh`**: PASS, 265s — T1 body 22s, `internal/selfhost`
  104s, native-lane `internal/mactest` (full, no `-run` filter) 133s,
  `internal/bake` full-corpus gate (`CLARUS_BAKE_FULL=1`) 6s. Zero FAILs.
  (An earlier attempt was killed mid-`mactest` by an operator `pkill`
  while investigating a tool-harness auto-background edge case, not a
  test failure; the clean rerun immediately after is the one recorded
  here — foreground throughout, no backgrounding used deliberately.)
- **Probe 6** (`func f(): error` failure mode, `docs/TODO.md`'s
  `cgRetNeedsHidden` entry): LOUD, not silent. Native lane
  (`clarusc emit68k`) aborts at codegen time (`cg68k: cgExpr: EVarRef
  non-scalar (str/rec/arr) reached in value context`, exit 1) the moment
  a `return e`-shaped body is lowered; host lane (`clarusc emit` + `cc`)
  is unaffected (`cgRetNeedsHidden` is `cg68k.cla`-only — the C printer
  lane returns a plain C struct with no analogous hidden-pointer
  bookkeeping). No code change (loud beats silent, per the probe's own
  brief); `docs/TODO.md` updated with the reproduction; throwaway
  fixture discarded (kept only in scratch, not committed).
- **TODO additions**: the native-binary size-growth lever
  (`cg68AddRoots`'s unconditional `nat*` rooting keeps the conn runtime
  in every native binary; narrowing lever recorded) and the missing
  host-lane emitted-C golden for `cpEmitMain`'s abort-aware pump loop
  (behaviorally covered by `TestAbortDuringPump`, no byte-level
  tripwire).

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
