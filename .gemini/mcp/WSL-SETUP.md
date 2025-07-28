# WSL Claude MCP Setup for Gemini

Since Claude is running in WSL on your machine, here's the complete setup guide:

## Current Configuration

Your `.gemini/settings.json` is now configured to use Claude via WSL:
```json
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
```

## Testing Your Setup

Run the WSL test script:
```powershell
cd D:\workspace\dev\.gemini
.\test-wsl-claude.ps1
```

This will verify:
- ✓ WSL is installed and working
- ✓ Claude is available in WSL
- ✓ MCP serve command works
- ✓ Path translation between Windows and WSL

## Using Gemini with WSL Claude

1. **Start Gemini** (from Windows Terminal recommended):
   ```
   cd D:\workspace\dev
   gemini
   ```

2. **Check MCP connection**:
   ```
   /mcp
   ```
   
   You should see:
   ```
   claude-code: connected
     Tools: view, edit, ls
   ```

3. **Test Claude tools**:
   ```
   Use Claude to list files in the current directory
   ```

## Monitoring Claude Activity

The monitoring scripts are updated to detect WSL processes:

```powershell
# Monitor Claude MCP activity
.\monitor-claude-mcp.ps1

# View logs (if available)
.\claude-mcp-logs.ps1 recent
```

## Path Considerations

When using Claude via WSL:
- Windows paths are automatically translated
- `D:\workspace\dev` becomes `/mnt/d/workspace/dev` in WSL
- Claude will handle this translation automatically

## Troubleshooting

### If "claude-code" still shows disconnected:

1. **Verify WSL Claude**:
   ```powershell
   wsl which claude
   wsl claude --version
   ```

2. **Test manual startup**:
   ```powershell
   wsl claude mcp serve
   ```

3. **Check WSL version** (WSL2 recommended):
   ```powershell
   wsl --status
   ```

4. **Windows Terminal** vs Command Prompt:
   - Use Windows Terminal for better WSL integration
   - Avoid old cmd.exe

### Common Issues:

**Issue**: Permission denied
```powershell
# Fix WSL permissions
wsl chmod +x ~/.local/bin/claude
```

**Issue**: Command not found
```bash
# In WSL, check PATH
wsl echo $PATH
# Add Claude to PATH if needed
wsl echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

**Issue**: Firewall blocking
- Windows Defender may block WSL processes
- Add exception for wsl.exe

## Best Practices

1. **Always use Windows Terminal** (not cmd.exe)
2. **Keep WSL updated**: `wsl --update`
3. **Use WSL2**: Better performance and compatibility
4. **Regular testing**: Run test script after updates

## Quick Commands Reference

```powershell
# Test WSL Claude setup
.\test-wsl-claude.ps1

# Monitor MCP activity
.\monitor-claude-mcp.ps1

# In Gemini
/mcp                    # Check connection
/mcp desc               # Show tool descriptions

# Example usage
"Use Claude to view README.md"
"Ask Claude to edit config.json"
"Have Claude list all .cpp files"
```