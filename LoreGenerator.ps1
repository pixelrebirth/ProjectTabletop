param(
    [parameter(Mandatory=$true)][string]$SearchTerm,
    [switch]$RandomLore
)

class Lore {
    $Lore

    Lore () {
        $get = invoke-webrequest -uri "http://eberron.wikia.com/wiki/Special:Random"
        $this.Lore = ((($get.ParsedHtml.body.outertext) -split('\n')) | ? {$_.length -gt 100})
    }

    Lore ($SearchTerm) {
        $Content = (Get-Content $PSScriptRoot\data\EberronHistory.txt) -split('---') | where {$_ -match $SearchTerm}
        $Random = Get-Random -Min 0 -Max $Content.count
        $this.Lore = ($Content[$Random]) -replace("\.  ",".`n")
    }
}

if ($RandomLore -eq $false){
    try {[Lore]::new($SearchTerm)}
    catch {Write-Error "Cannot find `'$SearchTerm`' in the EberronHistory.txt"}
}
else {
    [Lore]::new()
}