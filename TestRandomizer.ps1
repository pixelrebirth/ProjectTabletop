param(
    $Level = 3,
    $PlotType = "All",

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
    $SearchTerm = "Khorvaire"
)
. ./LoadClasses.ps1
Get-SimCityLoading
$RandomContent = [RandomContent]::new()
Get-SimCityLoading
$RandomContent.Treasures = . {
    if ($level -ge 5){1..14 | % {($output = [treasure]::new($level-3)).DiceNumber = $_ ; $output}}
    if ($level -ge 4){15..29 | % {($output = [treasure]::new($level-2)).DiceNumber = $_ ; $output}}
    if ($level -ge 3){30..44 | % {($output = [treasure]::new($level-1)).DiceNumber = $_ ; $output}}
    if ($level -ge 2){45..59 | % {($output = [treasure]::new($level)).DiceNumber = $_ ; $output}}
    60..74 | % {($output = [treasure]::new($level+1)).DiceNumber = $_ ; $output}
    75..89 | % {($output = [treasure]::new($level+2)).DiceNumber = $_ ; $output}
    90..100 | % {($output = [treasure]::new($level+3)).DiceNumber = $_ ; $output}
}

Get-SimCityLoading
$RandomContent.PanicPlots = 1..3 | foreach {[plot]::new()}
Get-SimCityLoading
$RandomContent.SideQuests = 1..3 | foreach {[plot]::new($PlotType,$TagsFilter,$AdaptedToFilter)}
Get-SimCityLoading
$RandomContent.NameVariants = . {
    $Categories = Get-Content $PSScriptRoot/data/NameGenCategories.txt
    foreach ($Category in $Categories){
        Get-SimCityLoading
        [Names]::new($Category)
    }

}
Get-SimCityLoading
$RandomContent.Weather = 1..3 | foreach {[Weather]::new()}
Get-SimCityLoading
$RandomContent.Inn = [Inn]::New($InnType,$PatronType)
Get-SimCityLoading
$RandomContent.Vendors = . {
    @("Trader","Armorer","Weaponsmith","Alchemist","Scribe","Wandwright") | foreach {
        [Vendor]::new($TownSize,$_)
    }
}

$Stature = "Memorable"
$Trait = '.*'

$LevelMod = 0
$Alignment = "Allies"
Get-SimCityLoading
$RandomContent.Allies = 1..3 | foreach {
    [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+$LevelMod))
    $LevelMod += 2
}

$LevelMod = 0
$Alignment = "Neutrals"
Get-SimCityLoading
$RandomContent.Neutrals = 1..2 | foreach {
    [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+$LevelMod))
    $LevelMod += 2
}

$Alignment = "Villains"
Get-SimCityLoading
$RandomContent.Villains = [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+3))

Get-SimCityLoading
$RandomContent.MonsterKits = 1..5 | foreach {
    ./Get-Monsters.ps1 -PartyLevel (($Level * 4) + $Difficulty) -MinCR ($Level + $Difficulty) -MaxCR ($Level + 2 + $Difficulty) -MaxUnique 4
}

Get-SimCityLoading
$RandomContent.ExtraMonsterKits = 1..3 | foreach {
    ./Get-Monsters.ps1 -HD ($Level + $Difficulty) -MaxUnique 4
}

$Alignment = "Neutrals"
$Stature = 'Forgettable'
Get-SimCityLoading
$RandomContent.NPCKits = 1..5 | foreach {
    $LevelMod = -1
    $Output = [PSCustomObject]@{
        NPCGroups = 1..4 | foreach {
            [CharacterProfile]::new($Genre,$Alignment,$Stature,$Trait,($Level+[int]$LevelMod))
            [decimal]$LevelMod += [decimal](.65)
        }
    }
    $Output
}


Get-SimCityLoading
$RandomContent.Prophecies = .\Get-DonjonGenerator.ps1 -GeneratorType Prophecy -HowMany 4
Get-SimCityLoading
$RandomContent.Omens = .\Get-DonjonGenerator.ps1 -GeneratorType Omen -HowMany 4
Get-SimCityLoading
$RandomContent.Graffiti = .\Get-DonjonGenerator.ps1 -GeneratorType Graffiti -HowMany 5
Get-SimCityLoading
$RandomContent.SecretDoors = .\Get-DonjonGenerator.ps1 -GeneratorType Secret -HowMany 10
Get-SimCityLoading
$RandomContent.Castles = .\Get-DonjonGenerator.ps1 -GeneratorType Castle -HowMany 4
Get-SimCityLoading
$RandomContent.LegendaryItems = .\Get-DonjonGenerator.ps1 -GeneratorType Legendary -HowMany 4
Get-SimCityLoading
$RandomContent.Pockets = .\Get-DonjonGenerator.ps1 -GeneratorType Pocket -HowMany 10
Get-SimCityLoading
$RandomContent.Tomes = .\Get-DonjonGenerator.ps1 -GeneratorType Tome -HowMany 5
Get-SimCityLoading
$RandomContent.Traps = .\Get-DonjonGenerator.ps1 -GeneratorType 'Trap' -HowMany 20
Get-SimCityLoading
$RandomContent.GiantBags = .\Get-DonjonGenerator.ps1 -GeneratorType GiantBag -HowMany 6

Get-SimCityLoading
$RandomContent.Lore = . {
    1..10 | foreach {
        [Lore]::new($SearchTerm) 
    } | select -unique -Property Lore
    1..3 | foreach {
        [Lore]::new()
    }
}

Get-SimCityLoading
$RandomContent.PanicLocations = 1..3 | foreach {
    [Location]::new()
}

Get-SimCityLoading
$RandomContent.Descriptions = . {
    $List = Get-Content $PSScriptRoot\Data\FantasyDescPhp.txt
    $List | foreach {
        Get-SimCityLoading
        @{
            $_ = .\Get-FantasyGenerators.ps1 -SearchName $_
        }
    }
}

Get-SimCityLoading
$RandomContent