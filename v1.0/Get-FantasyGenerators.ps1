[cmdletbinding()]
param()
DynamicParam {
    . ./LoadClasses.ps1
    [Scriptblock]$List = {Get-Content $PSScriptRoot\Data\FantasyDescPhp.txt}
    return Get-DynamicParam -ParamName "SearchName" -ParamCode $List
}

begin {
    $SearchName = $PsBoundParameters['SearchName']
}
process {
    $ie = New-Object -ComObject "InternetExplorer.Application"
    $ie.silent = $true
    $ie.Navigate("https://www.fantasynamegenerators.com/$SearchName.php")
    $timeout = 0
    while ($timeout -lt 40 -and $ie.ReadyState -ne 4) {
        start-sleep -m 100
        $timeout++
    }
    $timeout = 0
    while ($timeout -lt 40 -and $ie.Busy) {
        Start-Sleep -Milliseconds 100
        $timeout++
    }
    
    try {
        $body = $ie.document.getElementById('result').innerText
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie) 
        Remove-Variable ie | Out-Null
        Get-Process iexplore | Stop-Process -force | Out-Null
    }
    catch {}

}
end {
 return $body
}