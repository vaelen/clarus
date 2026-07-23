# clarusc diagnostics inventory

Authoritative list of every diagnostic message string emitted by the Go front
end (`internal/lexer`, `internal/parser`, `internal/check`) — the messages
clarusc must reproduce byte-for-byte. This is the coverage checklist the
differential harness works toward: Task 11 requires every message here to be
exercised by at least one corpus/fixture file and matched by clarusc.

Extraction: `grep` of every string-literal diagnostic in the non-test `.go`
files of the three packages. `%s`/`%d`/`%q` are Go format placeholders filled
at emit time; clarusc must produce the identical filled text (`%q` wraps in
double quotes with Go escaping — clarusc approximates with a plain
`"` + text + `"`, exact for ordinary ASCII source; see the `unexpected
character` note below).

Backend diagnostics (`internal/lower`'s `host build does not support %s yet`)
are NOT in scope: `clarus check` never lowers, so they never appear in the
parity stdout.

## internal/lexer (11)

- `hex literal has no digits`
- `identifier too long (max 255 bytes)`
- `string literal too long (max 255 bytes)`
- `character literal must contain exactly one character`
- `unterminated character literal`
- `unterminated string literal`
- `invalid escape sequence`
- `unexpected character %q` — `%q` quotes the offending byte. clarusc emits
  `unexpected character '<byte>'` (plain quotes), which diverges only for
  control/non-ASCII bytes (already flagged with a `ponytail:` note in
  `lex.cla`).

## internal/parser (21)

- `expected %q, found %s`
- `expected %s, found %s`
- `expected declaration, found %s`
- `expected expression, found %s`
- `expected property, found %s`
- `expected member name, found %s`
- `expected menu entry, found %s`
- `expected default value, found %s`
- `expected column width (INT or 'fill'), found %s`
- `expected integer or fixed literal after '-', found %s`
- `expected 'item', 'separator', or 'standard', found %s`
- `expected 'on' or 'extend', found %s`
- `expression is not a statement`
- `cannot assign to this expression`
- `comparisons do not chain`
- `slices are not assignable`
- `enum must have at least one member`
- `include must precede other declarations`
- `variable declarations must appear at the top of the body`
- `variable declarations are only allowed at the top of a function or handler body`

## internal/check (80)

Wrapper: `%s` — the checker re-emits an already-formatted message verbatim in
a few spots; not a distinct message, just a pass-through.

Types / assignment / conversion:
- `mixed int/fixed arithmetic; convert explicitly`
- `bitwise operator requires int operands`
- `operator mod requires int operands`
- `invalid operands to %s: %s and %s`
- `type mismatch: %s and %s`
- `cannot assign %s to %s`
- `cannot assign %s to field %s of type %s`
- `cannot assign to constant %s`
- `cannot assign to read-only property %s`
- `cannot convert %s to %s`
- `cannot convert to %s`
- `conversion %s takes exactly one argument`
- `cannot use %s where %s is expected`
- `cannot use %s here (expected %s)`
- `cannot use %s where a char array is expected`
- `cannot use %s where a record is expected`
- `cannot use type %s as a value`
- `cannot use function %s as a value`
- `cannot use new with non-record type %s`
- `cannot negate %s`
- `condition must be bool`
- `index must be int`
- `map index must be string`
- `cannot index %s`
- `cannot slice %s`
- `slice start must be int`
- `slice length must be int`
- `range bounds must be int`

Names / declarations:
- `undefined: %s`
- `redeclaration of %s`
- `no field %s on %s`
- `duplicate enum value %d`
- `enum value out of range: %d`
- `const type must be int, fixed, char, bool, enum, or string`
- `constant initializer must be a literal, enum member, or constant`
- `case label must be a constant`
- `duplicate case label`

Comparisons / ordering:
- `enums are not ordered`
- `lists cannot be compared`
- `maps cannot be compared`
- `records cannot be compared`
- `nil is only valid for window and resource references`
- `nil is only valid with == or !=`

Control flow / returns:
- `break is only valid inside a loop`
- `continue is only valid inside a loop`
- `cancel is only valid inside a closeRequest handler`
- `window is only valid inside a window-scoped handler`
- `missing return value`
- `cannot return %s as %s`
- `unexpected return value in a procedure`
- `quit code must be int`
- `switch operand must be int, char, enum, or string`

Calls / iteration:
- `cannot call this expression`
- `%s is not callable`
- `wrong number of arguments`
- `wrong number of arguments to %s`
- `count takes no arguments`
- `file.%s must be called`
- `list iteration takes one variable`
- `map iteration requires key and value variables`
- `range for takes one variable`
- `cannot iterate over %s`

UI / windows / menus / forms / events:
- `%s is not a window`
- `%s is not a form window`
- `%s is a menu, not a value`
- `cannot open non-window type %s`
- `cannot close %s`
- `cannot extend %s`
- `cannot extend inside a menu extend`
- `form for names an undefined record: %s`
- `unknown property %s for %s`
- `unknown property %s for window`
- `unknown property column for %s`
- `unknown property column for window`
- `binds: expects a bare field name`
- `binds: takes one field name`
- `binds: requires the window to declare form for`
- `field %s (%s) is not compatible with %s`
- `duplicate menu item %s`
- `rows: takes one list expression`
- `rows: must be a list of record`
- `unknown event`
- `handler %s takes (%s)`
- `tick count must be at least 1`

Internal (should never fire on valid input; still transcribed for completeness):
- `internal: unhandled binary operator %s`
- `internal: unhandled unary operator %s`
- `internal: unhandled expression type`

## Known parity divergences (documented, corpus-untriggered)

These are places where clarusc's diagnostics can differ from `clarus check`;
no corpus or reference-fence file triggers them, so the differential stays
green. Fixing either is architectural and belongs to a future task that also
adds the triggering fixture.

- **`unexpected character %q` quoting.** clarusc prints the raw byte where the
  Go lexer applies `%q`-style escaping for non-printable/non-ASCII bytes.
  Differs only for control/high bytes in source.
- **Bad escape in a double-quoted string** (e.g. `"a\qb"`). clarusc's `lexAll`
  eagerly lexes to EOF, so after the escape error the orphaned closing quote
  starts a bogus second string and clarusc emits an extra
  `unterminated string literal` that Go never produces (Go's lazy lexer stops
  being pulled once the parser fail-fast aborts). The covered case `'\q'`
  (char literal) agrees on both sides.
