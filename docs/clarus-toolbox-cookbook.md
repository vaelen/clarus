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

**Who this is for.** Most Clarus programs should never need anything in this
document: the language's own windows, widgets, menus, forms, and files hide
the Toolbox behind friendlier abstractions (cut/copy/paste, for example, is
a capability of text controls, not something an application implements), and
a "standard" application is written entirely through the lens of the Clarus
language. The Toolbox surface exists for the minority case — when a program
needs something the abstractions don't cover — and for the runtime itself,
which calls the Toolbox through the same `toolbox/` catalog documented here.
When transcribing something new, prefer the Toolbox as the 1980s Inside
Macintosh volumes define it (Volume VI covers System 7.0): this repository's
programs run on System 6 and System 7 both, so use the System 6 form
whenever possible, and gate anything System 7-only behind a `Gestalt`
version check with a graceful fallback (§4 shows the mechanics).

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
   Function Codes" tables). The authoritative machine-readable source for
   this repo is Apple's own Universal Interfaces 3.4, checked out at
   `Retro68/InterfacesAndLibraries/Interfaces`:

   - **`AIncludes/*.a`** — the assembly-language interfaces. Each routine's
     `OPWORD $Axxx` line is the trap word itself, verbatim, plus `RECORD`
     blocks giving struct field offsets (e.g. `AIncludes/Events.a`'s
     `EventRecord RECORD 0` block, or `AIncludes/Scrap.a`'s `ScrapStuff`).
     This is the ground truth for "what is the trap word."
   - **`CIncludes/*.h`** — the C interfaces. A `#pragma parameter __D0
     Name(__A0, __D0)`-style line just above a routine's declaration gives
     its exact register convention (which argument goes in which register,
     and where the result comes back); a bare declaration with no such
     pragma is the plain Pascal/stack convention. `ONEWORDINLINE`/
     `TWOWORDINLINE`/`THREEWORDINLINE` macros give the trap word (first
     word) plus any compiler-generated glue instructions that run
     immediately after it (see the Delay walkthrough in
     `toolbox/osutils.cla`'s own header comment for why that glue matters:
     it can hide a second parameter that never touches the raw trap).
   - **`PInterfaces/*.p`** — the Pascal interfaces, with `INLINE` clauses
     giving the same trap words in Pascal's own compiler-inline syntax, a
     third independent cross-check when the first two are ambiguous.

   **A file-handling gotcha worth knowing up front:** these three
   directories are ISO-8859 text with CR (`\r`) line terminators and
   occasional high bytes (comment-box art, mostly) — a plain recursive
   `grep -r` silently returns nothing, because every file looks like one
   giant line with no `\n` in it. Read them with the line terminator
   translated first:

   ```sh
   LC_ALL=C tr '\r' '\n' < AIncludes/Events.a | LC_ALL=C grep -n 'OPWORD'
   ```

   (or pipe through `sed -n` afterwards for a range). `LC_ALL=C` keeps the
   high bytes from being treated as invalid multibyte sequences and
   silently dropped or erroring out.

   Retro68 also ships its own machine-readable *reconstruction* of these
   same tables under `multiversal/defs/*.yaml` (trap word, register
   bindings, result location, one file per Manager) — this repo's earlier
   catalog work leaned on it heavily, and older provenance comments in
   `toolbox/*.cla` cite it. **Treat multiversal as untrusted when cited
   alone** — but note that the one case where this repo declared it wrong
   turned out to be multiversal being *right*. `multiversal/defs/
   Gestalt.yaml` says Gestalt's `responsep` is `register: Out<A0>`, and an
   earlier revision of this document called that "wrong for real 68k
   hardware" on the strength of `CIncludes/Gestalt.h`'s `#pragma parameter
   __D0 Gestalt(__D0, __A1)`. The pragma describes the inline *glue*'s
   parameter passing, not the trap's: the glue is
   `TWOWORDINLINE(0xA1AD, 0x2288)`, and `0x2288` is `MOVE.L A0,(A1)` —
   compiler-emitted code that copies the trap's A0 result through the
   caller's `long *response`. The trap answers in A0; A1 is where the glue
   wants the pointer. See §4 below for the full walkthrough, and
   `toolbox/osutils.cla`'s header comment for the on-hardware proof.
   multiversal is still worth re-checking rather than trusting alone, but
   the real lesson is narrower and sharper: **decode the inline words.** A
   `#pragma parameter` line on a `TWOWORDINLINE`/`FOURWORDINLINE` routine
   is describing a call whose second half is glue you must either
   reproduce or route around. Any trap word or register binding should be
   re-checked against the AIncludes/CIncludes/PInterfaces sources above
   before being trusted on its own, and the FINAL word belongs to
   empirical boot verification (a
   real native `emit68k` boot on Mini vMac, or one of the gated
   `internal/mactest` suites) whenever the two disagree or the stakes are
   high enough to warrant it — a static header, however authoritative,
   still can't catch a ROM behaving differently than documented.

   `MenuKey`'s trap word is `0xA93E`.
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

## 4. Walkthrough: the named-register form, and glue words — `Gestalt`

Some register-convention traps don't fill registers in simple declaration
order, and some answer in more registers than a Clarus extern can name.
`Gestalt` is both, and it is the cautionary tale of this whole document.

Start from `CIncludes/Gestalt.h:64-69`:

```c
#pragma parameter __D0 Gestalt(__D0, __A1)
EXTERN_API( OSErr )
Gestalt(OSType selector, long *response)   TWOWORDINLINE(0xA1AD, 0x2288);
```

Read the pragma alone and you conclude "selector in D0, response pointer in
A1, OSErr in D0", and you write this:

```rust
// WRONG -- do not copy
external func Gestalt(selector: int, response: ptr): word =
    trap 0xA1AD reg(d0: selector, a1: response) ret d0
```

That was `toolbox/osutils.cla`'s real declaration until the
pack3-standardfile phase, and it silently returned nothing. **`TWOWORDINLINE`
means the call is not one instruction.** Decode the second word the way
§3's `Delay` note decodes its own: `0x2288` is the raw 68k instruction
`MOVE.L A0,(A1)`. That is compiler glue, emitted *after* the trap returns,
copying A0 through the caller's `response` pointer. Which tells you the raw
trap's actual contract: **OSErr in D0, response VALUE in A0**, and it never
reads A1 at all. Retro68's `multiversal/defs/Gestalt.yaml` said exactly that
all along (`responsep` `register: Out<A0>`); the pragma was describing the
glue's inputs, not the trap's.

A `reg` extern names exactly ONE result register and cannot emit that second
word, so the trap is transcribed twice — once per result register — and
callers pair the two:

```rust
external func GestaltErr(selector: int): word = trap 0xA1AD reg(d0: selector) ret d0
external func GestaltValue(selector: int): int = trap 0xA1AD reg(d0: selector) ret a0
```

This is `toolbox/osutils.cla`'s real declaration pair, verbatim. Note `ret
a0` on an `int` return: without it the default rule (A0 for a `ptr` result,
D0 otherwise) would read D0 and hand back the error code. Gestalt is a pure
query with no side effects, so making the call twice is safe; check
`GestaltErr` first, then read `GestaltValue`. The same "faithful, if reduced,
transcription" applies as for `Delay`, whose glue word `0x2280` is
`MOVE.L D0,(A1)` — there the wanted value already sits in D0, so one
declaration suffices and the pointer parameter can be dropped entirely.

### Why the wrong version looked like it worked

This is the part worth internalizing. The broken declaration passed A1 as an
input the trap ignores and read D0, which really is the OSErr — so `err` came
back a clean `noErr` on every call. Only the response was lost. Every caller
had written the obvious test:

```rust
var respSlot: ptr = NewPtr(4)
var err: int = Gestalt(0x73797376, respSlot) // 'sysv' = gestaltSystemVersion
var resp: int = peekl(respSlot)
DisposePtr(respSlot)
if err == 0 and resp != 0 {
    // "real success"
}
```

`_NewPtr` does not zero its block. `respSlot` was never written by anything,
so `resp` was whatever heap garbage happened to be lying there — usually
large and nonzero, so `resp != 0` usually held and the check usually passed.
It cost this repo two days: `testsuite/toolbox`'s `Catalog` case eventually
drew a heap layout where those four bytes came back zero, and the resulting
"passes here, fails there, flips on any unrelated edit, native lane only"
signature was attributed to a phantom segment-loader bug in `cg68k` — a
theory that survived a clean git bisect, a cross-lane comparison, and a
deterministic `--seglimit` reproduction, because *every one of those
observations was also consistent with it*. The tell that broke it open was a
size-neutral probe: poke `0x11223344` into the slot before the call, read it
back after, get `0x11223344`.

Two rules fall out, and they generalize past this trap:

- **Never assert `!= 0` on a Toolbox out-parameter.** Assert the value's real
  shape. `Gestalt('sysv')` answers a small BCD system version, so the cases
  in `testsuite/toolbox` now require `0x0400 <= resp < 0x1000`. An out-param
  test that a wild pointer or an untouched buffer can satisfy is not a test.
- **A clean error code proves the trap dispatched, nothing more.** It says
  nothing about whether your argument registers landed where the callee
  expected, and nothing at all about registers the callee returns in.

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

### (c) A fill-target trap parameter must be declared `ptr`, never `str`

A Toolbox trap that WRITES INTO a caller-supplied string (fills it, the
same shape `file.readText`/`askOpen`/`askSave` use for their own
runtime-side out-params, Ch3/Ch12) must transcribe that parameter as
`ptr`, never `str`, in its `external func` declaration. Before the
param-abi phase (2026-08-12), a `str`-typed Clarus variable was always a
private, full-copy value at every call boundary, so even if you passed it
into a filling trap, only your own local copy could ever be mutated — a
`str` parameter looked safe to use for a fill target by accident. Since
that phase, `string`/record parameters pass **by address** (Ch3, Ch13's
own `external func` note): a `str`-typed Clarus PARAMETER is now a
borrowed alias of whatever storage the caller passed, not a private copy,
so a fill through it writes into the caller's own aliased storage instead
of a disposable local. Declaring the trap's out-param `ptr` instead keeps
the aliasing explicit and caller-controlled (the caller passes the
address of whatever storage it actually intends to have mutated) rather
than letting it happen silently through ordinary `str`-param plumbing.

## 10. Walkthrough: the bit-11 exception — `SecondsToDate`

`SecondsToDate`'s trap word is `0xA9C6`. `0xA9C6 & 0x0800 == 0x0800` — bit 11
set, which §1's rule reads as the plain Toolbox/Pascal convention. Checking
the actual glue instead settles it the other way. `CIncludes/DateTimeUtils.h`
gives:

```c
#pragma parameter SecondsToDate(__D0, __A0)
EXTERN_API( void )
SecondsToDate(unsigned long secs, DateTimeRec *d)   ONEWORDINLINE(0xA9C6);
```

`ONEWORDINLINE` — one word, no second glue instruction — and `AIncludes/
DateTimeUtils.a` says so explicitly: `secs => D0, d => A0`. There is no
compiler-emitted copy after the trap returns; the raw trap itself is
register-based, despite its bit-11-set trap word. This is the reference's
one documented exception to the bit-11 rule (Ch13, the bit-11 paragraph),
and the declaration follows the register convention, not the plain one:

```rust
external func SecondsToDate(secs: int, d: ptr) = trap 0xA9C6 reg(d0: secs, a0: d)
```

This is `toolbox/osutils.cla`'s real declaration, verbatim. `DateToSeconds`
(`0xA9C7`) is the same shape, register-based for the identical reason —
always check the glue word count, not just the bit-11 bit, when the two
disagree.

---

*Everything in this document is a citation, not an assertion — see the
individual walkthroughs above for exact file and line references. Where a
mapping rule itself (rather than a worked example of applying it) is in
question, `docs/clarus-language-reference.md` Chapter 13 is the authority.*
