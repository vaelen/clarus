# Runtime Migration Wave 1 (Plan 5b) — Design

**Date:** 2026-07-29
**Status:** Approved (brainstorm with Andrew, 2026-07-29)
**Parent:** `2026-07-29-native-68k-toolchain-design.md` (Plan 5 umbrella). This
spec covers phase 5b: porting the serializer and the core
string/text/list/map runtime from C to Clarus over the 5a waist.

## Goal

The full spec wave 1: `rt_ser` and the `rt_str_*`/`rt_text_*`/`rt_list_*`/
`rt_map_*` families become Clarus source (`runtime/clarus/*.cla`), compiled
into every program that uses them by clarusc's own backends. The RC/memory
layer below them stays C (wave 2, per the umbrella spec's
"recently-hardened code ports last" rule) and is reached through waist
externals. Every stage lands with the differential corpus, leak gates, and
Mac suite green.

## Scope decision (2026-07-29)

Andrew chose the full wave over a serializer-only 5b, accepting the larger
plan. Staging (§Port order) is designed so the str/text/list/map stages can
be cut to a follow-on plan mid-flight without stranding work.

## Load-bearing facts (from code exploration, 2026-07-29)

- `rt_ser.inc` has a two-symbol public surface (`rt_file_save`,
  `rt_file_load`, rt.h:175-176) over one per-platform write primitive
  (`rt_file_write_data`: host rt.c:166, Mac rt_mac.c:387) and the public
  `rt_file_read_text`. Byte output goes through `rt_text_append_char`
  one byte at a time — already endian-canonical.
- The existing layout descriptor tables (`rt_layout_desc`/`rt_field_desc`,
  rt.h:151-176) contain three pointer-valued fields (one double-indirect:
  `enumLabels`) and `long`s — 18-byte entries on m68k vs 40-byte on the
  LP64 host. **Unwalkable from portable Clarus.** The serializer needs only
  ftype/strCap/offset/enumValues — never the labels.
- The runtime box structs (`rt_text`, `rt_list`, `rt_map`) contain
  pointer-width fields, so their field offsets also differ per target —
  same portability trap; this is what forces overlay records.
- `rt_str_*` is pure byte-buffer code (no allocation, no RC) — portable
  with peek/poke alone.
- Containers are `memmove`-of-N-bytes boxes with zero type knowledge;
  ALL per-element retain/release is emitted by the compiler at call sites.
  Porting container logic therefore does NOT move RC policy — RC stays in
  C, invoked via externals.
- Emitted C maps intrinsics ~1:1 onto `rt_*` symbols in `fpIntrCall`
  (cprint.cla:1221ff) — the redirect point.
- The frozen Go compiler's emitted code calls the C runtime forever, so
  the C implementations cannot be deleted. They remain in `rt.c` as the
  Go-side implementation — and thereby as the differential oracle.

## Design

### 1. Binding: intrinsic redirect, no export mechanism

Ported runtime functions are ordinary Clarus functions using a reserved
`rt`-prefixed naming convention (documented in the reference; a user
collision hits the normal duplicate-declaration diagnostic). cprint's
intrinsic arms redirect per ported module: where `str.concat` emits
`rt_str_concat(...)` today, it emits `clar_fn_rtStrConcat(...)` (same
argument casts) when the module is ported. No new export surface. The C
implementations stay in `rt.c` for Go-built programs; dead in
clarusc-built ones.

**Differential oracle:** every corpus program builds twice — Go compiler
(C runtime) vs clarusc (Clarus runtime) — with stdout byte-compared, and
for serializer programs the saved CLRD file byte-compared too. The C
runtime is the reference implementation the port is proven against.

### 2. Runtime source and implicit inclusion

- Location: `runtime/clarus/*.cla` (sibling of `runtime/mac/`), one module
  per family (ser, str, text, list, map).
- clarusc feeds runtime modules implicitly — user programs never `include`
  them. Inclusion is gated per module on IR usage marks (serializer module
  only when `file.save/load` is present; str/text/list/map when their
  intrinsics appear). Coarse tree-shaking; function-level shaking stays 5c.
- clarusc locates the runtime sources relative to a `--rtdir` flag with a
  repo-relative default (exact mechanics are plan detail). The bootstrap
  one-liner (`cc … clarusc.c rt.c`) is unaffected — building clarusc needs
  no runtime sources; compiling *programs* does, and they live in the repo.
- Snapshot/golden churn is accepted and re-blessed once per stage: when the
  str/container stages land, every program (including clarusc itself)
  carries the runtime's emitted C, so `clarusc/clarusc.c` and the corpus
  goldens grow. The bootstrap fixed-point tests still hold — they just pin
  a bigger artifact.

### 3. Overlay records (the one language addition)

`overlay` record types — declared like records, bound to a `ptr`, with
field access emitting real C pointer-to-struct access
(`((clar_rec_Name *)(x))->cv_field`), so the C compiler computes correct
per-target layout; the 68k backend computes its own layout in 5d/5e.

v1 restrictions:
- scalar fields only: int, bool, char, fixed, ptr (no str/text/list/map/
  record fields — keeps overlays out of ARC entirely);
- an overlay value IS a pointer: assignment copies the pointer, `==`
  compares addresses, no constructors, no retain/release, no serializer
  or form participation;
- usable as variable/param/return types; not as container elements
  (same rule as `ptr`).

Layout-match guarantee: the emitted overlay struct for `RtList`
(`int32_t`, `void *`, `int32_t`, `int32_t`, `int32_t` in declaration
order) has the same field sequence and types as C's `rt_list`, so the same
ABI lays both out identically. Each overlay declaration in the runtime
source carries a comment naming the C struct it mirrors; a C-side
`_Static_assert(sizeof…)`-style guard in rt.c pins the correspondence
where expressible.

Reference: overlay records get a Chapter 13 section; fences join
`ClaruscOnly`.

### 4. Waist extensions

- **External marshalling grows `str` and `text`:** a `str` param marshals
  as the Str255 address (`uint8_t *`), a `text` param as the box pointer
  (`rt_text *`). Return types stay int/ptr/bool/char. Needed for paths and
  for handing built byte streams to the file layer; generally useful for
  every future waist function that takes a name or buffer.
- **File layer stays C, exposed as externals** wrapping the existing
  per-platform primitives (host stdio versions in rt.c; Mac FSOpen/FSWrite
  versions in rt_mac.c — both already exist). The Clarus serializer builds
  its stream in an ordinary `text` value and calls
  `rt_ext_FileWriteData(path, out)` / reads via a matching read external.
- **Handle-deref primitive** (the 5a pointer-width lesson, resolved here):
  `external func HandleDeref(h: ptr): ptr` — transition C implementation
  is `*(void **)h`; the native backend inlines a MOVEA later. This is the
  master-pointer access the container element addressing needs.
- **RC/mem externals:** retain/release/lastref (×3 families) and the
  Memory Manager entry points the container logic needs, as thin
  `rt_ext_*` wrappers. The hardened C RC layer is used, not ported.

### 5. Flat serializer descriptors

cprint emits, per serialized record, an additional pointer-free flat
`int32` table (`clar_serdesc_REC[]`): field count, then per field
ftype / strCap / `(int32_t)offsetof(clar_rec_REC, cv_F)` / enumCount /
enum values inline. No labels — the serializer never needs them. The
Clarus serializer receives it as `ptr` and walks it with `peekl`:
portable, because entries are native int32 and the offsets come from the
C compiler's own `offsetof` on each target. The existing pointer-style
tables continue to be emitted for the UI consumers (form walker, table
LDEF, popup) until 5e; the duplication is transitional and gated on the
same `irLayoutNeeded` mark.

### 6. Port order (each stage lands green; stages C-E cuttable)

- **A — Machinery:** implicit runtime inclusion + intrinsic-redirect
  mechanism + overlay records + external str/text marshalling + flat
  descriptor emission + file/deref/RC externals. Proven by a toy runtime
  module end-to-end before any real port.
- **B — Serializer:** port `rt_ser` logic (header, i32/bool/str/enum field
  canonicalization, record/list/map containers, trailing-byte check,
  lasterr discipline, 2048-byte record cap, element-copy-before-append
  relocation discipline). Gates: differential corpus, sertest roundtrips,
  saved-file byte-compare Go-vs-clarusc, Mac bookmarks persistence
  scenario, leak gate.
- **C — str family:** pure byte functions, peek/poke only. Clamp+lasterr
  semantics and the slice panic exception preserved exactly.
- **D — text family:** overlay on `rt_text`, growth policy via mem
  externals, relocation discipline (re-derive `*h` after any call that can
  move memory).
- **E — list/map:** overlays on `rt_list`/`rt_map`, HandleDeref element
  addressing, sorted-parallel-array map with binary search, RC via
  externals. The ARC-era adversarial fixture matrix (reassign/discard/
  alias per slot class) re-runs throughout.

Strict-ledger leak gates run at every stage — ported allocations flow
through the same instrumented C seam, so coverage is preserved.

### 7. Explicitly not at risk in 5b

- **68k performance:** during the whole wave, Mac builds compile ported
  modules as emitted C under Retro68 gcc -O2 — zero perf regression; the
  naive-codegen cost arrives only with 5d (recorded in the umbrella spec).
- **Memory-safety invariants:** UAF/double-free guarding stays in the
  untouched C RC layer; the governing invariant (leak over unsafe free)
  is unchanged.
- **Bootstrap:** snapshot buildable by cc alone throughout; the chain's
  fixed point is re-established at each stage's re-bless.

## Carried-in 5a leftovers

- clarusc-side check sweep over `ClaruscOnly` fences (today no compiler
  parses them).
- Direct `map of ptr` / array-of-ptr rejection tests.
- Ch13 wording nits: "window/resource references" for nil; replace the
  coined "reference counting" phrasing.

## Risks

- **Plan size:** largest since 4d (est. 14-16 tasks). Mitigation: staged
  landings, cuttable tail.
- **Behavioral drift in ported semantics** (clamp vs panic boundaries,
  lasterr codes, map absent-key semantics): pinned by the differential
  corpus and the C reference; any divergence is a failing gate, not a
  judgment call.
- **Overlay/C struct layout mismatch:** guarded by declaration-order
  discipline + C-side size asserts + the differential gate (a mismatch
  corrupts immediately and loudly under the paranoid allocator).
- **Golden/snapshot churn noise:** large re-blesses at stages C-E could
  mask real regressions — mitigation: re-bless in dedicated commits with
  no logic changes, so logic diffs stay reviewable.

## Outcomes (2026-07-30, Tasks 1-13 landed)

The full wave landed as designed, Stage A through E, on branch `native-5b`.
`runtime/clarus/{ser,str,text,list,map}.cla` (2,127 lines total) now carry
the ported logic; `internal/build/rt/rt.c` and `runtime/mac/rt_mac.c` keep
the C originals as the permanent Go-compiler backend and the differential
oracle. `clarusc/clarusc.c` grew to 38,894 lines carrying its own
now-implicit runtime inclusion.

- **Stage A (machinery) — Tasks 1-6:** overlay records (front end + KOverlay
  emission, no-ARC, `->field`/conversions), implicit per-module runtime
  inclusion gated on IR usage marks (`--rtdir`), str/text external param
  marshalling plus file/container/lasterr externals for both host and Mac,
  flat `clar_serdesc_<REC>[]` int32 descriptor emission, and the sertest
  CLRD byte-compare gate (see the Task 6 defect below) — all as designed.
- **Stage B (serializer) — Task 7:** `ser.cla` (519 lines) replaces
  `rt_ser.inc`'s `rt_file_save`/`rt_file_load` byte-for-byte; established
  the ported-flag mechanism (`cpSerPorted`) and the extern-naming
  convention both reused by every later family.
- **Stage C (str) — Task 8:** `str.cla` (323 lines), pure byte/peek-poke
  logic, no allocation.
- **Stage D (text) — Task 9:** `text.cla` (592 lines), overlay on `rt_text`,
  established `TextNewRaw` birth-allocation and `cpEmitDefaultInitFnProtos`
  (below).
- **Stage E (list/map) — Tasks 10-11:** `list.cla` (297 lines) and `map.cla`
  (396 lines), overlays on `rt_list`/`rt_map`, `ListNewRaw`/`MapNewRaw`
  reusing the Task 9 pattern, sorted-parallel-array map search preserved.
- **Verification — Tasks 12-13:** an 18-probe adversarial container matrix
  (reassign/discard/alias per slot class) over the ported runtime, zero
  bugs surfaced; then a small 5a-leftover sweep (fence checks, container-
  element rejection tests, two Ch13 wording fixes) closed out before this
  task.

### Task 6 plan defect and its adjudication

The plan's original oracle for the serializer stage called for a
Go-compiler-vs-clarusc double build of every corpus program, byte-comparing
stdout and saved CLRD files. That is unbuildable: the frozen Go host
compiler permanently rejects `file.save`/`file.load` programs
(`internal/build/unsupported_test.go`, a restriction dating to the
2026-07-22 host-backend plan, predating this wave). The controller
adjudicated a golden-based oracle instead: the frozen C serializer's CLRD
bytes and stdout are committed under `testdata/sertest/clrd_goldens/`, and
`internal/sertest/clrdcompare_test.go` byte-compares every clarusc build
against them (the file documents why the double-build oracle doesn't
apply). This preserved the same guarantee through the Task 7 str→ser flip
and every later family — the goldens themselves never moved across any
subsequent port.

### Raw-birth-allocation externals decision

`TextNewRaw`/`ListNewRaw`/`MapNewRaw` delegate the *whole* box construction
(allocation + `rc` initialization) to the existing C `rt_text_new`/
`rt_list_new`/`rt_map_new`, rather than having the ported Clarus code
allocate raw memory and set `rc` itself — the plan's lazier option
(§4 "RC/mem externals"), confirmed as-built. Rationale documented at each
call site (`runtime/clarus/{text,list,map}.cla`): `rc` is written exactly
once, entirely in C, with no Clarus-side field poking of a struct whose
layout portability is exactly what overlays exist to avoid duplicating.

### Extern-naming convention (evolved Tasks 7-8; completed final review)

Every runtime module uses privately-prefixed extern names — `SerFileWriteData`,
`StrPanic`, `TextHandleDeref`, `ListNewRaw`, `MapBlockMoveData`, etc. — each
backed by its own `rt_ext_<Prefix>*` wrapper in *both*
`internal/build/rt/rt_ext_host.inc` and `runtime/mac/rt_ext_mac.inc`. This
was not the plan's original naming (which reused shared names across
families); it was forced by a real gap found mid-wave: `irRegisterExtern`
does no cross-declaration dedup, so if two modules (or a user program)
declared an `external func` with the same name, the merged translation
unit got conflicting C prototypes. Per-family prefixes make every extern
name globally unique by construction — Task 7 initially applied this only
to `ser.cla`'s two file-I/O externs (`SerFileWriteData`/`SerFileReadTextInto`),
leaving fourteen more (`NewPtr`, `DisposePtr`, `BlockMoveData`, `Panic`,
`SetLastErr`, `List*`, `Map*`) unprefixed and colliding with the documented
Ch13 user-external-func API; the final whole-branch review caught and fixed
the gap, renaming all fourteen to the `Ser*` prefix (verified by grepping
every `external func` across `runtime/clarus/*.cla`: no name collides across
files).

### Ported-flag mechanism (Task 7, reused Tasks 8-11)

Per-family `cpSerPorted`/`cpStrPorted`/`cpTextPorted`/`cpListPorted`/
`cpMapPorted` bools live in `cprint.cla`, set at main.cla's emit-manifest
decision point and reset per program. `cpStrPorted` (and every family
after it) is set unconditionally true — str is a required dependency of
every other family, unlike `cpSerPorted`, which is conditional on
`file.save`/`file.load` usage.

### cpEmitDefaultInitFnProtos (Task 9 fix)

A narrow forward-declaration pass, added when text.cla landed, for
`cpDefaultInit`'s redirect targets (`rtStrStore`/`rtTextNew`/`rtTextStore`/
`rtListNew`/`rtMapNew`): a call-before-prototype ordering gap in the
emitted C. `cprint.cla`'s maintenance comment on the function mandates that
any future `cpDefaultInit` redirect addition update this pass in the same
commit.

### Scratch buffers: non-relocatable NewPtr, not Handle

A Task 9 review finding, fixed mid-plan: text.cla's growth-scratch buffers
use non-relocatable `NewPtr` blocks with an OOM panic at the wrapper
(`rt_ext_TextNewPtr`), matching the C reference exactly. An earlier
`TextNewHandle` draft was deleted in favor of this.

### Redirect exclusion list, as-built (kept C, per family)

Consolidated from every family's own doc comments in `cprint.cla`:

- ALL retain/release/lastref/free calls, for all three families;
- `rt_list_at` everywhere it's used to *address* an element (never
  redirected): `fpIndexRef`, `fpForListStmt`'s element deref, `IListSet`
  and `IListRemove`'s old-value read;
- `cpEmitRelease`/`cpEmitRetain`'s own deep per-element walks, including
  the C `rt_map_val_at` call inside the map walk;
- `fpHeapFn`'s stem compositions (`_retain`/`_release`/`_lastref` name
  building) stay against the C stems;
- UI-block emissions: `fpUiEditStmt`'s str/list arms and its MAP arm
  (documented as a fifth STAYS-C site in `map.cla`, since `rt_map_get_dv`
  writes through a caller buffer the UI layer owns) and
  `IUiGetTextviewText`;
- lasterr-global reads (`ILastErrMsg`/`ILastErr`) keep `rt_str_store`;
- `rt_list_note`;
- `ITextFreeVar`/`IListFreeVar`/`IMapFreeVar`;
- `fpMapReleaseGuard`'s own `_release` call (its has/get pair IS
  redirected; only the guard's release stays C, matching the other
  release exclusions above).

### Dead-but-ported parity functions

`rtListClear`/`rtTextStoreText` exist in the ported modules for parity with
the C reference but have no intrinsic wiring reaching them — `ser.cla`
uses its own independent `rt_ext_ListClear`/`rt_ext_MapClear` external path
instead. Left in place rather than deleted, matching each module's
"port everything the C file has" discipline; harmless dead code, not a gap.

### Task 12 verification matrix

18 adversarial container probes (reassign/discard/alias crossed with each
element slot class: value, str, text, list-of-X, map-of-X) run over the
now-fully-ported runtime. Zero live leaks, zero bugs surfaced — the ARC
counting discipline held across the whole port unchanged.

## Umbrella spec status

Plan 5b (this spec) is DONE as of this task. See
`2026-07-29-native-68k-toolchain-design.md`'s "Sequencing" section, updated
alongside this note.
