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
- **Macintosh target** — native 68k `.APPL` binaries (`clarusc emit68k`, no
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

./clarusc FILE...               # type-check only
./clarusc emit -o OUT.c FILE... # emit C for a host build
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

## Repository layout

| Path | Contents |
|---|---|
| `docs/` | Language reference, cookbook, roadmap, and history |
| `clarusc/` | The self-hosted compiler, written in Clarus, plus its committed C snapshot |
| `runtime/` | The Clarus and C runtime modules spliced into every build |
| `toolbox/` | Curated Inside Macintosh trap declarations, per manager |
| `examples/` | Complete sample programs (`atalkclock`, `texteditor`, `bookmarks`, …) |
| `tests/` | The test harness: a Make + POSIX-shell runner plus its C tools |
| `testdata/` | Golden tests: valid programs, diagnostics, runtime behavior |

## License

MIT — see [LICENSE](LICENSE).

Copyright 2026, Andrew C. Young <andrew@vaelen.org>
