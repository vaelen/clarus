# Makefile -- Clarus test runner (go-retirement phase). GNU Make 3.81.
# make t1 | make t2 | make test T='cg68k/goldens bake/' | make smoke
CC ?= cc
BR := build-run
J ?= $(shell sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

TOOL_SRCS := $(wildcard tests/tools/*.c)
TOOLS := $(patsubst tests/tools/%.c,$(BR)/tools/%,$(TOOL_SRCS))
RT_HOST := $(wildcard runtime/host/*)
CLA_SRC := $(wildcard clarusc/*.cla) $(wildcard runtime/clarus/*.cla)

TESTS := $(shell find tests -name '*.sh' ! -name 'lib*.sh' ! -name run1.sh ! -name summary.sh | sort)
T ?=
SEL := $(foreach p,$(T),$(filter tests/$(p)%,$(TESTS)))
T1 := $(filter-out tests/selfhost/% tests/perfgate/%,$(TESTS))
RES = $(patsubst tests/%.sh,$(BR)/tests/%.result,$(1))

.PHONY: tools bootstrap test t1 t2 smoke
tools: $(TOOLS)
bootstrap: $(BR)/clarusc-current

# atalkdrive is the one tool that links the host runtime: it drives
# rt_atalk.inc's LToUDP stack (Task 2), which lives inside rt.c. Explicit
# rule, above the generic one, so `make -j tools` still builds every tool.
$(BR)/tools/atalkdrive: tests/tools/atalkdrive.c runtime/host/rt.c $(RT_HOST)
	@mkdir -p $(BR)/tools
	$(CC) -std=c99 -Wall -Werror -I runtime/host -o $@ $< runtime/host/rt.c

$(BR)/tools/%: tests/tools/%.c
	@mkdir -p $(BR)/tools
	$(CC) -std=c99 -Wall -Werror -o $@ $<

# Two-stage bootstrap, mirroring internal/claruscboot: the committed C
# snapshot builds clarusc-snapshot; that emits the current .cla source to
# C, which builds clarusc-current. mtime deps replace the Go stamp files;
# make's scheduling replaces the flock (every test depends on bootstrap).
$(BR)/clarusc-snapshot: clarusc/clarusc.c $(RT_HOST)
	@mkdir -p $(BR)
	$(CC) -O1 -I runtime/host -o $@.tmp clarusc/clarusc.c runtime/host/rt.c && mv $@.tmp $@

$(BR)/clarusc-current: $(BR)/clarusc-snapshot $(CLA_SRC)
	$(BR)/clarusc-snapshot emit --rtdir runtime/clarus/ -o $@.c clarusc/main.cla
	$(CC) -O1 -I runtime/host -o $@.tmp $@.c runtime/host/rt.c && mv $@.tmp $@

# Every result is rebuilt on every run (FORCE): there is no result cache.
$(BR)/tests/%.result: tests/%.sh FORCE | tools bootstrap
	@tests/run1.sh $< $@
FORCE:

test: $(call RES,$(SEL))
	@tests/summary.sh $^
# t1 runs every group but selfhost/ and perfgate/ IN PARALLEL -- every
# tests/mactest/** script included. Those gated groups are MEANT to
# self-skip here (require_env on CLARUS_MAC_TESTS / CLARUS_SNOW_TESTS /
# CLARUS_CPRINT_MAC_TESTS / CLARUS_BENCH68K): an inherited gate variable
# would boot several emulators at once, each fighting for the one screen.
# So the wrappers (scripts/test-task.sh, scripts/test-merge.sh) and t2
# below strip those four with `env -u` before the parallel body; the later
# serial stages set them back explicitly and run -j1.
t1: $(call RES,$(T1))
	@tests/summary.sh $^
smoke:
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T='mactest/smoke_bounce mactest/tick'
# The wrappers duplicate these stages for per-stage timing -- keep in sync
# with scripts/test-merge.sh.
t2:
	env -u CLARUS_MAC_TESTS -u CLARUS_SNOW_TESTS -u CLARUS_CPRINT_MAC_TESTS -u CLARUS_BENCH68K $(MAKE) -j$(J) t1
	$(MAKE) test T=perfgate/
	$(MAKE) test T=selfhost/
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T=mactest/
	CLARUS_BAKE_FULL=1 $(MAKE) -j$(J) test T=bake/full_corpus_
