param($exportFormat)

$ErrorActionPreference = "Stop"

Set-Location C:\Users\Admin\Pictures # alias: cd

# HashTable para coluna de nome
$nameExp = @{
  Label      = "Name";
  Expression = { $_.Name }
}

# HashTable para coluna de tamanho
$lengthExp = @{
  Label      = "Size";
  Expression = { "{0:N2}KB" -f ($_.Length / 1kb) }
}

# Array de parâmetros
$params = $nameExp, $lengthExp

$result = 
Get-ChildItem -Recurse -File | # alias: gci
Where-Object Name -like "*.png" | # alias: ?
Select-Object $params # alias: select

Set-Location C:\Users\admin\Desktop\workspace\curso-powershell

$acceptedFormats = "Accepted formats are JSON, HTML and CSV"

if ($exportFormat -eq "JSON") {
  $result | ConvertTo-Json | Out-File report.json
  Write-Output "report generated in report.json"
}
elseif ($exportFormat -eq "CSV") {
  $result | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File report.csv
  Write-Output "report generated in report.csv"
}
elseif ($exportFormat -eq "HTML") {
  $htmlStyle = Get-Content .\style.css
  $styleTag = "<style>$htmlStyle</style>"
  $htmlTitle = "Script Generated Report"
  $bodyTitle = "<h1>$htmlTitle</h1>"
  
  $result |
  ConvertTo-Html -Head $styleTag -Title $htmlTitle -Body $bodyTitle |
  Out-File report.html
  Write-Output "report generated in report.html"
}
elseif (!$exportFormat) {
  Write-Error -Message "You must pass an export format as parameter. $acceptedFormats" -Category InvalidOperation
}
else {
  Write-Error -Message "Invalid export format: $exportFormat. $acceptedFormats" -Category InvalidArgument
}
