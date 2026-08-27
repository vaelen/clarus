# Task 1 report: front end for `= ptr` extern clause (conv 10)

## Summary

Implemented the front end only (parser + AST doc + checker rule +
fixtures), per `task-1-brief.md`. No codegen changes (out of scope for
this task).

## Files changed

- `clarusc/parse.cla`
  - New contextual keyword `cwPtr` (declared ~line 89, interned ~line
    126, added to the `curIsIdentIdx` doc-comment keyword list ~line
    218).
  - `parseExternFuncDecl`: new `else if curIsIdentIdx(cwPtr)` clause arm
    between the `cwInline` arm and the trailing `else` (sets
    `convFlag = 10`); updated the trailing-`else` diagnostic to
    `expected "trap", "inline", or "ptr", found ...`; updated the
    function's grammar doc comment (~1675) and provenance note (~1685)
    to include `| "ptr"`.
- `clarusc/ast.cla`
  - `externFuncConv`'s doc comment: appended `10=pascal call through a
    runtime pointer (`= ptr`, extern-ptr-call phase -- first param is
    the jump target).`
- `clarusc/check.cla`
  - `checkExternFunc`: after the conv 5 (`inline a5`) rule, added the
    conv 10 rule exactly as specified in the brief (short-circuited on
    `i == 0` before reading `funcSigParam(sigIdx, 0)`).
  - `checkExternFunc`'s doc comment (~2950): added the conv 10 sentence.
  - Verified (no change needed): `externClauseMatches` (~3269) already
    compares `externFuncConv(a) != externFuncConv(b)`, which alone makes
    `= ptr` vs `= trap` conflict on redeclaration — conv 10 adds no new
    packed-`c`-slot data, so no extension to the comparison was needed,
    confirming the brief's prediction.
- `clarusc/test/check_test.cla`: appended the seven-case block verbatim
  from the brief, at the end of `on App.startEmpty { ... }` (before its
  closing `}`).
- `clarusc/test/check_test.out`: regenerated/blessed; diff from the
  prior blessed file is exactly the 15 new lines for the 7 new cases
  (see GREEN evidence below).

## RED evidence (Step 2, before parser change)

```
$ scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1; tail -20 /tmp/check_test_new.out
...
=== extern ptr clean + merge ===
check_test.cla:1:56: expected "trap" or "inline", found identifier
=== extern ptr no params ===
check_test.cla:1:29: expected "trap" or "inline", found identifier
=== extern ptr first param not ptr ===
check_test.cla:1:50: expected "trap" or "inline", found identifier
=== extern ptr redecl mismatch ===
check_test.cla:1:39: expected "trap" or "inline", found identifier
=== extern ptr rejects reg ===
check_test.cla:1:39: expected "trap" or "inline", found identifier
=== extern ptr rejects sel ===
check_test.cla:1:39: expected "trap" or "inline", found identifier
=== extern ptr rejects ret ===
check_test.cla:1:39: expected "trap" or "inline", found identifier
```

All seven new cases failed to parse `= ptr` at all, as expected.

## GREEN evidence (Step 6, after implementation)

```
$ scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1
$ diff /tmp/check_test_new.out clarusc/test/check_test.out
302,316d301
< === extern ptr clean + merge ===
< clean
< === extern ptr no params ===
< check_test.cla:1:1: = ptr requires a first parameter of type ptr
< === extern ptr first param not ptr ===
< check_test.cla:1:1: = ptr requires a first parameter of type ptr
< === extern ptr redecl mismatch ===
< check_test.cla:1:1: conflicting extern declaration for 'Bad3' (also declared at 2:1)
< check_test.cla:2:1: conflicting extern declaration for 'Bad3' (also declared at 1:1)
< === extern ptr rejects reg ===
< check_test.cla:1:43: expected declaration, found identifier
< === extern ptr rejects sel ===
< check_test.cla:1:43: expected declaration, found identifier
< === extern ptr rejects ret ===
< check_test.cla:1:43: expected declaration, found identifier
```

Diff is exactly the 15 new lines from the 7 new cases; no existing case
changed. Blessed with `cp /tmp/check_test_new.out clarusc/test/check_test.out`,
then re-diffed to confirm identical (empty diff).

Case-by-case behavior matches the brief's expectations:
- "clean + merge": two identical `= ptr` decls merge cleanly, `func go`
  can call through the decayed `ptr` param — clean.
- "no params" / "first param not ptr": both hit the new conv-10 checker
  diagnostic.
- "redecl mismatch": `= ptr` vs `= trap 0xA975` conflict via the
  existing `externFuncConv` comparison in `externClauseMatches` —
  produces the existing "conflicting extern declaration" diagnostic,
  unchanged wording.
- "rejects reg/sel/ret": `= ptr` accepts no suffix, so the grammar
  itself treats the trailing `reg`/`sel 1`/`ret d0` tokens as a stray
  top-level parse error (`expected declaration, found identifier`) —
  the grammar-level suffix rejection the brief's Step 6 note describes.

## T1

```
$ scripts/test-task.sh
...
test-task.sh: PASS in 28s (smoke=0)
```

## Self-review

- Every brief requirement implemented: `cwPtr` intern, parser clause
  arm (verbatim from brief), trailing-else diagnostic text (verbatim),
  grammar doc comment updated, `curIsIdentIdx` keyword-list doc updated
  (extra, for accuracy — not explicitly required but keeps that comment
  truthful), `externFuncConv` doc comment (verbatim addition),
  `checkExternFunc` conv-10 rule (verbatim from brief) plus its doc
  comment, fixture cases (verbatim from brief), `.out` blessed.
- Diagnostic/fixture text checked verbatim against the brief's code
  blocks — matches exactly.
- No unrelated changes: `git diff --stat` shows only the 5 files the
  brief names; diff content confined to the described insertion points.
- `.out` diff contains ONLY the seven new cases' lines (confirmed via
  `diff` above, and re-confirmed identical after blessing).
- ASCII check: `git diff | LC_ALL=C grep -nP '[^\x00-\x7F]'` found
  nothing.
- Confirmed (per Step 1's explicit instruction) that
  `externClauseMatches` already includes `externFuncConv` in its
  comparison, so `= ptr` vs `= trap` redeclaration conflicts correctly
  with zero changes to that function — matches the brief's prediction
  that "no comparison change should be needed."

## Concerns

None. Front end only, as scoped; codegen for both lanes is deferred to
later tasks per the brief and design spec.

## Commit

`c9c2d4f` — `feat: parse + check '= ptr' extern clause (conv 10)`
(branch `extern-ptr-call`)
