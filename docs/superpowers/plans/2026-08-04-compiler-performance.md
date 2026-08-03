# Compiler-Performance Phase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `DisposePtr`'s O(n) block-record scan in the host-only
paranoid memory shim with an O(1) pointer-keyed hash index, collapsing the
measured 30x clarusc emit slowdown (7-11s → ≤0.8s on `every.cla`; 631s →
~1.5s on self-emission), then re-baseline the perf tripwire.

**Architecture:** `internal/build/rt/rt_mem_host.inc` keeps its
never-freed all-blocks ledger (`rt_mem_blocks`) untouched — leak report,
`CLARUS_MEM_STRICT`, quarantine, guards, scramble all unchanged. A new
open-addressing hash table keyed on the payload address `b->p` (is_ptr
blocks only; Handles already recover their record by direct cast) gives
`DisposePtr` O(1) lookup. Entries are never removed (mirrors the ledger,
preserves double-dispose detection); a recycled payload address replaces
the dead record's entry, matching the old scan's newest-first semantics.
Chosen over the spec's Experiment-3 embedded-header scheme because it
changes zero allocation layout and never reads memory the shim doesn't
own — a foreign pointer is a clean table miss → the existing
"unrecognized pointer" `abort()`, not an unchecked read through garbage
(the spec's own flagged risk with the header scheme).

**Tech Stack:** C (C89-style as the file already is, plus `<stdint.h>`
for `uintptr_t`), the existing standalone `rt_mem_test.c` harness, Go
test lanes for verification only.

## Global Constraints

- Spec: `docs/superpowers/specs/2026-08-03-compiler-performance-design.md`.
- HOST-ONLY change: only `internal/build/rt/rt_mem_host.inc` (+ its test
  `rt_mem_test.c`) may change. No Mac runtime, no `clarusc/*.cla`, no
  snapshot (`clarusc/clarusc.c`) changes.
- Do NOT touch `rt_mem_blocks`, the leak-report path, `rt_mem_note_`,
  `rt_mem_tag_of`, or the quarantine — only the is_ptr lookup path.
- Diagnostics must be preserved verbatim: `"rt_mem: DisposePtr of
  unrecognized pointer\n"` abort on a never-allocated pointer;
  `"rt_mem: double dispose at %s (allocated %s)\n"` abort on a second
  dispose.
- Success target (spec): `clarusc emit` of `testdata/emitui/every.cla`
  under 0.8s (3x of Go-built's ~0.26s), byte-identical `.c` output.
- Branch: `compiler-perf` off `main`. Merge only on Andrew's request.
- Working style: match the file's existing comment idiom (including
  `ponytail:` markers for deliberate ceilings).

## File Structure

- Modify: `internal/build/rt/rt_mem_host.inc` — add the pointer index
  (~70 lines), swap `DisposePtr`'s scan for a lookup, hook inserts into
  `rt_mem_alloc_block`.
- Modify: `internal/build/rt/rt_mem_test.c` — add churn test + two
  abort-diagnostic child modes.
- Modify: `internal/perfgate/baseline.txt` — re-baseline after the fix.
- Modify: `docs/ROADMAP.md` — phase outcome entry.
- Modify: `docs/superpowers/specs/2026-08-03-compiler-performance-design.md`
  — outcome addendum.

---

### Task 1: O(1) DisposePtr pointer index + regression tests

**Files:**
- Modify: `internal/build/rt/rt_mem_host.inc`
- Modify: `internal/build/rt/rt_mem_test.c`

**Interfaces:**
- Consumes: existing `rt_mem_block` record, `rt_mem_alloc_block`,
  `DisposePtr` (all in `rt_mem_host.inc`).
- Produces: `static void rt_mem_ptr_index_insert(rt_mem_block *nb)`,
  `static rt_mem_block *rt_mem_ptr_index_find(Ptr p)` — internal to the
  `.inc`; no external interface changes at all. Task 2 relies only on the
  behavior (fast `DisposePtr`).

- [ ] **Step 1: Branch, and capture the pre-fix reference (timing + bytes)**

```bash
cd /Users/andrew/repos/clarus
git checkout -b compiler-perf
SCRATCH=/private/tmp/claude-501/-Users-andrew-repos-clarus/a189c7ea-6db6-4828-afbd-ecc3cea322dd/scratchpad
mkdir -p "$SCRATCH/perf"
cc -O1 -I internal/build/rt -o "$SCRATCH/perf/clarusc_prefix" clarusc/clarusc.c internal/build/rt/rt.c
time "$SCRATCH/perf/clarusc_prefix" emit --rtdir runtime/clarus/ -o "$SCRATCH/perf/every_prefix.c" testdata/emitui/every.cla
```

Expected: wall time in the 7-11s range (the bug being fixed). Keep
`every_prefix.c` — Step 7 diffs against it. Record the time for the
final report.

- [ ] **Step 2: Add the regression tests to `rt_mem_test.c`**

These PASS against today's O(n) implementation — they are regression
guards pinning the semantics the index must preserve (the "failing test"
for this task is the Step 1 timing, re-measured in Step 7). Add after
`test_blockmove`:

```c
/* 9: bulk Ptr churn -- exercises DisposePtr block-record recovery across
   index growth, probe collisions, and recycled payload addresses (the
   quarantine caps at 64 blocks / 1 MiB, so a mass dispose forces real
   free()s and near-certain address reuse by later NewPtr calls). */
static void test_ptr_churn(void)
{
    enum { CHURN_N = 5000 };
    static Ptr ps[CHURN_N];
    int i;
    long before;

    before = rt_mem_live_count();
    for (i = 0; i < CHURN_N; i++) {
        ps[i] = NewPtr(32);
        CHECK(ps[i] != NULL, "churn NewPtr non-NULL");
        ps[i][0] = (char)(i & 0x7F);
    }
    /* dispose evens first, then odds, so recovery sees interleaved holes */
    for (i = 0; i < CHURN_N; i += 2) DisposePtr(ps[i]);
    for (i = 1; i < CHURN_N; i += 2) {
        CHECK(ps[i][0] == (char)(i & 0x7F), "odd survivor intact after even mass-dispose");
        DisposePtr(ps[i]);
    }
    CHECK(rt_mem_live_count() == before, "all churn blocks disposed");
    /* fresh Ptrs after the mass dispose recycle freed payload addresses:
       dispose must resolve each to its NEW (live) record, not a dead one */
    for (i = 0; i < 128; i++) {
        Ptr q;

        q = NewPtr(32);
        CHECK(q != NULL, "recycle NewPtr non-NULL");
        q[0] = 'q';
        DisposePtr(q);
    }
    CHECK(rt_mem_live_count() == before, "recycled-address dispose resolved to the live record");
}
```

Add two abort-expecting child modes and a parent helper (same re-exec
pattern as the existing `paranoid` child; the children must die, so the
parent checks for a NONZERO exit and silences the child's stderr):

```c
/* 10 + 11: the two DisposePtr diagnostics must still abort (the paranoid
   shim's whole reason to exist). Run in re-exec'd children, parent
   expects nonzero exit. */
static void expect_child_abort(const char *argv0, const char *mode)
{
    char cmd[1024];
    int rc;

    if (argv0[0] == '/') {
        snprintf(cmd, sizeof cmd, "%s %s 2>/dev/null", argv0, mode);
    } else {
        snprintf(cmd, sizeof cmd, "./%s %s 2>/dev/null", argv0, mode);
    }
    rc = system(cmd);
    if (rc == 0) {
        fprintf(stderr, "FAIL: %s child exited 0, expected abort\n", mode);
        failed = 1;
    }
}
```

In `main`, extend the child-mode dispatch (keep the existing `paranoid`
branch; note the children `return 0` on falling through — reaching that
line means the abort DIDN'T fire, which the parent counts as failure):

```c
    if (argc > 1 && strcmp(argv[1], "doubledispose") == 0) {
        Ptr p;

        p = NewPtr(8);
        DisposePtr(p);
        DisposePtr(p); /* must abort: double dispose */
        return 0;
    }
    if (argc > 1 && strcmp(argv[1], "unrecognized") == 0) {
        char stackbuf[8];

        DisposePtr((Ptr)stackbuf); /* must abort: never allocated */
        return 0;
    }
```

And in the parent's test sequence, after `test_blockmove();`:

```c
    test_ptr_churn();
    expect_child_abort(argv[0], "doubledispose");
    expect_child_abort(argv[0], "unrecognized");
```

- [ ] **Step 3: Run the harness standalone — must PASS pre-fix**

```bash
cd "$SCRATCH/perf"
cc -I /Users/andrew/repos/clarus/internal/build/rt -o memtest /Users/andrew/repos/clarus/internal/build/rt/rt_mem_test.c
./memtest
```

Expected: `OK` (exit 0). These tests pin current semantics; if any CHECK
fails here, the test is wrong — fix the test, not the shim.

- [ ] **Step 4: Implement the pointer index in `rt_mem_host.inc`**

Add `#include <stdint.h>` alongside the existing includes. Insert the
index after the `rt_mem_blocks`/`rt_mem_err` statics block (before
`rt_mem_fill_guards`):

```c
/* Ptr-identity index (compiler-performance phase, 2026-08-04):
   DisposePtr used to recover the owning rt_mem_block by linear-scanning
   rt_mem_blocks -- a ledger that keeps every record forever -- making
   teardown of bootstrap-scale runs effectively O(allocations^2): a
   measured 30x emit-time slowdown, 97%+ of samples inside DisposePtr
   (docs/superpowers/specs/2026-08-03-compiler-performance-design.md).
   Open-addressing, linear-probe hash table keyed on the payload address
   b->p, is_ptr blocks only (a Handle recovers its record by direct cast
   from the Handle itself). Entries are never removed, mirroring the
   ledger and keeping double-dispose detection: a dead block's entry
   still resolves, and DisposePtr's existing b->live check fires. When
   malloc recycles a freed payload address, insert REPLACES the dead
   record's entry -- the same answer the old newest-first list scan gave.
   The ledger itself is untouched (leak report / CLARUS_MEM_STRICT). */
static rt_mem_block **rt_mem_ptr_index = NULL;
static size_t rt_mem_ptr_index_cap = 0; /* always 0 or a power of two */
static size_t rt_mem_ptr_index_count = 0;

static void rt_mem_ptr_index_insert(rt_mem_block *nb);

static size_t rt_mem_ptr_hash(Ptr p, size_t cap)
{
    /* Fibonacci multiplicative hash; low bits of a malloc'd address are
       alignment zeros, the multiply spreads them. cap is a power of two. */
    return (size_t)(((uintptr_t)p * (uintptr_t)0x9E3779B97F4A7C15ULL) & (uintptr_t)(cap - 1));
}

static void rt_mem_ptr_index_grow(void)
{
    rt_mem_block **old;
    size_t oldcap;
    size_t i;

    old = rt_mem_ptr_index;
    oldcap = rt_mem_ptr_index_cap;
    rt_mem_ptr_index_cap = (oldcap == 0) ? 1024 : oldcap * 2;
    rt_mem_ptr_index = calloc(rt_mem_ptr_index_cap, sizeof(rt_mem_block *));
    if (rt_mem_ptr_index == NULL) {
        /* ponytail: the shim's other allocation failures surface as
           memFullErr, but a half-grown index would corrupt lookups; the
           paranoid shim aborts loudly instead. */
        fprintf(stderr, "rt_mem: out of memory growing ptr index\n");
        abort();
    }
    rt_mem_ptr_index_count = 0;
    for (i = 0; i < oldcap; i++) {
        if (old[i] != NULL) rt_mem_ptr_index_insert(old[i]);
    }
    free(old);
}

static void rt_mem_ptr_index_insert(rt_mem_block *nb)
{
    size_t i;

    if (rt_mem_ptr_index_count * 4 >= rt_mem_ptr_index_cap * 3) {
        rt_mem_ptr_index_grow();
    }
    i = rt_mem_ptr_hash(nb->p, rt_mem_ptr_index_cap);
    while (rt_mem_ptr_index[i] != NULL) {
        if (rt_mem_ptr_index[i]->p == nb->p) {
            /* Recycled payload address. The displaced record is
               necessarily dead (a live is_ptr block's raw is never
               freed, so malloc cannot hand its address out again). */
            rt_mem_ptr_index[i] = nb;
            return;
        }
        i = (i + 1) & (rt_mem_ptr_index_cap - 1);
    }
    rt_mem_ptr_index[i] = nb;
    rt_mem_ptr_index_count++;
}

static rt_mem_block *rt_mem_ptr_index_find(Ptr p)
{
    size_t i;

    if (rt_mem_ptr_index_cap == 0) return NULL;
    i = rt_mem_ptr_hash(p, rt_mem_ptr_index_cap);
    while (rt_mem_ptr_index[i] != NULL) {
        if (rt_mem_ptr_index[i]->p == p) return rt_mem_ptr_index[i];
        i = (i + 1) & (rt_mem_ptr_index_cap - 1);
    }
    return NULL;
}
```

Hook insertion into `rt_mem_alloc_block` — after the two lines
`b->next = rt_mem_blocks; rt_mem_blocks = b;` add:

```c
    if (is_ptr) rt_mem_ptr_index_insert(b);
```

Replace `DisposePtr`'s scan (the `for` loop and the `b == NULL` check
keep the exact same abort message) so the function body reads:

```c
void DisposePtr(Ptr p)
{
    rt_mem_block *b;
    unsigned char *raw;

    if (p == NULL) return;
    b = rt_mem_ptr_index_find(p);
    if (b == NULL) {
        fprintf(stderr, "rt_mem: DisposePtr of unrecognized pointer\n");
        abort();
    }
    if (!b->live) {
        fprintf(stderr, "rt_mem: double dispose at %s (allocated %s)\n", b->tag, b->tag);
        abort();
    }
    rt_mem_check_guards(b);
    raw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    rt_mem_retire_raw(raw, b->size);
    /* ponytail: unlike a Handle (whose identity is the stable address of
       b->p itself, unaffected by nulling that field), a bare Ptr's only
       identity IS the payload value -- nulling b->p here would destroy the
       one way to find this record again on a second dispose. Leave b->p
       as-is and rely on b->live for double-dispose detection instead. */
    b->live = 0;
    rt_mem_err = noErr;
}
```

Why the index stays valid: a live is_ptr block's `p` never changes —
`rt_mem_relocate` and `rt_mem_set_handle_size` both operate only on
Handle blocks (`is_ptr` filtered out / API takes a Handle), so is_ptr
payload addresses are stable from `NewPtr` to `DisposePtr`.

- [ ] **Step 5: Re-run the standalone harness — must PASS post-fix**

```bash
cd "$SCRATCH/perf"
cc -I /Users/andrew/repos/clarus/internal/build/rt -o memtest /Users/andrew/repos/clarus/internal/build/rt/rt_mem_test.c
./memtest
```

Expected: `OK` (exit 0). All pre-existing tests plus churn plus both
abort children green.

- [ ] **Step 6: Run the Go-side rt C-runtime lanes**

```bash
cd /Users/andrew/repos/clarus
go test -count=1 ./internal/build
```

Expected: PASS — `memtest_c`, `rctest_c`, `sertest_c`, `rtsmoke` all
compile the on-disk rt against `cc` (the Go-compiler tests in this
package self-skip without `CLARUS_GO_DIFF=1`; that's normal).

- [ ] **Step 7: Verify the fix: byte-identical output, target timing**

```bash
cc -O1 -I internal/build/rt -o "$SCRATCH/perf/clarusc_fixed" clarusc/clarusc.c internal/build/rt/rt.c
time "$SCRATCH/perf/clarusc_fixed" emit --rtdir runtime/clarus/ -o "$SCRATCH/perf/every_fixed.c" testdata/emitui/every.cla
cmp "$SCRATCH/perf/every_prefix.c" "$SCRATCH/perf/every_fixed.c" && echo BYTE-IDENTICAL
```

Expected: `BYTE-IDENTICAL`, and wall time ≤ 0.8s (spec target; scratch
Experiment 3 hit ~0.26-0.57s). Run the `time` line 3 times and note the
median. If over 0.8s, STOP and investigate before committing — do not
rationalize a miss.

- [ ] **Step 8: Commit**

```bash
git add internal/build/rt/rt_mem_host.inc internal/build/rt/rt_mem_test.c
git commit -m "perf: O(1) DisposePtr via ptr-keyed index in host mem shim

every.cla emit: <pre-fix time>s -> <post-fix median>s (byte-identical
output). Spec: docs/superpowers/specs/2026-08-03-compiler-performance-design.md"
```

(Fill the real measured numbers into the message.)

---

### Task 2: Re-baseline the perf tripwire, full verification, docs

**Files:**
- Modify: `internal/perfgate/baseline.txt`
- Modify: `docs/ROADMAP.md`
- Modify: `docs/superpowers/specs/2026-08-03-compiler-performance-design.md`

**Interfaces:**
- Consumes: Task 1's fixed `rt_mem_host.inc` (already committed on the
  branch).
- Produces: nothing downstream — this closes the phase.

- [ ] **Step 1: Measure the new tripwire median**

```bash
cd /Users/andrew/repos/clarus
go test -count=1 -v -run TestEmitPerfTripwire ./internal/perfgate
```

Expected: PASS (the fix only makes it faster). Copy the logged
`median: X.XXXs` value.

- [ ] **Step 2: Re-baseline `internal/perfgate/baseline.txt`**

Replace the file's contents with (substituting the measured median,
rounded UP to one decimal so run-to-run noise on a loaded machine doesn't
trip the 2x gate — e.g. median 0.31s → `0.4`):

```
# seconds; median clarusc emit of testdata/emitui/every.cla; 2026-08-04
# re-baselined after the O(1) DisposePtr fix (compiler-perf phase) --
# ROADMAP's re-baseline note: without this drop the 2x tripwire would
# have stayed armed at the old 7.6s and been silently toothless.
0.4
```

- [ ] **Step 3: Re-run the tripwire against the new baseline**

```bash
go test -count=1 -v -run TestEmitPerfTripwire ./internal/perfgate
```

Expected: PASS with the new, ~20x-smaller limit.

- [ ] **Step 4: Re-time self-emission for the record**

```bash
SCRATCH=/private/tmp/claude-501/-Users-andrew-repos-clarus/a189c7ea-6db6-4828-afbd-ecc3cea322dd/scratchpad
time "$SCRATCH/perf/clarusc_fixed" emit --rtdir runtime/clarus/ -o "$SCRATCH/perf/self.c" clarusc/main.cla
```

Expected: ~1.5s (vs the recorded 631.43s pre-fix). Note the number for
the docs and final report. (If `clarusc_fixed` is gone, rebuild it:
`cc -O1 -I internal/build/rt -o "$SCRATCH/perf/clarusc_fixed"
clarusc/clarusc.c internal/build/rt/rt.c`.)

- [ ] **Step 5: T1 gate**

```bash
scripts/test-task.sh
```

Expected: PASS. (The perfgate package is part of the sweep and now runs
against the new baseline.)

- [ ] **Step 6: Go-free selfhost lanes (behavior goldens + crossgen + snapshot self-consistency)**

```bash
go test -count=1 -timeout 30m ./internal/selfhost
```

Expected: PASS — `TestBehavior*` (including the `.leaks` paranoid-
allocator pin, which exercises the leak-report path the fix must not
disturb), `TestCrossGen*`, `TestSnapshotBuilds`, `TestSnapshotFixedPoint`
run by default; the 14 Go-differential lanes SKIP (no `CLARUS_GO_DIFF`).
This is the byte-level proof the runtime change altered no emitted
output.

- [ ] **Step 7: Update ROADMAP and spec with the outcome**

In `docs/ROADMAP.md`, replace the "Compiler-performance phase (after
Toolbox integration, before 5f):" paragraph body (keep the heading
sentence shape) with a DONE entry recording: date, the fix shape
(ptr-keyed hash index in `rt_mem_host.inc`, ledger untouched), measured
numbers (every.cla pre → post, self-emission pre → post, from Tasks 1/2),
byte-identical proof (cmp + selfhost lanes), and that
`internal/perfgate/baseline.txt` was re-baselined per the roadmap's own
re-baseline note (7.6 → new value). Also note the phase ran BEFORE the
Toolbox integration phase by Andrew's direction (2026-08-04), amending
the "after Toolbox integration" sequencing. In the test-suite-review
section (~line 1115), the "**re-baseline note:**" sentence gets a
parenthetical "(done, compiler-perf phase, 2026-08-04)".

In `docs/superpowers/specs/2026-08-03-compiler-performance-design.md`,
append an `## Outcome (2026-08-04)` section: hash-table candidate chosen
(and the one-line why: no layout change, no reads of unowned memory,
diagnostics preserved as clean table-miss aborts), measured results, plan
pointer (`docs/superpowers/plans/2026-08-04-compiler-performance.md`).

- [ ] **Step 8: Commit**

```bash
git add internal/perfgate/baseline.txt docs/ROADMAP.md docs/superpowers/specs/2026-08-03-compiler-performance-design.md docs/superpowers/plans/2026-08-04-compiler-performance.md
git commit -m "perf: re-baseline emit tripwire post-DisposePtr fix; phase docs"
```

---

## Self-Review (done at plan time)

- Spec coverage: fix direction (candidate chosen: hash table — the spec
  explicitly leaves the call to the plan), unrecognized-pointer
  diagnostic preserved (Task 1 Steps 2/4, abort child test), double-
  dispose wording preserved (same), `CLARUS_MEM_STRICT`/leak path
  untouched (constraint + `.leaks` pin in Task 2 Step 6), success target
  re-verified for real (Task 1 Step 7), self-emission + tripwire
  re-timed/re-baselined (Task 2 Steps 1-4), non-goals respected (no
  Mac-side change, no volume-gap investigation, no `rt_mem_blocks`
  change).
- Placeholders: none — all code verbatim, all commands exact.
- Type consistency: `rt_mem_ptr_index_insert(rt_mem_block *)` /
  `rt_mem_ptr_index_find(Ptr)` names match across Task 1's steps; Task 2
  touches no code.
