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

