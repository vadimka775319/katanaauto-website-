# Auto-deploy: uploads files when they change
# Run and leave open - saves will trigger upload

param(
    [string]$Method = "ftp"
)

$ftpHost = "95.81.124.28"
$ftpUser = "root"
$ftpPass = "vMm9l4z1C300"
$remotePath = "/var/www/html"
$localPath = $PSScriptRoot

function Upload-File {
    param($path)
    $rel = $path.Replace("$localPath\", "").Replace("\", "/")
    $uri = "ftp://$ftpHost$remotePath/$rel"
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)
        $wc.UploadFile($uri, $path)
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] OK: $rel" -ForegroundColor Green
    } catch {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Fail: $rel" -ForegroundColor Red
    }
}

function Upload-All {
    Write-Host "`nUploading all files..." -ForegroundColor Cyan
    $wc = New-Object System.Net.WebClient
    $wc.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)
    
    $files = Get-ChildItem $localPath -Recurse -File | Where-Object {
        $_.Name -notmatch "\.(bat|ps1|zip|md)$" -and
        $_.FullName -notmatch "\\\.git\\" -and
        $_.FullName -notmatch "deploy"
    }
    
    foreach ($f in $files) {
        $rel = $f.FullName.Replace("$localPath\", "").Replace("\", "/")
        try {
            $uri = "ftp://$ftpHost$remotePath/$rel"
            $wc.UploadFile($uri, $f.FullName)
            Write-Host "OK: $rel" -ForegroundColor Green
        } catch { Write-Host "Fail: $rel" -ForegroundColor Red }
    }
    Write-Host "Done.`n" -ForegroundColor Cyan
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Auto-deploy to katanaauto38.ru" -ForegroundColor Cyan
Write-Host "  (FTP) Watching for changes..." -ForegroundColor Cyan
Write-Host "  Ctrl+C to stop" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan

Upload-All

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $localPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $path = $Event.SourceEventArgs.FullPath
    if ($path -match "deploy|\.git|\.bat$|\.ps1$|\.zip$|\.md$") { return }
    Start-Sleep -Milliseconds 500
    Upload-File -path $path
}

Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
Register-ObjectEvent $watcher "Created" -Action $action | Out-Null

try {
    while ($true) { Start-Sleep 1 }
} finally {
    Get-EventSubscriber | Unregister-Event
}
