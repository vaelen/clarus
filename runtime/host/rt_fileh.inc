/* runtime/host/rt_fileh.inc -- host pread/pwrite glue for the
 * `filehandle` type's positioned file I/O (2026-08-22 binary-files spec,
 * Task 5). #included at the bottom of rt.c, exactly like rt_serial.inc
 * above it -- never a separate translation unit. Host lane only: the
 * native 68k lane's real File Manager glue is fileh_68k.cla (Task 6), a
 * Clarus-only file with no C counterpart here.
 *
 * Handle convention: fd + 1 (0 = nil/failed-open, matching fileh.cla's
 * own nil contract) -- open()'s -1-on-failure maps to 0 naturally, and
 * every OTHER entry point just subtracts 1 back to the real fd. No slot
 * table: the OS fd number itself IS the handle, offset by one, so a
 * stale handle after close reaches whatever the OS has since done with
 * that fd number -- the documented C-fd hazard the reference and
 * fileh.cla's own header comment both call out.
 *
 * fileh_c.cla's own rtFhDevReadAt/rtFhDevWriteAt own all `rt_text`
 * awareness (growing/filling a text's storage via Clarus-level
 * rtTextGrow/TextHandleDeref) -- FhHReadAt/FhHWriteAt here are
 * deliberately dumb: pread/pwrite over a caller-supplied raw pointer +
 * byte count, no rt_text struct knowledge in C at all, matching
 * conn_c.cla's own ConnHWrite(slot, p, n) shape.
 *
 * Error reporting: every failing call here stashes errno (or a synthetic
 * small positive code for a non-syscall failure) in rt_fh_errno, read
 * back via rt_ext_FhHErrno -- fileh.cla's own rtFhDevLastOSErr wraps that
 * one extern, then rtSetLastErr(code, "<op> failed") surfaces it as
 * lastError, per spec %4.2's binding error table. This file itself never
 * calls rt_set_lasterr -- that's fileh.cla's job, exactly like
 * conn.cla/rt_serial.inc's own division of labor.
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <sys/time.h>
#include <libgen.h>

static int rt_fh_errno = 0;

/* rt_ext_FhHOpen: the file must already exist -- O_RDWR, no O_CREAT
 * (spec %3.1: file.open's own contract). */
int32_t rt_ext_FhHOpen(const uint8_t *path) {
    char cpath[256];
    int fd;

    path_to_cstr(cpath, path);
    fd = open(cpath, O_RDWR);
    if (fd < 0) {
        rt_fh_errno = errno;
        return 0;
    }
    return (int32_t)(fd + 1);
}

/* ==================== resource fork (language-runtime-cleanup, spec %6.3) ====================
 * macOS: the fork is the file's com.apple.ResourceFork xattr, reachable as
 * an ordinary fd through the "<path>/..namedfork/rsrc" pseudo-path; the
 * kernel stores it natively on APFS/HFS+ and as an AppleDouble "._name"
 * sidecar on FAT/NFS/SMB-without-streams, so this one open covers every
 * volume. Elsewhere (and on macOS under CLARUS_FORCE_APPLEDOUBLE=1, the
 * harness's way to exercise this path on the dev machine): the fork lives
 * in an AppleDouble v2 sidecar "._name" beside the data file -- the exact
 * layout macOS writes on non-native volumes, so a sidecar written here is a
 * real fork to a Mac reading the same share. It is mirrored into an
 * unlinked temp file at open (so readAt/writeAt/size/setSize need no
 * fork-specific code) and written back on flush and close.
 *
 * The sidecar rewrite is NOT lossless: it emits a fresh two-entry header
 * carrying only the Finder-info (id 9) and resource-fork (id 2) entries, so
 * any OTHER entry a pre-existing macOS-written sidecar happened to carry
 * (id 3 file dates, id 4 Finder comment, id 8 the older date field, ...) is
 * dropped on the first flush or close. The two entries preserved are the
 * two a Mac needs to see a real fork with its real type/creator; the rest
 * are metadata a Clarus program has no way to author anyway.
 *
 * EFTYPE is BSD/macOS-only (glibc does not define it) and this block is the
 * one written FOR non-Apple hosts, so it gets the usual fallback. */
#ifndef EFTYPE
#define EFTYPE EINVAL
#endif
#define RT_FH_RF_MAX 32
static struct { int fd; char sidecar[1024]; unsigned char finfo[32]; int hasFinfo; } rt_fh_rf[RT_FH_RF_MAX];

static int rt_fh_rf_slot(int fd) { int i; for (i = 0; i < RT_FH_RF_MAX; i++) if (rt_fh_rf[i].fd == fd + 1) return i; return -1; }

static uint32_t rt_fh_be32(const unsigned char *p) { return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3]; }
static void rt_fh_put32(unsigned char *p, uint32_t v) { p[0] = (unsigned char)(v >> 24); p[1] = (unsigned char)(v >> 16); p[2] = (unsigned char)(v >> 8); p[3] = (unsigned char)v; }

/* rt_fh_sidecar_load: copy the sidecar's resource-fork entry (id 2) into fd
 * and stash its Finder-info entry (id 9, 32 bytes) for the rewrite. A
 * missing sidecar is an empty fork. Returns -1 only on a malformed header. */
static int rt_fh_sidecar_load(int slot, int fd) {
    unsigned char hdr[26], ent[12], buf[4096];
    FILE *f; uint32_t n, i, id, off, len, done;
    f = fopen(rt_fh_rf[slot].sidecar, "rb");
    if (!f) return 0;
    if (fread(hdr, 1, 26, f) != 26 || rt_fh_be32(hdr) != 0x00051607u) { fclose(f); return -1; }
    n = ((uint32_t)hdr[24] << 8) | hdr[25];
    for (i = 0; i < n; i++) {
        if (fseek(f, 26 + (long)i * 12, SEEK_SET) != 0 || fread(ent, 1, 12, f) != 12) { fclose(f); return -1; }
        id = rt_fh_be32(ent); off = rt_fh_be32(ent + 4); len = rt_fh_be32(ent + 8);
        if (id == 9 && len == 32) { fseek(f, (long)off, SEEK_SET); if (fread(rt_fh_rf[slot].finfo, 1, 32, f) == 32) rt_fh_rf[slot].hasFinfo = 1; }
        if (id == 2) {
            fseek(f, (long)off, SEEK_SET);
            for (done = 0; done < len; ) {
                size_t want = len - done > sizeof buf ? sizeof buf : len - done;
                size_t got = fread(buf, 1, want, f);
                if (got == 0) break;
                if (pwrite(fd, buf, got, (off_t)done) < 0) { fclose(f); return -1; }
                done += (uint32_t)got;
            }
        }
    }
    fclose(f);
    return 0;
}

/* rt_fh_sidecar_store: rewrite the sidecar from fd's current contents --
 * header (26 bytes), two entries (Finder info at 50, resource fork at 82).
 * An empty fork with no Finder info removes the sidecar instead. Only those
 * two entries survive a rewrite; see this block's own header comment.
 * deferred-minors wave: every failure path preserves the ORIGINAL errno
 * across its fclose(), so the two callers (FhHFlush/FhHClose) record the
 * real cause rather than whatever fclose() left behind. */
static int rt_fh_sidecar_store(int slot, int fd) {
    unsigned char hdr[82], buf[4096]; struct stat st; FILE *f; off_t pos; ssize_t got;
    if (fstat(fd, &st) != 0) return -1;
    if (st.st_size == 0 && !rt_fh_rf[slot].hasFinfo) { unlink(rt_fh_rf[slot].sidecar); return 0; }
    memset(hdr, 0, sizeof hdr);
    rt_fh_put32(hdr, 0x00051607u); rt_fh_put32(hdr + 4, 0x00020000u); hdr[24] = 0; hdr[25] = 2;
    rt_fh_put32(hdr + 26, 9); rt_fh_put32(hdr + 30, 50); rt_fh_put32(hdr + 34, 32);
    rt_fh_put32(hdr + 38, 2); rt_fh_put32(hdr + 42, 82); rt_fh_put32(hdr + 46, (uint32_t)st.st_size);
    memcpy(hdr + 50, rt_fh_rf[slot].finfo, 32);
    f = fopen(rt_fh_rf[slot].sidecar, "wb");
    if (!f) return -1;
    if (fwrite(hdr, 1, 82, f) != 82) { int e = errno; fclose(f); errno = e; return -1; }
    for (pos = 0; pos < st.st_size; pos += got) {
        got = pread(fd, buf, sizeof buf, pos);
        if (got <= 0) break;
        if (fwrite(buf, 1, (size_t)got, f) != (size_t)got) { int e = errno; fclose(f); errno = e; return -1; }
    }
    /* spec %6: flush's durability barrier covers the SIDECAR, not just the
     * unlinked temp -- push the stdio buffer and fsync before closing. */
    if (fflush(f) != 0 || fsync(fileno(f)) != 0) { int e = errno; fclose(f); errno = e; return -1; }
    return fclose(f) == 0 ? 0 : -1;
}

int32_t rt_ext_FhHOpenRF(const uint8_t *path) {
    char cpath[256], tmpl[1100], dirbuf[256], basebuf[256];
    const char *tdir;
    struct stat st; int fd, slot, i;
    path_to_cstr(cpath, path);
    if (stat(cpath, &st) != 0) { rt_fh_errno = errno; return 0; }
#if defined(__APPLE__)
    if (!getenv("CLARUS_FORCE_APPLEDOUBLE")) {
        char rsrc[300];
        snprintf(rsrc, sizeof rsrc, "%s/..namedfork/rsrc", cpath);
        fd = open(rsrc, O_RDWR | O_CREAT, 0644);
        if (fd < 0) { rt_fh_errno = errno; return 0; }
        return (int32_t)(fd + 1);
    }
#endif
    slot = -1;
    for (i = 0; i < RT_FH_RF_MAX; i++) if (rt_fh_rf[i].fd == 0) { slot = i; break; }
    if (slot < 0) { rt_fh_errno = EMFILE; return 0; }
    /* spec %6: the unlinked temp that backs the fork lives under $TMPDIR
     * when set and non-empty, else /tmp -- the ordinary POSIX rule. */
    tdir = getenv("TMPDIR");
    if (!tdir || !*tdir) tdir = "/tmp";
    if (snprintf(tmpl, sizeof tmpl, "%s/clarus-rf-XXXXXX", tdir) >= (int)sizeof tmpl) { rt_fh_errno = ENAMETOOLONG; return 0; }
    fd = mkstemp(tmpl);
    if (fd < 0) { rt_fh_errno = errno; return 0; }
    unlink(tmpl);
    strcpy(dirbuf, cpath); strcpy(basebuf, cpath);
    snprintf(rt_fh_rf[slot].sidecar, sizeof rt_fh_rf[slot].sidecar, "%s/._%s", dirname(dirbuf), basename(basebuf));
    rt_fh_rf[slot].hasFinfo = 0; memset(rt_fh_rf[slot].finfo, 0, 32);
    if (rt_fh_sidecar_load(slot, fd) != 0) { close(fd); rt_fh_errno = EFTYPE; return 0; }
    rt_fh_rf[slot].fd = fd + 1;
    return (int32_t)(fd + 1);
}

/* rt_ext_FhHCreate: create-or-truncate, opened read/write (spec %3.1:
 * file.create's own contract) -- 0644, matching rt_file_write_text's own
 * mode elsewhere in this runtime. */
int32_t rt_ext_FhHCreate(const uint8_t *path) {
    char cpath[256];
    int fd;

    path_to_cstr(cpath, path);
    fd = open(cpath, O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) {
        rt_fh_errno = errno;
        return 0;
    }
    return (int32_t)(fd + 1);
}

/* rt_ext_FhHReadAt: pread loop to completion; a short read (0 < got <
 * n, or got == 0 outright) at EOF returns normally -- NOT an error, per
 * spec %3.1 ("a read that crosses EOF succeeds with a shorter out"). Only
 * an actual pread() failure returns -1. */
int32_t rt_ext_FhHReadAt(int32_t h, int32_t pos, void *p, int32_t n) {
    int fd;
    uint8_t *buf;
    int32_t got;
    ssize_t k;

    fd = (int)h - 1;
    buf = (uint8_t *)p;
    got = 0;
    while (got < n) {
        k = pread(fd, buf + got, (size_t)(n - got), (off_t)(pos + got));
        if (k < 0) {
            if (errno == EINTR) continue;
            rt_fh_errno = errno;
            return -1;
        }
        if (k == 0) break; /* EOF: short read, not an error */
        got += (int32_t)k;
    }
    return got;
}

/* rt_ext_FhHWriteAt: pwrite loop to completion at a fixed offset, EXCEPT
 * pos == -1, which means "at current EOF" (rtFhAppend's own contract,
 * spec %3.1) -- plain write() then, exactly the fsFromLEOF-equivalent the
 * Mac lane's own PBWriteSync will use (Task 6). Returns 0 on success,
 * nonzero (errno, always > 0 on a real syscall failure) on any write
 * failure. */
int32_t rt_ext_FhHWriteAt(int32_t h, int32_t pos, void *p, int32_t n) {
    int fd;
    const uint8_t *buf;
    int32_t sent;
    ssize_t k;

    fd = (int)h - 1;
    buf = (const uint8_t *)p;
    sent = 0;
    if (pos < 0) {
        /* "at current EOF" (spec %3.1): the fd's own byte offset is NOT
         * reliably at EOF here -- every OTHER call on this fd goes
         * through pread/pwrite, which never advance it, so it can still
         * sit wherever open() left it (0). lseek(SEEK_END) first, THEN a
         * plain positioned write from there -- avoids relying on
         * O_APPEND, which fights explicit pwrite offsets anyway. */
        if (lseek(fd, 0, SEEK_END) < 0) {
            rt_fh_errno = errno;
            return 1;
        }
        while (sent < n) {
            k = write(fd, buf + sent, (size_t)(n - sent));
            if (k < 0) {
                if (errno == EINTR) continue;
                rt_fh_errno = errno;
                return 1;
            }
            sent += (int32_t)k;
        }
        return 0;
    }
    while (sent < n) {
        k = pwrite(fd, buf + sent, (size_t)(n - sent), (off_t)(pos + sent));
        if (k < 0) {
            if (errno == EINTR) continue;
            rt_fh_errno = errno;
            return 1;
        }
        sent += (int32_t)k;
    }
    return 0;
}

/* rt_ext_FhHSize: the logical EOF via fstat -- -1 + rt_fh_errno on
 * failure (a stale/reused handle number is the routine case, EBADF). */
int32_t rt_ext_FhHSize(int32_t h) {
    int fd;
    struct stat st;

    fd = (int)h - 1;
    if (fstat(fd, &st) != 0) {
        rt_fh_errno = errno;
        return -1;
    }
    return (int32_t)st.st_size;
}

/* rt_ext_FhHSetSize: grow (zero-fills on the host, per spec %3.1 -- a
 * POSIX ftruncate-grown region reads as zero) or truncate. */
int32_t rt_ext_FhHSetSize(int32_t h, int32_t n) {
    int fd;

    fd = (int)h - 1;
    if (ftruncate(fd, (off_t)n) != 0) {
        rt_fh_errno = errno;
        return 1;
    }
    return 0;
}

/* rt_ext_FhHFlush: fsync -- the write-ahead durability barrier (spec
 * %3.1/%4.2). */
int32_t rt_ext_FhHFlush(int32_t h) {
    int fd, slot;

    fd = (int)h - 1;
    /* An AppleDouble-backed fork lives in an unlinked temp file until it is
     * written back (spec %6.3), so flush's durability barrier has to rewrite
     * the sidecar first -- fsync alone would only harden the temp. */
    slot = rt_fh_rf_slot(fd);
    if (slot >= 0 && rt_fh_sidecar_store(slot, fd) != 0) {
        rt_fh_errno = errno;
        return 1;
    }
    if (fsync(fd) != 0) {
        rt_fh_errno = errno;
        return 1;
    }
    return 0;
}

/* rt_ext_FhHClose: idempotent from fileh.cla's own perspective (it never
 * calls this twice on a genuinely-still-open handle without a nil check
 * in between), but close() itself is a no-op on an already-invalid fd
 * (EBADF), so no extra guard is needed here either. */
void rt_ext_FhHClose(int32_t h) {
    int fd, slot;

    fd = (int)h - 1;
    /* Last chance to write an AppleDouble-backed fork back out, and the only
     * place its side-table slot is freed (the temp fd is unlinked, so the
     * slot is the whole of what close has to release). */
    slot = rt_fh_rf_slot(fd);
    if (slot >= 0) {
        /* close() is void on every lane (reference: "idempotent"), so a
         * failed write-back cannot be returned; it is recorded in
         * rt_fh_errno for FhHErrno, and the reference tells programs that
         * flush() is the call that reports it (spec %6). */
        if (rt_fh_sidecar_store(slot, fd) != 0) rt_fh_errno = errno;
        rt_fh_rf[slot].fd = 0;
    }
    close(fd);
}

int32_t rt_ext_FhHErrno(void) {
    return (int32_t)rt_fh_errno;
}

/* rt_fh_stat_buf: the single cached catalog record FhHStat fills and
 * FhHStatField reads back out of -- fileh.cla's own rtFhInfo issues
 * exactly one rtFhDevStat per file.info(path) call, then reads all seven
 * scalars from it (filesystem-api Task 3 spec %4.3: "the device layer
 * never sees FileInfo"). */
static struct stat rt_fh_stat_buf;

/* rt_fh_mac_time: Unix seconds -> Mac-epoch LOCAL seconds, the identical
 * conversion rt_dt_now_mac (rt_ext_host.inc, included earlier in rt.c so
 * the shared rt_unix_to_mac_secs helper is already visible here) uses for
 * "now" -- applied here to a file's stat times instead of the current
 * time. */
static int32_t rt_fh_mac_time(time_t t) {
    return (int32_t)rt_unix_to_mac_secs(t);
}

/* rt_fh_unix_time: rt_fh_mac_time's inverse (filesystem-api Task 4,
 * FhHSetTimes) -- subtract RT_MAC_EPOCH_DELTA, then the local UTC offset.
 * The offset itself depends on the instant (DST), so this is a two-step
 * approximation: get a rough Unix time first, read ITS gmtoff, then
 * apply that. ponytail: exact except right at a DST transition instant --
 * fine for a Finder-style "restamp this file's dates" call, upgrade to a
 * fixed-point iteration if that ever matters. */
static time_t rt_fh_unix_time(int32_t mac) {
    time_t approx;
    struct tm tmv;

    approx = (time_t)((unsigned long)mac - RT_MAC_EPOCH_DELTA);
    localtime_r(&approx, &tmv);
    return (time_t)((long)approx - tmv.tm_gmtoff);
}

/* rt_ext_FhHStat: stat by path; 0 on success (fields via FhHStatField),
 * -1 + rt_fh_errno otherwise. Fix round 1 (Task 5 review, controller
 * ruling): "" names the program's own folder for every folder-taking
 * call on both lanes (spec %3's lane-parity rule), not just `list` --
 * the native lane already synthesizes that hit directly (fileh_68k.cla's
 * own rtFhDevStat); here the empty translated path is substituted with
 * "." (the SAME substitution FhHListBegin below already makes) so
 * stat("") -- which always fails -- doesn't diverge from that. Done only
 * here, not inside path_to_cstr, so open("")/create("")/etc. keep
 * failing exactly as before. */
int32_t rt_ext_FhHStat(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (cpath[0] == '\0') { cpath[0] = '.'; cpath[1] = '\0'; }
    if (stat(cpath, &rt_fh_stat_buf) != 0) {
        rt_fh_errno = errno;
        return -1;
    }
    return 0;
}

/* rt_ext_FhHStatField: 0 size, 2 created, 3 modified, 4 isDir -- from the
 * last successful FhHStat. Mac-epoch seconds via RT_MAC_EPOCH_DELTA and
 * the local-time offset, the same convention rt_dt_now_mac uses. macOS/BSD
 * report a real file-creation time (st_birthtime); other hosts have none,
 * so "created" falls back to st_ctime there (documented in the reference
 * as "where the host reports one"). */
int32_t rt_ext_FhHStatField(int32_t which) {
    switch (which) {
    case 0: return (int32_t)rt_fh_stat_buf.st_size;
    case 2:
#if defined(__APPLE__)
        return rt_fh_mac_time(rt_fh_stat_buf.st_birthtime);
#else
        return rt_fh_mac_time(rt_fh_stat_buf.st_ctime);
#endif
    case 3: return rt_fh_mac_time(rt_fh_stat_buf.st_mtime);
    case 4: return S_ISDIR(rt_fh_stat_buf.st_mode) ? 1 : 0;
    default: return 0;
    }
}

/* ==================== directory/catalog surface (filesystem-api Task 4) ====================
 * makeDir/delete/list/setInfo/rename/move (spec %3): the six new file.*
 * calls' host lane. path_to_cstr already applies the HFS->POSIX
 * translation (rt.c's own rt_fh_posix_path hook), so every body below
 * gets an ordinary relative/absolute POSIX path for free. */

int32_t rt_ext_FhHMakeDir(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (mkdir(cpath, 0777) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHDelete(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (remove(cpath) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

/* rt_fh_dir: one listing at a time (fileh.cla's rtFhList's own module-
 * level cursor contract, spec %4.3) -- a fresh FhHListBegin closes any
 * still-open previous DIR* first, so a caller that forgets ListEnd (it
 * shouldn't -- rtFhList always calls it) can't leak past the next call. */
static DIR *rt_fh_dir = NULL;

int32_t rt_ext_FhHListBegin(const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    if (cpath[0] == '\0') { cpath[0] = '.'; cpath[1] = '\0'; }
    if (rt_fh_dir) closedir(rt_fh_dir);
    rt_fh_dir = opendir(cpath);
    if (!rt_fh_dir) { rt_fh_errno = errno; return -1; }
    return 0;
}

/* 0 = wrote a Pascal-string name into buf (<= 255 bytes), 1 = done, -1 =
 * error (fix round 1: readdir() signals a real failure by leaving errno
 * nonzero when it returns NULL -- "no more entries" leaves errno
 * untouched at the 0 this loop resets it to before each call, so the two
 * cases are distinguishable). '.' and '..' are skipped, matching spec
 * %3's "every file and folder directly inside path" (those two are not
 * catalog entries on the Mac). */
int32_t rt_ext_FhHListNext(void *buf) {
    struct dirent *de;
    size_t n;
    if (!rt_fh_dir) return 1;
    for (;;) {
        errno = 0;
        de = readdir(rt_fh_dir);
        if (!de) {
            if (errno != 0) { rt_fh_errno = errno; return -1; }
            return 1;
        }
        if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0) continue;
        n = strlen(de->d_name);
        /* A name too long for a Pascal Str255 is a real failure, not a
         * silently truncated entry (a truncated name would name a
         * DIFFERENT file to every caller that used it). rtFhDevListNext
         * (fileh_c.cla) maps this -1 to rtFhListFailed exactly like the
         * readdir() error path above, so rtFhList surfaces it as
         * false + lastError. Reachable on any filesystem whose name
         * limit counts characters rather than bytes (APFS: 255 UTF-8
         * characters, up to ~1KB). */
        if (n > 255) { rt_fh_errno = ENAMETOOLONG; return -1; }
        ((uint8_t *)buf)[0] = (uint8_t)n;
        memcpy((uint8_t *)buf + 1, de->d_name, n);
        return 0;
    }
}

void rt_ext_FhHListEnd(void) {
    if (rt_fh_dir) { closedir(rt_fh_dir); rt_fh_dir = NULL; }
}

/* rt_ext_FhHSetTimes: created is ignored on POSIX (birth time is not
 * settable); modified == 0 means "leave unchanged" (spec %3's own
 * setInfo contract). */
int32_t rt_ext_FhHSetTimes(const uint8_t *path, int32_t created, int32_t modified) {
    char cpath[256];
    struct timeval tv[2];
    struct stat sb; /* final-review wave, Minor 5: a LOCAL stat buffer --
                      * rt_fh_stat_buf is the shared FhHStat cache that
                      * FhHStatField reads back from; stat()-ing into it
                      * here would clobber a caller's still-pending
                      * info() read for the atime this call only needs
                      * internally. */
    (void)created;
    path_to_cstr(cpath, path);
    if (modified == 0) return 0;
    if (stat(cpath, &sb) != 0) { rt_fh_errno = errno; return -1; }
    tv[0].tv_sec = sb.st_atime; tv[0].tv_usec = 0;
    tv[1].tv_sec = rt_fh_unix_time(modified); tv[1].tv_usec = 0;
    if (utimes(cpath, tv) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHRename(const uint8_t *path, const uint8_t *newName) {
    char cpath[256], cnew[256], target[512], dirbuf[256];
    path_to_cstr(cpath, path);
    path_to_cstr(cnew, newName);
    strcpy(dirbuf, cpath);
    /* Refuse rather than silently rename to a truncated target. Belt and
     * braces: path_to_cstr caps each half at a Str255's own 255 bytes, so
     * "dir/leaf" cannot exceed 511 + NUL today -- the guard is here so a
     * later widening of either buffer can't turn into a silent
     * mis-rename. */
    if (snprintf(target, sizeof target, "%s/%s", dirname(dirbuf), cnew) >= (int)sizeof target) {
        rt_fh_errno = ENAMETOOLONG;
        return -1;
    }
    if (rename(cpath, target) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}

int32_t rt_ext_FhHMove(const uint8_t *path, const uint8_t *dirPath) {
    char cpath[256], cdir[256], target[512], basebuf[256];
    path_to_cstr(cpath, path);
    path_to_cstr(cdir, dirPath);
    if (cdir[0] == '\0') { cdir[0] = '.'; cdir[1] = '\0'; }
    strcpy(basebuf, cpath);
    /* Same guard as FhHRename above, same reasoning. */
    if (snprintf(target, sizeof target, "%s/%s", cdir, basename(basebuf)) >= (int)sizeof target) {
        rt_fh_errno = ENAMETOOLONG;
        return -1;
    }
    if (rename(cpath, target) != 0) { rt_fh_errno = errno; return -1; }
    return 0;
}
