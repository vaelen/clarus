# Fallback-Trigger Narrowing — Design

Date: 2026-08-13. Status: **DONE (2026-08-13, branch
`fallback-trigger-narrowing`, commits `fa59108..4d1beb4`)** — see the
ROADMAP `fallback-trigger-narrowing` entry and
`.superpowers/sdd/2026-08-13-fallback-trigger-narrowing/progress.md` for
the task ledger. The annotation below (Task 2/4, 2026-08-13) marks the one
claim the implementation narrowed; the design otherwise landed as
approved.
Originally: approved by Andrew (brainstorm session, this date).
Successor to the runtime-ir-bake phase (merged to main at `b16e8f0`);
resolves that phase's recorded debt item "include-dedup fallback trigger
too broad" (ROADMAP runtime-ir-bake entry, STATUS next-steps).

## Problem

On the bake path (`--rtbake`, and therefore ClarusC.APPL's default), a
user `include` that resolves to any file the bake carries — the 18
runtime modules or their nested includes, notably
`toolbox/{files,standardfile,appleevents}.cla` (pulled in via
`uidialogs.cla` and `ui.cla`) — triggers an unconditional from-source
fallback for that compile (drive.cla's `bkManifestHoistHit`,
runtime-ir-bake Task 5(b)). Correct and logged, but the whole compile
loses the bake, and the trigger hits exactly the users the toolbox
cookbook tells to compose those catalog files. The fallback exists for
one reason: the bake has no live scope/AST to make a collided module's
symbols visible to the user's check#1 the way from-source's hoist-dedup
does.

## Mechanism: check-only include

From-source handles the same double-include today by parsing the user's
copy into the user chain (check#1 sees it in user position), then
hoist-deduping at splice time so exactly one copy is lowered, in
runtime-chain position. The bake path will mirror that by construction:

- On a manifest collision with `--rtbake` active and the drift guard
  passing (below): parse the user's included file into the user chain
  normally — check#1 sees its declarations, diagnostics attribute to the
  real file — and mark the subtree check-only.
- Before lowering, drop the check-only subtree. The baked IR already
  contains that module's lowered form at the position from-source's
  hoist would produce. Neither path lowers a user-position copy; both
  paths check the same source bytes in the same position.

Byte-identity between `--rtbake` and from-source therefore holds by
construction — same shape of argument as the runtime-ir-bake phase's
superset-splice decision. Two assumptions are load-bearing and get a
probe task before implementation (Task 1):

1. **Checker-state parity.** Lowering of user code that CALLS into the
   collided module consumes checker tables built during check#1
   (extern tables, `typeArena`, `funcSigByDecl`-family). The check-only
   copy must populate them identically to from-source's user-position
   copy. Expected true (same source, same position, same checkReset
   lifecycle) — probe verifies on the toolbox suite composition.
2. **Exact drop.** Dropping the subtree at lowering must leave zero
   stray IR (no globals, no strLits, no extern-arena entries) from the
   checked copy. From-source's single hoisted copy defines the target;
   the full-corpus byte-identity gate is the oracle.

## Drift guard: per-module source hash

The check-only design trusts that the on-disk included file matches the
source the bake was generated from — and the bake stamp hashes
`clarusc.c`, not runtime sources (the accepted stamp-proxy gap). Guard:

- `--bake-ir` records, per manifest module, a 4-byte FNV hash of that
  module's source bytes (same `bkHashText` family as the stamp and the
  v4 body hash). CLIR format version bumps 4 → 5; loader refuses non-5
  with the existing clear message; `internal/bake` header/sanity
  fixtures update; artifacts are never committed, so no compat shim.
- On a user-include collision: hash the resolved disk file. Equal →
  check-only include, bake kept. Different → the existing from-source
  fallback, now scoped to provable staleness, with a log line naming
  the drifted file (`clarusc --rtbake: <path> differs from the baked
  copy; falling back to a from-source compile`).

This converts the fallback from "any collision" to "genuine drift
only", and partially closes the stamp-proxy gap for exactly the files
where it can bite silently.

Non-collision drift (a runtime module edited on disk but never included
by user code) remains covered only by the stamp proxy, unchanged — out
of scope here, recorded debt stays.

## testapi interaction

Under `--testapi` (UI programs), the early modules' checker symbols are
already preloaded into check#1's scope. A check-only copy would
double-declare. Resolution: when the collided module's symbols are
already visible via the preload AND the drift hash matches, dedup fully
(no check-only parse) — matching from-source's post-dedup state, where
one copy exists and user code resolves against it. A parity test
asserts identical diagnostics on both paths for a testapi program that
includes a collided catalog file (and for the redeclaration case, the
existing collision-parity test pattern applies).

> **[Task 2/4 annotation, 2026-08-13]** "Dedup fully (no check-only
> parse)" narrowed in implementation: `expand()` still lexes/parses the
> collided file into `combined` like any other include (it can't yet
> know this collision will resolve to case (b) — that needs `isUiProg`,
> which isn't known until Phase A finishes); only the excise from
> `combined`, right before `checkPhase1`, is new. The checker and
> lowering never see the collided decls — proven by the toolbox-suite
> corpus byte-identity gate, and by construction unable to reach the
> redeclaration diagnostic shape this section's own parity test
> anticipated (that shape only ever appeared under the probe wave's own
> hack, which disabled the real fix to prove it necessary in the first
> place; `TestRtbakeTestapiIncludeParity`'s doc comment records this).
> So "dedup" holds observably (checker-visibility, lowering, and
> byte-identity all match "one copy"), but "no parse" does not — the
> lex/parse cost is still paid on a file the checker/lowering discard.
> Judged a documented amendment over a bigger Phase-A restructure (see
> `.superpowers/sdd/2026-08-13-fallback-trigger-narrowing/task-2-report.md`,
> "Deviations from the brief" item 4, and its fix-round-1 writeup).
> Separately, this same task discovered and fixed a real, previously
> latent gap the ORIGINAL runtime-ir-bake preload left in this
> mechanism: case (b)'s excise-before-checker approach needs
> `check.cla`'s `fieldInfos`/`recFieldsHeadByName` side tables for any
> record-bearing early-visible module, which the original preload never
> baked (only `funcSigs`/`symbols`/`scopes`/`typeArena`/`enumMembers`)
> — a new `bkSecFieldInfo` section (format v5) closes it. See the
> ROADMAP `fallback-trigger-narrowing` entry for the full writeup.

Non-testapi programs never see baked checker symbols
(runtime-ir-bake invariant, unchanged): for them the check-only copy is
the ONLY source of the collided module's symbols, which is the point.

## Oracles and tests

- `TestBakeFullCorpusSuiteToolbox` flips from an explicit
  fallback-class test to a genuine bake-path byte-identity assertion
  (the Task 5 reviewer's original request) — the toolbox suite build
  must take the bake path (no-"falling back" assertion) and
  byte-equal from-source.
- New drift fixture test: bake, then modify a copy of a collided file
  (temp rtdir), assert the fallback fires with the drifted-file log
  line and the compile still succeeds from source.
- testapi parity test per the section above.
- Existing full-corpus identity gates, leak gate (check-only parse must
  not leak — DoubleCompile discipline), T1 --smoke, full T2 at tip.
- Standing rule applies: `bake.cla`/`macgui.cla` change in this phase →
  manual `TestClarusCBakePathOnSnow` rerun (CLARUS_SNOW_TESTS=1) before
  merge.

## Housekeeping (same phase, separate commit)

- `macgui.cla` fallback log taxonomy: the CLFS-fallback reason string
  (macgui.cla:485 area) currently omits the v4 body-hash reason; update
  it to enumerate the real refusal set (format/version/lane/stamp/body
  hash), and add the drift-fallback reason line this phase introduces.
- `cg68k.cla` tight-scratch cleanup: remove (or rename to honest names)
  the dead tight-to-tight scratch indirection
  (`cgFillTightScratchFromPaddedArr`/`cgDrainTightScratchToPaddedArr`),
  left self-documented after the stride-2 fix. Goldens must show zero
  churn if removal is behavior-preserving as expected; any churn is
  stop-and-investigate.

## Out of scope

- Extending the stamp to cover runtime sources globally (recorded
  longer-term item; the per-module hash covers the include-collision
  slice only).
- KArr param ABI, object-code/linker work (phase 3.5), and all other
  recorded debt.

## Shape

~4 tasks: (1) probe wave verifying the two load-bearing assumptions on
the toolbox suite composition; (2) mechanism + drift guard + format v5;
(3) oracles (toolbox test flip, drift fixture, testapi parity,
no-fallback assertions); (4) housekeeping + close-out (snapshot regen,
docs/debt-ledger updates, full T2, Snow rerun).
