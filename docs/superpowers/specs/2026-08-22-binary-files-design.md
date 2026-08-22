# Binary files — `filehandle`, binary `text` accessors, and usability gaps — design

Brainstormed with Andrew 2026-08-22. The ROADMAP's "Binary streams and
files" language-usability item. Driven by the 68kBBS project's
`docs/language-gaps.md` (68kbbs repo), whose concrete consumer is the
vDB database engine (`libvdb/db.md`: fixed 512-byte pages, a write-ahead
journal, B-tree index files, all little-endian, CRC-16 checksums) to be
written in pure Clarus. Approved section by section in-chat; this
document is the written record.

## 1. Problem

Eight gaps, from the 68kBBS list, in its priority order:

1. **Required: positioned (random-access) file I/O.** The `file`
   namespace is whole-file only (`readText`/`writeText`/`save`/`load`).
   A page-oriented database needs an open handle with positioned reads
   and writes, `flush` for write-ahead ordering, `setSize` for journal
   truncation. Raw File Manager traps via `extern record` param blocks
   would work natively but put unsafe-lane `ptr`/`poke` code under the
   one component where corruption matters most, and would not run on
   the host lane at all.
2. CRC16 — vDB's journal checksums and string index keys.
3. Little-endian accessors on `text` (`intAt` is big-endian only).
4. In-place binary writers on `text` (`intAt`/`stringAt`/`textAt` have
   no `set*` siblings; building a page is byte-by-byte `t[i] = c`).
5. Int-to-string conversion — every program reimplements `intStr`.
6. `include "toolbox/X.cla"` only works from inside the compiler repo.
7. Method calls on `connection`-typed parameters/locals/fields fail
   (`method call on receiver kind 13 not yet implemented`).
8. emit68k's fixed per-statement string/record temp ceiling
   (`cgBigTmpSlots`) makes check-clean code fail at emit.

Decided (Andrew, 2026-08-22): **all eight in one phase**, one branch,
one merge — the items are small individually and share machinery (7
falls out of the representation chosen for 1; 2-5 are all
binary-format helpers on `text`/`int`).

## 2. Approach (decided)

- **`filehandle` is a plain value** — a new resource type represented
  at runtime as a small `int` (host: `fd+1`; Mac: the File Manager
  refNum), `nil` = 0. Copyable into records, arrays, lists, maps, and
  parameters for free; `close` is explicit; no ARC, no auto-close (a
  leaked open handle leaks a file, exactly like C). Alternatives
  considered: a refcounted heap object with close-on-last-reference
  (serial-phase-sized work on its own — a new ARC kind on both lanes,
  dispose hooks, retain/release in codegen — for a convenience the
  consumer does not need), and `connection`'s compile-time-slot trick
  (structurally cannot follow a value through a call; it is the cause
  of gap 7).
- **`connection` adopts the same value representation** (`slot+1`,
  `nil` = 0), so `connection` params/locals/fields/elements work with
  one mechanism instead of two. The 4-slot cap and the name-bound
  `on conn.<event>` handlers are unchanged.
- **Synchronous `bool`/`int` + `lastError`** for every `filehandle`
  operation — the `file.*` idiom, not `connection`'s deferred-event
  `failed` idiom: file I/O is synchronous on both lanes. Error
  principle, as in the serial spec: **contract violations are runtime
  errors; environmental failures are `false`/`-1` + `lastError`.**
- `f = file.open(path)` returns the handle (nil on failure) rather than
  the gaps doc's `file.open(path, f): bool` out-param form — same
  semantics, no by-ref-scalar lowering machinery.

## 3. Language surface (reference changes)

### 3.1 `filehandle`

New builtin type name `filehandle`, a resource kind like `connection`
(`nil`-comparable; `==`/`!=` between two handles compare identity).
Default value `nil`. Allowed anywhere a value type is allowed (locals,
params, returns, record fields, array/list/map elements, globals). Not
serializable: a record containing a `filehandle` field is rejected by
`file.save`/`file.load`'s value-type-fields rule, with the existing
"is not a value type" diagnostic.

```rust
var f: filehandle = file.open(path)                        // existing file, read/write
var j: filehandle = file.create(path, "VDBJ", "68BB")      // create-or-truncate, open for read/write
if f == nil { alert(lastError.message) }

f.readAt(pos: int, count: int, out: text): bool   // positioned read; out is replaced
f.writeAt(pos: int, data: text|string): bool      // positioned write; extends the file past EOF
f.append(data: text|string): bool                 // write at current EOF
f.size(): int                                     // logical EOF in bytes; -1 + lastError on error
f.setSize(n: int): bool                           // grow (new bytes zero) or truncate
f.flush(): bool                                   // durability barrier
f.close()                                         // idempotent
```

Semantics:

- `file.open(path)`: the file must exist; opened read/write (the Mac
  `fsRdWrPerm`; host `O_RDWR`). Returns `nil` + `lastError` on any
  failure (not found, permission, too many open files).
- `file.create(path, type, creator)`: creates the file if missing,
  stamps `type`/`creator` exactly as `file.writeText` does (mandatory,
  compile-time-literal 4-character strings, `lowCheckLiteral4CCArg`;
  ignored on the host), truncates to 0 bytes, opens read/write. Returns
  `nil` + `lastError` on failure.
- `readAt(pos, count, out)`: reads up to `count` bytes starting at
  byte offset `pos` into `out` (replacing its contents). A read that
  crosses EOF succeeds with a shorter `out`; a read starting at or
  past EOF succeeds with an empty `out`. Returns `false` + `lastError`
  only on an I/O error. `pos < 0` or `count < 0` is a runtime error.
- `writeAt(pos, data)`: writes all of `data` at `pos`; a write past EOF
  extends the file (the Mac File Manager extends on write; the gap
  between old EOF and `pos`, if any, has unspecified contents on the
  Mac and zeros on the host — programs that care pre-size with
  `setSize`). `pos < 0` is a runtime error. `data` may be `text` or
  `string` (the `send` overload shape).
- `append(data)`: writes at the current EOF (`fsFromLEOF` on the Mac,
  `lseek(SEEK_END)`/`O_APPEND`-equivalent on the host). No `size()`
  call is involved, so it does not depend on §4.2's GetEOF question.
- `size()`: the logical EOF. `-1` + `lastError` on error.
- `setSize(n)`: `n < 0` is a runtime error. Growing zero-fills on the
  host; on the Mac the new bytes' contents are unspecified (documented).
- `flush()`: Mac `_FlushFile` then `_FlushVol` on the file's volume;
  host `fsync`. This is the journal protocol's write-ahead barrier.
- `close()`: idempotent; closing a `nil` handle is a no-op. After
  `close` every copy of the value is stale; an operation through a
  stale copy fails with `false` + `lastError` (File Manager `rfNumErr`
  on the Mac, `EBADF` on the host) — never silently reused. A program
  that wants a "closed" marker sets its variable to `nil`.
- **Any method other than `close` on a `nil` handle is a runtime
  error** ("use of nil filehandle") — a bug, not weather.
- Every operation is synchronous; no events, no pump.
- No Gestalt gating: every trap used is 1980s-IM System 6 Toolbox.

### 3.2 `connection` as a value

No new syntax. `connection`-typed parameters, locals, record fields,
and array/list/map elements now support `open`/`send`/`close` — the
receiver may be any expression of type `connection`, not only a bare
global identifier. `on conn.<event>` handlers still name a global
`connection` var (unchanged; events are dispatched by the global's
slot). `nil` is the value of a never-assigned non-global `connection`
(a record field, an array element); `open`/`send`/`close` on it is a
runtime error ("use of nil connection"). The 4-variable cap stands.
`termio.cla`'s color functions can take `(conn: connection, ...)`
again.

### 3.3 `text` binary accessors

Siblings of `intAt`/`stringAt`/`textAt`/`hashStep`, text-only, same
bounds rule (out-of-range is a runtime error `text index out of range`,
using the overflow-safe `pos > len - n` form):

| Method | Result | Notes |
|---|---|---|
| `t.intAtLE(pos): int` | signed 32-bit | little-endian twin of `intAt` |
| `t.wordAt(pos): int` | 0–65535 | big-endian unsigned 16-bit |
| `t.wordAtLE(pos): int` | 0–65535 | little-endian unsigned 16-bit |
| `t.setIntAt(pos, v: int)` | — | writes 4 bytes big-endian |
| `t.setIntAtLE(pos, v: int)` | — | writes 4 bytes little-endian |
| `t.setWordAt(pos, v: int)` | — | writes the low 16 bits of `v`, big-endian |
| `t.setWordAtLE(pos, v: int)` | — | writes the low 16 bits of `v`, little-endian |
| `t.crc16(h: int, pos: int, n: int): int` | 0–65535 | CRC-16/KERMIT over `t[pos, pos+n)`, rolling |

`crc16` is CRC-16/KERMIT (reflected polynomial 0x8408, init 0, no
final XOR — `libvdb/src/hash.c`'s `CRC16`), in `hashStep`'s rolling
shape: pass `h = 0` to start, feed the result back to continue across
chunks; `n == 0` returns `h`. One-shot use is `t.crc16(0, 0, t.count)`.
Setters do not grow the text (a write ending past `count` is the same
out-of-range error as a read); size the page first with `append` or
existing means. Byte reads/writes stay `int(t[i])` / `t[i] = char(v)`.

### 3.4 `string(n)`

`string(n)` converts an `int` to its decimal representation as a
`string`, joining the explicit conversion family (`int(f)`, `fixed(i)`,
`char(i)`, `int(c)`, `ptr(i)`, reference §Numeric Conversions).
Negative-safe, including `int.min` (`-2147483648`). Only `int` is
accepted this phase (no `fixed`/`char`/`bool` formatting). In type
position `string(20)` remains the sized-string type; the parser already
distinguishes type from expression context, so both coexist; the
reference notes the visual collision once. The reference's examples
and the in-tree reimplementations (`examples/serialecho.cla`'s
`intStr`, `testsuite/kit.cla`'s `tkIntToStr`, the runtime's `natItoa`/
`rtUiIntToText`) migrate to it.

### 3.5 `include "toolbox/..."` resolution

Resolution order for an `include` path, documented in the reference:

1. Relative to the including file's directory (today's rule;
   absolute paths win outright) — unchanged.
2. If step 1 names no readable file **and** the path's first segment is
   `toolbox/`: the compiler's runtime directory's sibling `toolbox/`
   (`<rtdir>/../toolbox/<rest>`), where `<rtdir>` is `--rtdir` or
   today's upward probe from the cwd. Both lanes (host cc builds and
   the Mac-resident ClarusC's disk mode).
3. Mac-resident ClarusC only: the baked `'CLFS'` resource under the
   key `driveKeyResolve` already computes (`toolbox/osutils.cla`) —
   this step exists today; it is listed for completeness.

Identity/dedup: a `toolbox/` include found via step 2 gets the same
normalized identity as the same file reached via a relative path, so
a program that includes `toolbox/osutils.cla` and a runtime module
that includes `../../toolbox/osutils.cla` parse it once. 68kBBS drops
its `clarus-src` symlink spelling.

### 3.6 emit68k string/record temp ceiling

Gone. A statement may need any number of string/record temporaries;
the frame grows to fit. The reference/docs drop the "bump
cgBigTmpSlots" caveat and `testsuite/kit.cla`'s split-`alert`
workaround comment. The single-temp size limit (`cgBigTmpSize`, 512
bytes) stays — it bounds records/strings, not statement shape.

## 4. Implementation architecture

### 4.1 Representation and lowering

- `types.cla`: new `TyFileHandle` TypeKind (appended, so existing
  kind numbers — including 13 — are stable). `check.cla`:
  `declBuiltinType("filehandle")`, `isResourceKind` gains it,
  `filehandleMethods` table, `fileFuncs["open"]`/`["create"]`
  returning the type, the `string` conversion arm in the conversion
  switch, the seven new `textOnlyMethods`. The serializable-fields
  rule rejects it by construction (not in the value-type list).
- `lower.cla`: `lowTypeAt` maps `TyFileHandle` AND `TyConnection` to
  the int IR type. A global `connection` var becomes an IR int global
  initialized to `slot+1` (today `lowGlobalVarDecl` emits nothing for
  it); `lowConnMethod` lowers the receiver with `lowExpr` and passes
  the value — the compile-time `lowConnSlotOf` map survives only for
  the `on conn.<event>` dispatcher synthesis. New `lowFileHandleMethod`
  (value receiver → `rtFh*` runtime call), `lowFileCall` arms for
  `open`/`create`, `string()` → `IIntToStr` intrinsic, the text methods
  → `IText*` intrinsics. `nil` for both kinds lowers to int 0.
- `cg68k.cla`: intrinsic dispatch entries for the new `IText*` and
  `IIntToStr` (plain calls into the shared runtime routines, no
  inlining, like `ITextIntAt`); no new codegen concept — every handle
  is an int.
- `cprint.cla`: same intrinsics onto the same shared routines.

### 4.2 Runtime (conn-style lane split)

- `runtime/clarus/fileh.cla` (shared): argument checks (`nil` panic,
  negative pos/count/n panics), `lastError` wording, and the
  `rtFh*` entry points the lowering calls; delegates to the lane
  primitives (`rtFhDevOpen/Create/ReadAt/WriteAt/Append/Size/SetSize/
  Flush/Close`).
- `runtime/clarus/fileh_68k.cla` (native): File Manager through the
  catalog — `PBOpenSync` (`fsRdWrPerm`), `PBReadSync`/`PBWriteSync`
  with `ioPosMode = fsFromStart` + `ioPosOffset` (positioned I/O lives
  in the param block; no separate seek), `fsFromLEOF` + offset 0 for
  `append`, `PBSetEOFSync`, `PBFlushFileSync` + `PBFlushVolSync`,
  `PBCloseSync`, `PBCreateSync` + direct `PBSetFInfoSync` stamp
  (the no-Get discipline `natFileWriteText` already uses). Reads go
  through a bounce buffer with the `HLock`-around-`_Write` discipline
  `native.cla` documents. Spliced on the native superset like
  `conn_68k.cla`.
- `runtime/clarus/fileh_c.cla` (host): externs onto new
  `runtime/host/rt_fileh.inc` — `open(O_RDWR)`/`open(O_RDWR|O_CREAT|
  O_TRUNC)`, `pread`/`pwrite`, `lseek(SEEK_END)`+`write`, `fstat`,
  `ftruncate`, `fsync`, `close`; value = `fd+1`. Usage-gated splice
  like `conn_c.cla`. The demoted Retro68/cprint Mac lane gets a stub
  (every open fails with `lastError`), as the serial phase did.
- `toolbox/files.cla` gains the rest of the sync File Manager
  routines this needs, verified against Universal Interfaces inline
  words per the catalog's provenance convention: `PBGetEOFSync`
  (0xA011), `PBSetEOFSync` (0xA012), `PBGetFPosSync` (0xA018),
  `PBSetFPosSync` (0xA044), `PBFlushFileSync` (0xA045),
  `PBFlushVolSync` (0xA013), `PBAllocateSync` (0xA010), plus any further sync
  routines found while filling the manager.
- `size()` and the PBGetEOFSync question: `native.cla` documents,
  three times over, that `PBGetEOFSync`/`PBGetFInfoSync`/
  `ReleaseResource` hung real hardware 100% reproducibly under a busy
  heap (never in isolation). `size()` needs an EOF query, so the plan
  opens with a **probe task** on hardware under a deliberately busy
  heap: `PBGetEOFSync` vs `PBSetFPosSync(fsFromLEOF, 0)` +
  `PBGetFPosSync` vs FCB-info. Whatever survives is the
  implementation; the result and evidence go in the catalog comment
  and the reference's `size()` entry. `append` and `writeAt` are
  written so they never need the query.
- `text.cla` (shared by both lanes): `rtTextIntAtLE`, `rtTextWordAt`,
  `rtTextWordAtLE`, the four setters, `rtTextCrc16` (bitwise, 8
  iterations per byte; `ponytail:` a 256-entry table if a profile ever
  says so), plus `rtIntToStr` backing `string(n)`; `natItoa` and
  `rtUiIntToText` collapse onto it.
- `conn.cla`/`conn_c.cla`/`conn_68k.cla`: `rtConn*` entry points take
  the 1-based handle, index `h-1`, panic on 0. Dispatchers unchanged.

### 4.3 Compiler driver and backend

- `drive.cla` `expand()`: the step-2 `toolbox/` fallback — after the
  relative resolution fails to read, and the include's key (per
  `driveKeyResolve`) begins `toolbox/`, try `<rtdir>/../toolbox/` on
  disk; the existing baked-resource step remains after it on the Mac.
  `rtDir` may need resolving earlier than today's first-runtime-module
  lazy point; the same `findRtDir` probe.
- `cg68k.cla` big-temp pool: `cgEmitFunc` already runs twice per
  function (the `cg68Measure` throwaway pass, then the real pass). The
  measure pass records each function's maximum per-statement big-temp
  count (the pool grows on demand there instead of aborting); the real
  pass sizes that function's pool to exactly that max (a small floor so
  most functions' frames are unchanged or smaller than today's
  unconditional 16×512). `cgFuncFrameSizes` and the `SetApplLimit`
  stack heuristic pick the per-function number up with no change.
  `testdata/run/bigtmp_ceiling.cla` is repointed to prove a 40-temp
  statement emits and runs; a frame-size golden pins that a small
  function's frame shrank.

### 4.4 Planned consequences

- Runtime global renumbering (new runtime files) → one golden rebless
  wave (`CLARUS_MAC_BLESS=1`, native lane), planned not discovered.
- New `runtime/clarus/*.cla` + `toolbox/files.cla` growth → the bake
  manifest lists change → the standing-rule
  `TestClarusCBakePathOnSnow` rerun (`CLARUS_SNOW_TESTS=1`).
- `clarusc.c` snapshot regeneration; `TestSnapshotFixedPoint`.
- `docs/clarus-language-reference.md` (normative) and
  `docs/clarus-toolbox-cookbook.md` (new File Manager entries) updated
  in the same tasks as the code; 68kBBS's `docs/language-gaps.md` is
  the consumer's checklist, not ours.

## 5. Testing

- **T1, host, every task:**
  - Check fixtures: `filehandle` in records/arrays/params type-checks;
    `file.save` of a record with a handle field is rejected; `string()`
    rejects non-int; reftest fences for every new method name.
  - `testdata/runerr`: method on nil `filehandle`, negative `pos`,
    `setSize(-1)`, `open`/`send` on a nil `connection` field.
  - `testdata/run`: LE/word/setter round-trips (every accessor against
    a hand-built byte image, both endiannesses, sign and top-bit cases);
    `crc16` against published CRC-16/KERMIT vectors (`"123456789"` →
    0x2189) both one-shot and chunked; `string(n)` for 0, positive,
    negative, `int.max`, `int.min`; `bigtmp` 40-temp statement.
  - emitui/cg68k goldens for the new lowered shapes (value-receiver
    connection call, filehandle method, intrinsics).
  - Host end-to-end: `testsuite/core` gains `FileHandleRW` (create,
    writeAt/readAt, append, size, setSize grow+truncate, flush, close,
    reopen with `open`, a record owning two handles, a handle passed
    to a func, stale-after-close → `false`+`lastError`), `TextBinary`,
    `Crc16`, `IntToStr` — all run on host (CLI) and natively (the
    existing suite GUI boots), so both lanes are proved by the same
    cases. The serial host echo test gains a variant that sends through
    a `connection` parameter.
  - Include fallback: a Go test compiles a program outside the repo
    tree that includes `toolbox/osutils.cla`, with only `--rtdir`.
- **T2:** native suite boots (`TestCoreSuiteGUIOn68k` fans the new
  cases out per case), selfhost, snapshot fixed point, the rebless wave.
- **Gated Snow (`CLARUS_SNOW_TESTS=1`):** `TestClarusCBakePathOnSnow`
  rerun (standing rule), and an acceptance program
  `examples/pagefile.cla` — a vDB-shaped demo (512-byte pages, LE
  header via the setters, journal append + flush + truncate, CRC'd
  entries) — booted on Snow with its own `flush` ordering observable
  on the disk image; also Andrew's manual check.

## 6. Risks

- **`PBGetEOFSync` under a busy heap** — the probe task is first for
  this reason; `append`/`writeAt` are designed not to need it so only
  `size()` is exposed.
- **Connection re-representation touches working code** — the 4-slot
  runtime, dispatchers, and bake exclusion all stay; only the receiver
  path and the global's storage change. The existing serial host echo
  test and `SerialOpenWrite` suite case are the regression net.
- **Frame-size change from the per-function big-temp pool** — most
  frames shrink (16×512 unconditional today); any function that grows
  is one that previously could not compile at all. The stack heuristic
  absorbs it.
- **`string(n)` vs `string(N)` type syntax** — no parse ambiguity (type
  vs expression position), one line in the reference.

## 7. Out of scope (this phase)

Auto-close / ARC for handles; asynchronous File Manager calls and
completion routines; directories, volumes, enumeration, rename/delete
(catalog escape hatch); `listener`/`serviceBrowser`/MacTCP; a
`connection` cap above 4; CRC variants beyond Kermit (XMODEM etc. are
user-space); `fixed`/`char`/`bool` formatting in `string()`; the
`PBGetEOFSync` root cause (workaround only); Retro68 retirement (stays
in ROADMAP "Later"); a friendly vDB layer (the ROADMAP's "Then" item,
which this phase unblocks).
