#!/bin/bash

# View Claude MCP logs to see what Gemini is doing
# Cross-platform script that works in WSL/Linux/macOS

# Detect if running in WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
else
    IS_WSL=false
fi

LOG_DIR="$HOME/.claude/logs"
GEMINI_LOG_MARKERS=("MCP request" "Tool:" "view" "edit" "ls")

echo "==================================="
echo "Claude MCP Activity Logs"
echo "==================================="
echo ""

# Function to show recent MCP activity
show_recent_activity() {
    echo "Recent MCP Activity (last 50 lines):"
    echo ""
    
    if [ -d "$LOG_DIR" ]; then
        # Find the most recent log file
        latest_log=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
        
        if [ -f "$latest_log" ]; then
            echo "Log file: $latest_log"
            echo ""
            tail -50 "$latest_log" | grep -E "(MCP|Tool|view|edit|ls|request|response)" | tail -20
        else
            echo "No log files found in $LOG_DIR"
        fi
    else
        echo "Log directory not found: $LOG_DIR"
    fi
}

# Function to monitor logs in real-time
monitor_logs() {
    echo "Monitoring Claude MCP logs in real-time..."
    echo "Press Ctrl+C to stop"
    echo ""
    
    if [ -d "$LOG_DIR" ]; then
        latest_log=$(ls -t "$LOG_DIR"/*.log 2>/dev/null | head -1)
        
        if [ -f "$latest_log" ]; then
            tail -f "$latest_log" | grep --line-buffered -E "(MCP|Tool|view|edit|ls|request|response)"
        else
            echo "No log files found"
        fi
    fi
}

# Main menu
case "$1" in
    "monitor"|"-m")
        monitor_logs
        ;;
    "recent"|"-r")
        show_recent_activity
        ;;
    *)
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  recent, -r     Show recent MCP activity"
        echo "  monitor, -m    Monitor logs in real-time"
        echo ""
        echo "Example:"
        echo "  $0 monitor    # Watch logs in real-time"
        echo "  $0 recent     # Show recent activity"
        ;;
esac