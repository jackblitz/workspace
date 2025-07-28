@echo off
REM This script ensures we're in the correct directory before building

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

REM Change to the parent directory (hot_reload_sample)
cd /d "%SCRIPT_DIR%\.."

echo Current directory: %CD%
echo.

REM Now run the build from tools directory
call "%SCRIPT_DIR%build_debug.bat"