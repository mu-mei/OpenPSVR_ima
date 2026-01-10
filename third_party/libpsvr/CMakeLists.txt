cmake_minimum_required(VERSION 3.2)

project(libpsvr LANGUAGES C)

add_library(psvr STATIC
    src/psvr.c
)

add_library(libpsvr ALIAS psvr)

target_include_directories(psvr
    PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/include
)

set_target_properties(psvr PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    OUTPUT_NAME "psvr"
)
