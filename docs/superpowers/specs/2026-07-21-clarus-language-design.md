# Clarus Language Design

**Date:** 2026-07-21
**Status:** Approved design, pre-implementation
**Source extension:** `.cla` (long form `.clarus`); classic Mac creator code `'CLAR'`

## 1. Identity

Clarus is a small, compiled, event-driven programming language for building
native System 6/7 applications on 68k Macintosh computers. It is an "80/20"
language: it makes the common shapes of classic Mac software — utilities,
network tools, forms-over-data apps, and simple games — easy to write, and
does not attempt to cover everything else.

Design pillars:

- **Wirthian core, modern surface.** Pascal/Oberon semantics — static types,
  records, value semantics, declare-before-use, single-pass compilable, tiny
  runtime — under a C-family syntax familiar to programmers of Python,
  TypeScript, Rust, Go, Java, or C#.
- **Event-driven end to end.** The runtime owns the event loop; all user code
  lives in event handlers. Async operations complete by posting events.
- **The hard parts of classic Mac programming are absorbed by the runtime:**
  the event queue, Memory Manager Handles, window updating/resizing,
  scrollbars, and the raw AppleTalk/MacTCP driver interfaces.
- **Toolbox-native, libc-free.** The runtime is defined in terms of the
  Macintosh Toolbox, never the C standard library (§11).
- Not object-oriented. No closures. No manual memory management. No pointers
  in user code.

Non-goals: general-purpose systems programming, functional programming,
covering 100% of the Toolbox.

## 2. Toolchain strategy

**Hybrid: cross-hosted first, self-hosted later.**

The compiler is built on a modern machine and cross-compiles, with testing in
emulators (Mini vMac, Basilisk II) and deployment to real hardware. The
language is deliberately kept single-pass-friendly, small-grammared, and
closure-free so that a self-hosted compiler running on a 68k Mac is a
realistic future milestone rather than a rewrite.

**Backend: IR frozen early, printers swappable.**

Pipeline: source → typed AST → small typed IR → printer.

- v1 printer emits C, compiled by Retro68 into a real application with a
  proper resource fork.
- A later printer emits 68k assembly directly, enabling self-hosting.
- The IR names runtime primitives abstractly (`ir.alloc_handle`,
  `ir.blockmove`, `ir.str_eq`, …). No libc concept exists at the IR level.
  The C printer lowers intrinsics to Toolbox calls via Retro68's Universal
  Headers, so even the C output barely touches libc.

## 3. Language core

- Declarations: `var x: int`, `var b: Bookmark`, colon type syntax.
- Blocks with braces; statements newline-terminated; no semicolons.
- `record` — plain data aggregate. No methods, no inheritance.
- Enums: `protocol: (Gopher, HTTP, Telnet)`.
- Strings: `string(n)` is a fixed-size, length-prefixed Pascal string
  (n ≤ 255) — what the Toolbox eats natively. Bare `string` = `string(255)`.
- Fixed arrays: `var history: Bookmark[10]`.
- Growable, handle-backed types: `text` (unbounded text), `list of T`,
  `map of T` (§4).
- Functions with typed parameters and return values. Declare-before-use.
- Local variables are declared at the top of a function or handler body
  (Wirthian; keeps stack-frame layout trivial for the single-pass compiler).
- Single-pass compilable: no forward references, no whole-program inference.

Example:

```rust
record Bookmark {
    name:     string(63)
    url:      string(255)
    port:     int = 80
    protocol: (Gopher, HTTP, Telnet)
    favorite: bool
}

var bookmarks: list of Bookmark
var count: int = 0
```

## 4. Collection types

**`list of T`** — growable sequence, handle-backed. `add`, `remove`,
indexing, `for x in list`.

**`map of T`** — hashtable, string keys.

- Keys are strings up to 255 bytes, case-sensitive, byte-compared.
  (`EqualString`-based case-insensitive maps are a possible later option.)
- Values are any fixed-size type, records included. Handle-backed values
  (`text`, `list of T`) as map values are deferred — nesting handle-backed
  types inside handle-backed types complicates transparent locking.
- Storage: one relocatable handle containing a slot table (hash, 2-byte key
  offset, value) plus a packed key arena of length-prefixed strings — keys
  cost what they are, not 256 bytes per slot. Deleted keys leave arena holes
  until the next growth rehash compacts them.
- Operations: `m["k"] = v`, `m["k"]`, `m.has("k")`, `m.remove("k")`,
  `for key, v in m`.

## 5. Event model

The runtime owns `WaitNextEvent`, update/activate handling, and dispatch.
All user code is event handlers plus the plain functions they call:

```rust
extend Main {
    on Go.click { … }        // widget event
    on close { … }           // the window's own events: bare event name
}

extend File {                // menus scope the same way
    on Quit.select { quit }
}

on conn.received(data: text) { … }   // global resources: top-level handlers
every 2 ticks { … }          // a tick = 1/60 s, the Mac's native clock

on App.launch { … }          // always runs first, however we were started

on App.startEmpty {          // bare launch, no documents: nothing opens
    open Main                // by itself
}
```

**App lifecycle.** No window is displayed implicitly, and the built-in
`App` entity delivers startup in three events:

1. `on App.launch` — always runs first, however the app was started:
   app-wide setup (load preferences, register network services).
2. Then either `on App.openDocument(path: string)`, once per document the
   Finder launched or dropped on the app, **or** — if no documents were
   passed — `on App.startEmpty`, whose name says exactly when it runs: a
   bare launch. This mirrors the Mac's own OAPP/ODOC launch distinction,
   so a document launch never also opens an unwanted empty window.

`quit` requests flow through the windows: the runtime sends
`closeRequest` to every open window, and any handler that cancels aborts
the quit — so unsaved-changes logic is written once, per window, not
duplicated at quit time.

Widget and menu-item handlers live in an **`extend` block** naming their
window or menu, which provides the scope: inside `extend Main`, bare names
resolve against Main's widgets and fields, so two windows may each have an
`Add` button without ambiguity and nothing is retyped per handler. A window
may have any number of `extend` blocks (per feature, per file) — layout
stays purely declarative in the `window` block. Handlers for global
resources (`conn`, timers) are written at top level. `extend` is
deliberately contents-neutral: instance-scoped helper functions may be
allowed in it later, and the same construct could be folded inline into
`window` blocks if co-location proves wanted.

**Async model: everything is an event (no closures).** Async operations do
not take callbacks; they post completion events caught by named handlers
(`on fetcher.done(reply: text)`, `on fetcher.fail(err: error)`). State
between steps lives in globals or window fields. Inline continuation sugar
(`then` blocks) may be added later by compiling down to hidden named
handlers; the runtime never needs closure support.

## 6. Memory model

Two tiers with an invisible seam:

- **Tier 1 — A5 world.** Small fixed values (scalars, records, `string(n)`,
  small fixed arrays) are true globals: always resident, one-instruction
  access. Kept small (within the ~32K comfort zone shared with the jump
  table).
- **Tier 2 — handle-backed heap.** `text`, `list of T`, `map of T`, and any
  fixed type past a size threshold (~1–2K, a compiler flag) are transparently
  promoted: the global itself is the 4-byte handle; the payload is movable,
  compactable, and pageable under System 7 virtual memory. The compiler
  inserts locking around access. User code is identical in both tiers.

Rules:

- No `NewHandle`/`DisposeHandle`/pointer syntax in user code, ever.
- Resources (connections, browsers, forms) own their handles and free them
  when their window closes or the app quits.
- Purgeable handles are reserved for a future image/resource cache type
  only. User data is never purgeable.
- Out-of-memory is a runtime disaster: clean alert, quit (§10).

## 7. Windows, menus, widgets

`window` blocks are **declarations, not code**, compiled to real resources
(WIND/MENU/CNTL/DITL) — ResEdit can open the output. Menus likewise.

**Windows are instantiable templates** (multi-document capable):

- `open Doc` creates an instance with its own window and its own copy of
  the variables declared inside the block, stored in a record hung off the
  `WindowRecord` (a handle — instance state is swappable too).
- Inside a `Doc` handler the firing instance is implicit: bare names resolve
  to that instance's fields and widgets. Single-window apps never notice the
  machinery.
- Window variables are **references**: `var d: Doc` declares a nil
  reference (4 bytes, nothing to clean up); `d = open Doc` is an
  expression that creates the instance, opens its window, and returns the
  reference. `Doc.front` is the frontmost window *of type Doc*, or nil.
- Inside a window's handlers, the keyword `window` names the firing
  instance (for passing it to functions). `close w` closes an instance
  after its `closeRequest` runs; inside a request handler, the `cancel`
  statement aborts the pending close (or quit).
- **Menu handlers may live in a window's `extend` block** (qualified:
  `on File.Save.select` inside `extend Doc`), meaning "this command
  applies when a Doc is frontmost." The runtime auto-enables/disables such
  menu items as windows of that type come and go from the front — menu
  dimming, one of classic Mac's most tedious chores, requires no user
  code, and a handler can never fire without a valid `window`.

Layout: `at: x, y`, `width: fill`, `fill: both`, `at: right, 10`. The
runtime handles resize re-layout, grow box, update regions, and scrollbars
(`scrollbar: vertical`).

```rust
window Doc {
    title: "Untitled"
    size: 400, 300
    resizable: min(300, 200)

    textview Body { fill: both;  scrollbar: vertical }

    var path: string(255)
    var dirty: bool = false
}

menu File {
    item New  "New"   key "N"
    separator
    item Quit "Quit"  key "Q"
}

menu Edit { standard edit }   // Undo/Cut/Copy/Paste, pre-wired to text widgets
```

`standard edit` supplies the Mac-standard Edit menu items with clipboard
behavior already connected to `field`/`textview` widgets — required for a
native feel (and for desk accessories) but pure boilerplate otherwise. The
behavior is named by the keyword, not by the menu's name.

Widget set (v1): `button`, `field`, `textview`, `check`, `popup`, `table`,
`canvas`, static `label` text.

## 8. Forms and tables (data binding)

**Forms.** A window may declare `form of RecordType`. Widgets bind to record
fields by bare name (`binds: name` — inside a form block the record's fields
are the innermost scope). Types drive widget behavior with nothing specified
twice: enum → popup items, `bool` → checkbox, `int` → numeric validation,
`string(n)` → typing length limit.

- `edit FormWindow, someRecord` copies the record into a working buffer,
  fills the widgets, shows the form (movable modal by default).
- Cancel discards the buffer — the original record is untouched.
- OK validates each bound widget (bad field: beep, select, stay open),
  writes back, then fires `accepted`. Handlers only ever see clean data.
- `button OK { default }` / `button Cancel { cancel }` wire return/escape.

**Tables** bind to `list of T` and stay live — `add`/`remove`/writeback
invalidate the right rows automatically:

```rust
table Marks {
    rows: bookmarks
    column "Name" shows name     width 140
    column "URL"  shows url      width fill
}

extend Main {
    on Marks.doubleClick(i: int) {
        edit EditForm, bookmarks[i]
    }
}
```

Implementation: the compiler already holds per-record field tables (offsets,
types) for the IR; the runtime adds one generic fill/validate/writeback
walker (~2–3K of 68k code) serving every form in every program.

Auto-generated whole forms (`edit someRecord` with no window declared) are
future sugar: they compile down to a generated bound form.

## 9. Drawing, timers, games

`canvas` widget wrapping QuickDraw: `clear`, `line`, `rect`, `fillCircle`,
text drawing, offscreen buffering for flicker-free animation. Click/key
events deliver coordinates: `on Board.click(px: int, py: int)` inside
`extend Game`.

`every N ticks { }` timers are first-class; games and network polling both
need them. A `fixed` numeric type (Toolbox `FixMath`, 16.16 fixed-point)
provides smooth fractional motion without SANE floating-point overhead; it
supports the same arithmetic operators as `int` and converts explicitly.

## 10. Networking

**One stream abstraction over both stacks.** ADSP (AppleTalk) and TCP
(MacTCP) are both reliable byte streams; the transport is chosen at `open`
and invisible afterward. Name resolution (DNS or NBP) happens inside
`open`.

```rust
var conn: connection

conn.open("wds.example.com:70")                    // MacTCP + DNS
conn.open(appletalk "Andrew's Mac:ChatServer")     // NBP + ADSP

on conn.received(data: text) { … }
on conn.closed { … }
on conn.failed(err: error) { … }
```

**Servers:** a `listener` resource fires `on accepted(c: connection)`.
Registering an NBP name is one line.

**Service discovery** (`serviceBrowser`): NBP lookup by type/zone —
"find the other players on the LAN" is a first-class 80% case:

```rust
var browser: serviceBrowser
browser.find("ChatServer")
on browser.found(name: string, addr: address) { … }
```

Deferred to v2: HTTP convenience layer (`http.get`/`post`), UDP/DDP
datagrams. Both slot into the existing event model without new concepts.

## 11. Files

The 80% is documents plus one preferences file:

- `file.readText(path)`, `file.writeText(path, t)`.
- Record/list serialization: `file.save(path, bookmarks)` /
  `file.load(path, bookmarks)` — the binding metadata already knows field
  layouts.
- `askOpen(path)` / `askSave(path, suggestedName)` wrap Standard File
  dialogs: they fill the passed string and return `false` on cancel.
- `askSaveChanges(name)` shows the standard 3-way "Save changes to
  “name”?" dialog, returning a built-in `saveChoice` enum:
  `Save`, `Discard`, or `Cancel`.
- Document windows can declare their file type for Finder integration
  (type/creator codes; double-click opens the app with the document).
- No byte streams, no random access in v1.

## 12. Error handling

- **Async errors are events:** `on conn.failed(err: error)`.
- **Sync fallible operations** (file I/O, mostly) return `bool`; details in
  an inspectable `lastError`. No exceptions, no unwinding machinery.
- **Runtime disasters** (out of memory) show a clean alert and quit rather
  than corrupting the heap.

## 13. Toolbox-native, libc-free

The runtime's primitives are defined in terms of the Macintosh Toolbox — the
one dependency Clarus may confidently assume. No libc concept (null-terminated
strings, errno, a non-moving heap) exists at the IR level or in the runtime's
design.

| Instead of libc | The runtime uses |
|---|---|
| `malloc` / `free` | `NewHandle`, `SetHandleSize`, `DisposeHandle` |
| `memcpy` / `memmove` | `BlockMove` |
| `strcpy` / `strcmp` | Pascal-string ops, `EqualString` / `RelString` |
| `printf` / number formatting | `NumToString`, `StringToNum` |
| `fopen` / `fread` | File Manager (`PBOpen`, `PBRead`, …) |
| `time()` | `TickCount`, `GetDateTime` |
| `rand()` | QuickDraw `Random()` |
| floating point | SANE; `FixMath` fixed-point for games |

The v1 C printer may incidentally use libc where harmless (it is being
compiled by a C toolchain anyway), but lowers runtime intrinsics to the
Toolbox calls above. This keeps the runtime honest for System 6 on a Mac
Plus — where libc never existed but the Toolbox always does — and means the
future self-hosted compiler needs nothing but the Toolbox.

## 14. Out of scope for v1

Objects/inheritance, closures, HTTP layer, UDP/DDP, auto-generated forms,
printing, desk accessories, color QuickDraw beyond basics, PowerPC,
case-insensitive maps, handle-backed values inside maps.

## 15. Worked example: bookmark manager

A complete bookmark manager — data, live table, bound edit form:

```rust
record Bookmark {
    name:     string(63)
    url:      string(255)
    port:     int = 80
    protocol: (Gopher, HTTP, Telnet)
    favorite: bool
}

var bookmarks: list of Bookmark

window Main {
    title: "Bookmarks"
    size: 420, 300
    resizable

    table Marks {
        rows: bookmarks
        column "Name" shows name     width 140
        column "URL"  shows url      width fill
        column "Fav"  shows favorite width 30
    }
    button Add    { at: 10, bottom;   caption: "Add…" }
    button Remove { at: next, bottom; caption: "Remove" }
}

window EditForm {
    title: "Edit Bookmark"
    form of Bookmark

    field Name     { binds: name;     label: "Name:" }
    field Url      { binds: url;      label: "URL:" }
    field Port     { binds: port;     label: "Port:";  width: 60 }
    popup Protocol { binds: protocol; label: "Protocol:" }
    check Fav      { binds: favorite; caption: "Favorite" }

    button OK      { default }
    button Cancel  { cancel }
}

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

    on Remove.click {
        bookmarks.remove(Marks.selected)
    }
}

extend EditForm {
    on accepted(b: Bookmark) {
        if b.isNew { bookmarks.add(b) }
    }
}
```

## 16. Worked example: text editor

A complete multi-document plain-text editor — menus, document launching,
and unsaved-changes handling:

```rust
window Doc {
    title: "Untitled"
    size: 460, 320
    resizable: min(200, 120)

    textview Body { fill: both;  scrollbar: vertical }

    var path: string(255)          // empty until first saved
    var dirty: bool = false
}

menu File {
    item New    "New"       key "N"
    item Open   "Open…"     key "O"
    item Save   "Save"      key "S"
    item SaveAs "Save As…"
    separator
    item Quit   "Quit"      key "Q"
}

menu Edit { standard edit }        // Undo/Cut/Copy/Paste, pre-wired

func openPath(p: string) {
    var d: Doc

    d = open Doc
    if file.readText(p, d.Body.text) {
        d.path = p
        d.title = file.name(p)
    } else {
        alert("Couldn't open “" + file.name(p) + "”")
        close d
    }
}

func save(d: Doc): bool {
    if d.path == "" {
        if not askSave(d.path, "Untitled") { return false }   // fills d.path
    }
    if not file.writeText(d.path, d.Body.text) {
        alert("Couldn't save: " + lastError.message)
        return false
    }
    d.title = file.name(d.path)
    d.dirty = false
    return true
}

on App.startEmpty {                // bare launch: one empty document
    open Doc
}

on App.openDocument(p: string) {   // double-clicked / dropped documents:
    openPath(p)                    // fires per file; startEmpty does not
}

extend File {                      // app-level commands: always enabled
    on New.select  { open Doc }

    on Open.select {
        var p: string(255)

        if askOpen(p) { openPath(p) }
    }

    on Quit.select { quit }        // runtime sends closeRequest to every
}                                  // open window; any cancel aborts quit

extend Doc {                       // document commands: the runtime dims
                                   // these items when no Doc is frontmost
    on File.Save.select { save(window) }

    on File.SaveAs.select {
        path = ""                  // forget the path to force the dialog
        save(window)
    }

    on Body.change {
        dirty = true
    }

    on closeRequest {              // close box — and each window at quit
        var c: saveChoice

        if dirty {
            c = askSaveChanges(title)
            if c == Cancel { cancel }
            if c == Save and not save(window) { cancel }
        }
    }
}
```

Points of note:

- Save and Save As live in `extend Doc`, so they only ever run with a Doc
  frontmost — and the runtime dims those menu items whenever that isn't
  true. Menu enabling logic: zero lines.
- The whole "quit with unsaved windows" story is the `closeRequest`
  handler, written once.
- Launching by double-clicking three files opens three windows and no
  empty "Untitled" — `App.openDocument` replaces `App.startEmpty` on a
  document launch (§5).
- `save` is an ordinary function taking a `Doc` instance; handlers pass
  `window`. No methods needed.
- With a declared document file type for Finder integration (§11), this
  is a complete, shippable System 6/7 application in under 100 lines.
