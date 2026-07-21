# Clarus Language Reference Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Write `docs/clarus-language-reference.md` — the complete developer-facing reference for Clarus v1: enough to write an application from, and the normative contract the compiler will be built against.

**Architecture:** One Markdown document built chapter by chapter, each task appending sections and committing. Content decisions not present in the design spec (operator precedence, literal syntax, keyword classes, per-widget property/event inventories, EBNF) are made *in this plan* and copied into the doc verbatim. The design spec (`docs/superpowers/specs/2026-07-21-clarus-language-design.md`) is the authority where it speaks; this reference elaborates but never contradicts it.

**Tech Stack:** Markdown only. Verification is `grep`-based consistency checking — no toolchain exists yet.

## Global Constraints

- Target platform: System 6 and 7 on 68k Macintosh (from the spec §1).
- The reference documents **v1 only**. Deferred features (spec §14) appear only in a short "Not in v1" appendix note, never in the main chapters.
- Both worked examples are copied **verbatim from the spec** (§15, §16) — if a reference chapter contradicts an example, the chapter is wrong; fix the chapter (or flag the spec conflict to the user, never silently change an example).
- All code fences in the doc use ```rust (matches spec convention for syntax highlighting).
- Event names, type names, keyword spellings must match the spec exactly: `App.launch`, `App.startEmpty`, `App.openDocument`, `closeRequest`, `saveChoice`, `standard edit`, `window` (self-ref), `extend`, `me` does NOT exist (replaced by `window`).
- File being written: `docs/clarus-language-reference.md` (single file; chapters appended in order, so tasks must run in sequence).

---

### Task 1: Document skeleton + Lexical structure chapter

**Files:**
- Create: `docs/clarus-language-reference.md`

**Interfaces:**
- Produces: chapter numbering 1–12 + appendices A–C used by all later tasks; the keyword tables and operator table that Tasks 2–3 must not contradict.

- [ ] **Step 1: Create the file with title, intro, and TOC**

Write exactly this structure (prose may be lightly expanded, headings fixed):

```markdown
# The Clarus Language Reference

Version: v1 draft. Companion to the [design spec](superpowers/specs/2026-07-21-clarus-language-design.md), which is authoritative on rationale; this document is authoritative on surface details.

Clarus is a small, compiled, event-driven language for building native
System 6/7 applications on 68k Macintosh computers.

## Contents
1. Program Structure
2. Lexical Structure
3. Types
4. Expressions and Operators
5. Statements
6. Functions
7. Application Lifecycle
8. Windows and Widgets
9. Menus
10. Forms and Tables
11. Drawing and Timers
12. Networking, Files, and Errors
Appendix A. Grammar (EBNF)
Appendix B. Event Handler Quick Reference
Appendix C. Worked Examples
```

- [ ] **Step 2: Write Chapter 1 — Program Structure**

Content requirements (all normative, write as prose with one example):
- A program is one or more `.cla` source files; compilation is single-pass over the concatenation in a declared file order (build details out of scope here).
- Top-level declarations, in any order **subject to declare-before-use**: `record`, `var`, `func`, `window`, `menu`, `extend`, top-level `on` handlers (App and global resources), `every` blocks.
- Declare-before-use: every name must be declared textually before its first use. No forward references.
- Local variables are declared at the top of a function or handler body, before any statement.
- There is no `main`; execution begins with the runtime, which fires `App.launch` (see Chapter 7).
- Comments: `//` to end of line. There are no block comments in v1.

- [ ] **Step 3: Write Chapter 2 — Lexical Structure**

Content (normative tables, copy exactly):

**Identifiers:** letter followed by letters/digits/underscores; case-sensitive. Convention (not enforced): types, windows, menus, widgets capitalized; variables and functions lowerCamel.

**Hard keywords** (reserved everywhere):
```
var func record window menu extend on every
if else while for in to return
and or not true false nil
open close edit new quit cancel
```
Note: `window` is both the declaration keyword and, inside a window's handlers, the expression naming the firing instance (Chapter 8). The parser distinguishes by position.

**Contextual keywords** (special meaning only in the noted position, usable as identifiers elsewhere):
```
list map of string text int bool fixed        (type positions)
item separator standard key                    (menu bodies)
form binds shows rows column width             (window/form/table bodies)
title size resizable min at fill scrollbar
caption label default ticks
```

**Literals:**
| Kind | Forms | Notes |
|---|---|---|
| Integer | `42`, `-7`, `0x1F` | 32-bit signed; hex with `0x` |
| Fixed | `1.5`, `0.25` | 16.16 fixed-point (no float type in v1) |
| Character | `'A'`, `'\n'` | single Mac Roman character; same escapes as strings |
| String | `"hello"` | escapes: `\"` `\\` `\n` `\t`; `\n` emits CR (13), the Mac newline |
| Boolean | `true`, `false` | |
| Nil | `nil` | window/resource references only |
| Enum member | bare identifier | resolved against the expected enum type |

**Statement termination:** newline ends a statement (Go-style). A line ending in an operator, comma, or opening bracket continues. No semicolons; `;` may separate multiple property declarations on one line inside declaration blocks only (as in the spec's examples).

- [ ] **Step 4: Verify internal consistency**

Run: `grep -n 'dim \|begin\|end if\|;$' docs/clarus-language-reference.md`
Expected: no output (no BASIC/Pascal residue, no trailing semicolons in code).

- [ ] **Step 5: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: skeleton, program structure, lexical chapter"
```

---

### Task 2: Types chapter

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapter 3)

**Interfaces:**
- Consumes: literal table from Task 1.
- Produces: the canonical type inventory; Tasks 3–8 must use exactly these names: `int`, `bool`, `fixed`, `string(n)`, `string`, `text`, enum types, `record`, `T[n]`, `list of T`, `map of T`, window reference types, resource types `connection`, `listener`, `serviceBrowser`, `error`, `address`, built-in enum `saveChoice`.

- [ ] **Step 1: Write Chapter 3 — Types**

Normative table:

| Type | Size | Storage | Description |
|---|---|---|---|
| `int` | 4 bytes | inline | 32-bit signed integer |
| `bool` | 1 byte | inline | `true` / `false` |
| `fixed` | 4 bytes | inline | 16.16 fixed-point (Toolbox `Fixed`) |
| `char` | 1 byte | inline | unsigned 8-bit Mac Roman character; doubles as a byte (0–255) for binary data |
| `string(n)` | n+1 bytes | inline | length-prefixed Pascal string, n ≤ 255; `string` alone = `string(255)` |
| enum `(A, B, C)` | 2 bytes | inline | named in a record field or type position |
| `record` | sum of fields | inline | plain data aggregate; no methods |
| `T[n]` | n × size(T) | inline* | fixed array, 0-indexed |
| `text` | 4-byte handle | heap | unbounded text buffer |
| `list of T` | 4-byte handle | heap | growable sequence of fixed-size T |
| `map of T` | 4-byte handle | heap | hashtable, string keys ≤ 255 bytes, values fixed-size |
| window ref (e.g. `Doc`) | 4 bytes | inline | reference to a window instance; `nil` until assigned |
| `connection`, `listener`, `serviceBrowser` | opaque | resource | networking resources (Chapter 12) |
| `error` | record | inline | `{ code: int, message: string }` |
| `address` | opaque | inline | network address from a `serviceBrowser` |
| `saveChoice` | enum | inline | built-in: `Save`, `Discard`, `Cancel` |

\* "inline" values past a size threshold are transparently promoted to handle-backed storage by the compiler (spec §6); semantics are identical.

Also cover in prose:
- Record declaration syntax with field defaults (`port: int = 80`).
- Assignment of records/arrays copies by value. `text`, `list`, `map` variables copy the *reference* (same underlying handle).
- No implicit numeric conversions. `fixed(i)`, `int(f)`, `int(c)`, and `char(i)` convert explicitly (numeric conversions truncate toward zero; `char(i)` takes the low byte).
- String indexing: `s[i]` yields a `char`, 0-based like arrays (the length prefix is invisible); `s[i] = c` assigns in place; `s.length` is an `int`. `string + char` appends. `char` compares byte-wise with the usual operators.
- Enum values: compared with `==`/`!=` only; converted with `int(e)`; not ordered.
- `list of T` operations: `l.add(v)`, `l.remove(i)`, `l[i]`, `l.count`, `for x in l`.
- `map of T` operations: `m[k] = v`, `m[k]` (runtime error if absent), `m.has(k)`, `m.remove(k)`, `m.count`, `for k, v in m`.
- `text` operations: assignment, `+` concatenation, `t.length`, comparison with `==`.
- Indexing out of range / missing map key / nil window deref: runtime error alert (Chapter 12).

- [ ] **Step 2: Verify type names match the spec**

Run: `grep -n 'string(63)\|string(255)\|list of\|map of\|saveChoice' docs/clarus-language-reference.md docs/superpowers/specs/2026-07-21-clarus-language-design.md | head -40`
Expected: identical spellings in both files.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: types chapter"
```

---

### Task 3: Expressions/Operators and Statements chapters

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapters 4–5)

**Interfaces:**
- Consumes: type inventory from Task 2.
- Produces: operator precedence table and statement forms used by the EBNF in Task 8.

- [ ] **Step 1: Write Chapter 4 — Expressions and Operators**

Normative precedence table (highest first):

| Level | Operators | Notes |
|---|---|---|
| 1 | `()` grouping, `f(args)` call, `a[i]` index, `a.b` field/property, `new T`, `open T` | postfix/primary |
| 2 | unary `-`, `not` | |
| 3 | `*` `/` `mod` | `/` on int truncates toward zero; `fixed` uses `FixMul`/`FixDiv` |
| 4 | `+` `-` | `+` also concatenates strings and text |
| 5 | `==` `!=` `<` `<=` `>` `>=` | strings compare byte-wise, case-sensitive |
| 6 | `and` | short-circuit |
| 7 | `or` | short-circuit |

- Assignment (`=`) is a **statement**, not an expression; no `+=`, no `++` in v1.
- No bitwise operators in v1.
- Mixed `int`/`fixed` arithmetic is a compile error; convert explicitly.
- `string + string` yields a temporary whose length is checked at the assignment target (truncation is a runtime error, not silent).

- [ ] **Step 2: Write Chapter 5 — Statements**

Cover each with a 2–4 line example:
- `var name: Type` / `var name: Type = expr` (top of body only)
- assignment `lvalue = expr`
- call statement `f(args)`, method-style calls `conn.open(...)`, `l.add(v)`
- `if expr { } else if expr { } else { }` — condition must be `bool`, no parens required
- `while expr { }`
- `for x in listExpr { }` / `for k, v in mapExpr { }` / `for i in 0 to 9 { }` (inclusive range)
- `return` / `return expr`
- `open WindowType` (statement) and `w = open WindowType` (expression form, Chapter 8)
- `close windowRef`
- `edit FormWindow, recordLvalue` (Chapter 10)
- `quit` — requests app quit (flows through every window's `closeRequest`)
- `cancel` — only inside `closeRequest`: aborts the pending close/quit
- No `break`/`continue` in v1 (restructure with `while` + flag, or `return`).

- [ ] **Step 3: Write Chapter 6 — Functions**

- `func name(p: Type, q: Type): ReturnType { }`; return type optional (procedure).
- Parameters: scalars/records/strings pass **by value**; `text`, `list`, `map`, window refs pass by reference (they are references). A parameter documented as filled by the callee (e.g. `file.readText(path, t)`) mutates the passed `text`/`list`/`map` in place; out-params of fixed-size types are not supported in v1 — return them instead.
- Recursion allowed. No overloading, no default parameter values, no varargs.
- Functions may be declared at top level only (window-scoped helpers are a possible future `extend` addition, not v1).

- [ ] **Step 4: Verify examples parse by eye against the spec's code**

Run: `grep -n 'for \|while \|if ' docs/superpowers/specs/2026-07-21-clarus-language-design.md | head`
Expected: every construct used in the spec's examples has a section in Chapters 4–6.

- [ ] **Step 5: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: expressions, statements, functions"
```

---

### Task 4: Application Lifecycle chapter

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapter 7)

**Interfaces:**
- Consumes: statement forms (Task 3).
- Produces: the `App` event inventory used by Appendix B (Task 9).

- [ ] **Step 1: Write Chapter 7 — Application Lifecycle**

Normative event inventory for `App` (v1 complete list):

| Event | Signature | When |
|---|---|---|
| `App.launch` | `on App.launch { }` | Always first, once, before any window exists. App-wide setup. |
| `App.openDocument` | `on App.openDocument(path: string) { }` | Once per document the Finder launched the app with, or dropped on it while running. |
| `App.startEmpty` | `on App.startEmpty { }` | After `launch`, only when the app was started with **no** documents. |

Prose requirements:
- Nothing opens implicitly; a program with no `App.startEmpty` handler and a bare launch shows only the menu bar.
- Launch order diagram: `launch` → (`openDocument` × N | `startEmpty`).
- `quit` semantics: runtime sends `closeRequest` to every open window (front to back); any `cancel` aborts the quit; otherwise windows close and the app exits.
- Mention: these mirror the Mac's OAPP/ODOC launch events (one sentence; rationale lives in the spec).
- Timers: `every N ticks { }` at top level; a tick is 1/60 s; the block runs on the main event loop (never reentrantly).

- [ ] **Step 2: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: application lifecycle"
```

---

### Task 5: Windows/Widgets and Menus chapters

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapters 8–9)

**Interfaces:**
- Consumes: type inventory (Task 2), lifecycle (Task 4).
- Produces: per-widget property and event inventories consumed by Appendix B; widget kind list: `button`, `field`, `textview`, `check`, `popup`, `table`, `canvas`, `label`.

- [ ] **Step 1: Write Chapter 8 — Windows and Widgets**

**Window declaration** — properties (v1 complete):
| Property | Form | Meaning |
|---|---|---|
| `title` | `title: "Untitled"` | initial title; assignable at runtime (`w.title = ...`) |
| `size` | `size: 400, 300` | content size in pixels |
| `resizable` | `resizable` or `resizable: min(300, 200)` | grow box + optional minimum |
| `form of T` | `form of Bookmark` | marks a form window (Chapter 10) |

**Window body** may contain: properties, widget declarations, `var` declarations (per-instance state), `form of`.

**Window instance semantics** (condense spec §7, all of):
- instantiable templates; `open Doc` creates+opens; expression form returns the reference
- `var d: Doc` is a nil reference; nil deref is a runtime error
- `Doc.front` — frontmost instance of that type or nil
- `window` keyword names the firing instance inside handlers
- per-instance vars live in a handle hung off the WindowRecord
- bare-name resolution inside `extend Doc`: fields and widgets of the firing instance, then globals
- `close ref`; `closeRequest` + `cancel`

**Window events** (v1 complete): `opened`, `closeRequest`, `closed`, `resized`, `key(k: char)`.

**Widget inventory** — for each: properties table + events table (v1 complete):

| Widget | Properties | Runtime properties | Events |
|---|---|---|---|
| `button` | `caption`, `at`, `width`, `default`, `cancel` | `caption`, `enabled` | `click` |
| `field` | `label`, `at`, `width`, `binds` | `text`, `enabled` | `change`, `enter` |
| `textview` | `at`, `fill`, `scrollbar` (`vertical`\|`both`) | `text` | `change` |
| `check` | `caption`, `at`, `binds` | `checked` | `change` |
| `popup` | `label`, `at`, `binds` | `selected` (int index) | `change` |
| `table` | `rows`, `column ...` (Chapter 10), `at`, `fill` | `selected` (int, −1 none) | `select(i: int)`, `doubleClick(i: int)` |
| `canvas` | `at`, `fill`, `buffered` | — | `click(x: int, y: int)`, `drag(x: int, y: int)` |
| `label` | `text`, `at` | `text` | — |

**Layout** properties: `at: x, y` (top-left); `at: right, y` / `at: next, bottom` (edge-relative); `width: fill`; `fill: both` — resize re-layout is automatic; widgets keep edge-relative positions.

- [ ] **Step 2: Write Chapter 9 — Menus**

- Declaration: `menu Name { item Ident "Caption" key "K" ... separator ... }`; `key` is the ⌘-equivalent, optional.
- `standard edit` inside a menu body: supplies Undo/Cut/Copy/Paste wired to `field`/`textview`; behavior named by keyword, not menu name.
- Events: each `item` fires `select` — handled in `extend MenuName { on Item.select { } }`.
- Window-scoped commands: nest `extend MenuName { }` inside `extend WindowType { }`; runtime auto-dims those items when no such window is frontmost; handlers get a valid `window`. Copy the spec §7 nested-extend example verbatim.
- Runtime menu-item property: `enabled` (for app-level items needing manual control, e.g. `File.Save.enabled = false`).
- The Apple menu and About item are provided by the runtime automatically (About text: future; one line saying v1 shows app name only).

- [ ] **Step 3: Verify inventories cover every event used in spec examples**

Run: `grep -n 'on [A-Za-z]' docs/superpowers/specs/2026-07-21-clarus-language-design.md`
Expected: every event named (click, change, doubleClick, select, accepted, closeRequest, received, closed, failed, found, launch, startEmpty, openDocument, key...) appears in a chapter table written so far or is scheduled for Chapters 10–12.

- [ ] **Step 4: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: windows, widgets, menus"
```

---

### Task 6: Forms and Tables chapter

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapter 10)

**Interfaces:**
- Consumes: widget inventory (Task 5), record types (Task 2).
- Produces: form window events `accepted(rec: T)`, `cancelled`; `edit` statement semantics; `rec.isNew`; table `column` syntax.

- [ ] **Step 1: Write Chapter 10 — Forms and Tables**

Forms (condense spec §8, all of):
- `form of T` in a window; `binds: fieldName` on widgets (bare name resolves against T's fields first).
- Type-driven behavior table: `string(n)` → typing length limit; `int` → numeric validation; `bool` → checkbox; enum → popup items from member names; `fixed` → numeric with decimal point.
- `edit FormWin, recordLvalue`: buffer copy in, movable-modal show, Cancel discards, OK validates (beep + select bad field + stay open), writes back, fires `accepted(rec: T)`.
- `new T` as the edit target creates a blank record; inside `accepted`, `rec.isNew` is true for that case.
- `cancelled` event fires on Cancel (optional to handle).
- `button OK { default }` / `button Cancel { cancel }` behavior.

Tables:
- `rows: listExpr` binding; live invalidation on `add`/`remove`/element writeback.
- `column "Header" shows fieldName width N` / `width fill`; `shows` resolves against the row record type; `bool` columns render a checkmark; enum columns render the member name.
- Selection model: single-select in v1; `selected` property; `select`/`doubleClick` events.

- [ ] **Step 2: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: forms and tables"
```

---

### Task 7: Drawing/Timers and Networking/Files/Errors chapters

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Chapters 11–12)

**Interfaces:**
- Consumes: `canvas` widget (Task 5), resource types (Task 2).
- Produces: canvas method inventory; `connection`/`listener`/`serviceBrowser`/`file`/dialog API inventories consumed by Appendix B.

- [ ] **Step 1: Write Chapter 11 — Drawing and Timers**

Canvas methods (v1 complete):
```
c.clear()
c.line(x1, y1, x2, y2: int)
c.rect(x, y, w, h: int)        c.fillRect(x, y, w, h: int)
c.circle(x, y, r: int)         c.fillCircle(x, y, r: int)
c.drawText(x, y: int, s: string)
c.width  c.height              // runtime properties, int
```
- All coordinates are `int` pixels, origin top-left of the canvas.
- `buffered` canvases draw offscreen and blit on return to the event loop (flicker-free); unbuffered draw immediately.
- Drawing outside a handler/timer is not possible (no code runs there).
- `every N ticks { }` recap + `fixed` for smooth motion, one short bounce example (may reuse spec §9 fragment).

- [ ] **Step 2: Write Chapter 12 — Networking, Files, and Errors**

**connection** (v1 complete):
| Member | Form |
|---|---|
| `open` | `c.open("host:port")` — MacTCP, DNS inside; `c.open(appletalk "Name:Type")` — ADSP, NBP inside; `c.open(addr)` — from a browser `address` |
| `send` | `c.send(t: text)` (also accepts string) |
| `close` | `c.close()` |
| events | `opened`, `received(data: text)`, `closed`, `failed(err: error)` |

**listener**: `l.listen(port: int)` (TCP) / `l.register(name: string, type: string)` (ADSP + NBP registration); events `accepted(c: connection)`, `failed(err: error)`. The `connection` delivered by `accepted` is bound to a global `connection` variable named in the handler's parameter — document the pattern of assigning it to a free slot in a fixed array of connections for multi-client servers (short example).

**serviceBrowser**: `b.find(type: string)` (current zone, v1); events `found(name: string, addr: address)`, `failed(err: error)`.

**file** namespace (all return `bool`, false ⇒ inspect `lastError`):
`file.readText(path: string, t: text)`, `file.writeText(path: string, t: text)`, `file.save(path: string, data)`, `file.load(path: string, data)` (data: any record, `list of` record, or `map of` record), `file.name(path: string): string` (display name; always succeeds).

**Dialogs:** `alert(msg: string)`, `askOpen(path: string): bool`, `askSave(path: string, suggested: string): bool`, `askSaveChanges(name: string): saveChoice`.

**Errors:** `error` record `{ code: int, message: string }`; global `lastError`; async errors via `failed` events; out-of-memory = alert + quit; runtime errors (nil deref, index out of range, string truncation, missing map key) = alert naming the handler, then app continues if safe or quits if not.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: drawing, timers, networking, files, errors"
```

---

### Task 8: Appendix A — Grammar (EBNF)

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Appendix A)

**Interfaces:**
- Consumes: every syntax form from Chapters 1–12.
- Produces: the EBNF the compiler front-end plan (Plan 2) will implement.

- [ ] **Step 1: Write the EBNF**

Copy this grammar (adjusting only if a chapter written earlier contradicts it — then flag the conflict):

```ebnf
program     = { topDecl } ;
topDecl     = recordDecl | varDecl | funcDecl | windowDecl
            | menuDecl | extendDecl | handlerDecl | everyDecl ;

recordDecl  = "record" IDENT "{" { fieldDecl } "}" ;
fieldDecl   = IDENT ":" type [ "=" literal ] ;

type        = "int" | "bool" | "fixed" | "char" | "text"
            | "string" [ "(" INT ")" ]
            | "list" "of" type
            | "map" "of" type
            | enumType
            | IDENT
            | type "[" INT "]" ;
enumType    = "(" IDENT { "," IDENT } ")" ;

varDecl     = "var" IDENT ":" type [ "=" expr ] ;
funcDecl    = "func" IDENT "(" [ params ] ")" [ ":" type ] block ;
params      = param { "," param } ;
param       = IDENT ":" type ;

windowDecl  = "window" IDENT "{" { windowItem } "}" ;
windowItem  = property | widgetDecl | varDecl | "form" "of" IDENT ;
widgetDecl  = widgetKind IDENT [ "{" propertyList "}" ] ;
widgetKind  = "button" | "field" | "textview" | "check" | "popup"
            | "table" | "canvas" | "label" ;
propertyList= property { ";" property } ;
property    = IDENT [ ":" propValue { "," propValue } ]
            | "column" STRING "shows" IDENT "width" ( INT | "fill" ) ;
propValue   = expr | IDENT "(" [ args ] ")" ;

menuDecl    = "menu" IDENT "{" { menuEntry } "}" ;
menuEntry   = "item" IDENT STRING [ "key" STRING ]
            | "separator"
            | "standard" "edit" ;

extendDecl  = "extend" IDENT "{" { handlerDecl | extendDecl } "}" ;
handlerDecl = "on" eventPath [ "(" params ")" ] block ;
eventPath   = IDENT { "." IDENT } ;
everyDecl   = "every" INT "ticks" block ;

block       = "{" { stmt } "}" ;
stmt        = varDecl | assign | callStmt | ifStmt | whileStmt
            | forStmt | returnStmt
            | "quit" | "cancel"
            | "open" IDENT | "close" expr
            | "edit" IDENT "," ( lvalue | "new" IDENT ) ;
assign      = lvalue "=" expr ;
lvalue      = IDENT { "." IDENT | "[" expr "]" } ;
callStmt    = lvalue "(" [ args ] ")" ;
ifStmt      = "if" expr block [ "else" ( ifStmt | block ) ] ;
whileStmt   = "while" expr block ;
forStmt     = "for" IDENT [ "," IDENT ] "in" forRange block ;
forRange    = expr [ "to" expr ] ;
returnStmt  = "return" [ expr ] ;

expr        = andExpr { "or" andExpr } ;
andExpr     = cmpExpr { "and" cmpExpr } ;
cmpExpr     = addExpr [ cmpOp addExpr ] ;
cmpOp       = "==" | "!=" | "<" | "<=" | ">" | ">=" ;
addExpr     = mulExpr { ( "+" | "-" ) mulExpr } ;
mulExpr     = unaryExpr { ( "*" | "/" | "mod" ) unaryExpr } ;
unaryExpr   = [ "-" | "not" ] postfix ;
postfix     = primary { "." IDENT | "[" expr "]" | "(" [ args ] ")" } ;
primary     = literal | IDENT | "window" | "nil"
            | "new" IDENT | "open" IDENT | "(" expr ")" ;
args        = expr { "," expr } ;
literal     = INT | HEXINT | FIXEDLIT | CHARLIT | STRING | "true" | "false" ;
```

Note under the grammar: newline sensitivity (statement termination, Chapter 2) is handled by the lexer, not shown in the EBNF; `appletalk` in `conn.open(appletalk "...")` is a contextual keyword parsed as a call-argument prefix.

- [ ] **Step 2: Cross-check grammar against both worked examples by eye**

Read spec §15 and §16; every line must derive from the grammar. Known checks: `resizable` bare property (property with no value — covered), `menu Edit { standard edit }`, nested `extend`, `every 2 ticks`, `if c == Save and not save(window) { cancel }`.
Expected: no underivable lines. If found: fix grammar, note in commit message.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: EBNF grammar appendix"
```

---

### Task 9: Appendix B — Event Handler Quick Reference

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Appendix B)

**Interfaces:**
- Consumes: every event table from Chapters 7–12.

- [ ] **Step 1: Write the consolidated table**

One table, grouped by resource, every v1 event with full signature (this is the user-requested "all valid event handlers per resource" deliverable — it must be complete):

| Resource | Event | Handler signature |
|---|---|---|
| App | launch | `on App.launch { }` |
| App | startEmpty | `on App.startEmpty { }` |
| App | openDocument | `on App.openDocument(path: string) { }` |
| window | opened | `on opened { }` (in `extend W`) |
| window | closeRequest | `on closeRequest { }` — `cancel` allowed |
| window | closed | `on closed { }` |
| window | resized | `on resized { }` |
| window | key | `on key(k: char) { }` |
| form window | accepted | `on accepted(rec: T) { }` |
| form window | cancelled | `on cancelled { }` |
| button | click | `on Name.click { }` |
| field | change | `on Name.change { }` |
| field | enter | `on Name.enter { }` |
| textview | change | `on Name.change { }` |
| check | change | `on Name.change { }` |
| popup | change | `on Name.change { }` |
| table | select | `on Name.select(i: int) { }` |
| table | doubleClick | `on Name.doubleClick(i: int) { }` |
| canvas | click | `on Name.click(x: int, y: int) { }` |
| canvas | drag | `on Name.drag(x: int, y: int) { }` |
| menu item | select | `on Item.select { }` (in `extend Menu`) |
| connection | opened | `on c.opened { }` |
| connection | received | `on c.received(data: text) { }` |
| connection | closed | `on c.closed { }` |
| connection | failed | `on c.failed(err: error) { }` |
| listener | accepted | `on l.accepted(c: connection) { }` |
| listener | failed | `on l.failed(err: error) { }` |
| serviceBrowser | found | `on b.found(name: string, addr: address) { }` |
| serviceBrowser | failed | `on b.failed(err: error) { }` |
| (timer) | — | `every N ticks { }` |

- [ ] **Step 2: Verify completeness against chapters**

Run: `grep -n '`on \|on [A-Za-z]*\.' docs/clarus-language-reference.md | wc -l`
Then manually confirm every event in Chapters 7–12 appears in Appendix B and vice versa.
Expected: 1:1 match; fix whichever side is missing.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: event handler quick reference"
```

---

### Task 10: Appendix C — Worked examples + final review

**Files:**
- Modify: `docs/clarus-language-reference.md` (append Appendix C)

**Interfaces:**
- Consumes: spec §15 and §16 verbatim.

- [ ] **Step 1: Copy both examples**

Copy the bookmark manager (spec §15) and the text editor (spec §16) code blocks **verbatim** into Appendix C, each with its one-paragraph introduction adapted from the spec. Include the spec's "points of note" bullets for the text editor.

- [ ] **Step 2: Full-document consistency pass**

- Run: `grep -n 'TBD\|TODO\|???' docs/clarus-language-reference.md` — expected: no output.
- Every identifier used in Appendix C must be documented: spot-check `saveChoice`, `askSaveChanges`, `file.name`, `lastError.message`, `window`, `Doc.front`, `standard edit`, `separator`, `binds`, `shows`, `isNew` against their chapters.
- Confirm chapter numbers in the TOC match actual headings.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "reference: worked examples appendix, consistency pass"
```

---

## Roadmap context (later plans, not this one)

1. ~~Language reference~~ (this plan)
2. Compiler front end — lexer/parser/typed AST/checker against Appendix A; bootstrap implementation language decided at the top of that plan
3. IR + host C printer — semantics golden-tested natively, no emulator
4. Mac target — Retro68 pipeline, resource emission, runtime shell, first app in Mini vMac
5. Memory + forms runtime — handles, `text`/`list`/`map`, binding walker, files
6. Networking — MacTCP + AppleTalk drivers behind `connection`/`listener`/`serviceBrowser`
