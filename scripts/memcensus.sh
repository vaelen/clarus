#!/bin/sh
# scripts/memcensus.sh [--rtbake] FILE.cla... -- SE memory program diagnostic.
# Builds a census-enabled copy of the current compiler (its own globals
# are file-static in build-run/clarusc-current.c, so the census must be
# compiled into the same translation unit), then compiles FILE.cla for
# the 68k lane with CLARUS_MEM_PEAK=2: each phase's memprobe line is
# followed by the per-tag histogram and the top 25 compiler globals by
# payload bytes. Not a test; nothing gates on it. Writes only under
# build-run/memcensus/.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BR=$ROOT/build-run
OUT=$BR/memcensus
BAKE=
if [ "$1" = --rtbake ]; then BAKE=1; shift; fi
[ $# -ge 1 ] || { echo "usage: $0 [--rtbake] FILE.cla..." >&2; exit 2; }
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
typedef struct { const char *n; long bytes, count, elem, cap; } rtm_row;
static long rtm_hsz(Handle h) { return h ? (long)GetHandleSize(h) : 0; }
#define RTM_L(v) if (v && n < 4096) { struct rtm_list *p = (struct rtm_list *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->data); r[n].count = p->count; r[n].elem = p->elemsize; r[n].cap = p->cap; n++; }
#define RTM_M(v) if (v && n < 4096) { struct rtm_map *p = (struct rtm_map *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->keys) + rtm_hsz(p->vals) + rtm_hsz(p->keypool) + rtm_hsz(p->index); \
    r[n].count = p->count; r[n].elem = p->valsize; r[n].cap = p->cap; n++; }
#define RTM_T(v) if (v && n < 4096) { struct rtm_text *p = (struct rtm_text *)v; r[n].n = #v; \
    r[n].bytes = rtm_hsz(p->h); r[n].count = p->len; r[n].elem = 1; r[n].cap = p->cap; n++; }
void rtm_census(void) {
  static rtm_row r[4096]; int n = 0, i, j;
EOF
  sed -nE 's/^static rt_list \* ?(cv_[A-Za-z0-9_]+);$/  RTM_L(\1)/p
           s/^static rt_(int)?map \* ?(cv_[A-Za-z0-9_]+);$/  RTM_M(\2)/p
           s/^static rt_text \* ?(cv_[A-Za-z0-9_]+);$/  RTM_T(\1)/p' "$SRC"
  cat <<'EOF'
  for (i = 0; i < 25 && i < n; i++) { int b = i; rtm_row t;
    for (j = i + 1; j < n; j++) if (r[j].bytes > r[b].bytes) b = j;
    t = r[i]; r[i] = r[b]; r[b] = t;
    fprintf(stderr, "memprobe:   census %10ld %s count=%ld elemsize=%ld cap=%ld\n",
        r[i].bytes, r[i].n, r[i].count, r[i].elem, r[i].cap); }
}
EOF
} > "$OUT/clarusc-census.c"

${CC:-cc} -O1 -w -DRTM_CENSUS -I "$ROOT/runtime/host" -o "$OUT/clarusc-census" \
    "$OUT/clarusc-census.c" "$ROOT/runtime/host/rt.c"

cd "$ROOT"
if [ -n "$BAKE" ]; then
    "$OUT/clarusc-census" --bake-ir --lane 68k --rtdir runtime/clarus/ -o "$OUT/rt.clir"
    CLARUS_MEM_PEAK=2 "$OUT/clarusc-census" emit68k --rtdir runtime/clarus/ --rtbake "$OUT/rt.clir" -o "$OUT/out.bin" "$@" 2>&1 | grep '^memprobe:'
else
    CLARUS_MEM_PEAK=2 "$OUT/clarusc-census" emit68k --rtdir runtime/clarus/ -o "$OUT/out.bin" "$@" 2>&1 | grep '^memprobe:'
fi
