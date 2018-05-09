[CmdletBinding()]
param(
    [ValidateSet("Fantasy","Modern","SciFI")]$Genre = "Fantasy",
    [ValidateSet("Villains","Neutrals","Allies")]$Alignment = "Neutrals",
    [ValidateSet("Memorable","Forgettable")]$Stature = "Forgettable",
    $Level = 5
)

DynamicParam {
    . ./LoadClasses.ps1
    [Scriptblock]$ScriptBlock = {((Get-Content $PSScriptRoot\Data\Traits.txt) -split(",")).trim().tolower() | sort -unique}
    return Get-DynamicParam -ParamName Trait -ParamCode $ScriptBlock
}

begin {
    $Trait = $PsBoundParameters['Trait']
    if ($Trait -eq "" -or $Trait -eq $null){$Trait = '.*'}
    . ./LoadClasses.ps1
}

process {
    [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,$Level)
}

end {}