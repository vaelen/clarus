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
	case ir.ILog:
		fp.emit("rt_log(%s);", fp.strAddr(x.Args[0]))
		return ""
	case ir.IQuit:
		fp.emit("rt_quit((int32_t)(%s));", fp.expr(x.Args[0]))
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
	case ir.IStrCoerce:
		// Materializes x.Args[0] (any Str capacity) into a fresh temp at
		// x.Ty's (different) capacity via the same clamped rt_str_store
		// storeStr uses for a plain lvalue — see coerceStr's doc comment
		// (internal/lower/expr.go) for why this can't just be a plain `=`.
		src := fp.strAddr(x.Args[0])
		t := fp.newTmp(fp.pr.cType(x.Ty))
		fp.emit("rt_str_store((uint8_t*)&%s, %d, %s);", t, x.Ty.N, src)
		return t
	case ir.IStrSlice:
		s, start, ln := fp.strAddr(x.Args[0]), fp.expr(x.Args[1]), fp.expr(x.Args[2])
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_str_slice((uint8_t*)&%s, %s, (int32_t)(%s), (int32_t)(%s));", t, s, start, ln)
		return t
	case ir.IStrIndexOfStr:
		return fmt.Sprintf("rt_str_index_of_str(%s, %s)", fp.strAddr(x.Args[0]), fp.strAddr(x.Args[1]))
	case ir.IStrIndexOfChar:
		return fmt.Sprintf("rt_str_index_of_char(%s, (uint8_t)(%s))", fp.strAddr(x.Args[0]), fp.expr(x.Args[1]))

	// ---- text ----
	case ir.ITextCmp:
		return fp.textCmp(x.Args[0], x.Args[1])
	case ir.ITextConcat:
		return fp.textConcat(x.Args[0], x.Args[1])
	case ir.ITextStore:
		t, s := fp.expr(x.Args[0]), fp.strAddr(x.Args[1])
		fp.emit("rt_text_store(%s, %s);", t, s)
		return ""
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
	case ir.ITextSlice:
		t0, start, ln := fp.expr(x.Args[0]), fp.expr(x.Args[1]), fp.expr(x.Args[2])
		t := fp.newTmp("clar_str_255")
		fp.emit("rt_text_slice((uint8_t*)&%s, %s, (int32_t)(%s), (int32_t)(%s));", t, t0, start, ln)
		return t
	case ir.ITextIndexOfStr:
		return fmt.Sprintf("rt_text_index_of_str(%s, %s)", fp.expr(x.Args[0]), fp.strAddr(x.Args[1]))
	case ir.ITextIndexOfChar:
		return fmt.Sprintf("rt_text_index_of_char(%s, (uint8_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.ITextAppendStr:
		fp.emit("rt_text_append_str(%s, %s);", fp.expr(x.Args[0]), fp.strAddr(x.Args[1]))
		return ""
	case ir.ITextAppendChar:
		fp.emit("rt_text_append_char(%s, (uint8_t)(%s));", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
		return ""
	case ir.ITextAppendText:
		fp.emit("rt_text_append_text(%s, %s);", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
		return ""

	// ---- fixed ----
	case ir.IFixMul:
		return fmt.Sprintf("rt_fix_mul((int32_t)(%s), (int32_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))
	case ir.IFixDiv:
		return fmt.Sprintf("rt_fix_div((int32_t)(%s), (int32_t)(%s))", fp.expr(x.Args[0]), fp.expr(x.Args[1]))

	// ---- list ----
	case ir.IListPush, ir.IListUnshift:
		// v goes through copyToTemp, not addrable: push/unshift can realloc
		// l's backing store, and if v were instead a raw rt_list_at pointer
		// (addrable's IndexRef shortcut, e.g. `l.push(l[0])`), that realloc
		// could free it before this call's own memmove reads it.
		l, v := fp.expr(x.Args[0]), fp.copyToTemp(x.Args[1])
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
		// v goes through copyToTemp, not addrable, for the same reason as
		// list_push/unshift above: map_set grows m's key/value arrays on a
		// new key, so a raw rt_list_at-derived pointer passed as v (e.g.
		// `m.set(k, l[0])`) must be copied out before the call, not handed
		// in live. (m's own values never alias this way: map subscript
		// lowers to the map_get intrinsic, which always materializes into
		// its own temp before it can be used as another call's argument —
		// see intrCall's IMapGet case.)
		m, k, v := fp.expr(x.Args[0]), fp.strAddr(x.Args[1]), fp.copyToTemp(x.Args[2])
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
	case ir.ILastErr:
		// Materializes a whole Err-record value {code, message} from the
		// runtime's rt_lasterr_* globals — the printer contract lowerIdent
		// (internal/lower/expr.go) relies on for a bare `lastError` rvalue,
		// since there is no cv_lastError global to reference directly.
		t := fp.newTmp("clar_rec_Err")
		fp.emit("%s.code = rt_lasterr_code;", t)
		fp.emit("rt_str_store((uint8_t*)&%s.message, 255, rt_lasterr_msg);", t)
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
