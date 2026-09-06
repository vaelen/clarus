# Clarus TODO — technical debt and needed improvements, not yet scheduled

Condensed from completed phases' deferred/debt lists. The verbatim
context for every item is the originating phase's entry in
`docs/HISTORY.md` (named in the sub-heading or in parentheses) and that
phase's `.superpowers/sdd/<date>-<phase>/` ledger. Items here are
recorded, not committed — scheduling is `docs/ROADMAP.md`'s job. This is
a to-do list, not a history: a fixed item is deleted, not struck through.

Ideas, "if it ever bites" levers, and other maybe-someday items live in
`docs/FUTURE.md` instead (split 2026-09-05).

## Serial / connection

Grouped (Andrew, 2026-09-05) so they can be addressed together in one
serial/connection follow-up phase. The originating phase is the
sub-heading.

### Serial/connection phase (2026-08-16)

- **Host-lane `stdio` and `pty` transports for the serial ports**
  (Andrew 2026-08-30, from 68kbbs's standalone BASIC interpreter):
  `CLARUS_SERIAL_MODEM`/`CLARUS_SERIAL_PRINTER` accept only
  `listen:PORT` and `connect:HOST:PORT` today (`runtime/host/
  rt_serial.inc`'s `rt_ext_ConnHOpen`), so a host CLI program's only
  terminal is a TCP peer — 68kbbs's `scripts/basic.sh` has to start the
  binary listening and attach `nc` to it. Add two more spec values in
  the same parser: `stdio` (read fd 0, write fd 1; optionally raw-mode
  `tcsetattr` on open, restored at exit, for per-keystroke input) and
  `pty` (`posix_openpt`/`grantpt`/`unlockpt`, print the slave path;
  a master with no slave attached behaves like the `listening` state).
  Same env-var-at-open mechanism, no build flag — one binary serves
  any transport by how it is launched. The four functions that assume
  a socket must branch for non-socket fds: `ReadByte`/`Write`
  (`recv`/`send` → `read`/`write`, `ENOTSOCK` on a tty), and `Gone`,
  whose `MSG_PEEK` trick has no tty/pipe equivalent — keep a per-slot
  `gone` flag set when `read` returns 0. `FIONREAD` (`Avail`) and
  `select` (`Idle`) already work on ttys and pipes. Roughly 100 lines of
  C plus a `pipe()`-pair case in `rt_serial_test.c` and a spec
  paragraph; then a deliberate re-pin in 68kbbs.

- **Host `every`-timer gap in the CLI pump** (design doc
  `docs/superpowers/specs/2026-08-15-serial-connection-design.md` §6/§7)
  — `every` machinery is UI-runtime-entangled today; the host CLI pump
  services open connections only, not `every` timers. Deliberately not
  promised this phase.

- **Task 7 leftover minors, all deferred**: `serial_snow_test.go`'s
  `done()` blocks ~34s inside `runSnow`'s poll loop, suspending
  died-mid-run detection for that window (now
  `tests/lib_snow.sh`'s `snow_run`); `tests/conntest/listen.sh`
  has a stolen-port edge case.

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

## Compiler correctness / cleanup

### language-runtime-cleanup phase (2026-09-06)

- **Array RETURNS still abort on `emit68k`** (Task 9) — `func mk():
  int[4]` checks clean and runs on the host lane, but the native lane
  aborts: `cgRetNeedsHidden` (`clarusc/cg68k.cla`) knows `KStr`/`KRec`/
  `KErr` and not `KArr`, so an array result never gets a hidden-return
  slot. Pre-existing; §3.4 fixed the *parameter* ABI only. Task 9's
  `cgEmitStoreArr` guard now turns the reachable half of this into a
  diagnostic instead of a SIGSEGV, so the remaining gap is the missing
  feature, not a crash.

- **Handle-bearing fixed-array PARAMETERS abort on `emit68k`** (final
  review) — an array whose element carries a `text`/`list`/`map` (e.g.
  `func f(a: Named[2])` where `Named` has a `text` field) checks clean
  and runs on the host lane (by-value struct), but `emit68k` aborts with
  the generic `cgExpr: EVarRef non-scalar (str/rec/arr) reached in value
  context` message — the same one an array RETURN gets. Pre-existing (at
  7c9d5f8 every fixed-array argument aborted natively); this phase turned
  the scalar-element case into the working `KArr` borrow ABI and left
  handle-bearing ones exactly where they were. A clear diagnostic in
  `cgPushArgs`' by-value `KArr` arm (naming the handle-bearing element,
  not the generic value-context message) would be the code-side
  improvement.

- **`cpParamByRef` omits `KErr` where `cgParamByRef` has it** (Task 9) —
  a pre-existing host/native asymmetry in the `error` argument ABI, now
  documented in `cpParamByRef`'s own doc comment but not unified. Close
  it when something depends on the two lanes agreeing here.

- **clarusc's native self-compile sits near the 32 KB per-function
  ceiling** (Task 7) — `cg_free_globals` scales with `irGlobals.count`,
  so ANY new compiler global grows every segment, and adding the
  array-literal pool machinery pushed `fpIntrCall3` over. Task 7 split it
  into `fpIntrCall3`/`fpIntrCall3b` to recover ~10 KB. The next compiler
  feature will hit the same wall; the lever is another split, or making
  `cg_free_globals` iterate a table instead of unrolling.

- **`abort()` inside a global initializer does not propagate** (Task 8
  review) — newly reachable now that a global initializer may call a
  function, on BOTH lanes, and neither documented nor tested. The stub
  resets `cgCurFuncHasBail`, so the abort check is emitted; where the
  bail goes from `cg_init_globals` is the open question.

- **`cg_init_globals`' frame is invisible to `cgStackHeuristic`** (Task 8
  minor) and its `frameSize > 32767` guard runs on the floor-inflated
  measure frame rather than the real one. Neither is reachable today (the
  stub's frame is tiny); both are wrong in principle.

- **`cg_init_globals` still emits explicit stores for zero-valued
  constant initializers** (final review) — `var x: int = 0`, `= ptr(0)`,
  `= false` each cost a `MOVE.L #0,D0` / `MOVE.L D0,-N(A5)` pair (~30 of
  them in a UI program's stub) even though the startup sweep already
  zeroed that memory. §3.5's skip only covers DEFAULT-init (no `=` at
  all); a zero-valued EXPLICIT initializer of an all-zero type is the
  same case and isn't caught. A one-predicate extension to that skip
  would remove them.

## Runtime / Toolbox robustness

### language-runtime-cleanup phase (2026-09-06)

- **`file.rename("", x)` reaches `PBHRenameSync` with an empty name**
  (Task 4) — after the stat reuse, `rtFhDevStat`'s `""` branch returns
  true, so the empty-name case is no longer rejected before the trap.
  One-line guard candidate.

- **Sidecar `filehandle` minors** (Task 11) — `flush` fsyncs the unlinked
  temp rather than the `._` sidecar; `close` cannot report a failed
  write-back; the temp path is hardcoded `/tmp` and ignores `TMPDIR`.
  All three only bind on the AppleDouble path (non-Apple host, or
  `CLARUS_FORCE_APPLEDOUBLE=1`).

## Test coverage gaps (recorded by audits, mostly need real input/hardware)

- **cprint-lane `UiLaunchReal`** (real AppleEvent glue in
  `rt_ext_mac.inc`) has no test — every Retro68 build uses `--events`;
  needs a no-events Mac-lane smoke or real Finder launch.

- **Real modal halves** (`rtUiAskSaveChanges`'s `Alert(130)`,
  `rtUiAskOpen`/`rtUiAskSave`'s real SF halves) and **real
  mouse-tracking continuations** (`TrackControl`/`LClick`/
  `UiPopUpMenuSelect` branches) are `rtUiScripted`-gated and never
  exercised — need live input, the display's documented carve-out.

- **No automated abort-dispatcher-default test on either lane**; the
  C lane's UI dispatch loop has no abort-default check at all (parked —
  the opt-in cprint lane isn't where ClarusC.APPL builds).

- **`stringAt` return-arm/materialize consumption shapes** are
  read-verified, not hardware-exercised — add one assertion if touched
  again; the `textAt` core case never pins its freshness contract.

- **Dead runtime declaration**: the runtime's own `UiCurrentA5`
  (`runtime/clarus/uiscript.cla`) has no Clarus call site -- the `A5Live`
  suite case covers the codegen via its own local extern. Delete or wire
  up in a cleanup pass. (`UiNewMenuStr`, its former twin, was deleted by
  the language-runtime-cleanup phase, 2026-09-06.)

- **Suite bookkeeping minors**: the expected case counts are hand-written
  literals in the ported scripts too (`suite_report_check "$WORK/cap.out"
  82` in `tests/mactest/coresuite_68k.sh`, `38` in `toolbox_68k.sh`, each
  duplicated in that script's own doc comment), so adding a suite case
  still means editing two places per lane — the original
  `internal/mactest/coresuite_test.go` complaint, carried over by the
  go-retirement port rather than fixed. `caseIntMapGrowIter` lacks the
  masked-hash-collision partner pair a fuller test would pin.

- **Transient `emit68k` extern-record-decay crash** (2026-08-06,
  unconfirmed): one observed crash, 0/28 repro attempts. Repro ladder
  archived in `.superpowers/sdd/2026-08-06-toolbox-cookbook/
  repro-decay-crash/`. Recorded, not dismissed.

### extern-ptr-call phase (2026-08-27)

- **Retro68/cprint-lane (OnMac twins) restoration, remaining scope** — the
  `*/`-in-comment build break from `ae662a3` is FIXED (2026-08-28, with
  the drift it had been hiding: ten missing `FhH*` failure stubs from
  filesystem-api, `UiValidRect`/`UiNewMenuStr` wrappers from live-log);
  `TestCoreSuiteGUIOnMac` now compiles, links, boots, and runs 78/80.
  Remaining, deliberately unfixed pending a scope decision: (1) the two
  red cases (`FileHandleRW`, `DirOps`) fail BY DESIGN — binary-files gave
  this lane permanent-failure FhH stubs while also adding suite cases
  that need real file I/O, so the twin can only go green via real
  C-side HFS FhH implementations for this lane, lane-aware case skips,
  or accepting a documented 78/80. (The toolbox twin itself runs green,
  38/38 as of 2026-09-06.)

### Correctness-cleanup phase (2026-08-17)

- **`rt_ext_UiCompactMem` (Task 3's cprint-lane no-op stub for
  `CompactMem`) is unexercised** — no jiggle test targets the Retro68/
  cprint Mac lane (`TestToolboxSuiteJiggleOn68k` is native-68k-only); the
  stub compiles and links (the cprint toolbox twin runs 38/38) but no
  test ever drives it.

### Serial/connection phase (2026-08-16)

- **No committed emit-time fixture pinning the unchanged
  `lowUnsupported` rejection for `appletalk`/local-receiver shapes**
  (Task 5) — those shapes still reject the same way pre-phase; nothing
  regresses that specifically today.

- **No coverage for the >4-connections build error** (Task 5) — the
  cap exists and is enforced, just untested.

### binary-files phase (2026-08-22)

- **No fixture asserts `readAt`/`writeAt` with `count == 0`** (Task 5
  minor; final-review wave M5) — the `pos == EOF` case IS covered
  (`readAt(600,10)` past EOF, `readAt(512,100)` crossing EOF); only a
  zero-length request is unpinned. `rtFhWriteRaw`'s `n == 0` early
  return means a zero-length `writeAt` never reaches the device
  (correct, undocumented); `readAt`'s zero-length behavior is likewise
  unexercised.

### filesystem-api phase (2026-08-26)

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
  probe wave, Task 5's native `fileh_68k.cla` lane, and the
  `mactest/snow/clarusc_bake` gate (owed after any runtime-module addition,
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

## Compiler-on-Mac (`ClarusC.APPL`) — on hold

The Mac-resident compiler target is on hold (Andrew, 2026-09-05). Nothing
here matters until it resumes: compile-time performance and memory of
clarusc running ON a 68k Mac, the baked runtime IR/object-code (`CLIR`)
machinery that exists to make that fast, and the Snow boots that prove
it. Recorded so the work is not lost, not scheduled.

### ABI / performance

- **param-abi RSS increase (+4-9%) unexplained** — profile before
  further Layer-2/3 memory work; suspects are the call-site copy temps
  and classification side tables.

- **§1.7 double codegen** (layer1 findings doc): full fix needs
  relocation entries so emission becomes segment-independent — Layer 3
  (caching/architecture) scope.

- **Layer 2 systemic costs** (256-byte `Str255` etc.) untouched by the
  layer1 phase.

- **intmap Stage C candidates** (map-hashtable): `intmapHash` is the
  identity function — add a multiplicative mixer if an on-target
  measurement shows clustering; remaining int-keyed string maps to
  migrate (`recFieldsHeadByName`/`xrecSizeByName` in check.cla,
  `ast.cla`'s `externRetRegBy*` family, `checkEnumDecl`'s `seen`).
  Stage B's own premise (68k-lane win) is still unmeasured on-target.

- **`natLogCap` is 4096 bytes** — a multi-compile `ClarusC.APPL`
  session's `##CLARUS-LOG##` trailer clips at the tail. Raising it
  reblesses ~40 native goldens (`MOVE.L #4096,D0` in every `.s`); do it
  when a real session loses lines that matter.

### Bake / CLIR artifact machinery

#### string-perf phase (2026-09-02)

- **Second baked panic-message identity** — the object/bake format's
  `cgRelClsPanicMsg` carries exactly one codegen-emitted message
  (`cgListOobMsgIdx`, hardcoded at `cg68k.cla` record/resolve sites).
  The phase's inline `s[i]` sidestepped it by delegating its cold path
  to `rtStrIndex`; the next inline bounds check wanting its own message
  must either do the same or extend the format.

#### compiler-cleanup phase (2026-09-05)

- **`--rtbake --lane c` silently drops the `connection`/`filehandle`
  runtime** — a HOST program that uses either type compiles under
  `--rtbake` to C that CALLS `clar_fn_rtConnOpen`/`clar_fn_rtFhOpen`
  (etc.) without ever declaring or defining them, so the emitted C does
  not compile. **Pre-existing, not introduced by this phase**, and
  reproducible on `main`: `tests/conntest/testdata/echo.cla` (unchanged
  since go-retirement) forks 74,570 bytes from source vs 57,795 from the
  bake, the difference being the entire `rtConn*` family; a minimal
  `file.create`/`append`/`close` program forks 59,282 vs 52,371 the same
  way. **Why:** `bake.cla`'s `bakeModuleList` deliberately leaves
  `conn.cla`/`conn_c.cla` and `fileh.cla`/`fileh_c.cla` out of the
  **C-lane** baked chain (its own comment says so) because
  `driveManifestSplice` gates that pair on `usesConn`/`usesFileh` for the
  host lane, keeping every non-conn host program's manifest and IR
  indices byte-identical. But `driveCompile`'s `haveRtbake` branch
  **bypasses `driveManifestSplice` entirely**, so on the bake path
  nothing ever consults `usesConn`/`usesFileh` and nothing ever splices
  the pair. The 68k lane is unaffected — it splices conn/fileh
  unconditionally on both sides, which is why `tests/bake/connfileh.sh`
  (an `emit68k_pair`) has always passed.
  **Found by** the compiler-cleanup phase's close-out T2: spec §3.5's new
  `testdata/emitui/connpump_abort.cla` is the first fixture in the C-lane
  `bake/full_corpus_emitui` sweep to declare a `connection`. That sweep
  now SKIPs the shape with an explicit reason naming this entry, and the
  skip retires itself when the gap closes (it only fires when the
  from-source fork declares the entry point, the bake fork does not, AND
  the bake fork still CALLS it -- that third clause added by Task 11,
  2026-09-05, so a fixture that merely dropped an unused declaration
  cannot take the SKIP).
  **Two candidate fixes**, neither taken here (this phase's spec forbids
  touching `clarusc/bake.cla`, which would fire the 55-minute Snow
  `clarusc_bake` gate):
  (a) add `conn.cla`/`conn_c.cla` and `fileh.cla`/`fileh_c.cla` to the
  C-lane `bakeModuleList` unconditionally, mirroring the 68k lane —
  correct and simple, but it moves every existing host program's baked
  manifest and IR indices, so it needs its own bless;
  (b) extend the existing from-source fallback in `drive.cla` (the
  `bkManifestDriftPath` site that logs "falling back to a from-source
  compile" and re-enters `driveCompile` with `haveRtbake = false`) with
  `haveRtbake and not want68k and (usesConn or usesFileh)` — no
  `bake.cla` edit, no golden movement, reuses machinery that already
  exists, at the cost of a full recompile for those programs. `usesConn`/
  `usesFileh` are already set at that point (the user program is checked
  before the `haveRtbake` branch).
  **Repro** (runnable from this entry alone, from the repo root, using
  the snapshot-bootstrapped `build-run/clarusc-current`):
  ```
  $ build-run/clarusc-current --bake-ir --lane c -o RTC.clir
  $ build-run/clarusc-current emit --rtdir runtime/clarus/ -o SRC tests/conntest/testdata/echo.cla
  $ build-run/clarusc-current emit --rtdir runtime/clarus/ --rtbake RTC.clir -o BAKE tests/conntest/testdata/echo.cla
  $ wc -c SRC BAKE
     74570 SRC
     57795 BAKE
  $ grep -c 'clar_fn_rtConnOpen' BAKE
  1                       # one CALL, zero definitions -- BAKE does not compile
  ```

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

- **`bkReadObjCode` spins on a corrupt `nHoles` count** before the
  framing check fires (pre-existing).

- **Comment-drift minors** (clir-load-perf): `bkParsedValid` should
  state "lane cannot change mid-session"; `bkLoadOverrun` names only
  `bkGetByte` as a setter (four exist); `rtTextStringAt` cites a moved
  idiom; `bkCheckRtbakeHeader`'s header doc still names
  `bkHashTextFrom`; `drive.cla`'s "rtbakeBytes still held"
  parenthetical is wrong for the memoized drift-interleaving case.

#### filesystem-api phase (2026-08-26)

- **Pre-existing: the C (host) lane's `--rtbake` cannot compile any
  `filehandle` program** — `fileh*.cla` is not in `clarusc/bake.cla`'s
  `bakeModuleList` on that lane (found by Task 3's reviewer while
  checking the `prelude.cla` bake path; not introduced by this phase,
  not fixed by it either — the native/`emit68k` `--rtbake` lane is
  unaffected).

### Test coverage

- **No automated test of the 10-stage progress sequence**
  (clarusc-live-log) — order/count/`total` growth only exercised by
  real compile boots; the "Checking Whole Program" stage placement
  depends on the unconditional `native.cla` splice (comment not added).

- **`/tmp/l1src` frozen-source byte-identity procedure is stale**
  (predates param-abi's immutable-params rule); any future phase using
  it needs a fresh re-freeze.

#### filesystem-api phase (2026-08-26)

- **No test exercises `emit68k --rtbake [--testapi]` over a
  `file.info`-calling program** (Task 3's own deferred test gap) —
  closing test: one `tests/bake/` script asserting the bake path was
  taken (`bkRuntimeFuncBoundary > 0`) and that its output matches the
  from-source build's. Task 3's own manual `--rtbake`/`--rtbake
  --testapi` experiments (task-3-report.md) are the only current
  evidence this path works.

#### go-retirement phase (2026-09-05)

- **The Snow `macresident` / `macresident_failed_compile` scripts are
  ported but NOT live-validated** (Task 14) — `tests/mactest/snow/
  macresident.sh` and `macresident_failed_compile.sh` are faithful ports
  of `TestMacResidentClaruscOnSnow` / `...FailedCompileStaysAlive`
  (110-minute default settle, `CLARUS_MACRESIDENT_SETTLE` /
  `CLARUS_MACRESIDENT_DONE` overrides), but neither has been run to
  completion against real Snow: the Go twin needed ~12 h per run on this
  host and the one Snow instance is contended. The rest of the Snow lane
  (`serial_echo`, `pagefile`, `clarusc_boot`, `clarusc_bake`) has been
  booted; `roundtrip` has too. Closing
  action: run both once, opt-in (`CLARUS_SNOW_TESTS=1 make test
  T=mactest/snow/macresident`), when the screen and a long window are
  free, and record the durations.
