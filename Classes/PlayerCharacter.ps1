class PlayerCharacter {
    $PlayerName
    $Str
    $Dex
    $Mind
    $StrMod
    $DexMod
    $MindMod
    $StrBase
    $DexBase
    $MindBase
    $Virtue
    $Vise
    $Amulet
    $Ring
    $Helm
    $Shield
    $ArmorSet
    $SideArm
    $MainRanged
    $MainMelee
    $GearSlot18
    $GearSlot17
    $GearSlot16
    $GearSlot15
    $GearSlot14
    $GearSlot13
    $GearSlot12
    $GearSlot11
    $GearSlot10
    $GearSlot9
    $GearSlot8
    $GearSlot7
    $GearSlot6
    $GearSlot5
    $GearSlot4
    $GearSlot3
    $GearSlot2
    $GearSlot1
    $BankGold
    
    $Level
    $Phys
    $Sub
    $Know
    $Comm
    $Surv
    $CMBase
    $SideArmCM
    $RangedCM
    $MeleeCM
    $Heroism
    $Fortitude
    $Reflex
    $Will
    $SpellDC
    $AC
    $HP
    $XP
    
    $Race
    $RaceBonus
    $CharacterName
    $TalentName
    $TalentBonus
    $Idol
    $Foe
    $Lover
    $Family
    $WhereFrom
    $BestFriend
    $LastWar
    $Organization
    $MostLikelyDo
    $Hobby
    $Food
    $DiscoverMagic
    $WhatSeek
    
    FirstLevel () {
        $StatData = @("PlayerName","Str","Dex","Mind","Virtue","Vise")
        foreach ($field in $StatData){
            $Entry = Get-ManualDataEntry -field $field -ReplaceMode $False
            # if ($field -match "GearSlot" -and $Entry -eq $null){break}
            $this."$field" = $Entry
        }

        $this.StrBase = $this.Str
        $this.DexBase = $this.Dex
        $this.MindBase = $this.Mind
    }

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }
    
    LevelUp () {
        $this.Level++
        $DataEntryFields = @("BankGold","Amulet","Ring","Helm",
            "Shield","ArmorSet","SideArm","MainRanged","MainMelee","GearSlot1",
            "GearSlot2","GearSlot3","GearSlot4","GearSlot5","GearSlot6","GearSlot7","GearSlot8",
            "GearSlot9","GearSlot10","GearSlot11","GearSlot12","GearSlot13","GearSlot14",
            "GearSlot15","GearSlot16","GearSlot17","GearSlot18"
        )
        
        foreach ($field in $DataEntryFields){
            if ($this.level -eq 1){$ReplaceMode = $False} else {$ReplaceMode = $True}
            $Entry = Get-ManualDataEntry -field $field -ReplaceMode $ReplaceMode
            if ($field -match "GearSlot" -and $Entry -eq $null){break}
            if ($Entry -ne ""){
                $this."$field" = $Entry
            }
        }
    }

    UpdateStats () {
        $this.str = $this.StrBase
        $this.dex = $this.DexBase
        $this.mind = $this.MindBase
        $this.CMBase = $this.Level
        $this.Phys = $this.Level
        $this.Sub = $this.Level
        $this.Know = $this.Level
        $this.Comm = $this.Level
        $this.Surv = $this.Level
        $this.Heroism = $this.Level

        $BaseAC = 0

        $EquipStats = @(
            "STR:Power",
            "DEX:Speed",
            "MIND:Wisdom",
            "Phys:Endurance",
            "Sub:Shadow",
            "Know:Brilliance",
            "Comm:Tongues",
            "Surv:Hunting",
            "Hardening:AC"
            "CMBase:Gutting"
        )
       
        $AllEquipmentTypes = @(
            "Amulet",
            "Ring",
            "Helm",
            "Shield",
            "ArmorSet",
            "SideArm",
            "MainRanged",
            "MainMelee",
            "GearSlot1","GearSlot2","GearSlot3","GearSlot4","GearSlot5","GearSlot6","GearSlot7",
            "GearSlot8","GearSlot9","GearSlot10","GearSlot11","GearSlot12","GearSlot13",
            "GearSlot14","GearSlot15","GearSlot16","GearSlot17","GearSlot18"
        )
        if ($this.level / 3 -is [int]){

        }
        
        $Bonus = (($this.RaceBonus) -split('\+'))[0]
        if ($this.RaceBonus -match "$Bonus\+(\d+)"){
            $this."$Bonus" = [int]$this."$Bonus" + [int]$matches[1]
        }

        Foreach ($Stat in $EquipStats){
            $Stat = ($Stat).split(":")
            $StatName = $Stat[0]
            $StatType = $Stat[1]
            
            if ($this.Virtue -match "$($StatName)"){
                $this."$($StatName)" = $this."$($StatName)" + 2
            }
            if ($this.Vise -match "$($StatName)"){
                $this."$($StatName)" = $this."$($StatName)" - 2
            }
        }
        
        if ($this.ArmorSet -match "\[(\d+)\]"){$ArmorAC = $matches[1]}
        else {$ArmorAC = 0}
        
        if ($this.Shield -match "\[(\d+)\]"){$ShieldAC = $matches[1]}
        else {$ShieldAC = 0}

        $this.Dex = [int]$this.Dex - (([int]$ArmorAC + [int]$ShieldAC)/2)

        switch ($this.TalentName){
            "Talented"{
                $Low = 100
                $LowName = ""
                if ($this.phys -lt $Low){$Low = $this.phys ; $LowName = "mind"}
                if ($this.sub -lt $Low){$Low = $this.sub ; $LowName = "sub"}
                if ($this.know -lt $Low){$Low = $this.know ; $LowName = "know"}
                if ($this.comm -lt $Low){$Low = $this.comm ; $LowName = "comm"}
                if ($this.surv -lt $Low){$Low = $this.surv ; $LowName = "surv"}
                $this."$($LowName)" = $this."$($LowName)" + 2
            }
            "Well Rounded" {
                $Low = 100
                $LowName = ""
                if ($this.str -lt $Low){$Low = $this.str ; $LowName = "str"}
                if ($this.dex -lt $Low){$Low = $this.dex ; $LowName = "dex"}
                if ($this.mind -lt $Low){$Low = $this.mind ; $LowName = "mind"}
                $this."$($LowName)" = $this."$($LowName)" + 2
            }
            "Martial Arts" {
                $BaseAC = ([math]::floor(.5 * $this.level)) + 1
                $FistBonus = ([math]::floor(.5 * $this.level)) + 1
                
                Write-Host -ForegroundColor Yellow "Warning Dropping $($this.MainMelee) and $($this.SideArm)"
                $this.MainMelee = "Magic Fists + $FistBonus [1d8]"
                $this.SideArm = "Magic Fists (Off-hand) + $FistBonus [1d6]"
            }
        }


        if ($this.dex -lt 10){$this.dex = 10}
        if ($this.str -lt 10){$this.str = 10}
        if ($this.mind -lt 10){$this.mind = 10}

        $this.STRMod = [math]::floor(($this.STR - 10) / 2)
        $this.MINDMod = [math]::floor(($this.MIND - 10) / 2)
        $this.DEXMod = [math]::floor(($this.DEX - 10 ) / 2)

        $this.ac = $this.dexmod + $ArmorAC + $ShieldAC + 10 + $BaseAc
        
        $this.hp = $this.str + ($this.roll("$($this.level * 3)d4"))
        $this.hp = $this.hp - ([int]$ArmorAC + [int]$ShieldAC)
        
        $SideArmCMBase = $this.strmod + $this.CMBase
        $MeleeCMBase = $this.strmod + $this.CMBase
        $RangedCMBase = $this.DexMod + $this.CMBase

        if ($this.SideArm -match "Masterful"){$SideArmCMBase = $SideArmCMBase + 2}
        if ($this.MainMelee -match "Masterful"){$MeleeCMBase = $MeleeCMBase + 2}
        if ($this.MainRanged -match "Masterful"){$RangedCMBase = $RangedCMBase + 2}
        
        $this.SideArmCM = If ($this.SideArm -match "\[(.*)\]"){"$($Matches[1]) + $MeleeCMBase" }
        $this.MeleeCM = If ($this.MainMelee -match "\[(.*)\]"){"$($Matches[1]) + $MeleeCMBase" }
        $this.RangedCM = If ($this.MainRanged -match "\[(.*)\]"){"$($Matches[1]) + $RangedCMBase" }
  
        $this.SpellDC = $this.level + $this.MindMod + 10
        $this.Fortitude = $this.StrMod + $this.Phys + 10
        $this.Reflex = $this.DexMod + $this.Sub + 10
        $this.Will = $this.MindMod + $this.Know + 10
    }
}