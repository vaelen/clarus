# Toolbox Cookbook — Design

**Date:** 2026-08-06
**Status:** Approved (brainstorming session with Andrew)
**ROADMAP:** item 3, "Docs cookbook" — plus the starter slice of its
follow-on (the curated `toolbox/` extern catalog), which was blocked on
extern-dedup and is now unblocked (identical-redeclaration merging landed
in the toolbox-integration phase, 2026-08-04).

## Goal

Turn the hard-won Inside Macintosh transcription lessons (MenuKey/CHAR,
bit-11 convention rule, small-scalar widths, Mini vMac alignment
blind spot) into durable documentation, and ship a small hardware-proven
catalog of real-name Toolbox declarations users can `include` instead of
re-transcribing.

No compiler or code-generator changes: every feature the docs describe
already exists.

## 1. Reference additions (Ch13, normative)

New subsection **"Transcribing Inside Macintosh Declarations"**, placed
after the Field Palette. Contents:

- The IM→Clarus mapping table:

  | Inside Macintosh | Clarus |
  |---|---|
  | INTEGER / OSErr | `word` (param/result and extern-record field) |
  | LONGINT / OSType / Fixed | `int` |
  | Boolean | `bool` (1 byte in every aggregate; word-marshaled high-byte at the pascal boundary per the trap-clause rules) |
  | CHAR (CharParameter) | `word` — **never** `char`; the char code is the low byte of a plain 16-bit INTEGER, while Clarus's `char` extern shape pads into the high byte (the MenuKey lesson, normative warning) |
  | SignedByte / Byte | `byte` (extern-record field) |
  | Str255 / StrN | `str` parameter (borrowed Str255 address) / `str[N]` field |
  | VAR parameter | `ptr` (extern-record variables/fields decay at the call site) |
  | Point by value | 4-byte extern record passed in an `int` position |
  | Ptr / Handle / ProcPtr | `ptr` |
  | ProcPtr you implement | `callback func` |

- The bit-11 trap-table reading rule as the normative convention test:
  `trap & 0x0800` set → Toolbox/pascal convention; clear → OS/register
  convention (`= trap N reg ...`).

Table plus terse normative paragraphs only — walkthrough prose lives in
the cookbook doc. Where any other doc disagrees, Ch13 wins (existing
repo rule).

## 2. Cookbook doc (`docs/clarus-toolbox-cookbook.md`)

New how-to companion; cites Ch13 as authority, never contradicts it.
Worked walkthroughs, each starting from the actual IM declaration and
ending at the Clarus one:

1. **Pascal trap** — MenuKey, including what the CHAR-as-`char` mistake
   looks like and how it fails (silently broken key-equivalent matches).
2. **Register trap + `memerr`** — SetHandleSize, applying the bit-11
   rule to pick the convention.
3. **Named-register form** — Gestalt with `reg(d0: …, a1: …) ret d0`.
4. **Extern-record transcription** — EventRecord/Point worked against
   the field palette.
5. **Selector dispatch** — LAddRow (`trap 0xA9E7 sel 0x0008`).
6. **Callback** — a control action procedure.
7. **Copy/paste: the two-scrap protocol** — Scrap Manager desk scrap vs
   TextEdit's private scrap; Cut/Copy = `TECut`/`TECopy` +
   `ZeroScrap` + `TEToScrap`, Paste = `TEFromScrap` + `TEPaste`; and the
   glue-routine-vs-trap lesson: `TEToScrap`/`TEFromScrap` have no trap
   word, so they cannot be declared `= trap NNNN` — they are reached
   through the runtime's existing `UiTEToScrap`/`UiTEFromScrap` externs.
   (Clarus programs get cut/copy/paste for free via the standard-edit
   runtime path — this walkthrough is about transcription, not a gap.)

Hard-won-lesson sections:

- **Mini vMac does not model 68000 address errors** — a native PASS does
  not prove alignment correctness; eyeball goldens for odd `.W`/`.L`
  bases.
- **Using the catalog** — how to `include` the `toolbox/` files, and why
  an identical redeclaration alongside them is safe (the dedup rule).

## 3. Starter catalog (`toolbox/` at repo root)

Four curated `.cla` declaration files using real IM names. Curated =
only traps already proven in this repo or trivially derived from a
proven sibling. Each file carries a header comment naming its IM source
volume/chapter.

- **`toolbox/memory.cla`** — NewPtr, DisposePtr, NewHandle,
  DisposeHandle, SetHandleSize (reg memerr), GetHandleSize, HLock,
  HUnlock, BlockMoveData, MoreMasters.
- **`toolbox/events.cla`** — `Point` + `EventRecord` extern records;
  event-what / event-mask / modifier constants; EventAvail,
  GetNextEvent, PostEvent, TickCount, Button, StillDown.
- **`toolbox/osutils.cla`** — Gestalt (named-reg, `ret d0`), Delay,
  SysBeep.
- **`toolbox/scrap.cla`** — ZeroScrap, PutScrap, GetScrap, InfoScrap,
  LoadScrap, UnloadScrap; `ScrapStuff` extern record (InfoScrap's
  result shape). Desk-scrap traps only — the TE-side bridge routines
  are glue, not traps, and stay out (see walkthrough 7).

**Collision constraint:** any catalog name that can co-occur with a
runtime declaration under `--testapi` (the suite GUI builds splice
runtime modules in) must be dedup-identical to the runtime's
declaration, or renamed until it cannot collide. Verified during
implementation by building the toolbox suite with the catalog files in
the list.

## 4. Testing

Two layers; no new emulator boot (the just-consolidated 16-boot
inventory stays at 16):

1. **T1, ungated host test** — runs clarusc check over each catalog
   file paired with a minimal driver program (a bare catalog file has no
   `app`, so it cannot be checked alone). Proves the files parse and
   type-check on every T1 run.
2. **One new toolbox-suite case, `Catalog`** (23 → 24 real cases). The
   four catalog files join the toolbox suite's build file list; the case
   exercises, through catalog declarations only: Gestalt, a
   NewPtr → BlockMoveData → DisposePtr roundtrip, EventAvail, and a
   PutScrap → GetScrap roundtrip. Hardware-proves the catalog on both
   existing suite boots (`TestToolboxSuiteOn68k` / `TestToolboxSuiteOnMac`).

## 5. Rider

Fix `runtime/clarus/ui.cla:263`'s `UiFlushEvents = trap 0xA032`
pascal-convention misdeclaration (bit 11 clear → OS/register
convention), filed during the toolbox-integration phase. Included
because shipping a doc that teaches the bit-11 rule while the runtime
violates it invites a copied bug. One-declaration fix; pulls in a
bootstrap-snapshot regeneration.

## Out of scope

- Collapsing the runtime's prefixed duplicate declarations
  (`ListNewPtr`/`MapNewPtr`/`SerNewPtr`/…) onto catalog names.
- Any broader per-manager catalog expansion (Windows, Menus, Dialogs,
  QuickDraw, …) — follow-on, now unblocked, driven by demand.
- Any compiler, code-generator, or (rider aside) runtime changes.
