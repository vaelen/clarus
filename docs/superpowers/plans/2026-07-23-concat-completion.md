# Concatenation Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Make `+` concatenation order-independent for the two missing
combinations — `char + string` (prepend → `string(255)`) and `string + text`
(→ `text`) — in the Go compiler and the clarusc checker, then replace the
clarusc workaround that these features obsolete.

**Architecture:** The Go compiler is the reference: add the type rules
(check), lowering to new intrinsics, C emission, and runtime functions, each
mirroring the existing `string + char` / `text + string` implementations. The
clarusc checker (check-only) mirrors just the two type rules. The differential
harness (both compilers over the whole corpus) is the parity gate; a new
`testdata/run` golden exercises the Go pipeline end to end.

**Tech Stack:** Go compiler (internal/{ir,check,lower,cprint}), C runtime
(internal/build/rt), Clarus (clarusc/*.cla), Go test harness.

## Global Constraints

- Commit trailer on every commit, verbatim:
  `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`
  `Claude-Session: https://claude.ai/code/session_01Fik77MPsCPT8hWgiVFa2FZ`
- Byte-exact diagnostic parity between `clarus check` and clarusc over the
  entire corpus is the contract. `go test ./internal/selfhost/...` must stay
  green (zero divergences).
- New concat rules (normative, from the reference Ch3/Ch4):
  - `char + string` → `string(255)` (prepend; the char goes first)
  - `string + text` → `text`
  - Existing rules unchanged: `string + string`→`string(255)`,
    `string + char`→`string(255)` (append), `text + text`→`text`,
    `text + string`→`text`.
- Truncation/clamp behavior for the `string(255)` result matches
  `rt_str_concat_char` exactly: clamp to 255, set `lastError` ("string
  truncated") if bytes were dropped.

---

### Task 1: Go compiler — `char + string` and `string + text` full pipeline

**Files:**
- Modify: `internal/ir/intrinsics.go` (two new intrinsic name constants)
- Modify: `internal/check/expr.go:283-292` (two new type-rule cases)
- Modify: `internal/lower/expr.go:183-188` (two new lowering cases)
- Modify: `internal/cprint/intr.go` (emit for the two new intrinsics)
- Modify: `internal/build/rt/rt.h`, `internal/build/rt/rt.c` (two runtime fns)
- Test: `internal/check/*_test.go` (add type-rule cases to the existing `+`
  concat table test), and a new `testdata/run/concat_order.cla` golden.

**Interfaces:**
- Produces: intrinsics `ir.IStrPrependChar = "str_prepend_char"` (Args:
  `[char, string]` → str255 temp) and `ir.ITextConcatSL = "text_concat_sl"`
  (Args: `[string, text]` → text). Runtime `void rt_str_prepend_char(uint8_t
  *out255, uint8_t c, const uint8_t *a)` and `void rt_text_concat_sl(rt_text
  *t, const uint8_t *sstr, const rt_text *btext)`.

- [ ] **Step 1: Add intrinsic constants.** In `internal/ir/intrinsics.go`,
  beside `IStrConcatChar` add:
  ```go
  IStrPrependChar = "str_prepend_char" // (c char, a str) -> str255 temp
  ```
  and beside `ITextConcat` add:
  ```go
  ITextConcatSL = "text_concat_sl" // (s str, b text) -> text (string on left)
  ```

- [ ] **Step 2: Add check type rules.** In `internal/check/expr.go`, inside
  the `if e.Op == "+"` block, after the existing cases add:
  ```go
  if lt.Kind == types.Char && rt.Kind == types.String {
      return types.StringT(255)
  }
  if lt.Kind == types.String && rt.Kind == types.Text {
      return types.TextT
  }
  ```

- [ ] **Step 3: Add lowering cases.** In `internal/lower/expr.go`
  `lowerBinary`, inside the `case "+":` switch, add before `default:`:
  ```go
  case lt.Kind == types.Char && rt.Kind == types.String:
      return l.intr(ir.IStrPrependChar, ty, e.X, e.Y)
  case lt.Kind == types.String && rt.Kind == types.Text:
      return l.intr(ir.ITextConcatSL, ty, e.X, e.Y)
  ```

- [ ] **Step 4: Add C emission.** In `internal/cprint/intr.go`, beside the
  `IStrConcatChar` case add (Args[0]=char, Args[1]=string; result is a fresh
  str255 temp `t`):
  ```go
  case ir.IStrPrependChar:
      t := fp.freshStr()
      c := fp.expr(x.Args[0])
      a := fp.strAddr(x.Args[1])
      fp.emit("rt_str_prepend_char((uint8_t*)&%s, (uint8_t)(%s), %s);", t, c, a)
      return t
  ```
  Match the surrounding style exactly — read how `IStrConcatChar` names its
  temp/args (`freshStr`/`strAddr`) and copy that idiom; the snippet above is
  the shape, use the real helper names from that case. Beside `ITextConcat`
  add:
  ```go
  case ir.ITextConcatSL:
      t := fp.freshText()
      fp.emit("rt_text_concat_sl(%s, %s, %s);", t, fp.strAddr(x.Args[0]), fp.expr(x.Args[1]))
      return t
  ```

- [ ] **Step 5: Add runtime declarations.** In `internal/build/rt/rt.h`,
  beside the existing concat decls:
  ```c
  void rt_str_prepend_char(uint8_t *out255, uint8_t c, const uint8_t *a); /* out is a str255 temp */
  void rt_text_concat_sl(rt_text *t, const uint8_t *sstr, const rt_text *btext);
  ```

- [ ] **Step 6: Add runtime definitions.** In `internal/build/rt/rt.c`,
  beside `rt_str_concat_char` add (char first, then a's bytes; clamp to 255):
  ```c
  /* out255 must not alias a; the printer always passes a fresh temp as out. */
  void rt_str_prepend_char(uint8_t *out255, uint8_t c, const uint8_t *a) {
      int la = a[0];
      int total = la + 1;
      int n = total > 255 ? 255 : total;
      out255[1] = c;                              /* n >= 1, so the char always fits */
      memmove(out255 + 2, a + 1, (size_t)(n - 1));
      out255[0] = (uint8_t)n;
      if (n < total) rt_set_lasterr(1, "string truncated");
  }
  ```
  and beside `rt_text_concat` add (string on the left, text on the right;
  mirror rt_text_concat's scratch/grow, no truncation — text is unbounded):
  ```c
  void rt_text_concat_sl(rt_text *t, const uint8_t *sstr, const rt_text *btext) {
      int slen = sstr[0];
      int32_t blen = btext->len;
      int32_t total = slen + blen;
      uint8_t *scratch = malloc((size_t)(total > 0 ? total : 1));
      if (!scratch) rt_panic("out of memory");
      memmove(scratch, sstr + 1, (size_t)slen);
      memmove(scratch + slen, btext->data, (size_t)blen);
      grow((void **)&t->data, &t->cap, total, 1);
      memmove(t->data, scratch, (size_t)total);
      t->len = total;
      free(scratch);
  }
  ```

- [ ] **Step 7: Add check-level tests.** Find the existing table test that
  exercises `+` concatenation type rules in `internal/check` (grep for
  `str_concat` intent, or the test asserting `string + char` type). Add rows:
  `char + string` → `string(255)` accepted; `string + text` → `text`
  accepted; and confirm a non-concat misuse (e.g. `char + char`, `int +
  string`) still errors with `invalid operands to +`. Run:
  `go test ./internal/check/...` → PASS.

- [ ] **Step 8: Add an end-to-end run golden.** Create
  `testdata/run/concat_order.cla` — a program whose `App.startCLI` builds a
  string by char-prepend and a text by `string + text`, and prints both so
  the output pins the byte order. Example body:
  ```
  on App.startCLI(args: list of string) {
      var s: string = "bc"
      var t: text = ""
      s = 'a' + s            // "abc" (prepend)
      t = "x" + t            // string + text -> text
      t.append("yz")
      log(s)
      log(t)
      quit 0
  }
  ```
  Follow the existing `testdata/run/*.cla` golden convention (expected-output
  sidecar or inline `// out:` — match whatever the run harness already uses;
  inspect a neighbor file first). Run the run-golden suite (the same `go test`
  target that executes `testdata/run`) → PASS, output shows `abc` then `xyz`.

- [ ] **Step 9: Full suite + commit.** Run `go test ./...` → all PASS
  (the differential in `internal/selfhost` still checks clarusc, which does
  not yet use the new forms, so it stays green). Commit:
  ```
  git add -A && git commit -m "Add char+string and string+text concatenation" -m "<trailer>"
  ```

---

### Task 2: clarusc checker parity + numToStr rewrite

**Files:**
- Modify: `clarusc/check.cla:3078-3083` (two new `+` type-rule cases)
- Modify: `clarusc/lib.cla` (`numToStr` rewrite; delete `digitsOf`)
- Test: `internal/selfhost/differential_test.go` harness run (no new Go code
  unless a targeted fixture is warranted).

**Interfaces:**
- Consumes: the new concat rules now supported by the Go compiler (Task 1),
  so clarusc source may use `char + string`.

- [ ] **Step 1: Mirror the check rules in clarusc.** In `clarusc/check.cla`
  `checkArith`, inside `if op == OpAdd {`, after the existing `TyStr+TyChar`
  and `TyText+...` cases add:
  ```
  if typeKind(lt) == TyChar and typeKind(rt) == TyStr {
      return strT(255)
  }
  if typeKind(lt) == TyStr and typeKind(rt) == TyText {
      return TextT
  }
  ```

- [ ] **Step 2: Rewrite numToStr to iterative char-prepend.** In
  `clarusc/lib.cla`, replace `numToStr` + its `digitsOf` helper with a single
  iterative function that prepends each digit (`char + string`), handling
  `n == 0`, negatives, and `int.min` safely via mod/div without negating `n`:
  ```
  // numToStr renders n in base 10. Building the digits by PREPENDING each
  // one (char + string) lets this be a flat loop instead of the recursive
  // append helper the language once required. Working from the low digit of a
  // (possibly negative) n via mod/div avoids ever negating n directly, so
  // int.min (whose negation overflows a 32-bit int) is handled safely.
  func numToStr(n: int): string {
      var s: string
      var d: int
      var neg: bool

      if n == 0 {
          return "0"
      }
      neg = n < 0
      s = ""
      while n != 0 {
          d = n mod 10
          if d < 0 {
              d = 0 - d
          }
          s = char(48 + d) + s
          n = n / 10
      }
      if neg {
          s = "-" + s
      }
      return s
  }
  ```
  Delete the now-unused `digitsOf` function entirely. Leave `internText`
  unchanged — it converts `text`→`string` (which `string + text`, yielding
  `text`, cannot do); `toBytes`/`fromBytes` remains the correct tool.

- [ ] **Step 3: Differential + self-check green.** Run
  `go test ./internal/selfhost/...` → PASS. This both (a) checks clarusc's own
  source — now using `char + string` in numToStr — under both compilers, and
  (b) diffs the whole corpus. Zero divergences required. If a divergence
  appears, the two checkers disagree on a new rule — reconcile check.cla
  against expr.go before proceeding.

- [ ] **Step 4: Sanity-run numToStr.** Confirm numToStr still produces correct
  output across the edge cases by running clarusc's existing lib test driver
  (the `lib_test.cla` / harness that exercises numToStr) if one covers it, or
  add one assertion for `numToStr(int.min)`, `numToStr(0)`, `numToStr(-7)`,
  `numToStr(1000)`. Run it via `clarus run` → expected strings.

- [ ] **Step 5: Commit.**
  ```
  git add -A && git commit -m "clarusc: accept char+string and string+text; numToStr uses char-prepend" -m "<trailer>"
  ```

---

## Self-Review

- **Spec coverage:** `char + string` (Task 1 steps 2-6, Task 2 step 1);
  `string + text` (same); workaround replacement (Task 2 step 2, numToStr);
  follow-up note (done pre-plan, ROADMAP). internText correctly left alone
  (documented reason). ✓
- **Type consistency:** intrinsic names `IStrPrependChar`/`ITextConcatSL` and
  runtime `rt_str_prepend_char`/`rt_text_concat_sl` used identically in
  ir/lower/cprint/rt. ✓
- **Parity:** clarusc check rules (Task 2 step 1) exactly mirror Go check
  rules (Task 1 step 2); differential is the gate (Task 2 step 3). ✓
