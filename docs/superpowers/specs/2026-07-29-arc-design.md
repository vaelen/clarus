# Automatic Reference Counting (ARC) — Design

Date: 2026-07-29. Status: approved and implemented (brainstorm w/
Andrew; Task 9 close-out 2026-07-29 — see `docs/ROADMAP.md` Done item
11).
Branch: `arc`. Builds on the 4e memory audit
(`2026-07-28-memory-audit-design.md`), merged 2026-07-29.

## Goals

1. **Every heap value reclaimed when its last reference dies.** All 18
   nonzero `.leaks` goldens go to zero; the leak-by-design classes 4e had
   to document (user-call results, element-read containers, reassignment
   orphans, record fields, disqualified window vars) cease to exist.
2. **Delete the escape-analysis apparatus.** ARC's rules are local
   (retain on reference copy, release on reference death); no
   whole-program qualification, no freshness proofs, no default-deny
   walker. ~1000 lines of `lower.cla` pre-pass machinery go away.
3. **Keep 4e's governing invariant** during and after the migration:
   leaks acceptable and documented, use-after-free/double-free never.

## Non-goals

- **Elision.** Naive ARC first — retain/release at every site — then
  measure real apps (Bookmarks, Text Editor) on the 68k emulator and
  record numbers in the ROADMAP. Balanced-pair elision is a follow-up
  only if measurement demands it (decided 2026-07-29). **Disposition
  (Task 9):** measured — Bookmarks 9.09s pre-ARC → 9.21s post-ARC
  (+0.12s, ~1.3%), Text Editor 3.98s pre-ARC → 3.97s post-ARC (no
  measurable change), both deltas within run-to-run noise on Mini vMac
  and neither subjectively perceptible. Trigger not met; elision stays
  an unscheduled conditional follow-on (`docs/ROADMAP.md`).
- **Language changes.** ARC is unobservable: the language has no
  destructors or finalizers, reference semantics (Ch3) are untouched, and
  the language reference does not change.
- **Go compiler changes.** Counts are invisible in program output;
  differential parity and the bootstrap chain hold as in 4e.
- **Window refs.** Toolbox windows keep the teardown lifecycle; ARC
  covers exactly `text`, `list of T`, `map of T`.

## Why refcounting is sound AND complete here

Clarus has no recursive types: a container's element type can never
reach the container's own type, so the ownership graph is a DAG. No
cycles → no cycle collector, no weak references, no leaks ARC cannot
see. This is the property that makes ARC a complete solution rather
than an approximation.

## Architecture

### Runtime: the counted box

Each `rt_text`/`rt_list`/`rt_map` box (the non-relocatable `NewPtr`
struct from 4e) gains `int32_t rc` as its FIRST field, initialized to 1
at construction. New public API (rt.h, implemented once in rt_core.inc,
shared by both runtimes):

```c
void rt_text_retain(rt_text *t);   /* ++rc; NULL-safe */
void rt_text_release(rt_text *t);  /* --rc; at 0, dispose (data handle + box); NULL-safe */
/* same pairs for rt_list / rt_map */
```

The 4e `rt_text_free`/`rt_list_free`/`rt_map_free` become the internal
rc==0 disposal path; generated code stops calling them directly. During
the migration each `*_free` is redefined as an alias for `*_release`, so
partially-migrated states stay sound (a "free" of a value someone else
retained merely decrements).

Under the host shim, a release-to-zero disposes through the existing
ledger (double-dispose detection, scramble) — over-release crashes
loudly in tests, under-release fails the exact-match leak gate. An
`rc <= 0` retain or release aborts host-side with the box's allocation
tag (ledger-integrated assert; compiled out on the Mac).

### Deep release: compiler-generated, runtime stays dumb

Releasing a container to zero must release its elements. The runtime
does not know element types; clarusc generates per-type release helpers
(the 4e `cpEmitFree` machinery, upgraded): a `list of text` release loop
releases each element handle, then the container. Recursion over nested
containers/records terminates (no recursive types). Records with handle
fields get `clar_retain_REC` / `clar_release_REC` walk helpers,
generated exactly like `clar_new_REC` ctors; records with only by-value
fields (every serializable record) generate nothing.

### Counting rules — all local, no analysis

| Event | Emitted operations |
|---|---|
| Construction (`rt_*_new`, concat, string→text coercion) | born at +1, owned by the receiving slot |
| Assignment `a = b` (heap-typed) | retain new value FIRST, then release `a`'s old value (self-assign safe) |
| Container store (push/unshift/map-set/index-write) | retain the stored handle; an overwritten element handle is released |
| Container removal (pop/shift → out-param) | ownership transfers; no net count change |
| Container removal (remove/clear) | release removed element handles (emitted loop for clear) |
| Parameter pass (text/list/map) | nothing — the caller's reference outlives the call (caller-guarantees convention) |
| `return expr` (heap-typed) | +1 transfer: callee retains the returned reference; the caller owns the result and releases it when its use ends |
| Expression temporaries | born at +1 in the printer (Task-6 machinery); released at end of statement — stores/returns of a temp retain elsewhere, so the temp's own release balances |
| Scope exit (every heap-typed local, unconditionally) | release |
| Globals at exit/quit | `cl_free_globals` becomes an unconditional release-walk |
| Window vars at close | `clar_ui_release_<Win>` becomes an unconditional release-walk |
| `quit` mid-handler | locals released before the quit (safe now: release, not free); global cleanup runs via the existing hook |

The +1-return convention closes 4e's permanent leak class (call results):
`if f(x) == "y"` receives at +1, compares, releases — safe even when `f`
returns an alias of a live global, because the alias was retained.
Likewise the six alias-returning intrinsics (pop/shift/first/last/
map-get×2): first/last/get retain what they return (+1 like user calls);
pop/shift transfer.

### Records — the expensive part, enumerated

A record is a by-value C struct; copying one duplicates its handle
fields without the count knowing. Every record copy site retain-walks
the copy; every record death release-walks it:

1. record assignment (`r1 = r2`): retain-walk source copy, release-walk
   the overwritten destination first (same retain-then-release order)
2. record parameter: callee retain-walks its copy at entry,
   release-walks at exit (all exit paths)
3. record return: +1 transfer (retain-walk in callee; caller owns)
4. record container elements: store retain-walks, removal release-walks,
   `rt_list_at` in-place access is a borrow (no copy, no count)
5. record locals: release-walk at scope exit
6. window state defaults / form buffers: the form `edit` flat copy
   retain-walks in; writeback release-walks the replaced handles;
   cancel releases the buffer's copies
7. fixed arrays of records: per-element walks, mirroring `cpDefaultInit`

A missed copy site is an under-count (premature free → UAF). Mitigation:
copies funnel through few lowering points (`lowStoreStmt`,
`lowCallArgs`, `lowReturn`, container methods, the form walker), and the
paranoid corpus turns a miss into a crash in CI, not corruption on a Mac.

### Insertion architecture (decided)

Hybrid, formalizing the 4e split:
- **`lower.cla`** inserts `IRetain`/`IRelease` IR intrinsics for every
  NAMED slot: assignments, container ops, params/returns, scope exits,
  globals, window vars, record walks. Lifetime is visible in the IR.
- **`cprint.cla`** keeps the Task-6 statement-temp tracker, upgraded
  from free-at-end-of-statement to release-at-end-of-statement; call
  results become tracked temps (they are +1 now, so releasing them is
  finally correct — deleting the fpCallFn documented-leak carve-out).

### What gets deleted

- `lowEscapeWalk*`, `lowRunWinVarEscapePrepass`,
  `lowRunGlobalsEscapePrepass`, `lowGlobalsVarQualifies`,
  `lowEscapeFreshInit`, `lowEscapeContainerElemRisky`, and every
  disqualification consult — the whole 4e escape apparatus.
- Task 6's handoff exclusion list where it existed to prevent unsound
  frees (retains make those sites sound); what remains of the tracker is
  purely "which temp names die at statement end."
- The 18 nonzero `.leaks` golden files (absent = 0 stays the default;
  the ratchet mechanism itself remains as the regression gate).

## Migration soundness (one branch, staged by slot class)

Implementation proceeds class-by-class (temps/call-results → locals →
container elements → globals/window vars → records), and EVERY
intermediate state preserves the no-UAF invariant:

- `*_free` = `*_release` from the first runtime task, so legacy frees
  merely decrement.
- A slot class not yet migrated keeps its 4e qualification (it only
  releases values it provably solely owns — rc is exactly 1, release
  disposes, identical behavior).
- A migrated class retains everything it stores, so an unmigrated
  class's qualified release can never expose a migrated reference.
- `.leaks` goldens are updated per task (counts fall monotonically) and
  hit zero at the end; the exact-match gate polices every intermediate
  state.

## Verification

- **Unit:** rc semantics in `rt_mem_test.c`-style C tests (retain/
  release/zero-dispose/NULL-safety/abort-on-negative, host-side).
- **Corpus:** the 4e strict+paranoid leak gate, goldens driven to zero;
  p1–p9 adversarial fixtures flip from documented-leak to zero-leak
  proofs. New fixtures: self-assignment, record copy chains,
  return-of-global-alias, element overwrite, pop transfer, clear with
  handle elements, form-edit cancel.
- **Bootstrap:** clarusc compiling itself runs fully counted — the
  strongest stress test; fixed point must hold; snapshot regen expected
  to be large.
- **Mac:** DONE (Task 9) — full gated suite (`TestSuiteOnMac`,
  `TestRunErrOnMac`, `TestAbortAppsOnMac`, all 23 UI scenarios)
  byte-identical (counts are unobservable); the Bookmarks + Text Editor
  timing measurement was taken and recorded in the ROADMAP (Done item
  11) as the elision-decision baseline — see the Non-goals disposition
  above.

## Risks

- **Missed record-copy site → premature free.** The enumerated site
  list above is the review checklist; paranoid corpus + bootstrap catch
  misses as crashes.
- **Emitted-C growth** from retain/release traffic — measured at
  snapshot regen; naive-first accepted by decision.
- **68k performance** — measured, not guessed; elision is the recorded
  escape hatch.
- **Box size change** (+4 bytes) on the Mac heap — nothing serializes
  or sizeof-depends on boxes externally; harmless.

## Follow-ons (recorded, not scheduled)

- Retain/release elision (balanced-pair removal): measured (Task 9), not
  triggered — see the Non-goals disposition above. Stays unscheduled
  unless a future measurement shows real degradation.
- Host UI layer: unaffected; ARC lives below the Memory Manager seam's
  consumers.
- `form for` handle-backed-record checker gap and discard-tracking
  generality (pop/shift are the only intrinsics that consult the
  discard-release machinery): found during Task 9 close-out, not ARC
  regressions — ledgered in `docs/ROADMAP.md`'s Small open items.
