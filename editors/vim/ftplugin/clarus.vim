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
