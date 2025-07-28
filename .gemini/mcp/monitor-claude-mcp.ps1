# PowerShell script to monitor Claude MCP usage by Gemini CLI on Windows

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Claude MCP Activity Monitor" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Monitoring Claude MCP server usage..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Function to check if Claude MCP process exists
function Test-MCPProcess {
    $process = Get-Process | Where-Object { $_.ProcessName -like "*claude*" -and $_.CommandLine -like "*mcp serve*" } -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "✓ Claude MCP Server Active" -ForegroundColor Green -NoNewline
        Write-Host " (PID: $($process.Id))"
        return $process
    } else {
        Write-Host "✗ Claude MCP Server Not Running" -ForegroundColor Red
        return $null
    }
}

# Function to check using tasklist (more reliable for WSL processes)
function Test-MCPProcessTasklist {
    $tasks = tasklist /v /fo csv | ConvertFrom-Csv
    $claudeProcess = $tasks | Where-Object { $_.'Image Name' -like "*claude*" -or $_.'Window Title' -like "*claude*mcp*" }
    return $claudeProcess
}

# Initial check
Write-Host "Initial Status:" -ForegroundColor Blue
$initialProcess = Test-MCPProcess
if (-not $initialProcess) {
    Write-Host ""
    Write-Host "Claude MCP server is not running." -ForegroundColor Yellow
    Write-Host "Gemini will start it automatically when needed."
    Write-Host ""
    Write-Host "Waiting for Gemini to start Claude MCP..."
}

$lastStatus = ""
$checkCount = 0

# Monitor loop
while ($true) {
    $checkCount++
    
    # Primary method: Check WSL processes (since Claude runs in WSL)
    $wslProcesses = $null
    try {
        $wslProcesses = wsl ps aux 2>$null | Select-String "claude.*mcp.*serve"
        if (-not $wslProcesses) {
            # Also check for the wsl.exe process that might be running claude
            $wslProcesses = Get-Process | Where-Object { 
                $_.ProcessName -eq "wsl" -and 
                (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)" -ErrorAction SilentlyContinue).CommandLine -like "*claude*mcp*"
            }
        }
    } catch {
        # WSL command failed, ignore
    }
    
    # Secondary: Check for Windows processes (unlikely but possible)
    $process = Get-Process | Where-Object { $_.ProcessName -like "*claude*" } -ErrorAction SilentlyContinue
    
    if ($process -or $wslProcesses) {
        if ($lastStatus -ne "running") {
            Write-Host ""
            Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Claude MCP Started!" -ForegroundColor Green
            if ($process) {
                Write-Host "Gemini is now connected to Claude (PID: $($process.Id))"
            } else {
                Write-Host "Gemini is now connected to Claude (WSL process detected)"
            }
            $lastStatus = "running"
        }
        
        # Monitor activity
        if ($process) {
            $cpu = [math]::Round($process.CPU, 2)
            $mem = [math]::Round($process.WorkingSet64 / 1MB, 2)
            
            if ($cpu -gt 0.5) {
                Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Active:" -ForegroundColor Green -NoNewline
                Write-Host " Claude is processing a request"
                Write-Host "CPU Time: $cpu s | Memory: $mem MB" -ForegroundColor Yellow
            }
        }
        
    } else {
        if ($lastStatus -eq "running") {
            Write-Host ""
            Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Claude MCP Stopped" -ForegroundColor Yellow
            Write-Host "Waiting for next activation..."
            $lastStatus = "stopped"
        } elseif ($checkCount % 30 -eq 0) {
            # Every 60 seconds, show we're still monitoring
            Write-Host "." -NoNewline
        }
    }
    
    Start-Sleep -Seconds 2
}