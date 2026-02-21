# Katana Auto - Deploy to server
param([int]$Port = 22)

$Server = "root@95.81.124.28"
$RemotePath = "/var/www/html"
$LocalPath = $PSScriptRoot

$scpArgs = @("-r", "-o", "StrictHostKeyChecking=no", "-o", "ConnectTimeout=10")
if ($Port -ne 22) { $scpArgs += "-P", $Port }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploy to katanaauto38.ru" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Server: $Server | Port: $Port" -ForegroundColor Yellow
Write-Host "Enter root password when prompted" -ForegroundColor Gray
Write-Host ""

& scp @scpArgs "$LocalPath\*" "${Server}:${RemotePath}/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done! https://katanaauto38.ru" -ForegroundColor Green
} else {
    Write-Host "Connection failed. Try: .\deploy.ps1 -Port 2222" -ForegroundColor Red
}

Read-Host "Press Enter to exit"
