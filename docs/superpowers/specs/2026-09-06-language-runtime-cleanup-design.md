# language-runtime-cleanup — design

Date: 2026-09-06. Branch: `language-runtime-cleanup`, off `main`.
Status: design approved in discussion (Andrew, 2026-09-06); spec for
review before planning.

Clears `docs/TODO.md`'s four non-parked, non-connection sections in one
phase: "Language features (needed)", "Compiler correctness / cleanup",
"ABI / performance", and "Runtime / Toolbox robustness". The
"Serial / connection" section and the parked "Compiler-on-Mac" section
are untouched; so is everything in `docs/FUTURE.md`.

## Why one phase

Twenty-three actionable entries. Twenty are mechanical fixes; three are
new language surface (array-literal initializers, window-owned menu
sets, `file.openRF`). Several of the fixes and all three features force
the same expensive regeneration — every `testdata/cg68k/*.s` golden, the
`emitui` goldens, the `clarusc/clarusc.c` snapshot — so fixing them a
phase at a time pays that cost repeatedly. The compiler-cleanup phase
(2026-09-05) proved the shape: group the work into waves so the goldens
bless exactly twice and the snapshot regenerates exactly once.

## 1. Entry dispositions

Section and entry as they read in `docs/TODO.md` at `2e59fa6`, and the
wave that owns each.

| # | Entry | Wave |
|---|---|---|
| 1 | Array-literal initializers | 2 (§4) |
| 2 | Per-window menu bars / menu teardown | 2 (§5) |
| 3 | Resource-fork-as-bytes / `file.openRF` | 2 (§6) |
| 4 | Converge the three extern-index scans | 2 (§3.3) |
| 5 | Native-only leak: `lst.pop().field` on a handle-bearing record | 2 (§3.1) |
| 6 | Global `text` initializer with a non-literal expression | 2 (§3.2) |
| 7 | `KArr` param ABI copies arrays by value | 2 (§3.4) |
| 8 | `ser.cla` reads per byte | 1 (§2.9) |
| 9 | `scripts/size-68k.sh` suite composition stale | 1 (§2.10) |
| 10 | `cg_init_globals` re-zeroes and unrolls | 2 (§3.5) |
| 11 | Migrate `crc16`/`crc16x` to table-driven loops | 2 (§4.6, rides on array literals) |
| 12 | Buffered canvases blit every event-loop pass | 1 (§2.1) |
| 13 | `rtUiTableClick` no upper clamp | **excluded** — a deliberate tripwire, stays as recorded |
| 14 | Map runtime minors | 1 (§2.3) |
| 15 | Heap-jiggle hooks only the `UiNewPtr` waist | 1 (§2.2) |
| 16 | `rtUiLayout` dead `ctrlMp` assignment | 1 (§2.4) |
| 17 | `(new)` doc-comment tag | 1 (§2.4) |
| 18 | `cases_catalog.cla` discards `PBCreateSync`'s error | 1 (§2.8) |
| 19 | `rt_fh_mac_time` duplicates `rt_dt_now_mac` | 1 (§2.5) |
| 20 | `rtFhDevRename` re-issues the catalog lookup | 1 (§2.6) |
| 21 | `rtFh68kEnsureState` unchecked `SerNewPtr` | 1 (§2.6) |
| 22 | Zero `fdType` reads back as `""` | 1 (§2.6) |
| 23 | Host `readdir`/rename/move buffers clip silently | 1 (§2.7) |
| 24 | `crc32` table pointer global in every program (sub-entry of #1) | 2 (§4.6) |

Entry 13 is the only one left in TODO.md after this phase, and it is a
"do not fix" note, not work. It moves to `docs/ROADMAP.md`'s Standing
rules at close-out so TODO.md's Runtime section can be deleted outright.

## 2. Wave 1 — runtime and harness

Wave 1 touches `runtime/`, `toolbox/`, `testsuite/`, `tests/`, and
`scripts/` only. The compiler is not edited, so every golden hunk in the
wave-1 bless must be a runtime-edit ripple; the differential oracle from
compiler-cleanup §2 (build the wave-1 tip's runtime with the pre-phase
compiler and diff its `.s` output against the blessed goldens) proves it.

### 2.1 Canvas dirty flag (entry 12)

`rtUiFlushBufferedCanvases` (`runtime/clarus/uiwidgets.cla:1369`)
`CopyBits` every buffered
canvas with an offscreen port on every `rtUiRun` pass. Add a `dirty:
int` field to `RtUiCanvasBuf` (`uidesc.cla:861`, overlay record — the
descriptor's allocation grows by 4 bytes on both lanes). Every drawing
op (`clear`/`line`/`rect`/`fillRect`/`circle`/`fillCircle`/`drawText`/
`pattern`) sets it; the flush skips a clean canvas and clears the flag
after blitting; the `updateEvt` path passes a `force` flag so window
exposure repaints regardless. The Bounce example draws every frame, so
animation is unaffected; a static canvas under an `every` timer costs
nothing per pass and the cursor stops flickering.

Proof: a toolbox-suite case `CanvasIdle` — draw once, run 200 scripted
idle ticks, assert the canvas's blit counter (a new `UiTestVerb`
probe reading a per-canvas counter incremented in the flush) advanced
exactly once and that FreeMem is flat.

### 2.2 Widen the heap-jiggle waist (entry 15)

`rtUiJiggleTick()` (`uiscript.cla:90`) fires at each scripted dispatch
and inside the `UiNewPtr` wrapper (`ui.cla:196`). Every other runtime
allocation bypasses it. Add the tick to the wrappers for `UiNewPtrClear`,
`UiNewHandleClear`, `UiNewRgn`, `UiTENew`, `UiLNew`, `UiNewMenu`,
`UiNewControl`, and `UiNewWindow` — the same one-line call, guarded by
the existing jiggle-mode flag so an unscripted run is untouched. A
stale master pointer held across ANY runtime allocation is now
compacted under. The four pass-into-trap sites compiler-cleanup §3.1
documented stay unreachable by construction (the pointer is inside the
trap when the move happens); their note in `docs/HISTORY.md` is not
changed.

Proof: the existing `TestToolboxSuiteJiggleOn68k` port
(`tests/mactest/toolbox_jiggle.sh`) stays green — that is the
assertion that no widened waist uncovers a new instance. If it goes
red, that is a real bug found, fixed in the same task and recorded.

### 2.3 Map runtime minors (entry 14)

In `runtime/clarus/map.cla` and `runtime/host/rt_core.inc`: (a) every
index-probe loop gets a bound of one full table sweep and panics with
`map: index corrupt` past it, instead of hanging; (b)
`rt_map_layout_check` gains `offsetof` assertions for every field the
`.cla` overlay reads, not just `sizeof`; (c) the dead `MAP_KEYBLOCK`
constant is deleted; (d) the three near-identical growers collapse into
one helper taking the element stride. The append-only key pool is a
documented ceiling and stays (FUTURE candidate if it ever bites).

### 2.4 Dead code and a stray tag (entries 16, 17)

Delete the unread `ctrlMp = UiHandleDeref(ctrl)` at
`uiwidgets.cla:568` (the sibling at 717 is live — the next line pokes
through it). Delete the two `(new)` markers in `ui.cla`'s About-box
helpers.

### 2.5 One epoch helper (entry 19)

`rt_fh_mac_time` (`runtime/host/rt_fileh.inc:210`) and `rt_dt_now_mac`
(`rt_ext_host.inc`) each carry the same Unix-to-Mac-epoch-local
conversion. One `rt_unix_to_mac_secs(time_t)` in `rt_ext_host.inc`,
both callers use it.

### 2.6 Native filesystem minors (entries 20, 21, 22)

`runtime/clarus/fileh_68k.cla`: (a) `rtFhDevRename` reuses the parent
DirID `rtFhDevStat`'s lookup already fetched, stashed at a new
`rtFh68kState+44` slot, instead of its own `PBGetCatInfoSync`; (b)
`rtFh68kEnsureState` checks `SerNewPtr`'s result, sets `lastError` to
`memFullErr` and returns `false` on nil — its callers already propagate
a false return; (c) `rtFh68kFourCCToStr` gains the recorded comment that
a zero `fdType` and a folder both read back as `""`, and
`docs/clarus-language-reference.md`'s `file.info` entry gains one
sentence naming `isDir` as the discriminator.

### 2.7 Host clamps set `lastError` (entry 23)

`rt_ext_FhHListNext`, `rt_ext_FhHRename`, `rt_ext_FhHMove`
(`runtime/host/rt_fileh.inc`): a name over 255 bytes or a path/newName
combination over the 512-byte target buffer sets `lastError` to
`bdNamErr` and returns failure instead of silently truncating. One
`rt_fileh_test.c` case per function.

### 2.8 Catalog test checks its create (entry 18)

`testsuite/toolbox/cases_catalog.cla` ~219: keep `PBCreateSync`'s
result; anything other than `noErr` or `dupFNErr` fails the case with
the error number in the report line.

### 2.9 `ser.cla` bulk reads (entry 8)

`file.save`/`file.load` (`runtime/clarus/ser.cla`) read the serialized
stream a byte at a time. Adopt the bulk readers the clir-load-perf phase
added (`intAt`/`stringAt`/`textAt`) for the scalar and string arms; the
per-record walk shape is unchanged. Byte-identical output is the
contract: `tests/sertest/` and the frozen `clrd_goldens` pin it, no
bless.

### 2.10 `size-68k.sh` reads the file lists (entry 9)

`scripts/size-68k.sh` composes the two suites from an inline list that
is five `cases_*.cla` files behind `tests/mactest/coregui_files.txt`.
Replace both inline lists with a read of `coregui_files.txt` and
`toolbox_files.txt` (the same fix TODO.md prescribes for the bake
script's toolbox list). Record the before/after CODE-byte numbers for
this phase in the wave-2 close-out.

### 2.11 Wave-1 end

`scripts/test-task.sh --smoke`, then bless #1 (`CLARUS_CG68K_BLESS=1`,
`emitui` goldens), then the differential oracle above, then
`CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` for the two suite boots
and the jiggle boot. Commit.

## 3. Wave 2 — compiler fixes

### 3.1 `lst.pop().field` on a handle-bearing record, native lane (entry 5)

`cgIntrListPopLike` tracks a popped handle kind in every position but
deliberately not a `KRec` scratch (a block copy hands the bytes to a
destination that then owns them, and `cgLastTrackedOff` is only
consulted for handle kinds — tracking the scratch would double-release
fields the destination still uses). In receiver and operand position
nothing takes ownership, so the record's handle fields leak one block
per evaluation. Fix as recorded: extend `cgMaterializeToTemp`'s
(`cg68k.cla:5891`) gate to `irExprKind(e) == EIntr and
lowIntrIsOwningContainerRead(irIntrName(e))` for `KRec` results only —
the materialized temp is a proper owned record whose end-of-statement
release walks its fields. Handle kinds are excluded (already tracked at
the producer; double-tracking would double-release).

Proof: a new arm in the toolbox suite's `LeakCheck` — pop a record with
a `text` field in receiver position (`lst.pop().t.length`) and in
operand position (`lst.pop().n + 1`), 500 iterations, FreeMem flat in
both directions. Plus a `cg68k` listing-level fixture asserting one
release per evaluation.

### 3.2 Global initializer with a non-literal expression (entry 6)

The reference (Chapter 1, initialization order) already promises that a
top-level initializer may call a function. So `var g: text = mk()` is a
bug on both lanes, not a missing feature. Native: `cgEmitInitGlobalsStub`
(`cg68k.cla:5039`) runs its initializers with no temp pool, so
`cgAllocTmpOff` aborts; give the stub its own small/big temp pool sized
by the same per-function high-water pass every real function gets.
Host: `cpEmitGlobalsInit` (`cprint.cla:7333`) emits initializer calls
before the function prototypes; move the prototype block ahead of
`clar_init_globals`. Proof: `testdata/run/global_init_call.cla` —
`var g: text = mk()`, `var h: text = "ab" + "c"`, and a global reading
a LATER global's zero value, asserting the reference's declaration-order
rule — on both lanes.

### 3.3 One extern-index scan (entry 4)

`cgExternIdxByName` (`cg68k.cla:10437`) and `fpExternIdxByName`
(`cprint.cla:1600`) become one-line calls to `irExternLookup`
(`ir.cla:1036`). Output-neutral; the wave-2 bless proves it by having
no hunk attributable to it.

### 3.4 `KArr` param ABI (entry 7)

`lower.cla:1024` already counts `KArr` as a value kind for the
borrow-safety root walk, but the copy decision at `lower.cla:1200` gates
on `KStr or KRec` only, and both backends still pass arrays by value.
Extend the gate to `KArr`, and make each backend pass a borrowed `KArr`
argument by address exactly as it passes a borrowed `KRec` (the `LEA`
path on 68k, the `const T *` cast on the host lane, both already
parameterized by kind). Parameters are immutable (reference, Chapter
6), so the only copy trigger is the existing aliasing rule; `const`
arrays (§4) borrow the pool address through the same path.
**Scope (plan-time decision):** the by-address ABI applies to arrays
whose element carries no handle (`not cgNeedsRelease(t)`); a
handle-bearing array parameter (an array of records with `text`/`list`/
`map` fields) keeps by-value passing, because its copy path would need a
retain walk. One shared predicate (`cgParamByRef`/`cpParamByRef`)
decides on both sides of every call, so caller and callee can never
disagree. An array argument that needs a copy and exceeds the 512-byte
big-temp slot aborts the compile with a message naming the ceiling, the
same way an oversized record does today.

Proof: `testdata/cg68k/karr_param.cla` golden (a 64-int array passed
three ways: plain, aliased through a global the callee writes, forwarded
to a second callee), the core suite's existing `param` cases extended
with an array arm, and `testdata/run/karr_abi.cla` on both lanes.

### 3.5 `cg_init_globals` (entry 10)

`cgEmitInitGlobalsStub` default-inits every global through
`cgDefaultInitAt` even when the below-A5 sweep already zeroed it, and
`cgArrDefaultAt` unrolls a `T[N]` into N stores. Two changes: skip any
global whose default is all-zero bytes (every scalar, `bool`, `char`,
enum, `ptr`, handle, and any array/record composed only of those — the
existing `cgDefaultIsZero`-style predicate, added if absent); for a
scalar array whose default is non-zero (a `string(n)` array's length
bytes) emit a `DBRA` loop above 8 elements instead of unrolling. Every
`cg68k` golden's stub changes; that is the wave-2 bless.

## 4. Array-literal initializers (entries 1, 11, 24)

### 4.1 Syntax

```rust
const kermitTab: int[4] = [0x0000, 0x1189, 0x2312, 0x329B]
var keymap: char[3] = ['a', 'b', 'c']
```

An array literal is `[` elements `]` and is legal ONLY as the
initializer of a `const` or `var` whose declared type is `T[n]`, at top
level or as a local. Elements follow today's `const` rule: a literal, an
enum member, or a previously declared scalar constant — no expressions.
Element types: `int`, `bool`, `char`, `fixed`, enum. Not in this phase:
nested arrays, `string(n)` elements, record elements, a literal in any
other expression position, and partial fill — the element count must
equal `n` exactly, and a mismatch is `array literal has M elements,
type has N` (the most likely typo in a 256-entry table is a miscount,
and zero-fill would hide it).

### 4.2 `const` arrays

A new constant kind in `check.cla`. Reads (`tab[i]`) index the constant
pool directly: PC-relative addressing on 68k, a `static const` C array on
the host lane. Bounds checks are the ordinary fixed-array check. A
`const` array is a valid `KArr` argument — it borrows the pool address
(§3.4), which immutability makes safe — and a valid `switch` label is
NOT extended to it (a `const` array is not a scalar). Assigning to an
element is the existing "cannot assign to constant" error.

### 4.3 `var` arrays with a literal

The literal goes into the pool once; the variable's initialization is a
block copy from the pool (`cg_init_globals` for a global, function entry
for a local), so a 256-int table costs one copy loop. The host lane
emits the same `static const` array and a `memcpy`.

### 4.4 Pool representation: a new relocation class

Array literals get their own pool section and relocation class,
`cgRelClsPoolArr` (= 12, after `cgRelClsJt`), with a per-literal label
list `cgArrLitLabels` alongside `cgStrLitLabels`. `cgEmitPoolsBody`
emits each literal as big-endian element bytes at the element's native
stride (`cgArrElemStride`, so `bool[n]`/`char[n]` pack at 1). IR gains
`irArrLits` (element type + values) parallel to `irStrLits`.

This is a deliberate object-code/CLIR format extension, chosen over
smuggling the bytes through the string pool: `bake.cla`'s relocation
dispatch (`bkObjRelocSymValid` ~3113 and the section reader/writer
around it) gains one arm each for the new class, and the CLIR body
version bumps. `bake.cla` is therefore edited in this phase, which owes
the Snow `clarusc_bake` gate — run ONCE at close-out (§7), covering
every `bake.cla` edit on the branch (this one and §5.3's).

### 4.5 Reference

Chapter 3's fixed-array entry and the Constants section gain the
literal form, the exact-count rule, the element-type list, and the
`const`-array semantics. The `CheckClean` fence manifest is regenerated
as the wave's last task, per the standing convention.

### 4.6 The three CRC tables

`text.cla`'s `rtCrc32Tab` heap block and its lazy builder are replaced by
a 256-entry `const int[256]` literal; `crc16` and `crc16x` migrate from
per-bit loops to table-driven loops over two new `const int[256]`
literals (reflected `0x8408` for KERMIT, forward `0x1021` for XMODEM,
the byte-indexed formulations recorded in TODO.md). The three `ptr`
globals and their builders are deleted, which also closes entry 24 (the
table pointer in every program's data segment). Bit-exactness is pinned
by the existing vectors (`"123456789"` → `0x2189`, `0x31C3`, and the
CRC-32 vector), `testdata/run/crc16.cla`, the core suite's `Crc16`
case, and `examples/pagefile.cla`'s journal checksum. The tables are
generated by a throwaway script in the task's report, not typed.

## 5. Window-owned menu sets (entry 2)

### 5.1 Syntax and semantics

```rust
window Doc {
    title: "Untitled"
    menus: File, Edit
    ...
}
```

`menus:` is a new optional top-level window property naming declared
menus, in the existing `name: v1, v2` property syntax (so the parser is
untouched; the checker validates the values). The named menus must be
declared above the window (declare-before-use, like every other
declaration). Rules:

- The **app-scope bar** is Apple plus every menu no window claims, in
  declaration order. A program with no `menus` clause anywhere gets
  exactly today's bar.
- When a window whose type has a `menus` clause is frontmost, the bar is
  Apple, the app-scope menus, then that window's set, in declaration
  order. When no such window is frontmost, the bar is the app-scope bar.
- A menu may be claimed by any number of window types. Naming an
  undeclared menu, or the same menu twice in one clause, is a check
  error.
- Menu-item `enabled` state and window-scoped `extend` dimming are
  unchanged: every `MenuHandle` is created once at startup and kept for
  the run; only its presence in the bar changes.

### 5.2 Runtime

`rtUiBuildMenus` (`ui.cla:1259`) splits: the build-once half creates
every handle as today but inserts only the app-scope menus; a new
`rtUiSyncMenuBar()` computes the target set from the front window's
descriptor, and if it differs from the current set, deletes the menus
that leave, inserts the ones that arrive (`UiInsertMenu(mh, 0)` in
order), and calls `UiDrawMenuBar`. It is called from `rtUiAfterFrontChange`,
the hook that already fires on open, close, and click-to-front. Both
lanes run the same `.cla` runtime (`runtime/mac/rt_ui.c` is a frozen,
never-linked oracle and is not edited). How this is drawn is recorded in
`docs/FUTURE.md` for re-evaluation once real multi-window apps use it.

### 5.3 Descriptor and blob

The window descriptor (`uidesc.cla`, 48 bytes/entry) gains one int32,
`menuMask` (bit i set = menu declaration index i is claimed by this
window type; at most 31 menus per program, a check-time error beyond),
making it 52 bytes/entry (`uiblob.cla:929`'s stride and a new
`uidWinMenuMask` accessor; no new blob section). `irWindowDescs` gains
the field; `bake.cla`'s window-desc section (`~1047`/`~2746`) writes and
reads it — the second `bake.cla` edit on the branch, covered by the same
close-out Snow run.

### 5.4 Suite teardown

The toolbox suite's harness windows declare their menus, so a case's
menus leave the bar when the case's window closes — the teardown the
origin note asked for, with no add/remove API. A new toolbox case
`WindowMenus` opens two windows with different sets, activates each,
and checksums the menu-bar band each time (the `CasesTable`
checksum-band technique), then closes one and checks the bar reverts.

## 6. `file.openRF` (entry 3)

### 6.1 Surface

`file.openRF(path: string): filehandle` — opens an existing file's
resource fork read/write; `nil` plus `lastError` if the file does not
exist or the fork cannot be opened. Everything else is the existing
`filehandle` API: a whole-fork read is `f.readAt(0, f.size(), t)`; a
fork written alongside an existing data fork is `file.create` (or an
existing file), then `openRF`, `writeAt`, `close`. No blob helpers.
`readResource`/`writeRes` are unchanged.

### 6.2 Native lane

`fileh_68k.cla`: `rtFhDevOpenRF` mirrors `rtFhDevOpen` with `PBHOpenRF`
(already declared in `toolbox/files.cla`) in place of `PBHOpen`. The
refnum feeds the existing positioned read/write/flush/close path
unchanged; the slot records the fork only for `lastError` wording.

### 6.3 Host lane

The host `filehandle` is a bare `fd + 1`, so `openRF` must yield an fd:

- **macOS** (`#ifdef __APPLE__`): `open("<path>/..namedfork/rsrc",
  O_RDWR | O_CREAT)`. The kernel stores it natively on APFS/HFS+ and as
  an AppleDouble `._` sidecar on FAT/NFS/SMB-without-streams, so one
  line covers every volume type and interoperates with Finder.
- **Other hosts**: materialize the fork into an unlinked temp file
  (`mkstemp` + `unlink`) loaded from the AppleDouble v2 sidecar
  `._<name>` next to the file (entry ID 2, resource fork; entry ID 9,
  Finder info, preserved verbatim if present); return that fd. A small
  side table keyed by fd records the sidecar path; `flush` and `close`
  rewrite the sidecar from the temp file. The format is the one macOS
  itself writes on non-native volumes, so a Clarus-written sidecar is a
  real fork to a Mac reading the same share. Roughly 120 lines of C in
  `rt_fileh.inc`.

An env var `CLARUS_FORCE_APPLEDOUBLE=1` makes macOS take the sidecar
path too, so the harness exercises both on the dev machine.

### 6.4 Compiler

`check.cla`'s `fileFuncs` gains `openRF` with `open`'s signature;
`lower.cla`'s file-call lowering gains the arm; both backends forward to
`rtFhOpenRF`. Per the standing rule, `tests/bake/connfileh.sh` gains the
`emit68k_pair` twin for the new runtime function in the same task.

### 6.5 Proof

`testdata/run/openrf.cla` on the host (both storage paths on macOS via
the env var): create a data-fork file, write a fork, reopen, read back,
assert the data fork is intact and `file.info` still reports the type.
A core-suite case `OpenRF` hardware-proves the native lane on System 6.
The reference's file table and `filehandle` section document the
function and the host storage rule.

## 7. Wave ends and close-out

- **Wave 1 end**: §2.11.
- **Wave 2 end**: T1 with `--smoke`; bless #2 (`cg68k`, `emitui`,
  `selfhost` behavior blobs if any moved); snapshot regen to fixed point
  (`tests/selfhost/fixedpoint.sh`'s recipe); reference fence manifest
  regenerated; `scripts/size-68k.sh` before/after recorded.
- **Close-out**: full T2 (`scripts/test-merge.sh`); then the Snow
  `clarusc_bake` gate ONCE (`CLARUS_SNOW_TESTS=1 make test
  T=mactest/snow/clarusc_bake`, ~55 min) for the two `bake.cla` edits;
  whole-branch review on the most capable model, one consolidated fix
  wave; `docs/TODO.md`'s four sections deleted (entry 13's note moves to
  ROADMAP's Standing rules); `docs/HISTORY.md` entry; ROADMAP "Where we
  are" updated.

## 8. Out of scope

- Everything in `docs/FUTURE.md`, including the menu-drawing
  re-evaluation this phase records there.
- The "Serial / connection" TODO section (its own follow-up phase) and
  the parked "Compiler-on-Mac" section.
- Array literals in expression position, nested or record-element
  literals, partial fill.
- A runtime menu add/remove API or per-window `MenuList` swapping.
- Whole-fork blob helpers on top of `openRF`; `writeRes` changes.
- The `rtUiTableClick` clamp (entry 13).

## 9. Risks

- **`bake.cla` is edited twice** (§4.4, §5.3), so the Snow gate is owed
  and the CLIR body version bumps. Mitigation: both edits are additive
  section arms, and the one Snow run at close-out is budgeted.
- **`KArr` borrow correctness** rides on `lowArgNeedsCopy`'s root walk
  treating arrays like records. It already counts `KArr` as a value
  kind; the task must add the forwarded-argument and global-aliasing
  fixtures (§3.4) before flipping the gate, TDD-style.
- **Widened jiggle waist may go red** (§2.2). That is the point; a red
  is a real pre-existing bug, fixed in-wave and recorded.
- **Menu-bar redraw cost** on a Mac Plus is visible only when the front
  window's set actually changes; the equal-set skip keeps ordinary
  activation free. Recorded in FUTURE.md for re-evaluation.
- **Plan-time deviations** (2026-09-06, recorded in the plan's Global
  Constraints and patched into §2.1, §3.4, §5.1-5.3 above): `menus:`
  colon syntax; `menuMask` bitmask; `rt_ui.c` untouched; handle-free
  arrays only for the borrow ABI; the 512-byte copy ceiling.
- **Two blesses, one snapshot**: wave 1's runtime edits also change the
  compiler's own embedded runtime, so the snapshot regen at wave 2's end
  covers both waves; the wave-1 differential oracle is what proves
  nothing else moved.
