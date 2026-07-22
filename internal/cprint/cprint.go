// Package cprint walks a lowered *ir.Program (internal/ir) into one
// self-contained C99 translation unit that #includes "rt.h" and links
// against runtime/host/rt.c (Task 4/5's host runtime).
//
// # Name mangling
//
//   - user functions and App handlers: clar_fn_NAME (ir.Func.Name, e.g.
//     clar_fn_handler_App_launch)
//   - record struct types:            clar_rec_NAME
//   - record default constructors:    clar_new_NAME (ir.NewRec's contract:
//     returns the struct BY VALUE, every field at its RecordLayout default)
//   - string-literal pool entries:    clar_lit_K (K = index into
//     ir.Program.StrLits)
//   - per-capacity string typedefs:   clar_str_N ({uint8_t len; uint8_t
//     b[N];}), one per distinct capacity actually used anywhere in the
//     program (always includes 255: the literal pool and every
//     intrinsic string result — concat et al — materialize into a
//     clar_str_255 temp)
//   - enum value tables:              clar_enum_NAME (a static const
//     int32_t[]; clar_enum_NAME_count alongside it), consulted by
//     rt_enum_from_int for the checked EnumType(i) conversion
//   - fixed-size array wrapper types: clar_arr_<elem>_<N> ({ElemT e[N];}) —
//     arrays need a named struct (not a bare C array) so whole-array
//     assignment can print as plain C struct assignment (Ch3: fixed arrays
//     are value types); IndexRef over an Arr therefore prints
//     `X.e[rt_arr_check(i, N)]`.
//   - Clarus variables (locals, params, globals):  cv_NAME
//
// # Value vs. reference types
//
// int/bool/fixed/char/enum print as int32_t/int32_t/int32_t/uint8_t/int32_t.
// string(n) prints as clar_str_n (a value struct — assignment/copy is a
// clamped rt_str_store, never plain C `=`). record and fixed-array values
// print as plain C structs; `=` between them is a real C struct assignment,
// matching Ch3's by-value semantics. text/list/map print as the raw
// rt_text*/rt_list*/rt_map* handle; `=` between them is a plain pointer
// copy, matching Ch3's reference semantics.
//
// # Statement-level temporaries for intrinsic string results
//
// Every rt_* function that "returns" a string or record-shaped value
// actually does so through an out-parameter (rt_str_concat, rt_list_pop,
// rt_map_get, ...) — there is no way to embed such a call as a nested C
// subexpression. The printer never nests one: whenever an ir.Intr call
// requires an out-param, it first declares a local `TYPE tN;` at the
// current statement position, emits the out-param call as its own
// statement, and uses `tN` wherever the caller needed the intrinsic's
// value (including as the Src operand of a StoreStr — a concat's result
// is always a named clar_str_255 temp by the time StoreStr's rt_str_store
// call is printed, never a raw nested rt_str_concat(...) call). Pure
// value-returning rt_* calls (rt_str_len, rt_str_cmp, rt_fix_mul, ...) are
// embedded directly with no temp, since C already lets them nest safely.
//
// # IndexRef printer contract (see ir.IndexRef's doc comment)
//
// `l[i]` where l is a List shares the IndexRef node with real array
// indexing; the printer tells them apart by X's type: over an Arr it
// prints `X.e[rt_arr_check(i, N)]` (bounds-checked C array access), over a
// List it prints `(*(ElemT*)rt_list_at(l, i))` (both reads and in-place
// writes go through the same dereferenced-pointer expression). Per
// rt_list_at's CONTRACT comment in rt.c, that pointer is invalidated by any
// subsequent mutation of the same list — the printer never holds it across
// statements, only within the single expression it's part of.
//
// # Operators
//
// `and`/`or` short-circuit, per the language spec — see "and/or:
// conditional RHS expansion" below for how that's actually achieved; `not`
// prints as `!`; `~` as `~`; every other Bin op string (+, -, *, /, mod, &,
// |, ^, <<, >>, ==, !=, <, <=, >, >=) maps directly to the same C operator
// (mod -> %). Fixed +/- are plain int32 adds/subs (fixed is a raw scaled
// int32); fixed *,/ always arrive as ir.Intr(IFixMul/IFixDiv), never ir.Bin.
//
// # and/or: conditional RHS expansion
//
// A plain `X && Y` / `X || Y` is only correct C when neither operand's
// *printing* has side effects — but printing an operand can itself emit
// statements (a temp declaration + assignment) ahead of the expression, per
// the "statement-level temporaries" section above. If those emits happened
// unconditionally for the RHS, short-circuiting would be a lie: the RHS's
// side effects (e.g. a function call materialized so its address can be
// taken) would run even when the LHS already decided the outcome (Critical
// review finding: `left() == "aa" or right() == "bb"` was calling right()
// even when left() alone made the `or` true).
//
// funcPrinter.andOr fixes this by speculatively printing the RHS into an
// isolated buffer first (captureExpr) to see whether it needed any
// statements. If not, the plain form is still used — no churn for the
// common case (e.g. two bool locals: `cv_a && cv_b`). If it did, the RHS's
// statements move inside an `if`, guarded by the already-evaluated
// (unconditional — the LHS always evaluates) LHS:
//
//	int32_t tN;
//	tN = <lhs>;
//	if (!tN) {              // "or"; "if (tN)" for "and"
//	    <rhs's statement-level temps>
//	    tN = <rhs>;
//	}
//
// with tN as the expression's value. Nested and/or chains compose for
// free: each side prints through the normal expr() dispatch, so a Y that is
// itself an and/or recurses through andOr again, each level guarded by its
// own if.
//
// # List/map-mutating intrinsics: never alias the container's own storage
//
// rt_list_push/unshift and rt_map_set can realloc their target's backing
// store mid-call (rt.c's `grow`). addrable's normal "already an lvalue,
// print as-is" shortcut for a List-kind IndexRef (`l[i]`, which dereferences
// rt_list_at — see rt_list_at's CONTRACT comment in rt.c) is therefore
// unsafe as the *value* argument to one of these calls: `l.push(l[0])`
// naively prints as `rt_list_push(l, &(*(T*)rt_list_at(l, 0)))`, and push's
// own realloc can free that pointer's block before push's memmove reads it
// (Critical review finding, ASan-confirmed heap-use-after-free). Every
// list/map-growing intrinsic's value argument therefore goes through
// copyToTemp instead of addrable: it always materializes into a fresh,
// stable local first, regardless of whether the source expression happened
// to be addressable in place. (map subscript, `m[k]`, isn't an IndexRef at
// all — it lowers to the map_get intrinsic, which already always
// materializes into its own temp — so this same hazard doesn't reach
// map_set's value argument via that path either way.)
package cprint

import (
	"fmt"
	"strings"

	"clarus/internal/ir"
)

// printer holds the whole-program emission state: three separately-grown
// buffers assembled in a fixed final order (typeBuf can gain a new
// clar_str_N/clar_arr_* typedef at ANY point during emission — including
// deep inside a function body, the first time an unseen type is touched —
// so it can never share a buffer with something that must stay in program
// order; see cType/ensureType).
type printer struct {
	prog *ir.Program

	typeBuf strings.Builder // string-capacity + array-wrapper typedefs
	litBuf  strings.Builder // string-literal pool (must precede recBuf: a record's
	// clar_new_NAME may reference clar_lit_K for a string field default)
	recBuf  strings.Builder // record structs + clar_new_NAME constructors
	restBuf strings.Builder // enum tables, globals, funcs, main

	strCapsEmitted map[int]bool
	arrEmitted     map[string]bool

	loopN int // counter for default-init loop variable names (array defaults)
}

// Emit renders p as one C99 translation unit.
func Emit(p *ir.Program) []byte {
	pr := &printer{
		prog:           p,
		strCapsEmitted: map[int]bool{},
		arrEmitted:     map[string]bool{},
	}
	pr.ensureStr(255) // literal pool + every intrinsic string temp use this
	pr.recBuf.WriteString("typedef struct { int32_t code; clar_str_255 message; } clar_rec_Err;\n\n")

	pr.emitStrLits()
	pr.emitRecords()
	pr.emitEnums()
	pr.emitGlobalsAndInit()
	pr.emitFuncs()
	pr.emitMain()

	var out strings.Builder
	out.WriteString("/* Generated by clarus (internal/cprint). Do not edit. */\n")
	out.WriteString("#include \"rt.h\"\n")
	out.WriteString("#include <stddef.h> /* NULL, used by rt_text_concat's bstr/btext args */\n\n")
	out.WriteString(pr.typeBuf.String())
	out.WriteString("\n")
	out.WriteString(pr.litBuf.String())
	out.WriteString("\n")
	out.WriteString(pr.recBuf.String())
	out.WriteString("\n")
	out.WriteString(pr.restBuf.String())
	return []byte(out.String())
}

// emitRecords prints every record struct (and its clar_new_NAME
// constructor) in declaration order. Clarus requires declare-before-use for
// record-typed fields, so any nested record a field refers to was already
// fully emitted by an earlier iteration of this same loop — ensureType's
// lazy array-wrapper emission (for Arr-typed fields) can safely assume that.
func (pr *printer) emitRecords() {
	for _, rl := range pr.prog.Records {
		for _, f := range rl.Fields {
			pr.ensureType(f.T)
		}
		ctype := cTypeName(ir.Type{K: ir.Rec, Name: rl.Name})
		pr.recBuf.WriteString("typedef struct {\n")
		for _, f := range rl.Fields {
			pr.recBuf.WriteString(fmt.Sprintf("    %s cv_%s;\n", pr.cType(f.T), f.Name))
		}
		pr.recBuf.WriteString(fmt.Sprintf("} %s;\n", ctype))

		pr.recBuf.WriteString(fmt.Sprintf("static %s clar_new_%s(void) {\n", ctype, rl.Name))
		pr.recBuf.WriteString(fmt.Sprintf("    %s r;\n", ctype))
		for _, f := range rl.Fields {
			pr.recBuf.WriteString(pr.defaultInit("r.cv_"+f.Name, f.T, f.Default, f.DefaultStr, 1))
		}
		pr.recBuf.WriteString("    return r;\n}\n\n")
	}
}

// emitEnums prints each enum's value table (for the checked int->enum
// conversion, rt_enum_from_int) plus a matching _count constant. Marked
// __attribute__((unused)): a program that declares an enum but never runs a
// checked EnumType(i) conversion on it would otherwise fail
// -Wunused-const-variable under -Werror. __attribute__ is a GCC/Clang
// extension tolerated under -std=c99 (it doesn't relax standard
// conformance, just adds vocabulary); both are what "cc" resolves to on
// every host build platform mentioned in the plan.
func (pr *printer) emitEnums() {
	for _, el := range pr.prog.Enums {
		vals := make([]string, len(el.Values))
		for i, v := range el.Values {
			vals[i] = fmt.Sprintf("%d", v)
		}
		pr.restBuf.WriteString(fmt.Sprintf("static const int32_t clar_enum_%s[] __attribute__((unused)) = {%s};\n", el.Name, strings.Join(vals, ", ")))
		pr.restBuf.WriteString(fmt.Sprintf("static const int clar_enum_%s_count __attribute__((unused)) = %d;\n", el.Name, len(el.Values)))
	}
	pr.restBuf.WriteString("\n")
}

// emitStrLits prints the interned string-literal pool as clar_str_255
// constants (StrConst.Idx indexes this by construction — every string
// literal lowers with Ty.N == 255).
func (pr *printer) emitStrLits() {
	for i, s := range pr.prog.StrLits {
		b := []byte(s)
		bytes := make([]string, len(b))
		for j, c := range b {
			bytes[j] = fmt.Sprintf("%d", c)
		}
		pr.litBuf.WriteString(fmt.Sprintf("static const clar_str_255 clar_lit_%d = {%d, {%s}};\n", i, len(b), strings.Join(bytes, ", ")))
	}
	pr.litBuf.WriteString("\n")
}

// emitGlobalsAndInit declares every global as a bare (uninitialized-in-C)
// file-scope variable, then defines clar_init_globals, which applies each
// one's default (RecordLayout defaults for a nil-Init Rec; the type's zero/
// empty value for anything else nil-Init) followed by its explicit Init
// expression, if any, in Program.Globals order (== declaration order).
// Globals can't be given real C initializers at file scope: several of
// their defaults (clar_new_NAME, rt_list_new, ...) are function calls, and
// C requires file-scope initializers to be constant expressions.
func (pr *printer) emitGlobalsAndInit() {
	for _, g := range pr.prog.Globals {
		pr.ensureType(g.T)
		pr.restBuf.WriteString(fmt.Sprintf("static %s cv_%s;\n", pr.cType(g.T), g.Name))
	}
	pr.restBuf.WriteString("\nstatic void clar_init_globals(void) {\n")
	for _, g := range pr.prog.Globals {
		pr.restBuf.WriteString(pr.defaultInit("cv_"+g.Name, g.T, 0, -1, 1))
		if g.Init != nil {
			fp := newFuncPrinter(pr, 1)
			dst := &ir.VarRef{Name: g.Name, Global: true, Ty: g.T}
			if g.T.K == ir.Str {
				fp.storeStr(dst, g.Init)
			} else {
				d := fp.expr(dst)
				v := fp.expr(g.Init)
				fp.emit("%s = %s;", d, v)
			}
			pr.restBuf.WriteString(fp.body.String())
		}
	}
	pr.restBuf.WriteString("}\n\n")
}

// emitFuncs prints every function/handler's prototype (all up front, so
// mutual recursion and call-before-definition order never matter) followed
// by its full definition.
func (pr *printer) emitFuncs() {
	for _, f := range pr.prog.Funcs {
		pr.restBuf.WriteString(pr.funcProto(f) + ";\n")
	}
	pr.restBuf.WriteString("\n")
	for _, f := range pr.prog.Funcs {
		pr.emitFunc(f)
	}
}

func (pr *printer) funcProto(f *ir.Func) string {
	params := make([]string, len(f.Params))
	for i, p := range f.Params {
		pr.ensureType(p.T)
		params[i] = fmt.Sprintf("%s cv_%s", pr.cType(p.T), p.Name)
	}
	if len(params) == 0 {
		params = []string{"void"}
	}
	pr.ensureType(f.Ret)
	return fmt.Sprintf("static %s clar_fn_%s(%s)", pr.cType(f.Ret), f.Name, strings.Join(params, ", "))
}

func (pr *printer) emitFunc(f *ir.Func) {
	pr.ensureType(f.Ret) // funcProto (prototypes pass) already did this, but emitFunc may reference cTypeName(f.Ret) before calling funcProto below
	fp := newFuncPrinter(pr, 1)
	// Every local (var-declared, or a for-loop's bound variable) is
	// hoisted to the top of the C function, per Ch5's "var only at the
	// top of a function/handler body" restriction (the parser already
	// enforces this — lower.go's f.Locals is exactly that flat list, plus
	// for-loop V1/V2 bindings the lowerer appends alongside them). Two
	// sibling (non-nested, non-overlapping) for-loops reusing the same
	// bound-variable name is legal Clarus and common style; declaring the
	// shared C variable once and reusing it across both loops is
	// semantically identical to two independent loops in C, so duplicate
	// (name, same-type) entries just skip re-declaration. A genuine
	// same-name/different-type collision (rare, and not exercised by any
	// program this compiler currently builds) is a real ambiguity in a
	// flat-by-name IR and is reported loudly rather than silently
	// miscompiled.
	declared := map[string]ir.Type{}
	for _, loc := range f.Locals {
		if prev, ok := declared[loc.Name]; ok {
			if !typeEqual(prev, loc.T) {
				panic(fmt.Sprintf("cprint: local %q redeclared with a different type in func %s (unsupported: same name, different type, in sibling scopes)", loc.Name, f.Name))
			}
			continue
		}
		declared[loc.Name] = loc.T
		pr.ensureType(loc.T)
		fp.emit("%s cv_%s;", pr.cType(loc.T), loc.Name)
		fp.body.WriteString(pr.defaultInit("cv_"+loc.Name, loc.T, 0, -1, fp.indent))
	}
	fp.stmts(f.Body)
	// Every path through a well-formed Clarus function already returns (or
	// the function is void), but proving that from the C side is harder
	// than the Clarus checker's own analysis — an unconditional trailing
	// return sidesteps "control reaches end of non-void function"
	// (-Wreturn-type, part of -Wall) regardless. Dead code when the real
	// body already returns on every path; -Wall has no unreachable-code
	// warning to trip over it.
	if f.Ret.K != ir.Void {
		fp.emit("return %s;", zeroLiteral(f.Ret))
	}

	pr.restBuf.WriteString(pr.funcProto(f) + " {\n")
	pr.restBuf.WriteString(fp.body.String())
	pr.restBuf.WriteString("}\n\n")
}

// emitMain prints the fixed entry point: init globals, then App.launch (if
// declared), then App.startEmpty (if declared), then exit 0.
func (pr *printer) emitMain() {
	pr.restBuf.WriteString("int main(void) {\n")
	pr.restBuf.WriteString("    clar_init_globals();\n")
	if pr.prog.HasLaunch {
		pr.restBuf.WriteString("    clar_fn_handler_App_launch();\n")
	}
	if pr.prog.HasStartEmpty {
		pr.restBuf.WriteString("    clar_fn_handler_App_startEmpty();\n")
	}
	pr.restBuf.WriteString("    return 0;\n}\n")
}
