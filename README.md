# Clarus

Clarus is a small, compiled, event-driven language for building native
System 6/7 applications on 68k Macintosh computers. Programs are written as
typed declarations — windows, menus, records — plus event handlers; there is
no `main`. The compiler emits C.

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
- **Host toolchain** — `clarus check` / `build` / `run` work on the host via
  a portable C runtime.
- **Self-hosting** — done. `clarusc`, the compiler written in Clarus
  (`clarusc/*.cla`), compiles itself: the three-stage bootstrap reaches a
  byte-identical fixed point, and the generated C snapshot is committed at
  `clarusc/clarusc.c` so the compiler can be rebuilt from any C compiler
  with no prior Clarus or Go toolchain.
- **Next** — the actual Macintosh target (Toolbox backend), then memory +
  forms runtime, networking, and finally building Clarus programs *on* a Mac.

## Building

The host toolchain requires Go and a C compiler:

```sh
go build -o clarus ./cmd/clarus

./clarus check FILE...          # type-check only
./clarus build [-o OUT] FILE... # compile to a host binary
./clarus run FILE...            # compile and run
```

To bootstrap `clarusc` from the committed snapshot with no Go at all:

```sh
cc -I runtime/host -o clarusc clarusc/clarusc.c runtime/host/rt.c
./clarusc [emit -o OUT.c] FILE...
```

## Repository layout

| Path | Contents |
|---|---|
| `docs/` | Language reference and roadmap |
| `tests/` | The test harness: a Make + POSIX-shell runner plus its C tools |
| `clarusc/` | The self-hosted compiler, written in Clarus, plus its committed C snapshot |
| `testdata/` | Golden tests: valid programs, diagnostics, runtime behavior |

## License

MIT — see [LICENSE](LICENSE).

Copyright 2026, Andrew C. Young <andrew@vaelen.org>
