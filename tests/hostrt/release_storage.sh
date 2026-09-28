#!/bin/sh
# SE Wave 1: .release() returns a container's storage (host lane),
# .shrink() returns an over-grown list's unused tail, and
# an element-bearing release frees its elements without leaking (the
# runtime's CLARUS_MEM_STRICT exit report lists no leaks). SE wave 2:
# text .removeFirst(n) shrinks the handle to the remaining bytes.
. "$(dirname "$0")/../lib.sh" || exit 2
host_build "$WORK/rs" testdata/lowlevel/release_storage.cla > "$WORK/build.log" 2>&1 \
    || die "host_build: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
CLARUS_MEM_PEAK=1 CLARUS_MEM_STRICT=1 CLARUS_MEM_REPORT="$WORK/mem.txt" "$WORK/rs" > "$WORK/out" 2> "$WORK/err" \
    || die "run failed: $(tail -5 "$WORK/err" | tr '\n' ' ')"
live() { sed -n "s/^memprobe: $1 | .* live=\([0-9]*\) .*/\1/p" "$WORK/err"; }
f=$(live filled); r=$(live released); s=$(live strs); sr=$(live strsreleased)
p=$(live popped); sh=$(live shrunk)
echo "live filled=$f released=$r strs=$s strsreleased=$sr popped=$p shrunk=$sh"
[ -n "$f" ] && [ -n "$r" ] && [ -n "$s" ] && [ -n "$sr" ] && [ -n "$p" ] && [ -n "$sh" ] || die "missing memprobe lines"
[ $((f - r)) -ge 900000 ] && t_pass list_storage_freed || t_fail list_storage_freed "only $((f - r)) bytes freed"
[ $((p - sh)) -ge 900000 ] && t_pass shrink_freed || t_fail shrink_freed "only $((p - sh)) bytes freed"
[ "$sr" -lt "$s" ] && [ $((s - sr)) -ge 16000 ] && t_pass elements_freed || t_fail elements_freed "strs=$s strsreleased=$sr"
if grep -q '^rt_mem: leak' "$WORK/mem.txt"; then t_fail no_leak "$(grep '^rt_mem: leak' "$WORK/mem.txt" | head -3 | tr '\n' ' ')"; else t_pass no_leak; fi
grep -q '^ok 1$' "$WORK/err" && t_pass map_reuse || t_fail map_reuse "no 'ok 1' log line"
tf=$(live textfilled); tr=$(live textremoved)
[ -n "$tf" ] && [ -n "$tr" ] || die "missing text memprobe lines"
[ $((tf - tr)) -ge 150000 ] && t_pass removefirst_freed || t_fail removefirst_freed "textfilled=$tf textremoved=$tr"
t_done
