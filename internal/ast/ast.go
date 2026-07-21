package ast

import "clarus/internal/source"

type File struct{ Decls []Decl }

type Decl interface{ declNode() }
type Stmt interface{ stmtNode() }
type Expr interface {
	exprNode()
	Pos() source.Pos
}

// ---- types as written in source ----
type TypeExpr interface{ typeNode() }
type NamedType struct {
	P    source.Pos
	Name string // "int", "bool", "fixed", "char", "text", user record/enum/window name
}
type StringType struct {
	P source.Pos
	N int
} // string / string(63); N=255 for bare
type ListType struct {
	P    source.Pos
	Elem TypeExpr
}
type MapType struct {
	P   source.Pos
	Val TypeExpr
}
type ArrayType struct {
	P    source.Pos
	Elem TypeExpr
	N    int
}

// ---- declarations ----
type Field struct {
	P       source.Pos
	Name    string
	Type    TypeExpr
	Default Expr
} // Default may be nil
type RecordDecl struct {
	P      source.Pos
	Name   string
	Fields []Field
}
type EnumMember struct {
	P        source.Pos
	Name     string
	HasValue bool
	Value    int64
	Label    string
}
type EnumDecl struct {
	P       source.Pos
	Name    string
	Members []EnumMember
}
type VarDecl struct {
	P    source.Pos
	Name string
	Type TypeExpr
	Init Expr
} // also a Stmt
type Param struct {
	P    source.Pos
	Name string
	Type TypeExpr
}
type FuncDecl struct {
	P      source.Pos
	Name   string
	Params []Param
	Ret    TypeExpr
	Body   *Block
}
type WindowDecl struct {
	P     source.Pos
	Name  string
	Items []WindowItem
}
type MenuDecl struct {
	P       source.Pos
	Name    string
	Entries []MenuEntry
}
type ExtendDecl struct {
	P        source.Pos
	Target   string
	Handlers []*HandlerDecl
	Nested   []*ExtendDecl
}
type HandlerDecl struct {
	P      source.Pos
	Path   []string
	Params []Param
	Body   *Block
} // "on a.b.c(params)"
type EveryDecl struct {
	P     source.Pos
	Ticks int64
	Body  *Block
}

// ---- window body items ----
type WindowItem interface{ windowItemNode() }
type Property struct {
	P      source.Pos
	Name   string
	Values []Expr
} // title: "x" / size: 400, 300 / resizable / resizable: min(300,200) — min(...) arrives as a Call expr
type Column struct {
	P         source.Pos
	Header    string
	Shows     string
	WidthPx   int
	WidthFill bool
}
type FormFor struct {
	P      source.Pos
	Record string
}
type Widget struct {
	P          source.Pos
	Kind, Name string
	Props      []WindowItem
} // Props: Property or Column
type MenuEntry struct {
	P                           source.Pos
	IsItem                      bool
	Name, Caption, Key          string
	IsSeparator, IsStandardEdit bool
}

// ---- statements ----
type Block struct {
	P     source.Pos
	Vars  []*VarDecl
	Stmts []Stmt
} // vars-at-top enforced by parser
type AssignStmt struct {
	P        source.Pos
	LHS, RHS Expr
}
type ExprStmt struct {
	P source.Pos
	X Expr
} // call statements
type IfStmt struct {
	P    source.Pos
	Cond Expr
	Then *Block
	Else Stmt
} // Else: *IfStmt, *Block, or nil
type WhileStmt struct {
	P    source.Pos
	Cond Expr
	Body *Block
}
type ForStmt struct {
	P      source.Pos
	V1, V2 string
	Seq    Expr
	ToExpr Expr
	Body   *Block
} // V2=="" unless map form; ToExpr!=nil for ranges
type ReturnStmt struct {
	P source.Pos
	X Expr
} // X may be nil
type QuitStmt struct{ P source.Pos }
type CancelStmt struct{ P source.Pos }
type OpenStmt struct {
	P      source.Pos
	Window string
}
type CloseStmt struct {
	P source.Pos
	X Expr
}
type EditStmt struct {
	P       source.Pos
	Form    string
	Target  Expr
	IsNew   bool
	NewType string
}

// ---- expressions ----
type Ident struct {
	P    source.Pos
	Name string
}
type IntLit struct {
	P   source.Pos
	Val int64
}
type FixedLit struct {
	P   source.Pos
	Raw int32
}
type CharLit struct {
	P   source.Pos
	Val byte
}
type StringLit struct {
	P   source.Pos
	Val string
}
type BoolLit struct {
	P   source.Pos
	Val bool
}
type NilLit struct{ P source.Pos }
type WindowSelf struct{ P source.Pos } // the `window` keyword in expression position
type Unary struct {
	P  source.Pos
	Op string
	X  Expr
} // "-", "not", "~"
type Binary struct {
	P    source.Pos
	Op   string
	X, Y Expr
} // "+","-","*","/","mod","<<",">>","&","|","^","==","!=","<","<=",">",">=","and","or"
type Call struct {
	P         source.Pos
	Fn        Expr
	Args      []Expr
	AppleTalk bool
} // AppleTalk: first arg had `appletalk` prefix
type Index struct {
	P    source.Pos
	X, I Expr
}
type Select struct {
	P    source.Pos
	X    Expr
	Name string
}
type NewExpr struct {
	P    source.Pos
	Type string
}
type OpenExpr struct {
	P      source.Pos
	Window string
}

// ---- marker methods ----

// Decl markers
func (d *RecordDecl) declNode()  {}
func (d *EnumDecl) declNode()    {}
func (d *VarDecl) declNode()     {}
func (d *FuncDecl) declNode()    {}
func (d *WindowDecl) declNode()  {}
func (d *MenuDecl) declNode()    {}
func (d *ExtendDecl) declNode()  {}
func (d *HandlerDecl) declNode() {}
func (d *EveryDecl) declNode()   {}

// Stmt markers
func (d *VarDecl) stmtNode()    {}
func (s *Block) stmtNode()      {}
func (s *AssignStmt) stmtNode() {}
func (s *ExprStmt) stmtNode()   {}
func (s *IfStmt) stmtNode()     {}
func (s *WhileStmt) stmtNode()  {}
func (s *ForStmt) stmtNode()    {}
func (s *ReturnStmt) stmtNode() {}
func (s *QuitStmt) stmtNode()   {}
func (s *CancelStmt) stmtNode() {}
func (s *OpenStmt) stmtNode()   {}
func (s *CloseStmt) stmtNode()  {}
func (s *EditStmt) stmtNode()   {}

// TypeExpr markers
func (t *NamedType) typeNode()  {}
func (t *StringType) typeNode() {}
func (t *ListType) typeNode()   {}
func (t *MapType) typeNode()    {}
func (t *ArrayType) typeNode()  {}

// WindowItem markers
func (w *Property) windowItemNode() {}
func (w *Column) windowItemNode()   {}
func (w *FormFor) windowItemNode()  {}
func (w *Widget) windowItemNode()   {}

// Expr markers with Pos()
func (e *Ident) exprNode()       {}
func (e *Ident) Pos() source.Pos { return e.P }

func (e *IntLit) exprNode()       {}
func (e *IntLit) Pos() source.Pos { return e.P }

func (e *FixedLit) exprNode()       {}
func (e *FixedLit) Pos() source.Pos { return e.P }

func (e *CharLit) exprNode()       {}
func (e *CharLit) Pos() source.Pos { return e.P }

func (e *StringLit) exprNode()       {}
func (e *StringLit) Pos() source.Pos { return e.P }

func (e *BoolLit) exprNode()       {}
func (e *BoolLit) Pos() source.Pos { return e.P }

func (e *NilLit) exprNode()       {}
func (e *NilLit) Pos() source.Pos { return e.P }

func (e *WindowSelf) exprNode()       {}
func (e *WindowSelf) Pos() source.Pos { return e.P }

func (e *Unary) exprNode()       {}
func (e *Unary) Pos() source.Pos { return e.P }

func (e *Binary) exprNode()       {}
func (e *Binary) Pos() source.Pos { return e.P }

func (e *Call) exprNode()       {}
func (e *Call) Pos() source.Pos { return e.P }

func (e *Index) exprNode()       {}
func (e *Index) Pos() source.Pos { return e.P }

func (e *Select) exprNode()       {}
func (e *Select) Pos() source.Pos { return e.P }

func (e *NewExpr) exprNode()       {}
func (e *NewExpr) Pos() source.Pos { return e.P }

func (e *OpenExpr) exprNode()       {}
func (e *OpenExpr) Pos() source.Pos { return e.P }
