function Get-ManualDataEntry {
    param($field)
    $LongStrings = @("Amulet","Ring","Helm","ArmorSet","SideArm","MainRanged","MainMelee")
    $Entry = $null
    $WeaponPattern = '^[A-Za-z ]+\[\d+d\d+\]|^[\w+ ]+ \+ \d+ \[\d+d\d+\]|None'
    $ArmorPattern = '^[A-Za-z ]+\[\d+\]|^[\w+ ]+ \+ \d+ \[\d+\]|None'
    $AccessoryPattern = '^[A-Za-z ]+|^[\w+ ]+ \+ \d+|None'
    $VirtuePattern = '^\w+\\\w+$|^\w+\/\w+$'
    while ($true){
        # FIXME Bastard Sword of Tongues + 3 [1d10] FAILED
        # TODO Deal with how to fix long gear slot names
        try {
            switch -regex ($field){
                "PlayerName"        {[ValidateLength(3,15)][string]$Entry = Read-Host "What is your own name"}
                "Amulet"            {[ValidateLength(3,30)][ValidateScript({$_ -match $AccessoryPattern})][string]$Entry = Read-Host "Do you have an amulet (ex. Amulet of Hunting + 2)"}
                "Ring"              {[ValidateLength(3,30)][ValidateScript({$_ -match $AccessoryPattern})][string]$Entry = Read-Host "Do you have a ring (ex. Ring of Shadow + 1)"}
                "Helm"              {[ValidateLength(3,30)][ValidateScript({$_ -match $AccessoryPattern})][string]$Entry = Read-Host "Do you have a helm (ex. Winged Helm of Brilliance + 3)"}
                "Shield"            {[ValidateLength(3,30)][ValidateScript({$_ -match $ArmorPattern})][string]$Entry = Read-Host "Do you have armor (ex. Bucklet of Power + 1 [2])"}
                "ArmorSet"          {[ValidateLength(3,30)][ValidateScript({$_ -match $ArmorPattern})][string]$Entry = Read-Host "Do you have armor (ex. ScaleMail of Endurance + 1 [4])"}
                "SideArm"           {[ValidateLength(3,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a side arm (ex. Dagger of Wisdom + 1 [1d6])"}
                "MainRanged"        {[ValidateLength(3,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a melee weapon (ex. Masterful Bastard Sword of Power + 4 [1d6]"}
                "MainMelee"         {[ValidateLength(3,30)][ValidateScript({$_ -match $WeaponPattern})][string]$Entry = Read-Host "Do you have a ranged weapon (ex. Longbow of Speed + 3 [1d8]"}
                "Vise"              {[ValidateScript({$_ -match $VirtuePattern})]$Entry = (Read-Host "Pick one stat, and one skill that are your vise (ex. MIND\KNOW)").toUpper()}
                "Virtue"            {[ValidateScript({$_ -match $VirtuePattern})]$Entry = (Read-Host "Pick one stat, and one skill that are your virtue (ex. STR\SURV)").toUpper()}
                "Str"               {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for STR (4d6 drop lowest)"}
                "Dex"               {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for DEX (4d6 drop lowest)"}
                "Mind"              {[ValidateRange(3,18)][int]$Entry = Read-Host "What did you roll for MIND (4d6 drop lowest)"}
                "BankGold"          {[int]$Entry = Read-Host "How much gold do you have in the bank"}
                "GearSlot(\d+)"     {[ValidateLength(0,30)][string]$Entry = Read-Host "What is in gear slot $($Matches[1]), leave blank if none left"}
            }
        }
        catch {}
        if ($Entry -ne $null -or $entry -eq "None"){break}
    }
    return $entry
}