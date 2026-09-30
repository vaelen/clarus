# SE memory program, Wave 5: Close on the SE, with margin (spec, 2026-09-30)

Status: **merged to main** (2026-09-30, fast-forward to `9c738c32`; tagged `v1.1`). Branch
`se-wave5-close`. ClarusC compiles `bookmarks.cla` on the Snow SE with
a lowest free of 1130 KB; the floor is 1017 KB. Numbers: umbrella §9.6;
rulings: `docs/HISTORY.md`'s Wave 5 entry. Two changes from this spec:
a controller-added Task 7a (the recursive walkers' frames, see §7), and
the Wave 6 answer, **no-go** (Andrew, 2026-09-30).
Umbrella: `2026-09-27-se-memory-program-design.md` (§6 Wave 5 is the
brief; D1, D9, D11 are the inputs this spec revises or closes). Wave 4's
numbers: umbrella §9.5.

Anchors below are as of `main` at `6d3c8f0e`.

## 1. Why this wave is smaller than its brief

The umbrella's Wave 5 brief (code overlays, a `segment` directive,
smaller frames, a streamed fork) assumed ClarusC would still be over
the SE's 2221 KB heap target after Wave 4. That target was Wave 0's
conservative estimate: app space minus 64 KB of stack minus all
1.56 MB of CODE, set while the 1.9 MB library resource was still read
into the heap.

A throwaway spike on 2026-09-30 (Wave 4's tip plus a scripted-mode disk
mount in `macgui.cla`) compiled `examples/bookmarks.cla` with ClarusC
on the Snow SE (4 MB, System 6.0.8, single-app via boot-block
autostart):

| Point                   | Free KB | Used KB |
|-------------------------|--------:|--------:|
| launch (zone 3038 KB)   |    2783 |       0 |
| Parsed user program     |    1666 |    1117 |
| Measured                |     531 |    2252 |
| Emitted segment 4 (low) |     342 |    2441 |
| Built fork              |     617 |    2166 |

- `clarusc_memprobe` 5/5 and `clarusc_bake` 6/6 passed on the SE: bake
  path taken, no fallback to source, byte-identical output. The compile
  took 4m 39s of guest time.
- Heap use matches the IIcx's (2441 KB used vs 2443 KB at the same
  phase). Stack high-water was 128 KB of a 736 KB reserve (IIcx:
  194 of 752 KB).
- The only blocker was a harness gap. In scripted (`--events`) mode the
  runtime never pulls disk-inserted events (§3.1). On System 6 without
  the Finder, the `Clarus` volume therefore never mounts, and the
  compile fails with `cannot open entry file`. It went unseen because
  every ClarusC compile test defaults to the IIcx, and on the SE
  ClarusC used to run out of memory long before it opened a source
  file.

So the goal (D1) is already within reach. This wave fixes the harness,
makes the SE the standing gate, and buys margin with the two cheapest
large levers. It then closes the program.

## 2. Decisions (Andrew, 2026-09-30)

| #  | Decision                                                                                                                                                                                                      |
|----|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| V1 | **Scope: close with margin.** Scripted pump mounts disks; the SE becomes the default ClarusC acceptance machine with a floor; a measured stack reserve plus a depth guard; a table-driven `cg_free_globals`.  |
| V2 | **D9 amended.** The `segment "name"` directive, `UnloadSeg` and ClarusC phase overlays leave the SE program and become their own later phase (ROADMAP). Smaller walker frames and a streamed fork go to TODO. |
| V3 | **Stack: measured reserve plus guard.** ClarusC's reserve is 2× its largest measured high-water. A too-deep source aborts the compile with a diagnostic instead of corrupting the heap.                       |
| V4 | **SE gate: default machine plus floor.** The ClarusC Snow scripts default to the SE; `clarusc_memprobe` there fails under a committed low-point floor.                                                        |
| V5 | **`cg_free_globals` becomes table-driven** (approach (a) of `docs/TODO.md`'s "ABI / performance" entry), not a jump-table slot.                                                                               |

## 3. Work

### 3.1 W1: The scripted pump mounts disks (runtime; output-changing for UI programs)

- `rtUiPumpPassive` (`runtime/clarus/uiscript.cla` ~l.1326) calls
  `UiGetNextEvent(0x0140, ev)` (update | activate). Widen the mask to
  `0x01C0` (adding `diskMask`, 0x0080).
- The Event Manager mounts the volume itself as it returns a
  disk-inserted event: the spike saw drive 8's event come back with a
  MountVol result of 0, and the `Clarus` volume mounted. The pump drops
  the event (`what == 7`). A failed mount is ignored; `DIBadMount` is
  out of scope.
- The spike's `gcSpikeMountDisks` is not kept. Task 8's
  `gcScriptedSetDefault` stays as it is.
- The native lane is the one that matters. If `uiscript.cla` is also
  spliced into C-lane builds, the host `UiGetNextEvent` returns false
  for the new mask as it does for the old one.

### 3.2 W2: `cg_free_globals` stops being duplicated (output-changing for multi-segment native programs)

Today `cgEmitFreeGlobalsStub` (`cg68k.cla` ~l.5579) is re-emitted into
every segment (~l.16291). It unrolls one `MOVE.L off(A5),D0; …; JSR`
group per handle-typed global. For ClarusC that is ~11 KB × 50 segments,
about 500 KB of its 1.60 MB of CODE (`docs/TODO.md` "ABI /
performance"). The same "glue is duplicated, not JT-cross-called" rule
(header comment ~l.1164) also copies `cg_mul32`/`div32`/`mod32` and
every record's `cg_retain_<Rec>`/`cg_release_<Rec>` walk into every
segment that needs them.

- **Measure first.** Record the per-segment size of the duplicated-glue
  bucket (`cgRecMode == 3`), broken down into free-globals, record
  walks and arithmetic, for ClarusC and `bookmarks.cla`.
- **Table-driven free.** Each segment keeps a small stub: one release
  loop plus a constant-pool table with one entry per handle-typed
  global, giving its A5 offset and a kind index. The kind selects the
  release routine the unrolled code calls today (the per-type release,
  or a record's `cg_release_<Rec>` walk). The loop reads each global,
  releases it by kind, and clears the slot exactly as the unrolled code
  does.
- **Order is preserved.** The loop releases globals in the same order
  as today's unrolled code. Finalizers close files, drivers and
  connections, so the order is observable.
- **The record walks.** If the measurement shows the walks are a large
  share of the bucket, they get the same treatment. Otherwise they go to
  TODO with their numbers.
- A program with no handle-typed globals emits no table.

### 3.3 W3: Measured stack reserve plus depth guard (ClarusC only)

- **Reserve.** ClarusC's `app` section (`clarusc/macgui.cla` ~l.530)
  gets `stack: 393216` (384 KB).
  - Rule: 2× the largest measured high-water on either machine. Today
    that is the IIcx's 194 KB, so 388 KB, rounded to 384 KB.
  - Re-measured at every later ClarusC-affecting wave close.
  - Expected gain: about 350 KB of heap on the SE.
- **Guard.** One helper, `drvStackGuard()`, reads SP (`inline sp`,
  reference ~l.2027) and `ApplLimit` (0x130). When fewer than 65,536
  bytes remain, it aborts with `source too deeply nested`.
  - It is called at the entry of the parser's recursive descent
    (`parseExpr`, `parseUnary`, `parsePrimary`, `parseStmt`), of
    `checkExpr`/`checkStmt` and `lowExpr`/`lowStmt`, and of
    `cg68k.cla`'s recursive expression and statement emitters.
  - It is native only. On the host the helper returns at once. The
    implementer chooses the mechanism (for example, a host shim for the
    `inline sp` extern that returns 0), and host output stays
    byte-identical.
  - The abort reaches ClarusC's existing `attempt` around the compile,
    so the user sees an ordinary compile error, and the next compile in
    the session works.
  - Every other compiled program is byte-identical: the guard lives in
    `clarusc/*.cla`, not in the runtime.

### 3.4 W4: The SE becomes the default ClarusC machine, with a floor

- **Default machine.** `snow_clarusc_system` (`tests/lib_snow.sh`
  ~l.310) defaults `SNOW_SYSTEM` to 6. `CLARUS_SNOW_CLARUSC` is removed,
  and `SNOW_SYSTEM=7` runs the IIcx. This covers `clarusc_bake`,
  `clarusc_memprobe`, `macresident` and `macresident_failed_compile`.
- **Floor.** `clarusc_memprobe` reads the compile's lowest per-phase
  free KB. On the SE only, it fails when that value is below the floor
  in `tests/mactest/snow/se_floor.txt` (one integer, KB, plus a
  comment line per change).
  - At wave close the floor is set to 90% of the measured low point,
    rounded down.
  - Later waves may only raise it. It moves down only with a written
    measured justification, the same rule as §5.5 of the umbrella.
- **Deep-source test.** A new `tests/mactest/snow/clarusc_deep.sh`
  generates a source nested deeply enough to hit the guard. ClarusC on
  the SE must report `source too deeply nested`, as a compile error that
  is neither a hang nor a crash, and quit normally.
- **CLAUDE.md.** The standing rule becomes "`clarusc_bake` on the SE
  after any change to `clarusc/bake.cla` or `clarusc/macgui.cla`". The
  Snow bullet says ClarusC fits the SE.
- The floor is set on Snow's System 6 image. Andrew's real SE has more
  INITs/cdevs and less free memory. The docs say so.

### 3.5 W5: Close the program

- Umbrella:
  - §5.5 row 5 with the SE numbers;
  - §9's Wave 5 row and a §9.6 with SE and IIcx per-phase tables
    against Wave 4;
  - the status line;
  - **D1 marked done**;
  - D9's amendment recorded;
  - the **Wave 6 go/no-go** presented to Andrew with the numbers, and
    his answer recorded.
- `docs/ROADMAP.md`: the SE program closed, and the segment
  directive / overlays phase entered.
- `docs/HISTORY.md` Wave 5 entry, with every ledger ruling. Also
  `docs/TODO.md` and `docs/FUTURE.md`.

## 4. Output policy

| Change                   | Label                                                                                                      |
|--------------------------|------------------------------------------------------------------------------------------------------------|
| W1 pump mask             | output-changing: UI programs' goldens (one immediate); frozen UI scenario traces/snaps must NOT move       |
| W2 table-driven free     | output-changing: multi-segment native programs' `.s` goldens; behaviour identical, release order identical |
| W3 stack reserve + guard | byte-identical for every program except ClarusC.APPL itself                                                |
| W4 harness               | tests only                                                                                                 |
| snapshot regeneration    | serialization point                                                                                        |
| memgate budgets          | unchanged unless a peak drops (ratchet down only)                                                          |

W1's and W2's golden moves are made in one combined rebless task, with
a written reason per golden family.

## 5. Sequencing

- **Wave A (parallel worktrees):**
  - T1, W1 (the `uiscript.cla` mask);
  - T2, W2 (measurement, then the free-globals table, in `cg68k.cla`'s
    glue and emit regions);
  - T3, W3 (`drive`/`parse`/`check`/`lower` plus `cg68k.cla`'s emitter
    entries only, and `macgui.cla`'s `stack:`);
  - T4, W4's harness (`lib_snow.sh`, `clarusc_memprobe.sh`,
    `clarusc_deep.sh`, a placeholder `se_floor.txt`).
  - T1 and T2 do not rebless.
- **Serialization, in order:**
  1. merge, then the combined rebless;
  2. snapshot regeneration, so `build-clarusc-mac.sh` builds a ClarusC
     with W2 and W3;
  3. wave close, run by the controller.
- **Wave close:**
  - full T2;
  - on the SE: `clarusc_bake`, `clarusc_memprobe`, `macresident`,
    `macresident_failed_compile`, `clarusc_deep`;
  - `clarusc_bake` on the IIcx;
  - the floor committed;
  - the §9.6 measurements;
  - W5's docs.

## 6. Tests

- Per task: T1, plus the Wave 4 identity check for byte-identical
  tasks.
- **W1:** the SE ClarusC runs at wave close are the proof, together with
  the reblessed goldens.
- **W2:**
  - The existing suites prove behaviour. Relevant cases include
    `toolbox_68k`'s `LeakCheck`, the core filehandle cases and
    `LogFile`, and the connection/atalk/tcp twins, since finalizer
    order is observable.
  - A new host check that ClarusC.APPL's total CODE falls by at least
    400 KB, read from the MacBinary resource map as
    `tests/bake/clarusc_container.sh` does.
  - The glue measurement goes in the task report.
- **W3:**
  - `clarusc_deep` on the SE.
  - T1 green, which covers host byte-identity and a no-op guard.
  - The SE memprobe stack line reports the new 384 KB reserve.
- **W4:** `runner/syntax`, plus the wave-close runs.

## 7. Out of scope

- The `segment` directive, `UnloadSeg` and ClarusC phase overlays (V2),
  now a later phase.
- Smaller frames on the recursive walkers, and a streamed output fork
  (TODO). **The frames were done after all** (Task 7a, 2026-09-30): at
  close, `macresident_failed_compile` tripped the depth guard on the SE,
  and the cause was cg68k's 4 × 512-byte big-temp floor in every native
  frame. It now applies on the measure pass only, and the cold abort
  strings left the walkers (umbrella §9.6). Only the streamed fork
  stays in TODO.
- The Wave 4 leftovers: the `strIndex` rewrite, `a68Items`' 68-byte
  record and `reserve`'s power-of-two slack. They go to TODO unless the
  wave-close census makes one necessary.
- Wave 6 (separate compilation plus a linker): decided at close, not
  built here. **Decided: no-go** (Andrew, 2026-09-30); recorded in
  `docs/FUTURE.md`.
