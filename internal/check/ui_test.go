// internal/check/ui_test.go
package check

import "testing"

const uiBase = `
enum Protocol { Gopher, HTTP, Telnet }

record Bookmark {
    name:     string(63)
    protocol: Protocol
    favorite: bool
}

var bookmarks: list of Bookmark

window EditForm {
    title: "Edit"
    form for Bookmark

    field Name  { binds: name; label: "Name:" }
    check Fav   { binds: favorite; caption: "Favorite" }
    popup Proto { binds: protocol; label: "Protocol:" }

    button OK     { default }
    button Cancel { cancel }
}

window Main {
    title: "Marks"
    size: 420, 300
    resizable

    table Marks {
        rows: bookmarks
        column "Name" shows name width 140
    }
    button Add { at: 10, bottom; caption: "Add…" }
}
`

func TestUIClean(t *testing.T) {
	expectClean(t, uiBase+`
on App.startEmpty {
    open Main
}

extend Main {
    on Add.click {
        edit EditForm, new Bookmark
    }
    on Marks.doubleClick(i: int) {
        edit EditForm, bookmarks[i]
    }
    on closeRequest {
        cancel
    }
}

extend EditForm {
    on accepted(b: Bookmark) {
        if b.isNew { bookmarks.add(b) }
    }
}
`)
}

func TestUIErrors(t *testing.T) {
	expectError(t, uiBase+"extend Main {\n    on Add.frobnicate { }\n}\n", "unknown event")
	expectError(t, uiBase+"extend Main {\n    on Marks.doubleClick(i: bool) { }\n}\n", "takes")
	expectError(t, uiBase+"func f() {\n    cancel\n}\n", "closeRequest")
	expectError(t, `record R { x: int }
window W {
    form for R
    field F { binds: nope }
}
`, "no field")
	expectError(t, `window W {
    button B { rows: 3 }
}
`, "unknown property")
	expectError(t, uiBase+"func f() {\n    edit Main, new Bookmark\n}\n", "not a form window")
}
