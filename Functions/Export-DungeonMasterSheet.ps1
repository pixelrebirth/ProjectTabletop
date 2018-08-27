function Export-DungeonMasterSheet {
    param ($BlobData)

    $count = 1
    foreach ($quest in $BlobData.SideQuests){
        "### $($quest.Title)"
        foreach ($line in $($quest.summary)){
            if ($line -ne ""){
                ""
                "$($line -replace("^(\w)",'**$1**'))"
            }
        }

        if ($count -eq 2){
            $count = 0
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | MAJOR PLOT</div>"
            "\page"
        }
        else {
            '```'
            '```'
        }
        $count++
    }
    
    foreach ($type in @("Allies","Neutrals","Villains")){
        foreach ($character in $blobdata.$type){
            "<div class=`'wide`'>"
            "### $($character.name) ($($character.Title))"          
            "##### Quote"
            "$($character.Quote)"
            "##### Appearance"
            "$($character.Appearance)"
            "##### Roleplaying"
            "$($character.Roleplaying)"
            "##### Personality"
            "$($character.Personality)"
            "##### Motivation"
            "$($character.Motivation)"
            "##### Background"
            "$($character.Background)"
            "##### Traits"
            "$($character.Traits)"
            "</div>"
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |$($Type.toupper())</div>"
            "\page"
        }
    }

    $Count = 0
    "<div class=`'wide`'>"
    '### Levelled Treasure Rolls'
    "Roll | Items | Gold"
    "-----:|-----:|----:"

    foreach ($treasure in $BlobData.Treasures){
        if ($Count -gt 40){
            "</div>"
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | TREASURE</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | TREASURE</div>"
    "\page"

    Foreach ($NameType in $BlobData.NameVariants){
        "### $($NameType.NameType.ToUpper())"
        "$($NameType.names[0..9].trim() -join(", "))"
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | NAMES</div>"
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
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | VENDORS</div>"
            "\page"
            "<div class=`'wide`'>"
        }
        $count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | VENDORS</div>"
    "\page"
    
    $Total = 0
    foreach ($Desc in $BlobData.Descriptions){                    
        if ($Desc.values -ne $null){
            $value = $(($desc.values) -replace("^0 |.*[\=\-][\=\-]+.*",''))
            $total += $value.length
            
            ""
            if ($total -gt 4500){
                "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | DESCRIPTIONS</div>"
                "\page"
                $total = 0
            }
            
            "### $($desc.keys)"
            "$value"
        }
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | DESCRIPTIONS</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | DONJON</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | DONJON </div>"
    "\page"

    "<div class=`'wide`'>"
    $Count = 1
    "### Pockets"
    "|Dice Roll|Pockets|"
    "|:-----:|:-----|"
    foreach ($Pocket in $($BlobData.Pockets)){
        "|$Count|$Pocket|"
        $Count++
    }
    
    $Count = 1
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | DICE ROLLS</div>"
    "\page"
    
    "# Panic-Plots"
    foreach ($PanicPlot in $($BlobData.PanicPlots)){
        "### $($PanicPlot.Title)"
        ""
        "##### Summary:"
        "$($PanicPlot.Summary)"
        ""
        "##### Twist:"
        "$($PanicPlot.Twist)"
    }

    '```'
    '```'
    $Count = 1
    "<div class=`'wide`'>"
    "# Spare Monsters"
    "### Extra Monsters"
    "|Dice Roll|Monster|"
    "|:-----|:-----|"
    foreach ($monster in $BlobData.ExtraMonsterKits.extramonsters){
        "|$Count|$monster|"
        $Count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | EXTRA MONSTERS </div>"
    "\page"

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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | INN</div>"
}