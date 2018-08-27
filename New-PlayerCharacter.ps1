[cmdletbinding()]
param(
    [parameter(Mandatory=$true)]$PlayerName,
    [switch]$NoPhotoshop,
    [int]$XP
)

DynamicParam {
    . ./LoadClasses.ps1

    $ParamNames = @(
        "Specialization",
        "CharacterName",
        "TalentName"
    )

    [Scriptblock]$ScriptSpecialization = {Get-Content $PSScriptRoot\Data\Character\Specialization.txt}
    [Scriptblock]$ScriptCharacterName = {
        if ($Global:Set -eq $null){
            $AllNames = Get-Content $PSScriptRoot\Data\Character\CharacterName.txt
            $Random = Get-Random -min 0 -max $AllNames.count
            $Global:Set = $AllNames[$random..($random+100)]
        }
        $Global:Set += "Self"
        $Global:Set
    }
    [Scriptblock]$ScriptTalentName = {Get-Content $PSScriptRoot\Data\Character\TalentName.txt}

    $Scripts = @(
        $ScriptSpecialization,
        $ScriptCharacterName,
        $ScriptTalentName
    )

    return Get-DynamicParam -ParamName $ParamNames -ParamCode $Scripts
}

begin {
    $Specialization = $PsBoundParameters['Specialization']
    $CharacterName = $PsBoundParameters['CharacterName']
    $TalentName = $PsBoundParameters['TalentName']

    Import-Module powershell-yaml
    . ./LoadClasses.ps1
    $Level = 1
}

process {
    $PlayerCharacter = [PlayerCharacter]::new()
    $PlayerCharacter.PlayerName = $PlayerName
    
    try {
        $CharacterImport = Get-ChildItem "$($PSScriptRoot)/data/saves/$PlayerName*.yaml" | where name -notmatch "\.old$" | select -first 1 | Get-Content | ConvertFrom-Yaml
        foreach ($key in $CharacterImport.keys){
            $PlayerCharacter.$key = $CharacterImport.$key
        }
    }
    catch {
        Write-Verbose "There is no character YAML file in Get-ChildItem $($PSScriptRoot)/data/saves/$PlayerName*.yaml"
        Write-Debug "$($Error[0].Exception.Message)"
    }

    Set-PlayerPropertyNull -PropName Specialization
    Set-PlayerPropertyNull -PropName CharacterName
    Set-PlayerPropertyNull -PropName TalentName
    Set-PlayerPropertyNull -PropName Background


    if (!$PlayerCharacter.Specialization -or $PlayerCharacter.Specialization -notmatch "\;"){
        $SpecializationFull = Get-Content "$PSScriptRoot\data\character\Specialization.txt" | where {$_ -match "^$($PlayerCharacter.Specialization);"}
        $PlayerCharacter.Specialization = $SpecializationFull
    }
    $PlayerCharacter.SpecializationBonus = $PlayerCharacter.Specialization.split(";")[1]
    $PlayerCharacter.Specialization = $PlayerCharacter.Specialization.split(";")[0]

    if (!$PlayerCharacter.TalentName -or $PlayerCharacter.TalentName -notmatch "\;"){
        $TalentNameFull = Get-Content "$PSScriptRoot\data\character\TalentName.txt" | where {$_ -match "^$($PlayerCharacter.TalentName);"}
        $PlayerCharacter.TalentName = $TalentNameFull
    }
    $PlayerCharacter.TalentAbility = $PlayerCharacter.TalentName.split(";")[1]
    $PlayerCharacter.TalentName = $PlayerCharacter.TalentName.split(";")[0]

    if (-NOT !$XP){$PlayerCharacter.XP = $XP}

    if (!$PlayerCharacter.XP){
        while ([int]$PlayerCharacter.XP -isnot [int]){
            $PlayerCharacter.XP = Read-Host "Is your character supposed to have XP, how much, try 0"
        }
    }

    $PlayerCharacter.UpdateStats($PlayerCharacter.XP)
}

end {
    $YamlArray = @("PlayerName","CharacterName","Specialization","TalentName","Titles","Background"
        "XP","Amulet","Ring","Helm","Shield","ArmorSet","SideArm","MainRanged","MainMelee",
        "GearSlot1","GearSlot2","GearSlot3","GearSlot4","GearSlot5","GearSlot6","GearSlot7","GearSlot8",
        "GearSlot9","GearSlot10","GearSlot11","GearSlot12","GearSlot13","GearSlot14","GearSlot15","GearSlot16",
        "GearSlot17","GearSlot18","BankGold","StrLevel","DexLevel","MindLevel"
    )

    $PlayerCharacter | Export-Csv "./data/saves/$($PlayerCharacter.PlayerName)-$($PlayerCharacter.CharacterName)`.csv" -Force -NoTypeInformation

    $YamlFile = "./data/saves/$($PlayerCharacter.PlayerName)-$($PlayerCharacter.CharacterName)`.yaml"
    if (Test-Path $YamlFile){Copy-Item $YamlFile "$YamlFile.old" -Force}

    $PlayerCharacter | select $YamlArray | ConvertTo-Yaml | Out-File "./data/saves/$($PlayerCharacter.PlayerName)-$($PlayerCharacter.CharacterName)`.yaml" -Force

    if ($NoPhotoshop -eq $false){
        Format-PhotoshopExport -PlayerCharacter $PlayerCharacter
        Set-SheetGraphics
        Move-Item "E:\temp\PSExport.png" "E:\www\characters\$($PlayerCharacter.PlayerName).png" -Force
    }

    return $PlayerCharacter
}