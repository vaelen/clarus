# SDD ledger — plan: docs/superpowers/plans/2026-08-27-extern-ptr-call.md

Branch: extern-ptr-call (from main @ 74c9e46). Spec:
docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md (read).
Ruling: work on the branch in the main checkout, no separate worktree —
Retro68/toolchain/macplus symlinks and build caches don't travel to
worktrees; every prior phase did the same. Costs if wrong: dirty-tree risk,
accepted.

## Preflight conflict scan

| Pair / task | Produces vs consumes | Finding |
|---|---|---|
| T1→T2/T3/T4 | conv flag 10, checker guarantees (≥1 param, param0 ptr) | consistent (value 10 everywhere) |
| T2→T3 | testdata/lowlevel/ptrcall_host.cla reused as T3's emit68k smoke | CONFLICT: plan's fixture declares NewPtr/DisposePtr clauseless (callback_host precedent, host-only); native lane aborts on clauseless externs (cgCallExtNatFallback: "no trap clause and no nat_ fallback", cg68k.cla:10517). See Ruling 1. |
| T3→T4 | cgCallExtPtr conv-10 arm | consistent; pokel/peekl have native arms (cgIntrPeek/cgIntrPoke, cg68k.cla:6637/6656) — verified |
| T4 internal | casePtrCall(): TestResult, tkPass/tkFail, string(r), word→int widening | consistent with kit.cla + binary-files string(n) |
| T1 internal | Bad4/Bad5/Bad6 expect stray-token parse errors | consistent with Global Constraints (grammar-level suffix rejection) |
| T5/T6 | docs only / close-out | no interactions |

Ruling 1: Task 2's fixture declares `external func NewPtr(size: int): ptr =
trap 0xA11E reg` and `external func DisposePtr(p: ptr) = trap 0xA01F reg`
(verbatim from runtime/clarus/list.cla:118 family) instead of the plan's
clauseless forms — host emission is unaffected (rt_ext_<name> regardless of
clause), and the same file then assembles under emit68k for Task 3 Step 4.
Costs if wrong: none foreseen; host shim resolution is name-keyed.

Task 1: minor (deferred): check.cla:3074-3076 comment says suffix exclusivity is enforced "alongside" checker rules; actually parser-level. Wording only.
Task 1: complete (commits 74c9e46..c9c2d4f, review clean)

Task 2: minor (deferred): fpExternIdxByName (cprint.cla:1585) duplicates irExternLookup (ir.cla:1036); plan-mandated mirror of cgCallExt's own precedent. Ruling: keep as-is for now — final review triages; if flagged there, converge fpExternIdxByName (and optionally cgExternIdxByName) onto irExternLookup in the final fix wave. Costs if wrong: ~10 duplicated lines.
Task 2: complete (commits c9c2d4f..5f8d225, review clean)

Task 3 note: implementer found build-68k.sh Step-1/4 recipe hits the stale
committed snapshot (same pitfall the plan only patched for Task 4's host
run); routed around it via the two-stage current-source bootstrap. Plan
defect, self-corrected — carry to Task 4: any manual compile of new-syntax
code must use the current-source compiler, not the bare snapshot bootstrap.

Task 3: minor (deferred): cgCallExtPascal's doc block now sits fused above cgPushPascalArgs, misattributing result-pop/no-ADDQ claims (cgCallExtPtr DOES ADDQ); cgCallExtPascal left doc-less; split/move the paragraphs.
Task 3: minor (deferred): result-slot + 3-arm readback duplicated between cgCallExtPascal and cgCallExtPtr (drift-prone site with bug history); extract cgPascalResultSlot/cgPascalResultReadback.
Task 3: minor (deferred): cgPushPascalArgs comment says "arg node `a`", param is `a0`.
Task 3: ⚠️ resolved: Step-1 failure-mode deviation = the ledgered build-68k snapshot plan defect, disclosed + routed around; not a gap.
Task 3: ⚠️ resolved→Ruling 2: bool/char RESULT readback arm (LSR.L #8, historic bug site) unproven by the planned Task 4 case (word result only). Ruling: Task 4's case adds a second `= ptr` extern + bool-returning callback round trip (true and false both asserted). Costs if wrong: slightly larger case; coverage only gains.
Task 3: complete (commits 5f8d225..0ae201d, review clean)

Task 4: complete (commits 0ae201d..8fa24f7, review clean). Native boot green: PASS PtrCall, TOTAL 80/80. Implementer additionally bumped core_cli_test.go wantCases + coresuite_test.go wantCoreSuiteCases (necessary, reviewer-verified complete via grep). nCoreCases now 80 (79 real + SelfCheck) — Task 6's CLAUDE.md update must say 80 cases: 79 real + SelfCheck.

Task 5: minor (deferred): closing example uses undeclared `pb` with no comment (reference :1873-1882, cookbook :130-138; inherited from the spec's own example) — add a one-line comment like `h`'s.
Task 5: complete (commits 8fa24f7..929bd15, review clean)
Ruling: Task 6 (gates + close-out) runs before the final whole-branch review per plan order; if the final fix wave later touches clarusc/*.cla, that fix dispatch must regen the snapshot and re-run the affected gates. Costs if wrong: one redundant snapshot regen.

Task 6 note: internal/reftest's CheckClean fence gate caught the Task 5
deferred minor (bare statements + undeclared pb in the closing example) —
fixed in-task (function-wrapped, mirrored to cookbook, manifest indices
shifted). Task 5 minor: RESOLVED.

Task 6: complete (commits 929bd15..24faf57, review clean). Gates: snapshot fixed-point PASS, T1 PASS, T2 PASS 345s. Reftest fence fix folded in (root-cause, disclosed).

Final review (opus): READY WITH FIXES.
- Important 1: host cast lacks CLAR_PASCAL — Retro68/cprint Mac lane gets C-convention call through pascal pointer (silent stack corruption; OnMac opt-in gate would go red). FIX PRE-MERGE. Wrinkle: CLAR_PASCAL #define lives under cpEmitCallbackGlueProtos' glue-count guard — must be hoisted for callback-free = ptr programs.
- Important 2 (= deferred minor 3): fused/misattributed cg68k doc block; FIX PRE-MERGE with minor 5 (a/a0 word).
- Minor: void-return/zero-param native arm unproven (add PtrCallVoid check); "strictly conforming" overclaim in fixture+spec; scratch leak on tkFail paths; manifest.go header sentence deletion.
- Triage: check.cla wording stays deferred; fpExternIdxByName triplication → TODO.md line (no code change); readback duplication stays deferred.
Ruling: fix wave = Important 1+2, minor 5(word), PtrCallVoid coverage, overclaim wording (fixture+spec), scratch-leak hygiene, TODO.md helper-dup line. Parked: check.cla "alongside" wording (comment nuance, truth already present in-line); manifest.go header sentence (its own "line numbers drift" note covers it). Costs if parked wrong: none functional.

Fix wave: commit cac7ff1 (all 6 items). Gates: snapshot PASS, T1 --smoke
PASS, On68k boot PASS 80/80 (PtrCall green incl. new void arm), T2 PASS 346s.
OnMac cprint twin (opt-in Fix-1 proof) FAIL — controller-verified
pre-existing: ae662a3 (2026-08-22, predates branch base 74c9e46) broke
runtime/mac/rt_ext_mac.inc for that lane ('*/' comment bug per fix report);
branch never touches that file (empty diff 74c9e46..HEAD). Fix-1 proof on
that lane rests on emitted-C evidence (CLAR_PASCAL present on casts) in the
fix report. Ruling: OnMac breakage is main's, out of scope; surfaced to
Andrew at finish — the demoted diagnostic lane has been silently broken
since 2026-08-22. Costs if wrong: the cprint-Mac lane stays red until fixed
on main; native lane fully proven regardless.
