# Binary Files Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the eight 68kBBS language gaps in one phase: a value-typed `filehandle` with positioned I/O on both lanes; `connection` re-represented as a value so params/locals/fields work; `text` LE/word/setter accessors + `crc16`; `string(n)`; the `toolbox/` include fallback; and the removal of emit68k's per-statement big-temp ceiling.

**Architecture:** A hardware probe first settles the one trap-level unknown (`PBGetEOFSync` under a busy heap) and verifies the File Manager trap words the catalog gains. Then, feature by feature rather than layer by layer (each task leaves a working, tested surface): catalog fill; the `text`/`string(n)` helpers end to end on both lanes (shared `text.cla`/`str.cla` routines, intrinsic arms in both backends); `connection` as an int value; `filehandle` surface + shared runtime + host glue (`fileh.cla`/`fileh_c.cla`/`rt_fileh.inc`); the native lane (`fileh_68k.cla`, superset splice, bake list, cprint-Mac stub); the include fallback; the per-function big-temp pool (the phase's ONE planned golden rebless wave — frame sizes change everywhere); a vDB-shaped acceptance program on Snow; close-out.

**Tech Stack:** Clarus (`clarusc/*.cla` compiler, `runtime/clarus/*.cla` runtime), C host glue (`runtime/host/*.inc`), Go test harness (`internal/*`), Mini vMac (suite lane, System 6) and Snow (System 7 Mac II, `--serial-bridge-a`) emulators, Universal Interfaces (`Retro68/InterfacesAndLibraries`) as the sole trap-verification source.

**Spec:** `docs/superpowers/specs/2026-08-22-binary-files-design.md` — read it first; every task below argues from it.

## Global Constraints

- Branch: all work on `binary-files` (already created from `main`; the spec is its first two commits). Merge only on Andrew's explicit request; `main` stays green.
- SDD ledger: `.superpowers/sdd/2026-08-22-binary-files/` (`progress.md` + per-task reports). Never delete it (project memory rule: SDD workspaces are phase records).
- After every task: `scripts/test-task.sh --smoke` (every task here touches `runtime/` or `clarusc/`; `--smoke` is mandatory per CLAUDE.md). Go tests always `-count=1`. `internal/selfhost` only at phase close, `-count=1 -timeout 30m`.
- Emulator-gated tests need `CLARUS_MAC_TESTS=1`. Snow-gated (`CLARUS_SNOW_TESTS=1`) only where a task says so; the standing `TestClarusCBakePathOnSnow` rerun (~55 min) happens once, at phase close, controller-run.
- Trap words and PB field offsets are NEVER trusted from memory or this plan: verify each against `Retro68/InterfacesAndLibraries/CIncludes/Files.h` (corroborate `AIncludes/Files.a`), decoding inline words per `toolbox/files.cla`'s provenance-comment convention (`files.cla:58-97` is the model block). Values here are labeled *expected*; Task 1 and the headers are authoritative.
- Before editing any `.cla` file, check for non-ASCII bytes (`LC_ALL=C grep -nP '[\x80-\xff]' FILE`); if any, do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (project memory rule).
- Golden policy: Tasks 2–7 are expected to produce ZERO golden churn (new runtime routines are tree-shaken out of programs that don't call them; `fileh*.cla` has no globals, so no runtime-global renumbering; `conn.cla`'s pump chain is untouched). If a golden churns in Tasks 2–7, STOP and explain the churn in the task report before touching it — it must be one of: a fixture that now exercises the new surface, or an unavoidable consequence you can name. Task 8 is the ONE PLANNED rebless wave (every function's frame size changes); rebless there only with a normalization-diff proof.
- reftest: new ```` ```rust ```` fences in the reference shift every later fence's `Index`; `internal/reftest/manifest.go` may go red mid-branch and its regeneration is ALWAYS the branch's final step (Task 10), per ROADMAP's process conventions.
- Counts drift: `testsuite/core/runner.cla`'s `nCoreCases` + `SelfCheck`, `internal/mactest/coresuite_test.go:34`'s `wantCoreSuiteCases`, `internal/mactest/suite_host_test.go:88-119`'s `coreCLIFiles`, and `internal/bake/bakeidentity_test.go:1284-1316`'s `coreSuiteGUIFiles` must ALL move together every time a `cases_*.cla` file or case is added (commit `0907364` is the drift lesson). Read the CURRENT literals before editing; trust the files, not this plan's numbers.
- Subagent models: `sonnet` for implementation and review tasks, `haiku` only for mechanical batch edits, `opus` for a hard debugging detour; never Fable. State each subagent's model at dispatch.
- Commit after every task (prefix `feat:`/`fix:`/`test:`/`docs:`).

## File map (who owns what)

- `toolbox/files.cla` — GetEOF/SetEOF/GetFPos/SetFPos/FlushFile/FlushVol/Allocate traps (Task 2). `testsuite/toolbox/cases_catalog.cla` — hardware proof (Task 2). `internal/testsuite/catalog_test.go` — driver symbol (Task 2).
- `runtime/clarus/text.cla` — `rtTextIntAtLE/WordAt/WordAtLE/SetIntAt/SetIntAtLE/SetWordAt/SetWordAtLE/Crc16` (Task 3). `runtime/clarus/str.cla` — `rtIntToStr` (Task 3).
- `clarusc/ir.cla` (intrinsic accessors), `clarusc/check.cla` (tables, `cnString`, conversion), `clarusc/lower.cla` (arms), `clarusc/cprint.cla` + `clarusc/cg68k.cla` (backend arms) — Task 3; `clarusc/types.cla` + `check.cla` + `lower.cla` again for `filehandle` (Task 5) and `connection` (Task 4).
- `runtime/clarus/conn.cla`, `conn_c.cla`, `conn_68k.cla` — 1-based handle entry points (Task 4). `internal/conntest/` — param-receiver echo variant, shadow-test flip (Task 4).
- `runtime/clarus/fileh.cla` (new, shared), `fileh_c.cla` (new, host), `runtime/host/rt_fileh.inc` (new) + `rt.c` include line (Task 5); `fileh_68k.cla` (new, native), `runtime/mac/` cprint-lane stub (Task 6).
- `clarusc/drive.cla` — splice gate (Task 5 host, Task 6 68k) and include fallback (Task 7). `clarusc/bake.cla` + `internal/bake/bake_test.go` — module list/counts (Task 6).
- `testsuite/core/cases_textbinary.cla` (new: `TextBinary`, `Crc16`, `IntToStr` — Task 3), `testsuite/core/cases_fileh.cla` (new: `FileHandleRW` — Task 5), `testsuite/core/runner.cla`, `testsuite/kit.cla` (Tasks 3, 5, 8).
- `testdata/run`, `testdata/runerr`, `testdata/errors` fixtures (Tasks 3–5, 8). `testdata/cg68k/*.s` (Task 8 rebless).
- `internal/lowlevel/rtinc_test.go` + `testdata/rtinc/` — include fallback test (Task 7).
- `examples/pagefile.cla` (new) + `internal/mactest/pagefile_snow_test.go` (new) — acceptance (Task 9).
- `docs/clarus-language-reference.md` (every surface task), `docs/clarus-toolbox-cookbook.md` (Task 2), `clarusc/clarusc.c`, `STATUS.md`, `docs/ROADMAP.md`, `docs/TODO.md`, `CLAUDE.md` (Task 10).

---

### Task 1: Probe wave — `PBGetEOFSync` under a busy heap + trap-word verification (NO tree commits)

Per the established probe pattern (serial Task 1): everything here is throwaway; the deliverable is a report + amendments to Tasks 2–6. `native.cla:135-138` and `:915-932` document that `PBGetEOFSync` hung real hardware 100% reproducibly once the heap had prior List/Map/Text traffic — never in isolation. `size()` needs an EOF query; `append`/`writeAt` are designed not to.

**Files:**
- Create (scratch, reverted before finishing): a temporary `testsuite/toolbox/cases_probe.cla` + temporary `runner.cla` registration (the toolbox suite boot IS the busy heap — 31 real cases run before yours if you register it last).
- Read: `runtime/clarus/native.cla:907-1016` (the hang trail, `natFileReadCap` chunk loop), `runtime/clarus/conn_68k.cla:108-236` (extern-record PB idiom: `var pb: IOParam` local, direct field writes, `rtConn68kName` for `ioNamePtr`), `toolbox/files.cla:167-184` (`IOParam` fields), `Retro68/InterfacesAndLibraries/CIncludes/Files.h`.

**Interfaces:**
- Produces: `.superpowers/sdd/2026-08-22-binary-files/task-1-report.md` with (a) the VERIFIED trap table for Task 2, (b) which EOF query survives the busy heap, (c) whether `_Write` at `fsFromStart` past EOF extends the file and whether `_Read` past EOF returns `eofErr` with a short `ioActCount`, (d) amendments.

- [ ] **Step 1: Transcribe the candidate trap set from Universal Interfaces**

Record with header line numbers: `PBGetEOFSync` (expected 0xA011), `PBSetEOFSync` (0xA012), `PBGetFPosSync` (0xA018), `PBSetFPosSync` (0xA044), `PBFlushFileSync` (0xA045), `PBFlushVolSync` (0xA013), `PBAllocateSync` (0xA010), plus confirm `PBOpenSync` (0xA000)/`PBReadSync` (0xA002)/`PBWriteSync` (0xA003)/`PBCloseSync` (0xA001)/`PBCreateSync` (0xA008) already in `toolbox/devices.cla`/`files.cla`. Record the `IOParam` offsets used for positioned I/O (`ioPosMode` @44:2, `ioPosOffset` @46:4, `ioMisc` @28:4 — `ioMisc` carries the new EOF for SetEOF and receives the EOF for GetEOF; `ioPosMode` constants `fsAtMark 0`/`fsFromStart 1`/`fsFromLEOF 2`/`fsFromMark 3`), and for `PBGetFPosSync`/`PBSetFPosSync` which field carries the position (expected `ioPosOffset`). All values go in the report as the verified table.

- [ ] **Step 2: Write the throwaway probe case**

`testsuite/toolbox/cases_probe.cla`, registered LAST in `runner.cla`'s dispatch so every other case's heap traffic precedes it. The case: create a scratch file (`PBCreateSync` + `PBOpenSync`, `IOParam` locals per `conn_68k.cla`'s idiom), `PBWriteSync` 1024 bytes at `fsFromStart` offset 0, then: (1) `PBGetEOFSync` → expect `ioMisc == 1024`; (2) `PBSetFPosSync(fsFromLEOF, 0)` then `PBGetFPosSync` → expect 1024; (3) `PBWriteSync` 16 bytes at `fsFromStart` offset 2048 → then query EOF again → expect 2064 (write past EOF extends); (4) `PBReadSync` 100 bytes at `fsFromStart` 2000 → expect `ioActCount == 64` and result `eofErr` (-39); (5) `PBSetEOFSync` to 512 → EOF query → 512; (6) `PBFlushFileSync` + `PBFlushVolSync` → 0; close. Report each step's OSErr and value via `tkFail` detail strings even on success (so the log carries the numbers). Do steps 1 and 2 as SEPARATE sub-probes guarded so a hang in (1) can be isolated: run once with (1) enabled, once with (1) replaced by (2) only.

- [ ] **Step 3: Boot it on the Mini vMac lane, twice**

`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -v` (after bumping the toolbox TOTAL literal in `coresuite_test.go` temporarily). Expected: either PASS with the numbers, or a hang on the GetEOF sub-probe — a hang is a RESULT, not a failure of the probe. If `PBGetEOFSync` hangs, the SetFPos/GetFPos pair is the `size()` implementation; if both hang, `size()` becomes "track EOF in the runtime from `open` (GetEOF once, right after open, before any heap traffic) + every write/setSize" — record which.

- [ ] **Step 4: Write the report, revert, no commits**

Report per the Interfaces block; amendments to Task 2 (trap list) and Task 6 (`rtFhDevSize` implementation choice, extension semantics). `git checkout -- testsuite/ internal/mactest/` and delete `cases_probe.cla`. `git status` must be clean.

---

### Task 2: Toolbox catalog — File Manager positioned-I/O traps, hardware-proved

**Files:**
- Modify: `toolbox/files.cla` (append after `PBCloseSync` at `:189`), `testsuite/toolbox/cases_catalog.cla` (the `Catalog` case — read it first; it hardware-proves the catalog), `internal/testsuite/catalog_test.go:50-126` (`catalogDriver` — one reference line per new symbol so check-proof covers it), `docs/clarus-toolbox-cookbook.md` (a short §11 "positioned file I/O in the param block" walkthrough: `ioPosMode`/`ioPosOffset`/`ioMisc` — 30–40 lines, with the verified citations).
- Read first: `toolbox/files.cla:58-97` (provenance block model), Task 1's verified table.

**Interfaces:**
- Produces: `external func PBGetEOFSync(paramBlock: ptr): int = trap 0xA011 reg`, `PBSetEOFSync` (0xA012), `PBGetFPosSync` (0xA018), `PBSetFPosSync` (0xA044), `PBFlushFileSync` (0xA045), `PBFlushVolSync` (0xA013), `PBAllocateSync` (0xA010) — all OS/register convention like `PBWriteSync`; `const fsAtMark: int = 0`, `fsFromStart = 1`, `fsFromLEOF = 2`, `fsFromMark = 3`; `const fsRdWrPerm: int = 3` (verify `fsCurPerm 0`/`fsRdPerm 1`/`fsWrPerm 2`/`fsRdWrPerm 3` in Files.h). `IOParam` already has `ioMisc`/`ioPosMode`/`ioPosOffset` (`files.cla:167-184`) — confirm the field names; do not redeclare the record (devices.cla's header `:21-39` explains the single-declaration rule).
- Consumed by: `fileh_68k.cla` (Task 6), `cases_catalog.cla` below.

- [ ] **Step 1: Append the traps + constants to `toolbox/files.cla`** with a full provenance block each (header file + lines, the `#pragma parameter`/`ONEWORDINLINE` quote, bit-11 reasoning, `AIncludes/Files.a` OPWORD corroboration).

- [ ] **Step 2: Extend the `Catalog` toolbox-suite case** with a sub-proof: create+open a scratch file, `PBWriteSync` 64 bytes at `fsFromStart` 0, EOF-query via whichever Task 1 chose, assert 64, `PBSetEOFSync` 32, re-query 32, `PBFlushFileSync`, close. Keep it after the existing sub-proofs.

- [ ] **Step 3: Catalog check + hardware proof**

Run: `go test ./internal/testsuite -run TestCatalog -count=1 -v` → PASS. Then `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -v` → PASS with `Catalog` green.

- [ ] **Step 4: Cookbook §11, T1, commit**

Run: `scripts/test-task.sh --smoke` → PASS, zero churn.
```bash
git add toolbox/files.cla testsuite/toolbox/cases_catalog.cla internal/testsuite/catalog_test.go docs/clarus-toolbox-cookbook.md
git commit -m "feat: File Manager positioned-I/O traps in toolbox/files.cla, hardware-proved by the Catalog case"
```

---

### Task 3: `text` binary accessors, `crc16`, and `string(n)` — both lanes, end to end

**Files:**
- Modify: `runtime/clarus/text.cla` (after `rtTextIntAt` at `:655-665`), `runtime/clarus/str.cla` (`rtIntToStr`), `clarusc/ir.cla` (accessors beside `ITextIntAt` at `:3521-3528`), `clarusc/check.cla` (`textOnlyMethods` block `:1482-1499`; `cnString` in `cnInit` `:85-103` + var beside `cnInt` `:69`; `checkIdentCall` `:5356-5365`; `checkConversion` `:5237-5272`), `clarusc/lower.cla` (`lowStringTextMethod` `:1912-1925`; `lowCall` conversion arms `:1245-1252`), `clarusc/cprint.cla` (`:2801-2813` scalar arms; the `ITextStringAt` KStr shape `:2805-2808`), `clarusc/cg68k.cla` (`rn*` vars `:300-460`; `cgIntr` arms `:8190-8213`; `cgEmitStoreStr` `:10763-10793` and `cgEmitReturnStr` `~:11094` `"text_string_at"` arms), `docs/clarus-language-reference.md` (`### Text` `:385-401`; `### Numeric Conversions` `:198`), `testsuite/kit.cla:45-75` (`tkIntToStr` body → `return string(n)`, keep the name), `examples/serialecho.cla:37-54` (`intStr` → `string(n)`), `runtime/clarus/uiscript.cla:250-286` (`rtUiIntToText` builds its text from `rtIntToStr`).
- Create: `testdata/run/text_binary.cla` (+ `.behavior`), `testdata/run/crc16.cla`, `testdata/run/int_to_str.cla`, `testdata/runerr/text_setint_oor.cla` (+ `.err`), `testdata/errors/string_conv_arg.cla` (+ `.expect`), `testsuite/core/cases_textbinary.cla`.
- Modify (counts): `testsuite/core/runner.cla` (enum + dispatch + `nCoreCases` +3), `internal/mactest/coresuite_test.go:34`, `internal/mactest/suite_host_test.go:88-119`, `internal/bake/bakeidentity_test.go:1284-1316`.

**Interfaces:**
- Produces (runtime, `text.cla`, all taking `t: ptr` like `rtTextIntAt`, all using the STRICT bound `pos < 0 or pos > rt.len - n`, panic `"text index out of range"`, one `TextHandleDeref` per call, `peekb`/`pokeb`): `rtTextIntAtLE(t, pos): int` (LE signed 32), `rtTextWordAt(t, pos): int` (BE, 0–65535), `rtTextWordAtLE(t, pos): int`, `rtTextSetIntAt(t, pos, v: int)`, `rtTextSetIntAtLE(t, pos, v)`, `rtTextSetWordAt(t, pos, v)` (low 16 bits), `rtTextSetWordAtLE(t, pos, v)`, `rtTextCrc16(t, h, pos, n): int` — CRC-16/KERMIT: `crc = h & 0xFFFF; for each byte b: crc = crc ^ b; 8×{ if crc & 1 { crc = (crc >> 1) ^ 0x8408 } else { crc = crc >> 1 } }` (NB `>>` is arithmetic in Clarus — mask `crc & 0xFFFF` after each step or keep the value < 2^15 by construction; test vector pins it), `n == 0` returns `h & 0xFFFF`. (`str.cla`): `rtIntToStr(n: int): string` — decimal, negative-safe incl. `int.min` (use the `numToStr` shape from `clarusc/lib.cla:139-163`: low-digit-first `mod`/`/` with prepend; handle `int.min` by negating digit-wise, never `0 - n`).
- Produces (IR): `ITextIntAtLE()` (`"text_int_at_le"`), `ITextWordAt()`, `ITextWordAtLE()`, `ITextSetIntAt()`, `ITextSetIntAtLE()`, `ITextSetWordAt()`, `ITextSetWordAtLE()`, `ITextCrc16()`, `IIntToStr()` (`"int_to_str"`) — the 4-line memoized-accessor shape at `ir.cla:3512-3519`.
- Produces (checker): `textOnlyMethods["intAtLE"/"wordAt"/"wordAtLE"]` = `(int)->int`; `["setIntAt"/"setIntAtLE"/"setWordAt"/"setWordAtLE"]` = `(int,int)->void` (`sigEnd(-1)`); `["crc16"]` = `(int,int,int)->int`; `string(n)` = `checkIdentCall` branch `if nameIdx == cnString { return checkConversion(e, strT(255), "string") }` placed BEFORE `scopeLookup`, with a `checkConversion` arm keyed on `name == "string"`: `ok = typeKind(at) == TyInt` (the `strT(255)` index is non-singleton, so key on the name, not the target index).
- Produces (lowering): text arms via `newIRIntr(I…(), lowMethodArgsN(...), ty)`; `string` arm in `lowCall`: `newIRIntr(IIntToStr(), lowArgs(callArgsHead(e)), ty)`.
- Produces (backends): cprint scalar arms `clar_fn_rtTextIntAtLE((void*)recv, (int32_t)(pos))` etc.; setters emitted as statements (`fpEmit`) returning nothing — copy `ITextSetIndex`'s arm; `IIntToStr` as the `ITextStringAt` KStr shape with `clar_fn_rtIntToStr((int32_t)(n))`. cg68k: `rnTextIntAtLE = intern("rtTextIntAtLE")` etc.; `cgIntr2/3/4` arms with `addr` flags matching `ITextIntAt`'s (`false,false`) and `ITextSetIndex`'s; `IIntToStr` in `cgEmitStoreStr` + `cgEmitReturnStr` matching `nm == "int_to_str"`, hidden-result-pointer convention of the `"text_string_at"` arm, `rnIntToStr = intern("rtIntToStr")`.

- [ ] **Step 1: Failing fixtures first**

`testdata/run/text_binary.cla`: build a 16-byte text (append 16 zero chars), `t.setIntAt(0, 0x01020304)`, `t.setIntAtLE(4, 0x01020304)`, `t.setWordAt(8, 0xBEEF)`, `t.setWordAtLE(10, 0xBEEF)`, `t.setIntAt(12, -2)`; then alert each of: `t.intAt(0) == 0x01020304`, `t.intAtLE(4) == 0x01020304`, `int(t[4]) == 4` (LE byte order proof), `t.wordAt(8) == 0xBEEF`, `t.wordAtLE(10) == 0xBEEF`, `int(t[10]) == 0xEF`, `t.intAt(12) == -2`, `t.intAtLE(12) != -2` (it reads 0xFEFFFFFF's LE twin — assert the exact value), `t.wordAt(12) == 0xFFFF` (unsigned). `testdata/run/crc16.cla`: `"123456789"` → `crc16(0,0,9) == 0x2189` one-shot, and chunked (`h = t.crc16(0,0,4); h = t.crc16(h,4,5)`) equal; `n == 0` returns `h`. `testdata/run/int_to_str.cla`: `string(0)`, `string(42)`, `string(-7)`, `string(2147483647)`, `string(-2147483648)` printed via `alert`. `testdata/runerr/text_setint_oor.cla`: `t.setIntAt(13, 1)` on a 16-byte text → `.err` "text index out of range". `testdata/errors/string_conv_arg.cla`: `string("x")` → `.expect` the conversion diagnostic text (check what `checkConversion` prints for `int("x")` and mirror).
Run: `scripts/clarus-run.sh testdata/run/text_binary.cla` → FAIL (unknown method).

- [ ] **Step 2: Runtime routines** in `text.cla`/`str.cla` per the Interfaces block (mirror `rtTextIntAt`'s body exactly for readers; `rtTextSetIndex`'s for writers).

- [ ] **Step 3: Compiler + both backends** per the Interfaces block. Then `scripts/clarus-run.sh` each fixture → expected alerts. Bless: `CLARUS_BLESS_BEHAVIOR=1 go test ./internal/selfhost -run 'TestBehaviorGoldens/(run|runerr)/(text_binary|crc16|int_to_str|text_setint_oor)' -count=1` and hand-write the `.expect`.

- [ ] **Step 4: Core suite cases + migrations**

`testsuite/core/cases_textbinary.cla`: `caseTextBinary` (the fixture's assertions as `tkFail` details), `caseCrc16`, `caseIntToStr`. Register all three; bump every count site (Global Constraints). `tkIntToStr` body → `return string(n)`; `serialecho.cla`'s `intStr` → `string(n)`; `rtUiIntToText` → build from `rtIntToStr` (keep its text-returning contract; `natItoa` stays — it is JSR'd by cg68k with a ptr-buffer contract, record that deviation from spec §4.2 in the task report). Host: the CLAUDE.md core-CLI recipe with `all` → PASS. Native: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestCoreSuiteGUIOn68k -count=1 -v` → the three new subtests PASS (this is the 68k proof of the cg68k arms incl. the KStr path).

- [ ] **Step 5: Reference** — `### Text` gains the seven accessors + `crc16` (one table, the bounds rule, the KERMIT identification and vector); `### Numeric Conversions` gains `string(n)` with the type-position note (spec §3.4). Fences for the examples (note the reftest-index rule).

- [ ] **Step 6: T1 + zero-churn + commit**

Run: `scripts/test-task.sh --smoke` → PASS. `go test ./internal/cg68k ./internal/emitui -count=1` → no golden diffs (new runtime routines are unreferenced by golden programs; if a golden churns, STOP per Global Constraints).
```bash
git add runtime/clarus/text.cla runtime/clarus/str.cla runtime/clarus/uiscript.cla clarusc/ testdata/ testsuite/ internal/mactest/ internal/bake/ examples/serialecho.cla docs/clarus-language-reference.md
git commit -m "feat: text LE/word/setter accessors + crc16 + string(n) on both lanes; core cases TextBinary/Crc16/IntToStr"
```

---

### Task 4: `connection` as a value — params, locals, fields, elements

**Files:**
- Modify: `clarusc/lower.cla` (`lowTypeAt` `:362-419` — add `case TyConnection { return irIntT }`; `lowGlobalVarDecl` `:5135-5148` — replace the early `return` with an ordinary int IR global initialized to `slot+1` (find how `var x: int = 5` builds its initializer in the fall-through path `:5150-5165` and synthesize `newIRIntConst(slot + 1, irIntT)`); `lowConnMethod` `:1385-1425` — `recv = lowExpr(recvExpr)` for EVERY receiver, pass `recv` where the slot const was passed; keep the `callTransport(e) == 2` check and the existing `lowUnsupported` for non-serial transports), `clarusc/check.cla` (nothing structural; confirm `usesConn` `:5715-5730` still fires on the global decl), `runtime/clarus/conn.cla:196-299` (`rtConnOpen/SendText/SendStr/Close` take `h: int` 1-based: `if h == 0 { rtPanic("use of nil connection") }`, `slot = h - 1`, then the existing body; pump/alive/dispatchers untouched), `conn_c.cla`/`conn_68k.cla` (no change — they take the 0-based slot from `conn.cla`).
- Modify tests: `internal/conntest/testdata/echo.cla` (add `func sendVia(c: connection, s: string) { c.send(s) }` and route `READY` through it; add a record `Link { conn: connection }`, assign the global, send through `link.conn`), `internal/conntest/testdata/conn_shadow_local.cla` + `TestConnShadowedLocalRejected` (`conntest_test.go:442`) — a local `connection` shadowing the global is now LEGAL (it is a value, nil unless assigned): flip the test to assert the program BUILDS and that `send` on the never-assigned local panics `use of nil connection` (rename to `TestConnShadowedLocalIsNil`).
- Create: `testdata/runerr/conn_nil_field.cla` (+ `.err` "use of nil connection"): `record R { c: connection }`, `var r: R`, `r.c.send("x")` in `startCLI`.
- Reference: `### Connections` `:1313` — one paragraph: connection values may be copied/passed; handlers still bind to globals; nil semantics (spec §3.2).

**Interfaces:**
- Consumes: nothing new. Produces: every `connection`-typed expression lowers to an int; `rtConn*(h, ...)` 1-based contract. `lowConnSlotOf` survives ONLY for `on conn.<event>` handler resolution (`lower.cla:4910-4933`) and the `>4` build error.

- [ ] **Step 1: Failing fixture** — the updated `echo.cla`; `scripts/clarus-run.sh internal/conntest/testdata/echo.cla` → FAIL today (`receiver kind 13`).
- [ ] **Step 2: Lowering + runtime** per the Interfaces block.
- [ ] **Step 3: Tests** — `go test ./internal/conntest -count=1 -v` → PASS incl. the flipped shadow test; bless the runerr fixture; `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1` → `SerialOpenWrite` green (native conn path unchanged).
- [ ] **Step 4: T1 + zero-churn + commit** — `scripts/test-task.sh --smoke`; `go test ./internal/cg68k ./internal/emitui -count=1` no diffs (no golden program declares a connection).
```bash
git add clarusc/lower.cla runtime/clarus/conn.cla internal/conntest/ testdata/runerr/ docs/clarus-language-reference.md
git commit -m "feat: connection is an int value -- params, locals, fields, elements work; rtConn* take a 1-based handle"
```

---

### Task 5: `filehandle` — surface, shared runtime, host glue, host end-to-end

**Files:**
- Modify: `clarusc/types.cla:34-123` (append `TyFileHandle`), `clarusc/check.cla` (`var fileHandleT: int` beside `:46-48`; `fileHandleT = pushSimple(TyFileHandle)` after `:5667`; `declBuiltinType(scope, "filehandle", fileHandleT)` at `:1399-1404`; `isResourceKind` `:1247-1251`; new `filehandleMethods: map of int` beside `:538-543` built in `buildMethodTables` — `readAt(int,int,text)->bool`, `writeAt(int, text|str)->bool` (`psOneOf2(TyText, TyStr)`), `append(text|str)->bool`, `size()->int`, `setSize(int)->bool`, `flush()->bool`, `close()->void`; `checkMethodCall` switch `:1918-1960` gains `case TyFileHandle { return checkTableMethod(filehandleMethods, sel, argsHead) }`; `fileFuncs["open"] = sigEnd(fileHandleT)` with one `psPlain(strT(255))`, `fileFuncs["create"] = sigEnd(fileHandleT)` with path/type/creator `strT(255)`; new `var usesFileh: bool` (declare beside `usesConn` `:733`, reset in `checkReset` `:5681`), set `true` wherever `resolveType` yields `fileHandleT` AND in the `file` branch of `checkMethodCall` (`:1858-1894`) when `sel` is `open`/`create`), `clarusc/lower.cla` (`lowTypeAt` `case TyFileHandle { return irIntT }`; `lowMethodCall` `:1303-1343` — after `recv = lowExpr(...)`, `else if xk == TyFileHandle { return lowFileHandleMethod(recv, fn, callArgsHead(e), ty) }`; new `lowFileHandleMethod`: `newIRCallFn(intern("rtFhReadAt"), args(recv,pos,count,out), irBoolT)` etc., `writeAt`/`append` pick `rtFhWriteAt`/`rtFhWriteAtStr` / `rtFhAppend`/`rtFhAppendStr` by `typeKind(exprTypeGet(arg)) == TyText` exactly like `lowConnMethod:1407-1414`, coercing via `lowConnCoerceArg`'s generalization (rename it `lowRtCoerceArg` if its name misleads — it reads the target runtime fn's param type); `lowFileCall` `:1542-1594` gains `open` → `newIRCallFn(intern("rtFhOpen"), path, irIntT)` and `create` → `lowCheckLiteral4CCArg` on args 2/3 (as `writeText` does at `:1558-1559`) then `newIRCallFn(intern("rtFhCreate"), (path,type,creator), irIntT)`), `clarusc/drive.cla:1522-1531` (host lane: `else if usesFileh { neededMods.add("fileh.cla"); neededMods.add("fileh_c.cla") }` — 68k superset waits for Task 6), `runtime/host/rt.c:219` (`#include "rt_fileh.inc"` after `rt_serial.inc`).
- Create: `runtime/clarus/fileh.cla`, `runtime/clarus/fileh_c.cla`, `runtime/host/rt_fileh.inc`, `testsuite/core/cases_fileh.cla`, `testdata/run/fileh_basic.cla`, `testdata/runerr/fileh_nil.cla`, `testdata/runerr/fileh_negpos.cla`, `testdata/errors/fileh_save_field.cla`.
- Modify (counts): `runner.cla`, `coresuite_test.go:34`, `suite_host_test.go:88-119`, `bakeidentity_test.go:1284-1316`.
- Reference: `### Files` `:1424` (the `filehandle` type, `file.open`/`file.create`, the seven methods, every semantic bullet of spec §3.1 incl. nil-method = runtime error, stale-after-close = C-fd semantics, `setSize` growth contents per lane, no auto-close); `### Runtime Errors`/`nil` table row `:139` (filehandle joins "window/resource references").

**Interfaces:**
- Produces (`fileh.cla`, shared — no globals, no state; `h == 0` ⇒ `rtPanic("use of nil filehandle")` in every entry but `rtFhClose`; negative `pos`/`count`/`n` ⇒ `rtPanic("filehandle position out of range")`; on device failure `rtSetLastErr(code, msg)` with `code` = the lane's OS error (OSErr / errno) and `msg` one of `"open failed"`, `"create failed"`, `"read failed"`, `"write failed"`, `"size failed"`, `"setSize failed"`, `"flush failed"`):
  - `rtFhOpen(path: string): int` → `rtFhDevOpen(path)` (0 on failure, lastError set); `rtFhCreate(path: string, ftype: string, fcreator: string): int` → `rtFhDevCreate`; `rtFhReadAt(h, pos, count, out: text): bool`; `rtFhWriteAt(h, pos, t: text): bool`; `rtFhWriteAtStr(h, pos, s: string): bool` (`return rtFhWriteAt(h, pos, s)` — the implicit string→text conversion `rtConnSendStr` relies on at `conn.cla:288-290`); `rtFhAppend(h, t: text): bool`; `rtFhAppendStr(h, s: string): bool`; `rtFhSize(h): int` (-1 + lastError); `rtFhSetSize(h, n): bool`; `rtFhFlush(h): bool`; `rtFhClose(h)` (no-op on 0, idempotent).
  - Lane waist (each lane implements all): `rtFhDevOpen(path: string): int`, `rtFhDevCreate(path, ftype, fcreator: string): int` (create-or-truncate, stamps type/creator on the Mac, returns open handle), `rtFhDevReadAt(h, pos, out: text, count): int` (grows `out` to `count`, reads into it, sets `out.len` to bytes read, returns bytes read or -1 — a short read at EOF is NOT an error), `rtFhDevWriteAt(h, pos, t: text): int` (0 or -errcode; `pos == -1` means "at EOF" so `append` needs no size query), `rtFhDevSize(h): int`, `rtFhDevSetSize(h, n): int`, `rtFhDevFlush(h): int`, `rtFhDevClose(h)`, `rtFhDevLastOSErr(): int`.
- Produces (`fileh_c.cla` + `rt_fileh.inc`): externs `FhHOpen(path: string): int`, `FhHCreate(path: string): int`, `FhHReadAt(h, pos, p: ptr, n): int`, `FhHWriteAt(h, pos, p: ptr, n): int`, `FhHSize(h): int`, `FhHSetSize(h, n): int`, `FhHFlush(h): int`, `FhHClose(h)`, `FhHErrno(): int` → C `rt_ext_FhH*` (`"rt_ext_" + name`, `cprint.cla:1656`); handle = `fd + 1`; `open(O_RDWR)`, `open(O_RDWR|O_CREAT|O_TRUNC, 0644)`, `pread`/`pwrite` (loop to completion), `pos == -1` → `lseek(SEEK_END)` + `write`, `fstat().st_size`, `ftruncate`, `fsync`, `close`; type/creator ignored. `fileh_c.cla`'s `rtFhDevReadAt` grows the text (`rtTextGrow`, re-derive `TextHandleDeref`, pass the master pointer) — on the host a text's storage does not move during a C call.
- Consumed by: Task 6 (`fileh_68k.cla` implements the same waist), `lowFileHandleMethod` above.

- [ ] **Step 1: Failing fixtures** — `testdata/run/fileh_basic.cla`: `file.create("fileh_basic.dat","TEXT","CLRS")`, `writeAt(0, "hello")`, `writeAt(512, t)` (a 4-byte text), `size() == 516`, `readAt(0,5,out)` == `"hello"`, `readAt(512,100,out)` → `out.count == 4`, `readAt(600,10,out)` → `out.count == 0` and `true`, `append("!")` → size 517, `setSize(8)` → size 8, `setSize(1024)` → size 1024 and (host) `readAt(1000,4,out)` all zero bytes, `flush()`, `close()`, reopen via `file.open`, read back, close; a `record DB { dat: filehandle; jnl: filehandle }` holding two handles; a `func pageWrite(f: filehandle, n: int, t: text): bool` called with the field; `f == nil` after `f = nil`; `file.open("does-not-exist")` → nil and `lastError.message == "open failed"`. Clean up the scratch file at the end (`file.*` has no delete — leave it; the Go driver runs in a temp cwd? check `behavior_test.go` — if not, write under `/tmp`-style path the same way `testdata/run/core_*` fixtures do, see the repo-root `core_*.dat` droppings: prefer a relative name so it lands beside them). `testdata/runerr/fileh_nil.cla` (`var f: filehandle; f.size()` → `.err` "use of nil filehandle"), `fileh_negpos.cla` (`readAt(-1, ...)` → "filehandle position out of range"), `testdata/errors/fileh_save_field.cla` (`file.save` of a record with a `filehandle` field → the existing "is not a value type" diagnostic from `lowCheckSerializableFields`; NB that runs at emit — `TestErrorGoldens` invokes `clarusc emit`, so it is caught).
- [ ] **Step 2: Types/checker/lowering/drive** per the Interfaces block. `scripts/clarus-run.sh testdata/run/fileh_basic.cla` → now fails at link (no runtime) — proceed.
- [ ] **Step 3: Runtime + host glue** — `fileh.cla`, `fileh_c.cla`, `rt_fileh.inc`. Standalone C proof: add `runtime/host/rt_fileh_test.c` beside `rt_ser_test.c`/`rt_mem_test.c` (read one; wire it wherever they run) — create/pwrite/pread/size/truncate/fsync/close round trip. Then the fixture runs; bless behavior goldens; hand-write the `.expect`.
- [ ] **Step 4: Core suite case `FileHandleRW`** (`cases_fileh.cla`, the fixture's assertions + stale-after-close: `close()`, then `size()` on the stale copy returns -1 — on the host ONLY if the fd was not reused; assert `lastError.message == "size failed"` ONLY when the call returned -1, documented C-fd semantics) — register; bump all count sites; host CLI `all` → PASS.
- [ ] **Step 5: Reference** per the Files list above.
- [ ] **Step 6: T1 + zero-churn + commit** — `scripts/test-task.sh --smoke`; cg68k/emitui no diffs (host-gated splice; no golden program uses `filehandle`).
```bash
git add clarusc/ runtime/clarus/fileh.cla runtime/clarus/fileh_c.cla runtime/host/ testsuite/ testdata/ internal/mactest/ internal/bake/ docs/clarus-language-reference.md
git commit -m "feat: filehandle -- value-typed positioned file I/O, shared runtime + host glue, FileHandleRW on host"
```

---

### Task 6: `filehandle` native lane — `fileh_68k.cla`, superset splice, bake list, cprint-Mac stub

**Files:**
- Create: `runtime/clarus/fileh_68k.cla`.
- Modify: `clarusc/drive.cla:1522-1524` (`if want68k { ... neededMods.add("fileh.cla"); neededMods.add("fileh_68k.cla") }` — unconditional superset, mirroring `conn_68k.cla`; host stays `usesFileh`-gated), `clarusc/bake.cla:424-439` (`bakeModuleList` 68k branch +2), `internal/bake/bake_test.go:15-22` (`wantModuleCounts["68k"]` +2, comment), `runtime/mac/` cprint-lane ext include (find where `rt_ext_CoreSetLastErr`'s Mac twin lives — `grep -rn rt_ext_ runtime/mac/` — add `rt_ext_FhH*` stubs: `FhHOpen`/`FhHCreate` return 0, others return -1, `FhHErrno` returns -1; this lane is a demoted diagnostic, spec §4.2).
- Read first: `conn_68k.cla:61-73,108-236` (PB idiom), `native.cla:865-893` (HLock-around-`_Write`, re-derive after lock), `native.cla:824-852` (no-Get `PBSetFInfoSync` stamp), `toolbox/files.cla` (Task 2), Task 1's report.

**Interfaces:**
- Consumes: Task 2's traps/consts, Task 5's waist. Produces: `rtFhDevOpen`: `IOParam` local, `ioNamePtr` via the `rtConn68kName` Pascal-buffer idiom (copy it as `rtFh68kName`; free the buffer after the call — check what `rtConn68kName` does with its buffer and do the same), `ioPermssn = fsRdWrPerm`, `PBOpenSync`, return `ioRefNum` (0 on error + `rtSetLastErr(err, "open failed")`). `rtFhDevCreate`: `PBCreateSync` (ignore `dupFNErr`), stamp via direct `PBSetFInfoSync` on a `FileParam` with `ioFDirIndex = 0`, `ioFlFndrInfo` type/creator packed by `rtFourCC` (`core.cla:130`) — exactly `natFileWriteText:824-852`'s no-Get discipline, then open as above, then `PBSetEOFSync` 0. `rtFhDevReadAt`: `rtTextGrow(out, count)`, `NatHLock`-equivalent on the text handle (declare `HLock`/`HUnlock` the way `conn_68k`/`native.cla` reach them — `toolbox/memory.cla` has them; use the catalog), re-derive master pointer, `PBReadSync` with `ioPosMode = fsFromStart`, `ioPosOffset = pos`, `ioReqCount = count`, `ioBuffer = mp`; `eofErr` with `ioActCount >= 0` is SUCCESS (short read); unlock; set `len = ioActCount`; any other error → -1. `rtFhDevWriteAt`: HLock, `PBWriteSync` at `fsFromStart`/`pos` or `fsFromLEOF`/0 when `pos == -1`, unlock. `rtFhDevSize`: Task 1's survivor. `rtFhDevSetSize`: `PBSetEOFSync` with `ioMisc = n`. `rtFhDevFlush`: `PBFlushFileSync` then `PBFlushVolSync` with `ioNamePtr = 0`, `ioVRefNum` from the open PB (stash per-call: `PBGetFCBInfo` is out; pass `ioVRefNum = 0` = default volume, the `natFileFlush` precedent `native.cla:760-764`). `rtFhDevClose`: `PBCloseSync`.

- [ ] **Step 1: Write `fileh_68k.cla`** per the Interfaces block (provenance comments naming the catalog symbols).
- [ ] **Step 2: Wire** the 68k superset + `bakeModuleList` + `bake_test.go` counts + cprint-Mac stub. `go test ./internal/bake -count=1` → PASS.
- [ ] **Step 3: Native proof** — `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k' -count=1 -v` → `FileHandleRW` subtest green (this is the hardware proof of positioned I/O, `setSize`, `flush` on System 6). Also `TestToolboxSuiteOn68k|TestSmokeBounceOn68k|TestRealEventLoopTickOn68k` → PASS.
- [ ] **Step 4: Churn check** — `go test ./internal/cg68k ./internal/emitui -count=1`. Expected: no diffs (superset module tree-shaken from golden programs; `fileh*.cla` declares no globals). If the `.s` goldens churn, STOP and explain (a likely cause: a new extern-record or trap declaration that the pool/constant emission orders globally — name it in the report; do NOT rebless in this task without the explanation, and prefer fixing the cause).
- [ ] **Step 5: T1 + commit** — `scripts/test-task.sh --smoke`.
```bash
git add runtime/clarus/fileh_68k.cla clarusc/drive.cla clarusc/bake.cla internal/bake/ runtime/mac/
git commit -m "feat: native filehandle -- File Manager positioned I/O via the catalog, 68k superset splice, bake list"
```

---

### Task 7: `include "toolbox/..."` resolution fallback

**Files:**
- Modify: `clarusc/drive.cla:1000-1017` (`expand()`'s `DkInclude` loop: after `missing = expand(incResolved, false, incKey)` returns `true`, and BEFORE the `emitDiag("cannot open included file ...")` at `:1016`: if `incName` begins `"toolbox/"` (or normalizes to a key beginning `toolbox/` via `driveKeyResolve`), resolve `rtDir` if empty (`if not haveRtDir and rtDir == "" { rtDir = findRtDir("core.cla") }` — `findRtDir` `:568-595` probes `runtime/clarus/<probe>`), then `alt = drivePathJoin(rtDir, "../" + incName)` (host: `joinPath`; Mac disk mode: `drivePathJoin` handles `../` → `::`), `missing = expand(alt, false, incKey)`; only if still missing, the diagnostic. The baked-resource step is already inside `expand()`'s read path (`feReadSource` `:960`) so the Mac-resident order is disk-relative → rtdir sibling → resource, as spec §3.5 lists), `docs/clarus-language-reference.md:77` (`### Multi-File Programs: include` — the three-step rule).
- Create: `testdata/rtinc/toolbox_fallback/main.cla` (a `startCLI` program that `include "toolbox/osutils.cla"` and references one symbol from it, e.g. declares `var dt: DateTimeRec`), `internal/lowlevel/rtinc_test.go` subtest `ToolboxIncludeFallback` (`:29`/`:63` are the models): copy `main.cla` into `t.TempDir()` (no repo above it), run `clarusc --rtdir <repo>/runtime/clarus/ main.cla` (check-only) → exit 0; and a negative: same program, cwd in the temp dir, NO `--rtdir` and no `runtime/clarus` above → the `cannot open included file` diagnostic (fallback can't resolve; error stays honest).

- [ ] **Step 1: Failing test** — `go test ./internal/lowlevel -run 'TestRtInc/ToolboxIncludeFallback' -count=1` → FAIL (cannot open included file).
- [ ] **Step 2: Implement** in `expand()`. Identity: the fallback passes the SAME `incKey` so dedup against a runtime module's `../../toolbox/osutils.cla` holds (`drive.cla:344-380` comment).
- [ ] **Step 3: Tests** — the new subtest PASS; `TestIncludeDedup` (`incdedup_test.go:21`) still PASS; `go test ./internal/testsuite -count=1` (catalog) PASS.
- [ ] **Step 4: Reference + T1 + commit** — `scripts/test-task.sh --smoke`.
```bash
git add clarusc/drive.cla internal/lowlevel/ testdata/rtinc/ docs/clarus-language-reference.md
git commit -m "feat: include \"toolbox/...\" falls back to the compiler's toolbox/ directory via rtdir"
```

---

### Task 8: emit68k big-temp pool sized per function — the planned rebless wave

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgAllocBigTmpOff` `:4071-4083` (no abort on count: if `cgStmtBigTmpNext >= cgBigTmpBaseOffs.count`, extend the pool — see Step 2), `cgEmitFunc` frame layout `:5145-5158` (size the pool from `cgFuncBigTmpNeed[f]` instead of the const), `cg68Measure` `:12819-12824` (pre-size a new `cgFuncBigTmpNeed: list of int` to `irFuncs.count` zeros beside `cgFuncFrameSizes`), `cgStmt` `:11738-11745` (the per-statement reset stays), the `cgBigTmpSlots` doc comment `:1354-1409` (rewrite: the const becomes `cgBigTmpFloor` = 4, the per-function max comes from the measure pass), `testsuite/kit.cla:102-108` (drop the split-`alert` workaround comment; re-join `tkReport`'s line into one expression to PROVE it), `testdata/run/bigtmp_ceiling.cla` (rename to `bigtmp_spill.cla`: 40 chained string-concat args through a `take40` — or a 40-term `alert("a"+string(1)+"b"+string(2)+...)`), `docs/` (wherever "bump cgBigTmpSlots" appears: `grep -rn cgBigTmpSlots docs/ CLAUDE.md`).
- Rebless: `testdata/cg68k/*.s` (`CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -run TestCg68kGoldens -count=1`) — frame `LINK` immediates and big-temp A6 offsets change in every function; emitui (C) and behavior goldens are unaffected.

**Interfaces:**
- Produces: the measure pass (`cg68Measure`'s loop `:12841-12876`, `cgRecMode = 1`) lets the pool grow unbounded per statement and records the high-water `cgStmtBigTmpNext` per function into `cgFuncBigTmpNeed[f]`; the real pass (`cg68ProgramFork` `:14329,14340`) lays out exactly `max(cgBigTmpFloor, cgFuncBigTmpNeed[f])` slots. Frame offsets of everything BELOW the big pool (deep scratch, `cgReserveDeepScratch`) shift accordingly — they are computed after it at `:5160`, so they follow automatically. Invariant to assert in code: in the real pass `cgAllocBigTmpOff` must never need to extend (abort with `"cg68k: big-temp need mismatch between measure and emit passes"` if it does — the two passes run the same IR, so a mismatch is a bug, not a ceiling).

- [ ] **Step 1: Failing fixture** — `bigtmp_spill.cla` with 40 temps; `scripts/build-68k.sh` it → FAIL today ("bump cgBigTmpSlots").
- [ ] **Step 2: Implement** per the Interfaces block. In the measure pass, when the pool needs extending, append a new offset `runningNeg - cgBigTmpSize` below the last — but the deep scratch was already laid out below the pool at `:5160`: so in the MEASURE pass use offsets that only need to be self-consistent (the measure pass's code bytes are thrown away; instruction SIZES are what matter, and `d16(A6)` encoding is the same for any 16-bit displacement — keep every offset within ±32KB, which a 40×512 pool is). Simplest correct form: measure pass lays out the pool with `cgBigTmpFloor` slots and extends on demand below the deep scratch (colliding offsets are fine in a throwaway pass AS LONG AS instruction sizes match the real pass — they do: same addressing mode); real pass lays out the recorded max first, then deep scratch. Document this in the const's comment.
- [ ] **Step 3: Prove** — `scripts/build-68k.sh` the spill fixture → builds; behavior golden for it (host) bless; `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestSmokeBounceOn68k' -count=1` → PASS (the re-joined `tkReport` line runs natively). Check `cgStackHeuristic`'s reserve shrank: note the before/after number from a `tickprobe`/coregui build in the report.
- [ ] **Step 4: The planned rebless** — regenerate `testdata/cg68k/*.s`; normalization diff: strip `LINK A6,#-N` immediates and `d(A6)` displacements with `d <= -(named-locals size)` and assert the remaining opcode stream is byte-identical to HEAD's. Anything else churning → STOP. Then commit the goldens with the proof in the report.
- [ ] **Step 5: T1 + commit** — `scripts/test-task.sh --smoke`.
```bash
git add clarusc/cg68k.cla testsuite/kit.cla testdata/ docs/ CLAUDE.md
git commit -m "feat: cg68k sizes the str/rec temp pool per function from the measure pass -- no per-statement ceiling; planned .s rebless"
```

---

### Task 9: Acceptance — `examples/pagefile.cla` on Snow (System 7)

**Files:**
- Create: `examples/pagefile.cla`, `internal/mactest/pagefile_snow_test.go`.
- Read first: `internal/mactest/serial_snow_test.go` (`TestSerialEchoOnSnow` — the scratch-workspace clone + `--serial-bridge-a` + dial-with-retry machinery to reuse verbatim), `examples/serialecho.cla`.

**Interfaces:**
- Produces: a vDB-shaped demo: on launch, `file.create("PageFile.dat","VDBD","68BB")` + `file.create("PageFile.jnl","VDBJ","68BB")`; build a 512-byte page in a `text` with the header via `setWordAtLE`/`setIntAtLE` (signature `"VDB\0"`, version 1, page_size 512), CRC it (`crc16`), journal-append the page + CRC, `flush`, `writeAt(0, page)` to `.dat`, `flush`, `setSize(0)` on the journal; then re-read page 0, verify CRC and fields, loop 16 pages; send `"PASS <n>\n"` or `"FAIL <what>\n"` over `serial "modem:9600"` (opened via a `connection` passed to a `report(c: connection, s: string)` func — exercising Task 4), then `quit`. Host lane: same program runs with `CLARUS_SERIAL_MODEM=listen:PORT` (dev loop).
- The test: `TestPageFileOnSnow`, gated `CLARUS_SNOW_TESTS=1`: build via `scripts/build-68k.sh`, stage startup-booting, launch Snow with `--serial-bridge-a tcp:<port>`, dial, read `PASS 16`, assert clean exit.

- [ ] **Step 1: Write the app**, run it on the host (`scripts/clarus-run.sh examples/pagefile.cla` with the env var + `nc`) → `PASS 16`.
- [ ] **Step 2: The Snow test**; run once: `CLARUS_SNOW_TESTS=1 go test ./internal/mactest -run TestPageFileOnSnow -count=1 -v -timeout 30m` → PASS. Record the run in the report.
- [ ] **Step 3: T1 + commit** — `scripts/test-task.sh --smoke`.
```bash
git add examples/pagefile.cla internal/mactest/pagefile_snow_test.go
git commit -m "feat: pagefile acceptance app (vDB-shaped pages, journal, crc16) + gated Snow test"
```

---

### Task 9b: Compiler hardening — coercion-temp release order in `return call(...)` (inserted 2026-08-22)

Found by Task 5: when a `string` argument is implicitly coerced to a `text` parameter inside a call that is itself the operand of `return` (`return rtFoo(h, s)` where `rtFoo(h: int, t: text)`), lowering/cprint releases the coercion temp BEFORE the call consumes it (use-after-free on the host lane; the native lane needs the same audit). `runtime/clarus/fileh.cla` carries a marked workaround (`rtFhWriteAtStr`/`rtFhAppendStr` avoid the shape). Task 5's report ("TDD evidence" section) has the reproduction.

**Files:**
- Modify: `clarusc/lower.cla` and/or `clarusc/cprint.cla` (wherever the coercion temp's release is scheduled relative to the call — find the `lowCoerceStr`/temp-release path the report names), `clarusc/cg68k.cla` only if the native lane has the same ordering bug (prove it either way with the fixture below built via `scripts/build-68k.sh` and run on the suite lane if needed), `runtime/clarus/fileh.cla` (remove the workaround once the fix lands; the one-liner `return rtFhWriteAt(h, pos, s)` shape is the intended code).
- Create: `testdata/run/ret_coerce_str_text.cla` (+ `.behavior`): a user `func takes(t: text): int { return t.count }` and `func via(s: string): int { return takes(s) }` called with a non-empty string; under `CLARUS_MEM_STRICT=1`/the leak-strict harness the use-after-free must be observable (read `internal/selfhost/behavior_test.go`'s `.leaks` handling) — assert the correct count AND no leak/no UAF.

- [ ] **Step 1: Failing fixture** (RED under the strict harness or a visible wrong value).
- [ ] **Step 2: Fix the release ordering** (the temp must live until after the call returns; mirror how a non-`return` call statement already orders it). Remove the `fileh.cla` workaround.
- [ ] **Step 3: Prove both lanes** — behavior golden green; `scripts/build-68k.sh` the fixture and run it under the native lane (`internal/mactest` smoke or a one-off `LaunchAPPL` boot) if cg68k was touched; host core CLI `all` PASS; `go test ./internal/cg68k ./internal/emitui -count=1` (goldens: zero churn expected unless emitted C/asm ordering legitimately changes for existing fixtures — explain any churn; rebless only with proof).
- [ ] **Step 4: Snapshot regen to the fixed point; T1; commit** — `fix: release string->text coercion temps after the call they feed (return-call use-after-free); drop fileh.cla workaround`.

---

### Task 10: Close-out — snapshot regen, selfhost, reftest manifest, docs

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `internal/reftest/manifest.go` (regen), `STATUS.md`, `docs/ROADMAP.md` (item 1 "Binary streams and files" → DONE with the phase name; "Where we are"), `docs/TODO.md` (deferrals: handle generation counter; `natItoa` not collapsed; `PBGetEOFSync` root cause; anything a review deferred), `CLAUDE.md` (core case count sentence; the stale `coreCLIHostFiles` mention at `:145-146`; `string(n)`/`filehandle` one-liners where `file.*` is described), `docs/HISTORY.md` (the phase entry, verbatim archive per ROADMAP's header rule).
- Read first: `internal/selfhost/fixedpoint_test.go`'s regeneration instructions.

- [ ] **Step 1: Snapshot regen to a Go-free fixed point** per the fixed-point test's printed instructions (stage-1 from committed snapshot → emit gen1 → cc → emit gen2 → `cmp`; converge and re-verify).
- [ ] **Step 2: reftest manifest regeneration** (the branch's final-task rule) → `go test ./internal/reftest -count=1` PASS.
- [ ] **Step 3: Full selfhost** — `go test ./internal/selfhost -count=1 -timeout 30m` → PASS incl. `TestSnapshotFixedPoint` and every new behavior golden.
- [ ] **Step 4: T2** — `scripts/test-merge.sh` (foreground, log to the SDD workspace) → PASS.
- [ ] **Step 5: Docs** per the Files list; commit.
- [ ] **Step 6: Report the controller-run finals** — NOT this task's job to run: the standing `TestClarusCBakePathOnSnow` rerun (`CLARUS_SNOW_TESTS=1`, ~55 min; the bake manifest changed) and a final `TestPageFileOnSnow` at the true tip; state both in `STATUS.md` §0. Also state the two consumer-side follow-ups for Andrew's 68kBBS repo (not ours): `termio.cla` restores `(conn: connection, ...)` signatures; `bbs.cla` drops the `clarus-src/` include spelling for `toolbox/osutils.cla`; `docs/language-gaps.md` ticks off all eight.

---

## Self-review notes (spec coverage)

- Spec §3.1 filehandle → Tasks 5 (surface, semantics, host), 6 (native); every bullet (nil panic, negative-pos panic, short reads, past-EOF writes, `append` without size query, `setSize` lane note, `flush` = FlushFile+FlushVol / fsync, idempotent close, stale = C-fd semantics) is named in a task step or the reference step. `file.create`'s literal-4CC rule → Task 5 (`lowCheckLiteral4CCArg`).
- Spec §3.2 connection → Task 4 (incl. the shadow-test flip, nil-field runerr, reference paragraph).
- Spec §3.3 text accessors + crc16 → Task 3 (vector 0x2189, chunked, bounds).
- Spec §3.4 `string(n)` → Task 3 (`cnString`, KStr backend paths, migrations; `natItoa` deviation recorded).
- Spec §3.5 include → Task 7. Spec §3.6 bigtmp → Task 8.
- Spec §4.1/4.2/4.3 → Tasks 3–8 as mapped; spec §4.2's probe → Task 1; catalog fill → Task 2; cprint-Mac stub → Task 6.
- Spec §4.4 consequences → Task 6 (bake counts), Task 8 (the rebless wave, narrowed from "runtime renumbering" to "frame sizes" — the runtime tasks are expected churn-free), Task 10 (snapshot, Snow rerun, reftest).
- Spec §5 testing → Tasks 3–9; §6 risks → Tasks 1, 4, 8; §7 out-of-scope → nothing in this plan implements any of it.
