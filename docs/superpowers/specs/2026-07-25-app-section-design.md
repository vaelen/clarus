# `app` Section + Richer About Box — Design

Date: 2026-07-25
Status: approved (brainstormed with Andrew)

## Goal

Two deliverables, one motivation: the About box currently reuses the error
alert (`ALRT`/`DITL` 128) and shows only the app's filename floating in a
box sized for multi-line error text. The reference (Ch9) promised "a richer
About dialog will come later" — this is that later.

1. **Language:** a declarative `app` section, in the same family as
   `window` and `menu`, carrying app identity: name, version, author,
   about text, icon, and creator code.
2. **Runtime/build:** an About box that shows that identity with a proper
   layout, a real Finder icon (ICN# + BNDL/FREF + creator), and output
   naming derived from the section.

The Go compiler stays frozen per CLAUDE.md: this lands in the reference +
clarusc + Mac runtime/build only.

## Part 1 — Language surface

### Reference (Ch7 Application Lifecycle + Appendix A grammar; Ch9 About wording)

```
app Mandelbrot {
    name: "Mandelbrot"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "An example Clarus application that displays the Mandelbrot set in a window."
    icon: "mandelbrot.pbm"
    id: "MNDL"
}
```

- Top-level declaration; **at most one per program** (across all included
  files). The label is required, matching `window`/`menu` grammar.
- Properties are newline/semicolon-separated `key: value`, no commas —
  the same shape as `window` properties.
- **Every property is optional**, and the whole section is optional.
  Programs without one behave exactly as today.
- All values are **string literals** (checker rejects non-literal
  expressions, same diagnostic family as non-literal window geometry).

### Checker rules

- Duplicate `app` section → error (report at the second one).
- Duplicate key within the section → error.
- Unknown key → error.
- `id`: exactly 4 characters, all printable ASCII, not all-lowercase
  (all-lowercase creators are reserved by Apple) → else error.
- `id` **required if `icon` is present** (BNDL/FREF need a creator);
  otherwise optional.
- `icon`: path resolves relative to the declaring file's directory
  (same rule as `include`). Existence/format is checked at build time
  (build-mac.sh), not by the checker — `clarusc check` stays filesystem-
  independent beyond includes.
- The label and property values do not need to agree; `name` is the
  display name, the label is the fallback.

## Part 2 — Runtime plumbing (rt_ui.c + clarusc emit)

Reuse the weak-symbol pattern already proven by `rt_ui_test_script`:

- `rt_ui.h` declares `rt_app_info` — C-string fields `name`, `version`,
  `author`, `about` (empty string = absent; `icon`/`id` are build-time
  only and never reach the runtime struct).
- `rt_ui.c` defines a **weak** all-empty default.
- When an `app` section exists, clarusc emits a **strong**
  `const rt_app_info` definition in the generated C. No
  `rt_ui_startup` signature change; non-UI programs may carry the
  section (it still drives naming) and simply never show it.

## Part 3 — About box (rt_ui.c + alert.r)

With a non-empty `rt_app_info.name`:

- Apple menu item becomes `About <name>…` (built at menu-setup time from
  the struct, replacing the static "About This Application").
- Selecting it shows a new fixed-size **ALRT/DITL 129** (alert.r), the
  approved icon + text block layout:

```
┌──────────────────────────────────┐
│  ████    Mandelbrot  1.0         │
│  █icon█  Andrew C. Young         │
│  ████    <andrew@vaelen.org>     │
│                                  │
│  An example Clarus application   │
│  that displays the Mandelbrot    │
│  set in a window.                │
│                      ┌──────┐    │
│                      │  OK  │    │
│                      └──────┘    │
└──────────────────────────────────┘
```

- Text arrives via ParamText: `^0` name, `^1` version, `^2` author,
  `^3` about. Static text items wrap the about text automatically.
- The DITL's icon item (ICN# 128) is included **only when an icon is
  declared** — the base alert.r DITL 129 has no icon item; the build's
  generated per-app resource file (Part 4) supplies an overriding
  DITL 129 with the icon item when `icon:` is set. (Exact override
  mechanism — separate resource ID picked at runtime vs. Rez replace —
  is a plan-time decision; the contract is: icon declared ⇒ icon shown,
  else clean text-only layout, never a missing-resource artifact.)
- **No `app` section (or empty name): exactly today's behavior** —
  "About This Application" → name-only NoteAlert 128. Existing examples
  and blessed UI goldens are untouched.

## Part 4 — Icon, creator, version resources (build-mac.sh)

- `icon:` names a **32×32 1-bit PBM** (P1 or P4 — the format the project
  already uses for UI snapshots). Wrong size/format → build error.
- A small C helper, `scripts/pbm2icn.c`, compiled on the fly by
  build-mac.sh (same caching trick as the clarusc bootstrap), converts
  the PBM to Rez `ICN#` data (icon + mask).
- **Mask (the "alpha channel"):** PBM has none, so the mask is derived —
  flood-fill white from the image border; reached pixels become
  transparent, enclosed white stays opaque white. Upgrade path if an
  icon ever needs explicit transparency: an optional `mask:` property
  naming a second PBM. Not built now.
- build-mac.sh generates a per-app `appres.r`: `ICN#` 128 +
  `BNDL`/`FREF`/signature resources (creator = `id`), the icon-bearing
  DITL 129 override, and a `'vers'` 1 resource from `version` + `name`
  (Finder Get Info).
- Creator/type stamping goes through Retro68's `add_application`.
  **Plan-time risk to verify:** whether Retro68 sets CREATOR and the
  Finder *bundle bit* (needed for the icon to show on the desktop); if
  not, stamp the file attributes on the .dsk with hfsutils
  (`toolchain/bin` h* tools) as a build-mac.sh post-step.

## Part 5 — Output naming

Resolved name, in order of preference:

1. `name:` inside the `app` section
2. The `app` label (`app Mandelbrot {}`)
3. First input filename's basename (today's behavior)

- clarusc gains a tiny `appname FILE...` subcommand printing the resolved
  name (runs the front end far enough to read the section).
- build-mac.sh: an explicit NAME first argument **still wins** (keeps
  mactest and existing callers working unchanged); if the first argument
  is a `.cla` file, the script asks `clarusc appname`.
- The resolved name is used **verbatim** for display (About box, `vers`);
  for the CMake target and output filenames it is **sanitized**
  (any char outside `[A-Za-z0-9_-]` → `-`), since CMake target names
  can't contain spaces.

## Part 6 — Mandelbrot example

- `examples/mandelbrot.cla` gains the `app` section shown above.
- `examples/mandelbrot.pbm`: a 32×32 1-bit rendering of the Mandelbrot
  set silhouette (generated from the same escape-time math; enclosed
  white lakes stay white via the derived mask).

## Testing

- clarusc unit tests (`clarusc/test/*_test.cla` + `.out` goldens):
  parse/check coverage — happy path, duplicate section, duplicate key,
  unknown key, bad `id`, icon-without-id, non-literal value.
- New syntax is clarusc-only (Go compiler frozen), so `app` corpus files
  stay out of the differential-parity corpus, following the canvas
  `pattern` precedent.
- `TestSnapshotCurrent` regeneration (clarusc.c snapshot).
- UI scenario: a `testdata/ui` scenario with an `app` section exercising
  the About item → blessed trace + PBM snap of the new about box.
  Existing scenarios (no `app` section) must produce byte-identical
  goldens (regression gate for Part 3's fallback).
- pbm2icn: golden test — known PBM in, known Rez hex out (including a
  shape with an enclosed white region, proving the flood-fill mask).
- Manual: build mandelbrot, screenshot the About box in the emulator;
  verify Finder shows the icon on the .dsk.

## Out of scope

- Explicit `mask:` property (upgrade path noted above).
- Color icons (`icl4`/`icl8`), document-type FREFs beyond APPL, custom
  about-box sizing to fit long text (fixed-size DITL; text that
  overflows is clipped — author the about text to fit).
- Go compiler changes.
