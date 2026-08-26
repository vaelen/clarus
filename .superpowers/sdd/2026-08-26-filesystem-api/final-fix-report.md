# filesystem-api final-review fix wave

Base: `4c7a1f3` (HEAD at dispatch, T2 PASS). One fix wave, applied directly
(no subagent dispatch per the controller's own instruction for this wave).

## Findings addressed

### Important 1 — `""` lane parity is nominal
`docs/clarus-language-reference.md`, Files section, Host-behaviour
paragraph: added one sentence — "On the Macintosh, `file.info(\"\")`
reports only `isDir`; its other fields are zero (a host build reports the
folder's real dates)." Non-ASCII file (the doc has em-dashes elsewhere);
edited via a python script (`patch_docs.py`), not the Edit tool.
Byte-diff proof (sha256 before/after, from the patch run):
```
before=615f9e0d44dd536d5117e8d6f8ed20188d9937812a26d75413ec8fc5250e2834
after =35df459dd9581501df8d07ec11d8e69241d59578587665aa1fd28314d280ff3c
```

### Important 2 — `file.rename`'s `newName` accepts a path on the host
Fixed at the shared lane-neutral waist: `runtime/clarus/fileh.cla`'s
`rtFhRename` (now ~line 335) rejects an empty `newName` or one containing
`:` with `rtSetLastErr(-37, "rename failed")` (bdNamErr — the same OSErr
native's `PBHRenameSync` itself returns for a colon-bearing leaf name) and
returns `false` **without** calling `rtFhDevRename` — neither device layer
is reached with a path-shaped `newName` now.

New assertion added to `testsuite/core/cases_dirops.cla` (after the
successful rename, before the delete section):
```
if file.rename(":DirOpsT:c.dat", "sub:d.dat") {
    return tkFail("DirOps", "rename with path succeeded")
}
```
Lane-neutral (no `#ifdef`/lane branch needed) — proven on host CLI and
native (test tails below).

Reference row also updated: `rename`'s Notes column now ends "-- a
`newName` containing `:` fails". Same script/byte-diff as Important 1
(same file, same `patch_docs.py` run):
```
before=35df459dd9581501df8d07ec11d8e69241d59578587665aa1fd28314d280ff3c
after =74b35aced539139a9403ee2960b3017e4a7a96457597b25817df5f1c92d73d45
```

### Minor 3 — inverted comment, `clarusc/drive.cla:1520`
"When it ISN'T -1 …" → "When it IS -1 …" (the sentence correctly
describes the `drvPreludeHead == -1` branch, i.e. entriesOnlyHead ==
combined). Comment-only; no non-ASCII in this file, edited with the Edit
tool.

### Minor 4 — `DirOps` rerunnable teardown misses `:DirOpsT:b.dat`
`testsuite/core/cases_dirops.cla`'s best-effort teardown block: added
`file.delete(":DirOpsT:b.dat")` alongside the existing five deletes.

### Minor 5 — `FhHSetTimes` clobbers the shared `rt_fh_stat_buf`
`runtime/host/rt_fileh.inc`'s `rt_ext_FhHSetTimes`: now stats into a
local `struct stat sb` instead of the shared `rt_fh_stat_buf` that
`FhHStatField` reads back from a prior `FhHStat` call.

### Minor 6 — FourCC overlong sentinel ignored
`runtime/clarus/fileh_68k.cla`: added a 3-line shared helper
`rtFh68kPack4CC(s: string): int` (`rtFourCC(UiStrAddr(s))`) used by both
call sites, then a `-1`-check at each:
- `rtFhDevCreate` (~line 164): checks right after packing, before any
  buffer is allocated — no disposal needed on that path, stashes
  `rtFh68kLastErr = -37` and returns 0.
- `rtFhDevSetInfo` (~line 720): checks after packing (namePtr already
  allocated at that point) — disposes `namePtr`, stashes
  `rtFh68kLastErr = -37`, returns it.

-37 is bdNamErr, the same OSErr used for Important 2's rename guard.

### Minor 8 — `rtFhList` leaves `names` partially filled on failure
`runtime/clarus/fileh.cla`'s `rtFhList`: `names.clear()` added in the
`rtFhDevListFailed()` branch, before `rtSetLastErr`/`return false`.
Reference `list` row updated: "...a `path` that is not a folder is a
failure; on failure `names` is empty". Same script, same file:
```
before=74b35aced539139a9403ee2960b3017e4a7a96457597b25817df5f1c92d73d45
after =f12e5b30bf0bc6f3221db9adfb9ce7230c791404d33ccede7ef45895e85029a7
```

### Minor 9 — catalog driver doesn't bind the new consts
`internal/testsuite/catalog_test.go`'s `catalogDriver`: added
`t0 = t0 + fnfErr + fBsyErr + dupFNErr + dirNFErr + fsRtDirID` at the end
of `App.startCLI`, and extended the header comment listing which symbols
each catalog file's driver code references.

### Recommendation 4 — HISTORY note
`docs/HISTORY.md`'s filesystem-api entry, end of the Close-out (Task 7)
bullet: added two sentences noting the design spec's §6 named two risks
(a standalone-gate allow-list for the prelude splice; cg68k golden growth
from an unused record) that both turned out to be non-issues — the
from-source splice needed no allow-list, and cg68k emits nothing for an
unreferenced record type. Non-ASCII file; script-edited.
```
before=6368e66b8d4e379a796f1c487ef3059b89a1c65353a9450afafdda783dbc6628
after =94ce629dd837b7c56fad6086860ab634437a98b46e9f33764603a36f0a98dc73
```

### Deferred to TODO — Minor 7 (not fixed, recorded only)
`docs/TODO.md`, "Runtime / Toolbox robustness" → filesystem-api phase
subsection: added an entry for host `readdir` names >255 bytes being
silently clamped and `FhHRename`/`FhHMove`'s `snprintf` into a 512-byte
`target` silently truncating a 255+255-byte combination (both silent, no
`lastError`). Script-edited (file has non-ASCII elsewhere).
```
before=96feba8129ff8b2540b3e89a4b9e669ddaad87f4997ae8c1e37b272d3a4a53fe
after =91bd051f85bf164d23bc0cb167013cbc3aad2e6e7ffedc92043d53c9e45bdc31
```

## Files touched
- `docs/clarus-language-reference.md` (script edit)
- `docs/HISTORY.md` (script edit)
- `docs/TODO.md` (script edit)
- `clarusc/drive.cla`
- `runtime/clarus/fileh.cla`
- `runtime/clarus/fileh_68k.cla`
- `runtime/host/rt_fileh.inc`
- `testsuite/core/cases_dirops.cla`
- `internal/testsuite/catalog_test.go`

## Tests / gates run

**Host core CLI (`all`)** — bootstrap + compose + run:
```
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
```
Tail:
```
PASS FileHandleRW
PASS DirOps
PASS SelfCheck
TOTAL 79 PASS 79 FAIL 0
```
(The two new assertions — the aborted-run teardown covering `b.dat`, and
the `file.rename(..., "sub:d.dat")` path-rejection check — are both
inside this `DirOps` case; PASS confirms both.)

**`go test -count=1 ./internal/hostrt -run TestFilehC`**
```
ok  	clarus/internal/hostrt	0.817s
```

**`go test -count=1 ./internal/testsuite`** (covers `TestCatalogChecks`,
exercising the Minor 9 catalog-driver line)
```
ok  	clarus/internal/testsuite	13.884s
```

**`scripts/test-task.sh --smoke`** (runtime changed):
```
ok  	clarus/internal/asm68k	3.130s
ok  	clarus/internal/bake	3.278s
ok  	clarus/internal/cg68k	4.151s
ok  	clarus/internal/claruscboot	1.192s
ok  	clarus/internal/conntest	9.208s
ok  	clarus/internal/emitui	5.119s
ok  	clarus/internal/hostrt	14.319s
ok  	clarus/internal/lowlevel	19.066s
ok  	clarus/internal/mactest	23.873s
ok  	clarus/internal/perfgate	2.618s
ok  	clarus/internal/reftest	2.306s
ok  	clarus/internal/sertest	4.538s
ok  	clarus/internal/testsuite	3.644s
ok  	clarus/internal/mactest	10.325s
test-task.sh: PASS in 34s (smoke=1)
```
`cg68k`/`emitui` (the golden-comparison packages) passed clean — no
rebless needed.

**Native boot — `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest
-run 'TestCoreSuiteGUIOn68k' -v`** (no stray minivmac beforehand; ran in
foreground):
```
=== RUN   TestCoreSuiteGUIOn68k
--- PASS: TestCoreSuiteGUIOn68k (3.96s)
PASS
ok  	clarus/internal/mactest	4.113s
```
This test's own `checkCoreSuiteCapture` requires all `wantCoreSuiteCases`
(79) real `CoreTest` cases to PASS in the one captured native boot log —
it does not emit per-case `t.Run` subtests the way the toolbox suite gate
does (only `TestToolboxSuiteOn68k` fans out per-case; confirmed by
reading `internal/mactest/coresuite_test.go`'s own doc comments). The
aggregate PASS covers `DirOps` (including both new assertions) natively;
no per-case line is separately printed on a PASS, only on a FAIL (none
occurred).

**Fixed-point snapshot check** —
`go test -count=1 -timeout 30m ./internal/selfhost -run TestSnapshotFixedPoint`:
```
ok  	clarus/internal/selfhost	1.269s
```
Passed as-is — no snapshot regeneration needed. Expected: the only
`clarusc/*.cla` change (Minor 3, `drive.cla`) is comment-only, so
`clarusc emit`'s own emitted C is byte-identical and the committed
`clarusc/clarusc.c` snapshot needed no regen.

Snow-gated tests were not run, per instruction.

## Golden statement
No `cg68k`/`emitui` golden files changed. `scripts/test-task.sh --smoke`
ran both golden-comparison packages clean against the new
`fileh_68k.cla`/`fileh.cla` bodies (new `rtFh68kPack4CC` helper, the
`-1`-check additions in `rtFhDevCreate`/`rtFhDevSetInfo`, the rename
leaf-name guard, the list-failure clear) — no diff, no rebless triggered.

## Commit(s)
One commit, `fix: filesystem-api final-review wave -- rename leaf-name
guard, info("") host note, FourCC overlong guard, DirOps teardown,
catalog consts`.
