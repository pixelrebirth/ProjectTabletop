[cmdletbinding()]
param(
    [parameter(Mandatory=$true)]$PlayerName,
    [switch]$NoPhotoshop,
    [int]$XP
)

DynamicParam {
    . ./LoadClasses.ps1

    $ParamNames = @(
        "Upbringing",
        "CharacterName",
        "TalentName",
        "MostLikelyDo",
        "Hobby",
        "Food",
        "Idol",
        "DiscoverMagic",
        "Foe",
        "WhatSeek",
        "Lover",
        "Family",
        "WhereFrom",
        "BestFriend",
        "LastWar",
        "Organization"
    )

    [Scriptblock]$ScriptUpbringing = {Get-Content $PSScriptRoot\Data\Character\Upbringing.txt}
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
    [Scriptblock]$ScriptMostLikelyDo = {Get-Content $PSScriptRoot\Data\Character\MostLikelyDo.txt}
    [Scriptblock]$ScriptHobby = {Get-Content $PSScriptRoot\Data\Character\Hobby.txt}
    [Scriptblock]$ScriptFood = {Get-Content $PSScriptRoot\Data\Character\Food.txt}
    [Scriptblock]$ScriptIdol = {Get-Content $PSScriptRoot\Data\Character\Idol.txt}
    [Scriptblock]$ScriptDiscoverMagic = {Get-Content $PSScriptRoot\Data\Character\DiscoverMagic.txt}
    [Scriptblock]$ScriptFoe = {Get-Content $PSScriptRoot\Data\Character\Foe.txt}
    [Scriptblock]$ScriptWhatSeek = {Get-Content $PSScriptRoot\Data\Character\WhatSeek.txt}
    [Scriptblock]$ScriptLover = {Get-Content $PSScriptRoot\Data\Character\Lover.txt}
    [Scriptblock]$ScriptFamily = {Get-Content $PSScriptRoot\Data\Character\Family.txt}
    [Scriptblock]$ScriptWhereFrom = {Get-Content $PSScriptRoot\Data\Character\WhereFrom.txt}
    [Scriptblock]$ScriptBestFriend = {Get-Content $PSScriptRoot\Data\Character\BestFriend.txt}
    [Scriptblock]$ScriptLastWar = {Get-Content $PSScriptRoot\Data\Character\LastWar.txt}
    [Scriptblock]$ScriptOrganization = {Get-Content $PSScriptRoot\Data\Character\Organization.txt}

    $Scripts = @(
        $ScriptUpbringing,
        $ScriptCharacterName,
        $ScriptTalentName,
        $ScriptMostLikelyDo,
        $ScriptHobby,
        $ScriptFood,
        $ScriptIdol,
        $ScriptDiscoverMagic,
        $ScriptFoe,
        $ScriptWhatSeek,
        $ScriptLover,
        $ScriptFamily,
        $ScriptWhereFrom,
        $ScriptBestFriend,
        $ScriptLastWar,
        $ScriptOrganization
    )

    return Get-DynamicParam -ParamName $ParamNames -ParamCode $Scripts
}

begin {
    $Upbringing = $PsBoundParameters['Upbringing']
    $CharacterName = $PsBoundParameters['CharacterName']
    $TalentName = $PsBoundParameters['TalentName']
    $MostLikelyDo = $PsBoundParameters['MostLikelyDo']
    $Hobby = $PsBoundParameters['Hobby']
    $Food = $PsBoundParameters['Food']
    $Idol = $PsBoundParameters['Idol']
    $DiscoverMagic = $PsBoundParameters['DiscoverMagic']
    $Foe = $PsBoundParameters['Foe']
    $WhatSeek = $PsBoundParameters['WhatSeek']
    $Lover = $PsBoundParameters['Lover']
    $Family = $PsBoundParameters['Family']
    $WhereFrom = $PsBoundParameters['WhereFrom']
    $BestFriend = $PsBoundParameters['BestFriend']
    $LastWar = $PsBoundParameters['LastWar']
    $Organization = $PsBoundParameters['Organization']

    Import-Module powershell-yaml
    . ./LoadClasses.ps1
    $Level = 1
}

process {
    $PlayerCharacter = [PlayerCharacter]::new()

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

    Set-PlayerPropertyNull -PropName Upbringing
    Set-PlayerPropertyNull -PropName CharacterName
    Set-PlayerPropertyNull -PropName TalentName
    Set-PlayerPropertyNull -PropName MostLikelyDo
    Set-PlayerPropertyNull -PropName Hobby
    Set-PlayerPropertyNull -PropName Food
    Set-PlayerPropertyNull -PropName Idol
    Set-PlayerPropertyNull -PropName DiscoverMagic
    Set-PlayerPropertyNull -PropName Foe
    Set-PlayerPropertyNull -PropName WhatSeek
    Set-PlayerPropertyNull -PropName Lover
    Set-PlayerPropertyNull -PropName Family
    Set-PlayerPropertyNull -PropName WhereFrom
    Set-PlayerPropertyNull -PropName BestFriend
    Set-PlayerPropertyNull -PropName LastWar
    Set-PlayerPropertyNull -PropName Organization

    if (!$PlayerCharacter.Upbringing -or $PlayerCharacter.Upbringing -notmatch "\;"){
        $UpbringingFull = Get-Content "$PSScriptRoot\data\character\Upbringing.txt" | where {$_ -match "^$($PlayerCharacter.Upbringing);"}
        $PlayerCharacter.Upbringing = $UpbringingFull
    }
    $PlayerCharacter.UpbringingBonus = $PlayerCharacter.Upbringing.split(";")[1]
    $PlayerCharacter.Upbringing = $PlayerCharacter.Upbringing.split(";")[0]

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

    $PlayerCharacter.FirstLevel()

    $XPRemain = $PlayerCharacter.XP
    while ($XPRemain -ge 0){
        $XPRemain = $XPRemain - $Level*10
        $Level++
        $PlayerCharacter.LevelUp()
    }

    $PlayerCharacter.UpdateStats()
}

end {
    $YamlArray = @("PlayerName","CharacterName","Upbringing","TalentName","Titles","StrBase","DexBase","MindBase",
        "Virtue","Vise","Idol","Foe","Lover","Family","WhereFrom","BestFriend","LastWar","Organization",
        "MostLikelyDo","Hobby","Food","DiscoverMagic","WhatSeek","XP","Amulet","Ring","Helm","Shield",
        "ArmorSet","SideArm","MainRanged","MainMelee","GearSlot1","GearSlot2","GearSlot3","GearSlot4",
        "GearSlot5","GearSlot6","GearSlot7","GearSlot8","GearSlot9","GearSlot10","GearSlot11","GearSlot12",
        "GearSlot13","GearSlot14","GearSlot15","GearSlot16","GearSlot17","GearSlot18","BankGold","StrLevel",
        "DexLevel","MindLevel"
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