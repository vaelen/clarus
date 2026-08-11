# Cross-compile degradation findings — 2026-08-12

Root-cause investigation of the Snow observation (live-log phase ledger,
reruns 1-2 of `TestMacResidentClaruscOnSnow`): in one `ClarusC.APPL`
process, compile #2 (`catprobe.cla`) runs 2x-7x slower than compile #1
(`tickprobe.cla`) across EVERY phase — whole-program check 35m vs 5m
(~7x), Lowered ~1.7x, Measure 2h20m vs 36m (~4x), seg-1 emit 49m vs 20m
(~2.4x) — and, on the pre-layer1 build, compile #2 died OOM in the 48MB
partition.

**Verdict: clarusc leaks ~42,000 Memory Manager blocks (~20k of them
nonrelocatable NewPtr boxes) per compile — every compile, on both lanes,
rc=1 (missing release, not over-retain). On the Mac these dead-but-live
blocks stay threaded through the one 48MB heap zone that is set up once
per process (`MaxApplZone` at startup, never compacted or reset), so
compile #2's ~1.24M allocation traps each pay to walk/compact around
compile #1's litter. The host shows the same leak (block counts below)
but no slowdown — malloc doesn't degrade with a fragmented heap the way
the classic Memory Manager's zone walk does — which is exactly the
observed signature: host flat, Mac 2-7x.**

## Evidence chain (all reproducible on host, no emulator needed)

Probe harness: `clarusc/test/dblcompile.cla` (uncommitted) — runs the
exact `macgui.cla` `gcCompile` sequence (`driveReset`/`resetDiags`/
`astReset` → `driveCompile` → `driveEmit68kFork`) N times in one host
process, one argv entry per compile.

1. **Host timing is flat** (8 alternating tickprobe/catprobe compiles:
   1-3 ticks each, no trend) → not a Clarus-level algorithmic growth.
2. **Live-block growth is linear**: `CLARUS_MEM_STRICT=1` exit ledger
   after 1 vs 3 compiles of the SAME file (intern-pool dedup active):
   37,970 → 123,660 live blocks, i.e. **+42,845 blocks (+0.94MB) per
   compile**, split per compile: **+19,423 lists** (`rt_ext_ListNewPtr`/
   `ListNewHandle` pairs, almost all EMPTY — 0-byte handles), **+695
   maps**, **+262 texts**.
3. **rc=1 on essentially every leaked box** (diagnostic rc-dump patch,
   `scratchpad/rtmem-diag.patch`) → missing release of the birth
   reference, not an unbalanced retain.
4. **Backtrace attribution** (same patch, `-DRT_MEM_BACKTRACE`):
   73,904 of 80,815 leaked blocks over 2 compiles born in
   `clar_fn_cgIntr`; 4,837 in `clar_fn_checkFuncSig`; the rest spread
   over `cgEmitPoolsBody`/`cgEmitFunc`/`cgEmitStoreStr`/`expand`/etc.
5. Host RSS growth (~18MB/compile) is a red herring: ~17MB of it is the
   host-only rt_mem ledger keeping a node per allocation forever
   (double-dispose detection). Mac-relevant retention is the ~1MB/42k
   blocks above.

## Root cause 1 (dominant, ~18.5k lists/compile): synthetic `__store`
## temps' prologue births leak on every path that doesn't consume them

- Lowering (`lowCountedStore`, lower.cla) mints a synthetic
  `__storeN` local per counted-store site (via `lowAddLocal`).
- BOTH backends unconditionally default-init every declared local at
  function entry (`cpEmitFunc`/`cpDefaultInit`, cprint.cla; mirrored by
  `cgEmitFunc`'s `cgDefaultInitAt` loop, cg68k.cla:4770-4774) — for a
  container local that is a real birth: `rtListNew` (NewPtr+NewHandle on
  the native lane).
- The scope-exit free list (`lowFreeNames`) is built by
  `lowCollectScopeExitCandidates` from `blockVarsHead(bodyBlk)` — the
  body's OWN `var` decls only. Synthetic store temps are never added.
- A store temp's prologue birth is only released at its own store site
  (release-before-overwrite, then nulled after ownership transfer). Any
  `return` path that doesn't execute that site leaks the birth: emitted
  `cgIntr` has 14 container locals born in its prologue (args, addrs,
  `__store359..370`), ~40 returns, and each call takes ONE arm — so
  ~11-12 empty lists leak per `cgIntr` call, ~770 calls per pass, twice
  (Measure + emit) per compile.
- Minimal repro: `clarusc/test/stemp.cla` — two arms, each with its own
  counted store; 1000 calls → exactly 1000 leaked empty lists (rc=1).
  Sibling probes proving what does NOT leak: `earlyret.cla` (early
  return releases user locals), `paramleak.cla` (container args
  balanced), `voidret.cla` (bare return in void func fine),
  `untouched.cla` (never-used locals released), `leakprobe.cla` (global
  reassignment releases old).
- Pre-dates layer1 (ARC-port era machinery) → consistent with the
  pre-layer1 Snow run's compile-#2 OOM.

## Root cause 2 (~2k blocks/compile): `.clear()` releases no elements,
## and some cleared/reset containers hold reference elements

`rtListClear`/`rtMapClear` are documented hard resets — count=0, **no
element release** (safe only for scalar elements). Confirmed leak vector
by probe `clarusc/test/clearprobe.cla`: `.clear()` on a
`list of list of int` leaks all 1000 inner lists; the compiler accepts
it silently. Sites that leak per compile:

- `funcSigs.clear()` (`scopesReset`, types.cla:710): `FuncSig.params:
  list of int` (types.cla:562-563) — ~1.2k lists/compile (matches the
  `checkFuncSig` attribution).
- `scopes.clear()` (same reset): `Scope.names: intmap of int`
  (types.cla:640-642) — ~0.7k maps/compile (matches the +695).
- `a68DataTexts: list of text` (asm68k.cla:208), cleared by `a68Reset`
  once per Measure pass AND once per segment — ~262 texts/compile.
- Host-lane cousins: `cpTypeBuf`/`cpLitBuf`/`cpRecBuf`/`cpUiBuf`/
  `cpRestBuf`/`fpBody`/`fpStmtTmps`/`fpStmtTmpRel` (all `list of text`,
  cprint.cla) — same class, host `emit` only.
- The layer1 phase's pop-loop→`.clear()` conversion (70 sites) widened
  exposure of this class; the pop-loops it replaced did release.

## Root cause 3 (unbounded growth, smaller): deliberately-never-reset
## tables (see agent survey, this session)

- `strPool`/`strIndex` (lib.cla:7-8) — documented "unbounded but
  harmless"; benign for repeat compiles of the same source (dedup), but
  every new distinct name/string across compiles stays forever.
- `menuItems`/`externFirstDeclByName` (check.cla) — `progGen`-namespaced
  keys, guaranteed-fresh per compile, never freed; per-access key
  concatenation cost grows with `progGen`.
- `irColumnDescs` (ir.cla:688) — populated via `.add()` (ir.cla:2374)
  but MISSING from `irReset`'s clear list; looks like an oversight
  (every sibling descriptor arena is cleared there).
- Assorted never-reset maps documented correctness-safe
  (`windowIsForm`, `funcScopeByDecl`, `shakeFuncIdxByName`,
  `irRcWalkNeededByName`, `irLayoutNeededByName`, ...).

## Fix directions (for the design discussion — costs are honest)

1. **Root cause 1 — preferred: don't birth synthetic store temps.**
   Mark lowering's `__store` temps no-prologue-birth (IR-level local
   flag both backends honor); default-init them to NULL/0 instead. The
   store-site release-before-overwrite is already NULL-safe (the hazard
   the unconditional init fixed was stack GARBAGE, not NULL). Also a
   straight perf win: removes thousands of pointless birth traps per
   compile on the Mac. Alternative (smaller but costly): add store
   temps to `lowFreeNames` — correct (they're nulled after transfer,
   release-of-NULL is safe) but bloats every return site with releases
   (~40 returns x 14 releases in cgIntr alone → real 68k code-size risk
   against 32KB segment ceilings).
2. **Root cause 2 — make `.clear()` honest at the language level**: the
   compiler statically knows the element type; emit a deep-clear
   (element release walk, then reset) for ref-bearing element types and
   keep the O(1) hard reset for scalar elements. Closes every current
   and future site at once; no per-site audit debt. (Cheap alternative:
   fresh-reassign at the two types.cla reset sites + a68DataTexts, and
   leave `.clear()` a documented footgun.)
3. **Root cause 3 — leave for Layer 2/3** except the one-line
   `irColumnDescs` addition to `irReset` (bug, not policy).

## Validation plan

- Host: rerun `dblcompile` 1-vs-3 ledger diff → expect ~0 block growth
  per compile (strPool/strIndex only).
- T1 + `--smoke`, cg68k goldens (expect churn: prologue-init changes
  native codegen; emitui goldens likewise for the cprint side).
- Snow: rerun the two-compile acceptance — expect compile #2 ≈ compile
  #1 per-phase times, and the ~4x-shorter total run STATUS.md step 0
  predicted.

## Diagnostics kept

- Probes: `clarusc/test/{dblcompile,leakprobe,clearprobe,earlyret,
  paramleak,voidret,untouched,stemp}.cla` (uncommitted; outside the
  `*_test.cla` glob `internal/selfhost/modules_test.go` consumes).
- Runtime diagnostic patch (rc dump + `-DRT_MEM_BACKTRACE` attribution +
  `CLARUS_MEM_NOCLEAN`): `rtmem-diag.patch` in this session's scratchpad
  — reverted from the working tree; reapply for fix-phase verification.
