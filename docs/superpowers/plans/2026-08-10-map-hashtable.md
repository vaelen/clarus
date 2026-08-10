# map/sortedmap/intmap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `map of T`'s sorted-array runtime with a real hashtable, add `sortedmap of T` (the old implementation, ordered iteration) and `intmap of T` (int keys, identity hash), then migrate the compiler's int-keyed string maps to `intmap`.

**Architecture:** Dense insertion-order entry arrays + separate open-addressed power-of-two hash index (djb2 for strings, identity for ints, all mod-by-mask), implemented byte-identically in both runtime lanes (`runtime/clarus/map.cla` for emitted programs, `runtime/host/rt_core.inc` C for host shims/ungated C sites). New types are purely contextual in the parser (zero lexer changes). Two snapshot regenerations: after the feature lands (Stage A) and after the compiler migrates to intmap (Stage B).

**Tech Stack:** Clarus (self-hosted clarusc), C (host runtime), Go test harness (gates only).

**Spec:** `docs/superpowers/specs/2026-08-10-map-hashtable-design.md`. Background: `docs/superpowers/specs/2026-08-10-native-compiler-performance-findings.md` (findings 1.1, 1.2, 2.2).

## Global Constraints

- Branch: stack all commits on the current worktree branch (based on `mac-resident-clarusc`).
- **Per-task gate:** `scripts/test-task.sh` (T1, ~15s). NO `--smoke`, NO T2, NO `internal/selfhost` until the plan says so (user direction: core suite only; UI suite once at the very end).
- **The current-compiler recipe** (needed because test programs use new syntax the committed snapshot doesn't know; the snapshot compiler must still COMPILE the compiler + runtime sources, which never use new syntax until Task 10):
  ```sh
  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  ```
  `/tmp/cur` is "the current compiler" wherever a task says so.
- **Core-suite run** (the user's "core test suite"):
  ```sh
  /tmp/cur emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
      testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
  cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
  /tmp/core_cli all   # nonzero exit on any FAIL
  ```
- **Append new enum members at the END of every enum they join** (`TypeKind`, `TypeExprKind`, IR `K*` kinds, `CoreTest` before `SelfCheck`) — inserting mid-enum renumbers later members and invalidates goldens.
- Do not edit `examples/`, `testdata/` fixtures, or any test not directly about maps — EXCEPT where a test's expectation depends on map iteration order (Task 4 enumerates the known sites).
- `map of T` stays a drop-in replacement: same syntax, same methods, same panic messages (`"map key not found"`), same `get`/`get_dv`/`remove` contracts. Only iteration order changes.
- Both lanes must implement the **identical** algorithm (same hash, probe order, growth thresholds, swap-last remove) — host↔native byte-identity and golden stability depend on it. All hash arithmetic is masked to 31 bits (`and 0x7FFFFFFF`) each step so signed-overflow semantics can never diverge between lanes.
- The compiler and runtime `.cla` sources must remain compilable by the COMMITTED snapshot until Task 9 completes; only Task 10 may introduce new-type syntax into `clarusc/*.cla`.
- Subagent staffing (CLAUDE.md): `sonnet` for implementation and review tasks; `haiku` acceptable for the mechanical copies in Tasks 1 and 8.
- Commit after every task (message style: `feat(map): …` / `test(map): …` / `docs: …`).

## Shared design constants (referenced by Tasks 5–7)

New box layout, shared by `map` and `intmap` (one `overlay record` per lane pinned by a C layout guard):

```
overlay record RtMap {        // struct rt_map, same order
    rc: int                   // refcount
    keys: ptr                 // Handle: per-entry meta array (see stride below)
    vals: ptr                 // Handle: count * valsize value bytes (unchanged role)
    valsize: int
    count: int                // live entries; dense 0..count-1
    cap: int                  // entry capacity of keys array
    valcap: int               // entry capacity of vals array
    keypool: ptr              // Handle: raw key bytes end-to-end (map); ptr(0) for intmap
    poolused: int             // bytes used in keypool
    poolcap: int              // byte capacity of keypool
    index: ptr                // Handle: indexcap int32 slots: entry idx, EMPTY, TOMB
    indexcap: int             // power of two; 0 until first insert
    tombs: int                // tombstone count in index
}
```

- Entry meta stride: map = 12 bytes `{hash:int32, keyOff:int32, keyLen:int32}`; intmap = 4 bytes `{key:int32}`.
- Index slot values: `EMPTY = -1`, `TOMB = -2`, else entry index. Fresh/grown index slots are all EMPTY.
- Hash (map): djb2 masked per step — `h = 5381; for each byte b: h = (((h << 5) + h) + b) and 0x7FFFFFFF`. Hash (intmap): `h = key and 0x7FFFFFFF`.
- Probe: `slot = h and (indexcap - 1)`, then `slot = (slot + 1) and (indexcap - 1)` (linear). Lookup remembers the first TOMB seen for insert reuse; lookup stops at EMPTY.
- Match test (map): stored `hash == h`, then `keyLen == klen`, then byte compare against keypool. (intmap): stored `key == k`.
- Growth: initial `indexcap = 8` on first insert; rehash (doubling) when `(count + tombs) * 4 >= indexcap * 3`; rehash walks dense entries `0..count-1` re-inserting by stored hash, resets `tombs = 0`. Entry/vals/keypool arrays grow by the existing doubling-`SetHandleSize` pattern (`rtMapGrowKeys`/`rtMapGrowVals` shape).
- Remove: find via index; TOMB its index slot; if the removed entry is not last, copy entry `count-1`'s meta+value into its slot and update the MOVED entry's index slot (find it by the moved entry's stored hash + key compare); `count -= 1`. Abandon the removed key's pool bytes.
- `clear`: `count = 0; tombs = 0; poolused = 0;` index slots all EMPTY (capacity kept).
- Box size consts: `rtMapBoxSize = 112` (14 fields × conservative 8-byte slots, same reasoning as today's 56 — comment must carry it).
- Iteration contract: `rtMapKeyAt`/`rtMapValAt` unchanged signatures, walking dense entries `0..count-1` (insertion order, perturbed by removes). `rtIntMapKeyAt(m, i): int` RETURNS the key (int) instead of filling a Str255.

Runtime name families: `rtSortedMap*` = exact copy of today's `rtMap*` set. `rtIntMap*` = `New/Set/Get/GetDv/Has/Remove/Count/Clear/KeyAt/ValAt/Retain/Release/Lastref` with `key: int` replacing `key: ptr`. Intrinsic name families: `sortedmap_set`, `sortedmap_set_retain`, `sortedmap_get`, `sortedmap_get_dv`, `sortedmap_get_dv_birth`, `sortedmap_has`, `sortedmap_remove`, `sortedmap_count`, `sortedmap_free_var`; same nine with `intmap_` prefix.

---

### Task 1: `sortedmap` runtime copy (both lanes' extern seams)

**Files:**
- Create: `runtime/clarus/sortedmap.cla`
- Modify: `runtime/host/rt_ext_host.inc` (after the Map wrappers, `:96-100` and `:275-300`)
- Modify: `runtime/mac/rt_ext_mac.inc` (after the Map wrappers, `:96-100` and `:234-255`)

**Interfaces:**
- Produces: `rtSortedMapNew(valsize: int): ptr`, `rtSortedMapSet(m, key, val: ptr)`, `rtSortedMapGet(m, key, out: ptr)`, `rtSortedMapGetDv(m, key, out: ptr): bool`, `rtSortedMapHas(m, key: ptr): bool`, `rtSortedMapRemove(m, key: ptr)`, `rtSortedMapCount(m: ptr): int`, `rtSortedMapClear(m: ptr)`, `rtSortedMapKeyAt(m: ptr, i: int, key255: ptr)`, `rtSortedMapValAt(m: ptr, i: int, out: ptr)`, `rtSortedMapRetain/Release/Lastref` — identical bodies to today's `runtime/clarus/map.cla` (:184-:541), renamed.
- Produces: extern wrappers `rt_ext_SortedMapHandleDeref/SetHandleSize/BlockMoveData/NewPtr/DisposePtr/NewHandle/DisposeHandle/RcCheck` in both `.inc` files, byte-parallel to the `rt_ext_Map*` set.

- [ ] **Step 1:** Copy `runtime/clarus/map.cla` → `runtime/clarus/sortedmap.cla`. Rename every `rtMap` → `rtSortedMap`, `Map`-prefixed extern → `SortedMap`-prefixed (`MapHandleDeref` → `SortedMapHandleDeref`, etc.), `RtMap` overlay → `RtSortedMap`, `MAP_KEYBLOCK` → `SORTEDMAP_KEYBLOCK`, `mapKeySlot/mapValSlot/mapLowerBound/mapKeyEq/mapFind` → `sortedmap*`-prefixed, `rtMapBoxSize` → `rtSortedMapBoxSize`. Rewrite the header comment: this is the preserved sorted implementation backing the new `sortedmap of T` type (ascending-key iteration contract), conditionally spliced (Task 2). Bodies otherwise byte-identical — no logic changes.
- [ ] **Step 2:** Add the `rt_ext_SortedMap*` wrapper functions to `runtime/host/rt_ext_host.inc` and `runtime/mac/rt_ext_mac.inc` — copy each `rt_ext_Map*` wrapper in the `:275-300`/`:234-255` blocks under the new name, delegating to the same primitives. (The `:96-100` `rt_ext_MapCount`-family aliases are ser-era leftovers — do NOT copy those five.)
- [ ] **Step 3:** Type-check the new module composed with its dependencies (declare-before-use order):
  ```sh
  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot runtime/clarus/core.cla runtime/clarus/str.cla runtime/clarus/sortedmap.cla
  ```
  Expected: exit 0, no diagnostics.
- [ ] **Step 4:** Run `scripts/test-task.sh`. Expected: green (nothing references the new file yet).
- [ ] **Step 5:** Commit: `feat(sortedmap): preserve sorted map implementation as rtSortedMap* (both lanes' extern seams)`

### Task 2: `sortedmap of T` through the compiler

**Files:**
- Modify: `clarusc/types.cla` (`:46` enum — append `TySortedMap` at END; `:224-232` add `sortedMapT(val)`; `:441`/`:491` assignable/typesEqual arms)
- Modify: `clarusc/ast.cla` (`:266` append `TxSortedMap` at enum END; `:2062-2076` add `newSortedMapType`/`sortedMapTypeVal`)
- Modify: `clarusc/parse.cla` (`:645-648` add `else if nStr == "sortedmap"` arm)
- Modify: `clarusc/check.cla` (mirror every TyMap site listed below; add `usesSortedMap` flag)
- Modify: `clarusc/lower.cla`, `clarusc/ir.cla` (KSortedMap + intrinsics + SForMap reuse)
- Modify: `clarusc/cprint.cla`, `clarusc/cg68k.cla` (backend arms)
- Modify: `clarusc/shake.cla` (roots), `clarusc/drive.cla` (conditional splice)
- Modify: `docs/clarus-language-reference.md` (sortedmap section + grammar `:1664` + type-table rows `:120,161`)
- Test: `/tmp/sortedmap_smoke.cla` (scratch, not committed)

**Interfaces:**
- Consumes: `rtSortedMap*` family from Task 1.
- Produces: `TySortedMap` (types.cla), `TxSortedMap` (ast.cla), `KSortedMap` (ir.cla), `sortedMapT(val: int): int`, `irSortedMapType(elem: int): int`, IR intrinsic helpers `ISortedMapSet()` … `ISortedMapFreeVar()` (nine, per Shared design constants), `var usesSortedMap: bool` (check.cla, reset alongside `usesFileSaveLoad` at `check.cla:5003`).

The complete TyMap site checklist to mirror (from the integration fact sheet — every line is a place needing a TySortedMap twin arm; treat any `TyMap` grep hit not listed here the same way):
- check.cla: `:1714-1729` resolveType TxMap arm (set `usesSortedMap = true` inside the new TxSortedMap arm — the type's mere mention triggers the splice); `:1523-1568` checkMapMethod (reuse by passing the kind through, keys stay `strT(255)`); `:1598-1600` dispatch; `:4487-4493` index read (`"map index must be string"` message reused); `:3869-3877` for-k-v arm; `:977-979` typeName (`"sortedmap of "`); `:1041-1043` kindName; `:1417` anyRecordish (do NOT add — sortedmap stays non-serializable); `:2650`; `:3602`; `:4409-4412` compare-reject; `:4617` `.count` select.
- lower.cla: `:287` lowType; `:1033-1034` method dispatch; `:1320-1360` lowMapMethod twin (emit `ISortedMap*` names); `:1494-1495` index read; `:1756-1757` count; `:3488-3500` index assign; `:2767-2779` for-map lowering (SForMap node REUSED — no new stmt kind; backends key off `irtKind(irExprType(irForMapMapV(s)))`); `:2984-2985` + `:5817-5818` free-var selection; `:2643-2645` edit stmt — do NOT add (edit stays map-only; the checker's existing TyMap-only acceptance already rejects it).
- ir.cla: `:44/:104` KSortedMap (append at kind-enum END); `:1165` irtNeedsCtor; `:1182-1184` irSortedMapType; `:3066-3122` the nine `ISortedMap*()` helpers.
- cprint.cla: new dispatch arms in the `fpIntrCall5` map-family block (`:2562-2798`) emitting `clar_fn_rtSortedMap*` (ALWAYS ported — no raw `rt_sortedmap_*` C fallback exists or is wanted; guard with the new `cpSortedMapPorted` flag and `cpUnsupported` if false); `:3743-3751` default-init arm → `clar_fn_rtSortedMapNew(sizeof(...))`; `:3912-3990` cpEmitRelease + `:4052-4058` cpEmitRetain + `:433/:504-506/:590` retain/release-val arms; `:715` C type (`rt_sortedmap *` — emit a `typedef struct rt_sortedmap rt_sortedmap;` via cpEnsureType or reuse `rt_map *`? NO: since no C code ever touches one, emit `void *` is tempting but breaks style — declare `typedef struct rt_sortedmap rt_sortedmap;` in the preamble cprint already emits, body never defined in C); `:951` cpElemKey (`"sortedmap"`); `:992-993` cpEnsureType; `:1104/:658/:4176` handle-kind predicates; `:4616-4667` cpEmitDefaultInitFnProtos gate — add `(cpSortedMapPorted and (nm == "rtSortedMapNew" or nm == "rtSortedMapValAt" or nm == "rtSortedMapCount" or nm == "rtSortedMapRetain" or nm == "rtSortedMapRelease" or nm == "rtSortedMapLastref"))`; `:3391-3435` fpForMapStmt — branch on the map expr's IR kind to call the `rtSortedMap*` accessors; `:1709-1740` fpMapReleaseGuard twin.
- cg68k.cla: dispatch arms for the nine `"sortedmap_*"` strings in `cgIntr` (`:6470-6501` block) plus the store-path re-tests at `:4767-4772` and `:8668-8673` — parameterize the existing `cgIntrMapSet/cgIntrMapGet/cgIntrMapGetDv/cgIntrMapRemove` helpers with the runtime-name prefix rather than duplicating them; `:2526-2527` default-init → `rtSortedMapNew`; `:3264-3269` cgDeepReleaseContainer name selection + `:3203-3204` caller; `:2735-2736` cgRetainAt / `:2770` cgReleaseAt; `:9243-9310` cgForMapStmt kind branch; `:9075-9107` cgMapReleaseGuard twin; `:1186` slot classification; `:1485` cgKindName; `:3127/:3156/:9374/:9343` handle-kind predicates.
- shake.cla: conditional roots — mirror the `:547-570` `IMap*` walk arms for `ISortedMap*`; mirror the `:352-360` SForMap arm to root `rtSortedMapKeyAt`/`rtSortedMapValAt` when the iterated expr is KSortedMap; add the six ARC/default-init names (`rtSortedMapNew/ValAt/Count/Retain/Release/Lastref`) to the unconditional root list `:257-274` — they no-op harmlessly when sortedmap.cla isn't spliced (verify `shakeFuncIdxByName` lookup tolerates absence; it does — `map.get(name, -1)` returns -1) — and update the header's "17 names" count and the sync note both here and at cprint.cla `:4592-4615`.
- drive.cla: in `driveManifestSplice` after the map entry (`:1031-1033`): `if usesSortedMap { cpSortedMapPorted = true; neededMods.add("sortedmap.cla") }` — mirror ser.cla's `:1044-1047` pattern (splice order: after map.cla, before ser.cla). Also mirror in `driveEarlySplice` (`:812-832`) — add unconditionally there like map, since `--testapi` splices everything early (match the existing style; check whether ser.cla is in the early list — mirror whatever ser does).

- [ ] **Step 1:** Land the type plumbing (types/ast/parse/check) per the checklist. `usesSortedMap` is set in resolveType's TxSortedMap arm and cleared in the checker reset beside `usesFileSaveLoad = false` (`check.cla:5003`).
- [ ] **Step 2:** Land lowering + IR + both backends + shake + drive per the checklist.
- [ ] **Step 3:** Write `/tmp/sortedmap_smoke.cla`:
  ```
  func main() {
      var m: sortedmap of int
      m["c"] = 3
      m["a"] = 1
      m["b"] = 2
      var out: text
      for k, v in m {
          out.append(k)
          out.append(numToText(v))
      }
      print(out)     // must print a1b2c3 — ascending-key order
      m.remove("b")
      print(numToText(m.count))   // 2
  }
  ```
  (Adjust to the language's real entry-point/print idioms — follow `testdata/run/lib/collections.cla`'s conventions.) Run: `scripts/clarus-run.sh /tmp/sortedmap_smoke.cla`. Expected: sorted output. NOTE: clarus-run.sh bootstraps from the SNAPSHOT, which cannot parse `sortedmap` — instead compile with the current-compiler recipe: `/tmp/cur emit --rtdir runtime/clarus/ -o /tmp/sm.c /tmp/sortedmap_smoke.cla && cc -O1 -I runtime/host -o /tmp/sm /tmp/sm.c runtime/host/rt.c && /tmp/sm`.
- [ ] **Step 4:** Verify a program NOT using sortedmap does not splice it: `/tmp/cur emit --rtdir runtime/clarus/ -o /tmp/nosort.c testdata/run/lib/collections.cla` then `grep -c rtSortedMap /tmp/nosort.c` → expected `0`.
- [ ] **Step 5:** Update `docs/clarus-language-reference.md`: new "Sorted maps" subsection after Maps (`:331-343`) carrying the ascending-order guarantee verbatim from the old Maps text; grammar production at `:1664` (`| "sortedmap" "of" type`); type-position list `:120`; type-table row after `:161`. Do NOT change the Maps section itself yet (Task 5 does).
- [ ] **Step 6:** Run `scripts/test-task.sh`. Expected: green.
- [ ] **Step 7:** Commit: `feat(sortedmap): sortedmap of T language type, conditionally spliced`

### Task 3: sortedmap test cases

**Files:**
- Create: `testsuite/core/cases_sortedmap.cla`
- Modify: `testsuite/core/runner.cla` (enum `:23-64`, `nCoreCases :73`, `coreCaseName :79+`, `coreAllCases :225-269`, `runCoreTests :291-480`)
- Modify: `internal/mactest/suite_host_test.go:88-101` (`coreCLIFiles`), `internal/testsuite/core_cli_test.go:62-77`, `internal/cg68k/segment_test.go:65`, `scripts/size-68k.sh:47`

**Interfaces:**
- Consumes: `sortedmap of T` from Task 2; `tkPass/tkFail/TestResult` from `testsuite/kit.cla`.
- Produces: `CoreTest` members `SortedMapSetCount`, `SortedMapHasRemove`, `SortedMapOfListUpsert`, `SortedMapIterOrder`; case funcs `caseSortedMapSetCount()` etc.

- [ ] **Step 1:** Copy `testsuite/core/cases_map.cla` → `testsuite/core/cases_sortedmap.cla`; rename each case (`caseMapSetCount` → `caseSortedMapSetCount`, tkPass/tkFail name strings likewise) and change every `map of` → `sortedmap of`. Bodies otherwise unchanged (user direction: the code is the same, tests shouldn't change).
- [ ] **Step 2:** Add ONE new case the copy set lacks — the ordering contract that now belongs to sortedmap alone:
  ```
  func caseSortedMapIterOrder(): TestResult {
      var m: sortedmap of int
      var out: text
      m["b"] = 2
      m["c"] = 3
      m["a"] = 1
      for k, v in m {
          out.append(k)
      }
      if out != "abc" {
          return tkFail("SortedMapIterOrder", "iteration not ascending")
      }
      m.remove("b")
      out = ""
      for k2, v2 in m {
          out.append(k2)
      }
      if out != "ac" {
          return tkFail("SortedMapIterOrder", "post-remove order wrong")
      }
      return tkPass("SortedMapIterOrder")
  }
  ```
  (Match kit.cla's actual text-comparison idioms.)
- [ ] **Step 3:** Register all four in runner.cla: enum members appended immediately BEFORE `SelfCheck`; `nCoreCases` 42 → 46; `coreCaseName` cases; `coreAllCases` adds; `runCoreTests` branches (uniform `if wantAll or coreHas(...)` shape, `casesRun` incremented). cli.cla needs NO edit (name matching iterates `coreAllCases()`).
- [ ] **Step 4:** Add `cases_sortedmap.cla` to the four Go/shell file lists (paths above, keep alphabetical-ish placement next to `cases_map.cla`).
- [ ] **Step 5:** Build + run the core suite (Global Constraints recipe). Expected: 45 passes + SelfCheck pass.
- [ ] **Step 6:** Run `scripts/test-task.sh`. Expected: green.
- [ ] **Step 7:** Commit: `test(sortedmap): copy map cases + ascending-iteration contract case`

### Task 4: make map-order-dependent expectations order-agnostic (pre-switch)

**Files (the known iteration sites — sweep `grep -rn "for .*, .* in" --include=*.cla testsuite testdata` to confirm the list is complete):**
- Modify: `testsuite/core/cases_map.cla` (comment `:12-15` claims "iteration must come back sorted" — reword: order unspecified)
- Inspect/modify only if order-dependent: `testsuite/core/cases_list.cla:93,114`; `testdata/cg68k/smoke.cla:193,219`; `testdata/run/lib/emit_map.cla:71`, `breakcont.cla:112,123`, `collections.cla:91`, `for_loop_var_alias.cla:89,110`; `testdata/sertest/roundtrip.cla`; plus whatever the sweep adds.

**Interfaces:** none (test-only task).

- [ ] **Step 1:** For each site, decide: (a) order-insensitive already (single entry, last-write-wins over all entries, aggregate sum) → leave, note in the task report; (b) asserts sorted map order incidentally → rewrite the assertion order-agnostically (aggregate, or `has`-based, or sort the collected keys before comparing); (c) exists SPECIFICALLY to check map ordering → delete the assertion (user direction), and where that leaves a fixture meaningless, note it for the ROADMAP entry. Any fixture with a committed stdout golden (`internal/selfhost` behavior goldens, `clarusc/test/*.out`) whose text would change: prefer rewriting the fixture to print order-agnostically NOW so the golden survives both implementations; do NOT regenerate goldens in this task.
- [ ] **Step 2:** `testdata/sertest/roundtrip.cla`: confirm it asserts VALUES after reload (order-agnostic) rather than byte-comparing the saved file. If it byte-compares, rewrite to value assertions.
- [ ] **Step 3:** Build + run the core suite. Expected: green (old sorted implementation still in place — order-agnostic tests must pass under BOTH orders; that's the point).
- [ ] **Step 4:** Run `scripts/test-task.sh`. Expected: green.
- [ ] **Step 5:** Commit: `test(map): make iteration-order expectations order-agnostic ahead of hashtable switch`

### Task 5: `map` hashtable rewrite — both lanes in lockstep

**Files:**
- Modify: `runtime/clarus/map.cla` (full rewrite of layout + lookup machinery; public `rtMap*` signatures unchanged)
- Modify: `runtime/host/rt_core.inc:589-756` (struct rt_map `:603-611`, layout guard `:620`, all `rt_map_*`; the `:589-598` CONTRACT banner)
- Modify: `runtime/host/rt.h` (comment updates only — signatures unchanged)
- Modify: `docs/clarus-language-reference.md:331-343` (Maps section: order now unspecified-but-deterministic, pointer to sortedmap) and the `:161` row
- Test: `testsuite/core/cases_map.cla` (new hashtable-stress cases), `testsuite/core/runner.cla`

**Interfaces:**
- Consumes: Shared design constants (box layout, djb2, probe/growth/remove rules) — implement EXACTLY as written there, in both lanes.
- Produces: unchanged public signatures: `rtMapNew/Set/Get/GetDv/Has/Remove/Count/Clear/KeyAt/ValAt/Retain/Release/Lastref` and `rt_map_*` C twins. New internal helpers (both lanes, same names modulo case convention): `mapHash(key) `, `mapIndexLookup(m, hash, key) -> entryIdx or -1`, `mapIndexSlotFor(m, hash, key) -> slot` (insert position, reusing first tombstone), `mapIndexInsert(m, hash, entryIdx)`, `mapRehash(m)`, `mapGrowEntries(m, need)`, `mapPoolAppend(m, key) -> keyOff`.
- CoreTest members produced: `MapGrowRehash`, `MapRemoveSwap`, `MapIterComplete`, `MapLongKeys`.

- [ ] **Step 1 (failing tests first):** Add four cases to `cases_map.cla` + runner registration (`nCoreCases` 46 → 50):
  - `caseMapGrowRehash`: insert 200 distinct keys (`"k" + numToStr(i)` style — build keys with the suite's existing string idioms), then verify `count == 200` and 10 spot keys `get` correctly (crosses several rehashes: 8→16→…→512).
  - `caseMapRemoveSwap`: insert `a..j` (10), remove 5 interleaved with lookups, verify `count`, removed keys `has == false`, survivors all `get` correctly, then re-insert two removed keys and verify.
  - `caseMapIterComplete`: insert 20 keys with known int values summing to S; `for k, v in m` accumulate `sum += v` and `seen += 1`; verify `seen == 20 and sum == S` (order-agnostic completeness).
  - `caseMapLongKeys`: two 255-byte keys differing only in the last byte, plus the empty-string key `""`; verify all three store/retrieve independently.
  Run the core suite: the four new cases must PASS against the OLD implementation too (they're order-agnostic) — run and confirm green BEFORE the rewrite; they're the safety net, not a red/green TDD gate here. (The red/green pair for the rewrite itself is Step 4's determinism check plus the suite staying green across the swap.)
- [ ] **Step 2:** Rewrite `runtime/host/rt_core.inc`'s map section per Shared design constants: new `struct rt_map` (14 fields, order exactly as the overlay), new layout-check typedef (14-field anonymous struct twin), `MAP_KEYBLOCK` stays only where `rt_map_key_at`'s out-copy contract needs the Str255 width, all internal arithmetic `uint32_t`-masked to 31 bits exactly like the Clarus side. `rt_map_key_at` copies length byte + bytes from the pool into the caller's Str255. Keep panic messages byte-identical. Keep `rt_map_clear` semantics (capacity kept). NOTE the ungated C consumers that must keep working against the new struct: `fpUiEditStmt`'s `rt_map_get_dv` (cprint.cla:3198-3202 emission) and `rt_ser.inc:136-154`'s fallback.
- [ ] **Step 3:** Rewrite `runtime/clarus/map.cla` to the same algorithm: new `RtMap` overlay (14 fields), `rtMapBoxSize = 112`, helpers per Interfaces, all key/index access through freshly-derived master pointers (`MapHandleDeref` on every access — the relocation discipline in today's header comment MUST be preserved; the index and keypool are new Handles with the same discipline). `rtMapNew` births `keypool`/`index` as `MapNewHandle(0)` with `indexcap = 0`; first insert materializes the 8-slot index. `rtMapRelease`'s rc==0 path disposes keys, vals, keypool, index, then the box — extend the existing order.
- [ ] **Step 4 (determinism + parity):** Build the core suite and run `all` — green. Then compile the same program twice and byte-compare: `/tmp/cur emit --rtdir runtime/clarus/ -o /tmp/d1.c testdata/cg68k/smoke.cla && /tmp/cur emit --rtdir runtime/clarus/ -o /tmp/d2.c testdata/cg68k/smoke.cla && cmp /tmp/d1.c /tmp/d2.c` — identical. Then host-run a ser roundtrip: compile `testdata/sertest/roundtrip.cla` with the current compiler, run it, expected pass (save→load through the new iteration order).
- [ ] **Step 5:** Update the language reference Maps section (`:331-343`): iteration bullet becomes "visits entries in an unspecified but deterministic order (a given sequence of inserts and removes always replays the same order); use `sortedmap of T` when ascending key order matters", and fix the `:161` row's description to match reality (true hashtable now). Update `rt_core.inc:589-598`'s CONTRACT banner the same way.
- [ ] **Step 6:** Run `scripts/test-task.sh`. Expected: green. If any T1 test fails on iteration order that Task 4 missed, fix it the Task-4 way (order-agnostic), note it, re-run.
- [ ] **Step 7:** Commit: `feat(map): replace sorted-array map with insertion-order hashtable (both lanes)`

### Task 6: `intmap` runtime (shared machinery inside map.cla)

**Files:**
- Modify: `runtime/clarus/map.cla` (append the `rtIntMap*` family; refactor shared helpers so map/intmap differ only in hash + key compare + key store, per the spec)

**Interfaces:**
- Consumes: Task 5's helpers (`mapIndexInsert`, `mapRehash` machinery).
- Produces: `rtIntMapNew(valsize: int): ptr`, `rtIntMapSet(m: ptr, key: int, val: ptr)`, `rtIntMapGet(m: ptr, key: int, out: ptr)`, `rtIntMapGetDv(m: ptr, key: int, out: ptr): bool`, `rtIntMapHas(m: ptr, key: int): bool`, `rtIntMapRemove(m: ptr, key: int)`, `rtIntMapCount(m: ptr): int`, `rtIntMapClear(m: ptr)`, `rtIntMapKeyAt(m: ptr, i: int): int`, `rtIntMapValAt(m: ptr, i: int, out: ptr)`, `rtIntMapRetain/Release/Lastref(m: ptr)`.

- [ ] **Step 1:** Implement per Shared design constants: same box layout (`keypool = ptr(0)`, `poolused/poolcap = 0` forever), entry meta stride 4 (`{key:int32}`), `hash = key and 0x7FFFFFFF`. Share the index-side helpers with map where the code genuinely doesn't touch keys (rehash walk re-derives hash: map reads stored hash, intmap recomputes from the stored key — either share via a tiny "hash of entry i" helper per family or accept a duplicated 15-line probe loop; do NOT contort the code to force sharing). `rtIntMapRelease` disposes the same handle set (keypool is an empty handle — birth it anyway so release stays uniform).
- [ ] **Step 2:** No C-lane twin: no C code path ever touches an intmap (no `edit` support, no ser support, cprint always emits `clar_fn_rtIntMap*`). State that in the family's header comment.
- [ ] **Step 3:** Type-check composed: `/tmp/boot runtime/clarus/core.cla runtime/clarus/str.cla runtime/clarus/map.cla`. Expected: clean. (The snapshot compiler CAN check this — the implementation is plain Clarus, no new syntax.)
- [ ] **Step 4:** Run `scripts/test-task.sh`. Expected: green.
- [ ] **Step 5:** Commit: `feat(intmap): rtIntMap* hashtable family sharing map.cla machinery`

### Task 7: `intmap of T` through the compiler

**Files:** same compiler-file set as Task 2, plus `docs/clarus-language-reference.md` (intmap section + grammar + tables).

**Interfaces:**
- Consumes: `rtIntMap*` from Task 6.
- Produces: `TyIntMap` (types.cla, appended after `TySortedMap`), `TxIntMap` (ast.cla), `KIntMap` (ir.cla), `intMapT(val)`, `irIntMapType(elem)`, `IIntMapSet()` … `IIntMapFreeVar()` (nine).

Differences from the Task 2 recipe (everything not listed mirrors Task 2's checklist mechanically):
- check.cla `:4487-4493` twin: index expr checked against `IntT`; diag `"intmap index must be int"`. checkMapMethod twin: `get(k,dv)`/`has(k)`/`remove(k)` take `IntT` keys. `:3869-3877` twin: `declareForVar(v1, IntT)`. `:4409-4412` compare-reject and `:4617` count arms mirror. anyRecordish: NOT added (not serializable).
- lower.cla: key args are ints — do NOT route keys through `lowCoerceStr` (`:1343`/`:3497` shapes); pass the int expr directly. For-map twin adds the key local as `IntT`'s IR type, not `irStrType(255)` (`:2770`).
- Backends' for-map arms: key variable is a 4-byte int slot; per iteration emit `k = rtIntMapKeyAt(m, ix)` (C: `cv_K = clar_fn_rtIntMapKeyAt((void*)mt, ix);`; 68k: JSR + store D0 to the frame slot) instead of the out-pointer Str255 copy.
- cprint.cla: `cpIntMapPorted` set `true` alongside `cpMapPorted` at drive.cla `:1031-1033` and `:831-832` (intmap lives in the always-spliced map.cla — no new splice entry, no usage flag). C type: `typedef struct rt_intmap rt_intmap;` never defined — same treatment as sortedmap. Key arguments emit as plain `int32_t` values, not `(void*)` casts.
- shake.cla: `IIntMap*` walk arms; SForMap arm roots `rtIntMapKeyAt/ValAt` for KIntMap exprs; add the six ARC/default-init names to the unconditional root list + cprint protos gate (they're always spliced — this one genuinely belongs in the unconditional set, unlike sortedmap's tolerated-absent entries). Update both sync comments and the count again.
- Reference: "Integer maps" section (methods with int keys, order wording identical to map's new wording, not serializable), grammar `| "intmap" "of" type`, `:120` list, type-table row.

- [ ] **Step 1:** Type plumbing (types/ast/parse/check) per above.
- [ ] **Step 2:** Lowering/IR/backends/shake/drive per above.
- [ ] **Step 3:** Smoke test (current-compiler recipe, like Task 2 Step 3): intmap with negative, zero, and large keys; get/get-dv/has/remove; `for k, v` summing keys and values; 200-entry growth. Expected output verified.
- [ ] **Step 4:** Reference updates per above.
- [ ] **Step 5:** Core suite + `scripts/test-task.sh`. Expected: green.
- [ ] **Step 6:** Commit: `feat(intmap): intmap of T language type`

### Task 8: intmap test cases

**Files:** Create `testsuite/core/cases_intmap.cla`; modify `testsuite/core/runner.cla` (+4 cases → `nCoreCases` 50 → 54) and the four Go/shell file lists (Task 3's paths).

**Interfaces:** Consumes `intmap of T`. Produces CoreTest members `IntMapSetCount`, `IntMapHasRemove`, `IntMapOfListUpsert`, `IntMapGrowIter`.

- [ ] **Step 1:** Copy `cases_map.cla`'s three original cases with int keys (`m[3] = 3; m[2] = 2; m[1] = 1` etc.; the map-of-list upsert case keyed by `42`). Add `caseIntMapGrowIter`: 200 sequential keys `i -> i*2`, verify count, spot gets, and an order-agnostic iteration sum; plus negative-key coverage (`m[-5]`).
- [ ] **Step 2:** Register in runner.cla + the four file lists (same recipe as Task 3 Steps 3–4).
- [ ] **Step 3:** Core suite green; `scripts/test-task.sh` green.
- [ ] **Step 4:** Commit: `test(intmap): map-family cases with int keys + growth/iteration case`

### Task 9: Stage A snapshot regeneration

**Files:** Modify `clarusc/clarusc.c` (regenerated artifact only).

- [ ] **Step 1:** Regenerate per the committed recipe (fixedpoint_test.go `:123-138`):
  ```sh
  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
  ```
- [ ] **Step 2:** Verify the fixed point without running the selfhost package: build the NEW snapshot (`cc -O1 -I runtime/host -o /tmp/gen2boot clarusc/clarusc.c runtime/host/rt.c`), emit again (`/tmp/gen2boot emit --rtdir runtime/clarus/ -o /tmp/gen3.c clarusc/main.cla`), `cmp /tmp/gen3.c clarusc/clarusc.c` → identical.
- [ ] **Step 3:** `scripts/test-task.sh` green (the snapshot now understands sortedmap/intmap; nothing in T1 changed behavior).
- [ ] **Step 4:** Commit: `chore(snapshot): regenerate clarusc.c with sortedmap/intmap + hashtable map (Stage A)`

### Task 10: migrate compiler internals to intmap (Stage B)

**Files:**
- Modify: `clarusc/check.cla`, `clarusc/types.cla`, `clarusc/ir.cla`, `clarusc/lower.cla`, `clarusc/shake.cla`
- Modify: `clarusc/clarusc.c` (second regeneration)

**Interfaces:** none new — internal representation changes only; all public behavior byte-identical (verified by Step 4's fork comparison).

The migration list (each item: change the declaration `map of X` → `intmap of X`, change writes/reads to key by the int directly, DELETE the `numToStr`/`poolGet` key round-trips at those sites):
- check.cla: `exprTypeOf` (`:588` decl, `:4848-4853` write, `exprTypeGet :594-596` read; lower.cla's 43 `exprTypeGet` call sites unaffected — the accessor signature keeps taking the expr index); `funcSigByDecl` (`:2170-2171` / `:2305,:2511,:2561-2562`); `funcScopeByDecl`/`funcRetByDecl` (`:2234-2235` / `:2627-2628`); `constUseIsStr`/`constUseInt`/`constUseStr` (`:4188-4192` / `:3982-3986`); `enumConstOf` (`:4202` / `:591,:3988-3989`). The checker-reset bulk clears at `:5003`-area reassign fresh intmaps.
- types.cla: `Scope.names` → `intmap of int` keyed by `nameIdx` — `scopeDeclare(scope, nameIdx, sym)` and `scopeLookup(scope, nameIdx)` (`:595-637`) drop their `poolGet(nameIdx)` de-intern; collapse the `has`+`get` double probe to one `get(key, -1)` while touching it. Sweep every `scopeDeclare`/`scopeLookup` caller for signature fallout (they already pass `nameIdx` — the change is internal).
- ir.cla: `irLayoutNeededByName` (`:733`), `irRcWalkNeededByName` (`:751`) → keyed by interned nameIdx.
- lower.cla: the `:3303`-area name-keyed table (verify its key population; migrate if int-keyed in nature, leave if genuinely string-keyed).
- shake.cla: `shakeFuncIdxByName` (`:80`) → `intmap of int` keyed by nameIdx; its populate/lookup sites (`:147` etc.) drop `poolGet`.
- Leave as string `map`: `strIndex` (lib.cla — the intern pool itself), `caseLabelKey`'s `seen` (`check.cla:3967-3993`), and every genuinely string-keyed table. When in doubt, leave it — this task is the mechanical subset.

- [ ] **Step 1:** Migrate check.cla's eight tables; core suite + `scripts/test-task.sh` green.
- [ ] **Step 2:** Migrate types.cla scopes, ir.cla, lower.cla (if applicable), shake.cla; gates green again.
- [ ] **Step 3 (behavior proof):** The compiler's OUTPUT must be unchanged: `/tmp/cur` (pre-migration, from Task 9's snapshot) and a freshly built post-migration compiler both emit `testdata/cg68k/smoke.cla` and `testdata/mac-resident/catprobe.cla`; `cmp` the emitted `.c` files → byte-identical. (Symbol tables affect only lookup speed, not resolution results — this is the proof.)
- [ ] **Step 4 (perf proof):** `time` the tickprobe compile before/after migration with a host build: `time <compiler> emit68k --rtdir runtime/clarus/ -o /tmp/tp.bin testdata/cg68k/tickprobe.cla`. Record both numbers in the commit message. (Baseline on this machine pre-phase: ~1.25s.)
- [ ] **Step 5:** Regenerate the snapshot (Task 9's Steps 1–2 verbatim — the Task 9 snapshot compiles the intmap-using source, then fixed-point again).
- [ ] **Step 6:** `scripts/test-task.sh` green.
- [ ] **Step 7:** Commit: `perf(clarusc): migrate int-keyed compiler tables to intmap (Stage B) + snapshot regen`

### Task 11: final verification + docs

**Files:** Modify `docs/ROADMAP.md` (phase entry); possibly re-blessed goldens.

- [ ] **Step 1:** Full core suite (host) green; determinism re-check (Task 5 Step 4's double-emit cmp).
- [ ] **Step 2:** The user-mandated single UI-suite run (needs the emulator + Retro68 toolchain):
  ```sh
  CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestToolboxSuiteOn68k' -count=1 -timeout 40m
  ```
  Expected: every fanned-out case subtest green on the native lane. If a failure traces to map iteration order in a golden (uiblob descriptor order, scenario trace), fix the expectation order-agnostically where possible; re-bless via `CLARUS_MAC_BLESS=1` ONLY for pure byte-layout goldens, and record exactly which goldens were re-blessed and why in the ROADMAP entry.
- [ ] **Step 3:** ROADMAP entry: phase summary, the map→hashtable semantic change (iteration order), new types, both snapshot regens, the perf numbers from Task 10 Step 4, and the explicit debt note: T2 (`internal/selfhost` + full native lane) NOT run this phase per user direction — first T2 run after this phase must expect `internal/selfhost` behavior-golden churn if any fixture prints map order (Task 4 tried to eliminate these; list any survivors), and `clarusc/test/*.out` module goldens may need regeneration.
- [ ] **Step 4:** Commit: `docs: map-hashtable phase ROADMAP entry`

## Self-review notes (already applied)

- Spec coverage: user steps 1→(T1–T3), 2→(T3), 3→(T4), 4→(T5), 5→(T6–T7), 6→(T8), 7→(T10); spec's splice/flag design → T2; snapshot dance → T9/T10; core-only gating → Global Constraints; UI-once-at-end → T11.
- The `edit` statement and ser stay map-only by construction (checker acceptance unchanged) — verified against the fact sheet, no task needed.
- `rtIntMapKeyAt` returns int (not out-ptr) — T6/T7 agree.
- Case counts: 42 → 46 (T3) → 50 (T5) → 54 (T8); each task updates `nCoreCases` and SelfCheck stays consistent.
