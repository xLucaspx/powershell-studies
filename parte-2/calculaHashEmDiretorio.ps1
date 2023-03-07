param($folder)

$ErrorActionPreference = "Stop"

. "C:\Users\admin\desktop\workspace\curso-powershell\parte-2\shaFile.ps1" # dot source

$files = Get-ChildItem $folder -File

# foreach ($file in $files | ForEach-Object { $_.FullName }) { # Versão mais antiga
foreach ($file in $files.FullName) {
  $hashItem = Get-FileSHA256 $file
  Write-Host "Hash SHA256 do arquivo ${file}: $hashItem"
}
