# Memory-Management Audit (4e) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** One Handle-based memory model shared by both runtimes (Mac native, host via a paranoid Memory Manager shim with a leak ledger), a dispose API, conservative compiler-emitted frees, and per-site leak dispositions enforced by tests.

**Architecture:** The shim boundary is the classic Memory Manager API itself (`NewHandle`/`SetHandleSize`/`HLock`/`DisposeHandle`/…): the Mac build calls the real Toolbox with zero indirection; the host build gets `rt_mem_host.inc`, a deliberately hostile allocator that relocates unlocked handles, scrambles freed memory, and ledgers every block. `rt_mac.c`'s Handle-backed collections move to a shared `rt_core.inc` (same precedent as `rt_ser.inc`); `rt.c`'s malloc twins are deleted. clarusc gains: end-of-statement frees for text temporaries, scope-exit frees for provably sole-reference locals, a generated `cl_free_globals()`, and a generated per-window release function.

**Tech Stack:** C89-compatible C (Retro68 m68k + host cc), Clarus (clarusc's own source), Go test harness.

**Spec:** `docs/superpowers/specs/2026-07-28-memory-audit-design.md` (approved 2026-07-28).

## Global Constraints

- Branch: `memory-audit-4e`. Commit after every task. `main` stays green; this branch may be red mid-task only.
- The Go compiler (`internal/`) is FROZEN: **no changes** to `internal/cprint`, `internal/lexer`, etc. Go *test* files may change (env injection, goldens) — tests are harness, not compiler.
- `rt.h`'s existing ABI must not change: `rt_text*`/`rt_list*`/`rt_map*` remain stable plain pointers to the caller. Only additions allowed.
- The documented bootstrap must keep working **unchanged**: `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`. Therefore all new host runtime code is `#include`d into `rt.c`, never a new `.c` file.
- Every task that touches `clarusc/*.cla` MUST regenerate the snapshot before committing:
  `go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla && /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla`
- Every task that changes clarusc's emitted C MUST regenerate `testdata/emitui/*.c.golden` (byte-compared by `internal/emitui.TestEmitUiGoldens`): for each fixture with a golden, `/tmp/clarusc emit -o <fixture>.c.golden <fixture>.cla` (after building /tmp/clarusc from the CURRENT source).
- clarusc files this plan edits (`ir.cla`, `lower.cla`, `cprint.cla`, `main.cla`, `check.cla`) are pure ASCII — safe for the Edit tool. Do NOT edit `lex.cla`, `lib.cla`, `tok.cla` with the Edit tool (they contain MacRoman 0xC9 bytes); this plan never needs to.
- clarusc's own source must not use new language features (conservative subset rule). This plan adds no language features, so this is automatic — do not add any.
- Mac gates (`CLARUS_MAC_TESTS=1 go test ./internal/mactest`) run only in Tasks 3, 8, and 10; host gates (`go test ./...`) run in every task.
- Full-suite runs can take several minutes (bootstrap tests build clarusc repeatedly). `go test ./internal/build ./internal/selfhost` is the fast core loop.
- C style: match the existing runtime files — C89 declarations at block top, `/* */` comments, no `//`, two-space-ish alignment as in `rt.c`.

---

### Task 1: `rt_mem.h` + paranoid host Memory Manager + its C test

**Files:**
- Create: `internal/build/rt/rt_mem.h`
- Create: `internal/build/rt/rt_mem_host.inc`
- Create: `internal/build/rt/rt_mem_test.c`
- Create: `internal/build/memtest_c_test.go`
- Modify: `docs/superpowers/specs/2026-07-28-memory-audit-design.md` (one paragraph, step 6)

**Interfaces:**
- Produces (consumed by Tasks 2–4): the Memory Manager subset — `Handle`, `Ptr`, `Size`, `OSErr`, `noErr`, `memFullErr`, `nilHandleErr`, `NewHandle(Size)`, `NewHandleClear(Size)`, `SetHandleSize(Handle, Size)`, `GetHandleSize(Handle)`, `HLock(Handle)`, `HUnlock(Handle)`, `DisposeHandle(Handle)`, `NewPtr(Size)`, `NewPtrClear(Size)`, `DisposePtr(Ptr)`, `MemError(void)`, `BlockMoveData(src, dst, count)` — plus `rt_mem_note(block, "why")` (leak-by-design tag; no-op macro on Mac) and host-only `rt_mem_live_count(void)`.
- Environment knobs (host only): `CLARUS_MEM_PARANOID=1` → every allocation relocates every live unlocked handle; default → only the block being resized relocates (always). `CLARUS_MEM_STRICT=1` → at exit, run the registered cleanup, then write a leak report to the file named by `CLARUS_MEM_REPORT` (or stderr if unset).

- [ ] **Step 1: Write `rt_mem.h`**

```c
/* internal/build/rt/rt_mem.h -- the memory seam. On the Mac this IS the
   Toolbox Memory Manager; on the host, rt_mem_host.inc implements the same
   subset with deliberate hostility (relocation, scramble, ledger) so Handle
   discipline is proven in host tests before code ever runs on a Mac. */
#ifndef CLARUS_RT_MEM_H
#define CLARUS_RT_MEM_H

#if defined(__m68k__) || defined(macintosh)
#include <Memory.h>
#define rt_mem_note(block, why) ((void)(block), (void)(why))
#else

typedef long Size;
typedef short OSErr;
typedef char *Ptr;
typedef Ptr *Handle;

#define noErr        0
#define memFullErr   (-108)
#define nilHandleErr (-109)

Handle rt_mem_new_handle(Size n, int clear, const char *tag);
void   rt_mem_set_handle_size(Handle h, Size n);
Size   GetHandleSize(Handle h);
void   HLock(Handle h);
void   HUnlock(Handle h);
void   DisposeHandle(Handle h);
Ptr    rt_mem_new_ptr(Size n, int clear, const char *tag);
void   DisposePtr(Ptr p);
OSErr  MemError(void);
void   BlockMoveData(const void *src, void *dst, Size n);
void   rt_mem_note_(void *block, const char *why);
long   rt_mem_live_count(void);

#define RT_MEM_STR2(x) #x
#define RT_MEM_STR(x) RT_MEM_STR2(x)
#define RT_MEM_TAG (__FILE__ ":" RT_MEM_STR(__LINE__))

#define NewHandle(n)        rt_mem_new_handle((n), 0, RT_MEM_TAG)
#define NewHandleClear(n)   rt_mem_new_handle((n), 1, RT_MEM_TAG)
#define SetHandleSize(h, n) rt_mem_set_handle_size((h), (n))
#define NewPtr(n)           rt_mem_new_ptr((n), 0, RT_MEM_TAG)
#define NewPtrClear(n)      rt_mem_new_ptr((n), 1, RT_MEM_TAG)
#define rt_mem_note(block, why) rt_mem_note_((void *)(block), (why))

#endif /* host */
#endif /* CLARUS_RT_MEM_H */
```

- [ ] **Step 2: Write `rt_mem_host.inc`**

Implementation requirements (write real C89, ~200 lines; includes `<stdio.h> <stdlib.h> <string.h>` under its own guard):

```c
/* Block record. The Handle a caller holds is &b->p, and because p is the
   FIRST member, (rt_mem_block *)h recovers the record. Records are
   malloc'd individually and never freed (ledger keeps dead records to
   catch double-dispose); a freed record slot is not reused. */
typedef struct rt_mem_block {
    Ptr p;                    /* master pointer; NULL once disposed */
    Size size;
    unsigned char locked, noted, is_ptr, live;
    const char *tag;
    struct rt_mem_block *next; /* all-blocks list head: rt_mem_blocks */
} rt_mem_block;
```

- Guard bytes: allocate `size + 16`; `p` points 8 past the start; both 8-byte guards filled with `0x47`. `rt_mem_check_guards(b)` verifies both and on violation prints `rt_mem: guard smashed at <tag>` to stderr and `abort()`.
- `rt_mem_relocate(b)`: malloc new raw block, copy payload, refill guards, fill the OLD raw block with `0xA5`, `free` it, update `b->p`. Never called on locked or `is_ptr` blocks.
- `rt_mem_upheaval()`: called at the TOP of `rt_mem_new_handle`, `rt_mem_new_ptr`, and `rt_mem_set_handle_size`. If `CLARUS_MEM_PARANOID` env is set (getenv once, cache in a static int), relocate every live unlocked non-ptr block.
- `rt_mem_set_handle_size`: check guards; ALWAYS relocate into a fresh raw block of the new size (copy `min(old,new)` payload bytes, scramble+free old) — even without PARANOID, a resized handle always moves. Update `size`.
- `DisposeHandle`/`DisposePtr`: NULL is a no-op (matches Toolbox tolerance and the spec's NULL-safe frees). Disposing an already-dead block: print `rt_mem: double dispose at <tag> (allocated <b->tag>)` — the *dispose* site isn't known (no macro on dispose), so print just the allocation tag — and `abort()`. Otherwise: check guards, scramble payload with `0xA5`, free raw block, `b->p = NULL`, `b->live = 0`, decrement live count.
- `MemError()`: returns and clears a static `OSErr`; set `memFullErr` when malloc fails (then return NULL from the allocator), `nilHandleErr` on NULL handle args to size/lock calls; `noErr` otherwise.
- `BlockMoveData(src, dst, n)`: `memmove(dst, src, (size_t)n)` — note the argument order swap (Toolbox is src-first).
- Exit check: the first allocation does `atexit(rt_mem_exit_check)`. The handler: `rt_run_cleanup();` (declare `void rt_run_cleanup(void);` extern here — defined in rt_core.inc from Task 2), then if `CLARUS_MEM_STRICT` env set: count live un-noted blocks, open `CLARUS_MEM_REPORT` path (or use stderr), write one line `##CLARUS-MEM## live=<N>` then one `rt_mem: leak <tag> (<size> bytes)` line per live un-noted block.
- `rt_mem_live_count()`: live un-noted blocks (for the C test).
- `/* ponytail: relocation sweep is O(live blocks) per allocation under PARANOID; fine for corpus-sized programs, do not enable it for bootstrap-scale runs */`

- [ ] **Step 3: Write the failing C test `rt_mem_test.c`**

Standalone: includes `rt_mem.h` then `rt_mem_host.inc` directly, defines its own `void rt_run_cleanup(void) {}`. `main` runs assert-style checks, prints `OK\n` on success (mirror `rt_ser_test.c`'s style):

```c
/* the checks, in order: */
/* 1. NewHandle(16): non-NULL, GetHandleSize==16, live_count==1.        */
/* 2. Write 16 bytes via *h; SetHandleSize(h, 4096): payload preserved  */
/*    for first 16 bytes, *h CHANGED (relocation on resize is always).  */
/* 3. Paranoia: setenv is not portable pre-main -- instead the test     */
/*    re-execs itself: if argv[1]=="paranoid" run the paranoid checks,  */
/*    else system("CLARUS_MEM_PARANOID=1 ./<argv[0]> paranoid") and     */
/*    propagate its exit. Paranoid branch: h1=NewHandle(8); p=*h1;      */
/*    h2=NewHandle(8); assert *h1 != p (an unrelated allocation moved   */
/*    h1). Then HLock(h1); p=*h1; NewHandle(8); assert *h1==p (locked   */
/*    pins). HUnlock, DisposeHandle both.                               */
/* 4. Scramble: h=NewHandle(4); q=*h; DisposeHandle(h); assert          */
/*    q[0]==(char)0xA5 (reading freed memory sees poison; ok in a test).*/
/* 5. NULL DisposeHandle / DisposePtr are no-ops.                       */
/* 6. NewPtr never moves: p1=NewPtr(8); NewHandle(8); p1 still valid    */
/*    (write/read through it), DisposePtr(p1).                          */
/* 7. rt_mem_note: h=NewHandle(4); rt_mem_note(h, "by design");         */
/*    live_count drops by 1 (noted blocks aren't counted).              */
/* 8. BlockMoveData order: char a[4]="abc"; char b[4]; BlockMoveData(a, */
/*    b, 4); assert b[0]=='a'.                                          */
```

- [ ] **Step 4: Write the Go wrapper `internal/build/memtest_c_test.go`**

Model on `internal/build/sertest_c_test.go:17` (`TestSerC`), but compile ONLY the test file: `cc -std=c99 -Wall -Werror -I rt rt/rt_mem_test.c -o $TMP/memtest`, run with `cmd.Dir = t.TempDir()`, require stdout `"OK\n"`.

- [ ] **Step 5: Run it — expect FAIL (no files yet), then implement until PASS**

Run: `go test ./internal/build -run TestMemC -v`
Expected first: compile errors; iterate until `OK`.

- [ ] **Step 6: Amend the spec's paranoia paragraph**

In `docs/superpowers/specs/2026-07-28-memory-audit-design.md`, in the `rt_mem_host.inc` section, replace the sentence beginning "**Paranoia (stricter than a real Mac):** every allocation call" with: relocation-on-resize is unconditional; the full every-allocation-moves-everything sweep is opt-in via `CLARUS_MEM_PARANOID=1`, enabled by the corpus test lanes but not by bootstrap-scale runs (clarusc compiling itself under an O(live-blocks)-per-allocation allocator would be quadratic). Keep the rest.

- [ ] **Step 7: Full host suite still green** (`go test ./...` — nothing links the new files except the new test)

- [ ] **Step 8: Commit**

```bash
git add internal/build/rt/rt_mem.h internal/build/rt/rt_mem_host.inc internal/build/rt/rt_mem_test.c internal/build/memtest_c_test.go docs/superpowers/specs/2026-07-28-memory-audit-design.md
git commit -m "rt: paranoid host Memory Manager shim (rt_mem) -- relocation, scramble, guards, ledger"
```

---

### Task 2: `rt_core.inc` — unified Handle-based collections; rewire `rt.c`

**Files:**
- Create: `internal/build/rt/rt_core.inc`
- Modify: `internal/build/rt/rt.c` (delete ~470 lines, add includes)
- Modify: `internal/build/rt/rt.h` (dispose API declarations)

**Interfaces:**
- Consumes: Task 1's Memory Manager API.
- Produces (consumed by Tasks 3–9):
  - `void rt_text_free(rt_text *t);` / `void rt_list_free(rt_list *l);` / `void rt_map_free(rt_map *m);` — NULL-safe, shallow (containers do not free element handles).
  - `void rt_register_cleanup(void (*fn)(void));` and `void rt_run_cleanup(void);` (runs the registered fn at most once, clearing the slot first).
  - `rt_core.inc` expects, from the including `.c`, before inclusion: `rt.h`, `rt_mem.h`, `<string.h>` included, and `rt_panic` available.

- [ ] **Step 1: Create `rt_core.inc` from rt_mac.c's portable code**

Copy these `runtime/mac/rt_mac.c` ranges into `internal/build/rt/rt_core.inc`, in this order (they are the Handle-native implementations; semantics must not change — every panic message, clamp, and lastError code stays byte-identical):

1. lasterr state + `rt_set_lasterr` (rt_mac.c:274–287)
2. str255 ops (rt_mac.c:289–432)
3. fixed-point (rt_mac.c:434–449)
4. enum/arr checks + `rt_arr_check`/`rt_enum_from_int` (rt_mac.c:451–467)
5. collections preamble (rt_mac.c:469–515) with these changes:
   - Rewrite the 469–485 comment: storage is now shared by both runtimes via rt_mem.h; structs are `NewPtr` boxes; dispose exists (`rt_*_free`), and the paranoid host shim proves handle discipline.
   - `rt_mac_oom` → rename `rt_core_oom` (all call sites).
   - `rt_mac_new_struct` → replace with:
     ```c
     static void *rt_core_new_struct(Size sz)
     {
         Ptr p;
         p = NewPtr(sz);
         if (!p) rt_core_oom();
         return p;
     }
     ```
   - `rt_mac_grow` → rename `rt_core_grow` (all call sites).
6. text (rt_mac.c:517–738) — includes `rt_text_cmp` at the end.
7. list (rt_mac.c:751–837)
8. map + clears (rt_mac.c:839–991)

Then append the new API:

```c
/* ---- dispose (4e). Shallow: a list/map of text frees only its own
   storage; the compiler emits element frees where it knows the types. */
void rt_text_free(rt_text *t)
{
    if (!t) return;
    DisposeHandle(t->h);
    DisposePtr((Ptr)t);
}

void rt_list_free(rt_list *l)
{
    if (!l) return;
    DisposeHandle(l->h);      /* match the actual field name from rt_mac.c:753-758 */
    DisposePtr((Ptr)l);
}

void rt_map_free(rt_map *m)
{
    if (!m) return;
    DisposeHandle(m->keys);   /* match actual field names from rt_mac.c:850-857 */
    DisposeHandle(m->vals);
    DisposePtr((Ptr)m);
}

static void (*rt_cleanup_fn)(void) = 0;
void rt_register_cleanup(void (*fn)(void)) { rt_cleanup_fn = fn; }
void rt_run_cleanup(void)
{
    void (*f)(void);
    if (!rt_cleanup_fn) return;
    f = rt_cleanup_fn;
    rt_cleanup_fn = 0;
    f();
}
```

(Check the real field names when copying — the list struct is at rt_mac.c:753–758, map at 850–857.)

- [ ] **Step 2: Add to `rt.h`** (after the `rt_map_val_at` block, before the printer-additions section):

```c
/* ---- dispose (4e) ---- shallow, NULL-safe; compiler emits element frees */
void rt_text_free(rt_text *t);
void rt_list_free(rt_list *l);
void rt_map_free(rt_map *m);
/* one-slot at-exit/quit hook; emitted main registers cl_free_globals */
void rt_register_cleanup(void (*fn)(void));
void rt_run_cleanup(void);
```

- [ ] **Step 3: Rewire `rt.c`**

- After `#include "rt.h"` (rt.c:9) add `#include "rt_mem.h"` and after the libc includes add `#include "rt_mem_host.inc"`.
- Delete: lasterr (15–24), str255 (55–170), fixed (172–181), `grow` (183–194), text (196–357), list (359–428), map+clears (461–594), enum/arr+`rt_text_cmp` (596–620). KEEP: panic/quit/alert/log (26–53), args (430–459), files (622–688), `rt_file_write_data` (690–709).
- Where the deleted sections were, add one line: `#include "rt_core.inc"` (place it before the args section so nothing is used before it exists in the TU — order doesn't strictly matter with rt.h prototypes, but keep it tidy).
- `rt_quit` (rt.c:31–33) becomes:
  ```c
  void rt_quit(int32_t code) { rt_run_cleanup(); exit(code); }
  ```

- [ ] **Step 4: Run the fast core loop**

Run: `go test ./internal/build ./internal/selfhost ./internal/sertest ./internal/emitui`
Expected: PASS. This compiles every corpus program against the rewired rt.c and runs clarusc itself (built from Go) — the unified core is now under the shim (default mode: resize-always-moves + scramble), which already catches any cached-`*h`-across-grow bug. If something crashes, that IS the audit finding — fix it in rt_core.inc by re-dereferencing after the allocating call, matching the discipline documented in the rt_mac.c 469-485 comment.

- [ ] **Step 5: Full suite**

Run: `go test ./...`
Expected: PASS (bootstrap fixed point unaffected — clarusc's emitted C is unchanged by runtime-only edits; `TestSnapshotBuilds` now compiles the snapshot against the rewired rt.c).

- [ ] **Step 6: Commit**

```bash
git add internal/build/rt/rt_core.inc internal/build/rt/rt.c internal/build/rt/rt.h
git commit -m "rt: unify collections into rt_core.inc over the Memory Manager seam; dispose API; delete host malloc twins"
```

---

### Task 3: Rewire `rt_mac.c` onto the shared core; Mac gates

**Files:**
- Modify: `runtime/mac/rt_mac.c` (delete ~600 lines, add includes)

**Interfaces:**
- Consumes: `rt_core.inc`, `rt_mem.h`.
- Produces: rt_mac.c = Toolbox-only + shared includes. `rt_quit` (both variants) runs `rt_run_cleanup()` first.

- [ ] **Step 1: Rewire**

- After `#include "rt.h"` (rt_mac.c:16) add `#include "rt_mem.h"` (harmless next to the explicit `<Memory.h>` at line 19 — rt_mem.h's Mac branch includes the same header; keep both, `rt_mem.h` documents the seam).
- Delete rt_mac.c:274–738 and 751–991 (lasterr, str255, fixed, enum/arr, collections preamble, text, list, map). **Keep 740–749** (`rt_test_flush_log`, RT_MAC_TEST-only — it reads `struct rt_text` internals, so it must appear AFTER the core include).
- In place of the deleted 274 region insert `#include "rt_core.inc"`, so the file order is: Toolbox sections … `#include "rt_core.inc"` … `rt_test_flush_log` ifdef block … files … `rt_ser.inc`.
- Both `rt_quit` variants get cleanup: real one (rt_mac.c:66) → `void rt_quit(int32_t code) { rt_run_cleanup(); ExitToShell(); }` (code was already discarded there — keep whatever the current body does with it, just prepend the call); RT_MAC_TEST one (rt_mac.c:222–227) → prepend `rt_run_cleanup();` before its existing capture/exit sequence.
- `rt_text_free`/`rt_list_free`/`rt_map_free` compile to Toolbox `DisposeHandle`/`DisposePtr` automatically — no Mac-specific code needed.

- [ ] **Step 2: Host suite green** — `go test ./...` (host doesn't compile rt_mac.c, but the suite guards against accidental rt.h drift). Expected: PASS.

- [ ] **Step 3: Mac gates**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSuiteOnMac|TestRunErrOnMac|TestAbortAppsOnMac' -v -timeout 30m` (background; LaunchAPPL blocks while emulating).
Expected: PASS — byte-identical to host oracle. This proves the unified core behaves identically under the real Memory Manager.

- [ ] **Step 4: UI snapshot gate**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestUi -v -timeout 30m` (exact test name: check `internal/mactest/ui_test.go`; run whatever the UI scenario test function is).
Expected: PASS with existing goldens (no UI behavior changed yet).

- [ ] **Step 5: Commit**

```bash
git add runtime/mac/rt_mac.c
git commit -m "rt_mac: collections move to shared rt_core.inc -- Toolbox-only file now; quit runs cleanup hook"
```

---

### Task 4: `rt_ser` leak fix + sertest under STRICT

**Files:**
- Modify: `internal/build/rt/rt_ser.inc` (4 free sites)
- Modify: `internal/build/sertest_c_test.go` (env)
- Modify: `internal/build/rt/rt_ser_test.c` (only if it leaks otherwise — see step 3)

**Interfaces:** consumes `rt_text_free` from Task 2.

- [ ] **Step 1: Free the temporaries**

- `rt_file_save` (rt_ser.inc:100–148): single exit `return ok;` at 147. Insert `rt_text_free(out);` between line 146 (`ok = rt_file_write_data(path, out);`) and the return.
- `rt_file_load` (rt_ser.inc:243–311): three sites:
  - line 257: `if (!rt_file_read_text(path, in)) return 0;` → `if (!rt_file_read_text(path, in)) { rt_text_free(in); return 0; }`
  - line 304 success: `rt_text_free(in);` immediately before `return 1;`
  - `fail:` label (306): `rt_text_free(in);` as the first statement after the label (covers the goto sites at 267/268/270/303).
  - Note `r.t` merely aliases `in` (259) — no other retention; do not free `r.t` too.

- [ ] **Step 2: Turn sertest into a leak test**

In `internal/build/sertest_c_test.go` (the `exec.Command` running the compiled sertest binary, near line 23): `cmd.Env = append(os.Environ(), "CLARUS_MEM_STRICT=1", "CLARUS_MEM_PARANOID=1")`. The report goes to stderr since `CLARUS_MEM_REPORT` is unset; assert stderr's `##CLARUS-MEM## live=` line reports 0 (parse the line; fail with the full stderr if not).

- [ ] **Step 3: Make rt_ser_test.c leak-clean**

`rt_ser_test.c` itself creates texts/lists/maps as fixtures. Add matching `rt_*_free` calls (or `rt_mem_note`) so the binary genuinely exits at live=0 — whatever it allocates, free before `printf("OK\n")`. Free element texts before their containers where it stores `rt_text*` elements (read the file; it's 330 lines).

- [ ] **Step 4: Run** `go test ./internal/build -run 'TestSerC|TestMemC' -v` → PASS with live=0. Then `go test ./...` → PASS.

- [ ] **Step 5: Commit**

```bash
git add internal/build/rt/rt_ser.inc internal/build/rt/rt_ser_test.c internal/build/sertest_c_test.go
git commit -m "rt_ser: free the per-call save/load text -- the worst repeatable leak; sertest now a strict leak gate"
```

---

### Task 5: clarusc emits `cl_free_globals` + registration

**Files:**
- Modify: `clarusc/cprint.cla` (`cpEmitGlobalsInit` ~line 2810, `cpEmitMain` ~3000, `cpEmitUiMain` ~2977)
- Modify: `clarusc/clarusc.c` (regenerated snapshot)
- Modify: `testdata/emitui/*.c.golden` (regenerated)

**Interfaces:**
- Consumes: `rt_register_cleanup`, `rt_*_free` (Task 2).
- Produces: emitted C contains `static void cl_free_globals(void) { ... }` after `clar_init_globals`, and `rt_register_cleanup(cl_free_globals);` as the line after `clar_init_globals();` in both mains. Also produces the reusable printer helper **`cpEmitFree(dst: text, cexpr: string, t: int)`** — appends to `dst` the free statement(s) for an lvalue C expression `cexpr` of IR type `t` — used again by Tasks 7 and 8.

- [ ] **Step 1: Write `cpEmitFree` in cprint.cla**

Semantics (shallow-plus rule from the spec):
- `KText` → `rt_text_free(<cexpr>);`
- `KList` → if the element type is itself `KText` emit the element loop first:
  ```c
  { int32_t i; for (i = 0; i < rt_list_count(<cexpr>); i++) rt_text_free(*(rt_text **)rt_list_at(<cexpr>, i)); }
  ```
  then `rt_list_free(<cexpr>);`. Element types `KList`/`KMap` (nested containers): free the container SHALLOW only — no loop — the elements leak by design until ARC (matches spec; note it in a C comment in the emitted code? No — keep emitted code clean; the rule is documented in the spec).
- `KMap` → same shape with `rt_map_val_at` into a local temp:
  ```c
  { int32_t i; rt_text *v; for (i = 0; i < rt_map_count(<cexpr>); i++) { rt_map_val_at(<cexpr>, i, &v); rt_text_free(v); } }
  ```
  (only when val type is `KText`), then `rt_map_free(<cexpr>);`.
- `KArr` → recurse per element index over the array length, mirroring `cpDefaultInit`'s `KArr` branch (cprint.cla:1471–1479) — arrays of text/list/map exist iff cpDefaultInit constructs them; mirror exactly what it constructs.
- `KRec` → recurse over record fields that need ctor (`irtNeedsCtor`-style walk mirroring cpDefaultInit's record branch).
- Every other kind → emit nothing.
- Loop-variable naming: `fpNewTmp`-style names are per-function state; `cl_free_globals` is its own function — use fixed inner-scope names (`i`, `v`) inside the emitted `{ }` blocks as shown, so no temp bookkeeping is needed.

- [ ] **Step 2: Emit the function + registration**

- In `cpEmitGlobalsInit` (cprint.cla:2810): after the `clar_init_globals` body is closed, emit `static void cl_free_globals(void) { ... }` — a walk over the same `irGlobals` arena calling `cpEmitFree(dst, "cv_" + name, irGlobalType(i))` per global.
- **Alias guard:** a global whose *initializer expression* is a bare reference to another global (IR: the init is a plain `EVarRef` of a global with a KText/KList/KMap type) must be SKIPPED in cl_free_globals — freeing both would double-free one handle (Ch3 reference semantics). Find where globals' init expressions are reachable during `cpEmitGlobalsInit` (it prints them); apply the check there. Everything else (literals, constructors, concat results) is fresh by construction.
- In `cpEmitMain` (cprint.cla:3000) and `cpEmitUiMain` (cprint.cla:2977): insert `rt_register_cleanup(cl_free_globals);` immediately after the `clar_init_globals();` line. Emit unconditionally (an empty cl_free_globals is fine and keeps the shape uniform).

- [ ] **Step 3: Test via a run fixture**

Write `/tmp/globals_free.cla` (scratch, not committed):
```rust
var g: text = "hello"
var gl: list of text = []
var alias: text = g

on App.startCLI(args: list of string) {
    gl.push("one")
    alert(g[0, g.length])
}
```
(If `[]` list literals don't exist, declare without initializer — check testdata/run for the idiom.) Then:
```sh
go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
/tmp/clarusc emit -o /tmp/gf.c /tmp/globals_free.cla
cc -std=c99 -I internal/build/rt -o /tmp/gf /tmp/gf.c internal/build/rt/rt.c
CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 /tmp/gf 2>&1 | grep CLARUS-MEM
```
Expected: `##CLARUS-MEM## live=0` and stdout `hello`. Two sub-changes this step needs first:
- The `rt_args_list` list (rt.c:446–459) is a deliberate process-lifetime allocation (2 ledger blocks: box + data handle). Note it: add `void rt_list_note(rt_list *l, const char *why);` to rt.h (next to the dispose API), define it in rt_core.inc (non-static — it must not warn as unused when rt_mac.c includes the core) as two `rt_mem_note` calls (the box `Ptr` and the data `Handle`; on Mac `rt_mem_note` is a no-op macro so the function compiles to nothing). Call it from rt.c's `rt_args_list` right after the list is built.
- The alias guard makes `alias` skipped; its handle is `g`'s handle and is freed exactly once via `g` — not a leak, not a double-free.

- [ ] **Step 4: Regenerate snapshot + emitui goldens**

```sh
go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
/tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
for f in testdata/emitui/*.c.golden; do /tmp/clarusc emit -o "$f" "${f%.c.golden}.cla"; done
```

- [ ] **Step 5: Full suite** — `go test ./...` → PASS (bootstrap fixed point re-established by the snapshot regen; emitui goldens match by construction — eyeball `git diff testdata/emitui/textwidgets.c.golden` to confirm the diff is exactly cl_free_globals + registration).

- [ ] **Step 6: Commit**

```bash
git add clarusc/cprint.cla clarusc/clarusc.c testdata/emitui/*.c.golden internal/build/rt/rt_core.inc internal/build/rt/rt.c internal/build/rt/rt.h
git commit -m "clarusc: emit cl_free_globals + rt_register_cleanup -- globals freed at exit/quit; args list noted"
```

---

### Task 6: clarusc frees statement-level text temporaries

**Files:**
- Modify: `clarusc/cprint.cla` (`fpNewTmp` :132, `fpStmt` :1180, consumption sites)
- Modify: `clarusc/clarusc.c`, `testdata/emitui/*.c.golden` (regenerated)

**Interfaces:**
- Consumes: `rt_text_free` (NULL-safe — required here).
- Produces: every emitted statement is followed by `rt_text_free(tN);` for each text temp the statement created and did not hand off.

- [ ] **Step 1: Track temps**

- Add module state next to `fpTmpN`: a `list of text` `fpStmtTmps` (names of text temps created since the current `fpStmt` began) — plus a re-entrancy discipline: `fpStmt` saves the current list contents count on entry? No — **save/swap**: `fpStmt` snapshots the current list into a local, resets the module list, and restores on exit (mirror however `fpCaptureExpr` (:404) swaps `fpBody` — same pattern, module-var swap through locals).
- `fpNewTmp(ctype)` — when `ctype` is the C type for text (`rt_text *`): initialize the declaration as `rt_text *tN = NULL;` (change from uninitialized — required for temps born inside `fpAndOr`'s conditional blocks, cprint.cla:428–460) and push the name onto `fpStmtTmps`. Other ctypes: unchanged.
- Add `func fpHandoff(cexpr: text)`: if `cexpr` exactly equals a tracked temp name, remove it from `fpStmtTmps` (it escaped the statement — do not free).

- [ ] **Step 2: Mark handoffs at every retaining consumption site**

Call `fpHandoff` on the produced C expression at:
- `SAssign` src (cprint.cla:1192–1195) — when the destination type is text (a text temp assigned to a var IS the var's new value). Also `SStoreStr`? No — `SStoreStr` copies bytes, not handles; no handoff.
- `SReturn` value (cprint.cla:1202–1207).
- `ECallFn` argument expressions whose parameter type is text/list/map (`fpExpr`'s ECallFn case — the callee may retain; freeing after the call would UAF).
- Retaining intrinsics: `IListPush`, `IListUnshift`, `IMapSet` value argument (element/val handles are stored); also `IUiEdit` bind arguments if any take text (check `fpIntrCall`'s edit case).
- NOT handoffs (bytes are copied, temp stays freeable): `ITextStore`, `ITextConcat`/`ITextConcatSL` inputs, `IAlert`/`ILog`, `ITextSlice`, comparisons, `IFileReadText`/`IFileWriteText` path/args, `ITextOfStr` input.

- [ ] **Step 3: Free at end of statement**

At the end of `fpStmt` (single exit — confirm; if multiple, funnel): for each remaining tracked name, emit `rt_text_free(tN);` then restore the outer list. Compound statements (`SIf`/`SWhile`/`SForRange`/`SForList`/`SForMap`) recurse via `fpStmts` — their inner statements each handle their own temps; the compound's own condition temps: condition expressions are printed once per C evaluation for `SIf` but per-iteration for loops — **loop conditions**: check how `SWhile` prints its condition (cprint.cla near :1210–1240); if the condition C-expr is evaluated each iteration but the temp creation was emitted BEFORE the loop, a text-producing while-condition would already be broken today (stale temp) — verify with a grep for how while conditions involving concat behave; most likely conditions are comparisons producing int. If a while condition can create a text temp per iteration inside the loop's emitted body, free it there; if temps for conditions are hoisted (current behavior), freeing at end-of-`fpStmt` (after the whole loop) matches current lifetime. Match existing structure; do not redesign it.

- [ ] **Step 4: Targeted proof**

`/tmp/temps.cla`:
```rust
func shout(s: text): text {
    return s + "!"
}

on App.startCLI(args: list of string) {
    var t: text = "a"
    if t + "b" == "ab" { alert("yes") }
    var u: text = shout(t)
    alert(u[0, u.length])
}
```
Emit, compile, run under STRICT+PARANOID as in Task 5 step 3. Expected: stdout `yes` then `a!`. The `t + "b"` concat temp is consumed by a comparison (bytes read, not retained) so it IS freed after the `if` statement; `s + "!"` inside `shout` is handed off to `return` (not freed). Locals aren't freed until Task 7, so the report shows exactly `t` and `u`: each text is 1 `NewPtr` box + 1 `NewHandle` data = 2 ledger blocks, so expect `live=4`. Verify by reading the emitted C: exactly one `rt_text_free(t<N>);` after the emitted `if` statement, none after the return inside `clar_fn_shout`.

- [ ] **Step 5: Regenerate snapshot + emitui goldens** (same commands as Task 5 step 4). Full suite: `go test ./...` → PASS. The paranoid corpus isn't wired yet, but `TestEmitDifferential` reruns all 41 programs with frees active — any UAF from a wrong handoff shows as output divergence or crash here.

- [ ] **Step 6: Commit**

```bash
git add clarusc/cprint.cla clarusc/clarusc.c testdata/emitui/*.c.golden
git commit -m "clarusc: free statement-level text temporaries -- handoff-aware, NULL-init for conditional temps"
```

---

### Task 7: clarusc frees provably sole-reference locals at scope exit

**Files:**
- Modify: `clarusc/lower.cla` (escape pre-pass + free insertion; `lowFuncBody` :2090, `lowBlock` :2031, `lowReturn` :1606)
- Modify: `clarusc/ir.cla` (three free intrinsics)
- Modify: `clarusc/cprint.cla` (`fpIntrCall` cases delegating to `cpEmitFree`-style output)
- Modify: `clarusc/clarusc.c`, `testdata/emitui/*.c.golden` (regenerated)

**Interfaces:**
- Consumes: Task 5's `cpEmitFree` helper (reuse for the intrinsic printing), Task 2's frees.
- Produces: IR intrinsics `ITextFreeVar()`/`IListFreeVar()`/`IMapFreeVar()` (one `EVarRef` argument), emitted before every `SReturn` and at body end for qualifying locals.

- [ ] **Step 1: The qualification rule (write it as a comment block at the top of the new lower.cla section, then implement exactly)**

A function/handler local `x` of type text/list/map qualifies for scope-exit free iff ALL of:
1. Declared at body top (all Clarus locals are — Ch4: `var` only at top of body). NOT a `for`-loop binding (those alias container elements — lowFor lower.cla:1579/1587 locals are out of scope of this rule by construction since they aren't body-top vars).
2. Its initializer is fresh: a string literal (→ `ITextOfStr`), absent (default constructor), a concat result, or a user-call result — NOT a bare reference to another variable/global/window var/field/element. (A call result is fresh-enough: even if the callee returns a retained reference, the callee's other holders keep it alive — freeing here would be wrong! **Correction: a user-call initializer does NOT qualify** — `func f(): text { return gKeep }` returns an alias. Only literals, absent-init, and concat/slice-of results qualify.)
3. `x` never appears, anywhere in the body, as: the RHS of any assignment (`a = x`); an argument to a user function (`ECallFn`); a `return` operand; the value operand of `push`/`unshift`/map-index-set into ANY container; a form-edit binding; stored into a record field, window var, or global. Appearing as: method receiver (`x.append(...)`, `x.length`), operand of concat/comparison/slice, `alert`/`log`/`file.*` argument, or index-read source is fine — **except** when `x` is itself a List/Map whose element/value kind carries a handle (Text/List/Map, or a Rec/Arr that might embed one): reading an element back out (`x[i]`, `x[k]`, `.get`/`.first`/`.last`/`.pop`/`.shift`, or `x` as a `for`-loop's own sequence) hands out a reference `x` still owns — if that reference later escapes and `x` is also freed at scope exit, `x`'s own scope-exit element-free loop double-frees it (Task 7 review's repro: `gSaved = items[0]` then freeing `items` frees the same handle `gSaved` holds). Every such read disqualifies `x`, unconditionally — even `.pop`/`.shift`, which remove the slot and could in principle stay safe: default-deny wins over the theoretical safety.
4. `x` is never re-assigned from a non-fresh source later (`x = g`). Re-assignment from fresh sources is fine but means the ORIGINAL handle leaks on overwrite — still emit the scope-exit free (frees the final handle); the overwritten-handle leak is an ARC-era fix, don't chase it.

- [ ] **Step 2: Implement the pre-pass in lower.cla**

Where: inside `lowFuncBody` (lower.cla:2090), before lowering the body block — walk the AST body (statements + expressions, recursively; the AST arenas + accessors in ast.cla) collecting, per body-top local name, a `disqualified` flag per rule above. Store as a map keyed by interned name index (module-level `lowFreeableSet: map of int`-equivalent — match clarusc's existing idiom for name-keyed side tables, see check.cla's `windowVarsHead` pattern or use `list of int` + membership scan; clarusc has maps of string — key by `poolGet(nameIdx)` if int keys aren't idiomatic; **follow whatever check.cla does for name-keyed tables**).
The walk needs ~10 AST node cases (assignment, call, return, method-call, index-assign, form-edit). Being AST-level, it runs before any lowering state exists — keep it purely syntactic and conservative: unknown/unhandled node kinds containing an identifier reference to `x` in a non-receiver position → disqualify. **Default-deny.**

- [ ] **Step 3: Insert frees during lowering**

- Add intrinsics in ir.cla mirroring an existing zero-result intrinsic's plumbing (find `ITextStore`'s registration pattern in ir.cla's intrinsic-name registry and copy it): `ITextFreeVar`, `IListFreeVar`, `IMapFreeVar`.
- In `lowReturn` (lower.cla:1606): before building the `SReturn`, for each qualifying local currently declared in this function (the pre-pass set), append `SExprStmt(EIntr(I*FreeVar, EVarRef(x)))` — EXCEPT when the return operand is `x` itself (rule 3 already disqualified that x, so this is automatic; assert it stays true).
- In `lowFuncBody` after `lowBlock` returns the body chain: if the last IR statement isn't an `SReturn`, append the same frees at the end.
- `quit` (lowQuit lower.cla:1885): no frees — matches spec.

- [ ] **Step 4: Print the intrinsics in cprint.cla**

`fpIntrCall` gains three cases: `ITextFreeVar()` → `rt_text_free(cv_x);`, list/map → delegate to Task 5's `cpEmitFree` with the var's IR type (element loops included). After freeing a list/map local, also emit `cv_x = NULL;`? Not needed — the variable is dead (scope exit / pre-return). Skip.

- [ ] **Step 5: Targeted proof**

Reuse `/tmp/temps.cla` from Task 6 step 4 (same build/run commands). Expected now: `t` disqualified? `t` is passed to `shout` (user call) → disqualified, stays leaked. `u` is initialized from a user-call result → disqualified (rule 2 correction). So live count unchanged from Task 6 — add a third case to the fixture:
```rust
    var scratch: text = "x"
    scratch.append("y")
    alert(scratch[0, 2])
```
`scratch` qualifies (literal init, only receiver/alert uses) → freed at body end. Expected live drops by 2 blocks (box + data) vs Task 6's count. Also verify in the emitted C: `rt_text_free(cv_scratch);` appears exactly once, at end of the handler body.

- [ ] **Step 6: Corpus + snapshot + goldens**

`go test ./...` → PASS (TestEmitDifferential re-runs everything with local frees live — divergence or crash = escape-analysis bug; fix before proceeding). Regenerate snapshot + emitui goldens (Task 5 step 4 commands). Re-run `go test ./internal/selfhost` after regen.

- [ ] **Step 7: Commit**

```bash
git add clarusc/lower.cla clarusc/ir.cla clarusc/cprint.cla clarusc/clarusc.c testdata/emitui/*.c.golden
git commit -m "clarusc: scope-exit frees for provably sole-reference locals -- default-deny escape pre-pass"
```

---

### Task 8: Generated window-var release + rt_ui teardown hook

**Files:**
- Modify: `runtime/mac/rt_ui.h` (`rt_ui_handlers` :185–188)
- Modify: `runtime/mac/rt_ui.c` (`rt_ui_teardown_window`, after :4801)
- Modify: `clarusc/cprint.cla` (`cpEmitWinHandlersFwd` :2311, new release emitter near `cpEmitUiWiring` :2792)
- Modify: `clarusc/clarusc.c`, `testdata/emitui/*.c.golden` (regenerated)

**Interfaces:**
- Consumes: `cpEmitFree`, `cpFindWindowStateFields` (cprint.cla:2143), `irtNeedsCtor` (ir.cla:703).
- Produces: `rt_ui_handlers` gains a third slot `void (*releaseVars)(void *inst);` (may be NULL); clarusc emits `static void clar_ui_release_<Win>(void *inst)` and wires it.

- [ ] **Step 1: rt_ui.h** — add to `rt_ui_handlers` (rt_ui.h:185–188) a third member after `widget`: `void (*releaseVars)(void *inst); /* frees handle-backed window vars; may be NULL */`. This struct is emitted positionally by generated code — old golden C without the third member still compiles (C zero-fills trailing initializers) but ALL goldens regenerate this task anyway.

- [ ] **Step 2: rt_ui.c** — in `rt_ui_teardown_window`, immediately after the `RTUI_EV_CLOSED` dispatch (:4800–4801) and before the per-widget dispose loop (:4803):

```c
    if (inst->desc->handlers && inst->desc->handlers->releaseVars && inst->state)
        inst->desc->handlers->releaseVars(inst);
```

(`inst->state` is still valid until `DisposeHandle(inst->stateH)` at :4822 — comment this constraint.)

- [ ] **Step 3: clarusc emission**

- New emitter next to the dispatchers (`cpEmitUiDispatchers` cprint.cla:2720): for each window whose state fields include any `irtNeedsCtor` field, emit
  ```c
  static void clar_ui_release_<Win>(void *inst)
  {
      <for each needs-ctor field f: cpEmitFree over "(*(clar_uistate_<Win> *)rt_ui_state(inst)).cv_<f>">
  }
  ```
  — the exact mirror of `fpIntrCall`'s `IUiStateDefaults()` case (cprint.cla:967–986).
- `cpEmitWinHandlersFwd` (cprint.cla:2311): add the third initializer — `clar_ui_release_<Win>` when the window has needs-ctor fields, else `0`.
- **Escape caveat, keep it simple:** window vars can be aliased into globals by handler code (`gKeep = winvar`). Freeing at close would UAF the global. Apply the same default-deny rule cheaply: a window var qualifies for release iff NO handler/function body in the program mentions that window-var name as an RHS/argument/return/stored value (reuse Task 7's pre-pass walker over every body, with the window-var names as the tracked set — run it in lower.cla where window decls lower (lowWindowDecl :2694), stash the verdict on the IR window desc (new bool per state field or a per-window filtered list), and let the emitter consult it). Vars that fail stay leaked-by-design (goldens/ARC).

- [ ] **Step 4: Host-side verification** — emitui goldens: regenerate, then READ `git diff testdata/emitui/textwidgets.c.golden`: expect `clar_ui_release_*` functions freeing the three `rt_text_new` state fields (textwidgets constructs at :104–116 per the explorer map), the handlers structs gaining the third member, teardown unchanged (runtime side isn't in goldens). `go test ./...` → PASS (emitui's m68k compile-check validates rt_ui.h compatibility).

- [ ] **Step 5: Mac gates** — `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 40m` (all of it, background). Expected: PASS, byte-identical traces and snaps (close/reopen scenarios now free — behavior invisible, memory reclaimed).

- [ ] **Step 6: Snapshot regen + full suite + commit**

```bash
git add runtime/mac/rt_ui.h runtime/mac/rt_ui.c clarusc/cprint.cla clarusc/lower.cla clarusc/ir.cla clarusc/clarusc.c testdata/emitui/*.c.golden
git commit -m "rt_ui + clarusc: generated releaseVars hook frees window vars at teardown -- closes the rt_mac.c:479 leak"
```

---

### Task 9: The corpus leak gate (`.leaks` goldens)

**Files:**
- Modify: `internal/selfhost/emit_test.go` (env + report parsing, ~line 158)
- Create: `testdata/run/<name>.leaks` — ONLY for programs with nonzero expected leaks

**Interfaces:** consumes the `##CLARUS-MEM## live=<N>` report via `CLARUS_MEM_REPORT=<tmpfile>`.

- [ ] **Step 1: Wire the lane**

In `TestEmitDifferential`'s run step (emit_test.go:158): set
```go
report := filepath.Join(t.TempDir(), "mem.txt")
cmd.Env = append(os.Environ(), "CLARUS_MEM_STRICT=1", "CLARUS_MEM_PARANOID=1", "CLARUS_MEM_REPORT="+report)
```
After the existing output assertions: read `report`, parse `live=<N>`; expected = contents of `testdata/run/NAME.leaks` if present (a single integer) else 0; on mismatch, fail printing the full report (its per-block tag lines say exactly what leaked and where it was allocated). Report file missing → fail ("runtime wrote no mem report — is STRICT plumbed?"). Do the same for the runerr lane (:337)? NO — those exit via panic (exit 3), atexit still runs but frees didn't; skip runerr (comment why: panic paths don't unwind, leak counts there are meaningless).

- [ ] **Step 2: Run and bless**

`go test ./internal/selfhost -run TestEmitDifferential -v` — for each failing program, READ the report: (a) if the leak is a runtime bug (unnoted process-lifetime block, missed free path), FIX it; (b) if it's a legitimate escaping-value leak per the spec, create `testdata/run/NAME.leaks` with the count and a `#`-less rationale? No — `.leaks` is one bare integer (readOptional-style); put the rationale in a comment in the fixture's `.cla` file instead. Target state: most programs 0, a handful with small documented counts.

- [ ] **Step 3: Full suite green** — `go test ./...`.

- [ ] **Step 4: Commit**

```bash
git add internal/selfhost/emit_test.go testdata/run/*.leaks testdata/run/lib/*.cla
git commit -m "selfhost: strict leak gate over the emitted corpus -- per-program .leaks goldens, default zero"
```

---

### Task 10: Docs, ROADMAP, final gates

**Files:**
- Modify: `docs/ROADMAP.md`
- Modify: `docs/superpowers/specs/2026-07-28-memory-audit-design.md` (dispositions table → final state)

- [ ] **Step 1: ROADMAP** — mark 4e DONE in the two places 4a–4d are marked (lines ~143 and ~218), with a "Done item"-style summary: Memory Manager shim (`rt_mem.h`/`rt_mem_host.inc`), unified `rt_core.inc`, dispose API, conservative frees (temps/locals/globals/window vars), rt_ser fix, leak-gate goldens. Remove the now-fixed "Handle-backed window vars never freed" small-open-item (lines ~260–263). Add to the follow-on list: **ARC milestone** (refcount + retain/release lowering + deep frees + all `.leaks` goldens to zero; sound and complete — no recursive types → no cycles) and the optional parameter-escape-summary precision upgrade.
- [ ] **Step 2: Spec** — update the dispositions table's rows to past tense where fixed; record the paranoia two-tier decision if Task 1 step 6 didn't already.
- [ ] **Step 3: Final gates** — `go test ./...` AND `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 40m` AND the bootstrap-from-C check: `cc -std=c99 -I internal/build/rt -o /tmp/boot clarusc/clarusc.c internal/build/rt/rt.c && /tmp/boot emit -o /dev/null clarusc/main.cla` (or `check` subcommand per main.cla's CLI) — the ground-floor path with the shim included.
- [ ] **Step 4: Commit**

```bash
git add docs/ROADMAP.md docs/superpowers/specs/2026-07-28-memory-audit-design.md
git commit -m "docs: 4e memory audit complete -- dispositions recorded, ARC follow-on scheduled"
```

Then: whole-branch final review (most capable model) + one consolidated fix wave, per the project convention. Merge to main only on Andrew's request.
