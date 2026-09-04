# tests/lib_bake.sh -- bake-group helpers, sourced right after lib.sh.

CLIRHDR=$TOOLS/clirhdr

# bake_ir LANE OUT : mirrors internal/bake.RunBakeIR. lib.sh has already
# cd'd to the repo root, which is what RunBakeIR's cmd.Dir does, so the
# default --rtdir search finds runtime/clarus/ the way an ordinary
# `clarusc emit68k` invocation does. RunBakeIR t.Fatalf's on a failed
# bake; die is the script-side equivalent.
bake_ir() {
    "$CLARUSC" --bake-ir --lane "$1" -o "$2" || die "clarusc --bake-ir --lane $1 -o $2 failed"
}

# clir_field KEY HDR : the value of one key=value pair on clirhdr's first
# output line (the `module`/`section` lines that follow carry no "=", so
# the NR==1 guard is belt-and-braces).
clir_field() {
    awk -v k="$1" 'NR==1{for(i=1;i<=NF;i++){n=index($i,"=");
        if(substr($i,1,n-1)==k){print substr($i,n+1);exit}}}' "$2"
}
