package build

// RuntimeH and RuntimeC expose the embedded host runtime (rt/rt.h, rt/rt.c)
// so out-of-package harnesses (internal/selfhost's emit differential) can
// write the same runtime this package links against, without re-embedding it.
func RuntimeH() []byte { return rtH }
func RuntimeC() []byte { return rtC }
