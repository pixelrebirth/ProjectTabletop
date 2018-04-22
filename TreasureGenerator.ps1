param(
    $Type,
    [switch]$ManualRollMode
)
function roll {
    param($dice)
    $splitDice = $dice -split("d")
    $count = [int]$splitDice[0]
    $sides = [int]$splitDice[1]
    (1..$count | ForEach-Object {Get-Random -min 1 -max ($sides+1)} | Measure-Object -sum).sum
}

function Get-Treasure {
    param($Type, $TreasureParsed)
    switch ($Type) {
        mundane { 
            $MundaneParsed = $TreasureParsed[0].split(";")
            function SubRoll ([int]$intArray) {
                $roll = roll 1d100
                $MundaneParsed[$intArray] | foreach {
                    $each = $_.split(":")
                    if(($each[0]..$each[1]) -match $roll){
                        return $each[3]
                    }
                }
            }
            
            $type = SubRoll -intArray 0
            switch ($type) {
                "Alchemical item" {SubRoll -intArray 1}
                "Armor" {SubRoll -intArray 2}
                "Shield" {SubRoll -intArray 3}
                "Weapons" {SubRoll -intArray 4}
                "Tools and gear" {SubRoll -intArray 5}
            }
            
            $OutputTreasure = [PSCustomObject]@{
                Type = $MundaneParsed[0]
                Treasure = $Choice[1]
            }
         }
         gems    { }
         art     { }
         magic   { }
    }
}

$TreasureParsed = ((Get-Content ./TreasureData.txt) -join("")) -split('-----')

$TreasureTypes = @("magic","mundane","gems","art")
foreach ($eachType in $TreasureTypes){
    $d100roll = roll 1d100
    if ($d100roll -gt (100 - ($level * 5))){
        Get-Treasure -Type "mundane" -TreasureParsed $TreasureParsed
    }
}
$CoinsMax = (roll "1d$([int]($level / 2))") * ([math]::floor(($level / 5)) + 1) * 100
$CoinsMin = $CoinsMax * .75
$Coins =  [int](Get-Random -min $CoinsMin -max $CoinsMax)


# foreach type in @(magic,mundane,gems,art) if (1d100 > (100 - (level * 5)){roll on typechart}
# -ManualRollMode
# magicitem = "+((level/5).rnddown)"
# converttables to be easily parsed