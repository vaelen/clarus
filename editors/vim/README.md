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

## Encoding

`.cla` source files are Mac OS Roman (MacRoman) encoded, not UTF-8 (see
Chapter 2, "Source Encoding" in `docs/clarus-language-reference.md`) — so
they stay editable on a period Mac. Vim's `fileencodings` autodetection
does not reliably guess MacRoman on read, so open/save `.cla` files
explicitly:

    :e ++enc=macroman file.cla
    :w ++enc=macroman

(No autocmd is set up for this — an fread-time `fileencodings` guess is
not reliable enough to do automatically here, so it's a manual step
instead of fragile magic.)

## Known tradeoffs

- `mod` highlights as an operator everywhere (it is not reserved).
- Type names highlight everywhere, not only in type positions.
- Property keywords (`size`, `at`, ...) highlight only when followed by
  `:`; a record field reusing such a name colors as a label.
- Table-column lines (`column "Hdr" shows field width fill`) are not
  specially highlighted (safe default; no examples use tables yet).
- `include` highlights everywhere, though the language treats it as
  contextual and top-of-file only.
