#!/bin/bash

# Monitor Claude MCP usage by Gemini CLI
# This script shows when Gemini is actively using Claude

echo "==================================="
echo "Claude MCP Activity Monitor"
echo "==================================="
echo ""
echo "Monitoring Claude MCP server usage..."
echo "Press Ctrl+C to stop"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to check if Claude MCP process exists
check_mcp_process() {
    if pgrep -f "claude mcp serve" > /dev/null; then
        local pid=$(pgrep -f "claude mcp serve")
        echo -e "${GREEN}✓ Claude MCP Server Active${NC} (PID: $pid)"
        return 0
    else
        echo -e "${RED}✗ Claude MCP Server Not Running${NC}"
        return 1
    fi
}

# Function to monitor process activity
monitor_activity() {
    local pid=$1
    local cpu_usage=$(ps -p $pid -o %cpu | tail -1 | tr -d ' ')
    local mem_usage=$(ps -p $pid -o %mem | tail -1 | tr -d ' ')
    
    echo -e "CPU Usage: ${YELLOW}${cpu_usage}%${NC} | Memory: ${YELLOW}${mem_usage}%${NC}"
}

# Initial check
echo -e "${BLUE}Initial Status:${NC}"
if check_mcp_process; then
    MCP_PID=$(pgrep -f "claude mcp serve")
else
    echo ""
    echo -e "${YELLOW}Claude MCP server is not running.${NC}"
    echo "Gemini will start it automatically when needed."
    echo ""
    echo "Waiting for Gemini to start Claude MCP..."
fi

# Monitor loop
LAST_STATUS=""
while true; do
    if pgrep -f "claude mcp serve" > /dev/null; then
        MCP_PID=$(pgrep -f "claude mcp serve")
        
        # Check if this is a new process
        if [ "$LAST_STATUS" != "running" ]; then
            echo ""
            echo -e "${GREEN}[$(date '+%H:%M:%S')] Claude MCP Started!${NC}"
            echo -e "Gemini is now connected to Claude (PID: $MCP_PID)"
            LAST_STATUS="running"
        fi
        
        # Check for active file operations by monitoring CPU usage
        cpu_usage=$(ps -p $MCP_PID -o %cpu | tail -1 | tr -d ' ' | cut -d. -f1)
        if [ "$cpu_usage" -gt 5 ] 2>/dev/null; then
            echo -e "${GREEN}[$(date '+%H:%M:%S')] Active:${NC} Claude is processing a request"
            monitor_activity $MCP_PID
        fi
        
        # Check for open files (indicates active operations)
        open_files=$(lsof -p $MCP_PID 2>/dev/null | grep -E "\.md$|\.cpp$|\.h$|\.txt$" | wc -l)
        if [ "$open_files" -gt 0 ]; then
            echo -e "${BLUE}[$(date '+%H:%M:%S')] File Operations:${NC} $open_files files being accessed"
        fi
        
    else
        if [ "$LAST_STATUS" = "running" ]; then
            echo ""
            echo -e "${YELLOW}[$(date '+%H:%M:%S')] Claude MCP Stopped${NC}"
            echo "Waiting for next activation..."
            LAST_STATUS="stopped"
        fi
    fi
    
    sleep 2
done