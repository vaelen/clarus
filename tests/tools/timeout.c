/* tests/tools/timeout.c -- run CMD under a wall-clock deadline.
 * usage: timeout [--elapsed] SECONDS CMD [ARGS...]
 * The child runs in its own process group. On expiry the group gets
 * SIGTERM, then SIGKILL two seconds later, and we exit 124. Otherwise
 * the child's status is propagated (128+signal if it died by signal).
 * --elapsed prints "elapsed_ms=N" as the last line on stderr (macOS
 * date(1) has no sub-second field; tests/perfgate needs this).
 * SIGINT/SIGTERM/SIGHUP are forwarded to the group and then re-raised, so
 * a Ctrl-C at the make prompt never leaves the child running orphaned. */
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <unistd.h>

static pid_t child;
static volatile sig_atomic_t fired;
static volatile sig_atomic_t caught;

static void on_alarm(int sig) {
    (void)sig;
    fired++;
    if (fired == 1) { kill(-child, SIGTERM); alarm(2); }
    else            { kill(-child, SIGKILL); }
}

static void on_signal(int sig) {
    caught = sig;
    kill(-child, sig);          /* the child group, not just the child */
}

int main(int argc, char **argv) {
    int elapsed = 0, ai = 1;
    if (ai < argc && strcmp(argv[ai], "--elapsed") == 0) { elapsed = 1; ai++; }
    if (argc - ai < 2) {
        fprintf(stderr, "usage: timeout [--elapsed] SECONDS CMD [ARGS...]\n");
        return 2;
    }
    char *end;
    unsigned long secs = strtoul(argv[ai], &end, 10);
    /* Reject a non-numeric or zero deadline: alarm(0) would silently mean
     * "no timeout at all", which is how a malformed "# timeout:" header
     * disables the deadline for a whole test. */
    if (argv[ai][0] == '\0' || *end != '\0' || secs == 0 || secs > 0x7fffffffUL) {
        fprintf(stderr, "timeout: bad SECONDS \"%s\"\n", argv[ai]);
        fprintf(stderr, "usage: timeout [--elapsed] SECONDS CMD [ARGS...]\n");
        return 2;
    }
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    child = fork();
    if (child < 0) { perror("fork"); return 2; }
    if (child == 0) {
        setpgid(0, 0);
        execvp(argv[ai + 1], argv + ai + 1);
        perror(argv[ai + 1]);
        _exit(127);
    }
    setpgid(child, child);
    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_alarm;          /* no SA_RESTART: waitpid must EINTR */
    sigaction(SIGALRM, &sa, NULL);
    sa.sa_handler = on_signal;
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGHUP, &sa, NULL);
    alarm((unsigned)secs);
    int status;
    while (waitpid(child, &status, 0) < 0) {
        if (errno != EINTR) { perror("waitpid"); return 2; }
    }
    gettimeofday(&t1, NULL);
    if (elapsed) {
        long ms = (t1.tv_sec - t0.tv_sec) * 1000L + (t1.tv_usec - t0.tv_usec) / 1000L;
        fprintf(stderr, "elapsed_ms=%ld\n", ms);
    }
    if (fired) return 124;
    if (caught) {                  /* die the way we were told to */
        signal(caught, SIG_DFL);
        raise(caught);
        return 128 + caught;
    }
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return 2;
}
