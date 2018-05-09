param(
    [ValidateSet(
        "Common",
        "Good",
        "Poor"
    )]$InnType = "Common",
    
    [ValidateSet(
        "Townsfolk",
        "Adventurers"
    )]$PatronType = "Townsfolk"
)
. ./LoadClasses.ps1
[Inn]::New($InnType,$PatronType)