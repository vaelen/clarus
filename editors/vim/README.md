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
