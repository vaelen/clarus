#!/bin/sh
# Port of internal/sertest/sertest_test.go TestBadFieldRejected: a record with
# a `text` field reaching file.save must fail clarusc emit loudly (lower.cla's
# lowCheckSerializableFields) instead of silently emitting an unserializable
# layout table -- nonzero exit, and the value-field message on stderr. No
# golden: this fixture never successfully emits.
. "$(dirname "$0")/../lib.sh"

WANT='file.save: record Note field body is not a value type'

"$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/out.c" testdata/sertest/badfield.cla \
    > "$WORK/stdout" 2> "$WORK/stderr"
rc=$?

if [ $rc -eq 0 ]; then
    t_fail exit "want nonzero exit, got success (stderr: $(cat "$WORK/stderr"))"
else
    t_pass exit
fi
if grep -Fq "$WANT" "$WORK/stderr"; then
    t_pass diagnostic
else
    t_fail diagnostic "stderr \"$(cat "$WORK/stderr")\" missing \"$WANT\""
fi
t_done
