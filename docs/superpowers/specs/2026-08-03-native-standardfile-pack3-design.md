# Native Standard File (_Pack3) port — design

Date: 2026-08-03. Follow-up to the 5e UI runtime port
(`2026-08-01-native-5e-ui-runtime-design.md`): closes one of its recorded
deferred stubs. Native-lane only; the cprint/Retro68 lane's Standard File
support (`rt_ext_mac.inc:635-659`, itself a verbatim adaptation of
`rt_ui.c:2399-2455`) is already real and stays byte-untouched.

## Problem

On a real (non-`--events`) native boot, `askOpen`/`askSave` do nothing:
`nat_UiSFGetFile`/`nat_UiSFPutFile` (`runtime/clarus/uidialogs.cla:92-122`)
are deferred stubs returning `false` — SFReply's "user cancelled" — so
every Open/Save menu pick silently takes the cancelled path. First
observed live 2026-08-03 in the native texteditor (the same session that
found the UiTickCount/UiMenuKey real-event-loop convention bugs, commit
5faaa6c).

The stub's stated blocker — "SFGetFile/SFPutFile are routine-selector
Pascal traps ... not a plain trap this language's `= trap` clause can
express" — was written in Task 12 and is stale since Task 14 added the
`= trap TRAPWORD sel SELECTOR` clause for the List Manager. The Universal
Interfaces encoding `THREEWORDINLINE(0x3F3C, <sel>, 0xA9EA)` is exactly
what the `sel` clause emits (`MOVE.W #sel,-(SP)` then the trap word).
What remains is the argument marshaling and SFReply decode.

## Decision summary

Port the two stub BODIES to real Clarus, native lane only. The waist
externs `UiSFGetFile(path255Out: ptr): bool` /
`UiSFPutFile(suggested255: ptr, path255Out: ptr): bool` keep their exact
declarations, so the cprint lane (which resolves them to the existing
`rt_ext_` C wrappers) is structurally unaffected.

Alternatives rejected: making the raw SF traps the shared waist for both
lanes (forces new C glue plus `int`→`Point` conversion on the proven
lane, no behavioral gain); System 7 `StandardGetFile` (sel 6) with an S6
fallback (YAGNI — the C lane ships classic SFGetFile on both systems).

## New externs (uidialogs.cla, private to the file)

```
external func UiSFGetFilePack(where: int, prompt: ptr, fileFilter: ptr,
    numTypes: word, typeList: ptr, dlgHook: ptr, reply: ptr)
    = trap 0xA9EA sel 0x0002
external func UiSFPutFilePack(where: int, prompt: ptr, origName: ptr,
    dlgHook: ptr, reply: ptr)
    = trap 0xA9EA sel 0x0001
```

Selectors byte-verified against
`Retro68/InterfacesAndLibraries/Interfaces/CIncludes/StandardFile.h`
(SFPutFile `THREEWORDINLINE(0x3F3C, 0x0001, 0xA9EA)`, SFGetFile
`... 0x0002 ...`). Marshaling, slot by slot:

- `where: int` — Point by value, packed `(v << 16) | h` = `(100 << 16) |
  100`, pushed as one `.L`. Hardware-proven pattern: `UiLClick(pt: int,
  ...)` / `UiLSetSelect(theCell: int, ...)` (uitable.cla).
- `prompt`/`origName`: `ptr` to a Pascal string in scratch — `""` (a
  single 0x00 length byte) for Get, `"Save as:"` (len 8) for Put,
  mirroring the C reference's literals.
- `fileFilter`/`dlgHook`: `ptr(0)` (NULL, both lanes agree).
- `numTypes: word` = 1; `typeList: ptr` — 4-byte scratch holding
  `'TEXT'` (0x54455854), poked as one long.
- `reply: ptr` — 74-byte scratch (SFReply: `good` byte @0, `copy` @1,
  `fType` @2, `vRefNum` word @6, `version` @8, `fName` Str63 @10).

`SetVol` after a good reply (the C reference's own step — makes the
picked volume the default so the plain-path `file.readText`/`writeText`
that follows resolves on it): new `external func UiSetVolPB(pb: ptr): int
= trap 0xA015 reg` in the same PB-trap style as native.cla's file family
(`NatOpen`/`NatFlushVol`); VolumeParam scratch with `ioNamePtr` @18 = 0,
`ioVRefNum` @22 = reply's vRefNum. Result ignored, matching C.

Note the naming/location asymmetry with `NatSetVol`-style expectations:
the extern lives in uidialogs.cla with the `Ui` prefix because runtime
extern names are file-prefixed to dodge irRegisterExtern's no-dedup rule
(the 5b convention), and no other file needs it.

## Stub bodies (the whole behavioral change)

Each body is the rt_ext_mac.inc wrapper transcribed:

- `nat_UiSFGetFile(path255Out)`: build scratches → `UiSFGetFilePack` →
  `good` false ⇒ return false; else SetVol(vRefNum), copy `fName` into
  `path255Out` (length byte + bytes, `UiBlockMoveData`, ≤ 64 bytes so no
  clamp needed against a Str255 target), return true.
- `nat_UiSFPutFile(suggested255, path255Out)`: same with
  `UiSFPutFilePack` (suggested255 passes through as `origName`).

Scratch buffers via `UiNewPtr`/`UiDisposePtr` per call (dialog-rate, not
hot). Error surface mirrors C exactly: the bool is the only result; a
SetVol failure is ignored; `lastError` is not involved. The cancel path
returns false — the identical net behavior to today's stubs, so existing
callers regress in no case.

## Verification (decided: live-drive + goldens; no new machinery)

Automated self-driving was investigated and is cleanly impossible on
System 6: the classic Standard File `dlgHook` fires only on item hits
(`sfHookNullEvent` is a 7.0 pseudo-item), so an inputless boot sits in
the modal dialog forever. A host-side coordinate-injection harness was
considered and rejected as fragile. Therefore:

1. **Scripted lane frozen**: `rtUiAskOpen`/`rtUiAskSave`'s scripted
   branches are untouched; the full 23-scenario gate must stay green
   against the frozen goldens (native never blesses).
2. **Listing goldens pin the call shape**: one `CLARUS_CG68K_BLESS=1`
   re-bless; the new `MOVE.W #$0001/#$0002,-(SP)` + `DC.W $A9EA` shapes
   are eyeball-checked against the THREEWORDINLINE encoding before any
   boot (a wrong selector/slot crashes real hardware — the List Manager
   selector bug's class).
3. **Live-drive acceptance** (the 4c standard, per Andrew 2026-08-03):
   native texteditor in Mini vMac — type text, Save via the real
   SFPutFile dialog, quit, relaunch, Open via the real SFGetFile dialog,
   verify content roundtrip; plus Cancel on each dialog verified as a
   clean no-op. TestRealEventLoopTickOn68k (commit 5faaa6c) already
   covers the real-loop plumbing the dialogs sit on.

## Non-goals

- TE↔Scrap port (`nat_UiTEFromScrap`/`nat_UiTEToScrap`) — native
  cut/copy/paste; different mechanism (executor glue, no A-trap), stays
  a recorded 5e limit.
- AE/GetAppFiles launch (`nat_UiLaunchReal` stays startEmpty).
- System 7 StandardFile/CustomGetFile variants (sel 5-8).
- Any automated modal-dialog driving harness.

## Files touched

- `runtime/clarus/uidialogs.cla` — 3 new externs, 2 stub bodies become
  real (~60 lines).
- `testdata/cg68k/*.s` — golden re-bless fallout only.
- No clarusc, no C runtime, no reference/doc surface changes (Ch12/Ch13
  already describe the behavior being implemented).
