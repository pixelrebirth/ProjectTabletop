class Treasure {
    $Level
    $Gold
    $TreasureParsed
    [System.Collections.ArrayList]$Items
    [Bool]$ManualRollMode = $false
    
    Treasure ($Level) {
        $this.Items = New-Object System.Collections.ArrayList
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

    [void] GetParse ([int]$ArrayInt,[int]$TreasureInt) {
        $roll = $this.roll("1d100")
        $SectionParsed = $this.TreasureParsed[$TreasureInt].split(";")
        $SectionParsed[$ArrayInt].split('*') | foreach {
            $each = $_.split(":")
            if(($each[0]..$each[1]) -match $roll){
                if ($ArrayInt -eq 0 -AND $TreasureInt -eq 0){
                    return $each[2]
                }
                else {
                    $this.items.Add($each[2])
                }
            }
        }
    }

    [void] GetMundane () {     
        $type = $this.GetParse(0,0)
        switch ($type) {
            "Alchemical item" {$this.GetParse(1,0)}
            "Armor" {$this.GetParse(2,0)}
            "Shield" {$this.GetParse(3,0)}
            "Weapons" {$this.GetParse(4,0)}
            "Tools and gear" {$this.GetParse(5,0)}
        }
    }
    [void] GetMagic () {}
    [void] GetGem () {}
    [void] GetArt () {}
    
    [void] GetArmor () {}
    [void] GetWeapon () {}
    [void] GetShield () {}

    [void] GetGold () {
        $CoinSides = "1d$([int]($This.level / 2))"
        $CoinsMax = $this.roll($CoinSides) * ([math]::floor(($this.level / 5)) + 1) * 100
        $CoinsMin = $CoinsMax * .75
        $this.Gold = [int](Get-Random -min $CoinsMin -max $CoinsMax)
    }
}

[treasure]::new(10)
