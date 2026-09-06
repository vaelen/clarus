# AppleTalk phase — Task 6 report: `toolbox/appletalk.cla` + `AtalkSelf`

Date: 2026-09-07. Worktree `/Users/andrew/repos/clarus-wt/t6`, branch
`appletalk-t6`, base `8c07654`. One commit: **`f37db16`**
`feat(toolbox): AppleTalk catalog (.MPP/.ATP/.XPP/.DSP), hardware-proved by AtalkSelf`.

## What was implemented

### `toolbox/appletalk.cla` (new, 583 lines)

Every item the brief lists, each with a provenance comment citing the
CR-reflowed `CIncludes` line number plus the Inside Macintosh source.
All numbers were re-verified against the headers as they were written
(`LC_ALL=C tr '\r' '\n' < AppleTalk.h | /usr/bin/grep -na …`); none of
the brief's values turned out wrong.

- `external func PBControlAsync(paramBlock: ptr): int = trap 0xA404 reg`
  — the one new trap (Devices.h:1307-1310). `PBOpenSync`/`PBControlSync`/
  `PBStatusSync`/`PBKillIOSync` are deliberately NOT redeclared; the
  header comment says to compose `toolbox/devices.cla` alongside.
- Driver refNums `mppRefNum -10` / `atpRefNum -11` / `xppRefNum -41`
  (AppleTalk.h:60-62). The `.MPP`/`.ATP`/`.XPP`/`.DSP` name strings are
  documented in prose, not declared as `const string` — the same
  discipline `toolbox/serial.cla` uses for its four serial driver names
  (they are IM prose convention, not header symbols).
- csCodes: 9 `.MPP`, 12 `.ATP`, `xCall` + 3 ZIP sub-codes, 15 ADSP.
- Flags/sizes: 5 `atp*value`, `atpMaxData/atpMaxNum/bdsEntrySz`, 4 `oc*`,
  6 `s*` states, 4 `e*` event flags, `attnBufSize`, `minDSPQueueSize`,
  `ccbSize`.
- 28 error codes, all from `MacErrors.h` with line numbers.
- Extern records: `NBPParam`, `NBPRegParam`, `NBPLookupParam`,
  `ATPParam`, `XCallParam`, `DSPParam`, `BDSElement`.
- The full offset table (49 constants): `pb*`, `nbp*`, `atp*`, `dsp*`,
  `ccb*`, `nte*`, `tuple*`.

The header block states the three rules Task 1 paid for — the 52-byte
floor, the never-reuse-a-block-without-re-zeroing rule (Amendment 2, the
one that hung the Mac three times), and NBP's copy-your-socket-verbatim
behaviour (Amendment 1) — plus the two facts a runtime author needs
(Amendment 4's free self-address, and that the ROM `.MPP` has no
`setSelfSend` and answers no self-lookup).

**Two deviations from the brief's interface list, both deliberate:**

1. **`NBPParam` was split into three records**, not one. `extern record`
   has no union and its `pad[N]` runs are not writable, so a single
   44-byte `NBPParam` with a trailing `pad[10]` cannot set `verifyFlag`
   or read `numGotten` at all — a caller would have to abandon the
   record and go back to `NewPtrClear` + poke. The split follows
   `toolbox/devices.cla`'s own documented house style (`CntrlReset` /
   `CntrlCount` / `CntrlSetBuf`, one record per csCode payload shape):
   `NBPParam` (remove/kill, fields through `entityPtr`@30),
   `NBPRegParam` (adds `verifyFlag`@34), `NBPLookupParam` (adds
   `retBuffPtr`@34 / `retBuffSize`@38 / `maxToGet`@40 / `numGotten`@42).
   All three are 52 bytes. The brief's offset constants are all still
   declared verbatim — Task 9's `NewPtrClear`-allocated async blocks
   consume those, not the records.
2. **`toolbox/memory.cla` gained one line:**
   `external func NewPtrClear(byteCount: int): ptr = trap 0xA31E reg`
   (MacMemory.h:580-583, AIncludes/MacMemory.a:561), with its own
   provenance entry in that file's header block. Every AppleTalk
   parameter block, NTE and ADSP CCB must start out zeroed; the Memory
   Manager's own clear variant belongs in the Memory Manager's catalog
   file, not in `appletalk.cla` (a second declaration of the same extern
   name in one build is the hazard `devices.cla`'s header warns about).
   The runtime's own `NatNewPtr` uses the same trap under a different
   name, so there is no collision. `NewHandleClear` was NOT added —
   nothing needs it yet.

### `testsuite/toolbox/cases_atalk.cla` (new) — the `AtalkSelf` case

Asserts **every row** of `task-1-report.md`'s Amendment 3 table and
nothing that was not observed on real hardware:

| step | assertion |
|---|---|
| 1 | `PBOpenSync(".MPP")` → err 0 **and** refNum == `mppRefNum` (-10) |
| 2 | `registerName`, `interval` 8 / `count` 3 / `verifyFlag` 1 → err 0 |
| 3 | `nteAddress` net == 0 and node in 1..254 (range, never a fixed node) |
| 4 | `lookupName` for `=:ClarusNoSuch@*` → err 0 **and** `numGotten` == 0 |
| 5 | `removeName` (entity at NTE+9) → err 0 |
| 6 | `PBOpenSync(".ATP")` → err 0 **and** refNum == `atpRefNum` (-11) |
| 7 | `openATPSkt` with `atpSocket` 0 → err 0 and socket in 128..254 |
| 8 | `closeATPSkt` → err 0 |

No self-lookup, no `setSelfSend`, no ATP self-transaction, and `.XPP` /
`.DSP` are not opened — all four are unavailable on this boot disk, and
the case's header comment records why in full. Each call uses a FRESH
zero-initialized extern-record local (Rule 2 satisfied by construction);
the NTE and lookup buffers are `NewPtrClear` + `pokeb`, built with a
local `atPStr` helper that returns the end pointer so three calls build
the packed object/type/zone entity. The socket byte at NTE+7 is left 0
with a comment saying a real service must not.

### Bookkeeping

All five count sites plus the two lists and the catalog check:
`runner.cla` (enum member after `SerialOpenWrite`, `nTbCases` 38→39,
`tbCaseName` arm, `tbAllCases` add, dispatch block, plus a paragraph in
its case-inventory header comment), `tests/mactest/toolbox_68k.sh`
(literal + the "each of the 38" doc line), `toolbox_jiggle.sh`,
`toolbox_mac.sh`, `CLAUDE.md` (the `39 = 38 real + SelfCheck` sentence
and the "then to 38 real by the AppleTalk phase's `AtalkSelf`" clause;
also added `appletalk` to the `toolbox/{…}.cla` catalog list),
`tests/mactest/toolbox_files.txt` (`toolbox/appletalk.cla` after
`toolbox/serial.cla`, `cases_atalk.cla` after `cases_serial.cla`), and
`tests/testsuite/catalog.sh`'s file list.

### One extra fix that was NOT in the brief: the suite's settle budget

`tests/mactest/toolbox_68k.sh`'s `run_mac … 300` and
`toolbox_mac.sh`'s `run_mac "$bin" 300` were raised to **420**, with a
comment explaining why. This was forced, not cosmetic — see below.

## Tests and results

- `make test T=testsuite/catalog` → **PASS** (`catalog` and
  `catalog_ui`). Verified the file is really being parsed by appending a
  garbage line and watching it fail with
  `toolbox/appletalk.cla:584:1: expected declaration, found identifier`,
  then reverting.
- `make -j t1` → **89 passed, 30 skipped, 0 failed**.
- `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k` →
  **`PASS mactest/toolbox_68k 303s`**, 39 `PASS` lines and zero `FAIL`
  lines in `build-run/tests/mactest/toolbox_68k.log`, including:

  ```
  PASS AtalkSelf
  ```

  `suite_report_check` additionally asserts, and passed,
  `grep -qx "TOTAL 39 PASS 39 FAIL 0"` against the capture — the test
  cannot pass without that exact line.

Per instructions, perfgate and `--smoke` were not run (controller's job
on the merged tree).

## The one real problem hit, and how it was diagnosed

The first `toolbox_68k` boot **timed out at 300 s with an empty
capture**. The diagnosis chain, in order:

1. A standalone `build-68k.sh` probe replicating the case's exact
   sequence against the same catalog, bisected into 7 cumulative stages
   (open `.MPP` → register → lookup → remove → open `.ATP` → openATPSkt
   → closeATPSkt). **Every stage exited 0**, stage 2 in 6.7 s wall and
   stage 3 in 9.7 s — exactly the ~3.2 s per NBP retry budget Task 1
   measured. So the AppleTalk sequence itself is sound.
2. A second probe ran `SerialOpenWrite`'s whole serial sequence and then
   the AppleTalk sequence in one program, to rule out an SCC
   interaction. Exit 0.
3. Rebuilt the suite with `caseAtalkSelf` stubbed to an immediate
   `tkPass`. **Still hung.**
4. `git stash -u` and booted the pristine baseline suite by hand with a
   200 s cap: also "hung". Then ran the real
   `CLARUS_MAC_TESTS=1 make test T=mactest/toolbox_68k` on that same
   pristine tree: **`PASS mactest/toolbox_68k 287s`**.

So the toolbox suite was already spending **287 s of its 300 s
budget** before this phase, and my hand-run caps of 90/120/200 s were
simply below that floor. `AtalkSelf` adds ~6.5 s of irreducible real
NBP time (`registerName` with verification and `lookupName` each run
their full retry budget regardless of how fast an answer arrives —
task-1-report.md P2), which pushed the total past 300. Raising the
settle to 420 s fixed it; the script's own `# timeout: 20m` header gives
plenty of room.

`toolbox_jiggle.sh` already used a 900 s settle and needed no change.

## Self-review findings

A scripted audit (re-run at the end) confirms:

- **All 143 brief-mandated constants present**, every one with a
  provenance comment, and **zero value mismatches** against the brief's
  own table (checked programmatically, name by name).
- **Record layouts recomputed from the declarations** with the language
  reference's packing rules and compared field by field against the
  headers: `NBPParam` / `NBPRegParam` / `NBPLookupParam` **52** bytes,
  `ATPParam` **56**, `XCallParam` **112**, `DSPParam` **68** — every
  parameter block at or above the 52-byte floor. `BDSElement` is **12**,
  the one deliberate exception (it is a BDS array element, not a
  parameter block; its size is fixed by the wire contract and its
  comment says so).
- Every offset constant equals the offset its corresponding record field
  actually lands on.
- Both new `.cla` files are pure ASCII (`LC_ALL=C grep -P '[\x80-\xff]'`
  clean), so the Edit-tool MacRoman hazard did not apply; `runner.cla`,
  `CLAUDE.md` and the three shell scripts were edited with byte-exact
  Python/`sed` rewrites anyway, and `CLAUDE.md`'s two non-ASCII bytes
  survive untouched.
- No stray emulator processes; all scratch builds
  (`build-68k/AtP*`, `build-run/tb*.bin`) deleted.

## Concerns / notes for the controller

1. **`XCallParam`, `DSPParam` and `BDSElement` are check-compiled only.**
   Nothing in this phase can boot `.XPP` or `.DSP` (both are `-43` on the
   LaunchAPPL disk, Amendment 6), so their layouts rest on the header
   transcription alone. Tasks 9/11 should treat the first real ADSP boot
   as the point where those get proved.
2. **The suite's wall clock is now the binding constraint on new toolbox
   cases.** 303 s of a 420 s budget. Anything that adds another minute
   of real hardware time needs another look at that number, or the suite
   needs a way to run long cases separately.
3. `killAllGetReq` is declared but its comment tells callers not to use
   it (`-17` on the ROM `.ATP`, per Task 1 P3b) and to use `PBKillIOSync`
   instead. Worth re-testing if Tasks 9/11 ever get the AppleTalk System
   file onto the boot disk.
4. The `NBPParam` three-way split (above) is a real interface change from
   the brief that Task 9's author should know about before they write
   `atalk_68k.cla` — though Task 9 was always going to use the offset
   constants, which are unchanged.

---

# Fix round 1 (review: Needs fixes, 2 Important + 6 minors)

Commit **`0160464`** `fix(toolbox): cprint NewPtrClear shim, catalog bind-check, AppleTalk citation fixes`.

## Important 1 — cprint lane could not link `NewPtrClear`

`runtime/mac/rt_ext_mac.inc`, right after `rt_ext_NewPtr` (:50):

```c
/* appletalk: toolbox/memory.cla declares NewPtrClear (0xA31E) and
   testsuite/toolbox's AtalkSelf case calls it; cprint emits one
   rt_ext_<Name> call per extern, so it needs its own shim here or the
   toolbox_mac.sh lane fails to link (same failure mode as
   rt_ext_TbFreeMem above). */
void *rt_ext_NewPtrClear(int32_t size) { return (void *)NewPtrClear((Size)size); }
```

Finding accepted as stated — my diff bumped `toolbox_mac.sh` to 39/420
while leaving that lane unlinkable.

## Important 2 — `catalog.sh` did not bind-check the new catalog

Accepted: adding the file to the list only proved it *parses*. The
driver heredoc now declares `np: NBPLookupParam`, `xp: XCallParam`,
`dp: DSPParam`, `bd: BDSElement`, writes a field on each (so the layouts
are actually computed), calls `PBControlAsync(np)`, and folds
`registerName + nteSize + ccbSize + atpMaxData + nbpDuplicate` into `t0`.
`XCallParam` / `DSPParam` / `BDSElement` — the three records nothing can
boot this phase — now get their offsets computed in T1, which closes part
of Concern 1 from the first report.

## Minors, all applied

| # | fix |
|---|---|
| a | Five struct ranges re-read from the reflowed headers and corrected: `atpSize` `AppleTalk.h:189`, `struct EntityName` `:312-316`, `AddrBlock` `:319-323`, `DSPParamBlock` `ADSP.h:193-216`, `TRCCB` `ADSP.h:105-116`. `ADSP.h:124-217` (the variant-arm block) was also wrong and is now `:124-216`. |
| b | `atpMaxData`'s note now says outright that 578 is **not** a header symbol under any name, that IM II ch. 10 is the source, and that `AppleTalk.h:780` is only indirect corroboration (XCallParam's ZIP-buffer comment reads 578 precisely because a ZIP reply is one ATP response). The `const` line's own comment no longer cites :780. |
| c | `toolbox_jiggle.sh:18` "vs the plain suite's 5m" → 7m. |
| d | `CLAUDE.md`'s catalog list reworded to "`standardfile`/`files` added by pack3-standardfile, `appletalk` by the AppleTalk phase". |
| e | `maxToGet` 16 → **8**, with the arithmetic in a comment: a reply tuple is AddrBlock(4) + enumerator(1) + three packed Pascal strings ≤ 104 bytes, so 8 × 104 = 832 fits the 1024-byte buffer and 16 (1664) would not. |
| f | Applied rather than waived: the object name is now `"AtalkSelf-" + string(TickCount() mod 10000)` (`TickCount` from `toolbox/events.cla`, the same trap `cases_catalog.cla` uses), with a comment saying a fixed name only collides when two suite boots share one LocalTalk net — which Task 11's two-emulator harness is about to make possible, and where `verifyFlag` would then fail the case with `nbpDuplicate`. |

(While applying (f): Clarus spells remainder `mod`, not `%` — the first
attempt failed to compile and was fixed before any test ran.)

## Tests run, and why the boot WAS needed after all

- `make test T=testsuite/catalog` → **PASS** (`catalog`, `catalog_ui`).
- `make test T=testsuite/` → **4 passed, 0 skipped, 0 failed**.
- `make -j t1` → **89 passed, 30 skipped, 0 failed**.
- `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k` →
  **`PASS mactest/toolbox_68k 304s`**, `PASS AtalkSelf`, 39 `PASS` lines,
  zero `FAIL`, `TOTAL 39 PASS 39 FAIL 0` asserted by
  `suite_report_check`.

The dispatch said not to boot unless a change touches what the suite
executes on the native lane. The two Important fixes indeed do not (the
shim is cprint-only, `catalog.sh` is a host check-compile) — **but
minors (e) and (f) do**: they change `caseAtalkSelf`'s own executed
code, its NBP `maxToGet` argument and the object name it registers. A
new registered name with `verifyFlag` on is exactly the call that
returns `nbpDuplicate` when it goes wrong, so it was booted rather than
assumed. No emulator ran for the Important fixes alone.

No stray emulator processes; no new scratch artifacts.

## Concerns after this round

Unchanged from the first report except that Concern 1 is now partly
addressed: `XCallParam`/`DSPParam`/`BDSElement` are bind-checked (layouts
computed) in T1, though still never executed against real `.XPP`/`.DSP`
hardware — that remains Tasks 9/11's first ADSP boot.
