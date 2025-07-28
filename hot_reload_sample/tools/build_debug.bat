@echo off
echo Building Hot Reload Sample (Debug with Hot Reload)...
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
bazel build --config=debug-hot-reload //host:hot_reload_host
if %errorlevel% neq 0 (
    echo.
    echo Build failed! Check the error messages above.
    exit /b %errorlevel%
)
echo.
echo Build successful!

echo.
echo Copying outputs to build\debug...

REM Get the parent directory (project root)
set PROJECT_ROOT=%~dp0..

REM Create build\debug directory if it doesn't exist
if not exist "%PROJECT_ROOT%\build\debug" mkdir "%PROJECT_ROOT%\build\debug"

REM Copy files from bazel-bin to build\debug
copy "%PROJECT_ROOT%\bazel-bin\host\hot_reload_host.exe" "%PROJECT_ROOT%\build\debug\" >nul 2>&1
copy "%PROJECT_ROOT%\bazel-bin\host\game_logic.dll" "%PROJECT_ROOT%\build\debug\" >nul 2>&1

if exist "%PROJECT_ROOT%\build\debug\hot_reload_host.exe" (
    echo Debug build complete. Output in build\debug\
    echo   - hot_reload_host.exe
    echo   - game_logic.dll
) else (
    echo Warning: Could not copy outputs to build\debug\
)
