# Session status — 2026-08-25 (transfer-crcs: COMPLETE, T2 green, not merged)

Handoff summary. **The `transfer-crcs` phase (branch `transfer-crcs`, based
on `main` at `26d6748` — `binary-files` is already merged into `main`)
adds `text.crc16x` (CRC-16/XMODEM, bitwise) and `text.crc32` (CRC-32/
ZMODEM, table-driven), both lanes, driven by 68kBBS's XMODEM/YMODEM/
ZMODEM needs. Task 1 shipped the two methods plus a rebless wave (the
two new runtime globals shift every later global's A5 offset in every
cg68k/emitui golden); an unplanned mid-task finding forced the `crc32`
table off a `int[256]` global onto a lazily-built heap block, because
`cg_init_globals` unrolls array-global zero-init into one store per
element (~1.5 KB of startup code added to every native program, not
just `crc32` callers) — fixed on the runtime side, not codegen, and
reblessed a second time from a clean base. Task 2 grew the core suite's
`Crc16` case and proved it on real 68000 hardware. Task 3 (this
close-out) regenerated the bootstrap snapshot, re-verified the
`.behavior` golden for real (byte-identical to Task 1's hand-written
version — the real bless surfaced one legitimate new artifact,
`testdata/run/crc16.leaks`, for the table's intentional process-lifetime
heap allocation), and closed out docs. Full T2 PASS (see §1). NOT
merged, NOT pushed — merge only on Andrew's request.**

## 0. START HERE next session

**The phase is fully closed on the branch — nothing code-side remains,
including the Snow timing probe (below).** What's left is entirely the
merge decision.

**What this phase built** (3 tasks, one commit each — `c4e6c31` (Task
1), `213a782` (Task 2), `f3e8367` (Task 3), plus the close-out fix
commit; full detail in `.superpowers/sdd/2026-08-25-transfer-crcs/`):

1. **`t.crc16x(h, pos, n)`** — CRC-16/XMODEM, poly `0x1021` forward
   (MSB-first, no reflection), same bitwise-loop shape as the existing
   `t.crc16` (CRC-16/KERMIT). Check value `0x31C3` over `"123456789"`.
2. **`t.crc32(h, pos, n)`** — CRC-32/ZMODEM/IEEE, reflected poly
   `0xEDB88320`, table-driven. Register returned raw (caller applies
   the `0xFFFFFFFF` init/final XOR); check value
   `t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF == 0xCBF43926` over
   `"123456789"`.
3. **The `crc32` table is a lazily-built heap block, not a global
   array.** Original design was `var rtCrc32Tab: int[256]` + a `bool`
   ready flag; `cg68k.cla`'s `cgEmitInitGlobalsStub` default-inits
   every declared global unconditionally, unrolling an array global
   into one store per element (257 scalars, 514 lines for a 256-int
   array), which landed in EVERY native program's startup code
   regardless of whether it calls `crc32`, and pushed 8 previously
   single-segment cg68k fixtures into a second segment. Controller
   ruling: fix on the runtime side. `rtCrc32Tab` is now a single
   `ptr` global (`ptr(0)` until built); `rtCrc32TabInit` allocates 1 KB
   via `TextNewPtr` on first call, fills it with `pokel`, and the
   per-byte lookup uses `peekl`. Net global-offset shift across the
   whole corpus: a uniform **+4 bytes** (one pointer) instead of the
   original **+1026 bytes** (array + flag). The heap block itself is
   never freed (a deliberate process-lifetime cache, same as the
   `ponytail:` comment on the table says) — surfaced by Task 3's real
   `.behavior` bless as one `1024`-byte live block, recorded in the new
   `testdata/run/crc16.leaks` golden (precedented by
   `for_loop_var_alias.leaks`, test-suite-review phase).
4. **Core suite coverage**: `testsuite/core/cases_textbinary.cla`'s
   `caseCrc16` grew XMODEM and ZMODEM vectors (one-shot/chunked/`n==0`/
   table-reuse); no new `CoreTest` enum member, no case-count site
   touched. Proved on real 68000 hardware
   (`TestCoreSuiteGUIOn68k`, System 6, Mini vMac).
5. **Snow timing probe.** Task 2's own attempt collided with a second,
   unrelated Snow instance sharing this machine's display (a concurrent
   session's own work) and was aborted rather than risk clicking into
   someone else's window. A controller rerun of the same throwaway
   program (`build-run/crctime.cla`, TickCount-bracketed
   `crc16`/`crc16x`/`crc32` calls over a 64 KB buffer) completed
   cleanly on a Mac II (16 MHz 68020) Snow instance, read from the
   app's captured out-file (byte-exact) rather than an on-screen alert
   (none was ever observed on screen, though the clean
   `##CLARUS-EXIT## 0` trailer confirms a normal completion). Single
   run, no repeats. Results: `crc16` 277 ticks (≈70.4 µs/byte),
   `crc16x` 287 ticks (≈73.0 µs/byte), `crc32` 120 ticks (≈30.5
   µs/byte) — `crc32` ≈2.3-2.4x faster than either bitwise loop, less
   than the ~5x a table alone would suggest (per-byte loop/`peekb`/
   `peekl` overhead dominates on a 68020); a 1 KB ZMODEM subpacket
   costs ≈31 ms of `crc32` time against the ~180 ms it takes to arrive
   at 57600 bps (≈72 ms bitwise). Full trail:
   `.superpowers/sdd/2026-08-25-transfer-crcs/snow-probe-report.md`.
6. **Close-out (this task)**: bootstrap snapshot regenerated and
   fixed-point-verified, `.behavior` golden re-verified against the
   real bless, spec amendment (`docs/superpowers/specs/
   2026-08-25-transfer-crcs-design.md` §4, Task 1's heap-block pivot
   folded in), `docs/TODO.md` (the `cg_init_globals` finding filed
   under ABI/performance; the array-literal entry's own note extended),
   `docs/HISTORY.md`, `docs/ROADMAP.md`, `CLAUDE.md`, this file.

**Deliberate decisions worth remembering** (full rationale: design spec
§2, §4):
- `crc16` itself is untouched — with `crc32` table-driven it no longer
  shares a loop with `crc16x`, so the hardware-proved `rtTextCrc16`
  stays as-is.
- `app68Crc16` (`clarusc/app68k.cla`, the compiler's own CRC-16/XMODEM
  used for `.APPL` checksums) is deliberately NOT converted to call
  `rtTextCrc16X` — it lives in the compiler, which the committed
  `clarusc/clarusc.c` bootstrap snapshot must still be able to compile;
  wiring it to a runtime intrinsic would break the bootstrap until the
  snapshot is regenerated, not worth the coupling for a 124-byte header.
- The `crc32` table is built lazily because Clarus has no array-literal
  initializer (`var t: int[256]` is always zero-filled); that gap is
  filed in `docs/TODO.md` as its own future language-feature phase.

## 1. Gate results (this phase — `c4e6c31` Task 1, `213a782` Task 2,
   `f3e8367` Task 3, plus the close-out fix commit; code unchanged by
   Task 3 except the snapshot regen + the new `.leaks` golden)

1. **Snapshot fixed point**: PASS. Regenerated per
   `TestSnapshotFixedPoint`'s exact recipe (`cc`-only bootstrap, no Go
   compiler); `go test ./internal/selfhost -run TestSnapshotFixedPoint
   -count=1 -timeout 30m` → PASS, 13.0s. Sanity:
   `scripts/clarus-run.sh testdata/run/crc16.cla` (Go-free, rebuilds
   from the regenerated snapshot) prints all ten `ok` lines.
2. **`.behavior` re-verification**: `CLARUS_BLESS_BEHAVIOR=1 go test
   ./internal/selfhost -run 'TestBehaviorGoldens/run/crc16' -count=1
   -timeout 30m` → the real bless produced a `testdata/run/crc16.behavior`
   byte-identical to Task 1's hand-written version (confirmed via
   `diff`), but FAILed on first run with a live-leak mismatch (`got 1
   want 0`) — the `crc32` table's intentional never-freed heap block.
   Added `testdata/run/crc16.leaks` (content `1`), matching the
   existing `.leaks` golden mechanism (`for_loop_var_alias.leaks`,
   test-suite-review phase); re-ran → PASS.
3. **T2** (`scripts/test-merge.sh`) — **PASS**, 340s (~5:40) wall.
   T1 body (13 packages): PASS in 25s. `internal/selfhost`: PASS,
   125.2s. Gated native `internal/mactest` lane (`CLARUS_MAC_TESTS=1`,
   no `-run` filter, includes `TestCoreSuiteGUIOn68k`/
   `TestToolboxSuiteOn68k`): PASS, 183.8s. `internal/bake` full-corpus
   gate (`CLARUS_BAKE_FULL=1`): PASS, 6.5s.
4. **Docs**: this file, `docs/ROADMAP.md` (item 1 extended, "Where we
   are" gets its own paragraph), `docs/TODO.md` (the `cg_init_globals`
   finding filed; the array-literal entry's note extended),
   `docs/HISTORY.md` (phase entry), `CLAUDE.md` (binary-data
   paragraph), `docs/superpowers/specs/2026-08-25-transfer-crcs-design.md`
   (§4 amendment) — all committed alongside this file.

## 2. Prior phases (all merged; recap pointers only)

- **binary-files** (`filehandle`, `connection` as a value, `text`
  binary accessors + `crc16`, `string(n)`, the `toolbox/` include
  fallback, emit68k's per-function big-temp pool) — merged to `main`
  2026-08-23.
- **correctness-cleanup** — merged to `main` (ff `48a4696..3a4c054`),
  pushed 2026-08-18.
- **serial-connection** (fenced `connection` type, serial as first
  transport, both lanes, Snow-hardware-proved) — merged 2026-08-16.
- **clir-load-perf** — merged 2026-08-15/16. Both Snow gates PASSED.
- **attempt-abort** — merged 2026-08-15.
- **object-code-linker** — merged 2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Doc-hygiene note (pre-existing, not this task's job):** `attempt-abort`,
`serial-connection`, and `correctness-cleanup` are all merged to `main`
but none has its full write-up archived into `docs/HISTORY.md` yet
(HISTORY jumps from `clir-load-perf` straight to `binary-files`, with a
note explaining the gap) — a future docs pass should catch HISTORY up
through all three.

**Standing rules:** `internal/selfhost` always gets `-count=1 -timeout
30m`. Merge only on Andrew's request; main stays green (this branch
does NOT touch main).
