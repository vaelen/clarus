### Task 14: Close-out — snapshot regen, T2, HISTORY, final review

- [ ] **Step 1:** Regenerate `clarusc/clarusc.c` per `tests/selfhost/fixedpoint.sh`'s `snapshot_fresh` recipe; `make test T=selfhost/`.
- [ ] **Step 2:** `scripts/test-merge.sh` (full T2, `CLARUS_MAC_TESTS=1`). Expected: every stage PASS.
- [ ] **Step 3:** `docs/HISTORY.md` entry (verbatim phase record incl. the probe findings and the rebless proof), `docs/ROADMAP.md` status, `CLAUDE.md` (suite counts already updated; add the `tests/atalk/` and `tests/atalkdrive/` groups and `CLARUS_ATALK_IFACE` to the test section; fix the stale `Retro68/InterfacesAndLibraries` header path to `toolchain/universal/CIncludes`), project memory note (`macplus2`, `ClarusSnow` process name, `disk1.dsk`).
- [ ] **Step 4:** Final whole-branch review (most capable model allowed), fix wave, T2 again, then report to Andrew — merge only on request.
