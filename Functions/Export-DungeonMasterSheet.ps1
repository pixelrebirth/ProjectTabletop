function Export-DungeonMasterSheet {
    param ($InputObject)

    # . {($InputObject.SideQuests[0]).title
    #     ($InputObject.SideQuests[0]).summary
    #     $InputObject.Lore[0].lore
    #     $InputObject.Allies[0]
    #     $InputObject.Allies[0].CharacterSheet
    #     $InputObject.Neutrals[0]
    #     $InputObject.Neutrals[0].CharacterSheet
    #     $InputObject.Villains[0]
    #     $InputObject.Villains[0].CharacterSheet
    #     $InputObject.MonsterKits[0].monstergroups | select CR,Name,Type,HP,AC,DamageCM,Speed | ft
    #     $InputObject.MonsterKits[0].monstergroups | select Name,Image,SpecialAttacks,Notes | fl
    #     $InputObject.NPCKits[0].npcgroups | select Level,Name,Race,Class,Vitals,Attack | ft
    #     $InputObject.NPCKits[0].npcgroups | select Name,Appearance,Traits | fl
    #     } 
        "<div class=`'wide`'>"
        '### Level 3 Treasure Rolls'
        "Roll | Items | Gold"
        "-----:|-----:|----:"

        foreach ($treasure in $InputObject.Treasures){
            if ($Count -gt 40){
                "</div>"
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
        "\page"

        "# Names"
        Foreach ($NameType in $InputObject.NameVariants){
            "### $($NameType.NameType.ToUpper())"
            "$($NameType.names[0..9].trim() -join(", "))"
        }
        "\page"
        
        "<div class=`'wide`'>"
        "# Panic Locations"
        Foreach ($Location in $InputObject.PanicLocations){
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
        "\page"

        $count = 1
        "<div class=`'wide`'>"
        "# Vendors"
        foreach ($shop in $($InputObject.Vendors)){
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
                "\page"
                "<div class=`'wide`'>"
            }
            $count++
        }
        "</div>"
        "\page"
        
        $Total = 0
        
        foreach ($Desc in $InputObject.Descriptions){                    
            if ($Desc.values -ne $null){
                $value = $(($desc.values) -replace("^0 |.*[\=\-][\=\-]+.*",''))
                $total += $value.length
                
                ""
                if ($total -gt 4500){
                    "\page"
                    $total = 0
                }

                "### $($desc.keys)"
                "$value"
            }
        }
    #     $InputObject.Prophecies
    #     $InputObject.Omens
    #     $InputObject.Graffiti
    #     $InputObject.SecretDoors
    #     $InputObject.Castles
    #     $InputObject.LegendaryItems
    #     $InputObject.Pockets
    #     $InputObject.Tomes
    #     $InputObject.Traps
    #     $InputObject.GiantBags
    #     $InputObject.PanicPlots
    #     $InputObject.Weather
    #     $InputObject.Inn | select Name,Location,Description,Keeper
    #     $InputObject.Menu
    #     $InputObject.Patrons
    #     $InputObject.Rumors
    #     $InputObject.ExtraMonsterKits.extramonsters
    # }
}