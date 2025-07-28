# Fixing "claude-code disconnected" in Gemini

## Quick Fix Steps

### 1. Test your setup
Run this PowerShell script to diagnose:
```powershell
cd D:\workspace\dev\.gemini
.\test-mcp-connection.ps1
```

This will:
- Find where Claude is installed
- Test if MCP serve works
- Generate the correct settings.json

### 2. Common Issues and Solutions

#### Issue: "claude-code" shows as disconnected

**Solution A: Claude not in PATH**
```json
{
  "mcpServers": {
    "claude-code": {
      "command": "C:\\full\\path\\to\\claude.exe",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

**Solution B: Using WSL Claude**
```json
{
  "mcpServers": {
    "claude-code": {
      "command": "wsl",
      "args": ["claude", "mcp", "serve"],
      "env": {}
    }
  }
}
```

**Solution C: Using cmd wrapper**
```json
{
  "mcpServers": {
    "claude-code": {
      "command": "cmd",
      "args": ["/c", "claude", "mcp", "serve"],
      "env": {}
    }
  }
}
```

### 3. Verify Claude Installation

#### Windows Command Prompt:
```cmd
where claude
claude --version
```

#### PowerShell:
```powershell
Get-Command claude
claude --version
```

#### WSL:
```bash
which claude
claude --version
```

### 4. Manual Test

Try starting the MCP server manually:
```bash
claude mcp serve
```

You should see output indicating the server is running.

### 5. Debug in Gemini

1. Start Gemini with verbose logging:
   ```
   gemini --verbose
   ```

2. Check MCP status:
   ```
   /mcp
   ```

3. Look for error messages about why connection failed

### 6. Alternative: Direct stdio test

Create this test file `test-stdio.json`:
```json
{
  "mcpServers": {
    "claude-code": {
      "command": "echo",
      "args": ["test"],
      "env": {}
    }
  }
}
```

If this connects, the issue is with finding Claude.

## Still Not Working?

1. **Check Windows Defender/Antivirus**: May block stdio communication
2. **Run as Administrator**: Some systems require elevated permissions
3. **Check Event Viewer**: Look for application errors
4. **Try absolute paths**: Use full path to claude.exe
5. **Update Claude CLI**: Make sure you have the latest version

## Working Example

Once connected, you should see:
```
/mcp
claude-code: connected
  Tools: view, edit, ls
```