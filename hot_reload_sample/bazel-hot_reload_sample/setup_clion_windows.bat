@echo off
echo Setting up CLion for Bazel on Windows
echo =====================================
echo.

echo Step 1: Install Bazel
echo --------------------
echo.
where bazel >nul 2>nul
if %errorlevel% equ 0 (
    echo Bazel found at:
    where bazel
) else (
    echo Bazel NOT found! 
    echo.
    echo Please download Bazel manually from:
    echo https://github.com/bazelbuild/bazelisk/releases
    echo.
    pause
    exit /b 1
)

echo.
echo Step 2: Configure CLion
echo ----------------------
echo.
echo 1. Open CLion
echo 2. Install Bazel Plugin:
echo    - File -^> Settings -^> Plugins
echo    - Search "Bazel" and install
echo    - Restart CLion
echo.
echo 3. Configure Bazel Path:
echo    - File -^> Settings -^> Bazel Settings
echo    - Set "Bazel binary location" to one of:
echo      * C:\tools\bazel\bazel.exe (if you used our installer)
echo      * Or wherever you installed bazel.exe
echo.
echo 4. Open Project:
echo    - File -^> Open
echo    - Select this folder: %CD%
echo    - Choose "Open as Bazel Project"
echo.
echo 5. If Bazel project doesn't work, try CMake:
echo    - File -^> Open
echo    - Select CMakeLists.txt
echo    - Use External Tools to run Bazel commands
echo.

echo Step 3: Build and Run
echo --------------------
echo.
echo From CLion Terminal or Command Prompt:
echo   - Build Debug:   build_debug.bat
echo   - Build Release: build_release.bat
echo.
echo Or use CLion's run configurations:
echo   - "Bazel Build Debug"
echo   - "Bazel Run Host"
echo.

pause