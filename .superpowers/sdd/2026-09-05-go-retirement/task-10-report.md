# Task 10 report: `tcpdrive` tool and `conntest`

Worktree: `/Users/andrew/repos/clarus/.claude/worktrees/agent-a4cc48550e7397ba5`
Branch: `worktree-agent-a4cc48550e7397ba5` (base reset to `go-retirement` =
`76a54c2`, which the worktree was NOT on when I started — it was on
`aa31091`, main's tip. `git reset --hard go-retirement` per preamble §0.)

## What I implemented

### 1. `tests/tools/tcpdrive.c` (new, 480 lines)

Single C99 file, POSIX sockets + `poll` for every deadline, no threads, no
compiler code. Builds clean under the Makefile's `-std=c99 -Wall -Werror`
rule (it is picked up automatically by `TOOL_SRCS := $(wildcard
tests/tools/*.c)` — no Makefile edit needed).

Subcommands: `pick-port`, `listen PORT SCRIPT`, `connect HOST:PORT
[--retry SECS] SCRIPT`. Steps: `expect FILE`, `expect-sub STRING MAXBYTES`,
`send FILE`, `sleep MS`, `close`, `await-close SECS`. Exit 0 on script
completion, 1 on divergence (`step N: REASON at byte K` + a 32-byte hex
window of got vs want), 2 on usage/socket error.

Implementation notes:

- One shared read buffer (`rbuf`/`rpos`/`rlen`) behind every read step, so
  `expect-sub` may over-read past its needle without losing bytes a later
  `expect` needs. `fill()` compacts, polls with the remaining deadline,
  reads; returns 1/0/-1 for data/EOF/timeout. `ECONNRESET` is treated as a
  close (an abortive close is still a close).
- `expect` compares incrementally as bytes arrive (no requirement that the
  whole file fit in the buffer), 30 s read deadline per step, and reports
  the offset within the expected file as `K`.
- `expect-sub` accumulates into a `maxbytes`-sized window and `memcmp`s the
  tail each byte — an exact search, not a hand-rolled restart heuristic
  that would mis-handle a needle with internal repeats. Bytes before the
  match are discarded, which is the leading-garbage tolerance Task 14's
  Snow bridge needs; documented in the usage text.
- `STRING` may be double-quoted and understands `\r \n \t \0 \\ \"`, so
  `expect-sub "READY\r" 64` works verbatim from a script.
- `await-close SECS` drains and discards anything still arriving; success
  is peer EOF, failure is the deadline.
- `close` is `shutdown(sock, SHUT_WR)`.
- `--retry SECS` re-dials every 250 ms with a 500 ms non-blocking
  connect+`poll(POLLOUT)`+`SO_ERROR` attempt each time until SECS elapse.
- **One addition beyond the brief's Interfaces block**: `listen PORT` accepts
  `PORT 0` (ephemeral) and always prints `port N` on stdout (flushed) before
  blocking in accept. This removed the pick-port-then-bind steal window
  from `connect.sh` and `abort.sh` entirely — those two need a *listening*
  peer, so with `listen 0` they need no port-collision retry loop at all,
  and the printed line doubles as "the listening socket is up now" (closing
  the other race: program dials before the peer has bound). `pick-port`
  remains, and is what `listen.sh` uses (there the *program* binds).

### 2. `tests/lib_conntest.sh` (new)

Three helpers, per the controller's "never `lib.sh`" instruction:

- `conn_build NAME` — `host_build` of `tests/conntest/testdata/NAME.cla`
  into `$WORK/NAME` (build output to `$WORK/NAME.build`). `host_build` uses
  `$CLARUSC` = `clarusc-current`, which is the requirement Go's
  `buildConnFixture` encodes (the committed snapshot cannot parse `serial`).
- `conn_sweep FILE` — the 0-255 sweep, built as the controller specified:
  `printf '%02x'` of the hex list piped through `xxd -r -p`, then asserted
  to be exactly 256 bytes. (Not awk `printf "%c"`, which is not byte-safe
  for NUL/high bytes in POSIX awk.)
- `conn_wait_self_exit PID NAME` — Go's `waitExit`: polls `kill -0` for up
  to 5 s, FAILs if the process is still alive (and only then kills it, to
  clean up), else `wait`s and requires exit 0.

### 3. `tests/conntest/{connect,listen,envunset,abort,shadow}.sh` (new)

POSIX sh only — verified with `sh -n`; no arrays, no `[[ ]]`, no `local`
(helper locals are `_`-prefixed globals), no `${!v}`, no `echo -e`.

### 4. Fixture move

`internal/conntest/testdata/{echo,echo_abort,conn_shadow_local}.cla` →
`tests/conntest/testdata/` via `git mv` (shows as `R` in `git status`).
`internal/conntest/conntest_test.go`'s five `filepath.Join(repoRoot(t),
"internal", "conntest", "testdata", ...)` calls became `"tests",
"conntest", "testdata"`; nothing else in the Go file changed.

## tcpdrive usage text

```
usage: tcpdrive pick-port
       tcpdrive listen PORT SCRIPT          (PORT 0 = ephemeral)
       tcpdrive connect HOST:PORT [--retry SECS] SCRIPT

pick-port prints a free 127.0.0.1 port. listen prints "port N" (the
port it actually bound) before waiting for a peer, so PORT 0 works.
connect --retry SECS re-dials every 250 ms, each attempt allowed 500 ms,
until SECS elapse.

SCRIPT is a line-oriented step list; blank lines and lines whose first
non-space character is '#' are ignored. Steps:
  expect FILE          read exactly size(FILE) bytes (30 s deadline) and
                       byte-compare them against FILE
  expect-sub STRING N  read at most N bytes, succeeding as soon as STRING
                       has been seen. Bytes BEFORE the match are discarded,
                       so leading garbage is tolerated (Snow's serial
                       bridge emits one noise byte ahead of the first real
                       byte). STRING may be double-quoted and may use the
                       escapes \r \n \t \0 \\ \" -- e.g.
                       expect-sub "READY\r" 64
  send FILE            write every byte of FILE
  sleep MS             wait MS milliseconds
  close                orderly shutdown of our writing half
  await-close SECS     the peer must close within SECS; bytes that arrive
                       meanwhile are drained and discarded

exit 0 = script completed; 1 = divergence ("step N: REASON at byte K"
plus a 32-byte hex window of got vs want); 2 = usage or socket error.
```

## Per-script result (no SKIPs — every script ran)

`make test T=conntest/`:

```
PASS conntest/abort 0s
PASS conntest/connect 2s
PASS conntest/envunset 1s
PASS conntest/listen 1s
PASS conntest/shadow 1s
tests: 5 passed, 0 skipped, 0 failed
```

Subcase lines from `build-run/tests/conntest/*.log`:

| Script | Go test | Subcases |
|---|---|---|
| `connect.sh` | TestConnectMode | `PASS build`, `PASS exchange`, `PASS lifetime` |
| `listen.sh` | TestListenMode | `PASS build`, `PASS exchange`, `PASS lifetime` |
| `envunset.sh` | TestEnvUnsetFailedPath | `PASS build`, `PASS exit1`, `PASS failed_msg` |
| `abort.sh` | TestAbortDuringPump | `PASS build`, `PASS prompt_exit1`, `PASS abort_msg` |
| `shadow.sh` | TestConnShadowedLocalIsNil | `PASS build`, `PASS exit3`, `PASS nil_panic` |

No script has a skip condition (none needs the emulator, vasm, or the
cross-toolchain — all five are host-only, exactly like the Go tests, which
also never skip).

### Per-script mapping to the Go assertions

**connect.sh** — peer is `tcpdrive listen 0` with the brief's script:
`expect-sub "READY\r" 64` / `send sweep` / `expect sweep` / `send sweep` /
`expect sweep` / `send qqq` / `expect qqq` / `await-close 5`. Program run
with `CLARUS_SERIAL_MODEM=connect:127.0.0.1:PORT`; `exchange` asserts
tcpdrive exit 0; `lifetime` is `conn_wait_self_exit` (must exit on its own,
status 0, within 5 s — never killed to pass).

**listen.sh** — up to 5 attempts of `pick-port` + spawn (`listen:PORT`) +
`tcpdrive connect --retry 5`. Retry fires only on tcpdrive exit **2** (a
dial/socket failure — the port-steal race Go's loop exists for); exit 1 (a
real divergence) breaks out and FAILs, so a retry can never mask a red.
The optional greeting is handled data-driven within the brief's grammar:
the script first sends a one-byte probe `!` (a byte in neither `READY\r`
nor the `QQQ` terminator) and consumes through its echo with
`expect-sub "!" 64`, whose leading bytes are discarded. The greeting, if it
arrives at all, is strictly earlier than that echo (`rtConnPump` drains
`opened` before `received`, and the probe cannot be received before the
accept), so the stream is byte-aligned either way and the sweep comparison
below stays byte-exact. No fixed sleep anywhere.

**envunset.sh** — `env -u CLARUS_SERIAL_MODEM -u CLARUS_SERIAL_PRINTER`,
asserts exit 1 and `failed:` on stderr.

**abort.sh** — peer is `tcpdrive listen 0` running `sleep 4000`: it accepts
and then never reads, writes, or closes for **longer** than the deadline
the program is held to, so an exit caused by this peer going away could not
pass. Program run under `"$TOOLS/timeout" 2`, so `rc == 1` proves both the
exit code and the promptness (expiry would be 124). Also asserts `boom` on
stderr.

**shadow.sh** — builds `conn_shadow_local.cla` clean (`PASS build` is the
"must BUILD clean, no lowUnsupported rejection" assertion), asserts exit 3
and `use of nil connection` on stderr. No TCP peer, matching Go.

## Mutation check

Per the brief: `printf 'QQQ'` → `printf 'QQ'` in `connect.sh`, so the
program never sees three consecutive `Q`s, never calls `conn.close()`, and
`await-close` must fail.

```
FAIL exchange: tcpdrive exit 1: port 63558
step 8: peer did not close within 5s at byte 0
  got:  (none)
```

`make test T=conntest/connect` reported `tests: 0 passed, 0 skipped, 1
failed`. Reverted immediately; the group is green again (see above).

Two extra negative probes on the tool itself (not committed, run by hand)
to prove `expect` and `--retry`/garbage tolerance are not vacuous:

```
step 1: expect mismatch at byte 6
  got:  77 6f 72 6c 64
  want: 57 4f 52 4c 44
rc=1
```
(`send "hello world"` vs `expect "hello WORLD"`), and a `--retry 5` client
dialed 2 s *before* its listener existed, against a peer sending
`\x07READY\rtail`, exited 0 — the leading `0x07` noise byte was tolerated
by `expect-sub "READY\r" 64`.

## Gates

- `make test T=conntest/` — **5 passed, 0 skipped, 0 failed** (above).
- `go test ./internal/conntest -count=1` — `ok clarus/internal/conntest
  15.432s` (the moved fixtures resolve at their new path).
- `scripts/test-task.sh` — `test-task.sh: PASS in 34s (smoke=0)`. Go lane:
  all 12 packages `ok`. Make lane: `tests: 7 passed, 0 skipped, 0 failed`
  (the 5 new + `runner/selfcheck` + `runner/timeout`). The
  `summary: no tests matched` / `make: *** [test] Error 2` line after it is
  the pre-existing `make test T=perfgate/ || true` guard (no perfgate
  scripts exist until Task 2) — unrelated to this task, and the script
  still reports PASS. `perfgate/tripwire` does not exist yet, so there was
  nothing to re-run separately.
- `sh -n` clean on all five scripts and `lib_conntest.sh`.

## Files changed

```
new:  tests/tools/tcpdrive.c
new:  tests/lib_conntest.sh
new:  tests/conntest/connect.sh
new:  tests/conntest/listen.sh
new:  tests/conntest/envunset.sh
new:  tests/conntest/abort.sh
new:  tests/conntest/shadow.sh
move: internal/conntest/testdata/echo.cla              -> tests/conntest/testdata/echo.cla
move: internal/conntest/testdata/echo_abort.cla        -> tests/conntest/testdata/echo_abort.cla
move: internal/conntest/testdata/conn_shadow_local.cla -> tests/conntest/testdata/conn_shadow_local.cla
edit: internal/conntest/conntest_test.go   (5 fixture paths: internal/ -> tests/)
```

No Makefile edit (the tool wildcard already covers `tcpdrive.c`), no
`lib.sh` edit, no `run1.sh`/`summary.sh` edit.

## Self-review

- **Completeness**: all five Go tests ported; every `t.Fatalf`/`t.Errorf`
  in `conntest_test.go` has a counterpart subcase (exit codes 1/3, the
  `failed:` / `boom` / `use of nil connection` stderr substrings, the
  byte-exact sweep, the QQQ echo, the multiple-`received` second write, the
  build-clean assertion, the lifetime rule, the 2 s promptness bound, the
  5-attempt listen retry, the optional greeting). No assertion dropped or
  weakened except as noted under Concerns.
- **POSIX shell**: `sh -n` clean; no bashisms. `env -u` is not in POSIX
  `env` but was explicitly specified by the controller and is present on
  macOS and GNU coreutils.
- **C**: `-std=c99 -Wall -Werror` clean (the Makefile rule itself); no
  threads; every blocking wait is a `poll` with a computed deadline; all
  `malloc` results checked; `fopen`/`socket`/`bind`/`accept` errors exit 2
  with `strerror`.
- **No unrequested extras**: the one addition beyond the brief's Interfaces
  block is `listen 0` + the `port N` line, justified above (it deletes shell
  retry logic rather than adding any, and closes two real races). No
  scenario/golden files, no docs, no new Makefile targets, no reviewer
  dispatched, no subagents.

## Concerns

1. **connect.sh's second write is the sweep again, not Go's text payload.**
   Go writes `"a second write, after the sweep"` for its second-`received`
   proof; the brief's script says `send sweep` / `expect sweep` twice, so
   that is what I wrote. The property under test (a second write also
   echoes, i.e. `received` fires more than once) is preserved identically;
   only the payload differs. Flag it if you want the literal Go bytes.
2. **`expect qqq` inserted before `await-close 5` in connect.sh.** The
   brief's script listed `send qqq`, `await-close 5` with no echo check, but
   Go asserts the `QQQ` echo byte-exactly, and preamble §3 forbids dropping
   an assertion. `await-close` drains, so the step is not required for the
   test to pass — it is there for parity. Say the word and I will remove it.
3. **`QQQ` must arrive as one `received` chunk.** `echo.cla`'s `quit3`
   counter is a handler-local, re-zeroed per `received` firing, so a `QQQ`
   split across two firings would never trigger `conn.close()` and
   `await-close` would time out. This is a pre-existing property of the
   fixture — the Go test has the identical exposure (a 3-byte loopback
   write) and passes — so I did not change it, but it is the one plausible
   flake surface in `connect.sh`/`listen.sh` under extreme load.
4. **The greeting almost certainly never arrives in listen mode.**
   `rtConnPump` drains `opened` *before* the `rtConnDevAvail` call that does
   the accept, and `opened` drains on the very first pass, so
   `rt_ext_ConnHWrite`'s still-listening discard should always eat it. Both
   my probe path and Go's peek path therefore exercise the "no greeting"
   branch in practice; the tolerance is kept because the Go test documents
   it as non-deterministic and I did not want to narrow a contract on the
   strength of a code reading.
5. **`abort.sh`'s peer holds the socket for 4 s.** Deliberate (it must
   outlive the 2 s deadline), but it means the script cannot finish faster
   than the program's own exit — measured 0-1 s wall, since the peer is
   killed as soon as the program is reaped.
6. The worktree arrived on the wrong commit (`aa31091`, main) and needed the
   preamble's `git reset --hard go-retirement`. Worth flagging for the other
   task dispatches.
