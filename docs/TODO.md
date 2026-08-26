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
- **Array-literal initializers** (transfer-crcs phase, Andrew
  2026-08-25): `var t: int[256] = {…}` / `const` arrays do not exist —
  fixed arrays are always zero-filled and `const` initializers are single
  literals — so lookup tables (the `crc32` table, sine tables, MacRoman
  translation tables, keycode maps) must be built at run time. `crc32`'s
  table is built lazily at first call as a stopgap (a 4-byte table pointer in every
  program's data segment, since shake prunes unreachable functions but
  never globals — a second, smaller follow-up in its own right; the 1 KB
  block itself is heap-allocated only by programs that call `crc32`). Needs
  parser + checker + IR + both backends (cg68k constant pool; cprint
  static initializer). Spec: `docs/superpowers/specs/2026-08-25-transfer-crcs-design.md` §2.3.
  The `crc32` table ended up as a heap block rather than a global array
  for the `cg_init_globals` reason recorded under ABI / performance —
  an array literal would also need a zero-cost (constant-pool)
  representation to be the right home for it.
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

### binary-files phase (2026-08-22)

- **UI/non-UI connection-pump lane gap** (Task 9's report) — the native
  lane only pumps `connection` traffic (`nat_UiConnPump`) for
  UI-classified programs (window/menu/`every` present); the host C lane
  only ever compiles NON-UI programs (`cprint` emits `#include
  "rt_ui.h"`, which lives only under `runtime/mac/`, so `cc` against
  `runtime/host` fails outright for any program with a `window`/`menu`).
  There is no single program shape that both boots on the host dev lane
  AND pumps connections on native — a serial/BBS-style program has to
  carry at least one throwaway status window purely to get native
  pumping (`examples/pagefile.cla`'s workaround). Serial-connection
  phase's own spec §3/§7 promised one program shape on both lanes; it
  doesn't hold today. Also affects `examples/serialecho.cla`'s doc
  comment, fixed this task to state the real constraint instead of
  claiming host-lane runnability it never had.
- **Handle generation-counter idea (spec §7, out of scope this phase)**
  — `filehandle`/`connection` values are bare small ints (slot+1); a
  closed-then-reused slot number is indistinguishable from the original
  handle at the type level (no staleness detection). A generation
  counter packed into the value (or a parallel generation table checked
  by every `rtFh*`/`rtConn*` call) would catch use-after-close bugs
  instead of silently operating on a reused slot. Recorded, unscheduled.
- **`natItoa`/`rtUiIntToText` stay unmerged** (Task 3 ruling, reverted a
  same-body collapse) — three near-identical int-to-string bodies live
  in the runtime (`natItoa`, `rtUiIntToText`, and `string(n)`'s own
  `rtIntToStr`) rather than one shared routine, because collapsing them
  pulled `str.cla` into every native binary's always-reachable set
  (`globals.cla` 2→3 CODE segments) for no user benefit. Duplication
  only, no functional gap; revisit if a future phase needs the shared
  body for another reason anyway.

### filesystem-api phase (2026-08-26)

- **Resource-fork-as-bytes / `file.openRF`** — this phase's `file.*`
  family covers the data fork only; `readResource`/`writeRes`
  (binary-files phase) remain the only resource-fork surface. A
  `file.openRF(path): filehandle` giving positioned I/O against the
  resource fork (mirroring `file.open`'s data-fork `filehandle`) was
  named out of scope (design spec §7), unscheduled.
- **`list of string(31)` element capacity** — `file.list`'s `names`
  param is `list of string`, whose element is the general (255-byte)
  `string`; a caller who wants a narrower-capacity element (31 chars is
  the real HFS leaf-name max) still pays the general `string`'s 256
  B/entry ceiling — no `list of string(N)` narrowing is offered by the
  catalog. Named out of scope (design spec §7), unscheduled.
- **Recursive `makeDir`** — `file.makeDir` creates exactly one level
  (the parent must already exist); a `makeDir -p`-style multi-level
  create was named out of scope (design spec §7), unscheduled.
- **Combined rename+move** — `file.rename` changes the leaf name in
  place; `file.move` changes the parent folder while keeping the name;
  no single call does both atomically (a caller wanting to move to a
  new folder AND rename issues two calls). Named out of scope,
  unscheduled.
- **`PBSetCatInfoSync` declared but unused** — `toolbox/files.cla`'s
  catalog exposes it (bound once by the catalog driver, Task 2) but no
  `rtFhDev*` call in this phase calls it; `setInfo` goes through
  `PBHGetFInfoSync`/`PBHSetFInfoSync` instead (spec §4.3). Same
  declared-but-unused shape as other catalog-completeness entries.

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

### binary-files phase (2026-08-22)

- **FIXED (Task 9c): `--rtbake` + `connection`/`filehandle` method calls
  used to crash clarusc** (`list index out of range`) — found by Task
  10's own T2 run, root-caused via `lldb` to `lower.cla`'s
  `lowRtCoerceArg`, which looked up the target runtime function's
  DECLARED param type by NAME through the checker's live symbol table
  at lowering time, a table `--rtbake` never populates for baked
  runtime functions (it skips their parse+check for performance). Fixed
  by `lowCoerceTo`, which passes the statically-known target IR type
  (`irTextT`/`irStrType(255)`) directly at each of the 7 call sites
  instead of looking anything up — the coercion target was always fixed
  at compile time, no lookup was ever actually needed. Full trail:
  `.superpowers/sdd/2026-08-22-binary-files/task-10-report.md`'s "Task
  9c" section.
- **STILL LIVE: an `emit68k` build whose generated code references a
  runtime function that was NOT spliced into that build crashes
  clarusc** (`runtime error: list index out of range`, exit 3) instead
  of emitting a diagnostic — found by Task 5 when
  `internal/cg68k/segment_test.go`'s `segmentationFixture` (a native
  composition of the whole core suite) tried composing
  `cases_fileh.cla` before the native `filehandle` lane existed
  (`fileh_68k.cla` was Task 6's; at Task 5's own tip, `rtFh*` calls had
  no spliced module to resolve against). Task 5's report ("Golden churn
  / known gaps") worked around it by leaving `cases_fileh.cla` out of
  `segmentationFixture` rather than fixing the underlying gap — DISTINCT
  from the FIXED item just above: there, the runtime function WAS
  spliced and the crash was a checker-symbol-table lookup that
  `--rtbake` never populates; here, the function is genuinely absent
  from the build (a real, ordinary "undefined" situation any other
  unresolved reference gets a clean diagnostic for) and the compiler
  crashes instead of saying so. Same crash text, different code path,
  still live — Task 6 landing `fileh_68k.cla` only removed the ONE
  trigger `cases_fileh.cla` happened to hit; the general robustness gap
  (any unspliced runtime-function reference in a native build) is
  untouched.
- **Testing-strategy gap the FIXED item above exposed**: `--rtbake` (the
  fast baked-IR compile path `ClarusC.APPL` uses by default) was only
  ever exercised by `internal/bake`'s `CLARUS_BAKE_FULL=1` gate, which
  is opt-in and runs only inside T2 (`scripts/test-merge.sh`) — not T1,
  not any individual task's `--smoke` run. A whole phase (8 tasks, one
  new type end-to-end) shipped with a `--rtbake`-breaking bug that
  nothing caught until the FINAL close-out task happened to run T2 for
  the first time. Task 9c added ONE targeted T1-speed regression
  (`TestRtbakeConnFilehByteIdentity`) for this specific bug class, but
  the broader gap stands: `--rtbake` as a WHOLE has no T1-speed smoke at
  all, only the opt-in full-corpus gate. A cheap general fix: promote
  one or two representative `--rtbake` fixtures (a self-compile, one
  fixture using each "unusual" runtime module) into T1's default run,
  the same way `TestBakePathByteIdentity` already does for the cg68k
  corpus slice — `connection`/`filehandle` are now covered by Task 9c's
  own test, but a FUTURE new value-typed runtime module (the same shape
  as `connection`/`filehandle`) could reintroduce a sibling gap with no
  T1 tripwire.
- **`expand()` marks `seenPaths` before a successful read** (Task 7
  re-review; `clarusc/drive.cla` ~950-953) — a failed dir-relative
  attempt poisons that raw path for later calls; benign in every
  reachable case today, hardening candidate (mark on success only).
- **A program whose only `connection`-typed things are record
  fields/params (no global) never sets `usesConn`** (Task 4 minor;
  `clarusc/check.cla` ~5850-5865) — so `conn.cla` isn't spliced and the
  program fails with a link error instead of a diagnostic; unreachable
  in practice (no non-nil connection without a global) but ugly.
  `usesFileh` does the equivalent gating correctly (any `filehandle`
  use, not just a global, sets it) — port that discipline over.
- **`string("x")` diagnostic reads "cannot convert string to string"**
  (Task 3 minor; `clarusc/check.cla` ~5372) — mirrors the pre-existing
  `int()` path's wording; source and target type names coincide for
  this one conversion, so the message is technically true but useless.
- **Duplicate-`const` diagnostic cites only the second declaration's
  position** (Task 2 minor; final-review wave M5; `clarusc/check.cla`'s
  `checkConstDecl`, ~2705/2710) — both `emitDiag` calls use `declLine(d)/
  declCol(d)` (the redeclaration), never the first decl's own position;
  `externFirstDeclByName`/`xrecFirstDeclByName`'s sibling diagnostics
  cite both. Cosmetic (the message still names the right identifier).
- **`cgReturnStmt` computes `irExprType(x)` twice** (Task 9b minor;
  final-review wave M5; `clarusc/cg68k.cla`'s `cgReturnStmt`) — once for
  `rk = irtKind(irExprType(x))`, again a few lines later for
  `retT = irExprType(x)`; pure polish, same result both times.

### filesystem-api phase (2026-08-26)

- **`drive.cla`'s prelude-splice rationale is restated at 4 sites**
  (Task 3 minor, deferred) — `clarusc/drive.cla:63-73,1516-1531,
  1996-2077` and `clarusc/bake.cla:404-417` each carry their own telling
  of why `prelude.cla` is spliced from source first and excluded from
  the bake drift guard; consolidate into one comment the others
  reference, after the wording fix (already applied, fix round 1).

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

### transfer-crcs phase (2026-08-25)

- **`cg_init_globals` re-zeroes what the startup zero-loop already
  zeroed, and unrolls arrays element by element** (transfer-crcs Task 1
  finding): `cgEmitInitGlobalsStub` default-inits EVERY global via
  `cgDefaultInitAt` even when the type's default is all-zero and the
  below-A5 sweep has already zeroed it, and `cgArrDefaultAt` unrolls
  `T[N]` into N stores — a 256-int global costs ~1.5 KB of startup code
  in every native program. Skipping all-zero-default globals (or
  looping large scalar arrays) would shrink every native program's
  startup code; it is a planned rebless wave of its own (every cg68k
  golden's `cg_init_globals` changes). The `crc32` table went to the
  heap to sidestep this.
- **Migrate `crc16` and `crc16x` to table-driven loops** (Andrew
  2026-08-26): both are still per-bit loops (`rtTextCrc16`,
  `rtTextCrc16X` in `runtime/clarus/text.cla`, 8 iterations per byte);
  the Snow probe measured 277 / 287 ticks per 64 KB against `crc32`'s
  120 with its table, so a 512-byte table each (256 × 16-bit entries:
  reflected `0x8408` for KERMIT, forward `0x1021` for XMODEM — the
  standard byte-indexed formulations, `crc = tab[(crc ^ b) & 0xFF] ^
  (crc >> 8)` reflected, `crc = tab[((crc >> 8) ^ b) & 0xFF] ^ ((crc
  << 8) & 0xFFFF)` forward) should bring each down to roughly `crc32`'s
  per-byte cost. Follow the `crc32` pattern exactly: a lazily
  `TextNewPtr`-allocated heap block behind one `ptr` global each, NOT
  an `int[256]` global (the `cg_init_globals` unrolled-init cost just
  above). Each new `ptr` global shifts every later global's A5 offset
  — a full cg68k/emitui golden rebless per global — so land both
  together, ideally in the same wave as the `cg_init_globals` fix or
  the array-literal-initializer phase (which would make all three
  tables constant-pool data and retire the heap blocks). Test vectors
  already pinned: `"123456789"` → `0x2189` (KERMIT), `0x31C3` (XMODEM),
  plus the chunked/n==0 cases in `testdata/run/crc16.cla` and the core
  suite's `Crc16` case; the KERMIT one is also `examples/pagefile.cla`'s
  journal checksum, so the migration must stay bit-exact.

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

### binary-files phase (2026-08-22)

- **`rt_fileh.inc`'s `rt_ext_FhH*` glue never guards `h <= 0`** (Task 5
  minor) — safe only because `fileh.cla`'s own nil check panics before a
  bad handle ever reaches the C glue, and there is no way for user code
  to forge a handle value; hardening candidate if that invariant ever
  loosens.
- **`rtFhDevFlush`'s two-attempt error shape is invisible** (Task 6
  minor; final-review wave M5; `runtime/clarus/fileh_68k.cla`) — it
  always issues BOTH `PBFlushFileSync` and `PBFlushVolSync` and reports
  the file error over the vol error when both fail, deliberately (a
  vol-flush failure after a file-flush success is still surfaced), but
  nothing about the return value tells a caller two attempts were made
  or which one is being reported. Documented behavior, not a bug.
- **`testsuite/toolbox/cases_catalog.cla` discards `PBCreateSync`'s own
  error** (Task 2 minor; final-review wave M5; ~line 219,
  `PBCreateSync(fpb) // dupFNErr on a rerun is fine; PBOpenSync below is
  the real gate`) — test-side only, `PBOpenSync` right after is the real
  pass/fail gate for this case. NOT made moot by the final-review wave's
  M2 fix (the `wbuf` `NewPtr(64)` leak a few lines below, in the same
  function) — M2 only disposes the write buffer; it does not touch this
  discarded return value. The *runtime* sibling of this same class of
  gap (`rtFhDevCreate` reporting the OPEN error over a real non-dupFNErr
  CREATE error) is the final-review wave's M4, fixed for real.

### filesystem-api phase (2026-08-26)

- **`rt_fh_mac_time` duplicates `rt_dt_now_mac`'s 3-line Unix-to-Mac-
  epoch-local conversion** (Task 3 minor, deferred; `runtime/host/
  rt_fileh.inc:210-214`, `rt_ext_host.inc`'s `rt_dt_now_mac`) — share
  one helper instead of two independently-maintained copies.
- **`rtFhDevListBegin` (host lane) leaks `rtFhListBuf` if called twice
  without an intervening `ListEnd`** (Task 4 minor, deferred;
  `runtime/clarus/fileh_c.cla:180`) — unreachable today (`rtFhList`'s
  own begin/next-loop/end shape always pairs them); one-line guard if a
  future caller ever calls `ListBegin` directly without going through
  `rtFhList`.
- **`rtFhDevRename` (native lane) re-implements the by-name
  `PBGetCatInfoSync` block instead of reusing a state-block slot**
  (Task 5 minor, deferred; `runtime/clarus/fileh_68k.cla:731`) —
  `rtFhDevStat` already stashes a directory hit's own DirID at
  `rtFh68kState+28`; `rtFhDevRename` could stash the SAME lookup's
  parent DirID at a new `+44` slot and reuse it instead of issuing its
  own separate `PBGetCatInfoSync` call. Correctness is unaffected (both
  calls read the identical field), purely a duplicate-call cost.
- **`rtFh68kEnsureState` does not check `SerNewPtr`'s result** (Task 5
  minor, deferred; `runtime/clarus/fileh_68k.cla:395`) — pre-existing
  idiom for this file's global-lifetime allocation block; an
  out-of-memory native Mac would crash on the next `peekl`/`pokel`
  rather than fail cleanly.
- **`rtFh68kFourCCToStr` maps a zero `fdType` to `""`, conflating an
  untyped file with a folder** (Task 5 minor, deferred; `runtime/
  clarus/fileh_68k.cla:409`) — both a folder and a file with no
  Finder type set read back `type == ""` from `file.info`; `isDir` is
  the only reliable discriminator today. Comment-only fix recorded,
  unimplemented.
- **`rtFh68kName` truncates the Pascal length byte for a path over 255
  characters** (Task 5 minor, deferred; `runtime/clarus/
  fileh_68k.cla:59`) — pre-existing HFS path-length idiom; no
  overrun, just silent truncation of an already-illegal-length HFS
  path.
- **Host `readdir` names over 255 bytes are silently clamped, and
  `FhHRename`/`FhHMove`'s `snprintf` into a 512-byte `target` buffer
  silently truncates a 255+255-byte path/newName combination**
  (final-review wave, Minor 7, deferred; `runtime/host/rt_fileh.inc`'s
  `rt_ext_FhHListNext:321`/`rt_ext_FhHRename:367`/`rt_ext_FhHMove:377`)
  — neither ceiling sets `lastError`, both just quietly clip. An
  HFS-authored path never reaches either limit (31-byte name cap), but
  a host filesystem entry created by another program could.

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

### filesystem-api phase (2026-08-26)

- **Pre-existing: the C (host) lane's `--rtbake` cannot compile any
  `filehandle` program** — `fileh*.cla` is not in `clarusc/bake.cla`'s
  `bakeModuleList` on that lane (found by Task 3's reviewer while
  checking the `prelude.cla` bake path; not introduced by this phase,
  not fixed by it either — the native/`emit68k` `--rtbake` lane is
  unaffected).

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

### binary-files phase (2026-08-22)

- **FIXED (final-review wave, M6): no fixture pinned the native D0-save
  fix for a `text`-typed `return call(...)`** (Task 9b minor) — Task
  9b's native `cgReturnStmt` D0-clobber-by-release fix was only
  exercised by `FileHandleRW`'s bool-returning paths.
  `testdata/run/ret_text_tmp_release.cla` (host behavior golden + native
  `scripts/build-68k.sh` build) and `testsuite/core/cases_textbinary.cla`'s
  `TextBinaryAccessors` case (internal check bump, same case count) now
  both exercise a `text`-returning `return call(...)` whose call
  argument is a coerced temp.
- **No fixture asserts `readAt`/`writeAt` with `count == 0`** (Task 5
  minor; final-review wave M5) — the `pos == EOF` case IS covered
  (`readAt(600,10)` past EOF, `readAt(512,100)` crossing EOF); only a
  zero-length request is unpinned. `rtFhWriteRaw`'s `n == 0` early
  return means a zero-length `writeAt` never reaches the device
  (correct, undocumented); `readAt`'s zero-length behavior is likewise
  unexercised.
- **`internal/perfgate`'s `TestEmitPerfTripwire` flakes under parallel
  `go test` on this host** — every task this phase saw it fail inside a
  full `scripts/test-task.sh --smoke`/T2 run and PASS cleanly re-run
  alone (`-p 1`); confirmed again at Task 10's own T2 run (T1 body:
  FAIL, median 0.160s vs. a 0.124s limit; isolated re-run: PASS, medians
  0.10-0.12s both times). Host-contention artifact of running the whole
  gauntlet in parallel with itself, not a real regression — the
  baseline itself is fine. Final-review wave (M7): the tripwire has
  almost no headroom even isolated (0.110s median vs. the 0.124s limit)
  and failed twice under T2 contention during this phase; a re-baseline
  decision (longer warm-up, more samples, or a wider margin) is owed
  before the next phase adds anything to the host emit path.

### filesystem-api phase (2026-08-26)

- **No test exercises `emit68k --rtbake [--testapi]` over a
  `file.info`-calling program** (Task 3's own deferred test gap) —
  closing test: one `internal/bake` case asserting the bake path was
  taken (`bkRuntimeFuncBoundary > 0`) and that its output matches the
  from-source build's. Task 3's own manual `--rtbake`/`--rtbake
  --testapi` experiments (task-3-report.md) are the only current
  evidence this path works.
- **Folder rename untested on hardware** (Task 5) — `DirOps` only
  renames a file (`a.dat` → `c.dat`); `rtFhDevRename`'s use of
  `ci.ioFlParID` as the parent DirID for a FOLDER hit relies on the
  DirInfo/HFileInfo union sharing that field's meaning at offset 100
  (documented Inside Macintosh behavior, not independently re-derived
  by Task 1's probe the way `ioDirID`@48's file/folder difference was).
- **`file.list("")` untested** (Task 5) — `file.exists("")`/
  `file.info("")` are pinned (fix round 1, both lanes); `list("")` (the
  program's own folder) has no fixture on either lane.
- **`rtFhDevListFailed`'s true branch is unexercised natively** (Task
  4/5) — the host lane's `readdir()`-error path is pinned by a C
  harness test (fix round 1); the native lane's `PBGetCatInfoSync`
  hard-failure path (as opposed to the ordinary `fnfErr` end-of-listing
  case) has no fixture on real hardware.
- **System 7 (Snow) is entirely unverified for this phase** — Task 1's
  probe wave, Task 5's native `fileh_68k.cla` lane, and
  `TestClarusCBakePathOnSnow` (owed after any runtime-module addition,
  deferred per the ledger's Task 7 ruling) all ran on Mini vMac/System 6
  only; a live 68kbbs session owned the one Snow instance throughout
  this phase. Every `PBH*`/`_HFSDispatch` trap predates System 7, so no
  difference is expected, but none of this phase's own hardware claims
  are System-7-backed.
- **The full-path spike (Task 1 (b)) was verified only on the boot
  volume** — `PBGetVolSync` + `vol + ":path"` opened successfully
  against `"SysAndApp"` (the probe's own boot volume); a second,
  non-boot mounted volume was never exercised.
- **A core-suite jiggle twin** (crash-report.md §9, the `rtUiTeWidestLine`
  find) — `TestToolboxSuiteJiggleOn68k` is the ONLY heap-jiggle boot in
  the tree, and it is T2-only; a `TestCoreSuiteGUIJiggleOn68k` twin (or
  a jiggle variant of one frozen UI scenario) would widen the net for
  the next stale-master-pointer-across-compaction bug at the cost of
  one more T2 boot. Every UI program shares the same runtime the
  toolbox suite's jiggle boot exercises, so the gap is real, not
  hypothetical.
