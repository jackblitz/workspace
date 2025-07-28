# PowerShell script to sync build outputs to build/debug directory
param(
    [string]$SourceDir = "bazel-bin\host",
    [string]$DestDir = "build\debug"
)

Write-Host "Starting build output sync..." -ForegroundColor Green
Write-Host "Watching: $SourceDir" -ForegroundColor Yellow
Write-Host "Copying to: $DestDir" -ForegroundColor Yellow
Write-Host ""

# Create destination directory if it doesn't exist
if (!(Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

# Initial copy of existing files
if (Test-Path "$SourceDir\hot_reload_host.exe") {
    Copy-Item "$SourceDir\hot_reload_host.exe" -Destination $DestDir -Force
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Copied hot_reload_host.exe" -ForegroundColor Green
}
if (Test-Path "$SourceDir\game_logic.dll") {
    Copy-Item "$SourceDir\game_logic.dll" -Destination $DestDir -Force
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Copied game_logic.dll" -ForegroundColor Green
}

# Set up file watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $SourceDir
$watcher.Filter = "*.*"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite, [System.IO.NotifyFilters]::FileName

$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $fileName = Split-Path $path -Leaf
    
    if ($fileName -eq "hot_reload_host.exe" -or $fileName -eq "game_logic.dll") {
        Start-Sleep -Milliseconds 100  # Brief delay to ensure file write is complete
        
        try {
            Copy-Item $path -Destination $DestDir -Force
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Updated $fileName" -ForegroundColor Green
        }
        catch {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Failed to copy $fileName" -ForegroundColor Red
        }
    }
}

Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $action

$watcher.EnableRaisingEvents = $true

Write-Host "File sync is running. Press Ctrl+C to stop." -ForegroundColor Cyan
Write-Host ""

# Keep the script running
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Write-Host "File sync stopped." -ForegroundColor Yellow
}