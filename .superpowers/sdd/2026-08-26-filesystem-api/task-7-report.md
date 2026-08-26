# Task 7 report: close-out — snapshot, docs, ledger, 68kBBS gaps

Status: **DONE** (T2 green, including a latent-bug fix commit `4bc0a07`
made by a dispatched crash-debugger agent mid-task; docs updated to
reflect it).

## What changed, per file

- `clarusc/clarusc.c` — regenerated via `TestSnapshotFixedPoint`'s
  cc-only recipe. Re-checked after the crash fix (`4bc0a07`, which
  touches no `clarusc/*.cla`) and confirmed still at the fixed point;
  no second regen needed.
- `internal/reftest/manifest.go` — **not modified**. `go test -count=1
  ./internal/reftest` was green throughout; no fence shift, no
  regeneration required.
- `toolbox/files.cla` — (1) `CMovePBRec.ioNewName`'s comment corrected:
  it names the destination FOLDER's own path, not the item's new leaf
  name (Task 1 step 8 proved this; `fileh_68k.cla`'s `rtFhDevMove`
  comment already said it correctly). (2) `const dirNFErr: int = -120`
  added to the error-const block, cited against `MacErrors.h` (Files.h
  itself doesn't carry `dirNFErr`) reflowed line 108, same citation
  style as its neighbors.
- `runtime/clarus/fileh_68k.cla` — `rtFhDevListBegin`'s bare `-120`
  replaced with `dirNFErr`. One line.
- `docs/clarus-language-reference.md` — Files section Host-behaviour
  paragraph extended: `setInfo`'s `created` is now also documented as
  ignored on a host build (POSIX birth time isn't settable), not just
  `type`/`creator`. Two stray `--` (lines ~176, ~1441) changed to em
  dashes to match their neighbors. Edited via a Python script (file has
  7 pre-existing non-ASCII lines); byte-diff proof below.
- `docs/TODO.md` — five new `### filesystem-api phase (2026-08-26)`
  subsections: under "Language features" (resource-fork-as-bytes/
  `file.openRF`, `list of string(31)` capacity, recursive `makeDir`,
  combined rename+move, `PBSetCatInfoSync` declared-but-unused); under
  "Compiler correctness / diagnostics" (the `drive.cla` splice-rationale
  restated-at-4-sites minor); under "Runtime / Toolbox robustness" (six
  Task 3/4/5 code minors: `rt_fh_mac_time` duplication,
  `rtFhDevListBegin` double-call leak guard, `rtFhDevRename`
  re-deriving the parent DirID, unchecked `SerNewPtr`,
  `rtFh68kFourCCToStr`'s zero-type/folder conflation, `rtFh68kName`'s
  >255 truncation); under "Bake / CLIR artifact machinery" (the
  pre-existing C-lane `--rtbake` gap for `filehandle` programs); under
  "Test coverage gaps" (the `--rtbake`/`file.info` test gap, folder
  rename untested, `file.list("")` untested, `rtFhDevListFailed`'s true
  branch unexercised natively, System 7 unverified, the full-path spike
  verified only on the boot volume, and — added after the crash fix —
  a core-suite jiggle twin, since the toolbox suite is the only jiggle
  boot in the tree).
- `docs/ROADMAP.md` — new "Where we are" paragraph for the
  `filesystem-api` phase (branch, base, what shipped, hardware
  findings, NOT merged); item 1 ("Binary streams and files") extended
  with the phase's own DONE sentence; the standing rule's
  stale-master-pointer bug-class count bumped 6→7, citing the
  `rtUiTeWidestLine` find.
- `docs/HISTORY.md` — new phase entry (what shipped per task, the
  `FileInfo` prelude mechanism, the dead `psRecNamed` deletion, the
  `_HFSDispatch` `reg(d0: selector)` shape, host HFS path translation,
  the one new native global `rtFh68kState` and its golden rebless,
  Task 1's hardware findings including the full-path answer, deferred
  items) plus a "Latent bug found" paragraph (what, why the jiggle gate
  caught it, that no phase commit caused it — proved via byte-identical
  CODE segments on both sides of the crash — fix commit `4bc0a07`).
- `CLAUDE.md` — core-suite count line 78→79 (`DirOps`); `toolbox/
  files.cla`'s catalog description no longer calls it "deliberately
  thin" (it grew from a SetVol-only scope to the full HFS catalog/
  directory family); `runtime/clarus/prelude.cla` mentioned next to
  `--bake` (the glob picks it up automatically); one sentence in the
  binary-files paragraph pointing at the filesystem-api surface.
- `STATUS.md` — full rewrite: branch/base header, the crash fix
  surfaced and resolved this task, per-task commit list, Task 1's
  hardware findings, gate results (all PASS, with timings), the two
  owed pre-merge obligations (System 7 spot check, `TestClarusCBakePathOnSnow`),
  prior-phases recap.
- `.superpowers/sdd/2026-08-26-filesystem-api/progress.md` — carries
  the crash-debugger agent's own ledger entries (dispatched by the
  coordinator mid-task, not by me); included in this commit per the
  existing convention (every prior Task-N ledger update in this phase
  was committed the same way).
- `../68kbbs/docs/language-gaps.md` + `../68kbbs/docs/fidonet.md`
  (separate repo) — see the 68kbbs section below. **Left uncommitted**
  per the controller's ruling.

## The crash fix (not authored by me — see below)

Mid-task, `TestToolboxSuiteJiggleOn68k` bombed natively ("illegal
instruction") during my own gate runs. I bisected (via `git worktree`,
without touching my working tree) far enough to confirm: PASS on
pre-phase `main`@`8b8e8e2` (45s) and at this phase's Task-4 tip
`3e97204` (57s); a run at Task-5 tip `607c2fa` was still in progress
when the coordinator intervened. I reported this verbatim and stopped
rather than attempt a fix myself (outside Task 7's docs/snapshot-regen
scope). The coordinator dispatched a separate crash-debugger agent
(opus), which root-caused and fixed it at commit `4bc0a07`:
`runtime/clarus/uitext.cla`'s `rtUiTeWidestLine` held a `TEHandle`
master pointer across `rtUiGetPortSaved()`'s allocation (`UiNewPtr`,
the heap-jiggle waist) and kept reading through it once stale — a
PRE-EXISTING bug (proved via two byte-identical-CODE-segment builds
landing on opposite sides of the crash), not a filesystem-api defect;
Task 5's new global merely re-rolled the heap layout that made it
live. Full trail: `.superpowers/sdd/2026-08-26-filesystem-api/crash-report.md`.
I incorporated it into HISTORY/ROADMAP/TODO per the coordinator's
instructions (see above) and re-verified the snapshot's fixed point
still holds (the fix touches no `clarusc/*.cla`).

## Snapshot regen + fixed-point PASS

```
$ cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
$ /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
$ cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
$ /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
$ go test -count=1 -timeout 30m ./internal/selfhost -run TestSnapshotFixedPoint -v
=== RUN   TestSnapshotFixedPoint
    fixedpoint_test.go:146: snapshot fixed point reached: gen1 == gen2 (4923665 bytes), and matches the committed snapshot
--- PASS: TestSnapshotFixedPoint (12.77s)
PASS
```

Re-checked after the crash fix landed (`4bc0a07`):

```
$ grep -c "rtUiTeWidestLine\|rtUiGetPortSaved" clarusc/clarusc.c
0
$ go test -count=1 -timeout 30m ./internal/selfhost -run TestSnapshotFixedPoint -v
--- PASS: TestSnapshotFixedPoint (0.93s)
```

Sanity: `scripts/clarus-run.sh testdata/run/dirops_info.cla` (Go-free,
rebuilds from the regenerated snapshot) prints all its `ok` lines.

## T2 gate — run in foreground, one piece per shell call

```
$ scripts/test-task.sh --smoke 2>&1 | tail -20
... 13 packages ok, PASS in 35s (smoke=1)

$ CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest 2>&1 | tail -30
ok  	clarus/internal/mactest	184.666s
# includes TestToolboxSuiteJiggleOn68k (the previously-bombing test) —
# PASS, along with every other native-lane boot (core+toolbox suite
# GUI, 4 frozen UI scenarios, native codegen tests, real-event-loop
# tick, runerr/abort fixtures).

$ go test -count=1 -timeout 30m ./internal/selfhost 2>&1 | tail -30
ok  	clarus/internal/selfhost	130.789s

$ go test -count=1 ./internal/reftest 2>&1 | tail -10
ok  	clarus/internal/reftest	0.438s

$ CLARUS_BAKE_FULL=1 go test ./internal/bake -count=1 -timeout 10m 2>&1 | tail -15
ok  	clarus/internal/bake	6.507s
```

All PASS. `TestClarusCBakePathOnSnow` and any other Snow-gated test:
**not run** (deferred per the ledger's ruling — Snow was owned by a
live 68kbbs session throughout this phase; recorded as an owed
pre-merge obligation in `STATUS.md` §0 and `docs/TODO.md`).

## Byte-diff proofs for non-ASCII files

Every `.md`/`CLAUDE.md`/reference edit in this task was made with a
Python script (never the `Edit` tool), each verified round-trip-decodes
as UTF-8 after writing, and diffed to confirm only the intended text
changed:

```
$ for f in docs/TODO.md docs/ROADMAP.md docs/HISTORY.md docs/clarus-language-reference.md CLAUDE.md STATUS.md; do
    python3 -c "open('$f','rb').read().decode('utf-8')" && echo "$f: valid utf-8"
  done
docs/TODO.md: valid utf-8
docs/ROADMAP.md: valid utf-8
docs/HISTORY.md: valid utf-8
docs/clarus-language-reference.md: valid utf-8
CLAUDE.md: valid utf-8
STATUS.md: valid utf-8
```

`docs/clarus-language-reference.md`'s diff is exactly 3 lines changed
(Host-behaviour paragraph extended + 2 em-dash fixes), confirmed via
`git diff docs/clarus-language-reference.md` showing only those three
`-`/`+` pairs and no other byte moved.

`toolbox/files.cla` and `runtime/clarus/fileh_68k.cla` are plain ASCII
(`LC_ALL=C grep -nP '[\x80-\xff]'` empty on both) — edited with the
`Edit` tool, no byte-safety concern.

`../68kbbs/docs/language-gaps.md` and `../68kbbs/docs/fidonet.md` both
carry non-ASCII bytes too; both edited via Python scripts the same way,
both verified to round-trip as UTF-8.

## 68kbbs working-tree diff (uncommitted, per ruling)

```
$ cd ../68kbbs && git diff --stat
 docs/fidonet.md       |   8 ++-
 docs/language-gaps.md | 137 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 106 insertions(+), 39 deletions(-)
```

`docs/language-gaps.md`: §1/§2/§3/§5/§6/§7 each gained a "**Shipped**
(2026-08-26) — as shipped: …" paragraph with the real shipped
signatures (noting where they differ from the original request — e.g.
`file.info` RETURNS the record rather than filling an out-param;
rename/move shipped as two separate calls, not one combined call); the
Summary table's rows 1/2/3/5/6/7 marked "— shipped"; the "one open
question … spike" paragraph replaced with Task 1's answer (both
nested-partial and full volume-qualified paths open natively — verified
on System 6, boot volume only, System 7 unverified); a closing note
that `docs/fidonet.md`'s own spike list is satisfied.

`docs/fidonet.md`: its "To verify (spikes...)" paragraph rewritten to
say both spikes (nested partial paths; host-lane date glue) are now
answered/shipped.

**Left uncommitted in that repo**, per the controller's ruling
(precedent: the transfer-crcs phase's own cross-repo §8 edit was left
uncommitted the same way) — one `git commit` there is Andrew's to make.

## Self-review

- Core-suite count (78→79): checked against `testsuite/core/runner.cla`'s
  `const nCoreCases: int = 79` directly — matches every doc claim.
- Toolbox-suite count (31 real + SelfCheck = 32): unchanged this phase,
  no doc claim altered.
- Every commit SHA cited in HISTORY/STATUS (`75d9c39`, `9549634`,
  `3e6aa69`, `5efc3f5`, `8454885`, `3e97204`, `2084ccc`, `607c2fa`,
  `856d1d1`, `4bc0a07`) checked against `git log --oneline --reverse
  main..HEAD`.
- No claim of System 7 or Snow-bake verification appears anywhere in
  the docs touched this task — every such mention is explicitly flagged
  UNVERIFIED/deferred/owed.
- Golden counts cited (14 `emitui` + 3 `cg68k` `.seg2.s` for the crash
  fix; 19 `emitui` + 49 `cg68k`/1 new `.seg2.s` for Task 2/Task 5)
  checked against `git show 4bc0a07 --stat` and the task reports
  respectively, not paraphrased from memory.
- Snapshot regen: confirmed both before AND after the crash fix landed,
  since the fix could in principle have touched `clarusc/*.cla` (it
  did not — verified by grep and by `git show 4bc0a07 --stat`).

## Concerns

- None blocking. The two owed pre-merge obligations (System 7 spot
  check, `TestClarusCBakePathOnSnow`) are recorded in `STATUS.md` §0
  and `docs/TODO.md`, not resolved by this task, by design (Snow was
  unavailable throughout).
- The crash fix (`4bc0a07`) was authored by a separately-dispatched
  debugger agent, not by me — I incorporated its findings into the
  docs this task owns but did not review its diff line-by-line beyond
  what's summarized in `crash-report.md` and the commit message.
