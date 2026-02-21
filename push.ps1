# Push and deploy - run after changes
# First time: follow DEPLOY_SETUP.md

cd $PSScriptRoot

git add index.html styles.css script.js data.js admin.html README.md images
git status

$msg = Read-Host "Commit message (or Enter for 'update')"
if ([string]::IsNullOrWhiteSpace($msg)) { $msg = "update" }

git commit -m $msg
git push

Write-Host "`nPushed. GitHub Actions will deploy to server." -ForegroundColor Green
Write-Host "Check: https://github.com/YOUR_USERNAME/katanaauto-website/actions" -ForegroundColor Gray
