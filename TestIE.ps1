$ie = New-Object -ComObject "InternetExplorer.Application"
# $ie.visible = $true
$ie.silent = $true
$ie.Navigate("https://www.fantasynamegenerators.com/prophecy-descriptions.php")
while($ie.ReadyState -ne 4) {start-sleep -m 100}
while ($ie.Busy) {Start-Sleep -Milliseconds 50}
$body = $ie.document.getElementById('result').innerText
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
Remove-Variable ie

$body