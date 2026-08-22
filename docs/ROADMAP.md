# Clarus Roadmap

Living document — the authoritative record of sequencing and strategy
going forward. Updated 2026-08-15.

- Completed phases are archived verbatim in `docs/HISTORY.md`.
- Recorded-but-unscheduled follow-ups and phase debt: `docs/TODO.md`.
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

- `TestClarusCBakePathOnSnow` (opt-in, `CLARUS_SNOW_TESTS=1`, ~55m) is
  the only proof that `ClarusC.APPL`'s default bake path works on real
  hardware — re-run it manually after any change to `clarusc/bake.cla`
  or `clarusc/macgui.cla`; neither T1 nor T2 boots it.
- A green native UI boot is not proof that handle discipline is sound:
  the stale-master-pointer-across-compaction bug class has passed on
  heap-layout luck before (found six times so far — see HISTORY,
  runtime-ir-bake T2 blocker and the fallback-trigger-narrowing final
  fix wave). Re-derive master pointers after any allocating call.

## Where we are (2026-08-17)

Everything through the serial-connection phase is merged to `main`:

- **clarusc is the only compiler** — self-hosted (the Go compiler is
  deleted, tag `go-compiler-final`), bootstrapped from the committed C
  snapshot `clarusc/clarusc.c` with `cc` alone.
- **Both targets work**: host builds via C emission (`clarusc emit` +
  cc against `runtime/host`), native 68k `.APPL` binaries via direct
  emission (`emit68k`, no C, no Retro68).
- **`ClarusC.APPL`** compiles Clarus programs ON a Mac: baked runtime
  source catalog (`'CLFS'`) + baked runtime IR/object code (`'CLIR'`
  v7; first-compile load window cut ~4.4x, repeat compiles in a session
  skip verify+parse entirely), live progress UI (`on App.log`),
  recoverable errors (`attempt`/`abort`).
- Retro68/cprint's Mac lane is already demoted to an opt-in diagnostic
  (`CLARUS_CPRINT_MAC_TESTS=1`); the C printer's first-class role is
  host builds.
- **The fenced `connection` type** is real end to end, serial as its
  first transport, both lanes, Snow-hardware-proved (serial-connection
  phase, merged 2026-08-16).

**`correctness-cleanup` phase (an interleaved detour, not on the
language-usability list below) is COMPLETE — merged to `main` (ff
`48a4696..3a4c054`) and pushed 2026-08-18:** the About box
now shows real app info in unscripted runs; a labeled `popup` with a
narrow declared width no longer collapses to an unclickable box;
div-by-zero (and INT_MIN/-1) is pinned as a runtime error on both lanes;
a new heap-jiggle stress mode + stale-master-pointer audit (3 real bugs
fixed, `TestToolboxSuiteJiggleOn68k` gated native boot added) make that
bug class deterministically testable instead of heap-layout luck; the
`error`-return hidden-pointer ABI gap is closed; `get(k, dv)`'s
evaluation order now matches host on native; two memory leaks/fd-reuse
gaps are closed; three checker guards (widget-property fill-in-place,
`toBytes` receiver-kind keying, xrec forward-reference) are tightened;
the PBM icon parser accepts CR/CRLF; and the Bookmark Manager reference
erratum is fixed. Full detail: `STATUS.md` §1, or (once merged)
`docs/HISTORY.md`.

**`binary-files` phase (branch `binary-files`, 2026-08-22/23) is
COMPLETE — full T2 green, NOT YET merged (merge only on Andrew's
request):** closes item 1 below, "Next: language usability"'s next
item after serial. All eight 68kBBS language gaps closed in one phase
(`filehandle`, `connection` as a value, `text` binary accessors +
`crc16`, `string(n)`, the `toolbox/` include fallback, no more emit68k
big-temp ceiling) plus two compiler bugs found and fixed along the way
(`checkConstDecl` identical-redeclaration tolerance; a `--rtbake`
lowering crash for any `connection`/`filehandle`-using program, found
by this phase's own close-out T2 run and fixed by sourcing runtime-call
arg coercions from statically-known types instead of a checker
symbol-table lookup the baked-IR fast path never populates). Full
detail: `docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-22-binary-files/`.

## Roadmap

Focus (Andrew, 2026-08-15): make the tools more usable — expand the set
of Toolbox managers Clarus programs can reach, add the language features
that work needs, and retire old parts of the toolchain. The user-module
compilation cache is deliberately de-prioritized (see "Later").

### Next: language usability

In order:

1. **Binary streams and files** — proper reading and writing of binary
   data, filling the gaps in the existing support. DONE (`binary-files`
   phase, 2026-08-22/23): closed all eight 68kBBS language gaps —
   `filehandle` (positioned file I/O, both lanes, hardware-proved on
   System 6 via Mini vMac and System 7 via Snow), `connection` as an
   ordinary int value (params/locals/fields, not just a global), `text`
   LE/word/setter binary accessors + `crc16`, `string(n)`, the
   `toolbox/` include fallback (+ `--rtdir` in check-only mode), and
   emit68k's per-function big-temp pool (no more per-statement
   ceiling). Full T2 green on branch `binary-files`; not yet merged
   (merge only on Andrew's request).
2. **Serial ports** — controlling the ports and sending/receiving data.
   DONE (`serial-connection` phase, 2026-08-16): the fenced `connection`
   type is real end to end, serial as its first transport, both lanes
   (native SCC/Serial Driver + host TCP dev-lane substitute), acceptance-
   proved on Snow hardware; merged to `main` 2026-08-16.
3. **AppleTalk.**
4. **MacTCP.**

Environment note for 2-4: `snow/MacII.snoww` + its hdd image are
already configured (2026-08-15): AppleTalk on the Printer port, a
TCP listener (port 1984) bridging the Modem port, and a DaynaPORT SCSI
Ethernet adapter running a NATted MacTCP instance (the emulated Mac is
10.0.0.2, gateway 10.0.0.1). Caveat: on a modern Mac the emulator
cannot attach to a tap device, so it can't reach the real Ethernet —
AppleTalk runs over UDP instead, which means two Snow instances running
simultaneously can see each other over AppleTalk (the way to test
AppleTalk peer-to-peer).

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
- **Retire Go** — port the test-harness infrastructure to C and Make so
  the project no longer depends on a Go toolchain.

More recorded candidates (`yield`/cancel, reciprocal packers, parking
lot): `docs/TODO.md`.

## Process conventions that worked (for future sessions)

- Doc-first: reference updated and committed BEFORE implementation plans;
  the reference is the compiler's contract.
- Subagent-driven development with per-task review gates and a whole-branch
  final review (most capable model) + one consolidated fix wave; reviews
  probe (compile/run/ASan), not just read.
- Feature branches per plan; main stays green; reftest may be red mid-branch
  when the reference gains fences for unimplemented features (manifest
  regeneration is always the branch's final task).
