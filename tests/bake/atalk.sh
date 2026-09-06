#!/bin/sh
# tests/bake/atalk.sh (2026-09-06 appletalk spec, Task 9): the T1-speed
# `emit68k --rtbake` byte-identity twin for the AppleTalk lowering sites,
# in the shape connfileh.sh established for `connection`/`filehandle`.
#
# The standing rule (CLAUDE.md, compiler-cleanup phase): a phase that adds
# a value-typed runtime module to the 68k superset adds its bake twin in
# the SAME task, so --rtbake drift is a T1 failure rather than something
# only the opt-in full-corpus sweep would find. atalk.cla + atalk_68k.cla
# joined that superset in this task.
#
# The fixture deliberately touches every lowering site the phase added --
# serve / reply (text AND string) / stop / call (address AND "Name:Type"
# targets) / find (both arities) / zones / register / open(appletalk ...)
# / open(addr) / send / close / string(addr) -- plus one handler per
# event, so all seven synthesized clar_lsn_/clar_brs_/clar_svc_fire_*
# dispatchers get real (non-empty) arms in both forks.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/atalk.cla" <<'CLA'
var svc: service
var brs: serviceBrowser
var lsn: listener
var link: connection
var direct: connection
var peer: address
var zones: list of string
var reply: text
var payload: text

on App.startCLI(args: list of string) {
    payload = "payload"
    svc.serve("ClarusBake", "ClarusTest")
    lsn.register("ClarusBakeStream", "ClarusTest")
    brs.zones(zones)
    if zones.count > 1 {
        brs.find("ClarusTest", zones[0])
    } else {
        brs.find("ClarusTest")
    }
    quit 0
}

on svc.request(op: int, req: text, from: address) {
    peer = from
    if op == 1 {
        svc.reply(0, "string reply")
    } else if op == 2 {
        svc.reply(0, req)
    } else {
        svc.reply(-1, payload)
    }
}

on svc.failed(err: error) {
    log("svc " + string(err.code) + " " + err.message)
    svc.stop()
}

on brs.found(name: string, addr: address) {
    peer = addr
    log("found " + name + " " + string(addr))
}

on brs.done {
    if svc.call(peer, 1, payload, reply) {
        log("addr " + string(reply.length))
    }
    if svc.call("ClarusBake:ClarusTest", 2, "string request", reply) {
        log("name " + string(reply.length))
    }
    link.open(appletalk "ClarusBakeStream:ClarusTest")
    direct.open(peer)
}

on brs.failed(err: error) {
    log("brs " + string(err.code) + " " + err.message)
}

on lsn.accepted(c: connection) {
    c.send(payload)
    c.close()
}

on lsn.failed(err: error) {
    log("lsn " + string(err.code) + " " + err.message)
    lsn.stop()
}

on link.opened {
    link.send("hello")
    link.send(payload)
}

on link.received(data: text) {
    log("rx " + string(data.length))
    link.close()
}

on link.closed {
    log("closed")
}

on link.failed(err: error) {
    log("link " + string(err.code) + " " + err.message)
}

on direct.failed(err: error) {
    direct.close()
}
CLA

if detail=$(emit68k_pair atalk "$WORK/atalk.cla"); then
    t_pass atalk.cla
else
    t_fail atalk.cla "$detail"
fi
t_done
