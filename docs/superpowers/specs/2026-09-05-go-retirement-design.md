# Go retirement — design

Written 2026-09-05 from a full inventory of `internal/` (the session
survey plus a per-test sweep by a sonnet subagent). Not brainstormed
section by section with Andrew: the roadmap's "Retire Go" entry fixed
the direction ("port the test-harness infrastructure to C and Make"),
so this document takes the remaining decisions by default and lists
every one of them in §9 for override at review time.

## 1. Problem

The compiler is Go-free (tag `go-compiler-final`), the day-to-day
`clarus run` path is Go-free (`scripts/clarus-run.sh`), and the
`core`/`toolbox` suites are Clarus-native. The only thing still
requiring a Go toolchain is the test harness: 16 packages under
`internal/`, 14,435 lines, 133 `Test*` functions, driven by
`go test` from `scripts/test-task.sh` (T1) and `scripts/test-merge.sh`
(T2). A contributor who wants to run the gauntlet needs Go 1.26 for
code that, almost entirely, runs `clarusc`/`cc`/an emulator and
compares bytes.

What Go actually provides today, so the replacement covers all of it:

| Facility | Where it is used |
|---|---|
| Test discovery, `-run` filtering, per-package parallelism, `-timeout` | every package |
| Env-gated skip (`t.Skip`) | `CLARUS_MAC_TESTS`, `CLARUS_CPRINT_MAC_TESTS`, `CLARUS_SNOW_TESTS`, `CLARUS_BAKE_FULL`, `CLARUS_BENCH68K`, vasm/m68k-gcc presence |
| Subtests (`t.Run`) for per-case red/green | suite boots, cg68k fixture sweeps, bake corpus sweeps, leak gate, run-error fixtures |
| Bless modes rewriting goldens | `CLARUS_MAC_BLESS`, `CLARUS_BLESS_BEHAVIOR`, `CLARUS_CG68K_BLESS`, `CLRD_BLESS` |
| Shared bootstrap cache with `flock` + content stamps | `internal/claruscboot` (`SnapshotExe`/`CurrentExe`) |
| Process control: timeouts, `WaitDelay`, kill by PID, `pkill` | `RunMac`, `runSnow` |
| TCP sockets (`net`) | `conntest` (host echo peer), Snow serial bridge |
| Binary parsers written independently of the compiler | CLIR header, MacBinary + resource fork + CRC-16, `clar_ui_blob`, PBM |
| Regex scans over listings / logs | release-call counting, JT-slot displacement checks, `##CLARUS-MEM##`, `BENCH` lines |
| Timing (median of 3, `time.Duration` parsing) | `perfgate`, `CLARUS_MACRESIDENT_SETTLE` |
| Fixture synthesis | 6000-statement source, 70-arg call, CR/CRLF PBM variants, one-bit-flipped CLIR |

There is no third-party Go dependency (no `go.sum`); every package is
stdlib only. `t.Parallel` is used nowhere. The only cross-test shared
state is the bootstrap cache and one `sync.Once` build in
`appres_test.go`.

## 2. Approach (decided)

**Make + POSIX shell + five small C tools.** Each Go `Test*` becomes a
shell script (or, where the Go body was already a wrapper around a C
test, a Make rule) that exits 0/77/nonzero; a root `Makefile` is the
runner. C is used only where shell cannot do the job: process control
with a deadline, TCP peers, and byte-level parsing of binary formats.
No Python, no third-party test framework.

Alternatives considered:

- **A single C test runner binary** (one `tests.c` with a test table).
  Rejected: it re-implements process spawning, output capture, golden
  diffing and skip logic that the shell already has, and every test
  becomes C string-building around `system()`. More code, not less.
- **Writing the harness in Clarus.** Attractive for dogfooding, but the
  host runtime has no process-spawn intrinsic, so this needs a new
  `system()`-class extern and host-runtime glue first, and then a
  Clarus program orchestrating `cc` and emulators. It would put
  test-only surface into the language. Rejected for this phase; it can
  be revisited once a `process`/`exec` feature has a user-facing reason
  to exist.
- **Keep Go only for the Snow tests.** Rejected: the goal is zero Go,
  and the Snow tests are the last group to port, not a permanent
  exception (§7).

## 3. Runner

### Layout

```
Makefile                      # root; targets below
tests/
  lib.sh                      # shared shell helpers (sourced by every test)
  tools/                      # C tools, built by make into build-run/tools/
    timeout.c  clirhdr.c  resfork.c  uiblob.c  tcpdrive.c
  <group>/<name>.sh           # one script per ported Go test (§4 maps them)
  <group>/testdata/...        # fixtures that lived under internal/<pkg>/
```

Test scripts are named `tests/<group>/<name>.sh` where `<group>` is the
old Go package name (`cg68k`, `bake`, `mactest`, ...) so the mapping in
§4 stays greppable in both directions. Build products go under
`build-run/tests/<group>/<name>.{log,ok,fail,skip}`; `build-run/` is
already gitignored.

### Targets

| Target | Meaning |
|---|---|
| `make t1` | T1 body: every group except `selfhost`, `-j` by default (`sysctl -n hw.ncpu`), emulator-bound tests self-skip without their gate |
| `make t2` | T1 body, then `selfhost`, then the gated `mactest` native lane and `CLARUS_BAKE_FULL=1 bake` — same sequencing `test-merge.sh` has today |
| `make test T=cg68k/goldens` | one test (the `-run` replacement); `T=cg68k/` runs a group |
| `make smoke` | the two native smoke boots `test-task.sh --smoke` runs |
| `make tools` | build `build-run/tools/*` |
| `make clarusc-current` / `make clarusc-snapshot` | the bootstrap (§3 "Bootstrap") |

`scripts/test-task.sh` and `scripts/test-merge.sh` keep their names,
flags and printed summaries (`test-task.sh: PASS in Ns (smoke=N)`), and
become thin wrappers over these targets, so every doc recipe that says
"run `scripts/test-task.sh`" stays true.

### Test protocol

- A test is `sh tests/<group>/<name>.sh`, run with cwd at the repo root,
  under `build-run/tools/timeout` with a per-group deadline (default
  10 min; `mactest` 90 min; `selfhost` 30 min; overridable per script
  by a `# timeout: 15m` header line the Makefile greps).
- Exit 0 = pass, 77 = skip (the autotools convention), anything else =
  fail. The script's combined stdout/stderr is its log.
- Subtests use `kit.cla`'s `tkReport` line format, which is already the
  suites' normative log contract: `PASS <name>`, `FAIL <name>: <detail>`.
  `lib.sh` provides `t_pass NAME` / `t_fail NAME DETAIL` (which also
  latch the script's exit status) so a fixture sweep prints one line per
  fixture and the runner's summary reports per-case red/green exactly as
  `t.Run` did. The runner treats a script as failed if it exits nonzero
  or if its log contains any `FAIL ` line.
- `make -k` semantics: a failing test does not stop the others; the
  final summary lists every `.fail` with the last 40 log lines, then
  exits nonzero.

### Skips and gates

`lib.sh` provides `require_env VAR` (exit 77 unless `$VAR=1`),
`require_tool PATH` (exit 77 unless executable), and
`require_vasm` (the live `dc.b 1,2,3,4` probe from `asm68k`). Every
gate keeps its exact current spelling: `CLARUS_MAC_TESTS`,
`CLARUS_CPRINT_MAC_TESTS`, `CLARUS_SNOW_TESTS`, `CLARUS_BAKE_FULL`,
`CLARUS_BENCH68K`. Bless variables likewise: `CLARUS_MAC_BLESS`,
`CLARUS_BLESS_BEHAVIOR`, `CLARUS_CG68K_BLESS`, `CLRD_BLESS`. `CLARUS_DEBUG_UI` keeps its
full-capture dump in `ui_scenarios.sh`.
`golden_check FILE GOLDEN BLESSVAR` in `lib.sh` is the one place the
compare-or-rewrite decision lives.

### Bootstrap

`claruscboot`'s two-stage build (snapshot compiler from
`clarusc/clarusc.c`; current compiler emitted by the snapshot from
`clarusc/*.cla`) becomes two Make targets whose prerequisites are the
same input sets Go stamped (`clarusc/clarusc.c`, `runtime/host/*`,
`clarusc/*.cla`, `runtime/clarus/*.cla`). Make's mtime dependency
tracking replaces the content-stamp files, and Make's own job
scheduling replaces the `flock`: every test target depends on
`build-run/clarusc-current`, so `-j` builds it exactly once before any
test starts. Artifact names stay `build-run/clarusc-snapshot` and
`build-run/clarusc-current`. `scripts/clarus-run.sh` keeps its sibling
`build-run/clarusc` cache untouched. mtime keying rebuilds more often
than content keying (a `git checkout` of identical bytes still
triggers) and never less often, which is the safe direction.

### Parallelism and ordering

The T1 body runs `-j`. Three things must not run in parallel and are
sequenced by the wrapper scripts, not by Make (GNU Make 3.81, Apple's
default, has no per-target `.NOTPARALLEL`):

- `perfgate` runs alone after the parallel body; it already flakes
  under contention (`docs/TODO.md`), and the port re-baselines it
  against an isolated run.
- Every emulator boot (`mactest` gated lane, `smoke`) runs serially:
  Mini vMac boots each take the screen, and `RunMac` never ran them
  concurrently in Go either.
- `selfhost` runs after the body (it is 30 min on its own and
  rebuilds compilers in scratch dirs).

## 4. Port map

Every Go test file maps to scripts as follows. "Shell" means
`lib.sh` + `cmp`/`diff`/`grep`/`awk`/`xxd`/`od`; the C column names a
§5 tool where one is needed.

| Go package / file | New location | Needs |
|---|---|---|
| `claruscboot` (non-test) | `Makefile` bootstrap targets + `lib.sh` `clarusc_current`/`clarusc_snapshot`/`cc_path` (honours `$CC`) | — |
| `claruscboot_test.go` (2) | `tests/claruscboot/{checks_fixture,cache_reuse}.sh` (cache reuse = run `make clarusc-current` twice, mtime unchanged) | — |
| `hostrt/*_c_test.go` (13) | Make rules: `cc -std=c99 -Wall -Werror` each `runtime/host/rt_*_test.c`, run, expect `OK`; the 5 embedded `smokeMain` C strings in `rtsmoke_test.go` become committed `runtime/host/rt_smoke_*_test.c` files; the `live=0` strict gate is a grep | — |
| `perfgate_test.go` | `tests/perfgate/tripwire.sh`; `baseline.txt` moves to `tests/perfgate/`; median of 3 `timeout --elapsed` runs | timeout |
| `asm68k/vasm_test.go` | `tests/asm68k/roundtrip.sh`; `exercise.cla` moves alongside | — |
| `reftest/{reftest,manifest}.go` + test | `tests/reftest/{extract,checkclean,required}.sh`; fence extraction is a 12-line awk state machine on the literal ```` ```rust ````/```` ``` ```` lines; `CheckClean` becomes `tests/reftest/manifest.txt` (one index per line, `#` comments carry each exclusion reason verbatim from `manifest.go`) | — |
| `lowlevel/*_test.go` (6) | `tests/lowlevel/{run,rtinc,incdedup,constdedup,xrecorder}.sh` | — |
| `testsuite/*_test.go` (4) | `tests/testsuite/{catalog,catalog_ui,core_cli,lazyintern}.sh`; the 81-name `wantCases` list becomes `tests/testsuite/core_cases.txt`; the lazy-intern scan is grep/awk over `clarusc/*.cla` | — |
| `sertest/*_test.go` (3) | `tests/sertest/{roundtrip,badfield,clrd}.sh` | — |
| `emitui/emitui_test.go` | `tests/emitui/{goldens,errconst,popupguards,uiblob}.sh`; m68k compile-only step skips (77) without `toolchain/` | uiblob |
| `emitui/appinfo_test.go` (5) | `tests/emitui/appinfo.sh` with 5 `t_pass` subcases | — |
| `cg68k/golden_test.go` | `tests/cg68k/{goldens,vasm,determinism}.sh` | — |
| `cg68k/array_assign_test.go` | `tests/cg68k/array_assign.sh` | — |
| `cg68k/callresult_release_test.go` | `tests/cg68k/release.sh`: awk locates a function in `.segN.s`, counts `rtTextRelease` calls in both `BSR.W`/`JSR LBL_n` and `JSR N(A5)` forms (slot = `(N-32)/8`), and extracts the `BEQ.W`…`BRA.W` short-circuit region | — |
| `cg68k/image_test.go` | `tests/cg68k/image.sh` | resfork |
| `cg68k/segment_test.go` | `tests/cg68k/segments.sh`; the 6000-statement and 70-arg sources are generated by a shell loop | resfork |
| `cg68k/selfemit_test.go` | `tests/cg68k/selfemit.sh` | — |
| `bake/bake.go` + `bake_test.go` (4) | `tests/bake/{twice,header,bodyhash,corrupt}.sh` | clirhdr |
| `bake/bakeidentity_test.go` (~30) | one script per Go test under `tests/bake/` (`identity.sh`, `connfileh.sh`, `refuse_stamp.sh`, ..., `full_corpus_*.sh` gated on `CLARUS_BAKE_FULL`); `copyTree` is `cp -R` | clirhdr |
| `conntest_test.go` (5) | `tests/conntest/{connect,listen,envunset,abort,shadow}.sh` | tcpdrive |
| `mactest/leakgate_test.go` | `tests/mactest/leakgate.sh` (+ `dblcompile*.sh`); `BAKESTATE` lines parsed by awk | — |
| `mactest/resparity_test.go` | `tests/mactest/resparity.sh`; CR/CRLF PBM variants via `tr`/`sed` | resfork |
| `mactest/pbm2icn_test.go` | `tests/mactest/pbm2icn.sh` (see §9 item 7) | — |
| `mactest/bake_test.go` (3) | `tests/mactest/bake_named.sh` | — |
| `mactest/{mac,native,ui,coresuite,bench,appres}_test.go` | `tests/mactest/{runerr_mac,abort_mac,native_compare,smoke_bounce,ui_scenarios,tick,connfailed,runerr_68k,abort_68k,coresuite_68k,coresuite_mac,toolbox_68k,toolbox_jiggle,toolbox_mac,bench,appres}.sh`; `RunMac`/`parseCapture`/`checkUIGoldens`/`parseUIOutput`/`pbmBytes` become `lib.sh` functions (`run_mac`, `capture_split`, `ui_goldens`; hex→PBM is `xxd -r -p` plus a `P4\n512 342\n` header); the `appres` `sync.Once` becomes one build shared by three subcases in one script | timeout |
| `mactest/uiprobe/`, `mactest/probe/` (Retro68 C probes, no Go) | `tests/mactest/probe/`, `tests/mactest/uiprobe/` unchanged; `.gitignore` paths follow | — |
| `mactest/{snow,serial_snow,pagefile_snow,macresident,clarusc_bake,clarusc_boot}_test.go` | `tests/mactest/snow/*.sh` + `lib_snow.sh` (§7) | timeout, tcpdrive |
| `selfhost/*_test.go` (6) | `tests/selfhost/{behavior,crossgen,diag,fixedpoint,modules,snapshot}.sh`; `fixedpoint.sh` prints the same regeneration recipe on failure | — |

## 5. C tools (`tests/tools/`)

Each is a single file, `cc -std=c99 -Wall -Werror`, no dependencies
beyond libc/POSIX, built once by `make tools`.

1. **`timeout`** — `timeout [--elapsed] SECONDS CMD...`: fork/exec in a
   new process group, `alarm`, on expiry kill the group and exit 124;
   otherwise propagate the child's status. `--elapsed` prints wall
   milliseconds to stderr on its last line (macOS `date` has no `%N`,
   so `perfgate` needs this). Replaces `context.WithTimeout` +
   `WaitDelay`; the `pkill -f minivmac.app` sweep on a real timeout
   stays in `run_mac`.
2. **`clirhdr`** — `clirhdr FILE` parses the CLIR header exactly as
   `bake.ParseHeader` does (magic, version, lane, stamp, body hash,
   module keys, section table, trailing-byte accounting) and prints
   `version=7 lane=68k stamp=<hex> bodyhash=<hex> modules=23
   sections=46` plus one line per module and section. `--flip-stamp`
   / `--flip-body` write a copy with the first stamp/body byte XOR
   0xFF (the `Corrupt*Fixture` generators). `--corrupt-objcode` stays
   what it is today: clarusc's own `--corrupt-objcode-testonly` flag,
   invoked from the script.
3. **`resfork`** — MacBinary + resource-fork reader, independent of
   `cg68k.cla`'s writer: `resfork header FILE` prints the MacBinary
   fields and verifies the CRC-16/XMODEM (self-checked against the
   `"123456789"` → `0x31C3` vector at startup); `resfork list FILE`
   prints `TYPE ID NAME OFFSET LEN` per resource; `resfork get FILE
   TYPE ID OUT` extracts one; `resfork code0 FILE` prints the A5-world
   header and every jump-table entry (`slot seg offset`) with the
   filler/trailer-word checks `image_test.go` makes. Serves
   `image.sh`, `segments.sh` and `resparity.sh`. The two Go parsers
   were deliberately duplicated across packages for independence from
   the compiler, not from each other; one tool keeps that property.
4. **`uiblob`** — `uiblob FILE` decodes a raw `clar_ui_blob` byte file
   (extracted from the emitted C by awk) with the same big-endian
   walk `uiBlobDecoder` performs and prints one line per header field,
   window, widget, table, form, bind, enum layout, menu, handler,
   every-block and app field. `uiblob.sh` byte-compares the raw blob
   against `uiblob_probe.blob.golden` (unchanged) and additionally
   diffs the decoded dump against a new committed
   `uiblob_probe.dump.golden`, which pins every count and offset the
   Go test asserted individually (§9 item 6).
5. **`tcpdrive`** — `tcpdrive pick-port` prints a free port (bind 0,
   read back, close). `tcpdrive {listen PORT | connect HOST:PORT
   [--retry SECS]} SCRIPT` runs a line-oriented exchange: `expect
   FILE` (read exactly `size(FILE)` bytes, byte-compare), `expect-sub
   STRING MAXBYTES` (scan a window for a substring, tolerating the
   Snow bridge's leading noise byte), `send FILE`, `sleep MS`, `close`,
   `await-close SECS`. Exits nonzero with the first divergence's offset
   and a hex window. Serves `conntest/*.sh` and the Snow serial and
   pagefile tests; `--retry` is the 120 s dial budget.

`scripts/pbm2icn.c` and `scripts/setbundle.c` stay where they are.

## 6. Gates and scripts after the port

`scripts/test-task.sh` becomes:

```sh
make -j tools clarusc-current
make -j t1              # parallel body, perfgate excluded
make test T=perfgate/   # isolated
[ "$SMOKE" = 1 ] && CLARUS_MAC_TESTS=1 make smoke
```

`scripts/test-merge.sh` runs the same body, then `make test
T=selfhost/`, then `CLARUS_MAC_TESTS=1 make test T=mactest/` (serial),
then `CLARUS_BAKE_FULL=1 make test T=bake/full_corpus_`. The per-stage
`PASS in Ns` lines are preserved verbatim. `-count=1` has no
replacement because the runner has no result cache: every invocation
re-runs every selected script (the `.ok` files are for the summary,
not for skipping work).

## 7. Snow lane (`tests/mactest/snow/`)

Ported last, as its own task group, because it cannot be validated in
the T1/T2 loop (multi-hour settles, whole-screen emulator). `lib_snow.sh`
provides:

- `snow_disk` — clone `snow/Clarus.snoww`, its `scsi_targets[0].Disk`
  image and `snow/clarus.pram` into a scratch dir and rewrite the four
  path keys with `sed` (the workspace is flat JSON with one key per
  line; a structural JSON edit is not needed).
- `snow_put` / `snow_put_bin` / `snow_get` / `snow_get_bin` — hfsutils
  with `HOME` pointed at the scratch dir (the `.hcwd` isolation rule),
  Startup Items for the app, volume root for data files.
- `snow_run DISK TIMEOUT DONE_CMD [ARGS...]` — start `snow/Snow` in the
  background, record the PID, poll `DONE_CMD` every 2 s, detect an
  unexpected exit within one poll, then `osascript -e 'quit app
  "Snow"'`, wait up to 20 s, and on overrun kill by PID and fail loudly
  (the disk image is untrustworthy after a forced kill, exactly today's
  rule).
- `settle_seconds VALUE` — parses the `CLARUS_MACRESIDENT_SETTLE`
  duration subset the docs actually use (`Nh`, `Nm`, `Ns`, and bare
  seconds); `CLARUS_MACRESIDENT_DONE` keeps its marker-file early exit.

The seven Snow scripts (`roundtrip`, `serial_echo`, `pagefile`,
`macresident`, `macresident_failed_compile`, `clarusc_bake`,
`clarusc_boot`) use `tcpdrive` for the bridge and keep every current
timeout constant (110 min settle, 55 min bake settle, 45 s boot settle,
6 min echo bound, 4 min pagefile bound). The standing rule "re-run
`TestClarusCBakePathOnSnow` after any `bake.cla`/`macgui.cla` change"
becomes "run `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake`".

## 8. Proof of parity and the deletion order

The port is only correct if the new harness fails when the old one
would. The plan enforces this in three ways:

1. **Side-by-side green.** Go is not deleted until `scripts/test-task.sh
   --smoke` and `scripts/test-merge.sh` are green under the new runner
   on the same tree where `go test` is green, and the two summaries
   list the same set of executed (non-skipped) tests.
2. **Mutation smoke per golden family.** Each ported golden test is
   shown red once by a one-byte edit to a golden (then reverted) before
   the task is marked done; each diagnostic-substring test is shown red
   once by changing the expected substring. This is a review-gate step,
   not committed code.
3. **Count pins.** The plan's task table lists every one of the 133 Go
   `Test*` names against its script; a task is not review-clean until
   its row is filled. The `internal/` tree is deleted in one commit
   together with `go.mod`, after which `grep -rw 'go test'` over
   `CLAUDE.md`, `docs/ROADMAP.md`, `docs/TODO.md` and `scripts/` must be
   empty. `docs/HISTORY.md` is an archive and keeps its 17 historical
   `go test` mentions verbatim, with one new entry recording this phase.

Task order (for the writing-plans step): runner + `lib.sh` + `timeout`
first, proven on `hostrt` and `claruscboot`; then the host-only groups
in the order of §4 (each group is one task, `mactest`'s host-only
tests are one task); then `selfhost`; then the gated vMac lane; then
Snow; then deletion and docs. Go stays runnable throughout, so any
task can be compared against `go test ./internal/<pkg>` on demand.

## 9. Decisions taken by default (review these)

1. **Make + shell + C, not a Clarus-native harness.** The roadmap entry
   says C and Make; a Clarus harness needs a process-spawn extern first.
2. **Root `Makefile`, tests under `tests/`**, groups named after the
   old packages. `testsuite/` (the Clarus-native suites) and `testdata/`
   are untouched.
3. **`tkReport`'s `PASS`/`FAIL` line format is the universal subtest
   protocol.** It is already the suites' contract; reusing it means one
   parser (in the runner) instead of two.
4. **Exit 77 means skip.** The autotools convention; nothing in the
   tree uses 77 for anything else.
5. **All env var spellings preserved**, including the un-prefixed
   `CLRD_BLESS`, so every doc recipe and memory stays valid.
6. **`uiblob`'s field-by-field assertions become a decoded-dump golden.**
   Stronger than the Go test (pins every field, not the asserted
   subset) and shorter; the raw-blob byte golden is kept too.
7. **`pbm2icn`'s flood-fill oracle is not reimplemented.** The script
   constructs the fixture (a bitmap with an enclosed white hole and a
   border-reachable white region) and checks the specific output bits
   by construction with `od`; P1/P4 equivalence stays a byte-compare.
   The BFS reimplementation existed to compute an expected mask the
   author can instead write down.
8. **One `resfork` tool serves both `image.sh` and `resparity.sh`.**
9. **Snow is in scope**, ported last, validated by one manual run of
   each script (the short ones in the plan's task; the two 55–110 min
   settles once before deletion).
10. **Make replaces `flock` and the stamp files.** mtime keying is
    coarser but never stale.
11. **`CLARUS_MACRESIDENT_SETTLE` keeps `Nm`/`Nh`/`Ns` syntax** rather
    than switching to bare seconds.
12. **`perfgate` runs isolated after the body and is re-baselined** as
    part of this phase (its TODO item closes here).
13. **`hostrt`'s embedded C strings become committed `.c` files.**
    Five new files under `runtime/host/`, named `rt_smoke_*_test.c` so
    `selfhost/snapshot.sh`'s existing `*_test.c` exclusion still
    applies.

## 10. Out of scope

- Retiring Retro68 (its own roadmap entry). `build-mac.sh`,
  `coresuite_mac.sh`, `appres.sh` and the cprint lane stay opt-in
  behind `CLARUS_CPRINT_MAC_TESTS` exactly as today.
- Any change to what is tested. No test is dropped, weakened, or
  added beyond the two decoded-dump goldens (§9 items 6 and 7) and the
  perfgate re-baseline.
- CI. The repo has no CI workflows; none are added.
- A process-spawn feature for the language (§2).

## 11. Risks

- **GNU Make 3.81.** Apple ships it; the Makefile uses nothing newer
  (no `$(file ...)`, `!=`, `.NOTPARALLEL` per target, or
  `--output-sync`). Per-test logs go to files so interleaved `-j`
  output is not a problem.
- **Shell portability.** Scripts target `/bin/sh` (macOS's is bash in
  POSIX mode); `lib.sh` avoids bashisms so a Linux contributor with
  `dash` is not broken by accident. `xxd` is assumed (ships with vim on
  both).
- **Timing-sensitive tests** (`perfgate`, `TestRealEventLoopTickOn68k`,
  the conntest 2 s abort bound) keep their bounds; the port changes
  scheduling, so each is watched across the side-by-side runs before
  deletion.
- **Snow cannot be exercised in the normal review loop.** Mitigated by
  the manual-run requirement in §9 item 9 and by porting it last.
