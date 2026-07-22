# clarusc v1 Design (check-only)

**Date:** 2026-07-23
**Status:** Approved design, pre-implementation
**Context:** First step of the self-hosting track (docs/ROADMAP.md). clarusc
is the Clarus compiler written in Clarus. v1 is the front half only; codegen
and the bootstrap chain are v2.

## 1. Identity and scope

`clarusc` lexes, parses, and typechecks `.cla` programs, printing diagnostics
**byte-identical** to the Go compiler's `clarus check` and exiting 0/1
identically. It runs on the host, built by the Go toolchain (`clarus build`).
clarusc is written in the full current language — the conservative-subset
rule (ROADMAP) begins only after self-hosting.

Out of scope for v1: C emission, the bootstrap chain, the C snapshot, the
Mac GUI shell, performance work beyond "the differential suite completes in
sensible time." clarusc's own source is IN the check corpus (it must check
itself clean) but cannot compile itself until v2.

## 2. Language precursors (implemented in the GO compiler first, with
reference updates, before clarusc consumes them)

- **`include` declarations.** `include "file.cla"` at top level: the named
  file's declarations enter the program at the include site (inclusion is
  concatenation, preserving single-pass declare-before-use). Include-once:
  a file is processed at its first include site program-wide; subsequent
  includes of the same file (by cleaned absolute path) are silent no-ops —
  diamonds work, true cycles are harmless. Paths are relative to the
  including file. No search paths, no conditionals. `include` is a
  contextual keyword (top-level position only). Diagnostics keep per-file
  positions. Reference: Ch1 (program structure) + Appendix A.
- **Identifier/length cap.** Identifiers and string literals longer than
  255 bytes are a compile error (they must fit `string(255)` in a
  self-hosted compiler). Reference Ch2 gains one sentence; the Go lexer
  enforces it with a test. Removes a latent parity divergence.
- **`clarus run prog.cla -- args…`.** Everything after `--` passes to the
  built program's argv (reaches `App.startCLI`). Needed to exercise clarusc
  without separate build steps.

## 3. Module layout

Ordered `.cla` files stitched by `include` from the entry file; the order
is the dependency graph, enforced by declare-before-use:

```
clarusc/main.cla    — includes the rest in order; startCLI driver
clarusc/lib.cla     — string helpers: intern pool, number→string,
                      string→number, char classification
clarusc/tok.cla     — token-kind enum, keyword table (data), token record
clarusc/lex.cla     — lexer: source text → token arena
clarusc/ast.cla     — Expr/Stmt/Decl arena records, node-kind enums,
                      accessor functions
clarusc/parse.cla   — recursive descent, fail-fast per file
clarusc/types.cla   — TypeInfo arena, singletons, assignability rules
clarusc/check.cla   — declaration walk, expression/statement checking,
                      UI surface, the events table (data)
```

`clarusc check FILE...` is the CLI (files after the subcommand, argv via
`App.startCLI`). The future Mac version replaces main.cla with a GUI shell;
all other files are shared.

## 4. Data structures (the arena idiom)

Clarus has no recursive types; clarusc uses index-linked arenas:

- **Typed arenas + accessors** (decided): `list of ExprNode`,
  `list of StmtNode`, `list of DeclNode`, `list of Token`, `list of
  TypeInfo`, with `int` indices, `-1` as nil. Category confusion (a stmt
  index used as an expr index) is prevented by the type split; readability
  comes from thin accessor functions (`binLeft(i)`, `ifCond(i)`) — all
  field access goes through them.
- Node records are fixed-size and small (target 40–60 bytes): kind enum,
  3–4 generic child/link indices, a `next` sibling link for variable-arity
  sequences (stmt lists, args, params, cases), an interned-name index, an
  int payload (literal value / operator code), line, col.
- **String interning:** one global pool — `var strPool: list of string`
  plus `var strIndex: map of int` (pool index by string) — every
  identifier and string literal interned once; all records store pool
  indices. The pool is also the natural place the 255-byte cap bites.
- **Types:** a TypeInfo arena mirroring the Go checker's shape (kind,
  elem index, name index, capacity), singletons pre-seeded at startup;
  record fields and enum members in parallel arenas referenced by range
  (first index + count).

## 5. Diagnostics and parity

- Pipeline behavior mirrors the Go compiler exactly: lexer accumulates
  diagnostics; parser fails fast (first syntax error ends that file);
  checker accumulates; declare-before-use single walk.
- Output: `path:line:col: message` lines on **stdout via `alert`**
  (matching `clarus check`'s stdout contract), usage errors via `log` to
  stderr, `quit 1` if any diagnostic else `quit 0`.
- **Byte-exact parity is the contract** (decided): same diagnostics, same
  order, same text, same positions, same exit codes, over the entire
  corpus. The Go compiler's diagnostic wording is normative; the plan
  includes building a diagnostics inventory (extracted from the Go source)
  as the transcription checklist, which doubles as the coverage checklist.
- Positions are tracked as line/col during lexing (no offset→line pass).

## 6. Differential testing

Go-side harness `internal/selfhost/differential_test.go`:

1. Build clarusc once per test run via `build.Build` (its own entry file).
2. Corpus, glob-driven so new fixtures join automatically: every reference
   fence (via `internal/reftest`'s extractor — ALL fences, not just the
   manifest: for excluded fragments both compilers must produce the SAME
   diagnostics), `testdata/valid/*.cla`, `testdata/errors/*.cla`,
   `testdata/run/*.cla`, `testdata/runerr/*.cla`, and clarusc itself —
   one corpus entry checking `clarusc/main.cla` (the include graph pulls
   in the rest; individual clarusc files are fragments and are not
   checked standalone).
3. For each corpus entry: run `clarus check` and the built clarusc; diff
   stdout byte-for-byte and compare exit codes. Any difference fails with
   the diff.
4. Plus targeted fixtures for underrepresented cases (every diagnostic in
   the inventory exercised at least once; deep nesting; long-but-legal
   identifiers at the 255 boundary; include diamonds).

## 7. Error handling inside clarusc

clarusc is an ordinary Clarus program: runtime errors (index out of range
etc.) in clarusc itself are clarusc bugs and surface as the host runtime's
`runtime error:` panics — the differential harness treats a nonzero-exit-3
crash as failure. Internal capacity limits (arena sizes) are unbounded
(lists grow); the only fixed caps are the language's own (string 255).

## 8. Risks / accepted costs

- **Two implementations to keep in sync** until v2 retires nothing (both
  evolve together; byte-exact parity is the sync mechanism, and language
  changes now cost two edits — accepted while the language is stabilizing).
- **Arena code is unfamiliar** relative to pointer ASTs — mitigated by
  accessors and by being the pattern the reference's own worked examples
  will never show (clarusc is deliberately not a style template for app
  code).
- **The Go compiler's diagnostics were never designed as a stable API** —
  byte-exact parity freezes them; deliberate rewording becomes a
  two-compiler, corpus-regenerating change. Accepted: stability here is a
  feature during self-hosting.
