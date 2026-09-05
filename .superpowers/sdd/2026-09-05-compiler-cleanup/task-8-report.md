# Task 8 report — Diagnostics B (spec §4.3)

Worktree: `/Users/andrew/repos/clarus/.claude/worktrees/agent-a2d44a6a87db82d1a`
Branch: `worktree-agent-a2d44a6a87db82d1a` (based on `compiler-cleanup` @ `311af68` —
see "Worktree base" below)

## Commits

| SHA | Subject |
|---|---|
| `3722f3a` | fix(check): transport-misuse diagnostic points at the transport keyword |
| `0addfa2` | fix(check): transportName is exhaustive |
| `4ee0aad` | fix(check): usesConn set from any connection type position; fieldonly conntest |
| `65bb37b` | test(cg68k): pin the unspliced-runtime-function guard |
| `53b242b` | style(tests): ASCII-only comments in the new fixtures |

### Worktree base

The worktree was handed to me at `a1f9899` (**main**), not at `compiler-cleanup`
`311af68` as the dispatch stated. `a1f9899` is a strict ancestor of `311af68`
(verified with `git merge-base --is-ancestor`), so I `git reset --hard 311af68` on
a clean tree before starting. All five commits sit on top of `311af68`. Flagging it
because the controller may have handed the same stale base to sibling tasks.

## Files changed

- `clarusc/ast.cla` — `ExprNode` gains `tLine`/`tCol`; `newCall` gains two params;
  new `callTransportLine`/`callTransportCol` accessors.
- `clarusc/parse.cla` — new `parseArgsTransportLine`/`parseArgsTransportCol`
  out-globals; `parseArgs` captures the keyword position before `advance()`; the
  single `newCall` call site updated.
- `clarusc/check.cla` — both `checkCall` `emitDiag` sites use the keyword position;
  `transportName` exhaustive + `abort`; `usesConn` hook moved from
  `checkTopDeclPhase1`'s `DkVar` arm into `resolveType`'s `TxNamed` arm (and its doc
  comment rewritten); the now-unused `symIdx` local dropped from
  `checkTopDeclPhase1`.
- `testdata/errors/transport_misuse_col.cla` + `.expect` — **new**.
- `testdata/errors/conn_serial_badarg.expect` — regenerated (`10:14` → `10:15`).
- `tests/conntest/fieldonly.sh` + `tests/conntest/testdata/fieldonly.cla` — **new**.
- `tests/cg68k/unspliced_guard.sh` — **new**.

No `clarusc/clarusc.c`, no `clarusc/bake.cla`, no `tests/lib.sh`, no goldens blessed.

## Step 2 — transport keyword position

**Node-size growth (controller decision 1).** `ExprNode` had exactly ONE spare
generic int for `ExCall` (`c`); `nameIdx` is also unset by `newCall` but is a
semantic field every other kind uses, so hiding a column number in it would mislead
the next reader. Per the brief's "otherwise add `tLine`/`tCol` fields", I added two
new fields. **Every `ExprNode` grows 8 bytes** (9 ints → 11). The expr arena is a
few tens of thousands of nodes even when clarusc compiles itself, so this is well
under a megabyte on the Mac-resident compiler; T1 and perfgate are green with it.

**RED** (fixture committed before the fix; run from `tests/selfhost`, the directory
`diag.sh` cds into):

```
$ ../../build-run/clarusc-current emit -o /tmp/o.c ../../testdata/errors/transport_misuse_col.cla
../../testdata/errors/transport_misuse_col.cla:9:6: serial is only valid on connection.open with a single string argument
rc=1
```

`9:6` is the `(`. Wanted `9:7`, the `s` of `serial`.

**GREEN**:

```
../../testdata/errors/transport_misuse_col.cla:9:7: serial is only valid on connection.open with a single string argument
```

**Collateral golden move (not blessed — regenerated from the real compiler).** The
pre-existing `testdata/errors/conn_serial_badarg.expect` moves for the same reason:
`10:14` (the `(` of `.send(`) → `10:15` (the `s` of `serial`). That is the intended
behaviour change, not drift. Both `.expect` files were produced by running
`build-run/clarusc-current emit` from `tests/selfhost/` and copying its combined
output verbatim, exactly as `tests/selfhost/diag.sh` compares it.

`make test T=selfhost/diag` → `PASS selfhost/diag`, 27 fixtures.

## Step 3 — `transportName` outcome

Was `if tag == 1 { "appletalk" }; return "serial"` — an unknown tag silently
rendered as `serial`. Now tag 2 is matched explicitly and anything else hits
`abort("clarusc: unknown transport tag " + numToStr(tag))`. `abort` is the ordinary
language builtin (the same one `lowUnsupported` and `bake.cla` use for internal
invariants); `check.cla` had no `abort(` call of its own before, so there was no
existing house style to match.

Callers all pre-filter on `transport != 0`, so this is unreachable by construction
and has no fixture — it is an invariant tripwire, not a user diagnostic.

## Step 4 — `usesConn` from `resolveType`, and the zero-slot audit

Moved the hook beside `usesFileh`'s in `resolveType`'s `TxNamed` arm; deleted the
`DkVar`-arm setter (and its now-dead `symIdx` local). `lower.cla`'s slot pre-pass
was **not** changed.

**Audit (controller decision 2): a `usesConn == true, zero global connection vars`
program is now constructible. Every consumer tolerates it.**

- `lower.cla:7671,7764-7775` — `connCount` is a **`lowerProgram`-local**. Its only
  effects are the `>= 4` abort and populating `lowConnSlotOf`. The loop walks
  `declHead` `DkVar`s and finds none, so `connCount` stays 0, no abort, empty map.
  Nothing outside `lowerProgram` ever reads `connCount`.
- `lowConnSlotOf` — read sites are already guarded: `lower.cla:5179`
  `.get(root, -1)` (behind `symbols[symIdx].typeIdx == connectionT`, which can only
  hold for a real global) and `lower.cla:5385/5409` `.has(...)` / `.get(_, -1)`. A
  field-only program never enters either branch, because neither a record field nor
  a param is a top-level `DkVar`.
- `irUsesConn` (mirrors `usesConn`) — three readers:
  - `cprint.cla:7597` emits the host pump loop `while (rtConnAlive()) {...}`. With
    zero connections `rtConnAlive()` is false on the first test, so the body never
    runs. The symbols it calls exist precisely because `usesConn` is what splices
    `conn.cla`.
  - `shake.cla:241` roots `rtConnPump`/`rtConnAlive` — same module, present.
  - `lower.cla:7763` is the assignment itself.

So the previously-impossible state is a no-op everywhere. **Nothing needed fixing**;
the only change is the hook's location. `fieldonly.sh`'s `run` subcase proves it
end to end: the binary reaches the pump loop with zero connections and exits 0.

**Also checked: no over-triggering.** `resolveType` runs over runtime modules too,
so a module naming `connection` in a type position could in principle have flipped
`usesConn` for every program. It does not — `examples/texteditor.cla` emits C with
zero `clar_fn_rtConn` occurrences, and `cg68k/goldens`, `emitui/*` and the whole
`bake/` group are green, i.e. no emitted output moved for a non-connection program.

## Step 5 — `tests/conntest/fieldonly.sh`

Follows `conn_build`'s real contract as read off `tests/lib_conntest.sh`: it takes a
NAME and builds `tests/conntest/testdata/<NAME>.cla` into `$WORK/<NAME>`, with the
build log at `$WORK/<NAME>.build` (the brief's sketch guessed a different signature
and log path; both were wrong). So the program lives at
`tests/conntest/testdata/fieldonly.cla`.

One deviation from the brief's sketch, and it matters: the brief's program never
*used* the connection, only named it. That version **built clean even without the
fix** — nothing referenced any `rtConn*` symbol, so the missing splice was
invisible and the fixture would have been a false pass. The committed fixture
therefore adds a statically-reachable `c.send(...)` behind a runtime-false guard
(`if id() < 0`), which `shake.cla` keeps, so the linker really has to resolve it.
That reproduces the spec's stated failure.

**RED** (before Step 4's fix):

```
FAIL build: .../fieldonly.c:1125:9: error: call to undeclared function
'clar_fn_rtConnSendStr'; ISO C99 and later do not support implicit function
declarations [-Wimplicit-function-declaration]
 1125 |         clar_fn_rtConnSendStr(cv_c, &(clar_lit_118));
```

**GREEN** — four subcases: `build` (emit + `cc` link), `conn_spliced` (the emitted
C mentions `clar_fn_rtConnPump`), `run` (exit 0), `native_emit` (`emit68k` exits 0;
the native lane splices `conn.cla` unconditionally so that half never depended on
`usesConn`, but it is pinned so a future narrowing of `drive.cla`'s `want68k` arm
cannot silently reopen the same gap).

```
PASS conntest/abort  PASS conntest/connect  PASS conntest/envunset
PASS conntest/fieldonly  PASS conntest/listen  PASS conntest/shadow
tests: 6 passed, 0 skipped, 0 failed
```

## Step 6 — unspliced-function guard: WHICH OUTCOME (controller decision 3)

**The TODO's `list index out of range` crash is NOT live. The guard already
diagnoses cleanly.** I ran the brief's script verbatim first; it passed
immediately. No `-1` guard was added to any compiler file.

But the brief's shape passes for a *weaker* reason than intended, so the committed
script is stronger than the sketch. Details:

1. **The brief's shape never reaches codegen.** With `datetime_68k.cla` removed
   from the `--rtdir` copy, `drive.cla`'s manifest splice rejects it while
   *loading* the runtime, long before `cgJsrByName`/`cgCallFnScalar`:
   ```
   [...] Included /tmp/rtx/datetime.cla
   runtime module datetime_68k.cla not found (searched /tmp/rtx/); use --rtdir
   rc=1
   ```
   So as written the fixture pins the *module* check, not the guard family §4.3d
   names.

2. **A bare `runtime/clarus` copy is broken for an unrelated reason.** It fails
   with `undefined: CInfoPBRec` &c. because `fileh_68k.cla` `include`s
   `toolbox/*.cla` through the `<rtdir>/../../toolbox/` fallback, which does not
   resolve for a flat copy. The brief's script never noticed because the missing
   module aborts first — i.e. it would have gone on passing even if the copy were
   nonsense. The committed script builds a well-formed
   `$WORK/<name>/{runtime/clarus,toolbox}` tree instead, and asserts a
   **`baseline`** subcase (untouched copy builds clean) so neither failure below
   can be an artifact of the copy.

3. **Added a `missing_function` subcase that does reach the guard.** Delete
   `rtStrStore` from `str.cla` in the copy and compile a program that stores a
   string. Nothing else in the runtime references `rtStrStore`, so it survives the
   whole-program check and reaches `cg68k.cla`'s lookup:
   ```
   [...] Shaken (0s, 0 ticks)
   cg68k: rtStrStore not found/reachable
   rc=1
   ```
   Named diagnostic, exit 1. Not `list index out of range`, not exit 3.

Final: `PASS baseline / PASS missing_module / PASS missing_function`.

**`findIRFuncIdxByName` audit** (done anyway, even though the fixture never went
red). Every one of the ~45 `fi = findIRFuncIdxByName(...)` sites in `cg68k.cla`,
and both in `shake.cla`/`cprint.cla`, is followed within three lines by an `== -1`
guard. Exactly one site anywhere in the compiler uses the result unguarded:

- `clarusc/lower.cla:6196` — `fIdx = findIRFuncIdxByName(fnNameIdx)` then
  `irFuncBodyHead(fIdx)` with no `-1` check. **Deliberately not touched.** It is a
  lowering-internal lookup of a window handler function *this same pass has already
  minted*, so `-1` is structurally unreachable; it is not a runtime-module-splice
  path, it is outside my brief's scope (`cg68k.cla` / `shake.cla`), and no fixture
  can reach it. Recorded here so the controller can decide whether it is worth a
  cheap `abort` in a later task — I judged a guard there to be speculative
  hardening.

**Recommended TODO disposition:** entry 13 ("STILL LIVE unspliced-runtime-function
crash") can be closed as not-reproducible, now pinned by
`tests/cg68k/unspliced_guard.sh`'s two shapes.

## Step 7 — gates

`pgrep -x minivmac` printed `81313` — **the emulator was busy**, so per the
constraints I did **not** run `--smoke`. Native proof deferred (emulator busy). The
native lane is still exercised without booting: `fieldonly.sh`'s `native_emit` and
all three `unspliced_guard` subcases go through `emit68k`.

```
$ scripts/test-task.sh
tests: 77 passed, 35 skipped, 0 failed
PASS perfgate/tripwire 1s
tests: 1 passed, 0 skipped, 0 failed
test-task.sh: PASS in 20s (smoke=0)
```

**No golden moved.** `PASS cg68k/goldens`, `PASS bake/identity` and the whole
`bake/` + `emitui/` groups are green; nothing was blessed. (`emitui/goldens`,
`mactest/*` and `bake/full_corpus_*` SKIP as usual without their gate variables.)

The brief's targeted command:

```
$ make test T='selfhost/diag conntest/ cg68k/unspliced_guard'
PASS selfhost/diag 0s
PASS conntest/abort 1s      PASS conntest/connect 1s
PASS conntest/envunset 0s   PASS conntest/fieldonly 1s
PASS conntest/listen 1s     PASS conntest/shadow 1s
PASS cg68k/unspliced_guard 0s
tests: 8 passed, 0 skipped, 0 failed
```

`make test T=runner/` (the `sh -n` sweep over every test script) is green with the
two new scripts; both are `chmod +x`.

### `selfhost/`

Run in full (`make test T=selfhost/`) — **the expected snapshot-staleness red, and
nothing else**:

```
PASS selfhost/modules 6s
PASS selfhost/snapshot 6s
=== FAIL(exit 1) selfhost/fixedpoint 1s
FAIL snapshot_fresh: clarusc/clarusc.c is stale: committed snapshot (4935632 bytes)
!= fresh emission from the snapshot-built compiler (4951026 bytes).
[...]
first divergence at line 1033:
--- c2 ---  clar_lit_754 = " is only valid on connection.open with a single string argument"
--- c3 ---  clar_lit_754 = "clarusc: unknown transport tag "

tests: 5 passed, 0 skipped, 1 failed
```

The only divergence is my new `transportName` abort literal shifting the string
pool by one entry — i.e. the snapshot is stale in exactly the way `constraints.md`
predicts for any task that edits `clarusc/*.cla`. **Not regenerated** (Task 10
owns that). Every other `selfhost/` subcase — `modules`, `snapshot`, and the other
five subcases of `fixedpoint` including the cross-generation differential oracles
— is green, which is the real evidence that the `ExprNode` widening and the
`usesConn` move are behaviour-neutral.

## Self-review

**Completeness (a–d).** (a) transport keyword position — done, fixture pins the
column. (b) `transportName` exhaustive — done. (c) `usesConn` from `resolveType` —
done, `DkVar` setter deleted, host fixture covers both the record field and the
param in one program (the spec asked for both; one program exercising both is the
smaller diff and both type positions are genuinely present). (d) guard fixture —
done, with the outcome recorded above.

**MacRoman discipline.** All three `clarusc/*.cla` files I edited are pure ASCII
both before and after (`LC_ALL=C grep -lP '[\x80-\xff]'` lists none), so the Edit
tool was safe on them. **Note for later tasks:** `LC_ALL=C grep -c $'[\x80-\xff]'`
as written in `constraints.md` silently reported `0` for files that DO contain high
bytes under this shell — `grep -P` is the form that actually works here. That false
negative caught me once: my three new files each carried a UTF-8 `§` in a comment,
which `53b242b` replaced with the repo's own `%N.N` convention.

**Testing.** Both `.expect` files were generated by running the real
`build-run/clarusc-current` from `tests/selfhost/` (so the embedded relative path
round-trips) and copying its output verbatim — neither was hand-written.
`fieldonly.sh` really builds AND links (`conn_build` → `host_build` → `clarusc emit`
then `cc ... rt.c`) and then runs the binary. Every grep pattern in
`unspliced_guard.sh` was checked against diagnostic text I observed by hand first
(`runtime module datetime_68k.cla not found`, `cg68k: rtStrStore not
found/reachable`).

**YAGNI.** No new abstraction. The `usesConn` fix is a four-line hook moved to an
existing, precedented location rather than a new pass. The `transportName` abort
adds no user-facing surface. I did not add a guard at `lower.cla:6196` (see above)
and did not touch the concurrently-edited `checkConversion`/`checkConstDecl`/
`checkEditStmt` — my `check.cla` edits are confined to `usesConn`'s doc comment,
`resolveType`'s `TxNamed` arm, `transportName`, `checkCall`, and
`checkTopDeclPhase1`'s `DkVar` arm, exactly as scoped.

## Concerns

1. **`testdata/errors/conn_serial_badarg.expect` moved** (`10:14` → `10:15`).
   Correct and intended, but it is a golden the brief did not list — worth a glance
   at merge time.
2. **`ExprNode` is 8 bytes wider** for every expression node, not just calls. Cheap
   on the host; on the Mac-resident `ClarusC.APPL` it adds a fraction of a percent
   to the expr arena. No `--partition` change should be needed, but nothing in T1
   or T2 measures Mac-side peak memory, so it is unproven on hardware.
3. **`--smoke` not run** (emulator busy). No native boot happened for this task.
4. **`lower.cla:6196`** is the compiler's one unguarded `findIRFuncIdxByName` index
   use. Judged unreachable and out of scope; flagged for the controller.
5. **Report path.** The dispatch named
   `/Users/andrew/repos/clarus/.superpowers/sdd/.../task-8-report.md`, which is
   outside my worktree and not writable from here. This file is committed inside the
   worktree at the same relative path, so it lands in the shared checkout when the
   branch merges.
