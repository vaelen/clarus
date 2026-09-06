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

