# - try to find libpsvr
#
# Cache Variables:
#  LIBPSVR_INCLUDE_DIR
#  LIBPSVR_LIBRARY
#
# Non-cache variables you might use in your CMakeLists.txt:
#  LIBPSVR_FOUND
#  LIBPSVR_INCLUDE_DIR
#  LIBPSVR_LIBRARY
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs

message(STATUS "Finding libpsvr, CMAKE_CURRENT_LIST_DIR=${CMAKE_CURRENT_LIST_DIR}/../third_party/libpsvr")

if (LIBPSVR_INCLUDE_DIR AND LIBPSVR_LIBRARY)
    set(LIBPSVR_FOUND TRUE)
else()
    set(LIBPSVR_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../third_party/libpsvr)

    find_path(LIBPSVR_INCLUDE_DIR
        NAMES
            psvr.h
        PATHS
            ${LIBPSVR_ROOT_DIR}/include
            /usr/local/include)

    find_library(LIBPSVR_LIBRARY
        NAMES
            libpsvr psvr
        PATHS
            ${LIBPSVR_ROOT_DIR}/lib
            /usr/local/lib)

    include(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBPSVR DEFAULT_MSG LIBPSVR_LIBRARY LIBPSVR_INCLUDE_DIR)

    mark_as_advanced(LIBPSVR_INCLUDE_DIR LIBPSVR_LIBRARY)
endif()
