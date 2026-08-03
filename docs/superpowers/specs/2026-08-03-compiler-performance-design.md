# Compiler-performance phase — design

Date: 2026-08-03. Follow-up to the test-suite-review phase's Task 7
attribution (`.superpowers/sdd/2026-08-03-test-suite-review/task-7-report.md`
has the full profile tables and experiment log; this doc is the scoped fix
spec). Slotted before 5f, after the Toolbox integration phase (ROADMAP,
"Decided sequencing 2026-08-03").

## The finding (measured 2026-08-03, ATTRIBUTED not fixed by this doc)

The 30x is NOT ARC retain/release call volume, NOT `clar_str_255` by-value
copies, and NOT container (list/map) access patterns — the three suspects
the test-suite-review phase named going in (confirmed below: measured
`rt_text`/`rt_list`/`rt_map` retain/release call counts are literally
ZERO for this workload on both lanes). It is a single mechanical bug in
the HOST-ONLY paranoid memory shim, `internal/build/rt/rt_mem_host.inc`:
`DisposePtr(Ptr p)` recovers the owning `rt_mem_block` record by linear-
scanning `rt_mem_blocks`, a list that holds every allocation the process
has EVER made (dead records are deliberately kept forever, "to catch
double-dispose" per the file's own comment — a freed slot is never
reused). Every Ptr-backed allocation pays this scan on dispose — for this
workload that's almost entirely `text.cla`'s own manual scratch-buffer
allocator (`rt_ext_TextNewPtr`/`rt_ext_TextDisposePtr`, used by
`rtTextConcat`/`rtTextConcatSl` for string building), called directly by
Clarus runtime-library source, NOT the compiler-inserted automatic
`rt_text_retain`/`rt_text_release` ARC wrapper pair (see "Why the Go lane
escapes" below).

**Evidence chain** (3 runs each; scratch dir, not committed — reproducible
from this spec's numbers plus the report's exact patches):

1. **Repro**: `clarusc emit --rtdir runtime/clarus/ -o OUT.c
   testdata/emitui/every.cla` — snapshot-built clarusc 7.18-10.72s vs a
   Go-built clarusc (same `clarusc/main.cla` source, Go frontend's own C
   emission instead of clarusc's self-hosted emission, both cc'd)
   0.26-0.64s. ~30x, byte-identical `.c` output both ways.
2. **Profile** (`sample`, 1ms, 3 runs): 97.3-98.1% of top-of-stack samples
   land in `DisposePtr`, and essentially 100% of those are reached via
   `rt_quit -> cl_free_globals` — i.e. almost the ENTIRE 9-11s is
   teardown (disposing global compiler state at process exit), not
   steady-state compilation work.
3. **Diagnostic instrumentation** (call/scan counters added to a scratch
   runtime copy, same `every.cla` workload): 321,489 `DisposePtr` calls,
   621,952,785 total list-node visits (avg scan depth 1934.6), 393,514
   total `is_ptr`-block allocations, peak concurrent live-block count
   83,378. The allocation VOLUME (393K) is not itself expensive — at
   normal malloc/free cost that's tens of milliseconds — the scan
   algorithm bolted onto it is what turns it into seconds.
4. **Experiment 1** (scratch patch: dispose from a live-only intrusive
   list, splicing on release, instead of the full historical list): 9-11s
   -> 2.5-2.9s (~3.6x recovered). `DisposePtr` still 89% of profile
   share — the live set itself still peaks at 83K, so O(live) is still
   too slow at this scale.
5. **Experiment 3** (scratch patch: O(1) recovery — stash a
   `rt_mem_block*` self-pointer in an 8-byte header immediately before
   each Ptr allocation's guard region; `DisposePtr` reads it directly, no
   scan at all): 0.26-0.57s on `every.cla` — matches the Go-built
   reference. Also re-run on self-emission of `clarusc/main.cla` (54,539
   output lines): 1.52s vs the Go-built reference's 1.47s, again parity.
   The unpatched snapshot compiler's self-emission was ALSO timed live on
   this machine for a direct before/after on the same workload: **631.43s
   -> 1.52s, a 415x speedup**. All three builds' `.c` output is
   byte-identical on both workloads — the O(1) header trick changes only
   lookup cost, not semantics.

**Attribution**: >=95% of the 30x collapses from fixing ONE function's
algorithmic complexity. The other named suspects were not confirmed
material at this workload scale; they may still be worth a smaller look
once the dominant term is gone (non-goal below).

### Why the Go lane escapes (measured, not assumed)

Both lanes link the IDENTICAL `rt_mem_host.inc` — the Go-built binary does
not structurally avoid the O(n) `DisposePtr` bug, it just triggers far
less of it. Call/scan counters (same technique as the diagnostic
instrumentation above, added temporarily to the real tree's
`rt_mem_host.inc`/`rt_core.inc`, reverted before commit) on the
`every.cla` workload, one run each:

| counter | clarusc-snap | clarusc-goc | ratio |
|---|---|---|---|
| `rt_text_retain`/`release`, `rt_list_*`, `rt_map_*` calls | 0 / 0 / 0 / 0 / 0 / 0 | 0 / 0 / 0 / 0 / 0 / 0 | — |
| `is_ptr` allocations (`NewPtr`) | 393,514 | 241,777 | 1.63x |
| `DisposePtr` calls | 321,489 | 65,391 | **4.92x** |

Two findings, one confirming and one correcting the phase's going-in
suspicion:

- **Corrected**: the automatic ARC wrapper functions (`rt_text_retain`/
  `rt_text_release`/etc., the compiler-inserted retain/release pair the
  test-suite-review phase suspected) are called ZERO times by either
  lane on this workload. The Ptr churn driving `DisposePtr` is
  `text.cla`'s own manual scratch-buffer allocator (string-concatenation
  primitives calling `NewPtr`/`DisposePtr` directly, bypassing the RC
  wrapper) — the SAME Clarus runtime library, linked into both lanes.
  "Naive ARC counted stores" was not the mechanism; it was misdiagnosed
  going in.
- **Confirmed, with a correction to WHY**: the Go lane does see
  meaningfully less Ptr churn — 1.63x fewer allocations, and, more
  tellingly, 4.92x fewer `DisposePtr` calls (it disposes only ~27% of
  what it allocates within the timed process vs. clarusc-snap's ~82%,
  i.e. clarusc-snap's C emission is the MORE eagerly-freeing of the two,
  ironically the "more correct" memory behavior). This volume gap is
  real but **not the 30x driver**: Experiment 3 fixes ONLY the scan
  algorithm, leaves clarusc-snap's higher allocation/dispose volume
  completely unchanged, and STILL collapses the gap to Go-built parity.
  A volume difference that would itself explain at most a small
  constant-factor gap (malloc/free of ~150K extra pointer pairs is tens
  of milliseconds, not seconds) is not what produced 9-11s vs 0.26s —
  the O(n) scan is. The volume gap between the two C emitters may be
  worth a smaller follow-up look (why does clarusc's self-hosted emitter
  materialize ~1.6x more scratch-buffer temporaries for equivalent
  Clarus source?), but it is out of THIS phase's scope (non-goals,
  below).

## Standing timing inputs (context for scoping, measured 2026-08-03)

- Single UI-fixture emit (`testdata/emitui/every.cla`): 8-9s snapshot-
  built vs 0.27s Go-built (original finding); this task's own runs:
  7.18-10.72s vs 0.26-0.64s.
- `clarusc` self-emission (`clarusc/main.cla`, its own ~10-module source):
  ~500-600s with the snapshot compiler unpatched.
- `TestCrossGenDifferential` (current-gen bootstrap): ~8min.
- Full Go-lane selfhost: 1525s; Go-free: 1029s.
- Self-emission, unpatched snapshot compiler, measured live on this
  machine: 631.43s. Experiment-3's O(1) DisposePtr patch on the same
  workload, same machine: 1.52s (415x). Full detail in the report.

## Fix direction (decided: scope for the follow-up phase's plan)

Replace `DisposePtr`'s block-record recovery with an O(1) or O(log n)
scheme. Candidates (plan's call, not decided here):

- **Embedded self-pointer header** (what Experiment 3 does): simplest,
  proven correct on two workloads in this phase's scratch testing, but a
  scratch hack — needs a real review pass before landing:
  - guard-byte layout interaction, `rt_mem_retire_raw`'s scramble-length
    precision since the header sits before the front guard;
  - `CLARUS_MEM_STRICT` leak-report interaction;
  - double-dispose error message wording changed under the header scheme
    since an already-disposed block's header still resolves — must
    re-check `b->live` after recovery, which Experiment 3 already does;
  - **unrecognized-pointer diagnostic preserved under O(1) recovery**:
    Experiment 3's `DisposePtr` dereferences 8 bytes immediately before
    ANY pointer it's handed and trusts what it finds there as a
    `rt_mem_block*` — for a bad/foreign pointer (one never returned by
    `NewPtr`) that's an unchecked read through garbage, not the shim's
    current clean `abort()` with "DisposePtr of unrecognized pointer"
    (`rt_mem_host.inc:353-356` today). This is exactly the class of bug
    the shim exists to catch, so a real fix must NOT regress it: validate
    before trusting the header (e.g. a magic tag byte/word written
    alongside the self-pointer, checked before dereferencing further) and
    fall back to a clean `abort()` — or, for a pointer that fails the
    magic check, the old O(n) scan as a slow-but-safe diagnostic path —
    rather than trusting arbitrary memory.
- **Hash table keyed by pointer** instead of a header: avoids touching the
  allocation layout at all; more code, same asymptotic win.
- Do NOT touch `rt_mem_blocks` (the full historical list) — it backs the
  leak report and is orthogonal to this fix; only the is_ptr lookup path
  needs to change.

Whichever scheme: this is HOST-ONLY code (`rt_mem_host.inc`, gated out of
Mac builds) — zero risk to the frozen Mac-target runtime or any committed
snapshot bytes. It changes internal bookkeeping only; `clarusc.c`'s and
`clarusc/*.cla`'s emitted output is provably unaffected (byte-identical in
both experiments here).

## Measured success target

Emit of `testdata/emitui/every.cla` within 3x of Go-built time (i.e. under
~0.8s, against today's 7-11s). Experiment 3 already hit ~1x in scratch
testing, so 3x is a conservative floor, not a stretch goal — the plan
should re-verify it holds once the fix lands for real (not just in a
scratch header hack) and re-time self-emission and the perf tripwire
baseline (test-suite-review phase, T1) against the fixed compiler.

## Non-goals

- Landing the fix itself — this doc scopes it; a plan + SDD tasks do the
  work.
- Re-attributing ARC retain/release traffic, `clar_str_255` copies, or
  container-access cost — not confirmed material here; revisit only if
  the DisposePtr fix lands and a residual gap remains beyond the 3x
  target.
- Any change to Mac-target runtime code (`rt_mac.c` / the 68k-emitted
  runtime) — this finding and fix are host-only (`rt_mem_host.inc`, the
  cprint/snapshot-bootstrap pipeline's memory shim). Implication worth
  stating plainly: because the bug is host-only, it never threatened 5f's
  Mac-resident compiler in the first place — 5f's own memory management
  (the real Toolbox Memory Manager, `rt_mac.c`) never went through this
  shim or its O(n) scan; this phase is entirely about host build/test
  wall-clock, not about de-risking 5f.
- Touching `rt_mem_blocks` or the leak-report/`CLARUS_MEM_STRICT` path
  beyond what the is_ptr lookup change requires.
- Re-running the full historical-scan-vs-live-list Experiment 1 as a
  candidate fix — Experiment 3's O(1) result supersedes it; kept in the
  report only as an intermediate data point.
