# Go Retirement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the 16-package Go test harness under `internal/` with a Make + POSIX shell + five-C-tool harness under `tests/`, then delete `go.mod` and `internal/`.

**Architecture:** A root `Makefile` is the runner: every `tests/<group>/<name>.sh` is one test (exit 0 pass, 77 skip, else fail; `PASS`/`FAIL` lines for subtests), run under `build-run/tools/timeout` with its log captured to `build-run/tests/`. `tests/lib.sh` holds the shared helpers (bootstrap paths, golden compare/bless, capture parsing, emulator boot). Five single-file C tools under `tests/tools/` cover what shell cannot: deadlines, TCP peers, and the CLIR/resource-fork/UI-blob binary parsers. Go stays runnable until the last task, and the wrapper scripts run both harnesses side by side until then.

**Tech Stack:** GNU Make 3.81 (Apple's), `/bin/sh` (POSIX, no bashisms), C99 via host `cc`, `cmp`/`diff`/`grep`/`awk`/`sed`/`xxd`/`od`, existing hfsutils/LaunchAPPL/Snow/vasm toolchains.

**Spec:** `docs/superpowers/specs/2026-09-05-go-retirement-design.md`

## Global Constraints

- Branch: `go-retirement` off `main` (`aa31091` or later). Main stays green; merge only on request.
- Makefile syntax must work on GNU Make 3.81: no `$(file ...)`, no `!=`, no `--output-sync`, no per-target `.NOTPARALLEL`, no `.RECIPEPREFIX`.
- Scripts are `/bin/sh` POSIX: no arrays, no `[[ ]]`, no `${!var}`, no `local` (use subshells or unique names), no `echo -e`. `set -u` is on; `set -e` is not (tests inspect exit codes).
- Every env var keeps its exact current spelling: gates `CLARUS_MAC_TESTS`, `CLARUS_CPRINT_MAC_TESTS`, `CLARUS_SNOW_TESTS`, `CLARUS_BAKE_FULL`, `CLARUS_BENCH68K`; bless `CLARUS_MAC_BLESS`, `CLARUS_BLESS_BEHAVIOR`, `CLARUS_CG68K_BLESS`, `CLRD_BLESS`; overrides `CLARUS_MACRESIDENT_SETTLE`, `CLARUS_MACRESIDENT_DONE`, `CLARUS_DEBUG_UI`; runtime `CLARUS_MEM_STRICT`, `CLARUS_MEM_PARANOID`, `CLARUS_MEM_REPORT`, `CLARUS_SERIAL_MODEM`, `CLARUS_SERIAL_PRINTER`; `CC` (default `cc`).
- **The Go test file named in each port row is the normative assertion list.** Read it in full before writing the script. Every `t.Fatalf`/`t.Errorf`/`t.Skip` condition must have a counterpart; every golden path, fixture list, expected substring, exit code and count must be copied verbatim, not paraphrased. Do not weaken, drop, or add assertions except where the spec's §9 items 6 and 7 say so.
- No test is deleted from Go until Task 15. Each task's gate runs both `scripts/test-task.sh` (Go + Make) and the new group directly.
- C tools: one file each, `cc -std=c99 -Wall -Werror`, libc/POSIX only, no compiler code included or linked.
- Commit after every task with the project's attribution trailer.
- Subagents: `sonnet` for implementation and per-task review; never Fable for implementation.

---

## File structure

```
Makefile                          # runner (Task 1)
tests/
  lib.sh                          # shared helpers (Task 1; extended in 8, 13, 14)
  lib_snow.sh                     # Snow helpers (Task 14)
  run1.sh                         # run one script → .result/.log (Task 1)
  summary.sh                      # aggregate .result files (Task 1)
  tools/timeout.c                 # Task 1
  tools/uiblob.c                  # Task 5
  tools/resfork.c                 # Task 7
  tools/clirhdr.c                 # Task 8
  tools/tcpdrive.c                # Task 10
  runner/{selfcheck,timeout}.sh   # Task 1
  hostrt/*.sh  claruscboot/*.sh  perfgate/*.sh      # Task 2
  asm68k/*.sh  reftest/*.sh  sertest/*.sh           # Task 3
  lowlevel/*.sh  testsuite/*.sh                     # Task 4
  emitui/*.sh                                       # Task 5
  cg68k/*.sh                                        # Tasks 6, 7
  bake/*.sh                                         # Tasks 8, 9
  conntest/*.sh                                     # Task 10
  mactest/*.sh                                      # Tasks 7, 11, 13
  mactest/snow/*.sh                                 # Task 14
  selfhost/*.sh                                     # Task 12
  <group>/testdata/, perfgate/baseline.txt, asm68k/exercise.cla,
  reftest/manifest.txt, testsuite/core_cases.txt, mactest/probe/, mactest/uiprobe/
scripts/test-task.sh, scripts/test-merge.sh   # wrappers (Task 1, final form Task 15)
```

`build-run/` holds every product: `tools/`, `clarusc-snapshot`, `clarusc-current`(+`.c`), `tests/<group>/<name>.{log,result}`.

---

### Task 1: Runner skeleton, `timeout`, `lib.sh`, wrappers

**Files:**
- Create: `Makefile`, `tests/lib.sh`, `tests/run1.sh`, `tests/summary.sh`, `tests/tools/timeout.c`, `tests/runner/selfcheck.sh`, `tests/runner/timeout.sh`
- Modify: `scripts/test-task.sh`, `scripts/test-merge.sh` (append Make stages after the Go stages)

**Interfaces:**
- Produces: Make targets `tools`, `bootstrap`, `test T=<prefix ...>`, `t1`, `t2`, `smoke`; `build-run/tools/timeout [--elapsed] SECS CMD...` (exit 124 on expiry, `elapsed_ms=N` last stderr line); `tests/lib.sh` functions listed in Step 3; result-line format `PASS|SKIP|FAIL(...) <group>/<name> <secs>s`.

- [ ] **Step 1: Branch**

```sh
git checkout -b go-retirement main
```

- [ ] **Step 2: Write `tests/tools/timeout.c`**

```c
/* tests/tools/timeout.c -- run CMD under a wall-clock deadline.
 * usage: timeout [--elapsed] SECONDS CMD [ARGS...]
 * The child runs in its own process group. On expiry the group gets
 * SIGTERM, then SIGKILL two seconds later, and we exit 124. Otherwise
 * the child's status is propagated (128+signal if it died by signal).
 * --elapsed prints "elapsed_ms=N" as the last line on stderr (macOS
 * date(1) has no sub-second field; tests/perfgate needs this). */
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <unistd.h>

static pid_t child;
static volatile sig_atomic_t fired;

static void on_alarm(int sig) {
    (void)sig;
    fired++;
    if (fired == 1) { kill(-child, SIGTERM); alarm(2); }
    else            { kill(-child, SIGKILL); }
}

int main(int argc, char **argv) {
    int elapsed = 0, ai = 1;
    if (ai < argc && strcmp(argv[ai], "--elapsed") == 0) { elapsed = 1; ai++; }
    if (argc - ai < 2) {
        fprintf(stderr, "usage: timeout [--elapsed] SECONDS CMD [ARGS...]\n");
        return 2;
    }
    unsigned secs = (unsigned)strtoul(argv[ai], NULL, 10);
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    child = fork();
    if (child < 0) { perror("fork"); return 2; }
    if (child == 0) {
        setpgid(0, 0);
        execvp(argv[ai + 1], argv + ai + 1);
        perror(argv[ai + 1]);
        _exit(127);
    }
    setpgid(child, child);
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_alarm;          /* no SA_RESTART: waitpid must EINTR */
    sigaction(SIGALRM, &sa, NULL);
    alarm(secs);
    int status;
    while (waitpid(child, &status, 0) < 0) {
        if (errno != EINTR) { perror("waitpid"); return 2; }
    }
    gettimeofday(&t1, NULL);
    if (elapsed) {
        long ms = (t1.tv_sec - t0.tv_sec) * 1000L + (t1.tv_usec - t0.tv_usec) / 1000L;
        fprintf(stderr, "elapsed_ms=%ld\n", ms);
    }
    if (fired) return 124;
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return 2;
}
```

- [ ] **Step 3: Write `tests/lib.sh`**

```sh
# tests/lib.sh -- sourced by every test script (POSIX sh). The runner
# (tests/run1.sh) exports ROOT and runs scripts with cwd = repo root;
# the fallback lets a script be run by hand from anywhere.
set -u
ROOT=${ROOT:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel)}
cd "$ROOT" || exit 2
BR=$ROOT/build-run
TOOLS=$BR/tools
CLARUSC=$BR/clarusc-current
CLARUSC_SNAPSHOT=$BR/clarusc-snapshot
RTDIR=$ROOT/runtime/clarus/
HOSTRT=$ROOT/runtime/host
CC=${CC:-cc}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/clarus-test.XXXXXX") || exit 2
trap 'rm -rf "$WORK"' EXIT
STATUS=0

# --- result protocol -------------------------------------------------
t_pass() { echo "PASS $1"; }
t_fail() { echo "FAIL $1: $2"; STATUS=1; }
t_done() { exit $STATUS; }
die()    { echo "FATAL: $*" >&2; exit 1; }
skip()   { echo "SKIP: $*"; exit 77; }

# --- gates -----------------------------------------------------------
require_env()  { eval "_v=\${$1:-}"; [ "$_v" = 1 ] || skip "$1 not set"; }
require_tool() { [ -x "$1" ] || skip "$1 not found"; }
require_vasm() {
    VASM=$ROOT/vasm/vasmm68k_mot
    [ -x "$VASM" ] || skip "vasm not built"
    printf ' dc.b 1,2,3,4\n' > "$WORK/probe.s"
    "$VASM" -m68000 -no-opt -Fbin -quiet -o "$WORK/probe.bin" "$WORK/probe.s" >/dev/null 2>&1 \
        || skip "vasm -Fbin probe failed"
    [ "$(od -An -tx1 "$WORK/probe.bin" | tr -d ' \n')" = 01020304 ] || skip "vasm -Fbin probe wrong bytes"
}
env_set() { eval "_v=\${$1:-}"; [ -n "$_v" ]; }

# --- goldens ---------------------------------------------------------
# golden_check FILE GOLDEN BLESSVAR : bless (copy) if $BLESSVAR is set,
# else byte-compare; on mismatch print the first differing byte and a
# unified diff excerpt and return 1.
golden_check() {
    if env_set "$3"; then cp "$1" "$2"; echo "BLESSED $2"; return 0; fi
    cmp -s "$1" "$2" && return 0
    echo "golden mismatch: $2"
    cmp "$1" "$2" 2>&1 | head -1
    diff -u "$2" "$1" | head -60
    return 1
}
# first_diff A B : line-oriented first mismatch (mirrors mactest firstDiff)
first_diff() { diff "$1" "$2" | head -5; }

# --- building --------------------------------------------------------
# host_build OUT FILE.cla... : clarusc emit + cc, host binary at OUT
host_build() {
    _out=$1; shift
    "$CLARUSC" emit --rtdir "$RTDIR" -o "$_out.c" "$@" || return 1
    $CC -O1 -I "$HOSTRT" -o "$_out" "$_out.c" "$HOSTRT/rt.c"
}
# emit68k ARGS... : clarusc emit68k with the runtime dir supplied
emit68k() { "$CLARUSC" emit68k --rtdir "$RTDIR" "$@"; }
# run_c_test SRC.c : cc -std=c99 -Wall -Werror against rt.c, run, expect "OK"
run_c_test() {
    _exe=$WORK/$(basename "$1" .c)
    $CC -std=c99 -Wall -Werror -I "$HOSTRT" "$1" "$HOSTRT/rt.c" -o "$_exe" || return 1
    _got=$("$_exe" 2>&1) || { echo "$_got"; return 1; }
    [ "$_got" = OK ] || { echo "expected OK, got: $_got"; return 1; }
}
# mem_live LOGFILE : the last ##CLARUS-MEM## live=N count, or empty
mem_live() { grep -o '##CLARUS-MEM## live=[0-9]*' "$1" | tail -1 | sed 's/.*live=//'; }
```

- [ ] **Step 4: Write `tests/run1.sh` and `tests/summary.sh`**

```sh
#!/bin/sh
# tests/run1.sh SCRIPT RESULT -- run one test script under the deadline,
# write "<STATUS> <name> <secs>s" to RESULT and the log next to it.
script=$1; result=$2
ROOT=$(cd "$(dirname "$0")/.." && pwd); export ROOT; cd "$ROOT"
log=${result%.result}.log
name=${script#tests/}; name=${name%.sh}
t=$(sed -n 's/^# timeout: *//p' "$script" | head -1)
case "$t" in
    "") t=600 ;;
    *h) t=$(( ${t%h} * 3600 )) ;;
    *m) t=$(( ${t%m} * 60 )) ;;
    *s) t=${t%s} ;;
esac
mkdir -p "$(dirname "$result")"
start=$(date +%s)
build-run/tools/timeout "$t" sh "$script" > "$log" 2>&1
rc=$?
secs=$(( $(date +%s) - start ))
if [ $rc -eq 77 ]; then st=SKIP
elif [ $rc -eq 124 ]; then st="FAIL(timeout ${t}s)"
elif [ $rc -eq 0 ] && ! grep -q '^FAIL ' "$log"; then st=PASS
else st="FAIL(exit $rc)"; fi
echo "$st $name ${secs}s" | tee "$result"
```

```sh
#!/bin/sh
# tests/summary.sh RESULT... -- print counts, dump failing logs, exit 1 on any FAIL.
[ $# -gt 0 ] || { echo "summary: no tests matched" >&2; exit 2; }
pass=0; skip=0; fail=0
for r in "$@"; do
    case "$(cut -d' ' -f1 "$r")" in
        PASS) pass=$((pass+1)) ;;
        SKIP) skip=$((skip+1)) ;;
        *) fail=$((fail+1)); echo "=== $(cat "$r")"; tail -40 "${r%.result}.log"; echo ;;
    esac
done
echo "tests: $pass passed, $skip skipped, $fail failed"
[ $fail -eq 0 ]
```

- [ ] **Step 5: Write the `Makefile`**

```make
# Makefile -- Clarus test runner (go-retirement phase). GNU Make 3.81.
# make t1 | make t2 | make test T='cg68k/goldens bake/' | make smoke
CC ?= cc
BR := build-run
J ?= $(shell sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

TOOL_SRCS := $(wildcard tests/tools/*.c)
TOOLS := $(patsubst tests/tools/%.c,$(BR)/tools/%,$(TOOL_SRCS))
RT_HOST := $(wildcard runtime/host/*)
CLA_SRC := $(wildcard clarusc/*.cla) $(wildcard runtime/clarus/*.cla)

TESTS := $(shell find tests -name '*.sh' ! -name 'lib*.sh' ! -name run1.sh ! -name summary.sh | sort)
T ?=
SEL := $(foreach p,$(T),$(filter tests/$(p)%,$(TESTS)))
T1 := $(filter-out tests/selfhost/% tests/perfgate/%,$(TESTS))
RES = $(patsubst tests/%.sh,$(BR)/tests/%.result,$(1))

.PHONY: tools bootstrap test t1 t2 smoke
tools: $(TOOLS)
bootstrap: $(BR)/clarusc-current

$(BR)/tools/%: tests/tools/%.c
	@mkdir -p $(BR)/tools
	$(CC) -std=c99 -Wall -Werror -o $@ $<

# Two-stage bootstrap, mirroring internal/claruscboot: the committed C
# snapshot builds clarusc-snapshot; that emits the current .cla source to
# C, which builds clarusc-current. mtime deps replace the Go stamp files;
# make's scheduling replaces the flock (every test depends on bootstrap).
$(BR)/clarusc-snapshot: clarusc/clarusc.c $(RT_HOST)
	@mkdir -p $(BR)
	$(CC) -O1 -I runtime/host -o $@.tmp clarusc/clarusc.c runtime/host/rt.c && mv $@.tmp $@

$(BR)/clarusc-current: $(BR)/clarusc-snapshot $(CLA_SRC)
	$(BR)/clarusc-snapshot emit --rtdir runtime/clarus/ -o $@.c clarusc/main.cla
	$(CC) -O1 -I runtime/host -o $@.tmp $@.c runtime/host/rt.c && mv $@.tmp $@

# Every result is rebuilt on every run (FORCE): there is no result cache.
$(BR)/tests/%.result: tests/%.sh FORCE | tools bootstrap
	@tests/run1.sh $< $@
FORCE:

test: $(call RES,$(SEL))
	@tests/summary.sh $^
t1: $(call RES,$(T1))
	@tests/summary.sh $^
smoke:
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T='mactest/smoke_bounce mactest/tick'
t2:
	$(MAKE) -j$(J) t1
	$(MAKE) test T=perfgate/
	$(MAKE) test T=selfhost/
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T=mactest/
	CLARUS_BAKE_FULL=1 $(MAKE) -j$(J) test T=bake/full_corpus_
```

- [ ] **Step 6: Write the runner self-checks**

`tests/runner/timeout.sh`:

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
"$TOOLS/timeout" 1 sleep 5; rc=$?
[ $rc -eq 124 ] && t_pass expiry || t_fail expiry "exit $rc, want 124"
"$TOOLS/timeout" 5 sh -c 'exit 7'; rc=$?
[ $rc -eq 7 ] && t_pass propagate || t_fail propagate "exit $rc, want 7"
"$TOOLS/timeout" 1 sh -c 'sleep 30 & wait' ; rc=$?
sleep 1
pgrep -f 'sleep 30' >/dev/null && t_fail group "grandchild survived" || t_pass group
ms=$("$TOOLS/timeout" --elapsed 5 sleep 0 2>&1 | sed -n 's/^elapsed_ms=//p')
[ -n "$ms" ] && t_pass elapsed || t_fail elapsed "no elapsed_ms line"
t_done
```

`tests/runner/selfcheck.sh` (drives `run1.sh` on throwaway scripts):

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
mk() { printf '#!/bin/sh\n%s\n' "$2" > "$WORK/$1.sh"; }
mk pass 'exit 0'
mk skip 'exit 77'
mk failx 'exit 3'
mk failline 'echo "FAIL x: boom"; exit 0'
mk slow '# timeout: 1s
sleep 5'
for n in pass skip failx failline slow; do
    got=$(tests/run1.sh "$WORK/$n.sh" "$WORK/$n.result" | cut -d' ' -f1)
    case "$n:$got" in
        pass:PASS|skip:SKIP|"failx:FAIL(exit 3)"|"failline:FAIL(exit 0)"|"slow:FAIL(timeout 1s)") t_pass "$n" ;;
        *) t_fail "$n" "status $got" ;;
    esac
done
t_done
```

(`run1.sh` computes the name from the script path, so scripts outside `tests/` get a `../` name; that is fine for this check.)

- [ ] **Step 7: Run and verify**

```sh
make -j tools bootstrap && make -j t1
```
Expected: `tests: 2 passed, 0 skipped, 0 failed`. Then `make test T=runner/timeout` alone prints one PASS line.

- [ ] **Step 8: Wrappers run both harnesses**

Append to `scripts/test-task.sh` after the existing `go test` block (before the `END=` line):

```sh
make -j"$(sysctl -n hw.ncpu)" tools bootstrap
make -j"$(sysctl -n hw.ncpu)" t1
make test T=perfgate/ || true   # no perfgate scripts until Task 2
if [ "$SMOKE" = "1" ]; then make smoke || true; fi   # no scripts until Task 13
```

Append to `scripts/test-merge.sh` before the final `END=` line: `make t2 || true` with a `# transition: Make lane, hard-failing from Task 15` comment. Both `|| true` guards come off in Task 15.

- [ ] **Step 9: Gate and commit**

```sh
scripts/test-task.sh
git add Makefile tests scripts/test-task.sh scripts/test-merge.sh
git commit -m "test(harness): Make runner, lib.sh, timeout tool (go-retirement Task 1)"
```

---

### Task 2: `hostrt`, `claruscboot`, `perfgate`

**Files:**
- Create: `tests/hostrt/{fileh,mem,rc,serial,ser_leak,smoke,smoke_collections,smoke_slice_index_append,smoke_log,smoke_args,smoke_slice_oob,smoke_text_slice_len,slice_overflow}.sh`; `runtime/host/rt_smoke_test.c`, `rt_smoke_collections_test.c`, `rt_smoke_slice_index_append_test.c`, `rt_smoke_log_test.c`, `rt_smoke_args_test.c` (the five C `main`s currently embedded as Go strings in `internal/hostrt/rtsmoke_test.go`, copied verbatim); `tests/claruscboot/{checks_fixture,cache_reuse}.sh`; `tests/perfgate/tripwire.sh`; move `internal/perfgate/baseline.txt` → `tests/perfgate/baseline.txt` (`git mv`; the Go test reads it by relative path, so update `internal/perfgate/perfgate_test.go`'s path to `../../tests/perfgate/baseline.txt` so Go keeps working until Task 15).

**Port table** (Go file → script → assertions to preserve):

| Go test | Script | Must preserve |
|---|---|---|
| `filehtest_c_test.go` TestFilehC | `hostrt/fileh.sh` | `run_c_test runtime/host/rt_fileh_test.c`; cwd = `$WORK` |
| `memtest_c_test.go` | `hostrt/mem.sh` | compiles `rt_mem_test.c` alone (no `rt.c`); run with cwd = exe dir (it re-execs `./argv[0]` with `CLARUS_MEM_PARANOID=1`) |
| `rctest_c_test.go` | `hostrt/rc.sh` | `rt_rc_test.c` |
| `serialtest_c_test.go` | `hostrt/serial.sh` | `rt_serial_test.c` |
| `sertest_c_test.go` (2) | `hostrt/ser_leak.sh` | run `rt_ser_test.c` plain → `OK`; run again with `CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1`, `mem_live` of stderr must be `0` |
| `rtsmoke_test.go` 8 tests | one script each as listed in Files | exit-3 + `slice out of range` on stderr for the three panic tests, including `start=INT32_MAX,len=5` |
| `claruscboot_test.go` TestCurrentExeChecksFixture | `claruscboot/checks_fixture.sh` | `$CLARUSC testdata/valid/bookmarks.cla` exits 0 with empty output |
| TestCacheReuse | `claruscboot/cache_reuse.sh` | `stat -f %m build-run/clarusc-current` before/after a second `make bootstrap` is unchanged |
| `perfgate_test.go` | `perfgate/tripwire.sh` | 3 runs, median, fail above 2× baseline, same failure text incl. re-baseline instructions pointing at `tests/perfgate/baseline.txt` |

- [ ] **Step 1: Extract the five embedded C mains** from `rtsmoke_test.go` into `runtime/host/rt_smoke_*_test.c` byte for byte (they are Go raw strings; copy the content between the backticks). Point the Go test at the files (`os.ReadFile`) so both harnesses share one copy.

- [ ] **Step 2: Write the scripts.** Exemplar `tests/hostrt/smoke_slice_oob.sh`:

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
exe=$WORK/oob
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_smoke_test.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" slice-oob > "$WORK/out" 2> "$WORK/err"; rc=$?
[ $rc -eq 3 ] || die "exit $rc, want 3"
grep -q 'slice out of range' "$WORK/err" || die "stderr lacks 'slice out of range'"
```
(Check `rtsmoke_test.go` for how each panic variant is selected: if the Go test compiles a distinct `main`, keep one `.c` per variant instead of an argv switch. Match the Go exactly.)

Exemplar `tests/perfgate/tripwire.sh`:

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
base=$(grep -v '^#' tests/perfgate/baseline.txt | grep -v '^$' | head -1)
[ -n "$base" ] || die "no baseline value"
for i in 1 2 3; do
    ms=$("$TOOLS/timeout" --elapsed 300 "$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/every.c" testdata/emitui/every.cla 2>&1 >/dev/null | sed -n 's/^elapsed_ms=//p')
    [ -n "$ms" ] || die "emit run $i failed"
    echo "$ms"
done | sort -n > "$WORK/runs"
median=$(sed -n 2p "$WORK/runs")
limit=$(awk -v b="$base" 'BEGIN{printf "%d", b*2*1000}')
echo "emit runs (ms): $(tr '\n' ' ' < "$WORK/runs"); median ${median}ms; baseline ${base}s; limit ${limit}ms"
[ "$median" -le "$limit" ] || die "emit-time tripwire: median ${median}ms exceeds 2x baseline ${base}s (limit ${limit}ms) -- either a real regression, or the baseline is stale: re-baseline by editing tests/perfgate/baseline.txt to the new median and justifying the change in the commit message"
```

- [ ] **Step 3: Run** `make test T='hostrt/ claruscboot/ perfgate/'` → all PASS.

- [ ] **Step 4: Mutation check.** Edit `runtime/host/rt_fileh_test.c` to print `OK!` instead of `OK`, run `make test T=hostrt/fileh`, expect `FAIL(exit 1)`; revert. Set `tests/perfgate/baseline.txt` to `0.001`, expect FAIL with the tripwire text; revert.

- [ ] **Step 5: Gate and commit** `scripts/test-task.sh` (both lanes green); commit `test(harness): port hostrt, claruscboot, perfgate (go-retirement Task 2)`.

---

### Task 3: `asm68k`, `reftest`, `sertest`

**Files:**
- Create: `tests/asm68k/roundtrip.sh`; `tests/asm68k/exercise.cla` (git mv from `internal/asm68k/`; update the Go test's path); `tests/reftest/{extract,checkclean,required}.sh`, `tests/reftest/manifest.txt`; `tests/sertest/{roundtrip,badfield,clrd}.sh`

| Go test | Script | Must preserve |
|---|---|---|
| `vasm_test.go` TestVasmRoundTrip | `asm68k/roundtrip.sh` | `require_vasm`; `host_build` exercise.cla; run it in `$WORK` (writes `exer.s`,`exer.dat`); `vasmm68k_mot -m68000 -no-opt -Fbin -o out.bin exer.s`; `cmp out.bin exer.dat`; on mismatch print `cmp` offset and `xxd -s $((off-16)) -l 32` of both |
| `reftest_test.go` TestFencesExtract | `reftest/extract.sh` | fence count ≥ 20 |
| TestCheckCleanFences | `reftest/checkclean.sh` | for every index in `manifest.txt`: write fence to `$WORK/fN.cla`, `$CLARUSC $WORK/fN.cla` exit 0 with empty output; one `t_pass fN`/`t_fail` per index |
| TestRequiredProgramsInManifest | `reftest/required.sh` | locate the four full programs by the same content substrings the Go test uses; each index must appear in `manifest.txt` |
| `sertest_test.go` TestRoundtrip | `sertest/roundtrip.sh` | stdout vs `roundtrip.out.golden`; `rec.dat` vs `roundtrip.bytes.golden`; `pad.dat` vs `padprobe.bytes.golden` |
| TestBadFieldRejected | `sertest/badfield.sh` | emit must fail (nonzero) with the same diagnostic substring |
| `clrdcompare_test.go` TestCLRDByteCompare | `sertest/clrd.sh` | every fixture's stdout + every `.dat` vs `testdata/sertest/clrd_goldens/<fixture>.<file>`; bless var `CLRD_BLESS` via `golden_check` |

- [ ] **Step 1: Fence extractor** — in `tests/reftest/extract.sh` define and use:

```sh
# fences FILE       -> count
# fences FILE N     -> body of fence N (0-based) on stdout
# fences FILE find SUBSTR -> index of first fence containing SUBSTR
fences() {
    awk -v want="${2:-count}" -v sub_="${3:-}" '
        /^```rust$/ && !in_f { in_f=1; body=""; next }
        /^```$/ && in_f { in_f=0;
            if (want=="count") n++;
            else if (want=="find") { if (index(body, sub_)) { print n; exit } ; n++ }
            else if (n==want+0) { printf "%s", body; exit } else n++;
            next }
        in_f { body = body $0 "\n" }
        END { if (want=="count") print n+0 }' "$1"
}
```
Put it in `tests/lib.sh` under a `# --- reftest` header so all three scripts share it.

- [ ] **Step 2: `manifest.txt`** — transcribe `internal/reftest/manifest.go`'s `CheckClean` indices one per line, and every exclusion comment as a `# ...` line at the same position, verbatim.

- [ ] **Step 3: Write the scripts, run** `make test T='asm68k/ reftest/ sertest/'`.

- [ ] **Step 4: Mutation check** — append a byte to `testdata/sertest/roundtrip.out.golden` → `sertest/roundtrip` FAIL; revert. Add a bogus index `999` to `manifest.txt` → `reftest/checkclean` FAIL; revert.

- [ ] **Step 5: Gate and commit** `test(harness): port asm68k, reftest, sertest (go-retirement Task 3)`.

---

### Task 4: `lowlevel`, `testsuite`

**Files:**
- Create: `tests/lowlevel/{run,rtinc,incdedup,constdedup,xrecorder}.sh`; `tests/testsuite/{catalog,catalog_ui,core_cli,lazyintern}.sh`; `tests/testsuite/core_cases.txt` (the 81 `wantCases` names from `core_cli_test.go`, in order)

| Go test | Script | Must preserve |
|---|---|---|
| `lowlevel_test.go` TestLowlevel | `lowlevel/run.sh` | every `testdata/lowlevel/*.cla`: `host_build`, run under `CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1`, stdout vs `.out`, `mem_live` = 0; `t_pass`/`t_fail` per fixture |
| `rtinc_test.go` TestRtInc (6 subtests), TestTestApiFlag (3) | `lowlevel/rtinc.sh` | same 9 subcases by name; `copyDir` = `cp -R` into `$WORK` with no `runtime/clarus` ancestor |
| `incdedup_test.go` (2) | `lowlevel/incdedup.sh`, `lowlevel/constdedup.sh` | the un-cleaned `dir/./main.cla` second-arg spelling must be passed literally |
| `xrecorder_test.go` | `lowlevel/xrecorder.sh` | diagnostic present, `list index out of range` absent |
| `catalog_test.go` TestCatalogChecks | `testsuite/catalog.sh` | compose the same driver text, check-only over driver + all catalog files |
| TestCatalogComposesWithUIRuntime | `testsuite/catalog_ui.sh` | two subcases `emit`, `emit68k`; exit 0, no `list index out of range` |
| `core_cli_test.go` TestCoreSuiteCLI | `testsuite/core_cli.sh` | build with `coreCLIFiles` list; `all` → PASS lines equal `core_cases.txt` in order, `TOTAL` line exact; single-name run; unknown-name run's exit/text as in Go |
| `lazyintern_test.go` | `testsuite/lazyintern.sh` | the two regexes (`== -1` sentinel guard; `Inited: bool` guard) over comment-stripped `clarusc/*.cla`; every guarded global needs a reset assignment somewhere; report each missing one as `FAIL` |

- [ ] **Step 1: Write scripts.** Exemplar `tests/lowlevel/run.sh`:

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
for f in testdata/lowlevel/*.cla; do
    n=$(basename "$f" .cla)
    if ! host_build "$WORK/$n" "$f" > "$WORK/$n.build" 2>&1; then
        t_fail "$n" "build: $(head -3 "$WORK/$n.build" | tr '\n' ' ')"; continue
    fi
    CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 "$WORK/$n" > "$WORK/$n.out" 2> "$WORK/$n.err"
    if ! cmp -s "$WORK/$n.out" "testdata/lowlevel/$n.out"; then
        t_fail "$n" "stdout: $(first_diff "testdata/lowlevel/$n.out" "$WORK/$n.out" | tr '\n' ' ')"; continue
    fi
    live=$(mem_live "$WORK/$n.err")
    [ "$live" = 0 ] && t_pass "$n" || t_fail "$n" "live=$live"
done
t_done
```

- [ ] **Step 2: Run** `make test T='lowlevel/ testsuite/'`.
- [ ] **Step 3: Mutation check** — edit one `testdata/lowlevel/*.out`; swap two names in `core_cases.txt`; both must FAIL; revert.
- [ ] **Step 4: Gate and commit** `test(harness): port lowlevel, testsuite (go-retirement Task 4)`.

---

### Task 5: `uiblob` tool and `emitui`

**Files:**
- Create: `tests/tools/uiblob.c`; `tests/emitui/{goldens,errconst,popupguards,uiblob,appinfo}.sh`; `testdata/emitui/uiblob_probe.dump.golden` (new, generated once by the tool and reviewed by hand against the counts `TestUiBlobGolden` asserts)

**Interfaces:**
- Produces: `uiblob FILE` → text dump, one line per decoded item, format `header <field>=<n>`, `window <i> <field>=<n> ...`, `widget <i> ...`, `table`, `form`, `bind`, `enumlayout`, `menu`, `handler`, `every`, `app <field>=<n>`; strings printed as `"..."` or `-` for the −1 absent sentinel; exit 1 with `decode error at offset N: reason` on any truncation.

- [ ] **Step 1: Port the decoder.** Read `internal/emitui/emitui_test.go`'s `uiBlobDecoder` (the `int()`/`str()` readers and the walk order) and transcribe it into `uiblob.c`: big-endian int32 reader, Pascal-style length-prefixed string reader with the −1 sentinel, the same section order, a bounds check before every read.

- [ ] **Step 2: `tests/emitui/uiblob.sh`**:

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
"$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/probe.c" testdata/emitui/uiblob_probe.cla || die emit
# extract clar_ui_blob[] initialiser bytes (same regex intent as uiBlobArrayRe/uiBlobIntRe)
awk '/clar_ui_blob\[\] *= *\{/{f=1;next} f&&/\};/{exit} f' "$WORK/probe.c" \
  | tr -d ' \n' | tr ',' '\n' | grep -v '^$' \
  | awk '{printf "%02x", $1+0}' | xxd -r -p > "$WORK/probe.blob"
golden_check "$WORK/probe.blob" testdata/emitui/uiblob_probe.blob.golden NO_BLESS || STATUS=1
"$TOOLS/uiblob" "$WORK/probe.blob" > "$WORK/probe.dump" || die "uiblob decode"
golden_check "$WORK/probe.dump" testdata/emitui/uiblob_probe.dump.golden NO_BLESS || STATUS=1
t_done
```
(Confirm the initialiser's literal form in the emitted C — decimal vs hex — and adjust the awk to match what `uiBlobIntRe` matched.)

- [ ] **Step 3: Remaining scripts** per table:

| Go test | Script | Must preserve |
|---|---|---|
| TestEmitUiGoldens | `emitui/goldens.sh` | every `testdata/emitui/*.cla` with a `.c.golden`: emit, `cmp`; then `toolchain/bin/m68k-apple-macos-gcc -x c -c` the golden against `rt_ui.h` (whole script `skip` if the gcc is absent, exactly as `m68kGCC` skipped); `t_pass`/`t_fail` per fixture |
| TestEmitUiErrConstAt, TestEmitUiTablePopupGuards (8) | `emitui/errconst.sh`, `emitui/popupguards.sh` | exact diagnostic substrings per named fixture |
| `appinfo_test.go` (5) | `emitui/appinfo.sh` | exact stdout `app=1\nname=...\nversion=...` contract, the three name-resolution rungs, icon path relative to the declaring file, checker-error passthrough |

- [ ] **Step 4: Run, mutation check** (flip a byte in one `.c.golden` and in `uiblob_probe.dump.golden`), **gate, commit** `test(harness): uiblob tool + emitui (go-retirement Task 5)`.

---

### Task 6: `cg68k` listings

**Files:**
- Create: `tests/cg68k/{goldens,vasm,determinism,array_assign,release,selfemit}.sh`

| Go test | Script | Must preserve |
|---|---|---|
| TestCg68kGoldens | `cg68k/goldens.sh` | every `testdata/cg68k/*.cla`: `emit68k --listing`; every `out.segN.s` vs golden (`<name>.s` for seg 1, `<name>.segN.s` after); bless `CLARUS_CG68K_BLESS`; a golden that exists for a segment not emitted (or vice versa) is a failure |
| TestCg68kVasmRoundTrip | `cg68k/vasm.sh` | `require_vasm`; per segment: vasm `out.segN.s` → cmp `out.segN.dat` |
| TestCg68kDeterminism | `cg68k/determinism.sh` | `control.cla` twice, `.dat` identical |
| TestSAssignWholeArraySucceeds / ...HandleElemFailsClosed | `cg68k/array_assign.sh` | first must emit and vasm-round-trip; second must fail with the named error text |
| TestCallResultRelease, TestGetterResultRelease, TestAndOrShortCircuitRelease | `cg68k/release.sh` | per-function `rtTextRelease` call counts in both `BSR.W`/`JSR LBL_n` and `JSR N(A5)` forms with slot `(N-32)/8` and the `+2` entry offset; the `BEQ.W`…`BRA.W` region containment check |
| TestSelfEmit68k | `cg68k/selfemit.sh` | `emit68k clarusc/main.cla` exit 0 at the default segment limit |

- [ ] **Step 1: Write `release.sh`'s awk helpers** (in the script):

```sh
# func_region SEGFILE LABEL : lines from "LABEL:" to the next top-level label
func_region() { awk -v L="$2" '$0==L":"{f=1;next} f&&/^[A-Za-z_][A-Za-z0-9_]*:$/{exit} f' "$1"; }
# count_release TEXT SLOT : same-segment (BSR.W/JSR LBL) + cross-segment JSR d(A5) with (d-32)/8==SLOT
count_release() { printf '%s\n' "$1" | awk -v slot="$2" '
    /BSR\.W +rtTextRelease|JSR +rtTextRelease/ {n++}
    match($0,/JSR +(-?[0-9]+)\(A5\)/){d=substr($0,RSTART+4,RLENGTH-8)+0; if ((d-32)%8==2 && int((d-32)/8)==slot) n++}
    END{print n+0}'; }
```
Read the Go `findFuncInSeg`/`countReleaseCalls`/`shortCircuitRegion` first and make the awk match their exact label and instruction spellings; the Go regex strings are authoritative.

- [ ] **Step 2: Write the rest, run** `make test T=cg68k/` (the resfork-dependent scripts come in Task 7).
- [ ] **Step 3: Mutation check** — edit one listing golden; change the expected release count in `release.sh` by one; both FAIL; revert.
- [ ] **Step 4: Gate, commit** `test(harness): port cg68k listing gates (go-retirement Task 6)`.

---

### Task 7: `resfork` tool, `cg68k` image/segments, `mactest` resparity

**Files:**
- Create: `tests/tools/resfork.c`; `tests/cg68k/{image,segments}.sh`; `tests/mactest/resparity.sh`; move `internal/mactest/testdata/icon_probe.pbm` → `tests/mactest/testdata/icon_probe.pbm` (update the Go path)

**Interfaces:**
- Produces: `resfork header FILE` → `name=... type=APPL creator=... datalen=N rsrclen=N ver=129/129 crc=ok|bad dates=0|nonzero`; `resfork list FILE` → `TYPE ID "NAME" OFFSET LEN` per resource (name `-` if none); `resfork get FILE TYPE ID OUT`; `resfork code0 FILE` → `above_a5=N below_a5=N jt_size=N jt_off=N` then `slot SEG OFFSET filler=3F3C trailer=A9F0` per entry with `BAD` appended when the filler/trailer/offset checks fail; `resfork size FILE` → the 10 SIZE(-1) bytes as hex. Exit 1 with `parse error: reason` on any malformed input. CRC-16/XMODEM self-test on the `"123456789"`→`0x31C3` vector at startup (abort if it fails).

- [ ] **Step 1: Port** `internal/cg68k/image_test.go`'s `parseResourceFork`/`crc16Xmodem` and `internal/mactest/resparity_test.go`'s `resparParseFork` (Inside Macintosh name-offset decoding) into `resfork.c`. Keep every structural check `image_test.go` makes (`dataOff==256`, `mapOff==dataOff+dataLen`, map length, JT entry 0 offset 0).

- [ ] **Step 2: Scripts:**

| Go test | Script | Must preserve |
|---|---|---|
| TestImageStructure, TestImageDeterminism | `cg68k/image.sh` | every field assertion via `resfork header/code0/size`; SIZE(-1) exact 10 bytes; two emits identical |
| TestSegmentationMultiSegment | `cg68k/segments.sh` | >1 CODE segment; every JT slot resolves inside its segment's code range; every segment owns ≥1 slot; `JSR d(A5)` in every `.segN.s` has `(d-32)%8==2`; per-segment vasm round trip; determinism |
| TestSegmentationOversizedFunction / OversizedFrame | `cg68k/segments.sh` (subcases) | generate the 6000-statement function and the 70-arg call with a shell loop; expect the named compile errors, not crashes |
| TestApp68kResourceParity | `mactest/resparity.sh` | `resfork get` each of ALRT/DITL/vers/SIZE/STR/FREF/BNDL/ICN#/ICON, `cmp` against `testdata/mac/resparity/*.bin` (frozen: no bless var) |
| TestApp68kIconMissingWarns | `mactest/resparity.sh` | warning on both channels; fork identical to the icon-stripped twin |
| TestApp68kIconAcceptsCRLineEndings | `mactest/resparity.sh` | build CR-only and CRLF variants of `icon_probe.pbm` with `tr '\n' '\r'` and `sed 's/$/\r/'`; all three forks identical |

- [ ] **Step 3: Run, mutation check** (flip a byte in one `testdata/mac/resparity/*.bin`), **gate, commit** `test(harness): resfork tool + image/segment/resparity gates (go-retirement Task 7)`.

---

### Task 8: `clirhdr` tool and `bake` (header tests)

**Files:**
- Create: `tests/tools/clirhdr.c`; `tests/bake/{twice,header,bodyhash,corrupt}.sh`; add to `tests/lib.sh`: `bake_ir LANE OUT` (`"$CLARUSC" --bake-ir --lane "$1" -o "$2"` with cwd root)

**Interfaces:**
- Produces: `clirhdr FILE` → line 1 `version=7 lane=68k|c stamp=<hex> bodyhash=<hex> modules=N sections=N body_off=N`, then `module <key>` per module and `section <id> <len> <off>` per section; exit 1 `parse error at N: reason` (including trailing-byte accounting). `clirhdr --flip-stamp FILE OUT` / `--flip-body FILE OUT` write a copy with the first stamp/body byte XOR 0xFF.

- [ ] **Step 1: Port `bake.ParseHeader`** (`internal/bake/bake.go`) field for field, keeping every `need(n)` bounds check.

- [ ] **Step 2: Scripts:**

| Go test | Script | Must preserve |
|---|---|---|
| TestBakeTwiceIdentical | `bake/twice.sh` | both lanes baked twice, `cmp` |
| TestBakeHeaderSanity | `bake/header.sh` | per lane: version 7, lane tag, non-empty stamp, modules 23 (68k) / 18 (c), sections 46, every module key under `runtime/clarus/`, `native.cla` present iff 68k |
| TestBakeHeaderBodyHashMasked | `bake/bodyhash.sh` | bit 31 of bodyhash clear: `[ $((0x$hash & 0x80000000)) -eq 0 ]` |
| TestBakeCorruptStampFixture | `bake/corrupt.sh` | flipped file still parses, stamp differs, exactly one differing byte (`cmp -l | wc -l` = 1) |

- [ ] **Step 3: Run, mutation check** (change `modules=23` to `24` in `header.sh`), **gate, commit** `test(harness): clirhdr tool + bake header gates (go-retirement Task 8)`.

---

### Task 9: `bake` identity suite

**Files:**
- Create: one script per `Test*` in `internal/bake/bakeidentity_test.go` under `tests/bake/`: `identity.sh` (TestBakePathByteIdentity, subcase per fixture + self-compile), `connfileh.sh`, `refuse_stamp.sh`, `refuse_body.sh`, `refuse_objcode.sh`, `refuse_lane.sh`, `testapi_positive.sh`, `testapi_negative.sh`, `testapi_manifest_negative.sh`, `testapi_nonui_negative.sh`, `testapi_collision.sh`, `include_checkonly.sh` (subcases `CoreCla`, `ToolboxFiles`), `include_undefined_extern.sh`, `drift_fallback.sh`, `testapi_include_parity.sh`, `testapi_manifest_include_parity.sh`, and the gated `full_corpus_cg68k.sh`, `full_corpus_selfcompile.sh`, `full_corpus_emitui.sh`, `full_corpus_testapi.sh`, `full_corpus_testapi_nonui.sh`, `full_corpus_suite_core.sh`, `full_corpus_suite_toolbox.sh` (each starts with `require_env CLARUS_BAKE_FULL`). Add to `tests/lib.sh`: `emit68k_pair NAME FILES...` that emits FILES twice into `$WORK/src/NAME/` and `$WORK/bake/NAME/` (from-source vs `--rtbake`) and `cmp`s the `.bin`s — separate subdirectories with identical basenames, because MacBinary embeds the output filename.

- [ ] **Step 1: Read the whole Go file** and list its `Test*` names against the scripts above; any test not in the list gets its own script named after it. The full-corpus scripts assert plain byte-identity except `full_corpus_suite_toolbox.sh`, which asserts the documented fallback-class shape (the `falling back to a from-source compile` note), exactly as the Go test does.

- [ ] **Step 2: Exemplar `tests/bake/drift_fallback.sh`:**

```sh
#!/bin/sh
. "$(dirname "$0")/../lib.sh"
cp -R runtime/clarus "$WORK/rt"; cp -R toolbox "$WORK/toolbox"
bake_ir 68k "$WORK/rt.clir" || die bake
printf '\n// drift\n' >> "$WORK/toolbox/files.cla"
"$CLARUSC" emit68k --rtdir "$WORK/rt/" --rtbake "$WORK/rt.clir" -o "$WORK/out.bin" testdata/cg68k/smoke.cla > "$WORK/log" 2>&1 \
    || die "emit68k --rtbake failed: $(head -3 "$WORK/log")"
grep -q 'toolbox/files.cla differs from the baked copy; falling back to a from-source compile' "$WORK/log" \
    || die "no drift-fallback note in: $(head -5 "$WORK/log")"
```
(Match the exact fixture, flag spelling and note text used by `TestRtbakeDriftFallback`; the above is the shape, the Go file is the source of truth for the strings.)

- [ ] **Step 3: Run** `make test T=bake/` then `CLARUS_BAKE_FULL=1 make -j test T=bake/full_corpus_`.
- [ ] **Step 4: Mutation check** — change one expected diagnostic substring in `refuse_stamp.sh`; FAIL; revert.
- [ ] **Step 5: Gate, commit** `test(harness): port bake identity suite (go-retirement Task 9)`.

---

### Task 10: `tcpdrive` tool and `conntest`

**Files:**
- Create: `tests/tools/tcpdrive.c`; `tests/conntest/{connect,listen,envunset,abort,shadow}.sh`; move `internal/conntest/testdata/*.cla` → `tests/conntest/testdata/` (update Go paths)

**Interfaces:**
- Produces: `tcpdrive pick-port` → a free port number. `tcpdrive listen PORT SCRIPT` / `tcpdrive connect HOST:PORT [--retry SECS] SCRIPT`; SCRIPT lines: `expect FILE` (read exactly `size(FILE)` bytes with a 30 s read deadline, byte-compare), `expect-sub STRING MAXBYTES` (read until STRING seen or MAXBYTES read), `send FILE`, `sleep MS`, `close` (orderly shutdown), `await-close SECS` (peer must close within SECS). Exit 0 on script completion; 1 with `step N: <reason> at byte K` plus a 32-byte hex window on divergence; 2 on usage/socket errors. `--retry` re-dials every 250 ms with 500 ms connect attempts until SECS elapse.

- [ ] **Step 1: Write `tcpdrive.c`** (`socket`/`bind`/`listen`/`accept`/`connect`, `poll` for deadlines, no threads).

- [ ] **Step 2: Scripts:**

| Go test | Script | Must preserve |
|---|---|---|
| TestConnectMode | `conntest/connect.sh` | `tcpdrive listen` peer with script: `expect-sub "READY\r" 64`, `send sweep` (bytes 0–255 via `awk 'BEGIN{for(i=0;i<256;i++)printf "%c",i}'` → careful: use `printf` via `xxd -r -p` of `00..ff`), `expect sweep`, `send sweep`, `expect sweep`, `send qqq`, `await-close 5`; program run with `CLARUS_SERIAL_MODEM=connect:127.0.0.1:PORT`; program must exit on its own within 5 s (poll `kill -0`) |
| TestListenMode | `conntest/listen.sh` | up to 5 attempts of pick-port + spawn + `tcpdrive connect --retry 5`; greeting optional (data-driven) |
| TestEnvUnsetFailedPath | `conntest/envunset.sh` | `env -u CLARUS_SERIAL_MODEM -u CLARUS_SERIAL_PRINTER prog`; exit 1; stderr contains `failed:` |
| TestAbortDuringPump | `conntest/abort.sh` | `echo_abort.cla` exits within 2 s (`timeout 2`) |
| TestConnShadowedLocalIsNil | `conntest/shadow.sh` | builds clean; exit 3; `use of nil connection` on stderr |

- [ ] **Step 3: Run, mutation check** (change `QQQ` to `QQ` in `connect.sh`'s send file → `await-close` fails), **gate, commit** `test(harness): tcpdrive tool + conntest (go-retirement Task 10)`.

---

### Task 11: `mactest` host-only tests

**Files:**
- Create: `tests/mactest/{leakgate,dblcompile,dblcompile_bake,dblcompile_abort,abort_leak_baseline,pbm2icn,bake_named}.sh`

| Go test | Script | Must preserve |
|---|---|---|
| TestLeakGate subcases StoreTemps, ArrStore, ClearRefElems, ArrElem, PopArgLeak | `mactest/leakgate.sh` | `host_build` each `testdata/leakgate/*.cla`, run under `CLARUS_MEM_STRICT=1`, `mem_live` = 0 |
| DoubleCompile (+ alternating `tickprobe,catprobe,tickprobe`) | `mactest/dblcompile.sh` | live-block growth per extra compile ≤ 64; `leakfork_0.bin` vs `leakfork_2.bin` identical |
| DoubleCompileAbortRecovery | `mactest/dblcompile_abort.sh` | `[tickprobe, badabort, tickprobe]` |
| DoubleCompileBake | `mactest/dblcompile_bake.sh` | parse `BAKESTATE <i> k=v ...` lines with awk into per-compile `parsedBefore/objValid/boundary/eligible`; the four design-B checks from `checkDesignBStates` |
| TestAbortLeakBaseline | `mactest/abort_leak_baseline.sh` | the three 500-iteration shapes, live 0 |
| pbm2icn_test.go (all) | `mactest/pbm2icn.sh` | compile `scripts/pbm2icn.c`; P1 vs P4 byte-identical Rez output; spec §9 item 7: construct a bitmap with a border-reachable white region and an enclosed white hole, assert with `od` that the mask bit for the hole is set (opaque) and for the border region clear |
| bake_test.go (3) | `mactest/bake_named.sh` | named resource present; duplicate name → exit 2 and no output file; no-flag byte identity |

- [ ] **Step 1: Write, run** `make test T='mactest/leakgate mactest/dblcompile mactest/abort_leak mactest/pbm2icn mactest/bake_named'`.
- [ ] **Step 2: Mutation check** — set the growth limit to 0 in `dblcompile.sh`; FAIL; revert.
- [ ] **Step 3: Gate, commit** `test(harness): port mactest host-only gates (go-retirement Task 11)`.

---

### Task 12: `selfhost`

**Files:**
- Create: `tests/selfhost/{behavior,crossgen,diag,fixedpoint,modules,snapshot}.sh`, each with `# timeout: 30m`; add to `tests/lib.sh`: `behavior_blob EXE OUT` producing `exit=N\n--- stdout ---\n<bytes>--- stderr ---\n<bytes>` exactly as `behaviorBlob` does, and `runnable_fixtures` (`testdata/run/*.cla testdata/runerr/*.cla`)

| Go test | Script | Must preserve |
|---|---|---|
| TestBehaviorGoldens | `selfhost/behavior.sh` | build with `$CLARUSC_SNAPSHOT`; blob vs `<base>.behavior`, bless `CLARUS_BLESS_BEHAVIOR`; `testdata/run` also checked against `.out`/`.log`/`.exit`/`.args`; strict-mode run vs optional `.leaks` (default 0) |
| TestCrossGenDifferential | `selfhost/crossgen.sh` | snapshot-built vs current-built blobs identical per fixture |
| TestErrorGoldens | `selfhost/diag.sh` | `testdata/errors/*.cla` via `emit`, diagnostics vs golden |
| TestSnapshotFixedPoint | `selfhost/fixedpoint.sh` | gen1 emit of `clarusc/main.cla` == committed `clarusc/clarusc.c`; gen2 == gen1; on failure print the ±2-line context diff and the same regeneration recipe text |
| TestClarusModules | `selfhost/modules.sh` | each `clarusc/test/*_test.cla` stdout vs `.out` |
| TestSnapshotBuilds | `selfhost/snapshot.sh` | copy `runtime/host/*` minus `*_test.c` and `clarusc/clarusc.c` into `$WORK`, `cc` there, check 3 sample fixtures' stdout+exit against `$CLARUSC` |

- [ ] **Step 1: Write, run** `make test T=selfhost/` (about 30 min).
- [ ] **Step 2: Mutation check** — append a comment line to `clarusc/clarusc.c` → `fixedpoint` FAIL with the recipe; revert.
- [ ] **Step 3: Gate, commit** `test(harness): port selfhost oracles (go-retirement Task 12)`.

---

### Task 13: `mactest` Mini vMac lane

**Files:**
- Modify: `tests/lib.sh` (add `run_mac`, `capture_split`, `ui_split`, `ui_goldens`, `suite_report_check`)
- Create: `tests/mactest/{runerr_mac,abort_mac,native_compare,smoke_bounce,ui_scenarios,tick,connfailed,runerr_68k,abort_68k,coresuite_68k,coresuite_mac,toolbox_68k,toolbox_jiggle,toolbox_mac,bench,appres}.sh`; move `internal/mactest/{probe,uiprobe}` → `tests/mactest/`; update `.gitignore`'s two `internal/mactest/*/build/` lines to the new paths; `# timeout: 20m` on boot scripts, `# timeout: 15m` on `toolbox_jiggle.sh`

**Interfaces (lib.sh additions):**

```sh
# run_mac BIN SECS : LaunchAPPL -e minivmac BIN with cwd=$WORK/launch, deadline SECS;
# on expiry: pkill -f minivmac.app, die. Writes $WORK/cap.raw. Then capture_split.
run_mac() {
    mkdir -p "$WORK/launch"
    ( cd "$WORK/launch" && "$TOOLS/timeout" "$2" "$ROOT/toolchain/bin/LaunchAPPL" -e minivmac "$1" > "$WORK/cap.raw" 2> "$WORK/cap.err" )
    rc=$?
    if [ $rc -eq 124 ]; then pkill -f minivmac.app; die "LaunchAPPL $1 timed out after $2s (emulator killed)"; fi
    [ $rc -eq 0 ] || die "LaunchAPPL $1 failed ($rc): $(head -5 "$WORK/cap.err")"
    capture_split "$WORK/cap.raw"
}
# capture_split RAW : split at the LAST "##CLARUS-EXIT## " into $WORK/cap.out,
# $WORK/cap.log and MAC_EXIT (the integer after the marker).
capture_split() {
    awk -v out="$WORK/cap.out" -v log="$WORK/cap.log" -v ex="$WORK/cap.exit" '
        { lines[NR]=$0; if (index($0,"##CLARUS-EXIT## ")==1) last=NR }
        END { if (!last) exit 1
              for (i=1;i<last;i++) print lines[i] > out
              sub(/^##CLARUS-EXIT## /,"",lines[last]); print lines[last] > ex
              for (i=last+1;i<=NR;i++) if (lines[i]!="##CLARUS-LOG##" || seen++) print lines[i] > log }' "$1" \
        || die "no ##CLARUS-EXIT## marker in capture"
    MAC_EXIT=$(cat "$WORK/cap.exit")
}
# ui_split OUT : "T ..." trace lines -> $WORK/ui.trace; each
# "##CLARUS-SNAP## NAME" ... hex ... "##CLARUS-SNAP-END##" block -> $WORK/snap.NAME.pbm
ui_split() {
    grep '^T ' "$1" > "$WORK/ui.trace"
    awk -v w="$WORK" '
        /^##CLARUS-SNAP## /{name=$2; hex=""; f=1; next}
        /^##CLARUS-SNAP-END##/{ print hex > (w "/snap." name ".hex"); close(w "/snap." name ".hex"); f=0; next }
        f{hex=hex $0}' "$1"
    for h in "$WORK"/snap.*.hex; do
        [ -e "$h" ] || break
        n=${h%.hex}; { printf 'P4\n512 342\n'; xxd -r -p "$h"; } > "$n.pbm"
    done
}
# ui_goldens SCENARIO WANT_EXIT : compare (or bless under CLARUS_MAC_BLESS)
# testdata/ui/SCENARIO.trace and testdata/uisnaps/SCENARIO.NAME.pbm
ui_goldens() {
    [ "$MAC_EXIT" = "$2" ] || t_fail "$1/exit" "exit $MAC_EXIT, want $2"
    golden_check "$WORK/ui.trace" "testdata/ui/$1.trace" CLARUS_MAC_BLESS || t_fail "$1/trace" mismatch
    for p in "$WORK"/snap.*.pbm; do
        [ -e "$p" ] || break
        n=${p#"$WORK"/snap.}; n=${n%.pbm}
        golden_check "$p" "testdata/uisnaps/$1.$n.pbm" CLARUS_MAC_BLESS || t_fail "$1/snap.$n" mismatch
    done
}
# suite_report_check OUT WANT_CASES : PASS/FAIL/TOTAL contract; echoes each case line
suite_report_check() {
    grep -E '^(PASS|FAIL) ' "$1"          # re-emit as our own subtests
    p=$(grep -c '^PASS ' "$1"); f=$(grep -c '^FAIL ' "$1")
    [ "$p" -eq "$2" ] || t_fail total "PASS lines $p, want $2"
    [ "$f" -eq 0 ] || t_fail total "$f FAIL lines"
    grep -qx "TOTAL $2 PASS $2 FAIL 0" "$1" || t_fail total "TOTAL line missing or wrong"
}
```
(`capture_split` must produce byte-exact `cap.out`; if any golden compare fails only on a trailing newline, switch the split to a C-free `dd`-based byte split using the offset from `grep -bo` and note it in the task report.)

| Go test | Script | Must preserve |
|---|---|---|
| TestRunErrOnMac, TestAbortAppsOnMac | `mactest/runerr_mac.sh`, `abort_mac.sh` | `require_env CLARUS_CPRINT_MAC_TESTS`; `scripts/build-mac.sh`; `oob` exit 3 + `.err` text; `emit_array` `.out`/`.exit` |
| TestNativeSmoke/StrContainers/ArrWholeAssign | `mactest/native_compare.sh` | `require_env CLARUS_MAC_TESTS`; host build vs native boot, identical stdout, exit 0; log segment count |
| TestSmokeBounceOn68k | `mactest/smoke_bounce.sh` | `ui_goldens smoke_bounce 0` |
| TestUiScenariosOn68k (smoke_mandel, texteditor, bookmarks) | `mactest/ui_scenarios.sh` | per-row subcases; `CLARUS_DEBUG_UI` dumps the full capture; `checkSmokeMandelSnaps`/`checkBookmarksSnaps` successive-snap-differ checks (`cmp` must FAIL between S1 and S2) |
| TestRealEventLoopTickOn68k | `mactest/tick.sh` | no `--events`; 60 real ticks then quit within the deadline |
| TestConnFailedHandlerOn68k | `mactest/connfailed.sh` | exact `invalid connection spec` text in the capture |
| TestRunErrOn68k (4), TestAbortOn68k | `mactest/runerr_68k.sh`, `abort_68k.sh` | `.out68k` override when present |
| TestCoreSuiteGUIOn68k / OnMac | `mactest/coresuite_68k.sh`, `coresuite_mac.sh` | `testdata/ui/coresuite.events`; `suite_report_check "$WORK/cap.out" 81` |
| TestToolboxSuiteOn68k / Jiggle / OnMac | `mactest/toolbox_68k.sh`, `toolbox_jiggle.sh` (`jiggle on` prepended to the events), `toolbox_mac.sh` | `suite_report_check ... 35`; `FAIL` lines re-emitted so the runner reports per case |
| TestParseBench68k, TestStrBench68k | `mactest/bench.sh` | `require_env CLARUS_BENCH68K`; log `BENCH ... ticks=` lines; never fail on timing |
| TestAppResNaming/Resources/BundleBit | `mactest/appres.sh` | one `build-mac.sh` build, three subcases; `setbundle.c` against Retro68 `libhfs.a`; bundle bit 0x2000 set, 0x0100 clear |

- [ ] **Step 1: Write lib additions and scripts.**
- [ ] **Step 2: Run** `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` (about 15 min) and `make smoke`.
- [ ] **Step 3: Mutation check** — flip one byte of `testdata/uisnaps/smoke_bounce.*.pbm`; `smoke_bounce` FAIL; revert. Change `81` to `80` in `coresuite_68k.sh`; FAIL; revert.
- [ ] **Step 4: Bless round trip** — `CLARUS_MAC_BLESS=1 make test T=mactest/smoke_bounce`, then `git status` must show no changes (bless of an unchanged scenario is a no-op).
- [ ] **Step 5: Gate** (`scripts/test-task.sh --smoke`), **commit** `test(harness): port mactest Mini vMac lane (go-retirement Task 13)`.

---

### Task 14: Snow lane

**Files:**
- Create: `tests/lib_snow.sh`; `tests/mactest/snow/{roundtrip,serial_echo,pagefile,macresident,macresident_failed_compile,clarusc_bake,clarusc_boot}.sh` (each begins `require_env CLARUS_SNOW_TESTS`; `# timeout:` = the Go outer bound + 20 min: `roundtrip` 3m→`25m`, `serial_echo` `30m`, `pagefile` `25m`, `clarusc_boot` `25m`, `macresident*` `150m`, `clarusc_bake` `100m`)

**Interfaces (`lib_snow.sh`):**

```sh
# snow_disk : clone snow/Clarus.snoww + its scsi_targets[0] image + clarus.pram into
# $WORK/snow, rewrite rom_path/display_card_rom_path/pram_path/Disk keys; sets SNOW_WS, SNOW_IMG.
# snow_put FILE MACPATH | snow_put_bin BIN | snow_get MACPATH OUT | snow_get_bin MACPATH OUT
#   hfsutils with HOME=$WORK/snow (the .hcwd isolation rule); apps go to
#   ":System Folder:Startup Items:", data files to the volume root.
# snow_run SECS DONE_CMD [SNOW_ARGS...] : start snow/Snow $SNOW_WS SNOW_ARGS in the
#   background, poll "$DONE_CMD" every 2s up to SECS, fail fast if Snow exits early,
#   then osascript -e 'quit app "Snow"', wait 20s, on overrun kill $SNOW_PID and die.
# settle_seconds VALUE : "2h"/"12m"/"45s"/bare seconds -> seconds.
```

Implement `snow_run` as:

```sh
snow_run() {
    _secs=$1; _done=$2; shift 2
    "$ROOT/snow/Snow" "$SNOW_WS" "$@" > "$WORK/snow.log" 2>&1 &
    SNOW_PID=$!
    _t=0
    while [ $_t -lt "$_secs" ]; do
        kill -0 "$SNOW_PID" 2>/dev/null || die "Snow exited early: $(tail -5 "$WORK/snow.log")"
        sh -c "$_done" && break
        sleep 2; _t=$((_t+2))
    done
    osascript -e 'quit app "Snow"'
    _g=0
    while kill -0 "$SNOW_PID" 2>/dev/null; do
        [ $_g -lt 20 ] || { kill -9 "$SNOW_PID"; die "Snow did not quit within 20s; disk image untrustworthy"; }
        sleep 1; _g=$((_g+1))
    done
    wait "$SNOW_PID" 2>/dev/null
}
```

| Go test | Script | Must preserve |
|---|---|---|
| TestSnowRoundTrip | `snow/roundtrip.sh` | 3 min bound, 30 s settle, marker file round trip via `:::NAME` |
| TestSerialEchoOnSnow | `snow/serial_echo.sh` | `--serial-bridge-a tcp:PORT`; `tcpdrive connect --retry 120` with `expect-sub "READY\r" 4096` (tolerates the leading noise byte), `sweep256` echo, 8×2048 sustained sweep, `QQQ`, 5 s quit settle, 6 min bound |
| TestPageFileOnSnow | `snow/pagefile.sh` | result line over the bridge, 4 min bound |
| TestMacResidentClaruscOnSnow / FailedCompileStaysAlive | `snow/macresident.sh`, `macresident_failed_compile.sh` | 110 min default settle, `CLARUS_MACRESIDENT_SETTLE`, `CLARUS_MACRESIDENT_DONE` |
| TestClarusCBakePathOnSnow | `snow/clarusc_bake.sh` | 55 min settle |
| TestClarusCBootOnSnow | `snow/clarusc_boot.sh` | 45 s settle, 3 min bound |

- [ ] **Step 1: Write `lib_snow.sh` and the seven scripts.**
- [ ] **Step 2: Run the short four** once each: `CLARUS_SNOW_TESTS=1 make test T='mactest/snow/roundtrip mactest/snow/serial_echo mactest/snow/pagefile mactest/snow/clarusc_boot'` (`pgrep Snow` first; nothing else may be using the screen). Record durations in the task report.
- [ ] **Step 3: Run the long three** once each, in the background, and record: `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (~55 min), then `macresident` and `macresident_failed_compile` (up to 110 min each; use `CLARUS_MACRESIDENT_SETTLE=12m` only if the Go test's own doc comment says a shorter settle is valid for the fixture).
- [ ] **Step 4: Commit** `test(harness): port Snow lane (go-retirement Task 14)`.

---

### Task 15: Delete Go, finalize wrappers and docs

**Files:**
- Delete: `go.mod`, `internal/` (entire tree)
- Modify: `scripts/test-task.sh`, `scripts/test-merge.sh` (remove the `go test` stages and the `|| true` guards; keep the `PASS in Ns` summary lines), `scripts/size-68k.sh` (comment references `internal/mactest/coresuite_test.go` → `tests/mactest/coresuite_68k.sh`), `.gitignore`, `CLAUDE.md`, `docs/ROADMAP.md` (move "Retire Go" out of Later; add the phase note), `docs/TODO.md` (close the perfgate-flake item; update the `go test` mentions), `docs/HISTORY.md` (append the phase entry; leave old `go test` text as archive), `docs/clarus-toolbox-cookbook.md` and any other doc `grep -rlw 'go test' docs CLAUDE.md` finds outside HISTORY

- [ ] **Step 1: Side-by-side proof.** On the branch tip, run `scripts/test-task.sh --smoke` and `scripts/test-merge.sh` with both lanes still wired. Save the Go `-v` test list and the Make result lines; every non-skipped Go test must map to a non-skipped Make result (`grep -c PASS` counts match the port tables: hostrt 13, claruscboot 2, perfgate 1, asm68k 1, reftest 3, sertest 3, lowlevel 5 scripts/6 tests, testsuite 4, emitui 5, cg68k 8, bake 4+~30, conntest 5, mactest per Task 11/13 tables, selfhost 6).

- [ ] **Step 2: Final wrappers.** `scripts/test-task.sh`:

```sh
#!/bin/bash
# test-task.sh [--smoke]
# T1 gate (per-task): the Make runner's t1 body (every tests/ group except
# selfhost/ and perfgate/, in parallel), then perfgate alone (it flakes
# under contention), then with --smoke the two native emulator boots
# (CLARUS_MAC_TESTS=1, needs Retro68 + Mini vMac). No result cache: every
# invocation re-runs every selected script.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
SMOKE=0; for arg in "$@"; do [ "$arg" = --smoke ] && SMOKE=1; done
START=$(date +%s)
J=$(sysctl -n hw.ncpu)
make -j"$J" tools bootstrap
make -j"$J" t1
make test T=perfgate/
[ "$SMOKE" = 1 ] && make smoke
echo "test-task.sh: PASS in $(( $(date +%s) - START ))s (smoke=$SMOKE)"
```
`scripts/test-merge.sh` becomes the same header plus `make t2`, keeping one `echo "test-merge.sh: <stage> PASS in Ns"` per stage by calling the four `t2` stages explicitly instead of the `t2` target.

- [ ] **Step 3: Delete.** `git rm -r internal go.mod`; remove the two `internal/mactest/*/build/` lines from `.gitignore` (replaced in Task 13). `grep -rw 'go test' CLAUDE.md docs/ROADMAP.md docs/TODO.md scripts` must print nothing; `grep -rw go scripts/*.sh` must only show comments about the retired lane.

- [ ] **Step 4: Docs.** `CLAUDE.md` "Build and test": replace the `go test` paragraphs with the Make targets, the `T=` filter, exit 77, the `# timeout:` header, the bless variables, and the "no result cache" note (which replaces the `-count=1` paragraph). Remove the `-timeout 30m` selfhost note (the script header carries it now). Update the suite-boot test names (`TestCoreSuiteGUIOn68k` → `tests/mactest/coresuite_68k.sh` etc.) wherever CLAUDE.md names them. ROADMAP: phase entry under completed work, "Retire Go" removed from Later. TODO: close the perfgate flake item with the isolated-run note; `docs/TODO.md:471` and `:892` updated. HISTORY: phase entry.

- [ ] **Step 5: Re-baseline perfgate** from an isolated `make test T=perfgate/` run (median of 5 in a quiet host), edit `tests/perfgate/baseline.txt` with the measurement in the header comment.

- [ ] **Step 6: Final gates.** `scripts/test-task.sh --smoke`, then `scripts/test-merge.sh` (about 15 min plus selfhost 30 min). Both must print their PASS line with Go absent from the machine's `PATH` (`PATH=$(echo "$PATH" | tr ':' '\n' | grep -v go | paste -sd:)` for the run).

- [ ] **Step 7: Commit** `chore: delete the Go test harness; Make + shell + C tools are the gauntlet (go-retirement Task 15)`.

---

## Self-review

**Spec coverage.** §3 runner/targets/protocol/skips/bootstrap/parallelism → Task 1 (+ Task 15 wrappers). §4 port map → Tasks 2–14, every row present. §5 tools → Tasks 1, 5, 7, 8, 10. §6 gates → Tasks 1 and 15. §7 Snow → Task 14. §8 parity proof → each task's mutation step + Task 15 Step 1. §9 items: 1–5 structural (Task 1), 6 (Task 5), 7 (Task 11), 8 (Task 7), 9 (Task 14), 10 (Task 1 Makefile), 11 (Task 14 `settle_seconds`), 12 (Tasks 1 and 15), 13 (Task 2). §10/§11: nothing to implement.

**Deviations from the spec, recorded here.** The runner has two helper scripts (`run1.sh`, `summary.sh`) alongside `lib.sh`; `hostrt` tests are scripts using `run_c_test` rather than bare Make rules. Both keep one test protocol everywhere and change nothing observable.

**Type/name consistency.** `t_pass`/`t_fail`/`t_done`/`die`/`skip`/`require_env`/`require_tool`/`require_vasm`/`golden_check`/`first_diff`/`host_build`/`emit68k`/`run_c_test`/`mem_live` (Task 1); `fences` (Task 3); `bake_ir` (Task 8); `emit68k_pair` (Task 9); `behavior_blob`/`runnable_fixtures` (Task 12); `run_mac`/`capture_split`/`ui_split`/`ui_goldens`/`suite_report_check`/`MAC_EXIT` (Task 13); `snow_disk`/`snow_put*`/`snow_get*`/`snow_run`/`settle_seconds`/`SNOW_WS`/`SNOW_IMG`/`SNOW_PID` (Task 14). Tool CLIs: `timeout [--elapsed] SECS CMD`, `uiblob FILE`, `resfork header|list|get|code0|size`, `clirhdr FILE | --flip-stamp | --flip-body`, `tcpdrive pick-port | listen | connect [--retry]`. Result line: `PASS|SKIP|FAIL(...) <name> <secs>s`.
