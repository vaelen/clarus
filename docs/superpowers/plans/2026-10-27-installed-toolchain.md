# Installed Toolchain Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make clarusc installable (`make install`) into `<prefix>/bin` + `<prefix>/share/clarus`, find that data directory on its own, build host executables itself (`clarusc build`), and add `check`/`build68k` commands.

**Architecture:** Four new host-only runtime routines (env read, build-time defaults, spawn, temp file) in `runtime/host/rt_ext_host.inc`, reached from clarusc through `external func` + `nat_` no-op fallbacks (the `MemProbe` pattern, `clarusc/main.cla:88`). The rtdir chain hooks into the one shared function `findRtDir` (`clarusc/drive.cla:619`) through a new front-end seam (`feRtDirFallback`/`feRtDirSearched`), implemented for the host in a new `clarusc/hostenv.cla` and for ClarusC.APPL in `clarusc/macgui.cla` with today's behaviour. `build` lives in a new `clarusc/hostbuild.cla`. `make install` compiles the bootstrap's own `build-run/clarusc-current.c` with the install's defines.

**Tech Stack:** Clarus (clarusc self-hosted), C99 host runtime, POSIX `posix_spawnp`/`mkstemps`, GNU Make, POSIX sh tests (`tests/lib.sh` vocabulary).

**Spec:** `docs/superpowers/specs/2026-10-27-installed-toolchain-design.md` — read it first; this plan does not repeat its rationale.

## Global Constraints

- Lookup order: `--rtdir` → upward search from cwd (`findRtDir`, unchanged) → `$CLARUS_DATADIR/runtime/clarus/` → built-in `CLARUS_DATADIR` define + `/runtime/clarus/`. A candidate counts only if its probe file reads. Empty define = no step 4.
- Build-time defines: `CLARUS_DATADIR` (default `"/usr/local/share/clarus"`), `CLARUS_CC` (default `"cc"`).
- `CC` env (non-empty) beats `CLARUS_CC`; `CFLAGS` env (if set, even empty) is split on spaces/tabs, else `-O1`.
- Never `system()`/`popen()`; argv exec only.
- Bare check prints, on stderr, before checking: `clarusc: checking only; use 'clarusc build' or 'clarusc build68k' to produce an executable`. Explicit `check` prints nothing extra.
- `emit68k` prints on stderr: `clarusc: 'emit68k' is deprecated; please use 'build68k'`, then behaves exactly as `build68k`.
- `-o` without a command does not build.
- ClarusC.APPL: behaviour unchanged (bytes may move). `tests/lib.sh` is FROZEN except for Task 3's `emit68k` → `build68k` rename, which Andrew explicitly authorized (2026-10-27).
- The `emit68k` rename covers invocations and user-visible text only. Internal identifiers (`emitMode68k`, `driveEmit68k`, `cg68*`), comments in `testdata/**/*.cla` fixtures, and historical docs (`docs/HISTORY.md`, `docs/superpowers/**` from before this phase) keep the old name.
- Host-only externs need `nat_` no-op/empty fallbacks so `tests/cg68k/selfemit.sh` (clarusc self-compiled on the 68k lane) stays green.
- Keep `App.startCLI` (`clarusc/main.cla:204`) lean: it has a 32 KB native per-function segment budget (selfemit's gate). New logic goes in functions in the new files.
- Implementation and review subagents: `model: opus`.

## Review Focus

1. A missed `emit68k` invocation would print the deprecation line into a test's stderr; a test that diffs stderr goes red, and an unrenamed one goes stale silently. → Task 3 Step 6's `grep` gate: no `emit68k` invocation remains outside `tests/claruscboot/commands.sh`.
2. Relative `--rtdir` / relative `-o` with `build`: cc runs in clarusc's cwd, so relative paths must resolve the same way as for `emit`. → Task 3 `build_relative` test.
3. A `CLARUS_DATADIR` with a trailing slash (`/usr/share/clarus/`) must work like one without. → Task 2 `env_trailing_slash` test.
4. `make install` run twice with a different `DATADIR` must rebuild the installed binary (the default is baked in). → Task 4 `reinstall_datadir` test.
5. The C compiler being killed or missing: clarusc must exit nonzero with a diagnostic, never 0. → Task 3 `build_cc_missing` test.

## Tracks and order

```
Task 1 (runtime routines) ──┬── Task 2 (rtdir chain)      ──┬── Task 4 (install) ──┐
                            └── Task 3 (commands + build) ──┘                      ├── Task 6 (snapshot + gates)
                                Task 5 (docs + hand-off) ── any time after 1 ──────┘
```

- Tasks 2 and 3 run in parallel, each in its own worktree. Both add one `include` line to `clarusc/main.cla` right after `include "bake.cla"` (line 39): Task 2 `include "hostenv.cla"`, Task 3 `include "hostbuild.cla"`. The integrator resolves that one-line conflict; nothing else overlaps (Task 2 owns `drive.cla`, `macgui.cla`, the Makefile's bootstrap rules, `scripts/clarus-run.sh`; Task 3 owns the rest of `main.cla`).
- Task 5 touches docs only, so it runs in parallel with 2–4.
- Task 6 is the serialization point (snapshot regen).

---

### Task 1: Host runtime routines

**Files:**
- Modify: `runtime/host/rt_ext_host.inc` (append a section)
- Create: `runtime/host/rt_hostcli_test.c`
- Create: `tests/hostrt/hostcli.sh`

**Interfaces — Produces** (C, all in `rt_ext_host.inc`; the Clarus declarations are written by Tasks 2/3):

| C                                                              | Clarus declaration                                        | Behaviour                                                                                                                                                                            |
|----------------------------------------------------------------|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `int32_t rt_ext_HostGetEnv(const uint8_t *name, rt_text *out)` | `external func HostGetEnv(name: string, out: text): bool` | 1 + value in `out` if set (even empty); 0 + `out` emptied if unset                                                                                                                   |
| `void rt_ext_HostDefaultDataDir(rt_text *out)`                 | `external func HostDefaultDataDir(out: text)`             | the `CLARUS_DATADIR` macro (default `"/usr/local/share/clarus"`)                                                                                                                     |
| `void rt_ext_HostDefaultCc(rt_text *out)`                      | `external func HostDefaultCc(out: text)`                  | the `CLARUS_CC` macro (default `"cc"`)                                                                                                                                               |
| `int32_t rt_ext_HostSpawn(rt_text *argv)`                      | `external func HostSpawn(argv: text): int`                | `argv` = args each terminated by a NUL byte; `posix_spawnp` + `waitpid`; returns exit status, 128+signal if signalled, -1 if it could not start (errno text via `rt_ext_SetLastErr`) |
| `int32_t rt_ext_HostMkTemp(rt_text *out)`                      | `external func HostMkTemp(out: text): bool`               | `mkstemps` on `$TMPDIR` (else `/tmp`) + `/clarusc-XXXXXX.c`; creates the file, closes the fd, path in `out`                                                                          |

Bool returns use the int32 0/1 convention of `rt_ext_FileReadTextInto`. Names are Pascal strings (`const uint8_t *`, length byte first) as elsewhere in the file. Guard each macro with `#ifndef`.

- [ ] **Step 1: Write the failing C test** `runtime/host/rt_hostcli_test.c` (shape of `rt_fileh_test.c`): `getenv_set` (setenv `X_T=abc` → 1, "abc"), `getenv_empty` (`X_T=` → 1, ""), `getenv_unset` → 0; `default_datadir` equals `"/usr/local/share/clarus"`; `default_cc` equals `"cc"`; `spawn_true` (`"true\0"`) → 0; `spawn_exit3` (`"sh\0-c\0exit 3\0"`) → 3; `spawn_space_arg` (`"sh\0-c\0test \"$1\" = 'a b'\0x\0a b\0"`) → 0; `spawn_missing` (`"/nonexistent/x\0"`) → -1 or 127 and never 0; `mktemp` → file exists, path ends `.c`, two calls differ.
- [ ] **Step 2:** `tests/hostrt/hostcli.sh`: `run_c_test "$HOSTRT/rt_hostcli_test.c" || die rt_hostcli_test`, plus a second compile with `-DCLARUS_DATADIR='"/opt/x"'` asserting the override (pass extra cflags the way `tests/hostrt/*.sh` siblings do; if `run_c_test` takes none, compile with `$CC` directly). Run `make test T=hostrt/hostcli` → FAIL (undefined symbols).
- [ ] **Step 3:** Implement the five routines.
- [ ] **Step 4:** `make test T=hostrt/` → all PASS.
- [ ] **Step 5:** Commit `feat(runtime): host spawn/env/tempfile routines for clarusc build`.

### Task 2: rtdir lookup chain

**Files:**
- Modify: `clarusc/drive.cla:619-639` (`findRtDir`), `:1489-1491`, `:1950-1952` (not-found aborts)
- Create: `clarusc/hostenv.cla`; Modify: `clarusc/main.cla` (one `include` line)
- Modify: `clarusc/macgui.cla` (seam implementations, near `feExpectedStamp` :227)
- Modify: `Makefile:37-43` (bootstrap compiles), `scripts/clarus-run.sh:32`
- Test: `tests/claruscboot/rtdir_chain.sh`

**Interfaces:**
- Consumes: `HostGetEnv`, `HostDefaultDataDir` (Task 1).
- Produces (seam, defined in BOTH `hostenv.cla` and `macgui.cla`):
  - `func feRtDirFallback(probeFile: string): string` — called by `findRtDir` instead of its final `return ""`. Host: steps 3–4 of the chain; returns the rtdir (ending `runtime/clarus/`) or `""`. macgui: returns `""`.
  - `func feRtDirSearched(): string` — the "searched ..." text for the not-found aborts. Host: `runtime/clarus/ from the working directory upward, $CLARUS_DATADIR (<value> | unset), <default> (or "no built-in default")`. macgui: today's `runtime/clarus/ from the working directory upward`.
  - Abort text becomes `"runtime module " + m + " not found (searched " + feRtDirSearched() + "); use --rtdir or set CLARUS_DATADIR"` on the no-`--rtdir` branch; the `--rtdir` branch is unchanged.
  - Declares the Task 1 externs used here, with `nat_` fallbacks (`nat_HostGetEnv` returns false; `nat_HostDefaultDataDir` leaves `out` empty).

Data-dir values strip one trailing `/` before appending `/runtime/clarus/`.

- [ ] **Step 1: Write the failing test** `tests/claruscboot/rtdir_chain.sh`. Setup: compile `$BR/clarusc-current.c` with `-DCLARUS_DATADIR='"'$WORK/dflt'"'` into `$WORK/cc-dflt`; make `$WORK/dflt` and `$WORK/envd` each a copy of `runtime/clarus` → `<d>/runtime/clarus`, `toolbox` → `<d>/toolbox`, plus `<d>/toolbox/mark_<d>.cla` defining `func markOk(): int { return 1 }`. A program `p_<d>.cla` with `include "toolbox/mark_<d>.cla"` and a `startCLI` that calls `markOk()`. Subcases (each runs `emit -o x.c` from `cd $WORK/proj`, which has no `runtime/` above it, under `env -u CLARUS_DATADIR` unless set):
  - `default_used`: `cc-dflt emit p_dflt.cla` → exit 0.
  - `env_beats_default`: `CLARUS_DATADIR=$WORK/envd cc-dflt emit p_envd.cla` → 0; and `p_dflt.cla` → nonzero (env won).
  - `env_trailing_slash`: `CLARUS_DATADIR=$WORK/envd/` → `p_envd.cla` 0.
  - `env_bogus_falls_through`: `CLARUS_DATADIR=$WORK/nope cc-dflt emit p_dflt.cla` → 0.
  - `repo_beats_env`: from `cd $ROOT`, `CLARUS_DATADIR=$WORK/envd $CLARUSC emit $WORK/p_envd.cla` → nonzero (the repo's runtime won, so the marker is not found).
  - `rtdir_beats_all`: `--rtdir $WORK/envd/runtime/clarus/` with `CLARUS_DATADIR=$WORK/dflt` → `p_envd.cla` 0.
  - `none_resolves`: `$CLARUSC emit` (the dev compiler, built with an empty default) on `p_dflt.cla` from `$WORK/proj` → nonzero, stderr contains `CLARUS_DATADIR` and `no built-in default`.
  - `check_unchanged`: bare check of a self-contained program from `$WORK/proj` with nothing resolvable → same exit code as `$CLARUSC_SNAPSHOT` gives.
- [ ] **Step 2:** `make test T=claruscboot/rtdir_chain` → FAIL.
- [ ] **Step 3:** Implement the seam in `drive.cla`, `hostenv.cla` and `macgui.cla`; add `include "hostenv.cla"` after `include "bake.cla"` in `main.cla`.
- [ ] **Step 4:** Makefile: add `unexport CLARUS_DATADIR` near the top, and `-DCLARUS_DATADIR='""'` to both the `clarusc-snapshot` and `clarusc-current` `$(CC)` lines. Add the same define to `scripts/clarus-run.sh`'s clarusc compile (line 32), and change that script's cache key so an old cached binary is rebuilt (e.g. bump its cache filename).
- [ ] **Step 5:** `make test T=claruscboot/rtdir_chain` → PASS; `scripts/test-task.sh` → green (selfemit included).
- [ ] **Step 6:** Commit `feat(clarusc): find the runtime via CLARUS_DATADIR and a built-in default`.

### Task 3: `check`, `build`, `build68k` commands

**Files:**
- Modify: `clarusc/main.cla` (dispatch :257-330, flag loop :334+, emit tail :732+, usage strings, the 9 `"clarusc emit68k: ..."` message prefixes → `clarusc build68k: ...`)
- Create: `clarusc/hostbuild.cla`; Modify: `clarusc/main.cla` (one `include` line)
- Modify (rename): `tests/lib.sh` (the `emit68k()` helper at line 63 becomes `build68k()`, calling `clarusc build68k`), every `tests/**/*.sh` that calls the helper or `clarusc emit68k` (~82 files), `scripts/build-68k.sh`, `scripts/build-clarusc-mac.sh`, and the other `scripts/*` that invoke it
- Test: `tests/claruscboot/commands.sh`

**Interfaces:**
- Consumes: `HostGetEnv`, `HostDefaultCc`, `HostSpawn`, `HostMkTemp` (Task 1); the `rtDir` global (`drive.cla:89`), which holds the resolved rtdir after `driveCompile`.
- Produces: `func cliBuildHost(cSrc: text, outPath: string, keepC: bool): int` in `hostbuild.cla`. It writes `cSrc` to a `HostMkTemp` path, runs `<cc> <cflags...> -I <rtDir>../host -o <outPath> <tmp> <rtDir>../host/rt.c`, deletes the temp file unless `keepC` (if kept, `log("clarusc build: kept " + path)`), and returns 0 or 1. On a nonzero status it logs `clarusc build: <cc> failed (status N)`, or `clarusc build: cannot run <cc>: <err>` if spawn returned -1. It also declares the Task 1 externs it uses (`nat_` fallbacks: `HostSpawn` → -1, `HostMkTemp` → false, `HostDefaultCc` → empty). If Task 2 already declared an extern, share one declaration; the integrator dedups.

The rename is mechanical: per CLAUDE.md it may go to a `haiku` subagent once the command exists. Tests that grep for a `clarusc emit68k:` message prefix are updated to the new prefix in the same pass. `scripts/clarus-run.sh` is Task 2's; it doesn't use `emit68k`.

Command dispatch (`args[0]`): `check` → checkMode with no info line; `build` → `buildMode` (implies the emit pipeline, accepts only `-o`, `--rtdir`, `--keep-c`, and requires `-o`); `build68k` → today's `emitMode68k`; `emit68k` → log the deprecation line, then `emitMode68k`; no command → checkMode plus the info line, logged after argument parsing and before `driveCompile`. Usage line: `usage: clarusc [check | build -o PROG | build68k -o APP.bin | emit -o OUT.c | appinfo | --bake-ir ... | --version] FILE...`. The existing `clarusc emit68k:`-prefixed error messages stay as they are (the later cleanup handles them).

- [ ] **Step 1: Write the failing test** `tests/claruscboot/commands.sh` (fixture `hello.cla`: `startCLI` that `alert("hi")`s; `bad.cla`: a type error). Every run passes `--rtdir "$RTDIR"`.
  - `bare_info`: `$CLARUSC hello.cla` → stderr has `checking only`; stdout and exit equal `$CLARUSC check hello.cla`'s.
  - `check_quiet`: `$CLARUSC check hello.cla` → empty stderr, exit 0.
  - `o_alone_checks`: `$CLARUSC -o x hello.cla` → no file `x` (exit as for a bad positional arg today).
  - `build68k_same_bytes`: `build68k -o a.bin examples/hello-mac.cla` and `emit68k -o b.bin` → `cmp` equal; the `emit68k` stderr has `'emit68k' is deprecated; please use 'build68k'`; `build68k` stderr does not.
  - `build_runs`: `build -o "$WORK/sp ace/hi" hello.cla` → exit 0; running it prints `hi`.
  - `build_relative`: from `cd $WORK`, `build -o rel/hi --rtdir <relative path to $RTDIR> hello.cla` → `rel/hi` runs.
  - `build_bad_no_cc`: `CC=$WORK/ccspy` (a script that touches `$WORK/called` and exits 0) building `bad.cla` → nonzero, `$WORK/called` absent, no output file.
  - `build_cc_argv`: `CC=$WORK/ccspy-log` (logs `"$@"` one per line, then `exec cc "$@"`) → log contains `-O1` and `-I` + `…/host`; with `CFLAGS="-O0 -g"` the log contains `-O0` and `-g` and not `-O1`.
  - `build_cc_missing`: `CC=/nonexistent/cc` → nonzero, stderr contains `clarusc build:`.
  - `build_cc_fails`: `CC=false` → nonzero, stderr contains `failed`.
  - `keep_c`: `build --keep-c` → stderr `kept <path>`, and that file exists.
  - `no_tmp_leak`: after `build_runs` with `TMPDIR=$WORK/tmp`, `$WORK/tmp` is empty.
- [ ] **Step 2:** `make test T=claruscboot/commands` → FAIL.
- [ ] **Step 3:** Implement `hostbuild.cla` and the dispatch. Add `include "hostbuild.cla"` after `include "bake.cla"`.
- [ ] **Step 4:** `make test T=claruscboot/commands` → PASS.
- [ ] **Step 5:** `make test T=cg68k/selfemit` → PASS (segment budget).
- [ ] **Step 6:** Commit `feat(clarusc): check/build/build68k commands; emit68k deprecated`.
- [ ] **Step 7:** Rename every invocation (Files list above), as a separate commit.
- [ ] **Step 8:** Gate: `grep -rn 'emit68k' tests scripts Makefile | grep -v '^tests/claruscboot/commands.sh'` prints only comment lines that describe history, and no invocation. `grep -rn 'clarusc emit68k' clarusc/*.cla` prints nothing outside the alias handling.
- [ ] **Step 9:** `scripts/test-task.sh` → green. Then `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/smoke_bounce` → PASS, which exercises the renamed `lib_mac.sh` path on a real boot.
- [ ] **Step 10:** Commit `test,scripts: use build68k instead of emit68k`.

### Task 4: `make install` / `make uninstall`

Starts after Tasks 2 and 3 are merged into the branch.

**Files:**
- Modify: `Makefile` (new variables and targets, appended; add `install uninstall` to `.PHONY`)
- Test: `tests/claruscboot/install.sh` (header `# timeout: 15m`)

**Interfaces:**
- Consumes: `build-run/clarusc-current.c` (the bootstrap's emission of the working tree), `CLARUS_DATADIR`/`CLARUS_CC` defines.
- Produces: variables `PREFIX ?= /usr/local`, `BINDIR ?= $(PREFIX)/bin`, `DATADIR ?= $(PREFIX)/share/clarus`, `DOCDIR ?= $(PREFIX)/share/doc/clarus`, `DESTDIR ?=`; targets `install-bin` (builds `$(BR)/clarusc-install`), `install`, `uninstall`.

Rebuild rule: `$(BR)/clarusc-install.cfg` holds `DATADIR=… CC=…`. It is rewritten only when its contents differ (write to a temp file, then `cmp -s || mv`), and `$(BR)/clarusc-install` depends on it plus `$(BR)/clarusc-current`. The install binary is `$(CC) -O1 -DCLARUS_DATADIR='"$(DATADIR)"' -DCLARUS_CC='"$(CC)"' -I runtime/host $(BR)/clarusc-current.c runtime/host/rt.c`. `install` depends on `install-bin` (so a later `sudo make install` copies without rebuilding when it's current), removes `$(DESTDIR)$(DATADIR)/runtime` and `/toolbox`, then copies the file set in the spec's Install section with `install -d` / `install -m 644` / `install -m 755`. `runtime/host/*_test.c` is excluded. `uninstall` removes `$(DESTDIR)$(BINDIR)/clarusc`, `$(DESTDIR)$(DATADIR)` and the three doc files, then `rmdir` on `$(DESTDIR)$(DOCDIR)` (ignoring failure).

- [ ] **Step 1: Write the failing test** `tests/claruscboot/install.sh`. Use `make -C "$ROOT" --no-print-directory`, with the bootstrap already built by the runner.
  - `install_tree`: `make install PREFIX=$WORK/inst` → `bin/clarusc` is executable; `share/clarus/runtime/clarus/core.cla`, `share/clarus/runtime/host/rt.c`, `share/clarus/toolbox/memory.cla` and `share/doc/clarus/clarus-language-reference.md` all exist; nothing matches `share/clarus/runtime/host/*_test.c`.
  - `installed_build`: from `cd $WORK/proj` under `env -u CLARUS_DATADIR`, `$WORK/inst/bin/clarusc build -o hi hi.cla` (with `include "toolbox/memory.cla"`) → runs and prints its line.
  - `installed_build68k`: same cwd, `build68k -o h.bin $ROOT/examples/hello-mac.cla` → exit 0; bytes 65–68 are `APPL`.
  - `env_override`: copy `share/clarus` to `$WORK/alt`, add a marker toolbox file; `CLARUS_DATADIR=$WORK/alt` build of a program that includes it → 0. Without the variable → nonzero.
  - `uninstall_clean`: `make uninstall PREFIX=$WORK/inst` → `find $WORK/inst -type f` prints nothing.
  - `destdir`: `make install DESTDIR=$WORK/root PREFIX=/usr` → `$WORK/root/usr/bin/clarusc` and `$WORK/root/usr/share/clarus/runtime/clarus/core.cla` exist, and `grep -c /usr/share/clarus $WORK/root/usr/bin/clarusc` ≥ 1.
  - `reinstall_datadir`: `make install PREFIX=$WORK/i2 DATADIR=$WORK/i2/data` → the binary contains `$WORK/i2/data` and not `$WORK/inst/share`.
- [ ] **Step 2:** `make test T=claruscboot/install` → FAIL.
- [ ] **Step 3:** Implement the Makefile targets.
- [ ] **Step 4:** `make test T=claruscboot/install` → PASS; `scripts/test-task.sh` → green.
- [ ] **Step 5:** Commit `feat(build): make install / uninstall`.

### Task 5: Docs and the m68k-bbs hand-off

Docs only; runs in parallel with Tasks 2–4. Command names and behaviour come from the Global Constraints.

**Files:**
- Modify: `README.md` (an "Installing" section: `make install` variables, the lookup order, `CC`/`CFLAGS`, the command table)
- Modify: `CLAUDE.md` ("Build and test": `make install`, the commands, the dev compilers having no built-in default, `CLARUS_DATADIR` being unexported by the Makefile)
- Modify: `docs/clarus-language-changelog.md` (a short "Tooling (not language)" note under the current version: new commands, `emit68k` deprecated)
- Modify (rename `emit68k` → `build68k` in current-usage text): `CLAUDE.md`, `README.md`, `docs/clarus-language-reference.md`, `docs/clarus-toolbox-cookbook.md`, and the live (non-history) parts of `docs/ROADMAP.md` and `docs/TODO.md`. Past-tense accounts of earlier phases keep the old name.
- Create: `docs/m68k-bbs-installed-toolchain.md`

The hand-off doc, addressed to the m68k-bbs agent, is self-contained. Cover:
- installing and upgrading Clarus;
- deleting `bin/` and `vendor/`;
- `scripts/build.sh` → `clarusc build68k -o build/X.bin X.cla` ×3 with no `--rtdir`;
- `scripts/test.sh` → `clarusc build -o "$D/prog" "$t"` with no `cc` line;
- the check command → `clarusc check bbs.cla`;
- the docs now living in `$(DOCDIR)` instead of copied into `docs/` (replace the copies with a pointer, or keep symlinks to the installed copies);
- the CLAUDE.md "Compiler" section rewrite (drop the pin-refresh recipe and the `--rtdir` rule);
- using `CLARUS_DATADIR` or `--rtdir` to try an uninstalled compiler tree.

Mention that `include "toolbox/..."` resolves against the installed `toolbox/`.

- [ ] **Step 1:** Write all four edits.
- [ ] **Step 2:** `make test T=runner/syntax` → PASS (sanity; no scripts changed).
- [ ] **Step 3:** Commit `docs: installed toolchain usage and m68k-bbs hand-off`.

### Task 6: Snapshot regeneration and gates (serialization point)

**Files:** `clarusc/clarusc.c`

- [ ] **Step 1:** `make test T=selfhost/fixedpoint`. It will fail `snapshot_fresh`; follow the regeneration recipe that failure message prints.
- [ ] **Step 2:** `scripts/test-task.sh --smoke` → green.
- [ ] **Step 3:** `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` → PASS (macgui.cla and drive.cla changed; standing rule).
- [ ] **Step 4:** `scripts/test-merge.sh` → every stage PASS.
- [ ] **Step 5:** End-to-end by hand: `make install PREFIX=$SCRATCH/inst`, then from `/tmp/x` (outside the repo) build the BBS: `$SCRATCH/inst/bin/clarusc build68k -o bbs.bin ~/repos/m68k-bbs/bbs.cla`. Expect exit 0. This validates the hand-off without changing m68k-bbs. Report the result.
- [ ] **Step 6:** Commit `chore: regenerate clarusc.c snapshot`.
