# Task 1 report: probe wave — paths, catalog enumeration, prelude splice point

Status: **DONE_WITH_CONCERNS**. Every probe that could run on Mini vMac
(System 6) ran and produced real hardware data. The Snow (System 7) spot
check did **not** run — see (b)/concerns below; do not read any System 7
claim into this report.

All header line numbers below are against the reflowed copies made per the
brief's Step 1 recipe:

```
LC_ALL=C tr '\r' '\n' < Retro68/InterfacesAndLibraries/Interfaces/CIncludes/Files.h > .../scratchpad/Files.h
LC_ALL=C tr '\r' '\n' < Retro68/InterfacesAndLibraries/Interfaces/AIncludes/Files.a > .../scratchpad/Files.a
```

## (a) VERIFIED trap/selector/offset table

All nine trap declarations were independently re-grepped against the
reflowed headers (not merely carried over from the brief). Every one
matched the brief's expected line numbers and words exactly.

| Extern | Files.h `#pragma parameter`/`EXTERN_API` line | Inline word(s) | Files.a corroboration |
|---|---|---|---|
| `PBGetCatInfoSync` | Files.h:2879-2881 | `TWOWORDINLINE(0x7009, 0xA260)` | Files.a:3367-3371, `Macro _PBGetCatInfoSync / moveq #9,D0 / dc.w $A260 / EndM` |
| `PBSetCatInfoSync` | Files.h:2907-2909 | `TWOWORDINLINE(0x700A, 0xA260)` | Files.a:3419-3423, `moveq #10,D0 / dc.w $A260` |
| `PBDirCreateSync` | Files.h:2792-2794 | `TWOWORDINLINE(0x7006, 0xA260)` | Files.a:3209-3213, `moveq #6,D0 / dc.w $A260` |
| `PBCatMoveSync` | Files.h:2764-2766 | `TWOWORDINLINE(0x7005, 0xA260)` | Files.a:3157-3161, `moveq #5,D0 / dc.w $A260` |
| `PBHDeleteSync` | Files.h:3187-3189 | `ONEWORDINLINE(0xA209)` | Files.a:3899, `_PBHDeleteSync: OPWORD $A209` |
| `PBHRenameSync` | Files.h:3215-3217 | `ONEWORDINLINE(0xA20B)` | Files.a:3943, `_PBHRenameSync: OPWORD $A20B` |
| `PBHGetFInfoSync` | Files.h:3299-3301 | `ONEWORDINLINE(0xA20C)` | Files.a:4075, `_PBHGetFInfoSync: OPWORD $A20C` |
| `PBHSetFInfoSync` | Files.h:3327-3329 | `ONEWORDINLINE(0xA20D)` | Files.a:4119, `_PBHSetFInfoSync: OPWORD $A20D` |
| `PBHOpenRFSync` | Files.h:3103-3105 | `ONEWORDINLINE(0xA20A)` | Files.a:3759, `_PBHOpenRFSync: OPWORD $A20A` |
| `PBGetVolSync` (probe-only) | Files.h:1382-1384 | `ONEWORDINLINE(0xA014)` | Files.a:1502, `_PBGetVolSync: OPWORD $A014` |

Every `_HFSDispatch` trio (`GetCatInfo`/`SetCatInfo`/`DirCreate`/`CatMove`
all dispatch through `$A260` with the selector in D0 via `moveq #N,D0`)
uses `TWOWORDINLINE` in the C header but the Files.a `Macro` body is the
authoritative register contract: `moveq #N,D0` then `dc.w $A260` — pb in
A0 (implicit, standard OS trap convention), OSErr in D0. Bit 11 of
`$A260`/`$A20x`/`$A014` is clear in every case (`0xA260 & 0x0800 == 0`,
etc.), confirming register (not Pascal-stack) convention throughout — the
Clarus declaration shape `trap 0xNNNN reg(a0: pb, d0: sel) ret d0` (for
the three `_HFSDispatch` routines) / bare `trap 0xNNNN reg` (for the
`0xA20x` H-routines) is correct.

### Struct layouts (hand-computed, MPW 68k packing: 2-byte alignment for
`short`/`long`/pointers, 1-byte for `SInt8`; verified by having `emit68k`
successfully lower and run real trap calls against these exact offsets —
see (b)/(c) below)

**`HFileInfo`** (`CInfoPBRec`'s file variant, Files.h:557-586):

| Field | Offset | Size |
|---|---|---|
| `ioNamePtr` | 18 | 4 |
| `ioVRefNum` | 22 | 2 |
| `ioFRefNum` | 24 | 2 |
| `ioFVersNum` | 26 | 1 |
| `filler1` | 27 | 1 |
| `ioFDirIndex` | 28 | 2 |
| `ioFlAttrib` | 30 | 1 |
| `ioACUser` | 31 | 1 |
| `ioFlFndrInfo` (FInfo: `fdType`@32, `fdCreator`@36) | 32 | 16 |
| `ioDirID` | 48 | 4 |
| `ioFlStBlk` | 52 | 2 |
| `ioFlLgLen` | 54 | 4 |
| `ioFlPyLen` | 58 | 4 |
| `ioFlRStBlk` | 62 | 2 |
| `ioFlRLgLen` | 64 | 4 |
| `ioFlRPyLen` | 68 | 4 |
| `ioFlCrDat` | 72 | 4 |
| `ioFlMdDat` | 76 | 4 |
| `ioFlBkDat` | 80 | 4 |
| `ioFlXFndrInfo` (FXInfo) | 84 | 16 |
| `ioFlParID` | 100 | 4 |
| `ioFlClpSiz` | 104 | 4 |
| **total** | | **108** |

Confirms the controller's ruling #1: from `ioFlMdDat`@76 (4 bytes, ends
at 80) to the struct's real end at 108 is **28** trailing bytes, not 32.
`PbCInfo`'s declared shape (below) uses `pad[28]`, and the probe's own
`sizeof`-style arithmetic (28 = 108 − 80) is the sole authority — the
original `pad[32]` in the brief's example would have overrun the struct
by 4 bytes into whatever followed it on the stack/heap.

**`DirInfo`** (`CInfoPBRec`'s directory variant, Files.h:588-611): shares
`HFileInfo`'s layout byte-for-byte through offset 31 (`qLink`..`ioACUser`),
then `ioDrUsrWds` (DInfo, 16 bytes) @32, `ioDrDirID`@48(4) — the SAME
physical bytes as `ioDirID`@48 above — and `ioDrNmFls`@52(2) — the SAME
physical bytes as `ioFlStBlk`@52. This is a real union overlap in Apple's
own struct, not a Clarus modeling choice: `PbCInfo`'s single
`ioDirID`/`ioDrNmFls` naming (borrowing the file-variant's field names)
reads correctly for BOTH a file hit and a directory hit during
enumeration — confirmed empirically in (c) below (folder hits show
`ioFlAttrib & 0x10 != 0` and a directory's own `ioDrNmFls`-as-`ioFlStBlk`
slot reads as its child count).

**`HIOParam`** (Files.h:811-830, 50 bytes total): `ioNamePtr`@18(4),
`ioVRefNum`@22(2), `ioRefNum`@24(2), `ioVersNum`@26(1), `ioPermssn`@27(1),
**`ioMisc`@28(4, a `Ptr`)**, `ioBuffer`@32(4), `ioReqCount`@36(4),
`ioActCount`@40(4), `ioPosMode`@44(2), `ioPosOffset`@46(4).

**Controller ruling #2, CONFIRMED**: `ioMisc` genuinely exists, at offset
28, in `struct HIOParam` (Files.h:811). It is a plain `Ptr` — 4 bytes.
Inside Macintosh - Files (1992), p. 2-198 (`PBHRename`'s own parameter
table, `pdftotext`'d from `inside-macintosh-v2/Inside Macintosh - Files -
1992.pdf`) spells this out explicitly and independently of the headers:

```
→   ioMisc    Ptr      A pointer to the new name for the file.
→   ioDirID   LongInt  A directory ID.
```

**`HFileParam`** (Files.h:832-859, 80 bytes total): identical prefix to
`HFileInfo` through offset 31 (`ioFlVersNum` replaces `ioACUser` at
offset 31, same size), then `ioFlFndrInfo`@32(16, `fdType`@32/
`fdCreator`@36), `ioDirID`@48(4), `ioFlStBlk`@52(2), `ioFlLgLen`@54(4),
`ioFlPyLen`@58(4), `ioFlRStBlk`@62(2), `ioFlRLgLen`@64(4),
`ioFlRPyLen`@68(4), `ioFlCrDat`@72(4), `ioFlMdDat`@76(4) — ends at 80.
Because `HIOParam` and `HFileParam` are both members of the SAME
`HParamBlockRec` union, their byte ranges [24,32) genuinely overlap:
`HIOParam`'s `ioRefNum`(2)+`ioVersNum`(1)+`ioPermssn`(1)+`ioMisc`(4) =
bytes 24-31 is the identical physical span as `HFileParam`'s
`ioFRefNum`(2)+`ioFVersNum`(1)+`filler1`(1)+`ioFDirIndex`(2)+
`ioFlAttrib`(1)+`ioFlVersNum`(1) = bytes 24-31. `ioDirID`@48 is a
genuinely-named field in BOTH `HFileParam` (Files.h:848) and (as
`ioDrDirID`) `DirInfo` — not a coincidental overlay, so a single
`PbCInfo`/`HFileParam`-shaped record can read/write `ioDirID`@48 safely
for `PBHDelete`/`PBDirCreate`/`PBGetCatInfo` all alike.

**Task 2's planned `HIOParamRename`** (`ioMisc`@28, `ioDirID`@48, size
52) is therefore correct as specified — it's a purpose-built 52-byte
record covering only the four fields `PBHRename` actually touches
(`ioNamePtr`@18, `ioVRefNum`@22, `ioMisc`@28, `ioDirID`@48), padded to
52 bytes so `ioDirID`@48(4) fits; it does not need to model the full
union (`HFileParam`'s real 80-byte size) since the trap never reads past
`ioDirID`. The probe's own `PbRename` record (below) is exactly this
shape and was proven against real hardware.

**`CMovePBRec`** (Files.h:1117-1132, 52 bytes total): `ioNamePtr`@18(4),
`ioVRefNum`@22(2), `filler1`@24(4), `ioNewName`@28(4), `filler2`@32(4),
`ioNewDirID`@36(4), `filler3[2]`@40(8), `ioDirID`@48(4). Matches the
spec's table exactly.

**Constants**: `ioDirMask = 0x10` at BOTH Files.h:310 (`ioDirMask = 0x10,`
in the C enum) and Files.a:247 (`ioDirMask EQU $10`); `fsRtDirID = 2` at
both Files.h:88 and Files.a:59. Selectors: `hfsSelDirCreate = 6`,
`hfsSelCatMove = 5`, `hfsSelGetCatInfo = 9` — all reconfirmed live in (c).

## (b) Path-form results

Both spikes (spec §5's own headline probe) succeeded on Mini vMac
(System 6), from the SAME probe run whose full trace is quoted in (c):

- **Nested partial path** (`":ProbeA:B:x.dat"`, no volume name, leading
  colon, two levels deep): `file.create`/`writeAt`/`close`, then
  `file.open` + `size()` on the identical string — round-tripped exactly
  (`size() == 5` after writing `"hello"`). Confirms the existing
  `filehandle` lane's HFS-path handling (already used for single-level
  paths) works unchanged for a MULTI-level nested partial path with no
  code changes needed on the native side.
- **Full path via the volume name**: `PBGetVolSync` (a probe-only trap,
  `toolbox/files.cla` does not need it) returned the boot volume's own
  name, `"SysAndApp"`, and `vol + ":ProbeA:B:x.dat"` (`"SysAndApp:ProbeA:B:x.dat"`)
  opened successfully via `file.open`. Confirms a caller-supplied
  volume-qualified full path needs no special-casing either.

**Not run on System 7 (Snow)** — see Concerns below.

## (c) Enumeration recipe

**Superseded by Fix round 1** (see that section at the end of this
report for what changed and why): the trace and step-by-step narrative
below are from the fix-round-1 boot, which rewrote steps 7-9 so every
path literal after the successful rename is the file's REAL on-disk name
and added two deliberate stale-name calls (8b, 9e) to prove — not just
assert — that a name which no longer resolves genuinely fails. The
original round's steps 8-9 prose (which claimed `x.dat` was still the
live name after a rename the same original trace showed had succeeded)
was self-contradictory; this replaces it outright rather than layering a
correction on top.

Full accumulated trace from the probe's `Probe` case
(`testsuite/toolbox/cases_probe.cla`), captured verbatim from
`CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run
TestToolboxSuiteOn68k -v` (the exact `FAIL Probe:` line the run emitted;
the case always returns `tkFail` deliberately, purely so its full
diagnostic trace lands in the captured log regardless of whether every
step matched its expectation):

```
probe:1:0/25 2a:0 2b:-48 3:5 4:0/SysAndApp/openOK 5:0/16/1/26
6a:hits=1,x=1,end=-43 6b:hits=10,probeA=1,end=-43 7:-37 7b:-120/dir=26
7d:0/dir=26 7c:reopenOK 8:0/reopenOK 8b:-43 9a:0 9b:-47 9c:0 9d:0
9e:-120 10:a=7,s=x
```

Step-by-step, with the exact `ioVRefNum`/`ioDirID`/`ioFDirIndex` values
used and the raw OSErr/values the log shows:

1. `PBDirCreateSync(":ProbeA")`, `ioVRefNum=0, ioDirID=0`, sel 6 → OSErr
   **0**, `ioDirID` read back **25** (the new folder's own DirID).
2. `PBDirCreateSync(":ProbeA:B")` → OSErr **0**. `PBDirCreateSync(":ProbeA")`
   again → OSErr **-48** (`dupFNErr`), exactly as expected.
3. `file.create(":ProbeA:B:x.dat", "TEXT", "CLRS")` → `writeAt(0,
   "hello")` → `close()` → `file.open(":ProbeA:B:x.dat")` → `size()` =
   **5**. Nested-partial-path spike, PASS.
4. `PBGetVolSync`, `ioVRefNum=0` → OSErr **0**, volume name **"SysAndApp"**;
   `file.open("SysAndApp:ProbeA:B:x.dat")` → **openOK**. Full-path spike,
   PASS.
5. `PBGetCatInfoSync(":ProbeA:B")`, `ioFDirIndex=0, ioDirID=0,
   ioACUser=0`, sel 9 → OSErr **0**, `ioFlAttrib` = **16** (`0x10`, the
   directory bit set), `ioDrNmFls` (via `ioFlStBlk`'s overlay) = **1**
   (one child), `ioDirID` read back = **26** (folder B's own DirID).
6. **Enumeration, first loop**: `ioVRefNum=0, ioDirID=26` (folder B's
   real DirID from step 5), `ioFDirIndex = 1, 2, …`, `ioNamePtr` → a
   fresh 256-byte scratch buffer per call (the trap WRITES the Pascal
   name there). **1 hit**: `x.dat`, `ioFlLgLen==5`, `ioFlAttrib & 0x10
   == 0` (not a directory) — exactly the file created in step 3. Loop
   ends at `ioFDirIndex` past the last entry with OSErr **-43** (`fnfErr`).
   **Second loop, same shape but `ioDirID=0`**: **10 hits**
   (this run's own `ProbeA` PLUS the toolbox suite's own on-disk fixture
   files from earlier cases in the same boot — `TestLog.txt`,
   `stamp1`/`stamp2` from `FInfoStamp`, etc.), `ProbeA` genuinely among
   them, ending the same way with OSErr **-43**.
   **Confirms the spec §5/§4.3 open question directly: `ioDirID = 0`
   (with `ioVRefNum = 0`) DOES enumerate the default folder** — the
   exact convention `rtFhDevStat`/`ListBegin`/`ListNext` (spec §4.3)
   plans to rely on.
7. **`PBHRenameSync`, first attempt** (as literally specified by the
   brief): `ioNamePtr = ":ProbeA:B:x.dat"`, `ioVRefNum=0, ioDirID=0`,
   `ioMisc` → a buffer holding `"y.dat"` → OSErr **-37** (`bdNamErr`,
   "Bad filename") — **did NOT match the brief's expectation of 0.** This
   attempt does not touch the disk (it fails outright), so it leaves
   `x.dat` exactly where step 3 created it.
   **7b (diagnostic retry)**: same `ioNamePtr`/`ioMisc`, but
   `ioDirID = 26` (folder B's real DirID from step 5) instead of 0 →
   OSErr **-120** (`dirNFErr`, "Directory not found or incomplete
   pathname") — still fails, differently, and still leaves `x.dat` in
   place.
   **7d (diagnostic retry, SUCCEEDS)**: `ioNamePtr = "x.dat"` (a BARE
   LEAF NAME, no colon) + `ioDirID = 26` (folder B's real DirID) +
   `ioMisc` → `"y.dat"` → OSErr **0**. **This is the one attempt that
   actually renames the file on disk** — from this point on, the file
   that started life as `":ProbeA:B:x.dat"` is physically named
   `":ProbeA:B:y.dat"`, and every later step in this same run addresses
   it by that real name.
   **7c (independent confirmation)**: `file.open(":ProbeA:B:y.dat")` →
   **reopenOK** — proves 7d's rename genuinely stuck, independently of
   7d's own OSErr.
   **Finding for Task 2/3**: unlike `PBDirCreateSync`/`PBGetCatInfoSync`/
   `PBHDeleteSync`/`PBCatMoveSync` (which all accept a nested-partial
   *pathname* in `ioNamePtr` combined with `ioDirID = 0`, confirmed
   working throughout steps 1-6 and 8-9 of this same run),
   **`PBHRenameSync` needs the "dirID + bare leaf name" addressing mode**
   — `ioNamePtr` must be JUST the item's own leaf name (no colons at
   all), and `ioDirID` must be the item's REAL containing-folder DirID
   (never 0). This is a genuine, non-obvious Mac File Manager quirk this
   probe surfaced; it is not documented in the reflowed headers
   themselves (no field-semantics prose there) — only in Inside
   Macintosh - Files (1992) p. 2-198, and even that page doesn't call out
   the addressing-mode restriction explicitly, only the field table
   above. **rtFhDevRename (spec §4.3) MUST resolve the file's own
   parent-folder DirID first (one extra `PBGetCatInfoSync` call, same as
   `rtFhDevStat`) and pass a bare leaf name + that DirID, NOT the
   `dirID=0` + partial-pathname convention every other `rtFhDev*` call
   uses.**
8. `PBCatMoveSync`: `ioNamePtr = ":ProbeA:B:y.dat"` — the file's REAL
   current name after 7d's rename, confirmed independently by 7c, not
   assumed — `ioNewName = ":ProbeA"`, `ioNewDirID=0, ioDirID=0`, sel 5 →
   OSErr **0**. `file.open(":ProbeA:y.dat")` → **reopenOK**. **Confirms
   `PBCatMoveSync` DOES accept the ordinary `ioDirID=0` + nested-partial-
   pathname convention** (unlike `PBHRenameSync`) — spec §4.3's
   `rtFhDevMove` plan (`ioNamePtr` = path, `ioNewName` = `dirPath`,
   `ioNewDirID = 0`) needs no change.
   **8b (fix round 1's own addition, proving finding 1's doubt wrong)**:
   the SAME `PBCatMoveSync`, but deliberately addressed by the STALE name
   `ioNamePtr = ":ProbeA:B:x.dat"` — the name the file had BEFORE 7d's
   rename, which no longer resolves to anything in folder B → OSErr
   **-43** (`fnfErr`). This is the direct, on-hardware proof the review
   asked for: a name that is genuinely gone really does fail with
   `fnfErr`, not silently resolve to the renamed file or something else.
9. Cleanup, all via the ordinary `ioDirID=0` + nested-partial-path
   convention, all against the file's REAL name/location at each point:
   delete `":ProbeA:B"` (now empty — `y.dat` already moved out by step 8)
   → **0** (9a); delete `":ProbeA"` (still has `y.dat`) → **-47**
   (`fBsyErr`, exactly as expected, 9b); delete `":ProbeA:y.dat"` →
   **0** (9c); delete `":ProbeA"` (now empty) → **0** (9d).
   **9e (fix round 1's own addition, proving finding 1's doubt wrong a
   second way)**: `PBHDeleteSync` on the SAME path just deleted in 9c
   (`":ProbeA:y.dat"`, now doubly gone — its own file AND its parent
   folder `":ProbeA"` were both just removed in 9c/9d) → OSErr **-120**
   (`dirNFErr`), not `fnfErr` — different from 8b's `-43` because by this
   point the CONTAINING folder itself is gone too (9d ran before 9e), so
   the File Manager reports "directory not found" rather than "file not
   found" for the same dead path. Still a hard failure, not a silent
   success — the point the review asked this step to prove.

`PBHDeleteSync` (step 9) confirms `ioDirID=0` + nested-partial-path is
fine for Delete, matching `DirCreate`/`GetCatInfo`; only `PBHRenameSync`
is the odd one out. Steps 8b and 9e together close the review's doubt:
every call in this trace that reports OSErr 0 genuinely corresponds to a
real on-disk change, and every stale-name call genuinely fails (`-43`
when the parent folder still exists, `-120` when it doesn't) — none of
them "succeed" on a name that no longer resolves.

## (d) `drive.cla` splice point, byte-identity, record-return, overlay

### Splice point

`combined` (the standalone "user code only" chain, checked as the FIRST
`checkProgram` pass) is assembled at `clarusc/drive.cla:1971-1985`, by
walking `asmHeads` (Phase A's post-order parse results) right after Phase
A's own `entries` loop (`drive.cla:1914-1919`, one `expand(entries[i],
true, "")` call per user-supplied file) and BEFORE the standalone check
itself, which is either `checkProgram(combined)` at `drive.cla:2104`
(the ordinary, non-bake path) or `checkPhase1(combined)` /
`checkPhase2(combined)` at `drive.cla:2097-2100` (the `--rtbake
--testapi` path). `combined2` (the whole-program, runtime-spliced chain)
starts as `combined2 = combined` at `drive.cla:1645`, inside
`driveManifestSplice`, which then prepends the `neededMods`/`rtHeads`
runtime chain and checks the result via `checkProgram(combined2)` at
`drive.cla:1808`.

**Key finding, not called out by the spec**: `driveManifestSplice`
(where `neededMods.add(...)`, `drive.cla:1481` onward, lives) runs AFTER
the standalone `checkProgram(combined)`/`checkPhase1/2(combined)` pass,
not before it. Adding `"prelude.cla"` to `neededMods` alone — the most
obvious-looking fix — only makes `FileInfo` visible in `combined2`, never
in `combined`. Since `fileFuncs`' `file.info` return type is resolved
`psRecNamed(intern("FileInfo"))` *at check time* (spec §4.1), and the
type must already be declared in whatever chain the checker is walking
at that moment, an ordinary (non-`--testapi`, non-`--rtbake`) program
that merely calls `file.info(...)` — e.g. the eventual 68kBBS FTN-toss
program, or any host CLI-style non-UI program — would fail the FIRST
`checkProgram(combined)` pass with an undefined-type diagnostic, because
at that point `combined` is *only* the user's own parsed files; no
runtime module (prelude included) has been spliced into it yet.

Two candidate fixes, in order of how much of the existing pipeline they
touch:

1. **Prepend `prelude.cla` via `expand()` as the very first Phase-A call**
   (before the `entries` loop, `drive.cla:1914`), using the same
   `findRtDir`/`rtModuleKey` machinery `driveManifestSplice` already uses
   (`drive.cla:1649` `rtDir = findRtDir(neededMods[0])` is the existing
   precedent for resolving `runtime/clarus/`). Because `expand()` appends
   its parsed decls to `asmHeads` before the entries loop runs,
   `prelude.cla`'s record decl becomes `asmHeads[0]`, so it's included in
   `combined` (hence visible to the STANDALONE check) and, since
   `combined2 = combined` for the ordinary non-`--testapi` case, it stays
   visible in `combined2` too, with zero double-declaration risk (it's
   simply never re-added to `neededMods`). **Unverified**: whether this
   plays correctly with `driveEarlySplice`'s own `combined`-rebuild logic
   for `--testapi` UI builds (`drive.cla:1230-1400`, which hoists
   `ui*.cla`/`uitest.cla` OUT of `combined` via `hoistedHead` flags) —
   Task 3 needs to trace that interaction concretely (a record decl with
   no early-runtime-module membership should just fall through
   unaffected as ordinary "user" content, but this needs an actual build
   + the golden suite to confirm, not just a read).
2. **The `--rtbake` (`haveRtbake && testapi`) path is separate and
   simpler**: it never re-parses source at all (`driveEarlySplice` is
   explicitly skipped, `drive.cla:2061-2066`'s own comment). Its
   checker-visibility instead comes from `bkInstallCheckerSymbolsForTestapi`
   (a wholesale symbol-table install that runs BEFORE the user's own
   `checkPhase1`, `drive.cla:2096`), fed by `bakeModuleList`
   (`clarusc/bake.cla:400-449`). Adding `"prelude.cla"` to
   `bakeModuleList`, mirroring how it would be added to `neededMods`,
   is therefore both necessary (for the bake path) AND sufficient for
   THAT path specifically — `bkInstallCheckerSymbolsForTestapi` already
   runs early enough.

Given (1) is unverified across every from-source pipeline branch and (2)
only covers the bake path, **the fallback the spec's own Risk section
(§6) names — `declBuiltinType` + a synthesized record via
`recT`/`newFieldInfo` directly in `check.cla`'s universe-init block
(`drive.cla` `checkInitUniverse`-style, see `check.cla:1442-1447`'s
`declBuiltinType(scope, "connection"/"listener"/.../"error", ...)`
block) — is the recommendation for Task 3**, not the source-parsed
`prelude.cla` module. One caveat found while checking the spec's own
"like `error`" analogy: `error` itself is NOT built via `recT`/
`newFieldInfo` — it's a distinct simple builtin kind, `TyErrorType`
(`clarusc/types.cla:419`, `ErrTIndex = pushSimple(TyErrorType)`), pushed
through `declBuiltinType` the same way `connection`/`filehandle` are.
`FileInfo` is a genuine 7-field value record (not a resource-kind opaque
handle like those), so it needs the general `recT`/`newFieldInfo` path
already used for ordinary record declarations (`check.cla:2435-2443`),
run once at universe-init time instead of from a parsed decl — more code
than a one-line `declBuiltinType` call, but it sidesteps the entire
`combined`/`combined2`/`driveEarlySplice`/`bakeModuleList` interaction
surface (guaranteed correct on every lane/mode/path by construction,
since it never touches the AST/chain machinery at all), matching the
spec's own stated fallback rationale exactly.

**Task 1 does not have a from-source `prelude.cla` (Task 2's own
deliverable) to test option 1 against a real build**, so this section is
necessarily analysis from reading `drive.cla`/`bake.cla`, not an
empirical proof either way — flagged as Task 2/3's first order of
business (build the simplest option, run the standalone-check gate
against a plain non-UI `file.info`-calling program, and the golden
suite; fall back to the synthesized-builtin-type approach immediately if
that program fails to check standalone).

### emit68k byte-identity measurement

`testdata/valid/bounce.cla` (the frozen `smoke_bounce` scenario's actual
source — `examples/bounce.cla` does not exist in this tree) was copied
unchanged as a baseline, and a second copy had an unused
`record ProbeInfo { size: int  rsrcSize: int  type: string  creator:
string  created: int  modified: int  isDir: bool }` (spec §4.1/§5's own
shape) added at the top. Both were compiled with the SAME output
basename (`bounce.bin`/`bounce.cla`) in separate directories, to avoid a
spurious diff from the MacBinary header's own embedded filename field —
an early attempt using differently-named source/output files produced 15
bytes of diff that turned out to be entirely the embedded name, not
codegen:

```
clarusc emit68k --rtdir runtime/clarus/ -o bounce.bin bounce.cla   (baseline, no ProbeInfo)
clarusc emit68k --rtdir runtime/clarus/ -o bounce.bin bounce.cla   (probe, +ProbeInfo)
cmp a/bounce.bin b/bounce.bin   →   EXIT 0, byte-identical (107,776 bytes each)
```

**Byte-identical.** The spec §6 golden-drift risk ("if cg68k emits
layout tables for unused records, the plan adds a 'referenced records
only' gate") is **not realized** — an unused record costs nothing in the
native lane's own emitted bytes, at least for this one scalar-only
7-field shape. No cg68k table needs a "referenced records only" gate for
Task 3.

The C (host) lane diff, as the spec predicted, is small and mechanical:

```diff
+typedef struct {
+    int32_t cv_size;
+    int32_t cv_rsrcSize;
+    clar_str_255 cv_type;
+    clar_str_255 cv_creator;
+    int32_t cv_created;
+    int32_t cv_modified;
+    uint8_t cv_isDir;
+    uint8_t clar_pad0;
+} clar_rec_ProbeInfo;
+static clar_rec_ProbeInfo clar_new_ProbeInfo(void) {
+    ...zero-init every field...
+}
```

23 diff lines total: one typedef + one zero-init constructor. **Nuance
on the spec's own wording**: the spec says the diff is "the typedef +
retain/release helpers" — for THIS record shape (`int`/`string(n)`/`bool`
fields only, no `text`/`list`/`map` reference-typed field) `cpEmitRecords`
does NOT emit retain/release helpers at all (confirmed by reading
`cprint.cla`'s own retain/release gating, which is keyed on a record
containing a reference-counted field). `FileInfo`'s actual real shape
(seven scalars, spec §4.1) will get exactly this same "typedef + zero-init
constructor, no retain/release" treatment — one fewer generated function
than the spec's wording implied, immaterial to Task 3's own work either
way.

### Record-return call shape

Host lane, the brief's literal 15-line program (`record R { a: int  b:
bool  s: string }`, `func mk(): R { var r: R  r.a = 7  r.s = "x"  return
r }`, `on App.launch { var r: R  r = mk()  alert(string(r.a)) }`, run via
`scripts/clarus-run.sh`): printed **`7`**, exactly as expected.

**Native lane (Fix round 1, dedicated check)**: the brief's own program
shape was added directly into the probe case itself, `record ProbeR { a:
int  b: bool  s: string }` + `func probeMk(): ProbeR { var r: ProbeR
r.a = 7  r.s = "x"  return r }`, called as `rr = probeMk()` and logged as
`detail = detail + " 10:a=" + tkIntToStr(rr.a) + ",s=" + rr.s`. The
fix-round-1 trace's own step 10 reads **`10:a=7,s=x`** — both fields
round-tripped correctly through a checked `func`-returning-`record` call
on the real native 68k lane, confirming the brief's literal Step 6
directly rather than only by the indirect `tkPass`/`tkFail` argument the
first pass used. (That indirect argument was reasonable and stands too —
`tkPass`/`tkFail` exercise the identical checked call → `KRec` construct
→ return → field-read shape dozens of times in the same boot — but this
dedicated check is the one the brief actually asked for.)

Task 3's `rtFhInfo`'s own difference from either of these is only that
its call site is an *unchecked* `newIRCallFn`-lowered runtime call rather
than a checked user-to-user call — codegen (cg68k) treats a call's
return handling uniformly once lowered to IR regardless of which kind of
call produced it, so this native-lane evidence transfers. **Confirms
spec §4.2's claim ("record-returning runtime calls already exist... so
nothing new") — Task 3 needs no new cg68k/cprint work for `file.info`'s
`KRec` return.**

### Overlay-spelling answer (controller ruling #3)

**Only `var x: CInfoPBRec`-style locals exist. There is no
`CInfoPBRec(ptr(...))`-style overlay/conversion for `extern record`.**
The language reference is explicit and unambiguous on this
(`docs/clarus-language-reference.md:1662`):

> "Unlike `overlay record` (a named VIEW over memory some other pointer
> owns), an `extern record` is a **storage kind** of its own, like `int`
> or `char[N]`: declaring one as a local or global `var` reserves the
> record's packed size in bytes, directly, zero-initialized — there is
> no address to convert from or to, and no `Name(p)` conversion exists
> for it."

`overlay record` (lines 1601-1632) DOES support a `Name(p)` conversion
from an arbitrary `ptr`, but its field types are restricted to `int`,
`bool`, `char`, `fixed`, `ptr` only (line 1619) — `PbCInfo`/`CInfoPBRec`'s
actual field types (`word`, `byte`) are not in that list anyway, so
`overlay record` could not express this struct's shape even if extern
records supported the conversion. Empirically, the working pattern
throughout this probe (and `cases_finfo.cla`'s pre-existing precedent,
`PBGetFInfoSync(fp)` with `var fp: FileParam`) is: declare a local
`extern record`, write the fields the call needs, and pass the local
DIRECTLY where a `ptr` parameter is expected — the language implicitly
takes its address at the call site. **Task 5 must design around a local
`var pb: CInfoPBRec` reused across `rtFhDevStat`/`ListBegin`/`ListNext`
calls (as `fileh_68k.cla`'s existing module-level `var` pattern already
does elsewhere), not an overlay onto a computed address.**

## (e) Amendments to Tasks 2-5

- **Task 2**: `HIOParamRename` (`ioMisc`@28, `ioDirID`@48, size 52) is
  confirmed correct as planned — no change to its shape. `CInfoPBRec`'s
  trailing pad is `pad[28]` (108 total), not `pad[32]` — already the
  controller's ruling #1, re-confirmed here with the full byte-by-byte
  derivation in (a). Add `"prelude.cla"` to `clarusc/bake.cla`'s
  `bakeModuleList` (line ~400-449) alongside adding the file itself —
  needed for the `--rtbake --testapi` path's own checker visibility (see
  (d)); this is IN ADDITION to whatever Task 2/3 decides for the
  from-source splice point, not instead of it.
- **Task 3**: the `prelude.cla`-as-parsed-module plan from spec §4.1 has
  an unverified gap for the standalone check on a plain (non-`--testapi`,
  non-`--rtbake`) program calling `file.info` — see (d)'s full writeup.
  Recommend building the simplest from-source splice (prepend `expand()`
  before the Phase A `entries` loop, `drive.cla:1914`) FIRST and testing
  it against a plain non-UI `file.info`-calling program's standalone
  check; if that fails (or interacts badly with `driveEarlySplice`'s own
  `combined`-rebuild for `--testapi` builds), fall back immediately to
  the spec's own `declBuiltinType` + synthesized-record approach
  (`check.cla`'s universe init, `recT`/`newFieldInfo`, NOT `error`'s
  `pushSimple(TyErrorType)` — `FileInfo` is a real 7-field record, a
  structurally different builtin-type shape than `error`). Either way,
  **`rtFhDevRename`'s design in spec §4.3 needs a correction**: it
  currently reads `PBHRenameSync, ioMisc → new name Str255` with no
  mention of `ioDirID`'s addressing mode. Per (c) step 7's hardware
  finding, `rtFhDevRename` MUST resolve the renamed file's own parent
  DirID first (one extra `PBGetCatInfoSync` call — the exact same call
  `rtFhDevStat` already makes) and pass `ioNamePtr` as a BARE LEAF NAME
  (never a colon-path) + that real `ioDirID` (never 0) — the
  `ioDirID=0`+partial-path convention every other `rtFhDev*` call uses
  fails `PBHRenameSync` specifically with `bdNamErr`/`dirNFErr`. No
  extra call is needed for `rtFhDevMove` (`PBCatMoveSync` DOES accept
  `ioDirID=0` + nested-partial-pathname, confirmed in (c) step 8) or for
  `rtFhDevDelete` (`PBHDeleteSync` likewise, confirmed in (c) step 9).
  Fix round 1 re-ran this whole sequence with corrected path literals
  (every step after the rename addresses the file's real post-rename
  name, `y.dat`) plus two deliberate stale-name calls (8b: `PBCatMoveSync`
  on the pre-rename name, `-43`/`fnfErr`; 9e: `PBHDeleteSync` on an
  already-deleted path, `-120`/`dirNFErr` since its parent folder is also
  gone by that point) — both hard-fail as expected, closing the doubt
  that a wrong literal could have coincidentally "succeeded" in the first
  pass. The rename finding itself is unchanged, now with stronger
  evidence behind it. The emit68k byte-identity risk from spec §6 is
  closed: no "referenced records only" cg68k gate is needed.
- **Task 4**: no findings that touch the host lane directly; `file.info`'s
  `FileInfo` record on the C lane gets a typedef + zero-init constructor
  only (no retain/release, since it has no reference-typed field) — one
  less generated function than spec §4.7's wording implied, immaterial.
- **Task 5**: use the `var x: CInfoPBRec` LOCAL form (module-level `var`,
  reused across calls, exactly `fileh_68k.cla`'s existing pattern for
  other PB records) for `rtFhDevStat`/`ListBegin`/`ListNext` — there is
  no overlay/`Name(p)`-conversion form for `extern record`, confirmed
  against the language reference directly (see (d)). The enumeration
  recipe itself (c) step 6 is proven: `ioVRefNum=0`, `ioDirID` = the
  target folder's own DirID from a prior `PBGetCatInfoSync`-by-name call,
  `ioFDirIndex` 1-based incrementing, `fnfErr` (-43) ends the listing;
  `ioDirID=0` genuinely enumerates the DEFAULT folder (spec §4.3's own
  open question, now closed) — no design change needed there.

## Concerns (why this is DONE_WITH_CONCERNS, not DONE)

- **Snow (System 7) was not run.** `pgrep -f Snow` (per project memory,
  run before any Snow interaction) found Snow ALREADY RUNNING —
  `Snow --serial-bridge-a tcp:1234 /Users/andrew/repos/68kbbs/snow/MacII.snoww`
  (PID 52636) — a live, unrelated 68kbbs session already using port 1234.
  Project memory and this task's own instructions are explicit: never
  start a second Snow instance, and use a `--serial-bridge-a` port
  distinct from the one already in use. Booting a fresh Snow instance
  for this probe (even on a different port) risks disrupting that
  in-progress session (Snow has no headless mode and steals the screen
  for screenshot-driven interaction) and there was no clear signal it was
  idle/safe to interrupt. Per this task's own explicit instruction ("If
  after a genuine attempt Snow cannot be driven in this session, report
  the vMac results as DONE_WITH_CONCERNS naming exactly what was not
  run — do not fabricate System 7 results"), Step 4 is skipped entirely:
  **no System 7 claim anywhere in this report is backed by data; every
  claim above is Mini vMac (System 6) only.** Spec §5's own expectation
  ("System 7 differences: none") is UNVERIFIED, not confirmed.
- **The `drive.cla` splice-point analysis in (d) is read-only, not
  empirically built.** `prelude.cla` doesn't exist yet (it's Task 2's own
  deliverable), so the two candidate splice mechanisms could not actually
  be built and run against the standalone-check gate. This is flagged as
  Task 3's first concrete task, with a specific test program ("a plain
  non-UI program calling `file.info`") named as the discriminating case.
- **`PBHRenameSync`'s hardware behavior did not match spec §4.3's
  original one-line plan.** Steps 7/7b/7d in (c) needed three real
  attempts (two probe-added, beyond the brief's literal script) before
  finding a combination that actually succeeds. This is exactly the kind
  of finding Task 1 exists to catch before Task 3 writes `rtFhDevRename`
  against an unverified assumption — see the Task 3 amendment in (e) for
  the concrete fix.

## Fix round 1

Review returned two Important findings against the original report; both
addressed with ONE more Mini vMac boot of the (re-added, then reverted)
throwaway `Probe` case.

### What changed in the probe

`testsuite/toolbox/cases_probe.cla` (re-created identically to the
original probe for steps 1-6, then):

- **Steps 7-9 rewritten** so no path literal is asserted independent of
  what the probe itself just proved on disk. Step 7d (bare leaf name +
  real parent DirID) is still the one rename attempt that succeeds; step
  7c's `file.open(":ProbeA:B:y.dat")` independently confirms it stuck.
  Step 8's `PBCatMoveSync` now literally uses `":ProbeA:B:y.dat"` — the
  file's real current name — instead of the stale `x.dat` the original
  report's prose (wrongly) kept using. Step 9's cleanup literally deletes
  `":ProbeA:y.dat"` (the file's real post-move name), not `x.dat`.
- **Two new steps added**, both deliberately addressing a name that no
  longer resolves, to prove (not just assert) that a stale reference
  fails rather than silently "succeeding" against the wrong file:
  - **8b**: `PBCatMoveSync` with `ioNamePtr = ":ProbeA:B:x.dat"` — the
    file's PRE-rename name, dead since step 7d — expect `fnfErr` (-43).
  - **9e**: `PBHDeleteSync` on `movedPath` (`":ProbeA:y.dat"`) a second
    time, immediately after 9c/9d already deleted the file and then its
    now-empty parent folder — expect a hard failure (not necessarily
    `-43`; see the actual result below).
- **A local record-return check added**: `record ProbeR { a: int  b:
  bool  s: string }`, `func probeMk(): ProbeR { var r: ProbeR  r.a = 7
  r.s = "x"  return r }`, called as `rr = probeMk()`, logged as step 10
  (`a=`/`s=` in the trace). This is the brief's literal Step 6 program,
  run directly on the native lane inside the same boot, closing the gap
  the review flagged (the first pass only argued this indirectly via
  `tkPass`/`tkFail`'s own pervasive record-returning calls elsewhere in
  the suite).

Wiring (registering `Probe` in `testsuite/toolbox/runner.cla` and
`internal/mactest/coresuite_test.go`'s `toolboxFiles`/33-count) was
identical to the original pass and was reverted the same way afterward;
`git status` is clean except `.superpowers/sdd/`.

### Exact command run

```
CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run TestToolboxSuiteOn68k -v
```

(preceded by a `clarusc emit68k --testapi --rtdir runtime/clarus/ -o ... `
dry-run compile of the same file list, to catch syntax/type errors before
spending the ~1-minute emulator boot — came back clean on the first try
this round).

### Raw trace from the new boot

```
FAIL Probe: probe:1:0/25 2a:0 2b:-48 3:5 4:0/SysAndApp/openOK 5:0/16/1/26
6a:hits=1,x=1,end=-43 6b:hits=10,probeA=1,end=-43 7:-37 7b:-120/dir=26
7d:0/dir=26 7c:reopenOK 8:0/reopenOK 8b:-43 9a:0 9b:-47 9c:0 9d:0
9e:-120 10:a=7,s=x
```

### Resolution of finding 1 (file-identity narrative)

Steps 1-7d/7c are numerically identical to the original boot (same
OSErr/values throughout) — the underlying hardware behavior did not
change, only the probe's own bookkeeping and the report's prose did. The
new trace is now self-consistent end to end:

- Step 8 (`0/reopenOK`) is `PBCatMoveSync` on `":ProbeA:B:y.dat"` (the
  REAL name after 7d), landing at `":ProbeA:y.dat"`.
- Step 8b (`-43`) is the SAME call on the STALE `":ProbeA:B:x.dat"` —
  fails with `fnfErr`, proving that name is genuinely dead, not silently
  resolving to the renamed file (or anything else).
- Steps 9a-9d (`0`, `-47`, `0`, `0`) are cleanup against the real
  `":ProbeA:y.dat"` path throughout — no `x.dat` reference anywhere.
- Step 9e (`-120`, `dirNFErr`) is a second `PBHDeleteSync` on the just-
  deleted `":ProbeA:y.dat"` — a hard failure as expected, though
  `dirNFErr` rather than the `fnfErr` the probe's own comment predicted,
  because by 9e's point BOTH the file (9c) AND its parent folder `":ProbeA"`
  (9d) are gone, so the File Manager reports "directory not found" rather
  than "file not found" for the same dead path — still conclusively a
  failure, not a success, which is what the review needed proven.

**Root cause of the original contradiction**: it was a report-writing
error, not a probe-code bug. The original probe's own `if renamedOk {
leaf = "y.dat" } else { leaf = "x.dat" }` logic (removed in this
rewrite in favor of literal names, now that the addressing mode is
confirmed reliable) had already correctly computed `renamedOk = true`
and `leaf = "y.dat"` by the time step 8 ran in the original boot too —
the ORIGINAL trace's own `8:0/reopenOK` was therefore already the result
of moving `y.dat`, not `x.dat`. The original report's prose ("the rename
never stuck... so x.dat — not y.dat — is what actually moved") was
narrating an EARLIER, pre-`7d` boot's behavior that had been overwritten
in my own memory/notes when I wrote that paragraph, not what the actual
final trace showed. This fix-round's rewrite removes the ambiguity at
the source (no more conditional-on-`renamedOk` literal, since three
boots now agree 7d reliably succeeds) and backs every claim with the two
new stale-name steps besides.

**No change to the underlying finding**: `PBHRenameSync` still needs
bare-leaf-name + real-parent-DirID addressing (`ioDirID=0` +
nested-partial-path fails, `-37` then `-120`); `PBCatMoveSync` and
`PBHDeleteSync` still both accept the ordinary `ioDirID=0` +
nested-partial-path convention (step 8 and steps 9a-9d, both against
real, live paths this time). (c) and (e)'s Task 3 amendment are updated
in place above to reflect the corrected narrative and the new stale-name
evidence; no amendment content changed in substance, only its accuracy
and evidentiary support.

### Resolution of finding 2 (native-lane record-return)

Step 10 of the new trace, `10:a=7,s=x`, is the brief's literal Step 6
record-return program (`ProbeR`/`probeMk`, above) run directly on the
real native 68k lane — both fields (`a: int`, `s: string`) round-tripped
correctly through a checked `func`-returning-`record` call, construct →
return → field-read, exactly the shape `file.info`'s own lowered runtime
call will need. (d)'s "Record-return call shape" section is updated in
place to lead with this direct result; the original indirect
`tkPass`/`tkFail` argument is kept as corroborating (not primary)
evidence. The host-lane result from the first pass (`7`, via
`scripts/clarus-run.sh`) stands unchanged.

Tree is clean (`git status` shows only `.superpowers/sdd/` staged) —
`testsuite/toolbox/cases_probe.cla` deleted again, `runner.cla` and
`internal/mactest/coresuite_test.go` reverted to their committed state.
