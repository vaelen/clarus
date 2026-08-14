package reftest

// CheckClean lists the indices (into ExtractFences' result, document order)
// of ```rust fences from docs/clarus-language-reference.md that check clean
// standalone under clarusc. Built by running clarusc's check mode over
// every fence and keeping every index that passed as-is; see
// internal/reftest/reftest_test.go's TestCheckCleanFences, which is the
// single fence-cleanliness gate covering this whole manifest.
//
// Most fences are fragments lifted mid-explanation — bare statements with no
// enclosing declaration, or references to a record/window/menu/enum/func
// declared earlier in prose but not repeated in the fence — so they don't
// parse or check standalone. That's expected, not a bug; each excluded index
// below has a one-line reason. The four full worked programs (Chapter 1
// example, Chapter 11 bounce, Appendix C bookmark manager, Appendix C text
// editor) are all in this list; TestRequiredProgramsInManifest guards them.
//
// NOTE on line numbers below: after the attempt-abort phase's Task 8 doc
// pass (which added prose and two fences throughout this file), the
// "(line M)" annotations below are approximate/stale for entries above the
// insertion point that follow it in document order — same as every prior
// doc-only edit in this file's own history (see the shift narrative further
// down): only the INDEX numbers are load-bearing (cross-referenced by other
// comments and, transitively, by CheckClean itself) and those are kept
// exactly correct; line numbers are not re-verified after every edit.
//
// Excluded, references a file that doesn't exist on disk (the include
// subsection's own example — an include is only ever a fragment, since the
// file it names is never included in the reference itself):
// 1  (line 80): include "geometry.cla" — no such file
//
// Excluded, fragments with no enclosing declaration (bare statements at top
// level, where only record/enum/const/var/func/window/menu/extend/on/every
// are valid):
// 4  (line 208): bare statements — indexing/in-place-assignment fragment
// 5  (line 219): bare statement — string concat fragment
// 8  (line 247): bare statements — byte-copy fragment
// 16 (line 431): bare statement — assignment fragment
// 19 (line 463): bare statement — truncating-assignment fragment
// 21 (line 490): bare statement — assignment fragment
// 22 (line 499): bare call-statement fragment — also references undeclared var conn
// 23 (line 512): bare if/else-if/else fragment
// 24 (line 527): bare while fragment
// 25 (line 540): bare for-in fragment (list form)
// 26 (line 549): bare for-in fragment (map form)
// 27 (line 557): bare for-in fragment (range form)
// 30 (line 590): bare open-statement fragment
// 31 (line 602): bare close-statement fragment
// 32 (line 612): bare edit-statement fragment — also references undeclared EditPerson, Person
// 35 (line 644): bare closeRequest-handler fragment — unknown event outside a window extend block
// 36 (line 656): bare while fragment — break-inside-loop example
// 37 (line 671): bare switch-statement fragment — references undeclared var tok
// 50 (line 947): bare property-assignment fragment (File.Save.enabled = false)
// 52 (line 997): bare edit-statement fragment
// 54 (line 1027): bare table-widget-declaration fragment (table outside a window)
//
// Excluded, references a name declared only in surrounding prose, not in
// the fence itself:
// 12 (line 300): undefined: EventKind (enum shown elsewhere in the chapter)
// 13 (line 365): undefined: EventKind (const example; enum declared elsewhere)
// 14 (line 411): undefined: Person
// 15 (line 420): undefined: Person
// 20 (line 478): undefined: Person (func param type)
// 28 (line 570): undefined: Person (func param type)
// 29 (line 577): undefined: Person (func param type)
// 40 (line 691): undefined: Type — func skeleton uses placeholder type names
// 41 (line 699): undefined: Person (func param type)
// 43 (line 776): undefined: compile — startCLI example calls a function shown nowhere
// 50 (line 923): undefined: File (menu extend block, menu declared elsewhere)
// 51 (line 933): undefined: Doc (window extend block, window declared elsewhere)
// 53 (line 961): form for names an undefined record: Bookmark
// 55 (line 1013): undefined: EditForm (window extend block)
// 57 (line 1046): undefined: Main (window extend block)
//
// Excluded, Chapter 13 fences that are fragments rather than complete
// top-level declarations (same fragment/prose-reference classes as above,
// just from the ptr/peek-poke/overlay-record/extern-record section added
// after the fence set below was first drafted):
// 64 (line 1330): peek/poke — bare pokeb/pokel call statements after the
// var decls, not a valid top-level form (same bare-statement-fragment
// class as indices 4/5/8/16/19/21 above).
// 66 (line 1363): overlay records — func f's body interleaves var decls
// with statements (var n; h.rc = 5; h.data = p; var back; var same) for
// expository clarity, genuinely violating "local variables ... are
// declared at the top of the body before any statement" (see the
// reference's variable-scoping prose) — a real check-time error, not a
// missing-context fragment. Reordering the example to check clean is a
// content change out of scope here.
// 69 (line 1447): extern record — waitClick usage example calls
// UiWaitNextEvent/nilPtr/handleAt, none declared in the fence itself
// (same "references a name declared only in surrounding prose" class as
// 12-15, 20, 28, 29, 40, 41, 43, 50, 51, 53, 55 above).
//
// Indices 66-69 (Task 2, native-5d: trap/inline clause examples) shifted
// the two Appendix C programs from 66/67 to 70/71; index 70 (Task 4,
// native-5e: the `word` extern type example) then shifted them again, to
// 71/72; Task 15 (native-5e, Ch13 doc pass: `reg memerr`, `trap ... sel`,
// `inline a5`) added three more fences interleaved among the existing
// trap/inline ones, shifting them to 74/75; Task 1 (toolbox-integration
// Feature A: named `reg(...)` clause, the named-reg worked example)
// added one more fence right after the `reg memerr` example, shifting
// them to 75/76; Task 3 (toolbox-integration: identical-signature extern
// dedup, the `TickCount` repeated-declaration example) added one more
// fence right after `inline a5`/CurrentA5, ahead of the `word` extern
// type section, shifting them to 76/77; Task 4 (toolbox-integration
// Feature B: `extern record`) added three more fences (Point/EventRecord/
// SFReply declarations; a waitClick usage example; a commented
// whole-value-restrictions example) right after Overlay Records, ahead of
// Trap and Inline Clauses, shifting them to 79/80; Task 7 (toolbox-
// integration Feature C: `callback func`) added two more fences (a
// declaration + decay + direct-call worked example; a commented
// decay-misuse/direct-call restrictions example) right after `extern
// record`, ahead of Trap and Inline Clauses, shifting them to 81/82 -- see
// the Chapter 13 block below, inserted right after the existing Chapter 13
// CheckClean entries, ahead of Appendix C in document order.
//
// attempt-abort phase Task 8 (close-out doc pass) added TWO new fences —
// both complete, self-contained, and check-clean — right after the
// existing Chapter 5 "Switch" fence (old index 37) and before what was
// Chapter 6's own first fence (old index 38): a basic attempt/aborted
// worked example (`loadConfig`/`startup`), and a nested-attempt/re-abort
// worked example (`riskyStep`/`run`). These landed at NEW indices 38/39.
// Every fence at OLD index 38 or higher shifted by +2 as a result --
// confirmed by content-matching every pre-existing fence body against the
// post-edit document (unchanged bodies, uniform +2 shift, zero reordering)
// rather than assumed. This shifted the two Appendix C programs a final
// time, from 81/82 to 83/84.
//
// Chapter 13 (ptr type, peek/poke builtins, external func declarations
// including trap/inline clauses, overlay record declarations, extern
// record, callback func, the word extern type): these fences post-date the
// deleted Go compiler, which could not parse this syntax at all -- they
// were tracked separately as ClaruscOnly until the Go-compiler-deletion
// phase (2026-08-05) removed the only reason for a second manifest, and
// were merged into CheckClean here (all indices except the three fragment
// exclusions documented above).
// 62 (line 1300): ptr basics — conversion, arithmetic, comparison
// 63 (line 1310): ptr container restriction (list of ptr, commented)
// 65 (line 1346): external func
// 67 (line 1387): overlay records restrictions (container/field, commented)
// 68 (line 1398): extern record — Point/EventRecord/SFReply declarations (Task 4, toolbox-integration Feature B)
// 70 (line 1457): extern record restrictions (assign/field/container, commented) (Task 4, toolbox-integration Feature B)
// 71 (line 1467): callback func — declaration + decay + direct-call worked example (Task 7, toolbox-integration Feature C)
// 72 (line 1484): callback func restrictions (decay-misuse/direct-call, commented) (Task 7, toolbox-integration Feature C)
// 73 (line 1503): trap/inline clauses — trap pascal (TickCount)
// 74 (line 1513): trap/inline clauses — trap reg (BlockMove)
// 75 (line 1519): trap/inline clauses — trap reg memerr (SetHandleSize) (Task 15, native-5e)
// 76 (line 1525): trap/inline clauses — trap reg(...) named form (PostEvent) (Task 1, toolbox-integration Feature A)
// 77 (line 1534): trap/inline clauses — trap sel SELECTOR (LAddRow) (Task 15, native-5e)
// 78 (line 1540): trap/inline clauses — inline deref (HandleToPtr)
// 79 (line 1546): trap/inline clauses — inline nop (DebugBreak)
// 80 (line 1552): trap/inline clauses — inline a5 (CurrentA5) (Task 15, native-5e)
// 81 (line 1558): extern dedup — repeated identical TickCount declaration (Task 3, toolbox-integration)
// 82 (line 1576): word extern type — UiMoveTo/UiFindWindow (Task 4, native-5e)
var CheckClean = []int{
	0, 2, 3, 6, 7, 9, 10, 11, 17, 18,
	33, 34, // Ch5 quit-code / App.startCLI + log example
	38, 39, // Ch5 attempt/abort worked examples (attempt-abort phase Task 8)
	42,
	44, 45, 46, 47, 48, 49,
	58, // Chapter 11 bounce example
	59, 60, 61,
	62, 63, // Chapter 13 ptr basics / container restriction
	65,             // Chapter 13 external func
	67,             // Chapter 13 overlay records restrictions
	68, 70, 71, 72, // Chapter 13 extern record / callback func
	73, 74, 75, 76, 77, 78, 79, 80, // Chapter 13 trap/inline clauses
	81, // Chapter 13 extern dedup
	82, // Chapter 13 word extern type
	83, // Appendix C bookmark manager
	84, // Appendix C text editor
}
