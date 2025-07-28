@echo off
REM Batch file wrapper for Windows Command Prompt

echo Starting Claude MCP Monitor...
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    powershell -ExecutionPolicy Bypass -File "%~dp0monitor-claude-mcp.ps1"
) else (
    echo PowerShell is required to run this monitor.
    echo Please install PowerShell or use Windows PowerShell.
    pause
)