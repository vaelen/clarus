# string(n) Record-Field Layout Convergence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the cprint lane give `string(n)` record fields 2-byte alignment and even-rounded size, matching cg68k's existing rule, so every offset in a str-bearing record coincides across the two Mac lanes.

**Architecture:** Three coordinated cprint-side changes that must land together: (1) the `clar_str_n` typedef gains a trailing pad byte when `n+1` is odd, (2) the C-ABI layout model (`cpCAlignOfField`/`cpCSizeOfField`) flips `KStr` to align 2 / even size, (3) `cpEmitRecords` emits explicit `uint8_t` pad members so the real struct realizes the model on both m68k GCC and host cc. cg68k is untouched. Spec: `docs/superpowers/specs/2026-08-06-strn-field-alignment-design.md`.

**Tech Stack:** Clarus (clarusc self-hosted compiler), C host runtime, Go test harnesses.

## Global Constraints

- Feature branch: `strn-field-alignment` off `main` (create in Task 1; CLAUDE.md: feature branch per plan, merge only on request).
- `.cla` files may contain MacRoman bytes that the Edit tool corrupts. Before editing any `.cla` region, run `LC_ALL=C grep -n '[^[:print:][:space:]]' <file>` on the lines you will touch; all regions this plan edits are plain ASCII (verified), so Edit is safe — but check before any edit you improvise.
- After ANY `clarusc/*.cla` change, the committed snapshot `clarusc/clarusc.c` is stale until regenerated (Task 1 Step 7); `internal/selfhost`'s `TestSnapshotFixedPoint` enforces this. Never hand-edit `clarusc/clarusc.c`.
- T1 gate: `scripts/test-task.sh --smoke` (this plan touches `clarusc/`, so `--smoke` is required per CLAUDE.md).
- Background context an implementer needs: the numeric layout model (`cpCFieldOffset`/`cpCRecordSize`) is consumed ONLY by (a) the cprint-lane uiblob (`clarusc/uiblob.cla:571` `uibEmitLayout`, `uibNativeLane == false` branch) and (b) `cpEmitUiLayoutAsserts` (`clarusc/cprint.cla:4816`), which emits a C compile-time assert pinning model offsets/size against the real struct for every UI-bound record. Runtime ser/UI descriptors use literal `offsetof`/`sizeof` expressions and are always self-consistent. The native lane's blob uses `cgRecordSize`/`cgFieldOffset` (`uibNativeLane == true`) and is untouched.

---

### Task 1: cprint layout convergence + sertest proof + snapshot regen

**Files:**
- Modify: `clarusc/cprint.cla` (`cpEnsureStr` ~:891, `cpCSizeOfField` ~:788, `cpCAlignOfField` ~:799, new helpers after `cpCAlignOfField`, `cpEmitRecords` struct loop ~:4485)
- Modify: `testdata/sertest/roundtrip.cla`, `testdata/sertest/roundtrip.out.golden`
- Create: `testdata/sertest/padprobe.bytes.golden`
- Modify: `internal/sertest/sertest_test.go` (`TestRoundtrip`, add second bytes compare)
- Modify: `clarusc/clarusc.c` (regenerated, never hand-edited)

**Interfaces:**
- Consumes: `cgAlignUp(n, align)` (`clarusc/cg68k.cla:1009`), `irtKind`/`irtN`/`irtElem`/`irtName`, `cgFindRecordByName`, `irRecordLayoutFieldsHead`/`irFieldSlotType`/`irFieldSlotNext`, `cpCRecordSize` — all existing.
- Produces: `cpFieldCParity(t: int): int`, `cpFieldCAlign1(t: int): bool`, `cpRecCAlign1(nameIdx: int): bool` in `cprint.cla` (used only by `cpEmitRecords`; Task 2 has no code dependency on them).

- [ ] **Step 1: Create the branch**

```bash
git checkout -b strn-field-alignment
```

- [ ] **Step 2: Extend the sertest fixture with an odd-parity record (regression guard, green before AND after)**

In `testdata/sertest/roundtrip.cla`, add after the `Bookmark` record declaration:

```
// PadProbe: the odd-parity shape from the 2026-08-06 strn-field-alignment
// spec -- a string(n) field after an odd bool run, and a bool after the
// odd-sized (pre-padding) string. Pins that struct-internal pad bytes
// never leak into the on-disk format (padprobe.bytes.golden) and that the
// emitted rt_field_desc offsets agree with the padded struct at runtime.
record PadProbe {
    pre:  bool
    s:    string(2)
    post: bool
}

func padProbesEqual(a: PadProbe, b: PadProbe): bool {
    var ok: bool

    ok = a.pre == b.pre
    ok = ok and a.s == b.s
    ok = ok and a.post == b.post
    return ok
}
```

In `on App.startCLI`, declare two more locals alongside the existing ones:

```
    var probe1: PadProbe
    var probe2: PadProbe
```

and add this block immediately before the `// ---- load failure` section:

```
    // ---- odd-parity record: pad.dat is the second byte-exact golden ----
    probe1.pre = true
    probe1.s = "AB"
    probe1.post = true

    ok = file.save("pad.dat", probe1)
    if ok {
        alert("pad save ok")
    } else {
        alert("pad save FAIL")
    }

    ok = file.load("pad.dat", probe2)
    if ok and padProbesEqual(probe1, probe2) {
        alert("pad roundtrip ok")
    } else {
        alert("pad roundtrip FAIL")
    }
```

- [ ] **Step 3: Update the goldens and the Go harness**

Insert the two new lines into `testdata/sertest/roundtrip.out.golden` before the `missing-file` line, so the file reads:

```
rec save ok
rec roundtrip ok
list save ok
list roundtrip ok
map save ok
map roundtrip ok
pad save ok
pad roundtrip ok
missing-file load returns false ok
```

Create `testdata/sertest/padprobe.bytes.golden` — exactly these 11 bytes (header `CLRS`, version 1, container `RT_SER_REC` = 0, then pre=1, str len=2 + `AB` with strCap 2 fully used, post=1):

```bash
printf '\x43\x4c\x52\x53\x01\x00\x01\x02\x41\x42\x01' > testdata/sertest/padprobe.bytes.golden
xxd testdata/sertest/padprobe.bytes.golden
# expect: 434c 5253 0100 0102 4142 01
```

In `internal/sertest/sertest_test.go`, `TestRoundtrip`, after the existing `rec.dat` bytes comparison block, add:

```go
	gotPad, err := os.ReadFile(filepath.Join(runDir, "pad.dat"))
	if err != nil {
		t.Fatalf("read pad.dat: %v", err)
	}
	wantPad, err := os.ReadFile(filepath.Join(root, "testdata", "sertest", "padprobe.bytes.golden"))
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(gotPad, wantPad) {
		t.Errorf("pad.dat bytes mismatch\ngot:  % x\nwant: % x", gotPad, wantPad)
	}
```

- [ ] **Step 4: Run sertest — must pass on the UNCHANGED compiler (baseline: format is layout-independent)**

```bash
go test ./internal/sertest -count=1 -run TestRoundtrip
```

Expected: PASS. Also capture the pre-change struct shape (the red half of this task's red/green):

```bash
build-run/clarusc emit -o /tmp/rt_pre.c testdata/sertest/roundtrip.cla 2>/dev/null \
  || (cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c \
      && build-run/clarusc emit -o /tmp/rt_pre.c testdata/sertest/roundtrip.cla)
grep -n 'clar_str_2\b' /tmp/rt_pre.c | head -2
grep -n -A5 'clar_rec_PadProbe' /tmp/rt_pre.c | head -8
```

Expected pre-change: `typedef struct { uint8_t len; uint8_t b[2]; } clar_str_2;` (no pad) and a `clar_rec_PadProbe` struct with exactly three `cv_` members, no `clar_pad` members.

- [ ] **Step 5: Commit the fixture baseline**

```bash
git add testdata/sertest/roundtrip.cla testdata/sertest/roundtrip.out.golden testdata/sertest/padprobe.bytes.golden internal/sertest/sertest_test.go
git commit -m "test(sertest): odd-parity PadProbe record fixture + second bytes golden"
```

- [ ] **Step 6: Implement the cprint changes**

All in `clarusc/cprint.cla`.

**(a) `cpEnsureStr` (~:891):** pad `clar_str_n` to even size when `n+1` is odd. Replace the single `cpTypeBuf.add(...)` line with:

```
    if (n + 1) mod 2 != 0 {
        // strn-field-alignment (2026-08-06): pad the typedef to even size
        // so sizeof(clar_str_N) matches cgSlotSizeOf's even-rounded slot --
        // record-field tails and array-of-string strides then coincide with
        // the native lane. len/b keep their offsets; nothing consumes
        // sizeof semantically (runtime str calls pass the cap; rt_ser.inc
        // writes 1+strCap bytes).
        cpTypeBuf.add(toText("typedef struct { uint8_t len; uint8_t b[" + key + "]; uint8_t clar_pad; } clar_str_" + key + ";"))
    } else {
        cpTypeBuf.add(toText("typedef struct { uint8_t len; uint8_t b[" + key + "]; } clar_str_" + key + ";"))
    }
```

**(b) `cpCSizeOfField` (~:788):** change the `KStr` arm from `return irtN(t) + 1` to:

```
    if k == KStr {
        return cgAlignUp(irtN(t) + 1, 2)
    }
```

**(c) `cpCAlignOfField` (~:799):** remove `KStr` from the align-1 arm:

```
    if k == KChar or k == KBool {
        return 1
    }
    return 2
```

Update the big doc comment above `cpCSizeOfField` (~:751-795): the `string(n)` sentence becomes "…`string(n)` is `clar_str_n` = `struct { uint8_t len; uint8_t b[n]; }`, padded with a trailing byte to even size when n+1 is odd (n+1 rounded up to even bytes, 2-byte aligned via cpEmitRecords' explicit pad members — the strn-field-alignment phase, 2026-08-06, matching cg68k's cgRecFieldSizeOf/cgRecFieldAlignOf)."

**(d) New helpers**, inserted directly after `cpCAlignOfField`:

```
// cpFieldCParity: the parity (0 or 1) a field of type t contributes to the
// emitted clar_rec_ struct's running C byte offset -- cpEmitRecords' pad
// walk only (strn-field-alignment, 2026-08-06). Exact for every
// serializable/UI-descriptor kind plus bool/char arrays and all-byte
// nested records; an array-bearing nested record falls back on
// cpCRecordSize's approximation (such offsets have no consumer -- see
// cpCSizeOfField's six-kinds note above).
func cpFieldCParity(t: int): int {
    var k: IRKind

    k = irtKind(t)
    if k == KBool or k == KChar {
        return 1
    }
    if k == KStr {
        return 0
    }
    if k == KArr {
        return (irtN(t) * cpFieldCParity(irtElem(t))) mod 2
    }
    if k == KRec {
        return cpCRecordSize(irtName(t)) mod 2
    }
    return 0
}

// cpFieldCAlign1 reports whether a field of type t is a C-align-1 member
// of the emitted struct (all-uint8_t storage: bool/char, clar_str_N, byte
// arrays, all-byte nested records). Anything else the C compiler
// self-aligns at >= 2, which re-evens the running offset on its own.
func cpFieldCAlign1(t: int): bool {
    var k: IRKind

    k = irtKind(t)
    if k == KBool or k == KChar or k == KStr {
        return true
    }
    if k == KArr {
        return cpFieldCAlign1(irtElem(t))
    }
    if k == KRec {
        return cpRecCAlign1(irtName(t))
    }
    return false
}

// cpRecCAlign1: does clar_rec_<nameIdx> consist solely of C-align-1
// members (so the struct's own C alignment is 1)?
func cpRecCAlign1(nameIdx: int): bool {
    var ri: int
    var f: int

    ri = cgFindRecordByName(nameIdx)
    if ri == -1 {
        return false
    }
    f = irRecordLayoutFieldsHead(ri)
    while f != -1 {
        if not cpFieldCAlign1(irFieldSlotType(f)) {
            return false
        }
        f = irFieldSlotNext(f)
    }
    return true
}
```

**(e) `cpEmitRecords` struct loop (~:4485):** replace

```
        cpRecBuf.add(toText("typedef struct {"))
        f = irRecordLayoutFieldsHead(i)
        while f != -1 {
            cpRecBuf.add(toText("    " + cpRecFieldCType(irFieldSlotType(f)) + " cv_" + poolGet(irFieldSlotName(f)) + ";"))
            f = irFieldSlotNext(f)
        }
        cpRecBuf.add(toText("} " + ctype + ";"))
```

with (new locals `t2: int`, `parity: int`, `padN: int`, `anyAlign2: bool` added to `cpEmitRecords`' var block — do not shadow the existing `f`/`i`/`j`):

```
        // strn-field-alignment (2026-08-06): explicit pad members realize
        // the documented packing rule (reference Ch13, "Ordinary record
        // packing") on both m68k GCC and host cc -- a pad byte before a
        // string(n) field whose running offset is odd, and a trailing pad
        // when the model total is odd and the model maxAlign is 2,
        // mirroring cpCFieldOffset/cpCRecordSize exactly so
        // cpEmitUiLayoutAsserts' model-vs-offsetof pin stays true. Pads
        // are never IR fields: the ctor loop below, ARC walks, and
        // descriptor emission all iterate IR fields and skip them.
        cpRecBuf.add(toText("typedef struct {"))
        parity = 0
        padN = 0
        anyAlign2 = false
        f = irRecordLayoutFieldsHead(i)
        while f != -1 {
            t2 = irFieldSlotType(f)
            if cpFieldCAlign1(t2) {
                if irtKind(t2) == KStr and parity != 0 {
                    cpRecBuf.add(toText("    uint8_t clar_pad" + numToStr(padN) + ";"))
                    padN = padN + 1
                    parity = 0
                }
                parity = (parity + cpFieldCParity(t2)) mod 2
            } else {
                parity = 0
            }
            if cpCAlignOfField(t2) >= 2 {
                anyAlign2 = true
            }
            cpRecBuf.add(toText("    " + cpRecFieldCType(t2) + " cv_" + poolGet(irFieldSlotName(f)) + ";"))
            f = irFieldSlotNext(f)
        }
        if parity != 0 and anyAlign2 {
            cpRecBuf.add(toText("    uint8_t clar_pad" + numToStr(padN) + ";"))
        }
        cpRecBuf.add(toText("} " + ctype + ";"))
```

- [ ] **Step 7: Regenerate the snapshot (Go-free, from the old snapshot) and verify the green half**

```bash
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```

Then re-emit the fixture with the NEW compiler and check the struct shape:

```bash
cc -O1 -I runtime/host -o /tmp/newc clarusc/clarusc.c runtime/host/rt.c
/tmp/newc emit -o /tmp/rt_post.c testdata/sertest/roundtrip.cla
grep -n 'clar_str_2\b' /tmp/rt_post.c | head -2
grep -n -A6 'clar_rec_PadProbe' /tmp/rt_post.c | head -9
```

Expected post-change: `typedef struct { uint8_t len; uint8_t b[2]; uint8_t clar_pad; } clar_str_2;` and `clar_rec_PadProbe` = `{ cv_pre; clar_pad0; cv_s; cv_post; clar_pad1; }` (member order exactly: `uint8_t cv_pre;`, `uint8_t clar_pad0;`, `clar_str_2 cv_s;`, `uint8_t cv_post;`, `uint8_t clar_pad1;` — offsets 0/1/2/6/7, sizeof 8). `clar_str_63` (Bookmark) must be UNCHANGED (63+1 = 64, even — no pad), and `clar_rec_Bookmark` must contain no `clar_pad` members.

- [ ] **Step 8: Run the focused tests**

```bash
go test ./internal/sertest -count=1
go test ./internal/hostrt ./internal/emitui -count=1
```

Expected: PASS (sertest proves runtime descriptors against the padded struct; the pad.dat golden proves pads never reach the disk format).

- [ ] **Step 9: Run T1 with smoke**

```bash
scripts/test-task.sh --smoke
```

Expected: PASS (includes the two native-68k emulator smoke tests; cg68k is untouched, so failures here mean the cprint change leaked somewhere unexpected — stop and investigate, do not paper over).

- [ ] **Step 10: Commit**

```bash
git add clarusc/cprint.cla clarusc/clarusc.c
git commit -m "fix(cprint): string(n) record fields align 2 / even size, matching cg68k

clar_str_n typedef padded to even size when n+1 is odd; cpCAlignOfField/
cpCSizeOfField KStr arms flipped to the documented Ch13 packing rule;
cpEmitRecords emits explicit clar_pad members (before an odd-offset
string(n) field, and trailing when the rounded model total exceeds the
member sum) so real offsetof/sizeof match the model on both m68k GCC and
host cc. Closes the small-scalar-width Task 4 cross-lane divergence:
str-bearing record offsets now coincide across the two Mac lanes."
```

### Task 2: Reference + ROADMAP updates

**Files:**
- Modify: `docs/clarus-language-reference.md` (Ch3 storage table row ~:155; Ch13 "Ordinary `record` packing" paragraph ~:1447)
- Modify: `docs/ROADMAP.md` ("Small open items": close the `string(n)` divergence entry ~:1582; append one new sibling entry)

**Interfaces:**
- Consumes: nothing from Task 1's code — text only. Task 1 must already be merged into the branch so wording describes shipped behavior.
- Produces: nothing consumed downstream.

- [ ] **Step 1: Ch3 storage table row (~:155)**

Change the `string(n)` row's notes cell from:

`length-prefixed Pascal string, n ≤ 255; `string` alone = `string(255)``

to:

`length-prefixed Pascal string, n ≤ 255; `string` alone = `string(255)`; inside an aggregate it occupies n+1 rounded up to even bytes (Ch13 packing rule)`

- [ ] **Step 2: Ch13 packing paragraph (~:1447)**

In the "**Ordinary `record` packing:**" paragraph, make two edits.

(1) After the sentence fragment "…packs at 2-byte alignment (a degenerate 1-byte `T[n]` — `bool[1]`/`char[1]` — packs at 1-byte alignment instead, same as a bare `bool`/`char` field), in declaration order…" — immediately after the closing parenthesis and before ", in declaration order", insert nothing; instead add this new sentence directly after the sentence ending "…rounded up to even the same way.":

`A `string(n)` field additionally occupies its even-rounded size — n+1 rounded up to even bytes — so the field after it starts on an even offset on every lane.`

(2) Change the clause "Both code generators (`cg68k` and the host-C `cprint` lane) implement this rule for `bool`/`char`, the one place this phase changed the layout, so the two lanes' record layouts now coincide for those two kinds" to:

`Both code generators (`cg68k` and the host-C `cprint` lane) implement this rule for `bool`/`char` (small-scalar-width phase) and for `string(n)` fields' 2-byte alignment and even-rounded size (strn-field-alignment phase, 2026-08-06 — the C lane realizes it with explicit pad members and an even-padded `clar_str_n` typedef), so the two lanes' record layouts coincide for those kinds`

Keep the trailing "; per-lane layouts are still never interchangeable…" clause exactly as it stands (it remains true: `char[n]` array fields and all-byte record totals still diverge — the ROADMAP sibling item added below).

- [ ] **Step 3: ROADMAP edits**

In `docs/ROADMAP.md` "Small open items", replace the entire `**Cross-lane `string(n)` record-field alignment divergence…**` bullet with:

```
- **Cross-lane `string(n)` record-field alignment divergence: DONE** —
  fixed on branch `strn-field-alignment` (2026-08-06): the cprint lane now
  gives a `string(n)` record field 2-byte alignment and even-rounded size
  (even-padded `clar_str_n` typedef + explicit `clar_pad` struct members),
  matching cg68k, so str-bearing record offsets coincide across the two
  Mac lanes. Spec:
  `docs/superpowers/specs/2026-08-06-strn-field-alignment-design.md`.
```

Then append this new bullet directly after it:

```
- **Remaining odd-C-size record-layout divergences (filed 2026-08-06,
  strn-field-alignment spec Out-of-scope):** the same divergence family
  the `string(n)` fix closed still exists for the other odd-C-sized field
  kinds — `char[n]`/`bool[n]` array fields with odd n (cg68k even-rounds
  the field slot, `char[3]` occupies 4 with 2-byte alignment; C packs at
  exact size, natural alignment 1), the degenerate `char[1]`/`bool[1]`
  case (where cg68k's even-rounded 2-byte slot arguably contradicts the
  reference's "packs at 1-byte alignment, same as a bare bool/char field"
  sentence — decide reference wording vs `cgSlotSizeOf` before fixing),
  and all-byte records (odd C `sizeof`, unrounded, struct alignment 1 —
  diverging from cg68k's even-rounded `cgRecordSize` in total size,
  nested-record field offset, and array-of-record stride). Same root
  cause, rarer shapes, offsets never consumed cross-lane (latent). Note
  the `string(n)` fix's pad walk already converges a `string(n)` field
  that FOLLOWS one of these shapes; only non-str fields after them, and
  the totals themselves, still diverge.
```

- [ ] **Step 4: Verify doc-only diff and commit**

```bash
git diff --stat   # expect exactly the two docs files
git add docs/clarus-language-reference.md docs/ROADMAP.md
git commit -m "docs: string(n) even-rounded aggregate size in reference; close ROADMAP strn divergence, file siblings"
```

---

## Post-plan gates (top-level session, not a task subagent)

- Whole-branch final review (most capable model, per CLAUDE.md conventions).
- T2 before merge: `scripts/test-merge.sh` (runs `internal/selfhost` incl. `TestSnapshotFixedPoint`, plus the full gated `internal/mactest` — the Mac-lane suites exercise the cprint-lane uiblob model offsets against the real padded structs live; `cpEmitUiLayoutAsserts`' compile-time pin makes any model/struct drift a build failure there).
- Merge only on Andrew's request.
