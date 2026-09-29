#!/bin/sh
# hostrt/logfile -- app.writeLog/app.flushLog on the host lane
# (log-trace-optin): append across runs, a mid-run flush, auto-flush past
# the 4 KB buffer, a full-length (255-byte) line, switching files, the
# panic report, a failed open, and no file at all without writeLog.
# testdata/hostrt/logfile.cla takes the subcase name as args[0].
. "$(dirname "$0")/../lib.sh" || exit 2
host_build "$WORK/lf" testdata/hostrt/logfile.cla > "$WORK/build.log" 2>&1 \
    || die "host_build: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
mkdir "$WORK/run" && cd "$WORK/run" || die "no run dir"
run() { "$WORK/lf" "$@" > out.txt 2> err.txt; }
# is FILE EXPECTED-printf-format: FILE's bytes equal the printf expansion
is() { printf "$2" > want.txt; cmp -s "$1" want.txt; }

run a1 && run a2
is L.txt 'a\nb\nc\n' && t_pass create_append || t_fail create_append "L.txt: $(od -c L.txt 2>&1 | head -3)"

run flush
[ "$(cat out.txt)" = 2 ] && t_pass flush_midrun || t_fail flush_midrun "read back length: $(cat out.txt)"

run burst
i=0; : > want.txt
while [ $i -lt 300 ]; do printf '%s\n' "line $i...................." | cut -c1-20 >> want.txt; i=$((i + 1)); done
cmp -s B.txt want.txt && t_pass autoflush || t_fail autoflush "B.txt: $(wc -lc < B.txt 2>&1)"

run maxline
[ "$(wc -c < M.txt)" -eq 256 ] && [ "$(tr -d 'm\n' < M.txt | wc -c)" -eq 0 ] \
    && t_pass maxline || t_fail maxline "M.txt: $(wc -c < M.txt 2>&1) bytes"

run switch
is A.txt '1\n' && is B2.txt '2\n' && t_pass switch || t_fail switch "A=$(cat A.txt) B2=$(cat B2.txt)"

run panic; rc=$?
if [ $rc -ne 3 ]; then t_fail panic "exit $rc, want 3"
elif is P.txt 'before\nruntime error: list index out of range\n'; then t_pass panic
else t_fail panic "P.txt: $(cat P.txt)"; fi

run badpath; rc=$?
if [ $rc -ne 0 ]; then t_fail badpath "exit $rc"
elif [ "$(cat out.txt)" != "err 2" ]; then t_fail badpath "lastError: $(cat out.txt)"
elif ! grep -qx y err.txt; then t_fail badpath "log(y) missing from stderr"
else t_pass badpath; fi

mkdir off && cd off && run off
[ -z "$(ls -A | grep -v '^out.txt$' | grep -v '^err.txt$')" ] && grep -qx q err.txt \
    && t_pass off || t_fail off "files: $(ls -A | tr '\n' ' ')"
t_done
