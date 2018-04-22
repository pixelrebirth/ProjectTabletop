class Treasure {
    $Level
    $Coins
    [Bool]$ManualRollMode = $false
    $TreasureParsed
    
    Treasure ($Level) {
        $this.Level = $Level
        $this.TreasureParsed = ((Get-Content ./TreasureData.txt) -join("")) -split('-----')
        $TreasureTypes = @("magic","mundane","gems","art")

        foreach ($eachType in $TreasureTypes){
            $d100roll = $this.roll("1d100")
            if ($d100roll -gt (100 - ($this.level * 5))){
                $This.GetTreasure($eachType)
            }
        }

        $this.GetGold()
    }

    hidden [int] Roll ($dice) {
        $splitDice = $dice -split("d")
        $count = [int]$splitDice[0]
        $sides = [int]$splitDice[1]
        return (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
    }

    [void] GetTreasure ($Type) {
        switch ($Type) {
            "mundane"  { $this.GetMundane() }
             "gems"    { $this.GetGem() }
             "art"     { $this.GetArt() }
             "magic"   { $this.GetMagic() }
        }
    }

    [void] GetMundane () {}
    [void] GetMagic () {}
    [void] GetGem () {}
    [void] GetArt () {}

    [void] GetGold () {
        $CoinSides = "1d$([int]($This.level / 2))"
        $CoinsMax = $this.roll($CoinSides) * ([math]::floor(($this.level / 5)) + 1) * 100
        $CoinsMin = $CoinsMax * .75
        $this.Coins = [int](Get-Random -min $CoinsMin -max $CoinsMax)
    }
}

[treasure]::new(10)