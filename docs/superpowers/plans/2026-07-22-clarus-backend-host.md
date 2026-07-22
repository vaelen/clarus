# Clarus IR + Host Backend Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clarus programs execute: a typed IR, an AST→IR lowering pass, a C printer, and a portable host runtime give `clarus build` / `clarus run` — golden-tested natively with no emulator, proving the language's core semantics before any Mac code exists.

**Architecture:** The checker learns to export per-expression type info. Lowering produces a small typed IR — structured statements, typed expressions, and **named intrinsics** for everything the runtime does (string stores, list ops, fixed math); no libc concept exists in the IR. A C printer walks the IR into one C99 translation unit linked against `runtime/host/rt.c` (which MAY use libc freely — it is the host stand-in for the future Toolbox runtime). Plan 4 adds a second printer/runtime targeting Retro68; the IR is the frozen seam between them.

**Tech Stack:** Go ≥ 1.22 stdlib only (runtime C embedded via `go:embed`); host C compiler `cc` (override with `$CC`), `-std=c99`.

## Global Constraints

- **Authorities:** `docs/clarus-language-reference.md` for semantics; `docs/superpowers/specs/2026-07-21-clarus-language-design.md` §2/§13 for the IR philosophy (abstract intrinsics, no libc at IR level).
- Existing packages must keep their public behavior: `clarus check` output unchanged; `check.File`/`check.Files` diagnostics unchanged (signature MAY gain an Info return — Task 2).
- **Host-build scope (deliberate, enforced):** programs using `window`, `menu`, `extend`, `every`, resource types (`connection`/`listener`/`serviceBrowser`), dialogs other than `alert`, or `file.save`/`file.load` fail `clarus build` with `host build does not support X yet` naming the construct and its position. `clarus check` still accepts them. Supported: everything else — functions, `App.launch`/`App.startEmpty` handlers, records, enums, strings, `char`, `fixed`, `text`, `list of`, `map of`, `alert`, `file.readText`/`writeText`/`name`, `lastError`.
- Host program behavior: `main` runs `App.launch` handler (if declared) then `App.startEmpty` (if declared), then exits 0. `alert(msg)` prints the message + `\n` to **stdout**. Runtime errors print `runtime error: MESSAGE` to **stderr** and exit **3**. Truncating string stores clamp and set `lastError` (code 1, message `string truncated`) exactly per reference Ch4.
- `\n` inside Clarus string data is CR (byte 13) per the reference; the HOST `alert` translates CR to LF on output so goldens are readable. (Document this in `rt.c` — it is a host affordance, not language semantics.)
- Golden harness: `testdata/run/NAME.cla` + `NAME.out` (exact stdout); `testdata/runerr/NAME.cla` + `NAME.err` (substring of stderr, exit 3).
- gofmt-clean, `go vet` clean, table-driven tests, C compiled with `-std=c99 -Wall -Werror` in tests.

---

### Task 1: Reference-fence check fixtures

Carryover from the front-end final review: the two Criticals lived in documented-but-unfixtured code paths. Harvest the reference's own examples as permanent check fixtures.

**Files:**
- Create: `internal/reftest/reftest.go`, `internal/reftest/reftest_test.go`, `internal/reftest/manifest.go`

**Interfaces:**
- Produces: `reftest.ExtractFences(mdPath string) ([]Fence, error)` where `Fence{Index int, Line int, Code string}` — every ```` ```rust ```` block in document order.

- [ ] **Step 1: Write the failing test**

```go
// internal/reftest/reftest_test.go
package reftest

import (
	"clarus/internal/driver"
	"os"
	"path/filepath"
	"testing"
)

func TestFencesExtract(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	if len(fences) < 20 {
		t.Fatalf("expected at least 20 rust fences, got %d", len(fences))
	}
}

// Every fence listed in CheckClean must pass `clarus check` standalone.
func TestCheckCleanFences(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	dir := t.TempDir()
	for _, idx := range CheckClean {
		if idx >= len(fences) {
			t.Fatalf("manifest index %d out of range (%d fences)", idx, len(fences))
		}
		p := filepath.Join(dir, "fence.cla")
		if err := os.WriteFile(p, []byte(fences[idx].Code), 0o644); err != nil {
			t.Fatal(err)
		}
		diags, err := driver.Check([]string{p})
		if err != nil {
			t.Fatal(err)
		}
		if len(diags) != 0 {
			t.Errorf("fence %d (md line %d): %v", idx, fences[idx].Line, diags[0])
		}
	}
}
```

- [ ] **Step 2: Run to verify failure** — `go test ./internal/reftest/` → FAIL (undefined).
- [ ] **Step 3: Implement.** `reftest.go`: scan lines for ```` ```rust ```` … ```` ``` ```` pairs, record start line. `manifest.go`: `var CheckClean = []int{...}` — populate it by running the extractor over all fences (write a temporary `TestMain` dump or a one-off `go run` snippet), attempting `driver.Check` on each, and listing every index that passes TODAY. Fragments that reference undeclared names won't pass — that's expected; they stay off the manifest with a `// not standalone:` comment noting why (one line per excluded index, grouped). The three full programs (Ch1 example, Ch11 bounce, both Appendix C examples) MUST be on the manifest — if one fails, that's a compiler bug to investigate, not an exclusion.
- [ ] **Step 4: Run to verify pass** — `go test ./internal/reftest/` → ok.
- [ ] **Step 5: Commit** — `git commit -am "feat: reference-fence check fixtures with manifest"`

---

### Task 2: Checker type-info export

**Files:**
- Modify: `internal/check/check.go`, `internal/check/expr.go` (recording), `internal/driver/driver.go` (adapt call)
- Test: `internal/check/info_test.go`

**Interfaces:**
- Produces:

```go
// package check
type Info struct {
	Types       map[ast.Expr]*types.Type // type of every successfully checked expression
	EnumConsts  map[ast.Expr]int         // resolved VALUE for bare enum-member Idents and enum-typed defaults
	GlobalOrder []string                 // declaration order of globals (init order for lowering)
}
func Files(files []*source.File, trees []*ast.File) ([]source.Diag, *Info)
func File(f *source.File, tree *ast.File) []source.Diag  // unchanged behavior, discards Info
```

Recording rule: at the single point(s) where `checkExpr` returns a type, record `Info.Types[e]`; where a bare Ident resolves as an enum member, record its value in `EnumConsts`. Existing tests must pass untouched except call sites of `Files` (driver + any test using it directly gains `, _`).

- [ ] **Step 1: Write the failing test**

```go
// internal/check/info_test.go
package check

import (
	"clarus/internal/parser"
	"clarus/internal/source"
	"clarus/internal/types"
	"clarus/internal/ast"
	"testing"
)

func TestInfoTypes(t *testing.T) {
	src := "enum E { A, M 0x10 }\nvar x: int = 3 + 4\nvar e: E = M\n"
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatal(pd[0])
	}
	diags, info := Files([]*source.File{f}, []*ast.File{tree})
	if len(diags) != 0 {
		t.Fatal(diags[0])
	}
	init := tree.Decls[1].(*ast.VarDecl).Init // 3 + 4
	if tt, ok := info.Types[init]; !ok || tt.Kind != types.Int {
		t.Fatalf("no int type recorded for binary expr: %v", tt)
	}
	em := tree.Decls[2].(*ast.VarDecl).Init // M
	if v, ok := info.EnumConsts[em]; !ok || v != 0x10 {
		t.Fatalf("enum const not recorded: %v %v", v, ok)
	}
	if len(info.GlobalOrder) != 2 || info.GlobalOrder[0] != "x" {
		t.Fatalf("global order: %v", info.GlobalOrder)
	}
}
```

- [ ] **Step 2: Run to verify failure** — FAIL.
- [ ] **Step 3: Implement** per Interfaces (thread an `*Info` through the checker struct; nil-safe so `File` can skip allocation if convenient — but simplest is always-allocate).
- [ ] **Step 4: Full suite** — `go test ./...` ok (existing checker tests unchanged).
- [ ] **Step 5: Commit** — `git commit -am "feat: checker exports expression type info"`

---

### Task 3: IR package

**Files:**
- Create: `internal/ir/ir.go`, `internal/ir/intrinsics.go`
- Test: compile-only (exercised from Task 6 on): `go build ./...`

**Interfaces (complete — later tasks use these exact names):**

```go
// internal/ir/ir.go
package ir

type Program struct {
	Globals []*Global
	Funcs   []*Func
	StrLits []string        // literal pool; StrConst.Idx indexes this
	Records []*RecordLayout // declaration order
	Enums   []*EnumLayout
	HasLaunch, HasStartEmpty bool // which App handlers exist
}

type RecordLayout struct {
	Name   string
	Fields []FieldSlot
}
type FieldSlot struct {
	Name    string
	T       Type
	Default int64 // scalar/enum/char/bool/fixed-raw default; strings default empty
	DefaultStr int // -1, or StrLits index for a string default
}
type EnumLayout struct {
	Name    string
	Members []string
	Values  []int
	Labels  []string
}
type Global struct {
	Name string
	T    Type
	Init Expr // nil → zero value
}
type Func struct {
	Name   string // user funcs keep their name; handlers are "handler_App_launch", "handler_App_startEmpty"
	Params []Local
	Ret    Type // K == Void for procedures
	Locals []Local
	Body   []Stmt
}
type Local struct {
	Name string
	T    Type
}

// ---- types (flat; Name links records/enums by name) ----
type Kind int
const (
	Void Kind = iota
	Int; Bool; Fixed; Char
	Str  // N = capacity
	Text; List; Map // Elem = element/value type
	Rec  // Name = record name
	Enum // Name = enum name
	Arr  // N = length, Elem = element type
	Err  // the error record {code, message}
)
type Type struct {
	K    Kind
	N    int
	Elem *Type
	Name string
}

// ---- statements ----
type Stmt interface{ stmt() }
type Assign struct{ Dst, Src Expr }      // same-type move (records/arrays copy by value)
type StoreStr struct{ Dst, Src Expr }    // clamped string store; sets lastError on truncation
type ExprStmt struct{ X Expr }
type If struct {
	Cond Expr
	Then, Else []Stmt // Else may be nil
}
type While struct {
	Cond Expr
	Body []Stmt
}
type ForRange struct {
	V        string // int loop local, inclusive bounds
	From, To Expr
	Body     []Stmt
}
type ForList struct {
	V     string // element local
	ListV Expr
	Body  []Stmt
}
type ForMap struct {
	K, V string
	MapV Expr
	Body []Stmt
}
type Return struct{ X Expr } // nil for bare return

// ---- expressions (every node carries its Type) ----
type Expr interface{ Type() Type }
type IntConst struct { V int64; Ty Type }  // int/bool(0|1)/char/enum-value/fixed-raw constants
type StrConst struct { Idx int; Ty Type }  // Ty.K == Str, N = 255
type VarRef struct { Name string; Global bool; Ty Type }
type FieldRef struct { X Expr; Name string; Ty Type }        // record field lvalue/rvalue
type IndexRef struct { X Expr; I Expr; Ty Type }             // array element (lvalue/rvalue); list/map/string/text indexing lowers to intrinsics, NOT IndexRef
type Bin struct { Op string; X, Y Expr; Ty Type }            // int/char/bool/fixed(+,-) arith+cmp+bitwise; fixed *,/ lower to intrinsics; string/text ops lower to intrinsics
type Un struct { Op string; X Expr; Ty Type }                // "-", "not", "~"
type ConvOp int
const (
	IntToFixed ConvOp = iota; FixedToInt; IntToChar; CharToInt; EnumToInt; IntToEnum // IntToEnum is CHECKED (panics on no member)
)
type Conv struct { Op ConvOp; X Expr; EnumName string; Ty Type }
type CallFn struct { Name string; Args []Expr; Ty Type }     // user function call
type Intr struct { Name string; Args []Expr; Ty Type }       // runtime intrinsic (intrinsics.go names)
```

```go
// internal/ir/intrinsics.go — the complete Plan 3 intrinsic vocabulary.
// The IR names operations; each printer's runtime decides how (host: C+libc; Mac later: Toolbox).
package ir

const (
	// strings (layout: [len byte][bytes...]; args pass ptr+cap as the printer arranges)
	IStrConcat     = "str_concat"      // (a str, b str) -> str255 temp
	IStrConcatChar = "str_concat_char" // (a str, c char) -> str255 temp
	IStrCmp        = "str_cmp"         // (a, b) -> int (-1/0/1 bytewise)
	IStrLen        = "str_len"         // (s) -> int
	IStrIndex      = "str_index"       // (s, i) -> char  [panics OOB]
	IStrSetIndex   = "str_set_index"   // (s, i, c)       [panics OOB]
	IStrFromBytes  = "str_from_bytes"  // (dst str, buf char-arr ptr+cap, count) ; clamps, sets lastError
	IStrToBytes    = "str_to_bytes"    // (src str, buf char-arr ptr+cap) -> int ; clamps, sets lastError
	// text (opaque handle on host: heap buffer)
	ITextNew = "text_new"; ITextStore = "text_store"; ITextConcat = "text_concat"
	ITextCmp = "text_cmp"; ITextLen = "text_len"; ITextIndex = "text_index"
	ITextSetIndex = "text_set_index"; ITextFromBytes = "text_from_bytes"; ITextToBytes = "text_to_bytes"
	// list (element size known at creation)
	IListNew = "list_new"; IListPush = "list_push"; IListPop = "list_pop"
	IListShift = "list_shift"; IListUnshift = "list_unshift"; IListFirst = "list_first"
	IListLast = "list_last"; IListRemove = "list_remove"; IListGet = "list_get"
	IListSet = "list_set"; IListCount = "list_count"
	// map (string keys; value size known at creation)
	IMapNew = "map_new"; IMapSet = "map_set"; IMapGet = "map_get" // panics if absent
	IMapGetDv = "map_get_dv"; IMapHas = "map_has"; IMapRemove = "map_remove"; IMapCount = "map_count"
	// fixed 16.16
	IFixMul = "fix_mul"; IFixDiv = "fix_div"
	// misc
	IEnumFromInt = "enum_from_int" // (enum table, v) -> value or panic
	IPanic = "panic"               // (msg str-lit) -> never returns
	IAlert = "alert"               // (s) host: stdout
	ILastErrCode = "lasterr_code"; ILastErrMsg = "lasterr_msg"
	// files (host: stdio)
	IFileReadText = "file_read_text"   // (path str, t text) -> bool
	IFileWriteText = "file_write_text" // (path str, t text) -> bool
	IFileName = "file_name"            // (path str) -> str255
)
```

- [ ] **Step 1: Write both files exactly** (plus mechanical `stmt()` / `Type() Type` methods).
- [ ] **Step 2: Verify** — `go build ./...`, `gofmt -l .` clean.
- [ ] **Step 3: Commit** — `git commit -am "feat: IR definition with intrinsic vocabulary"`

---

### Task 4: Host runtime — strings, fixed, panic, alert, lastError

**Files:**
- Create: `runtime/host/rt.h`, `runtime/host/rt.c`, `internal/build/rtsmoke_test.go`

**Interfaces (the C ABI later tasks print calls against — exact signatures):**

```c
/* runtime/host/rt.h — host stand-in for the future Toolbox runtime. May use libc. */
#ifndef CLARUS_RT_H
#define CLARUS_RT_H
#include <stdint.h>

/* Strings: [len][bytes...] — a strN value is a struct {uint8_t len; uint8_t b[N];}.
   All functions take the raw pointer to the len byte plus the capacity N. */
void rt_str_store(uint8_t *dst, int dstcap, const uint8_t *src);      /* clamped; sets lastError on truncation */
void rt_str_concat(uint8_t *out255, const uint8_t *a, const uint8_t *b); /* out is a str255 temp */
void rt_str_concat_char(uint8_t *out255, const uint8_t *a, uint8_t c);
int  rt_str_cmp(const uint8_t *a, const uint8_t *b);                  /* bytewise -1/0/1 */
int  rt_str_len(const uint8_t *s);
uint8_t rt_str_index(const uint8_t *s, int32_t i);                    /* panics OOB */
void rt_str_set_index(uint8_t *s, int32_t i, uint8_t c);
void rt_str_from_bytes(uint8_t *dst, int dstcap, const uint8_t *buf, int bufcap, int32_t count);
int32_t rt_str_to_bytes(const uint8_t *src, uint8_t *buf, int bufcap);

int32_t rt_fix_mul(int32_t a, int32_t b);                             /* (a*b)>>16 via int64 */
int32_t rt_fix_div(int32_t a, int32_t b);                             /* (a<<16)/b via int64; b==0 panics "division by zero" */

void rt_panic(const char *msg);                                       /* "runtime error: MSG" to stderr, exit(3) */
void rt_alert(const uint8_t *s);                                      /* stdout + \n; CR bytes rendered as LF */

extern int32_t rt_lasterr_code;
extern uint8_t rt_lasterr_msg[256];                                    /* a str255 */
void rt_set_lasterr(int32_t code, const char *msg);
#endif
```

Also in rt.c but not yet in rt.h: nothing — keep header complete per task.

- [ ] **Step 1: Write the smoke test** (Go test that compiles and runs a tiny C program against rt.c):

```go
// internal/build/rtsmoke_test.go
package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

const smokeMain = `
#include "rt.h"
#include <stdio.h>
int main(void) {
    struct { uint8_t len; uint8_t b[3]; } s3 = {0};
    struct { uint8_t len; uint8_t b[255]; } hello = {5, {'h','e','l','l','o'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_concat((uint8_t*)&out, (uint8_t*)&hello, (uint8_t*)&hello);
    if (rt_str_len((uint8_t*)&out) != 10) { printf("concat len FAIL\n"); return 1; }
    rt_str_store((uint8_t*)&s3, 3, (uint8_t*)&hello);        /* clamps to "hel", sets lastError */
    if (s3.len != 3 || rt_lasterr_code == 0) { printf("clamp FAIL\n"); return 1; }
    if (rt_fix_mul(98304, 131072) != 196608) { printf("fixmul FAIL\n"); return 1; } /* 1.5*2.0=3.0 */
    if (rt_str_index((uint8_t*)&hello, 1) != 'e') { printf("index FAIL\n"); return 1; }
    rt_alert((uint8_t*)&hello);
    printf("OK\n");
    return 0;
}
`

func cc() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}

func TestRuntimeSmokeStrings(t *testing.T) {
	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, []byte(smokeMain), 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "smoke")
	cmd := exec.Command(cc(), "-std=c99", "-Wall", "-Werror", "-I", "../../runtime/host", main, "../../runtime/host/rt.c", "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}
	out, err := exec.Command(exe).CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, out)
	}
	if string(out) != "hello\nOK\n" {
		t.Fatalf("output: %q", out)
	}
}
```

- [ ] **Step 2: RED** — `go test ./internal/build/` fails (missing files).
- [ ] **Step 3: Implement rt.h/rt.c** per the header above. Clamped store: `n = min(src[0], dstcap); memcpy; dst[0]=n; if n < src[0] set lastError(1, "string truncated")`. Panic on OOB indexing (`"string index out of range"`).
- [ ] **Step 4: GREEN**, commit — `git commit -am "feat: host runtime — strings, fixed, panic, alert"`

---

### Task 5: Host runtime — text, list, map

**Files:**
- Modify: `runtime/host/rt.h`, `runtime/host/rt.c`
- Test: extend `internal/build/rtsmoke_test.go`

**Interfaces (append to rt.h):**

```c
typedef struct rt_text rt_text;   /* opaque; growable byte buffer */
rt_text *rt_text_new(void);
void rt_text_store(rt_text *t, const uint8_t *s);            /* from string */
void rt_text_store_text(rt_text *t, const rt_text *src);
void rt_text_concat(rt_text *t, const rt_text *a, const uint8_t *bstr, const rt_text *btext); /* one of bstr/btext non-NULL */
int  rt_text_cmp_str(const rt_text *t, const uint8_t *s);
int32_t rt_text_len(const rt_text *t);
uint8_t rt_text_index(const rt_text *t, int32_t i);
void rt_text_set_index(rt_text *t, int32_t i, uint8_t c);
void rt_text_from_bytes(rt_text *t, const uint8_t *buf, int bufcap, int32_t count);
int32_t rt_text_to_bytes(const rt_text *t, uint8_t *buf, int bufcap);

typedef struct rt_list rt_list;   /* growable array of fixed-size elements */
rt_list *rt_list_new(int32_t elemsize);
void rt_list_push(rt_list *l, const void *elem);
void rt_list_pop(rt_list *l, void *out);      /* panics empty: "pop on empty list" etc. */
void rt_list_shift(rt_list *l, void *out);
void rt_list_unshift(rt_list *l, const void *elem);
void rt_list_first(const rt_list *l, void *out);
void rt_list_last(const rt_list *l, void *out);
void rt_list_remove(rt_list *l, int32_t i);   /* panics OOB */
void *rt_list_at(rt_list *l, int32_t i);      /* element pointer; panics OOB (used for l[i] read AND in-place write) */
int32_t rt_list_count(const rt_list *l);

typedef struct rt_map rt_map;     /* string keys -> fixed-size values */
rt_map *rt_map_new(int32_t valsize);
void rt_map_set(rt_map *m, const uint8_t *key, const void *val);
void rt_map_get(rt_map *m, const uint8_t *key, void *out);        /* panics absent: "map key not found" */
int  rt_map_get_dv(rt_map *m, const uint8_t *key, void *out);     /* returns 0 and leaves out untouched if absent */
int  rt_map_has(rt_map *m, const uint8_t *key);
void rt_map_remove(rt_map *m, const uint8_t *key);
int32_t rt_map_count(const rt_map *m);
/* iteration for `for k, v in m`: stable snapshot by index */
void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255);
void rt_map_val_at(const rt_map *m, int32_t i, void *out);
```

Map iteration order: **insertion order** (host keeps keys in an array; deletions compact) — deterministic goldens matter more than hash order. Document in rt.c that the Mac runtime must preserve this contract (reference doesn't promise an order; we set the de-facto one — flag to the controller in the report so it can be added to the reference later).

- [ ] **Step 1: Extend the smoke test** with `TestRuntimeSmokeCollections`: build a list of int32 (push 3, pop → 3, empty pop is NOT tested here — that's a Clarus-level runerr golden), a map with two keys + get_dv default + insertion-order key_at check, text concat/index/len round-trip. Same cc pattern as Task 4; assert printed "OK".
- [ ] **Step 2: RED.**
- [ ] **Step 3: Implement** (malloc/realloc growable buffers; map = parallel arrays of key str255 + value bytes, linear scan — host simplicity beats speed; `// ponytail: linear-scan map, fine for host tests`).
- [ ] **Step 4: GREEN**, full suite, commit — `git commit -am "feat: host runtime — text, list, map"`

---

### Task 6: Lowering — expressions

**Files:**
- Create: `internal/lower/lower.go`, `internal/lower/expr.go`
- Test: `internal/lower/expr_test.go`

**Interfaces:**
- Produces: `lower.Program(files []*source.File, trees []*ast.File, info *check.Info) (*ir.Program, []source.Diag)` — diags only for host-unsupported constructs (`host build does not support X yet`). Internal: `(*lowerer).lowerExpr(e ast.Expr) ir.Expr`.
- Type mapping helper `lowerType(*types.Type) ir.Type` (Str keeps N; Rec/Enum carry names; Err maps to `ir.Err`).

Lowering rules (complete):
- Literals → IntConst/StrConst (string literals interned into Program.StrLits; FixedLit → IntConst with fixed raw + Ty Fixed; CharLit/BoolLit → IntConst). Bare enum members (via `info.EnumConsts`) → IntConst{V: value, Ty: Enum}.
- `+`: int/fixed/char per Bin; string+string → Intr(IStrConcat), string+char → Intr(IStrConcatChar), text combos → Intr(ITextConcat). fixed `*`/`/` → Intr(IFixMul/IFixDiv). Everything else arithmetic/bitwise/logical → Bin/Un (C printer emits operators; `and`/`or` print as `&&`/`||` — short-circuit preserved).
- Comparisons on strings → `Intr(IStrCmp) <op> 0`; text vs string → `Intr(ITextCmp...) <op> 0`. nil comparisons: Plan 3 programs can't have window/resource values (host-unsupported), so lowering `nil` is a build error via the unsupported check — assert unreachable.
- Conversions → Conv with the matching ConvOp; `EnumName(i)` → Conv{IntToEnum, EnumName}.
- Indexing: array → IndexRef; string → IStrIndex; text → ITextIndex; list → deref of IListGet-style access (lower reads to `Intr("list_get_deref"…)`? NO — keep IR small: reads AND writes of `l[i]` lower to `IndexRef{X: listExpr}` and the C printer emits `*(T*)rt_list_at(l, i)` — document this printer contract in the code); map read → IMapGet, `m.get(k,dv)` → IMapGetDv.
- Select: record field → FieldRef; `.length`/`.count` → IStrLen/ITextLen/IListCount/IMapCount; lastError.code/message → ILastErrCode/ILastErrMsg; method calls per the intrinsic table.
- User function calls → CallFn. `alert` → Intr(IAlert). Unsupported builtins (askOpen etc.) → unsupported diag.

- [ ] **Step 1: Failing test** (drive through Files+Parse+check.Files, lower a few globals, assert IR shapes):

```go
// internal/lower/expr_test.go
package lower

import (
	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/ir"
	"clarus/internal/parser"
	"clarus/internal/source"
	"testing"
)

func lowerSrc(t *testing.T, src string) *ir.Program {
	t.Helper()
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatal(pd[0])
	}
	diags, info := check.Files([]*source.File{f}, []*ast.File{tree})
	if len(diags) > 0 {
		t.Fatal(diags[0])
	}
	p, ld := Program([]*source.File{f}, []*ast.File{tree}, info)
	if len(ld) > 0 {
		t.Fatal(ld[0])
	}
	return p
}

func TestLowerArith(t *testing.T) {
	p := lowerSrc(t, "var x: int = 3 + 4 * 5\n")
	b := p.Globals[0].Init.(*ir.Bin)
	if b.Op != "+" || b.Ty.K != ir.Int {
		t.Fatalf("root: %+v", b)
	}
}

func TestLowerFixedMul(t *testing.T) {
	p := lowerSrc(t, "var f: fixed = 1.5 * 2.0\n")
	in := p.Globals[0].Init.(*ir.Intr)
	if in.Name != ir.IFixMul {
		t.Fatalf("want fix_mul, got %s", in.Name)
	}
	if c := in.Args[0].(*ir.IntConst); c.V != 98304 {
		t.Fatalf("raw 1.5: %d", c.V)
	}
}

func TestLowerStringConcat(t *testing.T) {
	p := lowerSrc(t, `var s: string = "a" + "b"` + "\n")
	in := p.Globals[0].Init.(*ir.Intr)
	if in.Name != ir.IStrConcat {
		t.Fatalf("want str_concat, got %s", in.Name)
	}
	if len(p.StrLits) != 2 {
		t.Fatalf("literal pool: %v", p.StrLits)
	}
}

func TestLowerEnumConst(t *testing.T) {
	p := lowerSrc(t, "enum E { A, M 0x10 }\nvar e: E = M\n")
	c := p.Globals[0].Init.(*ir.IntConst)
	if c.V != 0x10 || c.Ty.K != ir.Enum || c.Ty.Name != "E" {
		t.Fatalf("%+v", c)
	}
}

func TestUnsupportedWindow(t *testing.T) {
	f := &source.File{Name: "t.cla", Content: []byte("window W {\n    title: \"x\"\n}\n")}
	tree, _ := parser.Parse(f)
	_, info := check.Files([]*source.File{f}, []*ast.File{tree})
	_, ld := Program([]*source.File{f}, []*ast.File{tree}, info)
	if len(ld) == 0 {
		t.Fatal("want unsupported diagnostic for window")
	}
}
```

- [ ] **Step 2: RED.** **Step 3: Implement** lower.go (walk decls; globals in `info.GlobalOrder`; enum/record layouts; unsupported detection for the constructs in Global Constraints) + expr.go per rules. **Step 4: GREEN**, commit — `git commit -am "feat: lowering — expressions and program skeleton"`

---

### Task 7: Lowering — statements, functions, handlers

**Files:**
- Create: `internal/lower/stmt.go`
- Test: `internal/lower/stmt_test.go`

**Interfaces:**
- Completes `lower.Program`: user funcs → ir.Func (locals collected from Block.Vars); `on App.launch`/`on App.startEmpty` → Funcs named `handler_App_launch`/`handler_App_startEmpty` + Program flags; statements per rules:
- Assign: if Dst type is Str → StoreStr (clamped) else Assign. String-typed var initializers likewise (globals: Init handled by an emitted init sequence — see Task 8 contract: the C printer initializes globals in `GlobalOrder` inside `rt_main_init()`; the lowerer just keeps Init exprs).
- if/while/for forms → If/While/ForRange/ForList/ForMap. return/quit: `quit` in host context → lower to Intr(IPanic)?? NO — `quit` is legal in handlers; host semantics: end the program normally. Lower `quit` → `Return{}` from the handler IS wrong inside nested blocks. Give it an intrinsic: add `IQuit = "quit"` to intrinsics.go (host: `exit(0)`). One-line addition — do it in this task, noting it in the report.
- Method-call statements (`l.push(v)` etc.) → ExprStmt(Intr). `l[i] = v` where l is a list → Assign{Dst: IndexRef{list}} (printer contract), string index set → IStrSetIndex, text → ITextSetIndex, map set → IMapSet.

- [ ] **Step 1: Failing test** — lower a function with locals + while + string store; assert: Func has 2 locals; body[1] is *ir.While; a `s = s + "x"` inside lowers to StoreStr whose Src is Intr(IStrConcat). Lower an `on App.launch { alert("hi") }` program; assert HasLaunch and Funcs contains handler_App_launch with ExprStmt(Intr IAlert). (Write the test in the same style as expr_test.go — use lowerSrc.)
- [ ] **Step 2: RED. Step 3: Implement. Step 4: GREEN**, full suite, commit — `git commit -am "feat: lowering — statements, functions, App handlers"`

---

### Task 8: C printer

**Files:**
- Create: `internal/cprint/cprint.go`
- Test: `internal/cprint/cprint_test.go` (structure assertions + compile check)

**Interfaces:**
- Produces: `cprint.Emit(p *ir.Program) []byte` — one self-contained C99 translation unit that `#include "rt.h"` and defines:
  - per-capacity string typedefs actually used: `typedef struct { uint8_t len; uint8_t b[N]; } clar_str_N;`
  - record structs `typedef struct { ... } clar_rec_NAME;` in declaration order (fields in order; strings as clar_str_N; text/list/map as pointers; nested records/arrays inline)
  - enum value tables `static const int32_t clar_enum_NAME[] = {...};` (+ count) for IntToEnum checks
  - string literal pool `static const clar_str_255 clar_lit_K = {len, {bytes...}};`
  - globals as C globals; `static void clar_init_globals(void)` running Inits in order (StoreStr for strings)
  - user funcs/handlers with mangled names `clar_fn_NAME` / declared prototypes first (mutual recursion irrelevant — declare-before-use — but prototypes cost nothing and dodge order bugs)
  - `int main(void) { clar_init_globals(); if HasLaunch clar_fn_handler_App_launch(); if HasStartEmpty clar_fn_handler_App_startEmpty(); return 0; }`
- Printer contracts (from Task 6/7): `IndexRef` over a List prints `(*(T*)rt_list_at(l, i))`; over Arr prints `a.e[i]` with a bounds check helper `rt_arr_check(i, n)` (add to rt.h/rt.c in THIS task: panics "array index out of range"; returns i); `and`/`or` → `&&`/`||`; StoreStr → `rt_str_store((uint8_t*)&dst, CAP, (uint8_t*)&srctemp)` with concat temps materialized into locals (`clar_str_255 t1;`) — the printer may introduce statement-level temporaries for intrinsic string results; document the scheme in a file-top comment.
- Value semantics: record/array assignment prints as plain C struct assignment. list/map/text variables are pointers (reference semantics per Ch3) — plain pointer assignment.

- [ ] **Step 1: Failing test** — emit for a tiny program (`var x: int = 2 + 3` + a func + App.launch alert): assert output contains `clar_init_globals`, `int main(void)`, `rt_alert`; then WRITE the emitted C plus rt.c to a temp dir and compile with cc `-std=c99 -Wall -Werror` (reuse the cc() helper pattern from Task 4's test file — export it as `build.CCPath()` in a tiny `internal/build/cc.go` if cleaner) and RUN it, asserting stdout `hi\n`.
- [ ] **Step 2: RED. Step 3: Implement. Step 4: GREEN**, commit — `git commit -am "feat: C printer emitting runnable host programs"`

---

### Task 9: Build package + `clarus build`

**Files:**
- Create: `internal/build/build.go`, `internal/build/embed.go` (go:embed of runtime/host/*), `internal/build/build_test.go`
- Modify: `cmd/clarus/main.go` (add subcommand)

**Interfaces:**
- `build.Build(paths []string, out string) (diags []source.Diag, err error)`: parse+check (return diags if any) → lower (return its diags) → Emit → write `main.c` + embedded `rt.h`/`rt.c` into a temp work dir → `cc -std=c99 -O1 main.c rt.c -o out` → on cc failure return err with cc output (a cc failure on checker-clean input is a compiler bug — the error says so: `internal error: emitted C failed to compile`).
- `go:embed` note: embed directives can't reach outside the package dir — mirror the runtime files with `//go:generate` copy? NO — simplest correct: move nothing; use `embed.go` in package `build` with `//go:embed rt/rt.h rt/rt.c` where `internal/build/rt/` holds SYMLINKS? Symlinks break go:embed. Decision: the runtime's canonical source LIVES at `internal/build/rt/rt.h|rt.c` from this task onward; Tasks 4–5 create it at `runtime/host/` and THIS task `git mv`s it to `internal/build/rt/` (updating the smoke tests' include paths). One canonical location, no copies.
- CLI: `clarus build [-o OUT] FILE...` (default OUT = basename of first file minus .cla); prints diags/exit 1; usage/exit 2.

- [ ] **Step 1: Failing test** — `build.Build` on a hello-alert .cla in a temp dir produces an executable whose run prints `hi\n`; a program with a check error returns its diags and creates no output file; a `window` program returns the unsupported diag.
- [ ] **Step 2: RED. Step 3: git mv runtime + implement + wire CLI. Step 4: GREEN** (all smoke tests still pass at new paths), commit — `git commit -am "feat: clarus build with embedded host runtime"`

---

### Task 10: `clarus run` + golden harness + first goldens

**Files:**
- Create: `internal/build/golden_test.go`, `cmd/clarus` run wiring
- Create: `testdata/run/hello.cla` + `.out`, `testdata/run/arith.cla` + `.out`, `testdata/run/fixedmath.cla` + `.out`

**Interfaces:**
- CLI: `clarus run FILE...` — Build to a temp exe, exec it, stream stdout/stderr, exit with the child's code.
- Harness:

```go
// internal/build/golden_test.go
package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestRunGoldens(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/run/*.cla")
	if len(files) == 0 {
		t.Fatal("no run goldens")
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".out")
			if err != nil {
				t.Fatal(err)
			}
			exe := filepath.Join(t.TempDir(), "prog")
			if diags, err := Build([]string{f}, exe); err != nil || len(diags) > 0 {
				t.Fatalf("build: %v %v", err, diags)
			}
			out, err := exec.Command(exe).Output()
			if err != nil {
				t.Fatalf("run: %v", err)
			}
			if string(out) != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", out, want)
			}
		})
	}
}

func TestRunErrGoldens(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/runerr/*.cla")
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}
			exe := filepath.Join(t.TempDir(), "prog")
			if diags, err := Build([]string{f}, exe); err != nil || len(diags) > 0 {
				t.Fatalf("build: %v %v", err, diags)
			}
			cmd := exec.Command(exe)
			var stderr strings.Builder
			cmd.Stderr = &stderr
			err = cmd.Run()
			ee, ok := err.(*exec.ExitError)
			if !ok || ee.ExitCode() != 3 {
				t.Fatalf("want exit 3, got %v", err)
			}
			if !strings.Contains(stderr.String(), strings.TrimSpace(string(want))) {
				t.Errorf("stderr %q missing %q", stderr.String(), want)
			}
		})
	}
}
```

Goldens (write exactly):

`testdata/run/hello.cla`:
```rust
on App.launch {
    alert("Hello from Clarus")
}
```
`hello.out`: `Hello from Clarus` + newline.

`arith.cla`: a program computing with ints, chars, bitwise ops and printing via a small `func show(n: int)` that builds a string with concat + char digits (int→decimal-string conversion in Clarus code — division/mod loop; ~15 lines) and alerts it. Expected `.out` with 3–4 lines of known values (e.g. `3 + 4*5 = 23`, `0xFF & 0x0F = 15`, `1 << 10 = 1024`).

`fixedmath.cla`: fixed arithmetic exercising `fix_mul`/`fix_div` and `int(f)`/`fixed(i)` printing integer parts (e.g. `1.5 * 2.0` → `3`).

- [ ] **Step 1:** goldens + failing harness (RED because `run` wiring/`testdata` missing). **Step 2: implement + GREEN.** Also `testdata/runerr/` gets its first case: `oob.cla` (array index out of range) + `.err` `array index out of range`. **Step 3:** commit — `git commit -am "feat: clarus run and golden harness"`

---

### Task 11: Goldens — strings, truncation, lastError, byte copies

**Files:**
- Create: `testdata/run/strings.cla`+`.out`, `testdata/run/truncate.cla`+`.out`, `testdata/run/crc8.cla`+`.out`, `testdata/runerr/strindex.cla`+`.err`

Programs (write exactly; expected outputs computed by hand and frozen):
- `strings.cla`: concat, `s[i]` read/write, `.length`, comparison branches, `string + char`, and a `fromBytes`/`toBytes` round-trip through a `char[8]` buffer (copy a string out, mutate one byte, copy back, alert the result) — this is the only golden coverage of the byte-copy intrinsics, don't drop it.
- `truncate.cla`: `var g: string(3)`; store `"ab" + "cdef"`; alert g (`abc`); alert lastError.message (`string truncated`); then a fitting store; verify lastError untouched by successful stores per Ch4/Ch12 (only failures SET it; document: successful ops do not clear it — matches reference's "most recent soft failure").
- `crc8.cla`: the reference Ch4-discussion CRC-8 function over `"123456789"` (standard check-vector input) with polynomial 0x07 → alert the value as decimal (expected: `244` — verify by hand during implementation with an independent C calculation in the report; freeze whatever both agree on).
- `strindex.cla`: index a string out of range → `.err` `string index out of range`.

- [ ] **Steps:** write programs → run harness (these are RED if any semantics bug exists) → fix any front/mid-end bugs surfaced (separate commits) → GREEN → commit `git commit -am "test: string semantics goldens"`.

---

### Task 12: Goldens — records, enums, lists, maps, control flow

**Files:**
- Create: `testdata/run/records.cla`+`.out` (record defaults incl. enum field default = first member; nested record copy-by-value proof: mutate copy, original unchanged), `testdata/run/collections.cla`+`.out` (list push/pop/shift/unshift/first/last/count; map set/get/get-dv/has/remove/count; `for` over list, map — insertion order — and range), `testdata/run/enums.cla`+`.out` (explicit values, `int(e)`, checked `E(i)` round-trip), `testdata/runerr/emptypop.cla`+`.err` (`pop on empty list`), `testdata/runerr/badenum.cla`+`.err` (checked conversion failure message `no enum member`), `testdata/runerr/mapmiss.cla`+`.err` (`map key not found`)

- [ ] **Steps:** as Task 11 — write, run, fix surfaced bugs in separate commits, freeze outputs, commit `git commit -am "test: records, enums, collections goldens"`.

---

### Task 13: Host files, handler ordering, final polish

**Files:**
- Create: `testdata/run/files.cla`+`.out` (writeText a text, readText it back, alert round-tripped content + `file.name` of a path; use a relative filename in the CWD — the harness runs the exe with cwd = the temp dir; adjust the harness's `exec.Command` to set `cmd.Dir = t.TempDir()` for all run goldens in this task), `testdata/run/launchorder.cla`+`.out` (both App.launch and App.startEmpty declared; output proves launch runs first), plus `internal/build/unsupported_test.go` (table: window/menu/every/connection/askOpen/file.save programs each produce `host build does not support` naming the construct)
- Modify: anything the goldens surface.

- [ ] **Steps:** write → RED where bugs → fix → GREEN. Then full-repo gate: `go test ./...`, `go vet ./...`, `gofmt -l .` empty, `clarus check` fixtures still clean, README-level usage comment at top of `cmd/clarus/main.go` updated to mention build/run. Commit — `git commit -am "feat: host file ops, launch ordering, unsupported-construct errors"`.

---

## Self-review notes (for the executor)

- The IR deliberately has NO nil-window/resource, UI, timer, or network constructs — lowering rejects those programs first. Plan 4 extends the IR rather than reworking it (extension point: new intrinsic names + new Global kinds).
- Map iteration order (insertion order) is a runtime contract this plan CREATES — surface it to the controller for a future one-line reference addition.
- `quit` gets intrinsic `IQuit` (host `exit(0)`) added in Task 7 — intrinsics.go is append-only.
- Two places intentionally lean on printer contracts instead of IR nodes (list `IndexRef`, string temps) — both documented in cprint.go's header comment.

## Roadmap context (later plans, not this one)

4. Mac target — Retro68 toolchain (`/Users/andrew/repos/Retro68-build/toolchain`), Toolbox runtime, resource emission, windows/menus/events, first app in Mini vMac
5. Memory + forms runtime — real Handles, binding walker, files/dialogs on Mac
6. Networking — MacTCP + AppleTalk behind connection/listener/serviceBrowser
