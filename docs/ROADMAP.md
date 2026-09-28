# Clarus Roadmap

Living document — the authoritative record of sequencing and strategy
going forward. Updated 2026-09-28. Lists only unfinished work.

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

## Where we are (2026-09-28)

Everything through the `appletalk` phase is merged to `main` and pushed
(`6e6e3d4`). In brief:

- **clarusc is the only compiler** — self-hosted (the Go compiler is
  deleted, tag `go-compiler-final`), bootstrapped from the committed C
  snapshot `clarusc/clarusc.c` with `cc` alone. The test harness is Make
  + POSIX shell + six small C tools; no Go anywhere (`go-retirement`).
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

**`language-runtime-cleanup` is COMPLETE and MERGED to `main`**
(fast-forward, 2026-09-06 morning, merge tip `d36e728`; the status line
here had lagged the merge until the evening close-out). It
cleared 24 `docs/TODO.md` entries in two waves across 16 tasks, blessed
the goldens exactly twice, regenerated the bootstrap snapshot once, and
landed three user-visible features (array literals, `menus:`,
`file.openRF`) plus two compiler-correctness fixes nobody had asked for
(a native statement-temp aliasing bug that was releasing wrong pointers
in any program with `for x in f()`, and the `lst.pop().field` native
leak). **Full T2 green** (one clean `scripts/test-merge.sh` on the final
tree, every stage) and **Snow bake gate PASS in 1656s** (27.6 min, all
six subcases) via the new exit-trailer probe that replaced the gate's
fixed 55-minute settle timer. Details: `docs/HISTORY.md`'s own entry.

**`native-array-return-and-fileh-guards` is COMPLETE and MERGED to
`main`** (fast-forward, 2026-09-06 19:49, `main` = `d947f9a`; pushed
since, with the `appletalk` merge). It cleared the five entries `language-runtime-cleanup`
had left behind, in six tasks across three waves: fixed arrays of scalar
elements are now a legal native return type (one predicate,
`cgRetNeedsHidden`, sharing `cgParamByRef`'s boundary, so the return ABI
and the parameter ABI have the same edge); handle-bearing fixed arrays
get named diagnostics instead of the generic value-context abort on both
the parameter and the return path; `cg_init_globals` no longer stores
zeros the startup sweep already wrote; `file.rename("", x)` is refused
before the trap on both lanes instead of reaching `PBHRenameSync` as a
volume rename; and the host AppleDouble sidecar honours `$TMPDIR`, is
fsynced by `flush()`, and records a failed write-back at `close`. The
core suite is 83 cases (the new `ArrReturn`), and 49 `testdata/cg68k/*.s`
goldens were blessed — two new, 27 pure `cg_init_globals` deletions, 20
repacked by the 32 KB segment packer with equivalence verified unit by
unit in review. That emptied `docs/TODO.md`'s "Compiler correctness /
cleanup" and "Runtime / Toolbox robustness" sections; the Compiler
section is DELETED, and the Runtime section was re-created at close-out
for one new entry (the sidecar shrink-between-`fstat`-and-copy path the
final review surfaced), alongside two test nits under the test-coverage
gaps. What remains in that file is the Serial / connection group, the
test-coverage gaps, that one Runtime entry, and the on-hold
Compiler-on-Mac section. Full T2 green at the tip (`scripts/test-merge.sh` PASS in 859s
on `d4cd7c1`, after the deferred-minors wave: selfhost 179s, mactest
648s with `coresuite_68k` 83/83 and `toolbox_68k` `LeakCheck` on
hardware, bake full corpus 2s); the bootstrap snapshot was regenerated
three times on the branch and reproduces itself. Details: `docs/HISTORY.md`'s
own entry.

**`appletalk` is COMPLETE and MERGED to `main`** (fast-forward,
2026-09-07, `main` = `6e6e3d4`, pushed). Clarus programs now discover
services with `serviceBrowser`, answer and make ATP requests with the new
`service` resource, and open ADSP streams as `connection`s with
`listener` accepting them — natively on real LocalTalk, and, for
discovery and RPC, on the host as a genuine LocalTalk-over-UDP peer on
the same wire an emulator is on. It also cleared the `serial-connection`
phase's two carry-ins (host `stdio`/`pty` transports, `every` timers in
the host CLI pump). Full T2 green (1350 s), with `adsp_68k` 12/12 and
`toolbox_68k` 40/40 on hardware. Details: `docs/HISTORY.md`'s own entry.

Owed, not yet done (details in `docs/TODO.md`): a live run of the Snow
`macresident` scripts; a System 7 spot check of the filesystem-api
phase; the 68kbbs re-pin.

## Roadmap

Focus (Andrew, 2026-08-15): make the tools more usable — expand the set
of Toolbox managers Clarus programs can reach, add the language features
that work needs, and retire old parts of the toolchain. The user-module
compilation cache is deliberately de-prioritized (see "Later").

### Now: the SE memory program (2026-09-27)

Make `ClarusC.APPL` compile a small program on a 4 MB Macintosh SE
under System 6 (today it needs ~14 MB of heap, 1.56 MB of code and a
729 KB stack). Six waves, 0 (measurement), 1 (lifetimes), 2
(representation), 3 (narrow scalars: `uint8`/`int16`/`uint16`,
2-byte enums, serializer v2), 4 (lazy runtime library), and 5 (code
and stack: `segment` directive, overlays), then a go/no-go on separate
compilation + a linker. Program design (start here, including from a
fresh session): `docs/superpowers/specs/2026-09-27-se-memory-program-design.md`;
measured analysis:
`docs/superpowers/specs/2026-09-27-se-memory-footprint-findings.md`.
- **Wave 0 (measurement): merged** (branch `se-wave0-measurement`,
  2026-09-28). The host memory gate `tests/memgate/` is in T1 at an
  11,789,468-byte `bookmarks --rtbake` baseline. The SE app space is
  3808 KB, which gives ClarusC a heap target of about 2221 KB. The IIcx
  per-phase baseline and the calibration are in the program design's
  §9.1 and in `docs/HISTORY.md`.
- **Wave 1 (lifetimes): done, pending merge** (branch
  `se-wave1-lifetimes`, 2026-09-28). `.release()`/`.shrink()` on every
  container; the compiler frees the AST, tokens and checker tables after
  lowering, resets `a68Items` per function in measure, installs the bake
  by move and re-parses it on every compile. `bookmarks --rtbake` peaks
  at 6,324,316 bytes (target 6 MB, missed by 32,860; the wave spec
  revises its number), `bookmarks` from source at 8,605,188 and
  `hello-mac` at 8,531,984. On the IIcx the launch→low heap use fell
  from 12035 KB to 7977 KB. Numbers: the program design's §9.2 and
  `docs/HISTORY.md`. Wave 2 (representation) is next.

The DNR/UDP items below resume after this program.

### Next: language usability

Items 1 (binary streams and files), 2 (serial ports) and 3 (AppleTalk)
of the original list are DONE — `binary-files`, `transfer-crcs`,
`filesystem-api`, `serial-connection` and `appletalk` in
`docs/HISTORY.md` (the AppleTalk phase merged to `main` 2026-09-07; its
environment prerequisite — a LaunchAPPL with the `--system-extra-file`
option, upstream since PR #316 merged — is now passed explicitly by
`tests/lib_mac.sh`'s `mac_launch`, with no `~/.LaunchAPPL.cfg`). Remaining, in order:

1. **MacTCP** — MERGED to main 2026-09-08 (ff 2d258a4..8f1dd29). TCP as
   `connection`'s third transport (`c.open(tcp "a.b.c.d:port")`) and
   `listener`'s second (`l.listen(tcp port)`), on both lanes: MacTCP's
   `.IPP` driver natively, through polled async parameter blocks with no
   ASR, and BSD sockets on the host, so a host build is a working TCP
   client and server. Dotted quads only — a host name needs the DNR,
   which is the next phase. Spec:
   `docs/superpowers/specs/2026-09-07-mactcp-design.md`.
2. **DNR** — host names instead of dotted quads, on both lanes. Three
   pieces first, in this order (spec §11): a C-convention `= ptr` extern
   variant (arguments pushed right-to-left as longs, the caller pops,
   result in D0 — the resolver's entry points are C, not pascal); the
   resource-file search that finds the resolver code (`cdev`/`mtcp` in
   the System Folder, then `cdev`/`ztcp` in Control Panels and the
   System Folder); and a result-procedure probe (the DNR answers at
   interrupt time, so A5 has to be set up). Then `open(tcp "host:port")`
   takes a name, host lane included.
3. **UDP** — connected-peer `open(udp "host:port")` on `connection`,
   plus a separate datagram-server resource: a UDP server is not
   accept-shaped, so it is not a `listener`. Recorded, after the DNR.

Environment note (Linux emulator port, 2026-09-27): the emulator lanes
run on Linux: two Snow workspaces -- `snow/system6.snoww` (a 4MB
Macintosh SE, System 6.0.8) and `snow/system7.snoww` (a 128MB Mac IIcx,
System 7.1, MacTCP at 10.0.0.2 / gateway 10.0.0.1, where ClarusC.APPL
runs) -- both with Snow's NAT "Ethernet" target (outbound-only), and the
Linux Mini vMac Mac Plus pair (`macplus/`, `macplus2/`). Mini vMac and
Snow (`--serial-bridge-b localtalk`) both carry LocalTalk-over-UDP, on a
multicast group that is a real, routed LocalTalk network (a router on
net 6801, other zones and nodes -- tests use per-run NBP names/types and
never assert exact zone lists or node counts). The serial bridge
(`--serial-bridge-a tcp:PORT`) is what `mactest/snow/serial_echo` and
`pagefile` use.

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
