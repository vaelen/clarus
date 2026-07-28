package build

// RuntimeH, RuntimeC, and RuntimeSerInc expose the embedded host runtime
// (rt/rt.h, rt/rt.c, rt/rt_ser.inc -- rt.c #includes the last at its bottom)
// so out-of-package harnesses (internal/selfhost's emit differential) can
// write the same runtime this package links against, without re-embedding it.
// RuntimeMemH, RuntimeMemHostInc, and RuntimeCoreInc expose the memory seam
// and unified text/list/map core rt.c #includes near its top (4e) -- any
// harness that copies rt.c into its own build dir must copy these three
// alongside it or rt.c's quoted #includes won't resolve.
func RuntimeH() []byte          { return rtH }
func RuntimeC() []byte          { return rtC }
func RuntimeSerInc() []byte     { return rtSerInc }
func RuntimeMemH() []byte       { return rtMemH }
func RuntimeMemHostInc() []byte { return rtMemHostInc }
func RuntimeCoreInc() []byte    { return rtCoreInc }
