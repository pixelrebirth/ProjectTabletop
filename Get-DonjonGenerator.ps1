param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "Prophecy",
        "Omen",
        "Graffiti",
        "Secret",
        "Castle",
        "Legendary",
        "Pocket",
        "Tome",
        "Trap",
        "Monster",
        "GiantBag"
    )]$GeneratorType,
    [int]$HowMany = 4,
    [int]$Level = 1
)
switch ($GeneratorType) {
    "Prophecy" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Prophecy&n=$HowMany"}
    "Omen" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Omen&n=$HowMany"}
    "Graffiti" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Dungeon+Graffiti&n=$HowMany"}
    "Secret" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Secret+Door+Detail&n=$HowMany"}
    "Castle" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Castle&size=&race=&culture=&n=$HowMany"}
    "Legendary" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Legendary+Weapon&n=$HowMany"}
    "Pocket" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/m20/random/rpc.cgi?type=Purse&n=$HowMany"}
    "Tome" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Ancient+Tome&n=$HowMany"}
    "Trap" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/m20/random/rpc.cgi?type=Level+$Level+Room+Trap&n=$HowMany"}
    "Monster" {$Response = Invoke-WebRequest -uri "https://donjon.bin.sh/m20/monster/rpc.cgi?HD=$Level&n=$HowMany"}
    "GiantBag" {
        $Giants = @("Hill","Stone","Frost","Fire","Cloud","Storm")
        $Random = Get-Random -Min 0 -Max $Giants.Count
        $RandomGiant = $Giants[$Random]
        $Response = Invoke-WebRequest "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Giant+Bag&giant_type=$RandomGiant+Giant&n=$HowMany"
    }
}

return $Response.content -split('","') -replace('\[|\]|"','') 