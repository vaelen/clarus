# The Clarus Toolbox Cookbook

This is a how-to companion to `docs/clarus-language-reference.md` Chapter 13
("Low-Level Memory Access") and, within it, especially the "Transcribing
Inside Macintosh Declarations" subsection. That table is the **normative**
mapping from Inside Macintosh's own type vocabulary to Clarus's `extern
record`, `external func`, and `callback func` — it is what a compiler-facing
disagreement gets resolved against. This document does not restate that
table's rules; it walks through applying them to real Inside Macintosh pages,
end to end, including the mistakes a first attempt tends to make. Wherever
this document and the reference seem to disagree, the reference wins — that
would be a bug in this document, not a second opinion.

Every declaration shown below either already ships in the repository — the
curated catalog under `toolbox/` (`memory.cla`, `events.cla`, `osutils.cla`,
`scrap.cla`), the runtime (`runtime/clarus/ui.cla`, `runtime/clarus/
uitext.cla`), or a test suite case (`testsuite/toolbox/`) — or is the
reference's own worked example. None of it is invented for this document;
each walkthrough below cites its source.

## 1. Reading an IM page

An Inside Macintosh trap listing gives you a Pascal-looking signature, e.g.

```
FUNCTION MenuKey (ch: CHAR): LongInt;
```

Transcribing that into Clarus takes four steps:

1. **Read off the name and parameters**, matching each Inside Macintosh type
   against the reference's own transcription table (Ch13). `CHAR` here is a
   `CharParameter`, which the table calls out specially: it maps to `word`,
   **never** `char` — more on why in §2.
2. **Find the routine's trap word.** It is not in the Pascal signature above;
   it lives in Inside Macintosh's trap-word appendix (the "Trap Macros and
   Function Codes" tables), or, more conveniently for this codebase, in
   Retro68's own machine-readable transcription of those tables under
   `Retro68/InterfacesAndLibraries` (the CIncludes headers, which `#define`
   the trap constants) and `multiversal/defs/*.yaml` (a structured per-call
   listing of trap word, register bindings, and result location this repo's
   catalog work leans on heavily — see the provenance comments atop
   `toolbox/*.cla`). `MenuKey`'s trap word is `0xA93E`.
3. **Decide pascal vs. `reg` with the bit-11 test.** This is the reference's
   own normative rule (Ch13, "Transcribing Inside Macintosh Declarations"):
   a trap word's bit 11 (`trap & 0x0800`) says which calling convention a
   `= trap` clause must declare — set means the Toolbox/Pascal convention,
   clear means the OS/register convention. `0xA93E & 0x0800 == 0x0800`, so
   `MenuKey` is bit-11-set: plain `trap 0xA93E`, no `reg` clause.
4. **Watch for a param/result type that needs `word`, not the "obvious"
   Clarus type** — `CHAR`, `Boolean`, `INTEGER`, and `OSErr` all transcribe
   to `word`, per the table; only `LONGINT`/`OSType`/`Fixed` become `int`.
   Getting this step wrong is the single most common way a transcription
   compiles clean and then fails silently at runtime — the whole subject of
   §2 below.

### Bit 11 is a real trap, not a pedantic rule

It is tempting to trust an Inside Macintosh signature's own Pascal shape —
`FUNCTION OSEventAvail (eventMask: INTEGER; VAR theEvent: EventRecord):
BOOLEAN;` certainly *looks* like an ordinary Pascal call. It is not: `_
OSEventAvail` is trap `0xA030`, and `0xA030 & 0x0800 == 0` — bit 11 clear, OS
register convention, despite the Pascal-looking prose signature.
`testsuite/toolbox/cases_event.cla`'s own header comment documents exactly
this trap catching a real mis-declaration in this repository's history: an
early draft declared `TbOSEventAvail = trap 0xA030` as plain Pascal (no
`reg`), which is wrong, and the SAME mis-declaration shape had already landed
for real in `runtime/clarus/ui.cla`'s `UiFlushEvents` (`_FlushEvents`,
`0xA032` — bit-11-clear too, right next to `OSEventAvail` in the same OS
Event Manager family). `UiFlushEvents` was fixed in this same phase (Task
3) — it now reads:

```rust
external func UiFlushEvents(masks: int) = trap 0xA032 reg
```

with the two 16-bit masks Inside Macintosh's own `FlushEvents(whichMask,
stopMask: Integer)` signature describes packed into one 32-bit `int`
argument (`masks`), low word = `whichMask`, high word = `stopMask`) — the
register convention's own D0-pair-not-two-stack-words shape, verified
against `multiversal/defs/OSEvent.yaml`'s `register: D0LowWord`/
`D0HighWord` clause for this trap. Before the fix, `UiFlushEvents` was
declared plain `trap 0xA032` with no `reg` — it compiled, and, on the
scripted-golden lanes that never reach a real event loop, it never even ran;
only a real native boot exercised it, and by then the damage (`every` blocks
silently never firing) looked like a scheduling bug, not a trap-declaration
bug. The lesson: an Inside Macintosh page's Pascal-looking prose signature
describes the *language-level* glue a Pascal or C compiler would generate
around the raw trap — not the raw trap-dispatch convention itself. The two
differ for OS traps specifically. Always check bit 11 against the actual hex
trap word; never infer the convention from how the signature reads.

## 2. Walkthrough: the pascal trap — `MenuKey`

`MenuKey`'s trap word, `0xA93E`, is bit-11-set (§1), so it takes the plain
Toolbox/Pascal convention: `trap 0xA93E`, no `reg`. The one remaining
question is `ch`'s type. Inside Macintosh's `MenuKey` signature declares `ch:
CHAR` — a `CharParameter`. The reference's transcription table has a
dedicated row for exactly this case:

> `CHAR` (a CharParameter) | `word` — **never** `char`. A CHAR parameter is a
> plain 16-bit `INTEGER` with the character code in the low byte; Clarus's
> `char` extern shape instead pads its value into the word's high byte, the
> same convention `bool` uses. Declaring a CHAR parameter `char` silently
> reads and writes the wrong byte at the trap boundary — the MenuKey lesson.

That last sentence names this exact routine because a real, in-repository
mistake shaped this row of the table. Here is the broken version, exactly as
it once existed in this codebase (per `testsuite/toolbox/cases_events.cla`'s
own header comment, describing the "5faaa6c-era bug shape"):

```rust
// BROKEN -- do not transcribe MenuKey this way.
external func MenuKeyBroken(ch: char): int = trap 0xA93E
```

Trace what happens at the call boundary. Per the reference's own pascal
marshaling rule (Ch13, "Trap and Inline Clauses"): a `bool`/`char` parameter
under the plain `trap` clause occupies a full 16-bit stack word, but the
value itself is pushed into that word's **high** byte — the same convention
`bool` uses. `MenuKey`'s real ABI wants the character code in the word's
**low** byte (that's what `CharParameter` means). `MenuKeyBroken(int('Q'))`
therefore pushes `'Q'`'s code shifted into the high byte, `_MenuKey` reads
the low byte — always zero, because nothing was ever written there — and no
key equivalent, on any menu, ever matches. There is no crash, no error
return, no visible symptom beyond "the Quit menu's Cmd-Q equivalent silently
never fires from the keyboard." That is the silent failure mode: the
function compiles, links, runs, and returns a plausible-looking `int` every
single call — it is just always wrong.

The fix is the row's own prescription — declare `ch` as `word`:

```rust
// Correct: CharParameter transcribes to `word`, per Ch13's transcription
// table.
external func TbMenuKey(ch: word): int = trap 0xA93E
```

This is `testsuite/toolbox/cases_events.cla`'s real `TbMenuKey` declaration,
verbatim, and its case `caseMenuKeyMatches` is the live proof: it calls
`TbMenuKey(int('Q'))` against a real File menu with a `key "Q"` item, and
requires the packed result to name a nonzero menu ID **and** the exact
expected item number — the broken `char` shape above would return `0`
(nothing matched), which the case's own comment calls out explicitly as
exactly the failure this assertion is designed to catch. `MenuKey`'s packed
result — menu ID in the high word, 1-based item number in the low word, per
Inside Macintosh's own `MenuKey` documentation — is ordinary bit-shift-and-
mask arithmetic on the returned `int`, the same shape `runtime/clarus/
ui.cla`'s own `rtUiHiWord`/`rtUiLoWord` helpers use to unpack it after the
runtime's own `UiMenuKey` call:

```rust
var result: int = TbMenuKey(int('Q'))
var menuID: int = (result >> 16) & 0xFFFF
var item: int = result & 0xFFFF
```

## 3. Walkthrough: the register trap and `memerr` — `SetHandleSize`

Inside Macintosh's Memory Manager declares `SetHandleSize` as a `PROCEDURE`
— no return value — but every real caller needs to know whether the resize
succeeded. The trap word answers both open questions: is this `reg`, and
where does the error code actually live?

`SetHandleSize`'s trap word is `0xA024`. `0xA024 & 0x0800 == 0` — bit 11
clear, register convention. Register-convention parameters are assigned by
declaration order: at most two `ptr` params in A0 then A1, at most two
`int`/`bool`/`char`/`word` params in D0 then D1 (Ch13, "Trap and Inline
Clauses"). `SetHandleSize(h: ptr, newSize: int)` fits that exactly — `h` in
A0, `newSize` in D0.

The remaining wrinkle is the reference calls out by name: `reg` assumes a
meaningful result lands in D0, but `SetHandleSize` is a Pascal `PROCEDURE` —
no result register at all. Its real error code is Inside Macintosh's own
documented behavior for this whole Memory Manager family: it goes into the
well-known low-memory global `MemErr` (`$0220`), not any register.
`reg memerr` names exactly that shape — the call still marshals like plain
`reg`, but the declared return value is read back from `MemErr` (sign-
extended, like any other `OSErr`) instead of from D0:

```rust
external func SetHandleSize(h: ptr, newSize: int): int = trap 0xA024 reg memerr
```

This is `toolbox/memory.cla`'s real declaration, verbatim — proven against
`runtime/clarus/list.cla`'s own `ListSetHandleSize` (an already-shipped `reg
memerr` declaration against the same trap word), per that catalog file's own
provenance comment; the sibling declarations in the same file (`NewPtr`/
`DisposePtr`, plain `reg`, no `memerr`) are separately proven against
`testsuite/toolbox/cases_gestalt.cla`'s own `TbNewPtr`/`TbDisposePtr`.
Reading `SetHandleSize`'s result the ordinary way — no ceremony at the call
site, `memerr`'s indirection is entirely inside the compiler-generated glue:

```rust
var h: ptr = NewHandle(64)
var err: int = SetHandleSize(h, 256)
if err != 0 {
    // MemErr was nonzero after the trap -- the resize failed.
}
```

`HLock`/`HUnlock`/`NewHandle`/`DisposeHandle`/`NewPtr`/`DisposePtr`/
`GetHandleSize`/`BlockMoveData`/`MoreMasters` — the rest of `toolbox/
memory.cla` — are all plain `reg` (no `memerr`) by the same bit-11 test;
`SetHandleSize` is the one member of the family whose real error path
doesn't come back in D0 at all.

## 4. Walkthrough: the named-register form — `Gestalt`

Some register-convention traps don't fill registers in simple declaration
order — `Gestalt`'s real convention, per Inside Macintosh VI chapter 3 and
Retro68's own `Gestalt.h` (`#pragma parameter __D0 Gestalt(__D0, __A1)`), is
`selector` in D0 and `response` in **A1**, not the positional form's A0.
`reg`'s NAMED form exists for exactly this: `reg(REG: paramName, ...)` binds
each register explicitly instead of assigning by position, and an optional
trailing `ret REG` names the result register (default is A0 for a `ptr`
result, D0 otherwise — `Gestalt` returns a `word`, so its default result
register is already D0, and `ret d0` here is redundant with that default;
it's spelled out anyway to document the real convention explicitly, not
because the declaration needs it):

```rust
external func Gestalt(selector: int, response: ptr): word =
    trap 0xA1AD reg(d0: selector, a1: response) ret d0
```

This is `toolbox/osutils.cla`'s real declaration, verbatim — and it comes
with a genuinely useful warning, not just a syntax note. `toolbox/
osutils.cla`'s own header comment records a **real discrepancy** between two
sources that are supposed to agree: Retro68's `multiversal/defs/
Gestalt.yaml` claims `responsep` is `register: Out<A0>`, but that's wrong for
real 68k hardware — `Gestalt.h`'s own `#pragma parameter` line (A1, not A0)
is the actual convention, and this repository hit the concrete consequence
of trusting the wrong source: an earlier revision of `runtime/clarus/
ui.cla`'s `UiGestalt` declared `Gestalt` as plain pascal, which made `cg68k`
push arguments on the stack instead of loading D0/A1 — the register-based
trap then read a garbage selector and wrote its response through a wild A0
pointer, hanging the machine on a real native boot. The fix was switching to
`reg(d0: selector, a1: response)`, and it is what both `ui.cla`'s `UiGestalt`
and the catalog's `Gestalt` use today. **The generated defs can be wrong; the
empirical boot is the tiebreaker** — this is worth internalizing as a general
rule for every trap transcribed from generated headers, not just this one.

There is a second, more insidious failure mode `ret d0` guards against, and
it is the reason the catalog exists at all rather than everyone hand-rolling
`Gestalt` locally: `testsuite/toolbox/cases_gestalt.cla`'s `caseGestaltNamed`
case documents a historical bug shape where the register wiring silently
misroutes the response pointer while the error code still comes back clean:

```rust
var respSlot: ptr = NewPtr(4)
var err: int = Gestalt(0x73797376, respSlot) // 'sysv' = gestaltSystemVersion
var resp: int = peekl(respSlot)
DisposePtr(respSlot)
if err == 0 and resp != 0 {
    // real success
}
```

A broken register assignment — response landing in the wrong register —
reproduces `UiGestalt`'s own historical bug exactly: `err` reads back `0`
(the call *looks* like it succeeded) while `response` was never actually
written, leaving `resp` at its zero-initialized default. That is why the
case (and any real caller) must check **both** `err == 0` **and** `resp !=
0`, never `err == 0` alone — a clean error code from a register trap proves
the trap dispatched, not that every argument register actually landed where
the callee expected.

## 5. Walkthrough: extern-record transcription — `EventRecord` and `Point`

Inside Macintosh's own Toolbox Event Manager gives `EventRecord`'s Pascal
struct diagram as:

```
EventRecord = RECORD
    what:      INTEGER;
    message:   LONGINT;
    when:      LONGINT;
    where:     Point;
    modifiers: INTEGER;
END;
```

Transcribing an `extern record` is a field-by-field pass against the
reference's Field Palette (Ch13): each Inside Macintosh field type becomes
the palette's corresponding Clarus type, at the palette's own byte size and
alignment, in declaration order, with the whole record's size rounded up to
even. `Point` first, since `EventRecord` nests it:

```rust
extern record Point {
    v: word
    h: word
}
```

`Point`'s own diagram is `v, h: INTEGER` — both `word` (2 bytes, 2-byte
alignment per the palette), so `Point` is 4 bytes total, `v`@0, `h`@2. Now
`EventRecord`, walking the palette one field at a time:

| Field | IM type | Clarus type | bytes | offset |
|---|---|---|---|---|
| `what` | `INTEGER` | `word` | 2 | 0 |
| `message` | `LONGINT` | `int` | 4 | 2 |
| `when` | `LONGINT` | `int` | 4 | 6 |
| `where` | `Point` | nested `extern record` | 4 | 10 |
| `modifiers` | `INTEGER` | `word` | 2 | 14 |

Every field here is already 2-byte-aligned by the palette's own rule (`word`
aligns at 2, `int` aligns at 2, a nested extern record aligns at 2), so there
is no padding to insert anywhere — the running offset is already even before
every field. Total size: 16 bytes, already even, so no rounding needed:

```rust
extern record EventRecord {
    what: word
    message: int
    when: int
    where: Point
    modifiers: word
}
```

This is `toolbox/events.cla`'s real declaration, verbatim — verified against
Retro68's `multiversal/defs/MacTypes.yaml` (`Point`: `v`, `h` both
`INTEGER`, size 4) and `defs/EventMgr.yaml` (`EventRecord`: exactly this
field list, size 16), per that catalog file's own provenance comment.

Using it means reading fields at those offsets through ordinary field
access, and passing the whole record's address by decay at an `external
func` call site — the one address-of the language provides (Ch13, `extern
record`):

```rust
external func TbEventAvail(mask: word, ev: ptr): bool = trap 0xA971

func waitForEvent(): int {
    var ev: EventRecord
    var got: bool = TbEventAvail(0xFFFF, ev) // `ev` decays to its address
    if got and ev.what == keyDown {
        return ev.message & charCodeMask
    }
    return -1
}
```

## 6. Walkthrough: selector dispatch — `LAddRow`

Some Toolbox packages share a single trap word across a whole family of
routines, distinguished by a selector word the caller pushes immediately
before the trap. The List Manager is the canonical example: `LNew`,
`LDispose`, `LAddRow`, and the rest all dispatch through the one trap
`0xA9E7`. The reference's own worked example (Ch13, "Trap and Inline
Clauses") transcribes `LAddRow`:

```rust
external func LAddRow(count: word, rowNum: word, lHandle: ptr): word = trap 0xA9E7 sel 0x0008
```

`sel 0x0008` names `LAddRow`'s own selector within the shared `0xA9E7` trap;
`SELECTOR` is pushed as one more Pascal-convention stack word, closest to the
trap itself, after every declared argument — the trap dispatcher pops it
along with the rest, so the caller does no extra cleanup. `sel` and `reg` are
mutually exclusive: a selector-dispatch trap is always Pascal-convention,
which also follows from the bit-11 test — `0xA9E7 & 0x0800 == 0x0800`, bit 11
set. Reading an Inside Macintosh page for a selector-dispatched call means
finding both numbers: the shared trap word from the trap appendix, and the
routine's own selector from the package's own selector-constant table (List
Manager's `lNewSel`/`lDisposeSel`/`lAddRowSel`/etc.) — Retro68's
`multiversal/defs/*.yaml` files list both together for the routines they
cover, the same as any other trap entry.

## 7. Walkthrough: a callback — a control action procedure

A `callback func` declares an ordinary Clarus function the Toolbox itself
calls back through — an LDEF, a control's action procedure, a dialog filter
— via compiler-generated pascal-convention glue (Ch13, `callback func`). The
reference's own schematic example uses exactly this shape, a `TrackControl`
action procedure:

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

A callback's own body is ordinary Clarus code, entirely unaware of the
pascal-convention boundary — the glue that reads each argument at its fixed
stack offset and writes the result back is compiler-generated, never
hand-written. The bare callback name (`myAction` above) decays to its glue's
address only where the callee's parameter is declared `ptr`; used any other
way (a variable initializer, a non-`ptr` argument, a return value), it is a
build-time error.

A real one lives in this codebase: `runtime/clarus/uitext.cla`'s
`rtUiScrollbarAction`, the action procedure behind a textview's scrollbar
(continuous scroll on a held-down arrow or page button). It is decayed
directly into `UiTrackControl`'s own `actionProc` argument — `UiTrackControl`
itself is `trap 0xA968` (`runtime/clarus/uiwidgets.cla`), bit-11-set, plain
Pascal, taking the callback's glue address as an ordinary `ptr` parameter:

```rust
callback func rtUiScrollbarAction(ctrl: ptr, part: word) {
    // ... reads the control's own refCon to find which textview and
    // scroll axis, computes a step, applies it via UiSetControlValue and
    // UiTEScroll ...
}

// elsewhere, inside the scrollbar-click handler:
UiTrackControl(ctrl, wherePt, rtUiScrollbarAction)
```

`part` is declared `word`, not `int`: `ControlActionUPP` declares it pascal
`short`, and `word` is the one callback-palette type that reproduces a pascal
short's sign-extending marshal at the boundary — the same reasoning as
`MenuKey`'s `ch` parameter in §2, just on the callback side of the
convention instead of the `external func` side. The same file also calls
`rtUiScrollbarAction` **directly**, as an ordinary function call, from its
scripted-click test path — proof that a callback's body is a real,
independently-callable Clarus function, and that a direct call bypasses the
Toolbox glue entirely.

**Warning, restated from the reference:** interrupt-time completion routines
— VBL tasks, asynchronous completion procedures, Time Manager tasks — are
out of scope for `callback func`. The A5-world and allocation restrictions
those contexts impose are not something this language can make safe yet. A
`callback func` should only be handed to a Toolbox routine that invokes it at
ordinary application-level call time (an LDEF, an action procedure, a dialog
filter, and the like — exactly `rtUiScrollbarAction`'s own situation), never
one that fires from an interrupt.

## 8. Walkthrough: copy/paste, the two-scrap protocol

TextEdit maintains its own private "TE scrap" — a scratch buffer for the
currently-selected/most-recently-cut-or-copied text inside one `TEHandle` —
separate from the Scrap Manager's desk scrap, the one real clipboard that
crosses applications. Getting Cut/Copy/Paste right means moving data between
the two at the right moments, in the right direction. Inside Macintosh's own
recipe (TextEdit chapter) is:

- **Cut/Copy**: `TECut`/`TECopy` (moves/copies the TE's own selection into
  the *TE* scrap) — then `ZeroScrap` (clears the desk scrap) — then
  `TEToScrap` (publishes the TE scrap out to the desk scrap, making it
  available to every other application, not just this one).
- **Paste**: `TEFromScrap` (pulls the desk scrap's current contents into the
  TE scrap) — then `TEPaste` (inserts the TE scrap at the current
  selection).

This is exactly `runtime/clarus/ui.cla`'s real `rtUiStdEditDispatch`, the
dispatcher every Clarus program's Edit menu routes through:

```rust
if itemIdx == 2 { // Cut
    UiTECut(te)
    UiZeroScrap()
    UiTEToScrap()
    rtUiTeMutated(inst, w.focusIdx, true)
} else if itemIdx == 3 { // Copy: no mutation
    UiTECopy(te)
    UiZeroScrap()
    UiTEToScrap()
} else if itemIdx == 4 { // Paste
    rtUiStdEditPaste(inst, te) // UiTEFromScrap(); ...; UiTEPaste(te)
}
```

`ZeroScrap`/`GetScrap`/`PutScrap` are ordinary Scrap Manager traps and
transcribe the ordinary way — `toolbox/scrap.cla`:

```rust
external func ZeroScrap(): int = trap 0xA9FC
external func PutScrap(length: int, theType: int, source: ptr): int = trap 0xA9FE
external func GetScrap(hDest: ptr, theType: int, offset: ptr): int = trap 0xA9FD
```

### The glue-vs-trap lesson

`TEFromScrap` and `TEToScrap` are **not** transcribable the same way —
they have no trap word at all. This is confirmed independently by two
sources: `runtime/clarus/uitext.cla`'s own doc comment records that neither
`Multiverse.h` nor `TextEdit.h` gives these an `M68K_INLINE` trap word, unlike
every other TE call around them, which all do; Retro68's own headers resolve
them to a real InterfaceLib call instead. `toolbox/scrap.cla`'s header
comment independently confirms the same absence from the Scrap Manager side:
it found no TE-prefixed entries anywhere in `multiversal/defs/ScrapMgr.yaml`
either. So a bare, clause-less declaration is the correct transcription —
not an oversight, not a stub to fill in later:

```rust
external func UiTEFromScrap(): int
external func UiTEToScrap(): int
```

This is the general lesson worth internalizing: not every Inside Macintosh
"call" is a raw A-line trap. Some are ordinary library glue routines dressed
up in the same Pascal-signature prose as a trap, and the tell is the absence
of a trap word anywhere in the headers or the trap-word appendix — when that
happens, `external func` with no `= trap`/`= inline` clause at all is
itself the correct, deliberate transcription, and it is up to each code
generator lane to decide how such a clause-less extern actually resolves.

### How the runtime bridges it, lane by lane

That "up to each lane" decision is exactly where this repository's own
implementation gets interesting, and it is a real illustration of why
Clarus has two code-generation lanes at all. A bare (clause-less) extern
resolves differently per lane:

- **The host-C (`cprint`) lane** resolves `UiTEFromScrap`/`UiTEToScrap` by
  emitting a call to the real C library name — its generated wrapper calls
  the actual `TEFromScrap`/`TEToScrap` InterfaceLib routines directly, the
  same way it already does for other bare glue externs like
  `UiMacInitToolbox`/`UiScreenBounds`.
- **The native (`cg68k`) lane** has no InterfaceLib to link against on a
  bare-metal 68k boot, so it resolves a clause-less extern by a naming
  convention instead: a clause-less `external func Foo(...)` compiles to a
  call to an ordinary Clarus function named `nat_Foo`, which the program
  itself must supply. `runtime/clarus/uitext.cla` supplies exactly that —
  `nat_UiTEFromScrap`/`nat_UiTEToScrap` — as a **real** hand-written bridge,
  not a stub: they read/write the documented TE low-memory scrap globals
  (`TEScrpHandle` at `$0AB4`, `TEScrpLength` at `$0AB0`) directly via
  `peekl`/`pokew`, and move bytes to and from the desk scrap through the
  ordinary `GetScrap`/`PutScrap` traps with the `'TEXT'` type
  (`0x54455854`):

```rust
func nat_UiTEToScrap(): int {
    var th: ptr
    var st: int
    var err: int

    th = ptr(peekl(ptr(0xAB4)))
    if th == ptr(0) {
        return 0 // empty TE scrap: nothing to publish
    }
    st = UiHGetState(th)
    UiHLock(th)
    err = UiPutScrap(nat_UiTEGetScrapLength(), 0x54455854, UiHandleDeref(th))
    UiHSetState(th, st)
    return err
}
```

This is a complete, correct substitute for this runtime's own purposes
specifically because the TE records this runtime creates are monostyled (no
style runs to preserve) — going straight to the flat desk-scrap buffer via
`GetScrap`/`PutScrap` loses nothing a real `TEToScrap` would have kept. Note
also what this bridge is **not**: earlier in this same phase it was a no-op
deferred stub, in-app-only; this bridge is the fix — both lanes now
implement the real round trip, and `testsuite/toolbox/cases_catalog.cla`'s
own `caseCatalog` proves it empirically, copying real typed text through a
real `EditMain` field, reading the desk scrap back through the catalog's own
`GetScrap`, then publishing fresh desk-scrap text and pasting it back into
the field — on the native lane, the hardware-proof lane, not just a host
simulation.

### The free path

None of the above is something an ordinary Clarus program needs to write.
`menu Edit { standard edit }` (Chapter 9, "Standard Edit") wires exactly
this Cut/Copy/Paste/Clear behavior to every `field` and `textview` widget
automatically — "required for a native feel... but otherwise pure
boilerplate," in the reference's own words. Reach for the machinery in this
section only when writing runtime-level code or a program that needs the
desk scrap directly (say, to interoperate with a non-TextEdit source of
text); an ordinary application gets it for free.

## 9. Hard-won lessons

### (a) Mini vMac does not model 68000 address errors

A misaligned memory access is a hard fault on real 68000 hardware — an
address error, immediate and visible. Mini vMac's emulation does not model
that fault: an odd-aligned `.W` or `.L` access that would crash a real Mac
Plus just silently works in the emulator. This means **a native-gate PASS
does not prove alignment correctness** — the goldens have to be eyeballed
for odd `.W`/`.L` bases, not just trusted because the emulator run came back
green. This is exactly the failure shape that motivated `cgSlotSizeOf`'s
even-rounding fix for packed byte-array-of-`bool`/`char` records: a subtly
misaligned field can pass every gated boot in this repository's own CI, on
this repository's own emulator, and still be wrong on real hardware. When
transcribing an `extern record` or reasoning about a struct's layout, trust
the Field Palette's alignment rules (Ch13) over "the test suite is green" —
the emulator cannot catch what it doesn't model.

### (b) Using the catalog

The four `toolbox/*.cla` files are ordinary user-side declaration files, not
runtime modules — they join a build the same way any other `.cla` file does,
two ways:

- **Positionally**, as one more file handed to `clarusc emit`/`emit68k`/
  `check`, the same compose-recipe pattern `testsuite/core`'s own CLI build
  uses (CLAUDE.md's own "Run `core` on host" recipe):

  ```sh
  clarusc emit --rtdir runtime/clarus/ -o out.c \
      toolbox/memory.cla toolbox/events.cla myprogram.cla
  ```

- **Via `include`** (Chapter 1, "Multi-File Programs"), naming the catalog
  file's path from your own source:

  ```rust
  include "toolbox/events.cla"
  ```

Either way works because `extern record`/`external func`/`const` are
ordinary top-level declarations with no special build-graph requirement.

The one thing worth understanding before composing a catalog file alongside
your own declarations, or alongside the runtime's own `Ui`-prefixed
originals: the reference's dedup rule (Ch13, `external func`) — and, just as
important, what it does **not** cover. Two `external func` declarations
sharing a name are legal **if and only if they are identical** — same
parameter list (types and order), same return type, same trap/inline clause
in full (trap word, `sel`, calling convention, every register binding,
`memerr`, and `ret`). The checker silently merges an identical repeat into
the first declaration; every call site resolves to that one entry. The
reference's own `TickCount` example (Ch13) shows the same trap declared
twice, verbatim, merging cleanly. That rule is scoped to `external func`
only — `extern record` has no dedup rule at all, identical or not, so two
same-named record declarations simply collide. That is exactly why
`testsuite/toolbox/cases_event.cla` no longer declares its own local
`Point`/`EventRecord`: its own header comment notes it used to, and now gets
them from `toolbox/events.cla` instead, because a second local copy would
collide outright rather than merge. Its locally declared `Tb`-prefixed
externs (the `external func` half) compose alongside the catalog's without
collision precisely because the dedup rule above covers those.

**When a redeclaration differs**, even in one small way — a different
parameter type, a missing `memerr`, a `reg` clause where the other
declaration has none — it is a compile error naming both declaration sites,
not a silent pick-one. This is deliberate, the same accommodation a C header
gives a repeated `extern` prototype (a program can redeclare a trap the
runtime already declares, transcribed independently from the same Inside
Macintosh page, without a spurious redeclaration error) — but it means a
genuine mismatch is loud, not silently resolved in either declaration's
favor. If your own catalog usage and the runtime's own internal declaration
of the same trap ever disagree, that disagreement is exactly the kind of
thing this document's §1 and §4 warn about: one of the two transcriptions is
wrong, and the compiler is telling you to go find out which.

---

*Everything in this document is a citation, not an assertion — see the
individual walkthroughs above for exact file and line references. Where a
mapping rule itself (rather than a worked example of applying it) is in
question, `docs/clarus-language-reference.md` Chapter 13 is the authority.*
