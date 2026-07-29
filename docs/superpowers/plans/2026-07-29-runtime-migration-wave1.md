# Runtime Migration Wave 1 (Plan 5b) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the serializer and the core str/text/list/map runtime families from C (`internal/build/rt`) to Clarus source (`runtime/clarus/*.cla`) compiled into programs by clarusc, over the 5a waist — per `docs/superpowers/specs/2026-07-29-runtime-migration-wave1-design.md` (read it first; it is the authoritative design).

**Architecture:** Five stages. A (Tasks 1-6): machinery — overlay records, external str/text marshalling, file/RC/container externals, implicit runtime-module inclusion, flat serializer descriptors, CLRD byte-compare gate. B (Task 7): serializer port + redirect. C (Task 8): str family. D (Task 9): text family. E (Tasks 10-12): list/map + adversarial ARC matrix. Wrap (Tasks 13-14). Ported functions are ordinary Clarus functions (`rt`-prefixed names → `clar_fn_rtXxx` C symbols); cprint's emission sites redirect per family; the C implementations stay in `rt.c` forever as the frozen-Go-compiler runtime and the differential oracle.

**Tech Stack:** Clarus (clarusc/*.cla compiler + runtime/clarus/*.cla new), C99 (internal/build/rt, runtime/mac), Go test harnesses.

**Session-cold context (executor: read these before Task 1):**
- `CLAUDE.md` (repo conventions; sonnet implementers; Mac toolchain notes)
- `docs/superpowers/specs/2026-07-29-runtime-migration-wave1-design.md` (this plan's spec)
- `docs/superpowers/specs/2026-07-29-native-68k-toolchain-design.md` §"Low-level language additions" + "5a outcomes"
- `docs/clarus-language-reference.md` Chapter 13 (normative for ptr/peek-poke/external; overlay records join it in Task 1)
- Branch: create `native-5b` from main (main is at 1304bb5 or later; 5a landed at 808ad47).

## Global Constraints

- **Frozen Go compiler:** new-syntax fixtures NEVER in `testdata/valid`, `testdata/errors`, `testdata/run`, `testdata/run/lib`, `testdata/runerr`, `testdata/include`, `testdata/diag`, `testdata/suite`, or as driver-level syntax in `clarusc/test/*_test.cla`. Safe homes: string-embedded cases in `clarusc/test/check_test.cla`, `testdata/lowlevel/` (run harness: `internal/lowlevel`, leak-gated), `testdata/emitui/` (emit goldens + m68k compile-check), `testdata/rtinc/` (new in Task 4). Reference fences with new syntax use ```rust tags but MUST be added to `ClaruscOnly` in `internal/reftest/manifest.go` (indices positional among ALL rust fences; adjust `CheckClean` indices at/after insertion; guard test `TestClaruscOnlyDisjoint`).
- **clarusc's own compiler source (`clarusc/*.cla`) must not USE the new features** (conservative subset; implementing them is fine).
- **Every commit touching `clarusc/*.cla` regenerates the snapshot in the same commit:**
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  ```
  and re-emits any changed `testdata/emitui/*.c.golden` with the same `/tmp/clarusc emit -o <golden> <fixture>`. From Task 8 (str inclusion) onward the snapshot embeds the runtime modules' emitted C — expected, re-bless in a dedicated commit.
- **Bootstrap one-liner preserved:** `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`. All new host runtime C is `.inc` included from `rt.c` (never a new `.c` TU). rt copy-sites that must ship any new `.inc`: `internal/build/embed.go`, `internal/build/runtime.go`, `internal/build/build.go:56-82`, `internal/selfhost/emit_test.go:56-87`, `internal/cprint/cprint_test.go:86-110` (six sites total, incl. `rt.c` itself).
- **No new tokens** (`TokKind` order is load-bearing, tok.cla:6-12). `overlay` is contextual: `curIsIdentText("overlay") and peekKind() == TkRecord` (helper `curIsIdentText` parse.cla:103; precedent `external` at parse.cla:1363).
- **RC layer stays C** (wave 2): retain/release/lastref, `rt_list_at`, and `cpEmitRelease`/`cpEmitRetain`/`fpHeapFn` emissions (cprint.cla:2576/2729/298) are NEVER redirected in this plan.
- **UAF/double-free invariant:** leaks acceptable and documented; unsafe frees never. Strict leak gates (`CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1`) run in `internal/lowlevel` and `internal/selfhost/emit_test.go` — must stay green every task.
- Stage ordering is load-bearing: overlay records + marshalling + externals (Tasks 1-3) must be committed with snapshot regenerated BEFORE any runtime module using them is fed into programs (Task 7+), because the snapshot-built compiler must parse the runtime source.
- Work on branch `native-5b`; `go test ./...` green before every commit; commits end with the project's Co-Authored-By/Claude-Session trailers (copy from `git log -1 --format=%B` of any 5a commit).
- Diagnostic-message note: `internal/selfhost/coverage_test.go` asserts Go-compiler messages ⊆ clarusc messages (one-directional); new clarusc-only messages are fine.

---

### Task 1: Overlay records — front end (parse, AST, types, check) + reference

**Files:**
- Modify: `clarusc/parse.cla` (~:1363 dispatch region, :1030-1074 record/field parsing), `clarusc/ast.cla` (:97 schema comment, :1161-1178 record accessors), `clarusc/types.cla` (:41/:64 TypeKind, new `overlayT` constructor beside `recT` :207-216, `assignable`/`typesEqual` TyRec-arm region), `clarusc/check.cla` (:1377-1428 checkRecordDecl, :3568-3637 checkSelect, :3645-3660 checkNewExpr, :1342-1359 container-elem guards, conversion dispatch :3679-3704 region)
- Modify: `docs/clarus-language-reference.md` (Chapter 13 new section) + `internal/reftest/manifest.go` (ClaruscOnly)
- Test: `clarusc/test/check_test.cla` + `.out`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: 5a's `TyPtr`/`PtrT` (types.cla:64/:118), contextual-keyword pattern (parse.cla:1363), `fieldInfos`/`recFieldsHeadByName` side table (check.cla:72-105).
- Produces: `TyOverlay` TypeKind (appended after `TyPtr`) carrying `nameIdx` only, constructor `overlayT(nameIdx)` mirroring `recT`; `DkRecord` nodes with `intVal = 1` marking overlay (accessor `recordDeclIsOverlay(d): bool` in ast.cla using the `boolToInt`/`intToBool` helpers ~ast.cla:299); overlay field lists stored in the SAME `fieldInfos`/`recFieldsHeadByName` table as records (name-keyed; a record and overlay with the same name collide via the normal duplicate-declaration diagnostic); conversions `OverlayName(p: ptr) → overlay` and `ptr(o: overlay) → ptr` through `checkConversion`. Task 2 consumes all of these names verbatim.

**Language rules to implement (these go in the reference section verbatim, and the checker enforces each):**
- Declaration: `overlay record Name { f: type ... }` — `overlay` contextual, only immediately before `record`. No field defaults (`= literal` in an overlay field is an error: "overlay fields cannot have defaults").
- Field types: int, bool, char, fixed, ptr ONLY. Diagnostic: `"overlay fields must be int, bool, char, fixed, or ptr"`.
- An overlay value is an address: assignment copies the pointer; `==`/`!=` compare addresses; zero value is the null address.
- Obtaining: `Name(p)` converts ptr→overlay; `ptr(o)` converts back. No `new` (extend checkNewExpr's existing "cannot use new with non-record type" rejection to fire for TyOverlay).
- Field get `o.f` and set `o.f = v` type-check per the declaration (checkSelect gets a TyOverlay arm mirroring the TyRec arm at check.cla:3597-3610, minus the `isNew` fallback; assignment flows through the ordinary checkAssignStmt path check.cla:2717-2745 unchanged).
- Not usable as: container element (mirror the `ptr` rejection at check.cla:1342-1359, message `"overlay records cannot be container elements"`), record or overlay field type, serializer/form/table subject, `for`-loop subject. Usable as: variable, param, return, comparison operand.
- Overlays never participate in ARC (enforced structurally in Task 2 via IR kind, but the reference states it).

- [ ] **Step 1: Write failing checker cases** in `clarusc/test/check_test.cla` (string-embedded `runCase`/`ln` idiom — see existing 5a ptr cases in the same file for the exact pattern) + extend `check_test.out`:
  - Clean: declare `overlay record RtHdr { rc: int; data: ptr }`, `var p: ptr`, `var h: RtHdr`, `h = RtHdr(p)`, `var n: int  n = h.rc`, `h.rc = 5`, `h.data = p`, `p = ptr(h)`, `h == RtHdr(p)`.
  - `overlay record Bad { s: string }` → "overlay fields must be int, bool, char, fixed, or ptr".
  - `overlay record BadD { n: int = 3 }` → "overlay fields cannot have defaults".
  - `var xs: list of RtHdr` → "overlay records cannot be container elements".
  - `new RtHdr` → the checkNewExpr rejection message.
  - `h.nope` → "undefined: nope" (existing message shape from check.cla:3637).

- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/selfhost -run TestClarusModules` (diags like `undefined: RtHdr` / parse error at `overlay`).

- [ ] **Step 3: Implement parse + AST.** parse.cla: in `parseTopDecl` beside the `external` dispatch (:1363), add `if curIsIdentText("overlay") and peekKind() == TkRecord { advance()  return parseRecordDeclOverlay() }` where `parseRecordDeclOverlay` calls the existing `parseRecordDecl` (:1030-1053) and stamps the returned decl's `intVal = 1` (add a setter or set it inside via a bool param — match whichever style ast.cla's flag precedents use, see `DkEnumMember hasValue` ast.cla:119). ast.cla: document `intVal=isOverlay` in the DkRecord schema comment (:97) and add `recordDeclIsOverlay`.

- [ ] **Step 4: Implement types + check.** types.cla: append `TyOverlay` to TypeKind (after TyPtr :64); add `overlayT(nameIdx)` cloning `recT` (:207-216) with `kind = TyOverlay`; `assignable`/`typesEqual`: TyOverlay arm = same `nameIdx` only (mirror the TyRec arms; overlays are NOT assignable to/from TyRec or TyPtr implicitly). check.cla: `checkRecordDecl` (:1377-1428) branches on `recordDeclIsOverlay`: same fieldInfos registration, but per-field kind restriction + no-defaults check, and declares the type symbol with `overlayT(nameIdx)`; `checkSelect` TyOverlay arm; `checkNewExpr` rejects TyOverlay; container-elem guards extended (all three arms at :1342-1359, plus record-field restriction: in the non-overlay checkRecordDecl path, reject TyOverlay field types with "overlay records cannot be record fields"); conversion dispatch: in checkIdentCall's conversion region (:3679-3704), when the callee name resolves to a type symbol whose type kind is TyOverlay → conversion from TyPtr (message on failure: `"cannot convert <t> to <Name>"`), and extend the `ptr(...)` conversion's accepted source kinds with TyOverlay.

- [ ] **Step 5: Run to verify checker cases PASS:** `go test ./internal/selfhost -run TestClarusModules` (iterate on golden line/col positions from actual output).

- [ ] **Step 6: Reference + fences.** Add "Overlay Records" subsection to Chapter 13 (after the external-func section) covering every rule in the block above, with one or two rust fences; add their indices to `ClaruscOnly` (recount ALL rust fences; shift `CheckClean` entries at/after the insertion; `go test ./internal/reftest ./internal/selfhost -run 'Fences|ClaruscOnly'` green).

- [ ] **Step 7: Snapshot + full suite + commit:** snapshot commands from Global Constraints; `go test ./...`; commit `"clarusc: overlay record declarations (front end) + Ch13 section"`.

---

### Task 2: Overlay records — back end (IR, lower, cprint) + run fixture

**Files:**
- Modify: `clarusc/ir.cla` (:105 KRec region, :916 irRecType, :883-891 irtNeedsCtor — verify no change needed, record-layout registry near newIRRecordLayout), `clarusc/lower.cla` (:234 lowType, :3434-3473 lowRecordDecl, :1285-1300 lowSelect TyRec arm, :268-278 lowResolveType name chain), `clarusc/cprint.cla` (:555 cpCTypeName, :841-847 fpFieldRef, :2999-3040 cpEmitRecords, :2514+ cpDefaultInit, conversion emission near the 5a CvIntToPtr arms)
- Test: `testdata/lowlevel/overlay.cla` + `.out`; `testdata/emitui/overlay_seam.cla` + `.c.golden`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: Task 1's `TyOverlay`/`overlayT`/`recordDeclIsOverlay`; 5a's `KPtr`/`irPtrT`, `rt_ext_NewPtr`/`rt_ext_DisposePtr` (in `internal/build/rt/rt_ext_host.inc`), peek/poke builtins; `internal/lowlevel` harness (globs `testdata/lowlevel/*.cla`, leak-gated).
- Produces: IR kind `KOverlay` (appended to IRKind, carries `name` like `KRec` — constructor `irOverlayType(nameIdx)` mirroring `irRecType` ir.cla:916); C type `clar_rec_<Name> *` for overlay values (`cpCTypeName` case KOverlay); field access emission `(<x>)->cv_<f>`; overlay conversions emit casts `((clar_rec_N *)(<p>))` / `((void *)(<o>))`; overlay typedefs emitted by cpEmitRecords WITHOUT the `clar_new_` ctor; `cpDefaultInit` KOverlay → `dst = 0;`. Tasks 9-11 declare `RtText`/`RtList`/`RtMap` overlays against these semantics.

- [ ] **Step 1: Write the failing run fixture** `testdata/lowlevel/overlay.cla` (alert-ok/FAIL idiom — copy the shape of `testdata/lowlevel/peekpoke.cla`):

```
// overlay.cla: overlay record over raw memory (Plan 5b Task 2).
// Allocates a 12-byte block, views it as a 3-field overlay, writes
// through fields, verifies via peek at C-computed offsets NOT assumed:
// re-reads through a second overlay binding instead (layout-agnostic).

external func NewPtr(size: int): ptr
external func DisposePtr(p: ptr)

overlay record Trip {
    a: int
    b: ptr
    c: int
}

on App.startCLI(args: list of string) {
    var p: ptr
    var t: Trip
    var u: Trip
    p = NewPtr(32)
    t = Trip(p)
    t.a = 111
    t.b = ptr(0)
    t.c = 222
    u = Trip(ptr(t))
    if u.a == 111 { alert("a-ok") } else { alert("a-FAIL") }
    if u.c == 222 { alert("c-ok") } else { alert("c-FAIL") }
    if u == t { alert("eq-ok") } else { alert("eq-FAIL") }
    var d: Trip
    if ptr(d) == ptr(0) { alert("zero-ok") } else { alert("zero-FAIL") }
    DisposePtr(p)
}
```
`.out` = the four ok lines (freeze from the real first run; adjust the alert output form to match how the lowlevel harness captures alerts — see extmem.out).

- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/lowlevel -v` (emit error: overlay unlowerable).

- [ ] **Step 3: Implement.** ir.cla: `KOverlay` appended to IRKind; `irOverlayType(nameIdx)` mirroring `irRecType` (:916); do NOT touch `irtNeedsCtor` (:883-891) — verify KOverlay is absent from it (that absence IS the no-ARC guarantee) and that `irRecHasHandleField` (:699-718) is never consulted for overlays. Record-layout registration: `lowRecordDecl` (lower.cla:3434-3473) still runs for overlays (cpEmitRecords needs the field list for the typedef) but tag the layout as overlay — add a parallel flag on the IR record-layout registry keyed the same way, `irRecordLayoutIsOverlay(nameIdx)`. lower.cla: `lowType` (:234) TyOverlay → `irOverlayType(typeNameIdx(t))`; `lowResolveType` name chain — overlays resolve via the type-symbol path already (verify; named types route through the checker's symbol, follow how TyRec named types resolve there); `lowSelect` TyOverlay arm mirroring the TyRec arm (:1285-1300) minus isNew → `newIRFieldRef(lowExpr(xExpr), selectName(e), ty)`; assignment path (lowAssign :2881-2882 → lowCountedStore) needs no change: overlay field types are scalars, so `lowCountedStore` takes its non-counted path — verify with the fixture, don't modify. Conversions: mirror 5a's `CvIntToPtr`/`CvPtrToInt` pair (ir.cla:346-347, lower.cla:462-463/1451-1452, cprint.cla:1034-1037) with `CvPtrToOverlay`/`CvOverlayToPtr` carrying the target type. cprint.cla: `cpCTypeName` case KOverlay → `"clar_rec_" + poolGet(irtName(t)) + " *"`; `fpFieldRef` (:841-847) third arm — when `irtKind(irExprType(irFieldRefX(e))) == KOverlay`: `"(" + fpExpr(irFieldRefX(e)) + ")->cv_" + poolGet(irFieldRefName(e))`; `cpEmitRecords` (:2999-3040) — emit the typedef for overlay layouts, skip the `clar_new_` ctor (`if` around :3021-3040 using `irRecordLayoutIsOverlay`); `cpDefaultInit` — add KOverlay to the KWinRef/KPtr zero arm (the 5a lesson: every new scalar kind needs this); conversion emission: CvPtrToOverlay → `"((clar_rec_" + name + " *)(" + arg + "))"`, CvOverlayToPtr → `"((void *)(" + arg + "))"`. Comparisons: KOverlay values are C pointers, `==`/`!=` emit via the existing generic fpBin path — verify only.

- [ ] **Step 4: Emit-shape golden.** `testdata/emitui/overlay_seam.cla`: minimal program with one overlay decl + field get/set + conversion. Emit its `.c.golden` with `/tmp/clarusc`; verify by hand: typedef present, NO `clar_new_Trip`, no retain/release walk, `->cv_` access, casts as specified, `= 0` default init. The auto-glob m68k-compile-checks it.

- [ ] **Step 5: Run everything:** `go test ./internal/lowlevel ./internal/emitui ./internal/selfhost -run 'Lowlevel|EmitUi|TestClarusModules' -v` then full `go test ./...`.

- [ ] **Step 6: Snapshot + commit:** `"clarusc: overlay records (KOverlay, ->field emission, no-ARC, conversions)"`.

---

### Task 3: Waist widening — str/text external params + file/container/lasterr externals (host AND Mac)

**Files:**
- Modify: `clarusc/check.cla:1716-1747` (checkExternFunc — param guard line :1733-1736 ONLY), `clarusc/ir.cla:620-683` (extern registry accepts str/text param types), `clarusc/cprint.cla:2944-2969` (cpEmitExternProtos param C types) + `:808-835` (fpCallExt arg marshalling)
- Modify: `internal/build/rt/rt_ext_host.inc` (new functions), `internal/build/rt/rt.c` (forward decls if include order requires)
- Create: `runtime/mac/rt_ext_mac.inc`; Modify: `runtime/mac/rt_mac.c` (include it after `rt_file_write_data`), `scripts/build-mac.sh:243-248` (only if a new TU — it must NOT be; use the .inc include, no script change)
- Test: `clarusc/test/check_test.cla` + `.out`; `testdata/lowlevel/exttext.cla` + `.out`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: 5a extern machinery (registry ir.cla:620-683, protos cprint.cla:2944, calls cprint.cla:808, guard check.cla:1716-1747 — quoted in full in the spec's exploration notes; the param-kind predicate is line :1734, the return predicate :1743).
- Produces: external param marshalling — `str` param emits C type `const uint8_t *` and call-site arg `fpStrAddr(<a>)`; `text` param emits `rt_text *` and passes the box pointer (borrowed, no retain — callee must not store it); returns stay int/ptr/bool/char (line :1743 untouched; split the two diagnostics: params say `"external parameters may only use int, ptr, bool, char, str, or text"`, returns keep the 5a message). And the wave-1 external set, implemented BOTH in `rt_ext_host.inc` and `rt_ext_mac.inc` (C bodies identical shape; Mac side delegates to the same rt.h/rt_core symbols, which exist in both TUs):

```c
void *rt_ext_HandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_FileWriteData(const uint8_t *path, rt_text *t) { return rt_file_write_data(path, t); }
int32_t rt_ext_FileReadTextInto(const uint8_t *path, rt_text *out) {
    rt_text *r = rt_file_read_text(path, 0);
    if (!r) return 0;
    rt_text_store_text(out, r);
    rt_text_release(r);
    return 1;
}
void rt_ext_SetLastErr(int32_t code, const uint8_t *msg) { rt_set_lasterr(code, (const char *)msg + 1); } /* msg is Str255; +1 skips len byte — see Step 3 note */
int32_t rt_ext_ListCount(void *l) { return rt_list_count((rt_list *)l); }
void *rt_ext_ListAt(void *l, int32_t i) { return rt_list_at((rt_list *)l, i); }
void rt_ext_ListClear(void *l) { rt_list_clear((rt_list *)l); }
void rt_ext_ListPush(void *l, void *elem) { rt_list_push((rt_list *)l, elem); }
int32_t rt_ext_MapCount(void *m) { return rt_map_count((rt_map *)m); }
void rt_ext_MapKeyAt(void *m, int32_t i, void *key255) { rt_map_key_at((rt_map *)m, i, (uint8_t *)key255); }
void rt_ext_MapValAt(void *m, int32_t i, void *out) { rt_map_val_at((rt_map *)m, i, out); }
void rt_ext_MapSet(void *m, void *key255, void *val) { rt_map_set((rt_map *)m, (const uint8_t *)key255, val); }
void rt_ext_MapClear(void *m) { rt_map_clear((rt_map *)m); }
```
  (Adjust to the real signatures in `rt.h`/`rt_core.inc` — e.g. `rt_file_read_text`'s second arg and `rt_set_lasterr`'s msg convention: rt_core stores a C string; if `rt_set_lasterr` expects NUL-terminated, build one from the Str255 in the wrapper. Verify against `rt_core.inc:19` before writing.) Host: append to `rt_ext_host.inc`; if `rt_file_write_data` (rt.c:166) is defined after the include (rt.c:48), add a forward declaration above the include rather than moving it. Mac: `rt_ext_mac.inc` included from `rt_mac.c` AFTER its `rt_file_write_data` (rt_mac.c:387-412) — plus the 5a seven (NewHandle…DisposePtr) so Mac has the full set.

- [ ] **Step 1: Failing checker cases:** `external func F(s: str, t: text)` clean; `external func G(): text` → the return diag (5a message); `external func H(m: map of int)` → the new param diag. Extend `check_test.out`.
- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/selfhost -run TestClarusModules`.
- [ ] **Step 3: Implement** per the Produces block: check.cla line :1734 gains `and k != TyStr and k != TyText` exemptions (i.e. allow them) with the split diagnostic; ir extern registry stores `irStrT(n)`-typed / `irTextT` param entries (follow how 5a stored param IR types); cpEmitExternProtos: param C type for KStr → `"const uint8_t *"`, KText → `"rt_text *"`; fpCallExt: str arg → `fpStrAddr(<arg>)` (cprint.cla:1060 helper), text arg → the plain expr. Note the `rt_set_lasterr` msg convention check from the Produces block.
- [ ] **Step 4: Run fixture** `testdata/lowlevel/exttext.cla`: declare `FileWriteData`/`FileReadTextInto`; build a `text` with appends, write to `"exttest.dat"`, read into a fresh `text`, compare lengths + a sampled char, alert ok/FAIL; delete nothing (harness runs in temp dirs). Freeze `.out`.
- [ ] **Step 5: Run:** `go test ./internal/lowlevel ./internal/selfhost -run 'Lowlevel|TestClarusModules' -v`; then full `go test ./...`.
- [ ] **Step 6: Mac smoke:** the emitui m68k compile-check covers compilation; additionally run `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestSuiteOnMac` once to prove the rt_ext_mac.inc addition breaks nothing (suite doesn't call the new externals; this is a link/compile gate).
- [ ] **Step 7: Snapshot + commit:** `"clarusc+rt: str/text external params; file/container/lasterr externals (host+Mac)"`.

---

### Task 4: Implicit runtime-module inclusion (usage flags, --rtdir, re-check flow)

**Files:**
- Modify: `clarusc/check.cla` (new module-level flag `var usesFileSaveLoad: bool` — declare near `appDeclSeen` :360, reset in checkReset :2779 region, set in the `file.` call arm — find `fileFuncs` dispatch, the checker arm that validates `file.save`/`file.load`), `clarusc/main.cla` (:241-259 flag loop for `--rtdir`, :272-276 expansion loop, :282-296 assembly, :305-307/:368-377 the check→lower flow)
- Create: `testdata/rtinc/` fixture dir (a fake runtime dir + a program, see Step 1)
- Test: new Go test in `internal/lowlevel/rtinc_test.go`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: main.cla program assembly (expand :117-178, `asmHeads` post-order :42/:176, `setDeclFile` lib.cla:103 — NOTE: lib.cla/lex.cla/tok.cla contain MacRoman bytes; grep them with `grep -a`), emit branch :368-377.
- Produces: the inclusion mechanism all later tasks flip modules into. Behavior: (1) `--rtdir DIR` flag (arm beside `-o` at :247-256); default = walk UP from the current working directory looking for `runtime/clarus/` (a directory containing `ser.cla` once Task 7 lands; for this task the probe file is the module manifest below), max 10 levels, no error if absent — the error surfaces only when a needed module can't be found: `"runtime module <name> not found (searched <dir>); use --rtdir"`. (2) A hardcoded module manifest in main.cla: list of `{flagName, fileName}` pairs — this task ships it EMPTY plus the machinery; Task 7 adds `{usesFileSaveLoad, "ser.cla"}`; Task 8+ add unconditional entries. (3) Flow (emit mode only): after the existing `checkProgram` + diagnostic gate (:305-322), consult the flags; for each needed module, `expand(joinPath(rtdir, fileName), true)`; rebuild `combined` with the runtime modules' heads FIRST (runtime decls precede user decls — declare-before-use), then `checkReset()` + re-`checkProgram(combined)` + re-gate diagnostics (runtime-module diags are compiler bugs but must surface, attributed to the runtime file via the existing setDeclFile loop :151-155); then lower/emit as today. Check-only mode (`clarus check` semantics — the no-subcommand path) does NOT pull runtime modules (user programs must check clean standalone).
- Note for the executor: `checkReset` must actually clear everything `checkProgram` populates — it already does (it's the per-program reset used by check_test's runCase driver); the re-check is the same call sequence that driver uses repeatedly in one process.

- [ ] **Step 1: Build the test fixture.** `testdata/rtinc/rt/ser.cla` — a stand-in runtime module (ordinary Clarus, NO new syntax needed):
```
// Fake runtime module for the inclusion-machinery test (Task 4).
func rtIncProbe(): int {
    return 4242
}
```
`testdata/rtinc/prog.cla` — a program whose emitted C should contain `clar_fn_rtIncProbe` only when inclusion fires; it must also exercise the file-usage flag:
```
record Note { n: int }
on App.startCLI(args: list of string) {
    var x: Note
    x.n = 7
    file.save("t.dat", x)
}
```
- [ ] **Step 2: Write the failing Go test** `internal/lowlevel/rtinc_test.go` — three subtests using the same clarusc-build helper the package already has:
  1. `emit` with `--rtdir testdata/rtinc/rt` (paths relative to repo root; compute like the existing tests) on `prog.cla`, with the manifest TEMPORARILY containing `{usesFileSaveLoad, "ser.cla"}`… — no: the manifest ships empty this task, so instead the test drives a TEST hook: add a hidden manifest entry gated behind the flag itself, i.e. this task ships the manifest with exactly `{usesFileSaveLoad, "ser.cla"}` as its ONE entry, and Task 7 repoints it at the real module. Assert emitted C contains `clar_fn_rtIncProbe` and that it appears BEFORE `clar_fn_` user functions.
  2. Same emit WITHOUT `--rtdir`, cwd = the temp dir (no runtime dir above it) → expect exit 1 and stderr containing "runtime module".
  3. A program with no `file.save` → emit succeeds flagless, C does NOT contain `rtIncProbe`.
- [ ] **Step 3: Run to verify FAIL**, then **Step 4: implement** per Produces. **Step 5: tests green** (`go test ./internal/lowlevel -run RtInc -v`, then TestClarusModules, then full suite — note `snapshot` stays byte-identical because clarusc itself doesn't call file.save and the flagless no-file.save path is unchanged).
- [ ] **Step 6: Snapshot + commit:** `"clarusc: implicit runtime-module inclusion (--rtdir, usage flags, re-check)"`.

---

### Task 5: Flat serializer descriptors (`clar_serdesc_`)

**Files:**
- Modify: `clarusc/cprint.cla` (:3156-3196 cpEmitLayouts region — add sibling emitter `cpEmitSerDescs`, called from emitProgram :4620-4647 next to cpEmitLayouts)
- Test: `testdata/emitui/filesave.cla`'s golden (regenerate) — assert the new array by eye once; add `testdata/emitui/serdesc.cla` + `.c.golden` if filesave doesn't cover an enum field (it does — check; if covered, no new fixture)
- Regenerate: `clarusc/clarusc.c` + affected emitui goldens

**Interfaces:**
- Consumes: `irLayoutNeeded(name)` gate (ir.cla:575-581), existing row builder context (cpFieldDescRow :3110-3143, ftype constants RT_FT_INT 0/FIXED 1/BOOL 2/CHAR 3/STR 4/ENUM 5 from rt.h:151-156).
- Produces: for every `irLayoutNeeded` record, alongside the existing tables: `static const int32_t clar_serdesc_<REC>[] = { <recSizeExprOrZero-see-below>, <nFields>, then per field: <ftype>, <strCap>, (int32_t)offsetof(clar_rec_<REC>, cv_<F>), <enumCount>, <enum values inline...> };` — first slot is `(int32_t)sizeof(clar_rec_<REC>)`. Task 7's Clarus serializer walks exactly this layout with peekl at stride 4: `[0]=recSize [1]=nFields` then fields sequentially, each `4 + enumCount` int32s. Document the format in a comment block above the emitter AND in `runtime/clarus/ser.cla`'s header when Task 7 writes it.

- [ ] **Step 1:** Regenerate `testdata/emitui/filesave.c.golden` EXPECTATION by hand-writing the expected new array into a copy, or simpler: implement first (small, additive), then diff the regenerated golden and verify by eye that the array matches the format spec above (this task is emission-only; the golden diff IS the test). Implement `cpEmitSerDescs` (≈25 lines, model on cpEmitLayouts' loop + gate), wire into emitProgram directly after `cpEmitLayouts()`.
- [ ] **Step 2:** `/tmp/clarusc emit` the emitui fixtures; inspect `filesave.c.golden`'s diff: array present, gated fixtures without file.save unchanged. Commit goldens with the code.
- [ ] **Step 3:** Full suite + snapshot + commit: `"clarusc: flat int32 serializer descriptors (clar_serdesc_)"`.

---

### Task 6: CLRD byte-compare gate (pre-port baseline)

**Files:**
- Create: `internal/sertest/clrdcompare_test.go`
- Test fixture: reuse `testdata/sertest/` roundtrip fixtures (they save records/lists/maps — read `internal/sertest/sertest_test.go:87-152` for the emit+cc+run mechanics and fixture inventory)

**Interfaces:**
- Consumes: `build.Build` (Go compiler path, internal/build), the sertest clarusc emit path.
- Produces: `TestCLRDByteCompare` — for each sertest save-capable fixture: build with the GO compiler (`build.Build`), run in temp dir A; build via clarusc emit + cc, run in temp dir B; byte-compare the produced `.dat`/CLRD files A vs B (and both runs' stdout). This gate is the port oracle: green now (both C), and it must stay green through Task 7 when side B switches to the Clarus serializer.

- [ ] **Step 1:** Write the test; run: green (both sides C today). **Step 2:** Full suite; commit `"sertest: CLRD file byte-compare gate (Go-build vs clarusc-build)"`.

---

### Task 7: Serializer port (`runtime/clarus/ser.cla`) + redirect

**Files:**
- Create: `runtime/clarus/ser.cla`
- Modify: `clarusc/main.cla` (manifest: repoint `{usesFileSaveLoad, "ser.cla"}` at the real runtime dir default), `clarusc/cprint.cla` (:1859-1863 IFileSave/IFileLoad arms — redirect), plus a ported-module flag the redirect keys on: add `var cpSerPorted: bool` set from main.cla when the ser module was included (plumb via a setter, mirror how `irHasApp`-style flags flow — or an ir-side mark `irMarkRuntimePorted("ser")` set during inclusion and read by cprint; pick ONE mechanism and document it, Tasks 8-11 reuse it per family)
- Test: existing gates (Task 6 byte-compare, sertest roundtrips, differential corpus, lowlevel leak gates) + `CLARUS_MAC_TESTS=1` bookmarks persistence scenario
- Regenerate: snapshot + emitui goldens (filesave etc. now embed the ser module's emitted C)

**Interfaces:**
- Consumes: EVERYTHING from Tasks 1-6: overlays not needed here (ser walks user records via flat descriptors + peek/poke, and containers via externals); Task 3 externals (FileWriteData, FileReadTextInto, SetLastErr, List*/Map*, BlockMoveData, NewPtr/DisposePtr, HandleDeref unused here); Task 5 `clar_serdesc_` format; Task 4 inclusion.
- Produces: `func rtFileSave(path: ptr, container: int, data: ptr, desc: ptr): int` and `func rtFileLoad(path: ptr, container: int, data: ptr, desc: ptr): int` in ser.cla (path = address of the emitted Str255; container 0=REC 1=LIST 2=MAP matching RT_SER_REC/LIST/MAP in rt.h). Redirected emission at cprint :1859-1863 when ser ported: `clar_fn_rtFileSave((void*)<fpStrAddr a0>, <0|1|2>, <dataExpr>, (void*)clar_serdesc_<REC>)` (same dataExpr selection :1848-1858; container becomes the int literal).

**Behavior contract (port EXACTLY; the C reference is `internal/build/rt/rt_ser.inc`, 328 lines — the implementer MUST read it side-by-side):**
- Format: header `'C','L','R','S'`, version byte 1, container byte; fields per record: INT/FIXED/ENUM as 4-byte BE; BOOL read as int32 (native, via peekl on record memory) canonicalized to ONE byte 0/1 on disk, written back as full int32 on load; STR as 1 length byte + strCap data bytes zero-padded, load rejects len>strCap; ENUM load validates membership against the descriptor's inline values. All output built in a Clarus `text` via append ops; all input via a `text` filled by FileReadTextInto, walked with an int cursor.
- recSize > 2048 → same panic path as C (`rt_panic` — expose as one more external `rt_ext_Panic(msg: str)` added in this task to both .incs, or reuse SetLastErr + quit; MATCH the C behavior: panic).
- Save-LIST: copy each element out via `BlockMoveData(ListAt(l,i), scratch, recSize)` into a `NewPtr(recSize)` scratch BEFORE appending bytes (the relocation discipline from rt_ser.inc:125-137 — text appends can move the list's Handle); free scratch at the end. Save-MAP: same with MapValAt (which already copies) into scratch + the key via MapKeyAt into a 256-byte scratch.
- Load: clear target container first, again on failure; trailing-bytes check (cursor != len → error); errors = `SetLastErr(2, "bad file format")` + return 0; success returns 1.
- Byte-for-byte proof: Task 6's gate stays green with ZERO golden changes.

- [ ] **Step 1:** Write `runtime/clarus/ser.cla` (with the descriptor-format comment block from Task 5). ~250 lines.
- [ ] **Step 2:** Flip the manifest + implement the redirect + ported-flag plumbing.
- [ ] **Step 3:** Run the gauntlet in order, foreground: `go test ./internal/sertest -v` (roundtrips + byte-compare), `go test ./internal/lowlevel ./internal/emitui`, `go test ./internal/selfhost` (differential + leak gates + snapshot — regenerate snapshot/goldens as needed first), full `go test ./...`, then `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSuiteOnMac|Bookmarks' -timeout 30m`.
- [ ] **Step 4:** Commit `"runtime: serializer ported to Clarus (ser.cla); file.save/load redirect"` (snapshot + goldens in the same or an adjacent re-bless commit — logic and re-bless separated per the spec's churn rule).

---

### Task 8: str family port (`runtime/clarus/str.cla`)

**Files:** Create `runtime/clarus/str.cla`; modify main.cla manifest (unconditional entry — every program gets it once ported); cprint redirect for the str arms; snapshot + ALL emitui goldens + corpus re-bless (dedicated commit).

**Interfaces:**
- Consumes: peek/poke (bytes only — this family is pure byte-buffer logic, no overlays, no allocation); `BlockMoveData` external where the C used it; the ported-flag mechanism from Task 7.
- Produces: Clarus functions with these signatures (all bytes through peekb/pokeb; dst/a/b are addresses of Str255/StrN buffers; caps are ints): `rtStrStore(dst: ptr, dstcap: int, src: ptr)`, `rtStrConcat(out: ptr, a: ptr, b: ptr)`, `rtStrConcatChar(out: ptr, a: ptr, c: int)`, `rtStrPrependChar(out: ptr, c: int, a: ptr)`, `rtStrCmp(a: ptr, b: ptr): int`, `rtStrLen(s: ptr): int`, `rtStrIndex(s: ptr, i: int): int`, `rtStrSetIndex(s: ptr, i: int, c: int)`, `rtStrFromBytes(dst: ptr, dstcap: int, buf: ptr, bufcap: int, count: int)`, `rtStrToBytes(s: ptr, buf: ptr, bufcap: int): int`, `rtStrSlice(out: ptr, s: ptr, start: int, len: int)`, `rtStrIndexOfStr(s: ptr, sub: ptr): int`, `rtStrIndexOfChar(s: ptr, c: int): int`.
- **Redirect inventory (cprint.cla fpIntrCall — change EXACTLY these arms; C reference for each behavior is rt_core.inc:31-171):** :1363 IStrConcat, :1369 IStrConcatChar, :1375 IStrPrependChar, :1378 IStrCmp, :1380 IStrLen, :1382 IStrIndex, :1386 IStrSetIndex, :1393 IStrFromBytes, :1399 IStrToBytes, :1407 IStrCoerce (→rtStrStore), :1413 IStrSlice, :1416 IStrIndexOfStr, :1418 IStrIndexOfChar. Plus non-intrinsic sites: fpStoreStr :2099, cpDefaultInit :2531/:2534 (str arms), fpUiEditStmt :2087, ILastErrMsg :1813 / ILastErr :1822 (these two read `rt_lasterr_msg`, a C global — KEEP rt_str_store here, C; document as deliberate exclusion), cpEmitGlobalsInit :4344. Every redirected call keeps identical casts but targets `clar_fn_rtStrXxx` with `(void*)` on the address args and `(int32_t)` on char/int args (chars widen: C `uint8_t` args become Clarus `int` params carrying 0-255).
- **Behavior contract:** clamp-plus-`SetLastErr(1, "string truncated")` on overflow (store/concat/concatChar/prependChar/fromBytes/toBytes exactly as rt_core.inc:31-134); slice is the exception — STRICT bounds with panic (rt_core.inc:145-146), including len>255. Ordering (rtStrCmp) is byte-wise unsigned, shorter-is-less on prefix (match rt_core.inc:88-100 exactly).

- [ ] **Step 1:** Port with the C file open side-by-side; every function's doc comment cites its rt_core.inc line range.
- [ ] **Step 2:** Redirect the inventory; flip the manifest entry (unconditional).
- [ ] **Step 3:** Gauntlet: `go test ./internal/selfhost` FIRST (differential corpus is the big str consumer; every .out golden must pass unchanged), then full suite, then re-bless snapshot + emitui goldens in a dedicated commit, then Mac suite (`TestSuiteOnMac` — the 39-case suite is string-heavy; byte-identical host-vs-Mac still required).
- [ ] **Step 4:** Commits: logic `"runtime: str family ported to Clarus (str.cla) + redirects"`, then re-bless.

---

### Task 9: text family port (`runtime/clarus/text.cla`)

**Files:** Create `runtime/clarus/text.cla`; manifest entry (unconditional); cprint redirects; snapshot/golden re-bless.

**Interfaces:**
- Consumes: Task 2 overlays — declare `overlay record RtText { rc: int; h: ptr; len: int; cap: int }` (mirrors rt_core.inc:259's `struct rt_text { int32_t rc; Handle h; int32_t len; int32_t cap; }`; add a C-side `_Static_assert`-equivalent guard: a line in rt.c like `typedef char rt_text_layout_check[(sizeof(rt_text) == sizeof(struct { int32_t a; void *b; int32_t c; int32_t d; })) ? 1 : -1];`); `HandleDeref` external (master pointer); mem externals (NewPtr/NewHandle/SetHandleSize/DisposeHandle); str module (Task 8).
- Produces: `rtTextNew(): ptr`, `rtTextStore(t: ptr, s: ptr)`, `rtTextStoreText(dst: ptr, src: ptr)`, `rtTextConcat(dst: ptr, a: ptr, bstr: ptr, btext: ptr)` (bstr/btext mutually exclusive, NULL as ptr(0) — matches the C signature so the :1142-1146 call shape keeps working), `rtTextConcatSl(dst: ptr, a: ptr, b: ptr)`, `rtTextCmp(a: ptr, b: ptr): int`, `rtTextCmpStr(t: ptr, s: ptr): int`, `rtTextLen(t: ptr): int`, `rtTextIndex/SetIndex/FromBytes/ToBytes/Slice/IndexOfStr/IndexOfChar/AppendStr/AppendChar/AppendText` mirroring rt_core.inc:266-473 signatures with ptr in place of rt_text*/uint8_t*.
- **RC boundary:** `rc` field is READ-NEVER-WRITTEN by this module; retain/release/lastref/free stay C (`rt_text_release` etc. — cpEmitRelease/fpHeapFn untouched). `rtTextNew` must produce a box the C RC layer owns: allocate via the same path — port the body of rt_text_new (NewPtr box + NewHandle bytes + rc=1... rc WRITE at birth is allowed, it's initialization; document this single exception) or add external `rt_ext_TextNewRaw` delegating to C `rt_text_new` — CHOOSE the external delegation (lazier, keeps every rc byte C-owned); then rtTextNew is just that external call and the redirect for :1421-1491 text arms points the REST at Clarus.
- **Redirect inventory:** fpIntrCall :1421 (ITextCmp via fpTextCmp :1117-1130 — redirect inside fpTextCmp), :1423 (ITextConcat via fpTextConcat :1136-1146), :1429 ITextConcatSL, :1433 ITextStore, :1436 ITextLen, :1438 ITextIndex, :1442 ITextSetIndex, :1448 ITextFromBytes, :1454 ITextToBytes, :1459 ITextSlice, :1462/:1464 IndexOf, :1466/:1469/:1472 appends, :1482-1484 ITextOfStr, plus cpDefaultInit :2536 (`rt_text_store` init arm) and :2534 (`rt_text_new()` → keep: it IS rt_ext-delegated via rtTextNew? No — cpDefaultInit emits C directly; redirect :2534 to `clar_fn_rtTextNew()` and :2536 to `clar_fn_rtTextStore`), fpUiEditStmt :2091 stays C (UI, deliberate exclusion), :1935 IUiGetTextviewText `rt_text_new()` stays C (UI), ITextFreeVar :1491 stays C (RC). fpNewTmp :260's `"rt_text_release"` string stays C (RC).
- **Relocation discipline:** every byte access re-derives the master pointer via `HandleDeref(t.h)` AFTER any call that can allocate/move (append, grow, concat) — mirror rt_core.inc's re-deref pattern; the paranoid allocator (CLARUS_MEM_PARANOID) will catch violations in the leak-gated runs. Growth: port `rt_core_grow`'s doubling policy (rt_core.inc:246-255) via SetHandleSize external.

- [ ] Steps mirror Task 8: port with C side-by-side → redirect → gauntlet (differential first, paranoid leak gates are the real judge here) → Mac suite → logic commit + re-bless commit. Message: `"runtime: text family ported to Clarus (text.cla) + redirects"`.

---

### Task 10: list family port (`runtime/clarus/list.cla`)

**Files:** Create `runtime/clarus/list.cla`; manifest; redirects; re-bless.

**Interfaces:**
- Consumes: `overlay record RtList { rc: int; data: ptr; elemsize: int; count: int; cap: int }` (mirrors rt_core.inc:483-489); HandleDeref; mem externals; the birth-allocation decision from Task 9 (external `rt_ext_ListNewRaw` delegating to C `rt_list_new` — same rationale).
- Produces + redirect inventory (fpIntrCall): :1524-1528 push/unshift (`clar_fn_rtListPush(l, (void*)&(v))` — the `fpRetainVal` prefix at :1521 stays C), :1532-1556 pop/shift (both emission points), :1569-1586 first/last (the `_retain` suffix calls stay C), :1609 IListRemove (the old-value read at :1606 uses `rt_list_at` — STAYS C per the RC-layer rule), :1633-1645 IListSet's `rt_list_at` ref STAYS C (interior-pointer primitive), :1648 IListCount → `clar_fn_rtListCount`, fpForListStmt :2246 (`rt_list_count` → `clar_fn_rtListCount`; the :2252 `rt_list_at` deref stays C), cpDefaultInit :2539 → `clar_fn_rtListNew` (which itself calls the raw external, consistent with text). **STAYS C, complete list (verify each against the RC-layer Global Constraint):** fpIndexRef :859 (`rt_list_at`), fpForListStmt :2252 (`rt_list_at`), every cpEmitRelease/cpEmitRetain site (:2602-2654, :2738-2742), fpHeapFn-composed retain/release (:366/:398/:432/:1584/:1715), IListFreeVar :1663, fpUiEditStmt :2077.
- Ported bodies: new (via raw external + field init through overlay), push/pop/shift/unshift/first/last/remove/count/clear/note(skip note — ledger is host-C-only; keep C), growth policy from rt_core.inc:491-577, element moves via BlockMoveData + HandleDeref(l.data) with re-deref discipline.

- [ ] Steps as Task 8/9: port → redirect → gauntlet (the ARC corpus fixtures arc_*.cla in the differential run are the critical gate) → Mac suite → commits `"runtime: list family ported to Clarus (list.cla) + redirects"` + re-bless.

---

### Task 11: map family port (`runtime/clarus/map.cla`)

**Files:** Create `runtime/clarus/map.cla`; manifest; redirects; re-bless.

**Interfaces:**
- Consumes: `overlay record RtMap { rc: int; keys: ptr; vals: ptr; valsize: int; count: int; cap: int; valcap: int }` (mirrors rt_core.inc:582-590); `rt_ext_MapNewRaw` (add, delegating to `rt_map_new`); MAP_KEYBLOCK=256 constant; str module for key compares.
- Produces + redirect inventory: :1704 IMapSet (the `fpMapReleaseGuard` prologue :1179-1188 uses rt_map_has/rt_map_get — those two calls are INSIDE the guard emission; redirect them too since has/get are ported — but the `_release` it emits stays C), :1714-1718 IMapGet, :1738-1743 IMapGetDv, :1774-1779 IMapGetDvBirth (retain/release parts stay C), :1783 IMapHas, :1794 IMapRemove, :1797 IMapCount, cpDefaultInit :2541 → `clar_fn_rtMapNew`, fpForMapStmt :2276/:2280/:2283 (count/key_at/val_at are ported, not RC — redirect all three; the loop structure is unchanged). **STAYS C:** cpEmitRelease map walks :2659-2690 wholesale (mixed C walk calling C `rt_map_val_at`, per the RC rule — the C `rt_map_val_at` remains linked for exactly this), IMapFreeVar :1802, fpHeapFn-composed retain/release.
- Ported bodies: sorted parallel key/val arrays, binary search (map_lower_bound/map_find from rt_core.inc:608-643), set/get/get_dv/has/remove/count/clear/key_at/val_at, both-handle growth, key block copies via BlockMoveData.
- Behavior contract: `get` on absent key panics (match rt_core.inc:670-676 — use the Panic external); `get_dv` returns 0 and leaves out untouched on absent; `remove` silent on absent.

- [ ] Steps as prior: port → redirect → gauntlet → Mac suite → commits `"runtime: map family ported to Clarus (map.cla) + redirects"` + re-bless.

---

### Task 12: Adversarial container matrix + paranoid soak

**Files:** Create `testdata/lowlevel/arc_ported_matrix.cla` (+ `.out`) — or several files if one exceeds ~150 lines; no compiler changes expected.

**Interfaces:** Consumes everything; produces the wave's memory-safety evidence.

- [ ] **Step 1:** Write fixtures covering, for BOTH list and map with text elements and record elements: whole-container reassign, discarded call-result container, aliased container (two vars, one cleared), element pop/shift discard, map overwrite-same-key, load-over-populated-container (file.load into a non-empty list — exercises ported clear + ported ser together). These mirror the ARC-era blind spots recorded in the ROADMAP (reassign/discard/alias per slot class). All alert-verified AND leak-gate-verified (live=0).
- [ ] **Step 2:** Run `go test ./internal/lowlevel -v` and the full differential with paranoid mode (already env-set in emit_test). Any UAF/double-free here is a Task-10/11 bug — fix there, re-run.
- [ ] **Step 3:** Commit `"lowlevel: adversarial container matrix over ported runtime"`.

---

### Task 13: 5a leftovers

**Files:** `internal/reftest/` or `internal/selfhost/` (clarusc-sweep test), `clarusc/test/check_test.cla` + `.out`, `docs/clarus-language-reference.md`.

- [ ] **Step 1:** Clarusc-side fence sweep: new Go test that runs the clarusc binary's CHECK mode over every `ClaruscOnly` fence (write fence to temp .cla, run `clarusc <file>` — no subcommand = check mode, expect exit 0 and no output). Note some Ch13 fences are declaration fragments — apply the same wrap-or-exclude judgment `CheckClean`'s curation comments use; document each index's treatment.
- [ ] **Step 2:** check_test cases: `var m: map of ptr` and `var a: ptr[4]` → "ptr cannot be a container element" (both arms now directly tested); same pair for overlays if Task 1 didn't already cover map/array forms.
- [ ] **Step 3:** Ch13 wording: "reserved for window references" → "window/resource references" (~line 1296); replace the coined "reference counting" sentence (~line 1315) with zero-value/never-retained phrasing. Check fence indices didn't shift (prose-only edits).
- [ ] **Step 4:** Suite + commit `"docs+test: 5a leftovers (fence sweep, container-elem tests, Ch13 wording)"`.

---

### Task 14: Docs, ROADMAP, spec outcomes, final gate

**Files:** `docs/ROADMAP.md`, both spec files, full-suite + Mac runs.

- [ ] **Step 1:** Spec outcomes note in `2026-07-29-runtime-migration-wave1-design.md`: what landed per stage, the raw-birth-allocation externals decision (TextNewRaw/ListNewRaw/MapNewRaw), the redirect exclusion list as-built, any behavior notes discovered. Umbrella spec: mark 5b done in its sequencing section.
- [ ] **Step 2:** ROADMAP entry per 4a-4e style; note Retro68 still in the Mac app path (unchanged until 5d), C runtime retained for the frozen Go compiler.
- [ ] **Step 3:** Final gate, foreground: `go test ./... -count=1`; `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 40m` (FULL gated suite — all 29 boots; the ported runtime now runs inside every Mac binary); eyeball the suite timing vs the ROADMAP's 68k baseline note (expect ≈no change — still gcc -O2; record the number).
- [ ] **Step 4:** Commit `"docs: 5b landed (runtime wave 1 in Clarus); ROADMAP + spec outcomes"`.

---

## Self-review notes (performed at write time)

- Spec coverage: §1 redirect→Tasks 7-11; §2 inclusion→Task 4; §3 overlays→Tasks 1-2; §4 waist→Task 3 (+Panic in Task 7, NewRaw in 9-11); §5 flat descriptors→Task 5; §6 stages→task order; §7 no-risk claims→Task 14 verification; carried leftovers→Task 13; churn rule→dedicated re-bless commits in 7-11.
- Known deliberate exclusions from redirect (kept C), consolidated: ALL retain/release/lastref/free, `rt_list_at` everywhere, cpEmitRelease/cpEmitRetain walks, fpHeapFn compositions, UI-block emissions (:1866-2046, :2077, :2091, :1935), lasterr-global reads (:1813/:1822), `rt_list_note`, `rt_arr_check`, `rt_enum_from_int`, `rt_file_read_text`/`rt_file_write_text` user-level intrinsics (:1827/:1829 — text-file I/O stays C this wave; only the SERIALIZER's file path went through externals), `rt_file_name` (:1833).
- Type consistency: `rtFileSave/rtFileLoad(path: ptr, container: int, data: ptr, desc: ptr): int` (T7) matches redirect emission; overlay names RtText/RtList/RtMap (T9-11) match Task 2's semantics; NewRaw externals introduced in T9 and reused T10-11; ported-flag mechanism defined once (T7) and reused.
- Fresh-session sufficiency: every task carries its file:line anchors, C reference ranges, exact signatures, and behavior contracts; the four context docs are listed in the header; no facts live only in the planning conversation.
