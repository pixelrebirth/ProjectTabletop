[cmdletbinding()]
param(    
    [int]$XP = 50
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
    [Scriptblock]$ScriptCharacterName = {
        if ($Global:Set -eq $null){
            $AllNames = Get-Content $PSScriptRoot\Data\Character\CharacterName.txt
            $Random = Get-Random -min 0 -max $AllNames.count
            $Global:Set = $AllNames[$random..($random+100)]
        }
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
    $Level = 0
}

process {
    $PlayerCharacter = [PlayerCharacter]::new()

    $PlayerCharacter.Race = $Race | % {if ($_ -eq $null){. $ScriptRace | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.CharacterName = $CharacterName | % {if ($_ -eq $null){. $ScriptCharacterName | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.TalentName = $TalentName | % {if ($_ -eq $null){. $scriptTalentName | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.MostLikelyDo = $MostLikelyDo | % {if ($_ -eq $null){. $scriptMostLikelyDo | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Hobby = $Hobby | % {if ($_ -eq $null){. $scriptHobby | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Food = $Food | % {if ($_ -eq $null){. $scriptFood | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Idol = $Idol | % {if ($_ -eq $null){. $scriptIdol | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.DiscoverMagic = $DiscoverMagic | % {if ($_ -eq $null){. $scriptDiscoverMagic | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Foe = $Foe | % {if ($_ -eq $null){. $scriptFoe | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.WhatSeek = $WhatSeek | % {if ($_ -eq $null){. $scriptWhatSeek | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Lover = $Lover | % {if ($_ -eq $null){. $scriptLover | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Family = $Family | % {if ($_ -eq $null){. $scriptFamily | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.WhereFrom = $WhereFrom | % {if ($_ -eq $null){. $scriptWhereFrom | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.BestFriend = $BestFriend | % {if ($_ -eq $null){. $scriptBestFriend | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.LastWar = $LastWar | % {if ($_ -eq $null){. $scriptLastWar | Sort {Get-Random} | select -first 1} else {$_}}
    $PlayerCharacter.Organization = $Organization | % {if ($_ -eq $null){. $scriptOrganization | Sort {Get-Random} | select -first 1} else {$_}}

    $PlayerCharacter.RaceBonus = $PlayerCharacter.Race.split(";")[1]
    $PlayerCharacter.Race = $PlayerCharacter.Race.split(";")[0]
    
    $PlayerCharacter.TalentBonus = $PlayerCharacter.TalentName.split(";")[1]
    $PlayerCharacter.TalentName = $PlayerCharacter.TalentName.split(";")[0]
    $PlayerCharacter.XP = $XP
  
    
    # $ReplaceMode = $False
    $PlayerCharacter.FirstLevel()
    
    $XPRemain = $XP
    while ($XPRemain - $Level*10 -ge 0){   
        $PlayerCharacter.LevelUp()
        $Level++
        # if ($Level -gt 1){$ReplaceMode = $true}    
        $XPRemain = $XPRemain - $Level*10
    }
    
    $PlayerCharacter.UpdateStats()
}

end {
    $PlayerCharacter
}