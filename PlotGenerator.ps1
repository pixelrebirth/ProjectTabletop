[CmdletBinding()]
param (
    [ValidateSet("all","fantasy","scifi","horror")]$PlotType = "all"
)

DynamicParam {
    [Scriptblock]$ScriptAdapted = {((Get-Content $PSScriptRoot\Data\PlotAdaptedTo.txt) -split(",")).trim().tolower() | sort -unique}
    [Scriptblock]$ScriptTags = {((Get-Content $PSScriptRoot\Data\PlotTags.txt) -split(",")).trim().tolower() | sort -unique}
    return ./Functions/Get-DynamicParam.ps1 -ParamName @("TagsFilter","AdaptedToFilter") -ParamCode @($ScriptTags,$ScriptAdapted)
}

begin {
    $TagsFilter = $PsBoundParameters['TagsFilter']
    $AdaptedToFilter = $PsBoundParameters['AdaptedToFilter']
}

process {
    $content = get-content -path $PSScriptRoot/data/plots/$($PlotType).txt
    $ParsedContent = ($content) -split('\=\=') | where {$_ -match "Tags:.*$TagsFilter.*$" -and $_ -match "Easily adapted to:.*$AdaptedToFilter.*\*Tags:"}
    $RandomNumber = Get-Random -min 0 -max ($ParsedContent.count - 1)
    $SelectChoice = ($ParsedContent[$RandomNumber].split("*")) -split("\.|\!|\?")

    $OutputObject = [PSCustomObject]@{
        Title = $SelectChoice[0] 
        AdaptedTo = ($SelectChoice[-2]) -replace("Easily adapted to: ","")
        Tags = ($SelectChoice[-1]) -replace("Tags: \(.*\) ","")
        ContentArray = $SelectChoice[1..$($SelectChoice.count - 3)]
    }
}

end {
    return $OutputObject
}