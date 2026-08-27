### Task 1: Front end — parse `= ptr`, check it, fixture it

**Files:**
- Modify: `clarusc/parse.cla` (~line 121 cw-interns; ~line 1748 clause parse; doc comment ~1675)
- Modify: `clarusc/ast.cla` (`externFuncConv` doc comment, ~1715)
- Modify: `clarusc/check.cla` (`checkExternFunc`, ~2969; its doc comment ~2952)
- Modify: `clarusc/test/check_test.cla` + regenerate `clarusc/test/check_test.out`

**Interfaces:**
- Produces: parsed `external func` decls with `externFuncConv(d) == 10`, `externFuncTrap(d) == -1`, `externFuncSel(d) == -1`, no reg binds, retReg -1. Checker guarantees: ≥1 param, param 0 is `ptr`, rest of signature already validated by the existing shared rules. Tasks 2–4 rely on conv 10 meaning exactly this.

- [ ] **Step 1: Add failing checker fixtures**

In `clarusc/test/check_test.cla`, append a new case block at the end of `App.startEmpty` (follow the file's existing `runCase`/`ln` idiom exactly):

```rust
    // extern-ptr-call phase: `= ptr` clause (conv 10).
    src = ""
    ln(src, "external func PluginMain(entry: ptr, verb: int): int = ptr")
    ln(src, "external func PluginMain(entry: ptr, verb: int): int = ptr")
    ln(src, "func go(p: ptr): int { return PluginMain(p, 1) }")
    runCase("extern ptr clean + merge", src)

    src = ""
    ln(src, "external func Bad1(): int = ptr")
    runCase("extern ptr no params", src)

    src = ""
    ln(src, "external func Bad2(verb: int, entry: ptr): int = ptr")
    runCase("extern ptr first param not ptr", src)

    src = ""
    ln(src, "external func Bad3(entry: ptr): int = ptr")
    ln(src, "external func Bad3(entry: ptr): int = trap 0xA975")
    runCase("extern ptr redecl mismatch", src)

    src = ""
    ln(src, "external func Bad4(entry: ptr): int = ptr reg")
    runCase("extern ptr rejects reg", src)

    src = ""
    ln(src, "external func Bad5(entry: ptr): int = ptr sel 1")
    runCase("extern ptr rejects sel", src)

    src = ""
    ln(src, "external func Bad6(entry: ptr): int = ptr ret d0")
    runCase("extern ptr rejects ret", src)
```

Before writing the expected `.out` lines, READ the tail of `checkExternFunc` (the `mergeCandidate` comparison, after line ~3120) to confirm what the mismatch diagnostic text is, and confirm the identity comparison covers `externFuncConv` + the packed `c` slot (it must, for `= ptr` vs `= trap` to conflict; conv 10 adds no new clause data, so no comparison change should be needed — if it only compares trap/sel and NOT conv, extend it to compare conv too).

- [ ] **Step 2: Run the fixture to verify it fails**

```sh
scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1; tail -20 /tmp/check_test_new.out
```

Expected: the new "extern ptr clean + merge" case reports a parse diagnostic (`expected "trap" or "inline"`), since `ptr` isn't accepted yet.

- [ ] **Step 3: Parser — accept `= ptr`**

In `clarusc/parse.cla`:
1. Alongside the other cw-interns (~line 80 declarations, ~line 116 assignments): `var cwPtr: int` / `cwPtr = intern("ptr")`. (`ptr` in clause position lexes as an ordinary identifier, same as `trap`/`inline` — contextual, no new token.)
2. In `parseExternFuncDecl`, add a third clause arm between the `cwInline` arm and the trailing `else` error:

```rust
        } else if curIsIdentIdx(cwPtr) {
            // extern-ptr-call phase: `= ptr` -- pascal-convention call
            // through a runtime pointer. The FIRST declared parameter
            // (checkExternFunc enforces it exists and is `ptr`) is the
            // jump target, consumed by the call, never pushed; every
            // remaining param/return marshals exactly like conv 1's
            // pascal trap. No suffixes: no trap word, no sel/reg/ret.
            advance()
            convFlag = 10
        } else {
```
3. Update the final `else` diagnostic to `"expected \"trap\", \"inline\", or \"ptr\", found "` and the grammar doc comment above `parseExternFuncDecl` (and the ~1675 grammar line) to include `| "ptr"`.

- [ ] **Step 4: AST doc comment**

In `clarusc/ast.cla`, extend `externFuncConv`'s doc comment list with `, 10=pascal call through a runtime pointer (\`= ptr\`, extern-ptr-call phase -- first param is the jump target)`.

- [ ] **Step 5: Checker — conv 10 rule**

In `clarusc/check.cla` `checkExternFunc`, after the conv 5 rule (the `inline a5` check), add:

```rust
    if conv == 10 and (i == 0 or typeKind(funcSigParam(sigIdx, 0)) != TyPtr) {
        emitDiag(declLine(d), declCol(d), "= ptr requires a first parameter of type ptr")
    }
```

(`i` is the param count after the existing param walk; `funcSigParam(sigIdx, 0)` is safe to read only when `i > 0`, hence the short-circuit order.) Note conv 10 deliberately reuses ALL existing shared rules unchanged: param palette (int/ptr/bool/char/word/str/text), return palette, and the trap-range check does not apply (conv 10 is not in its conv list). Update `checkExternFunc`'s doc comment (~2952) with the conv 10 sentence.

- [ ] **Step 6: Run fixture, bless the .out**

```sh
scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1
diff /tmp/check_test_new.out clarusc/test/check_test.out
```

Expected diffs ONLY in the seven new cases: "clean" for the merge case, the new diagnostic for the two bad-shape cases, the redecl-mismatch diagnostic for the fourth, and ordinary parse diagnostics for the last three (`reg`/`sel`/`ret` after the clause are stray top-level tokens -- this is the grammar-level suffix rejection the Global Constraints describe). Anything else changed = a regression, stop and investigate. Then:

```sh
cp /tmp/check_test_new.out clarusc/test/check_test.out
```

- [ ] **Step 7: T1**

Run: `scripts/test-task.sh` — expected PASS (compiler untouched beyond front end; no emit changes yet).

- [ ] **Step 8: Commit**

```sh
git add clarusc/parse.cla clarusc/ast.cla clarusc/check.cla clarusc/test/check_test.cla clarusc/test/check_test.out
git commit -m "feat: parse + check '= ptr' extern clause (conv 10)"
```

---

