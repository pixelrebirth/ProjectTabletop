class Character {
    hidden [int] $BaseDefense = 10
    hidden [int] $RndModifier = 2
    hidden [int] $PointsPerDifficulty = 5
    hidden [int] $BasePoints = 10

    [int] $Movement = 3
    [int] $Health = $this.RndModifier*(20-$this.BaseDefense)
    [int] $Defense = $this.BaseDefense
    [int] $Will
}

class Npc : Character {
    hidden $EquipmentModifier
    hidden [int] $Points
    [int] $Difficulty
    
    $Melee
    $Ranged
    $Magic
    
    [int] $Equipment
    
    Npc ($Difficulty) {
        $this.Difficulty = $Difficulty
        $this.EquipmentModifier = $this.Difficulty
        $this.Points = ($this.Difficulty*$this.PointsPerDifficulty)+$this.BasePoints
        
        [System.Collections.ArrayList]$PropertyArray = ("Melee","Ranged","Magic","Will","Will","Defense","Defense","Movement","Health")
        $AllValues = @()
        while ($AllValues.count -gt 7 -OR $AllValues.count -lt 3){
            $AllValues = $this.Get_PointDistributionArray()
        }
        #TODO Randomize property array and assign a number from the $AllValues array
        foreach ($Value in $AllValues){
            $Random = Get-Random -min 0 $PropertyArray.count
            $Property = $PropertyArray[$Random]
            $this."$Property" += $Value
            if ($Value - $Difficulty -gt $this.Equipment){
                $this.Equipment = $Value - $Difficulty
            }
            1..2 | foreach {$PropertyArray.Remove("$Property")}
        }
        $MeleeArray = ("0H","1H","1H+1H","2H","2H+")
        $RangedArray = ("SR","MR","LR")
        if ($this.Melee -gt 0){
            $Random = Get-Random -min 0 -max $MeleeArray.count
            $MeleeType = $MeleeArray[$Random]
            $this.Melee = "$MeleeType [$($this.melee)]"
        }
        if ($this.Melee -eq 0){$this.melee = "-"}
        if ($this.Ranged -gt 0){
            $Random = Get-Random -min 0 -max $RangedArray.count
            $RangedType = $RangedArray[$Random]
            $this.Ranged = "$RangedType [$($this.Ranged)]"
        }
    }
    
    
    [array] Get_PointDistributionArray () {
        $AllValues = @()
        $TotalValue = $this.Points
        $CalculatedValue = 0
        $RemainingValue = 0
        
        $count = 0
        while ($TotalValue -gt 0 -or $AllValues.count -lt 7){
            $count++
            [int] $CalculatedValue = Get-Random -min 1 -max 18
            if ($CalculatedValue -le $this.Difficulty+$this.EquipmentModifier){
                $RemainingValue = $TotalValue - $CalculatedValue
                if ($RemainingValue -ge 0){
                    $TotalValue = $RemainingValue
                    $AllValues += $CalculatedValue
                }
            }
            if ($Count -gt 100){
                break
            }
        }
        return $AllValues
    }
}
1..7 | % {
    $Difficulty = $_
    1..10 | % {
        $output = New-Object Npc($Difficulty)
        $output
    }
}