# SE memory program, Wave 1: Lifetimes (spec, 2026-09-28)

Status: **merged to main (2026-09-28, `fadb19af`).** Branch
`se-wave1-lifetimes`. The 6 MB exit was missed by 32,860 bytes; §1's
revision records the measured number and why.
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 1 is the
brief; D2 and D10 are decided inputs). Wave 0's numbers and findings:
umbrella §9.1 and `docs/HISTORY.md`'s Wave 0 entry.

Anchors below are as of `main` at `87dcf389`.

## 1. Goal and exit

Free what the compiler holds past its last use, without changing any
compiled output.

**Exit:**
- `tests/memgate/budget.txt` `bookmarks_rtbake` ≤ **6 MB** (6,291,456
  68k-equivalent bytes), with its measured peak + 1% committed. The
  baseline is 11,789,468. If 6 MB is not reached, the wave records the
  measured figure and the census's remaining top tables, and the spec
  revises its own number (umbrella §5.5). It may not skip the ratchet.
- The other two memgate budgets are lowered to their new peaks + 1%.
- Every golden is unchanged except for new core-suite cases. That
  covers `testdata/cg68k/*.s`, emitui, `bake/`, selfhost behavior and
  module stdout, and the CLRD goldens.
- End-of-wave gates (umbrella §5.3): full T2; `mactest/snow/clarusc_bake`
  on the IIcx (this wave touches `bake.cla` and `macgui.cla`); and
  `mactest/snow/clarusc_memprobe` on the IIcx, with its numbers recorded
  in umbrella §9.

**Revision (2026-09-28, end of wave).** `bookmarks_rtbake` measured
**6,324,316** bytes, 32,860 (0.5%) over the 6,291,456 target, from an
11,789,468 baseline. The committed budget is 6,387,378. The wave's exit
number is revised to that measured figure, for these reasons (Task 6's
census; umbrella §9.2 has the tables):
- The peak is a transient inside `bkLoadRtbake`, before
  `rtbakeBytes.release()`. The phase ends at 3.89 MB live, so 2.43 MB
  is transient. About 1.94 MB of that is the CLIR bytes themselves,
  which must stay live while the IR is decoded; the other ~0.5 MB fits
  the `bkRead*` lists growing by doubling (at `bkReadIrExprs`' 16384 →
  32768 step, 655 KB and 1.31 MB blocks are live together).
- Both levers that remove it are outside this spec. Pre-sizing the
  `bkRead*` lists from the `n` they already read needs a list
  capacity/reserve primitive (§7: not requested by D10). Releasing
  `rtbakeBytes` progressively during the parse, or parsing in chunks,
  changes the loader's structure (Wave 2/4 territory). Either one
  removes far more than 33 KB.
- The other exit items hold: the other two budgets were lowered to
  peak + 1% (8,691,240 and 8,617,304), and every task was
  byte-identical except the new core-suite case.

## 2. Decisions settled in this spec

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                             |
|-----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| L1  | **`.release()`/`.shrink()` act on the shared box in place; every alias sees the result.** Containers are references with no copy-on-write (reference l.201). Parameters are borrowed, and mutating a parameter's referent is legal (l.859-861). `clear()`/`append` already behave this way (`testdata/lowlevel/arc2_list.cla:47-49`). The box pointer never changes, so aliases stay valid.             |
| L2  | **`release()` = the canonical-empty birth state.** It runs the same element-release walk as `clear()` (the `*ClearDeep` path), then `SetHandleSize` to 0 on every handle the box owns, and sets every count and capacity field to 0 (map: also `indexcap`, `tombs`, `poolused`/`poolcap`, `valcap`). It does not allocate. |
| L3  | **`shrink()` trims capacity to count** (`SetHandleSize` to `count × elemsize`, `cap = count`). It releases no elements. Map/intmap trim entries, vals and the key pool to their used sizes and keep the hash index as it is. Sortedmap trims keys and vals. Text trims `h` to `len`. It is a no-op when already tight.                                                                                   |
| L4  | **Internal names avoid "release".** "Release" already means rc−1 (`rtListRelease`, IR intrinsic `"release"` at `ir.cla:4363`). The runtime uses `rt<Type>DropStorage`/`rt<Type>Shrink`; IR uses `<type>_drop_storage`/`<type>_shrink`. The user-facing names stay `release()`/`shrink()` (D10).                                                                                                     |
| L5  | **Compiler frees happen in `driveCompile` after `lowerProgram` succeeds, on both lanes, and not under `--bake-ir`.** The bake-ir writer reads `funcSigs`, `symbols`, `scopes`, `typeArena`, `enumMembers`, `fieldInfos`, `recFieldsHeadByName` and `declFileTab` after lowering (`bake.cla` ~l.1399-1576).                                                                                           |
| L6  | **Every compile re-parses the bake (D2).** Install moves staging into the live arenas instead of cloning it, so staging is consumed. The `bkParsedValid` memoization is removed. `driveCompile` frees `rtbakeBytes` right after a successful parse, on every front end, so each front end supplies the bytes per compile.                                                                            |
| L7  | **The host matches ClarusC.** The Wave 0 finding (host `main.cla` never freed `rtbakeBytes`, so memgate overstated ClarusC by ~2 MB) is fixed by L6's free living in `driveCompile` itself, not in a front end.                                                                                                                                                                                     |
| L8  | **Tasks that free compiler state first use today's reassign-a-fresh-container idiom** (`var e: list of X; exprs = e`), so they don't wait on the language task. One small task switches them to `.release()` after it lands.                                                                                                                                                                         |

## 3. Language: `.release()` and `.shrink()`

### 3.1 Surface

```rust
xs.release()   // list, map, intmap, sortedmap, text
xs.shrink()
```

Both are statements with no result. They are legal on any container
expression that `clear()` accepts, including a borrowed parameter and a
global. The reference gets entries next to each type's `clear()`
(`docs/clarus-language-reference.md` l.337, 353, 368, 385, 399). Each
entry states L1's aliasing rule and L2/L3's exact effect. `clear()`'s
entries gain one sentence: "capacity is kept; use `release()` to free
it".

### 3.2 Implementation sites (the `clear()`/`reserve()` path, per type)

| Layer    | Sites                                                                                                                                                                        |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| checker  | `checkListMethod` (`check.cla` ~l.2099, `clear` arm ~l.2136); `checkMapMethod` (~l.2170, `clear` ~l.2214, which covers map/intmap/sortedmap); text's `textOnlyMethods` (~l.1604)                        |
| IR       | interned intrinsic-name getters beside `IListClear`/`IListClearDeep` (`ir.cla` ~l.3942-3955) and `ITextReserve` (~l.3620)                                                                  |
| lower    | `lowListMethod` (`lower.cla` ~l.2212; the `clear` arm ~l.2282 chooses deep vs plain using `lowEscapeTrackableKind`/`lowIsRecBearing`/`lowArrHeapScalarBearing`); `lowMapMethod` (~l.2316, per-family names ~l.2340); text ~l.2475 |
| shake    | `shakeWalkIntr` (`shake.cla` ~l.565): mark the new runtime functions reachable                                                                                                        |
| C lane   | `fpIntrCall4` (list, `cprint.cla` ~l.3266; deep walk via `cpEmitElemReleaseWalk` ~l.3276), `fpIntrCall10` (map ~l.3596), `fpIntrCall13` (text ~l.4013)                                     |
| 68k lane | `rn*` name vars (`cg68k.cla` ~l.243/301) and their interns (~l.396/452); dispatch in `cgIntr` (~l.8924; `cgIntr1`/`cgIntr2`; the deep path via `cgClearDeepContainer` ~l.9324)                  |
| runtime  | `runtime/clarus/{list,map,sortedmap,text}.cla`, next to each `*Clear`. Compiled from Clarus on both lanes, so no C shim.                                                                    |

`release()` on an element-bearing container reuses the deep-clear walk
exactly as `clear()` does, then calls `rt<Type>DropStorage`.

### 3.3 Byte-identity

Programs that don't call the new methods must compile byte-identically.
Shake drops unreachable runtime functions, so user programs are
unaffected. The runtime gains functions, so the baked CLIR gains
entries: the `bake/` byte-identity twins compare from-source against
bake, and both sides change together. If any existing golden moves,
the task stops and reports.

### 3.4 Tests

New core-suite cases in `testsuite/core/cases_list.cla` (containers)
and `cases_str.cla` (text). They must run on both lanes; the host CLI
lane is T1. Required cases:
- per type, `release()` leaves count 0 and cap 0, and a later
  `append`/insert works;
- `shrink()` leaves cap == count and keeps the contents;
- an **aliasing case**: `b = a; a.release()` makes `b.count == 0`, and
  `b` stays usable;
- element-bearing `release()` (a list of text and a map of records)
  frees its elements. Check with the suite's existing leak idiom, or
  under `CLARUS_MEM_STRICT`, as `caseClearBasics` does.

**The core case count moves in all five places**: `nCoreCases`
(`testsuite/core/runner.cla`), `tests/mactest/coresuite_68k.sh`,
`coresuite_mac.sh`, `tests/testsuite/core_cases.txt`, and CLAUDE.md.

## 4. Compiler frees

### 4.1 AST, tokens, checker tables (`drive.cla` `driveCompile`)

The frees go right after `lowerProgram` returns with no diagnostics,
on both the bake path (~l.2543) and the source path (~l.2562), and
only when not `--bake-ir`. One new helper, `driveFreeFrontEnd()`,
frees:
- the AST (`ast.cla`): `exprs`, `stmts`, `decls`, `typeExprs`;
- tokens and source (`lex.cla`): `toks`, `lexSrc`;
- `declFileTab`;
- the checker (`check.cla`/`types.cla`): `symbols`, `scopes`,
  `funcSigs`, `typeArena`, `funcScopeByDecl`, `funcRetByDecl`,
  `funcSigByDecl`, `xrecSizeByName`, `xrecFirstDeclByName`,
  `externFirstDeclByName`, `constFirstDeclByName`,
  `recFieldsHeadByName`.

Verified (2026-09-28): nothing downstream of `lowerProgram` reads these
on the compile path. That covers shake, cg68k, cprint, app68k, uiblob,
asm68k, peep68k, res68k, the rest of `driveCompile` and the emit
functions, and the front ends after `driveCompile`. The main.cla
`appinfo` path reads the AST but never lowers.

The multi-compile paths (`dblcompile*.cla`, and macgui's compile #2)
already call `driveReset()`/`astReset()` before each compile. The
helper must leave each global in a state those resets accept. The plan
checks each reset against a released container.

### 4.2 `cg68Measure` per-function reset (`cg68k.cla` ~l.14297-14338)

- **Per-function reset.** In the per-function branch that runs
  `cgEmitFunc(i)`, clear `a68Items`, `a68CommentTexts` and
  `a68DataTexts` **before** `before = a68SizeSoFar()`. Keep `a68Pc`,
  `a68LabelAddr` and `a68LabelDefined`, because cross-function label
  ids must stay valid.
- **Pools measure.** Do the same per literal in the pools measure
  (`cgEmitPoolsBody` under `cgMeasuringPoolSizes`, ~l.14394).
- **Why this is safe.**
  - `a68SizeSoFar()` returns `a68Pc`.
  - `peepFunc(startIdx)` touches only `[startIdx, count)`.
  - `a68Relayout` rebases from absolute addresses.
  - The comment and data texts are read only by `a68Finish`/the
    listing, per segment, after the per-segment `a68Reset()`.
  - cgObj capture runs only in the emission loop.
- **Never call `a68Reset()` here**: it zeroes `a68Pc` and the label
  tables.

### 4.3 Bake staging (`bake.cla`, `drive.cla`, `macgui.cla`)

- **Install by move.**
  - `bkInstallArenas` (~l.4303) and `bkInstallPool` (~l.4076) take
    ownership of the staging lists instead of `.clone()`-ing or
    copying them. The staging global is then left as a fresh empty
    container.
  - This includes the truncating Funcs/StrLits/ArrLits copies. They
    move the list, then truncate to the `bkLdBase*Count`.
  - It also includes `bkInstallTypeArenaPrefix`/`bkInstallFieldInfo`,
    and the `--testapi` installs of `bkLoaded*`.
- **Free the rest of staging after install.**
  - The parse-only staging (the `bkLdIr*`, `bkLdLow*`, `bkLdStrPool`,
    `bkLdBase*` and `bkLdEarly*` families) is freed.
  - The `bkLoaded*` tables are freed once their last reader has run:
    `bkComputeManifestPaths` for `bkLoadedDeclFileTab`/
    `bkLoadedModules`, and the testapi branch for the rest.
- **Keep until the fork is built**: the `bkLdObj*` tables and
  `cgObjRuns`/`cgObjHoles`. `cg68Measure`, `cgObjPasteEligible`,
  `cgObjBuildFunc{StrLits,ArrLits}`, `cgObjApplyGlueUsage` and
  `cgObjPasteFunc` read them. They are not freed in this wave; Wave 2's
  per-function encode is the place for that.
- **Re-parse every compile.**
  - Remove the `bkParsedValid` memoization (`bake.cla` ~l.2005;
    `drive.cla` ~l.2149; `macgui.cla` ~l.616/755). The parse gate
    becomes unconditional.
  - The drift fallback (`drive.cla` ~l.2060-2085) keeps working. It
    already re-runs `driveCompile` from source.
- **Free `rtbakeBytes` in `driveCompile`** right after `bkLoadRtbake`
  succeeds (~l.2150), with the reassign idiom or `.release()`.
  - On failure the bytes are left for the fallback decision; the plan
    confirms that the fallback does not read them.
  - macgui drops its own post-compile free (~l.755-757).
  - `gcResolveBakePath` copies the bytes from the resident CLIR
    resource on every compile.
- **Parse `CheckerSymbols` only under `--testapi`**
  (`bkLoadSections` ~l.3649). Its consumer (drive.cla ~l.2343) is
  already gated.
- **The host harness.** `clarusc/test/dblcompile_bake.cla` re-sets
  `rtbakeBytes` before every compile.
- **Its assertion.** `tests/lib_mactest_host.sh` changes its BAKESTATE
  expectation from "`parsedBefore` 0 then 1" to "`parsedBefore` 0 on
  every compile". The other BAKESTATE fields (`boundary`, `eligible`,
  `objvalid`) must still match across compiles, and `fork_identity`
  and `growth_ok` stay as they are.

### 4.4 Switch to `.release()` (L8)

Once §3 lands, every free added by §4 uses `.release()` instead of the
reassign idiom. That covers `driveFreeFrontEnd`, the staging frees and
the `rtbakeBytes` free. `astReset()` (`ast.cla`) switches as well: its
`.clear()` frees nothing today (umbrella §6).

## 5. Measurement and ratchet

- After the snapshot is regenerated, memgate is re-measured, and all
  three budgets are lowered to their new peak + 1% in one commit with
  a change-log line.
- `scripts/memcensus.sh --rtbake examples/bookmarks.cla` records the
  top 10 at the new peak phase, as Wave 2's input.
- The IIcx re-run (`clarusc_memprobe`) records per-phase free, the
  launch→low heap used, and the stack high-water in umbrella §9. It
  also records compile #1's re-parse cost in ticks, which D2 accepts.
  (As measured: the re-parse runs before `driveCompile` starts its
  tick count, so it has no tick figure. It is the guest wall-clock span
  "Verifying Baked Runtime" → "Starting", 5m 28s; umbrella §9.2.)

## 6. Output policy (umbrella §5.4)

| Change                                                         | Label                                                                                  |
|----------------------------------------------------------------|----------------------------------------------------------------------------------------|
| `.release()`/`.shrink()`                                       | additive: new core-suite cases only; every other golden unchanged                       |
| `driveFreeFrontEnd`, measure reset, install-by-move, re-parse  | byte-identical (compiler internals; the snapshot changes)                               |
| `dblcompile_bake` BAKESTATE expectation                        | test-expectation change, justified by L6                                                |
| snapshot regeneration                                          | serialization point, once                                                               |
| memgate budgets                                                | ratchet down, one commit                                                                |

## 7. Out of scope

- The compact string pool, per-function encode, 68k box sizes and
  `MoreMasters` (Wave 2).
- Freeing `bkLdObj*`/`cgObjRuns`/`cgObjHoles` (Wave 2).
- The never-released CLIR resource (Wave 4).
- `reserve(n)` for list/map: not requested by D10.
- The deferred Wave 0 minors (`docs/HISTORY.md` Wave 0 entry, "Three
  items" → four, and `toolbox/memory.cla`'s miscount). They fold into
  one small commit in this wave's first task wave.
