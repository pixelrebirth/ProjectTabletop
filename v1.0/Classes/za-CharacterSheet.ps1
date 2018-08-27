class CharacterSheet {
    [ValidateRange(1,20)]$Level
    hidden [CharacterClass]$ClassInternal
    hidden [CharacterRace]$RaceInternal
    
    [int]$STR
    [int]$DEX
    [int]$MIND
    
    hidden [int]$MeleeCM
    hidden [int]$RangedCM
    
    hidden $MeleeType
    hidden $MeleeDamage
    
    hidden $RangedType
    hidden $RangedDamage
    
    hidden $ArmorAC
    
    [string]$Race
    [string]$Class
    [int]$AC
    [int]$HP
    [int]$SpellCM
    [int]$SpellResist
    [String]$Attack
    
    [int]$StrMod
    [int]$DexMod
    [int]$MindMod
    
    $ArmorType
    
    [int]$Phys
    [int]$Sub
    [int]$Know
    [int]$Comm
    [int]$Surv
    
    [String]$Traits
    [String]$Description
    hidden [decimal]$HPCalibration

    CharacterSheet ([int]$Level,[decimal]$HPCalibration) {
        $this.HPCalibration = $HPCalibration
        $this.Level = $Level
        $this.GetClass()
        $this.GetRace()

        $this.GetLevel()
        $this.CalculateLevel()
        
        $this.GetWeapon()
        $this.CalculateEquipment()
    }

    [void] GetRace () {$this.RaceInternal = [CharacterRace]::new()}
    [void] GetClass () {$this.ClassInternal = [CharacterClass]::new()}
    
    [void] GetLevel () {
        $this.Race = $this.RaceInternal.RaceName
        $this.Class = $this.ClassInternal.ClassName

        $this.STR = $this.roll('3d6') + (Get-Random -Min 1 -max 6)
        $this.DEX = $this.roll('3d6') + (Get-Random -Min 1 -max 6)
        $this.MIND = $this.roll('3d6') + (Get-Random -Min 1 -max 6)
    }

    [void] GetWeapon () {
        $Equipment = ((Get-Content $PSScriptRoot\..\Data\WeaponsArmorShields.txt) -join("*")) -split('-----')

        $Melee = $Equipment[0].split("*") | where {$_ -notmatch "^$"}
        $Ranged = $Equipment[1].split("*") | where {$_ -notmatch "^$"}
        $Armor = $Equipment[2].split("*") | where {$_ -notmatch "^$"}
        $RandomMelee = Get-Random -Minimum 0 -Maximum $Melee.count
        $RandomRanged = Get-Random -Minimum 0 -Maximum $Ranged.count
        $RandomArmor = Get-Random -Minimum 0 -Maximum $Armor.count

        $this.ArmorType = $Armor[$RandomArmor].split(";")[0]
        $this.ArmorAC = $Armor[$RandomArmor].split(";")[1]

        $this.RangedType = $Ranged[$RandomRanged].split(";")[0]
        $this.RangedDamage = $Ranged[$RandomRanged].split(";")[1]

        $this.MeleeType = $Melee[$RandomMelee].split(";")[0]
        $this.MeleeDamage = $Melee[$RandomMelee].split(";")[1]

    }

    [void] CalculateEquipment () {
        $this.AC = $this.AC + $this.ArmorAC
        $this.Attack = "$($this.MeleeType) ($($this.MeleeDamage)+$($this.MeleeCM)) or $($this.RangedType) ($($this.RangedDamage)+$($this.RangedCM))"
    }

    [void] CalculateLevel () {
        $this.Phys = $this.Level
        $this.Sub = $this.Level
        $this.Know = $this.Level
        $this.Comm = $this.Level
        $this.Surv = $this.Level
        
        $this.Description = $this.RaceInternal.RacialHistory + " and " + $this.ClassInternal.ClassHistory
        $this.Traits = $this.RaceInternal.DefiningTrait + " and " + $this.ClassInternal.DefiningTrait

        $RaceBonus = $this.RaceInternal.Bonuses.split(';')
        
        switch ($RaceBonus[0]){
            "STR" {$this.STR += $RaceBonus[1]}
            "DEX" {$this.DEX += $RaceBonus[1]}
            "MIND" {$this.MIND += $RaceBonus[1]}
            "CM" {$this.MeleeCM = $RaceBonus[1]; $this.RangedCM = $RaceBonus[1]}
            "AC" {$this.AC = $RaceBonus[1]}
            "NA" {}
            "SKILLS" {
                $this.Phys += $RaceBonus[1]
                $this.Sub += $RaceBonus[1]
                $this.Know += $RaceBonus[1]
                $this.Comm += $RaceBonus[1]
                $this.Surv += $RaceBonus[1]
            }
        }

        $ClassBonus = $this.ClassInternal.Bonuses.split(';')
        switch ($ClassBonus[0]) {
            "Phys" {$this.Phys = ($this.Phys + $ClassBonus[1])}
            "Sub" {$this.Sub = ($this.Sub + $ClassBonus[1])}
            "Know" {$this.Know = ($this.Know + $ClassBonus[1])}
            "Comm" {$this.Comm = ($this.Comm + $ClassBonus[1])}
            "Surv" {$this.Surv = ($this.Surv + $ClassBonus[1])}
        }
        
        $this.StrMod = [math]::floor(($this.STR-10)/2)
        $this.DexMod = [math]::floor(($this.DEX-10)/2)
        $this.MindMod = [math]::floor(($this.MIND-10)/2)
        
        $this.MeleeCM = $this.Level + $this.MeleeCM + $this.StrMod
        $this.RangedCM = $this.Level + $this.RangedCM + $this.DexMod
        
        $this.AC = 10 + $this.DexMod + $this.AC
        $this.hp = ((($this.str + $this.dex + $this.mind) / 3) + ($this.roll("$($this.level * 3)d4"))) * $this.HPCalibration
        $this.SpellCM = $this.Level + $this.MindMod

        $this.SpellResist = $this.StrMod + $this.DexMod + $this.MindMod + 10

        foreach ($iteration in 1..([math]::floor($this.level / 3))) {
            $Random = Get-Random -Minimum 1 -Maximum 3
            $Stat = @("STR","DEX","MIND")[$Random-1]
            $this."$Stat"++
        }
    }
    
    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }
}