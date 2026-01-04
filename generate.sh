#!/bin/bash
set -eE
###########################################################################
# Author: Stephen O'Hair
#                                                                     
# Purpose: Generates the openpsvr driver make project files for use on linux.
###########################################################################

# Initialise
PROJECT_ROOT=$PWD
TOOLCHAIN_FILE=""

#Function loads configuration properties and generates project files
main(){
	parseArgs "$@"

	# Generate the project files for PSMoveService
	generateProjectFiles || return $?

	# Exit batch script successfully
    echo -e "\E[1;32mBUILD SUCCESS\E[;0m";
	exit 0
}

#Function generates project files for the configured ide
generateProjectFiles(){
	if [ ! -d "$PROJECT_ROOT/generated" ]; then
		mkdir $PROJECT_ROOT/generated
	fi
	echo "Generating OpenPSVR Project files..."
	echo "Running cmake in $PROJECT_ROOT"
	cd $PROJECT_ROOT/generated
	local CMAKE_ARGS=()
	if [ -n "$TOOLCHAIN_FILE" ]; then
		CMAKE_ARGS+=("-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE")
	fi
	cmake .. -G "Unix Makefiles" "${CMAKE_ARGS[@]}"
}

parseArgs(){
	while [ "$#" -gt 0 ]; do
		case "$1" in
			--toolchain)
				TOOLCHAIN_FILE="$2"
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
   error_msg="GENERATE FAILED"
   echo -e "\E[1;31m$error_msg\E[;0m";
   exit 1;
}


# this will trap any errors or commands with non-zero exit status
# by calling function catch_errors()
trap handleError ERR;

# entry point of script
main "$@"
