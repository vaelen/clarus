# AppleTalk docs audit — fix report

Branch `docs-appletalk-audit`, worktree `/Users/andrew/repos/clarus-wt/docs`,
one commit `6e53e47` on top of `main` (`6e6e3d4`). Docs-only; no tests,
runtime, compiler, goldens or `.superpowers/` touched.

## Findings

| # | Site after edit | Disposition |
|---|---|---|
| 1 | `docs/TODO.md:77-82` | applied as proposed (kept the trailing "and nothing regresses that specifically today" clause from the original entry, which the proposal dropped silently) |
| 2 | `docs/ROADMAP.md:181-188` | applied with deviation: menu path quoted from `tests/lib_snow.sh`'s `snow_localtalk_b` header as **Ports > Channel B (printer) > Enable LocalTalk (UDP)** — the audit wrote "Channel B", the source comment says "Channel B (printer)". Also added "or workspace field", which the same header states. |
| 3 | `README.md:32-53` | applied with deviation: the Status section is the audit's bullets plus a **Toolbox catalog** bullet (task's README brief asks the layout table to point at `toolbox/`; a Status line makes the pointer findable) and a **Macintosh target** bullet reworded to name `clarusc emit68k` rather than "`emit68k`" bare. |
| 4 | `README.md:55-79` | applied as proposed: Go block deleted, snapshot bootstrap promoted, `scripts/clarus-run.sh` and the two gate scripts added. |
| 5 | `docs/clarus-toolbox-cookbook.md:703` | applied as proposed |
| 6 | `CLAUDE.md:52-54` | applied as proposed (`atalkdrive` appended; the line rewrapped) |
| 7 | `docs/TODO.md:85-89` | applied with deviation: named the three existing fixtures (`too_many_lsn`/`too_many_brs`/`too_many_svc`) instead of the audit's prose paraphrase. |
| 8 | `docs/clarus-toolbox-cookbook.md:15-17` | applied as proposed (all eleven catalog files, verified against `ls toolbox/`) |
| 9 | `docs/ROADMAP.md:57-60`, new paragraph at `141-151` | applied with deviation: also updated the lead sentence from "Everything through the `compiler-cleanup` phase … (`c5d447b`)" to "Everything through the `appletalk` phase … (`6e6e3d4`)" — the audit only asked for the heading date, but the sentence under it was the actual staleness. Verified `main == origin/main == 6e6e3d4`, so "pushed" is true. |
| 10 | `docs/ROADMAP.md:4` | applied as proposed |
| 11 | `docs/HISTORY.md:5894-5896` | applied with deviation: the task requires "(fast-forward, then pushed)", so the appended clause is "**Merged to `main` 2026-09-07 — fast-forward, then pushed (`main` = `6e6e3d4`).**" |
| 12 | `README.md:32-53` | applied — covered by finding 3's bullets (Networking, Toolbox catalog) |
| 13 | `README.md:81-91` | applied as proposed (`runtime/`, `toolbox/`, `examples/` rows added; `docs/` row widened to name the cookbook and history) |
| 14 | `docs/clarus-language-reference.md:1458` | applied as proposed, inserted mid-paragraph between the `failed` sentence and the `stop()` sentence |
| 15 | `docs/clarus-language-reference.md:1558` | applied as proposed |
| 16 | `CLAUDE.md:398-403` | applied with deviation: added "Gitignored like `macplus/`" (verified `.gitignore:4`) since that is why nothing else in the repo names it. |
| 17 | `docs/TODO.md:235-244` | applied with deviation in LOCATION: the audit proposed appending to the AppleTalk subsection of `## Test coverage gaps`, but the entry is compiler code duplication, not a test gap. Filed under a new `## Compiler: cleanup` / `### AppleTalk phase (2026-09-07)` section placed after `## Compiler: type checking`. Text is the audit's, verbatim. |
| 18 | `CLAUDE.md:189-191` | applied as proposed |
| 19 | `docs/snow-floppy-howto.md:103-110` | applied with deviation: same "Channel B (printer)" correction as finding 2, plus the source header's own detail that a bad `--serial-bridge-*` value is a WARN and is ignored. |
| 20 | `docs/HISTORY.md:211-224` | applied (the task overrides the audit's "leave it"): added item 12 for AppleTalk in the list's own numbered/bold/DONE format, with a parenthetical noting that items 1-11 are the pre-2026-08 milestones and that `go-retirement`, `compiler-cleanup`, `language-runtime-cleanup`, `native-array-return-and-fileh-guards` and `appletalk` are all merged and recorded as their own `## … phase` sections below. That answers the audit's consistency objection without writing four more long-form entries. |
| 21 | `examples/atalkchat.cla:14-17` | applied as proposed, reflowed to the file's ~72-column comment wrap. File is pure ASCII (`LC_ALL=C grep -c '[^ -~]'` → 0 before and after); verified by byte diff (`git diff \| cat -A`) — comment lines only. |
| 22 | — | not applied (audit says "not now"; the `server.listen(6502)` fence note belongs with the MacTCP phase) |
| 23 | — | not applied (audit says "No action") |

### Extra corrections beyond the 23 (found while editing the same blocks)

- `docs/ROADMAP.md:65` — "five small C tools" → "six" (`ls tests/tools/*.c` is
  six: `atalkdrive` `clirhdr` `resfork` `tcpdrive` `timeout` `uiblob`). Same
  staleness as finding 6, one line below the block finding 9 rewrote.
- `docs/ROADMAP.md:135-136` — the `native-array-return-and-fileh-guards`
  paragraph said "`main` = `d947f9a`; NOT yet pushed to origin", which
  contradicts the "pushed" I just asserted at the top of the same section.
  Changed to "pushed since, with the `appletalk` merge".
- `README.md:3-7` — opening paragraph's "The compiler emits C." replaced per
  the task brief.

## Verification

Tools built first: `make -j tools bootstrap` → exit 0.

```
$ make test T='reftest/ atalk/examples runner/'
PASS reftest/checkclean 1s
PASS reftest/extract 0s
PASS reftest/required 1s
PASS atalk/examples 0s
PASS runner/selfcheck 2s
PASS runner/syntax 0s
PASS runner/timeout 5s
tests: 7 passed, 0 skipped, 0 failed
```

(The reference gate's group is `reftest/`, confirmed by
`grep -rl clarus-language-reference tests/` → `tests/lib_reftest.sh`,
`tests/reftest/manifest.txt`.)

```
$ git diff --stat
 CLAUDE.md                         | 11 ++++++--
 README.md                         | 54 +++++++++++++++++++++++++++------------
 docs/HISTORY.md                   | 18 ++++++++++++-
 docs/ROADMAP.md                   | 31 +++++++++++++++++-----
 docs/TODO.md                      | 30 +++++++++++++++++-----
 docs/clarus-language-reference.md |  4 +--
 docs/clarus-toolbox-cookbook.md   |  5 ++--
 docs/snow-floppy-howto.md         |  7 +++++
 examples/atalkchat.cla            |  7 ++---
 9 files changed, 127 insertions(+), 40 deletions(-)
```

Every file the audit names is present; the only additions are README,
HISTORY and ROADMAP, all explicitly in scope.

### Commands written into README, each executed in the worktree first

- `cc -I runtime/host -o clarusc clarusc/clarusc.c runtime/host/rt.c` → built.
- `./clarusc FILE...` (check-only) → exit 0 on a scratch program.
- `./clarusc emit -o OUT.c FILE...` → exit 0 on the scratch program and on
  `examples/bookmarks.cla` (a UI program; no `--rtdir` needed from the repo
  root).
- `scripts/clarus-run.sh FILE.cla` → printed the program's output, exit 0.
- `scripts/test-task.sh` / `scripts/test-merge.sh` — quoted verbatim from
  CLAUDE.md's "Build and test" block, not run here (T2 needs the emulator).

### Code claims verified before writing them

- `clarusc/lower.cla:1630-1640` lowers `open` with `callTransport(e) == 1`
  (the `appletalk` arm) — finding 1's premise holds.
- `runtime/clarus/atalk.cla:932` calls `rtLsnStop(i + 1)` right after
  `rtLsnSetFailed` — finding 14.
- `runtime/host/rt_atalk.inc:435-436` — "the spec's 3 x 1 s window: the Mac's
  registerName blocks ~3.2 s for the same verify" — finding 15.
- `docs/clarus-language-reference.md:174` — "at most 8 global `connection`
  variables" — finding 7's cap number.
- `tests/lib_mac.sh:71` — `--minivmac-dir "$ROOT/macplus2" --minivmac-path
  ./MacPlus2.app` — finding 16.
- `tests/mactest/atalk_selfserve.sh` exists — finding 18.
- `ls toolbox/` = 11 files — findings 5, 8.
- `testsuite/toolbox/runner.cla:213` `const nTbCases: int = 40` — the
  "40/40" in ROADMAP's new paragraph.
- `git rev-parse main origin/main` → both `6e6e3d4` — "pushed".

## Final grep sweep

```
$ grep -n 'go build\|cmd/clarus\|Not merged\|blocked on\|SKIPs today\|still owed' \
    README.md docs/*.md CLAUDE.md
docs/HISTORY.md:737   the last 2 blocked on a real hang — see below
docs/HISTORY.md:986   deletion (cmd/clarus + …
docs/HISTORY.md:1376  replaces day-to-day `clarus run` — `cmd/clarus` + the Go frontend
docs/HISTORY.md:1495  `cmd/clarus` + `internal/{lexer,parser,check,types,lower,cprint,driver,
docs/HISTORY.md:2202  **T2 (`scripts/test-merge.sh`) still owed before any merge**
docs/HISTORY.md:2324  **T2 (`scripts/test-merge.sh`) still owed before any merge** — now
docs/HISTORY.md:2510  DONE (T1 + selfhost; T2 emulator body still owed before merge).
docs/HISTORY.md:5900  run) was blocked on a toolchain patch outside this repo until
```

All eight are in `docs/HISTORY.md`, the verbatim archive:

- 737, 986, 1376, 1495 — historical narrative about the Go compiler's hang
  investigation and its deletion (`cmd/clarus` is named as the thing that was
  deleted). Correct as history.
- 2202, 2324, 2510 — per-task write-time snapshots inside older phase
  entries ("T2 still owed before any merge"); those phases have since merged.
  House convention for a write-time snapshot, same as the sentence finding 11
  amended.
- 5900 — the AppleTalk entry's own "Task 13 … was blocked on a toolchain
  patch outside this repo until 2026-09-07, and was amended into this entry
  once it landed". Resolved within the same sentence.

Zero hits in `README.md`, `CLAUDE.md`, `docs/ROADMAP.md`, `docs/TODO.md`,
`docs/clarus-language-reference.md`, `docs/clarus-toolbox-cookbook.md`.

## Newcomer read of README

Read top to bottom after the rewrite. 99 lines. One thing changed on that
pass: the Building section originally jumped from the bootstrap straight to
the gate scripts, which left `scripts/clarus-run.sh` unexplained — it now
carries the one-line "does the bootstrap, the emission, the C compile and the
run" gloss. No other wording failed to parse.

## Concerns

1. **Finding 20 is a judgement call.** The audit recommended leaving the
   `## Done (all merged to main)` list alone or adding all five recent
   phases; the task required AppleTalk in it. I added one entry plus a
   parenthetical that names the other four as merged and points at their own
   sections. If Andrew wants four more long-form entries instead, that is a
   separate pass.
2. **Finding 17's location differs from the audit's.** A new `## Compiler:
   cleanup` heading now exists in `docs/TODO.md`. `docs/ROADMAP.md` records
   that the old "Compiler correctness / cleanup" section was deleted when it
   emptied, so re-creating one is consistent with how that file has been
   used, but it is a structural change the audit did not ask for.
3. **README's `./clarusc emit -o OUT.c FILE...` line omits `--rtdir`.** It
   works from the repo root (verified on a UI example), and CLAUDE.md's
   compose recipe passes `--rtdir runtime/clarus/` explicitly. A reader
   running it from elsewhere would need the flag. Left short deliberately —
   `scripts/clarus-run.sh` is the recommended path and handles it.
4. **Not run:** `scripts/test-merge.sh` (T2) and any emulator lane. The three
   requested gates plus the reference gate are green; nothing in this diff
   touches a tested artifact except `examples/atalkchat.cla`'s comment block,
   which `tests/atalk/examples` compiles and which passed.

---

# Fix round 1 (review of `6e53e47`)

One Important and four minors from the coordinator's review, all applied.

## Important 1 — `docs/clarus-language-reference.md:1458` (finding 14)

The audit's proposed sentence was a false universal. Read
`runtime/clarus/atalk.cla:905-963` (`rtAtalkPump`'s listener arm),
`:214-220` (`rtLsnSetFailed`) and `:563-566` (`register`'s
already-active guard). Two distinct failure paths reach `failed`:

- `pr < 0` (`rtLsnDevPoll` reports the listen request itself failed) —
  `rtLsnSetFailed(i, pr, "listener failed")` **then `rtLsnStop(i + 1)`**
  at `:931-932`. Name removed, slot released, state back to idle.
- `rtLsnDevAccept` returns nonzero at `:949` —
  `rtLsnSetFailed(i, e, "could not accept connection")` and nothing
  else; control falls out of the `pr == 1` arm to `rtLsnDevListen(i)` at
  `:959`, which re-arms. The listener stays `rtAtActive`, so a program
  that then calls `register` hits the `:563-566` guard and gets
  `rtConnErrAlreadyOpen` / `"listener already registered"`.

Verbatim string check in `runtime/clarus/atalk.cla`: `"listener failed"`,
`"could not accept connection"` and `"listener already registered"` each
occur exactly once, spelled as quoted above.

New text (replacing the single audit sentence, same position between the
`l.failed` sentence and the `l.stop()` sentence):

> After a successful `register`, what a `failed` costs depends on which
> failure it reports. A lost listen request — the listener's own
> machinery failing — tears the listener down: the name is removed and
> the listener released, exactly as if `stop()` had been called, so a
> program that wants to keep serving must `register` again. A single
> connection that could not be accepted does not: the listener stays
> registered and listening, the next client can still connect, and
> `register` on it fails with *listener already registered*.

Deliberately worded by what the program observes ("a lost listen
request" / "a single connection that could not be accepted") rather than
by runtime internals, matching the chapter's voice; the `failed` message
strings are the discriminator a program actually sees.

## Minor 2 — `docs/HISTORY.md:219-225`

`grep -n '^## .*phase' docs/HISTORY.md` returns exactly five:
`go-retirement`, `compiler-cleanup`, `language-runtime-cleanup`,
`native-array-return-and-fileh-guards`, `AppleTalk`. The parenthetical
now names those five as the ones with their own top-level section and
says the rest are bullets under the sections above, instead of claiming
every phase since 2026-08 has one.

## Minor 3 — `CLAUDE.md:398-402`

`tests/mactest/adsp_68k.sh:33` is `[ -d "$ROOT/macplus2" ] || skip
"macplus2 not present"`. Changed "missing ⇒ that script cannot run" to
"Missing ⇒ that script SKIPs (`macplus2 not present`)", matching the
`vasm/` and `snow/` siblings' "Missing ⇒ … SKIP" pattern in the same
list.

## Minor 4 — `CLAUDE.md:52-56`

Rewrapped the whole `make -j tools bootstrap` bullet; the two orphan
fragments left by the `atalkdrive` insertion ("the two-stage" and "test
depends on" as standalone short lines) are gone.

## Minor 5 — `docs/clarus-toolbox-cookbook.md:14-20`

Rewrapped the paragraph to the file's ~76-column width. Lines 14-20 are
now 76/76/74/65/71/73/74 characters; the 108- and 115-character lines the
eleven-file list produced are gone.

## Verification

```
$ make test T='reftest/ runner/'
PASS reftest/checkclean 0s
PASS reftest/extract 0s
PASS reftest/required 2s
PASS runner/selfcheck 1s
PASS runner/syntax 0s
PASS runner/timeout 5s
tests: 6 passed, 0 skipped, 0 failed
```

Files touched this round: `docs/clarus-language-reference.md`,
`docs/HISTORY.md`, `CLAUDE.md`, `docs/clarus-toolbox-cookbook.md`. No new
files, nothing outside the round-1 set.

## Concerns

None new. The round-1 concerns 1-4 above stand unchanged; concern 3
(README's `emit` line omitting `--rtdir`) was not raised in review and is
left as shipped.
