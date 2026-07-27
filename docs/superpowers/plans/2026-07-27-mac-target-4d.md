# Mac Target 4d: Forms and Data Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bound form windows, `popup`, `table` (List Manager), the `edit` statement with `accepted`/`cancelled`/`isNew`, and `file.save`/`file.load` — acceptance: the Appendix C Bookmark Manager as a shippable app with persistence.

**Architecture:** One shared artifact — per-record field-layout descriptor tables emitted by cprint — drives both the runtime form binding walker and a byte-canonical serializer whose single source (`rt_ser.inc`) is `#include`d by both runtimes. rt_ui grows two widget kinds (popup kind 6, table kind 7), a filter-flag modal state, and the walker; clarusc's five `lowUnsupported` abort sites on this path become real lowering. New descriptor data rides **trailing** struct fields (C zero-init keeps every existing positional initializer and emit golden byte-identical).

**Tech Stack:** C (classic Toolbox: List Manager, Menu Manager/PopUpMenuSelect, Control Manager popup CDEF on System 7; Retro68), Clarus (clarusc), Go test harnesses, bash.

**Spec:** `docs/superpowers/specs/2026-07-27-mac-target-4d-design.md` (read first).

## Global Constraints

- Go compiler (cmd/clarus, non-test internal/) FROZEN. `internal/build/unsupported_test.go:47-56` pins that Go still aborts on `file.save`/`file.load`/`isNew` — never "fix" that. No file.save fixtures in the six Go-swept testdata dirs, in `testdata/run/`, or in `testdata/suite/` (those build with the FROZEN Go compiler, which cannot lower file.save).
- ZERO checker/parser/ast edits (front end complete and at parity — verified). Only lower.cla/ir.cla/cprint.cla among clarusc files change; snapshot regen after every clarusc edit:
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  go test ./internal/selfhost/
  ```
- New emit fixtures ONLY in `testdata/emitui/` (+ scenarios in `testdata/ui/`). Existing emitui goldens and UI goldens stay **byte-identical** except where a task explicitly regenerates/blesses (the trailing-field rule makes "no churn" the default — a task that changes an old golden without saying so is broken).
- rt_ui.h:1-14 pins the descriptor ABI — new fields go at the END of structs, ABI comment updated; `internal/mactest/uiprobe/probe_ui.c` positional initializers must still compile (trailing fields zero-init, so no edits needed unless a task uses the new fields).
- PORT DISCIPLINE RULE (rt_ui.h:168-181): every new rt_ui entry point that touches the Toolbox saves/sets/restores the port.
- lastError conventions: code 1 = truncation, code 2 = file I/O; host and Mac messages byte-identical. New serializer failures use code 2 + msg `"bad file format"`.
- The pinned bootstrap command (`cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`) must keep working — the serializer is `#include`d, never a new translation unit.
- Full gated suite (`CLARUS_MAC_TESTS=1 go test ./internal/mactest`) green at every task end; host `go test ./...` green at every commit. Emulator env: kill stray `minivmac` processes if the System image is busy.
- Branch: all tasks commit to `mac-target-4d`.

**Key research facts** (verified 2026-07-27 at a1bd812; cite in briefs as needed):

- *Frontend already done, both compilers*: `WidgetInfo.bindsIdx` (check.cla:383-388, set :2065), `windowIsForm`/`windowFormRecType` maps (check.cla:410-411, set :1746-1747), `checkRowsProperty` (check.cla:1967-1985), `checkColumn` (:1990-2007), `checkEditStmt` (:3036-3084), events `popup.change`/`table.select`/`table.doubleClick`/`cancelled` (check.cla:562-571), `accepted` synthesized via `makeSpec1` (:2441-2447). Lowering may READ `recordFieldsHead`/`fieldInfos` and the window maps (established: lower.cla:562-566, :1189-1197).
- *clarusc abort sites to convert*: lower.cla:866 (`file.save/load`, in `lowFileCall` :856-868), :1364 (StEdit falls to generic "statement kind N"; add case after StCancel :1360), :2152-2155 (widget-kind whitelist), :2319-2321 (`DkFormFor`), :2637-2639 (window events accepted/cancelled in `lowWindowHandlerEntry` :2611-2646).
- *isNew defect*: `lowSelect` TyRec arm (lower.cla:1119-1120) emits `(x).cv_isNew` unconditionally → uncompilable C. The "record lacks a literal isNew field" walk to reuse: check.cla:2576-2588. Lowering has `lowCurWinType` (lower.cla:98, save/set :2480-2481, restore :2516) but NO current-handler state — add paired globals `lowCurHandlerEvent`/`lowCurAcceptedParam` with the same save/restore discipline.
- *IR shapes*: `IRWidgetDesc` (ir.cla:263-280, 15-arg ctor :1376-1397, sole caller lower.cla:2224); `IRWindowDesc` (ir.cla:289-299, ctor :1463); `IRWinHandlers` (ir.cla:357-366: winTypeNameIdx + openedFn/closeRequestFn/closedFn/resizedFn/keyFn + widget chain); `IRWidgetHandlerEntry` (ir.cla:376-383: clickFn/changeFn/dragFn/enterFn); `IRMenuDesc.itemsHead → cpEmitMenuItemsArray` (cprint.cla:1968-1986) is the sub-array emission template for column/bind tables. `IRFieldSlot`/`IRRecordLayout` (ir.cla:213-224); record field order = source order (lowRecordDecl lower.cla:2000-2040 walks in lockstep; cpEmitRecords cprint.cla:1471-1514) → `offsetof(clar_rec_R, cv_f)` is authoritative per-platform. `IREnumMember` carries `label` (ir.cla:228-233) — **`irEnumMemberLabel` (ir.cla:1339) has zero readers today**; enum C type is `int32_t` (cpCTypeName cprint.cla:151); member values may be sparse/explicit 0..65535 (check.cla:1435-1445), so ordinal↔value mapping needs BOTH a labels and a values array.
- *Intrinsic pattern* (3 edits): ir.cla nullary name func (e.g. `IFileReadText` ir.cla:2033-2035); lower.cla builds `newIRIntr(name, argsHead, ty)` (ir.cla:1089-1099; widget-set template lower.cla:1565-1602, guard chain :1626-1628); cprint.cla arm in `fpIntrCall` (:635-1061; value-returning `rt_file_read_text` :899-901, void-emit `IUiSetText` :965-967, temp-returning `IFileName` :903-907). Str255 arg = `fpStrAddr` (:565-568); lvalue addr = `fpAddrable` (:536-554); extra args `fpArgAt` (:614).
- *cprint UI emission*: widget rows `cpEmitWidgetDescArray` (:1771-1799, row :1789-1793), kind macro `cpWidgetKindMacro` (:1651-1676, explicit + loud fallthrough — add RTUI_POPUP/RTUI_TABLE), window descs `cpEmitWindowDescs` (:1916-1963, literal :1953-1959), state struct two-pass `cpEmitUiStateStruct` (:1748-1764 — pass 1 cpEnsureType exists because nested typedefs land in the same buffer), win-event dispatcher `cpEmitOneWinEventDispatcher` (:2105-2130; golden shape testdata/emitui/handlers.c.golden:111-134), widget dispatcher `cpEmitOneWidgetDispatcher` (:2138-2181; canvas gets `(inst,(int32_t)a,(int32_t)b)` via `cpWidgetKindForIndex` :1842-1863), conditional scratch-global precedent `clar_ui_cur_cancel` (:2058-2096). `<stddef.h>` NOT yet included — cprint.cla:2571 includes `<stdint.h>` etc.; offsetof needs stddef added unconditionally.
- *lowWidgetDesc walk* (lower.cla:2131-2225): flat if/else over DkProperty names; `binds`/`rows` fall through silently, `DkColumn` nodes fail the `declKind(p)==DkProperty` test (:2172) — columns are INTERLEAVED with properties in `widgetPropsHead`; `columnHeader/Shows/WidthPx/WidthFill` accessors ast.cla:1452-1464. `editForm/editTarget/editIsNew/editNewType` ast.cla:1018-1030. `formForRecord` ast.cla:1480.
- *rt_ui.h inventory* (current): kinds 0-5 (:33-38, next 6/7); flags used 1|2|4|8|16 (next bit 32, none needed); `RTUI_EV_*` 0-4 (:70-74, next 5/6); `RTUI_WEV_*` 0-3 (:77-82, next 4/5); `RTUI_PROP_SELECTED 4` pre-reserved (:98) and `rt_ui_prop_name` already returns "selected" (rt_ui.c:362); `rt_ui_widget_get_int` exists (rt_ui.c:3586-3593, "default: width" fallthrough — new prop case must precede it); **no `rt_ui_widget_set_int`**. Structs verbatim: widget_desc :104-113 (9 fields), window_desc :115-119 (10 fields, handlers last), menu_desc :121-127. `rt_text` fwd decl :164.
- *rt_ui.c geography*: winst struct :222-252 (parallel locked-Handle arrays; refCon tags: widget `i`, V-bar `0x8000|i`, H-bar `0xC000|i`, mask 0x3FFF); open allocs :3184-3207 (`rt_ui_alloc_locked` :259-267); close disposes :3335-3350 (DisposeWindow :3324 kills Controls first); make_widgets :729-810; layout :606-715 (natural size fns :563-590, constants :141-204; `width==0` = omitted; `fill: both` implies width fill; per-kind relayout branch :698-708); update draw loop :1875-1916 (new kinds slot here; LUpdate must sit between BeginUpdate/EndUpdate); activate :1939-1962 (add LActivate); content-click chain :2143-2212 (FindControl → scrollbar tag → widget TrackControl [gUiScripted bypass :2177] → canvas hit :2099 → TE hit :2120; table/popup join as new lanes); fire_widget :1801-1837 (CHECK/BUTTON cases; popup change mirrors CHECK's mutate-trace-fire); key path :2293-2356 (default/cancel EXIST: `rt_ui_find_flagged` :2264-2275, Return/Enter :2344-2347, Escape :2348-2351 exempt from TE swallow :2316; default ring :1841-1849 drawn at :1913-1915); resize :1991-2008 (relayout via rt_ui_layout so per-kind branch gets all three resize paths free); menus: `RTUI_MENU_ID_BASE 2` (:209), Apple=1 (:1367), IDs 2..N+1, bar-position==ID pinned by `menu M I` (:3014-3031) — **popup MenuHandles use `InsertMenu(mh, -1)` + IDs 1000+widgetIndex, never the bar**.
- *4c Gestalt probe is NOT reusable*: inline in `rt_ui_launch`'s non-test branch (rt_ui.c:2649-2662), compiled out under RT_MAC_TEST, tests AE-awareness not system version. New cached probe (`Gestalt(gestaltSystemVersion)` ≥ 0x0700, noErr-else-0) belongs in `rt_ui_startup` (:2416, runs in both modes), file-scope static per the gAeOpenDoc convention (:2487-2493). `#include <Gestalt.h>` already present (:75-76).
- *Script harness*: reader `rt_ui_run_scripted` :3036-3123 (`sscanf "%31s %63s %63s"`; rest-of-line verbs read `line+strlen(verb)+1`); verb table :3051-3119; unknown verbs silently ignored; `gUiScripted` :442 set :3042. Answer queue :460-510 (`rt_ui_answer` {kind,val,str}, ring of 8, `RT_UI_ANS_*` 0-3 — popup takes 4; push_val :494, pop :502 panics empty; kind-mismatch panic in consumers, template `rt_ui_ask_save_changes` :1594-1612). Bypass families: dialogs keyed on `RT_MAC_TEST`, tracking loops (TrackControl :2163-2182, scrollbars :1200-1216) keyed on `gUiScripted` — **PopUpMenuSelect and LClick are tracking loops → gUiScripted family**. `rt_ui_script_click` :2777-2785 (global coords, modifiers 0, `when`/`message` unread); `rt_ui_script_drag` :2817-2840 is the precedent for "verb resolves target itself and fires directly" — the dblclick/table lane follows it. Traces: `rt_test_emit` one line + `\n` (rt_mac.c:152-160); helpers :280-388 (`trace_set_str` :372, `trace_set_bool` :383 — add `trace_set_int` beside them); grammar: non-`T `/non-snap/non-empty capture lines are FATAL (ui_test.go:68); snap = 21,888-byte framebuffer (:2995-3013).
- *ui scenarios*: `runUIScenarioSrc(t, scenario, claRel, wantExit)` (ui_test.go:102-152); `.cla`+`.events`+`.trace` in testdata/ui/, PBMs testdata/uisnaps/`<scenario>.<snap>.pbm`; `CLARUS_MAC_BLESS=1` blesses (still asserts sizes/exit). build-mac.sh compiles with the SNAPSHOT clarusc → scenarios exercise new lowering only after snapshot regen.
- *uiprobe has NO Go-driven goldens* — it is the ABI compile canary + manual eyeball vehicle (cmake `-DRT_MAC_TEST=ON -DUI_EVENTS=<events.c>` per its CMakeLists; LaunchAPPL by hand, read the screenshot). Automated goldens come only from clarusc-emitted scenarios.
- *rt (host) shapes*: `rt_text{data,len,cap}` rt.c:198-202; `rt_list{data,elemsize,count,cap}` :361-366; `rt_map{keys,vals,valsize,count,cap,valcap}` :482-489, MAP_KEYBLOCK 256, always key-sorted (insert via `map_lower_bound` :505-519) → `rt_map_key_at`/`rt_map_val_at` (rt.h:82-83) iterate in key order. **No list/map clear-all exists** — add `rt_list_clear`/`rt_map_clear` (host: `l->count=0`; Mac mirrors in rt_mac.c). `rt_list_at` pointer invalidated by growth. `rt_set_lasterr(int32_t, const char*)` rt.h:32. `rt_text_append_str/char/text`, `rt_text_from_bytes/to_bytes` exist (rt.h:34-51). File fns rt.h:105-107; Mac impls rt_mac.c:998-1056 (`Create(path,0,'MPS ','TEXT')` :1036 hardcoded; Str255 paths on default volume; the FSOpen/SetEOF/FSWrite/FlushVol shape to clone). Creator plumbing: NO runtime symbol carries the app id — use weak `const` default in rt_ui.c overridden by emitted strong def (exact precedent `rt_ui_app_info` rt_ui.c:92-104 + rt_ui.h:143-156); app id source: build-mac.sh:55/241 (`CREATOR "${APPID:-????}"`).
- *Host serializer testing*: `testdata/run` + suite build with FROZEN Go → unusable for file.save. New harness required: Go test that (a) builds clarusc via `build.Build` (template: `internal/emitui/emitui_test.go:53-77` buildClarusc sync.Once), (b) `clarusc emit` the fixture, (c) `cc -I internal/build/rt` + rt.c, (d) run in a temp dir, compare stdout golden AND saved-file bytes golden.
- *fixed repr*: confirm at implementation via rt.h/cprint (grep `fixed`); the walker's fixed parser must produce the same 32-bit representation the runtime already uses for fixed arithmetic/printing — derive from `rt_fixed_*` helpers, do not invent.
- *`gestaltSystemVersion` selector* is in Gestalt.h (grep -a); movable-modal WDEF `movableDBoxProc` (procID 5) is System 7-only → S6 modal opens as `noGrowDocProc` (still draggable; acceptable, note in reference), S7 uses movableDBoxProc via the new probe.

---

### Task 0: Docs-first — reference clarifications + roadmap

**Files:**
- Modify: `docs/clarus-language-reference.md` (Ch10 popup/binds + isNew wording; Ch12 file section)
- Modify: `docs/ROADMAP.md`

**Interfaces:** none (prose only). The three contract clarifications from the spec, worded as normative reference text:
1. Ch10 (popup row of the type-driven table or the binds paragraph, ref :1000-1030): a `popup`'s items come from its bound enum; a popup without `binds:` is rejected at build time.
2. Ch12 file section (after the save/load rows, ref :1241-1245): `file.save`/`load` require every field of the record (transitively, for list/map payloads) to be a value type — `text`, `list`, and `map` fields are a build-time error.
3. Ch10 edit-statement section (ref :1040-1050): `isNew` is defined only on the `accepted` handler's parameter; any other use is a build-time error (unless the record declares a literal `isNew` field, which then shadows it entirely).

- [ ] **Step 1:** Make the three reference edits; ROADMAP: 4d line → "in progress (branch mac-target-4d)"; insert after the 4d bullet a new phase bullet: "**4e (post-4d): memory-management audit** — Handle/close leak sweep: lists, text, maps, menus, window instances, the deferred ClosePort item; decide per-site free-vs-leak-by-design and document." 
- [ ] **Step 2:** `go test ./...` (docs-only change; proves tree still green) and verify with `git diff` that no code changed.
- [ ] **Step 3:** Commit `docs: 4d contract clarifications (popup binds, save/load value fields, isNew scope); roadmap 4d in progress + 4e memory audit`.

### Task 1: Serialization core — layout descriptors + rt_ser.inc + host/Mac rt_file_save/load

**Files:**
- Modify: `internal/build/rt/rt.h` (RT_FT_* codes, `rt_field_desc`, `rt_layout_desc`, `rt_file_save/load`, `rt_list_clear`, `rt_map_clear`)
- Create: `internal/build/rt/rt_ser.inc` (single-source serializer, `#include`d by both runtimes)
- Modify: `internal/build/rt/rt.c` (clear fns, `rt_file_write_data` host, `#include "rt_ser.inc"` at bottom)
- Modify: `runtime/mac/rt_mac.c` (clear fns, `rt_file_write_data` with `'CLRD'` + creator, weak `rt_app_creator` default, `#include` of rt_ser.inc)
- Test: `internal/build/rt/rt_ser_test.c` (hand-written C harness) + `internal/build/sertest_c_test.go` (compiles+runs it host-side)

**Interfaces:**
- Produces (in rt.h — the contract Tasks 2, 6, 7 consume):
  ```c
  #define RT_FT_INT   0  /* int32, 4B BE */
  #define RT_FT_FIXED 1  /* 4B BE, raw runtime representation */
  #define RT_FT_BOOL  2  /* 1B */
  #define RT_FT_CHAR  3  /* 1B */
  #define RT_FT_STR   4  /* 1 len byte + strCap data bytes (fixed width, zero-padded) */
  #define RT_FT_ENUM  5  /* int32 value, 4B BE; load validates membership in enumValues */

  typedef struct { short ftype; short strCap; long offset;
                   short enumCount; const int32_t *enumValues;
                   const unsigned char *const *enumLabels; /* Str255s, popup/table render */
  } rt_field_desc;
  typedef struct { long recSize; short nFields; const rt_field_desc *fields; } rt_layout_desc;

  #define RT_SER_REC  0
  #define RT_SER_LIST 1
  #define RT_SER_MAP  2
  int rt_file_save(const uint8_t *path, short container, const void *data, const rt_layout_desc *ld);
  int rt_file_load(const uint8_t *path, short container, void *data,       const rt_layout_desc *ld);
  void rt_list_clear(rt_list *l);
  void rt_map_clear (rt_map *m);
  ```
  `data` is the record pointer (REC), `rt_list*` (LIST), `rt_map*` (MAP).
- File format (byte-exact on both platforms because the pack/unpack code is shared source writing individual bytes): `'C' 'L' 'R' 'S'`, version byte 1, container byte, payload. Record = fields in layout order per RT_FT_* encodings above. LIST = 4B BE count + records. MAP = 4B BE count + (1 len byte + key bytes + record), natural rt_map key order. Load: bad magic/version/container mismatch/short read/trailing bytes/enum-value-not-member/str len > strCap → `rt_set_lasterr(2, "bad file format")`, return 0, target left as empty collection (cleared first) / untouched record on header failure.
- rt_ser.inc uses ONLY public rt API (`rt_text_*`, `rt_list_*`, `rt_map_*`, `rt_file_read_text` for load input) + one per-runtime primitive each runtime defines BEFORE the include: `static int rt_file_write_data(const uint8_t *path, const rt_text *t);` — host: fopen/fwrite clone of write_text (rt.c:658-670); Mac: the rt_mac.c:1028-1056 shape but `Create(path, 0, rt_app_creator, 'CLRD')`. Creator symbol: declaration `extern const unsigned long rt_app_creator;` in rt.h; weak definition `const unsigned long rt_app_creator __attribute__((weak)) = 0x3F3F3F3FUL; /* '????' */` in rt_mac.c (rt_mac.c is in every Mac link; rt_ui.c is not — CLI programs must still link). Emitted C overrides it with a strong definition when an `app` section declares an id (Task 2), the exact `rt_ui_app_info` weak/strong precedent (rt_ui.c:92-104).
- List element writeback during load: `rt_list_clear` then per record `rt_list_push(l, tmpRec)` — never a held `rt_list_at` pointer across pushes.

- [ ] **Step 1:** Write the failing C test `rt_ser_test.c`: defines a `struct { int32_t a; clar-style str fields via uint8_t[len+cap]; ... }`-equivalent test record + hand-rolled `rt_field_desc[]`, round-trips REC/LIST/MAP through save/load in a temp cwd, asserts loaded equals saved field-by-field, asserts exact expected file bytes for a known record (hex-literal array in the test), asserts each failure mode (truncated file, bad magic, bad enum value) returns 0 + lastError code 2. Driver `sertest_c_test.go`: `cc -I internal/build/rt rt_ser_test.c internal/build/rt/rt.c -o <tmp>/sertest` + run, in `t.TempDir()`. Run: `go test ./internal/build/ -run SerC` → FAIL (undefined rt_file_save).
- [ ] **Step 2:** Implement rt.h declarations, rt_ser.inc, host rt_file_write_data + clears + include; run → PASS.
- [ ] **Step 3:** Mac side: clears + rt_file_write_data + weak creator + include in rt_mac.c. Prove it compiles for 68k: `toolchain/bin/m68k-apple-macos-gcc -x c -c -I internal/build/rt runtime/mac/rt_mac.c -o /tmp/rtmac.o` (match the emitui compile-check flags, emitui_test.go:153-175).
- [ ] **Step 4:** Full host suite `go test ./...` — everything else untouched and green.
- [ ] **Step 5:** Commit `rt: canonical big-endian record serializer (rt_ser.inc), file save/load, list/map clear, CLRD creator plumbing`.

### Task 2: clarusc lowering — file.save/load + layout-table emission

**Files:**
- Modify: `clarusc/lower.cla` (:856-868 lowFileCall; value-field guard; layout-demand tracking)
- Modify: `clarusc/ir.cla` (intrinsics `IFileSave`/`IFileLoad`; per-record "layout needed" registry)
- Modify: `clarusc/cprint.cla` (layout-table emission incl. enum label/value arrays; `<stddef.h>`; fpIntrCall arms)
- Create: `testdata/emitui/filesave.cla` + `.c.golden`
- Create: `internal/sertest/sertest_test.go` + `testdata/sertest/roundtrip.cla` + `.out.golden` + `.bytes.golden`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes Task 1's rt.h contract exactly.
- Produces: for each record type reaching file.save/load (this task) or a form/table (Tasks 5/7 reuse the same emitter), cprint emits once, before window descs:
  ```c
  static const int32_t clar_enumvals_Protocol[] = {0, 1, 2};
  static const unsigned char *const clar_enumlabels_Protocol[] = { (const unsigned char*)"\pGopher", ... };
  static const rt_field_desc clar_fields_Bookmark[] = {
      { RT_FT_STR, 63, (long)offsetof(clar_rec_Bookmark, cv_name), 0, 0, 0 },
      ...
      { RT_FT_ENUM, 0, (long)offsetof(clar_rec_Bookmark, cv_protocol), 3, clar_enumvals_Protocol, clar_enumlabels_Protocol },
  };
  static const rt_layout_desc clar_layout_Bookmark = { (long)sizeof(clar_rec_Bookmark), 5, clar_fields_Bookmark };
  ```
  Emitter name: `cpEmitLayouts()` walking a lower-populated registry (`irLayoutNeeded(recNameIdx)`), enum sub-arrays deduped per enum type. Labels use the existing caption Pascal-literal escaping helper (find it where widget captions are emitted, cpUiCaptionOrNull area cprint.cla:1611-1616).
- When an `app` section declares an id, emit the strong creator override beside the existing `rt_ui_app_info` strong definition: `const unsigned long rt_app_creator = 0x43424B4DUL; /* 'CBKM' */` (4 bytes of the id, big-endian) — overrides Task 1's weak `'????'` default so saved data files carry the app's creator.
- Lowering: `file.save(p, x)` → typecheck-known container from `exprTypeGet(x)` (TyRec/TyList/TyMap) → `newIRIntr(IFileSave(), args: p, containerConst, x-or-&x, layoutRef, ...)` — cprint arm emits `rt_file_save(fpStrAddr(p), RT_SER_REC, (const void*)&(rec), &clar_layout_R)` (REC passes `fpAddrable` address; LIST/MAP pass `fpExpr` handle). **Value-field guard**: walking the record's `fieldInfos`, any field whose type kind is TyText/TyList/TyMap (or a nested record containing one — records can't nest per current resolveType? verify; if nested records are possible, recurse) → `lowUnsupported("file.save: record R field f is not a value type")` — same loud log+quit shape as :866 today.
- isNew guard lands in Task 7, NOT here (keep this task's diff serialization-only).

- [ ] **Step 1:** Failing fixture `testdata/emitui/filesave.cla`: CLI-style program (`on App.startCLI`) declaring an enum + record (string(n)/int/bool/char/fixed/enum fields), `list of` + `map of` vars, calling save and load on all three containers, printing results. `go run ./cmd/clarus` — no wait: emit via clarusc: build clarusc with Go, `clarusc emit` → aborts `file.save` (quote the abort in the task report).
- [ ] **Step 2:** Implement ir/lower/cprint per Interfaces. Emit fixture golden; eyeball: layout tables before use, offsetof/sizeof spelled, stddef included, container tags right, LIST passes the handle not its address. Commit golden. `go test ./internal/emitui/` green (m68k compile of the golden proves rt.h agreement).
- [ ] **Step 3:** Failing host run-test: `internal/sertest/sertest_test.go` — buildClarusc (clone the emitui sync.Once pattern), emit `testdata/sertest/roundtrip.cla`, `cc -I internal/build/rt <out.c> internal/build/rt/rt.c`, run in t.TempDir(); compare stdout to `.out.golden` AND the written data file's bytes to `.bytes.golden` (byte-exact; this pins the format). Also one negative fixture arm: a record with a `text` field under file.save → clarusc exits non-zero with the value-field message (assert stderr, exit≠0; no golden).
- [ ] **Step 4:** Bless the two goldens by running once and committing outputs after eyeballing the hex (magic/version/container header visible; BE ints; padded strings). Re-run → PASS deterministically (map order is sorted; no timestamps in format).
- [ ] **Step 5:** Snapshot regen + `go test ./...` + commit `clarusc: lower file.save/load through emitted record layout tables; host round-trip + byte goldens`.

### Task 3: rt_ui popup widget (manual System 6 path) + set_int + harness verbs

**Files:**
- Modify: `runtime/mac/rt_ui.h` (RTUI_POPUP 6; widget_desc trailing `const void *extra;`; window_desc trailing `const struct rt_ui_form_desc *form;`; form/bind desc structs; `rt_ui_widget_set_int`; ABI comment)
- Modify: `runtime/mac/rt_ui.c` (popup arrays, create/draw/hit/track, set_int/get_int, trace_set_int, answer-popup verb+queue kind, sys7 probe stub)
- Modify: `internal/mactest/uiprobe/probe_ui.c` + a new events variant (manual-validation vehicle)

**Interfaces:**
- Produces (contracts for Tasks 5-8):
  ```c
  #define RTUI_POPUP 6
  /* trailing additions -- existing positional initializers/goldens unaffected (zero-init): */
  /*   rt_ui_widget_desc:  const void *extra;      (table desc later; popup leaves NULL) */
  /*   rt_ui_window_desc:  const struct rt_ui_form_desc *form;  (NULL = not a form)      */
  typedef struct { short widgetIndex; short fieldIndex; } rt_ui_bind_desc;
  typedef struct rt_ui_form_desc { const rt_layout_desc *layout;
                                   short nBinds; const rt_ui_bind_desc *binds; } rt_ui_form_desc;
  void rt_ui_widget_set_int(void *inst, short wIdx, short prop, long v);   /* SELECTED: popup redraw, no change event */
  ```
  rt_ui.h includes nothing new — `rt_layout_desc` needs a fwd decl `typedef struct rt_layout_desc rt_layout_desc;` (same convention as rt_text :164).
- Popup behavior: items = bound enum's labels, found via `form->binds` (bind whose widgetIndex == wIdx) → `form->layout->fields[fieldIndex]`. A popup in a window with NULL `form` or no matching bind: draw as empty, never crash (the compiler rejects it before this ships, Task 7 — runtime stays defensive). Creation (`rt_ui_make_widgets`): build MenuHandle `NewMenu(1000+wIdx, "\p")`, per label `AppendMenu(mh, "\px")` then `SetItem(mh, n, label)` (metachar-immune); store in new parallel `popupsH/popups` array; `InsertMenu(mh, -1)` at creation, `DeleteMenu(1000+wIdx)` + `DisposeMenu` in close (:3335-3341 loop + new DisposeHandle at :3349-area). Widget state: current index in a new parallel `short *popupSel` array (init 0). Natural size: `RTUI_POPUP_H 20`, `RTUI_POPUP_W 200` (label lane RTUI_FIELD_LABEL_W reused, drawn like field labels :1905-1912).
- Draw (update loop :1875-1916, new `else if` branch): label via TETextBox in the label lane; box = FrameRect + 1px drop shadow (bottom/right offset lines) + current item label + down-arrow triangle. All port-disciplined by the existing handler (update already sets port).
- Hit (content-click chain, new lane after TE hit :2193): `PtInRect(local, &rects[i]) && kind==RTUI_POPUP`. Real path: `PopUpMenuSelect(popups[i], globalTopLeft.v, globalTopLeft.h, popupSel[i]+1)` → loWord item → if changed: update popupSel, InvalRect, `T FIRE <Win>.<W>.change` (trace_fire2), fire widget handler `RTUI_WEV_CHANGE` with `a = newIndex`. Scripted (`gUiScripted`): pop `RT_UI_ANS_POPUP 4` from the answer queue (panic if empty/mismatched kind — clone rt_ui_ask_save_changes :1594-1612 shape), item = queued val; same update+trace+fire path after that point (shared function so both paths diverge only at the tracking call).
- Properties: `rt_ui_widget_get_int` gains `case RTUI_PROP_SELECTED:` (before the width default, :3586-3593) returning popupSel (later table sel); new `rt_ui_widget_set_int` entry (port-disciplined) — SELECTED on popup clamps to [0, count-1], sets, InvalRect, `trace_set_int`, NO change fire. New `rt_ui_trace_set_int(name, wname, prop, v)` beside trace_set_bool :383-388 emitting `T SET %s.%s.%s %ld`.
- Script verb: `answer-popup N` → `rt_ui_answer_push_val(RT_UI_ANS_POPUP, atoi(arg1))` (verb table :3051-3119).
- Sys7 probe (used by Tasks 6/8): `static short gSys7; /* set once in rt_ui_startup */` via `Gestalt(gestaltSystemVersion, &r)==noErr && r >= 0x0700` — added now, consumed later (mark `(void)gSys7;` or use in 8; keep -Wunused clean).

- [ ] **Step 1:** Write the failing compile first: add to `probe_ui.c` a 4th window with a popup bound via a hand-rolled `rt_field_desc[]`/`rt_ui_form_desc` (enum labels array in the probe), plus an events variant `events_popup.c` (click the popup with a queued `answer-popup 2`, set/get selected via a button handler calling the new entry points, snap). m68k-compile uiprobe → FAIL (RTUI_POPUP undefined).
- [ ] **Step 2:** Implement rt_ui.h + rt_ui.c per Interfaces. uiprobe + rt_ui.c compile clean for 68k (cmake per uiprobe/CMakeLists with `-DRT_MAC_TEST=ON -DUI_EVENTS=events_popup.c`).
- [ ] **Step 3:** Manual gate: LaunchAPPL the probe build (background; it blocks), screenshot per CLAUDE.md recipe, READ the screenshot: popup drawn with label + item text + arrow, selection changed to item 3 after the scripted pick. Capture file shows `T FIRE ....change` and `T SET ....selected`. Report the screenshot path + trace lines.
- [ ] **Step 4:** Full gated suite: all EXISTING goldens byte-identical (trailing fields are zero-init; no emitted code changed). Host `go test ./...` green.
- [ ] **Step 5:** Commit `rt_ui: popup widget (manual PopUpMenuSelect path), set_int/selected, answer-popup verb, sys7 probe`.

### Task 4: rt_ui table widget (List Manager + JMP-stub LDEF)

**Files:**
- Modify: `runtime/mac/rt_ui.h` (RTUI_TABLE 7; `rt_ui_col_desc`/`rt_ui_table_desc`; RTUI_WEV_SELECT 4 / RTUI_WEV_DBLCLICK 5)
- Modify: `runtime/mac/rt_ui.c` (list arrays, LDEF stub, create/layout/draw/hit/activate/sync, dblclick verb)
- Modify: `internal/mactest/uiprobe/probe_ui.c` + `events_table.c` variant

**Interfaces:**
- Produces:
  ```c
  #define RTUI_TABLE 7
  #define RTUI_WEV_SELECT   4   /* a = row index */
  #define RTUI_WEV_DBLCLICK 5   /* a = row index */
  typedef struct rt_list rt_list;   /* fwd decls, rt_text precedent (rt_ui.h:164) -- never include rt.h */
  typedef struct rt_map  rt_map;
  typedef struct { const unsigned char *header; /* Str255 */ short widthPx; short widthFill;
                   short fieldIndex; } rt_ui_col_desc;
  typedef struct rt_ui_table_desc { rt_list **rows; const rt_layout_desc *layout;
                                    short nCols; const rt_ui_col_desc *cols; } rt_ui_table_desc;
  /* widget_desc.extra = &clar_ui_table_<Win>_<W> (a rt_ui_table_desc) */
  void rt_ui_tables_sync(void);  /* re-sync every open table's LM row count to rt_list_count; called by both event loops */
  ```
- Creation: `LNew(&viewRect, &dataBounds /*1 col, 0 rows*/, cellSize, 0 /*no LDEF resource*/, wp, false, false, false, true /*vScroll*/)` then replace `(*lh)->listDefProc` with a 6-byte JMP-stub handle: `{0x4EF9, hi16(addr), lo16(addr)}` targeting `static pascal void rt_ui_ldef(short msg, Boolean sel, Rect *r, Cell c, short off, short len, ListHandle lh)`. (68000 target: no cache flush needed under Mini vMac; leave a `/* ponytail: no FlushCodeCache -- 68000; revisit for real 030+ hardware */` comment.) Store ListHandle in new parallel `listsH/lists` array; `LDispose` in the close loop BEFORE DisposeWindow (:3324 — order matters, LM controls die with the window; verify against IM). Row height = font ascent+descent+leading via GetFontInfo at creation; header strip height = same + 4, carved off the TOP of `rects[i]` (list view = rects[i] inset by header).
- LDEF draw (lDrawMsg/lHiliteMsg): cell row = `c.v`; fetch `rt_list_at(*(td->rows), c.v)` freshly EVERY call (never cached); clip per column x-slices (widths: fixed px; ONE `widthFill` column absorbs `viewWidth - sum(fixed)`); render by `fields[col->fieldIndex].ftype`: STR → len-prefixed bytes via DrawText; INT/FIXED/CHAR → formatted (reuse/mirror the runtime's existing int/fixed formatting); BOOL → checkmark char (0xD7 in Chicago? verify — the standard checkmark is char 0x12 in menus; for cells use '√' MacRoman 0xC3) when true, blank when false; ENUM → linear-scan enumValues for the value → enumLabels[i] (unknown value → "?"). Row out of range (sync lag) → draw blank. Selection = LM's own hilite (lHiliteMsg → InvertRect).
- Liveness: `rt_ui_tables_sync()` — for each open window, each RTUI_TABLE widget: `n = rt_list_count(*(td->rows))`, LM rows = `(**lh).dataBounds.bottom`; diff → LAddRow/LDelRow at the end; then `LUpdate`-driving `InvalRect` of the list rect when count changed OR a `gTablesDirty` flag was set. Content writeback (edit) also just invalidates — full visible redraw is O(visible), fine. Call sites: bottom of the real event loop (beside :3126-3175's dispatch) and `rt_ui_pump_passive` (scripted, once per verb :3121); ALSO immediately after any widget/menu/timer handler returns in the dispatch paths — simplest: one call after each `handlers->widget(...)`/menu fire/every pump in rt_ui.c (grep the call sites; keep it idempotent and cheap when counts match).
- Hit lane (after popup's): `PtInRect` on the LIST rect (header strip is inert) → real path: `SetPort`, `LClick(local, ev->modifiers, lh)` returns double-click Boolean; then `LGetSelect` for the row; fire `RTUI_WEV_SELECT` (a=row) + trace `T FIRE <Win>.<W>.select`, or on LClick true: ALSO fire `RTUI_WEV_DBLCLICK` + trace `...doubleClick` (select fires first, matching real-Mac click-then-double semantics). Scripted path (`gUiScripted`): compute row = topVisibleRow + (local.v - listTop) / cellHeight (read `(**lh).visible.top`), `LSetSelect` it exclusively, fire select (and for the dblclick verb, also doubleClick) — the drag-verb precedent (:2817-2840).
- Selection property: get_int SELECTED → LGetSelect scan from row 0 → index or -1; set_int SELECTED → deselect-all + LSetSelect(v) when v>=0, trace_set_int, no event. Activate hook: `LActivate(activating, lh)` beside :1948-1961. Layout/resize: `rt_ui_table_relayout(inst, i)` branch at :698-708 (move/size list view + header, `LSize`, recompute fill column). Natural size `RTUI_TABLE_H 120`, `RTUI_TABLE_W 300`.
- Script verb: `dblclick X Y` → same as click but routes the table lane with the double flag (non-table targets: treat as plain click).

- [ ] **Step 1:** Failing compile: probe gains a table window — hand-rolled layout + `rt_ui_table_desc` over a static `rt_list` seeded in main (push 3 records via rt public API), events_table.c: click row 1 (snap), dblclick row 0, a button handler that pushes a 4th record (liveness: snap shows 4 rows), another that removes selected. m68k compile → FAIL (RTUI_TABLE undefined).
- [ ] **Step 2:** Implement per Interfaces; uiprobe compiles.
- [ ] **Step 3:** Manual gate: LaunchAPPL, screenshots: headers + 3 rows with per-type rendering (checkmark col), row hilite after click, 4 rows after add. Capture shows select/doubleClick fires with indices. Report screenshots + trace.
- [ ] **Step 4:** Full gated suite byte-identical; host suite green.
- [ ] **Step 5:** Commit `rt_ui: table widget - List Manager with JMP-stub LDEF, live row sync, select/doubleClick, dblclick verb`.

### Task 5: clarusc lowering — popup + table descriptors, selected, events

**Files:**
- Modify: `clarusc/lower.cla` (widget whitelist :2152; property walk :2171-2222 gains binds/rows/columns capture; rows-must-be-global-list-var guard; selected read/write; select/doubleClick/change handler entries; unbound-popup + non-form-popup errors)
- Modify: `clarusc/ir.cla` (IRWidgetDesc + `bindsIdx`, `rowsGlobalIdx`, `columnsHead`; new `IRColumnDesc` arena; IRWidgetHandlerEntry + `selectFn`, `doubleClickFn`; intrinsics `IUiSetSelected`/`IUiGetSelected`)
- Modify: `clarusc/cprint.cla` (kind macro cases; column/table-desc emission via the cpEmitMenuItemsArray pattern; widget row 10th field for tables; dispatcher SELECT/DBLCLICK cases with `(int32_t)a`; set/get selected arms; layout emission reused from Task 2 — a table's row record and bound enum register in the same `irLayoutNeeded` registry)
- Create: `testdata/emitui/popuptable.cla` + `.c.golden`; `testdata/ui/popuptable.cla` + `.events` + goldens
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes Task 3/4 rt_ui contracts + Task 2's layout emitter.
- Produces emitted shapes:
  - table widget row: `{ RTUI_TABLE, "Marks", 0, RTUI_AT_XY, 10, 10, RTUI_FILL, RTUI_FILL_NONE, 0, (const void *)&clar_ui_table_Main_Marks },` — note ALL widget rows in a window containing any popup/table/form may now emit 10 fields; windows without them keep the 9-field shape so OLD goldens stay byte-identical (emit the 10th field only when non-NULL — C allows trailing-field omission).
  - `static const rt_ui_col_desc clar_ui_cols_Main_Marks[] = { { (const unsigned char*)"\pName", 140, 0, 0 }, { ..., 0, 1, 1 }, ... };` + `static const rt_ui_table_desc clar_ui_table_Main_Marks = { &clar_g_bookmarks, &clar_layout_Bookmark, 3, clar_ui_cols_Main_Marks };` (rows = ADDRESS of the global's `rt_list*` cell; lowering rejects any `rows:` expression that is not a bare global list-of-record variable: `lowUnsupported("table rows must be a global list variable")`).
  - column `fieldIndex` = index of the `shows` field in the record's layout order; popup with no `binds:` OR in a non-form window → `lowUnsupported("popup requires binds inside a form window")` (checked in lowWidgetDesc using `WidgetInfo.bindsIdx` + `windowIsForm`).
  - `Marks.selected` read → `rt_ui_widget_get_int(inst, N, RTUI_PROP_SELECTED)` (int type); write → `rt_ui_widget_set_int(inst, N, RTUI_PROP_SELECTED, v)`. Applies to popup AND table (lowWidgetPropRead :1210-1244 / lowWidgetSetAssign :1565-1602 patterns).
  - `on T.select(i: int)` / `on T.doubleClick(i: int)` / `on P.change` → dispatcher cases `if (event == RTUI_WEV_SELECT) clar_fn_..._select(inst, (int32_t)a);` etc.
  - Form-window pieces (binds table, form desc, window 11th field) are NOT emitted yet — Task 7. This task's fixture uses a table + an UNBOUND-check: popup fixtures here must live inside a form-for window to pass lowering, but `form for` still aborts — so THIS task's scenario covers **table only**; popup lowering lands here but its fixture/golden coverage arrives with Task 7's form fixture. Guard tests (unbound popup) run via a stderr-assert arm like Task 2's.
- IRWidgetDesc grows 3 fields → 18-arg ctor; single caller updated; all existing emit goldens must stay byte-identical (assert by running emitui suite before commit).

- [ ] **Step 1:** Failing fixture `testdata/emitui/popuptable.cla`: global `list of` record, window with a 3-column table (fixed/fill/bool+enum columns), handlers for select/doubleClick, code reading and setting `T.selected`. clarusc emit → aborts `widget kind table` (quote).
- [ ] **Step 2:** Implement; golden emitted, eyeballed (col descs, table desc, 10-field row, dispatcher cases, layout tables present via the Task 2 registry), committed; `go test ./internal/emitui/` green including old goldens untouched.
- [ ] **Step 3:** Negative arms (stderr asserts, no goldens): unbound popup; popup outside form window; `rows:` on a window-local expression.
- [ ] **Step 4:** Scenario `testdata/ui/popuptable.cla` (table only, per Interfaces note): seed 3 rows in `App.startEmpty`, events: click row → trace select, dblclick row → select+doubleClick, button adds a row then `snap` (4 visible), button removes `T.selected` then snap, set `selected` programmatically → `T SET` line, read it back into a title breadcrumb. Bless; full gated suite green, old goldens byte-identical.
- [ ] **Step 5:** Snapshot regen + host suite + commit `clarusc: lower table (cols/rows/selected/events) and popup plumbing; table scenario`.

### Task 6: rt_ui modal forms — edit runtime, binding walker, accepted/cancelled

**Files:**
- Modify: `runtime/mac/rt_ui.h` (RTUI_EV_ACCEPTED 5 / RTUI_EV_CANCELLED 6; `rt_ui_edit`; `rt_ui_form_is_new`; writeback kinds)
- Modify: `runtime/mac/rt_ui.c` (modal state, movable-modal window proc, walker fill/validate/writeback, OK/Cancel routing, typing filters, close-box-as-cancel, beeps)
- Modify: `internal/mactest/uiprobe/probe_ui.c` + `events_form.c`

**Interfaces:**
- Produces:
  ```c
  #define RTUI_EV_ACCEPTED  5   /* a = (long)&buffer (clar_rec_T *) */
  #define RTUI_EV_CANCELLED 6
  #define RT_UI_WB_NONE 0
  #define RT_UI_WB_ADDR 1   /* global or window-state record */
  #define RT_UI_WB_LIST 2   /* re-derived rt_list_at(l, idx) at writeback; dropped if idx >= count */
  #define RT_UI_WB_MAP  3   /* rt_map_set(m, key, buf) */
  void rt_ui_edit(const rt_ui_window_desc *d, const void *src, short isNew,
                  short wbKind, void *addr, rt_list *lst, long idx,
                  rt_map *mp, const unsigned char *key255);
  short rt_ui_form_is_new(void);   /* valid during the accepted dispatch only */
  ```
- Modal state (file-scope, one modal max): `gModal` = {inst, bufH (locked Handle of layout->recSize), isNew, wb copy (key copied into a 256 buffer)}. `rt_ui_edit`: panic `"edit while a form is already open"` if set; panic if `d->form == NULL`; alloc+copy src into buf; `rt_ui_open(d)` — window proc: `gSys7 ? movableDBoxProc : noGrowDocProc` for form windows (rt_ui_open :3239 branches on `d->form`); walker-fill widgets from buf; set gModal.
- Filter flag: in `rt_ui_handle_mouse_down` (:2214-2260): if gModal set and the hit window is one of ours but NOT gModal.inst → SysBeep(1), return (menu bar `inMenuBar` likewise beeps; DragWindow on the modal itself allowed; system windows/DA handling unchanged). Everything else (updates, activates, timers, TEIdle) untouched — single loop, no nesting.
- Walker (driven by `d->form`): fill — per bind: FIELD ← format field (int/fixed/str per ftype), CHECK ← SetControlValue, POPUP ← ordinal of value in enumValues (unknown → 0). Typing filter: in the key path (:2293-2356), when gModal and focused widget is a bound FIELD: int → digits + leading `-` only; fixed → + one `.`; else beep-drop. (`string(n)` cap: TE keystroke gate clamps at layout strCap — reuse the RTUI_FIELD_TEXT_MAX mechanism with the smaller cap.) OK = the `RTUI_DEFAULT` button of a form window: instead of firing click, run validate — declaration order over binds: INT/FIXED parse (empty/malformed/int32-overflow fails; fixed parse mirrors the runtime's fixed representation — see research note); failure → SysBeep, focus field, TESetSelect(0, 32767), stay open, trace `T FIRE <Win>.invalid.<field>` (new trace, walker-only); all pass → write fields back into buf, apply writeback (WB_LIST bounds-checked re-derive; vanished → skip silently), fire `T FIRE <Win>.accepted` + `RTUI_EV_ACCEPTED` with a=(long)buf while gModal still set (rt_ui_form_is_new reads it), then tear down: clear gModal, dispose bufH, close window (skip closeRequest for form windows — Ch10 forms have no unsaved-changes hook). Cancel = `RTUI_CANCEL` button, Escape, or close box on a form window: fire `T FIRE <Win>.cancelled` + `RTUI_EV_CANCELLED`, tear down same way. Return/Escape wiring already exists (:2344-2351) — route through the form branch when gModal.
- The scripted harness needs NO twin: scripts click the real OK/Cancel buttons and type into real fields; the filter flag doesn't touch scripted dispatch.

- [ ] **Step 1:** Failing compile: probe adds a form window (form desc over the Task 3 probe record: str/int/bool/enum binds + OK default + Cancel), a launcher button whose handler calls `rt_ui_edit` (WB_ADDR into a probe global), handlers printing accepted/cancelled + isNew. `events_form.c`: open form, type into str field, clear+type bad int ("12x"), click OK (beep+stay: snap), fix int, click OK → accepted trace + writeback visible (button prints the global), reopen, Escape → cancelled. Click a background window while modal → beep, no fire (trace absence). m68k compile → FAIL (rt_ui_edit undefined).
- [ ] **Step 2:** Implement per Interfaces; probe compiles.
- [ ] **Step 3:** Manual gate: LaunchAPPL + screenshots (modal front, validation beep state, post-accept state); capture trace shows fill → invalid → accepted sequence and the modal-click beep gap. Report.
- [ ] **Step 4:** Full gated + host suites; existing goldens byte-identical (form==NULL paths unchanged).
- [ ] **Step 5:** Commit `rt_ui: movable-modal form windows - edit entry, binding walker fill/validate/writeback, accepted/cancelled`.

### Task 7: clarusc lowering — form for, binds, edit, accepted/cancelled, isNew

**Files:**
- Modify: `clarusc/lower.cla` (DkFormFor :2319; StEdit case at :1362; accepted/cancelled at :2637; isNew guard in lowSelect :1119; `lowCurHandlerEvent`/`lowCurAcceptedParam` globals)
- Modify: `clarusc/ir.cla` (IRWindowDesc + `formRecNameIdx`; IRWinHandlers + `acceptedFn`/`cancelledFn`; intrinsics `IUiEdit`, `IUiFormIsNew`)
- Modify: `clarusc/cprint.cla` (bind-table + form-desc emission; window-desc 11th field; ACCEPTED/CANCELLED dispatcher cases with the record-by-value cast; edit-statement emission incl. new-T temp + writeback args)
- Create: `testdata/emitui/formedit.cla` + `.c.golden`; `testdata/ui/formedit.cla` + `.events` + goldens
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes Task 6's rt_ui contract + Task 2's layout registry.
- Produces emitted shapes:
  - `static const rt_ui_bind_desc clar_ui_binds_EditForm[] = { {0, 0}, {1, 4}, ... };` (widgetIndex → layout fieldIndex, from `WidgetInfo.bindsIdx` resolved against layout order) + `static const rt_ui_form_desc clar_ui_form_EditForm = { &clar_layout_Bookmark, 5, clar_ui_binds_EditForm };` + window desc 11th field `&clar_ui_form_EditForm` (non-form windows keep 10-or-fewer fields → old goldens byte-identical).
  - `edit EditForm, bookmarks[i]` →
    ```c
    rt_ui_edit(&clar_ui_win_EditForm, (const void *)rt_list_at(clar_g_bookmarks, (i)), 0,
               RT_UI_WB_LIST, 0, clar_g_bookmarks, (long)(i), 0, 0);
    ```
    (src pointer = the same re-derive; rt_ui_edit copies immediately, so the transient rt_list_at pointer is safe). Global/window-var record target → `RT_UI_WB_ADDR` with `fpAddrable` address; map element → `RT_UI_WB_MAP` with map handle + `fpStrAddr` key; `edit F, new T` → `clar_rec_T <tmp> = clar_new_T();` then `rt_ui_edit(..., &<tmp>, 1, RT_UI_WB_NONE, 0,0,0,0,0);`. Any other lvalue shape (nested field of a list element, etc.): `lowUnsupported("edit target must be a variable, list element, or map element")`.
  - `on accepted(b: Bookmark)` → `acceptedFn`; dispatcher: `case RTUI_EV_ACCEPTED: clar_fn_ui_EditForm_accepted(inst, *(clar_rec_Bookmark *)a); break;` — cancelled: plain `(inst)` call.
  - `b.isNew` where `b` is the accepted param (tracked via `lowCurHandlerEvent == intern("accepted")` and `lowCurAcceptedParam == identName`, both saved/set/restored exactly like lowCurWinType at :2480/:2516) → `newIRIntr(IUiFormIsNew(), -1, irBoolT)` → `(rt_ui_form_is_new())`. Any OTHER isNew read on a record lacking a literal isNew field (reuse the check.cla:2576-2588 walk) → `lowUnsupported("isNew is only defined on the accepted handler's parameter")` — this replaces the silent uncompilable-C path.
- Form windows without `size:`: check what `lowWindowDecl` produces today for a sizeless window (w/h come from the property walk; verify the default). If it already errors or zero-sizes, have `rt_ui_open` derive natural size when `d->w == 0`: stacked natural heights + gaps, width = max natural widget width + margins — implement in Task 6's rt_ui_open if this task's fixture (appendix-shaped, sizeless EditForm) renders wrong; the fixture decides. Record the outcome in the task report.

- [ ] **Step 1:** Failing fixture `testdata/emitui/formedit.cla`: the appendix Bookmark Manager's EditForm + a global list + edit statements covering all four target shapes (global rec var, list element, map element, new T) + accepted (using isNew) + cancelled + an `edit`-into-`accepted`-writeback round. clarusc emit → aborts `form for` (quote).
- [ ] **Step 2:** Implement; golden emitted, eyeballed (bind table order, 11th field, ACCEPTED cast, edit arg shapes for all four targets, IUiFormIsNew), committed; emitui green, old goldens untouched.
- [ ] **Step 3:** Negative arms (stderr): `isNew` on a non-accepted-param record read; unsupported edit target shape. Also now enable the deferred popup coverage: this fixture's form has a popup — golden shows its binds-driven emission (no `extra`).
- [ ] **Step 4:** Scenario `testdata/ui/formedit.cla`: open main window (table over globals) → button `edit ... new` → type name, pick popup via `answer-popup`, toggle check, bad port then OK (beep snap), fix, OK → accepted adds to list → table shows row (snap); dblclick row → edit lvalue → change field → OK → table redraws (snap); open again → Escape → cancelled trace, row unchanged. Bless; full gated suite; host suite.
- [ ] **Step 5:** Snapshot regen + commit `clarusc: lower form windows, binds, edit statement, accepted/cancelled, scoped isNew`.

### Task 8: popup CDEF path (System 7 enhancement)

**Files:**
- Modify: `runtime/mac/rt_ui.c` only (creation/draw/hit/dispose/set-selected branches on `gSys7`)

**Interfaces:**
- Consumes Task 3's popup machinery + gSys7 probe. No compiler or ABI change.
- On gSys7: `rt_ui_make_widgets` popup case creates `NewControl(wp, &r, label, true, popupSel+1, /*min=menuID*/ 1000+wIdx, /*max*/ 0, popupMenuProc /*1008*/ + popupFixedWidth, (long)wIdx)` AFTER the MenuHandle is built and inserted with `InsertMenu(mh, -1)` — then replace the MenuHandle inside the control's `popupPrivateData` (contrlData → `struct { MenuHandle mHandle; short mID; }`) with ours and `SetControlMaximum(ctrl, count)`. The control lives in `ctrls[wIdx]` (plain refCon = wIdx) → FindControl claims clicks, TrackControl runs the menu natively, `Draw1Control`/DrawControls handles drawing (the manual draw branch and manual hit lane are skipped when `ctrls[wIdx] != NULL`). After TrackControl: `GetControlValue - 1` → same shared change-dispatch function Task 3 factored out. get/set selected: GetControlValue/SetControlValue (± 1) when the control exists. Dispose: control dies with the window; menu DeleteMenu/DisposeMenu unchanged.
- Scripted mode is System 6 (test image) → CDEF path has NO golden coverage; the shared dispatch keeps behavior identical. gUiScripted popup bypass (answer queue) must fire BEFORE the ctrls[wIdx] TrackControl branch — the scripted check sits in the content-click popup handling regardless of path.
- Verify popupPrivateData poke against Inside Macintosh VI + the Universal Interfaces (`grep -a popupMenuProc Retro68/InterfacesAndLibraries/...Controls.h`) before coding; if the private-data layout is absent from the interfaces, define the two-field struct locally with an IM VI citation comment.

- [ ] **Step 1:** m68k compile with the branch in place (no test build change — CDEF path is compiled in but dormant under the S6 test image).
- [ ] **Step 2:** Full gated suite: byte-identical everything (S6 goldens exercise only the manual path).
- [ ] **Step 3:** Manual System 7 gate: Mac II Finder flow (per CLAUDE.md: scratch MacPlus.app copy is the S6 recipe — for S7 use `macii/MacII.app` + `System 7.1.dsk` per the 4c plan's Task 6 notes) with a formedit-style app build; screenshot: native CDEF popup (title + current item in the standard S7 bezel), pick works, accepted round-trip works. Report screenshots.
- [ ] **Step 4:** Commit `rt_ui: System 7 popup CDEF path (native control; manual path remains S6 baseline)`.

### Task 9: Bookmark Manager acceptance + persistence + docs close-out

**Files:**
- Create: `examples/bookmarks.cla`, `examples/bookmarks.pbm` (32×32 hand-drawn P1: book with ribbon marker)
- Create: `testdata/ui/bookmarks.events`, blessed goldens; ui_test.go func (runUIScenarioSrc against examples/bookmarks.cla)
- Modify: `docs/ROADMAP.md` (4d → DONE), `docs/clarus-language-reference.md` (only if any behavior deviated — list deviations explicitly or state none)

**Interfaces:** consumes everything.

- [ ] **Step 1:** `examples/bookmarks.cla` = Appendix C Bookmark Manager verbatim PLUS: `app` section (name "Bookmarks", version "1.0", about text, icon, id "CBKM"), `file.load("Bookmarks Data", bookmarks)` in `App.startEmpty` before `open Main` (ignore false), and a `saveAll()` helper called from `accepted` and `Remove.click` doing `file.save("Bookmarks Data", bookmarks)`. The reference appendix example stays untouched.
- [ ] **Step 2:** Scenarios. `bookmarks`: startEmpty (no data file → load returns false, ignored) → add two bookmarks via the form (popup pick via `answer-popup`, favorite check, port-validation failure exercised once) → table snap → edit one via dblclick → remove one → snap → quit. Persistence within the gated harness: LaunchAPPL boots a fresh disk each run, so a true quit-relaunch round trip is NOT scriptable — the save/load *format* is already byte-golden-pinned by Task 2's host test, and this scenario proves the save-path wiring fires (the data file is written). The real cross-run reload is validated live in Final Validation step 1 (relaunch on the same disk). State exactly this in the task report; do not invent a test-only reload button in the app.
- [ ] **Step 3:** ROADMAP 4d → DONE (mirror the 4a-4c line format, cite acceptance); reference deviations pass.
- [ ] **Step 4:** Commit `examples: Bookmark Manager acceptance app with persistence; 4d roadmap close`.

---

### Final validation (top-level session)

1. System 6.0.8 (Mac Plus, LaunchAPPL real-input): launch bookmarks, add/edit/remove via real clicks and typing, popup via PopUpMenuSelect, port-validation beep, quit; relaunch → bookmarks restored (real cross-run persistence check that the scripted harness can't do). Screenshots at each stage; About box sanity.
2. System 7.1 (Mac II, Finder flow): same pass; verify the popup renders via the CDEF (visibly different bezel), movableDBoxProc title bar on the form, table/scrolling behavior.
3. Whole-branch review (most capable model), fix wave if needed; merge only on Andrew's request.
