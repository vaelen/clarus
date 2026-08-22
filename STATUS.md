# Session status — 2026-08-23 (binary-files: COMPLETE, T2 green, not merged)

Handoff summary. **The `binary-files` phase (branch `binary-files`) closed
all eight 68kBBS language gaps — `filehandle`, `connection` as a value,
`text` binary accessors + `crc16`, `string(n)`, the `toolbox/` include
fallback, and the emit68k big-temp ceiling removal — every task (1-9b)
landed with a clean per-task review, and Task 10 close-out ran every
gate green: snapshot fixed point, reftest manifest regeneration, full
`internal/selfhost`, and full `scripts/test-merge.sh` (T2), including
`internal/bake`'s `CLARUS_BAKE_FULL=1` gate. That last gate DID catch a
real bug on its first run this phase — a `--rtbake` (baked-IR fast
compile path) lowering crash for any program using `connection` or
`filehandle` — which is now fixed (Task 9c, inserted between Task 10's
first BLOCKED attempt and this resumed run). Full T2 PASS at the tip
(`6778e88`). NOT merged, NOT pushed — merge only on Andrew's request.**

## 0. START HERE next session

**The phase is fully closed on the branch — nothing code-side remains.**
What's left is entirely controller-run verification (below) plus the
merge decision itself.

**What this phase built** (10 tasks + Task 9b + Task 9c, one commit
each — full detail in `.superpowers/sdd/2026-08-22-binary-files/`):

1. **`filehandle`** — a value-typed handle for positioned file I/O
   (`file.open`/`file.create`, `readAt`/`writeAt`/`append`/`size`/
   `setSize`/`flush`/`close`), shared host+native runtime waist,
   hardware-proved on System 6 (Mini vMac) and System 7 (Snow).
2. **`connection` as an ordinary int value** — now usable as a param,
   local, or record field, not just a global.
3. **`text` binary accessors + `crc16`** — LE/word-typed getters/
   setters plus a bounds-checked `crc16` method, both lanes.
4. **`string(n)`** — bounded-capacity string values as a first-class
   type; `IntToStr` migrated onto it from ad hoc reimplementations.
5. **`toolbox/` include fallback** — `include "toolbox/..."` resolves
   against the compiler's own `toolbox/` directory when not found
   relative to the including file; `--rtdir` now works in check-only
   mode too.
6. **emit68k big-temp pool sized per function** — no more flat
   per-statement ceiling.
7. **Two compiler bugs found and fixed along the way**: `checkConstDecl`
   identical-redeclaration tolerance (Task 2); a `--rtbake` lowering
   crash for `connection`/`filehandle` calls, found by this task's own
   T2 run and fixed in Task 9c (full detail below).
8. **Acceptance**: `examples/pagefile.cla` (vDB-shaped pages, journal,
   `crc16`), hardware-proved on Snow.
9. **Close-out**: this task — snapshot regen, reftest manifest regen,
   docs (this file, `docs/ROADMAP.md`, `docs/TODO.md`,
   `docs/HISTORY.md`, `CLAUDE.md`, a spec correction note).

**Task 9c, inserted mid-close-out (full trail:
`.superpowers/sdd/2026-08-22-binary-files/task-10-report.md`'s "Task
9c" section):** Task 10's first close-out attempt found T2's
`internal/bake` `CLARUS_BAKE_FULL=1` gate RED — the first time this
phase that gate had actually run. Root cause (via `lldb`):
`clarusc/lower.cla`'s `lowRtCoerceArg` looked up a target runtime
function's param type by NAME through the checker's symbol table at
LOWERING time; `--rtbake` skips parsing+checking the runtime for
performance, so that table is never populated for runtime functions —
the lookup returned -1 and the next line crashed indexing `symbols[-1]`.
Fixed by replacing the lookup with `lowCoerceTo`, which takes the
target IR type directly at each of the 7 call sites (the coercion
target was always statically known — `lowConnMethod`/
`lowFileHandleMethod` already pick the runtime twin by the argument's
checked kind). Audited every other lowering-time `scopeLookup` in
`clarusc/*.cla` for the same pattern — none found; Task 4/5 (via the
shared `lowRtCoerceArg`) were the only two culprits. New T1-speed
regression added (`internal/bake`'s `TestRtbakeConnFilehByteIdentity`,
plain `go test ./internal/bake`, not gated) — proven to catch the bug
(red before the fix, green after, via `git stash`). Zero golden churn.
Commit `6778e88`.

**Controller-run finals (NOT run by this task, by design — foreground,
long, hardware-gated):**
- `TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`, ~55 min) — the
  standing rule fires this phase: `fileh.cla`/`fileh_68k.cla` were
  added to `clarusc/bake.cla`'s native runtime module manifest.
  Should now PASS given the `--rtbake` fix, but hasn't been confirmed
  on real hardware yet — worth running before merge as the hardware
  proof of Task 9c's own host-side fix.
- A final `TestPageFileOnSnow` rerun at the true tip (`6778e88`) — last
  known-PASS was at Task 9's own tip (`c5cc2cf`); nothing in Tasks
  9b/9c/10 should affect it (pagefile.cla doesn't call `.open`/`.send`
  on a `connection`, so Task 9c's fix path isn't even exercised by it),
  but it hasn't been re-run at the literal current HEAD.

**Consumer-side follow-ups for Andrew's 68kBBS repo (not this repo):**
- `termio.cla` can restore `(conn: connection, ...)` parameter/field
  signatures now that Task 4 makes `connection` an ordinary value type.
- `bbs.cla` should drop its `clarus-src/` include symlink spelling for
  `toolbox/osutils.cla` — the real fallback is `include
  "toolbox/osutils.cla"` with either `--rtdir
  ~/repos/clarus/runtime/clarus/` passed explicitly, or a
  `runtime/clarus` directory somewhere above the cwd. **Important:** if
  `~/repos/68kbbs/bin/clarusc` is a symlink to this repo's
  `build-run/clarusc` (as it was described), `findRtDir`'s upward
  cwd-probe finds NOTHING from `~/repos/68kbbs` (the probe walks up
  from the CWD, not the symlink target) — 68kBBS MUST pass
  `--rtdir ~/repos/clarus/runtime/clarus/` explicitly; the upward-probe
  fallback will not help them.
- `docs/language-gaps.md` (in the 68kBBS repo) should tick off all
  eight gaps as closed.

## 1. Gate results (this phase, branch tip `6778e88`)

1. **Snapshot fixed point**: PASS (regenerated once more after Task
   9c's `lower.cla` edit; 4,876,797 bytes, gen1 == gen2, matches
   committed).
2. **reftest manifest regeneration**: `internal/reftest/manifest.go`
   rebuilt from a fresh `clarusc check` pass over all 87 fences (46
   clean). `go test ./internal/reftest -count=1`: PASS.
3. **Full selfhost**: `go test ./internal/selfhost -count=1 -timeout
   30m`: PASS, 215.4s.
4. **T2** (`scripts/test-merge.sh`, log at
   `.superpowers/sdd/2026-08-22-binary-files/t2-final.log`) — **PASS
   end to end**, ~9.7 min total:
   - T1 body (13 packages): 12/13 PASS in-script; `internal/perfgate`
     `TestEmitPerfTripwire` FAILed under parallel contention both times
     this task ran the full body (median 0.146-0.160s vs the 0.124s
     limit), re-run alone (`-p 1`) PASSed cleanly every time
     (0.10-0.12s medians) — the known, already-documented host-
     contention flake, confirmed again, not a regression.
   - `internal/selfhost` (T2 stage): PASS, 215.4s.
   - `CLARUS_MAC_TESTS=1 go test ./internal/mactest` (gated native
     lane, no `-run` filter): PASS, 213.9s.
   - `CLARUS_BAKE_FULL=1 go test ./internal/bake`: **PASS**, 14.7s —
     `TestBakeFullCorpusSuiteCore` (the test that originally failed)
     now green, plus the new `TestRtbakeConnFilehByteIdentity`.
5. **Docs**: this file, `docs/ROADMAP.md` (item 1 DONE, "Where we are"
   updated), `docs/TODO.md` (9 deferred items filed + Task 9c's fix
   noted + a new testing-strategy TODO), `docs/HISTORY.md` (phase
   entry), `CLAUDE.md` (case counts, new-surface one-liners),
   `docs/superpowers/specs/2026-08-22-binary-files-design.md` (§3.5
   dated correction note) — all committed alongside this file.

## 2. Prior phases (all merged; recap pointers only)

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

**Standing rules:** re-run `TestClarusCBakePathOnSnow`
(`CLARUS_SNOW_TESTS=1`) after ANY change to `clarusc/bake.cla`,
`clarusc/macgui.cla`, OR the native runtime source manifest — THIS
PHASE fires that rule; see §0's controller-run finals.
`internal/selfhost` always gets `-count=1 -timeout 30m`. Merge only on
Andrew's request; main stays green (this branch does NOT touch main).
