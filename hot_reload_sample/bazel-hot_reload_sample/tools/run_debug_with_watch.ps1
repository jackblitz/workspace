Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  Starting Hot Reload Development Environment" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# Start the watcher in a new window
Write-Host "Starting file watcher in a new window..." -ForegroundColor Yellow
$scriptPath = $PSScriptRoot
Start-Process -FilePath "cmd.exe" -ArgumentList "/k", "$scriptPath\watch.bat" -WindowStyle Minimized

# Give the watcher a moment to start
Start-Sleep -Seconds 2

# Build the project first
Write-Host "Building the project..." -ForegroundColor Yellow
& cmd /c "$scriptPath\build_debug.bat"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Check the error messages above." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "  Starting Debug Host with Hot Reload" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  The watcher is running in a separate window." -ForegroundColor Yellow
Write-Host "  Edit your code and save to see changes instantly!" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Press Ctrl+C to stop the application." -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""

# Run the host executable
& ..\bazel-bin\host\hot_reload_host.exe

# When the host exits, close the watcher
Write-Host ""
Write-Host "Closing watcher window..." -ForegroundColor Yellow
Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like "*Hot Reload Watcher*" }

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Read-Host "Press Enter to exit"