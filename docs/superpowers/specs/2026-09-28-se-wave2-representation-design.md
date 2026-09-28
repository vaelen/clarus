# SE memory program, Wave 2: Representation (spec, 2026-09-28)

Status: **spec, awaiting review.** Branch `se-wave2-representation`.
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 2 is the
brief; D2, D10 and D12 are decided inputs). Wave 1's numbers and census:
umbrella §9.2 and `docs/HISTORY.md`'s Wave 1 entry.

Anchors below are as of `main` at `e0f2cfc8`.

## 1. Goal and exit

Shrink how the compiler represents what it must hold, so the
`bookmarks --rtbake` compile peaks at ≤ 4 MB.

**Where the bytes are today** (host memgate, `bookmarks --rtbake`,
68k-equivalent):

| Phase                  | Live    | Peak within phase |
|------------------------|--------:|------------------:|
| Parsed (bake re-parse) | 3.89 MB |       **6.32 MB** |
| Shaken                 | 3.92 MB |           3.92 MB |
| Measured               | 4.39 MB |           4.40 MB |
| Emitted segments 1–4   | 5.01 MB |           5.01 MB |
| Built fork             | 5.14 MB |       **5.42 MB** |

Two peaks must fall. The parse peak is end-of-parse live plus the whole
1.94 MB CLIR blob, which stays live while the IR is decoded, plus
list-doubling transients in the `bkRead*` readers. The back-end peak
is the ~1 MB string pool, the whole-segment `a68Items` stream, and
`cgObjRuns`' per-run text handles.

**Exit:**
- `tests/memgate/budget.txt` `bookmarks_rtbake` ≤ **4 MB** (4,194,304),
  with its measured peak + 1% committed. The estimate is ~3.4 MB at the
  parse and ~3.8 MB at `Built fork`, so the margin is thin. If 4 MB is
  not reached, the wave records the measured figure and a peak-moment
  census, and revises its own number (umbrella §5.5). It may not skip
  the ratchet.
- The other two memgate budgets drop to their new peaks + 1%.
- Every golden is unchanged except by the one output-changing task
  (§3.6) and the new core-suite cases (§3.1).
- End-of-wave gates (umbrella §5.3): full T2; `mactest/snow/clarusc_bake`
  on the IIcx (this wave touches `bake.cla` and `macgui.cla`); and
  `mactest/snow/clarusc_memprobe` on the IIcx, with its numbers recorded
  in umbrella §9.

## 2. Decisions settled in this spec

| #   | Decision                                                                                                                                                                                                                                                                                                                                                              |
|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| R1  | **The CLIR blob is freed progressively, in memory** (Andrew, 2026-09-28). After each section is decoded, the consumed prefix is removed from the shared buffer in place. No `readAt`, no resource streaming: Wave 4 still owns reading the runtime library without a whole-resource read.                                                                                 |
| R2  | **Two new language methods**: `xs.reserve(n)` on `list of T`, and `t.removeFirst(n)` on `text` (name: Andrew, 2026-09-28). `map.reserve` is not added; nothing needs it (YAGNI).                                                                                                                                                                                    |
| R3  | **The compact string pool keeps its contracts.** `intern(s)`, `internText(t)` and `poolGet(i)` keep their signatures and semantics (`lib.cla` l.10–42), pool indices stay dense and in insertion order, and the CLIR pool section's decoded contents are unchanged. Only the storage changes.                                                                         |
| R4  | **`MoreMasters` is ClarusC-only.** `macgui.cla` calls the catalog's `MoreMasters` (`toolbox/memory.cla`) at startup, enough for ~10k live blocks, with the count derived from the measured handle count. The runtime's own startup (`native.cla` ~l.1416–1432) is untouched, so every other program stays byte-identical. An `app` header field (like `stack:`) was considered and deferred to `docs/FUTURE.md`. |
| R5  | **The sortedmap 256-byte key blocks are out of scope.** The umbrella asked to measure first. The compiler has no `sortedmap` globals (`/usr/bin/grep -a sortedmap clarusc/*.cla` finds only the type's own plumbing), so they cost ClarusC nothing.                                                                                                                  |
| R6  | **The 68k box sizes are measured on the IIcx, not by memgate.** Memgate counts host allocation sizes, so the `_68k.cla` box change (§3.6) moves no memgate number. Its effect is recorded from the IIcx memprobe.                                                                                                                                                   |
| R7  | **`--listing` keeps today's whole-segment emit path.** The listing needs every item, comment and data text. Per-function encode (§3.4) applies to the non-listing path only, and the listing's output must stay byte-identical.                                                                                                                                   |
| R8  | **The snapshot is regenerated after the language task lands and before any compiler source uses `reserve`/`removeFirst`.** `clarusc-current` is built by the committed snapshot (`Makefile`, the `$(BR)/clarusc-current` rule), which Wave 1 learned the hard way. The wave's final regeneration comes after that.                                              |

## 3. Work

### 3.1 Language: `list.reserve(n)` and `text.removeFirst(n)`

```rust
xs.reserve(n)        // list of T
t.removeFirst(n)     // text
```

- **`reserve(n)`**: capacity becomes at least `n`, with at most one
  underlying resize; a no-op when capacity already suffices; never
  shrinks; count and contents unchanged. It mirrors `text.reserve`
  (reference l.409) and fails the same way growth does when memory is
  exhausted.
- **`removeFirst(n)`**: drops the first `n` bytes of the text in place.
  The rest moves down, `len` drops by `n`, and the handle is resized to
  the new length (capacity becomes the new length). `n` is clamped to
  `0..len`. Like `release()`/`shrink()` (Wave 1 L1), it acts on the
  shared box, so every alias sees it, and it never allocates a new
  buffer.
- **Implementation sites:** the same ones Wave 1's `.release()`/
  `.shrink()` used — checker, IR, lower, shake, both lanes, and runtime
  functions next to `rtListShrink`/`rtTextShrink`. Reuse Wave 1's
  table-driven storage-intrinsic dispatch (`irStorageRow` and friends)
  where it fits.
- **Reference:** entries next to each type's `reserve`/`shrink`.
- **Tests:** a new core case (`ReserveRemoveFirst`) that runs on both
  lanes. It covers reserve then push without regrowth, reserve smaller
  than count as a no-op, `removeFirst` at 0, in the middle, at `len`,
  and past `len` (clamped), aliasing, and append after `removeFirst`.
  The core case count moves in all five places (CLAUDE.md lists them).
  A host storage probe shows that `removeFirst` shrinks live bytes.

### 3.2 Compact string pool (`lib.cla`, `bake.cla`)

- `strPool: list of string` (256 B per entry, ~1 MB at bookmarks
  scale) becomes one `text` blob holding the strings back to back, plus
  a `list of int` of start offsets with one trailing sentinel (the
  blob's length), so string i spans `[off[i], off[i+1])`.
- `strIndex: map of int` (string → index) stays.
- `poolGet(i)` materializes a `string` from the blob. Callers that
  iterate the pool (`strPool.count`, direct `strPool[i]` reads) switch
  to a `poolCount()` accessor and `poolGet`. Audit every reader with
  `/usr/bin/grep -a -n 'strPool' clarusc/*.cla`.
- **Bake:** the CLIR pool section keeps its on-disk bytes (the
  byte-identity twins compare CLIR files). `bkReadStrPool`
  (`bake.cla` ~l.3022) decodes straight into the blob-plus-offsets
  shape, and `bkInstallPool` moves it into place (Wave 1's
  install-by-move pattern).
- **Expected:** −~0.9 MB in every phase after the first intern.

### 3.3 Bake parse: pre-size and progressive free (`bake.cla`, `drive.cla`)

- **Pre-size.** Every `bkRead*` reader that reads its count `n` before
  its elements (`bkReadIrExprs` ~l.2575 and siblings ~l.2534–2974,
  `bkReadIntList`, `bkReadStrPool`) calls `reserve(n)` on its result
  first. Expected: the doubling transient at the 16384 → 32768 step
  goes away, plus ~0.25 MB of tail slack.
- **Progressive free (R1).** `bkLoadSections` (~l.3538) reads through
  the module-level cursor `bkLoadBuf`/`bkLoadPos` (~l.1961–1964).
  - After a section ends, if the cursor is at least 64 KB past the last
    removal, call `bkLoadBuf.removeFirst(bkLoadPos)` and set
    `bkLoadPos = 0`. The 64 KB floor bounds the number of moves (each
    is a copy of the remaining tail, which matters on an 8 MHz SE) and
    still gives each big section (IR exprs, stmts, types, pool, obj
    code) its own removal.
  - Any value that is an absolute offset into the blob (a section
    table, the obj-code sections) is rebased against a running
    `bkLoadBase`, which counts the bytes removed so far. Audit before
    changing.
  - The body-hash check (~l.3783–3851) runs over the whole blob
    **before** any removal, as today.
  - `bkLoadBuf` shares its box with `rtbakeBytes` and with the front
    end's buffer (macgui's `clirBuf`; Wave 1 Task 5). `removeFirst`
    mutates that shared box, which is what we want: it is the one
    buffer being consumed. The `dblcompile_bake` harness already hands
    `driveCompile` a copy per compile, which must stay true.
  - A failed parse (a bad section or a drift) leaves a partly consumed
    buffer. The drift fallback re-runs from source and never reads the
    bytes (Wave 1 Task 4 audit), so that is safe. Re-confirm it.
- **Expected:** parse peak ≈ end-of-parse live + the largest remaining
  suffix at any moment, instead of + 1.94 MB.

### 3.4 Per-function emit → encode → discard (`cg68k.cla`)

- In `cg68ProgramFork`'s per-segment emit loop (~l.15778), after each
  function is emitted, encode its items to bytes plus holes right away.
  Use the `cgObjRuns`/`cgObjHoles` capture shape (~l.14893–14897) and
  the path `cgObjDumpSegment` (~l.15197) already takes. Then drop the
  items (`.clear()`; keep the capacity, as `cgMeasureDropItems` does).
- `a68Items` is then bounded by the largest function, not the largest
  segment.
- **Oracle:** `cgObjDumpSegment`'s byte-count assertion, the
  `testdata/cg68k/*.s` goldens, the `--rtbake` twins, and the
  identity check (Wave 1 plan, Global Constraints).
- **Not under `--listing` (R7).**
- **Check first:** anything that reads `a68Items` across functions in
  a segment (branch relaxation, relayout, the peephole, cross-function
  label fixups). Label ids and `a68Pc` stay global, as in Wave 1 §4.2.
  If a segment-wide pass exists, encode at its latest safe point
  instead, and say where in the plan.

### 3.5 Flat `cgObjRuns` (`cg68k.cla`, `bake.cla`)

- `cgObjRuns: list of text` (~4,400 handles at bookmarks scale)
  becomes one byte `text` plus a `list of int` of (offset, len) pairs.
  Update every reader: `cgObjPasteFunc` (~l.15735), the dump, and
  `bkReadObjCode` (~l.3260).
- The CLIR obj-code section's on-disk bytes are unchanged.

### 3.6 68k box sizes (`runtime/clarus/*_68k.cla`) — **output-changing**

- `_68k.cla` companions give native builds 68k-correct container box
  sizes: list 40 → 20 B, text 32 → 16 B, map 112 → 52 B, sortedmap
  56 → 28 B (`list.cla` ~l.196, `text.cla` ~l.198, `map.cla` ~l.580,
  `sortedmap.cla` ~l.208). Follow the existing `*_68k.cla` companion
  pattern (`conn_68k.cla`, `fileh_68k.cla`) and its manifest entries
  (`bake.cla` `bakeModuleList`).
- The change moves box-size immediates, so every `testdata/cg68k/*.s`
  golden, the emitui goldens and the bake twins may move. It is its own
  isolated task, with a rebless step and a written reason per golden
  family (umbrella §5.4). It is a serialization point.
- The CLAUDE.md standing rule applies: a new `_68k` runtime module gets
  its `tests/bake/<module>.sh` `emit68k_pair` twin in the same task.
- The host lane is unchanged, so memgate is unchanged (R6).

### 3.7 `MoreMasters` for ClarusC (`macgui.cla`)

- At `ClarusC.APPL` startup, before the first compile, call
  `MoreMasters` from `toolbox/memory.cla` enough times for ~10k master
  pointers (64 per call on System 6/7, so about 160 calls, ~40 KB
  nonrelocatable at the bottom of the heap).
- Derive the count from the IIcx memprobe's handle count at the low
  point, plus headroom, and write the derivation in the comment.
- Byte-identical for every program except ClarusC.APPL.

### 3.8 Peak-moment census (`scripts/memcensus.sh`, host runtime)

- Wave 1's attribution was inferred, because the census samples only at
  phase boundaries. Add a mode, `CLARUS_MEM_PEAK=3` or a
  `memcensus.sh --at-peak` switch, that snapshots the census whenever a
  new overall peak is set. The last snapshot then describes the peak
  moment.
- Wave 2 uses it for its own attribution, and so do Waves 3–4.

## 4. Output policy (umbrella §5.4)

| Change                                                                                    | Label                                                                    |
|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `reserve`/`removeFirst`                                                                   | additive: a new core-suite case only; every other golden unchanged       |
| compact pool, pre-size, progressive free, per-function encode, flat runs, `MoreMasters`   | byte-identical (compiler internals; the snapshot changes)                |
| 68k box sizes                                                                             | output-changing: isolated rebless task, a written reason per golden family |
| peak-moment census                                                                        | tooling only                                                             |
| snapshot regenerations (after §3.1, and at the end)                                       | serialization points                                                     |
| memgate budgets                                                                           | ratchet down, one commit                                                 |

## 5. Tests

- Per task: T1 (`scripts/test-task.sh`, no `--smoke`; it includes
  memgate) and the Wave 1 identity check (snapshot vs current on four
  examples: from source, `--rtbake` and C).
- Multi-compile: `mactest/dblcompile`, `dblcompile_abort` and
  `dblcompile_bake` for every task that touches `bake.cla`, `drive.cla`,
  `lib.cla` or `cg68k.cla`'s emit loop; `bake/drift_fallback` for §3.3.
- `--listing`: a listing build of `examples/bookmarks.cla` is diffed
  against the snapshot's (R7).
- End of wave: umbrella §5.3, as in §1.

## 6. Out of scope

- Reading the runtime library with `readAt` / no whole-resource read
  (Wave 4).
- Freeing `bkLdObj*`/`cgObjHoles` before the fork is built: per-function
  encode changes how runs are produced, not their lifetime.
- `map.reserve` (R2); sortedmap key blocks (R5).
- The narrow scalar types and serializer v2 (Wave 3).
- The Wave 1 TODO items not named here (the failed-compile staging while
  idle, the FieldInfo testapi gate, the enum/serdesc measure sites):
  they stay in `docs/TODO.md` unless a task touches that code anyway.
