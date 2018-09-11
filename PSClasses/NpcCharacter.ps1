class Character {
    hidden [int] $BaseDefense = 8
    hidden [int] $PointsPerDifficulty = 5
    hidden [int] $BasePoints = 10

    [int] $Movement = 6
    [int] $Defense = $this.BaseDefense
    [int] $Tactics
}

class Npc : Character {
    $Type
    $Style
    [int] $Difficulty
    $Offense
    $Magic

    Npc ($Difficulty, $Type){
        $this.Difficulty = $Difficulty
        $this.Type = $Type

        switch ($Type) {
            "Generalist" {
                $this.Set_Stats(.33,.33,.33)
            }
            "Offensive" {
                $this.Set_Stats(.50,.30,.20)
            }
            "Defensive" {
                $this.Set_Stats(.30,.50,.20)
            }
            "Tactical" {
                $this.Set_Stats(.30,.20,.50)
            }
        }

        [System.Collections.ArrayList]$MagicTechniques = ("Cr","Co","De","Tr","Pe")
        [System.Collections.ArrayList]$MagicForms = ("An","Ai","Wa","Bo","Pl","Fi","Mi","Ea","Sp","Im")
        
        $Max = [math]::ceiling($this.Offense / 5) + 1
        if ($Max -gt 5){$Max = 5}
        $this.Magic = "$Max-"
        
        $Max = [math]::ceiling($this.Offense / 3) + 1
        $this.Magic += "$Max"
    }

    [void] Set_Stats ([decimal]$Offense, [decimal]$Defense, [decimal]$Tactics){
        $PointsTotal = ($this.PointsPerDifficulty * $this.Difficulty) + $this.Difficulty

        $this.Offense = [math]::Ceiling($PointsTotal * $Offense)
        $this.Defense = $this.Defense + [math]::Ceiling($PointsTotal * $Defense)
        $this.Tactics = [math]::Ceiling($PointsTotal * $Tactics)
    }
}

    "Generalist","Offensive","Defensive","Tactical" | foreach {
        $Type = $_
        1..7 | % {
            New-Object Npc($_, $Type)
        }
    } | Select "Type","Difficulty","Offense","Defense","Tactics","Movement","Magic" | sort Difficulty,Type | ft
