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
    echo Copying outputs to build\release...
    
    REM Get the parent directory (project root)
    set PROJECT_ROOT=%~dp0..
    
    REM Create build\release directory if it doesn't exist
    if not exist "%PROJECT_ROOT%\build\release" mkdir "%PROJECT_ROOT%\build\release"
    
    REM Copy executable to build\release
    copy "%PROJECT_ROOT%\bazel-bin\host\hot_reload_host.exe" "%PROJECT_ROOT%\build\release\" >nul 2>&1
    
    if exist "%PROJECT_ROOT%\build\release\hot_reload_host.exe" (
        echo Release build complete. Output in build\release\
        echo   - hot_reload_host.exe (optimized, single executable)
    ) else (
        echo Warning: Could not copy output to build\release\
    )
) else (
    echo.
    echo Build failed! Check the error messages above.
)

pause