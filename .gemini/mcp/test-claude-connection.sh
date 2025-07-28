#!/bin/bash

# Test script to verify Gemini-Claude MCP connection

echo "==================================="
echo "Testing Gemini-Claude MCP Connection"
echo "==================================="
echo ""

# Check if Gemini CLI is installed
if ! command -v gemini &> /dev/null; then
    echo "Error: Gemini CLI is not installed or not in PATH"
    echo "Please install Gemini CLI first"
    exit 1
fi

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "Error: Claude CLI is not installed or not in PATH"
    echo "Please install Claude CLI first"
    exit 1
fi

echo "✓ Gemini CLI found"
echo "✓ Claude CLI found"
echo ""

# Check configuration file
CONFIG_FILE="$(dirname "$0")/settings.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "✓ Configuration file found: $CONFIG_FILE"
    echo ""
    echo "Configuration:"
    cat "$CONFIG_FILE" | grep -A 10 "claude-code"
else
    echo "✗ Configuration file not found at $CONFIG_FILE"
    exit 1
fi

echo ""
echo "To test the connection in Gemini CLI:"
echo ""
echo "1. Start Gemini CLI from this directory:"
echo "   cd $(dirname "$0")/.."
echo "   gemini"
echo ""
echo "2. Check MCP server status:"
echo "   /mcp"
echo ""
echo "3. Test Claude's tools:"
echo "   - 'Use Claude to list files in the current directory'"
echo "   - 'Ask Claude to view the README.md file'"
echo "   - 'Have Claude create a test.txt file with hello world'"
echo ""
echo "Note: Since trust is set to false, Gemini will ask for confirmation"
echo "before executing Claude's tools (recommended for security)."