#!/bin/bash

# Script to connect Gemini to Claude Code MCP Server
# This establishes the MCP connection between Gemini and Claude

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_CONFIG="$SCRIPT_DIR/mcp/gemini-client-config.json"
SERVER_CONFIG="$SCRIPT_DIR/mcp/server-config.json"

echo "==================================="
echo "Gemini-Claude MCP Connection Setup"
echo "==================================="
echo ""

# Check if MCP server is running
if ! pgrep -f "claude mcp serve" > /dev/null; then
    echo "MCP server is not running. Starting it now..."
    "$SCRIPT_DIR/start-mcp-server.sh" &
    sleep 2
fi

echo "MCP Server Status: Running"
echo "Gemini Config: $GEMINI_CONFIG"
echo ""
echo "Connection Details:"
echo "- Protocol: stdio (standard input/output)"
echo "- Tools Available: view, edit, ls"
echo "- Resource Access: file:///*"
echo ""

# Display connection instructions for Gemini
cat << EOF
To connect Gemini to Claude's MCP server:

1. In Gemini, configure the MCP client with these settings:
   - Server Command: claude mcp serve --debug
   - Transport Type: stdio
   - Available Tools: view, edit, ls

2. Use the configuration file at:
   $GEMINI_CONFIG

3. Example usage in Gemini:
   - "Use Claude to view file /path/to/file"
   - "Ask Claude to edit the configuration"
   - "Have Claude list files in directory"

The server is ready to accept connections.
EOF