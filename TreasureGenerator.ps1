class Treasure {
    $Level
    $Gold
    [System.Collections.ArrayList]$Items
    hidden $TreasureParsed
    hidden [Bool]$ManualRollMode = $false
    hidden $LastType
    hidden $ofQuality
    
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

    [void] GetParse ([int]$ArrayInt) {
        if ($ArrayInt -match "^0$|^1$|^2$"){
            $roll = $this.roll("1d100")
        }
        else {$roll = $this.roll("1d20")}

        $this.TreasureParsed[$ArrayInt].split('*') | foreach {
            $each = $_.split(":")
            if(($each[0]..$each[1]) -match $roll){
                if ($ArrayInt -match "^0$|^9$"){
                    $this.LastType = $each[2]
                }
                elseif ($ArrayInt -eq 10){
                    $this.ofQuality = $each[2]
                }
                else {
                    $this.items.Add($each[2])
                    start-sleep -Milliseconds 10
                }
            }
        }
    }

    [void] GetMundane () {     
        $this.GetParse(0)
        switch ($this.LastType) {
            "Alchemical" {$this.GetAlchemical()}
            "Armor" {$this.GetArmor()}
            "Shield" {$this.GetWeapon()}
            "Weapons" {$this.GetShield()}
            "Tools" {$this.GetTools()}
        }
    }
    [void] GetMagic () {
        $this.GetParse(9)
        $this.GetParse(10)
        switch ($this.LastType){
            "Alchemical" {
                $this.GetAlchemical()
                $this.items[-1] = "$($this.items[-1]) $($this.ofQuality)"
            }
            "Armor" {
                $this.GetArmor()
                $this.items[-1] = "$($this.items[-1]) $($this.ofQuality)"
            }
            "Shield" {
                $this.GetWeapon()
                $this.items[-1] = "$($this.items[-1]) $($this.ofQuality)"
            }
            "Weapon" {
                $this.GetShield()
                $this.items[-1] = "$($this.items[-1]) $($this.ofQuality)"
            }
            "Tool" {
                $this.GetTools()
                $this.items[-1] = "$($this.items[-1]) $($this.ofQuality)"
            }
            "Ring" {}
            "Amulet" {}
            "Scroll" {}
            "Wonderous Item" {}
        }
    }
    [void] GetGem () {}
    [void] GetArt () {}
    
    [void] GetAlchemical () {$this.GetParse(1)}
    [void] GetTools () {$this.GetParse(2)}
    [void] GetArmor () {$this.GetParse(3)}
    [void] GetShield () {$this.GetParse(4)}
    [void] GetWeapon () {
        $int = Get-Random -min 5 -max 9
        $this.GetParse($int)
    }

    [void] GetGold () {
        $CoinSides = "1d$([int]($this.level / 2))"
        $CoinsMax = $this.roll($CoinSides) * ([math]::floor(($this.level / 5)) + 1) * 100
        $CoinsMin = $CoinsMax * .75
        $this.Gold = [int](Get-Random -min $CoinsMin -max $CoinsMax)
    }
}

[treasure]::new(20)
