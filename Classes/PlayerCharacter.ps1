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
    hidden $Hardening
    $Race
    $RaceBonus
    $CharacterName
    $TalentName
    $TalentAbility
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

    hidden $Level3
    hidden $Level6
    hidden $Level9
    hidden $Level12
    hidden $Level15
    hidden $Level18
    hidden $Level20
    
    [void] IfNullStats ($stat){
        if ($this."$stat`Base" -eq $null -or $this."$stat`Base" -eq ''){
            $this."$stat`Base" = $this."$stat"
        } else {
            $this."$stat" = $this."$stat`Base"
        }
    }

    FirstLevel () {
        . ./LoadClasses.ps1
        
        $this.IfNullStats('STR')
        $this.IfNullStats('DEX')
        $this.IfNullStats('MIND')

        $StatData = @("PlayerName","Str","Dex","Mind","Virtue","Vise")
        foreach ($field in $StatData){
            if ($this."$field" -eq '' -or $this."$field" -eq $null){
                $Entry = Get-ManualDataEntry -field $field -ReplaceMode $False
                $this."$field" = $Entry
            }
        }

        $this.IfNullStats('STR')
        $this.IfNullStats('DEX')
        $this.IfNullStats('MIND')

    }

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }
    
    LevelUp () {
        . ./LoadClasses.ps1
        $this.Level++
        
        if ($this.level / 3 -is [int]){
            $DynamicLevel = $this."Level$($this.level)"
            if ($DynamicLevel -ne '' -or $DynamicLevel -ne $null){
                $this."$DynamicLevel"++
            }
            else {
                $StatBump = $null
                while ($StatBump -eq $null){
                    [ValidateSet("str","dex","mind")]$StatBump = Read-Host "`n!--!--!`nWhat stat would you like to increase (str,dex,mind)"
                }
                $this."$StatBump"++
            }
        }
    }

    UpdateStats () {
        # $this.str = $this.StrBase
        # $this.dex = $this.DexBase
        # $this.mind = $this.MindBase
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
            "AC:Hardening",
            "Heroism:Bravery",
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
                
                Write-Host -ForegroundColor Yellow "`nWarning Dropping $($this.MainMelee) and $($this.SideArm)`n"
                $this.MainMelee = "Magic Fists + $FistBonus [1d8]"
                $this.SideArm = "Magic Fists (Off-hand) + $FistBonus [1d6]"
            }
            "Combat Training" {
                $this.CMBase + ([math]::floor(.2 * $this.level)) + 1
            }
        }
        

        if ($this.dex -lt 10){$this.dex = 10}
        if ($this.str -lt 10){$this.str = 10}
        if ($this.mind -lt 10){$this.mind = 10}

        $this.STRMod = [math]::floor(($this.STR - 10) / 2)
        $this.MINDMod = [math]::floor(($this.MIND - 10) / 2)
        $this.DEXMod = [math]::floor(($this.DEX - 10 ) / 2)

        $this.ac = $this.dexmod + $ArmorAC + $ShieldAC + 10 + $BaseAc
        
        $this.hp = ([math]::floor(($this.str + $this.dex + $this.mind) / 3)) + ($this.roll("$($this.level * 3)d4"))
        
        $SideArmCMBase = $this.strmod + $this.CMBase
        $MeleeCMBase = $this.strmod + $this.CMBase
        $RangedCMBase = $this.DexMod + $this.CMBase

        if ($this.SideArm -match "^Masterful|^M "){$SideArmCMBase = $SideArmCMBase + 2}
        if ($this.MainMelee -match "^Masterful|^M "){$MeleeCMBase = $MeleeCMBase + 2}
        if ($this.MainRanged -match "^Masterful|^M "){$RangedCMBase = $RangedCMBase + 2}
        
        $this.SideArmCM = If ($this.SideArm -match "\[(.*)\]"){"$($Matches[1]) + $MeleeCMBase" }
        $this.MeleeCM = If ($this.MainMelee -match "\[(.*)\]"){"$($Matches[1]) + $MeleeCMBase" }
        $this.RangedCM = If ($this.MainRanged -match "\[(.*)\]"){"$($Matches[1]) + $RangedCMBase" }
  
        $this.SpellDC = $this.level + $this.MindMod + 10
        $this.Fortitude = $this.StrMod + $this.Phys + 10
        $this.Reflex = $this.DexMod + $this.Sub + 10
        $this.Will = $this.MindMod + $this.Know + 10
    }
}