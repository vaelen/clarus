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
