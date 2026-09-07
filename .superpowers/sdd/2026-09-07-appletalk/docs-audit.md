# AppleTalk phase — documentation audit

Read-only audit of the repo's docs against `git diff dbacb90..6e6e3d4`
(the AppleTalk phase, merged to `main` 2026-09-07). Ground truth: the
spec (`docs/superpowers/specs/2026-09-06-appletalk-design.md`, amended at
close-out), the plan, the `progress.md` rulings, `docs/HISTORY.md`'s
phase entry, and targeted reads of the code. Nothing was edited.

## Step 1 — user-visible surface inventory

| Item | Implementing file | Documented in |
|---|---|---|
| `service` resource type (`serve`/`reply`/`stop`/`call`, events `request`/`failed`) | `clarusc/check.cla`, `clarusc/lower.cla:1526+`, `runtime/clarus/atalk.cla:285-500` | reference ch12 "Services" (1503-1556); Appendix B (2171-2172) ✓ |
| `serviceBrowser.find(type, zone)` overload, `zones(out)`, `done` event | `clarusc/check.cla`, `lower.cla`, `atalk.cla:506-556` | reference 1462-1478; Appendix B 2168-2170 ✓ |
| `listener.stop()`; `register` as ADSP+NBP; `accepted` already-open | `atalk.cla:560-600`, `lower.cla:1677+` | reference 1424-1458 ✓ |
| Listener torn down (name removed, slot released) after a post-register `failed` | `atalk.cla:926-932` (fix wave I3) | **nowhere** — MISSING (M3) |
| ADSP as `connection` transport 1: `open(appletalk "Name:Type")`, `open(addr)`, `closed`, binary-safe `received` | `runtime/clarus/atalk.cla`, `atalk_68k.cla`, `conn.cla` (+11 lines) | reference 1347-1392 ✓ |
| Connection cap 4 → 8; caps 2 listener / 2 serviceBrowser / 2 service, build error naming the cap | `lower.cla` slot pre-pass; `tests/atalk/runerr.sh:59-61` | reference 174 ✓ (see S2 for TODO) |
| `address` inline 4-byte value; `string(addr)` → `net.node.socket` | `lower.cla:1404`, `rtAtalkAddrStr` | reference 169/176/217/1476 ✓ |
| `found`'s `name` is already `"Object:Type"` (the 13a bug) | `atalk.cla` lookup path; `examples/atalkchat.cla:174-177` | reference 1478 ✓ |
| `svc.call`'s `reply` must be a `text` variable (one-off guard) | `clarusc/check.cla`; `testdata/errors/svc_call_reply.expect` | reference 1556 ✓; class-wide hole in TODO 209-228 ✓ |
| `string()` diagnostic now "an int, char, or address" | `testdata/errors/addr_string.expect` | reference 217 ✓ |
| Host lane: real LToUDP peer — NBP/ATP/discovery/`serve`/`call` work, ADSP does not; `zones` always `["*"]`; `CLARUS_ATALK_IFACE` | `runtime/host/rt_atalk.{h,inc}`, `atalk_c.cla` | reference 1558 ✓ |
| Host `serve()` blocks ~3 s on NBP's verify window | `rt_atalk.inc` (spec §6.1 amendment) | **nowhere** — MISSING (M4) |
| Serial `stdio` / `pty` host transports | `runtime/host/rt_serial.inc` | reference 1403 ✓ |
| `every` timers in the host CLI pump (a non-UI `every` program now compiles on the host) | `clarusc/lower.cla` (`clar_every_pump`), `rt_ext_host.inc` | reference 1403 ✓ |
| `toolbox/appletalk.cla` — `.MPP` (LAP/DDP/NBP), `.ATP`, `.XPP` (ZIP), `.DSP` (ADSP), + `PBControlAsync`; `NewPtrClear` in `toolbox/memory.cla` | `toolbox/appletalk.cla` (586 lines) | cookbook §14 (967-1225) ✓; CLAUDE.md:353 ✓; cookbook's two catalog LISTS stale (W5, S3) |
| Examples `atalkclock.cla`, `atalkchat.cla`, `atalkfind.cla` | `examples/` | own headers ✓ (one nit, N2); no `examples/README` exists |
| `tests/tools/atalkdrive.c` driver tool | `Makefile:22-25` | CLAUDE.md tools list omits it (S1) |
| T1 groups `tests/atalk/` (7), `tests/atalkdrive/` (2), `tests/hostrt/atalk.sh`; `tests/conntest/{stdio,pty,every,atalk_check}.sh`; `tests/bake/{atalk,every_cli}.sh` | those files | CLAUDE.md:117-143 ✓ (conntest/bake additions not enumerated — no inventory there, fine) |
| `atalk_lock` mkdir mutex; multicast group; `CLARUS_ATALK_IFACE` | `tests/lib_atalk.sh` | CLAUDE.md:117-136 ✓ |
| Gated boots `mactest/atalk_68k.sh`, `atalk_selfserve.sh`, `adsp_68k.sh` (now 12/12); `run_mac_pair` | `tests/lib_mac.sh`, those scripts | CLAUDE.md:177-189 ✓ except `atalk_selfserve` unnamed (M8) |
| LaunchAPPL `CopySystemFile("AppleTalk", false)` prerequisite | out-of-repo `Retro68/LaunchAPPL/Client/MiniVMac.cc` | CLAUDE.md:382-393 ✓; ROADMAP:157-161 ✓ |
| `macplus2/` second emulator (gitignored) | `.gitignore:4`, `run_mac_pair` | **nowhere** — MISSING (M5) |
| Snow lane `mactest/snow/adsp_listener.sh` + `snow_localtalk_b` menu click | `tests/lib_snow.sh:309-390` | CLAUDE.md:168-175 ✓; FUTURE:368 ✓; ROADMAP env note contradicts (W7); Snow howtos silent (M7) |
| Toolbox suite 38 → 40 (`AtalkSelf`, `AdspLeak`) | `testsuite/toolbox/cases_atalk.cla`, `runner.cla` | CLAUDE.md:258-322 ✓ (all five sites) |
| Deferred: host ADSP / `call` retry knob / T1 wait budgets / Snow bridge flag / `delay` verb / UI-non-UI pump gap | — | FUTURE 278, 293, 121, 368, 44, 250 ✓ |
| Deferred: listener-teardown test / `atalk_lock` steal race / `AdspLeak` waist + `--testapi` visibility / `text` out-param hole / `system.has*` | — | TODO 158, 173, 189, 209, 232 ✓ |
| Deferred: `lowSynthAtalkFire{Simple,Failed}` dispatcher fold (MacTCP) | `clarusc/lower.cla:8100+` | HISTORY only — MISSING (M6) |

## Findings

### WRONG (a doc states something false about the code)

1. `docs/TODO.md:78-81` — WRONG — "No committed emit-time fixture pinning
   the unchanged `lowUnsupported` rejection for `appletalk`/local-receiver
   shapes (Task 5) — those shapes still reject the same way pre-phase".
   `appletalk` shapes are LOWERED now (`clarusc/lower.cla:1631`); nothing
   rejects them. Proposed: drop the `appletalk` half —
   "**No committed emit-time fixture pinning the `lowUnsupported`
   rejection for local-receiver connection shapes** (Task 5) — the
   `appletalk` half of this entry was closed by the AppleTalk phase
   (2026-09-07), which lowers those shapes; the local-receiver shapes
   still reject the same way pre-phase."

2. `docs/ROADMAP.md:169-172` — WRONG — "AppleTalk runs over UDP instead,
   which means two Snow instances running simultaneously can see each
   other over AppleTalk (the way to test AppleTalk peer-to-peer)." Snow's
   LocalTalk-over-UDP bridge is OFF by default and has no launch flag or
   workspace field (Task 13c; `tests/lib_snow.sh:309-330` —
   `--serial-bridge-b` accepts only `pty` and `tcp:PORT`). Proposed
   addition after that sentence: "Snow's LocalTalk-over-UDP bridge is off
   by default and has no launch flag — it is turned on per run from Snow's
   own **Ports > Channel B > Enable LocalTalk (UDP)** menu, which is what
   `tests/lib_snow.sh`'s `snow_localtalk_b` clicks; once on, the guest
   joins the same `239.192.76.84:1954` group Mini vMac and the host
   `atalkdrive` tool are on."

3. `README.md:42-43` — WRONG — "**Next** — the actual Macintosh target
   (Toolbox backend), then memory + forms runtime, networking, and finally
   building Clarus programs *on* a Mac." All four are done; networking now
   includes serial `connection` and AppleTalk. Proposed replacement:
   "- **Macintosh target** — native 68k `.APPL` binaries (`emit68k`), the
   full UI runtime, and `ClarusC.APPL`, which compiles Clarus programs on
   the Mac itself.
   - **Networking** — `connection` over a serial port or AppleTalk (ADSP),
   NBP service discovery, and ATP request/response `service`s; a
   command-line host build is a real LocalTalk-over-UDP peer on the same
   wire as an emulated Mac.
   - **Next** — MacTCP."

4. `README.md:45-55` — WRONG — the Building section tells the reader to
   `go build -o clarus ./cmd/clarus`; the Go compiler was deleted (tag
   `go-compiler-final`) and `cmd/clarus` does not exist. Pre-existing, not
   caused by this phase, but it is the first command a reader runs.
   Proposed: delete the Go block and promote the snapshot bootstrap
   already at 57-62, adding "`scripts/clarus-run.sh FILE.cla` is the
   day-to-day `clarus run`."

5. `docs/clarus-toolbox-cookbook.md:702` — WRONG — "The four
   `toolbox/*.cla` files are ordinary user-side declaration files". There
   are eleven (`appleevents`, `appletalk`, `devices`, `events`, `files`,
   `memory`, `osutils`, `resources`, `scrap`, `serial`, `standardfile`).
   Proposed: "The `toolbox/*.cla` files are ordinary user-side declaration
   files, not runtime modules".

### STALE (true once, superseded)

6. `CLAUDE.md:52-53` — STALE — the C-helper list "`timeout`, `uiblob`,
   `resfork`, `clirhdr`, `tcpdrive`" omits `atalkdrive`, which
   `Makefile:22-25` builds into `build-run/tools/` and which every
   `tests/atalk/` script drives. Proposed: "…`clirhdr`, `tcpdrive`,
   `atalkdrive`)".

7. `docs/TODO.md:83-84` — STALE — "**No coverage for the >4-connections
   build error** (Task 5) — the cap exists and is enforced, just untested."
   The cap is 8 now (reference:174). Still genuinely untested — there is no
   `too_many_conn` fixture beside `tests/atalk/runerr.sh`'s
   `too_many_{lsn,brs,svc}` — so the entry survives with a new number.
   Proposed: "**No coverage for the >8-connections build error** (Task 5;
   cap raised 4 → 8 by the AppleTalk phase) — the listener/serviceBrowser/
   service caps got fixtures in `tests/atalk/runerr.sh`; the connection cap
   did not."

8. `docs/clarus-toolbox-cookbook.md:15-17` — STALE — "the curated catalog
   under `toolbox/` (`memory.cla`, `events.cla`, `osutils.cla`,
   `scrap.cla`)" predates seven more catalog files, `appletalk.cla`
   included — and §14 of this same document walks through it. Proposed:
   "the curated catalog under `toolbox/` (`memory.cla`, `events.cla`,
   `osutils.cla`, `scrap.cla`, `devices.cla`, `files.cla`,
   `standardfile.cla`, `serial.cla`, `resources.cla`, `appleevents.cla`,
   `appletalk.cla`)".

9. `docs/ROADMAP.md:57-60` — STALE — the "Where we are (2026-09-06)"
   heading and "Everything through the `compiler-cleanup` phase is merged
   to `main` and pushed (`c5d447b`)" both predate this phase; the section
   carries a closing paragraph for each of the two preceding phases and
   none for AppleTalk. Proposed: retitle to `## Where we are (2026-09-07)`
   and add, after the `native-array-return-and-fileh-guards` paragraph:
   "**`appletalk` is COMPLETE and MERGED to `main`** (2026-09-07). Clarus
   programs now discover services with `serviceBrowser`, answer and make
   ATP requests with the new `service` resource, and open ADSP streams as
   `connection`s with `listener` accepting them — natively on real
   LocalTalk, and, for discovery and RPC, on the host as a genuine
   LocalTalk-over-UDP peer. It also cleared the serial phase's two
   carry-ins (host `stdio`/`pty`, `every` in the host CLI pump). Full T2
   green (1350 s), `adsp_68k` 12/12 and `toolbox_68k` 40/40 on hardware.
   Details: `docs/HISTORY.md`'s own entry."

10. `docs/ROADMAP.md:4` — STALE — "Updated 2026-09-05"; the file was
    amended 2026-09-07 (commit `6e6e3d4`). Proposed: "Updated 2026-09-07."

11. `docs/HISTORY.md:5880-5881` — STALE — "merging to `main` is Andrew's
    call and had not happened when this was written." It has happened: the
    phase is on `main` at `6e6e3d4`, and `docs/ROADMAP.md:157` says so.
    (The same sentence appears verbatim in the three preceding entries —
    it is a house convention for a write-time snapshot — so the minimal fix
    is an appended clause, not a rewrite.) Proposed: append
    "**Merged to `main` 2026-09-07.**" to that sentence.

### MISSING (an item with no doc at all)

12. `README.md:32-43` — MISSING — the file has zero mentions of AppleTalk,
    of `connection`, or of the Toolbox catalog. Covered by finding 3's
    proposed Status bullets; nothing else in README needs AppleTalk text.

13. `README.md:66-72` — MISSING — the Repository layout table lists
    `docs/`, `tests/`, `clarusc/`, `testdata/` only: no `runtime/`,
    `toolbox/`, or `examples/`, so a reader has no pointer to the catalog
    the cookbook documents. Proposed rows: "| `runtime/` | The Clarus and
    C runtime modules spliced into every build |", "| `toolbox/` | Curated
    Inside Macintosh trap declarations, per manager |", "| `examples/` |
    Complete sample programs (`atalkclock`, `texteditor`, `bookmarks`, …) |".

14. `docs/clarus-language-reference.md:1458` — MISSING — a `listener` that
    fails AFTER a successful `register` is now torn down, not merely
    reported: `atalk.cla:926-932` calls `rtLsnStop` after
    `rtLsnSetFailed`, so the NBP name is removed and the slot released. A
    program must `register` again to resume; the reference says only that
    `failed` is delivered. Proposed sentence after 1458: "A `failed` that
    arrives after a successful `register` also stops the listener — the
    name is removed and the listener released, exactly as if `stop()` had
    been called — so a program that wants to keep serving must
    `register` again."

15. `docs/clarus-language-reference.md:1558` — MISSING — on the host lane
    `serve()` blocks for its ~3 s NBP verify window (the spec's §6.1
    close-out amendment; parity with the Mac's own `registerName`). Nothing
    in the reference warns a host program that `serve` is not instant.
    Proposed clause inside the host-lane paragraph: "One timing difference:
    on the host, `serve` blocks for about three seconds while NBP verifies
    the name is not already taken — the same verification the Macintosh
    does inside `registerName`."

16. `CLAUDE.md:395` — MISSING — the toolchain symlink list documents
    `macplus/` but not `macplus2/`, the second Mini vMac instance
    (`MacPlus2.app` + its own `disk1.dsk`) that `run_mac_pair` and
    `tests/mactest/adsp_68k.sh` require; it is gitignored
    (`.gitignore:4`), so nothing else in the repo names it. Proposed line
    after 395: "- `macplus2/` → a second Mini vMac (`MacPlus2.app` +
    `vMac.ROM` + its own `disk1.dsk`, an identical copy of `macplus/`'s) —
    `tests/lib_mac.sh`'s `run_mac_pair` boots it as the second machine for
    `mactest/adsp_68k.sh`. Missing ⇒ that script cannot run."

17. `docs/TODO.md` (AppleTalk phase section, after line 203) — MISSING —
    the deliberately-deferred dispatcher fold is recorded only in
    `docs/HISTORY.md:6360-6365`, not in the file that "holds the condensed
    open follow-ups". Proposed entry: "**`lowSynthAtalkFire{Simple,Failed}`
    duplicate ~70 lines of the connection dispatcher builders**
    (`clarusc/lower.cla`). The final review recommended folding them; the
    fold edits code every `emitui` and `cg68k` golden pins, for zero
    behaviour change, so it was deferred to the MacTCP phase, where a third
    copy makes the case and the corpus is reblessed anyway."

18. `CLAUDE.md:188` — MISSING — `tests/mactest/atalk_selfserve.sh` (serve +
    browse with no peer, written to pass on both boot disks; PASS in 18 s
    at the final gate) is never named, while its two siblings are.
    Proposed: extend that sentence — "`tests/mactest/atalk_68k.sh` (NBP/ATP
    over the ROM's own `.MPP`/`.ATP`) and `tests/mactest/atalk_selfserve.sh`
    (serve + browse with no peer at all) need no such file."

19. `docs/snow-floppy-howto.md:101-103` — MISSING — "Other useful flags:
    `--serial-bridge-a tcp:PORT` / `--serial-bridge-b …` (SCC serial to TCP
    or PTY)" is correct but incomplete in the one way that now matters:
    LocalTalk-over-UDP is NOT a bridge mode. Proposed added sentence: "Note
    that `--serial-bridge-*` takes only `pty` and `tcp:PORT` — Snow's
    LocalTalk-over-UDP bridge is not a flag; it is enabled per run from
    **Ports > Channel B > Enable LocalTalk (UDP)** in Snow's own in-window
    menu bar." (`docs/snow-hdd-howto.md` mentions no bridge flags at all
    and needs nothing.)

### NIT

20. `docs/HISTORY.md:9` — NIT — the `## Done (all merged to main)` list is
    items 1-11, an index of the pre-2026-08 milestones; it does not carry
    `go-retirement`, `compiler-cleanup`, `language-runtime-cleanup`,
    `native-array-return-and-fileh-guards` either. Adding AppleTalk alone
    would be inconsistent; leave it, or add all five in one pass. The
    condensed indexes at 1636-1644 and 4194-4205 are dated archival notes
    about earlier moves and do not need this phase.

21. `examples/atalkchat.cla:14-15` — NIT — the header still reads "then
    `open(appletalk "Name:Type")` to the first match", which is what the
    13a bug looked like from a distance (the code now passes `found`'s
    `name` straight through, correctly commented at 174-177). Proposed:
    "then `open(appletalk name)` — `found`'s `name` is already NBP's
    `"Object:Type"` spelling — to the first match".

22. `docs/clarus-language-reference.md:1441` — NIT — the Listeners example
    calls `server.listen(6502)`, which is still a build error (the MacTCP
    fence lowering rejects). Pre-existing and deliberate (the reference
    specifies MacTCP ahead of implementation); worth a one-clause fence
    note when MacTCP lands, not now.

23. `docs/clarus-language-reference.md` "Contents" (12-27) — NIT — chapter-
    level only, no per-section index, so the new Services / Service
    Discovery sections need no TOC entry. No action.

## Counts

- WRONG: 5 (findings 1-5)
- STALE: 6 (findings 6-11)
- MISSING: 8 (findings 12-19)
- NIT: 4 (findings 20-23)
