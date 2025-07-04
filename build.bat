@echo off
setlocal

set BUILD_TYPE=Debug

if /I "%1"=="-release" (
    set BUILD_TYPE=Release
) else if /I NOT "%1"=="-debug" (
    if NOT "%1"=="" (
        echo "Invalid argument: %1"
        echo "Usage: build.bat [-debug ^| -release]"
        exit /b 1
    )
)

set BUILD_DIR=build\%BUILD_TYPE%

if not exist %BUILD_DIR% (
    echo "Build directory %BUILD_DIR% does not exist."
    echo "Please run 'install.bat %1' first."
    exit /b 1
)

echo "Building %BUILD_TYPE% configuration..."
cmake --build %BUILD_DIR%

endlocal
