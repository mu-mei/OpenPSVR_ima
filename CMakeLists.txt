cmake_minimum_required(VERSION 3.2)
project(OpenPSVR VERSION 0.1.0)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(THIRD_PARTY "${ROOT_DIR}/third_party" CACHE PATH "Path to prebuilt third-party dependencies.")

if (NOT EXISTS "${THIRD_PARTY}")
    message(FATAL_ERROR
        "Third-party dependencies were not found at '${THIRD_PARTY}'. "
        "Populate this directory with OpenVR, GLM, libusb, and libpsvr, or "
        "configure -DTHIRD_PARTY=/path/to/third_party before running CMake.")
endif()

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
				set(LIBPSVR_REQ_LIB ${THIRD_PARTY}/libpsvr/src/libpsvr/libpsvr.lib)
				set(LIBPSVR_INCL_DIR ${THIRD_PARTY}/libpsvr/src/libpsvr)
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.lib)
				set(LIBUSB_REQ_SHARED_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.dll)
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/include/libusb-1.0)
        elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") # OSX
				# TODO add OSX dependencies
        else()# Linux
				set(LIBPSVR_REQ_LIB ${THIRD_PARTY}/libpsvr/src/libpsvr/build/Linux64/libpsvr/liblibpsvr.so)
				set(LIBPSVR_INCL_DIR ${THIRD_PARTY}/libpsvr/src/libpsvr/include)
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb-build/libusb/.libs/libusb-1.0.so)
				set(LIBUSB_REQ_SHARED_LIB ${LIBUSB_REQ_LIB})
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/libusb)
        endif()
endif()

# OpenVR Cross-platform Dependency

# GLM Cross-platform Dependency
set(GLM_INCL_DIR ${THIRD_PARTY}/glm/src/glm/glm)

add_subdirectory(src)
