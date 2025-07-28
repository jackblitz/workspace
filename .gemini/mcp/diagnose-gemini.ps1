# Diagnose Gemini CLI issues

Write-Host "Gemini CLI Diagnostics" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""

# Check Gemini CLI version
Write-Host "1. Checking Gemini CLI version..." -ForegroundColor Yellow
try {
    $version = gemini --version 2>&1
    Write-Host "Version: $version" -ForegroundColor Green
} catch {
    Write-Host "Failed to get version: $_" -ForegroundColor Red
}

Write-Host ""

# Check environment variables
Write-Host "2. Environment variables:" -ForegroundColor Yellow
Write-Host "GEMINI_API_KEY: $(if($env:GEMINI_API_KEY){'Set'}else{'Not set'})" -ForegroundColor Gray
Write-Host "PATH contains gemini: $(if($env:PATH -like '*gemini*'){'Yes'}else{'No'})" -ForegroundColor Gray

Write-Host ""

# Try minimal invocation
Write-Host "3. Testing minimal Gemini invocation..." -ForegroundColor Yellow
Write-Host "Try running: gemini --no-tools" -ForegroundColor White
Write-Host "Or: gemini --disable-tools" -ForegroundColor White
Write-Host "Or: gemini --help (to see available options)" -ForegroundColor White

Write-Host ""
Write-Host "4. Alternative approaches:" -ForegroundColor Yellow
Write-Host "a) Update Gemini CLI:" -ForegroundColor White
Write-Host "   pip install --upgrade gemini-cli" -ForegroundColor Gray
Write-Host "   OR" -ForegroundColor Gray
Write-Host "   npm update -g @google/gemini-cli" -ForegroundColor Gray
Write-Host ""
Write-Host "b) Try Gemini API directly:" -ForegroundColor White
Write-Host "   Use curl or a simple script instead of the CLI" -ForegroundColor Gray
Write-Host ""
Write-Host "c) Check for known issues:" -ForegroundColor White
Write-Host "   https://github.com/google-gemini/gemini-cli/issues" -ForegroundColor Gray