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
Task 3: fix round 1/5 (3 addressed per implementer — guard + honest diagnostic, bake/drive comments corrected + duplicate collision add removed, psRecNamed deleted; commit 5efc3f5; T1 --smoke PASS; re-review sonnet pending). Concern carried: testdata/errors harness cannot express the no-prelude repro (fixed cwd) — pinned by manual repro in the report.
Task 3: fix round 1/5 re-review: 3 addressed, 0 open
Task 3: complete (commits 9549634..5efc3f5, review clean after 1 fix round)
Task 4: dispatched (implementer sonnet), BASE 5efc3f5
Task 4: implementer DONE_WITH_CONCERNS at 8454885 (no golden churn; extra count mirrors found: internal/testsuite/core_cli_test.go, internal/cg68k/segment_test.go; native DirOps FAIL expected until Task 5)
Task 4: review (sonnet): spec ✅; 1 Important — rt_ext_FhHListNext never returns -1 on a readdir() error (silently truncated listing reported as success). Approved otherwise; no golden churn.
Task 4: minor (deferred): fileh_c.cla rtFhDevListBegin would leak rtFhListBuf if called twice without ListEnd (unreachable today; one-line guard).
Task 4: minor (deferred, spec/doc): the reference's Host-behaviour paragraph omits that setInfo's `created` is ignored on POSIX (birth time not settable) — spec §3 text gap reproduced verbatim; fix in Task 7's doc pass.
Task 4: fix round 1/5 dispatched (resume implementer)
Task 4: fix round 1/5 (1 addressed per implementer — readdir errno → -1, rtFhDevListFailed-style reporting; commit 3e97204; T1 --smoke PASS; re-review pending)
Task 4: fix round 1/5 re-review: 1 addressed, 0 open
Task 4: complete (commits 5efc3f5..3e97204, review clean after 1 fix round)
Task 5: dispatched (implementer sonnet), BASE 3e97204
Task 5: implementer DONE at 2084ccc (native DirOps GREEN on vMac; cg68k+emitui goldens reblessed for the one new global rtFh68kState; new segment file peep_pushpop.seg2.s; Snow skipped — still owned by 68kbbs session)
Task 5: controller golden analysis (goldens-setnorm.txt, goldens-union.txt): 51 goldens churned; residue = uniform A5 shift (globals 1588→1592), label renumbering, one zero-init store pair per program (31 programs; the cg_init_globals unrolled-store cost), and segment repacking — every unusual instruction (NEG.L/MULU/SWAP/cg_div) is in the new peep_pushpop.seg2.s (that program crossed a segment boundary). Review dispatched on opus with the code-only diff + the three analysis files (raw package 3.5 MB).
Task 5: review (opus): Approved w/ 2 Important — (1) fileh_68k.cla comments cite Task 1 findings/sections that don't exist (:454,:456-457,:592,:676); (2) plan-mandated "" lane divergence for exists/info (native synthetic default-folder hit, host stat("") fails). Golden churn re-derived independently: fully explained (init pair ×31, A5 shift, segment repacking, peep_pushpop.seg2.s per-segment helpers).
Task 5: Ruling: "" names the program's own folder for EVERY folder-taking call on BOTH lanes (list, exists, info) — host FhHStat substitutes "." for an empty path (as FhHListBegin already does); DirOps pins parity; reference Paths paragraph generalised. Cost if wrong: a caller relying on exists("") == false — none exists.
Task 5: minor (deferred): rtFhDevRename re-implements the by-name GetCatInfo block instead of stashing ioFlParID in a +44 state slot.
Task 5: minor (deferred): bare -120 at fileh_68k.cla:605 — add `dirNFErr` const to toolbox/files.cla.
Task 5: minor (deferred): rtFh68kEnsureState does not check SerNewPtr (pre-existing idiom; global-lifetime block).
Task 5: minor (deferred): rtFh68kFourCCToStr maps a zero fdType to "" (conflates untyped file with folder) — comment.
Task 5: minor (deferred, Task 7 doc pass): toolbox/files.cla:490-492 describes CMovePBRec.ioNewName as "new leaf name" — wrong; it is the destination folder path (Task 1 step 8 proved it). Fix wording.
Task 5: minor (deferred): rtFh68kName truncates the Pascal length byte for paths > 255 (pre-existing; no overrun).
Task 5: coverage gaps (deferred → TODO): folder rename untested on hardware; file.list("") untested; rtFhDevListFailed true-branch unexercised natively; System 7 unverified (Snow owned by another session).
Task 5: fix round 1/5 dispatched (resume implementer)
Task 5: fix round 1/5 (2 addressed per implementer; commit 607c2fa; native + host DirOps green, no golden churn; re-review pending)
Task 5: fix round 1/5 re-review: 2 addressed, 0 open
Task 5: complete (commits 3e97204..607c2fa, review clean after 1 fix round; one planned golden rebless for rtFh68kState)
Task 6: dispatched (implementer sonnet), BASE 607c2fa
Task 6: implementer DONE at 856d1d1 (ReadDateTime returns short per cprint; fixture uses alert(); selfhost TestSnapshotFixedPoint red as expected until Task 7 regen)
Task 6: review (sonnet): spec ✅, no findings (arithmetic, prototypes, unsigned wrap, byte-exact reference edit all independently verified)
Task 6: complete (commits 607c2fa..856d1d1, review clean)
Task 7: Ruling: the ../68kbbs/docs/language-gaps.md update is WRITTEN but left UNCOMMITTED in that repo for Andrew (precedent: the transfer-crcs §8 edit was left uncommitted; committing in another repo is outside this branch's remit). Cost if wrong: one `git commit` for Andrew.
Task 7: Ruling: TestClarusCBakePathOnSnow (~55 min, controller-run) is DEFERRED — Snow is still owned by a live 68kbbs session (pgrep, 06:00 JST); recorded in STATUS/TODO as an owed rerun before merge, alongside the System 7 spot check. Cost if wrong: a baked-runtime regression on the Mac-resident compiler reaches main unproven — the reviewer's --rtbake experiments in Task 3 are the only current evidence.
Task 7: dispatched (implementer sonnet), BASE 856d1d1
Task 7: implementer stalled twice (turn ended waiting on a background gate; no report, no commit; doc edits uncommitted in tree). 12:36 JST Andrew screenshotted a System 6 bomb "illegal instruction" in the native Toolbox Suite boot (TestToolboxSuiteOn68k, T2-only) — REGRESSION not caught by Task 5 (core suite only) or T1 smokes. Task 7 agent HALTED; crash debugger dispatched on opus (systematic-debugging; bisect 856d1d1/3e97204/5efc3f5/9549634/8b8e8e2; report crash-report.md).
Crash: close-out agent evidence — failing test is TestToolboxSuiteJiggleOn68k (heap-layout jiggle variant), 3/3 LaunchAPPL timeouts; PASS at main 8b8e8e2 and Task 4 tip 3e97204; Task 5 tip inconclusive → first-bad ∈ {2084ccc, 607c2fa}. Forwarded to the debugger. Task 7 agent halted with doc edits + ../68kbbs/docs/{language-gaps,fidonet}.md edits uncommitted.
Crash: RESOLVED by debugger (opus) at 4bc0a07 — root cause PRE-EXISTING: runtime/clarus/uitext.cla rtUiTeWidestLine captured the TEHandle master pointer, then called rtUiGetPortSaved() (UiNewPtr → CompactMem under jiggle) and kept dereferencing the stale pointer → garbage GrafPtr → QuickDraw JSR through bogus grafProcs (illegal instruction). Plain TestToolboxSuiteOn68k never failed; only the Jiggle twin. No first-bad commit — byte-identical code segments land on both sides of the coin flip; Task 5 merely re-rolled the layout. Andrew's "SETTEXT"/widget screenshots were the debugger's temporary markers (reverted). Fix: hoist the allocating call above the deref + warning comment; 17 other call sites audited clean. Verified: ToolboxSuite + Jiggle 32/32, CoreSuiteGUI 79/79, UI scenario goldens unchanged, T1 --smoke PASS. Goldens: 14 emitui + 3 cg68k seg2 — one statement moved (normalized). Follow-up (TODO): a core-suite jiggle twin.
Crash: Ruling: the uitext.cla fix ships in THIS branch (it is what makes T2 green) and is recorded in HISTORY as a latent-bug find of the layout-sensitive class, not a filesystem-api defect. Cost if wrong: none — the fix is a strict ordering correction.
Crash fix 4bc0a07: review (sonnet) Approved, no Critical/Important; minors: crash-report tally says uiwidgets ×6 (actually 7, all safe); scenario subtest list omits smoke_bounce (covered by TestSmokeBounceOn68k). No fix round needed.
Task 7: resumed at 14:16 (docs first, gates last, foreground pieces)
Task 7: implementer DONE at af10374 (T2 PASS all 5 pieces incl. Jiggle; 68kbbs edits uncommitted per ruling; Snow obligations recorded)
Task 7: review (sonnet): ❌ 4 Important (doc accuracy) — CLAUDE.md "79 real" should be 78 real; 68kbbs language-gaps.md:220 `data.crc16x` → `t.crc16x`; files.cla dirNFErr comment misattributes a phrase to Files.h; HISTORY/STATUS omit Task 2/3 emitui reblesses. Minor (folded into the fix for cost reasons): STATUS "six" vs seven coverage gaps; task-7-report cg68k count 49→50+1.
Task 7: minor (deferred): STATUS.md lacks a "how to run the new file.* surface" pointer (CLAUDE.md covers suites generically).
Task 7: fix round 1/5 dispatched (resume implementer)
Final whole-branch review dispatched on opus (package final-8b8e8e2..HEAD.code.diff + final-goldens.txt; triages ledger deferred/parked items) — in parallel with Task 7 fix round 1 (doc-only).
Task 7: fix round 1/5 (4 addressed per implementer + 2 cheap corrections; commit 5d94818; re-review pending)
Task 7: fix round 1/5 re-review: 4+2 addressed, 0 open
Task 7: complete (commits 856d1d1..5d94818 incl. crash fix 4bc0a07, review clean after 1 fix round; T2 PASS at af10374, doc-only commit since)
Final review (opus, 5d94818): READY WITH FIXES. Verified --rtbake / --rtbake --testapi / nested-cwd bake paths byte-equivalent; path hook covers every entry; PB addressing matches hardware; no held master pointers in new native code; goldens as ledgered. Important: (1) native info("")/exists("") synthetic hit zeroes every field but isDir while host stats "." — undocumented; (2) host rename(newName with ':') silently MOVES (path_to_cstr translates it) while native fails bdNamErr — reference says leaf name only; fix = reject ':' in rtFhRename at the fileh.cla waist. Minors: inverted comment drive.cla:1520-1524; DirOps teardown misses b.dat; FhHSetTimes clobbers rt_fh_stat_buf; rtFhDevSetInfo/Create ignore rtFourCC -1 overlong sentinel; host >255 name/path silent truncation; rtFhList leaves names partially filled on mid-listing failure; catalog driver doesn't bind the new consts. Blocking (already recorded): System 7 spot check; TestClarusCBakePathOnSnow. Triage: all ledger deferrals AGREE/FINE TO DEFER; three already fixed.
Final: ONE fix wave dispatched (sonnet): Importants 1-2 + minors 3,4,5,6,8,9 + HISTORY note that spec §6's two named risks were non-issues; minor 7 (host truncations) deferred to TODO.
