@echo off
REM Batch file wrapper for viewing Claude logs

echo Claude MCP Logs Viewer
echo.

if "%1"=="" (
    set ACTION=recent
) else (
    set ACTION=%1
)

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    powershell -ExecutionPolicy Bypass -File "%~dp0claude-mcp-logs.ps1" %ACTION%
) else (
    echo PowerShell is required to run this script.
    echo Please install PowerShell or use Windows PowerShell.
    pause
)