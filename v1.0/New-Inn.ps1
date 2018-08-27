param(
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
    )]$TownSize = "Large Town"
)
. ./LoadClasses.ps1
[Inn]::New($InnType,$PatronType)