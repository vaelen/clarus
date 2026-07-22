// Package ir defines the IR (Intermediate Representation) and the complete Plan 3
// intrinsic vocabulary. The IR names operations; each printer's runtime decides how
// (host: C+libc; Mac later: Toolbox).
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
	ITextNew       = "text_new"
	ITextStore     = "text_store"
	ITextConcat    = "text_concat"
	ITextCmp       = "text_cmp"
	ITextLen       = "text_len"
	ITextIndex     = "text_index"
	ITextSetIndex  = "text_set_index"
	ITextFromBytes = "text_from_bytes"
	ITextToBytes   = "text_to_bytes"
	// list (element size known at creation)
	IListNew     = "list_new"
	IListPush    = "list_push"
	IListPop     = "list_pop"
	IListShift   = "list_shift"
	IListUnshift = "list_unshift"
	IListFirst   = "list_first"
	IListLast    = "list_last"
	IListRemove  = "list_remove"
	IListGet     = "list_get"
	IListSet     = "list_set"
	IListCount   = "list_count"
	// map (string keys; value size known at creation)
	IMapNew    = "map_new"
	IMapSet    = "map_set"
	IMapGet    = "map_get" // panics if absent
	IMapGetDv  = "map_get_dv"
	IMapHas    = "map_has"
	IMapRemove = "map_remove"
	IMapCount  = "map_count"
	// fixed 16.16
	IFixMul = "fix_mul"
	IFixDiv = "fix_div"
	// misc
	IEnumFromInt = "enum_from_int" // (enum table, v) -> value or panic
	IPanic       = "panic"         // (msg str-lit) -> never returns
	IAlert       = "alert"         // (s) host: stdout
	ILastErrCode = "lasterr_code"
	ILastErrMsg  = "lasterr_msg"
	// files (host: stdio)
	IFileReadText  = "file_read_text"  // (path str, t text) -> bool
	IFileWriteText = "file_write_text" // (path str, t text) -> bool
	IFileName      = "file_name"       // (path str) -> str255
)
