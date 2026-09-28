# SE Wave 3 (Narrow scalars) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:**
- Add `uint8`/`int16`/`uint16` to the language, on both lanes.
- Make enums 2 bytes on both lanes.
- Move the serializer to format v2 (still loading v1).
- Retire the `word`/`byte` extern spellings.
- Let the compiler's arenas shrink, so the `bookmarks --rtbake` peak goes from 3.67 MB to ≤ 3.5 MB.

**Architecture:**
- Narrow ints are a width tag on the existing int kind, not new kinds.
- The native lane gets `sz==2` load/store/push/return paths. The C lane emits `<stdint.h>` types.
- Enum storage (record fields and container elements) becomes 2 bytes on both lanes. The compiler's own arena records then shrink by grouping their enum fields.
- The box-size constants move into a dedicated lane pair.
- Snapshot regenerations are placed wherever compiler sources start using something the committed snapshot does not know.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`, `toolbox/*.cla`, `testsuite/`), C99 host runtime, POSIX sh tests, Mini vMac (controlled boots in Tasks 3 and 9), Snow (the wave close).

**Spec:** `docs/superpowers/specs/2026-09-28-se-wave3-narrow-scalars-design.md` (umbrella: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`, §2 decisions D3–D8; the spec's N8 revises D7 to both lanes).

## Starting a fresh session on this plan

This plan is written to be executed from a cleared context. The controller should:
1. Read `CLAUDE.md`, this plan, and the spec.
2. Use superpowers:subagent-driven-development. Run `bash scripts/sdd-workspace PLAN_FILE` from that skill to get the workspace, and create the ledger with the preflight scan.
3. Create the worktrees for each parallel wave as below.

The branch `se-wave3-narrow-scalars` already exists and holds the spec (`77354a25`) and this plan. Waves 1 and 2 used the same process: their `docs/HISTORY.md` entries list the rulings and the pitfalls. Two of those pitfalls matter here:
- The snapshot builds `clarusc-current`.
- The memgate `bookmarks_rtbake` subcase runs from `$WORK`, outside the repo.

## Global Constraints

- **Branch and merging.** Branch `se-wave3-narrow-scalars`. `main` stays green. Merge only when Andrew asks.
- **Model.** Every implementer and reviewer runs on Opus (`model: opus`). The exception is Task 11, the mechanical rename, which may use `haiku` for the batch edit, with an Opus review.
- **Per-task gate.** `flock /tmp/claude-1000/clarus-w3-gate.lock scripts/test-task.sh` (T1, no `--smoke`; it includes `memgate/`). The lock is shared by all worktrees: the AppleTalk lock is per-worktree, and perfgate needs an idle machine. Focused `make test T=...` runs need no lock unless they include `atalk/` or `perfgate/`.
- **Emulators.** No boots except Tasks 3 and 9's controlled native-suite boots and Task 14. The command for those boots is `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority; CLARUS_MAC_TESTS=1 make -j1 test T='mactest/coresuite_68k mactest/toolbox_68k'`.
- **Process safety.** Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write the `snow/`, `macplus/` or `macplus2/` pristine images.
- **grep.** `grep` is ugrep and skips MacRoman/ISO-8859 files (`clarusc/lex.cla` is one). Use `/usr/bin/grep -a` for every audit over `.cla` files.
- **Byte-identity.** A task labeled byte-identical changes no existing golden: `testdata/cg68k/*.s`, emitui, `bake/`, selfhost behavior and module stdout, `testdata/errors/*.expect`, and the CLRD goldens. Output-changing tasks (Task 9) rebless only the families they name, each in its own commit with a written reason. If anything else moves, stop and report.
- **Identity check** (every byte-identical compiler task, before committing). Use `D=/tmp/claude-1000/w3tN`, where `N` is the task number:
  ```sh
  make -j tools bootstrap
  D=/tmp/claude-1000/w3tN; mkdir -p $D/idA $D/idB
  build-run/clarusc-snapshot --bake-ir --lane 68k --rtdir runtime/clarus/ -o $D/idA/rt.clir
  build-run/clarusc-current  --bake-ir --lane 68k --rtdir runtime/clarus/ -o $D/idB/rt.clir
  cmp $D/idA/rt.clir $D/idB/rt.clir || echo "DIFF clir"
  for f in bookmarks hello-mac texteditor tcpchat; do
    build-run/clarusc-snapshot emit68k --rtdir runtime/clarus/ -o $D/idA/$f.bin examples/$f.cla
    build-run/clarusc-current  emit68k --rtdir runtime/clarus/ -o $D/idB/$f.bin examples/$f.cla
    cmp $D/idA/$f.bin $D/idB/$f.bin || echo "DIFF src $f"
    build-run/clarusc-current emit68k --rtdir runtime/clarus/ --rtbake $D/idB/rt.clir -o $D/idB/$f.bin examples/$f.cla
    cmp $D/idA/$f.bin $D/idB/$f.bin || echo "DIFF rtbake $f"
    build-run/clarusc-snapshot emit --rtdir runtime/clarus/ -o $D/idA/$f.c examples/$f.cla
    build-run/clarusc-current  emit --rtdir runtime/clarus/ -o $D/idB/$f.c examples/$f.cla
    cmp $D/idA/$f.c $D/idB/$f.c || echo "DIFF C $f"
  done
  ```
  Expected: no `DIFF` line. If the runtime gains or changes a function, `DIFF clir` is expected and must be explained in the report. The per-program lines must still match.
- **Snapshot.** `clarusc-current` is compiled by the committed snapshot (`Makefile`, the `$(BR)/clarusc-current` rule). No `clarusc/*.cla` may use the narrow types, `int16`/`uint8` at extern positions, or a new runtime module before the regeneration that teaches the snapshot about them. That is Task 5, Task 10's first step, and Task 13. Only those three tasks regenerate `clarusc/clarusc.c`. `selfhost/fixedpoint` failing between regenerations is expected. Other tasks may run `selfhost/diag` and `selfhost/modules`, but not the rest of `selfhost/`.
- **Memgate.** Budgets only go down. Tasks 1–12 do not edit `tests/memgate/budget.txt` (parallel edits collide); they record before/after peaks in their reports. Task 13 ratchets.
- **Case counts.** The core and toolbox suite counts are hand-maintained in five places each, listed in CLAUDE.md. Current values: core 85 (84 real + `SelfCheck`), toolbox 40 (39 real + `SelfCheck`).
- **Commits.** Messages end with:
  ```
  Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01TSN5Gu3dKXT51LZnfqpfFP
  ```

## Review Focus

0. **Mixed-width arithmetic and compares.** In `a + b` with `a: uint8 = 200`, `b: uint8 = 100`, the operands widen to `int`, so the sum is 300, not 44. `int16` −1 compared with `uint16` 65535 gives unequal: both widen to `int` first. Task 1's host case and Task 3's native boot pin both.
1. **Truncating conversions.** `uint8(300) == 44`, `int16(40000) == -25536` and `uint16(-1) == 65535` hold on both lanes. Task 1 (host) and Task 3 (native) pin them.
2. **Narrow values through every storage class.** Locals, globals, parameters, returns, record fields, fixed-array elements, and `list of uint16`/`map of int16` values must round-trip their extreme values (0, max, and min for `int16`). The sign must survive a load, and `uint16` 65535 must not come back as −1. Task 3 pins all of this natively.
3. **A v1 file written before this wave loads after it.** This includes a record with an enum field (bookmarks' own shape). Task 9's frozen v1 fixture and core case pin it.
4. **The 2-byte enum in every container and the serializer on both lanes.** An enum as a `list` element, a `map` value, a fixed-array element, a record field inside a `list of record`, and a UI popup's bound field must all work. Task 9's cases and native boot pin these.
5. **The UI form range check.** OK is refused for `70000` and `-1` in a `uint16` field and accepted for `8080`, and the refusal is reported the way a non-numeric value is today. Task 4's toolbox case pins it.

## Tracks and waves

| Wave | Tasks                                                                                 | Where                                                       |
|------|---------------------------------------------------------------------------------------|-------------------------------------------------------------|
| A    | 1 narrow types: front end + C lane · 2 box-size scaffolding                            | worktrees `../clarus-w3-t1`, `../clarus-w3-t2`             |
| A2   | 3 narrow types: 68k codegen · 4 form binding + `RtFt` codes                            | worktrees (both need Task 1 merged)                        |
| B0   | 5 snapshot regeneration (**serialization point**)                                      | branch tip, alone                                           |
| B    | 6 `int16`/`uint8` at extern positions · 7 serializer v2 framing + narrow fields · 8 move the box-size constants | worktrees                              |
| C1   | 9 2-byte enums, both lanes + serializer enum width + CLRD re-pin (**output-changing**) | branch tip, alone                                           |
| C2   | 10 snapshot regeneration, then arena field grouping                                     | branch tip, alone                                           |
| C3   | 11 rename `word`→`int16`, `byte`→`uint8`                                                | branch tip, alone                                           |
| C4   | 12 remove `word`/`byte`                                                                  | branch tip, alone                                           |
| D    | 13 final snapshot regeneration + ratchet + census                                        | branch tip, alone                                           |
| E    | 14 IIcx re-measure, docs, end-of-wave gates (controller-driven)                          | branch tip                                                  |

Shared files within a parallel wave:
- **Wave A:** Task 1 touches the checker, IR, lower, cprint and the reference. Task 2 touches `bake.cla`/`drive.cla` module lists and `runtime/clarus/boxsize_*.cla`. Disjoint.
- **Wave A2:** Task 3 touches `cg68k.cla` load/store/push/return plus core cases. Task 4 touches the UI runtime (`runtime/clarus/ui*.cla`), `uiblob.cla`, the serdesc producers (`cprint.cla` `cpSerFieldRow`, `cg68k.cla` `cgBuildSerdescInts` ~l.4968) and a toolbox case. `cg68k.cla` is shared, but the regions are different.
- **Wave B:** Task 6 touches `check.cla`'s extern/callback/reg gates plus `ir.cla`'s `KWord` path. Task 7 touches `runtime/clarus/ser.cla` plus core ser cases. Task 8 touches the datetime/boxsize pair plus the `drive.cla`/`bake.cla` early lists. Disjoint.

The controller merges each wave in task order and runs T1 after every merge. Worktree setup: `git worktree add -b w3-tN ../clarus-w3-tN se-wave3-narrow-scalars`, then add absolute symlinks for `snow/ macplus/ macplus2/ vasm/` (to `/home/andrew/repos/clarus/<d>`), `Retro68` (to `/home/andrew/repos/Retro68`) and `toolchain` (to `/home/andrew/repos/Retro68-build/toolchain`).

---

### Task 1: Narrow types — front end and C lane (byte-identical for existing programs)

**Files:**
- Modify: `clarusc/types.cla` (`TyInt` ~l.34; `assignable` ~l.442, same-kind fallthrough ~l.495), `clarusc/check.cla` (`checkArith` ~l.5578, `checkUnary` ~l.5516, the conversions ~l.5990–6030, literal checks), `clarusc/ast.cla`/`clarusc/parse.cla` (the three type names; they are contextual identifiers, so read how `char`/`fixed` are spelled before choosing), `clarusc/ir.cla` (`KInt` ~l.98 tag in the aux field), `clarusc/lower.cla` (~l.402, 1280, 2186), `clarusc/cprint.cla` (`cpCType` ~l.940), `clarusc/bake.cla` (only if `IRType` field serialization needs the tag; it should already carry the `n` field)
- Modify: `docs/clarus-language-reference.md` (the scalar-types table; a new "Narrow integers" section), `docs/FUTURE.md` (`uint`, spec N7)
- Create: `testsuite/core/cases_narrow.cla`; modify `testsuite/core/runner.cla`, `tests/testsuite/core_cases.txt`, `tests/testsuite/core_cli.sh` (add the file to its list if it enumerates files), `tests/mactest/coregui_files.txt`, `tests/mactest/coresuite_68k.sh`, `tests/mactest/coresuite_mac.sh`, `CLAUDE.md` (core 85 → 86)
- Create: `testdata/errors/narrow_literal_range.cla` + `.expect`, `testdata/errors/narrow_assign_int.cla` + `.expect`, `testdata/errors/narrow_assign_cross.cla` + `.expect`

**Interfaces:**
- Produces (types.cla): `func tyIntWidth(t: int): int` (0 = `int`, else 8/16), `func tyIntSigned(t: int): bool`, `func tyNarrowRangeOk(t: int, v: int): bool`, and the interned type ids for `uint8`/`int16`/`uint16`. Give them names in the existing type-constructor style.
- Produces (ir.cla): `func irtIntWidth(t: int): int` and `func irtIntSigned(t: int): bool`, read by Tasks 3, 4 and 9. On the 68k lane, `cgSizeOf` of a narrow type is 1 or 2 bytes; Task 3 wires that. Task 1 must at least make the 68k lane **reject** a narrow type with a clear internal diagnostic (`narrow integer types are not yet supported by emit68k`), so that nothing silently miscompiles in between.
- Consumed by Task 4: `irtIntWidth`/`irtIntSigned` for field-type codes.

**Semantics (spec §3.1, N1, D4):**
- `uint8` 0..255, `int16` −32768..32767, `uint16` 0..65535.
- Narrow → `int` is implicit. `int` → narrow and narrow → a different narrow type are errors unless converted.
- Arithmetic, unary minus, `>>` and compares produce `int`.
- `uint8(x)`/`int16(x)`/`uint16(x)` accept `int`, `char` and any narrow type, and truncate. A conversion to the same type is an error, matching the existing identity-conversion rule and wording (`uint8() expects an int, char, int16 or uint16, got uint8`).
- `string(n)` accepts each narrow type.
- A literal at an N1 position adopts the narrow type when it is in range, and is an error otherwise.

- [ ] **Step 1: Write the failing tests.**

  (a) Create `testsuite/core/cases_narrow.cla`:

```
// cases_narrow.cla (SE wave 3): uint8/int16/uint16 semantics -- widening,
// 32-bit arithmetic, truncating conversions, literal adoption, storage.
record NarrowRec {
    a: uint8
    b: int16
    c: uint16
    n: int
}

var gU8: uint8
var gI16: int16

func narrowId16(x: int16): int16 {
    return x
}

func narrowRetU16(): uint16 {
    return 65535
}

func caseNarrowInts(): TestResult {
    var a: uint8
    var b: uint8
    var s: int16
    var u: uint16
    var r: NarrowRec
    var arr: uint16[3]
    var l: list of int16
    var i: int

    a = 200
    b = 100
    if a + b != 300 {
        return tkFail("NarrowInts", "uint8 sum did not widen")
    }
    s = -1
    u = 65535
    if s == u {
        return tkFail("NarrowInts", "int16 -1 equals uint16 65535")
    }
    if uint8(300) != 44 or int16(40000) != -25536 or uint16(-1) != 65535 {
        return tkFail("NarrowInts", "truncating conversion")
    }
    i = 70000
    if uint16(i) != 4464 {
        return tkFail("NarrowInts", "uint16 of int")
    }
    r.a = 255
    r.b = -32768
    r.c = 65535
    r.n = 7
    if r.a != 255 or r.b != -32768 or r.c != 65535 or r.n != 7 {
        return tkFail("NarrowInts", "record field round trip")
    }
    arr[0] = 0
    arr[2] = 65535
    if arr[2] != 65535 or arr[0] != 0 {
        return tkFail("NarrowInts", "array element round trip")
    }
    l.push(-32768)
    l.push(32767)
    if l[0] != -32768 or l[1] != 32767 {
        return tkFail("NarrowInts", "list element round trip")
    }
    gU8 = 255
    gI16 = -2
    if gU8 != 255 or gI16 != -2 {
        return tkFail("NarrowInts", "global round trip")
    }
    if narrowId16(-5) != -5 or narrowRetU16() != 65535 {
        return tkFail("NarrowInts", "param/return round trip")
    }
    if string(s) != "-1" or string(u) != "65535" {
        return tkFail("NarrowInts", "string() of narrow")
    }
    return tkPass("NarrowInts")
}
```

  Match the real API spellings (`push`, `l[0]`, `string(x)`, array syntax) against `cases_list.cla`/`cases_arr.cla`. Keep every assertion. Register `NarrowInts` exactly as Wave 2 registered `ReserveRemoveFirst`: the enum, name, `all`, dispatch, `nCoreCases` 85 → 86, and the other four places, plus the file lists.

  (b) The three error fixtures, in the style of `testdata/errors/int_conv_identity.cla` (a copyright header, then a comment line saying what it pins):
  - `narrow_literal_range.cla` holds `var x: uint8` then `x = 300`. Its `.expect` is `../../testdata/errors/narrow_literal_range.cla:L:C: 300 is out of range for uint8 (0..255)`.
  - `narrow_assign_int.cla` holds `var i: int` then `var x: int16` then `i = 5` then `x = i`. The `.expect` uses the checker's existing assignability wording for mismatched types; read how `assignable` failures are reported and reuse that message.
  - `narrow_assign_cross.cla` holds `var a: uint8` then `var b: int16` then `b = a`, with the same existing wording.

  Write each `.expect` by running the fixture once the implementation exists, then check by eye that the message is right. The checked-in `.expect` is the test.

- [ ] **Step 2: Run to verify failure.** `make test T='testsuite/core_cli'`. Expected: FAIL, because `uint8` is an unknown type.

- [ ] **Step 3: Implement** the representation, the checker rules, lower, and the C lane (`uint8_t`/`int16_t`/`uint16_t` from `cpCType`). Add the temporary emit68k rejection. Keep every existing type's encoding unchanged (tag 0).

- [ ] **Step 4: Document** the reference section and the FUTURE entry.

- [ ] **Step 5: Run.** `make test T='testsuite/ selfhost/diag lowlevel/ emitui/ bake/ reftest/'` and the identity check. Expected: all PASS, and no `DIFF` except an explained `DIFF clir` (none is expected: no runtime change).

- [ ] **Step 6: T1 and commit.**
```bash
git add clarusc/ docs/clarus-language-reference.md docs/FUTURE.md testsuite/core/ tests/ testdata/errors/narrow_* CLAUDE.md
git commit -m "feat(lang): uint8/int16/uint16 -- checker, IR, C lane (SE wave 3)"
```

---

### Task 2: Box-size lane pair — scaffolding (byte-identical)

**Files:**
- Create: `runtime/clarus/boxsize_c.cla`, `runtime/clarus/boxsize_68k.cla` (header comment only, spec §3.5 step 1), `tests/bake/boxsize.sh`
- Modify: `clarusc/bake.cla` (`bakeModuleList` ~l.413: add the pair right after `core.cla`, lane-selected like the datetime pair), `clarusc/drive.cla` (`driveManifestSplice` and `driveEarlySplice`: the same position, both lanes)

**Interfaces:**
- Produces: two always-spliced modules, early-visible on both lanes (they sit before `uidesc.cla`). Task 8 moves the constants into them after Task 5's regeneration.

- [ ] **Step 1:** Write `tests/bake/boxsize.sh` by copying `tests/bake/datetime.sh`'s `emit68k_pair` shape. Run it: it fails because the files do not exist.
- [ ] **Step 2:** Create the two files, each with a copyright header and a comment: "SE wave 3: container box-size constants (rtTextBoxSize ...). Empty until Task 8 moves them here from the datetime pair; see spec §3.5." Add them to the three module lists.
- [ ] **Step 3:** Run the identity check. `DIFF clir` is expected, because the CLIR manifest gains two entries; explain it. The per-program lines must show no DIFF. Then run `make test T='bake/ lowlevel/ mactest/dblcompile mactest/dblcompile_bake'` and `CLARUS_BAKE_FULL=1 make test T=bake/`. Expected: PASS.
- [ ] **Step 4:** T1, then commit: `feat(runtime): boxsize lane pair scaffolding (SE wave 3)`.

---

### Task 3: Narrow types — 68k codegen (byte-identical for existing programs)

Needs Task 1 merged.

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgSizeOfUncached` for a narrow int; `cgLoadVar` ~l.6760, `cgStoreScalarVar` ~l.6780, `cgLoadFieldScalar` ~l.6800, `cgEmitStoreScalarAny` ~l.6829, `cgPushArgs` ~l.10572, the return paths, `cgArrElemStride`, `cgRecFieldSizeOf`, `cgSlotSizeOf`, and the list/map element load/store paths). Remove Task 1's temporary rejection.
- Create: `testdata/cg68k/narrow.cla` plus its blessed `.s` golden (one new fixture; no existing golden moves)

**Interfaces:**
- Consumes: `irtIntWidth`/`irtIntSigned` (Task 1).
- Produces: `sz==2` load/store/push/return paths that Task 9 reuses for enums. Name the helpers `cgLoadSz2(signed: bool, ...)` etc. in the existing style, so Task 9 can call them with `signed = false`.

**Codegen rules (spec §3.1):**
- `uint8` uses the `char` paths.
- `int16` loads are `MOVE.W` then `EXT.L`.
- `uint16` loads clear the destination first (`MOVEQ #0,Dn`) and then `MOVE.W`. Alternatively, `MOVE.W` then `AND.L #$FFFF`: pick the shorter encoding and use it consistently.
- Stores are `MOVE.W`/`MOVE.B`.
- Arguments are pushed as longs. The callee reads a narrow parameter from its long slot, and the caller has already widened it.

- [ ] **Step 1:** Add `testdata/cg68k/narrow.cla`, a program exercising each storage class. Bless its golden with `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens` once the codegen exists. First confirm that `git status testdata/cg68k` shows only the two new files.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** Run the identity check (no DIFF), `make test T='cg68k/ bake/ asm68k/ testsuite/ lowlevel/'` (includes `lowlevel/boxsize68k`), and `CLARUS_BAKE_FULL=1 make test T=bake/`.
- [ ] **Step 4: Native proof** (the controlled boot): run the Global Constraints boot command. Expected: core 86/86 including `NarrowInts`, toolbox 40/40.
- [ ] **Step 5:** T1, then commit: `feat(cg68k): uint8/int16/uint16 codegen (SE wave 3)`.

---

### Task 4: Form binding for narrow fields and the new field-type codes (byte-identical for existing programs)

Needs Task 1 merged.

**Files:**
- Modify: `runtime/clarus/ser.cla` (add `RtFtU8: int = 6`, `RtFtI16: int = 7`, `RtFtU16: int = 8` after `RtFtEnum` ~l.103; only the constants here, Task 7 does the serializer), `runtime/clarus/uidesc.cla` (~l.64–67 shares the numbering), `clarusc/uiblob.cla` (`uibFieldTypeNum` ~l.282), `clarusc/cprint.cla` (`cpSerFieldRow`), `clarusc/cg68k.cla` (`cgBuildSerdescInts` ~l.4968), the UI runtime's bound-field validation (find it: `/usr/bin/grep -a -n 'RtFtInt' runtime/clarus/ui*.cla`), `clarusc/check.cla` (UI binding ~l.4155: accept narrow fields in a `field` and in a table `column`)
- Modify: `docs/clarus-language-reference.md` (the Type-Driven Widget Behavior table ~l.1219: one row for the narrow types, spec N3)
- Create: `testsuite/toolbox/cases_narrowform.cla`; modify `testsuite/toolbox/runner.cla` and the toolbox count's five places (40 → 41) and `tests/mactest/toolbox_files.txt`

**Interfaces:**
- Produces: the `RtFtU8`/`RtFtI16`/`RtFtU16` codes (6/7/8), emitted by all three producers for narrow fields. Task 7 consumes them in the serializer.

- [ ] **Step 1: The failing test.** Copy `cases_formedit.cla`'s harness shape into a case `NarrowForm`. It covers a form window over a record with `port: uint16`. Using the suite's `UiTest*` verbs, it types `70000` and presses OK (asserting the refusal), types `-1` and presses OK (refused), then types `8080` and presses OK (accepted, with the record's field equal to 8080). The refusal path must be the same one a non-numeric value takes. Assert the same observable signal `FormEdit` uses for the non-numeric case.
- [ ] **Step 2:** Implement the codes, the producers, the runtime range check (min/max per code; for the unsigned codes a leading `-` refuses), and the checker's acceptance. `column` shows the value as decimal.
- [ ] **Step 3:** Run the identity check (no DIFF: no existing program has a narrow field), `make test T='testsuite/ emitui/ bake/ lowlevel/'`, and the native boot command (toolbox 41/41, core 86/86).
- [ ] **Step 4:** T1, then commit: `feat(ui): narrow int fields in forms and tables; RtFt codes 6-8 (SE wave 3)`.

---

### Task 5: Snapshot regeneration (serialization point)

Needs Tasks 1–4 merged.

- [ ] **Step 1:** Run `make test T=selfhost/fixedpoint`, follow the recipe it prints, and re-run until it PASSes. Then run `make test T=selfhost/`: 6/6.
- [ ] **Step 2:** Probe: a scratch program declaring a `uint8` local and an `int16` global compiles with `cc -O1 -I runtime/host -o /tmp/claude-1000/w3t5/cc clarusc/clarusc.c runtime/host/rt.c`, then `/tmp/claude-1000/w3t5/cc emit ...`, with no diagnostics.
- [ ] **Step 3:** T1, then commit only `clarusc/clarusc.c`: `chore(clarusc): regenerate snapshot for narrow ints + boxsize modules (SE wave 3)`.

---

### Task 6: `int16`/`uint8` at extern, callback and `reg` positions (byte-identical)

Needs Task 5.

**Files:**
- Modify: `clarusc/check.cla` (the extern/callback gates ~l.2492–2525 and the `reg(...)` parameter-type check), `clarusc/ir.cla` (make `int16` → the `KWord` marshaling path and `uint8` → the `byte` path at extern positions, ~l.142–155), `clarusc/cprint.cla`/`cg68k.cla` only if their extern paths switch on `KWord` directly
- Modify: `docs/clarus-language-reference.md`, `docs/clarus-toolbox-cookbook.md` (the extern type lists name `int16`/`uint8` alongside `word`/`byte`; the removal comes in Task 12)
- Create: `testdata/lowlevel/extern_narrow.cla` (or a core/toolbox case if lowlevel has no extern shape)

**Semantics (D5, spec §3.2 step 1):**
- At an extern or callback argument, and at an `extern record` field store, an `int` value is accepted for a narrow slot and truncated.
- Marshaling is byte-for-byte what `word`/`byte` produce.

- [ ] **Step 1:** Write the test: an extern-declaring program using `int16`/`uint8` params compiles to the same `.bin` as the same program spelled with `word`/`byte`. `cmp` the two `emit68k` outputs, and the two `emit` outputs, in a new `tests/lowlevel/extern_narrow.sh`.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** Run the identity check (no DIFF), then `make test T='lowlevel/ testsuite/catalog testsuite/ cg68k/ bake/'`.
- [ ] **Step 4:** T1, then commit: `feat(lang): int16/uint8 accepted at extern/callback/reg positions (SE wave 3)`.

---

### Task 7: Serializer v2 framing and narrow fields (output-changing only for the version byte; the CLRD re-pin waits for Task 9)

Needs Task 5.

**Files:**
- Modify: `runtime/clarus/ser.cla` (`RtSerVersion` ~l.92; the header write ~l.270 and check ~l.512; the per-type read/write ~l.132–139, ~l.366–371)
- Modify: `testsuite/core/cases_ser.cla`, `runner.cla` and the five count places (86 → 87)
- Create: `testdata/sertest/frozen_v1_enum.dat` (Step 0)

**Design (spec §3.4, with the enum width left to Task 9):**
- `file.save` writes version byte **2**. `file.load` accepts 1 and 2.
- In this task the enum field stays 4 bytes on disk in both versions. Task 9 makes v2's enum 2 bytes, and keeps v1 reading 4.
- Narrow fields (`RtFtU8`/`RtFtI16`/`RtFtU16`) are written at 1/2/2 bytes and read back with their sign rule.
- **Is anything already pinned at version 1?** The CLRD goldens and `testdata/sertest/*.golden` were written by `file.save`, so the header byte in them moves 1 → 2 here. That is a deliberate re-pin. If the diff is exactly the version byte, do it in this task with `CLRD_BLESS=1`, in its own commit, with that reason. Task 9 re-pins again for the enum width. Otherwise, stop and report.

- [ ] **Step 0: Freeze a v1 file BEFORE changing `ser.cla`.** Any compiler reads `runtime/clarus/ser.cla` from disk, so once this task changes it, nothing writes v1 any more. On this task's unchanged base, build and run (with `host_build` or `scripts/clarus-run.sh`) a tiny host program. It declares `enum Color { Red, Green, Blue }` and `record V1Rec { kind: Color; n: int; name: string(8) }`, sets `{ kind = Blue, n = 42, name = "v1" }`, and calls `file.save`. Commit the file as `testdata/sertest/frozen_v1_enum.dat` in its own commit, `test(sertest): freeze a v1 file with an enum field (SE wave 3)`, recording its hex dump in the report. Task 9 loads it.
- [ ] **Step 1: The failing test.** Add a core case `SerNarrow`. It saves a record `{ a: uint8 = 255; b: int16 = -32768; c: uint16 = 65535; n: int = -7; s: string(10) = "x" }`, loads it, and checks every field. Then it reads the saved file with `file.readText` and asserts byte 4 (the version byte) is `2`.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** Run `make test T='testsuite/ sertest/ lowlevel/ bake/'`. For any CLRD or sertest golden that moves, confirm the diff is exactly the version byte and re-pin it in a separate commit with that reason. Run the identity check: `DIFF clir` is expected (the runtime changed), and the program lines must not DIFF for the four examples. Bookmarks uses `file.save`, but the change is runtime data behavior, not codegen; if bookmarks' `.bin` differs, explain why.
- [ ] **Step 4:** T1, then commit(s): `feat(ser): format v2 header, narrow field widths (SE wave 3)` and, if needed, `test(sertest): re-pin CLRD goldens for version byte 2 (SE wave 3)`.

---

### Task 8: Move the box-size constants into their lane pair (byte-identical)

Needs Task 5 (the snapshot must know the boxsize modules).

**Files:**
- Modify: `runtime/clarus/boxsize_c.cla`, `boxsize_68k.cla` (receive the four `rt*BoxSize` constants and their explanation), `runtime/clarus/datetime_c.cla`, `datetime_68k.cla` (lose them; restore the headers' pre-Wave-2 wording about when the pair is spliced)
- Modify: `clarusc/drive.cla`, `clarusc/bake.cla` (revert Wave 2 Task 9's host early-set widening: the host early-visible list ends after `uidialogs.cla` again, and `uitest.cla`'s host position in `bakeModuleList` moves back to match; the boxsize pair stays early on both lanes). Keep Wave 2 Task 9's fix for the empty-remainder uitest drop if it is still reachable; if it is not, say so.
- Modify: `tests/lowlevel/boxsize68k.sh` (read `boxsize_68k.cla`), `CLAUDE.md` (`--testapi` paragraph), `docs/TODO.md` (close the datetime-pair entry)

- [ ] **Step 1:** Run `tests/lowlevel/boxsize68k.sh` after pointing it at `boxsize_68k.cla`. Expected FAIL: the constant is not there yet.
- [ ] **Step 2:** Move the constants and revert the early set.
- [ ] **Step 3:** Run the identity check (no DIFF, including clir if the constants' declaration order in the CLIR doesn't matter; if clir differs, explain), then `make test T='lowlevel/ bake/ testsuite/ emitui/'` and `CLARUS_BAKE_FULL=1 make test T=bake/`. The host `--testapi` suite builds must be byte-identical to before; the full-corpus testapi scripts pin that.
- [ ] **Step 4:** T1, then commit: `refactor(runtime): box sizes live in the boxsize pair; host early set restored (SE wave 3)`.

---

### Task 9: Enums are 2 bytes on both lanes; serializer v2 enum width; CLRD re-pin (output-changing; alone)

Needs Wave B merged.

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgSizeOfUncached` `KEnum` ~l.1939 → 2; the comment ~l.4876; enum loads through Task 3's `sz==2` helpers with `signed = false`)
- Modify: `clarusc/cprint.cla` (the record-layout and element-type paths, `cpEmitLayouts` ~l.6801–6867, and list/map element sizes: an enum field or element is `int16_t`; `cpCType`'s `KEnum` ~l.943 stays `int32_t` for locals, params, globals and returns, per spec N8)
- Modify: `runtime/clarus/ser.cla` (v2 writes and reads a 2-byte enum; v1 reads 4 and narrows), the in-memory enum width in the serializer's field walk (2 on both lanes)
- Create: the core case that loads `testdata/sertest/frozen_v1_enum.dat` (frozen by Task 7 Step 0)
- Rebless: `testdata/cg68k/*.s`, the emitui goldens of programs with enum fields, the CLRD goldens (`CLRD_BLESS=1`), and the bake twins if they pin bytes

- [ ] **Step 1:** Confirm that Task 7 committed `testdata/sertest/frozen_v1_enum.dat` (a true v1 file).
- [ ] **Step 2: The failing tests.**
  - Add a core case `SerV1Enum` that `file.load`s `frozen_v1_enum.dat` into that record type and checks `kind == Blue`, `n == 42` and `name == "v1"`. This needs the file on the Mac boot volume for the native boot: add it to whatever mechanism ships the existing sertest data, or embed its bytes with `text.append` and write it first.
  - Add a core case `EnumStorage` covering an enum as a `list` element, a `map` value, a fixed-array element, and a field of a record inside a `list of record`. It also checks `file.save`/`file.load` of a record with an enum at v2.
  - The count goes 87 → 89.
- [ ] **Step 3: Implement** both lanes and the serializer.
- [ ] **Step 4: Rebless.** For each family that moves, run its bless variable, inspect one representative diff by hand, and commit it separately with the reason:
  - cg68k: enum field offsets and sizes, word loads;
  - emitui: `int16_t` enum fields;
  - CLRD: 2-byte enum fields in v2.

  Anything else moving is a bug: stop.
- [ ] **Step 5:** Run `make test T='testsuite/ sertest/ emitui/ cg68k/ bake/ lowlevel/ selfhost/diag'`, `CLARUS_BAKE_FULL=1 make test T=bake/`, and the native boot (core 89/89, toolbox 41/41).
- [ ] **Step 6:** T1, then commits: `feat(lang): enums are 2 bytes on both lanes; serializer v2 enum width (SE wave 3)`, plus one rebless commit per family.

---

### Task 10: Snapshot regeneration, then compiler arenas group their enum fields (byte-identical)

Needs Task 9.

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated, own commit), `clarusc/ir.cla` (`IRExpr` ~l.325, `IRStmt` ~l.315, `IRType` ~l.308), `clarusc/asm68k.cla` (`A68Item` ~l.180)

- [ ] **Step 1:** Regenerate as in Task 5, so that the compiler itself is built with 2-byte enums. `selfhost/` must be 6/6. Commit `clarusc/clarusc.c` alone.
- [ ] **Step 2: Measure before:** `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla`, plus the memgate peaks.
- [ ] **Step 3:** Reorder each record so that its 2-byte fields (enums) are adjacent. For `IRExpr`: `kind`, `convOp`, then the `int` fields, then the two `bool`s. `bool` is `int32_t` on the C lane, so it doesn't pack; say whether a `uint8` for `global`/`argCopy` would save more, and do it only if the census shows it. Audit for positional record literals or anything depending on field order: `/usr/bin/grep -a -n 'IRExpr{\|IRStmt{\|IRType{\|A68Item{' clarusc/*.cla`, plus the bake field-by-field serializers, which must not change.
- [ ] **Step 4: Measure after.** The target is `bookmarks_rtbake` ≤ 3,670,016. Run the identity check (no DIFF; the CLIR bytes are unchanged, because bake serializes by field), `make test T='cg68k/ bake/ memgate/ mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`.
- [ ] **Step 5:** T1, then commit: `perf(clarusc): group 2-byte enum fields in the IR/asm arenas (SE wave 3)`.

---

### Task 11: Rename `word` → `int16`, `byte` → `uint8` (byte-identical except ClarusC.APPL's baked source)

Needs Task 10 (the snapshot knows `int16`/`uint8` at extern positions from Tasks 6 and 10).

**Files:** every `.cla` under `runtime/clarus/`, `toolbox/`, `clarusc/`, `testsuite/`, `examples/` and `testdata/` that spells the extern type `word` or `byte`; `docs/clarus-language-reference.md`; `docs/clarus-toolbox-cookbook.md`; `CLAUDE.md`; the diagnostic fixtures in `testdata/errors/` whose expected text names the type.

- [ ] **Step 1: Inventory.** Match `word`/`byte` only in **type position**: `: word`, `: byte`, `-> word`, `): word`, `word[`, and `reg(... )` parameter lists. The words appear in prose, identifiers (`wordAt`, `bytes`) and comments too. Produce the list with `/usr/bin/grep -a -n -E '(:|->|\)) *(word|byte)\b' ...` and review it before editing. Write the inventory into the report.
- [ ] **Step 2:** Rename. A `haiku` batch edit from the reviewed inventory is fine.
- [ ] **Step 3:** Run the identity check. Every program line must show no DIFF; `DIFF clir` is expected (the baked runtime/toolbox source text changed). Then `make test T='testsuite/ cg68k/ bake/ lowlevel/ selfhost/diag reftest/ emitui/'` and `CLARUS_BAKE_FULL=1 make test T=bake/`. For any `testdata/errors/*.expect` that changes, the diff must be exactly the type spelling.
- [ ] **Step 4:** T1, then commit: `refactor: rename extern types word->int16, byte->uint8 (SE wave 3)`.

---

### Task 12: Remove `word`/`byte` (byte-identical)

Needs Task 11.

**Files:** `clarusc/ast.cla` (`TxWord`/`TxByte` ~l.292–315), `clarusc/parse.cla` (~l.1359/1682), `clarusc/check.cla` (~l.2492–2525), `clarusc/ir.cla` (`KWord`, if it now has no producer other than `int16` at extern positions: keep the marshaling path and drop only the old spelling), `docs/clarus-language-reference.md` (no `word`/`byte` type left), `testdata/errors/extern_word_removed.cla` + `.expect` (the old spelling now fails as an unknown type).

- [ ] **Step 1:** Write the failing fixture (`x: word` in an extern parameter) and its expected unknown-type diagnostic, using the checker's existing unknown-type wording.
- [ ] **Step 2:** Remove the spellings. Confirm that `/usr/bin/grep -a -n -E '(:|->|\)) *(word|byte)\b' runtime/ toolbox/ clarusc/*.cla testsuite/ examples/ testdata/ docs/` finds nothing but prose.
- [ ] **Step 3:** Run the identity check (no DIFF, `rt.clir` included), then `make test T='selfhost/diag testsuite/ bake/ lowlevel/'`.
- [ ] **Step 4:** T1, then commit: `feat(lang)!: remove the word/byte type spellings (SE wave 3)`.

---

### Task 13: Final snapshot regeneration, ratchet, census (serialization point)

Needs Tasks 1–12.

- [ ] **Step 1:** Regenerate as in Task 5. Run `make test T=selfhost/`: 6/6.
- [ ] **Step 2:** Run `make test T=memgate/` three times; the peaks must be identical. Set each budget to `int(P * 1.01) + 1`, never above the current value. Add a change-log line: `# 2026-09-28 wave 3: narrow ints, 2-byte enums both lanes, arena field grouping. Measured peaks <P1> / <P2> / <P3> + 1%.` If `bookmarks_rtbake` > 3,670,016, commit the measured value anyway and put the `--at-peak` census in the report.
- [ ] **Step 3:** T1, then commit `clarusc/clarusc.c` and `tests/memgate/budget.txt`: `test(memgate): ratchet to wave 3 peaks; regenerate snapshot (SE wave 3)`.

---

### Task 14: IIcx re-measure, docs, end-of-wave gates (controller-driven)

Needs Task 13.

**Files:**
- `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`:
  - D7's row notes N8's revision (enums 2 bytes on both lanes);
  - §5.5 row 3;
  - §9 status;
  - a new "Wave 3 measurements" subsection.
- The wave spec's status line.
- `docs/ROADMAP.md`, `docs/HISTORY.md` (a Wave 3 entry with the `<T2 result>`/`<clarusc_bake result>` placeholders and every ledger `Ruling:` with its cost), `docs/TODO.md`.

- [ ] **Step 1:** The IIcx measurement (subagent):
  ```sh
  export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
  CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_memprobe
  cp build-run/tests/mactest/snow/clarusc_memprobe.log build-run/memprobe-saved/clarusc_memprobe.wave3.log
  ```
  Expected: 5/5. Record the numbers side by side with Wave 2 (launch→low 6272 KB, stack 187 KB, parse span 2m01s, 32,864 ticks).
- [ ] **Step 2:** The docs (subagent). Tables must have aligned columns.
- [ ] **Step 3:** The gates (controller):
  ```sh
  scripts/test-merge.sh
  CLARUS_SNOW_TESTS=1 make test T='mactest/snow/clarusc_bake mactest/snow/macresident_failed_compile'
  ```
  Fill in the HISTORY placeholders.
- [ ] **Step 4:** The final whole-branch review (Opus), one fix wave, a scoped re-review, then report to Andrew. Do not merge.
