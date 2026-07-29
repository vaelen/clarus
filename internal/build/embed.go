package build

import _ "embed"

//go:embed rt/rt.h
var rtH []byte

//go:embed rt/rt.c
var rtC []byte

//go:embed rt/rt_ser.inc
var rtSerInc []byte

//go:embed rt/rt_mem.h
var rtMemH []byte

//go:embed rt/rt_mem_host.inc
var rtMemHostInc []byte

//go:embed rt/rt_core.inc
var rtCoreInc []byte

//go:embed rt/rt_ext_host.inc
var rtExtHostInc []byte
