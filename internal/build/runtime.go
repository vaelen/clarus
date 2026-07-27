package build

// RuntimeH, RuntimeC, and RuntimeSerInc expose the embedded host runtime
// (rt/rt.h, rt/rt.c, rt/rt_ser.inc -- rt.c #includes the last at its bottom)
// so out-of-package harnesses (internal/selfhost's emit differential) can
// write the same runtime this package links against, without re-embedding it.
func RuntimeH() []byte      { return rtH }
func RuntimeC() []byte      { return rtC }
func RuntimeSerInc() []byte { return rtSerInc }
