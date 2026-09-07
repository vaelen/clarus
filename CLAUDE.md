# CLAUDE.md

Clarus is a compiled, event-driven language for System 6/7 68k Macs.
Read `docs/ROADMAP.md` first — it is the authoritative record of sequencing
and strategy; completed (merged-to-main) phases are archived verbatim in
`docs/HISTORY.md`, recorded technical debt lives in `docs/TODO.md`, and
maybe-someday ideas / if-it-ever-bites levers in `docs/FUTURE.md`.
`docs/clarus-language-reference.md` is the normative
language spec; where any other doc disagrees, the reference wins.
`docs/clarus-toolbox-cookbook.md` is a how-to companion for transcribing
Inside Macintosh declarations into Clarus `extern`/`callback` forms.

## Working conventions

- Design-first: brainstorm → spec → plan → implement (specs in
  `docs/superpowers/specs/`, plans in `docs/superpowers/plans/`).
- Implementation is ALWAYS subagent-driven (superpowers:subagent-driven-development)
  using cheaper models (`model: sonnet` for implementation and review tasks;
  `haiku` for mechanical batch edits). The top-level (Fable) session designs,
  dispatches, reviews, and integrates — it does not write implementation code
  itself. Final whole-branch review may use the most capable model.
- Feature branch per plan; main stays green; merge only on request.
- Toolbox calls (runtime included) go through `toolbox/*.cla`; when a new
  feature needs a new Toolbox routine, enable the rest of that manager's
  interface at the same time where feasible. Users get friendly Clarus
  abstractions (80/20 — a standard app needs zero Toolbox knowledge); the
  catalog is the escape hatch. Prefer 1980s-IM (System 6) APIs; gate
  System 7-only features behind a Gestalt check with graceful fallback.
  Full statement: `docs/ROADMAP.md`'s "Standing principles" section
  (GUIDING PRINCIPLE block).

## Build and test

```sh
scripts/clarus-run.sh FILE.cla [-- args...]  # day-to-day `clarus run`
scripts/test-task.sh              # T1: per-task gate (~1-2m)
scripts/test-merge.sh             # T2: per-merge gate (~15m + selfhost, needs the emulator)
```

- `scripts/clarus-run.sh` is the Go-free replacement for `clarus run` day
  to day: it bootstraps clarusc from the committed `clarusc/clarusc.c`
  snapshot with `cc` alone (cached under `build-run/`, keyed on the
  snapshot's mtime), emits C for `FILE.cla`, compiles that against the
  on-disk host runtime (`runtime/host`), and execs the result with
  any args after `--`. No Go compiler involved.

The test harness is Make + POSIX shell + a handful of small C tools —
no Go anywhere (the Go harness was deleted in the go-retirement phase,
2026-09-05; `tests/` replaces the old `internal/*_test.go` packages one
script per Go test).

- `make -j tools bootstrap` builds `build-run/tools/*` (the C helpers:
  `timeout`, `uiblob`, `resfork`, `clirhdr`, `tcpdrive`, `atalkdrive`) and
  the two-stage `build-run/clarusc-{snapshot,current}` compilers. Every
  test depends on both targets, so make's own scheduling serializes the
  bootstrap.
- `make test T='<group>/<name> <group>/'` runs selected scripts. Each `T=`
  word is a prefix matched against `tests/<prefix>`, so `T=bake/` is a
  whole group and `T=cg68k/goldens` one script.
- `make -j t1` runs every group except `selfhost/` and `perfgate/`.
  `make t2` is the whole merge gate (t1, then perfgate alone, `selfhost/`,
  the gated `mactest/` group at `-j1`, and the `bake/` full-corpus sweep).
  `make smoke` is just the two native emulator boots.
- Result lines are `PASS|SKIP|FAIL(...) <group>/<name> <secs>s`; per-test
  logs land in `build-run/tests/<group>/<name>.log`, and `make` dumps the
  tail of every failing log in its summary.
- **There is no result cache** — every `make test`/`t1`/`t2` invocation
  re-executes every selected script (the `.result` targets depend on
  `FORCE`). Deliberate: the retired Go lane cached a package result keyed
  on its `.go` inputs and knew nothing about the `.cla` fixtures a test
  reads at runtime, so an edited `.cla` with unchanged `.go` could
  silently replay a stale PASS. That silent-red hole cannot exist here.
- A test script is `#!/bin/sh` plus
  `. "$(dirname "$0")/../lib.sh" || exit 2`, POSIX sh only (no arrays,
  `[[ ]]`, `local`, `echo -e`). It prints `PASS <name>` / `FAIL <name>:
  <detail>` per subcase and exits 0 (pass), **77** (skip — a missing
  toolchain or an unset gate variable), or anything else (fail). A `FAIL `
  line in the log beats exit 0 *and* exit 77: a script that reports a
  failing subcase and then skips is a FAIL. A `# timeout: 15m` header line
  overrides the runner's 600 s default deadline (a malformed value falls
  back to the default rather than disabling the deadline).
- `tests/lib.sh` is FROZEN and defines the whole vocabulary — `t_pass`,
  `t_fail`, `t_done`, `die`, `skip`, `require_env`, `require_tool`,
  `require_vasm`, `golden_check`, `first_diff`, `host_build`, `emit68k`,
  `run_c_test`, `mem_live`, and `ROOT BR TOOLS CLARUSC
  CLARUSC_SNAPSHOT RTDIR HOSTRT CC WORK`. Group helpers live in
  `tests/lib_<group>.sh`, sourced right after it as
  `... || die "helper lib failed to load"` (an unguarded source of a
  broken helper once produced a green PASS with zero assertions).
  `tests/runner/{selfcheck,syntax,timeout}.sh` are the harness's own
  self-checks: verdict precedence, `sh -n` over every `tests/**/*.sh`, and
  the `timeout` tool's process-group kill.

Tiered test gates:

- `scripts/test-task.sh` — T1, run after every task: `make -j t1`, then
  `make test T=perfgate/` on its own (timing under a parallel load is
  meaningless, so perfgate is excluded from `t1` and run alone). Add
  `--smoke` when a task touches `runtime/` or `clarusc/`, which
  additionally runs `make smoke` — the two native-68k emulator boots
  (`CLARUS_MAC_TESTS=1`, `tests/mactest/smoke_bounce.sh` and
  `tests/mactest/tick.sh`; needs the Retro68 toolchain + Mini vMac).
- `scripts/test-merge.sh` — T2, run before merging to main: T1's body plus
  `selfhost/` (the bootstrap fixed-point + snapshot + cross-generation
  differential oracles; each script carries its own `# timeout: 30m`
  header, so there is no timeout flag to remember), the whole gated
  `mactest/` group (`CLARUS_MAC_TESTS=1`, `-j1` — an emulator boot owns
  the machine's screen, so those scripts can never run in parallel), and
  the `bake/` full-corpus byte-identity sweep (`CLARUS_BAKE_FULL=1`).
  Each stage prints its own `test-merge.sh: <stage> PASS in Ns` line.
- **Standing rule (compiler-cleanup phase, 2026-09-05).** A phase that
  adds a new value-typed runtime module (the `connection`/`filehandle`/
  datetime shape) adds its `tests/bake/<module>.sh` `emit68k_pair` twin
  in the same task — `--rtbake` byte-identity for that module then fails
  in T1, not only in the opt-in full-corpus sweep. The binary-files
  phase shipped eight tasks `--rtbake`-broken because nothing but the
  T2-only sweep exercised that path.
- **AppleTalk test groups (AppleTalk phase, 2026-09-07).** Three T1
  groups put a real LocalTalk-over-UDP (LToUDP) stack on the loopback
  multicast group `239.192.76.84:1954`: `tests/atalk/` (end-to-end
  Clarus programs against the `atalkdrive` peer tool — `call`, `find`,
  `serve`, `zones`, `runerr`, plus `splice`/`examples`, which need no
  network), `tests/atalkdrive/` (the tool talking to itself) and
  `tests/hostrt/atalk.sh` (the C unit test over `rt_atalk.inc`). That
  group is shared with any Mini vMac/Snow session running on the same
  machine, so every script that puts a stack on it takes
  `tests/lib_atalk.sh`'s `atalk_lock` first — a `mkdir` mutex under
  `build-run/`, holder pid inside, stolen if the holder died. A dozen
  stacks racing for 127 node ids under `make -j` is flaky in a way no
  protocol hardening fixes. The lock is taken as late as possible:
  fixture COMPILES run outside it (they need no group), and
  `tests/atalk/runerr.sh`'s panic and build-error sections run before it
  and without the multicast gate at all. A machine with no multicast
  makes the network scripts SKIP (`atalk_skip_unless_multicast`, whose
  probe is `atalkdrive`'s own exit 77). `CLARUS_ATALK_IFACE=<ipv4>`
  picks the interface to join the group on when the host is multi-homed;
  unset, the system chooses. `runtime/clarus/atalk.cla` +
  `atalk_68k.cla` are in the 68k superset — spliced into EVERY native
  build, not usage-gated like the host `atalk.cla`/`atalk_c.cla` pair —
  so they are in `bake.cla`'s 68k module list and any edit to
  `atalk.cla` moves `testdata/cg68k/atalk_{server,client}.s` and all
  FOUR `testdata/emitui/atalk_*.c.golden` files
  (`atalk_{browser,client,listener,server}`) -- `shake` pulls whatever
  the pump references into every program that uses AppleTalk, so a
  one-line pump edit is not confined to the listener golden.
- **MacTCP test groups (MacTCP phase, 2026-09-08).** Three T1 groups
  cover the TCP transport, and none of them needs `atalk_lock`:
  `tests/tcp/` (end-to-end Clarus programs against the `tcpdrive` peer
  tool -- `connect`, `listen`, `failed`, `lfailed`, `deny`, `every`,
  `runerr`, `examples`, plus `waist68k`, which drives a probe through
  the language surface and greps `emit68k --listing` for all sixteen
  native waist entry points),
  `tests/hostrt/tcp.sh` (the C unit test over `rt_tcp.inc`) and
  `tests/bake/tcp.sh` (the `--rtbake` byte-identity twin the standing
  rule above requires). They bind loopback ports only -- no multicast
  group, no shared node-id space -- so they are safe under `make -j`.
  `runtime/clarus/tcp.cla` + `tcp_68k.cla` are in the 68k superset like
  the AppleTalk pair (spliced into EVERY native build, not usage-gated
  like the host `tcp.cla`/`tcp_c.cla` pair), so they are in `bake.cla`'s
  68k module list, and an edit that moves `tcp.cla`'s GLOBALS moves
  every one of the 60 `testdata/cg68k/*.s` goldens, not just the TCP
  ones -- the splice itself did exactly that (+438 B of A5 globals and
  8 extra `rtTextNew` calls at boot in every native program, from
  `tcp.cla`'s `rtTcpPending: text[8]`; see `docs/TODO.md`).
- Opt-in lanes, SKIPped by both gates:
  - `CLARUS_CPRINT_MAC_TESTS=1` (alongside `CLARUS_MAC_TESTS=1`) enables
    the Retro68/cprint-gcc twins — `tests/mactest/{coresuite_mac,
    toolbox_mac,runerr_mac,abort_mac,appres}.sh`. Demoted off T2 by the
    pack3-standardfile phase (2026-08-07) and kept only as a cross-lane
    localization oracle: the native `emit68k` lane already covers every
    case they check. Two known failures, unchanged from the retired Go
    lane: `FileHandleRW: create failed` and `DirOps: exists("") false` in
    the cprint CORE-suite boot (cprint-lane runtime gaps). The cprint
    TOOLBOX twin (`toolbox_mac.sh`) no longer compiles at all and is
    retired to a compile-error state pending the 5f Retro68 retirement:
    the toolbox suite is now 68k-source-only, because its `AdspLeak`
    case names the runtime's own native AppleTalk waist
    (`rtAt68DspInitEnd`/`rtAdspDevClose`, which do not exist in
    `atalk_c.cla`) and the `--testapi` early-visible module set is
    68k-lane only (MacTCP-phase Ruling 10 — see the `--testapi` note
    below). It was green 38/38 up to then, since the compiler-cleanup
    phase (2026-09-05) added the
    `rt_ext_TbFreeMem`/`rt_ext_TbClearWarmFreeMem` shims whose absence
    used to make it fail to LINK. The CORE twin is unaffected. The C
    printer's remaining first-class role is host builds (`clarusc emit`
    + `cc`).
  - `CLARUS_SNOW_TESTS=1` enables the Snow (System 7 / Mac II) scripts
    under `tests/mactest/snow/`. `CLARUS_SNOW_TESTS=1 make test
    T=mactest/snow/clarusc_bake` (~30 min) is the standing rule after any
    change to `clarusc/bake.cla` or `clarusc/macgui.cla` — it is the only
    proof `ClarusC.APPL`'s default bake path works on real hardware, and
    neither T1 nor T2 boots it. It ends on the guest's own
    `##CLARUS-EXIT##` trailer (a probe of the live disk image) rather than
    a fixed settle timer — the language-runtime-cleanup phase, 2026-09-06;
    the old 55-minute timer was a floor on every run, pass or fail.
    `mactest/snow/adsp_listener` (AppleTalk phase, 2026-09-07 — System 7
    Snow as the ADSP listener, Mini vMac as the client, over LToUDP) also
    needs `CLARUS_MAC_TESTS=1` for its client half **and a real, unlocked
    display**: Snow's LocalTalk-over-UDP bridge has no launch flag, so
    `tests/lib_snow.sh`'s `snow_localtalk_b` turns it on by posting
    CGEvent clicks into Snow's own in-window menu bar (see
    `docs/FUTURE.md`).
    **Snow is launched as `snow/ClarusSnow`** (2026-09-08) — a symlink
    into a SEPARATE `snow/Snow.app` copy, so a test boot can coexist
    with the long-running Snow instance Andrew keeps for the BBS:
    `pgrep -x Snow` is HIS and is never touched, `pgrep -x ClarusSnow`
    is ours. **Never touch a running Snow you did not start.**
    `tests/lib_snow.sh`'s `snow_run` refuses to boot only on a stray
    `ClarusSnow`, and quits by the pid IT launched (`kill -TERM`), never
    by app name — `osascript -e 'quit app "Snow"'` would take Andrew's
    BBS down with it.
    `snow_ethernet` attaches the DaynaPORT SCSI Ethernet adapter at SCSI
    ID 3 in the scratch workspace (`Clarus.snoww` itself carries none):
    the guest is 10.0.0.2, gateway 10.0.0.1, NAT **outbound-only** — no
    inbound port forwarding, no DNS (`docs/FUTURE.md`). The standing TCP
    hardware proof is `tests/mactest/snow/tcp_selfconnect.sh` (MacTCP
    phase, 2026-09-08): it self-connects on the guest's OWN address
    10.0.0.2, because MacTCP does not loop `127.0.0.1` back — an active
    open to it returns 0 and the listener never completes (the phase's
    probe wave measured it), so a self-test must dial the real
    address.
  - `CLARUS_BENCH68K=1` (with `CLARUS_MAC_TESTS=1`) runs the 68k
    calibration bench, `tests/mactest/bench.sh`.
- `tests/mactest/adsp_68k.sh` (the two-Mac ADSP stream boot, appletalk
  phase 2026-09-07) runs both boots under plain `CLARUS_MAC_TESTS=1` and
  is 12/12 in ~20 s; `run_mac_pair`'s 420 s is the per-boot timeout
  ceiling, not the expected duration (both apps quit on their own). Its
  `^failed -1273 ` grep over the SERVER capture stays as the guard for a
  LaunchAPPL that does NOT carry the `AppleTalk` system file (`.DSP`/`.XPP` then open `-43`):
  the script calls `skip` on that line BEFORE its first assertion,
  because a `FAIL ` line would beat exit 77. See the LaunchAPPL
  prerequisite under "Retro68 / Mac toolchain" below — without that
  patch this script SKIPs and `mactest/toolbox_68k` goes RED (the
  `AdspLeak` suite case has no skip verdict and FAILs with
  `open .DSP err -43`). `tests/mactest/atalk_68k.sh` (NBP/ATP over the
  ROM's own `.MPP`/`.ATP`) and `tests/mactest/atalk_selfserve.sh` (serve
  + browse with no peer at all) need no such file.
- Golden blessing — five variables, and each must be set to exactly `1`
  (`lib.sh`'s `env_set`; any other value, `0` included, is NOT a bless):
  `CLARUS_MAC_BLESS=1` rewrites the UI trace + PBM snap goldens,
  `CLARUS_CG68K_BLESS=1` the `testdata/cg68k` `.s` goldens,
  `CLARUS_BLESS_BEHAVIOR=1` the `selfhost` `.behavior` blobs,
  `CLARUS_MODULES_BLESS=1` the `clarusc/test/*.out` module-driver stdout
  goldens (`tests/selfhost/modules.sh`; added by the compiler-cleanup
  phase's follow-up sweep, 2026-09-05), and
  `CLRD_BLESS=1` the frozen `testdata/sertest/clrd_goldens/` CLRD
  stdout/`.dat` blobs — that last one is deliberate-only: those goldens
  were pinned once from a verified run and nothing should rewrite them
  incidentally.

- The Go compiler is DELETED (tag `go-compiler-final`). clarusc
  (`clarusc/*.cla`) is the only compiler; new language features land in the
  reference + clarusc.
- `clarusc/clarusc.c` is the committed bootstrap snapshot. If
  `tests/selfhost/fixedpoint.sh` fails, its `snapshot_fresh` failure
  message prints the Go-free regeneration recipe.
- Bootstrap from C alone:
  `cc -I runtime/host -o clarusc clarusc/clarusc.c runtime/host/rt.c`
- `--testapi` (`clarusc emit`/`emit68k`/`appinfo`, ui-scenario-retirement
  phase): for a UI program, splices the UI runtime modules PLUS
  `runtime/clarus/uitest.cla` (`UiTestVerb` + wrappers +
  `UiTestChecksum`) in early, before the ordinary clean-standalone check,
  so the program can name runtime/`UiTest*` functions. Without the flag,
  ordinary programs cannot name runtime functions at all (clarusc
  enforces user code checks standalone before any runtime module is
  consulted) and behavior is byte-identical to no-flag builds — the
  emitui/frozen-scenario goldens are the proof. A no-op on non-UI
  programs. Check-only mode (bare `clarusc FILE...`) doesn't recognize
  the flag at all — it's only matched under `emitMode`/`emitMode68k`/
  `appinfoMode` (`clarusc/main.cla`); in check-only mode it falls into
  the generic positional-file-args branch and is treated as a bogus
  entry filename (`clarusc --testapi FILE.cla` fails `cannot open entry
  file`, exit 1). Only the suites' GUI (`gui.cla`, `--events`-driven)
  builds pass it — `core`'s non-UI host CLI (`cli.cla`) doesn't need it;
  nothing outside the two suites does.
  On the 68k lane the early-visible set is WIDER than the UI modules
  (MacTCP phase, 2026-09-08): `sortedmap`, `datetime`(+`_68k`), `ser`,
  `conn`(+`_68k`), `atalk`(+`_68k`) and `tcp`(+`_68k`) go in ahead of
  `uitest.cla`, so a toolbox-suite case can drive the runtime's own
  AppleTalk and TCP waists and not only the ROM. That list must stay a
  strict PREFIX of the runtime manifest's own module order —
  `driveManifestSplice` appends the remainder after it, and `bake.cla`'s
  `bakeModuleList` moves `uitest.cla` to the matching spot, which is the
  marker for where "early-visible" ends. Get the order wrong and only
  `CLARUS_BAKE_FULL=1` catches it. The HOST lane is deliberately
  unchanged (Ruling 10): `bakeModuleList`'s C-lane list carries no
  conn/atalk/tcp at all, so early-splicing them there would desynchronise
  from-source against bake for no gain — which is why the toolbox suite
  is 68k-source-only and its cprint twin no longer builds.

### `core`/`toolbox` test suites (`testsuite/`)

Clarus-native test suites (test-suite-review phase, Tasks 8-13) — ordinary
Clarus functions returning pass/fail, run in-process by a hand-maintained
enum + runner, not one boot per case.

- `testsuite/core/` (83 `CoreTest` cases: 82 real + `SelfCheck`, grown
  from 74 real (correctness-cleanup phase tip) by the binary-files
  phase's `TextBinary`/`Crc16`/`IntToStr`/`FileHandleRW` cases — the
  first three hardware-prove `text`'s new LE/word/setter binary
  accessors, `crc16`, and `string(n)`'s `IntToStr` migration; the fourth
  hardware-proves `filehandle` positioned I/O on both lanes — then to 78
  real by the filesystem-api phase's `DirOps` case, which hardware-
  proves the directory/catalog family (`makeDir`/`delete`/`list`/
  `exists`/`info`/`setInfo`/`rename`/`move`) on both lanes; unchanged by
  the transfer-crcs phase, whose new `crc16x`/`crc32` coverage landed
  inside the existing `Crc16` case; then to 79 real by the
  extern-ptr-call phase's `PtrCall` case, which hardware-proves the
  `= ptr` extern clause (pascal-convention call through a runtime
  pointer, including a bool-returning round trip) on both lanes — then
  to 80 real by the string-perf phase's `StrPerf` case, which pins the
  length-byte-only string-local init, the inline `s[i]`/`s.length`
  codegen, and `text.clear()`/`reserve(n)` semantics -- then to 81 real
  by the language-runtime-cleanup phase's `OpenRF` case, which
  hardware-proves `file.openRF` (a resource fork opened as an ordinary
  `filehandle`) on both lanes -- then to 82 real by the
  native-array-return-and-fileh-guards phase's `ArrReturn` case, which
  hardware-proves scalar-element fixed-array RETURNS (hidden-result-pointer
  block copy) on both lanes) runs on
  host and natively; `testsuite/toolbox/` (40 `ToolboxTest` cases: 39 real +
  `SelfCheck`, grown from 7 by the ui-scenario-retirement phase — 12 of the
  legacy `testdata/ui` scenarios migrated in as cases, plus two new
  machinery cases, `UiTestVerbSmoke` and `PostEventClick` — then to 22 real
  by the test-consolidation phase, which migrated `formedit`/
  `texteditor_bigfile` in as `FormEdit`/`BigText` — then to 23 real by the
  toolbox-cookbook phase's `Catalog` case, which hardware-proves the
  `toolbox/` catalog below — then to 24 real by the native-gaps-cleanup
  phase's `FInfoStamp` case, which hardware-proves the doctype/creator
  file-stamp rule on both lanes — then to 27 real by the mac-resident-
  clarusc phase's `ResourceBake`/`WriteResStamp`/`FieldCap` cases — then
  to 28 real by the datetime-instrumentation phase's `DateTimeRoundTrip`
  case — then to 29 real by the clarusc-live-log phase's `LivePaint`
  case — then to 30 real by the serial-connection phase's
  `SerialOpenWrite` case — then to 31 real by the correctness-cleanup
  phase's `NarrowPopup` case, which pins the labeled-popup layout fix;
  unchanged by the binary-files phase, whose new suite coverage landed
  in `core` instead — then to 32 real by the 68k-call-result-release
  phase's `LeakCheck` case, which hardware-proves FreeMem stays exactly
  flat (3570496 -> 3570496) across 1500x4 direct-consumption shapes on
  the emulated Mac Plus — then to 33 real by the textview-scroll-to-end
  phase's `ScrollToEnd` case, which hardware-proves the new
  `textview.scrollToEnd()` widget method on the native lane (the cprint
  twin passes too, 38/38, since the compiler-cleanup phase added the
  `rt_ext_TbFreeMem`/`rt_ext_TbClearWarmFreeMem` shims that used to block
  it) — then to 34 real by the
  string-perf phase's `ClearWarm` case, which hardware-proves
  `text.clear()`+warm reuse keeps FreeMem EXACTLY flat (zero Memory
  Manager traffic) across 200 clear+refill cycles — then to 35 real by
  the compiler-cleanup phase's `CasesTable` case, which checksums the
  suite GUI's OWN case table (the one stale-master-pointer instance
  nothing in the suite asserted on: a band over one row of `gui.cla`'s
  `Cases` table, non-blank while a row is present and stable across two
  paints) -- then to 37 real by the language-runtime-cleanup phase's
  `CanvasIdle` and `WindowMenus` cases, which hardware-prove the buffered
  canvas dirty gate (200 idle ticks cost no blit and no FreeMem churn)
  and the `menus:` window-owned menu set (menu-bar band checksums across
  an activation) -- then to 38 real by the AppleTalk phase's `AtalkSelf`
  case, which hardware-proves the `toolbox/appletalk.cla` catalog against
  the ROM `.MPP`/`.ATP` drivers: open both, NBP register with
  verification, read the node's own net/node back out of the Names Table
  Entry, look up a type nothing registered (err 0, 0 gotten -- the ROM
  answers no self-lookup and has no `setSelfSend`), remove the name, then
  open and close a dynamic ATP socket -- then to 39 real by the AppleTalk
  phase's Task 13b `AdspLeak` case, which hardware-proves the ROM `.DSP`
  `dspInit`/`dspRemove` and `dspCLInit`/`dspCLRemove` pairs leak nothing at
  the runtime's own block sizes: 20 cycles of each, `FreeMem` exactly flat.
  It does NOT cover `rtAt68DspFree`'s own bookkeeping -- a suite case cannot
  name the AppleTalk runtime at all, since `--testapi`'s early-visible module
  set does not include it, see `docs/TODO.md`)
  needs the real Toolbox/emulator. Each has `runner.cla` (the enum + dispatch +
  `tkReport` result log) plus `cases_*.cla` families; `core` additionally
  has a host CLI (`cli.cla`, real argv) and a Mac/native front end
  (`cli_mac.cla` — `cli.cla` can't boot natively, see its own doc comment:
  cg68k's non-UI startup stub fires `App.startCLI` with a never-marshaled
  `args` list). Both suites also have a scriptable GUI front end
  (`gui.cla`, driven by `--events` the same way the legacy UI goldens are).
  **Both case counts are hand-maintained in FIVE places each**: core =
  the runner's `nCoreCases`, `tests/mactest/coresuite_68k.sh`'s and
  `coresuite_mac.sh`'s `suite_report_check` literals,
  `tests/testsuite/core_cases.txt` (the host CLI's own list --
  `testsuite/core_cli` fails without it), and this file; toolbox = the
  runner's `nTbCases`, `tests/mactest/toolbox_68k.sh`,
  `toolbox_jiggle.sh`, `toolbox_mac.sh`, and this file. A task adding a
  case bumps all five.
- **Run `core` on host** (compose recipe — no single-file entry point,
  `clarusc emit`/`emit68k` both take multiple `.cla` files positionally):
  ```sh
  cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c   # once
  build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
      testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
  cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
  /tmp/core_cli all   # or one/some case names by `CoreTest` enum name; nonzero exit on any FAIL
  ```
  `SelfCheck` as the CLI's lone explicit arg always FAILs, by contract
  design: it asserts all 82 other cases ran in the same invocation
  (`casesRun == nCoreCases - 1`), so pass it alongside other names (or use
  `all`), never alone.
  (Exact file list: `tests/testsuite/core_cli.sh`.) `toolbox` has no host
  CLI by design
  (Toolbox/hardware-only) — it only runs via a Mac/native boot.
- **The four gated suite-boot scripts**, one boot each, both platform
  lanes: `tests/mactest/coresuite_68k.sh`/`tests/mactest/coresuite_mac.sh`
  (native `emit68k` / Retro68-cprint twins, `core/gui.cla` + `--events`,
  the file list in `tests/mactest/coregui_files.txt`) and
  `tests/mactest/toolbox_68k.sh`/`tests/mactest/toolbox_mac.sh` (same,
  `toolbox/gui.cla` + `tests/mactest/toolbox_files.txt`). Each parses the
  captured `tkReport` log and asserts every case's own PASS line plus the
  `TOTAL n PASS n FAIL 0` tally, reporting one `PASS <case>`/`FAIL <case>`
  result line per case. The `_68k` halves run under T2's
  `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` (`scripts/test-merge.sh`);
  not part of T1. The `_mac` twins are the Retro68/cprint lane, demoted
  (pack3-standardfile phase, 2026-08-07) to an opt-in diagnostic behind
  `CLARUS_CPRINT_MAC_TESTS=1` — SKIP under bare `CLARUS_MAC_TESTS=1`, so
  they no longer run as part of T2 by default.
- `toolbox/{memory,events,osutils,scrap,standardfile,files,appletalk,mactcp}.cla`
  (toolbox-cookbook phase; `standardfile`/`files` added by
  pack3-standardfile, `appletalk` by the AppleTalk phase, `mactcp` by the
  MacTCP phase) is a
  curated extern catalog of real Inside Macintosh trap declarations,
  ready to compose into a build (positionally or via `include`) for new
  UI code instead of hand-declaring traps; `tests/testsuite/catalog.sh`
  (plus `tests/testsuite/catalog_ui.sh`) is its T1 check. `files.cla` itself grew from
  pack3-standardfile's deliberately-thin SetVol-only scope to a full HFS
  catalog/directory family (`_HFSDispatch`'s `GetCatInfo`/`SetCatInfo`/
  `DirCreate`/`CatMove`, plus `PBH{Delete,Rename,Get/SetFInfo,OpenRF}Sync`)
  in the filesystem-api phase, 2026-08-26 — no longer just a Standard
  File helper. `mactcp.cla` is the cookbook's §14 csCode-dispatched
  driver shape a second time (one driver, `.IPP`, and no `extern record`
  at all — a `TCPiopb`'s csParam is an eight-arm union `extern record`
  cannot spell, so the runtime pokes absolute offsets into one
  `NewPtrClear(102)` block). Its ULP timeout ACTION constants are
  `tcpUlpActionReport = 0` and `tcpUlpActionAbort = 1` (the MacTCP
  Programmer's Guide: "0 = report, nonzero = abort"; abort is the
  driver's own default, applied when the validity bit is clear). They
  deliberately do NOT share a spelling with the termination REASONS
  `tcpULPTimeoutTerminate = 5` / `tcpULPAbort = 6`: `tcpUlpActionAbort`
  (1) and `tcpULPAbort` (6) would otherwise differ only in letter case,
  which the compiler cannot catch. See
  `docs/clarus-toolbox-cookbook.md` for worked transcription examples.
  An `include "toolbox/..."` path that isn't found relative to the
  including file falls back to the compiler's own `toolbox/` directory
  (`<rtdir>/../../toolbox/<rest>`, since `<rtdir>` is `runtime/clarus/`)
  — usable from a program tree outside this repo, not just in-tree;
  `--rtdir DIR` is honored in check-only mode too (`clarusc FILE.cla
  --rtdir DIR`), not just `emit`/`emit68k` (binary-files phase,
  2026-08-22).

## Retro68 / Mac toolchain (symlinks, not in git)

- `Retro68/` → Retro68 source. The Universal Interfaces headers the
  `toolbox/` catalog is transcribed from are `toolchain/universal/CIncludes`
  (CR-only line endings and MacRoman bytes — read them through
  `LC_ALL=C tr '\r' '\n'`, a plain `grep -n` reports nothing).
- `toolchain/` → built cross-toolchain (`toolchain/bin`: gcc, Rez, LaunchAPPL,
  hfsutils h* tools). Prebuilt samples: `../Retro68-build/build-target/Samples/`.
- **LaunchAPPL needs `system-extra-file = AppleTalk` (AppleTalk phase,
  2026-09-07).** Stock LaunchAPPL builds its Mini vMac boot disk from
  only the System file, the debugger and a few extensions, so the
  `AppleTalk` file (the `.XPP`/`.DSP` drivers) is absent and both open
  `-43`. The installed `toolchain/bin/LaunchAPPL` is built from Andrew's
  fork (`github.com/vaelen/Retro68`, branch `system-extra-file`, upstream
  PR autc04/Retro68#316), which adds a repeatable `--system-extra-file
  NAME` option / config key; `~/.LaunchAPPL.cfg` carries
  `system-extra-file = AppleTalk`. The pre-option binary is kept beside
  it as `LaunchAPPL.orig`. A LaunchAPPL rebuilt from upstream without
  that option (or a config missing the line) makes `mactest/adsp_68k`
  SKIP itself and `mactest/toolbox_68k` go RED on `AdspLeak`
  (`open .DSP err -43`); rebuild from the fork branch (or upstream once
  the PR lands) and keep the config line. The `Retro68` checkout's
  remotes are `origin` = the fork, `upstream` = autc04.
- `macplus/` → Mini vMac emulator (`MacPlus.app`) + `vMac.ROM`.
- `macplus2/` → a second Mini vMac (`MacPlus2.app` + `vMac.ROM` + its
  own `disk1.dsk`, an identical copy of `macplus/`'s) —
  `tests/lib_mac.sh`'s `run_mac_pair` boots it as the second machine
  for `tests/mactest/adsp_68k.sh`. Gitignored like `macplus/`. Missing ⇒
  that script SKIPs (`macplus2 not present`).
- `vasm/` → locally built `vasmm68k_mot` (the third-party 68000 assembler
  used as an encoder oracle; rebuild recipe in
  `tests/asm68k/roundtrip.sh`'s header). Missing or built without the bin
  output module ⇒ `tests/asm68k/roundtrip.sh`, `tests/cg68k/vasm.sh` and
  the round-trip halves of `tests/cg68k/array_assign.sh` and
  `tests/cg68k/segments.sh` SKIP.
- `snow/` → Snow emulator, launched as `snow/ClarusSnow` (a symlink into
  our OWN `snow/Snow.app` copy, so a test boot never collides with
  another running Snow — see the `CLARUS_SNOW_TESTS=1` bullet above),
  plus its `Clarus.snoww` workspace, ROM and PRAM — the System 7 /
  Mac II lane. Missing ⇒ the whole `tests/mactest/snow/` group SKIPs.

To build a Mac app from C: `CMakeLists.txt` with `add_application(Name src.c)`, then

```sh
cmake -B build -DCMAKE_TOOLCHAIN_FILE=$REPO/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake
make -C build    # produces Name.bin (for LaunchAPPL), Name.APPL, Name.dsk
```

## Running Mac apps in the emulator

`~/.LaunchAPPL.cfg` is already configured (minivmac backend: `macplus/MacPlus.app`,
`macplus/vMac.ROM`, system image `~/mac/System 6.0.8.dsk`, AutoQuit at
`~/mac/macplus/autoquit-1.1.1.dsk`).

```sh
toolchain/bin/LaunchAPPL -e minivmac App.bin   # takes MacBinary (.bin)
```

- Build a Clarus program for Mac: `scripts/build-mac.sh <Name> <files.cla...> [--test]`
  (snapshot-bootstrapped clarusc emit → Retro68 cmake → `.bin`/`.APPL`/`.dsk`
  under `build-mac/`).
- Build a Clarus program as a NATIVE 68k binary (no C, no cmake, no
  Retro68): `scripts/build-68k.sh [Name] <files.cla...> [--events FILE]`
  (snapshot-bootstrapped clarusc `emit68k` directly → `.bin` under
  `build-68k/`; `Name` is optional — derived from `clarusc appinfo` when
  the first arg is a `.cla` file). `--events FILE` pours a scripted-event
  file into the native constant pool for deterministic UI driving, the
  native counterpart to `build-mac.sh`'s own `--events` below.
- Build the Mac-resident compiler itself (`ClarusC.APPL` — a real Mac app
  that runs `clarusc emit68k` ON the Mac, compiling OTHER `.cla` programs
  with no host involved): `scripts/build-clarusc-mac.sh [--events FILE]`
  → `build-68k/ClarusC/ClarusC.bin`. `--bake FILE` (one flag per
  `runtime/clarus/*.cla` + `toolbox/*.cla` file, used verbatim as the
  baked `'CLFS'` resource's name) embeds the whole runtime/toolbox source
  catalog in the app's own resource fork, so it needs no
  `runtime/clarus/` directory on the Mac disk (the glob picks up
  `runtime/clarus/prelude.cla` — the `FileInfo` record predeclaration,
  filesystem-api phase — automatically, same as any other runtime
  module); `--partition N` overrides
  the SIZE(-1) resource's partition (ClarusC.APPL itself needs more than
  the ordinary 2MB default — see `docs/HISTORY.md`'s mac-resident-clarusc
  phase entry). `file.readResource(name, out)`/`file.writeRes(path,
  fork, doctype, creator)` are the underlying resource-fork intrinsics
  (Mac-only; a host build's `readResource` always returns `false`) — see
  `docs/clarus-language-reference.md`'s own entry for both. The
  binary-files phase (2026-08-22) rounded out the binary-data surface:
  `filehandle` (positioned file I/O — `file.open`/`file.create`/
  `readAt`/`writeAt`/`size`/`setSize`/`flush`/`close`, both lanes,
  hardware-proved on System 6 and System 7; the language-runtime-cleanup
  phase, 2026-09-06, added `file.openRF`, which opens a file's RESOURCE
  fork as an ordinary `filehandle` — native `PBOpenRFSync`, host xattr
  with an AppleDouble `._` sidecar fallback), `string(n)` (the
  int-to-decimal-string conversion, `string(i)`, joining `int()`/
  `fixed()`/`char()`/`ptr()` -- not the pre-existing bounded-capacity
  TYPE syntax of the same name; the compiler-cleanup phase, 2026-09-05,
  extended it to `string(c)` for a `char` -- the same IR `"" + c`
  already produced -- and reshaped every conversion diagnostic in the
  family from the tautological `cannot convert X to X` to
  `X() expects <accepted>, got <actual>`, e.g. `string() expects an int
  or char, got string`; identity conversions stay errors by decision),
  and `text`'s LE/word/setter binary accessors
  plus `crc16`/`crc16x`/`crc32` (the last two from the transfer-crcs
  phase, 2026-08-25; `crc32`'s table is built lazily on first call);
  `emit68k` also now sizes a function's string/record temp
  pool per function instead of a fixed per-statement ceiling. The
  filesystem-api phase (2026-08-26) rounded out directory/catalog
  management on top of this: `file.makeDir/delete/list/exists/info/
  setInfo/rename/move`, both lanes, backed by a new predeclared
  `FileInfo` record and the `toolbox/files.cla` HFS catalog family
  above. The extern-ptr-call phase (2026-08-27) added `= ptr`, an
  `external func` clause for a pascal-convention call through a runtime
  pointer rather than a fixed trap number — the way to reach loaded code
  (a plugin/door module fetched with `GetResource`), both lanes. The
  68k-call-result-release phase (2026-08-29) fixed an `emit68k` leak: a
  user function's handle-typed result (or a textview `.text` getter box)
  consumed directly as an argument/operand/receiver was never released;
  producer-side tracking in `cg68k.cla` closes it, hardware-proved
  FreeMem-flat by the toolbox suite's new `LeakCheck` case. See the
  reference for the full method lists.
- Gated Mac-vs-host byte-compare harness (needs the toolchain + emulator):
  `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/`.
- UI test scenarios live in `testdata/ui`, with blessed goldens (trace +
  PBM framebuffer snaps) under `testdata/uisnaps` — the snaps are viewable
  PBMs. `CLARUS_MAC_BLESS=1` regenerates both, via the **native** lane
  (`tests/mactest/smoke_bounce.sh` and `tests/mactest/ui_scenarios.sh`,
  `clarusc emit68k` boots) — the
  test-consolidation phase's Task 7 (2026-08-06) retired the Retro68/cprint
  scenario lane outright (its per-scenario cprint boots), so the native
  lane is now the ONLY lane that boots these scenarios, and the only place
  `CLARUS_MAC_BLESS=1` has any effect (`ui_goldens`, `tests/lib_mac.sh`). `scripts/build-68k.sh`/`clarusc emit68k --events FILE`
  compile a scripted event sequence into a test build for deterministic UI
  driving (no real input needed); `scripts/build-mac.sh` still takes
  `--events FILE` too, for the two opt-in Retro68/cprint suite-gate
  diagnostics (`tests/mactest/coresuite_mac.sh`/`toolbox_mac.sh`, demoted
  behind `CLARUS_CPRINT_MAC_TESTS=1` by the pack3-standardfile phase,
  2026-08-07) and any future Retro68-lane build, but no longer for
  scenario goldens. The
  ui-scenario-retirement phase (2026-08-05) migrated 12 of the original 23
  scenarios into `testsuite/toolbox` cases and retired their
  `testdata/ui`/`testdata/uisnaps` fixtures; the test-consolidation phase
  migrated two more (2026-08-06): Task 3 migrated `formedit` (now
  `testsuite/toolbox/cases_formedit.cla`'s `FormEdit` case, once the
  blocking native-68k `accepted(rec)` trailing-`bool` codegen bug was
  fixed) and Task 4 migrated `texteditor_bigfile` (its >32,000-byte
  clamp/lastError/tail-content shape now lives in the toolbox suite's
  `BigText` case, testsuite/toolbox/cases_bigtext.cla; its own
  alert-message/close-cascade business logic stays covered by
  `examples/texteditor.cla` remaining in the `texteditor` acceptance boot).
  4 survive as frozen golden scenarios (`smoke_bounce`, `smoke_mandel`,
  `texteditor`, `bookmarks`), each booted ONLY on the native lane now
  (Task 7); `about`'s own coverage lives inside `smoke_mandel`'s events
  script, and `texteditor`'s own script has absorbed `opendoc`/
  `opendoc_empty`/`texteditor_quit`'s coverage — none of those four have
  their own standalone scenario anymore.
- This sandboxed display has a short (well under a minute of zero real HID
  activity) idle-lock; a naive long `sleep` with no synthetic input during
  manual real-input testing can look identical to a frozen app — nudge with
  a synthetic `CGEvent(mouseMoved)` (no click) periodically during waits.

- LaunchAPPL builds a stripped boot disk (System + AutoQuit + app), boots it
  in a fresh Mini vMac copy, and BLOCKS until the app quits — run it in the
  background. It creates a temp dir in the cwd (auto-removed on clean exit;
  delete it manually if you kill the process). Exit 0 = app ran and quit.
- To run an app with the full Finder instead: copy `MacPlus.app` to a scratch
  dir, put `vMac.ROM` and a bootable image as `Contents/mnvm_dat/disk1.dsk`
  (app disk as `disk2.dsk`), and `open -na` the copy. Mini vMac auto-mounts
  the `mnvm_dat` disks.

### Controlling and screenshotting the emulator

The emulator window is the Mac's 512×342 screen at 2× (1024×684 + title bar).

```sh
# window geometry {x, y, w, h}:
osascript -e 'tell application "System Events" to tell process "minivmac" to get {position, size} of window 1'
# screenshot that region:
screencapture -x -Rx,y,w,h shot.png
# mouse (CGEvent): screen coords = window origin + 2 × Mac coords
swift scripts/click.swift <x> <y> [double]
# keyboard (focus the window first):
osascript -e 'tell application "System Events" to set frontmost of process "minivmac" to true'
osascript -e 'tell application "System Events" to keystroke "text"'
```

Screenshot → read the image → click at computed coords → screenshot again.
System 6 boots in ~2-3 s; sleep ~10 s after launch before interacting.

### Known issues

- Retro68's console-library samples (HelloWorld, Raytracer) crash on launch
  with system error 3 (illegal instruction) on the Mac Plus — the binary
  itself, not the launch path. Plain Toolbox apps (Dialog sample) work fine.
  Don't use the console library as a reference for whether the pipeline works.
