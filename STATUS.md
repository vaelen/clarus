# Session status — 2026-08-26 (filesystem-api: COMPLETE, T2 green, not merged)

Handoff summary. **The `filesystem-api` phase (branch `filesystem-api`,
based on `main` at `8b8e8e2` — `binary-files` and `transfer-crcs` are
already merged into local `main`) adds `file.makeDir/delete/list/
exists/info/setInfo/rename/move` on both lanes, closing the remaining
68kBBS filesystem gaps (`docs/language-gaps.md` §1/§2/§3/§5/§6/§7 in
the `68kbbs` project). Task 1 was a hardware probe wave (trap/selector/
offset verification, path-form spikes, the `drive.cla` splice-point
analysis) with no code commit. Task 2 built the `toolbox/files.cla` HFS
catalog/directory family (`_HFSDispatch`'s selector-in-D0 traps plus
five `PBH*` single-trap routines). Task 3 added a new predeclared
`FileInfo` record (a from-source `runtime/clarus/prelude.cla` splice
ahead of the standalone user-code check) and `file.exists`/`file.info`
on the host lane. Task 4 added the remaining six calls on the host
lane, HFS→POSIX path translation, and the `DirOps` core suite case.
Task 5 built the native lane (`fileh_68k.cla`), adding ONE new native
global (`rtFh68kState`) and reblessing the cg68k/emitui corpus once.
Task 6 added host C twins for the `ReadDateTime`/`SecondsToDate`/
`DateToSeconds` public catalog externs. Task 7 (this close-out)
regenerated the bootstrap snapshot, hit and fixed a PRE-EXISTING native
UI crash the T2 gate surfaced (`4bc0a07`, see below — not a
filesystem-api defect), closed out docs, and left a written-but-
uncommitted update to `../68kbbs/docs/language-gaps.md` (+
`docs/fidonet.md`) for Andrew. Full T2 PASS (see §1). NOT merged, NOT
pushed — merge only on Andrew's request.**

## 0. START HERE next session

**Pre-merge obligations (both owed, neither run this phase):**

1. **System 7 (Snow) verification is UNVERIFIED for this entire
   phase.** A live, unrelated 68kbbs session owned the one Snow
   instance throughout (Task 1's probe wave, Task 5's native lane, and
   the `TestClarusCBakePathOnSnow` rerun below all deferred for the
   same reason). Every `PBH*`/`_HFSDispatch` trap this phase uses
   predates System 7, so no difference is expected — but nothing in
   this phase's own hardware evidence is System-7-backed. Re-run Task
   1's probe (or at minimum `DirOps`, the core-suite case) on Snow
   before merge.
2. **`TestClarusCBakePathOnSnow`** (`CLARUS_SNOW_TESTS=1 go test
   -count=1 -timeout 90m ./internal/mactest -run
   TestClarusCBakePathOnSnow`, ~55 min) is owed after any runtime-module
   addition — `fileh_68k.cla` gained real bodies this phase (Task 5).
   Deferred for the same reason as (1). Task 3's own manual `--rtbake`/
   `--rtbake --testapi` experiments are the only current evidence the
   bake path works with the new `prelude.cla` splice.

Otherwise the phase is fully closed on the branch: snapshot regenerated
and fixed-point-verified, T2 green, docs closed out.

**A pre-existing native UI crash surfaced and was fixed this task**
(commit `4bc0a07`, full trail
`.superpowers/sdd/2026-08-26-filesystem-api/crash-report.md`): T2's
gated native lane bombed on `TestToolboxSuiteJiggleOn68k` ("illegal
instruction") while the plain `TestToolboxSuiteOn68k` stayed green —
exactly the signal the correctness-cleanup phase's heap-jiggle harness
exists to catch. Root cause: `runtime/clarus/uitext.cla`'s
`rtUiTeWidestLine` held a `TEHandle` master pointer across
`rtUiGetPortSaved()`'s allocation (`UiNewPtr`, the jiggle waist),
then kept reading through the now-stale pointer — a pre-existing bug,
**not** a filesystem-api defect (two builds with byte-identical CODE
segments landed on opposite sides of the crash; Task 5's new global
merely re-rolled the heap layout that made it live). Fixed by hoisting
the allocating call above the master-pointer capture; 14 `emitui` +
3 `cg68k` `.seg2.s` goldens reblessed (one statement moved, normalized
in the crash report). `docs/HISTORY.md`'s phase entry and
`docs/ROADMAP.md`'s standing rule both cite it as the seventh instance
of this bug class; `docs/TODO.md` records the follow-up (a core-suite
jiggle twin — the jiggle gate exists only for the toolbox suite today).

**What this phase built** (7 tasks; Task 1 no code commit, Tasks 2-6
one feat + one fix-round commit each, plus the crash fix `4bc0a07` and
this Task 7 close-out commit; full detail in
`.superpowers/sdd/2026-08-26-filesystem-api/`):

1. **`toolbox/files.cla` HFS catalog/directory family** (Task 2,
   `75d9c39`, fix round `9549634`) — the `_HFSDispatch` trap trio
   (`PBGetCatInfoSync`/`PBSetCatInfoSync`/`PBDirCreateSync`/
   `PBCatMoveSync`, trap `0xA260`, selector in D0 via `moveq #N,D0`,
   `reg(a0: pb, d0: selector) ret d0`) plus five single-trap
   `PBH*Sync` routines; records `HFileParam`/`CInfoPBRec`/
   `CMovePBRec`/`HIOParamRename`; cookbook §12.
2. **`FileInfo` prelude + `file.exists`/`file.info`** (Task 3,
   `3e6aa69`, fix round `5efc3f5`) — `runtime/clarus/prelude.cla`
   spliced from source as the very first file in `driveCompile`, so
   the predeclared `FileInfo` record is visible to the STANDALONE
   check on every lane/mode. `MethodSig.retNameIdx`/`sigEndNamed`
   resolve `file.info`'s return type by name at check time. A parallel
   `ParamSpec.recNameIdx`/`psRecNamed` mechanism was drafted, never
   became reachable, and was deleted (controller ruling) rather than
   left dead. Fix round 1 guarded a `-1`-index crash on a missing
   prelude (undeclared `FileInfo` now diagnoses cleanly instead of
   panicking) and corrected the `--rtbake` manifest-drift exclusion.
3. **`file.makeDir/delete/list/setInfo/rename/move`, host lane, HFS→
   POSIX paths, `DirOps` core case** (Task 4, `8454885`, fix round
   `3e97204`) — `rt_fh_posix_path` (`runtime/host/rt.c`) is the ONE
   hook every path-taking C entry point shares. Fix round 1: a
   `readdir()` error was silently reported as a truncated success;
   `rtFhDevListFailed()` now surfaces it.
4. **Native lane** (Task 5, `2084ccc`, fix round `607c2fa`) —
   `fileh_68k.cla` drives every call for real. ONE new native global,
   `rtFh68kState` (lazily `SerNewPtr`'d 44-byte state block).
   Reblessed the cg68k/emitui corpus once: uniform A5 shift, one
   `cg_init_globals` zero-init pair per program, one fixture
   (`peep_pushpop.s`) crossed into a new second segment. Fix round 1:
   `""` generalized to name the program's own folder for
   `exists`/`info` too, on both lanes (was list-only, host-lane-absent
   for the other two).
5. **Host date glue** (Task 6, `856d1d1`) — host C twins for the
   PUBLIC `ReadDateTime`/`SecondsToDate`/`DateToSeconds` catalog
   externs, so a host build linking them now works.
6. **Latent crash fix** (Task 7, `4bc0a07`) — see above.
7. **Close-out (Task 7, this commit)**: bootstrap snapshot
   regenerated and fixed-point-verified (confirmed unaffected by the
   crash fix, which touches no `clarusc/*.cla`); `toolbox/files.cla`'s
   `CMovePBRec.ioNewName` comment corrected + a `dirNFErr` const added
   (replacing a bare `-120` in `fileh_68k.cla`); the reference's
   Host-behaviour paragraph extended (`setInfo`'s `created` is ignored
   on a host too); two stray `--` fixed to em dashes near the `Files`
   section; `docs/TODO.md`/`docs/ROADMAP.md`/`docs/HISTORY.md`/
   `CLAUDE.md` closed out; `../68kbbs/docs/language-gaps.md` (+
   `docs/fidonet.md`) updated but left UNCOMMITTED in that repo, for
   Andrew.

**Task 1's hardware findings worth remembering** (probe wave, Mini
vMac/System 6 only — full trail:
`.superpowers/sdd/2026-08-26-filesystem-api/task-1-report.md`):

- `PBHRenameSync` rejects the ordinary `ioDirID=0` + partial-path
  convention every other HFS call in this phase accepts
  (`bdNamErr`/`dirNFErr`); it needs a bare leaf name plus the item's
  real parent DirID, resolved via one extra `PBGetCatInfoSync` call.
- Both a nested partial path (`:ProbeA:B:x.dat`) and a full
  volume-qualified path (`vol + ":ProbeA:B:x.dat"`) opened
  successfully natively with zero code changes — verified only
  against the probe's own boot volume, never a second mounted volume.
- `ioDirID = 0` genuinely enumerates the default folder.
- `""` names the program's own folder for `list`/`exists`/`info` on
  both lanes (fix round 1 generalized this beyond `list`).
- There is no `Name(ptr)`-style overlay/conversion form for `extern
  record` — only `var x: SomeRecord`-style locals; `fileh_68k.cla`
  uses function-local records reused across calls instead of a
  persisted PB record.

## 1. Gate results (this phase)

1. **Snapshot fixed point**: PASS. Regenerated per
   `TestSnapshotFixedPoint`'s exact recipe (`cc`-only bootstrap, no Go
   compiler): `go test ./internal/selfhost -run TestSnapshotFixedPoint
   -count=1 -timeout 30m` → PASS ("snapshot fixed point reached: gen1
   == gen2 (4923665 bytes), and matches the committed snapshot").
   Re-checked after the crash fix (`4bc0a07`, which touches no
   `clarusc/*.cla`) — still at the fixed point, no regen needed.
2. **Reftest manifest**: `go test -count=1 ./internal/reftest` → PASS,
   no fence shift, no manifest regeneration needed.
3. **T2** (`scripts/test-merge.sh`, run in pieces, foreground): PASS.
   `scripts/test-task.sh --smoke` (T1 body + 2 native smokes) → PASS,
   35s. `CLARUS_MAC_TESTS=1 go test ./internal/mactest` (no `-run`
   filter, includes `TestToolboxSuiteJiggleOn68k` and every other
   native-lane boot) → PASS, 184.7s. `go test ./internal/selfhost
   -count=1 -timeout 30m` → PASS, 130.8s. `go test ./internal/reftest
   -count=1` → PASS, 0.4s. `CLARUS_BAKE_FULL=1 go test ./internal/bake
   -count=1 -timeout 10m` (full-corpus byte-identity gate) → PASS,
   6.5s. `TestClarusCBakePathOnSnow` NOT run (deferred, §0 above).
4. **Docs**: this file, `docs/ROADMAP.md` ("Next: language usability"
   item 1 extended + a new "Where we are" paragraph + the standing
   rule's bug-class count 6→7), `docs/TODO.md` (five new phase
   subsections: language follow-ups, a compiler-correctness minor, six
   runtime/toolbox minors, a bake-machinery pre-existing gap, seven
   test-coverage gaps including the jiggle-twin follow-up),
   `docs/HISTORY.md` (new phase entry + a "Latent bug found" paragraph
   + the Task 2/Task 3 golden-churn record — each reblessed all 19
   `testdata/emitui/*.c.golden` files, additive-only), `CLAUDE.md`
   (core-suite count 78→79, `toolbox/files.cla` no-longer-thin
   description, `prelude.cla` next to `--bake`, one sentence in the
   binary-files paragraph), the language reference (Host-behaviour
   paragraph extended, two `--`→em-dash fixes) — all committed
   alongside this file.

## 2. Prior phases (all merged; recap pointers only)

- **transfer-crcs** (`text.crc16x`/`text.crc32`) — merged to local
  `main` 2026-08-25 (part of this branch's own base, `8b8e8e2`).
- **binary-files** (`filehandle`, `connection` as a value, `text`
  binary accessors + `crc16`, `string(n)`, the `toolbox/` include
  fallback, emit68k's per-function big-temp pool) — merged to local
  `main` 2026-08-23 (part of this branch's own base).
- **correctness-cleanup** — merged to `main` (ff `48a4696..3a4c054`),
  pushed 2026-08-18.
- **serial-connection** (fenced `connection` type, serial as first
  transport, both lanes, Snow-hardware-proved) — merged 2026-08-16.
- **clir-load-perf** — merged 2026-08-15/16. Both Snow gates PASSED.
- **attempt-abort** — merged 2026-08-15.
- **object-code-linker** — merged 2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Doc-hygiene note (pre-existing, not this task's job):** `attempt-abort`,
`serial-connection`, and `correctness-cleanup` are all merged to `main`
but none has its full write-up archived into `docs/HISTORY.md` yet
(HISTORY jumps from `clir-load-perf` straight to `binary-files`, with a
note explaining the gap) — a future docs pass should catch HISTORY up
through all three.

**Standing rules:** `internal/selfhost` always gets `-count=1 -timeout
30m`. Merge only on Andrew's request; main stays green (this branch
does NOT touch main).
