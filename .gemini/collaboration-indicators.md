# How to Know When Gemini is Using Claude

## Visual Indicators in Gemini's Responses

When Gemini is collaborating with Claude, you'll see these clear indicators:

### 1. **Consultation Announcements**
```
🤝 Consulting Claude for technical analysis...
```

### 2. **MCP Tool Usage Messages**
```
> Execute tool 'view' with arguments: {"file_path": "..."}? (y/n)
> Executing tool: view
> Tool execution complete
```

### 3. **Status Indicators**
- `📡 MCP Connection Active` - Claude is being consulted
- `🔧 Claude is analyzing...` - Processing technical request
- `✅ Received technical assessment` - Claude has responded
- `🤝 Consulting Claude...` - Starting consultation

### 4. **Clear Communication Pattern**
Gemini will always:
1. Announce the consultation
2. Show what's being asked
3. Display Claude's response
4. Explain the decision made

## Example of What You'll See:

```
You: "Should we use WebSockets or HTTP/2 for streaming?"

Gemini: "Let me evaluate both options for our video streaming needs.

🤝 Consulting Claude for technical analysis...

Ask Claude: What are the technical trade-offs between WebSockets and HTTP/2 
for video streaming in our ECS architecture? Consider latency, browser 
compatibility, and server resource usage.

📡 Waiting for Claude's response through MCP...

✅ Received technical assessment from Claude:
- WebSockets: Better for bidirectional real-time communication
- HTTP/2: Better for unidirectional streaming with built-in multiplexing
- Resource usage: HTTP/2 more efficient for our use case
- Compatibility: Both have good browser support

Based on Claude's analysis, I'm deciding on HTTP/2 for our video streaming. 
It aligns better with our unidirectional streaming needs and offers better 
resource efficiency.

🔧 Now I'll have Claude implement the HTTP/2 streaming system..."
```

## Behind the Scenes

### In Gemini CLI:
- You'll see `/mcp` showing `claude-code: connected`
- Tool execution prompts when Claude uses file operations
- MCP activity in the console

### In Monitoring Scripts:
- Run `.\monitor-claude-mcp.ps1` to see real-time activity
- Process monitoring shows when Claude MCP is active
- Log files capture all MCP interactions

## Quick Check Commands

### In Gemini:
```
/mcp              # Shows Claude connection status
/mcp desc         # Shows available Claude tools
```

### In Terminal:
```powershell
# Check if MCP server is running
.\test-wsl-claude.ps1

# Monitor activity
.\monitor-claude-mcp.ps1
```

## Summary

You'll ALWAYS know when Gemini is using Claude because:
1. **Gemini announces it** with emoji indicators
2. **Shows the exact question** being asked
3. **Displays waiting status** during processing
4. **Shares Claude's response** summary
5. **Explains decisions** based on the consultation

The collaboration is designed to be completely transparent!