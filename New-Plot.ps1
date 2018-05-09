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
    . ./LoadClasses.ps1
}

process {
    [Plot]::new()
    [Plot]::new($PlotType,$TagsFilter,$AdaptedToFilter)
}

end {}