/* probe.c -- emulator plumbing probe for the Clarus Mac harness.
   Writes "PROBE-OUT-42\r" to the pre-existing file `out` on the boot
   volume, and creates `probe_marker` containing "PROBE-MARKER-42\r".
   No console library, no window; exits immediately. */
#include <Files.h>
#include <TextUtils.h>

static void writeAll(short ref, const char *buf, long n)
{
    long count = n;
    FSWrite(ref, &count, buf);
}

static void writeFile(ConstStr255Param name, const char *buf, long n, Boolean mustCreate)
{
    short ref;
    OSErr err;
    if (mustCreate)
        Create(name, 0, 'MPS ', 'TEXT');          /* vRefNum 0 = default volume */
    err = FSOpen(name, 0, &ref);
    if (err != noErr)
        return;
    SetEOF(ref, 0);
    writeAll(ref, buf, n);
    FSClose(ref);
    FlushVol(NULL, 0);
}

int main(void)
{
    writeFile("\pout", "PROBE-OUT-42\r", 13, false);
    writeFile("\pprobe_marker", "PROBE-MARKER-42\r", 16, true);
    return 0;
}
