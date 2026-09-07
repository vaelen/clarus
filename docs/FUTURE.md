# Clarus FUTURE — ideas and if-it-ever-bites items

Split out of `docs/TODO.md` on 2026-09-05. Nothing here is debt: each
item is either a candidate feature nobody has asked for yet, an
alternative that was considered and not taken, or a lever to pull only
if a measurement or a real failure says so. The originating phase's
`docs/HISTORY.md` entry (named in the sub-heading or in parentheses) and
its `.superpowers/sdd/<date>-<phase>/` ledger hold the verbatim context.
Real debt and needed improvements stay in `docs/TODO.md`.

## Language features (candidates)

- **`yield`/cancel statement** — event-loop tie-in so long computations
  (mandelbrot-class) pump events and can be cancelled; spec questions
  recorded in memory, unscheduled.

- **Reciprocal packers for the bulk range-readers** (clir-load-perf;
  Andrew 2026-08-15): the phase added only the READ half
  (`intAt`/`stringAt`/`textAt`/`hashStep`). Write half sketch:
  `t.appendPackedInt(i)` / `t.appendPackedString(s)` mutator shapes (a
  max-payload packed string overflows `string` under both prefix
  conventions, so return-`string` forms don't work). Note `stringAt` is
  now 1-byte Pascal-prefix; the CLIR pool's wire format stays 4-byte BE
  (read via `bkGetStr`'s `stringAt(pos + 3)` hop), so a pool-targeting
  packer still writes the 4-byte shape.

- **`text + char` concatenation** does not exist (append accepts char;
  `+` does not). Deliberate; revisit if it keeps surprising.

- **Launch-an-application-from-Clarus** (ui-scenario-retirement, Andrew
  2026-08-05): needed before an on-Mac suite can drive the example apps.
  System 6 `_Launch` REPLACES the running app, so this needs its own
  design (sub-launch conventions, result handoff, suite chaining, or
  System 7/MultiFinder gating). The 4 frozen golden scenarios' eventual
  fate rides on this.

- **Parking lot** (design spec §14 + later decisions): HTTP layer,
  UDP/DDP, auto-generated forms, float/SANE, case-insensitive maps,
  handle-backed map values, printing, color QuickDraw, labeled break,
  const arithmetic, `switch` on text, substring/indexOf as library code.

### Serial/connection phase (2026-08-16)

- **No carrier detect** — `rtConnDevGone` (`runtime/clarus/conn_68k.cla:253`)
  always returns false; `closed` never fires for a native serial
  connection (deliberate, spec-out-of-scope this phase). Revisit with
  real modem control lines (RING/carrier) if a future BBS-target phase
  needs it.

### filesystem-api phase (2026-08-26)

- **`list of string(31)` element capacity** — `file.list`'s `names`
  param is `list of string`, whose element is the general (255-byte)
  `string`; a caller who wants a narrower-capacity element (31 chars is
  the real HFS leaf-name max) still pays the general `string`'s 256
  B/entry ceiling — no `list of string(N)` narrowing is offered by the
  catalog. Named out of scope (design spec §7), unscheduled.

- **Recursive `makeDir`** — `file.makeDir` creates exactly one level
  (the parent must already exist); a `makeDir -p`-style multi-level
  create was named out of scope (design spec §7), unscheduled.

- **Combined rename+move** — `file.rename` changes the leaf name in
  place; `file.move` changes the parent folder while keeping the name;
  no single call does both atomically (a caller wanting to move to a
  new folder AND rename issues two calls). Named out of scope,
  unscheduled.

- **`PBSetCatInfoSync` declared but unused** — `toolbox/files.cla`'s
  catalog exposes it (bound once by the catalog driver, Task 2) but no
  `rtFhDev*` call in this phase calls it; `setInfo` goes through
  `PBHGetFInfoSync`/`PBHSetFInfoSync` instead (spec §4.3). Same
  declared-but-unused shape as other catalog-completeness entries.

### extern-ptr-call phase (2026-08-27)

- **Named-target `= ptr(name)` form** — today every `= ptr` declaration is
  a calling contract only, taking its target fresh as the first argument
  at every call site; a `= ptr(name)` form binding a declaration to one
  fixed pointer (set once, e.g. after a `GetResource`/`HLock`/deref, then
  called with no target argument at each site) was named out of scope
  (design spec's out-of-scope section), unscheduled.

- **Register-convention (`reg`) targets for `= ptr`** — `= ptr` is
  pascal-convention only, mutually exclusive with `reg`/`sel`/`seld0`/
  `memerr`/`ret` at the grammar level; a register-convention call
  through a runtime pointer was named out of scope (design spec's
  out-of-scope section), unscheduled.

## Performance levers (measure first)

### AppleTalk phase (2026-09-07)

- **T1's wall clock went 34 s -> ~2:14, and the cost is the network
  scripts' WAIT budgets, not compiles and not the lock.** The five
  building `tests/atalk/*.sh` scripts plus `tests/atalkdrive/` and
  `tests/hostrt/atalk.sh` serialize on `atalk_lock` (a shared loopback
  multicast group -- a dozen LToUDP stacks racing for 127 node ids under
  `make -j` is not deterministic, and the group is shared with Andrew's
  live emulator sessions), and while serialized they spend their time in
  `atalk_wait_line`'s up-to-20 s NBP-registration confirmations and
  `atalk_wait_exit`'s up-to-15 s lifetime checks. Measured: the whole
  network chain is ~130 s of the ~134 s; `atalk/examples` is 0 s and
  `atalk/splice` 1 s. The fix wave already moved every compile OUT of the
  lock -- that bought ~2.5 s, which is the honest size of the compile
  share. Levers, in order of payoff: shrink the `atalk_wait_*` budgets to
  what the observed registrations actually need (they were sized for the
  Mac's ~3.2 s verify, not the host's); or overlap the atalkdrive-free
  halves, since only the sections that put a stack on the group need the
  mutex at all. Do neither without a before/after `make -j t1` timing --
  a budget cut that makes the group flaky costs far more than 100 s.

### language-runtime-cleanup phase (2026-09-06)

- **CRC hot loops pay a bounds-check + multiply per byte** (final
  review) — `cgArrElemAddr` emits an `rtArrCheck` JSR and a `BSR mul32`
  for every array index, even at a constant stride, so `crc16`/`crc16x`/
  `crc32`'s per-byte table loop pays that cost where `crc32` used to be
  a raw `peekl`. `perfgate/` is green and `crc16`/`crc16x` (were 8-step
  bit loops) probably still net faster; worth one Mac Plus measurement
  before 68kbbs leans on `crc16` for transfers. Lever: a constant-stride
  shift peephole in `cgArrElemAddr`.

- **Bulk `text` methods' loop-body residual** (clir-load-perf): ~10x a
  `move.b`-class floor on 68k; lever if it matters again is
  hand-emitted asm helpers (à la `cg_mul32`) or tighter loop codegen.

- **Truncate-on-reuse** alternative to design B's copy-on-install
  recorded (clir-load-perf spec §4); revisit only if the ~31k-copy
  install cost becomes unacceptable.

- **Retain/release elision** (ARC non-goal): trigger not met by
  measurement (deltas within noise). Revisit only if a
  refcount-heavier acceptance app or real hardware shows degradation.

### string-perf phase (2026-09-02)

- **Record-local default-init elision** — record (and `error`) locals
  still full-zero their string fields every call (`cgDefaultInitStrAt`
  via `cgRecordCtorAt`/the KErr arm); the same zeroed-tail argument
  applies but was out of the phase's approved scope. Measure first: a
  record-heavy hot loop would show it.

- **Concat/return-path inlining** — `a + b` and string returns still go
  out of line (`rtStrConcat`/`rtStrStore`, ~0.25-0.5 ms/call class on
  the Mini vMac lane); an order of magnitude below what the phase
  removed, unscheduled without new evidence.

- **Loop-invariant `&s`/length hoisting** — repeated `s[i]` in a loop
  re-derives the string address and re-loads the length byte per
  iteration even inlined; a real optimizer feature, not a patch.

- **Mini vMac bench-row bimodality** — `TestStrBench68k` rows flip
  between discrete speed states across runs of the SAME binary (ledger,
  `.superpowers/sdd/2026-09-02-string-perf/progress.md` Task 7).
  Cross-run per-row deltas under ~2x are not evidence; a future bench
  phase wanting finer resolution needs a fixed-speed emulator lane (or
  Snow).

### Serial/connection phase (2026-08-16)

- **Per-byte read path ceiling, both lanes** — `rtConnPump`'s
  byte-at-a-time `text.append` loop (`runtime/clarus/conn.cla:322`) and
  `rtConnDevReadByte`'s one-`PBReadSync`-per-byte native read
  (`runtime/clarus/conn_68k.cla:198`) are both already `ponytail`-
  commented in place: correct and plenty fast at serial rates (even
  57600 baud is ~170µs/byte, nowhere near per-call overhead), with the
  named upgrade lever being a batched `rtConnDevReadInto(slot, buf, n)`
  added to the per-lane waist if a future fast bulk transport ever makes
  it a bottleneck.

## Runtime / Toolbox (if it ever bites)

- **Re-evaluate how window-owned menu sets are drawn** (Andrew,
  2026-09-06; language-runtime-cleanup design §5): the first
  implementation rebuilds the menu bar on every activate/close that
  changes the front window's menu set — a few `InsertMenu`/`DeleteMenu`
  calls plus one `DrawMenuBar`, skipped when the target set equals the
  current one. Revisit once real multi-window apps use it: whether the
  redraw is visibly slow on a Mac Plus, whether the bar should instead
  be swapped as a whole (per-window `MenuList` handles via
  `SetMenuBar`/`GetMenuBar`, the System 6 idiom for exactly this), and
  whether the app-scope menus should stay on the left or the right of a
  window's set.

- **Unreproduced live-input popup anomaly** (mac-target-4d): Protocol
  popup failed to open once; 20+ repro attempts failed. Guarded by the
  `rt_ui_popup_assert_alive` tripwire in both scripted popup lanes — if
  it fires, investigate menu lifecycle across form reopen.

- **Modal form map-element writeback upserts** (`RT_UI_WB_MAP` uses
  `rt_map_set`): a key removed by a timer mid-edit is re-inserted on
  OK. Deliberate; descriptor carries enough to check-then-set if upsert
  proves wrong.

- **S7 native popup CDEF** (parked 2026-07-28): dormant scaffolding
  behind `RTUI_POPUP_CDEF`; enabling needs real per-popup `'MENU'`
  resources emitted at build time.

- **Odd-C-size record-layout divergences** (strn-field-alignment
  out-of-scope): `char[n]`/`bool[n]` with odd n, the `char[1]`/`bool[1]`
  degenerate case (decide reference wording vs `cgSlotSizeOf` first),
  and all-byte records still diverge cprint vs cg68k in size/alignment.
  Latent — offsets never consumed cross-lane today.

- **Native non-UI `App.startCLI` dispatch is known-broken** (cg68k
  startup stub calls every handler unconditionally and never marshals
  `args`) — deprioritized by design ("CLI targets the host"); blocks
  booting `abort_uncaught`/`abort_launch_uncaught` natively
  (attempt-abort Task 8; two named resolutions, none adopted).

### binary-files phase (2026-08-22)

- **`natItoa`/`rtUiIntToText` stay unmerged** (Task 3 ruling, reverted a
  same-body collapse) — three near-identical int-to-string bodies live
  in the runtime (`natItoa`, `rtUiIntToText`, and `string(n)`'s own
  `rtIntToStr`) rather than one shared routine, because collapsing them
  pulled `str.cla` into every native binary's always-reachable set
  (`globals.cla` 2→3 CODE segments) for no user benefit. Duplication
  only, no functional gap; revisit if a future phase needs the shared
  body for another reason anyway.

- **UI/non-UI connection-pump lane gap** (Task 9's report) — the native
  lane only pumps `connection` traffic (`nat_UiConnPump`) for
  UI-classified programs (window/menu/`every` present); the host C lane
  only ever compiles NON-UI programs (`cprint` emits `#include
  "rt_ui.h"`, which lives only under `runtime/mac/`, so `cc` against
  `runtime/host` fails outright for any program with a `window`/`menu`).
  There is no single program shape that both boots on the host dev lane
  AND pumps connections on native — a serial/BBS-style program has to
  carry at least one throwaway status window purely to get native
  pumping (`examples/pagefile.cla`'s workaround). Serial-connection
  phase's own spec §3/§7 promised one program shape on both lanes; it
  doesn't hold today. Also affects `examples/serialecho.cla`'s doc
  comment, fixed this task to state the real constraint instead of
  claiming host-lane runnability it never had.

  Moved here verbatim from `docs/TODO.md` on 2026-09-07 (Andrew's ruling
  during the AppleTalk phase): the gap is a lane-shape consequence of how
  the two backends classify programs, not debt anyone owes. That phase
  also narrowed it — `every` alone no longer classifies a HOST
  program as a UI program (`irIsUiProgram`'s `irEveryCount > 0 and
  want68k`, `clarusc/cprint.cla`; spec §6.4), while the native lane
  still treats an every-only program as a real UI program, so the shape
  that both compiles on the host AND pumps natively is now "carry one
  `every` timer" rather than "carry a throwaway window". A single shape
  that needs neither still does not exist.

### AppleTalk phase (2026-09-07)

- **Host-lane ADSP** (spec §11, out of scope this phase) — the host
  stack drops DDP type 7 on the floor, and every `rtAdspDev*`/`rtLsnDev*`
  entry point in `runtime/clarus/atalk_c.cla` is a stub reporting
  "unavailable" — `rtAtErrNoHost` / 0 / false, per its own header note —
  so `connection.open(appletalk ...)` and `listener.register` are
  native-only. Implementing it is roughly
  800-1500 lines of C in `runtime/host/rt_atalk.inc` (which is 1252
  lines today) mirroring the ATP layer already there: connection state
  machine, sequenced send/receive queues, open/close handshake,
  retransmit and forward reset. The payoff is a host lane that can serve
  and dial ADSP — and `system.hasADSP()` (recorded in `docs/TODO.md`)
  could then answer true on the host instead of always false. Pull it
  only if host-side ADSP development (or a host end of a two-peer test)
  is actually wanted; the emulator lane covers ADSP today.

- **A `service.call` retry knob** (spec §4.4, out of scope this phase)
  — request timeout and retry count are fixed at 2 s × 3, and the NBP
  lookup at 1 s × 3, with no way for a program to widen them for a slow
  or busy peer or tighten them for a snappy UI. Shape if it ever bites:
  optional named arguments on `serve`/`call`, or a `svc.timeout(ms,
  retries)` setter — both are pure plumbing down to the `timeOutVal`@45
  / `retryCount`@47 ATP fields (`toolbox/appletalk.cla`) the native lane
  already writes.

## Hardening candidates

### binary-files phase (2026-08-22)

- **Handle generation-counter idea (spec §7, out of scope this phase)**
  — `filehandle`/`connection` values are bare small ints (slot+1); a
  closed-then-reused slot number is indistinguishable from the original
  handle at the type level (no staleness detection). A generation
  counter packed into the value (or a parallel generation table checked
  by every `rtFh*`/`rtConn*` call) would catch use-after-close bugs
  instead of silently operating on a reused slot. Recorded, unscheduled.

- **`rt_fileh.inc`'s `rt_ext_FhH*` glue never guards `h <= 0`** (Task 5
  minor) — safe only because `fileh.cla`'s own nil check panics before a
  bad handle ever reaches the C glue, and there is no way for user code
  to forge a handle value; hardening candidate if that invariant ever
  loosens.

- **`rtFhDevFlush`'s two-attempt error shape is invisible** (Task 6
  minor; final-review wave M5; `runtime/clarus/fileh_68k.cla`) — it
  always issues BOTH `PBFlushFileSync` and `PBFlushVolSync` and reports
  the file error over the vol error when both fail, deliberately (a
  vol-flush failure after a file-flush success is still surfaced), but
  nothing about the return value tells a caller two attempts were made
  or which one is being reported. Documented behavior, not a bug.

### filesystem-api phase (2026-08-26)

- **`rtFhDevListBegin` (host lane) leaks `rtFhListBuf` if called twice
  without an intervening `ListEnd`** (Task 4 minor, deferred;
  `runtime/clarus/fileh_c.cla:180`) — unreachable today (`rtFhList`'s
  own begin/next-loop/end shape always pairs them); one-line guard if a
  future caller ever calls `ListBegin` directly without going through
  `rtFhList`.

- **`rtFh68kName` truncates the Pascal length byte for a path over 255
  characters** (Task 5 minor, deferred; `runtime/clarus/
  fileh_68k.cla:59`) — pre-existing HFS path-length idiom; no
  overrun, just silent truncation of an already-illegal-length HFS
  path.

## Bake / CLIR

### compiler-cleanup phase (2026-09-05)

- **Smart linking / IR-body removal from the 68k lane + link-time
  layout improvements**: gated behind a future oracle-relaxation
  decision (object-code-linker design boundary).

## Tooling

- **Host CLI progress bar** (clarusc-live-log follow-up): reuse the
  `feProgressStep`/`feProgressTick` seams for a stderr bar/spinner.

### AppleTalk phase (2026-09-07)

- **`hostrt/atalk` costs ~24 s of T1** (Task 2's report; `rt_atalk_test.c`
  `main`'s own watchdog comment says the same) — three NBP registers,
  each paying a 3 × 1 s verify lookup, plus the lookups the test itself
  makes. It is the slowest host test. The only ~3 s lever is to drop one
  of the three registers (there is no cheaper register: re-registering a
  name that is still live answers `nbpDuplicate`, and `test_ext` already
  re-registers the one `test_nbp` removed). Not taken — the verify
  window is the ruled behavior, and one register per subtest keeps the
  subtests independent.

- **Snow's LocalTalk-over-UDP bridge has no launch flag** (Task 13c).
  It is off by default and reachable only through the menu bar Snow's
  egui draws inside its own window: `--serial-bridge-b localtalk` (and
  `ltoudp`, and `udp`) get
  `WARN snowemu::app Invalid serial bridge mode ... Use 'pty' or
  'tcp:PORT'` and are then ignored, the `.snoww` workspace has no
  serial-bridge field to serialize, PRAM only picks which GUEST port
  AppleTalk uses, and Snow's own `settings.json` has no such key — each
  measured, not assumed. So `tests/lib_snow.sh`'s `snow_localtalk_b`
  clicks **Ports → Channel B (printer) → Enable LocalTalk (UDP)** at
  fixed offsets from the Snow window's origin ((+250,+49) / (+310,+95) /
  (+498,+184)) and then waits for Snow's own
  `LocalTalk bridge enabled` log line, failing with the exact geometry
  it used if that never arrives. Ratified for the opt-in Snow lane — it
  fails loudly rather than silently, and the lane already needs a real
  unlocked display — but it means every future Snow AppleTalk test
  inherits a pixel click, and a Snow release that moves the Ports menu
  breaks the lane until the offsets are re-measured. The clean fix is
  upstream, the same one-line shape as this phase's LaunchAPPL patch: a
  `--serial-bridge-b localtalk` mode in Snow. Worth asking for.

### MacTCP phase (2026-09-08)

- **A MacIP gateway on the host LToUDP stack**, so a System 6 Mini vMac
  guest could reach TCP at all. MacTCP on the Mac Plus lane has no
  Ethernet to talk to — the emulator cannot attach to a tap device —
  and the only transport it and the host already share is the
  LocalTalk-over-UDP group `239.192.76.84:1954` the runtime's own stack
  is on. MacIP (IP datagrams encapsulated in DDP, RFC 1742's
  KIP/AppleTalk gateway) is the 1980s answer, and the host stack is
  already a real LocalTalk peer with a DDP layer, so the gateway half
  would live in `runtime/host/rt_atalk.inc` beside the ATP layer:
  answer the MacIP gateway NBP name, hand out an address, and bridge
  DDP type 22 both ways to a host socket. That would put the native TCP
  lane under T2 instead of only the opt-in Snow lane. Sized in the
  hundreds of lines and worth it only if System 6 TCP itself becomes a
  target — Snow (System 7, DaynaPORT SCSI Ethernet) already covers the
  hardware proof.

- **Snow port forwarding, inbound.** `snow_ethernet`'s NAT is
  outbound-only: the guest (10.0.0.2, gateway 10.0.0.1) can dial out,
  but nothing on the host can dial IN, and there is no DNS. So a test
  where the HOST is the client and the guest is the server has to be
  written as a self-connect on the guest's own address, which is
  exactly what `tests/mactest/snow/tcp_selfconnect.sh` does. An
  inbound port-forward option (Snow's own NAT config, or running the
  emulator behind a host-side forwarder) would let the host lane's
  `tcpdrive` peer drive a real Macintosh server. The other half of this
  wish — a second Snow bundle so a test boot can coexist with Andrew's
  BBS instance — is DONE (2026-09-08): `snow/ClarusSnow` is a symlink
  into a separate `snow/Snow.app` copy, and `tests/lib_snow.sh` quits
  by our own pid, never by app name.
