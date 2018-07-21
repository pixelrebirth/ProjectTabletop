class PlayerCharacter {
    $PlayerName
    $Str
    $Dex
    $Mind
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
    $MD
    $RD
    $SD
    $SpellCM
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
    hidden $physlevel
    hidden $sublevel
    hidden $knowlevel
    hidden $commlevel
    hidden $survlevel

    $MeleeFail
    $RangedFail
    $SpellFail

    hidden $Points0
    hidden $Points1
    hidden $Points2
    hidden $Points3
    hidden $Points4
    hidden $Points5
    hidden $Points6
    hidden $Points7
    hidden $Points8
    hidden $Points9

    FirstLevel () {
        . ./LoadClasses.ps1

        $StatData = @("Virtue","Vise")
        foreach ($field in $StatData){
            if (!$this."$field"){
                $Entry = Get-ManualDataEntry -field $field -Replace $False
                $this."$field" = $Entry
            }
        }
    }

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }

    LevelUp () {
        $this.Level++
    }

    UpdateStats () {
        $this.CMBase = 0
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
        
        $AllPoints = $this.physlevel + $this.sublevel + $this.knowlevel + $this.commlevel + $this.survlevel
        if ($AllPoints -le ($this.level - 1)){
            $this.Phys = 3 + $this.physlevel
            $this.Sub = 3 + $this.sublevel
            $this.Know = 3 + $this.knowlevel
            $this.Comm = 3 + $this.commlevel
            $this.Surv = 3 + $this.survlevel
        }
        else {
            throw "Error in Skill Points amount, currently at $AllPoints total and should be at $($this.level - 1)"
            exit
        }
        if ($AllPoints -lt ($this.level - 1)){
            Write-Warning "You have [$(($this.level - 1) - $AllPoints)] unspent points on Skills you should use and rerun the code."
        }

        $EquipStats = @(
            "STR:Power",
            "DEX:Speed",
            "MIND:Wisdom",
            "Phys:Endurance",
            "Sub:Shadow",
            "Know:Brilliance",
            "Comm:Tongues",
            "Surv:Hunting",
            "PR:Hardening",
            "Heroism:Bravery",
            "CMBase:Gutting",
            "SpellCM:Elements"
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

        if ($this.ArmorSet -match "\[(\d+)\]"){$ArmorPR = $matches[1]}
        else {$ArmorPR = 0}

        if ($this.Shield -match "\[(\d+)\]"){$ShieldPR = $matches[1]}
        else {$ShieldPR = 0}

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
            "Combat Training" {
                $this.CMBase + ([math]::floor(.2 * $this.level)) + 1
            }
        }

        if ($this.dex -lt 0){$this.dex = 0}
        if ($this.str -lt 0){$this.str = 0}
        if ($this.mind -lt 0){$this.mind = 0}

        $this.HP = $this.level * 6
        $this.MD = $this.str + $ArmorPR + $ShieldPR
        $this.RD = $this.dex + $ArmorPR + $ShieldPR
        $this.SD = $this.mind + $ArmorPR + $ShieldPR

        $SideArmCMBase = ($this.str) + $this.CMBase - 4
        $MeleeCMBase = ($this.str) + $this.CMBase
        $RangedCMBase = ($this.dex) + $this.CMBase
        $SpellCMBase = ($this.mind) + $this.CMBase

        if ($this.SideArm -match "^Masterwork|^M\. "){$SideArmCMBase = $SideArmCMBase + 2}
        if ($this.MainMelee -match "^Masterwork|^M\. "){$MeleeCMBase = $MeleeCMBase + 2}
        if ($this.MainRanged -match "^Masterwork|^M\. "){$RangedCMBase = $RangedCMBase + 2}
        if ($this.ArmorSet -match "^Masterwork|^M\. "){$this.MR = $this.MR + 2}
        if ($this.Shield -match "^Masterwork|^M\. "){$this.MR = $this.MR + 2}

        $SideArmDmg = Get-DiceRollPerInteger -Integer $(($this.str) - 4)
        $MeleeDmg = Get-DiceRollPerInteger -Integer $($this.str)
        $RangedDmg = Get-DiceRollPerInteger -Integer $($this.dex)
        $SpellDmg = Get-DiceRollPerInteger -Integer $($this.mind)

        $this.SideArmCM = "$SideArmDmg+$SideArmCMBase"
        $this.MeleeCM = "$MeleeDmg+$MeleeCMBase"
        $this.RangedCM = "$RangedDmg+$RangedCMBase"
        $this.SpellCM = "$SpellDmg+$SpellCMBase"

        $this.MeleeFail = [math]::floor((25 - $this.Str) + $ArmorPR + $ShieldPR)
        $this.RangedFail = [math]::floor((25 - $this.Dex) + $ArmorPR + $ShieldPR)
        $this.SpellFail = [math]::floor((25 - $this.Mind) + $ArmorPR + $ShieldPR)

        $SpellLevel = [math]::floor($this.level / 2)
        0..9 | foreach {
            $num = $_
            if ($SpellLevel -ge $num){
                $this."Points$num" = ((($num * 2) + 1) * 2) + 2
            }
            else {
                $this."Points$num" = "-"
            }
        }
        if ($this.MeleeFail -lt 0){$this.MeleeFail = 0}
        if ($this.RangedFail -lt 0){$this.RangedFail = 0}
        if ($this.SpellFail -lt 0){$this.SpellFail = 0}
    }
}