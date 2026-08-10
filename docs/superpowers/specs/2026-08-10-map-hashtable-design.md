# map/sortedmap/intmap redesign (2026-08-10)

First implementation phase driven by the native compiler performance
findings (`2026-08-10-native-compiler-performance-findings.md`, finding
2.2 and the Layer 1 map-laundering findings 1.2/1.1). Branch stacks on
`mac-resident-clarusc` (user decision, 2026-08-10).

## Goal

Replace `map of T`'s sorted-array implementation (256-byte key blocks,
O(n) memmove insert, log-n call-heavy lookup) with a real hashtable,
preserve the old implementation as a new `sortedmap of T` type for code
that needs ordered iteration, add `intmap of T` (int keys, key-as-hash),
and migrate the compiler's int-keyed string maps to `intmap`. `map`
stays a drop-in replacement usage-wise: no example or non-map-test
program changes.

## Language surface

- `map of T` — unchanged syntax and methods (`m[k]`, `m.get(k,dv)`,
  `m.has(k)`, `m.remove(k)`, `m.count`, `for k, v in m`), string keys
  ≤255 bytes. **Semantic change: iteration order is no longer sorted** —
  the reference will say order is *unspecified but deterministic* (a
  given sequence of inserts/removes always yields the same order, and
  the host and native lanes agree byte-for-byte). Anything needing
  ordered iteration migrates to `sortedmap`.
- `sortedmap of T` — new type; today's `map` implementation and
  semantics verbatim, including the ascending-byte-order iteration
  guarantee. Same method surface as `map`.
- `intmap of T` — new type; same method surface, but keys are `int`
  (`m[42] = v`, `m.get(7, dv)`, `for k, v in m` iterates `int` keys).
- Serialization (`file.save`/`load`): `map of` record keeps working.
  `sortedmap`/`intmap` payloads are **not** serializable in this phase
  (build-time error, same as today's unsupported payloads). YAGNI.
- Reference updates: Ch. 3 Maps section rewritten (order guarantee
  moved to sortedmap), new sortedmap/intmap sections, type grammar
  (`docs/clarus-language-reference.md:1664`), the two type-table rows
  (`:120,161` — and `:161`'s "hashtable" claim finally becomes true).

## Runtime design (both lanes, identical algorithm)

One layout shared by `map` and `intmap`, differing only in key storage,
key compare, and hash:

- **Dense entry storage in insertion order**: parallel key/value arrays
  exactly like today, minus the sort. `rtMapKeyAt(m, i, …)` /
  `rtMapValAt(m, i, …)` keep their index-based contract over
  `0..count-1`, so `for k, v in m` lowering is untouched.
- **Separate open-addressed hash index**: power-of-two capacity, linear
  probing, entry indices as slots. All modular arithmetic is
  `and (cap-1)` — no divide (the findings doc's 2.3: div is a
  32-iteration software loop on 68k).
- **Hash**: strings use djb2 (`h = (h<<5) + h + byte` — shift+add only,
  no multiply, cheap on 68000). `intmap` uses the key itself as the hash
  (arena/intern indices are dense sequences — identity hashing spreads
  them perfectly under a power-of-two mask).
- **Keys**: `map` stores variable-length key bytes in a byte pool
  (offset+len per entry) — the fixed 256-byte key blocks are gone.
  `intmap` stores the 4-byte int key directly in the entry.
- **Growth**: rehash at ~3/4 load by doubling the index; entry arrays
  keep the existing geometric growth. Rehash walks the dense entries —
  O(n), amortized O(1) per insert.
- **Remove**: swap-last into the removed entry's dense slot, fix the
  moved entry's index slot, tombstone the removed index slot. Iteration
  order after a remove changes — allowed (order is unspecified).
- **Determinism / cross-lane identity**: the host C runtime
  (`runtime/host/rt_core.inc`) and the native Clarus runtime
  (`runtime/clarus/map.cla`) implement byte-identical algorithms (same
  hash, same probe sequence, same growth thresholds, same swap-last
  remove), so program-visible iteration order is identical on both
  lanes — required by the mac-resident byte-identity acceptance and the
  suite goldens.
- `sortedmap` runtime = rename-copy of today's `rtMap*` code
  (`rtSortedMap*`), both lanes.

## Compiler support for the new types

- `types.cla`: new kinds `TySortedMap`, `TyIntMap` alongside `TyMap`
  (elem = value type, as today).
- `parse.cla`: `sortedmap of T` / `intmap of T` in type positions
  (same contextual-identifier mechanism `map` uses).
- `check.cla`: method/index checking shared with map; `intmap` keys
  check as `int` (index, get/has/remove, iteration key var).
- `lower.cla` + both backends (`cg68k.cla`, `cprint.cla`): intrinsics
  route to `rtSortedMap*` / `rtIntMap*` names; ARC
  (retain/release/lastref, deep-release walks) extended to the new
  kinds; default-init emits the right `*New`.
- Module placement: `intmap` lives inside `runtime/clarus/map.cla`
  (shares the hash-index helpers; map.cla is already in the
  unconditional splice, and the compiler itself will use intmap).
  `sortedmap` gets its own `runtime/clarus/sortedmap.cla`, spliced
  **only when the program uses the type** (same usage-flag mechanism as
  `ser.cla`'s `usesFileSaveLoad`) — never adding dead lines to every
  compile. `shake.cla`'s unconditional root set gains the new RC entry
  points only for the always-spliced kinds (same reason the map ones
  are there).
- The old Go compiler is already deleted (go-compiler-final); no
  action. `internal/selfhost` regen instructions handle the snapshot.

## Bootstrap staging (the snapshot dance)

The committed `clarusc/clarusc.c` snapshot must compile the compiler
source at every step:

1. **Stage A — land the feature.** Runtime (both lanes) + compiler
   support for all three types. Compiler source does NOT use
   `sortedmap`/`intmap` yet. Core suite green on host; regenerate the
   snapshot (`TestSnapshotFixedPoint` instructions).
2. **Stage B — migrate the compiler.** With the new snapshot as
   bootstrap, switch compiler-internal tables to `intmap` where the key
   is conceptually an int:
   - `exprTypeOf[numToStr(e)]` and the seven sibling tables
     (findings 1.2) → `intmap` keyed by the arena index directly
     (deletes the `numToStr` calls too).
   - Scope name tables (`types.cla` `Scope.names`) and other
     nameIdx-keyed tables → `intmap` keyed by the interned index
     (deletes the `poolGet` de-intern round trips, findings 1.8).
   - `strIndex` (the intern pool) stays a string `map` — it becomes a
     real hashtable for free, which is most of findings 1.1's cost.
   - Ordering-dependent internal uses (if any turn up) → `sortedmap`.
   Regenerate the snapshot again to fixed point.

## Tests

- `testsuite/core/cases_map.cla`: drop/reshape any case that assumes
  sorted iteration (ordering-only cases are removed, per user
  direction); everything else unchanged — map is a drop-in.
- New `cases_sortedmap.cla`: copy of the *original* map cases renamed —
  unchanged bodies except type/case names (the code is the same).
- New `cases_intmap.cla`: copy of the map cases with int keys.
- `runner.cla`/`cli.cla` enum + dispatch grow the new cases.
- Gates, per user direction: **core suite on host** after each task
  (compose recipe from CLAUDE.md) — no full T2. The UI/toolbox suite
  runs **once at the very end** on the native lane. If hash-order
  iteration shifts any blessed golden output (uiblob/ser byte layouts),
  re-bless via the native lane and note it — goldens pin behavior, and
  iteration order is now explicitly unspecified.
- `scripts/test-task.sh` (T1) additionally runs `internal/testsuite` /
  host-side checks as today; `TestSnapshotFixedPoint` gets its regen at
  each stage boundary.

## Non-goals

- No user-visible `map` API changes; no edits to examples or non-map
  tests (byte-identical behavior except iteration order).
- No dense-`list`-instead-of-map optimization for arena-indexed tables
  (findings 1.2's alternate remedy) — `intmap` is the uniform tool this
  phase; revisit only if profiling still points there.
- No ser support for the new types; no Retro68/cprint-lane opt-in runs;
  no Go-compiler work.

## Risks

- **Golden/byte drift**: any compiler-output path that iterates a `map`
  (uiblob descriptors, ser descriptors, segment tables) may emit in a
  different (still deterministic) order → forks differ from
  pre-change builds. That's expected and fine — the fixed-point/
  byte-identity checks compare new-vs-new, not new-vs-old — but the
  first Stage A snapshot regen will show a large diff. Verify
  determinism (two consecutive builds byte-identical), not stability
  against the past.
- **Cross-lane divergence** is the dangerous failure mode: a single
  algorithmic difference between rt_core.inc and map.cla (probe order,
  growth threshold) silently breaks host↔native byte identity. The
  suites cover it (`Catalog`, ser roundtrips, and the mac-resident
  acceptance later); implement from one shared pseudocode spec in the
  plan.
- **ARC edge cases** in the new kinds (deep release of value records
  containing text/list) — reuse map's existing walk machinery; the
  toolbox `Catalog`/core list/map cases cover the shapes.
