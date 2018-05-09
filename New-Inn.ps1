param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "Common",
        "Good",
        "Poor"
    )]$InnType,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "Townsfolk",
        "Adventurers"
    )]$PatronType
)
. ./LoadClasses.ps1
[Inn]::New($InnType,$PatronType)