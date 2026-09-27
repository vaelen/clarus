# SE Wave 0 (Measurement) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A host memory ratchet (`tests/memgate/`) in T1, plus on-target
measurements: the Snow SE's app budget, and ClarusC's per-phase heap and
stack on the Mac IIcx.

**Architecture:** Counters in the host Memory Manager shim are dumped at
every compile phase through a new front-end seam, `feMemProbe(phase)`.
The host front end routes it to a runtime extern that prints only under
`CLARUS_MEM_PEAK`; ClarusC.APPL routes it to `FreeMem`/`MaxBlock` log
lines. A new `= inline sp` extern clause lets ClarusC paint and scan its
stack. Two opt-in Snow scripts take the on-target numbers.

**Tech Stack:** C99 (`runtime/host`), Clarus (`clarusc/*.cla`,
`toolbox/*.cla`), POSIX sh test scripts, Snow emulator.

**Spec:** `docs/superpowers/specs/2026-09-27-se-wave0-measurement-design.md`
(umbrella: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`).

## Global Constraints

- Branch: `se-wave0-measurement`. `main` stays green; merge only when Andrew asks.
- Opus (`model: opus`) for every implementer and reviewer.
- Per-task gate: `scripts/test-task.sh` (T1, **no** `--smoke`), plus `make test T=memgate/` from Task 7 on.
- Emulator boots are allowed in this wave (umbrella D12's Wave 0 exception), but only in Tasks 4 and 8, and only through `tests/lib_snow.sh`.
- **Process safety:** never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write `snow/`, `macplus/` or `macplus2/` pristine images. Andrew's own emulators may be running.
- Emulator shells need `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority`.
- `grep` here is ugrep and skips MacRoman files (`clarusc/lex.cla`, `clarusc/lib.cla`). Use `/usr/bin/grep -a` for any "who uses X" audit over `.cla` files.
- Every task is **byte-identical** for user programs: no existing `testdata/cg68k/*.s`, emitui, `bake/` or selfhost golden may change. The only new golden is `testdata/cg68k/inline_sp.s` (Task 2). If any other golden moves, stop and report.
- `tests/lib.sh` is FROZEN. Test scripts are POSIX sh (no arrays, `[[ ]]`, `local`, `echo -e`) and exit 0 / 77 (skip) / other (fail).
- The C `emit` lane must stay byte-silent: nothing new prints unless `CLARUS_MEM_PEAK` is set.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

1. **`CLARUS_MEM_PEAK` unset**: `emit68k` stderr must be byte-identical to before. Task 1 tests that `rtm_dump` is silent without the variable; Task 6 diffs `emit68k` stderr against the snapshot compiler's.
2. **Handle resize while locked, and shrink to 0**: the counters must follow the logical size on both `rt_mem_set_handle_size` paths, never go negative, and never count a failed locked grow. Task 1's unit test covers all three.
3. **A compile that fails or aborts in ClarusC** (diagnostics, `aborted`, early `return`): it must still log the `stack:` line, and the next compile must repaint. Task 6 hooks around `gcCompile(w, p)` in `Compile.select`, not inside `gcCompile`.
4. **Stack paint must never write at or above the live SP.** If `SP − 1 KB ≤ ApplLimit + 16`, skip and log `stack: probe unavailable`. Task 6 includes that branch.
5. **Budget file missing a subcase or holding a malformed line**: memgate must FAIL loudly, never PASS with an empty budget. Task 7's script checks `[ -n "$budget" ]` and that the value is numeric.

## Tracks and waves

| Wave | Tasks (parallel within a wave)                                                | Worktrees                                                      |
|------|--------------------------------------------------------------------------------|----------------------------------------------------------------|
| A    | 1 host counters · 2 `inline sp` · 3 memory.cla catalog                          | one worktree per task (disjoint files); controller merges       |
| B    | 4 SE budget probe (emulator) · 6 compiler seam + macgui probes                  | separate worktrees; 4 touches only testdata/snow + tests/mactest/snow |
| C    | 7 snapshot regen + memgate (**serialization point**, runs alone)                | branch tip                                                     |
| D    | 5 census script · 8 IIcx probe run (emulator); Task 5 is numbered before 7 but runs after it | separate worktrees                                             |
| E    | 9 recording, calibration, docs; end-of-wave gates (controller)                  | branch tip                                                     |

Task 4 needs Task 3 (it includes `toolbox/memory.cla` for `MaxBlock`).
Task 6 needs Tasks 1–3. Task 5 needs Tasks 1 and 7. Task 8 needs Task 7.

Dispatch pattern for worktrees: the controller creates
`git worktree add ../clarus-w0-tN se-wave0-measurement` (on a
`w0-tN` branch) per parallel task. Each implementer works and commits
only there, and the controller merges each `w0-tN` back into
`se-wave0-measurement` (`git merge --no-ff w0-tN`) after its review
passes. Symlinked toolchains (`toolchain/`, `snow/`, `macplus/`, `vasm/`,
`Retro68/`) are not in git; the implementer symlinks them into the
worktree from `/home/andrew/repos/clarus/` before running tests that need them.

---

### Task 1: Host memory counters, dump and `MemProbe` extern (byte-identical)

**Files:**
- Modify: `runtime/host/rt_mem_host.inc` (counters in `rt_mem_alloc_block`, `rt_mem_set_handle_size`, `DisposeHandle`, `DisposePtr`; new `rtm_*` functions; TOTAL line in `rt_mem_exit_check`)
- Modify: `runtime/host/rt_mem.h` (declare the `rtm_*` API)
- Modify: `runtime/host/rt_ext_host.inc` (`rt_ext_MemProbe`)
- Create: `runtime/host/rt_memprobe_test.c`
- Create: `tests/hostrt/memprobe.sh`

**Interfaces:**
- Produces (C, declared in `rt_mem.h`):
  ```c
  typedef struct {
      long live, peak, live68k, peak68k, peakAll68k, blocks, handles, allocs;
  } rtm_counters;
  void rtm_get(rtm_counters *out);   /* snapshot of the counters */
  void rtm_dump(const char *phase);  /* prints iff CLARUS_MEM_PEAK is "1" or "2"; ALWAYS resets peak/peak68k/allocs */
  ```
- Produces (extern, consumed by Task 6's `main.cla`): `void rt_ext_MemProbe(const uint8_t *phase)`, where `phase` is a Pascal string (`phase[0]` is the length).
- Produces (consumed by Task 5): when compiled with `-DRTM_CENSUS`, `rtm_dump` calls `void rtm_census(void);` (defined elsewhere) after its line, whenever the level is 2.
- Output format (consumed by Tasks 5 and 7), one line per call, to stderr:
  `memprobe: <phase> | live68k=N peak68k=N live=N peak=N blocks=N handles=N allocs=N`
  and at process exit, if enabled: `memprobe: TOTAL | peakAll68k=N`

**68k cost model** (spec W1): a block costs `((size + 3) & ~3) + 8`, plus 4 if it is a handle.

- [ ] **Step 1: Write the failing unit test** `runtime/host/rt_memprobe_test.c`:

```c
/* SE Wave 0: rt_mem_host.inc live/peak counters and the 68k cost model
   (round4(size) + 8 header, + 4 master pointer for a handle). Run by
   tests/hostrt/memprobe.sh through run_c_test, which needs stdout+stderr
   to be exactly "OK": CLARUS_MEM_PEAK is unset, so rtm_dump must be
   silent -- that silence is itself under test. */
#include "rt.h"
#include "rt_mem.h"
#include <stdio.h>

static int fails = 0;
#define CHECK(cond) do { if (!(cond)) { printf("FAIL line %d: %s\n", __LINE__, #cond); fails++; } } while (0)

int main(void)
{
    rtm_counters c0, c;
    Handle h;
    Ptr p;

    rtm_dump("reset");            /* silent; resets the phase peak */
    rtm_get(&c0);

    h = NewHandle(10);            /* 68k: 12 + 8 + 4 = 24 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 10);
    CHECK(c.live68k - c0.live68k == 24);
    CHECK(c.blocks - c0.blocks == 1);
    CHECK(c.handles - c0.handles == 1);

    SetHandleSize(h, 21);         /* relocating grow: 24 + 8 + 4 = 36 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 21);
    CHECK(c.live68k - c0.live68k == 36);
    CHECK(c.peak68k - c0.live68k >= 36);

    HLock(h);
    SetHandleSize(h, 40);         /* locked grow fails: nothing counted */
    CHECK(MemError() == memFullErr);
    rtm_get(&c);
    CHECK(c.live - c0.live == 21);
    SetHandleSize(h, 0);          /* locked shrink in place: 0 + 8 + 4 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 0);
    CHECK(c.live68k - c0.live68k == 12);
    HUnlock(h);

    p = NewPtr(5);                /* 68k: 8 + 8 = 16, not a handle */
    rtm_get(&c);
    CHECK(c.live68k - c0.live68k == 12 + 16);
    CHECK(c.handles - c0.handles == 1);
    CHECK(c.blocks - c0.blocks == 2);

    DisposePtr(p);
    DisposeHandle(h);
    rtm_get(&c);
    CHECK(c.live == c0.live);
    CHECK(c.live68k == c0.live68k);
    CHECK(c.blocks == c0.blocks);
    CHECK(c.peakAll68k >= c0.live68k + 36);

    rtm_dump("after");            /* silent; resets the phase peak to live */
    rtm_get(&c);
    CHECK(c.peak68k == c.live68k);
    CHECK(c.allocs == 0);

    if (fails == 0) printf("OK");
    return fails != 0;
}
```

`tests/hostrt/memprobe.sh`:

```sh
#!/bin/sh
# SE Wave 0: host Memory Manager shim counters (live/peak, 68k cost model)
# and rtm_dump's silence when CLARUS_MEM_PEAK is unset.
. "$(dirname "$0")/../lib.sh" || exit 2
unset CLARUS_MEM_PEAK
run_c_test runtime/host/rt_memprobe_test.c || die "rt_memprobe_test"
echo "PASS memprobe"
```

- [ ] **Step 2: Run it to verify it fails**

Run: `make test T=hostrt/memprobe`
Expected: FAIL (compile error: `rtm_counters` / `rtm_get` undeclared).

- [ ] **Step 3: Implement the counters in `rt_mem_host.inc`**

Near the other statics (after `rt_mem_atexit_done`):

```c
/* SE Wave 0 memory probe (docs/superpowers/specs/2026-09-27-se-wave0-
   measurement-design.md §3). Maintained unconditionally -- a few adds per
   allocation -- and printed only when CLARUS_MEM_PEAK is "1" or "2".
   live68k models a 24-bit Memory Manager: round4(size) + 8-byte block
   header, + 4 for a handle's master pointer. Host payloads are counted at
   host width (pointer-sized elements overcount; spec W2). */
static long rtm_live, rtm_peak, rtm_live68k, rtm_peak68k, rtm_peak_all68k;
static long rtm_blocks, rtm_handles, rtm_allocs;
static int rtm_level = -1; /* -1 = not yet read from env */

static long rtm_cost68k(Size n, int is_ptr)
{
    return (((long)n + 3) & ~3L) + 8 + (is_ptr ? 0 : 4);
}

static void rtm_note_peak(void)
{
    if (rtm_live > rtm_peak) rtm_peak = rtm_live;
    if (rtm_live68k > rtm_peak68k) rtm_peak68k = rtm_live68k;
    if (rtm_live68k > rtm_peak_all68k) rtm_peak_all68k = rtm_live68k;
}

static int rtm_get_level(void)
{
    const char *v;

    if (rtm_level < 0) {
        v = getenv("CLARUS_MEM_PEAK");
        rtm_level = (v != NULL && v[0] == '2' && v[1] == '\0') ? 2
                  : (v != NULL && v[0] == '1' && v[1] == '\0') ? 1 : 0;
    }
    return rtm_level;
}
```

Hook points (only the successful paths count):
- `rt_mem_alloc_block`, just before `rt_mem_err = noErr; return b;`:
  ```c
      rtm_live += (long)n;
      rtm_live68k += rtm_cost68k(n, is_ptr);
      rtm_blocks++;
      if (!is_ptr) rtm_handles++;
      rtm_allocs++;
      rtm_note_peak();
  ```
- `rt_mem_set_handle_size`, **locked shrink path**, before `b->size = n;`, and the **relocating path**, before its `b->size = n;` (the same two lines in both places):
  ```c
      rtm_live += (long)n - (long)b->size;
      rtm_live68k += rtm_cost68k(n, 0) - rtm_cost68k(b->size, 0);
      rtm_note_peak();
  ```
  The relocating path briefly holds old and new at once on a real Mac too, but the shim frees the old block into quarantine. Count the logical transition only; the spec says counters follow logical lifetimes.
- `DisposeHandle`, before `b->p = NULL;`:
  ```c
      rtm_live -= (long)b->size;
      rtm_live68k -= rtm_cost68k(b->size, 0);
      rtm_blocks--;
      rtm_handles--;
  ```
- `DisposePtr`, before `b->live = 0;`:
  ```c
      rtm_live -= (long)b->size;
      rtm_live68k -= rtm_cost68k(b->size, 1);
      rtm_blocks--;
  ```

Public functions (after `MemError`):

```c
#ifdef RTM_CENSUS
void rtm_census(void); /* generated by scripts/memcensus.sh */
#endif

void rtm_get(rtm_counters *out)
{
    out->live = rtm_live;
    out->peak = rtm_peak;
    out->live68k = rtm_live68k;
    out->peak68k = rtm_peak68k;
    out->peakAll68k = rtm_peak_all68k;
    out->blocks = rtm_blocks;
    out->handles = rtm_handles;
    out->allocs = rtm_allocs;
}

static void rtm_tag_histogram(void)
{
    /* Top 15 tags by live bytes. O(blocks x distinct tags); a diagnostic
       path only (CLARUS_MEM_PEAK=2). */
    enum { MAXT = 512, TOP = 15 };
    const char *tags[MAXT];
    long bytes[MAXT];
    int nt = 0, i, j, best;
    rt_mem_block *b;

    for (b = rt_mem_blocks; b != NULL; b = b->next) {
        if (!b->live) continue;
        for (i = 0; i < nt && tags[i] != b->tag; i++) {}
        if (i == nt) {
            if (nt == MAXT) continue;
            tags[nt] = b->tag;
            bytes[nt] = 0;
            nt++;
        }
        bytes[i] += (long)b->size;
    }
    for (j = 0; j < TOP && j < nt; j++) {
        best = j;
        for (i = j + 1; i < nt; i++) if (bytes[i] > bytes[best]) best = i;
        { const char *t = tags[j]; long y = bytes[j];
          tags[j] = tags[best]; bytes[j] = bytes[best];
          tags[best] = t; bytes[best] = y; }
        fprintf(stderr, "memprobe:   %10ld %s\n", bytes[j], tags[j]);
    }
}

void rtm_dump(const char *phase)
{
    int lvl = rtm_get_level();

    if (lvl > 0) {
        fprintf(stderr,
            "memprobe: %s | live68k=%ld peak68k=%ld live=%ld peak=%ld blocks=%ld handles=%ld allocs=%ld\n",
            phase, rtm_live68k, rtm_peak68k, rtm_live, rtm_peak,
            rtm_blocks, rtm_handles, rtm_allocs);
        if (lvl > 1) {
            rtm_tag_histogram();
#ifdef RTM_CENSUS
            rtm_census();
#endif
        }
    }
    rtm_peak = rtm_live;
    rtm_peak68k = rtm_live68k;
    rtm_allocs = 0;
}
```

In `rt_mem_exit_check`, right after `rt_run_cleanup();` and **before** the `CLARUS_MEM_STRICT` early return:

```c
    if (rtm_get_level() > 0) {
        fprintf(stderr, "memprobe: TOTAL | peakAll68k=%ld\n", rtm_peak_all68k);
    }
```

`rt_mem.h`, next to `rt_mem_live_count`: the `rtm_counters` typedef and the `rtm_get`/`rtm_dump` prototypes from the Interfaces block. They must be outside any Mac-only `#if` branch that hides them from the host build; check which branch `rt_mem_live_count` sits in and match it.

- [ ] **Step 4: Add the extern in `rt_ext_host.inc`** (next to `rt_ext_CorePanic`, same Pascal-string idiom):

```c
/* rt_ext_MemProbe: host body of clarusc/main.cla's feMemProbe seam (SE
 * Wave 0). The phase name arrives as a Pascal string; rtm_dump prints
 * only under CLARUS_MEM_PEAK, so an ordinary compile stays byte-silent.
 * On the 68k lane the same extern is `= inline nop`. */
void rt_ext_MemProbe(const uint8_t *phase) {
    char buf[256];
    uint8_t n = phase[0];
    memmove(buf, phase + 1, (size_t)n);
    buf[n] = '\0';
    rtm_dump(buf);
}
```

- [ ] **Step 5: Run the new test and the other hostrt tests**

Run: `make test T=hostrt/`
Expected: every script PASSes. `mem.sh` and `rc.sh` also compile `rt_mem_host.inc` through their own translation units; they must still build with `-Wall -Werror` (no unused-static warnings). If `rtm_tag_histogram` or `rtm_get_level` is unused in a TU, that is a warning: keep them reachable from `rtm_dump`, which is non-static.

- [ ] **Step 6: Check silence and output by hand**

```sh
make -j tools bootstrap
build-run/clarusc-current emit68k -o /tmp/x.bin examples/hello-mac.cla 2> /tmp/e0; cat /tmp/e0
CLARUS_MEM_PEAK=1 build-run/clarusc-current emit68k -o /tmp/x.bin examples/hello-mac.cla 2>&1 | grep memprobe
```
Expected: the first run's stderr has no `memprobe` line. The second shows only the `memprobe: TOTAL | peakAll68k=…` line; phase lines appear after Task 6. The count is real, since the counters are compiled into `rt.c`.

- [ ] **Step 7: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add runtime/host/rt_mem_host.inc runtime/host/rt_mem.h runtime/host/rt_ext_host.inc runtime/host/rt_memprobe_test.c tests/hostrt/memprobe.sh
git commit -m "feat(rt-host): live/peak memory counters with a 68k cost model (SE wave 0)"
```

---

### Task 2: `= inline sp` extern clause (byte-identical; one new golden)

**Files:**
- Modify: `clarusc/parse.cla` (~l.101-103 `var cwSp`, ~l.139-141 intern, ~l.1752 grammar comment, ~l.1930-1943 parse branch and error text)
- Modify: `clarusc/ast.cla` (conv-code comments ~l.164-172 and ~l.1777-1784)
- Modify: `clarusc/check.cla` (doc ~l.3268-3270; check twin ~l.3372-3374)
- Modify: `clarusc/cg68k.cla` (table comment ~l.11059-11062; new `cgCallExtSp` beside `cgCallExtA5` ~l.11538; dispatch ~l.11651-11672)
- Modify: `clarusc/test/check_test.cla` + `clarusc/test/check_test.out` (new diagnostic case)
- Create: `testdata/cg68k/inline_sp.cla`, `testdata/cg68k/inline_sp.s` (blessed)
- Modify: `docs/clarus-language-reference.md` (~l.1959 list, and a paragraph after ~l.1975)

**Interfaces:**
- Produces: conv code **11** = `inline sp`. The signature must be `(): ptr`. On the 68k it emits `MOVE.L A7,D0`; the C printer emits an ordinary `rt_ext_<Name>` call (no C shim is added, because no C-lane program uses it).
- Codes 0–10 keep their numbers; baked `.clir` files store them raw.

- [ ] **Step 1: Write the failing tests**

`testdata/cg68k/inline_sp.cla` is a twin of `testdata/cg68k/inline_a5.cla`. Open that file and mirror its shape exactly, including whatever `app` block or `App.startCLI` handler it uses, replacing `TestA5`/`inline a5` with:

```
external func TestSp(): ptr = inline sp
```

and in the handler body, the same use `inline_a5.cla` makes of `TestA5()` (e.g. assigning it to a `ptr` var and branching on `!= ptr(0)`).

`clarusc/test/check_test.cla`: next to Case 72 (`extern-inline-nop-bad-return`), add a case in the same format:

```
// Case NN: extern-inline-sp-bad-sig
external func BadSp(x: int): ptr = inline sp
```

(match the exact case-header convention used by Cases 69/72; `NN` is the next free case number). Add the expected diagnostic line to `clarusc/test/check_test.out` in the same position/format as the Case 72 line:
`check_test.cla:L:C: inline sp requires signature (): ptr`

- [ ] **Step 2: Run to verify they fail**

Run: `make test T='cg68k/goldens selfhost/modules'`
Expected: `cg68k/goldens` fails, because `inline_sp` has no golden and the parse errors with `expected "deref", "nop", or "a5"`. `selfhost/modules` fails on the check_test diff.

- [ ] **Step 3: Implement**

parse.cla: `var cwSp: int` next to `cwA5`, and `cwSp = intern("sp")` next to `cwA5 = intern("a5")`. In the inline branch, after the `cwA5` arm:

```
            } else if curIsIdentIdx(cwSp) {
                advance()
                convFlag = 11
            } else {
                parseErrorf(curLine(), curCol(), "expected \"deref\", \"nop\", \"a5\", or \"sp\", found " + tokKindQuoted(curKind()))
```

Update the grammar comment to `( "deref" | "nop" | "a5" | "sp" )`, with a history note: `inline sp` added by SE wave 0.

ast.cla: append `11=inline sp` to both conv-code comment lists.

check.cla, after the conv 5 check:

```
    if conv == 11 and (i != 0 or ret == -1 or typeKind(ret) != TyPtr) {
        emitDiag(declLine(d), declCol(d), "inline sp requires signature (): ptr")
    }
```

and extend the doc comment (~l.3268) with one sentence: `inline sp (conv 11, SE wave 0: MOVE.L A7,D0) requires zero params and a ptr return`.

cg68k.cla, next to `cgCallExtA5`:

```
// cgCallExtSp implements `= inline sp` (SE wave 0): the current stack
// pointer, MOVE.L A7,D0. Read at the call site, so it is the caller's SP
// (no frame of its own). checkExternFunc guarantees zero params and a ptr
// return. Used by clarusc/macgui.cla's stack high-water probe.
func cgCallExtSp(e: int) {
    a68Emit(OpMove, 4, AmAn, 7, 0, AmDn, 0, 0)
}
```

Dispatch: `} else if conv == 11 { cgCallExtSp(e) }` next to the `conv == 5` arm. Table comment: append `11=inline sp (SE wave 0)`.

Reference doc: change l.1959's list to "`= inline deref`, `= inline nop`, `= inline a5` and `= inline sp`", and after the `inline a5` paragraph and example add:

> `inline sp` requires zero parameters and a `ptr` return; it reads the
> current value of the 68k stack pointer (A7) at the call site. It is
> meant for stack-depth probes (paint-and-scan high-water measurement);
> the value is only meaningful relative to the low-memory globals
> `CurStackBase` (0x908) and `ApplLimit` (0x130). Native lane only: a C
> lane build resolves it as an ordinary `rt_ext_` extern.
> ```rust
> external func CurrentSP(): ptr = inline sp
> ```

- [ ] **Step 4: Bless the new golden only**

```sh
CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens
git status --short testdata/
```
Expected: exactly `?? testdata/cg68k/inline_sp.s` (plus any `.segN.s` siblings for the new fixture, if that is how goldens are named; follow what `inline_a5`'s golden files look like). **No modified (`M`) golden.** Check that the listing contains `MOVE.L A7,D0`: `grep -n 'MOVE.L\s*A7,D0' testdata/cg68k/inline_sp*.s`.

- [ ] **Step 5: Run the tests**

Run: `make test T='cg68k/ selfhost/modules asm68k/'`, then `scripts/test-task.sh`.
Expected: all PASS. If `vasm` is present, `tests/cg68k/vasm.sh` round-trips the new fixture's encoding.

- [ ] **Step 6: Commit**

```bash
git add clarusc/parse.cla clarusc/ast.cla clarusc/check.cla clarusc/cg68k.cla clarusc/test/check_test.cla clarusc/test/check_test.out testdata/cg68k/inline_sp* docs/clarus-language-reference.md
git commit -m "feat(clarusc): = inline sp extern clause (MOVE.L A7,D0) (SE wave 0)"
```

(The `clarusc/clarusc.c` snapshot is NOT regenerated here; Task 7 does it once. `selfhost/` is not in T1.)

---

### Task 3: `toolbox/memory.cla` gains MaxBlock and siblings (byte-identical)

**Files:**
- Modify: `toolbox/memory.cla` (header verification notes ~l.125-185, declarations after l.187)
- Modify: `docs/clarus-toolbox-cookbook.md` only if it lists memory.cla's routines (grep it; add the new names to any such list)

**Interfaces:**
- Produces (consumed by Tasks 4 and 6):
  ```
  external func MaxBlock(): int = trap 0xA061 reg
  external func StackSpace(): int = trap 0xA065 reg
  external func MaxApplZone() = trap 0xA063 reg
  ```
  plus the siblings in Step 1 that verify cleanly.

- [ ] **Step 1: Verify every trap word and register convention against the headers**

Read the Universal Interfaces through `LC_ALL=C tr '\r' '\n'`, e.g.:
```sh
LC_ALL=C tr '\r' '\n' < toolchain/universal/CIncludes/MacMemory.h | grep -n -E 'MaxBlock|StackSpace|MaxApplZone|HPurge|HNoPurge|EmptyHandle|NewEmptyHandle|GetPtrSize|SetApplLimit|HGetState|HSetState|ReserveMem'
```
For each candidate, record its trap word, its `#pragma parameter` registers, and whether its D0 is a result or an OSErr (use `reg memerr` for a void procedure whose D0 is an error code, as memory.cla's existing entries do). Add only routines whose convention `reg` can express. **Required:** MaxBlock (0xA061), StackSpace (0xA065), MaxApplZone (0xA063). **Add if they verify:** HPurge, HNoPurge, EmptyHandle, NewEmptyHandle, GetPtrSize, HGetState, HSetState, ReserveMem, SetApplLimit. Skip any routine with two outputs (e.g. `PurgeSpace`), and note the skip in the header the way the `MaxMem` note does.

- [ ] **Step 2: Add the declarations and header notes**

Append the verified declarations after `MaxMem` (l.187), each with a one-line verification note in the header block, in the existing style (trap word, source header, register mapping).

- [ ] **Step 3: Run the catalog checks**

Run: `make test T='testsuite/catalog testsuite/catalog_ui'`
Expected: PASS. The driver type-checks every catalog file, so a malformed clause fails here.

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS.
```bash
git add toolbox/memory.cla docs/clarus-toolbox-cookbook.md
git commit -m "feat(toolbox): memory.cla gains MaxBlock, StackSpace, MaxApplZone and siblings (SE wave 0)"
```

---

### Task 4: SE app budget probe (Snow SE, System 6) (byte-identical)

Needs Task 3 merged.

**Files:**
- Create: `testdata/snow/sebudget.cla`
- Create: `tests/mactest/snow/se_budget.sh`

**Interfaces:**
- Consumes: `MaxBlock`, `FreeMem` from `toolbox/memory.cla` (via `include`).
- Produces (read by Task 9), one line each in `out`:
  `SEBUDGET FreeMem=N MaxBlock=N ApplZone=N ApplLimit=N HeapEnd=N CurStackBase=N BufPtr=N MemTop=N`

- [ ] **Step 1: Write the probe app** `testdata/snow/sebudget.cla`. Model it on `testdata/snow/roundtrip.cla`: open that file and copy its `app` block, window and `on App.launch` shape exactly. The probe does no file I/O, so it can log straight from `App.launch`:

```
// SE memory program Wave 0: the single-app memory budget on the Snow SE
// (4 MB, System 6.0.8, launched via the boot-block autostart -- no
// MultiFinder). Logs FreeMem/MaxBlock and the Memory Manager low-memory
// globals, then quits. tests/mactest/snow/se_budget.sh reads the line.
include "toolbox/memory.cla"

// (copy roundtrip.cla's app block / window declaration here verbatim,
//  renaming the app to SeBudget)

func lowl(addr: int): int {
    return peekl(ptr(addr))
}

on App.launch {
    var line: string
    line = "SEBUDGET FreeMem=" + string(FreeMem())
    line = line + " MaxBlock=" + string(MaxBlock())
    line = line + " ApplZone=" + string(lowl(0x02AA))
    line = line + " ApplLimit=" + string(lowl(0x0130))
    line = line + " HeapEnd=" + string(lowl(0x0114))
    line = line + " CurStackBase=" + string(lowl(0x0908))
    line = line + " BufPtr=" + string(lowl(0x010C))
    line = line + " MemTop=" + string(lowl(0x0108))
    log(line)
    quit
}
```

If `quit` is not legal inside `App.launch`, follow `roundtrip.cla` and do the work in an `every 60 ticks` block instead. Build it once on the host to check that it compiles: `scripts/build-68k.sh testdata/snow/sebudget.cla`.

- [ ] **Step 2: Write the script** `tests/mactest/snow/se_budget.sh`:

```sh
#!/bin/sh
# timeout: 15m
# SE memory program Wave 0: measure the single-app memory budget on the
# Snow SE (4 MB, System 6.0.8; boot-block autostart, no MultiFinder).
# Prints the raw probe line plus derived numbers; asserts only that the
# probe ran. The numbers are recorded in the SE program's design doc §9.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
SNOW_SYSTEM=6
export SNOW_SYSTEM

BIN=$ROOT/build-68k/SeBudget/SeBudget.bin
"$ROOT/scripts/build-68k.sh" testdata/snow/sebudget.cla > "$WORK/build.log" 2>&1 \
    || die "build-68k.sh testdata/snow/sebudget.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk 6
snow_put_bin "$BIN" SeBudget
snow_run 300 "$(snow_done_when_trailer 10)"
snow_get "${SNOW_APPDIR}out" "$WORK/out"
cat "$WORK/out"

line=$(grep '^SEBUDGET ' "$WORK/out")
if [ -n "$line" ]; then t_pass probe_ran; else t_fail probe_ran "no SEBUDGET line in out"; fi
grep -qF '##CLARUS-EXIT## 0' "$WORK/out" && t_pass clean_exit || t_fail clean_exit "no clean exit trailer"

val() { echo "$line" | tr ' ' '\n' | sed -n "s/^$1=//p"; }
if [ -n "$line" ]; then
    free=$(val FreeMem); zone=$(val ApplZone); buf=$(val BufPtr)
    echo "SE budget: FreeMem=$free bytes ($((free / 1024)) KB); app space BufPtr-ApplZone=$((buf - zone)) bytes ($(((buf - zone) / 1024)) KB)"
fi
t_done
```

(Match the build-output name: if `build-68k.sh` derives a name other than `SeBudget` from the app block, fix `BIN`.)

- [ ] **Step 3: Run it on the emulator**

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
CLARUS_SNOW_TESTS=1 make test T=mactest/snow/se_budget
cat build-run/tests/mactest/snow/se_budget.log
```
Expected: PASS for `probe_ran` and `clean_exit`, plus the `SE budget:` line. **Copy the `SEBUDGET` line and the `SE budget:` line verbatim into the task report**; Task 9 records them. If the boot hangs, the script's `snow_run` stops only the pid it launched. Do not kill other emulators.

- [ ] **Step 4: Check the script skips without the gate**

Run: `make test T=mactest/snow/se_budget` (no env). Expected: SKIP.

- [ ] **Step 5: Commit**

```bash
git add testdata/snow/sebudget.cla tests/mactest/snow/se_budget.sh
git commit -m "test(snow): SE single-app memory budget probe (SE wave 0)"
```

---

### Task 6: `feMemProbe` seam and ClarusC.APPL probes (byte-identical for user programs)

Needs Tasks 1, 2 and 3 merged.

**Files:**
- Modify: `clarusc/drive.cla` (`driveProgressPhase` ~l.860, `driveProgressDone` ~l.881)
- Modify: `clarusc/main.cla` (feProgress block ~l.66-77)
- Modify: `clarusc/macgui.cla` (feProgress block ~l.276; `Compile.select` ~l.764)
- Modify: `clarusc/test/dblcompile.cla`, `clarusc/test/dblcompile_bake.cla` (they include drive.cla, so each needs a `feMemProbe`; check them for their own `feProgress` bodies and add a no-op `feMemProbe` beside them)
- Modify: any other file that includes `drive.cla` (`/usr/bin/grep -arln 'drive.cla' clarusc/ testsuite/ tests/`)

**Interfaces:**
- Consumes: `rt_ext_MemProbe` (Task 1), `= inline sp` (Task 2), `FreeMem`/`MaxBlock` (Task 3).
- Produces:
  - every front end defines `func feMemProbe(phase: string)`;
  - drive.cla calls it after each phase line, and after the final `Finished` with phase `"Done"`;
  - on the host, `memprobe: <phase> | …` lines appear under `CLARUS_MEM_PEAK=1` (Task 7 parses them);
  - in ClarusC's `out`, after every phase line, `  mem: free N KB, max M KB`, and after every compile, `  stack: high-water N KB of M KB` (or `  stack: probe unavailable`). Task 8 parses these.

- [ ] **Step 1: Wire drive.cla**

In `driveProgressPhase`, after `drvPhaseTicks = t`: `feMemProbe(msg)`. In `driveProgressDone`, after `driveProgress("Finished")`: `feMemProbe("Done")`. Both functions already return early unless `want68k`, so the C `emit` lane never reaches the probe; say so in a comment on `feMemProbe`'s first use.

- [ ] **Step 2: main.cla host body**

After `feProgressTick`:

```
// feMemProbe: SE wave 0 per-phase memory probe. The host runtime's
// rt_ext_MemProbe prints a `memprobe:` line only when CLARUS_MEM_PEAK is
// set (tests/memgate/); otherwise silent. On the 68k lane (selfemit /
// bake self-compile of this file) it is `inline nop`: no code at all.
external func MemProbe(phase: string) = inline nop

func feMemProbe(phase: string) {
    MemProbe(phase)
}
```

Check that `inline nop` accepts a parameter: `make test T='cg68k/selfemit bake/identity'` must pass. If the checker or cg68k rejects a param on `inline nop`, add `nat_MemProbe` instead: a no-op `func nat_MemProbe(phase: string) {}` placed in **main.cla itself**, not the runtime, so that no runtime golden moves; confirm `cgCallExtNatFallback` finds user-level `nat_` functions. Record which route was taken in the commit message.

- [ ] **Step 3: macgui.cla probes**

Include the catalog if macgui does not already reach `FreeMem`: `include "../toolbox/memory.cla"` (or the path form macgui's other toolbox includes use; if the include collides with an existing declaration of `FreeMem`, identical redeclarations merge, so keep one). Then, near `feProgress`:

```
// ---- SE wave 0 on-target probes (always on; spec W3) ----
// feMemProbe: after every compile phase line, the heap's FreeMem and
// MaxBlock. A separate line so the phase line's own shape is untouched.
func feMemProbe(phase: string) {
    log("  mem: free " + numToStr(FreeMem() / 1024) + " KB, max " + numToStr(MaxBlock() / 1024) + " KB")
}

// Stack high-water: paint the unused stack below the current SP with a
// pattern right before a compile, scan for the deepest overwritten long
// right after. CurStackBase (0x908) is the stack's top, ApplLimit (0x130)
// its floor (cg68k's startup SetApplLimit reserve).
external func GcStackPtr(): ptr = inline sp
const gcStackPat: int = 0x5AA5C33C
var gcStackLo: int
var gcStackHi: int

func gcStackPaint() {
    var a: int
    gcStackLo = peekl(ptr(0x0130)) + 16
    gcStackHi = int(GcStackPtr()) - 1024
    if gcStackHi <= gcStackLo {
        gcStackLo = 0
        return
    }
    a = gcStackLo
    while a < gcStackHi {
        pokel(ptr(a), gcStackPat)
        a = a + 4
    }
}

func gcStackReport() {
    var a: int
    var top: int
    var floor: int
    if gcStackLo == 0 {
        log("  stack: probe unavailable")
        return
    }
    a = gcStackLo
    while a < gcStackHi and peekl(ptr(a)) == gcStackPat {
        a = a + 4
    }
    top = peekl(ptr(0x0908))
    floor = peekl(ptr(0x0130))
    log("  stack: high-water " + numToStr((top - a) / 1024) + " KB of " + numToStr((top - floor) / 1024) + " KB")
}
```

If `int(ptr)` is not a legal conversion, use the idiom `runtime/clarus/native.cla` uses for pointer arithmetic (it adds ints to `ptr` values directly), and keep the variables as `ptr` with the same logic. Do not change `native.cla`.

In `on Compile.select`, wrap the compile call so that every exit path of `gcCompile` is covered:

```
        if askOpen(p, "TEXT") {
            gcStackPaint()
            gcCompile(w, p)
            gcStackReport()
        }
```

- [ ] **Step 4: Front-end stubs**

In every other file that includes `drive.cla` (the dblcompile drivers and anything the grep in Files found), add a no-op beside that file's own `feProgress`:

```
func feMemProbe(phase: string) {
}
```

- [ ] **Step 5: Check host byte-silence against the snapshot**

```sh
make -j tools bootstrap
for f in examples/bookmarks.cla examples/hello-mac.cla; do
  build-run/clarusc-snapshot emit68k -o /tmp/a.bin $f 2> /tmp/a.err
  build-run/clarusc-current  emit68k -o /tmp/b.bin $f 2> /tmp/b.err
  cmp /tmp/a.bin /tmp/b.bin && sed 's/([^)]*)//' /tmp/a.err > /tmp/a.n && sed 's/([^)]*)//' /tmp/b.err > /tmp/b.n && diff /tmp/a.n /tmp/b.n && echo "same $f"
done
CLARUS_MEM_PEAK=1 build-run/clarusc-current emit68k -o /tmp/b.bin examples/bookmarks.cla 2>&1 | grep '^memprobe:'
```
Expected: `same` for both files (the phase durations are stripped before the diff, since timings differ). The last command prints one `memprobe:` line per phase plus `Done` and `TOTAL`.

- [ ] **Step 6: Compile ClarusC.APPL with the current compiler (compile check only; no boot in this task)**

`scripts/build-clarusc-mac.sh` bootstraps from the committed snapshot, which does not know `inline sp` until Task 7 regenerates it, so do not use it here. Compile macgui directly with the current-source compiler, using the same flags the script's final `emit68k` line uses (see `scripts/build-clarusc-mac.sh` ~l.106):

```sh
build-run/clarusc-current emit68k --testapi --rtdir runtime/clarus/ --listing -o /tmp/ClarusC.bin clarusc/macgui.cla
grep -l 'MOVE.L\s*A7,D0' /tmp/ClarusC*.s
```
Expected: it compiles with no diagnostics, and a listing segment contains `MOVE.L A7,D0`.

- [ ] **Step 7: T1 and commit**

Run: `scripts/test-task.sh`, then `make test T='cg68k/selfemit bake/identity selfhost/modules'`.
Expected: all PASS (`selfhost/fixedpoint` is expected to fail until Task 7; do not run the whole `selfhost/` group here).
```bash
git add clarusc/drive.cla clarusc/main.cla clarusc/macgui.cla clarusc/test/dblcompile.cla clarusc/test/dblcompile_bake.cla
git commit -m "feat(clarusc): feMemProbe seam; ClarusC logs per-phase FreeMem/MaxBlock and stack high-water (SE wave 0)"
```

---

### Task 7: Snapshot regeneration and `tests/memgate/` (serialization point; runs alone)

Needs Tasks 1–3 and 6 merged. Nothing else runs concurrently.

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)
- Create: `tests/memgate/peak.sh`
- Create: `tests/memgate/budget.txt`
- Modify: `CLAUDE.md` (build/test section: memgate, `CLARUS_MEM_PEAK`, memcensus pointer)

**Interfaces:**
- Consumes: the `memprobe:` output format from Task 1.
- Produces: `budget.txt` lines `bookmarks_rtbake N`, `bookmarks_src N`, `hello_src N` (68k-equivalent bytes), read by later waves' ratchet edits.

- [ ] **Step 1: Regenerate the snapshot**

Run `make test T=selfhost/fixedpoint`. It fails with `snapshot_fresh` and prints the Go-free regeneration recipe; follow that recipe exactly. Re-run until `selfhost/fixedpoint` PASSes. Then run `make test T=selfhost/` (it takes several minutes; each script carries its own `# timeout: 30m`). Expected: all PASS.

- [ ] **Step 2: Write the gate script** `tests/memgate/peak.sh`:

```sh
#!/bin/sh
# SE memory program ratchet (Wave 0 onward): peak live heap of a compile,
# in 68k-equivalent bytes (round4(size) + 8-byte block header, + 4 per
# handle master pointer -- the SE's 24-bit Memory Manager), measured by
# the host runtime's counters (CLARUS_MEM_PEAK=1, rt_mem_host.inc) and
# compared with tests/memgate/budget.txt. Host allocation is
# deterministic; the budget is the measured peak + 1%. Lower a budget
# whenever a change earns it ("note: ratchet available"); never raise
# one without a written reason in budget.txt. Spec:
# docs/superpowers/specs/2026-09-27-se-wave0-measurement-design.md §3.4.
. "$(dirname "$0")/../lib.sh" || exit 2
BUDGET=$ROOT/tests/memgate/budget.txt
[ -f "$BUDGET" ] || die "missing $BUDGET"

"$CLARUSC" --bake-ir --lane 68k --rtdir "$RTDIR" -o "$WORK/rt.clir" > "$WORK/bake.log" 2>&1 \
    || die "bake-ir failed: $(tail -3 "$WORK/bake.log" | tr '\n' ' ')"

measure() {
    _name=$1; shift
    _budget=$(awk -v n="$_name" '$1 == n { print $2 }' "$BUDGET")
    case "$_budget" in
        ''|*[!0-9]*) t_fail "$_name" "no numeric budget for $_name in $BUDGET"; return ;;
    esac
    if ! CLARUS_MEM_PEAK=1 "$CLARUSC" emit68k "$@" -o "$WORK/$_name.bin" > /dev/null 2> "$WORK/$_name.err"; then
        t_fail "$_name" "emit68k failed: $(tail -3 "$WORK/$_name.err" | tr '\n' ' ')"
        return
    fi
    grep '^memprobe:' "$WORK/$_name.err"
    _peak=$(sed -n 's/^memprobe: TOTAL | peakAll68k=\([0-9][0-9]*\)$/\1/p' "$WORK/$_name.err")
    [ -n "$_peak" ] || { t_fail "$_name" "no memprobe TOTAL line"; return; }
    _pct=$(awk -v p="$_peak" -v b="$_budget" 'BEGIN { printf "%.1f", 100 * p / b }')
    echo "$_name: peak $_peak / budget $_budget ($_pct%)"
    if [ "$_peak" -gt "$_budget" ]; then
        t_fail "$_name" "peak $_peak exceeds budget $_budget"
        return
    fi
    awk -v p="$_peak" -v b="$_budget" 'BEGIN { exit !(p < 0.95 * b) }' \
        && echo "note: ratchet available for $_name (peak under 95% of budget)"
    t_pass "$_name"
}

measure bookmarks_rtbake --rtdir "$RTDIR" --rtbake "$WORK/rt.clir" examples/bookmarks.cla
measure bookmarks_src --rtdir "$RTDIR" examples/bookmarks.cla
measure hello_src --rtdir "$RTDIR" examples/hello-mac.cla
t_done
```

- [ ] **Step 3: Run it with a placeholder budget to verify it fails**

Write `tests/memgate/budget.txt` as:

```
# tests/memgate/peak.sh budgets: peak live heap, 68k-equivalent bytes.
# One "name bytes" line per subcase. Change log (newest first):
bookmarks_rtbake 1
bookmarks_src 1
hello_src 1
```

Run: `make test T=memgate/`. Expected: FAIL on all three with `peak N exceeds budget 1`. Note the three peaks from the log (`build-run/tests/memgate/peak.log`).

- [ ] **Step 4: Set the baseline budgets**

For each peak `P`, the budget is `ceil(P * 1.01)`: `awk -v p=P 'BEGIN { printf "%d\n", int(p * 1.01) + 1 }'`. Write them, with a change-log line:

```
# 2026-09-27 wave 0 baseline: measured peaks <P1> / <P2> / <P3> + 1%.
```

(substituting the real numbers). Run `make test T=memgate/` three times. Expected: PASS every time, with identical peaks each run (determinism check). If the peaks differ between runs, stop and report. Record the time the script takes (the `<secs>s` on its result line).

- [ ] **Step 5: Document**

In CLAUDE.md's "Build and test" section, add a bullet after the perfgate/tiered-gates text:

```
- **Memory ratchet (SE memory program, Wave 0, 2026-09-27).**
  `tests/memgate/peak.sh` (T1) measures a compile's peak live heap in
  68k-equivalent bytes (round4(size) + 8-byte block header, + 4 per
  handle) from the host runtime's counters and fails over
  `tests/memgate/budget.txt` (measured peak + 1%; host allocation is
  deterministic). `CLARUS_MEM_PEAK=1` makes any host clarus binary print
  a `memprobe:` line per compile phase plus a `TOTAL` line at exit;
  `=2` adds a per-tag histogram. `scripts/memcensus.sh FILE.cla` names
  the compiler globals behind the bytes. A change that lowers a peak
  lowers its budget in the same commit.
```

- [ ] **Step 6: T1 and commit**

Run: `scripts/test-task.sh`. Expected: all PASS, memgate included.
```bash
git add clarusc/clarusc.c tests/memgate/ CLAUDE.md
git commit -m "test(memgate): host memory ratchet at the wave 0 baseline; regenerate snapshot (SE wave 0)"
```

---

### Task 5: `scripts/memcensus.sh` per-global census (diagnostic; byte-identical)

Needs Tasks 1 and 7 merged (Task 7 so that the current compiler emits the phase lines).

**Files:**
- Create: `scripts/memcensus.sh`

**Interfaces:**
- Consumes: `rtm_dump`'s `RTM_CENSUS` hook (Task 1); `build-run/clarusc-current.c` (Makefile bootstrap output).
- Produces, per phase under the `memprobe:` line:
  `memprobe:   census <bytes> <name> count=N elemsize=N cap=N`, top 25 globals by bytes.

- [ ] **Step 1: Look at the declarations the scan targets**

```sh
make -j tools bootstrap
grep -nE '^static (rt_list|rt_map|rt_text) \* ?cv_[A-Za-z0-9_]+;' build-run/clarusc-current.c | head
grep -n 'struct rt_text' -A6 runtime/host/rt_core.inc | head -12
```
Note the exact declaration spelling (spacing around `*`) and `struct rt_text`'s fields, and make the script's regex match what is really there. `rt_text` has a `Handle h` payload. `rt_map` has four handles (`keys`, `vals`, `keypool`, `index`); count all four.

- [ ] **Step 2: Write the script**

```sh
#!/bin/sh
# scripts/memcensus.sh [--rtbake] FILE.cla -- SE memory program diagnostic.
# Builds a census-enabled copy of the current compiler (its own globals
# are file-static in build-run/clarusc-current.c, so the census must be
# compiled into the same translation unit), then compiles FILE.cla for
# the 68k lane with CLARUS_MEM_PEAK=2: each phase's memprobe line is
# followed by the per-tag histogram and the top 25 compiler globals by
# payload bytes. Not a test; nothing gates on it.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BR=$ROOT/build-run
OUT=$BR/memcensus
BAKE=
if [ "$1" = --rtbake ]; then BAKE=1; shift; fi
[ $# -ge 1 ] || { echo "usage: $0 [--rtbake] FILE.cla..." >&2; exit 2; }
make -C "$ROOT" -j tools bootstrap > /dev/null
mkdir -p "$OUT"
SRC=$BR/clarusc-current.c

{
  cat "$SRC"
  echo '#include <stdio.h>'
  echo 'typedef struct { const char *n; long bytes, count, elem, cap; } rtm_row;'
  echo 'static long rtm_hsz(Handle h) { return h ? (long)GetHandleSize(h) : 0; }'
  echo 'void rtm_census(void) {'
  echo '  rtm_row r[4096]; int n = 0, i, j;'
  grep -oE '^static rt_list \* ?cv_[A-Za-z0-9_]+;' "$SRC" | sed -E 's/^static rt_list \* ?(cv_[A-Za-z0-9_]+);/  if (\1 \&\& n < 4096) { r[n].n = "\1"; r[n].bytes = rtm_hsz(\1->data); r[n].count = \1->count; r[n].elem = \1->elemsize; r[n].cap = \1->cap; n++; }/'
  grep -oE '^static rt_map \* ?cv_[A-Za-z0-9_]+;' "$SRC" | sed -E 's/^static rt_map \* ?(cv_[A-Za-z0-9_]+);/  if (\1 \&\& n < 4096) { r[n].n = "\1"; r[n].bytes = rtm_hsz(\1->keys) + rtm_hsz(\1->vals) + rtm_hsz(\1->keypool) + rtm_hsz(\1->index); r[n].count = \1->count; r[n].elem = \1->valsize; r[n].cap = \1->cap; n++; }/'
  grep -oE '^static rt_text \* ?cv_[A-Za-z0-9_]+;' "$SRC" | sed -E 's/^static rt_text \* ?(cv_[A-Za-z0-9_]+);/  if (\1 \&\& n < 4096) { r[n].n = "\1"; r[n].bytes = rtm_hsz(\1->h); r[n].count = r[n].bytes; r[n].elem = 1; r[n].cap = r[n].bytes; n++; }/'
  echo '  for (i = 0; i < 25 && i < n; i++) { int b = i; rtm_row t;'
  echo '    for (j = i + 1; j < n; j++) if (r[j].bytes > r[b].bytes) b = j;'
  echo '    t = r[i]; r[i] = r[b]; r[b] = t;'
  echo '    fprintf(stderr, "memprobe:   census %10ld %s count=%ld elemsize=%ld cap=%ld\n", r[i].bytes, r[i].n, r[i].count, r[i].elem, r[i].cap); }'
  echo '}'
} > "$OUT/clarusc-census.c"

${CC:-cc} -O1 -DRTM_CENSUS -I "$ROOT/runtime/host" -o "$OUT/clarusc-census" \
    "$OUT/clarusc-census.c" "$ROOT/runtime/host/rt.c"

cd "$ROOT"
if [ -n "$BAKE" ]; then
    "$OUT/clarusc-census" --bake-ir --lane 68k --rtdir runtime/clarus/ -o "$OUT/rt.clir"
    CLARUS_MEM_PEAK=2 "$OUT/clarusc-census" emit68k --rtdir runtime/clarus/ --rtbake "$OUT/rt.clir" -o "$OUT/out.bin" "$@" 2>&1 | grep '^memprobe:'
else
    CLARUS_MEM_PEAK=2 "$OUT/clarusc-census" emit68k --rtdir runtime/clarus/ -o "$OUT/out.bin" "$@" 2>&1 | grep '^memprobe:'
fi
```

Adjust the struct field names to what Step 1 found (e.g. if `rt_text`'s handle field is not `h`). The census TU needs `struct rt_list`/`rt_map`/`rt_text` to be complete types; if `clarusc-current.c` only has them as opaque typedefs, add local mirror structs copied from `rt_core.inc` (the spec's §3.5 fallback) and cast through them.

- [ ] **Step 3: Run it**

Run: `scripts/memcensus.sh --rtbake examples/bookmarks.cla | head -60`
Expected: for each phase, a `memprobe:` line, up to 15 tag lines and up to 25 `census` lines. The biggest `census` entries at the peak phase should be the tables the findings doc names (e.g. `cv_strPool`, `cv_a68Items`, `cv_exprs`). Paste the peak phase's top 10 census lines into the task report; Task 9 records them.

- [ ] **Step 4: Commit**

```bash
chmod +x scripts/memcensus.sh
git add scripts/memcensus.sh
git commit -m "feat(scripts): memcensus.sh per-global compiler heap census (SE wave 0)"
```

---

### Task 8: Mac IIcx baseline run (`clarusc_memprobe.sh`) (byte-identical)

Needs Task 7 merged. It may run while Task 5 runs. It takes the Snow lock, so it serializes against Task 4 if both are running.

**Files:**
- Create: `testdata/mac-resident/clarusc-bookmarks.events`
- Create: `tests/mactest/snow/clarusc_memprobe.sh`

**Interfaces:**
- Consumes: ClarusC's `  mem:` / `  stack:` lines (Task 6).
- Produces: `$WORK/memprobe.txt`, copied into the log; Task 9 reads it from `build-run/tests/mactest/snow/clarusc_memprobe.log`.

- [ ] **Step 1: Events file** `testdata/mac-resident/clarusc-bookmarks.events`:

```
answer-open Clarus:bookmarks.cla
menu 2 1
quit
```

- [ ] **Step 2: Script** `tests/mactest/snow/clarusc_memprobe.sh`, modeled on `clarusc_bake.sh` (open it and keep its structure):

```sh
#!/bin/sh
# timeout: 90m
# SE memory program Wave 0 (and every wave close, umbrella §7): ClarusC.APPL
# compiles examples/bookmarks.cla on the Snow Mac IIcx (System 7.1) and
# logs, per compile phase, FreeMem/MaxBlock (`  mem:` lines) and, after
# the compile, its stack high-water (`  stack:`). The numbers are
# recorded in the SE program design doc §9; this script asserts only that
# the probes ran and the log was not truncated at natLogCap.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
snow_clarusc_system

EVENTS=$ROOT/testdata/mac-resident/clarusc-bookmarks.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$ROOT/examples/bookmarks.cla" bookmarks.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-55m}")
snow_run $(( SETTLE + 1200 )) "$(snow_done_when_trailer 30)"

snow_get "${SNOW_APPDIR}out" "$WORK/out"
echo "--- app out ($(wc -c < "$WORK/out" | tr -d ' ') bytes)"
cat "$WORK/out"
echo "--- end app out"

grep -E 'ticks\)$|^  mem: |^  stack: |^Compiled |^Finished' "$WORK/out" > "$WORK/memprobe.txt" || true
echo "--- memprobe"
cat "$WORK/memprobe.txt"
echo "--- end memprobe"

phases=$(grep -c 'ticks)$' "$WORK/out" || true)
mems=$(grep -c '^  mem: ' "$WORK/out" || true)
[ "$phases" -gt 0 ] && [ "$mems" -ge "$phases" ] && t_pass mem_lines \
    || t_fail mem_lines "phases=$phases mem lines=$mems"
[ "$(snow_count '  stack: high-water' "$WORK/out")" = 1 ] && t_pass stack_line \
    || t_fail stack_line "expected one '  stack: high-water' line"
grep -q '^Finished' "$WORK/out" && t_pass not_truncated \
    || t_fail not_truncated "no Finished line: out is $(wc -c < "$WORK/out") bytes (natLogCap 4096)"
snow_no_error_markers no_error_markers "$WORK/out"
grep -qF '##CLARUS-EXIT## 0' "$WORK/out" && t_pass clean_exit || t_fail clean_exit "no clean exit trailer"
t_done
```

The `Compiled …` line also ends in `ticks)`, and `driveProgressDone` emits a `mem:` line after `Finished`, so `mems ≥ phases` holds. If `snow_count`'s argument convention differs, match `clarusc_bake.sh`'s use of it.

- [ ] **Step 3: Run it on the emulator**

```sh
export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_memprobe
sed -n '/--- memprobe/,/--- end memprobe/p' build-run/tests/mactest/snow/clarusc_memprobe.log
```
Expected: all subcases PASS in roughly 10–20 minutes. **Paste the whole memprobe block and the `out` byte count into the task report.**

- If `not_truncated` fails, the log hit `natLogCap`. Report it and stop; the controller then schedules the spec §4.1 `natLogCap` task, which is output-changing and moves every native golden.
- If `stack_line` reports `probe unavailable`, report that as well.

- [ ] **Step 4: Check the script skips without the gate, then commit**

Run: `make test T=mactest/snow/clarusc_memprobe`. Expected: SKIP.
```bash
git add testdata/mac-resident/clarusc-bookmarks.events tests/mactest/snow/clarusc_memprobe.sh
git commit -m "test(snow): ClarusC per-phase heap + stack probe run on the IIcx (SE wave 0)"
```

---

### Task 9: Recording, calibration, docs and end-of-wave gates (controller-driven)

Needs Tasks 1–8 merged. The controller runs the gates. An Opus subagent writes the docs from the numbers the reports carried.

**Files:**
- Modify: `docs/superpowers/specs/2026-09-27-se-memory-program-design.md` (§9 status table and numbers; the umbrella §5.5 wave-0 budget row, with the measured value)
- Modify: `docs/superpowers/specs/2026-09-27-se-wave0-measurement-design.md` (status line: complete)
- Modify: `docs/ROADMAP.md` ("Where we are" date and a Wave 0 line, and refresh the stale "prerequisite" sentence)
- Modify: `docs/HISTORY.md` (Wave 0 entry)

- [ ] **Step 1: Calibration table** (spec §5.3). From Task 8's memprobe block and a fresh `CLARUS_MEM_PEAK=1 build-run/clarusc-current emit68k --rtdir runtime/clarus/ --rtbake <clir> -o /tmp/b.bin examples/bookmarks.cla` run:
  - IIcx heap used at phase k = (`free` on the first `mem:` line after the `Installed baked runtime` phase, i.e. the post-install baseline) − (`free` at phase k). Use the post-install point because the CLIR resource and the code segments are resident on the Mac but never counted on the host.
  - Host figure at phase k = `live68k + 4 × blocks` from the matching `memprobe:` line, minus the host's live68k at `Installed baked runtime`.
  - Ratio = IIcx / host, for every phase after install.

  Write a table with columns phase | IIcx used KB | host (H=12) KB | ratio. A peak-phase ratio outside 0.85–1.15 goes in the HISTORY entry as a Wave 1 input, naming the model term most likely wrong.
- [ ] **Step 2: SE target.** From Task 4: `ClarusC target = (BufPtr − ApplZone) − 64 KB stack − 1.56 MB resident code` (spec §5.1). Write it into umbrella §9, including the raw SEBUDGET line.
- [ ] **Step 3: Write umbrella §9, the HISTORY entry and the ROADMAP line.** Include: the memgate budgets (three numbers), the IIcx per-phase table, the stack high-water, the compile ticks, the census top 10 from Task 5, and the calibration table. Mark the status Wave 0 = complete (pending merge), branch `se-wave0-measurement`.
- [ ] **Step 4: End-of-wave gates** (umbrella §5.3), with every emulator env exported:
  ```sh
  export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority
  scripts/test-merge.sh
  CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake
  ```
  Expected: every stage prints `PASS`, and `clarusc_bake` passes (this wave touched `macgui.cla`). Record both durations in the HISTORY entry.
- [ ] **Step 5: Final whole-branch review** (Opus, most capable): the diff from `main` against this plan and the spec. Fix findings in one consolidated wave, then re-run T1.
- [ ] **Step 6: Commit the docs**

```bash
git add docs/
git commit -m "docs(se-wave0): record SE budget, IIcx baseline, calibration; wave 0 complete"
```

Then report to Andrew and wait for a merge request. Do not merge.
