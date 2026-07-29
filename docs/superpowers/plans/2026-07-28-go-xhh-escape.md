# Go Compiler \xHH Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Backport the `\xHH` string/char escape (added to clarusc on the ui-visual-fixes branch) to the frozen Go reference compiler — a deliberate, owner-directed, one-feature exception to the freeze — so the differential corpus and reference fences regain full-language coverage.

**Architecture:** One `case 'x'` in `internal/lexer`'s `decodeEscape`, mirroring clarusc's semantics byte-for-byte (exactly two hex digits, case-insensitive, no C-style maximal munch). Then revert the fence workaround: Appendix C's listing goes back to `"Add\xC9"` and a differential fixture pins go-vs-clarusc parity on the escape forever.

**Tech Stack:** Go (internal/lexer), Clarus corpus fixtures, markdown reference.

## Global Constraints

- **This exception is exactly one feature.** No other change to Go compiler behavior: no new diagnostics wording, no other escapes, no refactoring. The freeze stays in force otherwise; the exception gets recorded in ROADMAP.md.
- Semantics must match clarusc's `lexDecodeEscape` (clarusc/lex.cla:~400,436-443) exactly: after `\x`, require BOTH next bytes present and hex (`0-9a-fA-F`); decoded byte = hi*16+lo; consume exactly two; anything else (one digit, EOF, non-hex) falls through to the existing invalid-escape path unchanged.
- clarusc is NOT touched; `clarusc/clarusc.c` snapshot must be byte-identical after this branch (`git diff` empty for clarusc/).
- Host gate after every task: `go build -o clarus ./cmd/clarus && go test ./...`.
- Branch `go-xhh-escape` off main; merge only on request.
- The Mac gate is NOT needed (no runtime or emitted-code change); do not run it.

## File Structure

- `internal/lexer/lexer.go` — `decodeEscape` gains `case 'x'` (Task 1)
- `internal/lexer/lexer_test.go` — unit tests (Task 1)
- `testdata/valid/` — new small fixture using `\xHH` in char + string literals, swept by whichever harness differential-checks the valid corpus against both compilers (Task 1)
- `docs/clarus-language-reference.md` — Appendix C listing back to `"Add\xC9"`; prose note updated (Task 2)
- `docs/ROADMAP.md` — freeze-exception record (Task 2)

---

### Task 0: Branch setup

- [ ] **Step 1:** `git checkout -b go-xhh-escape main`. No commit.

---

### Task 1: `\xHH` in the Go lexer + parity fixture

**Files:**
- Modify: `internal/lexer/lexer.go` (`decodeEscape`, ~line 239)
- Modify: `internal/lexer/lexer_test.go`
- Create: `testdata/valid/xhh_escapes.cla` (name it to match sibling fixtures' conventions — check the directory first)

**Interfaces:**
- Produces: Go compiler accepts `\xHH` identically to clarusc. Task 2 depends on this (fences).

**Background:** `decodeEscape(quote byte) (byte, bool)` at internal/lexer/lexer.go:239 — `l.off` points just past the backslash; each case consumes what it matches and returns the byte. Hex-digit helpers: check the file for existing ones from hex int literals (`0x1F` is supported) and reuse; if none are exported to this scope, a tiny local `isHexDigit(byte) bool` + `hexVal(byte) byte` pair inside lexer.go is fine.

- [ ] **Step 1: Write the failing unit tests.** In `lexer_test.go`, following the file's existing test style (look at the neighboring escape/charlit tests around line 240 first):

```go
func TestHexEscapes(t *testing.T) {
	// Semantics pinned to clarusc's lexDecodeEscape: exactly two hex
	// digits, case-insensitive, no maximal munch.
	toks, diags := lexAll(t, `x = '\x41'`) // helper: mirror how sibling tests lex a line
	// expect CHARLIT IntVal 65, no diags
	toks2, diags2 := lexAll(t, `y = '\xc9'`)
	// expect CHARLIT IntVal 201, no diags
	toks3, diags3 := lexAll(t, `s = "A\x42C"`)
	// expect STRINGLIT text "ABC", no diags
	_ = toks; _ = diags; _ = toks2; _ = diags2; _ = toks3; _ = diags3
}

func TestHexEscapeInvalid(t *testing.T) {
	// One digit, then non-hex: NOT decoded (no maximal munch, no partial):
	// '\x4' and '\xZ9' both take the existing invalid-escape path.
	// Assert the same diagnostic the existing bad-escape test at ~line 244
	// asserts ("invalid escape sequence") for the char-literal cases, and
	// whatever the string path's existing bad-escape behavior is for
	// "A\xZZ" (match current behavior — do NOT change string-path
	// diagnostics).
}
```

Adapt to the file's real helpers (there is an existing pattern near line 175-245 for lexing a snippet and asserting tokens/diags — copy it; the sketch above is the shape, the file's idiom governs). Cover: `\x41`→65, `\xc9`→201, uppercase `\xC9`→201, string `"A\x42C"`→`ABC`, invalid `'\xZ9'`, `'\x4'` (single trailing digit), `'\x'` at end.

- [ ] **Step 2: Run to verify failure.** `go test ./internal/lexer -run 'TestHexEscape' -v` — FAIL (invalid escape today).

- [ ] **Step 3: Implement.** In `decodeEscape`, before the final `return 0, false`:

```go
	case 'x':
		// \xHH: exactly two hex digits, case-insensitive — byte-for-byte
		// the semantics of clarusc's lexDecodeEscape (no C-style maximal
		// munch). Backported 2026-07-28 as a deliberate one-feature
		// exception to the freeze (see ROADMAP) so the differential
		// corpus and reference fences cover the full language again.
		if l.off+1 < len(l.f.Content) && isHexDigit(l.f.Content[l.off]) && isHexDigit(l.f.Content[l.off+1]) {
			v := hexVal(l.f.Content[l.off])*16 + hexVal(l.f.Content[l.off+1])
			l.off += 2
			return v, true
		}
```

(Use the file's actual hex helpers if they exist; otherwise add the two tiny local functions.)

- [ ] **Step 4: Run the tests.** `go test ./internal/lexer -v` — all PASS, including every pre-existing test (especially the invalid-escape and hex-int-literal ones).

- [ ] **Step 5: Add the parity fixture.** First look at `testdata/valid/` siblings for naming/shape conventions and find which test harness sweeps this directory against BOTH compilers (grep `testdata/valid` under `internal/`). Then create a minimal fixture exercising: char escapes upper/lower hex, a string with embedded `\x` bytes including `\x00` and `\xff`, and adjacent-hex-after-escape (`"\x41B"` — proves no maximal munch). It must check clean under both compilers. Verify explicitly:

```sh
go run ./cmd/clarus check testdata/valid/xhh_escapes.cla        # exit 0, no output
cc -I internal/build/rt -o /tmp/clarusc_snap clarusc/clarusc.c internal/build/rt/rt.c
/tmp/clarusc_snap check testdata/valid/xhh_escapes.cla          # exit 0, no output
```

- [ ] **Step 6: Check for collateral expectations.** `LC_ALL=C grep -rn '\\\\x' testdata/diag/ internal/lexer/lexer_test.go clarusc/test/` — confirm no existing fixture expects `\x` to be rejected as invalid (if one does, STOP and report; do not silently change its golden).

- [ ] **Step 7: Full host gate.** `go build -o clarus ./cmd/clarus && go test ./...` — PASS, and `git status` shows clarusc/ untouched.

- [ ] **Step 8: Commit:** `lexer: \xHH escapes in the Go compiler -- one-feature freeze exception, semantics pinned to clarusc`

---

### Task 2: Un-work-around the fence + record the exception

**Files:**
- Modify: `docs/clarus-language-reference.md` (Appendix C listing ~line 1446 + the prose note ~line 1489 added by commit 12d6afa)
- Modify: `docs/ROADMAP.md`

**Interfaces:**
- Consumes: Task 1 (Go accepts `\xHH`, so fences may now contain it).

- [ ] **Step 1: Flip the appendix listing.** The caption line inside the Appendix C fence currently holds a raw UTF-8 ellipsis (bytes E2 80 A6) — that line is multibyte, so use perl, not the Edit tool:

```sh
perl -pi -e 's/Add\xE2\x80\xA6/Add\\xC9/' docs/clarus-language-reference.md
```

Verify with `LC_ALL=C git diff` that exactly that line changed, and `od -c` shows `A d d \ x C 9`.

- [ ] **Step 2: Update the prose note.** The sentence added by 12d6afa (just after that fence, ~line 1489) justifies the literal ellipsis by the frozen harness — now false. Replace it with one short sentence keeping only the still-true warning, e.g.: "Spell the ellipsis with the `\xC9` escape as shown — a literal `…` typed into a source file is UTF-8 and renders as three garbage glyphs on the Mac (Chapter 3)." Also grep the reference for any other claim that `\xHH` is clarusc-only and fix it if found.

- [ ] **Step 3: Record the exception in ROADMAP.md.** One entry, near wherever the freeze policy/process conventions live in that file (read it first): `\xHH` escapes backported to the Go compiler 2026-07-28 at Andrew's direction — spec-level lexical feature, deliberately excepted from the freeze so fences/corpus keep full coverage; the freeze remains in force for everything else.

- [ ] **Step 4: Full host gate.** `go build -o clarus ./cmd/clarus && go test ./...` — PASS. `internal/reftest` and `internal/selfhost` prove the fence now compiles under both compilers.

- [ ] **Step 5: Commit:** `docs: appendix caption back to \xC9 -- Go now lexes \xHH; roadmap records the freeze exception`
