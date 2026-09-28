# SE memory program, Wave 3: Narrow scalars (spec, 2026-09-28)

Status: **spec, awaiting review.** Branch `se-wave3-narrow-scalars`.
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 3 is the
brief; D3–D8 are decided inputs). Wave 2's numbers and at-peak census:
umbrella §9.3 and `docs/HISTORY.md`'s Wave 2 entry.

Anchors below are as of `main` at `1c7a76c5`.

## 1. Goal and exit

Add the narrow integer types `uint8`, `int16` and `uint16`. Make enums
2 bytes on the native lane. Move the serializer to format v2. Retire
the `word`/`byte` extern spellings. Then let the compiler's biggest
arenas use the narrow types.

**Exit:**
- `tests/memgate/budget.txt` `bookmarks_rtbake` ≤ **3.5 MB**
  (3,670,016 bytes). Its measured peak + 1% is committed. Today the
  peak is 3,668,312 at `Built fork`, and `irExprs` alone is 1.31 MB
  of it (Wave 2 at-peak census). If 3.5 MB is not reached, the wave
  records the measured figure and the at-peak census, and revises its
  own number (umbrella §5.5).
- The other two memgate budgets drop to their new peaks + 1%.
- `file.save` writes v2 and `file.load` reads v1 and v2. The core
  suite and the CLRD goldens prove this, plus a new frozen v1 fixture.
- No `word` or `byte` type spelling remains anywhere: `.cla`, docs,
  fixtures or diagnostics.
- End-of-wave gates (umbrella §5.3): full T2;
  `mactest/snow/clarusc_bake` on the IIcx (this wave touches
  `bake.cla`); and `mactest/snow/clarusc_memprobe` on the IIcx, with
  its numbers recorded in umbrella §9.

## 2. Decisions settled in this spec

| #   | Decision                                                                                                                                                                                                                                                                                  |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| N1  | **Literal typing.** An integer literal whose value is in range adopts the narrow type expected at that point: an assignment target, an argument, a return, a field initializer, or a comparison operand of that type. An out-of-range literal there is a build error: `300 is out of range for uint8 (0..255)`, and `-1 is out of range for uint16 (0..65535)`. Elsewhere a literal is `int`, as today. |
| N2  | **`text.wordAt`/`wordAtLE` keep returning `int`** (0–65535). Under D4 a later change to `uint16` would be compatible; making it now only adds churn.                                                                                                                                         |
| N3  | **Form binding** (Andrew, 2026-09-28). A `field` bound to a `uint8`/`int16`/`uint16` record field behaves like an `int` field: numeric input only. OK validation also fails when the value is out of the type's range, or when it has a minus sign for `uint8`/`uint16`, exactly as a non-numeric value fails today. A table `column` shows the value as a decimal number. |
| N4  | **One spec and one plan** (Andrew, 2026-09-28), with parallel waves inside the plan and the serialization points listed in §5.                                                                                                                                                           |
| N5  | **The box-size constants move to their own lane pair**, `boxsize_c.cla`/`boxsize_68k.cla`, placed right after `core.cla` in every module list. The host `--testapi` early-visible set goes back to ending after `uidialogs.cla` (Wave 2 widened it only because the constants lived in the datetime pair). Andrew folded this into Wave 3. |
| N6  | **Compiler arenas narrow only non-index fields**, mostly for free through N8: enum-typed kind/op/mode fields become 2 bytes on both lanes, and the plan groups them so that no padding eats the saving. Explicit `uint8` fields are used only where the measured saving justifies the conversions. Every arena index, name index, count and value stays `int`: a self-compile already has more than 65,535 expressions. Narrowed fields are grouped together in each record, so that no padding eats the saving on either lane. |
| N8  | **D7 is revised: enums are 2 bytes on both lanes** (Andrew, 2026-09-28). The C lane also stores an enum-typed record field and an enum array/list/map element as `int16_t`. This matches the reference ("enums are 2 bytes"), gives the serializer one in-memory enum width, and lets the host memgate see the arena saving (§3.6). Enum locals, parameters, globals and returns keep their current C type (`int32_t`). The native lane follows §3.3 everywhere. |
| N7  | **`uint` (32-bit unsigned) is deferred** to `docs/FUTURE.md`, with D3's cost list: unsigned compares and divide, a new `rtUIntToStr`, literal-range work, and C-lane mixing hazards.                                                                                                              |

Decided inputs (umbrella §2), restated briefly: D3 (the three types, no
`uint`); D4 (implicit widening, 32-bit arithmetic, explicit truncating
narrowing, in-range literals accepted); D5 (at an extern or callback
argument and at an `extern record` field store, an `int` value is
accepted for a narrow slot and truncated); D6 (`word` → `int16` and
`byte` → `uint8` everywhere, then remove the old spellings); D7 (enums
become 2 bytes natively; revised by N8 to both lanes); D8 (serializer v2 with 2-byte enum fields,
v1 still loads, one deliberate CLRD re-pin plus a frozen v1 fixture).

## 3. Work

### 3.1 Narrow types: checker, IR and both lanes

- **Representation.** A width/signedness tag on the existing int kind
  (`TyInt` in `types.cla` ~l.34, `KInt` in `ir.cla` ~l.98), stored in
  the aux field the way `TyStr` stores its capacity. Tag 0 means plain
  `int`, so every existing type encodes exactly as today. No new
  `IRKind` ordinal is added, so the bake's raw-ordinal `IRKind`
  serialization (`bake.cla` ~l.828/~l.2543) is unchanged.
- **Checker sites that need per-width rules** (umbrella §6):
  - the arithmetic result type (`checkArith` ~`check.cla` l.5578), which
    is always `int`;
  - assignability (`assignable`, `types.cla` ~l.442; its same-kind
    fallthrough ~l.495 must compare widths): narrow → `int` is implicit,
    `int` → narrow is not, and narrow → a different narrow type is not;
  - literal range (N1);
  - `>>` and negation (`checkUnary` ~l.5516), whose result is `int`;
  - `string()` and the conversions (~l.5990–6030): `uint8(x)`,
    `int16(x)` and `uint16(x)` accept `int`, `char` and the other narrow
    types, and truncate; `string(n)` accepts every narrow type;
  - UI field binding (`check.cla` ~l.4155; N3);
  - the extern and callback gates (D5).
- **Lowering:** the three int-specific sites (`lower.cla` ~l.402, 1280,
  2186).
- **68k codegen:**
  - `uint8` clones the `char` path, since 1-byte fields, elements and
    frame slots already exist.
  - `int16`/`uint16` add a `sz==2` branch to `cgLoadVar` (~l.6760),
    `cgStoreScalarVar` (~l.6780), `cgLoadFieldScalar` (~l.6800),
    `cgEmitStoreScalarAny` (~l.6829), `cgPushArgs` (~l.10572) and the
    return paths. A load is `MOVE.W`, followed by `EXT.L` for `int16`,
    or by clearing the high word for `uint16`. A store is `MOVE.W`/
    `MOVE.B`, which truncates.
  - The peephole patterns are size-1/size-4 only, so word shapes do not
    match them. That is safe.
  - Byte-identical for every program that does not use the new types.
- **C lane:** `cpCType` (`cprint.cla` ~l.940) emits `uint8_t`/
  `int16_t`/`uint16_t`. C integer promotion already gives D4's
  semantics.
- **Reference:** a new section on the three types (ranges, widening,
  explicit narrowing, literals, the extern rule, and form binding). The
  scalar-types table gains three rows.
- **FUTURE.md:** the `uint` entry (N7).

### 3.2 `word`/`byte` → `int16`/`uint8` (D5, D6)

1. `int16` and `uint8` are accepted wherever `word` and `byte` are
   accepted today: extern and callback parameters and returns,
   `extern record` fields, and `reg(...)` bindings. Their marshaling is
   identical to `KWord` (`ir.cla` ~l.142–155), and D5's silent-truncation
   rule applies at those positions only.
2. Mechanical rename. The umbrella counts about 317 `word` uses, about
   51 `byte` uses, about 200 doc mentions and about 10 diagnostic
   fixtures. It covers `runtime/clarus/`, `toolbox/`, `clarusc/`,
   `testsuite/`, `examples/`, `testdata/`, the reference, the cookbook
   and CLAUDE.md. Every compiled program is byte-identical except
   ClarusC.APPL, which bakes source text.
3. Remove `TxWord`/`TxByte` (`ast.cla` ~l.292–315), their parse sites
   (`parse.cla` ~l.1359/1682) and their checker sites (`check.cla`
   ~l.2492–2525). Using the old spelling now gives an ordinary unknown
   type diagnostic.

### 3.3 Enums are 2 bytes (D7, revised by N8) — **output-changing**

- `cgSizeOfUncached`'s `KEnum` case (`cg68k.cla` ~l.1939) returns 2.
  Update the comment at ~l.4876.
- Enum fields, elements, locals, arguments and returns go through the
  `sz==2` paths from §3.1. Enum values are never negative, so the
  signed and unsigned loads give the same result; use `uint16`'s
  zero-extension.
- **C lane (N8):** `cpCType`'s `KEnum` case (`cprint.cla` ~l.943)
  stays `int32_t` for locals, parameters, globals and returns. The
  record-layout and element-type paths (`cpEmitLayouts` ~l.6801–6867,
  plus the list/map element sizes) emit `int16_t` for an enum field or
  element. C promotion does the widening on read.
- **Rebless:** most `testdata/cg68k/*.s` goldens, the emitui C goldens
  of programs with enum fields, and the bake twins move. It is its own
  isolated task, with a written reason per golden family.
- **Native proof:** the core and toolbox suites run on the emulator in
  the same task, because a wrong width corrupts memory without failing
  a host test.

### 3.4 Serializer v2 (D8)

- `runtime/clarus/ser.cla`:
  - the header version byte goes 1 → 2;
  - an ENUM field is 2 bytes in memory (§3.3) and 2 bytes on disk in
    v2;
  - the v1 loader reads a 4-byte enum field and narrows it;
  - new `RtFt*` codes for `uint8`/`int16`/`uint16` store their natural
    widths (1/2/2 bytes).
- The codes are added at the three producers (`uibFieldTypeNum`
  `uiblob.cla` ~l.282, `cpSerFieldRow` in `cprint.cla`,
  `cgBuildSerdescInts` `cg68k.cla` ~l.4968), at the consumer
  (`ser.cla` ~l.98–103, 132, ~366), and at `uidesc.cla` ~l.64–67, which
  shares the numbering.
- **CLRD:** one deliberate re-pin of `testdata/sertest/clrd_goldens/`
  with `CLRD_BLESS=1`, in the task that exists for it. Also add a new
  frozen v1 `.dat` fixture that the core suite loads and checks field
  by field.
- **Core suite:** a new case that saves a record holding every narrow
  type and an enum, loads it back, and checks each field. Loading the
  frozen v1 file is its own assertion. The core case count moves in all
  five places.

### 3.5 The box-size lane pair (N5)

This needs two steps around a snapshot regeneration. The committed
snapshot builds `clarusc-current` by splicing its own module list, so a
module it does not know cannot hold a constant the runtime needs.

1. **Before the regeneration:** add `boxsize_c.cla`/`boxsize_68k.cla`
   holding only a header comment, and add them right after `core.cla`
   in `bakeModuleList`, `driveManifestSplice` and `driveEarlySplice` on
   both lanes. Add the `tests/bake/boxsize.sh` `emit68k_pair` twin
   (CLAUDE.md standing rule). The constants stay in the datetime pair.
   Byte-identical.
2. **After the regeneration:** move the four `rt*BoxSize` constants from
   `datetime_c.cla`/`datetime_68k.cla` into the new pair. Put the host
   early-visible boundary back after `uidialogs.cla` (undoing Wave 2
   Task 9's widening in `drive.cla` and `bake.cla`). Point
   `tests/lowlevel/boxsize68k.sh` at `boxsize_68k.cla`. Update
   CLAUDE.md's `--testapi` paragraph and the datetime headers, and
   close the `docs/TODO.md` entry. Byte-identical: the C output, the
   emitui goldens and the host testapi builds are unchanged, which
   `CLARUS_BAKE_FULL=1` confirms.

### 3.6 Compiler arenas adopt narrow fields (N6) — byte-identical

- After §3.3 (N8), every enum-typed field is 2 bytes on both lanes. This
  task **reorders fields** so that the 2-byte enum fields sit together,
  and no padding eats the saving. It measures first and after with
  `scripts/memcensus.sh --rtbake --at-peak`.
  - `IRExpr` (`ir.cla` ~l.325): `kind` and `convOp` go together at the
    front. On the host that is 40 → 32 bytes (`bool` stays `int32_t` in
    C), about 260 KB at the 32,768-element capacity. Natively it is
    40 → 28.
  - `IRStmt` (~l.315), `IRType` (~l.308) and `A68Item` (`asm68k.cla`
    ~l.180, whose `op`/`sm`/`dm` are enums): reorder only where the
    measured size actually drops.
- `bool` and `int` fields of a kind or size nature (`A68Item.kind`/
  `size`/`dataKind`) become `uint8` only if the census shows a real
  saving, and never an index field (N6).
- The bake serializes field by field, not by layout, so the CLIR bytes
  do not change. Code that depends on field order (positional record
  literals, if any) is audited.
- Expected: `bookmarks_rtbake` goes from 3.67 to about 3.41 MB, under
  the 3.5 MB exit.

## 4. Output policy (umbrella §5.4)

| Change                                                   | Label                                                                          |
|----------------------------------------------------------|--------------------------------------------------------------------------------|
| narrow types (§3.1)                                      | byte-identical for existing programs; new core cases                           |
| extern acceptance, the rename, the removal (§3.2)        | byte-identical (ClarusC.APPL's baked source changes by design)                 |
| 2-byte enums (§3.3)                                      | output-changing (both lanes, N8): isolated rebless, a reason per golden family |
| serializer v2 (§3.4)                                     | output-changing: the deliberate CLRD re-pin; the new frozen v1 fixture         |
| the box-size pair (§3.5)                                 | byte-identical                                                                 |
| arena narrowing (§3.6)                                   | byte-identical (compiler internals); runs after §3.3                           |
| snapshot regenerations                                   | serialization points                                                           |
| memgate budgets                                          | ratchet down, one commit                                                       |

## 5. Sequencing

- **Wave A (parallel):** §3.1 (narrow types on both lanes, plus the
  reference) and §3.5 step 1 (boxsize scaffolding).
- **Snapshot regeneration:** the compiler's own sources can use the
  narrow types and the boxsize modules only after this.
- **Wave B (parallel):** §3.2 step 1 (extern acceptance), §3.4 without
  the enum-width part (v2 framing and the new codes), and §3.5 step 2
  (move the constants).
- **Serialization points, alone, in this order:**
  1. §3.3 plus §3.4's enum width and the CLRD re-pin, together, since
     the in-memory enum width and the on-disk format change at the same
     time;
  2. §3.6 (arena narrowing), which needs §3.3's width and a snapshot
     regeneration so that the compiler itself is built with 2-byte
     enums;
  3. §3.2 step 2 (the rename);
  4. §3.2 step 3 (the removal);
  5. the final regeneration plus the ratchet.
- **Close:** the IIcx measurement, docs and gates.

## 6. Tests

- Per task: T1 (`scripts/test-task.sh`, no `--smoke`), plus the
  identity check from the Wave 2 plan for every byte-identical task.
- **New core cases:** narrow arithmetic and widening, truncating
  conversions, the literal range at every N1 position, fields and
  array elements of each width, locals, arguments and returns, and the
  serializer round trip plus the v1 load.
- **New diagnostic fixtures:** an out-of-range literal per type,
  `int` → narrow without a conversion, and a narrow → different narrow
  assignment.
- **New toolbox case:** a form with a `uint16` field that rejects
  `70000` and `-1` at OK, and accepts `8080`.
- Native: the core and toolbox suites boot in §3.3's task and again at
  T2.

## 7. Out of scope

- `uint` (N7). Narrowing any compiler index field (N6).
- Returning `uint16` from `text.wordAt` (N2).
- Lazy runtime library, `readAt` of the CLIR (Wave 4). Segments and
  overlays (Wave 5).
