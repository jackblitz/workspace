# Test MCP connection setup for Windows

Write-Host "Testing Claude MCP Setup for Gemini" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Check if claude is in PATH
Write-Host "1. Checking Claude CLI availability..." -ForegroundColor Yellow
$claudePath = Get-Command claude -ErrorAction SilentlyContinue

if ($claudePath) {
    Write-Host "✓ Claude found at: $($claudePath.Path)" -ForegroundColor Green
} else {
    Write-Host "✗ Claude not found in PATH" -ForegroundColor Red
    Write-Host "  Checking common locations..." -ForegroundColor Yellow
    
    $possiblePaths = @(
        "$env:USERPROFILE\AppData\Local\Programs\claude\claude.exe",
        "$env:PROGRAMFILES\claude\claude.exe",
        "$env:PROGRAMFILES(x86)\claude\claude.exe",
        "$env:USERPROFILE\.claude\bin\claude.exe"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            Write-Host "  Found at: $path" -ForegroundColor Green
            Write-Host "  Add this to your PATH or update settings.json with full path" -ForegroundColor Yellow
            $claudePath = @{Path = $path}
            break
        }
    }
}

Write-Host ""

# Test 2: Test MCP serve command
if ($claudePath) {
    Write-Host "2. Testing claude mcp serve..." -ForegroundColor Yellow
    try {
        $testOutput = & $claudePath.Path mcp serve --help 2>&1
        if ($testOutput -match "Start the Claude Code MCP server") {
            Write-Host "✓ MCP serve command is available" -ForegroundColor Green
        } else {
            Write-Host "✗ MCP serve command not working properly" -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Error running claude mcp serve: $_" -ForegroundColor Red
    }
}

Write-Host ""

# Test 3: Check Node.js (required for some MCP setups)
Write-Host "3. Checking Node.js..." -ForegroundColor Yellow
$nodePath = Get-Command node -ErrorAction SilentlyContinue

if ($nodePath) {
    $nodeVersion = & node --version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js not found (may be required)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Create test server
Write-Host "4. Testing MCP server startup..." -ForegroundColor Yellow
if ($claudePath) {
    Write-Host "Starting test server (5 seconds)..." -ForegroundColor Yellow
    $proc = Start-Process -FilePath $claudePath.Path -ArgumentList "mcp", "serve" -PassThru -WindowStyle Hidden
    Start-Sleep -Seconds 2
    
    if (!$proc.HasExited) {
        Write-Host "✓ MCP server started successfully" -ForegroundColor Green
        $proc.Kill()
    } else {
        Write-Host "✗ MCP server exited immediately" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Configuration Recommendations:" -ForegroundColor Cyan
Write-Host ""

# Generate recommended settings
if ($claudePath) {
    $recommendedSettings = @"
{
  "mcpServers": {
    "claude-code": {
      "command": "$($claudePath.Path -replace '\\', '\\\\')",
      "args": ["mcp", "serve"],
      "env": {},
      "description": "Claude Code MCP Server - Provides file manipulation tools (view, edit, ls)"
    }
  },
  "trust": {
    "claude-code": false
  }
}
"@
    
    Write-Host "Recommended settings.json content:" -ForegroundColor Green
    Write-Host $recommendedSettings -ForegroundColor Yellow
} else {
    Write-Host "Claude CLI not found. Please install Claude or provide the full path." -ForegroundColor Red
    Write-Host ""
    Write-Host "If Claude is installed via WSL, you may need to use:" -ForegroundColor Yellow
    Write-Host @"
{
  "mcpServers": {
    "claude-code": {
      "command": "wsl",
      "args": ["claude", "mcp", "serve"],
      "env": {},
      "description": "Claude Code MCP Server via WSL"
    }
  }
}
"@ -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Update .gemini/settings.json with the recommended configuration"
Write-Host "2. Restart Gemini CLI"
Write-Host "3. Run /mcp to check connection status"
Write-Host "4. Test with: 'Use Claude to list files in the current directory'"