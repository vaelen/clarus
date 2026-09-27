# SE Wave 1 (Lifetimes) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the `bookmarks --rtbake` compile's peak heap from 11.79 MB to ≤ 6 MB (68k-equivalent). Do it by freeing what the compiler holds past its last use, and by adding `.release()`/`.shrink()` to the language.

**Architecture:** There are four independent tracks, run in parallel worktrees:
- the language feature;
- the front-end frees in `driveCompile`;
- the per-function measure reset in cg68k;
- bake install-by-move plus a re-parse on every compile.

The free sites then switch to `.release()`, the snapshot is regenerated once, and the memgate budgets ratchet down. End-of-wave gates plus an IIcx re-measure close the wave.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C99 host runtime, POSIX sh tests, Snow emulator (the wave close only).

**Spec:** `docs/superpowers/specs/2026-09-28-se-wave1-lifetimes-design.md` (umbrella: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`).

## Global Constraints

- **Branch and merging.** Branch `se-wave1-lifetimes`. `main` stays green. Merge only when Andrew asks.
- **Model.** Every implementer and reviewer runs on Opus (`model: opus`).
- **Per-task gate.** `scripts/test-task.sh` (T1, **no** `--smoke`; it includes `memgate/`). No emulator boots until Task 7.
- **Process safety.** Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write the `snow/`, `macplus/` or `macplus2/` pristine images.
- **grep.** `grep` here is ugrep and skips MacRoman files. Use `/usr/bin/grep -a` for any "who reads X" audit over `.cla` files.
- **Byte-identity** (spec §6). Every task except Task 1's new suite cases is byte-identical for compiled output. No existing golden may change: `testdata/cg68k/*.s`, emitui, `bake/`, selfhost behavior and module stdout, and the CLRD goldens. If one moves, stop and report.
- **Identity check for compiler-internal tasks (2, 3, 4, 5).** Run this before committing. It compiles with the committed snapshot and with the current sources into same-named outputs (MacBinary embeds the file name), and compares them:
  ```sh
  make -j tools bootstrap
  mkdir -p /tmp/claude-1000/idA /tmp/claude-1000/idB
  build-run/clarusc-snapshot --bake-ir --lane 68k --rtdir runtime/clarus/ -o /tmp/claude-1000/idA/rt.clir
  build-run/clarusc-current  --bake-ir --lane 68k --rtdir runtime/clarus/ -o /tmp/claude-1000/idB/rt.clir
  for f in bookmarks hello-mac texteditor tcpchat; do
    build-run/clarusc-snapshot emit68k --rtdir runtime/clarus/ -o /tmp/claude-1000/idA/$f.bin examples/$f.cla
    build-run/clarusc-current  emit68k --rtdir runtime/clarus/ -o /tmp/claude-1000/idB/$f.bin examples/$f.cla
    cmp /tmp/claude-1000/idA/$f.bin /tmp/claude-1000/idB/$f.bin || echo "DIFF src $f"
    build-run/clarusc-current emit68k --rtdir runtime/clarus/ --rtbake /tmp/claude-1000/idB/rt.clir -o /tmp/claude-1000/idB/$f.bin examples/$f.cla
    cmp /tmp/claude-1000/idA/$f.bin /tmp/claude-1000/idB/$f.bin || echo "DIFF rtbake $f"
    build-run/clarusc-snapshot emit --rtdir runtime/clarus/ -o /tmp/claude-1000/idA/$f.c examples/$f.cla
    build-run/clarusc-current  emit --rtdir runtime/clarus/ -o /tmp/claude-1000/idB/$f.c examples/$f.cla
    cmp /tmp/claude-1000/idA/$f.c /tmp/claude-1000/idB/$f.c || echo "DIFF C $f"
  done
  ```
  Expected: no `DIFF` line. The rtbake compile is checked against the snapshot's from-source output, because the bake twins guarantee that from-source and bake builds are equal. If `examples/tcpchat.cla` doesn't exist, use any two other `examples/*.cla`.
- **Snapshot.** Do not regenerate `clarusc/clarusc.c` except in Task 6. `selfhost/fixedpoint` failing before Task 6 is expected. Run `selfhost/modules` if a task touches `clarusc/test/*`, but not the rest of `selfhost/`.
- **Memgate.** Budgets may only be *lowered*, except as Task 1 allows (a written reason line in `tests/memgate/budget.txt`). The wave's final budgets are set in Task 6.
- **Commits.** Messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

0. **`.release()` on a name that shares its box with a live name** (a moved staging list, a harness-held `rtbakeBytes`) empties the live one too. Task 5's aliasing-trap rules forbid it, and `dblcompile_bake` plus the identity check catch it.
1. **`release()` on an alias** (`b = a; a.release()`): `b` sees count 0 and stays usable, with no dangling data handle. Task 1's `ReleaseShrink` case asserts this.
2. **`release()` on a list of text or a map of records**: the elements are freed too, not just the handle, with no leak and no double free under the suite's normal run. Task 1 asserts it through the host storage test, under `CLARUS_MEM_STRICT`.
3. **`shrink()` on a map after deletes**: the contents and lookups stay correct (`has`/`get` for surviving keys, and insertion order). Task 1's case deletes, shrinks, then checks every surviving key and `for` order.
4. **A second compile in one process after the frees**: it compiles identically. The frees and re-parse must leave every global in a state `driveReset`/`astReset` accept. `mactest/dblcompile`, `dblcompile_abort` and `dblcompile_bake` (all host, all T1) cover this. Tasks 2 and 4 must run them explicitly.
5. **The drift fallback** (the CLIR manifest drifted, so `driveCompile` re-runs from source) must still work after `rtbakeBytes` is freed early. Task 4 runs `bake/drift_fallback` (or the script that covers it) and checks it does not read the freed bytes.

## Tracks and waves

| Wave | Tasks (parallel within a wave)                                            | Worktrees                                                   |
|------|----------------------------------------------------------------------------|-------------------------------------------------------------|
| A    | 1 `.release()`/`.shrink()` · 2 front-end frees · 3 measure reset · 4 bake staging | one worktree per task; the controller merges each after review |
| B    | 5 switch free sites to `.release()`, plus the Wave 0 doc minors            | branch tip                                                   |
| C    | 6 snapshot regen + memgate ratchet + census (**serialization point**)      | branch tip, alone                                            |
| D    | 7 IIcx re-measure, docs, end-of-wave gates (controller-driven)             | branch tip                                                   |

Tasks 2, 3 and 4 touch different regions of `drive.cla`, `cg68k.cla` and `bake.cla`. Task 1 touches `cg68k.cla`'s intrinsic dispatch, and Task 3 touches `cg68Measure`: different regions again, so git merges them. The controller merges Wave A in the order 3, 2, 4, 1, and re-runs T1 after each merge.

Worktree setup (controller): `git worktree add -b w1-tN ../clarus-w1-tN se-wave1-lifetimes`, plus absolute symlinks for the untracked `snow/ macplus/ macplus2/ vasm/` (to `/home/andrew/repos/clarus/<d>`), `Retro68` (to `/home/andrew/repos/Retro68`) and `toolchain` (to `/home/andrew/repos/Retro68-build/toolchain`).

---

### Task 1: `.release()` and `.shrink()` (additive: new suite cases only)

**Files:**
- Modify: `runtime/clarus/list.cla`, `map.cla`, `sortedmap.cla`, `text.cla` (new runtime functions next to each `*Clear`)
- Modify: `clarusc/check.cla` (`checkListMethod` ~l.2099, `checkMapMethod` ~l.2170, `textOnlyMethods` ~l.1604)
- Modify: `clarusc/ir.cla` (intrinsic-name getters, near `IListClear`/`IListClearDeep` ~l.3942-3955 and `ITextReserve` ~l.3620)
- Modify: `clarusc/lower.cla` (`lowListMethod` ~l.2212 / `clear` arm ~l.2282; `lowMapMethod` ~l.2316-2350; text ~l.2475)
- Modify: `clarusc/shake.cla` (`shakeWalkIntr` ~l.565)
- Modify: `clarusc/cprint.cla` (`fpIntrCall4` ~l.3266, `fpIntrCall10` ~l.3596, `fpIntrCall13` ~l.4013)
- Modify: `clarusc/cg68k.cla` (`rn*` vars ~l.243/301, interns ~l.396/452, `cgIntr` ~l.8924; deep path `cgClearDeepContainer` ~l.9324)
- Modify: `docs/clarus-language-reference.md` (entries next to l.337, 353, 368, 385, 399; plus `tests/reftest/manifest.txt` if new rust fences shift indices, as in Wave 0 Task 2)
- Modify: `testsuite/core/cases_list.cla`, `testsuite/core/runner.cla`, `tests/testsuite/core_cases.txt`, `tests/mactest/coresuite_68k.sh`, `tests/mactest/coresuite_mac.sh`, `CLAUDE.md` (core case count, 5 places)
- Create: `testdata/lowlevel/release_storage.cla`, `tests/hostrt/release_storage.sh`

**Interfaces:**
- Produces (user surface): `xs.release()` and `xs.shrink()` for `list of T`, `map of T`, `intmap of T`, `sortedmap of T` and `text`. Both are statements with no result.
- Produces (runtime): `rtListDropStorage(l: ptr)`, `rtListShrink(l: ptr)`, `rtMapDropStorage(m: ptr)`, `rtMapShrink(m: ptr)` (intmap reuses the map pair; it shares `RtMap`), `rtSortedMapDropStorage(m: ptr)`, `rtSortedMapShrink(m: ptr)`, `rtTextDropStorage(t: ptr)`, `rtTextShrink(t: ptr)`.
- Produces (IR intrinsic names; spec L4, never "release"): `list_drop_storage`, `list_drop_storage_deep`, `list_shrink`, `map_drop_storage`, `map_drop_storage_deep`, `map_shrink`, `sortedmap_drop_storage`, `sortedmap_drop_storage_deep`, `sortedmap_shrink`, `intmap_drop_storage`, `intmap_drop_storage_deep`, `intmap_shrink`, `text_drop_storage`, `text_shrink`. Follow the existing per-family naming pattern if `clear` uses different spellings; keep "drop_storage"/"shrink" in every name.
- Consumed by Task 5: `xs.release()` on compiler globals of type `list of <record>`, `list of string`, `list of int`, `map`, `intmap` and `text`.

**Semantics (spec L1–L3):**
- **Aliasing.** Both methods act on the shared box in place.
- **`release()`.**
  - Run exactly what `clear()` runs for that container, including the deep element-release walk when `clear()` would use it.
  - Then call `rt<Type>DropStorage`. That sets every handle the box owns to size 0 with the type's `*SetHandleSize` extern, and sets every count and capacity field to 0 (map: `count cap valcap poolused poolcap indexcap tombs`; sortedmap: `count cap valcap`; text: `len cap`).
  - It never allocates or frees the box.
- **`shrink()`.**
  - List: `SetHandleSize(data, count*elemsize)`, then `cap = count`.
  - Text: `SetHandleSize(h, len)`, then `cap = len`.
  - Sortedmap: trim keys and vals to count, then `cap = valcap = count`.
  - Map/intmap: trim entries (`keys`), `vals` and `keypool` to what is in use, and leave `index` alone. Read `map.cla` first: if entries stay dense after deletes (compacted), "in use" is `count`. If deleted entries leave holes, trim to the highest occupied entry slot instead, and say which in the runtime comment.
  - It releases no elements.

- [ ] **Step 1: Write the failing tests**

  **(a) The core case.** Append to `testsuite/core/cases_list.cla`:

```
func caseReleaseShrink(): TestResult {
    var l: list of int
    var b: list of int
    var ls: list of string
    var m: map of int
    var im: intmap of int
    var sm: sortedmap of int
    var t: text
    var i: int

    // list: release empties, stays usable
    i = 0
    while i < 100 {
        l.push(i)
        i = i + 1
    }
    l.release()
    if l.count != 0 {
        return tkFail("ReleaseShrink", "list release count")
    }
    l.push(7)
    if l.count != 1 or l.first() != 7 {
        return tkFail("ReleaseShrink", "list reuse after release")
    }

    // aliasing: release through one name is seen through the other
    b = l
    l.release()
    if b.count != 0 {
        return tkFail("ReleaseShrink", "alias did not see release")
    }
    b.push(9)
    if l.count != 1 or l.first() != 9 {
        return tkFail("ReleaseShrink", "alias reuse after release")
    }

    // shrink keeps contents
    i = 0
    while i < 50 {
        l.push(i)
        i = i + 1
    }
    l.shrink()
    if l.count != 51 or l.first() != 9 {
        return tkFail("ReleaseShrink", "list shrink contents")
    }
    l.push(99)
    if l.count != 52 {
        return tkFail("ReleaseShrink", "list push after shrink")
    }

    // element-bearing list
    ls.push("alpha")
    ls.push("beta")
    ls.release()
    if ls.count != 0 {
        return tkFail("ReleaseShrink", "list of string release")
    }
    ls.push("gamma")
    if ls.first() != "gamma" {
        return tkFail("ReleaseShrink", "list of string reuse")
    }

    // map: delete, shrink, every survivor still found, order kept
    m["a"] = 1
    m["b"] = 2
    m["c"] = 3
    m["d"] = 4
    m.remove("b")
    m.shrink()
    if m.count != 3 or m.get("a", -1) != 1 or m.get("c", -1) != 3 or m.get("d", -1) != 4 or m.has("b") {
        return tkFail("ReleaseShrink", "map shrink lookups")
    }
    m.release()
    if m.count != 0 or m.has("a") {
        return tkFail("ReleaseShrink", "map release")
    }
    m["z"] = 26
    if m.get("z", -1) != 26 {
        return tkFail("ReleaseShrink", "map reuse after release")
    }

    im[1] = 10
    im[2] = 20
    im.shrink()
    if im.get(2, -1) != 20 {
        return tkFail("ReleaseShrink", "intmap shrink")
    }
    im.release()
    if im.count != 0 or im.has(1) {
        return tkFail("ReleaseShrink", "intmap release")
    }
    im[5] = 50
    if im.get(5, -1) != 50 {
        return tkFail("ReleaseShrink", "intmap reuse")
    }

    sm["y"] = 2
    sm["x"] = 1
    sm.shrink()
    if sm.get("x", -1) != 1 or sm.get("y", -1) != 2 {
        return tkFail("ReleaseShrink", "sortedmap shrink")
    }
    sm.release()
    if sm.count != 0 or sm.has("x") {
        return tkFail("ReleaseShrink", "sortedmap release")
    }
    sm["w"] = 3
    if sm.get("w", -1) != 3 {
        return tkFail("ReleaseShrink", "sortedmap reuse")
    }

    // text
    t.append("hello world")
    t.shrink()
    if t.length != 11 {
        return tkFail("ReleaseShrink", "text shrink length")
    }
    t.release()
    if t.length != 0 {
        return tkFail("ReleaseShrink", "text release")
    }
    t.append("again")
    if t.length != 5 {
        return tkFail("ReleaseShrink", "text reuse")
    }
    return tkPass("ReleaseShrink")
}
```

  Match the exact method names these types really have: `remove` vs `delete`, `push` vs `add`, and `text.append` vs `+=`, `length` vs `count`. Check `caseClearBasics` and the reference. Only the method names may change; keep the assertions. Add a map `for` order check if the map supports `for k in m`: after the delete and shrink, the keys iterate as `a`, `c`, `d`.

  **(b) Register the case.** Add `ReleaseShrink` to the `CoreTest` enum, `coreCaseName`, the `all` list and the dispatch in `runner.cla`, placed exactly like `ClearBasics`. Bump `nCoreCases` 83 → 84. Add `ReleaseShrink` to `tests/testsuite/core_cases.txt`. Bump the `suite_report_check` literals in `tests/mactest/coresuite_68k.sh` and `coresuite_mac.sh`. Update CLAUDE.md's core count text: "83 `CoreTest` cases: 82 real" becomes 84/83, plus one clause on what `ReleaseShrink` proves, in the existing style.

  **(c) The host storage test.** `testdata/lowlevel/release_storage.cla`, a host CLI program. Copy the `app` header and `App.startCLI` handler shape from an existing CLI fixture such as `testdata/emitui/every_cli.cla`:

```
// SE Wave 1: .release() really returns storage. MemProbe is the host
// runtime's rt_ext_MemProbe (rt_ext_host.inc): under CLARUS_MEM_PEAK=1 it
// prints `memprobe: <phase> | live68k=N ... live=N ...`.
external func MemProbe(phase: string)

var big: list of int
var strs: list of string

// (app header + on App.startCLI(...) copied from the fixture), body:
    var i: int
    i = 0
    while i < 250000 {
        big.push(i)
        i = i + 1
    }
    MemProbe("filled")
    big.release()
    MemProbe("released")
    i = 0
    while i < 2000 {
        strs.push("element-" + string(i))
        i = i + 1
    }
    MemProbe("strs")
    strs.release()
    MemProbe("strsreleased")
```

  `tests/hostrt/release_storage.sh`:

```sh
#!/bin/sh
# SE Wave 1: .release() returns a container's storage (host lane), and
# an element-bearing release frees its elements without leaking (the
# runtime's CLARUS_MEM_STRICT exit report lists no leaks).
. "$(dirname "$0")/../lib.sh" || exit 2
host_build "$WORK/rs" testdata/lowlevel/release_storage.cla > "$WORK/build.log" 2>&1 \
    || die "host_build: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
CLARUS_MEM_PEAK=1 CLARUS_MEM_STRICT=1 CLARUS_MEM_REPORT="$WORK/mem.txt" "$WORK/rs" > "$WORK/out" 2> "$WORK/err" \
    || die "run failed: $(tail -5 "$WORK/err" | tr '\n' ' ')"
live() { sed -n "s/^memprobe: $1 | .* live=\([0-9]*\) .*/\1/p" "$WORK/err"; }
f=$(live filled); r=$(live released); s=$(live strs); sr=$(live strsreleased)
echo "live filled=$f released=$r strs=$s strsreleased=$sr"
[ -n "$f" ] && [ -n "$r" ] && [ -n "$s" ] && [ -n "$sr" ] || die "missing memprobe lines"
[ $((f - r)) -ge 900000 ] && t_pass list_storage_freed || t_fail list_storage_freed "only $((f - r)) bytes freed"
[ "$sr" -lt "$s" ] && [ $((s - sr)) -ge 16000 ] && t_pass elements_freed || t_fail elements_freed "strs=$s strsreleased=$sr"
if grep -q '^rt_mem: leak' "$WORK/mem.txt"; then t_fail no_leak "$(grep '^rt_mem: leak' "$WORK/mem.txt" | head -3 | tr '\n' ' ')"; else t_pass no_leak; fi
t_done
```

  The 16000 threshold is a floor: 2000 strings × at least one 8-byte block each. If `list of string` elements are inline 256-byte strings rather than separate blocks, most of the drop comes from the data handle; the assertion still holds. If the leak report path is different, check `rt_mem_exit_check` in `runtime/host/rt_mem_host.inc`: the report goes to `CLARUS_MEM_REPORT`.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `make test T='testsuite/core_cli hostrt/release_storage'`
Expected: both FAIL. Clarusc rejects `release`/`shrink` as unknown methods, and the core CLI fails the build or reports `ReleaseShrink` unknown.

- [ ] **Step 3: Implement the runtime functions** next to each `*Clear`. Here are list and text; map, intmap and sortedmap follow the same pattern with their own fields and `*SetHandleSize` externs:

```
// rtListDropStorage (SE wave 1, `.release()`): back to the birth state --
// data handle sized to 0, count = cap = 0. The caller (lowering) has
// already run the element-release walk when the list holds references,
// exactly as for clear(). The box itself stays: every alias keeps a
// valid, empty list (reference: containers are shared by reference).
func rtListDropStorage(l: ptr) {
    var rl: RtList
    rl = RtList(l)
    ListSetHandleSize(rl.data, 0)
    rl.count = 0
    rl.cap = 0
}

// rtListShrink (SE wave 1, `.shrink()`): capacity trimmed to count.
// Never releases elements.
func rtListShrink(l: ptr) {
    var rl: RtList
    rl = RtList(l)
    if rl.cap > rl.count {
        ListSetHandleSize(rl.data, rl.count * rl.elemsize)
        rl.cap = rl.count
    }
}
```

  Use the type's real extern name, e.g. `TextSetHandleSize` in text.cla. Re-derive an overlay after any call that can move memory, if the code dereferences the handle; these functions don't. **Add no string literals** to the new runtime functions: a new literal could shift runtime string-pool numbering in unrelated programs. `rtPanic` calls are not needed here.

- [ ] **Step 4: Wire the checker, IR, lowering, shake and both lanes**
  - Follow `clear` in every site listed in Files.
  - `release()` lowers to the deep variant exactly when `clear()` would use `ClearDeep`, using the same predicate calls (`lowEscapeTrackableKind`, `lowIsRecBearing`, `lowArrHeapScalarBearing`). The deep variant emits the element-release walk and then the drop-storage call:
    - C lane: `cpEmitElemReleaseWalk`, then `clar_fn_rt<Type>DropStorage(...)`.
    - 68k lane: the `cgClearDeepContainer` walk, then `cgIntr1(e, rn<Type>DropStorage, false)`.
  - `shrink()` always lowers to the plain call.
  - Shake marks each new runtime function reachable only from its own intrinsic.
  - C lane: mirror how `clear` reaches the Clarus-compiled runtime function (the `cpListPorted`-style gate). If the family's clear goes through a C `rt_*` function on some path, implement the same path for the new calls rather than a C shim, and say so in the report.

- [ ] **Step 5: Document.** In `docs/clarus-language-reference.md`, next to each type's `clear()` entry, add `release()` and `shrink()` entries. Each entry states:
  - the exact effect (spec L2/L3);
  - that it acts on the shared container, so every reference sees it;
  - that `release()` also releases elements, like `clear()`.

  Add "Capacity is kept; use `release()` to free it." to each `clear()` entry. If new ```` ```rust ```` fences shift the reftest manifest indices, update `tests/reftest/manifest.txt` the same way Wave 0 Task 2 did (commit a3a9bfee).

- [ ] **Step 6: Run the tests**

Run: `make test T='testsuite/ hostrt/release_storage cg68k/ bake/ reftest/'`, then `CLARUS_CG68K_BLESS= make test T=cg68k/goldens`.
Expected: all PASS, and `git status --short testdata/` shows no modified golden.

If `memgate/peak` fails *only* because the added runtime functions raised the from-source peaks over budget+1%:
- raise only the failing budget(s) to the new peak + 1%;
- add a change-log line to `tests/memgate/budget.txt`: `# 2026-09-28 wave 1 Task 1: +N bytes from the release/shrink runtime functions (from-source lowers the whole runtime); lowered again in Task 6`;
- report it.

Any other memgate failure is a real regression: stop.

- [ ] **Step 7: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add runtime/clarus/ clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/shake.cla clarusc/cprint.cla clarusc/cg68k.cla docs/clarus-language-reference.md tests/reftest/manifest.txt testsuite/core/ tests/testsuite/core_cases.txt tests/mactest/coresuite_68k.sh tests/mactest/coresuite_mac.sh CLAUDE.md testdata/lowlevel/release_storage.cla tests/hostrt/release_storage.sh tests/memgate/budget.txt
git commit -m "feat(lang): .release() and .shrink() for list/map/intmap/sortedmap/text (SE wave 1)"
```

---

### Task 2: Front-end frees after lowering (byte-identical)

**Files:**
- Modify: `clarusc/drive.cla` (`driveCompile`: bake path ~l.2543, source path ~l.2562; new `driveFreeFrontEnd`)

**Interfaces:**
- Produces: `func driveFreeFrontEnd()` in drive.cla, called after a successful `lowerProgram` on both paths, and never when `--bake-ir` is active. Find the global that marks `--bake-ir` mode by reading main.cla's arg parsing and `bakeGenerateChain` (bake.cla ~l.797). Task 5 switches its body to `.release()`.

- [ ] **Step 1: Record the before numbers**

Run: `make -j tools bootstrap && make test T=memgate/ && grep -E '^(bookmarks|hello)' build-run/tests/memgate/peak.log`
Record the three peaks for the report.

- [ ] **Step 2: Implement `driveFreeFrontEnd`**

```
// driveFreeFrontEnd (SE wave 1, spec §4.1): drop the front end's state
// once lowering has succeeded -- nothing downstream of lowerProgram reads
// the AST, tokens, source, declFileTab or the checker tables (audited
// 2026-09-28: shake, cg68k, cprint, app68k, uiblob, asm68k, peep68k,
// res68k, drive's emit functions, main/macgui after driveCompile). NOT
// under --bake-ir: bakeWriteFile reads funcSigs/symbols/scopes/typeArena/
// enumMembers/fieldInfos/recFieldsHeadByName/declFileTab after lowering.
// Fresh-container reassignment (spec L8); Task 5 switches to .release().
func driveFreeFrontEnd() {
    var ex: list of ExprNode
    var st: list of StmtNode
    var de: list of DeclNode
    var te: list of TypeExpr
    var tk: list of Token
    exprs = ex
    stmts = st
    decls = de
    typeExprs = te
    toks = tk
    // ... one fresh local per remaining global, same pattern:
    // lexSrc, declFileTab, symbols, scopes, funcSigs, typeArena,
    // funcScopeByDecl, funcRetByDecl, funcSigByDecl, xrecSizeByName,
    // xrecFirstDeclByName, externFirstDeclByName, constFirstDeclByName,
    // recFieldsHeadByName
}
```

  - Use each global's real declared type: read its declaration (`/usr/bin/grep -an '^var <name>' clarusc/*.cla`).
  - For a `text` or `string` global, assign `""`.
  - For each global, check whether any reset function (`driveReset`, `astReset`, `lexReset` or the checker's reset) or the start of the next compile assumes a particular shape, such as a sentinel element at index 0. If one does, restore that shape here too, or leave that global out and say so in the report.

  Call it right after each `lowerProgram(...)` whose diagnostics check passes, guarded by the bake-ir flag:

```
    if diags.count > 0 {
        return false
    }
    if not <bakeIrFlag> {
        driveFreeFrontEnd()
    }
    return true
```

- [ ] **Step 3: Audit the readers once more**

  For each global in the helper, run `/usr/bin/grep -an '\b<name>\b' clarusc/*.cla`. Confirm that no hit is on the compile path after `driveCompile` returns true. The spec's audit (§4.1) is the reference. Record any surprise in the report, and leave that global out.

- [ ] **Step 4: Run the tests**

Run the Global Constraints identity check. Expected: no `DIFF`.
Run: `make test T='mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake memgate/ cg68k/selfemit bake/'`. Expected: all PASS. memgate peaks fall (it may print `note: ratchet available`). Record the new peaks.

- [ ] **Step 5: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add clarusc/drive.cla
git commit -m "perf(clarusc): free AST, tokens and checker tables after lowering (SE wave 1)"
```

---

### Task 3: Per-function reset in `cg68Measure` (byte-identical)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cg68Measure` per-function loop ~l.14297-14338; the pools measure ~l.14394; `cgEmitPoolsBody` ~l.13559)

**Interfaces:**
- Produces: `func cgMeasureDropItems()` in cg68k.cla, which clears `a68Items`, `a68CommentTexts` and `a68DataTexts` and nothing else. Task 5 may switch it from `.clear()` to the right call. `.clear()` already keeps the capacity high-water, which is what we want per function: one function's worth, reused.

- [ ] **Step 1: Record the before numbers** (the same command as Task 2 Step 1).

- [ ] **Step 2: Implement**

```
// cgMeasureDropItems (SE wave 1, spec §4.2): measure needs only each
// function's size (a68SizeSoFar() is a68Pc, not a sum over items) and
// the label tables; the items themselves are dead once cgFuncSize has
// the size. peepFunc(startIdx) only touches [startIdx, count), a68Relayout
// rebases from absolute addresses, and the comment/data texts are read
// only by a68Finish/the listing after the per-segment a68Reset(). Keep
// a68Pc and a68LabelAddr/a68LabelDefined -- cross-function label ids.
// Never a68Reset() here.
func cgMeasureDropItems() {
    a68Items.clear()
    a68CommentTexts.clear()
    a68DataTexts.clear()
}
```

  In the per-function branch that runs `cgEmitFunc(i)`, call `cgMeasureDropItems()` right before `before = a68SizeSoFar()`. Do the same inside the pools measure. Under `cgMeasuringPoolSizes`, `cgEmitPoolsBody` measures per literal with `before = a68SizeSoFar()`, so call it before each `before` there, **only when `cgMeasuringPoolSizes` is true**. The emission-time call path must not clear.

  Before relying on this, check that no code in `cgEmitFunc`/`peepFunc`/`a68Emit` indexes `a68Items` by an index saved before the reset:
  - `/usr/bin/grep -an 'a68Items\[' clarusc/cg68k.cla clarusc/asm68k.cla clarusc/peep68k.cla` lists every indexed read;
  - confirm each index is derived from `startIdx` or later, inside the same function.

  Also check that `a68CommentTexts`/`a68DataTexts` are indexed from items. If an item stores an index into them and the reset restarts both from 0, the new function's items are self-consistent, which is fine; confirm it anyway.

- [ ] **Step 3: Run the tests**

Run the Global Constraints identity check (no `DIFF`), then `make test T='cg68k/ bake/ memgate/ asm68k/'`. Expected: all PASS, with the peak lower. Also build the listing variant once, `build-run/clarusc-current emit68k --listing -o /tmp/claude-1000/l.bin examples/bookmarks.cla`, and diff its `.s` segments against the snapshot's (same basename; MacBinary embeds the file name). This proves the listing path is unaffected.

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add clarusc/cg68k.cla
git commit -m "perf(cg68k): drop each function's items after measuring its size (SE wave 1)"
```

---

### Task 4: Bake install by move, re-parse per compile, early `rtbakeBytes` free (byte-identical)

**Files:**
- Modify: `clarusc/bake.cla` (`bkInstallPool` ~l.4076, `bkInstallTypeArenaPrefix` ~l.4135, `bkInstallFieldInfo` ~l.4158, `bkInstallArenas` ~l.4303, `bkInstallCheckerSymbolsForTestapi` ~l.4597, `bkLoadSections` CheckerSymbols ~l.3649, `bkParsedValid` ~l.1991-2005 and its uses)
- Modify: `clarusc/drive.cla` (parse gate ~l.2137-2160; `driveRtbakeFallback` ~l.2060-2085, its `bkParsedValid = false`)
- Modify: `clarusc/macgui.cla` (`gcResolveBakePath` ~l.602-656; `gcCompile`'s post-compile free ~l.755-757)
- Modify: `clarusc/test/dblcompile_bake.cla` (re-set `rtbakeBytes` before every compile; the BAKESTATE `parsedBefore` field)
- Modify: `tests/mactest/dblcompile_bake.sh` (~l.41-48: `wantpb` is 0 on every compile)

**Interfaces:**
- Produces:
  - `driveCompile` consumes `rtbakeBytes`: after a successful `bkLoadRtbake`, the bytes are gone.
  - Every front end sets `rtbakeBytes` and `haveRtbake` before each `driveCompile` that should use the bake.
  - `bkParsedValid` no longer exists. Remove it, and fix every reference, including dblcompile_bake's BAKESTATE printer: `parsedBefore` prints 0, because the parse is never memoized now.
- Keeps: `bkLdObj*` and `cgObjRuns`/`cgObjHoles` untouched (spec §4.3).

- [ ] **Step 1: Update the test expectation first** (TDD). In `tests/mactest/dblcompile_bake.sh`, make the expected `parsedBefore` 0 for every compile, and change the failure message to `(wave 1: the CLIR is re-parsed on every compile)`. Also add a check that the harness reports `boundary`/`eligible`/`objvalid` identical across compiles, if it doesn't already.

Run: `make test T=mactest/dblcompile_bake`. Expected: FAIL (compile #2 reports `parsedBefore=1`).

- [ ] **Step 2: Re-parse every compile, and free the bytes after the parse**
  - drive.cla's parse gate becomes unconditional:
    ```
            if not bkLoadRtbake(rtbakeBytes, wantLane) {
                return false
            }
            // SE wave 1 (spec L6): the bytes are dead once parsed --
            // every compile re-parses from its front end's fresh copy.
            rtbakeBytes = ""
    ```
  - Leave the bytes untouched on the failure return. Read `driveRtbakeFallback` and its callers, and confirm the fallback never reads `rtbakeBytes`: it re-runs from source. If it does read them, free only on the success path after the fallback decision point, and document where.
  - Delete `bkParsedValid`, and every set, test and doc comment that references it. In `gcResolveBakePath`, remove the `if bkParsedValid` skip, so the bytes are copied from the CLIR resource on every compile. In `gcCompile`, remove the `if bkParsedValid { rtbakeBytes = "" }` block.
  - `dblcompile_bake.cla`: re-set `rtbakeBytes` (and `haveRtbake`) from the baked file before every compile, not once. Keep the file's bytes in a harness-local `text`, and assign a copy into `rtbakeBytes` per compile. Because `driveCompile` frees `rtbakeBytes` by reassignment, check the copy semantics: containers share by reference, so assigning the local to `rtbakeBytes` and then reassigning `rtbakeBytes = ""` only drops that reference and leaves the local intact. That is right on the host, since the harness still holds its own reference. Confirm with the test.
  - `main.cla` needs no change: one compile per process, and the free now happens inside `driveCompile`.

- [ ] **Step 3: Install by move**

  In `bkInstallArenas`, `bkInstallPool`, `bkInstallTypeArenaPrefix`, `bkInstallFieldInfo` and `bkInstallCheckerSymbolsForTestapi`, replace each `.clone()` or `bkCopy*` copy with an ownership move, then leave the staging global as a fresh empty container:

```
    irTypes = bkLdIrTypes
    var e1: list of IRType
    bkLdIrTypes = e1
```

  Use the real element types. For the truncating Funcs/StrLits/ArrLits copies, move the list, then pop or truncate to `bkLdBase*Count`. If the list API has no truncate, pop in a loop; the tail is short. Then reset the staging global.

  `bkInstallPool` rebuilds `strIndex` from `strPool`, so move `bkLdStrPool` into `strPool` first and rebuild the index from `strPool`. After install, free the remaining parse-only staging (`bkLdLow*`, `bkLdBase*` and `bkLdEarly*`, whichever are left after the moves) in a new `bkFreeParseStaging()`, called at the end of the install sequence in `driveCompile`.

  The `bkLoaded*` tables: free `bkLoadedDeclFileTab`/`bkLoadedModules` after `bkComputeManifestPaths` runs, and free the testapi-only ones after the testapi branch (drive.cla ~l.2343-2409), or right after the point where that branch is known not to run.

  **Do not free** `bkLdObj*`, `cgObjRuns` or `cgObjHoles`.

  To confirm the install sequence runs once per compile now that the parse always precedes it, run `/usr/bin/grep -an 'bkInstall' clarusc/drive.cla`.

- [ ] **Step 4: Parse CheckerSymbols only under `--testapi`**

  In `bkLoadSections` (~l.3649), wrap `bkReadCheckerSymbols()` in the same condition its consumer uses (`testapi and isUiProg`, or just `testapi` if `isUiProg` isn't known at parse time). If the section must still be *skipped* in the byte stream when not parsed, use the section-skip idiom the loader already uses for sections it ignores; the body-hash check covers the whole file either way.

- [ ] **Step 5: Run the tests**

Run: `make test T='mactest/dblcompile_bake mactest/dblcompile mactest/dblcompile_abort bake/ memgate/'`. Expected: all PASS; dblcompile_bake shows `parsedBefore=0` on every compile.
Then find the drift-fallback coverage (`ls tests/bake/ | grep -i drift`), run it, and confirm it passes.
Run the Global Constraints identity check: no `DIFF`.
Compile macgui with the current compiler, `build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ -o /tmp/claude-1000/ClarusC.bin clarusc/macgui.cla`. Expected: no diagnostics.

- [ ] **Step 6: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add clarusc/bake.cla clarusc/drive.cla clarusc/macgui.cla clarusc/test/dblcompile_bake.cla tests/mactest/dblcompile_bake.sh
git commit -m "perf(bake): install by move, re-parse per compile, free rtbakeBytes after parse (SE wave 1)"
```

---

### Task 5: Switch the free sites to `.release()`; fold in the Wave 0 doc minors (byte-identical)

Needs Tasks 1–4 merged.

**Files:**
- Modify: `clarusc/drive.cla` (`driveFreeFrontEnd`; the `rtbakeBytes` free)
- Modify: `clarusc/bake.cla` (staging resets after moves; `bkFreeParseStaging`; `bkLoaded*` frees)
- Modify: `clarusc/ast.cla` (`astReset`: its `.clear()` calls free nothing (umbrella §6); use `.release()` wherever the list's next use starts from empty)
- Modify: `docs/HISTORY.md` (Wave 0 entry: "Three items outlive the wave" becomes four, and add the natLog-headroom item to that list)
- Modify: `toolbox/memory.cla` (header note: "eight siblings" → "nine siblings", "eleven" → "twelve")

**Interfaces:**
- Consumes: `.release()` (Task 1). `driveFreeFrontEnd` (Task 2). The staging resets and `bkFreeParseStaging` (Task 4).

**Aliasing trap (read first).** `.release()` empties the *shared* box (spec L1). So:
- **Do NOT convert the post-move staging resets.** After `irTypes = bkLdIrTypes`, both names hold the same box, and `bkLdIrTypes.release()` would empty `irTypes`. Those resets must stay `var e: …; bkLdIrTypes = e`, which re-points the staging name at a fresh box. Add a one-line comment at the first one saying why.
- **`rtbakeBytes.release()` empties every holder of that box.** In macgui, `gcResolveBakePath` assigns a freshly read buffer, so that is fine. The `dblcompile_bake.cla` harness keeps its own reference to reuse on the next compile, so it must hand `driveCompile` a copy per compile (`rtbakeBytes = local.clone()`, or the text equivalent), or the second compile gets empty bytes. The `dblcompile_bake` test catches this, so run it.
- **`driveFreeFrontEnd`'s globals.** Before converting each one, grep for any other variable that aliases it and outlives the compile, e.g. a `combined`/entries list holding the same box. Keep the reassignment for any global that has one.

- [ ] **Step 1: Replace each fresh-container reassignment with `.release()`, except the cases above**

  Example: `var ex: list of ExprNode` plus `exprs = ex` becomes `exprs.release()`. Leave a reassignment in place only where the variable must become a *different* box, which should be nowhere here. `rtbakeBytes = ""` becomes `rtbakeBytes.release()` if `rtbakeBytes` is a `text`.

  In `astReset`, use `.release()` for the arenas that the next compile refills from empty, instead of `.clear()`. Leave `cgMeasureDropItems` on `.clear()`: keeping capacity per function is the point there.

- [ ] **Step 2: Fold in the two Wave 0 minors** (the text edits in Files).

- [ ] **Step 3: Run the tests**

Run the Global Constraints identity check (no `DIFF`), then `make test T='mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake bake/ memgate/ testsuite/catalog'`. Expected: all PASS. Peaks are equal to or lower than after Wave A (`.release()` also frees the arenas' old handles where the reassign idiom already did, so expect equal).

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add clarusc/drive.cla clarusc/bake.cla clarusc/ast.cla docs/HISTORY.md toolbox/memory.cla
git commit -m "refactor(clarusc): free sites use .release(); astReset releases; wave 0 doc minors (SE wave 1)"
```

---

### Task 6: Snapshot regeneration, memgate ratchet, census (serialization point; runs alone)

Needs Tasks 1–5 merged.

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)
- Modify: `tests/memgate/budget.txt`

- [ ] **Step 1: Regenerate the snapshot**

  Run `make test T=selfhost/fixedpoint`. It fails and prints the Go-free regeneration recipe; follow it exactly, then re-run until it PASSes. Then run `make test T=selfhost/`. Expected: all PASS. If a selfhost script fails for a reason other than staleness, stop and report it.

- [ ] **Step 2: Ratchet**

  Run `make test T=memgate/` three times. The peaks must be identical across the three runs; if not, stop. Set each budget to `int(P * 1.01) + 1`, and add a change-log line at the top of the log:

```
# 2026-09-28 wave 1: .release/.shrink, front-end frees, measure reset,
# bake install-by-move + re-parse + early rtbakeBytes free. Measured peaks
# <P1> / <P2> / <P3> + 1%.
```

  If `bookmarks_rtbake` > 6,291,456, still commit the ratchet at the measured value. Also run `scripts/memcensus.sh --rtbake examples/bookmarks.cla`, and put the peak phase's memprobe line and top 10 census lines in the report: they are Wave 2's input, and the spec's revised-number justification.

- [ ] **Step 3: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add clarusc/clarusc.c tests/memgate/budget.txt
git commit -m "test(memgate): ratchet to wave 1 peaks; regenerate snapshot (SE wave 1)"
```

---

### Task 7: IIcx re-measure, docs and end-of-wave gates (controller-driven)

Needs Task 6.

**Files:**
- Modify: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md` (§5.5 row for wave 1 with the measured value; §9 status, plus a "Wave 1 measurements" subsection with aligned-column tables)
- Modify: `docs/superpowers/specs/2026-09-28-se-wave1-lifetimes-design.md` (status line; revise §1's number with justification if 6 MB was not reached)
- Modify: `docs/ROADMAP.md` (Wave 1 done, pending merge)
- Modify: `docs/HISTORY.md` (Wave 1 entry, with placeholders `<T2 result>`, `<clarusc_bake result>`)
- Modify: `docs/TODO.md` (anything new the wave found)

- [ ] **Step 1: The IIcx measurement (subagent, emulator)**

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_memprobe
cp build-run/tests/mactest/snow/clarusc_memprobe.log build-run/memprobe-saved/clarusc_memprobe.wave1.log
```

  Expected: 5/5 PASS. Record:
  - launch free/zone;
  - the per-phase free;
  - the launch→low heap used, compared with Wave 0's ~12.0 MB;
  - the stack high-water;
  - the ticks, including the re-parse cost, which now shows in "Installed baked runtime" on every compile.

  Copy the log before any other run of that script: `run1.sh` truncates it.

- [ ] **Step 2: The docs** (subagent): steps from the Files list, with numbers from Tasks 2–6's reports and Step 1. Tables must have aligned columns (Andrew's rule).

- [ ] **Step 3: The end-of-wave gates** (controller)

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
scripts/test-merge.sh
CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake
```

  Expected: every stage PASSes. Fill in the HISTORY placeholders.

- [ ] **Step 4: The final whole-branch review** (Opus), a single fix wave, and a scoped re-review. Then report to Andrew. Do not merge.
