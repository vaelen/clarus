# clarusc UI Gaps: Widget-Set Coercion + Window-Var Construction — Design

Date: 2026-07-26
Status: approved (root causes investigated, design confirmed with Andrew)

## Goal

Fix the two clarusc gaps discovered during window-zoom-hscroll (recorded in
ROADMAP "Small open items"):

1. `Body.text = "literal"` (any `string`-kinded RHS into a textview's
   `text` property) emits C that passes a `clar_str_N` struct where
   `rt_text *` is expected — build failure.
2. A window-scope handle-backed `var` (`text`, `list of T`, `map`, records
   or arrays containing them) is never constructed — the per-instance state
   block is only `NewHandleClear`-zeroed, so first in-place use dereferences
   a NULL handle (on a 68000: silent low-memory corruption). Even a
   declared default (`var t: text = "hi"`) crashes, because the 4b defaults
   machinery stores INTO the handle it never creates.

The Go compiler stays frozen (it does not lower UI at all — no
differential exposure). Both checkers already accept both shapes per the
reference; no checker or reference changes are needed.

## Root causes (investigated 2026-07-26)

- Gap 1: `lowWidgetSetAssign` (clarusc/lower.cla:1571) calls
  `lowExpr(rhsAst)` raw — the ONLY RHS-consuming lowering site that skips
  `lowCoerceStr`, so the documented Str→Text widening (`ITextOfStr` →
  `rt_text_new()` + `rt_text_store()`) is never inserted. The comment at
  cprint.cla:959-964 ("a2 is already an rt_text*: the checker requires a
  Text-typed rhs") asserts an invariant the checker never enforced —
  assignability includes every `string`.
- Gap 2: `cpEmitUiStateStruct` (cprint.cla:1707-1723) deliberately emits
  field declarations only, on the premise that zeroing suffices; true for
  inline types (`string(N)`, scalars, window refs, `Err`), false for
  handle-backed ones. `cpDefaultInit` — the constructor emitter — has
  exactly three call sites (locals, record ctors, globals); window state is
  not one of them. The `WinVarDefault` glue (lower.cla:107-153, applied via
  `lowPrependWinVarDefaults` and `lowSynthesizeMissingOpenedHandlers`) only
  covers vars with an explicit initializer, and routes through
  `lowStoreStmt` (store-in-place), not construction.

## Part 1 — Widget-set coercion (clarusc/lower.cla, cprint.cla)

- At the single widget-set funnel (lower.cla:1571), coerce the RHS against
  the property's IR type: `lowCoerceStr(<prop IR type>, lowExpr(rhsAst))`.
  This fixes textview `text` (Str→Text widening) and makes the Str-capacity
  clamp on caption/label/field/title sets correct-by-construction (today
  benign only because `fpStrAddr` passes a raw Pascal-string address).
- Rewrite the stale cprint.cla:959-964 comment: a2 is an rt_text* because
  lowering coerces Str RHS via ITextOfStr, not because the checker forbids
  Str.
- No checker changes (both compilers accept the shape; reference Ch3
  documents string→text assignability).

## Part 2 — Window-var construction (clarusc/lower.cla, cprint.cla)

- New intrinsic (suggested name `IUiStateDefaults`), taking the window
  instance expression; lowering inserts it as the FIRST statement of the
  window's `opened` glue — both paths: prepended before user statements
  (and before `WinVarDefault` assignments) in an explicit `on opened`, and
  in the synthesized handler when none exists. The synthesis condition
  widens: a window now needs `opened` glue if it has declared defaults OR
  any handle-backed var.
- The C printer walks that window's state fields and emits
  `cpDefaultInit`-style construction for each field whose type needs it
  (exactly the types for which `cpDefaultInit` emits a constructor:
  text/list/map/records; inline types emit nothing — the zeroed block is
  already their default). Reuse `cpDefaultInit` itself against
  `state->cv_<name>` destinations rather than duplicating its type switch.
- Ordering guarantee: construction first, then declared-default
  assignments (`WinVarDefault`), then user `opened` statements.
- Zero runtime (rt_ui.{h,c}) changes — the OPENED dispatch and synthesized
  handler hooks already exist.

## Part 3 — Tests

- `testdata/emitui/` (the clarusc-only golden gate whose m68k compile-check
  against rt_ui.h would have caught gap 1): extend
  `testdata/emitui/textwidgets.cla` with (a) a string-literal assignment to
  the textview's `text`, (b) a bare handle-backed window var (`var log:
  text`, no initializer) mutated in-place in a handler
  (`log.append(...)`) — then regenerate `textwidgets.c.golden`. The golden
  locks both the ITextOfStr coercion and the state-construction emission.
- Unwind the two shipped workarounds so the gated scenarios exercise the
  real shapes end to end:
  - `testdata/ui/hscroll.cla`: window-scope `var body: text` was moved into
    the handler and the literal routed through it — restore the direct
    forms (window var + `Body.text = "<literal>"`), update its header
    comment (which currently documents the workaround).
  - `testdata/ui/dialogs.cla:110-112`: `var e: text` / `Body.text = e`
    becomes the intended `Body.text = ""` (header comment at :37 says so),
    update comments.
  - Expected outcome: traces and PBM snaps BYTE-IDENTICAL (same visible
    behavior, different code shape) — no rebless. Any golden churn is a
    regression to investigate.
- Bootstrap: regenerate `clarusc/clarusc.c` (TestSnapshotCurrent prints the
  procedure) and verify the three-stage fixed point; full host suite
  (`go test ./...`) and full gated Mac suite green.

## Out of scope

- Freeing handle-backed window vars on close: the runtime never frees
  text/list/map anywhere (leak-by-design, rt_mac.c:479-484); adding
  disposal is new memory machinery. Recorded in ROADMAP instead
  (per-instance leak on close, unbounded across open/close cycles).
- The read-side fill-in-place gap (`file.readText(p, d.Body.text)` fills a
  discarded temporary) — already tracked in ROADMAP for 4d's binding work.
- `popup.selected` / `table.selected` assignment (`lowUnsupported` today) —
  4d surface.
- Any `rt_ui.h`/`rt_ui.c` change.
