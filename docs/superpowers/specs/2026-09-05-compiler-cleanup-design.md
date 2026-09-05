# Compiler-cleanup phase — design

**Date:** 2026-09-05
**Status:** approved (Andrew, 2026-09-05, in-session)
**Branch:** `compiler-cleanup`

## Why now

`docs/TODO.md`'s "Compiler correctness / diagnostics" section has
accumulated 30 entries across seven phases (2026-07-23 to 2026-08-29).
One is marked FIXED and kept as a record; the other 29 are open (the
in-session count of "25" was a miscount, corrected here). Most are
small, but several force the same expensive regeneration — every
`testdata/cg68k/*.s` golden, the `clarusc.c` snapshot — so fixing them
one phase at a time has meant paying that cost repeatedly. Andrew's
direction (2026-09-05): fix every open entry in the section in ONE
phase, structured so goldens are blessed at most twice and the snapshot
regenerated once.

Every entry was re-verified against the current tree on 2026-09-05
(three read-only survey agents; line numbers below are from that survey
and are approximate — several TODO citations had drifted). Three entries
turned out not to be what the TODO records; their dispositions are in
§1 and they are NOT worked as fixes.

## 1. Entry dispositions (the 29 open entries)

| # | TODO entry | Disposition | Section |
|--:|-----------|-------------|---------|
| 1 | Lexer diagnostic quality | fix | §4.2 |
| 2 | `edit F, sm[k]` / `im[k]` | fix | §4.2 |
| 3 | `declIsRuntimeOrigin` symlink residual | fix (by construction) | §4.4 |
| 4 | Discard-tracking generality | fix (one predicate, two call sites) | §4.1 |
| 5 | Parameter-escape-summary precision | **obsolete — delete** (the analysis it refers to was deleted in `e4b592f`; scope-exit release is unconditional now, there is nothing to make more precise) | — |
| 6 | `transportName(tag)` fallthrough | fix | §4.3 |
| 7 | Transport-misuse diagnostic column | fix | §4.3 |
| 8 | Three connection-dispatcher builders share ~25 lines | fix | §4.1 |
| 9 | `lowSynthConnFireFailed` unused `err` local | fix | §4.1 |
| 10 | Every native binary carries the conn runtime | fix | §4.1 |
| 11 | No emitted-C golden for `cpEmitMain`'s pump loop | fix | §3.5 |
| 12 | `cgLastTrackedOff` aliasing hazard in `cgIntrMapGetDv` | **already fixed — delete** (the `cgLastTrackedOff = -1` reset landed in the 68k-call-result-release phase, `cg68k.cla` ~7811-7823, comment "Task 1 probe item 1c hardening") | — |
| 13 | STILL LIVE unspliced-runtime-function crash | **close with evidence** (no longer reproduces: every native name-resolution site guards with a clean abort, `drive.cla` catches a missing module pre-splice, the checker catches an undeclared name; the one remaining shape is the `usesConn` gap, entry 17, fixed here). A fixture pins the guard. | §4.3 |
| 14 | Testing-strategy gap: `--rtbake` has no T1 smoke | fix | §3.6 |
| 15 | `expand()` marks `seenPaths` before a successful read | fix | §4.4 |
| 16 | Record-field-only `connection` never sets `usesConn` | fix (gap is wider than recorded: locals, params, return types, list/map elements all miss it) | §4.3 |
| 17 | `string("x")` diagnostic / `string(char)` | fix (as redefined 2026-09-05) | §4.2 |
| 18 | Duplicate-`const` cites only the second position | fix | §4.2 |
| 19 | `cgReturnStmt` computes `irExprType(x)` twice | fix | §4.1 |
| 20 | `drive.cla` prelude-splice rationale at 4 sites | fix (the two driver-internal restatements only; `bake.cla` untouched) | §4.4 |
| 21 | `makeRec().field` leaks (native) | fix | §4.1 |
| 22 | `smalltmp_ceiling.cla` pins the old 14-slot ceiling | fix (folded into entry 26) | §4.1 |
| 23 | `pop`/`shift` as operand/receiver leaks, both lanes | fix | §4.1 |
| 24 | Four more stale-master-pointer sites | fix | §3.1 |
| 25 | Suite GUI's own case table draws through a stale pointer | fix (checksum case) | §3.4 |
| 26 | `cgTmpSlots` 14 → 24 costs +40 bytes of frame per function | fix (per-function high-water) | §4.1 |
| 27 | Second `textview` method needs kind-based dispatch | fix | §4.1 |
| 28 | Textview scroll range 16-bit ceiling | fix | §3.2 |
| 29 | cprint-lane toolbox twin fails to link | fix | §3.3 |

(Entries 22 and 26 are one fix. The section's one FIXED row — the
`--rtbake` + method-call crash — stays in TODO as a record and is not
listed.) At close-out the section is emptied of every row above: each is
either deleted (fixed/obsolete) or moved to `HISTORY.md`'s phase entry
with its evidence.

## 2. Structure: two waves, two blesses, one snapshot

Golden churn drives the structure.

- **Wave 1 — runtime + harness.** No `clarusc/` change. Runtime `.cla`
  edits DO ripple into `testdata/cg68k/*.s` and `testdata/emitui/
  *.c.golden` (the runtime is spliced into every fixture build), so
  wave 1 ends with **bless #1**, a mechanical rebless whose diff must be
  attributable to the runtime edits alone. The `clarusc.c` snapshot is
  untouched (it is the compiler, not the runtime).
- **Wave 2 — compiler.** Three tracks. The codegen track is ONE task
  because each of its items touches most `.s` goldens; the diagnostics
  and driver tracks run in parallel with it (disjoint files, disjoint
  fixtures). Wave 2 ends with **bless #2** plus the single snapshot
  regeneration (`tests/selfhost/fixedpoint.sh`'s `snapshot_fresh`
  recipe).
- **Close-out.** Full T2, final whole-branch review, docs.

Wave 1 runs first so that bless #2's diff is compiler-only. Parallel
tasks within a wave must not bless: a task whose T1 run shows golden
diffs reports them; the wave-end bless task reviews and blesses once.

## 3. Wave 1 — runtime and harness

### 3.1 Four stale-master-pointer sites (entry 24)

All four are the shape `bff3268`'s "re-derive immediately before the
call" rule CANNOT fix: the master pointer is passed INTO an allocating
Toolbox trap, so the relocation window is inside the call. The heap-
jiggle harness hooks only the `UiNewPtr` waist and cannot exercise any
of them. The applicable shape is `rtUiMakeLdefStub`'s (`uitable.cla`
~511): `UiHLock` the handle across the read, `UiHUnlock` after.

Sites (survey line numbers):

- `runtime/clarus/uitable.cla` ~411, `rtUiTableDrawField`'s string arm:
  `UiDrawText(base + 1, 0, peekb(base))`. Lock the record handle around
  the call.
- `runtime/clarus/uitable.cla` ~887, `rtUiTableSyncOne`:
  `UiInvalRect(lhMp + rtUiListRView)` (already re-derived one line
  above; still handed into an allocating trap). Lock `lh` around it.
- `runtime/clarus/uiwidgets.cla` ~853 and ~955, `UiInvalRect(
  UiHandleDeref(te) + rtUiTeViewRect)`. The ~955 site's pointer is
  reused as `teMp` for the paired `UiValidRect` (~991) in the live-paint
  path: lock `te` across the whole InvalRect..ValidRect region, not
  just the one call, and re-check that nothing between them requires
  the TERec to be relocatable (TextEdit calls that grow the text do).
- `runtime/clarus/uiwidgets.cla` ~1155 (TODO said 1093), the
  `table.selected` setter: `UiInvalRect(UiHandleDeref(lh) +
  rtUiListRView)`. Lock `lh` around it.

Alternative for the InvalRect sites: copy the rect into a local
(`peekw` × 4 into a stack `Rect`) and pass the local's address — no
lock/unlock pair, no relocatability question. The implementer may choose
per site; the spec's requirement is that no master pointer is live
across an allocating trap at any of the four sites.

**Proof.** Honest statement: no deterministic red-to-green exists for
this class (the jiggle waist cannot see an allocation inside a trap).
Proof is (a) the full native suite boots green — `toolbox_68k.sh`,
`toolbox_jiggle.sh`, `coresuite_68k.sh`, the four frozen scenarios — and
(b) reviewer verification that each site meets the requirement above.

### 3.2 Textview 16-bit scroll ceiling (entry 28)

`runtime/clarus/uitext.cla` `rtUiTeScrollSync` (~323): `maxScroll`/
`contentH` are `int`, but `UiTEScroll`'s `dv`, `UiSetControlMaximum`'s
and `UiSetControlValue`'s values are `word`. Fix: after each existing
`if maxScroll < 0 { maxScroll = 0 }` (vertical ~347-351, horizontal
~368-372) add `if maxScroll > 32767 { maxScroll = 32767 }`; the existing
`offset > maxScroll` clamp then bounds `offset` transitively.
`rtUiWidgetScrollToEnd` (`uiwidgets.cla` ~1020) calls the sync and
inherits the clamp. Straight clamp, not proportional remapping: no user
has hit the ceiling, fidelity at it is not a requirement. No test — a
>32767-px textview needs >32 KB of text, over TextEdit's cap.

### 3.3 cprint-lane toolbox twin link failure (entry 29)

`runtime/mac/rt_ext_mac.inc` gains two shims next to
`rt_ext_GetHandleSize` (~43):

```c
int32_t rt_ext_TbFreeMem(void) { return (int32_t)FreeMem(); }
int32_t rt_ext_TbClearWarmFreeMem(void) { return (int32_t)FreeMem(); }
```

Both `.cla` externs (`cases_leak.cla:25`, `cases_clearwarm.cla:16`) bind
trap `0xA01C` under different Clarus names, and cprint emits
`rt_ext_<ExternName>` per extern, so both symbols are needed.
`<Memory.h>` is already included; `build-mac.sh` compiles `rt_mac.c`
into every app, so no build change. Proof: `CLARUS_MAC_TESTS=1
CLARUS_CPRINT_MAC_TESTS=1 make test T=mactest/toolbox_mac` links and
boots (the two pre-existing cprint-lane case failures recorded in
`CLAUDE.md` — `FileHandleRW`/`DirOps` — are in the CORE twin, not this
one; if the toolbox twin shows its own pre-existing reds they are
reported, not fixed, this phase).

### 3.4 Suite-table checksum case (entry 25)

New toolbox case `CasesTable` (`testsuite/toolbox/cases_casestable.cla`)
modeled on `cases_popuptable.cla`'s three-checksum shape: `UiTestChecksum`
over an 8-px-aligned band covering one row of `gui.cla`'s own `Cases`
table (`table Cases { at: 10, 10 ... }`, global rect (46,54)-(346,174)
per `gui.cla`'s header derivation), asserting the band is non-blank
while a row is present and that a second checksum of the same band on a
later paint equals the first (a zeroed record — the `lastLen 0` probe
result recorded in the 68k-call-result-release debug report — paints
differently). Bookkeeping: `ToolboxTest` enum member, `tbCaseName`
arm, `tbAllCases` entry, dispatch arm, `nTbCases` 35 → 36; the three
`suite_report_check ... 35` sites (`toolbox_68k.sh:19`,
`toolbox_jiggle.sh:28`, `toolbox_mac.sh:26`) → 36; `toolbox_files.txt`
gains the file. `runner.cla` ~354's stale "32 real cases here" comment
(a repeat of the drift `docs/TODO.md` already records once) is replaced
by wording that carries no number.

### 3.5 Emitted-C golden for the pump loop (entry 11)

`tests/emitui/goldens.sh` already byte-compares every
`testdata/emitui/*.cla` with a committed `.c.golden` and then compiles
the golden with the Retro68 gcc; it is not UI-gated. Add one small
non-UI fixture `testdata/emitui/connpump_abort.cla` that uses a
`connection` AND `abort` (so `cpEmitMain` emits the full `while
(!clar_aborting && clar_fn_rtConnAlive())` shape, `cprint.cla`
~7596-7604) plus its generated `.c.golden`. Zero script change.

### 3.6 `--rtbake` T1 smoke (entry 14)

`tests/bake/identity.sh` (6 cg68k fixtures + the clarusc self-compile)
and `tests/bake/connfileh.sh` already run ungated in T1. The one
per-lane value-typed runtime split with no T1 tripwire is `datetime`
(`datetime_68k.cla`/`datetime_c.cla`). Add `tests/bake/datetime.sh`
mirroring `connfileh.sh` (an `emit68k_pair` byte-identity over a
fixture touching `now()`/datetime fields). The TODO entry's recorded
lesson (a whole phase shipped `--rtbake`-broken) is carried into
`HISTORY.md`; the standing rule becomes: **a phase that adds a new
value-typed runtime module adds its `tests/bake/<module>.sh` twin in
the same task.** That sentence goes in `CLAUDE.md`'s test section.

## 4. Wave 2 — compiler

### 4.1 Codegen track — ONE task (entries 4, 8, 9, 10, 19, 21, 22, 23, 26, 27)

Serialized because items b, c, d, e each touch most `.s` goldens.

a. **`makeRec().field` leak (21).** `cg68k.cla` `cgMaterializeToTemp`
   (~5811): `off = cgAllocTmpOff(t)` is always untracked. Change to
   `cgNewTrackedTmp(t)` when `irExprKind(e) == ECallFn and
   cgNeedsRelease(irExprType(e))` — the native mirror of `cprint.cla`
   `fpCallFn` ~1541-1554, which already tracks the same shape.
b. **`pop`/`shift` as operand/receiver (23), both lanes.** Native
   `cgIntrListPopLike` (~7435-7462) tracks only when `e ==
   cgDiscardExprIdx`; drop that gate and track whenever
   `cgNeedsRelease(elemT)`, letting `cgHandoff` untrack on consumption
   (the shape `cgIntrListFirstLast` ~7481-7497 already uses). Host
   `fpIntrCall`'s pop/shift arm (`cprint.cla` ~3039-3053): `fpNewTmp` +
   no-op `fpHandoff` → `fpNewTrackedTmp`, same rule.
c. **Discard-tracking generality (4).** `lowIntrIsOwningContainerRead`
   (`lower.cla` ~1057) is the one authority (today: `IListPop`,
   `IListShift`, exhaustive). `cprint.cla` ~3003 and `cg68k.cla` ~8591
   each re-spell the `nm == IListPop() or nm == IListShift()` chain;
   route both through the predicate. A third transfer intrinsic then
   has one place to be added, and the discard arms follow by
   construction. No separate self-check — the audit gap closes by
   removing the copies.
d. **Per-function small-temp high-water (26, 22).** `cgTmpSlots = 24`
   (~1402) is laid out flat in every frame (~5251-5258). Mirror the big
   pool's two-pass scheme (`cgFuncBigTmpNeed`/`cgFuncBigTmpHigh`,
   `cgAllocBigTmpOff`, `cgEmitFunc` ~5281-5292): `cgAllocTmpOff`/
   `cgNewTrackedTmp` bump a per-function high-water on the measure
   pass; the emit pass lays out exactly that many slots (floor 0 — a
   function with no temps reserves none). The ceiling disappears with
   the flat pool. `testdata/cg68k/smalltmp_ceiling.cla` is extended to
   30 concurrent small temps (pins "no ceiling", not "works at 14").
   The frame-size cap (~5308) stays.
e. **Conn runtime in every native binary (10).** Root-gating alone is
   insufficient: `runtime/clarus/ui.cla` ~2647's event loop calls
   `UiConnPump()` unconditionally → `nat_UiConnPump` → `rtConnPump`,
   so the conn runtime is reachable through the UI runtime regardless
   of `cg68AddRoots`. Use the seam the four empty `clar_conn_fire_*`
   dispatchers already use (`lower.cla` ~7390-7399, always synthesized
   under `want68k`): synthesize a fifth, `clar_conn_pump()`, whose body
   is `rtConnPump()` when `irUsesConn` and EMPTY otherwise; `native.cla`
   ~1474's `nat_UiConnPump` calls `clar_conn_pump()` instead of
   `rtConnPump()` directly. `rtConnPump` and everything under it then
   drop out of a non-conn build's reachability walk. The empty
   dispatcher stubs stay unconditional (the link-time-loud seam the
   serial-connection review verdicted SOUND). Acceptance: a non-conn UI
   program's `.s` contains no `rtConnPump`/`rtConnAlive` symbol; the
   `.s` line delta on the cg68k corpus is recorded in the task report
   (the TODO measured +5-7%). `cg68AddRoots`'s `nat*` loop is left as
   is — it is no longer the lever.
f. **Textview kind-based dispatch (27).** `lowMethodCall`'s `TyWidget`
   arm (`lower.cla` ~1326-1353) routes by method NAME. Replace with
   `lowWidgetRecv` (~1608) + `findWidgetKind(recv.winNameIdx,
   recv.wgName)` (`check.cla` ~3961) and switch on the kind string:
   `"textview"` → `lowTextviewMethod`, `"canvas"` → `lowCanvasMethod`,
   else `lowUnsupported` naming the kind. `scrollend_kind.expect`/
   `scrollend_arity.expect` are checker-level and unaffected.
g. **Dispatcher builders (8) + unused `err` (9).** `lowSynthConnFireOpened`/
   `...Closed` (`lower.cla` ~7413-7471) differ only in the event-key
   and C-name strings: fold into one `lowSynthConnFireSimple(eventKey,
   fnName)`. `lowSynthConnFireFailed` (~7537-7582) adds its `err` local
   (`lowAddLocal(intern("err"), irErrT)`, ~7557) unconditionally; add
   it only when at least one slot has a `failed` handler. IR/emission
   for Opened/Closed must be byte-identical (goldens unchanged by g);
   the `err` elision changes frames in `connfailprobe.seg4.s`-class
   goldens — same task, same bless.
h. **`cgReturnStmt` (19).** `cg68k.cla` ~12227/12232: compute
   `retT = irExprType(x)` once, `rk = irtKind(retT)`. No emission change.

**Hardware proof for a/b.** `testsuite/toolbox/cases_leak.cla`'s
`LeakCheck` gains two loop shapes beside the existing `tlkMake()` ones:
a handle-bearing-record-returning call consumed as a receiver
(`makeRec().field`) and `lst.pop().length`/`lst.pop() + x`. FreeMem
must stay exactly flat across the same 1500-iteration cycles. Host
parity for b: a `tests/lowlevel` (or existing leak-golden) fixture
asserting the emitted C's release call appears for the operand shape.

### 4.2 Diagnostics track — `lex.cla` / `check.cla` conversions+const+edit (entries 1, 2, 17, 18)

Each item lands with a fixture in `testdata/errors/` (`.cla` +
`.expect`) run by `tests/selfhost/diag.sh`'s byte-exact compare. The
pre-existing `testdata/diag/{lex_badescape,lex_untermstr,chk_conv*}.cla`
fixtures are inert (empty `.expect`, referenced by no runner) and are
deleted in this track rather than left as dead weight.

a. **Lexer (1).** `lex.cla` `lexString` (~522-566): on
   `lexDecodeEscape` failure the message is `unterminated string
   literal` and the function `break`s without resyncing, so the rest
   of the literal is re-lexed and the next `"` opens a phantom string
   that runs to EOF — the cascade. Fix: message → `invalid escape
   sequence`; add `lexResyncStringLit()` mirroring `lexResyncCharLit`
   (~470-481): advance to and consume the closing `"`, or stop at
   newline/EOF, before returning. Exactly ONE diagnostic for
   `"a\qb"`. No lazy lexing, no truncate-after-first: the cascade was
   a missing resync, not an architecture. Fixture
   `lex_str_badescape.cla`: one line of `.expect`.
b. **`edit F, sm[k]` / `im[k]` (2).** `checkEditStmt` (`check.cla`
   ~4985-5047) checks only the target's TYPE; `lowEditStmt` (`lower.cla`
   ~3452-3481) is what restricts the SHAPE and dies via
   `lowUnsupported` (a hard `abort`, exit 3). Move the shape rule into
   the checker: target must be an identifier, a list element, a map
   (`TyMap`) element, or `new`; anything else — a sortedmap/intmap
   element, a nested field like `holders[0].b` — gets the checker
   diagnostic `edit target must be a variable, list element, or map
   element` at the target's position. Lowering keeps its
   `lowUnsupported` as an unreachable defensive fallback.
   `tests/emitui/popupguards.sh`'s `edit_bad_target` row (nonzero exit
   + that substring) keeps passing with the checker's exit 1. New
   fixtures: `edit_sortedmap_elem.cla`, `edit_intmap_elem.cla`.
c. **Conversion wording + `string(char)` (17).** `checkConversion`
   (`check.cla` ~5609-5648). Message template becomes
   `<name>() expects <accepted>, got <actual>`: `string() expects an
   int or char, got string`; `int() expects a fixed, char, enum, or
   ptr, got int`; `fixed() expects an int, got fixed`; `char() expects
   an int, got string`; `ptr() expects an int or overlay, got string`;
   `<EnumName>() expects an int, got string`; `<OverlayName>() expects
   a ptr, got int`. Identity conversions remain errors (decision
   recorded in TODO 2026-09-05: every conversion is an explicit change
   of type; assignment already copies a string). The `name == "string"`
   arm accepts `TyChar` alongside `TyInt`. Lowering (`lower.cla`
   ~1270): `TyInt` → `IIntToStr` as today; `TyChar` → `IStrConcatChar`
   over an empty string literal and the arg, the IR `"" + c` already
   produces (~810) — no new intrinsic, runtime function, or backend
   arm. Fixtures: `string_conv_arg.expect` reblessed to the new
   wording; new `int_conv_identity.cla` (`int(i)`); positive
   `string('a') == "a"` and `string(c)` for a variable `c` added to
   `testsuite/core`'s `IntToStr` case. Reference: the Numeric
   Conversions example block gains `var s2: string = string(c) // char
   to string, "a"` and the paragraph after it says `string()` takes an
   `int` or a `char`.
d. **Duplicate-`const` (18).** `checkConstDecl` (~2834-2838) emits one
   `redeclaration of X` at the second decl. Mirror
   `emitConflictingExtern` (~3343-3349): two diagnostics, one at each
   declaration, each suffixed `(also declared at L:C)`. The first
   decl's index must be recoverable (a `constFirstDeclByName` beside
   `externFirstDeclByName`, or the decl index stored on the symbol —
   plan's choice). Fixture `const_dup.cla`: two `.expect` lines.

### 4.3 Diagnostics track — `parse.cla`/`check.cla` transport + `usesConn` (entries 6, 7, 13, 16)

a. **Transport keyword position (7).** `parse.cla` `parseArgs`
   (~616-647) records the transport as the bare int `parseArgsTransport`
   and `advance()`s past the keyword without saving its position;
   `newCall`'s line/col are the `(`. Add `parseArgsTransportLine`/
   `parseArgsTransportCol` out-globals (the same idiom as
   `parseArgsTransport`), captured before the `advance()`, carried on
   the call node (or a side table keyed by call index — plan's
   choice), and used by both `emitDiag` sites in `checkCall` (~5832,
   ~5844). Fixture: `transport_misuse_col.cla` whose `.expect` column
   is the keyword's.
b. **`transportName` exhaustive (6).** `check.cla` ~5799-5804: `1 →
   "appletalk"`, `2 → "serial"`, anything else → `abort("clarusc:
   unknown transport tag N")` (an internal invariant, not a user
   diagnostic; callers pre-filter `tag != 0`).
c. **`usesConn` (16).** The only setter is `checkTopDeclPhase1`'s
   `DkVar` arm (~6098-6124), so ONLY a global `var x: connection` sets
   it; locals, params, return types, record fields, and `list of
   connection` elements all miss it, and `drive.cla` ~1615's host-lane
   splice of `conn.cla`/`conn_c.cla` is skipped → link error. Move the
   check into `resolveType`'s `TxNamed` arm beside the `fileHandleT`
   hook (~2296-2302): `if symbols[symIdx].typeIdx == connectionT {
   usesConn = true }`. Delete the `DkVar`-only site. Fixtures: a
   `tests/conntest` (host) case compiling and running a program whose
   only `connection` is a record field, and one whose only
   `connection` is a param; both must build and link.
d. **Unspliced-function guard fixture (13).** One `tests/cg68k` script
   composes a program that DECLARES (via a local `func` stub named like
   a runtime function, or via `--rtdir` pointing at a copy with one
   module removed) and calls a runtime function the build never
   splices, and asserts clarusc exits nonzero with a message naming
   the function (the `cgJsrByName`/`cgCallFnScalar` `abort("cg68k: X
   not found/reachable")` family, `cg68k.cla` ~10026-10037,
   ~11825-11833) — never `list index out of range`, never exit 3 from
   a runtime error. If the survey's "cannot reproduce" holds, the
   script proves the guard; if a crash path is found, it is fixed in
   this task and the fixture pins it.

### 4.4 Driver track — `drive.cla` / `lower.cla` (entries 3, 15, 20)

a. **Runtime origin by construction (3).** `declIsRuntimeOrigin`
   (`lower.cla` ~5077-5100) decides origin by comparing a decl's path
   string against `normalizePath(rtDir)` (host) or the literal
   `"runtime/clarus/"` prefix (native); `normalizePath` is lexical, so
   two spellings equal only via a symlink misclassify. Replace the
   comparison with provenance recorded at read time: `drive.cla` gains
   `var drvRuntimeFiles: intmap of bool`; in `expand()` where decls
   are stamped (`setDeclFile(d, pathIdx)`, ~1015), `if drvSpliceActive
   { drvRuntimeFiles[pathIdx] = true }`. `declIsRuntimeOrigin` becomes
   `p != -1 and drvRuntimeFiles.has(p)`. The `hostPaths` branch,
   `normalizePath` call, `rtDir` consult, and both prefix compares are
   deleted. Precondition to verify in the plan: `drvSpliceActive` is
   true for every runtime read (the three set/clear pairs at ~1301/
   1366, ~1701/1739, ~2073/2076, including the `--rtbake` manifest
   path) and false for every user read including the toolbox include
   fallback. Fixture: `tests/selfhost` (or `tests/cg68k`) script
   compiling one program with `--rtdir runtime/clarus/` and with a
   symlink to it, asserting byte-identical output.
b. **`seenPaths` on success only (15).** `expand()` ~976-978 marks
   `seenPaths[path] = 0` (and `altPath`) before `feReadSource`; a
   failed read returns `true` without unmarking, so a later attempt at
   the same path dedupes against a file never loaded. Move both marks
   below the `if not ok { ... return true }` early return. The
   successful path already overwrites them with the real index at
   ~1098. Fixture: an include of a missing file followed by an include
   of the same path once present (two-step script) — or, cheaper, an
   include that fails via the toolbox fallback's first attempt and
   succeeds on the second, asserting the second is not deduped.
c. **Prelude comment consolidation (20).** Four restatements:
   `drive.cla` ~60-74 (mechanism declaration — stays), ~1506-1522 and
   ~1989-2077 (two driver-internal retellings — collapse to one, the
   other becoming a one-line pointer), `bake.cla` ~403-417 (the bake
   lane's own module-list note — stays, `bake.cla` untouched so the
   55-minute Snow `clarusc_bake` standing rule does not fire).

## 5. Wave ends and close-out

- **Bless #1** (end of wave 1): `CLARUS_CG68K_BLESS=1` + emitui
  goldens; reviewer confirms every hunk is a runtime-edit ripple
  (HLock/HUnlock pairs, the clamp, nothing else). `CLARUS_MAC_TESTS=1
  make -j1 test T=mactest/` green (native suites incl. the new
  `CasesTable` case and 36-count assertions); the opt-in cprint twin
  links.
- **Bless #2** (end of wave 2): `CLARUS_CG68K_BLESS=1`, snapshot
  regeneration, `.expect` reblesses listed in §4.2/§4.3 only; reviewer
  attributes the `.s` diff to items 4.1 a/b/d/e/g (tracked-temp
  releases, per-function frame sizes, absent `rtConnPump`, `err`
  elision) and nothing else. T1 green; `tests/selfhost/` green.
- **Close-out:** full T2 (`scripts/test-merge.sh`); final whole-branch
  review (most capable model); `docs/TODO.md`'s section emptied per §1;
  `HISTORY.md` phase entry carries the three dispositions' evidence and
  the `.s` line delta from 4.1e; `CLAUDE.md`: toolbox case count 35 →
  36 (`CasesTable`), the `tests/bake/<module>.sh` standing rule (§3.6),
  and the conversion-wording change; reference: `string(c)` (§4.2c);
  `ROADMAP.md` gets the phase paragraph in the usual shape. Merge only
  on request.

## 6. Out of scope (deliberately untouched)

- Every other `docs/TODO.md` section. In particular the "Test coverage
  gaps" entries that neighbour this work (`runner.cla`'s stale count
  comment is fixed incidentally by §3.4; the rest stay).
- A canonical-path primitive (`file.realPath` or a `FileInfo` identity
  field): §4.4a removes the need instead of adding the surface.
- A general `cg68AddRoots` `irUsesConn` gate: §4.1e's synthesized stub
  is the lever; the `nat*` loop stays as is.
- Reviving a static escape analysis (entry 5's only real successor).
  If release traffic ever measurably matters, that is a new phase with
  its own numbers.
- Proportional scrollbar remapping above the 16-bit ceiling (§3.2).
- Any `bake.cla` edit (keeps the Snow bake rule from firing).

## 7. Risks

- **HLock across TextEdit calls (§3.1, the two `te` sites).** Locking a
  TERec while TextEdit needs to grow its text handle is fine (the text
  is a separate handle), but the implementer must confirm no call in
  the locked region resizes the TERec itself. Fallback: the rect-copy
  variant, which needs no lock.
- **`drvSpliceActive` precondition (§4.4a).** If any runtime read
  happens outside the flag (e.g. the `--rtbake` manifest-collision
  path reads via `feReadSource` early in `expand()`), runtime decls
  would be misclassified as user code and lose the abort-propagation
  exemption. The task's first step is the audit; the byte-identity
  fixture is the tripwire.
- **`clar_conn_pump` stub (§4.1e) and the CLIR bake.** `runtime/clarus/
  native.cla` changes, so the baked-IR body hash changes; `--rtbake`
  byte-identity (`tests/bake/*`) and the full-corpus T2 sweep are the
  proof that the bake path follows. `bake.cla` itself is untouched.
- **Per-function small-temp pool (§4.1d)** is the largest golden churn
  in the phase and touches frame layout in every function. The
  measure/emit two-pass already exists for the big pool; the risk is a
  temp allocated on the emit pass that was not counted on the measure
  pass. The existing frame-size cap and the 30-temp fixture bound it;
  the toolbox suite's `LeakCheck`/`ClearWarm` FreeMem-flat cases are
  the hardware tripwire for a mis-sized frame.
- **Diagnostic wording changes** (§4.2c) touch one committed `.expect`;
  any downstream project pinning `cannot convert` text (68kbbs does
  not) would need updating.
