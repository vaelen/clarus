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

## Staging and verification

Per-stage discipline (every stage, no exceptions):

1. Port the family to `ui*.cla`; redirect cprint's emission arms for that
   family (the `cp*Ported` pattern).
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
