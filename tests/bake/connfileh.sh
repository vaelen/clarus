#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeConnFilehByteIdentity: the T1-speed regression for the bug
# `emit68k --rtbake` had for ANY program calling a `connection` or
# `filehandle` method (lower.cla's old lowRtCoerceArg looked the target
# runtime function's param type up by NAME through a symbol table
# --rtbake never populates; fixed by lowCoerceTo). This fixture exercises
# BOTH types and, between them, every one of lowConnMethod's/
# lowFileHandleMethod's seven lowCoerceTo call sites -- none of
# identity.sh's own fixtures declares either type.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/connfileh.cla" <<'CLA'
var conn: connection

on App.startCLI(args: list of string) {
    var fh: filehandle
    var t: text

    conn.open(serial "modem:9600")
    conn.send("str payload")
    t = "text payload"
    conn.send(t)
    conn.close()

    fh = file.create("scratch.dat", "TEXT", "CLAR")
    fh.writeAt(0, "str payload")
    fh.writeAt(20, t)
    fh.append("str tail")
    fh.append(t)
    fh.close()
    quit 0
}
CLA

if detail=$(emit68k_pair connfileh "$WORK/connfileh.cla"); then
    t_pass connfileh.cla
else
    t_fail connfileh.cla "$detail"
fi
t_done
