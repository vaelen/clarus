# `app` Section + Richer About Box Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A declarative `app` section (name/version/author/about/icon/id) that drives a properly laid-out About box, a real Finder icon + creator code, and output naming.

**Architecture:** `app` is a contextual soft keyword parsed into a new `DkApp` decl; the checker validates it; lowering stores pool indices in `ir.cla` module vars; cprint emits a strong `rt_ui_app_info` struct that overrides a weak default in `rt_ui.c`. The About box is a generated per-app `ALRT`/`DITL` 129 shown with `Alert()` + `ParamText`. build-mac.sh gains `clarusc appinfo`-driven naming and generates `appres.r` (about DITL, `vers`, `BNDL`/`FREF`/`ICN#`) with two on-the-fly-compiled C helpers (`pbm2icn`, `setbundle`).

**Tech Stack:** Clarus (clarusc self-hosted compiler), C (classic Mac Toolbox via Retro68), Rez resources, bash, Go test harnesses.

**Spec:** `docs/superpowers/specs/2026-07-25-app-section-design.md` (read it first).

## Global Constraints

- The Go compiler (`cmd/clarus`, `internal/` compiler packages) is FROZEN. New syntax lands in clarusc + reference only. Test harness packages (`internal/mactest`, `internal/emitui`, `internal/selfhost` test files) may be edited.
- **`app` fixtures must NEVER go in `testdata/valid`, `testdata/errors`, `testdata/run`, `testdata/runerr`, `testdata/include`, or `testdata/diag`** — the differential corpus globs those and the frozen Go front end cannot parse `app`. Use `testdata/emitui/` and `clarusc/test/` goldens (canvas-`pattern` precedent, commit 5692df5).
- Every task that edits any `clarusc/*.cla` MUST regenerate the snapshot before committing:
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  go test ./internal/selfhost/   # TestSnapshotCurrent + fixed point must pass
  ```
- Diagnostics print as `path:line:col: message` via `emitDiag` (lib.cla:70); parse errors are fail-fast (`parseErrorf` sets `parseAborted`; every parse loop needs `and not parseAborted`).
- Existing UI goldens (`testdata/ui/*.trace`, `testdata/uisnaps/*.pbm`) must stay byte-identical except where a task explicitly blesses new ones.
- All runtime display strings are Pascal (`const unsigned char *`, `"\p..."` literals); descriptor identity names are C strings.
- `go build -o clarus ./cmd/clarus && go test ./...` must pass at every commit.
- Branch: all tasks commit to `app-section` (created from main before Task 1).

---

### Task 1: clarusc front end — parse + check the `app` section

**Files:**
- Modify: `clarusc/ast.cla` (DeclKind enum ~:181-201, layout doc ~:104, constructors near :1277)
- Modify: `clarusc/parse.cla` (parseTopDecl :1314-1334, new parseAppDecl near parseWindowDecl :1356)
- Modify: `clarusc/check.cla` (buildUiTables :429, checkTopDeclPhase1 :3723-3747, checkReset :3689)
- Modify: `clarusc/test/check_test.cla` + `clarusc/test/check_test.out`
- Modify: `docs/clarus-language-reference.md` (Ch7 new subsection + Appendix A grammar)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces: `DkApp` (appended LAST in `enum DeclKind`, after `DkMenuEntry`); node layout `nameIdx`=label, `a`=DkProperty chain head, `b`=source path pool index (`curPathIdx` at parse time); `newAppDecl(nameIdx: int, propsHead: int, pathIdx: int, line: int, col: int): int`, `appDeclName(i: int): int`, `appDeclPropsHead(i: int): int`, `appDeclPathIdx(i: int): int`. Later tasks (2, 4) rely on these exact names.

- [ ] **Step 1: Write failing check tests.** Append cases to `clarusc/test/check_test.cla` (follow the existing `runCase(label, src)` pattern — build `src` with `ln(src, "...")`; `app` snippets live only inside these strings, never as driver syntax, because the driver itself is compiled by the frozen Go compiler):
  - `app-clean`: full section (all 6 keys, `id: "MNDL"`) + `on App.startCLI(args: list of string) {}` → expect `clean`
  - `app-duplicate-section`: two `app` sections → `duplicate app section` at the second's line/col
  - `app-duplicate-key`: `name` twice → `redeclaration of name`
  - `app-unknown-key`: `flavor: "x"` → `unknown property flavor for app`
  - `app-non-literal`: `name: 1 + 2` → `app property name requires a string literal`
  - `app-missing-value`: bare `name` (no colon/value) → `app property name requires a string literal`
  - `app-bad-id-len`: `id: "TOOLONG"` → `app id must be exactly 4 printable characters`
  - `app-bad-id-lower`: `id: "mndl"` → `app id must not be all lowercase`
  - `app-icon-without-id`: `icon: "x.pbm"` with no `id` → `app icon requires an id property` (report at the icon property's line/col)
- [ ] **Step 2: Run to verify failure.** `go test ./internal/selfhost/ -run TestClarusModules` — expect check_test to fail (either parse error "expected declaration" or golden mismatch).
- [ ] **Step 3: ast.cla.** Add `DkApp` at the END of `enum DeclKind`; add layout doc line near :104 (`DkApp  nameIdx=label; a=props head (DkProperty chain); b=path pool idx`); add constructor + accessors cloned from the `newWindowDecl` group (ast.cla:1277-1294):
  ```clarus
  func newAppDecl(nameIdx: int, propsHead: int, pathIdx: int, line: int, col: int): int {
      var n: DeclNode
      n.kind = DeclKind.DkApp
      n.nameIdx = nameIdx
      n.a = propsHead
      n.b = pathIdx
      n.c = -1
      n.next = -1
      n.intVal = 0
      n.line = line
      n.col = col
      decls.add(n)
      return decls.count - 1
  }
  func appDeclName(i: int): int { return decls[i].nameIdx }
  func appDeclPropsHead(i: int): int { return decls[i].a }
  func appDeclPathIdx(i: int): int { return decls[i].b }
  ```
  (Match the exact field-setting style of neighboring constructors — copy one and adjust.)
- [ ] **Step 4: parse.cla.** In `parseTopDecl` just before the final `parseErrorf` (:1332), add the soft-keyword dispatch (mirror the `include` special case at :1315 for the ident-text test idiom):
  ```clarus
  if curKind() == TkIdent and poolGet(curTok().nameIdx) == "app" and peekKind() == TkIdent {
      return parseAppDecl()
  }
  ```
  Add `parseAppDecl` next to `parseWindowDecl` (clone of :1356-1380, but the body loop calls `parseProperty()` directly instead of `parseWindowItem()`):
  ```clarus
  func parseAppDecl(): int {
      var line: int
      var col: int
      var name: Tok
      var propsHead: int
      var propsTail: int
      var pIdx: int

      line = curLine()
      col = curCol()
      advance() // 'app' (contextual ident)
      name = expect(TkIdent)
      expect(TkLBrace)
      propsHead = -1
      propsTail = -1
      skipItemSeps()
      while curKind() != TkRBrace and not parseAborted {
          pIdx = parseProperty()
          if propsHead == -1 { propsHead = pIdx }
          propsTail = declListAppend(propsTail, pIdx)
          skipItemSeps()
      }
      advance() // consume '}'
      return newAppDecl(name.nameIdx, propsHead, curPathIdx, line, col)
  }
  ```
  (Verify `curPathIdx` is the global lib.cla path index visible here — it's what `emitDiag` stamps; if parse.cla uses a different accessor for the current path, use that.)
- [ ] **Step 5: check.cla.** (a) Declare `var appProps: map of int` beside `windowTopProps` (:425) and seed it in `buildUiTables()` (:429): `name version author about icon id` → 1. (b) Module var `var appDeclSeen: bool`, set `false` in `checkReset` (near :3689). (c) `case DkApp { checkAppDecl(d) }` in `checkTopDeclPhase1` (:3745). (d) `checkAppDecl`, following `checkWindowDecl`'s shape (:1736-1757):
  ```clarus
  func checkAppDecl(d: int) {
      var item: int
      var pname: string
      var vh: int
      var declared: map of int
      var iconLine: int
      var iconCol: int
      var hasIcon: bool
      var hasId: bool
      var idVal: string

      if appDeclSeen {
          emitDiag(declLine(d), declCol(d), "duplicate app section")
          return
      }
      appDeclSeen = true
      hasIcon = false
      hasId = false
      item = appDeclPropsHead(d)
      while item != -1 {
          pname = poolGet(propertyName(item))
          if not appProps.has(pname) {
              emitDiag(declLine(item), declCol(item), "unknown property " + pname + " for app")
          } else if declared.has(pname) {
              emitDiag(declLine(item), declCol(item), "redeclaration of " + pname)
          } else {
              declared[pname] = 1
              vh = propertyValuesHead(item)
              if vh == -1 or exprNext(vh) != -1 or exprKind(vh) != ExStringLit {
                  emitDiag(declLine(item), declCol(item), "app property " + pname + " requires a string literal")
              } else {
                  if pname == "id" {
                      hasId = true
                      idVal = poolGet(stringLitIdx(vh))
                      checkAppId(idVal, declLine(item), declCol(item))
                  }
                  if pname == "icon" {
                      hasIcon = true
                      iconLine = declLine(item)
                      iconCol = declCol(item)
                  }
              }
          }
          item = declNext(item)
      }
      if hasIcon and not hasId {
          emitDiag(iconLine, iconCol, "app icon requires an id property")
      }
  }
  func checkAppId(v: string, line: int, col: int) {
      var i: int
      var allLower: bool
      if v.length != 4 {
          emitDiag(line, col, "app id must be exactly 4 printable characters")
          return
      }
      allLower = true
      i = 0
      while i < 4 {
          if v[i] < ' ' or v[i] > '~' {
              emitDiag(line, col, "app id must be exactly 4 printable characters")
              return
          }
          if v[i] < 'a' or v[i] > 'z' { allLower = false }
          i = i + 1
      }
      if allLower {
          emitDiag(line, col, "app id must not be all lowercase")
      }
  }
  ```
  (Verify the exact accessor for an expr's chain link — the values list is chained via `ExprNode.next`; use the existing accessor (`exprNext` or equivalent) that `parseProperty`'s comma loop uses. Printable check: reuse however check.cla compares chars if `'~'` literals aren't idiomatic — grep for existing char comparisons.)
- [ ] **Step 6: Run tests, generate golden.** `go test ./internal/selfhost/ -run TestClarusModules` — inspect actual output for the new cases, verify each message + line:col is right, append to `check_test.out`, re-run to green.
- [ ] **Step 7: Reference docs.** In Ch7 (after the lifecycle handlers), add an "Application identity" subsection documenting the section (all properties optional, one section max, string literals only, id rules, icon path relative to declaring file, naming preference order). Add `AppDecl` to Appendix A EBNF alongside WindowDecl (label required, property list). Keep to the reference's existing voice.
- [ ] **Step 8: Snapshot regen + full suite.** Run the Global Constraints regen sequence, then `go build -o clarus ./cmd/clarus && go test ./...` — all green.
- [ ] **Step 9: Commit.** `git add -A && git commit -m "clarusc: parse + check the app declaration"`

---

### Task 2: clarusc emit — `rt_ui_app_info` strong definition; runtime type + weak default

**Files:**
- Modify: `clarusc/ir.cla` (module vars near :432, irReset :451)
- Modify: `clarusc/lower.cla` (lowDecl :2683, new lowAppDecl)
- Modify: `clarusc/cprint.cla` (new cpEmitAppInfo; the `#include "rt_ui.h"` gate at :2350; NOT `irIsUiProgram()` at :1900)
- Modify: `runtime/mac/rt_ui.h`, `runtime/mac/rt_ui.c`
- Create: `testdata/emitui/app_info.cla`, `testdata/emitui/app_info.c.golden`, `testdata/emitui/app_nonui.cla`, `testdata/emitui/app_nonui.c.golden`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `DkApp`, `appDeclPropsHead`, `propertyName`, `propertyValuesHead`, `stringLitIdx` (Task 1).
- Produces: in `rt_ui.h`:
  ```c
  typedef struct rt_ui_app_desc {
      const unsigned char *name;     /* Pascal; len 0 = no app section */
      const unsigned char *version;
      const unsigned char *author;
      const unsigned char *about;
  } rt_ui_app_desc;
  extern const rt_ui_app_desc rt_ui_app_info;
  ```
  Weak default in `rt_ui.c` (NOT inside `#ifdef RT_MAC_TEST` — this one exists in all builds):
  ```c
  __attribute__((weak)) const rt_ui_app_desc rt_ui_app_info = {
      (const unsigned char *)"\p", (const unsigned char *)"\p",
      (const unsigned char *)"\p", (const unsigned char *)"\p"
  };
  ```
  IR side: `var irAppName: int`, `irAppVersion: int`, `irAppAuthor: int`, `irAppAbout: int` (pool indices, -1 = absent), `var irHasApp: bool` — all reset in `irReset()`. Task 3 reads `rt_ui_app_info`; nothing reads icon/id from IR (build-time only).

- [ ] **Step 1: Write failing emit fixtures.** `testdata/emitui/app_info.cla`: the full `app` section (name/version/author/about — include a `"` or `\` in one value to exercise escaping; omit icon/id, they don't affect emission) + one window + one menu + `on App.launch { open ... }`. `testdata/emitui/app_nonui.cla`: `app` section + `on App.startCLI(args: list of string) { quit 0 }`, no window/menu. No goldens yet.
- [ ] **Step 2: Run to verify current behavior.** `go test ./internal/emitui/ -run TestEmitUiGoldens` — fixtures without goldens are skipped, so instead run clarusc directly to see the current hard abort:
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc-dev clarusc/main.cla
  /tmp/clarusc-dev emit -o /tmp/app_info.c testdata/emitui/app_info.cla
  ```
  Expected: abort via `lowUnsupported` ("declaration kind ...") — proving lowering must learn `DkApp`.
- [ ] **Step 3: ir.cla.** Add the 5 module vars near the `irHasLaunch` group (:432-435); clear all in `irReset()` (`-1`/`false`).
- [ ] **Step 4: lower.cla.** Branch in `lowDecl` (:2683): `else if k == DkApp { lowAppDecl(d) }`. Implementation — walk props, store pool indices (checker already validated; icon/id are deliberately ignored here):
  ```clarus
  func lowAppDecl(d: int) {
      var item: int
      var pname: string
      var vh: int
      irHasApp = true
      item = appDeclPropsHead(d)
      while item != -1 {
          pname = poolGet(propertyName(item))
          vh = propertyValuesHead(item)
          if pname == "name" { irAppName = stringLitIdx(vh) }
          if pname == "version" { irAppVersion = stringLitIdx(vh) }
          if pname == "author" { irAppAuthor = stringLitIdx(vh) }
          if pname == "about" { irAppAbout = stringLitIdx(vh) }
          item = declNext(item)
      }
  }
  ```
- [ ] **Step 5: cprint.cla.** (a) New `cpEmitAppInfo()` writing to **`cpRestBuf`** (unconditional buffer — an `app` section must emit for non-UI programs too; `cpUiBuf` is UI-gated):
  ```clarus
  func cpEmitAppInfo() {
      if not irHasApp { return }
      cpRestBuf.add(toText("const rt_ui_app_desc rt_ui_app_info = { " + cpUiTitleStr(irAppName) + ", " + cpUiTitleStr(irAppVersion) + ", " + cpUiTitleStr(irAppAuthor) + ", " + cpUiTitleStr(irAppAbout) + " };"))
  }
  ```
  Call it from `emitProgram` near the `cpEmitUiDescs()` call (:2342). (b) Widen ONLY the include gate (:2350): `if irIsUiProgram() or irHasApp { ... #include "rt_ui.h" ... }`. **Do not touch `irIsUiProgram()` itself** — widening it would route a CLI program into `cpEmitUiMain` (wrong `main()`).
- [ ] **Step 6: rt_ui.h / rt_ui.c.** Add the typedef + extern + weak default exactly as in Interfaces above. Place the weak default near the top of rt_ui.c's globals, OUTSIDE any `#ifdef RT_MAC_TEST`, with a comment mirroring the `rt_ui_test_script` weak-override contract (rt_ui.h:175-186).
- [ ] **Step 7: Generate + bless goldens.** Emit both fixtures with the freshly built clarusc, eyeball the output (strong `rt_ui_app_info` present; `app_nonui.c` has `#include "rt_ui.h"` but a plain CLI `main`, no `rt_ui_startup`), save as `.c.golden`. Run `go test ./internal/emitui/` — golden match + m68k compile check green.
- [ ] **Step 8: Regression: UI-free emission unchanged.** `git diff --stat testdata/` must show only the two new fixture pairs; run `go test ./...` — differential + snapshot-affecting suites green after regen (next step).
- [ ] **Step 9: Snapshot regen + full suite + commit.** Regen sequence; `go test ./...`; `git add -A && git commit -m "clarusc+rt_ui: emit rt_ui_app_info; weak runtime default"`

---

### Task 3: Runtime About box + scenario test

**Files:**
- Modify: `runtime/mac/rt_ui.c` (rt_ui_build_apple_menu :614-620, rt_ui_apple_select :622-633, stale comment :607-613)
- Create: `testdata/ui/about.cla`, `testdata/ui/about.events`, `testdata/ui/about.trace` (blessed), `testdata/uisnaps/` (none needed — no snap in this scenario)
- Modify: `internal/mactest/ui_test.go` (new test func)
- Modify: `docs/clarus-language-reference.md` (Ch9 About wording, ~line 954)

**Interfaces:**
- Consumes: `rt_ui_app_info` (Task 2).
- Produces: About behavior contract: `rt_ui_app_info.name[0] != 0` ⇒ Apple item 1 is `About <name>…` (MacRoman ellipsis `0xC9`) and selecting it does `ParamText(name, version, author, about); Alert(129, NULL);` in real builds, or emits trace line `ABOUT <name>|<version>|<author>|<about>` in `RT_MAC_TEST` builds. Empty name ⇒ exactly today's path (byte-identical goldens). ALRT/DITL 129 is supplied by build-mac.sh in Task 6 — the runtime just calls `Alert(129, NULL)`.

- [ ] **Step 1: Write the failing scenario.** `testdata/ui/about.cla`:
  ```
  app AboutProbe {
      name: "AboutProbe"
      version: "9.9"
      author: "Probe Author"
      about: "Probe about text."
      id: "PRBA"
  }
  window Main {
      title: "Main"
      size: 200, 100
  }
  on App.launch {
      open Main
  }
  ```
  `testdata/ui/about.events`:
  ```
  menu 1 1
  quit
  ```
  In `internal/mactest/ui_test.go`, add beside the existing scenario funcs:
  ```go
  func TestUIAbout(t *testing.T) { runUIScenario(t, "about", 0) }
  ```
- [ ] **Step 2: Run to verify failure.** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestUIAbout` — expect failure: no `about.trace` golden and no ABOUT trace emitted (Apple selection currently returns before any trace; in an RT_MAC_TEST build the modal NoteAlert path is what we're replacing).
- [ ] **Step 3: Implement rt_ui.c.** (a) `rt_ui_build_apple_menu`: when `rt_ui_app_info.name[0] != 0`, build the item as `About <name>…` in a `unsigned char buf[258]` (copy `"\pAbout "` prefix, append name bytes via its length byte, append `0xC9`, fix count byte — same buffer idiom as the `/K` append at :659-670), then `AppendMenu(gAppleMenu, buf); AppendMenu(gAppleMenu, (const unsigned char *)"\p-");` — else keep the existing single `AppendMenu(..."\pAbout This Application;-")`. Name is not escaped against AppendMenu metachars (`;/!<(`) — same disclosed limitation as menu captions (:658). (b) `rt_ui_apple_select` item 1:
  ```c
  if (itemNum == 1) {
      if (rt_ui_app_info.name[0] != 0) {
  #ifdef RT_MAC_TEST
          rt_ui_trace_about();   /* modal Alert would block the script reader */
  #else
          ParamText(rt_ui_app_info.name, rt_ui_app_info.version,
                    rt_ui_app_info.author, rt_ui_app_info.about);
          Alert(129, NULL);      /* plain Alert: never draws a system icon */
  #endif
      } else {
          ParamText(LMGetCurApName(), (const unsigned char *)"\p",
                    (const unsigned char *)"\p", (const unsigned char *)"\p");
          NoteAlert(128, NULL);
      }
      return;
  }
  ```
  `rt_ui_trace_about` (inside the existing `#ifdef RT_MAC_TEST` block): emit one trace line `ABOUT AboutProbe|9.9|Probe Author|Probe about text.` using the same emit path as the other `T `-prefixed trace lines (find the existing trace helper the FIRE lines use and match its framing exactly); convert each Pascal field with a local len-byte loop, `|`-joined. (c) Refresh the stale comment at :607-613 to describe both paths.
- [ ] **Step 4: Bless + verify.** `CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestUIAbout` to write `about.trace`; eyeball it (window-open lines + the ABOUT line with all four fields); re-run without BLESS to green.
- [ ] **Step 5: Regression — full UI suite, goldens byte-identical.** `CLARUS_MAC_TESTS=1 go test ./internal/mactest` (no BLESS). `git status` must show no modified goldens — only the three new `about.*` files and ui_test.go.
- [ ] **Step 6: Reference Ch9.** Replace the "About item shows the application's name only — a richer About dialog will come later" sentence: with an `app` section the About item reads `About <name>…` and shows name, version, author, about text, and the app icon; without one, the name-only behavior remains.
- [ ] **Step 7: Commit.** `git add -A && git commit -m "rt_ui: richer About box from rt_ui_app_info; about scenario"`

---

### Task 4: `clarusc appinfo` subcommand

**Files:**
- Modify: `clarusc/main.cla` (arg parsing :178-226, output block after check)
- Create: `internal/emitui/appinfo_test.go`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `DkApp`, `appDeclName`, `appDeclPropsHead`, `appDeclPathIdx` (Task 1); `dirOf`/`joinPath` (main.cla:52-75).
- Produces: `clarusc appinfo FILE...` — runs the full pipeline (parse + check, same as `check`); on any diagnostic prints them and exits 1. On success prints via `alert()` (stdout), in this fixed order, only lines that apply:
  ```
  app=1                      (only if an app section exists)
  name=<resolved>            (always: name prop > app label > basename of first file minus .cla)
  version=<v>                (only if declared)
  id=<XXXX>                  (only if declared)
  icon=<joined path>         (only if declared; joinPath(dirOf(<declaring file>), value))
  ```
  Task 6 parses exactly these `key=value` lines.

- [ ] **Step 1: Write the failing Go test.** `internal/emitui/appinfo_test.go`, reusing the package's existing build-clarusc-once helper (see `emitui_test.go:55-76`):
  - full fixture: run `clarusc appinfo testdata/emitui/app_info.cla`, assert exact stdout (app=1, name/version from the fixture; app_info.cla has no icon/id so no such lines).
  - label fallback: temp dir file `probe.cla` with `app Zap {}` + a trivial `startCLI` handler → `app=1\nname=Zap\n`.
  - filename fallback: temp `myprog.cla`, no app section → `name=myprog\n` (no `app=1`).
  - icon join: temp `sub/prog.cla` with `icon: "art/i.pbm"`, `id: "TEST"` → `icon=<tmp>/sub/art/i.pbm`.
  - error: file with `id: "bad"` → exit code 1, stderr/stdout contains the id diagnostic.
- [ ] **Step 2: Run to verify failure.** `go test ./internal/emitui/ -run TestAppInfo` — fails (`appinfo` is an unknown arg today, treated as a missing input file).
- [ ] **Step 3: Implement main.cla.** Add `appinfoMode` beside `emitMode` (`if args[0] == "appinfo" { appinfoMode = true; startArg = 1 }`); reuse the existing file-collection loop untouched. After the existing diag-print + `quit 1` gate (:277-279), before the emit block, add:
  ```clarus
  if appinfoMode {
      d = combined
      appIdx = -1
      while d != -1 {
          if declKind(d) == DkApp { appIdx = d }
          d = declNext(d)
      }
      resolved = ""
      if appIdx != -1 {
          alert("app=1")
          // scan props once into locals nameV/versionV/idV/iconV ("" = absent)
          ...walk appDeclPropsHead(appIdx) via propertyName/propertyValuesHead/stringLitIdx...
          if nameV != "" { resolved = nameV } else { resolved = poolGet(appDeclName(appIdx)) }
      }
      if resolved == "" { resolved = baseNameNoExt(fileArgs[0]) }
      alert("name=" + resolved)
      if versionV != "" { alert("version=" + versionV) }
      if idV != "" { alert("id=" + idV) }
      if iconV != "" { alert("icon=" + joinPath(dirOf(poolGet(appDeclPathIdx(appIdx))), iconV)) }
      quit 0
  }
  ```
  Add tiny `baseNameNoExt(path: string): string` (strip through last `/`, strip trailing `.cla` if present) near `dirOf`. Write the prop-scan loop out fully (the `...` above is shorthand for this plan only — the real code walks the chain exactly like `lowAppDecl` in Task 2). Note `emit` and `appinfo` are mutually exclusive modes; usage string becomes `usage: clarusc [emit -o OUT.c | appinfo] FILE...` in all three places it appears.
- [ ] **Step 4: Run tests.** `go test ./internal/emitui/ -run TestAppInfo` → green.
- [ ] **Step 5: Snapshot regen + full suite + commit.** Regen; `go test ./...`; `git add -A && git commit -m "clarusc: appinfo subcommand for build-time app metadata"`

---

### Task 5: `pbm2icn` converter

**Files:**
- Create: `scripts/pbm2icn.c`
- Create: `internal/mactest/pbm2icn_test.go` (NOT gated on CLARUS_MAC_TESTS — needs only `cc`)
- Create: `internal/mactest/testdata/icon_probe.pbm` (P1, 32×32, a ring shape: black circle with white hole — proves the mask keeps enclosed white opaque)

**Interfaces:**
- Produces: `pbm2icn ICON.pbm` → writes to stdout a complete Rez resource:
  ```
  resource 'ICN#' (128, purgeable) {
      {
          $"...", /* 32 rows x 4 bytes: the icon, 8 lines of 16 bytes */
          $"..."  /* the mask */
      }
  };
  ```
  Exit 1 with a one-line stderr message on: unreadable file, not P1/P4, dimensions ≠ 32×32. Task 6 shells this and appends stdout to `appres.r`.

- [ ] **Step 1: Write the failing test.** `pbm2icn_test.go`: compile `scripts/pbm2icn.c` with `cc` into `t.TempDir()`; run on `icon_probe.pbm`; assertions: output contains `resource 'ICN#' (128, purgeable)`; parse both hex blocks back to 128 bytes each; icon bytes equal the PBM bits; mask has 1s exactly where flood-fill-from-border of white pixels does NOT reach (for the ring: mask = filled disk — spot-check the center row: interior hole bits are 1 in mask, 0 in icon). Error cases: 16×16 PBM → exit 1; garbage file → exit 1. Also generate a P4 variant of the same image in the test and assert identical output to P1.
- [ ] **Step 2: Run to verify failure.** `go test ./internal/mactest -run TestPbm2Icn` — fails (no such file).
- [ ] **Step 3: Implement `scripts/pbm2icn.c`** (~120 lines, plain C99, no deps):
  - Parse header: magic `P1` or `P4`, skip `#` comments and whitespace, read width/height, require both 32.
  - P1: read 1024 ASCII bits (`0`/`1`, whitespace/comments between allowed). P4: after the single whitespace byte post-height, read 128 raw bytes (4 per row, MSB first — already ICN# bit order).
  - Icon bitmap: 128 bytes, bit=1 means black (PBM and ICN# agree).
  - Mask: BFS/DFS flood fill over the 32×32 grid seeded with every WHITE border pixel; 4-connectivity; visited-white = exterior. `mask[bit] = !(white && exterior)` — i.e. everything except reachable-outside white. (`/* ponytail: 4-connectivity silhouette mask; add an explicit mask: property if an icon ever needs designed transparency */`)
  - Emit the Rez text: each 128-byte block as 8 lines of `$"XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX"` (16 bytes/line, uppercase hex, space every 2 bytes), comma between the two array elements.
- [ ] **Step 4: Run tests to green.** `go test ./internal/mactest -run TestPbm2Icn`
- [ ] **Step 5: Commit.** `git add -A && git commit -m "scripts: pbm2icn - 32x32 PBM to ICN# Rez resource"`

---

### Task 6: build-mac.sh — naming, appres.r, creator, bundle bit

**Files:**
- Modify: `scripts/build-mac.sh`
- Create: `scripts/setbundle.c`
- Create: `testdata/ui/appres.cla`, `testdata/ui/appres-icon.pbm` (any 32×32 shape with an enclosed hole)
- Modify: `internal/mactest/mac_test.go` or new `internal/mactest/appres_test.go` (gated tests)

**Interfaces:**
- Consumes: `clarusc appinfo` output (Task 4), `pbm2icn` (Task 5), `rt_ui_app_info` emission (Task 2).
- Produces: build-mac.sh behavior: `build-mac.sh Name files...` unchanged for all existing callers; `build-mac.sh files.cla...` (first arg ends in `.cla`) derives NAME from appinfo, sanitized (`[^A-Za-z0-9_-]` → `-`). When `app=1`: generates `$OUT/appres.r` (about ALRT/DITL 129 + optional icon item, `vers`, and — when icon declared — `ICN#`/`BNDL`/`FREF`/signature), passes `TYPE "APPL" CREATOR "<id>"` to add_application, and post-stamps the bundle bit on the `.dsk`. `setbundle IMAGE.dsk FILENAME` sets `HFS_FNDR_HASBUNDLE` and clears `HFS_FNDR_HASBEENINITED`; `setbundle -q IMAGE.dsk FILENAME` prints the fdflags word in hex (for tests).

- [ ] **Step 1: Fixture.** `testdata/ui/appres.cla` (nothing globs testdata/ui — safe for clarusc-only syntax):
  ```
  app AppResProbe {
      name: "App Res Probe"
      version: "2.5"
      author: "Probe Author"
      about: "Resource probe."
      icon: "appres-icon.pbm"
      id: "PRBR"
  }
  window Main {
      title: "Main"
      size: 200, 100
  }
  on App.launch {
      open Main
  }
  ```
  Draw `appres-icon.pbm` as P1 by hand (e.g. a 32×32 hollow square: rows 4-27, cols 4-27 black border 4px thick, white center — enclosed white proves mask handling later if eyeballed in Finder).
- [ ] **Step 2: Write the failing gated tests** (in `internal/mactest`, using `requireMac(t)` since they need the Retro68 toolchain, but NOT the emulator):
  - `TestAppResNaming`: run `scripts/build-mac.sh ../../testdata/ui/appres.cla --test` (via the same exec pattern as `runBuildMac` but WITHOUT the name arg); assert `build-mac/App-Res-Probe/App-Res-Probe.bin` exists (sanitized name derived).
  - `TestAppResResources`: after that build, assert `build-mac/App-Res-Probe/appres.r` contains `resource 'ALRT' (129`, `resource 'vers' (1`, `resource 'BNDL' (128`, `'PRBR'`, and `resource 'ICN#' (128`; assert the generated CMakeLists.txt contains `CREATOR "PRBR"`.
  - `TestAppResBundleBit`: compile `scripts/setbundle.c` (test does it directly, same as pbm2icn test), run `setbundle -q build-mac/App-Res-Probe/App-Res-Probe.dsk "App Res Probe"` → flags word has bit 13 (0x2000) set and bit 8 (0x0100, inited) clear. (File inside the dsk is named by Rez from the output stem — verify actual name with `toolchain/bin/hls`; adjust the test's FILENAME arg to what Rez actually wrote, likely `App-Res-Probe`.)
  - `TestUIScenariosUnchanged` is not a new test — just re-run the whole existing gated suite in Step 6.
- [ ] **Step 3: Run to verify failure.** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestAppRes` — naming test fails (build-mac.sh treats `../../testdata/ui/appres.cla` as NAME).
- [ ] **Step 4: Implement `scripts/setbundle.c`.** ~50 lines: args `[-q] image path`; `hfs_mount(argv[i], 0, HFS_MODE_RDWR)` (partition 0), `hfs_stat`, then either print `%04x` of `ent.fdflags` (`-q`) or `ent.fdflags = (ent.fdflags | 0x2000) & ~0x0100; hfs_setattr; hfs_umount`. Use the numeric masks with a comment naming `HFS_FNDR_HASBUNDLE`/`HASBEENINITED` if including `hfs.h` proves awkward. Compile/link strategy, in order: (1) look for a built `libhfs.a` under `Retro68-build/` (`find "$ROOT/../Retro68-build" -name 'libhfs*.a'`) and `-I Retro68/hfsutils/libhfs`; (2) fallback: compile libhfs sources directly (`cc scripts/setbundle.c Retro68/hfsutils/libhfs/*.c -I Retro68/hfsutils/libhfs`) — check how hattrib links in the Retro68 build tree and mirror it. Cache the binary like the clarusc bootstrap (`build-mac/setbundle`, rebuilt when sources newer). If neither approach links cleanly in ~30 min, STOP and report back rather than hacking — the task boundary is: bundle bit set on .dsk via a cached helper.
- [ ] **Step 5: Implement build-mac.sh.** Restructure:
  1. Arg parse: if `$1` is `*.cla`, leave NAME empty and treat all non-flag args as FILES; else `NAME="$1"; shift` as today.
  2. Bootstrap clarusc (existing block, moved before naming).
  3. `APPINFO="$("$CLARUSC" appinfo "${FILES[@]}")"` — always run; extract `RAWNAME=$(sed -n 's/^name=//p')`, `HASAPP`, `VERSION`, `APPID`, `ICONPBM` similarly. If NAME still empty: `NAME=$(printf '%s' "$RAWNAME" | sed 's/[^A-Za-z0-9_-]/-/g')`.
  4. If `HASAPP`: write `$OUT/appres.r`:
     ```
     #include "MacTypes.r"
     #include "Dialogs.r"
     resource 'ALRT' (129, purgeable) {
         {40, 40, 220, 460}, 129,
         { OK, visible, silent, OK, visible, silent,
           OK, visible, silent, OK, visible, silent },
         alertPositionMainScreen
     };
     resource 'DITL' (129, purgeable) {
         {
             {150, 350, 170, 410}, Button { enabled, "OK" },
             {13, 70, 29, 410},   StaticText { disabled, "^0  ^1" },
             {33, 70, 49, 410},   StaticText { disabled, "^2" },
             {60, 20, 140, 410},  StaticText { disabled, "^3" }ICONITEM
         }
     };
     resource 'vers' (1, purgeable) {
         0x1, 0x0, release, 0x0, verUS,
         "$VERSION",
         "$RAWNAME $VERSION"
     };
     ```
     where ICONITEM expands to `,\n            {13, 20, 45, 52},   Icon { disabled, 128 }` only when ICONPBM is set (and the `vers` resource is skipped when VERSION is empty). When ICONPBM is set, also append:
     ```
     #include "Finder.r"
     #include "Icons.r"
     type '$APPID' as 'STR ';
     resource '$APPID' (0, purgeable) { "$RAWNAME $VERSION" };
     resource 'FREF' (128, purgeable) { 'APPL', 0, "" };
     resource 'BNDL' (128, purgeable) {
         '$APPID', 0,
         { 'ICN#', { 0, 128 }, 'FREF', { 0, 128 } }
     };
     ```
     plus `pbm2icn "$ICONPBM" >> $OUT/appres.r` (compile-and-cache pbm2icn like the clarusc bootstrap). Local-ID semantics: the FREF's second field (icon local ID, here 0) must match a local ID in the BNDL's `'ICN#'` map (here 0 → actual ICN# 128); the local IDs in the BNDL's `'FREF'` map are arbitrary labels (LaunchAPPLServer uses 10, 0 is equally valid — keep 0).
  5. CMakeLists: `add_application($NAME TYPE "APPL" CREATOR "${APPID:-????}" $NAME.c ... alert.r $APPRES $EXTRA_SRC)` where `$APPRES` is `$OUT/appres.r` or empty.
  6. After the copy loop: if ICONPBM set, `"$SETBUNDLE" "$OUT/$NAME.dsk" "<file name inside dsk>"` (Rez names it from the output stem; confirm with hls and hardcode the same stem logic).
- [ ] **Step 6: Run gated tests + full regression.** `CLARUS_MAC_TESTS=1 go test ./internal/mactest` — new tests green, ALL existing scenario goldens byte-identical (they pass NAME positionally and have no app section except about.cla/mandelbrot — about.cla has an `app` section, so its build now also generates appres.r; its trace golden must not change since resources don't affect the trace).
- [ ] **Step 7: Commit.** `git add -A && git commit -m "build-mac: app-driven naming, about/vers/icon resources, bundle bit"`

---

### Task 7: Mandelbrot app section + icon

**Files:**
- Create: `examples/mandelbrot.pbm` (32×32 P1)
- Modify: `examples/mandelbrot.cla`
- Modify: `docs/ROADMAP.md` only if it tracks feature status lines for 4b/samples (one-line addition; skip if no natural slot)

**Interfaces:**
- Consumes: everything above.

- [ ] **Step 1: Generate the icon.** Write a throwaway host program (Go or C, run from the scratchpad — do NOT commit it) computing the standard escape-time Mandelbrot on a 32×32 grid over x ∈ [-2.1, 0.9], y ∈ [-1.5, 1.5], 32 iterations; pixel black iff still bounded (|z|² ≤ 4) after 32 iterations. Emit P1 with a comment line `# Mandelbrot set silhouette, 32x32`. Save as `examples/mandelbrot.pbm`. Eyeball the ASCII bits — the cardioid + period-2 bulb must be recognizable.
- [ ] **Step 2: Add the app section** at the top of `examples/mandelbrot.cla` (after the header comment, before `const BUDGET`):
  ```
  app Mandelbrot {
      name: "Mandelbrot"
      version: "1.0"
      author: "Andrew C. Young <andrew@vaelen.org>"
      about: "An example Clarus application that displays the Mandelbrot set in a window."
      icon: "mandelbrot.pbm"
      id: "MNDL"
  }
  ```
- [ ] **Step 3: Full regression.** `go test ./...` and `CLARUS_MAC_TESTS=1 go test ./internal/mactest` — the existing mandelbrot UI scenario builds this file via clarusc; its trace/snap goldens must remain byte-identical (the app section adds a strong `rt_ui_app_info` and appres.r, neither of which the scenario's events touch — no `menu 1 1` in its script).
- [ ] **Step 4: Real build smoke.** `scripts/build-mac.sh examples/mandelbrot.cla` (no NAME arg) — must produce `build-mac/Mandelbrot/Mandelbrot.{bin,APPL,dsk}` with appres.r containing the ICN#.
- [ ] **Step 5: Commit.** `git add -A && git commit -m "examples: mandelbrot app section + icon"`

---

### Final validation (top-level session, after all tasks)

Manual, performed by the dispatching session, not a subagent:
1. `toolchain/bin/LaunchAPPL -e minivmac build-mac/Mandelbrot/Mandelbrot.bin` (background), screenshot the emulator, open Apple menu → `About Mandelbrot…`, screenshot the About box against the approved layout, click OK, quit.
2. Finder-mode emulator (per CLAUDE.md: copy MacPlus.app, boot System disk as disk1, `build-mac/Mandelbrot/Mandelbrot.dsk` as disk2), screenshot the desktop — the Mandelbrot ICN# must show on the mounted disk's app.
3. Whole-branch review, then merge on request.
