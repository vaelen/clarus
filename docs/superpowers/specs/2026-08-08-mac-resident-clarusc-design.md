# Mac-resident clarusc — design

Date: 2026-08-08. Second sub-phase of the decomposed 5f (peephole → **this**
→ compilation cache → Retro68 retirement). Branch: `mac-resident-clarusc`.

## Goal & acceptance

Deliverable: **Clarusc.APPL** — clarusc itself compiled by host
`clarusc emit68k` (cross), running on System 6 in Mini vMac as a one-shot
GUI compiler.

Acceptance: on-Mac, it compiles `testdata/cg68k/tickprobe.cla` (a real
self-quitting `every`-block UI program already in-tree) from a `.cla` file
on disk into a double-clickable APPL whose **resource fork byte-compares
equal to host `emit68k` output of the same source**, and which then boots
and exits clean. A second compile in the same boot exercises the baked
`toolbox/` catalog path (see Testing).

The bootstrap chain is untouched: the snapshot stays host-C of the CLI
composition (`clarusc emit -o clarusc/clarusc.c clarusc/main.cla`); the Mac
build is a separate composition cross-built from the host.

## 1. cg68k gap fixes (prerequisite)

The two gaps recorded by the peephole phase as blocking clarusc's own
self-emit:

- **`cgPushArgs` unmaterializable KStr/KRec**: a freshly-produced str/rec
  value (e.g. a concatenation result) passed directly as a call argument
  has no addressable home. Fix generally in lowering: hoist non-trivial
  str/rec call arguments into compiler temps (mechanically what the
  approved `lex.cla` hand-hoist did). The `lex.cla` hoist is then
  reverted, and the ~14 `parse.cla` `parseErrorf` sites compile without
  edits.
- **`cgBigTmpSlots` ceiling** ("too many str/rec temps"): replace the
  fixed budget with a per-function count (or a bump if counting is
  invasive — decided in the plan; the requirement is: no artificial
  ceiling clarusc itself can hit).

Gate: `clarusc emit68k` over the full Mac composition succeeds; the 4
frozen scenarios' trace/framebuffer goldens stay byte-identical
(behavior-unchanged); `internal/cg68k` byte goldens may legitimately
change (hoisting alters instruction streams) and are regenerated under
review.

## 2. Mac front end (`clarusc/macgui.cla`) + driver split

One window ("Clarus Compiler") with a log textview; File menu:
Compile… / Quit. Flow: askOpen → compile → every diagnostic appended to
the log as `path:line: message` → on success, write the APPL next to the
source and log size/segment stats; on failure, alert carries the first
error, log carries all. Then back to idle — pick another file or quit.

Driver sharing: the pipeline orchestration currently in `main.cla`
(expand/include walk → check → lower → emit) moves to a shared
`clarusc/drive.cla`, callable from both front ends. `main.cla` keeps
argv/flags/stdout/exit codes; `macgui.cla` keeps UI. Diagnostics are
already collected as data before printing, so the split moves code, not
redesigns it. `macgui.cla` uses only ordinary user-level UI surface
(window/textview/menus/askOpen) — no `--testapi`, no runtime-function
access. The Mac front end supports `emit68k` compilation only (no
`emit`/`appinfo`/check-only modes).

## 3. `--bake`: general resource baking

`clarusc emit68k --bake PATH` (repeatable). PATH must be a **file** — no
directory form: neither the language nor the toolchain has any
directory-enumeration primitive (verified: zero readdir/listdir/
PBGetCatInfo hits repo-wide), so the build script globs and passes each
file. One resource per file: type `'CLFS'`, **name = PATH exactly as
passed**, bytes = verbatim contents. Duplicate keys are a build-time
error (the Resource Manager would silently shadow: `Get1NamedResource`
returns the first match). Resource names cap at 255 chars — enforced at
bake time.

Baked resources are *named*; `app68BuildResourceFork` today emits only
unnamed resources (empty name list), so it gains an optional per-resource
name (empty = unnamed, existing callers unchanged, no-`--bake` output
byte-identical).

Key convention: the path as passed on the command line. The Mac compiler
build runs `--bake runtime/clarus --bake toolbox` from repo root, so keys
match what the driver asks for (`runtime/clarus/ui.cla`,
`toolbox/files.cla`, …). The keys form a virtual `/`-separated filesystem
inside the resource fork.

Emission goes through `res68k.cla`'s resource-fork builder (arbitrary
named-blob API added). No constant-pool involvement — the `--events` pool
lives in CODE-segment space (32KB segmentation pressure; `ui.cla` alone
is ~101KB), which is why baking is resource-based. Host `.bin` output
without `--bake` is byte-identical to today.

This is a general emit68k feature, not compiler-private. Reading baked
resources from Clarus code gets a **minimal language surface** (amended
2026-08-08 after recon — the Mac front end is ordinary user code and
cannot reach runtime internals; the alternatives, `--testapi` on a
shipping build or a per-byte copy loop in user code, are worse):

- `file.readResource(name: string, out: text): bool` — fill `out` from
  the named `'CLFS'` resource in the current resource chain; native impl
  in `runtime/clarus/native.cla` (Get-named-resource → copy via the
  `natFileReadText` grow/deref/BlockMove idiom → `ReleaseResource`);
  host impl returns false (host binaries have no resource fork).
- `file.writeRes(path: string, fork: text, doctype: string,
  creator: string): bool` — create `path`, write `fork` verbatim as its
  resource fork, leave the data fork empty, stamp type/creator (the
  output-write primitive, §6).

**Conservative-subset guard:** the snapshot composition (`main.cla` +
includes) must not contain the new surface for one release cycle. The
shared driver therefore reads all source through a front-end-supplied
seam — `func feReadSource(path: string, key: string, out: text): bool`,
defined by each front end: `main.cla`'s uses `file.readText` (+ rtdir
mapping) only; `macgui.cla`'s tries disk then `file.readResource`.
`file.writeRes` appears only in `macgui.cla`. Both new intrinsics are
documented in the language reference (Chapter on files).

## 4. Include & runtime-source resolution on Mac

All reads go through one driver helper, `readSource()`:

1. **Filesystem first**, relative to the including file's directory
   (normal include semantics — a user's local copy always wins).
2. **On miss, resource key space**: resolve the same relative path
   against the includer's key (when the includer itself came from a
   resource) with the same `dirOf` + `../` normalization, and look up the
   `'CLFS'` resource by name. `ReleaseResource` after lex/parse — the
   source bytes don't stay resident.

Runtime-module splices read `runtime/clarus/<mod>.cla` through the same
helper — no special case. On host, resolution stays purely filesystem
(`--rtdir` as today); no search-path feature is added.

Consequences, accepted and documented: a typo'd include can silently hit
a baked file on Mac (disk miss → resource hit); keys depend on how the
build invoked `--bake` (the one real invocation lives in a script).
No startup name-cache for lookups: ~25–30 linear `Get1NamedResource`
scans per compile is microseconds against minutes of compile —
`ponytail:` comment at the helper names the upgrade path (cache the name
list if baked-file counts get large or lookups become per-line).

## 5. Paths: `/` in source, `:` at the rim

- **In source files, `/` is the only separator** — the entire corpus
  already uses `/`-relative includes (`../ast.cla`,
  `../../toolbox/files.cla`). Same `.cla` compiles on host and Mac
  unchanged; the language reference documents this as the include-path
  form.
- **Conversion happens only at resolution time** in the Mac driver:
  split on `/`, map to HFS relative form against the including file's
  directory — `a/b.cla` → `:a:b.cla`, `../x.cla` → `::x.cla`. A
  leading-`/` absolute include is rejected with a diagnostic on Mac
  (meaningless on HFS; none exist in the corpus).
- **Native paths never round-trip the other way**: askOpen's result and
  the output writer stay in native `:` form end to end. A
  `hostPaths: bool` driver global (set by each front end) governs the
  path helpers (`normalizePath`/`dirOf`/join), not source syntax.
- **askOpen returns a bare Standard File name, not a full path**
  (verified: the Str255 goes straight to the File Manager with
  `ioVRefNum = 0`, i.e. default volume/dir — that's why the texteditor
  scenario's bare-name round trip works). The compile model is therefore
  default-directory-relative; the front end ensures the chosen file's
  volume/dir becomes the default (SetVol from the SFReply, the exact
  purpose `toolbox/files.cla`'s `PBSetVolSync` was cataloged for) so
  bare-name reads and write-next-to-source both land in the source's
  folder.
- Include dedup stays exact-match on the path string; HFS
  case-insensitivity is a documented simplification (case-fold if it
  ever bites).

## 6. Output write on-Mac

`app68k.cla` splits at the natural seam: resource-fork image construction
(exists) vs MacBinary wrapping (host-only). Host path wraps exactly as
today — existing `.bin` outputs byte-identical. Mac path: create the
output file, write the fork image to the **resource fork** (create /
open-RF / write / close), stamp `APPL` + the app's creator from its `app`
section. The data fork stays empty, matching what the MacBinary header
already declares (data fork length 0).

The needed File Manager externs (create/open-RF/write/close/stamp; exact
high-level-vs-PB forms decided against Universal Interfaces during
implementation, per the standing decode-the-inline-words rule) fill out
`toolbox/files.cla`, which was explicitly left thin for this phase. The
Resource Manager externs (`Get1NamedResource`, `ReleaseResource`, size
query) go in a new `toolbox/resources.cla`.

## 7. Memory & speed posture

Named risk, measured before it's bet on: **plan task 1** instruments host
clarusc (arena/heap high-water) compiling tickprobe + full UI splice, and
sizes the Mac composition via self-emit. Budget: 4MB Mac Plus minus
System 6 (~300KB) minus the loaded app's CODE — the compile must fit in
what remains, with `ReleaseResource` reclaiming each module's source
after parse. If the measurement says it doesn't fit, stop and re-scope
(options ranked then: trim the splice for the acceptance app, lazier
arena retirement) rather than discovering it in the emulator.

Compile wall-clock is recorded, not gated — speed is the cache phase's
business. No SIZE resource work: System 6 plain Finder gives the app the
whole heap (MultiFinder partition tuning noted as future).

## 8. Testing

**T1 (host, ungated):**
- Units for the KStr/KRec materialization (the `parse.cla` shapes compile
  and run on host); `lex.cla` hoist reverted.
- `app68k` fork-split byte-compare: every existing `.bin` output
  unchanged bit-for-bit.
- `--bake` unit: resource present under the expected key, bytes equal the
  source file; duplicate-key and >255-char-name errors fire.
- Catalog test extension (`internal/testsuite/catalog_test.go`) for the
  new `toolbox/files.cla` + `toolbox/resources.cla` entries.
- `internal/cg68k` golden regen, reviewed.

**Harness spike (own task, before the integration test):** the native
lane has NO existing machinery to put arbitrary files onto the boot disk
or pull files back off it (verified: texteditor's `Report.txt` is written
by a setup-companion `.cla` at boot; LaunchAPPL builds and deletes its
own temp disk). The spike resolves the file-in/file-out mechanism with
ranked strategies: (1) read `Retro68/LaunchAPPL`'s minivmac backend
source for an extra-file/extra-disk/keep-disk hook; (2) own-disk boot —
hfsutils (`toolchain/bin/h*`) builds a scratch HFS image, boot-block
startup-app trick per LaunchAPPL's own source, Mini vMac driven directly
(must also solve log capture, which today rides LaunchAPPL's stdout);
(3) fallback, adopted only if 1–2 prove impractical within the task and
recorded for sign-off: file-in via a baked `'CLFS'` test resource,
file-out via fork checksums+length logged from the Mac side and compared
against the same checksums of host output (byte-compare weakened to
strong-checksum-compare; the produced-app boot still proves launchability
end-to-end).

**T2 (gated, `internal/mactest`, new test):**
1. Build Clarusc.APPL (`emit68k --bake <runtime/clarus/*.cla glob>
   --bake <toolbox/*.cla glob>` + macgui composition, `--events` script
   baked in).
2. Seed `tickprobe.cla` and a second small source (one that includes a
   `toolbox/` catalog file and calls one real trap) onto the boot disk
   via the spike's mechanism.
3. Boot; script: answer-open tickprobe.cla → compile via menu verb →
   answer-open the catalog-using source → compile → quit.
4. Pull both produced APPLs back out (spike mechanism);
   **byte-compare each resource fork against host `emit68k` of the same
   source** (built without `--events`, same flags) — the differential
   oracle. Same compiler algorithm on two architectures producing
   identical bytes is the real cross-check; any word-size or
   endianness-assumption bug in clarusc surfaces here.
5. LaunchAPPL-boot the produced tickprobe APPL; exit 0 proves the on-Mac
   fork write + stamp made a real launchable app.

Generous timeout: on-Mac compile of tickprobe + UI splice at all-out
emulator speed is minutes, not seconds. One boot of the compiler, one
boot of its output; everything else rides the byte-compare oracle.

## Non-goals

Compilation cache (next sub-phase); Retro68 retirement (last);
self-host-on-Mac (needs the cache; this phase proves the compiler runs
and compiles small programs natively); `emit`/`appinfo`/check-only modes
on Mac; any resource surface beyond the minimal
`file.readResource`/`file.writeRes` pair (§3); `openDocument` droplet
behavior; editor/IDE features; System 7 anything; bootstrap-chain
changes (snapshot is regenerated once at phase end per the standing
release convention, via `TestSnapshotFixedPoint`'s printed recipe);
startup resource-name cache.

## Rejected alternatives

- **Constant-pool baking** (generalize the `--events` pool): the pool is
  emitted into CODE-segment space; 507KB of runtime source (ui.cla alone
  101KB) breaks 32KB segmentation. Resources have no such limit and are
  releasable after parse.
- **String-constant `.cla` generation** (runtime sources as generated
  Clarus literals): 507KB through the lexer as literals, worse than the
  proven resource path.
- **Runtime/toolbox as TEXT files on disk**: editable on-Mac but
  reintroduces the disk-layout/missing-file class; catalog updates ride
  compiler releases anyway; filesystem-first resolution already gives
  power users an override.
- **Output via Resource Manager calls** (`AddResource`/`WriteResource`):
  `res68k` already serializes a complete fork image; decomposing it back
  into RM calls is pure extra surface over a raw fork write.
- **Two special-purpose bake flags** (`--bakert`/`--baketb`): superseded
  by the general `--bake PATH`.
