#!/bin/sh
. "$(dirname "$0")/../lib.sh" || exit 2
mk() { printf '#!/bin/sh\n%s\n' "$2" > "$WORK/$1.sh"; }
mk pass 'exit 0'
mk skip 'exit 77'
mk failx 'exit 3'
mk failline 'echo "FAIL x: boom"; exit 0'
mk failskip 'echo "FAIL x: boom"; exit 77'
mk slow '# timeout: 1s
sleep 5'
mk minhdr '# timeout: 1m
exit 0'
mk bogus '# timeout: bogus
exit 0'
# "(m" would be an arithmetic syntax error inside $(( )) -- the runner must
# fall back to the default, not abort with no result line at all.
mk badhdr '# timeout: (m
exit 0'
for n in pass skip failx failline failskip slow minhdr bogus badhdr; do
    # the status field itself can contain a space ("FAIL(exit 3)"), so strip
    # the trailing "<name> <secs>s" instead of cutting the first field.
    got=$(tests/run1.sh "$WORK/$n.sh" "$WORK/$n.result" | sed 's/ [^ ]* [0-9][0-9]*s$//')
    case "$n:$got" in
        pass:PASS|skip:SKIP|"failx:FAIL(exit 3)"|"failline:FAIL(exit 0)"|"slow:FAIL(timeout 1s)") t_pass "$n" ;;
        # a FAIL line beats exit 77: reporting a failing subcase and then
        # skipping must not launder the failure into a SKIP.
        "failskip:FAIL(exit 77)") t_pass "$n" ;;
        # 1m must parse to 60s, and a malformed header must fall back to the
        # default rather than becoming alarm(0) = no deadline at all.
        minhdr:PASS|bogus:PASS|badhdr:PASS) t_pass "$n" ;;
        *) t_fail "$n" "status $got" ;;
    esac
done
t_done
