class CharacterRace {
    [String]$RaceName
    [ValidatePattern('^\w+;\d+$')]$Bonuses
    [String]$DefiningTrait
    [String]$RacialHistory

    CharacterRace ($RaceName) {
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

    CharacterRace () {
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