# Windows Setup for Hot Reload Sample

## Prerequisites

1. **Install Bazel**
   - Download Bazelisk from: https://github.com/bazelbuild/bazelisk/releases
   - Download the `bazelisk-windows-amd64.exe` file
   - Rename it to `bazel.exe`
   - Add it to your PATH:
     - Create a folder like `C:\tools\bazel\`
     - Copy `bazel.exe` to this folder
     - Add `C:\tools\bazel\` to your system PATH

2. **Install Visual Studio Build Tools** (if not already installed)
   - Download from: https://visualstudio.microsoft.com/downloads/
   - Install "Desktop development with C++" workload

## Building the Project

Once Bazel is installed and in your PATH:

1. **Build Debug version** (with hot reload support):
   ```cmd
   build_debug.bat
   ```

2. **Build Release version** (optimized single executable):
   ```cmd
   build_release.bat
   ```

## CLion Setup

For CLion integration, run:
```cmd
setup_clion_windows.bat
```

This will guide you through setting up CLion with the Bazel plugin.

## Verification

To verify Bazel is installed correctly:
```cmd
bazel --version
```

You should see the Bazel version number.