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
13. Low-Level Memory Access
Appendix A. Grammar (EBNF)
Appendix B. Event Handler Quick Reference
Appendix C. Worked Examples

## Chapter 1: Program Structure

A Clarus program consists of one or more `.cla` source files, compiled as one program over the concatenation of files in a declared file order (build details are out of scope for this reference). Checking is single-pass over type layout — see declare-before-use below for the precise ordering rules — with function bodies visible to one another regardless of order.

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

**Declare-before-use** governs where a name may be referenced, and it applies in two tiers:

- **Type-layout positions are strictly ordered.** A record field's type, an enum, a function's parameter and return types, and a top-level variable's declared type may only name types declared textually before them. This keeps the compiler single-pass over type layout (a record cannot forward-reference a record, so recursive record types do not arise).
- **Function and handler bodies see the whole program.** Inside any `func`, `on`-handler, or `every` body, a name resolves against every top-level declaration — function, variable, record, enum, or constant — regardless of whether it appears earlier or later in the source. Functions may therefore call one another freely and be mutually recursive, and a body may read a global declared further down.

Local variables inside a body remain declare-before-use, and are declared at the top of the body before any statement. One initialization-order caution follows from the second tier: top-level variable initializers run in declaration order, so a global initializer that calls a function reading a *later* global sees that global still at its zero value.

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

### Multi-File Programs: `include`

A file may pull in another file's declarations with an `include` declaration naming a path in quotes:

```rust
include "geometry.cla"
```

`include` is contextual, not a reserved word — it is only recognized as an include when it starts a top-level declaration and is followed by a string. An `include` must be one of the leading declarations in its file: it may only be preceded by other `include`s, and once any other top-level declaration has appeared, a later `include` is an error.

The path is resolved relative to the directory of the file containing the `include` (not the current working directory, and not relative to the program's entry file). There are no search paths and no conditional includes — a path names exactly one file, unconditionally, with one exception: an `include` whose path's first segment is `toolbox/` (e.g. `include "toolbox/osutils.cla"`) that finds no file relative to the includer's directory falls back to the compiler's own `toolbox/` catalog, resolved off the same runtime directory (`--rtdir`, or the same upward `runtime/clarus/` search) implicit runtime-module inclusion uses — `--rtdir` is accepted in every `clarusc` mode, including plain check-only, specifically so this fallback works there too — so a user program outside the repo can spell `include "toolbox/files.cla"` without a `clarus-src`-style symlink into the compiler's checkout. A file reached this way dedups against the identical file reached by a runtime module's own relative include of it (e.g. `runtime/clarus/uidialogs.cla`'s `include "../../toolbox/files.cla"`) as the same identity, not a second copy.

Includes are expanded depth-first: each included file's own leading includes are resolved first, so a file's declarations always enter the program after everything it depends on. A file is included at most once no matter how many other files include it (identity is the file's **lexically normalized** path — `.`/`..`/`//` segments are resolved textually, so two spellings of the same file dedup; an absolute and a relative spelling remain distinct — so two different files that both include a third common file each see its declarations exactly once, not duplicated) — this also means include cycles (A includes B includes A) are harmless rather than an error: a file already in progress is simply not visited again. Beyond that ordering, declare-before-use across an expanded program works exactly as described above for a single file.

## Chapter 2: Lexical Structure

### Source Encoding

Clarus source files (`.cla`) are Mac OS Roman (MacRoman) encoded, not UTF-8 — so a `.cla` file can be opened and edited on a period Mac. Bytes 0x00-0x7F are plain ASCII; program text (identifiers, keywords, operators) must stay within this ASCII range. Bytes 0x80-0xFF are permitted inside comments and string/character literals, where they pass through to the compiled program verbatim, byte for byte — the compiler never re-encodes them. This document is itself a modern UTF-8 file, and its example listings use real Unicode typography (curly quotes, em dashes, ellipses) for readability; when transcribing an example into an actual `.cla` file, that typography must be saved as MacRoman, not left as UTF-8, or the corresponding glyphs will render as junk bytes on a real Mac screen. On a modern editor, save/open the file with a MacRoman encoding — e.g. VS Code's "Western (Mac Roman)" encoding, or vim's `:e ++enc=macroman`.

### Identifiers

Identifiers begin with a letter and continue with letters, digits, or underscores. Identifiers are case-sensitive. An identifier may be at most 255 bytes; longer is a compile error.

Convention (not enforced): types, windows, menus, and widgets use CapitalCase; variables and functions use lowerCamelCase.

### Keywords

**Hard keywords** (reserved everywhere):

```
var func record enum const window menu extend on every
if else while for in to return
and or not true false nil
open close edit new quit cancel
switch case break continue
attempt aborted
```

Note: `window` is both the declaration keyword and, inside a window's handlers, the expression naming the firing instance (Chapter 8). The parser distinguishes by position.

**Contextual keywords** (special meaning only in the noted position, usable as identifiers elsewhere):

```
list map sortedmap intmap of string text int bool fixed  (type positions)
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
| Character | `'A'`, `'\n'`, `'\xC9'` | single Mac Roman character; same escapes as strings |
| String | `"hello"` | escapes: `\"` `\\` `\n` `\t` `\xHH`; `\n` emits CR (13), the Mac newline; `\xHH` (exactly two hex digits, case-insensitive) emits byte HH — the way to put MacRoman bytes (e.g. `\xC9` for `…`) in a literal while keeping source files pure ASCII. A string literal may be at most 255 bytes. |
| Boolean | `true`, `false` | |
| Nil | `nil` | window/resource references only (`connection`, `listener`, `serviceBrowser`, `filehandle`) |
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
| `string(n)` | n+1 bytes | inline | length-prefixed Pascal string, n ≤ 255; `string` alone = `string(255)`; inside an aggregate it occupies n+1 rounded up to even bytes (Ch13 packing rule) |
| enum | 2 bytes | inline | named type declared with `enum Name { … }` (see Enums below) |
| `record` | sum of fields | inline | plain data aggregate; no methods |
| `T[n]` | n × size(T) | inline* | fixed array, 0-indexed; literal initializer `[…]` for `const`/`var` declarations (Constants) |
| `text` | 4-byte handle | heap | unbounded text buffer |
| `list of T` | 4-byte handle | heap | growable sequence of fixed-size T |
| `map of T` | 4-byte handle | heap | hashtable, string keys ≤ 255 bytes, values fixed-size |
| `sortedmap of T` | 4-byte handle | heap | string-keyed container, values fixed-size; iterates in ascending key order |
| `intmap of T` | 4-byte handle | heap | hashtable, int keys, values fixed-size |
| window ref (e.g. `Doc`) | 4 bytes | inline | reference to a window instance; `nil` until assigned |
| `connection`, `listener`, `serviceBrowser`, `filehandle` | opaque | resource | networking and file resources (Chapter 12) |
| `error` | record | inline | `{ code: int, message: string }` |
| `FileInfo` | record | inline | `{ size: int, rsrcSize: int, type: string, creator: string, created: int, modified: int, isDir: bool }` (Chapter 12) |
| `address` | opaque | inline | network address from a `serviceBrowser` |
| `saveChoice` | enum | inline | built-in: `Save`, `Discard`, `Cancel` |

\* "inline" values past a size threshold are transparently promoted to handle-backed storage by the compiler (spec §6); semantics are identical.

Resource variables (`connection`, `listener`, `serviceBrowser`, `filehandle`) are fixed-size 4-byte references, like window references: assignable, storable in records and arrays (`connection[8]` is 8 references, 32 bytes), and `nil` until bound.

`FileInfo` is a predeclared record (Chapter 12: Files) returned by `file.info` — an ordinary value, like any user record: assignable, copyable, a legal field, array, or `list of`/`map of` element type. A program may not declare its own `FileInfo` (the ordinary duplicate-declaration error). Its seven fields, in declaration order: `size: int` (data fork length in bytes; 0 for a folder), `rsrcSize: int` (resource fork length in bytes; 0 for a folder or on a host), `type: string` (Finder type, `""` on a host or for a folder), `creator: string` (Finder creator, `""` on a host or for a folder), `created: int` and `modified: int` (Macintosh-epoch seconds, the same clock as `now()`), and `isDir: bool`. A file with no Finder type set reads back `type == ""`, the same as a folder; `isDir` is the reliable discriminator.

**Storage:** `bool` and `char` occupy exactly 1 byte inside every ordinary aggregate — records and arrays — on every target; `bool` occupies 1 byte inside an `extern record` too, but `char` is not a legal `extern record` field type at all (an extern record's 1-byte numeric field type is `byte` — see the Chapter 13 field palette). As a standalone local, parameter, or global, `bool`/`char` occupy a 2-byte slot (68000 even-address alignment). At `external func`/`trap` boundaries the Chapter 13 marshaling rules apply (a bool/char parameter or result travels in a 16-bit stack word).

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
var s: string = string(i)    // int to string, decimal, "42"
var s2: string = string(c)   // char to string, "*"
```

Numeric truncation in `int(f)` is toward zero. `char(i)` is not a numeric truncation: it keeps only the low byte of `i` — `char(-1)` yields 255. `string()` takes an `int` (rendered in decimal, negative values included, e.g. `string(-7)` is `"-7"`) or a `char` (the one-character string); it is unrelated to the type-position use of `string(n)` as a capacity declaration (e.g. `var s: string(20)`) — the two are told apart positionally (a call expression vs. a type), never ambiguously.

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

**Concatenation:** `string + char` appends the character to the string, and `char + string` prepends it:

```rust
var s: string = "hi"
s = s + 'b'                  // "hib" (append)
s = 'a' + s                  // "ahib" (prepend)
```

**Comparison:** Strings and characters compare byte-wise with `==`, `!=`, and other relational operators.

**Slicing:** `s[start, len]` yields a new `string` holding `len` characters beginning at index `start` (the Pascal `Copy` parameter order). Bounds are strict: `start < 0`, `len < 0`, `start + len > s.length`, or `len > 255` raises a runtime error (`slice out of range`). A slice is an expression, never an assignment target:

```rust
var s: string = "hello world"
var w: string = s[6, 5]          // "world"
```

**Searching:** `s.indexOf(needle)` returns the index of the first occurrence of `needle` (a `string` or a `char`), or `-1` if absent. Byte-wise, case-sensitive; an empty `string` needle matches at index 0:

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
- `l.clear()` — remove all elements; `count` becomes 0, capacity is retained. `.clear()` releases the elements it discards. It is O(1) for scalar element types and O(n) for reference-bearing element types (the elements are released first)
- `l.clone()` — return a new `list of T`, independent of `l`, holding a copy of every element (mutating the clone never affects `l`, and vice versa). Only legal when `T` is a *flat* type — no `text`, `list of`, or `map of` anywhere in it, recursively through record fields and fixed arrays (`int`/`bool`/`char`/`fixed`/enum/`string(n)`/`char[n]`/a record built only from those is fine). Cloning a non-flat element type is a check-time error: the clone is a single bulk copy of the backing store, which would alias a reference-typed element instead of copying it
- `for x in l { … }` — iterate (see Chapter 5)

Out-of-range indexing raises a runtime error, and so do `pop`, `shift`, `first`, and `last` on an empty list.

### Maps

A `map of T` is a hashtable with string keys (up to 255 bytes) and values of fixed-size type `T`. Map operations are:

- `m[k] = v` — set key `k` to value `v`
- `m[k]` — retrieve value for key `k` (returns `T`); runtime error if absent
- `m.get(k, dv)` — retrieve the value for key `k`, or the default value `dv` (of type `T`) if the key is absent; never errors. `k` and `dv` are evaluated left to right (`m`, then `k`, then `dv`) if either is an expression with side effects
- `m.has(k)` — test for key presence (returns `bool`)
- `m.remove(k)` — remove the entry for key `k`; silently succeeds if absent
- `m.count` — number of entries (returns `int`)
- `m.clear()` — remove all entries; `count` becomes 0, capacity is retained. `.clear()` releases the values it discards (keys are inline strings, never released). It is O(1) for scalar value types and O(n) for reference-bearing value types (the values are released first)
- `for k, v in m { … }` — iterate (see Chapter 5)

Keys are compared case-sensitively, byte-wise. Iteration (`for k, v in m`) visits entries in an unspecified but deterministic order (a given sequence of inserts and removes always replays the same order); use `sortedmap of T` when ascending key order matters.

### Sorted maps

A `sortedmap of T` is a string-keyed (up to 255 bytes) container of fixed-size values of type `T`, with the exact same operations as `map of T`:

- `m[k] = v` — set key `k` to value `v`
- `m[k]` — retrieve value for key `k` (returns `T`); runtime error if absent
- `m.get(k, dv)` — retrieve the value for key `k`, or the default value `dv` (of type `T`) if the key is absent; never errors
- `m.has(k)` — test for key presence (returns `bool`)
- `m.remove(k)` — remove the entry for key `k`; silently succeeds if absent
- `m.count` — number of entries (returns `int`)
- `m.clear()` — remove all entries; `count` becomes 0, capacity is retained. `.clear()` releases the values it discards (keys are inline strings, never released). It is O(1) for scalar value types and O(n) for reference-bearing value types (the values are released first)
- `for k, v in m { … }` — iterate (see Chapter 5)

Keys are compared case-sensitively, byte-wise. Iteration (`for k, v in m`) visits entries in ascending key order (byte-wise) — deterministic regardless of insertion or removal history.

`sortedmap of T` is a distinct type from `map of T`: the two are never assignable or comparable to each other, even with the same element type `T`.

### Integer maps

An `intmap of T` is an int-keyed hashtable of fixed-size values of type `T`, with the same operations as `map of T`, keyed by `int` instead of `string`:

- `m[k] = v` — set key `k` to value `v`
- `m[k]` — retrieve value for key `k` (returns `T`); runtime error if absent
- `m.get(k, dv)` — retrieve the value for key `k`, or the default value `dv` (of type `T`) if the key is absent; never errors
- `m.has(k)` — test for key presence (returns `bool`)
- `m.remove(k)` — remove the entry for key `k`; silently succeeds if absent
- `m.count` — number of entries (returns `int`)
- `m.clear()` — remove all entries; `count` becomes 0, capacity is retained. `.clear()` releases the values it discards (keys are ints, never released). It is O(1) for scalar value types and O(n) for reference-bearing value types (the values are released first)
- `for k, v in m { … }` — iterate (see Chapter 5), `k` is `int`

Iteration (`for k, v in m`) visits entries in an unspecified but deterministic order (a given sequence of inserts and removes always replays the same order) — same contract as `map of T`.

`intmap of T` is a distinct type from `map of T` and `sortedmap of T`: none of the three are ever assignable or comparable to each other, even with the same element type `T`.

### Text

A `text` is an unbounded, resizable buffer of characters. A `string` value may be used wherever a `text` is expected — assignment, a call argument, a return value, or a `list`/`map` element — and the conversion always creates a **fresh** `text` holding a copy of the string's bytes: because strings are values, mutating the resulting `text` never affects the original `string`. Text operations are:

- Assignment: `t = "hello"`
- Concatenation: `t = t + "world"`
- `t.append(x)` — append `x` (a `string`, `char`, or `text`) in place. Unlike concatenation with `+`, which rebuilds the buffer, `append` grows it amortized (and accepts a `char` directly, which `+` does not) — the right tool for building large output in a loop.
- `t.clear()` — reset length to 0 in place. Capacity and the underlying buffer are kept (no allocation, no shrink), so a reused buffer cleared each cycle appends again without re-growing — pair with `reserve` for trap-free hot loops.
- `t.reserve(n)` — pre-grow capacity to at least `n` bytes (at most one underlying resize; a no-op when capacity already suffices; never shrinks). Fails the same way growth during `append` does if memory is exhausted. For producers that must append byte-at-a-time and cannot batch.
- `t[i]` — the character at index `i` (returns `char`), 0-based; `t[i] = c` assigns in place
- `t[start, len]` — slice, yielding a `string`; same strict-bounds rules as string slicing (above)
- `t.indexOf(needle)` — first index of a `string` or `char`, or `-1` (as for strings)
- `t.length` — length of the buffer (returns `int`)
- Comparison: `t == "hello"` (byte-wise)
- `t.fromBytes(buf, count)` / `t.toBytes(buf)` — byte copies to and from a `char` array, with the same clamping rules as their `string` counterparts (above). A `text` has no fixed capacity, so `fromBytes` resizes the text and never truncates; `toBytes` still clamps to the array's capacity and sets `lastError` if bytes were dropped.
- `t.hashStep(h, pos, n)` — folds bytes `[pos, pos+n)` into rolling hash `h` (per byte: `h = ((h << 5) + h + b) & 0x7FFFFFFF`) and returns the updated value; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. For incrementally hashing a large buffer in chunks without an intermediate copy.
- `t.intAt(pos)` — reads the 4-byte big-endian field at `pos` and returns it as the `int` whose bits those are (values with the top bit set are negative). Out-of-range `pos` raises a runtime error. For reading binary formats with a fixed-width length or offset field.
- `t.stringAt(pos)` — reads a 1-byte Pascal-style length prefix `L` at `pos` (the same layout `string` itself uses — length byte then payload), then `L` bytes, returning them as a `string`; the caller advances by `1 + result.length`. Raises a runtime error if the range is out of bounds. For reading length-prefixed binary formats whose length byte matches `string`'s own Str255 shape.
- `t.textAt(pos, n)` — a fresh `text` holding a copy of bytes `[pos, pos+n)`; `n == 0` is legal and yields an empty `text`. Out-of-range `pos`/`n` raises a runtime error. For extracting a binary-format sub-range without hand-copying byte by byte.
- `t.intAtLE(pos)` — `intAt`'s little-endian twin: reads the same 4-byte field but combines the bytes low-byte-first.
- `t.wordAt(pos)` / `t.wordAtLE(pos)` — reads a 2-byte big-/little-endian field at `pos` and returns it as an **unsigned** value, `0`–`65535` (unlike `intAt`/`intAtLE`, there is no sign bit to preserve at 16 bits).
- `t.setIntAt(pos, v)` / `t.setIntAtLE(pos, v)` — writes `v`'s 4 bytes at `pos`, big- or little-endian.
- `t.setWordAt(pos, v)` / `t.setWordAtLE(pos, v)` — writes `v`'s low 16 bits at `pos` as a 2-byte field, big- or little-endian.
- `t.crc16(h, pos, n)` — folds bytes `[pos, pos+n)` into running CRC `h` (masked to 16 bits) and returns the updated value; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. The algorithm is CRC-16/KERMIT (poly `0x8408` reflected, seed and result both taken as-is, no final XOR) — the published check value for `crc16(0, 0, 9)` over the ASCII bytes `"123456789"` is `0x2189`. Like `hashStep`, it is chunkable: folding a buffer in pieces (feeding each call's return value in as the next call's `h`) produces the same result as one call over the whole range.
- `t.crc16x(h, pos, n)` — folds bytes `[pos, pos+n)` into running CRC `h` (masked to 16 bits) and returns the updated value; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. The algorithm is CRC-16/XMODEM (poly `0x1021` forward, MSB-first, no reflection; seed and result taken as-is, no final XOR) — the one XMODEM-CRC and YMODEM use. The published check value for `crc16x(0, 0, 9)` over the ASCII bytes `"123456789"` is `0x31C3`. Chunkable exactly like `crc16`.
- `t.crc32(h, pos, n)` — folds bytes `[pos, pos+n)` into running 32-bit CRC register `h` and returns the updated register; `n == 0` returns `h` unchanged. Out-of-range `pos`/`n` raises a runtime error. The algorithm is CRC-32 (reflected poly `0xEDB88320` — the IEEE/zip/ZMODEM CRC), table-driven; the table is built on the first call. The register is returned **raw**: the caller supplies the `0xFFFFFFFF` seed and applies the final XOR itself, so the published check is `t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF == 0xCBF43926` over `"123456789"`. The result is an ordinary 32-bit `int` — a register with bit 31 set reads as negative (`0xCBF43926` is `-873187034`), and hex literals above `0x7FFFFFFF` wrap the same way, so comparisons against published check values work as written. Chunkable exactly like `crc16`: feed each call's return value in as the next call's `h`, and apply the final XOR once at the end.

All eight bound accessors above (`intAt`/`intAtLE`/`wordAt`/`wordAtLE`/`setIntAt`/`setIntAtLE`/`setWordAt`/`setWordAtLE`), plus `crc16`/`crc16x`/`crc32`, use the same STRICT out-of-range rule as `intAt` and `hashStep`: `pos` must be in range for the field's own width, checked without the overflow a naive `pos + width > t.length` test would have.

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

A `const` or `var` whose declared type is a fixed array `T[n]` may be initialized from an **array literal**:

```rust
const kermitTab: int[4] = [0x0000, 0x1189, 0x2312, 0x329B]
var keymap: char[3] = ['a', 'b', 'c']
```

An **array literal** `[e1, e2, …]` is legal only as the initializer of a `const` or `var` whose declared type is a fixed array `T[n]`. Its elements follow the `const` rule above (a literal, an enum member, or a previously declared constant — no expressions), `T` must be `int`, `fixed`, `char`, `bool`, or an enum, and the element count must equal `n` exactly; a mismatch is a compile error naming both counts. A `const` array lives in the program's constant pool: reading `tab[i]` costs one bounds-checked load and nothing at startup, and passing it to a function borrows it in place. A `var` array with a literal is copied from the pool once, when the variable is initialized. Assigning to an element of a `const` array is a compile error. Nested literals, `string(n)` or record elements, and array literals in any other expression position are not supported.

### Runtime Errors

The following operations may raise runtime errors (Chapter 12 specifies how errors are reported):

- Indexing a string, text, array, or list out of range
- Slicing a string or text out of range, or with a length over 255
- `pop`, `shift`, `first`, or `last` on an empty list
- Accessing a map with the `[]` form using a key that does not exist (`get` never errors)
- A checked enum conversion (`EnumType(i)`) with a value that matches no member
- Dereferencing a `nil` window reference
- Dividing an `int` by zero, or taking `mod` by zero

## Chapter 4: Expressions and Operators

### Operator Precedence

The following table is normative. Operators bind tighter the lower their level number; within a level, operators are left-associative. Comparison operators do not chain: `a < b < c` is a compile error.

| Level | Operators | Notes |
|---|---|---|
| 1 | `()` grouping, `f(args)` call, `a[i]` index, `a.b` field/property, `new T`, `open T` | postfix/primary |
| 2 | unary `-`, `not`, `~` | `~` is bitwise NOT (int only) |
| 3 | `*` `/` `mod` `<<` `>>` `&` | `/` on int truncates toward zero; `fixed` uses `FixMul`/`FixDiv`; shifts and `&` are int only; division or `mod` by zero is a runtime error (Chapter 3); the quotient of the most negative `int` and −1 is the most negative `int`, and the remainder is 0 |
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

`+` concatenates two `string`s, two `text`s, a `string` with a `text` in either order (the result is always `text`), and a `char` with a `string` in either order (append or prepend; the result is `string`, per Chapter 3). A `string + string` result is a temporary of the combined length; when that temporary is stored into a fixed-capacity `string(n)` target, the store is clamped to the target's capacity. The copy never writes past the end — a buffer overrun is impossible by construction. If clamping dropped any bytes, the store sets `lastError` (Chapter 12) and execution continues:

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
on App.startCLI(args: list of string) {
    if args.count == 0 {
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

### Attempt and Abort

`attempt { } aborted msg { }` is cooperative, non-local error propagation: the body runs; if `abort(expr)` fires anywhere during it — directly, or arbitrarily many calls deep — control jumps to the `aborted` block with `msg` bound to the aborted message, skipping the rest of the body. `attempt` always requires an `aborted` block; there is no bare `attempt`.

```rust
func loadConfig(path: string): text {
    var t: text
    if not file.readText(path, t) {
        abort("cannot read " + path)
    }
    return t
}

func startup() {
    var cfg: text
    attempt {
        cfg = loadConfig("prefs.dat")
        log("config loaded")
    } aborted msg {
        log("startup failed: " + msg)
    }
}
```

`abort(expr)` is itself an ordinary statement, valid anywhere a statement is — inside a function body, an event handler, or an `aborted` block itself (a **re-abort**, below). `expr` must be `string`-typed, with the same coercions `alert` accepts. `abort` does not exit the program; it unwinds the call chain looking for the nearest enclosing `attempt`.

**Binder scope.** `msg` (the identifier after `aborted`) is a fresh `string` local, scoped to the `aborted` block only; ordinary shadowing rules apply.

**Nesting and re-abort.** `attempt` blocks nest freely. The dynamically innermost `attempt` whose body is currently running catches an abort raised inside it — an abort deep in a call chain is caught by whichever `attempt` statically encloses the *call site* that (transitively) led to the `abort`, not by an `attempt` merely active higher up an unrelated call path. Calling `abort` again from inside an `aborted` block (a re-abort) propagates to the *next* enclosing `attempt` — never back into the same one — or to the top-level default (below) if there is none:

```rust
func riskyStep() {
    abort("step failed")
}

func run() {
    attempt {
        attempt {
            riskyStep()
        } aborted inner {
            log("inner saw: " + inner)
            abort("re-raised: " + inner)      // propagates OUTWARD, not back into this block
        }
    } aborted outer {
        log("outer caught: " + outer)          // runs; "re-raised: step failed"
    }
}
```

**`return` inside `attempt` is ordinary.** A `return` statement anywhere inside an `attempt` body (or an `aborted` block) exits the enclosing function exactly as it would anywhere else — it is not intercepted by the `attempt` it happens to be inside.

**What actually unwinds.** There is no exception object, no stack of active handlers, and no runtime bookkeeping beyond one pending-message value: an aborting function returns through its own ordinary epilogue (every local it owns is released, exactly as on a normal return), and each caller up the chain checks once, after the call returns, whether an abort is pending — if so, it also returns through its own epilogue (releasing its own locals) unless the call site is lexically inside an `attempt` body, in which case control instead enters that `attempt`'s `aborted` block. This is why `attempt`/`abort` never leaks memory the way an unchecked jump out of scope would: every frame it passes through cleans up on the way. "Nearest enclosing attempt" is a purely compile-time question — the compiler resolves it from where the call site sits in the source, not from any runtime search.

**Uncaught abort (top-level default).** An `abort` that no `attempt` catches reaches a runtime default:

- **Command-line programs:** the message is written to the diagnostic stream (the same channel `log` uses), and the program exits with code 1 — identical to a bare `log(msg)` followed by `quit 1`.
- **GUI (Macintosh) programs:** the system beeps, the message is shown in a standard alert (the same presentation `alert(msg)` uses), and the program then quits with code 1.

Either way, this is the *only* place `attempt`/`abort` ever terminates the program — an `abort` caught by some `attempt`, anywhere in the chain, never does.

The GUI default's own timing depends on which Mac build path produced the program. Built via the native 68k path (`scripts/build-68k.sh`, `clarusc emit68k`), the default is checked after *every* individual event-handler dispatch, so an uncaught abort surfaces immediately, no matter which handler raised it — including one raised directly in a top-level event handler. Built via the C/Retro68 path (`scripts/build-mac.sh`), the default is checked only after `App.launch` returns and after the event loop itself returns — an abort raised inside an ordinary event handler is detected only once the whole app is shutting down, not at the moment it happens.

**Interaction with runtime errors.** `attempt`/`abort` is unrelated to the runtime errors listed under Runtime Errors (Chapter 3) and Errors (Chapter 12) — an out-of-range index, a `nil` window dereference, and the like are not `abort`s and are not caught by an `attempt`; they follow their own existing reporting rules. `attempt`/`abort` exists purely for a program's *own* code to signal and recover from a failure it defines itself.

**Interaction with `callback func`.** If `abort` fires while control is inside a `callback func` invoked BY the Toolbox (Chapter 13) — the callback is executing because a Toolbox trap called back into it, not because ordinary Clarus code called it — propagation cannot continue past that boundary the normal way: the callback returns a default value to the Toolbox as if it had returned normally, and the Toolbox completes whatever call it was in the middle of. The pending abort then resumes propagating from the first ordinary checked call site *after* that original external call returns, exactly as if the callback itself had been the site where the abort occurred. A callback's own body needs no special code to arrange this — it is a property of where callback glue sits, not something a callback author writes.

**Not for use in the bundled runtime library.** Clarus ships with a runtime library (the `list`, `map`, `text`, and similar built-in types' own implementations, plus the machinery behind `open`/`close`/the dialogs in Chapter 12) written in Clarus itself. That library's own source does not use `attempt`/`abort` internally — it is a convention the library's authors follow, not a restriction this compiler enforces on ordinary application code. Nothing about writing your own program is affected by it; it is mentioned here only because it means a runtime-provided call (`t.toBytes(...)`, `askOpen(...)`, and the like) never itself raises an `abort` your code would need to catch.

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

Scalars, records, strings, and fixed arrays pass **by value** (semantically — the callee cannot affect the caller's copy; how the compiler achieves that is described under *Parameters are immutable* below); `text`, `list`, `map`, and window refs pass **by reference** (they are references). A parameter documented as filled by the callee (e.g. `file.readText(path, t)`) mutates the passed `text`/`list`/`map` in place. User-declared functions cannot fill fixed-size out-parameters — return values instead. Built-in runtime routines are not bound by this rule: dialogs such as `askOpen(p, types)` and `askSave(path, suggested)` fill the string you pass, using a runtime calling convention not available to user code (Chapter 12).

Parameters are immutable bindings: a function may not rebind a parameter name (`x = ...`) or store through a value-typed parameter — a field or index write on a `record`, fixed array, or `string` parameter — and either is a build-time error (`cannot assign to parameter NAME`). Mutating the referent of a reference-typed parameter (`text`, `list`, `map`, a window ref) stays legal; that mutation is the whole point of passing by reference, not a rebind of the parameter itself. Fixed arrays with scalar elements are passed by reference like `string` and `record` values (the callee borrows the caller's storage; a copy is made only when the argument aliases storage the callee writes), so passing a large table costs nothing.

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

Functions may be declared at top level only. They are visible to the whole program regardless of order: any function or handler body may call any function whether it appears earlier or later, and two functions may call each other (mutual recursion). This follows from the body-scope tier of declare-before-use (Chapter 1) — a function's parameter and return types, being type-layout positions, must still be declared before the function.

## Chapter 7: Application Lifecycle

### Application Entry Points

A Clarus program responds to application-level events through top-level event handlers. These are the sole entry points to user code (aside from the other handlers documented in Chapters 8–12).

### Event Inventory

| Event | Signature | When |
|---|---|---|
| `App.launch` | `on App.launch { }` | Always first, once, before any window exists. App-wide setup. |
| `App.openDocument` | `on App.openDocument(path: string) { }` | Once per document the Finder launched the app with, or dropped on it while running. |
| `App.startEmpty` | `on App.startEmpty { }` | After `launch`, only when the app was started with **no** documents. |
| `App.startCLI` | `on App.startCLI(args: list of string) { }` | After `launch`, only on a command-line host, carrying the argument list. Never fires on the Macintosh. |
| `App.log` | `on App.log(line: string) { }` | Once per `log(...)` call, at any point in the program's life, carrying that call's line. |

#### `App.log`

`on App.log(line: string)` subscribes to the program's own diagnostic stream: every `log(...)` call (Chapter 12) fires it once, with that call's line. It is optional, and only one is meaningful: as with the other `App` handlers, a second declaration of the same event silently replaces the first. Four rules define it:

1. **The persistent channel comes first.** The line reaches the platform's diagnostic stream (standard error on a command-line host; the log the Macintosh runtime writes at exit) *before* the handler runs. A handler that aborts or crashes cannot cost the line.
2. **The handler runs synchronously**, inside the `log(...)` call, before that statement completes.
3. **It does not re-enter.** A `log(...)` called from inside the handler — directly or through anything the handler calls — still reaches the persistent channel, but does *not* fire the handler again. Nesting is impossible by construction, so a handler may log freely.
4. **Only your own `log(...)` calls reach it.** The runtime's own writes to the same stream — the crash report a panic emits, the message an uncaught `abort` prints (Chapter 5), the Macintosh UI trace — never fire the handler. Neither does an unwinding program: no `log(...)` statement runs while an abort is propagating.

An `abort(...)` raised inside the handler propagates out of the `log(...)` call site like an abort raised by any other call, and can be caught by an enclosing `attempt` (Chapter 5). The subscription survives it: later `log(...)` calls fire the handler as usual.

The handler is how a program puts its own diagnostics somewhere a user can see them — a log window's `textview`, a file, a status line — without touching a single `log(...)` call site.

### Nothing Opens Implicitly

A Clarus program does not automatically open any window. A program launched with no documents that provides no `App.startEmpty` handler shows only the menu bar. The programmer must explicitly open windows by calling `open WindowType` (Chapter 5) in an event handler.

### Launch Order

The runtime fires application events in the following sequence:

```
App.launch
  ├─ App.openDocument (× N documents)     [Macintosh, launched with documents]
  ├─ App.startEmpty (no documents)        [Macintosh bare launch]
  └─ App.startCLI(args)                   [command-line host]
```

On a command-line host, `App.startCLI` fires after `launch` with the argument list (excluding the program name; possibly empty). A program that declares no `startCLI` handler falls back to `App.startEmpty` — a GUI-style program run from the command line behaves as a bare launch. On the Macintosh, `startCLI` never fires.

### Quit Semantics

The `quit` statement (Chapter 5) requests that the application exit. The runtime does not exit immediately; instead, it sends a `closeRequest` event to every open window, starting with the front-most window and proceeding toward the back. If any window's `closeRequest` handler runs `cancel` (Chapter 5), the entire quit is aborted and the app remains open. If all windows close without cancellation, the app exits.

### Mac Launch Events

These events correspond to the classic Macintosh OAPP and ODOC Apple events sent by the Finder; design rationale appears in the language design spec.

**System 6 vs. System 7+:** On System 6, `App.openDocument` fires only for documents the Finder handed the application at launch (via the pre-AppleEvents Segment Loader mechanism) — a document dropped on an *already-running* Clarus program never arrives at all. Receiving documents while the program is already running requires System 7's AppleEvents, which in turn requires the program to declare an `app` section (Application Identity, below): declaring one is what makes the build high-level-event aware, the flag the Finder and the toolbox check before routing a dropped document as an Apple event instead of a fresh launch. A program with no `app` section still gets `App.openDocument` for documents present at launch on both systems — only the "drop while running" behavior is System-7-and-`app`-section-only.

### Command-Line Programs

A tool built for a command-line host does its work in `App.startCLI`, which delivers the arguments the way `openDocument` delivers a path — documents opened from the Finder never arrive as arguments:

```rust
on App.startCLI(args: list of string) {
    for a in args {
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

### Application Identity

An optional top-level `app` section names the program and feeds its Finder-facing identity (the Apple menu's About item and About box, the `vers` resource that `Get Info` reads for the version line, and the four-character creator/signature the classic Mac OS uses to associate documents with their owning application):

```
app Bookmarks {
    name: "Bookmarks"
    version: "1.0"
    author: "A. Programmer"
    about: "Keeps track of your favorite places."
    icon: "bookmarks.pbm"
    id: "BMRK"
}
```

A program has at most one `app` section; a second is an error. Every property is optional. All but `stack` take a bare string literal — no expressions, no concatenation; `stack` takes a bare int literal:

| Property | Meaning |
|---|---|
| `name` | The program's name: it appears in the Apple menu's About item ("About _name_...") and About box, and in the `vers` resource's long version string ("_name_ _version_"), which is what `Get Info` shows. If omitted, falls back to the `app` section's own label (e.g. `Mandelbrot` in `app Mandelbrot { }`); if there is no `app` section either, falls back to the first input file's basename. An explicitly empty `name: ""` behaves the same as omitting it — it falls back to the app label (or filename) and the About item/box fall back to their legacy no-app-section behavior. |
| `version` | Version string, shown in the About box and in the `vers` resource (which `Get Info` reads). |
| `author` | Author/copyright string, shown only in the About box (`ParamText`'s `^2` slot) — no Finder-visible resource carries it. |
| `about` | A one-line description, shown only in the About box (`ParamText`'s `^3` slot) — no Finder-visible resource carries it. |
| `icon` | Path to a PBM icon, relative to the file the `app` section is declared in. Requires `id` — the icon is stored under the application's own creator code, so one can't exist without the other. |
| `id` | The application's four-character creator code (e.g. `"BMRK"`), used to tag the program and its documents for the Finder. Must be exactly four printable characters, not all lowercase (an all-lowercase four-character code is reserved by Apple for system use), and must not contain a `"` or `'` character (the build interpolates it verbatim into generated Rez and CMake source). |
| `doctype` | The program's default document type code (e.g. `"TEXT"`), used to tag documents the program saves for the Finder. 1 to 4 printable characters, space-padded to four; must not contain a `"` or `'` character. Feeds `app.doctype` (see App Constants, below). Defaults to `"TEXT"` if omitted, or if there is no `app` section at all. |
| `stack` | The native (68k) build's stack-reserve size in bytes, e.g. `stack: 65536`. An int literal between 4096 and 1048576. Native-lane semantics only — a Mac/host build compiled through the cprint (C) backend ignores this field entirely, though it still checks clean there. If omitted, the native backend computes a reserve itself: the deepest call chain reachable in the program plus fixed Toolbox headroom, floored at 32768 bytes. |

### App Constants

`app.doctype` and `app.id` are compile-time constant expressions, valid anywhere a `string` expression is expected: they read back the `app` section's own `doctype`/`id` fields, resolved to a string literal at compile time and space-padded to exactly four characters. In a program with no `app` section (or one that omits the field), `app.doctype` is `"TEXT"` and `app.id` is `"????"`.

A handful of common four-character type codes are predeclared as `string` constants, for use with `app.doctype` and anywhere else a document/file type or creator code is needed:

| Constant | Value | Meaning |
|---|---|---|
| `fileTypeText` | `"TEXT"` | Plain text |
| `fileTypeData` | `"CLRD"` | The serializer's conventional data-file type (Chapter 12) — recommended when a program wants its data files visually and behaviorally distinct from its documents, though any type code is legal for a data file |
| `fileTypePicture` | `"PICT"` | QuickDraw picture |
| `fileTypeApplication` | `"APPL"` | Application |

These constants are a convenience, not a closed set: any four-character string — a custom document type, `"ttro"`, another application's creator code — is an equally legal type or creator code wherever one is expected.

## Chapter 8: Windows and Widgets

### Window Declaration

A `window` block is a declaration, not code: it compiles to a real resource (WIND, plus CNTL/DITL for its widgets), the way a `record` compiles to a layout. The following properties may appear at the top of a window's body:

| Property | Form | Meaning |
|---|---|---|
| `title` | `title: "Untitled"` | initial title; assignable at runtime (`w.title = ...`) |
| `size` | `size: 400, 300` | content size in pixels |
| `resizable` | `resizable` or `resizable: min(300, 200)` | grow box + zoom box + optional minimum |
| `menus` | `menus: File, Edit` | the menus shown (after the app-wide ones) while a window of this type is frontmost; each must be declared above this window |
| `form for T` | `form for Bookmark` | marks a form window (Chapter 10) |

One additional window declaration — the document file-type declaration for Finder integration — is described in Chapter 12; its syntax is settled alongside the toolchain.

**Mac note — `size` on a small screen:** `size` is a request, not a guarantee. On a Macintosh screen too small for the declared size (e.g. a Mac Plus's 512×342 against a 460×320 window), the runtime clamps the window's position and, if that alone isn't enough, its size too, so the whole window — including the grow box — stays on-screen.

**Mac note — zoom:** a resizable window's zoom box toggles it between its current size and position and a standard state — the full screen minus the menu bar, clamped to the screen the same way `size` is at open. Zooming (either direction) fires the window's `resized` event.

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
| `resized` | `on resized { }` | The user resized or zoomed the window (resizable windows only). |
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
| `popup` | `label`, `at`, `width`, `binds` | `selected` (int index) | `change` |
| `table` | `rows`, `column ...` (Chapter 10), `at`, `fill` | `selected` (int, −1 none) | `select(i: int)`, `doubleClick(i: int)` |
| `canvas` | `at`, `fill`, `buffered` | `width`, `height` | `click(x: int, y: int)`, `drag(x: int, y: int)` |
| `label` | `text`, `at`, `width` | `text` | — |

`binds` connects a `field`, `check`, or `popup` to a record field inside a form window (Chapter 10); `default` and `cancel` on a `button` wire the Return and Escape keys respectively. A `field`'s `text` runtime property is a `string`; a `textview`'s is a `text`.

A `textview` has one method, `scrollToEnd()`, callable as a statement from any handler (`Body.scrollToEnd()` inside the window's own `extend` block, or `w.Body.scrollToEnd()` through a window reference) — the same call shape a `canvas`'s drawing methods use (Chapter 11). It scrolls the view so its last line is visible and moves the vertical scrollbar to match; when the content already fits it does nothing, and the horizontal position is never changed. Like every programmatic write to a widget, it never fires `change`. A log window fed from `on App.log` (Chapter 7) assigns its `text` and then calls `scrollToEnd()` so the newest line is always the one on screen. It is a `textview` method only — on any other widget kind it is a check error.

A `button`, `check`, `field`, `popup`, or `label` declared without its caption-like property (`caption`, `label`, or `text`, respectively) displays its own widget name instead — the same "member name when unlabeled" default Chapter 3 gives an enum member with no label. Appendix C's Bookmark Manager relies on this for its `EditForm` buttons: `button OK { default }` and `button Cancel { cancel }` give no `caption:` at all, so they display "OK" and "Cancel".

**Mac note — textview capacity:** on the Macintosh, a `textview`'s `text` property holds at most 32,000 bytes (a classic TextEdit limit). Setting it (directly, or by reading a longer file into it) with more content than that truncates to the first 32,000 bytes and sets `lastError` (Chapter 12), the same as any other clamped string store; execution continues with the truncated content. A program that must reject an oversized document outright — rather than silently show a truncated one — reads the file into an uncapped local `text` (Chapter 3), checks its length, and only assigns it to the `textview` if it fits (Appendix C's Text Editor does this in `openPath`). Separately: pathological content shaped as one unbroken word of several tens of thousands of bytes (no spaces or line breaks at all) makes classic TextEdit's line-wrap search effectively quadratic — real text, which breaks on whitespace at normal intervals, does not hit this.

**Mac note — `scrollbar: both`:** `scrollbar: vertical` wraps text at the view's width (prose style). `scrollbar: both` turns word wrap off — lines break only at Return, long lines extend right (code and log style) — and adds a horizontal scrollbar. The horizontal scroll range tracks the widest line; when everything fits, the bar goes empty (no thumb). The view scrolls automatically to keep the insertion point visible.

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

On a `field` with a `label:`, `width:` gives the width of the edit box alone — the fixed label lane is added to its left, so every field's edit box in a form starts at the same x regardless of each field's own `width:`. `width: fill` is the exception: it sizes the whole widget (label lane included), same as any other widget. Omitting `width:` keeps the field's natural overall size (label lane plus a default box width) unchanged from a bare, un-widthed field. A `popup` with a `label:` follows the identical rule — `width:` gives the popup's own visible box, with the label lane added to its left — so a labeled `popup` and a labeled `field` of the same declared `width:` line up the same way.

A widget declared with no `at:` at all defaults to a vertical stack — placed one gap below the previous widget (or the window's top edge, for the first widget), at a fixed left margin — unless it also declares `fill: both`, which defaults instead to the window's own top-left origin, since a widget filling both dimensions is meant to occupy the whole window regardless of declaration order. A window declared with no `size:` at all sizes itself to fit its widgets' laid-out extent (their declared or default sizes, stacked per the rule above) plus margin, the same way an explicit `size:` is itself only a request (see the Mac note above). Appendix C's Bookmark Manager `EditForm` relies on both defaults: it gives its window no `size:` and none of its widgets an `at:`. Auto-placed and explicitly placed widgets share one running layout cursor: an at:-less widget stacks one gap below whatever widget preceded it, whether that widget was itself placed explicitly or by default, and a later `at: next`/`at: right` widget measures from an auto-placed widget's rect the same way it would from an explicitly placed one.

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

`standard edit` supplies the Mac-standard Edit menu items (Undo/Cut/Copy/Paste/Clear) with clipboard behavior already wired to `field` and `textview` widgets — required for a native feel (and for desk accessories) but otherwise pure boilerplate. The behavior comes from the `edit` keyword, not from the menu's own name — a menu declared under a different name could still use `standard edit`. Cut/Copy/Paste/Clear act on whichever `field` or `textview` currently has the caret, dim together when nothing does, and forward to the frontmost desk accessory instead when one is active. Undo is always present but permanently dimmed — there is no undo stack — an honest placeholder for the standard menu shape rather than a working command.

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

**Window-owned menus.** A window declaration may claim menus with `menus: A, B` (Chapter 8). A menu claimed by any window is not part of the application-wide menu bar; it appears, after the application-wide menus and in declaration order, only while a window of a claiming type is frontmost, and leaves the bar when that window closes or another window comes to the front. Menus no window claims form the application-wide bar, exactly as before. Item enabling and window-scoped dimming are unaffected: every menu exists for the whole run, only its presence in the bar changes. At most 31 menus may be declared.

### Runtime Menu-Item Property

`enabled` is a runtime property on a menu item, addressed as `MenuName.ItemName.enabled`, for app-level items that need manual control rather than the automatic window-scoped dimming above:

```rust
File.Save.enabled = false
```

### The Apple Menu

The Apple menu and its About item are provided by the runtime automatically; no declaration is needed. With an `app` section (Chapter 7), the About item reads `About <name>…` and shows the application's name, version, author, about text, and icon. Without one, the About item shows the application's name only.

## Chapter 10: Forms and Tables

### Form Windows

A window with `form for T` (Chapter 8) is a *form window*: its widgets bind to the fields of a value of type `T` rather than being addressed piecemeal by handler code. A `field`, `check`, or `popup` inside such a window declares `binds: name`, where `name` is resolved against `T`'s fields — inside a form window's widget declarations, the record's fields are the innermost scope, so a bare name is written, never a dotted path.

`form for T` requires every field of `T` to be a by-value type (Chapter 3) — the same restriction, and the same build-time error, as `file.save`/`file.load` (Chapter 12) — since the form buffer the `edit` statement copies into and out of (below) is a flat copy.

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

A `popup`'s items always come from its bound enum field — there is no form of `popup` with items given directly. A `popup` declared without `binds:` is rejected at build time.

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

`isNew` is defined only on the parameter of an `accepted` handler; any other use of it is a build-time error. The one exception is a record type that declares its own literal `isNew` field — that field shadows the synthetic one entirely, and behaves as an ordinary field with no special meaning.

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
c.pattern(level: int)          // fill pattern for fillRect/fillCircle
c.width  c.height              // runtime properties, int
```

`clear` erases the canvas to white. `line` draws a line from `(x1, y1)` to `(x2, y2)`. `rect`/`fillRect` draw a rectangle outline or a filled rectangle at `(x, y)` with width `w` and height `h`. `circle`/`fillCircle` draw a circle outline or a filled circle centered at `(x, y)` with radius `r`. `drawText` draws `s` with its baseline at `(x, y)`. `width` and `height` are read-only runtime properties giving the canvas's current size in pixels.

`pattern` sets the canvas's current fill pattern: `level` runs 0 (white) through 8 (black), with 1–7 ordered-dither grays of increasing density; out-of-range values clamp. The pattern applies to `fillRect` and `fillCircle` only — `rect`, `circle`, `line`, `drawText`, and `clear` are unaffected. Each canvas starts at level 8 (black), and the setting persists until changed. Patterns align to the window, not to the filled rectangle, so adjacent fills of any size tile into one seamless dither.

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
| `open` | `c.open("host:port")` — MacTCP, DNS inside; `c.open(appletalk "Name:Type")` — ADSP, NBP inside; `c.open(serial "modem:9600")` — a Mac serial port, `"modem"` or `"printer"`, baud after the colon; `c.open(addr)` — from a browser `address` |
| `send` | `c.send(t: text)` (also accepts string) |
| `close` | `c.close()` |
| events | `opened`, `received(data: text)`, `closed`, `failed(err: error)` |

A `connection` value can be copied like any other value: passed as a function parameter, stored in a record field, held in an array element, or assigned to a local variable, and `open`/`send`/`close` work the same way through any of those (spec §3.2). `on <var>.<event>` handlers are the one exception — they still name a top-level global directly, never an expression, since a handler is bound at compile time. A `connection` that has never been assigned (a fresh local, an unset record field or array element) is `nil`; calling `open`, `send`, or `close` on a nil connection is a runtime error (`use of nil connection`) — a different message than, but the same category of contract violation as, `send`/`close` on a connection that was never opened (`connection not open`). The 4-connection-variable-per-program cap (only global `connection` variables count toward it) still applies.

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

### Serial

`c.open(serial "modem:9600")` opens a Macintosh serial port directly, with no AppleTalk or TCP involved: `"modem"` is the modem port (SCC channel A), `"printer"` is the printer port (channel B), and the baud rate follows the colon. The rate must be one of the Serial Driver's standard values — 300, 600, 1200, 1800, 2400, 3600, 4800, 7200, 9600, 19200, or 57600. Framing is fixed at 8 data bits, no parity, one stop bit, no handshake; any other configuration is out of scope for `connection` and goes through the `toolbox/` catalog instead, the same escape hatch every other 80/20 abstraction in this reference falls back to.

A serial connection's events follow `connection`'s ordinary shape, with these transport-specific rules:

- `opened` fires on the event loop's next pass after a successful open, never synchronously inside `open` itself.
- `received(data: text)` fires once per pass when bytes are waiting; `data` is freshly allocated and binary-safe — no CR/LF translation, every byte value 0-255 passes through unchanged.
- `closed` fires only when the underlying channel itself goes away. A raw Mac serial line has no carrier-detect signal in this release, so `closed` never fires for a serial connection — a transport property, not a missing feature. A local `c.close()` never fires `closed`, on any transport.
- `send` on a connection that was never opened, or has since closed, is a runtime error — a program bug, not an environmental failure. Environmental failures (a bad port spec, a driver I/O error) arrive as `failed(err: error)` instead.

On a command-line host, two environment variables map the ports to TCP for development instead of real hardware: `CLARUS_SERIAL_MODEM` and `CLARUS_SERIAL_PRINTER`, each either `listen:PORT` (open becomes a listening accept) or `connect:HOST:PORT` (open dials out); the baud rate is accepted but ignored. An unset variable makes `open` fail with `failed`, not a crash. This host lane is also where the command-line lifetime rule matters: after `App.startCLI` returns, the program stays alive while any connection remains open or an event is pending, pumping them, and only exits once neither is true — `quit` still works at any point regardless.

Servicing a connection is cooperative: the runtime only drains waiting bytes between event-loop passes, so a handler that runs long starves every open connection's pump, not just its own. The driver's receive buffer is grown to 8KB at open to absorb a burst while a handler runs, but that is headroom, not immunity — a handler blocked for long enough can still overrun it and lose data.

```rust
var conn: connection

on App.startCLI(args: list of string) {
    conn.open(serial "modem:9600")
}

on conn.received(data: text) {
    if data.length > 0 and data[0] == 'Q' {
        quit
    }
    conn.send(data)
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

The `file` namespace covers documents and preferences. Every function but `file.name`, `file.open`, `file.openRF`, `file.create`, and `file.info` returns `bool`; `false` means inspect the global `lastError` (below) for what went wrong — except `file.exists`, whose `false` just means the path doesn't exist, never a failure. `open`/`openRF`/`create` return a `filehandle` (`nil` on failure — see below) instead, for positioned/random-access binary I/O; `info` returns a `FileInfo` record (Chapter 3), zeroed with `lastError` set on failure.

| Function | Signature | Notes |
|---|---|---|
| `readText` | `file.readText(path: string, t: text): bool` | fills `t` in place |
| `writeText` | `file.writeText(path: string, t: text, type: string, creator: string): bool` | writes `t`'s contents to `path`, stamped with `type`/`creator` |
| `save` | `file.save(path: string, data, type: string, creator: string): bool` | `data`: any `record`, `list of` record, or `map of` record; stamped with `type`/`creator` |
| `load` | `file.load(path: string, data): bool` | fills `data` in place |
| `name` | `file.name(path: string): string` | the file's display name; always succeeds |
| `readResource` | `file.readResource(name: string, out: text): bool` | fills `out` from the named resource; Macintosh only |
| `writeRes` | `file.writeRes(path: string, fork: text, doctype: string, creator: string): bool` | writes `fork`'s contents as `path`'s resource fork, stamped with `doctype`/`creator`; Macintosh only |
| `open` | `file.open(path: string): filehandle` | opens an existing file read/write; `nil` + `lastError` if it doesn't exist or can't be opened |
| `openRF` | `file.openRF(path: string): filehandle` | opens an existing file's resource fork read/write; `nil` + `lastError` if the file does not exist |
| `create` | `file.create(path: string, type: string, creator: string): filehandle` | creates the file if missing, truncates it to 0 bytes if it already exists, opens it read/write, stamped with `type`/`creator`; `nil` + `lastError` on failure |
| `exists` | `file.exists(path: string): bool` | `true` for an existing file or folder; never sets `lastError` |
| `info` | `file.info(path: string): FileInfo` | on failure returns a zeroed record and sets `lastError` |
| `makeDir` | `file.makeDir(path: string): bool` | creates one folder; the parent must already exist; an existing folder or file at `path` is a failure (`dupFNErr` / `EEXIST`) |
| `delete` | `file.delete(path: string): bool` | removes a file or an *empty* folder; a non-empty folder is a failure; on the Macintosh an open file is too (`fBsyErr`), while a POSIX host unlinks it |
| `list` | `file.list(path: string, names: list of string): bool` | empties `names`, then appends the leaf name of every file **and** folder directly inside `path`, in catalog order; `""` names the program's own folder; a `path` that is not a folder is a failure; on failure `names` is empty |
| `setInfo` | `file.setInfo(path: string, type: string, creator: string, created: int, modified: int): bool` | restamps an existing file's Finder type/creator and dates; a `0` date means "leave unchanged"; `type`/`creator` follow `writeText`'s four-character rule |
| `rename` | `file.rename(path: string, newName: string): bool` | renames in place; `newName` is a leaf name, not a path -- a `newName` containing `:` fails |
| `move` | `file.move(path: string, dirPath: string): bool` | moves a file or folder into the folder `dirPath`, keeping its name; same volume only (`badMovErr` otherwise) |

`save` and `load` serialize using the field layout already known from the record's declaration (Chapter 3) — no separate schema is written or read.

Every field of the record — transitively, for a `list of` or `map of` payload — must be a by-value type (Chapter 3); a `text`, `list`, or `map` field is a build-time error, since a reference has no meaningful serialized form.

**Binary faithfulness:** `readText` and `writeText` transfer content verbatim, byte for byte — no newline translation, and every byte value 0–255 (including 0) round-trips unchanged. Since a `text` is a byte buffer (Chapter 3), these two functions are also the way to read and write binary data.

**`type`/`creator`:** four-character Finder type/creator codes (the App Section's `app.doctype`/`app.id` constants, above, are the idiomatic values — `file.writeText(p, t, app.doctype, app.id)`; the four `fileType*` constants or any other 4-character `string` also work). There are no defaults: every call spells them out. A `string` literal longer than four characters is a build-time error; a shorter one is space-padded on the right. A *non-literal* `string` longer than four characters fails the whole operation instead (`false` + `lastError`) — the same rule `askOpen`'s filter, below, follows. These literal-length checks run during `clarusc emit`'s lowering pass, not bare check-only mode (`clarusc FILE.cla`) — a program with a bad literal here passes a check-only run and is only rejected when built with `emit`. Stamping happens only when the file is freshly created; writing to an already-existing path leaves that file's type/creator untouched. Double-clicking a document saved this way in the Finder launches the application that wrote it and fires `App.openDocument` with the document's path (Chapter 7).

**`readResource`/`writeRes`:** a minimal pair reserved for resource-fork access — `readResource` fills `out` from a named resource in the current resource chain; `writeRes` writes `fork` verbatim as a *whole file's* resource fork (the data fork is left empty), stamped with `doctype`/`creator` the same way `writeText` stamps a data-fork file. Both are Macintosh-only: on a host build, `readResource` always returns `false` (nothing to fill), and `writeRes` always returns `false` (nothing written) — there is no resource fork on that filesystem. `writeRes`'s `doctype`/`creator` follow the exact same literal-length/padding rule as `writeText`'s `type`/`creator`, above. Ordinary programs have little reason to reach for either function directly; they exist for tools that read or produce Macintosh resource forks.

**Paths.** Every `path` is an HFS path exactly as `file.open` takes one: a bare name (the program's own folder), a partial path with a leading colon (`:FTN:In:x.pkt`), or a full path (`BBS HD:Files:x`). On a host build the same spellings work — `:` separates components, a leading `:` is dropped, and a full path's volume name becomes an ordinary leading directory component. `""` names the program's own folder wherever a folder is accepted, not just `list` — `exists` and `info` treat an empty `path` the same way. `file.list` returns leaf names; a caller re-joins them (`path + ":" + name`, or the bare name when `path` is `""`).

**Host behaviour.** `setInfo`'s `type`/`creator` are accepted and ignored; its `created` is likewise accepted and ignored (POSIX birth time is not settable) — only `modified` actually restamps the file. `info` returns `rsrcSize = 0`, empty `type`/`creator`, `created` from the file's birth time where the host reports one (else its change time). On the Macintosh, `file.info("")` reports only `isDir`; its other fields are zero (a host build reports the folder's real dates). Everything else behaves identically on both lanes.

#### `filehandle`

`readText`/`writeText` and `save`/`load` cover whole-file I/O; `filehandle` (Chapter 3) is the positioned (random-access) counterpart — the way to read or write part of a file without reading or rewriting the whole thing, the shape a small database engine or an append-only log needs. It is a resource kind like `connection`: `nil`-comparable, copyable (a local, a parameter, a return value, a record field, an array/list/map element — anywhere a value type is allowed), `==`/`!=` between two handles compare identity, and its default (never-assigned) value is `nil`. It is **not serializable**: a record with a `filehandle` field is rejected by `save`/`load`'s value-type-fields rule, above, with the same "is not a value type" diagnostic any other reference-typed field gets.

```rust
var f: filehandle = file.open(path)                    // existing file, read/write
var j: filehandle = file.create(path, "VDBJ", "68BB")   // create-or-truncate, read/write
if f == nil { alert(lastError.message) }
```

| Method | Signature | Notes |
|---|---|---|
| `readAt` | `f.readAt(pos: int, count: int, out: text): bool` | positioned read; replaces `out` entirely |
| `writeAt` | `f.writeAt(pos: int, data: text \| string): bool` | positioned write; extends the file past EOF |
| `append` | `f.append(data: text \| string): bool` | writes `data` at the current end of file |
| `size` | `f.size(): int` | the logical end of file, in bytes |
| `setSize` | `f.setSize(n: int): bool` | grows (new bytes zero) or truncates |
| `flush` | `f.flush(): bool` | a durability barrier |
| `close` | `f.close()` | idempotent |

- `readAt(pos, count, out)` reads up to `count` bytes starting at byte offset `pos` into `out`, replacing whatever `out` held. A read that crosses the end of file succeeds with a shorter `out`; a read starting at or past the end of file succeeds with an empty `out` — neither is an error. `readAt` returns `false` + `lastError` only on an actual I/O error. `pos < 0` or `count < 0` is a runtime error.
- `writeAt(pos, data)` writes all of `data` (`text` or `string` — the same either-form `connection.send` accepts) at `pos`. A write that starts past the current end of file extends it (the Mac File Manager's own behavior on write); the gap between the old end of file and `pos`, if any, has unspecified contents on the Macintosh and reads as zero bytes on a host build — a program that cares about the gap's contents should `setSize` first to pin them down. `pos < 0` is a runtime error.
- `append(data)` writes `data` at the file's current end, with no separate `size()` query involved.
- `size()` returns the logical end of file; `-1` + `lastError` on error.
- `setSize(n)` grows or truncates the file to exactly `n` bytes. `n < 0` is a runtime error. Growing reads as zero bytes on a host build; on the Macintosh, the new bytes' contents are unspecified (documented, not guarded — pre-size and overwrite explicitly if a program needs to depend on them).
- `flush()` is a durability barrier: on the Macintosh, `_FlushFile` followed by `_FlushVol`; on a host build, `fsync`. Nothing else in this reference forces bytes to stable storage before the OS gets around to it on its own.
- `close()` is idempotent — closing a `nil` handle is a no-op, and closing an already-closed handle does nothing further. After `close`, every OTHER copy of the same value is stale, with the same hazard a closed C file descriptor has: an operation through it usually fails with `false` + `lastError`, but if the underlying platform has since reused that same handle number for a different file, it silently reaches that different file instead. This is documented, not guarded — a generation counter that could detect it is out of scope for this release. A program that assigns `f = nil` right after `f.close()` protects that one variable; the runtime has no way to reach into a record field, array element, or other copy that also held the same value and clear it too.
- Any method other than `close` called on a `nil` handle is a runtime error (`use of nil filehandle`) — a program bug, the same category as indexing a string out of range, not an environmental failure to inspect `lastError` for.
- `file.openRF(path)` opens the resource fork of an existing file; the returned `filehandle` is identical in every way to `file.open`'s, so a whole-fork read is `f.readAt(0, f.size(), out)` and a fork written alongside an existing data fork is `file.create` (or an existing file), `openRF`, `writeAt`, `close`. On a host build the fork is stored where the host keeps it: on macOS as the file's `com.apple.ResourceFork` attribute (a real fork on APFS/HFS+, an AppleDouble `._name` sidecar on FAT/NFS/SMB volumes — the kernel chooses); on other hosts as that same AppleDouble sidecar beside the file, written on `flush` and `close`. `readResource`/`writeRes` are unchanged.
- Every `filehandle` operation is synchronous: there are no `filehandle` events, and nothing here interacts with the event-loop pump `connection`/`listener`/`serviceBrowser` use.
- No Gestalt gating: every Toolbox trap `filehandle` uses is available on the original 1984 Macintosh File Manager (System 6-era), so there is no fallback path to document.

### Dialogs

Four built-in dialogs cover file selection and quit confirmation. As Chapter 6 notes, these fill the string arguments passed to them using a runtime calling convention available only to built-ins, not to user-declared functions:

- `alert(msg: string)` — shows `msg` in a standard alert with an OK button. On the Macintosh, this always shows a real dialog now (the attempt-abort phase closed a native-lane bug where `alert` had been silently headless — no dialog, message dropped — since `alert` needed a real, immediately-flushed alert path to make the top-level abort default's own beep-then-alert-then-quit sequence actually visible; fixing that also fixed every other `alert(...)` call site on that lane, not just abort-triggered ones).
- `askOpen(path: string, types: string): bool` — Standard File "Open" dialog; fills `path` and returns `true`, or returns `false` on Cancel. `types` is a comma-separated list of up to four four-character type codes (`"TEXT,PICT"`), or `"*"` for every file regardless of type — the idiomatic single-type call is `askOpen(p, app.doctype)`. The same padding/length rule as `writeText`'s `type`/`creator` applies to each code; a *literal* filter with more than four entries, or a literal entry longer than four characters, is a build-time error, and a non-literal filter that breaks the same rule fails the call outright (`false` + `lastError`, dialog never opens).
- `askSave(path: string, suggested: string): bool` — Standard File "Save" dialog, pre-filled with `suggested`; fills `path` and returns `true`, or returns `false` on Cancel.
- `askSaveChanges(name: string): saveChoice` — the standard three-way "Save changes to “name”?" dialog; returns `Save`, `Discard`, or `Cancel` (Chapter 3).

### Logging

`log(msg: string)` writes a diagnostic line to the platform's diagnostic stream: on a command-line host, standard error; on the Macintosh, a destination reserved for a later release (a log file or debugging window) — programs use it identically either way. Diagnostics belong in `log`; user-facing output belongs in `alert` or files.

A program that declares `on App.log(line: string)` (Chapter 7) also receives every one of these lines as an event, after it has reached the stream — the way to put a program's own diagnostics on screen, into a file, or anywhere else, without changing a single `log(...)` call site.

### Date and Time

A datetime is a plain `int`: seconds since the Mac epoch — January 1, 1904, 00:00:00, **local time** — the same raw value the Macintosh clock (the low-memory `Time` global) stores, and the same value the Toolbox uses for file dates. The count is unsigned at the Toolbox level (it wraps on February 6, 2040) and crossed 2³¹ back in 1972, so every contemporary clock reading is *negative* when held in an `int`. This is safe by construction: differences and orderings among real clock values behave correctly (see below), and calendar decomposition is performed by the Toolbox — never by Clarus arithmetic.

- `now(): int` — the current datetime. On the Macintosh this reads the `Time` global the one-second interrupt maintains (the exact read `GetDateTime` performs); on a command-line host it derives the same local-time value from the host clock.
- `dateTimeStr(t: int): string` — formats `t` as `"mm-dd-yy HH:MM:SS"`: zero-padded fields, 24-hour clock, two-digit year.
- `durationStr(secs: int): string` — formats a span of seconds as `"1h 0m 5s"`, `"30m 5s"`, `"45s"`, `"0s"`: units above the highest nonzero unit are omitted, seconds always appear, and a negative span is `"-"` followed by the absolute span's form.

The difference between two datetimes is plain subtraction — `b - a` is the span in seconds, correct even across the 2³¹ boundary (two's-complement subtraction is modulo 2³²). Ordering comparisons are likewise correct for any two values in the 1972–2040 range (both sit in the same signed half); only comparing a pre-1972 constant against a modern reading misorders. There is no time-zone API: the classic Mac OS keeps its clock in local time (GMT offset is an opt-in Map-control-panel hint the OS itself never applies), and Clarus follows the platform. For calendar-field access or date arithmetic beyond subtraction, use the Date-Time Utilities in `toolbox/osutils.cla` (`DateTimeRec`, `SecondsToDate`, `DateToSeconds`).

### Errors

An `error` (Chapter 3) is the record `{ code: int, message: string }`. The global `lastError: error` holds the detail behind the most recent soft failure: a `false` return from a `file` function, or a clamped string store or byte copy (Chapters 3 and 4).

Clarus reports failures in five ways, depending on where they occur:

- **Async failures** — a `connection`, `listener`, or `serviceBrowser` operation that fails after it's already underway — are delivered as a `failed(err: error)` event on that resource (above).
- **Synchronous fallible operations** — the `file` functions return `bool`; on `false`, inspect `lastError`. String stores and byte copies that must truncate (Chapters 3 and 4) clamp safely, set `lastError`, and continue.
- **Out of memory** shows a clean alert and quits, rather than continuing on a corrupted heap.
- **Runtime errors** — dereferencing a `nil` window reference, indexing or slicing a string, text, array, or list out of range, taking from an empty list, accessing a map with a key that doesn't exist (`[]` form, not `get`), a checked enum conversion with no matching member, or a shift count outside 0–31 (Chapter 3, Chapter 4) — show an alert naming the handler in which the error occurred. The app then continues if that's safe, or quits if it isn't. These are unrelated to `attempt`/`abort` (below) and are never caught by an `attempt`.
- **Program-defined failures** — `attempt { } aborted msg { }` and `abort(expr)` (Chapter 5) are a program's own cooperative, non-local error signal: a function calls `abort` with a message, and the dynamically innermost `attempt` whose body is currently running catches it — resolved per frame at compile time from the call site up the chain that led to the `abort`, with every intervening frame's locals released on the way — no exceptions object and no runtime handler stack, just one pending-message value and a compile-time-resolved unwind target. An `abort` with no enclosing `attempt` reaches a top-level default: a command-line program logs the message and exits 1 (identical to a bare `log`+`quit 1`); a GUI program beeps, shows the message in a standard alert, and quits 1.

## Chapter 13: Low-Level Memory Access

Clarus's built-in types and checked operations (Chapters 3–12) cover ordinary application logic. Some platform runtime calls and driver-level protocols need raw memory addresses instead — a `ptr` type, `peek`/`poke` byte-level access, and `external func` declarations exist for exactly that, and nowhere else. Code using them opts out of the safety guarantees the rest of the language provides; use them only at the boundary with the platform.

### The `ptr` Type

A `ptr` is an untyped machine address — 32 bits on the target Macintosh; host builds may use a wider native representation, and a program must never assume a specific size. The zero value of `ptr` is the null address; there is no `nil` literal for `ptr` (`nil`, Chapter 3, is reserved for window/resource references) — test for null by comparing against `ptr(0)`.

A `ptr` is produced by calling an `external func` that returns one (below), or by converting an `int` with `ptr(intExpr)`. Converting back to `int` is equally explicit, with `int(ptrExpr)`. Neither conversion is implicit. `p + n` and `p - n`, where `n` is an `int`, add or subtract `n` bytes from the address `p` and yield a `ptr`; `==`, `!=`, `<`, `<=`, `>`, and `>=` compare two `ptr` values as addresses:

```rust
var p: ptr = ptr(4096)
var addr: int = int(p)
var isNull: bool = p == ptr(0)
var next: ptr = p + 16
var inRange: bool = next > p and next <= p + 256
```

A `ptr` may be used wherever an ordinary by-value type can — as a variable, function parameter, function return type, or record field. It may not be a container element: `list of ptr`, `map of ptr`, and `T[n]` of `ptr` are all build-time errors, since a raw address carries none of the bookkeeping a container's element type needs:

```rust
var p: ptr = ptr(0)
// var addrs: list of ptr        // build-time error: ptr not allowed as container element
```

Like the other inline scalar types (`int`, `bool`, `fixed`, `char`), a `ptr` is copied by value on assignment and return; its zero value is a plain null address, and it is never retained or released the way a `text`, `list`, `map`, or window reference is.

### `peek` and `poke`

`peekb`, `peekw`, and `peekl` read 1, 2, and 4 bytes at address `p` respectively, returning an `int` (the 1- and 2-byte forms zero-extend). `pokeb`, `pokew`, and `pokel` write the low 1, 2, or 4 bytes of `v` to address `p`:

| Function | Signature | Reads/writes |
|---|---|---|
| `peekb` | `peekb(p: ptr): int` | 1 byte, zero-extended |
| `peekw` | `peekw(p: ptr): int` | 2 bytes, zero-extended |
| `peekl` | `peekl(p: ptr): int` | 4 bytes |
| `pokeb` | `pokeb(p: ptr, v: int)` | low byte of `v` |
| `pokew` | `pokew(p: ptr, v: int)` | low 2 bytes of `v` |
| `pokel` | `pokel(p: ptr, v: int)` | low 4 bytes of `v` |

```rust
var p: ptr = ptr(4096)
var lo: int = peekb(p)
var word: int = peekw(p + 2)
pokeb(p, 0xFF)
pokel(p + 4, 0x12345678)
```

Multi-byte reads and writes use the machine's native byte order — big-endian on the 68k target. `peekw`/`peekl`/`pokew`/`pokel` are for values already resident in memory in native order (a Toolbox struct field, a register image); they are never the right tool for a byte layout that leaves the process (a network packet, a saved file) — build that layout with explicit `peekb`/`pokeb` calls, one byte at a time, the same way `string.fromBytes`/`toBytes` (Chapter 3) do.

Out-of-bounds access through `peek`/`poke` is undefined behavior — there is no bounds check, and none is possible for a raw address. This is the one corner of Clarus that is not memory-safe; every other builtin in the language (Chapters 3–12) is.

### `external func`

An `external func` declares a function implemented by the platform runtime rather than by Clarus source — a Toolbox call, a runtime helper, anything reachable only as a raw entry point:

```rust
external func GetTicks(): int
external func HLock(p: ptr)

func ticksSince(start: int): int {
    return GetTicks() - start
}
```

`external func` is a top-level declaration and may appear anywhere among a program's top-level declarations, like `record`, `func`, or `const`. It has no body — the form above, ending at the parameter list and optional return type, is complete. Return types are restricted to `int`, `ptr`, `bool`, and `char`; the return type may be omitted for a function with no result. Parameter types additionally allow `str` and `text`: a `str` parameter is marshalled as the address of the caller's Str255, borrowed for the call; a `text` parameter is passed as the underlying box pointer, likewise borrowed — the callee must not store either beyond the call. `word` (below, alongside the trap/inline clauses it exists for) is also accepted in either position — an `int`-compatible 16-bit-at-the-boundary type, not a fifth independent scalar. A call to an `external func` is an ordinary call expression or call statement, indistinguishable at the call site from a call to a Clarus-defined function — `GetTicks()` above is called exactly like any other zero-argument function returning `int`.

An `external func` may optionally name how its entry point is reached, with a trailing `= trap ...` or `= inline ...` clause — see Trap and Inline Clauses, below.

### Overlay Records

An `overlay record` declares a named view over raw memory: its fields describe a byte layout at some address, the same way `record` describes a value's fields — but an overlay value IS that address, not a copy of the bytes there. `overlay` is contextual, recognized only immediately before `record`; elsewhere it is an ordinary identifier.

```rust
overlay record RtHdr {
    rc: int
    data: ptr
}

func f(p: ptr) {
    var h: RtHdr = RtHdr(p)
    var n: int = h.rc
    h.rc = 5
    h.data = p
    var back: ptr = ptr(h)
    var same: bool = h == RtHdr(p)
}
```

Field types are restricted to `int`, `bool`, `char`, `fixed`, and `ptr` — the same by-value scalars `peek`/`poke` (above) read and write, since an overlay field's offset and width must be exactly one of those. An overlay field may not have a default value: its value lives at whatever address the overlay currently names, so there is nothing for a per-declaration default to initialize.

An overlay value is produced from a `ptr` by calling the overlay type as a conversion, `Name(p)`, and converted back with `ptr(o)`; neither conversion is implicit, matching `ptr`'s own conversions. There is no `new OverlayName` — an overlay is never allocated, only obtained by converting an existing address.

Reading a field (`h.rc`) or writing one (`h.rc = 5`) reads or writes through the address `h` currently holds — the overlay's declared layout is just a name for those offsets. Assignment between overlay-typed values (`h = RtHdr(p)`) copies the address, not the bytes it points to; `==` and `!=` compare the two addresses, the same rules `ptr` follows.

An overlay type may be used as a variable, function parameter, function return type, or comparison operand — anywhere an ordinary by-value type can. It may not be a container element, a field of another `record` or `overlay record`, the subject of `file.save`/`file.load`, a `form for` record, or a `for`-loop subject:

```rust
// var xs: list of RtHdr       // build-time error: overlay records cannot be container elements
// record Wrapper { h: RtHdr } // build-time error: overlay records cannot be record fields
```

Like `ptr`, an overlay value is copied by value, its zero value is a plain null address, and it is never retained or released — an overlay is a view, not an owner, of whatever it points to.

### `extern record`

An `extern record` declares a Mac-packed-layout struct transcribed straight from an Inside Macintosh struct diagram — `EventRecord`, `Point`, `SFReply`, and the like. `extern` is contextual, recognized only immediately before `record`; elsewhere it is an ordinary identifier:

```rust
extern record Point {
    v: word
    h: word
}

extern record EventRecord {
    what: word
    message: int
    when: int
    where: Point
    modifiers: word
}

extern record SFReply {
    good: bool
    copy: bool
    fType: int
    vRefNum: word
    version: word
    fName: str[63]
}
```

Unlike `overlay record` (a named VIEW over memory some other pointer owns), an `extern record` is a **storage kind** of its own, like `int` or `char[N]`: declaring one as a local or global `var` reserves the record's packed size in bytes, directly, zero-initialized — there is no address to convert from or to, and no `Name(p)` conversion exists for it.

Field access (`ev.what`, `ev.where.v`) reads and writes at the record's packed byte offsets, as ordinary scalar expressions and assignment targets. There are no whole-record operations: no assignment (`ev2 = ev`), no comparison, and an extern record is never a function parameter or return type, an ordinary `record` field, or a container element — any of these can be added later if a real Inside Macintosh use case demands it, but none does today.

The one way to take an extern record's address is **decay at an `external func` call site**: passing an extern-record variable, or a nested extern-record field lvalue (`ev.where`), where the callee's parameter is declared `ptr` passes that field's address. No general address-of operator exists in the language. A **4-byte** extern record (variable or field) may additionally pass where an extern parameter is declared `int` — the classic Inside Macintosh Point-by-value idiom (`FindWindow(where, ...)`, `where: Point`, passed as a `long`); any other size in an `int` position is an error.

### Field Palette

| Clarus field type | bytes | alignment | notes |
|---|---|---|---|
| `bool` | 1 | 1 | Pascal `Boolean` |
| `byte` | 1 | 1 | new contextual field-type name, unsigned byte (`SignedByte`/`Byte`); reads/writes as `int`, zero-extended |
| `word` | 2 | 2 | `INTEGER`; reads back sign-extended (same as extern `word`) |
| `int` | 4 | 2 | `LONGINT`/`OSType`/`Fixed` — 68k packs longs at 2 |
| `ptr` | 4 | 2 | `Ptr`/`Handle`/`ProcPtr` fields |
| nested `extern record` | its size | 2 | `Point` in `EventRecord`; nesting depth unbounded |
| `str[N]` (1 ≤ N ≤ 255) | N+1 | 1 | Pascal string buffer (`Str63` = `str[63]`): length byte + N bytes. Reads as `string` (copy out), assigns from `string` (truncating at N, length byte updated) |
| `pad[N]` (N ≥ 1) | N | 1 | reserved/unused byte runs (`ParamBlockRec` filler); not readable or writable, occupies layout only, needs no field name — `pad[4]` alone is a complete field line |

Total record size rounds up to even. Field offsets follow the classic MPW 68k packing rule exactly: each field aligned per the table above, no other padding inserted. `byte` and `pad` are contextual field-type names recognized ONLY inside an `extern record` body, the same way `word` is contextual only in an `external func` signature — elsewhere (a `var` declaration, an ordinary `record` field) they are ordinary identifiers. `pad` additionally has no named form: a field written `name: pad[N]` does NOT declare a pad run — "pad" is recognized only as a bare field line's own leading token, never after `name:`, so `name: pad[N]` instead falls through to the ordinary `type[N]` array-length grammar (an array of a nested type named `pad`), which is not itself in the palette and so is rejected with the same "extern record field type must be bool, byte, word, int, ptr, str[N], pad[N], or an extern record" diagnostic any other non-palette field type gets. `fixed`-typed fields are not supported in this phase (add on demand — `Fixed` transcribes as `int` and converts via the existing fixed conversions).

**Ordinary `record` packing:** the same discipline governs an ordinary `record`'s (Chapter 3) own field layout, independently of the palette above: `bool` and `char` fields pack at 1-byte alignment — their exact 1-byte size, no padding before or after, in an ordinary record or a fixed array alike; `bool` keeps that same 1-byte packing inside an `extern record` too, but `char` is excluded from the extern-record palette entirely (not a legal field type there — an extern record's 1-byte numeric field type is `byte`, above). Every other ordinary-record field kind (`int`, `fixed`, `string(n)`, enum, nested `record`, `T[n]`, `text`, `list of T`, `map of T`, window and resource references) packs at 2-byte alignment (a degenerate 1-byte `T[n]` — `bool[1]`/`char[1]` — packs at 1-byte alignment instead, same as a bare `bool`/`char` field), in declaration order: a 2-byte-aligned field is padded up to the next even offset when the fields before it left an odd running size, and the record's total size is rounded up to even the same way. A `string(n)` field additionally occupies its even-rounded size — n+1 rounded up to even bytes — so the field after it starts on an even offset on every lane. A fixed array's elements follow the identical rule at element granularity — `bool[n]`/`char[n]` elements sit at stride 1, tightly packed with no inter-element padding, while every other element kind keeps its own natural stride. Both code generators (`cg68k` and the host-C `cprint` lane) implement this rule for `bool`/`char` (small-scalar-width phase) and for `string(n)` fields' 2-byte alignment and even-rounded size (strn-field-alignment phase, 2026-08-06 — the C lane realizes it with explicit pad members and an even-padded `clar_str_n` typedef), so the two lanes' record layouts coincide for those kinds; per-lane layouts are still never interchangeable — a native-computed field offset is never valid against a host build's struct, or vice versa, since each lane computes its own independently.

Multi-byte fields read and write in the machine's native byte order — the same `peekw`/`peekl`/`pokew`/`pokel` contract Chapter 13's `peek`/`poke` section already documents: big-endian on the 68k target, host-endian on a host build. An `extern record` is all-scalar storage, structurally outside automatic reference counting — never retained or released, the same as an overlay record or a plain `ptr`.

A field read/write, and the decay/coercion at an `external func` call site, in context (`UiWaitNextEvent` is a Toolbox trap and `handleAt` an ordinary function, both declared elsewhere in the program):

```rust
func waitClick() {
    var ev: EventRecord
    while UiWaitNextEvent(0xFFFF, ev, 10, ptr(0)) == 0 { }
    handleAt(ev.where.v, ev.where.h)
}
```

Like `overlay record`, an `extern record` rejects the same handful of whole-value uses:

```rust
// var e2: EventRecord = ev          // build-time error: extern records cannot be assigned
// record Wrapper { e: EventRecord } // build-time error: extern records cannot be record fields
// var xs: list of EventRecord       // build-time error: extern records cannot be container elements
```

### Transcribing Inside Macintosh Declarations

This is the normative mapping from Inside Macintosh's own type vocabulary to the Clarus types used above to transcribe a Toolbox or OS declaration as `extern record`, `external func`, and `callback func`. Where a row's mechanics are documented elsewhere in this chapter, the row cross-references that section instead of restating it.

| Inside Macintosh | Clarus |
|---|---|
| `INTEGER` / `OSErr` | `word` — `external func` parameter/result (The `word` Extern Type, below) or extern-record field (Field Palette, above) |
| `LONGINT` / `OSType` / `Fixed` | `int` |
| `Boolean` | `bool` — 1 byte in every aggregate; word-marshaled into the high byte at the pascal trap boundary (Trap and Inline Clauses, below) |
| `CHAR` (a CharParameter) | `word` — **never** `char`. A CHAR parameter is a plain 16-bit `INTEGER` with the character code in the low byte; Clarus's `char` extern shape instead pads its value into the word's high byte, the same convention `bool` uses (Trap and Inline Clauses, below). Declaring a CHAR parameter `char` silently reads and writes the wrong byte at the trap boundary — the MenuKey lesson. |
| `SignedByte` / `Byte` | `byte` — extern-record field only (Field Palette, above) |
| `Str255` / `StrN` | `str` parameter, the caller's Str255 address borrowed for the call (`external func`, above), or `str[N]` extern-record field (Field Palette, above) |
| `VAR` parameter | `ptr` — an extern-record variable or field lvalue decays to its address at the call site (`extern record`, above) |
| `Point` passed by value | a 4-byte extern record passed where the callee declares an `int` parameter (`extern record`, above) |
| `Ptr` / `Handle` / `ProcPtr` | `ptr` |
| a `ProcPtr` parameter you implement (an LDEF, action procedure, filter, or other Toolbox callback) | `callback func` (below) |

A trap word's bit 11 (`trap & 0x0800`) is the normative test for which calling convention a `= trap` clause must declare: set means the Toolbox/Pascal convention (plain `trap NNNN`, or `trap NNNN sel SELECTOR` for a selector-dispatched routine); clear means the OS/register convention (`trap NNNN reg ...`, below). `TickCount`'s trap word is `0xA975`; bit 11 is set (`0xA975 & 0x0800 == 0x0800`), so it takes the plain convention, `trap 0xA975`, with no `reg` clause. `BlockMoveData`'s trap word is `0xA22E`; bit 11 is clear (`0xA22E & 0x0800 == 0`), so it takes the register convention, `trap 0xA22E reg`. An Inside Macintosh trap listing's own hex trap word settles the convention without relying on the surrounding prose. Two catalogued exceptions exist: `_SecondsToDate` (`0xA9C6`) and `_DateToSeconds` (`0xA9C7`) carry Toolbox-range trap words yet are register-based (Apple's own `DateTimeUtils.a` gives `secs => D0, d => A0`; Inside Macintosh II documents both as register-based), so their declarations use `reg` despite bit 11 being set — the bit-11 test is the rule, these two are the known exceptions. Both, plus `ReadDateTime`, have host C twins, so a host build that calls them links.

### `callback func`

A `callback func` declares an ordinary Clarus function the Toolbox itself calls back through, via compiler-generated pascal-convention glue — a List Manager LDEF, a control's action procedure, a dialog filter, or any other Inside Macintosh entry point that expects a raw function pointer. `callback` is contextual, recognized only immediately before `func`; elsewhere it is an ordinary identifier. A `callback func` is a top-level declaration only — one may not be nested inside another function.

```rust
external func UiTrackControl(ctl: ptr, startPt: int, action: ptr): word

callback func myAction(ctl: ptr, part: word) {
    var offset: int = part
}

func track(ctl: ptr, startPt: int) {
    UiTrackControl(ctl, startPt, myAction)
    myAction(ctl, 1)
}
```

A callback's parameter and return types are restricted to `bool`, `char`, `word`, `int`, and `ptr` — the same by-value scalars a pascal-convention `external func` already marshals (no `str`/`text`, records, or containers; no defaults). The compiler generates the glue that reads each argument at its fixed pascal-convention stack offset and writes the result back the same way, following the marshaling rule the trap clause above already documents: a `word` sign-extends, and `bool`/`char` occupy a full word but live in its high byte. A callback's own BODY is ordinary Clarus code with no awareness of that boundary at all — the glue is entirely compiler-generated, never hand-written.

The bare name of a callback decays to its glue's address only where an `external func` parameter is declared `ptr` — `myAction` passed to `UiTrackControl`'s `action` parameter, above. A callback name used anywhere else — a variable initializer, a non-`ptr` or non-extern argument, a return value, a container element — is a build-time error. A callback may also be called directly, like any ordinary function (`myAction(ctl, 1)`, above); a direct call bypasses the glue entirely and runs the body straight, since underneath a callback's body is nothing but an ordinary Clarus function.

```rust
// var f: ptr = myAction                  // build-time error: callback function name can only be passed to an external function ptr parameter
// track(myAction, 0)                     // build-time error: same rule -- track's own params are ptr/int, not an external func
// UiTrackControl(ctl, startPt, myAction) // ok -- action is an external func's ptr parameter: decays to the glue's address
// myAction(ctl, 1)                       // ok -- ordinary direct call, bypasses the glue
```

A callback whose address is never taken (no decay anywhere in the program) and which is never called directly is unreachable, and the compiler drops it entirely — glue and body both — the same tree-shaking every other unused function already gets.

Interrupt-time completion routines (VBL tasks, asynchronous completion procedures, Time Manager tasks) are out of scope: the A5-world and allocation restrictions those contexts impose are not something this language can make safe yet. A `callback func` should only be handed to a Toolbox routine that invokes it at ordinary application-level call time (an LDEF, an action procedure, a dialog filter, and the like), never one that fires from an interrupt.

**Interaction with `attempt`/`abort`.** See Chapter 5's own note on this: an `abort` that fires while control is inside a callback the Toolbox itself invoked cannot propagate past that boundary the normal way. The callback returns a default value to the Toolbox as if nothing happened, the Toolbox's own call completes normally, and the pending abort resumes propagating from the next ordinary checked call site after that external call returns. No code in the callback's own body needs to account for this.

### Trap and Inline Clauses

An `external func` declaration may end with a clause tying it to a specific Toolbox entry point, instead of leaving name resolution to the toolchain:

```
externDecl = "external" "func" IDENT "(" [ params ] ")" [ ":" type ]
             [ "=" ( "trap" ( INT | HEXINT ) [ "sel" ( INT | HEXINT ) | "seld0" ( INT | HEXINT ) | regClause ]
                   | "inline" ( "deref" | "nop" | "a5" )
                   | "ptr" ) ] ;
regClause = "reg" [ "(" regBind { "," regBind } ")" ] [ "memerr" ] [ "ret" REG ] ;
regBind   = REG ":" IDENT ;   // REG in { d0, d1, d2, a0, a1 }, lowercase
```

`= trap NNNN` names the Toolbox trap word — an unsigned 16-bit A-line value, always in `0xA000`–`0xAFFF` — the runtime dispatches to using the ordinary Pascal calling convention (arguments pushed left to right, result returned in the caller-reserved stack slot the call pops after the trap — the same slot a real Pascal trap always writes its result to; D0 is not the calling convention's result location, it is only where the compiled code lands the value after popping that slot):

```rust
external func TickCount(): int = trap 0xA975
```

A `bool` or `char` parameter or result under the plain `trap` clause still occupies a full 16-bit stack word — Pascal never packs sub-word arguments — but the value itself lives in that word's HIGH-order byte (the word's own, lowest, address), not its low byte: pushing a `bool`/`char` argument shifts the value up 8 bits before the word push, and reading a `bool`/`char` result shifts the popped word down 8 bits before use. This is normative and empirically verified (native-5e Task 12, against a real ROM trap and a real Toolbox struct field on Mini vMac hardware) — an earlier (5d-era) low-byte claim for this same convention was wrong and is superseded by this paragraph. `word` (below) parameters and results are unaffected: a `word` is a genuine 16-bit value, not a narrower value padded into a word, so it always occupies the word's full span with no shift.

Appending `reg` selects the register calling convention some traps use instead, in either of two forms. The POSITIONAL form (below) assigns registers by declaration order; a NAMED form (further below) binds each register to a parameter explicitly.

At most two `ptr` parameters, passed in A0 then A1 (declaration order), and at most two `int`/`bool`/`char`/`word` parameters, passed in D0 then D1 (declaration order) — a third parameter of either kind, or any `str`/`text` parameter, is an error, since none of those has a register slot under `reg`:

```rust
external func BlockMove(src: ptr, dst: ptr, count: int) = trap 0xA02E reg
```

`reg` assumes the trap leaves a meaningful result in D0. Some register-convention Toolbox routines are Pascal `PROCEDURE`s (no result at all) whose real error code instead lives in the well-known low-memory global `MemErr` ($0220) — `SetHandleSize`, `SetPtrSize`, and their kin, per Inside Macintosh's own Memory Manager chapter. `reg memerr` names that shape: the call marshals exactly like plain `reg`, but the declared return value is read back from `MemErr` after the trap (sign-extended, like any other Toolbox `OSErr`/`INTEGER`) instead of from D0:

```rust
external func SetHandleSize(h: ptr, newSize: int): int = trap 0xA024 reg memerr
```

`reg` also accepts a NAMED form, `reg( REG: paramName, ... )`, binding each register explicitly to one declared parameter by name instead of assigning by position. Register names are contextual identifiers (like `reg` itself), lowercase only, drawn from the closed set `d0 d1 d2 a0 a1` — matching the listing printer's own lowercase spelling; any other spelling, including `d3` or `a5`, is an error (`a5`/`a6`/`a7` are the globals base, frame, and stack registers, never available here). Every declared parameter must be bound exactly once, every bound name must name a real parameter, and no register may be bound twice; unlike the positional form above, the named form has no 2+2 count limit — it is bounded only by the register table itself. Parameter types are the same set the positional form accepts (`int`, `bool`, `char`, `word`, `ptr`; `str`/`text` remain rejected):

```rust
external func PostEvent(eventNum: word, eventMsg: int): word =
    trap 0xA02F reg(a0: eventNum, d0: eventMsg) ret d0
```

An optional trailing `ret REG` names the result register, for either form of `reg`; omitted, the default is today's rule — `A0` for a `ptr` result, `D0` otherwise. `ret` on a `void` extern (no declared return type) is an error, and `ret` is mutually exclusive with `memerr` (which already names the result's source — the low-memory global, not a register). Reading the result from whichever register, named or defaulted: an `int` or `ptr` result uses its full 32 bits; a `word` result reads its low 16 bits, SIGN-extended (Toolbox `INTEGER`/`OSErr`); a `bool` or `char` result reads its low byte, zero-extended — see the `word` correction just below.

Some Toolbox packages share a single trap word across many routines, distinguished by a selector word the caller pushes immediately before the trap — the List Manager's `LNew`/`LDispose`/`LAddRow`/etc. all dispatch through the one trap `0xA9E7` this way. `trap NNNN sel SELECTOR` names that shape: `SELECTOR` (an unsigned 16-bit value, decimal or hex) is pushed as one more Pascal-convention stack word, closest to the trap itself, after every declared argument — the trap dispatcher pops it along with the rest, so no separate caller cleanup is needed. `sel` and `reg` are mutually exclusive — a selector-dispatch trap is always Pascal-convention:

```rust
external func LAddRow(count: word, rowNum: word, lHandle: ptr): word = trap 0xA9E7 sel 0x0008
```

Some other Toolbox managers share a single trap word the same way, but distinguish the routine by PRELOADING the selector into D0 instead of pushing it — the AppleEvent Manager's own trap `0xA816` (every `AE*` routine) is the working example. `trap NNNN seld0 SELECTOR` names that shape: the selector is moved into D0 immediately before the trap, after every declared argument has already been pushed — no extra stack word, so no extra cleanup either. `seld0` and `sel` are two different selector-dispatch shapes for two different trap families; a routine's own Inside Macintosh/Universal-Interfaces `THREEWORDINLINE` encoding says which — `0x3F3C` (`MOVE.W #selector,-(SP)`) is `sel`, `0x303C` (`MOVE.W #selector,D0`) is `seld0`. Like `sel`, `seld0` is mutually exclusive with `reg` (`external func AEInstallEventHandler(theAEEventClass: int, theAEEventID: int, handler: ptr, handlerRefcon: int, isSysHandler: bool): word = trap 0xA816 seld0 0x091F`, toolbox/appleevents.cla).

`= inline deref`, `= inline nop`, and `= inline a5` name no trap at all — they mark the external as a compiler-known intrinsic, expanded at the call site instead of dispatched through a trap number. `inline deref` requires the signature `(ptr): ptr` exactly, reading the pointer stored at its argument address (the common master-pointer-to-object-pointer step of following a Handle):

```rust
external func HandleToPtr(h: ptr): ptr = inline deref
```

`inline nop` requires no return type; it compiles to nothing, useful for a platform hook that some builds need to declare but never call:

```rust
external func DebugBreak() = inline nop
```

`inline a5` requires zero parameters and a `ptr` return; it reads the current value of the 68k A5 register — the classic Mac OS application-globals base pointer, valid for the lifetime of the running application (not a call-specific value, so there is nothing to marshal):

```rust
external func CurrentA5(): ptr = inline a5
```

Two `external func` declarations sharing a name are legal if and only if they are IDENTICAL: the same parameter list (types and order; parameter names may differ), the same return type, and the same trap/inline clause in full — trap word, `sel`, calling convention, every register binding, `memerr`, and `ret`. The checker merges an identical repeat into the first declaration; every call site resolves to that one entry, and no diagnostic is raised. Any other kind of same-name mismatch is a compile error naming both declaration sites. This is the same accommodation a C header gives a repeated `extern` prototype: a program can redeclare a trap the runtime already declares — transcribed independently from the same Inside Macintosh page — without a spurious redeclaration error:

```rust
external func TickCount(): int = trap 0xA975
external func TickCount(): int = trap 0xA975
```

### The `ptr` Clause

`= ptr` names no trap and no compiler intrinsic; it calls through a pointer the program already holds at run time — a loaded code resource, a `ProcPtr` handed back from the Toolbox, any machine-code entry point reachable only by value rather than by a fixed trap number. The declaration's first parameter is the call target: it must exist and must be declared `ptr`, and it is consumed as the jump address rather than pushed as an argument — a zero-parameter `= ptr` declaration, or one whose first parameter is any other type, is a compile-time error (`= ptr requires a first parameter of type ptr`):

```rust
external func PluginMain(entry: ptr, verb: word, param: ptr): int = ptr
```

Every parameter after the target, and the return type, follow the plain pascal `trap` clause's own marshalling rules exactly (Trap and Inline Clauses, above) — the same type sets (`int`/`ptr`/`bool`/`char`/`word`/`str`/`text` parameters; `int`/`ptr`/`bool`/`char`/`word`, or no return type), the same high-byte `bool`/`char` convention, the same borrowed-address treatment for `str`/`text`. A `= ptr` declaration with no parameters besides the target is fine — the call still marshals a target and nothing else.

`ptr` takes no suffix: none of `sel`, `seld0`, `reg`, `memerr`, or `ret` may follow it — those all modify a `trap` clause's dispatch or calling convention, and `= ptr` is Pascal-convention-only with no trap word to select and no convention to override. The grammar itself has no production for a suffix in that position, so writing one is a plain parse error, not a checked diagnostic the way an incompatible `reg`/`sel` combination under `trap` is.

The redeclaration-merge rule (above) applies unchanged, with `= ptr` counted as the clause for the identity check: two `external func` declarations sharing a name merge if and only if every part matches, including the clause, so two identical `= ptr` declarations merge silently, and a `= ptr` declaration conflicting with a `= trap`/`= inline` declaration (or a differently-shaped `= ptr` declaration) of the same name is a compile error naming both sites.

A `callback func`'s bare name is a valid argument for a `= ptr` call's target parameter, needing no rule of its own: the target parameter is an ordinary `external func` `ptr` parameter, and a callback's bare name already decays to its glue's address in exactly that position (`callback func`, above). Calling a callback's own glue through `= ptr` — rather than through the Toolbox routine the callback was written for — is a legitimate use the existing decay rule already covers, not a special case the compiler has to recognize.

A nil or garbage target is the caller's problem: `= ptr` performs no runtime check on the pointer before jumping through it, the same unchecked contract every other raw `ptr` value already carries in this language. Getting the target right — a locked, non-purged handle dereferenced down to a real code address — is entirely on the code that built it.

Interrupt-time entry points are out of scope, for the same reason `callback func` excludes them (above): the A5-world and allocation restrictions VBL tasks, asynchronous completion procedures, and Time Manager tasks impose are not something this language can make safe yet. Call through `= ptr` only at ordinary application-level call time, never from a routine that fires from an interrupt.

The declaration is a calling contract, not a binding: nothing in it ties the call to any one pointer, so the same declaration serves every call site regardless of which handle produced the target — a different `code` value at every call is the ordinary case, not an exception:

```rust
external func HLock(h: ptr) = trap 0xA029 reg               // toolbox/memory.cla
external func HandleToPtr(h: ptr): ptr = inline deref
external func PluginMain(entry: ptr, verb: word, param: ptr): int = ptr

// h: ptr — a resource Handle from GetResource, e.g. GetResource('PLUG', 128)
// pb: ptr — a parameter block the plugin's caller has already built
func callPlugin(h: ptr, pb: ptr): int {
    var code: ptr
    HLock(h)                            // pin it: it can't move or be purged while code runs
    code = HandleToPtr(h)               // master pointer -> the code's own address
    return PluginMain(code, 1, pb)
}
```

### The `word` Extern Type

The Toolbox's Pascal calling convention is built on 16-bit `INTEGER` arguments and results, not the 32-bit values every other Clarus `int` marshals as. `word` names that 16-bit width at the extern boundary — it is accepted ONLY as an `external func` parameter or return type:

```
externParam = IDENT ":" ( type | "word" ) ;
externRet   = type | "word" ;
```

`word` is contextual, the same way `overlay` and `external` are: recognized only in an `external func`'s own parameter list or return type position; everywhere else (a `var` declaration, a `record` field, a non-extern function's parameter) it is an ordinary identifier, and a program may freely use `word` as a variable or field name.

Within Clarus code, a `word`-typed parameter or return behaves exactly like `int` — callers pass ordinary `int` expressions, and a call returning `word` reads back as `int`, usable anywhere an `int` is:

```rust
external func UiMoveTo(h: word, v: word) = trap 0xA893
external func UiFindWindow(pt: int, wpOut: ptr): word = trap 0xA92C

func openAt(pt: int, wpOut: ptr): int {
    var kind: int = UiFindWindow(pt, wpOut)
    UiMoveTo(10, 20)
    return kind
}
```

The distinction matters only at the trap boundary itself. A `word` argument pushes as a single 16-bit stack word rather than `int`'s 32-bit long — the Pascal calling convention's own `bool`/`char` push shape, one stack word per argument regardless of width. A `word` result is popped back off its reserved stack slot and SIGN-extended to fill the full 32-bit value the rest of Clarus code sees — Toolbox `INTEGER` is signed (a coordinate, a row number, an index that can carry a negative sentinel), unlike the zero-extended `bool`/`char` result.

Under EITHER form of the `reg` calling convention (positional or named, above), a `word` PARAMETER has no separate marshaling of its own: it occupies a full D-register slot exactly like `int`, since `reg` never narrows to a stack word in the first place. A `word` RESULT is different — this corrects an earlier revision of this paragraph, which said a `word` result also occupies a full register slot like `int`: it does not. A `word` result under `reg` reads back from its result register's low 16 bits, SIGN-extended — the same `INTEGER`/`OSErr` signedness rule as a `word` result under the plain `trap` convention above, just sourced from a register instead of a popped stack slot. The one real call site that returns a `word` under `reg`, `UiGestaltErr` (`runtime/clarus/ui.cla`), already sign-extends its result this way; this correction makes the written rule match it.

## Appendix A: Grammar (EBNF)

```ebnf
program     = { topDecl } ;
topDecl     = includeDecl | recordDecl | enumDecl | constDecl | varDecl
            | funcDecl | externDecl | windowDecl | menuDecl | extendDecl
            | handlerDecl | everyDecl | appDecl ;

includeDecl = "include" STRING ;

recordDecl  = "record" IDENT "{" { fieldDecl } "}" ;
fieldDecl   = IDENT ":" type [ "=" ( literal | IDENT ) ] ;

enumDecl    = "enum" IDENT "{" enumMember { [ "," ] enumMember } "}" ;
enumMember  = IDENT [ INT | HEXINT ] [ STRING ] ;

constDecl   = "const" IDENT ":" type "=" ( literal | IDENT ) ;

type        = "int" | "bool" | "fixed" | "char" | "text" | "ptr"
            | "string" [ "(" INT ")" ]
            | "list" "of" type
            | "map" "of" type
            | "sortedmap" "of" type
            | "intmap" "of" type
            | IDENT
            | type "[" INT "]" ;

varDecl     = "var" IDENT ":" type [ "=" expr ] ;
funcDecl    = "func" IDENT "(" [ params ] ")" [ ":" type ] block ;
externDecl  = "external" "func" IDENT "(" [ params ] ")" [ ":" ( type | "word" ) ]
            [ "=" ( "trap" ( INT | HEXINT ) [ "sel" ( INT | HEXINT ) | regClause ]
                  | "inline" ( "deref" | "nop" | "a5" ) ) ] ;
            // regClause: see "Trap and Inline Clauses" (Chapter 13) for the full production
params      = param { "," param } ;
param       = IDENT ":" ( type | "word" ) ;

windowDecl  = "window" IDENT "{" { windowItem } "}" ;
windowItem  = property | widgetDecl | varDecl | "form" "for" IDENT ;
appDecl     = "app" IDENT "{" { property } "}" ;
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
            | forStmt | switchStmt | returnStmt | attemptStmt
            | "quit" [ expr ] | "cancel" | "break" | "continue"
            | "open" IDENT | "close" expr
            | "edit" IDENT "," ( lvalue | "new" IDENT ) ;
attemptStmt = "attempt" block "aborted" IDENT block ;
            // "abort" itself is an ordinary callStmt (a builtin function,
            // not a keyword) -- see Chapter 5's own "Attempt and Abort".
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

Newline sensitivity (statement termination, Chapter 2) is handled by the lexer and is not shown in the EBNF above. Newlines likewise separate properties inside declaration blocks; `;` is an optional same-line separator there. `appletalk` in `conn.open(appletalk "...")` is a contextual keyword parsed as a call-argument prefix, not a general-purpose token. After `.`, the hard keywords `open` and `close` are permitted as member names (`conn.open(...)`, `c.close()`) — the same positional carve-out Chapter 2 grants `window`. The two-expression index form (`s[start, len]`) is a slice, valid only in expression position — `lvalue` deliberately keeps the single-expression form. In `quit [expr]`, the expression must start on the same line as `quit` (a newline after `quit` ends the statement). `include` is likewise contextual, recognized only when it starts a top-level declaration and is followed by a STRING; `includeDecl` must precede every other `topDecl` in its file (Chapter 1) — an `include` appearing after any other top-level declaration is an error, not shown in the EBNF above. `app` is contextual the same way, recognized only when it starts a top-level declaration and is followed by an IDENT; unlike `include` it may appear anywhere among the top-level declarations, but at most once per program (Chapter 7). `external` is likewise contextual, recognized as the start of an `externDecl` only when immediately followed by `func`; elsewhere it is an ordinary identifier. Like `app`, an `externDecl` may appear anywhere among a program's top-level declarations (Chapter 13).

## Appendix B: Event Handler Quick Reference

The following table is the complete per-resource inventory of every event handler; Chapters 7–12 give full semantics.

| Resource | Event | Handler signature |
|---|---|---|
| App | launch | `on App.launch { }` |
| App | startEmpty | `on App.startEmpty { }` |
| App | startCLI | `on App.startCLI(args: list of string) { }` — command-line hosts only |
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

For `field`/`textview`/`check`/`popup`, `change` fires for a user edit — typing, cut, paste, or clear — and never for a program's own assignment to the widget's property (e.g. `Body.text = t`, or a `textview`'s `scrollToEnd()`), the same "programmatic writes are silent" rule every other runtime property already follows.

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
    button Add    { at: 10, bottom;   caption: "Add\xC9" }
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
        if Marks.selected == -1 {
            return
        }
        bookmarks.remove(Marks.selected)
    }
}

extend EditForm {
    on accepted(b: Bookmark) {
        if b.isNew { bookmarks.add(b) }
    }
}
```

Spell the ellipsis with the `\xC9` escape as shown — a literal `…` typed into a source file is UTF-8 and renders as three garbage glyphs on the Mac (Chapter 3).

### Text Editor

A complete multi-document plain-text editor — menus, document launching, and unsaved-changes handling:

```rust
window Doc {
    title: "Untitled"
    size: 460, 320
    resizable: min(200, 120)

    textview Body { fill: both;  scrollbar: both }

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

menu Edit { standard edit }        // Undo (dimmed)/Cut/Copy/Paste/Clear, pre-wired

func openPath(p: string) {
    var d: Doc
    var t: text

    d = open Doc
    if file.readText(p, t) {
        d.Body.text = t
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
    if not file.writeText(d.path, d.Body.text, app.doctype, app.id) {
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

        if askOpen(p, app.doctype) { openPath(p) }
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
