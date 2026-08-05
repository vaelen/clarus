# Small-Scalar Width Unification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `bool` and `char` occupy 1 byte in every aggregate (ordinary records, arrays, extern records) on both lanes; locals/params keep 2-byte slots; trap boundaries unchanged.

**Architecture:** One atomic ABI flip across the two codegen layout authorities (cg68k record/array rules, cprint C-struct field rules) and every runtime reader of bool record fields (Clarus-side `peekl`/`pokel` sites, host C `rt_ser.inc`), pinned before and after by a new serializer round-trip case and the existing popuptable/layout-assert/uisnaps regression nets. The on-disk `.clrs` format already stores bool as 1 byte — only in-memory widths change.

**Tech Stack:** Clarus (clarusc self-hosted compiler), C host runtime, Go test harnesses, Retro68/Mini vMac for gated lanes.

**Spec:** `docs/superpowers/specs/2026-08-05-small-scalar-width-design.md`

## Global Constraints

- Branch: `small-scalar-width` (already created; all commits go here).
- After every task: `scripts/test-task.sh` (T1); add `--smoke` for tasks touching `runtime/` or `clarusc/` (Tasks 2, 3). Full `scripts/test-merge.sh` (T2) only in Task 5.
- **MacRoman hazard:** before editing ANY `.cla`/`.inc` file, run `LC_ALL=C grep -nP '[\x80-\xFF]' <file>`. If it hits anywhere near your edit region, use `LC_ALL=C sed` byte-safe edits + byte-diff verification instead of the Edit tool (see `docs/ROADMAP.md` conventions; the Edit tool corrupts MacRoman bytes).
- Line numbers below are as of branch point `fc8c3dd`. Function names are the real anchors — re-grep if lines drifted.
- The frozen UI goldens (`testdata/uisnaps`) must remain **byte-identical** throughout. Never re-bless them. If they change, the task has a bug.
- Emitted-C / 68k-listing goldens (internal/cg68k, internal/emitui, internal/selfhost crossgen) are EXPECTED to change in Task 2 and are re-blessed there — each failing test names its own bless env var in its failure message.

---

### Task 1: Regression pin — `SerMixedScalarRec` core case

**Files:**
- Modify: `testsuite/core/cases_ser.cla` (append case + record decl)
- Modify: `testsuite/core/runner.cla` (enum member, `coreCaseName` arm, `coreAllCases` entry, dispatch arm, `nCoreCases` 41→42)

**Interfaces:**
- Produces: `CoreTest.SerMixedScalarRec`, `caseSerMixedScalarRec(): TestResult`, record `MixedScalarRec` — Task 2 relies on this case staying green across the flip; Task 4 updates the documented case counts.

- [ ] **Step 1: Write the case (green today — it pins behavior, the ABI flip must not break it)**

Append to `testsuite/core/cases_ser.cla` (field order deliberately interleaves 1-byte and word-sized kinds so the post-flip layout has odd offsets):

```
record MixedScalarRec {
    a: char
    b: bool
    c: int
    d: char
    e: string(5)
    f: bool
    g: fixed
}

func caseSerMixedScalarRec(): TestResult {
    var r: MixedScalarRec
    var r2: MixedScalarRec
    var ok: bool

    r.a = char(7)
    r.b = true
    r.c = -123456
    r.d = char(255)
    r.e = "hey"
    r.f = false
    r.g = 2.5
    ok = file.save("core_mixed_scalar.dat", r)
    if not ok {
        return tkFail("SerMixedScalarRec", "save failed")
    }
    ok = file.load("core_mixed_scalar.dat", r2)
    if not ok {
        return tkFail("SerMixedScalarRec", "load failed")
    }
    if r2.a != char(7) {
        return tkFail("SerMixedScalarRec", "a (char) wrong")
    }
    if not r2.b {
        return tkFail("SerMixedScalarRec", "b (bool true) wrong")
    }
    if r2.c != -123456 {
        return tkFail("SerMixedScalarRec", "c (int) wrong")
    }
    if r2.d != char(255) {
        return tkFail("SerMixedScalarRec", "d (char 255) wrong")
    }
    if r2.e != "hey" {
        return tkFail("SerMixedScalarRec", "e (str) wrong")
    }
    if r2.f {
        return tkFail("SerMixedScalarRec", "f (bool false) wrong")
    }
    if r2.g != 2.5 {
        return tkFail("SerMixedScalarRec", "g (fixed) wrong")
    }
    return tkPass("SerMixedScalarRec")
}
```

Match the file's existing header comment style (add a `SerMixedScalarRec` line to the case→source table; source is "new for small-scalar-width phase, no legacy fixture"). If `fixed` literal syntax differs from `2.5`, mirror whatever `cases_*.cla`'s `FixedMathOps` uses.

- [ ] **Step 2: Register in the runner**

In `testsuite/core/runner.cla`: add `SerMixedScalarRec` to the `CoreTest` enum (after `SerFileNameRoundtrip`, keeping the ser family together); add a `coreCaseName` arm returning `"SerMixedScalarRec"`; add it to `coreAllCases()`; add the dispatch arm calling `caseSerMixedScalarRec()`; bump `nCoreCases` (documented as "CoreTest's member count minus All") from 41 to 42. Update the file-header count comment and `SelfCheck`'s expectations if they hardcode 40/41 (SelfCheck asserts `casesRun == nCoreCases - 1`; if `nCoreCases` is maintained correctly the assert adapts).

- [ ] **Step 3: Run the core suite on host, verify 42 cases pass**

```sh
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
```

Expected: all PASS including `SerMixedScalarRec` and `SelfCheck`, exit 0.

- [ ] **Step 4: Run T1**

Run: `scripts/test-task.sh`
Expected: green (`internal/mactest/suite_host_test.go`'s `coreCLIHostFiles` file list is glob-based over `cases_*.cla`, so no Go change should be needed — if a hardcoded case count fails there, update it).

- [ ] **Step 5: Commit**

```bash
git add testsuite/core/cases_ser.cla testsuite/core/runner.cla
git commit -m "test(core): SerMixedScalarRec pin for small-scalar width flip"
```

---

### Task 2: The ABI flip — 1-byte bool/char aggregates, both lanes

This task is deliberately atomic: the two codegen authorities and every runtime reader describe ONE layout and must change together. A partial application is a heap-corruption bug (see the Task-10 form-accept story in `clarusc/cprint.cla:731`'s comment).

**Files:**
- Modify: `clarusc/cg68k.cla` (cgRecFieldSizeOf :977, cgRecFieldAlignOf :987, cgArrElemStride :948, cgRecordCtorAt ~:1737, comment blocks :60-86, :955-976)
- Modify: `clarusc/cprint.cla` (cpEmitRecords ~:4457, array typedef :903, cpCSizeOfField :755, cpCAlignOfField :768, comment block :728-754)
- Modify: `runtime/clarus/ser.cla` (:123-128 comment, :137 peekl, :381-388 pokel)
- Modify: `runtime/clarus/uidialogs.cla` (:454 peekl, :582-584 pokel, surrounding comments)
- Modify: `runtime/clarus/uitable.cla` (:418 peekl, :34 comment)
- Modify: `runtime/host/rt_ser.inc` (:70-79 save arm, :213-225 load arm)
- Modify: `runtime/host/rt_ser_test.c` (fixture struct + header comment)

**Interfaces:**
- Consumes: Task 1's `SerMixedScalarRec` (must stay green).
- Produces: the unified layout rule every later task documents/verifies. New helper `cpRecFieldCType(t: int): string` in cprint.cla.

- [ ] **Step 1: cg68k layout authorities**

In `clarusc/cg68k.cla`:

`cgRecFieldSizeOf` / `cgRecFieldAlignOf` — bool/char become 1/1:

```
func cgRecFieldSizeOf(t: int): int {
    var k: IRKind

    k = irtKind(t)
    if k == KBool or k == KChar {
        return 1
    }
    return cgSlotSizeOf(t)
}

func cgRecFieldAlignOf(t: int): int {
    var k: IRKind

    k = irtKind(t)
    if k == KBool or k == KChar {
        return 1
    }
    return cgAlignOf(t)
}
```

`cgArrElemStride` — `KBool` joins the packed branch:

```
func cgArrElemStride(elemT: int): int {
    var k: IRKind

    k = irtKind(elemT)
    if k == KChar or k == KBool {
        return 1
    }
    return cgSlotSizeOf(elemT)
}
```

`cgRecordCtorAt` — delete the `if ftk == KBool or ftk == KChar { a68Emit(OpClr, 4, ...) }` block entirely (the slot is now exactly the 1 byte every write path already writes; there are no other 3 bytes to keep zero). Remove `ftk`/its assignment if now unused.

Rewrite the stale comments — they are load-bearing documentation, not decoration: the file-header "TASK 14 EXCEPTION" block (:77-86), the layout-divergence note (:60-75), cgRecFieldSizeOf's doc comment (:955-976), cgArrElemStride's char-only framing (:919-947 — bool now packs too), and cgRecordCtorAt's CLR.L paragraph. New story to tell: bool/char are 1 byte in every aggregate on both lanes (small-scalar-width phase, 2026-08-05); cgRecFieldSizeOf/AlignOf remain the record-field authority but no longer diverge from packed sizes for bool/char; locals/params still get cgSlotSizeOf's 2-byte slots; the historical Task-14 4-byte rule and its popuptable bug stay as a one-line historical note pointing at the spec.

- [ ] **Step 2: cprint C-lane authorities**

In `clarusc/cprint.cla`:

Add next to `cpCTypeName`:

```
// cpRecFieldCType: the C type of a clar_rec_<T> STRUCT FIELD. Identical to
// cpCType except bool, which is uint8_t as a record field (small-scalar-
// width phase: 1 byte in every aggregate, both lanes) while staying
// int32_t as a local/param/global.
func cpRecFieldCType(t: int): string {
    if irtKind(t) == KBool {
        return "uint8_t"
    }
    return cpCType(t)
}
```

In `cpEmitRecords`' field loop (~:4457), change `cpCType(irFieldSlotType(f))` → `cpRecFieldCType(irFieldSlotType(f))`.

Array typedef (:903): bool element arrays pack too:

```
cpRecBuf.add(toText("typedef struct { " + cpArrElemCTypeName(irtElem(t)) + " e[" + numToStr(irtN(t)) + "]; } " + name + ";"))
```

with

```
// cpArrElemCTypeName: array-element C type -- bool packs as uint8_t
// (matching cg68k's 1-byte stride), everything else is cpCTypeName.
func cpArrElemCTypeName(t: int): string {
    if irtKind(t) == KBool {
        return "uint8_t"
    }
    return cpCTypeName(t)
}
```

`cpCSizeOfField` (:755): move `KBool` out of the fall-through-4 into the 1-byte return alongside `KChar`. `cpCAlignOfField` (:768): `KBool` returns 1 alongside `KChar`/`KStr`. Rewrite the authority comment block (:728-754) to the new rule (bool field = uint8_t = 1 byte; the rt.h descriptor ABI reads 1 byte; keep the Task-10 heap-corruption story as history).

- [ ] **Step 3: Clarus-side runtime readers**

`runtime/clarus/ser.cla`: `:137` `v = peekl(p)` → `v = peekb(p)`; read side `:381-388` both `pokel(p, 1)`/`pokel(p, 0)` → `pokeb(p, 1)`/`pokeb(p, 0)`; rewrite the `:123-128` doc comment ("BOOL's in-memory field is 1 byte at the field's base address on both lanes — endian-neutral; disk byte unchanged").

`runtime/clarus/uidialogs.cla`: `:454` `v = peekl(base)` → `v = peekb(base)` (comment: `// bool: 1 byte at base, both lanes`); form-accept writeback `:582`/`:584` `pokel(base, 1)`/`pokel(base, 0)` → `pokeb(...)`. Update the file's big layout comment (~:499-520, the "a bool field is a full int32_t there" paragraph) to the new rule. Do NOT touch `:461`/`:598-600` — those are enum fields, still int32.

`runtime/clarus/uitable.cla`: `:418` `v = peekl(base)` → `v = peekb(base)`; drop its "int32, not a raw byte" comment; update the `:26-45` header paragraph's bool sentence. Do NOT touch `:406`/`:412`/`:431` (int/fixed/enum arms).

- [ ] **Step 4: Host C runtime**

`runtime/host/rt_ser.inc` save arm (:70-79) becomes:

```c
    case RT_FT_BOOL:
        /* bool's emitted C field type is uint8_t (small-scalar-width phase)
           -- one byte at the field's base address, endian-neutral. */
        rt_text_append_char(out, (uint8_t)(*p != 0 ? 1 : 0));
        break;
```

load arm (:213-225) becomes:

```c
    case RT_FT_BOOL: {
        uint8_t b;
        b = ser_get_byte(r);
        if (!r->bad) *p = (uint8_t)(b != 0 ? 1 : 0);
        break;
    }
```

`runtime/host/rt_ser_test.c`: change the fixture struct's `flag` field from `int32_t` to `uint8_t` and fix the header comment (:11-16). Offsets use `offsetof` so they self-adjust.

- [ ] **Step 5: Sweep for stragglers**

```sh
grep -rn "full int32\|int32, not a raw byte\|4-byte slot" clarusc/ runtime/ testsuite/ | grep -vi "enum\|fixed\|historical"
grep -rn "peekl\|pokel" runtime/clarus/ | grep -i "bool"
```

Expected: zero live-code hits for bool-as-int32; anything left is either enum/int/fixed (correct) or a comment you rewrite now. Also grep `clarusc/uiblob.cla` for the `:551-565` divergence comment and rewrite it (the authorities now agree for bool/char; the native/cprint authority split machinery stays).

- [ ] **Step 6: Rebuild the host compiler and run the core suite (Task 1's pin)**

Same four commands as Task 1 Step 3. Expected: 42/42 PASS. This proves compiler + ser + host runtime agree on the new layout.

- [ ] **Step 7: Re-bless the emitted-code goldens**

Run: `go test ./internal/cg68k ./internal/emitui ./internal/testsuite -count=1` — failures are EXPECTED (listings/emitted C changed). Re-bless with each test's own env var (named in its failure output, e.g. `CLARUS_CG68K_BLESS=1`), then re-run to green. Inspect the cg68k golden diff before committing: field offsets shrink, `CLR.L` disappears from record ctors, byte ops replace long ops on bool fields — anything ELSE changing is a red flag.

- [ ] **Step 8: T1 with smoke**

Run: `scripts/test-task.sh --smoke`
Expected: green, including the two emulator smoke boots. `internal/sertest` (`.clrd` byte-compare) must be green WITHOUT re-blessing — the disk format didn't change; if it fails, Step 3/4 broke canonicalization.

- [ ] **Step 9: Commit**

```bash
git add clarusc/cg68k.cla clarusc/cprint.cla clarusc/uiblob.cla runtime/clarus/ser.cla runtime/clarus/uidialogs.cla runtime/clarus/uitable.cla runtime/host/rt_ser.inc runtime/host/rt_ser_test.c internal/cg68k/testdata internal/emitui internal/testsuite
git commit -m "feat: bool/char occupy 1 byte in all aggregates, both lanes"
```

(Adjust the golden paths to wherever the blessed files actually live.)

---

### Task 3: Native verification — gated suites, alignment eyeball, uisnaps untouched

**Files:**
- No source changes expected. Read-only verification + possibly small fixes if it finds real bugs (escalate to the coordinator if a fix touches layout logic).

**Interfaces:**
- Consumes: Task 2's flip. Produces: evidence log for the phase wrap (paste key results into the task report).

- [ ] **Step 1: Gated suite boots, both lanes**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestCoreSuiteGUIOnMac|TestToolboxSuiteOn68k|TestToolboxSuiteOnMac' -count=1 -timeout 20m`
Expected: PASS — 42 core subtests and 21 toolbox subtests per lane. The popuptable bool-column case (`cases_popuptable.cla`, `favorite: bool`) is the original Task-14 regression running against the NEW 1-byte layout end-to-end.

- [ ] **Step 2: Odd-offset alignment eyeball (Mini vMac does not model 68000 address errors — green tests do NOT prove this)**

Build a listing for a mixed record and inspect every access to it:

```sh
scripts/build-68k.sh AlignProbe /tmp/alignprobe.cla   # write a tiny program: declare MixedScalarRec (copy from Task 1), set+read every field, log results
```

In the generated listing (`build-68k/` `.lst` or the golden from `internal/cg68k`): verify (a) `char`/`bool` fields are accessed with **byte**-width ops (`MOVE.B`/`TST.B`) at their packed offsets, (b) every `.W`/`.L` access (the `int`/`fixed` fields) lands on an EVEN offset — `cgAlignUp` must have padded after the odd-sized fields, (c) record total size is even. Report the actual field offset table in the task report. If any word/long op has an odd base: STOP, report — that is a real-hardware address error.

- [ ] **Step 3: Frozen UI goldens byte-identical**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestUIScenarios|TestNative' -count=1 -timeout 30m` (whatever test names cover the 11 surviving `testdata/ui` scenarios — grep `internal/mactest/ui_test.go`/`native_test.go` for the actual `-run` names first).
Expected: PASS with `testdata/uisnaps` untouched (`git status --short testdata/uisnaps` prints nothing).

- [ ] **Step 4: Commit (only if fixes were needed; otherwise no commit — report evidence)**

---

### Task 4: Documentation — reference, ROADMAP, counts

**Files:**
- Modify: `docs/clarus-language-reference.md` (Ch3 type table + notes, Ch13 layout statements)
- Modify: `docs/ROADMAP.md` (close 2b, cookbook input note)
- Modify: `CLAUDE.md` (core-suite counts 41→42)

**Interfaces:**
- Consumes: the shipped rule from Task 2 and the offset evidence from Task 3.

- [ ] **Step 1: Reference Ch3**

In the Chapter 3 type table (~:148-167) `bool` and `char` rows: keep "1 byte" and make it true by adding a Storage note under the table (mirror the chapter's existing note style):

```
Storage: `bool` and `char` occupy exactly 1 byte inside every aggregate --
ordinary records, arrays, and extern records -- on every target. As a
standalone local, parameter, or global they occupy a 2-byte slot (68000
even-address alignment). At `external func`/`trap` boundaries the Chapter
13 marshaling rules apply (a bool/char parameter or result travels in a
16-bit stack word).
```

- [ ] **Step 2: Reference Ch13**

Near the extern-record palette table (~:1432-1441), add the ordinary-record packing statement: record fields pack at their 1-byte (bool/char/str) or 2-byte-aligned (int/fixed/ptr/enum/text/handle kinds) natural sizes in declaration order, with word-sized fields padded to even offsets and total record size rounded to even; array elements of `bool`/`char` pack at stride 1. State that both code generators implement this same rule (the per-lane record layouts coincide for these kinds; layouts are still never cross-used between lanes).

- [ ] **Step 3: ROADMAP**

Close item 2b (~:1086-1101): mark **DONE (2026-08-05, small-scalar-width phase)** with the outcome: kept all four types; `bool`/`char` = 1 byte in all aggregates both lanes; `byte` stays extern-record-contextual; `text` documented as the binary buffer type; spec + plan paths. In item 3 (cookbook, ~:1102-1113) add the settled mapping inputs: Boolean→`bool` (1 byte), SignedByte/Byte→`byte`, CharParameter→`word` (never `char` — the MenuKey lesson, `cases_events.cla`), and the bit-11 trap-table rule already noted there.

- [ ] **Step 4: CLAUDE.md counts**

Update "41 `CoreTest` cases: 40 real + `SelfCheck`" → "42 `CoreTest` cases: 41 real + `SelfCheck`" (and the same numbers anywhere else CLAUDE.md states them).

- [ ] **Step 5: T1, commit**

```bash
scripts/test-task.sh
git add docs/clarus-language-reference.md docs/ROADMAP.md CLAUDE.md
git commit -m "docs: small-scalar width rule in reference; close ROADMAP 2b"
```

---

### Task 5: Snapshot regeneration + T2 merge gate

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)

**Interfaces:**
- Consumes: everything prior. Produces: a merge-ready branch.

- [ ] **Step 1: Regenerate the bootstrap snapshot**

The flip changes clarusc's own emitted C, so the committed snapshot is stale. Run: `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m` — if it fails it PRINTS the Go-free regeneration procedure; follow it exactly (build from the old snapshot, emit `clarusc/main.cla`, iterate to the fixed point), then re-run to green.

- [ ] **Step 2: Full T2**

Run: `scripts/test-merge.sh`
Expected: green — T1 body + `internal/selfhost` (30m timeout) + full gated `internal/mactest`. Confirm `git status --short testdata/uisnaps` is still empty.

- [ ] **Step 3: Commit**

```bash
git add clarusc/clarusc.c
git commit -m "chore: regenerate clarusc.c snapshot for 1-byte small-scalar aggregates"
```

Do NOT merge to main — merging is Andrew's call (report ready-to-merge instead).

---

## Self-review notes (spec coverage)

- Spec "cg68k changes" → Task 2 Step 1. "cprint changes" → Step 2. "Host C runtime" → Step 4. "Clarus runtime readers / six contract sites" → Steps 3+5. "Serializer format" → corrected: disk format already 1 byte (rt_ser.inc:70-79 canonicalizes); only in-memory reads change — Task 2 Step 8's sertest check proves it. "Bootstrap" → Task 5. "Spec/docs" → Task 4. "New core case" → Task 1. "Existing pins" → Tasks 2 (Step 6) and 3 (Steps 1, 3). "Goldens re-bless + eyeball" → Task 2 Step 7 + Task 3 Step 2. "Hardcoded-offset grep" → Task 2 Step 5.
