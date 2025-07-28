@echo off
echo =================================================================
echo  Starting iBazel Watcher for Hot Reloading
echo =================================================================
echo.
echo  This will automatically rebuild the project when you save a file.
echo  Keep this terminal open.
echo.
echo  In another terminal or in VS Code, run the 'Debug Host (MSVC)'
echo  configuration to see the changes hot-reloaded.
echo.
echo =================================================================
echo.

REM Get the project root directory
set PROJECT_ROOT=%~dp0..

REM Run ibazel from the project root
cd /d "%PROJECT_ROOT%"

echo Starting file watcher and output sync...
echo.

REM Start the file sync in a separate PowerShell window
start "Build Output Sync" /MIN powershell -ExecutionPolicy Bypass -File "%~dp0sync_build_output.ps1"

REM Run ibazel build
ibazel build --config=debug-hot-reload //modules/game_logic //host:copy_game_logic_dll

REM When ibazel exits, also stop the sync script
taskkill /FI "WINDOWTITLE eq Build Output Sync*" /F >nul 2>&1
