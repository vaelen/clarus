package reftest

// CheckClean lists the indices (into ExtractFences' result, document order)
// of ```rust fences from docs/clarus-language-reference.md that check clean
// standalone with driver.Check. Built by running driver.Check over every
// fence and keeping every index that passed as-is; see
// internal/reftest/reftest_test.go's TestCheckCleanFences.
//
// Most fences are fragments lifted mid-explanation — bare statements with no
// enclosing declaration, or references to a record/window/menu declared
// earlier in prose but not repeated in the fence — so they don't parse or
// check standalone. That's expected, not a bug; each excluded index below
// has a one-line reason. The four full worked programs (Chapter 1 example,
// Chapter 11 bounce, Appendix C bookmark manager, Appendix C text editor)
// are all in this list.
//
// Excluded, fragments with no enclosing declaration (bare statements at top
// level, where only record/enum/var/func/window/menu/extend/on/every are
// valid):
// 3  (line 189): bare statements — indexing/assignment fragment
// 4  (line 200): bare statements — string concat fragment
// 5  (line 212): bare statements — byte-copy fragment
// 12 (line 380): bare statement — assignment fragment
// 15 (line 412): bare statement — truncating-assignment fragment
// 17 (line 439): bare statement — assignment fragment
// 18 (line 448): bare statements — also references undeclared var conn
// 19 (line 461): bare if fragment — also references undeclared record Person
// 20 (line 476): bare while fragment — also references undeclared record Person
// 21 (line 489): bare for-in fragment — also references undeclared record Person
// 22 (line 498): bare for-in fragment (map form)
// 23 (line 506): bare for-in fragment (range form)
// 26 (line 539): bare open-statement fragment — also references undeclared window Doc
// 27 (line 551): bare close-statement fragment — also references undeclared window Doc
// 28 (line 561): bare edit-statement fragment — also references undeclared form EditPerson, record Person
// 31 (line 596): bare while fragment — also references undeclared record Person
// 43 (line 851): bare property-assignment fragment (File.Save.enabled = false)
// 45 (line 901): bare edit-statement fragment — also references undeclared EditForm, bookmarks, Bookmark
//
// Excluded, references a name declared only in surrounding prose, not in
// the fence itself:
// 9  (line 265): undefined: EventKind (enum shown elsewhere in the chapter)
// 10 (line 360): undefined: Person
// 11 (line 369): undefined: Person
// 16 (line 427): undefined: Person (func body uses it)
// 24 (line 519): undefined: Person (func body uses it)
// 25 (line 526): undefined: Person (func body uses it)
// 30 (line 584): unknown event — closeRequest handler shown out of its window context
// 32 (line 611): undefined: Type — func skeleton uses placeholder type names
// 33 (line 619): undefined: Person (func body uses it)
// 41 (line 827): undefined: File (menu extend block, menu declared elsewhere)
// 42 (line 837): undefined: Doc (window extend block, window declared elsewhere)
// 44 (line 865): form for names an undefined record: Bookmark
// 46 (line 917): undefined: EditForm (window extend block)
// 47 (line 931): bare table fragment — parse error: expected declaration, found identifier
// 48 (line 950): undefined: Main (window extend block)
var CheckClean = []int{
	0, 1, 2, 6, 7, 8, 13, 14, 29, 34, 35, 36, 37, 38, 39, 40,
	49, 50, 51, 52, // Chapter 11 bounce example is 49
	53, // Appendix C bookmark manager
	54, // Appendix C text editor
}
