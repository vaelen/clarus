/* internal/build/rt/rt_ext_host.inc: host implementations of `external
 * func` symbols (Task 3, Ch13: Low-Level Memory Access -- the narrow-waist
 * seam, Plan 5a). Each rt_ext_* delegates to the host Memory Manager shim
 * (rt_mem.h/rt_mem_host.inc) rather than bare malloc/free, so the strict-
 * ledger/paranoid/leak-gate instrumentation that already covers every
 * INTERNAL allocation (rt_text/rt_list/rt_map, ...) covers an `external
 * func` allocation exactly the same way -- NewHandle/NewPtr are both
 * already present in the host shim (verified against rt_mem.h's host
 * branch + rt_mem_host.inc before writing this file), so no malloc-backed
 * fallback is needed for either.
 *
 * Every wrapper here just narrows/widens between the C ABI's plain
 * int32_t/void* (what clarusc's cprint emits for `int`/`ptr`) and
 * rt_mem.h's Size/Handle/Ptr/OSErr typedefs -- no logic of its own.
 */
#ifndef CLARUS_RT_EXT_HOST_INC
#define CLARUS_RT_EXT_HOST_INC

void *rt_ext_NewHandle(int32_t size) { return (void *)NewHandle((Size)size); }
void rt_ext_DisposeHandle(void *h) { DisposeHandle((Handle)h); }
int32_t rt_ext_GetHandleSize(void *h) { return (int32_t)GetHandleSize((Handle)h); }
int32_t rt_ext_SetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_BlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_NewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_DisposePtr(void *p) { DisposePtr((Ptr)p); }

#endif /* CLARUS_RT_EXT_HOST_INC */
