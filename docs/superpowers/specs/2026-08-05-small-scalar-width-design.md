# Small-scalar width unification (`bool`/`char` = 1 byte in aggregates)

**Date:** 2026-08-05
**Status:** Approved (Andrew, 2026-08-05 — "Option B")
**Closes:** ROADMAP item 2b ("Character/byte-type surface review"), unblocking
item 3 (Docs cookbook).

## Motivation

The 2b review was scheduled to revisit `byte`, `char`, `bool`, and `text` as a
set before the Mac runtime freezes contracts. Andrew's driving concerns:

1. **Record footprint.** cg68k gives every `bool` and `char` ordinary-record
   field a full 4-byte slot (the Task-14/RT_FT rule). `bool` is ~10x more
   common than `char` in real code (149 vs 14 declarations in
   `runtime/clarus` alone), so record-heavy data models on a 1MB-class Mac
   pay 3 wasted bytes per `bool` field, per row.
2. **Backend divergence on `char`.** cg68k gives a `char` record field 4
   bytes; cprint emits `uint8_t` (1 byte). The layouts are documented as
   "MUST NEVER BE CROSS-USED" (`cg68k.cla:60-75`, `uiblob.cla:551-560`) —
   per-lane self-consistent, but a live hazard.

Survey findings that shaped the decision (all anchors as of 2026-08-05):

- The Task-14 4-byte rule exists because `rt_ui.c`'s `RT_FT_BOOL` descriptor
  arm does a raw `*(int32_t *)(rec + off)` read; the pre-fix backend reserved
  2 bytes and the popuptable `favorite: bool` column read CHECKED for every
  row. `char` was folded into the same rule purely for "one rule, not two" —
  `RT_FT_CHAR` reads only the base byte and never needed 4.
- The "bool is a full int32" contract is restated in six places
  (`cprint.cla:738`, `cg68k.cla:81`, `cg68k.cla:960`,
  `runtime/clarus/ser.cla:123-124`, `uitable.cla:34`,
  `uidialogs.cla:454,497`).
- `char` is already the language's general unsigned octet ("doubles as a
  byte (0-255) for binary data", reference Ch3) — not a Java-style wide
  char. `char[N]` arrays are already packed at stride 1 (Task 6's
  `cgArrElemStride` fix); `bool` arrays still stride 2.
- `byte` is a contextual field-type name recognized ONLY inside
  `extern record` bodies (like `word` in `external func` signatures); it has
  exactly two uses repo-wide, both compiler self-tests.
- The normative reference documents none of the width asterisks — Ch3 says
  flatly "1 byte" for `bool`/`char`, which is currently false in three of
  five contexts.

## The rule (normative outcome)

**`bool` and `char` occupy 1 byte in every aggregate — ordinary records,
arrays, and extern records — on both lanes. Locals and params keep 2-byte
stack slots (68000 alignment). Trap/extern boundaries keep Ch13's word-sized
rules unchanged.**

| Context | `char` | `bool` | before (cg68k / C lane) |
|---|---|---|---|
| Ordinary record field | 1 | 1 | 4/1 (char), 4/4 (bool) |
| Array element stride | 1 | 1 | 1 (char), 2 (bool) |
| Extern record field | n/a (`byte`) | 1 | already 1 |
| Local / param slot | 2 | 2 | unchanged |
| Trap boundary | word (Ch13) | word (Ch13) | unchanged |

Ordinary records pad interior `int`/`ptr`/`fixed` fields to even offsets and
round total record size to even (array-of-record stride), per normal 68000
alignment. After this change the two lanes' record-layout *rules* coincide;
the "never cross-use" guard remains as belt-and-suspenders.

## Naming surface — decided: keep all four

- `char` stays the one general unsigned-octet type. No new general `byte`
  type, no rename, no Java-style character/byte split.
- `byte` stays the extern-record-only contextual field name for numeric IM
  fields (SignedByte/Byte; reads/writes as `int`).
- `bool` and `text` keep their names and roles, with `text` officially
  documented as the binary file/buffer type (its dominant real use: the 68k
  assembler's byte emission, the serializer's cursor
  `rtSerGetByte(t: text): char`).

## Changes by component

### cg68k (`clarusc/cg68k.cla`)

- `cgRecFieldSizeOf`/`cgRecFieldAlignOf` (:977, :987): `KBool`/`KChar`
  return size 1 / align 1.
- `cgArrElemStride` (:948): `KBool` joins `KChar` in the unpadded (stride 1)
  branch.
- `cgRecordCtorAt` (:1725-1737): drop the 4-byte `CLR.L` over bool/char
  slots; clear 1 byte.
- Rewrite the "TASK 14 EXCEPTION" file-header note (:77-86) and the
  layout-divergence commentary (:60-75, :955-976) to describe the unified
  rule.

### cprint (`clarusc/cprint.cla`)

- Split field-type emission from local/param-type emission: record struct
  fields emit `uint8_t` for `KBool` (as `KChar` already does at :711). C
  locals/params/globals stay `int32_t` — host memory is free and expression
  code stays untouched.
- `cpEmitUiLayoutAsserts` regenerates; it keeps pinning host struct offsets.

### Host C runtime (`runtime/host`)

- `RT_FT_BOOL` descriptor arm: `*(int32_t *)` read/write becomes 1-byte.
  `RT_FT_CHAR` already reads one byte.

### Clarus runtime (`runtime/clarus`)

- The four `peekl`-for-bool sites (`ser.cla:123-124`, `uitable.cla:34`,
  `uidialogs.cla:454,497`) become 1-byte reads/writes. Together with the
  compiler-comment rewrites this deletes the "bool is a full int32" contract
  from all six restatement sites.
- Serializer format: `bool` fields serialize as 1 byte. Breaks `.clrs`
  compatibility; format is pre-1.0, nothing to migrate.

### Bootstrap

clarusc's own records change layout, so its emitted C changes:
`clarusc/clarusc.c` regenerates via the standard `TestSnapshotFixedPoint`
procedure. The 3-stage fixed point is the proof the change is
self-consistent through the bootstrap.

### Spec / docs

- Reference Ch3: the "1 byte" claims become true; add two explicit notes —
  the 2-byte local/param slot rule, and a pointer to Ch13 for boundary
  conventions.
- Reference Ch13: add array-stride and record-packing statements.
- ROADMAP: close 2b with an outcome note; the cookbook item's mapping table
  gains its settled wording (Boolean → `bool` (1 byte), SignedByte/Byte →
  `byte`, CharParameter → `word` — the MenuKey lesson lives in the
  trap-table reading guide).

## Testing & acceptance

- **New `core` case:** a mixed record (`bool`/`char`/`int`/`ptr` interleaved
  to force odd offsets) round-tripped through the serializer; asserts field
  values and total record size.
- **Existing pins:** the popuptable bool-column regression case (the
  original Task-14 bug), `caseMenuKeyMatches`, `cpEmitUiLayoutAsserts`, and
  the frozen UI goldens (`testdata/uisnaps` must stay byte-identical —
  visible behavior does not change).
- **68k listing goldens re-bless** (expected churn), with a mandatory
  eyeball pass for odd `.W`/`.L` effective addresses: Mini vMac does not
  model 68000 address errors, so green tests alone do not prove alignment
  (ROADMAP-filed hazard).
- **Gates:** T1 `--smoke` per task; full T2 (selfhost + both suite lanes)
  before merge.

## Risks

1. **Alignment** — the big one; covered by the golden eyeball pass above.
2. **Hardcoded offsets** — any code peeking record memory directly. The
   plan must include a repo-wide grep pass (`peekl`/`peekb` near bool/char
   record access) beyond the six known sites.
3. **Snapshot regen ordering** — the layout change must be self-consistent
   through the 3-stage bootstrap; `TestSnapshotFixedPoint` is the proof.

## Out of scope

- Local/param slot packing (68000 stack alignment is non-negotiable).
- Ch13 boundary conventions (trap marshaling rules are correct and pinned).
- Allowing `char` as an extern-record field type (use `byte` + `char(x)`).
- The Docs cookbook itself (ROADMAP item 3 — unblocked by, not part of,
  this phase).
