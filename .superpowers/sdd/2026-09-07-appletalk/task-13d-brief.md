# Task 13d brief -- AppleTalk phase close-out amendments + the final T2

Plan: `docs/superpowers/plans/2026-09-07-appletalk.md` Task 14's docs items, re-opened
for Task 13's results (the first Task 14 ran while Task 13 was blocked and wrote the
"pending" paragraphs you are now replacing). Sources of truth for WHAT HAPPENED:
`task-13a-report.md`, `task-13b-report.md`, `task-13c-report.md` and the ledger
`progress.md` lines from "Task 13 UNBLOCKED" onward (rulings included). Docs-only task
plus the gate run. Quote numbers from the reports, never from memory.

## The LaunchAPPL fact every doc must get right

The blocker was cleared 2026-09-07 10:48 JST by this session, NOT by a Retro68 upstream
change: `Retro68/LaunchAPPL/Client/MiniVMac.cc` gained
`CopySystemFile("AppleTalk", false);` right after the debugger-file copy (three lines
with its comment; UNCOMMITTED in Andrew's Retro68 checkout), LaunchAPPL was rebuilt in
`Retro68-build/build-host` (`make LaunchAPPL`) and installed at
`Retro68-build/toolchain/bin/LaunchAPPL` with the previous binary kept as
`LaunchAPPL.orig`. Consequence: the harness boot disk now carries AppleTalk 58.1.4's
`.XPP`/`.DSP`; a fresh Retro68 build would silently lose this. That is an environment
prerequisite and belongs in CLAUDE.md's "Retro68 / Mac toolchain" section.

## Edits (each with its exact site)

1. `docs/HISTORY.md`, AppleTalk entry: replace the "**Task 13, still owed.**" paragraph
   and its five-item list (~line 6152-6170) with a "**Task 13, done 2026-09-07.**"
   record: the LaunchAPPL patch (above); 13a -- first `adsp_68k` run 3/12 with the
   `-1025` diagnosis, root cause = `examples/atalkchat.cla` dialed `found.name` (already
   `Object:Type`) plus `:Type` again, one-line fix, every native ADSP body correct on
   first hardware contact ON THE PATHS THE PAIR EXERCISES (`dspCLDeny` and error/abort
   paths still uncovered), 12/12 twice, no runtime edit, no golden moved; 13b -- the
   `--testapi` visibility finding and the ruling (catalog-level `AdspLeak`, what it
   proves and does not, the TODO for the runtime-waist version), 40/40, suite wall clock
   286 -> 319 s of the 420 s settle; 13c -- from its report (P5 both directions,
   `adsp_listener` 12/12, `clarusc_bake` result and wall clock, any `lib_snow.sh`
   change, any System 7 difference). Then fix the SAME entry's now-stale present-tense
   statements: "`mactest/adsp_68k.sh` (two boots, ADSP — SKIPs today, see below)"
   (~line 5999) and the "**`adsp_68k` SKIP in 40 s**" sentence in the Gates paragraph
   (~line 6191-6196) -- keep the historical fact (it skipped at the 20d6fbf gate) but
   add that the final gate below ran it green. Append the final T2 result block (step 6)
   to the Gates paragraph.
2. `docs/ROADMAP.md` item 1 "**AppleTalk.**" (~line 158-167): all fourteen tasks
   complete, reviewed and merged into `appletalk`; awaiting Andrew's merge request; the
   LaunchAPPL prerequisite in one clause.
3. `CLAUDE.md`: (a) retire the `tests/mactest/adsp_68k.sh` SKIP bullet (~line 170-181)
   -- replace with two or three lines: it runs both boots under `CLARUS_MAC_TESTS=1`
   (~20 s once the pair is up; the whole script ~7 min with the 420 s pair budget --
   take the number from 13a's report), and its `^failed -1273 ` skip remains as the
   guard for a LaunchAPPL that does not carry the `AppleTalk` file; (b) in the
   "Retro68 / Mac toolchain" section add the LaunchAPPL patch prerequisite (above,
   with the `.orig` and the "a fresh Retro68 build loses it" warning); (c) confirm 13b's
   toolbox-count sentence reads correctly in context.
4. `docs/TODO.md`: the "listener teardown path has no runtime test" bullet (~line
   158-169) says `adsp_68k.sh` SKIPs on every boot disk and "once the patch lands" --
   rewrite to present tense (it runs; the cheap subcase is now buildable). Check 13b's
   new TODO entry sits in the AppleTalk group and reads well beside it.
5. `docs/clarus-language-reference.md`, `serviceBrowser` section (~line 1462-1479):
   one sentence after the events row or the `address` paragraph: `found`'s `name` is
   already the NBP `"Object:Type"` spelling and is exactly what `c.open(appletalk
   "Name:Type")` (~line 1382) takes -- pass it straight through, never append the type.
   Check `tests/reftest/` (or whatever gate reads the reference -- `grep -rl
   clarus-language-reference tests/`) still passes.
6. **Full T2** on the finished tree: `CLARUS_MAC_TESTS=1 scripts/test-merge.sh` (~25
   min; `adsp_68k` must now PASS, `toolbox_68k` 40/40). Bootstrap snapshot regen ONLY if
   any `clarusc/*.cla` changed since 5aab2a7 (`git diff --stat 5aab2a7..HEAD --
   clarusc/`; expected: nothing) -- the recipe is in `tests/selfhost/fixedpoint.sh`'s
   failure message. Paste every `test-merge.sh: <stage> PASS in Ns` line into the
   HISTORY block (step 1) AND the report.
7. Commit: `docs: AppleTalk phase close-out -- Task 13 record, LaunchAPPL prerequisite,
   found.name note` (one commit; T2 must have run on the tree that includes this commit's
   doc edits or, since they are docs-only, on the commit before it -- say which).

## Constraints

Docs-only (plus the gate). No runtime/compiler/test edits. Do not touch
`.superpowers/sdd/2026-09-07-appletalk/` (the controller commits the ledger). Emulator
discipline as in the earlier briefs; check `pgrep -fl 'Snow|minivmac'` is empty before
T2. Branch `appletalk-t13` in `/Users/andrew/repos/clarus-wt/t13`.

## Added after the Task 13b review (controller ruling)

8. Two small edits in `testsuite/toolbox/cases_atalk.cla` (the ONLY non-doc edits in this
   task; T2's `toolbox_68k` boot verifies them, no separate boot): (a) `tbAdspEndCycle`'s
   comment says the CCB is ADSP's until `dspRemove` returns, but the code disposes every
   block even when `dspRemove` failed -- make the code match the comment: when
   `dspRemove` returns nonzero, leave the CCB and the two queues (the blocks the driver
   references) allocated, still dispose the two parameter blocks, and carry the OSErr into
   the detail; same for `tbAdspLsnCycle`'s CCB; (b) rename `rtAtErrMemFullLocal` to
   `tbAdspMemFullErr` and move it beside `tbAdspPbSz`/`tbAdspQSz`/`tbAdspCycles`.
   The 13b review's Important 1 and 2 are the CLAUDE.md/TODO edits already listed in
   items 3 and 4 above -- do them exactly as written there. `AdspLeak` stays a FAIL (not
   a skip) on a `.DSP` that will not open: ruling recorded in the ledger.

## Added after Task 13c (controller)

9. `docs/FUTURE.md`: one entry -- Snow's LocalTalk-over-UDP bridge has no launch flag, so
   `tests/lib_snow.sh`'s `snow_localtalk_b` enables it by a verified screen-position click
   (ratified for the opt-in lane); the clean fix is an upstream Snow `--serial-bridge-b
   localtalk` mode, the same shape as the LaunchAPPL patch. Use 13c's report for the
   exact menu path and the log line it verifies against.
10. HISTORY's Task 13 record (item 1) must also state 13c's System 7 finding: AppleTalk
    58 on System 7 implements `setSelfSend` (err 0) and self-lookup then works, so Task
    1's Amendment 3 (`AtalkSelf`'s no-self-lookup shape) is a Mac Plus ROM verdict, not
    an AppleTalk one -- and `testsuite/toolbox/cases_atalk.cla`'s `AtalkSelf` header
    already scopes its claim to "the Mac Plus ROM .MPP, which is what this suite boots"
    (verify that sentence still reads correctly; amend one clause if not). CLAUDE.md's
    Snow-lane paragraph (the `CLARUS_SNOW_TESTS=1` bullet) gains one sentence naming
    `mactest/snow/adsp_listener` and the display requirement (a real, unlocked display --
    the click helper).
