// Package types represents Clarus's static type system: the Type value
// itself, named-type info (enum/record/window), and the assignability and
// equality rules from the language reference, Chapter 3.
package types

// Kind identifies the shape of a Type.
type Kind int

const (
	Invalid Kind = iota
	Int
	Bool
	Fixed
	Char
	String
	Text
	Enum
	Record
	Array
	List
	Map
	WindowRef
	Connection
	Listener
	ServiceBrowser
	Address
	ErrorType
	Void
)

// Type is a Clarus type. Only the fields relevant to Kind are populated.
type Type struct {
	Kind Kind

	N    int   // String: capacity; Array: length
	Elem *Type // Array/List elem, Map value

	Enum   *EnumInfo
	Record *RecordInfo
	Window *WindowInfo
}

// EnumInfo is the named-type identity for an enum declaration.
type EnumInfo struct {
	Name    string
	Members []EnumMemberInfo
}

// EnumMemberInfo is one member of an enum.
type EnumMemberInfo struct {
	Name  string
	Value int
	Label string
}

// RecordInfo is the named-type identity for a record declaration.
type RecordInfo struct {
	Name   string
	Fields []FieldInfo
}

// FieldInfo is one field of a record, or one var of a window.
type FieldInfo struct {
	Name string
	Type *Type
}

// WindowInfo is the named-type identity for a window declaration.
type WindowInfo struct {
	Name       string
	IsForm     bool
	FormRecord *RecordInfo
	Widgets    []WidgetInfo
	Vars       []FieldInfo
}

// WidgetInfo is one widget declared inside a window body.
type WidgetInfo struct {
	Name  string
	Kind  string
	Binds string
}

// Singletons for kinds with no other state.
var (
	IntT     = &Type{Kind: Int}
	BoolT    = &Type{Kind: Bool}
	FixedT   = &Type{Kind: Fixed}
	CharT    = &Type{Kind: Char}
	TextT    = &Type{Kind: Text}
	VoidT    = &Type{Kind: Void}
	AddressT = &Type{Kind: Address}
	ErrT     = &Type{Kind: ErrorType}

	// InvalidT is the checker's error-recovery sentinel: returned by
	// checkExpr in place of a real type after a diagnostic has already been
	// reported, so AssignableTo/Equal treat it as compatible with anything
	// and a single mistake never cascades into unrelated follow-on errors.
	// Distinct from ErrT, the language's own `error` record type.
	InvalidT = &Type{Kind: Invalid}
)

// StringT returns a string(n) type.
func StringT(n int) *Type { return &Type{Kind: String, N: n} }

// ListT returns a list-of-elem type.
func ListT(elem *Type) *Type { return &Type{Kind: List, Elem: elem} }

// MapT returns a map-of-val type.
func MapT(val *Type) *Type { return &Type{Kind: Map, Elem: val} }

// ArrayT returns a fixed elem[n] type.
func ArrayT(elem *Type, n int) *Type { return &Type{Kind: Array, Elem: elem, N: n} }

// SaveChoice is the built-in three-way save/discard/cancel enum, as if
// declared `enum saveChoice { Save, Discard "Don't Save", Cancel }`.
var SaveChoice = &Type{Kind: Enum, Enum: &EnumInfo{
	Name: "saveChoice",
	Members: []EnumMemberInfo{
		{Name: "Save", Value: 0, Label: "Save"},
		{Name: "Discard", Value: 1, Label: "Don't Save"},
		{Name: "Cancel", Value: 2, Label: "Cancel"},
	},
}}

// AssignableTo reports whether a value of type src may be assigned to a
// location of type dst (Chapter 3: Value and Reference Semantics, Strings).
func AssignableTo(src, dst *Type) bool {
	if src == nil || dst == nil {
		return false
	}
	if src.Kind == Invalid || dst.Kind == Invalid {
		return true
	}
	if src.Kind != dst.Kind {
		return false
	}
	switch src.Kind {
	case String:
		return true // any capacity assigns to any other; runtime clamps
	case Enum:
		return src.Enum == dst.Enum
	case Record:
		return src.Record == dst.Record
	case WindowRef:
		return src.Window == dst.Window
	case Array:
		return src.N == dst.N && AssignableTo(src.Elem, dst.Elem)
	case List, Map:
		return Equal(src.Elem, dst.Elem)
	default:
		return true // same-kind scalars/resources/void need no further check
	}
}

// Equal reports whether a and b are the same type. It is structural except
// for named types (enum/record/window), which compare by identity.
func Equal(a, b *Type) bool {
	if a == b {
		return true
	}
	if a == nil || b == nil {
		return false
	}
	if a.Kind == Invalid || b.Kind == Invalid {
		return true
	}
	if a.Kind != b.Kind {
		return false
	}
	switch a.Kind {
	case String:
		return a.N == b.N
	case Enum:
		return a.Enum == b.Enum
	case Record:
		return a.Record == b.Record
	case WindowRef:
		return a.Window == b.Window
	case Array:
		return a.N == b.N && Equal(a.Elem, b.Elem)
	case List, Map:
		return Equal(a.Elem, b.Elem)
	default:
		return true
	}
}
