#!/bin/bash

BUILD_TYPE="Debug" # Default value

if [ "$1" == "-release" ]; then
    BUILD_TYPE="Release"
elif [ "$1" != "-debug" ] && [ ! -z "$1" ]; then
    echo "Invalid argument: $1"
    echo "Usage: ./install.sh [-debug | -release]"
    exit 1
fi

BUILD_DIR="build/$BUILD_TYPE"

echo "Configuring for $BUILD_TYPE build in $BUILD_DIR directory..."

# Create the build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Navigate to the build directory and run CMake
cd "$BUILD_DIR"
cmake ../.. -DCMAKE_BUILD_TYPE=$BUILD_TYPE
