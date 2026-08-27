### Task 4: Core suite `PtrCall` case — hardware proof on both lanes

**Files:**
- Create: `testsuite/core/cases_ptrcall.cla`
- Modify: `testsuite/core/runner.cla` (enum + dispatch + `nCoreCases` 79→80)
- Modify: `internal/mactest/suite_host_test.go` (`coreCLIFiles`), `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`, `internal/bake/bakeidentity_test.go` (each holds its own copy of the core file list — grep `cases_evalorder.cla` in each to find the exact spot and add `cases_ptrcall.cla` alongside)

**Interfaces:**
- Consumes: conv 10 end-to-end from Tasks 1–3.
- Produces: `CoreTest` member `PtrCall`, case function `casePtrCall(): TestResult` (built with `tkPass`/`tkFail` from `testsuite/kit.cla`, like every sibling) in `cases_ptrcall.cla`, wired into `runner.cla`'s dispatch like every neighboring case (read `cases_evalorder.cla` + its runner wiring as the template).

- [ ] **Step 1: Write the case**

`testsuite/core/cases_ptrcall.cla` — same header/reporting idiom as `cases_evalorder.cla` (read it first; use `tkExpectInt`-style kit helpers if that's what siblings use, otherwise plain compare-and-report):

```rust
// casePtrCall: `= ptr` extern (conv 10) round trip through a
// callback's decayed glue address (extern-ptr-call phase). On the
// native lane the glue is real pascal-convention 68k code, so this
// hardware-proves the marshalling -- word sign, bool high-byte-in-word,
// ptr, int, and a signed word RESULT -- against the compiler's own
// glue. On host it proves fpCallExt's cast-and-call.
external func PcNewPtr(size: int): ptr = trap 0xA11E reg
external func PcDisposePtr(p: ptr) = trap 0xA01F reg
external func PtrCallRound(entry: ptr, w: word, flag: bool, out: ptr, n: int): word = ptr

callback func pcMixed(w: word, flag: bool, out: ptr, n: int): word {
    pokel(out, n + w)
    if flag {
        return w - 100
    }
    return w
}
```

plus a `casePtrCall(): bool` that allocates a 4-byte scratch, calls `PtrCallRound(pcMixed, 7, true, scratch, 21)`, and checks: result == -93 (proves signed word round trip both directions), `peekl(scratch) == 28` (proves ptr + int arrived), plus a `flag == false` second call proving the bool actually steers (result == 7). NOTE: check first (grep `toolbox/memory.cla` and sibling core cases) whether NewPtr/DisposePtr externs are already declared in a file the core suite composes — if so, reuse those and drop the `Pc*` duplicates; if core has its own allocator idiom (some cases use text/list instead of raw ptr), match it. `pokel`/`peekl` are language intrinsics (see `callback_host.cla`), fine on both lanes.

- [ ] **Step 2: Wire the runner**

In `testsuite/core/runner.cla`: add `PtrCall` to the `CoreTest` enum, add the dispatch arm calling `casePtrCall()` (copy the neighboring arm's exact reporting shape), bump `const nCoreCases: int = 79` → `80`, and update its doc comment ("the 79 real cases plus...").

- [ ] **Step 3: Add the file to all four Go file lists**

Grep `cases_evalorder.cla` under `internal/` — add `cases_ptrcall.cla` entries in `internal/mactest/suite_host_test.go`, `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`, `internal/bake/bakeidentity_test.go`, each with a one-line comment (`// extern-ptr-call phase: runner.cla unconditionally calls casePtrCall().`).

- [ ] **Step 4: Host CLI run**

```sh
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c 2>/dev/null || true
scripts/clarus-run.sh --help >/dev/null 2>&1 || true   # ensure bootstrap cache
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli PtrCall
```

CAUTION: `clarusc/clarusc.c` is the COMMITTED snapshot — it predates Task 1, so the `cc` bootstrap above cannot compile the new syntax. Build the CURRENT compiler instead the way `scripts/clarus-run.sh` does (it bootstraps from the snapshot, then the snapshot compiler compiles current source — read the script and reuse its cached current-source clarusc), or emit via `go test`-side harnesses which already do this. Simplest reliable form: run the whole host suite through the existing gate — `go test -count=1 -run 'TestCoreCLI' ./internal/testsuite` (check the exact test name in `core_cli_test.go`).
Expected: PtrCall PASS (and `all` stays green).

- [ ] **Step 5: Native boot — the hardware proof**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 -run TestCoreSuiteGUIOn68k ./internal/mactest`
Expected: PASS with a `PtrCall` subtest green. This is the phase's load-bearing evidence: real pascal glue called through a runtime pointer on the 68k lane.

- [ ] **Step 6: T1 + commit**

```sh
scripts/test-task.sh
git add testsuite/core/cases_ptrcall.cla testsuite/core/runner.cla internal/mactest/suite_host_test.go internal/testsuite/core_cli_test.go internal/cg68k/segment_test.go internal/bake/bakeidentity_test.go
git commit -m "test: core suite PtrCall case -- '= ptr' round trip via callback glue (80 cases)"
```

---

