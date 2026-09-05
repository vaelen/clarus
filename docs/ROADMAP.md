# Clarus Roadmap

Living document — the authoritative record of sequencing and strategy
going forward. Updated 2026-08-15.

- Completed phases are archived verbatim in `docs/HISTORY.md`.
- Recorded-but-unscheduled follow-ups and phase debt: `docs/TODO.md`.
- `docs/clarus-language-reference.md` is the normative spec; where any
  other doc disagrees, the reference wins.
- Current-session state: `STATUS.md`. Per-task execution history lives in
  `.superpowers/sdd/*/progress.md` (gitignored scratch; git history is
  the durable record).

## Standing principles

**GUIDING PRINCIPLE (Andrew, 2026-08-07 — governs all future Toolbox work;
ratifies and extends the sunset follow-on):** any call into the Toolbox goes
through the appropriate `toolbox/*.cla` interface — runtime code included — to
unify the cprint and native backends and cut duplication. When a new feature
needs a new Toolbox function, enable the rest of that manager's interface at
the same time where feasible, rather than declaring one routine at a time.
Layering follows the 80/20 rule: the RUNTIME uses Toolbox calls directly, but
the majority of user code should never need to — most Toolbox routines hide
behind friendlier Clarus abstractions (e.g. cut/copy/paste is a simple
capability on text controls, not a Scrap Manager lesson), so a "standard"
application is written entirely through the lens of the Clarus language. The
catalog exists so users CAN drop to the Toolbox outside the common case, not so
they must. API-era discipline: prefer the Toolbox as defined by the 1980s
Inside Macintosh volumes (I–V; Volume VI covers System 7.0) — target System 6
features whenever possible, and gate any System 7-only feature behind a version
check (Gestalt) with a graceful fallback when the feature is absent.

**Standing rules:**

- `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (opt-in,
  ~55m) is the only proof that `ClarusC.APPL`'s default bake path works on
  real hardware — re-run it manually after any change to
  `clarusc/bake.cla` or `clarusc/macgui.cla`; neither T1 nor T2 boots it.
- A green native UI boot is not proof that handle discipline is sound:
  the stale-master-pointer-across-compaction bug class has passed on
  heap-layout luck before (found eight times so far — see HISTORY,
  runtime-ir-bake T2 blocker, the fallback-trigger-narrowing final fix
  wave, the filesystem-api phase's `rtUiTeWidestLine` find, caught
  only by the heap-jiggle gate on a byte-identical binary whose
  resource fork alone differed, and the 68k-call-result-release phase's
  `rtUiLdefDraw` find below — that one on a binary whose only difference
  was an ADDED suite case, not even a rebuild of the buggy function
  itself). Re-derive master pointers after any allocating call.

## Where we are (2026-08-17)

Everything through the serial-connection phase is merged to `main`:

- **clarusc is the only compiler** — self-hosted (the Go compiler is
  deleted, tag `go-compiler-final`), bootstrapped from the committed C
  snapshot `clarusc/clarusc.c` with `cc` alone.
- **Both targets work**: host builds via C emission (`clarusc emit` +
  cc against `runtime/host`), native 68k `.APPL` binaries via direct
  emission (`emit68k`, no C, no Retro68).
- **`ClarusC.APPL`** compiles Clarus programs ON a Mac: baked runtime
  source catalog (`'CLFS'`) + baked runtime IR/object code (`'CLIR'`
  v7; first-compile load window cut ~4.4x, repeat compiles in a session
  skip verify+parse entirely), live progress UI (`on App.log`),
  recoverable errors (`attempt`/`abort`).
- Retro68/cprint's Mac lane is already demoted to an opt-in diagnostic
  (`CLARUS_CPRINT_MAC_TESTS=1`); the C printer's first-class role is
  host builds.
- **The fenced `connection` type** is real end to end, serial as its
  first transport, both lanes, Snow-hardware-proved (serial-connection
  phase, merged 2026-08-16).

**`correctness-cleanup` phase (an interleaved detour, not on the
language-usability list below) is COMPLETE — merged to `main` (ff
`48a4696..3a4c054`) and pushed 2026-08-18:** the About box
now shows real app info in unscripted runs; a labeled `popup` with a
narrow declared width no longer collapses to an unclickable box;
div-by-zero (and INT_MIN/-1) is pinned as a runtime error on both lanes;
a new heap-jiggle stress mode + stale-master-pointer audit (3 real bugs
fixed, `TestToolboxSuiteJiggleOn68k` gated native boot added) make that
bug class deterministically testable instead of heap-layout luck; the
`error`-return hidden-pointer ABI gap is closed; `get(k, dv)`'s
evaluation order now matches host on native; two memory leaks/fd-reuse
gaps are closed; three checker guards (widget-property fill-in-place,
`toBytes` receiver-kind keying, xrec forward-reference) are tightened;
the PBM icon parser accepts CR/CRLF; and the Bookmark Manager reference
erratum is fixed. Full detail: `STATUS.md` §1, or (once merged)
`docs/HISTORY.md`.

**`binary-files` phase (branch `binary-files`, 2026-08-22/23) is
COMPLETE — full T2 green, NOT YET merged (merge only on Andrew's
request):** closes item 1 below, "Next: language usability"'s next
item after serial. All eight 68kBBS language gaps closed in one phase
(`filehandle`, `connection` as a value, `text` binary accessors +
`crc16`, `string(n)`, the `toolbox/` include fallback, no more emit68k
big-temp ceiling) plus four compiler bugs found and fixed along the
way (`checkConstDecl` identical-redeclaration tolerance; a host-lane
use-after-free releasing a string->text coercion temp before a
`return call(...)` line that used it; the native lane's sibling bug in
the same spot, `cgReturnStmt` clobbering D0 with a temp-release call
before the branch out, fixed with a D0 save/reload; and a `--rtbake`
lowering crash for any `connection`/`filehandle`-using program, found
by this phase's own close-out T2 run and fixed by sourcing runtime-call
arg coercions from statically-known types instead of a checker
symbol-table lookup the baked-IR fast path never populates). Full
detail: `docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-22-binary-files/`.

**`transfer-crcs` phase (branch `transfer-crcs`, 2026-08-25, based on
`main` at `26d6748` — `binary-files` is already merged) is COMPLETE —
full T2 green, NOT YET merged (merge only on Andrew's request):**
`text.crc16x` (CRC-16/XMODEM, bitwise) and `text.crc32` (CRC-32/
ZMODEM, table-driven, table built lazily into a heap block on first
call) on both lanes, driven by 68kBBS's XMODEM/YMODEM/ZMODEM needs.
Array-literal initializers (the language feature that would let the
`crc32` table be a build-time constant instead of a lazily-built heap
block) filed in `docs/TODO.md`. Full detail: `docs/HISTORY.md` (once
archived) or `.superpowers/sdd/2026-08-25-transfer-crcs/`.

**`filesystem-api` phase (branch `filesystem-api`, 2026-08-26, based on
`main` at `8b8e8e2` — `transfer-crcs` is already merged to local `main`,
NOT pushed) is COMPLETE — full T2 green, NOT YET merged (merge only on
Andrew's request):** `file.makeDir/delete/list/exists/info/setInfo/
rename/move` on both lanes, closing the remaining 68kBBS filesystem
gaps (FTN packet directory management, catalog dates, HFS-shaped
names). A new predeclared `FileInfo` record (via a
`runtime/clarus/prelude.cla` splice ahead of the standalone user-code
check) carries `file.info`'s seven fields; the host lane translates
HFS `:`-paths to POSIX; the native lane drives
`PBGetCatInfo`/`PBDirCreate`/`PBCatMove` (the `_HFSDispatch` family,
selector in D0) plus `PBHDelete`/`PBHRename`/`PBHGetFInfo`/
`PBHSetFInfo` behind one new native global, `rtFh68kState`. Hardware
findings worth remembering: `PBHRename` needs a bare leaf name + the
real parent DirID, every other HFS call accepts `ioDirID = 0` + a
partial path; `""` names the program's own folder for every
folder-taking call on both lanes. System 7 (Snow) verification is
UNVERIFIED — deferred, see `STATUS.md` §0. Full detail:
`docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-26-filesystem-api/`.

**`extern-ptr-call` phase (branch `extern-ptr-call`, 2026-08-27/28, based
on `main` at `74c9e46` — `filesystem-api` and everything before it are
already merged to local `main`) is COMPLETE — full T2 green at the
final-review fix-wave tip `cac7ff1` (opus whole-branch review READY WITH
FIXES → fix wave, re-review clean), NOT YET merged (merge only on
Andrew's request):** a new `external func` clause,
`= ptr` (conv 10), calls through a runtime pointer with the plain pascal
calling convention instead of a fixed trap number — the way to reach
loaded code (a plugin/door module fetched with `GetResource`, 68kBBS
territory) on both lanes, which had no language surface at all before
this phase. The declaration's first parameter is the call target
(consumed as the jump address, never pushed); everything after it
marshals exactly like a plain pascal `trap` clause. Native codegen
factored the pascal arg-push loop out of the existing trap path
(`cgPushPascalArgs`, conv 1/9 emission proven byte-identical, no
rebless) and reuses it for the new saved-target `JSR (A0)` + `ADDQ`
sequence; the host lane casts through the same wire types a `callback
func`'s glue already conforms to, so a callback's bare name is a valid
`= ptr` target with no special-casing. Hardware-proved on the System 6
Mini vMac native lane via the core suite's new `PtrCall` case (a word-
and a bool-returning round trip; 80/80). Found and fixed one real
`internal/reftest` gate break along the way: the reference's own new
worked example didn't check clean standalone (bare top-level statements,
an undeclared variable) — fixed by wrapping it in a function, with the
`CheckClean` fence manifest updated for the two new fences this phase's
reference edit added. Deferred: a named-target `= ptr(name)` form and
register-convention (`reg`) targets, both filed in `docs/TODO.md`. Full
detail: `docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-27-extern-ptr-call/`.

**`68k-call-result-release` phase (branch `68k-call-result-release`,
2026-08-29, based on `main` at `0148c6a` — `extern-ptr-call` and
everything before it are already merged to local `main`) is COMPLETE —
full T2 green, NOT YET merged (merge only on Andrew's request):** fixes a
real `emit68k` memory leak (`../68kbbs/docs/memory-leak.md`): a user
function's handle-typed result (or a textview `.text` getter box)
consumed directly — as an argument, operand, or receiver — was never
released. Fix is producer-side tracking in `cg68k.cla`: `cgCallFnScalar`
and the `IUiGetTextviewText` arm spill their +1 result into a
`cgNewTrackedTmp` slot with `cgLastTrackedOff` set last, so the existing
`SAssign`/`SReturn` handoffs and the end-of-statement flush release it
like any other tracked temp. Two hardenings landed alongside: a
`cgLastTrackedOff` latch/restore in `cgEmitStoreScalarAny` (keeps a
dst-address side-effect from stomping the src's own verdict) and a clear
before value evaluation in the six container-set/push arms (keeps a
tracked receiver from being handed off in place of the value). Two
enablers were needed first: `cgTmpSlots` bumped 14 -> 24 (a real
in-tree cprint statement sits at exactly 21 concurrent tracked temps
post-fix, with a full mechanical golden rebless) and a `fpIntrCall12`
split in `cprint.cla` for CODE-segment headroom (output-neutral,
byte-diff-proven). Proof: `internal/cg68k/callresult_release_test.go`
(listing-level release-count pins across direct/local/receiver/operand/
getter shapes) plus the toolbox suite's new `LeakCheck` case (FreeMem
exactly flat, 3570496 -> 3570496, across 1500x4 direct-consumption
shapes on the emulated Mac Plus; toolbox suite now 33 cases, 32 real +
`SelfCheck`). Host lane is untouched (already correct) and unaffected.
**Close-out found a real T2 red** on `TestToolboxSuiteJiggleOn68k/
Popuptable` (only the visual checksum triple failed; every logical
assertion passed) — a per-commit bisect (one native boot each) proved it
PRE-EXISTING, not a codegen regression: the first bad commit is
`520f227`, which is test-only (adds the 33rd suite case, `LeakCheck`);
every codegen commit in the phase passes the gate standalone. Root cause,
confirmed with a heap probe: `rtUiLdefDraw` (`runtime/clarus/uitable.cla`)
derived its row's master pointer via `rtListAt` ONCE, above the per-column
loop, then let three allocating calls per column (`UiNewPtr`/`UiNewRgn`/
`UiGetClip`) run before reading through it — the exact "stale master
pointer across compaction" class this file's own Standing rules section
already tracks (now eight instances). `LeakCheck` merely grew the image
and the suite's own case-row list enough to shift heap layout past the
tipping point; the bug itself predates this phase. Fixed in `bff3268`
(`runtime/clarus/uitable.cla`, +29/-2: the derive moves inside the column
loop, immediately before the read; a second latent instance of the same
defect in the `RtFtChar` column-draw arm fixed alongside). Shared runtime
file — the host/cprint lane had the identical bug (same two hunks in the
emitui golden diff); the fix is not native-only. `internal/cg68k` (55
fixtures) and `internal/emitui` (14 fixtures) goldens reblessed
mechanically. Four more sites with the same shape (an unlocked master
pointer handed to or held across an allocating Toolbox call) were found
but NOT fixed — filed in `docs/TODO.md`. Close-out's T2 also caught a
second, smaller, unrelated pre-existing gap: `internal/bake`'s own
hand-maintained toolbox-suite file-list mirror was missing the
`LeakCheck` case's own fixture file since Task 4, only reachable via the
opt-in `CLARUS_BAKE_FULL=1` step T2 hadn't run to completion until now;
fixed in `cd43280`. Deferred, filed in
`docs/TODO.md`: the `makeRec().field` receiver-context
sibling leak (one type-kind over, out of scope per spec); extending
`testdata/cg68k/smalltmp_ceiling.cla` to pin the new 24-slot ceiling
(optional polish); a host-lane parity note on `pop`/`shift` used as an
operand or receiver (both lanes leak it identically — pre-existing,
out of scope). **The whole-branch final review then found one Critical
at a control-flow seam, also PRE-EXISTING** (this phase only made it
routine): `cgAndOr` short-circuits the RIGHT operand with a real runtime
branch, but tracked-temp registration is emission-time, so the
end-of-statement flush emitted an UNCONDITIONAL release of the right
operand's temp slot past the merge label — on the short-circuit path
that slot was never written this statement, holding either a stale handle
handed off earlier in the same statement (`s = h()` then `if flag and
g().length > 0` — a DOUBLE release of `s`'s live box) or frame garbage
(the pre-existing intrinsic-birth variant, `if flag and (a + a).length >
0`, which bites on `main` too). Fixed by mirroring cprint's guarded temp
scope: `cgAndOr` marks the tracked list before evaluating the right
operand and releases + untracks everything born past that mark on the
operand's own fall-through path, before the branch to the merge label
(D0/D1 bracketed, since Y's bool result is live in D0). Both operands are
bool-typed, so no temp born there can be the expression's own value — the
early release is unconditionally safe, and nested `and`/`or` composes
naturally (each level untracks only past its own, deeper, mark). Pinned
at the listing level by `TestAndOrShortCircuitRelease` (asserts the
release sits INSIDE the guarded region, not just that it happens once)
and on hardware by a new short-circuit shape inside `LeakCheck`, whose
FreeMem assertion is now flat in BOTH directions (a double release frees
early — the opposite signature of a leak). No golden rebless: no `cg68k`
fixture has an and/or with a tracked birth in its right operand. Full
detail: `docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-29-68k-call-result-release/`.

**`textview-scroll-to-end` phase (branch `textview-scroll-to-end`,
2026-08-29, based on `main` at `36b76ab`) is COMPLETE — full T2 green,
MERGED to local `main` 2026-08-29 (ff 36b76ab..8d4c2e5, NOT pushed):** one new widget method, `textview.scrollToEnd()`
(`../68kbbs/docs/language-gaps.md` §9's log-window ask), wired along the
canvas-method path (`check.cla` `textviewMethods` -> `lower.cla`
`lowTextviewMethod` -> `ui_scroll_to_end` intrinsic -> `cg68k.cla`/
`cprint.cla` one-arm forwarders -> `rtUiWidgetScrollToEnd`,
`uiwidgets.cla`), hardware-proved by the toolbox suite's new `ScrollToEnd`
case (34 cases) via a new `UiTestTextviewScroll` probe; the shelved
implicit follow-if-at-end setter semantics were rejected (ambiguous when
content fits — spec §Problem). Three deviations from the plan: (1) `peekw`
zero-extends but QuickDraw Rect fields are signed, so the plan's runtime
code (copied from `rtUiTeScrollSync`'s shape) went wrong by 65536 once a
scrolled TE's `destRect.top` goes negative — fixed with a new
sign-extending helper, `rtUiPeekSw` (`uiwidgets.cla`), applied to every
Rect-field read in both new functions; (2) the plan's Task 2 file list
missed two required edits (a `shakeAddRoot` line in `lower.cla` and an
`iUiScrollToEndIdx = -1` reset in `ir.cla`), both caught by failing tests,
whose always-on root renumbered every UI program's jump table and forced
a mechanical rebless of 3 `internal/cg68k` fixtures (12 `.s` files) and 12
`emitui` `.c.golden` files; (3) the suite's first emulator boot exposed a
pre-existing bug this phase's own code shares a root with: `rtUiTeScrollSync`'s
clamp compared a zero-extended `destRect.top`, so any `textview` shrunk
while scrolled past its own top was stranded off the end — fixed at the
root by moving the three `destRect` readers (`uitext.cla`, `uiwidgets.cla`)
onto `rtUiPeekSw` too, with a further golden rebless. Spec:
`docs/superpowers/specs/2026-08-29-textview-scroll-to-end-design.md`;
ledger `.superpowers/sdd/2026-08-29-textview-scroll-to-end/`.

**`string-perf` phase (branch `string-perf`, 2026-09-02, based on `main`
at `54292df`) is COMPLETE on its branch — T1 green per task, full T2
pending merge decision, NOT merged:** removes the two dominant measured
string costs on the native lane and adds the warm-buffer text idiom.
Origin: 68kbbs's Snow bench doc traced ~200 ms/row table draws to
Clarus string ops; three read-only code traces plus a new in-repo
calibration bench (`testdata/bench/strbench.cla` + `TestStrBench68k`,
promoted as a permanent measurement instrument) replaced that doc's
guessed model — no Memory Manager traps and no per-char copy on
`string` returns (both hypotheses wrong); the real flat cost was
`cgEmitFunc`'s full-capacity zero loop per string local per call
(~0.48 ms/local measured), plus `s[i]`/`s.length` as out-of-line
`rtStrIndex`/`rtStrLen` calls (~30 instructions of overhead each).
Changes: (1) a plain string local's default-init is now a single
length-byte clear (`cgDefaultInitStrLenOnlyAt`), gated on a zeroed-tail
probe that verified every consumer on both lanes is length-bounded
(ledger Task 1 — globals/record fields/array elements/error messages
keep the whole-slot zero); (2) `IStrLen`/`IStrIndex` emit inline
(unsigned CMP+BCS bounds check; the out-of-range cold path delegates to
`rtStrIndex` for exact panic parity, deliberately avoiding a second
`cgRelClsPanicMsg` identity in the object/bake format); (3) new `text`
methods `clear()` (len=0, capacity kept, zero traps) and `reserve(n)`
(public `rtTextGrow` wrapper), both lanes, reference documented.
Proof: core suite grew to 81 cases (`StrPerf`), toolbox to 35
(`ClearWarm` — FreeMem EXACTLY flat, no slack, across 200 clear+refill
cycles on hardware); after-bench `mklocal4` 10549→1268 ticks (8.3x) and
`strindex` ~71→~24 us/index; snapshot regenerated to fixed point in one
pass. Notable finds: `fpIntrCall3` trips the 32KB segment limit with
two more arms (clear/reserve landed in `fpIntrCall13` per its own
precedent); Mini vMac bench rows are bimodal across runs of the same
binary (TODO.md). Spec:
`docs/superpowers/specs/2026-09-02-string-perf-design.md`; plan
`docs/superpowers/plans/2026-09-02-string-perf.md`; ledger
`.superpowers/sdd/2026-09-02-string-perf/`.

**`go-retirement` phase (branch `go-retirement`, 2026-09-05) is COMPLETE:**
the project no longer depends on a Go toolchain at all. The Go compiler was
already deleted (tag `go-compiler-final`); what remained was the TEST
harness — 58 files and 14,268 lines of Go under `internal/` (53
`*_test.go` plus five non-test helpers), driving every gate from `hostrt`
C unit checks to Mini vMac and Snow emulator boots. All of it is ported to
a Make + POSIX-shell runner: a root `Makefile` (`make -j t1`, `make t2`,
`make test T='<group>/<name>'`, `make smoke`), a frozen `tests/lib.sh`
vocabulary plus per-group `tests/lib_<group>.sh` helpers, 117 test scripts
(~7,300 lines of sh all in, helpers and runner included), and five small C
tools (`tests/tools/{timeout,uiblob,resfork,clirhdr,tcpdrive}.c`, 1,442
lines) replacing the Go-side helpers that could not be expressed in sh —
a process-group-killing `timeout`, the UI-blob and resource-fork dumpers,
the CLIR-header reader/corrupter, and the TCP driver the `connection`
tests need. `internal/` and `go.mod` are deleted; the two
wrappers (`scripts/test-task.sh`, `scripts/test-merge.sh`) now call Make
stages and print a `PASS in Ns` line each.
Notable design points: the runner has NO result cache (every invocation
re-executes every selected script), which closes by construction the
stale-PASS hole `-count=1` existed to patch; a script's verdict is
`PASS|SKIP|FAIL(...)` with exit 77 = SKIP, and a `FAIL ` line in the log
beats exit 0 AND exit 77, so a script that reports a failing subcase and
then skips can never launder itself into a SKIP; each script carries its
own `# timeout:` header instead of a remembered `-timeout 30m` flag; and
`tests/runner/{selfcheck,syntax,timeout}.sh` are self-checks on the runner
itself (verdict precedence, `sh -n` over every `tests/**/*.sh`, the
timeout tool's process-group kill) after an unguarded helper source once
produced a green PASS with zero assertions — every helper source line is
now `... || die "helper lib failed to load"`. The perfgate tripwire's
long-standing under-load flake (`docs/TODO.md`) is closed structurally:
`perfgate/` is excluded from `t1` and run alone by both wrappers, and the
baseline was re-measured on a quiet host at the end of the phase (and the
idle host turned out ~40% SLOWER than a warm one on this single-threaded
emit, which is why `tests/perfgate/baseline.txt` now records both
regimes). The Snow (System 7 / Mac II) lane came across too, opt-in behind
`CLARUS_SNOW_TESTS=1`; its `clarusc_bake` script PASSED on real hardware
at 3303 s, discharging the standing `ClarusC.APPL` bake-path obligation
earlier phases owed. Two Snow scripts (`macresident`,
`macresident_failed_compile`) are ported but not yet live-validated, and
`roundtrip` is red on this System 7 machine exactly as its Go twin was —
both filed in `docs/TODO.md`. Spec:
`docs/superpowers/specs/2026-09-05-go-retirement-design.md`; plan
`docs/superpowers/plans/2026-09-05-go-retirement.md`; ledger
`.superpowers/sdd/2026-09-05-go-retirement/`.

**`compiler-cleanup` phase (branch `compiler-cleanup`, 2026-09-05, based
on `main` at `311af68` = `a1f9899` + this phase's own spec/plan/TODO
docs; `go-retirement` and everything before it are already merged to
local `main`, NOT pushed) is COMPLETE — full T2 green, NOT YET merged
(merge only on Andrew's request):** clears `docs/TODO.md`'s "Compiler
correctness / diagnostics" section outright. It had grown to 30 entries
across seven phases (2026-07-23 to 2026-08-29) — one FIXED record and 29
open — and several of them forced the same expensive regeneration (every
`testdata/cg68k/*.s` golden, the `clarusc/clarusc.c` snapshot), so
fixing them a phase at a time meant paying that cost repeatedly. All 29
are disposed of in one phase, structured as two waves so the goldens are
blessed exactly twice and the snapshot regenerated exactly once: **26
fixed**, **1 already fixed** (the `cgLastTrackedOff` reset had landed in
the 68k-call-result-release phase; the TODO entry outlived its own fix),
**1 obsolete** (parameter-escape precision — the analysis it refined was
deleted in `e4b592f`), and **1 closed with evidence** (the entry recorded
since binary-files as "STILL LIVE: an unspliced runtime function crashes
clarusc" does not reproduce; `tests/cg68k/unspliced_guard.sh` pins the
actual behavior, `cg68k: rtStrStore not found/reachable` with exit 1 — a
clean diagnostic, never exit 3). Wave 1 (runtime + harness) blessed 77
golden files, with a differential oracle proving every hunk was a
runtime-edit ripple; wave 2 (the compiler) blessed 64, of which 18 were
stale `*.seg2.s` files DELETED because the fixtures shrank back below
their segment boundary. The `.s` corpus went **501,110 → 478,983 lines,
−4.42%** — item e alone (a synthesized `clar_conn_pump()` stub, empty
unless the program uses `connection`) is −4.30%, paying back the +5-7%
conn-runtime tax the TODO had recorded as a cost; the per-function
small-temp high-water contributes ~95 bytes of frame per function. Also
closes the three follow-ups 68k-call-result-release deferred
(`makeRec().field`, the `smalltmp_ceiling` fixture, `pop`/`shift` as
operand/receiver), brings the toolbox suite to 36 cases (`CasesTable`,
which checksums the suite GUI's own case table — the one stale-pointer
class nothing asserted on), and unblocks the opt-in cprint toolbox twin,
now 36/36. Honest limit, recorded rather than papered over: the four
remaining stale-master-pointer sites have **no deterministic
red-to-green test** — the master pointer is passed INTO an allocating
trap, so the jiggle harness's `UiNewPtr` waist cannot see it; proof is
the green native suite plus reviewer verification of each site. One new
follow-up opened, filed in `docs/TODO.md`: native and host now differ on
`pop`/`shift` tracking for a handle-bearing RECORD element
(`lst.pop().field` leaks on the native lane only), a deliberate
consequence of gating the native always-track on `cgIsHandleKind` rather
than `cgNeedsRelease` — the literal spec wording would have
double-released a block-copied `KRec` scratch. `clarusc/bake.cla` is
untouched, so the 55-minute Snow `clarusc_bake` gate did not fire.
Close-out's own T2 turned up two PRE-EXISTING defects, both filed rather
than fixed: `tests/bake/full_corpus_suite_toolbox.sh`'s hand-maintained
file list had drifted (missing `cases_casestable.cla`, the same
hand-mirrored-list defect `LeakCheck` hit in the 68k-call-result-release
phase — fixed in place, the list is now `diff`-identical to
`tests/mactest/toolbox_files.txt`), and `--rtbake --lane c` silently
drops the `connection`/`filehandle` runtime, so a HOST program using
either type bakes to C that calls `rtConnOpen`/`rtFhOpen` without
defining them (reproduced on `main` with
`tests/conntest/testdata/echo.cla`; the 68k lane is unaffected). The
second is `docs/TODO.md`'s new "Bake / CLIR artifact machinery" entry
with both candidate fixes worked out — neither is in this phase's scope,
one of them needs `bake.cla`. Spec:
`docs/superpowers/specs/2026-09-05-compiler-cleanup-design.md`; plan
`docs/superpowers/plans/2026-09-05-compiler-cleanup.md`; ledger
`.superpowers/sdd/2026-09-05-compiler-cleanup/`.

## Roadmap

Focus (Andrew, 2026-08-15): make the tools more usable — expand the set
of Toolbox managers Clarus programs can reach, add the language features
that work needs, and retire old parts of the toolchain. The user-module
compilation cache is deliberately de-prioritized (see "Later").

### Next: language usability

In order:

1. **Binary streams and files** — proper reading and writing of binary
   data, filling the gaps in the existing support. DONE (`binary-files`
   phase, 2026-08-22/23): closed all eight 68kBBS language gaps —
   `filehandle` (positioned file I/O, both lanes, hardware-proved on
   System 6 via Mini vMac and System 7 via Snow), `connection` as an
   ordinary int value (params/locals/fields, not just a global), `text`
   LE/word/setter binary accessors + `crc16`, `string(n)`, the
   `toolbox/` include fallback (+ `--rtdir` in check-only mode), and
   emit68k's per-function big-temp pool (no more per-statement
   ceiling). Full T2 green on branch `binary-files`; not yet merged
   (merge only on Andrew's request). Extended by `text.crc16x`/
   `text.crc32` (transfer-crcs phase, 2026-08-25) — XMODEM/YMODEM and
   ZMODEM CRCs on both lanes; array-literal initializers filed in TODO.
   Full T2 green on branch `transfer-crcs`; not yet merged (merge only
   on Andrew's request).
   Extended again by `file.makeDir/delete/list/exists/info/setInfo/rename/move`
   (filesystem-api phase, 2026-08-26) — directory/catalog management on
   both lanes, closing 68kBBS's remaining filesystem gaps. Full T2 green
   on branch `filesystem-api`; not yet merged (merge only on Andrew's
   request).
2. **Serial ports** — controlling the ports and sending/receiving data.
   DONE (`serial-connection` phase, 2026-08-16): the fenced `connection`
   type is real end to end, serial as its first transport, both lanes
   (native SCC/Serial Driver + host TCP dev-lane substitute), acceptance-
   proved on Snow hardware; merged to `main` 2026-08-16.
3. **AppleTalk.**
4. **MacTCP.**

Environment note for 2-4: `snow/MacII.snoww` + its hdd image are
already configured (2026-08-15): AppleTalk on the Printer port, a
TCP listener (port 1984) bridging the Modem port, and a DaynaPORT SCSI
Ethernet adapter running a NATted MacTCP instance (the emulated Mac is
10.0.0.2, gateway 10.0.0.1). Caveat: on a modern Mac the emulator
cannot attach to a tap device, so it can't reach the real Ethernet —
AppleTalk runs over UDP instead, which means two Snow instances running
simultaneously can see each other over AppleTalk (the way to test
AppleTalk peer-to-peer).

**Driving application: a BBS server** — first over the serial port,
later over MacTCP networking.

### Then

- **vdb database files** — easily create data files that follow the vdb
  specification (format details: the `vaelen/vdb` GitHub project) with a
  friendly Clarus surface, so defining a data file doesn't take a lot of
  boilerplate code.

### Later (no particular order)

- **Caching precompiled user code** — per-module precompiled artifacts
  for USER code, extending the runtime-side CLIR work. Staging notes:
  `docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`.
- **Retire Retro68** — the host-side cross-compiler keeps being built
  from clarusc-emitted C (`clarusc emit` + cc), but every on-Mac app
  builds through the native 68k backend (`emit68k`); the opt-in
  cprint/Retro68 Mac lane (kept until now as a cross-lane localization
  oracle) gets deleted.

More recorded candidates (`yield`/cancel, reciprocal packers, parking
lot): `docs/TODO.md`.

## Process conventions that worked (for future sessions)

- Doc-first: reference updated and committed BEFORE implementation plans;
  the reference is the compiler's contract.
- Subagent-driven development with per-task review gates and a whole-branch
  final review (most capable model) + one consolidated fix wave; reviews
  probe (compile/run/ASan), not just read.
- Feature branches per plan; main stays green; reftest may be red mid-branch
  when the reference gains fences for unimplemented features (manifest
  regeneration is always the branch's final task).
