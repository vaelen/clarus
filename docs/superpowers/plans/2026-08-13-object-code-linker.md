# Object Code + Link Pass (stage 3.5) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Runtime function bytes ship in the CLIR artifact (v6) with
relocation tables; per compile, Measure measures user functions only and
the per-segment emit pastes runtime bytes through a68's existing fixup
machinery — byte-identical to from-source output.

**Architecture:** Approach A from the spec (normative, read first):
`docs/superpowers/specs/2026-08-13-object-code-linker-design.md`. Grow
CLIR v5→v6 with 68k-lane object sections (per-function bytes + reloc
table + the Measure metadata `cg68Measure` produces today); `--bake-ir
--lane 68k` gains a codegen step capturing them; compile-time
`cg68Measure` skips baked functions and `cg68ProgramFork`'s segment loop
pastes bytes with re-registered a68 label fixups. A5 displacements bake
in (position-stable, no reloc). Shake, lane c, and all
fallback-trigger-narrowing behavior unchanged.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), host C
runtime, Go test harness (`internal/bake`, `internal/mactest`), Mini
vMac/Snow emulator lanes.

## Global Constraints

- Branch: `precompiled-artifacts` (exists, from main `e143af1`; spec at
  `aa439ad`).
- MacRoman discipline: before every Edit to an existing `.cla`, verify
  target lines are pure ASCII (`sed -n 'X,Yp' FILE | LC_ALL=C grep -n
  '[^\x00-\x7f]'` empty), else `LC_ALL=C sed`; pre-commit `git diff |
  LC_ALL=C grep -c $'\xef\xbf\xbd'` must be 0. `drive.cla`, `check.cla`,
  `macgui.cla`, `cg68k.cla` contain MacRoman comment bytes.
- Byte-identity is the oracle: `--rtbake` output ≡ from-source output
  byte-for-byte, full corpus, both suite compositions, both consumers.
  Divergence = STOP-and-investigate, never re-bless. From-source output
  must be byte-untouched by this phase.
- CLIR format version `bkFormatVersion` (bake.cla:60) bumps 5→6 exactly
  once (Task 2). Artifacts never committed; no compat shim; loader
  refuses non-6 via the existing message path. New sections are written
  on BOTH lanes (empty on lane c) so the header's `bkSectionCount`
  round-trip check stays lane-uniform.
- T1 (`scripts/test-task.sh --smoke`) after every task (all tasks touch
  `clarusc/`). Snapshot regen ONCE, in Task 4. Full T2 in Task 4.
- Standing rule: `bake.cla` changes ⇒ manual `CLARUS_SNOW_TESTS=1`
  `TestClarusCBakePathOnSnow` before merge (Task 4; controller runs it
  post-final-review at the true tip, with Measure timings captured).
- Log each subagent's model at dispatch (standing request).
- Scout-verified citations at `e143af1`: `cg68Measure` per-function
  outputs cg68k.cla:1022-1148, Measure loop:11835-12190,
  `cgAssignGlobalOffsets`:2173-2204 (called once at :11848),
  `cgJtDisp`:2142-2144, `cgCallFunc`:2161-2167, segment loop
  `cg68ProgramFork`:12368-12556 (per-func scan :12474-12481, JT fill
  :12503-12514), pool labels `cgPoolStrRef`:11301-11306 (unbound-label
  contract :11314-11319), `bkInstallArenas` irGlobals prefix
  bake.cla:3055 / truncation :3020-3035, `bkSectionCount = 44`
  bake.cla:200, section write list ~:1472-1516, read loop ~:2627-2635.
  Task 1 re-verifies the load-bearing ones.

---

### Task 1: Probe wave — verify the three load-bearing assumptions

**Files:**
- Create: nothing committed; probes live in the SDD workspace. Report:
  `<workspace>/task-1-report.md`.
- Test: T1 green after probe revert proves the tree untouched.

**Interfaces:**
- Produces: PASS/FAIL per assumption with evidence; the COMPLETE hole
  taxonomy (every a68 label-operand / position-dependent site class in
  runtime function bytes — expected: JT displacements, pool-label
  PC-relatives, same-segment function-call PC-relatives, plus any
  glue-routine label references (mul32/div32/mod32 family, installed
  per-segment before emission) the spec's three-kind list folds into
  the same-segment class); the chosen capture representation (how
  bake-time codegen records bytes + holes: a68's own fixup records vs.
  emitter-side recording) and the chosen paste mechanic (raw-data
  stream + re-registered label fixups vs. alternative); amendments to
  Tasks 2-3 if an assumption fails.

- [ ] **Step 1: Re-verify citations at HEAD** (Global Constraints list
  above). Record drift.
- [ ] **Step 2: Hole-completeness probe.** Build the two-stage boot
  (`cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c
  runtime/host/rt.c`; `build-run/clarusc emit --rtdir runtime/clarus/
  -o /tmp/s2.c clarusc/main.cla && cc -O1 -I runtime/host -o /tmp/c2
  /tmp/s2.c runtime/host/rt.c`). Hack a diagnostic mode (local, never
  committed) that dumps per-function Measure-pass bytes + a68 fixup
  site lists. Dump once in a runtime-only universe (mimicking bake
  time: compile a trivial fixture, dump only baked-index functions)
  and once in a real user compile (the toolbox suite composition,
  `--testapi`, and a non-UI fixture). Diff per-function bytes with
  hole positions masked. Identical outside holes for EVERY runtime
  function = assumption 1 PASS. Any unmasked diff site = a hole class
  the spec missed — characterize it, extend the taxonomy, and record
  the amendment.
- [ ] **Step 3: Paste-mechanics probe.** Extend the hack: for one real
  segment containing both runtime and user functions, replace
  `cgEmitFunc(i)` for the runtime functions with a paste of the
  Step-2-captured bytes + re-registration of their fixup sites against
  the live labels, then `a68Finish` and byte-compare the segment
  against an untouched build. Identical = assumption 2 PASS. Report the
  exact a68 entry points used (this becomes Task 3's design).
- [ ] **Step 4: testapi truncation symmetry.** Confirm the baked
  function set's base-vs-testapi boundary (`bkLdBaseIrFuncsCount`,
  bake.cla:1810-1814) cleanly partitions the object capture too: dump
  in a testapi universe, confirm base-prefix functions' bytes are
  IDENTICAL to the non-testapi dump (if not, testapi objects need
  separate capture — record the amendment).
- [ ] **Step 5: Report, revert (`git checkout -- .`),
  `scripts/test-task.sh` green.**

---

### Task 2: Artifact v6 — serializer, bake-time codegen, loader

**Files:**
- Modify: `clarusc/bake.cla` (`bkFormatVersion` 5→6 at :60; new section
  constants `bkSecObjCode = 48`, `bkSecObjMeta = 49`; `bkSectionCount`
  44→46 at :200; writer additions in the `bkEmitSection` list
  ~:1472-1516; reader branches ~:2627-2635 into `bkLd*` staging;
  install function `bkInstallObjCode` + retained boundary global
  `bkRuntimeFuncBoundary`), `clarusc/main.cla` (bake-ir mode: invoke
  the capture step for `--lane 68k`), `clarusc/cg68k.cla` (the capture
  entry point — a bake-only emission mode producing per-function bytes
  + hole records, per Task 1's chosen representation).
- Test: `internal/bake/bake_test.go` (version/section-count expectations
  5→6, 44→46), existing corpus green.

**Interfaces:**
- Consumes: Task 1's capture representation, hole taxonomy, and testapi
  symmetry verdict.
- Produces: `bkSecObjCode` — per reachable runtime function: byte blob
  (length-prefixed) + reloc entries `{offset, kind, symIdx}` with kinds
  `bkRelocJt = 1` (symIdx = target func index), `bkRelocPool = 2`
  (symIdx = pool entry class + index, encoding per Task 1),
  `bkRelocSameSeg = 3` (symIdx = target func index or glue id).
  `bkSecObjMeta` — per function: size, frame size, pool-ref sets
  (strLits/enumTables/serdescs indices + uiBlob/uiEvents flags); plus
  the once-per-artifact fixed buckets (`cgSeg1ExtraSize`,
  `cgGlueBundleSize`, `cgPoolSize`) and per-pool-entry size tables
  (`cgStrLitSize`-family). Both sections written on lane c as empty
  (count 0). Loader stages into `bkLdObj*`; `bkInstallObjCode` installs
  post-acceptance only; `bkRuntimeFuncBoundary : int` global = the
  installed runtime function count (set in `bkInstallArenas`, respecting
  the existing non-testapi truncation — object entries truncate
  symmetrically with the IR truncation at bake.cla:3020-3035).

- [ ] **Step 1: Serializer + capture.** Wire the bake-ir 68k path to run
  the capture emission per runtime function (Task 1's mechanics) after
  the existing check+lower; write both sections. Lane c writes them
  empty. Bump version + section count.
- [ ] **Step 2: Loader.** Read both sections into `bkLd*` staging
  (staging convention — no live-global writes mid-parse, per the
  fallback-trigger-narrowing review's staging note); `bkInstallObjCode`
  installs after acceptance; set `bkRuntimeFuncBoundary` in
  `bkInstallArenas`.
- [ ] **Step 3: Update `bake_test.go`** version/section expectations;
  add a corrupt-object-section refusal case following the existing
  truncated-section test pattern (loader must refuse via the existing
  message path, never crash or half-install — the v4 body hash already
  rejects most corruption; the test targets a structurally-valid body
  with an out-of-range reloc symIdx, which the reader must refuse).
- [ ] **Step 4: Gates.** `go test ./internal/bake/... -count=1`;
  `CLARUS_BAKE_FULL=1 go test ./internal/bake -run TestBakeFullCorpus
  -count=1` (consumption not wired yet — corpus must stay green with
  the bigger artifact, proving the sections are inert until Task 3);
  `go test ./internal/mactest -run TestLeakGate -count=1`;
  `scripts/test-task.sh --smoke`.
- [ ] **Step 5: Commit** "feat: CLIR v6 object sections + bake-time
  capture (object-code-linker Task 2)".

---

### Task 3: Consumption — Measure skip + paste-with-fixups

**Files:**
- Modify: `clarusc/cg68k.cla` (`cg68Measure`: skip `cgEmitFunc` for
  `i < bkRuntimeFuncBoundary` when objects are installed, fill
  `cgFuncSize`/`cgFuncFrameSizes`/`cgFuncStrLits`-family + fixed
  buckets from the artifact; `cg68ProgramFork` segment loop: paste
  baked functions' bytes + re-register fixups per Task 1's mechanic,
  `cgEmitFunc` for user functions unchanged), `clarusc/drive.cla`
  (only if an enable/plumbing flag is needed — expected none: presence
  of installed objects is the switch).
- Test: the full-corpus gate is the oracle; no new Go tests this task.

**Interfaces:**
- Consumes: `bkRuntimeFuncBoundary`, installed `bkLdObj*` data via the
  accessor(s) Task 2 defined; Task 1's paste mechanics.
- Produces: the bake path emits byte-identical output with runtime
  codegen skipped — the property Tasks 4's perf capture measures.

- [ ] **Step 1: Measure skip.** Gate: with a locally-generated artifact,
  `emit68k --rtbake` a small fixture; assert (temporary debug output,
  removed before commit) that zero runtime functions were emitted in
  Measure.
- [ ] **Step 2: Paste path** in the segment loop. Byte-compare the
  small fixture vs from-source — identical before proceeding.
- [ ] **Step 3: Full corpus.** `CLARUS_BAKE_FULL=1 go test
  ./internal/bake -run TestBakeFullCorpus -count=1` — every
  composition byte-identical with the paste path live. Any divergence:
  STOP, characterize (which function, which hole), fix or report
  BLOCKED; never re-bless.
- [ ] **Step 4: Host perf snapshot** (10-pair interleaved medians,
  `/usr/bin/time -l`): `emit68k clarusc/macgui.cla` from-source vs
  `--rtbake`, and host self-compile — record in the report for Task 4's
  docs (expect the emit68k macro to improve substantially; Measure is
  ~half of codegen and codegen dominates).
- [ ] **Step 5: Gates + commit.** `scripts/test-task.sh --smoke`; leak
  gate. Commit "feat: Measure skip + paste-with-fixups link pass
  (object-code-linker Task 3)".

---

### Task 4: Close-out — snapshot, docs, T2, Snow with Measure timings

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `STATUS.md`, `docs/ROADMAP.md`
  (phase entry per the fallback-trigger-narrowing template; debt
  ledger: precompiled-artifacts notes' Staging section marked stage 3.5
  implemented; smart-link/IR-body-removal + layout-improvement items
  recorded as the deferred follow-ons), `docs/superpowers/specs/
  2026-08-12-precompiled-artifacts-design-notes.md` (Staging update
  note).
- Test: full gates.

- [ ] **Step 1: Snapshot regen to fixed point** (cc → emit → cc → emit →
  cmp; iterate once more if round 1 differs); `go test
  ./internal/selfhost -count=1 -timeout 30m` green incl.
  `TestSnapshotFixedPoint`.
- [ ] **Step 2: Docs** (ROADMAP entry with task ledger, probe findings,
  perf table from Task 3 Step 4; STATUS close-out; notes-doc staging
  update).
- [ ] **Step 3: Full T2** (`scripts/test-merge.sh`, foreground, tee to
  the SDD workspace) at tip — green.
- [ ] **Step 4: Snow (controller runs, post-final-review, true tip):**
  `CLARUS_SNOW_TESTS=1 CLARUS_MACRESIDENT_SETTLE=55m go test
  ./internal/mactest -run TestClarusCBakePathOnSnow -count=1 -timeout
  90m` — PASS required; capture the on-Mac per-phase `TickCount()`
  timings from the log (Measure line is the headline; compare against
  ~10m post-leak-fix TickProbe baseline).
- [ ] **Step 5: Final commit.**

---

## Verification summary

| Oracle | Task | Proves |
|---|---|---|
| Probe report | 1 | hole taxonomy complete; paste mechanics; testapi symmetry |
| Corpus green, sections inert | 2 | serializer/loader round-trip safe before consumption |
| Full corpus + paste live | 3 | link pass byte-identical, runtime codegen skipped |
| Corrupt-section refusal | 2 | loader refuses, never half-installs |
| T2 + Snow + Measure timings | 4 | merge-readiness + the phase's headline number on hardware |
