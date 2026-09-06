/* tests/tools/atalkdrive.c -- a real AppleTalk peer for the test scripts
 * and the T2 emulator boots (2026-09-06 appletalk spec %6.2, Task 2), the
 * sibling of tcpdrive. One process, no threads: it links the host's own
 * LocalTalk-over-UDP stack (runtime/host/rt_atalk.inc, via rt.c) and
 * drives it from a small CLI, so a test can register a name, look one up,
 * call a service or BE a service without any Clarus program involved.
 *
 * usage: atalkdrive lookup TYPE [ZONE]
 *        atalkdrive register OBJ TYPE SECS
 *        atalkdrive call OBJ TYPE OP [--timeout S] [--retries N]
 *        atalkdrive serve OBJ TYPE SECS SCRIPT
 *
 * Exit 0 on success, 1 on a transaction failure (reqFailed / name not
 * found), 2 on a usage or argument error, 3 when `call` completed but the
 * service answered a nonzero code (the reply is still written out), and 77
 * with "SKIP: multicast unavailable" when the stack cannot open at all --
 * the harness's own skip code, which the scripts propagate.
 *
 * CLARUS_ATALK_IFACE selects the interface on a multi-homed host, exactly
 * as it does for a Clarus program.
 */
#include "rt.h"
#include "rt_atalk.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>

#define MAXOPS 32

static const char USAGE[] =
"usage: atalkdrive lookup TYPE [ZONE]\n"
"       atalkdrive register OBJ TYPE SECS\n"
"       atalkdrive call OBJ TYPE OP [--timeout S] [--retries N]\n"
"       atalkdrive serve OBJ TYPE SECS SCRIPT\n"
"\n"
"lookup   prints one line per entity: \"net.node.socket obj:type@zone\"\n"
"register registers OBJ:TYPE on a fresh ATP socket, prints\n"
"         \"registered node=N sock=S\", idles SECS, then removes it\n"
"call     request body on stdin, reply on stdout, \"code N\" on stderr\n"
"serve    SCRIPT lines are \"OP CODE REPLYFILE\"; an op the script does not\n"
"         name is answered with code -1 and an empty reply. Each request is\n"
"         logged to stderr as \"request op=N len=L from=A\".\n"
"\n"
"exit 0 = ok; 1 = transaction failed; 2 = usage; 3 = call answered a\n"
"nonzero code; 77 = multicast unavailable (SKIP).\n";

static int usage(void) { fputs(USAGE, stderr); return 2; }

static rt_atalk *A;

static double now_s(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (double)tv.tv_sec + (double)tv.tv_usec / 1e6;
}

/* pump: poll the stack for `secs` seconds (10 ms granularity). */
static void pump(double secs) {
    double end = now_s() + secs;
    do {
        rt_at_poll(A);
        usleep(10000);
    } while (now_s() < end);
}

static int open_stack(void) {
    A = rt_at_open(getenv("CLARUS_ATALK_IFACE"));
    if (A == NULL) {
        fprintf(stderr, "SKIP: multicast unavailable (%s)\n", strerror(errno));
        return 77;
    }
    return 0;
}

/* wait_lookup: pump until the lookup's own 3 x 1 s window closes. */
static void wait_lookup(int lk) {
    double guard = now_s() + 10.0;
    while (!rt_at_nbp_lookup_done(A, lk) && now_s() < guard) pump(0.05);
}

static int cmd_lookup(const char *type, const char *zone) {
    int i, n;
    rt_at_nbp_lookup_start(A, 0, "=", type, zone);
    wait_lookup(0);
    n = rt_at_nbp_lookup_count(A, 0);
    for (i = 0; i < n; i++) {
        const rt_at_tuple *t = rt_at_nbp_lookup_get(A, 0, i);
        printf("%u.%u.%u %s:%s@%s\n", (unsigned)t->addr.net, (unsigned)t->addr.node,
               (unsigned)t->addr.socket, t->obj, t->type, t->zone);
    }
    fflush(stdout);
    return 0;
}

static int cmd_register(const char *obj, const char *type, double secs) {
    int sock = rt_at_atp_open(A), rc;
    if (sock < 0) { fprintf(stderr, "atp_open: %d\n", sock); return 1; }
    rc = rt_at_nbp_register(A, obj, type, (uint8_t)sock);
    if (rc != 0) { fprintf(stderr, "register: %d\n", rc); return 1; }
    printf("registered node=%u sock=%d\n", (unsigned)rt_at_node(A), sock);
    fflush(stdout);
    pump(secs);
    rt_at_nbp_remove(A, obj, type);
    return 0;
}

/* find_one: NBP-resolve obj:type to a single address. 0 on success. */
static int find_one(const char *obj, const char *type, rt_at_addr *out) {
    const rt_at_tuple *t;
    rt_at_nbp_lookup_start(A, 0, obj, type, "*");
    wait_lookup(0);
    if (rt_at_nbp_lookup_count(A, 0) < 1) return -1;
    t = rt_at_nbp_lookup_get(A, 0, 0);
    *out = t->addr;
    return 0;
}

static int cmd_call(const char *obj, const char *type, int op, int timeout_s, int retries) {
    uint8_t req[RT_AT_MAXREQ], resp[RT_AT_MAXRESP];
    rt_at_addr to;
    size_t reqlen;
    int rlen = 0, rc;
    int32_t code = 0;

    reqlen = fread(req, 1, sizeof(req), stdin);
    if (find_one(obj, type, &to) != 0) {
        fprintf(stderr, "not found: %s:%s\n", obj, type);
        return 1;
    }
    rc = rt_at_atp_call(A, to, op, req, (int)reqlen, resp, (int)sizeof(resp),
                        &rlen, &code, timeout_s, retries);
    if (rc != 0) {
        fprintf(stderr, "call failed: %d\n", rc);
        return 1;
    }
    if (rlen > 0) fwrite(resp, 1, (size_t)rlen, stdout);
    fflush(stdout);
    fprintf(stderr, "code %d\n", (int)code);
    return code != 0 ? 3 : 0;
}

/* --- serve: the op table ------------------------------------------- */
typedef struct {
    int     op;
    int32_t code;
    uint8_t body[RT_AT_MAXRESP];
    int     len;
} op_entry;

static op_entry ops[MAXOPS];
static int nops;

/* load_script: lines "OP CODE REPLYFILE"; blanks and #-comments ignored.
 * REPLYFILE "-" means an empty reply. */
static int load_script(const char *path) {
    char line[1024];
    FILE *f = fopen(path, "r");
    if (f == NULL) { fprintf(stderr, "cannot open script %s\n", path); return 2; }
    while (fgets(line, sizeof(line), f) != NULL) {
        char file[512];
        int op, code;
        if (line[0] == '#' || line[0] == '\n' || line[0] == '\0') continue;
        if (sscanf(line, "%d %d %511s", &op, &code, file) != 3) continue;
        if (nops >= MAXOPS) { fprintf(stderr, "too many ops\n"); fclose(f); return 2; }
        ops[nops].op = op;
        ops[nops].code = code;
        ops[nops].len = 0;
        if (strcmp(file, "-") != 0) {
            FILE *r = fopen(file, "rb");
            if (r == NULL) { fprintf(stderr, "cannot open reply %s\n", file); fclose(f); return 2; }
            ops[nops].len = (int)fread(ops[nops].body, 1, sizeof(ops[nops].body), r);
            fclose(r);
        }
        nops++;
    }
    fclose(f);
    return 0;
}

static int cmd_serve(const char *obj, const char *type, double secs, const char *script) {
    int sock, rc, i;
    double end;

    rc = load_script(script);
    if (rc != 0) return rc;
    sock = rt_at_atp_open(A);
    if (sock < 0) { fprintf(stderr, "atp_open: %d\n", sock); return 1; }
    rc = rt_at_nbp_register(A, obj, type, (uint8_t)sock);
    if (rc != 0) { fprintf(stderr, "register: %d\n", rc); return 1; }
    printf("serving node=%u sock=%d\n", (unsigned)rt_at_node(A), sock);
    fflush(stdout);

    end = now_s() + secs;
    while (now_s() < end) {
        rt_at_req req;
        rt_at_poll(A);
        while (rt_at_atp_get_request(A, sock, &req)) {
            const op_entry *e = NULL;
            fprintf(stderr, "request op=%d len=%d from=%u.%u.%u\n",
                    (int)req.userbytes, req.len, (unsigned)req.from.net,
                    (unsigned)req.from.node, (unsigned)req.from.socket);
            for (i = 0; i < nops; i++) if (ops[i].op == (int)req.userbytes) e = &ops[i];
            if (e != NULL) rt_at_atp_send_response(A, sock, &req, e->code, e->body, e->len);
            else           rt_at_atp_send_response(A, sock, &req, -1, NULL, 0);
        }
        usleep(10000);
    }
    rt_at_nbp_remove(A, obj, type);
    rt_at_atp_close(A, sock);
    return 0;
}

int main(int argc, char **argv) {
    int rc;

    if (argc < 2) return usage();

    if (strcmp(argv[1], "lookup") == 0) {
        if (argc < 3 || argc > 4) return usage();
        rc = open_stack(); if (rc != 0) return rc;
        rc = cmd_lookup(argv[2], argc == 4 ? argv[3] : "*");
    } else if (strcmp(argv[1], "register") == 0) {
        if (argc != 5) return usage();
        rc = open_stack(); if (rc != 0) return rc;
        rc = cmd_register(argv[2], argv[3], atof(argv[4]));
    } else if (strcmp(argv[1], "call") == 0) {
        int timeout_s = 2, retries = 3, i;
        if (argc < 5) return usage();
        for (i = 5; i < argc; i++) {
            if (strcmp(argv[i], "--timeout") == 0 && i + 1 < argc) timeout_s = atoi(argv[++i]);
            else if (strcmp(argv[i], "--retries") == 0 && i + 1 < argc) retries = atoi(argv[++i]);
            else return usage();
        }
        rc = open_stack(); if (rc != 0) return rc;
        rc = cmd_call(argv[2], argv[3], atoi(argv[4]), timeout_s, retries);
    } else if (strcmp(argv[1], "serve") == 0) {
        if (argc != 6) return usage();
        rc = open_stack(); if (rc != 0) return rc;
        rc = cmd_serve(argv[2], argv[3], atof(argv[4]), argv[5]);
    } else {
        return usage();
    }

    rt_at_close(A);
    return rc;
}
