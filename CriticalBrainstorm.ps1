# http://donjon.bin.sh/pathfinder/random/rpc.cgi?type=Magic+Shop+Name&n=1&shop_type=Alchemist
# http://donjon.bin.sh/pathfinder/random/rpc.cgi?type=Magic+Shop+Location&n=1&town_size=Large+City&shop_type=Alchemist
# http://donjon.bin.sh/pathfinder/random/rpc.cgi?type=Magic+Shop+Description&n=1&town_size=Large+City&shop_type=Alchemist
# http://donjon.bin.sh/pathfinder/random/rpc.cgi?type=Magic+Shopkeeper&n=1&shop_type=Alchemist
# http://donjon.bin.sh/pathfinder/random/rpc.cgi?type=Magic+Shop+Item&n=8&sort=1&town_size=Large+City&shop_type=Alchemist

function roll {
    param($dice)
    $splitDice = $dice -split("d")
    $count = [int]$splitDice[0]
    $sides = [int]$splitDice[1]
    (1..$count | % {Get-Random -min 1 -max ($sides+1)} | measure-object -sum).sum
}


foreach type in @(magic,mundane,gems,art) if (1d100 > (100 - (level * 5)){roll on typechart}
-ManualRollMode
magicitem = "+((level/5).rnddown)"
converttables to be easily parsed

dynamic parameters/sets
better documentation of used content and avoidance when issueing new content

--
monster image lookup
levelled eberron race creator with weapons

--
Dungeon Room Generator (donjon/book?)

--
from donjon
Vendor Generator
Markov Name Generator
Legendary Weapon Generator
Random Inn Generator
Weather Generator