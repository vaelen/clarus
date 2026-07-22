package cprint

import (
	"fmt"

	"clarus/internal/ir"
)

// intrCall prints one ir.Intr call. Every rt_* function whose result comes
// back through an out-parameter (concat, list pop/shift/first/last, map
// get/get_dv, text concat, ...) is materialized into a fresh statement-level
// temp here and its name returned; pure value-returning rt_* calls (len,
// cmp, count, has, fix_mul/div, ...) are embedded directly with no temp,
// since C already lets them nest safely. Void operations (alert, quit, the
// set/push/remove family) emit their call as a statement and return "" —
// see (*funcPrinter).stmt's ExprStmt case, the only context they appear in.
func (fp *funcPrinter) intrCall(x *ir.Intr) string {
	switch x.Name {
	case ir.IAlert:
		fp.emit("rt_alert(%s);", fp.strAddr(x.Args[0]))
		return ""
	case ir.IQuit:
		fp.emit("rt_quit();")
		return ""

	// ---- strings ----
	case ir.IStrConcat:
		a, b := fp.strAddr(x.Args[0]), fp.strAddr(x.Args[1])
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_str_concat((uint8_t*)&%s, %s, %s);", t, a, b)
		return t
	case ir.IStrConcatChar:
		a, c := fp.strAddr(x.Args[0]), fp.expr(x.Args[1])
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_str_concat_char((uint8_t*)&%s, %s, (uint8_t)(%s));", t, a, c)
		return t
	case ir.IStrCmp:
		return fmt.Sprintf("rt_str_cmp(%s, %s)", fp.strAddr(x.Args[0]), fp.strAddr(x.Args[1]))
	case ir.IStrLen:
		return fmt.Sprintf("rt_str_len(%s)", fp.strAddr(x.Args[0]))
	case ir.IStrIndex:
		return fmt.Sprintf("rt_str_index(%s, (int32_t)(%s))", fp.strAddr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.IStrSetIndex:
		s, i, c := fp.addrable(x.Args[0]), fp.expr(x.Args[1]), fp.expr(x.Args[2])
		fp.emit("rt_str_set_index((uint8_t*)&(%s), (int32_t)(%s), (uint8_t)(%s));", s, i, c)
		return ""
	case ir.IStrFromBytes:
		dst, dstcap := fp.addrable(x.Args[0]), x.Args[0].Type().N
		buf, bufcap := fp.addrable(x.Args[1]), x.Args[1].Type().N
		cnt := fp.expr(x.Args[2])
		fp.emit("rt_str_from_bytes((uint8_t*)&(%s), %d, (const uint8_t*)(%s).e, %d, (int32_t)(%s));", dst, dstcap, buf, bufcap, cnt)
		return ""
	case ir.IStrToBytes:
		src := fp.strAddr(x.Args[0])
		buf, bufcap := fp.addrable(x.Args[1]), x.Args[1].Type().N
		return fmt.Sprintf("rt_str_to_bytes(%s, (uint8_t*)(%s).e, %d)", src, buf, bufcap)

	// ---- text ----
	case ir.ITextCmp:
		return fp.textCmp(x.Args[0], x.Args[1])
	case ir.ITextConcat:
		return fp.textConcat(x.Args[0], x.Args[1])
	case ir.ITextLen:
		return fmt.Sprintf("rt_text_len(%s)", fp.expr(x.Args[0]))
	case ir.ITextIndex:
		return fmt.Sprintf("rt_text_index(%s, (int32_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.ITextSetIndex:
		t, i, c := fp.expr(x.Args[0]), fp.expr(x.Args[1]), fp.expr(x.Args[2])
		fp.emit("rt_text_set_index(%s, (int32_t)(%s), (uint8_t)(%s));", t, i, c)
		return ""
	case ir.ITextFromBytes:
		t := fp.expr(x.Args[0])
		buf, bufcap := fp.addrable(x.Args[1]), x.Args[1].Type().N
		cnt := fp.expr(x.Args[2])
		fp.emit("rt_text_from_bytes(%s, (const uint8_t*)(%s).e, %d, (int32_t)(%s));", t, buf, bufcap, cnt)
		return ""
	case ir.ITextToBytes:
		t := fp.expr(x.Args[0])
		buf, bufcap := fp.addrable(x.Args[1]), x.Args[1].Type().N
		return fmt.Sprintf("rt_text_to_bytes(%s, (uint8_t*)(%s).e, %d)", t, buf, bufcap)

	// ---- fixed ----
	case ir.IFixMul:
		return fmt.Sprintf("rt_fix_mul((int32_t)(%s), (int32_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.IFixDiv:
		return fmt.Sprintf("rt_fix_div((int32_t)(%s), (int32_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))

	// ---- list ----
	case ir.IListPush, ir.IListUnshift:
		l, v := fp.expr(x.Args[0]), fp.addrable(x.Args[1])
		fn := "rt_list_push"
		if x.Name == ir.IListUnshift {
			fn = "rt_list_unshift"
		}
		fp.emit("%s(%s, &(%s));", fn, l, v)
		return ""
	case ir.IListPop, ir.IListShift, ir.IListFirst, ir.IListLast:
		l := fp.expr(x.Args[0])
		t := fp.newTmp(fp.pr.cType(x.Ty))
		fp.emit("%s(%s, &%s);", listOutFn[x.Name], l, t)
		return t
	case ir.IListRemove:
		fp.emit("rt_list_remove(%s, (int32_t)(%s));", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
		return ""
	case ir.IListCount:
		return fmt.Sprintf("rt_list_count(%s)", fp.expr(x.Args[0]))

	// ---- map ----
	case ir.IMapSet:
		m, k, v := fp.expr(x.Args[0]), fp.strAddr(x.Args[1]), fp.addrable(x.Args[2])
		fp.emit("rt_map_set(%s, %s, &(%s));", m, k, v)
		return ""
	case ir.IMapGet:
		m, k := fp.expr(x.Args[0]), fp.strAddr(x.Args[1])
		t := fp.newTmp(fp.pr.cType(x.Ty))
		fp.emit("rt_map_get(%s, %s, &%s);", m, k, t)
		return t
	case ir.IMapGetDv:
		m, k, dv := fp.expr(x.Args[0]), fp.strAddr(x.Args[1]), fp.expr(x.Args[2])
		t := fp.newTmp(fp.pr.cType(x.Ty))
		fp.emit("%s = %s;", t, dv) // pre-fill with the default; get_dv leaves it untouched if absent
		fp.emit("rt_map_get_dv(%s, %s, &%s);", m, k, t)
		return t
	case ir.IMapHas:
		return fmt.Sprintf("rt_map_has(%s, %s)", fp.expr(x.Args[0]), fp.strAddr(x.Args[1]))
	case ir.IMapRemove:
		fp.emit("rt_map_remove(%s, %s);", fp.expr(x.Args[0]), fp.strAddr(x.Args[1]))
		return ""
	case ir.IMapCount:
		return fmt.Sprintf("rt_map_count(%s)", fp.expr(x.Args[0]))

	// ---- misc ----
	case ir.ILastErrCode:
		return "rt_lasterr_code"
	case ir.ILastErrMsg:
		// rt_lasterr_msg is a raw uint8_t[256] (rt.h), not a clar_str_255
		// struct — copy it into a proper temp via rt_str_store rather than
		// exposing the type mismatch to callers.
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_str_store((uint8_t*)&%s, 255, rt_lasterr_msg);", t)
		return t

	// ---- files (Task 13 implements the matching rt_file_* runtime; the
	// printer only needs to agree on the calling convention now) ----
	case ir.IFileReadText:
		return fmt.Sprintf("rt_file_read_text(%s, %s)", fp.strAddr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.IFileWriteText:
		return fmt.Sprintf("rt_file_write_text(%s, %s)", fp.strAddr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.IFileName:
		p := fp.strAddr(x.Args[0])
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_file_name((uint8_t*)&%s, %s);", t, p)
		return t

	default:
		panic(fmt.Sprintf("cprint: unhandled intrinsic %s", x.Name))
	}
}

var listOutFn = map[string]string{
	ir.IListPop:   "rt_list_pop",
	ir.IListShift: "rt_list_shift",
	ir.IListFirst: "rt_list_first",
	ir.IListLast:  "rt_list_last",
}

// textCmp handles text/text, text/string, and string/text comparisons.
// rt_text_cmp_str only knows (text, string); a string on the left needs the
// call flipped and its sign negated to preserve `a < b` orientation.
func (fp *funcPrinter) textCmp(a, b ir.Expr) string {
	at, bt := a.Type(), b.Type()
	switch {
	case at.K == ir.Text && bt.K == ir.Text:
		return fmt.Sprintf("rt_text_cmp(%s, %s)", fp.expr(a), fp.expr(b))
	case at.K == ir.Text && bt.K == ir.Str:
		return fmt.Sprintf("rt_text_cmp_str(%s, %s)", fp.expr(a), fp.strAddr(b))
	case at.K == ir.Str && bt.K == ir.Text:
		return fmt.Sprintf("(-rt_text_cmp_str(%s, %s))", fp.expr(b), fp.strAddr(a))
	default:
		panic(fmt.Sprintf("cprint: text_cmp on kinds %v/%v", at.K, bt.K))
	}
}

// textConcat allocates a fresh rt_text handle for the `text + (text|string)`
// result (text has reference semantics, but `+` always produces a new
// value — Ch3), then concatenates a and b into it.
func (fp *funcPrinter) textConcat(a, b ir.Expr) string {
	ae := fp.expr(a)
	t := fp.newTmp("rt_text *")
	fp.emit("%s = rt_text_new();", t)
	if b.Type().K == ir.Str {
		fp.emit("rt_text_concat(%s, %s, %s, NULL);", t, ae, fp.strAddr(b))
	} else {
		fp.emit("rt_text_concat(%s, %s, NULL, %s);", t, ae, fp.expr(b))
	}
	return t
}
