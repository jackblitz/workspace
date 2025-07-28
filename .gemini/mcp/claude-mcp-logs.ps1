# PowerShell script to view Claude MCP logs on Windows

param(
    [Parameter(Position=0)]
    [ValidateSet("recent", "monitor", "help")]
    [string]$Action = "help"
)

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Claude MCP Activity Logs" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Possible log locations
$logPaths = @(
    "$env:USERPROFILE\.claude\logs",
    "$env:APPDATA\claude\logs",
    "$env:LOCALAPPDATA\claude\logs",
    "$env:USERPROFILE\.cache\claude\logs"
)

# Find Claude log directory
$logDir = $null
foreach ($path in $logPaths) {
    if (Test-Path $path) {
        $logDir = $path
        break
    }
}

# If not found in Windows paths, check WSL
if (-not $logDir) {
    $wslHome = wsl echo '$HOME' 2>$null
    if ($wslHome) {
        $wslLogPath = wsl ls "$wslHome/.claude/logs" 2>$null
        if ($wslLogPath) {
            Write-Host "Found logs in WSL at $wslHome/.claude/logs" -ForegroundColor Yellow
            $useWSL = $true
        }
    }
}

function Show-RecentActivity {
    Write-Host "Recent MCP Activity (last 50 lines):" -ForegroundColor Green
    Write-Host ""
    
    if ($useWSL) {
        # Use WSL to read logs
        $logs = wsl find '$HOME/.claude/logs' -name '*.log' -type f -exec ls -t {} \; 2>$null | wsl head -1
        if ($logs) {
            Write-Host "Reading from WSL log file..." -ForegroundColor Yellow
            wsl tail -50 "$logs" | Select-String -Pattern "(MCP|Tool|view|edit|ls|request|response)" | Select-Object -Last 20
        } else {
            Write-Host "No log files found in WSL" -ForegroundColor Red
        }
    } elseif ($logDir) {
        $latestLog = Get-ChildItem "$logDir\*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        
        if ($latestLog) {
            Write-Host "Log file: $($latestLog.FullName)" -ForegroundColor Yellow
            Write-Host ""
            Get-Content $latestLog.FullName -Tail 50 | Select-String -Pattern "(MCP|Tool|view|edit|ls|request|response)" | Select-Object -Last 20
        } else {
            Write-Host "No log files found in $logDir" -ForegroundColor Red
        }
    } else {
        Write-Host "Claude log directory not found." -ForegroundColor Red
        Write-Host "Checked locations:" -ForegroundColor Yellow
        $logPaths | ForEach-Object { Write-Host "  $_" }
    }
}

function Start-LogMonitor {
    Write-Host "Monitoring Claude MCP logs in real-time..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
    Write-Host ""
    
    if ($useWSL) {
        # Monitor WSL logs
        $logs = wsl find '$HOME/.claude/logs' -name '*.log' -type f -exec ls -t {} \; 2>$null | wsl head -1
        if ($logs) {
            Write-Host "Monitoring WSL log file..." -ForegroundColor Yellow
            wsl tail -f "$logs" | ForEach-Object {
                if ($_ -match "(MCP|Tool|view|edit|ls|request|response)") {
                    Write-Host $_ -ForegroundColor Green
                }
            }
        }
    } elseif ($logDir) {
        $latestLog = Get-ChildItem "$logDir\*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        
        if ($latestLog) {
            Write-Host "Monitoring: $($latestLog.Name)" -ForegroundColor Yellow
            Get-Content $latestLog.FullName -Wait -Tail 10 | ForEach-Object {
                if ($_ -match "(MCP|Tool|view|edit|ls|request|response)") {
                    Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] $_" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "No log files found" -ForegroundColor Red
        }
    } else {
        Write-Host "Claude log directory not found." -ForegroundColor Red
    }
}

function Show-Help {
    Write-Host "Usage: .\claude-mcp-logs.ps1 [action]" -ForegroundColor Green
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  recent     Show recent MCP activity"
    Write-Host "  monitor    Monitor logs in real-time"
    Write-Host "  help       Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\claude-mcp-logs.ps1 monitor    # Watch logs in real-time"
    Write-Host "  .\claude-mcp-logs.ps1 recent     # Show recent activity"
}

# Execute based on action
switch ($Action) {
    "recent" { Show-RecentActivity }
    "monitor" { Start-LogMonitor }
    "help" { Show-Help }
    default { Show-Help }
}