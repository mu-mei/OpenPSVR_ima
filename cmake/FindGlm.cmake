# - try to find GLM headers
#
# Cache Variables:
#  GLM_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GLM_FOUND
#  GLM_INCLUDE_DIR
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs

message(STATUS "Finding GLM, CMAKE_CURRENT_LIST_DIR=${CMAKE_CURRENT_LIST_DIR}/../third_party/glm")

if (GLM_INCLUDE_DIR)
    set(GLM_FOUND TRUE)
else()
    set(GLM_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../third_party/glm)

    find_path(GLM_INCLUDE_DIR
        NAMES
            glm.hpp
        PATHS
            ${GLM_ROOT_DIR}/glm
            /usr/local/include)

    include(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLM DEFAULT_MSG GLM_INCLUDE_DIR)

    mark_as_advanced(GLM_INCLUDE_DIR)
endif()
