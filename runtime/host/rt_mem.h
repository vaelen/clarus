/* internal/build/rt/rt_mem.h -- the memory seam. On the Mac this IS the
   Toolbox Memory Manager; on the host, rt_mem_host.inc implements the same
   subset with deliberate hostility (relocation, scramble, ledger) so Handle
   discipline is proven in host tests before code ever runs on a Mac. */
#ifndef CLARUS_RT_MEM_H
#define CLARUS_RT_MEM_H

#if defined(__m68k__) || defined(macintosh)
#include <Memory.h>
#define rt_mem_note(block, why) ((void)(block), (void)(why))
#else

typedef long Size;
typedef short OSErr;
typedef char *Ptr;
typedef Ptr *Handle;

#define noErr        0
#define memFullErr   (-108)
#define nilHandleErr (-109)

Handle rt_mem_new_handle(Size n, int clear, const char *tag);
void   rt_mem_set_handle_size(Handle h, Size n);
Size   GetHandleSize(Handle h);
void   HLock(Handle h);
void   HUnlock(Handle h);
void   DisposeHandle(Handle h);
Ptr    rt_mem_new_ptr(Size n, int clear, const char *tag);
void   DisposePtr(Ptr p);
OSErr  MemError(void);
void   BlockMoveData(const void *src, void *dst, Size n);
void   rt_mem_note_(void *block, const char *why);
long   rt_mem_live_count(void);

#define RT_MEM_STR2(x) #x
#define RT_MEM_STR(x) RT_MEM_STR2(x)
#define RT_MEM_TAG (__FILE__ ":" RT_MEM_STR(__LINE__))

#define NewHandle(n)        rt_mem_new_handle((n), 0, RT_MEM_TAG)
#define NewHandleClear(n)   rt_mem_new_handle((n), 1, RT_MEM_TAG)
#define SetHandleSize(h, n) rt_mem_set_handle_size((h), (n))
#define NewPtr(n)           rt_mem_new_ptr((n), 0, RT_MEM_TAG)
#define NewPtrClear(n)      rt_mem_new_ptr((n), 1, RT_MEM_TAG)
#define rt_mem_note(block, why) rt_mem_note_((void *)(block), (why))

#endif /* host */
#endif /* CLARUS_RT_MEM_H */
