# Task 5 report: `every` timers in the host CLI pump

Worktree `/Users/andrew/repos/clarus-wt/t5`, branch `appletalk-t5`, one commit:
`86ff1e9 feat(host): every timers fire from the host CLI pump loop`.

## What I implemented

**`clarusc/cprint.cla`**
- `irIsUiProgram()`: the `every` disjunct is now `(irEveryCount > 0 and want68k)`.
  NOT dropped outright, as drafted -- see "Deviations" below.
- `cpEmitMain()`: the pump loop is emitted when `irUsesConn or irEveryCount > 0`.
  Condition = OR of `clar_fn_rtConnAlive()` (if `irUsesConn`) and `1` (if any
  `every`), ANDed with `!clar_aborting` when `lowUsesAbort`. Body = the pumps the
  program actually has (`clar_fn_rtConnPump()`, `clar_fn_clar_every_pump()`)
  followed by `rt_ext_ConnHIdle(20)`.

**`clarusc/lower.cla`**
- New `lowSynthEveryPump()` beside `lowSynthConnPump`: builds `clar_every_pump()`
  as a flat SEQUENCE of `if EveryDue(i, ticks_i) { ui_every_i() }` (not
  `lowSynthFoldIfChain`'s if/else chain -- two timers can come due on the same
  pass and both must fire), self-rooted with `shakeAddRoot` because `cpEmitMain`
  calls it from hand-written C text.
- Registers two clause-less externs from inside that function (so a program with
  no `every` grows no prototypes): `EveryDue(int,int): bool` and
  `ConnHIdle(int)`. The second is needed because `rt_ext_ConnHIdle` is literal C
  text in `cpEmitMain` and its prototype otherwise only exists via `conn_c.cla`,
  which is spliced only when the program opens a connection --
  `irRegisterExtern`'s own lookup-before-append makes the re-registration a no-op
  for a conn program, so no ordering churn.
- Call site (beside `lowSynthConnDispatchers`, inside the `lowSkipUiDispatchers`
  guard): `if not want68k and irEveryCount > 0 and not irIsUiProgram()`.
- `lowUiPortAddRoots`'s gate (the duplicated `irIsUiProgram()` condition) grew the
  same `and want68k` conjunct. Without it a non-UI host program with `every` still
  rooted `rtUiStartup`/`rtUiRun`, keeping the whole UI runtime reachable.

**`runtime/host/rt_ext_host.inc`** -- `rt_ext_EveryDue(idx, periodTicks)` right
after `rt_ext_TickCount`: `static int32_t due[16]` + `static unsigned char
armed[16]`, first call per idx arms (`now + period`, returns 0), later calls
return 1 and re-arm when `now - due >= 0` (signed difference, wrap-safe). Range
guard returns 0 past 16 slots; a period < 1 is clamped to 1.

**`docs/clarus-language-reference.md`** (Serial section, one sentence): "...stays
alive while any connection remains open, an event is pending, or an `every` timer
is declared (a timer never disarms, so such a program runs until `quit`), pumping
them, and only exits once none of those holds...". Edited with a byte-exact
Python replacement of an ASCII-only substring; the file's 7 non-ASCII lines are
untouched (count and `git diff --stat` = 1 line changed).

**New:** `testdata/emitui/every_cli.cla` + `.c.golden`, `tests/conntest/every.sh`.

## TDD evidence

RED (Step 1, before any implementation), `clarusc emit` on the new fixture:
```
$ build-run/clarusc-current emit --rtdir runtime/clarus/ -o /tmp/e5.c testdata/emitui/every_cli.cla
$ grep -n 'rt_ui.h\|int main' /tmp/e5.c
3:#include "rt_ui.h"
9184:int main(int argc, char **argv) {
        clar_fn_rtUiStartup(); clar_fn_rtUiLaunch(); clar_fn_rtUiRun();
$ cc -O1 -I runtime/host -o /tmp/e5 /tmp/e5.c runtime/host/rt.c
/tmp/e5.c:3:10: fatal error: 'rt_ui.h' file not found
```
So: it took the UI main path; the CHECKER did NOT reject `every` without a window.
**No `clarusc/check.cla` change was needed** (Task 3 keeps that file to itself).

GREEN, same command after the change:
```c
int main(int argc, char **argv) {
    clar_init_globals();
    rt_register_cleanup(cl_free_globals);
    rt_args_init(argc, argv);
    clar_fn_handler_App_startCLI(rt_args_list());
    while (1) {
        clar_fn_clar_every_pump();
        rt_ext_ConnHIdle(20);
    }
    return 0;
}

static void clar_fn_clar_every_pump(void) {
    if (rt_ext_EveryDue(0, 6)) {
        clar_fn_ui_every_0();
    }
}
```
no `rt_ui.h`; builds against `runtime/host` and runs: `start / tick 1 / tick 2 /
tick 3`, exit 0, 0.32-0.44 s unloaded (measured three times).

Conn + every + abort together (scratch program, not committed) emits and behaves
correctly -- this is the case the parenthesization fix exists for:
```c
while (!clar_aborting && (clar_fn_rtConnAlive() || 1)) {
    clar_fn_rtConnPump();
    clar_fn_clar_every_pump();
    rt_ext_ConnHIdle(20);
}
```
run under `timeout 5`: prints `boom`, exit 1 (prompt abort, loop not wedged).

## Tests

- `make -j t1`: **89 passed, 30 skipped, 0 failed** (baseline before my test
  existed was 88/30; the new script is the +1).
- `make test T='conntest/every emitui/'`: 6 passed, 0 skipped, 0 failed.
  `emitui/goldens` actually RAN (not skipped) because I symlinked
  `toolchain`/`Retro68` (gitignored) into the worktree -- so the new golden is
  also proven to `m68k-apple-macos-gcc -c` clean, same as every other golden.
- Native-lane differential, pre-change snapshot compiler vs the built one,
  `emit68k` to identically-named files (the MacBinary header carries the output
  name, so different names always differ):
  `every_cli.cla`, `every.cla`, `app_nonui.cla`, `examples/texteditor.cla` -- all
  four **byte-identical**.
- `git status testdata/` after the change: only the two NEW `every_cli` files.
  **Zero `testdata/cg68k` churn**, zero churn to any existing golden.
- Not run (per the brief): perfgate, `--smoke`, emulator, T2.

## Deviations from the brief (3, all deliberate)

1. **`irIsUiProgram` keeps its `every` disjunct behind `want68k`** instead of
   dropping it. The brief reads as if that predicate were cprint-local; it is
   not -- `cg68k.cla` reads it in a dozen places (UI startup path, `SIZE(-1)`
   flag word, UI blob/events segments) and `lower.cla` reads it too. Dropping the
   clause outright would silently turn a NATIVE every-only program into a CLI
   program with no event loop and no timers -- no golden would have caught it
   (no such fixture exists), which is exactly why I checked. `want68k` is false
   only on the host lane (`main.cla:621`, `macgui.cla:636` sets it true), so the
   68k lane's answer is bit-for-bit what it was; the differential above proves it.
2. **A third conjunct on the synthesis gate:** `and not irIsUiProgram()`. Without
   it, a HOST program that has BOTH a window and an `every` block (i.e.
   `testdata/emitui/every.cla`) synthesized a `clar_every_pump` nothing calls --
   it still takes `cpEmitUiMain`, whose event loop fires its own timers -- and
   churned that program's committed golden. Caught by the test I wrote for
   exactly that ("every.cla golden unchanged"), which failed before this conjunct.
3. **The end-to-end timing ceiling is 8 s, not 2 s.** The run is 0.32-0.44 s
   unloaded, but 4 s under a full `make -j t1` -- the loop idles in 20 ms
   `usleep()`s whose real duration stretches with CPU contention, and the drafted
   2 s budget FAILED in the first full t1 run. Raised to 8 s for the same reason
   `tests/conntest/abort.sh`'s own header records for its 2 s -> 10 s raise. What
   the test proves is unchanged in kind: the ceiling catches a timer that arms but
   never comes due (and a hang, well inside the 10 s `$TOOLS/timeout` net), while
   the "fires three separate times, in order" claim comes from the fixture's shape
   (`n` counts to 3 and quits), not from the clock. A free-running timer would
   still produce the same transcript, so if you want that pinned by wall clock it
   needs a longer period (e.g. 60 ticks) and a LOWER bound -- `date +%s`'s 1 s
   granularity cannot express a lower bound on a 0.4 s run.

Also worth noting, not a deviation: the first fire is one full period after the
loop is reached (arming does not fire), matching the Mac lane, where
`rt_ui_every_desc[]`'s deadline is likewise set at startup rather than fired at it.

## Self-review

- Native lane untouched: zero cg68k churn, no `want68k` synthesis,
  `runtime/clarus/ui.cla` not opened. `emit68k` byte-identity proven on four
  programs including the new every-only fixture.
- Loop condition/body: as specified, plus the `&&`/`||` precedence fix (an abort
  that could never stop the loop is a real bug, not a style point).
- `every.cla` golden unchanged, asserted twice (emitui/goldens.sh, and again in
  `tests/conntest/every.sh` where it does not depend on the m68k toolchain).
- No checker change (none was needed -- see RED above).
- `LC_ALL=C grep -nP '[\x80-\xff]'` run on all four modified files before editing;
  the two `.cla` files and the `.inc` are pure ASCII (Python ASCII-mode writes),
  the reference was edited byte-exactly with binary I/O.

## Concerns

1. **`ConnHIdle` as the timer-only program's sleep.** It is the brief's own
   choice and it works (`usleep` when no slot is open), but a program with no
   connection now depends on `rt_serial.inc` for its tick delay, and the extern
   is registered from `lowSynthEveryPump` purely to get a prototype. If Task 8's
   AppleTalk pump reshapes this loop, a plain `rt_ext_Idle(ms)` would be the
   more honest name for what the loop actually wants.
2. **20 ms idle vs a 1-tick timer.** `every 1 ticks` (16.7 ms) cannot be honored
   on the host lane: the loop sleeps 20 ms per pass, so it degrades to ~20-33 ms.
   Nothing documents that ceiling. Native is unaffected.
3. **No committed test for the conn+every combination.** Verified by hand (above)
   but not pinned by a fixture; the parenthesization branch is therefore only
   covered by my manual run. A `connpump_every.c.golden` would close it -- cheap,
   and worth adding if the controller wants it before the merge.
4. `clarusc/clarusc.c` was deliberately NOT regenerated (the phase's convention is
   one snapshot-regen commit at close-out); `tests/selfhost/fixedpoint.sh` will
   fail in T2 until that happens.
5. The worktree has gitignored `toolchain`/`Retro68`/`vasm` symlinks I added so
   `emitui/goldens.sh` would actually run instead of skipping. They are absolute
   paths and invisible to git; delete the worktree as usual.

---

# Fix round 1 (review: Approved, 1 Important + 2 minors)

Commit: `fcd1fe7 test(conntest): every.sh asserts a wall-clock floor, not just a ceiling`. All three items addressed.

## Important -- `tests/conntest/every.sh` did not test periodicity

Correct, and I proved the reviewer's exact counter-example before fixing it.
Stubbed `rt_ext_EveryDue` to `return 1;` unconditionally (a scratch copy of
`runtime/host` in /tmp, patched, built with `-I /tmp/stubrt`):

```
$ t0=$(date +%s); /tmp/stubprog; t1=$(date +%s); echo "elapsed=$((t1-t0))s"
start
tick 1
tick 2
tick 3
elapsed=0s
```

Identical transcript, exit 0, 0 s -- the old test passed it on every assertion.

Fix, as suggested in my own concern #3-adjacent note:
- `testdata/emitui/every_cli.cla`: `every 6 ticks` -> `every 60 ticks`. Three
  fires now cannot physically happen in under ~3 s.
- `tests/conntest/every.sh`: the single `timing` assertion split into
  `timing_floor` (`elapsed >= 2`, allowing for `date +%s`'s whole-second
  truncation of a ~3 s run) and `timing_ceiling`. The floor is the load-bearing
  one -- contention can only push elapsed UP, never below it, so it is a stable
  assertion in a way the ceiling never was. The stub above measures 0 s and fails
  it immediately.
- **Ceiling: 10 s, with the outer net raised to `$TOOLS/timeout 20`** (my call,
  stated as asked). 10 s against a ~3 s nominal run is the same ratio abort.sh
  settled on; the net is kept clear of the ceiling deliberately, so a real
  overrun is reported as a timing FAIL carrying its measured seconds rather than
  as an opaque exit 124.
- `testdata/emitui/every_cli.c.golden` reblessed. Exactly one line moves, as
  predicted:
  ```
  1238c1238
  <     if (rt_ext_EveryDue(0, 6)) {
  ---
  >     if (rt_ext_EveryDue(0, 60)) {
  ```

## Minor -- stale `rt_ui.h` comment (`clarusc/cprint.cla`)

Rewritten. It claimed an every-only program still needs `rt_ui.h` because its
`main()` calls the ported `rtUiStartup`/`rtUiRun`; inside cprint that is now
false (`want68k` is always false by the time the printer runs). The replacement
says what actually happens -- every-only takes the ordinary CLI `main()` and the
pump loop, `every` still means UI on the native lane, and `irIsUiProgram()`'s
`want68k` conjunct is what draws the line -- and keeps the `app`-only clause,
which is unrelated and still true.

## Minor -- signed-overflow UB in the deadline compare

```c
-    if (now - due[idx] >= 0) {
+    if ((int32_t)((uint32_t)now - (uint32_t)due[idx]) >= 0) {
```
Same `uint32_t` idiom `rt_ext_TickCount` itself uses to build its result; the
comment above it now says so instead of describing a signed subtraction.

## Commands run

```
$ make test T='conntest/every emitui/'
PASS conntest/every 4s
PASS emitui/appinfo 0s
PASS emitui/errconst 0s
PASS emitui/goldens 3s
PASS emitui/popupguards 0s
PASS emitui/uiblob 0s
tests: 6 passed, 0 skipped, 0 failed

$ make -j t1
tests: 89 passed, 30 skipped, 0 failed

$ cat build-run/tests/conntest/every.log     # under the parallel t1 above
PASS build
PASS exit0
PASS output
PASS timing_floor
PASS timing_ceiling
PASS ui_golden_unchanged
```

(`T=` takes ONE variable whose words are prefixes -- `T=a T=b` silently keeps
only the last, which is why the command above is quoted as a single value.)

`git status testdata/` shows only the two `every_cli` files; still zero
`testdata/cg68k` churn, and no other golden moves.

## Concerns after this round

Unchanged from the original report except #3, which is now the only one I would
still act on: there is no committed fixture for the conn+every combination (the
`(rtConnAlive() || 1)` parenthesization branch), verified by hand but not pinned.
The test now costs ~3-4 s of wall clock in t1 by design -- that is the price of
the floor assertion, and I see no cheaper way to distinguish a real arming clock
from a free-running one.

---

# Fix round 2 (T2 sweep: `bake/full_corpus_emitui` byte-identity failure)

Commit: `747c4bd fix(bake): filter lowStrIdx to the installed pool on a truncating install`.

## Root cause -- a pre-existing bake bug my fixture was the first to trip

Not the `EveryDue` extern and not `clar_every_pump` ordering. The forks diverged
on the STRING LITERAL POOL, and the bake fork was not merely different, it was
**broken**: it emitted a reference to `clar_lit_129` into a pool of 126 literals,
C that could not have compiled.

```
$ diff src.c bake.c | head
394,400c394,399
<     clar_lit_120 = {5, {116, 105, 99, 107, 32}}     /* "tick " -- present  */
...
1230c1229
<     ... clar_fn_rtStrConcat(..., &(clar_lit_120), ...)
---
>     ... clar_fn_rtStrConcat(..., &(clar_lit_129), ...)   /* pool has 126 */
```

The chain, in `clarusc/bake.cla`:

1. `bkInstallArenas(testapi=false)` TRUNCATES `irStrLits` back to the base
   boundary (`bkLdBaseIrStrLitsCount`), dropping `uitest.cla`'s literals -- a
   from-source non-testapi compile never splices `uitest.cla`, so the baked pool
   must not carry it either.
2. But `lowStrIdx` -- lowering's string-literal-**by-value** dedup map, baked so
   a user literal identical to a runtime one reuses the same slot -- was restored
   WHOLE: `lowStrIdx = bkCopyMapInt(bkLdLowStrIdx)`. Every entry it carried for a
   truncated `uitest.cla` literal now pointed PAST the installed pool.
3. `runtime/clarus/uitest.cla:239` is `verbLine = "tick "`. My fixture logs
   `"tick " + string(n)`. `lowInternStr` hit the stale entry, reused index 129,
   and never appended the literal at all.

So: any user program, `every` or not, whose source contained a string identical
to one of `uitest.cla`'s literals emitted an undefined `clar_lit_K` under
`--rtbake --lane c`. The corpus had simply never collided before. The exact same
hazard was already understood for the parallel arena four lines earlier --
`irFuncIdxByName` is REBUILT rather than copied, with a comment saying why "a
non-testapi truncation drops entries the loaded map's own indices would still
reference". `lowStrIdx` was the one that got missed.

## What changed

- `clarusc/bake.cla`, `bkInstallArenas`: the `lowStrIdx` restore filters to the
  installed pool (`if strVal < irStrLits.count`) instead of copying whole. On the
  testapi path nothing is truncated, so every entry survives and behavior there
  is bit-identical.
- `clarusc/bake.cla`: deleted `bkCopyMapInt`, which that line was its only caller
  of -- dead the moment the filter replaced it.
- **New T1 regression `tests/bake/every_cli.sh`**: C-lane pair-compile of
  `testdata/emitui/every_cli.cla` (from-source vs `--rtbake`), byte-compared,
  with the `falling back` guard `emit68k_pair` uses so a silent from-source
  fallback cannot make it pass vacuously. Written inline rather than as a new
  `emit_pair` helper in `tests/lib_bake.sh`: one caller, ~10 lines, and the C
  lane needs none of `emit68k_pair`'s separate-directory MacBinary dance. It
  `die`s if the fixture ever loses its `"tick "` literal, since that collision is
  the whole point of the fixture.
- **Nothing else moved.** `testdata/emitui/every_cli.c.golden` is byte-identical
  (verified explicitly) -- the from-source emission never touched `lowStrIdx`'s
  bake restore. Zero `testdata/cg68k` churn; no `.cla` fixture edited at all.

## Teeth check

Reverted the one-line fix, rebuilt, ran the new test -- it reproduces the
coordinator's exact failure, byte counts and offset included:

```
FAIL every_cli: --rtbake fork (62716 bytes) != from-source fork (62787 bytes):
  ... differ: char 27838, line 394
```

Then restored and re-verified. (Note for anyone repeating this: `make` compares
whole-second mtimes here, so a same-second edit after a build is silently NOT
rebuilt -- `touch` the file before `make -j bootstrap` or you will test a stale
compiler. It cost me one confusing red run.)

## Commands and output

```
$ make test T='bake/ emitui/ conntest/every'
tests: 29 passed, 7 skipped, 0 failed

$ CLARUS_BAKE_FULL=1 make test T=bake/full_corpus_emitui
PASS bake/full_corpus_emitui 2s
tests: 1 passed, 0 skipped, 0 failed

$ CLARUS_BAKE_FULL=1 make test T=bake/      # all sweeps, after the helper deletion
tests: 30 passed, 0 skipped, 0 failed

$ make -j t1
tests: 97 passed, 30 skipped, 0 failed
```

## Concerns

1. The same stale-index hazard applies to any OTHER by-value/by-index map baked
   whole against a truncatable arena. I checked the two that exist
   (`irFuncIdxByName`, already rebuilt; `lowArrLitIrIdx`, deliberately reset
   empty every compile with its own comment) and found no third, but the pattern
   is worth a grep by whoever next touches `bkInstallArenas`.
2. Unchanged from round 1: still no committed fixture for the conn+every
   combination. (Note that a host conn program cannot reach the bake path at all
   -- `driveCompile` falls back to from-source for `usesConn/usesFileh/usesAtalk`
   -- so that gap is emission-only, not bake-related.)
