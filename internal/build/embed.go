package build

import _ "embed"

//go:embed rt/rt.h
var rtH []byte

//go:embed rt/rt.c
var rtC []byte
