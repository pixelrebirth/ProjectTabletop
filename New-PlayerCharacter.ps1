function New-PlayerCharacter {
    # param(    
    #     $Race,
    #     $CharacterName,
    #     $TalentName,
    #     $Vise,
    #     $Virtue,
    #     $Lover,
    #     $Family,
    #     $WhereFrom,
    #     $BestFriend,
    #     $Foe,
    #     $LastWar,
    #     $Organization
    # )
    
    $DataEntryFields = @("PlayerName","Str","Dex","Mind","BankGold","Amulet","Ring","Helm","ArmorSet","SideArm","MainRanged","MainMelee","Vise","Virtue","GearSlot1","GearSlot2","GearSlot3","GearSlot4","GearSlot5","GearSlot6","GearSlot7","GearSlot8","GearSlot9","GearSlot10","GearSlot11","GearSlot12","GearSlot13","GearSlot14","GearSlot15","GearSlot16","GearSlot17","GearSlot18")
    $PlayerCharacter = [PlayerCharacter]::new()
    
    foreach ($field in $DataEntryFields){
        $Entry = Get-ManualDataEntry -field $field
        if ($field -match "GearSlot" -and $Entry -eq $null){break}
        $PlayerCharacter."$field" = $Entry
    }
    $PlayerCharacter
}

. ./LoadClasses.ps1
New-PlayerCharacter