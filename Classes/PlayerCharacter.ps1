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
    $Str
    $Dex
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
    $CharacterName
    $TalentName
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
        $this.Level = 1
        $AllStats = @(
            "STR:Power",
            "DEX:Speed",
            "MIND:Wisdom"
        )
        $AllSkills = @(
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

        Foreach ($Skill in $AllSkills){
            $Skill = ($Skill).split(":")
            $this."$($Skill[0])" = $this.Level

            if ($this.Virtue -match "$($Skill[0])"){
                $this."$($Skill[0])" = $this."$($Skill[0])" + 2
            }
            if ($this.Vise -match "$($Skill[0])"){
                $this."$($Skill[0])" = $this."$($Skill[0])" - 2
            }
            
            Foreach ($Type in $AllEquipmentTypes){
                if ($this."$Type" -match "$($Skill[1])"){
                    $this."$Type" -match " \+ (\d+)"
                    $PlusAttribute = $matches[1]
                    $CurrentAttribute = $this."$($Skill[0])"
                    $this."$($Skill[0])" = $CurrentAttribute + $PlusAttribute
                }
            }
        }

        Foreach ($Stat in $AllStats){
            $Stat = ($Stat).split(":")
            $StatName = $Stat[0]
            $StatType = $Stat[1]

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