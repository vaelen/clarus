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
