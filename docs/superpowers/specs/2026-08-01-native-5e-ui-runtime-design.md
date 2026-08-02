# Native 5e — UI runtime port design

Date: 2026-08-01. Child spec of
`2026-07-29-native-68k-toolchain-design.md` (Plan 5), refining its "5e —
Runtime migration wave 2" line into a buildable design. mem/ARC (the other
half of the parent's wave 2) already landed early as 5c′; what remains —
and what this spec covers — is the UI runtime: `runtime/mac/rt_ui.c`
(5,723 lines, ~169 distinct Toolbox routines) ported to Clarus so that UI
apps build and run on the native cg68k backend, gated on the existing 23
UI scenario goldens. Where the parent spec or the 5d spec already decided
something (whole-program codegen, trap-clause mechanism, segmentation,
fail-closed codegen arms), this spec inherits it without re-arguing.

## Goal and end gate

All 23 `testdata/ui` scenarios build via `clarusc emit68k` (no C, no
cmake, no Retro68), boot on Mini vMac, and byte-match the existing
`testdata/ui/*.trace` + `testdata/uisnaps/*.pbm` goldens — **the same
golden set the Retro68 lane is blessed against. One golden set, strict**
(ratified 2026-08-01): traces AND pixels; any native divergence is a bug
until root-caused; no per-backend goldens, no re-bless. Scripted events +
deterministic QuickDraw make this achievable; if a root-caused benign
divergence ever appears, changing this policy is an explicit Andrew
decision, not a bless.

The full gated `internal/mactest` suite (every Retro68 test AND every
native test, now including the native UI gate) must be green in one run.

## Ratified decisions (2026-08-01, with Andrew)

1. **Scope: everything rides in 5e.** The four carried 5d items land in
   this branch as stage 0 (see Staging): the discarded-call-result handle
   leak (final-review T13), whole-fixed-array assignment block-copy
   (final-review C1, currently fail-closed), `fpUiEditStmt`'s two
   cprint-only C arms, and pascal-trap byte-arg order verification.
2. **Port strategy: two-lane staged (option A).** Port family-by-family;
   the cprint → Retro68 lane redirects to the ported Clarus per stage with
   all 23 goldens held byte-identical throughout; the native gate flips at
   the end against the same goldens. Rejected: native-only port (every bug
   debugs only on the emulator under naive codegen — port bugs and codegen
   bugs indistinguishable; two UI runtimes to keep in sync until 5f) and
   big-bang single-source (months-long red gate, same confounded debugging
   until the end). The two-lane property is the whole point: any native
   divergence after a stage passes on Retro68 is codegen/trap/glue by
   construction, not port logic.
3. **Dispatch: program-emitted dispatcher externs over flat pointer-free
   descriptors.** No function-pointer type enters the language; no
   `callptr` primitive. (Details below.)
4. **Callback glue: per-backend at the seam.** cprint lane keeps small C
   `pascal` wrappers in the mac shim; cg68k emits native pascal-entry glue
   stubs. ui.cla logic stays single-source.
5. **`rt_ui.c` + `uiprobe` stay in-tree, frozen, out of the app path**,
   as the port's grep-able line-by-line oracle (and a runnable C-side
   triage harness if a divergence needs it). Deletion is 5f's
   Retro68-retirement business, not 5e's.

## Architecture

### Module split

`rt_ui.c` ports to three or four modules under `runtime/clarus/` so no
module dwarfs the existing largest .cla:

- `ui.cla` — app/event-loop core: startup, run loop, window open/close/
  front/state, menus, `every` timers, launch/opendoc AppleEvent plumbing,
  quit.
- `uiwidgets.cla` — widget creation/layout and the property get/set
  surface (button/check/label/field/textview/canvas incl. TE editing,
  scrap, scrolling, canvas drawing ops).
- `uitable.cla` — ListManager tables + popups + the LDEF stub.
- `uidialogs.cla` — alerts, about box, StandardFile open/save/
  save-changes, `rt_ui_edit` modal forms + the binding walker.

Exact boundaries may shift at porting time (the plan fixes them); the
constraint is per-module size, not this precise split. Modules are
clarusc-fed implicitly per program, gated on IR usage marks exactly like
the 5b families — a program with no UI surface includes nothing and sees
zero change, on either backend.

The port preserves rt_ui.c's explicit contracts, most notably the PORT
DISCIPLINE RULE (every entry point touching QuickDraw/Control state
self-asserts the port via GetPort/SetPort and restores the caller's port —
documented at `rt_ui.h:271`), the RTUI_TE_MAX=32000 clamp + lasterr
convention, and the double-indirection table-rows contract
(`rt_ui_table_desc.rows` re-read via `*rows` every draw).

### Toolbox layer

Toolbox routines become `external func` decls with trap clauses (the 5d
mechanism; mostly pascal-stack traps — Window/Control/Menu/TE/List/
Dialog/StandardFile/QuickDraw — plus the handful of register-based OS
traps). Toolbox structs (Rect, Point, EventRecord, the needed WindowRecord
/TERec/ListRec fields) are read/written via 5b `overlay` records and
peek/poke; Str255s via the existing external str marshalling. HLock/
HUnlock, BlockMoveData, NewPtrClear etc. join the extern surface. On the
cprint lane these lower to the mac shim as today (`rt_ext_mac.inc` grows);
on native they are direct trap words.

Estimated new trap-clause surface: ~50–80 routines. Each stage only adds
the traps its family needs, verified by that stage's goldens.

### The reverse waist: dispatch without function pointers

Today's emitted descriptors (`rt_ui_window_desc`, widget/menu/item/every/
handler tables) are C structs full of pointers — `fire` function pointers,
string pointers, nested struct pointers. They are re-specified as **flat,
pointer-free int tables** (the 5b `clar_serdesc_` precedent): fixed-width
int fields, strings as offsets into a per-program string blob, sub-tables
by index. Both backends emit byte-equivalent table content; ui.cla walks
them with `peekw`/`peekl` (native) / the same accessors over emitted
arrays (cprint) through one shared accessor layer in ui.cla itself.

All handler/`fire` function pointers disappear, replaced by
**program-emitted dispatcher externs**. ui.cla declares, as
`external func`:

- `UiFireWinEvent(winIdx int, inst ptr, ev int, a int, b int)`
- `UiFireWidget(winIdx int, inst ptr, widgetIdx int, ev int, a int, b int)`
- `UiFireMenu(handlerIdx int, frontInstOrNil ptr)`
- `UiFireEvery(idx int)`
- `UiReleaseVars(winIdx int, inst ptr)`
- `UiFireLaunch(openDocOrEmpty int, path ptr)`

clarusc emits their bodies per program: a switch over the index calling
the program's real handler functions (which keep their current
signatures). cprint: ordinary C functions (replacing today's
pointer-table indirection). cg68k: ordinary emitted functions reached by
direct JSR. A program that declares no handler of a given class gets an
empty body. No new language surface; the "extern whose body clarusc
emits per program" is the only new mechanism, and it is per-backend
codegen work, not language work.

### Toolbox→Clarus callback glue

Three places the Toolbox calls into our code, all `pascal` convention:
AppleEvent handlers (4), the ListManager LDEF, and control action procs
(scrollbar/TrackControl). Design:

- ui.cla builds the LDEF's 3-word JMP-stub handle itself via pokes
  (portable — same bytes both lanes); the JMP **target** comes from a
  per-backend extern (`UiLdefEntry() ptr`, `UiAeEntry(which int) ptr`,
  `UiActionEntry(which int) ptr`).
- cprint lane: targets are small C `pascal` wrapper functions kept in the
  mac shim (gcc implements the convention), each wrapper calling the
  ported ui.cla function (an ordinary C function in emitted C).
- cg68k: codegen emits fixed pascal-entry glue stubs — unwind the pascal
  argument frame into C-convention arguments, JSR the ui.cla function,
  store the pascal result slot, RTD-equivalent return (RTS + caller-frame
  cleanup per pascal callee-pops rules on 68000).

**This is where the pascal byte-arg question is settled** (5d Task 9's
recorded doubt: LOW-byte placement for bool/char stack args rests on
secondary sources, unexercised by any 5d trap). The first byte-arg pascal
trap and the LDEF glue verify it empirically against goldens, plus an
`internal/asm68k`-level listing check, and the result is recorded in the
language reference's trap-clause chapter.

### Resource parity

The Retro68 path gets alerts/about (`alert.r`) and app icon/BNDL
resources via Rez. `app68k.cla` must emit the equivalent ALRT/DITL (and
icon-family/BNDL/FREF + signature when the program declares an `app`
icon/id) resources directly — small, data-only, golden-checked by
byte-comparing against what Rez produces today for the same inputs.

## Stage 0: carried 5d items (land first)

1. **T13 discarded-call-result leak:** a bare `makeStr();`-shaped
   `ECallFn` statement's handle result is never released natively. Fix:
   route through the same `cgNewTrackedTmp` path the `lst.pop();` discard
   shape already uses. Leak-not-corruption in run-once apps; a real heap
   killer in 5e's event loops against a 384KB heap, so it lands before
   any UI stage.
2. **C1 whole-fixed-array assignment:** currently fail-closed (named
   log+quit). Fix for real: a `cgExprAddr` + block-copy codegen arm
   honoring Ch3 copy-by-value semantics, plus a corpus fixture (none
   exercises the shape today — the fixture is part of the fix).
3. **`fpUiEditStmt` kind==2/3 arms:** the last cprint-only C in that path
   (`rt_list_at`, `rt_map_get_dv`) redirects to the already-ported
   Clarus list/map accessors — carried unresolved from 5c′ because the
   binding-walker exclusion predated the wave; it must not survive into
   a ported uidialogs.cla.
4. **Pascal byte-arg verification** happens inside the first stage that
   ships a byte-arg pascal trap (see glue section) — stage 0 only adds
   the asm68k listing-level encodings needed to write it.

## Plan-time adjudications (2026-08-01, recorded during plan authoring)

Four refinements found necessary once the code was inventoried in depth
(`docs/superpowers/plans/2026-08-01-native-5e-ui-runtime.md` is the
consumer; the ratified decisions above are unchanged in intent):

1. **The cprint redirect flips per-scenario, not per-family.** Unlike
   str/text/list/map, the UI runtime is one interconnected event loop —
   half-ported/half-C cannot share `winst`/`gModal` state across a C/Clarus
   boundary. A temporary `clarusc emit --uiport` flag selects the ported
   runtime per build; scenarios move to the ported Retro68 lane as their
   widget surface lands (goldens strict throughout), and the flag flips to
   the only path — legacy emission deleted — once all 23 are green ported.
   The two-lane property (Retro68-proven before native) is preserved
   exactly.
2. **A `word` extern type is required.** 5d's pascal marshaling pushes
   `int` as `.L` and has no 16-bit form; the Toolbox UI surface is
   INTEGER-heavy. `word` (contextual, extern decls only, int-compatible,
   `.W` at the trap boundary, results sign-extended) is stage-0 apparatus.
3. **Glue entry addresses are jump-table entry addresses** (`LEA
   32+8*slot+2(A5)` — segment-safe, valid from any segment, the classic
   Mac idiom), not raw code labels; cg68k has no data-relocation
   mechanism and needs none for this.
4. **Native event-script injection is `emit68k --events FILE`** embedding
   the script bytes in the constant pool behind a `UiTestScript()` extern —
   the Retro68 lane's weak-symbol `events.c` override has no native
   analogue.

## Staging and verification

Per-stage discipline (every stage, no exceptions):

1. Port the family to `ui*.cla`; move the family's scenarios to the
   ported Retro68 lane under `--uiport` (adjudication 1 above).
2. `go test ./... -timeout 30m` green (differential + snapshot + selfhost).
3. Full Retro68 UI gate: **all 23 scenario goldens byte-identical** —
   trace and PBM, zero re-bless, zero churn tolerated.
4. Only then does the next stage start. Snapshot re-bless per stage as
   emitted C churns (mechanical, like 5b/5c′).

Stage order (approximate; the plan fixes task boundaries):

- **Stage 1 — app core + event loop + windows + menus** (startup, run,
  open/close/front/state/title, menu build + enable + dispatch, `every`
  timers, quit). Covers scenarios like `menus`, `winvar`, `zoomwin`.
- **Stage 2 — buttons/checks/labels/canvas** (controls, layout engine,
  canvas ops incl. patterns/text). Covers `buttons`, `canvas`, `pattern`,
  `smoke_bounce`, `smoke_mandel`, `hdim`.
- **Stage 3 — TE widgets** (field/textview, scrolling, scrap/edit menu,
  TE clamp). Covers `textwidgets`, `editmenu`, `hscroll`, `texteditor*`.
- **Stage 4 — tables + popups + LDEF** (`popuptable`, `bookmarks` table
  half).
- **Stage 5 — dialogs + StandardFile + AE launch/opendoc + forms**
  (`dialogs`, `formedit`, `opendoc*`, `about`, `appres`, full
  `bookmarks`).
- **Stage 6 — native bring-up**, scenario-graded as trap coverage lands:
  cg68k UI emission (descriptor tables, dispatcher externs, glue stubs,
  new traps), `app68k` resource parity, then scenarios turned on roughly
  smallest-surface-first (`smoke_bounce` → … → `bookmarks`), each
  byte-matched against the same goldens. New gate tests in
  `internal/mactest/native_test.go` mirror the Retro68 UI gate's
  structure (`TestUiScenariosOn68k` or per-scenario functions, same
  events/trace/snap plumbing — reuse the existing harness, which is
  backend-agnostic once handed a `.bin`).

Native bring-up is a single stage late, not interleaved, because the
native lane cannot run a partial UI runtime (it links only Clarus code —
there is no C to fall back to natively), and because by then the ported
logic is Retro68-proven, so stage-6 debugging is confined to codegen,
traps, glue, and resources.

cg68k codegen arms added in stage 6 follow 5d's fail-closed rule: any
unhandled shape is a named log+quit, never a silent zero/no-op.

## What stays C / behind the waist (recorded honestly)

- The cprint-lane pascal wrappers + a shrunken `rt_ext_mac.inc` (the
  extern seam is the waist; it grows entries, all thin).
- `rt_ui.c` + `uiprobe` in-tree frozen (decision 5) — out of the build
  path for Clarus apps, kept as oracle until 5f.
- The host `rt_ext_host.inc` gains matching no-op/host bodies only where
  a UI extern must exist for host compiles to link (host never runs UI).
- Everything already permanently C per earlier waves (frozen Go compiler
  backend, host leak ledger, `rt_register_cleanup`).

## Risks

- **Golden brittleness:** strict pixel identity across a 5.7k-line port —
  any ordering change in draw calls diverges a PBM. Mitigation: two-lane
  staging localizes every divergence to one family-sized diff; the trace
  usually names the divergence before the pixels do.
- **Pascal glue on 68000** (no RTD): callee-pops glue must be hand-tight;
  an error corrupts the stack asynchronously (Toolbox calls us). Mitigated
  by the forced-early byte-arg verification and asm68k listing oracle.
- **Naive-codegen UI latency:** the event loop, TE typing, and canvas
  redraw run unoptimized natively for the first time. The gate is
  correctness (goldens), not timing; boot-to-exit numbers get recorded
  per scenario as the peephole/regalloc phase's buy-back baseline, same
  framing as 5d's.
- **Code size:** ui*.cla adds emitted code to every native UI app;
  multi-segment CODE + jump table (5d) absorbs it. Watch: the 32,760-byte
  per-segment budget with per-module segment assignment, already proven
  by `TestNativeSmokeForcedMultiSegment`.
- **Re-porting hardened code** (parent-spec risk restated): rt_ui.c
  carries years of fix-comments (port-discipline, TE clamp, popup
  private-data, JT quirks). The port copies contracts deliberately —
  each rt_ui.c fix-comment must land as a comment or check in the ported
  code, and the plan's per-stage review checks for dropped contracts.

## Explicit non-goals

- No new UI features, widgets, or language surface — a pure port; the 23
  goldens define done.
- No peephole/regalloc work (later phase; this spec only records its
  baseline numbers).
- No compilation cache (still parked post-5d).
- No Retro68 retirement, no Mac-resident clarusc (5f).
- No host-side UI runtime.

## Outcomes (2026-08-03, Tasks 1-15 landed)

The design landed close to as-written — module split, dispatch mechanism,
callback glue split, and resource parity all shipped the shape this spec
describes. The real deviations are the four already recorded as
plan-time adjudications above (all confirmed as-executed, not revised
further) plus one big lesson the exploration surfaced that the spec did
not anticipate: the descriptor blob's record layout is lane-specific, not
lane-agnostic. Full task-by-task numbers are in
`.superpowers/sdd/2026-08-01-native-5e-ui-runtime/task-{1..15}-report.md`
and `progress.md`; this section is the as-built architecture record.

- **`--uiport` per-scenario staging: as adjudicated, executed exactly.**
  `clarusc emit --uiport` selected the ported Clarus UI runtime instead of
  legacy `rt_ui_*_desc` C emission; scenarios moved onto the ported lane in
  slices as each family's widget surface landed (Tasks 7-10: 8, then 9,
  then a run to 21/23, then the last 2 once a real hang was root-caused),
  never per-family the way 5b/5c′'s redirect flags worked, because the
  event loop shares mutable state (`winst[]`, `gModal`) across every
  family at once — a program cannot run half the loop in C and half in
  Clarus. Deleted outright in Task 11 ("the flip"): every legacy emission
  arm (`cpEmitWidgetDescArray`, `cpEmitOneFormDesc`, `cpEmitUiDispatchers`,
  `cpEmitUiWiring`, and their helpers), the flag itself, and both build
  script's `CLARUS_UIPORT` branches — the ported runtime is now the only
  cprint path for a UI program, unconditionally.
- **Descriptor blob format v1: as designed, plus the lane-specific Layout
  correction (the big lesson).** The flat, pointer-free int-table shape
  (fixed-width fields, strings as blob-string-pool offsets, sub-tables by
  index) shipped exactly as designed — `uiblob.cla`'s `uibBuild()` emits
  one shared byte layout, walked by `peekw`/`peekl` natively and the
  matching array-accessor layer on cprint. What the spec did NOT
  anticipate: the blob's `Layout` section (record size + per-field byte
  offsets, used by the form-accept and table-draw paths to read/write a
  record through raw offsets) encodes a *record ABI*, and cprint and cg68k
  do not agree on one — cprint's real record shape is the emitted C
  struct (`bool`/`char` = a full 4-byte-aligned slot, matching m68k GCC's
  own `BIGGEST_ALIGNMENT`), cg68k's own naive layout gives `bool`/`char` a
  bare 2-byte slot everywhere. Task 10 found this on the ported/cprint
  lane first (a hang from a 2-byte scratch-buffer overrun corrupting the
  Memory Manager free list, `formedit`/`bookmarks`'s modal accept path);
  Task 14 found the SAME class again natively (`popuptable`'s `bool`
  column always reading CHECKED, a 4-byte overread of a 2-byte-sliced
  field). The durable fix on both lanes: give EACH lane its own explicit
  record-field layout authority (cprint: `cpCRecordSize`/`cpCFieldOffset`;
  cg68k: `cgRecFieldSizeOf`/`cgRecFieldAlignOf`, scoped to
  `cgFieldOffset`/`cgRecordSize`/`cgRecordCtorAt`/`cgEmitOneRcWalk`
  only — a bare local/param/array element's own 2-byte `bool`/`char`
  sizing is untouched), plus a compile-time `clar_ui_layoutassert_<R>`
  guard on the cprint lane so a future divergence between the hand-derived
  rule and what the C compiler actually does is a build error, not a
  silent corruption. `uibEmitLayout` selects the authority off a
  `uibNativeLane: bool` switch. The ruling this settled, carried loudly
  between tasks in the ledger: record-field ABI is a per-lane decision,
  made deliberately, never inherited by copying the other lane's own
  rule.
- **Dispatcher externs as synthesized IRFuncs: as designed, on both
  lanes.** `UiFireWinEvent`/`UiFireWidget`/`UiFireMenu`/`UiFireEvery`/
  `UiReleaseVars`/`UiFireLaunch` are `external func` declarations whose
  BODY clarusc synthesizes per program (a switch over an index, calling
  the program's own real handler functions) — cprint emits them as
  ordinary C functions (replacing the old function-pointer-table
  indirection exactly as planned); cg68k emits them as ordinary compiled
  functions reached by direct `JSR`, via `cgCallExtUiSynth`'s pre-dispatch
  arm in `cgCallExt` (a name-based lookup ahead of the trap-clause switch,
  since a synthesized dispatcher extern carries no trap clause at all).
  No new language surface beyond what the spec named.
- **Toolbox→Clarus callback glue: as designed, via JT entry addresses
  specifically (plan-time adjudication 3, confirmed as the only workable
  choice).** cprint kept small C `pascal` wrapper functions in the mac
  shim exactly as designed. cg68k synthesizes two empty-bodied IRFuncs
  (`clar_ui_glue_ldef`/`clar_ui_glue_action`, `cg68SynthUiGlue`, called
  right after `lowerProgram`/`cg68AddRoots` so `cgAssignFinalJtSlots`
  gives them a real JT slot for free) and hand-emits their bodies
  (`cgEmitLdefGlue`/`cgEmitActionGlue` in `cgEmitFunc`, matched by name):
  unwind the pascal argument frame at fixed positive-A6 offsets, re-push
  in Clarus's own convention, `JSR` the real ported function, pop the
  return address, `ADDA` the caller's own pushed arg bytes (68000
  callee-pops, no RTD), `JMP` back. `UiLdefEntry()`/`UiActionEntry()`
  return the glue's JT ENTRY address (`LEA 32+8*slot+2(A5),A0` — segment-
  safe from any segment), not a raw code label, exactly the adjudication's
  own reasoning: cg68k has no data-relocation mechanism and needed none
  once entry addresses, not code labels, were the contract. AppleEvent
  handler glue (×4) was never built on EITHER lane — no `external func
  UiAeEntry` exists anywhere in the ported source, so there was nothing
  for cg68k to wire either; native AE dispatch is untested (see the
  ROADMAP entry's honest limits).
- **`--events` pool blob: as adjudicated (item 4), executed exactly.**
  `emit68k --events FILE` reads the scripted-event file and
  `cgEmitUiEventsPool` pours its bytes into the constant pool behind a
  `UiTestScript()` extern (`cgCallExtUiBlobAddr`, `LEA lbl(PC),A0` then
  `MOVE.L A0,D0` — an early bug left the `MOVE.L` off, so the computed
  address was silently discarded and `rtUiRun`'s script-vs-real gate
  always fell through to the real event loop; fixed in the same task that
  found it). `scripts/build-68k.sh` gained a matching `--events FILE`
  pass-through flag, mirroring `build-mac.sh`'s pre-existing
  `CLARUS_UIPORT`-era events mechanism.
- **Record-ABI unification ruling (the controller ruling that resolved
  Task 14's own popuptable bug, recorded here for the permanent record):**
  `bool`/`char` inside a RECORD get a full slot matching the shared
  runtime's own read width — 4 bytes on cg68k (unifying with the C
  convention `rt_ui.c:1100` already assumed, since the shared `.cla`
  runtime source cannot itself be lane-conditional) — but this is scoped
  to record FIELDS only; a bare local, parameter, or array element keeps
  its pre-existing 2-byte `bool`/`char` sizing on cg68k, unaffected. Every
  reader of record layout (`cgRecordSize`/`cgFieldOffset`/
  `cgRecordCtorAt`/`cgEmitOneRcWalk`) re-derives from the same two new
  functions; `uibEmitLayout`'s native lane already sourced its Layout
  section from `cgRecordSize`/`cgFieldOffset` (Task 12), so it inherited
  the fix for free once cg68k's own authority changed underneath it.
- **Pascal byte-arg placement: settled empirically, and the pre-existing
  5d-era guess it settles was WRONG.** Neither this spec's own
  "byte-arg question... rests on secondary sources" framing nor 5d's own
  low-byte guess had a real trap to test against before this branch. The
  first one this branch exercised (`NewWindow`'s `goAwayFlag`,
  `smoke_bounce`'s native boot) proved the value lives in the padded
  word's HIGH-order byte (the word's own, lowest, address) — found via A/B
  `log()` instrumentation on `WindowRecord.goAwayFlag`, comparing the
  native lane against the ported/gcc lane over the identical shared
  `ui.cla` source. Fixed in `cgCallExtPascal`: an argument shifts up 8
  bits (`LSL.W #8`) before the word push; a result shifts down 8 bits
  (`LSR.L #8`, replacing an `AND.L #255` that kept the wrong half) after
  the word pop. `word`-typed (genuine 16-bit Toolbox `INTEGER`) params and
  results are unaffected — they occupy the word's full span, nothing
  padded, nothing to shift. **Correction to the 5d-era claim:** any prior
  documentation or code comment asserting a pascal bool/char value lands
  in the padded word's LOW byte was wrong; the language reference's Trap
  and Inline Clauses section (Task 15) now states the HIGH-byte rule as
  normative, and `cgCallExtPascal`'s own header comment in `cg68k.cla`
  carries the same correction with the empirical trail.
- **Deviations from the spec as written, each with why:**
  - The per-scenario (not per-family) `--uiport` flip (plan-time
    adjudication 1) — the event loop's shared mutable state made a
    per-family split unworkable; see above.
  - The lane-specific blob `Layout` section (not anticipated at all,
    found mid-flight) — see the record-ABI lesson above; the spec's own
    "byte-equivalent table content" framing assumed one shared record
    shape existed to be byte-equivalent about, which turned out false.
  - `word` as a stage-0 addition (plan-time adjudication 2) — the
    Toolbox's INTEGER-heavy surface had no 16-bit marshaling shape in 5d's
    pascal convention at all; landed exactly as adjudicated, no further
    change.
  - Glue via JT entry addresses, not code labels (plan-time adjudication
    3) — cg68k's total absence of a data-relocation mechanism made this
    the only workable choice, not a preference between two working ones.
  - `reg memerr` and `trap ... sel SELECTOR` (Task 14 additions, not in
    the spec's original trap-clause inventory at all): found empirically
    bringing up native scenarios past `smoke_bounce` — `SetHandleSize`'s
    real Pascal signature is `void` (Memory Manager routines are
    PROCEDUREs, not FUNCTIONs; the real error lives in the low-memory
    global `MemErr`), and the entire List Manager family shares one trap
    word distinguished by a selector the 5d-era trap grammar had no way to
    express. Both are additive grammar clauses on the existing `external
    func` trap-clause mechanism, not a new mechanism.
  - `= inline a5` (Task 12 addition, also not in the spec's original
    inventory): `UiCurrentA5` needed the 68k A5 register (the classic
    Mac application-globals base) with no trap to read it through — a
    third `inline` variant alongside the existing `deref`/`nop`, same
    zero-marshaling-needed shape.

Nothing in the architecture was reverted. Every deviation above is either
a plan-time adjudication already recorded and executed as planned, a small
additive grammar clause the exploration found necessary (word, reg memerr,
trap sel, inline a5), or the one real design gap (lane-specific record
ABI) that the spec's "byte-equivalent blob" framing did not anticipate and
that both porting tasks (10 and 14) had to close independently, in the
same way, for the same underlying reason.
