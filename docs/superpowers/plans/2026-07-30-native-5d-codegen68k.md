# Native 5d — codegen68k (68k Codegen v1) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** clarusc gains a second backend — direct 68000 binary emission through
an instruction-table layer — that compiles the non-UI corpus into a MacBinary
APPL runnable under Mini vMac, with the suite app's output byte-identical to
the host build.

**Architecture:** Per `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`
(and its parent `2026-07-29-native-68k-toolchain-design.md`): one instruction
table drives an encoder (words + backpatch), a Motorola-syntax listing printer
(vasm-assemblable, never parsed), and a future peephole pass. Naive
stack-oriented codegen (temps on stack, D0/D1/A0/A1 scratch), C-style calling
convention (caller cleans, result in D0, LINK/UNLK A6), first-fit segmentation
with a CODE 0 jump table, A5-world globals, resource-fork bytes built by
clarusc itself and wrapped in MacBinary on the host. Tree-shake and trap
clauses land here; the remaining emitted-C runtime leaves (lasterr, arr/enum
checks, fixed mul/div, ser's C list/map externs) port to Clarus first so the
native backend links only Clarus-generated code plus inlined traps.

**Tech Stack:** New clarusc modules in the Go-compiler-buildable Clarus subset
(`shake.cla`, `asm68k.cla`, `cg68k.cla`, `app68k.cla`); runtime modules
`runtime/clarus/core.cla` (shared) and `runtime/clarus/native.cla`
(emit68k-only, File-Manager-trap console/file I/O); vasm 1.8g in-repo
(`vasm/vasmm68k_mot`) as the ring-2 oracle; existing mactest/LaunchAPPL
harness for boots.

## Design decisions locked during planning (2026-07-30)

- **`file.writeText` is already binary-safe** (`testdata/run/lib/binroundtrip.cla`
  pins NUL/CR/255 round-trips), so `emit68k` writes the MacBinary image with
  the existing builtin — no new file primitive.
- **Register-trap register assignment is rule-based, not per-trap syntax:**
  for `= trap 0xXXXX reg`, `ptr` params map to A0, A1 in declaration order;
  `int`/`bool`/`char` params map to D0, D1 in order; a `ptr` result reads A0,
  any other result reads D0. This covers every OS trap 5d needs
  (`_NewHandle` D0→A0, `_BlockMove` A0/A1/D0, `_SetHandleSize` A0/D0→D0,
  File Manager PB traps A0→D0, …). Pascal traps (`= trap 0xXXXX`, no `reg`)
  push args left-to-right (longs for int/ptr, words for bool/char, address
  for str), caller pre-reserves the result slot. Two extra clause forms:
  `= inline deref` (the `*HandleDeref` externs: `MOVEA.L arg,A0; MOVE.L (A0),D0`)
  and `= inline nop` (the `*RcCheck` externs on native: evaluate args, emit
  nothing).
- **Extern-to-native fallback:** in emit68k, an `ECallExt` with no clause
  resolves to a Clarus function named `nat_<ExternName>` if one exists in the
  program (supplied by `native.cla`), else it is a compile error naming the
  extern. cprint is untouched — host keeps the `rt_ext_*` shims.
- **Native console = the capture protocol, always on.** rt_mac.c's
  RT_MAC_TEST build multiplexes everything into a file named `out`
  (`runtime/mac/rt_mac.c:83-253`); LaunchAPPL echoes only that file. 5d
  native apps are faceless test apps, so `native.cla` implements exactly that
  protocol unconditionally (`##CLARUS-EXIT## <code>\n##CLARUS-LOG##\n` + log
  buffer). A real-app console story arrives with the 5e UI port.
- **String literals, enum tables, and serdesc tables are per-segment constant
  pools**, referenced `LEA d16(PC)` — no DATA resource, no startup copying,
  duplicated across segments when referenced from more than one (rare,
  harmless, deterministic). Mutable globals live below A5, zeroed by startup.
- **Every reachable function gets a jump-table entry** (deterministic,
  simple); intra-segment calls are direct `BSR.W`, cross-segment calls
  `JSR d16(A5)` through the JT. Function→JT-slot assignment happens before
  codegen (declaration order over shaken functions), so call sites never
  need relocation.
- **Two inventory additions confirmed during exploration** (beyond the spec's
  5d-input list): `rt_fix_mul`/`rt_fix_div` (live at cprint.cla:1496/1498)
  and ser.cla's 10 `SerList*`/`SerMap*` externs that still land on C
  `rt_list_*`/`rt_map_*` (`rt_ext_host.inc:73-81`). Both are closed in
  Phase A.
- **Honest gate limits, recorded up front:** (1) native rc-leak parity is
  structural, not measured — the host leak ledger cannot run on the Mac, so
  under-release on native is invisible; the mirror-of-cprint discipline plus
  the host-side leak gates on identical IR is the guarantee. (2) file.save/
  file.load never joins the native gate in 5d: the host suite expectation is
  built by the frozen Go compiler, which rejects those programs. ser goes
  fully Clarus (Task 4) and its file externs get native fallbacks (Task 14),
  but emulator coverage waits for 5f's self-host, which exercises file I/O
  heavily. (3) Division by zero natively raises the 68k divide exception
  (system error), matching host UB — no fixture divides by zero; no guard.

## Global Constraints

- The Go compiler (`internal/`) is FROZEN. All new behavior lands in clarusc
  (`clarusc/*.cla`), the runtime (`runtime/clarus/`, `internal/build/rt/`,
  `runtime/mac/`), scripts, and Go test harnesses.
- `clarusc/*.cla` must not USE new language features (the Go compiler builds
  clarusc): no `ptr`/peek/poke/`external` in `shake.cla`/`asm68k.cla`/
  `cg68k.cla`/`app68k.cla` — instructions are records/lists of int, bytes
  are built in `text` values via `char(n)` appends.
- Every commit that touches `clarusc/*.cla` regenerates the snapshot in the
  same task:
  `go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla && /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla`
  and re-blesses changed emitui goldens with that same binary. Churn rule:
  logic commit first, then a separate re-bless commit.
- `rt_ext_host.inc` and `runtime/mac/rt_ext_mac.inc` mirror each other
  function-for-function; every wrapper change edits BOTH in the same commit.
- New-syntax fixtures (trap clauses) never land in `testdata/{valid,errors,
  run,run/lib,runerr,include,diag,suite}` or as driver-level syntax in
  `clarusc/test/*_test.cla`; safe homes: string-embedded cases in
  `clarusc/test/check_test.cla`, `testdata/lowlevel/`, the runtime modules
  themselves, and the new `testdata/cg68k/` (compiled only by clarusc).
- **Determinism is a hard requirement**: no address-dependent choices, stable
  iteration order everywhere (arenas and lists only — clarusc has no
  hash-ordered container), all sizes computed from the instruction table
  (every Bcc/BSR emitted `.W`; shrinking is peephole's job, later).
- Listings must stay vasm-assemblable: Motorola syntax, trap words as
  `DC.W $Axxx  ; _TrapName`, labels/directives per
  `vasm/doc/cpu_m68k.texi`. Oracle invocation:
  `vasm/vasmm68k_mot -m68000 -no-opt -Fbin -o out.bin in.s`.
- Calling convention (fixed by the spec, do not re-litigate): caller pushes
  args left-to-right, caller cleans, 32-bit result in D0, LINK/UNLK A6
  frames, D0/D1/A0/A1 scratch, D2-D7/A2-A4 preserved (naive codegen does not
  use them), A5 = globals world, A6 = frame, A7 = SP. Str255 and record
  values pass by value (block-copied, even-padded), matching cprint's C
  semantics; results wider than 4 bytes return via a hidden pointer arg
  pushed last (so it is at 8(A6)).
- Segment budget: 32,760 bytes of CODE payload (header + code + pool). A
  single function + its pool exceeding the budget is a compile error naming
  the function.
- The gauntlet, after every task, in this order:
  `go test ./internal/selfhost` (differential + leak gates + snapshot),
  `go test ./internal/sertest ./internal/lowlevel ./internal/emitui`,
  `go test ./...`. Zero `.leaks` churn and zero CLRD-golden churn expected in
  Phase A (behavior-preserving ports); any diff is a bug, not a re-bless.
- Gated Mac/native gate where a task says so: `CLARUS_MAC_TESTS=1 go test
  ./internal/mactest -run <Test>` (needs toolchain + emulator symlinks).
- Trap words cited in this plan (0xA122 `_NewHandle`, 0xA023
  `_DisposHandle`, 0xA024 `_SetHandleSize`, 0xA11E `_NewPtr`, 0xA01F
  `_DisposPtr`, 0xA02E `_BlockMove`, 0xA063 `_MaxApplZone`, 0xA036
  `_MoreMasters`, 0xA9F4 `_ExitToShell`, 0xA9F0 `_LoadSeg`, 0xA000 `_Open`,
  0xA001 `_Close`, 0xA002 `_Read`, 0xA003 `_Write`, 0xA008 `_Create`,
  0xA011 `_GetEOF`, 0xA012 `_SetEOF`, 0xA013 `_FlushVol`) must be verified
  against `Retro68/InterfacesAndLibraries` (Traps.h) before use.
- Branch: `native-5d` off main. Merge only on request.

## File map

| File | Role |
|---|---|
| `clarusc/shake.cla` (new) | IR tree-shake: reachability marks over `irFuncs` |
| `clarusc/asm68k.cla` (new) | instruction table, encoder, backpatch, listing printer |
| `clarusc/cg68k.cla` (new) | IR → instruction streams; layout model; ARC layer; synthesized startup |
| `clarusc/app68k.cla` (new) | segmentation packing, CODE 0/JT, resource fork, MacBinary |
| `clarusc/parse.cla`, `ast.cla`, `check.cla`, `ir.cla`, `lower.cla` | trap/inline clause syntax through to the extern registry |
| `clarusc/cprint.cla` | consume shake marks; redirect to `core.cla`; otherwise untouched |
| `clarusc/main.cla` | `emit68k` subcommand, `--listing`; manifest adds `core.cla`/`native.cla` |
| `runtime/clarus/core.cla` (new) | lasterr, panic seam, arr check, enum-from-int, fixed mul/div |
| `runtime/clarus/native.cla` (new) | capture-protocol console, quit/panic/args, File Manager I/O (emit68k-only) |
| `runtime/clarus/{str,text,list,map,ser}.cla` | trap clauses on waist externs; panic/lasterr redirect; ser de-C |
| `internal/asm68k/` (new) | vasm round-trip Go harness |
| `internal/cg68k/` (new) | listing-golden Go harness + determinism test; fixtures `testdata/cg68k/` |
| `internal/mactest/native_test.go` (new) | hello/smoke/suite/runerr/abort boots of emit68k builds |
| `scripts/build-68k.sh` (new) | snapshot-bootstrapped clarusc → `emit68k` → `.bin` |

---

## Phase A — host groundwork (no 68k code yet; every task fully verified by existing harnesses)

### Task 1: IR tree-shake pass

**Files:**
- Create: `clarusc/shake.cla`
- Modify: `clarusc/cprint.cla` (`cpEmitFuncs` :3683, `cpFuncProto` loop, default-init protos), `clarusc/main.cla` (call site after `lowerProgram`, :581)
- Test: existing gauntlet (differential is the oracle: an under-marked function = C link error, immediately red)

**Interfaces:**
- Produces: `func shakeProgram()` (run after `lowerProgram`, before any
  backend; fills a `shakeMarks: list of bool` parallel to `irFuncs`),
  `func shakeReachable(f: int): bool` (cprint and later cg68k consult it),
  and `func shakeAddRoot(nameIdx: int)` (extra roots registered BEFORE
  `shakeProgram()` — unused by the C path, but emit68k must root functions
  cprint never calls: the `nat*` family and `rtEnumCheck`; see Tasks 7/11).

- [ ] **Step 1: Write `shake.cla`.** Worklist reachability over `irFuncs` by
  interned name. Roots: `handler_App_*` per `irHasLaunch`/`irHasStartEmpty`/
  `irHasStartCLI`/`irHasOpenDocument`; every handler name in `irWinHandlers`,
  `irMenuHandlersHead` chain, `irEveryHead` chain, and widget-handler
  entries; every `ECallFn` target inside `irGlobals` init expressions.
  Walking a body: `ECallFn` name → mark + enqueue; `EIntr` name and operand
  type kinds → mark the runtime redirect targets cprint would emit for that
  intrinsic (build one table mirroring `fpIntrCall`'s `cp*Ported` arms:
  e.g. `IStrConcat`→`rtStrConcat`, `IRetain`/`IRelease`/`I*FreeVar` per kind
  → `rt{Text,List,Map}{Retain,Release,Free}`, container ops → their
  `rtList*`/`rtMap*`/`rtText*` functions, plus the walk-internal helpers
  `rtListAt`/`rtListCount`/`rtMapValAt`/`rtMapCount`/`rtStrCmp` whenever any
  container ARC or map op is present). Over-approximation is fine;
  under-approximation is a link error. Also mark everything reachable from
  marked runtime functions (same walk — they are ordinary `IRFunc`s).
- [ ] **Step 2: Consume marks in cprint.** `cpEmitFuncs` skips proto+body of
  unmarked functions; skip matching default-init protos. UI wiring, rc
  walks, layouts, enums are untouched (they are keyed by `irRcWalkNeeded`/
  `irLayoutNeeded`, not the function walk).
- [ ] **Step 3: Wire `shakeProgram()` into `main.cla`** between
  `lowerProgram` and `emitProgram` (:581-582).
- [ ] **Step 4: Gauntlet.** Expect large mechanical churn in
  `clarusc/clarusc.c` (snapshot shrinks — unused runtime functions vanish)
  and `emitui` goldens. Zero `.leaks`/CLRD churn. `TestSnapshotBuilds` must
  stay green (proves the shaken snapshot still contains everything clarusc
  itself reaches).
- [ ] **Step 5: Quick Mac sanity:** `CLARUS_MAC_TESTS=1 go test
  ./internal/mactest -run TestSuiteOnMac`.
- [ ] **Step 6: Commit logic; commit re-bless.**

### Task 2: Trap and inline clauses on `external func`

**Files:**
- Modify: `clarusc/parse.cla` (`parseExternFuncDecl` :1315-1348),
  `clarusc/ast.cla` (slot doc :137-141, `newExternFuncDecl` :1329),
  `clarusc/check.cla` (`checkExternFunc` :1766), `clarusc/ir.cla` (extern
  registry :622-690), `clarusc/lower.cla` (`lowExternDecl` :4590),
  `docs/clarus-language-reference.md` (Ch13, replacing the "reserved"
  note at :1357), `internal/reftest/manifest.go` (`ClaruscOnly` for new
  fenced examples)
- Test: string-embedded cases in `clarusc/test/check_test.cla`; reference
  fences; gauntlet

**Interfaces:**
- Produces grammar: `externDecl = "external" "func" IDENT "(" [params] ")"
  [":" type] [ "=" ("trap" INTLIT ["reg"] | "inline" ("deref"|"nop")) ]`.
  `trap`/`reg`/`inline`/`deref`/`nop` are contextual identifiers (the
  `external` precedent — no new tokens). AST: trap word or inline code in
  slot `c` (currently hardcoded -1), convention flag in `intVal`
  (0 = none, 1 = pascal trap, 2 = reg trap, 3 = inline deref, 4 = inline
  nop). IR: sixth/seventh parallel arenas `irExternTrapWords` /
  `irExternConvs`, `irRegisterExtern` widened, accessors
  `irExternTrap(i): int` / `irExternConv(i): int`.
- Consumes: hex literals (lexer already handles `0xA122`).

- [ ] **Step 1: Parser.** After the optional return type, accept the clause;
  produce a widened `newExternFuncDecl(nameIdx, paramsHead, retType,
  trapVal, convFlag, line, col)`. Update every existing caller.
- [ ] **Step 2: Checker.** In `checkExternFunc`: trap word must be in
  `0xA000..0xAFFF` (diag `"trap word must be in 0xA000..0xAFFF"`); `reg`
  requires ≤2 ptr params and ≤2 scalar params (the A0/A1+D0/D1 rule);
  `inline deref` requires exactly `(h: ptr): ptr`; `inline nop` requires
  void return.
- [ ] **Step 3: IR + lower.** Register the clause; `fpCallExt`/
  `cpEmitExternProtos` in cprint remain byte-identical for clause-less
  externs and IGNORE clauses (verify emitted C for a claused decl matches
  the clause-less emission exactly).
- [ ] **Step 4: Reference + fences.** Ch13 section with the clause grammar,
  the reg register-assignment rule, and one example each (trap reg, trap
  pascal, inline deref, inline nop). New fence indices → `ClaruscOnly`.
- [ ] **Step 5: Tests + gauntlet.** check_test cases: valid reg trap, bad
  trap word, reg with 3 ptr params (error), deref with wrong signature
  (error). Gauntlet + snapshot re-bless (parser/checker changed). Commit.

### Task 3: Port the runtime core leaves to Clarus (`core.cla`)

**Files:**
- Create: `runtime/clarus/core.cla`
- Modify: `clarusc/main.cla` (manifest: `core.cla` first, unconditional;
  new flag `cpCorePorted`), `clarusc/cprint.cla` (redirect arms),
  `runtime/clarus/{str,text,list,map,ser}.cla` (drop `*SetLastErr`/
  `*Panic` externs → call `rtSetLastErr`/`rtPanic`),
  `internal/build/rt/rt_ext_host.inc` + `runtime/mac/rt_ext_mac.inc`
  (delete the 10 dropped shims; add `rt_ext_CorePanic`)
- Test: gauntlet (differential is the oracle; fixed-point math pinned by the
  existing fixed fixtures in the run corpus; `emit_array`/`emit_enum`/
  runerr fixtures pin the panic paths)

**Interfaces:**
- Produces (in `core.cla`, spliced before all other runtime modules):
  - globals `var lasterrCode: int`, `var lasterrMsg: str 255`
  - `func rtSetLastErr(code: int, msg: str 255)`
  - `func rtLastErrCode(): int`, `func rtLastErrMsg(): str 255`
  - `func rtPanic(msg: str 255)` — body is one call to the waist:
    `external func CorePanic(msg: string)` (host shim → `rt_panic`;
    native resolution via `nat_CorePanic`, Task 11). Never returns.
  - `func rtArrCheck(i: int, n: int): int` — bounds check, panic
    `"array index out of range"`, else return `i`.
  - `func rtEnumCheck(v: int, found: bool, name: str 255): int` — panics
    `"no enum member with value"` when `found` is false, else returns `v`.
    Decision: only the check/panic logic is shared; the linear scan stays
    per-backend (cprint keeps C `rt_enum_from_int` over its C tables;
    cg68k emits the scan inline over pool data, Task 12). Simplest shared
    surface — avoids marshalling per-enum static tables into Clarus.
  - `func rtFixMul(a: int, b: int): int`, `func rtFixDiv(a: int, b: int): int`
    — bit-exact ports of `rt_core.inc:176-189` (16.16; C uses int64_t).
    Algorithm for mul: extract signs, split |a|,|b| into 16-bit halves,
    combine partial products `(ah*bh)<<16 + ah*bl + al*bh + ((al*bl)>>16)`
    with unsigned handling via the sign-split (all intermediates fit 32
    bits after the split), reapply sign — matching C's truncation exactly.
    Div: sign-split, then 32-iteration binary long division of the 48-bit
    `|a|<<16` by `|b|`, reapply sign. The differential corpus fixed-point
    fixtures are the bit-exactness oracle.
- Consumes: nothing from other runtime modules (it is spliced first).

- [ ] **Step 1: Write `core.cla`** per the interface above. `rtPanic`
  prefixes nothing — the `"runtime error: "` prefix stays in the platform
  sink (`rt_panic` host / `nat_CorePanic` native) so host bytes are
  unchanged.
- [ ] **Step 2: Redirect cprint** under `cpCorePorted`: `ILastErrCode`
  (:2314) → `clar_fn_rtLastErrCode()`; `ILastErrMsg`/`ILastErr`
  (:2320-2329) → `clar_fn_rtLastErrMsg()`; `fpIndexRef`'s Arr arm
  `rt_arr_check` (:1016) → `clar_fn_rtArrCheck`; `IFixMul`/`IFixDiv`
  (:1496/:1498) → `clar_fn_rtFixMul`/`rtFixDiv`. `rt_enum_from_int`
  (:1192) stays C on the host path (decision above). Every `rt_set_lasterr`
  writer inside remaining C (`rt_core.inc`) is unaffected — C and Clarus
  lasterr state would diverge ONLY if both wrote; audit: after this task
  the only remaining C writers are in C-only paths never linked when
  `cpCorePorted` (verify by grep, document in the task report).
- [ ] **Step 3: Drop the 10 `*SetLastErr`/`*Panic` externs** from the five
  runtime modules; call `rtSetLastErr`/`rtPanic` directly (core is spliced
  first — declare-before-use holds). Delete the shims from both `.inc`
  files; add `rt_ext_CorePanic` to both (host: `rt_panic((const char*)…)`
  with Str255→C-string copy; Mac: same via its rt_panic).
- [ ] **Step 4: Gauntlet + Mac suite run.** Zero `.leaks`/CLRD churn;
  snapshot + emitui re-bless. Commit logic; commit re-bless.

### Task 4: ser.cla stops calling C list/map

**Files:**
- Modify: `runtime/clarus/ser.cla` (10 externs at :58-66 → direct Clarus
  calls), `internal/build/rt/rt_ext_host.inc` + `runtime/mac/rt_ext_mac.inc`
  (delete the 10 shims), `clarusc/main.cla` (manifest: when `ser.cla` is
  needed it must now be spliced AFTER `str/text/list/map`, since it calls
  their functions — reorder to `core, str, text, list, map, ser` and update
  the comment)
- Test: `go test ./internal/sertest` (CLRD goldens byte-stable is the whole
  point), then gauntlet

**Interfaces:**
- Consumes: `rtListCount`/`rtListAt`/`rtListClear`/`rtListPush` and
  `rtMapCount`/`rtMapKeyAt`/`rtMapValAt`/`rtMapSet`/`rtMapClear` from
  wave-1/2a modules (exact names per `runtime/clarus/{list,map}.cla` — the
  implementer verifies each exists with a compatible signature; any missing
  one (e.g. a `Clear`) is ported in this task following the family's
  existing style, C original as the oracle).

- [ ] **Step 1: Replace each `SerList*`/`SerMap*` call site** in ser.cla
  with the Clarus call; delete the extern decls; delete both shim sets.
- [ ] **Step 2: Reorder the manifest** and re-check the splice comment in
  `main.cla:499-560`.
- [ ] **Step 3: sertest + gauntlet + snapshot/emitui re-bless. Commit ×2.**

## Phase B — the instruction layer (host-only, no IR involvement)

### Task 5: `asm68k.cla` — table, encoder, listing printer

**Files:**
- Create: `clarusc/asm68k.cla`
- Create: `clarusc/test/asm68k_test.cla` + `clarusc/test/asm68k_test.out`
  (auto-discovered by `internal/selfhost/driver_test.go:44`)

**Interfaces:**
- Produces (all state module-global, arena-style like ir.cla):
  - `enum A68Op { OpMove, OpMovea, OpLea, OpPea, OpAdd, OpAdda, OpAddq,
    OpSub, OpSubq, OpCmp, OpNeg, OpAnd, OpOr, OpEor, OpNot, OpAsl, OpAsr,
    OpLsl, OpLsr, OpMuls, OpMulu, OpDivs, OpDivu, OpTst, OpExt, OpSwap,
    OpBra, OpBcc, OpBsr, OpJsr, OpJmp, OpLink, OpUnlk, OpRts, OpScc,
    OpClr, OpDbra }` — grown on demand, never a full ISA catalog.
  - `enum A68Mode { AmNone, AmDn, AmAn, AmInd, AmPostInc, AmPreDec,
    AmDisp16, AmPCLabel, AmImm, AmAbsW }`
  - `func a68Reset()`, `func a68NewLabel(): int`, `func a68Bind(l: int)`
  - `func a68Emit(op: A68Op, size: int, sm: A68Mode, sr: int, sv: int,
    dm: A68Mode, dr: int, dv: int)` — size 1/2/4; `sv`/`dv` carry the
    immediate, displacement, or label id (for AmPCLabel).
  - `func a68EmitBr(op: A68Op, cc: int, target: int)` — Bcc/BRA/BSR,
    always `.W`, backpatched.
  - `func a68EmitTrap(word: int, name: str 63)` — encodes the word,
    lists `DC.W $Axxx  ; _Name`.
  - `func a68DcB(v: int)`, `a68DcW(v: int)`, `a68DcL(v: int)`,
    `a68DcBytes(t: text)`, `a68Align()` (even), `a68Comment(s: str 255)`
  - `func a68Finish(): bool` — resolve labels, apply backpatches; false =
    unresolved label (caller panics with the label id).
  - `func a68Bytes(): text`, `func a68ListingText(): text`,
    `func a68Size(): int` (valid after Finish; also
    `func a68SizeSoFar(): int` mid-stream for packing).
- Encoding recipes live in ONE table (per-op: base word, size-field
  placement, legal mode classes, extension-word rule) consulted by both the
  encoder and the printer — nothing outside the table writes raw words.

- [ ] **Step 1: Write the module.** Instruction arena records
  `{op, size, sm, sr, sv, dm, dr, dv, label, kind}` (kind: instr / bind /
  data / trap / comment). Encoder pass 1 lays out (all sizes are
  context-free because branches are `.W`), pass 2 emits big-endian words
  into a `text` and patches label displacements.
- [ ] **Step 2: Listing printer** from the same arena: Motorola syntax
  (`MOVE.L (A7)+,D0`, `LINK A6,#-8`, `LBL_12:` labels, `DC.W`/`DC.B`,
  `; comment`). Every listing line derives from the table entry — no
  free-form strings for instructions.
- [ ] **Step 3: `asm68k_test.cla`**: build a stream exercising every op ×
  every legal mode class at least once (the exerciser doubles as Task 6's
  vasm input), print `a68ListingText()` then a hex dump of `a68Bytes()`
  (16 bytes/line via alert). Bless `asm68k_test.out` by running it, then
  eyeball-verify a sample of encodings against the 68000 Programmer's
  Reference (spot-check at minimum: MOVE.L D1,-(A7); LEA 8(A6),A0;
  BNE.W fwd; JSR 42(A5); MULS.W D1,D0; LINK A6,#-100; DC.W $A122).
- [ ] **Step 4: `go test ./internal/selfhost -run TestClarusModules`, then
  gauntlet.** (No snapshot churn — asm68k.cla is not yet included from
  main.cla.) Commit.

### Task 6: vasm round-trip oracle

**Files:**
- Create: `internal/asm68k/vasm_test.go`, `internal/asm68k/exercise.cla`
  (a tiny program: includes `clarusc/asm68k.cla`, builds the SAME exerciser
  stream as `asm68k_test.cla` — extract the stream builder into
  `asm68k.cla` itself as `func a68SelfExercise()` so the two tests cannot
  drift — then `file.writeText("exer.s", a68ListingText())` and
  `file.writeText("exer.dat", a68Bytes())`)

**Interfaces:**
- Consumes: `a68SelfExercise()` (added to asm68k.cla in this task),
  `build.Build` (Go compiler builds exercise.cla — asm68k.cla is
  Go-subset), `vasm/vasmm68k_mot`.

- [ ] **Step 1: Refactor the exerciser** into `a68SelfExercise()`; update
  `asm68k_test.cla` to call it (golden unchanged).
- [ ] **Step 2: Go test**: skip unless `../../vasm/vasmm68k_mot` stats
  (mirror `requireMac`'s pattern); build+run exercise.cla in a temp dir;
  run `vasmm68k_mot -quiet -m68000 -no-opt -Fbin -o out.bin exer.s`;
  byte-compare `out.bin` vs `exer.dat`, reporting the first divergent
  offset with a hex window.
- [ ] **Step 3: Fix every divergence** (encoder or printer — the table is
  wrong either way). Gauntlet. Commit.

## Phase C — codegen to first boot

### Task 7: `emit68k` skeleton — layout model, frames, startup, listing goldens

**Files:**
- Create: `clarusc/cg68k.cla`
- Modify: `clarusc/main.cla` (subcommand `emit68k -o OUT.bin [--rtdir DIR]
  [--listing] FILE...`; same manifest as emit plus — from Task 11 on —
  `native.cla`; calls `shakeProgram()` then `cg68Program(...)`; usage
  strings :252/:278/:322), `clarusc/asm68k.cla` only if a missing op/mode
  surfaces
- Create: `internal/cg68k/golden_test.go`, `testdata/cg68k/globals.cla`,
  `testdata/cg68k/arith.cla` + `.s` goldens

**Interfaces:**
- Produces (cg68k.cla):
  - `func cg68Program(outPath: str 255, listing: bool): bool` — top-level;
    for now single-segment, no output container (Task 10): with
    `--listing`, writes `<OUT>.seg1.s` and `<OUT>.seg1.dat` via
    `file.writeText`; returns false on any diagnostic-worthy failure after
    `log`-ing the reason.
  - Layout helpers (THE type-size authority for the native world; cprint
    has none — C laid types out): `func cgSizeOf(t: int): int`,
    `func cgAlignOf(t: int): int` (2 for everything ≥ 2 bytes, 1 for
    byte types), `func cgFieldOffset(recName: int, fieldName: int): int`.
    Sizes: int/fixed/ptr/enum/text/list/map/winref = 4; bool/char = 1
    (occupying 2 in any aggregate or stack slot); `str N` = N+1 rounded
    even; `arr N of T` = N × padded elem; records = fields in declaration
    order, each at its alignment, total rounded even.
  - Before shaking, register the emit68k-only roots via `shakeAddRoot`:
    every `nat*` function name and `rtEnumCheck` (cprint never calls them,
    so default reachability would drop them from native builds).
  - Per-function scaffolding: JT-slot assignment (`cgJtSlot(f): int`,
    declaration order over `shakeReachable` functions), local/param frame
    offsets (params from 8(A6) upward in push order — pushed
    left-to-right means the LAST arg is at 8(A6); locals + spill temps at
    negative offsets), `LINK A6,#-frame` / `UNLK A6; RTS` bracket.
  - Synthesized startup (JT entry 0, first function of CODE 1): zero the
    below-A5 world (`LEA -below(A5),A0` + clear loop), `_MaxApplZone`,
    `_MoreMasters`, `JSR` generated `cg_init_globals` (evaluates each
    `irGlobal` init expr — Task 8's expression codegen; until then emit
    only the zeroing), `JSR clar-startup handlers per irHas* flags`,
    `JSR cg_free_globals`, `PEA`/push 0, `JSR natQuit` (by-name via JT;
    errors cleanly if native.cla absent — wired in Task 11; until then the
    golden fixtures stop at RTS).
  - Constant-pool machinery: per-segment pools for string literals
    (`irStrLits` entries as `DC.B len, bytes`, even-aligned), enum value
    tables, serdesc tables; `cgPoolStrRef(litIdx): int` returns a label.
- Consumes: `shakeReachable`, all ir.cla accessors (§ the exploration
  report), `a68*`.

- [ ] **Step 1: CLI arm + module skeleton** with the layout helpers and a
  walk that emits, per reachable function, prologue + `; TODO body` comment
  + epilogue, plus the startup stub and pools.
- [ ] **Step 2: Golden harness**: `internal/cg68k/golden_test.go` builds
  clarusc via the memoized `buildClarusc()` pattern
  (`internal/selfhost/differential_test.go:28`), runs
  `clarusc emit68k -o out.bin --listing <fixture>` in a temp dir, compares
  `out.seg1.s` against `testdata/cg68k/<name>.s`; `CLARUS_CG68K_BLESS=1`
  regenerates. Fixtures: `globals.cla` (an int + a str global with
  initializers, empty launch handler), `arith.cla` (placeholder body —
  grows in Task 8).
- [ ] **Step 3: Gauntlet** (snapshot re-bless: main.cla now includes
  shake/asm68k/cg68k). Commit ×2.

### Task 8: Expression, statement, and call codegen

**Files:**
- Modify: `clarusc/cg68k.cla`
- Modify/Create: fixtures `testdata/cg68k/{arith,control,calls,strs}.cla`
  + `.s` goldens; extend `internal/cg68k/golden_test.go` with a vasm
  round-trip sub-test (assemble every emitted `.segN.s`, byte-compare vs
  `.segN.dat` — gated on vasm presence)

**Interfaces:**
- Produces: `cgExpr(e: int)` — evaluates any IRExpr into D0 (address-taking
  variants `cgExprAddr` for str/record/lvalue shapes into A0), naive
  discipline: binary ops evaluate left, `MOVE.L D0,-(A7)`, evaluate right,
  `MOVE.L (A7)+,D1`, operate D1→D0. `cgStmt(s: int)` / `cgStmts(head)`
  over all 11 IRStmtKinds. `cgCallFn(e)` implementing the convention
  (args pushed left-to-right, `ADDQ/ADDA` caller cleanup, hidden result
  pointer for >4-byte returns, by-value block copies for str/record args
  via a `cgBlockCopy(size)` helper emitting a `MOVE.W`-loop or unrolled
  moves ≤16 bytes).
- Key semantics to mirror exactly (from the exploration report):
  short-circuit `and`/`or` (lowering does NOT do it — branch-based, mirror
  `fpAndOr` cprint.cla:1111); `EBin`/`EUn` names are operator SPELLINGS
  (mirror `cOp` :1026 as a spelling→op table); comparisons via
  `CMP` + `Scc D0; AND.L #1,D0`; `EConv` per `IRConvOp` — the nine
  unchecked convs here; `CvIntToEnum` (needs enum pool tables) defers to
  Task 12, where the inline scan sets a found flag and calls
  `rtEnumCheck(v, found, name)`; `SForRange`/`SForList`/`SForMap` loop
  shapes with `SBreak`/`SContinue` label stacks; `SStoreStr` → call
  `rtStrStore`-family per kind (same targets cprint's redirected arms
  call); 32-bit multiply/divide/modulo via three hand-emitted helper
  routines (`cg_mul32`, `cg_div32`, `cg_mod32` — MULU partial products /
  binary long division, emitted once into segment 1, called like normal
  functions but with both operands in D0/D1 and no frame).

- [ ] **Step 1: Implement in this order, extending fixtures as each lands:**
  const/var/assign → arithmetic + helpers → comparisons + short-circuit +
  if/while/for-range → function calls (all four result shapes: void, D0
  scalar, str-by-hidden-pointer, record-by-hidden-pointer) → SStoreStr +
  str ops that Task 3/wave-1 made plain Clarus calls.
- [ ] **Step 2: Every fixture's listing golden reviewed by hand once**, then
  locked; the vasm sub-test proves listing↔bytes agreement on all of them.
- [ ] **Step 3: Gauntlet + snapshot/emitui re-bless. Commit ×2.**

### Task 9: ECallExt — trap inlining, inline clauses, peek/poke, nat-fallback

**Files:**
- Modify: `clarusc/cg68k.cla`; `runtime/clarus/{str,text,list,map,ser}.cla`
  (add trap clauses to the Memory-Manager/BlockMove externs; `inline deref`
  on `*HandleDeref`; `inline nop` on `*RcCheck`)
- Create: fixture `testdata/cg68k/traps.cla` (declares a reg trap + a
  pascal trap + deref + nop externs, calls each) + `.s` golden

**Interfaces:**
- Produces: `cgCallExt(e)` dispatching on `irExternConv(i)`:
  - reg trap: evaluate args into A0/A1/D0/D1 per the fixed rule (evaluate
    all to stack first, then pop into registers — naive but
    clobber-safe), emit the A-line word, result from A0 or D0.
  - pascal trap: reserve result slot (`CLR.W`/`CLR.L -(A7)` when a result
    exists), push args left-to-right (long for int/ptr, word for
    bool/char, address for str), A-line word, pop result.
  - `inline deref` / `inline nop` per the locked decision.
  - no clause: resolve `nat_<Name>` via `findIRFuncIdxByName`; hard error
    `"extern <name> has no trap clause and no nat_ fallback"` otherwise.
  - `IPeekB/W/L`, `IPokeB/W/L` intrinsics inline as
    `MOVEA.L addr,A0; MOVE.<sz> (A0),D0` (+ zero-extend for B/W) and the
    store mirror.
- Consumes: trap words verified against Traps.h (Global Constraints list).

- [ ] **Step 1: Implement + clause the runtime externs.** cprint emission
  for those modules must remain byte-identical (clauses ignored) — assert
  via zero diff in emitted C for a wave-1 fixture before/after.
- [ ] **Step 2: Fixture + golden + vasm round-trip. Gauntlet (snapshot
  re-bless: runtime .cla changed → emitted C in snapshot unchanged, but
  clarusc parser changed nothing this task — expect zero snapshot churn
  unless cg68k.cla edits; re-bless as needed). Commit.**

### Task 10: `app68k.cla` — single-segment app image + MacBinary

**Files:**
- Create: `clarusc/app68k.cla`
- Modify: `clarusc/cg68k.cla` (`cg68Program` hands segments to app68k and
  writes the final image with `file.writeText`)
- Create: `internal/cg68k/image_test.go` (host-only: parses the emitted
  `.bin`'s MacBinary header + resource fork structurally; plus the
  determinism test: emit the same fixture twice into different dirs,
  byte-compare the `.bin`s)

**Interfaces:**
- Produces (app68k.cla):
  - `func app68Build(appName: str 31, creator: str 7, segBytes: list of
    text, jtEntries: list of int, belowA5: int): text` — returns the full
    MacBinary bytes: 128-byte MacBinary II header (name, type `APPL`,
    creator, data fork 0, resource fork length, header CRC), then the
    resource fork padded to 128.
  - Resource fork: header (data offset 256, map offset/lengths), resource
    data (each resource: 4-byte length + payload), map (type list: `CODE`
    0..n, `SIZE` -1; ref lists; no names). `SIZE` -1: flags word
    (canBackground off, MultiFinder-aware off — plain System 6 app),
    preferred/minimum 384KB.
  - CODE 0: above-A5 = 32 + 8×jtCount, below-A5, JT length, JT offset 32,
    then per-function 8-byte unloaded entries
    `{offset.W, $3F3C, segNum.W, $A9F0}`.
  - CODE n: 4-byte header {first JT entry offset.W, entry count.W} + code.
- Consumes: `a68Bytes()` streams per segment from cg68k.

- [ ] **Step 1: Implement; wire into `cg68Program`.** Single segment for
  now (`segBytes.count == 1` beyond startup is fine — packing is Task 15).
- [ ] **Step 2: `image_test.go`**: Go-side structural parse (offsets
  self-consistent, CODE 0 JT entries point inside CODE 1, SIZE present,
  MacBinary CRC valid) + the double-emit determinism byte-compare.
- [ ] **Step 3: Gauntlet + re-bless. Commit ×2.**

### Task 11: `native.cla` console + the first boot

**Files:**
- Create: `runtime/clarus/native.cla`
- Modify: `clarusc/main.cla` (emit68k manifest appends `native.cla` last),
  `clarusc/cg68k.cla` (intrinsic arms `IAlert`→`natAlert`, `ILog`→`natLog`,
  `IQuit`→`JSR cg_free_globals; push code; JSR natQuit`; startup calls
  `natInit` before `cg_init_globals` and ends `push 0; JSR natQuit`)
- Create: `internal/mactest/native_test.go` (`TestHelloOn68k`),
  `testdata/cg68k/hello.cla` (`on App.launch { alert("hello, 68k") }`)

**Interfaces:**
- Produces (native.cla — the capture protocol of `rt_mac.c:83-253`,
  byte-identical trailer):
  - `func natInit()` — PB via `NatPtrNew` (its own `= trap 0xA11E reg`
    NewPtr extern); `_Create` name `"out"` vRefNum 0 (dupFNErr ignored),
    `_Open` → cache refnum in a global, `_SetEOF` 0. All File Manager
    calls are `= trap ... reg` externs taking `(pb: ptr): int` with the
    PB fields poked at the Inside-Mac ioParam offsets (ioNamePtr 18,
    ioVRefNum 22, ioPermssn 27, ioRefNum 24, ioBuffer 32, ioReqCount 36,
    ioPosMode 44, ioPosOffset 46, ioMisc 28 — verify against Files.h).
  - `func natAlert(s: str 255)` — CR→LF + trailing LF (mirror
    `rt_test_crlf` semantics), `_Write` + `_FlushVol`.
  - `func natLog(s: str 255)` — same rendering, appended to a `text`
    buffer global.
  - `func natQuit(code: int)` — writes `##CLARUS-EXIT## <code>` + LF +
    `##CLARUS-LOG##` + LF + log buffer, `_Close`, `_FlushVol`,
    `_ExitToShell` (pascal trap, no args). Guard global against double
    trailer.
  - `func nat_CorePanic(msg: str 255)` — `"runtime error: " + msg` + LF
    into the log buffer, then the natQuit(3) tail WITHOUT
    `cg_free_globals` (matches host: panic skips cleanup).
  - `func natArgsList(): list of str 255` — empty list (matches
    `rt_mac.c:269-274`).
- Consumes: peek/poke + `ptr` (native.cla is NOT Go-subset — it is never
  compiled by the Go compiler; it must still CHECK cleanly under clarusc).

- [ ] **Step 1: Write native.cla; wire manifest + cg68k arms.**
- [ ] **Step 2: `TestHelloOn68k`** in native_test.go: `requireMac(t)`;
  build clarusc (memoized); `clarusc emit68k -o hello.bin hello.cla`;
  `RunMac(t, bin, 5*time.Minute)`; assert exit 0 and output
  `"hello, 68k\n"` via the existing `parseCapture`. **This is the
  walking-skeleton milestone — expect debugging.** MacsBug-less debugging
  tools: the listing (`--listing`), and byte-diffing suspect segments in
  the emulator via screenshots per CLAUDE.md if it bombs. Iterate until
  green.
- [ ] **Step 3: Full gauntlet + gated `TestHelloOn68k` + `TestSuiteOnMac`
  (host path untouched — confirm). Commit ×2.**

## Phase D — full language coverage natively

### Task 12: Records, enums, and per-type data

**Files:**
- Modify: `clarusc/cg68k.cla`
- Create: fixtures `testdata/cg68k/{recs,enums}.cla` + goldens; extend
  `internal/mactest/native_test.go` with `TestNativeSmoke` boot running a
  new `testdata/cg68k/smoke.cla` (record ctor/field/assign, enum conv
  round-trip, printed via alert — host-expectation computed by building
  the same file with the GO compiler via `build.Build` and running it,
  like `RunSuiteHost`)

**Interfaces:**
- Produces: `ENewRec` (zero/default-init a frame or heap slot per
  `IRFieldSlot` defaults — mirror `cpDefaultInit` :3074 semantics),
  `EFieldRef` addressing (`cgFieldOffset`), record by-value copies,
  record rc-walk generation (`cg_retain_<Rec>`/`cg_release_<Rec>` emitted
  for every `irRcWalkNeeded` record, mirroring `cpEmitRcWalks` element
  logic but calling the Clarus family functions), enum pool tables +
  checked `CvIntToEnum` inline scan (Task 3's shape), `cg_init_globals` /
  `cg_free_globals` completed (init exprs now compile; free = release
  handle-bearing globals, mirroring `cl_free_globals`).
- Consumes: `irRecHasHandleField` (ir.cla:720) as THE handle-backed test.

- [ ] **Step 1: Implement; goldens + vasm round-trip.**
- [ ] **Step 2: `TestNativeSmoke`** green under the emulator (records +
  enums section).
- [ ] **Step 3: Gauntlet + re-bless. Commit ×2.**

### Task 13: Containers and the ARC layer

**Files:**
- Modify: `clarusc/cg68k.cla`
- Create: fixture `testdata/cg68k/arc.cla` + golden; extend `smoke.cla`
  (list/map/text section: push/pop/set/get/remove/iterate, nested
  containers, the adversarial shapes from the 5c′ matrix in miniature)

**Interfaces:**
- Produces:
  - `EIntr` dispatch for every non-UI intrinsic: nearly all become plain
    calls to the runtime IRFuncs (wave-1/2a + core made them Clarus);
    the arm table mirrors `fpIntrCall`'s redirect targets one-for-one.
    UI intrinsics → hard error `"UI intrinsics are 5e (native): <name>"`.
  - The four ADDRESSING shapes (cprint.cla:993-1010) as native addressing
    codegen — deref list box → handle → master via the same overlay
    offsets the Clarus runtime pokes, bounds check via `rtArrCheck`-style
    inline + `rtPanic` on OOB, then scaled index (`cgSizeOf(elem)`):
    `fpIndexRef` list arm, `IListSet`/`IListSetRetain` element store,
    `IListRemove` old-value read, `SForList` per-iteration deref.
    (The `fpUiEditStmt` arms are UI → 5e.)
  - The statement-temp ARC layer, mirroring cprint's tracked-temp
    discipline (`fpNewTmp`/`fpStmtTmps`/`fpFreeStmtTmps` :212-279):
    handle-bearing intermediate results land in dedicated frame slots,
    released at statement end unless the statement is terminal
    (return/break/continue) or ownership was handed off — port the RULES,
    not the strings; the decision table of which expressions produce
    tracked temps must match cprint arm-for-arm (function-call results
    with handle types, `IMapGetDvBirth`, container accessors' `_retain`
    variants, …).
  - `IRetain`/`IRelease`/`I*FreeVar` → calls to
    `rt{Text,List,Map}{Retain,Release,Free}`/record walks per operand
    kind (mirror `cpEmitRetain`/`cpEmitRelease` per-kind arms).
- Rc-parity note for the reviewer: host `.leaks` gates verify these same
  IR shapes leak-free through cprint; native shares the IR and the
  runtime — the mirror is audited by review + the over-release cold path
  (RcCheck → inline nop natively, but `rc <= 0` release panics come from
  the Clarus guard itself and DO surface in the capture).

- [ ] **Step 1: Implement intrinsic dispatch + addressing shapes.**
- [ ] **Step 2: Implement the ARC temp layer; document the arm-for-arm
  audit table in the task report** (cprint site → cg68k site).
- [ ] **Step 3: Goldens + vasm; `TestNativeSmoke` (containers section)
  green; runerr-shaped probes (oob/emptypop/mapmiss run transiently as
  native boots to confirm panic paths) — not yet committed as tests
  (Task 16 owns the gate). Gauntlet + re-bless. Commit ×2.**

### Task 14: Native file I/O

**Files:**
- Modify: `runtime/clarus/native.cla`, `clarusc/cg68k.cla` (arms
  `IFileReadText`/`IFileWriteText`/`IFileName` → `natFileReadText`/
  `natFileWriteText`/`natFileName`)
- Extend: `smoke.cla` (write/read/binary-roundtrip/file.name section —
  the `binroundtrip.cla` shapes)

**Interfaces:**
- Produces (native.cla): `func natFileWriteText(name: str 255, t: text):
  bool` (`_Create` ignore-dup, `_Open`, `_SetEOF` 0, `_Write` from the
  text's bytes, `_Close`), `func natFileReadText(name: str 255, out:
  text): bool` (`_Open`, `_GetEOF`, sized reads into out, `_Close`; false
  on any error, mirroring `rt.c:107-153` semantics incl. lasterr sets via
  `rtSetLastErr`), `func natFileName(path: str 255): str 255` (pure
  Clarus basename scan — port of `rt_file_name`), plus fallbacks
  `nat_SerFileWriteData` / `nat_SerFileReadTextInto` (same PB code, ptr
  path arg) so a native file.save/load program compiles and runs even
  though no emulator test covers it in 5d (recorded gate limit).
- [ ] **Step 1: Implement; smoke section green under the emulator.**
- [ ] **Step 2: Gauntlet + re-bless. Commit ×2.**

## Phase E — segmentation and the gate

### Task 15: Segmentation and the jump table for real

**Files:**
- Modify: `clarusc/cg68k.cla` (two-pass: measure every function's encoded
  size standalone, then pack first-fit in declaration order into ≤32,760-
  byte segments — pool bytes counted; emit per segment with intra-segment
  `BSR.W` for same-segment callees and `JSR d16(A5)` otherwise;
  per-segment `_LoadSeg`-compatible CODE headers from app68k),
  `clarusc/app68k.cla` (multi-CODE resource map)
- Create: `internal/cg68k/segment_test.go`

**Interfaces:**
- Produces: `cg68Program` emits N segments; oversized single function →
  `log("function <name> exceeds the 32KB segment limit")` + failure exit
  (compile error, not a crash — spec requirement).
- [ ] **Step 1: Implement measure→pack→emit.** Determinism: packing input
  is declaration order of shaken functions; no size-dependent reordering.
- [ ] **Step 2: `segment_test.go`**: compile `testdata/suite/test_suite.cla`
  with emit68k on the host — assert it produces >1 CODE segment, every JT
  entry resolves into its segment, per-segment vasm round-trip on all
  `.segN.s`/`.segN.dat` pairs, plus the double-emit determinism
  byte-compare on the multi-segment image. Also a synthetic oversized-
  function fixture asserting the named compile error.
- [ ] **Step 3: Gauntlet + re-bless. Commit ×2.**

### Task 16: The end gate + docs

**Files:**
- Create: `scripts/build-68k.sh` (bootstrap clarusc from the snapshot
  exactly like `build-mac.sh` step 1 — cached on `clarusc.c` mtime — then
  `$CLARUSC emit68k -o build-68k/$NAME/$NAME.bin "${FILES[@]}"`)
- Modify: `internal/mactest/native_test.go`: `TestSuiteOn68k` (host
  expectation from the existing `RunSuiteHost`, native build of
  `testdata/suite/test_suite.cla` via build-68k.sh, `RunMac` 15 min,
  byte-compare via `parseCapture` — exit 0), `TestRunErrOn68k` (the 6
  `testdata/runerr/*.cla` against their `.err` goldens, exit 3),
  `TestAbortOn68k` (`emit_array`, `emit_enum` against `.out`/`.exit`)
- Modify: `docs/ROADMAP.md` (5d entry: outcomes, timing vs the
  `TestSuiteOnMac` Retro68-built baseline, the three recorded gate
  limits), `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`
  (Outcomes section, as-built deltas), memory files per convention

- [ ] **Step 1: build-68k.sh + the three tests; iterate to green.** Full
  run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'On68k'
  -timeout 60m`.
- [ ] **Step 2: Full gauntlet + full gated mactest** (all existing Mac
  tests AND the new native ones in one run; record wall-clock).
- [ ] **Step 3: Timing:** record TestSuiteOn68k wall-clock and the suite
  app's boot-to-exit versus TestSuiteOnMac's (gcc -O2 baseline: 5c′ full
  suite 172.7s / Bookmarks 10.27s per ROADMAP). No pass/fail threshold in
  5d — the number seeds the peephole/regalloc phase's buy-back target.
  Record it honestly in the ROADMAP entry.
- [ ] **Step 4: Docs + final commits.** ROADMAP 5d entry, spec Outcomes,
  the three gate limits, and the 5e-input inventory (UI intrinsics +
  `fpUiEditStmt` arms + uisnaps-from-native).

---

## Self-review (performed at planning time)

- **Spec coverage:** direct binary emission via table (T5), listing printer
  + Motorola syntax (T5), vasm ring 2 (T6, T8, T15), trap clauses incl.
  cprint-ignores (T2, T9), C-style convention (T8), naive stack codegen
  (T7-T13), `.W` branches + backpatch (T5), determinism (T10, T15 tests),
  tree-shake (T1), segmentation + JT + oversized error (T15), resource
  fork + MacBinary host container (T10), Mac-side trap container writing
  is 5f (clarusc doesn't run on the Mac until then — out of scope here, as
  the spec's container section implies), end-gate suite + abort/runerr
  (T16), 5d-input inventory closure (T3, T4, T9, T11, T13, T14; UI arms
  deferred to 5e per spec).
- **Type/name consistency:** `shakeReachable`/`a68*`/`cg*`/`app68Build`/
  `nat*` names used consistently across tasks; `rtPanic`/`rtSetLastErr`/
  `rtArrCheck`/`rtFixMul` defined in T3 before first native use in T8/T13.
- **Known open risks, owned by tasks:** trap-word/PB-offset verification
  (Global Constraints + T9/T11), first-boot debugging (T11 explicitly
  budgets it), ARC mirror audit (T13's arm-for-arm table).
