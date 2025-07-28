# Windows Usage Guide for Gemini-Claude MCP Monitoring

## Running Monitoring Scripts on Windows

### Option 1: Using PowerShell (Recommended)

Open PowerShell and run:
```powershell
# Monitor Claude MCP activity
.\monitor-claude-mcp.ps1

# View recent logs
.\claude-mcp-logs.ps1 recent

# Monitor logs in real-time
.\claude-mcp-logs.ps1 monitor
```

If you get an execution policy error:
```powershell
# Run with bypass
powershell -ExecutionPolicy Bypass -File monitor-claude-mcp.ps1

# Or permanently allow scripts (run as admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Option 2: Using Batch Files

Double-click or run from Command Prompt:
```cmd
monitor-claude.bat      # Monitor MCP activity
view-logs.bat          # View recent logs
view-logs.bat monitor  # Real-time log monitoring
```

### Option 3: Using WSL (Windows Subsystem for Linux)

If you have WSL installed:
```bash
# In WSL terminal
./monitor-claude-mcp.sh
./claude-mcp-logs.sh recent
./claude-mcp-logs.sh monitor
```

## What the Scripts Do

### monitor-claude-mcp.ps1 / .sh
- Detects when Claude MCP server starts/stops
- Shows CPU and memory usage
- Indicates when Gemini is actively using Claude
- Works with both native Windows and WSL processes

### claude-mcp-logs.ps1 / .sh  
- Finds Claude log files automatically
- Shows recent MCP activity
- Can monitor logs in real-time
- Filters for relevant MCP operations

## Troubleshooting

### Scripts close immediately
- Run from PowerShell/Terminal, not by double-clicking
- Check if Claude is installed: `where claude` (CMD) or `which claude` (WSL)

### Can't find logs
The scripts check multiple locations:
- `%USERPROFILE%\.claude\logs`
- `%APPDATA%\claude\logs`
- `%LOCALAPPDATA%\claude\logs`
- WSL: `~/.claude/logs`

### Permission errors
- Right-click PowerShell → "Run as Administrator"
- Or use the bypass method shown above

### No activity shown
1. Make sure Gemini is configured properly (check `.gemini/settings.json`)
2. Try using Claude in Gemini: "Use Claude to list files"
3. Check `/mcp` status in Gemini

## Quick Test

1. Open PowerShell in `.gemini` directory
2. Run: `.\monitor-claude-mcp.ps1`
3. In another terminal, start Gemini and type:
   ```
   Use Claude to view the README.md file
   ```
4. Watch the monitor show Claude becoming active!