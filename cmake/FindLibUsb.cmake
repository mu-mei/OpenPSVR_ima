# - try to find libusb
#
# Cache Variables:
#  LIBUSB_INCLUDE_DIR
#  LIBUSB_LIBRARY
#
# Non-cache variables you might use in your CMakeLists.txt:
#  LIBUSB_FOUND
#  LIBUSB_INCLUDE_DIR
#  LIBUSB_LIBRARY
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs

message(STATUS "Finding libusb, CMAKE_CURRENT_LIST_DIR=${CMAKE_CURRENT_LIST_DIR}/../third_party/libusb")

if (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARY)
    set(LIBUSB_FOUND TRUE)
else()
    set(LIBUSB_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../third_party/libusb)

    find_path(LIBUSB_INCLUDE_DIR
        NAMES
            libusb.h
        PATHS
            ${LIBUSB_ROOT_DIR}/include/libusb-1.0
            /usr/local/include/libusb-1.0)

    find_library(LIBUSB_LIBRARY
        NAMES
            usb-1.0 libusb-1.0
        PATHS
            ${LIBUSB_ROOT_DIR}/lib
            ${LIBUSB_ROOT_DIR}/lib64
            ${LIBUSB_ROOT_DIR}/MS64/dll
            ${LIBUSB_ROOT_DIR}/MS32/dll
            /usr/local/lib)

    include(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBUSB DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_INCLUDE_DIR)

    mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARY)
endif()
