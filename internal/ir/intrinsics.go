// Package ir defines the IR (Intermediate Representation) and the intrinsic
// vocabulary actually reachable from lowering. The IR names operations; each
// printer's runtime decides how (host: C+libc; Mac later: Toolbox).
//
// # Fresh-handle-on-default contract
//
// Heap-handle types (text/list/map) default to a fresh empty handle, never a
// null pointer: Ch3's `var visitors: list of Person` is immediately usable
// (push, count, ...) with no explicit initializer. Every printer's
// default-init path (the host C printer's cprint.defaultInit) must uphold
// this — a nil-Init global/local and a record field with no explicit default
// both go through the same defaulting logic, so getting it right there
// covers both.
package ir

const (
	// strings (layout: [len byte][bytes...]; args pass ptr+cap as the printer arranges)
	IStrConcat      = "str_concat"        // (a str, b str) -> str255 temp
	IStrConcatChar  = "str_concat_char"   // (a str, c char) -> str255 temp
	IStrPrependChar = "str_prepend_char"  // (c char, a str) -> str255 temp
	IStrCmp         = "str_cmp"           // (a, b) -> int (-1/0/1 bytewise)
	IStrLen         = "str_len"           // (s) -> int
	IStrIndex       = "str_index"         // (s, i) -> char  [panics OOB]
	IStrSetIndex    = "str_set_index"     // (s, i, c)       [panics OOB]
	IStrFromBytes   = "str_from_bytes"    // (dst str, buf char-arr ptr+cap, count) ; clamps, sets lastError
	IStrToBytes     = "str_to_bytes"      // (src str, buf char-arr ptr+cap) -> int ; clamps, sets lastError
	IStrCoerce      = "str_coerce"        // (src str) -> str temp at Ty's (different) capacity; clamps, sets lastError
	IStrSlice       = "str_slice"         // (src str, start int, len int) -> str255 temp; panics OOB (Ch3: Slicing)
	IStrIndexOfStr  = "str_index_of_str"  // (s, needle str) -> int (-1 if absent; 0 if needle empty)
	IStrIndexOfChar = "str_index_of_char" // (s, c char) -> int
	// text (opaque handle on host: heap buffer)
	ITextStore       = "text_store"
	ITextConcat      = "text_concat"
	ITextConcatSL    = "text_concat_sl" // (s str, b text) -> text (string on left)
	ITextCmp         = "text_cmp"
	ITextLen         = "text_len"
	ITextIndex       = "text_index"
	ITextSetIndex    = "text_set_index"
	ITextFromBytes   = "text_from_bytes"
	ITextToBytes     = "text_to_bytes"
	ITextSlice       = "text_slice"         // (t text, start int, len int) -> str255 temp; panics OOB
	ITextIndexOfStr  = "text_index_of_str"  // (t text, needle str) -> int
	ITextIndexOfChar = "text_index_of_char" // (t text, c char) -> int
	ITextAppendStr   = "text_append_str"    // (t text, s str) grows t in place
	ITextAppendChar  = "text_append_char"   // (t text, c char) grows t in place
	ITextAppendText  = "text_append_text"   // (t text, src text) grows t in place; src may alias t
	// list (element size known at creation)
	IListPush    = "list_push"
	IListPop     = "list_pop"
	IListShift   = "list_shift"
	IListUnshift = "list_unshift"
	IListFirst   = "list_first"
	IListLast    = "list_last"
	IListRemove  = "list_remove"
	IListCount   = "list_count"
	// map (string keys; value size known at creation)
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
	IAlert       = "alert" // (s) host: stdout
	IQuit        = "quit"  // (code int) host: exit(code); never returns
	ILog         = "log"   // (s str) host: stderr + '\n'
	ILastErrCode = "lasterr_code"
	ILastErrMsg  = "lasterr_msg"
	ILastErr     = "lasterr_value" // () -> Err temp {rt_lasterr_code, rt_lasterr_msg}
	// files (host: stdio)
	IFileReadText  = "file_read_text"  // (path str, t text) -> bool
	IFileWriteText = "file_write_text" // (path str, t text) -> bool
	IFileName      = "file_name"       // (path str) -> str255
)
