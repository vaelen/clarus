# Transfer CRCs (`text.crc16x`, `text.crc32`) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `t.crc16x(h, pos, n)` (CRC-16/XMODEM, bitwise) and `t.crc32(h, pos, n)` (CRC-32, lazily built lookup table) as `text` methods on both lanes, mirroring `crc16`'s contract, so 68kBBS's XMODEM/YMODEM/ZMODEM framing can drop its Clarus bit-loop workaround.

**Architecture:** Two new runtime routines in `runtime/clarus/text.cla` beside `rtTextCrc16` (same bounds rule, same seed-carry chunking), the `crc32` table as two runtime globals built on first call; two new intrinsics threaded through the compiler exactly where `ITextCrc16` is (`ir`/`check`/`lower`/`shake`/`cg68k`/`cprint`). Because runtime globals are laid out in splice order and `text.cla` is spliced third, the 1 KB table shifts every later global's A5 offset — Task 1 therefore carries the phase's ONE planned golden rebless, with a normalization-diff proof. Task 2 grows the existing `Crc16` core-suite case (no new enum member) and proves it natively; Task 3 regenerates the bootstrap snapshot and closes out the docs.

**Tech Stack:** Clarus (`clarusc/*.cla` compiler, `runtime/clarus/*.cla` runtime), Go test harness (`internal/*`), Mini vMac (System 6 native suite lane), Snow (System 7 Mac II, timing spot-check only).

**Spec:** `docs/superpowers/specs/2026-08-25-transfer-crcs-design.md` — read it first; every task below argues from it.

## Global Constraints

- Branch: all work on `transfer-crcs`, created from `main` at the plan commit. Merge only on Andrew's explicit request; `main` stays green.
- SDD ledger: `.superpowers/sdd/2026-08-25-transfer-crcs/` (`progress.md` + per-task reports). Never delete it (project memory rule: SDD workspaces are phase records).
- After every task: `scripts/test-task.sh --smoke` (every task touches `runtime/` or `clarusc/`). Go tests always `-count=1`. `internal/selfhost` only in Task 3, `-count=1 -timeout 30m`.
- The committed bootstrap `clarusc/clarusc.c` does NOT know the new methods until Task 3 regenerates it, so `scripts/clarus-run.sh` (snapshot-only) cannot compile a fixture that calls `crc32`/`crc16x` during Tasks 1–2. Build the CURRENT compiler from source instead and use it for every manual run:
  ```sh
  cc -O1 -I runtime/host -o build-run/boot clarusc/clarusc.c runtime/host/rt.c
  build-run/boot emit --rtdir runtime/clarus/ -o build-run/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o build-run/cur build-run/cur.c runtime/host/rt.c
  # then: build-run/cur emit --rtdir runtime/clarus/ -o /tmp/x.c FILE.cla && cc -O1 -I runtime/host -o /tmp/x /tmp/x.c runtime/host/rt.c && /tmp/x
  ```
  (The Go harness already does this itself — `internal/claruscboot.CurrentExe` — so T1's own tests are unaffected.)
- Before editing any `.cla` file, check for non-ASCII bytes (`LC_ALL=C grep -nP '[\x80-\xff]' FILE`); if any, do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (project memory rule).
- Golden policy: Task 1 is the ONE planned rebless wave — `testdata/cg68k/*.s` (30 files: two new runtime globals shift every later global's `d(A5)` offset and the startup zero-loop bound) and `testdata/emitui/*.c.golden` (20 files: `text.cla` is spliced into every host emission, so the two new `static` globals, their `clar_init_globals` zeroing, and — for fixtures that don't tree-shake them — the new routines appear additively). Rebless ONLY with the normalization-diff proof in Task 1 Step 7; any churn that proof cannot explain → STOP and write it up in the task report before touching goldens. Tasks 2–3 must produce zero golden churn.
- `>>` is ARITHMETIC in Clarus. Every right shift of a value that may have bit 31 set is followed by a mask (`& 0x7FFFFFFF` after `>> 1`, `& 0x00FFFFFF` after `>> 8`). The `"123456789"` vectors below pin this; do not "simplify" the masks away.
- No new `CoreTest` enum member: the case-count constants in `testsuite/core/runner.cla`, `internal/mactest/coresuite_test.go`, `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`, `internal/bake/bakeidentity_test.go`, and `CLAUDE.md` do NOT move in this phase.
- reftest: the reference edits add NO new ```` ```rust ```` fences (bullets only), so `internal/reftest/manifest.go` needs no regeneration. If a task finds it must add a fence, regeneration becomes Task 3's last step (ROADMAP process convention).
- Subagent models: `sonnet` for implementation and review tasks; `opus` only for a hard debugging detour; never Fable. State each subagent's model at dispatch.
- Commit after every task (prefix `feat:`/`test:`/`docs:`).

## File map (who owns what)

- `runtime/clarus/text.cla` — `rtCrc32Tab`/`rtCrc32TabReady` globals, `rtCrc32TabInit`, `rtTextCrc32`, `rtTextCrc16X` (Task 1).
- `clarusc/ir.cla`, `check.cla`, `lower.cla`, `shake.cla`, `cg68k.cla`, `cprint.cla` — the two intrinsics (Task 1). `clarusc/clarusc.c` — snapshot (Task 3).
- `testdata/run/crc16.cla` + `.behavior` — fixture grows both algorithms (Task 1). `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden` — planned rebless (Task 1).
- `docs/clarus-language-reference.md` `### Text` — two bullets + the STRICT-rule sentence (Task 1).
- `testsuite/core/cases_textbinary.cla` `caseCrc16` — grows both algorithms (Task 2).
- `STATUS.md`, `docs/ROADMAP.md`, `docs/HISTORY.md`, `CLAUDE.md` — close-out (Task 3). `docs/TODO.md` already carries the array-literal follow-up (spec commit).
- 68kbbs repo `docs/language-gaps.md` §8 / `xmodem.cla` — NOT this phase (spec §7: after the next toolchain pin).

---

### Task 1: `crc16x` + `crc32` on both lanes, fixture, reference, planned rebless

**Files:**
- Modify: `runtime/clarus/text.cla` (after `rtTextCrc16`, which ends at `:813`), `clarusc/ir.cla` (`:1239` reset line; accessor beside `ITextCrc16` at `:3606-3613`), `clarusc/check.cla` (`textOnlyMethods["crc16"]` block `:1581-1585`), `clarusc/lower.cla` (`crc16` arm `:2094-2097`), `clarusc/shake.cla` (`:645-646`), `clarusc/cg68k.cla` (var `:327`, intern `:475`, arm `:8356-8358`), `clarusc/cprint.cla` (`:3847-3848`), `testdata/run/crc16.cla` + `testdata/run/crc16.behavior`, `docs/clarus-language-reference.md` (`:407-409`).
- Rebless: `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden`.

**Interfaces:**
- Consumes: `rtTextCrc16(t: ptr, h: int, pos: int, n: int): int` (`text.cla:785`) as the body template; `RtText(t)`, `rt.len`, `rt.h`, `TextHandleDeref`, `peekb`, `rtPanic` exactly as it uses them.
- Produces (runtime): `rtTextCrc16X(t: ptr, h: int, pos: int, n: int): int` — CRC-16/XMODEM forward; `rtTextCrc32(t: ptr, h: int, pos: int, n: int): int` — CRC-32 reflected, raw register; `rtCrc32TabInit()`; globals `rtCrc32Tab: int[256]`, `rtCrc32TabReady: bool`.
- Produces (IR): `ITextCrc16X()` interning `"text_crc16x"`, `ITextCrc32()` interning `"text_crc32"`, index vars `iTextCrc16XIdx`/`iTextCrc32Idx`.
- Produces (checker): `textOnlyMethods["crc16x"]` and `["crc32"]` = `(int, int, int) -> int`.
- Produces (backends): cg68k `rnTextCrc16X = intern("rtTextCrc16X")`, `rnTextCrc32 = intern("rtTextCrc32")`, both dispatched via `cgIntr4(e, rn…, false, false, false, false)`; cprint `clar_fn_rtTextCrc16X(...)`/`clar_fn_rtTextCrc32(...)` with `crc16`'s exact argument shape.

- [ ] **Step 1: Grow the fixture first (it must fail to compile)**

Append to `testdata/run/crc16.cla`'s `on App.launch` body, after the existing `n=0 ok` block (declare any new locals at the top of the body with the existing ones — Clarus requires locals before statements):

```rust
    // CRC-16/XMODEM (poly 0x1021 forward): published check 0x31C3.
    oneShot = t.crc16x(0, 0, 9)
    if oneShot == 0x31C3 {
        alert("crc16x one-shot ok")
    } else {
        alert("crc16x one-shot FAIL")
    }
    chunked = t.crc16x(0, 0, 4)
    chunked = t.crc16x(chunked, 4, 5)
    if chunked == oneShot {
        alert("crc16x chunked ok")
    } else {
        alert("crc16x chunked FAIL")
    }
    if t.crc16x(0x1234, 0, 0) == 0x1234 {
        alert("crc16x n=0 ok")
    } else {
        alert("crc16x n=0 FAIL")
    }

    // CRC-32 (reflected 0xEDB88320), raw register in/out: the caller
    // seeds 0xFFFFFFFF and applies the final XOR. Published check
    // 0xCBF43926 (a negative int -- hex literals above 0x7FFFFFFF wrap).
    oneShot = t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF
    if oneShot == 0xCBF43926 {
        alert("crc32 one-shot ok")
    } else {
        alert("crc32 one-shot FAIL")
    }
    chunked = t.crc32(0xFFFFFFFF, 0, 4)
    chunked = t.crc32(chunked, 4, 5) ^ 0xFFFFFFFF
    if chunked == oneShot {
        alert("crc32 chunked ok")
    } else {
        alert("crc32 chunked FAIL")
    }
    if t.crc32(0x12345678, 0, 0) == 0x12345678 {
        alert("crc32 n=0 ok")
    } else {
        alert("crc32 n=0 FAIL")
    }
    // Second call proves the table survives (built once, reused).
    if (t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF) == oneShot {
        alert("crc32 table reuse ok")
    } else {
        alert("crc32 table reuse FAIL")
    }
```

Update the file's header comment to say it covers all three CRCs (KERMIT, XMODEM, CRC-32).

Run (current-source compiler per Global Constraints): `build-run/cur emit --rtdir runtime/clarus/ -o /tmp/crc.c testdata/run/crc16.cla`
Expected: FAIL — an unknown-method diagnostic naming `crc16x`.

- [ ] **Step 2: Runtime routines in `text.cla`**

Insert immediately after `rtTextCrc16`'s closing brace (`:813`), before the `rtTextStringAt` comment block:

```rust
// rtTextCrc16X (transfer-crcs phase): CRC-16/XMODEM over bytes
// [pos, pos+n) -- poly 0x1021 FORWARD (MSB-first, no reflection), seed h
// masked to 16 bits, no final XOR. Same skeleton and chunking contract as
// rtTextCrc16 above (which is the REFLECTED CRC-16/KERMIT); only the
// inner loop differs: xor the byte into the HIGH half, shift LEFT, and
// mask to 16 bits after every step so the value never reaches bit 31.
// Published check value: "123456789" -> 0x31C3.
func rtTextCrc16X(t: ptr, h: int, pos: int, n: int): int {
    var rt: RtText
    var mp: ptr
    var crc: int
    var i: int
    var b: int
    var j: int

    rt = RtText(t)
    if pos < 0 or n < 0 or pos > rt.len - n {
        rtPanic("text index out of range")
    }
    crc = h & 0xFFFF
    if n == 0 {
        return crc
    }
    mp = TextHandleDeref(rt.h)
    i = 0
    while i < n {
        b = peekb(mp + pos + i)
        crc = crc ^ (b << 8)
        j = 0
        while j < 8 {
            if (crc & 0x8000) != 0 {
                crc = ((crc << 1) ^ 0x1021) & 0xFFFF
            } else {
                crc = (crc << 1) & 0xFFFF
            }
            j = j + 1
        }
        i = i + 1
    }
    return crc
}

// CRC-32 lookup table (transfer-crcs phase, spec %4). Built ONCE, on the
// first rtTextCrc32 call, by rtCrc32TabInit below: Clarus has no
// array-literal initializer, so a build-time table is not expressible
// today. ponytail: lazily built 1 KB global in every program's data
// segment (shake prunes functions, not globals); replace with a hardcoded
// array literal when the language grows one (docs/TODO.md, "Array-literal
// initializers").
var rtCrc32Tab: int[256]
var rtCrc32TabReady: bool

// rtCrc32TabInit: the standard reflected-CRC-32 table (poly 0xEDB88320).
// `>>` is arithmetic in Clarus and every entry routinely has bit 31 set,
// so each `>> 1` is masked with & 0x7FFFFFFF to make it a logical shift.
func rtCrc32TabInit() {
    var i: int
    var j: int
    var c: int

    i = 0
    while i < 256 {
        c = i
        j = 0
        while j < 8 {
            if (c & 1) == 1 {
                c = ((c >> 1) & 0x7FFFFFFF) ^ 0xEDB88320
            } else {
                c = (c >> 1) & 0x7FFFFFFF
            }
            j = j + 1
        }
        rtCrc32Tab[i] = c
        i = i + 1
    }
    rtCrc32TabReady = true
}

// rtTextCrc32 (transfer-crcs phase): CRC-32 (IEEE / ZMODEM / zip,
// reflected poly 0xEDB88320) over bytes [pos, pos+n), table-driven. h is
// the RAW 32-bit register in and out -- no masking (all 32 bits are
// significant), no init, no final XOR: the caller seeds 0xFFFFFFFF and
// xors the result with 0xFFFFFFFF, which keeps chunked calls composable
// exactly like rtTextCrc16's seed-carry. Published check:
// crc32(0xFFFFFFFF, "123456789") ^ 0xFFFFFFFF == 0xCBF43926. The
// & 0x00FFFFFF after `>> 8` is load-bearing (arithmetic shift, bit 31
// routinely set).
func rtTextCrc32(t: ptr, h: int, pos: int, n: int): int {
    var rt: RtText
    var mp: ptr
    var crc: int
    var i: int
    var b: int

    rt = RtText(t)
    if pos < 0 or n < 0 or pos > rt.len - n {
        rtPanic("text index out of range")
    }
    if n == 0 {
        return h
    }
    if not rtCrc32TabReady {
        rtCrc32TabInit()
    }
    crc = h
    mp = TextHandleDeref(rt.h)
    i = 0
    while i < n {
        b = peekb(mp + pos + i)
        crc = rtCrc32Tab[(crc ^ b) & 0xFF] ^ ((crc >> 8) & 0x00FFFFFF)
        i = i + 1
    }
    return crc
}
```

- [ ] **Step 3: Compiler — IR, checker, lowering, shake**

`clarusc/ir.cla`: after the `iTextCrc16Idx = -1` reset line (`:1239`) add `iTextCrc16XIdx = -1` and `iTextCrc32Idx = -1`; after `ITextCrc16()` (`:3613`) add:

```rust
var iTextCrc16XIdx: int = -1

func ITextCrc16X(): int {
    if iTextCrc16XIdx == -1 {
        iTextCrc16XIdx = intern("text_crc16x")
    }
    return iTextCrc16XIdx
}

var iTextCrc32Idx: int = -1

func ITextCrc32(): int {
    if iTextCrc32Idx == -1 {
        iTextCrc32Idx = intern("text_crc32")
    }
    return iTextCrc32Idx
}
```

`clarusc/check.cla`: after `textOnlyMethods["crc16"] = sigEnd(IntT)` (`:1585`):

```rust
    sigStart()
    sigAdd(psPlain(IntT))
    sigAdd(psPlain(IntT))
    sigAdd(psPlain(IntT))
    textOnlyMethods["crc16x"] = sigEnd(IntT)

    sigStart()
    sigAdd(psPlain(IntT))
    sigAdd(psPlain(IntT))
    sigAdd(psPlain(IntT))
    textOnlyMethods["crc32"] = sigEnd(IntT)
```

`clarusc/lower.cla`: after the `crc16` arm (`:2094-2097`):

```rust
    } else if nm == "crc16x" {
        arg1 = exprNext(arg0)
        arg2 = exprNext(arg1)
        return newIRIntr(ITextCrc16X(), lowMethodArgs4(recv, arg0, arg1, arg2), ty)
    } else if nm == "crc32" {
        arg1 = exprNext(arg0)
        arg2 = exprNext(arg1)
        return newIRIntr(ITextCrc32(), lowMethodArgs4(recv, arg0, arg1, arg2), ty)
```

`clarusc/shake.cla`: after the `ITextCrc16()` arm (`:645-646`):

```rust
    } else if nm == ITextCrc16X() {
        shakeMarkAndEnqueue(intern("rtTextCrc16X"))
    } else if nm == ITextCrc32() {
        shakeMarkAndEnqueue(intern("rtTextCrc32"))
```

(`rtCrc32TabInit` is reached transitively through `rtTextCrc32`'s body — no separate root.)

- [ ] **Step 4: Compiler — both backends**

`clarusc/cg68k.cla`: beside `var rnTextCrc16: int` (`:327`) add `var rnTextCrc16X: int` and `var rnTextCrc32: int`; beside `rnTextCrc16 = intern("rtTextCrc16")` (`:475`) add `rnTextCrc16X = intern("rtTextCrc16X")` and `rnTextCrc32 = intern("rtTextCrc32")`; after the `ITextCrc16()` arm (`:8356-8358`):

```rust
    if nm == ITextCrc16X() {
        cgIntr4(e, rnTextCrc16X, false, false, false, false)
        return
    }
    if nm == ITextCrc32() {
        cgIntr4(e, rnTextCrc32, false, false, false, false)
        return
    }
```

`clarusc/cprint.cla`: after the `ITextCrc16()` arm (`:3847-3848`):

```rust
    } else if nm == ITextCrc16X() {
        return "clar_fn_rtTextCrc16X((void*)" + fpExpr(a0) + ", (int32_t)(" + fpExpr(a1) + "), (int32_t)(" + fpExpr(a2) + "), (int32_t)(" + fpExpr(fpArgAt(a0, 3)) + "))"
    } else if nm == ITextCrc32() {
        return "clar_fn_rtTextCrc32((void*)" + fpExpr(a0) + ", (int32_t)(" + fpExpr(a1) + "), (int32_t)(" + fpExpr(a2) + "), (int32_t)(" + fpExpr(fpArgAt(a0, 3)) + "))"
```

Rebuild the current compiler (Global Constraints recipe — the compiler source changed, so `build-run/cur` must be regenerated from the snapshot-built `build-run/boot`).

- [ ] **Step 5: Run the fixture on the host, then bless its behavior golden**

Run: `build-run/cur emit --rtdir runtime/clarus/ -o /tmp/crc.c testdata/run/crc16.cla && cc -O1 -I runtime/host -o /tmp/crc /tmp/crc.c runtime/host/rt.c && /tmp/crc`
Expected: the original three `ok` lines followed by `crc16x one-shot ok`, `crc16x chunked ok`, `crc16x n=0 ok`, `crc32 one-shot ok`, `crc32 chunked ok`, `crc32 n=0 ok`, `crc32 table reuse ok`. Any `FAIL` → fix the runtime (the masks in Global Constraints are the first suspects) before going on.

Then bless: `CLARUS_BLESS_BEHAVIOR=1 go test ./internal/selfhost -run 'TestBehaviorGoldens/run/crc16' -count=1` and confirm `testdata/run/crc16.behavior` now lists all ten lines under `--- stdout ---` with `exit=0`.

Native smoke of the same fixture (no golden, just proof the cg68k arms and the `int[256]` global work on 68k): `scripts/build-68k.sh Crc testdata/run/crc16.cla` must build; then `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounceOn68k' -count=1` still passes (the full native proof of the vectors is Task 2's suite boot).

- [ ] **Step 6: Reference**

In `docs/clarus-language-reference.md`, directly after the `t.crc16(h, pos, n)` bullet (`:407`), add two bullets (no code fences):

```markdown
- `t.crc16x(h, pos, n)` — folds bytes `[pos, pos+n)` into running CRC `h` (masked to 16 bits) and returns the updated value; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. The algorithm is CRC-16/XMODEM (poly `0x1021` forward, MSB-first, no reflection; seed and result taken as-is, no final XOR) — the one XMODEM-CRC and YMODEM use. The published check value for `crc16x(0, 0, 9)` over the ASCII bytes `"123456789"` is `0x31C3`. Chunkable exactly like `crc16`.
- `t.crc32(h, pos, n)` — folds bytes `[pos, pos+n)` into running 32-bit CRC register `h` and returns the updated register; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. The algorithm is CRC-32 (reflected poly `0xEDB88320` — the IEEE/zip/ZMODEM CRC), table-driven; the table is built on the first call. The register is returned **raw**: the caller supplies the `0xFFFFFFFF` seed and applies the final XOR itself, so the published check is `t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF == 0xCBF43926` over `"123456789"`. The result is an ordinary 32-bit `int` — a register with bit 31 set reads as negative (`0xCBF43926` is `-873187034`), and hex literals above `0x7FFFFFFF` wrap the same way, so comparisons against published check values work as written. Chunkable exactly like `crc16`: feed each call's return value in as the next call's `h`, and apply the final XOR once at the end.
```

Then edit the STRICT-rule sentence (`:409`): `plus \`crc16\`,` → `plus \`crc16\`/\`crc16x\`/\`crc32\`,`.

- [ ] **Step 7: The planned rebless, with proof**

First capture HEAD's goldens for the proof: `git stash list` must be empty of your work — instead copy: `mkdir -p /tmp/gold && cp testdata/cg68k/*.s /tmp/gold/ && cp testdata/emitui/*.c.golden /tmp/gold/`.

Regenerate: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -run TestCg68kGoldens -count=1`; for emitui there is no bless switch — regenerate each fixture that has a golden with the current-source compiler, FROM THE REPO ROOT (with no `--rtdir`, clarusc walks up from the cwd to find `runtime/clarus/`, which is exactly what the test relies on): `for f in testdata/emitui/*.c.golden; do build-run/cur emit -o "$f" "${f%.c.golden}.cla"; done` (the test invokes `clarusc emit -o OUT FIXTURE` with no `--rtdir`, so match that exactly).

Proof (record the commands and their empty-diff output in the task report):
1. cg68k `.s`: for each file, `diff <(sed -E 's/-[0-9]+\(A5\)/-N(A5)/g; s/^ *;   rtCrc32Tab.*$//; s/^ *;   rtCrc32TabReady.*$//' /tmp/gold/X.s) <(same sed over testdata/cg68k/X.s)`. The ONLY remaining differences allowed are (a) the startup zero-loop's bound immediate (one instruction in `cgEmitStartup`'s sweep — name it), and (b) nothing else. Confirm every shifted offset moved by exactly the same delta (1024 + 2: `int[256]` plus the even-rounded `bool`) with `grep -o -- '-[0-9]*(A5)' old | paste - <(grep -o … new) | awk '{d=$2-$1; print d}' | sort -u` — one nonzero delta value (plus zeros for globals declared before `text.cla`'s).
2. emitui `.c.golden`: `diff /tmp/gold/X.c.golden testdata/emitui/X.c.golden` must be PURELY ADDITIVE — new `static int32_t cv_rtCrc32Tab[256];`/`static int32_t cv_rtCrc32TabReady;`-shaped declarations (match whatever shape cprint already uses for `int[4]`/`bool` globals in a `usesConn` host build — check `build-run/cur emit` of `examples/serialecho.cla` for `cv_rtConnState`), their zeroing in `clar_init_globals`, and (where not tree-shaken) the three new routines. No removed or modified lines.
3. `go test ./internal/cg68k ./internal/emitui -count=1` → PASS.

- [ ] **Step 8: T1 + commit**

Run: `scripts/test-task.sh --smoke` → PASS (all packages; note `TestSnapshotFixedPoint` lives in `internal/selfhost`, which T1 does not run — Task 3 handles the snapshot).

```bash
git add runtime/clarus/text.cla clarusc/ir.cla clarusc/check.cla clarusc/lower.cla clarusc/shake.cla clarusc/cg68k.cla clarusc/cprint.cla testdata/run/crc16.cla testdata/run/crc16.behavior testdata/cg68k testdata/emitui docs/clarus-language-reference.md
git commit -m "feat: text.crc16x (CRC-16/XMODEM, bitwise) + text.crc32 (table-driven, lazily built) on both lanes; planned .s/.c.golden rebless (runtime-global offset shift)"
```

---

### Task 2: Core-suite coverage (`caseCrc16` grows both algorithms), native proof, Snow timing

**Files:**
- Modify: `testsuite/core/cases_textbinary.cla` (`caseCrc16`, `:86-111`), `testsuite/core/runner.cla` (`:106-110` comment only — the `Crc16` case's description).
- Create (throwaway, NOT committed): `build-run/crctime.cla` (gitignored).

**Interfaces:**
- Consumes: `t.crc16x(h, pos, n): int`, `t.crc32(h, pos, n): int` (Task 1); `tkPass(name)`/`tkFail(name, detail)` from `testsuite/kit.cla`.
- Produces: nothing new for later tasks; `Crc16`'s `tkReport` line now proves all three CRCs on both lanes.

- [ ] **Step 1: Grow `caseCrc16`**

Replace the body of `caseCrc16` (`cases_textbinary.cla:89-111`) so that, after the existing three KERMIT checks (keep their `tkFail` details exactly), it also runs:

```rust
    // CRC-16/XMODEM (0x1021 forward): published check 0x31C3.
    oneShot = t.crc16x(0, 0, 9)
    if oneShot != 0x31C3 {
        return tkFail("Crc16", "crc16x one-shot wrong")
    }
    chunked = t.crc16x(0, 0, 4)
    chunked = t.crc16x(chunked, 4, 5)
    if chunked != oneShot {
        return tkFail("Crc16", "crc16x chunked wrong")
    }
    if t.crc16x(0x1234, 0, 0) != 0x1234 {
        return tkFail("Crc16", "crc16x n=0 wrong")
    }

    // CRC-32 (reflected 0xEDB88320), raw register: seed/final XOR by
    // the caller. Published check 0xCBF43926 (negative as an int).
    oneShot = t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF
    if oneShot != 0xCBF43926 {
        return tkFail("Crc16", "crc32 one-shot wrong")
    }
    chunked = t.crc32(0xFFFFFFFF, 0, 4)
    chunked = t.crc32(chunked, 4, 5) ^ 0xFFFFFFFF
    if chunked != oneShot {
        return tkFail("Crc16", "crc32 chunked wrong")
    }
    if t.crc32(0x12345678, 0, 0) != 0x12345678 {
        return tkFail("Crc16", "crc32 n=0 wrong")
    }
    if (t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF) != oneShot {
        return tkFail("Crc16", "crc32 table reuse wrong")
    }
    return tkPass("Crc16")
```

Update the case's doc comment (`:86-88`) and `runner.cla`'s `:106-110` description to say the case covers KERMIT, XMODEM, and CRC-32. The `CoreTest` enum, `nCoreCases`, and every count site are UNTOUCHED.

- [ ] **Step 2: Host run**

Per CLAUDE.md's compose recipe, but with the current-source compiler (`build-run/cur`, Global Constraints):
```sh
build-run/cur emit --rtdir runtime/clarus/ -o /tmp/core_cli.c testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
```
Expected: exit 0, `Crc16` PASS among the 78. Also `go test ./internal/testsuite -run TestCoreCLI -count=1` → PASS.

- [ ] **Step 3: Native proof (System 6, Mini vMac)**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k' -count=1 -v`
Expected: PASS, including the `Crc16` subtest — this is the hardware proof of the cg68k arms, the `int[256]` runtime global, and the arithmetic-shift masks on a real 68000.

- [ ] **Step 4: Snow timing spot-check (manual, numbers go in the report, nothing committed)**

Write `build-run/crctime.cla` (gitignored directory), a native-only program: declare `external func TickCount(): int = trap 0xA975` (the reference's own example, `docs/clarus-language-reference.md:1771`), append 65536 bytes (`char(i & 0xFF)`) to a `text` in `on App.launch`, then for each of `t.crc16(0, 0, 65536)`, `t.crc16x(0, 0, 65536)`, `t.crc32(0xFFFFFFFF, 0, 65536)`: read `TickCount()`, make the call, read `TickCount()` again, and `alert("crc16 ticks: " + string(delta))` (one alert per algorithm; 1 tick = 1/60 s). Build with `scripts/build-68k.sh CrcTime build-run/crctime.cla`, boot it on Snow the way `internal/mactest/pagefile_snow_test.go` boots `examples/pagefile.cla` (read that test for the boot mechanics; a manual boot and a screenshot of the three alerts is fine), and record the three tick counts plus the machine (Snow, Mac II, 16 MHz 68020) in the task report. Expected: `crc32` (table) clearly faster per byte than `crc16`/`crc16x` (bitwise) — the spec's ZMODEM motivation rests on it; if it is NOT, stop and report before Task 3. Nothing from this step is committed.

- [ ] **Step 5: T1 + zero-churn + commit**

Run: `scripts/test-task.sh --smoke` → PASS; `git status` shows only the two `testsuite/core` files changed (no golden churn — the suite is not a golden fixture).

```bash
git add testsuite/core/cases_textbinary.cla testsuite/core/runner.cla
git commit -m "test: core Crc16 case covers crc16x (XMODEM) and crc32 vectors, chunking, n=0, table reuse; proved natively"
```

---

### Task 3: Bootstrap snapshot, close-out docs, T2

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated), `STATUS.md` (§0 + §1), `docs/ROADMAP.md` (`### Next: language usability` item 1 `:114-125`; "Where we are" `:45`), `docs/HISTORY.md` (new phase entry appended after the binary-files entry, before `## Resolved "Small open items"` at `:4302` — read the binary-files entry's shape at `:4229-4300` and match it), `CLAUDE.md` (`:232-241` binary-data paragraph).

**Interfaces:**
- Consumes: everything Tasks 1–2 committed.
- Produces: a green T2 at the branch tip and docs that let the next session pick up cold.

- [ ] **Step 1: Regenerate the snapshot**

Exactly the recipe `TestSnapshotFixedPoint` prints (`internal/selfhost/fixedpoint_test.go:127-134`):
```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```
Then `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m` → PASS. Sanity: `scripts/clarus-run.sh testdata/run/crc16.cla` now works Go-free and prints all ten `ok` lines.

- [ ] **Step 2: Close-out docs**

- `docs/HISTORY.md`: append a `transfer-crcs` phase entry (date 2026-08-25, branch, the three commits, what was built, the rebless-wave rationale — runtime-global offset shift — with the proof summary from Task 1's report, the Snow timing numbers from Task 2's report, and the two spec decisions worth remembering: lazy table because no array literals; `app68Crc16` deliberately not converted because of the bootstrap snapshot).
- `STATUS.md` §0/§1: this phase is the current one; gate results table with T1/T2 timings and the native `Crc16` subtest.
- `docs/ROADMAP.md`: mark the item DONE in the same voice as item 1's binary-files note (`:114-125`): "`text.crc16x`/`text.crc32` (transfer-crcs phase, 2026-08-25) — XMODEM/YMODEM and ZMODEM CRCs on both lanes; array-literal initializers filed in TODO."
- `CLAUDE.md` `:239`: extend "plus `crc16`" to "plus `crc16`/`crc16x`/`crc32` (the last two from the transfer-crcs phase, 2026-08-25; `crc32`'s table is built lazily on first call)".
- `docs/TODO.md`: already carries the array-literal entry from the spec commit — verify it still reads correctly against what shipped; no edit expected.

- [ ] **Step 3: T2 and commit**

Run: `scripts/test-merge.sh` → PASS (needs the emulator; record wall time in STATUS §1).

```bash
git add clarusc/clarusc.c STATUS.md docs/ROADMAP.md docs/HISTORY.md CLAUDE.md docs/TODO.md
git commit -m "docs: transfer-crcs close-out (snapshot regen, STATUS, ROADMAP, HISTORY, CLAUDE.md)"
```

Then report to Andrew: branch tip, T2 result, and that merging is on request only.
