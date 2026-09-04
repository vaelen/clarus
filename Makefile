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
t1: $(call RES,$(T1))
	@tests/summary.sh $^
smoke:
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T='mactest/smoke_bounce mactest/tick'
t2:
	$(MAKE) -j$(J) t1
	$(MAKE) test T=perfgate/
	$(MAKE) test T=selfhost/
	CLARUS_MAC_TESTS=1 $(MAKE) -j1 test T=mactest/
	CLARUS_BAKE_FULL=1 $(MAKE) -j$(J) test T=bake/full_corpus_
