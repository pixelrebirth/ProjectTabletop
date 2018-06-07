param (
    [int]$PartyLevel = 10,
    [string]$CreatureType,
    [decimal]$MinCR = 1,
    [decimal]$MaxCR = 5,
    [int]$MaxUnique = 3,
    [int]$HD
)
. ./LoadClasses.ps1

if ($HD -ne $Null -and $HD -ne ""){
    $Response = Invoke-WebRequest -uri "https://donjon.bin.sh/m20/monster/rpc.cgi?HD=$HD&n=$MaxUnique"
    return $Response.content -split('","') -replace("\[|\]|`"","")
}

$content = Get-Content $PSScriptRoot\Data\DndMicroliteMonsters.txt
$AllCreatures = New-Object -typename System.Collections.ArrayList
foreach ($row in $content) {
    $row -match "(.*) - (.*) Hit Dice: .*d \((\d)\) Speed: (.*) AC: (.*).* Attack\/Damage: (.*) Special Attacks: (.*) Special Qualities: (.*) Abilities: STR(.*), DEX(.*), MIND(.*) Skills: (.*) CR: (\.\d+|\d+)(.*)|(.*) - (.*) Hit Dice: .* \((.*)\) Speed: (.*) AC: (\d+).*Damage: (.*) Special Attacks: (.*) Special Qualities: (.*) Abilities: STR(.*), DEX(.*), MIND(.*) Skills: all @ (.*) CR: (\.\d+|\d+) (.*)" | Out-Null
    
    $split = $matches[23] -split(" \(|\(")
    $str = $split[0]
    if ($split[1] -eq $null){
        $strmod = 0
    } else {    
        [int]$strmod = $split[1].replace(")","")
    }

    $split = $matches[24] -split(" \(|\(")
    $dex = $split[0]
    if ($split[1] -eq $null){
        $dexmod = 0
    } else {    
        [int]$dexmod = $split[1].replace(")","")
    }
    
    $split = $matches[25] -split(" \(|\(")
    $mind = $split[0]
    if ($split[1] -eq $null){
        $mindmod = 0
    } else {    
        [int]$mindmod = $split[1].replace(")","")
    }
        
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
        STR = $str
        DEX = $dex
        MIND = $mind
        STRmod = $strmod
        DEXmod = $dexmod
        MINDmod = $mindmod
        Skills = $Matches[26]
        CR = [decimal]$Matches[27]
        Notes = $Matches[28]
        Fortitude = $StrMod + $matches[26] + 7
        Reflex = $DexMod + $matches[26] + 7
        Will = $MindMod + $matches[26] + 7
        SpellDC = [decimal]$Matches[27] + $mindmod + 10
        Vitals = "HP:$($Matches[17] -replace("hp",'')), AC:$($Matches[19]), F:$($StrMod + $matches[26] + 10), R:$($DexMod + $matches[26] + 10), W:$($MindMod + $matches[26] + 10), SDC:$([decimal]$Matches[27] + $mindmod + 10)"
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