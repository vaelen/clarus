# Vim Syntax Highlighting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A vim plugin at `editors/vim/` giving `.cla` files syntax coloring, filetype detection, and buffer-local editing defaults, verified by scripted `synID` assertions.

**Architecture:** Classic vimscript, plugin-shaped subtree (`ftdetect/`, `syntax/`, `ftplugin/`, `test/`). All syntax groups link to standard highlight groups. The test is a vimscript that locates probe tokens with `searchpos()` and asserts their syntax group names, run headlessly with `vim -es`.

**Tech Stack:** vimscript only (vim 8/9 + neovim compatible). No compiler/Go changes.

**Spec:** `docs/superpowers/specs/2026-07-25-vim-syntax-design.md`

## Global Constraints

- Everything lands under `editors/vim/` — no changes anywhere else in the repo, no Go files, no testdata.
- All `hi def link` targets are standard vim groups (Comment, Keyword, Type, Label, Number, Float, String, Character, SpecialChar, Error, Todo, Function, Include, Constant, Boolean, Operator, Statement, Conditional, Repeat).
- Documented accepted imprecisions (also in the syntax file's header comment): `mod` colored as operator everywhere; type names colored everywhere; a record field named like a property keyword (`size: int`) colors as Label.
- Vimscript files start with the header: `" Copyright 2026, Andrew C. Young <andrew@vaelen.org>` / `" SPDX-License-Identifier: MIT`.
- The keyword inventory is from the reference §Keywords: hard = `var func record enum const window menu extend on every if else while for in to return and or not true false nil open close edit new quit cancel switch case break continue`. `default` and `ticks` are contextual, NOT hard.
- Working branch: `vim-syntax` (exists; spec committed).

---

### Task 1: The plugin + probe test

**Files:**
- Create: `editors/vim/ftdetect/clarus.vim`
- Create: `editors/vim/syntax/clarus.vim`
- Create: `editors/vim/ftplugin/clarus.vim`
- Create: `editors/vim/test/sample.cla`
- Create: `editors/vim/test/check.vim`
- Create: `editors/vim/README.md`

**Interfaces:**
- Consumes: nothing from other tasks.
- Produces: the complete plugin; `scripts`-free manual check command documented in README.

- [ ] **Step 1: Write the probe fixture (test input)**

Create `editors/vim/test/sample.cla`. It need not compile — it exists to give every probe in check.vim an unambiguous first-occurrence target:

```
// sample.cla probe fixture -- need not compile  TODO tidy
include "lib.cla"

const LIMIT: int = 0x1F
var ratio: fixed = 1.5
var msg: string = "a\n b\q"
var ch: char = 'x'

window Main {
    title: "Demo"
    size: 300, 200
}

menu File {
    item New "New" key "N"
    separator
}

func size(at: int): int {
    return at mod 2
}

on App.launch {
    open Main
}

every 60 ticks {
    quit
}
```

- [ ] **Step 2: Write the failing check script**

Create `editors/vim/test/check.vim`:

```vim
" Copyright 2026, Andrew C. Young <andrew@vaelen.org>
" SPDX-License-Identifier: MIT
" Headless syntax-assertion harness. Run from the repo root:
"   vim -es -N -u NONE -i NONE --cmd 'set rtp+=editors/vim' \
"       -c 'filetype plugin on' -c 'syntax enable' \
"       -c 'edit editors/vim/test/sample.cla' \
"       -c 'source editors/vim/test/check.vim'
" Prints one line per failure and FAIL/OK; exit code 1 on any failure.

let s:report = []
let s:fails = 0

" Probe the FIRST occurrence of {pat}: the syntax group name at its first
" character must equal {want} ('' = no highlighting).
function! s:probeAt(pat, want) abort
  call cursor(1, 1)
  let [l, c] = searchpos(a:pat, 'cW')
  if l == 0
    let s:fails += 1
    call add(s:report, 'FAIL: pattern not found: ' . a:pat)
    return
  endif
  let got = synIDattr(synID(l, c, 1), 'name')
  if got !=# a:want
    let s:fails += 1
    call add(s:report, printf('FAIL %s at %d:%d: want [%s] got [%s]',
          \ a:pat, l, c, a:want, got))
  endif
endfunction

if &filetype !=# 'clarus'
  let s:fails += 1
  call add(s:report, 'FAIL: filetype is [' . &filetype . '], want [clarus] (ftdetect broken)')
endif

call s:probeAt('// sample',            'clarusComment')
call s:probeAt('TODO',                 'clarusTodo')
call s:probeAt('\<include\>',          'clarusInclude')
call s:probeAt('\<const\>',            'clarusKeyword')
call s:probeAt('\<int\>',              'clarusType')
call s:probeAt('0x1F',                 'clarusHex')
call s:probeAt('1\.5',                 'clarusFixed')
call s:probeAt('\<300\>',              'clarusNumber')
call s:probeAt('"Demo"',               'clarusString')
call s:probeAt('\\n',                  'clarusEscape')
call s:probeAt('\\q',                  'clarusEscapeError')
call s:probeAt("'x'",                  'clarusChar')
call s:probeAt('\<window\>',           'clarusKeyword')
call s:probeAt('title\ze:',            'clarusProperty')
call s:probeAt('size\ze:',             'clarusProperty')
call s:probeAt('\<menu\>',             'clarusKeyword')
call s:probeAt('\<item\>',             'clarusMenuKeyword')
call s:probeAt('\<separator\>',        'clarusMenuKeyword')
call s:probeAt('\<key\>',              'clarusMenuKeyword')
call s:probeAt('\<func\>',             'clarusKeyword')
call s:probeAt('func \zssize\>',       'clarusFuncName')
call s:probeAt('\<at\>\ze mod',        '')
call s:probeAt('\<mod\>',              'clarusOperatorWord')
call s:probeAt('\<return\>',           'clarusStatement')
call s:probeAt('\<on\>',               'clarusKeyword')
call s:probeAt('App\.\zslaunch',       'clarusEventName')
call s:probeAt('\<open\>',             'clarusStatement')
call s:probeAt('\<every\>',            'clarusKeyword')
call s:probeAt('\<ticks\>',            'clarusTicks')
call s:probeAt('\<quit\>',             'clarusStatement')

call add(s:report, s:fails == 0 ? 'OK' : 'FAIL (' . s:fails . ')')
call writefile(s:report, '/dev/stdout')
if s:fails > 0
  cquit!
endif
qall!
```

- [ ] **Step 3: Create ftdetect, then run the check to verify it fails**

Create `editors/vim/ftdetect/clarus.vim`:

```vim
" Copyright 2026, Andrew C. Young <andrew@vaelen.org>
" SPDX-License-Identifier: MIT
au BufRead,BufNewFile *.cla setfiletype clarus
```

Run (from repo root):

```sh
vim -es -N -u NONE -i NONE --cmd 'set rtp+=editors/vim' \
    -c 'filetype plugin on' -c 'syntax enable' \
    -c 'edit editors/vim/test/sample.cla' \
    -c 'source editors/vim/test/check.vim'; echo "exit: $?"
```

Expected: many `FAIL ... want [clarusX] got []` lines (filetype detects, but no syntax file exists yet), final `FAIL (N)`, `exit: 1`. This is the RED step.

- [ ] **Step 4: Write the syntax file**

Create `editors/vim/syntax/clarus.vim`:

```vim
" Copyright 2026, Andrew C. Young <andrew@vaelen.org>
" SPDX-License-Identifier: MIT
" Vim syntax for Clarus (.cla) -- normative token inventory:
" docs/clarus-language-reference.md Ch2 (Keywords, Literals).
"
" Accepted imprecisions (spec 2026-07-25-vim-syntax-design.md):
"   - `mod` colors as an operator everywhere (it is not a reserved word).
"   - type names color everywhere, not only in type positions.
"   - property keywords color only when followed by `:`; a record field
"     that reuses such a name (`size: int`) therefore colors as Label.

if exists("b:current_syntax")
  finish
endif

" ---- comments ---------------------------------------------------------
syn keyword clarusTodo TODO FIXME XXX contained
syn match   clarusComment "//.*$" contains=clarusTodo

" ---- hard keywords (reference Ch2) ------------------------------------
syn keyword clarusKeyword     var func record enum const window menu extend on every
syn keyword clarusConditional if else switch case
syn keyword clarusRepeat      while for in to
syn keyword clarusStatement   return break continue quit cancel open close edit new
syn keyword clarusOperatorWord and or not mod
syn keyword clarusBoolean     true false
syn keyword clarusNil         nil
syn keyword clarusInclude     include

" ---- types ------------------------------------------------------------
syn keyword clarusType int bool fixed char string text list map of
syn keyword clarusType connection listener serviceBrowser

" ---- contextual property keywords: only before ':' --------------------
syn match clarusProperty "\<\%(title\|size\|resizable\|min\|at\|fill\|scrollbar\|caption\|label\|default\|rows\|width\|binds\|shows\|column\)\ze\s*:"

" every N ticks
syn match clarusTicks "\<\d\+\s\+\zsticks\>"

" ---- menu bodies ------------------------------------------------------
" item/separator/standard/key color only inside `menu Name { ... }`
" (menu bodies contain no nested braces, so a single-level region is safe).
syn keyword clarusMenuKeyword item separator standard key contained
syn region  clarusMenuBlock transparent start="\<menu\>\s\+\k\+\s*{" end="}" contains=TOP,clarusMenuKeyword

" ---- literals ---------------------------------------------------------
syn match clarusNumber "\<\d\+\>"
syn match clarusFixed  "\<\d\+\.\d\+\>"
syn match clarusHex    "\<0x\x\+\>"

syn match  clarusEscapeError "\\." contained
syn match  clarusEscape      "\\[\"\\nt]" contained
syn region clarusString oneline start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=clarusEscapeError,clarusEscape
syn match  clarusChar +'\%([^'\\]\|\\.\)'+ contains=clarusEscapeError,clarusEscape

" ---- declarations -----------------------------------------------------
syn match clarusFuncName  "\<func\>\s\+\zs\w\+"
syn match clarusEventName "\<on\>\s\+\%(\w\+\.\)\?\zs\w\+"

syn sync fromstart

" ---- linking ----------------------------------------------------------
hi def link clarusComment      Comment
hi def link clarusTodo         Todo
hi def link clarusKeyword      Keyword
hi def link clarusConditional  Conditional
hi def link clarusRepeat       Repeat
hi def link clarusStatement    Statement
hi def link clarusOperatorWord Operator
hi def link clarusBoolean      Boolean
hi def link clarusNil          Constant
hi def link clarusInclude      Include
hi def link clarusType         Type
hi def link clarusProperty     Label
hi def link clarusTicks        Label
hi def link clarusMenuKeyword  Keyword
hi def link clarusNumber       Number
hi def link clarusFixed        Float
hi def link clarusHex          Number
hi def link clarusString       String
hi def link clarusChar         Character
hi def link clarusEscape       SpecialChar
hi def link clarusEscapeError  Error
hi def link clarusFuncName     Function
hi def link clarusEventName    Function

let b:current_syntax = "clarus"
```

Implementation notes for debugging (only if a probe fails):
- Keywords beat matches/regions at the same position in vim, so `menu`
  stays `clarusKeyword` even where the region starts. `clarusEventName`
  is a match and CANNOT recolor a keyword — that's why the probe list
  expects `on opened`-style bare names (matched) but hard keywords stay
  keywords. If `App.launch`'s `launch` probe fails, check the `\%(...\)\?`
  group; iterate with `:syn list clarusEventName` in an interactive vim.
- If the `clarusMenuBlock` region proves fiddly (e.g. `contains=TOP,...`
  misbehaving on the installed vim), fall back to line-anchored matches:
  `syn match clarusMenuKeyword "^\s*\zs\%(item\|separator\|standard\)\>\%(\s*[=.(:]\)\@!"`
  plus `syn match clarusMenuKeyword "\<key\>\ze\s\+\""` — and note the
  substitution in your report.
- Match definition ORDER matters for same-position starts (last wins):
  clarusFixed and clarusHex must stay defined after clarusNumber.
- `\zs` does not survive vim's keyword-over-match priority when the
  pattern's match START falls on a keyword (`:help :syn-priority`);
  rewriting such patterns with `\@<=` look-behind (as done for
  clarusFuncName, clarusEventName, clarusTicks) is the sanctioned fix.

- [ ] **Step 5: Write the ftplugin**

Create `editors/vim/ftplugin/clarus.vim`:

```vim
" Copyright 2026, Andrew C. Young <andrew@vaelen.org>
" SPDX-License-Identifier: MIT
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s
setlocal comments=://
setlocal shiftwidth=4 softtabstop=4 expandtab
setlocal formatoptions-=t formatoptions+=croql

let b:undo_ftplugin = "setlocal commentstring< comments< shiftwidth<"
      \ . " softtabstop< expandtab< formatoptions<"
```

- [ ] **Step 6: Run the check to verify it passes (GREEN)**

Same command as Step 3. Expected output: `OK`, `exit: 0`.

If any probe fails, fix syntax/clarus.vim (see Step 4's notes) and re-run. Do not weaken a probe to make it pass — probes encode the spec.

- [ ] **Step 7: Load-clean check on the real examples**

```sh
for f in examples/mandelbrot.cla examples/menu-demo.cla examples/hello-mac.cla; do
  vim -es -N -u NONE -i NONE --cmd 'set rtp+=editors/vim' \
      -c 'filetype plugin on' -c 'syntax enable' \
      -c "edit $f" \
      -c 'if v:errmsg != "" | cquit! | endif' -c 'qall!' \
      && echo "$f: clean" || { echo "$f: ERROR"; exit 1; }
done
```

Expected: three `clean` lines. (Catches regex errors that only fire on real-file constructs.)

- [ ] **Step 8: Write the README**

Create `editors/vim/README.md`:

```markdown
# Clarus vim support

Syntax highlighting, filetype detection, and editing defaults for
Clarus (`.cla`) in vim 8/9 and neovim.

## Install

Native packages (vim 8+/neovim):

    mkdir -p ~/.vim/pack/local/start
    ln -s /path/to/clarus/editors/vim ~/.vim/pack/local/start/clarus

(neovim: use ~/.local/share/nvim/site/pack/local/start instead.)

vim-plug:

    Plug 'vaelen/clarus', {'rtp': 'editors/vim'}

## Check

From the repo root:

    vim -es -N -u NONE -i NONE --cmd 'set rtp+=editors/vim' \
        -c 'filetype plugin on' -c 'syntax enable' \
        -c 'edit editors/vim/test/sample.cla' \
        -c 'source editors/vim/test/check.vim'

Prints `OK` (exit 0) or per-probe failures (exit 1).

## Known tradeoffs

- `mod` highlights as an operator everywhere (it is not reserved).
- Type names highlight everywhere, not only in type positions.
- Property keywords (`size`, `at`, ...) highlight only when followed by
  `:`; a record field reusing such a name colors as a label.
```

- [ ] **Step 9: Full-suite sanity + commit**

```sh
go test ./internal/driver ./internal/selfhost   # nothing should have changed, quick paranoia pass
git add editors/vim
git commit -m "editors/vim: Clarus syntax highlighting, ftdetect, ftplugin, probe harness"
```

Expected: tests pass (untouched), one commit.

---

## Final verification (whole branch)

- [ ] Probe harness green (`OK`, exit 0); examples load-clean.
- [ ] Controller eyeball: TOhtml render of examples/mandelbrot.cla screenshotted and reviewed.
- [ ] Whole-branch review; merge only on request.
