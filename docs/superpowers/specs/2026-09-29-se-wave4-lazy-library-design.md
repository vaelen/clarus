# SE memory program, Wave 4: Lazy runtime library (spec, 2026-09-29)

Status: **merged to main** (2026-09-29, `f62e67d5`). `bookmarks_rtbake` 1,194,744 (budget 1,206,692; target
1,258,291 met); measurements in the umbrella's §9.5, rulings and
deviations from this spec in `docs/HISTORY.md`'s Wave 4 entry.
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 4 is the
brief; D1, D2, D12 are decided inputs). Wave 3's numbers: umbrella §9.4.

Anchors below are as of `main` at `148f80e1`. The research behind this
spec (section sizes, census, reachability, taint list) was measured on
that commit; its numbers are quoted where they drive a decision.

## 1. Goal and exit

ClarusC's compile path stops loading the runtime library whole. A compile
reads a small resident index and only the object code of the runtime
functions its program reaches, and never loads runtime IR bodies at all.

**Exit:**
- `tests/memgate/budget.txt` `bookmarks_rtbake` ≤ **1.2 MB**
  (1,258,291 bytes), measured peak + 1% committed. Today it is 3,404,020
  (99.2% of its 3,433,168 budget). If 1.2 MB is not reached, the wave
  records the measured figure and the at-peak census, and revises its
  own number (umbrella §5.5).
- `bookmarks_src` and `hello_src` drop to their new peaks + 1%
  (`hello_src` is at 99.9% today).
- No whole-library read anywhere in ClarusC's compile path: the
  `__clir_bake_68k__` resource is gone, and the library is read with
  `filehandle.readAt` from ClarusC.APPL's own data fork.
- Every compiled program is byte-identical to its from-source build
  (the `tests/bake/` identity gates and the `CLARUS_BAKE_FULL=1` sweep).
- End-of-wave gates (umbrella §5.3): full T2; `mactest/snow/clarusc_bake`
  on the IIcx; `mactest/snow/clarusc_memprobe` on the IIcx, with its
  numbers recorded in umbrella §9 beside Wave 3's.

## 2. Decisions (Andrew, 2026-09-29)

| #   | Decision                                                                                                                                                                                                                                                                             |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| W1  | **One wave, the full set**: untaint, shake summary, no IR bodies, the data-fork `readAt` library, plus the extra levers toward 1.2 MB (§3.5). The number self-revises if missed.                                                                                                     |
| W2  | **The library lives in ClarusC.APPL's data fork.** A 68k application's code is in its resource fork (`CODE` resources); its data fork is empty today (0 bytes, measured). One file ships; the library cannot drift from its compiler.                                                |
| W3  | **The host from-source path stays whole-runtime.** It is the byte-identity oracle every bake test compares against. It only gets the early token/lexer free (§3.5).                                                                                                                  |
| W4  | **The on-demand checker interface is out of scope.** ClarusC compiles with `testapi = false` (`clarusc/macgui.cla` `gcCompile` → `driveCompile(entries, false)`), which already skips the checker-symbol section (`bake.cla:3794-3802`). Only host `--testapi` suite builds read it. |
| W5  | **Read-only open is user-facing**: `file.openRead(path)` returns a read-only `filehandle` on both lanes.                                                                                                                                                                             |
| W6  | **The version check is a header stamp** (format version + compiler stamp). The full-body hash goes (1m53s on the IIcx in Wave 3, and incompatible with partial reads).                                                                                                               |

## 3. Work

### 3.1 Untaint the runtime (every runtime function pasteable)

Today 26 runtime functions are "tainted" at bake time (`cgObjValid[i] =
false`, `cg68k.cla` ~l.15384-15412): each calls a per-program
synthesized reverse-waist dispatcher (`clar_ui_fire_*`, `clar_conn_*`,
`clar_lsn_/brs_/svc_fire_*`, named by `lowUiSynthExternName`,
`lower.cla` ~l.8394) that does not exist at bake time
(`cgCallExtUiSynth` ~l.11882-11905, `cgCallExtUiGlueAddr` ~l.11940).
The list is `nat_UiLaunchReal`, `rtUiOpen`, `rtUiTeardownWindow`,
`rtUiCloseInternal`, `rtUiMenuDispatch`, `rtUiEveryPump`,
`rtUiApplyResize`, `rtUiFireWidget`, `rtUiFireCanvasXY`,
`rtUiHandleKey`, `rtUiLaunch`, `rtUiWidgetSetInt`, `rtUiTeMutated`,
`rtUiLdefDraw`, `rtUiTableFireSelect`, `rtUiTableFireDblclick`,
`rtUiTableSyncOne`, `rtUiPopupPick`, `rtUiScriptEveryPump`,
`rtUiFormAccept`, `rtUiFormCancel`, `rtConnPump`, `rtAtalkPump`,
`rtTcpPollConn`, `rtTcpPump`, `nat_UiConnPump`.

- A new hole kind, **`cgHoleSynthCall`**: `sym` is the pool index of the
  dispatcher's name. At paste it resolves with `findIRFuncIdxByName`
  and emits `cgCallFunc(fi)`, exactly as `cgHoleCbGlueAddr` resolves
  through `cgCbGlueFuncIdx`. The glue-address variant
  (`cgCallExtUiGlueAddr`) gets the same treatment if any tainted
  function uses it.
- At capture time the missing dispatcher is emitted as the hole, not as
  a taint, so every runtime function captures valid object code.
- Afterwards no runtime function is lowered or code-generated per
  program on the bake path.

### 3.2 Shake runs on a baked call-graph summary

- The bake writes, per runtime function, the sorted list of callee
  `irFuncs` indices that `shakeWalk*` (`shake.cla` ~l.387-860) would
  record from its body (ECallFn, ECbAddr, the `shakeWalkIntr` table,
  `SStoreStr`, `SForList`, `SForMap`, array `EIndexRef`), and the
  callee set of every runtime global initializer. About 2.5-3 K edges,
  ~12 KB.
- `shakeProgram` walks the summary for `i < bkRuntimeFuncBoundary`, and
  walks IR for user functions and synthesized dispatchers, as today.
  The roots are unchanged (`shake.cla` ~l.198-372). Edges feed
  `cgStackHeuristic` as today.
- The from-source path keeps walking IR (it has the bodies). A test
  proves the summary and the IR walk give the same marks and edges for
  every runtime function.

### 3.3 The library format (CLIR version 9)

- **Header:** magic `CLIR`, format version 9, lane, stamp length and
  stamp. No body hash (W6).
- **Section directory** after the module list: per section, id, offset
  and length, so any section can be read on its own with `readAt`.
- **Resident tables** (read once at install, kept): IrFuncs,
  IrGlobals, IrTypes, IrFieldSlots, records, enums, IrStrLits,
  IrArrLits, StrPool, LowCounters, the extern registry, ObjMeta, the
  call-graph summary (§3.2), the manifest hashes, the scalars and
  bounds. Their numbering is unchanged, which is what keeps output
  byte-identical: runtime globals' A5 offsets, function indices and
  literal-pool indices are baked into pasted bytes.
- **No IR bodies.** IrExprs and IrStmts are no longer written, except a
  compact section holding only the runtime global-initializer
  expression trees (renumbered into their own small arena; the
  init-globals stub `cgEmitInitGlobalsStub`, `cg68k.cla` ~l.5337,
  needs them). IrLocals keeps parameters only. (1.27 MB of the
  1.98 MB file today.)
- **ObjCode with an index:** a per-function table of (offset, length)
  into the object section, so a compile reads only reachable
  functions' runs and holes, coalescing contiguous spans. Holes stay in
  their 21-byte wire form in the read buffer and are decoded at paste
  (`cgObjPasteHole`, ~l.15882) instead of being expanded into 48-byte
  records for all 3,730.
- **Checker sections** (CheckerSymbols, DeclFileTab, FieldInfo) stay in
  the file and are read only under `--testapi` (FieldInfo is parsed
  today even without it; `docs/TODO.md` ~l.624).
- The `tests/bake/` format fixtures (`header`, `bodyhash`, `corrupt`,
  `refuse_*`) move once, deliberately.

### 3.4 Container, discovery and the read path

- **ClarusC.APPL:** `scripts/build-clarusc-mac.sh` writes the library
  into the application's data fork (the MacBinary wrapper,
  `app68WrapFork`, gains a data-fork input). The `__clir_bake_68k__`
  resource and its `natReadResource` path (`native.cla` ~l.1323-1360,
  which never releases the handle) are removed from the compile path.
  The `CLFS` source resources stay (user `include "toolbox/…"`).
- **Discovery:** ClarusC finds its own file with `GetAppParms`
  (name + the launch volume's refnum) and opens its data fork with
  `file.openRead`. `gcResolveBakePath` (`macgui.cla` ~l.608-649) switches
  to it.
- **Host:** `--rtbake FILE` reads the same format from a plain file the
  same lazy way, so memgate measures ClarusC's real path.
- **`file.openRead(path)`** (W5): a read-only `filehandle`, native
  `fsRdPerm` beside `rtFhDevOpen`'s `fsRdWrPerm` (`fileh_68k.cla`
  ~l.89-110), host `O_RDONLY` (`rt_fileh.inc` ~l.44-49). Writes on it
  fail with `false` + `lastError`. Reference, core suite case, both
  lanes.
- The stamp check reads only the header. A mismatch refuses the library
  with today's diagnostic and falls back as today.

### 3.5 The extra levers

- **Codegen per-function lists for reachable functions only.**
  `cgFuncStrLits/ArrLits/EnumTables/Serdescs` are allocated for every
  irFunc today (`cg68k.cla` ~l.14406-14414, ~127 KB).
- **Pre-size the output fork** so it does not double from 64 to 128 KB
  while the segment bytes are live (the 0.28 MB transient at Built fork).
- **Intern pool and `a68Items`:** after the above, re-run the at-peak
  census; trim `strIndex` (163 KB) or `a68Items`' fixed 139 KB only if
  they are then in the top buckets and the change is contained.
- **Early front-end free:** release `toks` (393 KB) and `lexSrc`
  (65 KB) right after parsing (nothing reads them after the parse;
  `driveFreeFrontEnd` frees them only after lowering). This helps both
  `_src` subcases and the bake path.

### 3.6 Not changed

- The from-source path (W3), except §3.5's early free.
- Per-program synthesis: `cg_init_globals`, `cg_free_globals`, RC walks,
  pools, JT, packing, startup, glue (`cg68k.cla` ~l.15571-15600).
- `lowComputeCanAbort` (already skips runtime-origin functions,
  `lower.cla` ~l.8894-8906) and the user-only slot numbering
  (`lowConnSlotOf`/`uiMenuIdx`, `lower.cla` ~l.8573-8634). The brief
  listed both as consequences; neither needs work.
- `lowStrIdx` keeps resuming from the bake (its map is part of the
  resident tables).

## 4. Output policy

| Change                            | Label                                                                              |
|-----------------------------------|------------------------------------------------------------------------------------|
| untaint, shake summary, lazy load | byte-identical for every compiled program (bake identity gates, full-corpus sweep) |
| CLIR v9 format                    | output-changing for the library itself: `tests/bake/` format fixtures move once    |
| `file.openRead`                   | byte-identical for programs that do not call it; runtime growth moves goldens once |
| ClarusC.APPL container            | output-changing for ClarusC.APPL only (data fork added, resource removed)          |
| extra levers                      | byte-identical (compiler internals)                                                |
| snapshot regenerations            | serialization points                                                               |
| memgate budgets                   | ratchet down, one commit                                                           |

## 5. Sequencing

- **Wave A (parallel):** §3.1 untaint; §3.2 shake summary (baked beside
  today's IR, used only when present, and proven equal to the IR walk);
  §3.4's `file.openRead`; §3.5's early front-end free and
  reachable-only codegen lists.
- **Serialization point:** the CLIR v9 format (§3.3) and the lazy
  install and read path, alone. It needs A's untaint and summary.
- **Then:** the ClarusC.APPL data-fork container and discovery (§3.4),
  a snapshot regeneration where needed, the fork pre-size and any
  census-driven trims (§3.5), the ratchet.
- **Close:** T2, the IIcx `clarusc_bake` and `clarusc_memprobe`, docs.

## 6. Tests

- Per task: T1 plus the identity check from the Wave 3 plan.
- Untaint: a bake test that every runtime function captures valid
  (`cgObjValid` all true), and the corpus stays byte-identical.
- Summary: every runtime function's baked callee list equals the IR
  walk's edges; shake marks equal for the corpus.
- Format: the moved `tests/bake/` fixtures; a new test that a v9
  `--rtbake` compile reads only reachable functions' object bytes
  (instrumented read count or byte total below a bound).
- `file.openRead`: a core case (read works, write fails with
  `lastError`), host and native.
- Memgate: the three subcases, ratcheted.

## 7. Out of scope

- The on-demand checker interface (W4).
- Making the from-source path lazy (W3).
- Segments and overlays, code and stack (Wave 5). Separate compilation
  (Wave 6).
