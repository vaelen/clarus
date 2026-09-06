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

