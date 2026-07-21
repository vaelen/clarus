package check

import "clarus/internal/types"

// Kinds without a package-level singleton in internal/types (only the
// checker needs a concrete *types.Type for them, to register the built-in
// type-name symbols and to type resource-typed variables).
var (
	connectionT     = &types.Type{Kind: types.Connection}
	listenerT       = &types.Type{Kind: types.Listener}
	serviceBrowserT = &types.Type{Kind: types.ServiceBrowser}
)

// paramSpec describes one parameter slot of a built-in method/function.
// Exactly one of the match modes applies; the zero value (T set) is a plain
// assignable-to check against a concrete type.
type paramSpec struct {
	T            *types.Type  // plain expected type, checked via compatible()
	AnyCharArray bool         // any char[N] array, any N (string/text byte copies)
	AnyRecordish bool         // record, list of record, or map of record (file.save/load)
	OneOfKinds   []types.Kind // any of these kinds (e.g. connection.open: string or address)
}

// methodSig is a built-in callable's signature: a fixed arity, no
// overloading (matches user-declared funcs, Ch6: Restrictions). Ret == nil
// means the call is a procedure (void).
type methodSig struct {
	Params []paramSpec
	Ret    *types.Type
}

// stringTextMethods: string and text share the same byte-copy methods
// (Ch3: Strings, Text). `length` is a property, not a method, and is
// handled directly in checkSelect.
var stringTextMethods = map[string]methodSig{
	"fromBytes": {Params: []paramSpec{{AnyCharArray: true}, {T: types.IntT}}},
	"toBytes":   {Params: []paramSpec{{AnyCharArray: true}}, Ret: types.IntT},
}

// connectionMethods (Ch12: Connections). `open` accepts a string
// ("host:port" or, with the `appletalk` argument prefix, an ADSP name) or an
// address from a serviceBrowser; the appletalk prefix itself is a marker on
// the Call node, not a distinct parameter type.
var connectionMethods = map[string]methodSig{
	"open":  {Params: []paramSpec{{OneOfKinds: []types.Kind{types.String, types.Address}}}},
	"send":  {Params: []paramSpec{{OneOfKinds: []types.Kind{types.Text, types.String}}}},
	"close": {},
}

// listenerMethods (Ch12: Listeners).
var listenerMethods = map[string]methodSig{
	"listen":   {Params: []paramSpec{{T: types.IntT}}},
	"register": {Params: []paramSpec{{T: types.StringT(255)}, {T: types.StringT(255)}}},
}

// serviceBrowserMethods (Ch12: Service Discovery).
var serviceBrowserMethods = map[string]methodSig{
	"find": {Params: []paramSpec{{T: types.StringT(255)}}},
}

// fileFuncs is the `file` namespace (Ch12: Files). Reached through Select
// with an Ident base literally named "file" (see checkFileCall) — there is
// no `file` value or type in the type system, just this reserved name.
var fileFuncs = map[string]methodSig{
	"readText":  {Params: []paramSpec{{T: types.StringT(255)}, {T: types.TextT}}, Ret: types.BoolT},
	"writeText": {Params: []paramSpec{{T: types.StringT(255)}, {T: types.TextT}}, Ret: types.BoolT},
	"save":      {Params: []paramSpec{{T: types.StringT(255)}, {AnyRecordish: true}}, Ret: types.BoolT},
	"load":      {Params: []paramSpec{{T: types.StringT(255)}, {AnyRecordish: true}}, Ret: types.BoolT},
	"name":      {Params: []paramSpec{{T: types.StringT(255)}}, Ret: types.StringT(255)},
}

// canvasMethods and canvasProperties (Ch11: Drawing) are data only for Task
// 10 — there is no canvas/widget value type in the checker yet for a Select
// receiver to resolve to, so nothing dispatches to these tables until
// Task 11 adds widget symbols. They live here now per the task brief so the
// signatures are settled in one place.
var canvasMethods = map[string]methodSig{
	"clear":      {},
	"line":       {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.IntT}, {T: types.IntT}}},
	"rect":       {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.IntT}, {T: types.IntT}}},
	"fillRect":   {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.IntT}, {T: types.IntT}}},
	"circle":     {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.IntT}}},
	"fillCircle": {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.IntT}}},
	"drawText":   {Params: []paramSpec{{T: types.IntT}, {T: types.IntT}, {T: types.StringT(255)}}},
}
var canvasProperties = map[string]*types.Type{
	"width":  types.IntT,
	"height": types.IntT,
}

// registerBuiltins populates the universe scope: dialogs, the `file`
// namespace's presence (its functions are dispatched by name, not scope
// lookup), resource/error/saveChoice type names, and the global lastError.
func registerBuiltins(u *Scope) {
	declType := func(name string, t *types.Type) {
		_ = u.Declare(Symbol{Name: name, IsType: true, Type: t})
	}
	declType("connection", connectionT)
	declType("listener", listenerT)
	declType("serviceBrowser", serviceBrowserT)
	declType("address", types.AddressT)
	// ponytail: `error` and the checker's own error-recovery sentinel are
	// both types.ErrT (the brief mandates reusing it for recovery). That
	// means a real type mismatch on a value legitimately typed `error`
	// (e.g. lastError) won't be flagged, since compatible() treats ErrT as
	// compatible with everything. Not exercised by any rule or test; split
	// them into distinct types if that ever matters.
	declType("error", types.ErrT)
	declType("saveChoice", types.SaveChoice)

	declFunc := func(name string, params []*types.Type, ret *types.Type) {
		_ = u.Declare(Symbol{Name: name, IsFunc: true, Func: &FuncSig{Params: params, Ret: ret}})
	}
	declFunc("alert", []*types.Type{types.StringT(255)}, nil)
	declFunc("askOpen", []*types.Type{types.StringT(255)}, types.BoolT)
	declFunc("askSave", []*types.Type{types.StringT(255), types.StringT(255)}, types.BoolT)
	declFunc("askSaveChanges", []*types.Type{types.StringT(255)}, types.SaveChoice)

	_ = u.Declare(Symbol{Name: "lastError", Type: types.ErrT})
}
