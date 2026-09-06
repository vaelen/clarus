### Task 13: Snow — interop probe, `adsp_listener.sh`, the `clarusc_bake` gate

The ONLY Snow boots of the phase. Andrew's Snow instance may be in use: check `pgrep -l ClarusSnow` first and coordinate.

**Files:** `tests/mactest/snow/adsp_listener.sh` (new), `tests/lib_snow.sh` (read; reuse its workspace-clone helper), Task 1's report (appendix).

- [ ] **Step 1: Interop probe** — boot Task 1's `register` on Snow (System 7, `.DSP` built in) and `lookup` on `macplus/`; then the reverse. Record the result as Task 1's P5 appendix.
- [ ] **Step 2: `adsp_listener.sh`** (`require_env CLARUS_SNOW_TESTS`): Snow runs `atalkchat` as server, `macplus/` as client (reuse Task 11's events files); same assertions as `adsp_68k.sh`. Run: `CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener`.
- [ ] **Step 3: The standing gate** — `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (~30 min): `ClarusC.APPL`'s default bake path with the new module list.
- [ ] **Step 4: Commit** — `test(snow): System 7 ADSP listener proof; clarusc_bake gate re-run`.

---

