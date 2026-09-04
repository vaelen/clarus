# Task 12 report: `selfhost`

Worktree: `/Users/andrew/repos/clarus/.claude/worktrees/agent-ae7e4caa63c0301d9`
Branch: `worktree-agent-ae7e4caa63c0301d9`

## Base correction (preamble section 0)

The worktree was created at `aa31091` (main), **not** on `go-retirement` —
`tests/lib.sh`, `Makefile` and `tests/tools/timeout.c` were all absent.
`git reset --hard go-retirement` moved it to `76a54c2 fix(harness): forward
signals to child group, reject bad timeout SECS`; all three files present
after. No commits were lost (there were none). Section 1's five symlinks
(`Retro68 toolchain macplus vasm snow`) were created and all resolve.

## What I implemented

`tests/lib_selfhost.sh` (new group library, sourced by all six scripts right
after the frozen `lib.sh`):

- `runnable_fixtures` — prints `testdata/run/*.cla` then
  `testdata/runerr/*.cla`, one per line; `die`s if either family is empty
  (mirrors `runnableFixtures`' two `t.Fatal`s). Callers separate the two
  families by path prefix.
- `behavior_blob EXE OUT [ARGV...]` — runs `EXE` with `ARGV` in a fresh empty
  cwd and writes the byte-exact `behaviorBlob` layout
  `exit=<N>\n--- stdout ---\n<stdout>--- stderr ---\n<stderr>` (no separator
  before the stderr delimiter). Also exports `BB_EXIT` / `BB_OUT` / `BB_ERR`
  so callers can additionally diff stdout/stderr against `.out`/`.log`.
- `fixture_build OUTBIN CLARUSC FIXTURE.cla` — the compiler-parametrized twin
  of `lib.sh`'s `host_build` (which hardcodes the current generation;
  behavior/crossgen need the snapshot generation too).
- `check_mem_report REPORT LEAKSFILE NAME` — `checkMemReport` parity: the
  report's **first** line must be `##CLARUS-MEM## live=<N>` and N must equal
  the `.leaks` integer, default 0. Deliberately does *not* use `lib.sh`'s
  `mem_live`, which takes the *last* match anywhere in a log — a weaker
  assertion than Go's.
- `first_divergence A B LABELA LABELB` — awk reimplementation of
  `diffFirstDivergence` (first differing line, ±2 lines of context per side,
  `>>> ` on the divergent line, plus the "one side ends early" variant).

`tests/selfhost/{behavior,crossgen,diag,fixedpoint,modules,snapshot}.sh`, all
mode 755, each carrying `# timeout: 30m` as line 2 (verified: `run1.sh`'s
`sed` parse yields `30m` → 1800 s for all six). `lib_selfhost.sh` is 644,
matching `lib.sh`; the Makefile's `! -name 'lib*.sh'` filter excludes it from
`TESTS`, confirmed by `make test T=selfhost/` matching exactly 6 scripts.

Per-script assertion parity:

| Script | Go source | Notes |
|---|---|---|
| `behavior.sh` | `TestBehaviorGoldens` | builds with `$CLARUSC_SNAPSHOT`; run family: `.args` (whitespace-split), `.exit` (default 0), strict+paranoid `CLARUS_MEM_*` run, exit / `.out` / `.log` / `.behavior` / `.leaks`. runerr family: `.err` required (contains, after whole-string TrimSpace), `.exit` default **3**, `.behavior`. Bless var `CLARUS_BLESS_BEHAVIOR` via `golden_check`. |
| `crossgen.sh` | `TestCrossGenDifferential` | snapshot-built vs current-built blob byte-compare per fixture; `.args` on the run family only; no mem check (matches `memCheck=false`). |
| `diag.sh` | `TestErrorGoldens` | `$CLARUSC emit` (current gen, **not** check-only mode), combined stdout+stderr, must exit nonzero, byte-compare vs `.expect`. |
| `fixedpoint.sh` | `TestSnapshotFixedPoint` | gen1 (snapshot) emit of `clarusc/main.cla` == committed `clarusc/clarusc.c`, then gen2 (current) == gen1; failure prints the verbatim regeneration recipe + `first_divergence` with Go's own `c2`/`c3` labels. |
| `modules.sh` | `TestClarusModules` | 8 `clarusc/test/*_test.cla` drivers, current-gen build, nonzero exit is a failure, stdout byte-compare vs `.out`. |
| `snapshot.sh` | `TestSnapshotBuilds` | stages `clarusc/clarusc.c` as `main.c` plus `runtime/host/*` minus `*_test.c` into `$WORK`, compiles there with `-std=c99 -O1` and no `-I` (hermetic — `rt.c`'s `.inc`/`.h` siblings come along), then the 3 named fixtures' stdout+exit vs `$CLARUSC`. |

### Two path/cwd details that mattered

- `diag.sh` and `snapshot.sh` `cd "$ROOT/tests/selfhost"` and name fixtures as
  `../../testdata/...`. The `.expect` goldens embed that exact relative path
  (they were captured from `internal/selfhost`); `tests/selfhost` is at the
  same nesting depth, so the paths round-trip with **zero golden edits** and
  no dependency on `internal/` surviving.
- `fixedpoint.sh` passes no `--rtdir`, matching `emitCDir`. `clarusc` searches
  `runtime/clarus/` from the cwd **upward**, so the runner's cwd (repo root)
  resolves to the same runtime the Go test found by walking up from
  `internal/selfhost`. Verified: emitting from the root reproduces
  `clarusc/clarusc.c` byte-for-byte, while emitting from `/tmp` errors out.

## Gate results

`make test T=selfhost/` — **6 PASS, 0 SKIP, 0 FAIL** (no SKIPs at all; none of
these six has a gated dependency). Total ~2.5 min, well under the 30 m header.

```
PASS selfhost/behavior 34s
PASS selfhost/crossgen 100s
PASS selfhost/diag 0s
PASS selfhost/fixedpoint 1s
PASS selfhost/modules 6s
PASS selfhost/snapshot 6s
tests: 6 passed, 0 skipped, 0 failed
```

Subcase counts (from the per-test logs, confirming nothing was silently
skipped): behavior 95 PASS (76 run + 19 runerr), crossgen 95 PASS, diag 27
PASS, modules 8 PASS, snapshot 3 PASS, fixedpoint 2 PASS
(`snapshot_fresh`, `fixed_point`).

### Mandated mutation check

`printf '/* mutation check */\n' >> clarusc/clarusc.c`, then
`make test T=selfhost/fixedpoint`:

```
FAIL(exit 1) selfhost/fixedpoint 1s
FAIL snapshot_fresh: clarusc/clarusc.c is stale: committed snapshot (4935653 bytes) != fresh emission from the snapshot-built compiler (4935632 bytes).

The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it (Go-free, from the old snapshot):

  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla

Then commit the updated clarusc/clarusc.c.
first divergence at line 94758: one side ends early (c2 has 94758 lines, c3 has 94757 lines)
--- c2 ---
    94756:     return 0;
    94757: }
>>> 94758: /* mutation check */
--- c3 ---
    94756:     return 0;
    94757: }
```

Reverted with `git checkout -- clarusc/clarusc.c`; tree clean afterwards.

### Extra non-vacuity checks (not required, cheap, worth having)

Each reverted immediately; `git status` clean after.

- `echo 5 > testdata/run/for_loop_var_alias.leaks` →
  `FAIL run/for_loop_var_alias.cla: live leaks: got 6 want 5`. The
  memory-safety pin genuinely bites.
- `printf 'x\n' >> testdata/run/crc16.behavior` and
  `printf 'y\n' >> testdata/runerr/oob.behavior` → both families' golden
  comparison fails, with `golden_check`'s `cmp`+`diff` excerpt.
- `printf 'bogus\n' >> testdata/errors/mixed.expect` → `FAIL mixed.cla`.
- `printf 'bogus\n' >> clarusc/test/lex_test.out` → `FAIL lex_test.cla`.

### Bless-path proof (the strongest blob-layout evidence)

`CLARUS_BLESS_BEHAVIOR=1 make test T=selfhost/behavior` → 95 `BLESSED` lines,
95 PASS, and `git status --short` shows **zero modified goldens**. All 95
`.behavior` files rewritten from scratch by `behavior_blob` are byte-identical
to the ones Go's `behaviorBlob` committed. That covers the exit line, both
delimiters, the missing separator before `--- stderr ---`, and argv handling.

### `scripts/test-task.sh`

```
test-task.sh: PASS in 38s (smoke=0)
```

(Go lane all `ok`, `make t1` → `runner/selfcheck` + `runner/timeout` both
PASS. The `summary: no tests matched` / `make: *** [test] Error 2` noise in
its output is the pre-existing `make test T=perfgate/ || true` guard — Task 2
hasn't landed — not caused by this task. `make t1` correctly excludes
`selfhost/` per the Makefile's `T1` filter, so T1's runtime is unchanged.)

### `go test ./internal/selfhost`

```
ok  	clarus/internal/selfhost	130.320s
```

No Go file was touched — no fixture moved out of `internal/`, so the Go lane
needed no path updates.

## Files changed

- `tests/lib_selfhost.sh` (new, 644)
- `tests/selfhost/behavior.sh` (new, 755)
- `tests/selfhost/crossgen.sh` (new, 755)
- `tests/selfhost/diag.sh` (new, 755)
- `tests/selfhost/fixedpoint.sh` (new, 755)
- `tests/selfhost/modules.sh` (new, 755)
- `tests/selfhost/snapshot.sh` (new, 755)

Nothing else: `tests/lib.sh` untouched (frozen), no `Makefile` edit needed
(`selfhost/` is already excluded from `T1` and included in `t2`), no golden
edits, no Go edits.

## Self-review

- **Completeness.** All six scripts written; every `t.Fatalf`/`t.Errorf`
  condition in the six Go files has a counterpart, including the ones easy to
  drop: the runerr `.exit`-override default of 3, the `bad .exit` / `bad
  .leaks` parse errors, the "runtime wrote no mem report — is STRICT plumbed?"
  branch, the "mem report missing `##CLARUS-MEM##` header" branch, diag's
  "want nonzero exit, got 0", and both `runnable_fixtures` emptiness fatals.
  The one `t.Logf` (fixedpoint's success line) is reproduced as a plain echo.
- **Exact assertion parity.** Deliberately did *not* reuse `lib.sh`'s
  `mem_live` (last-match-anywhere, weaker than Go's first-line Sscanf) or
  `host_build` (wrong compiler generation). Byte comparisons are `cmp -s`
  throughout, never line-diff-based.
- **POSIX-only shell.** `sh -n` clean on all seven files. No arrays, no
  `[[ ]]`, no `local`, no `${!v}`, no `echo -e`, no bashisms; helper locals
  are `_`-prefixed to avoid caller collisions; awk locals are extra function
  parameters. `set --`/`"$@"` under `set -u` with zero positionals is exercised
  by 93 of the 95 fixtures. The two unquoted expansions
  (`set -- $(cat "$base.args")`) are intentional — that is `strings.Fields`.
- **No unrequested extras.** No new Makefile target, no cache, no wrapper
  script, no docs. Two `ponytail:` comments mark the only deliberate
  simplifications (both diagnostics-only, never assertions): the signal-exit
  encoding in `behavior_blob` (128+N vs Go's -1; no corpus fixture dies on a
  signal) and awk's phantom-trailing-line off-by-one in `first_divergence`.

## Concerns

1. **`behavior`/`crossgen` are far faster than the brief predicted** — 34 s
   and 100 s, not "about 30 min" for the group (~2.5 min total). Nothing is
   being skipped: the subcase counts above account for all 95 fixtures in
   both. The Go package takes 130 s for the same work, so the shell port is
   if anything faster (no per-subtest `t.TempDir()` churn). The `30m` headers
   are therefore very generous; that is what the brief specified, and it
   costs nothing, so I left them. Worth knowing when the T2 budget is
   re-estimated.
2. **`.leaks` non-integer handling is stricter than Go's** for negative
   values: Go's `strconv.Atoi` accepts `-1` and would then simply never match
   a live count, where my `case` rejects it as `bad .leaks`. Both fail; only
   the message differs. Neither existing `.leaks` file (1 and 6) is affected.
3. **Multi-line `.err` goldens.** The runerr "stderr contains TrimSpace(.err)"
   check uses a quoted `case` pattern on shell variables, so it is exact even
   for a multi-line golden — but all 19 current `.err` files are single-line,
   so that generality is untested by the corpus.
4. **`tests/selfhost`'s directory depth is load-bearing** for `diag.sh` and
   `snapshot.sh` (the `../../testdata/...` paths baked into the `.expect`
   goldens). If a later task moves or renests `tests/`, those two scripts
   break with confusing golden mismatches. Each carries a header comment
   saying so, but it is not machine-enforced.
5. The `make test T=perfgate/` failure inside `test-task.sh` is pre-existing
   (Task 2 not landed) and guarded with `|| true`; flagging it only so it is
   not mistaken for fallout from this task.
