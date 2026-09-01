# String performance on the native 68k lane — design

**Date:** 2026-09-02
**Status:** Approved (Andrew, 2026-09-01 session)
**Branch:** `string-perf`

## Motivation

A downstream project (68kbbs, running on the Snow Mac II emulator)
measured its table draws at ~200 ms/row and traced the cost to Clarus
string operations (`docs/superpowers/bench-2026-09-01-68k-strings.md`
in that repo — temporary, not committed). Three read-only code traces
plus an in-repo calibration bench (`strbench.cla`, 14 variants, run on
the Mini vMac lane 2026-09-01) replaced that doc's guessed model with a
measured one:

| Variant | Cost (net of loop baseline) | Mechanism |
|---|---|---|
| bare call (`nop`/int return) | 1.5–2.2 µs | call machinery is cheap |
| string round trip (`echo80`/`echo7`) | ~204/~297 µs | **flat, length-independent** — one full-capacity `_BlockMoveData` via `rtStrStore` |
| +1 `string` local (`mklocal`) | 824 µs | 256-byte `CLR.W`/`DBRA` zero loop per local per call |
| 4 `string` locals, 3 unused (`mklocal4`) | 2.20 ms | zero-init scales with local count |
| 1 `string(7)` local (`mk7`) | 346 µs | zero-init scales with declared capacity |
| `s[i]` | ~71 µs/index | out-of-line call to `rtStrIndex` (~30 instructions of overhead, no traps) |
| `t.append(char)` warm | ~29 µs/char | call overhead; growth traps only at doubling boundaries |
| `t.append(string)` warm | ~0.75 µs/byte | one grow check + one `_BlockMoveData` |
| text birth+death | 258 µs | NewHandle/Dispose pair |

Key corrections to the downstream doc's hypotheses, established by the
traces (subagent reports, 2026-09-01 session):

- `string` (Str255/KStr) is a pure value type on 68k. There are **no**
  Memory Manager traps and **no** per-character copy loop on the
  return path: `return s` is one call to `rtStrStore`
  (`runtime/clarus/str.cla:50`), which does a single `_BlockMoveData`
  trap. The doc's suggested fixes #1/#2 target machinery that does not
  exist.
- The dominant flat per-call cost is `cgEmitFunc`'s unconditional
  default-init of every declared local (`clarusc/cg68k.cla:5177-5213`):
  a `KStr` local with no explicit default runs `cgDefaultInitStrAt` →
  `cgZeroBlockAtA0(cgSizeOf(t))` (`cg68k.cla:3345-3364, 3406-3412`) —
  for a plain `string`, a 128-iteration `CLR.W (A0)+`/`DBRA` loop on
  **every call**, proven in the `testdata/cg68k/strs.s` golden
  (`LINK A6,#-2452` / `MOVE.W #127,D0` / `CLR.W (A0)+` / `DBRA`).
  Unused locals pay exactly the same as used ones, and every callee in
  a helper chain pays for its own locals.
- `s[i]` lowers to the `IStrIndex` intrinsic (`clarusc/lower.cla:2239`)
  which cg68k emits as an out-of-line `BSR` to `rtStrIndex`
  (`cg68k.cla:8323-8324`) — full LINK/UNLK frame, the string pointer
  derived twice (once for the bounds check's length fetch, once for
  the byte fetch), booleans materialized via the generic
  `SLT`/`ANDI`/`TST` idiom. The runtime's own loops (`rtStrCmp`,
  `str.cla:157-190`) hand-avoid all of this with the inline `peekb`
  intrinsic and a hoisted length.
- `text.append(char)` per-call work is small; the 30–40× per-byte gap
  vs. bulk append is trap count: `rtTextGrow`
  (`runtime/clarus/text.cla:159-183`) fires a real `_SetHandleSize`
  trap at each doubling boundary, ~6 times filling 0→128 per-char vs.
  exactly once in bulk. The growth policy itself (amortized doubling)
  is correct.

## Scope (approved option A)

Five items, each independently landable, each justified by a measured
number. Deeper codegen work (record-local init elision, concat/return
inlining, loop-invariant hoisting of `&s`) is explicitly out of scope —
those costs measured an order of magnitude below the items here; record
them in `docs/TODO.md` at close-out.

### 1. String-local default-init: length byte only (cg68k)

For a `KStr` local with **no explicit initializer**, `cgEmitFunc`'s
entry init emits a single byte clear of the length byte (`CLR.B` at the
local's address) instead of `cgZeroBlockAtA0` over the full declared
capacity. The language's zero value for `string` is the empty string,
which is fully represented by `len = 0`; bytes past `len` are never
semantically visible.

- Locals **with** explicit defaults keep their current path unchanged.
- Record and array locals keep their current full-capacity init
  (out of scope).
- Host/C lane untouched (its init cost is a host-speed memset;
  observable behavior — empty string — is identical on both lanes).
- **Gated on the Task-1 probe (§4a).** If the probe finds any consumer
  that assumes a zeroed tail beyond `len`, this item is reshaped (fix
  the consumer, or keep full zeroing for the affected shape) before
  implementation proceeds.

Expected effect: `mklocal` ~824 µs → approximately bare-call cost;
`mklocal4` collapses proportionally; every string-returning helper
chain in user code gets each frame's init cost back.

### 2. Inline `IStrIndex` / `IStrLen` (cg68k)

Replace the out-of-line `cgIntr2(rnStrIndex)` / `cgIntr1(rnStrLen)`
calls (`cg68k.cla:8319-8324`) with inline emission modeled on
`cgIntrPeek` (`cg68k.cla:6710-6722`):

- `IStrLen`: materialize `&s` in an address register, `CLR.L Dn` +
  `MOVE.B (An),Dn` — 2–3 instructions.
- `IStrIndex`: materialize `&s` once; load the length byte; one
  unsigned `CMP`+`Bcc` bounds check covering both `i < 0` and
  `i >= len` where possible; indexed `MOVE.B` for the fetch; the
  out-of-range path branches to the existing panic machinery with the
  **same message** (`"string index out of range"`) and identical panic
  semantics. No trap, no LINK/UNLK, no double pointer derivation.

`rtStrIndex`/`rtStrLen` remain in `str.cla` (host lane still uses
them; tree-shake drops them from native builds when unreferenced).
Bounds-check behavior is pinned by tests, not just goldens.

Expected effect: `s[i]` ~71 µs → ~10 µs class; downstream per-char
scanners (trackOutput-shaped code) improve proportionally.

### 3. `text.clear()` and `text.reserve(n)` (runtime + frontend + docs)

Both are pure Clarus additions in `runtime/clarus/text.cla`, so both
lanes get them from the same source:

- `clear()`: sets `rt.len = 0`. Capacity and handle untouched — **no
  traps**. On an already-empty or fresh text it is a no-op. This makes
  a reused per-line/per-draw buffer free to reset (the
  `clear()` + warm-buffer idiom removes both birth/death traps and
  growth traps from hot loops).
- `reserve(n)`: public wrapper over the existing `rtTextGrow(t, n)`.
  No-op when current capacity already ≥ n; never shrinks; panics
  `"out of memory"` on allocation failure exactly like implicit
  growth. For producers that genuinely must append per-byte (e.g.
  `conn.cla`'s per-byte path).

Plumbing follows the existing text-method shape end to end:
`check.cla` method typing, `lower.cla` lowering (same pattern as
`ITextAppendChar` — direct runtime-call intrinsics, no new codegen
work in cg68k beyond the intrinsic table entries), and
`docs/clarus-language-reference.md` entries for both methods
(reference is normative; wording pins the no-trap/no-shrink
semantics above).

### 4. Verification

a. **Zeroed-tail probe (first task, can veto §1):** a read-only sweep
   of the runtime and codegen for any consumer that reads `string`
   bytes beyond `len` — full-capacity block compares for equality,
   whole-buffer hashing (map keys!), record copies that later expose
   the tail, `--testapi`/checksum paths. The traces saw only
   len-bounded access (`rtStrCmp`, `rtStrStore`), but §1 lands only
   after this is proven. Written up in the plan as its own task with
   an explicit verdict.
b. **Calibration bench promoted:** `strbench.cla` moves from the
   session scratchpad into `testdata/bench/`, wired like
   `parsebench.cla` (a `TestStrBench68k` in
   `internal/mactest/bench_test.go`, gated `CLARUS_BENCH68K=1`, a
   measurement instrument — never a timing gate). Re-run before/after:
   expected `mklocal` → ~call cost, `strindex` → ~10 µs class,
   `echo*`/`concat` unchanged, `appendchar_warm` unchanged.
c. **Goldens:** affected `testdata/cg68k/*.s` goldens reblessed;
   diffs reviewed to show exactly the two expected shapes (zero loops
   → `CLR.B`; `rtStrIndex`/`rtStrLen` calls → inline sequences) and
   nothing else.
d. **Suite cases:** new `core` suite case pinning `clear()`/
   `reserve()` semantics (clear keeps capacity — append after clear
   must not re-trap when within prior capacity, observable via
   FreeMem-flatness on the toolbox side; reserve is a no-op when
   satisfied; both no-ops on fresh text) and an empty-string-local
   behavior pin (a function whose string local is read before
   assignment yields ""). Toolbox `LeakCheck` must stay FreeMem-flat.
e. **Gates:** T1 (`--smoke`) per task; full T2 before merge.

### 5. Rollout

- Feature branch `string-perf` off main (`061dbd5`).
- Subagent-driven implementation per convention (sonnet
  implementation/review; opus available for hard debugging); the
  top-level session designs, dispatches, reviews, integrates.
- Merge only on request; main stays green.
- Downstream: 68kbbs re-pins its toolchain and re-measures with its
  own bench on Snow **after** merge — informative, not a gate here.

## Out of scope (recorded for TODO.md at close-out)

- Record-local default-init elision (records containing string fields
  still full-zero their frames).
- Inlining the concat/`rtStrStore` paths; length-proportional (rather
  than capacity-sized) return copies.
- Loop-invariant hoisting of `&s`/length across repeated indexing —
  a real optimizer feature, not a patch.
- Any change to `text` growth policy (measured correct).
- The cprint/OnMac `TbFreeMem` shim gap (pre-existing, tracked in
  `docs/TODO.md`).
