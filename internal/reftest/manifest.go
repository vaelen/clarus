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
// Excluded, fragments with no enclosing declaration (bare statements at top
// level, where only record/enum/const/var/func/window/menu/extend/on/every
// are valid):
// 3  (line 191): bare statements — indexing/in-place-assignment fragment
// 4  (line 202): bare statement — string concat fragment
// 7  (line 230): bare statements — byte-copy fragment
// 15 (line 414): bare statement — assignment fragment
// 18 (line 446): bare statement — truncating-assignment fragment
// 20 (line 473): bare statement — assignment fragment
// 21 (line 482): bare call-statement fragment — also references undeclared var conn
// 22 (line 495): bare if/else-if/else fragment
// 23 (line 510): bare while fragment
// 24 (line 523): bare for-in fragment (list form)
// 25 (line 532): bare for-in fragment (map form)
// 26 (line 540): bare for-in fragment (range form)
// 29 (line 573): bare open-statement fragment
// 30 (line 585): bare close-statement fragment
// 31 (line 595): bare edit-statement fragment — also references undeclared EditPerson, Person
// 34 (line 627): bare closeRequest-handler fragment — unknown event outside a window extend block
// 35 (line 639): bare while fragment — break-inside-loop example
// 36 (line 654): bare switch-statement fragment — references undeclared var tok
// 49 (line 930): bare property-assignment fragment (File.Save.enabled = false)
// 51 (line 980): bare edit-statement fragment
// 53 (line 1010): bare table-widget-declaration fragment (table outside a window)
//
// Excluded, references a name declared only in surrounding prose, not in
// the fence itself:
// 11 (line 283): undefined: EventKind (enum shown elsewhere in the chapter)
// 12 (line 348): undefined: EventKind (const example; enum declared elsewhere)
// 13 (line 394): undefined: Person
// 14 (line 403): undefined: Person
// 19 (line 461): undefined: Person (func param type)
// 27 (line 553): undefined: Person (func param type)
// 28 (line 560): undefined: Person (func param type)
// 37 (line 674): undefined: Type — func skeleton uses placeholder type names
// 38 (line 682): undefined: Person (func param type)
// 40 (line 759): undefined: compile — startCLI example calls a function shown nowhere
// 47 (line 906): undefined: File (menu extend block, menu declared elsewhere)
// 48 (line 916): undefined: Doc (window extend block, window declared elsewhere)
// 50 (line 944): form for names an undefined record: Bookmark
// 52 (line 996): undefined: EditForm (window extend block)
// 54 (line 1029): undefined: Main (window extend block)
var CheckClean = []int{
	0, 1, 2, 5, 6, 8, 9, 10, 16, 17,
	32, 33, // Ch5 quit-code / App.startCLI + log example
	39,
	41, 42, 43, 44, 45, 46,
	55, // Chapter 11 bounce example
	56, 57, 58,
	59, // Appendix C bookmark manager
	60, // Appendix C text editor
}
