cmake_minimum_required(VERSION 3.2)
project(OpenPSVR VERSION 0.1.0)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(THIRD_PARTY ${ROOT_DIR}/third_party)
set(LIBPSVR_ROOT ${ROOT_DIR}/third_party/libpsvr)

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

option(OPENPSVR_DOWNLOAD_DEPENDENCIES "Download missing OpenVR/GLM sources into third_party." ON)

function(openpsvr_ensure_dependency name repo_url dest_dir)
    if (EXISTS "${dest_dir}")
        return()
    endif()
    if (NOT OPENPSVR_DOWNLOAD_DEPENDENCIES)
        message(FATAL_ERROR "${name} was not found at ${dest_dir}. Populate third_party or enable OPENPSVR_DOWNLOAD_DEPENDENCIES.")
    endif()
    find_program(GIT_EXECUTABLE git)
    if (NOT GIT_EXECUTABLE)
        message(FATAL_ERROR "Git is required to download ${name}. Install git or populate third_party manually.")
    endif()
    get_filename_component(dest_parent "${dest_dir}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_parent}")
    message(STATUS "Downloading ${name} from ${repo_url} into ${dest_dir}")
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" clone --depth 1 "${repo_url}" "${dest_dir}"
        RESULT_VARIABLE clone_result
        OUTPUT_VARIABLE clone_output
        ERROR_VARIABLE clone_error
    )
    if (NOT clone_result EQUAL 0)
        message(FATAL_ERROR "Failed to download ${name}: ${clone_error}\n${clone_output}")
    endif()
endfunction()

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
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.lib)
				set(LIBUSB_REQ_SHARED_LIB ${THIRD_PARTY}/libusb/src/libusb/MS64/dll/libusb-1.0.dll)
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/include/libusb-1.0)
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
				set(LIBUSB_REQ_LIB ${THIRD_PARTY}/libusb/src/libusb-build/libusb/.libs/libusb-1.0.so)
				set(LIBUSB_INCL_DIR ${THIRD_PARTY}/libusb/src/libusb/libusb)
        endif()
endif()

# OpenVR Cross-platform Dependency
set(OPENVR_ROOT_DIR ${THIRD_PARTY}/openvr/src/openvr)
openpsvr_ensure_dependency("OpenVR" "https://github.com/ValveSoftware/openvr.git" "${OPENVR_ROOT_DIR}")

# GLM Cross-platform Dependency
set(GLM_INCL_DIR ${THIRD_PARTY}/glm/src/glm/glm)
openpsvr_ensure_dependency("GLM" "https://github.com/g-truc/glm.git" "${THIRD_PARTY}/glm/src/glm")

add_subdirectory(src)
