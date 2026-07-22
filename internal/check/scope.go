// Package check implements the Clarus type checker.
package check

import (
	"fmt"

	"clarus/internal/types"
)

// FuncSig is the signature of a declared function.
type FuncSig struct {
	Params []*types.Type
	Ret    *types.Type
}

// Symbol is a name bound in a Scope: a variable, function, type name, or menu
// name. Menus are a fourth, narrower kind: unlike a window (a WindowRef
// type), a menu is never a value — it only ever appears as the base of
// `MenuName.ItemName` (Ch9's runtime `enabled` property), so it gets its own
// flag and payload rather than a types.Type.
type Symbol struct {
	Name   string
	Type   *types.Type
	IsFunc bool
	Func   *FuncSig
	IsType bool
	IsMenu bool
	Menu   *MenuInfo

	// IsConst marks a `const` declaration (Ch3: Constants): its value is
	// fixed at compile time (ConstVal) and it can never appear as an
	// assignment target (checkAssignStmt) or a non-constant switch case
	// label (checkCaseLabel).
	IsConst  bool
	ConstVal ConstVal
}

// Scope is a lexical block of declarations, chained to its enclosing scope.
type Scope struct {
	parent *Scope
	names  map[string]Symbol
}

// NewScope creates a scope nested inside parent (nil for the top level).
func NewScope(parent *Scope) *Scope {
	return &Scope{parent: parent, names: make(map[string]Symbol)}
}

// Declare binds sym in this scope. It errors if the name is already
// declared in this same scope (shadowing an outer scope is allowed).
func (s *Scope) Declare(sym Symbol) error {
	if _, exists := s.names[sym.Name]; exists {
		return fmt.Errorf("redeclaration of %s", sym.Name)
	}
	s.names[sym.Name] = sym
	return nil
}

// Lookup finds name in this scope or any enclosing scope.
func (s *Scope) Lookup(name string) (Symbol, bool) {
	for sc := s; sc != nil; sc = sc.parent {
		if sym, ok := sc.names[name]; ok {
			return sym, true
		}
	}
	return Symbol{}, false
}
