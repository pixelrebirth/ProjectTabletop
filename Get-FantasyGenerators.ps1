[cmdletbinding()]
param()
DynamicParam {
    [Scriptblock]$List = {Get-Content $PSScriptRoot\Data\FantasyDescPhp.txt}
    return ./Functions/Get-DynamicParam.ps1 -ParamName "SearchName" -ParamCode $List
}

begin {
    $SearchName = $PsBoundParameters['SearchName']
}
process {
    $ie = New-Object -ComObject "InternetExplorer.Application"
    $ie.silent = $true
    $ie.Navigate("https://www.fantasynamegenerators.com/$SearchName.php")
    while($ie.ReadyState -ne 4) {start-sleep -m 100}
    while ($ie.Busy) {Start-Sleep -Milliseconds 50}
    $body = $ie.document.getElementById('result').innerText
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
    Remove-Variable ie
}
end {
 return $body
}