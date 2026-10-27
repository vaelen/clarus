# Clarus

Clarus is a small, compiled, event-driven language for building native
System 6/7 applications on 68k Macintosh computers. Programs are written as
typed declarations — windows, menus, records — plus event handlers; there is
no `main`. The compiler emits C for host builds and native 68k code directly
for the Macintosh, and it also runs *on* the Mac, as `ClarusC.APPL`.

```rust
window Game {
    title: "Bounce"
    size: 200, 200
    canvas Board { at: 0, 0; fill: both; buffered }

    var x: fixed = 10.0
    var dx: fixed = 2.0
}

every 1 ticks {
    var g: Game = Game.front
    if g != nil {
        g.x = g.x + g.dx
        if g.x > 190.0 or g.x < 0.0 { g.dx = -g.dx }
        g.Board.clear()
        g.Board.fillCircle(int(g.x), 100, 8)
    }
}
```

The language is specified in [docs/clarus-language-reference.md](docs/clarus-language-reference.md).
Project status and sequencing live in [docs/ROADMAP.md](docs/ROADMAP.md).

## Status

- **Language reference** — complete v1 draft (the normative spec).
- **Host toolchain** — `scripts/clarus-run.sh` compiles and runs a program
  on the development machine, against a portable C runtime.
- **Self-hosting** — done. `clarusc`, the compiler written in Clarus
  (`clarusc/*.cla`), compiles itself: the three-stage bootstrap reaches a
  byte-identical fixed point, and the generated C snapshot is committed at
  `clarusc/clarusc.c` so the compiler can be rebuilt from any C compiler
  with no prior Clarus toolchain.
- **Macintosh target** — native 68k `.APPL` binaries (`clarusc build68k`, no
  C and no cross-compiler in the path), the full UI runtime — windows,
  menus, forms, tables, text editing, files — and `ClarusC.APPL`, which
  compiles Clarus programs on the Mac itself.
- **Networking** — `connection` over a serial port or AppleTalk (ADSP),
  `serviceBrowser` name discovery, and ATP request/response `service`s. A
  command-line host build is a real LocalTalk-over-UDP peer on the same
  wire as an emulated Mac, so the two ends can find and call each other.
- **Toolbox catalog** — `toolbox/*.cla` holds curated Inside Macintosh trap
  declarations for programs that need to reach past the language's own
  abstractions; see [docs/clarus-toolbox-cookbook.md](docs/clarus-toolbox-cookbook.md).
- **Next** — MacTCP.

## Building

A C compiler is the only prerequisite. Bootstrap `clarusc` from the
committed snapshot:

```sh
cc -I runtime/host -o clarusc clarusc/clarusc.c runtime/host/rt.c

./clarusc check FILE...               # type-check only
./clarusc build -o PROG FILE...       # host executable (runs cc itself)
./clarusc build68k -o APP.bin FILE... # native 68k Mac app (MacBinary)
```

Day to day, one script does the bootstrap, the emission, the C compile and
the run:

```sh
scripts/clarus-run.sh FILE.cla [-- args...]
```

The test gates are two more scripts — the first after every change, the
second before merging:

```sh
scripts/test-task.sh    # ~1-2 minutes
scripts/test-merge.sh   # ~15 minutes; needs the emulator
```

## Installing

`make install` installs `clarusc` the way other compilers are installed:
on `PATH`, finding its own runtime, with no `--rtdir` needed.

```sh
make install                                    # PREFIX=/usr/local
make install PREFIX=/usr DATADIR=/usr/share/clarus
make install DESTDIR=/tmp/pkgroot PREFIX=/usr   # staging, for packagers
make uninstall                                  # same variables
```

To install as root, build as yourself first and pass `sudo make install`
the SAME `PREFIX`/`DATADIR`/`CC` (sudo strips the environment, and a
mismatch rebuilds `clarusc` as root, leaving root-owned files in
`build-run/`):

```sh
make install-bin PREFIX=/usr
sudo make install PREFIX=/usr
```

| Variable  | Default                      | What it sets                                |
|-----------|------------------------------|---------------------------------------------|
| `PREFIX`  | `/usr/local`                 | the base of the four paths below            |
| `BINDIR`  | `$(PREFIX)/bin`              | where `clarusc` goes                        |
| `DATADIR` | `$(PREFIX)/share/clarus`     | `runtime/clarus`, `runtime/host`, `toolbox` |
| `DOCDIR`  | `$(PREFIX)/share/doc/clarus` | language reference, changelog, cookbook     |
| `MANDIR`  | `$(PREFIX)/share/man`        | the `clarusc(1)` page, in `man1/`           |
| `DESTDIR` | (empty)                      | a staging root prefixed to every path       |
| `CC`      | `cc`                         | builds `clarusc`; also its default compiler |

`DATADIR` and `CC` are baked into the installed binary (`DESTDIR` is
not), so `make install` rebuilds `clarusc` when either changes. An
install replaces the previous version's runtime and toolbox files;
there is one installed version at a time. After installing, `man
clarusc` documents every command, option and environment variable
(FreeBSD keeps local pages in `/usr/local/man`: pass
`MANDIR=/usr/local/man`).

### Commands

| Command                                   | What it does                                             |
|-------------------------------------------|----------------------------------------------------------|
| `clarusc check FILE...`                   | type-check only                                          |
| `clarusc FILE...`                         | the same, plus a stderr note that nothing was built      |
| `clarusc build -o PROG FILE...`           | a host executable (`--keep-c` keeps the generated C)     |
| `clarusc build68k -o APP.bin FILE...`     | a native 68k Mac application, as MacBinary               |
| `clarusc emit -o OUT.c FILE...`           | the generated C only                                     |
| `clarusc emit68k ...`                     | deprecated alias for `build68k` (warns on stderr)        |
| `clarusc --version`                       | print the version                                        |

`-o` without a command does not build. Every command that compiles
takes `--rtdir DIR`.

`clarusc build` writes the C to a temporary file and runs
`$CC $CFLAGS -I <rtdir>/../host -o PROG <tmp>.c <rtdir>/../host/rt.c`
directly, never through a shell. `CC` from the environment wins when it
is non-empty; otherwise the compiler baked in at install time (`cc`).
`CFLAGS` from the environment, if set (even to empty), is split on
spaces and tabs with no quote processing; otherwise `-O1`.

### Finding the runtime

Every command looks for the `runtime/clarus/` directory in this order,
taking the first whose files are actually there:

1. `--rtdir DIR`;
2. a `runtime/clarus/` directory in the current directory or any parent
   (so inside this repository the working tree always wins);
3. `$CLARUS_DATADIR/runtime/clarus/`, where `CLARUS_DATADIR` names a
   share directory such as `/usr/share/clarus`;
4. the installed `DATADIR` baked into `clarusc`.

`include "toolbox/..."` resolves against the `toolbox/` directory next
to whichever `runtime/` was found. To try an uninstalled checkout from
another project, pass `--rtdir /path/to/clarus/runtime/clarus/` or set
`CLARUS_DATADIR=/path/to/clarus`.

## Repository layout

| Path        | Contents                                                                   |
|-------------|----------------------------------------------------------------------------|
| `docs/`     | Language reference, cookbook, roadmap, and history                         |
| `clarusc/`  | The self-hosted compiler, written in Clarus, plus its committed C snapshot |
| `runtime/`  | The Clarus and C runtime modules spliced into every build                  |
| `toolbox/`  | Curated Inside Macintosh trap declarations, per manager                    |
| `examples/` | Complete sample programs (`atalkclock`, `texteditor`, `bookmarks`, …)      |
| `tests/`    | The test harness: a Make + POSIX-shell runner plus its C tools             |
| `testdata/` | Golden tests: valid programs, diagnostics, runtime behavior                |

## License

MIT — see [LICENSE](LICENSE).

Copyright 2026, Andrew C. Young <andrew@vaelen.org>
