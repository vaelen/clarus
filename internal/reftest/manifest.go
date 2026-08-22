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
// NOTE on line numbers below: only the INDEX numbers are load-bearing
// (cross-referenced by other comments and, transitively, by CheckClean
// itself); line numbers drift with every doc-only prose edit and are not
// re-verified after every edit EXCEPT at a full regeneration (like this
// one, binary-files phase Task 10), where every index/line/reason below was
// re-derived from a fresh clarusc-check pass over all fences rather than
// hand-patched.
//
// Excluded, references a file that doesn't exist on disk (the include
// subsection's own example — an include is only ever a fragment, since the
// file it names is never included in the reference itself):
// 1  (line 81): include "geometry.cla" — no such file
//
// Excluded, fragments with no enclosing declaration (bare statements at top
// level, where only record/enum/const/var/func/window/menu/extend/on/every
// are valid):
// 4  (line 219): bare statements — indexing/in-place-assignment fragment
// 5  (line 230): bare statement — string concat fragment
// 8  (line 259): bare statements — string(n) fromBytes/toBytes byte-copy fragment
// 16 (line 492): bare statement — assignment fragment
// 19 (line 524): bare statement — string(n) truncating-assignment fragment
// 21 (line 551): bare statement — assignment fragment
// 22 (line 560): bare fragment — top-level var decls + conn.open/names.add
//     call statements — also references undeclared Person (list of Person /
//     new Person)
// 23 (line 573): bare if/else-if/else fragment — also references undeclared Person
// 24 (line 588): bare while fragment — also references undeclared Person
// 25 (line 601): bare for-in fragment (list form) — also references undeclared Person
// 26 (line 610): bare for-in fragment (map form)
// 27 (line 618): bare for-in fragment (range form)
// 30 (line 651): bare open-statement fragment — also references undeclared Doc
// 31 (line 663): bare close-statement fragment — also references undeclared Doc
// 32 (line 673): bare edit-statement fragment — also references undeclared EditPerson, Person
// 35 (line 705): bare closeRequest-handler fragment — unknown event outside a window extend block
// 36 (line 717): bare while fragment — break-inside-loop example — also references undeclared Person
// 37 (line 732): bare switch-statement fragment — references undeclared var tok
// 52 (line 1151): bare property-assignment fragment (File.Save.enabled = false)
// 54 (line 1205): bare edit-statement fragment (table/form binds example)
// 56 (line 1237): bare table-widget-declaration fragment (table outside a window)
// 63 (line 1464): bare fragment — filehandle open/create/nil-check idiom
//     (binary-files phase) — also references undeclared var path
// 66 (line 1568): bare statement — ptr peek/poke call fragment
//
// Excluded, references a name declared only in surrounding prose, not in
// the fence itself:
// 12 (line 312): undefined: EventKind, Drag (enum shown elsewhere in the chapter)
// 13 (line 425): undefined: EventKind (const example; enum declared
//     elsewhere) — the unresolved type also trips the const-type-must-be-
//     int/fixed/char/bool/enum/string fallback error
// 14 (line 472): undefined: Person
// 15 (line 481): undefined: Person
// 20 (line 539): undefined: Person (func param type)
// 28 (line 631): undefined: Person (func param type)
// 29 (line 638): undefined: Person (func param type)
// 40 (line 820): undefined: Type — func skeleton uses placeholder type names
// 41 (line 828): undefined: Person (func param type)
// 43 (line 923): undefined: compile — startCLI example calls a function shown nowhere
// 50 (line 1127): undefined: File (menu extend block, menu declared elsewhere)
// 51 (line 1137): undefined: Doc (window extend block, window declared elsewhere)
// 53 (line 1167): form for names an undefined record: Bookmark
// 55 (line 1223): undefined: EditForm (window extend block)
// 57 (line 1256): undefined: Main (window extend block)
//
// Excluded, Chapter 13 fences that are fragments rather than complete
// top-level declarations (same fragment/prose-reference classes as above,
// just from the ptr/peek-poke/overlay-record/extern-record section):
// 68 (line 1601): overlay records — func f's body interleaves var decls
// with statements (var n; h.rc = 5; h.data = p; var back; var same) for
// expository clarity, genuinely violating "local variables ... are
// declared at the top of the body before any statement" (see the
// reference's variable-scoping prose) — a real check-time error, not a
// missing-context fragment. Reordering the example to check clean is a
// content change out of scope here.
// 71 (line 1687): extern record — waitClick usage example calls
// UiWaitNextEvent/nilPtr/handleAt, none declared in the fence itself
// (same "references a name declared only in surrounding prose" class as
// 12-15, 20, 28, 29, 40, 41, 43, 50, 51, 53, 55 above).
//
// Chapter 13 (ptr type, peek/poke builtins, external func declarations
// including trap/inline clauses, overlay record declarations, extern
// record, callback func, the word extern type): these fences post-date the
// deleted Go compiler, which could not parse this syntax at all -- they
// were tracked separately as ClaruscOnly until the Go-compiler-deletion
// phase (2026-08-05) removed the only reason for a second manifest, and
// were merged into CheckClean here (all indices except the fragment
// exclusions documented above).
// 64 (line 1538): ptr basics — conversion, arithmetic, comparison
// 65 (line 1548): ptr container restriction (list of ptr, commented)
// 67 (line 1584): external func
// 69 (line 1625): overlay records restrictions (container/field, commented)
// 70 (line 1636): extern record — Point/EventRecord/SFReply declarations
// 72 (line 1697): extern record restrictions (assign/field/container, commented)
// 73 (line 1726): callback func — declaration + decay + direct-call worked example
// 74 (line 1743): callback func restrictions (decay-misuse/direct-call, commented)
// 75 (line 1770): trap/inline clauses — trap pascal (TickCount)
// 76 (line 1780): trap/inline clauses — trap reg (BlockMove)
// 77 (line 1786): trap/inline clauses — trap reg memerr (SetHandleSize)
// 78 (line 1792): trap/inline clauses — trap reg(...) named form (PostEvent)
// 79 (line 1801): trap/inline clauses — trap sel SELECTOR (LAddRow)
// 80 (line 1809): trap/inline clauses — inline deref (HandleToPtr)
// 81 (line 1815): trap/inline clauses — inline nop (DebugBreak)
// 82 (line 1821): trap/inline clauses — inline a5 (CurrentA5)
// 83 (line 1827): extern dedup — repeated identical TickCount declaration
// 84 (line 1845): word extern type — UiMoveTo/UiFindWindow
//
// binary-files phase (2026-08-22, Task 10) inserted one new fence — a bare
// filehandle open/create/nil-check fragment (file.open/file.create idiom),
// new index 63 above — in the new File Handles section, right after the
// Chapter 12 Connections/serial/listener/serviceBrowser block and before
// what was index 63 (ptr basics, now 64). Every fence at the old index 63
// or higher shifted by +1 as a result; this whole manifest was regenerated
// from a fresh clarusc-check pass over all 87 fences rather than hand-
// patched, so every index/line/reason above is current as of this commit.
// This shifted the two Appendix C programs a final time, from 84/85 to
// 85/86.
var CheckClean = []int{
	0, 2, 3, 6, 7, 9, 10, 11, 17, 18,
	33, 34, // Ch5 quit-code / App.startCLI + log example
	38, 39, // Ch5 attempt/abort worked examples
	42,
	44, 45, 46, 47, 48, 49,
	58, // Chapter 11 bounce example
	59, 60, 61, 62, // Chapter 12 connection / serial / listener / serviceBrowser examples
	64, 65, // Chapter 13 ptr basics / container restriction
	67,             // Chapter 13 external func
	69,             // Chapter 13 overlay records restrictions
	70, 72, 73, 74, // Chapter 13 extern record / callback func
	75, 76, 77, 78, 79, 80, 81, 82, // Chapter 13 trap/inline clauses
	83, // Chapter 13 extern dedup
	84, // Chapter 13 word extern type
	85, // Appendix C bookmark manager
	86, // Appendix C text editor
}
