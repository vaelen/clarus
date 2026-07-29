# Bookmark Manager Visual Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix four visual defects found in the Bookmark Manager validation screenshots: table cell drawing erases the table border, the table's List Manager scrollbar renders outside the widget, button captions show MacRoman garbage from a corrupted source byte, and a labeled field's `width:` produces a misaligned, too-narrow edit box. Adds `\xXX` string/char escapes to the language so MacRoman bytes never have to live raw in source files again.

**Architecture:** Two independent runtime fixes in `runtime/mac/rt_ui.c` (table view-rect geometry; labeled-field width semantics), one language feature in the self-hosted compiler (`clarusc/lex.cla` escape decoding + `clarusc/cprint.cla` ASCII-safe caption emission), and one one-line app fix (`examples/bookmarks.cla`). The Go compiler stays frozen per policy.

**Tech Stack:** Clarus (`.cla`), C89 (Retro68 68k), Go test harness, Mini vMac gated UI harness.

## Global Constraints

- The Go compiler (`cmd/clarus`, `internal/` except tests) is FROZEN. The `\xXX` feature lands in the reference + clarusc only.
- **Because Go stays frozen, every `.cla` file the Go compiler itself builds must NOT use `\xXX`:** all of `clarusc/*.cla` (Go builds clarusc), all of `clarusc/test/*_test.cla` (built by `build.Build` in `internal/selfhost/driver_test.go`), and everything under `testdata/valid/` / `testdata/diag/` (differential corpus vs. the Go oracle). Only files compiled solely by clarusc (e.g. `examples/*.cla`, `testdata/ui/*.cla`) may use `\xXX`.
- Some `.cla` files contain non-UTF-8 bytes. After every edit to a `.cla` file, verify with `git diff` that ONLY the intended lines changed (byte-level: `git diff --stat` plus reading the hunk with `LC_ALL=C`). If the Edit tool mangles bytes, revert and use `LC_ALL=C sed` instead (see memory note "MacRoman .cla editing").
- Any change to `clarusc/*.cla` makes `TestSnapshotCurrent` fail until the snapshot is regenerated:
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  ```
  Regenerate + commit `clarusc/clarusc.c` in the same commit as the `.cla` change.
- Host gate: `go build -o clarus ./cmd/clarus && go test ./...` must pass after every task.
- Mac gate (needs toolchain + emulator, both present): `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run <Test> -v`. Golden re-bless: add `CLARUS_MAC_BLESS=1`. Re-bless regenerates traces + PBM snaps for the tests you run; commit only the snaps your change is expected to alter, and eyeball each changed PBM (they are viewable images) before committing.
- LaunchAPPL blocks until the app quits — always run gated tests in the background with generous timeouts (each scenario boots System 6, ~2-3 min).
- Branch: all work on `ui-visual-fixes` off `main`. Merge only on request.

## File Structure

- `clarusc/lex.cla` — `lexDecodeEscape` gains `\xHH` (Task 1)
- `clarusc/cprint.cla` — `cpEscapeCStr` emits octal escapes for non-printable/non-ASCII bytes (Task 1)
- `clarusc/test/lex_test.cla` + `lex_test.out` — escape test cases (Task 1)
- `clarusc/clarusc.c` — regenerated snapshot (Task 1)
- `docs/clarus-language-reference.md` — escape table row (Task 1); field `width:` semantics (Task 4)
- `examples/bookmarks.cla` — `"Add\xC9"` caption (Task 2)
- `runtime/mac/rt_ui.c` — `rt_ui_table_relayout` + table update-draw branch (Task 3); `rt_ui_layout` field width + label-lane cleanup (Task 4)
- `testdata/uisnaps/*.pbm` — re-blessed goldens (Tasks 3–5)

---

### Task 0: Branch setup

- [ ] **Step 1:** `git checkout -b ui-visual-fixes main` (repo is clean). No commit.

---

### Task 1: `\xXX` escapes in clarusc + ASCII-safe caption emission

**Files:**
- Modify: `clarusc/lex.cla` (`lexDecodeEscape`, ~line 400)
- Modify: `clarusc/cprint.cla` (`cpEscapeCStr`, ~line 1843)
- Modify: `clarusc/test/lex_test.cla` + `clarusc/test/lex_test.out`
- Modify: `docs/clarus-language-reference.md` lines 134–135 (escape lists)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces: string/char literals in clarusc-compiled programs accept `\xHH` (exactly two hex digits, case-insensitive, yielding that byte, 0x00–0xFF). Task 2 depends on this.

**Background you need:** `lexDecodeEscape(quote: char): bool` decodes the char after a `\`, storing the byte in the global `lexEscByte` and returning true; both the string lexer (line ~508) and char-literal lexer (line ~461) call it and emit a diagnostic on false. Hex helpers already exist in the same file: `isHex(c: char): bool` (line 40) and `hexDigitVal(c: char): int` (line 48). `lexOff`/`lexSrc`/`lexAdvance()` are the scan cursor. `cpEscapeCStr` escapes caption/title/menu-name strings into C `"\p..."` literals; today it passes any byte other than `"` and `\` through raw.

- [ ] **Step 1: Write the failing tests.** In `clarusc/test/lex_test.cla`, after the existing token-dump lines, extend the driver's `src` with new source lines exercising the escape (the test file itself is built by the FROZEN Go compiler, so spell the backslash as `\\` — the runtime text then contains a literal `\x..` for the clarusc lexer under test):

```
    // \xHH escapes (ui-visual-fixes Task 1). Go's frozen lexer never sees
    // these -- they are bytes inside this driver's src text, decoded by the
    // clarusc lexer under test.
    src.append(char(10))
    src.append("q = '\\x41'")          // char literal, decoded byte 65
    src.append(char(10))
    src.append("r = '\\xc9'")          // lowercase hex, decoded byte 201
    src.append(char(10))
    src.append("s = ")
    src.append('"')
    src.append("A\\x42C")              // string literal -> ABC (keeps golden ASCII)
    src.append('"')
    src.append(char(10))
    src.append("t = ")
    src.append('"')
    src.append("\\xZZ")                // bad escape -> diagnostic
    src.append('"')
```

Then extend `clarusc/test/lex_test.out` with the expected new lines: two char-literal tokens with `65` and `201`, ident/assign tokens as the existing golden spells them, a string-literal token showing `ABC`, and the bad-escape diagnostic line. Copy the exact kind-name/line:col spelling conventions from the existing golden lines (`describeTok` prints `KINDNAME line:col [payload]`); compute line/col from where your appended lines land.

- [ ] **Step 2: Run to verify failure.** `go test ./internal/selfhost -run TestClarusModules -v` — expect `lex_test.cla` to FAIL (the `\x` cases currently decode as bad escapes).

- [ ] **Step 3: Implement the lexer escape.** In `lexDecodeEscape`, add a case before the closing brace of the `switch`:

```
    case 'x' {
        if lexOff + 1 < lexSrc.length and isHex(lexSrc[lexOff]) and isHex(lexSrc[lexOff + 1]) {
            lexEscByte = char(hexDigitVal(lexSrc[lexOff]) * 16 + hexDigitVal(lexSrc[lexOff + 1]))
            lexAdvance()
            lexAdvance()
            return true
        }
    }
```

(Exactly two hex digits, no more, no fewer — C-style maximal munch is deliberately NOT copied; note this in the function's comment.)

- [ ] **Step 4: Implement ASCII-safe caption emission.** In `clarusc/cprint.cla`, add a 3-digit octal helper next to `cpEscapeCStr` and use it for every byte outside printable ASCII (octal, not `\xHH`, because C hex escapes are maximal-munch and would swallow a following hex digit; 3-digit octal is self-delimiting):

```
// cpOctal3 renders v (0-255) as exactly three octal digits, for C string
// escapes: \311 is self-delimiting where \xC9 would swallow a following
// hex digit (C's \x is maximal-munch).
func cpOctal3(v: int): string {
    var d: string
    d = numToStr(v % 8)
    d = numToStr((v / 8) % 8) + d
    d = numToStr(v / 64) + d
    return d
}
```

and in `cpEscapeCStr`'s loop, after the `'\\'` branch:

```
        } else if int(c) < 32 or int(c) > 126 {
            out = out + "\\" + cpOctal3(int(c))
        } else {
```

Update `cpEscapeCStr`'s header comment (it currently claims all captions are plain ASCII — no longer true once `\xC9` captions exist).

- [ ] **Step 5: Run tests.** `go test ./internal/selfhost -run TestClarusModules -v` — expect PASS. If the golden's line/col numbers were guessed wrong, fix the golden to the actual (correct-by-inspection) output, not the code.

- [ ] **Step 6: Regenerate the snapshot** (commands in Global Constraints), then run the full host gate: `go build -o clarus ./cmd/clarus && go test ./...` — expect PASS including `TestSnapshotCurrent` and `TestBootstrapFixedPoint`.

- [ ] **Step 7: Update the reference.** `docs/clarus-language-reference.md` lines 134–135: add `\xHH` to both the char and string escape lists, e.g. append to the string row: ``… `\xHH` (exactly two hex digits) emits byte HH — the way to put MacRoman bytes (e.g. `\xC9` for `…`) in a literal while keeping source files pure ASCII.`` Also check the grammar appendix (~line 1322) for an escape production; update if one exists.

- [ ] **Step 8: Byte-check + commit.** `LC_ALL=C git diff -- clarusc/ docs/` — confirm only intended lines changed. Commit: `clarusc: \xHH string/char escapes; octal-escape non-ASCII caption bytes in emitted C`.

---

### Task 2: Fix the corrupted Add caption

**Files:**
- Modify: `examples/bookmarks.cla:64`

**Interfaces:**
- Consumes: Task 1's `\xHH` escape.

**Background:** Line 64's caption currently contains the raw bytes `EF BF BD` (a UTF-8 U+FFFD replacement char left behind by an earlier bad edit) immediately after `Add`, rendering as `□øΩ` in MacRoman. The intended caption is `Add…` (MacRoman ellipsis = 0xC9).

- [ ] **Step 1: Replace the bytes with the new escape** (perl, not the Edit tool — the target bytes are not valid UTF-8, and BSD sed doesn't interpret `\xNN`):

```sh
perl -pi -e 's/\xEF\xBF\xBD/\\xC9/' examples/bookmarks.cla
```

- [ ] **Step 2: Verify the file is now pure ASCII and only line 64 changed:**

```sh
LC_ALL=C grep -n 'Add' examples/bookmarks.cla   # expect caption: "Add\xC9"
file examples/bookmarks.cla                      # expect: ASCII text
git diff examples/bookmarks.cla                  # exactly one line changed
```

- [ ] **Step 3: Prove it compiles and emits the right byte:**

```sh
scripts/build-mac.sh Bookmarks examples/bookmarks.cla
LC_ALL=C grep -c 'Add\\311' build-mac/Bookmarks/Bookmarks.c   # expect 1
```

- [ ] **Step 4: Commit:** `examples: Add caption uses \xC9 -- repairs U+FFFD corruption, file now pure ASCII`.

---

### Task 3: Table List-Manager view inset + scrollbar placement

**Files:**
- Modify: `runtime/mac/rt_ui.c` — `rt_ui_table_relayout` (~line 1445) and the `RTUI_TABLE` update-draw branch (~line 2891)
- Re-bless: `testdata/uisnaps/popuptable.S*.pbm`, `testdata/uisnaps/bookmarks.S*.pbm` (+ their `.trace` files if geometry lines appear in traces)

**Interfaces:**
- Consumes: nothing from other tasks (independent).
- Produces: LM view rect strictly inside the widget frame; both the LDEF (`rt_ui_ldef`, line ~1036) and the header-strip draw derive column x-positions from the same view-rect width.

**The bugs:** `rt_ui_table_relayout` makes `rView` identical to the widget rect below the header. `FrameRect(&box)` draws its 1px border inside that same rect, so the LDEF's per-cell `EraseRect(lRect)` (cells span the full view width) erases the left/right border pixels — bug #1. And `LNew(..., scrollVert=true)` puts the vertical scrollbar in the 16px strip *adjacent to the right of* `rView`, which is currently outside the widget entirely, at/off the window edge — bug #2.

- [ ] **Step 1: Fix the view rect.** In `rt_ui_table_relayout`, after the existing `listRect.top` adjustment, inset the view inside the frame and reserve the scrollbar strip:

```c
    /* The LM view sits strictly INSIDE the FrameRect border (the LDEF's
       per-cell EraseRect spans the full view width -- a view coextensive
       with the frame erases the border's own pixels), and leaves the
       classic 15px strip + shared border on the right for LM's vertical
       scroll bar, which LNew(scrollVert) draws ADJACENT to rView: with
       rView.right = box.right - 1 - RTUI_SCROLLBAR_W the bar's own frame
       lands flush on the widget frame, standard System 6 list geometry. */
    InsetRect(&listRect, 1, 0);
    listRect.bottom = (short)(listRect.bottom - 1);
    listRect.right = (short)(listRect.right - RTUI_SCROLLBAR_W);
    if (listRect.bottom < listRect.top) listRect.bottom = listRect.top;
    if (listRect.right < listRect.left) listRect.right = listRect.left;
```

(Keep the existing `rView.left/top` poke + `LSize` flow — `LSize` repositions the scrollbar itself. Note `InsetRect(&listRect, 1, 0)` moves left AND right in by 1; the net right edge must be `box.right - 1 - RTUI_SCROLLBAR_W`.)

- [ ] **Step 2: Make the header agree with the LDEF.** In the update-draw branch (~line 2905), the column x-walk uses `box` while the LDEF uses `rView` — after Step 1 they'd disagree by 17px. Change the branch to derive from the view rect:

```c
                Rect view = (*lh)->rView;
                FrameRect(&box);
                headerRect.bottom = view.top;
                fillW = rt_ui_table_fill_width(td, (short)(view.right - view.left));
                x = view.left;
```

(divider line + `LUpdate` unchanged). Also check the scripted-click lane (`rt_ui_table_click`, ~line 1523) and any row→point math: coordinates must land inside the NEW narrower view; adjust any `box`-derived x to `rView.left + 2` style if needed.

- [ ] **Step 3: Host gate.** `go test ./...` (runtime C isn't compiled by host tests, but keep the gate green).

- [ ] **Step 4: Mac gate + re-bless.** Run in background:

```sh
CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run 'TestPopuptableUIScenario|TestBookmarksUIScenario' -v -timeout 30m
```

- [ ] **Step 5: Eyeball every changed PBM** (Read tool renders them): the table frame must be a complete unbroken rectangle on all four sides; the scrollbar must be a full vertical bar (arrows top+bottom, gray shaft) flush inside the table's right edge; header column labels must sit exactly above their cell columns.

- [ ] **Step 6: Commit** code + blessed snaps/traces: `rt_ui: table LM view inset inside frame; scrollbar strip reserved -- border no longer erased, bar renders in-widget`.

---

### Task 4: Labeled-field `width:` means the edit box

**Files:**
- Modify: `runtime/mac/rt_ui.c` — `rt_ui_layout` (~line 902–908), `rt_ui_field_label_lane`/`RTUI_FIELD_MIN_EDIT_W` (~line 752–784, delete), `rt_ui_te_relayout` (~line 1926), update-handler field-label draw (~line 2825)
- Modify: `docs/clarus-language-reference.md` — field `width:` semantics (widget table ~line 904, layout prose ~line 938, Appendix C check ~line 1440)
- Re-bless: `testdata/uisnaps/formedit.S*.pbm`, `testdata/uisnaps/bookmarks.S*.pbm` (+ traces)

**Interfaces:**
- Consumes: nothing from other tasks (independent).
- Produces: for a `field` with a nonempty `label:`, the widget's total width = `RTUI_FIELD_LABEL_W` + edit-box width, where edit-box width is the declared `width:` (or a natural default when omitted). `width: fill` keeps whole-widget semantics. The label lane is ALWAYS `RTUI_FIELD_LABEL_W` — the Task-9 clamp becomes dead and is deleted.

**The bug:** `width: 60` on `Port` currently sizes the WHOLE widget; the clamp shrinks its label lane 70→40 to keep a 20px minimum box — so the box is 20px wide and starts 30px left of every other field's box.

- [ ] **Step 1: New width rule in `rt_ui_layout`.** Add near `RTUI_FIELD_W` (~line 187):

```c
/* Natural EDIT-BOX width for a labeled field (width-semantics fix,
   ui-visual-fixes Task 4): `width:` on a labeled field sizes the edit box
   alone, the RTUI_FIELD_LABEL_W lane is added on top -- so a labeled
   field with no `width:` keeps exactly its old 200px overall footprint. */
#define RTUI_FIELD_BOX_W (RTUI_FIELD_W - RTUI_FIELD_LABEL_W)
```

then replace the non-fill width computation (lines 904–908) with:

```c
        } else if (wd->kind == RTUI_FIELD && inst->labels[i][0] > 0) {
            /* Labeled field: `width:` is the EDIT BOX; the label lane is
               added here so every box in a form starts at the same x
               regardless of per-field widths (Ch8 width-semantics fix). */
            w = (short)(((wd->width == 0) ? RTUI_FIELD_BOX_W : wd->width) + RTUI_FIELD_LABEL_W);
        } else if (wd->width == 0) {
            w = rt_ui_kind_width(wd->kind); /* no `width:` given (or none exists for this kind) -- see RTUI_*_W's comment */
        } else {
            w = wd->width;
        }
```

- [ ] **Step 2: Delete the clamp.** Remove `rt_ui_field_label_lane` + `RTUI_FIELD_MIN_EDIT_W` + their comment block (lines ~752–784). Replace its two call sites with the constant:
  - `rt_ui_te_relayout` line ~1927: `box.left = (short)(box.left + RTUI_FIELD_LABEL_W);`
  - update-handler label draw ~line 2825–2831: same substitution.
  The existing `if (teRect.right < teRect.left)` clamp in `rt_ui_te_relayout` stays — it still guards the `width: fill`-in-a-tiny-window case.

- [ ] **Step 3: Grep for stragglers.** `LC_ALL=C grep -n 'field_label_lane\|FIELD_MIN_EDIT' runtime/ internal/` — expect zero hits. Host gate: `go test ./...`.

- [ ] **Step 4: Update the reference.** In the widget-property table's `field` row and/or the layout prose (~line 938), state: on a labeled `field`, `width:` gives the edit box's width and the fixed label lane is added to its left, so all boxes in a form align; `width: fill` sizes the whole widget (lane included); omitted `width:` keeps the natural overall size. Verify Appendix C's Bookmark Manager (`width: 60`, ~line 1440) now reads correctly with no change needed.

- [ ] **Step 5: Mac gate + re-bless.** Run in background:

```sh
CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run 'TestFormeditUIScenario|TestBookmarksUIScenario' -v -timeout 30m
```

- [ ] **Step 6: Eyeball changed PBMs:** in the Edit Bookmark form, all four bound-widget boxes (Name, URL, Port, Protocol) must start at the same x; Port's box must be 60px wide and fully enclose "80" with room to edit.

- [ ] **Step 7: Commit** code + reference + snaps: `rt_ui: labeled field width: sizes the edit box, constant label lane -- form boxes align; drop the Task-9 lane clamp`.

---

### Task 5: Full-gate verification + live visual check

**Files:** none new; re-bless any remaining stale snaps.

- [ ] **Step 1: Full host gate:** `go build -o clarus ./cmd/clarus && go test ./...` — PASS.

- [ ] **Step 2: Full gated Mac suite** (background, generous timeout):

```sh
CLARUS_MAC_TESTS=1 go test ./internal/mactest -v -timeout 90m
```

Any scenario failing on stale goldens whose diff is explained by Tasks 3/4 (table/field geometry): re-bless that scenario, eyeball, commit. Any OTHER diff = investigate before touching goldens.

- [ ] **Step 3: Live visual check.** Build and boot the real app with the Finder-less LaunchAPPL path in the background:

```sh
scripts/build-mac.sh Bookmarks examples/bookmarks.cla
toolchain/bin/LaunchAPPL -e minivmac build-mac/Bookmarks/Bookmarks.bin
```

Screenshot the emulator window (geometry via osascript, `screencapture -x -R...`), then drive it: verify (a) `Add…` caption renders with a real ellipsis, (b) table border complete, (c) scrollbar in place, then click Add and verify (d) the Port box aligns with the other fields. Screenshot the edit form too. Quit via File > Quit. Compare both screenshots against the two defect screenshots from the report.

- [ ] **Step 4: Commit any final blessed goldens.** Branch stays unmerged pending review + user request.
