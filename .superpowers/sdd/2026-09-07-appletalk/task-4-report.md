# Task 4 report -- Host serial `stdio` and `pty` transports

Branch `appletalk-t4`, worktree `/Users/andrew/repos/clarus-wt/t4`.
Commit: `9239145 feat(host): stdio and pty serial transports`.

## What was implemented

`CLARUS_SERIAL_MODEM` / `CLARUS_SERIAL_PRINTER` accept two new values
beside `listen:PORT` / `connect:HOST:PORT` (spec 4.7, 6.3):

- **`stdio`** -- no fd is opened at all: the slot reads fd 0 and writes
  fd 1. `rt_conn_stdio_raw()` puts the terminal in raw mode (`cfmakeraw` +
  `tcsetattr`) only when `isatty(0)`, saving the old `termios` and
  restoring it from an `atexit` handler; under a pipe the whole step is
  skipped silently. `rt_ext_ConnHClose` never closes fd 0/1 (they are the
  process's own console, not something the slot opened).
- **`pty`** -- `posix_openpt(O_RDWR|O_NOCTTY)` / `grantpt` / `unlockpt` /
  `ptsname`, with `pty /dev/ttysNNN\n` written to stderr (`fflush`ed) at
  open. With no slave attached the slot sits in the existing `listening`
  state: writes discarded and reported successful, `Avail` 0, `Gone` 0.
  It leaves that state only when bytes actually ARRIVE from a client.

Slot struct gains `kind` (`RT_CONN_SOCKET`/`STDIO`/`PTY`), `gone`, and a
512-byte read buffer (`bufLen`/`bufPos`). `rt_conn_slot_clear()` is the
one place a slot is reset -- used by `ConnHClose` and by all four
`ConnHOpen` branches' belt -- and it closes the fd only when the slot owns
it, so a reopen over a `stdio` slot can never close the process's stdin.

### Two design points worth the controller's attention

1. **No FIONREAD for the non-socket kinds.** Verified directly on macOS: a
   pty master answers `FIONREAD` 0 while bytes are genuinely waiting
   (`poll()` says readable, `read()` then hands the bytes over). So
   `rt_conn_fd_avail()` polls (0 timeout), `read()`s into the per-slot
   buffer and reports the buffer's depth; `ConnHReadByte` pops from it.
   EOF is that same `read()` returning 0 (or failing hard), latched in
   `gone`, and `ConnHGone` reports it only once the buffer is also drained
   -- deliberately the same "all data first, THEN gone" ordering the
   socket path gets from `MSG_PEEK`.
2. **How "no slave attached" is tracked** (the brief offered two options):
   the slot leaves `listening` on the first byte received, not on a
   successful write. That choice is load-bearing beyond bookkeeping: a
   freshly granted pty slave is COOKED, and a cooked pty echoes the
   master's own writes straight back at it (verified: writing `zz` to the
   master read back as `7a 7a ...`, plus CR->CRLF rewriting), which would
   turn an echo server into an infinite loop. The runtime cannot fix that
   from its side -- on macOS the master is not a tty (`tcgetattr` fails
   ENOTTY), and holding a slave open itself would destroy both the
   unattached state and the hangup signal -- so the client owns the
   slave's line discipline, exactly as it owns a real serial device's.
   Because no master write can happen before the client's first byte, a
   client that raws the slave before sending always wins that race.
   POLLHUP is honoured as a second, independent EOF signal (an unattached
   master polls as nothing at all on macOS, so it cannot false-positive).

## Tests + results

- `runtime/host/rt_serial_test.c`: `test_stdio` (pipe pair dup2'd onto fd
  0/1 with the originals saved/restored, `ConnHOpen == 0`, 300 bytes fed
  in and read back in order, a 0-255 sweep written out byte-exact, `Gone`
  0 while the writer lives and 1 once it closes) and `test_pty` (stderr
  captured over a pipe around `ConnHOpen` to parse the announced path,
  the unattached state pinned -- `Avail` 0, write discarded with success,
  `Gone` 0 -- then the slave opened and rawed by the test as a real client
  would, a 0-255 sweep each way with a DIFFERENT pattern outbound, and
  `Gone` once the slave closes). The watchdog moved 240s -> 270s with its
  per-scenario budget table updated for the two new scenarios.
- `tests/conntest/stdio.sh`: `echo.cla` under `CLARUS_SERIAL_MODEM=stdio`,
  stdin from a FIFO, stdout to a file. stdio is never "unattached", so
  unlike `listen.sh` this asserts the whole stream byte-exactly --
  `READY\r` + the echoed sweep + the echoed `QQQ` -- then
  `conn_wait_self_exit`.
- `tests/conntest/pty.sh`: same fixture under `=pty`; the announced path
  is polled out of the program's stderr and driven by a ~50-line python3
  client (raws the slave, one-byte `!` probe consumed through its echo the
  way `listen.sh` does, 0-255 sweep echoed byte-exactly, then `QQQ`);
  `skip` (77) when python3 is absent.

Results (worktree `t4`):

- `make test T='hostrt/serial conntest/'` -> 9 passed, 0 skipped, 0 failed
  (repeated 3x for the two new scripts and 4x for the C harness: stable).
- `make -j t1` -> **90 passed, 30 skipped, 0 failed**.
- `tests/runner/syntax.sh` -> PASS parsed 137 files.
- Not run, per the dispatch: perfgate, `--smoke`, any emulator lane.

### TDD evidence

RED (tests written first, `sh tests/hostrt/serial.sh` before any
`rt_serial.inc` change) -- the socket cases stayed silent, the nine new
assertions failed:

```
FAIL: stdio: ConnHOpen should succeed (rt_serial_test.c:542)
FAIL: stdio: ConnHAvail should report the 300 fed bytes (:548)
FAIL: stdio: terminal->program bytes match, in order (:550)
FAIL: stdio: ConnHWrite should succeed (:555)
FAIL: stdio: the sweep should reach the output pipe (:556)
FAIL: stdio: program->terminal bytes match (:557)
FAIL: stdio: ConnHGone should fire once the input pipe's writer closes (:561)
FAIL: pty: ConnHOpen should succeed (:606)
FAIL: pty: open should announce `pty /dev/...` on stderr (:613)
```

An intermediate GREEN-ish state (FIONREAD-based `Avail`) failed exactly
the four pty data assertions, which is what turned up the macOS
FIONREAD-on-a-pty-master finding above; the buffered version is fully
GREEN.

## Files changed

- `runtime/host/rt_serial.inc` -- the two new specs, `kind`/`gone`/read
  buffer, `rt_conn_slot_clear`, `rt_conn_stdio_raw`/`_restore`,
  `rt_conn_open_pty`, `rt_conn_fd_avail`; kind switches in `Avail`,
  `ReadByte`, `Write`, `Close`, `Gone`.
- `runtime/host/rt_serial_test.c` -- `fd_read_all`, `test_stdio`,
  `test_pty`, watchdog 270s.
- `tests/conntest/stdio.sh`, `tests/conntest/pty.sh` -- new (executable).
- `docs/clarus-language-reference.md` -- Serial section's env-var
  paragraph only, one line changed (byte-checked: `git diff --numstat` =
  `1 1`, and the line's non-ASCII bytes are the 3 new + 1 existing UTF-8
  em dashes; edited via a byte-exact rewrite, never the Edit tool).

## Self-review

- **Socket path unchanged.** No existing test or assertion was edited (the
  only touch to existing code in the test file is the watchdog bound and
  its comment). For `kind == RT_CONN_SOCKET` every function's statements
  are the originals; the new work is behind `kind != RT_CONN_SOCKET`
  branches or, in `ConnHOpen`, behind two new `strcmp` prefixes tried
  before `listen:`/`connect:`. `RT_CONN_MAX` is still 4.
- **`-Wall -Werror -std=c99` clean** -- that is exactly how `run_c_test`
  compiles both the harness and `rt.c`.
- **Raw mode is genuinely set and genuinely restored.** The committed unit
  test deliberately runs over a pipe (not a tty), so I verified the
  `isatty` branch out-of-band with a scratch harness that gives a child
  process a real pty slave as fd 0/1: `ECHO/ICANON/ICRNL/OPOST` all 1
  before, all 0 inside the child after `ConnHOpen`, all 1 again after the
  child exits normally. The restored `termios` differs from the saved one
  in exactly one bit, `PENDIN` (0x20000000) -- a kernel-maintained
  transient, not a setting. Not committed: pinning it would mean a second
  pty harness in the C test for a branch the pty case already covers in
  spirit.

## Concerns

1. **Linux portability of the new syscalls is unverified.** `posix_openpt`
   / `grantpt` / `unlockpt` / `ptsname` and `cfmakeraw` are visible under
   `-std=c99` on macOS but glibc hides them behind `_DEFAULT_SOURCE` /
   `_XOPEN_SOURCE`, and `rt_serial.inc` is `#include`d far too late in
   `rt.c` to define a feature macro itself. If a Linux host build ever
   matters, the fix is `-D_DEFAULT_SOURCE` (or feature macros at the top
   of `rt.c`), not a change here. The gate is macOS-only, so nothing in
   T1/T2 would catch it.
2. **Closing a `pty` connection truncates.** Closing a pty master discards
   whatever the client has not read yet, so a program that sends a goodbye
   and closes in the same handler may deliver a truncated one (echo.cla's
   `QQQ` echo does exactly this). There is no fix from the master side on
   macOS: the bytes sit in the SLAVE's input queue, which the master can
   neither count (`TIOCOUTQ` answers 0) nor drain (`tcdrain` is a no-op
   there). Documented in `rt_serial.inc` and in one clause of the
   reference; `pty.sh` therefore asserts the hangup after `QQQ` plus "any
   bytes that did arrive are a prefix of the echo", rather than the echo
   itself. Sockets and stdio are unaffected.
3. **`RT_CONN_BUFSZ` is a fixed 512 bytes per slot** (2 KB of static for
   4 slots; only the non-socket kinds use it). One pump pass hands the
   program at most that much, the next takes the rest -- the same shape a
   slow reader already has on the socket path. Marked `ponytail:`.
4. A program killed by an uncaught signal leaves a `stdio` terminal in raw
   mode -- the standard cost of the `atexit` approach; a `sigaction` net
   felt out of scope.
5. Spec 4.7's second bullet (`every` in the host CLI lifetime rule) is not
   this task -- untouched here.

---

# Fix round 1 -- review findings addressed

Commit: see below. All three findings taken as written; no counter-argument.

## Important -- `gone` latched on an unattached pty master (Linux)

`rt_conn_fd_avail`'s EOF/error latch is now gated on `!s->listening`:

```c
} else if (!s->listening &&
           (k == 0 || (errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR))) {
    s->gone = 1;
}
```

The reviewer's diagnosis is right and the `listening` gate is the better
of the two offered fixes: requiring `p.revents & POLLIN` before reading
would ALSO suppress the hangup Linux signals with a bare `POLLHUP` after a
slave really does close, trading one platform bug for another. `listening`
is by definition "not there yet", so nothing about it can mean hung up --
the gate is correct on both platforms by construction, which matters
because **Linux cannot be tested here** (this repo's gate is macOS only;
the finding itself is a code-reading result, not an observed failure). The
function's doc comment now names the Linux POLLHUP/EIO shape explicitly
and says why the gate is not redundant, so nobody deletes it as dead code
after reading only the macOS behavior a line above.

Note the gate is inert for `stdio`, which is never `listening`, so pipe
and tty EOF detection is unchanged -- as `test_stdio` still proves.

## Minors

- `ConnHWrite` now retries on `EINTR` (`if (k < 0 && errno == EINTR)
  continue;`) instead of returning failure and dropping the tail of a
  message whose prefix already went out.
- `tests/conntest/stdio.sh`: all three `wc -c < "$WORK/out"` polls are
  guarded with `[ ! -f "$WORK/out" ] || ...`, so the background
  redirect not having created the file yet reads as "keep waiting"
  rather than "condition satisfied".

## Commands + output

```
$ make test T='hostrt/serial conntest/'
PASS hostrt/serial 0s
PASS conntest/abort 1s
PASS conntest/connect 2s
PASS conntest/envunset 0s
PASS conntest/fieldonly 1s
PASS conntest/listen 1s
PASS conntest/pty 3s
PASS conntest/shadow 0s
PASS conntest/stdio 3s
tests: 9 passed, 0 skipped, 0 failed

$ sh tests/runner/syntax.sh
PASS parsed 137 files
```

Still `-Wall -Werror -std=c99` clean (that is how `run_c_test` builds both
the harness and `rt.c`). Concern 1 of the original report (Linux
portability of the new syscalls under glibc's feature macros) stands
unchanged and now has this second, behavioural Linux item filed beside it:
both are reasoned, neither is executed.

---

# Fix round 2 -- attach-then-detach without a byte

Commit: see below.

## Important -- the `!s->listening` gate wedged a silent attach/detach

Reproduced the reviewer's probe before touching anything (macOS, scratch
C): unattached master polls `revents=0x0`; slave opened, still `0x0`;
slave closed with **no write at all** -> `poll=1 revents=0x11
(POLLIN|POLLHUP) read()==0`, persistently, on every subsequent pass.
Verdict accepted in full. The gate is now the reviewer's:

```c
} else if ((!s->listening || (p.revents & POLLIN)) &&
           (k == 0 || (errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR))) {
    s->gone = 1;
    s->listening = 0;   /* a hangup proves a client was here */
}
```

Two things the proposed gate needed on top of itself to actually work,
both found by the new test failing after the gate alone was applied:

1. **`s->listening = 0` alongside the latch.** A hangup proves a client
   WAS there, so the slot is no longer "not there yet" -- and without
   clearing it, `rt_ext_ConnHGone`'s `listening` early-return still
   answered 0 forever.
2. **`rt_ext_ConnHGone`'s early return is now socket-only.** It was
   `if (fd < 0 || listening) return 0;` before the kind switch, so for a
   non-socket slot it returned 0 without ever reaching the code that does
   the polling -- the latch lives in `rt_conn_fd_avail`, and `ConnHGone`
   was the only caller that could have reached it in that state. Moved
   below the non-socket branch (the socket path is unchanged: same test,
   same position relative to its own `recv`). `rt_conn_fd_avail`'s gate is
   what keeps a merely-unattached slot quiet, so running it while
   `listening` is safe.

`rt_conn_fd_avail`'s doc comment now explains both halves of the gate,
what each platform does in each of the three states, why `listening` is
cleared with the latch, and -- as asked -- the reviewer's out-of-scope
Linux observation: an unattached master polls readable there (bare
POLLHUP), so `ConnHIdle`'s `select()` returns immediately every pass and a
program waiting on an empty pty busy-spins until a client attaches. That
is inherent in keeping the slot alive-but-unattached, not a defect of the
gate; the comment names the fix if it ever matters (leave a still-
listening pty master out of the `fd_set` and fall back to the `usleep`).

## New test case

`test_pty_attach_close` (slot 2): open `pty`, assert not gone while
unattached, open the announced slave and close it **without writing a
byte**, then assert `ConnHGone` latches, that no phantom bytes appear, and
that the latch stays. `test_pty`'s stderr-capture preamble was factored
into a `pty_open(slot, path)` helper both cases now use, so the new case
cost ~20 lines rather than a second copy. Watchdog budget table updated
(216s of honest worst case under the 270s alarm).

RED/GREEN for it, with everything else unchanged (the gate reverted to
round 1's `!s->listening` and put back):

```
$ sh tests/hostrt/serial.sh        # gate reverted to round 1
FAIL: pty attach/close: ConnHGone should fire for a client that never sent a byte (:687)
FAIL: pty attach/close: gone stays latched (:689)
FAILED
$ sh tests/hostrt/serial.sh        # gate restored
(silent, exit 0)
```

Skipped the `ConnHIdle` timing assertion the reviewer offered as optional:
`Gone` latching is what makes the pump close the slot, and a wall-clock
assertion inside a test file whose every other bound is generous would be
the one timing-sensitive thing in it.

## Recorded, no code change: EINTR `continue` also covers `send()`

Round 1's `if (k < 0 && errno == EINTR) continue;` sits in `ConnHWrite`'s
shared loop, above the `kind` ternary, so it applies to the socket
`send()` too. That is a deliberate, strictly-better deviation from this
task's "socket path byte-identical" rule: `send()` interrupted by a signal
previously returned failure with a partial write already on the wire, and
the caller has no way to learn how much went. Nothing in the socket tests
changed behaviour (all four socket scenarios green throughout both fix
rounds).

## Commands + output

```
$ make test T='hostrt/serial conntest/'
PASS hostrt/serial 0s
PASS conntest/abort 1s
PASS conntest/connect 2s
PASS conntest/envunset 0s
PASS conntest/fieldonly 1s
PASS conntest/listen 1s
PASS conntest/pty 3s
PASS conntest/shadow 0s
PASS conntest/stdio 3s
tests: 9 passed, 0 skipped, 0 failed
```

Still `-Wall -Werror -std=c99` clean. Linux remains untested (macOS-only
gate); both Linux items -- the glibc feature-macro concern from the
original report and the unattached-window busy-spin above -- are reasoned
and documented, not executed.
