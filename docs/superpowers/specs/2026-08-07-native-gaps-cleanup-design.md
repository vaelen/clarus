# Native/runtime gaps cleanup — design

Date: 2026-08-07 (same-day follow-on to pack3-standardfile; brainstormed
with Andrew). Scope: the ROADMAP "small open items" native/runtime-gap
cluster, minus the three items deferred with their own-design notes
(menu-bar cleanup / per-window menu bars, launch-from-Clarus, rtUiSys7
System 7 exercise — all stay ROADMAP items). Six items in three parts.

## Part A — document type/creator: mandatory args + app constants

> **REVISED 2026-08-07 (Andrew, brainstorm round 2), superseding the
> original Part A below-the-line design of app-block defaults +
> optional trailing args.** Optional/variable arity was rejected to
> avoid setting a language precedent (no optional-argument machinery
> exists; three special-cased builtins would masquerade as one).
> Instead: the arguments are ALWAYS present, and the language makes
> providing them trivial.

**New signatures (exact arity — a breaking change; every in-repo call
site is updated in this phase):**

- `file.writeText(path, text, type, creator): bool`
- `file.save(path, rec, type, creator): bool`
- `askOpen(path, types): bool`

`type`/`creator`/`types` are `string`. There are NO defaults and NO
optional forms; the old 2-arg/1-arg spellings become ordinary
"wrong number of arguments" check errors.

**New `app`-section field (unchanged from the original design):**
`doctype: "XXXX"` — optional, string literal, 1..4 printable chars
(space-padded to 4), checker-validated beside `id`; default `"TEXT"`.
It exists to feed `app.doctype` — the field is the declaration, the
expression is the access.

**New compile-time app expressions:** `app.doctype` and `app.id` —
expression-position constants (section-field spellings), resolving at
COMPILE TIME to the app section's 4-char values, space-padded; in a
program with no app section (or the field absent): `app.doctype` →
`"TEXT"`, `app.id` → `"????"`. The canonical call every standard app
writes: `file.writeText(p, t, app.doctype, app.id)`.

**New predeclared constants (universe scope, like the builtins):**
`fileTypeText = "TEXT"`, `fileTypeData = "CLRD"`,
`fileTypePicture = "PICT"`, `fileTypeApplication = "APPL"`. (Andrew
asked for "an enum of common types"; a literal Clarus `enum` is
auto-numbered int-backed and cannot carry 4CC values, so this ships as
a predeclared `const … : string` family — string consts are
established language surface, reference:375. Explicit-valued enums
would be their own language feature; not this phase.)

**Reference stance (usage-neutral, per Andrew):** the reference does
NOT prescribe types per operation. Its examples use `app.doctype` +
`app.id` for both text and data saves, plus a table of common types
(the four constants above + PICT/APPL/'ttro' etc. as prose) users can
pass directly or via the constants; custom 4CCs are just strings.
`CLRD` remains documented as the serializer's conventional data type,
recommended when the program wants data files visually/behaviorally
distinct from documents — but the choice is the programmer's.

**Filter semantics (askOpen `types`):** comma-separated 4-char codes,
max 4 (SFTypeList capacity; a 5th = check error for literals,
`lastError` + cancel-return for dynamic strings); `"*"` = all files
(SFGetFile numTypes -1). The idiomatic single-type call:
`askOpen(p, app.doctype)`.

**Padding rule (unchanged):** shorter than 4 bytes → space-padded
right; longer → check error for literals, `lastError` + failed
operation for dynamic strings. The empty string is NOT special (no
sentinel — that wart died with the optional-args design); `""` pads to
four spaces, a (weird but honest) legal 4CC.

**Runtime simplification vs the superseded design:** no fallback
globals, no runtime default resolution — every call site carries
concrete values (compile-time literals when `app.*`/constants/literal
strings are used; runtime pad+validate only for genuinely dynamic
strings). `rt_app_creator`'s file-stamping role is retired (the arg
carries the creator); the plan verifies no other consumer needs it
before removing anything.

**Stamp rule (what the runtime does, both lanes):** stamp exactly what
the call provides, after padding/validation. `file.writeText` and
`file.save` are identical in stamping behavior; they differ only in
payload encoding.

**Hardware proof:** `FInfoStamp` toolbox case writes one file with
`(…, app.doctype, app.id)` and one with explicit literals
`("PICT", "RDIT")`, reads both back via `PBGetFInfoSync`, asserts
exact fdType/fdCreator. askOpen filter behavior remains
non-auto-drivable (modal); its plumbing is pinned by emission goldens
+ the frozen scenarios staying green with explicit `app.doctype`
filters.

**Call-site migration (in-repo, this phase):** examples/
(texteditor, bookmarks), testsuite/ cases using file.save/load or
askOpen answers, testdata/ fixtures (emitui, behavior corpus,
lowlevel), and every reference fence. Frozen scenario goldens
(trace/PBM) must stay byte-identical — the migrated calls are
behavior-equivalent (`askOpen(p, app.doctype)` ≡ old `askOpen(p)` with
no app section → TEXT filter). Listing/emitui goldens re-bless as
usual.

<details>
<summary>Superseded original Part A (optional trailing args + app-block defaults) — kept for the record</summary>

## (superseded) Part A — document type/creator: app-block defaults + per-call overrides

**The rule (ONE rule, both lanes, replacing today's accidents):**

| Operation | fdType | fdCreator |
|---|---|---|
| `file.writeText(path, text)` | app `doctype` (default `"TEXT"`) | app `id`, else `'????'` |
| `file.writeText(path, text, type[, creator])` | per-call `type` | per-call `creator`, else the id rule |
| `file.save(path, rec)` | `"CLRD"` | app `id`, else `'????'` |
| `file.save(path, rec, type[, creator])` | per-call | per-call, else the id rule |

Today's stamps — `'TEXT'/'MPS '` on writeText (both lanes since 6a; MPS
= MPW Shell, a C-lane oddity) and `'CLRD'/rt_app_creator` on the C
lane's file.save — are replaced by the table. Net user-visible win:
double-clicking a saved document in Finder launches the app that wrote
it (the app-section phase's FREF/BNDL machinery already handles the
Finder side; the missing half was the document's creator byte).

**New `app`-section field:** `doctype: "XXXX"` — optional, exactly 4
MacRoman bytes after padding (see padding rule below), default
`"TEXT"`. Joins name/version/author/about/icon/id in the app-section
grammar; checker-validated like `id`.

**Open-side filter:** `askOpen(path)` gains an optional second arg:
`askOpen(path, types)` where `types` is a string of comma-separated
4-char codes (`"TEXT,PICT"`), max 4 (SFTypeList's capacity — a 5th is
a check error for literals, `lastError` + cancel-return for dynamic
strings), and `"*"` means show all files (SFGetFile numTypes = -1).
Default filter = the app's `doctype` — behavior-identical to today
(`'TEXT'`) until a program sets `doctype` or passes the arg.

**Padding rule (types AND creators, everywhere):** shorter than 4
bytes → space-padded right (`"TX"` → `'TX  '`); longer → check error
for literals, `lastError` (write fails, `false`/no-op per the calling
builtin's existing error surface) for dynamic strings. Empty string in
a per-call slot = "use the default" (lets a caller override creator
while keeping the default type: `file.writeText(p, t, "", "RDIT")`).

**Plumbing contract (implementation shape is plan-level):** the
app-derived defaults travel to the FILE layer, not just the UI layer —
non-UI programs with app sections (`app_nonui` emitui fixture is the
precedent) stamp the same way on both lanes. The waist externs
(`UiSFGetFile`) grow filter parameters; the cprint lane's C wrappers
(`rt_ext_mac.inc`, `rt_ui.c` frozen copy untouched) update to match —
death-row code, but still compile-gated by emitui's m68k-gcc check.
The native lane routes through the toolbox catalog declarations
(standardfile.cla/files.cla) exactly as pack3 left it.

**Hardware proof (new toolbox-suite case, `FInfoStamp`):** write a file
via `file.writeText` (default stamp) and another with per-call
overrides, `PBGetFInfoSync` both back, assert fdType/fdCreator match
the table; askOpen filter behavior is NOT auto-drivable (modal — the
pack3 finding stands) and rides the existing scripted lane + the
checker/emission tests.

</details>

## Part B — stack reserve: app field + codegen heuristic

**New `app`-section field:** `stack: N` — optional int literal, bytes;
checker range `4096..1048576`. Native (cg68k) lane only in effect;
checks clean everywhere (cprint host/Mac lanes ignore it, documented).

**Heuristic (no field present):** cg68k computes, over the
post-tree-shake static call graph, the deepest acyclic chain's summed
fixed frame sizes (LINK sizes are known per function at emit time),
plus a fixed Toolbox/trap headroom constant (the plan pins the number
with its derivation — traps and the UI runtime's own dispatch depth
must fit). Reserve = `max(32768, heuristic)`, even-rounded. A call
cycle (recursion) makes the chain unbounded: cycle participants
contribute one frame each and the result is clamped to
`max(32768, acyclic-portion)` — i.e. recursion falls back toward the
floor rather than inventing a bound. An explicit `stack:` field wins
outright, no max().

`cgStartupStackReserve`'s one-size 131072 constant is retired; the
32768 floor returns. The toolbox suite composition — the reason for
the 128KB bump — must come out ≥ its measured need via the heuristic
(its deep chains are exactly what the heuristic measures); if the
heuristic undershoots at boot, that's a heuristic bug to fix, not a
reason to re-hardcode.

## Part C — the mechanical four

1. **`label.text` read** — close the `lowWidgetPropGet` gap (checker
   accepts the read today? verify; the gap is in lowering). Both
   lanes. Un-workaround the two ui-scenario-retirement toolbox cases
   that dodged the read path, so the suite exercises it for real.
2. **`rtUiBuildEvery` virtual-tick seeding** — scripted builds seed
   every-block due times from virtual tick 0 (`gVirtualTicks`), not
   real `UiTickCount()`; the real (non-scripted) path is unchanged.
   Delete `cases_canvas.cla`'s warm-up-tick workaround. Rider from the
   same ROADMAP entry: investigate the suspected stale per-segment
   constant-pool duplicates (`clarusc/cg68k.cla:395-403` area); fix if
   real, record findings either way.
3. **PostEvent clobber-list verification** — decode-don't-trust (the
   Gestalt lesson): verify `rt_ext_mac.inc`'s PostEvent glue d1/a1
   clobber list against Apple's interfaces (pragma + any glue words +
   AIncludes) and IM II's register documentation; correct or confirm,
   with the evidence cited in the glue's comment.
4. **Checker panic → diagnostic** — an unresolved type name (the
   composition-ordering failure mode: `extern record` referenced
   before/without declaration) produces a real `path:line:col`
   diagnostic instead of `runtime error: list index out of range`.
   Pinned by a `testdata/errors/*.cla` + `.expect` fixture. Scope is
   the unknown-TYPE path specifically — a general
   panic-elimination sweep of the checker is NOT this item.

## Verification

1. Per-task T1; snapshot regen for every clarusc-touching task.
2. App-field emission churns emitui/appinfo/cg68k goldens — expected;
   re-bless with eyeballs on the new shapes (stamp constants, stack
   reserve value in the startup sequence, SFGetFile filter push).
3. New `FInfoStamp` toolbox case + the two un-workarounded cases green
   on both native suite gates; suite total grows accordingly.
4. Checker fixture in the errors lane (T2/selfhost) + a T1-visible
   twin if the errors lane's T2-only placement leaves the panic class
   unguarded per-task (plan decides placement, states the reasoning).
5. Behavior goldens: writeText/save stamps are invisible to byte
   goldens (FInfo isn't in any golden) — the FInfoStamp case is the
   regression guard; askOpen default-filter equivalence is pinned by
   the 4 frozen scenarios staying byte-identical (never re-blessed).
6. Full T2 at phase end. No live-drive required this phase (nothing
   needs real modal input — FInfo asserts via PB traps in-process).

## Non-goals

- Menu-bar cleanup / per-window menu bars; launch-from-Clarus; rtUiSys7
  System 7 lane (all deferred, own designs).
- `askSave` suggested-name/type coupling (askSave stamps nothing — the
  subsequent write does).
- A general checker panic-elimination sweep.
- Retro68/cprint-lane feature work beyond keeping its wrappers
  compiling (death row per 5f).

## Files touched (expected)

- `clarusc/{parse,check,lower}.cla` (app fields, optional args,
  diagnostics), `clarusc/cg68k.cla` (stack heuristic, const-pool rider),
  `clarusc/cprint.cla` (stamp/filter emission), snapshot.
- `runtime/clarus/{uidialogs,native,ser}.cla` + `runtime/mac/
  rt_ext_mac.inc`, `runtime/host` shim equivalents.
- `toolbox/` untouched (catalog already has every trap needed).
- `testsuite/toolbox/` (FInfoStamp + un-workarounded cases),
  `testdata/errors/`, `testdata/emitui|cg68k` re-bless fallout.
- `docs/clarus-language-reference.md` (app-section fields, file
  builtins' optional args, askOpen filter), `docs/ROADMAP.md`.

## Outcome (2026-08-07, 9 tasks, branch `native-gaps-cleanup`)

All six items shipped; T2 (`scripts/test-merge.sh`) green end-to-end
(239s: T1 body 15s, `internal/selfhost` 86s, gated `internal/mactest`
native lane 138s). `testsuite/toolbox` grew 24 → 25 `ToolboxTest` cases
(23 → 24 real + `SelfCheck`, the new `FInfoStamp` case).

### Part A — doctype/creator (Tasks 1-3)

Shipped exactly per the REVISED (mandatory-args) design above, no
deviation: `file.writeText(path, text, type, creator)`,
`file.save(path, rec, type, creator)`, `askOpen(path, types)`; new
`doctype: "XXXX"` app field + `app.doctype`/`app.id` compile-time
constants (`ExAppConst` AST node — named `Ex`-prefixed per the
codebase's actual `ExprKind` convention, not the brief's literal
`EAppConst`); `fileType{Text,Data,Picture,Application}` const family.
41 real call sites migrated across the repo (35 in the brief's grep
scope + 4 self-hosting sites in `clarusc/*.cla` itself, required for
the bootstrap dance to work at all + 2 in `internal/asm68k/
exercise.cla`, missed by the brief's grep scope, caught by
`TestVasmRoundTrip`). `rt_app_creator` (the old C-lane global default)
retired outright — one reader, one writer, one override site, no
other consumer anywhere in the tree.

**Two controller-authorized extras, both found mid-Task-3, both
required to reach a passing both-lane `FInfoStamp` case:**

1. A real cprint-lane codegen gap: `clarusc/cprint.cla`'s `IPokeL`
   emission arm forwarded an extern-record `ptr`-field RHS into
   `rt_pokel`'s `int32_t` parameter with no cast — harmless for every
   *prior* call site (all wrote the literal `ptr(0)`, which prints as
   bare `0`) but a real C compile error the moment a genuine non-null
   pointer expression (`UiStrAddr(...)`, `FInfoStamp`'s own
   `fp.ioNamePtr = UiStrAddr("stamp1")`) hit the same path. Fixed by
   gating a `(int32_t)(intptr_t)(...)` cast on the RHS's static type
   (`KPtr`) in `cprint.cla` only — not `lower.cla`'s shared IR, to
   avoid forcing the native (cg68k) lane through an unproven codegen
   path for a shape only the C lane needed. Zero native-lane risk
   (confirmed: unchanged `TestToolboxSuiteOn68k` result) and zero
   `.c.golden` churn beyond one new regression fixture
   (`testdata/emitui/xrec_ptr_field.cla`).
2. A missing runtime-glue gap: `PBGetFInfoSync` had never had a
   cprint-lane C wrapper (`runtime/mac/rt_ext_mac.inc`) — every prior
   caller was native-lane-only. Added
   `rt_ext_PBGetFInfoSync`, a one-line passthrough matching every
   sibling `rt_ext_*` wrapper's own shape. (`PBSetFInfoSync`'s own
   cprint wrapper is still missing — nothing calls it yet; ponytail:
   add it the same way the moment a case does.)

**Both-lane hardware proof:** the `FInfoStamp` toolbox case writes one
file via `(app.doctype, app.id)` and one via explicit literals
(`"PICT"`, `"RDIT"`), reads both back via `PBGetFInfoSync`, and asserts
the exact packed big-endian 4CC longs (`0x54455854`/`0x3F3F3F3F` and
`0x50494354`/`0x52444954`). Green on both `TestToolboxSuiteOn68k`
(native) and `TestToolboxSuiteOnMac` (cprint/Retro68, `CLARUS_CPRINT_
MAC_TESTS=1`), 25/25 both times.

### Part B — stack reserve (Task 4)

Shipped per design: `stack: N` app field (checker range
4096..1048576) wins outright; otherwise a codegen heuristic —
deepest reachable acyclic chain (`frameSize+8` per node, `cgHeur
Longest`) + `cycleExtra` (one frame each for every on-cycle node
reachable from the deepest chain) + a fixed 8192-byte Toolbox
headroom, floored at 32768, even-rounded.

**Delta beyond the planned formula:** a `cbExtra` term was added after
the heuristic *undershot* on its first real gate run (the toolbox-suite
composition hung the emulator — `LaunchAPPL` timeout — at the
un-augmented heuristic's computed ADDA of -61738; bisected true
threshold `(61738, 65000]`). Root cause: a Toolbox-invoked callback
body (`cg68SynthCbGlue`'s target, e.g. `rtUiLdefDraw`) is reachable via
`shakeAddRoot`, not a traced call edge — its own frames stack on top of
whatever chain was already live when the ROM fired the trap, but the
`best = max(...)` formula only ever compared chains against each
other, never summed a live callback onto the chain beneath it.
`cbExtra` = the deepest reachable callback body's own `cgHeurLongest`,
added on top of `best` (not maxed). Documented known limitation: models
at most one live Toolbox callback at a time; a callback whose own body
triggers a second, distinct nested callback would still be
undercounted (no such nesting exists in the current runtime/test
corpus).

**Measured values:**
- Hand-computed fixture (`testdata/cg68k/arith.cla`): longest chain
  `handler_App_launch → label → rtStrStore` = 6940; + 0 cycleExtra + 0
  cbExtra + 8192 headroom = 15132, floored to 32768 (golden `arith.s`
  line 26: `ADDA.L #-32768,A0`).
- Mutual-recursion fixture (`testdata/cg68k/mutrec.cla`, added in the
  review fix round to prove multi-node-cycle handling): `best` = 8560
  (memoized, happens to equal the true longest simple path for this
  2-node cycle), `cycleExtra` = 4280 (`mutA`+`mutB`, `frame+8` each);
  `best + cycleExtra` (12840) structurally dominates the true longest
  simple path (8560) regardless of memo order — floored to 32768
  either way.
- **Toolbox-suite composition (the real deployment case, the original
  reason for the old flat 131072):** computed ADDA **-72544**
  (`best`=53546 via `clar_ui_fire_widget`, `cycleExtra`=0, `cbExtra`
  =10806 via `rtUiLdefDraw`, +8192 headroom) — **about 45% less
  reserved stack than the old flat 131072**, empirically proven
  sufficient (`TestToolboxSuiteOn68k`, 25/25 PASS, ~48s boot).

### Part C — the mechanical four (Tasks 5-8)

1. **`label.text` read (Task 5):** the SET path's storage
   (`rtUiLabelAt`'s per-window-instance `labels[]` Pascal-string slot)
   turned out to already be the natural GET source — no shadow store,
   no BLOCKED condition. `IUiGetLabelText` added as a structural copy
   of `IUiGetFieldText`'s emission shape on both lanes; `cases_buttons.
   cla`'s checksum-inequality workaround and `cases_popuptable.cla`'s
   label-as-field workaround both un-workarounded.
2. **Every-seeding (Task 6) — the plan's `rtUiBuildEvery` hypothesis
   was DISPROVEN.** Hardware debug probes (`bb=99 bn=0 sb=99 d0=50`)
   showed `rtUiBuildEvery`'s own virtual-tick-0 seed was correct all
   along; the real bug was `rtUiEveryPump` (the ONE every-array pump
   that didn't gate on `rtUiScripted`), unconditionally rescheduling
   *every* program-wide every-block from real `UiTickCount()` whenever
   `casePostEventClick`'s legitimate direct call fired — stomping
   Canvas's virtual-tick-seeded `due` well before Canvas's own window
   opened. Fixed by gating `rtUiEveryPump` on `rtUiScripted`,
   forwarding to the already-correct `rtUiScriptEveryPump`. Rider
   (stale per-segment constant-pool duplicates) investigated and
   resolved as **policy, not a bug** — `testdata/valid/bounce.cla`'s 4
   real segments each carry exactly one full, non-redundant copy of the
   string-literal pool (120 entries), UI blob (168 bytes), and events
   blob (91 bytes+NUL); `cgEmitPoolsBody` has no mechanism to produce a
   duplicate beyond the documented one-copy-per-segment design.
3. **PostEvent clobber list (Task 7):** decoded against Apple's
   pragma, the `.a` glue comment, IM II's register table, and the
   sibling trap PPostEvent's own glue word (`0x2288` = `MOVE.L
   A0,(A1)`, proof the underlying dispatch code writes A0). A0 was a
   genuine latent under-clobber (`"r"(a0)` plain input, not in the
   clobber list); fixed to `"+r"(a0)`. Verified against
   `TestToolboxSuiteOnMac`'s `PostEventClick` subtest.
4. **Checker/lowering panic → diagnostic (Task 8):** the panic was in
   `lower.cla`, not `check.cla` as the plan's own prior corrections
   already suspected — `lowType`'s `TyXRec` arm (plus three sibling
   field-access sites) panicked on a checker-clean, forward-referenced
   `extern record`. Fixed with a position-carrying `lowTypeAt` +
   `recIdx == -1` guards emitting a real diagnostic. Delta beyond the
   plan: `internal/selfhost/diag_test.go`'s `TestErrorGoldens` had to
   switch from bare check-only mode to `clarusc emit` mode, because
   check-only mode never calls `lowerProgram` at all (confirmed by
   reading `main.cla`) and so could never reach a lowering-phase
   diagnostic — verified byte-identical output for all 10 pre-existing
   fixtures under the new mode before adding the 11th. Known follow-on
   gap, flagged not fixed: `ir.cla`'s `irXRecFieldSize`'s own recursive
   `XFRec` call is the same panic class for a *nested* forward-
   referenced xrec field; out of this item's scope ("the unknown-TYPE
   path specifically"), unexercised by any current fixture.

### Verification checklist (spec's own list, closing the loop)

1. Per-task T1 + snapshot regen: done every clarusc-touching task
   (1-5, 8).
2. Golden churn eyeballed, not just diffed: cg68k `ADDA` immediates
   (Task 4), emitui stamp/filter args (Task 2), `rtUiScripted` guard
   line (Task 6) — each confirmed to be the ONLY change in its diff.
3. `FInfoStamp` + the two un-workarounded label.text cases green on
   both native suite gates: confirmed (25/25 both lanes for
   `FInfoStamp`; `Buttons`/`Popuptable` re-verified post-un-workaround).
4. Checker/lowering fixture in the errors lane + a T1-visible twin
   (`internal/lowlevel/xrecorder_test.go`): both landed, per Task 8's
   own reasoning for why the errors-lane fixture alone would leave the
   panic class unguarded at T1.
5. Behavior goldens unaffected by FInfo stamping (not a byte-goldens
   concern); askOpen default-filter equivalence held (all 4 frozen
   scenarios byte-identical throughout, confirmed via `git status`
   after every native-lane gate run touching UI runtime code).
6. Full T2 green at phase end (this task): 239s, zero FAIL.
