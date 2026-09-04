#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeCollections: list,
# map (hashtable insertion order), text, and 16-byte-struct element types.
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_smoke_collections_test.c || die "rt_smoke_collections_test"
