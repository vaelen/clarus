# Clarus TODO — technical debt and needed improvements, not yet scheduled

Condensed from completed phases' deferred/debt lists. The verbatim
context for every item is the originating phase's entry in
`docs/HISTORY.md` (named in the sub-heading or in parentheses) and that
phase's `.superpowers/sdd/<date>-<phase>/` ledger. Items here are
recorded, not committed — scheduling is `docs/ROADMAP.md`'s job. This is
a to-do list, not a history: a fixed item is deleted, not struck through.

Ideas, "if it ever bites" levers, and other maybe-someday items live in
`docs/FUTURE.md` instead (split 2026-09-05).

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
  83` in `tests/mactest/coresuite_68k.sh`, `38` in `toolbox_68k.sh`, each
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

### native-array-return-and-fileh-guards phase (2026-09-06)

- **The read-only-directory close-errno check is a silent no-op under
  root and does not check `mkdir`** (`runtime/host/rt_fileh_test.c`,
  `test_openrf`'s forced-AppleDouble block, added by the phase's
  deferred-minors wave): the `EACCES` assertion is skipped when
  `geteuid() == 0` (root bypasses directory modes) without printing a
  SKIP, and `mkdir("rf_ro_dir", 0755)`'s return is unchecked, so a stale
  0555 `rf_ro_dir` left by a killed run surfaces as a confusing
  `close errno: openRF` failure rather than naming the directory. Two
  lines each.

- **`ArrReturn`'s independence-failure message is a 167-character source
  line** (`testsuite/core/cases_arr.cla`, the `assigned copy not
  independent` `tkFail`) in a file wrapped at ~72 columns — the same wave
  wrapped a 190-character comment for the same reason. Cosmetic; split
  the concatenation across two lines.

### AppleTalk phase (2026-09-07)

- **The listener teardown path has no runtime test.** The final fix
  wave's I3 made `rtAtalkPump`'s listener arm call `rtLsnStop(i + 1)`
  after `rtLsnSetFailed` when `rtLsnDevPoll` returns negative, so a
  listener that loses its `dspCLListen` is torn down (NBP name removed,
  device slot released, state back to `rtAtIdle`) instead of staying
  `rtAtActive` and permanently deaf. Nothing exercises it: the failure
  needs a real `.DSP` that then fails, and `mactest/adsp_68k.sh` SKIPs on
  every current boot disk. The change is pinned only by goldens (four
  `testdata/emitui/atalk_*.c.golden`, ten `testdata/cg68k/atalk_*.s`) --
  shape, not behaviour. Once the LaunchAPPL `AppleTalk`-file patch lands
  (Task 13), the cheap check is a subcase that kills the server mid-run
  and asserts the client's next `find` no longer sees the name.

- **`atalk_lock`'s stale-holder steal path is still racy between two
  waiters** (`tests/lib_atalk.sh`). The fix wave closed the UNLOCK half
  -- `atalk_unlock` now refuses to `rm -rf` a lock directory whose
  `pid` file is not `$$`, so a waiter that stole a dead holder's lock and
  then exited can no longer delete a second waiter's live lock. The STEAL
  half is unguarded: two waiters that both observe the same dead holder's
  pid can both `rm -rf` and both `mkdir`, and the second `mkdir` succeeds
  because the first `rm -rf` removed the directory it had just created.
  Pre-existing shape, never observed, and it only costs determinism on a
  test group (two LToUDP stacks racing for node ids, which is exactly what
  the lock exists to prevent). Real fix: make the steal an atomic
  `mv`-into-place of a uniquely named directory, or drop the mkdir mutex
  for `flock` on a lock FILE where the platform has it.

## Compiler: type checking

### AppleTalk phase (2026-09-07)

- **Text out-parameters accept a `string`, and nothing but `cc` catches
  it.** Every `text` out-parameter in the language -- `file.readText(path,
  t)`, `fh.readAt(pos, n, t)`, `svc.call(target, op, req, reply)` -- is
  registered in `clarusc/check.cla` as an ordinary `psPlain(TextT)`
  parameter, and a `string` argument is admitted there by the ordinary
  string->text call-argument coercion. Lowering then passes an
  out-parameter through UNCOERCED (deliberately -- the callee must write
  into the caller's own storage), so a `string` argument arrives at a
  `rt_text *` parameter as a `clar_str_255 *`. For `readText`/`readAt`
  the callee is an intrinsic whose prototype takes `rt_text` by value, so
  `cc` errors and the user is stopped; for `svc.call` the callee is a
  lowered Clarus function, so `cc` only WARNS and the program ships with
  a wild write into the string's storage. The AppleTalk phase's fix wave
  put a one-off `typeKind(...) != TyText` guard on `svc.call`'s fourth
  argument (`testdata/errors/svc_call_reply.{cla,expect}`) because that
  was the site with the silent failure mode; the general fix is real
  out-parameter typing in the checker -- a parameter-shape flag that
  suppresses the coercion and rejects any argument whose kind is not the
  declared one -- applied to the whole family at once, so the next
  `text` out-parameter added does not have to remember the guard.

## Language: feature-support queries (after the AppleTalk release)

- **A `system.has*()` family for optional platform features** (Andrew,
  2026-09-07, during the AppleTalk brainstorm). A program running on
  System 6 without the `.DSP` driver should be able to learn that and
  disable its ADSP features itself, rather than discovering it through
  a `failed` event. Shape: `system.hasADSP(): bool` first, then
  whatever other optional things need a check later (`.XPP`/zone
  calls, MacTCP, Gestalt-gated System 7 features). Mostly syntactic
  sugar over the corresponding Toolbox calls (`OpenDriver` probes,
  Gestalt selectors), but abstracting them lets the host lane answer
  the same questions (`hasADSP()` is `false` on the host until host
  ADSP lands, see `docs/FUTURE.md`). Scheduled AFTER the initial
  AppleTalk implementation ships, not inside it.

## Runtime / Toolbox robustness

### native-array-return-and-fileh-guards phase (2026-09-06)

- **A resource fork that SHRINKS between `fstat` and the copy still
  yields a truncated AppleDouble sidecar reported as success**
  (`runtime/host/rt_fileh.inc`, `rt_fh_sidecar_store`): the resource-fork
  entry length is written into the header from `st.st_size` BEFORE the
  copy loop, and the loop's `got == 0` break (end of file) exits early if
  the fork got shorter in between, so the header's length exceeds the
  data that follows it. The phase's `pread` follow-up made a read ERROR
  fail (errno preserved); this is the remaining short-copy path. Only
  reachable if another writer truncates the same open fork mid-store —
  host lane, AppleDouble path only (non-Apple host or
  `CLARUS_FORCE_APPLEDOUBLE=1`). Fix candidates: re-`fstat` after the
  loop and fail on a mismatch, or copy first and write the header last
  with the byte count actually copied.

## Compiler-on-Mac (`ClarusC.APPL`) — on hold

The Mac-resident compiler target is on hold (Andrew, 2026-09-05). Nothing
here matters until it resumes: compile-time performance and memory of
clarusc running ON a 68k Mac, the baked runtime IR/object-code (`CLIR`)
machinery that exists to make that fast, and the Snow boots that prove
it. Recorded so the work is not lost, not scheduled.

### ABI / performance

- **`cg_free_globals` is ~11 KB of glue duplicated into EVERY segment
  of ClarusC.APPL** (language-runtime-cleanup Task 7 found the symptom;
  measured 2026-09-06 on a `--listing` self-emit of `clarusc/macgui.cla`:
  46 segments, 3667 instructions / 369 release `JSR`s / ~11 KB per
  segment, ~500 KB of the 1.5 MB binary). The routine is backend-
  synthesized (not an `irFunc`), so it has no jump-table entry and is
  re-emitted per segment; it unrolls one `MOVE.L off(A5),D0; ...; JSR`
  group per handle-typed global, so ANY new compiler global shrinks every
  segment's 32 KB budget at once. That is what pushed `fpIntrCall3` over
  the ceiling (Task 7 split it into `fpIntrCall3`/`fpIntrCall3b` to
  recover ~10 KB) and the next compiler feature will hit the same wall.
  Two levers, either of which recovers a third of every segment: (a) a
  table-driven loop -- a constant-pool table of (A5 offset, kind) pairs
  and one release loop, ~200 bytes per segment instead of ~11 KB; (b) a
  jump-table slot so the routine lives in segment 1 only. Only
  ClarusC.APPL is anywhere near the ceiling (a user program has a
  handful of globals), which is why this sits in the on-hold section.

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
