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
"   - menu keywords (`item`/`separator`/`standard`/`key`) are matched by
"     line anchoring and lookaheads rather than a menu-scoped region, so a
"     pathological identifier use of one of those names at the start of a
"     line inside some other block could miscolor (accepted).
"   - table-column lines (`column "Hdr" shows field width fill`) are not
"     specially highlighted: `column` is never followed by `:` (grammar
"     always writes `shows`/`width` instead), so it doesn't fit the
"     colon-lookahead property match (safe default; no examples use
"     tables yet).
"   - `include` highlights everywhere, though the language treats it as
"     contextual and top-of-file only.

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
syn match clarusProperty "\<\%(title\|size\|resizable\|min\|at\|fill\|scrollbar\|caption\|label\|default\|rows\|width\|binds\|shows\)\ze\s*:"

" every N ticks
" NOTE: a plain \zs match here starts scanning at the digit, the same
" column clarusNumber starts at; match-vs-match ties go to the
" last-defined item (clarusNumber), silently discarding this whole match.
" A look-behind keeps the item's own start column at "ticks", clear of
" the conflict.
syn match clarusTicks "\(\<\d\+\s\+\)\@<=ticks\>"

" ---- menu bodies ------------------------------------------------------
" item/separator/standard/key color only inside `menu Name { ... }`.
" FALLBACK (see docs/superpowers/plans/2026-07-25-vim-syntax.md Step 4 notes): a
" `syn region ... start="\<menu\>\s\+\k\+\s*{" ... contains=TOP,...`
" never opens on this vim -- its start pattern begins scanning at the
" same column as the `menu` keyword, and keywords always beat
" match/region items at a shared start column (:help :syn-priority),
" so the region is discarded entirely. Falling back to line-anchored
" matches instead, per the brief's pre-authorized substitution.
syn match clarusMenuKeyword "^\s*\zs\%(item\|separator\|standard\)\>\%(\s*[=.(:]\)\@!"
syn match clarusMenuKeyword "\<key\>\ze\s\+\""
syn match clarusMenuKeyword "\<standard\>\ze\s\+edit\>"

" ---- literals ---------------------------------------------------------
syn match clarusNumber "\<\d\+\>"
syn match clarusFixed  "\<\d\+\.\d\+\>"
syn match clarusHex    "\<0x\x\+\>"

syn match  clarusEscapeError "\\." contained
syn match  clarusEscape      "\\[\"\\nt]" contained
syn region clarusString oneline start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=clarusEscapeError,clarusEscape
syn match  clarusChar +'\%([^'\\]\|\\.\)'+ contains=clarusEscapeError,clarusEscape

" ---- declarations -----------------------------------------------------
" NOTE: a plain \zs match after \<func\>/\<on\> starts its regex scan at
" the SAME column as the clarusKeyword match for "func"/"on", and a
" keyword always beats a match at a shared start column (:help
" :syn-priority) -- the whole match is discarded, not just recolored up
" to \zs. A look-behind assertion moves the match's own start column
" past the keyword, clear of the conflict, while still requiring it.
syn match clarusFuncName  "\(\<func\>\s\+\)\@<=\w\+"
" clarusEventName must not color the receiver in `on App.launch` -- only
" the trailing member (or the whole name in the bare `on opened` form).
" The look-behind absorbs an optional `Receiver.` past the keyword so the
" match's own start column lands on the member name, clear of the
" keyword/match priority conflict noted above; the trailing \>\%(\.\)\@!
" excludes any word that is itself followed by a dot (a receiver). The
" \> (word-end boundary) before the negative lookahead is required: without
" it, a plain \w\+\%(\.\)\@! backtracks -- on failure to match the full
" word (because a dot follows), the engine retries with \w\+ one character
" short, where the lookahead trivially passes, silently mis-highlighting a
" truncated prefix of the receiver. \> only matches at a real word
" boundary, so \w\+ has no shorter valid backtrack point and the whole
" match correctly fails on a receiver.
syn match clarusEventName "\%(\<on\>\s\+\%(\w\+\.\)\?\)\@<=\w\+\>\%(\.\)\@!"

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
