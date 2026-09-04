#!/bin/bash
# test-merge.sh
# T2 gate (per-merge, docs/superpowers/specs/2026-08-03-test-suite-review-
# design.md "Gate tiers"): T1's body (see test-task.sh) plus the groups T1
# leaves out -- perfgate/ (run alone, it flakes under contention),
# selfhost/ (the 30m bootstrap fixed-point + snapshot + cross-generation
# differential oracles), the whole gated mactest/ group (Retro68 toolchain
# + Mini vMac, CLARUS_MAC_TESTS=1, serial by construction so -j1), and the
# bake/ full-corpus byte-identity sweep (CLARUS_BAKE_FULL=1).
#
# The mactest/ group's Retro68/cprint-gcc twins (coresuite_mac,
# toolbox_mac, abort_mac, runerr_mac) SKIP unless CLARUS_CPRINT_MAC_TESTS=1
# is set alongside CLARUS_MAC_TESTS=1 (demoted to an opt-in cross-lane
# localization oracle by the pack3-standardfile phase, 2026-08-07; the
# native emit68k lane already covers every case they check). Lane deletion
# is deferred to 5f Retro68-retirement. The Snow (System 7 / Mac II)
# scripts are opt-in the same way, behind CLARUS_SNOW_TESTS=1.
#
# Slow (~15m plus selfhost) -- run before merging to main, not per-task.
# This is `make t2` with a PASS-in-Ns line per stage -- keep the stage list
# below in sync with `make t2`'s recipe in the Makefile.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

START=$(date +%s)
J=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

stage() {
    _name=$1; shift
    _t0=$(date +%s)
    "$@"
    echo "test-merge.sh: $_name PASS in $(( $(date +%s) - _t0 ))s"
}

make -j"$J" tools bootstrap
# t1 is parallel and includes every gated mactest/ script; strip the gate
# variables so an exported one can't boot emulators concurrently (the later
# stages set them back explicitly, at -j1). See the Makefile's `t1:` comment.
stage "t1 body"        env -u CLARUS_MAC_TESTS -u CLARUS_SNOW_TESTS -u CLARUS_CPRINT_MAC_TESTS -u CLARUS_BENCH68K make -j"$J" t1
stage "perfgate/"      make test T=perfgate/
stage "selfhost/"      make test T=selfhost/
stage "mactest/"       env CLARUS_MAC_TESTS=1 make -j1 test T=mactest/
stage "bake/ full corpus" env CLARUS_BAKE_FULL=1 make -j"$J" test T=bake/full_corpus_

echo "test-merge.sh: PASS in $(( $(date +%s) - START ))s"
