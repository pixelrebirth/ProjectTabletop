param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(2,20)]
    [int] $Level
)

begin {
    class Treasure {
        $Level
        $Gold
        [System.Collections.ArrayList]$Items
        $DiceNumber
        hidden $TreasureParsed
        hidden [Bool]$ManualRollMode = $false
        hidden $LastType
        hidden $ofQuality
        
        Treasure ($Level) {
            $this.Items = New-Object System.Collections.ArrayList
            $this.Level = $Level
            $this.TreasureParsed = ((Get-Content $PSScriptRoot\Data\TreasureData.txt) -join("")) -split('-----')
            $TreasureTypes = @("magic","mundane","gems","art")
            
            foreach ($eachType in $TreasureTypes){
                $d100roll = $this.roll("1d100")
                switch ($eachType) {
                    "mundane"  {
                        if ($d100roll -gt (40 - ($this.level * 5))){
                            $This.GetTreasure($eachType)
                        } 
                    }
                    "gems"    {
                        if ($d100roll -gt (50 - ($this.level * 5))){
                            $This.GetTreasure($eachType)
                        } 
                    }
                    "art"     {
                        if ($d100roll -gt (60 - ($this.level * 5))){
                            $This.GetTreasure($eachType)
                        } 
                    }
                    "magic"   {
                        if ($d100roll -gt (70 - ($this.level * 5))){
                            $This.GetTreasure($eachType)
                        } 
                    }
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
                if(($each[0]..$each[1]) -match "^$roll$"){
                    if ($ArrayInt -match "^0$|^9$"){
                        $this.LastType = $each[2]
                    }
                    elseif ($ArrayInt -eq 10){
                        $this.ofQuality = $each[2]
                    }
                    else {
                        if ($each[4] -match "\;"){
                            $worth = ($this.roll([string]$each[2])) * [int]$each[3]
                            $split = $each[4] -split(";")
                            $random = get-random -min 0 -max ($split.count)
                            $item = "$($split[$random]) ($worth gp)"
                            $this.items.Add($item)
                        }
                        else {
                            $this.items.Add($each[2])
                        }
                    }
                }
            }
        }

        [void] GetMundane () {     
            $this.GetParse(0)
            switch ($this.LastType) {
                "Alchemical" {$this.GetAlchemical()}
                "Armor" {$this.GetArmor()}
                "Shield" {$this.GetShield()}
                "Weapon" {$this.GetWeapon()}
                "Tool" {$this.GetTool()}
            }
            $this.LastType = $null
        }
        [void] GetMagic () {
            $this.GetParse(9)
            $this.GetParse(10)
            $plus = ([math]::floor(($this.level / 5)) + 1)

            switch ($this.LastType){
                "Alchemical" {
                    $this.GetAlchemical()
                    $this.SetMagicItem()
                }
                "Armor" {
                    $this.GetArmor()
                    $this.SetMagicItem()
                }
                "Shield" {
                    $this.GetShield()
                    $this.SetMagicItem()
                }
                "Weapon" {
                    $this.GetWeapon()
                    $this.SetMagicItem()
                }
                "Tool" {
                    $this.GetTool()
                    $this.SetMagicItem()
                }
                "Ring" {$this.items.add("Ring $($this.ofQuality) + $plus")}
                "Amulet" {$this.items.add("Amulet $($this.ofQuality) + $plus")}
                "Scroll" {$this.items.add("Scroll $($this.ofQuality) + $plus")}
                "Wonderous Item" {$this.items.add("Wonderous Item $($this.ofQuality) + $plus")}
            }
            $this.LastType = $null
        }

        
        [void] GetAlchemical () {$this.GetParse(1)}
        [void] GetArmor () {$this.GetParse(3)}
        [void] GetArt () {$this.GetParse(11)}
        [void] GetGem () {$this.GetParse(12)}
        [void] GetShield () {$this.GetParse(4)}
        [void] GetTool () {$this.GetParse(2)}
        [void] GetWeapon () {
            $int = Get-Random -min 5 -max 9
            $this.GetParse($int)
        }
        [void] SetMagicItem () {
            $plus = ([math]::floor(($this.level / 5)) + 1)
            $this.items[-1] = "$($this.items[-1]) $($this.ofQuality) + $plus"
        }
        [void] GetGold () {
            $CoinSides = "1d$([int]($this.level / 2))"
            $CoinsMax = $this.roll($CoinSides) * ([math]::floor(($this.level / 5)) + 1) * 100
            $CoinsMin = $CoinsMax * .85
            $this.Gold = [int](Get-Random -min $CoinsMin -max $CoinsMax)
        }
    }
}
process {
    if ($level -ge 5){1..14 | % {($output = [treasure]::new($level-3)).DiceNumber = $_ ; $output}}
    if ($level -ge 4){15..29 | % {($output = [treasure]::new($level-2)).DiceNumber = $_ ; $output}}
    if ($level -ge 3){30..44 | % {($output = [treasure]::new($level-1)).DiceNumber = $_ ; $output}}
    if ($level -ge 2){45..59 | % {($output = [treasure]::new($level)).DiceNumber = $_ ; $output}}
    60..74 | % {($output = [treasure]::new($level+1)).DiceNumber = $_ ; $output}
    75..89 | % {($output = [treasure]::new($level+2)).DiceNumber = $_ ; $output}
    90..100 | % {($output = [treasure]::new($level+3)).DiceNumber = $_ ; $output}
}
end {}