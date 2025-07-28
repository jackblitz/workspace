# Test WSL Claude setup for Gemini MCP

Write-Host "Testing WSL Claude MCP Setup" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Check if WSL is available
Write-Host "1. Checking WSL availability..." -ForegroundColor Yellow
$wslVersion = $null
try {
    $wslVersion = wsl --version 2>$null
} catch {
    # Ignore errors
}

if ($wslVersion -and $LASTEXITCODE -eq 0) {
    Write-Host "✓ WSL is installed" -ForegroundColor Green
    Write-Host $wslVersion
} else {
    Write-Host "✗ WSL not found or not properly configured" -ForegroundColor Red
    Write-Host "  Install WSL with: wsl --install" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Test 2: Check if Claude is installed in WSL
Write-Host "2. Checking Claude in WSL..." -ForegroundColor Yellow
$claudeCheck = wsl which claude 2>$null
if ($claudeCheck) {
    Write-Host "✓ Claude found in WSL at: $claudeCheck" -ForegroundColor Green
    
    # Get Claude version
    $claudeVersion = wsl claude --version 2>$null
    if ($claudeVersion) {
        Write-Host "  Version: $claudeVersion" -ForegroundColor Gray
    }
} else {
    Write-Host "✗ Claude not found in WSL" -ForegroundColor Red
    Write-Host "  Install Claude in WSL first" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Test 3: Test MCP serve command
Write-Host "3. Testing claude mcp serve in WSL..." -ForegroundColor Yellow
$mcpHelp = wsl claude mcp serve --help 2>&1
if ($mcpHelp -like "*Start the Claude Code MCP server*") {
    Write-Host "✓ MCP serve command is available" -ForegroundColor Green
} else {
    Write-Host "✗ MCP serve command not working" -ForegroundColor Red
    Write-Host "  Output: $mcpHelp" -ForegroundColor Gray
}

Write-Host ""

# Test 4: Test starting MCP server through WSL
Write-Host "4. Testing MCP server startup via WSL..." -ForegroundColor Yellow
Write-Host "Starting test server for 5 seconds..." -ForegroundColor Gray

# Start the process
$proc = Start-Process -FilePath "wsl" -ArgumentList "claude", "mcp", "serve" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 3

# Check if it's running
$wslCheck = wsl ps aux | Select-String "claude.*mcp.*serve"
if ($wslCheck) {
    Write-Host "✓ MCP server started successfully in WSL" -ForegroundColor Green
    $processInfo = $wslCheck.Line
    if ($processInfo.Length -gt 80) {
        $processInfo = $processInfo.Substring(0, 80) + "..."
    }
    Write-Host "  Process: $processInfo" -ForegroundColor Gray
    
    # Kill the test process
    wsl pkill -f "claude mcp serve" 2>$null
} else {
    Write-Host "✗ MCP server failed to start" -ForegroundColor Red
}

Write-Host ""

# Test 5: Path translation
Write-Host "5. Testing WSL path access..." -ForegroundColor Yellow
$currentPath = (Get-Location).Path
$wslPath = wsl wslpath "'$currentPath'" 2>$null
if ($wslPath) {
    Write-Host "✓ Windows path accessible from WSL" -ForegroundColor Green
    Write-Host "  Windows: $currentPath" -ForegroundColor Gray
    Write-Host "  WSL:     $wslPath" -ForegroundColor Gray
} else {
    Write-Host "✗ Path translation failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "Configuration Status:" -ForegroundColor Cyan
Write-Host ""

# Check current settings.json
if (Test-Path "settings.json") {
    try {
        $settingsContent = Get-Content "settings.json" -Raw
        $settings = $settingsContent | ConvertFrom-Json
        if ($settings.mcpServers.'claude-code'.command -eq "wsl") {
            Write-Host "✓ settings.json is correctly configured for WSL" -ForegroundColor Green
        } else {
            Write-Host "✗ settings.json needs to be updated" -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Error reading settings.json: $_" -ForegroundColor Red
    }
} else {
    Write-Host "✗ settings.json not found in current directory" -ForegroundColor Red
}

Write-Host ""
Write-Host "Recommended settings.json:" -ForegroundColor Green
Write-Host @"
{
  "mcpServers": {
    "claude-code": {
      "command": "wsl",
      "args": ["claude", "mcp", "serve"],
      "env": {},
      "description": "Claude Code MCP Server via WSL"
    }
  },
  "trust": {
    "claude-code": false
  }
}
"@ -ForegroundColor Yellow

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Ensure settings.json has the WSL configuration"
Write-Host "2. Restart Gemini CLI"
Write-Host "3. Run /mcp to verify connection"
Write-Host "4. Test with: 'Use Claude to list files'"
Write-Host ""
Write-Host "If still having issues, try:" -ForegroundColor Yellow
Write-Host "- Run Gemini from a Windows Terminal (not cmd.exe)"
Write-Host "- Ensure WSL is WSL2 (wsl --set-default-version 2)"
Write-Host "- Check Windows Defender isn't blocking WSL processes"