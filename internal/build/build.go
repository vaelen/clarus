// Package build compiles Clarus source files to a native host executable:
// parse, check, lower to IR, print C99, and invoke the C compiler against
// the embedded host runtime (rt.h/rt.c, package-relative in ./rt — see
// embed.go and the Task 9 plan note on why that runtime lives here rather
// than at the repo-level runtime/host/ it started at).
package build

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/cprint"
	"clarus/internal/lower"
	"clarus/internal/parser"
	"clarus/internal/source"
)

// Build compiles the Clarus program made up of paths (concatenated in
// argument order, as driver.Check does) into the native executable out. It
// returns non-empty diags on any parse, check, or host-build-support error
// — in that case out is not written. A non-nil err means the pipeline
// itself failed (an unreadable source file, or cc rejecting checker-clean
// emitted C, which is a compiler bug and reported as
// "internal error: emitted C failed to compile").
func Build(paths []string, out string) ([]source.Diag, error) {
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

	cdiags, info := check.Files(files, trees)
	diags = append(diags, cdiags...)
	if len(diags) > 0 {
		return diags, nil
	}

	prog, ldiags := lower.Program(files, trees, info)
	diags = append(diags, ldiags...)
	if len(diags) > 0 {
		return diags, nil
	}

	c := cprint.Emit(prog)

	workdir, err := os.MkdirTemp("", "clarus-build-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(workdir)

	mainPath := filepath.Join(workdir, "main.c")
	rtHPath := filepath.Join(workdir, "rt.h")
	rtCPath := filepath.Join(workdir, "rt.c")
	if err := os.WriteFile(mainPath, c, 0o644); err != nil {
		return nil, err
	}
	if err := os.WriteFile(rtHPath, rtH, 0o644); err != nil {
		return nil, err
	}
	if err := os.WriteFile(rtCPath, rtC, 0o644); err != nil {
		return nil, err
	}

	outAbs, err := filepath.Abs(out)
	if err != nil {
		return nil, err
	}

	cmd := exec.Command(CCPath(), "-std=c99", "-O1", mainPath, rtCPath, "-o", outAbs)
	if ccOut, err := cmd.CombinedOutput(); err != nil {
		return nil, fmt.Errorf("internal error: emitted C failed to compile: %v\n%s", err, ccOut)
	}

	return nil, nil
}
