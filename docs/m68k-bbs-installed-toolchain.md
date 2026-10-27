# m68k-bbs: moving to the installed Clarus toolchain

For the agent working in `~/repos/m68k-bbs`. Clarus can now be installed
like any other compiler: `clarusc` goes on `PATH` and finds its own
runtime and `toolbox/` catalog, so the pinned copy in `bin/` and
`vendor/` is no longer needed. This document lists every change to make
in m68k-bbs. Follow m68k-bbs's own CLAUDE.md for commits (short
messages, no AI trailers).

There is one installed Clarus version at a time and every project uses
it. There is no per-project version pin any more; the trade-off is that
upgrading Clarus upgrades the BBS's compiler too.

## 1. Install (and upgrade) Clarus

From the Clarus checkout:

```sh
cd ~/repos/clarus
git pull                       # upgrading: get the new version first
make install-bin               # build the release clarusc as yourself
sudo make install              # copy it into /usr/local
```

That installs:

```
/usr/local/bin/clarusc
/usr/local/share/clarus/runtime/clarus/*.cla
/usr/local/share/clarus/runtime/host/rt.c, rt*.h, rt*.inc
/usr/local/share/clarus/toolbox/*.cla
/usr/local/share/doc/clarus/clarus-language-reference.md
/usr/local/share/doc/clarus/clarus-language-changelog.md
/usr/local/share/doc/clarus/clarus-toolbox-cookbook.md
```

A different location is `make install PREFIX=$HOME/.local` (no `sudo`;
put `$HOME/.local/bin` on `PATH`). `DATADIR` and `DOCDIR` can be set on
their own; the data directory is baked into the installed `clarusc`, so
it finds its runtime wherever it was installed. Upgrading is the same
three commands: `make install` replaces the old runtime and toolbox
files rather than adding to them. `sudo make uninstall` (same variables)
removes it all.

Check it: `command -v clarusc` and `clarusc --version`.

## 2. Delete `bin/` and `vendor/`

```sh
rm -rf bin                     # untracked (.gitignore has bin)
git rm -r vendor               # 77 tracked files
```

Also drop the `bin/` entry from `.gitignore` if nothing else lives
there.

## 3. `scripts/build.sh`

Replace the three `bin/clarusc emit68k --rtdir vendor/runtime/clarus/`
lines with `build68k` and no `--rtdir`:

```sh
clarusc build68k -o build/68kBBS.bin bbs.cla
clarusc build68k -o build/68kBBSConfig.bin bbsconfig.cla
clarusc build68k -o build/68kBBSBench.bin bench.cla
```

`emit68k` still works but now prints
`clarusc: 'emit68k' is deprecated; please use 'build68k'` on stderr.
Update the header comment ("PINNED toolchain (bin/clarusc + vendor/
...)") to say it uses the installed `clarusc`. `scripts/deploy.sh` only
calls `scripts/build.sh` and needs no change.

## 4. `scripts/test.sh`

Replace the `emit` + `cc` pair with one `build`:

```sh
clarusc build -o "$D/prog" "$t"
```

and delete the `cc -O1 -I vendor/runtime/host ...` line. `clarusc build`
emits the C to a temporary file and runs the C compiler itself (no
shell): `$CC` if set and non-empty, else the compiler baked into
`clarusc` at install time (`CLARUS_CC`, the install's `CC`, normally
`cc`); `$CFLAGS` if set (split on spaces/tabs; set but empty means no
flags at all), else `-O1` — the same flags the script used. A check
failure exits nonzero without running the C compiler, so `set -e` still
stops on it. Fix the header comment too.

## 5. The other scripts that use the pin

The same rewrite applies wherever `bin/clarusc emit` is followed by
`cc ... vendor/runtime/host/rt.c`:

| Script                  | Becomes                                                                                  |
|-------------------------|------------------------------------------------------------------------------------------|
| `scripts/ftn-e2e.sh`    | `clarusc build -o "$WORK/harness" "$WORK/harness.cla"`                                   |
| `scripts/xmodem-e2e.sh` | `clarusc build -o "$WORK/harness" "$WORK/harness.cla"`                                   |
| `scripts/boardtool.sh`  | `CFLAGS="-O1 -w" clarusc build -o "$ROOT/build/boardtool" "$ROOT/scripts/boardtool.cla"` |
| `scripts/basic-host.sh` | `--build`: `clarusc build -o "$ROOT/build/basic-host" "$ROOT/basic/basic-host.cla"`      |

`boardtool.sh` passed `-w` to `cc`; `CFLAGS` replaces the default
`-O1`, so spell both.

`basic-host.sh --export` still needs `clarusc emit` (it ships `main.c`)
plus the host runtime files, which now live in the installed data
directory. Point `HOST` there:

```sh
HOST="${CLARUS_DATADIR:-/usr/local/share/clarus}/runtime/host"
emit() { clarusc emit -o "$1" "$ROOT/basic/basic-host.cla"; }
```

(`/usr/local/share/clarus` is the default install; anyone who installed
elsewhere sets `CLARUS_DATADIR`, which `clarusc` honours as well.)

## 6. Checking only

```sh
clarusc check bbs.cla
```

A bare `clarusc bbs.cla` also still only checks, but first prints
`clarusc: checking only; use 'clarusc build' or 'clarusc build68k' to
produce an executable` on stderr; `check` prints nothing extra. `-o`
without a command does not build.

## 7. Toolbox includes

`include "toolbox/osutils.cla"` (`bbs.cla:40`) keeps working: a
`toolbox/` include with no file next to the includer resolves against
the installed `toolbox/`, next to the installed `runtime/`. Change that
line's trailing comment, `// ... (via --rtdir)`, to say so.

## 8. Docs

`docs/clarus-language-reference.md` and
`docs/clarus-language-changelog.md` are tracked copies the old refresh
recipe overwrote. The installed versions are in
`/usr/local/share/doc/clarus/` (`$(DOCDIR)`), along with
`clarus-toolbox-cookbook.md`, and always match the installed compiler.
Either:

- delete the copies (`git rm`) and point at the installed ones in
  CLAUDE.md and README.md, or
- replace them with symlinks to the installed copies, e.g.
  `ln -sf /usr/local/share/doc/clarus/clarus-language-reference.md docs/`,
  so existing `docs/...` references keep working.

Update CLAUDE.md's opening paragraph ("a pinned copy of the compiler
repo's ... matching the pinned toolchain below") and its Layout bullets
(`bin/`, `vendor/` — pinned compiler...; `docs/` — language reference
...) to match whichever you choose.

## 9. CLAUDE.md "Compiler" section and README "Building"

Rewrite CLAUDE.md's "Compiler" section:

- drop the "fully pinned toolchain" description, the `bin/clarusc` /
  `vendor/` bullets, and the whole pin-refresh recipe (the
  `(cd ../clarus && cc ...) && cp ...` line);
- drop the "Always pass `--rtdir vendor/runtime/clarus/`" rule and its
  explanation;
- say the compiler is the installed `clarusc` (installed from
  `~/repos/clarus` with `make install`, upgraded by pulling and
  reinstalling), and list the commands:

  ```sh
  clarusc check bbs.cla # check only
  scripts/build.sh      # 68k Mac app -> build/68kBBS.bin (MacBinary)
  scripts/test.sh       # run every tests/*.cla on the host lane
  scripts/deploy.sh     # build + refresh snow/hdd2.img + restart Snow
  ```

- keep the `CLARUS_SERIAL_MODEM` paragraph;
- the "live-repo wrapper scripts" sentence becomes section 10 below.

In README.md's "Building", the requirement becomes "an installed Clarus
(`clarusc` on `PATH`, see the Clarus repo's README) plus `cc` for the
host-lane tests". The "Compiler limitations" section's "is in the pinned
toolchain" wording should say "installed" instead.

## 10. Trying an uninstalled Clarus tree

To test the BBS against a Clarus checkout that is not installed (a
feature branch, say), point the installed or the checkout's compiler at
that tree's runtime, either way:

```sh
clarusc build68k --rtdir ~/repos/clarus-branch/runtime/clarus/ -o build/68kBBS.bin bbs.cla
CLARUS_DATADIR=~/repos/clarus-branch scripts/build.sh
```

`clarusc` looks for its runtime in this order, taking the first that is
really there: `--rtdir DIR`; a `runtime/clarus/` directory in the
current directory or a parent; `$CLARUS_DATADIR/runtime/clarus/`; the
installed data directory. So a `runtime/clarus/` directory in the
current directory or any of its parents beats the install.
`CLARUS_DATADIR` names the directory that
holds `runtime/` and `toolbox/` — for a checkout, the checkout root.
`toolbox/` includes follow the same tree. The runtime must match the
compiler binary: a newer runtime with an older `clarusc` (or the
reverse) can fail with `undefined: rt...`, so for a real branch test
build that branch's compiler too (`make -j tools bootstrap` there, then
use its `build-run/clarusc-current` with `--rtdir`), or install it.
Note that `CLARUS_DATADIR=<checkout>` pairs the INSTALLED compiler with
that checkout's runtime; it does not test the checkout's compiler. To
test compiler changes, use the checkout's own compiler
(`<checkout>/build-run/clarusc-current --rtdir <checkout>/runtime/clarus/`)
or its `scripts/clarus-run.sh`.
