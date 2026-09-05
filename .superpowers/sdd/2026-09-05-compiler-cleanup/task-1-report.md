# Task 1 report — Stale master pointers passed into allocating traps (spec §3.1)

Status: **COMPLETE**. All four survey sites fixed (five call sites in the
emitted code — the textview one spans a whole InvalRect..ValidRect region).

Worktree: `/Users/andrew/repos/clarus/.claude/worktrees/agent-a324e40b0a1e22597`
Branch: `worktree-agent-a324e40b0a1e22597`, reset onto `compiler-cleanup` @ `311af68`
(the worktree was created off `main`, one commit behind the phase base).

Commit: `fix(runtime): lock handles whose master pointers are passed into allocating traps (4 sites)`

---

## Step 1 — sites confirmed

```
grep -n 'UiDrawText(base + 1, 0, peekb(base))'            uitable.cla   -> 411   (1 hit)
grep -n 'UiInvalRect(lhMp + rtUiListRView)'               uitable.cla   -> 887   (1 hit)
grep -n 'UiInvalRect(UiHandleDeref(te) + rtUiTeViewRect)' uiwidgets.cla -> 853,955 (2 hits)
grep -n 'UiInvalRect(UiHandleDeref(lh) + rtUiListRView)'  uiwidgets.cla -> 1155  (1 hit)
```

Expected 1/1/2/1 — matched exactly.

---

## Step 2 finding — what `rec` derives from in `rtUiTableDrawField`

**Outcome: RELOCATABLE. It is a real hazard, and Step 3 applies.**

Trace:

- `rtUiTableDrawField` has exactly one caller — `rtUiLdefDraw`, the LDEF
  callback, `uitable.cla:620`.
- The caller computes `rec = rtListAt(rows, row)` (`uitable.cla:619`).
- `rtListAt` (`runtime/clarus/list.cla:286-299`) returns
  `ListHandleDeref(rl.data) + i * rl.elemsize` — i.e. **a master-pointer-
  relative address inside the rt_list's own `data` Handle**, an ordinary
  unlocked relocatable block. The caller's own pre-existing comment
  (`uitable.cla:600-618`) already says so verbatim: "the rt_list's own
  (unlocked, Handle-backed) element block".

So `base = rec + uidFieldOffset(...)` is master-pointer-relative, and the
`rtUiFtStr` arm hands `base + 1` straight into `UiDrawText`, which
allocates (font strike load). That is precisely the shape `bff3268`'s
re-derive-before-the-call rule cannot cover: the caller already re-derives
`rec` immediately before the call (that was the 2026-08-29 popup-table
blank-cell fix), but the relocation window here is *inside* the trap.

Audit of the rest of `rtUiTableDrawField`: the `rtUiFtStr` arm is the ONLY
remaining `base`-relative read that survives across an allocation. The
`Int`/`Fixed`/`Bool`/`Char` arms all read `base` into a local *before*
their `UiNewPtr`, and the `Enum` arm reads `peekl(base)` first and then
works only from constant-pool label pointers. Nothing else needed a fix.

### Where the lock went, and why not verbatim inside the function

The brief's Step 3 snippet locks `recH` *inside* `rtUiTableDrawField`, but
that function receives only `rec: ptr` — it has no access to the owning
handle, no access to `rows`, and the brief's own Interfaces section says
"no signature changes". The brief anticipates this ("pass it in **or
re-derive it the way the caller does**"). Re-deriving the caller's way is
only possible at the caller, so the lock is placed there, around the whole
`rtUiTableDrawField(...)` call:

```
rec = rtListAt(rows, row)
recH = RtList(rows).data
hstate = UiHGetState(recH)
UiHLock(recH)
rtUiTableDrawField(rec, layoutOff, uidColFieldIndex(colsOff, k), colRect)
UiHSetState(recH, hstate)
```

This is strictly stronger than the brief's placement: it covers every
`rec`-relative read in the callee, not just the one `UiDrawText`, and it
needs no signature change. `RtList(rows).data` is exactly as null-safe as
the pre-existing `rtListCount(rows)` two statements above it (both deref
the same overlay record; `rtListCount` is not null-safe either), so no new
crash surface is introduced. The `row >= 0 and row < count` guard already
proves `rows` is a live list before this point.

---

## Per-site record

### Site 1 — `uitable.cla:619-637`, `rtUiLdefDraw` (was ~411 in the callee)

- **Handle:** `RtList(rows).data` — the rt_list element-storage Handle
  backing the table's row list.
- **Allocating trap:** `_DrawText` (`$A883`), reached via
  `rtUiTableDrawField`'s `rtUiFtStr` arm, with `base + 1` (a pointer into
  that block) already evaluated as its argument.
- **Why the lock is safe:** the block is a plain data Handle owned by the
  rt_list; nothing in the locked region resizes it. `rtUiTableDrawField`
  never calls `rtListPush`/`rtListGrow` or any other list mutator — it
  only reads fields and draws. The window is one field draw, and the
  state is restored, not blindly unlocked.
- **Edit:** `var recH: ptr` + `var hstate: int` added to the LDEF's var
  block; the `UiHGetState`/`UiHLock` … `UiHSetState` bracket added around
  the existing call.

### Site 2 — `uitable.cla:901-911`, `rtUiTableSyncOne`

- **Handle:** `lh`, the List Manager `ListRec` Handle for this table widget.
- **Allocating trap:** `_InvalRect` (`$A928`) — Window Manager update-region
  growth — with `lhMp + rtUiListRView` already evaluated as its argument.
- **Why the lock is safe:** `InvalRect` reads a `Rect` and unions it into
  the port's `updateRgn`. It never touches the ListRec. The only thing
  under the lock is that one trap.
- **Edit:** replaced the `lhMp = UiHandleDeref(lh)` re-derive + `UiInvalRect(lhMp + …)`
  pair with the state-preserving bracket around
  `UiInvalRect(UiHandleDeref(lh) + rtUiListRView)`. `lhMp`'s declaration is
  KEPT — it still has a live use earlier in the function
  (`lmCount = peekw(lhMp + rtUiListDataBoundsBottom)`).

### Site 3 — `uiwidgets.cla:851-863`, `rtUiWidgetSetStr`'s FIELD+TEXT arm

- **Handle:** `te`, the field's `TEHandle` (TERec).
- **Allocating trap:** `_InvalRect`, with `UiHandleDeref(te) + rtUiTeViewRect`
  already evaluated as its argument.
- **Why the lock is safe:** only the one `InvalRect` is inside the bracket.
  `UiTECalText` — the call that genuinely CAN resize the TERec, because it
  recalculates the record's trailing `lineStarts[]` array — is deliberately
  left ABOVE the lock, and `rtUiTeMutated` below it.
- **Edit:** `var hstate: int` added; bracket around the one `UiInvalRect`.

### Site 4 — `uiwidgets.cla:963-1017`, `rtUiWidgetSetText` (textview live paint)

- **Handle:** `te`, the textview's `TEHandle`.
- **Allocating traps in the region:** `_InvalRect`, then (after
  `rtUiTeMutated`) `_TEUpdate` (`$A9D3`) and `_ValidRect` (`$A92A`), the
  last two taking `teMp + rtUiTeViewRect` — a master-pointer-relative Rect
  address — as their first argument. The lock brackets the WHOLE region,
  per controller decision 2.
- **Edit:** `var hstate: int` added; `UiHGetState`/`UiHLock` inserted right
  after `UiTECalText(te)`, `UiHSetState(te, hstate)` inserted after
  `UiValidRect(...)` and before `UiSetPort(savedPort)`. The existing
  `teMp = UiHandleDeref(te) // AFTER the NewPtr` line is kept unchanged
  (harmless, and it documents the older rule).

#### Spec §7 confirmation — nothing in the locked region resizes the TERec

Confirmed. Classic TextEdit's TERec Handle is variable-sized: it ends in a
`lineStarts[]` array, so the routines that RECALCULATE line breaks
(`TECalText`, `TESetText`, `TEKey`, `TEInsert`, `TEDelete`) can
`SetHandleSize` the TERec itself. TextEdit's *text* is a separate handle
(`hText`), so text growth is irrelevant here. I walked every call in the
locked region:

| Call in the region | Recalculates lineStarts / resizes TERec? |
|---|---|
| `UiInvalRect` | No — Window Manager updateRgn only |
| `rtUiTeMutated` → `rtUiFieldCap` | No — pure `uidesc` accessor chain |
| `rtUiTeMutated` → `rtUiTeClamp` | `TESetText` — **would**, but unreachable here (see below) |
| `rtUiTeMutated` → `rtUiTeScrollSync` | No — `SetControlMaximum`/`TEScroll`/`SetControlValue`/`TextWidth`; `TEScroll` only edits `destRect` in place |
| `UiNewPtr`/`UiSetRect`/`UiEraseRect`/`UiDisposePtr` (erase strip) | No |
| `UiTEUpdate` | No — draws only, no recalc |
| `UiValidRect` | No |

The one candidate, `rtUiTeClamp`'s `UiTESetText`, is guarded by
`if peekw(teMp + rtUiTeTeLength) <= maxLen { return }`. For a textview
`rtUiTeMutated` passes `cap = rtUiTeMax` (32000), and
`copied = rtTextToBytes(t, buf, rtUiTeMax)` twelve lines earlier already
clamped the text to exactly that ceiling — so `teLength <= maxLen` always
holds and the clamp returns before `TESetText`. It cannot fire on this
path.

Note also that `rtUiTeClamp` does its own `UiHLock(th)`/`UiHUnlock(th)` on
`hText` — a DIFFERENT handle — so the nested lock does not collide with
ours, and every nested `rtUiTe*` state pair in `uitext.cla` is
`HGetState`/`HSetState`-shaped, so an outer lock survives them.

Because the resize path is provably unreachable rather than structurally
impossible, I stayed with the lock (controller decision 2) rather than the
rect-copy fallback, and pinned the reasoning in the source comment so a
future change to `rtUiTeMutated`'s cap logic is forced to re-read it. If a
reviewer prefers the invariant-free option, the rect-copy variant is a
drop-in for this one site.

### Site 5 — `uiwidgets.cla:1179-1189`, `rtUiWidgetSetInt`'s table SELECTED arm

- **Handle:** `lh`, the table's `ListRec` Handle.
- **Allocating trap:** `_InvalRect`, argument already evaluated from the
  master pointer.
- **Why safe:** same as site 2 — only the one trap under the lock.
- **Edit:** `var hstate: int` added; bracket around the one `UiInvalRect`.

All five brackets use `UiHGetState` → `UiHLock` → … → `UiHSetState`. No
bare `UiHUnlock` was introduced anywhere, so a handle a caller already
holds locked stays locked.

---

## Step 8 — byte safety

Both files are pure 7-bit ASCII, before and after:

```
$ git show HEAD:runtime/clarus/uitable.cla   | LC_ALL=C grep -c $'[\x80-\xff]'   -> 0
$ git show HEAD:runtime/clarus/uiwidgets.cla | LC_ALL=C grep -c $'[\x80-\xff]'   -> 0
$ LC_ALL=C grep -c $'[\x80-\xff]' runtime/clarus/uitable.cla runtime/clarus/uiwidgets.cla
runtime/clarus/uitable.cla:0
runtime/clarus/uiwidgets.cla:0
$ python3 -c "... sum(1 for c in open(p,'rb').read() if c>127)"
runtime/clarus/uitable.cla   high bytes: 0
runtime/clarus/uiwidgets.cla high bytes: 0
```

Counts unchanged (0 = 0). The edits were applied by a byte-level Python
script (`replace` on `bytes`, one-occurrence assertion per edit), never by
the Edit/Write tools.

---

## Golden diffs — attribution (NOT blessed)

`make test T='cg68k/goldens emitui/goldens'` → both FAIL, as the brief
predicted. Neither was blessed.

### emitui/goldens — 13 of 18 fixtures red

Every fixture that splices `uiwidgets.cla`/`uitable.cla` moved; the 5 that
pass (`app_nonui`, `filesave`, `lowlevel_seam`, `overlay_seam`,
`xrec_ptr_field`) shake those functions out.

Full `diff -u testdata/emitui/textwidgets.c.golden <fresh>` — this is the
COMPLETE diff, nothing elided:

```
@@ -4872,6 +4872,8 @@   (rtUiWidgetSetStr)
+    int32_t cv_hstate;
+    cv_hstate = 0;
@@ -4897,7 +4899,10 @@
         rt_ext_UiTECalText(cv_te);
+        cv_hstate = rt_ext_UiHGetState(cv_te);
+        rt_ext_UiHLock(cv_te);
         rt_ext_UiInvalRect(... rt_ext_UiHandleDeref(cv_te) + 8 ...);
+        rt_ext_UiHSetState(cv_te, cv_hstate);
         clar_fn_rtUiTeMutated(cv_instV, cv_wIdx, 0);
@@ -4991,6 +4996,8 @@   (rtUiWidgetSetText)
+    int32_t cv_hstate;
+    cv_hstate = 0;
@@ -5007,6 +5014,8 @@
     rt_ext_UiTECalText(cv_te);
+    cv_hstate = rt_ext_UiHGetState(cv_te);
+    rt_ext_UiHLock(cv_te);
     rt_ext_UiInvalRect(...);
@@ -5025,6 +5034,7 @@
     rt_ext_UiValidRect(... cv_teMp + 8 ...);
+    rt_ext_UiHSetState(cv_te, cv_hstate);
     rt_ext_UiSetPort(cv_savedPort);
@@ -5138,6 +5148,8 @@   (rtUiWidgetSetInt)
+    int32_t cv_hstate;
+    cv_hstate = 0;
@@ -5185,7 +5197,10 @@
     clar_fn_rtUiTableSelectExclusive(cv_lh, cv_row);
+    cv_hstate = rt_ext_UiHGetState(cv_lh);
+    rt_ext_UiHLock(cv_lh);
     rt_ext_UiInvalRect(... rt_ext_UiHandleDeref(cv_lh) + 0 ...);
+    rt_ext_UiHSetState(cv_lh, cv_hstate);
@@ -6561,6 +6576,10 @@   (rtUiLdefDraw)
+    void * cv_recH;   cv_recH = 0;
+    int32_t cv_hstate; cv_hstate = 0;
@@ -6602,7 +6621,11 @@
     cv_rec = clar_fn_rtListAt(cv_rows, cv_row);
+    cv_recH = (((clar_rec_RtList *)(cv_rows)))->cv_data;
+    cv_hstate = rt_ext_UiHGetState(cv_recH);
+    rt_ext_UiHLock(cv_recH);
     clar_fn_rtUiTableDrawField(...);
+    rt_ext_UiHSetState(cv_recH, cv_hstate);
@@ -6812,6 +6835,8 @@   (rtUiTableSyncOne)
+    int32_t cv_hstate;  cv_hstate = 0;
@@ -6836,8 +6861,10 @@
-    cv_lhMp = rt_ext_UiHandleDeref(cv_lh);
-    rt_ext_UiInvalRect((void *)((char *)(cv_lhMp) + (0)));
+    cv_hstate = rt_ext_UiHGetState(cv_lh);
+    rt_ext_UiHLock(cv_lh);
+    rt_ext_UiInvalRect(... rt_ext_UiHandleDeref(cv_lh) + 0 ...);
+    rt_ext_UiHSetState(cv_lh, cv_hstate);
```

Second fixture, `win_basic.cla` — machine census of every changed line
(`diff | grep '^[-+][^-+]' | sort | uniq -c`), 31 lines total:

```
   1 -    cv_lhMp = rt_ext_UiHandleDeref(cv_lh);
   1 -    rt_ext_UiInvalRect((void *)((char *)(cv_lhMp) + (0)));
   5 +    int32_t cv_hstate;              5 +    cv_hstate = 0;
   1 +    void * cv_recH;                 1 +    cv_recH = 0;
   1 +    cv_recH = (((clar_rec_RtList *)(cv_rows)))->cv_data;
   6 +  ... rt_ext_UiHGetState(cv_recH|cv_te|cv_lh) ...
   6 +  ... rt_ext_UiHLock(cv_recH|cv_te|cv_lh) ...
   6 +  ... rt_ext_UiHSetState(cv_recH|cv_te|cv_lh, cv_hstate) ...
   1 +    rt_ext_UiInvalRect(... rt_ext_UiHandleDeref(cv_lh) + 0 ...);
```

Every changed line is a new `hstate`/`recH` local, a new
HGetState/HLock/HSetState call, or the one InvalRect argument rewritten
from `cv_lhMp` to an inline deref. Nothing else moved.

### cg68k/goldens — all 31 fixtures red

Non-obvious but fully attributed: every `testdata/cg68k/*.cla` fixture is
compiled by `emit68k` WITHOUT `--rtdir`, so **every** fixture splices the
whole UI runtime (`clarusc emit68k -o /dev/null testdata/cg68k/xrec.cla`
logs `Included runtime/clarus/uiwidgets.cla` / `uitable.cla`). Their
listings are therefore sensitive to any UI-runtime change.

Baseline check: with the two files restored from HEAD and clarusc
rebuilt, `xrec.seg1` is byte-identical to `testdata/cg68k/xrec.s` — the
goldens ARE fresh at `311af68`, so all 31 reds are mine.

`xrec.cla` with labels normalized (`s/LBL_[0-9]+/LBL_N/g`) shows only two
kinds of hunk:

1. **`rtUiLdefDraw` frame growth.** `LINK A6,#-2264` → `#-2272` (two new
   4-byte locals), the local map comment gains `recH : -48(A6)` /
   `hstate : -52(A6)`, every later local shifts by −8, and the new code
   appears verbatim as the trap sequence:
   ```
   +   MOVE.L -32(A6),D0 / MOVEA.L D0,A0 / LEA 4(A0),A0 / MOVE.L (A0),D0
   +   MOVE.L D0,-48(A6)                       ; recH = RtList(rows).data  (offset 4)
   +   ... DC.W $A069  ; UiHGetState
   +   ... DC.W $A029  ; UiHLock
       BSR.W <rtUiTableDrawField>
   +   ... DC.W $A06A  ; UiHSetState
   ```
2. **Segment repack.** Seg 1 grew, so `clar_ui_fire_releasevars` (JT slot
   177) crossed the 32K boundary from seg 1 into seg 2, taking its
   panic-message string constant with it. Verified by grep: the symbol is
   in `testdata/cg68k/xrec.s` (seg1) in the golden and in `out.seg2.s`
   now, with 0 hits in the other file each time — moved, not
   added/removed. That move turns one `BSR.W` into `JSR 1450(A5)` (near
   call → jump-table call) and shifts one JT slot address by 8 bytes, and
   it is why the top-level label counter drops by 2. No instruction
   changed semantics.

Nothing was blessed. Both golden sets are wave-1 bless material for Task 5.

---

## Tests run

| Command | Result |
|---|---|
| `make -j tools bootstrap` | OK (both stages) |
| `clarusc-current emit --rtdir runtime/clarus/ examples/texteditor.cla` | OK (host lane accepts `RtList(rows).data` from `uitable.cla`) |
| `clarusc-current emit68k --rtdir runtime/clarus/ examples/texteditor.cla` | OK (native lane, 4 segments) |
| `make test T='cg68k/goldens emitui/goldens'` | 2 FAIL — expected, attributed above, NOT blessed |
| `make -j t1` | **74 passed, 34 skipped, 2 failed** — the only two failures are `cg68k/goldens` and `emitui/goldens` |
| `CLARUS_MAC_TESTS=1 make -j1 test T='mactest/toolbox_68k mactest/coresuite_68k mactest/smoke_bounce'` | **3 PASS** (`toolbox_68k` 165s / `coresuite_68k` 4s / `smoke_bounce` 6s); toolbox log shows 35 `PASS <case>` lines incl. `SelfCheck` |
| `CLARUS_MAC_TESTS=1 make -j1 test T='mactest/toolbox_jiggle mactest/ui_scenarios mactest/leakgate'` | **3 PASS** (148s / 35s / 2s) |

`pgrep -x minivmac` was empty before each gated command; only one boot ran
at a time. (`Snow` was running under another agent — a different emulator
on the System 7 lane, not covered by the one-Mini-vMac rule; no
interference observed.)

Beyond the brief I also ran the two extra gates spec §3.1 names as its
proof: `toolbox_jiggle` (CompactMem at every `UiNewPtr` — the heap-jiggle
harness) and `ui_scenarios` (the four frozen golden scenarios). Both
green, which additionally proves the change is **behavior-neutral**: the
blessed UI trace and PBM framebuffer snaps are unchanged.

`selfhost/fixedpoint`'s `snapshot_fresh` is NOT affected — this task edits
no `clarusc/*.cla`.

### One flake, investigated and cleared

The first `make -j t1` run also reported `FAIL(exit 1) conntest/abort`
(`prompt_exit1: exit 124 … peer-dependent`). Investigated: it passes on
the HEAD runtime, passes 3/3 when run alone with my change, and passed on
the second `make -j t1`. It is a real-socket test that times out at 2s
under parallel load, not a regression.

### Worktree note

The worktree shipped without the `toolchain/`, `Retro68/` and `macplus/`
symlinks (they are not in git). I recreated them pointing at the same
targets the main checkout uses; without `toolchain/` the `emitui/goldens`
script SKIPs rather than running.

---

## Self-review

- **Completeness.** All four survey sites addressed; the Step 2 outcome is
  documented as "relocatable, is a hazard" with the full trace. The §7
  TERec-resize question is answered with a per-call table, not a
  hand-wave.
- **Quality.** Every bracket carries a comment saying WHY it exists (the
  relocation window is inside the trap, the shape `bff3268` cannot fix)
  and why the state is restored rather than unlocked. The two `te`
  comments additionally record which call was deliberately left outside
  the lock, and why.
- **Discipline.** No unrelated refactors, no signature changes, no new
  functions, no `clarusc/` edits, nothing blessed. 61 insertions,
  2 deletions, 2 files. The two deleted lines are the `lhMp` re-derive
  pair the new bracket replaces; `lhMp`'s declaration stays because it
  still has a live use.
- **Testing.** Host goldens attributed line-by-line; native boots run, not
  deferred, including the jiggle gate and the frozen scenarios.

## Concerns for the controller

1. **Task 5 must bless both golden sets.** `testdata/emitui/*.c.golden`
   (13 fixtures) and `testdata/cg68k/*.s` (31 fixtures, all of them). The
   cg68k churn is bigger than a naive read suggests because seg 1 crossed
   its 32K boundary — a whole function and its string constant moved to
   seg 2.
2. **Seg 1 is near its 32K limit** for cg68k fixtures. 61 lines of runtime
   source was enough to push a function across. Later tasks in this phase
   that add runtime code will keep re-triggering large cg68k golden churn;
   worth batching the bless.
3. **The textview lock rests on one invariant** — that `rtUiTeMutated`'s
   clamp never fires for a textview, because a textview's cap IS
   `rtUiTeMax` and `rtTextToBytes` already clamped to it. True today,
   pinned in the source comment. If a future change gives textviews a
   tighter cap, that site should switch to the rect-copy variant spec
   §3.1 offers.
4. **No red-to-green test exists for this class**, exactly as spec §3.1
   states. Proof is the green native suite (35/35 toolbox cases, the
   jiggle gate, the four frozen scenarios) plus reviewer verification of
   each site above.
