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
   tools\build_debug.bat
   ```

2. **Build Release version** (optimized single executable):
   ```cmd
   tools\build_release.bat
   ```

## Hot Reload Development

For the best development experience with hot reload:

1. **Using VS Code** (Recommended):
   - Open the project in VS Code
   - Press `F5` to start debugging with hot reload
   - The file watcher will start automatically
   - Edit and save files to see changes instantly

2. **Using Command Line**:
   ```cmd
   tools\run_debug_with_watch.bat
   ```
   Or with PowerShell:
   ```powershell
   .\tools\run_debug_with_watch.ps1
   ```

3. **Manual Setup**:
   - Terminal 1: Run the watcher
     ```cmd
     tools\watch.bat
     ```
   - Terminal 2: Run the executable
     ```cmd
     bazel-bin\host\hot_reload_host.exe
     ```

## CLion Setup

For CLion integration, run:
```cmd
tools\setup_clion_windows.bat
```

This will guide you through setting up CLion with the Bazel plugin.

## Install iBazel for File Watching

The hot reload feature requires iBazel for automatic rebuilds:

1. **Install Node.js** (if not already installed):
   - Download from: https://nodejs.org/
   - Choose the LTS version

2. **Install iBazel**:
   ```cmd
   npm install -g @bazel/ibazel
   ```

## Verification

To verify Bazel is installed correctly:
```cmd
bazel --version
```

You should see the Bazel version number.