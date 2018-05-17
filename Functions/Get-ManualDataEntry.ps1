function Get-ManualDataEntry {
    param($field)
    $LongStrings = @("Amulet","Ring","Helm","ArmorSet","SideArm","MainRanged","MainMelee")
    $Entry = $null
    $WeaponPattern = '^[A-Za-z ]+\[\d+d\d+\][string]|^[\w+ ]+ \+ \d+ \[\d+d\d+\][string]'
    $VirtuePattern = '^\w+\\\w+$'
    while ($true){
        
        try {
            switch -regex ($field){
                "PlayerName"        {[ValidateLength(3,15)][string]$Entry = Read-Host "What is your own name"}
                "WorthMoreThanGold" {[ValidateLength(5,36)][string]$Entry = Read-Host "What is worth more than wealth"}
                "Hobby"             {[ValidateLength(5,36)][string]$Entry = Read-Host "What is a hobby you have"}
                "Food"              {[ValidateLength(5,36)][string]$Entry = Read-Host "What is your favorite food"}
                "DiscoverMagic"     {[ValidateLength(5,36)][string]$Entry = Read-Host "How did you first discover you had magic"}
                "WhatSeek"          {[ValidateLength(5,36)][string]$Entry = Read-Host "What do you seek in this world"}
                "Amulet"            {[ValidateLength(0,30)][string]$Entry = Read-Host "Do you have an amulet (ex. Amulet of Hunting + 2)"}
                "Ring"              {[ValidateLength(0,30)][string]$Entry = Read-Host "Do you have a ring (ex. Ring of Shadow + 1)"}
                "Helm"              {[ValidateLength(0,30)][string]$Entry = Read-Host "Do you have a helm (ex. Winged Helm of Brilliance + 3)"}
                "ArmorSet"          {[ValidateLength(0,30)][string]$Entry = Read-Host "Do you have armor (ex. ScaleMail of Endurance + 1 [4])"}
                "SideArm"           {[ValidateLength(0,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a side arm (ex. Dagger of Wisdom + 1 [1d6])"}
                "MainRanged"        {[ValidateLength(0,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a melee weapon (ex. Masterful Bastard Sword of Power + 4 [1d6]"}
                "MainMelee"         {[ValidateLength(0,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a ranged weapon (ex. Longbow of Speed + 3 [1d8]"}
                "Vise"              {[ValidateScript({$_ -match $VirtuePattern})]$Entry = Read-Host "Pick one stat, and one skill that are your vise (ex. MIND\KNOW)"}
                "Virtue"            {[ValidateScript({$_ -match $VirtuePattern})]$Entry = Read-Host "Pick one stat, and one skill that are your virtue (ex. STR\SURV)"}
                "Str"               {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for STR (4d6 drop lowest)"}
                "Dex"               {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for DEX (4d6 drop lowest)"}
                "Mind"              {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for MIND (4d6 drop lowest)"}
                "BankGold"          {[int]$Entry = Read-Host "How much gold do you have in the bank"}
                "GearSlot(\d+)"     {[ValidateLength(0,17)][string]$Entry = Read-Host "What is in gear slot $($Matches[1]), leave blank if none left"}
            }
        }
        catch {}

        if ($LongStrings -match "^$field$" -and $entry -eq $null){break}
        if ($Entry -ne $null){break}
    }
    return $entry
}