# SDD ledger — plan: docs/superpowers/plans/2026-08-26-filesystem-api.md

Spec: docs/superpowers/specs/2026-08-26-filesystem-api-design.md (binding authority).
Branch: filesystem-api (base main 8b8e8e2; spec 563fe7f, plan 65bfdd8).

## Pre-flight scan (2026-08-26, before Task 1)

| Pair / task | Produces vs consumes | Finding |
|---|---|---|
| T2 ↔ T5 | T2 externs `PBGetCatInfoSync(pb, sel)`… records `HFileParam`/`CInfoPBRec`/`CMovePBRec`/`HIOParamRename`, consts `hfsSel*`/`ioDirMask`; T5 consumes all by those names | consistent; `HIOParamRename` only described in T2 Step 3's trailing note (offsets `ioMisc`@28, `ioDirID`@48, size 52) — T1 must confirm `PBHRename` reads the new name from `ioMisc` on the H variant |
| T3 ↔ T4 | T3 defines `rtFhDevStat`+7 getters and `FhHStat`/`FhHStatField`, `rt_fh_stat_buf`, `rt_fh_mac_time`; T4 reuses `rt_fh_stat_buf` in `FhHSetTimes` and adds `rt_fh_unix_time` | consistent |
| T3 ↔ T4 (`usesFileh`) | T3 widens to open/create/exists/info; T4 replaces with a name-set helper | consistent (T4 supersedes) |
| T4 ↔ T5 | `rtFhDev*` contract identical in both Interfaces blocks | consistent; T5 must define every name T3+T4 introduced or the native splice fails |
| T4 internal | Step 5 shows `rt_fh_posix_path` in the `rt_fileh.inc` code block, then the prose says move it into `rt.c` above `path_to_cstr` | **Ruling:** define it in `rt.c` directly above `path_to_cstr` (the ONE hook all path-taking C entry points share) — the code block is illustrative. Cost if wrong: none (link-order only). |
| T5 internal | `CInfoPBRec(ptr)` overlay-from-address form assumed; fallback (local + copy scalars) stated | delegated to T1 Step 6/Step 5 to confirm; fallback is fine |
| T5 vs Global Constraints | zero-golden-churn rule vs the one new native global `rtFh68kState` | plan already carves the explicit exception with a rebless procedure — no conflict |
| T1 internal | probe record `PbCInfo` trailing `pad[32]` after `ioFlMdDat`@76 would size it 112, not 108 | **Ruling:** trailing pad is `pad[28]` (80→108). Cost if wrong: probe record over-long by 4 bytes, harmless. |
| T2 internal | `CInfoPBRec` layout: `fdCreator`@36 + `pad[8]` → `ioDirID`@48; `ioFlMdDat`@76, `ioFlBkDat`@80, `pad[16]` → `ioFlParID`@100, `ioFlClpSiz`@104, total 108 | arithmetic checks out; `HFileParam` fdFlags/fdLocationV/fdLocationH/fdFldr = 8 bytes → `ioDirID`@48 ✓; `CMovePBRec` `ioNewName`@28 `ioNewDirID`@36 `ioDirID`@48 ✓ |
| T6 internal | fixture `include "toolbox/osutils.cla"` from `testdata/run/` relies on the `<rtdir>/../../toolbox/` include fallback | the harness passes `--rtdir` (binary-files phase Task 7 proved this shape in `internal/lowlevel/rtinc_test.go`); implementer verifies |
| T3 internal | fixture harness test names unknown at plan time | implementer discovers via `grep "func Test" internal/lowlevel/*_test.go` |
| T4 test asserts | `DirOps` asserts real values on every step; no assert-nothing tests | clean |
| duplication | `rtFh*` six bodies in T4 Step 4 are three-line same-shape wrappers, matching the existing `rtFhOpen` idiom | accepted repo pattern, not a defect |

Rulings from the scan are in the rows above (2). No other conflicts found.

## Task log

Task 1: dispatched (implementer sonnet), BASE 65bfdd8
Task 1: implementer DONE_WITH_CONCERNS at cb2c298 (report task-1-report.md; Snow not run — a live 68kbbs Snow session owns the emulator; vMac results complete)
Task 1: Ruling: System 7 verification deferred — Task 5 Step 5's Snow spot check stands; if Snow is still owned by another session then, defer to close-out and record it in TODO as an unverified lane. Cost if wrong: a System 7-only HFS difference (none expected; the PBH*/HFSDispatch family predates System 7) reaches 68kBBS untested.
Task 1: Ruling: rtFhDevRename (Task 5) MUST NOT use the ioDirID=0 + partial-path convention — hardware returns bdNamErr/dirNFErr. It does one PBGetCatInfoSync by full path (the rtFhDevStat call), takes ioFlParID (@100) as the parent DirID, and calls PBHRenameSync with ioNamePtr = the BARE LEAF NAME (text after the last ':'; whole string if none) and ioDirID = that parent. Task 2's CInfoPBRec already names ioFlParID. Cost if wrong: rename fails natively; DirOps catches it.
Task 1: Ruling: prelude splice (Task 3) — the plan's neededMods route only reaches combined2; implement the from-source splice BEFORE the Phase A entries loop (drive.cla ~1914, one expand() of prelude.cla via the runtime-module reader) so FileInfo is in `combined` for the standalone check; test with a plain non-UI program calling file.info; fall back to the spec §6 synthesized-record route only if that breaks driveEarlySplice's --testapi rebuild. Cost if wrong: a day of rework in drive.cla, no external effect.
Task 1: note for Task 5: no overlay form for extern records. A module-level extern-record `var` is an A5 global and would churn goldens; prefer function-local PB records, with persistent cross-call state (list DirID/index, name buffer) in one lazily NewPtr'd block hung off a single new `ptr` global — the plan's rtFh68kState.
Task 1: fix round 1/5 (2 addressed per implementer, re-review pending — steps 7-9 narrative re-run with stale-name proofs 8b/9e; native record-return step 10 a=7; commits cb2c298..90875f9)
Task 1: fix round 1/5 re-review: 2 addressed, 0 open
Task 1: complete (commits 65bfdd8..90875f9, review clean after 1 fix round; Snow deferred per ruling)
Task 2: dispatched (implementer sonnet), BASE 90875f9
Task 2: implementer DONE at 75d9c39 (concerns: cookbook section landed as §12 not §7 — doc had grown; 19 emitui C goldens reblessed as additive extern prototypes; HIOParamRename unused by driver)
Task 2: Ruling: the plan's zero-golden-churn expectation was mis-stated for `testdata/emitui/*.c.golden` — those are C-printer output and legitimately gain one `extern` prototype line per new catalog extern whenever the UI runtime splices toolbox/files.cla (precedent be16175, binary-files Task 2). Additive-prototype-only churn there is accepted for this phase; the constraint still binds cg68k/native goldens (`testdata/cg68k`, uisnaps) and any non-additive emitui change. Reviewer verifies additivity. Cost if wrong: a masked C-lane regression hidden inside a rebless — the reviewer's hunk-by-hunk check is the guard.
Task 2: review (sonnet): spec ❌ 1 Important — driver does not bind PBSetCatInfoSync/HIOParamRename; goldens verified additive-only (9 extern lines × 19 files); offsets/citations all verified. Minor (deferred): cookbook section is §12 not §7 (doc grew).
Task 2: fix round 1/5 dispatched (resume implementer)
Task 2: fix round 1/5 (1 addressed per implementer — driver binds PBSetCatInfoSync + HIOParamRename; commit 9549634; re-review haiku pending)
Task 2: fix round 1/5 re-review: 1 addressed, 0 open
Task 2: complete (commits 90875f9..9549634, review clean after 1 fix round)
Task 3: dispatched (implementer sonnet), BASE 9549634
Task 3: implementer DONE_WITH_CONCERNS at 3e6aa69 (route 1 from-source splice; concerns: bake.cla manifest exclusion + drive.cla "collision registration" found empirically; --testapi --rtbake combo untested in T1/T2; fileh_68k.cla stubs added because the module is spliced into every native build — a plan gap). Review dispatched on opus (drive.cla +203 lines, bake manifest risk).
Task 3: review (opus): spec ❌ 2 Important — (1) unguarded symbols[scopeLookup(FileInfo)] crashes clarusc when the prelude is absent (--rtdir <empty>, or a tree outside the repo); (2) bake.cla/drive.cla comments misdescribe the manifest exclusion (second loop still covers the bake-time path; drive.cla:2089 collision add is a duplicate). Reviewer verified --rtbake and --rtbake --testapi builds byte-equal on the bake path; 19 emitui goldens gained the identical FileInfo typedef+ctor; no cg68k/uisnaps change.
Task 3: Ruling: psRecNamed + its matcher branch are dead (plan-mandated but unused; file.info resolves via sigEndNamed) — delete them. Cost if wrong: none (re-add on demand).
Task 3: minor (deferred): rt_fh_mac_time duplicates rt_dt_now_mac's 3-line conversion — share one helper (final review triage).
Task 3: minor (deferred): drive.cla splice rationale restated at 4 sites (drive.cla:63-73, 1516-1531, 1996-2077, bake.cla:404-417) — consolidate after the comment fix.
Task 3: minor (deferred): reference lines 176/1441 use `--` where neighbours use em dashes.
Task 3: note: native file.exists/file.info are STUBS until Task 5 (exists returns false, info fails with unimpErr -4) — the native lane must not ship without Task 5.
Task 3: deferred test gap (for Task 7 / final review): no T1/T2 test exercises `emit68k --rtbake [--testapi]` over a file.info program; closing test = one internal/bake case asserting the bake path was taken (bkRuntimeFuncBoundary > 0) and output matches the from-source build. Pre-existing, not this phase's: the C lane's --rtbake cannot compile any filehandle program (fileh*.cla not in bakeModuleList on that lane).
Task 3: note: internal/selfhost behavior/error goldens are red on the three new fixtures until Task 7's snapshot regen (expected per spec §4.7) — T2 cannot pass mid-branch.
Task 3: fix round 1/5 dispatched (resume implementer)
