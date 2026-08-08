# Mac-Resident clarusc Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clarusc.APPL — clarusc itself running natively on System 6 in Mini vMac as a one-shot GUI compiler that turns a `.cla` file on disk into a double-clickable APPL whose resource fork byte-matches host `emit68k` output.

**Architecture:** Fix the two cg68k gaps blocking clarusc's own self-emit; extract the compile pipeline from `main.cla`'s inline `startCLI` into a shared `drive.cla`; add named-resource support + a general `--bake FILE` flag (type `'CLFS'`, name = path); add the minimal resource file surface (`file.readResource`/`file.writeRes`); build a `macgui.cla` front end (log window + File menu + askOpen). Design spec: `docs/superpowers/specs/2026-08-08-mac-resident-clarusc-design.md` (read it first — it is the contract, including the 2026-08-08 recon amendments).

**Tech Stack:** Clarus (clarusc + runtime), Go test harness (`internal/mactest`, `internal/selfhost`), hfsutils (`toolchain/bin/h*`), LaunchAPPL + Mini vMac.

## Global Constraints

- Branch `mac-resident-clarusc`; merge to main only on Andrew's request.
- After every task: `scripts/test-task.sh --smoke` (foreground, never background). T1 excludes `internal/selfhost`, so mid-phase snapshot drift does NOT fail T1; the snapshot is regenerated ONCE, in the final task, then `scripts/test-merge.sh` runs.
- `.cla` files are ASCII-only. EXCEPTION: `clarusc/lex.cla` contains raw MacRoman bytes — NEVER use the Edit/Write tools on it; edit with `LC_ALL=C sed` and verify with a byte-level diff (`cmp`/`xxd`), per the standing repo rule.
- The 4 frozen UI scenarios' trace/framebuffer goldens (`testdata/ui`, `testdata/uisnaps`) must stay byte-identical all phase (behavior-unchanged gate). Never run `CLARUS_MAC_BLESS=1`.
- `internal/cg68k` instruction goldens MAY change only in Tasks 2–3 (the codegen-affecting tasks); regenerate via that suite's bless env var and eyeball the diff in the task report.
- No-flag no-op invariant: without `--bake`, and for compositions that don't use the new surface, emitted output is byte-identical to pre-task output (same discipline as `--testapi`/`--nopeep`).
- Conservative-subset guard: `main.cla` + its includes (the snapshot composition) must never contain `file.readResource`/`file.writeRes` tokens. Only `macgui.cla` may use them.
- New extern trap declarations follow the decode-the-inline-words rule: verify every trap word + register convention against `Retro68/InterfacesAndLibraries` (CIncludes pragmas + AIncludes OPWORDs), cite both in the catalog comment (see `toolbox/files.cla` header for the template). Retro68's multiversal yaml alone is untrusted.
- Commits end with:
  `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`

## Verified codebase facts (for implementers with zero context)

- `clarusc/main.cla`: include block at `:21-37` (lib, tok, lex, ast, parse, types, check, ir, lower, shake, asm68k, peep68k, app68k, res68k, cprint, cg68k, uiblob). The ENTIRE pipeline is inline in `on App.startCLI(args: list of string) {` at `:337-1233` — there are no orchestration funcs. Phase ranges: arg parsing `:390-549`; Phase A expand/lex/parse `:551-~600`; early splice+hoist `:~600-752`; `checkProgram` `:753-782`; appinfo block `:783-814`; runtime-manifest splice `:820-~1160`; second check `:1170`, `lowerProgram` `:1182`, diag gate `:1186-1194`; emit fork `:1196-1229` (`emitMode` → `shakeProgram(); emitProgram(); file.writeText`; `emitMode68k` → `cg68AddRoots(); cg68SynthCbGlue(); shakeProgram(); cg68Program(outPath, listingFlag, segLimitFlag)`). `--events` read at `:517-531`, bytes assigned to cg68k global `cgEventsBytes` at `:1216-1223`. File-scope helper funcs: `dirOf:89`, `baseNameNoExt:109`, `joinPath:131`, `normalizePath:144`, `findRtDir:196`, `lastDecl:221`, `expand:236`, `hoistDedups:317`.
- `clarusc/cg68k.cla`: `const cgBigTmpSlots: int = 4` at `:540`, `cgBigTmpSize = 512` at `:541`, rationale comment `:525-539`; allocator `cgAllocBigTmpOff` `:2558-2571` (per-STATEMENT bump, reset with `cgStmtTmpNext`; "too many str/rec temps" error at `:2565-2568`); slot base offsets built in a `while i < cgBigTmpSlots` loop at `:3414`. Arg-push gate `cgIsAddressableArgShape(a, tk)` `:6905-6917` (accepts EVarRef/EFieldRef/EIndexRef, EStrConst for KStr, EIntr named `ui_value_at_ptr`); `cgPushArgMaterialized` `:6948-6970` handles ENewRec (`cgRecordCtorAt`), ECallFn (`cgMaterializeCallResult`, A1-stash, depth-guarded `cgMaterializeDepth` `:588-600`), EIntr `str_coerce` (`cgMaterializeStrCoerce`); everything else hard-errors at `:6968` ("unaddressable, unmaterializable KStr/KRec argument"). The open gap = any OTHER `EIntr` producing KStr/KRec as a bare arg — notably `str_concat`.
- `clarusc/lex.cla:614-622`: the approved hand-hoist (local `unexpMsg` binds a concat before `emitDiag`) with a comment naming this phase. Revert = pass the concat directly again (via sed; MacRoman file).
- `clarusc/lower.cla`: arg lowering in `lowArgs:844` (intrinsics/builtins) and `lowCallArgs:881` (user funcs; also xrec-decay + TyCallback arms); `lowCoerceStr:1872` produces the `str_coerce` EIntr. Temp-binding idiom: `lowNewStoreTemp():1951` (`__storeN`) + `lowAddLocal` + `newIRVarRef` + `newIRAssign` — see uses at `:2299`, `:2457`; ARC caveat comment `:2430-2456`.
- `clarusc/app68k.cla`: `app68BuildResourceFork(resTypes: list of string, resIds: list of int, resDatas: list of text): text` at `:333` — generic (type,id,data) triples, groups+sorts, **emits NO name list (all resources unnamed today)**. `app68BuildHeader(appName, creator, rsrcLen)` `:180` (data-fork length 0 at `:196`). `app68Build(...)` `:491` appends `extraTypes/extraIds/extraDatas` (`:520-526`) then fork (`:528`) + header (`:530`) + 128-pad. Extras are assembled by `cg68ResourceParitySet` (`cg68k.cla:9272`) and flow through `cg68WriteImage` (`cg68k.cla:9387`, `app68Build` call `:9405`).
- Directory listing: NONE exists anywhere (language, runtime, clarusc, Go rt). All file access is explicit-path. Surface: `file.readText(path, t)`, `file.writeText(path, t, type, creator)`, `file.save/load`, `file_name` basename intrinsic.
- `internal/mactest`: `RunMac(t, bin, timeout)` at `mac_test.go:121` (LaunchAPPL `-e minivmac`, output split by `parseCapture` `mac_test.go:96` on `##CLARUS-EXIT## ` / `##CLARUS-LOG##`); `buildNative68k` `native_test.go:183`; `buildNative68kUI(t, name, eventsRel, claRel...)` `native_test.go:207`; `checkUIGoldens` `ui_test.go:105`. Resource-fork parsers: `resparParseFork(t, fork)` `resparity_test.go:51` (+ `resparBuildAndParse:88` slices `img[128:]` per the MacBinary header at `h[87:91]`), and independently `parseResourceFork` in `internal/cg68k/image_test.go`.
- Files reach the emulator disk ONLY by the booted app writing them (`testdata/ui/texteditor_opendoc_setup.cla` writes `Report.txt` at launch). LaunchAPPL builds its own temp boot disk in cwd and deletes it. hfsutils (`hformat`/`hcopy`/`hmount`…) live in `toolchain/bin`, used today only by the retired Retro68 lane (`scripts/build-mac.sh`, `appres_test.go`).
- Native text building: `natFileReadText` (`runtime/clarus/native.cla:728`) is the canonical bytes→text idiom: FSRead into a `NatNewPtr` bounce buffer, `rtTextGrow(out, n)` → re-derive `TextHandleDeref(rt.h)` → `TextBlockMoveData(src, mp+off, got)` → `rt.len = total` (`:779-797`; re-derive-after-grow is mandatory, comment `:775-778`). There is NO ptr→str-return primitive (see `natFileName:811`'s header comment for why).
- `askOpen(path: string, types: string): bool` (declared `check.cla:1208`, lowered `lower.cla:969`) fills a caller-owned Str255 with a **bare Standard File name**; native reads then use `ioVRefNum = 0` (default vol/dir) — `native.cla:742`. Scripted answers: `answer-open <path>` (`uiscript.cla:1337-1341` → `rtUiAnswerPushPath:120`), consumed by `rtUiAskOpen` (`uidialogs.cla:845`), which traces `T ASKOPEN <path>`. Queue answers BEFORE the verb that opens the dialog (see `testdata/ui/texteditor.events`).
- Snapshot regen recipe (printed by `internal/selfhost/fixedpoint_test.go:125-136`):
  ```sh
  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
  ```
  The snapshot emit composes `clarusc/main.cla` ALONE (its include block pulls the rest) — `drive.cla` must be added to that include block, and `macgui.cla` must NOT be.
- Host clarusc bootstrap for ad-hoc use:
  ```sh
  cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
  ```
- `scripts/size-68k.sh` exists (peephole Task 1): per-target `SIZE name bytes segments` lines; its clarusc line was expected to fail pre-fix.
- Emulator wall-clock: the lexer-only bench ran ~15.8k ticks (~264 emulated seconds); a full compile is MINUTES. Give T2 boots generous timeouts (≥15 min) and run them foreground.
- **Snow facts (2026-08-09 boot test; acceptance emulator for Tasks 4/10/11/12):** launch `./snow/Snow ./snow/<workspace>.snoww` (GUI app, no headless mode; runs until quit — background it). Workspace JSON: `snow/Clarus.snoww` (clone of `MacII.snoww`; `scsi_targets[0].Disk` names the device image, paths relative to the workspace file; `pram_path` cloned too; `init_args.start_fastforward` exists). Boot to Finder ≈45s. Disk access from the host, ONLY while Snow is not running: `toolchain/bin/hmount snow/<img>` (auto-selects HFS partition 1 of the full-device image), `hcopy -m` both directions (forks preserved), `hcopy -t` for text, `humount`. Native `log()`/trace output = plain file `out` next to the app, extractable the same way. System 7.1 menus are NOT sticky: menu interaction needs press-drag-release (a `drag.swift` helper exists in the session scratchpad; copy it into the repo if a task needs it). Window geometry via `osascript ... process "Snow" ... window 1`; Mac framebuffer origin ≈ window +60,+113 at scale ≈1.375 (window 1000×782). `TeachText`/`Read Me` live on the image — don't disturb the System Folder. Keep `snow/hdd0.img` and `snow/MacII.snoww` pristine; work only on copies.

---

### Task 1: Memory + size baseline (measurement only, no code)

> **OUTCOME (2026-08-09, task complete — do not re-dispatch):** measured
> 39.8MB live high-water for tickprobe+UI-splice (report in the phase
> workspace). Resolution: acceptance environment moved to the Snow
> emulator (Mac II, 128MB, System 7.1) — see the spec's Goal/§7 as
> amended; memory is GO there. First Snow boot also passed (Bounce +
> TickProbe correct; `rtUiSys7` branch live for the first time) and
> found the §7b Quit-AE gap (new Task 12). Tasks 4, 10, 11 below carry
> Snow-specific amendments.

**Files:**
- Create: `.superpowers/sdd/2026-08-08-mac-resident-clarusc/task-1-report.md` (numbers + go/no-go)

**Interfaces:**
- Consumes: committed snapshot bootstrap (recipe above).
- Produces: measured heap high-water + emitted-size numbers later tasks cite; the spec §7 go/no-go call.

- [ ] **Step 1: Bootstrap host clarusc**

Run: `cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c`
Expected: builds clean.

- [ ] **Step 2: Measure host peak RSS compiling the acceptance app (UI splice included)**

Run: `/usr/bin/time -l build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/tickprobe.bin testdata/cg68k/tickprobe.cla 2>&1 | grep -E "maximum resident|peak"`
Expected: a peak-RSS number. Record it. Run 3×, confirm stable.

- [ ] **Step 3: Estimate the Mac budget**

Host is 64-bit; the Mac arena is 32-bit — pointers and ints halve, so estimate Mac-side heap ≈ 35–55% of host RSS (state the assumption, don't hide it). Budget: 4096KB − ~300KB (System 6) − ClarusC.APPL's own loaded CODE (unknown until Task 3; carry as a variable). Write the arithmetic in the report.

- [ ] **Step 4: Go/no-go**

If the estimate exceeds the budget with no headroom, STOP and escalate to Andrew with the numbers (spec §7: re-scope rather than discover it in the emulator). Otherwise record GO.

- [ ] **Step 5: Commit the report**

```bash
git add .superpowers/sdd/2026-08-08-mac-resident-clarusc/task-1-report.md
git commit -m "chore(macresident): task 1 -- memory/size baseline"
```

---

### Task 2: cgPushArgs KStr/KRec materialization (the real fix for the lex.cla gap)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgPushArgMaterialized` region, `:6905-6970`) and/or `clarusc/lower.cla` (`lowArgs:844` / `lowCallArgs:881`)
- Modify: `clarusc/lex.cla:614-622` (revert the hand-hoist — **sed only**, MacRoman file)
- Create: `testdata/run/argmat_intr.cla` (+ expected-output golden per that suite's convention)
- Modify: `internal/cg68k` goldens (regen, reviewed)

**Interfaces:**
- Consumes: `cgMaterializeCallResult` (A1-stash convention), `cgAllocBigTmpOff`, or `lowNewStoreTemp()`+`lowAddLocal`+`newIRAssign`.
- Produces: any `EIntr`-produced KStr/KRec expression is legal as a direct call argument, on both emit lanes. Later tasks (3, 6) assume clarusc's own `parseErrorf` shapes compile.

- [ ] **Step 1: Read the two candidate sites, pick the smaller fix**

Read `cg68k.cla:6905-6990` and `lower.cla:2430-2470`. Primary route (prefer if it holds up): extend `cgPushArgMaterialized` with a generic `EIntr` arm — at cg level a KStr/KRec-producing intrinsic is emitted as a runtime call, so the ECallFn materialization path (`cgMaterializeCallResult`) is likely reusable nearly verbatim; check how `cgEmitExpr`'s EIntr arm stages results. Alternate route (if the EIntr result convention diverges intrinsic-by-intrinsic): lower-side hoist — in `lowArgs`/`lowCallArgs`, when an arg's IR is KStr/KRec and its expr kind is not one `cgIsAddressableArgShape` accepts, bind it via the `lowNewStoreTemp()` idiom (produces an EVarRef, which the gate accepts). Record the choice + why in the task report.

- [ ] **Step 2: Write the failing fixture**

```
// testdata/run/argmat_intr.cla -- freshly-produced str/rec values as
// direct call args (the cgPushArgs gap, peephole68k Task 1/2).
func takes(s: string): int {
    return s.length
}
func two(a: string, b: string): int {
    return a.length + b.length
}
on App.startCLI(args: list of string) {
    var n: int
    var parts: list of string
    parts.add("xy")
    n = takes("a" + "bc")                 // str_concat as arg
    n = n + takes(parts[0])               // container get as arg
    n = n + two("p" + "q", "r" + "st")    // two hoists, one call
    log(numToStr(n))
    quit 0
}
```
Adjust surface details (e.g. `.length`, `numToStr`) against `testdata/run/` neighbors before trusting; the INTENT (concat-as-arg, element-as-arg, two-in-one-call) is the contract. Expected output: `10`.

- [ ] **Step 3: Verify it fails on emit68k today**

Run: `build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/am.bin testdata/run/argmat_intr.cla`
Expected: FAIL with "unaddressable, unmaterializable KStr/KRec argument". (Host `emit` lane may already pass — that's fine, the gap is 68k-only.)

- [ ] **Step 4: Implement the fix; verify the fixture emits and the run suite passes it**

Run: the same emit68k command → succeeds; then whatever host-run harness `testdata/run/` uses (find the Go test that walks it, likely `internal/` run-suite) → `10`.

- [ ] **Step 5: Revert the lex.cla hand-hoist via sed**

Restore passing the concatenation directly to `emitDiag` and delete the 4-line gap comment (`lex.cla:616-619` region). Verify with `git diff clarusc/lex.cla | cat` and `grep -c "unexpMsg" clarusc/lex.cla` (should drop), and confirm non-ASCII bytes elsewhere are untouched: `git diff --stat` should show only intended hunks.

- [ ] **Step 6: Regenerate cg68k goldens, review the diff**

Run: the `internal/cg68k` golden suite's bless flow (find its env var in that package; peephole used `CLARUS_CG68K_BLESS`).
Expected: diffs only in materialization sites; paste a representative hunk into the task report.

- [ ] **Step 7: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): materialize EIntr KStr/KRec call args in cg68k; revert lex.cla hoist"
```

---

### Task 3: Self-emit — clarusc emit68k's clarusc (cgBigTmpSlots only if still needed)

**Files:**
- Modify: `clarusc/cg68k.cla:525-541,2558-2571,3414` (only if the ceiling still fires post-Task-2)
- Create: `.superpowers/sdd/2026-08-08-mac-resident-clarusc/task-3-report.md`

**Interfaces:**
- Consumes: Task 2's materialization.
- Produces: `clarusc emit68k ... clarusc/main.cla` succeeds; recorded size/segment baseline for the Mac binary; the big-temp pool has no ceiling clarusc itself hits.

- [ ] **Step 1: Attempt self-emit**

Run: `build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/clarusc68k.bin clarusc/main.cla`
Expected: either success (skip to Step 3) or "too many str/rec temps ... bump cgBigTmpSlots".

- [ ] **Step 2 (conditional): Remove the ceiling properly**

Preferred: size the pool per-function from the measure pass — cg68k already runs a throwaway measure pass (`cg68Measure`, see `cgReserveUiPoolLabels`'s doc comment); track the max per-statement big-temp count per function there and allocate exactly that many slots in the frame (loop at `:3414` becomes per-function count). Fallback (if measure-pass plumbing is disproportionate): bump the const with a comment quoting the actual observed need from clarusc's own worst statement — but then ALSO add a fixture that sits at the new ceiling so the next bump is a test failure, not a field error. Record which route and why.

- [ ] **Step 3: Record the size baseline**

Run: `scripts/size-68k.sh`
Expected: the clarusc line now prints `SIZE clarusc <bytes> <segments>` (it previously errored). Record all three lines in the task report; feed the clarusc bytes back into Task 1's budget arithmetic and re-state go/no-go.

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): clarusc self-emit68k -- big-temp pool sizing"
```

---

### Task 4: Snow file round-trip harness (REWRITTEN 2026-08-09 for the Snow pivot)

**Files:**
- Create: `internal/mactest/snow_test.go` (helpers + a gated self-test)
- Create: `scripts/drag.swift` (promote the session-scratchpad helper: press-drag-release CGEvent for non-sticky System 7 menus)
- Create: `.superpowers/sdd/2026-08-08-mac-resident-clarusc/task-4-report.md` (decision memo)

**Interfaces:**
- Consumes: the Snow facts block in "Verified codebase facts" (launch, workspace JSON, hfsutils-on-device-image recipe, `out`-file log channel, screen-coordinate mapping).
- Produces (target API — adjust to findings, keep names):
  ```go
  func newSnowDisk(t *testing.T) *snowDisk        // copies snow/hdd0.img + writes a scratch .snoww pointing at it
  func (d *snowDisk) putText(t *testing.T, name string, data []byte)
  func (d *snowDisk) putMacBinary(t *testing.T, binPath, name string)
  func (d *snowDisk) get(t *testing.T, name string) []byte            // text mode
  func (d *snowDisk) getMacBinary(t *testing.T, name string) []byte   // forks preserved
  func runSnow(t *testing.T, d *snowDisk, timeout time.Duration, done func() bool) // boots, polls done(), quits Snow
  ```
  Gate the whole file on a new env var `CLARUS_SNOW_TESTS=1` (Snow is a GUI app that steals the screen — never fold into plain `CLARUS_MAC_TESTS`).

- [ ] **Step 1: Auto-launch without GUI clicks**

Probe the Startup Items route: `hcopy -m` an app into `:System Folder:Startup Items:` on a scratch copy of the image, boot Snow, verify the app launches itself. If Startup Items works (expected on 7.1), it is THE launch mechanism — no click automation in the harness. Record the result. Also spend at most ~30 min probing the undocumented `shared_dir` workspace key (set it to a host dir, boot, look for a mounted volume); adopt it only if it obviously works, otherwise note and move on.

- [ ] **Step 2: Completion detection + shutdown/flush**

The app under test self-quits (TickProbe pattern). Options to prototype, in order: (a) `done()` polls for a sentinel — the app's LAST action before quit is writing a marker file (or its `out` file), and the harness polls by watching the image file's mtime/size from the host (the image IS written through while Snow runs — verify this claim first; if writes are buffered until quit, fall back to (b)); (b) fixed generous wait after boot, then quit Snow, then inspect. Quitting Snow: try plain SIGTERM/`osascript -e 'quit app "Snow"'` after the app has exited to Finder and ~10s of Finder idle (HFS flush); validate no corruption by byte-comparing a file written before shutdown across 3 repeated runs. A scripted Finder Shut Down via drag.swift is the fallback if kill-after-idle proves unreliable. Record which mechanism won and the reliability evidence (3/3 clean runs minimum).

- [ ] **Step 3: Land the helpers + a gated self-test**

`TestSnowRoundTrip` (under `CLARUS_SNOW_TESTS=1`): scratch disk; `putText` a marker file; put a 10-line fixture app (`file.readText` marker + `file.writeText` copy + quit) in Startup Items; `runSnow`; `get` the copy out; byte-compare; also assert the app's `out` file is extractable. This is the integration test's foundation — it must be rock solid (run it 3× in a row green).

Run: `CLARUS_SNOW_TESTS=1 go test ./internal/mactest -run TestSnowRoundTrip -count=1 -v -timeout 20m` (foreground)
Expected: PASS, 3 consecutive runs.

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh` (add --smoke only if `runtime/`/`clarusc/` were touched)
Expected: PASS.

```bash
git add -A
git commit -m "test(macresident): Snow file round-trip harness (snowDisk helpers)"
```

---

### Task 5: Named resources in app68k + `--bake FILE` flag

**Files:**
- Modify: `clarusc/app68k.cla:312-360` (`app68BuildResourceFork` gains names), `clarusc/cg68k.cla:9250-9290,9387-9410` (`cg68ResourceParitySet` + `cg68WriteImage` extras carry names), `clarusc/main.cla:390-549` (flag) and `:1204-1229` (hand-off)
- Modify: `internal/mactest/resparity_test.go` (parse names), `internal/cg68k/image_test.go` (`parseResourceFork` names)
- Create: `internal/mactest/bake_test.go` (or extend resparity) — host-side unit

**Interfaces:**
- Consumes: `app68BuildResourceFork` triple-list contract (facts above).
- Produces: `app68BuildResourceFork(resTypes: list of string, resIds: list of int, resNames: list of string, resDatas: list of text): text` — `resNames[i] == ""` → unnamed (name-list offset 0xFFFF in the ref entry), else Pascal-string entry in the name list. `clarusc emit68k --bake FILE` (repeatable): one `'CLFS'` resource per file, id `128+i` in flag order, name = FILE exactly as passed, bytes verbatim; duplicate name or name >255 bytes → error + `quit 2`. cg68k globals `cgBakeNames: list of string` / `cgBakeDatas: list of text` (mirroring `cgEventsBytes`'s hand-off pattern).

- [ ] **Step 1: Write the failing Go unit**

In the new test: run the bootstrapped clarusc with `emit68k --bake testdata/cg68k/tickprobe.cla -o <tmp>` on any small UI fixture; parse the fork (`resparParseFork` after extending it for names); assert a `CLFS` resource id 128 named `testdata/cg68k/tickprobe.cla` whose bytes equal the file. Also assert: same build WITHOUT `--bake` is byte-identical to a pre-change build (stash one before editing, or assert against the committed golden mechanism resparity already uses).

Run: `go test ./internal/mactest -run <name> -count=1`
Expected: FAIL (flag unknown).

- [ ] **Step 2: Implement name-list emission**

Resource-fork name list per Inside Macintosh I-M resource-map layout (the existing builder already lays out map/type-list/ref-lists — extend, don't rewrite): each named ref entry stores a 2-byte offset from name-list start; name list entries are length-byte + bytes; unnamed entries store 0xFFFF. Keep the existing sort (type raw-bytes asc, id asc). All existing call sites pass a same-length list of `""` — mechanical.

- [ ] **Step 3: Implement `--bake` in main.cla**

Parse repeatable `--bake PATH` under `emitMode68k` only (mirror `--events` at `:517-531`); read each file with `file.readText` at hand-off time (where `cgEventsBytes` is set, `:1216`); duplicate-key and >255 checks with `log(...)` + `quit 2`.

- [ ] **Step 4: Unit passes + no-flag byte-identity**

Run: `go test ./internal/mactest -run <name> -count=1` and the resparity/cg68k golden suites.
Expected: PASS; goldens untouched.

- [ ] **Step 5: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): named resources + emit68k --bake FILE"
```

---

### Task 6: Driver split — `drive.cla` + `feReadSource` seam

**Files:**
- Create: `clarusc/drive.cla`
- Modify: `clarusc/main.cla` (include block `:21-37` + `startCLI` body shrinks to flags/modes/CLI-IO)

**Interfaces:**
- Consumes: everything `startCLI` calls today.
- Produces (exact signatures later tasks call):
  ```
  // drive.cla — front-end-neutral pipeline. Globals it owns:
  var hostPaths: bool            // true = '/' semantics (main.cla), false = HFS ':' (macgui)
  func driveCompile(entries: list of string, testapi: bool): bool
      // Phase A expand/lex/parse + splices + checks + lowerProgram.
      // false on any diagnostic; diagnostics stay in the existing diag
      // stores exactly as today (front ends render them).
  func driveEmit68k(outPath: string, listing: bool, segLimit: int, nopeep: bool): bool
      // cg68AddRoots + glue + shake + cg68Program (host MacBinary write).
  // Each FRONT END must define:
  func feReadSource(path: string, key: string, out: text): bool
      // main.cla: file.readText(path) with the existing rtdir mapping for
      // runtime keys; ignores resource fallback entirely.
  ```
  Moved verbatim into drive.cla: `dirOf`, `baseNameNoExt`, `joinPath`, `normalizePath`, `findRtDir`, `lastDecl`, `expand`, `hoistDedups`. `expand`'s `file.readText` call (`main.cla:259`) becomes `feReadSource(path, <computed key or "">, src)`.
  The C-emit (`emitProgram`) and appinfo branches stay in main.cla, calling `driveCompile` first.

- [ ] **Step 1: Snapshot a differential baseline BEFORE the move**

Run: `build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/pre_tick.bin testdata/cg68k/tickprobe.cla && build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/pre_main.c clarusc/main.cla`
Expected: both succeed; keep the outputs.

- [ ] **Step 2: Extract**

Move the phase ranges listed in the facts section into `driveCompile`/`driveEmit68k`; add `include "drive.cla"` to main.cla's block (position: after `uiblob.cla`; if decl-order issues arise, before `cg68k.cla` — record what worked). Define `feReadSource` in main.cla wrapping today's exact read logic. `startCLI` becomes: parse flags → `driveCompile` → mode branch (`appinfo` print / `emitProgram`+writeText / `driveEmit68k`) → exit codes. NO behavior change intended anywhere.

- [ ] **Step 3: Differential check**

Rebuild the bootstrap against the NEW source (two-stage: old binary emits new compiler C, cc it, use that), then:
Run: `<new clarusc> emit68k --rtdir runtime/clarus/ -o /tmp/post_tick.bin testdata/cg68k/tickprobe.cla && cmp /tmp/pre_tick.bin /tmp/post_tick.bin`
Expected: byte-identical (a pure code-motion refactor cannot change emitted output for a fixed input program).

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS (T1 has no selfhost, so the snapshot-drift failure cannot fire here).

```bash
git add -A
git commit -m "refactor(macresident): extract pipeline into drive.cla behind feReadSource seam"
```

---

### Task 7: `file.readResource` + `file.writeRes` + toolbox catalogs

**Files:**
- Modify: `clarusc/check.cla` (file-call arms; find the `readText` declaration pattern), `clarusc/lower.cla:1150` region (`lowFileCall` arms), `clarusc/cprint.cla` (host lowering → rt stubs), `clarusc/cg68k.cla` (native lowering → nat wrappers)
- Modify: `runtime/host/rt.c`/headers (host stubs: readResource fills nothing + returns 0; writeRes writes NOTHING and returns 0 — host has no resource forks; document in the reference)
- Modify: `runtime/clarus/native.cla` (natReadResource, natWriteRes — the real Mac implementations)
- Create: `toolbox/resources.cla` (Resource Manager catalog); Modify: `toolbox/files.cla` (fill: create/open-RF/write/close/GetFInfo-SetFInfo family)
- Modify: `internal/testsuite/catalog_test.go` (new entries), `docs/clarus-language-reference.md` (files chapter, ClaruscOnly-fenced), `testsuite/toolbox/` (two new cases + runner enum)
- Modify: whatever builds the toolbox suite GUI (`internal/mactest/coresuite_test.go` file lists + `buildNative68kUI` call) to pass `--bake <small test blob>` for the ResourceBake case

**Interfaces:**
- Consumes: Task 5's `--bake`; `natFileReadText`'s copy idiom (facts above).
- Produces:
  ```
  file.readResource(name: string, out: text): bool   // 'CLFS' by name, current resource chain
  file.writeRes(path: string, fork: text, doctype: string, creator: string): bool
  ```
  Toolbox suite cases: `ResourceBake` (readResource of the baked test blob, verify contents+length; readResource of a missing name → false), `WriteResStamp` (writeRes a small fork; assert true + re-stat type/creator via the FInfo pattern from the existing `FInfoStamp` case).

- [ ] **Step 1: Trap verification FIRST**

For every new extern (Get1NamedResource, ReleaseResource, GetHandleSize/SizeRsrc, HLock/HUnlock as needed; Create/OpenRF/FSWrite/FSClose/SetFInfo or their PB forms): decode the inline words from `Retro68/InterfacesAndLibraries` CIncludes pragmas + AIncludes OPWORDs; write the citation comments in the catalog files BEFORE wiring anything (template: `toolbox/files.cla` header). Registers-vs-stack and bit-11 conventions per `trap-verification-sources` rule.

- [ ] **Step 2: Language surface (check/lower/cprint/cg68k arms) + host stubs**

Follow `file.readText`'s exact plumbing end to end and mirror it. Reference doc: add both intrinsics to the files chapter inside a `ClaruscOnly` fence (frozen Go compiler must keep rejecting them — verify the fence mechanism per Chapter 13's).

- [ ] **Step 3: Native impls in native.cla**

`natReadResource`: Get1NamedResource('CLFS', name-as-Str255) → nil check → GetHandleSize → HLock → chunked `rtTextGrow`/`TextHandleDeref`/`TextBlockMoveData` copy (the `:779-797` idiom, INCLUDING re-derive-after-grow) → HUnlock → ReleaseResource → true. `natWriteRes`: Create (delete-first if exists? match `natFileWriteText`'s existing overwrite discipline — read it) → OpenRF → chunked FSWrite from the text (bounce buffer like reads, reversed) → FSClose → SetFInfo(type,creator) → true; any OSErr → false with cleanup.

- [ ] **Step 4: Suite cases + host T1**

Host: catalog test + reference-fence checks green. Add the two toolbox cases + enum entries + `--bake` in the suite build.
Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

- [ ] **Step 5: Native proof (single gated boot)**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -timeout 30m` (foreground)
Expected: PASS including `ResourceBake` + `WriteResStamp` subtests.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat(macresident): file.readResource/file.writeRes + Resource Manager catalog"
```

---

### Task 8: Mac-side source resolution in drive.cla (paths + resource fallback)

**Files:**
- Modify: `clarusc/drive.cla` (`joinPath`/`dirOf`/`normalizePath` grow `hostPaths=false` arms; `expand` computes both disk path and key; absolute-include diagnostic on Mac)

**Interfaces:**
- Consumes: Task 6's seam; Task 7's `file.readResource` (used only by macgui's `feReadSource`, Task 10 — NOT here; this task is pure drive.cla logic).
- Produces:
  ```
  func drivePathJoin(dir: string, rel: string): string
      // hostPaths: today's joinPath. Mac: '/'-split rel; each ".." adds a
      // ':' (HFS parent); "a/b.cla" from dir "Disk:src:" -> "Disk:src:a:b.cla".
  func driveKeyResolve(baseKey: string, rel: string): string
      // pure '/'-space: dirOf(baseKey) + rel, "..", "." normalized;
      // leading "../" segments that escape the root are STRIPPED
      // ("../../toolbox/files.cla" from key "" -> "toolbox/files.cla").
  ```
  `expand` contract after this task: try `feReadSource(diskPath, key, src)` where diskPath = platform join and key = `driveKeyResolve(includerKey, rel)`; a file loaded from a resource carries its KEY as its recorded path (diagnostics show it; `seenPaths` dedups on it). Mac + include starting with `/` → diagnostic "absolute include paths are not supported on Mac", not a crash.

- [ ] **Step 1: Write failing host-visible checks where possible**

The `hostPaths=true` arms must be bit-for-bit today's behavior: rerun the include/incdedup fixture suites (they exist: `testdata/include/`, `testdata/incdedup/`). For the Mac arms, add `drive.cla` doc-comment worked examples (the ones above) and — since compiler-internal funcs have no host unit harness — the executable proof is Task 11's on-Mac catprobe compile; say so in the task report rather than pretending coverage.

- [ ] **Step 2: Implement; run the include suites**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS (host behavior unchanged).

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat(macresident): HFS path arms + resource key resolution in drive.cla"
```

---

### Task 9: Fork-split emit — `driveEmit68kFork`

**Files:**
- Modify: `clarusc/cg68k.cla:9387-9410` (`cg68WriteImage` splits: build fork → host wraps MacBinary as today), `clarusc/drive.cla`

**Interfaces:**
- Consumes: `app68Build`'s fork/header seam (`:528-530`).
- Produces:
  ```
  func driveEmit68kFork(): bool      // same pipeline tail as driveEmit68k
  func driveLastFork(): text          // the raw resource-fork image
  func driveLastAppName(): string     // from the app section (appinfo naming rules)
  func driveLastCreator(): string
  ```
  (Or return-by-out-params if that matches house style better — keep the four values, whatever the shape.) `driveEmit68k(outPath,...)` host path MUST remain byte-identical: it becomes driveEmit68kFork + MacBinary wrap + `file.writeText`.

- [ ] **Step 1: Refactor with the differential guard**

Same discipline as Task 6 Step 1/3: pre/post emit68k of tickprobe byte-identical via `cmp`.

- [ ] **Step 2: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "refactor(macresident): fork-split emit path (driveEmit68kFork)"
```

---

### Task 10: `macgui.cla` + build script

**Files:**
- Create: `clarusc/macgui.cla` (own include block: same modules as main.cla `:21-37` + `drive.cla`; NEVER included by main.cla)
- Create: `scripts/build-clarusc-mac.sh`
- Modify: `runtime/clarus/uidialogs.cla` (ONLY if Step 1 verification shows the real-SF path doesn't leave the chosen file reachable by bare name — then SetVol from the SFReply, real-dialog arm only, scripted arm untouched)

**Interfaces:**
- Consumes: `driveCompile`, `driveEmit68kFork`/`driveLast*`, `file.readResource`, `file.writeRes`, `askOpen`, the diag stores drive.cla exposes.
- Produces: the Mac front end. Structure (adjust widget/DSL details against `examples/texteditor.cla` — it is the canonical UI-source reference):
  - `app` section: name `ClarusC`, its own creator (pick an unused 4-char, document it), doctype `TEXT`.
  - One window, one full-size log `textview` (read-only if the DSL supports it).
  - File menu: `Compile…` (cmd-K or house pick) and `Quit`.
  - Compile flow: `askOpen(p, "TEXT")` → clear per-run state (drive.cla must be re-entrant per compile: verify/reset its globals — list what needed resetting in the task report) → `driveCompile` with entries=[p], testapi=false → diags appended to log → if clean: `driveEmit68kFork` → `file.writeRes(driveLastAppName(), driveLastFork(), "APPL", driveLastCreator())` → log `BUILT <name> <bytes> bytes` → else alert first error.
  - `feReadSource(path, key, out)`: `file.readText(path, out)`; on false and key non-empty, `file.readResource(key, out)`.
- `scripts/build-clarusc-mac.sh`: snapshot-bootstrap (copy `build-68k.sh:43-48`), then
  ```sh
  BAKES=""
  for f in runtime/clarus/*.cla toolbox/*.cla; do BAKES="$BAKES --bake $f"; done
  build-run/clarusc emit68k --rtdir runtime/clarus/ -o build-68k/ClarusC/ClarusC.bin \
      $BAKES ${EVENTS:+--events "$EVENTS"} clarusc/macgui.cla
  ```
- **SIZE resource (Snow pivot):** the app runs under System 7's Process
  Manager, so its SIZE partition must cover the compile working set
  (spec §7 as amended: comfortably above the Mac-side estimate of the
  39.8MB host high-water — on a 128MB machine, err large, e.g. 48–64MB).
  Find where `res68k`/`cg68k` emits SIZE today and how its value is set;
  make the partition configurable or macgui-specific rather than
  hardcoding a giant default for every Clarus app. Verify in Task 11
  that the compile doesn't die of an undersized partition.

- [ ] **Step 1: Verify the bare-name reachability assumption**

Read `runtime/clarus/uidialogs.cla:845` region + `UiSFGetFile`: after a REAL (non-scripted) SFGetFile, does anything SetVol to the reply's vRefNum? If not, a real user picking a file outside the default dir gets an unreadable bare name — add SetVol(reply.vRefNum) in the real-dialog arm (extern already cataloged: `PBSetVolSync`, `toolbox/files.cla`). Scripted lane semantics unchanged (scripted answers are bare names in the default dir by construction). If uidialogs already handles it, record that and skip.

- [ ] **Step 2: Write macgui.cla + script; cross-build**

Run: `scripts/build-clarusc-mac.sh`
Expected: `build-68k/ClarusC/ClarusC.bin` exists; `scripts/size-68k.sh`-style size logged in the report (this is the REAL Mac binary size — close Task 1's budget arithmetic with it).

- [ ] **Step 3: Native boot smoke**

Events file with just `quit` (plus a `snap` if the trace harness wants one frame); build with `EVENTS=<that file>`; boot via `RunMac`.
Run: ad-hoc gated Go test or a one-off `LaunchAPPL -e minivmac` foreground run.
Expected: window appears (trace), clean exit 0. Record boot wall-clock.

- [ ] **Step 4: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): macgui front end + build-clarusc-mac.sh"
```

---

### Task 11: Integration test + docs + snapshot regen (phase close)

**Files:**
- Create: `testdata/macresident/catprobe.cla`, `testdata/macresident/clarusc.events`
- Create: `internal/mactest/macresident_test.go` (`TestMacResidentClaruscOn68k`)
- Modify: `docs/ROADMAP.md` (phase entry), `docs/clarus-language-reference.md` (only if gaps found), `CLAUDE.md` (build script + surface one-liners), `clarusc/clarusc.c` (snapshot regen, LAST)

**Interfaces:**
- Consumes: everything.
- Produces: the phase's acceptance evidence.

- [ ] **Step 1: Write catprobe.cla**

```
// testdata/macresident/catprobe.cla -- proves the baked toolbox/ catalog
// resolves via resource fallback on-Mac (include has NO disk copy there).
include "../../toolbox/osutils.cla"

app {
    name: "CatProbe"
    id: "CPRB"
}

window main {
    title: "catprobe"
}

on App.launch {
    var t: int
    t = TickCount()
    if t > 0 {
        quit 0
    }
    quit 1
}
```
Verify surface details (app/window/launch syntax, that `toolbox/osutils.cla` declares `TickCount` — pick whichever cataloged trap it does declare) against `testdata/cg68k/tickprobe.cla` and the catalog file BEFORE trusting; keep the intent: one catalog include, one real trap call, self-quit.

- [ ] **Step 2: Write the events script**

```
answer-open tickprobe.cla
menu 1 1
answer-open catprobe.cla
menu 1 1
quit
```
Menu indices per macgui's actual menu layout (File is menu 1 only if there's no Apple menu entry — check how examples number theirs; texteditor uses `menu 2 x` because Apple is 1). Answers queue before the verb that opens the dialog.

- [ ] **Step 3: The test (Snow, per the Task 4 harness)**

`TestMacResidentClaruscOnSnow` (gated `CLARUS_SNOW_TESTS=1`):
1. Build ClarusC.bin via `scripts/build-clarusc-mac.sh` with `EVENTS=testdata/macresident/clarusc.events`.
2. Host oracles: bootstrapped clarusc `emit68k --rtdir runtime/clarus/ -o <tmp>/tick_host.bin testdata/cg68k/tickprobe.cla` and same for catprobe (no `--events`, no `--bake`); slice each fork per `resparBuildAndParse` (`img[128:128+rsrcLen]`, length at `h[87:91]`).
3. Disk: `newSnowDisk`; `putMacBinary` ClarusC into Startup Items (Task 4's launch mechanism); `putText("tickprobe.cla", ...)` + `putText("catprobe.cla", ...)` at the root. Deliberately NO toolbox/osutils.cla on disk — its resolution MUST come from the baked resource. NOTE: the events script drives ClarusC itself; verify with Task 4's completion mechanism (sentinel = ClarusC's own quit after the script's `quit` verb; its `out` file carries the log).
4. `runSnow(...)` with a ≥30 min timeout; after extraction, assert the `out` log contains two `BUILT` lines; record compile wall-clock in the report.
5. `getMacBinary` both produced apps (names per appinfo rules: `TickProbe`, `CatProbe` — verify against `clarusc appinfo` output); slice forks; `bytes.Equal` against the host forks. THE core assertion. (askOpen paths: the sources sit in the root, ClarusC launches from Startup Items — Task 10's SetVol/default-dir verification decides whether the events script's `answer-open` names need a folder prefix; resolve there, not here.)
6. Launchable-app proof: fresh `newSnowDisk`, extracted TickProbe into Startup Items, `runSnow` → its `out` trace appears and ends with the 60-fire quit shape (compare loosely: OPEN/FRONT present, ≥60 FIRE lines — Mac II fires per event-loop pass, so exact counts are CPU-speed-dependent; do NOT golden-compare real-mode fire counts).

Run: `CLARUS_SNOW_TESTS=1 go test ./internal/mactest -run TestMacResidentClarusc -count=1 -timeout 60m -v` (foreground)
Expected: PASS. If the fork compare fails, dump both forks to files and `xxd`-diff the first divergence — a word-size/endianness bug in clarusc itself is EXACTLY what this oracle exists to catch; report it, don't paper over it.

- [ ] **Step 4: Docs**

ROADMAP: phase entry under the 5f decomposition (done-state, measured numbers, honest limits — e.g. default-dir compile model, host readResource stub). CLAUDE.md: `build-clarusc-mac.sh` one-liner + `--bake` + the two intrinsics, kept terse. Reference: confirm Task 7's chapter text still matches as-built.

- [ ] **Step 5: Snapshot regen (LAST code-affecting step)**

Run the 4-line fixedpoint recipe from the facts section (exactly; it regenerates `clarusc/clarusc.c` through the two-stage bootstrap).
Then: `go test ./internal/selfhost -count=1 -timeout 30m` (foreground)
Expected: PASS including `TestSnapshotFixedPoint`.

- [ ] **Step 6: T2 and commit**

Run: `scripts/test-merge.sh` (foreground; needs emulator; budget ≥45 min)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): on-Mac compile integration test + snapshot regen + phase records"
```

---

### Task 12: System 7 Quit AppleEvent (EXECUTE BEFORE TASK 11; added 2026-08-09)

**Files:**
- Create: `toolbox/appleevents.cla` (AE catalog: `AEProcessAppleEvent`, `AEInstallEventHandler`, `AEGetParamDesc`/reply plumbing as needed — decode-the-inline-words rule, citations mandatory)
- Modify: `runtime/clarus/ui.cla` (the `rtUiSys7` path: handle `kHighLevelEvent` in the real event loop; install/dispatch the required-suite Quit handler via a `callback func` — the toolbox-integration phase's callback mechanism)
- Modify: `internal/testsuite/catalog_test.go` (new catalog entries)

**Interfaces:**
- Consumes: spec §7b; the existing `App.openDocument` System 7 arm (see how it already touches AppleEvents — mirror its conventions); `callback func` (language reference).
- Produces: a Clarus UI app on System 7 quits when the Finder/Process Manager sends `kAEQuitApplication` (shutdown proceeds); System 6 path byte-identical behavior; scripted-lane goldens untouched (the handler code must be unreachable under `--events`/System 6 — same discipline as `rtUiSys7` itself).

- [ ] **Step 1: Read the existing System 7 arm + the 5faaa6c lesson**

Read `runtime/clarus/ui.cla`'s `rtUiSys7` sites and `App.openDocument`'s System 7 arm, plus the ROADMAP's real-event-loop trap-convention entry (`5faaa6c`). Write down in the report: where `kHighLevelEvent` arrives in the loop, and whether openDocument already calls `AEProcessAppleEvent` (if yes, extend its handler table; if no, this task installs the first real AE plumbing and openDocument's arm should be left alone).

- [ ] **Step 2: Implement minimal required-suite handling**

Quit → set the runtime's existing quit flag (find how the `quit` statement sets it; reuse). oapp → no-op acknowledge. odoc/pdoc → route to the existing openDocument path if present, else return `errAEEventNotHandled`. Trap words and register conventions verified against Universal Interfaces; citations in `toolbox/appleevents.cla`.

- [ ] **Step 3: Prove it on Snow (real-mode only — scripted lane cannot see this)**

Manual-or-scripted probe (Task 4 helpers if landed): scratch disk, Bounce in Startup Items, boot, then scripted Finder Shut Down (drag.swift; Special menu drag coordinates in the Snow facts block) — shutdown must now COMPLETE (the 2026-08-09 boot test's exact failure). Record before/after evidence (screenshot or the fact the emulator process exits after Snow's own shutdown). If Task 4 landed a reusable scripted-shutdown helper, add this as a gated `CLARUS_SNOW_TESTS=1` test `TestQuitAppleEventOnSnow`; if not, a documented manual verification in the report is acceptable THIS task, and Task 11 step 6 re-proves app boot regardless.

- [ ] **Step 4: Guard the frozen goldens**

Run the native golden lane relevant subset (the 4 frozen scenarios) — byte-identical (the new code must be dead under scripted events / System 6).
Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounceOn68k|TestSmokeMandelUIScenario|TestUiScenariosOn68k' -count=1 -timeout 30m` (verify the exact test names in native_test.go first)
Expected: PASS, goldens untouched.

- [ ] **Step 5: T1 and commit**

Run: `scripts/test-task.sh --smoke` (foreground)
Expected: PASS.

```bash
git add -A
git commit -m "feat(macresident): System 7 required-suite Quit AppleEvent handling"
```

---

### Task 13: Constant-pool segmentation (added 2026-08-09 from Task 3's structural finding; EXECUTE BEFORE TASK 10)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgPackProgram` + pool emission/label-reservation sites; see Task 3's report for the discovery trace), possibly `clarusc/asm68k.cla` (if label/relayout plumbing needs a per-segment notion it lacks)
- Create: at least one committed self-check that pins the capability (preferred: a host-side Go test asserting `emit68k` of clarusc's own CLI composition succeeds — the two-stage bootstrap recipe in Global-facts — e.g. `TestSelfEmit68k` in `internal/cg68k` or `internal/selfhost`; it's a seconds-scale host run)

**Interfaces:**
- Consumes: Task 3's report (`task-3-report.md`) — the blocker: `cgPackProgram` duplicates the ENTIRE constant pool into every CODE segment, and clarusc's own pool is 32.8KB against the 32,760-byte segment budget, so nothing packs.
- Produces: per-segment constant pools — each segment carries only the constants its own packed functions reference (dedup within a segment; a constant referenced from N segments appears in those N pools — 68k PC-relative data access cannot cross segments, so per-referencing-segment duplication is the correct shape, verify that premise in the code before building on it). Gate: `scripts/size-68k.sh` prints a real `SIZE clarusc ...` line; the new self-emit test passes.

- [ ] **Step 1: Read the current pool model end to end** — reservation (`cgReserveStrLitLabels`, `cgReserveUiPoolLabels`), emission, and how `cgPackProgram` charges pool bytes to segments. Write the two-paragraph design (what owns a constant, how labels resolve per segment) in the report BEFORE coding.
- [ ] **Step 2: Implement + fixture.** The at-scale fixture is clarusc itself (the self-emit test). If a small synthetic multi-segment shared-constant fixture is cheap to add to `testdata/cg68k/`, add it with a golden; if it needs contrived >32KB literals, skip it and say so — the self-emit test is the pin.
- [ ] **Step 3: Behavior gates.** Frozen UI scenario trace/PBM goldens: byte-identical (behavior unchanged). `internal/cg68k` `.s` goldens: single-segment fixtures should be UNCHANGED (their one segment already held the whole pool); any multi-segment golden churn must be explainable as pool ownership/ordering, eyeballed and reported. coregui/toolboxgui sizes (`scripts/size-68k.sh`): record before/after — per-segment pools should SHRINK multi-segment binaries (less duplication); growth is a red flag to explain.
- [ ] **Step 4: T1 and commit** — `scripts/test-task.sh --smoke` foreground, then commit (standing trailer).

---

## Self-review notes (kept honest)

- Spec §1 acceptance → Task 11 (byte-compare + boot); §2 gaps → Tasks 2–3; §3 `--bake`+named resources → Task 5; §3 minimal file surface + seam → Tasks 6–7; §4 resolution → Tasks 8+10 (`feReadSource`); §5 paths → Task 8; §6 output write → Tasks 7 (writeRes) + 9 (fork split) + 10 (call site); §7 memory posture → Tasks 1, 3, 10 (budget closed with real numbers); §8 T1 items → Tasks 2,5,7,8; harness spike → Task 4; T2 → Task 11; non-goals respected (no cache, no Retro68 changes, no extra resource surface).
- Deliberately verify-before-trust: Clarus surface details in fixtures (Tasks 2, 11), `internal/cg68k` bless env var name (Task 2), menu indices + UI DSL details (Tasks 10–11), trap words (Task 7 Step 1 is exactly that), LaunchAPPL internals (Task 4 exists because they're unverified).
- Known sequencing risk: Task 4 (harness spike) is independent of Tasks 2–3 and can run in parallel or be pulled first; if it lands on fallback strategy 3, Task 11's steps 3/5 use baked-resource file-in and checksum file-out per the spec's fallback wording, and the produced-app boot check moves to whatever binary the checksum path can reconstruct — flag for explicit sign-off before proceeding on that path.
- Re-entrancy of drive.cla globals across two compiles in one boot (Task 10) is called out as a verify step — the CLI never needed it; the GUI does.
