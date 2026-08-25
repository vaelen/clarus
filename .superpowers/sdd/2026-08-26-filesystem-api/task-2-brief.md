### Task 2: `toolbox/files.cla` — HFS catalog/directory traps + records

**Files:**
- Modify: `toolbox/files.cla` (append after the `fsFromMark` const block at the end).
- Modify: `internal/testsuite/catalog_test.go` (the `catalogDriver` handler body, ~lines 95-110, already references `PBGetFInfoSync`/`PBCreateSync`/`PBOpenRFSync`).
- Modify: `docs/clarus-toolbox-cookbook.md` (new §7 walkthrough after `## 6. Walkthrough: selector dispatch — LAddRow`, ~line 454).

**Interfaces:**
- Produces (used verbatim by Task 5): `extern record HFileParam`, `extern record CInfoPBRec`, `extern record CMovePBRec`; `external func PBGetCatInfoSync(paramBlock: ptr, selector: int): int`, `PBSetCatInfoSync(paramBlock: ptr, selector: int): int`, `PBDirCreateSync(paramBlock: ptr, selector: int): int`, `PBCatMoveSync(paramBlock: ptr, selector: int): int`, `PBHDeleteSync(paramBlock: ptr): int`, `PBHRenameSync(paramBlock: ptr): int`, `PBHGetFInfoSync(paramBlock: ptr): int`, `PBHSetFInfoSync(paramBlock: ptr): int`, `PBHOpenRFSync(paramBlock: ptr): int`; consts `hfsSelCatMove = 5`, `hfsSelDirCreate = 6`, `hfsSelGetCatInfo = 9`, `hfsSelSetCatInfo = 10`, `ioDirMask = 0x10`, `fsRtDirID = 2`, `dupFNErr = -48`, `fnfErr = -43`, `fBsyErr = -47`.

- [ ] **Step 1: Write the failing catalog check**

Extend `catalogDriver` in `internal/testsuite/catalog_test.go` so it binds at least one new symbol of each new kind. Insert after the existing `iop`-using lines:

```
    var ci: CInfoPBRec
    var hp: HFileParam
    var cm: CMovePBRec
    ci.ioNamePtr = ptr(0)
    ci.ioVRefNum = 0
    ci.ioFDirIndex = 0
    ci.ioDirID = 0
    err = PBGetCatInfoSync(ci, hfsSelGetCatInfo)
    hp.ioNamePtr = ptr(0)
    hp.ioDirID = 0
    err = PBDirCreateSync(hp, hfsSelDirCreate)
    err = PBHDeleteSync(hp)
    err = PBHRenameSync(hp)
    err = PBHGetFInfoSync(hp)
    err = PBHSetFInfoSync(hp)
    err = PBHOpenRFSync(hp)
    cm.ioNamePtr = ptr(0)
    cm.ioNewDirID = 0
    err = PBCatMoveSync(cm, hfsSelCatMove)
    if (ci.ioFlAttrib & ioDirMask) != 0 {
        t0 = t0 + 1
    }
```

(Match the surrounding code's variable-declaration placement — Clarus requires `var` lines at the top of the handler; move the three `var`s up.)

- [ ] **Step 2: Run to verify it fails**

Run: `go test -count=1 ./internal/testsuite -run 'TestCatalogChecks|TestCatalogComposesWithUIRuntime' -v 2>&1 | tail -20`
Expected: FAIL — `undefined: CInfoPBRec` (or the first unknown name).

- [ ] **Step 3: Append the declarations to `toolbox/files.cla`**

Follow the file's provenance-comment discipline exactly (every trap: the `#pragma parameter` line, the `EXTERN_API`/`INLINE` line with reflowed `Files.h` line numbers from Task 1's report, the `Files.a` macro corroboration, the bit-11 test, the convention conclusion; every record: the layout walk with offsets). The HFSDispatch block's comment must explain: `_HFSDispatch` (`0xA260`) is ONE trap word shared by the HFS routines, distinguished by a selector the glue preloads into D0 (`moveq #N,D0` — the `TWOWORDINLINE(0x70NN, 0xA260)` first word IS that `moveq`); bit 11 is clear so it is the register convention, so the selector is simply one more `reg`-bound parameter (`reg(a0: paramBlock, d0: selector) ret d0`) that the caller passes as a literal constant — NOT `seld0` (which is the Pascal-convention D0-selector shape, mutually exclusive with `reg`, reference ~line 1807). Declarations (offsets to be re-verified against Task 1's table; names of unused fields become `pad`):

```
// ---- HFS directory / catalog family (filesystem-api phase, Task 2) ...

extern record HFileParam {
    qLink: ptr
    qType: word
    ioTrap: word
    ioCmdAddr: ptr
    ioCompletion: ptr
    ioResult: word
    ioNamePtr: ptr
    ioVRefNum: word
    ioFRefNum: word
    ioFVersNum: byte
    filler1: byte
    ioFDirIndex: word
    ioFlAttrib: byte
    ioFlVersNum: byte
    fdType: int
    fdCreator: int
    fdFlags: word
    fdLocationV: word
    fdLocationH: word
    fdFldr: word
    ioDirID: int
    ioFlStBlk: word
    ioFlLgLen: int
    ioFlPyLen: int
    ioFlRStBlk: word
    ioFlRLgLen: int
    ioFlRPyLen: int
    ioFlCrDat: int
    ioFlMdDat: int
}

extern record CInfoPBRec {
    qLink: ptr
    qType: word
    ioTrap: word
    ioCmdAddr: ptr
    ioCompletion: ptr
    ioResult: word
    ioNamePtr: ptr
    ioVRefNum: word
    ioFRefNum: word
    ioFVersNum: byte
    filler1: byte
    ioFDirIndex: word
    ioFlAttrib: byte
    ioACUser: byte
    fdType: int
    fdCreator: int
    pad[8]
    ioDirID: int
    ioDrNmFls: word
    ioFlLgLen: int
    ioFlPyLen: int
    ioFlRStBlk: word
    ioFlRLgLen: int
    ioFlRPyLen: int
    ioFlCrDat: int
    ioFlMdDat: int
    ioFlBkDat: int
    pad[16]
    ioFlParID: int
    ioFlClpSiz: int
}

extern record CMovePBRec {
    qLink: ptr
    qType: word
    ioTrap: word
    ioCmdAddr: ptr
    ioCompletion: ptr
    ioResult: word
    ioNamePtr: ptr
    ioVRefNum: word
    filler1: int
    ioNewName: ptr
    filler2: int
    ioNewDirID: int
    pad[8]
    ioDirID: int
}

external func PBGetCatInfoSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBSetCatInfoSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBDirCreateSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBCatMoveSync(paramBlock: ptr, selector: int): int = trap 0xA260 reg(a0: paramBlock, d0: selector) ret d0
external func PBHDeleteSync(paramBlock: ptr): int = trap 0xA209 reg
external func PBHRenameSync(paramBlock: ptr): int = trap 0xA20B reg
external func PBHGetFInfoSync(paramBlock: ptr): int = trap 0xA20C reg
external func PBHSetFInfoSync(paramBlock: ptr): int = trap 0xA20D reg
external func PBHOpenRFSync(paramBlock: ptr): int = trap 0xA20A reg

const hfsSelCatMove: int = 5
const hfsSelDirCreate: int = 6
const hfsSelGetCatInfo: int = 9
const hfsSelSetCatInfo: int = 10

const ioDirMask: int = 0x10
const fsRtDirID: int = 2

const fnfErr: int = -43
const fBsyErr: int = -47
const dupFNErr: int = -48
```

`CInfoPBRec` is declared as its `HFileInfo` variant; the comment lists the `DirInfo` overlaps a caller reads for a folder (`ioDrDirID` = `ioDirID`@48, `ioDrNmFls`@52 = `ioFlStBlk`'s slot, `ioDrCrDat`@76 = `ioFlCrDat`'s slot? — NO: verify; `DirInfo` has `filler3[9]` after `ioDrNmFls`, so `ioDrCrDat` is @72 = `ioFlCrDat`'s slot only if the arithmetic in Task 1's report says so; cite the report). `PBHRename`'s new name travels in `ioMisc`@28 — declare it on `HFileParam` by naming the `ioFDirIndex`/`ioFlAttrib`/`ioFlVersNum` slots… no: `ioMisc` lives in the `HIOParam` variant at offset 28 overlapping `ioFDirIndex`+`ioFlAttrib`+`ioFlVersNum`. Rather than a second record, add a separate small `extern record HIOParamRename { ... ioNamePtr: ptr  ioVRefNum: word  ioRefNum: word  ioVersNum: byte  ioPermssn: byte  ioMisc: ptr  pad[16]  ioDirID: int }` sized 52 — confirm offsets (`ioMisc`@28, `ioDirID`@48) against Task 1's table.

Also update the file's header comment: it says "DELIBERATELY THIN"; replace that paragraph with one sentence noting the filesystem-api phase filled the HFS directory/catalog family and pointing at this block.

- [ ] **Step 4: Run the catalog tests**

Run: `go test -count=1 ./internal/testsuite -run 'TestCatalogChecks|TestCatalogComposesWithUIRuntime' -v 2>&1 | tail -20`
Expected: PASS (both lanes compose).

- [ ] **Step 5: Cookbook walkthrough**

Add `## 7. Walkthrough: _HFSDispatch — a selector in D0 under the register convention` to `docs/clarus-toolbox-cookbook.md` after §6: quote `PBGetCatInfoSync`'s `TWOWORDINLINE(0x7009, 0xA260)`, decode `0x7009` as `MOVEQ #9,D0`, apply the bit-11 test, show the resulting `reg(a0: paramBlock, d0: selector) ret d0` declaration and a call `PBGetCatInfoSync(ci, hfsSelGetCatInfo)`, and contrast with §6's `sel` and the reference's `seld0` (why neither applies: both are Pascal-convention shapes). ~40 lines.

- [ ] **Step 6: T1 + commit**

Run: `scripts/test-task.sh --smoke 2>&1 | tail -15`
Expected: all PASS.

```bash
git add toolbox/files.cla internal/testsuite/catalog_test.go docs/clarus-toolbox-cookbook.md
git commit -m "feat: toolbox/files.cla HFS catalog/directory family (GetCatInfo/DirCreate/CatMove via _HFSDispatch, HDelete/HRename/HGetFInfo/HSetFInfo/HOpenRF)"
```

---

