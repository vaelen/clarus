package check

import (
	"clarus/internal/ast"
	"clarus/internal/parser"
	"clarus/internal/source"
	"clarus/internal/types"
	"testing"
)

func TestInfoTypes(t *testing.T) {
	src := "enum E { A, M 0x10 }\nvar x: int = 3 + 4\nvar e: E = M\n"
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatal(pd[0])
	}
	diags, info := Files([]*source.File{f}, []*ast.File{tree})
	if len(diags) != 0 {
		t.Fatal(diags[0])
	}
	init := tree.Decls[1].(*ast.VarDecl).Init // 3 + 4
	if tt, ok := info.Types[init]; !ok || tt.Kind != types.Int {
		t.Fatalf("no int type recorded for binary expr: %v", tt)
	}
	em := tree.Decls[2].(*ast.VarDecl).Init // M
	if v, ok := info.EnumConsts[em]; !ok || v != 0x10 {
		t.Fatalf("enum const not recorded: %v %v", v, ok)
	}
	if len(info.GlobalOrder) != 2 || info.GlobalOrder[0] != "x" {
		t.Fatalf("global order: %v", info.GlobalOrder)
	}
}
