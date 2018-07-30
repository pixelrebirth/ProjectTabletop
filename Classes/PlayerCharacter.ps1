class PlayerCharacter {
    $PlayerName
    $Str
    $Dex
    $Mind

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

    $SideArmCM
    $RangedCM
    $MeleeCM
    $SpellCM

    $SideArmCMBase
    $RangedCMBase
    $MeleeCMBase
    $SpellCMBase
    
    $Heroism

    $MD
    $RD
    $SD

    $HP
    $XP

    $Upbringing
    $UpbringingBonus
    $CharacterName
    $TalentName
    $TalentAbility
    [string]$Titles

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

    hidden $strlevel
    hidden $dexlevel
    hidden $mindlevel

    $MeleeFail
    $RangedFail
    $SpellFail

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }

    UpdateStats ($XP) {
        $this.Level = 1
        $this.XP = $XP
        $XPRemain = $this.XP

        while ($XPRemain -gt 0){
            $XPRemain = $XPRemain - $this.Level*10
            $this.Level++
        }

        $this.Heroism = $this.Level
        
        $AllPoints = $this.strlevel + $this.dexlevel + $this.mindlevel
        if ($AllPoints -le ($this.level - 1)){
            $this.str = 3 + $this.strlevel
            $this.dex = 3 + $this.dexlevel
            $this.mind = 3 + $this.mindlevel
        }
        else {
            throw "Error in Stat Points amount, currently at $AllPoints total and should be at $($this.level - 1)"
            exit
        }
        if ($AllPoints -lt ($this.level - 1)){
            Write-Warning "You have [$(($this.level - 1) - $AllPoints)] unspent points on Stats you should use and rerun the code."
        }

        $EquipStats = @(
            "STR:Power",
            "DEX:Speed",
            "MIND:Wisdom",
            "MD:Hardening",
            "RD:Fleeting"
            "SD:Force"
            "Heroism:Bravery",
            "MeleeCMBase:Gutting",
            "RangedCMBase:Precision"
            "SpellCMBase:Elements"
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

        $Bonus = (($this.UpbringingBonus) -split('\+'))[0]
        if ($this.UpbringingBonus -match "$Bonus\+(\d+)"){
            $this."$Bonus" = [int]$this."$Bonus" + [int]$matches[1]
        }

        Foreach ($Stat in $EquipStats){
            $Stat = ($Stat).split(":")
            $StatName = $Stat[0]
            $StatType = $Stat[1]

            Foreach ($Type in $AllEquipmentTypes){
                if ($this."$Type" -match "$($StatType)"){
                    $this."$Type" -match " \+ (\d+)"
                    $PlusAttribute = $matches[1]
                    $CurrentAttribute = $this."$($StatName)"
                    $this."$($StatName)" = $CurrentAttribute + $PlusAttribute
                }
            }
        }

        if ($this.ArmorSet -match "\[(\d+)\]"){$ArmorPR = $matches[1]}
        else {$ArmorPR = 0}

        if ($this.Shield -match "\[(\d+)\]"){$ShieldPR = $matches[1]}
        else {$ShieldPR = 0}

        switch ($this.TalentName){
            "Well Rounded" {
                $Low = 100
                $LowName = ""
                if ($this.str -lt $Low){$Low = $this.str ; $LowName = "str"}
                if ($this.dex -lt $Low){$Low = $this.dex ; $LowName = "dex"}
                if ($this.mind -lt $Low){$Low = $this.mind ; $LowName = "mind"}
                $this."$($LowName)" = $this."$($LowName)" + 1
            }
            "Combat Training" {
                $this.CMBase + ([math]::floor(.2 * $this.level)) + 1
            }
        }
        if ($this.dex -lt 0){$this.dex = 0}
        if ($this.str -lt 0){$this.str = 0}
        if ($this.mind -lt 0){$this.mind = 0}

        $this.HP = $this.level * 6
        $this.MD = $this.MD + $this.str + $ArmorPR + $ShieldPR
        $this.RD = $this.RD + $this.dex + $ArmorPR + $ShieldPR
        $this.SD = $this.SD + $this.mind + $ArmorPR + $ShieldPR

        $this.SideArmCMBase = ($this.str) + $this.SideArmCMBase - 4
        $this.MeleeCMBase = ($this.str) + $this.MeleeCMBase
        $this.RangedCMBase = ($this.dex) + $this.RangedBase
        $this.SpellCMBase = ($this.mind) + $this.SpellCMBase

        if ($this.SideArm -match "^Masterwork|^M\. "){$this.SideArmCMBase = $this.SideArmCMBase + 2}
        if ($this.MainMelee -match "^Masterwork|^M\. "){$this.MeleeCMBase = $this.MeleeCMBase + 2}
        if ($this.MainRanged -match "^Masterwork|^M\. "){$this.RangedCMBase = $this.RangedCMBase + 2}
        if ($this.ArmorSet -match "^Masterwork|^M\. "){$this.MR = $this.MR + 2}
        if ($this.Shield -match "^Masterwork|^M\. "){$this.MR = $this.MR + 2}

        $SideArmDmg = Get-DiceRollPerInteger -Integer $(($this.str) - 4)
        $MeleeDmg = Get-DiceRollPerInteger -Integer $($this.str)
        $RangedDmg = Get-DiceRollPerInteger -Integer $($this.dex)
        $SpellDmg = Get-DiceRollPerInteger -Integer $($this.mind)

        $this.SideArmCM = "$SideArmDmg+$($this.SideArmCMBase)"
        $this.MeleeCM = "$MeleeDmg+$($this.MeleeCMBase)"
        $this.RangedCM = "$RangedDmg+$($this.RangedCMBase)"
        $this.SpellCM = "$SpellDmg+$($this.SpellCMBase)"

        $this.MeleeFail = [math]::floor((25 - $this.Str) + $ArmorPR + $ShieldPR)
        $this.RangedFail = [math]::floor((25 - $this.Dex) + $ArmorPR + $ShieldPR)
        $this.SpellFail = [math]::floor((25 - $this.Mind) + $ArmorPR + $ShieldPR)

        if ($this.MeleeFail -lt 0){$this.MeleeFail = 0}
        if ($this.RangedFail -lt 0){$this.RangedFail = 0}
        if ($this.SpellFail -lt 0){$this.SpellFail = 0}
    }
}