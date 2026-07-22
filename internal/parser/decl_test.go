package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

func TestRecordDecl(t *testing.T) {
	src := `record Bookmark {
    name:     string(63)
    port:     int = 80
    protocol: Protocol
    tags:     char[4]
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	r := f.Decls[0].(*ast.RecordDecl)
	if len(r.Fields) != 4 {
		t.Fatalf("fields: %d", len(r.Fields))
	}
	if st := r.Fields[0].Type.(*ast.StringType); st.N != 63 {
		t.Fatal("string(63)")
	}
	if r.Fields[1].Default == nil {
		t.Fatal("default")
	}
	if at := r.Fields[3].Type.(*ast.ArrayType); at.N != 4 {
		t.Fatal("char[4]")
	}
}

func TestEnumDecl(t *testing.T) {
	src := `enum Foo {
    Bar  "Bar"
    Moof 0x10 "Dogcow"
    Next "The next thing"
}
enum Protocol { Gopher, HTTP, Telnet }
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	e := f.Decls[0].(*ast.EnumDecl)
	if len(e.Members) != 3 {
		t.Fatalf("members: %d", len(e.Members))
	}
	m := e.Members[1]
	if !m.HasValue || m.Value != 0x10 || m.Label != "Dogcow" {
		t.Fatalf("Moof: %+v", m)
	}
	if e.Members[0].HasValue || e.Members[0].Label != "Bar" {
		t.Fatal("Bar")
	}
	p := f.Decls[1].(*ast.EnumDecl)
	if len(p.Members) != 3 || p.Members[2].Name != "Telnet" {
		t.Fatal("comma-separated enum")
	}
}

func TestEmptyEnumRejected(t *testing.T) {
	src := `enum E {}
`
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 {
		t.Fatal("expected diagnostic for empty enum")
	}
	if msg := diags[0].Msg; msg != "enum must have at least one member" {
		t.Fatalf("wrong message: %q", msg)
	}

	// empty records are still legal
	recSrc := `record R {}
`
	_, recDiags := Parse(&source.File{Name: "t.cla", Content: []byte(recSrc)})
	if len(recDiags) > 0 {
		t.Fatalf("empty record should be legal, got diags: %v", recDiags[0])
	}
}
