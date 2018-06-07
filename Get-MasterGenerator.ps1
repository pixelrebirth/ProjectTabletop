param(
    $Level = 3,
    
    [ValidateSet(
        "Common",
        "Good",
        "Poor"
        )]$InnType = "Common",
        
        [ValidateSet(
            "Townsfolk",
            "Adventurers"
        )]$PatronType = "Townsfolk",
        
        [ValidateSet(
            "Thorp",
            "Hamlet",
            "Village",
            "Small Town",
            "Large Town",
            "Small City",
            "Large City",
            "Metropolis"
        )]$TownSize = "Large Town",
        
        [ValidateSet("Fantasy","Modern","SciFI")]$Genre = "Fantasy",
        
        [int]$Difficulty = -2,
        $SearchTerm = "Chamber",
        $PlotType = "All"
)
. ./LoadClasses.ps1
$Global:loadcount = 0

Get-LoaderMessage
$RandomContent = [RandomContent]::new()
Get-LoaderMessage
$RandomContent.Treasures = . {
    if ($level -ge 5){1..14 | % {($output = [treasure]::new($level-3)).DiceNumber = $_ ; $output}}
    if ($level -ge 4){15..29 | % {($output = [treasure]::new($level-2)).DiceNumber = $_ ; $output}}
    if ($level -ge 3){30..44 | % {($output = [treasure]::new($level-1)).DiceNumber = $_ ; $output}}
    if ($level -ge 2){45..59 | % {($output = [treasure]::new($level)).DiceNumber = $_ ; $output}}
    60..74 | % {($output = [treasure]::new($level+1)).DiceNumber = $_ ; $output}
    75..89 | % {($output = [treasure]::new($level+2)).DiceNumber = $_ ; $output}
    90..100 | % {($output = [treasure]::new($level+3)).DiceNumber = $_ ; $output}
}

Get-LoaderMessage
$RandomContent.PanicPlots = 1..3 | foreach {[plot]::new()}
Get-LoaderMessage
$RandomContent.SideQuests = 1..3 | foreach {[plot]::new($PlotType,$TagsFilter,$AdaptedToFilter)}
Get-LoaderMessage
$RandomContent.NameVariants = Get-InternetNames
Get-LoaderMessage
$RandomContent.Weather = 1..3 | foreach {[Weather]::new()}
Get-LoaderMessage
$RandomContent.Inn = [Inn]::New($InnType,$PatronType)
Get-LoaderMessage
$RandomContent.Vendors = . {
    @("Trader","Armorer","Weaponsmith","Alchemist","Scribe","Wandwright") | foreach {
        Get-LoaderMessage
        [Vendor]::new($TownSize,$_)
    }
}

$Stature = "Memorable"
$Trait = '.*'

$LevelMod = 0
$Alignment = "Allies"
Get-LoaderMessage
$RandomContent.Allies = 1..3 | foreach {
    Get-LoaderMessage
    [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+$LevelMod))
    $LevelMod += 2
}

$LevelMod = 0
$Alignment = "Neutrals"
Get-LoaderMessage
$RandomContent.Neutrals = 1..2 | foreach {
    Get-LoaderMessage
    [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+$LevelMod))
    $LevelMod += 2
}

$Alignment = "Villains"
Get-LoaderMessage
$RandomContent.Villains = [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+3))

Get-LoaderMessage
$RandomContent.MonsterKits = 1..5 | foreach {
    $MonsterOutput = [PSCustomObject]@{
        MonsterGroups = . {
            Get-LoaderMessage
            ./Get-Monsters.ps1 -PartyLevel (($Level * 4) + $Difficulty) -MinCR ($Level + $Difficulty) -MaxCR ($Level + 2 + $Difficulty) -MaxUnique 3
        }
    }
    $MonsterOutput
}

Get-LoaderMessage
$RandomContent.ExtraMonsterKits = 1..3 | foreach {
    $ExtraOutput = [PSCustomObject]@{
        ExtraMonsters = . {
            Get-LoaderMessage
            ./Get-Monsters.ps1 -HD ($Level + $Difficulty) -MaxUnique 4
        }
    }
    $ExtraOutput
}

$Alignment = "Neutrals"
$Stature = 'Forgettable'
Get-LoaderMessage
$RandomContent.NPCKits = 1..5 | foreach {
    Get-LoaderMessage
    $LevelMod = -1
    $Output = [PSCustomObject]@{
        NPCGroups = 1..4 | foreach {
            Get-LoaderMessage
            [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+[int]$LevelMod))
            [decimal]$LevelMod += [decimal](.65)
        }
    }
    $Output
}


Get-LoaderMessage
$RandomContent.Prophecies = .\Get-DonjonGenerator.ps1 -GeneratorType Prophecy -HowMany 4
Get-LoaderMessage
$RandomContent.Omens = .\Get-DonjonGenerator.ps1 -GeneratorType Omen -HowMany 4
Get-LoaderMessage
$RandomContent.Graffiti = .\Get-DonjonGenerator.ps1 -GeneratorType Graffiti -HowMany 6
Get-LoaderMessage
$RandomContent.SecretDoors = .\Get-DonjonGenerator.ps1 -GeneratorType Secret -HowMany 10
Get-LoaderMessage
$RandomContent.Castles = .\Get-DonjonGenerator.ps1 -GeneratorType Castle -HowMany 4
Get-LoaderMessage
$RandomContent.LegendaryItems = .\Get-DonjonGenerator.ps1 -GeneratorType Legendary -HowMany 4
Get-LoaderMessage
$RandomContent.Pockets = .\Get-DonjonGenerator.ps1 -GeneratorType Pocket -HowMany 10
Get-LoaderMessage
$RandomContent.Tomes = .\Get-DonjonGenerator.ps1 -GeneratorType Tome -HowMany 6
Get-LoaderMessage
$RandomContent.Traps = .\Get-DonjonGenerator.ps1 -GeneratorType 'Trap' -HowMany 20
Get-LoaderMessage
$RandomContent.GiantBags = .\Get-DonjonGenerator.ps1 -GeneratorType GiantBag -HowMany 6

Get-LoaderMessage
$RandomContent.Lore = . {
1..5 | foreach {
    Get-LoaderMessage
    [Lore]::new($SearchTerm) 
}
1..3 | foreach {
    Get-LoaderMessage
    [Lore]::new()
}
}

Get-LoaderMessage
$RandomContent.PanicLocations = 1..3 | foreach {
Get-LoaderMessage
[Location]::new()
}

Get-LoaderMessage
$RandomContent.Descriptions = . {
    $List = Get-Content $PSScriptRoot\Data\FantasyDescPhp.txt
    $List | foreach {
        Get-LoaderMessage
        @{
            $_ = .\Get-FantasyGenerators.ps1 -SearchName $_
        }
    }
}
$filename = "level-$level-$((get-date).ticks)"
$RandomContent | Export-CliXml "./data/saves/$filename`.xml" -depth 10

Export-DungeonMasterSheet -BlobData $RandomContent | Set-Clipboard

return $RandomContent