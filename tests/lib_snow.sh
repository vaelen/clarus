# tests/lib_snow.sh -- helpers for tests/mactest/snow/*.sh (sourced right
# after lib.sh). POSIX sh. Ported from internal/mactest/snow_test.go's own
# snowDisk/runHfs/putText/putMacBinary/get/getMacBinary/runSnow, plus the
# fork-comparison helpers macresident_test.go shares with
# clarusc_bake_test.go (readForkFromMacBinary, normalizeForkReserved,
# macResidentExtractApp).
#
# Snow (snow/ClarusSnow) is a real macOS GUI app with no headless mode: a
# boot occupies the whole screen for its entire run, which is why every
# script in this group gates on its own CLARUS_SNOW_TESTS (never
# CLARUS_MAC_TESTS) and why two boots must never overlap.
#
# ClarusSnow, not Snow: snow/ClarusSnow -> snow/Snow.app/Contents/MacOS/Snow
# is a private COPY of the emulator whose executable has a different
# name, so a Clarus boot and Andrew's own long-running BBS `Snow` are
# distinguishable by process name. Everything in this file that looks for
# "another emulator" therefore matches `ClarusSnow` only -- a BBS Snow
# must not block a Clarus boot, and nothing here may ever quit one.

SNOW_BIN=$ROOT/snow/ClarusSnow
SNOW_HFS=$ROOT/toolchain/bin

# --- hfsutils --------------------------------------------------------
# Every hfsutils call runs with HOME pinned to the scratch dir: these
# tools keep the "currently mounted volume" pointer in $HOME/.hcwd, real
# cross-process shared state, so each scratch disk needs its own HOME
# (snow_test.go's runHfs doc comment).
snow_hfs() {
    _tool=$1
    shift
    HOME=$SNOW_DIR "$SNOW_HFS/$_tool" "$@" || die "hfs $_tool $*: failed"
}
snow_mount()  { snow_hfs hmount "$SNOW_IMG" > /dev/null; }
snow_umount() { HOME=$SNOW_DIR "$SNOW_HFS/humount" > /dev/null 2>&1 || :; }

# snow_hfs_path NAME : bare name -> volume-root path (":NAME"); an
# already-colon-prefixed path passes through (snow_test.go's hfsPath).
snow_hfs_path() {
    case "$1" in
        :*) echo "$1" ;;
        *) echo ":$1" ;;
    esac
}

# snow_abs PATH : absolutize a workspace-relative path (bare filename in
# snow/Clarus.snoww, e.g. "rominator.rom") against snow/; an absolute one
# passes through (snowAbsPath).
snow_abs() {
    case "$1" in
        /*) echo "$1" ;;
        *) echo "$ROOT/snow/$1" ;;
    esac
}

# _snow_ws_val KEY FILE : the string value of one one-per-line
# "KEY": "VALUE" pair in a .snoww JSON file.
_snow_ws_val() {
    sed -n "s|^ *\"$1\": *\"\\([^\"]*\\)\".*|\\1|p" "$2" | head -1
}

# _snow_ws_set KEY VALUE : rewrite one key's string value in $SNOW_WS in
# place, preserving the line's own indentation and trailing comma, then
# verify the rewrite actually landed -- a silently-missed rewrite would
# leave the scratch workspace pointing at the PRISTINE snow/ original and
# let a boot write to it.
_snow_ws_set() {
    sed "s|^\\( *\"$1\": *\\)\"[^\"]*\"|\\1\"$2\"|" "$SNOW_WS" > "$SNOW_WS.new" \
        || die "rewrite $1 in $SNOW_WS"
    mv "$SNOW_WS.new" "$SNOW_WS"
    [ "$(_snow_ws_val "$1" "$SNOW_WS")" = "$2" ] \
        || die "$SNOW_WS: $1 rewrite did not take (still $(_snow_ws_val "$1" "$SNOW_WS"))"
}

# snow_disk : clone snow/Clarus.snoww's own scsi_targets[0] disk image and
# snow/clarus.pram into $WORK/snow and write a scratch workspace naming
# them, with rom_path/display_card_rom_path absolutized -- newSnowDisk,
# done fresh per script so a run never sees another run's (or a crashed
# run's) leftover Startup Items debris. Sets SNOW_DIR, SNOW_IMG, SNOW_WS.
snow_disk() {
    SNOW_DIR=$WORK/snow
    rm -rf "$SNOW_DIR"
    mkdir -p "$SNOW_DIR" || die "mkdir $SNOW_DIR"
    _tpl=$ROOT/snow/Clarus.snoww
    [ -f "$_tpl" ] || die "read snow/Clarus.snoww: not found"

    # Disk image name comes from the template's own scsi_targets[0].Disk,
    # never hardcoded here (a stale hardcoded name broke this once).
    _disk=$(_snow_ws_val Disk "$_tpl")
    [ -n "$_disk" ] || die "snow/Clarus.snoww: scsi_targets[0].Disk missing or empty"

    SNOW_IMG=$SNOW_DIR/hdd0.img
    cp "$(snow_abs "$_disk")" "$SNOW_IMG" || die "clone $_disk"
    cp "$ROOT/snow/clarus.pram" "$SNOW_DIR/clarus.pram" || die "clone snow/clarus.pram"

    SNOW_WS=$SNOW_DIR/scratch.snoww
    cp "$_tpl" "$SNOW_WS" || die "clone snow/Clarus.snoww"
    _snow_ws_set rom_path "$(snow_abs "$(_snow_ws_val rom_path "$_tpl")")"
    _snow_ws_set display_card_rom_path "$(snow_abs "$(_snow_ws_val display_card_rom_path "$_tpl")")"
    _snow_ws_set pram_path "$SNOW_DIR/clarus.pram"
    _snow_ws_set Disk "$SNOW_IMG"
    for _f in "$(_snow_ws_val rom_path "$SNOW_WS")" \
              "$(_snow_ws_val display_card_rom_path "$SNOW_WS")" \
              "$SNOW_IMG" "$SNOW_DIR/clarus.pram"; do
        [ -f "$_f" ] || die "scratch workspace names a missing file: $_f"
    done
}

# snow_ethernet [ID] : attach Snow's DaynaPORT SCSI/Link Ethernet adapter at
# SCSI ID (default 3 -- the ID snow/MacII.snoww uses and the ID the guest's
# DaynaPORT driver was installed against) in the SCRATCH workspace, which
# snow_disk clones from snow/Clarus.snoww (no adapter; "ethernet_link_type":
# "NAT" is already there). Call it after snow_disk and before snow_run.
#
# scsi_targets is one ENTRY per ID: a bare "None"/"Ethernet" string on its
# own line, or a three-line {"Disk": ...} object -- so entries are counted by
# the line that STARTS one, never by line number.
# ponytail: rewrite in place with awk; the file is a few dozen lines of
# one-key-per-line JSON, which is why the rest of this file sed-edits it too.
# A real JSON parser only pays off if Snow ever emits nested/compact output.
snow_ethernet() {
    _id=${1:-3}
    awk -v id="$_id" '
        /"scsi_targets": \[/ { inarr = 1; n = -1; print; next }
        inarr && /^[ \t]*\]/ { inarr = 0 }
        inarr && /^[ \t]*("None"|"Ethernet"|\{)/ {
            n++
            if (n == id) { sub(/"None"/, "\"Ethernet\"") }
        }
        { print }' "$SNOW_WS" > "$SNOW_WS.new" || die "snow_ethernet: rewrite failed"
    mv "$SNOW_WS.new" "$SNOW_WS"
    # A silently-missed rewrite would boot a guest with no link at all, and
    # every MacTCP probe would then fail for the wrong reason.
    grep -q '"Ethernet"' "$SNOW_WS" \
        || die "snow_ethernet: no Ethernet entry at SCSI id $_id after rewrite"
}

# snow_put FILE MACPATH : stage FILE in text mode (hcopy -t) at MACPATH
# (bare = volume root). putText -- data files NEVER go into Startup
# Items, where Finder auto-opens every item and a data file throws a
# blocking dialog before the real app gets a turn.
snow_put() {
    snow_mount
    snow_hfs hcopy -t "$1" "$(snow_hfs_path "$2")"
    snow_umount
}

# snow_put_bin BIN [NAME] : install a MacBinary build (forks preserved)
# into ":System Folder:Startup Items:", the harness's proven no-click
# auto-launch mechanism (putMacBinary). NAME defaults to BIN's basename
# without .bin, which is the Go call sites' own name in every case.
snow_put_bin() {
    _nm=${2:-$(basename "$1" .bin)}
    snow_mount
    snow_hfs hcopy -m "$1" ":System Folder:Startup Items:$_nm"
    snow_umount
}

# snow_get MACPATH OUT : extract in text mode (get).
snow_get() {
    snow_mount
    snow_hfs hcopy -t "$(snow_hfs_path "$1")" "$2"
    snow_umount
    [ -f "$2" ] || die "read extracted $1: not created"
}

# snow_get_bin MACPATH OUT : extract in MacBinary mode (getMacBinary).
snow_get_bin() {
    snow_mount
    snow_hfs hcopy -m "$(snow_hfs_path "$1")" "$2"
    snow_umount
    [ -f "$2" ] || die "read extracted $1: not created"
}

# snow_extract_app NAME OUT : extract a bare-named app written by
# file.writeRes, trying the volume root then Startup Items -- natWriteRes
# pokes no ioDirID, so the landing directory is not a sure thing
# (macResidentExtractApp). On a miss at both, prints an hls listing of
# both directories (re-mounting first, since the loop always unmounts)
# and returns 1; the caller t_fails so the listings stay in the log.
snow_extract_app() {
    _nm=$1
    _out=$2
    for _cand in ":$_nm" ":System Folder:Startup Items:$_nm"; do
        snow_mount
        if HOME=$SNOW_DIR "$SNOW_HFS/hcopy" -m "$_cand" "$_out" > "$WORK/hcopy.log" 2>&1; then
            snow_umount
            echo "$_nm extracted from $_cand ($(wc -c < "$_out" | tr -d ' ') bytes)"
            return 0
        fi
        echo "miss $_cand: $(tr '\n' ' ' < "$WORK/hcopy.log")"
        snow_umount
    done
    snow_mount
    echo "volume root listing:"
    HOME=$SNOW_DIR "$SNOW_HFS/hls" -l ":" 2>&1
    echo "Startup Items listing:"
    HOME=$SNOW_DIR "$SNOW_HFS/hls" -l ":System Folder:Startup Items:" 2>&1
    snow_umount
    return 1
}

# --- resource forks --------------------------------------------------
# snow_fork MACBIN OUT : slice MACBIN's resource fork (length from the
# 128-byte MacBinary header's big-endian uint32 at offset 87 --
# readForkFromMacBinary) and zero bytes 16..255, the Inside-Macintosh
# reserved span a live Mac's own Resource/File Manager scribbles
# filename/type/creator bookkeeping into (normalizeForkReserved). Both
# sides of every comparison are normalized this way.
snow_fork() {
    _img=$1
    _out=$2
    _n=$(wc -c < "$_img" | tr -d ' ')
    [ "$_n" -ge 128 ] || die "$_img: image too short: $_n bytes"
    _len=$(dd if="$_img" bs=1 skip=87 count=4 2>/dev/null \
        | od -An -tu1 | awk 'NR==1{print $1*16777216 + $2*65536 + $3*256 + $4}')
    [ -n "$_len" ] || die "$_img: cannot read resource fork length"
    [ "$_len" -le $(( _n - 128 )) ] \
        || die "$_img: resource fork length $_len exceeds remaining image bytes $(( _n - 128 ))"
    tail -c +129 "$_img" | head -c "$_len" > "$_out.raw" || die "slice fork of $_img"
    _z=$(( _len - 16 ))
    [ "$_z" -lt 0 ] && _z=0
    [ "$_z" -gt 240 ] && _z=240
    {
        head -c 16 "$_out.raw"
        [ "$_z" -gt 0 ] && dd if=/dev/zero bs=1 count="$_z" 2>/dev/null
        [ "$_len" -gt 256 ] && tail -c +257 "$_out.raw"
        :
    } > "$_out" || die "normalize fork of $_img"
}

# snow_fork_same NAME MACBIN ORACLEBIN : the byte-identity oracle -- the
# on-Mac app's normalized fork vs the host compiler's. Prints the first
# divergence and returns 1 on mismatch (dumpForkMismatch: report it,
# don't paper over it).
snow_fork_same() {
    snow_fork "$2" "$WORK/$1-mac.fork"
    snow_fork "$3" "$WORK/$1-host.fork"
    cmp -s "$WORK/$1-mac.fork" "$WORK/$1-host.fork" && return 0
    echo "$1 fork mismatch: on-Mac $(wc -c < "$WORK/$1-mac.fork" | tr -d ' ') bytes vs host oracle $(wc -c < "$WORK/$1-host.fork" | tr -d ' ') bytes"
    cmp "$WORK/$1-mac.fork" "$WORK/$1-host.fork" 2>&1 | head -1
    echo "on-Mac fork, first 64 bytes:"
    head -c 64 "$WORK/$1-mac.fork" | od -An -tx1
    echo "host oracle fork, first 64 bytes:"
    head -c 64 "$WORK/$1-host.fork" | od -An -tx1
    return 1
}

# snow_oracle FIXTURE OUT : FIXTURE compiled by the CURRENT-source host
# compiler via plain emit68k -- no --bake, --events or --partition, the
# same flags the on-Mac compile never sets either (buildHostOracleFork's
# build half; snow_fork does its fork slicing).
snow_oracle() {
    emit68k -o "$2" "$1" > "$WORK/oracle.log" 2>&1 \
        || die "clarusc emit68k -o $2 $1: $(tail -5 "$WORK/oracle.log" | tr '\n' ' ')"
}

# snow_count NEEDLE FILE : occurrences of NEEDLE (strings.Count).
snow_count() { grep -o -F -- "$1" "$2" | wc -l | tr -d ' '; }

# snow_no_error_markers NAME FILE : gcCompile's every error path calls
# alert(), and alert() -- unlike gcLog, which only ever reaches the
# on-screen Log textview -- writes live into this captured stream, so any
# of these markers in the trace is a real compile-error signal.
snow_no_error_markers() {
    _found=
    for _bad in 'cannot open entry file' 'emit68k failed' 'write failed' 'error:' 'warning:'; do
        grep -qF -- "$_bad" "$2" && _found="$_found \"$_bad\""
    done
    if [ -n "$_found" ]; then
        t_fail "$1" "app out contains compile-error signals:$_found"
        return 1
    fi
    t_pass "$1"
}

# --- booting ---------------------------------------------------------
# settle_seconds VALUE : "2h"/"12m"/"45s"/bare seconds -> seconds. Go's
# time.ParseDuration equivalent for CLARUS_MACRESIDENT_SETTLE; a value
# that isn't one of those forms dies, as ParseDuration's error does.
settle_seconds() {
    case "$1" in
        *[0-9]h) _n=${1%h}; _mul=3600 ;;
        *[0-9]m) _n=${1%m}; _mul=60 ;;
        *[0-9]s) _n=${1%s}; _mul=1 ;;
        *) _n=$1; _mul=1 ;;
    esac
    case "$_n" in
        ''|*[!0-9]*) die "settle \"$1\": want Nh/Nm/Ns or bare seconds" ;;
    esac
    echo $(( _n * _mul ))
}

# snow_run SECS DONE_CMD [SNOW_ARGS...] : boot $SNOW_WS in Snow, poll
# DONE_CMD (via sh -c) every 2s until it succeeds or SECS of wall clock
# elapse, then quit Snow and wait up to 20s for its process to exit
# (runSnow). Two failure paths deliberately do NOT fall through to the
# caller's extraction:
#   - Snow dying during the poll loop is caught within one poll tick;
#   - a quit that needed a force-kill dies loudly: SIGKILL can land in the
#     middle of an image write, so the image is untrustworthy afterwards
#     and asserting against it would be asserting against possibly torn
#     sectors. (This is NOT the older claim that guest writes only reach
#     the host image on a clean exit -- Snow writes guest sectors through
#     as the guest flushes them, measured; see snow_done_when_trailer.)
# The done command is what the Go done() closure was: it may block for as
# long as its own internal budgets allow (SECS is only the outer bound).
snow_run() {
    _secs=$1
    _done=$2
    shift 2
    [ -x "$SNOW_BIN" ] || die "$SNOW_BIN not found (snow/ClarusSnow symlink missing?)"
    # Never launch alongside another ClarusSnow: two boots fight over the
    # screen. Deliberately NOT `pgrep -x Snow` -- that also matches
    # Andrew's BBS instance, which shares nothing with a test boot but the
    # application, and must neither block one nor be touched by one.
    _other=$(pgrep -x ClarusSnow | tr '\n' ' ')
    [ -z "$_other" ] || die "another ClarusSnow process is already running (pid $_other) -- refusing to boot"

    "$SNOW_BIN" "$SNOW_WS" "$@" > "$WORK/snow.log" 2>&1 &
    SNOW_PID=$!
    # snow_localtalk_b's background clicker is armed BEFORE this launch
    # and so cannot see $SNOW_PID; it waits for this file instead, which
    # is both "our own Snow is up" and "and this is its pid".
    echo "$SNOW_PID" > "$WORK/snow.pid"
    # Safety net: never leave Snow on screen if this script dies below.
    trap 'kill -9 "$SNOW_PID" 2>/dev/null; rm -rf "$WORK"' EXIT

    _deadline=$(( $(date +%s) + _secs ))
    while [ "$(date +%s)" -lt "$_deadline" ]; do
        kill -0 "$SNOW_PID" 2>/dev/null \
            || die "Snow exited early: $(tail -5 "$WORK/snow.log" | tr '\n' ' ')"
        sh -c "$_done" && break
        sleep 2
    done

    # Quit OUR pid, never the app name: `osascript -e 'quit app "Snow"'`
    # would also quit a BBS Snow running beside us (same application,
    # different process). That -- not any property of SIGTERM -- is the
    # whole reason this is a signal.
    #
    # Whether Snow HANDLES SIGTERM (running its writeback_mode path) is
    # UNVERIFIED: it exits promptly, but the shipped binary carries no
    # signal-handling symbols (no SIGTERM/signal_hook/ctrlc strings), so
    # most likely there is no handler and the writeback path is skipped.
    # Nothing here depends on the answer, which is why it is acceptable:
    # Snow writes guest sectors through to $SNOW_IMG as the guest flushes
    # them (measured -- snow_done_when_trailer's own comment), and callers
    # gate the quit on a done command that requires the wanted bytes to be
    # in the HOST image already. The quit's flush behaviour is therefore
    # not load-bearing for the extraction that follows it. A caller that
    # instead quits on a timer (snow_settle_done) is trusting the guest to
    # have flushed by then, which was already true before this change.
    #
    # The shell's own "Terminated: 15" job notice for $SNOW_PID lands in
    # the test log here. It is the expected quit, not a failure -- the
    # real verdict is the graceful-exit loop below.
    kill -TERM "$SNOW_PID" 2>/dev/null
    _g=0
    while kill -0 "$SNOW_PID" 2>/dev/null; do
        if [ $_g -ge 20 ]; then
            kill -9 "$SNOW_PID" 2>/dev/null
            wait "$SNOW_PID" 2>/dev/null
            trap 'rm -rf "$WORK"' EXIT
            die "Snow did not quit gracefully within 20s; force-killed pid $SNOW_PID -- disk image is untrustworthy after a forced kill, failing instead of extracting from it"
        fi
        sleep 1
        _g=$(( _g + 1 ))
    done
    wait "$SNOW_PID" 2>/dev/null
    trap 'rm -rf "$WORK"' EXIT
}

# snow_localtalk_b : turn Snow's LocalTalk-over-UDP bridge on for SCC
# channel B (the printer port), which is the port the guest's own PRAM
# has AppleTalk on. That bridge puts the emulated LocalTalk network on
# 239.192.76.84:1954 -- the same LToUDP group every Mini vMac boot, the
# host `atalkdrive` tool and tests/atalk/ already share -- so it is what
# makes a Snow guest visible to the rest of the AppleTalk lane. Without
# it the guest still has a perfectly live AppleTalk stack (drivers open,
# NBP registers, node acquired from the PRAM hint) talking to nobody:
# measured, task-13c-report.md's network question.
#
# There is no non-GUI way to do this in Snow v1.5.0-b81dbcc:
#   - `--serial-bridge-b` accepts only "pty" and "tcp:PORT"; any other
#     value is a WARN ("Invalid serial bridge mode") and is ignored;
#   - the setting is not one of the Workspace struct's serde fields, so
#     saving a .snoww does not carry it (Clarus.snoww and Andrew's
#     networked MacII.snoww are byte-identical in this respect);
#   - it is not in ~/Library/Application Support/snowemu/Snow/settings.json
#     either, so it does not survive a quit;
#   - and the guest's PRAM only chooses which PORT AppleTalk uses -- it
#     cannot reach the host side of the wire at all.
# What is left is Snow's own Ports menu, which egui draws INSIDE the
# window (Snow's macOS menu bar has just Apple + Snow, so System Events
# cannot see it), clicked by screen position. All three items hang off
# the window's TOP-LEFT corner, so these offsets do not depend on the
# window's size or the guest's screen resolution:
#     Ports                    (+250, +49)
#     Channel B (printer)      (+310, +95)
#     Enable LocalTalk (UDP)   (+498, +184)
#
# Fragile by construction -- a Snow release that moves those menus breaks
# it -- but never SILENTLY: Snow logs "LocalTalk bridge enabled" on its
# own stdout ($WORK/snow.log), and this waits for that line and dies with
# the geometry it used if it never arrives. The right long-term fix is a
# `--serial-bridge-b localtalk` flag upstream, the same one-line shape as
# the LaunchAPPL AppleTalk patch.
#
# Both System Events lookups below name OUR process by unix id (read from
# $WORK/snow.pid, which snow_run writes at launch), never `process
# "Snow"`: the binary we exec is named ClarusSnow, so a name lookup would
# either miss it or -- worse -- find Andrew's BBS Snow and post clicks
# into that window.
#
# `window 1` is System Events' FRONTMOST window of that process, not
# necessarily the emulator window -- a modal Snow dialog (writeback ask,
# a file picker) would be window 1 instead and the clicks would land on
# it. Our own boots open none, and the log-line check below is what
# notices if one ever does.
#
# snow_run BLOCKS for the whole boot, so this cannot be called after it:
# it arms a BACKGROUND clicker that waits for Snow's window to appear
# (up to 60s) and then clicks. **It must only be started once snow_run is
# about to launch**: it waits for $WORK/snow.log, which nothing but our
# own snow_run creates, so an orphaned clicker (the caller died before
# snow_run ever ran, e.g. on snow_run's own "another Snow is already
# running" refusal) can never post clicks into somebody else's Snow
# window. It also gives up the moment $WORK is gone, which is how both
# EXIT traps in this file say "the parent is finished". `wait` for
# $SNOW_LTALK_PID afterwards. Clicking early is also correct on the
# guest's terms: the bridge only has to exist before the guest opens
# .MPP and acquires an LLAP node, which is ~35s into the boot (measured
# -- see adsp_listener.sh's own timing-budget comment).
snow_localtalk_b() {
    (
        # A backgrounded subshell inherits lib.sh's `rm -rf "$WORK"` EXIT
        # trap in some shells; dropping it here keeps this from deleting
        # the work directory the parent is still writing into.
        trap - EXIT
        _i=0
        _pos=
        _pid=
        while [ $_i -lt 60 ]; do
            [ -d "$WORK" ] || exit 1          # parent gone; both EXIT traps rm $WORK
            # $WORK/snow.pid is written by snow_run's own launch and by
            # nothing else: until it exists, the only emulator that could
            # be running is somebody else's.
            if [ -f "$WORK/snow.pid" ]; then
                _pid=$(cat "$WORK/snow.pid")
                _pos=$(osascript -e "tell application \"System Events\" to get position of window 1 of (first process whose unix id is $_pid)" 2>/dev/null)
                case "$_pos" in *,*) break ;; esac
                _pos=
            fi
            sleep 1
            _i=$(( _i + 1 ))
        done
        if [ -z "$_pos" ]; then
            echo "snow_localtalk_b: no window from our own Snow after ${_i}s (snow.pid $([ -f "$WORK/snow.pid" ] && echo "pid $_pid" || echo absent))"
            exit 1
        fi
        _x=${_pos%%,*}
        _y=${_pos##*, }
        echo "snow_localtalk_b: Snow window at $_x,$_y after ${_i}s"
        osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $_pid) to true" \
            > /dev/null 2>&1
        # Ports -> Channel B (printer) -> Enable LocalTalk (UDP). Neither
        # stream is discarded: a missing `swift` or a revoked Accessibility
        # permission has to show up in ltalk.log, not masquerade as
        # "Snow's menu layout moved".
        for _off in "250 49" "310 95" "498 184"; do
            swift "$ROOT/scripts/click.swift" \
                $(( _x + ${_off%% *} )) $(( _y + ${_off##* } ))
            sleep 1
        done
        _i=0
        while [ $_i -lt 20 ]; do
            if grep -q 'LocalTalk bridge enabled' "$WORK/snow.log" 2>/dev/null; then
                echo "snow_localtalk_b: $(grep 'LocalTalk bridge started' "$WORK/snow.log" | tail -1)"
                exit 0
            fi
            sleep 1
            _i=$(( _i + 1 ))
        done
        echo "snow_localtalk_b: Snow never logged \"LocalTalk bridge enabled\" after clicking (+250,+49)/(+310,+95)/(+498,+184) from window origin $_x,$_y -- Snow's Ports menu layout probably moved"
        exit 1
    ) > "$WORK/ltalk.log" 2>&1 &
    SNOW_LTALK_PID=$!
}

# snow_settle_done SECS : print a DONE_CMD for snow_run that becomes true
# SECS from now -- the elapsed-time proxy for a guest with no completion
# signal at all (one that never quits, e.g. a real-tick event loop).
# A guest that ENDS its trace with the ##CLARUS-EXIT## trailer should use
# snow_done_when_trailer instead: that is a real signal, and Snow does
# write guest sectors through to $SNOW_IMG mid-boot (measured -- see that
# helper), so it can be polled.
snow_settle_done() {
    echo "test \"\$(date +%s)\" -ge $(( $(date +%s) + $1 ))"
}

# snow_done_when_trailer HOLD_SECS : print a DONE_CMD for snow_run that is
# true once the guest has written a NEW '##CLARUS-EXIT##' -- the trace
# trailer natQuit writes as the very last thing before ExitToShell -- into
# the live disk image, and it has stayed there for HOLD_SECS.
#
# Measured (clarusc_boot boot, 2026-09-06): Snow writes guest sectors
# through to $SNOW_IMG as the guest flushes them, so the trailer really does
# appear in the host file mid-boot -- 29s into a boot whose settle ran to
# 45s. The file's MTIME never moves (Snow keeps the image mapped), so only
# the CONTENT is a usable signal. Must be called after snow_disk +
# snow_put_bin: the count is taken relative to a baseline of the staged
# volume, because ClarusC.APPL's baked runtime SOURCE names the trailer in
# native.cla's comments (4 matches on a staged ClarusC volume) -- while a
# produced app never does, natQuit pokes those 16 bytes one at a time and
# no binary carries the literal.
#
# HOLD_SECS gives the app's own EARLIER writes (the compiled .APPL's forks)
# and the guest's catalog flush time to reach the image -- Snow's graceful
# quit cannot flush the GUEST's own cache. The first-seen epoch lives in a
# marker file under $WORK, dropped again if the match count ever falls back.
# Callers keep a generous snow_run SECS as the CEILING: a guest that never
# writes a trailer still times out there, and the caller's own clean_exit
# check then fails exactly as it always did.
snow_done_when_trailer() {
    _mark=$WORK/trailer-seen
    rm -f "$_mark"
    _base=$(grep -a -o '##CLARUS-EXIT##' "$SNOW_IMG" | wc -l | tr -d ' ')
    printf '%s\n' "{ test \$(grep -a -o '##CLARUS-EXIT##' \"$SNOW_IMG\" | wc -l) -gt $_base || { rm -f \"$_mark\"; false; }; } && { [ -f \"$_mark\" ] || date +%s > \"$_mark\"; } && test \$(date +%s) -ge \$(( \$(cat \"$_mark\") + $1 )) && echo \"snow: exit trailer (over baseline $_base) first seen at epoch \$(cat \"$_mark\"), held ${1}s, quitting at epoch \$(date +%s)\""
}
