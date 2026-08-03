// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// gate_test.go: test-suite-review Task 6. Package types is part of the
// frozen Go compiler (differential-testing reference only per CLAUDE.md) --
// its unit tests are a Go lane, not part of the default Go-free gauntlet.
// TestMain skips the whole package unless CLARUS_GO_DIFF=1 is set; see
// CLAUDE.md's CLARUS_GO_DIFF documentation and scripts/test-merge.sh (which
// sets it for the T2 gate).
package types

import (
	"fmt"
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	if os.Getenv("CLARUS_GO_DIFF") != "1" {
		fmt.Println("skip: CLARUS_GO_DIFF=1 not set -- Go-compiler package, see CLAUDE.md")
		os.Exit(0)
	}
	os.Exit(m.Run())
}
