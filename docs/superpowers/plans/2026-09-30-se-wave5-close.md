# SE Wave 5 (Close on the SE, with margin) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ClarusC.APPL compiles `examples/bookmarks.cla` on the Snow SE (4 MB, System 6.0.8, single-app) with margin, and the SE is the standing acceptance gate, with a floor. This closes the SE memory program.

**Architecture:**
- The scripted UI pump pulls disk-inserted events, so the `Clarus` volume mounts on System 6 without the Finder.
- `cg_free_globals` becomes a per-segment table plus a loop instead of ~11 KB of unrolled glue in every segment.
- ClarusC gets a measured 384 KB stack reserve and a depth guard.
- The ClarusC Snow scripts default to the SE, with a low-point floor.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C99 host runtime, POSIX sh tests, Snow (SE and IIcx, wave close only), Mini vMac (T2 only).

**Spec:** `docs/superpowers/specs/2026-09-30-se-wave5-close-design.md` (umbrella `2026-09-27-se-memory-program-design.md` §6 Wave 5, revised by the spec's V1–V5).

## Global Constraints

- **Branch and merging.** Branch `se-wave5-close` (already holds the spec commit `ee3d6fef`). Merge only when Andrew asks.
- **Model.** Implementers and reviewers run on Opus (`model: opus`).
- **Per-task gate.** `flock /tmp/claude-1000/clarus-w5-gate.lock scripts/test-task.sh` (T1, no `--smoke`). The lock is shared across worktrees.
- **Emulators.**
  - No emulator boots in Tasks 1–6.
  - Task 7 (the controller) runs Snow and T2.
  - If an implementer has a concrete doubt that only a Mini vMac boot can settle, serialize it: `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority; flock /tmp/claude-1000/clarus-w5-emu.lock env CLARUS_MAC_TESTS=1 make -j1 test T='…'`. Say so in the report.
- **Process safety.**
  - Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched.
  - Never boot or write the pristine `snow/`, `macplus/` or `macplus2/` images.
  - Never use `git stash` (it is shared across worktrees). Leave the untracked `foo.txt` alone.
- **grep.** Use `/usr/bin/grep -a` for `.cla` audits (ugrep skips MacRoman files).
- **Output policy** (spec §4):
  - Task 1: output-changing for UI programs' goldens (one immediate each). The frozen UI scenario traces/snaps (`testdata/uisnaps`) must NOT move.
  - Task 2: output-changing for multi-segment native programs' `.s` goldens. Behaviour and global release order identical.
  - Task 3: byte-identical for every compiled program except ClarusC.APPL itself.
  - Task 4: tests and docs only.
  - Every rebless goes in its own commit, with a written reason per golden family.
  - Bless variables must be exactly `1`: `CLARUS_CG68K_BLESS=1` for `testdata/cg68k/*.s`. The emitui `.c.golden` files have no bless variable; regenerate a changed one by writing `clarusc emit`'s output over it, as `tests/emitui/goldens.sh` describes.
- **Identity check** (byte-identical tasks), with `D=/tmp/claude-1000/w5tN`:
  ```sh
  make -j tools bootstrap
  D=/tmp/claude-1000/w5tN; mkdir -p $D/idA $D/idB
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
  For an output-changing task, each `DIFF` line must be explained by that task's change. Also compare the `--rtbake` build against the current from-source build, which must always be identical: `build-run/clarusc-current emit68k … -o $D/idB/$f.src.bin` vs the `--rtbake` one.
- **Snapshot.** `clarusc-current` is compiled by the committed snapshot. Only Task 6 regenerates `clarusc/clarusc.c`. Between regenerations `selfhost/fixedpoint` may fail; `selfhost/diag` and `selfhost/modules` must pass.
- **Memgate.** `tests/memgate/budget.txt` may only go down (int(P × 1.01) + 1, three identical runs), and only in the task whose change lowered a peak.
- **Stack numbers** (spec §3.3): ClarusC `stack: 393216`; the guard aborts with the exact text `source too deeply nested` when fewer than 65536 bytes remain above `ApplLimit` (low-memory global 0x130).
- **SE floor** (spec §3.4): `tests/mactest/snow/se_floor.txt`, one integer in KB (a comment line per change). Set at wave close to `floor(0.9 × measured lowest free KB)`. Later waves may only raise it.
- **Commits.** Messages end with:
  ```
  Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01TSN5Gu3dKXT51LZnfqpfFP
  ```

## Review Focus

1. **A global whose finalizer does I/O** (an open `filehandle`, a `connection`, an AppleTalk/TCP listener, the app log) must still be released at quit, in today's order, after Task 2's table loop. Task 2 pins it with an order-dump check and the existing suites.
2. **A `quit` statement in a non-first segment** must still run that segment's free stub (the per-segment label semantics stay). Task 2 pins it with a multi-segment fixture that quits from segment ≥ 2.
3. **Program shapes the table has to handle.** A program with no handle-typed globals, one whose only handle globals are records with walks, and one with array-of-handle globals must emit correct tables (or none) and release correctly. Task 2 pins these three shapes with host-built fixtures.
4. **A too-deep source compiled by ClarusC** must produce the ordinary compile-error path, and the NEXT compile in the same session must work. A guard firing inside codegen must not leave half-built state. Task 3 pins it with a resident double-compile check (`dblcompile`-style) where the first compile aborts.
5. **The scripted pump receiving a disk-inserted event for a disk that fails to mount** (unformatted, or an error) must not hang or crash a scripted app. The pump drops the event either way. Task 1 pins it by code review only (no emulator), and the report says so.

## Tracks and waves

| Wave | Tasks                                                              | Where                                  |
|------|--------------------------------------------------------------------|----------------------------------------|
| A    | 1 pump mask · 2 free-globals table · 3 stack guard · 4 SE harness  | worktrees `../clarus-w5-t1` … `-t4`    |
| B    | 5 merge + combined rebless (**serialization point**)               | branch tip, alone                      |
| C    | 6 snapshot regeneration (**serialization point**)                  | branch tip, alone                      |
| D    | 7 wave close: T2, SE + IIcx Snow runs, floor, measurements, docs   | branch tip, controller-driven          |

Shared files in Wave A:
- Tasks 2 and 3 both touch `clarusc/cg68k.cla`. Task 2 works in the glue/free-globals region (`cgEmitFreeGlobalsStub` ~l.5579, the per-segment glue emission ~l.16291, the `cgRecMode == 3` bucket). Task 3 adds only one guard call at the entry of the recursive expression/statement emitters. The regions are disjoint.
- Tasks 1 and 2 both move `testdata/cg68k/*.s` goldens. Each reblesses in its own worktree, in its own commit. Task 5 re-blesses after the merge, which resolves every golden conflict by regeneration, never by hand-merging `.s` files.

Worktree setup: `git worktree add -b w5-tN ../clarus-w5-tN se-wave5-close`, then absolute symlinks to `/home/andrew/repos/clarus/<d>` for `snow/`, `macplus/`, `macplus2/` and `vasm/`; `Retro68` → `/home/andrew/repos/Retro68`; `toolchain` → `/home/andrew/repos/Retro68-build/toolchain`.

---

### Task 1: The scripted pump mounts disks (output-changing: UI goldens)

**Files:**
- Modify: `runtime/clarus/uiscript.cla`, `rtUiPumpPassive` (~l.1326-1344).
- Modify: the goldens this moves (their own commit).

**Interfaces:** none produced. Task 7's SE runs rely on it.

- [ ] **Step 1: Find what the mask reaches.** Run `/usr/bin/grep -a -n '0x0140' runtime/clarus/*.cla` and `/usr/bin/grep -a -n 'uiscript' clarusc/bake.cla clarusc/drive.cla` to learn which lanes splice `uiscript.cla`. Record in the report which golden families should move: `testdata/cg68k/*.s` for UI programs, and `testdata/emitui/*.c.golden` if the C lane splices it. `testdata/uisnaps` must not move.
- [ ] **Step 2: Implement.** In `rtUiPumpPassive`, change both `UiGetNextEvent(0x0140, ev)` calls to `UiGetNextEvent(0x01C0, ev)`. The loop body already handles `what == 6` (update) and `what == 8` (activate). Add nothing for `what == 7`: the Event Manager mounts the volume as it returns the event, and the pump drops it. Update the comment:
  ```
  gotEvent = UiGetNextEvent(0x01C0, ev) // updateMask|diskMask|activMask
  ```
  and add one comment line above the loop saying why disk events are pulled: "a disk-inserted event is pulled so the Event Manager mounts the volume (System 6 without the Finder: the second SCSI disk mounts only this way); the pump then drops it".
- [ ] **Step 3: Run the goldens and read every diff.** `make test T='cg68k/ emitui/ bake/ testsuite/'`. Every FAILing golden must differ only by the mask immediate (`0x0140` → `0x01C0` in C; the corresponding `MOVE.W #$140` → `#$1C0` in `.s`). Any other difference is a bug: stop and report it.
- [ ] **Step 4: Rebless** with `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`, plus regenerating any moved emitui `.c.golden`. Rerun Step 3's groups: all PASS.
- [ ] **Step 5: Failed-mount path (Review Focus 5).** Confirm by reading that the loop takes no action on `what == 7` other than fetching the next event, so a failed mount cannot hang or panic. Say "verified by code review, no emulator" in the report.
- [ ] **Step 6: T1, then commit.** First `feat(runtime): scripted pump pulls disk-inserted events so volumes mount (SE wave 5)` (the `.cla` alone), then `test(goldens): rebless for the scripted pump's disk mask (SE wave 5)` with the reason: "UI programs' rtUiPumpPassive mask 0x0140 -> 0x01C0; no other change".

---

### Task 2: Table-driven `cg_free_globals` (output-changing: multi-segment `.s` goldens)

**Files:**
- Modify: `clarusc/cg68k.cla`:
  - `cgEmitFreeGlobalsStub` (~l.5579);
  - the per-segment glue emission (~l.16291, the `cgRecMode == 3` bucket);
  - the header comment "GLUE IS DUPLICATED, NOT JT-CROSS-CALLED" (~l.1164);
  - `cgFreeGlobalsLbl` (~l.1125).
- Create: `tests/bake/clarusc_codesize.sh`.
- Create: `tests/cg68k/freeglobals.sh` and its fixtures under `testdata/cg68k/freeglobals/`.
- Modify: the goldens this moves (their own commit).
- Modify: `docs/TODO.md` ("ABI / performance": resolved, or the record-walk remainder with its numbers).

**Interfaces:**
- Produces: `cg_free_globals` still exists as a per-segment label with the same calling convention (`JSR`/`BSR` from the startup sequence and from every `quit`). Only its body changes: loop plus table.

- [ ] **Step 1: Measure (no code change).** Emit ClarusC with `--listing` using `build-run/clarusc-current emit68k --listing` on `scripts/build-clarusc-mac.sh`'s source list; read the script for the exact files and flags. Also emit `examples/bookmarks.cla`. From the listing, record per segment:
  - the bytes of `cg_free_globals`;
  - the bytes of all `cg_retain_*`/`cg_release_*` walks;
  - the bytes of `cg_mul32`/`div32`/`mod32`.

  Put the table in the report. **Decision rule:** if the record walks total more than 100 KB across ClarusC's segments, note it in the report as a follow-up and put it in TODO with the numbers. They are not converted in this task.
- [ ] **Step 2: Write `tests/bake/clarusc_codesize.sh` (fails first).**
  - Build ClarusC with `CLARUSC_BIN=build-run/clarusc-current scripts/build-clarusc-mac.sh`, into a `$WORK` output if the script supports `CLARUSC_MAC_OUT`.
  - Read the MacBinary header (data length at offset 83, resource length at 87) and walk the resource map the way `tests/bake/clarusc_container.sh` does (reuse its parsing code by copying the function; POSIX sh + `od`, or a small awk).
  - Sum every `CODE` resource's length. Assert the sum ≤ 1193734, i.e. today's 1,603,334 minus 409,600.
  - Print the measured total on a `PASS`/`FAIL` line.

  Run it: expect FAIL with a total near 1,603,334.
- [ ] **Step 3: Write `tests/cg68k/freeglobals.sh` (fails first).** Host-build fixtures, both lanes where the fixture is non-UI. The fixture's `quit` path must release globals whose finalizers are observable. Use `filehandle` globals that each write one distinct byte and are closed by the release, or globals of a record type whose release the fixture can observe through a file written at quit, whichever is simplest with today's language surface. Read `testsuite/core/cases_fileh.cla` for what finalizers do. The fixtures:
  - (a) no handle-typed globals;
  - (b) only record globals with walks;
  - (c) an `array`-of-`text` global plus a `list` and a `map` global;
  - (d) a program large enough to pack into ≥ 2 segments. Force it with many functions; read `tests/cg68k/segments.sh` for how that script forces segmentation. It executes `quit` from a function placed in segment ≥ 2.

  For each fixture the script asserts two things:
  - native `emit68k` builds;
  - the `--listing` of each segment's `cg_free_globals` is at most 512 bytes plus 4 × (number of handle-typed globals).

  For (d) it also asserts the listing shows the quit site in segment ≥ 2 reaching that segment's own `cg_free_globals` label. Run: expect FAIL on the size assertion.
- [ ] **Step 4: Implement the table.**
  - Per segment, `cg_free_globals` becomes:
    - a constant-pool table: one 4-byte entry per handle-typed global, in the order today's unrolled code visits them, holding the global's A5 offset (int16) and a kind index (int16), then a terminator entry;
    - one loop that walks the table: for each entry, load the global, and if non-nil call the release routine selected by the kind index, then clear the slot exactly as the unrolled code does today;
    - a small kind dispatch: a `BSR` table or compare chain to the same release routines the unrolled code calls (the per-type releases, and each record type's `cg_release_<Rec>` walk).
  - Keep the existing per-segment label and the `cgRecMode == 3` recording of the pool entries. The table's constant-pool bytes are recorded the same way other per-segment glue constants are.
  - A program with no handle-typed globals emits no table, and a bare `RTS` body (or whatever today's empty case emits; keep that).
  - Rewrite the "GLUE IS DUPLICATED" header paragraph to say that `cg_free_globals` is now table-driven and why (TODO's ~11 KB × segments), and that the RC walks and arithmetic remain duplicated.
- [ ] **Step 5: Order check (Review Focus 1).** Add an env probe `CLARUS_FREEGLOBALS_DUMP=1` to `emit68k` that prints `freeglobals: <seg> <idx> <A5off> <kind>` for each table entry, and before your change the unrolled order. Simplest route: dump in the old code first on a scratch branch, save the output, then compare. Extend `freeglobals.sh` to assert that for fixtures (b)–(d) the table order equals the saved old order, committing the saved expected dumps as fixtures under `testdata/cg68k/freeglobals/*.order`.
- [ ] **Step 6: Run.** `freeglobals.sh` PASS; `clarusc_codesize.sh` PASS, with the measured total recorded. Then `make test T='cg68k/ emitui/ bake/ testsuite/ lowlevel/ conntest/ atalk/ tcp/'`. Goldens will FAIL. Read the diffs: only `cg_free_globals` bodies and their constant-pool entries may change, plus the segment sizes and offsets that follow from them. Any change inside another function's body is a bug.
- [ ] **Step 7: Rebless** (`CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`, plus any bake/emitui goldens that encode a native image). Rerun Step 6's groups: all PASS. Then `CLARUS_BAKE_FULL=1 make test T=bake/` and `make test T=memgate/`. If a memgate peak drops, ratchet it down in this task; it must not rise.
- [ ] **Step 8: TODO.md.** Mark the "ABI / performance" `cg_free_globals` entry resolved, with the before/after CODE total. If Step 1's rule triggered, add the record-walk follow-up with its numbers.
- [ ] **Step 9: T1, then commit.** First `perf(cg68k): table-driven cg_free_globals instead of per-segment unrolled glue (SE wave 5)` (code, tests, TODO), then `test(goldens): rebless for the table-driven cg_free_globals (SE wave 5)` with the reason per family.

---

### Task 3: Measured stack reserve plus depth guard (byte-identical except ClarusC.APPL)

**Files:**
- Modify: `clarusc/macgui.cla`: the `app ClarusC` section (~l.530) gains `stack: 393216`.
- Modify: `clarusc/drive.cla`: the new `drvStackGuard()`, plus its extern.
- Modify: the call sites:
  - `clarusc/parse.cla`: `parseExpr` ~l.407, `parseUnary` ~l.513, `parsePrimary` ~l.686, `parseStmt` ~l.903;
  - `clarusc/check.cla`: `checkStmt` ~l.4979, `checkExpr` ~l.6490;
  - `clarusc/lower.cla`: `lowExpr` ~l.656, `lowStmt` ~l.3772;
  - `clarusc/cg68k.cla`: the entry of its recursive expression and statement emitters. Find them with `/usr/bin/grep -a -n '^func cg' clarusc/cg68k.cla` and pick the ones that recurse into themselves for sub-expressions and sub-statements. Name them in the report.
- Modify, if needed for the host link: `runtime/host/` (a shim for the guard's SP read). See Step 2.
- Create: `tests/bake/stackguard.sh` (host test, Step 5).

**Interfaces:**
- Produces: `func drvStackGuard()`. No arguments, no result. It calls `abort("source too deeply nested")` when `sp - ApplLimit < 65536`.

- [ ] **Step 1: Read the existing SP probe.** `clarusc/macgui.cla` ~l.355-400 already declares `external func GcStackPtr(): ptr = inline sp` and reads `ApplLimit` (0x130). The language reference ~l.2027 says `inline sp` is native only, and that "a C lane build resolves it as an ordinary `rt_ext_` extern". `macgui.cla` is never host-built; `drive.cla` is. Check whether a host `rt_ext_` definition for such an extern exists; `/usr/bin/grep -rn 'rt_ext_' runtime/host | head`.
- [ ] **Step 2: Implement the guard.** In `drive.cla`:
  ```
  external func DrvStackPtr(): ptr = inline sp

  // drvStackGuard aborts the compile when the native stack is nearly
  // exhausted (SE wave 5): ClarusC's reserve is a measured 384 KB, and
  // a 68k stack overflow silently corrupts the heap. Called at the top
  // of every recursive parse/check/lower/codegen walker. On the host
  // DrvStackPtr returns 0 and the guard does nothing.
  func drvStackGuard() {
      var sp: int
      sp = int(DrvStackPtr())
      if sp == 0 {
          return
      }
      if sp - peekl(ptr(0x130)) < 65536 {
          abort("source too deeply nested")
      }
  }
  ```
  - Use whatever cast and `peekl` spelling the codebase uses; copy the idiom from `macgui.cla`'s `gcStackReport`.
  - For the host, add an `rt_ext_DrvStackPtr` returning `NULL` in the host runtime, the way other host `rt_ext_` shims are defined. If the C lane needs a declaration in a `*_c.cla` file, follow the existing pattern.
  - The shim must not change any other program's emitted C. Only programs that declare this extern reference it.
- [ ] **Step 3: Add the calls.** Put `drvStackGuard()` as the first statement of each walker listed under Files. If a walker is a hot leaf (e.g. called per token), keep the guard at the recursion entry points only, and say which in the report.
- [ ] **Step 4: Stack reserve.** Add `stack: 393216` to `app ClarusC` in `macgui.cla`, with a comment: "SE wave 5: 2x the largest measured high-water (194 KB, IIcx, Wave 4 memprobe), re-measured at each ClarusC-affecting wave close; drvStackGuard (drive.cla) keeps 64 KB in hand".
- [ ] **Step 5: Host test `tests/bake/stackguard.sh` (Review Focus 4).**
  - (a) `clarusc emit68k` of every `examples/*.cla` still succeeds, which proves the host guard is a no-op.
  - (b) The resident double-compile path survives an aborted first compile. Read how `dblcompile`/`dblcompile_bake` (`/usr/bin/grep -rln dblcompile tests/`) drive two compiles in one process. Add a subcase whose first compile aborts through the same `abort` → `attempt` path the guard uses. Force it with a test-only env var, `CLARUS_STACKGUARD_FORCE=1`, that makes `drvStackGuard` abort on its Nth call (N from the variable's value). The second compile must be byte-identical to a fresh one.

  The env var is read once per compile and costs nothing when unset. Name it `…_TESTONLY`-style in a comment, following the `--corrupt-objcode-testonly` precedent.
- [ ] **Step 6: Identity check.** Expected: no `DIFF` at all. ClarusC is not in the identity list, and every other program must be byte-identical, `rt.clir` included. Then `make test T='bake/ cg68k/ emitui/ testsuite/ selfhost/diag selfhost/modules memgate/'` and `CLARUS_BAKE_FULL=1 make test T=bake/`.
- [ ] **Step 7: ClarusC builds.** `CLARUSC_BIN=build-run/clarusc-current scripts/build-clarusc-mac.sh` succeeds, and `build-run/tools/resfork size` or the `SIZE`/stack evidence shows the 393216 reserve. Find where the `stack:` field lands (`cgStackHeuristic` / startup `SetApplLimit`) and quote the listing line in the report.
- [ ] **Step 8: T1, then commit:** `feat(clarusc): 384 KB measured stack reserve and a depth guard (SE wave 5)`.

---

### Task 4: The SE becomes the default ClarusC machine, with a floor (tests and docs)

**Files:**
- Modify: `tests/lib_snow.sh`, `snow_clarusc_system` (~l.304-316).
- Modify: `tests/mactest/snow/clarusc_memprobe.sh` (floor check).
- Create: `tests/mactest/snow/se_floor.txt`.
- Create: `tests/mactest/snow/clarusc_deep.sh` and `testdata/mac-resident/clarusc-deep.events`.
- Modify: the headers of `tests/mactest/snow/clarusc_bake.sh`, `macresident.sh` and `macresident_failed_compile.sh`, wherever they say "IIcx" as the default.
- Modify: `CLAUDE.md` (the `CLARUS_SNOW_TESTS=1` bullet and the `clarusc_bake` standing rule).

**Interfaces:**
- Consumes: Task 3's diagnostic text `source too deeply nested` (the deep test greps it) and Task 1's disk mount (the SE compiles need it). Neither is present in this worktree, so this task runs no Snow boot. Task 7 runs them.
- Produces: `se_floor.txt` (format below) and the `clarusc_deep` script.

- [ ] **Step 1: `snow_clarusc_system`.** Make it default `SNOW_SYSTEM` to 6. Remove the `CLARUS_SNOW_CLARUSC` skip logic and its mention. Keep `SNOW_SYSTEM=7` working. Update its comment to say ClarusC fits the SE since Wave 5 (spec §1), and that the IIcx stays available as `SNOW_SYSTEM=7`.
- [ ] **Step 2: `se_floor.txt`.**
  ```
  # SE memory program Wave 5: floor (KB) on ClarusC's lowest per-phase
  # FreeMem while compiling examples/bookmarks.cla on the Snow SE
  # (System 6.0.8, single-app). Set to floor(0.9 x measured); later waves
  # may only raise it. One comment line per change.
  # 2026-09-30 placeholder: set at Wave 5 close.
  0
  ```
- [ ] **Step 3: Floor check in `clarusc_memprobe.sh`.**
  - After the existing checks, when `SNOW_SYS` is 6, parse every `^  mem: ` line's first `free N KB` number, take the minimum, and read the last non-comment line of `se_floor.txt`.
  - Emit `PASS se_floor` or `FAIL se_floor: lowest free <min> KB < floor <floor> KB`, and echo `memprobe: lowest free <min> KB (floor <floor>)` in either case.
  - With the placeholder 0 it always passes.
  - Update the header comment to say the script now runs on the SE by default and gates the floor there.
- [ ] **Step 4: `clarusc_deep.sh`.** Model it on `clarusc_memprobe.sh`.
  - Generate `$WORK/deep.cla`: a minimal non-UI program whose `main`/startup function contains one expression nested 20000 levels deep, e.g. `x = ((((…1…))))` with 20000 parentheses each side (deep enough that even a ~20-byte-per-level parse chain exhausts 320 KB; if Task 7 finds the guard does not fire, raise the depth). Use a POSIX sh loop or awk; no bash.
  - Events file `testdata/mac-resident/clarusc-deep.events`:
    ```
    answer-open Clarus:deep.cla
    menu 2 1
    quit
    ```
    Check `clarusc-bookmarks.events` for the exact verbs and copy them.
  - Assertions:
    - the app `out` contains `source too deeply nested`;
    - it contains `##CLARUS-EXIT## 0` (a normal quit, not a crash);
    - there is no hang: `snow_run`'s timeout plus the trailer check cover that.
  - Header comment: needs Task 3's guard and Task 1's mount, so it SKIPs meaningfully only after both are merged. It is a Wave 5 close test.
- [ ] **Step 5: CLAUDE.md.**
  - In the `CLARUS_SNOW_TESTS=1` bullet, replace "**ClarusC.APPL does not fit the 4 MB SE yet** …" and the `snow_clarusc_system` defaults text with: ClarusC fits the SE since Wave 5; the ClarusC scripts default to the SE; `SNOW_SYSTEM=7` runs the IIcx; `clarusc_memprobe` gates `se_floor.txt` on the SE; add `clarusc_deep`.
  - The standing rule becomes: "`CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (on the SE) is the standing rule after any change to `clarusc/bake.cla` or `clarusc/macgui.cla`".
  - Remove `CLARUS_SNOW_CLARUSC` everywhere it appears (`/usr/bin/grep -rn CLARUS_SNOW_CLARUSC .`, excluding `build-run`).
- [ ] **Step 6: Checks.** `make test T=runner/` (the `sh -n` syntax check covers the new scripts). Without `CLARUS_SNOW_TESTS`, `make test T=mactest/snow/` must SKIP cleanly.
- [ ] **Step 7: T1, then commit:** `test(snow): ClarusC scripts default to the SE, memprobe floor, clarusc_deep (SE wave 5)`.

---

### Task 5: Merge Wave A and the combined rebless (serialization point)

Needs Tasks 1–4 approved.

- [ ] **Step 1 (controller):** Merge `w5-t1`, `w5-t3`, `w5-t4`, `w5-t2` into `se-wave5-close`, in that order, with `--no-edit`. On a conflict in any `testdata/` golden, take either side (`git checkout --theirs`); Step 2 regenerates them. A conflict in a source file goes to a subagent.
- [ ] **Step 2 (subagent): Rebless once.**
  - Run `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`, regenerate any emitui/bake native-image golden, then `make test T='cg68k/ emitui/ bake/ testsuite/'`: all PASS.
  - Read the combined golden diff against each task's own rebless: it must be the union of Task 1's mask immediate and Task 2's free-globals change, nothing else.
  - Commit `test(goldens): combined Wave A rebless (SE wave 5)`, with the reason per family.
- [ ] **Step 3:** `CLARUS_BAKE_FULL=1 make test T='bake/ memgate/'` and T1 under the gate flock.

---

### Task 6: Snapshot regeneration (serialization point)

Needs Task 5.

- [ ] **Step 1:** Run `make test T=selfhost/fixedpoint` and follow its printed recipe until it passes. Then `make test T=selfhost/` must be 6/6.
- [ ] **Step 2:** Run `tests/bake/clarusc_codesize.sh` WITHOUT the `CLARUSC_BIN` override (plain `build-clarusc-mac.sh` now uses the regenerated snapshot). It must PASS, with the CODE total recorded.
- [ ] **Step 3:** T1, then commit `clarusc/clarusc.c` alone: `chore(clarusc): regenerate bootstrap snapshot for wave 5 (SE wave 5)`.

---

### Task 7: Wave close (controller-driven)

- [ ] **Step 1: T2.** `scripts/test-merge.sh`.
- [ ] **Step 2: SE runs.** `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority; CLARUS_SNOW_TESTS=1 make -j1 test T='mactest/snow/clarusc_bake mactest/snow/clarusc_memprobe mactest/snow/macresident mactest/snow/macresident_failed_compile mactest/snow/clarusc_deep'`, which now defaults to the SE. Save the memprobe log as `build-run/memprobe-saved/clarusc_memprobe.wave5-se.log`.
- [ ] **Step 3: IIcx.** `SNOW_SYSTEM=7 CLARUS_SNOW_TESTS=1 make -j1 test T='mactest/snow/clarusc_bake mactest/snow/clarusc_memprobe'`. Save the memprobe log as `clarusc_memprobe.wave5.log`.
- [ ] **Step 4: Floor.** From Step 2's `memprobe: lowest free <min> KB`, write `floor(0.9 × min)` into `se_floor.txt`, replacing the placeholder, with a dated comment line. Re-run `clarusc_memprobe` on the SE once: `PASS se_floor`. Commit `test(snow): SE floor from the Wave 5 measurement (SE wave 5)`.
- [ ] **Step 5 (subagent): Docs.**
  - Umbrella:
    - §5.5 row 5;
    - §9 Wave 5 row;
    - a new §9.6 (SE and IIcx per-phase tables against Wave 4 and the spike, CODE totals, stack reserve and high-water, the floor);
    - the status line;
    - **D1 marked done**;
    - D9's amendment recorded.
  - The wave spec's status line.
  - `docs/ROADMAP.md`: the SE program closed; a new "segment directive + overlays" phase entry.
  - `docs/HISTORY.md` Wave 5 entry with every ledger `Ruling:` and its cost, and `<T2 result>`/`<SE result>` placeholders.
  - `docs/TODO.md`: the Wave 4 leftovers still open, the record-walk follow-up if any, smaller walker frames, the streamed fork.
  - `docs/FUTURE.md` if anything is deferred there.
  - Every Markdown table aligned.
- [ ] **Step 6 (controller): Wave 6 go/no-go.** Present Andrew the numbers (SE margin, CODE total) and ask whether Wave 6 (separate compilation plus a linker) goes ahead. Record the answer in the umbrella's decision section and ROADMAP.
- [ ] **Step 7:** Fill the HISTORY placeholders. Then the final whole-branch review (Opus), one fix wave, a scoped re-review, and report to Andrew. Do not merge.
