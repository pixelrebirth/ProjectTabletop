class EberronCharacter {
    [ValidateRange(1,20)]$Level
    hidden [EberronClass]$ClassInternal
    hidden [EberronRace]$RaceInternal
    
    $Race
    $Class

    [int]$STR
    [int]$DEX
    [int]$MIND
    [int]$StrMod
    [int]$DexMod
    [int]$MindMod
    
    [int]$AC
    [int]$HP

    [int]$MeleeCM
    [int]$RangedCM

    [int]$SpellDC

    [int]$Phys
    [int]$Sub
    [int]$Know
    [int]$Comm
    [int]$Surv

    $Traits
    $Description

    EberronCharacter ([int]$Level) {
        $this.Level = $Level
        $this.GetClass()
        $this.GetRace()
        $this.GetLevel()
    }

    [void] GetRace () {$this.RaceInternal = [EberronRace]::new()}
    [void] GetClass () {$this.ClassInternal = [EberronClass]::new()}
    
    [void] GetLevel () {
        $this.Race = $this.RaceInternal.RaceName
        $this.Class = $this.ClassInternal.ClassName

        $this.STR = $this.roll('3d6') + 3
        $this.DEX = $this.roll('3d6') + 3
        $this.MIND = $this.roll('3d6') + 3

        $this.CalculateLevel()
    }

    [void] CalculateLevel () {
        $this.Phys = $this.Level
        $this.Sub = $this.Level
        $this.Know = $this.Level
        $this.Comm = $this.Level
        $this.Surv = $this.Level
        
        $this.Description = $this.RaceInternal.RacialHistory + " and " + $this.ClassInternal.ClassHistory
        $this.Traits = $this.RaceInternal.DefiningTrait + " and " + $this.ClassInternal.DefiningTrait
        
        $MeleeCMBonus = 0
        $RangedCMBonus = 0
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
        $this.HP = $this.STR + $($this.roll("$(3 * $this.Level)d4"))
        $this.SpellDC = $this.Level + $this.MindMod + 10

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

class EberronClass {
    [String]$ClassName
    [ValidatePattern('^\w+;\d+$')]$Bonuses
    [String]$DefiningTrait
    [String]$ClassHistory
    [String]$MaxArmor
    
    EberronClass ($ClassName) {
        $GetClasses = Get-Content $PSScriptRoot\..\Data\EberronClasses.txt
        foreach ($eachClass in $GetClasses){
            if ($eachClass -match "^$ClassName,"){
                $GetParse = $eachClass.Split(',')
                $this.ClassName = $GetParse[0]
                $this.Bonuses = $GetParse[1]
                $this.MaxArmor = $GetParse[2]
                $this.DefiningTrait = $GetParse[3]
                $this.ClassHistory = $GetParse[4]
            }
        }
    }

    EberronClass () {
        $GetClasses = Get-Content $PSScriptRoot\..\Data\EberronClasses.txt
        $Random = Get-Random -Min 0 -Max ($GetClasses.count)
        $eachClass = $GetClasses[$Random]

        $GetParse = $eachClass.Split(',')
        $this.ClassName = $GetParse[0]
        $this.Bonuses = $GetParse[1]
        $this.MaxArmor = $GetParse[2]
        $this.DefiningTrait = $GetParse[3]
        $this.ClassHistory = $GetParse[4]
    }
}

class EberronRace {
    [String]$RaceName
    [ValidatePattern('^\w+;\d+$')]$Bonuses
    [String]$DefiningTrait
    [String]$RacialHistory

    EberronRace ($RaceName) {
        $GetRaces = Get-Content $PSScriptRoot\..\Data\EberronRaces.txt
        foreach ($eachRace in $GetRaces){
            if ($eachRace -match "^$RaceName,"){
                $GetParse = $eachRace.Split(',')
                $this.RaceName = $GetParse[0]
                $this.Bonuses = $GetParse[1]
                $this.DefiningTrait = $GetParse[2]
                $this.RacialHistory = $GetParse[3]
            }
        }
    }

    EberronRace () {
        $GetRaces = Get-Content $PSScriptRoot\..\Data\EberronRaces.txt
        $Random = Get-Random -Min 0 -Max ($GetRaces.count)
        $eachRace = $GetRaces[$Random]
        
        $GetParse = $eachRace.Split(',')
        $this.RaceName = $GetParse[0]
        $this.Bonuses = $GetParse[1]
        $this.DefiningTrait = $GetParse[2]
        $this.RacialHistory = $GetParse[3]
    }
}

# 1..1000| % {[EberronCharacter]::new(18)} | Measure-Object -Minimum -Maximum -Average -Property HP
[EberronCharacter]::new(3)