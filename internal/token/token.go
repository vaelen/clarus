package token

import (
	"clarus/internal/source"
	"fmt"
)

type Kind int

const (
	// Basic tokens
	EOF Kind = iota
	NEWLINE
	SEMI
	IDENT
	INT
	FIXEDLIT
	CHARLIT
	STRINGLIT

	// Keywords (28 hard keywords)
	KwVar
	KwFunc
	KwRecord
	KwEnum
	KwWindow
	KwMenu
	KwExtend
	KwOn
	KwEvery
	KwIf
	KwElse
	KwWhile
	KwFor
	KwIn
	KwTo
	KwReturn
	KwAnd
	KwOr
	KwNot
	KwTrue
	KwFalse
	KwNil
	KwOpen
	KwClose
	KwEdit
	KwNew
	KwQuit
	KwCancel

	// Punctuation
	LPAREN
	RPAREN
	LBRACE
	RBRACE
	LBRACKET
	RBRACKET
	COMMA
	COLON
	DOT

	// Operators (contiguous range ASSIGN..TILDE for lexer range test)
	ASSIGN
	EQ
	NE
	LT
	LE
	GT
	GE
	PLUS
	MINUS
	STAR
	SLASH
	SHL
	SHR
	AMP
	PIPE
	CARET
	TILDE
)

// Token represents a single token.
type Token struct {
	Kind   Kind       // Token kind
	Pos    source.Pos // Position in source
	Text   string     // Raw text of the token
	IntVal int64      // Integer value (for INT tokens)
	FixVal int32      // Fixed-point value (16.16 fixed-point raw)
}

// Keywords maps keyword text to their Kind.
var Keywords = map[string]Kind{
	"var":    KwVar,
	"func":   KwFunc,
	"record": KwRecord,
	"enum":   KwEnum,
	"window": KwWindow,
	"menu":   KwMenu,
	"extend": KwExtend,
	"on":     KwOn,
	"every":  KwEvery,
	"if":     KwIf,
	"else":   KwElse,
	"while":  KwWhile,
	"for":    KwFor,
	"in":     KwIn,
	"to":     KwTo,
	"return": KwReturn,
	"and":    KwAnd,
	"or":     KwOr,
	"not":    KwNot,
	"true":   KwTrue,
	"false":  KwFalse,
	"nil":    KwNil,
	"open":   KwOpen,
	"close":  KwClose,
	"edit":   KwEdit,
	"new":    KwNew,
	"quit":   KwQuit,
	"cancel": KwCancel,
}

// String returns the human-readable form of Kind for diagnostics.
func (k Kind) String() string {
	return kindNames[k]
}

var kindNames = [...]string{
	// Basic tokens
	EOF:       "EOF",
	NEWLINE:   "newline",
	SEMI:      "';'",
	IDENT:     "identifier",
	INT:       "integer",
	FIXEDLIT:  "fixed-point literal",
	CHARLIT:   "character literal",
	STRINGLIT: "string literal",

	// Keywords
	KwVar:    "'var'",
	KwFunc:   "'func'",
	KwRecord: "'record'",
	KwEnum:   "'enum'",
	KwWindow: "'window'",
	KwMenu:   "'menu'",
	KwExtend: "'extend'",
	KwOn:     "'on'",
	KwEvery:  "'every'",
	KwIf:     "'if'",
	KwElse:   "'else'",
	KwWhile:  "'while'",
	KwFor:    "'for'",
	KwIn:     "'in'",
	KwTo:     "'to'",
	KwReturn: "'return'",
	KwAnd:    "'and'",
	KwOr:     "'or'",
	KwNot:    "'not'",
	KwTrue:   "'true'",
	KwFalse:  "'false'",
	KwNil:    "'nil'",
	KwOpen:   "'open'",
	KwClose:  "'close'",
	KwEdit:   "'edit'",
	KwNew:    "'new'",
	KwQuit:   "'quit'",
	KwCancel: "'cancel'",

	// Punctuation
	LPAREN:   "'('",
	RPAREN:   "')'",
	LBRACE:   "'{'",
	RBRACE:   "'}'",
	LBRACKET: "'['",
	RBRACKET: "']'",
	COMMA:    "','",
	COLON:    "':'",
	DOT:      "'.'",

	// Operators
	ASSIGN: "'='",
	EQ:     "'=='",
	NE:     "'!='",
	LT:     "'<'",
	LE:     "'<='",
	GT:     "'>'",
	GE:     "'>='",
	PLUS:   "'+'",
	MINUS:  "'-'",
	STAR:   "'*'",
	SLASH:  "'/'",
	SHL:    "'<<'",
	SHR:    "'>>'",
	AMP:    "'&'",
	PIPE:   "'|'",
	CARET:  "'^'",
	TILDE:  "'~'",
}

// Verify that the names array has the correct length
var _ = func() interface{} {
	if len(kindNames) != int(TILDE)+1 {
		panic(fmt.Sprintf("kindNames has %d entries, want %d", len(kindNames), int(TILDE)+1))
	}
	return nil
}()
