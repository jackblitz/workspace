# Workaround for Gemini CLI tool registration error

Write-Host "Gemini CLI Error Workaround" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

Write-Host "The error suggests Gemini CLI is trying to register tools with incompatible parameters." -ForegroundColor Yellow
Write-Host "This is likely a bug in Gemini CLI when using certain API keys." -ForegroundColor Yellow
Write-Host ""

Write-Host "Workarounds to try:" -ForegroundColor Green
Write-Host ""

Write-Host "1. Set API key manually in the session:" -ForegroundColor White
Write-Host '   $env:GEMINI_API_KEY = "your-key-here"' -ForegroundColor Gray
Write-Host '   gemini --disable-default-tools' -ForegroundColor Gray
Write-Host ""

Write-Host "2. Try with minimal configuration:" -ForegroundColor White
Write-Host "   Create a minimal config file without tools" -ForegroundColor Gray
Write-Host ""

Write-Host "3. Use Gemini API directly (bypass CLI):" -ForegroundColor White
Write-Host "   Here's a simple PowerShell script:" -ForegroundColor Gray
Write-Host ""

# Create a simple API script
$apiScript = @'
# Direct Gemini API call
$apiKey = $env:GOOGLE_API_KEY
$model = "gemini-1.5-pro"
$url = "https://generativelanguage.googleapis.com/v1/models/${model}:generateContent?key=${apiKey}"

$body = @{
    contents = @(
        @{
            parts = @(
                @{
                    text = "Hello, Gemini! Can you see this message?"
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host "Gemini Response:" -ForegroundColor Green
    Write-Host $response.candidates[0].content.parts[0].text
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
'@

Write-Host $apiScript -ForegroundColor DarkGray
Write-Host ""

Write-Host "4. Report the issue:" -ForegroundColor White
Write-Host "   This appears to be a bug in Gemini CLI" -ForegroundColor Gray
Write-Host "   Report at: https://github.com/google-gemini/gemini-cli/issues" -ForegroundColor Gray
Write-Host ""
Write-Host "   Error details: function_declarations[23].parameters.properties[url].format" -ForegroundColor Gray
Write-Host "   The CLI is trying to register a tool with a URL parameter that has" -ForegroundColor Gray
Write-Host "   an unsupported format type for the Gemini API." -ForegroundColor Gray

# Save the API script
$apiScript | Out-File -FilePath "test-gemini-api.ps1" -Encoding UTF8
Write-Host ""
Write-Host "Saved API test script to: test-gemini-api.ps1" -ForegroundColor Green
Write-Host "Run it with: .\test-gemini-api.ps1" -ForegroundColor Yellow