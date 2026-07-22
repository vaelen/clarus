package cprint

import (
	"fmt"

	"clarus/internal/ir"
)

// typeEqual is a shallow structural comparison — sufficient for the local
// redeclaration check (cprint.go's emitFunc), which only ever compares
// types that both came from the same lowering pass.
func typeEqual(a, b ir.Type) bool {
	if a.K != b.K || a.N != b.N || a.Name != b.Name {
		return false
	}
	if (a.Elem == nil) != (b.Elem == nil) {
		return false
	}
	if a.Elem != nil {
		return typeEqual(*a.Elem, *b.Elem)
	}
	return true
}

// cTypeName is a pure function of t: the C type name a given ir.Type prints
// as, with no side effects. Whether the typedef that name refers to
// (clar_str_N, clar_arr_...) has actually been emitted yet is a *separate*
// concern — see (*printer).cType/ensureType, which must be called at every
// site that also needs the typedef to exist.
func cTypeName(t ir.Type) string {
	switch t.K {
	case ir.Void:
		return "void"
	case ir.Int, ir.Bool, ir.Fixed, ir.Enum:
		return "int32_t"
	case ir.Char:
		return "uint8_t"
	case ir.Str:
		return fmt.Sprintf("clar_str_%d", t.N)
	case ir.Text:
		return "rt_text *"
	case ir.List:
		return "rt_list *"
	case ir.Map:
		return "rt_map *"
	case ir.Rec:
		return "clar_rec_" + t.Name
	case ir.Err:
		return "clar_rec_Err"
	case ir.Arr:
		return "clar_arr_" + arrKey(t)
	default:
		panic(fmt.Sprintf("cprint: type kind %v has no C representation", t.K))
	}
}

// arrKey names one Arr type's wrapper typedef, distinct per (element shape,
// length) pair.
func arrKey(t ir.Type) string {
	return fmt.Sprintf("%s_%d", elemKey(*t.Elem), t.N)
}

// elemKey renders t as an identifier fragment, for composing arrKey.
func elemKey(t ir.Type) string {
	switch t.K {
	case ir.Int:
		return "int"
	case ir.Bool:
		return "bool"
	case ir.Fixed:
		return "fixed"
	case ir.Char:
		return "char"
	case ir.Str:
		return fmt.Sprintf("str%d", t.N)
	case ir.Text:
		return "text"
	case ir.List:
		return "list"
	case ir.Map:
		return "map"
	case ir.Rec:
		return "rec_" + t.Name
	case ir.Enum:
		return "enum_" + t.Name
	case ir.Err:
		return "err"
	case ir.Arr:
		return "arr_" + arrKey(t)
	default:
		panic(fmt.Sprintf("cprint: type kind %v has no element-key representation", t.K))
	}
}

// cType returns t's C type name, first lazily emitting any typedef it
// depends on (a clar_str_N capacity, or a clar_arr_* wrapper struct) that
// hasn't been seen yet. Side-effecting on purpose: it may be called from
// deep inside function-body printing, the first time some capacity or array
// shape appears anywhere in the program — the typedef itself always lands
// in typeBuf (a separate buffer assembled before everything else in Emit),
// so where in program order the call happens never affects final placement.
func (pr *printer) cType(t ir.Type) string {
	pr.ensureType(t)
	return cTypeName(t)
}

// ensureType lazily emits whatever typedef(s) t depends on. Rec is
// deliberately not handled here: record structs are emitted by
// emitRecords in declaration order, and every Rec type ensureType ever
// sees (a field type, a var type) refers to an already-declared record
// (Clarus requires declare-before-use for record types), so nothing here
// needs to trigger it.
func (pr *printer) ensureType(t ir.Type) {
	switch t.K {
	case ir.Str:
		pr.ensureStr(t.N)
	case ir.Arr:
		pr.ensureArr(t)
	case ir.List, ir.Map:
		pr.ensureType(*t.Elem)
	}
}

func (pr *printer) ensureStr(n int) {
	if pr.strCapsEmitted[n] {
		return
	}
	pr.strCapsEmitted[n] = true
	pr.typeBuf.WriteString(fmt.Sprintf("typedef struct { uint8_t len; uint8_t b[%d]; } clar_str_%d;\n", n, n))
}

// zeroLiteral renders a type-correct placeholder value for t, for the
// unreachable trailing `return` cprint.go's emitFunc appends after every
// non-void function body (see its call site for why).
func zeroLiteral(t ir.Type) string {
	switch t.K {
	case ir.Text, ir.List, ir.Map:
		return "NULL"
	case ir.Rec:
		return fmt.Sprintf("clar_new_%s()", t.Name)
	case ir.Str, ir.Arr, ir.Err:
		return fmt.Sprintf("(%s){0}", cTypeName(t))
	default:
		return "0"
	}
}

// ensureArr lazily emits t's clar_arr_<elem>_<N> wrapper typedef, first
// ensuring its element type's own typedef (if any). Written into recBuf,
// not typeBuf: unlike a clar_str_N typedef (no dependencies, always safe
// early), an array of records needs that record's struct already defined,
// and record structs only exist in recBuf — which is emitted strictly
// after typeBuf/litBuf in Emit's final assembly. Every call site that can
// reach ensureArr (a record field, in emitRecords' declaration-order loop;
// a global/local/param type, only processed after emitRecords finishes)
// only ever needs records that are already appended to recBuf by the time
// it runs, so a plain append here is always correctly ordered. A
// non-record element (scalar/Str) has no such requirement, but recBuf
// works fine for it too.
func (pr *printer) ensureArr(t ir.Type) string {
	name := cTypeName(t)
	if pr.arrEmitted[name] {
		return name
	}
	pr.arrEmitted[name] = true
	pr.ensureType(*t.Elem)
	elemC := cTypeName(*t.Elem)
	pr.recBuf.WriteString(fmt.Sprintf("typedef struct { %s e[%d]; } %s;\n", elemC, t.N, name))
	return name
}
