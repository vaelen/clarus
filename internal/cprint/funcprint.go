package cprint

import (
	"fmt"
	"strings"

	"clarus/internal/ir"
)

// funcPrinter accumulates one function/handler body's C statements (and the
// clar_init_globals body, and one global's Init assignment, which reuse the
// same machinery at indent level 1). It is intentionally single-buffer,
// program-order: every helper appends to fp.body via emit/newTmp exactly
// where it's called, so an expression that needs a statement-level
// temporary (see cprint.go's package doc) gets it declared and computed
// immediately before whatever uses it, in the right place, just by virtue
// of call order — no separate "prelude" list to thread through.
type funcPrinter struct {
	pr     *printer
	body   strings.Builder
	tmpN   int
	indent int
}

func newFuncPrinter(pr *printer, indent int) *funcPrinter {
	return &funcPrinter{pr: pr, indent: indent}
}

func (fp *funcPrinter) emit(format string, args ...interface{}) {
	fp.body.WriteString(strings.Repeat("    ", fp.indent))
	fp.body.WriteString(fmt.Sprintf(format, args...))
	fp.body.WriteString("\n")
}

// newTmp declares a fresh local `ctype tN;` at the current position and
// returns its name.
func (fp *funcPrinter) newTmp(ctype string) string {
	fp.tmpN++
	name := fmt.Sprintf("t%d", fp.tmpN)
	fp.emit("%s %s;", ctype, name)
	return name
}

func (fp *funcPrinter) stmts(ss []ir.Stmt) {
	for _, s := range ss {
		fp.stmt(s)
	}
}

func (fp *funcPrinter) stmt(s ir.Stmt) {
	switch s := s.(type) {
	case *ir.Assign:
		d := fp.expr(s.Dst)
		v := fp.expr(s.Src)
		fp.emit("%s = %s;", d, v)
	case *ir.StoreStr:
		fp.storeStr(s.Dst, s.Src)
	case *ir.ExprStmt:
		e := fp.expr(s.X)
		if e != "" {
			fp.emit("%s;", e)
		}
	case *ir.If:
		fp.ifStmt(s)
	case *ir.While:
		fp.whileStmt(s)
	case *ir.ForRange:
		fp.forRangeStmt(s)
	case *ir.ForList:
		fp.forListStmt(s)
	case *ir.ForMap:
		fp.forMapStmt(s)
	case *ir.Return:
		if s.X == nil {
			fp.emit("return;")
		} else {
			fp.emit("return %s;", fp.expr(s.X))
		}
	default:
		panic(fmt.Sprintf("cprint: unhandled statement %T", s))
	}
}

// stripOuterParens removes one matching outer parenthesis pair from s, if
// present. expr() always wraps a Bin/Un result in its own parens (needed
// when it's nested inside another expression); printed directly as an
// `if (...)` condition, a top-level comparison would come out
// double-parenthesized (`if ((a == b))`), which clang's -Wparentheses-
// equality (part of -Wall) flags as a likely `==`/`=` typo. Used only where
// the condition becomes the entire, sole content of a C `if (...)`.
func stripOuterParens(s string) string {
	if len(s) < 2 || s[0] != '(' || s[len(s)-1] != ')' {
		return s
	}
	depth := 0
	for i, c := range s {
		switch c {
		case '(':
			depth++
		case ')':
			depth--
			if depth == 0 && i != len(s)-1 {
				return s // the opening paren's match isn't the final char: not a single outer wrap
			}
		}
	}
	return s[1 : len(s)-1]
}

func (fp *funcPrinter) ifStmt(s *ir.If) {
	fp.emit("if (%s) {", stripOuterParens(fp.expr(s.Cond)))
	fp.indent++
	fp.stmts(s.Then)
	fp.indent--
	if s.Else != nil {
		fp.emit("} else {")
		fp.indent++
		fp.stmts(s.Else)
		fp.indent--
	}
	fp.emit("}")
}

// whileStmt prints `while (1) { <cond's prelude and any side effects,
// re-run every iteration>; if (!(cond)) break; <body> }` rather than a
// plain C `while (cond)`: cond may itself need statement-level
// temporaries (e.g. a string concat), which must be recomputed every
// iteration, not hoisted out and reused stale.
func (fp *funcPrinter) whileStmt(s *ir.While) {
	fp.emit("while (1) {")
	fp.indent++
	cond := fp.expr(s.Cond)
	fp.emit("if (!(%s)) break;", cond)
	fp.stmts(s.Body)
	fp.indent--
	fp.emit("}")
}

// forRangeStmt evaluates From/To once into temps (never re-embeds their
// expression text into the loop header, which would re-evaluate — and for
// a From/To that's a function call, re-run — them every iteration) and
// loops the bound variable, already declared at function top, over
// [from, to] inclusive.
func (fp *funcPrinter) forRangeStmt(s *ir.ForRange) {
	from := fp.expr(s.From)
	ft := fp.newTmp("int32_t")
	fp.emit("%s = %s;", ft, from)
	to := fp.expr(s.To)
	tt := fp.newTmp("int32_t")
	fp.emit("%s = %s;", tt, to)
	fp.emit("for (cv_%s = %s; cv_%s <= %s; cv_%s++) {", s.V, ft, s.V, tt, s.V)
	fp.indent++
	fp.stmts(s.Body)
	fp.indent--
	fp.emit("}")
}

// forListStmt lowers `for x in l { ... }` to an index loop over a count
// snapshotted once at loop entry (Ch5 doesn't promise behavior for a list
// mutated mid-iteration; a fixed count is the simplest defensible choice).
func (fp *funcPrinter) forListStmt(s *ir.ForList) {
	lv := fp.expr(s.ListV)
	lt := fp.newTmp("rt_list *")
	fp.emit("%s = %s;", lt, lv)
	cnt := fp.newTmp("int32_t")
	fp.emit("%s = rt_list_count(%s);", cnt, lt)
	ix := fp.newTmp("int32_t")
	elemC := fp.pr.cType(*s.ListV.Type().Elem)
	fp.emit("for (%s = 0; %s < %s; %s++) {", ix, ix, cnt, ix)
	fp.indent++
	fp.emit("cv_%s = *(%s*)rt_list_at(%s, %s);", s.V, elemC, lt, ix)
	fp.stmts(s.Body)
	fp.indent--
	fp.emit("}")
}

// forMapStmt lowers `for k, v in m { ... }` to an index loop over
// rt_map_count/rt_map_key_at/rt_map_val_at — insertion order, per rt.c's
// CONTRACT comment on rt_map.
func (fp *funcPrinter) forMapStmt(s *ir.ForMap) {
	mv := fp.expr(s.MapV)
	mt := fp.newTmp("rt_map *")
	fp.emit("%s = %s;", mt, mv)
	cnt := fp.newTmp("int32_t")
	fp.emit("%s = rt_map_count(%s);", cnt, mt)
	ix := fp.newTmp("int32_t")
	fp.emit("for (%s = 0; %s < %s; %s++) {", ix, ix, cnt, ix)
	fp.indent++
	fp.emit("rt_map_key_at(%s, %s, (uint8_t*)&cv_%s);", mt, ix, s.K)
	if s.V != "" {
		fp.emit("rt_map_val_at(%s, %s, &cv_%s);", mt, ix, s.V)
	}
	fp.stmts(s.Body)
	fp.indent--
	fp.emit("}")
}

// storeStr prints a clamped string store: `rt_str_store(&dst, CAP, &src);`.
// src is materialized first if it isn't already a named, addressable
// clar_str_255 (an intrinsic's result, e.g. concat, always is by the time
// expr() returns it — see addrable/expr's *ir.Intr case).
func (fp *funcPrinter) storeStr(dst, src ir.Expr) {
	d := fp.addrable(dst)
	fp.emit("rt_str_store((uint8_t*)&(%s), %d, %s);", d, dst.Type().N, fp.strAddr(src))
}

func (fp *funcPrinter) strAddr(e ir.Expr) string {
	return fmt.Sprintf("(const uint8_t*)&(%s)", fp.addrable(e))
}

// addrable returns a C expression for e that is always safe to take the
// address of: a plain reference (VarRef/FieldRef/IndexRef — all valid C
// lvalues once printed) or a string-literal pool entry are returned as-is;
// anything else (a call, an intrinsic's already-materialized temp is
// already covered by the VarRef-shaped case since a temp is just a plain
// declared local, but a CallFn/NewRec/Bin/... result is not addressable in
// C) is first copied into a fresh temp of its own type.
func (fp *funcPrinter) addrable(e ir.Expr) string {
	switch e.(type) {
	// VarRef/FieldRef/IndexRef print to real C lvalues; StrConst to a named
	// static; Intr's value-producing cases already materialize into a
	// named temp (intrCall) — none of these need a further copy.
	case *ir.VarRef, *ir.FieldRef, *ir.IndexRef, *ir.StrConst, *ir.Intr:
		return fp.expr(e)
	default:
		v := fp.expr(e)
		t := fp.newTmp(fp.pr.cType(e.Type()))
		fp.emit("%s = %s;", t, v)
		return t
	}
}

// expr prints e as a single C expression, materializing any needed
// statement-level temporary first (see the package doc comment).
func (fp *funcPrinter) expr(e ir.Expr) string {
	switch e := e.(type) {
	case *ir.IntConst:
		return fmt.Sprintf("%d", e.V)
	case *ir.StrConst:
		return fmt.Sprintf("clar_lit_%d", e.Idx)
	case *ir.VarRef:
		return "cv_" + e.Name
	case *ir.FieldRef:
		return fmt.Sprintf("(%s).cv_%s", fp.expr(e.X), e.Name)
	case *ir.IndexRef:
		return fp.indexRef(e)
	case *ir.Bin:
		return fmt.Sprintf("(%s %s %s)", fp.expr(e.X), cOp(e.Op), fp.expr(e.Y))
	case *ir.Un:
		return fp.un(e)
	case *ir.Conv:
		return fp.conv(e)
	case *ir.CallFn:
		return fp.callFn(e)
	case *ir.Intr:
		return fp.intrCall(e)
	case *ir.NewRec:
		return fmt.Sprintf("clar_new_%s()", e.RecName)
	default:
		panic(fmt.Sprintf("cprint: unhandled expression %T", e))
	}
}

// cOp maps a Bin/Un op string to its C spelling: and/or short-circuit as
// &&/||, mod as %, everything else (+ - * / & | ^ << >> == != < <= > >=)
// passes straight through.
func cOp(op string) string {
	switch op {
	case "and":
		return "&&"
	case "or":
		return "||"
	case "mod":
		return "%"
	default:
		return op
	}
}

func (fp *funcPrinter) un(e *ir.Un) string {
	x := fp.expr(e.X)
	switch e.Op {
	case "-":
		return fmt.Sprintf("(-(%s))", x)
	case "not":
		return fmt.Sprintf("(!(%s))", x)
	case "~":
		return fmt.Sprintf("(~(%s))", x)
	default:
		panic(fmt.Sprintf("cprint: unhandled unary op %q", e.Op))
	}
}

// conv prints a Conv node. IntToFixed/FixedToInt avoid a raw `<<`/plain
// arithmetic-shift on a possibly-negative value (UB pre-C99's defined
// division semantics aside — see rt_fix_div's own comment on the same
// issue) by multiplying/dividing by 65536 instead; C99 integer division
// truncates toward zero, exactly Ch3's "int(f) ... truncates toward zero".
func (fp *funcPrinter) conv(e *ir.Conv) string {
	x := fp.expr(e.X)
	switch e.Op {
	case ir.IntToFixed:
		return fmt.Sprintf("((int32_t)((int64_t)(%s) * 65536))", x)
	case ir.FixedToInt:
		return fmt.Sprintf("((int32_t)((%s) / 65536))", x)
	case ir.IntToChar:
		return fmt.Sprintf("((uint8_t)(%s))", x)
	case ir.CharToInt, ir.EnumToInt:
		return fmt.Sprintf("((int32_t)(%s))", x)
	case ir.IntToEnum:
		n := fp.pr.enumCount(e.EnumName)
		return fmt.Sprintf("rt_enum_from_int(clar_enum_%s, %d, (%s))", e.EnumName, n, x)
	default:
		panic(fmt.Sprintf("cprint: unhandled conv op %v", e.Op))
	}
}

func (pr *printer) enumCount(name string) int {
	for _, el := range pr.prog.Enums {
		if el.Name == name {
			return len(el.Values)
		}
	}
	panic(fmt.Sprintf("cprint: unknown enum %q", name))
}

func (fp *funcPrinter) callFn(e *ir.CallFn) string {
	args := make([]string, len(e.Args))
	for i, a := range e.Args {
		args[i] = fp.expr(a)
	}
	return fmt.Sprintf("clar_fn_%s(%s)", e.Name, strings.Join(args, ", "))
}

// indexRef implements the ir.IndexRef printer contract: Arr indexing is a
// bounds-checked plain C array access; List indexing (shared node — see
// ir.IndexRef's doc comment) dereferences rt_list_at's element pointer.
func (fp *funcPrinter) indexRef(e *ir.IndexRef) string {
	xt := e.X.Type()
	switch xt.K {
	case ir.Arr:
		x, i := fp.expr(e.X), fp.expr(e.I)
		return fmt.Sprintf("(%s).e[rt_arr_check((int32_t)(%s), %d)]", x, i, xt.N)
	case ir.List:
		x, i := fp.expr(e.X), fp.expr(e.I)
		elemC := fp.pr.cType(e.Ty)
		return fmt.Sprintf("(*(%s*)rt_list_at(%s, (int32_t)(%s)))", elemC, x, i)
	default:
		panic(fmt.Sprintf("cprint: IndexRef over unsupported kind %v", xt.K))
	}
}
