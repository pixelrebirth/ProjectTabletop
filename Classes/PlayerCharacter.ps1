class PlayerCharacter {
    $PlayerName
    $Amulet
    $Ring
    $Helm
    $Shield
    $ArmorSet
    $SideArm
    $MainRanged
    $MainMelee
    $Virtue
    $Vise
    $Mind
    $MindMod
    $Str
    $StrMod
    $Dex
    $DexMod
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

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }

    FirstLevel () {
        $this.Level = 1
        $this.CMBase = 0

        $EquipStats = @(
            "STR:Power",
            "DEX:Speed",
            "MIND:Wisdom",
            "Phys:Endurance",
            "Sub:Shadow",
            "Know:Brilliance",
            "Comm:Tongues",
            "Surv:Hunting"
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
        
        Foreach ($Stat in $EquipStats){
            $Stat = ($Stat).split(":")
            $StatName = $Stat[0]
            $StatType = $Stat[1]
            
            if ($this."$($StatName)" -eq $null){$this."$($StatName)" = $this.level}
            
            if ($this.Virtue -match "$($StatName)"){
                $this."$($StatName)" = $this."$($StatName)" + 2
            }
            if ($this.Vise -match "$($StatName)"){
                $this."$($StatName)" = $this."$($StatName)" - 2
            }
            
            Foreach ($Type in $AllEquipmentTypes){
                if ($this."$Type" -match "$($StatType)"){
                    $this."$Type" -match " \+ (\d+)"
                    $PlusAttribute = $matches[1]
                    $CurrentAttribute = $this."$($StatName)"
                    $this."$($StatName)" = $CurrentAttribute + $PlusAttribute
                }
            }
        }
        
        
        if ($this.ArmorSet -match "\[(\d+)\]"){$ArmorAC = $matches[1]}
        else {$ArmorAC = 0}
        
        if ($this.Shield -match "\[(\d+)\]"){$ShieldAC = $matches[1]}
        else {$ShieldAC = 0}

        $this.Dex = [int]$this.Dex - (([int]$ArmorAC + [int]$ShieldAC)/2)
        
        if ($this.dex -lt 10){$this.dex = 10}
        if ($this.str -lt 10){$this.str = 10}
        if ($this.mind -lt 10){$this.mind = 10}

        $this.STRMod = [math]::floor(($this.STR - 10) / 2)
        $this.MINDMod = [math]::floor(($this.MIND - 10) / 2)
        $this.DEXMod = [math]::floor(($this.DEX - 10 )/ 2)
        
        $this.ac = $this.dexmod + $ArmorAC + $ShieldAC + 10
        
        $this.hp = $this.str + $this.roll("3d4")
        $this.hp = $this.hp - ([int]$ArmorAC + [int]$ShieldAC)


        # TODO Create calculations of stats
        # Calculate
        # -----
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
}