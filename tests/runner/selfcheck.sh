#!/bin/sh
. "$(dirname "$0")/../lib.sh"
mk() { printf '#!/bin/sh\n%s\n' "$2" > "$WORK/$1.sh"; }
mk pass 'exit 0'
mk skip 'exit 77'
mk failx 'exit 3'
mk failline 'echo "FAIL x: boom"; exit 0'
mk slow '# timeout: 1s
sleep 5'
for n in pass skip failx failline slow; do
    # the status field itself can contain a space ("FAIL(exit 3)"), so strip
    # the trailing "<name> <secs>s" instead of cutting the first field.
    got=$(tests/run1.sh "$WORK/$n.sh" "$WORK/$n.result" | sed 's/ [^ ]* [0-9][0-9]*s$//')
    case "$n:$got" in
        pass:PASS|skip:SKIP|"failx:FAIL(exit 3)"|"failline:FAIL(exit 0)"|"slow:FAIL(timeout 1s)") t_pass "$n" ;;
        *) t_fail "$n" "status $got" ;;
    esac
done
t_done
