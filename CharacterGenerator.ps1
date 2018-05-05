[CmdletBinding()]
param(
    [ValidateSet("Fantasy","Modern","SciFI")]$Genre,
    [ValidateSet("Villains","Neutrals","Allies")]$Alignment,
    [ValidateSet("MetAlready","Memorable","Forgettable")]$Stature = "Memorable",
    [Parameter(Mandatory=$true)]$Level
)

DynamicParam {
    [Scriptblock]$ScriptBlock = {((Get-Content $PSScriptRoot\Data\Traits.txt) -split(",")).trim().tolower() | sort -unique}
    return ./Functions/Get-DynamicParam.ps1 -ParamName Trait -ParamCode $ScriptBlock
}

begin {
    $Trait = $PsBoundParameters['Trait']
    . $PSScriptRoot/Classes/EberronCharacter.ps1
}

process {
    $rawNPC = New-Object System.Collections.ArrayList
    $SelectedFiles = Get-ChildItem $PSScriptRoot\Data\NPCRaw | where name -match "$genre-$alignment"
    foreach ($file in $SelectedFiles){
        $Content = Get-Content $PSScriptRoot\Data\NPCRaw\$file
        $rawNPC.add($Content) | Out-Null
    }
    $joinedNPC = ($rawNPC) -join("")
    $CharacterSheet = [EberronCharacter]::new($Level)

    $NpcList = New-Object System.Collections.ArrayList
    if ($Stature -eq "Memorable"){
        $null | Out-File "$PSScriptRoot\Data\traits.txt"
        foreach ($npc in $joinedNPC.split('*')){
            $npc -match '^=(.*)=(.*)="(.*)"=Appearance: (.*)=Roleplaying: (.*)=Personality: (.*)=Motivation: (.*)=Background: (.*)=Traits: (.*)=' | Out-Null
            $CurrentNpc = [PSCustomObject]@{
                Name = $matches[1]
                Level = $CharacterSheet.Level
                Title = $matches[2]
                Race = $CharacterSheet.Race
                Class = $CharacterSheet.Class
                Attack = $CharacterSheet.Attack
                Vitals = "HP: $($CharacterSheet.HP), AC: $($CharacterSheet.AC)"
                Stats = "StrMod: $($CharacterSheet.StrMod), DexMod: $($CharacterSheet.DexMod), MindMod: $($CharacterSheet.MindMod), | Phys: $($CharacterSheet.Phys), Sub: $($CharacterSheet.Sub), Know: $($CharacterSheet.Know), Comm: $($CharacterSheet.Comm), Surv: $($CharacterSheet.Surv)"
                Quote = $matches[3]
                Appearance = $matches[4]
                Roleplaying = $matches[5]
                Personality = $matches[6]
                Motivation = $matches[7]
                Background = $matches[8]
                Traits = $matches[9] -replace ("=.*|\(\w+\) ","")
                CharacterSheet = $CharacterSheet
                GameNotes = ""
            }
            if ($($CurrentNpc | Where Traits -match "$trait") -ne $null -AND $CurrentNpc.name -ne $null){
                $CurrentNpc.traits | Out-File "$PSScriptRoot\Data\traits.txt" -append
                $NpcList.add($CurrentNpc) | Out-Null
            }
        }
        $RandomDigit = Get-Random -Minimum 0 -Maximum $($NpcList.count + 1)
        return $NpcList[$RandomDigit]
    }


    if ($Stature -eq "Forgettable"){
        $NPCs = import-clixml $PSScriptRoot\Data\quickNPCs.xml
        $RandomNumber = Get-Random -Minimum 0 -Maximum $($NPCs.count + 1)
        $SplitNpc = ($NPCs[$RandomNumber]) -split('\. |: ')
        $NpcOutput = [PSCustomObject]@{
            Name = $SplitNpc[0]
            Race = $CharacterSheet.Race
            Class = $CharacterSheet.Class
            Level = $CharacterSheet.Level
            Attack = $CharacterSheet.Attack
            Vitals = "HP: $($CharacterSheet.HP), AC: $($CharacterSheet.AC)"
            Stats = "StrMod: $($CharacterSheet.StrMod), DexMod: $($CharacterSheet.DexMod), MindMod: $($CharacterSheet.MindMod), | Phys: $($CharacterSheet.Phys), Sub: $($CharacterSheet.Sub), Know: $($CharacterSheet.Know), Comm: $($CharacterSheet.Comm), Surv: $($CharacterSheet.Surv)"        
            Appearance = $SplitNpc[3]
            Trait = $SplitNpc[5]
            CharacterSheet = [EberronCharacter]::new($Level)
        }
        return $NpcOutput
    }
}

end {}