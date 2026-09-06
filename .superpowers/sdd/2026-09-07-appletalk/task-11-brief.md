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

