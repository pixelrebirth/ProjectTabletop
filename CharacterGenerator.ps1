param(
    [ValidateSet("Fantasy","Modern","SciFI")]$Genre,
    [ValidateSet("Villains","Neutrals","Allies")]$Alignment,
    [ValidateSet("MetAlready","Memorable","Forgettable")]$Stature = "Memorable",
    $Traits,
    [switch]$LoggingOff
)

$rawNPC = New-Object System.Collections.ArrayList
$SelectedFiles = Get-ChildItem .\NPCRaw | where name -match "$genre-$alignment"
foreach ($file in $SelectedFiles){
    $Content = Get-Content .\NPCRaw\$file
    $rawNPC.add($Content) | Out-Null
}
$joinedNPC = ($rawNPC) -join("")

$NpcList = New-Object System.Collections.ArrayList
if ($Stature -eq "Memorable"){
    foreach ($npc in $joinedNPC.split('*')){
        $npc -match '^=(.*)=(.*)="(.*)"=Appearance: (.*)=Roleplaying: (.*)=Personality: (.*)=Motivation: (.*)=Background: (.*)=Traits: (.*)=' | Out-Null
        $CurrentNpc = [PSCustomObject]@{
            Name = $matches[1]
            Title = $matches[2]
            Quote = $matches[3]
            Appearance = $matches[4]
            Roleplaying = $matches[5]
            Personality = $matches[6]
            Motivation = $matches[7]
            Background = $matches[8]
            Traits = $matches[9] -replace ("=.*|\(\w+\) ","")
            GameNotes = ""
        }
        if ($($CurrentNpc | Where Traits -match "$traits") -ne $null -AND $CurrentNpc.name -ne $null){
            $CurrentNpc.traits | out-file traits.txt -append
            $NpcList.add($CurrentNpc) | Out-Null
        }
    }
    $RandomDigit = Get-Random -Minimum 0 -Maximum $($NpcList.count + 1)
    $NpcList[$RandomDigit]
    if ($LoggingOff -eq $False){
        $NpcList[$RandomDigit] | Export-Clixml "./Logs/Memorable/$($NpcList.name).xml"
    }
    return $NpcList[$RandomDigit]
}


if ($Stature -eq "Forgettable"){
    $NPCs = import-clixml .\quickNPCs.xml
    $RandomNumber = Get-Random -Minimum 0 -Maximum $($NPCs.count + 1)
    $SplitNpc = ($NPCs[$RandomNumber]) -split('\. |: ')
    $NpcOutput = [PSCustomObject]@{
        Name = $SplitNpc[0]
        Class = $SplitNpc[1]
        Stats = $SplitNpc[2]
        Appearance = $SplitNpc[3]
        Equipment = $SplitNpc[4]
        Trait = $SplitNpc[5]
    }

    if ($LoggingOff -eq $False){
        $NpcOutput | Export-Clixml "./Logs/Forgettable/$($NpcOutput.Name).xml"
    }
    return $NpcOutput
}