[cmdletbinding()]
param(
    $Level = 3,
    [ValidateSet("Minor","Standard","Brutal","Elite","Superior")]$Type,
    [ValidateSet("Synergist","Defender","Assasin","Sharpshooter","Generalist")]$Style,
    [int]$Difficulty = 0,
    [switch]$Kit
)
. ./LoadClasses.ps1

$TypeArray = "Minor","Standard","Brutal","Elite","Superior"
$StyleArray = "Synergist","Defender","Assasin","Sharpshooter","Generalist"

if (!$Type){$Type = $TypeArray[$(Get-Random -min 0 -max $TypeArray.count)]}
if (!$Style){$Style = $StyleArray[$(Get-Random -min 0 -max $StyleArray.count)]}
$Monster = @()
if ($Kit){
    foreach ($Type in $TypeArray){
        foreach ($Style in $StyleArray){
            $Monster += [NewMonster]::new($level,$type,$style,$difficulty)
        }
    }
} else {
    $Monster += [NewMonster]::new($level,$type,$style,$difficulty)
}
return $Monster