// Package build is the home of the shared C runtime (rt/) and the C
// compiler lookup its tests and other packages' harnesses use. The Go
// compiler that used to live here was deleted in the Go-compiler-deletion
// phase (tag go-compiler-final marks its last commit).
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
