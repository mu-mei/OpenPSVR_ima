#!/bin/bash

PROJECT_ROOT=$PWD
BUILD_DIR="$PROJECT_ROOT/generated"
BUILD_TYPE="Release"

get_arch_label(){
	local system_name=""
	local ptr_size=""

	if [ -f "$BUILD_DIR/CMakeCache.txt" ]; then
		system_name=$(awk -F= '/^CMAKE_SYSTEM_NAME:/{print $2}' "$BUILD_DIR/CMakeCache.txt")
		ptr_size=$(awk -F= '/^CMAKE_SIZEOF_VOID_P:/{print $2}' "$BUILD_DIR/CMakeCache.txt")
	fi

	if [ "$ptr_size" = "8" ]; then
		if [ "$system_name" = "Windows" ]; then
			echo "Win64"
		elif [ "$system_name" = "Darwin" ]; then
			echo "OSX64"
		elif [ -n "$system_name" ]; then
			echo "Linux64"
		fi
	else
		if [ "$system_name" = "Windows" ]; then
			echo "Win32"
		elif [ "$system_name" = "Darwin" ]; then
			echo "OSX32"
		elif [ -n "$system_name" ]; then
			echo "Linux32"
		fi
	fi
}

get_output_root(){
	local output_root=""

	if [ -f "$BUILD_DIR/CMakeCache.txt" ]; then
		output_root=$(awk -F= '/^OPENPSVR_OUTPUT_ROOT:PATH=/{print $2}' "$BUILD_DIR/CMakeCache.txt")
	fi

	if [ -z "$output_root" ]; then
		output_root="$PROJECT_ROOT/build"
	fi

	echo "$output_root"
}

#Function to build driver
buildDriver(){
	cd "$BUILD_DIR"
	cmake --build . --target install --config $BUILD_TYPE || return $?
    echo BUILD SUCCESS
    echo -e "\E[1;32mBUILD SUCCESS\E[;0m";
	local arch_label
	arch_label=$(get_arch_label)
	if [ -n "$arch_label" ]; then
		local output_root
		output_root=$(get_output_root)
		echo "Output: $output_root/$arch_label/openpsvr"
	fi
	exit 0
}

parseArgs(){
	while [ "$#" -gt 0 ]; do
		case "$1" in
			--config|-c)
				BUILD_TYPE="$2"
				shift 2
				;;
			*)
				echo "Unknown argument: $1"
				exit 1
				;;
		esac
	done
}

#Function to handle errors
function handleError() {
   error_msg="BUILD FAILED"
   echo -e "\E[1;31m$error_msg\E[;0m";
   exit 1;
}


# this will trap any errors or commands with non-zero exit status
# by calling function catch_errors()
trap handleError ERR;

#Main entry point
parseArgs "$@"
buildDriver
