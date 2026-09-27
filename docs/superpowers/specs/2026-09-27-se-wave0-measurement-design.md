# SE memory program, Wave 0: Measurement (spec, 2026-09-27)

Status: **spec, awaiting review.** Branch `se-wave0-measurement`.
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 0 is the
brief; its decision log D1–D12 is input, not open). Findings:
`2026-09-27-se-memory-footprint-findings.md` §8.

## 1. Goal and exit

Give every later wave a number to beat, measured on the host so it runs
in T1 with no emulator, and pin that number to reality with two
on-target measurements.

**Exit** (umbrella §6):
- `tests/memgate/` is in T1 and green at the baseline budgets.
- The SE app budget (Snow SE, System 6.0.8, single-app) is recorded.
- The Mac IIcx per-phase heap and stack high-water for ClarusC compiling
  `examples/bookmarks.cla` are recorded.
- The numbers go into the umbrella's §9 and the Wave 0 HISTORY entry.

## 2. Decisions settled in this spec

| #   | Decision                                                                                                                                                                                                                                                                                                                                                      |
|-----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| W1  | **Block-header model** (umbrella open item). A block costs `round4(size) + H`, plus 4 bytes for a handle's master pointer. `H = 8` (24-bit Memory Manager, the SE) is the gated number. The IIcx runs 32-bit addressing (`H = 12`) and is used only to calibrate, via `live + 4 × blocks`.                                                                  |
| W2  | **Host payloads are counted at host width.** Box sizes already match (both lanes allocate 40-byte list boxes today; Wave 2 shrinks them). The only remaining host/68k difference is pointer-width elements (8 vs 4 bytes), a small overcount in the conservative direction. It is recorded, not modelled; the IIcx calibration (§5.3) bounds it.              |
| W3  | **The probe lines are always on in ClarusC.APPL** (Andrew, 2026-09-27). Host output is unchanged: the host front end's probe prints nothing unless `CLARUS_MEM_PEAK=1` is set, so the C `emit` lane stays byte-silent and `emit68k`'s stderr is unchanged by default.                                                                                       |
| W4  | **Host counters are switched on at run time by `CLARUS_MEM_PEAK=1`, not by a special build.** The counters are maintained unconditionally (a few adds per allocation); only the dump is gated. The gate runs the ordinary `build-run/clarusc-current`.                                                                                                       |
| W5  | **The phase hook is an explicit front-end seam, `feMemProbe(phase: string)`**, called from `driveProgressPhase` and `driveProgressDone`. It is not a piggyback on `TickCount`, which other code also calls.                                                                                                                                                  |
| W6  | **Reading the stack pointer**: a new extern clause `= inline sp` (twin of `inline a5`), which returns A7 in D0. The C printer ignores extern clauses (every extern becomes an `rt_ext_<Name>` call), so no C-lane change is made; only macgui.cla (native-only) uses it, so no host shim is needed. |
| W7  | **The per-global census is a diagnostic script, not part of the gate.** Tags cannot name tables (every list data handle is tagged with the same `rt_ext_host.inc` wrapper line), so naming tables needs the census. Later waves use it to aim; the gate only needs totals.                                                                                    |

## 3. Host measurement

### 3.1 Counters (`runtime/host/rt_mem_host.inc`)

Maintained on every allocation path:

| Counter     | Updated at                                                                                                         |
|-------------|--------------------------------------------------------------------------------------------------------------------|
| `live`      | `+size` in `rt_mem_alloc_block`; `±delta` on both `rt_mem_set_handle_size` paths; `-size` in `DisposeHandle`/`DisposePtr` |
| `live68k`   | the same events at 68k cost: `round4(size) + 8 (+4 if handle)`, and `round4(new) − round4(old)` on resize            |
| `peak`, `peak68k` | max of the above since the last dump (reset after each dump)                                                 |
| `peakAll68k` | max since process start (never reset)                                                                             |
| `blocks`, `handles` | live block count, and how many of them are handles                                               |
| `allocs`    | allocations since the last dump                                                                                      |

The shim's quarantine (retired raw memory) is not counted: counters
follow logical block lifetimes, not `malloc`.

### 3.2 Dump

`rtm_dump(const char *phase)` prints one line to stderr, only when
`CLARUS_MEM_PEAK=1`:

```
memprobe: <phase> | live68k=N peak68k=N live=N peak=N blocks=N handles=N allocs=N
```

`CLARUS_MEM_PEAK=2` additionally prints the per-tag live-bytes histogram
(top 15 tags) under each line. At exit (the existing `atexit` hook), if
enabled: `memprobe: TOTAL | peakAll68k=N`.

### 3.3 The hook

- `drive.cla`: `driveProgressPhase(msg)` and `driveProgressDone()` call
  `feMemProbe(msg)` (the done call passes `"Done"`), after their own
  progress line. They already return early unless `want68k`, so the C
  `emit` lane never reaches the probe.
- `main.cla` (host front end): `feMemProbe(phase)` calls a new host
  extern `MemProbe(phase)`, implemented as `rt_ext_MemProbe` in
  `runtime/host/rt_ext_host.inc`, which calls `rtm_dump`. It is
  main.cla's first extern. If any test compiles `main.cla` for the 68k
  lane, the declaration needs a native meaning (`= inline nop`); the
  plan's first task checks this and settles it.
- `macgui.cla`: see §4.1.

This regenerates the `clarusc/clarusc.c` snapshot once (drive.cla and
main.cla change). User-program output is byte-identical: no runtime
`.cla` module changes, and no golden moves.

### 3.4 The gate (`tests/memgate/`)

One script, `tests/memgate/peak.sh`, with three subcases:

| Subcase           | Command                                                                  |
|-------------------|--------------------------------------------------------------------------|
| `bookmarks_rtbake` (primary) | `emit68k --rtbake $WORK/rt.clir -o … examples/bookmarks.cla`   |
| `bookmarks_src`   | `emit68k --rtdir runtime/clarus/ -o … examples/bookmarks.cla`           |
| `hello_src`       | `emit68k --rtdir runtime/clarus/ -o … examples/hello-mac.cla`           |

- The CLIR comes from `$CLARUSC --bake-ir --lane 68k --rtdir … -o
  $WORK/rt.clir`, as `tests/lib_bake.sh`'s `bake_ir` does.
- Each run sets `CLARUS_MEM_PEAK=1`, takes the `TOTAL` line's
  `peakAll68k`, and compares it with `tests/memgate/budget.txt`. That
  file has one `name bytes` line per subcase and `#` comments giving the
  date and the reason for each change.
- **Budget = measured baseline + 1%.** Host allocation is deterministic,
  so the margin covers only benign drift. The first budget is set from
  the real measurement in the plan; the umbrella table's "~11.5 MB" is
  an estimate.
- Result: `PASS <subcase>` with `peak X / budget Y (Z%)`. Over budget is
  `FAIL`, with the per-phase `memprobe:` lines in the log. Under 95% of
  budget, it also prints `note: ratchet available`, which is not a
  failure.
- The group joins T1 automatically (the Makefile's `find` picks it up).
  Expected cost: one bake-ir run plus three compiles, well under a
  minute on this machine; the plan measures it.
- `tests/hostrt/` gets a small C unit test over the counters: alloc,
  grow, locked shrink, dispose and peak reset give the exact expected
  `live`/`live68k` numbers.

### 3.5 Census (`scripts/memcensus.sh`)

A diagnostic tool, not a test:

1. Scan `build-run/clarusc-current.c` for global `rt_list *`, `rt_map *`
   and `rt_text *` statics.
2. Generate `rtm_census()`, which prints each global's name, handle
   size, count, elemsize and cap, using local mirrors of `struct
   rt_list`/`struct rt_map` from `rt_core.inc`.
3. Build a census-enabled compiler into `build-run/memcensus/`, and run
   a given compile with `CLARUS_MEM_PEAK=2`. The dump calls the census
   when it is linked in (a weak symbol, or a `#ifdef` set by the
   script), and prints the top 25 globals by bytes under each phase
   line.

Usage: `scripts/memcensus.sh [--rtbake] FILE.cla`. It is documented in
the script header and in CLAUDE.md's build section.

## 4. On-target measurement

### 4.1 ClarusC.APPL probes (`clarusc/macgui.cla`)

- **Per phase**: `feMemProbe(phase)` appends one line to the log:
  `  mem: free N KB, max M KB` (`FreeMem`, `MaxBlock`). It is a separate
  line rather than a suffix, so it is easy to grep and leaves the phase
  line's shape alone.
- **`MaxBlock`** (0xA061, register-result trap) is added to
  `toolbox/memory.cla` next to `FreeMem`. It is added with any sibling
  routines the catalog is still missing that the plan finds are cheap to
  add (standing Toolbox rule: enable the rest of the manager).
  `tests/testsuite/catalog.sh` covers the new declarations.
- **Stack high-water**:
  - At app start, paint the unused stack from `ApplLimit` (long at
    0x130) + 16 up to `SP − 1 KB` with the long `0xC1A5C1A5`. `SP` comes
    from `= inline sp` (W6).
  - After each compile, scan upward from `ApplLimit` for the first word
    that isn't the pattern. Log `  stack: high-water N KB of M KB`,
    where N = `CurStackBase` (long at 0x908) − that address and M =
    `CurStackBase − ApplLimit`. Then repaint for the next compile.
  - If `SP − 1 KB` is below the paint start, skip painting and log
    `stack: probe unavailable`.
- **Log cap.** The native log buffer is capped at 4096 bytes
  (`natLogCap`, `runtime/clarus/native.cla:106`), and anything past
  that is silently dropped. The IIcx run (§5.2) checks that the `out`
  file ends with the `Finished` line. If the probe lines push it past
  the cap, the fix is to raise `natLogCap` in its own output-changing
  task. That moves every native golden, so it is a serialization
  point.

### 4.2 SE app budget (`tests/mactest/snow/se_budget.sh`)

- A small native Clarus app, `testdata/snow/sebudget.cla`, logs:
  - `FreeMem`, `MaxBlock`;
  - the low-memory globals `ApplZone` (0x2AA), `ApplLimit` (0x130),
    `HeapEnd` (0x114), `CurStackBase` (0x908), `BufPtr` (0x10C) and
    `MemTop` (0x108);
  - its own stack reserve.

  Then it quits.
- The script gates on `CLARUS_SNOW_TESTS=1`, forces `SNOW_SYSTEM=6`,
  and autostarts the app single-app through the existing boot-block
  path. It asserts the trailer, then prints a derived summary:
  - **heap available** = `FreeMem` after startup;
  - **app space** = `BufPtr − ApplZone`: heap zone plus stack plus
    free, the ceiling a single-app ClarusC can use for heap and stack
    together. Code segments load into that heap.
- It is re-runnable, and this wave records its numbers once. Andrew's
  real SE has more INITs/cdevs than Snow's image. The number recorded
  is Snow's, labeled as such.

### 4.3 Mac IIcx baseline (`tests/mactest/snow/clarusc_memprobe.sh`)

- Modeled on `clarusc_bake.sh`: build ClarusC.APPL with an events
  script that compiles `examples/bookmarks.cla`, boot it on the IIcx
  (`snow_clarusc_system`), and fetch `out`.
- It extracts the phase, `mem:` and `stack:` lines into
  `$WORK/memprobe.txt`, copies them into the log, and asserts that each
  phase has a `mem:` line and that there is one `stack:` line.
- It records the compile time in ticks from the existing `Compiled …
  (N ticks)` line.
- Standing-rule note: this wave touches `macgui.cla`, so
  `mactest/snow/clarusc_bake` runs at the wave's close (umbrella §5.3).

## 5. Recording and calibration

1. **SE budget** → umbrella §9 and HISTORY: `FreeMem`, `MaxBlock`, app
   space, and the derived **ClarusC target**: app space minus a stack
   reserve of 64 KB and minus resident code (as of Wave 0: 1.56 MB).
   The target is the number Wave 5 must meet.
2. **IIcx baseline** → umbrella §9: per-phase free/max, heap used per
   phase (free at start − free at phase), stack high-water, and ticks.
3. **Calibration**: for each phase, compare the IIcx heap used with the
   host `live68k` from `bookmarks_rtbake` plus `4 × blocks` (H = 12).
   Record the ratio per phase in the HISTORY entry. The IIcx figure
   also includes the code segments and the 1.92 MB CLIR resource, which
   the host never loads as code; subtract those (from the SE probe app
   and the ClarusC build's segment sizes) before comparing. A ratio
   outside 0.85–1.15 at the peak phase is written up as a Wave 1 input
   (which host-model term is wrong). It does not change the gate.

## 6. Output policy (umbrella §5.4)

| Change                                                    | Label                                                                                                      |
|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| Host counters, `MemProbe` extern, hostrt unit test        | byte-identical                                                                                             |
| `inline sp` clause (parse/check/cg68k)                    | byte-identical (additive; no existing program uses it)                                                     |
| `MaxBlock` + siblings in `toolbox/memory.cla`             | byte-identical (catalog declarations only)                                                                 |
| drive.cla/main.cla seam                                   | byte-identical for user programs; **snapshot regeneration** (serialization point)                          |
| macgui.cla probes                                         | changes ClarusC.APPL only; no golden covers it                                                             |
| `natLogCap` raise, **only if** §4.1's check fails         | output-changing (every native golden), its own task                                                        |

## 7. Out of scope

- Any memory reduction: that is Wave 1 onward.
- Modelling pointer-width payloads or box sizes (W2).
- A MultiFinder partition measurement: D11 fixes single-app.
- Gating on-target numbers in CI: the Snow scripts are opt-in, and
  the numbers are recorded, not asserted.
