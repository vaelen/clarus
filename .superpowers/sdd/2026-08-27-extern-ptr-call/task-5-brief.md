### Task 5: Documentation

**Files:**
- Modify: `docs/clarus-language-reference.md` (grammar production ~line 1774; new subsection inserted immediately before `### The \`word\` Extern Type`, line ~1849)
- Modify: `docs/clarus-toolbox-cookbook.md` (new recipe section)

**Interfaces:**
- Consumes: the approved spec (`docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md`) — the reference subsection is the spec's "Language surface" + "Rules" made normative, in the reference's own voice.

- [ ] **Step 1: Reference — grammar + subsection**

1. In the `externDecl` grammar block (~1774), extend the clause alternatives: `[ "=" ( "trap" ... | "inline" ( "deref" | "nop" | "a5" ) | "ptr" ) ]`.
2. Insert a `### The \`ptr\` Clause` subsection before `### The \`word\` Extern Type`, covering (in the reference's normative style, with worked code): first-param-is-target rule (must exist, must be `ptr`, consumed not pushed); remaining params/return marshal identically to the plain pascal `trap` clause (cross-reference the high-byte bool/char paragraph rather than restating it); no suffixes (`sel`/`reg`/etc. do not compose); redeclaration-merge rule applies unchanged; a `callback func` name is a valid target argument (it is an extern `ptr` parameter — the decay rule needs no new case); nil/garbage target is undefined behavior, the caller's contract; interrupt-time entry points are out of scope, mirroring `callback func`'s own paragraph. Worked example: the spec's GetResource → HLock → HandleToPtr → `PluginMain(code, 1, pb)` sequence, plus the "a calling contract, not a binding — same declaration, different pointer" sentence.

- [ ] **Step 2: Cookbook recipe**

Add a "Calling loaded code" section to `docs/clarus-toolbox-cookbook.md`: when to reach for `= ptr` (code resources, ProcPtrs you hold), the same worked example, and the two footguns (lock the handle for the lifetime of every call into it; declare one extern per distinct entry-point shape).

- [ ] **Step 3: Verify + commit**

Re-read both diffs against the spec's Rules list — every numbered rule must appear in the reference text.

```sh
git add docs/clarus-language-reference.md docs/clarus-toolbox-cookbook.md
git commit -m "docs: '= ptr' extern clause -- reference subsection + cookbook recipe"
```

---

