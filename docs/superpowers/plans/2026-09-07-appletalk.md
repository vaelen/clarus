# AppleTalk Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make AppleTalk real in Clarus: NBP discovery (`serviceBrowser`), ATP request/response services (a new `service` resource), ADSP streams as `connection`'s second transport with `listener` accepting them — on real LocalTalk (Mini vMac, Snow) and, for discovery and RPC, on the host as a genuine LocalTalk-over-UDP peer — plus the two recorded serial items (host `stdio`/`pty` transports, `every` timers in the host CLI pump).

**Architecture:** A probe wave (Mac) and the host C stack (LToUDP + LLAP + DDP + NBP + ATP, instance-able, with a unit test and the `atalkdrive` driver tool) start together with the checker/parser front end and the two serial items. Then the Toolbox catalog (`toolbox/appletalk.cla`, hardware-proved by a suite case) and the lane-neutral runtime module `atalk.cla` with its `_c` twin land in parallel; lowering wires the four resource kinds and proves the host lane end to end against `atalkdrive`. One native-integration task then adds `atalk_68k.cla`'s real `.MPP`/`.ATP`/`.XPP`/`.DSP` bodies, the ADSP transport in `conn.cla`, the 68k splice, and the single planned golden rebless. Two parallel emulator-test tasks (one boot + `atalkdrive`; two boots for ADSP) and a docs task follow; Snow runs are last, before close-out.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C host glue (`runtime/host/*.inc`, `tests/tools/*.c`), POSIX-sh test harness (`tests/`), Mini vMac ×2 (`macplus/`, `macplus2/`, both LToUDP builds, both with AppleTalk 58.1.4) and Snow, Universal Interfaces at `toolchain/universal/CIncludes/{AppleTalk.h,ADSP.h,MacErrors.h}` (CR line endings: read via `LC_ALL=C tr '\r' '\n'`; BSD `/usr/bin/grep -a`, since ugrep treats them as binary).

**Spec:** `docs/superpowers/specs/2026-09-06-appletalk-design.md` — read it first; every task below argues from it. Where this plan refines the spec (host `every` via a synthesized pump, the synthesized `clar_conn_pump` calling `rtAtalkPump`, the joint conn+atalk host splice), the spec has been amended to match.

## Global Constraints

- Branch: all work on `appletalk` (exists, spec committed at f0c40d7). Merge to `main` only on Andrew's explicit request; `main` stays green.
- **Parallel execution.** Tasks are grouped in waves. Tasks in one wave own disjoint files (see the file map) and run concurrently, each in its own git worktree on a branch `appletalk-tN` cut from the current `appletalk` tip; the controller merges each finished task back into `appletalk` (fast-forward or rebase), runs the task's gate again on the merged tree, then starts the next wave. A task must not edit a file another task in the same wave owns. `docs/clarus-language-reference.md` is the one shared file (Tasks 3, 4, 5 edit different sections) — merge conflicts there are resolved by the controller, never by rewriting another task's section.
- After every task: `scripts/test-task.sh`; add `--smoke` when the task touches `runtime/` or `clarusc/` (mandatory per CLAUDE.md). The task's own new tests must be included in T1 (`make -j t1` picks up every `tests/**/*.sh`).
- Emulator-gated tests need `CLARUS_MAC_TESTS=1` and run `-j1`. **No Snow boot happens before Task 13** (Andrew's instruction: all Snow runs at the very end). The standing `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` rerun (owed because `bake.cla`'s module list changes) is Task 13's job.
- csCodes, constants, error codes, and parameter-block offsets in this plan are transcribed from the Universal Interfaces headers (2026-09-07) and cross-checked against Inside Macintosh; the catalog task cites both per declaration (the `toolbox/files.cla` provenance convention). The probe (Task 1) is authoritative for behavior.
- Before editing any `.cla` file, check for non-ASCII bytes (`LC_ALL=C grep -nP '[\x80-\xff]' FILE`); if any, do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (project memory rule).
- Golden policy: every task before Task 9 must produce ZERO `testdata/cg68k` churn (new runtime modules are host-only-spliced or dormant; if a native golden churns, STOP and investigate). Task 9 contains the ONE planned rebless wave; rebless there only with a normalization-diff proof that the churn is renumbering/addition. `testdata/emitui/*.c.golden` are compare-only host-C goldens: a task that legitimately changes host emission for an existing fixture regenerates that golden deliberately and says so in its report.
- Runtime globals discipline: `atalk.cla`'s global table is declared in full by Task 7 and never grown afterwards; `atalk_68k.cla`'s globals are declared in Task 9 (the rebless task) and never grown afterwards. A later task that needs a new global in a 68k-spliced module triggers a second rebless and must say so explicitly.
- Commit after every task (prefix `feat:`/`fix:`/`test:`/`docs:`), each with a `task-N-report.md` in `.superpowers/sdd/2026-09-07-appletalk/` (create the ledger dir in Task 1 with `progress.md`).
- Subagent models: `sonnet` for implementation and review; Task 2 (protocol stack) and Task 9 (native integration) are the two candidates for `opus` if a sonnet attempt stalls (project memory: opus for hard debugging paid off twice). Never Fable.
- Test-name hygiene (spec §8.4): every test and example registers NBP names with a per-run suffix (`$$` or `date +%s`) and tolerates unrelated entities in lookup results — the multicast group also carries Andrew's live sessions and, when up, his EtherTalk bridge.

## Wave map (parallelism)

| Wave | Tasks (parallel within a wave) | Depends on |
|---|---|---|
| 0 | 1 probe (Mac) · 2 host stack (C) · 3 front end · 4 serial stdio/pty · 5 host `every` | — |
| 1 | 6 catalog + `AtalkSelf` · 7 runtime `atalk.cla` + twins | 6 ← 1; 7 ← 2, 3 |
| 2 | 8 lowering + host end-to-end | 3, 5, 7 |
| 3 | 9 native integration + rebless | 6, 8 |
| 4 | 10 `atalk_68k.sh` + `atalkclock` · 11 `run_mac_pair` + `adsp_68k.sh` + `atalkchat` · 12 docs | 9 |
| 5 | 13 Snow (interop, `adsp_listener.sh`, `clarusc_bake`) | 10, 11 |
| 6 | 14 close-out (snapshot, T2, HISTORY, final review) | 12, 13 |

## File map (who owns what)

- Task 1: `.superpowers/sdd/2026-09-07-appletalk/{progress.md,task-1-report.md}`, scratch only.
- Task 2: `runtime/host/rt_atalk.inc` (new), `runtime/host/rt_atalk_test.c` (new), `runtime/host/rt.c` (one `#include` line), `tests/tools/atalkdrive.c` (new), `tests/hostrt/atalk.sh` (new), `tests/atalkdrive/` (new group, tool self-tests).
- Task 3: `clarusc/types.cla`, `clarusc/check.cla`, `clarusc/lower.cla` (ONLY `lowTypeAt`), `docs/clarus-language-reference.md` (Chapter 12 network sections + Chapter 3 conversions), `tests/reftest/manifest.txt`, `testdata/errors/*.{cla,expect}` (the checker-diagnostic fixture group; `tests/selfhost/diag.sh` and `tests/lowlevel/xrecorder.sh` consume it) plus a check-clean fixture under `testdata/valid/`.
- Task 4: `runtime/host/rt_serial.inc`, `runtime/host/rt_serial_test.c`, `docs/clarus-language-reference.md` (Serial section only), `tests/conntest/{stdio,pty}.sh` (new).
- Task 5: `clarusc/cprint.cla` (`irIsUiProgram`, `cpEmitMain`), `clarusc/lower.cla` (new `lowSynthEveryPump` + the dispatcher call site), `runtime/host/rt_ext_host.inc` (`rt_ext_EveryDue`), `docs/clarus-language-reference.md` (host lifetime paragraph only), `tests/conntest/every.sh` (new), `testdata/emitui/every_cli.{cla,c.golden}` (new).
- Task 6: `toolbox/appletalk.cla` (new), `testsuite/toolbox/cases_atalk.cla` (new), `testsuite/toolbox/runner.cla`, `tests/mactest/{toolbox_68k,toolbox_jiggle,toolbox_mac}.sh` (count), `tests/mactest/toolbox_files.txt`, `tests/testsuite/catalog.sh`, `CLAUDE.md` (count line).
- Task 7: `runtime/clarus/atalk.cla`, `atalk_c.cla`, `atalk_68k.cla` (all new; `_68k` stubs only), `clarusc/drive.cla` (host splice + rtbake fallback), `tests/atalk/splice.sh` (new group).
- Task 8: `clarusc/lower.cla` (all lowering except `lowTypeAt`), `clarusc/cprint.cla` (`cpEmitMain` pump loop), `clarusc/ir.cla` (`irUsesAtalk`), `tests/atalk/*.sh`, `tests/lib_atalk.sh`, `testdata/emitui/atalk_*.{cla,c.golden}`, `examples/atalkfind.cla` (host CLI browser).
- Task 9: `runtime/clarus/atalk_68k.cla` (real bodies), `runtime/clarus/conn.cla`, `conn_68k.cla`, `runtime/host/rt_serial.inc` (`RT_CONN_MAX`), `clarusc/drive.cla` (68k splice), `clarusc/lower.cla` (dispatcher gate `or want68k`, slot cap 8), `clarusc/bake.cla` (module list), `scripts/build-clarusc-mac.sh` (`--bake` flags), `testdata/cg68k/*.s` (rebless), `tests/bake/atalk.sh` (new), `testdata/cg68k/atalk_*.cla` (new).
- Task 10: `tests/mactest/atalk_68k.sh` (new), `examples/atalkclock.cla` (new), `testdata/ui/atalkclock.events` (new).
- Task 11: `tests/lib_mac.sh` (`run_mac_pair`), `tests/mactest/adsp_68k.sh` (new), `examples/atalkchat.cla` (new), `testdata/ui/atalkchat_{server,client}.events`, `testsuite/toolbox/cases_atalk.cla` (`AdspLeak` case) + the five count sites.
- Task 12: `docs/clarus-toolbox-cookbook.md`, `docs/TODO.md`, `docs/FUTURE.md`, `docs/ROADMAP.md`, reference proofread.
- Task 13: `tests/mactest/snow/adsp_listener.sh` (new), `tests/lib_snow.sh` if needed; Snow gate runs.
- Task 14: `clarusc/clarusc.c`, `docs/HISTORY.md`, `docs/ROADMAP.md`, `CLAUDE.md`, memory notes.

---

### Task 1: Probe wave — Mac side (no tree commits except the ledger)

Per the established pattern (serial-connection Task 1): throwaway programs; the deliverable is a report with go/no-go findings and amendments to later tasks. Snow interop is NOT probed here (Task 13).

**Files:**
- Create: `.superpowers/sdd/2026-09-07-appletalk/progress.md`, `task-1-report.md`.
- Scratch (delete after): `$SCRATCH/atprobe/*.cla`, a python multicast sniffer.
- Read: `toolchain/universal/CIncludes/AppleTalk.h`, `ADSP.h` (CR-converted), `toolbox/devices.cla`, `testsuite/toolbox/cases_serial.cla` (trap-level PB idiom), `tests/lib_mac.sh:20-32` (`run_mac`), `tests/mactest/probe/FINDINGS.md` (report convention).

**Interfaces:**
- Produces: answers to probe questions P1–P4 below, recorded in `task-1-report.md`, each as "Result: X. Use it." plus the exact commands.

- [ ] **Step 1: P1 — `.DSP`/`.XPP` open on the LaunchAPPL boot disk**

Write `$SCRATCH/atprobe/drivers.cla`: a pure user program (declares its own `IOParam` extern record and `PBOpenSync`, copying `toolbox/devices.cla`'s shapes) that opens `.MPP`, `.ATP`, `.XPP`, `.DSP` in that order with `PBOpenSync` and writes one line per driver `NAME refnum=N err=E` to the file `out` (the LaunchAPPL echo channel, `tests/mactest/probe/FINDINGS.md`). Build with `scripts/build-68k.sh Drivers $SCRATCH/atprobe/drivers.cla`; boot with `toolchain/bin/LaunchAPPL -e minivmac build-68k/Drivers/Drivers.bin`. Expected: all four `err=0`; `.MPP` refnum −10, `.XPP` −41, `.DSP` some negative refnum. If `.DSP` fails, the LaunchAPPL stripped boot disk dropped the `AppleTalk` file: record what the stripped disk contains (`hls` on the temp image LaunchAPPL builds in cwd) and how to make it carry the file — this decides whether Tasks 9/11 need a custom boot image.

- [ ] **Step 2: P2 — NBP register on one Mac, lookup from the other, host sniffer sees both**

`register.cla`: opens `.MPP`, builds a packed `NamesTableEntry` (108 bytes via `NewPtrClear`: `qNext`@0, `nteAddress`@4 (4 bytes, zero), `filler`@8, then at @9 the packed entity: `[len]"Probe-<n>"` `[len]"ClarusProbe"` `[len]"*"`), `PBControlSync` with `csCode` 253 (`registerName`), `interval`@28 = 8, `count`@29 = 3, `ntQElPtr`@30 = the NTE, `verifyFlag`@34 = 1; writes `register err=E` to `out`, then idles 60 s (a `while TickCount() < deadline` loop) so the other Mac can look it up, then removes the name (csCode 252, `entityPtr`@30 pointing at the packed entity) and quits.
`lookup.cla`: opens `.MPP`, builds a packed entity `=` / `ClarusProbe` / `*`, `PBControlSync` csCode 251 (`lookupName`) with `entityPtr`@30, `retBuffPtr`@34 → a 1024-byte `NewPtrClear` buffer, `retBuffSize`@38 = 1024, `maxToGet`@40 = 16, `interval` 8, `count` 3; writes `lookup err=E gotten=N` and, per tuple in the buffer (tuple = `AddrBlock` 4 bytes, enumerator 1 byte, then three packed Pascal strings), `net.node.socket obj:type@zone`. Boot `register` on `macplus/` via the default LaunchAPPL config, and 5 s later `lookup` on `macplus2/` via `LaunchAPPL -e minivmac --minivmac-dir $ROOT/macplus2 --minivmac-path ./MacPlus2.app --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk build-68k/Lookup/Lookup.bin` (from a different cwd, since LaunchAPPL makes its temp dir in cwd). Meanwhile run the sniffer: python3 joining `239.192.76.84:1954` (`IP_ADD_MEMBERSHIP`, `SO_REUSEPORT`), printing each datagram as hex with the 4-byte sender id, LLAP dst/src/type, and the DDP type byte. Expected: `gotten=1` naming `Probe-<n>` at the register Mac's node, and the sniffer shows LLAP type 1 (short DDP) frames with DDP type 2 (NBP) both ways. Record the exact bytes of one `LkUp` and one `LkUp-Reply` frame — Task 2's NBP encoder/decoder is written against them.

- [ ] **Step 3: P3 — self-lookup and `SetSelfSend`**

Extend `register.cla` (a variant) to look up its OWN name after registering, once without and once after a `setSelfSend` control (csCode 256, `newSelfFlag`@28 = 1) — record whether `gotten` is 0 or 1 in each case. Then an ATP self-transaction: `openATPSkt` (csCode 254, `atpSocket`@28 = 0, result socket in `atpSocket`), an async `getRequest` (`PBControlAsync` = trap `0xA404 reg`, csCode 253, `atpSocket`@28, `reqPointer`@36 → 600-byte buffer, `reqLength`@34 = 578), then a sync `sendRequest` (csCode 255, `addrBlock`@30 = own net/node from the `AddrBlock` of P2's own tuple with the ATP socket, `atpFlags`@29 = 32 (XO), `reqLength`@34, `reqPointer`@36, `bdsPointer`@40 → one 12-byte BDS entry over a 578-byte buffer, `numOfBuffs`@44 = 1, `timeOutVal`@45 = 2, `retryCount`@47 = 3), and before that a poll loop is impossible in one sync program — so instead: issue the async `getRequest`, then the sync `sendRequest`, and after it returns check the `getRequest` PB's `ioResult`@16 ≤ 0 and respond with `sendResponse` (csCode 252, `bdsPointer`@40, `numOfBuffs`@44 = 1, `transID`@46 = the request's `transID`@46). Record whether the sync `sendRequest` completes (it can only complete if the response was sent — so if `ioResult` stays 1 and `sendRequest` times out with −1096, self-transactions are not viable in one program and `AtalkSelf` (Task 6) is register + self-lookup only). This decides `AtalkSelf`'s shape.

- [ ] **Step 4: P4 — two-boot launcher**

From a POSIX sh script, start `register` on `macplus/` in the background (`run_mac`-style: `$TOOLS/timeout 120 LaunchAPPL ... > cap1 2> err1 &`), and `lookup` on `macplus2/` 5 s later in a different cwd, capture both stdouts, wait for both, and confirm (a) both windows appear on screen at once, (b) each `out` echo lands in its own capture, (c) `pkill -f MacPlus2.app` kills only the second instance (record the process names `pgrep -l` shows for each). This is the `run_mac_pair` helper's design input (Task 11).

- [ ] **Step 5: Write the report; create the ledger; clean up**

`task-1-report.md`: P1–P4 verdicts, the recorded frame bytes, the exact LaunchAPPL override command line that worked for `macplus2/`, timing (boot to first NBP packet), and explicit amendments (or "none") to Tasks 2, 6, 9, 10, 11. `progress.md` with the task table. Delete `$SCRATCH/atprobe`, `build-68k/Drivers`, `build-68k/Register`, `build-68k/Lookup`. `git status` must show only the ledger.

```bash
git add .superpowers/sdd/2026-09-07-appletalk/
git commit -m "docs(sdd): appletalk Task 1 probe report"
```

---

### Task 2: Host LocalTalk-over-UDP stack — `rt_atalk.inc`, unit test, `atalkdrive`

Pure C, no Clarus involvement; runs in parallel with Task 1. Spec §6.1–6.2.

**Files:**
- Create: `runtime/host/rt_atalk.inc`, `runtime/host/rt_atalk_test.c`, `tests/tools/atalkdrive.c`, `tests/hostrt/atalk.sh`, `tests/atalkdrive/{lookup,call}.sh`.
- Modify: `runtime/host/rt.c` (add `#include "rt_atalk.inc"` BEFORE `#include "rt_serial.inc"`, with a comment in the style of the `rt_fileh.inc` one at `rt.c:247-254`).
- Read first: `runtime/host/rt_serial.inc` (whole; the style to match), `runtime/host/rt_serial_test.c:1-60` (CHECK macro, `OK` contract), `tests/tools/tcpdrive.c:1-60` (CLI shape), `tests/hostrt/serial.sh`, `Makefile:1-24`.

**Interfaces:**
- Produces (C, instance API — used by the test and by `atalkdrive`):

```c
typedef struct rt_atalk rt_atalk;
typedef struct { uint16_t net; uint8_t node, socket; } rt_at_addr;
typedef struct { rt_at_addr addr; char obj[33], type[33], zone[33]; } rt_at_tuple;
typedef struct { rt_at_addr from; uint16_t tid; uint8_t bitmap; int xo;
                 int32_t userbytes; uint8_t data[578]; int len; } rt_at_req;

rt_atalk *rt_at_open(const char *iface_ip);   /* NULL + errno on failure; joins the group, acquires a node id */
void      rt_at_close(rt_atalk *a);
int       rt_at_fd(const rt_atalk *a);        /* for select() */
uint8_t   rt_at_node(const rt_atalk *a);
void      rt_at_poll(rt_atalk *a);            /* drain UDP, run retransmit/release timers; never blocks */
/* NBP */
int  rt_at_nbp_register(rt_atalk *a, const char *obj, const char *type, uint8_t socket); /* 0, or -1027 nbpDuplicate */
int  rt_at_nbp_remove(rt_atalk *a, const char *obj, const char *type);                  /* 0, or -1028 */
int  rt_at_nbp_lookup_start(rt_atalk *a, int lk, const char *obj, const char *type, const char *zone); /* lk 0..9 */
int  rt_at_nbp_lookup_done(rt_atalk *a, int lk);                                        /* 1 when the 3x1s window has elapsed */
int  rt_at_nbp_lookup_count(rt_atalk *a, int lk);
const rt_at_tuple *rt_at_nbp_lookup_get(rt_atalk *a, int lk, int i);
/* ATP responder */
int  rt_at_atp_open(rt_atalk *a);                     /* socket 128..254, or negative OSErr */
void rt_at_atp_close(rt_atalk *a, int sock);
int  rt_at_atp_get_request(rt_atalk *a, int sock, rt_at_req *out);   /* 1 if one was dequeued */
int  rt_at_atp_send_response(rt_atalk *a, int sock, const rt_at_req *req, int32_t userbytes, const uint8_t *data, int len); /* len <= 4624 */
/* ATP requester (blocking; internally polls with select) */
int  rt_at_atp_call(rt_atalk *a, rt_at_addr to, int32_t userbytes, const uint8_t *req, int reqlen,
                    uint8_t *resp, int respcap, int *resplen, int32_t *resp_userbytes, int timeout_s, int retries); /* 0, or -1096 reqFailed, -3106 atpLenErr */
```

- Produces (Clarus-facing `rt_ext_AtalkH*` on ONE process-global instance; these are what `atalk_c.cla` declares in Task 7). `string` parameters arrive as `const uint8_t *` Pascal strings (`rt_fileh.inc:44-55`'s `path_to_cstr` idiom); names going back to Clarus are written into caller buffers as Pascal strings:

```c
int32_t rt_ext_AtalkHUp(void);                                  /* lazy rt_at_open(getenv("CLARUS_ATALK_IFACE")); 0 or errno */
int32_t rt_ext_AtalkHNode(void);
int32_t rt_ext_AtalkHRegister(const uint8_t *obj, const uint8_t *type, int32_t sock);
int32_t rt_ext_AtalkHRemove(const uint8_t *obj, const uint8_t *type);
int32_t rt_ext_AtalkHLookupStart(int32_t lk, const uint8_t *obj, const uint8_t *type, const uint8_t *zone);
int32_t rt_ext_AtalkHLookupDone(int32_t lk);
int32_t rt_ext_AtalkHLookupCount(int32_t lk);
int32_t rt_ext_AtalkHLookupAddr(int32_t lk, int32_t i);         /* packed: net<<16 | node<<8 | socket */
void    rt_ext_AtalkHLookupName(int32_t lk, int32_t i, void *out); /* Pascal "obj:type" into a 68-byte buffer */
int32_t rt_ext_AtalkHAtpOpen(void);
void    rt_ext_AtalkHAtpClose(int32_t sock);
int32_t rt_ext_AtalkHAtpGetRequest(int32_t sock, void *buf, int32_t cap); /* len >= 0, or -1 none */
int32_t rt_ext_AtalkHAtpReqOp(void);   int32_t rt_ext_AtalkHAtpReqFrom(void);   /* of the last dequeued request */
int32_t rt_ext_AtalkHAtpSendResponse(int32_t sock, int32_t code, void *buf, int32_t n);
int32_t rt_ext_AtalkHAtpCall(int32_t addr, int32_t op, void *req, int32_t reqLen, void *resp, int32_t respCap); /* resp len, or negative OSErr */
int32_t rt_ext_AtalkHAtpCallCode(void);
void    rt_ext_AtalkHPoll(void);
int32_t rt_ext_AtalkHFd(void);                                   /* -1 when the stack is down; rt_ext_ConnHIdle adds it to its select set */
```

- Wire formats (Inside AppleTalk 2nd ed.; Task 1's recorded frames are the oracle): LToUDP datagram = 4-byte sender id + LLAP frame `dst node, src node, LLAP type, payload`; LLAP types 1 (short DDP), 2 (long DDP), $81 `lapENQ`, $82 `lapACK`. Short DDP header (5 bytes): `[hop/len hi][len lo][dst socket][src socket][DDP type]`, length = header + data, data ≤ 586. DDP types: 2 NBP, 3 ATP, 6 ZIP, 7 ADSP. NBP header: `[func<<4 | tuple count][NBP id]` then tuples `AddrBlock(4) enumerator(1) obj type zone` (packed Pascal); functions 1 BrRq, 2 LkUp, 3 LkUp-Reply, 4 FwdReq; lookups go to node 255 socket 2 (NIS). ATP header (8 bytes): `[control: func<<6 | XO 0x20 | EOM 0x10 | STS 0x08][bitmap/seq][TID hi][TID lo][userbytes ×4]`, func 1 TReq, 2 TResp, 3 TRel; response packets carry ≤ 578 data bytes, ≤ 8 per transaction; the requester's TReq bitmap has bit *n* set for each response packet still wanted; the responder sets EOM on its last packet.

- [ ] **Step 1: Write the failing unit test**

`runtime/host/rt_atalk_test.c`, `rt_serial_test.c`'s CHECK style, printing `OK` at the end. Two instances `a`/`b` from `rt_at_open(NULL)` (skips with `OK` after printing `SKIP: multicast unavailable` if both opens fail with `errno` `ENODEV`/`EADDRNOTAVAIL` — a sandbox without multicast must not fail the gate). Cases:
1. `rt_at_node(a) != rt_at_node(b)`, both in 1..127.
2. Forced collision: a private test hook `rt_at_test_force_node(b, rt_at_node(a))` re-acquires and ends on a different id (so `lapENQ`/`lapACK` work).
3. NBP: register `("Unit-<pid>", "ClarusTest", sock 200)` on `a`; lookup `("=", "ClarusTest", "*")` from `b` → at least one tuple whose obj matches; duplicate register on `b` → `-1027`; remove → later lookup finds none with that obj.
4. ATP: `sock = rt_at_atp_open(a)`; from `b`, `rt_at_atp_call(a's addr/sock, userbytes 7, "ping", 4, ...)` in a thread-free way: the test drives `a` by calling `rt_at_poll(a)` + `rt_at_atp_get_request` from a callback hook `rt_at_test_idle_hook(fn)` that `rt_at_atp_call`'s internal wait loop invokes each iteration; the hook answers with `userbytes 9` and a 4000-byte response (≥ 7 packets). Assert `resplen == 4000`, bytes are `i & 0xFF`, `resp_userbytes == 9`.
5. Dropped packet: `rt_at_test_drop_next_tx(a, 3)` (drop the 4th outgoing datagram once) → the call still succeeds (bitmap retransmit).
6. XO duplicate replay: `rt_at_test_drop_next_rx(a, RT_AT_DROP_TREL)` makes `a` ignore the next TRel it receives, so the completed transaction stays in `a`'s XO list; then `rt_at_test_resend_last_treq(b)` re-injects `b`'s last TReq verbatim, and `a` must answer it from the list — the test's idle hook counts `rt_at_atp_get_request` successes and asserts the count is still 1 while `b` received a full second response.
7. Oversize: `reqlen 579` → `-3106`; `rt_at_atp_send_response` with `len 4625` → `-3106`.
8. Idle wake: `select` on `rt_at_fd(a)` with a 2 s timeout returns > 0 within 100 ms after `b` sends a lookup.

Run: `cc -std=c99 -Wall -Werror -I runtime/host runtime/host/rt_atalk_test.c runtime/host/rt.c -o /tmp/atalktest && /tmp/atalktest`. Expected: compile failure (no `rt_at_*` yet).

- [ ] **Step 2: Implement `rt_atalk.inc`**

Sections, in this order, each with a header comment: (a) constants and the instance struct (fd, sender id, node, per-`lk` lookup slots ×10 with tuple arrays of 32, names table ×4, ATP sockets ×4 each with a request queue of 4 `rt_at_req`, an XO transactions list of 8 `{tid, from, response copy, expiry}`, and a requester state); (b) LToUDP I/O: `rt_at_tx(a, dst, type, payload, len)` prepends sender id + LLAP header, `sendto` the group; `rt_at_rx` drops own sender id, frames not for our node or broadcast (255); (c) LLAP node acquisition: random id 1–127, send `lapENQ` 3× at 20 ms apart, on any `lapACK` pick another id, at most 20 tries → `EADDRINUSE`; answer `lapENQ` for our id with `lapACK` forever after; (d) DDP short header encode/decode, dynamic socket allocation 128–254; (e) NBP: local names table answers `LkUp` (function 2) whose obj/type/zone match (case-insensitive, `=` full wildcard, `*` zone) with a `LkUp-Reply` (function 3) to the requester's socket; `lookup_start` broadcasts `LkUp` to 255/2 three times 1 s apart, replies accumulate de-duplicated by (addr, enumerator), `lookup_done` after 3 s; `register` does a verify lookup first and refuses on a match; (f) ATP requester: TID counter, TReq with XO, bitmap = (1<<n)-1 for n=8, resend every `timeout_s` with the bitmap of missing packets, up to `retries`; assemble by sequence number; on completion send TRel; (g) ATP responder: TReq → if TID in XO list, replay stored packets; else enqueue for `get_request` (drop with STS unused if the queue is full); `send_response` splits into ≤ 8 packets of ≤ 578, EOM on the last, stores a copy in the XO list with a 30 s expiry; TRel removes; `rt_at_poll` expires; (h) the `rt_ext_AtalkH*` layer over a static `rt_at_global` instance with `CLARUS_ATALK_IFACE`, plus `rt_ext_AtalkHFd`. Test hooks under `#ifdef RT_ATALK_TEST_HOOKS` (the test defines it before including `rt.h`? — no: `rt.c` is compiled separately; expose the hooks unconditionally but prefixed `rt_at_test_`, documented as test-only).

- [ ] **Step 3: Run the unit test to green; add `tests/hostrt/atalk.sh`**

```sh
#!/bin/sh
# hostrt/atalk -- compile rt_atalk_test.c against rt.c (which #includes
# rt_atalk.inc) and run it: two LToUDP stack instances on loopback
# multicast. Prints OK (or SKIP: multicast unavailable, still OK).
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_atalk_test.c || die "rt_atalk_test"
```
Run: `make test T=hostrt/atalk`. Expected: `PASS hostrt/atalk`.

- [ ] **Step 4: `atalkdrive`**

`tests/tools/atalkdrive.c`: `#include "../../runtime/host/rt_atalk.inc"` is not possible (it depends on `rt.h`); instead compile it as `$(CC) -std=c99 -Wall -Werror -I runtime/host -o $@ $< runtime/host/rt.c` — add a Makefile rule specialization for this one tool (`$(BR)/tools/atalkdrive: tests/tools/atalkdrive.c runtime/host/rt.c $(RT_HOST)`) above the generic `$(BR)/tools/%` rule. CLI:

```
atalkdrive lookup TYPE [ZONE]            -> one line per tuple: "net.node.socket obj:type@zone"; exit 0
atalkdrive register OBJ TYPE SECS        -> registers on a fresh ATP socket, prints "registered node=N sock=S", idles SECS, removes
atalkdrive call OBJ TYPE OP [--timeout S] [--retries N]   -> request = stdin, reply -> stdout, "code N" -> stderr; exit 0 ok, 3 on code!=0 (still prints reply), 1 on reqFailed
atalkdrive serve OBJ TYPE SECS SCRIPT    -> registers + serves for SECS; SCRIPT lines "OP CODE REPLYFILE" map an op to a reply (unknown op -> code -1 empty); logs "request op=N len=L from=A" per request to stderr
```
`tests/atalkdrive/lookup.sh`: `register` in the background for 8 s, `lookup` finds the name (skip on multicast unavailable: `atalkdrive` exits 77 with `SKIP: ...` when `rt_at_open` fails; the script propagates with `skip`). `tests/atalkdrive/call.sh`: `serve` with a script mapping op 1 → code 0 `reply.bin` (a 0–255 sweep ×16 = 4096 bytes) and op 2 → code 5 empty; `call ... 1` returns the sweep byte-exact; `call ... 2` exits 3 with `code 5`; `call` to a bogus name exits 1 within 8 s. Run: `make -j tools && make test T=atalkdrive/`. Expected: both PASS.

- [ ] **Step 5: T1 + commit**

Run: `scripts/test-task.sh --smoke` (touches `runtime/`). Expected: PASS, zero golden churn.
```bash
git add runtime/host/rt_atalk.inc runtime/host/rt_atalk_test.c runtime/host/rt.c tests/tools/atalkdrive.c Makefile tests/hostrt/atalk.sh tests/atalkdrive/
git commit -m "feat(host): LocalTalk-over-UDP stack (LLAP/DDP/NBP/ATP) with unit test and atalkdrive tool"
```

---

### Task 3: Front end — `service` type, browser/listener additions, `string(addr)`, reference text

Checker/parser only; lowering stays fenced (every new shape still aborts with the existing `lowUnsupported` text). Zero golden churn.

**Files:**
- Modify: `clarusc/types.cla:38-53` (add `TyService` after `TyServiceBrowser`), `clarusc/check.cla` (§ refs below), `clarusc/lower.cla:371-441` (`lowTypeAt` only), `docs/clarus-language-reference.md` (Connections, Listeners, Service Discovery, new Services section, Chapter 3 conversions + type table rows), `tests/reftest/manifest.txt`.
- Read first: `clarusc/check.cla:36-54, 475-486, 566-568, 785-799, 1041-1042, 1101-1112, 1337-1339, 1656-1678, 2245-2267, 2350, 4309-4356, 5844-5900`; `tests/lib_reftest.sh`, `tests/reftest/manifest.txt` header.

**Interfaces:**
- Produces (checker): `TyService`; `serviceT: int` singleton (allocated in `checkReset` beside `connectionT`); `serviceMethods` table: `serve(string, string)`, `reply(psOneOf2(TyText, TyStr))` with a leading `int`, `stop()`, `call(psOneOf2(TyStr, TyAddress), int, text, text): bool`; events `service.request(op: int, req: text, from: address)`, `service.failed(err: error)`; `listenerMethods["stop"]`; `serviceBrowserMethods["find"]` accepting 1 or 2 string args — `checkTableMethod` has no overloads, so register the 2-arg form under the key `"find/2"` and make `checkTableMethod` look up `sel + "/" + argc` before `sel` (a 3-line change that every future overload reuses); `serviceBrowserMethods["zones"](list of string)`; event `serviceBrowser.done` (0 params); `usesAtalk: bool` set in `resolveType` for `listener`/`serviceBrowser`/`service`/`address` names and in `checkCall` for transport tag 1; `isResourceKind` includes `TyService`; `checkConversion`'s `name == "string"` arm additionally accepts `TyAddress` (message becomes `an int, char, or address`).
- Produces (lowering, `lowTypeAt`): `case TyAddress { return irIntT }`, `case TyListener`, `case TyServiceBrowser`, `case TyService` → `irIntT` (1-based handle ints, `nil` = 0, exactly `TyConnection`'s convention).
- Produces (reference): the normative text for spec §4.1–4.5 and §4.7's serial values are NOT here (Task 4); the host lifetime paragraph is NOT here (Task 5).

- [ ] **Step 1: Write failing checker fixtures**

In `testdata/errors/` (`.cla` + `.expect`, the group's existing pairs show the expected-text format) and `testdata/valid/`: `atalk_ok.cla` in `testdata/valid/` (a full server + client + browser + listener program using every new method/event, check-clean), and in `testdata/errors/`: `svc_reply_type.cla` (`svc.reply("x", 1)` → `argument 1: expected int`-style diagnostic, whatever the table diagnostic already says for `connection.send`), `brs_find3.cla` (`b.find("a","b","c")` → arity diagnostic), `addr_string.cla` (`string(addr)` check-clean; `string(l)` on a listener → `string() expects an int, char, or address, got listener`). Run: expected FAIL (unknown type `service`).

- [ ] **Step 2: Implement types/check/lowTypeAt**

Follow the excerpts: enum member; `var serviceT: int` + `checkReset` allocation; `var serviceMethods: map of int` + registration block after `serviceBrowserMethods["find"]`; `addEvent("service.request", ...)` with params `op: IntT`, `req: TextT`, `from: AddressT` (build the chain with `newEventParam` last-to-first like `serviceBrowser.found`), `addEvent("service.failed", ...)`, `addEvent("serviceBrowser.done", -1, 0)`; the `checkTopHandlerDecl` ladder gains `else if k == TyService { ctx = "service" }`; method dispatch gains `checkTableMethod(serviceMethods, sel, argsHead)`; `resolveType`'s `TxNamed` arm sets `usesAtalk` for the four names (`address` too — `string(addr)` needs the runtime); `checkCall` sets `usesAtalk = true` when `transport == 1`; `isResourceKind` adds `TyService`; `checkConversion` string arm; `lowTypeAt` cases.

- [ ] **Step 3: Reference text**

Rewrite Chapter 12's Connections (add the `appletalk`/`address` open forms and ADSP event semantics from spec §4.1, the 8-slot cap), Listeners (`register` semantics, `stop`, deny-when-full, `listen(port)` still MacTCP), Service Discovery (`find(type[, zone])`, `found` then `done`, `zones(out)`, `find("=")`, `string(addr)`), and add a **Services** section after Service Discovery with spec §4.4 verbatim in reference voice, including the enum-guard example. Chapter 3: `service` in the resource rows and the `nil` row; `address` stays "opaque, inline" with the `AddrBlock` layout note; conversions gain `string(addr)`. Every new ```rust fence must check clean standalone; add each new fence's index to `tests/reftest/manifest.txt` (indices shift — re-derive with `tests/lib_reftest.sh`'s `fences` helper and fix every shifted entry; `tests/reftest/required.sh` locates programs by content so it is unaffected).

- [ ] **Step 4: Gate + commit**

Run: `make test T=reftest/ T=lowlevel/ T=selfhost/diag` then `scripts/test-task.sh --smoke`. Expected: PASS, zero golden churn (no emission path changed).
```bash
git add clarusc/types.cla clarusc/check.cla clarusc/lower.cla docs/clarus-language-reference.md tests/reftest/manifest.txt testdata/ tests/
git commit -m "feat(check): service resource type, browser zones/done/find(type, zone), listener.stop, string(addr); reference text"
```

---

### Task 4: Host serial `stdio` and `pty` transports

Spec §4.7, §6.3; the recorded TODO item, verbatim scope.

**Files:**
- Modify: `runtime/host/rt_serial.inc` (`rt_ext_ConnHOpen` parser, `ReadByte`/`Write`/`Gone`, slot struct), `runtime/host/rt_serial_test.c`, `docs/clarus-language-reference.md` (Serial section, the env-var paragraph only).
- Create: `tests/conntest/stdio.sh`, `tests/conntest/pty.sh`.
- Read first: `rt_serial.inc` whole (above), `tests/conntest/connect.sh`, `tests/lib_conntest.sh`, `tests/conntest/testdata/echo.cla`.

**Interfaces:**
- Consumes: the existing `rt_ext_ConnH*` signatures (unchanged).
- Produces: `CLARUS_SERIAL_MODEM=stdio` / `=pty`; slot struct gains `int kind` (0 socket, 1 stdio, 2 pty) and `int gone`; `rt_ext_ConnHWrite` writes with `write()` for kinds 1–2; `ReadByte` uses `read()`; `Gone` returns the `gone` flag for kinds 1–2 (set when `read()` returns 0); for `pty`, the slave path is printed to stderr as `pty /dev/ttysNNN` on open; for `stdio`, raw mode via `tcsetattr` when `isatty(0)`, restored by an `atexit` handler.

- [ ] **Step 1: Failing C test cases** — in `rt_serial_test.c`: (a) `stdio` over a `pipe()` pair: dup2 the read end onto fd 0 and a second pipe's write end onto fd 1 (save/restore the originals), `setenv("CLARUS_SERIAL_MODEM","stdio",1)`, `ConnHOpen(0, 0) == 0`, write 300 bytes into the input pipe → `ConnHAvail` reports 300, `ReadByte` returns them in order, `ConnHWrite` of a 0–255 sweep appears on the output pipe byte-exact, closing the input pipe's write end → `ConnHGone(0) == 1` after one `ReadByte` attempt returns... (specify: `Gone` becomes 1 once `Avail` is 0 AND a non-blocking `read` returned 0); (b) `pty`: `setenv(...,"pty")`, `ConnHOpen` succeeds, the slave path was printed (capture stderr via a pipe dup'd onto fd 2 around the call, parse `pty /dev/...`), open the slave `O_RDWR|O_NOCTTY`, write bytes each way, verify. Run the test: expected FAIL (`stdio` unparsed → open returns 1).
- [ ] **Step 2: Implement** per Interfaces; keep the socket path byte-identical in behavior.
- [ ] **Step 3: Conntest scripts** — `stdio.sh`: build `echo.cla` (`conn_build echo`), run it with `CLARUS_SERIAL_MODEM=stdio` with stdin from a FIFO and stdout to a file; feed `READY`-wait then the 0–255 sweep and `QQQ`; assert the output file ends with the echoed sweep and the program exited by itself (`conn_wait_self_exit`). `pty.sh`: run with `=pty`, parse `pty /dev/ttys…` from stderr, drive it with `$TOOLS/tcpdrive`? — no TCP; use a 20-line python3 (`os.open` the slave, write, read with a deadline) and assert the echo; skip (`skip`) if python3 is absent.
- [ ] **Step 4: Reference** — in the Serial section's env-var paragraph add `stdio` and `pty` with their two sentences each (spec §4.7).
- [ ] **Step 5: Gate + commit** — `make test T=hostrt/serial T=conntest/`, then `scripts/test-task.sh --smoke`.
```bash
git add runtime/host/rt_serial.inc runtime/host/rt_serial_test.c tests/conntest/stdio.sh tests/conntest/pty.sh docs/clarus-language-reference.md
git commit -m "feat(host): stdio and pty serial transports"
```

---

### Task 5: `every` timers in the host CLI pump

Spec §6.4 as amended: no runtime module move. A non-UI host program with `every` blocks gets a lowering-synthesized `clar_every_pump()` and a C due-check helper; `ui.cla` and the native lane are untouched.

**Files:**
- Modify: `clarusc/cprint.cla:7341-7343` (`irIsUiProgram` drops `irEveryCount`), `clarusc/cprint.cla:7678-7734` (`cpEmitMain` loop), `clarusc/lower.cla` (new `lowSynthEveryPump()` beside `lowSynthConnPump`, called from the same site as `lowSynthConnDispatchers` under `not want68k and irEveryCount > 0`), `runtime/host/rt_ext_host.inc` (`rt_ext_EveryDue`), `docs/clarus-language-reference.md` (the host-lane lifetime sentence in the Serial section), `clarusc/check.cla` ONLY if the checker rejects `every` without a window (verify first with the fixture; Task 3 owns check.cla otherwise — coordinate through the controller if a one-line lift is needed).
- Create: `testdata/emitui/every_cli.cla` + `.c.golden`, `tests/conntest/every.sh`.

**Interfaces:**
- Produces: `int32_t rt_ext_EveryDue(int32_t idx, int32_t periodTicks)` — static `due[16]` array in ticks (`rt_ext_TickCount()` units, 60/s); first call for an idx arms `now + period` and returns 0; later calls return 1 and re-arm when `now - due >= 0`. Synthesized IR function `clar_every_pump` (no params): for each `irEvery` entry *i* in order, `if EveryDue(i, ticks_i) { <entry fn>() }` — built with `newIRCallExt`-style nodes the way `lowSynthConnFireSimple` builds calls, the extern registered via `irRegisterExtern` as clause-less `EveryDue` (cprint renders `rt_ext_EveryDue`). `cpEmitMain`'s loop becomes: emitted when `irUsesConn or irEveryCount > 0` (Task 8 adds `irUsesAtalk`); condition = OR of `clar_fn_rtConnAlive()` (if `irUsesConn`) and `1` (if `irEveryCount > 0`), ANDed with `!clar_aborting` when `lowUsesAbort`; body calls `clar_fn_rtConnPump()` (if used), `clar_fn_clar_every_pump()` (if any `every`), then `rt_ext_ConnHIdle(20)` (usable even with no connection: it `usleep`s).

- [ ] **Step 1: Failing fixture** — `testdata/emitui/every_cli.cla`:
```rust
var n: int = 0
on App.startCLI(args: list of string) { log("start") }
every 6 ticks {
    n = n + 1
    log("tick " + string(n))
    if n == 3 { quit 0 }
}
```
Run `build-run/clarusc-current emit --rtdir runtime/clarus/ -o /tmp/e.c testdata/emitui/every_cli.cla`; expected today: it takes the UI main path (`#include "rt_ui.h"`) or the checker rejects it — record which.
- [ ] **Step 2: Implement** per Interfaces. If the checker rejected `every` without a window in Step 1, lift that one check (the reference's own text says `every` is a top-level declaration, not a window property).
- [ ] **Step 3: Golden + end-to-end** — bless `every_cli.c.golden` by copying the reviewed emission (emitui goldens are compare-only; the task report quotes the emitted main loop). `tests/conntest/every.sh`: `host_build` the fixture, run it with a 10 s `$TOOLS/timeout`, assert stdout has exactly `start`, `tick 1`, `tick 2`, `tick 3` and exit 0 in under 2 s (6 ticks = 100 ms period). Also assert the existing `every.cla` (has a window) golden is unchanged.
- [ ] **Step 4: Reference** — the lifetime sentence: "…while any connection remains open, an event is pending, **or an `every` timer is declared** (a timer never disarms, so such a program runs until `quit`)".
- [ ] **Step 5: Gate + commit** — `make test T=emitui/ T=conntest/every`, then `scripts/test-task.sh --smoke`. Expected: zero cg68k churn (native path untouched).
```bash
git add clarusc/cprint.cla clarusc/lower.cla runtime/host/rt_ext_host.inc testdata/emitui/every_cli.cla testdata/emitui/every_cli.c.golden tests/conntest/every.sh docs/clarus-language-reference.md
git commit -m "feat(host): every timers fire from the host CLI pump loop"
```

---

### Task 6: Toolbox catalog `toolbox/appletalk.cla` + `AtalkSelf` suite case

Spec §5.1. After Task 1 (P3 decides the case's shape).

**Files:**
- Create: `toolbox/appletalk.cla`, `testsuite/toolbox/cases_atalk.cla`.
- Modify: `testsuite/toolbox/runner.cla` (enum member `AtalkSelf` after `SerialOpenWrite`; `nTbCases` 38 → 39; `tbCaseName` arm; `tbAllCases` add; dispatch block), `tests/mactest/toolbox_68k.sh:19` (`38` → `39`), `tests/mactest/toolbox_jiggle.sh`, `tests/mactest/toolbox_mac.sh` (same literal + doc comments), `tests/mactest/toolbox_files.txt` (add `toolbox/appletalk.cla` after `toolbox/serial.cla`, and `testsuite/toolbox/cases_atalk.cla` among the cases), `tests/testsuite/catalog.sh:135-146` (add `"$ROOT/toolbox/appletalk.cla"`), `CLAUDE.md:210` (count sentence: 39 = 38 real + SelfCheck, naming the AppleTalk phase's `AtalkSelf`).
- Read first: `toolbox/devices.cla` (whole), `toolbox/files.cla:11-57`, `testsuite/toolbox/cases_serial.cla` (whole), `runner.cla:149-196, 292-294, 356, 518-521`, Task 1's report.

**Interfaces:**
- Produces (`toolbox/appletalk.cla`), every item with a provenance comment citing `CIncludes/AppleTalk.h`/`ADSP.h` line numbers (CR-reflowed) and the Inside Macintosh volume/page:
  - `external func PBControlAsync(paramBlock: ptr): int = trap 0xA404 reg` (the async `_Control`, bit 10 set) — the one new trap form; `PBControlSync`/`PBOpenSync`/`PBStatusSync` come from `toolbox/devices.cla` (compose both files).
  - Driver-name doc constants: `.MPP` (refnum −10), `.ATP`, `.XPP` (−41), `.DSP`.
  - `const int` csCodes: `writeDDP 246, closeSkt 247, openSkt 248, confirmName 250, lookupName 251, removeName 252, registerName 253, killNBP 254, setSelfSend 256`; ATP `nSendRequest 248, relRspCB 249, closeATPSkt 250, addResponse 251, sendResponse 252, getRequest 253, openATPSkt 254, sendRequest 255, relTCB 256, killGetReq 257, killSendReq 258, killAllGetReq 259`; `xCall 246`, `zipGetLocalZones 5, zipGetZoneList 6, zipGetMyZone 7`; ADSP `dspInit 255, dspRemove 254, dspOpen 253, dspClose 252, dspCLInit 251, dspCLRemove 250, dspCLListen 249, dspCLDeny 248, dspStatus 247, dspRead 246, dspWrite 245, dspAttention 244, dspOptions 243, dspReset 242, dspNewCID 241`.
  - Flags/modes: `atpXOvalue 32, atpEOMvalue 16, atpSTSvalue 8, atpTIDValidvalue 2, atpSendChkvalue 1, atpMaxData 578, atpMaxNum 8, bdsEntrySz 12`; `ocRequest 1, ocPassive 2, ocAccept 3, ocEstablish 4`; `sListening 1 … sClosed 6`; `eClosed 0x80, eTearDown 0x40, eAttention 0x20, eFwdReset 0x10`; `attnBufSize 570, minDSPQueueSize 100, ccbSize 242`.
  - Error codes: `ddpSktErr -91, noBridgeErr -93, portInUse -97, portNotCf -98, nbpBuffOvr -1024, nbpNoConfirm -1025, nbpConfDiff -1026, nbpDuplicate -1027, nbpNotFound -1028, nbpNISErr -1029, reqFailed -1096, tooManyReqs -1097, badATPSkt -1099, badBuffNum -1100, cbNotFound -1102, noDataArea -1104, reqAborted -1105, errRefNum -1280, errAborted -1279, errState -1278, errOpening -1277, errAttention -1276, errFwdReset -1275, errDSPQueueSize -1274, errOpenDenied -1273, atpLenErr -3106, atpBadRsp -3107, sktClosedErr -3109`.
  - Extern records (sync use; the runtime allocates its ASYNC blocks with `NewPtrClear` and uses the offset constants below): `NBPParam` (44 bytes: header to `csCode`@26, `interval`@28 byte, `count`@29 byte, `entityPtr`@30 ptr, then a 10-byte `pad` — the Lookup/Confirm variant fields are reached by offset constants), `ATPParam` (56 bytes: to `csCode`@26, `atpSocket`@28 byte, `atpFlags`@29 byte, `addrNet`@30 word, `addrNode`@32 byte, `addrSocket`@33 byte, `reqLength`@34 word, `reqPointer`@36 ptr, `bdsPointer`@40 ptr, `numOfBuffs`@44 byte, `timeOutVal`@45 byte, `numOfResps`@46 byte, `retryCount`@47 byte, `intBuff`@48 word, `TRelTime`@50 byte, pad to 56), `XCallParam` (112 bytes: `cmdResult`@18, `ioRefNum`@24, `csCode`@26, `xppSubCode`@28 word, `xppTimeout`@30 byte, `xppRetry`@31 byte, `filler1`@32 word, `zipBuffPtr`@34 ptr, `zipNumZones`@38 word, `zipLastFlag`@40 byte, `filler2`@41 byte, `zipInfoField` 70 bytes @42), `DSPParam` (68 bytes: `ioCRefNum`@24, `csCode`@26, `qStatus`@28 int, `ccbRefNum`@32 word, variant @34 as a 34-byte pad), `BDSElement` (12: `buffSize`@0 word, `buffPtr`@2 ptr, `dataSize`@6 word, `userBytes`@8 int).
  - Offset `const int`s for the async/variant fields: `nbpLookupRetBuffPtr 34, nbpLookupRetBuffSize 38, nbpLookupMaxToGet 40, nbpLookupNumGotten 42, nbpConfirmAddr 34, nbpConfirmNewSocket 38, nbpVerifyFlag 34, nbpNtQElPtr 30, nbpSetSelfNewFlag 28`; `atpUserData 18, atpReqTID 22, atpBitMap 44, atpTransID 46, atpBdsSize 45, atpRspNum 44`; `pbIoResult 16, pbIoRefNum 24, pbCsCode 26`; DSP `dspIoCRefNum 24, dspCcbRefNum 32, dspInitCcbPtr 34, dspInitUserRoutine 38, dspInitSendQSize 42, dspInitSendQueue 44, dspInitRecvQSize 48, dspInitRecvQueue 50, dspInitAttnPtr 54, dspInitLocalSocket 58, dspOpenLocalCID 34, dspOpenRemoteCID 36, dspOpenRemoteAddress 38, dspOpenFilterAddress 42, dspOpenSendSeq 46, dspOpenSendWindow 50, dspOpenRecvSeq 52, dspOpenAttnSendSeq 56, dspOpenAttnRecvSeq 60, dspOpenOcMode 64, dspOpenOcInterval 65, dspOpenOcMaximum 66, dspCloseAbort 34, dspIoReqCount 34, dspIoActCount 36, dspIoDataPtr 38, dspIoEom 42, dspIoFlush 43, dspStatusCcb 34, dspStatusSendQPending 38, dspStatusSendQFree 40, dspStatusRecvQPending 42, dspStatusRecvQFree 44`; CCB `ccbState 6, ccbUserFlags 8, ccbLocalSocket 9, ccbRemoteAddress 10, ccbAttnCode 14, ccbAttnSize 16, ccbAttnPtr 18`; NTE `nteQNext 0, nteAddress 4, nteEntity 9, nteSize 108`; tuple `tupleAddr 0, tupleEnum 4, tupleEntity 5`.
- Consumed by: `atalk_68k.cla` (Task 9), the suite case below.

- [ ] **Step 1: Write the catalog** with the provenance convention (header block like `devices.cla:1-66`; per-declaration comments citing the header lines found with `LC_ALL=C tr '\r' '\n' < toolchain/universal/CIncludes/AppleTalk.h | /usr/bin/grep -na NAME`).
- [ ] **Step 2: Check-compile** — add the file to `tests/testsuite/catalog.sh`'s list; `make test T=testsuite/catalog`. Expected PASS.
- [ ] **Step 3: `AtalkSelf` case** — `caseAtalkSelf()` in `cases_atalk.cla` (include idiom copied from `cases_serial.cla`): open `.MPP` via `PBOpenSync`; register `"AtalkSelf-" + <tick suffix>` / `"ClarusSuite"` / `"*"` with `registerName` (sync, verify on) → `tkFail` unless 0; `lookupName` for `=:ClarusSuite@*` (sync) → per Task 1's P3: if the ROM answers its own lookup (with or without `setSelfSend`, do what P3 said), assert `numGotten >= 1` and that one tuple's object equals the registered name; otherwise assert the call itself returns 0 with `numGotten == 0`; if P3 proved the async-getRequest + sync-sendRequest self-transaction works, do one (op 42 → reply "pong") and assert the reply; `removeName`; return `tkPass`. Register in `runner.cla` (five touch points), bump the three script literals and `CLAUDE.md`.
- [ ] **Step 4: Hardware-prove** — `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k`. Expected: `PASS AtalkSelf`, `TOTAL 39 PASS 39 FAIL 0`.
- [ ] **Step 5: Gate + commit** — `scripts/test-task.sh` (no `--smoke` needed unless runtime/clarusc changed).
```bash
git add toolbox/appletalk.cla testsuite/toolbox/ tests/mactest/toolbox_68k.sh tests/mactest/toolbox_jiggle.sh tests/mactest/toolbox_mac.sh tests/mactest/toolbox_files.txt tests/testsuite/catalog.sh CLAUDE.md
git commit -m "feat(toolbox): AppleTalk catalog (.MPP/.ATP/.XPP/.DSP), hardware-proved by AtalkSelf"
```

---

### Task 7: Runtime `atalk.cla` + `atalk_c.cla` (host, complete) + `atalk_68k.cla` (stubs), host splice

Spec §5.2–5.7 lane-neutral logic, §6 host twin. Dormant: nothing lowers to it yet (Task 8). Host-lane spliced under `usesConn or usesAtalk`; NOT on the 68k lane (Task 9). Zero native churn.

**Files:**
- Create: `runtime/clarus/atalk.cla`, `runtime/clarus/atalk_c.cla`, `runtime/clarus/atalk_68k.cla`.
- Modify: `clarusc/drive.cla:1628-1654` (host splice) and `2138-2140` (rtbake fallback).
- Create: `tests/atalk/splice.sh`.
- Read first: `runtime/clarus/conn.cla`, `conn_c.cla` (whole), `runtime/clarus/text.cla:534-558` (`rtTextFromBytes`), `core.cla:59-71` (`rtSetLastErr`), `fileh.cla:318` (`list of string` out-param precedent), Task 2's `rt_ext_AtalkH*` block.

**Interfaces:**
- Produces (`atalk.cla`, lane-neutral; `h` is the 1-based handle, `slot = h - 1`, `h == 0` → `rtPanic("use of nil <kind>")`):

```
const rtLsnMax: int = 2      const rtBrsMax: int = 2      const rtSvcMax: int = 2
const rtAtLookupMax: int = 11   // lookup slots: 0-1 browsers, 2-9 connection opens (conn slot + 2), 10 name-calls (rtAtNameCallLk; Task 7 review ruling — the host stack's RT_AT_NLK is 11)
const rtAtErrNoHost: int = -1273   // errOpenDenied reused: "streams not available on this lane"
// globals (parallel fixed arrays; the COMPLETE table, never grown later):
var rtAtUp: bool
var rtLsnState: int[2]; var rtLsnPendFailedCode: int[2]; var rtLsnPendFailedMsg: string[2]
var rtBrsState: int[2]; var rtBrsPendFailedCode: int[2]; var rtBrsPendFailedMsg: string[2]; var rtBrsPendDone: bool[2]
var rtSvcState: int[2]; var rtSvcSock: int[2]; var rtSvcInHandler: bool[2]; var rtSvcReplied: bool[2]
var rtSvcPendFailedCode: int[2]; var rtSvcPendFailedMsg: string[2]
var rtAdspPhase: int[8]     // 0 none, 1 lookup pending, 2 open pending, 3 open  (conn slots)
var rtConnSlotTransport: int[8]   // 0 serial (or unused), 1 ADSP -- read by conn.cla from Task 9 on
var rtAtLastErr: int
// dispatchers (bare externs, synthesized by Task 8):
external func clar_lsn_fire_accepted(slot: int, c: int)
external func clar_lsn_fire_failed(slot: int, code: int, msg: string)
external func clar_brs_fire_found(slot: int, name: string, addr: int)
external func clar_brs_fire_done(slot: int)
external func clar_brs_fire_failed(slot: int, code: int, msg: string)
external func clar_svc_fire_request(slot: int, op: int, req: text, from: int)
external func clar_svc_fire_failed(slot: int, code: int, msg: string)
// API called by lowering:
func rtLsnRegister(h: int, name: string, typ: string)
func rtLsnStop(h: int)
func rtBrsFind(h: int, typ: string, zone: string)          // lowering passes "*" for the 1-arg form
func rtBrsZones(h: int, out: list of string)
func rtSvcServe(h: int, name: string, typ: string)
func rtSvcReply(h: int, code: int, data: text)
func rtSvcReplyStr(h: int, code: int, s: string)
func rtSvcStop(h: int)
func rtSvcCallAddr(h: int, addr: int, op: int, req: text, reply: text): bool
func rtSvcCallName(h: int, name: string, op: int, req: text, reply: text): bool   // "Name:Type" -> sync lookup first
func rtAtalkAddrStr(addr: int): string            // "net.node.socket"
func rtAtalkPump()
func rtAtalkAlive(): bool                          // any service open, browser searching, listener registered, or event pending
// ADSP waist used by conn.cla (Task 9): 
func rtAdspOpenName(slot: int, spec: string): int  // starts lookup on lookup slot slot+2; 0 ok
func rtAdspOpenAddr(slot: int, addr: int): int
func rtAdspPoll(slot: int): int                    // 1 became open, 0 pending, <0 failed (error code)
func rtAdspAvail(slot: int): int;  func rtAdspReadInto(slot: int, t: text): int   // reads min(avail, 1024) bytes into the scratch buffer with ONE rtAdspDevRead, then appends them to t (t.append(char(peekb(scratch + i))) -- one Toolbox call per chunk instead of conn.cla's one per byte; rtTextFromBytes takes a raw ptr and is not reachable from a text value, so the per-byte append stays)
func rtConnOpenAddr(h: int, addr: int)             // connection.open(addr): sets rtConnSlotTransport[slot] = 1, rtAdspOpenAddr; the pump fires opened/failed
func rtAdspWrite(slot: int, p: ptr, n: int): int;  func rtAdspClose(slot: int);  func rtAdspGone(slot: int): bool
```
Per-lane waist (`atalk_c.cla` real over `AtalkH*`; `atalk_68k.cla` stubs this task, real in Task 9 — same names):
```
func rtAtDevUp(): int
func rtAtDevRegister(obj: string, typ: string, sock: int): int
func rtAtDevRemove(obj: string, typ: string): int
func rtAtDevLookupStart(lk: int, obj: string, typ: string, zone: string): int
func rtAtDevLookupDone(lk: int): bool
func rtAtDevLookupCount(lk: int): int
func rtAtDevLookupAddr(lk: int, i: int): int
func rtAtDevLookupName(lk: int, i: int): string      // "obj:type"
func rtAtDevZones(out: list of string): int          // 0, or an OSErr (noBridgeErr on the host, always); atalk.cla substitutes ["*"] on any error
func rtAtDevAtpOpen(): int                           // socket > 0, or 0 with rtAtDevLastErr()
func rtAtDevAtpClose(sock: int)
func rtAtDevAtpArm(slot: int, sock: int): int        // (re)issue the async get-request for service slot
func rtAtDevAtpPoll(slot: int): int                  // 1 request ready, 0 pending, <0 error
func rtAtDevAtpReqOp(slot: int): int;  func rtAtDevAtpReqFrom(slot: int): int
func rtAtDevAtpReqLen(slot: int): int; func rtAtDevAtpReqPtr(slot: int): ptr
func rtAtDevAtpRespond(slot: int, code: int, p: ptr, n: int): int   // copies p[0..n) into the slot reply buffer, sends (async natively)
func rtAtDevAtpRespBusy(slot: int): bool
func rtAtDevAtpCall(addr: int, op: int, req: ptr, reqLen: int): int   // sync; resp len >= 0 or negative OSErr
func rtAtDevAtpCallCode(): int;  func rtAtDevAtpCallPtr(): ptr
func rtAtDevLastErr(): int
func rtAtDevPoll()                                    // host: AtalkHPoll(); native: no-op
// ADSP + listener dev layer (host twin: every function returns rtAtErrNoHost / false / 0):
func rtAdspDevOpen(slot: int, addr: int): int;  func rtAdspDevOpenPoll(slot: int): int
func rtAdspDevAvail(slot: int): int;  func rtAdspDevRead(slot: int, p: ptr, n: int): int
func rtAdspDevWrite(slot: int, p: ptr, n: int): int;  func rtAdspDevClose(slot: int);  func rtAdspDevGone(slot: int): bool
func rtLsnDevInit(slot: int): int;  func rtLsnDevListen(slot: int): int;  func rtLsnDevPoll(slot: int): int
func rtLsnDevAccept(slot: int, connSlot: int): int;  func rtLsnDevDeny(slot: int): int;  func rtLsnDevRemove(slot: int)
func rtLsnDevSocket(slot: int): int                  // the listener's DDP socket after Init (for the NBP registration); host stub returns 0
```
- `atalk_c.cla` externs (family prefix `AtalkH`, one per Task 2 `rt_ext_AtalkH*`): `AtalkHUp(): int`, `AtalkHNode(): int`, `AtalkHRegister(obj: string, typ: string, sock: int): int`, `AtalkHRemove(obj: string, typ: string): int`, `AtalkHLookupStart(lk: int, obj: string, typ: string, zone: string): int`, `AtalkHLookupDone(lk: int): int`, `AtalkHLookupCount(lk: int): int`, `AtalkHLookupAddr(lk: int, i: int): int`, `AtalkHLookupName(lk: int, i: int, out: ptr)`, `AtalkHAtpOpen(): int`, `AtalkHAtpClose(sock: int)`, `AtalkHAtpGetRequest(sock: int, buf: ptr, cap: int): int`, `AtalkHAtpReqOp(): int`, `AtalkHAtpReqFrom(): int`, `AtalkHAtpSendResponse(sock: int, code: int, buf: ptr, n: int): int`, `AtalkHAtpCall(addr: int, op: int, req: ptr, reqLen: int, resp: ptr, respCap: int): int`, `AtalkHAtpCallCode(): int`, `AtalkHPoll()`. Scratch buffers via `SerNewPtr`/`SerDisposePtr` (already-spliced `ser.cla` externs, the `conn.cla` precedent) — a 600-byte request scratch and a 4700-byte response scratch allocated once (`ptr` globals in `atalk_c.cla`: `rtAtCReqBuf: ptr[2]`, `rtAtCRespBuf: ptr`, `rtAtCNameBuf: ptr`).
- Semantics to implement in `atalk.cla` (from the spec): `rtSvcServe` → `rtAtDevUp` (failure → pending failed `"AppleTalk unavailable"`), `rtAtDevAtpOpen`, `rtAtDevRegister(name, typ, sock)` (−1027 → pending failed `"name in use"`), `rtAtDevAtpArm`; state open. `rtAtalkPump`: `rtAtDevPoll()`; per service slot: drain pending failed; if open and not `RespBusy` and `AtpPoll == 1`: build the `req` text by appending `ReqLen` bytes from `ReqPtr` (`t.append(char(peekb(p + i)))`, at most 578 iterations), set `InHandler`, `Replied = false`, fire `clar_svc_fire_request(slot, op, req, from)`, then if not `Replied` → `rtAtDevAtpRespond(slot, -1, ptr(0), 0)`; clear `InHandler`; re-arm only when `RespBusy` is false (checked each pass). `rtSvcReply`: `not InHandler` → `rtPanic("reply outside a request handler")`; `Replied` → `rtPanic("reply already sent")`; `data.length > 4624` → pending failed `"reply too long"` + automatic −1 reply; else copy the text's bytes into a `SerNewPtr` scratch with the `pokeb` loop `rtConnSendText` uses and call `AtpRespond` (which copies again into the slot's reply buffer, so the scratch is disposed right after). `rtSvcCallAddr`: `req.length > 578` → `rtSetLastErr(-3106, "request too long")`, false; `n = rtAtDevAtpCall(addr, op, reqPtr, len)`; `n < 0` → `rtSetLastErr(n, "no response")`, false; `code = AtpCallCode()`; empty `reply` (`reply.clear()`) and append `n` bytes from `CallPtr` with the same per-byte loop; `code != 0` → `rtSetLastErr(code, "service")`, false; else true. `rtSvcCallName`: split at the first `:` (obj, type); `rtAtDevLookupStart(rtAtNameCallLk = 10, ...)` — sync: lookup slot 10 is reserved for name-calls, spin `while not LookupDone { rtAtDevPoll() }` (host) / Toolbox sync lookup (native handles inside `LookupStart` returning done immediately), count 0 → `rtSetLastErr(-1025, "name not found")`. `rtBrsFind`: parse `typ`; `LookupStart(slot, "=", typ, zone)`; state searching. Pump: when `LookupDone`, fire `found` per tuple (`name = LookupName`, `addr`), then `done`, state idle. `rtBrsZones`: `out.clear()`; `rtAtDevZones(out)`; on `noBridgeErr`/`reqFailed`/any error → `out.clear(); out.add("*")`. `rtLsnRegister`: `rtAtDevUp`, `rtLsnDevInit(slot)` (rtAtErrNoHost → pending failed `"streams not available on this lane"`), `rtAtDevRegister(name, typ, listenerSocket)`, `rtLsnDevListen`. Pump: `rtLsnDevPoll == 1` → find a free conn slot (`rtConnState[i] == stClosed` — conn.cla's arrays; conn.cla is always spliced alongside), `rtLsnDevAccept(slot, i)` → set `rtConnState[i] = stOpen`, `rtConnSlotTransport[i] = 1` (declared in `atalk.cla`'s global table as `var rtConnSlotTransport: int[8]`, so `conn.cla` can read it in Task 9 without gaining a global of its own), fire `clar_lsn_fire_accepted(slot, i + 1)`; no free slot → `rtLsnDevDeny`; re-listen. `rtAdsp*`: thin state machine over `rtAdspDev*` + lookup slot `slot + 2`.

- [ ] **Step 1: Write the three modules** per Interfaces (stubs in `atalk_68k.cla` return `rtAtErrNoHost`/false/0 — Task 9 replaces bodies only).
- [ ] **Step 2: Splice** — `drive.cla` host branch becomes `else if usesConn or usesAtalk { conn.cla, conn_c.cla, atalk.cla, atalk_c.cla }`; the rtbake fallback condition gains `or ((usesConn or usesFileh or usesAtalk) and not want68k)` (spec §7, TODO fix (b)) with the log line `"clarusc --rtbake: host program uses connection/filehandle/AppleTalk; falling back to a from-source compile"`. Do NOT touch the `want68k` branch or `bake.cla`.
- [ ] **Step 3: `tests/atalk/splice.sh`** — `host_build` a program that only declares `var s: service` and `var b: serviceBrowser` (no method calls; `on App.startCLI` logs and quits): assert the build succeeds and the emitted C defines `clar_fn_rtAtalkPump` and `clar_fn_rtSvcServe` (the splice happened and every module function compiles on the host). Also `emit --rtbake` of the same program against a fresh C-lane bake: assert the log contains `falling back` and the output compiles (the C-lane gap's closing test). Also build `tests/conntest/testdata/echo.cla` (serial only) and assert it still runs (`make test T=conntest/connect`) — conn programs now carry `atalk.cla` too. Regenerate `testdata/emitui/connpump_abort.c.golden` if its emission changed (it will: the extra module's functions); quote the diff summary in the report.
- [ ] **Step 4: Gate + commit** — `make test T=atalk/ T=conntest/ T=emitui/ T=bake/`, then `scripts/test-task.sh --smoke`. Expected: zero cg68k churn (68k lane untouched).
```bash
git add runtime/clarus/atalk.cla runtime/clarus/atalk_c.cla runtime/clarus/atalk_68k.cla clarusc/drive.cla tests/atalk/splice.sh testdata/emitui/
git commit -m "feat(runtime): atalk.cla with host twin over the LToUDP stack; host splice; rtbake C-lane fallback"
```

---

### Task 8: Lowering for all four kinds + host end-to-end

Spec §7 (lowering), §8.1 end-to-end. Dispatchers are synthesized under `usesAtalk` only (Task 9 adds `or want68k` with the rebless).

**Files:**
- Modify: `clarusc/lower.cla` (`lowConnMethod` arms for `open` transport 1 / `open(addr)`; new `lowListenerMethod`, `lowBrowserMethod`, `lowServiceMethod` dispatched where `lowConnMethod` is chosen by receiver kind; `lowTopHandler` ladder for `listenerT`/`serviceBrowserT`/`serviceT`; slot pre-passes `lowLsnSlotOf`/`lowBrsSlotOf`/`lowSvcSlotOf` with caps 2 and diagnostics `too many listener variables (max 2)` etc.; `lowSynthAtalkDispatchers()` producing the seven `clar_*_fire_*` functions in the `lowSynthConnFireSimple`/`Received`/`Failed` shapes; `lowSynthConnPump` body gains `rtAtalkPump()` when `usesAtalk`; `string(addr)` → `rtAtalkAddrStr`), `clarusc/ir.cla` (`irUsesAtalk` beside `irUsesConn`), `clarusc/cprint.cla` (`cpEmitMain`: `irUsesAtalk` joins the loop gate; condition adds `clar_fn_rtAtalkAlive()`; body adds `clar_fn_rtAtalkPump()`).
- Create: `tests/lib_atalk.sh`, `tests/atalk/{serve,call,find,zones,runerr}.sh`, `tests/atalk/testdata/{clock,caller,finder,reply_twice,reply_outside,send_unopened_adsp,too_many_svc}.cla`, `testdata/emitui/atalk_{server,client,browser,listener}.{cla,c.golden}`, `examples/atalkfind.cla`.
- Read first: `clarusc/lower.cla:121-156, 1444-1575, 5210-5281, 7529-7727, 7893-7970`, `clarusc/cprint.cla:7678-7734`, Task 7's API block, `tests/conntest/connect.sh`, `tests/lib_conntest.sh`.

**Interfaces:**
- Consumes: Task 7's `rt*` names exactly; Task 2's `atalkdrive`.
- Produces (lowering): `c.open(appletalk s)` → `rtConnOpen(recv, 1, s)`; `c.open(addr)` (arg kind `TyAddress`) → `rtConnOpenAddr(recv, addr)` (in `atalk.cla` since Task 7, so it lowers and links on the host now; on the host it stages `failed` with `rtAtErrNoHost`); `l.register(n, t)` → `rtLsnRegister`; `l.stop()` → `rtLsnStop`; `b.find(t)` → `rtBrsFind(recv, t, "*")`; `b.find(t, z)` → `rtBrsFind(recv, t, z)`; `b.zones(out)` → `rtBrsZones`; `s.serve` → `rtSvcServe`; `s.reply(code, text)` → `rtSvcReply`, string arg → `rtSvcReplyStr`; `s.stop()` → `rtSvcStop`; `s.call(addr|str, op, req, reply)` → `rtSvcCallAddr`/`rtSvcCallName` by the first arg's kind; `string(addr)` → `rtAtalkAddrStr`. Handlers: `handler_<var>_<event>` functions recorded in `lowLsnHandlerFn`/`lowBrsHandlerFn`/`lowSvcHandlerFn` keyed `"<slot>|<event>"`. Dispatchers: `clar_lsn_fire_accepted(slot: int, c: int)` (the handler's `c` param receives the int), `clar_lsn_fire_failed(slot, code, msg)` (assembles an `error` record like `lowSynthConnFireFailed`), `clar_brs_fire_found(slot, name: string, addr: int)`, `clar_brs_fire_done(slot)`, `clar_brs_fire_failed`, `clar_svc_fire_request(slot, op: int, req: text, from: int)`, `clar_svc_fire_failed`.

- [ ] **Step 1: Emitui fixtures first** — write the four `.cla` fixtures (server: `service` with `serve`/`request`/`reply`/`failed`; client: `call` with both target kinds + `string(addr)`; browser: `find` both arities, `found`/`done`/`failed`, `zones`; listener: `register`/`stop`/`accepted`/`failed` + `open(appletalk …)` + `open(addr)`). Run `make test T=emitui/`: expected FAIL with the `unsupported construct` abort for each.
- [ ] **Step 2: Implement lowering** per Interfaces, mirroring the excerpted shapes; `lowSynthAtalkDispatchers()` is called right after `lowSynthConnDispatchers()` under `if usesAtalk` (NOT `or want68k` — that is Task 9).
- [ ] **Step 3: Bless the four emitui goldens** (review the emitted C: each `clar_*_fire_*` is an if-chain over 2 slots; `cpEmitMain`'s loop shows both pumps).
- [ ] **Step 4: Host end-to-end** — `tests/lib_atalk.sh`: `atalk_build NAME` (host_build from `tests/atalk/testdata`), `atalk_skip_unless_multicast` (runs `$TOOLS/atalkdrive lookup ProbeNone 2>/dev/null; [ $? = 77 ] && skip ...`), `atalk_name` (`"T$$"` suffix). Scripts:
  - `serve.sh`: `clock.cla` serves `("Clock-$SFX", "ClarusClock")` (name from `args[0]`), op 1 → `reply(0, "12:00")`, op 2 → `reply(0, req)` (echo), op 3 → returns without replying, op 4 → `reply(7, "")`; `atalkdrive call` each: op 1 → `12:00`; op 2 with a 578-byte sweep → byte-exact; op 3 → exit 3 `code -1`; op 4 → exit 3 `code 7`; then `call ... 9` (unknown op → the program's `default` arm replies −1). Program quits on op 5; assert self-exit.
  - `call.sh`: `atalkdrive serve ("Echo-$SFX","ClarusEcho") 20 script` (op 1 → code 0 4000-byte file; op 2 → code 5 empty); `caller.cla` does `call("Echo-$SFX:ClarusEcho", 1, "hi", reply)` → logs `ok 4000`; op 2 → logs `err 5 service`; a call to `"Nobody-$SFX:ClarusEcho"` → logs `err -1025`; a call with a 579-byte request → logs `err -3106` (rejected before any packet leaves); exits 0. Assert the three log lines and total runtime under 15 s.
  - `find.sh`: `atalkdrive register ("Svc-$SFX","ClarusFind") 15` in the background; `finder.cla` `find("ClarusFind")` and logs `found <name> <string(addr)>` per hit then `done`; assert one `found Svc-$SFX:ClarusFind 0.N.S` line (N = the node the tool printed) and `done` last; then `find("ClarusFind", "*")` again → same; then `find("NoSuchType")` → only `done`.
  - `zones.sh`: `zones(out)` logs `zones 1 *`.
  - `runerr.sh`: `reply_twice.cla`, `reply_outside.cla` (calls `reply` from `App.startCLI`), `send_unopened_adsp.cla` (`c.open(appletalk "X:Y")` then immediate `c.send` — a panic `connection not open` since open is async), each run with `$TOOLS/timeout 10` and asserted to exit nonzero with the panic text on stderr; `too_many_svc.cla` (three `service` globals) asserted to fail at `clarusc emit` with `too many service variables (max 2)`.
  - `examples/atalkfind.cla`: host CLI browser: `zones` then `find(args[0] or "=")`, printing each entity; documented in the file header as the host acceptance program.
- [ ] **Step 5: Gate + commit** — `make test T=atalk/ T=emitui/ T=conntest/`, then `scripts/test-task.sh --smoke`. Expected: zero cg68k churn (dispatchers not synthesized under `want68k` yet).
```bash
git add clarusc/lower.cla clarusc/ir.cla clarusc/cprint.cla tests/lib_atalk.sh tests/atalk/ testdata/emitui/ examples/atalkfind.cla runtime/clarus/atalk.cla
git commit -m "feat(lower): listener/serviceBrowser/service/appletalk lowering and dispatchers; host end-to-end against atalkdrive"
```

---

### Task 9: Native integration — `atalk_68k.cla` real bodies, ADSP in `conn.cla`, 68k splice, the rebless wave

The one planned golden rebless. Candidate for `opus`.

**Files:**
- Modify: `runtime/clarus/atalk_68k.cla` (replace every stub; this task declares ALL of its globals), `runtime/clarus/conn.cla` (`rtConnMax` 4 → 8 and every `[4]` → `[8]`; `rtConnOpen` switches on `transport`: 2 → serial as today, 1 → `rtAdspOpenName(slot, spec)` with `rtConnSlotTransport[slot] = 1` and NO immediate `opened` (the pump sets it when `rtAdspPoll` returns 1); `rtConnPump` per slot: if transport 1 and phase < open → `rtAdspPoll`; avail/read/gone/close route to `rtAdsp*` for transport 1; `rtConnClose` resets transport to 0; the read path for transport 1 uses `rtAdspReadInto(slot, t)` — the batched read), `conn_68k.cla` (`rtConnOutRef`/`rtConnInRef` `[4]` → `[8]`), `runtime/host/rt_serial.inc` (`RT_CONN_MAX 8`, initializer), `clarusc/lower.cla` (cap 4 → 8 in the pre-pass and the `while i < 4` dispatcher loops; `lowSynthAtalkDispatchers` gate becomes `usesAtalk or want68k`), `clarusc/drive.cla` (`want68k` branch adds `atalk.cla`, `atalk_68k.cla` after `conn_68k.cla`), `clarusc/bake.cla:413-470` (`bakeModuleList` 68k lane adds the pair after `conn_68k.cla`), `scripts/build-clarusc-mac.sh` (`--bake` flags for the two files, if it enumerates runtime files explicitly — read it), `testdata/cg68k/*.s` (rebless), `docs/clarus-language-reference.md` only if a native behavior differs from the text.
- Create: `tests/bake/atalk.sh`, `testdata/cg68k/atalk_server.cla`, `atalk_client.cla` (+ blessed `.s`).
- Read first: `toolbox/appletalk.cla` (Task 6), `runtime/clarus/conn_68k.cla` (whole), `testsuite/toolbox/cases_serial.cla`, `tests/bake/connfileh.sh`, `tests/cg68k/goldens.sh:40-60`, Task 1's report (P1–P3), Inside Macintosh VI ch. 32 (ADSP) pages 32-43…32-80 and IM Networking ch. 5–6 via `inside-macintosh-v2/*.pdf` `pages` param for the sequences.

**Interfaces:**
- Consumes: Task 7's waist names (bodies only change), Task 6's constants/offsets.
- Produces (`atalk_68k.cla` globals, declared once): `rtAt68MppRef: int`, `rtAt68DspRef: int`, `rtAt68XppRef: int`, `rtAt68Up: bool`; per lookup slot `rtAt68LkPb: ptr[10]` (44-byte NBP PBs via `NewPtrClear`), `rtAt68LkEntity: ptr[10]` (99 bytes), `rtAt68LkBuf: ptr[10]` (2048 bytes, `maxToGet` 32); per service slot `rtAt68SvcGetPb: ptr[2]`, `rtAt68SvcReqBuf: ptr[2]` (600), `rtAt68SvcRespPb: ptr[2]`, `rtAt68SvcRespBuf: ptr[2]` (4624), `rtAt68SvcBds: ptr[2]` (96 = 8 × 12), `rtAt68SvcNte: ptr[2]` (108); requester `rtAt68CallBuf: ptr` (4624), `rtAt68CallBds: ptr` (96), `rtAt68CallCode: int`; listener `rtAt68LsnCcb: ptr[2]` (242), `rtAt68LsnPb: ptr[2]` (68), `rtAt68LsnNte: ptr[2]`; per conn slot `rtAt68Ccb: ptr[8]` (242), `rtAt68Pb: ptr[8]` (68, reused for open/read/write/status/close), `rtAt68SendQ: ptr[8]` (1024), `rtAt68RecvQ: ptr[8]` (1024), `rtAt68Attn: ptr[8]` (570), `rtAt68Scratch: ptr` (1024 read scratch). All allocated lazily on first use with `NewPtrClear`, never freed except the per-conn ADSP set on close (`DisposePtr`, so `AdspLeak` in Task 11 can prove FreeMem-flat).
- Sequences (offsets from Task 6): `rtAtDevUp`: `PBOpenSync` `.MPP` (refnum −10), then `.XPP` (failure tolerated: `rtAt68XppRef = 0` → `rtAtDevZones` returns `noBridgeErr`), then `.DSP` (failure tolerated: `rtAt68DspRef = 0` → every `rtAdspDev*`/`rtLsnDev*` returns `rtAtErrNoHost` — the spec's "`.DSP` missing" failure). `Register`: fill NTE (`nteEntity` packed obj/type/`*`), PB `csCode` 253, `interval` 8, `count` 3, `ntQElPtr`, `verifyFlag` 1, `PBControlSync`. `LookupStart`: packed entity, PB `csCode` 251, `retBuffPtr`/`Size` 2048/`maxToGet` 32/`interval` 8/`count` 3, `PBControlAsync`; `LookupDone`: `peekw(pb + pbIoResult) <= 0`; `LookupCount`: `numGotten`@42; `LookupAddr/Name`: walk tuples (`tupleEntity` packed strings; tuple stride = 5 + 3 + lengths). `Zones`: `XCallParam` with `csCode` 246, `xppSubCode` 6, `xppTimeout` 3, `xppRetry` 4, `zipBuffPtr` → 578 bytes, `zipInfoField` first word 0; loop `PBControlSync` until `zipLastFlag != 0`, appending each Pascal string; `noBridgeErr` → return it. `AtpOpen`: `csCode` 254, `atpSocket` 0, `addrBlock` 0 → returns `atpSocket`. `AtpArm`: PB `csCode` 253, `atpSocket`, `reqPointer` → `ReqBuf`, `reqLength` 578, `PBControlAsync`. `AtpPoll`: `ioResult <= 0` → 1 (`op` = `userData`@18, `from` = packed `addrBlock`@30, `len` = `reqLength`@34, `transID`@46 saved; `atpFlags`@29's XO bit saved). `AtpRespond`: copy into `RespBuf`; BDS entries: `buffSize` 578, `buffPtr` = `RespBuf + 578*i`, `dataSize` = min(578, remaining), `userBytes` = `code` on entry 0 (0 elsewhere); PB `csCode` 252, `atpSocket`, `atpFlags` = XO if the request was XO, `addrBlock` = from, `bdsPointer`, `numOfBuffs` = n, `bdsSize`@45 = n, `transID`; `PBControlAsync`; `RespBusy` = its `ioResult > 0`. `AtpCall`: BDS ×8 over `CallBuf`, PB `csCode` 255, `atpFlags` XO, `addrBlock`, `reqLength`, `reqPointer`, `bdsPointer`, `numOfBuffs` 8, `timeOutVal` 2, `retryCount` 3, `PBControlSync`; result < 0 → return it; concatenate `numOfResps`@46 entries' `dataSize` bytes (they are contiguous only if each is full — copy into `CallBuf` compacted); `CallCode` = BDS[0].`userBytes`. ADSP: `rtAdspDevOpen`: `dspInit` (`csCode` 255: `ccbPtr`, `userRoutine` 0, `sendQSize` 1024, `sendQueue`, `recvQSize` 1024, `recvQueue`, `attnPtr`, `localSocket` 0) → `ccbRefNum`@32 saved (in the CCB's `refNum`); then `dspOpen` async (`csCode` 253, `ccbRefNum`, `remoteAddress`@38 = addr, `filterAddress` 0, `ocMode` 1, `ocInterval` 6, `ocMaximum` 3); `OpenPoll`: `ioResult` 0 → 1; > 0 → 0; < 0 → the error (then `dspRemove`). `Avail`: `dspStatus` (`csCode` 247, `statusCCB`) → `recvQPending`@42. `Read`: `dspRead` sync with `reqCount` = min(n, pending), `dataPtr` = p → `actCount`. `Write`: `dspWrite` sync, `reqCount` n, `dataPtr` p, `eom` 0, `flush` 1. `Gone`: `peekw(ccb + ccbState) >= 5`. `Close`: `dspClose` (`abort` 0), `dspRemove` (`abort` 1), `DisposePtr` the four blocks. Listener: `rtLsnDevInit`: `dspCLInit` (`csCode` 251, `ccbPtr`, `localSocket` 0) → socket = `peekb(ccb + ccbLocalSocket)`, returned by `rtLsnDevSocket(slot)`; `Listen`: `dspCLListen` async (`csCode` 249, `ccbRefNum`, `filterAddress` 0); `Poll`: `ioResult <= 0` → 1; `Accept(slot, connSlot)`: `dspInit` a conn set, then `dspOpen` with `ocMode` 3 copying `remoteCID`@36, `remoteAddress`@38, `sendSeq`@46, `sendWindow`@50, `attnSendSeq`@56 from the listen PB; sync (accept completes when the handshake finishes; `ocInterval` 6 `ocMaximum` 3 bound it at ~3 s); `Deny`: `dspCLDeny` (`csCode` 248, `remoteCID`, `remoteAddress` from the listen PB); `Remove`: `dspCLRemove` (`abort` 1).

- [ ] **Step 1: cg68k fixtures first** — `testdata/cg68k/atalk_server.cla` (serve + request/reply handler + listener register/accepted) and `atalk_client.cla` (browser + call + `open(appletalk …)` + `open(addr)`); `make test T=cg68k/goldens` → FAIL (`missing golden`). Do not bless yet.
- [ ] **Step 2: Implement** `atalk_68k.cla` bodies, `conn.cla` transport dispatch + 8 slots, `conn_68k.cla`/`rt_serial.inc` sizes, lowering cap + gate, `drive.cla`/`bake.cla` splice, `build-clarusc-mac.sh` flags.
- [ ] **Step 3: The rebless** — `make test T=cg68k/goldens` shows churn across the corpus. Prove it is renumbering/addition: for three unrelated goldens (e.g. `arith`, `bounce`, `calls`), diff old vs new after normalizing A5 offsets and label numbers (`sed -E 's/-?[0-9]+\(A5\)/OFF(A5)/g; s/L[0-9]+/L/g'`) and confirm the only remaining hunks are inside `cg_free_globals` (new handle-typed globals: the `string[2]` arrays) and the new `clar_*_fire_*` roots. Then `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`. Quote the normalized-diff line counts in the report.
- [ ] **Step 4: `tests/bake/atalk.sh`** — copy `tests/bake/connfileh.sh`'s shape with a fixture exercising every new `lowCoerceTo` site: `serve`, `reply` (text and string), `call` (address and string targets), `find` both arities, `zones`, `register`, `stop`, `open(appletalk …)`, `open(addr)`, `string(addr)`. Expected PASS byte-identical.
- [ ] **Step 5: Native hardware check** — `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k T=mactest/smoke_bounce T=mactest/tick` (the suite carries `atalk.cla` now; `AtalkSelf` still passes) and `make smoke`.
- [ ] **Step 6: Gate + commit** — `scripts/test-task.sh --smoke`, then `make test T=bake/` (full group).
```bash
git add runtime/clarus/ clarusc/ runtime/host/rt_serial.inc scripts/build-clarusc-mac.sh testdata/cg68k/ tests/bake/atalk.sh
git commit -m "feat(native): AppleTalk on the 68k lane (NBP/ATP/ZIP/ADSP/listener), ADSP as connection transport 1, 8 connection slots; golden rebless"
```

---

### Task 10: `mactest/atalk_68k.sh` (one boot + `atalkdrive`) and `examples/atalkclock.cla`

**Files:**
- Create: `examples/atalkclock.cla`, `testdata/ui/atalkclock.events`, `tests/mactest/atalk_68k.sh`.
- Read first: `examples/serialecho.cla`, `tests/mactest/toolbox_68k.sh`, `tests/lib_mac.sh`, `tests/lib_atalk.sh`, Task 1's report (LaunchAPPL timing).

**Interfaces:**
- Consumes: `atalkdrive` (`register`/`serve`/`call`/`lookup`), the runtime.
- Produces: `examples/atalkclock.cla`: window `Clock` with a `list`/`textview` of found entities, a `Zones` label, buttons `Find`, `Call`, and `Quit`; `service clock` served as `("Clock-" + string(TickCount() mod 10000), "ClarusClock")` (a per-boot suffix; the test discovers the actual name with `atalkdrive lookup ClarusClock`, taking the `Clock-` entry whose node is not the host's); ops: 1 → current `datetime` as text, 2 → echo; on `Call`: `browser.find("ClarusClock")` then on `found` of a name that is NOT its own, `call(addr, 1, "", reply)` and log `remote <name> <reply>`; the events script drives Find → wait → Call → wait → Quit.
- Test flow (`atalk_68k.sh`, `# timeout: 20m`, `require_env CLARUS_MAC_TESTS`, `atalk_skip_unless_multicast`): (1) `atalkdrive serve ("Host-$SFX","ClarusClock") 240 script` in the background (op 1 → `code 0` file `HOSTTIME`); (2) `emit68k` the example with the events file and boot it with `run_mac … 300`; (3) after the boot's log shows `serving`, from the host: `atalkdrive lookup ClarusClock` must list `Clock-…` at a nonzero node; `atalkdrive call <that name> ClarusClock 2 < sweep` → byte-exact 578-byte echo; `call … 1` → a non-empty reply; (4) the app's own log must contain `remote Host-$SFX:ClarusClock HOSTTIME` (the Mac called the host) and `done`; (5) exit 0. Since `run_mac` blocks, steps 3's host-side calls run from a background subshell started before `run_mac` that waits for `serving` by polling with `atalkdrive lookup` every 2 s (max 90 s) — the boot's log is only available after exit, so the subshell writes its own results to `$WORK/host.out` and the script asserts both files after `run_mac` returns.

- [ ] **Step 1: Example + events** (hand-run once with `scripts/build-68k.sh` and the P4 launch command to see it work).
- [ ] **Step 2: Script**, then `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/atalk_68k`. Expected PASS.
- [ ] **Step 3: Gate + commit** — `scripts/test-task.sh`.
```bash
git add examples/atalkclock.cla testdata/ui/atalkclock.events tests/mactest/atalk_68k.sh
git commit -m "test(mactest): NBP+ATP both ways between a Mini vMac boot and atalkdrive; atalkclock example"
```

---

### Task 11: `run_mac_pair`, `mactest/adsp_68k.sh` (two boots), `examples/atalkchat.cla`, `AdspLeak` case

**Files:**
- Modify: `tests/lib_mac.sh` (add `run_mac_pair BIN1 BIN2 SECS`), `testsuite/toolbox/cases_atalk.cla` (+ `AdspLeak`), `testsuite/toolbox/runner.cla` + the four count sites + `CLAUDE.md` (39 → 40).
- Create: `examples/atalkchat.cla`, `testdata/ui/atalkchat_server.events`, `testdata/ui/atalkchat_client.events`, `tests/mactest/adsp_68k.sh`.
- Read first: Task 1's P4 findings, `tests/lib_mac.sh:20-55`.

**Interfaces:**
- Produces: `run_mac_pair`: launches BIN1 on `macplus/` (default config) and, 5 s later from `$WORK/launch2`, BIN2 on `macplus2/` via `LaunchAPPL -e minivmac --minivmac-dir $ROOT/macplus2 --minivmac-path ./MacPlus2.app --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk BIN2`, both under `$TOOLS/timeout SECS`; waits for both; on either timeout kills BOTH (`pkill -f MacPlus.app; pkill -f MacPlus2.app` — use the process names P4 recorded) and dies; then `capture_split` each capture into `$WORK/cap1.*` and `$WORK/cap2.*`, setting `MAC_EXIT1`/`MAC_EXIT2`.
- `examples/atalkchat.cla`: one program, two roles chosen by which button the events script clicks (`Serve` / `Connect`): server registers `("Chat-<n>","ClarusChat")` on a listener, logs `accepted`, echoes every `received` back prefixed with `>`, logs `closed`; client `find("ClarusChat")`, on `found` opens `appletalk` by name (string form) → on `opened` sends a 0–255 sweep and `hello`, on `received` logs the length and closes after the echo of `hello` arrives, then quits; the server quits when its client's `closed` fires. Both write a log.
- `adsp_68k.sh` (`# timeout: 25m`): builds two `.bin`s from the same source with the two events files (one clicks `Serve`, the other `Connect`), `run_mac_pair`, asserts server log has `accepted`, `received 256`, `received 5`, `closed` and exit 0; client log has `opened`, `received 257`, `received 6`, exit 0.
- `AdspLeak`: `FreeMem` before; `dspInit` + `dspRemove` a connection set through the runtime's own `rtAdspDevOpen`/`rtAdspDevClose` on a slot with a bogus address (no open: `rtAdspDevOpen` is not called; the case exercises `dspInit` + `rtAdspDevClose`'s `dspRemove` and `DisposePtr` of the four blocks, 20 times); `FreeMem` after equal (the `LeakCheck` case's pattern).

- [ ] **Step 1: `run_mac_pair`** and a smoke: boot `tick` twice via the pair helper; both exit 0.
- [ ] **Step 2: Example + events + script**; `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k`. Expected PASS.
- [ ] **Step 3: `AdspLeak`** + counts (40); `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k`.
- [ ] **Step 4: Gate + commit** — `scripts/test-task.sh`.
```bash
git add tests/lib_mac.sh tests/mactest/adsp_68k.sh examples/atalkchat.cla testdata/ui/atalkchat_*.events testsuite/toolbox/ tests/mactest/toolbox_*.sh CLAUDE.md
git commit -m "test(mactest): two-boot ADSP echo between macplus and macplus2; atalkchat example; AdspLeak"
```

---

### Task 12: Documentation moves

**Files:** `docs/clarus-toolbox-cookbook.md` (an AppleTalk `PBControl` transcription example: `lookupName` sync, with the offset-constant style for an async `getRequest`), `docs/TODO.md` (delete the two serial items under "Serial/connection phase (2026-08-16)" and the `--rtbake --lane c` item under compiler-cleanup; delete the filesystem-api duplicate of that gap), `docs/FUTURE.md` (add: host-lane ADSP; the UI/non-UI pump gap moved verbatim from TODO's binary-files entry; `service.call` retry knob; note the `system.has*()` family stays in TODO), `docs/ROADMAP.md` (AppleTalk status line: implemented on branch, MacTCP next), reference proofread pass (every ```rust fence still check-clean: `make test T=reftest/`).

- [ ] **Step 1: Edits**, `make test T=reftest/`, commit `docs: AppleTalk phase documentation moves`.

---

### Task 13: Snow — interop probe, `adsp_listener.sh`, the `clarusc_bake` gate

The ONLY Snow boots of the phase. Andrew's Snow instance may be in use: check `pgrep -l ClarusSnow` first and coordinate.

**Files:** `tests/mactest/snow/adsp_listener.sh` (new), `tests/lib_snow.sh` (read; reuse its workspace-clone helper), Task 1's report (appendix).

- [ ] **Step 1: Interop probe** — boot Task 1's `register` on Snow (System 7, `.DSP` built in) and `lookup` on `macplus/`; then the reverse. Record the result as Task 1's P5 appendix.
- [ ] **Step 2: `adsp_listener.sh`** (`require_env CLARUS_SNOW_TESTS`): Snow runs `atalkchat` as server, `macplus/` as client (reuse Task 11's events files); same assertions as `adsp_68k.sh`. Run: `CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener`.
- [ ] **Step 3: The standing gate** — `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (~30 min): `ClarusC.APPL`'s default bake path with the new module list.
- [ ] **Step 4: Commit** — `test(snow): System 7 ADSP listener proof; clarusc_bake gate re-run`.

---

### Task 14: Close-out — snapshot regen, T2, HISTORY, final review

- [ ] **Step 1:** Regenerate `clarusc/clarusc.c` per `tests/selfhost/fixedpoint.sh`'s `snapshot_fresh` recipe; `make test T=selfhost/`.
- [ ] **Step 2:** `scripts/test-merge.sh` (full T2, `CLARUS_MAC_TESTS=1`). Expected: every stage PASS.
- [ ] **Step 3:** `docs/HISTORY.md` entry (verbatim phase record incl. the probe findings and the rebless proof), `docs/ROADMAP.md` status, `CLAUDE.md` (suite counts already updated; add the `tests/atalk/` and `tests/atalkdrive/` groups and `CLARUS_ATALK_IFACE` to the test section; fix the stale `Retro68/InterfacesAndLibraries` header path to `toolchain/universal/CIncludes`), project memory note (`macplus2`, `ClarusSnow` process name, `disk1.dsk`).
- [ ] **Step 4:** Final whole-branch review (most capable model allowed), fix wave, T2 again, then report to Andrew — merge only on request.
