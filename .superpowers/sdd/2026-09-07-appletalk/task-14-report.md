# AppleTalk phase — Task 14 report: close-out

Worktree `/Users/andrew/repos/clarus-wt/t14`, branch `appletalk-t14`,
BASE `40ce5ef` (the fix-wave tip). Four commits. **Status: DONE.**
The full merge gate is green on the close-out tip.

| commit | what |
|---|---|
| `3fd0767` | `chore(clarusc): regenerate the bootstrap snapshot for the AppleTalk phase` |
| `20d6fbf` | `docs+test: the four residual nits from the fix-wave re-review` |
| (next) | `docs(sdd): appletalk phase ledger and reports` |
| (next) | `docs(HISTORY): AppleTalk phase record` |

---

## Step 1 — snapshot regeneration

`clarusc` changed substantially this phase (`check.cla`'s service /
address arms, `lower.cla`'s four resource kinds and the synthesized
pumps, `drive.cla`'s splices, `cg68k.cla`, `bake.cla`'s `lowStrIdx`
filter), so `tests/selfhost/fixedpoint.sh`'s `snapshot_fresh` was red on
the branch tip. Regenerated with that script's own printed Go-free
recipe (snapshot → current → snapshot, `cc` only). Verification:

```
make test T=selfhost/
PASS selfhost/behavior 64s
PASS selfhost/crossgen 124s
PASS selfhost/diag 0s
PASS selfhost/fixedpoint 2s
PASS selfhost/modules 7s
PASS selfhost/snapshot 6s
tests: 6 passed, 0 skipped, 0 failed
```

Committed as `3fd0767`.

## Step 2 — the four residual nits + TODO/FUTURE debt

All in `20d6fbf`. Every edit on a file with non-ASCII went through a
Python byte-level replace, never the Edit tool.

1. **`tests/atalk/examples.sh` now EMITS.** It was
   `$CLARUSC FILE --rtdir $RTDIR` (check-only), and check-only never
   runs lowering — which is exactly where the AppleTalk caps and the
   address/service fences live, so the script was not exercising the
   thing it exists to protect. Now
   `$CLARUSC emit --rtdir $RTDIR -o $WORK/$f.c $ROOT/examples/$f.cla`.
   The header comment says why in place of the old (wrong) claim that
   check-only "is enough to catch every front-end and lowering-fence
   break". Cost: **still 0 s** — `PASS atalk/examples 0s`, all three
   examples emit well under a second, and it stays outside `atalk_lock`
   with no network.

2. **`runtime/host/rt_atalk.inc` ~1276.** `rt_ext_AtalkHFd`'s comment
   still said "(Wiring it into `rt_ext_ConnHIdle`'s set is a later
   task's job -- that pump's 20 ms idle already bounds latency.)" The
   fix wave did that wiring. The comment now states the fact:
   `rt_ext_ConnHIdle` `FD_SET`s the fd when it is `>= 0`, so an
   AppleTalk-only host server sleeps on traffic instead of taking the
   20 ms `usleep` arm.

3. **`CLAUDE.md` (the AppleTalk test-groups bullet).** It said an
   `atalk.cla` edit moves `testdata/emitui/atalk_listener.c.golden`. It
   moves **all four** (`atalk_{browser,client,listener,server}`) —
   `shake` pulls whatever the pump references into every AppleTalk
   program, which is precisely what the fix wave's I3 demonstrated
   (`atalk_listener` +1 line, the other three +27/+33 each). The bullet
   now says all four and why.

4. **`CLAUDE.md` — `mactest/adsp_68k`'s SKIP reason** added as a
   top-level bullet right after the opt-in-lane list (it is not an
   opt-in lane: it runs under plain `CLARUS_MAC_TESTS=1` and skips
   itself). Records: LaunchAPPL's stripped boot disk carries System +
   AutoQuit + the app and NOT the `AppleTalk` system file, so
   `.DSP`/`.XPP` are `-43` and the listener reports `failed -1273`; the
   check is a grep of the SERVER capture for `^failed -1273 `; the skip
   is taken BEFORE the first assertion because a `FAIL ` line beats
   exit 77; it retires itself when the LaunchAPPL patch lands; and
   `mactest/atalk_68k` needs no such file and passes today.

**`docs/TODO.md`** gained an `### AppleTalk phase (2026-09-07)`
subsection under *Test coverage gaps* with two entries:

- **The listener teardown path (final review I3) has no runtime test.**
  It is pinned only by goldens — four `testdata/emitui/atalk_*.c.golden`
  and ten `testdata/cg68k/atalk_*.s` — i.e. shape, not behaviour. The
  failure needs a real `.DSP` that then fails, and `adsp_68k` skips on
  every current boot disk. The cheap check once Task 13's patch lands is
  named (kill the server mid-run, assert the client's next `find` no
  longer sees the name).
- **`atalk_lock`'s stale-holder STEAL path is still racy between two
  waiters.** The fix wave closed the UNLOCK half (the `pid` ownership
  check). Two waiters can both pass the same dead holder's `kill -0`
  check: waiter A `rm -rf`s the dead directory and `mkdir`s its own (A
  now holds the lock), then waiter B -- already past its check --
  `rm -rf`s A's FRESH directory and `mkdir`s its own. Both believe they
  hold the lock. Pre-existing
  shape, never observed, costs determinism on a test group only. Real
  fix recorded: an atomic `mv`-into-place, or `flock` on a lock file.

**`docs/FUTURE.md`** gained an `### AppleTalk phase (2026-09-07)`
subsection under *Performance levers (measure first)*: T1's 34 s →
~2:14 is dominated by the network scripts' **wait budgets**, not by
compiles and not by the lock — measured at ~130 s of the ~134 s network
chain, with `atalk/examples` at 0 s and `atalk/splice` at 1 s, and the
fix wave's lock narrowing worth only ~2.5 s. Two levers named (shrink
the `atalk_wait_*` budgets, which were sized for the Mac's ~3.2 s NBP
verify rather than the host's; or overlap the atalkdrive-free halves),
with the warning that a budget cut that makes the group flaky costs far
more than 100 s.

## Step 3 — the full merge gate

`CLARUS_MAC_TESTS=1 scripts/test-merge.sh` on `20d6fbf` (the phase tip
+ the snapshot + the nits). **Every stage PASS; the run is green.**

```
test-merge.sh: t1 body PASS in 130s          (104 passed, 33 skipped, 0 failed)
test-merge.sh: perfgate/ PASS in 0s          (1 passed, 0 skipped, 0 failed)
test-merge.sh: selfhost/ PASS in 204s        (6 passed, 0 skipped, 0 failed)
test-merge.sh: mactest/ PASS in 981s         (20 passed, 14 skipped, 0 failed)
test-merge.sh: bake/ full corpus PASS in 3s  (7 passed, 0 skipped, 0 failed)
test-merge.sh: PASS in 1318s
```

Zero `FAIL` lines anywhere in the run.

**`mactest/` detail** (the stage that matters for this phase):

| script | result |
|---|---|
| `mactest/atalk_68k` | **PASS 216s** — native NBP/ATP vs the host stack, both directions |
| `mactest/atalk_selfserve` | **PASS 14s** |
| `mactest/adsp_68k` | **SKIP 40s**, `grep -c '^FAIL' …/adsp_68k.log` = **0** — the self-retiring `.DSP`-absent skip, exactly as designed |
| `mactest/toolbox_68k` | PASS 303s, **39/39**, `AtalkSelf` green |
| `mactest/toolbox_jiggle` | PASS 303s |
| `mactest/coresuite_68k` | PASS, **83/83** |
| `mactest/smoke_bounce`, `mactest/tick` | PASS — the load-bearing check on the reblessed `cg68k` goldens |
| `mactest/ui_scenarios` | PASS 34s |
| `mactest/{abort,runerr}_68k`, `connfailed`, `dblcompile*`, `leakgate`, `bake_named`, `pbm2icn`, `resparity`, `abort_leak_baseline` | PASS |

The 14 `mactest/` skips are the opt-in cprint lane (`abort_mac`,
`appres`, `coresuite_mac`, `runerr_mac`, `toolbox_mac`, `bench`) and the
Snow lane (7 scripts), plus `adsp_68k`. All expected; none is this
phase's.

The `bake/` full-corpus sweep (`CLARUS_BAKE_FULL=1`) is 7 passed — it
includes the `every_cli` case that caught the pre-existing `bake.cla`
`lowStrIdx` bug mid-phase.

## Step 4 — the HISTORY entry and ROADMAP

`docs/HISTORY.md` gains `## AppleTalk phase (2026-09-07, branch
appletalk)` between the `native-array-return-and-fileh-guards` entry and
the 2026-09-05 ROADMAP archive (newest-last, house shape). ~19 KB. It
records, in the house order: the standing not-merged note plus an
explicit "this covers Tasks 1-12 + the fix wave; Task 13 lands after
this entry"; what the phase did; **the four probe findings** (P1 the
boot-disk gap, P2 LToUDP works first try, P3 no self-send/self-lookup/
self-transaction on the Plus ROM, P4 two-boot works but kill by cwd) and
the two amendments that fell out of P3 (PB re-zeroing, `nteAddress` as
the own-address source); the host stack, front end, runtime, catalog,
serial carry-ins, tests, examples and docs; **the two real bugs** —
`bake.cla`'s `lowStrIdx` restored unfiltered after a truncating install
(**pre-existing**, and the reason Task 13's Snow `clarusc_bake` rerun is
owed) and `rt_at_acquire`'s lapACK wait returning on any datagram
(**this phase's own code**, not pre-existing); the final review and the
one fix wave (C1, C2, I1-I4 and the minors, each with the ruling);
**the rebless proof** (the review's independent normalization of
`arith.s` leaving only the globals immediate + appended roots; I3's ten
`cg68k` files with four normalizing to zero residue and the server's
`; func` name set byte-identical; the four `emitui` goldens); the
**accepted costs stated precisely**; Task 13's exact remaining contents;
the gate results above; and the debt pointers.

**The costs are stated as the re-review corrected them, not as the
fix-wave report first wrote them:**

- Every native program's A5 globals grew **1,596 → 6,910 bytes**
  (immediate `#797` → `#3454`), because `atalk.cla` + `atalk_68k.cla`
  are in the 68k superset — paid even by a program that never mentions
  AppleTalk. Largest standing cost of the phase.
- Host `connection` programs carry the `atalk_c.cla` wrappers (the host
  splice is joint).
- **An AppleTalk native program WITHOUT a listener** keeps `rtLsnStop`
  and four callees. **NOT every native binary** — the fix-wave report
  claimed that and the re-review refuted it; retention is
  `usesAtalk`-gated.
- T1 34 s → ~2:14, with the measured attribution and the lever.
- `svc.call`'s type guard is a one-off until real out-parameter typing
  lands.

`docs/ROADMAP.md` keeps AppleTalk under "Remaining, in order" as **not
merged**, now noting that Tasks 1-12 + the fix wave are complete and
recorded in HISTORY, and that what remains is Task 13 (blocked on the
one-line LaunchAPPL `CopySystemFile("AppleTalk", false)` patch outside
this repo) and Andrew's merge request.

Project memory was **not** touched — the controller owns it.

## The ledger commit

`.superpowers/sdd/2026-09-07-appletalk/` is copied into the worktree and
force-added (`.superpowers/sdd/.gitignore` is `*`, so every phase's
record is force-added; `task-1-report.md` was already tracked).

**One deviation from the brief, deliberate:** 56 of the 57 files are
committed (2.5 MB). The omitted one is
`review-t9-8ef9fe6..6646efb.diff` — **12.8 MB**, ~98 % golden churn,
and exactly reproducible as `git diff 8ef9fe6..6646efb`. The code-only
package the reviewer actually read (`review-t9-code-only.diff`, 87 KB)
IS committed, as are all 12 other review diffs, all 8 top-level reports
and every task brief/report. Committing 12.8 MB of regenerable golden
diff into the repo permanently was not worth it; the HISTORY entry's
closing pointer names the omission and the command that regenerates it.
Nothing was deleted from the main repo's workspace.

## Step 5 — final `make -j t1`

Run after the doc commits. Result: PASS -- `make -j t1` on the close-out tip `0d3e317`: **104 passed,
33 skipped, 0 failed**, exit 0. (Docs cannot break it; the snapshot
commit could, which is why step 1 preceded the gate.)

## Concerns

1. **Task 13 is still blocked**, and with it the only proof that the
   ADSP stream stack works. `adsp_68k` SKIPs cleanly, `atalk_selfserve`
   and `atalk_68k` cover NBP/ATP, and the toolbox `AtalkSelf` case
   covers the catalog — but nothing in any gate executes an ADSP
   connection end to end. The unblocking action is Andrew's: one line in
   `Retro68/LaunchAPPL/Client/MiniVMac.cc` after the debugger-file copy
   (`CopySystemFile("AppleTalk", false);`) plus a LaunchAPPL rebuild in
   `Retro68-build/build-host`. Reversible; the classifier refused it to
   this session as an outside-repo write.
2. **T1 is 4x its pre-phase wall clock** (34 s → ~2:14) and that is now
   the everyday cost of running the per-task gate. Recorded in FUTURE
   with the measurement and the lever; not addressed here because a
   wait-budget cut needs its own before/after timing and a flaky
   network group would cost far more than the 100 s.
3. **The A5 globals growth is unconditional.** 1,596 → 6,910 bytes on
   every native binary, AppleTalk or not, because the 68k splice is not
   usage-gated the way the host splice is. Nobody asked for this to be
   fixed and it may never matter, but it is the phase's one permanent
   cost to unrelated programs and it will compound when MacTCP lands.
   If it is ever worth fixing, the lever is making the 68k splice
   `usesAtalk`-gated the way the host one already is.


---

## Fix round 1/5 (review: Needs fixes, docs only)

Four findings, all documentation, all verified against the tree before
editing; every edit byte-safe (Python UTF-8 replace, not the Edit tool).

1. **Important -- `docs/HISTORY.md`: the `docs/TODO.md` line figure was
   wrong.** It said "shrank by 158 lines net"; 158 is `--stat`'s total
   CHANGED-line count. `git diff --numstat dbacb90..40ce5ef --
   docs/TODO.md` = `40 118`, i.e. **-78 net**. Now reads "shrank by 78
   lines net (40 added, 118 removed)".

2. **`adsp_68k.sh` has TWELVE subcases, not ten.** Ten fail without
   `.DSP`; `server_registered` and `client_echo_bytes` pass either way
   (verified: the twelve are `server_{registered,accepted,sweep,hello,
   closed,exit}` and `client_{opened,sweep_echo,hello_echo,echo_exact,
   echo_bytes,exit}`). Both "all ten assertions run" sentences --
   `docs/HISTORY.md` and `CLAUDE.md`'s gated-lane bullet -- now say
   twelve. The separate "would have failed T2 on ten assertions"
   sentence is left alone: that one counts the assertions that were
   actually red, and ten is correct there.

3. **`docs/TODO.md`'s `atalk_lock` steal-race description was
   backwards.** The real interleaving is not "the second `mkdir`
   succeeds because the first `rm -rf` removed its own directory": both
   waiters pass the same dead holder's `kill -0`, then A `rm -rf`s the
   DEAD directory and `mkdir`s its own (A holds), and B -- already past
   its check -- `rm -rf`s **A's fresh** directory and `mkdir`s its own.
   Both then believe they hold the lock, which is the actual hazard.
   Rewritten in `docs/TODO.md` and in the Step 2 summary above.

4. **A third binding Task 1 amendment was missing from HISTORY.**
   `registerName` copies the NTE's `aSocket` VERBATIM -- it does not
   allocate one -- so a service must write its ATP/ADSP socket into
   NTE+7 BEFORE registering. The runtime's register path is built around
   that; the entry named only the PB re-zeroing and `nteAddress`
   amendments. Added as the middle of three.

**Verification:** `make test T='runner/ reftest/'` -- 6 passed, 0
skipped, 0 failed (`reftest/{checkclean,extract,required}`,
`runner/{selfcheck,syntax,timeout}`). No code changed, so no other gate
is implicated.
