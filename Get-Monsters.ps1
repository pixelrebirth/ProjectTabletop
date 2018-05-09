param (
    [int]$PartyLevel = 10,
    [string]$CreatureType,
    [decimal]$MinCR = 1,
    [decimal]$MaxCR = 5,
    [int]$MaxUnique = 3,
    [int]$HD
)

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
if ($HD -ne $Null -and $HD -ne ""){
    $Response = Invoke-WebRequest -uri "https://donjon.bin.sh/m20/monster/rpc.cgi?HD=$HD&n=$MaxUnique"
    $CMModified = Measure-CombatModifier ($Response.content -split('","',"") -replace("\[|\]|`"",""))
    return $CMModified
}

$content = Get-Content $PSScriptRoot\Data\DndMicroliteMonsters.txt
$AllCreatures = New-Object -typename System.Collections.ArrayList
foreach ($row in $content) {
    $row -match "(.*) - (.*) Hit Dice: .*d \((\d)\) Speed: (.*) AC: (.*).* Attack\/Damage: (.*) Special Attacks: (.*) Special Qualities: (.*) Abilities: STR(.*), DEX(.*), MIND(.*) Skills: (.*) CR: (\.\d+|\d+)(.*)|(.*) - (.*) Hit Dice: .* \((.*)\) Speed: (.*) AC: (\d+).*Damage: (.*) Special Attacks: (.*) Special Qualities: (.*) Abilities: STR(.*), DEX(.*), MIND(.*) Skills: all @ (.*) CR: (\.\d+|\d+) (.*)" | Out-Null
    $CurrentCreature = [PSCustomObject]@{
        Name = $Matches[15]
        Type = $Matches[16]
        HP = $Matches[17] -replace("hp","")
        Speed = $Matches[18]
        AC = $Matches[19]
        DamageOld = $Matches[20]
        DamageCM = Measure-CombatModifier -Damage $Matches[20]
        SpecialAttacks = $Matches[21]
        SpecialQualities = $Matches[22]
        STR = $Matches[23]
        DEX = $Matches[24]
        MIND = $Matches[25]
        Skills = $Matches[26]
        CR = [decimal]$Matches[27]
        Notes = $Matches[28]
        Image = if ((ls "$PSScriptRoot\Data\Images\$($Matches[15]).jpg" -ea 0) -ne $null){"$PSScriptRoot\Data\Images\$($Matches[15]).jpg"} else {"NaN"}
    }
    $AllCreatures.add($CurrentCreature) | Out-Null
}
$MonsterMatch = ""
$MonsterCRTotal = 0
$OutputList = New-Object -typename System.Collections.ArrayList
$Attempt = 0

while ($MonsterCRTotal -lt $PartyLevel -OR $MonsterCRTotal -gt $PartyLevel){
    $UniqueCount = ($OutputList.name | select-object -unique).count
    if ($UniqueCount -gt $MaxUnique){
        Write-Verbose "Unique Failure :: $($OutputList.count) creatures and CR $MonsterCRTotal"
        $MonsterMatch = ""
        $MonsterCRTotal = 0
        $OutputList = New-Object -typename System.Collections.ArrayList
        $Attempt = 0
    }

    if ($MonsterCRTotal -gt $PartyLevel){
        Write-Verbose "OverCR Failure :: $($OutputList.count) creatures and CR $MonsterCRTotal"
        $MonsterMatch = ""
        $MonsterCRTotal = 0
        $OutputList = New-Object -typename System.Collections.ArrayList
        $Attempt = 0
    }
    $CRRemaining = $PartyLevel - $MonsterCRTotal
    if ($UniqueCount -eq $MaxUnique -AND $MonsterMatch -eq ""){
        foreach ($MonsterName in $($OutputList.name)){
            $MonsterMatch = $MonsterMatch + "$MonsterName|"
        }
        $MonsterMatch = $MonsterMatch -replace("\|$","")
        $ProperCR = $AllCreatures | where {$_.name -match "$MonsterMatch"}
    }
    if ($UniqueCount -lt $MaxUnique) {
        $Filter = {$_.CR -le $CRRemaining -and $_.Type -match "$CreatureType" -and $_.CR -le $MaxCR -and $_.CR -gt $MinCR}
        $ProperCR = $AllCreatures | where $Filter
    }
    if ($ProperCR -eq $Null){break}

    $CreatureCount = $ProperCR.count
    $RandomNumber = Get-Random -min 0 -max $CreatureCount
    $CurrentChoice = $ProperCR[$RandomNumber]
    
    $MonsterCRTotal = $MonsterCRTotal + $CurrentChoice.CR
    $OutputList.add($CurrentChoice) | Out-Null
    $Attempt++
    
    if ($Attempt -gt 100){
        Write-Verbose "Attempt Failure :: Loosen Parameters :: $($OutputList.count) creatures and CR $MonsterCRTotal"
        $fail = $true
        break
    }
}
if ($Fail -ne $true){
    Write-Verbose "Attempt Success :: $($OutputList.count) creatures and CR $MonsterCRTotal"
    return $OutputList
}