# CLIR load performance (A+B+C) — design

**Date:** 2026-08-15
**Status:** approved-pending-review
**Motivation session:** Snow field data 2026-08-14 (screenshot, Log window
timestamps) + emulator probe 2026-08-15.

## 1. Problem

On ClarusC.APPL (Snow, Mac II, 12MB-partition run, 2026-08-14), the
stretch between "Verifying Baked Runtime" and driveCompile's "Starting"
line took **10m 2s** for a 1,255,314-byte CLIR (v6, 68k lane). The
resource read itself ("Loading Baked Runtime") took ~1s, and the arena
install ("Loading runtime" → "Installed baked runtime") 2s. Everything
else is the load protocol.

That window contains **three full passes over the 1.3MB buffer**:

1. Body-hash verify #1 — `gcResolveBakePath` (macgui.cla) calls
   `bkCheckRtbakeHeader`, whose `bkHashTextFrom` walks every byte.
2. Body-hash verify #2 — `driveCompile`'s `if haveRtbake` block
   (drive.cla:1782) calls `bkLoadRtbake`, which re-runs
   `bkCheckRtbakeHeader` on the exact buffer verified seconds earlier.
3. Full section parse — `bkLoadSections`, every byte through
   `bkGetByte()` (a Clarus function call + bounds check + global-cursor
   update per byte; `bkGetU32` costs five calls; `bkGetBytes` adds a
   `t.append` call per byte).

And this repeats on **every** compile in an app session, though the
resource physically cannot change between compiles.

### Probe evidence (2026-08-15, Mini vMac / Mac Plus, 64KB, guest ticks)

| loop shape | µs/byte |
|---|---|
| bare `buf[i]` + XOR, hoisted length | 119 |
| bare `buf[i]` + XOR, `.length` in condition | 144 |
| exact `bkHashTextFrom` body (FNV mul included) | 154 |
| `bkGetByte()`-style walk | 201 |
| `t.append` per byte | 182 |

Two conclusions. First, **the FNV multiply is irrelevant at current
loop shape** — mul variants (×16777619, ×3, none) were within
measurement noise of each other; `cg_mul32` is swamped. Second, the
floor is **per-iteration runtime-call overhead**: every `buf[i]` is a
full `rtTextIndex` call (frame, bounds check, handle deref, return),
and a `.length` in the loop condition is another call (hoisting it
alone saved 17%). Three passes × 1.3MB at these rates reproduces the
observed window; no Memory Manager mystery remains.

### Where the bytes are (real v6 CLIR, 68k lane)

| section | bytes | share |
|---|---|---|
| IrExprs | 655,592 | 52.2% |
| ObjCode | 149,035 | 11.9% |
| CheckerSymbols | 145,764 | 11.6% |
| IrStmts | 141,992 | 11.3% |
| IrTypes | 40,388 | 3.2% |
| StrPool | 28,900 | 2.3% |
| IrLocals | 28,656 | 2.3% |
| everything else | ~64,987 | ~5.2% |

~70% is U32-record arrays, ~12% raw byte blob, ~14% length-prefixed
strings — all bulk-readable shapes.

## 2. Goals / non-goals

**Goals:**
- First-compile load window (verify + parse): ~600s → target ≤60s,
  stretch ≤30s, on Snow-class hardware (measured, not promised).
- Repeat compiles in the same app session: skip verify and parse
  entirely (~2s install only).
- Integrity coverage unchanged in kind: whole body still hashed before
  any parse; parse keeps its overrun soft-fail.
- Host lane behavior identical in outcome (host is already fast; it
  simply inherits the same code paths).

**Non-goals (explicitly deferred, YAGNI until measured otherwise):**
- Load-in-place / memory-image CLIR format.
- Lazy per-section parsing.
- `ser.cla` (`file.save`/`file.load`) adoption of the new bulk reads.
- A hand-emitted asm hash helper (à la `cg_mul32`).

## 3. Design A — drop the redundant verify

New module-global in bake.cla: `bkHeaderVerified: bool` (default
false). `gcResolveBakePath` (macgui.cla) sets it true immediately after
its successful `bkCheckRtbakeHeader`. `bkLoadRtbake` consumes it: if
set, skip its internal `bkCheckRtbakeHeader` call (and reset the flag —
consume-once, so a stale value can never bless a different buffer).

- Host path unchanged: nothing on the host ever sets the flag, so the
  host's single verify (inside `bkLoadRtbake`) still runs.
- `driveReset()` gets a defensive `bkHeaderVerified = false`, following
  the established stale-state-reset pattern (drive.cla:515–550).
- No signature changes; `bkLoadRtbake(buf, wantLane)` keeps its shape.

Saves one full hash pass (~3 min today; ~seconds after C — still
correct to remove).

## 4. Design B — parse once per app session

**Fact found during design:** `bkInstallArenas` (bake.cla:3759) installs
most pending lists by **reference assignment** (`irExprs = bkLdIrExprs`
etc. — `text`/`list`/`map` are reference types, reference §196), and
the compile then appends user IR to those live arenas. Today that
aliasing is masked because every compile re-parses the pending state
from bytes. Memoizing the parse makes it a live corruption: compile #1
would pollute the pending lists through the alias and compile #2 would
install runtime arenas with compile #1's user IR appended.

**Mechanism:**

- New bake.cla global `bkParsedValid: bool` (default false). At
  drive.cla:1782, `bkLoadRtbake` is skipped when `bkParsedValid` is
  already true; on a successful `bkLoadRtbake` it is set true. It is
  set false on any parse failure and by the manifest-drift from-source
  fallback path (which already resets bake state — same place
  `bkLdObjValid` is reset). It is NOT reset by `driveReset()` — its
  whole purpose is to survive across compiles.
- **Copy-on-install:** every reference-assigned arena in
  `bkInstallArenas` switches to a fresh-list copy (`while` + `.add`
  loop, the exact shape the existing `truncFuncs` truncation already
  uses at bake.cla:3775–3788). `record` elements are value types
  (reference §194), so `.add` copies them — the pending lists stay
  pristine by construction, and in-place mutation of live-arena entries
  during a compile can never reach the pending state.
  `irFuncIdxByName` is already rebuilt fresh; the intmap/map-valued
  pending sections that are only consulted (never extended) may stay
  aliased **only if** an audit task proves no live mutation — default
  is copy.
- **Audit task (plan):** the void-returning readers
  (`bkReadIrScalars`, `bkReadLowCounters`, `bkReadCheckerSymbols`,
  `bkReadFieldInfo`, `bkReadCheckerVisibility`, `bkReadUitestBounds`,
  `bkReadManifestHashes`, `bkReadObjCode`/`bkReadObjMeta`) must be
  confirmed to populate **pending (`bkLd*`) state only**, never live
  compiler state, so a memoized parse replays correctly through
  install alone. Any live write found gets moved to install.
- **Front-end skip:** `gcResolveBakePath` (macgui.cla) early-returns
  when `bkParsedValid` is true — setting `haveRtbake = true` (drive's
  `if haveRtbake` install gate still needs arming every compile) and
  returning the "bake path" verdict string, without the resource read,
  the header check, or touching `rtbakeBytes`. Host front end needs no
  change (one compile per process).
- **Memory:** after the first successful parse, macgui frees the raw
  buffer (`rtbakeBytes = ""`) — today the 1.3MB buffer is held for the
  whole session *and* re-read every compile, so B is net-neutral or
  better on partition budget while retaining the parsed pending state.
  `bkLoadRtbake` is only ever reached with `bkParsedValid` false, so
  the freed buffer is never re-read. (drive.cla:1782's gate becomes
  `if haveRtbake and not bkParsedValid`.)
- `testapi` variation is already handled per-install (the
  `bkLdBaseIrFuncsCount` truncation runs at install time from pending
  state), so a session mixing `--testapi` and plain compiles stays
  correct.
- Manifest-drift detection (v5 per-include hash checks) runs inside
  `driveCompile`'s expand() per compile, off pending
  `bkManifestHashes` + on-disk reads — unaffected by memoization; the
  fallback path resets `bkParsedValid` as above so a drifted session
  re-parses if the bake becomes usable again.
- Existing leak/growth gates must stay green: per-compile heap growth
  stays 0 (the copies are freed by the next `driveReset`; the retained
  pending state is a one-time, first-compile allocation).

**Recorded alternative (not chosen):** truncate-on-reuse — keep
aliasing and cut live lists back to their baked boundary counts before
each re-install. Cheaper per compile (no copy) but requires a list
truncation primitive plus a proof that no pass mutates prefix entries
in place; revisit only if copy-on-install's measured cost is
unacceptable (it is bounded by the existing 2s install's same-shape
loops).

## 5. Design C — bulk `text` range reads + cheap hash (CLIR v7)

### 5.1 New Chapter-3 `text` methods

Four **stateless range reads** (no reader object, no hidden cursor —
callers advance their own position; `stringAt`'s consumed length is
recoverable from the result):

| method | semantics |
|---|---|
| `t.hashStep(h, pos, n): int` | rolling body-hash step over `n` bytes starting at `pos`, returns updated `h` |
| `t.u32At(pos): int` | big-endian U32 at `pos` (landed as `intAt` — renamed before merge; one signed int type, so the u32 name misdescribed the return) |
| `t.stringAt(pos): string` | 4-byte BE length prefix + bytes at `pos`; caller advances `4 + result.length` |
| `t.textAt(pos, n): text` | fresh `text` holding bytes `[pos, pos+n)` |

Contracts: STRICT out-of-range panic, same as `t[i]`
(`rtTextIndex`'s documented convention) — a read that would run past
`t.length` panics; `stringAt` additionally panics if the decoded length
exceeds 255 (`string` cap). These are general-purpose binary-format
reads (public, documented in the reference), not compiler-private —
e.g. the deferred PBM-parser fix and any user file-format reader can
use them.

Names collide with nothing in `buildMethodTables` (check.cla:1433 —
existing text surface is `fromBytes`/`toBytes`/`indexOf`/`append`).
All four are `textOnlyMethods` entries.

### 5.2 Runtime implementations (runtime/clarus/text.cla)

Each hoists `rt.len` and the master pointer once, then walks
`peekb(mp + i)` — the same pattern `rtTextCompare` already uses; the
per-byte JSR/bounds/deref tax becomes per-call. `rtTextTextAt`
allocates its result **first**, then re-derives the source master
pointer before the copy (text.cla's documented relocation discipline),
and uses `TextBlockMoveData` for the body — the 149KB ObjCode blob
becomes one Memory Manager copy. New functions: `rtTextHashStep`,
`rtTextU32At`, `rtTextStrAt`, `rtTextTextAt`.

Compiler plumbing follows the existing text-intrinsic route end to
end: check.cla method-table entries → lower.cla lowering to new
intrinsics → cprint.cla arms (→ `clar_fn_rtText*`, `cpTextPorted`
convention) and cg68k.cla arms (→ `rtText*` calls, `rnTextIndex`
precedent). Reference: Chapter 3 text-operations section gains the
four entries.

### 5.3 Hash function swap (why now, not before)

Today the multiply is noise (probe). Inside a tight per-call loop it
would become the dominant term (`cg_mul32` ≈ 3×MULU + JSR per byte).
So the body hash switches from FNV-mul to the shift-add djb2 step:

    h = ((h << 5) + h + b) & 0x7FFFFFFF

`bkHashText`/`bkHashTextFrom` change in place — seed stays 5381
(already djb2's constant), mask stays 31-bit (the existing
signed-overflow discipline). Every user changes together and stays
symmetric by construction: the body hash (writer `bakeWriteFile` +
both loaders), the clarusc.c stamp (host-computed; the same `--bake-ir`
run writes the sidecar `feExpectedStamp` reads on Mac), and the v5
per-module manifest hashes (written at bake, re-checked from the same
function). `rtTextHashStep` implements this same step; `bkHashTextFrom`
remains as the host-independent reference implementation and the
cold-path fallback for non-hot callers.

**`bkFormatVersion` 6 → 7.** Byte layout is unchanged; the version
bump exists because the `bodyHash`/stamp/manifest values' meaning
changed. Routine mechanics: regenerate the bake + stamp, snapshot
regen, `TestSnapshotFixedPoint`, golden churn expected ~zero
(behavior-level goldens).

### 5.4 Load-path rewrites (bake.cla)

- `bkCheckRtbakeHeader`: the body-hash walk becomes a ~32KB-chunk loop
  over `t.hashStep`, calling `driveProgressTick()` between chunks — the
  attempt-abort Task 7 liveness pulse survives with per-chunk (not
  per-byte) cost.
- `bkGetU32` body becomes `bkLoadBuf.u32At(bkLoadPos)` + cursor
  advance, behind the existing overrun guard: pre-check
  `bkLoadPos + 4 <= bkLoadBuf.length`, else set `bkLoadOverrun` and
  return 0 (soft-fail preserved; the STRICT method panic is never
  reached on the load path).
- `bkGetStr` → `stringAt` + advance, same pre-check shape (soft-fail,
  including the >255 case: overrun, not panic).
- `bkGetBytes` → `textAt` + advance, same pre-check shape.
- `bkGetByte`/`bkGetU16`/`bkGetStrShort` stay as-is (cold: header
  fields, section ids, 18 module keys).

The reads stay byte-compatible with v6's layout — only call shapes
change.

## 6. Interactions and ordering

A, B, C are independently correct and independently landable; the plan
should land **A first** (smallest), then **C** (format bump + new
surface), then **B** (its win is largest while parse is slow, but its
correctness work — copy-on-install + audits — is the delicate part and
deserves C's simpler world). With all three: first compile ≈ one
chunked hash pass + one bulk parse; repeat compiles ≈ install only.

## 7. Testing

- **T1 throughout**; snapshot fixed-point regen at the phase's own
  cadence (`TestSnapshotFixedPoint` prints the procedure).
- **New core-suite cases** (host + native lanes) for the four methods:
  known-answer values, bounds panics, `stringAt` >255 refusal, empty
  ranges, `textAt` zero-length, and a hashStep-vs-reference-loop
  equivalence case.
- **Format v7:** existing refusal tests (corrupt/truncated/stale-stamp/
  lane-mismatch) re-blessed against v7; drift-fallback test
  (`TestRtbakeDriftFallback`) unchanged in meaning.
- **B-specific:** a two-compile-one-process test proving compile #2
  (a) skips parse (log line absent), (b) produces byte-identical
  output to a fresh-process compile of the same file, (c) holds the
  zero-growth heap property (existing leak-gate pattern). Plus the
  pending-state audit tasks (§4).
- **Perf acceptance (measured, not asserted in CI):** extend this
  session's throwaway `hashprobe` shapes with the new intrinsics for a
  before/after emulator table; one emulator ClarusC.APPL bake-path
  compile with Log timestamps for the window; Snow field confirmation
  is Andrew's call.
- **Standing rules fire:** `TestClarusCBakePathOnSnow` re-run
  (bake.cla + macgui.cla change; 20m settle procedure per STATUS §0a),
  and `TestMacResidentFailedCompileStaysAliveOnSnow` for the
  failed-compile alert path. `internal/selfhost` with
  `-count=1 -timeout 30m` at merge gate (T2).

## 8. Risks

- **`.add` copy semantics carry the whole of B's safety** — records
  copy by value (reference §194). Any future arena that stores a
  reference-typed element (`text`/list/map inside a record) would
  shallow-copy; the audit task must flag any such field in the copied
  arenas (today's IR records are int-field-only; verify).
- **Chunk boundary bugs in the hash rewrite** silently change the hash
  → refused bake → silent CLFS fallback (slow but correct). The
  hashStep-equivalence test plus the existing bake-path Snow gate
  cover this; the fallback's own log line makes it visible.
- **New method panics on the load path** would replace soft-fail
  refusal with a crash — the pre-check discipline in §5.4 is the
  guard, and the refusal tests exercise it.
- **cg68k/cprint arm mistakes** surface as lane divergence — the
  core-suite cases run on both lanes by construction.
