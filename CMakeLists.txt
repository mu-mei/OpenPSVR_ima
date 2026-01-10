cmake_minimum_required(VERSION 3.2)
project(OpenPSVR VERSION 0.1.0)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(THIRD_PARTY ${ROOT_DIR}/third_party)
set(LIBPSVR_ROOT ${ROOT_DIR}/third_party/libpsvr)
set(OPENPSVR_OUTPUT_ROOT "${ROOT_DIR}/build" CACHE PATH "Output root for OpenPSVR install artifacts.")

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
set(CMAKE_CXX_STANDARD_17)
set(CMAKE_CXX_STANDARD_REQUIRED_ON)
IF (NOT MSVC)
    set(CMAKE_CXX_FLAGS "-std=c++11")
    IF (NOT CMAKE_COMPILER_IS_GNUCXX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
    ENDIF()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-switch")
ENDIF()

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Configure and build platform specific external 3rdParty projects from their respective released packages
if (${CMAKE_C_SIZEOF_DATA_PTR} EQUAL 8) # 64-bit
        if(${CMAKE_SYSTEM_NAME} MATCHES "Windows") # Windows
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.lib)
				set(LIBUSB_REQ_SHARED_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.dll)
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/include/libusb-1.0)
        elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") # OSX
				# TODO add OSX dependencies
        else()# Linux
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb-build/libusb/.libs/libusb-1.0.so)
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/libusb)
        endif()
endif()

# OpenVR Cross-platform Dependency
set(OPENVR_ROOT_DIR ${THIRD_PARTY}/openvr)
if (NOT EXISTS "${OPENVR_ROOT_DIR}")
    message(FATAL_ERROR "OpenVR was not found at ${OPENVR_ROOT_DIR}. Populate third_party/openvr.")
endif()

# GLM Cross-platform Dependency
set(GLM_INCL_DIR ${THIRD_PARTY}/glm/glm)
if (NOT EXISTS "${GLM_INCL_DIR}")
    message(FATAL_ERROR "GLM headers were not found at ${GLM_INCL_DIR}. Populate third_party/glm.")
endif()

if (NOT EXISTS "${LIBPSVR_ROOT}/CMakeLists.txt")
    message(FATAL_ERROR "libpsvr source was not found at ${LIBPSVR_ROOT}. Populate third_party/libpsvr with source and headers.")
endif()

add_subdirectory(${LIBPSVR_ROOT})

add_subdirectory(src)
