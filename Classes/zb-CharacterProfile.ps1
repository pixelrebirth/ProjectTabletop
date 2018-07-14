class CharacterProfile {
    $Name
    $Level
    $Title
    $Race
    $Class
    $Attack
    $Vitals
    $Stats
    $Quote
    $Appearance
    $Roleplaying
    $Personality
    $Motivation
    $Background
    $Traits
    $CharacterSheet
    $GameNotes
    
    CharacterProfile ($Genre,$Alignment,$Stature,$Trait,$Level,$HPCalibration) {
        $Path = "$PSScriptRoot\..\Data\NPCRaw"
        $file = Get-ChildItem $Path | where {$_.name -match "$Genre-$Alignment"}
        $joinedNPC = Get-Content $Path\$file
        $this.CharacterSheet = [CharacterSheet]::new($Level,$HPCalibration)
        
        if ($Stature -eq "Memorable"){
            $NpcList = $joinedNPC.split('*') | where {$_ -match "^=.*Traits: .*$Trait"}
            if ($NpcList -eq $null){Write-Error "Cannot find Trait: $trait in NPC search." ; break}
            $RandomDigit = Get-Random -Minimum 0 -Maximum $($NpcList.count)
            $npc = $NpcList[$RandomDigit]
            $npc -match "^=(.*)=(.*)=`"(.*)`"=Appearance: (.*)=Roleplaying: (.*)=Personality: (.*)=Motivation: (.*)=Background: (.*)=Traits: (.*)=" | Out-Null

            $this.Name = $matches[1]
            $this.Level = $this.CharacterSheet.Level
            $this.Title = $matches[2]
            $this.Race = $this.CharacterSheet.Race
            $this.Class = $this.CharacterSheet.Class
            $this.Attack = $this.CharacterSheet.Attack
            $this.Vitals = "HP:$($this.CharacterSheet.HP), AC:$($this.CharacterSheet.AC), SR:$($this.CharacterSheet.SpellResist), SCM:$($this.CharacterSheet.SpellCM)"
            $this.Stats = "StrMod: $($this.CharacterSheet.StrMod), DexMod: $($this.CharacterSheet.DexMod), MindMod: $($this.CharacterSheet.MindMod), | Phys: $($this.CharacterSheet.Phys), Sub: $($this.CharacterSheet.Sub), Know: $($this.CharacterSheet.Know), Comm: $($this.CharacterSheet.Comm), Surv: $($this.CharacterSheet.Surv)"
            $this.Quote = $matches[3]
            $this.Appearance = $matches[4]
            $this.Roleplaying = $matches[5]
            $this.Personality = $matches[6]
            $this.Motivation = $matches[7]
            $this.Background = $matches[8]
            $this.Traits = $matches[9] -replace ("=.*|\(\w+\) ","")
            $this.CharacterSheet = $this.CharacterSheet
            $this.GameNotes = ""
        }


        if ($Stature -eq "Forgettable"){
            $NPCs = import-clixml $PSScriptRoot\..\Data\quickNPCs.xml
            $RandomNumber = Get-Random -Minimum 0 -Maximum $($NPCs.count + 1)
            $SplitNpc = ($NPCs[$RandomNumber]) -split('\. |: ')
            
            $this.Name = $SplitNpc[0]
            $this.Race = $this.CharacterSheet.Race
            $this.Class = $this.CharacterSheet.Class
            $this.Level = $this.CharacterSheet.Level
            $this.Attack = $this.CharacterSheet.Attack
            $this.Vitals = "HP:$($this.CharacterSheet.HP), AC:$($this.CharacterSheet.AC), SR:$($this.CharacterSheet.SpellResist), SCM:$($this.CharacterSheet.SpellCM)"
            $this.Stats = "StrMod: $($this.CharacterSheet.StrMod), DexMod: $($this.CharacterSheet.DexMod), MindMod: $($this.CharacterSheet.MindMod), | Phys: $($this.CharacterSheet.Phys), Sub: $($this.CharacterSheet.Sub), Know: $($this.CharacterSheet.Know), Comm: $($this.CharacterSheet.Comm), Surv: $($this.CharacterSheet.Surv)"        
            $this.Appearance = $SplitNpc[3]
            $this.Traits = $SplitNpc[5]
            $this.CharacterSheet = [CharacterSheet]::new($Level,$HPCalibration)
        }
    }
}