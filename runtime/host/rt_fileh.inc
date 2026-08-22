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
    int fd;

    fd = (int)h - 1;
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
    int fd;

    fd = (int)h - 1;
    close(fd);
}

int32_t rt_ext_FhHErrno(void) {
    return (int32_t)rt_fh_errno;
}
