$LegendaryWeapon = (Invoke-WebRequest 'https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Legendary+Weapon&n=3').content  -split('","') -replace('\[|\]|"','')
return $LegendaryWeapon