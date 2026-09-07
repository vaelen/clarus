#!/bin/sh
# tests/bake/tcp.sh (2026-09-07 mactcp spec, Task 9): the T1-speed
# `emit68k --rtbake` byte-identity twin for the TCP lowering sites, in the
# shape connfileh.sh established for `connection`/`filehandle` and
# atalk.sh repeated for AppleTalk.
#
# The standing rule (CLAUDE.md, compiler-cleanup phase): a phase that adds
# a value-typed runtime module to the 68k superset adds its bake twin in
# the SAME task, so --rtbake drift is a T1 failure rather than something
# only the opt-in full-corpus sweep would find. tcp.cla + tcp_68k.cla
# joined that superset in Task 6.
#
# The fixture deliberately touches every lowering site the phase added --
# open(tcp "a.b.c.d:port") / listen(tcp port) / send (text AND string
# literal) / close / stop -- plus one handler per event on BOTH resources
# (opened, received, closed, failed on the connection; accepted, failed on
# the listener), so every synthesized clar_conn_/clar_lsn_fire_* arm is
# non-empty in both forks.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/tcp.cla" <<'CLA'
var link: connection
var client: connection
var lsn: listener
var payload: text

on App.startCLI(args: list of string) {
    payload = "payload"
    lsn.listen(tcp 2323)
    link.open(tcp "127.0.0.1:2323")
}

on link.opened {
    link.send("READY\n")
    link.send(payload)
}

on link.received(data: text) {
    log("rx " + string(data.length))
    link.close()
}

on link.closed {
    log("closed")
    quit 0
}

on link.failed(err: error) {
    log("link " + string(err.code) + " " + err.message)
    quit 1
}

on lsn.accepted(c: connection) {
    client = c
    client.send(payload)
}

on lsn.failed(err: error) {
    log("lsn " + string(err.code) + " " + err.message)
    lsn.stop()
}

on client.received(data: text) {
    client.send(data)
    client.close()
}

on client.closed {
    lsn.stop()
}
CLA

if detail=$(emit68k_pair tcp "$WORK/tcp.cla"); then
    t_pass tcp.cla
else
    t_fail tcp.cla "$detail"
fi
t_done
