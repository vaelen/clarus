#!/bin/sh
# tests/conntest/shadow.sh -- port of internal/conntest's
# TestConnShadowedLocalIsNil: a local `var conn: connection` shadowing a
# global of the same name is a legal receiver shape (an ordinary value), so
# conn_shadow_local.cla must BUILD clean and then PANIC at runtime with
# "use of nil connection" (runtime/clarus/conn.cla's h == 0 guard) -- rt.c's
# panic path exits 3, distinct from `quit N`/abort's exit 1.
#
# No TCP peer needed: `conn.open` on the GLOBAL takes the synchronous
# env-unset `failed` path (envunset.sh's own contract) before useLocal() runs.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_conntest.sh"

conn_build conn_shadow_local || { t_fail build "$(cat "$WORK/conn_shadow_local.build")"; t_done; }
t_pass build

"$WORK/conn_shadow_local" > "$WORK/out" 2> "$WORK/err"
rc=$?
[ $rc -eq 3 ] && t_pass exit3 \
    || t_fail exit3 "exit $rc, want 3 (stdout: $(cat "$WORK/out"), stderr: $(cat "$WORK/err"))"
grep -q 'use of nil connection' "$WORK/err" && t_pass nil_panic \
    || t_fail nil_panic "stderr missing \"use of nil connection\": $(cat "$WORK/err")"
t_done
