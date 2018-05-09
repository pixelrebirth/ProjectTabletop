function Measure-CombatModifier {
    param($damage)
    $LineOutput = New-Object -TypeName System.Collections.ArrayList
    foreach ($DmgLine in ($Damage -split(' and | or '))){
        if ($DmgLine -match "(.*) \+(\d+) \((.*)\+(\d+)(.*)\)"){
            $Weapon = "$($matches[1]): $($matches[3])+$([int]$matches[2] + [int]$matches[4])$($matches[5])"
        }
        elseif ($DmgLine -match "(.*) \+(\d+) \((\d+d\d+)(.*)$"){
            $Weapon = "$($matches[1]): $($matches[3])+$([int]$matches[2])$($matches[4])"
        }
        $LineOutput.add($Weapon) | Out-Null
    }
    foreach ($line in $LineOutput){
        [string]$Output += "$line, "
    }
    return [string]$Output -replace(", $|\)$","$")
}