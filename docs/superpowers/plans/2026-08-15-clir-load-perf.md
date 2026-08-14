# CLIR Load Performance (A+B+C) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cut ClarusC.APPL's baked-runtime load window (verify + parse) from ~10 minutes to seconds on first compile, and to ~zero on repeat compiles in the same session.

**Architecture:** Three independent changes, landed in order: (A) a consume-once flag drops the redundant second body-hash verify; (C) four new bulk range-read `text` methods (`hashStep`/`u32At`/`stringAt`/`textAt`) move the per-byte loops inside the runtime, plus a djb2 hash swap under a CLIR v6→v7 format bump; (B) parse-once-per-session memoization with copy-on-install to break the pending/live arena aliasing.

**Tech Stack:** Clarus (compiler `clarusc/*.cla`, runtime `runtime/clarus/*.cla`), Go test harness (`internal/mactest`, gated emulator lanes), Retro68/Mini vMac for native boots.

**Spec:** `docs/superpowers/specs/2026-08-15-clir-load-perf-design.md` — read it first; every task below argues from it.

## Global Constraints

- Branch: all work on `clir-load-perf` (created in Task 1 from `main`). Merge only on Andrew's explicit request; `main` stays green.
- After every task: `scripts/test-task.sh --smoke` (T1 + the two emulator smoke tests — every task here touches `runtime/` or `clarusc/`, so `--smoke` is mandatory per CLAUDE.md).
- All `.cla` edits in this plan are ASCII-only. If you ever must touch a MacRoman-encoded `.cla` (none are expected here), do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (see the project memory rule).
- `internal/selfhost` is never run at T1; when run (final gate), always `-count=1 -timeout 30m`.
- Go tests always `-count=1` (stale-`.cla`-fixture cache hazard, CLAUDE.md).
- Emulator-gated tests need `CLARUS_MAC_TESTS=1`; Snow-gated tests (`CLARUS_SNOW_TESTS=1`) are NOT run per-task — they run once at phase close with Andrew's go-ahead.
- Commit after every task (small, task-scoped commits; message prefix `feat:`/`fix:`/`test:`/`docs:` as appropriate).
- The frozen-scenario/emitui goldens must NOT churn: unused new runtime functions are removed by the shake pass, so emitted output for programs that don't use the new methods stays byte-identical. If any golden churns, STOP and investigate — do not rebless.

## File map (who owns what)

- `clarusc/bake.cla` — format version, hash function, load-path readers, verify flag, parse memo flag, copy-on-install (Tasks 1, 4, 5, 6, 7).
- `clarusc/macgui.cla` — `gcResolveBakePath` flag-arming + memo skip + buffer free (Tasks 1, 7).
- `clarusc/drive.cla` — `driveReset` defensive reset; `bkLoadRtbake` gate (Tasks 1, 7).
- `runtime/clarus/text.cla` — `rtTextHashStep`, `rtTextU32At`, `rtTextStringAt`, `rtTextTextAt` (Task 2).
- `clarusc/check.cla`, `clarusc/lower.cla`, `clarusc/ir.cla`, `clarusc/cprint.cla` — host-lane method plumbing (Task 2).
- `clarusc/cg68k.cla` — native-lane intrinsic arms (Task 3).
- `testsuite/core/` — new `cases_textrange.cla` + runner registration (Task 2).
- `testdata/run/` — panic-contract fixtures (Task 2).
- `internal/mactest/snow_test.go` — one-line log assertion for B (Task 8).
- `docs/clarus-language-reference.md` — Chapter 3 text-operations additions (Task 2).
- `docs/ROADMAP.md`, `STATUS.md` — close-out (Task 10).

---

### Task 1: Branch + Design A (skip the redundant verify)

**Files:**
- Modify: `clarusc/bake.cla` (new global near `bkLoadPos`/`bkLoadOverrun`, ~line 1850s; consume in `bkLoadRtbake`, line 3547)
- Modify: `clarusc/macgui.cla` (`gcResolveBakePath`, line 494)
- Modify: `clarusc/drive.cla` (`driveReset`'s defensive-reset block, lines 515–551)

**Interfaces:**
- Produces: `bkHeaderVerified: bool` (bake.cla module global). Contract: set ONLY immediately after a successful `bkCheckRtbakeHeader` on the very buffer about to be passed to `bkLoadRtbake`; consumed (read + reset to false) by `bkLoadRtbake`; defensively reset in `driveReset`.

- [ ] **Step 1: Create the branch**

```bash
git checkout -b clir-load-perf main
```

- [ ] **Step 2: Add the flag and consume it**

In `clarusc/bake.cla`, next to the other loader globals (`bkLoadBuf`/`bkLoadPos`/`bkLoadOverrun`):

```
// bkHeaderVerified (clir-load-perf Task 1, design A): set by a front
// end (macgui's gcResolveBakePath) immediately after ITS successful
// bkCheckRtbakeHeader on the exact buffer it then hands to
// driveCompile as rtbakeBytes -- bkLoadRtbake consumes it (read +
// reset) to skip re-hashing ~1.3MB it verified seconds earlier.
// Consume-once: never survives past one bkLoadRtbake call, so a stale
// value can never bless a different buffer. Host front ends never set
// it, so the host's single verify (inside bkLoadRtbake) is unchanged.
var bkHeaderVerified: bool
```

In `bkLoadRtbake` (line 3547), replace the unconditional check:

```
    if bkHeaderVerified {
        // Design A: the front end already verified THIS buffer.
        // Re-establish the parse preconditions bkCheckRtbakeHeader
        // normally leaves behind (cursor past the 19-byte header,
        // overrun flag clear), without the ~1.3MB body re-hash.
        bkHeaderVerified = false
        bkLoadOverrun = false
        bkLoadBuf = buf
        bkLoadPos = 19
    } else {
        if not bkCheckRtbakeHeader(buf, wantLane) {
            return false
        }
    }
```

CAREFUL: read `bkCheckRtbakeHeader` (line 3478) first and confirm the exact post-state it leaves (`bkLoadBuf`, `bkLoadPos` = position after the 19-byte header, `bkLoadOverrun`) — the skip arm must reproduce it exactly. Header is magic(4)+version(4)+lane(1)+stampLen(2)+stamp(4)+bodyHash(4) = 19 bytes.

- [ ] **Step 3: Arm the flag in macgui**

In `gcResolveBakePath` (macgui.cla:521), right after the successful header check (i.e., after the `if not bkCheckRtbakeHeader(...)` early-return, next to `haveRtbake = true`):

```
    bkHeaderVerified = true
```

- [ ] **Step 4: Defensive reset in driveReset**

At the end of the drive.cla:515–551 defensive-reset block, following its established comment style:

```
    // clir-load-perf Task 1: defensive reset, same rationale as the
    // resets above -- bkHeaderVerified is consume-once inside
    // bkLoadRtbake, so this is a no-op on the ordinary sequence; it
    // exists so a future aborted/reordered front-end path can never
    // leave a stale "verified" blessing for a buffer that was not.
    bkHeaderVerified = false
```

Note ordering (verified in design): `gcCompile` calls `driveReset()` BEFORE `gcResolveBakePath()`, so the reset cannot clobber the freshly-armed flag.

- [ ] **Step 5: Run T1 + smoke**

Run: `scripts/test-task.sh --smoke`
Expected: PASS (no behavior change on host — nothing sets the flag on host; native smoke tests don't exercise the Mac-resident front end).

- [ ] **Step 6: Commit**

```bash
git add clarusc/bake.cla clarusc/macgui.cla clarusc/drive.cla
git commit -m "feat: skip bkLoadRtbake's redundant body-hash re-verify when the front end just verified the same buffer (design A)"
```

---

### Task 2: Design C host lane — four bulk `text` methods end to end (runtime, checker, lowering, cprint, tests, reference)

**Files:**
- Modify: `runtime/clarus/text.cla` (four new functions; mirror `rtTextSlice`/`rtTextCompare` idioms)
- Modify: `clarusc/check.cla` (`buildMethodTables`, ~line 1433: four `textOnlyMethods` entries)
- Modify: `clarusc/ir.cla` (four intrinsic-name accessors; mirror `ITextIndex`, line 3366)
- Modify: `clarusc/lower.cla` (method lowering; mirror the `indexOf`/`append` text-method arms around lines 1696–1720)
- Modify: `clarusc/cprint.cla` (route the four intrinsics to `clar_fn_rtText*`; mirror how `text_index` routes under `cpTextPorted`)
- Create: `testsuite/core/cases_textrange.cla` + register in `testsuite/core/runner.cla` (hand-maintained enum + dispatch — read the runner's header comment)
- Create: `testdata/run/textrange_oor.cla` + `.err` golden, `testdata/run/stringat_cap.cla` + `.err` golden (panic contracts; follow any existing `testdata/run` fixture + golden pair as the template)
- Modify: `docs/clarus-language-reference.md` (Chapter 3, text operations — four new entries)

**Interfaces:**
- Produces (language surface):
  - `t.hashStep(h: int, pos: int, n: int): int` — rolling hash over bytes `[pos, pos+n)`: per byte `h = ((h << 5) + h + b) & 0x7FFFFFFF`. Returns updated `h`.
  - `t.u32At(pos: int): int` — big-endian U32 at `pos`.
  - `t.stringAt(pos: int): string` — reads a 4-byte BE length `L` at `pos`, then `L` bytes; returns them as a `string`. Caller advances `4 + result.length`. Panics if `L > 255` ("string too long") or the range is out of bounds.
  - `t.textAt(pos: int, n: int): text` — fresh `text` holding bytes `[pos, pos+n)`.
  - ALL bounds violations panic with the existing STRICT convention (same message style as `rtTextIndex`'s "text index out of range"; pick messages and keep them consistent between lanes — the runtime is shared, so this is automatic).
- Produces (runtime): `rtTextHashStep(t, h, pos, n)`, `rtTextU32At(t, pos)`, `rtTextStringAt(t, pos)`, `rtTextTextAt(t, pos, n)` in text.cla — Task 3 emits native calls to these exact names.
- Produces (intrinsic names): `text_hash_step`, `text_u32_at`, `text_string_at`, `text_text_at` (ir.cla accessors `ITextHashStep()`, `ITextU32At()`, `ITextStringAt()`, `ITextTextAt()`) — Task 3's cg68k arms match on these.

- [ ] **Step 1: Write the failing core-suite case**

Read `testsuite/core/runner.cla`'s header comment for the registration procedure (enum member + dispatch arm + case count), then create `testsuite/core/cases_textrange.cla` following the style of an existing small `cases_*.cla` file:

```
// cases_textrange.cla: Chapter 3 bulk range reads (clir-load-perf
// Task 2): hashStep/u32At/stringAt/textAt known-answer + edge cases.
func tkCaseTextRange(): bool {
    var t: text
    var h: int
    var i: int
    var s: string
    var sub: text
    var ok: bool

    ok = true
    t = ""
    t.append(char(1))
    t.append(char(2))
    t.append(char(3))
    t.append(char(4))
    // u32At: BE compose
    ok = ok and tkExpectInt("u32At", t.u32At(0), 16909060) // 0x01020304
    // hashStep vs hand loop, split across a chunk boundary
    h = 5381
    i = 0
    while i < t.length {
        h = ((h << 5) + h + int(t[i])) & 0x7FFFFFFF
        i = i + 1
    }
    ok = ok and tkExpectInt("hashStep whole", t.hashStep(5381, 0, 4), h)
    ok = ok and tkExpectInt("hashStep split", t.hashStep(t.hashStep(5381, 0, 2), 2, 2), h)
    // hashStep n=0 is identity
    ok = ok and tkExpectInt("hashStep empty", t.hashStep(99, 1, 0), 99)
    // stringAt: 4-byte BE length prefix + payload
    t = ""
    t.append(char(0))
    t.append(char(0))
    t.append(char(0))
    t.append(char(2))
    t.append('h')
    t.append('i')
    s = t.stringAt(0)
    ok = ok and tkExpectStr("stringAt", s, "hi")
    // textAt: fresh copy, zero-length allowed
    sub = t.textAt(4, 2)
    ok = ok and tkExpectInt("textAt len", sub.length, 2)
    ok = ok and tkExpectInt("textAt b0", int(sub[0]), int('h'))
    sub = t.textAt(6, 0)
    ok = ok and tkExpectInt("textAt empty", sub.length, 0)
    return ok
}
```

Adjust helper names (`tkExpectInt`/`tkExpectStr`) to whatever `testsuite/kit.cla` actually provides — read it; do not invent helpers.

- [ ] **Step 2: Run the host core suite to verify it fails**

Compose recipe (CLAUDE.md; the exact file list lives in `internal/mactest/suite_host_test.go`'s `coreCLIHostFiles` — add the new cases file THERE too, it is consumed by the gated suite tests):

```bash
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
```

Expected: FAIL at check time — `hashStep` is not a known text method. (You are bootstrapping from the committed snapshot, which predates your compiler edits — that is correct and expected; the snapshot's checker is what rejects the new method. After Step 4 you must rebuild the CURRENT compiler from source to test: `build-run/clarusc emit` the current `clarusc/*.cla` into a fresh host binary first. Read `scripts/clarus-run.sh` and `internal/selfhost`'s bootstrap notes if this two-stage dance is unclear.)

- [ ] **Step 3: Runtime implementations**

In `runtime/clarus/text.cla`, after `rtTextSlice` (read `rtTextIndex` at :509, `rtTextFromBytes` at :537, and `rtTextSlice` first — mirror their overlay/deref/panic idioms exactly). The shapes:

```
// rtTextHashStep (clir-load-perf Task 2): rolling 31-bit shift-add
// hash (djb2 shape, bake.cla's bkHashTextFrom body-hash convention)
// over bytes [pos, pos+n). STRICT bounds (rtTextIndex convention).
// Hoists len + master pointer ONCE -- this loop is the whole point:
// per-byte cost is peekb + shifts, not a call.  Allocates nothing, so
// holding mp across the loop is safe (relocation discipline, header
// comment).
func rtTextHashStep(t: ptr, h: int, pos: int, n: int): int {
    var rt: RtText
    var mp: ptr
    var i: int
    var b: int

    rt = RtText(t)
    if pos < 0 or n < 0 or pos + n > rt.len {
        rtPanic("text index out of range")
    }
    mp = TextHandleDeref(rt.h)
    i = 0
    while i < n {
        b = peekb(mp + pos + i)
        h = ((h << 5) + h + b) & 0x7FFFFFFF
        i = i + 1
    }
    return h
}

func rtTextU32At(t: ptr, pos: int): int {
    var rt: RtText
    var mp: ptr

    rt = RtText(t)
    if pos < 0 or pos + 4 > rt.len {
        rtPanic("text index out of range")
    }
    mp = TextHandleDeref(rt.h)
    return (peekb(mp + pos) << 24) | (peekb(mp + pos + 1) << 16) | (peekb(mp + pos + 2) << 8) | peekb(mp + pos + 3)
}
```

`rtTextStringAt(t, pos): string` — read the U32 length via the same shape, panic `"string too long"` (match `rtStr*`'s existing over-cap message if one exists — grep first) if > 255, bounds-check `pos + 4 + L`, then build via a `char[255]` buffer + `s.fromBytes(buf, L)` (the `bkGetStr` idiom, but with the copy loop over `peekb(mp + ...)` — still one call total).

`rtTextTextAt(t, pos, n): text` — bounds-check first; allocate the result text FIRST (mirror `rtTextConcat`'s construction of a new text and its OOM-guard shape), THEN re-derive the source master pointer (`TextHandleDeref(rt.h)`) after the allocation (relocation discipline — allocation can move the source), then one `TextBlockMoveData(srcMp + pos, dstMp, n)`. Set the result's `len` per `rtTextConcat`'s precedent. Return type/ARC convention: copy exactly what `rtTextConcat` declares and returns — do not improvise.

- [ ] **Step 4: Compiler plumbing (host lane)**

1. `clarusc/ir.cla`: four accessors mirroring `ITextIndex()` (:3366) — memoized `intern("text_hash_step")` etc.
2. `clarusc/check.cla` `buildMethodTables` (:1433): four `textOnlyMethods` entries with exact arities/types (see Interfaces above); mirror the `sigStart()/sigAdd(psPlain(IntT))/sigEnd(IntT)` style. `stringAt` returns the string type; `textAt` returns text (find the right `ps*`/type constants by reading the existing entries — `append`'s entry shows text-typed params).
3. `clarusc/lower.cla`: lower each method call to `newIRIntr(ITextHashStep(), <args>, <result ty>)` following `lowIndexOf` (:1709) — receiver first, then args, matching the runtime signatures (`t, h, pos, n` etc.).
4. `clarusc/cprint.cla`: route the four intrinsic names to `clar_fn_rtTextHashStep` etc. under the same unconditional `cpTextPorted` convention `text_index` uses — grep `text_index` in cprint.cla and mirror all its arms.

- [ ] **Step 5: Rebuild current compiler, run the suite, verify pass**

```bash
# stage-2: build the CURRENT compiler with the snapshot compiler
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/clarusc_cur.c clarusc/*.cla
cc -O1 -I runtime/host -o /tmp/clarusc_cur /tmp/clarusc_cur.c runtime/host/rt.c
# emit + build + run the core suite with it
/tmp/clarusc_cur emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
```

Expected: PASS including `TextRange` (and `SelfCheck` still passes — it asserts the case count, which you updated when registering).

- [ ] **Step 6: Panic-contract fixtures**

`testdata/run/textrange_oor.cla`: a minimal program that calls `t.u32At(t.length - 2)` and must die with the STRICT panic; `.err` golden per the existing `testdata/run` convention (find an existing panicking fixture and copy its golden format byte-for-byte). `testdata/run/stringat_cap.cla`: length prefix 256 → `"string too long"` panic. Wire into whatever host runerr test enumerates that directory (read `internal/mactest`'s host runerr test; native `TestRunErrOn68k` cannot boot these if they are `App.startCLI`-shaped — host-only is the accepted precedent, note it in the fixture comment).

- [ ] **Step 7: Reference doc**

Chapter 3's text-operations list (reference:386 region) gains the four methods with the exact contracts from Interfaces above, including the STRICT panic behavior, `stringAt`'s 255 cap, and a one-line "for reading binary formats" motivation. Match the surrounding entries' prose style; the reference is normative, so state contracts, not implementation.

- [ ] **Step 8: T1 + smoke, goldens untouched**

Run: `scripts/test-task.sh --smoke`
Expected: PASS, and `git status` shows NO golden churn (shake removes the unused new runtime functions from programs that don't call them; if goldens churned, STOP — do not rebless).

- [ ] **Step 9: Commit**

```bash
git add runtime/clarus/text.cla clarusc/ir.cla clarusc/check.cla clarusc/lower.cla clarusc/cprint.cla \
    testsuite/core/cases_textrange.cla testsuite/core/runner.cla internal/mactest/suite_host_test.go \
    testdata/run/ docs/clarus-language-reference.md
git commit -m "feat: bulk text range reads (hashStep/u32At/stringAt/textAt), host lane + runtime + suite + reference (design C, 1/4)"
```

---

### Task 3: Design C native lane — cg68k arms + native suite boot

**Files:**
- Modify: `clarusc/cg68k.cla` (intern the four `rtText*` names near `rnTextIndex`, :438; add dispatch arms in the `cgIntr` table region, :6453+)

**Interfaces:**
- Consumes: intrinsic names `text_hash_step`/`text_u32_at`/`text_string_at`/`text_text_at` (Task 2, ir.cla) and runtime functions `rtTextHashStep`/`rtTextU32At`/`rtTextStringAt`/`rtTextTextAt` (Task 2, text.cla).
- Produces: native (emit68k) programs can call the four methods — Tasks 5's load-path rewrite depends on this.

- [ ] **Step 1: Read the precedent**

Read how `text_index` flows through cg68k end to end: the `rnTextIndex = intern("rtTextIndex")` registration (:438), and where the `text_index` intrinsic is dispatched to a plain Clarus-function call on `rnTextIndex` (grep `rnTextIndex` uses). The four new intrinsics are the same shape: ordinary calls into runtime Clarus functions — no custom codegen, no new addressing modes. Note the argument-order convention the existing text intrinsic arms use (receiver first).

- [ ] **Step 2: Add the four registrations + arms**

Mirror `rnTextIndex`'s registration and its dispatch arm four times (`rnTextHashStep` → `rtTextHashStep`, etc.), with the correct arg counts (hashStep 4, u32At 2, stringAt 2, textAt 3) and result kinds (int, int, string, text) — copy whichever existing arm already returns a string (e.g. an `rtStr*` intrinsic) and whichever returns a text (e.g. `text_slice`/concat) so the return-value ABI handling is inherited, not invented. The trailing-`bool`/scalar-width ABI bugs of past phases live exactly here — match an existing same-shape arm precisely.

- [ ] **Step 3: Native proof — suite boot**

The `TextRange` case from Task 2 is already registered in the core suite, and the core suite GUI boots natively:

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestCoreSuiteGUIOn68k -count=1 -timeout 30m -v
```

Expected: PASS with a `TextRange` subtest green. (This is the per-case fan-out described in CLAUDE.md — one boot, per-case subtests.)

- [ ] **Step 4: T1 + smoke**

Run: `scripts/test-task.sh --smoke`
Expected: PASS, still zero golden churn.

- [ ] **Step 5: Commit**

```bash
git add clarusc/cg68k.cla
git commit -m "feat: native-lane cg68k arms for the four bulk text range reads (design C, 2/4)"
```

---

### Task 4: Design C hash swap — djb2 body hash + CLIR v7

**Files:**
- Modify: `clarusc/bake.cla` (`bkHashTextFrom` :330, `bkFnvPrime` const :318 removed, `bkFormatVersion` :81 → 7)

**Interfaces:**
- Consumes: nothing new (pure bake.cla change).
- Produces: `bkHashText`/`bkHashTextFrom` now compute the djb2-shape hash — `h = ((h << 5) + h + b) & 0x7FFFFFFF`, seed `bkFnvSeed = 5381` unchanged. Task 5's chunked `hashStep` verify must produce bit-identical results to `bkHashTextFrom`. `bkFormatVersion = 7`.

- [ ] **Step 1: Find every hash-value consumer**

```bash
grep -rn "bkHashText\|bkFnvPrime\|bkFnvSeed\|bkFormatVersion" clarusc/ internal/ scripts/
```

Confirm the design's symmetry claim before editing: body hash (writer + both loaders), clarusc.c stamp (host-computed, sidecar-persisted), v5 manifest per-module hashes (written at bake, re-checked in drive.cla) — ALL flow through `bkHashText`/`bkHashTextFrom`, and no test hardcodes a hash constant. If anything hardcodes one, list it and update it in this task.

- [ ] **Step 2: Swap the hash, bump the version**

In `bkHashTextFrom` replace the two arithmetic lines:

```
        h = ((h << 5) + h + b) & 0x7FFFFFFF
```

(keep the `driveProgressTick` pulse gate exactly as-is — Task 5 restructures it). Delete the now-unused `bkFnvPrime` const; keep `bkFnvSeed` (5381 — it is djb2's own seed) and reword the :305-315 doc comment: it currently says "FNV-1a-style" — it must now say djb2-shape shift-add, and why (native per-byte multiply cost; cite the spec). Bump `bkFormatVersion` to 7 with a one-line comment ("v7: body/stamp/manifest hash switched from FNV-mul to shift-add — layout unchanged").

- [ ] **Step 3: Run the bake-path tests**

```bash
go test ./internal/... -run 'Rtbake|Bake' -count=1 -v 2>&1 | tail -30
```

Expected: PASS — bakes are generated and loaded by the same-source compiler in these tests, so writer/loader stay symmetric through the swap. Any failure here means an asymmetric call site Step 1 missed.

- [ ] **Step 4: T1 + smoke**

Run: `scripts/test-task.sh --smoke`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add clarusc/bake.cla
git commit -m "feat: CLIR v7 -- body/stamp/manifest hash swapped to shift-add (djb2 shape), layout unchanged (design C, 3/4)"
```

---

### Task 5: Design C load path — chunked verify + bulk readers

**Files:**
- Modify: `clarusc/bake.cla` (`bkCheckRtbakeHeader` :3478, `bkGetU32` :1878, `bkGetStr` :1902, `bkGetBytes` :1922)

**Interfaces:**
- Consumes: `t.hashStep`/`t.u32At`/`t.stringAt`/`t.textAt` (Tasks 2–3); djb2 `bkHashTextFrom` (Task 4).
- Produces: the load path reads v7 bakes through bulk calls; `bkLoadOverrun` soft-fail semantics preserved (the STRICT method panics are unreachable from the load path).

- [ ] **Step 1: Chunked verify**

In `bkCheckRtbakeHeader`, replace the `bkHashTextFrom(buf, bkLoadPos)` call with a ~32KB chunk loop (keep `bkHashTextFrom` itself — it remains the reference implementation and the cold-path form for the manifest/stamp callers):

```
    actualBodyHash = bkFnvSeed
    i = bkLoadPos
    while i < buf.length {
        n = 32768
        if i + n > buf.length {
            n = buf.length - i
        }
        actualBodyHash = buf.hashStep(actualBodyHash, i, n)
        // Liveness pulse (attempt-abort Task 7 contract): one tick per
        // 32KB chunk, same cadence the per-byte loop's (i & 0x7FFF)
        // gate produced.
        driveProgressTick()
        i = i + n
    }
```

(`i`/`n` are new locals — declare them.) The equivalence case in `cases_textrange.cla` (Task 2, "hashStep split") is the chunk-boundary proof; this loop must equal `bkHashTextFrom(buf, bkLoadPos)` bit-for-bit.

- [ ] **Step 2: Bulk readers behind the overrun guard**

Rewrite the three hot readers so each performs ONE bulk call after a soft pre-check (STRICT panic never reachable). `bkGetByte`/`bkGetU16`/`bkGetStrShort` stay untouched (cold).

```
func bkGetU32(): int {
    var v: int
    if bkLoadPos + 4 > bkLoadBuf.length {
        bkLoadOverrun = true
        bkLoadPos = bkLoadBuf.length
        return 0
    }
    v = bkLoadBuf.u32At(bkLoadPos)
    bkLoadPos = bkLoadPos + 4
    return v
}
```

`bkGetStr`: pre-check 4 bytes, read the length via `bkLoadBuf.u32At`, then soft-check `n <= 255` AND `bkLoadPos + 4 + n <= bkLoadBuf.length` (overrun + return "" on violation — the current `char[255]` loop could never overflow, so the `n > 255` refusal is NEW defensive behavior for a corrupt bake; note it in the comment), then ONE `bkLoadBuf.stringAt(bkLoadPos)` and advance `4 + n`.

`bkGetBytes`: pre-check `4 + n` the same way, then `t = bkLoadBuf.textAt(bkLoadPos + 4, n)` and advance. Return `""` (empty text) on overrun, matching the current empty-start behavior.

- [ ] **Step 3: Refusal behavior is unchanged**

Re-run the Task 4 Step 3 selection plus any corrupt/truncation-refusal tests it revealed:

```bash
go test ./internal/... -run 'Rtbake|Bake|Drift' -count=1 -v 2>&1 | tail -30
```

Expected: PASS — truncated/corrupt bakes still soft-refuse ("body hash mismatch" / section-shape diagnostics), never panic.

- [ ] **Step 4: T1 + smoke**

Run: `scripts/test-task.sh --smoke`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add clarusc/bake.cla
git commit -m "feat: CLIR load path reads via bulk hashStep/u32At/stringAt/textAt behind the overrun guard (design C, 4/4)"
```

---

### Task 6: Design B audit — pending-state purity + copy-safety

**Files:**
- Modify: `clarusc/bake.cla` (ONLY if the audit finds live-state writes in readers — move them to install)
- Create: audit report in the SDD ledger dir (`.superpowers/sdd/2026-08-15-clir-load-perf/task-6-audit.md`)

**Interfaces:**
- Produces: the authoritative list of (a) every `bkInstallArenas` assignment that aliases (reference-assigns) pending state, (b) proof that every void-returning reader (`bkReadIrScalars`, `bkReadLowCounters`, `bkReadCheckerSymbols`, `bkReadFieldInfo`, `bkReadUitestBounds`, `bkReadCheckerVisibility`, `bkReadManifestHashes`, `bkReadObjCode`, `bkReadObjMeta`) writes ONLY `bkLd*` pending globals, (c) confirmation that every record type stored in a copied arena has only value-typed fields (int/bool/char/string/enum/fixed-array — reference §194). Task 7 implements exactly this list.

- [ ] **Step 1: Enumerate install-time aliasing**

Read `bkInstallArenas` (:3759) end to end plus `bkInstallPool`/`bkInstallTypeArenaPrefix`/`bkInstallFieldInfo`/`bkInstallObjCode`/`bkInstallCheckerSymbolsForTestapi`. For every `live = bkLd*` assignment, record: global name, element type, reference-or-value, and whether the live side is ever appended to or element-mutated during a compile (grep the live global's name across `clarusc/*.cla` for `.add`, `[...] =`, and field stores). Produce a table.

- [ ] **Step 2: Reader purity**

For each void-returning reader, list every global it writes. Any write to a LIVE (non-`bkLd*`) global is a finding: move the write to the corresponding install function (small, task-scoped fix with its own T1 run), so a memoized parse replays fully through install.

- [ ] **Step 3: Record-field audit**

For every record type in the copied arenas (`IRType`, `IRStmt`, `IRExpr`, `IRLocal`, `IRFunc`, `IRGlobal`, `IRFieldSlot`, `IRRecordLayout`, `IREnumMember`, `IREnumLayout`, the `IRWidget*`/`IRMenu*`/`IRWin*`/`IREvery*` descs): read its declaration (`clarusc/ir.cla`) and confirm every field is value-typed. Any `text`/`list`/`map` field is a finding — record it and its required deep-copy handling for Task 7.

- [ ] **Step 4: Write the report, commit**

```bash
git add .superpowers/sdd/2026-08-15-clir-load-perf/task-6-audit.md clarusc/bake.cla
git commit -m "docs: design-B audit -- install aliasing table, reader purity, record copy-safety (+ fixes if any)"
```

(Include `clarusc/bake.cla` only if Step 2 produced fixes; run `scripts/test-task.sh --smoke` before committing if it did.)

---

### Task 7: Design B — parse once per session

**Files:**
- Modify: `clarusc/bake.cla` (`bkParsedValid` global; copy-on-install in `bkInstallArenas` per Task 6's table)
- Modify: `clarusc/drive.cla` (:1782 gate; manifest-drift fallback reset)
- Modify: `clarusc/macgui.cla` (`gcResolveBakePath` early return; free `rtbakeBytes`)

**Interfaces:**
- Consumes: Task 6's audit table (the exact copy list).
- Produces: `bkParsedValid: bool` — true iff the `bkLd*` pending state is a complete, pristine parse of the session's bake. Reset only on parse failure and on the manifest-drift from-source fallback. NOT reset by `driveReset`.

- [ ] **Step 1: The flag + drive gate**

bake.cla, next to `bkHeaderVerified`:

```
// bkParsedValid (clir-load-perf Task 7, design B): true iff the bkLd*
// pending state holds a complete parse of this session's bake.
// Deliberately NOT reset by driveReset -- surviving across compiles
// is its entire purpose (ClarusC.APPL re-compiles in one process; the
// CLIR resource cannot change under it). Reset on parse failure and
// by the manifest-drift fallback (drive.cla), the two paths where the
// pending state must not be trusted again.
var bkParsedValid: bool
```

drive.cla:1782 — the existing block:

```
        if not bkLoadRtbake(rtbakeBytes, wantLane) {
```

becomes:

```
        if not bkParsedValid {
            if not bkLoadRtbake(rtbakeBytes, wantLane) {
                ... existing failure path ...
            }
            bkParsedValid = true
        }
```

Find the manifest-drift fallback point (the `driveReset()` + recursive `driveCompile()` sequence described at drive.cla:528–549) and add `bkParsedValid = false` beside its existing `haveRtbake = false` — with a comment citing the spec ("a drifted session must re-parse if the bake becomes usable again").

- [ ] **Step 2: Copy-on-install**

In `bkInstallArenas`, for every aliasing assignment in Task 6's table, replace `live = bkLdX` with a fresh-list copy using the existing truncation loop shape (bake.cla:3775–3788):

```
    freshExprs = driveFreshIrExprList()   // or an empty local list -- match file convention
    i = 0
    while i < bkLdIrExprs.count {
        freshExprs.add(bkLdIrExprs[i])
        i = i + 1
    }
    irExprs = freshExprs
```

With ~20+ arenas, add one small copy helper per element type (e.g. `bkCopyIntList(src: list of int): list of int`) rather than 20 inline loops — but do NOT get clever: no generics exist, one boring helper per type. Element `.add` copies records by value (reference §194; Task 6 confirmed no reference-typed fields — if it found any, implement the deep-copy it prescribed).

- [ ] **Step 3: macgui skip + buffer free**

In `gcResolveBakePath` (:494), before the `feHasKey` check:

```
    if bkParsedValid {
        // Design B: this session already parsed the bake -- arm the
        // install gate and skip the resource read + verify outright.
        // rtbakeBytes was freed after the first parse; bkLoadRtbake is
        // unreachable while bkParsedValid holds (drive.cla's gate).
        haveRtbake = true
        return "clarusc: bake path (CLIR resource, parsed earlier this session)"
    }
```

In `gcCompile`, after a successful `driveCompile` on the bake path (find where it already inspects the compile result), free the buffer: `rtbakeBytes = ""` guarded by `bkParsedValid` — the simplest correct placement is right after `driveCompile` returns success while `haveRtbake and bkParsedValid`; read `gcCompile`'s exit paths and pick the one all successful bake-path compiles cross.

- [ ] **Step 4: Two-compile sanity on host is impossible — say so, lean on gates**

Host front ends compile once per process, so this task's runtime proof is: (a) T1 + smoke green (single-compile behavior unchanged — first compile takes the identical code path plus one flag store and the copies), (b) the native suite boots (Task 3's test still green), (c) the Snow session tests at phase close (Task 8 wires the assertion). Do not invent a host double-compile harness.

- [ ] **Step 5: T1 + smoke + native suite boot**

```bash
scripts/test-task.sh --smoke
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestToolboxSuiteOn68k' -count=1 -timeout 30m -v
```

Expected: PASS ×3.

- [ ] **Step 6: Commit**

```bash
git add clarusc/bake.cla clarusc/drive.cla clarusc/macgui.cla
git commit -m "feat: parse the CLIR once per session -- bkParsedValid memo + copy-on-install breaks the pending/live aliasing (design B)"
```

---

### Task 8: Snow-test assertion + snapshot regen

**Files:**
- Modify: `internal/mactest/snow_test.go` (the failed-compile-stays-alive test's log parsing)
- Modify: `clarusc/clarusc.c` (regenerated snapshot)

**Interfaces:**
- Consumes: B's log behavior — "Loading Baked Runtime" appears on the session's FIRST compile only.
- Produces: a committed snapshot whose compiler contains Tasks 1–7 (required for `TestSnapshotFixedPoint`, ClarusC.APPL builds, and the Snow runs at close).

- [ ] **Step 1: The session assertion**

Read `TestMacResidentFailedCompileStaysAliveOnSnow` (snow_test.go) — it drives a failed compile then a successful one in the same app session and captures the Log window text. Add one assertion: the captured session log contains exactly ONE "Loading Baked Runtime" line across both compiles (B's skip proof — compile #2 must not re-read/re-verify). Keep it a plain `strings.Count(...) != 1` failure with a message quoting the log. Do NOT run the Snow test in this task (phase close, Andrew's go-ahead).

- [ ] **Step 2: Snapshot regen**

```bash
go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m -v
```

It fails and PRINTS the Go-free regeneration instructions (CLAUDE.md). Follow them exactly, re-run until it passes (fixed point reached), and confirm `git diff --stat clarusc/clarusc.c` shows the regen.

- [ ] **Step 3: T1 + smoke on the regenerated snapshot**

Run: `scripts/test-task.sh --smoke`
Expected: PASS (the snapshot now bootstraps a compiler that knows the new methods).

- [ ] **Step 4: Commit**

```bash
git add internal/mactest/snow_test.go clarusc/clarusc.c
git commit -m "test: session log asserts single baked-runtime load; regenerate clarusc.c snapshot for clir-load-perf"
```

---

### Task 9: Perf measurement (emulator) — before/after evidence

**Files:**
- Modify: `testdata/cg68k/hashprobe.cla`, `internal/mactest/hashprobe_test.go` (this session's throwaway probe — currently untracked in the working tree; extend, run, then DELETE both — they stay uncommitted; the numbers live in the task report and ROADMAP entry)

**Interfaces:**
- Consumes: the four methods (Tasks 2–3).
- Produces: a measured before/after table for the phase record. No CI assertion — timings are reported, not gated.

- [ ] **Step 1: Extend the probe**

Add variants to `hashprobe.cla` alongside the existing ones (same N=65536, same TickCount bracketing, same log format): `bulk-hash` (`buf.hashStep(5381, 0, N)` in one call), `bulk-hash-chunked` (32KB chunks, the Task 5 verify shape), `bulk-u32` (`buf.u32At(pos)` walk, pos += 4), `bulk-textAt` (one `buf.textAt(0, N)`). Log check values as before.

- [ ] **Step 2: Run**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestHashProbeOn68k -count=1 -timeout 30m -v
```

Expected: PASS; capture the tick table.

- [ ] **Step 3: Record + clean up**

Write the full before/after table (old per-byte variants from the 2026-08-15 probe: hash-exact 154µs/B, getbyte-walk 201µs/B, append 182µs/B — vs the new bulk numbers) into the task report and compute the projected Snow first-compile window. Then delete both probe files (`rm testdata/cg68k/hashprobe.cla internal/mactest/hashprobe_test.go`) — nothing to commit; verify `git status` is clean of them.

---

### Task 10: Docs close-out

**Files:**
- Modify: `docs/ROADMAP.md` (new phase entry: problem, probe table, design A/B/C summary, measured results, debt), `STATUS.md` (§0 rewrite for phase state)

**Interfaces:**
- Consumes: everything above, including Task 9's numbers.

- [ ] **Step 1: ROADMAP entry**

Follow the existing per-phase entry format (see the `attempt-abort` and `object-code-linker` entries): dated, task ledger, measured numbers table, rulings, debt list. Debt candidates to carry forward explicitly: `ser.cla` still reads per-byte (deliberate non-goal); truncate-on-reuse alternative recorded-not-chosen; the host `--rtbake` path still verifies once per process (fine); probe files deleted (numbers preserved in the entry).

- [ ] **Step 2: STATUS.md**

Rewrite §0 for the phase's actual end-state: what's done, what's pending (the two Snow runs + T2 + merge are NOT run inside this plan — they're the close-out gates below).

- [ ] **Step 3: Commit**

```bash
git add docs/ROADMAP.md STATUS.md
git commit -m "docs: ROADMAP + STATUS for clir-load-perf phase"
```

---

## Phase-close gates (outside the task list — run on Andrew's go-ahead)

1. `scripts/test-merge.sh` (T2 — includes `internal/selfhost` at 30m timeout and the native mactest lane).
2. `CLARUS_SNOW_TESTS=1` runs of `TestClarusCBakePathOnSnow` AND `TestMacResidentFailedCompileStaysAliveOnSnow` (standing rule: bake.cla/macgui.cla changed; 20m settle + fast-forward procedure per STATUS §0a; the second test now also proves B via the Task 8 assertion). Capture the Log-window timestamps — this is the real before/after for the 10-minute window.
3. Merge to `main` only on Andrew's request.
