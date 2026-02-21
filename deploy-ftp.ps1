# FTP Deploy - try if SSH doesn't work
# Note: VPS often has no FTP - use hosting panel file manager instead

$ftpHost = "95.81.124.28"
$ftpUser = "root"
$ftpPass = "vMm9l4z1C300"
$remotePath = "/var/www/html"
$localPath = $PSScriptRoot

# Build FTP URL (FTP uses port 21)
$ftpUrl = "ftp://$ftpHost$remotePath"

Write-Host "Deploying via FTP to $ftpHost" -ForegroundColor Cyan

$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

$files = @(
    "index.html", "styles.css", "script.js", "data.js", "admin.html", "README.md"
)

foreach ($file in $files) {
    $localFile = Join-Path $localPath $file
    if (Test-Path $localFile) {
        try {
            $uri = New-Object Uri("$ftpUrl/$file")
            $webclient.UploadFile($uri, $localFile)
            Write-Host "OK: $file" -ForegroundColor Green
        } catch {
            Write-Host "Fail: $file - $_" -ForegroundColor Red
        }
    }
}

# Upload images folder
$imagesPath = Join-Path $localPath "images"
if (Test-Path $imagesPath) {
    Get-ChildItem $imagesPath -File | ForEach-Object {
        try {
            $uri = New-Object Uri("$ftpUrl/images/$($_.Name)")
            $webclient.UploadFile($uri, $_.FullName)
            Write-Host "OK: images/$($_.Name)" -ForegroundColor Green
        } catch { Write-Host "Fail: $($_.Name)" -ForegroundColor Red }
    }
}

Write-Host "Done." -ForegroundColor Green
