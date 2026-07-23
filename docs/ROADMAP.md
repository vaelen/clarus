# Clarus Roadmap

Living document — the authoritative sequencing and strategy record. Updated
2026-07-22. The per-task execution history lives in `.superpowers/sdd/progress.md`
(gitignored scratch; git history is the durable record).

## Done (all merged to main)

1. **Language reference** (`docs/clarus-language-reference.md`) — the living,
   normative spec. The design spec (`docs/superpowers/specs/…`) is historical
   rationale; where they disagree, the reference wins.
2. **Front end** — `clarus check`: lexer, parser, checker (`internal/…`).
3. **IR + host backend** — `clarus build` / `clarus run` on the host; typed IR
   with abstract intrinsics (no libc concepts); portable C host runtime
   (`internal/build/rt/`); golden harness (`testdata/run`, `testdata/runerr`);
   reference-fence check suite (`internal/reftest`, index manifest).
4. **CLI/self-hosting language features** — break/continue, switch (desugared
   to if-chains in lowering), const (inline-lowered), slices `s[start,len]`,
   indexOf, text.append, `App.startCLI(args)` with startEmpty fallback, log,
   `quit [code]`, binary-faithful file I/O guarantee, sorted-by-key map
   iteration (Option B — binary-search host map; Mac layout: key-sorted
   offset table over packed arena, no hashing).

## Decided sequencing (REORDERED from the older plan docs' roadmap notes)

The user chose to pursue self-hosting BEFORE the Mac target, because clarusc
development is fully host-testable and will surface language defects that
should be fixed before the Mac runtime freezes contracts. The older plans'
"Roadmap context" sections predate this reorder — this file wins.

**Decided 2026-07-23: clarusc is next.** The order is:

1. **clarusc** — the compiler written in Clarus, developed host-side against
   the Go compiler with differential testing, through the three-stage
   bootstrap and the committed C snapshot (strategy below).
2. **Mac target** (4a "hello, Macintosh", then 4b windows/menus/events).
3. Memory + forms runtime, then networking.
4. clarusc's 68k build — compiling Clarus on a Macintosh — once the Mac
   target exists.

## clarusc / self-hosting strategy (agreed in discussion, 2026-07-22)

- The Go compiler remains the bootstrap + reference implementation. It must
  track the language only until clarusc reaches self-hosting; after that it
  freezes at the bootstrap-subset level (kept for differential testing).
- **Bootstrap chain:** Go compiler compiles clarusc.cla → stage1; stage1
  compiles clarusc → stage2; stage2 compiles clarusc → stage3; stage2 and
  stage3 outputs must be byte-identical (fixed point). CI-able.
- **C snapshot as interlingua:** commit clarusc's own generated C
  (`clarusc.c`) at releases — buildable by any C compiler with no Go and no
  prior Clarus binary. This is the ground-floor bootstrap; it means the Go
  compiler does NOT need indefinite maintenance. Each release's snapshot is
  built by the previous release (Go's compiler-lags-language discipline).
- **Conservative subset rule:** clarusc's own source avoids new language
  features for at least one release cycle, keeping the bootstrap chain wide.
- **Differential testing:** both compilers build the full golden/fence corpus;
  outputs must agree.
- **AST idiom:** Clarus has no recursive types — clarusc uses arena style
  (`list of Node` + int indices for child links). Deliberate, period-authentic.
- **Cross + native:** one clarusc source; host printer build = modern
  cross-compiler; 68k printer build (after Mac target) = compiling on the Mac.
  The Mac-resident version is a GUI app (askOpen/alert), not a CLI.

## Mac target (Plan 4, when taken — suggest splitting)

- **4a "hello, Macintosh":** Toolbox runtime implementing the same intrinsic
  ABI (Handles, BlockMove, real Str255), Retro68 pipeline
  (`/Users/andrew/repos/Retro68-build/toolchain` — note: built toolchain is in
  Retro68-build, NOT the Retro68 source dir), `clarus build --mac`, alert-only
  program in Mini vMac. Proves the printer seam.
- **4b windows/menus/events:** UI declaration lowering (WIND/MENU/CNTL/DITL
  resources), WaitNextEvent runtime, window instances, canvas. Acceptance:
  the two Appendix C examples as double-clickable System 7 apps. Test loop is
  the weak point (emulator automation) — plan needs a testing-strategy section.
- Then: memory+forms runtime (real Handles, binding walker, List Manager,
  Standard File, file.save/load), then networking (MacTCP + ADSP/NBP; needs
  Basilisk II or real hardware — Mini vMac networking is limited).

## Small open items (not yet scheduled)

- `clarus run prog.cla -- args…` pass-through: DONE (clarus-run-dashdash).
- **Lexer diagnostic quality (FOLLOW-UP, deferred — decided 2026-07-23):** a
  bad escape inside a double-quoted string (e.g. `"a\qb"`) should report
  `invalid escape sequence`, NOT `unterminated string literal` — the literal
  is well-formed, only the escape is wrong. AND it should not cascade a second
  spurious `unterminated string literal` from the eager `lexAll` scanning past
  the error to EOF (Go's lazy lexer stops once the parser fail-fast aborts;
  clarusc's eager lexer does not). Fixing the message is small; fixing the
  cascade is architectural (lazy/on-demand lexing, or truncate lexer diags
  after the first at an offset). Land BOTH together with a triggering fixture,
  since adding the fixture before the fix turns the differential red. Both
  compilers currently agree via `'\q'` (char literal); the double-quoted-string
  shape is corpus-untriggered. See internal/selfhost/inventory.md.
- `text + char` concatenation does not exist (append accepts char; `+` does
  not). Deliberate for now; revisit if it keeps surprising. (`char + string`
  and `string + text` WERE added 2026-07-23 — see the reference Ch4.)
- Parking lot (deferred features, from the design spec §14 + later
  decisions): HTTP layer, UDP/DDP, auto-generated forms, float/SANE,
  case-insensitive maps, handle-backed map values, printing, color QuickDraw,
  labeled break, const arithmetic, `switch` on text, substring/indexOf as
  library code conventions for clarusc.

## Process conventions that worked (for future sessions)

- Doc-first: reference updated and committed BEFORE implementation plans;
  the reference is the compiler's contract.
- Subagent-driven development with per-task review gates and a whole-branch
  final review (most capable model) + one consolidated fix wave; reviews
  probe (compile/run/ASan), not just read.
- Feature branches per plan; main stays green; reftest may be red mid-branch
  when the reference gains fences for unimplemented features (manifest
  regeneration is always the branch's final task).
- Golden outputs are hand-computed before running, then reconciled.
