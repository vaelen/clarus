// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// gate_test.go: test-suite-review Task 6. internal/build mixes two kinds of
// tests: the rt C-runtime smoke tests (rtsmoke/memtest_c/rctest_c/sertest_c
// -- these build and run rt.c directly with cc, never touching the Go
// compiler, and every lane depends on rt.c staying correct) and the
// Go-compiler tests (build_test.go/golden_test.go/unsupported_test.go --
// these call Build(), the frozen Go compiler's entry point). A package-wide
// TestMain can't split the two, so the Go-compiler tests each call
// requireGoCompiler individually instead; the rt C-runtime tests are left
// untouched and always run. See CLAUDE.md's CLARUS_GO_DIFF documentation.
package build

import (
	"os"
	"testing"
)

func requireGoCompiler(t *testing.T) {
	t.Helper()
	if os.Getenv("CLARUS_GO_DIFF") != "1" {
		t.Skip("CLARUS_GO_DIFF=1 not set; skipping Go-compiler test (see CLAUDE.md)")
	}
}
