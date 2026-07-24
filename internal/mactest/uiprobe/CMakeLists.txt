cmake_minimum_required(VERSION 3.9)
project(UIProbe C)
set(CLARUS_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../../..)
add_definitions(-I${CLARUS_ROOT}/runtime/mac -I${CLARUS_ROOT}/internal/build/rt)
add_application(UIProbe probe_ui.c
    ${CLARUS_ROOT}/runtime/mac/rt_ui.c
    ${CLARUS_ROOT}/runtime/mac/rt_mac.c
    ${CLARUS_ROOT}/runtime/mac/alert.r)
