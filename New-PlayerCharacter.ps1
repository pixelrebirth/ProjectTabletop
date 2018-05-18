[cmdletbinding()]
param(    
    [int]$XP = 0
)

DynamicParam {
    . ./LoadClasses.ps1

    $ParamNames = @(
        "Race",
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
    
    [Scriptblock]$ScriptRace = {Get-Content $PSScriptRoot\Data\Character\Race.txt}
    [Scriptblock]$ScriptCharacterName = {Get-Content $PSScriptRoot\Data\Character\CharacterName.txt}
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
        $ScriptRace,
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
    $Race = $PsBoundParameters['Race']
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

    . ./LoadClasses.ps1
}

process {
    $DataEntryFields = @("PlayerName","Str","Dex","Mind","BankGold","Amulet","Ring","Helm","ArmorSet","SideArm","MainRanged","MainMelee","Vise","Virtue","GearSlot1","GearSlot2","GearSlot3","GearSlot4","GearSlot5","GearSlot6","GearSlot7","GearSlot8","GearSlot9","GearSlot10","GearSlot11","GearSlot12","GearSlot13","GearSlot14","GearSlot15","GearSlot16","GearSlot17","GearSlot18")
    $PlayerCharacter = [PlayerCharacter]::new()
    
    foreach ($field in $DataEntryFields){
        $Entry = Get-ManualDataEntry -field $field
        if ($field -match "GearSlot" -and $Entry -eq $null){break}
        $PlayerCharacter."$field" = $Entry
    }
# Calculate
# -----
# Level
# Phys
# Sub
# Know
# Comm
# Surv
# SideArmCM
# RangedCM
# MeleeCM
# Heroism
# Fortitude
# Reflex
# Will
# SpellDC
# AC
# HP
}

end {
    $PlayerCharacter
}