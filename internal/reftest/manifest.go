package reftest

// CheckClean lists the indices (into ExtractFences' result, document order)
// of ```rust fences from docs/clarus-language-reference.md that check clean
// standalone with driver.Check. Built by running driver.Check over every
// fence and keeping every index that passed as-is; see
// internal/reftest/reftest_test.go's TestCheckCleanFences.
//
// Most fences are fragments lifted mid-explanation — bare statements with no
// enclosing declaration, or references to a record/window/menu/enum/func
// declared earlier in prose but not repeated in the fence — so they don't
// parse or check standalone. That's expected, not a bug; each excluded index
// below has a one-line reason. The four full worked programs (Chapter 1
// example, Chapter 11 bounce, Appendix C bookmark manager, Appendix C text
// editor) are all in this list; TestRequiredProgramsInManifest guards them.
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
// 38 (line 691): undefined: Type — func skeleton uses placeholder type names
// 39 (line 699): undefined: Person (func param type)
// 41 (line 776): undefined: compile — startCLI example calls a function shown nowhere
// 48 (line 923): undefined: File (menu extend block, menu declared elsewhere)
// 49 (line 933): undefined: Doc (window extend block, window declared elsewhere)
// 51 (line 961): form for names an undefined record: Bookmark
// 53 (line 1013): undefined: EditForm (window extend block)
// 55 (line 1046): undefined: Main (window extend block)
var CheckClean = []int{
	0, 2, 3, 6, 7, 9, 10, 11, 17, 18,
	33, 34, // Ch5 quit-code / App.startCLI + log example
	40,
	42, 43, 44, 45, 46, 47,
	56, // Chapter 11 bounce example
	57, 58, 59,
	64, // Appendix C bookmark manager
	65, // Appendix C text editor
}

// ClaruscOnly lists fence indices (same numbering as CheckClean) that use
// syntax the frozen Go compiler cannot parse at all — the `ptr` type,
// peek/poke builtins, and `external func` declarations from Chapter 13.
// These are the first reference fences added after the Go front end was
// frozen (docs/ROADMAP.md); every Go-side fence sweep over ALL fences (e.g.
// internal/selfhost's TestDifferentialFences) must skip them rather than
// fail on a syntax the Go compiler predates. They are deliberately absent
// from CheckClean, which is driver.Check'd through the same frozen Go
// front end.
//
// 60 (line 1300): Chapter 13 ptr basics — conversion, arithmetic, comparison
// 61 (line 1310): Chapter 13 ptr container restriction (list of ptr, commented)
// 62 (line 1330): Chapter 13 peek/poke
// 63 (line 1346): Chapter 13 external func
var ClaruscOnly = []int{
	60, 61, 62, 63,
}
