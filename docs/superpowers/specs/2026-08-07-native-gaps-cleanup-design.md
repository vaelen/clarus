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
