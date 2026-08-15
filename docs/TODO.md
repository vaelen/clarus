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

## Compiler correctness / diagnostics

- **Lexer diagnostic quality** (decided 2026-07-23): a bad escape in a
  double-quoted string (`"a\qb"`) should report `invalid escape
  sequence`, not `unterminated string literal`, and the eager `lexAll`
  should not cascade a second spurious diagnostic scanning to EOF.
  Message fix is small; cascade fix is architectural (lazy lexing or
  truncate-after-first). Land both together with a triggering fixture.
- **Widget-property out-param fill-in-place gap** (mac-target-4c final
  review): `file.readText(p, d.Body.text)` compiles but fills a
  discarded temporary, not the widget. Needs either a loud compile-time
  error for the shape or a real fill-in-place binding for widget
  properties (binding-walker work).
- **`edit F, sm[k]` / `im[k]`** dies in lowering with a generic "edit
  target" message instead of a checker diagnostic naming the map-only
  restriction (map-hashtable).
- **map/sortedmap `get(k, dv)` argument evaluation order** diverges host
  (m, k, dv) vs native (m, dv, k) — observable only with interacting
  side effects. Either pin "unspecified" in the reference or align the
  native order (map-hashtable).
- **`toBytes` name-only mutation guard** (param-abi Task 2): fires on
  the method name before the receiver-kind switch; harmless today, not
  principled.
- **`irXRecFieldSize` nested-xrec forward-reference panic** remains
  unguarded (native-gaps-cleanup Task 8's known follow-on): same class
  as the fixed `lowTypeAt` path, reachable only for a nested xrec field
  whose element record is itself forward-referenced; no current fixture
  reaches it. Guard + diagnose the same way if triggered.
- **`declIsRuntimeOrigin` symlink-equivalence residual** (attempt-abort
  Task 8): two `--rtdir` spellings equal only via a symlink can still
  misclassify — shared limitation with `expand()`'s key comparison.
- **Discard-tracking generality** (ARC Tasks 8-9): only `pop`/`shift`
  use transfer-convention discard release (`fpDiscardExprIdx`); a future
  transfer-semantics intrinsic needs the same explicit wiring — nothing
  audits for it automatically.
- **Parameter-escape-summary precision upgrade** (4e follow-on): only if
  leak analysis ever proves noisy in practice.

## ABI / performance

- **`KArr` param ABI** still copies arrays by value at call sites
  (param-abi covered `KStr`/`KRec` only).
- **param-abi RSS increase (+4-9%) unexplained** — profile before
  further Layer-2/3 memory work; suspects are the call-site copy temps
  and classification side tables.
- **Bare-`EIntr` arg release gap, both lanes** (pre-param-abi):
  `list_pop`/`list_shift` results passed directly as borrowed call args
  get no scheduled release.
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

## Runtime / Toolbox robustness

- **PBM app icons rejected on the Mac** (attempt-abort field test):
  `app68BuildIcnFamily`'s P1 parser should accept CR/CRLF/LF line
  endings (files staged via `hcopy -t` get CR; Mac-authored PBMs would
  too) — same treatment as the lexer's CR-byte fix. Deferred per Andrew;
  warn-and-continue fallback works as designed meanwhile.
- **`rtUiTableClick` scripted row math has no upper clamp** against the
  live row count — deliberate tripwire (runtime-ir-bake T2 blocker): a
  clamp would mask the next stale-master-pointer bug. Do not "fix"
  casually.
- **Map runtime minors** (map-hashtable Task 5 review): unbounded index
  probe loops have no corruption guard; `rt_map_layout_check` is
  `sizeof`-only; dead `MAP_KEYBLOCK` constant; three near-identical
  growers; keypool is append-only until release/clear (fine for compiler
  workloads, a real ceiling otherwise).
- **Popup label-lane latent bug** (mac-target-4d): `rt_ui_popup_box` +
  the popup draw branch still use raw unclamped `RTUI_FIELD_LABEL_W`; a
  labeled `popup` with declared `width:` under ~90px reproduces the
  zero-width unclickable box. Fix in `rt_ui_layout`'s width computation
  (mirror the labeled-field branch). No current fixture declares one.
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
- **Reference erratum**: Appendix C Bookmark Manager's `Remove.click`
  doesn't guard `Marks.selected == -1` — fix reference-side in a docs
  pass (the example is normative and shipped verbatim).

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
