### Task 3: Front end — `service` type, browser/listener additions, `string(addr)`, reference text

Checker/parser only; lowering stays fenced (every new shape still aborts with the existing `lowUnsupported` text). Zero golden churn.

**Files:**
- Modify: `clarusc/types.cla:38-53` (add `TyService` after `TyServiceBrowser`), `clarusc/check.cla` (§ refs below), `clarusc/lower.cla:371-441` (`lowTypeAt` only), `docs/clarus-language-reference.md` (Connections, Listeners, Service Discovery, new Services section, Chapter 3 conversions + type table rows), `tests/reftest/manifest.txt`.
- Read first: `clarusc/check.cla:36-54, 475-486, 566-568, 785-799, 1041-1042, 1101-1112, 1337-1339, 1656-1678, 2245-2267, 2350, 4309-4356, 5844-5900`; `tests/lib_reftest.sh`, `tests/reftest/manifest.txt` header.

**Interfaces:**
- Produces (checker): `TyService`; `serviceT: int` singleton (allocated in `checkReset` beside `connectionT`); `serviceMethods` table: `serve(string, string)`, `reply(psOneOf2(TyText, TyStr))` with a leading `int`, `stop()`, `call(psOneOf2(TyStr, TyAddress), int, text, text): bool`; events `service.request(op: int, req: text, from: address)`, `service.failed(err: error)`; `listenerMethods["stop"]`; `serviceBrowserMethods["find"]` accepting 1 or 2 string args — `checkTableMethod` has no overloads, so register the 2-arg form under the key `"find/2"` and make `checkTableMethod` look up `sel + "/" + argc` before `sel` (a 3-line change that every future overload reuses); `serviceBrowserMethods["zones"](list of string)`; event `serviceBrowser.done` (0 params); `usesAtalk: bool` set in `resolveType` for `listener`/`serviceBrowser`/`service`/`address` names and in `checkCall` for transport tag 1; `isResourceKind` includes `TyService`; `checkConversion`'s `name == "string"` arm additionally accepts `TyAddress` (message becomes `an int, char, or address`).
- Produces (lowering, `lowTypeAt`): `case TyAddress { return irIntT }`, `case TyListener`, `case TyServiceBrowser`, `case TyService` → `irIntT` (1-based handle ints, `nil` = 0, exactly `TyConnection`'s convention).
- Produces (reference): the normative text for spec §4.1–4.5 and §4.7's serial values are NOT here (Task 4); the host lifetime paragraph is NOT here (Task 5).

- [ ] **Step 1: Write failing checker fixtures**

In `testdata/errors/` (`.cla` + `.expect`, the group's existing pairs show the expected-text format) and `testdata/valid/`: `atalk_ok.cla` in `testdata/valid/` (a full server + client + browser + listener program using every new method/event, check-clean), and in `testdata/errors/`: `svc_reply_type.cla` (`svc.reply("x", 1)` → `argument 1: expected int`-style diagnostic, whatever the table diagnostic already says for `connection.send`), `brs_find3.cla` (`b.find("a","b","c")` → arity diagnostic), `addr_string.cla` (`string(addr)` check-clean; `string(l)` on a listener → `string() expects an int, char, or address, got listener`). Run: expected FAIL (unknown type `service`).

- [ ] **Step 2: Implement types/check/lowTypeAt**

Follow the excerpts: enum member; `var serviceT: int` + `checkReset` allocation; `var serviceMethods: map of int` + registration block after `serviceBrowserMethods["find"]`; `addEvent("service.request", ...)` with params `op: IntT`, `req: TextT`, `from: AddressT` (build the chain with `newEventParam` last-to-first like `serviceBrowser.found`), `addEvent("service.failed", ...)`, `addEvent("serviceBrowser.done", -1, 0)`; the `checkTopHandlerDecl` ladder gains `else if k == TyService { ctx = "service" }`; method dispatch gains `checkTableMethod(serviceMethods, sel, argsHead)`; `resolveType`'s `TxNamed` arm sets `usesAtalk` for the four names (`address` too — `string(addr)` needs the runtime); `checkCall` sets `usesAtalk = true` when `transport == 1`; `isResourceKind` adds `TyService`; `checkConversion` string arm; `lowTypeAt` cases.

- [ ] **Step 3: Reference text**

Rewrite Chapter 12's Connections (add the `appletalk`/`address` open forms and ADSP event semantics from spec §4.1, the 8-slot cap), Listeners (`register` semantics, `stop`, deny-when-full, `listen(port)` still MacTCP), Service Discovery (`find(type[, zone])`, `found` then `done`, `zones(out)`, `find("=")`, `string(addr)`), and add a **Services** section after Service Discovery with spec §4.4 verbatim in reference voice, including the enum-guard example. Chapter 3: `service` in the resource rows and the `nil` row; `address` stays "opaque, inline" with the `AddrBlock` layout note; conversions gain `string(addr)`. Every new ```rust fence must check clean standalone; add each new fence's index to `tests/reftest/manifest.txt` (indices shift — re-derive with `tests/lib_reftest.sh`'s `fences` helper and fix every shifted entry; `tests/reftest/required.sh` locates programs by content so it is unaffected).

- [ ] **Step 4: Gate + commit**

Run: `make test T=reftest/ T=lowlevel/ T=selfhost/diag` then `scripts/test-task.sh --smoke`. Expected: PASS, zero golden churn (no emission path changed).
```bash
git add clarusc/types.cla clarusc/check.cla clarusc/lower.cla docs/clarus-language-reference.md tests/reftest/manifest.txt testdata/ tests/
git commit -m "feat(check): service resource type, browser zones/done/find(type, zone), listener.stop, string(addr); reference text"
```

---

