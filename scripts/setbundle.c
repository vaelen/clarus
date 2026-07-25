/* setbundle.c -- stamp the Finder "has bundle" flag on a file inside an HFS
 * .dsk image, via libhfs. Task 6 (app-section plan) runs this after the
 * Retro68 build so a BNDL-carrying app's icon actually resolves in the
 * Finder (a BNDL resource alone isn't enough -- the file's Finder flags
 * word needs bit 13 set too, and the "has been inited" bit cleared so the
 * Finder re-reads the bundle instead of trusting a stale desktop DB entry).
 *
 * Usage:
 *   setbundle IMAGE.dsk FILENAME     -- set the bundle bit, clear inited
 *   setbundle -q IMAGE.dsk FILENAME  -- print the fdflags word in hex (test probe)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "hfs.h"

/* Finder flags bits (Retro68/hfsutils/libhfs/hfs.h:108,113) */
#define HFS_FNDR_HASBEENINITED (1 << 8)
#define HFS_FNDR_HASBUNDLE (1 << 13)

static void die(const char *msg) {
    fprintf(stderr, "setbundle: %s\n", msg);
    exit(1);
}

int main(int argc, char **argv) {
    int query = 0;
    if (argc == 4 && strcmp(argv[1], "-q") == 0) {
        query = 1;
        argv++;
        argc--;
    }
    if (argc != 3) die("usage: setbundle [-q] IMAGE.dsk FILENAME");
    const char *image = argv[1];
    const char *path = argv[2];

    hfsvol *vol = hfs_mount(image, 0, HFS_MODE_RDWR);
    if (!vol) die("hfs_mount failed");

    hfsdirent ent;
    if (hfs_stat(vol, path, &ent) == -1) die("hfs_stat failed");

    if (query) {
        printf("%04x\n", ent.fdflags & 0xffff);
        hfs_umount(vol);
        return 0;
    }

    ent.fdflags = (ent.fdflags | HFS_FNDR_HASBUNDLE) & ~HFS_FNDR_HASBEENINITED;
    if (hfs_setattr(vol, path, &ent) == -1) die("hfs_setattr failed");
    if (hfs_umount(vol) == -1) die("hfs_umount failed");
    return 0;
}
