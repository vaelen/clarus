package cprint

import (
	"fmt"
	"strings"

	"clarus/internal/ir"
)

// defaultInit renders the statement(s) that assign t's default value into
// the already-declared lvalue dst (a plain C expression string — "cv_x",
// "r.cv_field", ...), indented at the given level. It's the single code
// path both clar_new_NAME (record field defaults, scalarDefault/strDefault
// from the field's RecordLayout slot) and nil-Init global/local
// initialization (scalarDefault 0, strDefault -1: no override, use the
// type's own zero/empty/fresh-handle value) go through — a nil-Init Rec
// value gets the SAME per-field defaults as clar_new_NAME because this
// function's own ir.Rec case just calls clar_new_NAME too.
//
// Heap-handle types (text/list/map) get a fresh empty handle rather than a
// null pointer: Ch3's `var visitors: list of Person` is immediately usable
// (push, count, ...) with no explicit initializer, so the printer must
// supply the handle nil-Init leaves implicit.
func (pr *printer) defaultInit(dst string, t ir.Type, scalarDefault int64, strDefault int, indent int) string {
	ind := strings.Repeat("    ", indent)
	switch t.K {
	case ir.Int, ir.Bool, ir.Fixed, ir.Char, ir.Enum:
		return fmt.Sprintf("%s%s = %d;\n", ind, dst, scalarDefault)
	case ir.Str:
		if strDefault < 0 {
			return fmt.Sprintf("%s%s = (%s){0};\n", ind, dst, cTypeName(t))
		}
		return fmt.Sprintf("%srt_str_store((uint8_t*)&(%s), %d, (const uint8_t*)&clar_lit_%d);\n", ind, dst, t.N, strDefault)
	case ir.Text:
		return fmt.Sprintf("%s%s = rt_text_new();\n", ind, dst)
	case ir.List:
		return fmt.Sprintf("%s%s = rt_list_new(sizeof(%s));\n", ind, dst, cTypeName(*t.Elem))
	case ir.Map:
		return fmt.Sprintf("%s%s = rt_map_new(sizeof(%s));\n", ind, dst, cTypeName(*t.Elem))
	case ir.Rec:
		return fmt.Sprintf("%s%s = clar_new_%s();\n", ind, dst, t.Name)
	case ir.Err:
		return fmt.Sprintf("%s%s.code = 0;\n%s%s.message = (clar_str_255){0};\n", ind, dst, ind, dst)
	case ir.Arr:
		pr.loopN++
		v := fmt.Sprintf("ix%d", pr.loopN)
		var b strings.Builder
		b.WriteString(fmt.Sprintf("%sfor (int32_t %s = 0; %s < %d; %s++) {\n", ind, v, v, t.N, v))
		b.WriteString(pr.defaultInit(fmt.Sprintf("%s.e[%s]", dst, v), *t.Elem, 0, -1, indent+1))
		b.WriteString(fmt.Sprintf("%s}\n", ind))
		return b.String()
	default:
		panic(fmt.Sprintf("cprint: no default-init for type kind %v", t.K))
	}
}
