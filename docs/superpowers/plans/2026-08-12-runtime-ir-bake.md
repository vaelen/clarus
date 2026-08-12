# Runtime IR Bake Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bake the runtime's post-lower IR into a stamped, loadable artifact so each compile runs only user code through expand/lex/parse/check/lower; check#2 is retired; ClarusC.APPL loads the bake by default.

**Architecture:** One superset runtime image (17 modules on the 68k lane) lowered at `--bake-ir` time, serialized as flat big-endian sections (IR arenas + intern pool + lowering counters + checker symbols), reloaded at arena base 0 per compile with a version stamp; user code lowers on top. From-source compiles ALSO move to the superset splice so byte-identity between the two paths holds by construction. Spec: `docs/superpowers/specs/2026-08-12-runtime-ir-bake-design.md` (normative — read first). Research inventory backing every task: this plan cites it inline; the full report lives in the brainstorm session record, and Task 1 re-verifies its load-bearing claims.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), host C runtime, Retro68/Mini vMac emulator lane.

## Global Constraints

- Branch: create `runtime-ir-bake` from `param-abi` HEAD before Task 1.
- MacRoman discipline (three incidents in the param-abi phase): before every Edit, verify the exact target lines are pure ASCII (`sed -n 'X,Yp' FILE | LC_ALL=C grep -n '[^\x00-\x7f]'` empty); otherwise `LC_ALL=C sed`; scan every diff for `EF BF BD` before committing. `ir.cla`, `lower.cla`, `drive.cla`, `check.cla` all contain MacRoman bytes in comments.
- T1 (`scripts/test-task.sh`) after every task; `--smoke` when runtime/ or codegen paths change (Tasks 2, 4, 5, 6). Bootstrap snapshot regen happens ONCE, in Task 7 (T1 excludes selfhost, so intermediate stale-snapshot is fine).
- Byte-identity is the phase oracle: `emit68k --rtbake` output must equal from-source `emit68k` output byte-for-byte on the same input (both on the superset splice after Task 2). Any divergence is a STOP-and-investigate, never a re-bless.
- Serialized byte layout: explicit one-byte-at-a-time big-endian (the reference's own guidance for byte layouts that leave the process — reference:1411); `file.writeText`/`readText` are byte-clean verbatim (reference:1323), `file.readResource` has no size cap (`natReadResource` sizes dynamically, native.cla:943-979).
- The `--bake-ir` generator and `--rtbake` loader are lane-tagged: the 68k-lane bake covers 17 modules (all of runtime/clarus/ except `datetime_c.cla`); the cprint-lane bake swaps `datetime_68k.cla` for `datetime_c.cla`. The stamp includes the lane tag; loading a wrong-lane bake is a refused-stamp error.
- Log the model used for every subagent dispatch (Andrew's standing request).

---

### Task 1: Probe wave — verify the load-bearing assumptions, freeze the inventory

**Files:**
- Create: nothing committed except the report; probes live in the SDD workspace/scratch
- Test: probes are their own deliverable; T1 must stay green (no product change)

**Interfaces:**
- Produces: `task-1-report.md` with (a) PASS/FAIL per assumption, (b) the frozen serialization inventory table, (c) golden-churn forecast for Task 2, (d) any plan amendments (this task MAY amend later tasks — record amendments in the ledger and the report; the controller reviews them before Task 2 dispatches).

- [ ] **Step 1: Superset-splice experiment (the Task 2 rehearsal)**

Locally hack `driveManifestSplice` (drive.cla:1114-1345) to splice ALL 17 68k-lane modules unconditionally (ignore `isUiProg`/`usesFileSaveLoad`/`usesSortedMap`/`usesDateTime` gates; keep `datetime_68k.cla` vs `datetime_c.cla` lane selection). Build and run:
- `emit68k` across `testdata/cg68k/*.cla` and the core+toolbox suite builds — record which compile cleanly and which break (the ui+ser+uitest superset has never been lowered together in one program: research Q7 — the closest existing build, `TestCoreSuiteGUIOn68k`, covers ui+ser+native but not uitest/sortedmap/datetime simultaneously).
- Measure per-fixture fork-size delta and A5/global-space delta vs today's subset splice (does `cgAssignGlobalOffsets` assign offsets to unreachable module globals? Read cg68k.cla to answer, then measure). Record the worst case (a tiny non-UI program like tickprobe carrying ui+ser globals).
- DECISION GATE recorded in the report: if fork bloat or A5 pressure on small programs is unacceptable (e.g. tickprobe fork grows by more than ~10% or any segment/A5 budget nears its ceiling), Task 2 gains a sub-step: shake-aware global/descriptor emission (only reachable-referenced globals get A5 slots). Do NOT implement here — measure, decide, amend.

- [ ] **Step 2: check#2-adds-nothing verification**

With today's compiler (no hacks): for every corpus program (testdata/cg68k, testdata/emitui, suites, examples, clarusc self-compile), run the normal pipeline and a probe build where `driveManifestSplice`'s `checkProgram(combined2)` call (drive.cla:1339) is skipped. Compare: (a) diagnostics emitted, (b) final fork/C bytes. Byte-identical everywhere + no diagnostic differences = assumption PASS (check#2 exists to check the runtime, which the bake pre-checks). Any divergence: identify the mechanism (a check#2-populated table lower reads? research Q4 lists the checker tables lower consumes: `exprTypeOf` (43 sites), `windowIsForm`, `windowFormRecType`, `windowVarsHead`, `windowWidgetsHead`, `menuItems`, `fieldInfos`, `widgetInfos` — note these are populated for USER constructs during check#1 too; the question is whether any RUNTIME-decl entry matters to USER lowering) and record the narrowed claim + plan amendment.

- [ ] **Step 3: Appless runtime-chain viability (the bake generator's pipeline)**

The generator must check+lower a runtime-only chain with no user program and no `app` declaration. Probe: build a chain of the 17 modules alone, run `checkProgram` + `lowerProgram` on it. Record every failure (`appDeclSeen` enforcement? entry-point requirements? window/menu absence?) and the minimal accommodation (e.g. a generator-only flag suppressing the app-required check). Also verify the research claim that the runtime chain contributes ZERO entries to the progGen-namespaced never-reset maps (`uiMenuIdx`, `uiWinHandlersIdx`, `winVarDefaults` — user constructs only; runtime modules declare no menus/windows) — grep + probe.

- [ ] **Step 4: Freeze the serialization inventory**

Produce the authoritative table from the research baseline, verified against HEAD:
- ir.cla: every arena/scalar `irReset` (ir.cla:1039-1289) resets EXCEPT the ~162 lazy-intern `iXxxIdx` scalars (re-derived, not baked) — list each with element record shape and field widths.
- lib.cla: `strPool`/`strIndex` (the intern pool — baked; user interning appends/dedups on top).
- lower.cla program-wide counters that MUST be captured (research Q2, collision hazard confirmed): `lowSwitchN`, `uiMenuCount`, `lowStoreTempN`, `lowRetTempN`; populated-state maps `lowStrIdx`, `uiMenuItemIdx`, `lowTitleIdx`. Per-function scratch (lowScopes etc.): reset-state only, not serialized.
- types.cla/check.cla symbol state for the testapi preload: `symbols`, `scopes`, `funcSigs` (+ `typeArena`, `enumMembers`) — record shapes from types.cla:562-653.
- drive/codegen scalar flags consumed downstream (research Q8): `cpSerPorted`/`cpSortedMapPorted` mirrors, app name/icon resolution (drive.cla:1150-1178 reads USER AST — stays live, unaffected), `want68k`. Record which become constants on the bake path (superset ⇒ ported flags always true).
- `curPathIdx` diagnostics stamps for baked decls.

- [ ] **Step 5: Report, revert probes, commit nothing but ledger notes**

Write the report; revert all probe hacks (`git checkout -- .`); T1 green to prove the tree is untouched.

---

### Task 2: Superset splice on the from-source path (both lanes)

**Files:**
- Modify: `clarusc/drive.cla` (`driveManifestSplice` 1114-1345, `driveEarlySplice` 967-979), `clarusc/cprint.cla` (ported-flag handling if needed)
- Test: goldens re-blessed (cg68k + emitui), suites, T1 `--smoke`

**Interfaces:**
- Consumes: Task 1 Step 1's measurements and decision (possibly adds shake-aware global emission here — if so, the controller amends this task's brief from the Task 1 report before dispatch).
- Produces: from-source compiles always splice the full lane superset; `usesFileSaveLoad`/`usesSortedMap`/`usesDateTime`/`isUiProg` splice gates retired (checker flags may remain for other consumers — verify each consumer before deleting the flag itself); goldens at the new baseline that Task 4's byte-identity oracle compares against.

- [ ] **Step 1: Make the splice unconditional**

In `driveManifestSplice`: replace the conditional `neededMods` assembly (drive.cla:1199-1236) with the full lane list (68k: the 12 non-early modules incl. `sortedmap.cla`, `datetime.cla`, `datetime_68k.cla`, `ser.cla`, `native.cla`, plus the ui* set when not early-spliced; cprint lane: `datetime_c.cla` instead). `uitest.cla` stays `--testapi`-gated (it is a test API, not runtime — confirm with the spec; the bake carries it so the testapi path works, but from-source non-testapi programs must NOT see it: **the one module kept conditional**, and the bake loader must hide its decls from non-testapi user checks the same way — note for Task 5). Set `cpSerPorted`/`cpSortedMapPorted` unconditionally true.

- [ ] **Step 2: Rebuild, run the corpus, fix what the superset breaks**

Task 1 Step 1's probe forecast the breakage list. Fix for real whatever the superset-lowered runtime needs (these are genuine latent issues — e.g. name/ordering collisions between modules never before co-spliced). Each fix is ordinary reviewed code.

- [ ] **Step 3: Re-bless goldens, characterize churn**

```bash
CLARUS_CG68K_BLESS=1 go test ./internal/cg68k/... -count=1
# emitui: regenerate per internal/emitui/emitui_test.go's exact flags
```
Churn should be: added runtime code/globals in every fixture (superset), plus offset/slot shifts. Characterize; anything else = investigate.

- [ ] **Step 4: Gates + commit**

`scripts/test-task.sh --smoke`; host core CLI 63/63; leak gate. Commit: "feat: unconditional superset runtime splice (runtime-ir-bake Task 2)".

---

### Task 3: The serializer — `--bake-ir` host mode

**Files:**
- Create: `clarusc/bake.cla` (serializer + shared format constants; new module, included by main.cla)
- Modify: `clarusc/main.cla` (mode flag), `clarusc/drive.cla` (runtime-only chain assembly for the generator; appless accommodation per Task 1 Step 3)
- Test: determinism gate + a Go-side unit test (`internal/selfhost` or a new `internal/bake` package) asserting bake-twice-identical and stamp layout

**Interfaces:**
- Consumes: Task 1's frozen inventory; Task 2's superset splice (the generator lowers exactly the superset chain).
- Produces: `clarusc --bake-ir --lane 68k --rtdir runtime/clarus/ -o FILE` writes the artifact. Format (all multi-byte values big-endian, written byte-at-a-time):

```
magic 'CLIR' (4)  | formatVersion (4) | laneTag (1: 0=68k 1=c) |
stampLen (2) | stamp bytes (hash of generating clarusc identity) |
moduleCount (2) | per module: keyLen (1) + key bytes ("runtime/clarus/core.cla" form, rtModuleKey scheme drive.cla:532) |
sectionCount (2) | per section: sectionId (2) + byteLen (4) + payload
```

Sections (ids frozen in bake.cla constants): one per IR arena in irReset order, intern pool, irStrLits+lowStrIdx state, lowering counters block, checker-symbol block (symbols/scopes/funcSigs/typeArena/enumMembers), curPathIdx stamp table. Records serialize field-by-field in declaration order; bool as 1 byte; every int as 4 bytes BE.

- [ ] **Step 1: Write the serializer against the inventory** (mechanical: per-arena loops emitting bytes into a `text` buffer, then `file.writeText`).
- [ ] **Step 2: Determinism + stamp tests** — bake twice, byte-compare; corrupt a stamp byte, loader-side refusal is Task 4's test but write the fixture now.
- [ ] **Step 3: T1 green (no behavior change to normal compiles); commit.**

---

### Task 4: The loader — `--rtbake FILE` on the host emit paths

**Files:**
- Modify: `clarusc/bake.cla` (loader half), `clarusc/main.cla` (flag), `clarusc/drive.cla` (bake-path pipeline: skip splice/check#2/runtime-lower; install arenas; user-only lower on top)
- Test: NEW T1 gate `internal/bake/bakeidentity_test.go` — for a fixture slice (≥6 cg68k fixtures incl. tickprobe + one UI + self-compile), `emit68k --rtbake` vs from-source byte-identical

**Interfaces:**
- Consumes: Task 3's artifact; Task 2's superset baseline (identity target).
- Produces: the bake-path pipeline: load+verify stamp → install arenas at base 0 (fresh per compile — install = deserialize into the just-reset arenas; the leak gate's DoubleCompile discipline applies) → expand/lex/parse user → check#1 → lower user appending at base N (counters resume from baked end-values) → shake → codegen. `combined2`/manifest machinery bypassed on this path.

- [ ] **Step 1: Loader + install** (mirror of the serializer; stamp/lane refusal with clear diagnostics).
- [ ] **Step 2: Pipeline wiring in driveCompile** (drive.cla:1359-1486): bake path branches after phase A; check#1 unchanged; `irReset()` then install; `lowerProgram` variant that skips the runtime chain (user chain only) with counters restored.
- [ ] **Step 3: Byte-identity slice gate green; leak gate on the bake path (host DoubleCompile variant with --rtbake); T1; commit.**

---

### Task 5: Completeness — testapi preload, include-dedup, diagnostics, fallback, full corpus

**Files:**
- Modify: `clarusc/bake.cla`, `clarusc/drive.cla`, `clarusc/check.cla` (symbol preload entry)
- Test: full-corpus byte-identity (all cg68k fixtures, emitui via cprint-lane bake, both suites, self-compile); checker tests for testapi visibility

**Interfaces:**
- Consumes: Tasks 3-4.
- Produces: (a) `--testapi --rtbake`: baked checker symbols preloaded so user code names `UiTest*` (and ONLY testapi does — non-testapi user check must not see ANY runtime symbol: assert with a negative test); (b) user `include` of a runtime file dedups against the bake's module-key manifest; the hoisting case (user file pulled into runtime chain) triggers documented from-source fallback for that compile; (c) runtime-attributed diagnostics name the right file via the baked curPathIdx table; (d) cprint-lane bake (`--lane c`) + `emit --rtbake` identity across emitui corpus.

- [ ] Steps: implement each, with a test per produced behavior (testapi positive + non-testapi negative; dedup fixture; a forced runtime panic path naming the file; fallback fixture), then the full-corpus identity run, T1 `--smoke`, commit.

---

### Task 6: Mac integration — `'CLIR'` resource, ClarusC.APPL default

**Files:**
- Modify: `clarusc/cg68k.cla` (generalize the bake-resource writer cg68k.cla:11714-11758 to carry typed blobs — CLFS source AND one CLIR artifact), `scripts/build-clarusc-mac.sh` (add `--bake-ir` generation + flag), `clarusc/macgui.cla` (gcCompile loads CLIR by default; CLFS-source fallback when absent or stamp-refused, with a Log line saying which path ran)
- Test: emulator — build ClarusC.APPL with the baked resource, boot, compile tickprobe on the emulator via the bake path, byte-compare its fork vs the host `--rtbake` fork (existing mactest byte-compare harness pattern)

**Interfaces:**
- Consumes: Tasks 3-5.
- Produces: ClarusC.APPL whose per-compile pipeline is user-only + baked runtime; `natReadResource`'s never-release behavior means the CLIR handle stays resident once loaded per process (research Q5) — installs must copy out of it, never alias it across compiles.

- [ ] Steps: writer generalization → script wiring → macgui load path → emulator verification → T1 `--smoke` → commit.

---

### Task 7: Close-out — perf, snapshot, docs, T2

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `STATUS.md`, `docs/ROADMAP.md`, findings/notes docs
- Test: full `internal/selfhost`; full T2 (`scripts/test-merge.sh`)

- [ ] **Step 1:** Snapshot regen to fixed point; selfhost green (`-timeout 30m`, background the run).
- [ ] **Step 2:** Perf evidence, 10-pair interleaved medians: host `emit68k clarusc/macgui.cla` from-source (superset) vs `--rtbake`; host self-compile likewise; peak RSS both modes. Record raw pairs.
- [ ] **Step 3:** Docs: ROADMAP phase entry (template: param-abi's), STATUS.md, precompiled-artifacts notes doc (mark stage complete, point at 3.5 next), spec annotations if Task 1 narrowed any claim.
- [ ] **Step 4:** Full T2. Commit.

---

## Verification summary

| Oracle | Task(s) | Proves |
|---|---|---|
| Task 1 probe report | 1 | assumptions verified, not assumed; inventory frozen |
| Golden re-bless (reviewed) | 2 | superset baseline is the intended change only |
| Bake determinism + stamp refusal | 3, 4 | artifact integrity |
| Byte-identity slice → full corpus | 4, 5 | bake path ≡ from-source, both lanes |
| testapi positive + non-testapi negative | 5 | symbol visibility exactly preserved |
| Leak gate on bake path | 4 | reset discipline holds under install/reload |
| Emulator fork byte-compare | 6 | Mac bake path ≡ host bake path |
| Perf table + T2 | 7 | the point, and merge-readiness |
