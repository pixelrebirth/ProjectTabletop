class PlayerCharacter {
    $PlayerName
    [int]$Str
    [int]$Dex
    [int]$Mind

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

    $Masterwork = $false
    $Enchanted = $false
    $EquipmentTrack = @()

    $Level

    $MeleeCM
    $SideArmCM
    $RangedCM
    $SpellCM

    [int]$MeleeCMBase
    [int]$SideArmCMBase
    [int]$RangedCMBase
    [int]$SpellCMBase
    
    $Speed

    [int]$MD
    [int]$RD
    [int]$SD

    [int]$HP
    [int]$XP

    $Specialization
    $SpecializationBonus
    $CharacterName
    $TalentName
    $TalentAbility
    [string]$Titles

    $Background

    hidden $strlevel
    hidden $dexlevel
    hidden $mindlevel

    [int]$MeleeFail
    [int]$RangedFail
    [int]$SpellFail

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

        $this.Speed = 6
        
        $AllPoints = $this.strlevel + $this.dexlevel + $this.mindlevel
        if ($AllPoints -le ($this.level)){
            $this.str = 3 + $this.strlevel
            $this.dex = 3 + $this.dexlevel
            $this.mind = 3 + $this.mindlevel
        }
        else {
            throw "Error in Stat Points amount, currently at $AllPoints total and should be at $($this.level)"
            exit
        }
        if ($AllPoints -lt ($this.level)){
            Write-Warning "You have [$(($this.level) - $AllPoints)] unspent points on Stats you should use and rerun the code."
        }

        $EquipStats = @(
            "MeleeFail:Finesse",
            "RangedFail:Accuracy",
            "SpellFail:Wisdom",
            "MD:Hardening",
            "RD:Fleeting"
            "SD:Force"
            "MeleeCMBase:Power",
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
            "MainMelee"
        )

        Foreach ($Type in $AllEquipmentTypes){
            Foreach ($Stat in $EquipStats){
                $matches = $null
                $Stat = ($Stat).split(":")
                $StatName = $Stat[0]
                $StatType = $Stat[1]
                
                if ($this."$Type" -match "of $($StatType)"){
                    $this."$Type" -match " \+ (?<Attrib>\d+)" | Out-Null
                    $PlusAttribute = $matches['Attrib']
                    if ($this."$($StatName)" -lt $PlusAttribute){
                        $this."$($StatName)" = $PlusAttribute
                    }
                }
            }
        }

        $Bonus = (($this.SpecializationBonus) -split('\+|\-'))[0]
        if ($this.SpecializationBonus -match "$Bonus\+(?<Spec>\d+)|$Bonus\-(?<Spec>\d+)"){
            $this."$Bonus" = [int]$this."$Bonus" + [int]$matches['Spec']
        }

        if ($this.ArmorSet -match "\[?<APR>(\d+)\]"){$ArmorPR = $matches['APR']}
        else {$ArmorPR = 0}
        
        if ($this.Shield -match "\[(?<SPR>\d+)\]"){$ShieldPR = $matches['SPR']}
        else {$ShieldPR = 0}
        
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

        If (!$this.Masterwork){
            if ($this.SideArm,$this.MainMelee -match "^Masterwork|^M\. "){
                $this.Str = $this.Str + 2; $this.MasterWork = $true
            }
            if ($this.MainRanged -match "^Masterwork|^M\. "){
                $this.Dex = $this.Dex + 2; $this.Enchanted = $true
            }
        }

        If (!$this.Enchanting){
            if ($this.SideArm,$this.MainMelee,$this.MainRanged -match "^Enchanted|^E\. "){
                $this.Mind = $this.Mind + 2; $this.Enchanted = $true
            }
        }

        $SideArmDmg = Get-DiceRollPerInteger -Integer $(($this.str) - 4)
        $MeleeDmg = Get-DiceRollPerInteger -Integer $($this.str)
        $RangedDmg = Get-DiceRollPerInteger -Integer $($this.dex)
        $SpellDmg = Get-DiceRollPerInteger -Integer $($this.mind)

        $this.SideArmCM = "$SideArmDmg+$($this.SideArmCMBase)"
        $this.MeleeCM = "$MeleeDmg+$($this.MeleeCMBase)"
        $this.RangedCM = "$RangedDmg+$($this.RangedCMBase)"
        $this.SpellCM = "$SpellDmg+$($this.SpellCMBase)"

        $this.MeleeFail =  (-$this.MeleeFail) + [math]::floor((25 - $this.Str) + (($ArmorPR +  $ShieldPR) * 2))
        $this.RangedFail = (-$this.RangedFail) + [math]::floor((25 - $this.Dex) + (($ArmorPR + $ShieldPR) * 2))
        $this.SpellFail = (-$this.SpellFail) + [math]::floor((25 - $this.Mind) + (($ArmorPR + $ShieldPR) * 2))

        if ($this.MeleeFail -lt 0){$this.MeleeFail = 0}
        if ($this.RangedFail -lt 0){$this.RangedFail = 0}
        if ($this.SpellFail -lt 0){$this.SpellFail = 0}
    }
}