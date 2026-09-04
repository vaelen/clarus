#!/bin/sh
# tests/conntest/envunset.sh -- port of internal/conntest's
# TestEnvUnsetFailedPath: with no CLARUS_SERIAL_MODEM in the environment,
# `conn.open(serial "modem:9600")` fails ENVIRONMENTALLY (never a panic) --
# echo.cla's `on conn.failed` logs "failed: ..." and `quit 1`s.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_conntest.sh"

conn_build echo || { t_fail build "$(cat "$WORK/echo.build")"; t_done; }
t_pass build

# -u, not "assume they are unset": drop whatever the runner's own
# environment might carry (Go's own filtered os.Environ()).
env -u CLARUS_SERIAL_MODEM -u CLARUS_SERIAL_PRINTER "$WORK/echo" \
    > "$WORK/out" 2> "$WORK/err"
rc=$?
[ $rc -eq 1 ] && t_pass exit1 \
    || t_fail exit1 "exit $rc, want 1 (stdout: $(cat "$WORK/out"), stderr: $(cat "$WORK/err"))"
grep -q 'failed:' "$WORK/err" && t_pass failed_msg \
    || t_fail failed_msg "stderr missing \"failed:\": $(cat "$WORK/err")"
t_done
