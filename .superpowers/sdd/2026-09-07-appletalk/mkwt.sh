#!/bin/sh
# mkwt.sh N -- create worktree /Users/andrew/repos/clarus-wt/tN on branch appletalk-tN from appletalk,
# replicate the gitignored symlinks (absolute), and print the path.
set -e
N=$1; ROOT=/Users/andrew/repos/clarus; WT=/Users/andrew/repos/clarus-wt/t$N
mkdir -p /Users/andrew/repos/clarus-wt
cd "$ROOT"
git worktree add -q -b appletalk-t$N "$WT" appletalk
ln -s /Users/andrew/repos/Retro68-build/toolchain "$WT/toolchain"
ln -s /Users/andrew/repos/Retro68 "$WT/Retro68"
ln -s /Users/andrew/mac/macplus "$WT/macplus"
ln -s "$ROOT/macplus2" "$WT/macplus2"
ln -s "$ROOT/snow" "$WT/snow"
ln -s "$ROOT/vasm" "$WT/vasm"
ln -s "/Users/andrew/Documents/Inside Macintosh - 1980s" "$WT/inside-macintosh-v1"
ln -s "/Users/andrew/Documents/Inside Macintosh - 1990s" "$WT/inside-macintosh-v2"
echo "$WT"
