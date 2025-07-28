#!/bin/bash

echo "Building Hot Reload Sample (Release)..."
echo

# Check if bazel is available
if ! command -v bazel &> /dev/null; then
    echo "ERROR: Bazel not found in PATH!"
    echo
    echo "Please install Bazel first:"
    echo "Download from: https://github.com/bazelbuild/bazelisk/releases"
    echo "Add to PATH after installation"
    echo
    exit 1
fi

# Run bazel build
bazel build --config=release //...

if [ $? -eq 0 ]; then
    echo
    echo "Release build complete. Single optimized executable created."
else
    echo
    echo "Build failed! Check the error messages above."
    exit 1
fi