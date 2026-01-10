cmake_minimum_required(VERSION 3.2)
project(OpenPSVR VERSION 0.1.0)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(THIRD_PARTY ${ROOT_DIR}/third_party)
set(LIBPSVR_ROOT ${ROOT_DIR}/third_party/libpsvr)
set(OPENVR_ROOT_DIR ${THIRD_PARTY}/openvr)
set(GLM_ROOT_DIR ${THIRD_PARTY}/glm)
set(LIBUSB_ROOT_DIR ${THIRD_PARTY}/libusb)
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
				set(LIBPSVR_INCL_DIR ${LIBPSVR_ROOT}/include)
				set(LIBPSVR_LIB_DIR ${LIBPSVR_ROOT}/lib)
				set(LIBPSVR_REQ_LIB "")
				foreach(LIBPSVR_LIB_CANDIDATE
						${LIBPSVR_LIB_DIR}/libpsvr.lib
						${LIBPSVR_LIB_DIR}/psvr.lib)
					if (EXISTS ${LIBPSVR_LIB_CANDIDATE})
						set(LIBPSVR_REQ_LIB ${LIBPSVR_LIB_CANDIDATE})
						break()
					endif()
				endforeach()
				if (NOT EXISTS ${LIBPSVR_INCL_DIR})
					message(FATAL_ERROR "libpsvr headers not found at ${LIBPSVR_INCL_DIR}. Place the headers under third_party/libpsvr/include.")
				endif()
				if (NOT LIBPSVR_REQ_LIB)
					message(FATAL_ERROR "libpsvr library not found under ${LIBPSVR_LIB_DIR}. Place libpsvr binaries under third_party/libpsvr/lib.")
				endif()
				set(LIBUSB_REQ_LIB ${LIBUSB_ROOT_DIR}/MS64/dll/libusb-1.0.lib)
				set(LIBUSB_REQ_SHARED_LIB ${LIBUSB_ROOT_DIR}/MS64/dll/libusb-1.0.dll)
				set(LIBUSB_INCL_DIR ${LIBUSB_ROOT_DIR}/include/libusb-1.0)
				if (NOT EXISTS ${LIBUSB_INCL_DIR})
					message(FATAL_ERROR "libusb headers not found at ${LIBUSB_INCL_DIR}. Place the headers under third_party/libusb/include/libusb-1.0.")
				endif()
				if (NOT EXISTS ${LIBUSB_REQ_LIB})
					message(FATAL_ERROR "libusb library not found at ${LIBUSB_REQ_LIB}. Place libusb binaries under third_party/libusb/MS64/dll.")
				endif()
        elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") # OSX
				# TODO add OSX dependencies
        else()# Linux
				set(LIBPSVR_INCL_DIR ${LIBPSVR_ROOT}/include)
				set(LIBPSVR_LIB_DIR ${LIBPSVR_ROOT}/lib)
				set(LIBPSVR_REQ_LIB "")
				foreach(LIBPSVR_LIB_CANDIDATE
						${LIBPSVR_LIB_DIR}/libpsvr.so
						${LIBPSVR_LIB_DIR}/libpsvr.a)
					if (EXISTS ${LIBPSVR_LIB_CANDIDATE})
						set(LIBPSVR_REQ_LIB ${LIBPSVR_LIB_CANDIDATE})
						break()
					endif()
				endforeach()
				if (NOT EXISTS ${LIBPSVR_INCL_DIR})
					message(FATAL_ERROR "libpsvr headers not found at ${LIBPSVR_INCL_DIR}. Place the headers under third_party/libpsvr/include.")
				endif()
				if (NOT LIBPSVR_REQ_LIB)
					message(FATAL_ERROR "libpsvr library not found under ${LIBPSVR_LIB_DIR}. Place libpsvr binaries under third_party/libpsvr/lib.")
				endif()
				set(LIBUSB_INCL_DIR ${LIBUSB_ROOT_DIR}/include/libusb-1.0)
				set(LIBUSB_REQ_LIB "")
				foreach(LIBUSB_LIB_CANDIDATE
						${LIBUSB_ROOT_DIR}/lib/libusb-1.0.so
						${LIBUSB_ROOT_DIR}/lib/libusb-1.0.a
						${LIBUSB_ROOT_DIR}/lib64/libusb-1.0.so
						${LIBUSB_ROOT_DIR}/lib64/libusb-1.0.a)
					if (EXISTS ${LIBUSB_LIB_CANDIDATE})
						set(LIBUSB_REQ_LIB ${LIBUSB_LIB_CANDIDATE})
						break()
					endif()
				endforeach()
				if (NOT EXISTS ${LIBUSB_INCL_DIR})
					message(FATAL_ERROR "libusb headers not found at ${LIBUSB_INCL_DIR}. Place the headers under third_party/libusb/include/libusb-1.0.")
				endif()
				if (NOT LIBUSB_REQ_LIB)
					message(FATAL_ERROR "libusb library not found under ${LIBUSB_ROOT_DIR}/lib or ${LIBUSB_ROOT_DIR}/lib64.")
				endif()
        endif()
endif()

# OpenVR Cross-platform Dependency
if (NOT EXISTS "${OPENVR_ROOT_DIR}")
    message(FATAL_ERROR "OpenVR was not found at ${OPENVR_ROOT_DIR}. Populate third_party/openvr.")
endif()

# GLM Cross-platform Dependency
set(GLM_INCL_DIR ${GLM_ROOT_DIR}/glm)
if (NOT EXISTS "${GLM_INCL_DIR}")
    message(FATAL_ERROR "GLM headers were not found at ${GLM_INCL_DIR}. Populate third_party/glm.")
endif()

add_subdirectory(src)
