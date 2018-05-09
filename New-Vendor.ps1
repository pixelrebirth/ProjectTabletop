param(
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
    
    [ValidateSet(
        "Trader",
        "Armorer",
        "Weaponsmith",
        "Alchemist",
        "Scribe",
        "Wandwright"
    )]$ShopType = "Trader"
)
. ./LoadClasses.ps1
[vendor]::new($TownSize,$ShopType)