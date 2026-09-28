# SE Wave 2 (Representation) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the `bookmarks --rtbake` compile's peak heap from 6.32 MB to ≤ 4 MB (68k-equivalent) by changing how the compiler represents what it holds: a compact string pool, a progressively freed CLIR blob, pre-sized arenas, per-function encode, flat object-code runs, 68k-correct box sizes, and a `MoreMasters` count for ClarusC.

**Architecture:** Wave A runs five independent tracks in parallel worktrees:
- the language task (`list.reserve`, `text.removeFirst`);
- the compact string pool;
- per-function encode;
- the peak-moment census tooling;
- `MoreMasters` for ClarusC.

A snapshot regeneration then lets compiler sources use the new methods. Wave B runs the bake-parse pre-size/progressive free and flat `cgObjRuns` in parallel. Wave C is the output-changing box-size rebless, alone. The final regeneration, the ratchet, and an IIcx re-measure close the wave.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`, `toolbox/*.cla`), C99 host runtime (`runtime/host`), POSIX sh tests, Snow emulator (the wave close only).

**Spec:** `docs/superpowers/specs/2026-09-28-se-wave2-representation-design.md` (umbrella: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`).

## Global Constraints

- **Branch and merging.** Branch `se-wave2-representation`. `main` stays green. Merge only when Andrew asks.
- **Model.** Every implementer and reviewer runs on Opus (`model: opus`).
- **Per-task gate.** T1, run under a cross-worktree lock: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh` (no `--smoke`; it includes `memgate/`). The AppleTalk test lock lives under each worktree's own `build-run/`, and perfgate needs an idle machine. Focused `make test T=...` runs need no lock unless they include `atalk/` or `perfgate/`. No emulator boots until Task 11.
- **Process safety.** Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write the `snow/`, `macplus/` or `macplus2/` pristine images.
- **grep.** `grep` here is ugrep and skips MacRoman/ISO-8859 files (`clarusc/lex.cla` is one). Use `/usr/bin/grep -a` for any "who reads X" audit over `.cla` files.
- **Byte-identity** (spec §4). Every task except Task 1's new suite case and Task 9 must be byte-identical for compiled output. No existing golden may change: `testdata/cg68k/*.s`, emitui, `bake/`, selfhost behavior and module stdout, and the CLRD goldens. If one moves, stop and report.
- **Identity check** (every byte-identical compiler task). Run it before committing. It compiles with the committed snapshot and with the current sources into same-named outputs (MacBinary embeds the file name), and compares them. Use a per-task scratch directory, where `N` is your task number:
  ```sh
  make -j tools bootstrap
  D=/tmp/claude-1000/w2tN; mkdir -p $D/idA $D/idB
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
  Expected: no `DIFF` line. A task that edits runtime sources (Tasks 1 and 9) runs it too; both compilers read the same `runtime/clarus/`.
- **Snapshot.** Do not regenerate `clarusc/clarusc.c` except in Tasks 6 and 10. `selfhost/fixedpoint` failing between regenerations is expected. Run `selfhost/modules` if a task touches `clarusc/test/*`, but not the rest of `selfhost/`. No compiler source (`clarusc/*.cla`) may call `.reserve(` on a list or `.removeFirst(` before Task 6 lands (spec R8): the snapshot builds `clarusc-current`.
- **Memgate.** Budgets may only be lowered. Tasks 1–9 run in parallel worktrees and do **not** edit `tests/memgate/budget.txt` (parallel edits collide at merge); they record before/after peaks in their reports. The wave's budgets are set once, in Task 10. Task 1 may raise a budget only with a written reason line in `tests/memgate/budget.txt`, as Wave 1 Task 1 did.
- **Commits.** Messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

0. **`removeFirst` on a shared box.** `bkLoadBuf`, `rtbakeBytes` and macgui's `clirBuf` hold one box. Removal must empty exactly the consumed prefix for all of them, and a second compile in one process must still get whole, fresh bytes. Task 7 runs `mactest/dblcompile_bake` and adds a macgui-shaped double compile check to the harness if none exists.
1. **Pool edge strings.** `""`, a 255-byte string, strings containing byte 0 or bytes ≥ 0x80, and interning the same string twice. `intern` must return the same index and `poolGet` the same bytes as before. Task 2's host test pins these.
2. **Forward references under per-function encode.** A function that references a label defined later in the same segment (a later function, the mul/div/mod helpers, the free-globals stub, the rc walks, the pools body) must encode identically. Task 3's identity check covers this across four examples, and its report must name which later-defined label kinds it verified.
3. **The drift fallback after a partial progressive free.** The CLIR manifest drifts, `driveCompile` re-runs from source, and nothing reads the half-consumed buffer. Task 7 runs `bake/drift_fallback` and audits `driveRtbakeFallback`.
4. **`--listing` and baked-function paste.** A listing build must stay byte-identical (spec R7), and an `--rtbake` compile that pastes some functions and emits others in the same segment must encode identically. Task 3 runs both.
5. **A second compile in one process after all of the above.** `mactest/dblcompile`, `dblcompile_abort` and `dblcompile_bake` (host, T1) cover it. Tasks 2, 3, 7 and 8 must run them explicitly.

## Tracks and waves

| Wave | Tasks (parallel within a wave)                                                    | Worktrees                                                     |
|------|------------------------------------------------------------------------------------|---------------------------------------------------------------|
| A    | 1 language · 2 compact pool · 3 per-function encode · 4 peak census · 5 MoreMasters | one worktree per task; the controller merges each after review |
| B0   | 6 snapshot regeneration (**serialization point**)                                   | branch tip, alone                                             |
| B    | 7 bake parse pre-size + progressive free · 8 flat `cgObjRuns`                        | one worktree per task                                         |
| C    | 9 68k box sizes (**output-changing, serialization point**)                          | branch tip, alone                                             |
| D    | 10 final snapshot regeneration + ratchet + census (**serialization point**)          | branch tip, alone                                             |
| E    | 11 IIcx re-measure, docs, end-of-wave gates (controller-driven)                      | branch tip                                                    |

Shared files within a wave:
- Wave A: Task 1 touches `cg68k.cla`'s intrinsic dispatch and Task 3 its emit loop. Task 2 touches `lib.cla`, `bake.cla`'s pool code and the pool readers. Task 4 is `runtime/host`/`scripts`, and Task 5 is `macgui.cla`.
- Wave B: Task 7 touches `bake.cla`'s `bkRead*`/`bkLoadSections` and `drive.cla`'s parse gate. Task 8 touches `bake.cla`'s obj-code reader/writer (`bkReadObjCode` ~l.3260, the writer ~l.1655) and `cg68k.cla`'s dump/paste.

Different regions, so git merges them. The controller merges in the order 5, 4, 2, 3, 1 (Wave A) and 8, 7 (Wave B), and re-runs T1 after each merge.

Worktree setup (controller): `git worktree add -b w2-tN ../clarus-w2-tN se-wave2-representation`, plus absolute symlinks for the untracked `snow/ macplus/ macplus2/ vasm/` (to `/home/andrew/repos/clarus/<d>`), `Retro68` (to `/home/andrew/repos/Retro68`) and `toolchain` (to `/home/andrew/repos/Retro68-build/toolchain`).

---

### Task 1: `list.reserve(n)` and `text.removeFirst(n)` (additive: one new suite case)

**Files:**
- Modify: `runtime/clarus/list.cla` (new `rtListReserve` next to `rtListShrink` ~l.466)
- Modify: `runtime/clarus/text.cla` (new `rtTextRemoveFirst` next to `rtTextShrink` ~l.1188)
- Modify: `clarusc/check.cla` (`checkListMethod`, `textOnlyMethods`, next to `shrink`)
- Modify: `clarusc/ir.cla`, `clarusc/lower.cla`, `clarusc/shake.cla`, `clarusc/cprint.cla`, `clarusc/cg68k.cla`. Wave 1's `.release()`/`.shrink()` added a table-driven storage-intrinsic path (`irStorageRow`/`irStorFns`/`irStorDeep`, `fpIntrStorage`, `cgIntrStorage`, shake's final arm). Extend that path for these two methods. They take an `int` argument, which the Wave 1 rows did not, so extend the row shape or add a sibling path in the same style, and say which in the report.
- Modify: `docs/clarus-language-reference.md` (a `reserve(n)` entry next to the list `shrink()` entry; a `removeFirst(n)` entry next to text's `shrink()`; update `tests/reftest/manifest.txt` if new rust fences shift its indices)
- Modify: `testsuite/core/cases_list.cla`, `testsuite/core/runner.cla`, `tests/testsuite/core_cases.txt`, `tests/mactest/coresuite_68k.sh`, `tests/mactest/coresuite_mac.sh`, `CLAUDE.md` (core count 84 → 85: the five places)
- Modify: `testdata/lowlevel/release_storage.cla`, `tests/hostrt/release_storage.sh` (a `removeFirst` probe)

**Interfaces:**
- Produces (user surface): `xs.reserve(n: int)` on `list of T`, and `t.removeFirst(n: int)` on `text`. Both are statements with no result.
- Produces (runtime): `rtListReserve(l: ptr, n: int)` and `rtTextRemoveFirst(t: ptr, n: int)`.
- Produces (IR intrinsic names): `list_reserve`, `text_remove_first`.
- Consumed by Tasks 7 and 8 (after Task 6's snapshot): `.reserve(n)` on compiler `list of <record>`/`list of int`/`list of string` globals and locals, and `.removeFirst(n)` on `bkLoadBuf: text`.

**Semantics (spec §3.1):**
- `reserve(n)`: capacity becomes at least `n`, with at most one `SetHandleSize`. It is a no-op when `cap >= n` or `n <= 0`, never shrinks, and leaves count and contents unchanged. It panics "out of memory" exactly as implicit growth does.
- `removeFirst(n)`: clamp `n` to `0..len`. Move bytes `[n, len)` down to 0 with the text runtime's own block-move extern (it must handle overlap: `BlockMoveData` does). Then `len = len - n`, `SetHandleSize(h, len)`, and `cap = len`. It acts on the shared box, and it never allocates.

- [ ] **Step 1: Write the failing tests**

  (a) Append to `testsuite/core/cases_list.cla`:

```
func caseReserveRemoveFirst(): TestResult {
    var l: list of int
    var b: list of int
    var t: text
    var u: text
    var i: int

    // reserve: contents unchanged, pushes still work, smaller n is a no-op
    l.push(1)
    l.push(2)
    l.reserve(100)
    if l.count != 2 or l.first() != 1 {
        return tkFail("ReserveRemoveFirst", "reserve changed contents")
    }
    i = 0
    while i < 98 {
        l.push(i)
        i = i + 1
    }
    if l.count != 100 {
        return tkFail("ReserveRemoveFirst", "push after reserve")
    }
    l.reserve(5)
    l.reserve(0)
    l.reserve(-3)
    if l.count != 100 or l.first() != 1 {
        return tkFail("ReserveRemoveFirst", "small reserve not a no-op")
    }
    // alias sees reserve (same box)
    b = l
    b.reserve(500)
    b.push(7)
    if l.count != 101 {
        return tkFail("ReserveRemoveFirst", "alias after reserve")
    }

    // removeFirst: 0, middle, all, past the end
    t.append("hello world")
    t.removeFirst(0)
    if t.length != 11 {
        return tkFail("ReserveRemoveFirst", "removeFirst(0)")
    }
    t.removeFirst(6)
    if t.length != 5 or t[0] != 'w' or t[4] != 'd' {
        return tkFail("ReserveRemoveFirst", "removeFirst middle")
    }
    u = t
    u.removeFirst(2)
    if t.length != 3 or t[0] != 'r' {
        return tkFail("ReserveRemoveFirst", "alias did not see removeFirst")
    }
    t.append("XY")
    if t.length != 5 or t[3] != 'X' {
        return tkFail("ReserveRemoveFirst", "append after removeFirst")
    }
    t.removeFirst(5)
    if t.length != 0 {
        return tkFail("ReserveRemoveFirst", "removeFirst all")
    }
    t.append("abc")
    t.removeFirst(99)
    if t.length != 0 {
        return tkFail("ReserveRemoveFirst", "removeFirst past end")
    }
    t.append("z")
    if t.length != 1 or t[0] != 'z' {
        return tkFail("ReserveRemoveFirst", "reuse after removeFirst")
    }
    return tkPass("ReserveRemoveFirst")
}
```

  Match the exact method names these types really have (`push` vs `add`, `first()`, `append`, `length`, `t[i]` indexing, char literal syntax). Check `caseReleaseShrink` next to it and the reference. Only the spellings may change; keep every assertion.

  (b) Register `ReserveRemoveFirst` exactly as Wave 1 registered `ReleaseShrink`: the `CoreTest` enum, `coreCaseName`, the `all` list and the dispatch in `runner.cla`. Bump `nCoreCases` 84 → 85, `tests/testsuite/core_cases.txt`, and the `suite_report_check` literals in `coresuite_68k.sh`/`coresuite_mac.sh`. In CLAUDE.md, "84 `CoreTest` cases: 83 real" becomes 85/84, and `SelfCheck`'s "all 83 other cases" becomes 84. Add one clause on what `ReserveRemoveFirst` proves, in the existing style.

  (c) Host storage probe. In `testdata/lowlevel/release_storage.cla`, after the existing phases, add:

```
    var tb: text
    i = 0
    while i < 200000 {
        tb.append("x")
        i = i + 1
    }
    MemProbe("textfilled")
    tb.removeFirst(190000)
    MemProbe("textremoved")
```

  (Declare `tb` with the other locals if Clarus requires declarations first.) In `tests/hostrt/release_storage.sh`, add after the existing checks:

```sh
tf=$(live textfilled); tr=$(live textremoved)
[ -n "$tf" ] && [ -n "$tr" ] || die "missing text memprobe lines"
[ $((tf - tr)) -ge 150000 ] && t_pass removefirst_freed || t_fail removefirst_freed "textfilled=$tf textremoved=$tr"
```

  Keep `testdata/lowlevel/release_storage.out` consistent with `tests/lowlevel/run.sh` (it is currently empty).

- [ ] **Step 2: Run the tests to verify they fail**

Run: `make test T='testsuite/core_cli hostrt/release_storage'`
Expected: both FAIL (`reserve`/`removeFirst` are unknown methods).

- [ ] **Step 3: Implement the runtime functions**

```
// rtListReserve (SE wave 2, `xs.reserve(n)`): pre-grow capacity to at
// least n elements with at most one SetHandleSize -- the bake readers
// know their counts up front, and a doubling grow holds old + new at
// once. No-op when cap already suffices or n <= 0; never shrinks; count
// and contents unchanged. Panics "out of memory" like implicit growth.
func rtListReserve(l: ptr, n: int) {
    ...
}

// rtTextRemoveFirst (SE wave 2, `t.removeFirst(n)`): drop the first n
// bytes in place -- the tail moves down (overlapping move), len -= n, and
// the handle shrinks to the new length (cap = len). n is clamped to
// 0..len. Acts on the shared box (every alias sees it) and never
// allocates: the bake parse uses it to free the consumed CLIR prefix.
func rtTextRemoveFirst(t: ptr, n: int) {
    ...
}
```

  Build `rtListReserve` on the list's existing grow primitive if one exists (read how `push` grows) so the panic path is shared. If none fits, use `ListSetHandleSize(rl.data, n * rl.elemsize)` plus `rtPanic`'s existing out-of-memory call. `rtTextRemoveFirst` uses the text runtime's own `TextHandleDeref`/`TextBlockMoveData`/`TextSetHandleSize` externs (`text.cla` ~l.70–114). Re-derive any dereferenced pointer after `SetHandleSize`. **Add no new string literals**: an existing panic message is fine, but a new literal could shift string-pool numbering in unrelated programs.

- [ ] **Step 4: Wire the checker, IR, lowering, shake and both lanes**

  Follow `shrink` in every site. Each method type-checks its single `int` argument (reuse how `text.reserve(n)` checks its argument), and both are illegal on a `const`/non-assignable receiver exactly where `shrink()` is.

- [ ] **Step 5: Document** in `docs/clarus-language-reference.md` the exact semantics above. Include "acts on the shared container, so every reference sees it" for `removeFirst`, and cross-reference `text.reserve` from `list.reserve`.

- [ ] **Step 6: Run the tests**

Run: `make test T='testsuite/ hostrt/release_storage lowlevel/ cg68k/ bake/ reftest/'`, then the identity check.
Expected: all PASS, no `DIFF`, and `git status --short testdata/` shows no modified golden (except `release_storage.*`).

- [ ] **Step 7: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add runtime/clarus/list.cla runtime/clarus/text.cla clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/shake.cla clarusc/cprint.cla clarusc/cg68k.cla docs/clarus-language-reference.md tests/reftest/manifest.txt testsuite/core/ tests/testsuite/core_cases.txt tests/mactest/coresuite_68k.sh tests/mactest/coresuite_mac.sh CLAUDE.md testdata/lowlevel/release_storage.cla testdata/lowlevel/release_storage.out tests/hostrt/release_storage.sh
git commit -m "feat(lang): list.reserve(n) and text.removeFirst(n) (SE wave 2)"
```

---

### Task 2: Compact string pool (byte-identical)

**Files:**
- Modify: `clarusc/lib.cla` (l.7–60: `strPool`, `intern`, `internText`, `poolGet`, `libReset`)
- Modify: `clarusc/bake.cla` (pool writer ~l.1358–1361; `bkLdStrPool` ~l.2297; `bkReadStrPool` ~l.3022; the section dispatch ~l.3630; `bkInstallPool` ~l.3956–3964; `bkFreeParseStaging` ~l.4592)
- Modify: every other reader that `/usr/bin/grep -a -n 'strPool' clarusc/*.cla` finds (`drive.cla`, `asm68k.cla`, `ir.cla`, `lower.cla`, `shake.cla`)
- Create: `testdata/lowlevel/pool_edges.cla`, `tests/hostrt/pool_edges.sh`

**Interfaces:**
- Keeps (spec R3): `intern(s: string): int`, `internText(t: text): int`, `poolGet(i: int): string`, with the same semantics. Indices are dense and in insertion order.
- Produces: `poolCount(): int` (replaces every `strPool.count` read outside `lib.cla`), and the storage `var strBlob: text` plus `var strOff: list of int`. `strOff` has `poolCount() + 1` entries; the last one is `strBlob.length`. String `i` is `strBlob[strOff[i] .. strOff[i+1])`.
- Keeps: `strIndex: map of int` (string → index).
- Bake: the CLIR pool section's bytes do not change. The staging becomes `bkLdStrBlob: text` plus `bkLdStrOff: list of int`, and install moves both (Wave 1's install-by-move pattern; the staging names are then re-pointed at fresh boxes by reassignment, **never** `.release()`, because the moved-to globals share their boxes).

- [ ] **Step 1: Write the failing test.** `testdata/lowlevel/pool_edges.cla` cannot call the compiler's pool directly (it is compiler-internal), so the test goes through the compiler. It is a small Clarus program whose string literals are the edge cases:
  - `""`;
  - a 255-character literal;
  - a literal with `\x80`/`\xFF` bytes, or whatever escape syntax the reference allows for high bytes; if none exists, a MacRoman literal like `"é"`;
  - the same literal twice.

  It prints each literal's length and a checksum (`crc16`) to stdout.

  `tests/hostrt/pool_edges.sh` builds it with `host_build`, runs it, and compares stdout against a committed `testdata/lowlevel/pool_edges.out`. It also builds it with `emit68k` through the snapshot and through current, and `cmp`s the two `.bin` files (the pool numbering shows up in the literal pool). Write the `.out` from the snapshot-built binary *before* changing `lib.cla`: the test's job is to prove the new pool reproduces the old bytes.

  If `tests/lowlevel/run.sh` already picks up every `testdata/lowlevel/*.cla` with a matching `.out`, rely on that instead of a new script, and say so.

- [ ] **Step 2: Run it.** It PASSes on the unchanged pool. That is the baseline, and it must still pass after the change.

- [ ] **Step 3: Implement.**

```
// strBlob/strOff (SE wave 2, spec §3.2): the intern pool as one byte blob
// plus start offsets -- string i is strBlob[strOff[i] .. strOff[i+1]).
// strOff carries one trailing sentinel (== strBlob.length), so the pool
// has strOff.count - 1 entries. Replaces `list of string` (256 B per
// entry, ~1 MB at bookmarks scale). Indices stay dense and in insertion
// order; strIndex (string -> index) is unchanged.
var strBlob: text
var strOff: list of int
```

  - `intern(s)`: probe `strIndex` as today. On a miss: `idx = strOff.count - 1`, append `s`'s bytes to `strBlob`, `strOff.add(strBlob.length)`, then `strIndex[s] = idx`.
  - `poolGet(i)`: `return strBlob.stringAt(...)` or the byte-copy idiom `internText` already uses, whichever the text API supports for an arbitrary `[start, end)` range. `stringAt` reads a length-prefixed Pascal string, so check its contract before using it.
  - `libReset` starts `strOff` with the single sentinel `0`, and re-points both globals at fresh containers.
  - Keep `internText` routing through `intern`.
  - Replace every `strPool.count`/`strPool[i]` read outside `lib.cla` with `poolCount()`/`poolGet(i)`.
  - Bake writer (~l.1358): iterate `poolCount()`/`poolGet(i)`. Same bytes out.
  - Bake reader: `bkReadStrPool` decodes into `bkLdStrBlob`/`bkLdStrOff`. Its result type changes. Update the dispatch at ~l.3630.
  - `bkInstallPool`: `strBlob = bkLdStrBlob; strOff = bkLdStrOff`, then re-point the staging names at fresh boxes (reassignment, with the one-line "shares the box" comment Wave 1 used), then rebuild `strIndex` by iterating `poolGet(i)`.
  - `bkFreeParseStaging`: release both staging names, but only where they have not just been moved. Follow the existing comment's rule.

- [ ] **Step 4: Run the tests**

Run the identity check (no `DIFF`, including `DIFF clir`), then `make test T='hostrt/pool_edges lowlevel/ mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake bake/ memgate/ cg68k/ selfhost/modules'`.
Expected: all PASS. The memgate peaks fall by about 0.9 MB; record them in the report.

- [ ] **Step 5: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/lib.cla clarusc/bake.cla clarusc/drive.cla clarusc/asm68k.cla clarusc/ir.cla clarusc/lower.cla clarusc/shake.cla testdata/lowlevel/pool_edges.* tests/hostrt/pool_edges.sh
git commit -m "perf(clarusc): compact intern pool -- one blob plus offsets (SE wave 2)"
```
(`git add` only the files you actually changed.)

---

### Task 3: Per-function emit → encode → discard (byte-identical)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cg68ProgramFork` ~l.15778, its per-segment loop ~l.15840–16040; `cgObjDumpSegment` ~l.15197 and its capture shape ~l.14880–14900)
- Modify: `clarusc/asm68k.cla` only if the encoder needs a "finish a range" entry point (see Step 2)

**Interfaces:**
- Produces: a non-listing, non-capture emit path where `a68Items` holds at most one function's items (plus whatever a single stub/pool body adds) at a time. `--listing` (spec R7) and `cgBakeCapture` keep today's whole-segment path unchanged.
- Keeps: `a68Pc`, the label tables and the per-segment `a68Reset()` semantics (Wave 1 §4.2). `cgObjRuns`/`cgObjHoles` keep their meaning; Task 8 changes their storage in parallel, so **do not change `cgObjRuns`' type** here.

- [ ] **Step 1: Record the before numbers.** `make -j tools bootstrap && make test T=memgate/`, and record the three peaks plus `bookmarks_rtbake`'s `Emitted segment 1` and `Built fork` memprobe lines from `build-run/tests/memgate/peak.log`.

- [ ] **Step 2: Read before designing, and record the findings in the report.**
  - `a68Finish` (asm68k.cla): what it does over the whole item stream. Is there branch relaxation, a resolve pass over forward label refs, or listing assembly? Which of it needs items of *other* functions in the segment?
  - Label addresses: by emission time, is every label's address in the segment already known from measure (`cgFuncSize`, packing)? Or does `a68Finish` discover them?
  - `peepFunc`, `a68Relayout`, `cgObjPasteFunc` (~l.15735): do any of them read items outside the current function?
  - `/usr/bin/grep -an 'a68Items\[' clarusc/cg68k.cla clarusc/asm68k.cla clarusc/peep68k.cla`: every indexed read.

  Pick the design from what you find. In order of preference:
  - **(a)** If every label address is known when a function finishes emitting, encode that function's items straight into the segment's byte output, then `.clear()` the items. This is a new "finish this range" entry point in asm68k if needed.
  - **(b)** If forward refs to later labels exist, encode each function to bytes with a fixup list (offset, label, kind) for refs that are still unresolved. Patch those at segment end. This is the same shape the obj capture uses (runs + holes).
  - **(c)** If neither is safe, stop and report with the evidence (BLOCKED), not a partial design.

- [ ] **Step 3: Implement the chosen design** in the non-listing, non-capture path only. Leave a doc comment at the new code naming the design, the invariant it relies on (e.g. "every label a function references is either defined by now or recorded as a fixup"), and why listing/capture keep the old path.

- [ ] **Step 4: Run the tests**
  - The identity check: no `DIFF` (from-source, `--rtbake` which pastes baked functions between emitted ones, and C).
  - The listing check: `build-run/clarusc-snapshot emit68k --listing -o /tmp/claude-1000/w2t3/lA/bookmarks.bin examples/bookmarks.cla` and the same with `clarusc-current` into `lB/`. Then `cmp` every `.seg*.s` and `.seg*.dat`, plus the `.bin`.
  - `make test T='cg68k/ bake/ asm68k/ memgate/ mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake'`. Expected: all PASS.
  - Record the new peaks and the `Emitted segment 1`/`Built fork` lines. The report names every later-defined label kind the design had to handle (Review Focus 2).

- [ ] **Step 5: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/cg68k.cla clarusc/asm68k.cla
git commit -m "perf(cg68k): encode each function's items as soon as it is emitted (SE wave 2)"
```

---

### Task 4: Peak-moment census (tooling only)

**Files:**
- Modify: `runtime/host/` (the memory accounting that prints `memprobe:` lines under `CLARUS_MEM_PEAK`; find it with `/usr/bin/grep -rn 'CLARUS_MEM_PEAK' runtime/host`)
- Modify: `scripts/memcensus.sh`
- Modify: `CLAUDE.md` (the memory-ratchet bullet: document the new mode in one sentence)

**Interfaces:**
- Produces: `CLARUS_MEM_PEAK=3`. It behaves like `=1`, and in addition, each time the live 68k-equivalent total sets a new overall peak by at least 64 KB over the last snapshot, it records a census snapshot and prints it at exit as `memprobe: peakcensus ...` lines. The 64 KB floor keeps the cost bounded. `scripts/memcensus.sh --at-peak FILE.cla` (composable with `--rtbake`) drives it and prints the last snapshot.
- The census is whatever `memcensus.sh` already reports per global (the `cv_<name> count= elemsize= cap=` lines). Reuse its mechanism; if it walks compiler globals from Clarus code rather than C, snapshot through the same hook it uses at phase boundaries, and say how in the report.

- [ ] **Step 1: Write the failing test.** Add a subcase to the memgate or hostrt group, `tests/memgate/atpeak.sh`: run `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla` and assert that its output has at least one `peakcensus` line naming `cv_bkLdIrExprs`. At today's peak (inside the bake parse) that global is live. Run it; expected FAIL (unknown flag).

- [ ] **Step 2: Implement** the mode. With `CLARUS_MEM_PEAK` unset or `=1`/`=2`, host output must be exactly as today: memgate parses those lines.

- [ ] **Step 3: Run** `make test T='memgate/ hostrt/'`. Expected: PASS. Put the `--at-peak` output for `bookmarks --rtbake` in the report: it is Task 7's baseline.

- [ ] **Step 4: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add runtime/host scripts/memcensus.sh tests/memgate/atpeak.sh CLAUDE.md
git commit -m "test(memgate): census at the peak moment (CLARUS_MEM_PEAK=3, memcensus --at-peak) (SE wave 2)"
```

---

### Task 5: `MoreMasters` for ClarusC (byte-identical except ClarusC.APPL)

**Files:**
- Modify: `clarusc/macgui.cla` (startup, before the first compile)
- Modify: `docs/FUTURE.md` (the deferred `app` header field, spec R4)

**Interfaces:**
- Consumes: `MoreMasters` from `toolbox/memory.cla` (the catalog, ~l.21/100). If macgui does not already compose `toolbox/memory.cla`, add the `include`.
- Produces: nothing other tasks read.

- [ ] **Step 1: Derive the count.**
  - Read how many master pointers one `MoreMasters` call allocates on System 6/7 (Inside Macintosh: Memory; the zone's `moreMast` field). Default zones use 64 on 128K-ROM Macs and later; confirm it.
  - Take the measured handle count at the IIcx low point. If the Wave 1 IIcx log (`build-run/memprobe-saved/clarusc_memprobe.wave1.log`) has no handle count, use the host memgate's `handles=` at `Built fork` for `bookmarks_rtbake` (8157) as the proxy.
  - Add ~20% headroom and divide by the per-call count. For example, `ceil(8157 × 1.2 / 64) = 153` calls.
  - Write the derivation in the code comment.

- [ ] **Step 2: Implement.** A loop at macgui startup, placed before anything allocates compiler state, with a comment on why: master-pointer blocks are nonrelocatable. Allocating them on demand mid-compile scatters them through the heap. Allocating them up front packs them at the bottom.

- [ ] **Step 3: Verify.**
  - `build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ -o /tmp/claude-1000/w2t5/ClarusC.bin clarusc/macgui.cla` gives no diagnostics.
  - The identity check shows no `DIFF`: macgui is not in it, and every example must be unchanged.
  - `make test T='mactest/macresident_host bake/'`, or the host scripts that build macgui if that one does not exist (`ls tests/mactest | grep -i resident`). Expected: PASS.

- [ ] **Step 4: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/macgui.cla docs/FUTURE.md
git commit -m "perf(macgui): preallocate master pointers for ~10k blocks (SE wave 2)"
```

---

### Task 6: Snapshot regeneration (serialization point; runs alone)

Needs Wave A (Tasks 1–5) merged.

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)

- [ ] **Step 1:** Run `make test T=selfhost/fixedpoint`. It fails and prints the Go-free regeneration recipe; follow it exactly, and re-run until it PASSes. Then run `make test T=selfhost/`. Expected: all PASS.
- [ ] **Step 2:** Confirm the snapshot understands the new methods: `printf 'var l: list of int\nvar t: text\n...' > /tmp/claude-1000/w2t6/probe.cla`, a minimal program that calls `l.reserve(4)` and `t.removeFirst(1)` in its entry handler (copy the CLI shape of `testdata/lowlevel/release_storage.cla`). Build it with `cc -O1 -I runtime/host -o /tmp/claude-1000/w2t6/cc clarusc/clarusc.c runtime/host/rt.c`, then `/tmp/claude-1000/w2t6/cc emit --rtdir runtime/clarus/ -o /tmp/claude-1000/w2t6/p.c /tmp/claude-1000/w2t6/probe.cla`. Expected: no diagnostics.
- [ ] **Step 3: T1 and commit**

Run: `scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/clarusc.c
git commit -m "chore(clarusc): regenerate snapshot for list.reserve/text.removeFirst (SE wave 2)"
```

---

### Task 7: Bake parse — pre-size and progressive free (byte-identical)

Needs Task 6.

**Files:**
- Modify: `clarusc/bake.cla` (every `bkRead*` reader that reads a count before its elements, ~l.2159–3036 and `bkReadIntList` ~l.2186; `bkLoadSections` ~l.3538; the cursor `bkLoadBuf`/`bkLoadPos` ~l.1961–2110; the body-hash check ~l.3783–3851; `bkLoadRtbake` ~l.3864)
- Modify: `clarusc/drive.cla` (only if the parse gate or `driveRtbakeFallback` needs it)
- Modify: `clarusc/test/dblcompile_bake.cla` and its `.sh` only for Review Focus 0's check, if the harness lacks one

**Interfaces:**
- Consumes: `.reserve(n)` and `.removeFirst(n)` (Task 1, compiled by Task 6's snapshot). Also Task 2's `bkReadStrPool` in its blob-plus-offsets form: pre-size its `strOff` with `reserve(n + 1)`, and its blob with `text.reserve` if the byte total is known (it is not stored up front, so skip that).
- Consumes: Task 4's `scripts/memcensus.sh --rtbake --at-peak`, for before/after attribution.

- [ ] **Step 1: Record the before numbers** with Task 4's tool: `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla`, plus the memgate peaks.

- [ ] **Step 2: Pre-size.** In every reader of the shape

```
    n = bkGetU32()
    i = 0
    while i < n {
        ...
        l.add(e)
```

  insert `l.reserve(n)` right after `n` is read. Guard it: a corrupt CLIR can carry a huge `n`, and `reserve` would panic out of memory before the reader's own bounds checks fail cleanly. So reserve only when `n` passes the same plausibility check the reader already applies. If the reader has none, cap the reservation, for example `if n <= bkLoadBuf.length - bkLoadPos { l.reserve(n) }`, since every element takes at least one byte. `tests/bake/corrupt.sh` must stay green.

- [ ] **Step 3: Progressive free** (spec §3.3).
  - Add `var bkLoadBase: int`, the bytes removed so far, and reset it wherever `bkLoadPos` is reset for a new parse.
  - In `bkLoadSections`, at each section boundary: `if bkLoadPos >= 65536 { bkLoadBase = bkLoadBase + bkLoadPos; bkLoadBuf.removeFirst(bkLoadPos); bkLoadPos = 0 }`.
  - Audit every place that treats a buffer position as absolute: a section table, stored offsets, error messages that print positions, `bkReadObjCode`/`bkReadObjMeta`, and anything else after the hash check. Rebase each against `bkLoadBase`, and list each one in the report.
  - The body-hash check runs over the whole buffer before any removal. Assert that ordering with a comment.
  - `bkLoadBuf` shares its box with `rtbakeBytes` and the front end's buffer (Wave 1 Task 5 report): removal consumes the one shared buffer, which is intended. After a successful parse, `driveCompile` still does `rtbakeBytes.release()` for the remainder.
  - After a *failed* parse, the buffer is partly consumed. Confirm that `driveRtbakeFallback` and every caller of `bkLoadRtbake` never read it afterwards (Review Focus 3), and write that in a comment at the fallback.

- [ ] **Step 4: Review Focus 0.** Check that `clarusc/test/dblcompile_bake.cla` hands `driveCompile` a fresh copy per compile (Wave 1 made it do so). Also check that `macgui.cla`'s `gcResolveBakePath` reads fresh bytes per compile. If either does not, fix it and say so.

- [ ] **Step 5: Run the tests**
  - The identity check (no `DIFF`).
  - `make test T='bake/ mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake memgate/'`, including `bake/drift_fallback` and `bake/corrupt`. Expected: all PASS.
  - `CLARUS_BAKE_FULL=1 make test T=bake/`: expected PASS.
  - `build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ -o /tmp/claude-1000/w2t7/ClarusC.bin clarusc/macgui.cla`: no diagnostics.
  - Record the peaks and the `--at-peak` census after the change.

- [ ] **Step 6: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/bake.cla clarusc/drive.cla clarusc/test/dblcompile_bake.cla tests/mactest/dblcompile_bake.sh
git commit -m "perf(bake): pre-size parse lists; free the CLIR prefix as sections are decoded (SE wave 2)"
```

---

### Task 8: Flat `cgObjRuns` (byte-identical)

Needs Task 6 (it may use `.reserve`). It runs in parallel with Task 7.

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgObjRuns` ~l.14893; `cgObjDumpSegment` ~l.15237–15273; `cgObjPasteFunc` ~l.15748; the reset ~l.15851)
- Modify: `clarusc/bake.cla` (the writer ~l.1655; `bkReadObjCode` ~l.3260–3342; `bkFreeParseStaging`'s obj comment only)

**Interfaces:**
- Produces: `var cgObjRunBytes: text` plus `var cgObjRunOff: list of int` (with a trailing sentinel, the Task 2 convention). Run `r` is `cgObjRunBytes[cgObjRunOff[r] .. cgObjRunOff[r+1])`. `cgObjRunFirst`/`cgObjHoleFirst`/`cgObjNHoles`/`cgObjHoles` keep their meaning. Add `cgObjRunCount()`, `cgObjRunLen(r)` and one way to emit or copy run `r`'s bytes: whatever `a68DcBytes` and the bake writer need. Use the text API's range copy; if it has none, write one small helper here.
- The CLIR obj-code section's on-disk bytes are unchanged.

- [ ] **Step 1: Record the before numbers** (memgate peaks; the `cv_cgObjRuns` census line).
- [ ] **Step 2: Implement.** Replace every `cgObjRuns.add(slice)` with an append to the blob plus an offset. Replace `cgObjRuns[p].length` with `cgObjRunLen(p)`, and `a68DcBytes(cgObjRuns[i])` with the range form. The reader builds the blob straight from the section bytes, and pre-sizes `cgObjRunOff` with `reserve`.
- [ ] **Step 3: Run the tests**
  - The identity check: no `DIFF`, and `rt.clir` identical, because `--bake-ir` exercises the capture and the writer.
  - `make test T='cg68k/ bake/ memgate/ mactest/dblcompile mactest/dblcompile_abort mactest/dblcompile_bake'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`. Expected: all PASS.
  - Record the peaks.
- [ ] **Step 4: T1 and commit**

Run: `flock /tmp/claude-1000/clarus-w2-gate.lock scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/cg68k.cla clarusc/bake.cla
git commit -m "perf(cg68k): flat cgObjRuns -- one byte blob plus offsets (SE wave 2)"
```

---

### Task 9: 68k-correct container box sizes (**output-changing**; serialization point; runs alone)

Needs Wave B merged.

**Files:**
- Modify: `runtime/clarus/list.cla` (`rtListBoxSize` ~l.196), `text.cla` (~l.198), `map.cla` (`rtMapBoxSize` ~l.580), `sortedmap.cla` (~l.208)
- Create/modify: the lane companions that give native builds their own values (see Step 1)
- Modify: `clarusc/bake.cla` `bakeModuleList` (only if a new `_68k` module is added)
- Create: `tests/bake/<module>.sh` for each new `_68k` module (the CLAUDE.md standing rule: an `emit68k_pair` twin in the same task)
- Modify: the reblessed goldens (Step 4)

**Interfaces:**
- Produces: native box sizes list 20, text 16, map 52, sortedmap 28 bytes (spec §3.6). The host lane keeps 40/32/112/56.

- [ ] **Step 1: Choose the lane mechanism.**
  - Read how an existing constant or function already differs by lane: `datetime.cla` + `datetime_68k.cla`, `fileh.cla` + `fileh_68k.cla`, the `bakeModuleList` 68k list and `driveManifestSplice`.
  - Prefer the smallest mechanism that exists: move each `rt*BoxSize` const into a 68k companion and a host companion that already exist or are cheap to add.
  - **Verify each 68k size against the record layout**: sum the 68k field widths of `RtList`/`RtText`/`RtMap`/`RtSortedMap` (4-byte pointers and handles, 4-byte ints, 2-byte enums if any). The box must be at least that. The spec's numbers (20/16/52/28) are the targets; use the verified sum if it differs, and say why.
  - Remember CLAUDE.md's warning: an under-sized box corrupts the heap.
- [ ] **Step 2: Implement.** Keep the host values and the host C output byte-identical: the C-lane identity check must show no `DIFF C`.
- [ ] **Step 3: Measure what moved.** `make test T='cg68k/ bake/'` and `CLARUS_BAKE_FULL=1 make test T=bake/`. List every failing golden family: `testdata/cg68k/*.s` (box-size immediates in `NewPtr` calls), emitui (C lane: must NOT move), `bake/` twins (they compare from-source vs bake, so both sides move together: must still PASS), and selfhost behavior (the compiler's own 68k build is not in T1).
- [ ] **Step 4: Rebless** only the families that are expected to move, each in its own commit with a written reason: `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`. Diff one blessed golden by hand and confirm that the only changes are the box-size immediates (and any address shifts that follow from them). A C-lane or emitui golden moving is a bug: stop.
- [ ] **Step 5: Native proof.** The box shrink is only proven on the Mac. Boot the core suite once as a controlled exception to "no emulators until Task 11", because a wrong box corrupts memory silently: `DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority CLARUS_MAC_TESTS=1 make -j1 test T='mactest/coresuite_68k mactest/toolbox_68k'`. Expected: PASS (85/85 and 40/40).
- [ ] **Step 6: T1 and commit**

Run: `scripts/test-task.sh`. Expected: PASS.
```bash
git add runtime/clarus/ clarusc/bake.cla tests/bake/
git commit -m "perf(runtime): 68k-correct container box sizes (SE wave 2)"
git add testdata/cg68k/
git commit -m "test(cg68k): rebless for 68k box sizes -- NewPtr immediates only (SE wave 2)"
```

---

### Task 10: Final snapshot regeneration, ratchet, census (serialization point; runs alone)

Needs Tasks 1–9.

**Files:**
- Modify: `clarusc/clarusc.c`, `tests/memgate/budget.txt`

- [ ] **Step 1:** Regenerate as in Task 6 Step 1, then run `make test T=selfhost/`. Expected: all PASS.
- [ ] **Step 2: Ratchet.** Run `make test T=memgate/` three times; the peaks must be identical. Set each budget to `int(P * 1.01) + 1`, but **never above the current budget** (lower-only). Add a change-log line:

```
# 2026-09-28 wave 2: compact pool, progressive CLIR free + pre-size,
# per-function encode, flat cgObjRuns, reserve/removeFirst. Measured peaks
# <P1> / <P2> / <P3> + 1%.
```

  If `bookmarks_rtbake` > 4,194,304, still commit the ratchet at the measured value. Also run `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla` and put the peak line and top 10 census lines in the report.
- [ ] **Step 3: T1 and commit**

Run: `scripts/test-task.sh`. Expected: PASS.
```bash
git add clarusc/clarusc.c tests/memgate/budget.txt
git commit -m "test(memgate): ratchet to wave 2 peaks; regenerate snapshot (SE wave 2)"
```

---

### Task 11: IIcx re-measure, docs and end-of-wave gates (controller-driven)

Needs Task 10.

**Files:**
- Modify: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md` (§5.5 row 2 with the measured value; §9 status; a new "Wave 2 measurements" subsection with aligned-column tables)
- Modify: `docs/superpowers/specs/2026-09-28-se-wave2-representation-design.md` (status line; revise §1's number with justification if 4 MB was not reached)
- Modify: `docs/ROADMAP.md` (Wave 2 done, pending merge), `docs/HISTORY.md` (Wave 2 entry, with placeholders `<T2 result>` and `<clarusc_bake result>`), `docs/TODO.md`

- [ ] **Step 1: The IIcx measurement** (subagent, emulator)

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_memprobe
cp build-run/tests/mactest/snow/clarusc_memprobe.log build-run/memprobe-saved/clarusc_memprobe.wave2.log
```

  Expected: 5/5 PASS. Record, with Wave 1 side by side:
  - launch free/zone;
  - per-phase free;
  - launch→low heap used (Wave 1: 7977 KB);
  - stack high-water;
  - the "Verifying Baked Runtime" → "Starting" wall-clock span (the parse, with the progressive free's copies).

  The box-size change (Task 9) and `MoreMasters` (Task 5) show only here (spec R6). Copy the log before any other run of that script.

- [ ] **Step 2: The docs** (subagent). Follow the Files list, using numbers from the task reports and Step 1. Tables must have aligned columns (Andrew's rule).

- [ ] **Step 3: The end-of-wave gates** (controller)

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
scripts/test-merge.sh
CLARUS_SNOW_TESTS=1 make test T='mactest/snow/clarusc_bake mactest/snow/macresident_failed_compile'
```

  Expected: every stage PASSes. Fill in the HISTORY placeholders.

- [ ] **Step 4:** The final whole-branch review (Opus), a single fix wave, and a scoped re-review. Then report to Andrew. Do not merge.
