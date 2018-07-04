function Format-PhotoshopExport {
    param (
        $PlayerCharacter
    )

    $ExportArray = @("CharacterName","TalentName","PlayerName","GearSlot18","GearSlot17","GearSlot16",
        "GearSlot15","GearSlot14","GearSlot13","GearSlot12","GearSlot11","GearSlot10","GearSlot9",
        "GearSlot8","GearSlot7","GearSlot6","GearSlot5","GearSlot4","GearSlot3","GearSlot2","GearSlot1",
        "Foe","WhatSeek","Hobby","Food","WhereFrom","Idol","DiscoverMagic","MostLikelyDo","Lover",
        "BestFriend","Family","LastWar","Organization","BankGold","Amulet","Ring","Shield","Helm",
        "ArmorSet","SideArm","MainRanged","MainMelee","TalentAbility","Vise","Virtue","XP","Race",
        "Phys","Sub","Know","Comm","Surv","SideArmCM","RangedCM","MeleeCM","Heroism","SpellResist",
        "SpellCM","AC","HP","Mind","Str","Dex","Level","MeleeFail","RangedFail","SpellFail","RaceBonus",
        "Titles","Points0","Points1","Points2","Points3","Points4","Points5","Points6","Points7","Points8","Points9"
    )

    $PlayerCharacter.str = "$($PlayerCharacter.str) [$($PlayerCharacter.strmod)]"
    $PlayerCharacter.dex = "$($PlayerCharacter.dex) [$($PlayerCharacter.dexmod)]"
    $PlayerCharacter.mind = "$($PlayerCharacter.mind) [$($PlayerCharacter.mindmod)]"
    
    $PlayerCharacter.spellcm = "+$($PlayerCharacter.spellcm)"

    $PlayerCharacter.virtue -match '^(\w+)\\(\w+)$|^(\w+)\/(\w+)$'
    $PlayerCharacter.virtue = "$($matches[1]) + 2 \ $($matches[2]) + 2"
    
    $PlayerCharacter.vise -match '^(\w+)\\(\w+)$|^(\w+)\/(\w+)$'
    $PlayerCharacter.vise = "$($matches[1]) - 2 \ $($matches[2]) - 2"

    $PlayerCharacter.BankGold = "Banked Gold: $($PlayerCharacter.BankGold)"
    $PlayerCharacter.Titles = "$($PlayerCharacter.Titles -replace(';',"`n"))"

    $PlayerCharacter.MeleeFail = "$($PlayerCharacter.MeleeFail)%"
    $PlayerCharacter.RangedFail = "$($PlayerCharacter.RangedFail)%"
    $PlayerCharacter.SpellFail = "$($PlayerCharacter.SpellFail)%"

    $ExportArray | foreach {
        if ($PlayerCharacter."$_" -eq $null -or $PlayerCharacter."$_" -eq ""){$PlayerCharacter."$_" = "None"}
    }
    $PlayerCharacter | select $ExportArray | Export-Csv -Encoding ASCII -Path 'E:\temp\PSImport.csv' -NoTypeInformation
}