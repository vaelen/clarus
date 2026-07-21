# Clarus Compiler Front End Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Go program `clarus` whose `check` subcommand lexes, parses, and type-checks `.cla` sources against the language reference, printing `file:line:col: message` diagnostics — the front half of the compiler, host-tested with no Mac toolchain involved.

**Architecture:** Classic hand-written front end: newline-aware lexer → recursive-descent parser building a typed-position AST → two-pass-free, single-pass checker (declare-before-use makes one walk sufficient) with a symbol table and built-in tables for widgets/events/methods. Diagnostics accumulate; parsing stops at the first syntax error (single-pass honesty), checking reports all it can.

**Tech Stack:** Go ≥ 1.22, standard library only. No parser generators, no third-party deps.

## Global Constraints

- **Normative source of truth:** `docs/clarus-language-reference.md` — Appendix A (grammar), Chapter 2 (lexical rules), Chapter 3 (types), Chapters 4–6 (semantics), Appendix B (event signatures). Where this plan and the reference disagree, the reference wins; flag the conflict.
- Go module name `clarus`; binary `clarus`; layout under `cmd/` and `internal/` exactly as the Files blocks say.
- Standard library only. `gofmt`-clean. Table-driven tests.
- Diagnostic format exactly: `NAME.cla:LINE:COL: MESSAGE` (1-based line and column), one per line, to stdout; exit code 1 if any diagnostic, 0 otherwise.
- Both Appendix C worked examples (bookmark manager, text editor) must check clean by the end of Task 12 — they are permanent fixtures `testdata/valid/bookmarks.cla` and `testdata/valid/editor.cla`, copied **verbatim** from Appendix C.
- Hard keywords, contextual keywords, operators, and precedence exactly as reference Chapter 2 / Chapter 4: 7 levels; `|`/`^` at additive, `<<`/`>>`/`&` at multiplicative, `~` unary; `mod` is a word operator recognized in infix position (it is NOT a hard keyword — an identifier `mod` is legal elsewhere).
- Newline rule (Ch2): a newline ends a statement unless the previous significant token is an operator, comma, or opening bracket (`(`, `[`, `{`). `;` is a token accepted only as a property separator inside declaration blocks.
- The Retro68 toolchain (`/Users/andrew/repos/Retro68-build/toolchain`) is NOT used in this plan — it enters in Plan 4.

---

### Task 1: Module scaffold, source positions, diagnostics

**Files:**
- Create: `go.mod`, `internal/source/source.go`
- Test: `internal/source/source_test.go`

**Interfaces:**
- Produces: `source.File{Name string, Content []byte}`, `source.Pos{Offset int}` (byte offset), `(*File).LineCol(Pos) (line, col int)` 1-based, `source.Diag{File *File, Pos Pos, Msg string}`, `(Diag).String() string` → `name:line:col: msg`, `source.Load(path string) (*File, error)`.

- [ ] **Step 1: Init module and write the failing test**

```bash
cd /Users/andrew/repos/clarus && go mod init clarus
```

```go
// internal/source/source_test.go
package source

import "testing"

func TestLineCol(t *testing.T) {
	f := &File{Name: "t.cla", Content: []byte("ab\ncd\n")}
	cases := []struct{ off, line, col int }{
		{0, 1, 1}, {1, 1, 2}, {2, 1, 3}, // newline itself is col 3 of line 1
		{3, 2, 1}, {5, 2, 3},
	}
	for _, c := range cases {
		l, co := f.LineCol(Pos{c.off})
		if l != c.line || co != c.col {
			t.Errorf("off %d: got %d:%d want %d:%d", c.off, l, co, c.line, c.col)
		}
	}
}

func TestDiagString(t *testing.T) {
	f := &File{Name: "t.cla", Content: []byte("x\n")}
	d := Diag{File: f, Pos: Pos{0}, Msg: "boom"}
	if got := d.String(); got != "t.cla:1:1: boom" {
		t.Errorf("got %q", got)
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/source/` → FAIL (undefined types).

- [ ] **Step 3: Implement**

```go
// internal/source/source.go
package source

import (
	"fmt"
	"os"
)

type Pos struct{ Offset int }

type File struct {
	Name    string
	Content []byte
}

func Load(path string) (*File, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return &File{Name: path, Content: b}, nil
}

func (f *File) LineCol(p Pos) (line, col int) {
	line, col = 1, 1
	for i := 0; i < p.Offset && i < len(f.Content); i++ {
		if f.Content[i] == '\n' {
			line++
			col = 1
		} else {
			col++
		}
	}
	return line, col
}

type Diag struct {
	File *File
	Pos  Pos
	Msg  string
}

func (d Diag) String() string {
	l, c := d.File.LineCol(d.Pos)
	return fmt.Sprintf("%s:%d:%d: %s", d.File.Name, l, c, d.Msg)
}
```

- [ ] **Step 4: Run to verify pass** — `go test ./internal/source/` → ok.
- [ ] **Step 5: Commit** — `git add -A && git commit -m "feat: source positions and diagnostics"`

---

### Task 2: Token kinds and keyword tables

**Files:**
- Create: `internal/token/token.go`
- Test: `internal/token/token_test.go`

**Interfaces:**
- Produces: `token.Kind` (int enum), constants exactly: `EOF, NEWLINE, SEMI, IDENT, INT, FIXEDLIT, CHARLIT, STRINGLIT`, keywords `KwVar, KwFunc, KwRecord, KwEnum, KwWindow, KwMenu, KwExtend, KwOn, KwEvery, KwIf, KwElse, KwWhile, KwFor, KwIn, KwTo, KwReturn, KwAnd, KwOr, KwNot, KwTrue, KwFalse, KwNil, KwOpen, KwClose, KwEdit, KwNew, KwQuit, KwCancel`, punctuation `LPAREN, RPAREN, LBRACE, RBRACE, LBRACKET, RBRACKET, COMMA, COLON, DOT`, operators `ASSIGN, EQ, NE, LT, LE, GT, GE, PLUS, MINUS, STAR, SLASH, SHL, SHR, AMP, PIPE, CARET, TILDE`.
- Produces: `token.Token{Kind Kind, Pos source.Pos, Text string, IntVal int64, FixVal int32}` (FixVal = 16.16 raw), `token.Keywords map[string]Kind` (the 28 hard keywords), `(Kind).String() string` for diagnostics.

- [ ] **Step 1: Write the failing test**

```go
// internal/token/token_test.go
package token

import "testing"

func TestKeywords(t *testing.T) {
	hard := []string{"var", "func", "record", "enum", "window", "menu", "extend",
		"on", "every", "if", "else", "while", "for", "in", "to", "return",
		"and", "or", "not", "true", "false", "nil",
		"open", "close", "edit", "new", "quit", "cancel"}
	if len(Keywords) != len(hard) {
		t.Fatalf("Keywords has %d entries, want %d", len(Keywords), len(hard))
	}
	for _, w := range hard {
		if _, ok := Keywords[w]; !ok {
			t.Errorf("missing hard keyword %q", w)
		}
	}
	// contextual words must NOT be keywords
	for _, w := range []string{"mod", "string", "int", "list", "map", "of", "ticks", "form", "item", "standard"} {
		if _, ok := Keywords[w]; ok {
			t.Errorf("%q must not be a hard keyword", w)
		}
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/token/` → FAIL.
- [ ] **Step 3: Implement** — the `Kind` const block (order as in Interfaces), `Token` struct, `Keywords` map literal with exactly the 28 hard keywords listed in the test (note: the test list has 28 entries; `window` appears once), and a `String()` method via a `[...]string` name table (used in parser errors, e.g. `"'{'"` for LBRACE, `"identifier"` for IDENT).
- [ ] **Step 4: Run to verify pass** — `go test ./internal/token/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: token kinds and keyword tables"`

---

### Task 3: Lexer

**Files:**
- Create: `internal/lexer/lexer.go`
- Test: `internal/lexer/lexer_test.go`

**Interfaces:**
- Consumes: `source.File`, `token` package.
- Produces: `lexer.New(f *source.File) *Lexer`, `(*Lexer).Next() token.Token` (streaming; returns EOF forever at end), `(*Lexer).Diags() []source.Diag`.

Behavior (normative, from reference Ch2):
- `//` comment to end of line. Whitespace: space, tab, CR (CR is whitespace on the host; `\n` drives the newline rule).
- **Newline rule:** on `\n`, emit a `NEWLINE` token UNLESS the previously emitted significant token is one of: any operator kind (`ASSIGN…TILDE`), `COMMA`, `LPAREN`, `LBRACKET`, `LBRACE`, `COLON`, or there is no previous token yet, or the previous token is already `NEWLINE`/`SEMI` (collapse runs). (`COLON` continues because property values follow `name:` and multi-line property lists are declaration-block context; this matches every example in the reference.)
- Numbers: decimal `INT`; `0x`/`0X` hex `INT`; `digits.digits` → `FIXEDLIT` with `FixVal = int32(round(v * 65536))`. A leading `-` is NOT part of the literal (unary operator).
- `CHARLIT`: `'A'`, escapes `\'`? — reference lists `\"` `\\` `\n` `\t` for strings and "same escapes" for chars; accept `\'` inside char literals as the quote-escape analog, plus `\\`, `\n` (value 13 — CR, the Mac newline), `\t` (9). Value stored in `IntVal` (0–255).
- `STRINGLIT`: `"…"` with escapes `\"` `\\` `\n` (emits byte 13) `\t`. Text stores the DECODED bytes. Unterminated string/char at end of line → diagnostic `unterminated string literal` / `unterminated character literal`.
- Identifiers: letter then letters/digits/underscores; looked up in `token.Keywords`, else `IDENT`.
- Operators: longest-match — `<<` `>>` `<=` `>=` `==` `!=` before `<` `>` `=`; bare `!` is a diagnostic `unexpected character '!'` (there is no `!` operator; `not` is the negation).
- Unknown byte → diagnostic `unexpected character 'X'`, skip it.

- [ ] **Step 1: Write the failing test**

```go
// internal/lexer/lexer_test.go
package lexer

import (
	"clarus/internal/source"
	"clarus/internal/token"
	"testing"
)

func kinds(src string) []token.Kind {
	l := New(&source.File{Name: "t.cla", Content: []byte(src)})
	var out []token.Kind
	for {
		tk := l.Next()
		out = append(out, tk.Kind)
		if tk.Kind == token.EOF {
			return out
		}
	}
}

func TestNewlineRule(t *testing.T) {
	cases := []struct {
		src  string
		want []token.Kind
	}{
		{"x = 1\ny = 2\n", []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE,
			token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}},
		// line ends in operator → continuation, no NEWLINE
		{"x = 1 +\n2\n", []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.PLUS,
			token.INT, token.NEWLINE, token.EOF}},
		// comma and open bracket continue
		{"f(a,\nb)\n", []token.Kind{token.IDENT, token.LPAREN, token.IDENT, token.COMMA,
			token.IDENT, token.RPAREN, token.NEWLINE, token.EOF}},
		// blank lines collapse
		{"x\n\n\ny\n", []token.Kind{token.IDENT, token.NEWLINE, token.IDENT, token.NEWLINE, token.EOF}},
		// comment stripped, newline still applies
		{"x // hi\ny\n", []token.Kind{token.IDENT, token.NEWLINE, token.IDENT, token.NEWLINE, token.EOF}},
	}
	for _, c := range cases {
		got := kinds(c.src)
		if len(got) != len(c.want) {
			t.Errorf("%q: got %v want %v", c.src, got, c.want)
			continue
		}
		for i := range got {
			if got[i] != c.want[i] {
				t.Errorf("%q: token %d got %v want %v", c.src, i, got[i], c.want[i])
			}
		}
	}
}

func TestLiterals(t *testing.T) {
	l := New(&source.File{Name: "t.cla", Content: []byte(`x = 0x1F` + "\n" + `f = 1.5` + "\n" + `c = '\n'` + "\n" + `s = "a\tb"` + "\n")})
	var toks []token.Token
	for {
		tk := l.Next()
		toks = append(toks, tk)
		if tk.Kind == token.EOF {
			break
		}
	}
	// x = 0x1F
	if toks[2].Kind != token.INT || toks[2].IntVal != 31 {
		t.Errorf("hex: got %v %d", toks[2].Kind, toks[2].IntVal)
	}
	// f = 1.5 → 1.5 * 65536 = 98304
	if toks[6].Kind != token.FIXEDLIT || toks[6].FixVal != 98304 {
		t.Errorf("fixed: got %v %d", toks[6].Kind, toks[6].FixVal)
	}
	// c = '\n' → CR = 13
	if toks[10].Kind != token.CHARLIT || toks[10].IntVal != 13 {
		t.Errorf("char: got %v %d", toks[10].Kind, toks[10].IntVal)
	}
	// s = "a\tb" → decoded bytes a, 9, b
	if toks[14].Kind != token.STRINGLIT || toks[14].Text != "a\tb" {
		t.Errorf("string: got %v %q", toks[14].Kind, toks[14].Text)
	}
}

func TestOperatorsLongestMatch(t *testing.T) {
	want := []token.Kind{token.IDENT, token.SHL, token.INT, token.PIPE, token.INT,
		token.NEWLINE, token.EOF}
	got := kinds("x << 8 | 4\n")
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("token %d: got %v want %v", i, got[i], want[i])
		}
	}
}

func TestKeywordVsIdent(t *testing.T) {
	got := kinds("var mod: int\n") // mod and int are NOT hard keywords
	want := []token.Kind{token.KwVar, token.IDENT, token.COLON, token.IDENT, token.NEWLINE, token.EOF}
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("token %d: got %v want %v", i, got[i], want[i])
		}
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/lexer/` → FAIL.
- [ ] **Step 3: Implement** `lexer.go`: a struct holding `f *source.File, off int, prev token.Kind, havePrev bool, diags []source.Diag`. `Next()` skips spaces/tabs/CR and comments; on `\n` decides via the rule above (operator kinds are `k >= token.ASSIGN && k <= token.TILDE`, plus `COMMA, LPAREN, LBRACKET, LBRACE, COLON`); scans literals and operators per the Behavior block. Every emitted token records `Pos` at its first byte. Set `prev` only for significant (non-skipped) tokens.
- [ ] **Step 4: Run to verify pass** — `go test ./internal/lexer/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: newline-aware lexer"`

---

### Task 4: AST definitions

**Files:**
- Create: `internal/ast/ast.go`
- Test: none (pure data; exercised by parser tests from Task 5 on)

**Interfaces (complete node inventory — later tasks use these exact names):**

```go
// internal/ast/ast.go
package ast

import "clarus/internal/source"

type File struct{ Decls []Decl }

type Decl interface{ declNode() }
type Stmt interface{ stmtNode() }
type Expr interface {
	exprNode()
	Pos() source.Pos
}

// ---- types as written in source ----
type TypeExpr interface{ typeNode() }
type NamedType struct {
	P    source.Pos
	Name string // "int", "bool", "fixed", "char", "text", user record/enum/window name
}
type StringType struct { P source.Pos; N int }        // string / string(63); N=255 for bare
type ListType struct { P source.Pos; Elem TypeExpr }
type MapType struct { P source.Pos; Val TypeExpr }
type ArrayType struct { P source.Pos; Elem TypeExpr; N int }

// ---- declarations ----
type Field struct { P source.Pos; Name string; Type TypeExpr; Default Expr } // Default may be nil
type RecordDecl struct { P source.Pos; Name string; Fields []Field }
type EnumMember struct { P source.Pos; Name string; HasValue bool; Value int64; Label string }
type EnumDecl struct { P source.Pos; Name string; Members []EnumMember }
type VarDecl struct { P source.Pos; Name string; Type TypeExpr; Init Expr } // also a Stmt
type Param struct { P source.Pos; Name string; Type TypeExpr }
type FuncDecl struct { P source.Pos; Name string; Params []Param; Ret TypeExpr; Body *Block }
type WindowDecl struct { P source.Pos; Name string; Items []WindowItem }
type MenuDecl struct { P source.Pos; Name string; Entries []MenuEntry }
type ExtendDecl struct { P source.Pos; Target string; Handlers []*HandlerDecl; Nested []*ExtendDecl }
type HandlerDecl struct { P source.Pos; Path []string; Params []Param; Body *Block } // "on a.b.c(params)"
type EveryDecl struct { P source.Pos; Ticks int64; Body *Block }

// ---- window body items ----
type WindowItem interface{ windowItemNode() }
type Property struct { P source.Pos; Name string; Values []Expr } // title: "x" / size: 400, 300 / resizable / resizable: min(300,200) — min(...) arrives as a Call expr
type Column struct { P source.Pos; Header string; Shows string; WidthPx int; WidthFill bool }
type FormFor struct { P source.Pos; Record string }
type Widget struct { P source.Pos; Kind, Name string; Props []WindowItem } // Props: Property or Column
type MenuEntry struct { P source.Pos; IsItem bool; Name, Caption, Key string; IsSeparator, IsStandardEdit bool }

// ---- statements ----
type Block struct { P source.Pos; Vars []*VarDecl; Stmts []Stmt } // vars-at-top enforced by parser
type AssignStmt struct { P source.Pos; LHS, RHS Expr }
type ExprStmt struct { P source.Pos; X Expr } // call statements
type IfStmt struct { P source.Pos; Cond Expr; Then *Block; Else Stmt } // Else: *IfStmt, *Block, or nil
type WhileStmt struct { P source.Pos; Cond Expr; Body *Block }
type ForStmt struct { P source.Pos; V1, V2 string; Seq Expr; ToExpr Expr; Body *Block } // V2=="" unless map form; ToExpr!=nil for ranges
type ReturnStmt struct { P source.Pos; X Expr } // X may be nil
type QuitStmt struct{ P source.Pos }
type CancelStmt struct{ P source.Pos }
type OpenStmt struct { P source.Pos; Window string }
type CloseStmt struct { P source.Pos; X Expr }
type EditStmt struct { P source.Pos; Form string; Target Expr; IsNew bool; NewType string }

// ---- expressions ----
type Ident struct { P source.Pos; Name string }
type IntLit struct { P source.Pos; Val int64 }
type FixedLit struct { P source.Pos; Raw int32 }
type CharLit struct { P source.Pos; Val byte }
type StringLit struct { P source.Pos; Val string }
type BoolLit struct { P source.Pos; Val bool }
type NilLit struct{ P source.Pos }
type WindowSelf struct{ P source.Pos } // the `window` keyword in expression position
type Unary struct { P source.Pos; Op string; X Expr }            // "-", "not", "~"
type Binary struct { P source.Pos; Op string; X, Y Expr }        // "+","-","*","/","mod","<<",">>","&","|","^","==","!=","<","<=",">",">=","and","or"
type Call struct { P source.Pos; Fn Expr; Args []Expr; AppleTalk bool } // AppleTalk: first arg had `appletalk` prefix
type Index struct { P source.Pos; X, I Expr }
type Select struct { P source.Pos; X Expr; Name string }
type NewExpr struct { P source.Pos; Type string }
type OpenExpr struct { P source.Pos; Window string }
```

Every node gets the trivial marker method (`declNode`, `stmtNode`, `exprNode` returning nothing, `Pos() source.Pos` returning `P`) — write them all mechanically at the bottom of the file.

- [ ] **Step 1: Write the file exactly as above** (plus marker methods).
- [ ] **Step 2: Verify it compiles** — `go build ./...` → ok.
- [ ] **Step 3: Commit** — `git commit -am "feat: AST node definitions"`

---

### Task 5: Parser core + expressions

**Files:**
- Create: `internal/parser/parser.go`, `internal/parser/expr.go`
- Test: `internal/parser/expr_test.go`

**Interfaces:**
- Produces: `parser.Parse(f *source.File) (*ast.File, []source.Diag)` (fails fast: first syntax error stops parsing), and internal `(*parser).parseExpr() ast.Expr` used by every later parsing task.
- Parser infra: `p.tok` current token, `p.next()`, `p.expect(k token.Kind) token.Token` (diagnostic `expected X, found Y` and aborts via panic/recover to the fail-fast top level), `p.skipNewlines()`.

Expression grammar is reference Appendix A verbatim. Precedence-climbing structure: `parseExpr` (or) → `parseAnd` → `parseCmp` (non-chaining: at most one cmpOp) → `parseAdd` (`+ - | ^`) → `parseMul` (`* / mod << >> &`; `mod` = IDENT with text "mod" in operator position) → `parseUnary` (`- not ~`) → `parsePostfix` (`.memberName` where memberName is IDENT or `open`/`close` keywords; `[expr]`; `(args)` with optional `appletalk` prefix before a call's first argument) → `parsePrimary` (INT, FIXEDLIT, CHARLIT, STRINGLIT, `true`, `false`, `nil`, `window`, IDENT, `new` IDENT, `open` IDENT, `(expr)`).

- [ ] **Step 1: Write the failing test**

```go
// internal/parser/expr_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

// parse a whole file consisting of one global: var x: int = <expr>
func parseInit(t *testing.T, expr string) ast.Expr {
	t.Helper()
	src := "var x: int = " + expr + "\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("%s: unexpected diags: %v", expr, diags[0])
	}
	return f.Decls[0].(*ast.VarDecl).Init
}

func TestPrecedence(t *testing.T) {
	// (flags & 0x08) != 0 — & binds tighter than !=
	e := parseInit(t, "flags & 0x08 != 0")
	b, ok := e.(*ast.Binary)
	if !ok || b.Op != "!=" {
		t.Fatalf("root should be !=, got %#v", e)
	}
	if inner, ok := b.X.(*ast.Binary); !ok || inner.Op != "&" {
		t.Fatalf("left of != should be &, got %#v", b.X)
	}
	// (3 << 8) | 42
	e = parseInit(t, "3 << 8 | 42")
	b = e.(*ast.Binary)
	if b.Op != "|" {
		t.Fatalf("root should be |, got %q", b.Op)
	}
	// a + b * c — * tighter
	e = parseInit(t, "a + b * c")
	if b = e.(*ast.Binary); b.Op != "+" {
		t.Fatalf("root should be +")
	}
	// mod as operator
	e = parseInit(t, "a mod 3")
	if b = e.(*ast.Binary); b.Op != "mod" {
		t.Fatalf("mod: got %q", b.Op)
	}
}

func TestComparisonNoChain(t *testing.T) {
	src := "var x: bool = a < b < c\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 {
		t.Fatal("a < b < c must be a syntax error (comparisons do not chain)")
	}
}

func TestPostfixAndPrimary(t *testing.T) {
	e := parseInit(t, "conn.open(addr)") // open allowed as member name
	c := e.(*ast.Call)
	sel := c.Fn.(*ast.Select)
	if sel.Name != "open" {
		t.Fatalf("member: got %q", sel.Name)
	}
	e = parseInit(t, "bookmarks[i].url")
	if s, ok := e.(*ast.Select); !ok || s.Name != "url" {
		t.Fatalf("index-then-select: %#v", e)
	}
	e = parseInit(t, "not save(window)")
	u := e.(*ast.Unary)
	if u.Op != "not" {
		t.Fatal("unary not")
	}
	if _, ok := u.X.(*ast.Call).Args[0].(*ast.WindowSelf); !ok {
		t.Fatal("window keyword as argument")
	}
	e = parseInit(t, `c.open(appletalk "Mac:Srv")`)
	if !e.(*ast.Call).AppleTalk {
		t.Fatal("appletalk prefix flag")
	}
	e = parseInit(t, "new Bookmark")
	if e.(*ast.NewExpr).Type != "Bookmark" {
		t.Fatal("new expr")
	}
	e = parseInit(t, "open Doc")
	if e.(*ast.OpenExpr).Window != "Doc" {
		t.Fatal("open expr")
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/parser/` → FAIL.
- [ ] **Step 3: Implement** `parser.go` (infra: token buffer over `lexer`, `expect`, fail-fast via `panic(parseAbort{})` recovered in `Parse`; `Parse` loops `parseTopDecl` — for THIS task only `var` declarations are wired: `parseVarDecl`, so the test harness works; other declarations panic `expected declaration` and get wired in Tasks 7–8) and `expr.go` (the precedence-climbing chain exactly as the Interfaces block lays out; `parseCmp` parses one optional cmpOp then, if another cmpOp follows, emits `comparisons do not chain` and aborts).
- [ ] **Step 4: Run to verify pass** — `go test ./internal/parser/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: parser core and expressions"`

---

### Task 6: Statements and blocks

**Files:**
- Create: `internal/parser/stmt.go`
- Test: `internal/parser/stmt_test.go`

**Interfaces:**
- Produces: `(*parser).parseBlock() *ast.Block` — `{` NEWLINE? vars-first stmt list `}` — used by func/handler/every parsing. Statement forms per reference Ch5: var (top only — a `var` after a non-var statement is the diagnostic `variable declarations must appear at the top of the body`), assignment vs call statement (parse expr; if next is ASSIGN → assignment with LHS validated as lvalue — Ident/Select/Index chains only, else `cannot assign to this expression`; if expr is a Call → ExprStmt; else `expression is not a statement`), `if`/`else if`/`else`, `while`, `for x in e` / `for k, v in e` / `for i in a to b`, `return [expr]`, `quit`, `cancel`, `open IDENT`, `close expr`, `edit IDENT , (lvalue | new IDENT)`.

- [ ] **Step 1: Write the failing test**

```go
// internal/parser/stmt_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"strings"
	"testing"
)

func parseFunc(t *testing.T, body string) *ast.Block {
	t.Helper()
	src := "func f() {\n" + body + "\n}\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("unexpected diags: %v", diags[0])
	}
	return f.Decls[0].(*ast.FuncDecl).Body
}

func TestStatements(t *testing.T) {
	b := parseFunc(t, `
var i: int = 0
var done: bool

while i < 10 and not done {
    i = i + 1
}
if i == 10 {
    done = true
} else if i > 3 {
    done = false
} else {
    quit
}
for x in items {
    total = total + x
}
for k, v in scores {
    sum = sum + v
}
for j in 0 to 9 {
    sum = sum + j
}
return i`)
	if len(b.Vars) != 2 {
		t.Fatalf("want 2 vars, got %d", len(b.Vars))
	}
	if len(b.Stmts) != 6 {
		t.Fatalf("want 6 statements, got %d", len(b.Stmts))
	}
	fr := b.Stmts[4].(*ast.ForStmt)
	if fr.ToExpr == nil || fr.V1 != "j" {
		t.Fatal("range for")
	}
	fm := b.Stmts[3].(*ast.ForStmt)
	if fm.V2 != "v" {
		t.Fatal("map for")
	}
}

func TestVarAfterStmtRejected(t *testing.T) {
	src := "func f() {\nquit\nvar x: int\n}\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 || !strings.Contains(diags[0].Msg, "top of the body") {
		t.Fatalf("want var-at-top error, got %v", diags)
	}
}

func TestOpenCloseEdit(t *testing.T) {
	b := parseFunc(t, "open Doc\nclose d\nedit EditForm, bookmarks[i]\nedit EditForm, new Bookmark")
	if b.Stmts[0].(*ast.OpenStmt).Window != "Doc" {
		t.Fatal("open stmt")
	}
	e := b.Stmts[3].(*ast.EditStmt)
	if !e.IsNew || e.NewType != "Bookmark" {
		t.Fatal("edit new form")
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/parser/ -run 'Statements|VarAfter|OpenClose'` → FAIL.
- [ ] **Step 3: Implement** `stmt.go` per the Interfaces block; wire `parseFuncDecl` (name, params `IDENT: type` comma-separated, optional `: type` return, block) into `parseTopDecl`. Type parsing helper `parseType()` handles: `string` / `string(N)` (contextual by name), `list of`, `map of`, `IDENT`, and any of those followed by `[N]` → ArrayType.
- [ ] **Step 4: Run to verify pass** — `go test ./internal/parser/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: statement and function parsing"`

---

### Task 7: Record, enum, and type declarations

**Files:**
- Create: `internal/parser/decl.go`
- Test: `internal/parser/decl_test.go`

**Interfaces:**
- Produces: `parseRecordDecl` (`record IDENT { fields }`, field = `IDENT: type [= (literal|IDENT)]`, newline-separated), `parseEnumDecl` (`enum IDENT { members }`, member = `IDENT [INT|HEXINT] [STRING]`, separated by commas or newlines) — both wired into `parseTopDecl`.

- [ ] **Step 1: Write the failing test**

```go
// internal/parser/decl_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

func TestRecordDecl(t *testing.T) {
	src := `record Bookmark {
    name:     string(63)
    port:     int = 80
    protocol: Protocol
    tags:     char[4]
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	r := f.Decls[0].(*ast.RecordDecl)
	if len(r.Fields) != 4 {
		t.Fatalf("fields: %d", len(r.Fields))
	}
	if st := r.Fields[0].Type.(*ast.StringType); st.N != 63 {
		t.Fatal("string(63)")
	}
	if r.Fields[1].Default == nil {
		t.Fatal("default")
	}
	if at := r.Fields[3].Type.(*ast.ArrayType); at.N != 4 {
		t.Fatal("char[4]")
	}
}

func TestEnumDecl(t *testing.T) {
	src := `enum Foo {
    Bar  "Bar"
    Moof 0x10 "Dogcow"
    Next "The next thing"
}
enum Protocol { Gopher, HTTP, Telnet }
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	e := f.Decls[0].(*ast.EnumDecl)
	if len(e.Members) != 3 {
		t.Fatalf("members: %d", len(e.Members))
	}
	m := e.Members[1]
	if !m.HasValue || m.Value != 0x10 || m.Label != "Dogcow" {
		t.Fatalf("Moof: %+v", m)
	}
	if e.Members[0].HasValue || e.Members[0].Label != "Bar" {
		t.Fatal("Bar")
	}
	p := f.Decls[1].(*ast.EnumDecl)
	if len(p.Members) != 3 || p.Members[2].Name != "Telnet" {
		t.Fatal("comma-separated enum")
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/parser/ -run 'RecordDecl|EnumDecl'` → FAIL.
- [ ] **Step 3: Implement** `decl.go`. Enum member parsing: IDENT, then optional INT (that's the value), then optional STRINGLIT (that's the label), then optional COMMA; NEWLINEs separate as well.
- [ ] **Step 4: Run to verify pass** — ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: record and enum declaration parsing"`

---

### Task 8: Window, menu, extend, handler, every declarations

**Files:**
- Create: `internal/parser/ui.go`
- Test: `internal/parser/ui_test.go`

**Interfaces:**
- Produces: parsing for `windowDecl` (properties incl. bare flags and `min(...)` values, widget declarations for kinds `button field textview check popup table canvas label`, `column` clauses inside `table` widgets, `var` items, `form for IDENT`), `menuDecl` (`item IDENT STRING [key STRING]`, `separator`, `standard edit`), `extendDecl` (handlers + nested extends), top-level `on` handlers (`on a.b(params) { }` — path of 1–3 IDENTs where `App` etc. are just IDENTs), `every INT ticks { }`. Property parsing: inside a `{...}` declaration block, entries are separated by NEWLINE or SEMI; a property is `IDENT [: value {, value}]` where value = expr (so `min(300, 200)` is a Call expr, `fill`/`both`/`vertical` arrive as Ident exprs); the contextual words `form`, `item`, `separator`, `standard`, `column` are dispatched by name before generic property parsing.

- [ ] **Step 1: Write the failing test**

```go
// internal/parser/ui_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

func TestWindowDecl(t *testing.T) {
	src := `window Main {
    title: "Bookmarks"
    size: 420, 300
    resizable: min(300, 200)
    form for Bookmark

    table Marks {
        rows: bookmarks
        column "Name" shows name width 140
        column "URL"  shows url  width fill
    }
    button Add { at: 10, bottom; caption: "Add…"; default }

    var count: int = 0
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	w := f.Decls[0].(*ast.WindowDecl)
	var props, widgets, vars, forms int
	for _, it := range w.Items {
		switch it.(type) {
		case *ast.Property:
			props++
		case *ast.Widget:
			widgets++
		case *ast.VarDecl:
			vars++
		case *ast.FormFor:
			forms++
		}
	}
	if props != 3 || widgets != 2 || vars != 1 || forms != 1 {
		t.Fatalf("items: %d %d %d %d", props, widgets, vars, forms)
	}
	tbl := w.Items[4].(*ast.Widget)
	if tbl.Kind != "table" || tbl.Name != "Marks" {
		t.Fatal("table widget")
	}
	col := tbl.Props[1].(*ast.Column)
	if col.Header != "Name" || col.Shows != "name" || col.WidthPx != 140 || col.WidthFill {
		t.Fatalf("column: %+v", col)
	}
	col2 := tbl.Props[2].(*ast.Column)
	if !col2.WidthFill {
		t.Fatal("width fill")
	}
	btn := w.Items[5].(*ast.Widget)
	if len(btn.Props) != 3 { // at, caption, default (bare)
		t.Fatalf("button props: %d", len(btn.Props))
	}
}

func TestMenuAndExtend(t *testing.T) {
	src := `menu File {
    item New  "New"  key "N"
    separator
    item Quit "Quit" key "Q"
}
menu Edit { standard edit }

extend Doc {
    extend File {
        on Save.select { save(window) }
    }
    on closeRequest {
        cancel
    }
}

on App.startEmpty {
    open Doc
}

on conn.received(data: text) {
    process(data)
}

every 2 ticks {
    tick()
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	m := f.Decls[0].(*ast.MenuDecl)
	if len(m.Entries) != 3 || !m.Entries[1].IsSeparator || m.Entries[2].Key != "Q" {
		t.Fatalf("menu: %+v", m.Entries)
	}
	if !f.Decls[1].(*ast.MenuDecl).Entries[0].IsStandardEdit {
		t.Fatal("standard edit")
	}
	ex := f.Decls[2].(*ast.ExtendDecl)
	if ex.Target != "Doc" || len(ex.Nested) != 1 || len(ex.Handlers) != 1 {
		t.Fatal("extend nesting")
	}
	if ex.Nested[0].Handlers[0].Path[0] != "Save" {
		t.Fatal("nested handler path")
	}
	h := f.Decls[3].(*ast.HandlerDecl)
	if h.Path[0] != "App" || h.Path[1] != "startEmpty" {
		t.Fatal("App handler")
	}
	h2 := f.Decls[4].(*ast.HandlerDecl)
	if len(h2.Params) != 1 || h2.Params[0].Name != "data" {
		t.Fatal("handler params")
	}
	ev := f.Decls[5].(*ast.EveryDecl)
	if ev.Ticks != 2 {
		t.Fatal("every ticks")
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/parser/ -run 'WindowDecl|MenuAndExtend'` → FAIL.
- [ ] **Step 3: Implement** `ui.go` per the Interfaces block; wire `window`, `menu`, `extend`, `on`, `every` into `parseTopDecl`. `every` expects INT then IDENT with text `ticks` (else `expected 'ticks'`).
- [ ] **Step 4: Run to verify pass** — `go test ./internal/parser/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: window, menu, extend, handler, every parsing"`

---

### Task 9: Types package and symbol table

**Files:**
- Create: `internal/types/types.go`, `internal/check/scope.go`
- Test: `internal/types/types_test.go`

**Interfaces:**
- Produces `types` package:

```go
type Kind int
const (
	Invalid Kind = iota
	Int; Bool; Fixed; Char; String; Text; Enum; Record; Array; List; Map
	WindowRef; Connection; Listener; ServiceBrowser; Address; ErrorType; Void
)
type Type struct {
	Kind Kind
	N       int      // String: capacity; Array: length
	Elem    *Type    // Array/List elem, Map value
	Enum    *EnumInfo
	Record  *RecordInfo
	Window  *WindowInfo
}
type EnumInfo struct { Name string; Members []EnumMemberInfo } // MemberInfo{Name string; Value int; Label string}
type RecordInfo struct { Name string; Fields []FieldInfo }     // FieldInfo{Name string; Type *Type}
type WindowInfo struct { Name string; IsForm bool; FormRecord *RecordInfo; Widgets []WidgetInfo; Vars []FieldInfo } // WidgetInfo{Name, Kind string; Binds string}
```

- `types.AssignableTo(src, dst *Type) bool`: identical kinds; any `String` capacity assigns to any `String` capacity (runtime clamps); `StringLit`-driven cases handled in checker; enums/records/windows must be the same named info; `nil` handled in checker.
- `types.Equal(a, b *Type) bool`.
- Singletons `types.IntT, BoolT, FixedT, CharT, TextT, VoidT, AddressT, ErrT` and constructors `types.StringT(n)`, `types.ListT(e)`, `types.MapT(v)`, `types.ArrayT(e, n)`.
- The built-in `saveChoice` enum: `types.SaveChoice *Type` (EnumInfo Save=0, Discard=1 label "Don't Save", Cancel=2).
- `check/scope.go`: `Scope{parent *Scope, names map[string]Symbol}`, `Symbol{Name string, Type *types.Type, IsFunc bool, Func *FuncSig, IsType bool}` with `FuncSig{Params []*types.Type, Ret *types.Type}`; `Lookup` walks outward, `Declare` errors on duplicate in same scope (`redeclaration of X`).

- [ ] **Step 1: Write the failing test**

```go
// internal/types/types_test.go
package types

import "testing"

func TestAssignable(t *testing.T) {
	if !AssignableTo(StringT(255), StringT(63)) {
		t.Fatal("any string capacity assigns to any other (runtime clamps)")
	}
	if AssignableTo(IntT, FixedT) {
		t.Fatal("int is not assignable to fixed")
	}
	e1 := &Type{Kind: Enum, Enum: &EnumInfo{Name: "A"}}
	e2 := &Type{Kind: Enum, Enum: &EnumInfo{Name: "B"}}
	if AssignableTo(e1, e2) {
		t.Fatal("distinct enums do not assign")
	}
	if !AssignableTo(e1, e1) {
		t.Fatal("same enum assigns")
	}
	if !AssignableTo(ListT(IntT), ListT(IntT)) || AssignableTo(ListT(IntT), ListT(BoolT)) {
		t.Fatal("list elem types must match")
	}
}

func TestSaveChoice(t *testing.T) {
	if SaveChoice.Kind != Enum || len(SaveChoice.Enum.Members) != 3 {
		t.Fatal("saveChoice shape")
	}
	if SaveChoice.Enum.Members[1].Label != "Don't Save" {
		t.Fatal("Discard label")
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/types/` → FAIL.
- [ ] **Step 3: Implement** both files per the Interfaces block.
- [ ] **Step 4: Run to verify pass** — ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: type representations and scopes"`

---

### Task 10: Checker — declarations and expressions

**Files:**
- Create: `internal/check/check.go`, `internal/check/expr.go`, `internal/check/builtins.go`
- Test: `internal/check/check_test.go`

**Interfaces:**
- Produces: `check.File(f *source.File, tree *ast.File) []source.Diag` — the single public entry. Internal: `(*checker).checkExpr(e ast.Expr, expected *types.Type) *types.Type` (bidirectional where needed: `expected` resolves bare enum members and `nil`).
- `builtins.go` populates the universe scope: `alert(string)`, `askOpen(string): bool`, `askSave(string, string): bool`, `askSaveChanges(string): saveChoice`, the `file` namespace (`readText(string, text): bool`, `writeText(string, text): bool`, `save(string, any-record-ish): bool`, `load(string, any-record-ish): bool`, `name(string): string`), global `lastError: error` (record `{code: int, message: string}`), type name symbols (`connection`, `listener`, `serviceBrowser`, `address`, `error`, `saveChoice`), and **method tables** used by `checkExpr` on `Select`/`Call`:
  - string: `length: int`, `fromBytes(char-array, int)`, `toBytes(char-array): int`
  - text: same as string plus indexing
  - `list of T`: `add(T)`, `push(T)`, `pop(): T`, `shift(): T`, `unshift(T)`, `first(): T`, `last(): T`, `remove(int)`, `count: int`
  - `map of T`: `get(string, T): T`, `has(string): bool`, `remove(string)`, `count: int`
  - connection: `open(string)` / `open(address)` / appletalk form, `send(text-or-string)`, `close()`
  - listener: `listen(int)`, `register(string, string)`
  - serviceBrowser: `find(string)`
  - canvas widgets: `clear()`, `line(int,int,int,int)`, `rect/fillRect(int,int,int,int)`, `circle/fillCircle(int,int,int)`, `drawText(int,int,string)`, `width: int`, `height: int`

Declaration pass (single walk, declare-before-use): each top-level decl is checked then declared; `RecordDecl` builds `RecordInfo` (field defaults type-checked; enum member defaults resolved against the field's enum); `EnumDecl` builds `EnumInfo` (auto-numbering: 0 or prev+1; explicit values 0–65535, `enum value out of range`; duplicate values `duplicate enum value N`; duplicate member names `redeclaration of X`); `VarDecl` global; `FuncDecl` (params scope, body, return paths NOT flow-analyzed — a missing return is a runtime concern in this design, do not implement return-path analysis).

Expression rules (reference Ch3–4, all must be enforced):
- Arithmetic `+ - * / mod`: both int → int; both fixed → fixed (not `mod`: fixed `mod` fixed is an error `operator mod requires int operands`); mixed → `mixed int/fixed arithmetic; convert explicitly`.
- Bitwise `& | ^ << >> ~`: int only → `bitwise operator requires int operands`.
- `+` also: string+string→string(255) temp, string+char→string, text+text/string→text.
- Comparisons: operands assignable-compatible; enums only `==`/`!=` (`enums are not ordered`); result bool.
- `and`/`or`/`not`: bool operands (`condition must be bool`).
- Conversions (Call whose Fn is Ident naming a type): `int(fixed|char|enum)`, `fixed(int)`, `char(int)`, `EnumName(int)`. Anything else: `cannot convert X to Y`.
- Indexing: string/text → char; array/list → elem; map → value (index expr must be string for map, int otherwise).
- `Select`: record fields, method/property tables above, `EnumName.front`? no — `WindowName.front` yields window ref; enum member access is NOT via dot (bare names only).
- Bare `Ident` resolution order: current scope chain, then (when `expected` is an enum) that enum's members, then `expected==nil` fallback: if exactly one visible enum in the program has a member of that name... NO — keep it strict: bare enum members resolve ONLY via `expected` context (assignment RHS, comparison against enum expr, call arg, field default, return value). Comparison drives this: when checking `Binary` `==`, check left with no expectation; if left is enum, re-check right with that expectation (and vice versa).
- `nil` only where expected is WindowRef/resource (`nil is only valid for window and resource references`).
- `new T` → record type T; `open W` → WindowRef W.

- [ ] **Step 1: Write the failing test** (representative table — errors are matched by substring):

```go
// internal/check/check_test.go
package check

import (
	"clarus/internal/parser"
	"clarus/internal/source"
	"strings"
	"testing"
)

func diagsFor(t *testing.T, src string) []string {
	t.Helper()
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatalf("parse: %v", pd[0])
	}
	var out []string
	for _, d := range File(f, tree) {
		out = append(out, d.Msg)
	}
	return out
}

func expectClean(t *testing.T, src string) {
	t.Helper()
	if ds := diagsFor(t, src); len(ds) != 0 {
		t.Fatalf("want clean, got: %v", ds)
	}
}

func expectError(t *testing.T, src, substr string) {
	t.Helper()
	ds := diagsFor(t, src)
	for _, d := range ds {
		if strings.Contains(d, substr) {
			return
		}
	}
	t.Fatalf("want error containing %q, got %v", substr, ds)
}

func TestExprRules(t *testing.T) {
	expectClean(t, "var a: int = 3 + 4 * 5\n")
	expectClean(t, "var f: fixed = 1.5 + 2.0\n")
	expectError(t, "var a: fixed = 1 + 1.5\n", "mixed int/fixed")
	expectError(t, "var a: int = 1.5 & 2.0\n", "bitwise operator requires int")
	expectClean(t, "var a: int = 3 << 8 | 42\n")
	expectClean(t, "var s: string = \"a\" + \"b\"\n")
	expectError(t, "var b: bool = 1 and true\n", "condition must be bool")
	expectClean(t, "var i: int = 42\nvar f: fixed = fixed(i)\n")
	expectClean(t, "var c: char = char(65)\nvar i: int = int(c)\n")
	expectError(t, "var f: fixed = fixed(1.5)\n", "cannot convert")
}

func TestEnumRules(t *testing.T) {
	expectClean(t, "enum E { A, B, C }\nvar e: E = B\nvar n: int = int(e)\nvar back: E = E(n)\n")
	expectError(t, "enum E { A, B }\nvar e: E = A\nvar bad: bool = e < B\n", "not ordered")
	expectError(t, "enum E { A 0x10, B 0x10 }\n", "duplicate enum value")
	expectError(t, "enum E { A 70000 }\n", "out of range")
	expectClean(t, "enum E { A, M 0x10 \"Dogcow\", N }\nvar e: E = N\n") // N = 0x11
	expectError(t, "enum E { A }\nenum F { A }\nvar e: E = A\nvar f: F = e\n", "cannot assign")
}

func TestDeclareBeforeUse(t *testing.T) {
	expectError(t, "var a: int = b\nvar b: int = 1\n", "undefined: b")
	expectError(t, "var a: int = 1\nvar a: int = 2\n", "redeclaration")
}

func TestCollections(t *testing.T) {
	expectClean(t, `var l: list of int
func f() {
    var x: int

    l.push(3)
    x = l.pop()
    x = l.first()
    l.unshift(x)
}
`)
	expectClean(t, "var m: map of int\nfunc f() {\n    var x: int\n\n    x = m.get(\"k\", 0)\n}\n")
	expectError(t, "var l: list of int\nfunc f() {\n    l.push(true)\n}\n", "cannot use bool")
	expectClean(t, `var t: text
func crc(data: text): int {
    var c: int = 0
    var i: int = 0

    while i < data.length {
        c = c ^ int(data[i])
        i = i + 1
    }
    return c
}
`)
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/check/` → FAIL.
- [ ] **Step 3: Implement** `check.go` (walk + declaration building per Interfaces), `expr.go` (`checkExpr` per the rules list), `builtins.go` (universe scope + method tables as data: `map[types.Kind]map[string]methodSig` plus special cases for list/map element typing).
- [ ] **Step 4: Run to verify pass** — ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: checker for declarations and expressions"`

---

### Task 11: Checker — statements, UI surface, handlers

**Files:**
- Create: `internal/check/stmt.go`, `internal/check/ui.go`, `internal/check/events.go`
- Test: `internal/check/ui_test.go`

**Interfaces:**
- `stmt.go`: block scoping; `if`/`while` conditions bool; `for x in list/map/text?` — list (x: elem), map (k: string, v: value), range (both ends int, no second variable `range for takes one variable`); assignment `AssignableTo` (string capacities inter-assign freely; `cannot assign X to Y` otherwise); `cancel` only inside a handler whose event name is `closeRequest` (`cancel is only valid inside a closeRequest handler`); `edit F, target`: F must be a form window (`X is not a form window`), lvalue target must be F's record type, `new T` must be F's record type; `open`/`close` on window types/refs; `return` type vs declared.
- `ui.go`: windows — property names per widget kind validated against a table (exactly the reference Ch8 widget property table: unknown property `unknown property X for Y`), `binds:` fields must exist on the form record with a widget-compatible type (field/check/popup per Ch10 table), `column shows` fields must exist on the row record (rows: must be `list of` record), per-instance var scoping, `form for` names a record. Menus — entry shape already parsed; nothing to check beyond duplicate item names in one menu.
- `events.go`: one table, transcribed from reference Appendix B, mapping (context, event) → required param types, where context is one of `app`, `window`, `formWindow`, `button`, `field`, `textview`, `check`, `popup`, `table`, `canvas`, `menuItem`, `connection`, `listener`, `serviceBrowser`. Handler validation: top-level `on App.x` / `on resourceVar.x`; inside `extend W` — bare window events, `Widget.event` for W's widgets, nested `extend Menu { on Item.select }`; param lists must match the table exactly (names free, types fixed): `handler App.openDocument takes (path: string)` style messages. `every N ticks`: N ≥ 1 (`tick count must be at least 1`). Inside window handlers, declare `window` self-reference with type WindowRef(W), and bring the instance's widgets/vars/properties (`title: string`) into scope; `accepted` param type is the form's record.
- **Window references and type names in expressions:** a window TYPE name in expression position supports only `.front` (yields `WindowRef` of that type, possibly nil at runtime: `Doc.front`). A `WindowRef` value supports `Select` of: the window's per-instance vars (their declared types), its widgets (yielding a widget pseudo-type whose members are that widget kind's runtime properties and canvas methods, e.g. `d.Body.text` → `text` for a textview), and the `title: string` property. These paths are what the editor fixture exercises (`Doc.front.path`, `d.Body.text`, `g.Board.fillCircle(...)`).

- [ ] **Step 1: Write the failing test**

```go
// internal/check/ui_test.go
package check

import "testing"

const uiBase = `
enum Protocol { Gopher, HTTP, Telnet }

record Bookmark {
    name:     string(63)
    protocol: Protocol
    favorite: bool
}

var bookmarks: list of Bookmark

window EditForm {
    title: "Edit"
    form for Bookmark

    field Name  { binds: name; label: "Name:" }
    check Fav   { binds: favorite; caption: "Favorite" }
    popup Proto { binds: protocol; label: "Protocol:" }

    button OK     { default }
    button Cancel { cancel }
}

window Main {
    title: "Marks"
    size: 420, 300
    resizable

    table Marks {
        rows: bookmarks
        column "Name" shows name width 140
    }
    button Add { at: 10, bottom; caption: "Add…" }
}
`

func TestUIClean(t *testing.T) {
	expectClean(t, uiBase+`
on App.startEmpty {
    open Main
}

extend Main {
    on Add.click {
        edit EditForm, new Bookmark
    }
    on Marks.doubleClick(i: int) {
        edit EditForm, bookmarks[i]
    }
    on closeRequest {
        cancel
    }
}

extend EditForm {
    on accepted(b: Bookmark) {
        if b.isNew { bookmarks.add(b) }
    }
}
`)
}

func TestUIErrors(t *testing.T) {
	expectError(t, uiBase+"extend Main {\n    on Add.frobnicate { }\n}\n", "unknown event")
	expectError(t, uiBase+"extend Main {\n    on Marks.doubleClick(i: bool) { }\n}\n", "takes")
	expectError(t, uiBase+"func f() {\n    cancel\n}\n", "closeRequest")
	expectError(t, `record R { x: int }
window W {
    form for R
    field F { binds: nope }
}
`, "no field")
	expectError(t, `window W {
    button B { rows: 3 }
}
`, "unknown property")
	expectError(t, uiBase+"func f() {\n    edit Main, new Bookmark\n}\n", "not a form window")
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/check/ -run UI` → FAIL.
- [ ] **Step 3: Implement** the three files per Interfaces. The widget-property and event tables are transcribed from reference Ch8 and Appendix B — transcribe completely, both directions (every event in Appendix B appears; no extras). `isNew` is a synthetic bool field readable on any record value inside `accepted` handlers (implement as: record Select of name `isNew` → bool, valid only when the record came from an `accepted` param; simplest correct approximation: allow `isNew` as a bool pseudo-field on ANY record expression — note this in a code comment as deliberately permissive; Plan 3 revisits).
- [ ] **Step 4: Run to verify pass** — `go test ./internal/check/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: checker for statements, UI, and handlers"`

---

### Task 12: CLI, golden harness, worked-example fixtures

**Files:**
- Create: `cmd/clarus/main.go`, `internal/driver/driver.go`, `internal/driver/golden_test.go`
- Create: `testdata/valid/bookmarks.cla`, `testdata/valid/editor.cla` (copied **verbatim** from reference Appendix C code blocks), `testdata/errors/*.cla` + matching `*.expect` files

**Interfaces:**
- `driver.Check(paths []string) (diags []source.Diag, err error)` — loads files in order, concatenating their declarations into one program (multi-file, declare-before-use across the sequence).
- `cmd/clarus/main.go`: `clarus check FILE...` → prints each diag line to stdout, exit 1 if any; `clarus` with no args prints usage to stderr, exit 2.

- [ ] **Step 1: Copy fixtures.** Extract the two Appendix C code blocks from `docs/clarus-language-reference.md` byte-for-byte into `testdata/valid/bookmarks.cla` and `testdata/valid/editor.cla`. Create error fixtures, each `.cla` beside a `.expect` holding the exact expected stdout:

`testdata/errors/mixed.cla`:
```rust
var bad: fixed = 1 + 1.5
```
`testdata/errors/mixed.expect`:
```
testdata/errors/mixed.cla:1:18: mixed int/fixed arithmetic; convert explicitly
```
(Adjust the column in the expect file to whatever the implementation actually reports for the `+` position — then freeze it; goldens exist to catch drift.)

Also create, same pattern: `chain.cla` (`var b: bool = 1 < 2 < 3` → comparisons do not chain), `varorder.cla` (var after statement), `dupenum.cla` (duplicate enum value), `badbind.cla` (binds to missing field).

- [ ] **Step 2: Write the failing golden test**

```go
// internal/driver/golden_test.go
package driver

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestValidProgramsCheckClean(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/valid/*.cla")
	if len(files) < 2 {
		t.Fatal("expected at least the two worked-example fixtures")
	}
	for _, f := range files {
		diags, err := Check([]string{f})
		if err != nil {
			t.Fatalf("%s: %v", f, err)
		}
		if len(diags) != 0 {
			t.Errorf("%s: want clean, got %v", f, diags[0])
		}
	}
}

func TestErrorGoldens(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/errors/*.cla")
	for _, f := range files {
		want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".expect")
		if err != nil {
			t.Fatalf("%s: missing .expect", f)
		}
		diags, _ := Check([]string{f})
		var got strings.Builder
		for _, d := range diags {
			got.WriteString(d.String() + "\n")
		}
		if got.String() != string(want) {
			t.Errorf("%s:\ngot:  %q\nwant: %q", f, got.String(), string(want))
		}
	}
}
```

- [ ] **Step 3: Run to verify failure** — `go test ./internal/driver/` → FAIL (driver undefined).
- [ ] **Step 4: Implement** `driver.go` (load each file, parse each — a parse error in any file stops that file but still reports; concatenate ASTs in argument order into one `ast.File`; run `check.File` with a combined pseudo-file for cross-file positions — simplest: check per the merged tree but keep each Diag pointing at its own source.File) and `main.go` (arg handling per Interfaces). Fix any fixture-revealed front-end bugs now — the two worked examples are the acceptance test of this entire plan; budget real time here.
- [ ] **Step 5: Run everything** — `go test ./...` → all packages ok. `go vet ./...` → clean. Then by hand: `go run ./cmd/clarus check testdata/valid/editor.cla` → silent, exit 0.
- [ ] **Step 6: Commit** — `git commit -am "feat: clarus check CLI and golden test harness"`

---

## Self-review notes (kept in-plan for the executor)

- The grammar's `handlerDecl` inside `extend` vs top level is the same production; the CHECKER distinguishes contexts (Task 11), not the parser.
- `mod`, `ticks`, `appletalk`, `standard`, `item`, `separator`, `column`, `shows`, `width`, `key`, `form`, type words — all contextual: lexed as IDENT, recognized by position. Only the 28 hard keywords are keyword tokens.
- Reference Ch6 forbids user functions filling fixed-size out-params — nothing to enforce in the checker beyond normal by-value semantics; built-ins that DO fill strings (`askOpen`) are declared in `builtins.go` with ordinary signatures and get their special convention in the code generator (Plan 3+), not here.
- Windows/menus/resources referenced before declaration violate declare-before-use like everything else — single pass covers it.

## Roadmap context (later plans, not this one)

3. IR + host C printer — golden-run semantics natively
4. Mac target — Retro68 (`/Users/andrew/repos/Retro68-build/toolchain`), resource emission, runtime shell, first app in Mini vMac
5. Memory + forms runtime — handles, text/list/map, binding walker, files
6. Networking — MacTCP + AppleTalk behind connection/listener/serviceBrowser
