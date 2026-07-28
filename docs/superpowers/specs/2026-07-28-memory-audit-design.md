# Memory-Management Audit (4e) — Design

Date: 2026-07-28. Status: approved (brainstorm w/ Andrew).
Branch: `memory-audit-4e`.

## Goals

1. **One memory model, no forks.** Classic Mac Handle semantics are the
   native truth; the host conforms via a shim. Delete the duplicated
   text/list/map implementations (`rt.c` vs `rt_mac.c` are near-identical
   peer ports today).
2. **A dispose story.** `rt.h` currently has zero free functions; nothing
   heap-backed is ever freed on either runtime. Add one, and use it.
3. **Enforcement, not a one-time sweep.** A ledger in the host shim plus a
   strict-mode exit check makes any future leak a test failure, and doubles
   as the per-site leak-by-design documentation the roadmap asked for.
4. **Don't block a future host UI layer.** `rt_ui.c` already speaks the
   Memory Manager API natively; the shim is that same API, so a host UI
   just links the same shim later.

## Non-goals

- Full ARC (automatic reference counting). Explicitly a **follow-on
  milestone** on this foundation: Clarus has no recursive types, so
  refcounting is cycle-free and complete, and frees are unobservable in
  program output so the frozen Go compiler never needs to change. 4e ships
  the dispose API and conservative frees; ARC ships the smarter lowering.
- Changing language semantics. Ch3 reference semantics for text/list/map
  (assignment copies the handle) stay exactly as specified.
- Any Go compiler change. Its emitted programs simply never free; the leak
  gate applies to the clarusc-emitted lane only.

## Architecture

### rt_mem.h — the shim boundary IS the Memory Manager

New header `internal/build/rt/rt_mem.h` declaring the Toolbox Memory
Manager subset the runtime uses: `Handle`, `Ptr`, `Size`, `OSErr`/`noErr`/
`memFullErr`, `NewHandle`/`NewHandleClear`, `SetHandleSize`,
`GetHandleSize`, `HLock`/`HUnlock`, `DisposeHandle`, `NewPtr`/
`NewPtrClear`/`DisposePtr`, `MemError`, `BlockMoveData` (argument order
`(src, dst, count)`; host maps to `memmove(dst, src, count)`).

- **Mac build:** `#include <Memory.h>` — the real Toolbox. No wrapper, no
  indirection, no fork.
- **Host build:** declares the same names, implemented by
  `rt_mem_host.inc`.

Platform select: the Mac build defines nothing special today; the host
side is selected by the absence of Retro68's m68k macros
(`#if defined(__m68k__) || defined(macintosh)` → Toolbox, else shim).

### rt_mem_host.inc — the paranoid host Memory Manager

`#include`d into `rt.c` (NOT a separate `.c`: the documented one-line
bootstrap `cc -I internal/build/rt -o clarusc clarusc/clarusc.c
internal/build/rt/rt.c` must keep working unchanged).

- Real double indirection: a master-pointer table; `*h` changes when a
  block relocates.
- **Paranoia (stricter than a real Mac):** relocation-on-resize is
  unconditional — `SetHandleSize` always moves the block, even without
  paranoia enabled. The full every-allocation-moves-everything sweep
  (`NewHandle`, `NewPtr`, `SetHandleSize` each relocating every other
  unlocked handle block) is opt-in via `CLARUS_MEM_PARANOID=1`, enabled
  by the corpus test lanes but not by bootstrap-scale runs — clarusc
  compiling itself under an O(live-blocks)-per-allocation allocator would
  be quadratic. Any code that caches a dereferenced master pointer across
  an allocating call breaks on host, under paranoia — not on a Mac Plus.
  (`rt_mac.c`'s collections were written disciplined — fresh `*h` after
  every allocating call — and the shim now proves that property forever.)
- Moved-from and disposed memory scrambled with `0xA5` (the MacsBug heap
  scramble value). Guard bytes before/after every block, checked on
  resize and dispose; violation panics with the block's allocation tag.
- `HLock`ed blocks never move. `MemError()` reports per the real API.
- **The ledger:** every live block records an allocation tag
  (`__FILE__:__LINE__`, captured by host-only macros over the alloc
  calls). `rt_mem_note(h, "why")` marks a block leak-by-design (no-op
  macro on Mac). With env `CLARUS_MEM_STRICT=1`, an exit hook (atexit)
  first runs the registered cleanup (below), then reports every live
  un-noted block via `CLARUS_MEM_REPORT` (or stderr if unset) as a
  `##CLARUS-MEM## live=<N>` line plus one `rt_mem: leak <tag> (<size>
  bytes)` line per block. The process's exit code is unaffected — the
  harness (`checkMemReport` in the Go test suite) compares the report
  file's live count against each fixture's `.leaks` golden instead of
  relying on a distinct exit code.

### rt_core.inc — the single value-type implementation

The Handle-based str255/text/list/map code currently in `rt_mac.c`
(rt_mac.c:469-1090) moves to `internal/build/rt/rt_core.inc`, shared by
both runtimes exactly as `rt_ser.inc` already is. `rt.c`'s malloc
versions are deleted. Two changes while moving:

1. **The struct box becomes `NewPtr`** (small, fixed-size,
   non-relocatable, disposable via `DisposePtr`), replacing
   `rt_mac_new_struct`'s forever-locked Handle whose master pointer was
   discarded — the structural bug that made dispose impossible
   (rt_mac.c:493-500).
2. **Dispose functions added** (see API below).

After the move: `rt.c` = shim + host-specific (files/args/alert/log/
panic/quit) + `rt_core.inc` + `rt_ser.inc`; `rt_mac.c` = Toolbox-specific
(dialogs/files/init) + the same two includes. Pure byte-logic str255
helpers are also deduplicated into `rt_core.inc` (they were ports with
identical observable semantics; the move must preserve the Mac side's
`BlockMoveData` via the shim mapping).

## Dispose API (rt.h additions, implemented once in rt_core.inc)

```c
void rt_text_free(rt_text *t);   /* DisposeHandle(data) + DisposePtr(box) */
void rt_list_free(rt_list *l);
void rt_map_free(rt_map *m);     /* both handles + box */
void rt_register_cleanup(void (*fn)(void)); /* at-exit/quit hook, one slot */
```

- Frees are **shallow**. The runtime stays dumb about element types: for
  `list of text`, clarusc emits the element-freeing loop (it knows the
  types; same philosophy as the generated `rt_layout_desc` tables).
- `rt_register_cleanup(fn)`: emitted main registers the generated
  `cl_free_globals()`. Runs on normal termination AND on `quit` (both
  platforms; on host also before the strict-mode ledger check).
- NULL-safe: freeing NULL is a no-op; double-free is caught host-side by
  the scramble/ledger.

## clarusc lowering (the only compiler change)

1. **Expression temporaries:** a `text` temp created inside a statement
   (concat chains, string→text conversions at call sites) is freed at end
   of statement. The compiler just created it — provably sole reference.
2. **Non-escaping locals:** a local `text`/`list`/`map` is freed on every
   scope-exit path (block end, early `return`) **only if it never
   escapes**. Escape = assigned to any other variable/global/window
   var/field; stored into a container; returned; bound in a form; passed
   to a **user** function (a callee can capture the reference — verified
   by demonstration). Builtins with known non-retaining semantics
   (`alert`, `log`, method-style text/list/map ops, `file.*`) are not
   escapes. `quit` mid-handler skips local frees (one-shot; documented).
3. **Globals:** generated `cl_free_globals()` frees every global
   text/list/map (with element loops for nested container types),
   registered via `rt_register_cleanup` from emitted main.
4. **Window vars:** clarusc already emits per-window construction of
   handle-backed vars; it now also emits the matching release function,
   stored in the window instance, called from `rt_ui_teardown_window` —
   closing the roadmap's rt_mac.c:479 leak.

Aliasing semantics unchanged. Anything escape analysis can't prove stays
leaked-by-design until ARC. Go compiler untouched: frees are not
observable in output, so differential parity holds; clarusc's own source
uses no new language features, so the bootstrap chain and conservative
subset rule hold (snapshot regenerated per `TestSnapshotCurrent`).

## Runtime-internal fixes

- **`rt_ser.inc:107` / `:256`:** `rt_file_save`/`rt_file_load` leak a
  whole `rt_text` (struct + full-file buffer) per call, both runtimes —
  the worst live leak. Free on all exit paths; one shared-code fix.

## Testing & enforcement

1. **`rt_mem_test.c`** (sibling of `rt_ser_test.c`): relocation happens
   for unlocked handles on every alloc; locked blocks pin; scramble on
   move/dispose; guard-byte detection; ledger accounting + noted leaks;
   `MemError` codes; `BlockMoveData` argument order.
2. **Leak gate over the golden corpus:** host snapshot tests run every
   corpus program (clarusc-emitted lane) under `CLARUS_MEM_STRICT=1` with
   **per-program expected-leak goldens, default 0**. Programs that
   deliberately exercise escaping references record their count. Ratchet:
   leaks can never grow silently; the ARC follow-on drives all goldens to
   zero.
3. **Paranoia as a test:** the unified core plus conservative frees run
   under an allocator that moves unlocked blocks on every allocation and
   scrambles freed memory — an escape-analysis bug (freed-but-aliased
   value) surfaces as a host crash/wrong-output across the whole corpus,
   not as a use-after-free on hardware.
4. **Mac gates unchanged:** `CLARUS_MAC_TESTS=1` byte-compare parity and
   the `testdata/uisnaps` UI suite run as-is (Mac allocation behavior is
   identical Toolbox calls plus new teardown frees).

## Audit dispositions (per-site record)

| Site | Disposition |
|---|---|
| `rt_ser.inc` save/load temp text (per-call, both runtimes) | **Fixed** — freed on all exit paths (Task 4; distinct from Task 2's `rt_ser` fix, the list-save stale-pointer-under-relocation bug) |
| Struct box Handle discarded (`rt_mac_new_struct`, rt_mac.c:493) | **Fixed** — box is a `NewPtr` in the unified `rt_core.inc` (Task 2; Task 3 rewired `rt_mac.c` to consume it) |
| Handler locals + expression temporaries | **Fixed** — conservative default-deny lowering: statement-level temps (Task 6), non-escaping scope-exit locals incl. if-condition temps on branch jumps (Tasks 6–7) |
| Escaping values | **Leak by design until ARC** — ratchet-goldened; 9 of 40 corpus programs nonzero, all traced to documented gaps in the (window-free) host corpus: user-call-result/bare-alias reassignment orphans, element-read-disqualified containers, record fields out of local-free scope (Task 9). Window-var disqualification and cross-window name collisions are a separate leak-by-design class (Task 8), exercised by the Mac UI test suite, not by any of these 9 goldens. |
| Window vars never freed at close (rt_mac.c:479) | **Fixed** — generated per-window release function called from `rt_ui_teardown_window` (Task 8) |
| Globals live at exit | **Fixed** — `cl_free_globals()` via `rt_register_cleanup` (Task 5) |
| `rt_list_clear`/`rt_map_clear` keep capacity | **Kept** — deliberate amortization |
| Process-lifetime one-shots (menu bar menus, `gMenuHandles`, AE UPPs, `gEveryDue`, trace arrays, args list, `rt_test_log`) | **Leak by design** — reclaimed at exit; `rt_mem_note`-tagged host-side |
| `OpenWD` refnum (rt_ui.c:3873) | Not memory — existing comment stands |
| `NewControlActionUPP` per click (rt_ui.c:2093) | Benign on m68k (plain cast) — documented |
| `rt_ui_teardown_window` chain (controls/TE/List/LDEF/canvas/12 instance handles) | **Verified paired** — recorded so future audits don't re-litigate |

All rows above are closed as of Tasks 1–9 (commits `d318955`..`29e54bf` on
`memory-audit-4e`); the two-tier paranoia decision (unconditional resize
relocation everywhere, full move-on-every-alloc sweep opt-in via
`CLARUS_MEM_PARANOID=1`, corpus lanes only) is recorded above under
rt_mem_host.inc and was not revisited. Remaining leaks are deliberate and
tracked as the ARC follow-on below, not open work items.

## Risks

- **Escape-analysis bug = use-after-free on the Mac.** Mitigated by the
  paranoid shim + full-corpus coverage (risk surfaces host-side first),
  and by starting maximally conservative.
- **Migration shakeout:** moving rt_mac.c's collections under a
  move-on-every-alloc allocator may surface latent discipline bugs in
  code that looked correct. That is the audit working as intended; fix in
  the unified core.
- **Leak goldens churn:** per-program counts may prove noisy. If so, an
  optional precision upgrade is per-function parameter-escape summaries
  (whole-program compilation, no indirect calls — cheap fixpoint), which
  shrinks the "passed to user function" escape bucket. Not in 4e's
  initial scope.

## Follow-on (recorded, not scheduled)

- **ARC milestone:** refcount in the box, retain/release lowering, deep
  frees, all leak goldens to zero. Same runtime API; strictly smarter
  lowering. Sound and complete (no recursive types → no cycles).
- Host UI layer, if ever: extends the same Memory Manager emulation
  surface; nothing in 4e assumes host code cannot allocate Handles.
