# Monitoring Gemini-Claude MCP Connection

## How to Know When Gemini is Using Claude

There are several ways to monitor when Gemini CLI is actively using Claude through MCP:

### 1. Visual Indicators in Gemini

When Gemini uses Claude, you'll see:
- **Confirmation prompts** (since `trust: false`): Gemini will ask "Do you want to execute this tool?" before running Claude's commands
- **Tool execution messages**: Messages like "Executing tool: view" or "Executing tool: edit"
- **MCP server status**: Use `/mcp` command in Gemini to see connection status

### 2. Process Monitoring

Use the monitoring script:
```bash
.gemini/monitor-claude-mcp.sh
```

This shows:
- When Claude MCP server starts/stops
- Active requests being processed
- CPU/Memory usage during operations
- File operations in progress

### 3. Log Monitoring

View Claude MCP logs:
```bash
# Show recent activity
.gemini/claude-mcp-logs.sh recent

# Monitor in real-time
.gemini/claude-mcp-logs.sh monitor
```

### 4. In Gemini CLI

Check MCP status:
```
/mcp              # Shows all MCP servers and their status
/mcp desc         # Shows detailed descriptions
```

### 5. Debug Mode Indicators

With debug mode enabled in settings.json, you'll see:
- Detailed MCP communication logs
- Tool invocation details
- Request/response data

## Common Activity Patterns

When Gemini uses Claude, you'll typically see:

1. **MCP Server Start**: Claude MCP process appears when first tool is used
2. **Tool Execution**: Messages about "view", "edit", or "ls" operations
3. **File Access**: Claude accessing files in your project
4. **Confirmation Dialogs**: Gemini asking permission to execute Claude's tools

## Example Session

```
Gemini> Use Claude to view the main.cpp file

[Gemini will show a confirmation prompt]
> Execute tool 'view' with arguments: {"file_path": "app/main.cpp"}? (y/n)

[After confirming]
> Executing tool: view
> Tool execution complete

[Claude's response with file contents appears]
```

## Troubleshooting

If you don't see Claude being used:
1. Check MCP status with `/mcp`
2. Ensure settings.json is properly configured
3. Look for error messages in Gemini
4. Check if Claude CLI is installed: `which claude`
5. Review logs for connection issues