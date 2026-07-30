# Native 5c′ — Runtime Migration Wave 2a (mem/ARC in Clarus) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port reference counting (retain/release/lastref), the rc over-release
guard, and birth allocation for text/list/map from C (`rt_core.inc`) to Clarus
(`runtime/clarus/{text,list,map}.cla`), so the non-UI runtime is fully Clarus
before 5d's native backend — verified on the existing cprint→Retro68 path.

**Architecture:** The 5b playbook, inverted at one seam: the "rc is
READ-NEVER-WRITTEN in Clarus" boundary moves — rc arithmetic, the dispose
sequences, and birth field-initialization become Clarus code poking through the
existing layout-guarded overlay records; the `*NewRaw` whole-box delegation to C
collapses. What stays C: the host leak ledger (`rt_mem_host.inc`, host-only
debug infrastructure), the `rt_register_cleanup` function-pointer slot (Clarus
has no function pointers), the allocation floor (`NewPtr`/`NewHandle` reached
via waist externs), and the C originals in `rt_core.inc` forever (frozen Go
compiler's backend + differential oracle).

**Tech Stack:** Clarus runtime modules over the 5a waist (`external func` →
`rt_ext_*` shims, overlay records, ptr/peek/poke); cprint redirect flags;
Go test harnesses; gated Retro68/Mini vMac suite.

**Design decisions (adjudicated during 5d brainstorm, 2026-07-30):**
- Prerequisite of 5d: the native backend links only Clarus-generated code, so
  ARC logic must be Clarus before codegen68k exists. Recorded in
  `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`.
- **Birth moves to Clarus** (not the lazy keep-delegation option): a native
  build cannot call `rt_ext_TextNewRaw` — its body is C logic, not a Toolbox
  trap. Birth must be expressible as waist calls (`NewPtr`, `NewHandle`) plus
  overlay pokes.
- **rc guard as cold-path extern:** Clarus release checks `rc <= 0` and only
  then calls a per-family `*RcCheck` extern (host: ledger-tagged abort,
  matching `rt_rc_check`; Mac: no-op, matching today). No hot-path cost.
- **cprint scope:** redirect every emitter of `rt_{text,list,map}_{retain,
  release,free}` and `rt_{list,map}_lastref` strings, and route the
  walk-internal `rt_list_at`/`rt_list_count`/`rt_map_val_at`/`rt_map_count`
  calls (inside `cpEmitRelease`/`cpEmitRetain`) through the wave-1 ported
  functions while we are editing those walks. The pure *addressing* sites
  (`fpIndexRef` cprint.cla:914, `fpForListStmt` :2617, `IListSet` :1907,
  `IListRemove` :1872) and the other STAYS-C strings (lasterr reads,
  `rt_arr_check`, `rt_enum_from_int`, `fpUiEditStmt` arms, `rt_list_note`,
  file I/O) STAY C — they don't block 5d (codegen68k lowers IR directly, it
  never sees cprint's C strings). Record them as 5d input.
- **Not ported, ever:** `rt_mem_host.inc` (466 lines, host-only ledger/guards/
  quarantine — the leak gates read it), `rt_mem.h` seam,
  `rt_register_cleanup`/`rt_run_cleanup`, `rt_rc_check`'s host body.
- **`rt_text_lastref` is dead API** (zero cprint emission sites; text has no
  elements to walk). Do not port it; do not invent a Clarus equivalent.

## Global Constraints

(Verbatim from the wave-1 plan; all still binding.)

- The Go compiler (`internal/`) is FROZEN. All new behavior lands in clarusc
  (`clarusc/*.cla`) and the runtime (`runtime/clarus/`, `internal/build/rt/`,
  `runtime/mac/`).
- Every commit that touches `clarusc/*.cla` regenerates the snapshot in the
  same commit:
  `go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla && /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla`
  and re-emits changed emitui goldens with that same binary.
- Churn rule: logic commit first, then a separate re-bless commit for
  snapshot/golden churn.
- New host runtime C is `.inc`-included from `rt.c`, never a new `.c` TU —
  `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`
  must keep working.
- `rt_ext_host.inc` and `runtime/mac/rt_ext_mac.inc` mirror each other
  function-for-function; every wrapper change edits BOTH files in the same
  commit.
- `clarusc/*.cla` must not USE new language features; no new tokens.
- New-syntax fixtures never land in `testdata/{valid,errors,run,run/lib,
  runerr,include,diag,suite}` or as driver-level syntax in
  `clarusc/test/*_test.cla`; safe homes: string-embedded cases in
  `clarusc/test/check_test.cla`, `testdata/lowlevel/`, `testdata/emitui/`,
  `testdata/rtinc/`.
- UAF/double-free invariant: leaks acceptable and documented; unsafe frees
  never.
- The gauntlet, per family task, in this order:
  `go test ./internal/selfhost` (differential + leak gates + snapshot),
  `go test ./internal/sertest ./internal/lowlevel ./internal/emitui`,
  `go test ./...`. Differential runs under
  `CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1` with `.leaks` goldens —
  **zero `.leaks` churn expected in this entire wave** (rc semantics are
  identical); any `.leaks` diff is a port bug, not a re-bless.
  CLRD goldens (`testdata/sertest/clrd_goldens/`) likewise untouched.
- Gated Mac gate where a task says so:
  `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestSuiteOnMac`
  (full suite with `-timeout 40m` in the final task).
- Branch: `native-5c` off main. Merge only on request.

---

### Task 1: ARC waist externs in both shim files

**Files:**
- Modify: `internal/build/rt/rt_ext_host.inc`
- Modify: `runtime/mac/rt_ext_mac.inc`
- Test: existing suites (pure addition; wrappers are unreferenced until Task 2)

**Interfaces:**
- Consumes: `rt_mem_tag_of` (rt_mem_host.inc:415), `rt_core_oom`
  (rt_core.inc:230), Toolbox/macro `NewHandle`/`DisposeHandle`/`DisposePtr`.
- Produces (host names; Mac mirrors use real Toolbox calls, RcCheck a no-op):
  - `void *rt_ext_TextNewHandle(int32_t n)` — NewHandle(n), `rt_core_oom()` on NULL
  - `void rt_ext_TextDisposeHandle(void *h)`
  - `void rt_ext_TextRcCheck(void *box, int32_t rc)` — host: mirror
    `rt_rc_check`'s host branch (rt_core.inc:768-774: fprintf tag via
    `rt_mem_tag_of` + abort); Mac: empty body
  - Same trio for List and Map prefixes, PLUS `void *rt_ext_ListNewPtr(int32_t)`
    / `rt_ext_MapNewPtr` (oom-panic on NULL, like `rt_ext_TextNewPtr`
    rt_ext_host.inc:178) and `rt_ext_ListDisposePtr` / `rt_ext_MapDisposePtr`
    (Text already has NewPtr/DisposePtr).

- [ ] **Step 1: Write the wrappers in `rt_ext_host.inc`**, appended to each
  family's section, following the exact style of the existing per-family
  aliases (one-line bodies, comment stating which Clarus module owns them).
  RcCheck host body (adapted from rt_core.inc:768-774):

```c
void rt_ext_TextRcCheck(void *box, int32_t rc) {
    if (rc <= 0) {
        fprintf(stderr, "rt: over-release of %s (rc=%d)\n",
                rt_mem_tag_of(box), (int)rc);
        abort();
    }
}
```

- [ ] **Step 2: Mirror all wrappers into `runtime/mac/rt_ext_mac.inc`** —
  identical names/signatures; NewHandle/Dispose bodies call the real Toolbox;
  all three `*RcCheck` bodies are empty (`(void)box; (void)rc;`).
- [ ] **Step 3: Verify host bootstrap still compiles:**
  `cc -I internal/build/rt -o /tmp/boot-check clarusc/clarusc.c internal/build/rt/rt.c && rm /tmp/boot-check`
- [ ] **Step 4: Run `go test ./...`** — expected all green (no behavior change).
- [ ] **Step 5: Run the gated Mac link gate** (compiles rt_ext_mac.inc):
  `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestSuiteOnMac`
- [ ] **Step 6: Commit** — `runtime: ARC waist externs (Text/List/Map RcCheck,
  NewHandle, DisposeHandle/Ptr) in both shims`. No snapshot regen (no
  clarusc/*.cla change).

---

### Task 2: text — birth + retain/release in Clarus, cprint redirect

**Files:**
- Modify: `runtime/clarus/text.cla` (externs :70-94, rtTextNew :140, header
  RC-boundary comment)
- Modify: `internal/build/rt/rt_ext_host.inc` + `runtime/mac/rt_ext_mac.inc`
  (DELETE `rt_ext_TextNewRaw`, host :170 / mac :151)
- Modify: `clarusc/cprint.cla` (flag near :103; sites :1391-1450 area, :1710,
  :2997, :3012/:3069 text-element releases inside walks, :3148, fpHeapFn :337)
- Modify: `clarusc/main.cla` (flag set beside `neededMods.add("text.cla")`,
  :429-472 block)
- Test: `testdata/lowlevel/arc2_text.cla` + `.out` (new), full gauntlet

**Interfaces:**
- Consumes: Task 1 externs (`TextNewHandle`, `TextDisposeHandle`,
  `TextRcCheck`), existing `TextNewPtr`/`TextDisposePtr`, the `RtText` overlay
  record in text.cla (extend with an `rc` field if not present — field order
  and offsets EXACTLY per `struct rt_text` in rt_core.inc, which
  `rt_text_layout_check` at rt_core.inc:271 pins).
- Produces: `func rtTextRetain(t: ptr)`, `func rtTextRelease(t: ptr)` —
  emitted C names `clar_fn_rtTextRetain`/`clar_fn_rtTextRelease`, both taking
  the box pointer; `rtTextNew(): ptr` now constructs entirely in Clarus.
  cprint flag `cpTextArcPorted` (unconditional true).

- [ ] **Step 1: Write the failing fixture** `testdata/lowlevel/arc2_text.cla`:
  a program that binds a text to two variables, reassigns one, discards the
  other in a scope, prints the survivor — `.out` asserts content; the harness
  (lowlevel_test.go:127) asserts live==0 under strict+paranoid. Run
  `go test ./internal/lowlevel -run TestLowlevel` — passes TODAY against the C
  path; this fixture is the regression net, so verify it passes BEFORE the
  port, not after. (The failure-first step here is Step 4's grep instead.)
- [ ] **Step 2: Port in text.cla.** C references to transcribe exactly,
  following the module's existing null-check and overlay idioms:
  - `rtTextNew` (replacing the `TextNewRaw()` delegation at :140): box =
    `TextNewPtr(<sizeof rt_text — compute from the overlay/layout-check>)`;
    poke `rc=1`, `len=0`, `cap=0`; `h = TextNewHandle(0)`; poke it. Mirrors
    `rt_text_new` rt_core.inc:278-288.
  - `rtTextRetain` mirrors rt_core.inc:800-805: null-safe, `rc = rc + 1`.
  - `rtTextRelease` mirrors rt_core.inc:807-816: null-safe; read rc; `if rc <=
    0 { TextRcCheck(t, rc) }`; decrement; if now 0 →
    `TextDisposeHandle(<h field>)` then `TextDisposePtr(t)`.
  - Update the header's "RC boundary" comment: rc is now Clarus-owned for
    text; the C originals remain as the Go compiler's backend only.
  - Add `external func` decls for the Task 1 externs; delete the `TextNewRaw`
    decl and both shim wrappers.
- [ ] **Step 3: Redirect in cprint.cla + main.cla.** Add
  `var cpTextArcPorted: bool` beside cpMapPorted (:103); set
  `cpTextArcPorted = true` in main.cla beside text.cla's neededMods line.
  Gate every text ARC emission with the wave-1 arm shape
  (`if cpTextArcPorted { fpEmit("clar_fn_rtTextRelease((void*)" ... } else { <old> }`),
  cast rules per cprint.cla:1455-1474:
  - `IRetain`/`IRelease` text arms (:1448/:1450)
  - `ITextFreeVar` (:1710) → `clar_fn_rtTextRelease` (rt_text_free is an
    alias of release, rt_core.inc:817 — do not create a separate rtTextFree)
  - `cpEmitRetain` text arm (:3148); `cpEmitRelease` text arm (:2997)
  - text-element releases INSIDE the list walk (:3012 region) and map walk
    (:3069 region)
  - `fpHeapFn` (:337) text `_retain`/`_release` stem compositions
  - Confirm `fpRetainVal`/`fpReleaseVal` (:385/:407) dispatch through the
    gated arms (they are what `cpEmitOneRcWalk`, `cpEmitWinReleaseFn`, and
    `cpEmitGlobalsInit`'s cl_free_globals use — if any of those emit literal
    `rt_text_` strings instead, gate them too).
- [ ] **Step 4: Grep-verify** `grep -n '"rt_text_retain\|"rt_text_release\|"rt_text_free' clarusc/cprint.cla`
  — every remaining hit must be inside an `else` (un-ported) arm.
- [ ] **Step 5: Run the gauntlet** (order per Global Constraints). Expected:
  all green, ZERO `.leaks` and CLRD golden churn; emitui `.c.golden` diffs
  expected (redirected emission shape) — regenerate with the fresh binary.
- [ ] **Step 6: Commit logic** — `runtime: text ARC + birth ported to Clarus
  (rtTextRetain/Release, Clarus-side rtTextNew)`; **then re-bless commit** for
  snapshot + emitui goldens.

---

### Task 3: list — birth + retain/release in Clarus, cprint redirect, walk routing

**Files:**
- Modify: `runtime/clarus/list.cla` (externs :89-93, rtListNew :144, header)
- Modify: both `rt_ext_*.inc` (DELETE `rt_ext_ListNewRaw`, host :206 / mac :179)
- Modify: `clarusc/cprint.cla` (flag; `IRelease`/`IRetain` list arms :3150
  region, :3064; list walk in `cpEmitRelease` :3012-3060; `IListFreeVar`;
  fpHeapFn list stems; `rt_list_lastref` gates :3012/:3023/:3057)
- Modify: `clarusc/main.cla` (set `cpListArcPorted = true`)
- Test: `testdata/lowlevel/arc2_list.cla` + `.out` (new), full gauntlet

**Interfaces:**
- Consumes: Task 1 List externs; `RtList` overlay (extend with `rc` if absent;
  layout pinned by `rt_list_layout_check` rt_core.inc:510); wave-1
  `rtListAt`/`rtListCount` (list.cla) for walk routing.
- Produces: `rtListRetain(l: ptr)`, `rtListRelease(l: ptr)`,
  `rtListLastref(l: ptr): bool`; Clarus-side `rtListNew(elemsize: int): ptr`;
  flag `cpListArcPorted`.

- [ ] **Step 1: Fixture first** `testdata/lowlevel/arc2_list.cla`: list-of-text
  built, aliased, elements popped/overwritten, list discarded mid-scope,
  another list survives to print — `.out` + live==0. Verify green against C
  path before porting.
- [ ] **Step 2: Port in list.cla.** `rtListNew` mirrors rt_core.inc:512-523
  (box via `ListNewPtr`, poke rc=1/count=0/cap=0/elemsize, `data =
  ListNewHandle(0)`); `rtListRetain` :819; `rtListRelease` :826-835 (guard →
  decrement → if 0: `ListDisposeHandle(data)`, `ListDisposePtr(l)`);
  `rtListLastref` :794 (`l != null and rc == 1`). Delete ListNewRaw decl +
  wrappers. Update RC-boundary header.
- [ ] **Step 3: Redirect in cprint.cla:** `cpListArcPorted` flag; gate
  `IRetain`/`IRelease` list arms, `IListFreeVar`, `cpEmitRetain` list arm
  (:3150), `cpEmitRelease` list arm (:3064), fpHeapFn list stems, and the
  three `rt_list_lastref` walk gates (:3012/:3023/:3057) →
  `clar_fn_rtListLastref`. **Also route the walk-internal element accessors**
  hardcoded in `cpEmitRelease`/`cpEmitRetain` (`rt_list_at` :3012/:3023/:3059,
  `rt_list_count`) through `cpListPorted` (the wave-1 flag, already
  unconditionally true) → `clar_fn_rtListAt`/`clar_fn_rtListCount`. The four
  ADDRESSING sites (:914, :2617, :1907, :1872) stay C — add a doc comment at
  fpIndexRef :914 naming them 5d input.
- [ ] **Step 4: Grep-verify** `grep -n '"rt_list_retain\|"rt_list_release\|"rt_list_free\|"rt_list_lastref' clarusc/cprint.cla` — hits only in else-arms.
- [ ] **Step 5: Gauntlet** — green, zero `.leaks`/CLRD churn, emitui re-bless.
- [ ] **Step 6: Commit logic, then re-bless commit.**

---

### Task 4: map — birth + retain/release in Clarus, cprint redirect, walk routing

**Files:**
- Modify: `runtime/clarus/map.cla` (externs :107-111, rtMapNew :263, header
  incl. the five STAYS-C sites doc at :58-65)
- Modify: both `rt_ext_*.inc` (DELETE `rt_ext_MapNewRaw`, host :229 / mac :195)
- Modify: `clarusc/cprint.cla` (flag; map arms :3152/:3100; map walk
  :3069-3100; `IMapFreeVar`; fpHeapFn map stems; `rt_map_lastref` gates
  :3069/:3081/:3091; `fpMapReleaseGuard` :1266 release call)
- Modify: `clarusc/main.cla` (set `cpMapArcPorted = true`)
- Test: `testdata/lowlevel/arc2_map.cla` + `.out` (new), full gauntlet

**Interfaces:**
- Consumes: Task 1 Map externs; `RtMap` overlay (+`rc`; layout pinned by
  `rt_map_layout_check` rt_core.inc:620); wave-1 `rtMapValAt`/`rtMapCount`.
- Produces: `rtMapRetain(m: ptr)`, `rtMapRelease(m: ptr)`,
  `rtMapLastref(m: ptr): bool`; Clarus-side `rtMapNew(valsize: int): ptr`
  (box + TWO handles: keys, vals — mirror rt_core.inc:622-636 field by
  field); flag `cpMapArcPorted`.

- [ ] **Step 1: Fixture first** `testdata/lowlevel/arc2_map.cla`: map-of-text
  and map-of-list-of-text; upsert over existing keys (exercises
  fpMapReleaseGuard eviction), remove, alias, discard — `.out` + live==0.
  Green against C path first.
- [ ] **Step 2: Port in map.cla.** `rtMapNew` mirrors rt_core.inc:622-636;
  `rtMapRetain` :847; `rtMapRelease` :854-864 (guard → decrement → if 0:
  dispose keys handle, vals handle, box); `rtMapLastref` :795. Delete
  MapNewRaw decl + wrappers. Update headers (the fpUiEditStmt STAYS-C note at
  :58-65 gains a line: ARC now Clarus, edit-family still C).
- [ ] **Step 3: Redirect in cprint.cla:** `cpMapArcPorted`; gate map
  retain/release arms, `IMapFreeVar`, `cpEmitRetain`/`cpEmitRelease` map
  arms, fpHeapFn map stems, the three `rt_map_lastref` gates →
  `clar_fn_rtMapLastref`, and `fpMapReleaseGuard`'s release call (:1266 — its
  has/get pair is already redirected at :1277). Route walk-internal
  `rt_map_val_at`/`rt_map_count` through `cpMapPorted` →
  `clar_fn_rtMapValAt`/`clar_fn_rtMapCount`.
- [ ] **Step 4: Grep-verify** `grep -n '"rt_map_retain\|"rt_map_release\|"rt_map_free\|"rt_map_lastref\|"rt_map_val_at' clarusc/cprint.cla` — hits only in
  else-arms or documented STAYS-C sites (fpUiEditStmt map arm keeps
  `rt_map_get_dv` ungated, by design).
- [ ] **Step 5: Gauntlet** — green, zero `.leaks`/CLRD churn, emitui re-bless.
- [ ] **Step 6: Commit logic, then re-bless commit.**

---

### Task 5: emission sweep + adversarial matrix extension

**Files:**
- Modify: `clarusc/cprint.cla` (only if the sweep finds stragglers)
- Create: `testdata/lowlevel/arc2_nested.cla` + `.out`,
  `testdata/lowlevel/arc2_globals.cla` + `.out`
- Test: `go test ./internal/lowlevel ./internal/selfhost`

**Interfaces:**
- Consumes: everything Tasks 2-4 produced.
- Produces: a verified, documented exclusion list (what still emits `rt_*`
  memory calls and why), mirrored in the three module headers.

- [ ] **Step 1: Full sweep:**
  `grep -n '"rt_\(text\|list\|map\)_\(retain\|release\|free\|lastref\)\|"rt_register_cleanup\|"rt_list_note' clarusc/cprint.cla`
  Every hit must be (a) inside an un-ported else-arm, or (b) on the
  documented STAYS-C list (`rt_register_cleanup` — C function-pointer slot;
  `rt_list_note` — ledger exemption, called from rt.c only). Route anything
  else found (window-release fn :4356 and cl_free_globals :5024-5027 are the
  likely stragglers if Step 3 of Task 2 missed a literal).
- [ ] **Step 2: New probes.** `arc2_nested.cla`: list-of-map-of-text built,
  aliased at every level, inner containers evicted via upsert, outer
  discarded; deep-release ordering is the target. `arc2_globals.cla`: global
  text/list/map assigned, reassigned, program exits normally —
  cl_free_globals under the strict ledger is the target. Both `.out` +
  live==0. Run: `go test ./internal/lowlevel -run TestLowlevel -v` — PASS.
- [ ] **Step 3: Run `go test ./internal/selfhost && go test ./...`** — green.
- [ ] **Step 4: Commit** (+ re-bless commit only if Step 1 changed cprint).

---

### Task 6: docs, ROADMAP, final gates

**Files:**
- Modify: `docs/ROADMAP.md` (Plan 5 section: 5c′ outcome entry)
- Modify: `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`
  (Resequencing section: mark 5c′ landed; list the recorded 5d inputs — the
  four C addressing sites, lasterr/arr_check/enum_from_int/file/print
  runtime-logic inventory still in C)
- Modify: `runtime/clarus/{text,list,map}.cla` headers if any exclusion-list
  wording is stale
- Test: everything

**Interfaces:**
- Consumes: all prior tasks.
- Produces: the wave's outcomes record; a green branch ready for review.

- [ ] **Step 1: Write the ROADMAP entry** under "Native 68k toolchain
  (Plan 5)", same shape as the 5b entry: what moved (rc arithmetic, dispose
  sequences, birth construction ×3 families), what stayed C and why (ledger,
  cleanup hook, rc-check host body, C originals as Go backend), the
  zero-`.leaks`-churn result, and the 5d-input list.
- [ ] **Step 2: Final gates, in order:**
  1. `go test ./... -count=1` — full, uncached.
  2. `cc -I internal/build/rt -o /tmp/boot clarusc/clarusc.c internal/build/rt/rt.c && rm /tmp/boot`
  3. `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 40m` — full
     gated suite (31 tests); expected same ballpark as the 5b baseline
     (157s / Bookmarks ≈9.8s — ported ARC still compiles through gcc -O2,
     no naive-codegen cost yet).
- [ ] **Step 3: Commit docs** — `docs: 5c' landed (runtime wave 2a — mem/ARC
  in Clarus); ROADMAP + 5d-input inventory`.
- [ ] **Step 4: STOP — merge only on request** (finishing-a-development-branch
  skill from here).

---

## Self-review notes

- Spec coverage: birth ✓ (Tasks 2-4 Step 2), rc arithmetic ✓ (same), guard ✓
  (Task 1 + release bodies), redirects ✓ (Tasks 2-4 Step 3, sweep Task 5),
  walk routing ✓ (Tasks 3-4), stays-C boundary ✓ (header + Task 5/6 docs).
- The `rc` overlay-field addition in Tasks 2-4 assumes wave-1 overlays may
  lack the field; implementers verify against the layout-check typedefs
  before poking — offsets are pinned there, not guessed.
- `.leaks`-zero-churn is asserted in every gauntlet run, making the
  differential corpus an rc oracle, not just an output oracle.
