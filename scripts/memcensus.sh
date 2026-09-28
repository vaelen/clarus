#!/bin/sh
# scripts/memcensus.sh [--rtbake] [--at-peak] FILE.cla... -- SE memory program diagnostic.
# Builds a census-enabled copy of the current compiler (its own globals
# are file-static in build-run/clarusc-current.c, so the census must be
# compiled into the same translation unit), then compiles FILE.cla for
# the 68k lane with CLARUS_MEM_PEAK=2: each phase's memprobe line is
# followed by the per-tag histogram and the top 25 compiler globals by
# payload bytes. --at-peak runs CLARUS_MEM_PEAK=3 instead and prints the
# TOTAL line plus the LAST peakcensus snapshot (the census taken when the
# overall peak last climbed 64 KB past the previous snapshot; the true
# peak is within 64 KB of it). Nothing gates on this script but
# tests/memgate/atpeak.sh's smoke check. Writes only under
# build-run/memcensus/.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BR=$ROOT/build-run
OUT=$BR/memcensus
BAKE=
LVL=2
while :; do
    case "$1" in
        --rtbake) BAKE=1; shift ;;
        --at-peak) LVL=3; shift ;;
        *) break ;;
    esac
done
[ $# -ge 1 ] || { echo "usage: $0 [--rtbake] [--at-peak] FILE.cla..." >&2; exit 2; }
make -C "$ROOT" -j tools bootstrap > /dev/null
mkdir -p "$OUT"
SRC=$BR/clarusc-current.c

# rt_list/rt_map/rt_text are opaque typedefs in clarusc-current.c, so the
# census reads them through local mirrors of runtime/host/rt_core.inc's
# structs (the Plan 5b layout guards there keep those layouts pinned).
# rt_intmap is an rt_map underneath (runtime/clarus/map.cla's rtIntMapNew).
{
  cat "$SRC"
  cat <<'EOF'
#include <stdio.h>
#include "rt_mem.h"
struct rtm_list { int32_t rc; Handle data; int32_t elemsize, count, cap; };
struct rtm_map { int32_t rc; Handle keys, vals; int32_t valsize, count, cap, valcap;
    Handle keypool; int32_t poolused, poolcap; Handle index; int32_t indexcap, tombs; };
struct rtm_text { int32_t rc; Handle h; int32_t len, cap; };
typedef struct { const char *n, *alias; void *box; long bytes, count, elem, cap; } rtm_row;
/* Two globals holding one box (cv_rtbakeBytes/cv_bkLoadBuf) are one row:
   the later name is printed as "also=" instead of counting the bytes twice. */
#define RTM_DUP(v) { int k; for (k = 0; k < n && r[k].box != (void *)v; k++) {} \
    if (k < n) { r[k].alias = #v; dup = 1; } else { r[n].box = (void *)v; r[n].alias = 0; } }
static long rtm_hsz(Handle h) { return h ? (long)GetHandleSize(h) : 0; }
#define RTM_L(v) dup = 0; if (v) RTM_DUP(v) if (v && !dup && n < 4096) { struct rtm_list *p = (struct rtm_list *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->data); r[n].count = p->count; r[n].elem = p->elemsize; r[n].cap = p->cap; n++; }
#define RTM_M(v) dup = 0; if (v) RTM_DUP(v) if (v && !dup && n < 4096) { struct rtm_map *p = (struct rtm_map *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->keys) + rtm_hsz(p->vals) + rtm_hsz(p->keypool) + rtm_hsz(p->index); \
    r[n].count = p->count; r[n].elem = p->valsize; r[n].cap = p->cap; n++; }
#define RTM_T(v) dup = 0; if (v) RTM_DUP(v) if (v && !dup && n < 4096) { struct rtm_text *p = (struct rtm_text *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->h); r[n].count = p->len; r[n].elem = 1; r[n].cap = p->cap; n++; }
void rtm_census(FILE *out, const char *prefix) {
  static rtm_row r[4096]; int n = 0, i, j, dup;
EOF
  sed -nE 's/^static rt_list \* ?(cv_[A-Za-z0-9_]+);$/  RTM_L(\1)/p
           s/^static rt_(int)?map \* ?(cv_[A-Za-z0-9_]+);$/  RTM_M(\2)/p
           s/^static rt_text \* ?(cv_[A-Za-z0-9_]+);$/  RTM_T(\1)/p' "$SRC"
  cat <<'EOF'
  for (i = 0; i < 25 && i < n; i++) { int b = i; rtm_row t;
    for (j = i + 1; j < n; j++) if (r[j].bytes > r[b].bytes) b = j;
    t = r[i]; r[i] = r[b]; r[b] = t;
    fprintf(out, "%s %10ld %s count=%ld elemsize=%ld cap=%ld%s%s\n",
        prefix, r[i].bytes, r[i].n, r[i].count, r[i].elem, r[i].cap,
        r[i].alias ? " also=" : "", r[i].alias ? r[i].alias : ""); }
}
EOF
} > "$OUT/clarusc-census.c"

${CC:-cc} -O1 -w -DRTM_CENSUS -I "$ROOT/runtime/host" -o "$OUT/clarusc-census" \
    "$OUT/clarusc-census.c" "$ROOT/runtime/host/rt.c"

cd "$ROOT"
if [ "$LVL" = 3 ]; then
    # The host CLI's feExpectedStamp reads all of clarusc/clarusc.c (4 MB)
    # to stamp-check --rtbake; ClarusC.APPL reads a 4-byte resource. Run
    # from a directory with no clarusc/clarusc.c above it (bkFindClarusC
    # walks up), so bake and compile both stamp 0 and the peak found is
    # the Mac-shaped one, not that host-only read.
    for f; do set -- "$@" "$(cd "$(dirname "$f")" && pwd)/$(basename "$f")"; shift; done
    RUN=$(mktemp -d)
    trap 'rm -rf "$RUN"' EXIT
    cd "$RUN"
fi
set --  --rtdir "$ROOT/runtime/clarus/" -o "$OUT/out.bin" "$@"
if [ -n "$BAKE" ]; then
    "$OUT/clarusc-census" --bake-ir --lane 68k --rtdir "$ROOT/runtime/clarus/" -o "$OUT/rt.clir"
    set -- --rtbake "$OUT/rt.clir" "$@"
fi
CLARUS_MEM_PEAK=$LVL "$OUT/clarusc-census" emit68k "$@" > "$OUT/log" 2>&1 \
    || { cat "$OUT/log" >&2; exit 1; }
if [ "$LVL" = 3 ]; then
    awk '/^memprobe: TOTAL /{print} /^memprobe: peakcensus at /{n=0} /^memprobe: peakcensus /{s[n++]=$0}
         END { for (i = 0; i < n; i++) print s[i] }' "$OUT/log"
else
    grep '^memprobe:' "$OUT/log"
fi
