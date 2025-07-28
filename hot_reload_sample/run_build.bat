@echo off
REM This script ensures we're in the correct directory before building

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

REM Change to the script directory (hot_reload_sample)
cd /d "%SCRIPT_DIR%"

echo Current directory: %CD%
echo.

REM Now run the build
call build_debug.bat