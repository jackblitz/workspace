@echo off
echo =================================================================
echo  Starting Hot Reload Development Environment
echo =================================================================
echo.

REM Start the watcher in a new window
echo Starting file watcher in a new window...
start "Hot Reload Watcher" /MIN cmd /k "%~dp0watch.bat"

REM Give the watcher a moment to start
timeout /t 2 /nobreak > nul

REM Build the project first to ensure everything is up to date
echo Building the project...
call "%~dp0build_debug.bat"
if %errorlevel% neq 0 (
    echo Build failed! Check the error messages above.
    pause
    exit /b %errorlevel%
)

echo.
echo =================================================================
echo  Starting Debug Host with Hot Reload
echo =================================================================
echo.
echo  The watcher is running in a separate window.
echo  Edit your code and save to see changes instantly!
echo.
echo  Press Ctrl+C to stop the application.
echo =================================================================
echo.

REM Run the host executable from build folder
set PROJECT_ROOT=%~dp0..
if exist "%PROJECT_ROOT%\build\debug\hot_reload_host.exe" (
    "%PROJECT_ROOT%\build\debug\hot_reload_host.exe"
) else (
    echo ERROR: build\debug\hot_reload_host.exe not found!
    echo Please run tools\build_debug.bat first.
)

REM When the host exits, also close the watcher
echo.
echo Closing watcher window...
taskkill /FI "WINDOWTITLE eq Hot Reload Watcher*" /F > nul 2>&1

echo.
echo Done!
pause