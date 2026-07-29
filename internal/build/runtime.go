package build

// RuntimeH, RuntimeC, and RuntimeSerInc expose the embedded host runtime
// (rt/rt.h, rt/rt.c, rt/rt_ser.inc -- rt.c #includes the last at its bottom)
// so out-of-package harnesses (internal/selfhost's emit differential) can
// write the same runtime this package links against, without re-embedding it.
// RuntimeMemH, RuntimeMemHostInc, and RuntimeCoreInc expose the memory seam
// and unified text/list/map core rt.c #includes near its top (4e); RuntimeExtHostInc
// (Task 3, Ch13: `external func`) exposes the rt_ext_* host shim rt.c
// #includes after rt_core.inc -- any harness that copies rt.c into its own
// build dir must copy all four alongside it or rt.c's quoted #includes
// won't resolve.
func RuntimeH() []byte          { return rtH }
func RuntimeC() []byte          { return rtC }
func RuntimeSerInc() []byte     { return rtSerInc }
func RuntimeMemH() []byte       { return rtMemH }
func RuntimeMemHostInc() []byte { return rtMemHostInc }
func RuntimeCoreInc() []byte    { return rtCoreInc }
func RuntimeExtHostInc() []byte { return rtExtHostInc }
