# Task 3 report: native lane (cg68k) for `= ptr` extern calls

## What was implemented

`clarusc/cg68k.cla`:

1. **`cgPushPascalArgs(a0: int, xi: int, j0: int): int`** -- the pascal
   arg-push loop extracted verbatim out of `cgCallExtPascal`'s body
   (same four-way KStr/KText / KBool/KChar / KWord / default branch,
   same emission order), plus a `bytes` accumulator (4 for KStr/KText
   and the default arm, 2 for KBool/KChar/KWord) returned to the
   caller. The loop variable was renamed from the parameter `a` to a
   local `a` initialized from parameter `a0` (Clarus disallows
   assigning to a function parameter -- `a = irExprNext(a)` inside the
   loop needed a mutable local; this was the one deviation from a
   literal cut-paste, required to make it compile, with no effect on
   emitted bytes since the loop body itself is untouched).

2. **`cgCallExtPascal`** now does: result-slot push (unchanged) ->
   `cgPushPascalArgs(irCallExtArgsHead(e), xi, 0)` (return value
   ignored) -> the existing sel/seld0/trap/readback tail (untouched).
   `a`/`t`/`j` locals that only existed for the old inline loop were
   dropped from `cgCallExtPascal`'s own var block since nothing after
   the loop referenced them.

3. **`cgCallExtPtr(e: int, xi: int)`** -- new function implementing
   conv 10, following the brief's numbered recipe exactly: evaluate
   arg 0 (the jump target) and push it as a saved long *below* the
   result slot; push the result slot (same CLR.W/CLR.L shapes as
   `cgCallExtPascal`); push args 1.. via `cgPushPascalArgs(.... , xi,
   1)` against params 1..; `MOVEA.L (argBytes+slotBytes,A7),A0` to
   re-fetch the saved target past the args+slot it pushed; `JSR (A0)`;
   read the result back (same three `retIsSigned`/`retIsShortSlot`
   arms as `cgCallExtPascal`'s tail, byte for byte); `ADDQ.L #4,A7` to
   discard the saved target (the callee only pops its own declared
   args under pascal discipline, so the target is the caller's own
   cleanup).

4. **`cgCallExt` dispatch**: added `else if conv == 10 {
   cgCallExtPtr(e, xi) }` immediately before the `cgCallExtNatFallback`
   else, with a short doc comment.

## Step 1: recorded failure mode

`scripts/build-68k.sh` bootstraps clarusc from the **committed**
`clarusc/clarusc.c` snapshot only (it just recompiles that C file with
`cc` -- it does not re-transpile current `.cla` source). That snapshot
predates Task 1's parser change, so running it against
`testdata/lowlevel/ptrcall_host.cla` fails at PARSE time:

```
testdata/lowlevel/ptrcall_host.cla:12:86: expected "trap" or "inline", found identifier
```

This is not the failure the brief describes (which assumes a compiler
that already understands `= ptr` syntax) -- it's an artifact of the
snapshot bootstrap being stale relative to Tasks 1-2's *source*
changes, not yet regenerated (regeneration is conventionally deferred
to phase close-out, per repo history). To get the failure mode the
brief actually wants, I built a **two-stage** current-source compiler
instead (the same recipe `scripts/size-68k.sh` uses):

```sh
cc -O1 -I runtime/host -o work/boot clarusc/clarusc.c runtime/host/rt.c   # stage0, matches the stale snapshot
work/boot emit --rtdir runtime/clarus/ -o work/cur.c clarusc/main.cla     # self-compile CURRENT .cla source
cc -O1 -I runtime/host -o work/cur work/cur.c runtime/host/rt.c           # stage1 "cur", understands Tasks 1-2
work/cur emit68k --rtdir runtime/clarus/ -o out/PtrCallHost.bin testdata/lowlevel/ptrcall_host.cla
```

Run against the pre-Task-3 source (Tasks 1-2 only), this produced
exactly the predicted dispatch hole:

```
extern PtrCallMixed has no trap clause and no nat_ fallback
```

(from `cgCallExtNatFallback`'s `abort(...)`, since conv 10 fell all the
way through `cgCallExt`'s old else arm). This confirms the gap Task 3
closes.

## Encoder verification (read `clarusc/asm68k.cla`)

No encoder changes were needed -- all three operand shapes the recipe
needs already exist and are already exercised:

- **`OpMovea` + `AmDisp16` source, register 7 (A7-relative)**:
  `a68InstrWord`'s `OpMovea` case (line 984) computes the source EA via
  `a68EaField(sm, sr)` (line 585), which is fully register-generic --
  `(a68ModeCode(mode) << 3) | a68RegField(mode, reg)`, and for
  `AmDisp16`, `a68RegField` just returns `reg` literally (line 573-577,
  no per-register special-casing). `a68WriteEaExt` (line 779-789)
  writes the displacement word for `AmDisp16` unconditionally,
  independent of which address register it targets. Existing sites
  already use `OpMovea` + `AmDisp16` with register 6 (A6, lines
  3942/3967) and `OpMove` + `AmDisp16` with register 7 (A7, lines 9176,
  11719, 11723, 11828, 11832, 11850) -- between them these prove both
  the opcode-class and the specific register are already correctly
  handled; `OpMovea` + `AmDisp16,7,off` is the same generic machinery.
- **`OpJsr` + `AmInd` destination**: `a68InstrWord`'s `OpJsr` case
  (line 1088-1090) is `0x4E80 | a68EaField(dm, dr)`; for `AmInd`
  (mode code 2) and `dr = 0` (A0) that's `0x4E80 | (2<<3) | 0 =
  0x4E80 | 0x10 = 0x4E90` -- exactly the brief's expected `JSR (A0) =
  0x4E90`. `clarusc/test/asm68k_test.cla` line 1673 already has a
  blessed case `a68Emit(OpJsr, 0, AmNone, 0, 0, AmInd, 2, 0) // JSR
  (A2)`, proving this exact op/mode pairing is already encoder-tested
  (register-generic the same way as above).
- **`ADDQ.L #4,A7`**: grepped `OpAddq` call sites in `cg68k.cla`; line
  11511 (pre-existing, unrelated code) is
  `a68Emit(OpAddq, 4, AmImm, 0, 4, AmAn, 7, 0)` -- the exact operand
  spelling the brief asks to copy, and `cgCallExtPtr`'s own final line
  uses it verbatim.

No changes to `clarusc/asm68k.cla` or `clarusc/test/asm68k_test.cla` /
`.out` were made or needed.

## Step 4: emit68k build evidence

Using the two-stage current-source compiler described above, rebuilt
after the cg68k.cla changes:

```sh
work/boot emit --rtdir runtime/clarus/ -o work/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o work/cur work/cur.c runtime/host/rt.c
work/cur emit68k --rtdir runtime/clarus/ -o /tmp/ptrcall-out/PtrCallHost.bin testdata/lowlevel/ptrcall_host.cla
```

Result: builds clean through parse/check/lower/shake/measure/pack/emit
to `/tmp/ptrcall-out/PtrCallHost.bin` (35KB, 2 segments), no aborts, no
errors. Confirms codegen + assembly for the new conv-10 path resolve
correctly (per the brief, on-hardware behavioral proof is Task 4's
suite-boot job, not this task's).

## T1 --smoke summary

```
scripts/test-task.sh --smoke
```

All packages PASS in 39s (smoke=1), including
`internal/asm68k`, `internal/cg68k`, `internal/mactest` (both the plain
run and the `CLARUS_MAC_TESTS=1` smoke subset --
`TestSmokeBounceOn68k`/`TestRealEventLoopTickOn68k` -- boot on the real
emulator). No golden/snapshot diffs anywhere, which is direct evidence
`cgPushPascalArgs`'s extraction did not change conv 1/9 emission.

## Files changed

- `clarusc/cg68k.cla` -- `cgPushPascalArgs` (new), `cgCallExtPascal`
  (refactored to call it, no emission change), `cgCallExtPtr` (new),
  `cgCallExt` (new conv-10 dispatch arm).

Commit: `0ae201d feat: native-lane '= ptr' extern call (pascal marshal
+ JSR through saved target)`.

## Self-review

- `cgPushPascalArgs` is a verbatim extraction of the four-way branch in
  the same order, with only the `bytes` accumulator added (and the
  parameter-vs-local rename forced by Clarus's no-reassign-parameter
  rule) -- confirmed by reading the diff and by T1's clean golden-test
  pass for conv 1/9 callers.
- `cgCallExtPascal`'s emission is unchanged: same result-slot push,
  same call shape into the loop (now via the helper with j0=0), same
  tail.
- `cgCallExtPtr` matches the brief's numbered recipe verbatim,
  including the saved-target position (pushed BEFORE/below the result
  slot, addressed via `argBytes + slotBytes` at readback time) and the
  final `ADDQ.L #4,A7` discard.
- The `conv == 10` dispatch arm sits before the `cgCallExtNatFallback`
  else, after the `conv == 6 or conv == 8` arm.
- Doc comments on both new functions explain the stack layout
  (why the target sits below the result slot, why cleanup is the
  caller's job under pascal discipline).

## Concerns

None. No encoder gaps found, no snapshot/golden drift, build-68k smoke
clean on the current-source two-stage compiler, T1 --smoke fully
green.
