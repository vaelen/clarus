# Vim Syntax Highlighting for Clarus — Design

Date: 2026-07-25
Status: approved (brainstormed with Andrew)

## Goal

A classic vimscript plugin, living in-repo at `editors/vim/`, that gives
`.cla` files syntax coloring, filetype detection, and sane buffer-local
editing defaults in vim 8/9 and neovim. No tree-sitter, no LSP, no custom
indent engine.

## Layout

```
editors/vim/
  ftdetect/clarus.vim   # au BufRead,BufNewFile *.cla setfiletype clarus
  syntax/clarus.vim     # all highlighting
  ftplugin/clarus.vim   # commentstring, comments, 4-space expandtab, cindent-style braces
  README.md             # install: native pack symlink + vim-plug rtp one-liners
  test/check.vim        # scripted synID assertions (run manually)
  test/sample.cla       # the fixture check.vim probes
```

Plugin-shaped subtree so both install styles work unchanged:
`ln -s .../clarus/editors/vim ~/.vim/pack/local/start/clarus` or
`Plug 'vaelen/clarus', {'rtp': 'editors/vim'}`.

## Highlighting (syntax/clarus.vim)

All groups link to standard vim groups; no colors of our own.

**Hard keywords** (reference Chapter 2, reserved everywhere) → split by role:
- `Statement`/`Keyword`: `var func record enum const window menu extend on
  every if else while for in to return open close edit new quit cancel
  switch case break continue`
- `Boolean`: `true false`; `Constant`: `nil`
- `Operator`: `and or not`, plus `mod` (not formally a keyword, but it is
  an operator in every realistic occurrence; the collision with a variable
  named `mod` is accepted and documented in the file header)

**Types** → `Type`: `int bool fixed char string text list map of` and the
resource types `connection listener serviceBrowser`. These are contextual
in the language but overwhelmingly used as types in practice; highlighting
them everywhere is the standard vim tradeoff.

**Contextual property keywords** → `Label`, matched ONLY when followed by
optional space + `:` (colon lookahead, `\ze\s*:` style), so `at`/`size`
etc. as ordinary identifiers stay uncolored: `title size resizable min at
fill scrollbar caption label default ticks rows width binds shows`.
Record-field declarations (`name: type`) will color a field that happens
to reuse one of these names — accepted, rare, and visually harmless.

**Menu-body keywords** → `Keyword`, only inside a `menu <Name> { … }`
syntax region: `item separator standard key`. The region also colors the
item's accelerator string normally (strings still match inside regions).

**Table-column keywords** `column shows width fill` are covered by the
colon-lookahead set where they take colons, and `column`/`shows` are
matched as `Label` when followed by a string/identifier inside braces —
if this proves fiddly during implementation, `column` alone may be added
to the plain keyword set instead (implementer's choice, noted in file).

**`every N ticks`** — `every` is a hard keyword; `ticks` colors via a
dedicated match `\<ticks\>` preceded by a number (`\d\+\s\+\zsticks`).

**Literals:**
- `Number`: decimal `\<\d\+\>` and hex `\<0x\x\+\>` (no underscores — the
  language has none in numbers)
- `Float`: fixed-point `\<\d\+\.\d\+\>`
- `String`: `"…"` region, single line (strings cannot span lines);
  `SpecialChar` for exactly `\" \\ \n \t`; any other `\x` inside a string
  or char literal → `Error`
- `Character`: `'A'` and escape forms
- `Todo` inside comments: `TODO FIXME XXX`

**Comments** → `Comment`: `//` to end of line. No block comments exist.

**Declarations** → `Function`: the identifier after `func`, and the
`Name.event` pair in `on Name.event` handler heads (event name as
`Function`, receiver as default text). `include "file"` at top of file:
`include` → `Include`.

**Sync:** `syn sync fromstart` is fine at Clarus file sizes (largest file
in-repo is ~2k lines; per-buffer cost is negligible).

## ftplugin/clarus.vim

Buffer-local only, with undo_ftplugin: `commentstring=//\ %s`,
`comments=://`, `shiftwidth=4 softtabstop=4 expandtab`,
`formatoptions-=t` `+=croql`. No custom indentexpr — vim's default
brace handling plus these settings is adequate for Clarus's brace blocks.

## Verification

`test/check.vim` run as
`vim -es -u NONE -c 'set rtp+=editors/vim' -c 'source editors/vim/test/check.vim'`
against `test/sample.cla`: asserts `synIDattr(synID(line,col,1),"name")`
(transparent=1) at ~a dozen probe positions — hard keyword, type,
colon-followed property keyword, same word NOT followed by colon
(must be unhighlighted), menu `item`, hex number, fixed literal, string
escape, invalid escape → Error, comment, TODO. Exits nonzero with a
message on any mismatch, prints OK otherwise. Run manually + an eyeball
pass over examples/mandelbrot.cla and examples/menu-demo.cla; not wired
into go test (editor tooling, not compiler surface).

## Out of scope

Indent expression function, folding, tree-sitter grammar, neovim-lua
anything, LSP, other editors.
