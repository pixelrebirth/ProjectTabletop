class Character {
    hidden [int] $PointsPerDifficulty = 3
    hidden [int] $BasePoints = 0

    [int] $Movement
    [int] $FirstAid
    [int] $Grapple
    [int] $Defense
    [int] $Tactics
    [string] $OffenseMode
    [string] $DefenseMode
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
        $Styles = @("Melee","Ranged","Magic")
        $RandomNumber = Get-Random -min 0 -max 3

        $RandomStyle = $Styles[$RandomNumber]
        switch ($Type) {
            "Balanced" {
                $this.Set_Stats($RandomStyle,.25,.25,.25,.10,.05,.10)
            }
            "Offensive" {
                $this.Set_Stats($RandomStyle,.35,.10,.25,.20,.05,.05)
            }
            "Defensive" {
                $this.Set_Stats($RandomStyle,.15,.35,.25,.05,.05,.20)
            }
            "Support" {
                $this.Set_Stats($RandomStyle,.20,.05,.35,.10,.25,.05)
            }
        }
    }
    [void] Set_Stats ([string]$Style, [decimal]$Offense, [decimal]$Defense, [decimal]$Tactics, [decimal]$Movement, [decimal]$FirstAid, [decimal]$Grapple){
        $this.PointsTotal = ($this.PointsPerDifficulty * $this.Difficulty) + $this.BasePoints
        $this.Style = $Style

        $Quality = $this.difficulty
        $this.Tactics = [math]::Floor($this.PointsTotal * $Tactics + .5) 
        $this.Offense = ([math]::Floor($this.PointsTotal * $Offense))
        $this.Defense = 10 + [math]::Floor($this.PointsTotal * $Defense) + $Quality
        $this.Movement = [math]::Floor($this.PointsTotal * $Movement) + 3
        $this.FirstAid = ([math]::Floor($this.PointsTotal * $FirstAid) * 3) + 5
        $this.Grapple = [math]::Floor($this.PointsTotal * $Grapple)
      
        if ($this.Tactics -gt 10){$this.Tactics = 10}
        if ($this.Offense -gt 20){$this.Offense = 30}
        if ($this.Defense -gt 30){$this.Defense = 40}
        if ($this.Movement -gt 10){$this.Movement = 10}
        if ($this.FirstAid -gt 35){$this.FirstAid = 35}
        if ($this.Grapple -gt 10){$this.Defense = 10}

        $this.CM = $this.Offense + $Quality
        switch -regex ($this.Offense) {
            "^0|^1$" {$this.OffenseMode = "1d4+1d8"}
            "2|3"    {$this.OffenseMode = "1d6+1d8"}
            "4|5"    {$this.OffenseMode = "1d10+1d6"}
            "6|7"    {$this.OffenseMode = "1d8+1d10"}
            "8|9"    {$this.OffenseMode = "1d12+1d8"}
            "10"     {$this.OffenseMode = "1d10+1d12"}
        }
        
        switch -regex ($this.Difficulty) {
            "^0|^1$" {$this.DefenseMode = "1d4+1d6"}
            "2|3"    {$this.DefenseMode = "1d4+1d8"}
            "4|5"    {$this.DefenseMode = "1d6+1d8"}
            "6|7"    {$this.DefenseMode = "1d10+1d6"}
            "8|9"    {$this.DefenseMode = "1d8+1d10"}
            "10"     {$this.DefenseMode = "1d12+1d8"}
        }
    }
}

"Balanced","Offensive","Defensive","Support" | foreach {
    $Type = $_
    1..10 | % {
        New-Object Npc($_, $Type)
    }
} | sort Difficulty,Type | Select "DifficultyName","Type","Style","OffenseMode","CM","Defense","Tactics","DefenseMode","Movement","FirstAid","Grapple","PointsTotal" | ft *
