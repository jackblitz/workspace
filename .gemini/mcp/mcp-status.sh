#!/bin/bash

echo "==================================="
echo "Claude MCP Server Status"
echo "==================================="
echo ""

# Check if MCP server is running
if pgrep -f "claude mcp serve" > /dev/null; then
    PID=$(pgrep -f "claude mcp serve")
    echo "✓ MCP Server is RUNNING (PID: $PID)"
    echo ""
    echo "Server Details:"
    ps -p $PID -o pid,cmd,etime
else
    echo "✗ MCP Server is NOT RUNNING"
    echo ""
    echo "To start the server, run:"
    echo "  claude mcp serve --debug"
fi

echo ""
echo "==================================="
echo "Gemini Connection Instructions:"
echo "==================================="
echo ""
echo "1. Open a new terminal and navigate to this directory:"
echo "   cd $(pwd)"
echo ""
echo "2. Start Gemini CLI:"
echo "   gemini"
echo ""
echo "3. In Gemini, check MCP connection status:"
echo "   /mcp"
echo ""
echo "4. You should see 'claude-code' listed as a connected server"
echo ""
echo "5. Test with a simple command:"
echo "   'Use Claude to list files in the current directory'"
echo ""
echo "Note: The server uses stdio protocol, not network ports."