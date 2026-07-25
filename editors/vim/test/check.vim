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
