#!/bin/bash

# Claude Code MCP Server Startup Script
# This server exposes Claude's tools (View, Edit, LS) to MCP clients like Gemini

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/mcp/server-config.json"

echo "==================================="
echo "Claude Code MCP Server"
echo "==================================="
echo ""
echo "Configuration: $CONFIG_FILE"
echo "Server will listen on: localhost:3000"
echo ""
echo "Starting server..."
echo "Press Ctrl+C to stop"
echo ""

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Start the MCP server with debug mode for better visibility
claude mcp serve --debug

# Alternative: If you need to specify the config file explicitly
# claude mcp serve --debug --config "$CONFIG_FILE"