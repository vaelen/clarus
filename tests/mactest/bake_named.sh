#!/bin/sh
# bake_named: bake_test.go's three host-side units for `emit68k --bake
# FILE` (mac-resident-clarusc Task 5) -- the named-resource mechanism the
# Mac-resident compiler carries its own runtime/toolbox sources with.
#   TestBakeNamedResource      exactly one 'CLFS' resource, id 128, name =
#                              the --bake argument verbatim, data = the
#                              file's own bytes.
#   TestBakeDuplicateName      the same --bake name twice fails with exit
#                              2 and writes no output at all.
#   TestBakeNoFlagByteIdentity two no-flag builds of the same fixture, in
#                              two directories, are byte-identical.
. "$(dirname "$0")/../lib.sh" || exit 2

fixture=$ROOT/testdata/ui/about.cla
bakefile=$ROOT/testdata/cg68k/tickprobe.cla

# clfs_entries BIN : print "id len name" for every 'CLFS' resource in a
# MacBinary image's resource fork, writing entry i's data to $WORK/clfs.i.
# Inside Macintosh resource-map walk (fork header -> map -> type list ->
# reference list -> name list), the same decode resparParseFork does.
# ponytail: awk over od bytes because Task 7's tests/tools/resfork.c isn't
# in this branch; fold this into `resfork list/get` once it is.
clfs_entries() {
    od -An -v -tu1 "$1" | LC_ALL=C awk -v work="$WORK" '
        function be16(o) { return b[o] * 256 + b[o + 1] }
        function be32(o) { return ((b[o] * 256 + b[o + 1]) * 256 + b[o + 2]) * 256 + b[o + 3] }
        function str(o, n,   s, i) { s = ""; for (i = 0; i < n; i++) s = s sprintf("%c", b[o + i]); return s }
        { for (i = 1; i <= NF; i++) b[n++] = $i }
        END {
            if (n < 128 + 16) { print "image too short: " n " bytes" > "/dev/stderr"; exit 1 }
            forkLen = be32(87)
            fork = 128
            if (forkLen > n - fork) { print "resource fork length " forkLen " exceeds remaining image bytes " (n - fork) > "/dev/stderr"; exit 1 }
            dataOff = fork + be32(fork)
            mapOff = fork + be32(fork + 4)
            tl = mapOff + be16(mapOff + 24)
            nl = mapOff + be16(mapOff + 26)
            nTypes = be16(tl) + 1
            k = 0
            for (ti = 0; ti < nTypes; ti++) {
                th = tl + 2 + ti * 8
                typ = str(th, 4)
                cnt = be16(th + 4) + 1
                rl = tl + be16(th + 6)
                for (ri = 0; ri < cnt; ri++) {
                    re = rl + ri * 12
                    if (typ != "CLFS") continue
                    id = be16(re)
                    if (id > 32767) id -= 65536
                    nameOff = be16(re + 2)
                    name = (nameOff == 65535) ? "" : str(nl + nameOff + 1, b[nl + nameOff])
                    start = dataOff + be32(re + 4) % 16777216
                    len = be32(start)
                    print id " " len " " name
                    f = work "/clfs." k
                    printf "" > f
                    for (i = 0; i < len; i++) printf "%c", b[start + 4 + i] > f
                    close(f)
                    k++
                }
            }
        }'
}

# --- TestBakeNamedResource -------------------------------------------
mkdir -p "$WORK/named"
if ! emit68k -o "$WORK/named/out.bin" --bake "$bakefile" "$fixture" > "$WORK/named.log" 2>&1; then
    t_fail BakeNamedResource "emit68k --bake failed: $(tail -3 "$WORK/named.log" | tr '\n' ' ')"
else
    clfs_entries "$WORK/named/out.bin" > "$WORK/clfs.list" 2> "$WORK/clfs.err"
    count=$(wc -l < "$WORK/clfs.list" | tr -d ' ')
    if [ -s "$WORK/clfs.err" ] || [ "$count" != 1 ]; then
        t_fail BakeNamedResource "CLFS resources found = $count, want 1 $(cat "$WORK/clfs.err")"
    else
        id=$(cut -d' ' -f1 "$WORK/clfs.list")
        name=$(cut -d' ' -f3- "$WORK/clfs.list")
        ok=1
        [ "$id" = 128 ] || { t_fail BakeNamedResource "CLFS id = $id, want 128 (first --bake flag)"; ok=0; }
        [ "$name" = "$bakefile" ] || { t_fail BakeNamedResource "CLFS name = '$name', want '$bakefile' (the --bake FILE argument, verbatim)"; ok=0; }
        if ! cmp -s "$WORK/clfs.0" "$bakefile"; then
            t_fail BakeNamedResource "CLFS data mismatch against $bakefile: got $(wc -c < "$WORK/clfs.0" | tr -d ' ') bytes, want $(wc -c < "$bakefile" | tr -d ' ') bytes"
            ok=0
        fi
        [ "$ok" = 1 ] && t_pass BakeNamedResource
    fi
fi

# --- TestBakeDuplicateName -------------------------------------------
mkdir -p "$WORK/dup"
emit68k -o "$WORK/dup/out.bin" --bake "$bakefile" --bake "$bakefile" "$fixture" \
    > "$WORK/dup.log" 2>&1
rc=$?
if [ $rc -eq 0 ]; then
    t_fail BakeDuplicateName "emit68k with a duplicate --bake name succeeded, want failure: $(tail -2 "$WORK/dup.log" | tr '\n' ' ')"
elif [ $rc -ne 2 ]; then
    t_fail BakeDuplicateName "exit code = $rc, want 2: $(tail -2 "$WORK/dup.log" | tr '\n' ' ')"
elif [ -e "$WORK/dup/out.bin" ]; then
    t_fail BakeDuplicateName "$WORK/dup/out.bin was written despite the duplicate-name error"
else
    t_pass BakeDuplicateName
fi

# --- TestBakeNoFlagByteIdentity --------------------------------------
ok=1
for d in noflag1 noflag2; do
    mkdir -p "$WORK/$d"
    emit68k -o "$WORK/$d/out.bin" "$fixture" > "$WORK/$d.log" 2>&1 \
        || { t_fail BakeNoFlagByteIdentity "emit68k -o $WORK/$d/out.bin failed: $(tail -3 "$WORK/$d.log" | tr '\n' ' ')"; ok=0; }
done
if [ "$ok" = 1 ]; then
    if cmp -s "$WORK/noflag1/out.bin" "$WORK/noflag2/out.bin"; then
        t_pass BakeNoFlagByteIdentity
    else
        t_fail BakeNoFlagByteIdentity "no-flag build of $fixture is not deterministic across two runs ($(wc -c < "$WORK/noflag1/out.bin" | tr -d ' ') vs $(wc -c < "$WORK/noflag2/out.bin" | tr -d ' ') bytes)"
    fi
fi

t_done
