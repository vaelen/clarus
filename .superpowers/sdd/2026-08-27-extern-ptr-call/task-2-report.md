# Task 2 report: host-lane `= ptr` extern call (cprint.cla)

## What was implemented

1. `clarusc/cprint.cla`: added `fpExternIdxByName(nameIdx: int): int`, a
   local mirror of `cg68k.cla`'s `cgExternIdxByName` (linear scan over
   `irExternNames`), placed immediately above `fpCallExt`.
2. `fpCallExt`: added a branch, checked before the existing rt_ext_/synth
   logic, for `xi = fpExternIdxByName(irCallExtName(e))` with
   `irExternConv(xi) == 10`. In that branch:
   - The first call-site argument is rendered via `fpExpr` as the cast
     target (`targetText`).
   - The remaining call-site arguments build `args` with the same loop
     body as the pre-existing code (KStr -> `fpStrAddr`, everything else
     -> `fpExpr`; no synth `(void*)` wrap, since a conv-10 extern is never
     a UI reverse-waist synth).
   - The C function-pointer cast's parameter list (`castParams`) is built
     from the extern's OWN declared param types, `irExternParam(xi, j)`
     for `j` from 1 (skipping the target param): KStr -> `"const uint8_t
     *"`, KText -> `cpCType(pty)`, everything else -> `cpCbWireType(pty)`;
     zero remaining params -> `"void"`.
   - `castRet` = `cpCbRetWireType(irExternRet(xi))` (handles KVoid ->
     `"void"`).
   - `call` = `"((" + castRet + " (*)(" + castParams + "))(" + targetText
     + "))(" + args + ")"`.
   The pre-existing branch (UiProgDesc / synth / plain `rt_ext_`) is now
   the `else` arm, reindented one level but otherwise byte-identical --
   confirmed by diff review (see Self-review below). Both arms feed the
   same trailing `call` variable into the shared tracked-temp-materialization
   tail, unchanged.
3. `cpEmitExternProtos`: extended the `skip` condition with
   `or irExternConv(i) == 10`, with a comment explaining a conv-10 extern
   has no `rt_ext_` host symbol (fpCallExt casts and calls through its
   first argument directly).
4. `testdata/lowlevel/ptrcall_host.cla` (new fixture, modeled on
   `callback_host.cla`) + `testdata/lowlevel/ptrcall_host.out` (new,
   `"ptrcall-ret-ok\nptrcall-write-ok\n"`). `NewPtr`/`DisposePtr` carry the
   controller-ruling trap clauses (`= trap 0xA11E reg` / `= trap 0xA01F
   reg`), verified verbatim against `runtime/clarus/list.cla`'s
   `ListNewPtr`/`ListDisposePtr` (same trap words). `PtrCallMixed` is
   declared `= ptr`; its target argument is `mixed`, a `callback func`
   decaying to its glue address.

## RED evidence

```
$ git stash push -- clarusc/cprint.cla
$ go test -count=1 -run TestLowlevel/ptrcall_host ./internal/lowlevel
--- FAIL: TestLowlevel (6.39s)
    --- FAIL: TestLowlevel/ptrcall_host.cla (0.54s)
        lowlevel_test.go:120: cc: exit status 1
            Undefined symbols for architecture arm64:
              "_rt_ext_PtrCallMixed", referenced from:
                  _main in main-de50bc.o
            ld: symbol(s) not found for architecture arm64
FAIL
$ git stash pop
```
Exactly the brief's predicted failure mode (undefined `rt_ext_PtrCallMixed`).

## GREEN evidence

```
$ go test -count=1 -run TestLowlevel ./internal/lowlevel -v
...
--- PASS: TestLowlevel/ptrcall_host.cla (0.33s)
...
PASS
ok  	clarus/internal/lowlevel	14.006s
```
All 21 fixtures (20 pre-existing + the new one) pass.

```
$ scripts/test-task.sh
...
ok  	clarus/internal/lowlevel	15.573s
ok  	clarus/internal/mactest	23.589s
...
test-task.sh: PASS in 24s (smoke=0)
```

## Sample emitted C for the fixture's `= ptr` call site

Built via a manual two-stage bootstrap (stage1 = snapshot `clarusc.c`,
stage2 = stage1 emitting `clarusc/main.cla` against current `.cla`
sources, matching `claruscboot.ensureCurrent`'s recipe), then stage2
`emit`-ing the fixture:

```c
static CLAR_PASCAL int32_t clar_cb_mixed(short cv_w, uint8_t cv_flag, void * cv_out, int32_t cv_n);
...
cv_r = ((int32_t (*)(short, uint8_t, void *, int32_t))(((void*)&clar_cb_mixed)))(7, 1, cv_scratch, 21);
...
static CLAR_PASCAL int32_t clar_cb_mixed(short cv_w, uint8_t cv_flag, void * cv_out, int32_t cv_n) { return clar_fn_mixed(cv_w, (int32_t)cv_flag, cv_out, cv_n); }
```

The cast type list (`short, uint8_t, void *, int32_t`) exactly matches
`PtrCallMixed`'s declared params after the target
(`w: word, flag: bool, out: ptr, n: int`) via `cpCbWireType`, and the
target expression is `((void*)&clar_cb_mixed)` -- the callback's decayed
glue address (`fpCbAddr`), called through the built cast.

## Files changed

- `clarusc/cprint.cla` (modified: `fpExternIdxByName` added,
  `fpCallExt` restructured, `cpEmitExternProtos` skip condition extended)
- `testdata/lowlevel/ptrcall_host.cla` (new fixture)
- `testdata/lowlevel/ptrcall_host.out` (new expected stdout)

Commit: `5f8d225` "feat: host-lane '= ptr' extern call (cast through
cpCbWireType signature)"

## Self-review findings

- Diff-reviewed the `else` arm of the restructured `fpCallExt`: apart from
  the +4-space reindent (nesting into the `else` block), every line is
  character-for-character identical to the pre-change code -- no behavior
  change for any non-conv-10 extern call. Confirmed by the full
  `TestLowlevel` suite staying green for all 20 pre-existing fixtures.
- `castParams` is built from `irExternParam(xi, j)` (the extern's declared
  signature), not from the call-site argument expression types, per the
  brief -- this matters for `mixed` itself, whose declared type at the
  call site is a callback name/glue reference, not literally `ptr`; using
  the declared extern param type sidesteps any question of what "the
  argument's type" even means for a callback-decayed reference.
  `PtrCallMixed`'s own signature also exercises KWord/KBool/KPtr/KInt
  through `cpCbWireType`, and a void return would hit `cpCbRetWireType`'s
  KVoid branch (not exercised by this fixture, since `PtrCallMixed`
  returns `int`, but the code path is a straight function call, not a
  fixture-specific conditional).
  KStr/KText params for a conv-10 extern's declared signature are not
  exercised by this fixture either (the checker's own scope for conv 10
  is unclear whether KStr/KText are even legal there beyond int/ptr/bool/
  char/word) -- flagging as an untested branch, not a defect: the code
  mirrors `cpEmitExternProtos`' own existing KStr/KText handling exactly,
  so it inherits that code's proven correctness rather than introducing
  new logic.
- `cpEmitExternProtos`'s `skip` extension is a pure boolean-or addition;
  did not touch anything else in that function.
- Confirmed `NewPtr`/`DisposePtr`'s trap clauses (`0xA11E`/`0xA01F`
  `reg`) match `runtime/clarus/list.cla`'s `ListNewPtr`/`ListDisposePtr`
  verbatim, per the controller ruling.
- Both `.cla` files and the `.out` file are ASCII-only (checked with
  `LC_ALL=C grep -n '[^ -~\t]'`, no hits).
- Did not touch `cg68k.cla` (native lane is a later task, per the
  assignment).

## Concerns

- None blocking. One minor observation for the controller: `ir.cla`
  already exposes `irExternLookup(nameIdx)`, which does the exact same
  linear scan as the new `fpExternIdxByName`/existing
  `cgExternIdxByName`. The brief explicitly specified adding a local
  mirror (matching the `cg68k.cla` precedent, whose own doc comment notes
  it re-scans locally "rather than widening ir.cla's public surface for
  one caller"), so I followed that instruction verbatim rather than
  reusing `irExternLookup` on my own judgment. Flagging in case the
  controller wants `fpCallExt`/`cgExternIdxByName` to converge on
  `irExternLookup` in a later cleanup pass -- not something I'll change
  without direction, since the brief was explicit and binding.
