# Test Gemini CLI without MCP servers

Write-Host "Testing Gemini CLI (without MCP)" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Current configuration:" -ForegroundColor Yellow
Write-Host "- API Key: Configured in .env" -ForegroundColor Green
Write-Host "- MCP Servers: DISABLED for testing" -ForegroundColor Yellow
Write-Host ""

Write-Host "Steps to test:" -ForegroundColor Cyan
Write-Host "1. Start Gemini CLI: gemini" -ForegroundColor White
Write-Host "2. Try a simple prompt: 'Hello, can you see this?'" -ForegroundColor White
Write-Host "3. If it works, the issue is with MCP configuration" -ForegroundColor White
Write-Host ""

Write-Host "To re-enable Claude MCP later:" -ForegroundColor Yellow
Write-Host "Copy settings-backup.json to settings.json" -ForegroundColor White
Write-Host ""

# Show current settings
Write-Host "Current settings.json:" -ForegroundColor Gray
Get-Content "settings.json" | Write-Host -ForegroundColor Gray