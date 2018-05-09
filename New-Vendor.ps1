param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "Thorp",
        "Hamlet",
        "Village",
        "Small Town",
        "Large Town",
        "Small City",
        "Large City",
        "Metropolis"
    )]$TownSize,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "Trader",
        "Armorer",
        "Weaponsmith",
        "Alchemist",
        "Scribe",
        "Wandwright"
    )]$ShopType
)

[vendor]::new($TownSize,$ShopType)