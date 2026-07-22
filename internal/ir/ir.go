package ir

type Program struct {
	Globals                  []*Global
	Funcs                    []*Func
	StrLits                  []string        // literal pool; StrConst.Idx indexes this
	Records                  []*RecordLayout // declaration order
	Enums                    []*EnumLayout
	HasLaunch, HasStartEmpty bool // which App handlers exist
}

type RecordLayout struct {
	Name   string
	Fields []FieldSlot
}

type FieldSlot struct {
	Name       string
	T          Type
	Default    int64 // scalar/enum/char/bool/fixed-raw default; strings default empty
	DefaultStr int   // -1, or StrLits index for a string default
}

type EnumLayout struct {
	Name    string
	Members []string
	Values  []int
	Labels  []string
}

type Global struct {
	Name string
	T    Type
	Init Expr // Init nil → zero value. For Rec-typed globals, "zero value" means
	// the record's declared defaults per RecordLayout.Fields (Default/
	// DefaultStr), NOT memset-zero — the printer must apply them. A
	// whole-initializer `new T` lowers to a NewRec Init (not nil); nil Init
	// on a Rec-typed global only arises from an uninitialized declaration
	// (`var b: Bookmark`), which this same defaults-application applies to.
}

type Func struct {
	Name   string // user funcs keep their name; handlers are "handler_App_launch", "handler_App_startEmpty"
	Params []Local
	Ret    Type // K == Void for procedures
	Locals []Local
	Body   []Stmt
}

type Local struct {
	Name string
	T    Type
}

// ---- types (flat; Name links records/enums by name) ----
type Kind int

const (
	Void Kind = iota
	Int
	Bool
	Fixed
	Char
	Str  // N = capacity
	Text // opaque handle on host: heap buffer
	List // Elem = element type
	Map  // Elem = value type
	Rec  // Name = record name
	Enum // Name = enum name
	Arr  // N = length, Elem = element type
	Err  // the error record {code, message}
)

type Type struct {
	K    Kind
	N    int
	Elem *Type
	Name string
}

// ---- statements ----
type Stmt interface{ stmt() }

type Assign struct{ Dst, Src Expr }   // same-type move (records/arrays copy by value)
type StoreStr struct{ Dst, Src Expr } // clamped string store; sets lastError on truncation
type ExprStmt struct{ X Expr }
type If struct {
	Cond       Expr
	Then, Else []Stmt // Else may be nil
}
type While struct {
	Cond Expr
	Body []Stmt
}
type ForRange struct {
	V        string // int loop local, inclusive bounds
	From, To Expr
	Body     []Stmt
}
type ForList struct {
	V     string // element local
	ListV Expr
	Body  []Stmt
}
type ForMap struct {
	K, V string
	MapV Expr
	Body []Stmt
}
type Return struct{ X Expr } // nil for bare return

// stmt() marker methods
func (s *Assign) stmt()   {}
func (s *StoreStr) stmt() {}
func (s *ExprStmt) stmt() {}
func (s *If) stmt()       {}
func (s *While) stmt()    {}
func (s *ForRange) stmt() {}
func (s *ForList) stmt()  {}
func (s *ForMap) stmt()   {}
func (s *Return) stmt()   {}

// ---- expressions (every node carries its Type) ----
type Expr interface{ Type() Type }

type IntConst struct {
	V  int64
	Ty Type
} // int/bool(0|1)/char/enum-value/fixed-raw constants

type StrConst struct {
	Idx int
	Ty  Type
} // Ty.K == Str, N = 255

type VarRef struct {
	Name   string
	Global bool
	Ty     Type
}

type FieldRef struct {
	X    Expr
	Name string
	Ty   Type
} // record field lvalue/rvalue

type IndexRef struct {
	X  Expr
	I  Expr
	Ty Type
} // array element (lvalue/rvalue). Also reused, deliberately, for list
// indexing `l[i]` (both reads and writes): the printer recognizes a
// List-typed X and emits *(T*)rt_list_at(l, i) instead of a real array
// access — keeps the IR small rather than adding a dedicated node. Map,
// string, and text indexing are NOT IndexRef; they lower to intrinsics.

type Bin struct {
	Op   string
	X, Y Expr
	Ty   Type
} // int/char/bool/fixed(+,-) arith+cmp+bitwise; fixed *,/ lower to intrinsics; string/text ops lower to intrinsics

type Un struct {
	Op string
	X  Expr
	Ty Type
} // "-", "not", "~"

type ConvOp int

const (
	IntToFixed ConvOp = iota
	FixedToInt
	IntToChar
	CharToInt
	EnumToInt
	IntToEnum // IntToEnum is CHECKED (panics on no member)
)

type Conv struct {
	Op       ConvOp
	X        Expr
	EnumName string
	Ty       Type
}

type CallFn struct {
	Name string
	Args []Expr
	Ty   Type
} // user function call

type Intr struct {
	Name string
	Args []Expr
	Ty   Type
} // runtime intrinsic (intrinsics.go names)

// NewRec constructs a record value of the named record type with every
// field at its declared default (per RecordLayout.Fields). The C printer
// emits a call to the per-record constructor clar_new_NAME(), which
// returns the struct by value.
type NewRec struct {
	RecName string
	Ty      Type
}

// Type() marker methods
func (e *IntConst) Type() Type { return e.Ty }
func (e *StrConst) Type() Type { return e.Ty }
func (e *VarRef) Type() Type   { return e.Ty }
func (e *FieldRef) Type() Type { return e.Ty }
func (e *IndexRef) Type() Type { return e.Ty }
func (e *Bin) Type() Type      { return e.Ty }
func (e *Un) Type() Type       { return e.Ty }
func (e *Conv) Type() Type     { return e.Ty }
func (e *CallFn) Type() Type   { return e.Ty }
func (e *Intr) Type() Type     { return e.Ty }
func (e *NewRec) Type() Type   { return e.Ty }
