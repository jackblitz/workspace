@echo off
echo Building Hot Reload Sample (Release)...
echo.

REM Check if bazel is available
where bazel >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Bazel not found in PATH!
    echo.
    echo Please install Bazel first:
    echo Download from: https://github.com/bazelbuild/bazelisk/releases
    echo Add to PATH after installation
    echo.
    pause
    exit /b 1
)

REM Run bazel build
bazel build --config=release //...

if %errorlevel% equ 0 (
    echo.
    echo Release build complete. Single optimized executable created.
) else (
    echo.
    echo Build failed! Check the error messages above.
)

pause