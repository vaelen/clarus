/* SE Wave 0: rt_mem_host.inc live/peak counters and the 68k cost model
   (round4(size) + 8 header, + 4 master pointer for a handle). Run by
   tests/hostrt/memprobe.sh through run_c_test, which needs stdout+stderr
   to be exactly "OK": CLARUS_MEM_PEAK is unset, so rtm_dump must be
   silent -- that silence is itself under test. */
#include "rt.h"
#include "rt_mem.h"
#include <stdio.h>

static int fails = 0;
#define CHECK(cond) do { if (!(cond)) { printf("FAIL line %d: %s\n", __LINE__, #cond); fails++; } } while (0)

int main(void)
{
    rtm_counters c0, c;
    Handle h;
    Ptr p;

    rtm_dump("reset");            /* silent; resets the phase peak */
    rtm_get(&c0);

    h = NewHandle(10);            /* 68k: 12 + 8 + 4 = 24 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 10);
    CHECK(c.live68k - c0.live68k == 24);
    CHECK(c.blocks - c0.blocks == 1);
    CHECK(c.handles - c0.handles == 1);

    SetHandleSize(h, 21);         /* relocating grow: 24 + 8 + 4 = 36 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 21);
    CHECK(c.live68k - c0.live68k == 36);
    CHECK(c.peak68k - c0.live68k >= 36);

    HLock(h);
    SetHandleSize(h, 40);         /* locked grow fails: nothing counted */
    CHECK(MemError() == memFullErr);
    rtm_get(&c);
    CHECK(c.live - c0.live == 21);
    SetHandleSize(h, 0);          /* locked shrink in place: 0 + 8 + 4 */
    rtm_get(&c);
    CHECK(c.live - c0.live == 0);
    CHECK(c.live68k - c0.live68k == 12);
    HUnlock(h);

    p = NewPtr(5);                /* 68k: 8 + 8 = 16, not a handle */
    rtm_get(&c);
    CHECK(c.live68k - c0.live68k == 12 + 16);
    CHECK(c.handles - c0.handles == 1);
    CHECK(c.blocks - c0.blocks == 2);

    DisposePtr(p);
    DisposeHandle(h);
    rtm_get(&c);
    CHECK(c.live == c0.live);
    CHECK(c.live68k == c0.live68k);
    CHECK(c.blocks == c0.blocks);
    CHECK(c.peakAll68k >= c0.live68k + 36);

    rtm_dump("after");            /* silent; resets the phase peak to live */
    rtm_get(&c);
    CHECK(c.peak68k == c.live68k);
    CHECK(c.allocs == 0);

    if (fails == 0) printf("OK");
    return fails != 0;
}
