# Installed toolchain — design

Status: implemented (2026-10-27)

## Intent

Today a Clarus project on a Linux host carries its own pinned compiler:
m68k-bbs has `bin/clarusc` plus `vendor/runtime/{clarus,host}` and
`vendor/toolbox`, passes `--rtdir vendor/runtime/clarus/` on every call,
runs `cc` against `vendor/runtime/host/rt.c` itself, and refreshes the
pin with a long `cp` chain. Andrew wants Clarus installed once into a
shared location and used **the way other compilers are used**: `clarusc`
on `PATH`, finding its own standard library, and producing a host
executable in one step the way `gcc -o prog foo.c` does.

## Goals

1. An install layout: binary in `<prefix>/bin`, runtime + toolbox
   catalog in a shared data directory (`<prefix>/share/clarus`), docs in
   `<prefix>/share/doc/clarus`.
2. clarusc finds that data directory without `--rtdir`, via a
   flag → environment variable → built-in default chain. The default is
   chosen **when clarusc itself is built** (so a FreeBSD port, a Debian
   package and a `/usr/local` install can each bake their own).
3. A `build` command that produces a host executable directly (clarusc
   runs the C compiler), and a `check` command; `emit68k` becomes
   `build68k`.
4. `make install` / `make uninstall` with the usual `PREFIX`, `DATADIR`,
   `DESTDIR`, `CC` variables.
5. After the installed compiler works, a hand-off document describing
   the m68k-bbs changes (Andrew gives it to the BBS project's agent).

## Non-goals

- **No side-by-side versions.** One installed version; every project
  uses whatever is installed (Andrew's decision). No per-project version
  pin, no version-suffixed directories.
- **Not changing m68k-bbs** in this work — only writing the hand-off doc.
- **Not renaming `emit68k` across the repo's scripts/tests** in this
  work — a later cleanup does that (Andrew's decision). This work only
  adds the alias + deprecation line.
  *Amended:* Andrew later (2026-10-27) folded the invocation rename
  into this work (see the plan, Task 3).
- **No change to ClarusC.APPL** (the Mac-resident compiler). It bakes the
  runtime into itself; none of the lookup or install machinery applies
  to it. Everything below is host-only.
- No configure script, pkg-config file, man page, or prebuilt `librt.a`.
  The installed host runtime stays C source compiled per program, as
  today.
- No installed `.clir` runtime bake (a possible later speed-up).

## Anti-goals

- In-repo development and the test suite must behave exactly as now:
  inside the repo, clarusc keeps finding `runtime/clarus/` by its
  current upward search, and `make t1`/`t2` stay green.
- A `build` must never go through a shell: paths with spaces or quotes
  must not break it, and nothing from the command line is
  shell-interpreted.

## Command-line surface (decided)

| Invocation                                  | Behavior                                                                         |
|---------------------------------------------|----------------------------------------------------------------------------------|
| `clarusc FILE...`                           | check only, as today — but FIRST prints an info line to stderr (below)           |
| `clarusc check FILE...`                     | check only, no info line                                                         |
| `clarusc build -o PROG FILE...`             | NEW: host executable (see "build")                                               |
| `clarusc build68k -o APP.bin FILE...`       | today's `emit68k`, renamed; identical flags and output                           |
| `clarusc emit68k ...`                       | alias for `build68k`, plus a stderr deprecation line (below)                     |
| `clarusc emit -o OUT.c FILE...`             | unchanged                                                                        |
| `clarusc appinfo`, `--bake-ir`, `--version` | unchanged                                                                        |

- A bare `-o` with no command does **not** build (Andrew reversed his
  earlier "like gcc" answer): no command means `check`.
- The bare-check info line is printed before the check runs, on stderr
  (via `log`, which the host runtime writes to stderr), e.g.
  `clarusc: checking only; use 'clarusc build' or 'clarusc build68k' to
  produce an executable`. Exact wording is the builder's.
- The `emit68k` line is on stderr, e.g.
  `clarusc: 'emit68k' is deprecated; please use 'build68k'`. Then it
  runs exactly as `build68k`.
- `check` accepts what bare check accepts today (`--rtdir`, files).
- Usage/help text is updated to list `check`, `build`, `build68k`
  (`emit68k` omitted or marked deprecated).

### `build`

`clarusc build -o PROG [--rtdir DIR] [--keep-c] FILE...`

1. Runs the same pipeline as `emit` (check, then emit C). Diagnostics →
   nonzero exit, no C compiler invoked.
2. Writes the C to a uniquely named temp file (under `$TMPDIR`, else
   `/tmp`).
3. Runs the C compiler as a direct argv exec (no shell):
   `$CC $CFLAGS -I <rtdir>/../host -o PROG <tmp>.c <rtdir>/../host/rt.c`
   where `<rtdir>` is the resolved `runtime/clarus/` directory (so the
   host runtime is always the one matching the `.cla` runtime in use —
   in-repo that is `runtime/host`, installed it is
   `$(DATADIR)/runtime/host`).
   - `CC`: environment variable if set and non-empty, else the
     build-time default (`cc` unless the clarusc build said otherwise).
   - `CFLAGS`: environment variable if set, split on whitespace (no
     quote processing — my call; a builder may add quoting only if it is
     cheap), else `-O1` (today's flag).
4. Deletes the temp file (kept, and its path printed to stderr, with
   `--keep-c`). Exit status: 0 on success; the C compiler's nonzero
   status propagates as a nonzero clarusc exit with a one-line
   diagnostic naming the command that failed.

`--testapi` is not offered on `build` (it is a suite-internal flag).

## Locating the data directory (decided shape, my ordering)

clarusc resolves `<rtdir>` (the `runtime/clarus/` directory; toolbox is
still found as `<rtdir>/../../toolbox/`, unchanged) in this order:

1. `--rtdir DIR` — as today.
2. Today's upward search from the current directory (`findRtDir`,
   `clarusc/drive.cla`). First after `--rtdir` so the working tree
   always beats an install when compiling inside the repo. *My call.*
   Consequence: a project with its own `runtime/clarus/` at or above its
   cwd uses that — acceptable and arguably right.
3. `CLARUS_DATADIR` environment variable, naming the **share directory**
   (e.g. `/usr/share/clarus`); rtdir = `$CLARUS_DATADIR/runtime/clarus/`.
   Name is my call (matches the make variable).
4. The built-in default, `CLARUS_DATADIR` as a C preprocessor define at
   clarusc build time, defaulting to `/usr/local/share/clarus` when not
   defined. Defined as the empty string, it means "no default" (step 4
   skipped).

A candidate is accepted only if the probe file exists, as `findRtDir`
does today. Resolution stays **lazy** (*my call*): a missing runtime is
an error only where it is today — when a runtime module or toolbox
include is actually needed — and that error now names what was tried and
how to fix it (`--rtdir` / `CLARUS_DATADIR`). A self-contained `check`
with nothing installed keeps working.

The chain applies to every command that resolves the runtime today:
`check`, `build`, `build68k`/`emit68k`, `emit`, `appinfo`, `--bake-ir`.
Installed `build68k` must work from a project directory outside the
repo (the m68k-bbs hand-off depends on it); any other repo-relative
lookup on that path is a bug to fix. `bkFindClarusC` (the `--rtbake`
stamp check, upward search for `clarusc/clarusc.c`) is only on the
`--rtbake` path, which an installed user does not take; leave it.

**Test isolation** (*my call*): the dev compilers the Makefile builds
(`clarusc-snapshot`, `clarusc-current`) get `-DCLARUS_DATADIR='""'` (no
default), and the Makefile `unexport`s `CLARUS_DATADIR`, so an install
on the machine or an exported variable in Andrew's shell can never
change what a test sees. `tests/lib.sh` is frozen and is not touched.
*Amended:* folding the rename in (2026-10-27, above) authorized the
`emit68k` → `build68k` edit to `tests/lib.sh`'s helpers (the plan, Task 3).
`scripts/clarus-run.sh` keeps today's behaviour too (no default baked).

### Build-time defaults

clarusc is built by `cc` from `clarusc/clarusc.c` + `runtime/host/rt.c`,
so build-time defaults are C defines, read by host-only runtime
routines that clarusc calls through `external func` declarations:

- `-DCLARUS_DATADIR='"/usr/share/clarus"'` (default
  `/usr/local/share/clarus`)
- `-DCLARUS_CC='"cc"'` (default `cc`)

The lookup chain is driven from the host front end (`main.cla`) through
a seam the shared `drive.cla`/`bake.cla` code calls, the same pattern as
`feExpectedStamp`; ClarusC.APPL's `macgui.cla` implements the seam with
today's behaviour. ClarusC.APPL must stay **behaviourally** unchanged;
its bytes may move (*my call*). If `drive.cla`, `bake.cla` or
`macgui.cla` change, the plan includes the standing
`CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` boot.

Where these routines and their Clarus declarations live is the
builder's call, following the existing host-only `rt_ext_*` pattern in
`runtime/host/rt_ext_host.inc`. They are compiled into every host
program (rt.c is shared) but only clarusc calls them.

### New host runtime capability: run a program

The host runtime can read environment variables but cannot start a
process. `build` needs one new host-only routine: run a program with an
argument vector, wait, return its exit status. Implemented with
`posix_spawnp` (or `fork`/`execvp`), never `system()`/`popen()`.
Interface shape (how the argv list crosses the extern boundary) is the
builder's call. Mac lanes never declare or reference it. Plus an
environment-variable read if the existing host code doesn't already
expose a general one to Clarus (it has only fixed-name `getenv`s today).

These are compiler-private. Whether they also become user-facing
language features is out of scope.

## Install (my call on the details)

New Makefile targets:

```sh
make install                                    # PREFIX=/usr/local
make install PREFIX=/usr DATADIR=/usr/share/clarus
make install DESTDIR=/tmp/pkgroot PREFIX=/usr   # staging, for packagers
make uninstall                                  # same variables
```

Variables: `PREFIX` (default `/usr/local`), `BINDIR`
(`$(PREFIX)/bin`), `DATADIR` (`$(PREFIX)/share/clarus`), `DOCDIR`
(`$(PREFIX)/share/doc/clarus`), `DESTDIR` (empty), `CC` (`cc`; also
baked in as `CLARUS_CC`).

`install`:

1. Builds a release clarusc **two-stage, like `bootstrap`** (*my
   call*): the snapshot compiler emits the working tree's
   `clarusc/main.cla` to C, and that C is compiled with
   `-DCLARUS_DATADIR="$(DATADIR)"` (the final path, NOT prefixed by
   `DESTDIR`) and `-DCLARUS_CC="$(CC)"` into its own file under
   `build-run/` (not `clarusc-current`, whose defines differ). So the
   installed compiler always matches the installed runtime files, from
   the same tree, whatever the snapshot's age. `install` depends on it;
   `sudo make install` after a plain `make` should not need to rebuild
   as root (the build target is separate from the copy).
2. Installs, under `$(DESTDIR)`:

```
$(BINDIR)/clarusc
$(DATADIR)/runtime/clarus/*.cla
$(DATADIR)/runtime/host/rt.c, rt*.h, rt*.inc     # not rt_*_test.c
$(DATADIR)/toolbox/*.cla
$(DOCDIR)/clarus-language-reference.md
$(DOCDIR)/clarus-language-changelog.md
$(DOCDIR)/clarus-toolbox-cookbook.md
```

`$(DATADIR)/runtime/clarus` and `$(DATADIR)/toolbox` keep their
repo-relative sibling shape so the existing `<rtdir>/../../toolbox/`
include fallback works unchanged. `install` uses plain `install -d` /
`install -m 644` / `-m 755` (POSIX; works on Linux and FreeBSD).
Install replaces the data directory's contents — stale files from an
older version must not linger (remove `$(DATADIR)/runtime` and
`$(DATADIR)/toolbox` before copying). `uninstall` removes exactly what
`install` put there.

The snapshot (`clarusc/clarusc.c`) still needs regenerating once the
compiler changes land, as for any compiler change (`clarus-run.sh` and
`selfhost/fixedpoint` depend on it), but `install` does not depend on
its freshness.

## Testing

New T1 scripts (POSIX sh, `tests/lib.sh` vocabulary). Suggested:

- `check`/bare-check: bare prints the info line on stderr and the same
  stdout/exit as before; `check` prints no info line.
- `emit68k` alias: same `.bin` bytes as `build68k`, deprecation line on
  stderr.
- `build`: builds and runs a hello-world; a failing check → nonzero, no
  output file; a path with a space in it works; a bogus `CC` → nonzero
  with a diagnostic; `--keep-c` keeps the file.
- install: `make install PREFIX=$WORK/inst` (no `DESTDIR`, so the baked
  default is the real path); then from a cwd outside the repo, with no
  `--rtdir` and no `CLARUS_DATADIR`, `clarusc build` a program that
  `include`s a `toolbox/` file and run it, and `clarusc build68k` a
  small UI program and check it produces a MacBinary; prove
  `CLARUS_DATADIR` overrides the default; `make uninstall` leaves
  nothing behind. Separately, `make install DESTDIR=$WORK/root
  PREFIX=/usr` puts files under `$WORK/root/usr/...` and the binary's
  baked default is `/usr/share/clarus` (checked without running from
  it, e.g. a resolution error message naming the path).
- The rtdir search order (each step wins over the later ones).

Existing tests must stay green with no golden changes. Any test that
asserts an empty stderr from bare check or `emit68k` will see the new
line; those are fixed in this work only if they turn red (the full
`emit68k` → `build68k` rename is the later cleanup).

## Docs

- `docs/clarus-language-reference.md` / changelog: command-line surface
  if the reference documents it; the changelog entry for the new
  commands.
- `CLAUDE.md` "Build and test": add `make install` and the new commands.
- `README` (if one covers usage): installing.

## Deliverable after the code: m68k-bbs hand-off doc

Once the installed compiler works, write a document for the BBS
project's agent describing what to change there: delete `bin/` and
`vendor/`, rewrite `scripts/build.sh` to `clarusc build68k`,
`scripts/test.sh` to `clarusc build` (no `cc`, no `--rtdir`), check-only
as `clarusc check`, how docs are found (`$(DOCDIR)` instead of copied
`docs/`), remove the pin-refresh recipe from its CLAUDE.md, and how to
install/upgrade Clarus. It goes to Andrew, not committed into
m68k-bbs. Location: `docs/m68k-bbs-installed-toolchain.md` in this repo
(*my call*; Andrew may prefer a scratch file).

## Left to the builder

- Exact wording of the info/deprecation/error lines.
- Extern names and Clarus-side placement of the new host routines.
- Temp-file naming.
- Test script names and grouping.
