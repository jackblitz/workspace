# For Windows PowerShell - Run with: .\set-gemini-env.ps1

# Set for current session
$env:GEMINI_API_KEY = "AIzaSyDDWaA_P3MyfpWY8RyPPLCv1A2-lVXq5to"

Write-Host "GEMINI_API_KEY has been set for this PowerShell session" -ForegroundColor Green
Write-Host ""
Write-Host "To make it permanent:" -ForegroundColor Yellow
Write-Host "1. For current user: Run this command:" -ForegroundColor White
Write-Host '   [Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "AIzaSyDDWaA_P3MyfpWY8RyPPLCv1A2-lVXq5to", "User")' -ForegroundColor Gray
Write-Host ""
Write-Host "2. Or add to your PowerShell profile:" -ForegroundColor White
Write-Host "   notepad $PROFILE" -ForegroundColor Gray
Write-Host '   Add: $env:GEMINI_API_KEY = "AIzaSyDDWaA_P3MyfpWY8RyPPLCv1A2-lVXq5to"' -ForegroundColor Gray