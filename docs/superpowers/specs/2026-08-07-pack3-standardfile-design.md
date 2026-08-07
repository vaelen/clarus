# _Pack3 Standard File port + cprint-Mac demotion — design

Date: 2026-08-07. Supersedes
`2026-08-03-native-standardfile-pack3-design.md` per that spec's own
ROADMAP deferral note ("revise at implementation time if the new features
offer a cleaner shape") — it predates `extern record`, `callback func`,
extern dedup (toolbox-integration, 2026-08-04) and the Toolbox-first
guiding principle + `toolbox/*.cla` catalog (toolbox-cookbook,
2026-08-07). The 08-03 spec's marshaling analysis and verification
posture survive; its declaration placement does not. This phase also
folds in two decisions made at brainstorm time (Andrew, 2026-08-07):
demote the cprint/Retro68 Mac lane to an opt-in diagnostic, and add
include-path dedup to clarusc.

## Part A — include dedup by normalized path (clarusc)

clarusc's include-once set (`seenPaths`, `clarusc/main.cla`) keys the
raw path string, and `joinPath` is naive concatenation — so two
spellings of the same file (`include "sub/../common.cla"` vs `include
"common.cla"`, or a positional entry vs an include) load twice, and
duplicate declarations error out. Part C creates exactly this shape:
the runtime includes `toolbox/standardfile.cla` as
`<rtdir>/../../toolbox/standardfile.cla` while a user program may
compose the same file positionally as `toolbox/standardfile.cla`.

Change: a lexical `normalizePath` — collapse `//` and `./`, resolve
`seg/..` pairs, preserve leading `../` runs — applied to every path in
`expand()` before the `seenPaths` check (one shared map already covers
entry files and includes). Purely lexical: no symlink, case, or cwd
resolution; an absolute and a relative spelling of the same file remain
distinct (documented caveat — repo builds use relative paths
throughout, so this residue is theoretical; extern dedup is the
belt-and-braces if it ever bites).

Reference amendment (normative): the include-once paragraph's "identity
is the file's path" becomes "identity is the file's lexically
normalized path", with the abs-vs-rel caveat. clarusc change ⇒ snapshot
regeneration per the `TestSnapshotFixedPoint` procedure.

Probe result recorded: top-level function references are
order-insensitive (caller-before-callee checks clean), so include-once
retaining whichever copy loads first cannot break the combined
user+runtime chain.

## Part B — cprint-Mac demotion to diagnostic lane

Context (Andrew, 2026-08-07): the C printer's 68k role was a stop-gap;
its real remaining job is host builds (clarusc bootstrap, tools), which
never touch the Toolbox. The four Mac-lane emulator boots duplicate
detection the native twins already provide — every suite case, panic
fixture, and abort fixture still runs on hardware via
`TestCoreSuiteGUIOn68k`/`TestToolboxSuiteOn68k`/`TestRunErrOn68k`/
`TestAbortOn68k`. What the Mac lane uniquely provides is
*localization*: a native-only failure points at cg68k codegen, a
both-lane failure at runtime logic (this triangulation caught the
trailing-`bool` ABI bug, the 2B↔4B form hang, the `CharParameter`
marshaling bug). That is worth keeping as a tool, not as a per-merge
tax.

Change: a new gate helper `requireCprintMac(t)` — skips unless
`CLARUS_CPRINT_MAC_TESTS=1` — replaces `requireMac(t)` in every test
that needs the Retro68 **gcc/cmake build path**:

- `TestCoreSuiteGUIOnMac`, `TestToolboxSuiteOnMac` (coresuite_test.go)
- `TestRunErrOnMac`, `TestAbortAppsOnMac` (mac_test.go)
- `TestAppResNaming`, `TestAppResResources`, `TestAppResBundleBit`
  (appres_test.go — they verify build-mac.sh's own artifacts, so they
  ride the same gate)

Native-lane (`emit68k`) tests are untouched under `CLARUS_MAC_TESTS`.
`TestPbm2Icn*` is untouched (already ungated/host-side). T2
(`scripts/test-merge.sh`) needs no mechanical change — the demoted
tests now SKIP under it; its comment block and CLAUDE.md/ROADMAP get
the deprecation story (cprint-Mac = on-demand diagnostic oracle;
deletion of the lane, `rt_ext_mac.inc`, and `build-mac.sh` is 5f's
Retro68-retirement item, not this phase). Nothing is deleted here.

## Part C — the _Pack3 port, catalog-first, native lane only

The 08-03 spec's two-stub-bodies scope stands: `nat_UiSFGetFile`/
`nat_UiSFPutFile` (`runtime/clarus/uidialogs.cla`) become real; the
waist externs `UiSFGetFile(path255Out: ptr): bool` /
`UiSFPutFile(suggested255: ptr, path255Out: ptr): bool` keep their
declarations; the cprint lane keeps resolving them to its existing C
wrappers, byte-untouched (it is on the Part-B deprecation path — no
unification effort spent on it).

What moves: declarations live in the catalog, per the guiding
principle (fill the manager while there).

**New `toolbox/standardfile.cla`** — the classic System 6 _Pack3
surface, all verified against Apple Universal Interfaces
(`CIncludes/StandardFile.h` THREEWORDINLINE encodings + AIncludes), in
the established catalog citation style:

- `extern record SFReply` — the language reference's own worked
  example (§extern record): `good: bool` @0, `copy: bool` @1, `fType:
  int` @2, `vRefNum: word` @6, `version: word` @8, `fName: str[63]`
  @10; size 74, matching the 08-03 spec's scratch offsets slot for
  slot.
- `extern record SFTypeList` — four `int` (OSType) slots.
- `SFPutFile` (sel 0x0001), `SFGetFile` (sel 0x0002), `SFPPutFile`
  (sel 0x0003), `SFPGetFile` (sel 0x0004), each `= trap 0xA9EA sel N`
  (the clause the 08-03 spec verified emits exactly the
  `THREEWORDINLINE(0x3F3C, sel, 0xA9EA)` shape). `where` is `int`
  (Point by value — a 4-byte extern record decays to an `int` argument
  per the reference, so callers may pass a `Point` var directly).
  `SFGetFile`/`SFPutFile` are hardware-proven by this phase's
  live-drive; `SFPPutFile`/`SFPGetFile` are declaration-only with
  citations (modal dialogs cannot be auto-driven on System 6 — the
  08-03 spec's investigation stands).
- A `Str255`-buffer extern record (`s: str[255]`) for prompt strings —
  declared here as its first consumer; moves to a shared types catalog
  file when a second consumer appears.
- System 7 `StandardGetFile`/`CustomGetFile` (sel 5–8): out, as
  before (S6-first; Gestalt-gate them in a future phase if wanted).

**New minimal `toolbox/files.cla`** — `PBSetVolSync(pb: ptr): int =
trap 0xA015 reg(a0: pb) ret d0` plus a `VolumeParam` extern record
(`pad[N]` runs for untouched filler, real fields through `ioVRefNum`
@22), replacing the 08-03 spec's private `UiSetVolPB`. Deliberately
thin: the full File Manager fill belongs to a future file-abstraction
phase; the file's header says so.

**Runtime consumption**: `uidialogs.cla` gains `include
"../../toolbox/standardfile.cla"` + `.../files.cla` (include paths
resolve relative to the including file; the rtdir splice runs runtime
modules through the same `expand()`, which already anticipates
multi-file runtime modules). The stub bodies become the 08-03 spec's
transcription, minus scratch arithmetic: an `SFReply` var (decays to
`ptr` at the call site), an `SFTypeList` var holding `'TEXT'`, a
`Str255` var assigned `""`/`"Save as:"`, `where` = `(100 << 16) | 100`.
On `good`: `PBSetVolSync` with the reply's `vRefNum` (result ignored,
matching the C reference), copy `fName` into `path255Out`
(implementation picks the existing Pascal-string helper or byte pokes —
plan-level detail), return `true`; else `false`. Error surface
unchanged from 08-03: the bool is the only result, `lastError`
untouched, cancel ≡ today's stub behavior so no caller regresses.

Task-1 verification item: the composed orderings — user program that
positionally composes `toolbox/standardfile.cla` while the runtime
includes it (post-Part-A, one copy loads) — check clean through
`checkProgram`, including `extern record` and const decls, on both
emit lanes.

## Verification

1. **Part A**: include-dedup fixture (same file reached via two
   spellings; would be a duplicate-decl error today) wherever existing
   include fixtures live; snapshot fixed-point regen; full T1.
2. **Catalog**: `internal/testsuite/catalog_test.go` grows the two new
   files (T1, host-side standalone check).
3. **Listing goldens pin the call shape** (08-03 posture): one
   `CLARUS_CG68K_BLESS=1` re-bless; the `MOVE.W #$000N,-(SP)` +
   `DC.W $A9EA` shapes eyeball-checked against the THREEWORDINLINE
   encoding before any boot (a wrong selector crashes real hardware).
4. **Scripted lane frozen**: the four frozen golden scenarios + both
   native suite gates stay green (native never blesses).
5. **Part B rehearsal**: one T2 run showing the seven demoted tests
   SKIP; one `CLARUS_CPRINT_MAC_TESTS=1` run of the demoted set
   showing they still pass under the diagnostic gate.
6. **Live-drive acceptance** (the 4c standard, unchanged from 08-03):
   native texteditor in Mini vMac — type, Save through the real
   SFPutFile dialog, quit, relaunch, Open through the real SFGetFile
   dialog, verify content roundtrip; Cancel on each dialog verified as
   a clean no-op.

## Non-goals

- Deleting the cprint-Mac lane, `rt_ext_mac.inc`, or `build-mac.sh`
  (5f: Retro68 retirement).
- TE↔Scrap port, AE/GetAppFiles launch (recorded 5e limits).
- System 7 StandardFile variants; any modal-dialog driving harness.
- Full File Manager catalog fill.
- Symlink/case-aware path canonicalization (lexical only).

## Files touched

- `clarusc/main.cla` (normalizePath + expand hook), `clarusc/clarusc.c`
  (snapshot regen), include-dedup fixture + its test.
- `docs/clarus-language-reference.md` — include-once identity wording.
- `internal/mactest/{mac,coresuite,appres}_test.go` —
  `requireCprintMac` swap; `scripts/test-merge.sh` comment.
- `toolbox/standardfile.cla`, `toolbox/files.cla` (new);
  `internal/testsuite/catalog_test.go`.
- `runtime/clarus/uidialogs.cla` — includes + 2 stub bodies real.
- `testdata/cg68k/*.s` — golden re-bless fallout.
- `CLAUDE.md`, `docs/ROADMAP.md` — deprecation story + phase record.

## Outcome (2026-08-07)

Shipped on branch `pack3-standardfile` (Tasks 1-6 + two unplanned tasks),
all gates green. Deltas from the design above, discovered in flight:

- **Task 5a (unplanned): the Gestalt register-binding correction.** T2's
  first rehearsal failed `TestToolboxSuiteOn68k/Catalog` ("gestalt err
  0"). Root cause was NOT this phase's code and NOT the initially
  suspected cg68k segment bug: every Clarus Gestalt transcription bound
  the response pointer per Gestalt.h's `#pragma parameter` — but the
  pragma describes Apple's TWOWORDINLINE glue (`0x2288` = `MOVE.L
  A0,(A1)`), not the raw trap, which answers in A0. Split into
  `GestaltErr (ret d0)` / `GestaltValue (ret a0)`; assertions hardened
  from `!= 0` (which passed on uninitialized heap for weeks) to a BCD
  version range; the previously "non-reproducible" cg68k shape-corruption
  bug and the "Mini vMac Gestalt is broken" lore both resolved as
  artifacts of the same misbinding. The demoted cprint lane served as the
  localization oracle on day one of its demotion.
- **Task 6a (unplanned): native FInfo stamping.** Live-drive found saves
  landing with blank type/creator (pre-existing 5e file-layer gap,
  unobservable before a working SFGetFile filter). natFileWriteText now
  stamps `'TEXT'`/`'MPS '` via PBSetFInfoSync after a successful create —
  byte-parity with the C lane; `toolbox/files.cla` grew
  PBGet/SetFInfoSync + FileParam. Residual (recorded, out of scope):
  native `file.save` stamps `'TEXT'`/`'MPS '` vs the C lane's
  `'CLRD'`/app-creator.
- Verification outcomes: T2 236s (~10x faster post-demotion), all seven
  demoted tests SKIP by default and PASS under `CLARUS_CPRINT_MAC_TESTS=1`;
  listing goldens carry the `MOVE.W #sel,-(SP)` + `DC.W $A9EA` shapes
  (eyeballed before any boot); live-drive roundtrip proven on screen and
  by host-side `hdir` (`rt2` = `TEXT/MPS `, 8 bytes, content identical
  after relaunch; Cancel clean no-op on both dialogs).
