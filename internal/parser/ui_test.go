// internal/parser/ui_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

func TestWindowDecl(t *testing.T) {
	src := `window Main {
    title: "Bookmarks"
    size: 420, 300
    resizable: min(300, 200)
    form for Bookmark

    table Marks {
        rows: bookmarks
        column "Name" shows name width 140
        column "URL"  shows url  width fill
    }
    button Add { at: 10, bottom; caption: "Add…"; default }

    var count: int = 0
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	w := f.Decls[0].(*ast.WindowDecl)
	var props, widgets, vars, forms int
	for _, it := range w.Items {
		switch it.(type) {
		case *ast.Property:
			props++
		case *ast.Widget:
			widgets++
		case *ast.VarDecl:
			vars++
		case *ast.FormFor:
			forms++
		}
	}
	if props != 3 || widgets != 2 || vars != 1 || forms != 1 {
		t.Fatalf("items: %d %d %d %d", props, widgets, vars, forms)
	}
	tbl := w.Items[4].(*ast.Widget)
	if tbl.Kind != "table" || tbl.Name != "Marks" {
		t.Fatal("table widget")
	}
	col := tbl.Props[1].(*ast.Column)
	if col.Header != "Name" || col.Shows != "name" || col.WidthPx != 140 || col.WidthFill {
		t.Fatalf("column: %+v", col)
	}
	col2 := tbl.Props[2].(*ast.Column)
	if !col2.WidthFill {
		t.Fatal("width fill")
	}
	btn := w.Items[5].(*ast.Widget)
	if len(btn.Props) != 3 { // at, caption, default (bare)
		t.Fatalf("button props: %d", len(btn.Props))
	}
}

func TestMenuAndExtend(t *testing.T) {
	src := `menu File {
    item New  "New"  key "N"
    separator
    item Quit "Quit" key "Q"
}
menu Edit { standard edit }

extend Doc {
    extend File {
        on Save.select { save(window) }
    }
    on closeRequest {
        cancel
    }
}

on App.startEmpty {
    open Doc
}

on conn.received(data: text) {
    process(data)
}

every 2 ticks {
    tick()
}
`
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("diags: %v", diags[0])
	}
	m := f.Decls[0].(*ast.MenuDecl)
	if len(m.Entries) != 3 || !m.Entries[1].IsSeparator || m.Entries[2].Key != "Q" {
		t.Fatalf("menu: %+v", m.Entries)
	}
	if !f.Decls[1].(*ast.MenuDecl).Entries[0].IsStandardEdit {
		t.Fatal("standard edit")
	}
	ex := f.Decls[2].(*ast.ExtendDecl)
	if ex.Target != "Doc" || len(ex.Nested) != 1 || len(ex.Handlers) != 1 {
		t.Fatal("extend nesting")
	}
	if ex.Nested[0].Handlers[0].Path[0] != "Save" {
		t.Fatal("nested handler path")
	}
	h := f.Decls[3].(*ast.HandlerDecl)
	if h.Path[0] != "App" || h.Path[1] != "startEmpty" {
		t.Fatal("App handler")
	}
	h2 := f.Decls[4].(*ast.HandlerDecl)
	if len(h2.Params) != 1 || h2.Params[0].Name != "data" {
		t.Fatal("handler params")
	}
	ev := f.Decls[5].(*ast.EveryDecl)
	if ev.Ticks != 2 {
		t.Fatal("every ticks")
	}
}
