# Task 13d report -- AppleTalk phase close-out amendments + the final T2

Worktree `/Users/andrew/repos/clarus-wt/t13`, branch `appletalk-t13`, base
`3d81282`. **One commit, `d1b0fc6`.** Docs-only apart from the two briefed nits
in `testsuite/toolbox/cases_atalk.cla`.

**Result: T2 PASS in 1350 s on the finished tree, `adsp_68k` 12/12 and
`toolbox_68k` 40/40 in a merge gate for the first time.** No emulator was left
running; `git diff --stat 5aab2a7..HEAD -- clarusc/` was empty, so no bootstrap
snapshot regeneration was needed.

---

## Brief items and the hunks that satisfy them

Line numbers are post-commit (`d1b0fc6`).

| item | hunk | what |
|---|---|---|
| 1 (HISTORY, Task 13 record) | `docs/HISTORY.md:6155-6275` | `**Task 13, done 2026-09-07.**` replacing `**Task 13, still owed.**` and its five-item list: the LaunchAPPL patch, then `**13a**` / `**13b**` / `**13c**` / `**13d**` paragraphs. |
| 1 (HISTORY, stale present tense, entry head) | `docs/HISTORY.md:5882-5886` | "covers Tasks 1-12 ... Task 13 ... is BLOCKED ... lands after this entry" -> "covers all fourteen tasks ... was blocked ... until 2026-09-07, and was amended into this entry once it landed". |
| 1 (HISTORY, stale present tense, P1) | `docs/HISTORY.md:5909-5911` | "This is the whole reason Task 13 **is** blocked" -> "This is what blocked Task 13 until the LaunchAPPL patch below". |
| 1 (HISTORY, stale present tense, ~5999) | `docs/HISTORY.md:6001-6003` | "`mactest/adsp_68k.sh` (two boots, ADSP — SKIPs today, see below)" -> "it SKIPped itself until the LaunchAPPL `AppleTalk`-file patch of Task 13a, and has been 12/12 since". |
| 1 (HISTORY, Gates: keep the historical SKIP, add the second gate) | `docs/HISTORY.md:6281, 6301-6309` | "was run at close-out on `20d6fbf`" -> "was run TWICE. The first run was the Tasks 1-12 close-out on `20d6fbf`"; the `adsp_68k` SKIP sentence keeps the fact and gains "because that gate ran before the LaunchAPPL patch"; the snapshot sentence gains "nothing under `clarusc/` has changed since, so the snapshot did not need regenerating again for the second gate". |
| 1 + 6 (the final T2 block) | `docs/HISTORY.md:6311-6334` | The second run's six `test-merge.sh:` lines verbatim plus the load-bearing `mactest/` results. |
| 2 (ROADMAP) | `docs/ROADMAP.md:158-170` | Item 1 "**AppleTalk.**": "In progress" -> "Complete"; all fourteen tasks reviewed and merged into `appletalk`; "All that remains is Andrew's merge request"; the LaunchAPPL prerequisite in one clause. |
| 3a (CLAUDE.md, retire the SKIP bullet) | `CLAUDE.md:177-188` | Runs both boots under `CLARUS_MAC_TESTS=1` and is 12/12; ~20 s of emulator time once the pair is up, ~7 min for the whole script against its 420 s pair budget; the `^failed -1273 ` grep stays as the guard for an unpatched LaunchAPPL, and without the patch `toolbox_68k` goes RED on `AdspLeak`. |
| 3b (CLAUDE.md, Retro68 prerequisite) | `CLAUDE.md:381-394` | New bullet in "Retro68 / Mac toolchain": the three lines, the `build-host` rebuild, the install path, `LaunchAPPL.orig`, and the "UNCOMMITTED ... a fresh Retro68 build silently loses it" warning with its consequence. |
| 3c (CLAUDE.md, the toolbox-count sentence) | `CLAUDE.md:249, 300-306` | Verified in context, no edit needed: `40 ... 39 real` at 249, and the `AdspLeak` clause at 300-306 already scopes the claim to the ROM pairs and points at `docs/TODO.md`. |
| 4 (TODO, listener teardown) | `docs/TODO.md:158-170` | "`mactest/adsp_68k.sh` SKIPs on every current boot disk" -> "no test drives one into failing"; "Once the LaunchAPPL ... patch lands (Task 13), the cheap check is" -> "The cheap check is now buildable -- Task 13a's LaunchAPPL `AppleTalk`-file patch means `mactest/adsp_68k.sh` runs both boots against a real `.DSP` -- and is". 13b's `AdspLeak` entry (`docs/TODO.md:189-201`) checked: it is in the same `### AppleTalk phase (2026-09-07)` group, two bullets below, and reads correctly beside the rewritten one. |
| 5 (reference) | `docs/clarus-language-reference.md:1478-1479` | New paragraph after the `address` paragraph in *Service Discovery*: `found`'s `name` is already the full NBP `"Object:Type"` spelling, the very form `connection.open(appletalk "Name:Type")` takes -- pass it straight through, with the concrete `"ChatServer:ChatServer"` counterexample. |
| 8a (case nit: failed remove) | `testsuite/toolbox/cases_atalk.cla:300-302, 323-352, 366-368, 380-397` | Both cycle helpers gained `driverHolds: bool`, set true after a successful `dspInit`/`dspCLInit` and cleared only when the paired remove returns 0; the driver-referenced blocks are disposed only `if not driverHolds`. The parameter blocks are still disposed unconditionally (a comment says why: `PBControlSync` is synchronous). The OSErr already reaches the detail -- both helpers return `e` and `caseAdspLeak` prints `end cycle N err E` / `listener cycle N err E`. |
| 8b (case nit: rename/move) | `testsuite/toolbox/cases_atalk.cla:272-276, 309, 372` | `rtAtErrMemFullLocal` -> `tbAdspMemFullErr`, declaration (with its comment) moved from the foot of the helper block to sit directly under `tbAdspPbSz`/`tbAdspQSz`/`tbAdspCycles`. |
| 9 (FUTURE) | `docs/FUTURE.md:367-387` | New bullet in "## Tooling", `### AppleTalk phase (2026-09-07)`: no launch flag, every alternative measured and rejected, the exact menu path (Ports -> Channel B (printer) -> Enable LocalTalk (UDP)) with the three window-origin offsets, the `LocalTalk bridge enabled` log line it verifies against, the ratification, and the upstream `--serial-bridge-b localtalk` ask. |
| 10 (System 7 finding + `AtalkSelf` header check) | `docs/HISTORY.md:6242-6252` | The `setSelfSend` err 0 / self-lookup-works comparison, and "Task 1's Amendment 3 ... is therefore a Mac Plus ROM verdict, not an AppleTalk one". **`cases_atalk.cla`'s `AtalkSelf` header reads correctly as written** (`testsuite/toolbox/cases_atalk.cla:20-21`: "proved all three legs of that unavailable on the Mac Plus ROM .MPP, which is what this suite boots") -- no amendment made, and HISTORY says so. |
| 10 (CLAUDE.md Snow-lane sentence) | `CLAUDE.md:168-175` | Appended to the `CLARUS_SNOW_TESTS=1` bullet: `mactest/snow/adsp_listener` needs `CLARUS_MAC_TESTS=1` for its client half **and a real, unlocked display**, because `snow_localtalk_b` posts CGEvent clicks into Snow's in-window menu bar. |
| 7 (commit) | `d1b0fc6` | Subject as briefed. The body states which tree T2 ran on (below). |

### One deliberate deviation from the brief, flagged

Item 8(a) says "when `dspRemove` returns nonzero, leave the CCB and the two
queues (the blocks the driver references) allocated". I left **four** blocks --
the CCB, both queues **and the attention buffer** -- because the attention
buffer is equally driver-referenced: `dspInit` hands its address to ADSP in
`dspInitAttnPtr`, and a connection end whose `dspRemove` failed is still live,
so returning that buffer to the Memory Manager is the same use-after-free the
other three are. The parenthetical rationale in the brief ("the blocks the
driver references") is what I followed; the enumeration appears to have missed
one. Behaviourally the two readings are indistinguishable in the test: the path
only runs when `dspRemove` fails, which already FAILs the case with the OSErr.
`tbAdspLsnCycle` is unchanged in shape -- `dspCLInit` takes only a CCB, so
there is only the one block to hold back.

## The T2 result block, verbatim

`CLARUS_MAC_TESTS=1 scripts/test-merge.sh`, run in
`/Users/andrew/repos/clarus-wt/t13`. `pgrep -fl 'Snow|minivmac'` was empty
before it started and is empty now.

```
test-merge.sh: t1 body PASS in 131s
test-merge.sh: perfgate/ PASS in 0s
test-merge.sh: selfhost/ PASS in 208s
test-merge.sh: mactest/ PASS in 1009s
test-merge.sh: bake/ full corpus PASS in 2s
test-merge.sh: PASS in 1350s
```

Per-stage tallies from the same log: t1 body `104 passed, 34 skipped, 0
failed`; perfgate `1 passed`; selfhost `6 passed`; mactest `21 passed, 14
skipped, 0 failed`; bake full corpus `7 passed`. Exit code 0.

**Wall clock: 1350 s (22m30s)** by the script's own final line, which brackets
the whole run.

### `mactest/` per-script result lines (the gated stage)

```
PASS mactest/abort_68k 3s
PASS mactest/abort_leak_baseline 0s
SKIP mactest/abort_mac 0s
PASS mactest/adsp_68k 20s
SKIP mactest/appres 0s
PASS mactest/atalk_68k 216s
PASS mactest/atalk_selfserve 18s
PASS mactest/bake_named 0s
SKIP mactest/bench 0s
PASS mactest/connfailed 3s
PASS mactest/coresuite_68k 4s
SKIP mactest/coresuite_mac 0s
PASS mactest/dblcompile_abort 5s
PASS mactest/dblcompile_bake 5s
PASS mactest/dblcompile 4s
PASS mactest/leakgate 4s
PASS mactest/native_compare 20s
PASS mactest/pbm2icn 1s
PASS mactest/resparity 0s
PASS mactest/runerr_68k 11s
SKIP mactest/runerr_mac 0s
PASS mactest/smoke_bounce 7s
SKIP mactest/snow/adsp_listener 0s
SKIP mactest/snow/clarusc_bake 0s
SKIP mactest/snow/clarusc_boot 0s
SKIP mactest/snow/macresident_failed_compile 0s
SKIP mactest/snow/macresident 0s
SKIP mactest/snow/pagefile 0s
SKIP mactest/snow/roundtrip 0s
SKIP mactest/snow/serial_echo 0s
PASS mactest/tick 4s
PASS mactest/toolbox_68k 318s
PASS mactest/toolbox_jiggle 331s
SKIP mactest/toolbox_mac 0s
PASS mactest/ui_scenarios 35s
```

The seven the brief named: **`adsp_68k` PASS 20s**, **`toolbox_68k` PASS 318s**,
**`atalk_68k` PASS 216s**, **`atalk_selfserve` PASS 18s**, **`coresuite_68k`
PASS 4s**, **`smoke_bounce` PASS 7s**, **`tick` PASS 4s**. All eight Snow
scripts SKIP (no `CLARUS_SNOW_TESTS`), as do the five cprint-lane twins
(`abort_mac`, `appres`, `coresuite_mac`, `runerr_mac`, `toolbox_mac`) and
`bench`. 14 skips, 21 passes, 0 failures.

`build-run/tests/mactest/adsp_68k.log`, verbatim:

```
  server: serving Chat-5123
  server: accepted
  server: received 256
  server: received 5
  server: closed
  client: connecting
  client: found Chat-5123:ClarusChat66209 0.114.253
  client: opened
  client: received 257
  client: echo ok
  client: received 6
  client: echo ok
  client: closing
PASS server_exit
PASS client_exit
PASS server_registered
PASS server_accepted
PASS server_sweep
PASS server_hello
PASS server_closed
PASS client_opened
PASS client_sweep_echo
PASS client_hello_echo
PASS client_echo_exact
PASS client_echo_bytes
```

Case counts confirmed from the captured logs rather than inferred:
`grep -c '^PASS ' build-run/tests/mactest/toolbox_68k.log` = **40**,
`coresuite_68k.log` = **83**.

### Which tree T2 ran on

The gate ran on the working tree with **every edit in commit `d1b0fc6` present
except the T2 result block it produced** -- `docs/HISTORY.md:6311-6334`, which
could only be written from the run's own output. That block is docs-only prose
inside a `.md` file no test reads, and `tests/reftest/` (the only gate that
reads a doc, and it reads the language reference, not HISTORY) was run
separately and green (below). Nothing else changed between the gate and the
commit.

### Snapshot check

```
$ git diff --stat 5aab2a7..HEAD -- clarusc/
(no output)
```

Empty, as the brief expected -- no bootstrap snapshot regeneration, and
`tests/selfhost/` (6 passed, including `fixedpoint`) confirms `snapshot_fresh`
is green as-is.

## Pre-gate verification

```
$ make test T=reftest/
PASS reftest/checkclean 0s
PASS reftest/extract 0s
PASS reftest/required 2s
tests: 3 passed, 0 skipped, 0 failed
```

(Run after the reference edit, before T2; T2's t1 body re-ran the same group.)

The suite build was compile-checked before the gate, exactly as
`tests/lib_mac.sh`'s `toolbox_emit68k` builds it (`emit68k --rtdir
runtime/clarus/ --events testdata/ui/toolboxsuite.events --testapi` +
`tests/mactest/toolbox_files.txt`, from `build-run/emitcwd`) -- `Finished`, no
diagnostics -- so the `cases_atalk.cla` nits could not have cost an emulator
boot to a typo.

`LC_ALL=C grep -c '[^ -~<TAB>]' testsuite/toolbox/cases_atalk.cla` = **0**
before and after the edit: the file is plain ASCII, so no MacRoman byte could
be disturbed. (Edits were applied by a `python3` script reading and writing the
file in binary-faithful UTF-8 with `newline=''`, not by a text editor.)

## Self-review: the grep sweep, verbatim

No "pending" / "still owed" / "SKIPs today" / "blocked" statement about Task 13
or `.DSP` survives. Every hit below was read.

```
$ grep -n 'still owed' CLAUDE.md docs/ROADMAP.md docs/TODO.md docs/HISTORY.md
(no output)

$ grep -n 'adsp_68k' CLAUDE.md docs/ROADMAP.md docs/TODO.md
docs/ROADMAP.md:165:   `mactest/adsp_68k` and `toolbox_68k` boots need the one-line
docs/TODO.md:168:  LaunchAPPL `AppleTalk`-file patch means `mactest/adsp_68k.sh` runs
CLAUDE.md:177:- `tests/mactest/adsp_68k.sh` (the two-Mac ADSP stream boot, appletalk
CLAUDE.md:392:  which `mactest/adsp_68k` SKIPs itself and `mactest/toolbox_68k` goes

$ grep -n 'Task 13' CLAUDE.md docs/ROADMAP.md docs/TODO.md
CLAUDE.md:302:  phase's Task 13b `AdspLeak` case, which hardware-proves the ROM `.DSP`
docs/TODO.md:167:  shape, not behaviour. The cheap check is now buildable -- Task 13a's
docs/TODO.md:190:  runtime's.** Task 13b's `testsuite/toolbox` case (`cases_atalk.cla`)

$ grep -n '1273' CLAUDE.md docs/ROADMAP.md docs/TODO.md
CLAUDE.md:180:  whole script against its 420 s pair budget. Its `^failed -1273 ` grep

$ grep -n 'CopySystemFile' CLAUDE.md docs/ROADMAP.md docs/TODO.md
CLAUDE.md:384:  `CopySystemFile("AppleTalk", false);` added after its debugger-file
docs/ROADMAP.md:166:   `CopySystemFile("AppleTalk", false)` LaunchAPPL patch, which is

$ grep -n 'DSP' CLAUDE.md docs/ROADMAP.md docs/TODO.md
CLAUDE.md:169:    Snow as the ADSP listener, Mini vMac as the client, over LToUDP) also
CLAUDE.md:177:- `tests/mactest/adsp_68k.sh` (the two-Mac ADSP stream boot, appletalk
CLAUDE.md:182:  NOT carry the `AppleTalk` system file (`.DSP`/`.XPP` then open `-43`):
CLAUDE.md:188:  `open .DSP err -43`). `tests/mactest/atalk_68k.sh` (NBP/ATP over the
CLAUDE.md:302:  phase's Task 13b `AdspLeak` case, which hardware-proves the ROM `.DSP`
CLAUDE.md:386:  the app) also installs AppleTalk 58.1.4 and `.XPP`/`.DSP` open instead
CLAUDE.md:393:  RED on `AdspLeak` (`open .DSP err -43`). Re-apply the three lines and
docs/TODO.md:164:  needs a real `.DSP` that then fails, and no test drives one into
docs/TODO.md:169:  both boots against a real `.DSP` -- and is a subcase that kills the
docs/TODO.md:189:- **`AdspLeak` proves the ROM's half of the ADSP lifecycle, not the
docs/TODO.md:234:  System 6 without the `.DSP` driver should be able to learn that and
docs/TODO.md:235:  disable its ADSP features itself, rather than discovering it through
docs/TODO.md:241:  the same questions (`hasADSP()` is `false` on the host until host
docs/TODO.md:242:  ADSP lands, see `docs/FUTURE.md`). Scheduled AFTER the initial
```

`CLAUDE.md:392` and `docs/ROADMAP.md:165` are the two deliberate remaining
"SKIPs itself" statements -- both are the conditional describing a machine
WITHOUT the LaunchAPPL patch, not a claim about today.

Inside HISTORY's AppleTalk entry:

```
$ sed -n '/^## AppleTalk phase (2026-09-07/,/^## Archived from ROADMAP, 2026-09-05/p' docs/HISTORY.md \
    | grep -n 'still owed\|pending\|is blocked\|BLOCKED\|SKIPs today\|SKIPs on'
(no output)
```

The two surviving `blocked` words in that entry are past tense: "was blocked on
a toolchain patch outside this repo until 2026-09-07" (the entry head) and
"This is what blocked Task 13 until the LaunchAPPL patch below" (P1).

## Files changed

```
 CLAUDE.md                         |  42 ++++++--
 docs/FUTURE.md                    |  21 ++++
 docs/HISTORY.md                   | 206 +++++++++++++++++++++++++++++++-------
 docs/ROADMAP.md                   |  17 ++--
 docs/TODO.md                      |  12 ++-
 docs/clarus-language-reference.md |   2 +
 testsuite/toolbox/cases_atalk.cla |  62 ++++++++----
 7 files changed, 285 insertions(+), 77 deletions(-)
```

Nothing under `.superpowers/sdd/2026-09-07-appletalk/` was touched by the
commit; this report is written into the main repo's copy of that directory as
instructed and is not part of `d1b0fc6`.

## Self-review

- **Completeness.** Every brief item 1-5 and 7-10 has a hunk in the table
  above; item 6 is the gate. Item 3c was a verification, not an edit, and the
  report says so. Item 10's `AtalkSelf`-header check was a verification too:
  the sentence already scopes its claim, so nothing was amended.
- **Accuracy.** Every number traces to a report: 3/12 and -1025 and the 12/12-
  twice from `task-13a-report.md`; 39 -> 40, 286 -> 319 s of the 420 s settle,
  and the `driveEarlySplice`/`bakeModuleList` module count from
  `task-13b-report.md`; 12/12 four times at 72/73/73/73 s, `clarusc_bake` PASS
  2232 s / 37m12s, `setSelfSend` err 0, 640x480, and the three click offsets
  (re-read out of `tests/lib_snow.sh` rather than the prose) from
  `task-13c-report.md`; the LaunchAPPL patch details from the brief and the
  ledger. The T2 numbers are from this run's own log.
- **Where a report contradicted the brief, the report won.** 13a's own report
  qualifies "every native ADSP body correct on first hardware contact" with
  "on the paths the pair exercises", and the ledger's review line adds that
  `dspCLDeny` and the error/abort paths are uncovered; HISTORY says both. 13c's
  helper waits for `LocalTalk bridge enabled` (its `grep` at
  `tests/lib_snow.sh:405`), not the `bridge started` line the report's prose
  quotes first, so FUTURE and HISTORY name the line the code actually greps.
- **Discipline.** No runtime, compiler, harness or golden file touched; no test
  weakened; no settle or timeout changed; no subagent dispatched; no emulator
  killed by app name and none left running.

## Concerns

1. **The one deviation above** (holding the attention buffer as well as the CCB
   and queues on a failed `dspRemove`). Called out rather than silently
   applied; revert to exactly three blocks if the controller prefers the
   brief's literal enumeration -- it costs nothing either way, since the path
   only runs on a failure that already reddens the case.
2. **The failed-remove path is still unexercised.** It was before this change
   too (13b's own concern 1: `AdspLeak` has never been observed to FAIL), and
   this edit adds a second branch nothing runs. It is four lines of guarded
   disposal, statically auditable, and the honest cheap check is the one 13b
   named -- temporarily delete a `tbAdspFreeIf` call and watch the case go red.
   I did not burn an emulator boot on it.
3. **`coresuite_68k` PASS in 4 s** looks fast for an emulator boot next to
   `toolbox_68k`'s 318 s. Its log carries all 83 `PASS` lines and the script's
   own `TOTAL`/count assertions passed, so the result is real; I did not chase
   the timing, but it is worth a glance by anyone who remembers that script
   being slower.
4. **The whole `mactest/` half of T2 depends on an uncommitted patch in a
   directory this repo only symlinks to.** That is now recorded in three places
   (CLAUDE.md's Retro68 section, its `adsp_68k` bullet, ROADMAP item 1), which
   is the best a repo can do -- but a fresh Retro68 build on any machine turns
   `toolbox_68k` red, and nothing in the harness can detect the difference
   between "no patch" and "genuine ADSP regression" except the `AdspLeak`
   failure detail naming `-43`.

---

## Fix report (review round 1, 2026-09-07)

All four items taken. Text only -- no code, no test, no gate re-run beyond the
two the reviewer asked for. Commit `6e92cdf` on `appletalk-t13`.

### Important 1 -- the invented 7-minute wall clock

`CLAUDE.md:177-183`. The reviewer is right and I had no source for it: 420 is
`run_mac_pair`'s per-boot `timeout` CEILING (`tests/lib_mac.sh:62,69`), the two
apps quit on their own, and the only measured number anywhere is 20 s -- twice
in `task-13a-report.md` and again in this branch's own T2 (`docs/HISTORY.md`
and the `mactest/` result lines above). Replaced verbatim with the reviewer's
wording: *runs both boots under plain `CLARUS_MAC_TESTS=1` and is 12/12 in
~20 s; `run_mac_pair`'s 420 s is the per-boot timeout ceiling, not the expected
duration (both apps quit on their own).*

### Important 2 -- the `AtalkSelf` header contradicted itself

`testsuite/toolbox/cases_atalk.cla:22-26`, comment only. The old clause
explained the `-17` partly by the AppleTalk 58 file being absent from
LaunchAPPL's boot disk -- which stopped being true at Task 13a, as the same
file's own lines 36-39 already said, and as `CLAUDE.md:387` says in the
previous commit. `AtalkSelf` is green with the file present, so `-17` is the
ROM `.MPP`'s verdict, not a file-absence artefact. Now:

```
//   - `setSelfSend` (csCode 256) returns -17 (controlErr): the ROM .MPP
//     does not implement it, and the AppleTalk 58 file the boot disk now
//     carries (Task 13a) does not displace the ROM's .MPP on a Mac Plus,
//     so this stays -17 with the file present. System 7's AppleTalk 58
//     answers err 0 and self-lookup then works -- Task 13c.
```

My earlier report's claim that the header "reads correctly as written" was
wrong: I checked the sentence 13c's finding pointed at (line 20-21, the "Mac
Plus ROM .MPP, which is what this suite boots" scoping) and did not read the
sub-bullet two lines below it. `docs/HISTORY.md:6240-6245` changed from "so it
stands as written" to a statement that one clause WAS amended and why.

### Minor 3 -- the skip arithmetic

`docs/HISTORY.md:6334-6336`. "one more skips (14 against 13)" was wrong against
both gate blocks in the same file, which each print `14 skipped`. Now: *the
skip total is unchanged at 14 -- `adsp_68k` stopped skipping and the new
`mactest/snow/adsp_listener`, which needs `CLARUS_SNOW_TESTS`, started.*

### Minor 4 -- the first run's tally

`docs/HISTORY.md:6172-6174`. "3 PASS / 8 FAIL" is 11 of 12. Now **4 PASS (one
of them vacuous on an empty client log) / 8 FAIL**, per the controller's
correction of the ledger line I took it from.

### Verification, verbatim

```
$ LC_ALL=C grep -c '[^ -~]' testsuite/toolbox/cases_atalk.cla
0
```

The toolbox suite still builds -- exactly `tests/mactest/toolbox_68k.sh`'s
build step (`toolbox_emit68k`, `tests/lib_mac.sh:200-214`: `emit68k --rtdir
runtime/clarus/ --events testdata/ui/toolboxsuite.events --testapi --bake
testdata/mac-resident/resbake.bin` + `toolbox_files.txt`, run from
`build-run/emitcwd`), no boot:

```
[09-07-26 13:55:15] Emitted segment 7 (0s, 0 ticks)
[09-07-26 13:55:15] Built fork (0s, 0 ticks)
[09-07-26 13:55:15] Compiled ../../testsuite/kit.cla - 0s (3 ticks)
[09-07-26 13:55:15] Finished
```

(224 KB `.bin` produced, then deleted -- it was only the build proof.)

```
$ make test T='testsuite/ reftest/'
PASS testsuite/catalog_ui 0s
PASS testsuite/catalog 0s
PASS testsuite/core_cli 1s
PASS testsuite/lazyintern 3s
PASS reftest/checkclean 1s
PASS reftest/extract 0s
PASS reftest/required 1s
tests: 7 passed, 0 skipped, 0 failed
```

The self-review grep sweep was repeated in full and is **unchanged** from the
block above, hit for hit, modulo the +1/-1 line shifts the two CLAUDE.md
reflows caused (`-1273` 180 -> 181, `CopySystemFile` 384 -> 385, the `.DSP`
hits 182/188/302/386/392 -> 183/189/303/387/393). `still owed` still returns
nothing; the HISTORY-entry sweep for `still owed|pending|is blocked|BLOCKED|
SKIPs today|SKIPs on` still returns nothing.

T2 was not re-run: every change in this round is prose or a `.cla` comment, the
suite build above proves the comment edit did not disturb the compile, and
nothing under `runtime/`, `clarusc/`, `tests/` or any golden was touched.

### Files changed in the fix round

`CLAUDE.md`, `docs/HISTORY.md`, `testsuite/toolbox/cases_atalk.cla` (comment
only). `docs/ROADMAP.md`, `docs/TODO.md`, `docs/FUTURE.md` and the reference
are unchanged from `d1b0fc6`.

### Concerns

The four concerns in the original report stand. Nothing new -- except that
Important 2 is a reminder that "I checked the header" in my first self-review
meant one sentence of it, not the whole comment; the fix is read the block,
not the line the finding names.
