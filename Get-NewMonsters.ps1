[cmdletbinding()]
param(
    $Level = 3
)
. ./LoadClasses.ps1

$TypeArray = "Minor","Standard","Brutal","Elite","Superior"
$StyleArray = "Synergist","Defender","Support","Assasin","Sharpshooter","Multitalent"

$Type = $TypeArray[$(Get-Random -min 0 -max $TypeArray.count)]
$Style = $StyleArray[$(Get-Random -min 0 -max $StyleArray.count)]

$Monster = [NewMonster]::new($level,$type,$style)
return $Monster