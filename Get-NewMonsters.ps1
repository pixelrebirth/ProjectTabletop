[cmdletbinding()]
param(
    $Level = 3,
    [ValidateSet("Minor","Standard","Brutal","Elite","Superior")]$Type,
    [ValidateSet("Synergist","Defender","Support","Assasin","Sharpshooter","Generalist")]$Style
)
. ./LoadClasses.ps1

$TypeArray = "Minor","Standard","Brutal","Elite","Superior"
$StyleArray = "Synergist","Defender","Support","Assasin","Sharpshooter","Generalist"

if (!$Type){$Type = $TypeArray[$(Get-Random -min 0 -max $TypeArray.count)]}
if (!$Style){$Style = $StyleArray[$(Get-Random -min 0 -max $StyleArray.count)]}

$Monster = [NewMonster]::new($level,$type,$style)
return $Monster