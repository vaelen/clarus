# Task 12: Documentation moves — report

Branch `appletalk-t12`, worktree `/Users/andrew/repos/clarus-wt/t12`, cut from
wave-1 tip `9468eb7`. Two commits:

- `f529b6e` docs: AppleTalk phase documentation moves
- `e68df5f` test(bake): retire the C-lane rtbake SKIP branch

## What changed

### 1. `docs/TODO.md` (−118 lines, deletions only)

Three deletions, each verified against the code on this branch first:

- **The whole `## Serial / connection` section.** Both items under
  "Serial/connection phase (2026-08-16)" shipped this phase — host `stdio`/`pty`
  (Task 4: `runtime/host/rt_serial.inc` now parses `"stdio"`/`"pty"`, with
  `posix_openpt`/`grantpt`/`unlockpt` and the raw-mode `atexit` restore) and the
  host `every`-timer gap in the CLI pump (Task 5: `rt_ext_EveryDue` in
  `rt_ext_host.inc` + `lowSynthEveryPump`'s `clar_every_pump` in `lower.cla`,
  driven from `cpEmitMain`'s pump loop). Its one remaining entry, the
  binary-files **UI/non-UI connection-pump lane gap**, moved to FUTURE.md per
  the brief's ruling, which left the section (and its "Grouped … so they can be
  addressed together" preamble) with nothing in it.
- **The compiler-cleanup `--rtbake --lane c` item** and **its filesystem-api
  duplicate** ("Pre-existing: the C (host) lane's `--rtbake` cannot compile any
  `filehandle` program"), plus the now-empty `#### filesystem-api phase
  (2026-08-26)` sub-heading the duplicate sat under. Task 7 closed the gap with
  fix (b), at `clarusc/drive.cla:2368` — `if haveRtbake and not want68k and
  (usesConn or usesFileh or usesAtalk)` behind the `wantEmit` gate, after the
  check pass, calling the shared `driveRtbakeFallback` helper. (The brief asked
  whether to record the site correction in TODO; per its own answer, no — TODO
  is not a history. The correction is in the commit message instead.)

The `system.has*()` family under "Language: feature-support queries (after the
AppleTalk release)" is untouched — post-phase work, not debt this phase paid.

### 2. `docs/FUTURE.md` (+62 lines)

- **UI/non-UI connection-pump lane gap**, moved verbatim (byte-identical to the
  deleted TODO text — checked programmatically) under the existing `### binary-
  files phase (2026-08-22)` heading in "Runtime / Toolbox (if it ever bites)",
  so it keeps its provenance. A following paragraph records the move
  (2026-09-07, Andrew's ruling) *and the narrowing this phase bought it*:
  `irIsUiProgram()` is now `... or (irEveryCount > 0 and want68k)`
  (`clarusc/cprint.cla`), so `every` alone no longer classifies a HOST program
  as UI while the native lane still treats an every-only program as a real UI
  program — the cheap both-lanes shape is now "carry one `every` timer" instead
  of "carry a throwaway window". A shape needing neither still does not exist.
- **`### AppleTalk phase (2026-09-07)`** in the same section:
  - **Host-lane ADSP** (spec §11) — DDP type 7 dropped on the host; the whole
    `rtAdspDev*`/`rtLsnDev*` waist in `runtime/clarus/atalk_c.cla` returns
    `rtAtErrNoHost`; ~800–1500 lines of C in `rt_atalk.inc` (1252 lines today)
    mirroring the ATP layer; the lever is that `system.hasADSP()` could then be
    true on the host.
  - **A `service.call` retry knob** (spec §4.4) — 2 s × 3 and NBP 1 s × 3 are
    fixed; the shape if it bites is named arguments or a `svc.timeout(ms,
    retries)` setter, plumbing straight to `timeOutVal`@45 / `retryCount`@47 in
    `toolbox/appletalk.cla`'s `ATPParam` (offsets re-derived from the record,
    not copied).
- **`### AppleTalk phase (2026-09-07)`** under "## Tooling": `hostrt/atalk`
  costs ~23 s of T1 (three registers × a 3 s verify), with the ~3 s trim from
  Task 2's report named (`rt_atalk_test.c`'s `test_ext` register could reuse an
  earlier name) and why it was not taken.

### 3. `docs/superpowers/specs/2026-09-06-appletalk-design.md`

§6.1's NBP bullet gains one sentence recording the controller's 2026-09-07
ruling: `register` blocks for its 3 × 1 s verify lookup, for parity with the
Mac's own `registerName` verify at interval 8 / count 3.

### 4. `docs/ROADMAP.md`

"Next: language usability" item 1 now reads "**AppleTalk.** In progress on
branch `appletalk` (spec …, plan …). Not merged."

### 5. `docs/clarus-toolbox-cookbook.md` (+248 lines) — new §14

"Walkthrough: a driver Control call — NBP `lookupName`". Matches the existing
walkthrough style (§11–§13): open with what makes this family different, cite
the header line ranges, show `rust` fences, close with the footguns.

- Frames the family correctly: AppleTalk has **no traps of its own** — every
  routine is a Device Manager Control/Status call dispatched on `csCode`, so
  §1's bit-11 test has nothing per-routine to bite on; the only traps are
  `toolbox/devices.cla`'s `PBxxxSync` plus the catalog's one new
  `PBControlAsync` (`0xA404` = `0xA004` with async bit 10).
- The `NBPLookupParam` transcription: field names and order are **byte-identical
  to `toolbox/appletalk.cla`** (verified programmatically), annotated with
  offsets. Calls out the two non-obvious traps: the AppleTalk Device Manager
  prefix is `userData`@18 + `reqTID`@22, **not** `IOParam`'s `ioNamePtr`@18 +
  `ioVRefNum`@22 (same widths, so copying the File Manager prefix misplaces
  everything from 18 on silently), and `pad[8]` is load-bearing (Rule 1).
- The packed entity (`AppleTalk.h:305-310`'s own "they will not be the same"
  comment) built with `NewPtrClear` + `pokeb` via an `atPStr` helper.
- The sync form: open `.MPP` by name, fill a fresh extern-record local,
  `PBControlSync`, read `numGotten`. Includes the real `maxToGet`/`retBuffSize`
  arithmetic (8 × 104 = 832 fits 1024; 16 would answer `nbpBuffOvr`).
- The async form: why an extern record local cannot be used (no address-of
  outside a call site, and the driver owns the block until completion), so
  `NewPtrClear` + the catalog's offset constants; `PBControlAsync`; polling
  `ioResult`@16.
- The three catalog rules (≥52-byte PBs, re-zero before reuse, NBP registers the
  socket verbatim) plus the fourth probe fact (NTE+4..7 is the cheapest way to
  learn your own address).

**Proof, not "in spirit":** every `rust` fence past the record declaration was
extracted and run through `build-run/clarusc-current --rtdir runtime/clarus/` —
exit 0. The `include "toolbox/…"` lines resolve through the compiler's own
`toolbox/` fallback, so the example is copy-pasteable from outside the tree.

### 6. `tests/bake/full_corpus_emitui.sh` (−36 lines)

The "Known, PRE-EXISTING C-lane limitation" SKIP branch and its comment are
gone; the byte-compare is now a plain `if cmp … t_pass else t_fail fi` (the old
`continue`-then-fall-through shape had no second exit left).

## Gate

```
PASS reftest/checkclean 0s
PASS reftest/extract 0s
PASS reftest/required 2s
SKIP bake/full_corpus_emitui 0s      (ungated: CLARUS_BAKE_FULL unset)
PASS runner/selfcheck 1s
PASS runner/syntax 0s
PASS runner/timeout 5s
tests: 6 passed, 1 skipped, 0 failed
```

`sh -n` clean on the edited script (also covered by `runner/syntax`).

## CONCERN: `bake/full_corpus_emitui` is RED under `CLARUS_BAKE_FULL=1` — pre-existing, not mine

The opt-in sweep the brief asked me to run once fails:

```
FAIL every_cli.cla: --rtbake fork (62716 bytes) != from-source fork (62787 bytes):
     … differ: char 27838, line 394
```

The bake fork's literal pool is missing the user program's own `"tick "` literal
at its from-source index — from-source interns it as `clar_lit_120`, the bake
fork emits it as `clar_lit_129` and shifts the seven `clar_ui_fire_*` panic
literals down by one. So `emit --rtbake` and `emit` no longer agree on the
literal numbering for `testdata/emitui/every_cli.cla`, Task 5's new fixture.

**This is not caused by my edit.** Two proofs:

1. `every_cli.cla`'s forks contain **zero** occurrences of
   `clar_fn_rtConnOpen`/`clar_fn_rtFhOpen`, so the deleted SKIP branch could
   never have matched it — it fell through to the same `t_fail` before.
2. I restored the pre-edit script from `HEAD` and re-ran the sweep: **identical
   single failure**, same byte counts, same offset.

Two further findings from that run, both good news:

- `connpump_abort.cla` — the fixture that used to take the SKIP — now **PASSes**.
  That is the direct confirmation that Task 7 closed the gap and the branch was
  genuinely unreachable, exactly as the deleted comment predicted ("this check
  retires itself the moment the gap is closed").
- No other fixture regressed; the only SKIPs left are the intended
  "errors identically on both sides" ones.

The `every_cli.cla` bake-identity break is a **T2 blocker for the phase** and
belongs to whoever owns Task 5's lowering (`lowSynthEveryPump` registers the
`EveryDue` extern and mints `clar_every_pump` — the likely cause is that the
bake path interns the synthesized function's literals in a different order than
the from-source path). I did not file it in `docs/TODO.md`: it is a live
regression on an in-flight branch, not recorded debt.

## Other concerns / observations

1. **`peekw` ZERO-extends** (reference Ch13: "the 1- and 2-byte forms
   zero-extend"). The plan's Task 9 sketch and this task's brief both spell the
   async completion test as `ioResult`@16 `<= 0` — that is **wrong for the error
   case**: a negative OSErr read out of a word field comes back as e.g. 65497,
   not −39, so `<= 0` is false and the poll would spin forever on a failed
   async call. The cookbook example therefore uses `!= 1` (1 = `ioInProgress`)
   for "done" and a documented `atOSErr` sign-correction helper for the value,
   modelled on `runtime/clarus/native.cla`'s `nat_UiScreenBits`
   (`if rb >= 32768 { rb = rb - 65536 }`). **Task 9 should adopt the same
   correction** in `rtAtDevLookupDone`/`rtAdspDev*`.
2. **Reference proofread: no outright contradictions found**, so no edits to
   `docs/clarus-language-reference.md`. Two things I checked and deliberately
   left alone:
   - The 8-connection cap (Ch3 line 174, Connections line 1356) is ahead of the
     code: `runtime/clarus/conn.cla`'s `rtConnMax` is still 4 at this tip. Plan
     line 478 puts the 4 → 8 growth in Task 9, so the reference is
     correct-at-merge — the ordinary reference-first convention, not a bug.
   - The host CLI lifetime sentence (Serial section) enumerates connections,
     pending events and `every` timers. It matches `cpEmitMain`'s actual
     `pumpCond` (`clar_fn_rtConnAlive() || 1`) exactly, but neither mentions a
     serving `service` or a `listener`: a host program whose only liveness
     source is `svc.serve(...)` emits **no pump loop at all** and exits as soon
     as `App.startCLI` returns. That may be intended (host ADSP is out of scope)
     or may be a real hole for host services over ATP, which the host lane DOES
     implement. Flagging it for Task 8/9 rather than editing prose over it.
3. The FUTURE ADSP entry says the native lane is where ADSP is implemented. At
   this tip `runtime/clarus/atalk_68k.cla` is still all stubs (Task 9 replaces
   the bodies), so the sentence is written to be true at merge, not at this tip.

---

# Fix round 1 (review: Needs fixes) — commit `65ac054`

All eight items taken. `docs: Task 12 review fix round 1`.

## Important

1. **Spec self-contradiction** (`docs/superpowers/specs/2026-09-06-appletalk-design.md:366`).
   The bullet now reads "Non-blocking throughout except `register`, `call` and
   `zones`, which loop on `select` under their own deadline (`register` for the
   verify lookup above)." Rewrapped the following sentence so the paragraph does
   not carry a short line.
2. **`interval` units** (`docs/clarus-toolbox-cookbook.md`). The comment claimed
   "8 ticks between retries"; `interval` is in **8-tick units** — 8 ≈ 1 s — per
   `toolbox/appletalk.cla:73-74` ("a lookup costs about `count x interval x 8`
   ticks"), `runtime/clarus/atalk_68k.cla:36` ("interval 8 (1 s)"), and the
   section's own 3.2 s arithmetic. Fixed in the sync example
   (`// retry interval in 8-TICK units: 8 ≈ 1 s`) **and** in the async example's
   `pokeb(pb + nbpInterval, 8)`, which had the same latent ambiguity.
3. **Bogus §11 quotation.** The phrase "one record per payload shape" does not
   appear in §11 (`:806-811`, which is about `IOParam` *reusing* one layout for
   many traps — the near-opposite). The passage now says the rule plainly and
   attributes it correctly: the catalog states it in its own "Parameter blocks"
   note, with `toolbox/files.cla` (§11) as the precedent that note names.
4. **Sync-example leaks.** `lookupType` now takes `buf: ptr` from the caller
   (matching `lookupBegin`, and fixing the real bug that it returned a tuple
   count for a buffer the caller could never see). `DisposePtr(nm)` fires
   immediately after `PBOpenSync`, `DisposePtr(entity)` immediately after
   `PBControlSync` — both after the synchronous call that consumes them, so
   every return path is clean *including* the early `return err`, which now sits
   after `nm`'s dispose and before `entity` is ever allocated. A header comment
   states the caller's contract (≥1024 bytes, must outlive the call).
5. **Stale TODO pointers.** `examples/serialecho.cla:18` and
   `examples/pagefile.cla:46` now cite `docs/FUTURE.md`, each noting the
   2026-09-07 move. Both files are pure ASCII (checked before editing); both
   comment blocks were rewrapped to the files' own ~72-column style rather than
   left with an over-long line.

## Minors

- **(a)** The `atOSErr` comment had lost its path: `"…the same correction 's own
  // nat_UiScreenBits…"`. Cause found — the previous commit's fix ran through a
  double-quoted shell string containing a backtick-quoted path, so
  `` `runtime/clarus/native.cla` `` was command-substituted away (that also
  explains the stray "permission denied" line in that run). Restored, and every
  edit in this round went through a byte-safe Python script with no shell
  interpolation.
- **(b)** FUTURE's ADSP entry now says every `rtAdspDev*`/`rtLsnDev*` entry point
  "is a stub reporting 'unavailable' — `rtAtErrNoHost` / 0 / false, per its own
  header note", instead of claiming the whole waist returns `rtAtErrNoHost`.
- **(c)** FUTURE's T1-cost entry now says **~24 s** (matching
  `rt_atalk_test.c` `main`'s own watchdog comment, which spells out the same
  budget) and names the only real lever: drop one of the three registers. The
  old "reuse a name an earlier subtest already registered" was wrong twice —
  re-registering a live name answers `nbpDuplicate`, and `test_ext` already
  re-registers the name `test_nbp` removed (its own comment says so).

## Verification

```
PASS reftest/checkclean 1s
PASS reftest/extract 0s
PASS reftest/required 1s
SKIP bake/full_corpus_emitui 0s      (ungated)
PASS runner/selfcheck 1s
PASS runner/syntax 1s
PASS runner/timeout 5s
tests: 6 passed, 1 skipped, 0 failed
```

- Cookbook fences re-extracted and re-checked: `build-run/clarusc-current
  <extracted>.cla --rtdir runtime/clarus/` from the scratchpad (outside the
  tree) → exit 0, so the rewritten `lookupType` and the `DisposePtr` calls are
  real, not plausible.
- Line-granular diff audit against `HEAD`: changes confined to
  `docs/FUTURE.md` (2 hunks), `docs/clarus-toolbox-cookbook.md` (the §14 hunks
  only), the spec (1 hunk), and the two examples (1 hunk each). All files still
  decode as UTF-8; the two `.cla` files are pure ASCII, before and after.

## Unchanged concerns from the first report

The `CLARUS_BAKE_FULL=1` sweep's `FAIL every_cli.cla` (bake vs from-source
literal-pool numbering) is still open and still not mine — proven pre-existing
twice over in the first report. `peekw`'s zero-extension still means Task 9
should not use the plan's `ioResult <= 0` completion test.
