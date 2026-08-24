# Transfer CRCs — `text.crc16x` and `text.crc32` — design

Brainstormed with Andrew 2026-08-25. Driven by the 68kBBS project's
`docs/language-gaps.md` §8 (68kbbs repo): XMODEM/YMODEM need
CRC-16/XMODEM and ZMODEM needs CRC-32; `text.crc16` (binary-files
phase) is CRC-16/KERMIT only. Classified bounded — the flow to extend
is `crc16`'s own, end to end — and approved in-chat; this document is
the written record.

## 1. Problem

- `t.crc16(h, pos, n)` implements exactly one algorithm (CRC-16/KERMIT,
  reflected `0x8408`). XMODEM/YMODEM use poly `0x1021` **forward**
  (init 0, no final XOR, check `0x31C3` over `"123456789"`). ZMODEM's
  default framing is CRC-32 (reflected `0xEDB88320`, init and final XOR
  `0xFFFFFFFF`, check `0xCBF43926`).
- 68kBBS's `xmodem.cla` carries a bitwise `crcXmodem` workaround (128×8
  iterations per block). ZMODEM has no workaround worth writing.
- The gaps doc's stated motivation ("table-driven CRCs in the runtime's
  C/68k instead of a Clarus bit loop") rests on a false premise:
  `rtTextCrc16` is Clarus (`runtime/clarus/text.cla`), compiled by the
  same cg68k/cprint as user code. A builtin's real edge over a library
  loop is `peekb` on the dereferenced master pointer instead of a
  bounds-checked `t[i]` per byte, plus no per-byte call overhead — and,
  for `crc32`, a lookup table.

## 2. Decisions (Andrew, 2026-08-25)

1. **Two new `text` methods, same shape as `crc16`:** `t.crc16x(h, pos,
   n): int` and `t.crc32(h, pos, n): int`. Same strict bounds rule, same
   `n == 0` identity, same seed-carry chunking contract, raw register
   in and out (the caller applies CRC-32's `0xFFFFFFFF` init/final XOR,
   as it applies `crc16`'s seed today), so all three compose the same
   way.
2. **`crc32` is table-driven; `crc16x` is bitwise.** ZMODEM streams 1 KB
   subpackets back to back at 57600 bps (~180 ms apart) — a per-bit loop
   on a 16 MHz 68020 is a visible slice of that budget and a Mac Plus is
   ~3× worse. XMODEM's 128-byte blocks are cheap either way (the gaps
   doc says so itself), so `crc16x` stays a per-bit loop like `crc16`.
3. **The table is built lazily at first call, not hardcoded.** Clarus
   has no array-literal initializer (`var t: int[256]` is always
   zero-filled; `const` initializers are single literals), so a
   build-time table is not expressible today. Alternatives considered
   and rejected: a compiler-emitted constant-pool table wired to the
   intrinsic (bespoke data path in two backends, for one table); string-
   literal byte-plane smuggling (255-byte literal cap, reassembly eats
   the win). Array-literal initializers are filed in `docs/TODO.md` as
   the language feature that would make hardcoding possible — worth its
   own small phase later regardless of CRCs.
4. **`crc16` is untouched.** An earlier sketch shared one reflected
   engine between `crc16` and `crc32`; with `crc32` table-driven they no
   longer share a loop, so the hardware-proved `rtTextCrc16` stays as is.
5. **`app68Crc16` (`clarusc/app68k.cla`) is untouched.** It is the same
   CRC-16/XMODEM algorithm, but it lives in the compiler, which the
   committed `clarusc.c` bootstrap snapshot must still be able to
   compile; making it call `crc16x` would break the bootstrap until the
   snapshot is regenerated. Not worth the coupling for a 124-byte header.

## 3. API (reference `### Text` additions)

- `t.crc16x(h, pos, n)` — folds bytes `[pos, pos+n)` into running CRC
  `h` (masked to 16 bits) and returns the updated value; `n == 0`
  returns `h` unchanged. CRC-16/XMODEM: poly `0x1021` forward
  (MSB-first, no reflection), seed and result taken as-is, no final XOR.
  Check value: `t.crc16x(0, 0, 9)` over `"123456789"` is `0x31C3`.
  Chunkable like `crc16`.
- `t.crc32(h, pos, n)` — folds bytes `[pos, pos+n)` into running CRC
  register `h` (all 32 bits) and returns the updated register; `n == 0`
  returns `h` unchanged. CRC-32 (IEEE / ZMODEM / zip): reflected poly
  `0xEDB88320`. The register is returned **raw**: the caller supplies
  the `0xFFFFFFFF` init seed and applies the final XOR, so the standard
  check is `t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF == 0xCBF43926` over
  `"123456789"`. The result is an ordinary 32-bit `int`: a register with
  bit 31 set reads as negative (`0xCBF43926` is `-873187034`); hex
  literals above `0x7FFFFFFF` are accepted and wrap the same way, so
  comparisons against published check values work as written.
  Chunkable like `crc16`.
- Both use the STRICT out-of-range rule shared by `intAt`/`hashStep`/
  `crc16` (`pos < 0 or n < 0 or pos > t.length - n` → runtime error
  "text index out of range"), checked before the `n == 0` early return.

## 4. Runtime (`runtime/clarus/text.cla`)

- `rtTextCrc16X(t: ptr, h: int, pos: int, n: int): int` — `rtTextCrc16`'s
  skeleton (bounds check, `crc = h & 0xFFFF`, `n == 0` return, master-
  pointer deref, `peekb` per byte) with `app68Crc16`'s forward inner
  loop: `crc = crc ^ (b << 8)`, then 8× `crc = (crc & 0x8000) != 0 ?
  ((crc << 1) ^ 0x1021) & 0xFFFF : (crc << 1) & 0xFFFF`.
- `rtTextCrc32(t: ptr, h: int, pos: int, n: int): int` — same skeleton,
  `crc = h` (no mask — the full 32-bit register), then per byte
  `crc = rtCrc32Tab[(crc ^ b) & 0xFF] ^ ((crc >> 8) & 0x00FFFFFF)`.
  The `& 0x00FFFFFF` after the shift is load-bearing: `>>` is
  arithmetic in Clarus and the register routinely has bit 31 set.
- Table: `var rtCrc32Tab: ptr` (top-level in `text.cla`, `ptr(0)` until
  built). `rtTextCrc32` calls `rtCrc32TabInit()` when it is still
  `ptr(0)`: `TextNewPtr(1024)` (nil → `rtPanic("out of memory")`, the
  same check text.cla's other TextNewPtr sites make), then for `i` in
  0..255, `c = i`, 8× `c = (c & 1) == 1 ? ((c >> 1) & 0x7FFFFFFF) ^
  0xEDB88320 : (c >> 1) & 0x7FFFFFFF`, `pokel(p + i * 4, c)`; the
  per-byte lookup is `peekl(rtCrc32Tab + ((crc ^ b) & 0xFF) * 4)`. ~2K
  iterations, once per process. **Amended 2026-08-25 during Task 1:**
  the original design was an `int[256]` global + `bool` flag; cg68k's
  `cg_init_globals` unrolls a global array's default-init into one
  store per element, so that cost ~1.5 KB of startup code in EVERY
  native program (not just crc32 callers) and pushed 8 previously
  single-segment cg68k fixtures into a second segment. A heap block
  costs one 4-byte global; the 1 KB lives only in programs that call
  `crc32`. `ponytail:` comment on the table names the ceiling and the
  upgrade path (array-literal initializer, `docs/TODO.md`).
- Known cost, accepted: shake prunes unreachable *functions*, not
  globals, so the 4-byte table pointer lands in every program's data
  segment whether or not it calls `crc32`; the 1 KB table itself is
  allocated only by programs that do.
- Consequence found while planning (2026-08-25): runtime globals are
  laid out in module splice order and `text.cla` is spliced third, so
  the two new globals shift every later global's A5 offset in every
  cg68k golden (and add two `static` declarations to every emitui C
  golden). That is one planned rebless wave with a normalization-diff
  proof (plan, Task 1) — a process cost, not a design change. A
  usage-gated `crc.cla` module was considered and rejected: the 68k lane
  splices every runtime module unconditionally for the bake's fixed
  layout, so gating would not avoid the shift there and would add a
  `bake.cla` change (and its standing 55-minute Snow rerun). A per-call
  stack-local table (no globals) was rejected: 1 KB of stack per call on
  an 8 KB Mac Plus stack, and the 2K-iteration rebuild per call erases
  most of the win for 1 KB blocks.

## 5. Compiler (mechanical, `crc16` as the template)

| File | Change |
|---|---|
| `clarusc/ir.cla` | `ITextCrc16X()` (`"text_crc16x"`), `ITextCrc32()` (`"text_crc32"`), index vars + the reset-to-`-1` lines |
| `clarusc/check.cla` | `textOnlyMethods["crc16x"]`/`["crc32"]` = `(int,int,int) -> int` |
| `clarusc/lower.cla` | two arms beside `crc16`, `lowMethodArgs4` |
| `clarusc/shake.cla` | `rtTextCrc16X`/`rtTextCrc32` roots (the table-init helper is reached transitively) |
| `clarusc/cg68k.cla` | `rnTextCrc16X`/`rnTextCrc32` interns + `cgIntr4` arms |
| `clarusc/cprint.cla` | two arms beside `ITextCrc16()`'s |
| `clarusc/clarusc.c` | regenerated snapshot (`TestSnapshotFixedPoint` prints the recipe) |

## 6. Tests

- `testdata/run/crc16.cla` (+ `.behavior`, reblessed) grows the two
  new vectors, chunked equality, and `n == 0` identity for each — one
  fixture for all three CRCs rather than two more files.
- `testsuite/core/cases_textbinary.cla`'s `caseCrc16` grows the same
  assertions (distinct `tkFail` details per algorithm). No new
  `CoreTest` enum member — the case-count constants in `runner.cla`,
  `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`,
  `internal/bake/bakeidentity_test.go`, and `CLAUDE.md` stay put. The
  native `TestCoreSuiteGUIOn68k` lane is the hardware proof.
- Gates: T1 `--smoke` per task (runtime + clarusc touched); T2 before
  merge.
- Manual, recorded in the HISTORY entry, not a gated test: a 64 KB
  timing loop on Snow comparing `crc32` (table) against `crc16` (bitwise)
  so the "table pays off" claim has a number behind it.

## 7. Docs and follow-ups

- Reference `### Text`: the two bullets in §3, plus `crc16x`/`crc32`
  added to the "STRICT out-of-range rule" sentence.
- `docs/TODO.md`: array-literal initializers (filed with this spec).
- Close-out per convention: STATUS, ROADMAP, HISTORY, CLAUDE.md's
  binary-data paragraph.
- 68kbbs repo (after the next toolchain pin, not this phase): update
  `docs/language-gaps.md` §8 (fix the "runtime's C/68k" premise, mark
  shipped) and replace `crcXmodem` with `t.crc16x(0, 0, n)`.

## 8. Out of scope

- Table-driven `crc16`/`crc16x`; a generic `t.crc(h, pos, n, poly,
  reflected)`; hardcoded tables (blocked on the TODO feature);
  reflected-input/output variants beyond the three named algorithms.
