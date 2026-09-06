# AppleTalk phase — final fix wave (Task 15)

Worktree `/Users/andrew/repos/clarus-wt/t15`, branch `appletalk-t15`,
`a43b522..40ce5ef` (7 commits). Every finding in
`final-review-report.md` is addressed; nothing else was touched (the
dispatcher duplication was NOT folded, `bake.cla` was NOT touched, no
public runtime name changed).

| commit | finding(s) |
|---|---|
| `84b8f5d` | C1 |
| `5b055d5` | C2 |
| `87e2a1d` | I3 (+ goldens) |
| `1df154d` | I1, I2 |
| `40ce5ef` | the `examples.sh` file `1df154d`'s message describes (see note) |
| `1095a85` | minors: `rt_ext_EveryDue` overflow, `rt_ext_ConnHIdle` select set |
| `4245fdc` | I4 + spec §5.6 + stale citations + `toolbox/appletalk.cla` header + CLAUDE.md |

---

## C1 — `tests/mactest/adsp_68k.sh` committed red

**Changed.** After `run_mac_pair` returns and after the two verbatim
capture dumps — but **before** the first `t_fail`/`want_line` — the
script now greps the SERVER capture for the listener's own failure line
and skips:

```sh
if grep -q '^failed -1273 ' "$SRV"; then
    skip "boot disk lacks .DSP (AppleTalk system file not carried by LaunchAPPL)"
fi
```

The placement is the whole point and is written down in the comment: a
`FAIL ` line in the log beats exit 77 in this harness, so one assertion
ahead of the check would turn the skip into a red result. Every real
assertion below it is untouched, for Task 13's patched-LaunchAPPL lane.
The header's "There is no multicast/no-peer skip" paragraph now points
at the new check.

**Evidence — one real pair boot on the current disk:**

```
$ CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k
SKIP mactest/adsp_68k 40s
tests: 0 passed, 1 skipped, 0 failed

$ grep -c '^FAIL' build-run/tests/mactest/adsp_68k.log
0
$ tail -4 build-run/tests/mactest/adsp_68k.log
  server: failed -1273 streams not available on this lane
  client: connecting
  client: no server found
SKIP: boot disk lacks .DSP (AppleTalk system file not carried by LaunchAPPL)
```

Both paths proven: the skip path above, and the green path unchanged
because nothing below the check moved.

---

## C2 — `svc.call`'s `reply` out-parameter accepted a `string`

**Changed** (`clarusc/check.cla`, the `TyService` arm of
`checkMethodCall`, beside the `checkRejectParamFill` guard that was
already there):

```
arg4 = exprNext(exprNext(exprNext(argsHead)))
checkRejectParamFill(arg4)
t4 = exprTypeGet(arg4)
if t4 != InvalidT and typeKind(t4) != TyText {
    emitDiag(exprLine(arg4), exprCol(arg4), "call: reply must be a text variable")
}
```

`exprTypeGet` (not a second `checkExpr`) for the same reason the `zones`
and `readAt` guards read it: `checkTableMethod`'s own `checkParamArg`
walk is what warms the memo, so the guard runs after dispatch. The
`t4 != InvalidT` gate keeps a program that already has an argument error
from getting two diagnostics for one mistake.

**Evidence:**

```
$ build-run/clarusc-current emit -o /tmp/o.c ../../testdata/errors/svc_call_reply.cla
../../testdata/errors/svc_call_reply.cla:14:45: call: reply must be a text variable
rc=1
$ build-run/clarusc-current testdata/valid/atalk_ok.cla ; echo $?
0
$ make test T=selfhost/diag
PASS selfhost/diag 0s
```

`testdata/errors/svc_call_reply.{cla,expect}` added (a `var answer: string`
passed as `call`'s fourth argument, in an `App.startCLI` program).

**The class-wide hole is recorded**, not silently narrowed:
`docs/TODO.md` gains a new `## Compiler: type checking` heading with a
paragraph naming `file.readText(path, s)` and `fh.readAt(0, 4, s)`, why
those two are merely noisy (their callee is an intrinsic taking `rt_text`
by value, so `cc` errors) while `svc.call` was silent (its callee is a
lowered Clarus function, so `cc` only warns), and what the general fix
is: a parameter-shape flag in the checker that suppresses the
string→text coercion and rejects any non-matching argument, applied to
the whole family at once.

---

## I1 — narrow the LToUDP test lock

**Changed.**

- `tests/atalk/{call,find,serve,zones}.sh`: the `atalk_build` block moved
  **above** `atalk_lock`, and `atalk_lock` now sits immediately above
  `atalk_skip_unless_multicast`. Compiles run unlocked; the probe and
  everything after it stay locked. (`runerr.sh` is restructured by I2
  below and gets the same treatment.)
- `tests/lib_atalk.sh`: `atalk_unlock` now refuses to remove a lock it
  does not own —
  `[ "$(cat "$ATALK_LOCK/pid" 2>/dev/null)" = "$$" ] || return 0` — which
  closes the race where a waiter that stole a dead holder's lock and then
  exited could delete the directory a *second* waiter had legitimately
  created. Wait bound 300 → 600 s. The file header now names all three
  groups that source it (`tests/atalk/`, `tests/atalkdrive/`,
  `tests/hostrt/atalk.sh`), not just the first.
- `tests/atalkdrive/*.sh` and `tests/hostrt/atalk.sh` untouched, as
  instructed (they build nothing).

**Re-timing — the honest number: the narrowing buys almost nothing.**

| run | wall |
|---|---|
| `make -j t1` (whole gate, after the wave) | **2:14.47** |
| `scripts/test-task.sh --smoke` (t1 + perfgate + 2 boots) | 2:21 / `PASS in 141s` |
| `make -j test T='atalk/ atalkdrive/ hostrt/atalk'` — **old** scripts (9 scripts) | 2:13.94 |
| `make -j test T='atalk/ atalkdrive/ hostrt/atalk'` — **new** scripts (10 scripts) | 2:11.38 |

A ~2.5 s gain, while *adding* a script. Measured back to back on an idle
machine. The compiles were never the cost: `atalk/examples` (three
check-only compiles) is 0 s and `atalk/splice` is 1 s, while the
serialized network chain runs 130 s (`find` finishes last at 131 s).
The cost is the waits — `atalk_wait_line`'s up-to-20 s NBP-registration
confirmations and `atalk_wait_exit`'s up-to-15 s lifetime checks, times
five scripts, serialized. The change is still right (a compile has no
business holding a network mutex, and it makes the lock's scope
truthful), but the review's recommendation 6 is the operative one: if T1
needs to come back toward a minute, the lever is the waits, not the
lock. Recorded here rather than dressed up.

---

## I2 — `tests/atalk/runerr.sh` hid network-free assertions behind the gate

**Changed.** Section order is now gate order:

1. the two `check_panic` cases (`reply_outside`, `send_unopened_adsp`) —
   unconditional, unlocked;
2. the three `check_cap` build-error cases (`too_many_{lsn,brs,svc}`) —
   unconditional, unlocked, `clarusc emit` only;
3. `reply_twice`, the only section needing a peer — `atalk_lock` and
   `atalk_skip_unless_multicast` immediately above it.

Previously the probe was line 15 and section 3 was last, so on a host
without multicast **all five** assertions vanished — including the
phase's own cap diagnostics, which never touch a network. The two
header comments were rewritten to say why the sections are in this
order.

Note recorded rather than hidden: `send_unopened_adsp` does reach
`rtAtEnsureUp` (its `open(appletalk …)` starts an NBP lookup) before the
`send` panics, so it does put a stack on the group for a few
milliseconds, outside the lock. That is the shape the instruction asked
for and the exposure is negligible next to the five scripts that hold a
stack up for tens of seconds; if it ever flakes, the fix is to move that
one case under the lock, not to re-gate the section.

**Evidence:** `PASS atalk/runerr` in every run; wall time dropped 115 s →
44 s in the T1 run (the section that used to wait for the group now runs
last instead of blocking the two cheap sections behind it).

---

## I3 — a listener that fails a `dspCLListen` went permanently deaf

**Root cause** (`runtime/clarus/atalk.cla`, `rtAtalkPump`'s listener
arm): the re-arm `rtLsnDevListen(i)` lived only in the `pr == 1` branch.
Natively `rtLsnDevPoll` has already cleared `rtAt68LsnLive[slot]` by the
time it returns a negative, so every later poll returned 0 — the slot
stayed `rtAtActive` with nothing armed: deaf forever, the NBP name still
advertised, and `rtAtalkAlive` still holding a host CLI program open,
after exactly one `failed` event.

**Fix — teardown, not re-arm.** One added statement:

```
             if pr < 0 {
+                // ... (16 lines of reasoning)
                 rtLsnSetFailed(i, pr, "listener failed")
+                rtLsnStop(i + 1)
             } else if pr == 1 {
```

Why this one of the two the review offered:

- **State must match what the program was told.** The program has just
  received `failed` for its listener; leaving the name advertised and the
  slot `rtAtActive` contradicts that, and `stop()` would still be
  required to end a CLI program.
- **Re-arming turns one failure into a storm.** `rtLsnSetFailed` only
  stages when no event is pending, but the pump fires and clears the
  pending event every pass — so a persistent cause (the driver gone, the
  socket lost) would refire `failed` on every single pump pass forever.
- **It is smaller.** `rtLsnStop` already *is* the teardown (NBP name via
  `rtAtDevRemove`, device slot via `rtLsnDevRemove`, state to `rtAtIdle`,
  names cleared) and is documented idempotent, so the fix reuses it
  instead of open-coding three calls.
- The staged event still reaches the program: `rtAtalkAlive` counts
  `rtLsnPendFailedCode[i] != 0` independently of `rtLsnState[i]`, and the
  pending-event dispatch at the top of the listener loop is outside the
  `rtAtActive` guard.

### Golden churn — reblessed only what moved

`atalk.cla` is on the 68k superset, so `testdata/cg68k/atalk_{server,client}.s`
(+ their `seg2..seg5`) move; `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`
rewrote exactly those ten files and nothing else (`git status testdata/cg68k/`
lists ten paths). Raw vs. normalized (offsets `-?N(A5)` → `OFF(A5)`,
`LBL_n` → `LBL`, `#n` → `#N`):

| golden | raw | normalized |
|---|---|---|
| `atalk_server.s` | 10+/10− | **0** |
| `atalk_server.seg2.s` | 6+/6− | **0** |
| `atalk_server.seg3.s` | 10+/10− | **0** |
| `atalk_server.seg4.s` | 1459+/1459− | 12 |
| `atalk_server.seg5.s` | 198+/192− | 34 |
| `atalk_client.s` | 20+/20− | **0** |
| `atalk_client.seg2.s` | 13+/13− | **0** |
| `atalk_client.seg3.s` | 18+/18− | **0** |
| `atalk_client.seg4.s` | 5299+/5269− | 1514 |
| `atalk_client.seg5.s` | 1144+/491− | 741 |

The four `0`-residue files are pure jump-table renumbering, e.g.

```
-        JSR 4306(A5)
+        JSR 4298(A5)
```

The server's entire normalized residue is the call itself plus one
function crossing a segment boundary:

```
--- server.seg4 normalized
         JSR OFF(A5)
         ADDA.W #N,A7
+        MOVE.L -4(A6),D1
+        MOVEQ #N,D0
+        ADD.L D1,D0
+        MOVE.L D0,-(A7)
+        BSR.W LBL          <- rtLsnStop(i + 1)
+        ADDQ.L #N,A7
         BRA.W LBL
...
         ; func clar_ui_fire_launchdoc  (JT slot 524)
-LBL: LINK A6,#N / LBL: UNLK A6 / RTS
-        ; func clar_ui_fire_startempty  (JT slot 525)
```

`clar_ui_fire_startempty` did not disappear — it moved to the tail of
`seg5` (`; func clar_ui_fire_startempty  (JT slot 539)`), pushed across
the boundary by the six added instructions, which is why `seg5`'s
residue is a block of `JT slot n` → `n−1` comment renumbering. The
server's **function set is byte-identically the same** (`diff` of the
sorted `; func` names across all five segments: empty; 102 → 101 in
seg4, 18 → 19 in seg5).

The client's larger residue has one real cause, and it is a genuine cost
worth stating: the pump now references `rtLsnStop` **unconditionally**,
so `shake` keeps five functions in a program that has no listener at
all —

```
> ; func rtLsnStop
> ; func rtAtDevRemove
> ; func rtLsnDevRemove
> ; func rtAt68NteFind
> ; func rtAt68PStrEq
```

— and every native build (the 68k superset splices `atalk` into all of
them) now carries them. They are small, and the alternative (bare
re-arm, which adds no new function because `rtLsnDevListen` is already
referenced) is the semantically wrong fix. Recorded, not hidden.

**Host goldens** (`testdata/emitui/`): the review predicted
`atalk_listener.c.golden`; three more moved for the same shake reason.
`atalk_listener` gains exactly one line, because that program already
called `lsn.stop()`:

```diff
@@ -2313,4 +2313,5 @@ static void clar_fn_rtAtalkPump(void) {
             if (cv_pr < 0) {
                 clar_fn_rtLsnSetFailed(cv_i, cv_pr, &(clar_lit_151));
+                clar_fn_rtLsnStop(CLAR_ADD32(cv_i, 1));
             } else {
                 if (cv_pr == 1) {
```

`atalk_browser` / `atalk_client` (+33 lines each) and `atalk_server`
(+27) gain the same call line plus the pulled-in `clar_fn_rtLsnStop`
body and two or three forward declarations:

```diff
+static void clar_fn_rtLsnStop(int32_t cv_h);
+static int32_t clar_fn_rtAtDevRemove(const clar_str_255 *cv_obj, const clar_str_255 *cv_typ);
+static void clar_fn_rtLsnDevRemove(int32_t cv_slot);
...
+static void clar_fn_rtLsnStop(int32_t cv_h) {
+    ...
+    clar_fn_rtAtDevRemove(&(t1), &(t2));
+    clar_fn_rtLsnDevRemove(cv_slot);
+    (cv_rtLsnState).e[...] = 0;
+    clar_fn_rtStrStore(... cv_rtLsnName ...);
+    clar_fn_rtStrStore(... cv_rtLsnType ...);
+}
```

These four were regenerated with `clarusc-current emit` (the group has no
bless variable) and `make test T=emitui/` is green.

---

## I4 — the reference documented no host-lane AppleTalk behavior

**Changed.** One paragraph at the end of Chapter 12's *Services*
section (so it is reachable from both *Service Discovery* and
*Services*), modelled on the Serial section's `CLARUS_SERIAL_*`
paragraph: a host build is a **real** LocalTalk peer on the multicast
group `239.192.76.84:1954`, the same wire a local Mini vMac or Snow is
on; `find`/`zones`/`serve`/`reply`/`call` all work for real with the same
events, limits and `lastError`; `connection.open(appletalk …)`,
`connection.open(addr)` and `listener.register` fail with `failed` —
streams are Macintosh-only this release, the same environmental path a
System 6 machine without `.DSP` takes; `zones(out)` is always `["*"]`
on a host; and `CLARUS_ATALK_IFACE=<ipv4>` picks the interface on a
multi-homed host. The preceding `call` paragraph also gained one clause
saying `answer` must be a `text` variable, matching C2's new diagnostic.

Byte-safe: the edit was applied through a Python UTF-8 replace, not the
Edit tool; the em-dashes in the new prose match the file's existing
style.

```
$ make test T=reftest/
PASS reftest/checkclean 0s
PASS reftest/extract 0s
PASS reftest/required 2s
```

No fence added, so no manifest index moved.

---

## Minors

- **`runtime/host/rt_ext_host.inc`** — both `due[idx] = now + periodTicks`
  armings (the first-call arm and the refire arm) now go through
  `(int32_t)((uint32_t)now + (uint32_t)periodTicks)`; the comment that
  claimed "no signed overflow anywhere" now says the *compare* wraps by
  definition **and** that the two armings go through `uint32_t` for the
  same reason, because signed `now + periodTicks` is UB within
  `periodTicks` of the wrap.
- **Spec §5.6** — "a 2 KB return buffer" → "a 4 KB return buffer
  (`rtAt68LkBufSz` = 4096 — 32 tuples at up to 104 bytes each)".
- **Stale citations** — `clarusc/drive.cla` (two comments) and
  `tests/atalk/splice.sh` (two comments) cited "docs/TODO.md's fix (b)",
  a line this phase deleted. They now cite the compiler-cleanup entry in
  `docs/HISTORY.md` (where the gap and its two candidate fixes are
  recorded) and the AppleTalk spec §7. Comment-only; `splice.sh` still
  passes.
- **`toolbox/appletalk.cla:18`** — the header now cites
  `toolchain/universal/CIncludes/{AppleTalk,ADSP,MacErrors,Devices}.h`
  (verified to exist) instead of
  `Retro68/InterfacesAndLibraries/Interfaces/CIncludes`. Byte-safe edit;
  the `LC_ALL=C tr` reading note is preserved.
- **`rt_ext_ConnHIdle` now `FD_SET`s the AppleTalk UDP fd** when
  `rt_ext_AtalkHFd() >= 0`, closing spec §6.1's stated integration — a
  host AppleTalk-only server previously took the `usleep` arm and woke
  50×/s. `rt.c` includes `rt_serial.inc` **before** `rt_atalk.inc`, so
  the file carries a forward declaration `int32_t rt_ext_AtalkHFd(void);`
  with a comment saying why; both live in the same translation unit, so
  there is no link exposure for a build without AppleTalk. Verified
  `cc -std=c99 -Wall -Werror -c runtime/host/rt.c` clean, and the whole
  `conntest/` + `hostrt/` set is green.
- **`tests/atalk/examples.sh`** (~15 lines) check-compiles
  `examples/atalk{clock,chat,find}.cla` with
  `$CLARUSC FILE --rtdir $RTDIR` — no network, no lock, 0 s.
- **`CLAUDE.md`** — a new bullet in the test section covering: the three
  groups that put an LToUDP stack on the loopback multicast group
  (`tests/atalk/`, `tests/atalkdrive/`, `tests/hostrt/atalk.sh`); the
  `atalk_lock` `mkdir` mutex, why it exists (a dozen stacks racing for
  127 node ids under `make -j`, on a group shared with live emulator
  sessions), and that it is now taken as late as possible with compiles
  and `runerr.sh`'s network-free sections outside it;
  `atalk_skip_unless_multicast`; `CLARUS_ATALK_IFACE`; and that
  `runtime/clarus/atalk.cla` + `atalk_68k.cla` are in the 68k superset
  (hence in `bake.cla`'s 68k list, and any edit moves the
  `cg68k/atalk_*` and `emitui/atalk_*` goldens). The Retro68 bullet's
  stale `Retro68/InterfacesAndLibraries` path is replaced with
  `toolchain/universal/CIncludes` plus the CR-only/MacRoman reading note.
  The toolbox suite count was already 39 (38 real) — no change needed.

**Explicitly not done, as instructed:** the `lowSynthAtalkFire*` /
`lowSynthConnFire*` fold, anything in `bake.cla`, any public runtime
name.

---

## Gate

| gate | result |
|---|---|
| `scripts/test-task.sh --smoke` | `test-task.sh: PASS in 141s (smoke=1)` — t1 103/33 skip/0 fail, perfgate 1/0/0, `mactest/{smoke_bounce,tick}` 2/0/0 |
| `make -j t1` (timed, separate) | 0 failed, **2:14.47** wall |
| `make -j test T='reftest/ bake/ atalk/ emitui/ cg68k/goldens'` | 40 passed, 7 skipped, 0 failed |
| `make test T=selfhost/diag` (the new error fixture) | PASS |
| `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k` | **SKIP** 40 s, 0 `FAIL` lines in the log |
| `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/atalk_68k` | **PASS** 216 s |
| `cc -std=c99 -Wall -Werror -c runtime/host/rt.c` | clean |

(The `--smoke` run shows 103 rather than 104 t1 passes because
`examples.sh` was missing at that moment — see the note below; the final
combined run above has it back and green.)

## One process note

`tests/atalk/examples.sh` was written and passing before the
before/after lock timing, but the "old scripts" timing run deleted it
(`rm -f`) and `git stash pop` could not restore an **untracked** file, so
it missed commit `1df154d` whose message describes it. Recreated
verbatim and committed as `40ce5ef`, which says so. The tracked files in
that stash round-tripped correctly (verified against `HEAD~2`: the 600 s
bound, the pid ownership check, and `runerr.sh`'s relocated `atalk_lock`
are all in the commit).

## Concerns left standing

1. **T1 is still ~2:14.** The lock narrowing is correct but bought ~2.5 s;
   the network waits are the cost. Recommendation 6 of the review is
   unaddressed by design (out of scope for this wave) and is the real
   lever.
2. **Every native binary grew by five small functions** (`rtLsnStop` and
   its callees), because the pump now references the teardown
   unconditionally. Deliberate — the alternative is the wrong fix — but
   it is a real, permanent size cost on the 68k superset.
3. **`svc.call`'s guard is a one-off.** The class-wide out-parameter hole
   is recorded in `docs/TODO.md`, not fixed; the next `text`
   out-parameter added to the language will need to remember the guard
   until real out-param typing lands.
4. **`adsp_68k.sh` proves nothing today.** It SKIPs on every current
   boot disk. Task 13's out-of-repo LaunchAPPL patch is still what makes
   the ADSP stream stack a tested surface.
