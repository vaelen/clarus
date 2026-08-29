# Task 1 — probe wave report (68k call-result release)

**Date:** 2026-08-29
**Branch:** `68k-call-result-release`
**Scope:** verification only. No source file was modified; the only command
run against the tree was the existing test suite (`go test ./internal/cg68k
-count=1`) plus read-only `clarusc emit68k` probes on scratch `.cla` files
outside the repo.

All line numbers are on the unmodified tree at this commit.

## Verdict summary

| Item | Assumption | Verdict |
|---|---|---|
| 1 | Handoff coverage: every ownership-taking consumer reads `cgLastTrackedOff` right after the one `cgExpr` that sets it | **PASS** (with two documented, pre-existing narrow leaks + one recommended 4-line hardening; no UAF path) |
| 2 | No KRec sibling gap | **PASS for argument / assignment / discard**; one hole found in the **receiver/operand** context (`makeRec().field`) — documented, out of scope |
| 3 | Pool headroom absorbs the extra temps | **FAIL — `cgTmpSlots` MUST be bumped.** Proven: a real in-tree statement (`cprint.cla:3868`) sits at exactly the 14-slot ceiling today and needs 21 after the fix. T1 (`TestSelfEmit68k`) goes red without the bump. |
| 4 | No machinery change needed in the pending-arg-release / abort-path flush code | **PASS.** The hypothesised D0-clobber latent bug does **not** exist — `cgFlushArgReleases` already brackets its walk with a D0/D1 push/pop pair. No reorder required; today's discard-branch position is the correct position. |
| 5 | Existing special cases stay coherent; no path tracks the same value twice | **PASS.** All 14 `cgNewTrackedTmp` sites enumerated; none can fire for an `ECallFn`. |
| 6 | Golden blast radius | **PASS (test green today).** Task 2's tracking alone touches ONE fixture (`smoke`); the item-3 `cgTmpSlots` bump re-blesses **every** `testdata/cg68k/*.s` golden (31 fixtures, all segments). |

---

## Item 1 — handoff coverage

### 1a. `cgStmt`'s SAssign scalar arm (cg68k.cla:12088–12092)

The check runs after `cgEmitStoreScalarAny(dst, src)` returns:

```
cgEmitStoreScalarAny(dst, irAssignSrc(s))          // cg68k.cla:12089
if cgIsHandleKind(dstKind) and cgLastTrackedOff != -1 {   // :12090
    cgHandoff(cgLastTrackedOff)
}
```

`cgEmitStoreScalarAny` (cg68k.cla:6161–6178) evaluates **src first**, then
the dst address:

```
cgExpr(src)                                  // :6164
if irExprKind(dst) == EVarRef { cgStoreScalarVar(dst); return }   // :6165-6168
... push D0; cgExprAddr(dst); pop; store     // :6170-6177
```

So for a non-`EVarRef` dst, `cgExprAddr(dst)` runs **after** src. That path
*can* birth a tracked temp: `cgExprAddr`→`cgIndexRefAddr` (:5977) →
`cgArrElemAddr` (:6000) / `cgListElemAddr`, both of which evaluate the index
expression (`cgCallRuntime(rnArrCheck, ...)` at :6014, whose `args[0]` is `irIndexRefI(e)` (:6009) → `cgExpr`).
Nothing resets `cgLastTrackedOff` on entry to `cgExpr` — the only resets are
the per-statement one in `cgStmt` (:12077) and module init (:1583) — so a
temp born during dst-address computation **stomps** the module var before
the check reads it.

**Why this is nevertheless not a double-release (UAF) risk, and why Task 2
does not make it one:** `lower.cla` never hands cg68k an `SAssign` whose dst
is a handle-kind `EFieldRef`/`EIndexRef` **and** whose src is a
tracked-temp-producing expression. Every counted (handle) store funnels
through `lowCountedStoreVal` (lower.cla:3104), which, for any source that is
not a bare `ExIdent` (lower.cla:3146 `if exprKind(srcAst) != ExIdent`),
materialises the source into a **synthetic local** first and emits the
sequence (lower.cla:3202–3226):

```
release(__storeN)
__storeN = <src>          <-- SAssign, dst is EVarRef  (early return, no stomp)
[retain(__storeN)]        (non-birth only)
release(dst)
dst = __storeN            <-- SAssign, src is EVarRef  (never tracked)
__storeN = 0
```

The `cgLastTrackedOff` handoff therefore always fires on the **`__storeN =
<src>`** statement, whose dst is an `EVarRef`, which takes
`cgEmitStoreScalarAny`'s early-return path at :6165–6168 (no dst address
computation at all). `lowReturn` does the same for a heap return type
(lower.cla:4006–4008, `lowNewReturnTemp`). Confirmed by the evidence doc's
own listing, which shows the real `__store182` slot.

**What IS still reachable (pre-existing, leak-only, unchanged by Task 2):**
the *other* direction — src untracked, dst address births a temp. E.g.
`arr[m.get(k).length] = t` where `arr: text[8]` — step 5 above
(`arr[idx] = __storeN`, src `EVarRef`, untracked) computes `idx`, whose
`map_get` allocates a tracked temp (cg68k.cla:7555) and sets
`cgLastTrackedOff` (:7575). The SAssign check then hands off *that* temp,
which nothing ever releases → leak. No fixture in-tree has this shape.

**Recommended hardening (cheap, safe, and it keeps Task 2's intent honest):**
latch and restore inside `cgEmitStoreScalarAny`, so the module var always
reflects **src**:

```clarus
func cgEmitStoreScalarAny(dst: int, src: int) {
    var sz: int
    var srcTracked: int          // NEW

    cgExpr(src)
    srcTracked = cgLastTrackedOff        // NEW: latch src's own verdict
    if irExprKind(dst) == EVarRef {
        cgStoreScalarVar(dst)
        return                            // (latch is a no-op on this path)
    }
    sz = cgSizeOf(irExprType(dst))
    a68Emit(OpMove, 4, AmDn, 0, 0, AmPreDec, 7, 0)
    cgExprAddr(dst)
    a68Emit(OpMove, 4, AmPostInc, 7, 0, AmDn, 0, 0)
    if sz == 1 { ... } else { ... }
    cgLastTrackedOff = srcTracked        // NEW: restore before returning
}
```

Emits zero extra instructions for every shape in the corpus (verified: no
`testdata/cg68k` fixture has a handle dst with a temp-birthing index), and
closes the leak above. **Not required** for Task 2's correctness — call it
optional hardening and let the controller decide.

### 1b. `cgReturnStmt` (cg68k.cla:11969–12014) — sufficient

```
cgExpr(x)                                        // :11992
rk = irtKind(irExprType(x))
if (rk == KText or ... KIntMap) and cgLastTrackedOff != -1 { cgHandoff(...) }  // :11994-11996
if cgStmtTmpOffs.count > 0 { cgStoreD0At(6, cgRetSaveOff, retT); saved = true } // :11997-12007
cgFreeStmtTmps()                                 // :12009
if saved { cgLoadD0At(6, saveOff, retT) }        // :12010
```

The check reads `cgLastTrackedOff` immediately after the single `cgExpr(x)`;
nothing runs in between. Traced against the two shapes Task 2 newly creates:

- `return f(g())`, `f: int` — `g`'s result is tracked, `rk` is not a handle
  kind, so no handoff; `cgStmtTmpOffs` is non-empty → D0 saved to
  `cgRetSaveOff`, `g`'s temp released, D0 reloaded. Correct.
- `return f(g())`, `f: text` — `cgCallFnScalar(f)` sets `cgLastTrackedOff`
  as its LAST action (see the ordering below), so it names `f`'s temp, not
  `g`'s; handoff of `f`'s temp; `g`'s temp still tracked → D0 save/release/
  reload. Correct.

(For a handle-typed return, `lowReturn` materialises into a synthetic
return temp anyway, so this arm's handoff is belt-and-braces there.)

### 1c. Element/property stores that are NOT `SAssign`

`m[k] = g()`, `lst[i] = g()`, `lst.push(g())`, `w.LogView.text = g()`,
`t.append(g())` all lower to an `SExprStmt` wrapping an intrinsic
(`lowIndexAssign`, lower.cla:4316; `lowListMethod`, :1826;
`lowWidgetSetAssign` → `IUiSetTextviewText`, :4233) — **not** `SAssign`.
Each was checked for host parity:

| shape | native arm | native handoff | host arm | host handoff | balanced after Task 2? |
|---|---|---|---|---|---|
| `lst.push(g())` / `unshift` |  `cgIntrListPushLike` :7222 | **yes**, :7236-7237 | `fpIntrCall4` IListPush :2952 (`fpCopyToTemp`+`fpHandoff` :2960-2963) | yes | yes — container takes the +1, no statement-end release |
| `lst[i] = g()` | `cgIntrListSet` :7389 | **yes**, :7411-7412 | cprint :3149 (`fpCopyToTemp`/`fpHandoff` :3170-3171) | yes | yes |
| `m[k] = g()` (map/sortedmap) | `cgIntrMapSet` :7484 | **yes**, :7507-7508 | cprint :3261 (:3283-3285) | yes | yes |
| `im[k] = g()` (intmap) | `cgIntrIntMapSet` :7735 | **yes**, :7762-7763 | same family | yes | yes |
| `m.get(k, g())` | `cgIntrMapGetDv` :7601 / `cgIntrIntMapGetDv` :7830 | **yes**, :7638-7642 / :7857-7858 | cprint IMapGetDv | yes | yes (lowering picks the `_birth` variant for a call `dv`, whose retain/release compare at :7666-7676 is already written for an owned `dv`) |
| `w.LogView.text = g()` | `IUiSetTextviewText` :8989-8998 | **no** (borrow — `rtUiWidgetSetText` copies) | cprint :3767-3778 | **no** | yes — statement-end release is exactly the host's behaviour |
| `t.append(g())` | `cgIntr2(e, rnTextAppendText, ...)` (:8276 family) | no (borrow) | cprint append arm | no | yes |

So every ownership-taking element/property store already hands off, and
every borrowing one already doesn't. **No consumer change is needed for
Task 2.**

**One pre-existing wrinkle worth fixing while in the area (leak-only, no
UAF):** the container arms read `cgLastTrackedOff` after evaluating the
*value*, but they evaluate the **receiver** (and, for intmap, the key)
first, and nothing clears the var in between. If the receiver produces a
tracked temp and the value does not, the handoff untracks the *receiver's*
temp. Today reachable only via `lst.first().push(x)`-style shapes; Task 2
makes it reachable via `makeList().push(x)` / `getMap()[k] = v`. It is not a
regression (those receivers leak today anyway, untracked), but it silently
prevents Task 2's fix from applying there. Minimal fix, 1 line per arm,
immediately before the value's `cgStoreElemAt`:

```clarus
cgLastTrackedOff = -1        // only the VALUE's own verdict may be handed off
cgStoreElemAt(vOff, elemT, a2e)
if cgLastTrackedOff != -1 { cgHandoff(cgLastTrackedOff) }
```

Sites: `cgIntrListPushLike` :7235, `cgIntrListSet` :7410, `cgIntrMapSet`
:7506, `cgIntrIntMapSet` :7761, `cgIntrMapGetDv` :7637, `cgIntrIntMapGetDv`
:7856. Changes no existing golden. **Recommended, not required.**

---

## Item 2 — no KRec sibling gap

`cgCallFnInto` (cg68k.cla:9867) handles every `cgRetNeedsHidden` return
(KRec/KStr/KErr). Contexts:

- **Argument** (`f(makeRec())`) — **balanced.** `cgPushArgs`' KStr/KRec
  branch (:9672) rejects `ECallFn` as addressable
  (`cgIsAddressableArgShape` :9768 — only `EVarRef`/`EFieldRef`/`EIndexRef`/
  `EStrConst`/`ui_value_at_ptr`), materialises via `cgMaterializeToTemp`
  (:5766) → `cgEmitStoreRec` → `cgCallFnInto`, and for a handle-bearing
  record schedules the release into `cgPendingArgReleases` with **no**
  retain (:9683-9686 — an `ECallFn`/`ENewRec` source is already +1).
  `cgFlushArgReleases` (:9562) walks it after the call.
- **Assignment** (`r = makeRec()`) — **balanced.** `cgEmitStoreRec`'s
  `ECallFn` arm (:6203-6206) calls `cgCallFnInto(src, dst)`: the callee
  writes straight into the destination, no intermediate temp exists, and
  lowering's own `lowCountedStoreRec` sequence releases dst's old value.
- **Discard** (`makeRec();`) — **balanced.** `cgCallFnScalar`'s
  `cgRetNeedsHidden` discard branch (:9820-9840) routes through
  `cgNewTrackedTmp` + `cgEmitStoreRec`/`cgEmitStoreErr`/`cgEmitStoreStr`, so
  `cgFreeStmtTmps` releases it.

**Hole found (out of scope, documented per the brief):** the
**receiver/operand** context. `makeRec().field` reaches
`cgFieldRefAddr` (:5870) → `cgExprAddr(irFieldRefX(e))` → `cgExprAddr`'s
generic fallback (:5855-5856) → `cgMaterializeToTemp(e)`, which allocates
with **`cgAllocTmpOff`** (:5772) — *untracked*. The record's handle fields
are +1 from the callee and are never released. The host lane balances the
same shape (`fpCallFn` materialises any handle-bearing KRec return into
`fpNewTrackedTmp`, cprint.cla:1548-1554), so this is the exact same
lane asymmetry this phase is fixing, one type-kind over. Not fixed here per
the spec ("Any KRec-return redesign beyond probe item 2's verification" is
out of scope). Suggested follow-up: `docs/TODO.md` entry — make
`cgMaterializeToTemp` use `cgNewTrackedTmp` when
`irExprKind(e) == ECallFn and cgNeedsRelease(irExprType(e))`.

**Second, smaller note (also out of scope):** `cgPendingArgReleases` entries
are *not* released on the abort path — `cgAbortCheckAfterCall` (:10055) runs
*before* `cgFlushArgReleases` in both `cgCallFnScalar` (:9854-9855) and
`cgCallFnInto` (:9887-9888), and `cgEmitAbortCheck` (:2385) only walks
`cgStmtTmpOffs`, never `cgPendingArgReleases`. An aborting callee therefore
leaks its caller's KRec argument temps. Pre-existing; unaffected by this
phase.

---

## Item 3 — pool headroom — **FAIL, bump required**

**Current value:** `const cgTmpSlots: int = 14` (cg68k.cla:1388).

**Sizing rules.** `cgEmitFunc` reserves exactly `cgTmpSlots` anonymous
4-byte A6 slots per function, below the named locals (cg68k.cla:5212-5218),
plus one dedicated `cgRetSaveOff` slot (:5225-5227), plus a **per-function**
big pool (`max(cgBigTmpFloor, cgFuncBigTmpNeed[f])` × 512 bytes,
:5243-5254 — the binary-files phase made the *big* pool per-function; the
small pool is still a flat const). `cgAllocTmpOff` (:4105) is a
per-statement bump allocator that never reuses a slot within a statement and
hard-aborts at the ceiling (:4111-4113); `cgStmt` resets
`cgStmtTmpNext = 0` at each statement (:12065). Both **tracked**
(`cgNewTrackedTmp`) and **untracked** (`cgAllocTmpOff`) small temps draw
from the same 14.

**Post-fix demand = today's demand + one slot per `cgNeedsRelease`-returning
user call in the statement.**

**Measured worst case in-tree — and it is already exactly at the ceiling.**
`clarusc/cprint.cla:3868` (`fpIntrCall4`'s `IUiCanvasRect` arm) is a single
statement with **14 text-concat nodes** (each `cgIntrTextConcat`/
`cgIntrTextConcatSl` takes a slot, cg68k.cla:7032/7062) **and 7
text-returning user calls** (`fpExpr`). That function is compiled by cg68k
in T1 today — `TestSelfEmit68k` emits `clarusc/main.cla` via `emit68k`, and
`fpIntrCall4` lands in segment 30 of the self-emit listing (verified).

Empirical proof (scratch probes, `build-run/clarusc emit68k`, tree
unmodified):

| probe | shape | result |
|---|---|---|
| 14 text concats in one statement | `f("a" + s×14)` | compiles |
| 15 text concats in one statement | `f("a" + s×15)` | `cg68k: too many tracked temps in one statement (Task 13 pool exhausted -- bump cgTmpSlots)` |
| exact mimic of cprint.cla:3868 (14 concats + 7 text-returning calls) | compiles today (calls untracked) |
| same mimic + 1 more concat (15) | aborts |

So one concat = one slot, and the real statement sits at **exactly 14/14**
today. After Task 2 it needs **21**. Without a bump, `TestSelfEmit68k`
(T1, `internal/cg68k`) fails outright with the ceiling abort — this is a
hard blocker for Task 2, not a nicety.

**Recommendation for Task 2: `const cgTmpSlots: int = 24`.**
Exact in-tree need is 21; 24 leaves margin for out-of-tree consumers
(68kbbs's `wrapText(stripKludges(postBody(id)), …)` family needs far less,
but its worst statement was not measured here). Cost: +40 bytes of A6 frame
per function (`cgTmpSlots × 4`), stack-only — no code-size change, no
segment-packing change beyond the LINK immediate. The `frameSize > 32767`
guard (:5271-5273) has ample headroom.

**Ceiling pin:** `testdata/cg68k/smalltmp_ceiling.cla` (and its `testdata/run`
twin) exercises exactly 14 concurrent small temps via 14 `nums.pop()` args
(`list of int` → untracked `cgAllocTmpOff`). A bump does **not** invalidate
it (it pins "≥14 works", not "==14"), but its golden `.s` will change with
every other golden (see item 6). If Task 2 wants the new ceiling pinned
too, the cheapest way is to extend that fixture — optional; the const's own
doc comment at :1379-1387 must be updated either way to record 21 as the
new observed need and where it came from.

---

## Item 4 — D0 clobber ordering in `cgCallFnScalar` — **PASS, no reorder needed**

**The hypothesised latent bug does not exist.** `cgFlushArgReleases`
(cg68k.cla:9562-9581) *can* emit JSRs (`cgEmitRecWalkCall` → `BSR
cg_release_<Rec>`), but it brackets the entire walk with a D0/D1 save/restore
pair:

```
if cgPendingArgReleases.count > 0 { MOVE.L D0,-(A7); MOVE.L D1,-(A7) }   // :9565-9568
   ... per-entry cgEmitRecWalkCall ...                                    // :9569-9573
if cgPendingArgReleases.count > 0 { MOVE.L (A7)+,D1; MOVE.L (A7)+,D0 }   // :9574-9577
```

That protection was added deliberately (its own doc comment, :9548-9561,
records the native-lane repro `readParamDocBody(makeNestedDoc()) != "nested"`).
So today's discard branch — which stores D0 *after* the flush
(:9855-9860) — stores the real return value, not garbage. Nothing else
between the call and the store touches D0 either: `cgCleanupStack` only
adjusts A7, and `cgAbortCheckAfterCall`'s release walk sits behind a
`BEQ`-skip and only executes on the branch-away path (`cgEmitAbortCheck`
:2396-2404).

**Abort-check snapshot: confirmed.** `cgEmitAbortCheck` (:2385) walks
`cgStmtTmpOffs` **at emission time** (a compile-time `while` loop emitting one
`cgReleaseAt` per currently-tracked slot, :2399-2402) and explicitly does
**not** clear the lists. Therefore registering the result *after*
`cgAbortCheckAfterCall` keeps the not-yet-written slot off **this** call's
own abort path (critical: `cgAllocTmpOff` hands out a bump-allocated slot
that still holds a previous statement's bytes — releasing it there would
release garbage), while every **later** abort check in the same statement
picks it up automatically, and the ordinary statement-end
`cgFreeStmtTmps` releases it on the fallthrough.

### Required ordering for Task 2 (pseudo-Clarus)

Replace `cgCallFnScalar`'s tail (cg68k.cla:9850-9860) with:

```clarus
    // param-abi phase, Task 6: cgSaveArgReleases/cgFlushArgReleases bracket
    // the push+call+cleanup span.
    savedReleases = cgSaveArgReleases()
    total = cgPushArgs(irCallFnArgsHead(e))
    cgCallFunc(fi)
    cgCleanupStack(total)
    cgAbortCheckAfterCall(fi)        // (1) emitted BEFORE the result is tracked:
                                     //     cgEmitAbortCheck snapshots
                                     //     cgStmtTmpOffs at emission time, and
                                     //     the slot below is not written yet.
    cgFlushArgReleases(savedReleases) // (2) safe for D0: this function saves and
                                     //     restores D0/D1 around its own walk
                                     //     (cg68k.cla:9565-9577).
    retType = irFuncRet(fi)
    if cgNeedsRelease(retType) {      // (3) was `e == cgDiscardExprIdx and ...`
                                     //     -- the discard branch FOLDS IN here;
                                     //     emitted bytes for a discarded call
                                     //     are unchanged.
        off = cgNewTrackedTmp(retType)
        cgStoreD0At(6, off, retType)  // (4) MOVE.L D0,off(A6) -- leaves D0 intact
                                     //     (cgStoreD0At, :3301), so every
                                     //     consumer still reads the result from
                                     //     D0 exactly as before.
        cgLastTrackedOff = off        // (5) LAST action, after every nested
                                     //     cgExpr in cgPushArgs, so the value
                                     //     always reflects THIS call's result,
                                     //     matching every cgIntr birth arm's
                                     //     own contract (:7051, :7331, :7575).
    }
}
```

Notes for the implementer:

- **No reload of D0 is needed** (the spec's sketch had "flush → reload"): the
  store lands after the flush, and `cgStoreD0At` does not disturb D0. Adding
  a reload would emit a dead instruction at every handle-returning call site.
- `cgDiscardExprIdx` is **no longer consulted** in this function's scalar
  path. For a bare `makeStr();` statement the emitted instructions are
  byte-identical to today (`cgNewTrackedTmp` + `cgStoreD0At`); only the new
  `cgLastTrackedOff` assignment is added, and it is compile-time state
  nothing reads in that context.
- The `cgRetNeedsHidden` (>4-byte return) discard branch at :9820-9840 stays
  exactly as-is — it is on the early-return path and cannot co-fire.
- The `retType` local and the `off` local already exist in the function's
  `var` block; no new declarations are needed.

---

## Item 5 — double-track audit

Every `cgNewTrackedTmp` call site in cg68k.cla, with its gate:

| line | function | gate | interaction with Task 2 |
|---|---|---|---|
| 7032 | `cgIntrTextConcat` | always (text `+`) | none — `EIntr`, sets `cgLastTrackedOff` :7051 |
| 7062 | `cgIntrTextConcatSl` | always | none (:7074) |
| 7083 | `cgIntrTextOfStr` | always | none (:7093) |
| 7115 | `cgIntrTextTextAt` | always | none (:7129) |
| 7281 | `cgIntrListPopLike` | `e == cgDiscardExprIdx and cgNeedsRelease(elemT)` | none — `EIntr`, never `ECallFn`; **stays** |
| 7317 | `cgIntrListFirstLast` | `cgIsHandleKind(k)` | none (:7331) |
| 7454 | `cgIntrListClone` | always | none (:7467) |
| 7555 | `cgIntrMapGet` | `cgIsHandleKind(k)` | none (:7575) |
| 7646 | `cgIntrMapGetDv` | `cgIsHandleKind(k)` | none (:7678) |
| 7804 | `cgIntrIntMapGet` | `cgIsHandleKind(k)` | none (:7820) |
| 7862 | `cgIntrIntMapGetDv` | `cgIsHandleKind(k)` | none (:7890) |
| 9741 | `cgPushArgs` scalar arm | `sz == 4 and ak == EIntr and lowIntrIsOwningContainerRead(...) and cgNeedsRelease(t)` | **stays** — `ak == EIntr` excludes `ECallFn` outright (cg68k.cla:9739), so it can never double-track a call result |
| 9828 | `cgCallFnScalar` KRec/KStr/KErr discard | inside the `cgRetNeedsHidden` early-return | **untouched** |
| 9858 | `cgCallFnScalar` scalar discard | `e == cgDiscardExprIdx and cgNeedsRelease(retType)` | **folds into** the new unconditional tracking (item 4) |

No site can register the same value twice. `cgHandoff` (:4176) is
idempotent (a no-op if the offset isn't in the list), so the container-arm
handoffs remain safe.

**pop/shift as operand/receiver — host leaks it too, so it is out of scope.**
`lst.pop().length` / `lst.pop() + x`: native leaves the value untracked
(`cgIntrListPopLike` :7278-7283, tracked only in the discard case), and the
host does exactly the same — cprint.cla:3036-3053 materialises into an
*untracked* `fpNewTmp` and then calls `fpHandoff(t)` unconditionally
("Never auto-free/release t"). Both lanes leak identically; the Task 8
fix covered only the **call-argument** position (native :9739-9743, host
`fpCallFnArg` :1425-1431). Report-only, as the brief asks.

---

## Item 6 — golden blast radius

**`go test ./internal/cg68k -count=1` → `ok clarus/internal/cg68k 3.535s`
(PASS on the unmodified tree).** `TestSelfEmit68k` runs inside that package
and passes (58 CODE segments).

**Fixtures with a handle-returning user call: exactly one.** A scan of all
31 `testdata/cg68k/*.cla` fixtures for `func NAME(...): text|list of|map
of|sortedmap of|intmap of` found a single match:

- `testdata/cg68k/smoke.cla:283` `func other(): list of int`, called once at
  `smoke.cla:278` as `b = other()` (assignment context).

That call is currently untracked; after Task 2 it gains one
`MOVE.L D0,off(A6)` (`cgStoreD0At`) before the handoff, so **`smoke.s` (and
whichever `smoke.segN.s` that function packs into) must be re-blessed** for
Task 2's change alone. No fixture consumes a handle-returning call as an
argument/operand/receiver, so no fixture will show a *new release*; Task 2
needs its own regression fixture (the spec's `direct()`/`viaLocal()` listing
test) to prove the fix at all.

**Task 3 (`IUiGetTextviewText`) touches no `testdata/cg68k` fixture** — no
fixture reads a textview's `.text` (grep for `.text` in
`testdata/cg68k/*.cla`: no hits). Its blast radius is the gated native UI
goldens (`testdata/uisnaps`, `texteditor`/`bookmarks` scenarios) and the
`toolbox` suite, i.e. T2, not T1.

**The item-3 `cgTmpSlots` bump re-blesses EVERYTHING.** The small pool is
laid out below the named locals (cg68k.cla:5212-5218) and above
`cgRetSaveOff`/the big pool/the deep-release scratch, so raising the const
changes every function's `LINK A6,#-N` immediate **and** every temp/big/deep
A6 displacement. All 31 fixtures × every segment file
(`testdata/cg68k/*.s`, `*.seg2.s`, …) will differ. `internal/cg68k`'s
`image_test.go`/`segment_test.go` may also see shifted sizes. Plan the
re-bless as one mechanical step, and keep it in its own commit so the
Task 2 semantic diff stays readable.

---

## Reproduction commands (all read-only against the repo)

```sh
go test ./internal/cg68k -count=1                       # PASS today
cc -O1 -Iruntime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/p.bin /tmp/probe14.cla   # compiles
build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/p.bin /tmp/probe15.cla   # ceiling abort
build-run/clarusc emit68k --rtdir runtime/clarus/ -o /tmp/self.bin --listing clarusc/main.cla
grep -l fpIntrCall4 /tmp/self.seg*.s                    # -> seg30: the 14/14 statement is emitted in T1
```

`probe14.cla` / `probe15.cla` are N-way text-concat statements
(`n = f("a" + s + s + ...)`); the mimic probe reproduces
`cprint.cla:3868`'s shape verbatim (14 concats + 7 text-returning calls).
Both live in the session scratchpad, not the repo.
