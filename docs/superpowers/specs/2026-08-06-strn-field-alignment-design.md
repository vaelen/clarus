# string(n) record-field layout convergence (cprint lane)

**Date:** 2026-08-06
**Status:** approved (Andrew, 2026-08-06)
**Closes:** ROADMAP "Small open items" — *Cross-lane `string(n)` record-field
alignment divergence* (found during small-scalar-width Task 4, 2026-08-05).

## Problem

cg68k's record-field layout authority gives a `string(n)` field 2-byte
alignment (`cgRecFieldAlignOf` → `cgAlignOf`, size ≥ 2) **and** even-rounded
size (`cgRecFieldSizeOf` → `cgSlotSizeOf`, e.g. `string(2)` occupies 4).
cprint's model (`cpCAlignOfField`/`cpCSizeOfField`) gives the same field
1-byte alignment and exact `n+1` size — because that is what any C compiler
does with the emitted `clar_str_n` struct (`{ uint8_t len; uint8_t b[n]; }`,
all-byte, natural alignment 1).

So a `string(n)` field preceded by an odd run of `bool`/`char` bytes sits at
a different offset on the two Mac lanes (`record { flag: bool; name:
string(10) }` → `name` at 1 on cprint, 2 on cg68k), and any field *after* an
odd-sized `string(n)` field diverges too (`record { s: string(2); b: bool }`
→ `b` at 3 on cprint, 4 on cg68k). The same rounding gap makes
array-of-string element stride diverge (`string(2)[k]`: C stride 3, native
stride 4).

Verified latent, not live: `file.save`/`file.load` serialize via a per-field
descriptor walk into a byte-exact big-endian format (`rt_ser.inc`) using each
lane's own offsets, so files are cross-lane compatible; host-build ser
descriptors are emitted as literal `offsetof`/`sizeof` expressions; uiblob
model offsets (the one consumer of `cpCFieldOffset`'s computed values) only
ever see the six descriptor field kinds. Nothing compares or copies record
bytes wholesale (no `memcmp` on records anywhere).

The reference's Ch13 "Ordinary `record` packing" paragraph already states the
2-byte rule for `string(n)`; cg68k implements it. **All changes are
cprint-side** — make the emitted C obey the documented rule.

## Design

All code changes in `clarusc/cprint.cla`; cg68k untouched.

1. **`cpEnsureStr` (`cprint.cla:891`): pad `clar_str_n` to even size.** When
   `n+1` is odd (n even), emit
   `typedef struct { uint8_t len; uint8_t b[n]; uint8_t clar_pad; } clar_str_n;`
   so `sizeof` matches `cgSlotSizeOf`. `clar_str_255` (n+1 = 256) is
   unchanged. This alone converges array-of-string element stride (C array
   stride = element sizeof) and makes every `string(n)` field's size
   contribution even. Safe: nothing consumes `sizeof(clar_str_n)`
   semantically — runtime str calls pass the cap explicitly, the serializer
   writes `1 + strCap` bytes, str assignment is C struct assignment (copies
   the pad harmlessly), and `len`/`b` keep their offsets.

2. **Model flip:** `cpCAlignOfField`'s `KStr` arm → 2; `cpCSizeOfField`'s
   `KStr` arm → `cgAlignUp(irtN(t) + 1, 2)`. `cpCFieldOffset`/`cpCRecordSize`
   pick both up unchanged (they walk on these two helpers).

3. **`cpEmitRecords` (`cprint.cla:4452`): emit explicit pad members** so the
   real struct realizes the model on both m68k GCC and host cc:
   - Track the model offset parity across the field walk. Only C-align-1
     members can leave odd parity; anything the C compiler self-aligns at
     ≥ 2 (int/fixed/enum, text/list/map, window refs — all even-sized)
     resets parity to even. Parity contributions: `bool`/`char` +1;
     `bool[n]`/`char[n]` +n; `string(n)` +0 (even-padded typedef); nested
     record + its `cpCRecordSize` parity; array of T + n × elem-size parity.
   - Before a `string(n)` field at odd parity: emit `uint8_t clar_pad<k>;`.
   - After the walk: if the model total is odd and the record's model
     maxAlign is 2 (mirroring `cpCRecordSize`'s final `cgAlignUp` exactly),
     emit a trailing `uint8_t clar_pad<k>;` so real `sizeof` matches the
     rounded model.
   - Pad member names use the `clar_` prefix, not `cv_`, so they cannot
     collide with user field names. Pads are never IR fields: the ctor
     default-init loop, ARC walks, and descriptor emission all iterate IR
     fields and skip them automatically. Pads stay uninitialized in
     `clar_new_<T>`; nothing reads them.

4. **Reference: one storage note.** Ch13's ordinary-record packing paragraph
   gains a sentence: a `string(n)` field (and array element) occupies its
   even-rounded size (`n+1` rounded up to even), on both lanes. Ch3's storage
   table row (`string(n) | n+1 bytes`) gets the same pointer the `bool`/
   `char` row already has to the aggregate-packing rule.

5. **ROADMAP:** close the `string(n)` item; add a new small-open-item for the
   scoped-out siblings (below).

## Out of scope (file as one new ROADMAP small-open-item)

The same divergence family exists for the remaining odd-C-sized field kinds;
same root cause, rarer shapes, offsets never consumed cross-lane:

- `char[n]`/`bool[n]` array **fields** with odd n: cg68k gives the field an
  even-rounded slot (`char[3]` occupies 4) and 2-byte alignment; C packs it
  at exact size, natural alignment 1.
- The degenerate `char[1]`/`bool[1]` case, where cg68k's even-rounded 2-byte
  slot arguably contradicts the reference's "packs at 1-byte alignment, same
  as a bare bool/char field" sentence — needs a decision (reference wording
  vs `cgSlotSizeOf`) before fixing.
- All-byte records (only `bool`/`char`/odd byte-array fields): odd C
  `sizeof`, unrounded, C struct alignment 1 — diverges from cg68k's
  even-rounded `cgRecordSize` in total size, nested-record field offset, and
  array-of-record stride.

## Testing

- `TestSnapshotFixedPoint` + snapshot regen (clarusc's own records contain
  `string(n)` fields; self-hosting exercises the new layout hard).
- T1 (`scripts/test-task.sh`); T2 (`scripts/test-merge.sh`) before merge —
  the Mac-lane suites prove uiblob model offsets against the real structs
  (a wrong model offset fails form/table cases visibly).
- One new/extended emit golden containing an odd-parity record
  (`bool` + `string(2)` + `bool`) so pad emission is pinned and reviewable.
