# Session status — 2026-08-28 (extern-ptr-call: COMPLETE, T2 green, not merged)

Handoff summary. **The `extern-ptr-call` phase (branch `extern-ptr-call`,
based on `main` at `74c9e46` — `filesystem-api` is merged AND pushed
(origin/main = `9b2eea8`, pushed 2026-08-27); only main's two
extern-ptr-call spec/plan docs commits, `d3ae9fe`/`74c9e46`, are ahead of
origin) adds `= ptr`, a new
`external func` clause for a pascal-convention call through a runtime
pointer rather than a fixed trap number, both lanes. Driving use case:
loaded code resources — `GetResource` a plugin/door module (68kBBS
territory), `HLock` it, deref the handle, jump in with arguments — which
had no language surface at all before this phase. Tasks 1-5 (parser/
checker, host lane, native lane, core-suite `PtrCall` case, reference/
cookbook docs) all passed review clean, no fix rounds needed. Task 6
(this close-out) regenerated the bootstrap snapshot, ran full T1/T2 green,
found and fixed a real CheckClean gate break in the reference's own new
`ptr`-clause worked example (not a compiler bug — a doc example that
didn't compile standalone), and closed out docs. Full T2 PASS (see §1). The final
whole-branch review (opus) came back READY WITH FIXES; the fix wave
(`cac7ff1`) landed all six findings — most notably the host-lane conv-10
cast now carries `CLAR_PASCAL` (without it the Retro68/cprint Mac lane
called a pascal callee through a C-convention pointer — silent stack
corruption on `build-mac.sh` builds using `= ptr`; the `#define` is also
emitted for callback-free `= ptr` programs now), plus the cg68k doc-block
split, a void-return `PtrCallVoid` suite check, and wording/hygiene items —
re-review clean, gates re-run green at `cac7ff1` (snapshot fixed-point,
T1 --smoke, `TestCoreSuiteGUIOn68k` 80/80, T2 346s).
NOT merged, NOT pushed — merge only on Andrew's request.**

**Found-on-main while proving the fix wave:** the opt-in Retro68/cprint
suite twin (`TestCoreSuiteGUIOnMac`, `CLARUS_CPRINT_MAC_TESTS=1`) is
broken on main and has been since `ae662a3` (2026-08-22, filesystem-api's
native filehandle commit): a `*/`-in-comment bug in
`runtime/mac/rt_ext_mac.inc` breaks that lane's C build. Not this
branch's doing (the file is untouched here) and invisible by default
(demoted diagnostic lane), but the cross-lane oracle is dark until it's
fixed on main. The conv-10 `CLAR_PASCAL` fix is instead proven by the
emitted C for that very build (casts carry `CLAR_PASCAL`, evidence in the
fix-wave report).**

## 0. START HERE next session

No pre-merge obligations are owed by this phase specifically: `= ptr` is
pure compiler front-end + codegen (conv 10 alongside the existing trap/
inline convs) with no new Toolbox trap surface and no OS-version-
dependent behavior, so there is nothing here that needs a System 7
(Snow) spot check the way filesystem-api's new HFS traps did. The core
suite's `PtrCall` case (both a word-returning and a bool-returning round
trip through a callback's own glue) is hardware-proved green on the
System 6 Mini vMac native lane (80/80, `TestCoreSuiteGUIOn68k`).

Otherwise the phase is fully closed on the branch: snapshot regenerated
and fixed-point-verified, T2 green, docs closed out.

**A real gate break was found and fixed this task, not a compiler
defect:** T1's `internal/reftest` package (`TestCheckCleanFences`,
`TestRequiredProgramsInManifest`) went red after Task 5's reference edit.
The new "The `ptr` Clause" subsection's closing worked example (`HLock` →
`HandleToPtr` → `PluginMain(code, 1, pb)`) had two real problems: it used
bare top-level statements outside any function (only declarations are
legal at top level in Clarus) and referenced an undeclared `pb`. Fixed by
wrapping the example in a `callPlugin(h: ptr, pb: ptr): int` function,
with `var code: ptr` declared (uninitialized) before the `HLock`/
`HandleToPtr`/`return` statements — Clarus requires all local var
declarations at the top of a body before any statement, so the assignment
to `code` had to move after the declaration rather than being folded into
it. Mirrored the identical fix into `docs/clarus-toolbox-cookbook.md`'s
own copy of the same example (not gate-checked, but kept consistent).
This inserted two new fences into `docs/clarus-language-reference.md`
(the standalone `= ptr` declaration line, and the fixed closing example),
shifting every fence index at or after the old "word extern type" fence
by +2 — `internal/reftest/manifest.go`'s `CheckClean` list and its header
comments were updated to match (new indices 84/85 added; the two
Appendix C programs shifted from 85/86 to 87/88). Full trail: this file's
§1 below and the language reference's own "The `ptr` Clause" subsection.

**What this phase built** (6 tasks; Tasks 1-5 one feat commit each, all
review-clean with no fix rounds; Task 6 this close-out commit; full
detail in `.superpowers/sdd/2026-08-27-extern-ptr-call/`):

1. **Parser + checker front end** (Task 1, `c9c2d4f`) — new contextual
   keyword `ptr` recognized only in `external func`'s clause position
   (conv flag 10); the checker requires at least one parameter with the
   first declared `ptr` (the call target, consumed as the jump address,
   never pushed); `ptr` is grammar-level incompatible with `sel`/
   `seld0`/`reg`/`memerr`/`ret` (a parse error, not a checked
   diagnostic — the grammar has no production for a suffix there). Seven
   new `check_test` fixture cases.
2. **Host lane** (Task 2, `5f8d225`) — `cprint.cla`'s `fpCallExt` casts
   the first argument through a C function-pointer type built from the
   extern's own declared param/return types (`cpCbWireType`/
   `cpCbRetWireType`, the same wire types a `callback func`'s glue
   already conforms to) and calls through it directly — no `rt_ext_`
   host symbol at all for a conv-10 extern (`cpEmitExternProtos` skips
   it). New fixture `testdata/lowlevel/ptrcall_host.cla`
   (`TestLowlevel`), modeled on `callback_host.cla`.
3. **Native lane** (Task 3, `0ae201d`) — `cg68k.cla`'s pascal arg-push
   loop was extracted verbatim out of `cgCallExtPascal` into
   `cgPushPascalArgs(a0, xi, j0)` (conv 1/9 emission proven
   byte-identical by the existing golden corpus — no rebless). New
   `cgCallExtPtr`: push the target as a saved long below the result
   slot, push the result slot, push args 1.. via the shared loop against
   params 1.., `MOVEA.L` the saved target back into A0 past the pushed
   args+slot, `JSR (A0)`, read the result back (same three
   signed/short-slot arms `cgCallExtPascal` already used), `ADDQ.L
   #4,A7` to discard the saved target (the callee only pops its own
   declared args under pascal discipline). No new native globals.
4. **Core suite `PtrCall` case** (Task 4, `8fa24f7`) —
   `testsuite/core/cases_ptrcall.cla`: a word-returning round trip
   (`PtrCallRound` through `callback func pcMixed`, asserting a signed
   result, a `ptr`+`int` side effect via `peekl`, and a bool-steered
   branch) plus a bool-returning round trip (`PtrCallFlag` through
   `callback func pcIsPositive`) added by review to pin the
   historically-buggy bool-result native readback arm — the word case
   alone doesn't reach it. `nCoreCases` 79 → 80 (79 real + `SelfCheck`);
   wired into every count site (`runner.cla`,
   `internal/testsuite/core_cli_test.go`, `internal/cg68k/
   segment_test.go`, `internal/mactest/coresuite_test.go`/
   `suite_host_test.go`, `internal/bake/bakeidentity_test.go`). Hardware
   green 80/80 on `TestCoreSuiteGUIOn68k` (System 6, Mini vMac).
5. **Docs** (Task 5, `929bd15`) — reference grammar production extended
   with `| "ptr"`; new "The `ptr` Clause" subsection (Ch13); cookbook
   §13, "Walkthrough: calling loaded code — the `= ptr` clause".
6. **Close-out (Task 6, this commit)** — bootstrap snapshot regenerated
   and fixed-point-verified; the reference/cookbook `pb`/top-level-
   statement fence bug found and fixed (see above); `internal/reftest/
   manifest.go`'s `CheckClean` manifest updated for the two new fences;
   `docs/TODO.md`/`docs/ROADMAP.md`/`docs/HISTORY.md`/`CLAUDE.md` closed
   out.

**Deferred follow-ups** (both from the spec's own out-of-scope section,
recorded in `docs/TODO.md`, not re-litigated): a named-target `= ptr(name)`
form (binding a declaration to one fixed pointer rather than taking the
target fresh at every call site); register-convention (`reg`) targets for
`= ptr` (today pascal-only).

## 1. Gate results (this phase)

1. **Snapshot fixed point**: PASS. `go test -count=1 -timeout 30m -run
   TestSnapshotFixedPoint ./internal/selfhost` first FAILed (stale
   snapshot — clarusc's own source changed under parse/check/cprint/
   cg68k this phase), printed the Go-free regen recipe, which was
   followed verbatim (`cc`-only two-stage bootstrap through the current
   source, no Go compiler); re-run → PASS ("snapshot fixed point
   reached").
2. **T1** (`scripts/test-task.sh --smoke`): first run FAILed
   (`internal/reftest`, the fence-manifest gate break described above);
   fixed (reference/cookbook doc edit + `manifest.go` update); re-run →
   PASS, 28s.
3. **T2** (`scripts/test-merge.sh`, foreground): PASS, 345s total. T1
   body 18s; `internal/selfhost` (`-count=1 -timeout 30m`) 133s;
   `internal/mactest` gated native lane (`CLARUS_MAC_TESTS=1`, no `-run`
   filter — every native-lane boot including the heap-jiggle gate) 187s;
   `internal/bake` full-corpus byte-identity gate
   (`CLARUS_BAKE_FULL=1`) 7s.
4. **Docs**: this file, `docs/ROADMAP.md` (new "Where we are" paragraph),
   `docs/HISTORY.md` (new phase entry), `docs/TODO.md` (two deferred
   follow-ups), `CLAUDE.md` (core-suite count 79→80, `= ptr` one-line
   mention) — all committed alongside this file.

## 2. Prior phases (all merged; recap pointers only)

- **filesystem-api** (`file.makeDir/delete/list/exists/info/setInfo/
  rename/move`, both lanes) — merged to local `main` 2026-08-26 (part of
  this branch's own base, `74c9e46`). System 7 (Snow) verification for
  that phase remains UNVERIFIED — still owed before that work (and this
  branch, which sits on top of it) is pushed; see that phase's own
  `docs/HISTORY.md` entry.
- **transfer-crcs** (`text.crc16x`/`text.crc32`) — merged to local `main`
  2026-08-25 (part of this branch's own base).
- **binary-files** (`filehandle`, `connection` as a value, `text` binary
  accessors + `crc16`, `string(n)`, the `toolbox/` include fallback,
  emit68k's per-function big-temp pool) — merged to local `main`
  2026-08-23 (part of this branch's own base).
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
30m`. Merge only on Andrew's request; main stays green (this branch does
NOT touch main).
