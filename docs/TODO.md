# Clarus TODO — recorded follow-ups, not yet scheduled

Condensed from completed phases' deferred/debt lists. The verbatim
context for every item is the originating phase's entry in
`docs/HISTORY.md` (named in parentheses) and that phase's
`.superpowers/sdd/<date>-<phase>/` ledger. Items here are recorded, not
committed — scheduling is `docs/ROADMAP.md`'s job.

## Language features (candidates)

- **`yield`/cancel statement** — event-loop tie-in so long computations
  (mandelbrot-class) pump events and can be cancelled; spec questions
  recorded in memory, unscheduled.
- **Reciprocal packers for the bulk range-readers** (clir-load-perf;
  Andrew 2026-08-15): the phase added only the READ half
  (`intAt`/`stringAt`/`textAt`/`hashStep`). Write half sketch:
  `t.appendPackedInt(i)` / `t.appendPackedString(s)` mutator shapes (a
  max-payload packed string overflows `string` under both prefix
  conventions, so return-`string` forms don't work). Note `stringAt` is
  now 1-byte Pascal-prefix; the CLIR pool's wire format stays 4-byte BE
  (read via `bkGetStr`'s `stringAt(pos + 3)` hop), so a pool-targeting
  packer still writes the 4-byte shape.
- **`text + char` concatenation** does not exist (append accepts char;
  `+` does not). Deliberate; revisit if it keeps surprising.
- **Launch-an-application-from-Clarus** (ui-scenario-retirement, Andrew
  2026-08-05): needed before an on-Mac suite can drive the example apps.
  System 6 `_Launch` REPLACES the running app, so this needs its own
  design (sub-launch conventions, result handoff, suite chaining, or
  System 7/MultiFinder gating). The 4 frozen golden scenarios' eventual
  fate rides on this.
- **Per-window menu bars / menu teardown** (Andrew 2026-08-05): suite
  cases install menus they never tear down; a multi-window app may want
  its own menu set swapped on activate. Needs a design.
- **Parking lot** (design spec §14 + later decisions): HTTP layer,
  UDP/DDP, auto-generated forms, float/SANE, case-insensitive maps,
  handle-backed map values, printing, color QuickDraw, labeled break,
  const arithmetic, `switch` on text, substring/indexOf as library code.

### Serial/connection phase (2026-08-16)

- **No carrier detect** — `rtConnDevGone` (`runtime/clarus/conn_68k.cla:253`)
  always returns false; `closed` never fires for a native serial
  connection (deliberate, spec-out-of-scope this phase). Revisit with
  real modem control lines (RING/carrier) if a future BBS-target phase
  needs it.

## Compiler correctness / diagnostics

- **Lexer diagnostic quality** (decided 2026-07-23): a bad escape in a
  double-quoted string (`"a\qb"`) should report `invalid escape
  sequence`, not `unterminated string literal`, and the eager `lexAll`
  should not cascade a second spurious diagnostic scanning to EOF.
  Message fix is small; cascade fix is architectural (lazy lexing or
  truncate-after-first). Land both together with a triggering fixture.
- **`edit F, sm[k]` / `im[k]`** dies in lowering with a generic "edit
  target" message instead of a checker diagnostic naming the map-only
  restriction (map-hashtable).
- **`declIsRuntimeOrigin` symlink-equivalence residual** (attempt-abort
  Task 8): two `--rtdir` spellings equal only via a symlink can still
  misclassify — shared limitation with `expand()`'s key comparison.
- **Discard-tracking generality** (ARC Tasks 8-9): only `pop`/`shift`
  use transfer-convention discard release (`fpDiscardExprIdx`); a future
  transfer-semantics intrinsic needs the same explicit wiring — nothing
  audits for it automatically.
- **Parameter-escape-summary precision upgrade** (4e follow-on): only if
  leak analysis ever proves noisy in practice.

### Serial/connection phase (2026-08-16)

- **`transportName(tag)` falls through any non-1 tag to `"serial"`**
  (`clarusc/check.cla`, Task 3) — an explicit `tag == 2` branch would be
  safer for a future third transport tag.
- **Transport-misuse diagnostic column points at the call's `(`**
  (`clarusc/check.cla`, Task 3), not the `serial`/`appletalk` token
  itself — existing `ExCall` convention, just noted as a future
  precision upgrade.
- **Three connection-dispatcher builders share ~25 near-identical
  lines** (Task 5) — folding the `Opened`/`Closed` builders into one
  helper alongside `Received`/`Failed` was deferred; same file as
  `lowSynthConnFireFailed` below.
- **`lowSynthConnFireFailed` declares an `err` local even when no
  `failed` handler exists** (Task 5) — unused C var under `-Wall`,
  harmless but sloppy.
- **Every native binary carries the conn runtime, `connection` or not**
  (final review, Important 3, confirmed as PLANNED, not a bug) —
  `cg68AddRoots` (`clarusc/cg68k.cla`) roots every `nat*`-named function
  unconditionally, no `irUsesConn` gate; `nat_UiConnPump`
  (`runtime/clarus/native.cla`) matches that prefix, so it (and
  everything it pulls in transitively via shake.cla's reachability walk)
  ships in every native build's `.s` output, not just conn-using ones —
  the final review measured +5-7% `.s` lines. The narrowing lever, if
  size ever matters: gate `cg68AddRoots`'s conn-specific roots on
  `irUsesConn` the same way other conn-only surfaces are gated, while
  keeping the EMPTY dispatcher stubs (the no-op seam Task 6's review
  verdicted SOUND+DISCOVERABLE — a bad config fails at link time, not
  silently) unconditional so a non-conn program that somehow still
  references a conn symbol still gets a loud link error instead of an
  unreachable-callee crash.
- **No host-lane emitted-C golden for `cpEmitMain`'s pump loop**
  (final review, noted alongside Important 3) — the abort-aware
  `while (!clar_aborting && clar_fn_rtConnAlive())` loop shape
  (`clarusc/cprint.cla`'s `cpEmitMain`) is behaviorally covered by
  `internal/conntest`'s `TestAbortDuringPump` (drives the real compiled
  binary through an abort mid-pump and asserts prompt exit), but there is
  no byte-level golden pinning the emitted C text itself — a future
  cprint.cla refactor could silently change the loop's shape (e.g. drop
  the `clar_aborting` short-circuit) and every existing gate would still
  pass as long as the behavior it happens to exercise still works. A
  golden (or a narrower text-contains assertion) over the emitted C
  around `cpEmitMain`'s pump loop would close that tripwire gap.

### Correctness-cleanup phase (2026-08-17)

- **`cgLastTrackedOff` aliasing hazard in `cgIntrMapGetDv` widened by one
  arg position** — the key is now evaluated before the dv handoff
  consult, widening the pre-existing hazard window by one arg position.
  Unreachable today (the checker rejects text-typed keys; the same
  hazard already existed for the map expression itself). Defensive fix
  is `cgLastTrackedOff = -1` before the dv store; deferred because it
  forces a snapshot regen.

## ABI / performance

- **`KArr` param ABI** still copies arrays by value at call sites
  (param-abi covered `KStr`/`KRec` only).
- **param-abi RSS increase (+4-9%) unexplained** — profile before
  further Layer-2/3 memory work; suspects are the call-site copy temps
  and classification side tables.
- **§1.7 double codegen** (layer1 findings doc): full fix needs
  relocation entries so emission becomes segment-independent — Layer 3
  (caching/architecture) scope.
- **Layer 2 systemic costs** (256-byte `Str255` etc.) untouched by the
  layer1 phase.
- **Bulk `text` methods' loop-body residual** (clir-load-perf): ~10x a
  `move.b`-class floor on 68k; lever if it matters again is
  hand-emitted asm helpers (à la `cg_mul32`) or tighter loop codegen.
- **Truncate-on-reuse** alternative to design B's copy-on-install
  recorded (clir-load-perf spec §4); revisit only if the ~31k-copy
  install cost becomes unacceptable.
- **intmap Stage C candidates** (map-hashtable): `intmapHash` is the
  identity function — add a multiplicative mixer if an on-target
  measurement shows clustering; remaining int-keyed string maps to
  migrate (`recFieldsHeadByName`/`xrecSizeByName` in check.cla,
  `ast.cla`'s `externRetRegBy*` family, `checkEnumDecl`'s `seen`).
  Stage B's own premise (68k-lane win) is still unmeasured on-target.
- **Host CLI progress bar** (clarusc-live-log follow-up): reuse the
  `feProgressStep`/`feProgressTick` seams for a stderr bar/spinner.
- **`ser.cla` still reads per-byte** (`file.save`/`file.load`) —
  deliberate clir-load-perf non-goal, not yet adopted onto bulk reads.
- **`natLogCap` is 4096 bytes** — a multi-compile `ClarusC.APPL`
  session's `##CLARUS-LOG##` trailer clips at the tail. Raising it
  reblesses ~40 native goldens (`MOVE.L #4096,D0` in every `.s`); do it
  when a real session loses lines that matter.

### Correctness-cleanup phase (2026-08-17)

- **`scripts/size-68k.sh` suite composition is stale/broken** — missing
  `cases_param`/`abort`/`textrange`/`errret`/`evalorder`; repair before
  the next size-sensitive phase. This phase's own code-size growth
  (jiggle machinery in the always-spliced `uiscript.cla`, plus the
  div/mod guard added to every glue site; 7 fixtures newly crossed into
  seg2) went unmeasured as a result — record that gap alongside the fix.

### Serial/connection phase (2026-08-16)

- **Per-byte read path ceiling, both lanes** — `rtConnPump`'s
  byte-at-a-time `text.append` loop (`runtime/clarus/conn.cla:322`) and
  `rtConnDevReadByte`'s one-`PBReadSync`-per-byte native read
  (`runtime/clarus/conn_68k.cla:198`) are both already `ponytail`-
  commented in place: correct and plenty fast at serial rates (even
  57600 baud is ~170µs/byte, nowhere near per-call overhead), with the
  named upgrade lever being a batched `rtConnDevReadInto(slot, buf, n)`
  added to the per-lane waist if a future fast bulk transport ever makes
  it a bottleneck.

## Runtime / Toolbox robustness

- **`rtUiTableClick` scripted row math has no upper clamp** against the
  live row count — deliberate tripwire (runtime-ir-bake T2 blocker): a
  clamp would mask the next stale-master-pointer bug. Do not "fix"
  casually.
- **Map runtime minors** (map-hashtable Task 5 review): unbounded index
  probe loops have no corruption guard; `rt_map_layout_check` is
  `sizeof`-only; dead `MAP_KEYBLOCK` constant; three near-identical
  growers; keypool is append-only until release/clear (fine for compiler
  workloads, a real ceiling otherwise).
- **Unreproduced live-input popup anomaly** (mac-target-4d): Protocol
  popup failed to open once; 20+ repro attempts failed. Guarded by the
  `rt_ui_popup_assert_alive` tripwire in both scripted popup lanes — if
  it fires, investigate menu lifecycle across form reopen.
- **Modal form map-element writeback upserts** (`RT_UI_WB_MAP` uses
  `rt_map_set`): a key removed by a timer mid-edit is re-inserted on
  OK. Deliberate; descriptor carries enough to check-then-set if upsert
  proves wrong.
- **S7 native popup CDEF** (parked 2026-07-28): dormant scaffolding
  behind `RTUI_POPUP_CDEF`; enabling needs real per-popup `'MENU'`
  resources emitted at build time.
- **Odd-C-size record-layout divergences** (strn-field-alignment
  out-of-scope): `char[n]`/`bool[n]` with odd n, the `char[1]`/`bool[1]`
  degenerate case (decide reference wording vs `cgSlotSizeOf` first),
  and all-byte records still diverge cprint vs cg68k in size/alignment.
  Latent — offsets never consumed cross-lane today.
- **Retain/release elision** (ARC non-goal): trigger not met by
  measurement (deltas within noise). Revisit only if a
  refcount-heavier acceptance app or real hardware shows degradation.

### Correctness-cleanup phase (2026-08-17)

- **Heap-jiggle stress mode only hooks the `UiNewPtr` waist** (Task 3):
  `rtUiJiggleTick()` forces a full-heap `CompactMem` at each scripted
  dispatch and each `UiNewPtr` call, but core text/list allocations
  (`TENew`, List Manager row storage) and Toolbox-internal moves that
  don't route through `UiNewPtr` are not jiggled — a stale-master-pointer
  bug reachable only through one of those paths would not be caught by
  the harness as it stands today. The stride lever named in the brief
  (tick every Nth call, for when per-call `CompactMem` overhead becomes
  unacceptable) is unused — Task 3's one measured script ran well under
  budget (44.75s vs. a 15m allowance), so no stride was needed.
- **`rtUiLayout`'s dead `ctrlMp` assignment** (`runtime/clarus/
  uiwidgets.cla`, Task 4 audit): `ctrlMp = UiHandleDeref(ctrl)` is
  computed and never read. Harmless (not a staleness hazard — nothing
  consumes the stale value), left in place per the audit's "don't churn
  safe code" rule; worth deleting in a future cleanup pass through that
  function.
- **`(new)` doc-comment tag is a one-off convention** (`runtime/clarus/
  ui.cla:1192,1203`, Task 1): marks the two About-box helpers as new
  relative to the file's inherited `rt_ui.c`-heritage citation style;
  cosmetic, not reused anywhere else in the runtime.

### Serial/connection phase (2026-08-16)

- **Host `every`-timer gap in the CLI pump** (design doc
  `docs/superpowers/specs/2026-08-15-serial-connection-design.md` §6/§7)
  — `every` machinery is UI-runtime-entangled today; the host CLI pump
  services open connections only, not `every` timers. Deliberately not
  promised this phase.
- **Task 7 leftover minors, all deferred**: `serial_snow_test.go`'s
  `done()` blocks ~34s inside `runSnow`'s poll loop, suspending
  died-mid-run detection for that window; `internal/conntest`'s
  `TestListenMode` has a stolen-port edge case; `examples/serialecho.cla`'s
  quit-in-loop keeps scanning the rest of a chunk after the 3rd `Q`
  instead of returning immediately; `runtime/host/rt_serial_test.c` has
  three stale/contradictory comments (alarm numbers, a retry-loop
  reference, and `set_recv_timeout`'s stated rationale).

## Bake / CLIR artifact machinery

- **Stamp-proxy gap** (runtime-ir-bake, still open): the CLIR stamp
  hashes the committed `clarusc/clarusc.c` snapshot, not the live
  runtime source set; the per-module drift hashes close only the
  include-collision slice. Longer-term fix: hash the live runtime
  module sources.
- **Drift log can mislead under a `--rtdir` override**
  (fallback-trigger-narrowing): "absent hash entry" doesn't distinguish
  not-in-manifest from hashed-under-a-different-`--rtdir`; wants a
  `--rtdir`-mismatch test.
- **Bake-time `file.readText` failure silently skips a manifest hash
  entry** (`bake.cla`) — surfaces later as defensive drift-fallback, no
  diagnostic at `--bake-ir` time.
- **`bkInstallFieldInfo` runs on every testapi+UI bake compile**, not
  only case-(b) collisions; and the field-table install has no
  visibility boundary (regression oracle exists:
  `TestRtbakeTestapiManifestOnlyIncludeParity`; underlying gap not
  fixed). `bkSecFieldInfo`'s sufficiency rests on an undocumented
  invariant (baked modules have no `method`/`window`/`form`/`every`/`on`
  decls) — add the doc note near `bake.cla`'s section writer.
- **Drift fixture's mutation is semantically null**
  (`TestRtbakeDriftFallback` appends a comment byte); stronger variant
  (add + call a new extern) recorded, unimplemented.
- **Taint-and-discard is silent/uncounted** (object-code-linker): a
  "captured N of M, D discarded" log line or floor assertion would
  surface silent baked-set shrinkage.
- **`bkObjRelocSymValid` never validates `kind` range** — `kind=99`
  falls through the class switch as `Label`.
- **`srcSlot` derivation over-broad** (cg68k paste fixups): claims any
  A5-relative source is the hole rather than exactly the classified
  slot.
- **Capture-side vs load-side object-code globals are half-shared** —
  `cgObjValid`/`RunFirst`/`HoleFirst`/`NHoles` are stale capture-side
  values after a load; read `bkLdObj*` for those. Footgun for readers
  assuming symmetry.
- **A future fourth lazily-set glue flag** (beyond
  `cgMul32Used`/`cgDiv32Used`/`cgMod32Used`) needs
  `cgObjApplyGlueUsage`-style replay or it silently reproduces
  object-code-linker Task 3's bug 3.
- **Smart linking / IR-body removal from the 68k lane + link-time
  layout improvements**: gated behind a future oracle-relaxation
  decision (object-code-linker design boundary).
- **`bkReadObjCode` spins on a corrupt `nHoles` count** before the
  framing check fires (pre-existing).
- **Comment-drift minors** (clir-load-perf): `bkParsedValid` should
  state "lane cannot change mid-session"; `bkLoadOverrun` names only
  `bkGetByte` as a setter (four exist); `rtTextStringAt` cites a moved
  idiom; `bkCheckRtbakeHeader`'s header doc still names
  `bkHashTextFrom`; `drive.cla`'s "rtbakeBytes still held"
  parenthetical is wrong for the memoized drift-interleaving case.

## Test coverage gaps (recorded by audits, mostly need real input/hardware)

- **cprint-lane `UiLaunchReal`** (real AppleEvent glue in
  `rt_ext_mac.inc`) has no test — every Retro68 build uses `--events`;
  needs a no-events Mac-lane smoke or real Finder launch.
- **Real modal halves** (`rtUiAskSaveChanges`'s `Alert(130)`,
  `rtUiAskOpen`/`rtUiAskSave`'s real SF halves) and **real
  mouse-tracking continuations** (`TrackControl`/`LClick`/
  `UiPopUpMenuSelect` branches) are `rtUiScripted`-gated and never
  exercised — need live input, the display's documented carve-out.
- **Native non-UI `App.startCLI` dispatch is known-broken** (cg68k
  startup stub calls every handler unconditionally and never marshals
  `args`) — deprioritized by design ("CLI targets the host"); blocks
  booting `abort_uncaught`/`abort_launch_uncaught` natively
  (attempt-abort Task 8; two named resolutions, none adopted).
- **No automated abort-dispatcher-default test on either lane**; the
  C lane's UI dispatch loop has no abort-default check at all (parked —
  the opt-in cprint lane isn't where ClarusC.APPL builds).
- **No automated test of the 10-stage progress sequence**
  (clarusc-live-log) — order/count/`total` growth only exercised by
  real compile boots; the "Checking Whole Program" stage placement
  depends on the unconditional `native.cla` splice (comment not added).
- **`stringAt` return-arm/materialize consumption shapes** are
  read-verified, not hardware-exercised — add one assertion if touched
  again; the `textAt` core case never pins its freshness contract.
- **Dead runtime declarations**: `UiNewMenuStr` (unused `string`-typed
  NewMenu overload) and the runtime's own `UiCurrentA5` (the `A5Live`
  suite case covers the codegen via its own local extern) — delete or
  wire up in a cleanup pass.
- **Datetime glue loose ends**: host `rt_ext` glue for the catalog's
  `ReadDateTime`/`SecondsToDate`/`DateToSeconds` never added (nothing
  host-side calls them); `rt_ext_mac.inc`'s Date-Time glue is
  header-verified but first really compiled whenever the opt-in cprint
  lane next runs.
- **Suite bookkeeping minors**: `internal/mactest/coresuite_test.go`
  carries the core case count as two literals (make it a const) and its
  `TestToolboxSuiteOn68k` doc comment lags the real case count;
  `caseIntMapGrowIter` lacks the masked-hash-collision partner pair a
  fuller test would pin.
- **Transient `emit68k` extern-record-decay crash** (2026-08-06,
  unconfirmed): one observed crash, 0/28 repro attempts. Repro ladder
  archived in `.superpowers/sdd/2026-08-06-toolbox-cookbook/
  repro-decay-crash/`. Recorded, not dismissed.
- **`/tmp/l1src` frozen-source byte-identity procedure is stale**
  (predates param-abi's immutable-params rule); any future phase using
  it needs a fresh re-freeze.

### Correctness-cleanup phase (2026-08-17)

- **`runner.cla:326`'s "24 real cases here" comment is stale**
  (`testsuite/toolbox/runner.cla`'s `runToolboxTests`, pre-existing
  drift noted during Task 2): the real count has moved several times
  since (now 31 real cases, `nTbCases` = 32). Candidate fix: derive the
  message from `nTbCases` instead of a hand-written number, or delete
  the count from the comment entirely.
- **`rt_ext_UiCompactMem` (Task 3's cprint-lane no-op stub for
  `CompactMem`) is unexercised** — no jiggle test targets the Retro68/
  cprint Mac lane (`TestToolboxSuiteJiggleOn68k` is native-68k-only), so
  the stub is only really compiled whenever the opt-in cprint lane next
  runs (`CLARUS_CPRINT_MAC_TESTS=1`), same class of gap as the existing
  Datetime glue entry above.

### Serial/connection phase (2026-08-16)

- **Toolbox-suite compose file list duplicated across `internal/bake`
  and `internal/mactest`** — `internal/bake/bakeidentity_test.go`'s
  `toolboxSuiteGUIFiles` and `internal/mactest/coresuite_test.go`'s
  `toolboxFiles` are hand-maintained twins with a "keep in sync"
  comment as the only enforcement; Task 2 updated one and missed the
  other, undetected until this task's T2 run (see `STATUS.md` §3, fix
  commit `0907364`). A shared source (one list, imported by both) or a
  T1-level consistency check would prevent the next miss.
- **No committed emit-time fixture pinning the unchanged
  `lowUnsupported` rejection for `appletalk`/local-receiver shapes**
  (Task 5) — those shapes still reject the same way pre-phase; nothing
  regresses that specifically today.
- **`TestEnvUnsetFailedPath` rebuilds `echo.cla` instead of reusing
  `TestConnectMode`'s binary** (`internal/conntest`, Task 5) — T1
  hot-path cost, harmless but avoidable.
- **No coverage for the >4-connections build error** (Task 5) — the
  cap exists and is enforced, just untested.
