// Package driver wires the parser and checker together into the multi-file
// entry point used by the CLI: load each path, parse it, concatenate the
// resulting ASTs in argument order, and check them as one program.
package driver

import (
	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/parser"
	"clarus/internal/source"
)

// Check loads and type-checks the files at paths as a single program: their
// top-level declarations are concatenated in argument order, so
// declare-before-use holds across the whole sequence (a var in an earlier
// file is visible in a later one, not the reverse). A parse error in one
// file stops parsing of that file only — its diagnostics are still
// reported, and the other files are still loaded and checked.
func Check(paths []string) ([]source.Diag, error) {
	var diags []source.Diag
	files := make([]*source.File, 0, len(paths))
	trees := make([]*ast.File, 0, len(paths))

	for _, path := range paths {
		f, err := source.Load(path)
		if err != nil {
			return nil, err
		}
		tree, pdiags := parser.Parse(f)
		diags = append(diags, pdiags...)
		files = append(files, f)
		trees = append(trees, tree)
	}

	cdiags, _ := check.Files(files, trees)
	diags = append(diags, cdiags...)
	return diags, nil
}
