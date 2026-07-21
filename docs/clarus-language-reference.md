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

## Chapter 1: Program Structure

A Clarus program consists of one or more `.cla` source files. Compilation is single-pass over the concatenation of files in a declared file order (build details are out of scope for this reference).

The following declarations may appear at the top level, in any order, subject to declare-before-use:

- `record` declarations
- `var` declarations
- `func` declarations
- `window` declarations
- `menu` declarations
- `extend` blocks
- Top-level `on` handlers (App and global resources)
- `every` blocks

**Declare-before-use:** Every name must be declared textually before its first use. No forward references are permitted.

Within a function or event handler body, local variables are declared at the top, before any statement.

There is no `main` function. Execution begins with the runtime, which fires `App.launch` (see Chapter 7).

**Comments:** Comments begin with `//` and extend to the end of the line. There are no block comments in v1.

Example program structure:

```rust
// A complete (tiny) Clarus program

record Person {
    name: string(63)
    age:  int
}

var visitors: list of Person

func describe(p: Person): string {
    return p.name + " is here"
}

on App.startEmpty {
    // a real program would open a window here (Chapter 8)
    quit
}
```

## Chapter 2: Lexical Structure

### Identifiers

Identifiers begin with a letter and continue with letters, digits, or underscores. Identifiers are case-sensitive.

Convention (not enforced): types, windows, menus, and widgets use CapitalCase; variables and functions use lowerCamelCase.

### Keywords

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

### Literals

| Kind | Forms | Notes |
|---|---|---|
| Integer | `42`, `-7`, `0x1F` | 32-bit signed; hex with `0x` |
| Fixed | `1.5`, `0.25` | 16.16 fixed-point (no float type in v1) |
| Character | `'A'`, `'\n'` | single Mac Roman character; same escapes as strings |
| String | `"hello"` | escapes: `\"` `\\` `\n` `\t`; `\n` emits CR (13), the Mac newline |
| Boolean | `true`, `false` | |
| Nil | `nil` | window/resource references only |
| Enum member | bare identifier | resolved against the expected enum type |

### Statement Termination

A newline ends a statement (Go-style). A line ending in an operator, comma, or opening bracket continues to the next line. No semicolons are required; `;` may separate multiple property declarations on one line inside declaration blocks only (as shown in design examples).

## Chapter 3: Types

Clarus is statically typed. All types are known at compile time; values are either stored inline or as opaque heap-allocated handles. The following table is the canonical inventory of types:

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

### Records and Defaults

A record declares a set of named fields, each with a type. Fields may have default values:

```rust
record Connection {
    host:    string(255)
    port:    int = 80
    timeout: int = 30
    active:  bool
}
```

When a record value is constructed (assigned or returned), uninitialized fields assume their defaults, or zero if no default is given. Records are assigned by value: the entire contents are copied.

### Value and Reference Semantics

Assignment and function returns copy *by value* for `int`, `bool`, `fixed`, `char`, `string(n)`, enum, `record`, and fixed arrays (`T[n]`). Each copy is independent.

Assignment and function returns copy the *reference* (handle) for `text`, `list of T`, and `map of T`. All references to the same handle point to the same underlying data.

### Numeric Conversions

Clarus performs no implicit conversions between numeric types. Conversions must be explicit:

```rust
var i: int = 42
var f: fixed = fixed(i)      // int to fixed
var j: int = int(f)          // fixed to int (truncates toward zero)
var c: char = char(i)        // int to char (takes low byte, 0–255)
var k: int = int(c)          // char to int
```

Numeric truncation in `int(f)` is toward zero. `char(i)` is not a numeric truncation: it keeps only the low byte of `i` — `char(-1)` yields 255.

### Strings

Strings are length-prefixed Pascal strings, stored with a leading byte indicating length (0–255). The length prefix is transparent to user code.

**Indexing:** A string index yields a single `char`, 0-based as with arrays:

```rust
var s: string = "hello"
var ch: char = s[1]          // 'e' (index 1)
s[2] = 'x'                   // 'x' (in-place assignment)
var len: int = s.length      // 5
```

Out-of-range indexing raises a runtime error (see Chapter 12).

**Concatenation:** `string + char` appends the character to the string:

```rust
var s: string = "hi"
s = s + 'b'                  // "hib"
```

**Comparison:** Strings and characters compare byte-wise with `==`, `!=`, and other relational operators.

### Enums

Enum types are declared in record field declarations or at the type level. Each enum member is an identifier known only within that enum:

```rust
record Event {
    kind: (Click, Drag, Release)
}
```

Enum values are compared with `==` and `!=` only; `<`, `>`, and other comparisons are not defined. To convert an enum to an integer (for display or storage), use `int(e)`:

```rust
var e: (Click, Drag, Release) = Click
var n: int = int(e)          // 0, 1, or 2 (order of declaration)
```

### Lists

A `list of T` is a growable sequence. List operations are:

- `l.add(v)` — append value `v` of type `T`
- `l.remove(i)` — remove the element at index `i`
- `l[i]` — access element at index `i` (returns `T`)
- `l.count` — number of elements (returns `int`)
- `for x in l { … }` — iterate (see Chapter 5)

Out-of-range indexing raises a runtime error.

### Maps

A `map of T` is a hashtable with string keys (up to 255 bytes) and values of fixed-size type `T`. Map operations are:

- `m[k] = v` — set key `k` to value `v`
- `m[k]` — retrieve value for key `k` (returns `T`); runtime error if absent
- `m.has(k)` — test for key presence (returns `bool`)
- `m.remove(k)` — remove the entry for key `k`
- `m.count` — number of entries (returns `int`)
- `for k, v in m { … }` — iterate (see Chapter 5)

Keys are compared case-sensitively, byte-wise.

### Text

A `text` is an unbounded, resizable buffer of characters. Text operations are:

- Assignment: `t = "hello"`
- Concatenation: `t = t + "world"`
- `t.length` — length of the buffer (returns `int`)
- Comparison: `t == "hello"` (byte-wise)

### Window References

A window type (e.g., `Doc`) represents a reference to an open window instance. Window references are initially `nil` and are assigned only by the runtime or framework. Dereferencing a `nil` window reference raises a runtime error.

### Built-in Enum: `saveChoice`

The `saveChoice` enum is pre-defined and used in save dialogs. Its members are:

`saveChoice` is a built-in enum with members `Save`, `Discard`, and `Cancel`. It is not declared by user code; it is the return type of `askSaveChanges` (Chapter 12) and is used in comparisons: `if c == Cancel { cancel }`.

### Runtime Errors

The following operations may raise runtime errors (Chapter 12 specifies how errors are reported):

- Indexing a string, array, or list out of range
- Accessing a map with a key that does not exist
- Dereferencing a `nil` window reference

## Chapter 4: Expressions and Operators

### Operator Precedence

The following table is normative. Operators bind tighter the lower their level number; within a level, operators are left-associative.

| Level | Operators | Notes |
|---|---|---|
| 1 | `()` grouping, `f(args)` call, `a[i]` index, `a.b` field/property, `new T`, `open T` | postfix/primary |
| 2 | unary `-`, `not` | |
| 3 | `*` `/` `mod` | `/` on int truncates toward zero; `fixed` uses `FixMul`/`FixDiv` |
| 4 | `+` `-` | `+` also concatenates strings and text |
| 5 | `==` `!=` `<` `<=` `>` `>=` | strings compare byte-wise, case-sensitive |
| 6 | `and` | short-circuit |
| 7 | `or` | short-circuit |

### Primary Expressions

Level 1 covers grouping and the ways a value is produced or drilled into:

- `(expr)` — grouping, overrides precedence
- `f(args)` — function call
- `a[i]` — string, array, list, or map indexing
- `a.b` — field access on a record, or a property/method reference on a window, list, map, text, or connection
- `new T` — constructs a value of record type `T` with every field at its declared default (or zero), per Chapter 3's record-construction rules
- `open T` — opens a window of type `T` and yields its reference (statement form and full semantics in Chapter 8)

```rust
var p: Person = new Person       // name: "" (empty string), age: 0
var isAdult: bool = p.age >= 18 and p.name != ""
```

### Unary Operators

Unary `-` negates a numeric operand; `not` inverts a `bool`:

```rust
var p: Person = new Person
var isAdult: bool = p.age >= 18
var negAge: int = -p.age
var notAdult: bool = not isAdult
```

### Assignment Is a Statement

`=` is a statement (see Chapter 5), not an expression. It cannot appear inside a larger expression, and there is no `+=`, `-=`, or `++`/`--` in v1 — write the full expression out:

```rust
var count: int = 0
count = count + 1                // not count += 1
```

### No Bitwise Operators

Clarus v1 has no bitwise operators (`&`, `|`, `^`, `<<`, `>>`, `~`). Byte-level work on `char` values, where needed, goes through explicit arithmetic and the numeric conversions in Chapter 3.

### Mixed Numeric Arithmetic

`int` and `fixed` do not mix in arithmetic; combining them is a compile error. Convert one side explicitly:

```rust
var i: int = 3
var f: fixed = 1.5
// var bad: fixed = i + f        // compile error: mixed int/fixed arithmetic
var ok: fixed = fixed(i) + f     // 4.5
```

### String Concatenation and Truncation

`+` concatenates `string` and `text` values (and appends a single `char` to a `string`, per Chapter 3). A `string + string` result is a temporary of the combined length; when that temporary is stored into a fixed-capacity `string(n)` target, the length is checked at the point of assignment. If it doesn't fit, that is a runtime error, not silent truncation:

```rust
var greeting: string(3) = "ab"
// greeting = greeting + "cdef"  // runtime error: "abcdef" doesn't fit string(3)
```

## Chapter 5: Statements

A statement ends at the newline that terminates it (Chapter 2). Each form below is shown as a short, self-contained example built from types already introduced (`Person` from Chapter 1, `connection` and `saveChoice` from Chapter 3).

### Local Variable Declaration

`var name: Type` and `var name: Type = expr` may appear only at the top of a function or handler body, before any other statement:

```rust
func summarize(p: Person): string {
    var isAdult: bool = p.age >= 18
    var note: string
    return note
}
```

### Assignment

`lvalue = expr`. The left side must be an assignable location: a variable, a field, or an indexed element.

```rust
var count: int = 0
count = count + 1
```

### Call Statement

A function call, method-style call, or list/map operation may appear on its own as a statement; any return value is discarded.

```rust
// conn: connection declared elsewhere (Chapter 12)
var p: Person = new Person
var names: list of Person

conn.open("mac.example.com:70")
names.add(p)
```

### If / Else If / Else

The condition must be a `bool` expression; no parentheses are required around it.

```rust
var p: Person = new Person
var greeting: string

if p.age >= 18 {
    greeting = "Welcome"
} else if p.age >= 13 {
    greeting = "Hi there"
} else {
    greeting = "Hello, kid"
}
```

### While

```rust
var names: list of Person
var i: int = 0

while i < names.count {
    i = i + 1
}
```

### For

Three forms: iterate a `list of T`, iterate a `map of T` (key and value), or step an inclusive integer range.

```rust
var names: list of Person
var total: int = 0

for v in names {
    total = total + v.age
}
```

```rust
var scores: map of int
var total: int = 0
for name, score in scores {
    total = total + score
}
```

```rust
var sum: int = 0
for i in 0 to 9 {
    sum = sum + i          // i takes 0, 1, ..., 9 — the range is inclusive
}
```

### Return

`return` exits a procedure with no value; `return expr` exits a function with its result.

```rust
func isAdult(p: Person): bool {
    if p.age >= 18 { return true }
    return false
}
```

```rust
func maybeGreet(p: Person) {
    var greeting: string

    if p.name == "" { return }
    greeting = "Hello, " + p.name
}
```

### Open

`open WindowType` used as a statement opens a window and discards the reference. Used as an expression (`w = open WindowType`), it yields the new window's reference; full window semantics are Chapter 8.

```rust
// window Doc declared in Chapter 8's style
var d: Doc

open Doc                         // statement form: opens, reference discarded
d = open Doc                     // expression form: keeps the reference
```

### Close

`close windowRef` closes an open window instance.

```rust
// window Doc declared in Chapter 8's style
var d: Doc = open Doc
close d
```

### Edit

`edit FormWindow, record` opens a form window bound to a record value; full form semantics are Chapter 10.

```rust
// form window EditPerson declared in Chapter 10's style
var p: Person
edit EditPerson, p                  // lvalue: OK writes validated values back to it
edit EditPerson, new Person         // new record: exists only in the form's buffer
```

The second argument is the record to edit — either an lvalue or a fresh record. With an lvalue, pressing OK writes the validated values back to that location. With `new T`, the record is delivered to the form's `accepted` handler, where `rec.isNew` is true (Chapter 10).

### Quit

`quit` requests that the application quit. The runtime sends `closeRequest` to every open window first; any handler that runs `cancel` aborts the quit.

```rust
on App.startEmpty {
    quit                          // requests app quit
}
```

### Cancel

`cancel` is valid only inside a `closeRequest` handler. It aborts the pending close (or, during quit, aborts the whole quit):

```rust
// closeRequest fires on close-box click and at quit (Chapter 8)
on closeRequest {
    var c: saveChoice = askSaveChanges("Untitled")
    if c == Cancel { cancel }
}
```

### No Break or Continue

Clarus v1 has no `break` or `continue`. Restructure a loop that needs to exit early with a `while` loop and a `bool` flag, or extract the loop into a function and use `return`:

```rust
var names: list of Person
var i: int = 0
var found: bool = false

while i < names.count and not found {
    if names[i].name == "Ann" { found = true }
    i = i + 1
}
```

## Chapter 6: Functions

### Declaration

```rust
func name(p: Type, q: Type): ReturnType {
    // body
}
```

The return type is optional; a function with no return type is a procedure and uses bare `return` (or falls off the end of its body) to finish.

```rust
func add(a: int, b: int): int {
    return a + b
}

func logGreeting(p: Person) {
    // procedure: no return type, nothing returned
}
```

### Parameter Passing

Scalars, records, and strings pass **by value**; `text`, `list`, `map`, and window refs pass **by reference** (they are references). A parameter documented as filled by the callee (e.g. `file.readText(path, t)`) mutates the passed `text`/`list`/`map` in place. User-declared functions cannot fill fixed-size out-parameters — return values instead. Built-in runtime routines are not bound by this rule: dialogs such as `askOpen(p)` and `askSave(path, suggested)` fill the string you pass, using a runtime calling convention not available to user code (Chapter 12).

### Recursion

Recursion is allowed:

```rust
func factorial(n: int): int {
    if n <= 1 { return 1 }
    return n * factorial(n - 1)
}
```

### Restrictions

There is no overloading, no default parameter values, and no varargs — every function has exactly one signature and every call site passes exactly its declared parameters.

### Scope

Functions may be declared at top level only. Window-scoped helper functions are a possible future `extend` addition, not part of v1.

## Chapter 7: Application Lifecycle

### Application Entry Points

A Clarus program responds to application-level events through top-level event handlers. These are the sole entry points to user code (aside from window, menu, and timer handlers, documented in later chapters).

### Event Inventory

| Event | Signature | When |
|---|---|---|
| `App.launch` | `on App.launch { }` | Always first, once, before any window exists. App-wide setup. |
| `App.openDocument` | `on App.openDocument(path: string) { }` | Once per document the Finder launched the app with, or dropped on it while running. |
| `App.startEmpty` | `on App.startEmpty { }` | After `launch`, only when the app was started with **no** documents. |

### Nothing Opens Implicitly

A Clarus program does not automatically open any window. A program launched with no documents that provides no `App.startEmpty` handler shows only the menu bar. The programmer must explicitly open windows by calling `open WindowType` (Chapter 4) in an event handler.

### Launch Order

The runtime fires application events in the following sequence:

```
App.launch
  ├─ App.openDocument (× N documents)
  └─ App.startEmpty (only if no documents)
```

This is the sole entry point to user code. All other execution flows from window, menu, and timer handlers.

### Quit Semantics

The `quit` statement (Chapter 5) requests that the application exit. The runtime does not exit immediately; instead, it sends a `closeRequest` event to every open window, starting with the front-most window and proceeding toward the back. If any window's `closeRequest` handler runs `cancel` (Chapter 5), the entire quit is aborted and the app remains open. If all windows close without cancellation, the app exits.

### Mac Launch Events

These events correspond to the classic Macintosh OAPP and ODOC Apple events sent by the Finder; design rationale appears in the language design spec.

### Timers

A top-level `every` block runs repeatedly at fixed intervals:

```rust
every 60 {
    // runs 60 times per second
}
```

The number is a tick count; each tick is 1/60 second. The block runs on the main event loop and is never entered reentrantly. If a block's execution duration approaches or exceeds the tick interval, the next iteration is skipped rather than queued, preserving responsiveness.
