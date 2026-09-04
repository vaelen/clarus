#!/bin/sh
# testsuite/catalog.sh -- port of internal/testsuite/catalog_test.go
# TestCatalogChecks: a bare catalog file has no app/on handler, so it
# cannot be checked alone. This composes the same minimal driver (>=1
# symbol referenced per catalog file, so the declarations must actually
# bind, not merely parse) and runs clarusc in check-only mode (bare
# positional files) over driver + every catalog file.
#
# The driver text is copied verbatim from catalog_test.go's catalogDriver.
. "$(dirname "$0")/../lib.sh"

cat > "$WORK/driver.cla" <<'CLA_EOF'
on App.startCLI(args: list of string) {
    var ev: EventRecord
    var t0: int
    var p: ptr
    var err: int
    var rep: SFReply
    var tl: SFTypeList
    var vp: VolumeParam
    var pr: Str255
    var fp: FileParam
    var iop: IOParam
    var rh: ptr
    var cr: CntrlReset
    var cc: CntrlCount
    var cb: CntrlSetBuf
    var ci: CInfoPBRec
    var hp: HFileParam
    var cm: CMovePBRec
    var hr: HIOParamRename

    t0 = TickCount()
    p = NewPtr(4)
    err = ZeroScrap()
    err = GestaltErr(0x73797376)
    t0 = t0 + GestaltValue(0x73797376)
    if EventAvail(everyEvent, ev) {
        t0 = t0 + ev.what
    }
    DisposePtr(p)
    SysBeep(1)
    if t0 < 0 {
        t0 = 0
    }

    tl.t0 = 0x54455854
    pr.s = "Save as:"
    vp.ioNamePtr = ptr(0)
    vp.ioVRefNum = 0
    err = PBSetVolSync(vp)
    SFGetFile((100 << 16) | 100, pr, ptr(0), 1, tl, ptr(0), rep)
    SFPutFile((100 << 16) | 100, pr, pr, ptr(0), rep)
    if rep.good {
        t0 = t0 + rep.vRefNum
    }

    fp.ioNamePtr = ptr(0)
    fp.ioVRefNum = 0
    fp.ioFDirIndex = 0
    err = PBGetFInfoSync(fp)
    fp.fdType = 0x54455854
    fp.fdCreator = 0x4D505320
    err = PBSetFInfoSync(fp)
    if err != 0 {
        t0 = t0 + 1
    }

    iop.ioNamePtr = ptr(0)
    iop.ioVRefNum = 0
    err = PBCreateSync(iop)
    err = PBOpenRFSync(iop)
    err = PBWriteSync(iop)
    err = PBCloseSync(iop)

    rh = Get1NamedResource(0x54455854, pr)
    ReleaseResource(rh)

    err = AEInstallEventHandler(kCoreEventClass, kAEQuitApplication, ptr(0), 0, false)
    err = AEProcessAppleEvent(ptr(0))

    err = PBOpenSync(iop)
    err = PBReadSync(iop)
    cr.csCode = kSERDConfiguration
    cr.csParam0 = baud9600 + data8 + noParity + stop10
    err = PBControlSync(cr)
    cc.csCode = kSERDInputCount
    err = PBStatusSync(cc)
    cb.csCode = kSERDInputBuffer
    err = PBControlSync(cb)
    err = PBKillIOSync(iop)
    t0 = t0 + kSERDSerHShake + kSERDStatus + cc.csCount

    iop.ioVersNum = 0
    iop.ioPermssn = fsRdWrPerm
    err = PBGetEOFSync(iop)
    iop.ioMisc = ptr(0)
    err = PBSetEOFSync(iop)
    err = PBGetFPosSync(iop)
    iop.ioPosMode = fsFromStart
    err = PBSetFPosSync(iop)
    err = PBFlushFileSync(iop)
    err = PBFlushVolSync(iop)
    err = PBAllocateSync(iop)
    t0 = t0 + fsAtMark + fsFromLEOF + fsFromMark + fsCurPerm + fsRdPerm + fsWrPerm

    ci.ioNamePtr = ptr(0)
    ci.ioVRefNum = 0
    ci.ioFDirIndex = 0
    ci.ioDirID = 0
    err = PBGetCatInfoSync(ci, hfsSelGetCatInfo)
    err = PBSetCatInfoSync(ci, hfsSelSetCatInfo)
    hp.ioNamePtr = ptr(0)
    hp.ioDirID = 0
    err = PBDirCreateSync(hp, hfsSelDirCreate)
    err = PBHDeleteSync(hp)
    hr.ioNamePtr = ptr(0)
    hr.ioMisc = ptr(0)
    hr.ioDirID = 0
    err = PBHRenameSync(hr)
    err = PBHGetFInfoSync(hp)
    err = PBHSetFInfoSync(hp)
    err = PBHOpenRFSync(hp)
    cm.ioNamePtr = ptr(0)
    cm.ioNewDirID = 0
    err = PBCatMoveSync(cm, hfsSelCatMove)
    if (ci.ioFlAttrib & ioDirMask) != 0 {
        t0 = t0 + 1
    }
    t0 = t0 + fnfErr + fBsyErr + dupFNErr + dirNFErr + fsRtDirID
}
CLA_EOF

n=CatalogChecks
if "$CLARUSC" "$WORK/driver.cla" \
        "$ROOT/toolbox/memory.cla" \
        "$ROOT/toolbox/events.cla" \
        "$ROOT/toolbox/osutils.cla" \
        "$ROOT/toolbox/scrap.cla" \
        "$ROOT/toolbox/standardfile.cla" \
        "$ROOT/toolbox/files.cla" \
        "$ROOT/toolbox/resources.cla" \
        "$ROOT/toolbox/appleevents.cla" \
        "$ROOT/toolbox/devices.cla" \
        "$ROOT/toolbox/serial.cla" \
        > "$WORK/catalog.log" 2>&1; then
    t_pass "$n"
else
    t_fail "$n" "clarusc check failed: $(head -5 "$WORK/catalog.log" | tr '\n' ' ')"
fi
t_done
