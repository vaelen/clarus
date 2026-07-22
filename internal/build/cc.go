// Package build will host the `clarus build`/`clarus run` pipeline (Task 9+).
// For now it just exports the C compiler lookup other packages' tests need.
package build

import "os"

// CCPath returns the C compiler to invoke for host builds: $CC if set,
// otherwise "cc".
func CCPath() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}
