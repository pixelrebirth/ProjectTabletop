function Format-PhotoshopExport {
    param (
        $PlayerCharacter
    )

    $ExportArray = @("CharacterName","TalentName","PlayerName","GearSlot18","GearSlot17","GearSlot16",
        "GearSlot15","GearSlot14","GearSlot13","GearSlot12","GearSlot11","GearSlot10","GearSlot9",
        "GearSlot8","GearSlot7","GearSlot6","GearSlot5","GearSlot4","GearSlot3","GearSlot2","GearSlot1",
        "BankGold","Amulet","Ring","Shield","Helm","ArmorSet","SideArm","MainRanged","MainMelee",
        "TalentAbility","XP","Specialization","SideArmCM","RangedCM","MeleeCM","SpellCM","Speed","Background",
        "SD","MD","RD","HP","Mind","Str","Dex","Level", "MeleeFail","RangedFail","SpellFail","SpecializationBonus","Titles"
    )

    $PlayerCharacter.str = "$($PlayerCharacter.str)"
    $PlayerCharacter.dex = "$($PlayerCharacter.dex)"
    $PlayerCharacter.mind = "$($PlayerCharacter.mind)"

    $PlayerCharacter.BankGold = "Banked Gold: $($PlayerCharacter.BankGold)"
    $PlayerCharacter.Titles = "$($PlayerCharacter.Titles -replace(';',"`n"))"

    $PlayerCharacter.MeleeFail = "$($PlayerCharacter.MeleeFail)%"
    $PlayerCharacter.RangedFail = "$($PlayerCharacter.RangedFail)%"
    $PlayerCharacter.SpellFail = "$($PlayerCharacter.SpellFail)%"

    $ExportArray | foreach {
        if (!$PlayerCharacter."$_"){$PlayerCharacter."$_" = "None"}
    }
    $PlayerCharacter | select $ExportArray | Export-Csv -Encoding ASCII -Path 'E:\temp\PSImport.csv' -NoTypeInformation
}