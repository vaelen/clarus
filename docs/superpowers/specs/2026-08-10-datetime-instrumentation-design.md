# Datetime stdlib + compiler instrumentation (2026-08-10)

Status: **approved design, pre-plan.** Two deliverables in one phase:

1. A minimal date/time surface in the Clarus standard library (three
   builtins backed by a new runtime module), usable by any program on all
   three lanes.
2. Always-on progress logging + per-phase `TickCount()` instrumentation in
   clarusc itself — the "instrument first" step the native-compiler
   performance findings doc calls for, and the cure for "on-Mac compiles
   give no sign they're running at all."

## 1. Motivation

- `ClarusC.APPL` compiles take hours with zero feedback; the Log window
  never updates mid-compile. A user cannot tell a working compile from a
  hang.
- The performance findings doc
  (`2026-08-10-native-compiler-performance-findings.md`) ranks fixes by a
  memory proxy; only lexing has a real Mac timing. Per-phase tick timing
  on-Mac converts that ranking into fact before we bet effort on it.
- The language has **no way to read the clock**: no date/time API in any
  lane, and a host build calling `TickCount()` doesn't even link
  (`runtime/host/rt_ext_host.inc` has no glue for it).

## 2. Language surface (reference additions)

A datetime is a **plain `int`**: seconds since the Mac epoch
(Jan 1 1904, 00:00:00, **local time** — what the Mac clock stores). No new
type; considered and rejected a nominal `datetime` type (the `fixed`
pattern) as retrofittable later if unit-safety earns its keep.

Three new builtins (declared in the builtin scope like `log`/`alert`):

| Builtin | Signature | Semantics |
|---|---|---|
| `now` | `now(): int` | Current local datetime in Mac-epoch seconds. |
| `dateTimeStr` | `dateTimeStr(t: int): string` | `"mm-dd-yy HH:MM:SS"` — all fields zero-padded, 24-hour clock, 2-digit year (`year mod 100`). |
| `durationStr` | `durationStr(secs: int): string` | `"Xh Ym Zs"` with leading zero units omitted: `"1h 0m 5s"`, `"30m 5s"`, `"45s"`, `"0s"`. Seconds always shown. No days unit (`"49h 2m 0s"` is fine). Negative input formats as `"-"` + absolute value. |

Difference between two datetimes is **plain subtraction** (`b - a`,
seconds) — documented, not wrapped in a helper.

**Unsigned interpretation (documented in the reference):** Mac-epoch
seconds exceeded 2³¹−1 in 1972; the Mac treats the value as unsigned
32-bit (wraps 2040). In Clarus the bit pattern lands in a signed `int`,
so every realistic clock reading is negative. This is safe:

- Subtraction is bit-identical signed vs. unsigned (mod 2³²).
- Ordering comparisons are monotonic within the 1972–2040 half-range,
  i.e. correct for all real clock values; only comparing a pre-1972
  constant against a clock reading would lie.
- All decomposition to calendar fields happens in `Secs2Date` (ROM) or
  its C glue — no unsigned arithmetic is ever done in Clarus.

## 3. Toolbox catalog additions (`toolbox/osutils.cla`)

Per the fill-the-manager standing principle, the OS Utilities catalog
gains the Date-Time Utilities:

- `record DateTimeRec` — seven 16-bit fields per IM: `year` (full year),
  `month` (1–12), `day` (1–31), `hour` (0–23), `minute`, `second`,
  `dayOfWeek` (1 = Sunday). Transcribed per cookbook conventions.
- `external func ReadDateTime(...)` — reads the clock chip, resyncs the
  low-memory `Time` global.
- `external func Secs2Date(secs, VAR DateTimeRec)` — unsigned
  seconds → calendar record; ROM handles leap years and month lengths.
- `external func Date2Secs(VAR DateTimeRec, VAR secs)` — inverse;
  tolerant of out-of-range fields (month 13 rolls over).

Exact trap words and register contracts are **verified against Universal
Interfaces / IM Vol II during implementation** (decode the inline glue
words — see trap-verification working notes; do not trust memory).
`GetDateTime` is inline glue (reads low-memory `Time`), not a trap, so it
cannot be a Clarus extern: it gets a doc comment pointing at `now()`.

C-lane glue for the catalog externs is added only for routines something
actually calls (the runtime module's private twins, §4); catalog entries
themselves are declarations and cost nothing.

## 4. Runtime module: `runtime/clarus/datetime.cla` (+ lane variants)

New conditionally-spliced module (the `sortedmap.cla` pattern), with
`rtNow` split into per-lane variant files (the `native.cla`
lane-conditional-splice precedent), because the native clock read has no
lane-portable expression:

- `datetime.cla` (shared, all lanes):
  - `rtDateTimeStr(t: int): string` — calls a module-private `Secs2Date`
    twin into a module-private `DtDateTimeRec`, then formats the fields
    (pure Clarus string building; zero-pad helpers local to the module).
  - `rtDurationStr(secs: int): string` — pure Clarus (signed arithmetic
    only; durations are small).
- `datetime_68k.cla` (native lane only):
  `func rtNow(): int { return peekl(0x020C) }` — reads the low-memory
  `Time` global directly, the era-authentic zero-cost path (`Time` is
  maintained by the one-second interrupt; no chip access on read).
- `datetime_c.cla` (C lanes only): `rtNow` calls a module-private extern
  `DtTimeNow(): int`, rendered by cprint as `rt_ext_DtTimeNow` glue
  (§5). The extern carries the truthful `ReadDateTime` trap word/contract
  even though the C lanes never emit it.

Runtime modules cannot reference user-composable catalog files, so
datetime.cla declares **private twins** of the externs and record
(`Dt`-prefixed), exactly as `ui.cla` privately declares `UiTickCount`
alongside the catalog's `TickCount`. Extern dedup already handles a user
composing both (`testdata/lowlevel/externdedup.cla` pins this).

Decomposition strategy (decided): **let the ROM do it.** The native lane
emits the real `Secs2Date` trap — unsigned handling and calendar
arithmetic correct by definition, no unsigned division in Clarus. The two
C lanes supply glue (§5). Trade-off accepted: `dateTimeStr`'s
lane-identity rests on glue matching ROM behavior; pinned by shared test
vectors (§9).

## 5. C-lane glue

`runtime/host/rt_ext_host.inc` (host CLI lane — all new; it has **no**
time glue today):

- `rt_ext_TickCount` — `clock_gettime(CLOCK_MONOTONIC)` scaled to 60ths
  of a second. Arbitrary zero point and monotonicity match the Mac's
  ticks-since-boot; all uses are deltas. (This alone un-breaks host
  builds that compose `toolbox/events.cla` and call `TickCount()`.)
- Glue for the `Dt*` clock/Secs2Date twins:
  - `rt_ext_DtTimeNow`: `time(NULL)` converted UTC→local (`localtime()`),
    shifted by the epoch offset 2,082,844,800 s (86,400 × 24,107 days,
    1904→1970), stored as the unsigned bit pattern in a 32-bit int.
  - `Secs2Date` twin: ~10 lines of C civil-date decomposition operating
    on `uint32_t` (or equivalently, shift back to Unix time and use
    `localtime()` on the already-local value via `timegm`-style
    handling — implementation picks the simplest correct form and pins it
    with the shared test vectors).

`runtime/mac/rt_ext_mac.inc` (Retro68/cprint lane): glue calls the real
`GetDateTime` / `Secs2Date` from Universal Interfaces (this lane already
has `rt_ext_TickCount`).

## 6. Compiler wiring (clarusc)

- `check.cla`: declare the three builtins; set a `usesDateTime` usage
  flag when any is called (the `usesSortedMap` precedent,
  `check.cla:1759`).
- `drive.cla` manifest splice: when `usesDateTime`, splice
  `datetime.cla` plus exactly one variant — `datetime_68k.cla` if
  `want68k`, else `datetime_c.cla` (`drive.cla:1059-1069` neighborhood,
  alongside sortedmap/ser/native).
- `lower.cla`: route the three builtins to **ordinary IR calls by name**
  (`rtNow`/`rtDateTimeStr`/`rtDurationStr`) — the `rtFixMul` precedent.
  Spliced runtime functions compile on every lane, so there are **no
  ir.cla intrinsic ids, no cg68k arms, no cprint arms**. The tree shaker
  walks real calls, so no new roots either.
- Reference + cookbook doc updates (§2, §3).

### Bootstrap sequencing (two-stage snapshot, the map-phase pattern)

The committed `clarusc/clarusc.c` snapshot must be able to compile
clarusc's own source at every commit:

- **Stage A**: land the builtins + runtime module + glue *without using
  them anywhere in clarusc's own source*. Regenerate the snapshot
  (`TestSnapshotFixedPoint` protocol).
- **Stage B**: use the new builtins in clarusc (instrumentation, §7).
  Regenerate the snapshot again; fixed point must hold.

`TickCount` needs no staging — it's a plain extern clarusc declares
itself (the `parsebench.cla` precedent), understood by the old snapshot.

## 7. Compiler instrumentation

### Seam

New front-end-provided function `feProgress(line: string)` (the
`feHasKey` precedent — drive.cla calls it, each front end defines it):

- **Host CLI** (`main.cla`): `log(line)` → stderr. Keeps stdout clean
  for appinfo/diagnostic conventions.
- **ClarusC.APPL** (`macgui.cla`): append to the Log textview via the
  existing `gcLog` path (window handle via a module global set at compile
  start). **Making those lines visibly paint mid-compile is deferred** to
  its own later phase
  (`2026-08-10-clarusc-mac-live-log-design.md`) — the compile runs
  synchronously inside an event handler, so today the appended lines
  render only when events next process. This phase's deliverable is the
  host-lane log plus the seam; the Mac window catches up when that spec
  runs (scheduled after more performance work, before the next emulator
  compile attempt).

drive.cla composes each line as `"[" + dateTimeStr(now()) + "] " + msg`.
Durations come from `TickCount()` deltas, reported as
`durationStr(ticks / 60)` plus the raw tick count.

### Messages (always on — no flag)

| # | Line | Where |
|---|---|---|
| 1 | `Starting` | front end, before `driveCompile` |
| 2 | `Compiling <entry file>` | `driveCompile`, per entry |
| 3 | `Included <path>` | `expand()`, only on an actual read — dedup hits (`seenPaths`) stay silent. Runtime modules splice through the same path, so the ~17 runtime files each log a line during the multi-minute splice: a free liveness heartbeat. |
| 4 | `Loading runtime` | `driveManifestSplice` start |
| 5 | per-phase completion lines, each `<Phase> (<duration>, <ticks> ticks)` | the driver boundaries: parse/expand done, check #1 (user standalone), runtime splice + check #2, lower, shake, and inside the 68k path: measure pass, segment pack, emit pass, fork write (`driveCompile` + `driveEmit68kFork` + `cg68ProgramFork` boundaries; exact hook lines are a plan detail — the measure/emit split matters because codegen is 67% of the profile) |
| 6 | `Compiled <entry file> - <duration> (<ticks> ticks)` | end of emit, total |
| 7 | `Finished` | front end, after fork/image write |

Check-only mode (bare `clarusc FILE`) and `appinfo` keep today's quiet
behavior: instrumentation lines are emitted through `feProgress`, and the
host CLI front end suppresses them unless an emit mode is active
(plan-level switch; the seam makes this a front-end decision, not
drive.cla's).

## 8. Byte-identity and cost guarantees

- Emitted forks for programs that don't use the datetime builtins are
  **byte-identical** before/after this phase (instrumentation only
  prints; datetime.cla splices only on use). Verified by the existing
  emitui/frozen-scenario goldens plus a before/after fork diff of a
  non-datetime program.
- Instrumentation overhead is a few dozen string builds + `feProgress`
  calls per compile — noise against a multi-minute compile; acceptable
  on host too.

## 9. Testing

- **Core suite** (host + native, pure logic):
  - `durationStr` shapes: `0s`, `45s`, `30m 5s`, `1h 0m 5s`, `49h 2m 0s`,
    negative input.
  - `dateTimeStr` against **shared fixed test vectors** spanning the
    unsigned range: a pre-1972 positive value, a modern (negative-int)
    value, month/year boundaries, a leap day (e.g. 02-29-04 both
    centuries' interpretation), midnight/23:59:59. Same vectors assert
    identical strings on host (C glue) and native (ROM) — this is the
    lane-identity pin for the Secs2Date decision.
  - `now()` sanity: nonzero, in the valid unsigned range for ≥2026
    (i.e. negative as signed int), non-decreasing across two calls.
- **Toolbox suite** (real emulator): a `DateTime` case exercising
  `now()` + `dateTimeStr` + the catalog externs on hardware
  (`Date2Secs(Secs2Date(t)) == t` round-trip).
- **Byte-identity**: fork diff per §8.
- **Harness audit**: one task greps `internal/` for anything parsing
  clarusc stderr/stdout and makes it tolerant of the new progress lines
  (host CLI emits them on stderr only in emit modes).
- **Snapshot**: `TestSnapshotFixedPoint` at both stages (§6).
- **Emulator scope (deliberately narrow this phase)**: the core and
  toolbox suite boots are the *only* emulator runs — the toolbox boot is
  what proves the trap wiring. No smoke tests, no scenario goldens, no
  other emulator lanes; those wait until after the next round of
  performance work (see the deferred live-log spec). T1 per task
  **without** `--smoke`, by explicit decision.

## 10. Acceptance

1. The core suite's new datetime cases pass on host, and the suites'
   68k boots (core + toolbox, including the new `DateTime` case) pass on
   the emulator — the only emulator runs this phase.
2. A `clarusc emit68k` run on host prints the full instrumented log to
   stderr with plausible timings.

Deferred to later phases: live Log-window updates in `ClarusC.APPL`
(`2026-08-10-clarusc-mac-live-log-design.md`) and the instrumented
on-Mac compile that converts the findings doc's ranking into real
timings — both scheduled after more Layer-1 performance work, when
running the compiler on the emulator is worth the hours again.

## 11. Risks

- **Host glue vs ROM divergence** in `dateTimeStr` — pinned by shared
  test vectors; scope limited to 1904–2040 which both sides handle.
- **Two snapshot regenerations** — routine (done twice in the map
  phase), but order-sensitive; the plan sequences Stage A before any
  clarusc-internal use.
- Trap words/register contracts for the three Date-Time externs must be
  glue-word-verified, not recalled.

## 12. Out of scope (YAGNI)

Date parsing, timezone/GMT API (`ReadLocation`), `SetDateTime`, a
nominal `datetime` type, format customization, an `elapsedSecs` wrapper,
days unit in `durationStr`, and any use of the Map control panel data.
The classic Toolbox model — everything local, GMT a rarely-set hint — is
matched, not fought.
