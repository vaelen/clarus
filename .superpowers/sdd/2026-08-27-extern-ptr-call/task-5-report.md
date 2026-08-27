# Task 5 Report: Documentation

## What was written where

### `docs/clarus-language-reference.md`

- **Grammar production** (line 1778-1781, inside "Trap and Inline Clauses",
  ~1773): extended the `externDecl` clause alternatives with a new
  `| "ptr"` arm, matching `clarusc/parse.cla`'s `parseExternFuncDecl` doc
  comment production exactly:
  `[ "=" ( "trap" ... | "inline" ( "deref" | "nop" | "a5" ) | "ptr" ) ]`.

- **New subsection** `### The \`ptr\` Clause`, inserted at line 1850,
  immediately before `### The \`word\` Extern Type` (now at 1882 after the
  insertion). Spans lines 1850-1878 (29 lines: 7 paragraphs + 2 fenced
  `rust` code blocks). Covers, in order: what `= ptr` is for (no trap, no
  intrinsic, calls through a held pointer); the first-parameter target
  rule with the exact checker diagnostic text; a one-line signature
  example; the "marshals like plain pascal trap" cross-reference
  paragraph; the no-suffix/grammar-level-parse-error paragraph; the
  redeclaration-merge-rule-unchanged paragraph; the callback-name-as-target
  paragraph; the nil/garbage-target-is-caller's-problem paragraph; the
  interrupt-time-out-of-scope paragraph (mirrors the `callback func`
  section's own wording at line 1769); the "calling contract, not a
  binding" sentence; and a closing worked example (`HLock` → `HandleToPtr`
  → `PluginMain(code, 1, pb)`, with `GetResource` cited in a comment since
  it isn't a real catalog declaration — same as the spec's own example).

### `docs/clarus-toolbox-cookbook.md`

- **New section** `## 13. Walkthrough: calling loaded code — the \`= ptr\`
  clause`, appended after §12 (`_HFSDispatch`) and before the closing
  citation footer. Spans roughly 59 new lines. Covers: when to reach for
  `= ptr` vs `= trap`; the same worked example end-to-end (`HLock` →
  `HandleToPtr` → `PluginMain`), with real `toolbox/memory.cla` trap word
  `0xA029` for `HLock`; the "calling contract, not a binding" restatement;
  and the two footguns from the brief — keep the handle locked across
  every call into it, and one `= ptr` extern per distinct entry-point
  shape.

## Rule-by-rule coverage checklist (spec → reference)

1. First param must exist, must be `ptr`, consumed as jump target not
   pushed → reference ¶1 ("The declaration's first parameter is the call
   target... a zero-parameter `= ptr` declaration, or one whose first
   parameter is any other type, is a compile-time error (`= ptr requires a
   first parameter of type ptr`)").
2. Remaining params/return marshal identically to plain pascal `trap`,
   same type sets and high-byte convention → reference ¶3 ("Every
   parameter after the target, and the return type, follow the plain
   pascal `trap` clause's own marshalling rules exactly... the same
   high-byte `bool`/`char` convention, the same borrowed-address treatment
   for `str`/`text`").
3. `ptr` mutually exclusive with `reg`/`sel`/`seld0`/`ret`/`memerr`,
   pascal-only, rejected by grammar (not a checked diagnostic) → reference
   ¶4 ("`ptr` takes no suffix... The grammar itself has no production for
   a suffix in that position, so writing one is a plain parse error, not
   a checked diagnostic...").
4. Redeclaration-merge rule applies unchanged; `= ptr` vs `= ptr` merges,
   `= ptr` vs `= trap` conflicts → reference ¶5 ("The redeclaration-merge
   rule (above) applies unchanged, with `= ptr` counted as the clause for
   the identity check...").
5. Nil/garbage target is caller's problem, no runtime guard → reference
   ¶7 ("A nil or garbage target is the caller's problem: `= ptr` performs
   no runtime check on the pointer before jumping through it...").
6. Callback bare name is a valid target arg, decay rule already covers it,
   no new special case → reference ¶6 ("A `callback func`'s bare name is
   a valid argument for a `= ptr` call's target parameter, needing no rule
   of its own...").
7. Interrupt-time entry points out of scope, mirrors `callback func`'s
   own paragraph → reference ¶8 ("Interrupt-time entry points are out of
   scope, for the same reason `callback func` excludes them (above)...").
8. "Calling contract, not a binding" point → reference ¶9, and restated
   in the cookbook.
9. Worked GetResource → HLock → HandleToPtr → call example → reference's
   closing code block and the cookbook's §13 code block, both showing
   `HLock(h)` then `HandleToPtr(h)` then `PluginMain(code, 1, pb)`, with
   `GetResource` cited in a comment (not declared — it isn't in the
   catalog today, same as the spec's own example).
10. Cookbook recipe with the two footguns → cookbook §13's bulleted list
    ("Keep the handle locked across every call into it" /
    "One extern per distinct entry-point shape").

## Files changed

- `docs/clarus-language-reference.md` (+35/-1)
- `docs/clarus-toolbox-cookbook.md` (+59)

Commit: `929bd15` — "docs: '= ptr' extern clause -- reference subsection +
cookbook recipe"

## Self-review findings

- Verified the checker diagnostic text against `clarusc/check.cla:3078`
  (`emitDiag(..., "= ptr requires a first parameter of type ptr")`) —
  quoted verbatim.
- Verified the grammar production against `clarusc/parse.cla`'s
  `parseExternFuncDecl` doc comment (lines 1676-1688) — the reference's
  EBNF now matches: `"ptr"` is a third top-level alternative alongside
  `"trap" ...` and `"inline" ...`, with no suffix production.
- Verified `HLock`'s real trap word (`0xA029 reg`) in
  `toolbox/memory.cla:167` before citing it in both files — did not
  invent a trap word.
- Confirmed `GetResource` is NOT currently declared anywhere in
  `toolbox/*.cla` or `runtime/clarus/*.cla` — matched the spec's own
  example, which also only references it in a comment
  (`// h from GetResource + HLock`) rather than declaring it, so neither
  new doc invents a nonexistent catalog entry.
- Caught and fixed one inaccuracy during drafting: an early draft of the
  cookbook's first footgun cited "§9(c)'s hard-won-lessons list" as
  covering handle-locking caller errors. §9(c) is actually about
  fill-target trap parameters needing `ptr` not `str` — unrelated. Removed
  the false cross-reference before committing.
- Strengthened the reference's closing example after first-pass review:
  the brief specifically asks for the full "GetResource → HLock →
  HandleToPtr → call" sequence; my first draft omitted the explicit
  `HLock` call (only mentioned it in a comment). Added the real `HLock`
  declaration and call so both the reference and the cookbook show the
  identical four-step sequence.
- Did not edit the pre-existing "Two `external func` declarations sharing
  a name are legal if and only if they are IDENTICAL..." paragraph
  (line 1843) to spell out `ptr` in its "trap/inline clause" enumeration —
  the new subsection's own cross-reference sentence ("The
  redeclaration-merge rule (above) applies unchanged, with `= ptr`
  counted as the clause for the identity check") covers rule 4 without
  touching established text, per the minimal-diff instinct and to avoid
  disturbing a paragraph outside this task's stated scope.
- Confirmed both files remain valid UTF-8 (`iconv -f utf-8 -t utf-8`) and
  that no paragraph in the reference's addition accidentally spans
  multiple lines (checked via `awk`/`cat -A` on the new line range) —
  the reference's single-line-paragraph convention is preserved; the
  cookbook keeps its own normal-width-wrapped convention.

## Concerns

- None blocking. One minor judgment call: the reference's worked example
  cites `GetResource('PLUG', 128)` only in a comment rather than as a
  compiling declaration, since `GetResource` isn't in the `toolbox/*.cla`
  catalog yet. This matches the spec's own example precisely and avoids
  inventing a declaration outside this task's scope; a future phase
  adding a Resource Manager catalog file could tighten this to a fully
  compiling snippet.
