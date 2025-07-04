#!/bin/bash

BUILD_TYPE="Debug" # Default value

if [ "$1" == "-release" ]; then
    BUILD_TYPE="Release"
elif [ "$1" != "-debug" ] && [ ! -z "$1" ]; then
    echo "Invalid argument: $1"
    echo "Usage: ./build.sh [-debug | -release]"
    exit 1
fi

BUILD_DIR="build/$BUILD_TYPE"

if [ ! -d "$BUILD_DIR" ]; then
    echo "Build directory $BUILD_DIR does not exist."
    echo "Please run './install.sh $1' first."
    exit 1
fi

echo "Building $BUILD_TYPE configuration..."
cmake --build "$BUILD_DIR"
