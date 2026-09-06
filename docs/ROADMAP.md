# Clarus Roadmap

Living document — the authoritative record of sequencing and strategy
going forward. Updated 2026-09-05. Lists only unfinished work.

- Completed phases are archived verbatim in `docs/HISTORY.md`.
- Recorded-but-unscheduled debt and needed improvements: `docs/TODO.md`.
- Ideas and if-it-ever-bites levers, not debt: `docs/FUTURE.md`.
- `docs/clarus-language-reference.md` is the normative spec; where any
  other doc disagrees, the reference wins.
- Current-session state: `STATUS.md`. Per-task execution history lives in
  `.superpowers/sdd/*/progress.md` (gitignored scratch; git history is
  the durable record).

## Standing principles

**GUIDING PRINCIPLE (Andrew, 2026-08-07 — governs all future Toolbox work;
ratifies and extends the sunset follow-on):** any call into the Toolbox goes
through the appropriate `toolbox/*.cla` interface — runtime code included — to
unify the cprint and native backends and cut duplication. When a new feature
needs a new Toolbox function, enable the rest of that manager's interface at
the same time where feasible, rather than declaring one routine at a time.
Layering follows the 80/20 rule: the RUNTIME uses Toolbox calls directly, but
the majority of user code should never need to — most Toolbox routines hide
behind friendlier Clarus abstractions (e.g. cut/copy/paste is a simple
capability on text controls, not a Scrap Manager lesson), so a "standard"
application is written entirely through the lens of the Clarus language. The
catalog exists so users CAN drop to the Toolbox outside the common case, not so
they must. API-era discipline: prefer the Toolbox as defined by the 1980s
Inside Macintosh volumes (I–V; Volume VI covers System 7.0) — target System 6
features whenever possible, and gate any System 7-only feature behind a version
check (Gestalt) with a graceful fallback when the feature is absent.

**Standing rules:**

- `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (opt-in,
  ~55m) is the only proof that `ClarusC.APPL`'s default bake path works on
  real hardware — re-run it manually after any change to
  `clarusc/bake.cla` or `clarusc/macgui.cla`; neither T1 nor T2 boots it.
- A green native UI boot is not proof that handle discipline is sound:
  the stale-master-pointer-across-compaction bug class has passed on
  heap-layout luck before (found eight times so far — see HISTORY,
  runtime-ir-bake T2 blocker, the fallback-trigger-narrowing final fix
  wave, the filesystem-api phase's `rtUiTeWidestLine` find, caught
  only by the heap-jiggle gate on a byte-identical binary whose
  resource fork alone differed, and the 68k-call-result-release phase's
  `rtUiLdefDraw` find — that one on a binary whose only difference
  was an ADDED suite case, not even a rebuild of the buggy function
  itself). Re-derive master pointers after any allocating call.
- **`rtUiTableClick` scripted row math has no upper clamp** against the
  live row count — deliberate tripwire (runtime-ir-bake T2 blocker): a
  clamp would mask the next stale-master-pointer bug. Do not "fix"
  casually. (Moved here verbatim from `docs/TODO.md` at the close of the
  `language-runtime-cleanup` phase, 2026-09-06: it is a do-not-fix note,
  not work, and it was the only survivor of that section.)

## Where we are (2026-09-06)

Everything through the `compiler-cleanup` phase is merged to `main` and
pushed (`c5d447b`). In brief:

- **clarusc is the only compiler** — self-hosted (the Go compiler is
  deleted, tag `go-compiler-final`), bootstrapped from the committed C
  snapshot `clarusc/clarusc.c` with `cc` alone. The test harness is Make
  + POSIX shell + five small C tools; no Go anywhere (`go-retirement`).
- **Both targets work**: host builds via C emission (`clarusc emit` +
  cc against `runtime/host`), native 68k `.APPL` binaries via direct
  emission (`emit68k`, no C, no Retro68).
- **`ClarusC.APPL`** compiles Clarus programs ON a Mac: baked runtime
  source catalog (`'CLFS'`) + baked runtime IR/object code (`'CLIR'`),
  live progress UI, recoverable errors (`attempt`/`abort`).
- Retro68/cprint's Mac lane is an opt-in diagnostic
  (`CLARUS_CPRINT_MAC_TESTS=1`); the C printer's first-class role is
  host builds.
- **68kBBS's language asks are closed**: the `connection` type (serial
  transport, both lanes), `filehandle` + binary `text` accessors +
  CRC-16/16x/32, the `file.*` directory/catalog family, `= ptr` externs,
  `textview.scrollToEnd()`, the string-perf work (length-byte-only
  string-local init, inline `s[i]`/`s.length`, `text.clear()`/
  `reserve(n)`), and — from `language-runtime-cleanup` —
  **array-literal initializers** (`const t: int[256] = [...]`, a
  zero-cost constant-pool table), **window-owned menu sets** (the
  `menus:` window property, bar synced on front change), and
  **`file.openRF`** (a resource fork as an ordinary `filehandle`).
- `docs/TODO.md`'s "Compiler correctness / diagnostics" section was
  emptied by `compiler-cleanup`; the "Language features (needed)",
  "Compiler correctness / cleanup", "ABI / performance" and "Runtime /
  Toolbox robustness" sections were emptied by `language-runtime-cleanup`
  (24 entries, all disposed of; the one do-not-fix note moved into
  Standing rules above). What remains there is recorded debt.
- **The Mac-resident compiler (`ClarusC.APPL`) is on hold** (Andrew,
  2026-09-05). It works and stays tested, but its compile-time
  performance, the bake/CLIR machinery behind it, and its Snow boots
  are not being advanced; that debt sits in `docs/TODO.md`'s own
  "Compiler-on-Mac" section until the target resumes.

**`language-runtime-cleanup` is COMPLETE and NOT YET MERGED** (branch
`language-runtime-cleanup`; merging to `main` is Andrew's call). It
cleared 24 `docs/TODO.md` entries in two waves across 16 tasks, blessed
the goldens exactly twice, regenerated the bootstrap snapshot once, and
landed three user-visible features (array literals, `menus:`,
`file.openRF`) plus two compiler-correctness fixes nobody had asked for
(a native statement-temp aliasing bug that was releasing wrong pointers
in any program with `for x in f()`, and the `lst.pop().field` native
leak). Full T2 green apart from one 2-byte `CanvasIdle` FreeMem sample
under review at close-out; the Snow `clarusc_bake` gate PASSed. Details:
`docs/HISTORY.md`'s own entry.

Owed, not yet done (details in `docs/TODO.md`): a live run of the Snow
`macresident` scripts; a System 7 spot check of the filesystem-api
phase; the 68kbbs re-pin.

## Roadmap

Focus (Andrew, 2026-08-15): make the tools more usable — expand the set
of Toolbox managers Clarus programs can reach, add the language features
that work needs, and retire old parts of the toolchain. The user-module
compilation cache is deliberately de-prioritized (see "Later").

### Next: language usability

Items 1 (binary streams and files) and 2 (serial ports) of the original
list are DONE — `binary-files`, `transfer-crcs`, `filesystem-api`, and
`serial-connection` in `docs/HISTORY.md`. Remaining, in order:

1. **AppleTalk.**
2. **MacTCP.**

Environment note: `snow/MacII.snoww` + its hdd image are already
configured (2026-08-15): AppleTalk on the Printer port, a TCP listener
(port 1984) bridging the Modem port, and a DaynaPORT SCSI Ethernet
adapter running a NATted MacTCP instance (the emulated Mac is 10.0.0.2,
gateway 10.0.0.1). Caveat: on a modern Mac the emulator cannot attach to
a tap device, so it can't reach the real Ethernet — AppleTalk runs over
UDP instead, which means two Snow instances running simultaneously can
see each other over AppleTalk (the way to test AppleTalk peer-to-peer).

**Driving application: a BBS server** — first over the serial port,
later over MacTCP networking.

### Then

- **vdb database files** — easily create data files that follow the vdb
  specification (format details: the `vaelen/vdb` GitHub project) with a
  friendly Clarus surface, so defining a data file doesn't take a lot of
  boilerplate code.

### Later (no particular order)

- **Caching precompiled user code** — per-module precompiled artifacts
  for USER code, extending the runtime-side CLIR work. Staging notes:
  `docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`.
- **Retire Retro68** — the host-side cross-compiler keeps being built
  from clarusc-emitted C (`clarusc emit` + cc), but every on-Mac app
  builds through the native 68k backend (`emit68k`); the opt-in
  cprint/Retro68 Mac lane (kept until now as a cross-lane localization
  oracle) gets deleted.

More recorded candidates (`yield`/cancel, reciprocal packers, parking
lot): `docs/FUTURE.md`.

## Process conventions that worked (for future sessions)

- Doc-first: reference updated and committed BEFORE implementation plans;
  the reference is the compiler's contract.
- Subagent-driven development with per-task review gates and a whole-branch
  final review (most capable model) + one consolidated fix wave; reviews
  probe (compile/run/ASan), not just read.
- Feature branches per plan; main stays green; reftest may be red mid-branch
  when the reference gains fences for unimplemented features (manifest
  regeneration is always the branch's final task).
