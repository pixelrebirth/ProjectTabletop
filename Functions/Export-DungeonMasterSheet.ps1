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
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |MAJOR PLOT</div>"
            "\page"
        }
        else {
            '```'
            '```'
        }
        $count++
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |MAJOR PLOT</div>"
    "\page"

    $onetime = $false
    foreach ($eachlore in $blobdata.lore){
        if ($eachlore.source -match "wikia" -and $onetime -eq $false){
            $onetime = $true
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |HISTORY LORE</div>"
            "\page"
        }
        "### $($eachlore.source)"
        "$($eachlore.lore)"
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |WIKIA LORE</div>"
    "\page"
    foreach ($type in @("Allies","Neutrals","Villains")){
        foreach ($character in $blobdata.$type){
            "<div class=`'wide`'>"
            "### $($character.name) ($($character.Title))"
            "#### $($character.race) - $($character.class) - Level $($character.level)"
            
            "||"
            "|:-----|"
            "|$($character.vitals)|"
            "|$($character.stats.replace('| ',''))|"
            "|$($character.Attack)|"
            
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


    "<div class=`'wide`'>"
    ""
    $MonsterProperties = @("CR","Name","HP","AC","Speed","DamageCM")
    $kitcount = 1
    $count = 0
    $AllGroups = @()
    foreach ($monsterkit in $blobdata.monsterkits){
        "### Monster Kit $kitcount"
        foreach ($monster in $monsterkit.monstergroups){
            $countgroup = $monster.count
            foreach ($property in $MonsterProperties){
                $MonsterProp += "|$property"
                $MonsterCol += "|:-----"
                $MonsterString += "|$($monster.$property)"
            }
            if ($count -eq 0){
                "$MonsterProp|"
                "$MonsterCol|"
            }
            "$MonsterString|"
            
            $MonsterString = ""
            $count++
        }
        $count = 0
        $MonsterProp = ""
        $MonsterCol = ""
        $kitcount++
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | MONSTER TABLES</div>"
    "\page"

    $count = 1
    foreach ($monster in $blobdata.monsterkits.monstergroups | sort -property "Name" -unique){
        "### $($monster.Name)"
        "#### Stats:"
        "##### STR $($monster.str), DEX $($monster.dex), MIND $($monster.mind)"
        "#### Skills:"
        "$($monster.skills)"
        "#### Special Qualities:"
        "$($monster.SpecialQualities)"
        "#### Special Attacks:"
        "$($monster.SpecialAttacks)"
        "#### Notes:"
        "$($monster.notes)"
        "#### Image:"
        "$($monster.image.replace('E:\Other\PS_Scripts\Personal\DnDMicroliteTools',''))"
        if ($count -eq 5){
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | MONSTER DESCRIPTION </div>"
            "\page"
        }
        $count++
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | MONSTER DESCRIPTION </div>"
    "\page"

    "<div class=`'wide`'>"
    ""
    $NPCProperties = @("Level","Name","Race","Class","Vitals","Attack")
    $kitcount = 1
    $count = 0
    foreach ($npckit in $blobdata.npckits){
        "### NPC Kit $kitcount"
        foreach ($npcgroup in $npckit.npcgroups){
            $countgroup = $npcgroup.count
            foreach ($property in $NPCProperties){
                $npcProp += "|$property"
                $npcCol += "|:-----"
                $npcString += "|$($npcgroup.$property)"
            }
            if ($count -eq 0){
                "$npcProp|"
                "$npcCol|"
            }
            "$npcString|"
            
            $npcString = ""
            $count++
        }
        $count = 0
        $npcProp = ""
        $npcCol = ""
        $kitcount++
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | NPC TABLES </div>"
    "\page"

    $count = 1
    foreach ($npc in $blobdata.npckits.npcgroups | sort -property "Name" -unique){
        $stats = $($npc.Stats) -split(', \| ')
        "### $($npc.Name)"
        "#### Skills:"
        "##### $($stats[0])"
        "###### $($stats[1])"
        "#### Appearance:"
        "$($npc.Appearance)"
        if ($($npc.Traits) -ne $null){
            "#### Traits:"
            "$($npc.Traits)"
        }
        if ($count -eq 11){
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | NPC DESCRIPTION </div>"
            "\page"
        }
        $count++
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE | NPC DESCRIPTION </div>"
    "\page"
    
    $Count = 0
    "<div class=`'wide`'>"
    '### Level 3 Treasure Rolls'
    "Roll | Items | Gold"
    "-----:|-----:|----:"

    foreach ($treasure in $BlobData.Treasures){
        if ($Count -gt 40){
            "</div>"
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |TREASURE</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |TREASURE</div>"
    "\page"

    "# Names"
    Foreach ($NameType in $BlobData.NameVariants){
        "### $($NameType.NameType.ToUpper())"
        "$($NameType.names[0..9].trim() -join(", "))"
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |NAMES</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |LOCATIONS</div>"
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
            "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |VENDORS</div>"
            "\page"
            "<div class=`'wide`'>"
        }
        $count++
    }
    "</div>"
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |VENDORS</div>"
    "\page"
    
    $Total = 0
    foreach ($Desc in $BlobData.Descriptions){                    
        if ($Desc.values -ne $null){
            $value = $(($desc.values) -replace("^0 |.*[\=\-][\=\-]+.*",''))
            $total += $value.length
            
            ""
            if ($total -gt 4500){
                "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |DESCRIPTIONS</div>"
                "\page"
                $total = 0
            }
            
            "### $($desc.keys)"
            "$value"
        }
    }
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |DESCRIPTIONS</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |DONJON</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |DONJON </div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |DICE ROLLS</div>"
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
    "<div class='pageNumber auto'></div><div class='pageNumber'>1</div> <div class='footnote'>DM GUIDE |INN</div>"
}