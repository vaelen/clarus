// Package driver wires the parser and checker together into the multi-file
// entry point used by the CLI: load each path, parse it (expanding any
// leading `include` declarations along the way), concatenate the resulting
// ASTs in expansion order, and check them as one program.
package driver

import (
	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/parser"
	"clarus/internal/source"
	"fmt"
	"path/filepath"
)

// Check loads and type-checks the files at paths as a single program.
// Each file may lead with `include "other.cla"` declarations (Chapter 1);
// includes are expanded depth-first, relative to the including file's
// directory, before that file's own declarations are emitted — so a
// dependency's declarations always precede the declarations of the file
// that included it. A file is expanded only once no matter how many times
// it's reached (identity by cleaned absolute path), which also makes
// include cycles harmless rather than infinite. Include nodes themselves
// are stripped before the trees reach the checker. Declare-before-use then
// holds across the whole expanded sequence exactly as it does for one file.
//
// A parse error in one file stops parsing of that file only — its
// diagnostics are still reported, and the rest of the program is still
// expanded and checked. A missing included file produces a "cannot open
// included file" diagnostic at the include's position and is otherwise
// skipped; a missing entry path (one of paths itself) is a hard error, as
// before.
func Check(paths []string) ([]source.Diag, error) {
	var diags []source.Diag
	var files []*source.File
	var trees []*ast.File
	seen := map[string]bool{}

	// expand loads and parses path, recursively expanding its leading
	// includes first. missing reports whether path itself couldn't be
	// loaded (relevant only for entry==false: the caller turns that into a
	// "cannot open included file" diagnostic at the include's position);
	// err is reserved for a failing entry path, which is a hard error.
	var expand func(path string, entry bool) (missing bool, err error)
	expand = func(path string, entry bool) (bool, error) {
		abs, err := filepath.Abs(path)
		if err != nil {
			return false, err
		}
		clean := filepath.Clean(abs)
		if seen[clean] {
			return false, nil
		}
		seen[clean] = true

		f, err := source.Load(path)
		if err != nil {
			if entry {
				return false, err
			}
			return true, nil
		}
		tree, pdiags := parser.Parse(f)
		diags = append(diags, pdiags...)

		dir := filepath.Dir(path)
		kept := tree.Decls[:0]
		for _, d := range tree.Decls {
			inc, ok := d.(*ast.Include)
			if !ok {
				kept = append(kept, d)
				continue
			}
			missing, err := expand(filepath.Join(dir, inc.Path), false)
			if err != nil {
				return false, err
			}
			if missing {
				diags = append(diags, source.Diag{File: f, Pos: inc.P,
					Msg: fmt.Sprintf("cannot open included file %q", inc.Path)})
			}
		}
		tree.Decls = kept

		files = append(files, f)
		trees = append(trees, tree)
		return false, nil
	}

	for _, path := range paths {
		if _, err := expand(path, true); err != nil {
			return nil, err
		}
	}

	cdiags, _ := check.Files(files, trees)
	diags = append(diags, cdiags...)
	return diags, nil
}
