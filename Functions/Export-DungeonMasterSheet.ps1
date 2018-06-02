function Export-DungeonMasterSheet {
    param ($BlobData)

    # . {($BlobData.SideQuests[0]).title
    #     ($BlobData.SideQuests[0]).summary
    #     $BlobData.Lore[0].lore
    #     $BlobData.Allies[0]
    #     $BlobData.Allies[0].CharacterSheet
    #     $BlobData.Neutrals[0]
    #     $BlobData.Neutrals[0].CharacterSheet
    #     $BlobData.Villains[0]
    #     $BlobData.Villains[0].CharacterSheet
    #     $BlobData.MonsterKits[0].monstergroups | select CR,Name,Type,HP,AC,DamageCM,Speed | ft
    #     $BlobData.MonsterKits[0].monstergroups | select Name,Image,SpecialAttacks,Notes | fl
    #     $BlobData.NPCKits[0].npcgroups | select Level,Name,Race,Class,Vitals,Attack | ft
    #     $BlobData.NPCKits[0].npcgroups | select Name,Appearance,Traits | fl
    #     } 
    "<div class=`'wide`'>"
    '### Level 3 Treasure Rolls'
    "Roll | Items | Gold"
    "-----:|-----:|----:"

    foreach ($treasure in $BlobData.Treasures){
        if ($Count -gt 40){
            "</div>"
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | TREASURE</div>"
            "\page"
            "<div class=`'wide`'>"
            "Roll | Items | Gold"
            "-----:|-----:|----:"
            $Count = 0
        }
        "$($treasure.dicenumber) | $(($treasure.items) -join(", ")) | $($treasure.gold)"
        $Count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | TREASURE</div>"
    "\page"

    "# Names"
    Foreach ($NameType in $BlobData.NameVariants){
        "### $($NameType.NameType.ToUpper())"
        "$($NameType.names[0..9].trim() -join(", "))"
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | NAMES</div>"
    "\page"
    
    "<div class=`'wide`'>"
    "# Panic Locations"
    Foreach ($Location in $BlobData.PanicLocations){
        "### $($Location.name)"
        
        Get-Content -Path ./data/LocationUri.txt | Where {$_ -match "^$($Location.name),(.*)$"} | Out-Null
        $uri = $Matches[1]

        $GetLore = invoke-webrequest -uri "http://eberron.wikia.com$uri"
        $Lore = $((($GetLore.ParsedHtml.body.outertext) -split('\n')) | where {$_.length -gt 100})

        foreach ($line in $lore){
            $ReducedLine = $($line -replace("^[A-Za-z ]+ Edit",""))
            ""
            "$ReducedLine"
        }
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | LOCATIONS</div>"
    "\page"

    $count = 1
    "<div class=`'wide`'>"
    "# Vendors"
    foreach ($shop in $($BlobData.Vendors)){
        "### $($shop.ShopName) [$($shop.ShopType)]"
        ""
        "###### __ShopKeep:__"
        "$($shop.ShopKeep)"
        ""
        "---"
        "###### __Location:__"
        "$($shop.Location)"
        ""
        "---"
        "###### __Description:__"
        "$($shop.Description)"
        ""
        "|Item|Description|"
        "|:-----|:-----|"
        foreach ($item in $shop.items){
            "|$($item.name)|$($item.notes)|"
        }
        
        if ($count -eq 3){
            "</div>"
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | VENDORS</div>"
            "\page"
            "<div class=`'wide`'>"
        }
        $count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | VENDORS</div>"
    "\page"
    
    $Total = 0
    foreach ($Desc in $BlobData.Descriptions){                    
        if ($Desc.values -ne $null){
            $value = $(($desc.values) -replace("^0 |.*[\=\-][\=\-]+.*",''))
            $total += $value.length
            
            ""
            if ($total -gt 4500){
                "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | DESCRIPTIONS</div>"
                "\page"
                $total = 0
            }
            
            "### $($desc.keys)"
            "$value"
        }
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | DESCRIPTIONS</div>"
    "\page"
    
    "<div class=`'wide`'>"
    "### Weather"
    "|Weather|Effect|"
    "|:-----|:-----|"
    foreach ($eachWeather in $($BlobData.Weather)){
        "|$($eachWeather.weather)|$($eachWeather.effect)|"
    }

    "### Prophecies"
    "||"
    "|:-----|"
    foreach ($prophecy in $($BlobData.Prophecies)){
        "|$prophecy|"
    }

    "### Omens"
    "||"
    "|:-----|"
    foreach ($omen in $($BlobData.Omens)){
        "|$omen|"
    }

    "### Graffiti"
    "||"
    "|:-----|"
    foreach ($graf in $($BlobData.Graffiti)){
        "|$graf|"
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | DONJON</div>"
    "\page"

    "<div class=`'wide`'>"
    "### Castles"
    "||"
    "|:-----|"
    foreach ($Castle in $($BlobData.Castles)){
        "|$Castle|"
    }

    "### Legendary Items"
    "||"
    "|:-----|"
    foreach ($Legend in $($BlobData.LegendaryItems)){
        "|$Legend|"
    }
    
    "### Tomes"
    "||"
    "|:-----|"
    foreach ($Tome in $($BlobData.Tomes)){
        "|$Tome|"
    }    
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | DONJON </div>"
    "\page"

    $Count = 1
    "### Pockets"
    "|Dice Roll|Pockets|"
    "|:-----:|:-----|"
    foreach ($Pocket in $($BlobData.Pockets)){
        "|$Count|$Pocket|"
        $Count++
    }
    
    $Count = 1
    "<div class=`'wide`'>"
    "### GiantBags"
    "|Dice Roll|GiantBags|"
    "|:-----:|:-----|"
    foreach ($GiantBag in $($BlobData.GiantBags)){
        "|$Count|$GiantBag|"
        $Count++
    }

    
    $Count = 1
    "### Traps"
    "|Dice Roll|Trap|DCs|"
    "|:-----:|:-----|"
    foreach ($Trap in $($BlobData.Traps | select -unique)){
        $Trap = ($Trap -split('\;\\n    ')) 
        "|$Count|$($Trap[0])|$($Trap[1])|"
        $Count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | DICE ROLLS</div>"
    "\page"
    
    "# Panic-Plots"
    
    foreach ($PanicPlot in $($BlobData.Inns)){
        "### $($PanicPlot.Title)"
        ""
        "##### Summary:"
        "$($PanicPlot.Summary)"
        ""
        "##### Twist:"
        "$($PanicPlot.Twist)"
    }
    "<div class=`'wide`'>"
    "# Inn"
    $Inn = $BlobData.Inn
    "### $($Inn.Name)"
    ""
    "#### Location:"
    "$($Inn.Location)"
    ""
    "#### Description:"
    "$($Inn.Description)"
    ""
    "#### Keeper:"
    "$($Inn.Keeper)"
    ""
    "#### Menu:"
    "||"
    "|:-----|"
    foreach ($item in $Inn.Menu){
        "|$Item|"
    }
    "#### Rumors:"
    "||"
    "|:-----|"
    foreach ($Rumor in $Inn.Rumors){
        "|$Rumor|"
    }
    ""
    "#### Patrons:"
    foreach ($person in $Inn.Patrons){
        $Person = $Person -Split(': ')
        "##### $($Person[0])"
        "$($Person[1])"
    }
    ""
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>LEVEL DATA | INN</div>"
    "\page"
    $Count = 1
    "### Extra Monsters"
    "|Dice Roll|Monster|"
    "|:-----|:-----|"
    foreach ($monster in $BlobData.ExtraMonsterKits.extramonsters){
        "|$Count|$monster|"
        $Count++
    }
}