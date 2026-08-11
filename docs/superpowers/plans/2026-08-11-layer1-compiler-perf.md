# Layer 1 Compiler Performance Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminate the Layer 1 algorithmic bugs and hot-loop constant factors in clarusc identified by `docs/superpowers/specs/2026-08-10-native-compiler-performance-findings.md`, with byte-identical emitted output.

**Architecture:** Every task is a behavior-preserving refactor of `clarusc/*.cla` (plus one small language addition, `.clear()`). Correctness is proven per task by (a) the T1 host gauntlet, which rebuilds the compiler from current source, and (b) fork byte-identity: the snapshot-built (pre-change) compiler and the current-source (post-change) compiler must emit byte-identical 68k forks. Perf is tracked by interleaved A/B wall-clock of the compiler self-compiling.

**Tech Stack:** Clarus (self-hosted compiler), C host runtime, Go test harness.

## Scope decisions (verified against current code 2026-08-11, HEAD `94bc1f1`)

- **Already fixed — no task:** findings §1.2 (all 8 side tables are `intmap` now), `scopeLookup` (int-keyed, single probe), §2.2 (map is a hashtable). Stale doc comment `check.cla:4978` is fixed in Task 6.
- **§1.7 (functions code-generated twice) — DEFERRED.** No bytes-reuse path exists; the cheap single-segment variant would not help ClarusC.APPL (35 segments); full reuse needs segment-independent relocation, which is findings Layer 3 item 4/5 territory. Re-measure with the new per-phase instrumentation after this phase, then decide. Recorded in the ROADMAP entry (Task 19).
- **§1.8 `numToStr` rewrite — DROPPED.** Its hot caller (map keys) is gone since map-hashtable; remaining callers are cold or listing-gated. The findings doc itself says "mostly moot once 1.2 removes its hottest caller."
- **Layer 2/3 items** (Str255 ABI, trap-per-copy, `text[i]` inlining, shake-early, session-resident runtime) — out of scope, unchanged from the findings sequencing.

## Global Constraints

- Work in this worktree only: `/Users/andrew/repos/clarus/.claude/worktrees/native-perf-findings`, branch `worktree-native-perf-findings`.
- **Per-task gate (every task):**
  1. `scripts/test-task.sh` — must PASS. No `--smoke` (zero emulator boots this phase except Task 19; explicit session decision).
  2. **Fork byte-identity** (see "Byte-identity gate" below) — `cmp` must report identical, single-segment AND (for Tasks 11–18) multi-segment.
- **Checker-touching tasks (5, 6, 7, 8) additionally run:** `go test ./internal/selfhost -run TestErrorGoldens -count=1 -timeout 30m` (fast; the 30m is package headroom). These tasks can affect diagnostics; nothing else in the phase may change any diagnostic text.
- **A/B wall-clock** (Tasks 1, 3, 4, 11, 12, 13, 14, 17 and the final report): 5 interleaved pre/post pairs of self-compile, per "Benchmark commands" below. Record medians in the task report. No hard threshold per task; regressions must be explained or reverted.
- **MacRoman bytes:** several `.cla` files contain MacRoman-encoded bytes in comments (e.g. `clarusc/tok.cla`'s `keywordKind` doc comment). Before editing any `.cla` file, run `LC_ALL=C /usr/bin/grep -nP '[\x80-\xFF]' FILE | head` — if an edit span touches a flagged line, use a byte-safe edit (`LC_ALL=C sed` or python bytes I/O) and verify with a byte diff, per the project's standing MacRoman rule. The Edit tool corrupts those bytes.
- Use `/usr/bin/grep` in shell commands — the interactive shell's `grep` wrapper has been observed to swallow output.
- The intern pool (`lib.cla` `strPool`/`strIndex`) is NEVER reset in-process (`drive.cla:447` doc comment; `shake.cla:99-105`). Two `intern("x")` calls anywhere always return the same index, so `poolGet(a) == poolGet(b)` ⇔ `a == b` whenever both sides came from `intern`. This is the license for every int-compare conversion in this plan. **[AMENDED after Task 1]** Module-level `var x: int = intern("...")` initializers do NOT compile on the host-C lane (cprint.cla does not forward-declare user functions called from global initializers). Use the lazy-init pattern Task 1 landed instead: globals default to `-1`/uninitialized, filled by a `xxInit()` helper guarded by a `xxInited: bool`, called at the top of the consuming function(s). See `clarusc/tok.cla`'s `kwInit()`/`kwInited` for the canonical shape.
- Implementation subagents: `model: sonnet`; purely mechanical sweeps may use `haiku`. Every task gets a spec review + code review per subagent-driven-development.
- Commit per task, message prefix `perf:` (or `feat:` for Task 8, `chore:` for snapshot regens). Ledger: `.superpowers/sdd/2026-08-11-layer1-compiler-perf/progress.md`.

### Byte-identity gate (run per task)

Once per stage (start of phase, and again after the Task 9 snapshot regen), build the oracle and its reference forks:

```sh
cc -O1 -I runtime/host -o /tmp/l1boot clarusc/clarusc.c runtime/host/rt.c
mkdir -p /tmp/l1old /tmp/l1new
/tmp/l1boot emit68k --rtdir runtime/clarus/ -o /tmp/l1old/tick.bin testdata/cg68k/tickprobe.cla
/tmp/l1boot emit68k --rtdir runtime/clarus/ -o /tmp/l1old/cc.bin --partition 50331648 clarusc/macgui.cla
```

Per task, after `scripts/test-task.sh` (which refreshes `build-run/clarusc-current`):

```sh
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/l1new/tick.bin testdata/cg68k/tickprobe.cla
cmp /tmp/l1old/tick.bin /tmp/l1new/tick.bin && echo TICK-IDENTICAL
# Tasks 11-18 (backend): also the multi-segment proof (~32 segments).
# [AMENDED after Task 10] The input must be FROZEN source — compiling the working
# tree's macgui.cla conflates input-change with behavior-change, since macgui
# includes the very clarusc/*.cla being edited. /tmp/l1src is a git-archive of
# the Stage A2 commit (1ffb12d); /tmp/l1old/ccfrozen.bin was emitted from it by
# the A2 snapshot compiler.
build-run/clarusc-current emit68k --rtdir /tmp/l1src/runtime/clarus/ -o /tmp/l1new/ccfrozen.bin --partition 50331648 /tmp/l1src/clarusc/macgui.cla
cmp /tmp/l1old/ccfrozen.bin /tmp/l1new/ccfrozen.bin && echo CCFROZEN-IDENTICAL
```

Matched basenames are load-bearing (MacBinary embeds the output basename). The host C lane is covered by T1's `TestEmitUiGoldens` byte-compares; the 68k `.s` listings by `TestCg68kGoldens`.

### Benchmark commands

```sh
go test ./internal/claruscboot -count=1     # refresh build-run/clarusc-current
# A/B: run pre and post binaries alternately, 5 pairs, report median user time
/usr/bin/time -p /tmp/l1boot           emit --rtdir runtime/clarus/ -o /tmp/self_a.c clarusc/main.cla
/usr/bin/time -p build-run/clarusc-current emit --rtdir runtime/clarus/ -o /tmp/self_b.c clarusc/main.cla
# macro (backend tasks): emit68k of macgui (the ClarusC.APPL compile, minus --bake)
/usr/bin/time -p build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/l1new/cc.bin --partition 50331648 clarusc/macgui.cla
```

`/tmp/l1boot` is the phase-start compiler, so "pre" stays fixed as tasks accumulate; each task's report states cumulative gain.

---

### Task 0: Baseline measurements + perfgate re-baseline

**Files:**
- Modify: `internal/perfgate/baseline.txt`
- Create: `.superpowers/sdd/2026-08-11-layer1-compiler-perf/progress.md`

**Interfaces:** Produces the phase-start `/tmp/l1boot`, `/tmp/l1old/*.bin` reference forks, and recorded baseline timings all later tasks compare against.

- [ ] **Step 1: Build the oracle + reference forks** — run the once-per-stage block from "Byte-identity gate" above. Confirm both reference forks exist and `cmp /tmp/l1old/tick.bin /tmp/l1old/tick.bin` is trivially clean.
- [ ] **Step 2: Record baselines.** Run each benchmark command 5 times, record medians in `progress.md` under a `## Baseline (Task 0)` heading: (a) host `emit` self-compile of `clarusc/main.cla`, (b) host `emit68k` of `clarusc/macgui.cla`, (c) `emit` of `testdata/emitui/every.cla` (the perfgate fixture, for cross-checking).
- [ ] **Step 3: Re-baseline perfgate.** `internal/perfgate/baseline.txt` currently reads `0.3` (limit 0.6s) while the observed median is ~0.066s — toothless. Set it to the measured every.cla median rounded up to 2 significant figures (expected `0.07`).
- [ ] **Step 4: Run T1** — `scripts/test-task.sh`, expect PASS (perfgate must pass against the new tighter baseline; if the margin is <2×, bump to the next 0.01 and note why).
- [ ] **Step 5: Commit** — `chore: tighten perfgate baseline to measured median; record layer1 phase baselines`

---

### Task 1: `keywordKind` pre-interned keyword constants (findings §1.1)

**Files:**
- Modify: `clarusc/tok.cla:101-139`

**Interfaces:** Produces module globals `kwVar, kwFunc, kwRecord, kwEnum, kwConst, kwWindow, kwMenu, kwExtend, kwOn, kwEvery, kwIf, kwElse, kwWhile, kwFor, kwIn, kwTo, kwReturn, kwAnd, kwOr, kwNot, kwTrue, kwFalse, kwNil, kwOpen, kwClose, kwEdit, kwNew, kwQuit, kwCancel, kwSwitch, kwCase, kwBreak, kwContinue` (all `int`). No other task consumes them (parser contextual keywords get their own set in Task 4).

- [ ] **Step 1: MacRoman check** — `LC_ALL=C /usr/bin/grep -nP '[\x80-\xFF]' clarusc/tok.cla`. The `keywordKind` doc comment (~line 102) contains a MacRoman byte; do not route an Edit through that line — either leave the comment bytes untouched or use a byte-safe tool.
- [ ] **Step 2: Add the 33 pre-interned globals** immediately above `keywordKind` (tok.cla includes `lib.cla` first, so `strPool`/`strIndex` are initialized before these run):

```clarus
// Keyword name indices, interned once at startup (global initializers run
// in declaration order; lib.cla's pool is declared first and the pool is
// never reset in-process, so these stay valid for the process lifetime).
var kwVar: int = intern("var")
var kwFunc: int = intern("func")
var kwRecord: int = intern("record")
var kwEnum: int = intern("enum")
var kwConst: int = intern("const")
var kwWindow: int = intern("window")
var kwMenu: int = intern("menu")
var kwExtend: int = intern("extend")
var kwOn: int = intern("on")
var kwEvery: int = intern("every")
var kwIf: int = intern("if")
var kwElse: int = intern("else")
var kwWhile: int = intern("while")
var kwFor: int = intern("for")
var kwIn: int = intern("in")
var kwTo: int = intern("to")
var kwReturn: int = intern("return")
var kwAnd: int = intern("and")
var kwOr: int = intern("or")
var kwNot: int = intern("not")
var kwTrue: int = intern("true")
var kwFalse: int = intern("false")
var kwNil: int = intern("nil")
var kwOpen: int = intern("open")
var kwClose: int = intern("close")
var kwEdit: int = intern("edit")
var kwNew: int = intern("new")
var kwQuit: int = intern("quit")
var kwCancel: int = intern("cancel")
var kwSwitch: int = intern("switch")
var kwCase: int = intern("case")
var kwBreak: int = intern("break")
var kwContinue: int = intern("continue")
```

- [ ] **Step 3: Rewrite the `keywordKind` body** — same 33 arms, `if nameIdx == kwVar { return TkVar }` etc. No `intern()` calls remain in the function.
- [ ] **Step 4: Gates** — T1; byte-identity (tick). A/B self-compile, record.
- [ ] **Step 5: Commit** — `perf: pre-intern keyword names; keywordKind is 33 int compares (findings 1.1)`

---

### Task 2: `intern` single-probe (findings §1.8)

**Files:**
- Modify: `clarusc/lib.cla:11-21`

**Interfaces:** `intern(s: string): int` signature unchanged.

- [ ] **Step 1: Rewrite `intern`** to one probe on the hit path, using the `-1`-sentinel argument already written down for `scopeLookup` (`types.cla:672-676`) — pool indices are `strPool.count` at insert, always >= 0:

```clarus
// intern returns s's index in the pool, adding it if not already present.
// Single get(s, -1) probe on the hit path (rather than has()-then-get()):
// -1 is never a real pool index, same argument as scopeLookup's.
func intern(s: string): int {
    var idx: int

    idx = strIndex.get(s, -1)
    if idx != -1 {
        return idx
    }
    idx = strPool.count
    strPool.add(s)
    strIndex[s] = idx
    return idx
}
```

- [ ] **Step 2: Gates** — T1; byte-identity (tick).
- [ ] **Step 3: Commit** — `perf: intern hit path is a single map probe (findings 1.8)`

---

### Task 3: Memoize the `I*()` intrinsic-name helpers (findings §1.8)

**Files:**
- Modify: `clarusc/ir.cla` (intrinsic-name constants block, `ir.cla:2884` onward)

**Interfaces:** Every `I*()` helper keeps its exact name and signature (`func IStrConcat(): int` etc.) — Tasks 13/14 rely on them being cheap. Adds one `i*Memo` module var per helper.

- [ ] **Step 1: Enumerate the helpers** — `/usr/bin/grep -n 'return intern("' clarusc/ir.cla` within the intrinsic block (§ header `ir.cla:2884-2888`). Expect ~116.
- [ ] **Step 2: Convert each** to the lazy-memo form (the pool is never reset, so a first-call intern is valid forever; global initializers cannot call `intern()` — Task 1 discovery, see `kwInit()` in tok.cla):

```clarus
var iStrConcatIdx: int = -1

func IStrConcat(): int {
    if iStrConcatIdx == -1 {
        iStrConcatIdx = intern("str_concat")
    }
    return iStrConcatIdx
}
```

  One `var` per helper, named after the helper (`IStrConcat` → `iStrConcatIdx`), placed directly above it. (Per-helper lazy guards, NOT one shared init function — 116 interns on first touch would be fine too, but per-helper keeps each diff local and mechanical.) This is a mechanical sweep — a haiku-grade batch edit with a sonnet review. Keep the helpers themselves (155 cprint + 182 lower call sites stay untouched).
- [ ] **Step 3: Gates** — T1; byte-identity (tick). A/B self-compile, record (lower/shake/cprint all get cheaper; host `emit` should visibly improve).
- [ ] **Step 4: Commit** — `perf: memoize I*() intrinsic-name interns into startup globals (findings 1.8)`

---

### Task 4: Parser cursor caching + lexer length caching (findings §1.8)

**Files:**
- Modify: `clarusc/parse.cla:48-105` (+ mechanical call-site sweep), `clarusc/lex.cla`

**Interfaces:** `curKind()/curLine()/curCol()/peekKind()/advance()` signatures unchanged. Adds `curTokKind/curTokLine/curTokCol/curTokNameIdx` module globals and `curIsIdentIdx(idx: int): bool`. Contextual-keyword globals `cwApp` etc. are parse.cla-local.

- [ ] **Step 1: Add cached-cursor globals + sync** in parse.cla:

```clarus
var curTokKind: TokKind
var curTokLine: int
var curTokCol: int
var curTokNameIdx: int

// parseSyncCur refreshes the cached current-token fields. Call after every
// parseIdx change; curKind()/curLine()/curCol()/curIsIdentIdx read the
// cache instead of paying a bounds-checked list read + record copy each.
func parseSyncCur() {
    var t: Token

    t = toks[parseIdx]
    curTokKind = t.kind
    curTokLine = t.line
    curTokCol = t.col
    curTokNameIdx = t.nameIdx
}
```

- [ ] **Step 2: Rewire the helpers** — `curKind()` returns `curTokKind`; `curLine()`/`curCol()` likewise; `advance()` increments then calls `parseSyncCur()`. Find every other `parseIdx` assignment (`/usr/bin/grep -n 'parseIdx =' clarusc/parse.cla` — expect `parseReset` and the parse entry) and add `parseSyncCur()` after each. `curTok()`/`peekKind()` stay as-is (record consumers).
- [ ] **Step 3: Contextual keywords by int** — add `curIsIdentIdx`:

```clarus
func curIsIdentIdx(idx: int): bool {
    return curTokKind == TkIdent and curTokNameIdx == idx
}
```

  Enumerate the 27 `curIsIdentText("...")` literals (`/usr/bin/grep -n 'curIsIdentText(' clarusc/parse.cla`), add one `var cwXxx: int` global per distinct literal filled by a `cwInit()`/`cwInited` lazy guard (Task 1's `kwInit()` pattern — global initializers cannot call `intern()`), called from `parseReset` (which runs before any parsing), and convert every call site to `curIsIdentIdx(cwXxx)`. Delete `curIsIdentText` if no callers remain.
- [ ] **Step 4: The two `"app"` probes** — `parse.cla:570` becomes `t.nameIdx == cwApp` (token already in hand); `parse.cla:1846` becomes `curTokNameIdx == cwApp`. Both keep their `peekKind()` conjuncts.
- [ ] **Step 5: Lexer length cache** — in lex.cla add `var lexLen: int`, set `lexLen = lexSrc.length` in `lexInit`, and replace every `lexSrc.length` read in the scanning loops (`/usr/bin/grep -n 'lexSrc.length' clarusc/lex.cla`) with `lexLen`. `lexSrc` is immutable during a lex pass. Do NOT restructure the byte reads themselves (`text[i]` inlining is Layer 2).
- [ ] **Step 6: Gates** — T1; byte-identity (tick). A/B self-compile, record.
- [ ] **Step 7: Commit** — `perf: cache parser cursor fields + lexer length; contextual keywords compare interned ints (findings 1.8)`

---

### Task 5: Checker int-compare bundle (findings §1.8)

**Files:**
- Modify: `clarusc/check.cla`, `clarusc/types.cla:428-438`

**Interfaces:** Adds check.cla module globals `cnInt, cnBool, cnFixed, cnChar, cnText, cnPtr, cnFile, cnIsNew, cnFront, cnNow, cnDateTimeStr, cnDurationStr` (filled by a `cnInit()`/`cnInited` lazy guard called at the top of `checkReset` — Task 1's `kwInit()` pattern; global initializers cannot call `intern()`).

- [ ] **Step 1: `resolveType` (`check.cla:1711-1744`)** — replace the six `name == "int"`-style compares with `nameIdx == cnInt` etc.; delete the unconditional `name = poolGet(nameIdx)` (fetch it lazily inside any failure/diagnostic branch that still needs the string).
- [ ] **Step 2: `checkIdentCall` (`check.cla:4916-4937`)** — same conversion for the 4 conversion probes and the 3 datetime probes (`identName(fn)` is already in hand); keep `poolGet` only where a diagnostic message needs the text.
- [ ] **Step 3: The two `"file"` probes** — `check.cla:1635` and `check.cla:4674` become `identName(x) == cnFile`.
- [ ] **Step 4: Field/member scans → int compares.** At each of these sites the scan compares `poolGet(<something>.nameIdx) == name` where `name` was itself fetched by `poolGet` from an interned index. Hoist the wanted index into a local `want: int` and compare ints; drop the string locals where they become dead:
  - `check.cla:4698, 4710, 4728` (checkSelect rec/overlay/xrec field scans; want = `selectName(e)`)
  - `check.cla:3717` (`isNew` shadow probe → `fieldInfos[fh].nameIdx == cnIsNew`)
  - `check.cla:3689-3699` (`readOnlyPropName`'s `"front"` probe → `selectName(sel) == cnFront`)
  - `check.cla:3134` (column `shows`), `check.cla:3175` (`checkBindsProperty`), `check.cla:3274/3281` (window field/widget scans), `check.cla:4316` (enum member scan)
  - Leave `findWidgetKind` (`check.cla:3310`) and the string-keyed window maps alone — Task 6 re-keys them.
- [ ] **Step 5: `readOnlyPropName` memo reuse (`check.cla:3699`)** — replace `xt = checkExpr(selectX(sel), -1)` with:

```clarus
    xt = exprTypeGet(selectX(sel))
    if xt == InvalidT {
        return ""
    }
```

  The receiver was fully checked moments earlier by `checkAssignStmt`'s `checkExpr(lhs, -1)` → `checkSelect` → `checkExpr(x, -1)`, so the memo is warm; `InvalidT` means the receiver already failed, and a read-only-property complaint on a broken receiver is noise. **This can change diagnostics** — run the error goldens (Step 7) and inspect any diff; if a fixture legitimately loses a duplicate diagnostic, bless is NOT allowed without flagging it in the task report for review.
- [ ] **Step 6: `assignable` early-out (`types.cla:428-438`)** — add `if src == dst { return true }` as the first statement. Update the doc comment: the byte-exact-port rationale is obsolete (the Go compiler is deleted); note that for `src == dst` every kind arm returns true anyway (verified: TyStr ignores capacity, container arms recurse into equal indices).
- [ ] **Step 7: Gates** — T1; byte-identity (tick); `go test ./internal/selfhost -run TestErrorGoldens -count=1 -timeout 30m` — must PASS with zero golden churn except any Step-5 case explicitly justified in the task report.
- [ ] **Step 8: Commit** — `perf: checker compares interned ints for builtins/fields/members; assignable fast path; readOnlyPropName reuses expr type memo (findings 1.8)`

---

### Task 6: Checker string-keyed maps → intmap (findings §1.8)

**Files:**
- Modify: `clarusc/check.cla:91-144, 683-706, 1399, 3274-3310, 4978`

**Interfaces:** `recordFieldsHead(nameIdx: int): int` / `setRecordFields(nameIdx: int, head: int)` signatures unchanged (internal re-key only). Window lookups change key type from `winName: string` to the interned `typeNameIdx` int — callers inside check.cla only.

- [ ] **Step 1: `recFieldsHeadByName` → intmap.** Change the declaration to `var recFieldsHeadByName: intmap of int`, drop both `poolGet` round-trips (`check.cla:112-118`): `recFieldsHeadByName.get(nameIdx, -1)` / `recFieldsHeadByName[nameIdx] = head`. Mirror the reset the same way the other intmaps are reset in `checkReset` (fresh-map assignment).
- [ ] **Step 2: `windowVarsHead` / `windowWidgetsHead` → intmap** keyed by the window's interned name index. Trace every writer/reader (`/usr/bin/grep -n 'windowVarsHead\|windowWidgetsHead' clarusc/check.cla`); writers have the interned index at registration; readers at `check.cla:3274/3281` currently do `winName = poolGet(typeNameIdx(xt))` — pass `typeNameIdx(xt)` instead. `findWidgetKind` (`check.cla:3310`) changes its `winName: string` parameter to `winNameIdx: int` accordingly (update its callers).
- [ ] **Step 3: `widgetRuntimeProps` single probe (`check.cla:1399, 3299`)** — collapse `has(key)` + `get(key, InvalidT)` to one `get(key, InvalidT)` call with the miss branch testing the sentinel. First verify `InvalidT` is never a stored value (`/usr/bin/grep -n 'widgetRuntimeProps\[' clarusc/check.cla` — values are real prop types); write that argument in a comment, same style as `scopeLookup`'s. Keep the string key (two-part composite; not worth a scheme change).
- [ ] **Step 4: Fix the stale comment** at `check.cla:4978` — it still says `exprTypeOf` is "keyed by numToStr(e)"; rewrite to describe the intmap keying.
- [ ] **Step 5: Gates** — T1; byte-identity (tick); error goldens (zero churn expected).
- [ ] **Step 6: Commit** — `perf: re-key record/window member tables by interned index; single-probe widget props (findings 1.8)`

---

### Task 7: Free block scopes on exit (findings §1.8)

**Files:**
- Modify: `clarusc/types.cla` (add `scopesTruncate`), `clarusc/check.cla` block-scope sites

**Interfaces:** Produces `scopesTruncate(mark: int)` in types.cla.

- [ ] **Step 1: Verify LIFO safety.** Enumerate every `scopeNew` caller (`/usr/bin/grep -n 'scopeNew(' clarusc/*.cla`) and every place a scope index is *stored* (`funcScopeByDecl` writes, `check.cla:2333`; `universeScope`/`topScope`/`curScope`). Confirm: function scopes (stored, must persist) are created only at decl-registration points, never inside a block body; block scopes are created and abandoned strictly LIFO with nothing storing their indices. Record the enumeration in the task report. If ANY block-scope index escapes, stop and report instead of implementing.
- [ ] **Step 2: Add `scopesTruncate`** to types.cla:

```clarus
// scopesTruncate pops every scope at index >= mark. Callers pass the
// scopes.count captured BEFORE their scopeNew: block scopes are strictly
// LIFO and nothing stores a block scope's index (funcScopeByDecl only
// ever stores function scopes, created outside any block), so popping
// frees each block's Scope record and its names intmap immediately
// instead of leaking ~one live intmap per block until checkReset.
func scopesTruncate(mark: int) {
    while scopes.count > mark {
        scopes.pop()
    }
}
```

- [ ] **Step 3: Apply at each block-scope site** found in Step 1 (expected: `checkBlock` `check.cla:3782-3800`, the loop/switch bodies `check.cla:3939/3954/3996`, and `check.cla:3413`; NOT `check.cla:2312` if that is the function-scope creation — Step 1 decides):

```clarus
    saved = curScope
    mark = scopes.count
    curScope = scopeNew(saved)
    ...
    curScope = saved
    scopesTruncate(mark)
```

- [ ] **Step 4: Gates** — T1; byte-identity (tick); error goldens (zero churn expected — scope *contents* during checking are unchanged, only post-exit lifetime).
- [ ] **Step 5: Commit** — `perf: free block scopes on exit instead of leaking until checkReset (findings 1.8)`

---

### Task 8: `.clear()` for list / map / intmap / sortedmap (language feature; enables findings §1.8 arena clears)

**Files:**
- Modify: `clarusc/check.cla:1535-1626` (list + map method arms), `clarusc/lower.cla` (method lowering), `clarusc/ir.cla` (intrinsic names), `clarusc/cprint.cla` (host dispatch), `clarusc/cg68k.cla` (native dispatch), `docs/clarus-language-reference.md` (Lists + Maps sections), `testsuite/core/cases_list.cla`, `testsuite/core/cases_map.cla`, `testsuite/core/runner.cla`, `internal/testsuite/core_cli_test.go`, `internal/mactest/coresuite_test.go`
- Runtime is already written: `rtListClear` (`runtime/clarus/list.cla:444`), `rtMapClear` (`map.cla:785`), `rtIntMapClear`, `rtSortedMapClear` (verify the last exists; if not, scope sortedmap out and say so), host mirrors in `runtime/host/rt_core.inc` (`rt_list_clear` at :724 etc.).

**Interfaces:** Produces surface syntax `xs.clear()` (returns nothing, zero args) for `list of T`, `map of T`, `intmap of T`, `sortedmap of T`; intrinsic names `IListClear()`, `IMapClear()`, `IIntMapClear()`, `ISortedMapClear()` in ir.cla (memoized form per Task 3). Task 10 consumes the surface syntax.

- [ ] **Step 1: Write the failing test** — add a `ClearBasics` case to `testsuite/core/cases_list.cla` (and a map/intmap clear assertion inside it or a sibling in `cases_map.cla`): build a list, `xs.clear()`, assert `xs.count == 0`, re-add and assert contents; same for a `map of int` and an `intmap of int` (count 0 after clear, `has` false, re-insert works). Register it in `runner.cla`'s enum + dispatch (57 → 58 cases; follow the datetime phase's diff shape for adding a case).
- [ ] **Step 2: Update the harness counts** — `internal/testsuite/core_cli_test.go` `wantCases` list + arithmetic (58), `internal/mactest/coresuite_test.go` 57→58 expectations (`:93-117` region). Run `go test ./internal/testsuite -count=1` — expect FAIL (checker rejects `.clear()`): red confirmed.
- [ ] **Step 3: Checker arms** — in `checkListMethod` (`check.cla:1535-1573`) and `checkMapMethod` (`check.cla:1576-1626`) add a `clear` arm: zero args, result type void (mirror the existing zero-arg `pop`-style arms' shape for arg-count diagnostics).
- [ ] **Step 4: Intrinsics + lowering** — add the four `I*Clear()` helpers in ir.cla's intrinsic block (memoized form). In lower.cla's list/map method lowering (find the `pop`/`remove` arms), route `clear` to an intrinsic call with the receiver as sole arg, dispatched by receiver type kind to the right `I*Clear()` name.
- [ ] **Step 5: Backends** — cprint.cla `fpIntrCall*`: arms emitting `rt_list_clear(...)` / `rt_map_clear(...)` / `rt_intmap_clear(...)` / `rt_sortedmap_clear(...)` (match the C names in `rt_core.inc`). cg68k.cla `cgIntr`: arms calling `cgCallRuntime` for `rtListClear` / `rtMapClear` / `rtIntMapClear` / `rtSortedMapClear` (match the existing single-ptr-arg call shapes, e.g. the `pop` intrinsic's arm).
- [ ] **Step 6: Reference** — add `l.clear()` to the Lists operation list and `m.clear()` to the map-family sections of `docs/clarus-language-reference.md`, noting count→0, capacity retained.
- [ ] **Step 7: Gates** — `go test ./internal/testsuite -count=1` now PASSES (58 cases); full T1; byte-identity (tick — existing programs don't use clear, bytes identical); error goldens (no diagnostic text changed).
- [ ] **Step 8: Commit** — `feat: .clear() for list/map/intmap/sortedmap (runtime fns already existed; enables O(1) arena resets)`

---

### Task 9: Snapshot regeneration Stage A

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)

The committed snapshot compiler must learn `.clear()` before Task 10 can use it in clarusc's own source (the snapshot bootstraps stage 1 of every build).

- [ ] **Step 1: Regenerate** (the fixed-point procedure):

```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```

- [ ] **Step 2: Verify fixed point** — `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m -v` (≈15s), expect PASS.
- [ ] **Step 3: Rebuild the byte-identity oracle** — re-run the once-per-stage block from "Byte-identity gate" (new `/tmp/l1boot`, new `/tmp/l1old` forks). Note in the ledger that the oracle rolled forward at this task.
- [ ] **Step 4: Run T1** — PASS.
- [ ] **Step 5: Commit** — `chore: regenerate clarusc.c snapshot (Stage A: .clear() in-tree)`

---

### Task 10: Arena resets use `.clear()` (findings §1.8)

**Files:**
- Modify: `clarusc/lex.cla:645-647`, `clarusc/ast.cla:370-383`, `clarusc/lib.cla:84-94`, `clarusc/types.cla:418-426, 695-705`, `clarusc/check.cla:5141-5158`, `clarusc/ir.cla:1012-1102`, plus any other pop-loop drains in `clarusc/` (`asm68k.cla`'s `a68Reset`, `cg68k.cla`, `cprint.cla`, `drive.cla`, `uiblob.cla`)

**Interfaces:** Consumes Task 8's `.clear()`.

- [ ] **Step 1: Enumerate** every drain: `/usr/bin/grep -n -B1 '\.pop()' clarusc/*.cla | /usr/bin/grep -A1 'count > 0'` (and eyeball each hit). Expected ≥46 across the files above; `a68Reset`'s `a68Items` drain (384-byte records until Task 17 lands) is the single biggest.
- [ ] **Step 2: Replace** each `while xs.count > 0 { xs.pop() }` with `xs.clear()`. ONLY where the loop body is exactly the pop — any drain that uses the popped value stays.
- [ ] **Step 3: Gates** — T1; byte-identity (tick). (`clear` semantics = count 0, capacity kept — identical to a pop-drain's end state.)
- [ ] **Step 4: Commit** — `perf: arena resets via .clear() instead of pop loops (findings 1.8)`

---

### Task 11: `cgHeurOnCycle` — measure-pass guard + one SCC pass (findings §1.3)

**Files:**
- Modify: `clarusc/cg68k.cla:1812-1867, 2035-2117` (+ new adjacency/SCC helpers nearby)

**Interfaces:** `cgStackHeuristic()` signature unchanged. `cgHeurOnCycle(start)` is replaced by a precomputed `cgOnCycleTab: list of bool`.

- [ ] **Step 1: Measure-pass guard.** `cg68Measure`'s own comment (`cg68k.cla:10758-10773`) proves the heuristic's *value* is discarded during measurement (frame sizes all zero → floor; only the fixed 6-byte ADDA size matters, and `cgEmitStartup`'s items are never peepholed). Add an early return at the top of `cgStackHeuristic` (after the `irAppStack` fast exit) returning the same floor constant the zero-data path produces, guarded by the measure-mode flag (`cgRecMode == 2` — verify the exact mode value at the `cg68k.cla:10782` call site before writing the guard). Read the zero-data fall-through to identify the floor (the comment says 32768; confirm in code and reuse the same named constant/expression).
- [ ] **Step 2: Build an adjacency index once per emit pass.** After `shakeProgram` the edge lists are immutable. Add CSR-style module state + builder:

```clarus
// Adjacency index over shake's per-call-site edge lists, built once per
// cgStackHeuristic call: cgAdjHead[f] is f's first out-edge or -1,
// cgAdjNext[j] chains edges sharing a source, cgAdjTo[j] is edge j's
// callee. Replaces the per-node whole-edge-list rescans (findings 1.3).
var cgAdjHead: list of int
var cgAdjNext: list of int
var cgAdjTo: list of int

func cgBuildAdjacency() {
    var i: int
    var n: int

    cgAdjHead = cgFreshIntList()
    cgAdjNext = cgFreshIntList()
    cgAdjTo = cgFreshIntList()
    i = 0
    while i < irFuncs.count {
        cgAdjHead.add(-1)
        i = i + 1
    }
    n = shakeEdgeCount()
    i = 0
    while i < n {
        cgAdjTo.add(shakeEdgeTo(i))
        cgAdjNext.add(cgAdjHead[shakeEdgeFrom(i)])
        cgAdjHead[shakeEdgeFrom(i)] = cgAdjTo.count - 1
        i = i + 1
    }
}
```

  (Hoist `shakeEdgeCount()` out of loop bounds, as here — the current code calls it per edge visit.)
- [ ] **Step 3: One iterative SCC pass → `cgOnCycleTab`.** Implement iterative Tarjan (explicit `list of int` stacks — NOT recursion: this code also runs on the Mac, where frames are ≥8KB and the call graph is ~1,600 deep in the worst case). A function is "on a cycle" iff its SCC has size > 1, or it has a self-edge (detect self-edges during the walk or in `cgBuildAdjacency`). Fill `cgOnCycleTab: list of bool` sized `irFuncs.count`. Compute it at the top of `cgStackHeuristic` (after the guards), then the driver loop (`cg68k.cla:2070-2077`) tests `cgOnCycleTab[i]` instead of calling `cgHeurOnCycle(i)`. Delete `cgHeurOnCycle`. Also convert `cgHeurLongest`'s per-node edge rescan (`cg68k.cla:1785-1810`) to walk `cgAdjHead`/`cgAdjNext`/`cgAdjTo` — it keeps its existing memoization.
- [ ] **Step 4: Gates** — T1; byte-identity (tick + cc.bin — the multi-segment fork is the real proof: same on-cycle verdicts ⇒ same `_SetApplLimit` immediate ⇒ identical bytes). A/B macro benchmark (emit68k of macgui), record.
- [ ] **Step 5: Commit** — `perf: stack heuristic uses adjacency index + one SCC pass; skip during measure (findings 1.3)`

---

### Task 12: cg68k record/type/extern lookups + `cgSizeOf` memo (findings §1.4)

**Files:**
- Modify: `clarusc/cg68k.cla:1178-1249, 1401-1471, 3478-3503`, `clarusc/ir.cla:930-954`

**Interfaces:** All function signatures unchanged (`cgFindRecordByName(nameIdx)`, `cgFieldOffset(recName, fieldName)`, `cgSizeOf(t)`, `irExternLookup(nameIdx)`).

- [ ] **Step 1: Int compares.** The intern pool guarantees index equality ⇔ string equality (Global Constraints), and the doc comment on `cgFindSerdescLabel` claiming otherwise (`cg68k.cla:3478-3503`) is factually wrong — `shake.cla:99-105` already relies on the invariant. Convert:
  - `cgFindRecordByName` (`:1401-1418`): `if irRecordLayoutName(i) == nameIdx` — delete the `poolGet`s and the stale comment.
  - `cgFieldOffset` (`:1420-1450`): `if irFieldSlotName(f) == fieldName`; drop `wantName`.
  - `cgFindSerdescLabel` (`:3478-3503`): same int compare; PRESERVE the `cgRecordSerdesc(i)` side effect exactly.
  - `irExternLookup` (`ir.cla:930-954`): `if irExternNames[i] == nameIdx`; drop both `poolGet`s. (Fixes `irIsExtern` and `irRegisterExtern` dedup in one edit.)
- [ ] **Step 2: Record-index map.** Add `var cgRecIdxByName: intmap of int` + `var cgRecIdxByNameValid: bool`, invalidated at the top of `cg68ProgramFork` (both passes share one compile's `irRecords`). `cgFindRecordByName` builds it on first call (walk `irRecords` once, first-wins on duplicates to match the scan) then answers with `get(nameIdx, -1)`.
- [ ] **Step 3: `cgSizeOf` memo.** Add `var cgSizeMemo: list of int` (parallel to `irTypes`, `-1` = unknown), cleared at `cg68ProgramFork` entry alongside Step 2's flag:

```clarus
func cgSizeOf(t: int): int {
    var sz: int

    while cgSizeMemo.count < irTypes.count {
        cgSizeMemo.add(-1)
    }
    if cgSizeMemo[t] != -1 {
        return cgSizeMemo[t]
    }
    sz = cgSizeOfUncached(t)
    cgSizeMemo[t] = sz
    return sz
}
```

  where `cgSizeOfUncached` is the existing switch body renamed. Types are append-only and per-index immutable, so the memo is sound; the grow-loop handles types created mid-codegen. (66 direct call sites plus `cgAlignOf`/`cgSlotSizeOf`/`cgRecFieldSizeOf`/`cgArrElemStride` fan-in all get the benefit with zero call-site edits.)
- [ ] **Step 4: Gates** — T1; byte-identity (tick + cc.bin). A/B macro benchmark, record.
- [ ] **Step 5: Commit** — `perf: int-compare record/field/serdesc/extern lookups; record-index map; cgSizeOf memo (findings 1.4)`

---

### Task 13: cg68k frame/global/function-name lookups (findings §1.4)

**Files:**
- Modify: `clarusc/cg68k.cla:466-473, 1672-1740, 4199-4295, 4339-4347` (+ the `cgCallRuntime`/`cgJsrByName` literal sites), `clarusc/ir.cla:1923-1934` (+ `newIRFunc`, `irReset`)

**Interfaces:** `cgVarOff(e)`, `findIRFuncIdxByName(nameIdx)` signatures unchanged. `cgFindFrameOffset`/`cgFindGlobalOffset` change parameter from `nm: string` to `nameIdx: int` (all callers are in cg68k.cla: `cgVarOff`, `cgXRecAddrDisp`).

- [ ] **Step 1: Frame table by interned index.** Add `var cgCurFrameNameIdxs: list of int` parallel to `cgCurFrameNames` (`cg68k.cla:466-473`). At the rebuild site (`cg68k.cla:4002-4003`) populate it alongside (the names were built from interned indices — pass those through rather than re-interning; read the frame-layout construction to find them). In `cgVarRefAt` (`:4339-4347`) append `intern(nm)` for the synthetic scratch name. `cgFindFrameOffset(nameIdx: int)` scans `cgCurFrameNameIdxs` with int compares. Keep `cgCurFrameNames` itself — the listing comments read it (and Task 18 leaves that alone).
- [ ] **Step 2: Global offsets map.** In `cgAssignGlobalOffsets` (`cg68k.cla:1672+`), after assigning each offset, record `cgGlobalOffByName[irGlobalName(i)] = off` in a fresh `intmap of int` (fresh-assigned at the function's top, once per pass). `cgFindGlobalOffset(nameIdx: int)` = `cgGlobalOffByName.get(nameIdx, cgUnresolved)` — `cgUnresolved` (`0x7FFFFFFF`) is already the never-a-real-offset sentinel.
- [ ] **Step 3: `cgVarOff` / `cgXRecAddrDisp`** (`:4243-4295`) — pass `irVarRefName(e)` straight through; `poolGet` only in the unresolved-quit diagnostic path.
- [ ] **Step 4: `findIRFuncIdxByName` via intmap.** Add `var irFuncIdxByName: intmap of int` to ir.cla; write `if not irFuncIdxByName.has(nameIdx) { irFuncIdxByName[nameIdx] = irFuncs.count - 1 }` in `newIRFunc` (first-wins matches the linear scan's first-match semantics); fresh-assign it in `irReset`. `findIRFuncIdxByName` becomes `return irFuncIdxByName.get(nameIdx, -1)`. This serves cprint's host lane too — the map is maintained at registration, not shake time, so it is valid on every lane.
- [ ] **Step 5: Pre-interned runtime-call names.** Enumerate `/usr/bin/grep -n 'cgCallRuntime("\|cgJsrByName("\|findIRFuncIdxByName(intern(' clarusc/cg68k.cla` (~34 `intern("...")` literal sites + the string-taking helpers). Change `cgCallRuntime`/`cgJsrByName` (and any sibling taking a runtime name string) to take `nameIdx: int`; add one `var rnXxx: int` module global per distinct literal, filled by an `rnInit()`/`rnInited` lazy guard called at `cg68ProgramFork` entry (Task 1's `kwInit()` pattern — global initializers cannot call `intern()`; ~40 names, placed together near the top of cg68k.cla); convert every call site. Diagnostic messages inside those helpers fetch `poolGet(nameIdx)` lazily.
- [ ] **Step 6: Gates** — T1; byte-identity (tick + cc.bin). A/B macro benchmark, record.
- [ ] **Step 7: Commit** — `perf: frame/global/function-name lookups by interned index + maps; pre-interned runtime call names (findings 1.4)`

---

### Task 14: `cgIntr`/`cgIntrUi`/operator dispatch on interned ints (findings §1.5)

**Files:**
- Modify: `clarusc/cg68k.cla:4401, 4862, 4958-5081, 6453-6980, 7121-7500, 7820`, `clarusc/ir.cla` (any missing `I*()` helpers), `clarusc/lower.cla:3302-3310`

**Interfaces:** `cgIntrUi(e, nm)` parameter changes to `nm: int`. Consumes Task 3's memoized `I*()` helpers.

- [ ] **Step 1: `cgIntr` head (`:6453-6465`)** — `nm` becomes `int` = `irIntrName(e)`; delete the `poolGet` and the hand-unrolled `ui_` prefix test. Routing: convert all non-UI arms to `if nm == IStrCmp() { ... }` style (each arm's `I*()` helper already exists — cprint dispatches on exactly these; any missing helper gets added in ir.cla in the Task 3 memoized form), and after the last non-UI arm falls through, call `cgIntrUi(e, nm)`; `cgIntrUi` tries its 37 arms and its existing unknown-intrinsic error path does `poolGet(nm)` for the message.
- [ ] **Step 2: `cgIntrUi` (`:7121-7500`)** — parameter `nm: int`; all arms `if nm == IUiOpen() { ... }` etc.
- [ ] **Step 3: One-off hot compares** — `cg68k.cla:4401` and `:7820` (`ui_value_at_ptr`) and `:4862` (`lasterr_value`): compare `irIntrName(...)` against the corresponding `I*()` helper.
- [ ] **Step 4: Operator dispatch (`:4958-5081`)** — `cgCcFor`/`cgIsCompareOp`/`cgArith`/`cgLogical`/`cgUnary` currently take/compare `op: string` from `poolGet(irBinOp(e))`. Convert the chain to `int` compares. Check ir.cla for existing operator-name helpers; if none, add memoized `IOpAdd()`-family helpers for exactly the operator literals these functions compare (enumerate them from the code, e.g. `"+", "-", "*", "/", "mod", "==", "!=", "<", "<=", ">", ">=", "and", "or", "not"`), following the intrinsic-block naming style.
- [ ] **Step 5: `lower.cla:3302-3310`** — `isWindowTitleSelect`'s `poolGet(selectName(e)) != "title"` becomes an int compare against a memoized helper or a lower.cla-local pre-interned `var lwTitleIdx: int = intern("title")`.
- [ ] **Step 6: Gates** — T1; byte-identity (tick + cc.bin). A/B macro benchmark, record. This is the sweep with the most arms (~150) — the review pass must diff-check that every arm's literal maps to the same-named helper (`"str_cmp"` ↔ `IStrCmp()`), the exact bug class byte-identity exists to catch.
- [ ] **Step 7: Commit** — `perf: cgIntr/cgIntrUi/operator dispatch compares interned ints, cprint-style (findings 1.5)`

---

### Task 15: Constant-pool membership — epoch stamps + segment bitmaps (findings §1.8)

**Files:**
- Modify: `clarusc/cg68k.cla:298-371, 393-460, 3461-3476, 10958-11093` (+ `cgReserveStrLitLabels` sibling)

**Interfaces:** `cgRecordStrLit`/`cgRecordEnumTable`/`cgRecordSerdesc` and `cgPoolDeltaPeek`/`cgPoolDeltaAndUnion` signatures may gain a bitmap parameter — internal to cg68k.cla.

- [ ] **Step 1: Recording paths (measure pass) → epoch stamps.** `cgRecordStrLit` (`:325-339`) tests membership in the *current function's* list only. Add `var cgStrLitSeen: list of int` sized `irStrLits.count` (and siblings for enum tables / serdescs, sized `irEnums.count` / `irRecords.count`), values = last stamp that saw the entry, plus `var cgSeenEpoch: int` bumped per `cgRecFuncIdx` change (and per `cgRecMode` 2/3 stream). Membership: `cgStrLitSeen[litIdx] == cgSeenEpoch` — O(1), no clearing between functions. Size the stamp lists once at `cg68Measure` entry (universes are dense IR-arena indices, fixed after lowering — verified).
- [ ] **Step 2: Pack loop → per-segment bitmaps.** `cgPackProgram`'s first-fit (`:10958-10991`) probes candidate sets against per-segment accumulated sets via `cgIntListHas`. Maintain `list of bool` bitmaps parallel to `segStrSets[s]`/`segEnumSets[s]`/`segSerdescSets[s]`: allocate all-false per fresh segment, set bits on union commit, REBUILD from the list on the wholesale replaces (`segStrSets[0] = cgAllStrLits` at `:11085` and the fresh-segment construction at `:10996-11046`). `cgPoolDeltaPeek` takes the bitmap and tests `bitmap[cand[i]]` instead of scanning. Keep the ordered lists untouched — emission order depends on them (`:11078-11084` comment).
- [ ] **Step 3: Reserve paths** — `cgReserveSerdescLabels` (`:3461-3476`) and the `cgReserveStrLitLabels` sibling probe `cgCurPool*` per arena entry; give `cgCurPool*` assignment sites a parallel bitmap too (built once when `cgCurPool*` is assigned, both in `cg68Measure` and the per-segment emit loop).
- [ ] **Step 4: Update the ponytail note** at `cg68k.cla:298-303` — its "not a hot path" claim is what this task retires; `cgIntListHas` itself stays for any remaining cold callers.
- [ ] **Step 5: Gates** — T1; byte-identity (tick + cc.bin — segment packing decisions must be bit-for-bit unchanged). A/B macro benchmark, record.
- [ ] **Step 6: Commit** — `perf: pool membership via epoch stamps + segment bitmaps (findings 1.8)`

---

### Task 16: Peephole reads/writes in place (findings §1.6a)

**Files:**
- Modify: `clarusc/peep68k.cla:47-290`, `clarusc/asm68k.cla:281-299` (`a68Relayout`)

**Interfaces:** No signature changes.

- [ ] **Step 1: `peepKill` (`:47-54`)** — two in-place stores (`ir.cla:1261` proves indexed field stores are legal):

```clarus
func peepKill(i: int) {
    a68Items[i].kind = KindDead
    a68Items[i].len = 0
}
```

- [ ] **Step 2: Every `it = a68Items[i]` copy** in peep68k.cla (`:75-87, 110-122, 141, 175-186, 215-221, 261-269`) — replace record-copy locals with direct field reads (`a68Items[i].op`, `a68Items[i].sm`, …) and direct field writes for the mutation sites. The guard chains at `:38, :112, :117` already read in place — extend that style to the whole file. Where a pass reads the same field 3+ times, a scalar local (`op = a68Items[i].op`) is fine; never copy the record.
- [ ] **Step 3: `a68Relayout` (`asm68k.cla:281-299`)** — same conversion: compute `len`/`addr` via direct field access.
- [ ] **Step 4: Gates** — T1; byte-identity (tick + cc.bin); `TestCg68kGoldens` is in T1 and pins the `.s` listings. A/B macro benchmark, record.
- [ ] **Step 5: Commit** — `perf: peephole and relayout access A68Items in place, no 384-byte record copies (findings 1.6)`

---

### Task 17: Shrink `A68Item` to plain ints via side tables (findings §1.6b)

**Files:**
- Modify: `clarusc/asm68k.cla` (record def `:180-201`, `a68Comment` `:435-443`, `a68EmitTrap`, the `a68Data*` emitters, `a68Reset`, the encoder's dataText consumer, the listing printer `:1452` region), `clarusc/cg68k.cla` (any direct `trapName`/`commentText`/`dataText` field access — enumerate)

**Interfaces:** `A68Item` loses `trapName: string(63)`, `commentText: string(255)`, `dataText: text`; gains `trapNameIdx: int`, `commentIdx: int`, `dataTextIdx: int` (all `-1` = none). New side tables `var a68CommentTexts: list of string` and `var a68DataTexts: list of text` in asm68k.cla; trap names go through the intern pool (`poolGet` at print time). Emitter helper signatures (`a68EmitTrap(word, name)` etc.) unchanged. Task 18 consumes `commentIdx`.

- [ ] **Step 1: Change the record** — replace the three fat fields with the three int fields (record drops 384 → 72 bytes; every `a68Items.add` and every remaining record copy shrinks 5×, and per-copy ARC traffic on the embedded `text` handle disappears).
- [ ] **Step 2: Writers** — `a68EmitTrap`: `it.trapNameIdx = intern(name)`. `a68Comment`: append `s` to `a68CommentTexts`, store the index. Data emitters: append the `text` to `a68DataTexts`, store the index. All other item constructors set the three fields to `-1` (find every `A68Item` local construction in asm68k.cla/cg68k.cla — `/usr/bin/grep -n 'var it: A68Item\|: A68Item' clarusc/*.cla`).
- [ ] **Step 3: Readers** — listing printer (`asm68k.cla:1452` region): `a68CommentTexts[a68Items[i].commentIdx]` / `poolGet(a68Items[i].trapNameIdx)` guarded by `!= -1`; encoder's data path reads `a68DataTexts[...]`. Enumerate every consumer with `/usr/bin/grep -n 'trapName\|commentText\|dataText' clarusc/*.cla` and convert each.
- [ ] **Step 4: `a68Reset`** — clear both side tables (with `.clear()`, per Task 10).
- [ ] **Step 5: Gates** — T1; byte-identity (tick + cc.bin); `.s` listings pinned by `TestCg68kGoldens` (trap names and comments must print identically). A/B macro benchmark + peak-RSS spot check (`/usr/bin/time -l`, record MaxRSS delta), record.
- [ ] **Step 6: Commit** — `perf: A68Item shrinks 384B -> 72B ints; trap/comment/data text in side tables (findings 1.6)`

---

### Task 18: Gate listing-comment construction (findings §1.8)

**Files:**
- Modify: `clarusc/asm68k.cla` (`a68Comment` + new `a68CommentMarker`), `clarusc/drive.cla:1410-1419` (`driveEmit68kFork`), `clarusc/cg68k.cla` comment call sites (31; hot ones `:1712-1719, 3856, 3897-3901, 3922, 4117, 4156`)

**Interfaces:** Adds `var a68ListingOn: bool` (asm68k.cla) and `func a68CommentMarker()`. Consumes Task 17's `commentIdx`.

**CRITICAL invariant:** comment ITEMS must still be emitted when listing is off — peephole probes treat any non-`KindInstr` neighbor as a match blocker (`peepIsSimpleLoadToD0` returns false on comments), so *removing* items would let new peephole matches fire and change emitted bytes, and would also make `--listing` builds differ from plain builds. Only the *string construction* is gated; the item stream is identical either way.

- [ ] **Step 1: Flag** — `var a68ListingOn: bool` in asm68k.cla; set `a68ListingOn = listing` in `driveEmit68kFork` (`drive.cla:1410+`), exactly where `peepDisabled = nopeep` is already set. Also set it `true` unconditionally in any non-68k entry that writes listings (none expected — verify).
- [ ] **Step 2: Marker emitter** in asm68k.cla:

```clarus
// a68CommentMarker emits the SAME KindComment item a68Comment would (so
// the peephole sees an identical item stream with or without --listing;
// comments block match windows) but with no text: callers use it when
// a68ListingOn is false to skip the concat/numToStr/Str255 traffic that
// built the string nobody will print.
func a68CommentMarker() {
    var it: A68Item

    it.kind = KindComment
    it.trapNameIdx = -1
    it.commentIdx = -1
    it.dataTextIdx = -1
    it.addr = a68Pc
    it.len = 0
    a68Items.add(it)
}
```

  Listing printer: a `commentIdx == -1` comment prints as an empty comment line only if such items can ever coexist with `a68ListingOn` (they can't — assert nothing and guard with `!= -1` as Task 17 already does).
- [ ] **Step 3: Call sites** — at each of the 31 `a68Comment(...)` sites, wrap: `if a68ListingOn { a68Comment(<built string>) } else { a68CommentMarker() }` — the string-building expressions (concat + `numToStr` + `cgSizeOf` calls at `:1719`, `:3901`) move inside the listing branch. For the fixed-literal sites this is still worth it (skips a 256-byte by-value pass + side-table append).
- [ ] **Step 4: Gates** — T1; byte-identity (tick + cc.bin) — the load-bearing check for the invariant above; `TestCg68kGoldens` (all `--listing`) pins that listings are unchanged. A/B macro benchmark, record.
- [ ] **Step 5: Commit** — `perf: skip listing-comment string construction when --listing is off; item stream unchanged (findings 1.8)`

---

### Task 19: Snapshot regeneration Stage B + final benchmarks + docs + one emulator run

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated), `docs/ROADMAP.md` (new phase entry), `docs/superpowers/specs/2026-08-10-native-compiler-performance-findings.md` (status annotations), `STATUS.md`

- [ ] **Step 1: Regenerate the snapshot** (same 4-command procedure as Task 9) and verify: `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m -v` — PASS.
- [ ] **Step 2: Final benchmark report** — 10 interleaved pre/post pairs (pre = Task 0's recorded medians + a fresh `/tmp/l1boot` rebuilt from the *phase-start* commit's snapshot via `git show <task0-sha>:clarusc/clarusc.c`): host `emit` self-compile, host `emit68k` macgui macro, every.cla, peak RSS. Write the table into the ledger and the ROADMAP entry.
- [ ] **Step 3: One emulator run** — `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestCoreSuiteGUIOn68k -count=1 -timeout 30m -v` — expect 58/58 PASS. (The phase's only emulator boot, per session scope. Toolbox suite, full T2, and the on-Mac instrumented timing rerun are pre-merge/next-session work — record as debt.)
- [ ] **Step 4: Docs** — ROADMAP phase entry (what changed, measured gains, explicitly: §1.7 deferred with the single-segment/relocation rationale, numToStr dropped, Layer 2/3 untouched, T2 still owed before merge — now covering three stacked phases); annotate the findings doc's §1.1–1.8 items with `[FIXED <date>]` / `[DEFERRED]` / `[STALE — already fixed by map-hashtable]` one-liners; rewrite `STATUS.md` for the next session.
- [ ] **Step 5: Final review** — whole-branch diff review per subagent-driven-development (most capable model), then T1 one last time.
- [ ] **Step 6: Commit** — `chore: regenerate clarusc.c snapshot (Stage B: layer1 perf in-tree); docs + phase close-out`

---

## Self-Review

1. **Spec coverage:** §1.1→Task 1; §1.2→already fixed (verified, documented); §1.3→Task 11; §1.4→Tasks 12+13; §1.5→Task 14; §1.6→Tasks 16+17; §1.7→explicitly deferred with rationale (Task 19 documents); §1.8: intern→Task 2, I*()→Task 3, parser/lexer→Task 4, checker compares/assignable/readOnlyPropName→Task 5, checker maps→Task 6, scopes→Task 7, clear()+drains→Tasks 8–10, a68Comment→Task 18, cgIntListHas→Task 15, irIsExtern→Task 12, numToStr→dropped with rationale, scopeLookup→already fixed. No gaps.
2. **Placeholder scan:** none — every step names exact files/lines/commands; mechanical sweeps specify the discovery grep and the exact target pattern.
3. **Type consistency:** `scopesTruncate(mark: int)` (Task 7) matches its call sites; `I*Clear()` helpers (Task 8) referenced by Task 10 only via surface `.clear()`; `cgIntrUi(e, nm: int)` (Task 14) consistent with `cgIntr`'s fall-through; Task 18's `a68CommentMarker` uses Task 17's `commentIdx/trapNameIdx/dataTextIdx` field names; Task 13's `cgFindFrameOffset(nameIdx: int)` parameter change is confined to cg68k.cla callers listed there.
