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
