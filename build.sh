#!/bin/bash

BUILD_TYPE="Release"

#Function to build driver
buildDriver(){
	cd generated
	cmake --build . --target install --config $BUILD_TYPE || return $?
    echo BUILD SUCCESS
    echo -e "\E[1;32mBUILD SUCCESS\E[;0m";
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
