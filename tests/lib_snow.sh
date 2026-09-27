# tests/lib_snow.sh -- helpers for tests/mactest/snow/*.sh (sourced right
# after lib.sh). POSIX sh. Ported from internal/mactest/snow_test.go's own
# snowDisk/runHfs/putText/putMacBinary/get/getMacBinary/runSnow, plus the
# fork-comparison helpers macresident_test.go shares with
# clarusc_bake_test.go (readForkFromMacBinary, normalizeForkReserved,
# macResidentExtractApp).
#
# Snow (snow/clarus-snow, a Linux build of the Snow emulator) is a GUI app
# with no headless mode: a boot opens a window on the X display for its
# entire run, which is why every script in this group gates on its own
# CLARUS_SNOW_TESTS (never CLARUS_MAC_TESTS) and why two boots must never
# overlap (snow_lock).
#
# Two machines, both a Macintosh SE with 4MB (snow/macse.rom, SE model,
# default RAM), picked by SNOW_SYSTEM (default 6) or snow_disk's argument:
#   6  snow/system6.snoww: SCSI 0 system6.img (System 6.0.8 + MultiFinder)
#   7  snow/system7.snoww: SCSI 0 system7.img (System 7.1)
# and SCSI 1 snow/clarus.img, the scratch "Clarus" volume, in both.
# snow_disk clones both images into $WORK and boots a scratch workspace
# naming the clones -- the pristine snow/ files are never written, and are
# also what Andrew boots himself via snow/system6 / snow/system7.
#
# Our process is identified by the PID snow_run launched and by nothing
# else: `clarus-snow` is ALSO the binary behind Andrew's own snow/system6 and
# snow/system7 sessions, and his BBS/SE/30 run `snowemu`. We exec it through
# a symlink under $WORK (so `ps` shows a path unique to this run), refuse to
# boot only while another TEST boot holds $BR/snow.lock, and only ever
# signal $SNOW_PID. Nothing here may pgrep/pkill by name.

SNOW_HFS=$ROOT/toolchain/bin

# --- hfsutils --------------------------------------------------------
# Every hfsutils call runs with HOME pinned to the scratch dir: these
# tools keep the "currently mounted volume" pointer in $HOME/.hcwd, real
# cross-process shared state, so each scratch disk needs its own HOME
# (snow_test.go's runHfs doc comment). hmount picks the one HFS partition
# of the partitioned SCSI images by itself ("contains 1 HFS partition").
snow_hfs() {
    _tool=$1
    shift
    HOME=$SNOW_DIR "$SNOW_HFS/$_tool" "$@" || die "hfs $_tool $*: failed"
}
# snow_mount [IMG] : default the BOOT volume ($SNOW_IMG).
snow_mount()  { snow_hfs hmount "${1:-$SNOW_IMG}" > /dev/null; }
snow_umount() { HOME=$SNOW_DIR "$SNOW_HFS/humount" > /dev/null 2>&1 || :; }

# snow_hfs_path NAME : bare name -> volume-root path (":NAME"); an
# already-colon-prefixed path passes through (snow_test.go's hfsPath).
snow_hfs_path() {
    case "$1" in
        :*) echo "$1" ;;
        *) echo ":$1" ;;
    esac
}

# _snow_ws_val KEY FILE : the string value of the first one-per-line
# "KEY": "VALUE" pair in a .snoww JSON file.
_snow_ws_val() {
    sed -n "s|^ *\"$1\": *\"\([^\"]*\)\".*|\1|p" "$2" | head -1
}

# _snow_ws_sub KEY OLD NEW : rewrite the "KEY": "OLD" pair(s) in $SNOW_WS
# to "KEY": "NEW", then verify it landed -- a silently-missed rewrite would
# leave the scratch workspace pointing at a PRISTINE snow/ original and
# let a boot write to it.
_snow_ws_sub() {
    sed "s|\"$1\": *\"$2\"|\"$1\": \"$3\"|" "$SNOW_WS" > "$SNOW_WS.new" \
        || die "rewrite $1 in $SNOW_WS"
    mv "$SNOW_WS.new" "$SNOW_WS"
    grep -qF "\"$1\": \"$3\"" "$SNOW_WS" || die "$SNOW_WS: $1 $2 -> $3 rewrite did not take"
}

# _snow_hfs_start IMG : the first block of IMG's Apple_HFS partition (an
# Apple Partition Map walk: entry 1's pmMapBlkCnt at +4, each entry's
# pmPyPartStart at +8 and pmParType at +48).
_snow_be32() { od -An -tu1 -j "$2" -N 4 "$1" | awk '{print $1*16777216 + $2*65536 + $3*256 + $4}'; }
_snow_hfs_start() {
    _n=$(_snow_be32 "$1" $(( 512 + 4 )))
    _i=1
    while [ "$_i" -le "$_n" ]; do
        if [ "$(dd if="$1" bs=1 skip=$(( _i * 512 + 48 )) count=9 2>/dev/null)" = Apple_HFS ]; then
            _snow_be32 "$1" $(( _i * 512 + 8 ))
            return 0
        fi
        _i=$(( _i + 1 ))
    done
    die "$1: no Apple_HFS partition in its partition map"
}

# snow_disk [6|7] : clone the chosen machine's boot image and snow/clarus.img
# into $WORK/snow and write a scratch workspace naming them, with rom_path
# absolutized -- newSnowDisk, done fresh per script so a run never sees
# another run's (or a crashed run's) leftover debris. Sets SNOW_DIR,
# SNOW_SYS, SNOW_IMG (the boot volume, where the app and its `out` live),
# SNOW_CLARUS_IMG (the "Clarus" volume, where snow_put stages data) and
# SNOW_APPDIR (the boot-volume directory snow_put_bin installs into, with a
# trailing colon; the app's own default directory, so its `out` is
# "${SNOW_APPDIR}out").
snow_disk() {
    SNOW_SYS=${1:-${SNOW_SYSTEM:-6}}
    case $SNOW_SYS in
        6) SNOW_APPDIR=":System Folder:" ;;
        7) SNOW_APPDIR=":System Folder:Startup Items:" ;;
        *) die "SNOW_SYSTEM=$SNOW_SYS: want 6 or 7" ;;
    esac
    SNOW_DIR=$WORK/snow
    rm -rf "$SNOW_DIR"
    mkdir -p "$SNOW_DIR" || die "mkdir $SNOW_DIR"
    _tpl=$ROOT/snow/system$SNOW_SYS.snoww
    [ -f "$_tpl" ] || skip "snow/system$SNOW_SYS.snoww not present"

    SNOW_WS=$SNOW_DIR/scratch.snoww
    cp "$_tpl" "$SNOW_WS" || die "clone $_tpl"
    # scsi_targets[0] is the boot disk, [1] the Clarus volume; the names come
    # from the template itself, never hardcoded here.
    _disks=$(sed -n 's|^ *"Disk": *"\([^"]*\)".*|\1|p' "$_tpl")
    _boot=$(echo "$_disks" | sed -n 1p)
    _clar=$(echo "$_disks" | sed -n 2p)
    [ -n "$_boot" ] && [ -n "$_clar" ] \
        || die "$_tpl: want two scsi_targets Disk entries, got: $_disks"
    SNOW_IMG=$SNOW_DIR/boot.img
    SNOW_CLARUS_IMG=$SNOW_DIR/clarus.img
    cp "$ROOT/snow/$_boot" "$SNOW_IMG" || die "clone snow/$_boot"
    cp "$ROOT/snow/$_clar" "$SNOW_CLARUS_IMG" || die "clone snow/$_clar"
    _snow_ws_sub Disk "$_boot" "$SNOW_IMG"
    _snow_ws_sub Disk "$_clar" "$SNOW_CLARUS_IMG"
    _rom=$(_snow_ws_val rom_path "$_tpl")
    _snow_ws_sub rom_path "$_rom" "$ROOT/snow/$_rom"
    grep -q '"pram_path": null' "$SNOW_WS" \
        || die "$_tpl: pram_path is not null -- it would name a pristine PRAM file"
    for _f in "$ROOT/snow/$_rom" "$SNOW_IMG" "$SNOW_CLARUS_IMG"; do
        [ -f "$_f" ] || die "scratch workspace names a missing file: $_f"
    done
}

# _snow_set_hello NAME : System 6 autolaunch. Point the boot volume's boot
# blocks' bbHelloName (the Str15 at +0x5A, "the startup program", which is
# "MultiFinder" on system6.img) at NAME, a program in the blessed System
# Folder -- exactly what LaunchAPPL does to its own Mini vMac boot disk.
# The system launches NAME in place of MultiFinder and the bbShellName
# Finder once it quits, so the app runs under the single-application
# System 6 environment, NOT under MultiFinder. (System 6 has no Startup
# Items; MultiFinder's own "Set Startup" list lives in an undocumented
# 'fndr' resource of "Finder Startup", which this does not attempt.)
_snow_set_hello() {
    _len=$(printf %s "$1" | wc -c | tr -d ' ')
    [ "$_len" -ge 1 ] && [ "$_len" -le 15 ] || die "startup program name \"$1\": want 1-15 bytes"
    _bb=$(( $(_snow_hfs_start "$SNOW_IMG") * 512 ))
    [ "$(dd if="$SNOW_IMG" bs=1 skip=$_bb count=2 2>/dev/null)" = LK ] \
        || die "$SNOW_IMG: no LK boot blocks at byte $_bb"
    { printf "\\$(printf %03o "$_len")%s" "$1"; head -c $(( 15 - _len )) /dev/zero; } \
        | dd of="$SNOW_IMG" bs=1 seek=$(( _bb + 90 )) conv=notrunc 2>/dev/null \
        || die "write bbHelloName"
    _got=$(dd if="$SNOW_IMG" bs=1 skip=$(( _bb + 91 )) count="$_len" 2>/dev/null)
    [ "$_got" = "$1" ] || die "bbHelloName rewrite did not take (read back \"$_got\")"
}

# snow_put FILE MACPATH : stage FILE in text mode (hcopy -t) at MACPATH
# (bare = volume root) on the scratch "Clarus" volume -- data files never
# go next to the app on the boot volume (in System 7's Startup Items the
# Finder would auto-open them and throw a blocking dialog). A fixture
# reaches them by the absolute pathname "Clarus:NAME", which works from
# wherever the app itself was launched.
snow_put() {
    snow_mount "$SNOW_CLARUS_IMG"
    snow_hfs hcopy -t "$1" "$(snow_hfs_path "$2")"
    snow_umount
}

# snow_put_bin BIN [NAME] : install a MacBinary build (forks preserved)
# into $SNOW_APPDIR on the boot volume and make it launch itself at boot
# with no clicks (putMacBinary). NAME defaults to BIN's basename without
# .bin. System 7: ":System Folder:Startup Items:", which the Finder opens
# at boot. System 6: the blessed ":System Folder:" plus _snow_set_hello.
snow_put_bin() {
    _nm=${2:-$(basename "$1" .bin)}
    snow_mount
    snow_hfs hcopy -m "$1" "$SNOW_APPDIR$_nm"
    snow_umount
    [ "$SNOW_SYS" = 6 ] && _snow_set_hello "$_nm"
    :
}

# snow_get MACPATH OUT [IMG] : extract in text mode (get), from the boot
# volume unless IMG names another image (e.g. $SNOW_CLARUS_IMG).
snow_get() {
    snow_mount "${3:-$SNOW_IMG}"
    snow_hfs hcopy -t "$(snow_hfs_path "$1")" "$2"
    snow_umount
    [ -f "$2" ] || die "read extracted $1: not created"
}

# snow_get_bin MACPATH OUT : extract from the boot volume in MacBinary
# mode (getMacBinary).
snow_get_bin() {
    snow_mount
    snow_hfs hcopy -m "$(snow_hfs_path "$1")" "$2"
    snow_umount
    [ -f "$2" ] || die "read extracted $1: not created"
}

# snow_extract_app NAME OUT : extract a bare-named app written by
# file.writeRes, trying the boot volume root then $SNOW_APPDIR --
# natWriteRes pokes no ioDirID, so the landing directory is not a sure
# thing (macResidentExtractApp). On a miss at both, prints an hls listing
# of both directories (re-mounting first, since the loop always unmounts)
# and returns 1; the caller t_fails so the listings stay in the log.
snow_extract_app() {
    _nm=$1
    _out=$2
    for _cand in ":$_nm" "$SNOW_APPDIR$_nm"; do
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
    echo "$SNOW_APPDIR listing:"
    HOME=$SNOW_DIR "$SNOW_HFS/hls" -l "$SNOW_APPDIR" 2>&1
    snow_umount
    return 1
}

# snow_skip_clarusc : ClarusC.APPL (scripts/build-clarusc-mac.sh) is built
# with a 48MB SIZE(-1) partition and needs ~14MB of live heap for a single
# compile; both Snow machines are 4MB SEs. Skip, don't fail, until the
# compiler fits (docs/superpowers/specs/2026-09-27-se-memory-footprint-
# findings.md). CLARUS_SNOW_CLARUSC=1 boots it anyway.
snow_skip_clarusc() {
    [ "${CLARUS_SNOW_CLARUSC:-}" = 1 ] && return 0   # force a boot anyway
    skip "ClarusC.APPL needs a 48MB partition (~14MB live heap per compile); the Snow machines are 4MB Macintosh SEs"
}

# snow_skip_no_network WHAT : Snow's LocalTalk bridge has no non-GUI switch
# on Linux (the macOS lane clicked Snow's in-window Ports menu with
# CGEvents; that clicker was removed, not ported), and the SE workspaces
# carry no DaynaPORT/MacTCP. The Snow networked lanes wait for that.
snow_skip_no_network() {
    skip "$1: Snow LocalTalk/MacTCP lanes deferred on Linux -- no non-GUI bridge switch; re-enabled after the SE-memory program"
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

# snow_lock / snow_unlock : a mkdir mutex under $BR, holder pid inside,
# stolen if the holder died (tests/lib_atalk.sh's atalk_lock shape). It is
# what "another test boot is running" means: only OUR boots take it, so
# Andrew's own clarus-snow/snowemu sessions neither block a boot nor are
# ever looked at.
snow_lock() {
    _lk=$BR/snow.lock
    mkdir -p "$BR"
    while ! mkdir "$_lk" 2>/dev/null; do
        _owner=$(cat "$_lk/pid" 2>/dev/null)
        if [ -n "$_owner" ] && kill -0 "$_owner" 2>/dev/null; then
            die "another Snow test boot is running (script pid $_owner holds $_lk) -- refusing to boot"
        fi
        rm -rf "$_lk"          # holder died without releasing; steal it
    done
    echo $$ > "$_lk/pid"
    SNOW_LOCK=$_lk
}
snow_unlock() {
    [ -n "${SNOW_LOCK:-}" ] || return 0
    [ "$(cat "$SNOW_LOCK/pid" 2>/dev/null)" = "$$" ] && rm -rf "$SNOW_LOCK"
    SNOW_LOCK=
}

# snow_run SECS DONE_CMD [SNOW_ARGS...] : boot $SNOW_WS in Snow, poll
# DONE_CMD (via sh -c) every 2s until it succeeds or SECS of wall clock
# elapse, then quit Snow and wait up to 20s for its process to exit
# (runSnow). Two failure paths deliberately do NOT fall through to the
# caller's extraction:
#   - Snow dying during the poll loop is caught within one poll tick;
#   - a quit that needed a force-kill dies loudly: SIGKILL can land in the
#     middle of an image write, so the image is untrustworthy afterwards.
# The done command may block for as long as its own internal budgets
# allow (SECS is only the outer bound). SNOW_ARGS go to clarus-snow before
# the workspace (e.g. --serial-bridge-a tcp:PORT; pick a free port -- never
# the 6666/7777 Andrew's snow/system6 / snow/system7 use).
snow_run() {
    _secs=$1
    _done=$2
    shift 2
    [ -x "$ROOT/snow/clarus-snow" ] || skip "snow/clarus-snow not present"
    [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] \
        || die "DISPLAY is not set -- emulator boots need an X display (e.g. DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority)"
    snow_lock
    # The exec path is unique to this run, so `ps` tells our boot apart
    # from every other clarus-snow on the machine.
    ln -sf "$ROOT/snow/clarus-snow" "$SNOW_DIR/clarus-snow-test" || die "symlink clarus-snow"

    "$SNOW_DIR/clarus-snow-test" "$@" "$SNOW_WS" > "$WORK/snow.log" 2>&1 &
    SNOW_PID=$!
    # Safety net: never leave Snow on screen if this script dies below.
    trap 'kill -9 "$SNOW_PID" 2>/dev/null; snow_unlock; rm -rf "$WORK"' EXIT
    trap 'kill -9 "$SNOW_PID" 2>/dev/null; snow_unlock; rm -rf "$WORK"; exit 2' INT TERM

    _deadline=$(( $(date +%s) + _secs ))
    while [ "$(date +%s)" -lt "$_deadline" ]; do
        kill -0 "$SNOW_PID" 2>/dev/null \
            || die "Snow exited early: $(tail -5 "$WORK/snow.log" | tr '\n' ' ')"
        sh -c "$_done" && break
        sleep 2
    done

    # Quit OUR pid, never a process name. clarus-snow has no SIGTERM
    # handler (measured on Linux, 2026-09-27: the default action ends it at
    # once, no writeback prompt). Nothing depends on a flush at quit: Snow
    # writes guest sectors through to $SNOW_IMG as the guest flushes them
    # (snow_done_when_trailer's own comment), and callers gate the quit on
    # a done command that requires the wanted bytes to be in the HOST image
    # already, or on a settle timer that trusts the guest to have flushed.
    kill -TERM "$SNOW_PID" 2>/dev/null
    _g=0
    while kill -0 "$SNOW_PID" 2>/dev/null; do
        if [ $_g -ge 20 ]; then
            kill -9 "$SNOW_PID" 2>/dev/null
            wait "$SNOW_PID" 2>/dev/null
            snow_unlock
            trap 'rm -rf "$WORK"' EXIT
            die "Snow did not quit within 20s of SIGTERM; force-killed pid $SNOW_PID -- disk image is untrustworthy after a forced kill, failing instead of extracting from it"
        fi
        sleep 1
        _g=$(( _g + 1 ))
    done
    wait "$SNOW_PID" 2>/dev/null
    snow_unlock
    trap 'rm -rf "$WORK"' EXIT
    trap - INT TERM
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
