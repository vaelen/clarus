# Mac Target 4a — "hello, Macintosh" — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Clarus program emitted by clarusc, compiled with Retro68 against a Toolbox-native runtime, runs as an APPL in Mini vMac — with the existing host corpus, recomposed as a pure-Clarus test suite, as the regression net.

**Architecture:** Three layers land in order: (1) corpus restructuring — each `testdata/run` program splits into `lib/X.cla` logic + an `X.cla` wrapper at the original path via `include`, so every existing harness is untouched; (2) `runtime/mac/` implements the full `internal/build/rt/rt.h` ABI on the Toolbox (Handles, BlockMoveData, Str255, File Manager); (3) `scripts/build-mac.sh` (snapshot-built clarusc → emit → Retro68 cmake) plus a gated `internal/mactest` harness that byte-compares the Mac suite run against the host suite run.

**Tech Stack:** Clarus, C (m68k-apple-macos-gcc via Retro68), Rez, cmake, Go (test harness), LaunchAPPL + Mini vMac.

**Spec:** `docs/superpowers/specs/2026-07-24-mac-target-4a-design.md`

## Global Constraints

- Branch: all work on `mac-target-4a`; main stays green; merge only on user request.
- FROZEN surfaces — must not change: `cmd/`, all existing packages under `internal/` (new package `internal/mactest` is allowed; existing test files are NOT modified), `clarusc/*.cla`, `clarusc/clarusc.c`, `internal/build/rt/rt.h`, `internal/build/rt/rt.c`.
- Every `.cla` file starts with the 3-line license header (`// Copyright 2026, Andrew C. Young <andrew@vaelen.org>` / `// SPDX-License-Identifier: MIT` / blank).
- `go test ./...` must be green at the end of every task (gated mactest tests skip without `CLARUS_MAC_TESTS=1`).
- Commit messages end with the Co-Authored-By/Claude-Session trailer per session config.
- Toolchain paths (developer machine): Retro68 gcc at `toolchain/bin/m68k-apple-macos-gcc`, cmake toolchain file at `toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake`, emulator config in `~/.LaunchAPPL.cfg` (already set up). Emulator control recipes are in CLAUDE.md.
- Clarus semantics note for wrapper/suite authors: `\n` in Clarus strings is CR; `alert(s)` on host prints s + newline to stdout (CR bytes rendered as LF). The reference is `docs/clarus-language-reference.md`.

## File Structure (end state)

```
testdata/run/lib/<name>.cla      41 logic files (entry func runX, prefixed helpers)
testdata/run/<name>.cla          41 wrappers (original paths; include + handlers)
testdata/suite/test_suite.cla    monolithic suite (includes all 41 lib files)
runtime/mac/rt_mac.c             Toolbox ABI implementation (normal + RT_MAC_TEST)
runtime/mac/alert.r              ALRT/DITL 128 resource for rt_alert/rt_panic
internal/mactest/probe/probe.c   emulator-plumbing probe app (Task 1)
internal/mactest/probe/CMakeLists.txt
internal/mactest/suite_host_test.go   ungated: host suite sanity
internal/mactest/mac_test.go     gated: Mac-vs-host byte compare + runerr apps
scripts/build-mac.sh             emit + Retro68 build orchestration
examples/hello-mac.cla           milestone artifact
build-mac/                       gitignored build output
```

---

### Task 1: Branch, probe app, extraction decision

Settles the spec's front-loaded probe: after a LaunchAPPL minivmac run, how do we get a file written by the app back to the host? Outcome is a committed FINDINGS.md that Task 11 follows.

**Files:**
- Create: `internal/mactest/probe/probe.c`
- Create: `internal/mactest/probe/CMakeLists.txt`
- Create: `internal/mactest/probe/FINDINGS.md`
- Modify: `.gitignore` (add `/build-mac/` and `internal/mactest/probe/build/`)

**Interfaces:**
- Produces: FINDINGS.md documenting the extraction method (`launchappl-echo` or `hcopy` + exact commands) that `internal/mactest/mac_test.go` (Task 11) must use; a proven File Manager write pattern that `rt_mac.c` (Task 10) reuses.

- [ ] **Step 1: Create branch**

```bash
git checkout -b mac-target-4a
```

- [ ] **Step 2: Write the probe app**

`internal/mactest/probe/probe.c` — writes two files to the app's default (boot) volume using the File Manager only, then exits. `out` is the name LaunchAPPL itself pre-creates on its boot disk (observed: type TEXT/MPS); we both append to `out` and create our own `probe_marker`:

```c
/* probe.c -- emulator plumbing probe for the Clarus Mac harness.
   Writes "PROBE-OUT-42\r" to the pre-existing file `out` on the boot
   volume, and creates `probe_marker` containing "PROBE-MARKER-42\r".
   No console library, no window; exits immediately. */
#include <Files.h>
#include <TextUtils.h>

static void writeAll(short ref, const char *buf, long n)
{
    long count = n;
    FSWrite(ref, &count, buf);
}

static void writeFile(ConstStr255Param name, const char *buf, long n, Boolean mustCreate)
{
    short ref;
    OSErr err;
    if (mustCreate)
        Create(name, 0, 'MPS ', 'TEXT');          /* vRefNum 0 = default volume */
    err = FSOpen(name, 0, &ref);
    if (err != noErr)
        return;
    SetEOF(ref, 0);
    writeAll(ref, buf, n);
    FSClose(ref);
    FlushVol(NULL, 0);
}

int main(void)
{
    writeFile("\pout", "PROBE-OUT-42\r", 13, false);
    writeFile("\pprobe_marker", "PROBE-MARKER-42\r", 16, true);
    return 0;
}
```

`internal/mactest/probe/CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.9)
project(Probe C)
add_application(Probe probe.c)
```

- [ ] **Step 3: Build it**

```bash
cd internal/mactest/probe
cmake -B build -DCMAKE_TOOLCHAIN_FILE=$PWD/../../../toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake
make -C build
```
Expected: `build/Probe.bin` exists. (Warnings OK; errors are not.)

- [ ] **Step 4: Run via LaunchAPPL and observe both channels**

```bash
cd internal/mactest/probe
timeout 120 ../../../toolchain/bin/LaunchAPPL -e minivmac build/Probe.bin > launchappl.stdout 2>&1; echo "exit: $?"
cat launchappl.stdout
```
Record: (a) exit code; (b) whether `PROBE-OUT-42` appears on LaunchAPPL's stdout (the `out`-echo hypothesis). Note: LaunchAPPL creates its temp dir in the cwd and deletes it on clean exit — if stdout echo does NOT work, re-run and, while the emulator is up, copy the temp dir's `minivmac.app/Contents/mnvm_dat/disk1.dsk` aside, then after exit run:

```bash
../../../toolchain/bin/hmount saved-disk1.dsk && ../../../toolchain/bin/hls
../../../toolchain/bin/hcopy :out probe-out.txt; ../../../toolchain/bin/hcopy :probe_marker probe-marker.txt
../../../toolchain/bin/humount
cat probe-out.txt probe-marker.txt
```
Expected: at least one channel yields `PROBE-OUT-42` / `PROBE-MARKER-42`.

- [ ] **Step 5: Write FINDINGS.md**

Document exactly: which channel works (`launchappl-echo` — out contents appear on LaunchAPPL stdout — or `hcopy` with the copy-aside timing), the commands used, exit-code behavior, and total wall-clock for one boot. If BOTH fail, STOP — report to the orchestrator instead of committing (the harness design needs revisiting).

- [ ] **Step 6: Commit**

```bash
git add internal/mactest/probe .gitignore
git commit -m "mactest: probe LaunchAPPL file extraction; record findings"
```

---

### Task 2: Corpus split — batch 1 (10 files)

Files: `appendperf arith binroundtrip breakcont cli clifallback collections concat_order constants crc8`

**Files:**
- Create: `testdata/run/lib/<name>.cla` for each of the 10
- Modify: `testdata/run/<name>.cla` for each (becomes wrapper at the SAME path)
- Goldens (`.out`, `.args`, `.exit`, `.log`): NOT modified.

**Interfaces:**
- Produces: for each corpus program `<name>`, `testdata/run/lib/<name>.cla` declaring entry func `run<PascalName>()` (e.g. `runAppendperf`, `runConcatOrder` — PascalCase of the file name, underscores dropped). Task 6's suite calls exactly these. Special signatures below.

**The split rule (applies to every batch):**

1. `testdata/run/lib/<name>.cla` gets the license header, then every top-level declaration from the original EXCEPT `on` handlers and any `quit` statement. Handler bodies move into entry funcs (below). Every top-level name (funcs, vars, consts, records, enums) is renamed with the file's camelCase prefix unless it already starts with it (e.g. `show` in `arith.cla` → `arithShow`; update all uses). The entry func is named `run<PascalName>`.
2. `testdata/run/<name>.cla` (wrapper, original path) gets the license header, `include "lib/<name>.cla"`, and the ORIGINAL `on` handler declarations whose bodies are replaced by a call to the entry func(s) plus any original trailing `quit`. Observable behavior must be byte-identical: same handlers, same order of effects, same exit code.
3. One handler body → one entry func. Files with multiple handlers get one entry func per handler, named `run<PascalName>Launch`, `run<PascalName>Start`, etc., and the wrapper calls each from its original handler.
4. If a handler takes parameters (`on App.startCLI(args)`), the entry func takes the same parameter (same type as the handler binds — read the original file) and the wrapper forwards it: `on App.startCLI(args) { runCli(args) }`.
5. Var initializers at top level stay in the lib file (initializer order within a file is preserved by the move; the wrapper includes the lib first, so lib globals initialize before wrapper globals — same as today where everything is one file).

**Batch-1 special cases:**
- `cli.cla`: startCLI handler — rule 4 applies; entry `runCli(args: <original type>)`.
- `clifallback.cla`: has both `startCLI` and `startEmpty` (fallback test) — rule 3; wrapper preserves both handlers.

- [ ] **Step 1: Split the 10 files per the rules** (read each original in full first; the rename set must cover every reference).

Worked example — `arith.cla` today (abbreviated):

```
// license header
func show(label: string, n: int) { ... }
on App.startEmpty { show("a", 1) ... }
```

becomes `testdata/run/lib/arith.cla`:

```
// license header
func arithShow(label: string, n: int) { ... }

func runArith() {
    arithShow("a", 1)
    ...
}
```

and `testdata/run/arith.cla`:

```
// license header
include "lib/arith.cla"

on App.startEmpty {
    runArith()
}
```

- [ ] **Step 2: Verify host behavior unchanged**

```bash
go test ./internal/build -run 'TestRunGoldens' -count=1
go test ./internal/selfhost -count=1
```
Expected: PASS. (The differential/emit tests re-run the same programs through clarusc — `include` is fully supported by both compilers.)

- [ ] **Step 3: Commit**

```bash
git add testdata/run
git commit -m "testdata: split run corpus into lib/ logic + wrappers (batch 1/4)"
```

---

### Task 3: Corpus split — batch 2 (11 files)

Files: `emit_arith emit_array emit_control emit_enum emit_file emit_func emit_hello emit_list emit_longline emit_map emit_record`

Same rules, same steps, same verification as Task 2. Entry names: `runEmitArith`, `runEmitArray`, `runEmitControl`, `runEmitEnum`, `runEmitFile`, `runEmitFunc`, `runEmitHello`, `runEmitList`, `runEmitLongline`, `runEmitMap`, `runEmitRecord`.

- [ ] Split per rules; verify (`go test ./internal/build ./internal/selfhost -count=1`); commit `"testdata: split run corpus (batch 2/4)"`.

---

### Task 4: Corpus split — batch 3 (10 files)

Files: `emit_strings emit_switch emit_text emit_wideproto enums errvar files fixedmath hello launchorder`

**Batch-3 special cases:**
- `launchorder.cla`: exists to pin launch-before-start ordering — it has BOTH `on App.launch` and a start handler. Rule 3: two entry funcs (`runLaunchorderLaunch`, `runLaunchorderStart`); the wrapper reproduces today's ordering exactly. (The suite will call them in launch-then-start order.)
- `files.cla`: file I/O with relative paths — logic moves untouched; paths are resolved by the runtime, nothing to change.

- [ ] Split per rules; verify; commit `"testdata: split run corpus (batch 3/4)"`.

---

### Task 5: Corpus split — batch 4 (10 files)

Files: `mutrec records savechoice slices strcap strings switch textassign truncate widen_text`

- [ ] Split per rules (check `savechoice` for `quit`/args usage and apply rules 3-4 as found); verify; commit `"testdata: split run corpus (batch 4/4)"`.

---

### Task 6: test_suite.cla + host sanity test

**Files:**
- Create: `testdata/suite/test_suite.cla`
- Create: `internal/mactest/suite_host_test.go`

**Interfaces:**
- Consumes: every `run*` entry func from Tasks 2-5 (exact list in those tasks).
- Produces: `testdata/suite/test_suite.cla` — the single-program suite; `BuildAndRunSuite` expectations used by Task 11: suite stdout on host is the byte-exact expectation for the Mac run.

- [ ] **Step 1: Write the suite**

`testdata/suite/test_suite.cla`: license header; one `include "../run/lib/<name>.cla"` per logic file (all 41, alphabetical); one launch handler that, for each test in alphabetical order, alerts the delimiter then calls the entry func(s):

```
// license header
include "../run/lib/appendperf.cla"
include "../run/lib/arith.cla"
... (all 41)

on App.launch {
    var cliArgs: <args type from lib/cli.cla's runCli signature>
    alert("=== appendperf ===")
    runAppendperf()
    alert("=== arith ===")
    runArith()
    ...
    alert("=== cli ===")
    cliArgs.push("alpha")
    cliArgs.push("beta")
    runCli(cliArgs)
    ...
    alert("=== launchorder ===")
    runLaunchorderLaunch()
    runLaunchorderStart()
    ...
    alert("=== suite done ===")
}
```

Multi-entry tests: call in the original handler order. `runCli` gets the fixed synthetic args shown (two args: `alpha`, `beta`).

- [ ] **Step 2: Write the failing host sanity test**

`internal/mactest/suite_host_test.go` (ungated — runs in normal `go test ./...`):

```go
package mactest

import (
	"clarus/internal/build"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// BuildSuiteHost builds testdata/suite/test_suite.cla with the host
// toolchain and returns the executable path.
func BuildSuiteHost(t *testing.T) string {
	t.Helper()
	exe := filepath.Join(t.TempDir(), "suite")
	diags, err := build.Build([]string{"../../testdata/suite/test_suite.cla"}, exe)
	if err != nil || len(diags) > 0 {
		t.Fatalf("build suite: err=%v diags=%v", err, diags)
	}
	return exe
}

// RunSuiteHost runs the host suite binary and returns its stdout. This
// output is the byte-exact expectation for the Mac run (mac_test.go).
func RunSuiteHost(t *testing.T, exe string) string {
	t.Helper()
	cmd := exec.Command(exe)
	cmd.Dir = t.TempDir() // suite tests touch relative-path files
	out, err := cmd.Output()
	if err != nil {
		t.Fatalf("run suite: %v", err)
	}
	return string(out)
}

func TestSuiteRunsAllTests(t *testing.T) {
	out := RunSuiteHost(t, BuildSuiteHost(t))
	names, _ := filepath.Glob("../../testdata/run/lib/*.cla")
	if len(names) == 0 {
		t.Fatal("no lib corpus")
	}
	for _, n := range names {
		delim := "=== " + strings.TrimSuffix(filepath.Base(n), ".cla") + " ==="
		if !strings.Contains(out, delim) {
			t.Errorf("suite output missing %q", delim)
		}
	}
	if !strings.Contains(out, "=== suite done ===") {
		t.Error("missing final delimiter")
	}
	_ = os.Stdout
}
```

(Remove the `_ = os.Stdout` line if `os` ends up unused.)

- [ ] **Step 3: Run it — expect failure, then fix the suite until green**

```bash
go test ./internal/mactest -run TestSuiteRunsAllTests -count=1 -v
```
First run typically fails on name/type mismatches — fix `test_suite.cla` (NOT the lib files, unless a lib file violates its own Task 2-5 contract, in which case fix it to match).

- [ ] **Step 4: Full-suite verify + commit**

```bash
go test ./... 
git add testdata/suite internal/mactest/suite_host_test.go
git commit -m "testdata: monolithic pure-Clarus test_suite + host sanity test"
```

---

### Task 7: Mac runtime — strings, fixed, error state, alert/panic/quit skeleton

**Files:**
- Create: `runtime/mac/rt_mac.c`
- Create: `runtime/mac/alert.r`

**Interfaces:**
- Consumes: `internal/build/rt/rt.h` (unmodified, single ABI truth); host semantics reference `internal/build/rt/rt.c`.
- Produces: every symbol in rt.h defined (text/list/map/file as temporary `rt_panic("not yet implemented on mac")` stubs, replaced in Tasks 9-10); `rt_mac_toolbox_init()` internal lazy-init used by later tasks.

- [ ] **Step 1: Write alert.r**

```rez
#include "Dialogs.r"

resource 'ALRT' (128, purgeable) {
    {40, 40, 190, 460}, 128,
    { OK, visible, silent, OK, visible, silent,
      OK, visible, silent, OK, visible, silent },
    alertPositionMainScreen
};

resource 'DITL' (128, purgeable) {
    {
        {120, 360, 140, 420}, Button { enabled, "OK" },
        {10, 20, 110, 420},  StaticText { disabled, "^0" }
    }
};
```

- [ ] **Step 2: Write rt_mac.c — the non-collection surface**

Structure and the parts that are new on Mac (complete); the pure-byte-logic functions (`rt_str_store`, `rt_str_concat*`, `rt_str_cmp/len/index/set_index/from_bytes/to_bytes/slice/index_of_*`, `rt_fix_mul/div`, `rt_arr_check`, `rt_enum_from_int`, `rt_set_lasterr`) are ports of `internal/build/rt/rt.c` with IDENTICAL observable semantics (same clamping, same lastError codes/messages, same panic messages — the suite byte-compare enforces this; copy the logic, replace `memcpy` with `BlockMoveData`):

```c
/* rt_mac.c -- Toolbox-native implementation of the Clarus runtime ABI
   (internal/build/rt/rt.h). Handles + BlockMoveData + Str255; no malloc,
   no console library. RT_MAC_TEST redirects alert/log/quit/panic for the
   corpus harness (Task 10). */
#include "rt.h"
#include <Dialogs.h>
#include <Files.h>
#include <Memory.h>
#include <Quickdraw.h>
#include <Fonts.h>
#include <Windows.h>
#include <Menus.h>
#include <TextEdit.h>

static int rt_mac_inited = 0;

static void rt_mac_toolbox_init(void)
{
    if (rt_mac_inited) return;
    InitGraf(&qd.thePort);
    InitFonts();
    InitWindows();
    InitMenus();
    TEInit();
    InitDialogs(NULL);
    InitCursor();
    rt_mac_inited = 1;
}

#ifndef RT_MAC_TEST
void rt_alert(const uint8_t *s)
{
    Str255 msg;
    rt_mac_toolbox_init();
    BlockMoveData(s + 1, msg + 1, s[0]);
    msg[0] = s[0];
    ParamText(msg, "\p", "\p", "\p");
    NoteAlert(128, NULL);
}

void rt_log(const uint8_t *s) { (void)s; } /* no stderr on System 6; 4b revisits */

void rt_quit(int32_t code) { (void)code; ExitToShell(); }

void rt_panic(const char *msg)
{
    Str255 p;
    int n = 0;
    const char *pre = "runtime error: ";
    rt_mac_toolbox_init();
    while (*pre && n < 255) p[++n] = *pre++;
    while (*msg && n < 255) p[++n] = *msg++;
    p[0] = n;
    ParamText(p, "\p", "\p", "\p");
    StopAlert(128, NULL);
    ExitToShell();
}
#endif

void rt_args_init(int argc, char **argv) { (void)argc; (void)argv; }

rt_list *rt_args_list(void)
{
    static rt_list *args = NULL;
    if (!args) args = rt_list_new(256);
    return args;
}
```

plus the ported byte-logic functions, `rt_lasterr_code`/`rt_lasterr_msg` globals, and panic-stubs for every text/list/map/file symbol not yet implemented:

```c
rt_text *rt_text_new(void) { rt_panic("not yet implemented on mac"); return 0; }
/* ...one stub per remaining rt.h symbol, exact signatures from rt.h... */
```

- [ ] **Step 3: Compile-check (68k, both modes)**

```bash
toolchain/bin/m68k-apple-macos-gcc -c -Iinternal/build/rt runtime/mac/rt_mac.c -o /tmp/rt_mac.o
toolchain/bin/m68k-apple-macos-gcc -c -DRT_MAC_TEST -Iinternal/build/rt runtime/mac/rt_mac.c -o /tmp/rt_mac_t.o
```
Expected: both succeed (RT_MAC_TEST mode will have undefined-behavior gaps until Task 10 — it only needs to COMPILE here; the `#ifndef RT_MAC_TEST` block simply disappears and the four functions are missing, which is fine for `-c`).

- [ ] **Step 4: Commit**

```bash
git add runtime/mac
git commit -m "runtime/mac: strings, fixed, alert/panic/quit on the Toolbox; collection stubs"
```

---

### Task 8: build-mac.sh + hello, Macintosh (milestone)

**Files:**
- Create: `scripts/build-mac.sh` (chmod +x)
- Create: `examples/hello-mac.cla`

**Interfaces:**
- Consumes: `clarusc/clarusc.c` snapshot, `runtime/mac/` (Task 7), Retro68 toolchain.
- Produces: `scripts/build-mac.sh <Name> <files.cla...> [--test]` → `build-mac/<Name>/<Name>.bin|.APPL|.dsk`; used verbatim by Task 11.

- [ ] **Step 1: Write examples/hello-mac.cla**

```
// license header

on App.launch {
    alert("hello, Macintosh!\nClarus was here.")
}
```

- [ ] **Step 2: Write scripts/build-mac.sh**

```bash
#!/bin/sh
# build-mac.sh NAME file.cla... [--test]
# Emits C via the snapshot-built clarusc and builds a classic Mac APPL
# via Retro68. Output: build-mac/NAME/NAME.{bin,APPL,dsk}
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"; shift
TESTDEF=""
FILES=""
for a in "$@"; do
    if [ "$a" = "--test" ]; then TESTDEF="-DRT_MAC_TEST=1"; else FILES="$FILES $a"; fi
done

mkdir -p "$ROOT/build-mac"
# 1. bootstrap clarusc from the committed snapshot (cached)
CLARUSC="$ROOT/build-mac/clarusc"
if [ ! -x "$CLARUSC" ] || [ "$ROOT/clarusc/clarusc.c" -nt "$CLARUSC" ]; then
    cc -O1 -I"$ROOT/internal/build/rt" -o "$CLARUSC" \
        "$ROOT/clarusc/clarusc.c" "$ROOT/internal/build/rt/rt.c"
fi
# 2. emit
OUT="$ROOT/build-mac/$NAME"
mkdir -p "$OUT"
"$CLARUSC" emit -o "$OUT/$NAME.c" $FILES
# 3. Retro68 build
cat > "$OUT/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.9)
project($NAME C)
add_definitions(-I$ROOT/internal/build/rt $TESTDEF)
add_application($NAME $NAME.c $ROOT/runtime/mac/rt_mac.c $ROOT/runtime/mac/alert.r)
EOF
cmake -S "$OUT" -B "$OUT/build" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake" \
    > /dev/null
make -C "$OUT/build" > /dev/null
for ext in bin APPL dsk; do cp -R "$OUT/build/$NAME.$ext" "$OUT/" 2>/dev/null || true; done
echo "built: $OUT/$NAME.bin"
```

- [ ] **Step 3: Build and run the milestone**

```bash
scripts/build-mac.sh HelloMac examples/hello-mac.cla
timeout 180 toolchain/bin/LaunchAPPL -e minivmac build-mac/HelloMac/HelloMac.bin &
```
While it runs (~10 s after launch): screenshot per CLAUDE.md (window geometry via System Events, `screencapture -R...`), verify the alert shows "hello, Macintosh!" with "Clarus was here." on the second line. Click OK (`swift scripts/click.swift ...` at the OK button) → app exits → LaunchAPPL exit 0.
Expected: screenshot saved to `build-mac/hello-mac-screenshot.png` (kept OUT of git; it's in build-mac/).

- [ ] **Step 4: Commit**

```bash
git add scripts/build-mac.sh examples/hello-mac.cla
git commit -m "mac: build-mac.sh pipeline + hello-mac milestone (alert on a Mac Plus)"
```

---

### Task 9: Mac runtime — Handle-backed text, list, map

**Files:**
- Modify: `runtime/mac/rt_mac.c` (replace Task 7's stubs)

**Interfaces:**
- Consumes: host semantics in `internal/build/rt/rt.c` (growth, panic messages, sorted-key map, snapshot iteration).
- Produces: full rt.h collection ABI, Handle-backed.

- [ ] **Step 1: Implement the backing pattern**

One struct per type, Handle for storage, capacity doubling exactly as host. The discipline: never hold a dereferenced pointer across a call that can move memory (`NewHandle`, `SetHandleSize`); compute, then `BlockMoveData`. Pattern (complete, for text — list and map follow it):

```c
struct rt_text { Handle h; int32_t len, cap; };

static void rt_mac_oom(void) { rt_panic("out of memory"); }

rt_text *rt_text_new(void)
{
    Handle box = NewHandle(sizeof(rt_text));
    rt_text *t;
    if (!box) rt_mac_oom();
    HLock(box);
    t = (rt_text *)*box;
    t->h = NewHandle(16);
    if (!t->h) rt_mac_oom();
    t->len = 0; t->cap = 16;
    return t;   /* box stays locked: rt_text* identity must be stable */
}

static void rt_text_grow(rt_text *t, int32_t need)
{
    int32_t cap = t->cap;
    while (cap < need) cap *= 2;
    if (cap != t->cap) {
        SetHandleSize(t->h, cap);
        if (MemError() != noErr) rt_mac_oom();
        t->cap = cap;
    }
}

void rt_text_append_str(rt_text *t, const uint8_t *s)
{
    rt_text_grow(t, t->len + s[0]);
    BlockMoveData(s + 1, *t->h + t->len, s[0]);
    t->len += s[0];
}
```

(Locked master-pointer blocks for the structs themselves keep `rt_text*`/`rt_list*`/`rt_map*` values stable — matching the host ABI where these are ordinary pointers. Small blocks, System-6-appropriate.)

- [ ] **Step 2: Port every text/list/map function from rt.c** — same amortized growth, same panic strings ("pop on empty list", "map key not found", …), same sorted-key insertion and index-snapshot iteration for maps, same self-append doubling for `rt_text_append_text`.

- [ ] **Step 3: Compile-check both modes** (same commands as Task 7 Step 3). Expected: clean.

- [ ] **Step 4: Rebuild + re-run hello (regression):** `scripts/build-mac.sh HelloMac examples/hello-mac.cla` then LaunchAPPL run, alert still shows, exit 0.

- [ ] **Step 5: Commit** `"runtime/mac: Handle-backed text/list/map"`.

---

### Task 10: Mac runtime — files + RT_MAC_TEST capture build

**Files:**
- Modify: `runtime/mac/rt_mac.c`

**Interfaces:**
- Consumes: probe's proven File Manager pattern (Task 1), host `rt_file_*` semantics (byte-faithful, lastError codes on failure — rt.c).
- Produces: full normal-mode ABI; test mode writing `out` (alert stream), `log` (log stream), `exitcode` (decimal + CR, written at exit) to the boot volume. Task 11 consumes these exact filenames.

- [ ] **Step 1: Implement rt_file_read_text / rt_file_write_text / rt_file_name**

File Manager, default volume, paths taken as-is from the str255 (byte-faithful contents, no newline translation; `TEXT` type on create). Port lastError codes/messages from rt.c. Reuse the probe's Create/FSOpen/SetEOF/FSWrite/FlushVol pattern; reads via GetEOF + FSRead into a grown text handle.

- [ ] **Step 2: Implement the RT_MAC_TEST block**

```c
#ifdef RT_MAC_TEST
/* Test build: alert/log append to files on the boot volume; quit/panic
   record the exit code. The harness (internal/mactest) byte-compares
   `out` against the host suite run. Clarus \n is CR; the host prints
   alerts with a trailing LF -- the harness normalizes CR->LF and appends
   the trailing newline per alert on the host side? NO: to keep the
   byte-compare honest, the test build writes s's bytes followed by a
   single LF (0x0A), matching rt.c's rt_alert exactly (which converts CR
   bytes to LF). */
static void rt_test_emit(ConstStr255Param name, const uint8_t *s);  /* append s (CR->LF) + LF */
void rt_alert(const uint8_t *s) { rt_test_emit("\pout", s); }
void rt_log(const uint8_t *s)   { rt_test_emit("\plog", s); }
static void rt_test_exit(int32_t code)
{
    /* write `exitcode` file: decimal + CR */
    ...complete File Manager write, then ExitToShell();
}
void rt_quit(int32_t code) { rt_test_exit(code); }
void rt_panic(const char *msg)
{
    /* "runtime error: " + msg + LF appended to `log`, then rt_test_exit(3) */
}
#endif
```

`rt_test_emit` opens-or-creates the named file once (cached refnum), appends at EOF, `FlushVol` after each write (crash-visible), converting CR bytes to LF and appending LF — byte-identical to `rt_alert`/`rt_log` in rt.c. Implement completely (the `...` above is filled in from the probe's write pattern + rt.c's CR/LF rule; ~40 lines).

- [ ] **Step 3: Compile-check both modes; rebuild hello (normal mode) as regression.**

- [ ] **Step 4: Commit** `"runtime/mac: File Manager rt_file_*; RT_MAC_TEST capture build"`.

---

### Task 11: Gated Mac harness — suite + runerr byte-compare

**Files:**
- Create: `internal/mactest/mac_test.go`

**Interfaces:**
- Consumes: `BuildSuiteHost`/`RunSuiteHost` (Task 6), `scripts/build-mac.sh --test` (Task 8), extraction method from `internal/mactest/probe/FINDINGS.md` (Task 1), capture filenames (Task 10).
- Produces: `CLARUS_MAC_TESTS=1 go test ./internal/mactest` — the 4a acceptance gate.

- [ ] **Step 1: Write the gated test**

```go
package mactest

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func requireMac(t *testing.T) {
	if os.Getenv("CLARUS_MAC_TESTS") == "" {
		t.Skip("set CLARUS_MAC_TESTS=1 (needs Retro68 toolchain + Mini vMac + display)")
	}
}

// BuildMac invokes scripts/build-mac.sh and returns the .bin path.
func BuildMac(t *testing.T, name string, test bool, claFiles ...string) string { /* exec the script; t.Fatal on error */ }

// RunMac launches the .bin via LaunchAPPL (timeout 10 min) and returns
// the extracted capture files (out, log, exitcode) per probe FINDINGS.
func RunMac(t *testing.T, bin string) (out, log string, exitCode int) { /* per FINDINGS.md */ }

func TestSuiteOnMac(t *testing.T) {
	requireMac(t)
	expected := RunSuiteHost(t, BuildSuiteHost(t))
	bin := BuildMac(t, "TestSuite", true, "../../testdata/suite/test_suite.cla")
	got, _, exitCode := RunMac(t, bin)
	if exitCode != 0 {
		t.Fatalf("suite exit code %d", exitCode)
	}
	if got != expected {
		// first divergence, with context
		t.Fatalf("mac/host divergence:%s", firstDiff(expected, got))
	}
}

func TestRunErrOnMac(t *testing.T) {
	requireMac(t)
	files, _ := filepath.Glob("../../testdata/runerr/*.cla")
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}
			name := "Err" + strings.TrimSuffix(filepath.Base(f), ".cla")
			bin := BuildMac(t, name, true, f)
			_, log, exitCode := RunMac(t, bin)
			if exitCode != 3 {
				t.Errorf("exit: got %d want 3", exitCode)
			}
			if !strings.Contains(log, strings.TrimSpace(string(want))) {
				t.Errorf("log %q missing %q", log, want)
			}
		})
	}
}
```

`BuildMac`, `RunMac`, and `firstDiff` are implemented fully (exec + LaunchAPPL + extraction per FINDINGS.md; `firstDiff` reports line number and both lines at first mismatch). Runerr programs are NOT split — `BuildMac` compiles the original single file; its emitted main runs the handler and panics as on host.

- [ ] **Step 2: Run ungated (must skip cleanly):** `go test ./internal/mactest -count=1` → suite host test PASS, mac tests SKIP.

- [ ] **Step 3: Run gated:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -v -timeout 30m`.
Expected: PASS. Divergences at this point are Mac-runtime bugs — fix in `runtime/mac/rt_mac.c` (semantics must match rt.c; when in doubt rt.c is right), re-run. Budget for iteration; this step is the real 4a shakeout.

- [ ] **Step 4: Full verify + commit**

```bash
go test ./... -count=1
git add internal/mactest
git commit -m "mactest: gated Mac-vs-host suite byte-compare + runerr apps"
```

---

### Task 12: Docs, roadmap, final review

**Files:**
- Modify: `docs/ROADMAP.md` (4a → done, one entry in Done section; 4b next)
- Modify: `CLAUDE.md` (build-mac.sh usage line + `CLARUS_MAC_TESTS=1` harness line under "Running Mac apps in the emulator")

- [ ] Update both docs (concise — follow each file's existing style).
- [ ] `go test ./...` green; `CLARUS_MAC_TESTS=1 go test ./internal/mactest` green.
- [ ] Commit `"docs: 4a done — Mac runtime, build-mac pipeline, corpus suite"`.
- [ ] Whole-branch final review (most capable model) per project convention; one consolidated fix wave if needed.
- [ ] Offer merge to the user (do not merge unprompted).

---

## Self-review notes

- Spec coverage: pipeline (T8), full ABI (T7/9/10), corpus split (T2-5), suite (T6), harness + probe (T1, T11), milestone (T8), docs (T12). Frozen-surface rule holds: no existing `internal/` file is modified (the lib/-subdir trick makes harness edits unnecessary — supersedes the spec's "harnesses may adapt" allowance).
- The 41/6 corpus counts supersede the spec's earlier 21/3 estimate (miscount; scope unchanged: all of `testdata/run` + `testdata/runerr`).
- Emitted C's only include is `rt.h` (verified on the snapshot); Retro68 newlib supplies nothing we rely on.
- `qd` globals and `main(argc, argv)` are provided by Retro68/libretro (verified in the toolchain-smoke session of 2026-07-24).
