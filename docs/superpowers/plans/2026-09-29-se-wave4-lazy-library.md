# SE Wave 4 (Lazy runtime library) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A `--rtbake` compile (host and ClarusC.APPL) reads a small resident index plus only the reachable runtime functions' object code. The library lives in ClarusC.APPL's data fork and is read with `readAt`. Runtime IR bodies are never loaded. `bookmarks --rtbake` peak ≤ 1.2 MB.

**Architecture:**
- Make all 781 runtime functions pasteable: a new hole kind resolves calls to per-program dispatchers at paste.
- Bake a per-function call-graph summary so shake needs no runtime IR.
- Cut CLIR v9 with a section directory, resident tables, no IR bodies, and an indexed object section loaded lazily.
- Ship the library in ClarusC.APPL's data fork, found through `GetAppParms` and opened with the new user-facing `file.openRead`.
- Trim the remaining peak buckets.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C99 host runtime, POSIX sh tests, Mini vMac, Snow (the wave close only).

**Spec:** `docs/superpowers/specs/2026-09-29-se-wave4-lazy-library-design.md` (umbrella `2026-09-27-se-memory-program-design.md` §6 Wave 4).

## Global Constraints

- **Branch and merging.** Branch `se-wave4-lazy-library`. Merge only when Andrew asks.
- **Model.** Implementers and reviewers run on Opus (`model: opus`).
- **Per-task gate.** `flock /tmp/claude-1000/clarus-w4-gate.lock scripts/test-task.sh` (T1, no `--smoke`). The lock is shared across worktrees.
- **Emulators.**
  - Mini vMac boots only where a task says so. Serialize them: `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority; flock /tmp/claude-1000/clarus-w4-emu.lock env CLARUS_MAC_TESTS=1 make -j1 test T='…'`.
  - Snow only in Task 9.
- **Process safety.** Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write the pristine `snow/`, `macplus/` or `macplus2/` images. Never use `git stash` (it is shared across worktrees).
- **grep.** Use `/usr/bin/grep -a` for `.cla` audits (ugrep skips MacRoman files).
- **Byte-identity of compiled programs.** Every compiled program stays byte-identical to its from-source build. The `tests/bake/` identity scripts and `CLARUS_BAKE_FULL=1 make test T=bake/` are the proof. Only the tasks named in spec §4 may move goldens, each in its own commit with a written reason.
- **Identity check** (every compiler task, before committing), with `D=/tmp/claude-1000/w4tN`:
  ```sh
  make -j tools bootstrap
  D=/tmp/claude-1000/w4tN; mkdir -p $D/idA $D/idB
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
  Expected: no per-program `DIFF` line. A `DIFF clir` must be explained: it is expected whenever the bake format or the runtime changes.
- **Snapshot.** `clarusc-current` is compiled by the committed snapshot. No `clarusc/*.cla` may call `file.openRead` before Task 5's regeneration. Only Tasks 5 and 8 regenerate `clarusc/clarusc.c`. Between regenerations `selfhost/fixedpoint` may fail; `selfhost/diag` and `selfhost/modules` must pass.
- **Memgate.** Tasks 1-7 do not edit `tests/memgate/budget.txt`; they record before/after peaks. Task 8 ratchets.
- **Case counts.** Core is 90. Task 3 moves it to 91, in the five places CLAUDE.md lists.
- **Commits.** Messages end with:
  ```
  Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01TSN5Gu3dKXT51LZnfqpfFP
  ```

## Review Focus

1. **A program reaching a dispatcher-calling runtime function** (a UI app with every timer, a conn/atalk/tcp app) pastes the new synth-call hole to the right synthesized function. Task 1's identity corpus (`tcpchat`, `bookmarks`, the atalk/tcp twins) pins it.
2. **Shake summary equals the IR walk for every runtime function.** A missing edge silently drops a function and crashes at runtime. Task 2's equality test pins it.
3. **A library whose stamp does not match** is refused with today's diagnostic, with no partial install. Task 6's `refuse_stamp` pins it.
4. **A program that reaches few runtime functions** (hello-mac) reads only its reachable object bytes, and one that reaches many (bookmarks) is still byte-identical. Task 6's read-bound test and the identity sweep pin it.
5. **`file.openRead` on a file that another path has open for writing, or on a missing file,** returns nil plus `lastError`, and writes through a read-only handle fail cleanly. Task 3's core case pins it.

## Tracks and waves

| Wave | Tasks                                                                                          | Where                                  |
|------|------------------------------------------------------------------------------------------------|----------------------------------------|
| A    | 1 untaint · 2 shake summary · 3 `file.openRead` · 4 early front-end free + reachable-only cg lists | worktrees `../clarus-w4-t1` … `-t4`    |
| B0   | 5 snapshot regeneration (**serialization point**)                                              | branch tip, alone                       |
| B    | 6 CLIR v9 + lazy install/read path (**output-changing for the library**)                       | branch tip, alone                       |
| C    | 7 ClarusC.APPL data-fork container and discovery                                               | branch tip, alone                       |
| D    | 8 fork pre-size, census-driven trims, final regeneration, ratchet                              | branch tip, alone                       |
| E    | 9 IIcx gates, docs (controller-driven)                                                          | branch tip                              |

Shared files in Wave A:
- Task 1 touches `cg68k.cla`'s capture and paste region (~l.11880-11950, ~15380-15420, ~15880-15930).
- Task 4 touches `cg68k.cla`'s Measure region (~l.14400-14420) and `drive.cla`.
- Task 2 touches `bake.cla` (a new section) and `shake.cla`.
- Task 3 touches `check.cla`/`lower.cla` intrinsic tables, `runtime/clarus/fileh*.cla`, `runtime/host/rt_fileh.inc` and the core suite.

The `cg68k.cla` regions of Tasks 1 and 4 are disjoint. Merge in task order and run T1 after each merge.

Worktree setup: `git worktree add -b w4-tN ../clarus-w4-tN se-wave4-lazy-library`, then absolute symlinks to `/home/andrew/repos/clarus/<d>` for `snow/`, `macplus/`, `macplus2/` and `vasm/`; `Retro68` → `/home/andrew/repos/Retro68`; `toolchain` → `/home/andrew/repos/Retro68-build/toolchain`.

---

### Task 1: Untaint the runtime (byte-identical)

**Files:**
- Modify: `clarusc/cg68k.cla`:
  - the hole kinds (~l.14983-15001): add `cgHoleSynthCall`;
  - `cgCallExtUiSynth` (~l.11882-11905) and `cgCallExtUiGlueAddr` (~l.11940): under `cgBakeCapture`, emit the new hole instead of tainting;
  - `cgObjPasteHole` (~l.15882): resolve `sym` (a pool index of the dispatcher name) with `findIRFuncIdxByName` and emit `cgCallFunc(fi)`, or the glue-address equivalent;
  - `cgObjDumpSegment` (~l.15384-15412): nothing is tainted any more.
- Modify: `clarusc/bake.cla`, only if the hole wire format needs the new kind recorded (it is a `u8` kind; confirm).
- Create: `tests/bake/untaint.sh`: bake the 68k lane with `--listing` or a debug dump, and assert that every runtime function's object code is valid (`cgObjValid` all true, e.g. a count line). Model it on the existing `tests/bake/*` scripts.

- [ ] **Step 1:** Write `tests/bake/untaint.sh`. Expected today: FAIL, because 26 functions are invalid.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** Run the identity check (`DIFF clir` expected: ObjCode now carries the 26 functions; explain it), `make test T='bake/ cg68k/ emitui/ lowlevel/ testsuite/'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`. Every per-program line must be clean, including the atalk/tcp/conn twins.
- [ ] **Step 4:** Emulator: `mactest/tick mactest/toolbox_68k mactest/coresuite_68k` on Mini vMac. Their builds are from-source, so this proves nothing about paste; run it only if T1 or the identity check raises a doubt, and say which in the report.
- [ ] **Step 5:** T1, then commit: `feat(bake): untaint runtime -- synth-dispatcher calls become paste holes (SE wave 4)`.

**Interfaces produced:** `cgHoleSynthCall` (a hole kind; `sym` = pool index of the target name).

---

### Task 2: Baked call-graph summary for shake (byte-identical)

**Files:**
- Modify: `clarusc/bake.cla`:
  - a new section `ShakeSummary` (the next free id; update the section count): per runtime function, a sorted list of callee `irFuncs` indices, plus a list of callee indices of runtime global initializers;
  - writer next to the other `bkWrite*`, reader next to `bkRead*`, load into `bkLd*` staging, and install alongside `bkInstallArenas`.
- Modify: `clarusc/shake.cla`: factor the per-body edge collection (`shakeWalkStmts/Stmt/Expr/Intr`, ~l.387-860) so the bake can call it to produce the summary, and so `shakeProgram` can use the installed summary for `i < bkRuntimeFuncBoundary` when present. The IR walk is used for everything else, and for runtime functions when no summary is installed (the from-source path).
- Create: `tests/bake/shakesum.sh` (a host test).
  - For each of `examples/{bookmarks,hello-mac,texteditor,tcpchat}.cla` plus the atalk and tcp twin fixtures, a debug dump of shake marks and edges (add a `CLARUS_SHAKE_DUMP=1` env probe, or reuse `--listing` func headers) from `--rtbake` (summary) and from source (IR walk). They must be identical.
  - Also an internal consistency check: for every runtime function, the baked list equals the IR walk of its body, computed in the bake process itself (e.g. a `--bake-ir` self-check that aborts on mismatch).

- [ ] **Step 1:** Write the test. Expected FAIL: no summary exists yet.
- [ ] **Step 2:** Implement. The summary is written and used while IR bodies are still in the bake: this task changes the file, not the output.
- [ ] **Step 3:** Identity check (explained `DIFF clir` only), `make test T='bake/ cg68k/ testsuite/'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`.
- [ ] **Step 4:** T1, then commit: `feat(bake): call-graph summary; shake walks it for runtime functions (SE wave 4)`.

**Interfaces produced:** the `ShakeSummary` section; `bkLdShakeEdges` (or similar) installed; a shake entry point that uses it.

---

### Task 3: `file.openRead` (user-facing, both lanes)

**Files:**
- Modify: the `file.open` intrinsic path in `clarusc/check.cla`, `clarusc/lower.cla`, `clarusc/cg68k.cla` and `clarusc/cprint.cla` (find it with `/usr/bin/grep -a -n 'openRF\|"open"' clarusc/*.cla` and mirror `file.openRF`, which was added the same way).
- Modify: `runtime/clarus/fileh.cla`, `fileh_68k.cla` (`rtFhDevOpen` ~l.89-110 with `fsRdPerm`) and `fileh_c.cla`, plus `runtime/host/rt_fileh.inc` (~l.44-49, `O_RDONLY`). Writes (`writeAt`, `setSize`, `flush`) on a read-only handle return `false` plus `lastError` and never crash.
- Create: `testsuite/core/cases_openread.cla`, an `OpenRead` case: create a file, write it, and close it; `file.openRead` it; `readAt` returns the bytes; `writeAt` returns false with `lastError` set; `openRead` of a missing path returns nil with `lastError`. Register it (core 90 → 91) in the five places and the file lists.
- Modify: `docs/clarus-language-reference.md` (the filehandle section: `file.openRead`).

- [ ] **Step 1:** Write the case. Run the host core CLI: FAIL.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** `make test T='testsuite/ lowlevel/ emitui/ bake/ cg68k/'`. Runtime growth may move goldens; rebless them in their own commit with the reason. Then the identity check.
- [ ] **Step 4:** Emulator: `mactest/coresuite_68k` (core 91/91).
- [ ] **Step 5:** T1, then commit: `feat(lang): file.openRead -- read-only filehandle (SE wave 4)`.

**Interfaces produced:** `file.openRead(path): filehandle`; the native `rtFhDevOpenRead` (or a flag on `rtFhDevOpen`).

---

### Task 4: Early front-end free and reachable-only codegen lists (byte-identical)

**Files:**
- Modify: `clarusc/drive.cla`, `clarusc/parse.cla`/`lex.cla` as needed.
  - Release `toks` and `lexSrc` right after the last parse. That is after Phase A plus the manifest splice on the from-source path, and after the user parse on the bake path.
  - Confirm with `/usr/bin/grep -a` that nothing reads them after that point (check, lower and diagnostics: if diagnostics need source text for line/column, keep what they need and say so).
- Modify: `clarusc/cg68k.cla` Measure (~l.14406-14414). Allocate `cgFuncStrLits/ArrLits/EnumTables/Serdescs` only for shake-reachable functions (or flatten them the way the `bkLdObj*Flat` lists are), keeping every reader correct for unreachable indices.
- No new test file is needed. The memgate subcases are the measurement. Record before/after peaks for all three in the report.

- [ ] **Step 1:** Measure before: `make test T=memgate/` and `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla`, run from outside the repo per CLAUDE.md.
- [ ] **Step 2:** Implement.
- [ ] **Step 3:** Identity check (no DIFF at all), `make test T='bake/ cg68k/ testsuite/ selfhost/diag selfhost/modules memgate/'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`. Measure after.
- [ ] **Step 4:** T1, then commit: `perf(clarusc): free tokens/lexer after parse; codegen lists only for reachable functions (SE wave 4)`.

---

### Task 5: Snapshot regeneration (serialization point)

Needs Tasks 1-4 merged.

- [ ] **Step 1:** Run `make test T=selfhost/fixedpoint` and follow its printed recipe until it passes. Then `make test T=selfhost/` must be 6/6.
- [ ] **Step 2:** Probe: a scratch program using `file.openRead` compiles with the regenerated snapshot (`cc -O1 -I runtime/host -o /tmp/claude-1000/w4t5/cc clarusc/clarusc.c runtime/host/rt.c`, then `emit`).
- [ ] **Step 3:** T1, then commit `clarusc/clarusc.c` alone.

---

### Task 6: CLIR v9 and the lazy install/read path (output-changing for the library; programs byte-identical)

Needs Task 5.

**Files:**
- Modify: `clarusc/bake.cla`:
  - `bakeWriteFile` (~l.1826-1975) writes the v9 layout. The header drops the body hash. A section directory (id, offset, length) follows the module list. `bkFormatVersion` becomes 9.
  - Stop writing IrExprs/IrStmts. Add a compact `GlobalInits` section: the runtime global-initializer expression trees renumbered into their own arena, plus the exprs they reference. Write parameter-only IrLocals.
  - Give ObjCode a per-function (offset, length) index.
  - Checker sections are written as today but read only when `testapi`.
- Modify: the loader, `bkLoadRtbake`/`bkLoadSections` (~l.3699-4038) and `bkInstallArenas` (~l.4364-4640).
  - Read the header and directory with `readAt`, then the resident table sections.
  - Keep the object section's reachable-function data lazy: after shake (which now uses Task 2's summary and needs no bodies), read the reachable functions' spans (coalesced) into one buffer.
  - Paste decodes holes from the 21-byte wire form in that buffer (`cgObjPasteHole`, `cgObjResolveLabel`) instead of `cgObjHoles` 48-byte records.
  - Install the `GlobalInits` arena where `cgEmitInitGlobalsStub` (`cg68k.cla` ~l.5337) and shake's global-init roots read runtime init exprs.
  - `bkCheckRtbakeHeader[Body]` (~l.3940/3948) becomes a header-only stamp and version check.
- Modify: `clarusc/main.cla` (~l.624-631) and `clarusc/drive.cla` (~l.2166-2175). The host `--rtbake FILE` no longer `readText`s the whole file: it opens it with `file.openRead` and hands the filehandle to the loader.
- Modify: `clarusc/cg68k.cla` Measure and paste (`cgObjPasteEligible` ~l.15625 and the Measure copy of baked meta ~l.14515-14545) to read from the lazy buffer.
- Modify: the `tests/bake/` format fixtures (`header`, `bodyhash`, `corrupt`, `refuse_*`, and any script that pokes offsets). Retarget them to v9 in a separate commit whose message states the reason.
- Create: `tests/bake/lazyread.sh`: instrument the loader (an env probe, `CLARUS_BAKE_READLOG=1`, printing total bytes read from the library) and assert that `hello-mac --rtbake` reads less than `bookmarks --rtbake`, which reads less than the whole file, and that neither reads any IR body section.

- [ ] **Step 1:** Write `lazyread.sh`. Expected FAIL.
- [ ] **Step 2:** Implement the writer, then the reader, the paste and the host front end.
- [ ] **Step 3:** Identity check (`DIFF clir` expected: the format changed; every program line must be clean), `make test T='bake/ cg68k/ emitui/ testsuite/ lowlevel/ selfhost/diag selfhost/modules memgate/'`, and `CLARUS_BAKE_FULL=1 make test T=bake/`. Record the memgate peaks and the at-peak census.
- [ ] **Step 4:** T1, then commits: `feat(bake): CLIR v9 -- directory, no IR bodies, indexed lazy object code (SE wave 4)` and `test(bake): retarget format fixtures to CLIR v9 (SE wave 4)`.

---

### Task 7: ClarusC.APPL data-fork container and discovery

Needs Task 6.

**Files:**
- Modify: `scripts/build-clarusc-mac.sh`: bake v9 and put it in the application's **data fork**, not a resource. `app68WrapFork` (MacBinary wrapper; find it with `/usr/bin/grep -a -n app68WrapFork clarusc/*.cla`) gains a data-fork input, e.g. a new `emit68k --data-fork FILE` flag replacing `--bake-ir PATH` for this purpose. Keep the `CLFS` `--bake` source resources.
- Modify: `clarusc/macgui.cla`, `gcResolveBakePath` (~l.608-649) and the stamp resource `__clarusc_stamp__` (~l.165):
  - find the app's own file with `GetAppParms`. Add the trap to `toolbox/` (Segment Loader, 1985 IM II) together with the rest of that manager's routines where feasible, per the standing principle.
  - `file.openRead` its data fork and hand the handle to the Task 6 loader.
  - Remove the `readResource("__clir_bake_68k__")` path.
  - If the data fork is empty or the stamp mismatches, fall back to the `CLFS` from-source path with today's diagnostic.
- Modify: `runtime/clarus/native.cla`. Remove `natReadResource`'s use for the library. Keep the function if anything else uses `file.readResource`.
- Modify: `tests/mactest/snow/clarusc_bake.sh` and `macresident*.sh` only if their "bake path taken" assertion text changes.
- Test: a host-side check that `build-clarusc-mac.sh`'s output `.bin` has a non-empty data fork whose first bytes are `CLIR` and a resource fork without `__clir_bake_68k__`. Read the MacBinary header (data-fork length at offset 83, resource length at 87) and use `build-run/tools/resfork list`. Add it as `tests/bake/clarusc_container.sh`.

- [ ] **Step 1:** Write `clarusc_container.sh`. Expected FAIL.
- [ ] **Step 2:** Implement. `build-clarusc-mac.sh` bootstraps from the snapshot, which learned `file.openRead` in Task 5 but not the v9 loader or the new flag. Run the container test with a snapshot-equivalent built from `clarusc-current` if needed, and say how in the report. Task 8 regenerates.
- [ ] **Step 3:** `make test T='bake/ selfhost/diag selfhost/modules'` and the identity check.
- [ ] **Step 4:** T1, then commit: `feat(clarusc-mac): runtime library in the data fork, found via GetAppParms (SE wave 4)`.

---

### Task 8: Fork pre-size, census-driven trims, final regeneration, ratchet

Needs Task 7.

- [ ] **Step 1:** Pre-size the output fork (`cg68BuildFork`/`app68BuildFork`) to its computed size, so it does not double while segment bytes are live. Identity check.
- [ ] **Step 2:** Re-run `scripts/memcensus.sh --rtbake --at-peak examples/bookmarks.cla` (from outside the repo). If `strIndex` or `a68Items` is still a top bucket and a contained change trims it, do it; otherwise record why not. Identity check after each change.
- [ ] **Step 3:** Regenerate the snapshot (the Task 5 recipe). `make test T=selfhost/` must be 6/6. Commit `clarusc/clarusc.c` alone.
- [ ] **Step 4:** Run `make test T=memgate/` three times; the peaks must be identical. Set each budget to `int(P * 1.01) + 1`, never above the current value. Add the change-log line: `# 2026-09-29 wave 4: lazy runtime library (no IR bodies, indexed object code, data-fork readAt). Measured peaks <P1> / <P2> / <P3> + 1%.` If `bookmarks_rtbake` > 1,258,291, commit the measured value and put the census in the report.
- [ ] **Step 5:** T1, then commit: `test(memgate): ratchet to wave 4 peaks (SE wave 4)`.

---

### Task 9: IIcx gates and docs (controller-driven)

- [ ] **Step 1 (subagent):** `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_memprobe`; save the log as `build-run/memprobe-saved/clarusc_memprobe.wave4.log`. Record the numbers against Wave 3's (launch free, low point used, stack, parse span, ticks).
- [ ] **Step 2 (subagent):** Docs:
  - umbrella §5.5 row 4 and §9 status, plus a new "Wave 4 measurements" subsection;
  - the wave spec's status line;
  - `docs/ROADMAP.md`;
  - `docs/HISTORY.md`: a Wave 4 entry listing every ledger `Ruling:` with its cost, with the `<T2 result>` and `<clarusc_bake result>` placeholders;
  - `docs/TODO.md`;
  - CLAUDE.md's ClarusC build paragraph (data fork, no `__clir_bake_68k__`).

  Every Markdown table must have aligned columns.
- [ ] **Step 3 (controller):** `scripts/test-merge.sh`; `CLARUS_SNOW_TESTS=1 make test T='mactest/snow/clarusc_bake mactest/snow/macresident mactest/snow/macresident_failed_compile'` (macresident also checks the log/trace detour's untested TickProbe change). Fill in the HISTORY placeholders.
- [ ] **Step 4:** The final whole-branch review (Opus), one fix wave, a scoped re-review, then report to Andrew. Do not merge.
