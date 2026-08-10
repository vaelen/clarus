# Datetime Stdlib + Compiler Instrumentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Three date/time builtins (`now`/`dateTimeStr`/`durationStr`) backed by a conditionally-spliced runtime module on all three lanes, plus always-on per-phase `TickCount()` progress logging in clarusc's emit68k path.

**Architecture:** Builtins declared in check.cla lower to ordinary named IR calls into `runtime/clarus/datetime.cla` (+ one per-lane `rtNow` variant file); the only platform code is the clock/`Secs2Date` C glue (`rt_ext_*`) and one `peekl` of the `Time` global. Instrumentation lives in drive.cla/cg68k.cla behind a `feProgress` front-end seam, emitting **only when `want68k`** (the C `emit` lane and check-only/appinfo modes must stay byte-silent — byte-exact harness goldens depend on it).

**Tech Stack:** Clarus (clarusc + runtime .cla), C (host + Retro68 rt_ext glue), Go test harness.

**Spec:** `docs/superpowers/specs/2026-08-10-datetime-instrumentation-design.md`

## Global Constraints

- **Two-stage snapshot**: Tasks 1–8 must not use the new builtins inside `clarusc/*.cla` (the committed snapshot can't compile them until regenerated in Task 5). Instrumentation (Task 9) comes only after the Stage-A snapshot regen.
- **Progress lines only when `want68k`**: never in check-only, `emit`, or `appinfo` modes. `internal/selfhost/diag_test.go` (byte-exact emit-mode goldens), `internal/reftest` + `internal/claruscboot` (zero-output check mode), `internal/emitui/appinfo_test.go` (byte-exact appinfo stdout) all break otherwise. Host progress goes to stderr (`log()`), never stdout.
- **Emitted forks for programs not using datetime builtins stay byte-identical** (T1's emitui/frozen-scenario goldens prove this every run).
- **cg68k string budget**: in any code that will be compiled native (runtime modules, testsuite, clarusc itself): bind each string concatenation to a variable before passing it to a function; at most ~2 `+` per statement.
- **datetime is a plain `int`**: unsigned Mac-epoch seconds (Jan 1 1904 00:00:00 **local**) in a signed int; modern values are negative; never do calendar math in Clarus — the ROM/glue does it.
- **Verified trap facts (from `Retro68/InterfacesAndLibraries/Interfaces/` `CIncludes/DateTimeUtils.h` + `AIncludes/DateTimeUtils.a`)**: `_ReadDateTime` = `0xA039` (A0=&secs, OSErr→D0); `_SecondsToDate` = `0xA9C6` (D0=secs, A0=&DateTimeRec, no result); `_DateToSeconds` = `0xA9C7` (A0=&DateTimeRec, secs→D0); `_SetDateTime` = `0xA03A` (D0=secs, OSErr→D0); `GetDateTime` is NOT a trap (inline `MOVE.L $020C,(A0)` — the low-memory `Time` global). `Secs2Date`/`Date2Secs` are register-based **despite bit 11 being set** — a documented exception to the reference's bit-11 rule (clarusc does not enforce the rule; verified).
- Unix→Mac epoch offset: **2,082,844,800** seconds (24,107 days). 1904-01-01 was a **Friday** (`dayOfWeek` 1=Sunday ⇒ 6).
- Before editing any file with the Edit tool, confirm it has no raw high-bit (MacRoman) bytes: `LC_ALL=C grep -n '[^ -~\t]' FILE` — if it hits, use `LC_ALL=C sed` instead (see memory note). All files this plan touches are ASCII today.
- Run from the worktree root `/Users/andrew/repos/clarus/.claude/worktrees/native-perf-findings`. Commit after every task.
- Progress ledger: `.superpowers/sdd/2026-08-10-datetime-instrumentation/progress.md`.

---

### Task 1: C glue — host TickCount + Dt* twins, Retro68 twins + catalog wrappers

**Files:**
- Modify: `runtime/host/rt_ext_host.inc` (append at end, before the closing `#endif`)
- Modify: `runtime/mac/rt_ext_mac.inc` (append near `rt_ext_TickCount`, line ~1028)

**Interfaces:**
- Produces C symbols: `rt_ext_TickCount` (host — mac already has it), `rt_ext_DtReadDateTime`, `rt_ext_DtSecs2Date` (both host and mac), and mac-only catalog wrappers `rt_ext_ReadDateTime`, `rt_ext_SecondsToDate`, `rt_ext_DateToSeconds`, `rt_ext_SetDateTime`. Task 3's `datetime_c.cla` calls the `Dt*` pair; Task 9's drive.cla `TickCount` extern needs the host `rt_ext_TickCount`.
- Host catalog wrappers (`rt_ext_ReadDateTime` etc.) are deliberately NOT added — nothing host-side calls the catalog names (the toolbox suite is emulator-only). If `internal/testsuite/catalog_test.go` turns out to link (not just compile) a host program calling them, add host aliases then.

- [ ] **Step 1: Append to `runtime/host/rt_ext_host.inc`** (check `rt.c` includes `<time.h>`; if not, add the include next to the file's other system includes):

```c
/* ---- Date/time (2026-08-10 datetime-instrumentation spec) ---- */

/* rt_ext_TickCount: host twin of _TickCount (0xA975) -- 60ths of a second
 * on an arbitrary monotonic zero point (the Mac's is boot; ours is
 * CLOCK_MONOTONIC's), so deltas behave identically. First host glue for
 * this trap: before this, a host build composing toolbox/events.cla and
 * calling TickCount() failed to link. */
int32_t rt_ext_TickCount(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int32_t)(uint32_t)((uint32_t)ts.tv_sec * 60u + (uint32_t)(ts.tv_nsec / 16666667L));
}

/* Mac epoch (1904-01-01 00:00:00 LOCAL) vs Unix epoch (1970-01-01 UTC):
 * 24,107 days. The Mac clock stores local-time seconds, so the host's
 * current UTC offset (tm_gmtoff) is applied. */
#define RT_MAC_EPOCH_DELTA 2082844800UL

static uint32_t rt_dt_now_mac(void) {
    time_t now = time(NULL);
    struct tm tmv;
    localtime_r(&now, &tmv);
    return (uint32_t)((unsigned long)now + (unsigned long)tmv.tm_gmtoff + RT_MAC_EPOCH_DELTA);
}

/* rt_ext_DtReadDateTime: C-lane twin of _ReadDateTime (0xA039) -- writes
 * current Mac-epoch local seconds through the caller's pointer, returns
 * noErr. Pointee is datetime_c.cla's DtSecsBox { secs: int }. */
int32_t rt_ext_DtReadDateTime(void *t) {
    *(int32_t *)t = (int32_t)rt_dt_now_mac();
    return 0;
}

/* rt_ext_DtSecs2Date: C-lane twin of _SecondsToDate (0xA9C6): unsigned
 * Mac-epoch local seconds -> DateTimeRec's seven int16 fields (year,
 * month 1-12, day 1-31, hour 0-23, minute, second, dayOfWeek 1=Sunday).
 * Hinnant civil-from-days shifted so day 0 = 1904-01-01 (a Friday).
 * Pinned against the ROM lane by the core suite's shared test vectors. */
void rt_ext_DtSecs2Date(int32_t secs, void *d) {
    uint32_t u = (uint32_t)secs;
    uint32_t days = u / 86400u;
    uint32_t rem = u % 86400u;
    int16_t *f = (int16_t *)d;
    long z = (long)days + 695361L; /* 719468 (Hinnant, 1970-based) - 24107 */
    long era = z / 146097L;
    long doe = z - era * 146097L;
    long yoe = (doe - doe / 1460L + doe / 36524L - doe / 146096L) / 365L;
    long y = yoe + era * 400L;
    long doy = doe - (365L * yoe + yoe / 4L - yoe / 100L);
    long mp = (5L * doy + 2L) / 153L;
    long day = doy - (153L * mp + 2L) / 5L + 1L;
    long month = mp < 10L ? mp + 3L : mp - 9L;
    if (month <= 2L) y = y + 1L;
    f[0] = (int16_t)y;
    f[1] = (int16_t)month;
    f[2] = (int16_t)day;
    f[3] = (int16_t)(rem / 3600u);
    f[4] = (int16_t)((rem % 3600u) / 60u);
    f[5] = (int16_t)(rem % 60u);
    f[6] = (int16_t)((days + 5u) % 7u + 1u); /* day 0 = Friday = 6 */
}
```

- [ ] **Step 2: Append to `runtime/mac/rt_ext_mac.inc`** (next to `rt_ext_TickCount`, same one-liner style; the file's existing includes already cover the Toolbox — verify `DateTimeUtils.h`/`OSUtils.h` reachable, add include if the compile in Step 4 says otherwise):

```c
int32_t rt_ext_DtReadDateTime(void *t) { return (int32_t)ReadDateTime((unsigned long *)t); }
void rt_ext_DtSecs2Date(int32_t secs, void *d) { SecondsToDate((unsigned long)secs, (DateTimeRec *)d); }
int32_t rt_ext_ReadDateTime(void *t) { return (int32_t)ReadDateTime((unsigned long *)t); }
void rt_ext_SecondsToDate(int32_t secs, void *d) { SecondsToDate((unsigned long)secs, (DateTimeRec *)d); }
int32_t rt_ext_DateToSeconds(void *d) { unsigned long s; DateToSeconds((DateTimeRec *)d, &s); return (int32_t)s; }
```

(No `SetDateTime` anywhere — the spec's out-of-scope list excludes it explicitly.)

- [ ] **Step 3: Write the host-glue test probe** `testdata/lowlevel/dtglueprobe.cla` (uses only OLD-snapshot features — externs, no new builtins):

```rust
// dtglueprobe.cla: link/behavior probe for Task 1's host rt_ext glue
// (rt_ext_TickCount / rt_ext_DtReadDateTime / rt_ext_DtSecs2Date).
// Declares the same extern shapes datetime_c.cla will use (Task 3).
app DtGlueProbe {
    id: "CLDG"
}

extern record DtSecsBox {
    secs: int
}

extern record DtDateTimeRec {
    year: word
    month: word
    day: word
    hour: word
    minute: word
    second: word
    dayOfWeek: word
}

external func TickCount(): int = trap 0xA975
external func DtReadDateTime(t: ptr): int = trap 0xA039 reg(a0: t) ret d0
external func DtSecs2Date(secs: int, d: ptr) = trap 0xA9C6 reg(d0: secs, a0: d)

on App.startCLI(args: list of string) {
    var box: DtSecsBox
    var rec: DtDateTimeRec
    var t1: int
    var t2: int

    t1 = TickCount()
    t2 = TickCount()
    if t2 < t1 {
        alert("FAIL ticks went backwards")
        quit 1
    }
    DtReadDateTime(box)
    if box.secs >= 0 {
        alert("FAIL now not in unsigned upper half")
        quit 1
    }
    DtSecs2Date(box.secs, rec)
    if rec.month < 1 or rec.month > 12 {
        alert("FAIL month out of range")
        quit 1
    }
    if rec.year < 2026 {
        alert("FAIL year before 2026")
        quit 1
    }
    DtSecs2Date(0, rec)
    if rec.year != 1904 or rec.month != 1 or rec.day != 1 or rec.dayOfWeek != 6 {
        alert("FAIL epoch decode wrong")
        quit 1
    }
    alert("OK")
}
```

- [ ] **Step 4: Run the probe on host**

Run: `scripts/clarus-run.sh testdata/lowlevel/dtglueprobe.cla`
Expected: `OK`, exit 0. (This exercises the old snapshot + new glue: link proof for all three host symbols, plus epoch/dayOfWeek correctness.)

- [ ] **Step 5: Compile-check the mac glue** — the Retro68 lane compiles `rt_ext_mac.inc` only inside a full mac build; the cheap check is T1's existing lanes plus a syntax eyeball. Run `scripts/test-task.sh` (T1) — expected green (nothing consumes the new symbols yet; this catches host-side C breakage in every lane that links rt.c).

- [ ] **Step 6: Commit**

```bash
git add runtime/host/rt_ext_host.inc runtime/mac/rt_ext_mac.inc testdata/lowlevel/dtglueprobe.cla
git commit -m "feat: date/time rt_ext glue (host TickCount+Dt twins; mac Dt twins + Date-Time catalog wrappers)"
```

---

### Task 2: Toolbox catalog — Date-Time Utilities in `toolbox/osutils.cla`

**Files:**
- Modify: `toolbox/osutils.cla` (append after the existing four externs)
- Modify: `docs/clarus-language-reference.md` (bit-11 rule footnote, ~line 1539)
- Modify: `docs/clarus-toolbox-cookbook.md` (short Date-Time worked example)

**Interfaces:**
- Produces catalog declarations: `extern record DateTimeRec` (fields `year month day hour minute second dayOfWeek`, all `word`), `ReadDateTime(time: ptr): int`, `SecondsToDate(secs: int, d: ptr)`, `DateToSeconds(d: ptr): int`, `SetDateTime(time: int): int`. Task 7's toolbox case consumes `DateTimeRec`/`SecondsToDate`/`DateToSeconds` by these exact names.

- [ ] **Step 1: Append to `toolbox/osutils.cla`:**

```rust
// ---- Date-Time Utilities (IM II "Date and Time Operations") ----
//
// Provenance: declarations verified against Interfaces/CIncludes/
// DateTimeUtils.h and Interfaces/AIncludes/DateTimeUtils.a (2026-08-10
// datetime-instrumentation phase). GetDateTime is deliberately ABSENT:
// it is not a trap at all -- Apple's glue is TWOWORDINLINE(0x20B8,
// 0x020C), a MOVE.L of the low-memory Time global ($020C) through the
// caller's pointer -- and Clarus programs should call the builtin now()
// instead, which performs exactly that read on the native lane.
//
// _SecondsToDate/_DateToSeconds are the documented EXCEPTION to the
// reference's bit-11 convention rule: Toolbox-range trap words (bit 11
// set) with REGISTER-based contracts. AIncludes/DateTimeUtils.a is
// explicit ("secs => D0, d => A0" over OPWORD $A9C6), and the CIncludes
// pragma (#pragma parameter SecondsToDate(__D0, __A0), ONEWORDINLINE)
// shows no glue words at all -- the raw trap takes registers.

extern record DateTimeRec {
    year: word
    month: word
    day: word
    hour: word
    minute: word
    second: word
    dayOfWeek: word
}

// _ReadDateTime (0xA039): re-reads the battery-backed clock chip
// (slow, serial) and rewrites the Time global; boot-time resync, not a
// routine time read. A0 = VAR secs (unsigned long), OSErr <= D0.
external func ReadDateTime(time: ptr): int = trap 0xA039 reg(a0: time) ret d0

// _SecondsToDate / Secs2Date (0xA9C6): unsigned seconds => D0,
// DateTimeRec pointer => A0, no result. Fills year (full year), month
// 1-12, day 1-31, hour 0-23, minute, second, dayOfWeek (1 = Sunday).
external func SecondsToDate(secs: int, d: ptr) = trap 0xA9C6 reg(d0: secs, a0: d)

// _DateToSeconds / Date2Secs (0xA9C7): DateTimeRec pointer => A0,
// unsigned seconds <= D0. Tolerates out-of-range fields (month 13 rolls
// into the next year) -- the ROM's own date arithmetic hook.
external func DateToSeconds(d: ptr): int = trap 0xA9C7 reg(a0: d) ret d0
```

(`SetDateTime` is deliberately absent — the spec's out-of-scope list names it. Writing the clock is nothing a Clarus program needs; if it ever is, `0xA03A` takes D0 = seconds, OSErr <= D0.)

- [ ] **Step 2: Run the catalog T1 check**

Run: `go test ./internal/testsuite -run TestCatalog -count=1 -v` (use the actual test name from `internal/testsuite/catalog_test.go` — grep for `func Test` there first)
Expected: PASS. If a host-link failure appears for the new catalog names, add host aliases in `rt_ext_host.inc` delegating to the `Dt*`/`rt_dt_now_mac` helpers from Task 1 and note it in the commit message.

- [ ] **Step 3: Add the bit-11 footnote** to `docs/clarus-language-reference.md` — locate the paragraph at ~line 1539 (`A trap word's bit 11 ... is the normative test`) and append one sentence to it:

```
Two catalogued exceptions exist: `_SecondsToDate` (`0xA9C6`) and `_DateToSeconds` (`0xA9C7`) carry Toolbox-range trap words yet are register-based (Apple's own `DateTimeUtils.a` gives `secs => D0, d => A0`; Inside Macintosh II documents both as register-based), so their declarations use `reg` despite bit 11 being set — the bit-11 test is the rule, these two are the known exceptions.
```

- [ ] **Step 4: Add a short cookbook section** to `docs/clarus-toolbox-cookbook.md` following its existing worked-example format: transcribing `SecondsToDate` from the pragma+inline evidence (quote the `#pragma parameter SecondsToDate(__D0, __A0)` / `ONEWORDINLINE(0xA9C6)` pair, show the resulting Clarus decl, and point at the bit-11 exception note). Keep it ~20 lines; mirror the style of an existing example in that doc.

- [ ] **Step 5: T1**

Run: `scripts/test-task.sh`
Expected: green.

- [ ] **Step 6: Commit**

```bash
git add toolbox/osutils.cla docs/clarus-language-reference.md docs/clarus-toolbox-cookbook.md
git commit -m "feat: Date-Time Utilities in the toolbox catalog (DateTimeRec + 4 traps; bit-11 exception documented)"
```

---

### Task 3: Runtime modules — `datetime.cla` + per-lane `rtNow` variants

**Files:**
- Create: `runtime/clarus/datetime.cla`
- Create: `runtime/clarus/datetime_68k.cla`
- Create: `runtime/clarus/datetime_c.cla`
- Create: `testdata/lowlevel/dtmodprobe.cla` (test)

**Interfaces:**
- Produces Clarus functions: `rtNow(): int`, `rtDateTimeStr(t: int): string`, `rtDurationStr(secs: int): string`. Task 4's lower.cla arms create IR calls to exactly these names. `datetime.cla` holds `rtDateTimeStr`/`rtDurationStr` (+ private `dtTwoDigit`/`dtIntToStr` helpers, `DtDateTimeRec` record, `DtSecs2Date` extern); each variant file holds its lane's `rtNow`.
- Consumes: Task 1's `rt_ext_DtReadDateTime`/`rt_ext_DtSecs2Date` (C lanes only).

- [ ] **Step 1: Create `runtime/clarus/datetime.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// datetime.cla: the date/time runtime backing the now()/dateTimeStr()/
// durationStr() builtins (2026-08-10 datetime-instrumentation spec).
// Conditionally spliced by drive.cla only when a program calls one of
// the three builtins (check.cla's usesDateTime flag), together with
// exactly ONE per-lane rtNow variant: datetime_68k.cla (native 68k --
// reads the low-memory Time global) or datetime_c.cla (C lanes --
// rt_ext glue).
//
// A datetime is a plain int: seconds since the Mac epoch (Jan 1 1904,
// 00:00:00, LOCAL time), the raw value the Toolbox clock stores. The
// count is UNSIGNED at the Toolbox level and crossed 2^31 in 1972, so
// every realistic clock reading is negative as a Clarus int; all
// calendar decomposition happens in the real Secs2Date trap (native
// lane) or its C glue twin rt_ext_DtSecs2Date -- never in Clarus
// arithmetic.
//
// DtDateTimeRec/DtSecs2Date are module-private twins of the public
// toolbox/osutils.cla catalog declarations (DateTimeRec/SecondsToDate):
// a runtime module cannot reference user-composable catalog files, the
// same reason ui.cla privately declares UiTickCount alongside the
// catalog's TickCount. Extern dedup keeps a program composing both safe
// (testdata/lowlevel/externdedup.cla pins byte-identical dedup).

extern record DtDateTimeRec {
    year: word
    month: word
    day: word
    hour: word
    minute: word
    second: word
    dayOfWeek: word
}

// _SecondsToDate / Secs2Date (0xA9C6): unsigned seconds => D0,
// DateTimeRec pointer => A0, no result. Register-based despite bit 11
// (see toolbox/osutils.cla's Date-Time provenance block).
external func DtSecs2Date(secs: int, d: ptr) = trap 0xA9C6 reg(d0: secs, a0: d)

// dtTwoDigit: zero-padded two-digit decimal field (callers guarantee
// 0 <= v <= 99).
func dtTwoDigit(v: int): string {
    var s: string

    s = s + char(v / 10 + int('0'))
    s = s + char(v mod 10 + int('0'))
    return s
}

// dtIntToStr: non-negative decimal conversion -- the module's own copy
// of the proven rtUiTestIntToStr shape (uitest.cla): numToStr is
// compiler-internal and unavailable to runtime modules, and the
// codebase's convention is one copy per splice (uitest/uiscript/kit all
// carry one).
func dtIntToStr(n: int): string {
    var digits: char[12]
    var count: int
    var v: int
    var s: string
    var i: int

    count = 0
    v = n
    while v > 0 {
        digits[count] = char(v mod 10 + int('0'))
        v = v / 10
        count = count + 1
    }
    if count == 0 {
        digits[0] = '0'
        count = 1
    }
    i = count - 1
    while i >= 0 {
        s = s + digits[i]
        i = i - 1
    }
    return s
}

// rtDateTimeStr backs dateTimeStr(t): "mm-dd-yy HH:MM:SS", zero-padded,
// 24-hour clock, two-digit year. The unsigned decomposition is entirely
// DtSecs2Date's; the fields come back as small positive ints.
func rtDateTimeStr(t: int): string {
    var rec: DtDateTimeRec
    var s: string

    DtSecs2Date(t, rec)
    s = dtTwoDigit(rec.month)
    s = s + "-"
    s = s + dtTwoDigit(rec.day)
    s = s + "-"
    s = s + dtTwoDigit(rec.year mod 100)
    s = s + " "
    s = s + dtTwoDigit(rec.hour)
    s = s + ":"
    s = s + dtTwoDigit(rec.minute)
    s = s + ":"
    s = s + dtTwoDigit(rec.second)
    return s
}

// rtDurationStr backs durationStr(secs): "Xh Ym Zs" with units above the
// highest nonzero unit omitted ("1h 0m 5s", "30m 5s", "45s", "0s");
// seconds always shown; negative input is "-" + the absolute form.
func rtDurationStr(secs: int): string {
    var s: string
    var v: int
    var h: int
    var m: int
    var sec: int
    var part: string

    v = secs
    if v < 0 {
        s = "-"
        v = -v
    }
    h = v / 3600
    m = (v mod 3600) / 60
    sec = v mod 60
    if h > 0 {
        part = dtIntToStr(h)
        s = s + part
        s = s + "h "
    }
    if h > 0 or m > 0 {
        part = dtIntToStr(m)
        s = s + part
        s = s + "m "
    }
    part = dtIntToStr(sec)
    s = s + part
    s = s + "s"
    return s
}
```

- [ ] **Step 2: Create `runtime/clarus/datetime_68k.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// datetime_68k.cla: the native-68k rtNow -- reads the low-memory Time
// global ($020C: unsigned seconds since 1904, local time) directly, the
// same single MOVE.L Apple's own GetDateTime glue performs
// (TWOWORDINLINE 0x20B8, 0x020C; CIncludes/DateTimeUtils.h). Time is
// maintained by the one-second interrupt, so this read never touches
// the clock chip. Spliced (with datetime.cla) only for want68k programs
// that use a datetime builtin; datetime_c.cla is the C-lane twin.

func rtNow(): int {
    return peekl(ptr(0x020C))
}
```

- [ ] **Step 3: Create `runtime/clarus/datetime_c.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// datetime_c.cla: the C-lane rtNow. The extern renders as
// rt_ext_DtReadDateTime (runtime/host/rt_ext_host.inc: host clock
// converted UTC->local and shifted to the Mac epoch;
// runtime/mac/rt_ext_mac.inc: the real ReadDateTime). The declaration
// is the truthful _ReadDateTime contract (0xA039: A0 = VAR secs, OSErr
// <= D0) even though this module is never spliced on the native lane,
// so the trap word is never emitted -- datetime_68k.cla is the native
// twin (a direct Time-global read, cheaper than the chip resync this
// trap would perform).

extern record DtSecsBox {
    secs: int
}

external func DtReadDateTime(t: ptr): int = trap 0xA039 reg(a0: t) ret d0

func rtNow(): int {
    var box: DtSecsBox

    DtReadDateTime(box)
    return box.secs
}
```

- [ ] **Step 4: Write the module probe** `testdata/lowlevel/dtmodprobe.cla` — composes the modules POSITIONALLY as user code (legal: they only become "runtime" when spliced), so this needs no compiler wiring:

```rust
// dtmodprobe.cla: Task 3 probe -- composes runtime/clarus/datetime.cla +
// datetime_c.cla positionally (host lane) and drives rtDateTimeStr/
// rtDurationStr/rtNow directly with the spec's fixed vectors. The same
// vectors reappear as core-suite cases in Task 6; this probe exists so
// the modules are proven BEFORE the builtin wiring (Task 4) lands.
app DtModProbe {
    id: "CLDM"
}

on App.startCLI(args: list of string) {
    var t: int
    var s: string

    s = rtDurationStr(0)
    if s != "0s" {
        alert("FAIL durationStr(0)")
        quit 1
    }
    s = rtDurationStr(45)
    if s != "45s" {
        alert("FAIL durationStr(45)")
        quit 1
    }
    s = rtDurationStr(1805)
    if s != "30m 5s" {
        alert("FAIL durationStr(1805)")
        quit 1
    }
    s = rtDurationStr(3605)
    if s != "1h 0m 5s" {
        alert("FAIL durationStr(3605)")
        quit 1
    }
    s = rtDurationStr(176520)
    if s != "49h 2m 0s" {
        alert("FAIL durationStr(176520)")
        quit 1
    }
    s = rtDurationStr(-45)
    if s != "-45s" {
        alert("FAIL durationStr(-45)")
        quit 1
    }
    s = rtDateTimeStr(0)
    if s != "01-01-04 00:00:00" {
        alert("FAIL dateTimeStr(0)")
        quit 1
    }
    s = rtDateTimeStr(86399)
    if s != "01-01-04 23:59:59" {
        alert("FAIL dateTimeStr(86399)")
        quit 1
    }
    s = rtDateTimeStr(5097600)
    if s != "02-29-04 00:00:00" {
        alert("FAIL dateTimeStr(5097600)")
        quit 1
    }
    s = rtDateTimeStr(2147483647)
    if s != "01-19-72 03:14:07" {
        alert("FAIL dateTimeStr(2^31-1)")
        quit 1
    }
    t = -2147483647
    t = t - 1
    s = rtDateTimeStr(t)
    if s != "01-19-72 03:14:08" {
        alert("FAIL dateTimeStr(2^31)")
        quit 1
    }
    s = rtDateTimeStr(-444896896)
    if s != "01-01-26 00:00:00" {
        alert("FAIL dateTimeStr(2026-01-01)")
        quit 1
    }
    t = rtNow()
    if t >= 0 {
        alert("FAIL rtNow not in unsigned upper half")
        quit 1
    }
    if t < -444896896 {
        alert("FAIL rtNow before 2026")
        quit 1
    }
    alert("OK")
}
```

(If the parser rejects a bare negative literal like `-444896896` in comparison position, bind it via the same `t = -2147483647; t = t - 1` two-step pattern and note it.)

- [ ] **Step 5: Run the probe** (multi-file compose — `clarus-run.sh` takes one file; use the compose recipe):

```bash
cc -O1 -I runtime/host -o build-run/clarusc-t3 clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc-t3 emit --rtdir runtime/clarus/ -o /tmp/dtmod.c \
    testdata/lowlevel/dtmodprobe.cla runtime/clarus/datetime.cla runtime/clarus/datetime_c.cla
cc -O1 -I runtime/host -o /tmp/dtmod /tmp/dtmod.c runtime/host/rt.c
/tmp/dtmod
```

Expected: `OK`, exit 0.

- [ ] **Step 6: Check the ClarusC.APPL bake list** — `scripts/build-clarusc-mac.sh` (and any caller constructing `--bake` flags, e.g. `internal/mactest/macresident_test.go` / `snow_test.go`): if the runtime file list is a glob of `runtime/clarus/*.cla`, nothing to do; if hardcoded, add the three new files. Record which it was in the ledger.

- [ ] **Step 7: T1** — `scripts/test-task.sh`, expected green (modules aren't spliced by anything yet).

- [ ] **Step 8: Commit**

```bash
git add runtime/clarus/datetime.cla runtime/clarus/datetime_68k.cla runtime/clarus/datetime_c.cla testdata/lowlevel/dtmodprobe.cla
git commit -m "feat: datetime runtime module + per-lane rtNow variants (vectors host-proven)"
```

---

### Task 4: Compiler wiring — builtins, `usesDateTime`, manifest splice

**Files:**
- Modify: `clarusc/check.cla` (declBuiltinFunc0 helper ~line 1169; registerUniverse ~1230; usesDateTime global ~626; checkIdentCall ~4898; checkReset ~5100)
- Modify: `clarusc/lower.cla` (lowCall arms, after the `askSaveChanges` arm ~line 987)
- Modify: `clarusc/drive.cla` (manifest splice, after the sortedmap block ~line 1060)
- Create: `testdata/lowlevel/dtbuiltins.cla` (test)

**Interfaces:**
- Consumes: Task 3's `rtNow`/`rtDateTimeStr`/`rtDurationStr` function names.
- Produces: builtins `now(): int`, `dateTimeStr(t: int): string`, `durationStr(secs: int): string`; `usesDateTime: bool` (check.cla global); splice of `datetime.cla` + one variant. Tasks 6/7/9 rely on the builtins by these names.

- [ ] **Step 1: check.cla — add `declBuiltinFunc0`** directly above `declBuiltinFunc1` (~line 1169), same shape with an empty params list:

```rust
func declBuiltinFunc0(scope: int, name: string, ret: int) {
    var params: list of int
    var sigIdx: int
    var sym: Symbol

    sigIdx = newFuncSig(params, ret)
    sym.nameIdx = intern(name)
    sym.typeIdx = -1
    sym.isFunc = true
    sym.sigIdx = sigIdx
    sym.isType = false
    sym.isConst = false
    sym.constIsStr = false
    sym.constInt = 0
    sym.constStrIdx = -1
    sym.isMenu = false
    scopeDeclare(scope, sym)
}
```

- [ ] **Step 2: check.cla — registerUniverse**, after the `declBuiltinFunc1(scope, "log", strT(255), -1)` line:

```rust
    // Date/time builtins (2026-08-10 datetime-instrumentation spec): a
    // datetime is a plain int (unsigned Mac-epoch seconds); see
    // runtime/clarus/datetime.cla for the backing functions these lower
    // to (lowCall's arms) when drive.cla splices it (usesDateTime).
    declBuiltinFunc0(scope, "now", IntT)
    declBuiltinFunc1(scope, "dateTimeStr", IntT, strT(255))
    declBuiltinFunc1(scope, "durationStr", IntT, strT(255))
```

- [ ] **Step 3: check.cla — the usage flag.** Next to `usesSortedMap` (~line 626):

```rust
// usesDateTime is true once the program under check has called one of
// the date/time builtins (now/dateTimeStr/durationStr) -- drive.cla's
// manifest splice reads it to decide whether runtime/clarus/datetime.cla
// (plus exactly one per-lane rtNow variant) must be spliced. Mirrors
// usesSortedMap above.
var usesDateTime: bool
```

In `checkIdentCall` (~line 4898), after the four conversion arms (`ptr`) and before `symIdx = scopeLookup(...)`:

```rust
    if name == "now" or name == "dateTimeStr" or name == "durationStr" {
        usesDateTime = true
    }
```

In `checkReset` (~line 5100), after `usesSortedMap = false`:

```rust
    usesDateTime = false
```

- [ ] **Step 4: lower.cla — lowCall arms.** After the `askSaveChanges` arm (~line 987), extending the same if/else chain (`symIdx` is already a declared local; `scopeLookup`/`symbols` already used at line ~989):

```rust
        } else if name == "now" {
            return newIRCallFn(intern("rtNow"), -1, ty)
        } else if name == "dateTimeStr" {
            symIdx = scopeLookup(curScope, identName(fn))
            return newIRCallFn(intern("rtDateTimeStr"), lowCallArgs(callArgsHead(e), symbols[symIdx].sigIdx), ty)
        } else if name == "durationStr" {
            symIdx = scopeLookup(curScope, identName(fn))
            return newIRCallFn(intern("rtDurationStr"), lowCallArgs(callArgsHead(e), symbols[symIdx].sigIdx), ty)
        }
```

- [ ] **Step 5: drive.cla — manifest splice.** After the sortedmap block (`if usesSortedMap { neededMods.add("sortedmap.cla") }`, ~line 1060) and before the ser block:

```rust
    // datetime (2026-08-10 spec): datetime.cla + exactly one per-lane
    // rtNow variant. No cprint ported-flag exists for this family -- the
    // builtins lower to ordinary named calls (lowCall), so the C lane
    // compiles the spliced .cla source directly.
    if usesDateTime {
        neededMods.add("datetime.cla")
        if want68k {
            neededMods.add("datetime_68k.cla")
        } else {
            neededMods.add("datetime_c.cla")
        }
    }
```

- [ ] **Step 6: Write `testdata/lowlevel/dtbuiltins.cla`** — same vectors as dtmodprobe but through the BUILTINS (no positional module compose):

```rust
// dtbuiltins.cla: Task 4 probe -- the dtmodprobe.cla vectors driven
// through the now()/dateTimeStr()/durationStr() builtins, proving the
// check/lower/splice wiring end to end on the host lane.
app DtBuiltins {
    id: "CLDB"
}

on App.startCLI(args: list of string) {
    var t: int
    var s: string

    s = durationStr(1805)
    if s != "30m 5s" {
        alert("FAIL durationStr")
        quit 1
    }
    s = dateTimeStr(0)
    if s != "01-01-04 00:00:00" {
        alert("FAIL dateTimeStr epoch")
        quit 1
    }
    s = dateTimeStr(2147483647)
    if s != "01-19-72 03:14:07" {
        alert("FAIL dateTimeStr 2^31-1")
        quit 1
    }
    t = -2147483647
    t = t - 1
    s = dateTimeStr(t)
    if s != "01-19-72 03:14:08" {
        alert("FAIL dateTimeStr 2^31")
        quit 1
    }
    t = now()
    if t >= 0 {
        alert("FAIL now sign")
        quit 1
    }
    t = now() - t
    if t < 0 {
        alert("FAIL now went backwards")
        quit 1
    }
    alert("OK")
}
```

- [ ] **Step 7: Build the CURRENT compiler and run the probe.** The committed snapshot doesn't know the builtins, so bootstrap one generation forward (this is the fixed-point recipe minus the final overwrite):

```bash
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o /tmp/dtb.c testdata/lowlevel/dtbuiltins.cla
cc -O1 -I runtime/host -o /tmp/dtb /tmp/dtb.c runtime/host/rt.c
/tmp/dtb
```

Expected: `OK`, exit 0.

- [ ] **Step 8: Byte-identity check** — a non-datetime program's fork must be identical from the old-snapshot-built and new-source-built compilers:

```bash
/tmp/boot emit68k --rtdir runtime/clarus/ -o /tmp/tick_old.bin testdata/cg68k/tickprobe.cla
/tmp/cur  emit68k --rtdir runtime/clarus/ -o /tmp/tick_new.bin testdata/cg68k/tickprobe.cla
cmp /tmp/tick_old.bin /tmp/tick_new.bin
```

Expected: no output (identical).

- [ ] **Step 9: T1** — `scripts/test-task.sh`. Expected green. (The snapshot is now stale relative to source — that's Task 5's job; T1 doesn't run the selfhost fixed-point test.)

- [ ] **Step 10: Commit**

```bash
git add clarusc/check.cla clarusc/lower.cla clarusc/drive.cla testdata/lowlevel/dtbuiltins.cla
git commit -m "feat: now/dateTimeStr/durationStr builtins wired to the datetime splice (Stage A: unused by clarusc itself)"
```

---

### Task 5: Snapshot regeneration, Stage A

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)

- [ ] **Step 1: Regenerate** (the exact recipe `TestSnapshotFixedPoint` prints):

```bash
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```

- [ ] **Step 2: Prove the fixed point**

Run: `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m`
Expected: PASS.

- [ ] **Step 3: T1** — `scripts/test-task.sh`. Expected green.

- [ ] **Step 4: Commit**

```bash
git add clarusc/clarusc.c
git commit -m "chore: regenerate clarusc.c snapshot (Stage A: datetime builtins exist, unused internally)"
```

---

### Task 6: Core-suite cases (3) + Go harness counts

**Files:**
- Create: `testsuite/core/cases_datetime.cla`
- Modify: `testsuite/core/runner.cla` (enum + nCoreCases + coreCaseName + coreAllCases + dispatch)
- Modify: `internal/mactest/suite_host_test.go` (`coreCLIFiles` + new file)
- Modify: `internal/mactest/coresuite_test.go` (counts 54 → 57, three spots: lines ~107, ~113, ~115)
- Modify: `internal/testsuite/core_cli_test.go` (its own build list gains the new file)

**Interfaces:**
- Consumes: the Task 4 builtins; `kit.cla`'s `TestResult`/`tkPass`/`tkFail`/`tkIntToStr`.
- Produces: `CoreTest` members `DurationStrShapes`, `DateTimeStrVectors`, `NowSanity` and case functions `caseDurationStrShapes()`, `caseDateTimeStrVectors()`, `caseNowSanity()`.

- [ ] **Step 1: Create `testsuite/core/cases_datetime.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_datetime.cla: DurationStrShapes / DateTimeStrVectors / NowSanity
// (datetime-instrumentation phase). The fixed vectors are the SHARED
// lane-identity pin from the spec (Sec 9): the same literals must pass on
// the host (C glue civil arithmetic) and native 68k (ROM Secs2Date)
// lanes. 2147483647 / its successor straddle the 2^31 unsigned boundary;
// -444896896 is 2026-01-01 00:00:00 (unsigned 3,850,070,400).

func caseDurationStrShapes(): TestResult {
    if durationStr(0) != "0s" {
        return tkFail("DurationStrShapes", "0s wrong")
    }
    if durationStr(45) != "45s" {
        return tkFail("DurationStrShapes", "45s wrong")
    }
    if durationStr(1805) != "30m 5s" {
        return tkFail("DurationStrShapes", "30m 5s wrong")
    }
    if durationStr(3605) != "1h 0m 5s" {
        return tkFail("DurationStrShapes", "1h 0m 5s wrong")
    }
    if durationStr(176520) != "49h 2m 0s" {
        return tkFail("DurationStrShapes", "49h 2m 0s wrong")
    }
    if durationStr(-45) != "-45s" {
        return tkFail("DurationStrShapes", "-45s wrong")
    }
    return tkPass("DurationStrShapes")
}

func caseDateTimeStrVectors(): TestResult {
    var t: int

    if dateTimeStr(0) != "01-01-04 00:00:00" {
        return tkFail("DateTimeStrVectors", "epoch wrong")
    }
    if dateTimeStr(86399) != "01-01-04 23:59:59" {
        return tkFail("DateTimeStrVectors", "day-end wrong")
    }
    if dateTimeStr(5097600) != "02-29-04 00:00:00" {
        return tkFail("DateTimeStrVectors", "leap day wrong")
    }
    if dateTimeStr(2147483647) != "01-19-72 03:14:07" {
        return tkFail("DateTimeStrVectors", "2^31-1 wrong")
    }
    t = -2147483647
    t = t - 1
    if dateTimeStr(t) != "01-19-72 03:14:08" {
        return tkFail("DateTimeStrVectors", "2^31 wrong")
    }
    if dateTimeStr(-444896896) != "01-01-26 00:00:00" {
        return tkFail("DateTimeStrVectors", "2026 wrong")
    }
    return tkPass("DateTimeStrVectors")
}

func caseNowSanity(): TestResult {
    var a: int
    var b: int

    a = now()
    b = now()
    if a >= 0 {
        return tkFail("NowSanity", "not in unsigned upper half")
    }
    if a < -444896896 {
        return tkFail("NowSanity", "before 2026")
    }
    if b < a {
        return tkFail("NowSanity", "went backwards")
    }
    return tkPass("NowSanity")
}
```

- [ ] **Step 2: Wire the runner** (`testsuite/core/runner.cla`) — the five documented edits, each **before the SelfCheck entry** of its structure:
  1. enum: add `DurationStrShapes`, `DateTimeStrVectors`, `NowSanity` immediately before `SelfCheck`.
  2. `const nCoreCases: int = 54` → `57` (and adjust the count words in its doc comment).
  3. `coreCaseName`: three new `case X { return "X" }` arms.
  4. `coreAllCases()`: `l.add(DurationStrShapes)` / `l.add(DateTimeStrVectors)` / `l.add(NowSanity)` before `l.add(SelfCheck)`.
  5. `runCoreTests`: three dispatch arms before the SelfCheck arm, each exactly:
     ```rust
     if wantAll or coreHas(deduped, DurationStrShapes) {
         results.add(caseDurationStrShapes())
         casesRun = casesRun + 1
     }
     ```
     (and likewise for the other two).

- [ ] **Step 3: Go lists/counts.** `internal/mactest/suite_host_test.go`: add `filepath.Join("testsuite", "core", "cases_datetime.cla")` to `coreCLIFiles`. `internal/mactest/coresuite_test.go`: `54` → `57` at the three assertion spots (`passes != 54`, `want 54`, `"TOTAL 54 PASS 54 FAIL 0"`). `internal/testsuite/core_cli_test.go`: add the new cases file to its build list (grep for `cases_intmap.cla` there and mirror).

- [ ] **Step 4: Run the host core CLI**

```bash
cc -O1 -I runtime/host -o build-run/clarusc-t6 clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc-t6 emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
```

Expected: `TOTAL 57 PASS 57 FAIL 0`, exit 0.

- [ ] **Step 5: T1** — `scripts/test-task.sh` (runs `internal/testsuite` + `internal/mactest`'s host-side pieces). Expected green.

- [ ] **Step 6: Commit**

```bash
git add testsuite/core/cases_datetime.cla testsuite/core/runner.cla internal/mactest/suite_host_test.go internal/mactest/coresuite_test.go internal/testsuite/core_cli_test.go
git commit -m "test: core-suite datetime cases (54 -> 57) with shared lane-identity vectors"
```

---

### Task 7: Toolbox-suite `DateTimeRoundTrip` case

**Files:**
- Create: `testsuite/toolbox/cases_datetime.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum + nTbCases 28→29 + tbCaseName + tbAllCases + dispatch)
- Modify: `internal/mactest/coresuite_test.go` (`toolboxFiles` + new file before `gui.cla`; counts 28 → 29 at ~lines 359 and 370)

**Interfaces:**
- Consumes: Task 2's catalog (`DateTimeRec`, `SecondsToDate`, `DateToSeconds` — `toolbox/osutils.cla` is already in `toolboxFiles`), Task 4's builtins, kit helpers.
- Produces: `ToolboxTest` member `DateTimeRoundTrip`, `func caseDateTimeRoundTrip(): TestResult`.

- [ ] **Step 1: Create `testsuite/toolbox/cases_datetime.cla`:**

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_datetime.cla: DateTimeRoundTrip (datetime-instrumentation
// phase) -- hardware-proves the Date-Time Utilities catalog contracts
// (SecondsToDate 0xA9C6 / DateToSeconds 0xA9C7, the two register-based-
// despite-bit-11 exceptions) and the now()/dateTimeStr builtins against
// real ROM. Uses the PUBLIC toolbox/osutils.cla declarations -- unlike
// the runtime module's private Dt* twins -- because proving the catalog
// itself is the point (same rationale as cases_events.cla's own local
// externs). Assumes the emulated clock is set to the host's real date
// (Mini vMac maps host time), i.e. >= 2026: now() must sit in the
// unsigned upper half.

func caseDateTimeRoundTrip(): TestResult {
    var t: int
    var rt: int
    var rec: DateTimeRec
    var s: string
    var detail: string

    t = now()
    if t >= 0 {
        return tkFail("DateTimeRoundTrip", "now not in unsigned upper half")
    }
    SecondsToDate(t, rec)
    if rec.month < 1 or rec.month > 12 {
        detail = "month " + tkIntToStr(rec.month)
        return tkFail("DateTimeRoundTrip", detail)
    }
    if rec.day < 1 or rec.day > 31 {
        detail = "day " + tkIntToStr(rec.day)
        return tkFail("DateTimeRoundTrip", detail)
    }
    rt = DateToSeconds(rec)
    if rt != t {
        return tkFail("DateTimeRoundTrip", "round trip mismatch")
    }
    s = dateTimeStr(t)
    if s.length != 17 {
        detail = "len " + tkIntToStr(s.length)
        return tkFail("DateTimeRoundTrip", detail)
    }
    return tkPass("DateTimeRoundTrip")
}
```

- [ ] **Step 2: Wire `testsuite/toolbox/runner.cla`** — same five-edit pattern as Task 6 Step 2, with `DateTimeRoundTrip` before `SelfCheck`, `nTbCases` 28 → 29, dispatch arm:

```rust
    if wantAll or tbHas(deduped, DateTimeRoundTrip) {
        results.add(caseDateTimeRoundTrip())
        casesRun = casesRun + 1
    }
```

- [ ] **Step 3: Go side.** `internal/mactest/coresuite_test.go`: add `filepath.Join("testsuite", "toolbox", "cases_datetime.cla")` to `toolboxFiles` (before the `gui.cla` entry); `28` → `29` at both assertion spots.

- [ ] **Step 4: Native build check (no emulator boot)** — prove the whole toolbox suite still compiles for 68k with the new case and the datetime splice:

```bash
cc -O1 -I runtime/host -o build-run/clarusc-t7 clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc-t7 emit68k --testapi --rtdir runtime/clarus/ -o /tmp/tb.bin \
    testsuite/kit.cla toolbox/memory.cla toolbox/events.cla toolbox/osutils.cla toolbox/scrap.cla \
    toolbox/files.cla toolbox/resources.cla testsuite/toolbox/runner.cla \
    testsuite/toolbox/cases_events.cla testsuite/toolbox/cases_draw.cla testsuite/toolbox/cases_a5.cla \
    testsuite/toolbox/cases_gestalt.cla testsuite/toolbox/cases_event.cla testsuite/toolbox/harness.cla \
    testsuite/toolbox/cases_uitest.cla testsuite/toolbox/cases_pattern.cla testsuite/toolbox/cases_buttons.cla \
    testsuite/toolbox/cases_winvar.cla testsuite/toolbox/cases_textwidgets.cla testsuite/toolbox/cases_menus.cla \
    testsuite/toolbox/cases_editmenu.cla testsuite/toolbox/cases_canvas.cla testsuite/toolbox/cases_zoomwin.cla \
    testsuite/toolbox/cases_hscroll.cla testsuite/toolbox/cases_popuptable.cla testsuite/toolbox/cases_dialogs.cla \
    testsuite/toolbox/cases_hdim.cla testsuite/toolbox/cases_formedit.cla testsuite/toolbox/cases_bigtext.cla \
    testsuite/toolbox/cases_catalog.cla testsuite/toolbox/cases_finfo.cla testsuite/toolbox/cases_resources.cla \
    testsuite/toolbox/cases_datetime.cla testsuite/toolbox/gui.cla
```

Expected: exit 0, `/tmp/tb.bin` written. (Exact file order per `toolboxFiles` in coresuite_test.go — keep them in sync.)

- [ ] **Step 5: T1** — `scripts/test-task.sh`. Expected green (the toolbox 68k boot itself is Task 11).

- [ ] **Step 6: Commit**

```bash
git add testsuite/toolbox/cases_datetime.cla testsuite/toolbox/runner.cla internal/mactest/coresuite_test.go
git commit -m "test: toolbox DateTimeRoundTrip case (28 -> 29) hardware-proving the Date-Time catalog"
```

---

### Task 8: Language-reference documentation

**Files:**
- Modify: `docs/clarus-language-reference.md` (new `### Date and Time` section in Chapter 12, after `### Logging`)

- [ ] **Step 1: Insert after the `### Logging` section:**

```markdown
### Date and Time

A datetime is a plain `int`: seconds since the Mac epoch — January 1, 1904, 00:00:00, **local time** — the same raw value the Macintosh clock (the low-memory `Time` global) stores, and the same value the Toolbox uses for file dates. The count is unsigned at the Toolbox level (it wraps on February 6, 2040) and crossed 2³¹ back in 1972, so every contemporary clock reading is *negative* when held in an `int`. This is safe by construction: differences and orderings among real clock values behave correctly (see below), and calendar decomposition is performed by the Toolbox — never by Clarus arithmetic.

- `now(): int` — the current datetime. On the Macintosh this reads the `Time` global the one-second interrupt maintains (the exact read `GetDateTime` performs); on a command-line host it derives the same local-time value from the host clock.
- `dateTimeStr(t: int): string` — formats `t` as `"mm-dd-yy HH:MM:SS"`: zero-padded fields, 24-hour clock, two-digit year.
- `durationStr(secs: int): string` — formats a span of seconds as `"1h 0m 5s"`, `"30m 5s"`, `"45s"`, `"0s"`: units above the highest nonzero unit are omitted, seconds always appear, and a negative span is `"-"` followed by the absolute span's form.

The difference between two datetimes is plain subtraction — `b - a` is the span in seconds, correct even across the 2³¹ boundary (two's-complement subtraction is modulo 2³²). Ordering comparisons are likewise correct for any two values in the 1972–2040 range (both sit in the same signed half); only comparing a pre-1972 constant against a modern reading misorders. There is no time-zone API: the classic Mac OS keeps its clock in local time (GMT offset is an opt-in Map-control-panel hint the OS itself never applies), and Clarus follows the platform. For calendar-field access or date arithmetic beyond subtraction, use the Date-Time Utilities in `toolbox/osutils.cla` (`DateTimeRec`, `SecondsToDate`, `DateToSeconds`).
```

- [ ] **Step 2: Reftest gate.** The reference's fenced examples are compiled by `internal/reftest` — this section adds no new fences, but run it anyway: `go test ./internal/reftest -count=1`. Expected: PASS.

- [ ] **Step 3: Commit**

```bash
git add docs/clarus-language-reference.md
git commit -m "docs: Date and Time builtins in the language reference (Ch12)"
```

---

### Task 9: Compiler instrumentation (Stage B — clarusc now uses the builtins)

**Files:**
- Modify: `clarusc/drive.cla` (TickCount extern + progress globals/helpers; hooks in `expand`, `driveCompile`, `driveManifestSplice` call site, `driveEmit68kFork`)
- Modify: `clarusc/cg68k.cla` (hooks in `cg68ProgramFork`)
- Modify: `clarusc/main.cla` (`feProgress` definition + `driveProgressDone()` call)
- Modify: `clarusc/macgui.cla` (`feProgress` buffer + flush + `driveProgressDone()`)

**Interfaces:**
- Consumes: builtins (Task 4), host `rt_ext_TickCount` (Task 1 — clarusc's own host build now links against it).
- Produces: `feProgress(line: string)` seam (defined per front end); drive.cla helpers `driveProgress(msg)`, `driveProgressPhase(msg)`, `driveProgressDone()` and globals `drvStartTicks`/`drvPhaseTicks`/`drvEntryName` — cg68k.cla calls `driveProgressPhase` directly (same program, plain name resolution).

- [ ] **Step 1: drive.cla — extern, globals, helpers** (place near the `fe*` call-site documentation, before `expand`):

```rust
// ---- Compile-progress instrumentation (datetime-instrumentation
// phase). Lines are emitted ONLY for want68k compiles: the C `emit`
// lane must stay byte-silent (internal/selfhost's TestErrorGoldens
// compares emit-mode CombinedOutput byte-exactly, and perfgate times
// the lane), and check-only/appinfo modes must stay silent
// (internal/reftest / internal/claruscboot assert zero output). Every
// line goes through the feProgress front-end seam -- main.cla: log()
// to stderr; macgui.cla: buffered into the Log window (painted after
// the compile until the deferred live-log phase,
// 2026-08-10-clarusc-mac-live-log-design.md).

// _TickCount (0xA975): stack-result Pascal trap -- plain `trap`, NO
// `reg` (the reg form is the documented 2026-08-03 stale-D0 bug,
// testdata/cg68k/tickprobe.cla). Host builds link rt_ext_TickCount
// (runtime/host/rt_ext_host.inc, added by this phase).
external func TickCount(): int = trap 0xA975

var drvStartTicks: int
var drvPhaseTicks: int
var drvEntryName: string

// driveProgress: timestamp-prefix msg and hand it to the front end; a
// no-op unless want68k (block comment above).
func driveProgress(msg: string) {
    var line: string

    if not want68k {
        return
    }
    line = "[" + dateTimeStr(now()) + "] "
    line = line + msg
    feProgress(line)
}

// driveProgressPhase: driveProgress plus a "(duration, N ticks)" suffix
// measured since the previous phase mark; advances the mark.
func driveProgressPhase(msg: string) {
    var t: int
    var d: int
    var line: string

    if not want68k {
        return
    }
    t = TickCount()
    d = t - drvPhaseTicks
    line = msg + " ("
    line = line + durationStr(d / 60)
    line = line + ", "
    line = line + numToStr(d)
    line = line + " ticks)"
    driveProgress(line)
    drvPhaseTicks = t
}

// driveProgressDone: the front ends' shared tail after a successful
// fork/image write -- the compile total plus the Finished stamp.
func driveProgressDone() {
    var t: int
    var d: int
    var line: string

    if not want68k {
        return
    }
    t = TickCount()
    d = t - drvStartTicks
    line = "Compiled " + drvEntryName
    line = line + " - "
    line = line + durationStr(d / 60)
    line = line + " ("
    line = line + numToStr(d)
    line = line + " ticks)"
    driveProgress(line)
    driveProgress("Finished")
}
```

- [ ] **Step 2: drive.cla — `expand()` hook.** Right after the successful `feReadSource` (`ok = feReadSource(...)` / `if not ok { ... }` block, ~line 677) and before the `pathIdx = intern(path)` line, add (declare `var progressLine: string` with expand's other locals):

```rust
    if entry {
        progressLine = "Compiling " + path
    } else {
        progressLine = "Included " + path
    }
    driveProgress(progressLine)
```

(Dedup hits return before this point, so a file logs at most once — requirement 3's "don't duplicate". Runtime modules splice through this same path, so each of the ~17 runtime files logs an `Included` heartbeat during the splice.)

- [ ] **Step 3: drive.cla — `driveCompile` hooks:**
  - At the very top (before the entries loop):
    ```rust
    drvStartTicks = TickCount()
    drvPhaseTicks = drvStartTicks
    if entries.count > 0 {
        drvEntryName = entries[0]
    }
    driveProgress("Starting")
    ```
  - After the entries `while` loop + `entryFailed` check: `driveProgressPhase("Parsed user program")`
  - After the `checkProgram(combined)` block's `if diags.count > 0 { return false }`: `driveProgressPhase("Checked user program")`
  - Immediately before `if not driveManifestSplice(...)`: `driveProgress("Loading runtime")`
  - After the splice call succeeds: `driveProgressPhase("Loaded runtime + checked whole program")`
  - After `lowerProgram`'s `if diags.count > 0 { return false }`: `driveProgressPhase("Lowered")`

- [ ] **Step 4: drive.cla — `driveEmit68kFork` hook.** After `shakeProgram()`, before `return cg68ProgramFork(...)`: `driveProgressPhase("Shaken")`

- [ ] **Step 5: cg68k.cla — `cg68ProgramFork` hooks** (add `var progressLine: string` to its locals):
  - After `if not cg68Measure() { return false }`: `driveProgressPhase("Measured")`
  - After `if not cgPackProgram() { return false }`:
    ```rust
    progressLine = "Packed " + numToStr(cgSegCount)
    progressLine = progressLine + " segments"
    driveProgressPhase(progressLine)
    ```
  - At the bottom of the per-segment `while s <= cgSegCount` body, just before `s = s + 1`:
    ```rust
    progressLine = "Emitted segment " + numToStr(s)
    driveProgressPhase(progressLine)
    ```
  - After `if not cg68BuildFork(...) { return false }`, before `return true`: `driveProgressPhase("Built fork")`

- [ ] **Step 6: main.cla — seam + Finished.** Next to `feHasKey` (~line 58):

```rust
// feProgress is main.cla's front end for drive.cla's compile-progress
// seam (datetime-instrumentation phase): log() -> stderr, the CLI's
// diagnostic-stream convention (stdout stays clean for appinfo/
// diagnostics). driveProgress itself gates on want68k, so check-only /
// emit / appinfo invocations remain byte-silent.
func feProgress(line: string) {
    log(line)
}
```

In the `emitMode68k` branch, after `ok68`'s failure check (right before falling through to `quit 0`): `driveProgressDone()`

- [ ] **Step 7: macgui.cla — buffered seam.** Next to `feHasKey`/`feReadSource`:

```rust
// gcProgressBuf accumulates drive.cla's compile-progress lines during
// the synchronous compile; gcCompile flushes it into the Log textview
// at its exit points. Painting lines LIVE mid-compile is the deferred
// 2026-08-10-clarusc-mac-live-log-design.md phase -- this buffer is the
// seam it will build on.
var gcProgressBuf: text

func feProgress(line: string) {
    gcProgressBuf.append(line)
    gcProgressBuf.append("\n")
}

// gcFlushProgress: append-and-clear the buffered progress lines into
// w's log textview (same read-mutate-reassign idiom as gcLog).
func gcFlushProgress(w: Log) {
    var buf: text

    if gcProgressBuf.length == 0 {
        return
    }
    buf = w.Output.text
    buf.append(gcProgressBuf)
    w.Output.text = buf
    gcProgressBuf = ""
}
```

In `gcCompile`: add `gcProgressBuf = ""` next to the `driveReset()` group; call `gcFlushProgress(w)` (a) right after the `ok = driveCompile(entries, false)` line's `entryFailed` check, (b) after the `built = driveEmit68kFork(...)` failure branch logs, and (c) in the success path — after `wrote` succeeds, call `driveProgressDone()` first, then `gcFlushProgress(w)`, then the existing `gcLog(w, "BUILT ...")`.

- [ ] **Step 8: Build current clarusc and verify the log shape:**

```bash
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit68k --rtdir runtime/clarus/ -o /tmp/tick.bin testdata/cg68k/tickprobe.cla 2>/tmp/progress.log
cat /tmp/progress.log
```

Expected stderr (timestamps/numbers vary; sequence and shapes must match):

```
[08-10-26 23:59:59] Starting
[08-10-26 23:59:59] Compiling testdata/cg68k/tickprobe.cla
[08-10-26 23:59:59] Parsed user program (0s, N ticks)
[08-10-26 23:59:59] Checked user program (0s, N ticks)
[08-10-26 23:59:59] Loading runtime
[08-10-26 23:59:59] Included runtime/clarus/core.cla
... (one Included line per spliced runtime module, no duplicates) ...
[08-10-26 23:59:59] Loaded runtime + checked whole program (0s, N ticks)
[08-10-26 23:59:59] Lowered (0s, N ticks)
[08-10-26 23:59:59] Shaken (0s, N ticks)
[08-10-26 23:59:59] Measured (0s, N ticks)
[08-10-26 23:59:59] Packed 1 segments (0s, N ticks)
[08-10-26 23:59:59] Emitted segment 1 (0s, N ticks)
[08-10-26 23:59:59] Built fork (0s, N ticks)
[08-10-26 23:59:59] Compiled testdata/cg68k/tickprobe.cla - 1s (N ticks)
[08-10-26 23:59:59] Finished
```

- [ ] **Step 9: Verify silence of the other modes** (all four must produce byte-identical behavior to before):

```bash
/tmp/cur testdata/valid/bookmarks.cla                                    # check-only: expect NO output, exit 0
/tmp/cur appinfo testdata/valid/bookmarks.cla                            # appinfo stdout only (app=1/name=/version=), NO stderr
/tmp/cur emit --rtdir runtime/clarus/ -o /tmp/b.c testdata/valid/bookmarks.cla 2>&1 | wc -c   # expect 0
```

- [ ] **Step 10: Fork byte-identity with instrumentation active** — same fork as the snapshot compiler produces:

```bash
/tmp/boot emit68k --rtdir runtime/clarus/ -o /tmp/tick_old.bin testdata/cg68k/tickprobe.cla
cmp /tmp/tick.bin /tmp/tick_old.bin
```

Expected: identical (progress lines change nothing about emitted bytes).

- [ ] **Step 11: T1** — `scripts/test-task.sh`. Expected green.

- [ ] **Step 12: Commit**

```bash
git add clarusc/drive.cla clarusc/cg68k.cla clarusc/main.cla clarusc/macgui.cla
git commit -m "feat: per-phase TickCount progress instrumentation behind the feProgress seam (emit68k only)"
```

---

### Task 10: Snapshot Stage B + harness-sensitive gates

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated)

- [ ] **Step 1: Regenerate the snapshot** (same four commands as Task 5 Step 1).

- [ ] **Step 2: Fixed point**: `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m` — PASS.

- [ ] **Step 3: The Class-A harness gates** (the tests the audit flagged as byte-sensitive; selfhost is not in T1, so run these directly):

```bash
go test ./internal/selfhost -run TestErrorGoldens -count=1 -timeout 30m
go test ./internal/reftest -count=1
go test ./internal/claruscboot -count=1
go test ./internal/emitui -count=1
go test ./internal/perfgate -count=1
```

Expected: all PASS (emit/check/appinfo lanes byte-silent; perfgate emit lane untouched by the want68k gate).

- [ ] **Step 4: T1** — `scripts/test-task.sh`. Expected green.

- [ ] **Step 5: Commit**

```bash
git add clarusc/clarusc.c
git commit -m "chore: regenerate clarusc.c snapshot (Stage B: instrumentation in-tree)"
```

---

### Task 11: Emulator suite boots (the phase's ONLY emulator runs)

- [ ] **Step 1: Run the two 68k suite gates** (needs the Retro68 toolchain + Mini vMac; run in the background, they boot the emulator):

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestToolboxSuiteOn68k' -count=1 -timeout 30m -v
```

Expected: both PASS — core 57/57 (`TOTAL 57 PASS 57 FAIL 0`) including the three datetime cases on real ROM (the lane-identity pin), toolbox 29/29 including `DateTimeRoundTrip` (the catalog trap-contract hardware proof).

Per the spec: **no smoke tests, no scenario goldens, no other emulator lanes this phase** (explicit decision, spec §9/§10).

- [ ] **Step 2: If `DateTimeRoundTrip` fails on register contract** (e.g. `DateToSeconds` round-trip mismatch): re-verify against `AIncludes/DateTimeUtils.a` + IM II before touching the declaration — decode, don't guess (trap-verification working notes). Fix, re-run, and record the correction in the ledger and the osutils.cla provenance comment.

- [ ] **Step 3: Update the ledger** with both boot results, then commit any fixes.

---

### Task 12: Phase records

**Files:**
- Modify: `docs/ROADMAP.md` (new unmerged-phase entry, following the existing entry format: what shipped, measured results, debt/deferrals)
- Modify: `STATUS.md` (refresh the session-status handoff: datetime+instrumentation phase done, live-log spec deferred, next steps)
- Modify: `.superpowers/sdd/2026-08-10-datetime-instrumentation/progress.md` (final state)

- [ ] **Step 1: ROADMAP entry** covering: the three builtins + int-datetime semantics (unsigned note), the module/variant splice design, the Date-Time catalog additions + bit-11 exception, the feProgress seam + want68k-only gating rationale (Class-A goldens), the two snapshot stages, suite growth (core 54→57, toolbox 28→29), and deferrals (live Mac log window → `2026-08-10-clarusc-mac-live-log-design.md`; host catalog Date-Time glue unadded; instrumented on-Mac timing capture still pending).
- [ ] **Step 2: STATUS.md refresh** (same content, handoff-style).
- [ ] **Step 3: T2 decision note** — this branch still owes a `scripts/test-merge.sh` run before any merge to main (documented standing debt from the map phase; unchanged by this plan). Record it, don't run it here unless Andrew asks.
- [ ] **Step 4: Commit**

```bash
git add docs/ROADMAP.md STATUS.md .superpowers/sdd/2026-08-10-datetime-instrumentation/progress.md
git commit -m "docs: datetime-instrumentation phase records"
```
