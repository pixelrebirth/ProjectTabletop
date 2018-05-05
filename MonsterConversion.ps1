$Get = Get-Content ./Data/DndMicroliteMonsters.txt
foreach ($monster in $get){
    $splitmonster = $monster.split(' - ')
    $name = $splitmonster[0]
    $image = $splitmonster[1]

    # Invoke-WebRequest -uri $srd -OutFile ("./Data/MonsterSite/$name" + ".html")
    Invoke-WebRequest -uri $image -OutFile ("./Data/MonsterSite/tn_$name" + ".jpg")
}
Wait-Job * -Any