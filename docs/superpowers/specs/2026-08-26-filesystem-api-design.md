# Filesystem API — `file.makeDir`/`delete`/`list`/`exists`/`info`/`setInfo`/`rename`/`move` — design

Date: 2026-08-26. Status: approved (Andrew, 2026-08-26), awaiting plan.

Companion to the binary-files spec (`2026-08-22-binary-files-design.md`),
whose `filehandle` plumbing (`fileFuncs` → `lowFileCall` → `rtFh*` →
lane-split `rtFhDev*`) is the template every call below follows.
Requested by 68kBBS (`../68kbbs/docs/language-gaps.md` §1–3, §5–7 and
`docs/fidonet.md`'s FTN toss flow).

## 1. Problem

The `file` namespace can open, create, read, and write a file whose path
it is already given, and nothing else. A program cannot make a folder,
remove a file, find out what is in a folder, ask a file's size or dates
without opening it, change an existing file's Finder type/creator, or
rename/move anything. 68kBBS's consequences today (all from its own
docs and `ponytail:` comments):

- FidoNet toss cannot run: it needs to enumerate `:FTN:In:`, open each
  `*.pkt` by nested partial path, and delete tossed packets; outbound
  packets need deleting once acknowledged; the `:FTN:`/`:FTN:In:`/
  `:FTN:Out:` folders must be made by the sysop in the Finder.
- Deleting a file entry or a whole area leaves the physical file, its
  `ARE<nn>` database files, and its folder orphaned on disk.
- Aborted uploads leave partial files behind forever.
- "Point an area at a folder of files" (import by browsing, CD-ROM
  areas) is impossible; every file is registered by hand.

Two small adjacent gaps travel with this: the host lane passes an HFS
colon path (`:FTN:In:x.pkt`) verbatim to `open(2)`, so nested folders
cannot be exercised on the host at all; and the public
`toolbox/osutils.cla` `SecondsToDate`/`DateToSeconds`/`ReadDateTime`
externs have no host C twins (only the runtime's private `DtSecs2Date`/
`DtReadDateTime` do), so a host build of a program that calls the
catalog pair fails to link.

## 2. Decisions (Andrew, 2026-08-26)

1. **Scope: core + cheap extras.** `makeDir`, `delete`, `list` (the
   FTN blockers) plus `exists`, `info`, `setInfo`, `rename`, `move` —
   each extra is one more trap/POSIX call on the plumbing the core
   already builds. Resource-fork-as-bytes (language-gaps §4) is
   deferred to a MacBinary phase.
2. **Listing is names only; metadata is a separate per-path query.**
   `file.list` fills a `list of string` with leaf names. Structured
   metadata comes from `file.info`, which RETURNS a `FileInfo` record.
   The originally-proposed fill-in-place `file.info(path, info): bool`
   shape was dropped during design: records are value types, and a
   user-callable runtime function cannot fill a record parameter
   (reference Ch7 "Parameters are immutable bindings"); only a compiler
   intrinsic carrying a layout descriptor (`file.load`'s shape) or a
   second `Err`-style hardwired kind could, and `KErr` is special-cased
   in 46 places in cg68k alone. Returning the record costs nothing new.
   Existence is its own call (`file.exists`) rather than a sentinel
   field, so `info`'s failure contract is the ordinary `lastError` one.
3. **`FileInfo` is an ordinary `record` declared in a runtime prelude**
   module spliced into every check and build — not a compiler builtin.
   See §4.1.
4. **Rename and move are two calls, one trap each.** `file.rename(path,
   newName)` (`PBHRename`) and `file.move(path, dirPath)` (`PBCatMove`).
   No path splitting in the runtime.
5. **Host lane gets HFS→POSIX path translation** applied to every
   path-taking host entry point, existing ones included (§4.4). This
   is a deliberate widening: without it the host suite cannot cover
   nested folders and the FTN flow cannot be developed on the host.
6. **Host date glue for the public catalog names** ships in this phase
   (§4.5) — it is the second half of the 68kBBS-listed spike and is
   pure computation.

## 3. Language surface (reference `### Files` additions)

All new calls live in the `file` namespace and follow the existing rule:
a `bool` result's `false` means inspect `lastError`. `lastError.code` is
the lane's own OS error (`OSErr` on the Macintosh, `errno` on a host);
`lastError.message` is one fixed string per call (`"makeDir failed"`,
`"delete failed"`, `"list failed"`, `"info failed"`, `"setInfo failed"`,
`"rename failed"`, `"move failed"`). Every call is synchronous; none
fires an event. No Gestalt gating: everything below is System 6-era
HFS (`_HFSDispatch` and the `PBH*` family are HFS, present on every
System 6 Mac this project targets).

| Function | Signature | Notes |
|---|---|---|
| `makeDir` | `file.makeDir(path: string): bool` | creates one folder; the parent must already exist; an existing folder or file at `path` is a failure (`dupFNErr` / `EEXIST`) |
| `delete` | `file.delete(path: string): bool` | removes a file or an *empty* folder; a non-empty folder is a failure; on the Macintosh an open file is too (`fBsyErr`), while a POSIX host unlinks it |
| `list` | `file.list(path: string, names: list of string): bool` | empties `names`, then appends the leaf name of every file **and** folder directly inside `path`, in catalog order; `""` names the program's own folder; a `path` that is not a folder is a failure |
| `exists` | `file.exists(path: string): bool` | `true` for an existing file or folder; never sets `lastError` |
| `info` | `file.info(path: string): FileInfo` | on failure returns a zeroed record and sets `lastError` |
| `setInfo` | `file.setInfo(path: string, type: string, creator: string, created: int, modified: int): bool` | restamps an existing file's Finder type/creator and dates; a `0` date means "leave unchanged"; `type`/`creator` follow `writeText`'s four-character rule |
| `rename` | `file.rename(path: string, newName: string): bool` | renames in place; `newName` is a leaf name, not a path |
| `move` | `file.move(path: string, dirPath: string): bool` | moves a file or folder into the folder `dirPath`, keeping its name; same volume only (`badMovErr` otherwise) |

`FileInfo` is a predeclared record type (Chapter 3), usable like any
user record — assignable, copyable, a legal field/element type:

```
record FileInfo {
    size: int        // data fork length in bytes; 0 for a folder
    rsrcSize: int    // resource fork length in bytes; 0 for a folder or on a host
    type: string     // Finder type, "" on a host or for a folder
    creator: string  // Finder creator, "" on a host or for a folder
    created: int     // Macintosh-epoch seconds, the same clock as now()
    modified: int
    isDir: bool
}
```

A program may not declare its own `FileInfo` (ordinary duplicate-type
diagnostic).

**Paths.** Every `path` is an HFS path exactly as `file.open` takes one
today: a bare name (the program's own folder), a partial path with a
leading colon (`:FTN:In:x.pkt`), or a full path (`BBS HD:Files:x`). On a
host build the same spellings work (§4.4) — `:` separates components,
a leading `:` is dropped, and a full path's volume name becomes an
ordinary leading directory component. `file.list` returns leaf names;
a caller re-joins them (`path + ":" + name`, or the bare name when
`path` is `""`).

**Host behaviour.** `setInfo`'s `type`/`creator` are accepted and
ignored; `info` returns `rsrcSize = 0`, empty `type`/`creator`,
`created` from the file's birth time where the host reports one (else
its change time). Everything else behaves identically on both lanes.

## 4. Implementation architecture

### 4.1 `FileInfo`: prelude module

New `runtime/clarus/prelude.cla` holds `record FileInfo { ... }` and
nothing else. `clarusc/drive.cla` splices it as the FIRST source of
BOTH the standalone user-code check and the full (runtime-spliced)
build, unconditionally, on both lanes and in check-only mode. Because it
is an ordinary `record` decl, it flows through `checkRecordDecl` →
`lowRecordDecl` → `cpEmitRecords` / `cgFieldOffset` untouched; cprint
and cg68k need no changes, and the record's C/68k layouts are whatever
they would be for a user record of that shape (no hand-maintained
offsets anywhere, so the layout-sensitive bug class documented in
ROADMAP cannot apply).

Consequences to carry:

- `--bake` (scripts/build-clarusc-mac.sh, one flag per runtime file)
  and the `'CLFS'` runtime-module read path pick up the new file.
- The "clean standalone" gate's purpose (user code cannot name runtime
  functions) is preserved: the prelude declares a type, no functions.
  The reference documents `FileInfo` as predeclared, like `error`.
- `fileFuncs`' signature for `file.info` cannot hold a type index at
  init time (the sig table is built before any source is checked); it
  uses a new param/return spec resolved by NAME at check time —
  `psRecNamed(intern("FileInfo"))` — same family as `psAnyRecordish`.
- Task 1 probes the exact splice point (`drive.cla`'s standalone check
  file list vs. `neededMods`) and whether the snapshot fixed point and
  `--bake-ir` need anything beyond a regen.

### 4.2 Compiler (`check.cla`, `lower.cla`) — mechanical

- `check.cla`: eight `fileFuncs` entries (`psPlain(strT(255))` paths;
  `psPlain(listT(strT(255)))` for `names`; `psPlain(IntT)` dates;
  `BoolT` returns, `psRecNamed(FileInfo)` return for `info`). `list`'s
  `names` arg gets `checkRejectParamFill` like `readText`'s `out` (it
  only bites on widget-property targets and value-kind params; a list
  parameter is a reference and passes). Any of the eight sets `usesFileh = true`
  (it already gates the host-lane splice of `fileh.cla`/`fileh_c.cla`).
- `lower.cla`: eight `lowFileCall` arms, each `newIRCallFn(intern(
  "rtFh<Name>"), ...)` exactly like `open`/`create`. `setInfo`'s
  `type`/`creator` get `lowCheckLiteral4CCArg`. `info`'s call has a
  record result type; record-returning runtime calls already exist
  (cg68k `cgRetIsRef` KRec arm), so nothing new.

### 4.3 Runtime (`fileh.cla` + lane files)

`fileh.cla` (shared) gains `rtFhMakeDir`, `rtFhDelete`, `rtFhList`,
`rtFhExists`, `rtFhInfo`, `rtFhSetInfo`, `rtFhRename`, `rtFhMove` —
every one of them the same three lines as `rtFhOpen`: call the
`rtFhDev*` twin, on failure `rtSetLastErr(rtFhDevLastOSErr(), "<op>
failed")`. Two carry logic:

- `rtFhList(path, names)`: `names.clear()`, then a loop —
  `rtFhDevListBegin(path): bool` (resolves the folder; false + OS error
  if not a folder), then `rtFhDevListNext(): string` until it returns
  `""` (done — HFS names are never empty), then `rtFhDevListEnd()`.
  The device layer hands back one leaf name at a time, so the
  list-building loop exists once, here. One listing at a time (a
  module-level cursor); nested `file.list` calls are not supported and
  not needed.
- `rtFhInfo(path)`: declares a local `FileInfo`, has the device layer
  fill the seven scalars through seven `rtFhDev*` getters after a
  single `rtFhDevStat(path): bool` (which caches the last catalog
  record in module state), assigns the fields, returns the record.
  The device layer never sees the record type — it returns ints/
  strings/bools — so `fileh_c.cla`/`fileh_68k.cla` stay layout-blind.

`fileh_68k.cla` (native): the new externs come from `toolbox/files.cla`
(§4.6). Path → `Str255` via the existing `rtFh68kName`. `ioVRefNum`
stays 0 (default volume) everywhere, as today.

- `rtFhDevMakeDir`: `HParamBlock` file variant, `ioDirID = 0`,
  `PBDirCreateSync` (`reg(a0: pb, d0: 6)`).
- `rtFhDevDelete`: `PBHDeleteSync`, `ioDirID = 0`.
- `rtFhDevStat`/`ListBegin`: `CInfoPBRec`, `ioFDirIndex = 0`,
  `ioDirID = 0`, `PBGetCatInfoSync` (`d0: 9`) by name; `isDir` =
  `ioFlAttrib & 0x10`; folder's `ioDrDirID` retained for enumeration.
  `ioACUser` is cleared before the call (Files.a:277's own warning).
- `ListNext`: same PB with `ioVRefNum = 0`, `ioDirID = <folder's
  DirID>`, `ioFDirIndex = n` (1-based, incremented per call),
  `ioNamePtr` → a 256-byte scratch buffer the returned name is read
  from; `fnfErr` ends the listing.
- `rtFhDevSetInfo`: `PBHGetFInfoSync` → patch `fdType`/`fdCreator`,
  and `ioFlCrDat`/`ioFlMdDat` when non-zero → `PBHSetFInfoSync`
  (get-modify-set, unlike `rtFhDevCreate`'s deliberate no-Get stamp,
  because here the file's other Finder flags must survive).
- `rtFhDevRename`: `PBHRenameSync`, `ioMisc` → new name `Str255`.
- `rtFhDevMove`: `CMovePBRec`, `ioNamePtr` = path, `ioNewName` =
  `dirPath` `Str255`, `ioNewDirID = 0`, `PBCatMoveSync` (`d0: 5`).
- `rtFhDevExists`: `rtFhDevStat` with the error discarded.

`fileh_c.cla` (host): one thin wrapper per `rtFhDev*` over new
`external func FhH*` declarations, C bodies in `runtime/host/
rt_fileh.inc`: `mkdir(p, 0777)`, `remove`, `opendir`/`readdir`/
`closedir` (skipping `.`/`..`; one static `DIR*` cursor), `stat`
(`st_size`, `S_ISDIR`, `st_birthtime` where available else `st_ctime`,
`st_mtime`, each converted with `RT_MAC_EPOCH_DELTA`), `utimes`,
`rename` (rename: `dirname(path) + "/" + newName`; move: `dirPath +
"/" + basename(path)`). `FhHListNext` copies a name into a
caller-supplied 256-byte buffer as a Pascal string, mirroring the
native lane, so `fileh_c.cla`'s `rtFhDevListNext` builds the `string`
the same way. Errors stash `errno` in the existing `rt_fh_errno`.

### 4.4 Host HFS path translation

One helper in `rt_fileh.inc`, `rt_fh_posix_path(const uint8_t *hfs,
char out[1024])`: a leading `:` is dropped; every other `:` becomes
`/`; a path with no colon is unchanged. Applied in every path-taking
`rt_ext_FhH*` (the existing `FhHOpen`/`FhHCreate` included) AND in
`rt.c`'s `rt_file_read_text`/`rt_file_write_text`/`rt_file_save`/
`rt_file_load`/`rt_file_name` so the two families agree — root cause,
every caller. Consequence: an HFS full path `Vol:a:b` becomes the
relative POSIX path `Vol/a/b`; documented, not special-cased. The
`rt_fileh_test.c` harness pins the translation table.

### 4.5 Host date glue

`runtime/host/rt_ext_host.inc` gains `rt_ext_ReadDateTime`,
`rt_ext_SecondsToDate`, `rt_ext_DateToSeconds` — the host twins of the
public `toolbox/osutils.cla` externs, with the same `rt_ext_<name>`
signatures cprint already emits for them. `ReadDateTime` and
`SecondsToDate` delegate to the existing `rt_ext_DtReadDateTime`/
`rt_ext_DtSecs2Date` bodies; `DateToSeconds` is the inverse
(days-from-civil, Hinnant's algorithm, matching `DtSecs2Date`'s own
civil-from-days). A core-suite case round-trips a fixed vector both
ways on both lanes so the ROM and C answers are pinned against each
other.

### 4.6 `toolbox/files.cla` additions

Same citation discipline as every entry already there (reflowed
`Files.h` line + `Files.a` corroboration, bit-11 test, layout offsets).
Verified during design against Universal Interfaces 3.4:

| Extern | Inline | Convention |
|---|---|---|
| `PBGetCatInfoSync` | `moveq #9,D0; dc.w $A260` (Files.h:2879-2881, Files.a:3368) | `trap 0xA260 reg(a0: pb, d0: sel) ret d0` — selector passed by the caller |
| `PBSetCatInfoSync` | `#10, $A260` (Files.h:2907-2909) | same; declared for manager completeness, unused |
| `PBDirCreateSync` | `#6, $A260` (Files.h:2792-2794, Files.a:3210) | same |
| `PBCatMoveSync` | `#5, $A260` (Files.h:2764-2766, Files.a:3158) | same |
| `PBHDeleteSync` | `$A209` (Files.h:3187-3189) | `reg` |
| `PBHRenameSync` | `$A20B` (Files.h:3215-3217) | `reg` |
| `PBHGetFInfoSync` | `$A20C` (Files.h:3299-3301) | `reg` |
| `PBHSetFInfoSync` | `$A20D` (Files.h:3327-3329) | `reg` |
| `PBHOpenRFSync` | `$A20A` (Files.h:3103-3105) | `reg`; declared for completeness (the deferred resource-fork phase) |

Since the three `_HFSDispatch` routines share one trap word and differ
only in D0, the catalog declares ONE extern per routine name with a
`sel: int` parameter bound to `d0` (the caller passes the literal —
`PBGetCatInfoSync(pb, 9)`), plus `const` selectors
(`hfsSelGetCatInfo = 9`, etc.). The bit-11 test holds (`0xA260 & 0x0800
== 0`, register convention); the cookbook gains a short "`_HFSDispatch`
selector in D0" walkthrough alongside the existing `seld0` one,
explaining why this is plain `reg` and not `seld0` (a Pascal-convention
shape).

Extern records added: `HFileParam` (the `HParamBlockRec` file variant,
Files.h:832-859 — `ioDirID` at offset 48), `CInfoPBRec` as its
`HFileInfo` variant (Files.h:557-587, with the `DirInfo` overlap
`ioDrDirID`@48/`ioDrNmFls`@52 noted; 108 bytes), `CMovePBRec`
(Files.h:1117-1134). Only fields the runtime reads or writes are named;
the rest is `pad`, per the file's own rule. Constants: `ioDirMask =
0x10` (Files.a:247), `fsRtDirID = 2`, the three selectors.

`internal/testsuite/catalog_test.go`'s driver references at least one
new symbol so the additions are bound, not just parsed.

### 4.7 Planned consequences

- `clarusc/clarusc.c` snapshot regen (new runtime module + compiler
  changes); `TestSnapshotFixedPoint` is the gate.
- emitui/frozen-scenario goldens: byte-identical for programs that use
  none of the new calls is the expectation — the prelude adds a record
  type, and an unused record type must not change emitted output on
  either lane. If it does, that is a finding to fix, not a golden to
  re-bless.
- `docs/clarus-language-reference.md` `### Files` table, a `FileInfo`
  paragraph under Chapter 3's predeclared types, the paths paragraph;
  `docs/clarus-toolbox-cookbook.md` `_HFSDispatch` note; TODO/ROADMAP/
  HISTORY/STATUS/CLAUDE.md close-out; `../68kbbs/docs/language-gaps.md`
  §1–3, §5–7 marked shipped with the as-shipped shapes (a separate
  68kbbs commit, like §8 was).

## 5. Testing

- **Task 1 probe wave (before any implementation):** on Mini vMac
  (System 6) and Snow (System 7) — `file.open` on `:FTN:In:x.pkt` after
  creating the folders by Finder, and on a full path `Vol:dir:x`;
  `PBGetCatInfo` index enumeration with `ioVRefNum = 0` + a DirID
  obtained by name (confirms the resolve-then-index plan and that
  `""`/`ioDirID = 0` means the default folder); the drive.cla splice
  point for the prelude and its effect on the standalone check.
  Findings go in the plan's task-1 report, as the binary-files phase
  did.
- **Core suite** (`testsuite/core/cases_dirops.cla`, `DirOps`, host +
  native): makeDir `:DirOpsT:` → makeDir again fails (`dupFNErr`/
  `EEXIST`) → create two files inside via `file.create` with a nested
  partial path → `list` returns exactly those two names → `exists`
  true/false → `info` sizes/`isDir`/dates ≥ a `now()` taken before →
  `setInfo` type + modified, re-`info` reflects it (dates both lanes;
  type native only) → makeDir `:DirOpsT:Sub:` → `move` one file into
  `Sub`, `list` both levels → `rename` → `delete` files, `delete`
  non-empty folder fails, `delete` `Sub` then `:DirOpsT:` → `exists`
  false → `list` on a missing path fails. Also a second `DateRoundTrip`
  case for §4.5 (`SecondsToDate`/`DateToSeconds` on a fixed vector and
  on `now()`), unless the existing `DateTimeRoundTrip` toolbox case
  already pins the catalog names — the plan decides after reading it.
- **Host C harness** (`runtime/host/rt_fileh_test.c`): path-translation
  table; mkdir/list/stat/rename/move/remove round trip in a temp dir;
  `FhHListNext` termination.
- **Catalog**: `catalog_test.go` driver binds the new externs; both
  emit lanes compose (`TestCatalogComposesWithUIRuntime`).
- **Gates**: T1 `--smoke` per task; T2 before merge; the mac-resident
  compiler bake (`TestClarusCBakePathOnSnow`, ~55 min, manual) once
  because a runtime module was added.

## 6. Risks

- **Prelude splice vs. the standalone gate.** If the standalone check
  is implemented as "user files only, then assert no runtime symbol
  resolved", a prelude type may need an explicit allow-list entry.
  Task 1 finds out; fallback is `declBuiltinType` + a synthesized
  record via `recT`/`newFieldInfo` in `check.cla`'s universe init, with
  `lowRecordDecl` fed a synthetic decl — more code, same layout safety.
- **Golden drift from the prelude.** An unused record must be
  output-neutral; `cpEmitRecords` emits every `irRecords` entry
  (a typedef + retain/release helpers), so host C output WILL change
  for every program. That is acceptable for the C printer (it is not a
  golden lane) but `emit68k` output must not grow for programs that
  never touch `FileInfo` — if cg68k emits layout tables for unused
  records, the plan adds a "referenced records only" gate there.
- **`ioVRefNum = 0` + `ioDirID` enumeration** under a WDRefNum default
  directory (System 6 apps launched by the Finder get a working
  directory refnum as the default volume). Expected fine; the probe
  confirms.
- **Host `st_birthtime`** is macOS/BSD-only; Linux falls back to
  `st_ctime` (documented as "where the host reports one").
- **Memory ceiling of `list of string`:** 256 bytes per entry; a
  500-file CD-ROM folder is 128 KB. Acceptable for this phase's
  consumers (FTN folders, file areas of tens of files); recorded in
  TODO with the upgrade path (`list of string(31)` element capacity).

## 7. Out of scope (this phase)

- Resource-fork-as-bytes / `file.openRF` (MacBinary phase; `PBHOpenRFSync`
  is declared now so that phase adds no catalog work).
- Recursive `makeDir`, recursive delete, cross-volume move, a combined
  rename+move, wildcard listing, `list` with metadata.
- Volume enumeration, `SetVol`/default-directory changes, working
  directories.
- Locking (`PBHSetFLock`), Finder flags beyond type/creator/dates.
