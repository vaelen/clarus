# Task 6 report — Codegen track (spec §4.1 a–h)

**Worktree:** `/Users/andrew/repos/clarus/.claude/worktrees/agent-a754435bff73efac3`
**Branch:** `worktree-agent-a754435bff73efac3`
**Base:** `311af68 docs(plan): compiler-cleanup implementation plan`

**Status: DONE_WITH_CONCERNS.** All eight lettered items implemented and committed, plus
brief Steps 9 and 10. Step 11 (native emulator proof) is **deferred — the emulator was
busy** (see Concerns). Step 12 (`.s` bless) deliberately **not done**, per the
controller's instruction; the 31 `testdata/cg68k` goldens are left red and attributed
below.

Two environment notes before the substance:

- The worktree branch was sitting on `main` at `a1f9899`, **not** on `compiler-cleanup` at
  `311af68`. `a1f9899` is an ancestor of `311af68` and the worktree was clean, so I
  `git reset --hard 311af68`'d onto the right base as the first action.
- The worktree had none of the gitignored toolchain symlinks, so `emitui/`, `mactest/`
  and the vasm-gated scripts all SKIPped. I created `Retro68` and `toolchain` → the main
  checkout's, and `macplus` → `/Users/andrew/mac/macplus`. That un-SKIPped `emitui/` and
  `mactest/`, both of which this task needs. `vasm/` and `snow/` do not exist in the main
  checkout either, so those stay SKIPped exactly as on `main`.
- `tests/selfhost/fixedpoint.sh`'s `snapshot_fresh` is RED, as the constraints say it
  will be for any `clarusc/*.cla` change. Not fixed; Task 10 regenerates the snapshot.

---

## Commits

| # | SHA | Item | Subject |
|---|-----|------|---------|
| 1 | `cb79628` | a | fix(cg68k): track handle-bearing call results materialized as receivers |
| 2 | `6dc53bc` | b | fix(codegen): track pop/shift results in every position on both lanes |
| 3 | `f2f8b34` | c | refactor(codegen): route pop/shift dispatch through lowIntrIsOwningContainerRead |
| 4 | `0d26330` | h | refactor(cg68k): compute the return type once in cgReturnStmt |
| 5 | `9f375f0` | f | fix(lower): dispatch widget methods by widget kind |
| 6 | `485b21a` | g | refactor(lower): fold the opened/closed dispatcher builders; elide the unused err local |
| 7 | `a488f76` | e | feat(lower): synthesized clar_conn_pump cuts the conn runtime out of conn-less native builds |
| 8 | `6031e59` | d | perf(cg68k): size the small-temp pool per function (no flat 24-slot tax, no ceiling) |
| 9 | `12193ab` | Step 9 | test(toolbox): LeakCheck covers the record-receiver and pop/shift shapes |
| 10 | `53c60a0` | b follow-up | fix(cprint): a KArr pop temp is not a pointer, and only the discard position may track it |

Commit 10 is a genuine bug found by `mactest/leakgate` during Step 10 and is a follow-up to
item b — see its own section. Bisecting item b means taking `6dc53bc` **and** `53c60a0`.

Files touched: `clarusc/{cg68k,cprint,lower,app68k}.cla`, `runtime/clarus/native.cla`,
`testdata/cg68k/smalltmp_ceiling.cla`, `testdata/run/smalltmp_ceiling.cla`,
`tests/cg68k/release.sh`, `testsuite/toolbox/cases_leak.cla`. Not touched:
`clarusc/clarusc.c`, `clarusc/bake.cla`, any golden.

None of the `.cla` files I edited contains a MacRoman high byte
(`LC_ALL=C grep -c $'[\x80-\xff]'` is 0 for each, unchanged before and after), so the
constraint's byte-corruption hazard did not apply; edits were still made with byte-exact
Python replacements rather than the Edit tool.

---

## Per item

### a — tracked temp for handle-bearing call results in `cgMaterializeToTemp` (`cb79628`)

Implemented verbatim from the brief. `cgMaterializeToTemp` is `cgExprAddr`'s generic
fallback for an expression with no other address, which is how a handle-bearing record
returned by a call and used as a receiver (`makeRec().field`) gets one. It always allocated
an UNTRACKED slot, so the record's handle fields were never released.

**Goldens moved by a: `recs` only** (`recs.seg2.s` at the time; that fixture now packs into
one segment, see the table). The whole hunk is the release call the fix adds:

```
@@ -278,6 +278,12 @@
         MOVE.L D0,-304(A6)
+        MOVE.L A1,-(A7)
+        LEA -1112(A6),A0
+        MOVE.L A0,-(A7)
+        BSR.W LBL_23
+        ADDQ.L #4,A7
+        MOVEA.L (A7)+,A1
         LEA -1112(A6),A0
```

### b — pop/shift always tracked, both lanes (`6dc53bc` + `53c60a0`)

**Deliberate deviation from the brief, on both lanes.** The brief and spec both say "track
whenever `cgNeedsRelease(elemT)` / `fpNeedsRelease(...)`". Taken literally that introduces
a use-after-free on each lane, in a different type. The rule I implemented is: *track in
every position exactly for the types whose ownership-taking consumers can hand the temp
off; keep the old discard-only gate for the rest.*

**Native (`cgIntrListPopLike`): gate on `cgIsHandleKind(irtKind(elemT))`, not
`cgNeedsRelease`.** That is what the spec's own cross-reference actually spells — it points
at "the shape `cgIntrListFirstLast` already uses", and that function's gate is
`cgIsHandleKind`. `cgNeedsRelease` is additionally true for a handle-bearing KRec, and a
KRec element is >4 bytes, so `cgIntrListPopLike` hands its scratch OFFSET back to
`cgEmitStoreRec` / `cgEmitReturnRec` / `cgMaterializeToTemp`, all of which
`cgCopyScratchToDst` the bytes into a destination that then owns them (a raw block copy, no
retain) and none of which can untrack the scratch, because `cgLastTrackedOff` is only ever
consulted for a handle kind (`cgStmt`'s SAssign arm gates on `cgIsHandleKind(dstKind)`,
`cgReturnStmt` on the same five kinds). Tracking a KRec scratch would release fields the
destination is still using. The bare-discard arm stays as the one KRec position that IS
tracked — nothing copies the scratch there.

**Host (`fpIntrCall4`'s pop/shift arm): `fpNeedsRelease(...)` as the brief says, minus
KArr.** KRec is safe here (`fpStmt`'s SAssign hands a KRec temp off by name, SReturn hands
off unconditionally, `fpCallFnArg` reuses the printer's temp). KArr is not, and it produced
two separate real failures under `mactest/leakgate` — see commit `53c60a0` below.

Consumers checked and adjusted, as the brief asked:

- `cgPushArgs`' `sz == 4 and ak == EIntr and lowIntrIsOwningContainerRead(...)` branch now
  double-tracked → deleted. Its KRec sub-branch keeps its `cgPendingArgReleases` scheduling
  — the KRec scratch is still untracked, so that branch is still load-bearing.
- `fpCallFnArg`: the non-KStr/KRec re-materializing branch deleted; the KRec
  `lowIntrIsOwningContainerRead` branch now returns `"&(" + fpExpr(a) + ")"`, reusing the
  printer's temp for exactly the reason its `ak == ECallFn` neighbour already does (routing
  through `fpAddrable` would `fpHandoff` it and put the leak back).
- `fpCopyToTemp` (the push/unshift value path) already `fpHandoff`s whatever `fpExpr`
  returned, so `l2.push(l1.pop())` does not double-release. No change needed.

**Goldens moved by b: none, on either lane.** `cg68k/goldens`, `emitui/goldens`,
`lowlevel/*` and `sertest/*` were all byte-identical after this item. The assign/return
positions hand off, so emission is unchanged there, and no existing cg68k or emitui fixture
pops in a receiver or operand position. So item b would have shipped with **zero** coverage
on the native lane. Spec §4.1 asks for exactly this ("Host parity for b: a `tests/lowlevel`
(or existing leak-golden) fixture asserting the emitted C's release call appears for the
operand shape"); I put it in the existing leak golden rather than a new script.

`tests/cg68k/release.sh` gains a fourth section, `poprelease`, in the same
`check_count CASE FN WANT` shape as the three already there:

| case | shape | want | pre-fix |
|---|---|---|---|
| `poprelease_recv` | `return l.pop().length` | 1 | **0** |
| `poprelease_operand` | `return (l.shift() + "x").length` | 2 | **1** |
| `poprelease_arg` | `return f(l.pop())` | 1 | 1 (unchanged by design) |

Verified by checking `clarusc/cg68k.cla` back out to `HEAD`, rebuilding and re-running:
`recv` and `operand` FAIL, `arg` PASSes. Restored afterwards.

#### `53c60a0` — the KArr follow-up (found by `mactest/leakgate`, Step 10)

Two distinct bugs on `list of text[3]`, both surfaced by
`testdata/leakgate/arrelem.cla`'s `popAssignCase` (`popped = l.pop()` with
`popped: text[3]`):

1. `fpNewTrackedTmp` declared every non-KRec temp `<ctype> t = NULL;`. A KArr's C type is
   an array typedef (`clar_arr_text_3`), not a pointer, so that is a hard C type error:
   `FAIL ArrElem: build failed: clar_arr_text_3 t5 = NULL;`. KArr is now declared
   uninitialized like KRec, safe for the same reason (the next emitted statement fills it);
   the release SHAPE still splits on KRec alone, so a KArr keeps routing through
   `fpEmitTmpRelease`'s element walk. **This was latent before this phase** —
   `fpNeedsRelease` is true for a text-element KArr, so the pre-existing discard branch
   already emitted the bad declaration; nothing in the corpus wrote one.
2. With that fixed, tracking a KArr pop in every position **over-releases**:
   `FAIL ArrElem: run failed (exit 134): rt_rc: over-release at
   runtime/host/rt_ext_host.inc:183`. `popped = t5` is a plain C array assignment and
   `fpStmt`'s SAssign handoff fires only for `fpIsHandleType` or KRec, so the destination
   owns the handles and nothing untracks the temp. This is the host-lane twin of the KRec
   hazard the native gate already excludes. KArr now tracks only in the bare-discard
   position.

Both root-cause fixes, not call-site patches. `mactest/leakgate` is green afterwards
(`StoreTemps`, `ArrStore`, `ClearRefElems`, `ArrElem`, `PopArgLeak` all PASS).

### c — one predicate for the transfer intrinsics (`f2f8b34`)

Both dispatch arms call `lowIntrIsOwningContainerRead(nm)`. The predicate's doc comment now
states that both backends' dispatch arms route through it, and records that `cgPushArgs`'
remaining separate use is the handle-bearing-record argument shape, not dispatch.

```
$ grep -n 'IListPop() or nm == IListShift()' clarusc/*.cla
clarusc/lower.cla:1069:// re-spelled `nm == IListPop() or nm == IListShift()` chain -- a third
clarusc/lower.cla:1076:    return nm == IListPop() or nm == IListShift()
```
i.e. the predicate itself, plus its own doc comment naming the pattern it replaced.

**Goldens moved by c: none**, as predicted.

### h — `cgReturnStmt` single type computation (`0d26330`)

`retT = irExprType(x)` hoisted above `rk = irtKind(retT)`; the duplicate assignment
deleted. **Goldens moved: none.**

### f — kind-based textview dispatch (`9f375f0`)

The `TyWidget` arm dispatches on `findWidgetKind(wr.winNameIdx, wr.wgName)` and names the
actual kind in the `lowUnsupported` fallthrough.

**The receiver double-lowering hazard the brief flagged is real**, and the brief settles it
("pass `wr` in (add a parameter)"), so I did not stop: `lowWidgetRecv` calls
`lowExpr(selectX(recvAst))` / `lowWinInstRef()`, so it emits the receiver instance's IR, and
both `lowCanvasMethod` and `lowTextviewMethod` called it themselves. Both now take the
already-peeled `LowWidgetRecv` as a parameter. Neither had any other caller, so the change
is closed.

**Goldens moved: none** — `emitui/*`, `cg68k/goldens` and `selfhost/diag` (which owns
`scrollend_kind.expect` / `scrollend_arity.expect`) all unchanged. Those two fixtures are
rejected by the checker before lowering runs, so the new `lowUnsupported` path is not
reachable from them.

### g — fold Opened/Closed; declare `err` only when needed (`485b21a`)

`lowSynthConnFireSimple(eventKey, cName)` replaces the two 20-line copies;
`lowSynthConnDispatchers` keeps the opened/received/closed/failed order (IR order drives
emission order). `err` is declared only when some slot has a `failed` handler.

**Goldens moved by g: 30 of 31.** `connfailprobe.cla` — the one fixture that HAS a `failed`
handler — is byte-identical, exactly the attribution the spec predicted. Everything else
moves by the 260-byte frame shrink (`sizeof(error)`) plus the label/offset renumbering that
cascades from it:

```
-        ADDA.L #-108078,A0
+        ADDA.L #-107818,A0        (delta 260)
-LBL_229:                          -> LBL_230; the whole label range shifts by one
-        DBRA D0,LBL_229
+        DBRA D0,LBL_230
```

Verified directly on a freshly emitted `globals.cla`: `clar_conn_fire_failed` links
`LINK A6,#-2196` with no `err` local (it was `-2456`).

`enums.cla` and `peep_pushpop.cla` additionally dropped from two CODE segments to one at
this point — both were a few hundred bytes over the budget and 260 bytes pushed them under
(`enums` was `32738 + 468` and became a single `32784`-byte segment). Item e later took
another 15 fixtures the same way; see the table.

Corpus `.s` line count: **501110 → 500524 (−586)**.

### e — synthesized `clar_conn_pump` (`a488f76`)

`lowSynthConnPump` builds `clar_conn_pump()` beside the four `clar_conn_fire_*` dispatchers
(called last from `lowSynthConnDispatchers`), body `rtConnPump()` when `usesConn` and empty
otherwise; `lowUiSynthExternName` gains its identity entry; `runtime/clarus/native.cla`
declares `external func clar_conn_pump()` and `nat_UiConnPump` forwards through it.

**Controller question 4 answered:** `newIRCallFn(name: int, argsHead: int, ty: int)`
(`clarusc/ir.cla:2026`) takes an **interned name**, not an `irFuncs` index — it stores the
value straight into `IRExpr.name` and shake resolves the edge by name later. So no
`findIRFuncIdxByName` lookup and no abort are needed, and none was added.

**Acceptance met.** Emitting all 31 `testdata/cg68k` fixtures with
`emit68k --rtdir runtime/clarus/ --listing` and grepping every `out.seg*.s`, the only
listing that still contains an `rtConnPump`/`rtConnAlive` symbol is
`connfailprobe/out.seg3.s` — the one conn-using fixture. `globals.cla`, a non-conn UI
fixture: zero hits.

**`.s` line-count delta (the number the spec asks for)**, measured by emitting the whole
`testdata/cg68k` corpus with one driver script at each point:

| point | corpus `.s` lines |
|---|---|
| before g (≈ base, items a–f move no line counts) | 501110 |
| after g | 500524 |
| **after e** | **478983** |
| final (after d + the widened `smalltmp_ceiling` fixture) | 479175 |

**Item e alone: −21541 lines, −4.30%.** Whole task to that point: 501110 → 478983,
**−4.42%**. The final +192 is entirely `smalltmp_ceiling.cla` growing from 14 to 30
arguments; every other fixture is ±0 across item d.

Host lane unchanged — `emitui/goldens` is byte-identical, so **there is nothing for Task 10
to fold in from this item**. (`lowSynthConnDispatchers` runs on the host only when
`usesConn`, and no emitui fixture uses a connection.)

**Goldens moved by e: all 31**, plus 15 more fixtures dropping their second segment.

### d — per-function small-temp pool (`6031e59`)

Mirrors the big pool: `cgFuncSmallTmpNeed: list of int` + `cgFuncSmallTmpHigh: int`,
pre-sized to zeros in `cg68Measure` beside `cgFuncBigTmpNeed`, written back beside
`cgFuncBigTmpNeed[f] = cgFuncBigTmpHigh` at the end of `cgEmitFunc`. `cgAllocTmpOff` grows
the pool on the measure pass and aborts on the emit pass
(`"cg68k: small-temp need mismatch between measure and emit passes"`). `const cgTmpSlots`
deleted; `grep -n cgTmpSlots clarusc/cg68k.cla` returns nothing. One deliberate historical
mention survives in `clarusc/app68k.cla`, inside a comment that already says "AT THE TIME"
— it is recounting a Snow hang investigation, not describing live code.

**Deviation from sub-step 5, deliberate.** The brief puts `cgSmallTmpFirstOff` "at the point
where slot 0 would go", i.e. `runningNeg - 4` immediately before the small loop. When the
pool is laid out empty — which is every function on the measure pass, which is exactly when
growth happens — that is the SAME offset the very next line assigns to `cgRetSaveOff`; grown
slot 0 would alias the return-save slot and slots 1..n would alias the big pool and the deep
scratch. Harmless for correctness (measure-pass bytes are discarded and `AmDisp16` encodes
to the same size either way) but not harmless for *measurement*: `peepFunc` runs at the end
of every `cgEmitFunc`, and two temps at one displacement is the kind of thing a peephole can
fold, which would make the measure pass under-count a function's size and mis-pack segments.
I record `cgSmallTmpFirstOff = runningNeg - 4` **after** `cgReserveDeepScratch` instead, so
growth extends strictly below the whole frame and can never collide. Same single assignment,
one line later. (The big pool has the same latent exposure against the deep scratch today; I
did not touch it — out of scope.)

**Controller question 5 / sub-step 5's audit: no module-level var caches a frame offset
across the measure and emit passes.** Every one is re-derived inside `cgEmitFunc`'s own
frame layout on each call:

| var | where re-derived per function |
|---|---|
| `cgTmpBaseOffs` | `cgTmpBaseOffs = tmpOffs`, in the layout |
| `cgBigTmpBaseOffs` | `cgBigTmpBaseOffs = bigTmpOffs`, in the layout |
| `cgRetSaveOff` | `cgRetSaveOff = runningNeg`, in the layout |
| `cgDeepPtrOffs` / `cgDeepCountOffs` / `cgDeepIndexOffs` / `cgDeepValueOffs` | all four assigned by `cgReserveDeepScratch`, called from the layout |
| `cgSmallTmpFirstOff` (new) | assigned in the layout |
| `cgFuncFrameSizes[f]` | index-written on both passes, emit pass last; its only reader, `cgStackHeuristic`, runs after both |

The pass-to-pass offset shift the brief warns about is therefore already the established
situation: the big pool's own size differs between passes for any function needing more than
`cgBigTmpFloor` big temps, so `cgRetSaveOff` and everything below it already moved between
passes before this change. Instruction *encodings* are pass-invariant (`AmDisp16` is a fixed
16-bit extension word; `LINK`'s displacement likewise), which is why the byte counts the
measure pass exists to produce stay correct.

`testdata/cg68k/smalltmp_ceiling.cla` rewritten per the brief: `sum30` with 30 `int` params,
30 values pushed, called with 30 `nums.pop()` arguments, expects `465`; its header now says
it pins "no per-statement ceiling", not "works at 14". `testdata/run/smalltmp_ceiling.cla`
keeps its 14 (its `.behavior` blob stays valid) but its comment, which described the deleted
const, was corrected.

**Measured saving**, `testdata/cg68k/globals.cla`, summing every `LINK A6,#-n`:

```
before item d: 377598 bytes of frame across 173 functions
after  item d: 361186 bytes of frame across 173 functions
```

−16412 bytes, ≈95 bytes per function against a theoretical maximum of 96 (24 slots × 4).
Instruction counts do not change, so no fixture's `.s` line count moves; all 31 goldens move
on displacements alone.

**Goldens moved by d: all 31.**

Frame-cap check (the brief's specific worry): `cg68k/selfemit` PASSes —
`clarusc self-emit succeeded, packed into 58 CODE segment(s)` — so clarusc compiling itself
through `emit68k` at the default segment limit still fits, and that is the widest program in
the tree (its own worst statement previously needed 21 of the 24 slots).
`selfhost/behavior` (60 s) and `selfhost/crossgen` (113 s) also PASS.

---

## Golden attribution (`testdata/cg68k/*.s`, un-blessed)

Which item first moved each fixture, recorded by running `make test T=cg68k/goldens` after
every item:

| item | fixtures moved (cumulative state after that item) |
|---|---|
| **a** | `recs` only |
| **b** | none |
| **c** | none |
| **h** | none |
| **f** | none |
| **g** | 30 of 31 — everything except `connfailprobe` (the only fixture with a `failed` handler). `enums`, `peep_pushpop` also drop 2 segments → 1 |
| **e** | all 31. 15 more fixtures drop 2 segments → 1 |
| **d** | all 31 (frame displacements) |

Final state: **31 of 31 fixtures FAIL `cg68k/goldens`.**

**17 `*.seg2.s` goldens are now STALE and must be DELETED at bless time**, not just
rewritten — those programs pack into a single CODE segment now (item g for two of them,
item e for the rest). A bless run that only rewrites existing files will leave them behind
and `cg68k/goldens` will stay red on `stale-seg2`:

```
abort_bake.seg2.s  argmat_intr.seg2.s  argmat_nested.seg2.s  arith.seg2.s
bigtmp16.seg2.s    callback.seg2.s     calls.seg2.s          control.seg2.s
enums.seg2.s       gapclose3.seg2.s    mutrec.seg2.s         peep_pushpop.seg2.s
recs.seg2.s        smalltmp_ceiling.seg2.s  strs.seg2.s      traps.seg2.s
xrec.seg2.s
```

---

## Tests run

Bootstrap: `make -j tools bootstrap` (first command in the worktree, and after every source
edit).

**Step 10 — `scripts/test-task.sh --smoke`:**

```
$ scripts/test-task.sh --smoke
... 75 passed, 34 skipped, 1 failed
=== FAIL(exit 1) cg68k/goldens 3s
make: *** [t1] Error 1
```

The script is `set -e`, so the un-blessed goldens stop it before `make test T=perfgate/` and
`make smoke`. I ran the remaining stage separately:

```
$ make test T=perfgate/
PASS perfgate/tripwire 0s
```

`make smoke` was **not** run — see Concerns.

`cg68k/goldens` is the ONLY failure in the whole t1 body. Every other group is green,
including the ones this task's changes reach:

```
PASS cg68k/{determinism,image,release,selfemit}    SKIP cg68k/{array_assign,segments,vasm} (no vasm/)
PASS emitui/{appinfo,errconst,goldens,popupguards,uiblob}
PASS lowlevel/{constdedup,incdedup,rtinc,run,xrecorder}
PASS hostrt/{fileh,mem,rc,ser_leak,serial,slice_overflow,smoke,smoke_args,
              smoke_collections,smoke_log,smoke_slice_index_append,smoke_slice_oob,
              smoke_text_slice_len}
PASS conntest/{abort,connect,envunset,listen,shadow}
PASS sertest/{badfield,clrd,roundtrip}
PASS testsuite/{catalog,catalog_ui,core_cli,lazyintern}
PASS mactest/{leakgate,dblcompile,dblcompile_abort,dblcompile_bake}
PASS reftest/required, runner/{selfcheck,syntax,timeout}
PASS perfgate/tripwire
```

Separately (not part of t1):

```
$ make test T=selfhost/
PASS selfhost/behavior   60s
PASS selfhost/crossgen  113s
PASS selfhost/diag        1s
FAIL selfhost/fixedpoint  <- snapshot_fresh ONLY
```

`selfhost/fixedpoint`'s only failing subcase, verbatim:

```
FAIL snapshot_fresh: clarusc/clarusc.c is stale: committed snapshot (4935632 bytes)
!= fresh emission from the snapshot-built compiler (4935646 bytes).
first divergence at line 1204:
--- c2 ---  clar_lit_925 = {29, "method call on receiver kind "}
--- c3 ---  clar_lit_925 = {10, "method on "}
            clar_lit_926 = { 7, " widget"}
```

i.e. exactly item f's two new string literals. The script `t_done`s on that failure, so the
gen1==gen2 fixed-point half never ran; the equivalent coverage that DID run and pass is
`cg68k/selfemit` and `selfhost/crossgen`.

The toolbox suite compiles for the native lane with the extended `LeakCheck`:

```
$ xargs build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ \
      -o /tmp/cc6/tb/out.bin --listing < tests/mactest/toolbox_files.txt
... Emitted segment 7 ... Built fork ... Finished
```

---

## Self-review findings (reading my own diff)

1. **Item b's KRec hazard** — found by reading `cgCopyScratchToDst` and `cgStmt`'s SAssign
   gate *before* writing the change, not by a test. Nothing in the tree would have caught
   it: no `testdata/cg68k` fixture pops a handle-bearing record. Resolved by gating on
   `cgIsHandleKind`; see item b.
2. **Item b's KArr twin was NOT caught by reading** — `mactest/leakgate` caught it during
   Step 10, twice over (a C build error, then a runtime over-release). Fixed at the root
   in `53c60a0`. This is the strongest argument for having run the full gate rather than
   only the groups I expected to move.
3. **Item b had zero coverage on the native lane** until I added `poprelease` to
   `tests/cg68k/release.sh` — no golden moved, so a silent revert would have gone
   unnoticed. Verified the new pins fail against the pre-fix compiler.
4. **Stale doc comments** left behind by items b and c: `cgIntrListPopLike`'s header still
   said the result is "normally left UNTRACKED"; `cgDiscardExprIdx`'s and
   `fpDiscardExprIdx`'s consumer lists still named the pop/shift arm as a discard-test
   caller. All corrected (they ride in `6031e59`, since `cg68k.cla` already had item d's
   changes in flight; called out in that commit's message).
5. **Dead locals** removed with the branches that used them: `cgPushArgs`' `off`,
   `lowCanvasMethod`'s `wgSel`.
6. **`cgReturnStmt`'s "shared 14-slot small pool"** comment was two bumps out of date
   *before* this task; corrected as part of item d's const removal.

## Concerns

1. **Step 11 (native proof) is deferred: the emulator was busy.** `pgrep -x minivmac`
   returned **93979** at the start of the Step 10 run and again afterwards, so per the
   constraints I did not boot — which also means `make smoke` did not run.
   **`PASS LeakCheck` / `PASS ClearWarm` / `TOTAL 36 PASS 36 FAIL 0` is UNVERIFIED.**
   The command to run once the emulator is clear (this worktree now has the
   `toolchain`/`macplus` symlinks it needs):
   `CLARUS_MAC_TESTS=1 make -j1 test T='mactest/toolbox_68k mactest/toolbox_jiggle mactest/coresuite_68k'`
   plus `make smoke`. What IS verified without hardware: the toolbox suite compiles for the
   native lane, `mactest/leakgate` (the host-side leak oracle) passes including the new
   `ArrElem` path, `cg68k/release`'s release counts pass including the three new pop pins,
   and `hostrt/ser_leak` passes.
2. **A KRec pop in receiver position is still a leak** — `lst.pop().field` where the element
   is a handle-bearing record. Item a's gate is `ECallFn`-only so `cgMaterializeToTemp` does
   not track the `EIntr` pop, and item b deliberately does not track the KRec scratch. This
   is pre-existing, unchanged by this task, and not in the phase's entry list. The fix is to
   extend item a's condition to `EIntr and lowIntrIsOwningContainerRead(...)` **for KRec
   only** (extending it to handle kinds would double-track against item b), plus a
   `LeakCheck` shape. Recorded as a follow-up rather than done: the brief did not ask, and
   the shape has no fixture anywhere in the tree.
3. **The bless must delete 17 stale `*.seg2.s` goldens** (listed above), not only rewrite
   the 31 that moved. Worth confirming `CLARUS_CG68K_BLESS=1` removes them; if it does not,
   `git rm` them in the same commit.
4. **Nothing for Task 10 from item e.** `emitui/goldens` is byte-identical after every item
   in this task, so the emitui regeneration Task 10 owns has no input from here.
5. **Two `.superpowers`-adjacent environment changes I made** and did not commit (they are
   gitignored): the `Retro68` / `toolchain` / `macplus` symlinks in this worktree. Harmless,
   but worth knowing they exist if the worktree is inspected or reused.

---

# Fix round 1 — review findings addressed

Review: `.superpowers/sdd/2026-09-05-compiler-cleanup/task-6-review.md` (base `311af68` →
head `ad76fa4`). All five findings addressed in one commit, `e6f8564`.

**Status after this round: DONE_WITH_CONCERNS**, unchanged in shape — the only red is the
un-blessed `cg68k/goldens` (31/31) and `selfhost/fixedpoint`'s `snapshot_fresh`. Still no
bless. Native proof still deferred: the emulator is busy.

## Critical 1 — double release of a handle-bearing record in argument position

Confirmed and fixed at the root. `cgPushArgs`' KRec-copy arm scheduled
`cgPendingArgReleases` for `ak == ECallFn or ak == ENewRec`, but item a made
`cgMaterializeToTemp` TRACK the ECallFn case, so `take(mk())` walked `cg_release_R` twice
on the same slot — an rc underflow, not a leak, and invisible to every host gate because
item a never touched `cprint.cla`.

**Fix: drop the `ECallFn` half, keep `ENewRec`** (`clarusc/cg68k.cla` ~10002). The tracked
temp's end-of-statement release via `cgFreeStmtTmps` is the single owner now. That is
*later* than `cgFlushArgReleases` but just as safe: the callee borrows the record by
address and cannot outlive the call, and the big-temp pool is bump-allocated per statement
(`cgStmtBigTmpNext` resets only at statement start), so nothing reuses the slot in
between. `ENewRec` stays on the pending path because item a's gate is `ECallFn`-only, so a
`new R` argument is still untracked and this is its only release.

I took the "drop the scheduling" option rather than `cgHandoff` there: one fewer moving
part, and it keeps the producer as the single owner, which is the invariant item a
established everywhere else.

**Grep for other double-schedulers, as asked — there are none.** `cgMaterializeToTemp` has
exactly two callers:

| caller | schedules its own release? |
|---|---|
| `cgExprAddr`'s generic fallback (`cg68k.cla:5984`) — the receiver shape | no |
| `cgPushArgs` (`cg68k.cla:9999`) — the argument shape | yes; this is the one fixed |

And the other consumers of an `ECallFn`-produced KRec never materialize at all:
`cgEmitStoreRec`'s `sk == ECallFn` arm routes straight through `cgCallFnInto` into `dst`
(hidden-result-pointer convention, no temp), and `cgReturnStmt` / `cgStmt`'s SAssign hand
off through `cgLastTrackedOff`, which a KRec never sets.

Before / after on the reviewer's own shape (`recArg` = `return take(mk())`):

```
pre-fix:   BSR.W LBL_227   (cg_release_R)      <- twice
           BSR.W LBL_227
post-fix:  BSR.W LBL_227                       <- once
```

## Important 1 — native oracle for item a

`tests/cg68k/release.sh` gains a `recmaterialize` section, in the same style as the three
that were already there. It counts calls to `cg_release_R` — the record's own release walk,
which `cgEmitRcWalks` emits as a bare label carrying a `; cg_release_R(rec ptr at 8(A6))`
comment rather than a `; func` marker, so the section resolves the label from that comment
instead of through `func_seg`.

| case | shape | want |
|---|---|---|
| `recmaterialize_recArg` | `return take(mk())` | 1 |
| `recmaterialize_recRecv` | `return mk().s.length` | 1 |

**RED check.** Against this branch's own pre-fix compiler (`git stash` of just the
`cg68k.cla` fix, rebuild):

```
FAIL recmaterialize_recArg: recArg: 2 LBL_227 (cg_release_R) calls, want 1
PASS recmaterialize_recRecv
```

i.e. exactly the regression Critical 1 names. Against the **task base** (`311af68`
`clarusc/` + `runtime/clarus/native.cla`, rebuilt) the section reports
`FAIL recmaterialize_seg: fixture packed into 2 segments, want 1` instead — the base
compiler still carries the whole conn runtime, so item e's shrink is what makes this
fixture single-segment. The single-segment assertion is deliberate and stays: the walk is
duplicated glue in every segment, so a same-segment `BSR.W` is the only call form the
counter can see, and a cross-segment `JSR d(A5)` would silently count 0. The pin therefore
guards the invariant going forward and is red on the exact bug it closes; it cannot also
serve as a base-vs-head oracle for item a's original leak. (`poprelease_recv` 0→1 and
`poprelease_operand` 1→2 do measure cleanly against the task base.)

## Minor 1 — `cgLastTrackedOff` set last

`cgIntrListPopLike` now records `tracked` at the allocation gate and sets
`cgLastTrackedOff = off` after `cgJsrByName`/`cgCleanupStack`, immediately before the
return — the invariant `cgIntrListFirstLast`, `cgIntrTextConcat` and `cgCallFnScalar` all
keep, and the one `cgLastTrackedOff`'s own doc comment states. Behaviour is unchanged
(nothing between the two points touches the var); the point is that the invariant is now
literal rather than incidentally true. Goldens unmoved.

## Minor 2 — abort message no longer misattributes

The reviewer is right that a small temp allocated outside `cgEmitFunc`'s layout
(`cgEmitInitGlobalsStub` → `cgEmitGlobalInitExpr` → `cgExpr`, e.g. `var g: text = mk()`)
now lands in `cgAllocTmpOff`'s abort. New text, verified on exactly that fixture:

```
$ clarusc emit68k -o gi.bin gi.cla        # var g: text = mk()
cg68k: small-temp pool exhausted -- emitted outside a laid-out function frame, or measure/emit disagreed
```

with a comment above it recording both causes and that the first one is pre-existing (the
same fixture dies as `runtime error: list index out of range` on the pre-change compiler).
Kept short because Clarus string literals cap at 255 bytes.

## Minor 3 — not done here, by instruction

The native/host asymmetry is not added to `docs/TODO.md` — Task 10 owns docs. Concern 2
below is restated precisely for that purpose.

## Tests

```
$ make test T='cg68k/release cg68k/goldens emitui/goldens lowlevel/ mactest/leakgate hostrt/'
PASS cg68k/release 1s          <- incl. recmaterialize_recArg, recmaterialize_recRecv
FAIL(exit 1) cg68k/goldens 2s  <- un-blessed, 31/31, attribution unchanged
PASS emitui/goldens 2s
PASS lowlevel/{constdedup,incdedup,rtinc,run,xrecorder}
PASS mactest/leakgate 2s
PASS hostrt/{fileh,mem,rc,ser_leak,serial,slice_overflow,smoke,smoke_args,
              smoke_collections,smoke_log,smoke_slice_index_append,smoke_slice_oob,
              smoke_text_slice_len}

$ scripts/test-task.sh
tests: 75 passed, 34 skipped, 1 failed
FAIL(exit 1) cg68k/goldens 3s        <- the only failure in the whole t1 body
make: *** [t1] Error 1

$ make test T=perfgate/               # set -e stops test-task.sh before this stage
PASS perfgate/tripwire 0s
```

Golden attribution is unchanged by this round — the Critical 1 fix removes a release from
`cgPushArgs`' ECallFn path, which no `testdata/cg68k` fixture exercises (that is why it
needed the new `recmaterialize` pin). Still 31/31 red, still these 17 `*.seg2.s` goldens
stale and needing DELETION at bless time:

```
abort_bake  argmat_intr  argmat_nested  arith  bigtmp16  callback  calls  control
enums  gapclose3  mutrec  peep_pushpop  recs  smalltmp_ceiling  strs  traps  xrec
```

## Native proof — still deferred, emulator busy

`pgrep -x minivmac` returned **93979** during Step 10 and **38339** now (a different
process, so something is actively booting — the coordinator says Task 5 owns it). No boot
attempted. Still owed, and the reviewer is right that it matters more after Critical 1:

```
CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k
```

## Concern 2, restated precisely (for Task 10's TODO entry)

**Shape:** `lst.pop().field` / `lst.pop() + x` — a `list of R` where `R` is a record with
at least one handle field (`text`/`list`/`map`), popped and consumed in a receiver or
operand position rather than assigned, returned, or passed as an argument.

**Lane:** native (`emit68k`) only. The host lane (`cprint`) releases it correctly.

**Why:** `cgIntrListPopLike`'s always-track gate is `cgIsHandleKind`, which excludes KRec
deliberately. A handle-bearing KRec element is >4 bytes, so the pop writes into a big-pool
scratch whose OFFSET is handed back to `cgEmitStoreRec` / `cgEmitReturnRec` /
`cgMaterializeToTemp`; those block-copy the bytes out with `cgCopyScratchToDst` (no
retain) into a destination that then owns them, and none can untrack the scratch because
`cgLastTrackedOff` is consulted only for a handle kind. Tracking the scratch would
double-release. In a receiver/operand position nothing takes ownership, so the record's
handle fields leak — one block per evaluation. The host has no such hazard: `fpStmt`'s
SAssign hands a KRec temp off by name and SReturn hands off unconditionally, so
`fpNeedsRelease` can gate the whole thing there.

**Fix when scheduled:** extend item a's `cgMaterializeToTemp` gate to
`irExprKind(e) == EIntr and lowIntrIsOwningContainerRead(irIntrName(e))` **for KRec
only** — extending it to handle kinds would double-track against item b, which already
tracks those at the producer. Plus a `LeakCheck` shape, since no fixture in the tree pops a
handle-bearing record today.
