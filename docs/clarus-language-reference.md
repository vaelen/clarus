# The Clarus Language Reference

Version: v1 draft. 

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
- `enum` declarations
- `const` declarations
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

**Comments:** Comments begin with `//` and extend to the end of the line. There are no block comments.

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
var func record enum const window menu extend on every
if else while for in to return
and or not true false nil
open close edit new quit cancel
switch case break continue
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

This list is representative, not exhaustive: later chapters introduce further contextual words in property and value positions (`right`, `next`, `bottom`, `vertical`, `both`, `buffered`, `appletalk`, and others). Outside their positions, all contextual keywords are ordinary identifiers.

### Literals

| Kind | Forms | Notes |
|---|---|---|
| Integer | `42`, `-7`, `0x1F` | 32-bit signed; hex with `0x` |
| Fixed | `1.5`, `0.25` | 16.16 fixed-point (no float type) |
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
| enum | 2 bytes | inline | named type declared with `enum Name { … }` (see Enums below) |
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

Resource variables (`connection`, `listener`, `serviceBrowser`) are fixed-size 4-byte references, like window references: assignable, storable in records and arrays (`connection[8]` is 8 references, 32 bytes), and `nil` until bound.

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

Strings are length-prefixed "Pascal" strings, stored with a leading byte indicating length (0–255). The length prefix is transparent to user code. Strings are defined with a maximum capacity which defaults to 255 if not provided.

**Indexing:** A string index yields a single `char`, 0-based as with arrays:

```rust
var s: string = "hello"      // same as string(255)
var ch: char = s[1]          // 'e' (index 1)
var len: int = s.length      // 5
s[2] = 'x'                   // 'x' (in-place assignment)
```

Out-of-range indexing raises a runtime error (see Chapter 12).

**Concatenation:** `string + char` appends the character to the string:

```rust
var s: string = "hi"
s = s + 'b'                  // "hib"
```

**Comparison:** Strings and characters compare byte-wise with `==`, `!=`, and other relational operators.

**Slicing:** `s[start, len]` yields a new `string` holding `len` characters beginning at index `start` (the Pascal `Copy` parameter order). Bounds are strict: `start < 0`, `len < 0`, `start + len > s.length`, or `len > 255` raises a runtime error (`slice out of range`). A slice is an expression, never an assignment target:

```rust
var s: string = "hello world"
var w: string = s[6, 5]          // "world"
```

**Searching:** `s.indexOf(needle)` returns the index of the first occurrence of `needle` (a `string` or a `char`), or `-1` if absent. Byte-wise, case-sensitive:

```rust
var s: string = "hello"
var i: int = s.indexOf('l')      // 2
var j: int = s.indexOf("lo")     // 3
var k: int = s.indexOf("xyz")    // -1
```

**Byte copies:** For assembling and parsing binary data (network protocols, file headers), a `string` doubles as a counted byte buffer, and two built-in methods copy between strings and `char` arrays. Both know the compile-time capacity of every operand and clamp every copy to it — a buffer overrun is impossible by construction. A clamped (truncated) copy sets `lastError` (Chapter 12) and execution continues:

- `s.fromBytes(buf, count)` — copy the first `count` bytes of `char` array `buf` into `s`, setting `s`'s length; copies min(`count`, `buf`'s capacity, `s`'s capacity).
- `s.toBytes(buf)` — copy `s`'s bytes into `char` array `buf`; returns (`int`) the number copied: min(`s.length`, `buf`'s capacity).

```rust
var packet: char[16]
var s: string(16)
var n: int

s.fromBytes(packet, 8)           // first 8 bytes of packet into s; s.length = 8
n = s.toBytes(packet)            // s's bytes back into packet; n = 8
```

These are built-ins with the runtime calling convention of Chapter 6 — the arrays' capacities travel with the call, which is what makes the clamping intrinsic. `text` supports the same two methods (see Text below).

### Enums

An `enum` declaration creates a named type with a fixed set of members:

```rust
enum EventKind { Click, Drag, Release }

var e: EventKind = Click

record Event {
    kind: EventKind
}
```

Members are identifiers, separated by commas or newlines. Because the enum is a named type, any number of variables, fields, and parameters can share it. A member name is resolved against the enum type expected where it appears, so members of different enums may share names.

**Labels.** Each member may carry a display label, used wherever the runtime shows the value to the user — popup items in bound forms and enum table columns (Chapter 10). A member without a label displays its own name:

```rust
enum Protocol {
    Gopher "Gopher"
    HTTP   "Web (HTTP)"
    Telnet "Telnet"
}
```

Labels are compiled into a string-list (STR#) resource, one per enum. They cost nothing in the value itself, and they can be edited — localized — with ResEdit without recompiling the program.

**Values.** A member may declare its own value with an integer literal placed before its label. Members without one number from 0, or continue from the previous member's value + 1. Values must be unique within the enum (a duplicate is a compile error) and fit in 16 bits (0–65535). Explicit values let an enum line up with a wire format or a Toolbox constant instead of forcing translation code:

```rust
enum Foo {
    Bar  "Bar"                 // value 0x00
    Moof 0x10 "Dogcow"         // value 0x10
    Next "The next thing"      // value 0x11
}
```

**Representation.** An enum value is a 16-bit word holding the member's value (its default or declared number). Two bytes rather than one keeps record fields aligned for the 68000, which cannot read a word from an odd address. A record field of enum type with no explicit default starts at the first declared member.

**Operations.** Enum values compare with `==` and `!=` only; ordering comparisons are not defined. `int(e)` yields the member's value; `EventKind(i)` converts an integer back to the member with that value, raising a runtime error if no member matches — the checked path for values read from files or the network:

```rust
var e: EventKind = Drag
var n: int = int(e)               // 1
var back: EventKind = EventKind(n)
```

### Lists

A `list of T` is a growable sequence. List operations are:

- `l.add(v)` — append value `v` of type `T`
- `l.push(v)` — synonym for `add`
- `l.pop()` — remove and return the last element (returns `T`)
- `l.shift()` — remove and return the first element (returns `T`)
- `l.unshift(v)` — insert value `v` at the front
- `l.first()` / `l.last()` — return the first / last element without removing it (returns `T`)
- `l.remove(i)` — remove the element at index `i`
- `l[i]` — access element at index `i` (returns `T`)
- `l.count` — number of elements (returns `int`)
- `for x in l { … }` — iterate (see Chapter 5)

Out-of-range indexing raises a runtime error, and so do `pop`, `shift`, `first`, and `last` on an empty list.

### Maps

A `map of T` is a hashtable with string keys (up to 255 bytes) and values of fixed-size type `T`. Map operations are:

- `m[k] = v` — set key `k` to value `v`
- `m[k]` — retrieve value for key `k` (returns `T`); runtime error if absent
- `m.get(k, dv)` — retrieve the value for key `k`, or the default value `dv` (of type `T`) if the key is absent; never errors
- `m.has(k)` — test for key presence (returns `bool`)
- `m.remove(k)` — remove the entry for key `k`; silently succeeds if absent
- `m.count` — number of entries (returns `int`)
- `for k, v in m { … }` — iterate (see Chapter 5)

Keys are compared case-sensitively, byte-wise. Iteration order is insertion order; removing a key preserves the order of the remaining entries.

### Text

A `text` is an unbounded, resizable buffer of characters. Text operations are:

- Assignment: `t = "hello"`
- Concatenation: `t = t + "world"`
- `t.append(x)` — append `x` (a `string`, `char`, or `text`) in place. Unlike `t = t + x`, which rebuilds the buffer, `append` grows it amortized — the right tool for building large output in a loop.
- `t[i]` — the character at index `i` (returns `char`), 0-based; `t[i] = c` assigns in place
- `t[start, len]` — slice, yielding a `string`; same strict-bounds rules as string slicing (above)
- `t.indexOf(needle)` — first index of a `string` or `char`, or `-1` (as for strings)
- `t.length` — length of the buffer (returns `int`)
- Comparison: `t == "hello"` (byte-wise)
- `t.fromBytes(buf, count)` / `t.toBytes(buf)` — byte copies to and from a `char` array, with the same clamping rules as their `string` counterparts (above). A `text` has no fixed capacity, so `fromBytes` resizes the text and never truncates; `toBytes` still clamps to the array's capacity and sets `lastError` if bytes were dropped.

Out-of-range indexing raises a runtime error. Indexing and byte copies make `text` usable directly for binary protocol work — data arriving in `on conn.received(data: text)` (Chapter 12) can be scanned byte by byte without an intermediate copy.

### Window References

A window type (e.g., `Doc`) represents a reference to an open window instance. Window references are initially `nil`; assigned from `open` expressions or from other references. Dereferencing a `nil` window reference raises a runtime error.

### Built-in Enum: `saveChoice`

`saveChoice` is a built-in enum, as if declared `enum saveChoice { Save, Discard "Don't Save", Cancel }`. It is not declared by user code; it is the return type of `askSaveChanges` (Chapter 12) and is used in comparisons: `if c == Cancel { cancel }`.

### Constants

A `const` declaration names an immutable typed value at the top level:

```rust
const maxTokens: int = 4096
const versionTag: string = "clarusc 0.1"
const startState: EventKind = Click
```

The initializer must be a literal, an enum member, or a previously declared constant — no expressions. Assigning to a constant is a compile error. Constants follow declare-before-use like every other declaration, and they are valid as `switch` case labels (Chapter 5).

### Runtime Errors

The following operations may raise runtime errors (Chapter 12 specifies how errors are reported):

- Indexing a string, text, array, or list out of range
- Slicing a string or text out of range, or with a length over 255
- `pop`, `shift`, `first`, or `last` on an empty list
- Accessing a map with the `[]` form using a key that does not exist (`get` never errors)
- A checked enum conversion (`EnumType(i)`) with a value that matches no member
- Dereferencing a `nil` window reference

## Chapter 4: Expressions and Operators

### Operator Precedence

The following table is normative. Operators bind tighter the lower their level number; within a level, operators are left-associative. Comparison operators do not chain: `a < b < c` is a compile error.

| Level | Operators | Notes |
|---|---|---|
| 1 | `()` grouping, `f(args)` call, `a[i]` index, `a.b` field/property, `new T`, `open T` | postfix/primary |
| 2 | unary `-`, `not`, `~` | `~` is bitwise NOT (int only) |
| 3 | `*` `/` `mod` `<<` `>>` `&` | `/` on int truncates toward zero; `fixed` uses `FixMul`/`FixDiv`; shifts and `&` are int only |
| 4 | `+` `-` `\|` `^` | `+` also concatenates strings and text; `\|` `^` are int only |
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

`=` is a statement (see Chapter 5), not an expression. It cannot appear inside a larger expression, and there is no `+=`, `-=`, or `++`/`--` :

```rust
var count: int = 0
count = count + 1                // not count += 1
```

### Bitwise Operators

Bitwise operators work on `int` operands only (`char` values convert through `int(c)`, Chapter 3): `~` NOT, `&` AND, `|` OR, `^` XOR, `<<` shift left, `>>` shift right. `>>` is an arithmetic shift: it propagates the sign bit, matching `int`'s signedness. Shift counts must be 0–31; a count outside that range raises a runtime error.

Precedence deliberately avoids C's pitfall: `&` binds at the multiplicative level and `|`/`^` at the additive level (the table above), so a masking test parses the way it reads:

```rust
var flags: int = 0x0C
var masked: bool = flags & 0x08 != 0    // parses as (flags & 0x08) != 0
var packed: int = 3 << 8 | 42           // parses as (3 << 8) | 42
```

### Mixed Numeric Arithmetic

`int` and `fixed` do not mix in arithmetic; combining them is a compile error. Convert one side explicitly:

```rust
var i: int = 3
var f: fixed = 1.5
// var bad: fixed = i + f        // compile error: mixed int/fixed arithmetic
var ok: fixed = fixed(i) + f     // 4.5
```

### String Concatenation and Truncation

`+` concatenates `string` and `text` values (and appends a single `char` to a `string`, per Chapter 3). A `string + string` result is a temporary of the combined length; when that temporary is stored into a fixed-capacity `string(n)` target, the store is clamped to the target's capacity. The copy never writes past the end — a buffer overrun is impossible by construction. If clamping dropped any bytes, the store sets `lastError` (Chapter 12) and execution continues:

```rust
var greeting: string(3) = "ab"
greeting = greeting + "cdef"     // stores "abc", sets lastError; no runtime error
```

The same rule governs every store into a `string(n)` — direct assignment as well as concatenation results. A program that cares checks `lastError` after the store; a program that doesn't gets a safely truncated value. A `string + string` result exceeding 255 bytes is itself clamped, at the `string(255)` temporary the concatenation builds before that final store, and sets `lastError` the same way.

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

If the range's start exceeds its end (`for i in 0 to n - 1` with `n` = 0), the body runs zero times.

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

`quit` requests that the application quit. The runtime sends `closeRequest` to every open window first; any handler that runs `cancel` aborts the quit. An optional `int` expression supplies the process exit code where the platform has one (command-line hosts); on the Macintosh the code is accepted and ignored. Bare `quit` exits 0.

```rust
on App.startEmpty {
    quit                          // requests app quit (exit code 0)
}
```

```rust
on App.launch {
    if App.args.count == 0 {
        log("usage: clarusc file.cla...")
        quit 2
    }
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

### Break and Continue

`break` exits the innermost enclosing loop immediately; `continue` skips to the next iteration (in a `for` over a range, list, or map, it advances to the next element; in a `while`, it re-tests the condition). Both are unlabeled — they act only on the innermost loop — and both are valid only inside a loop body:

```rust
var names: list of Person
var i: int = 0

while i < names.count {
    if names[i].name == "Ann" { break }
    i = i + 1
}
// i is the index of "Ann", or names.count if absent
```

### Switch

`switch` compares one value against constant case labels, running the first case that matches. There is **no fallthrough** — exactly one case (or `else`) runs. Case labels are literals, enum members, or declared constants (Chapter 3), comma-separated to match any of several values; the operand may be an `int`, `char`, enum, or `string`:

```rust
switch tok {
case KwIf {
    parseIf()
}
case KwWhile, KwFor {
    parseLoop()
}
else {
    syntaxError()
}
}
```

`else` is optional; with no match and no `else`, the statement does nothing. `break` is not used with `switch` (it has no fallthrough to break out of); a `break` inside a case body belongs to the enclosing loop, if any.

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

Functions may be declared at top level only. 

## Chapter 7: Application Lifecycle

### Application Entry Points

A Clarus program responds to application-level events through top-level event handlers. These are the sole entry points to user code (aside from the other handlers documented in Chapters 8–12).

### Event Inventory

| Event | Signature | When |
|---|---|---|
| `App.launch` | `on App.launch { }` | Always first, once, before any window exists. App-wide setup. |
| `App.openDocument` | `on App.openDocument(path: string) { }` | Once per document the Finder launched the app with, or dropped on it while running. |
| `App.startEmpty` | `on App.startEmpty { }` | After `launch`, only when the app was started with **no** documents. |

### Nothing Opens Implicitly

A Clarus program does not automatically open any window. A program launched with no documents that provides no `App.startEmpty` handler shows only the menu bar. The programmer must explicitly open windows by calling `open WindowType` (Chapter 5) in an event handler.

### Launch Order

The runtime fires application events in the following sequence:

```
App.launch
  ├─ App.openDocument (× N documents)
  └─ App.startEmpty (only if no documents)
```

### Quit Semantics

The `quit` statement (Chapter 5) requests that the application exit. The runtime does not exit immediately; instead, it sends a `closeRequest` event to every open window, starting with the front-most window and proceeding toward the back. If any window's `closeRequest` handler runs `cancel` (Chapter 5), the entire quit is aborted and the app remains open. If all windows close without cancellation, the app exits.

### Mac Launch Events

These events correspond to the classic Macintosh OAPP and ODOC Apple events sent by the Finder; design rationale appears in the language design spec.

### Command-Line Arguments

`App.args` is a read-only `list of string` holding the program's command-line arguments (not including the program name), populated before `App.launch` fires. On a command-line host this is the argument vector; on the Macintosh it is always empty — documents opened from the Finder arrive through `App.openDocument`, never as arguments:

```rust
on App.launch {
    for a in App.args {
        compile(a)
    }
}
```

### Timers

A top-level `every` block runs repeatedly at fixed intervals:

```rust
every 60 ticks {
    // runs once per second
}
```

The number is a tick count; each tick is 1/60 second. The block runs on the main event loop and is never re-entered while a previous run is still executing.

## Chapter 8: Windows and Widgets

### Window Declaration

A `window` block is a declaration, not code: it compiles to a real resource (WIND, plus CNTL/DITL for its widgets), the way a `record` compiles to a layout. The following properties may appear at the top of a window's body:

| Property | Form | Meaning |
|---|---|---|
| `title` | `title: "Untitled"` | initial title; assignable at runtime (`w.title = ...`) |
| `size` | `size: 400, 300` | content size in pixels |
| `resizable` | `resizable` or `resizable: min(300, 200)` | grow box + optional minimum |
| `form for T` | `form for Bookmark` | marks a form window (Chapter 10) |

One additional window declaration — the document file-type declaration for Finder integration — is described in Chapter 12; its syntax is settled alongside the toolchain.

```rust
window Doc {
    title: "Untitled"
    size: 400, 300
    resizable: min(300, 200)
}
```

### Window Body

Besides the properties above, a window body may contain widget declarations, `var` declarations (per-instance state), and `form for` (Chapter 10):

```rust
window Doc {
    title: "Untitled"
    size: 400, 300
    resizable: min(300, 200)

    textview Body { fill: both; scrollbar: vertical }

    var path: string(255)          // per-instance state
    var dirty: bool = false
}
```

### Window Instances

`window Doc` is an instantiable template: each `open Doc` (Chapter 5) creates a distinct instance, with its own widgets and its own copy of the `var`s declared in the block.

- `open Doc` used as a statement creates and opens an instance, discarding the reference; used as an expression (`d = open Doc`) it creates, opens, and returns the reference.
- `var d: Doc` declares a nil window reference. Dereferencing a nil reference is a runtime error (Chapter 3).
- `Doc.front` is the frontmost open instance of type `Doc`, or `nil` if none is open.
- Inside a `Doc` handler, the keyword `window` names the firing instance — the one whose event is being handled — so it can be passed to functions that take a `Doc`.
- Per-instance state (the `var`s declared in the window body) lives in a handle hung off the instance's `WindowRecord`; it is allocated when the instance opens and freed when it closes.
- Bare names inside `extend Doc` resolve first against the firing instance's properties, fields, and widgets, then against globals — this is why two different window types may each declare an `Add` button without conflict.
- `close ref` closes an open instance, but only after its `closeRequest` handler runs. Inside a `closeRequest` handler, `cancel` aborts the pending close (or, during `quit`, aborts the whole quit) — see Chapter 5.

### Window Events

| Event | Signature | When |
|---|---|---|
| `opened` | `on opened { }` | The instance has just been created and its window opened. |
| `closeRequest` | `on closeRequest { }` | The close box was clicked, or the app is quitting; `cancel` aborts the close. |
| `closed` | `on closed { }` | The window has finished closing; its per-instance state is about to be freed. |
| `resized` | `on resized { }` | The user resized the window (resizable windows only). |
| `key` | `on key(k: char) { }` | A key was typed while the window is frontmost and no widget consumed it. |

A window's own events are handled with the bare event name inside its `extend` block, e.g. `extend Doc { on closeRequest { ... } }`; widget events use `on Widget.event { }` in the same block (Chapter 9 covers nesting menu handlers there too).

### Widgets

Widget declarations appear inside a `window` body. Each widget has declaration-time properties (set in the `window` block), runtime properties (readable and assignable as `Widget.property` from handlers), and events (handled as `on Widget.event { }` in the window's `extend` block). 

| Widget | Properties | Runtime properties | Events |
|---|---|---|---|
| `button` | `caption`, `at`, `width`, `default`, `cancel` | `caption`, `enabled` | `click` |
| `field` | `label`, `at`, `width`, `binds` | `text`, `enabled` | `change`, `enter` |
| `textview` | `at`, `fill`, `scrollbar` (`vertical`\|`both`) | `text` | `change` |
| `check` | `caption`, `at`, `binds` | `checked` | `change` |
| `popup` | `label`, `at`, `binds` | `selected` (int index) | `change` |
| `table` | `rows`, `column ...` (Chapter 10), `at`, `fill` | `selected` (int, −1 none) | `select(i: int)`, `doubleClick(i: int)` |
| `canvas` | `at`, `fill`, `buffered` | `width`, `height` | `click(x: int, y: int)`, `drag(x: int, y: int)` |
| `label` | `text`, `at` | `text` | — |

`binds` connects a `field`, `check`, or `popup` to a record field inside a form window (Chapter 10); `default` and `cancel` on a `button` wire the Return and Escape keys respectively. A `field`'s `text` runtime property is a `string`; a `textview`'s is a `text`.

```rust
window Doc {
    title: "Untitled"
    size: 300, 120

    field Name { label: "Name:"; at: 10, 10; width: 200 }
    button Go  { at: 10, 40; caption: "Go"; default }
}

extend Doc {
    on Go.click {
        Name.text = "clicked"
    }
}
```

### Layout

`at: x, y` positions a widget's top-left corner; `at: right, y` and `at: next, bottom` position it relative to the previous widget's right or bottom edge. `width: fill` and `fill: both` stretch a widget to fill remaining width, or both dimensions, of the window. Resize re-layout is automatic: the runtime keeps edge-relative widgets pinned to the edges they were declared relative to; no resize handler is needed for ordinary layouts.

## Chapter 9: Menus

### Menu Declaration

```rust
menu File {
    item New  "New"   key "N"
    separator
    item Quit "Quit"  key "Q"
}
```

A `menu` block declares a menu — like `window`, it is a declaration compiled to a real resource (MENU), not code. `item Ident "Caption"` declares one item, named `Ident` for handlers and captioned `"Caption"` on screen; `key "K"` is the optional ⌘-equivalent. `separator` inserts a dividing line between items.

### Standard Edit

```rust
menu Edit { standard edit }
```

`standard edit` supplies the Mac-standard Edit menu items (Undo/Cut/Copy/Paste) with clipboard behavior already wired to `field` and `textview` widgets — required for a native feel (and for desk accessories) but otherwise pure boilerplate. The behavior comes from the `edit` keyword, not from the menu's own name — a menu declared under a different name could still use `standard edit`.

### Item Events

Each `item` fires `select` when chosen, handled in an `extend` block naming the menu:

```rust
extend File {
    on Quit.select { quit }
}
```

### Window-Scoped Commands

A menu's `extend` block may be nested inside a window's `extend` block, scoping those commands to windows of that type:

```rust
extend Doc {
    extend File {
        on Save.select { save(window) }
    }
}
```

The nesting means "these commands apply when a Doc is frontmost." The runtime automatically enables such menu items only while a window of that type is frontmost, and dims them otherwise — menu enabling requires no user code — and a handler nested this way can never fire without a valid `window`. Scopes compose lexically: the inner `extend` resolves menu items, the outer resolves widgets and fields.

### Runtime Menu-Item Property

`enabled` is a runtime property on a menu item, addressed as `MenuName.ItemName.enabled`, for app-level items that need manual control rather than the automatic window-scoped dimming above:

```rust
File.Save.enabled = false
```

### The Apple Menu

The Apple menu and its About item are provided by the runtime automatically; no declaration is needed. In the current version, the About item shows the application's name only — a richer About dialog will come later on.

## Chapter 10: Forms and Tables

### Form Windows

A window with `form for T` (Chapter 8) is a *form window*: its widgets bind to the fields of a value of type `T` rather than being addressed piecemeal by handler code. A `field`, `check`, or `popup` inside such a window declares `binds: name`, where `name` is resolved against `T`'s fields — inside a form window's widget declarations, the record's fields are the innermost scope, so a bare name is written, never a dotted path.

```rust
window EditForm {
    form for Bookmark

    field Name     { binds: name;     label: "Name:" }
    check Fav      { binds: favorite; caption: "Favorite" }
    popup Proto    { binds: protocol; label: "Protocol:" }

    button OK      { default }
    button Cancel  { cancel }
}
```

### Type-Driven Widget Behavior

A bound widget's behavior comes from the type of the field it binds to, with nothing specified twice:

| Field type | Bound widget | Behavior |
|---|---|---|
| `string(n)` | `field` | typing is limited to n characters |
| `int` | `field` | typing is restricted to numeric input; a non-numeric value fails OK validation |
| `fixed` | `field` | numeric input, including a decimal point |
| `bool` | `check` | checkbox; `checked` mirrors the field |
| enum | `popup` | popup items are the enum's member labels (member name when unlabeled — Chapter 3), in declaration order |

### The Edit Statement

`edit FormWindow, target` (Chapter 5) opens a form window bound to a value of its `form for T` type:

1. `target`'s contents are copied into a working buffer, and the form's widgets are filled from that buffer.
2. The form window is shown, movable modal by default.
3. **Cancel** discards the buffer immediately — the original record, if any, is left untouched — and fires `cancelled`.
4. **OK** validates every bound widget against its field's type. The first invalid widget in declaration order beeps, selects itself, and the form stays open for correction. Once every widget validates, the buffer is written back to `target` (when `target` is an lvalue), and `accepted(rec: T)` fires with the clean, validated record — handlers only ever see data that has already passed validation.

`target` is either an lvalue or `new T` (Chapter 5):

```rust
edit EditForm, bookmarks[i]     // lvalue: OK writes validated values back to it
edit EditForm, new Bookmark     // new record: exists only in the form's buffer
```

With `new T` there is no lvalue to write back to, so `accepted`'s `rec.isNew` is `true` for that call — the handler's cue to `add` the record rather than treat it as an update to something already stored.

A form window must be declared explicitly, as above. Generating one automatically from `edit someRecord` alone is not yet supported.

### Form Events

| Event | Signature | When |
|---|---|---|
| `accepted` | `on accepted(rec: T) { }` | OK was pressed and every bound widget validated; `rec` holds the clean, written-back data. |
| `cancelled` | `on cancelled { }` | Cancel was pressed (or Escape, via a button's `cancel` property). Discarding the buffer is automatic; handling this event is optional. |

```rust
extend EditForm {
    on accepted(b: Bookmark) {
        if b.isNew { bookmarks.add(b) }
    }
}
```

`button OK { default }` and `button Cancel { cancel }` (Chapter 8) wire Return to OK and Escape to Cancel, so a form needs no other code to support keyboard confirm/dismiss.

### Table Binding

A `table` widget (Chapter 8) binds to a `list of T` with `rows: listExpr`:

```rust
table Marks {
    rows: bookmarks
    column "Name" shows name     width 140
    column "URL"  shows url      width fill
    column "Fav"  shows favorite width 30
}
```

The table stays live: `add`, `remove`, and writeback to an element of the bound list (for instance, from an `edit` on that element) invalidate and redraw only the affected rows, with no handler code required.

### Table Columns

`column "Header" shows fieldName width N` declares one column. `fieldName` is resolved against the row type `T` the same way `binds:` is resolved in a form — bare, never dotted. `width N` gives a fixed pixel width; `width fill` gives the column the window's remaining width. A column's rendering also follows its field's type: a `bool` field renders as a checkmark, and an enum field renders its member label (member name when unlabeled — Chapter 3).

### Table Selection

Tables are single-select. `selected` (Chapter 8) is a runtime `int` property: the index of the selected row, or `-1` if none is selected. `select(i: int)` fires when a row is clicked; `doubleClick(i: int)` fires on a double-click:

```rust
extend Main {
    on Marks.doubleClick(i: int) {
        edit EditForm, bookmarks[i]
    }
}
```

## Chapter 11: Drawing and Timers

### Canvas Drawing Methods

A `canvas` widget (Chapter 8) is drawn on from its own events and from `every` blocks — nowhere else, since no code runs outside a handler or timer (Chapter 7). 

```
c.clear()
c.line(x1, y1, x2, y2: int)
c.rect(x, y, w, h: int)        c.fillRect(x, y, w, h: int)
c.circle(x, y, r: int)         c.fillCircle(x, y, r: int)
c.drawText(x, y: int, s: string)
c.width  c.height              // runtime properties, int
```

`clear` erases the canvas to white. `line` draws a line from `(x1, y1)` to `(x2, y2)`. `rect`/`fillRect` draw a rectangle outline or a filled rectangle at `(x, y)` with width `w` and height `h`. `circle`/`fillCircle` draw a circle outline or a filled circle centered at `(x, y)` with radius `r`. `drawText` draws `s` with its baseline at `(x, y)`. `width` and `height` are read-only runtime properties giving the canvas's current size in pixels.

All coordinates are `int` pixels. The origin `(0, 0)` is the canvas's top-left corner; `x` increases rightward, `y` increases downward.

### Buffered vs. Unbuffered

A `canvas` declared with `buffered` (Chapter 8) draws to an offscreen bitmap; the accumulated drawing is blitted to the screen in a single copy when the current handler or timer returns control to the event loop, so a sequence of drawing calls never flickers. An unbuffered canvas draws directly to the screen as each method is called, visible immediately.

### Drawing Only Happens in a Handler or Timer

Clarus has no code that runs outside an event handler or an `every` block (Chapter 7) — there is no idle loop and no background thread. Drawing on a canvas is therefore always a response to some event: a click, a timer tick, or another widget's change. There is no way to draw from anywhere else.

### Timers and Smooth Motion

`every N ticks { }` (Chapter 7) is the mechanism for animation: it runs on the main event loop once every `N` ticks (each tick is 1/60 second) and is never re-entered while a previous run is still executing. Paired with `fixed` (Chapter 3) for sub-pixel position and velocity, it drives smooth motion, converting to `int` only at the point of drawing:

```rust
window Game {
    title: "Bounce"
    size: 200, 200
    canvas Board { at: 0, 0; fill: both; buffered }

    var x: fixed = 10.0
    var dx: fixed = 2.0
}

every 1 ticks {
    var g: Game = Game.front
    if g != nil {
        g.x = g.x + g.dx
        if g.x > 190.0 or g.x < 0.0 { g.dx = -g.dx }
        g.Board.clear()
        g.Board.fillCircle(int(g.x), 100, 8)
    }
}
```

## Chapter 12: Networking, Files, and Errors

### Connections

A `connection` (Chapter 3) is a single reliable byte-stream abstraction over both AppleTalk (ADSP) and TCP (MacTCP); the transport is chosen at `open` and invisible afterward. 

| Member | Form |
|---|---|
| `open` | `c.open("host:port")` — MacTCP, DNS inside; `c.open(appletalk "Name:Type")` — ADSP, NBP inside; `c.open(addr)` — from a browser `address` |
| `send` | `c.send(t: text)` (also accepts string) |
| `close` | `c.close()` |
| events | `opened`, `received(data: text)`, `closed`, `failed(err: error)` |

Like other resources, a `connection`'s events are caught by top-level handlers, not callbacks:

```rust
var conn: connection

on App.launch {
    conn.open("mac.example.com:70")
}

on conn.opened {
    conn.send("HELLO\n")
}

on conn.received(data: text) {
    // process data
}

on conn.closed { }

on conn.failed(err: error) {
    alert(err.message)
}
```

### Listeners

A `listener` accepts incoming connections from clients. `l.listen(port: int)` opens a TCP listening socket; `l.register(name: string, type: string)` registers an ADSP server under an NBP name for clients to find. Its events are `accepted(c: connection)` and `failed(err: error)`.

The `connection` delivered by `accepted` is bound to the parameter named in the handler — `c` below — a fresh reference the program must store somewhere to keep talking to that client. The usual pattern for a multi-client server is a fixed array of connections with a parallel `bool` array tracking which slots are in use:

```rust
var server: listener
var clients: connection[8]
var busy: bool[8]

on App.launch {
    server.listen(6502)
}

on server.accepted(c: connection) {
    var i: int = 0
    while i < 8 and busy[i] { i = i + 1 }
    if i < 8 {
        clients[i] = c
        busy[i] = true
    }
}
```

`l.register(name, type)` is used the same way, in place of `l.listen(port)`, to run an ADSP server that's discoverable by name instead of a fixed TCP port.

### Service Discovery

A `serviceBrowser` finds other instances of a named service in the current AppleTalk zone. `b.find(type: string)` starts the search; its events are `found(name: string, addr: address)` and `failed(err: error)`. The `address` delivered by `found` can be passed straight to `connection.open`:

```rust
var browser: serviceBrowser
var conn: connection

on App.launch {
    browser.find("ChatServer")
}

on browser.found(name: string, addr: address) {
    conn.open(addr)
}

on browser.failed(err: error) { }
```

### Files

The `file` namespace covers documents and preferences. Every function but `file.name` returns `bool`; `false` means inspect the global `lastError` (below) for what went wrong. 

| Function | Signature | Notes |
|---|---|---|
| `readText` | `file.readText(path: string, t: text): bool` | fills `t` in place |
| `writeText` | `file.writeText(path: string, t: text): bool` | writes `t`'s contents to `path` |
| `save` | `file.save(path: string, data): bool` | `data`: any `record`, `list of` record, or `map of` record |
| `load` | `file.load(path: string, data): bool` | fills `data` in place |
| `name` | `file.name(path: string): string` | the file's display name; always succeeds |

`save` and `load` serialize using the field layout already known from the record's declaration (Chapter 3) — no separate schema is written or read.

**Binary faithfulness:** `readText` and `writeText` transfer content verbatim, byte for byte — no newline translation, and every byte value 0–255 (including 0) round-trips unchanged. Since a `text` is a byte buffer (Chapter 3), these two functions are also the way to read and write binary data.

A document window may declare its document file type for Finder integration (Mac type and creator codes). Double-clicking such a document in the Finder launches the application and fires `App.openDocument` with the document's path (Chapter 7). The declaration syntax is part of the window declaration and is settled alongside the toolchain; the behavior is as described here.

### Dialogs

Four built-in dialogs cover file selection and quit confirmation. As Chapter 6 notes, these fill the string arguments passed to them using a runtime calling convention available only to built-ins, not to user-declared functions:

- `alert(msg: string)` — shows `msg` in a standard alert with an OK button.
- `askOpen(path: string): bool` — Standard File "Open" dialog; fills `path` and returns `true`, or returns `false` on Cancel.
- `askSave(path: string, suggested: string): bool` — Standard File "Save" dialog, pre-filled with `suggested`; fills `path` and returns `true`, or returns `false` on Cancel.
- `askSaveChanges(name: string): saveChoice` — the standard three-way "Save changes to “name”?" dialog; returns `Save`, `Discard`, or `Cancel` (Chapter 3).

### Logging

`log(msg: string)` writes a diagnostic line to the platform's diagnostic stream: on a command-line host, standard error; on the Macintosh, a destination reserved for a later release (a log file or debugging window) — programs use it identically either way. Diagnostics belong in `log`; user-facing output belongs in `alert` or files.

### Errors

An `error` (Chapter 3) is the record `{ code: int, message: string }`. The global `lastError: error` holds the detail behind the most recent soft failure: a `false` return from a `file` function, or a clamped string store or byte copy (Chapters 3 and 4).

Clarus reports failures in four ways, depending on where they occur:

- **Async failures** — a `connection`, `listener`, or `serviceBrowser` operation that fails after it's already underway — are delivered as a `failed(err: error)` event on that resource (above).
- **Synchronous fallible operations** — the `file` functions return `bool`; on `false`, inspect `lastError`. String stores and byte copies that must truncate (Chapters 3 and 4) clamp safely, set `lastError`, and continue. There are no exceptions and no unwinding machinery.
- **Out of memory** shows a clean alert and quits, rather than continuing on a corrupted heap.
- **Runtime errors** — dereferencing a `nil` window reference, indexing or slicing a string, text, array, or list out of range, taking from an empty list, accessing a map with a key that doesn't exist (`[]` form, not `get`), a checked enum conversion with no matching member, or a shift count outside 0–31 (Chapter 3, Chapter 4) — show an alert naming the handler in which the error occurred. The app then continues if that's safe, or quits if it isn't.

## Appendix A: Grammar (EBNF)

```ebnf
program     = { topDecl } ;
topDecl     = recordDecl | enumDecl | constDecl | varDecl | funcDecl
            | windowDecl | menuDecl | extendDecl | handlerDecl | everyDecl ;

recordDecl  = "record" IDENT "{" { fieldDecl } "}" ;
fieldDecl   = IDENT ":" type [ "=" ( literal | IDENT ) ] ;

enumDecl    = "enum" IDENT "{" enumMember { [ "," ] enumMember } "}" ;
enumMember  = IDENT [ INT | HEXINT ] [ STRING ] ;

constDecl   = "const" IDENT ":" type "=" ( literal | IDENT ) ;

type        = "int" | "bool" | "fixed" | "char" | "text"
            | "string" [ "(" INT ")" ]
            | "list" "of" type
            | "map" "of" type
            | IDENT
            | type "[" INT "]" ;

varDecl     = "var" IDENT ":" type [ "=" expr ] ;
funcDecl    = "func" IDENT "(" [ params ] ")" [ ":" type ] block ;
params      = param { "," param } ;
param       = IDENT ":" type ;

windowDecl  = "window" IDENT "{" { windowItem } "}" ;
windowItem  = property | widgetDecl | varDecl | "form" "for" IDENT ;
widgetDecl  = widgetKind IDENT [ "{" propertyList "}" ] ;
widgetKind  = "button" | "field" | "textview" | "check" | "popup"
            | "table" | "canvas" | "label" ;
propertyList= property { ";" property } ;
property    = IDENT [ ":" propValue { "," propValue } ]
            | "column" STRING "shows" IDENT "width" ( INT | "fill" )
            | "cancel" ;
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
            | forStmt | switchStmt | returnStmt
            | "quit" [ expr ] | "cancel" | "break" | "continue"
            | "open" IDENT | "close" expr
            | "edit" IDENT "," ( lvalue | "new" IDENT ) ;
assign      = lvalue "=" expr ;
lvalue      = IDENT { "." memberName | "[" expr "]" } ;
callStmt    = lvalue "(" [ args ] ")" ;
ifStmt      = "if" expr block [ "else" ( ifStmt | block ) ] ;
whileStmt   = "while" expr block ;
forStmt     = "for" IDENT [ "," IDENT ] "in" forRange block ;
forRange    = expr [ "to" expr ] ;
switchStmt  = "switch" expr "{" { caseClause } [ "else" block ] "}" ;
caseClause  = "case" caseLabel { "," caseLabel } block ;
caseLabel   = literal | IDENT ;
returnStmt  = "return" [ expr ] ;

expr        = andExpr { "or" andExpr } ;
andExpr     = cmpExpr { "and" cmpExpr } ;
cmpExpr     = addExpr [ cmpOp addExpr ] ;
cmpOp       = "==" | "!=" | "<" | "<=" | ">" | ">=" ;
addExpr     = mulExpr { ( "+" | "-" | "|" | "^" ) mulExpr } ;
mulExpr     = unaryExpr { ( "*" | "/" | "mod" | "<<" | ">>" | "&" ) unaryExpr } ;
unaryExpr   = { "-" | "not" | "~" } postfix ;
postfix     = primary { "." memberName | "[" expr [ "," expr ] "]" | "(" [ args ] ")" } ;
memberName  = IDENT | "open" | "close" ;
primary     = literal | IDENT | "window" | "nil"
            | "new" IDENT | "open" IDENT | "(" expr ")" ;
args        = expr { "," expr } ;
literal     = INT | HEXINT | FIXEDLIT | CHARLIT | STRING | "true" | "false" ;
```

Newline sensitivity (statement termination, Chapter 2) is handled by the lexer and is not shown in the EBNF above. Newlines likewise separate properties inside declaration blocks; `;` is an optional same-line separator there. `appletalk` in `conn.open(appletalk "...")` is a contextual keyword parsed as a call-argument prefix, not a general-purpose token. After `.`, the hard keywords `open` and `close` are permitted as member names (`conn.open(...)`, `c.close()`) — the same positional carve-out Chapter 2 grants `window`. The two-expression index form (`s[start, len]`) is a slice, valid only in expression position — `lvalue` deliberately keeps the single-expression form. In `quit [expr]`, the expression must start on the same line as `quit` (a newline after `quit` ends the statement).

## Appendix B: Event Handler Quick Reference

The following table is the complete per-resource inventory of every event handler; Chapters 7–12 give full semantics.

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

## Appendix C: Worked Examples

### Bookmark Manager

A complete bookmark manager — data, live table, bound edit form:

```rust
enum Protocol { Gopher, HTTP, Telnet }

record Bookmark {
    name:     string(63)
    url:      string(255)
    port:     int = 80
    protocol: Protocol
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
    form for Bookmark

    field Name     { binds: name;     label: "Name:" }
    field Url      { binds: url;      label: "URL:" }
    field Port     { binds: port;     label: "Port:";  width: 60 }
    popup Proto    { binds: protocol; label: "Protocol:" }
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

### Text Editor

A complete multi-document plain-text editor — menus, document launching, and unsaved-changes handling:

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

extend Doc {
    extend File {                  // document commands: the runtime dims
        on Save.select {           // these items when no Doc is frontmost
            save(window)
        }

        on SaveAs.select {
            path = ""              // forget the path to force the dialog
            save(window)
        }
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

- Save and Save As live in an `extend File` scope nested inside
  `extend Doc`, so they only ever run with a Doc frontmost — and the
  runtime dims those menu items whenever that isn't true. Menu enabling
  logic: zero lines.
- The whole "quit with unsaved windows" story is the `closeRequest`
  handler, written once.
- Launching by double-clicking three files opens three windows and no
  empty "Untitled" — `App.openDocument` replaces `App.startEmpty` on a
  document launch (Chapter 7).
- `save` is an ordinary function taking a `Doc` instance; handlers pass
  `window`. No methods needed.
- With a declared document file type for Finder integration (Chapter 12),
  this is a complete, shippable System 6/7 application in under 100 lines.
