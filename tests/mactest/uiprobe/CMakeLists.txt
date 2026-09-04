cmake_minimum_required(VERSION 3.9)
project(UIProbe C)
set(CLARUS_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../../..)
add_definitions(-I${CLARUS_ROOT}/runtime/mac -I${CLARUS_ROOT}/runtime/host)

# Task 3 (mac-target-4b): -DRT_MAC_TEST=1 builds the capture-stream/trace/
# scripted-event variant of this same probe app; -DUI_EVENTS=<path/to/foo.c>
# additionally links a compiled-in event script (see events.c, a committed
# sample) whose strong `rt_ui_test_script` definition overrides rt_ui.c's
# weak empty default. Both default off, so a plain `cmake -S ...` with
# neither flag builds the exact same real-input, non-test probe Task 1/2
# already verified.
option(RT_MAC_TEST "build the RT_MAC_TEST capture/trace/scripted-event variant" OFF)
if(RT_MAC_TEST)
  add_definitions(-DRT_MAC_TEST=1)
endif()
set(UI_EVENTS "" CACHE FILEPATH "optional events.c overriding rt_ui_test_script")
set(UIPROBE_EXTRA_SOURCES "")
if(UI_EVENTS)
  list(APPEND UIPROBE_EXTRA_SOURCES ${UI_EVENTS})
endif()

add_application(UIProbe probe_ui.c
    ${CLARUS_ROOT}/runtime/mac/rt_ui.c
    ${CLARUS_ROOT}/runtime/mac/rt_mac.c
    ${CLARUS_ROOT}/runtime/mac/alert.r
    ${UIPROBE_EXTRA_SOURCES})
