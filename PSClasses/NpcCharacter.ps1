class Character {
    hidden [int] $PointsPerDifficulty = 3
    hidden [int] $BasePoints = 0

    [int] $Movement
    [int] $FirstAid
    [int] $Grapple
    [int] $Defense
    [int] $Tactics
    [string] $Damage
    [int] $CM

}

class Npc : Character {
    $DifficultyName
    $Type
    $Style
    [int] $Difficulty
    $Offense
    $Magic
    $PointsTotal

    Npc ($Difficulty, $Type){
        $this.Difficulty = $Difficulty
        $this.DifficultyName = @("Minor","Normal","Major","Brutal","Champion","Boss","Ancient","Legendary","DemiGod","God")[$Difficulty-1]
        $this.Type = $Type   
        
        switch ($Type) {
            "Balanced" {
                $this.Set_Stats("Melee",.25,.25,.25,.10,.05,.10)
            }
            "Offensive" {
                $this.Set_Stats("Ranged",.35,.10,.25,.20,.05,.05)
            }
            "Defensive" {
                $this.Set_Stats("Melee",.10,.35,.25,.05,.05,.20)
            }
            "Support" {
                $this.Set_Stats("Magic",.20,.05,.35,.10,.25,.05)
            }
        }
    }
    [void] Set_Stats ([string]$Style, [decimal]$Offense, [decimal]$Defense, [decimal]$Tactics, [decimal]$Movement, [decimal]$FirstAid, [decimal]$Grapple){
        $this.PointsTotal = ($this.PointsPerDifficulty * $this.Difficulty) + $this.BasePoints
        $this.Style = $Style

        $Quality = $this.Difficulty
        $this.Tactics = [math]::Floor($this.PointsTotal * $Tactics + .5) 
        $this.Offense = ([math]::Floor($this.PointsTotal * $Offense) * 2) + $Quality
        $this.Defense = 10 + [math]::Floor($this.PointsTotal * $Defense) + $Quality + $Quality
        $this.Movement = [math]::Floor($this.PointsTotal * $Movement) + 3
        $this.FirstAid = ([math]::Floor($this.PointsTotal * $FirstAid) * 3) + 5
        $this.Grapple = [math]::Floor($this.PointsTotal * $Grapple)
      
        if ($this.Tactics -gt 10){$this.Tactics = 10}
        if ($this.Offense -gt 30){$this.Offense = 30}
        if ($this.Defense -gt 40){$this.Defense = 40}
        if ($this.Movement -gt 10){$this.Movement = 10}
        if ($this.FirstAid -gt 35){$this.FirstAid = 35}
        if ($this.Grapple -gt 10){$this.Defense = 10}

        $this.CM = $this.Offense
        switch -regex ($this.Tactics) {
            "0|1$|2" {$this.Damage = "1d6+1d8"}
            "3|4"   {$this.Damage = "1d6+1d10"}
            "5|6"   {$this.Damage = "1d8+1d10"}
            "7|8"   {$this.Damage = "1d8+1d12"}
            "9|10"  {$this.Damage = "1d10+1d12"}
        }
    }
}

    "Balanced","Offensive","Defensive","Support" | foreach {
        $Type = $_
        1..10 | % {
            New-Object Npc($_, $Type)
        }
    } | sort Difficulty,Type | Select "DifficultyName","Type","Style","CM","Damage","Defense","Tactics","Movement","FirstAid","Grapple","PointsTotal" | ft *
