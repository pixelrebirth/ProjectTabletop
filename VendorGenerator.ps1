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

class vendor {
    $ShopName
    $ShopKeep
    $Location
    $Description
    $Items

    vendor ($TownSize, $ShopType) {
        $this.items = New-Object System.Collections.ArrayList

        $this.shopname = (invoke-webrequest "https://donjon.bin.sh/d20/random/rpc.cgi?type=Magic+Shop+Name&n=1&shop_type=$ShopType").content -replace("`"|,|\[|\]","")
        $this.location = (invoke-webrequest "https://donjon.bin.sh/d20/random/rpc.cgi?type=Magic+Shop+Location&n=1&town_size=Thorp&shop_type=$ShopType").content -replace("`"|,|\[|\]","")
        $this.description = (invoke-webrequest "https://donjon.bin.sh/d20/random/rpc.cgi?type=Magic+Shop+Description&n=1&town_size=Thorp&shop_type=$ShopType").content -replace("`"|,|\[|\]","")
        $this.shopkeep = (invoke-webrequest "https://donjon.bin.sh/d20/random/rpc.cgi?type=Magic+Shopkeeper&n=1&shop_type=$ShopType").content -replace("`"|,|\[|\]","")
        $ItemsRaw = (invoke-webrequest "https://donjon.bin.sh/d20/random/rpc.cgi?type=Magic+Shop+Item&n=3&sort=1&town_size=Thorp&shop_type=$ShopType").content
        $ParsedItems = ($ItemsRaw -replace("<p><i>",";") -replace("</i></p>",":")  -replace("`"|,|\[|\]","")) -split(":")
        $ParsedItems | foreach {
            $SplitParsed = $_ -split(";")
            $eachItem = [StoreItem]::new()
            $eachItem.Name = $SplitParsed[0]
            $eachItem.Notes = $SplitParsed[1]
            if ($eachItem.Name -ne ""){$this.Items.add($eachItem)}
        }
    }
}

class StoreItem {
    $Name
    $Notes
}

[vendor]::new($TownSize,$ShopType)