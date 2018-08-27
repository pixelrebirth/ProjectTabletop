class NewMonster {
    $Name
    [int]$Level
    [int]$HP
    [int]$MD
    [int]$RD
    [int]$SD
    $MeleeCM
    $RangedCM
    $SideArmCM
    $SpellCM

    hidden $ArmorBonus
    
    [int]$MeleeFail
    [int]$RangedFail
    [int]$SpellFail
    
    hidden [int]$Str
    hidden [int]$Dex
    [int]$Mind

    hidden $MeleeCMBase
    hidden $RangedCMBase
    hidden $SideArmCMBase
    hidden $SpellCMBase

    hidden [ValidateSet("Minor","Standard","Brutal","Elite","Superior")]$Type
    hidden [ValidateSet("Synergist","Defender","Support","Assasin","Sharpshooter","Generalist")]$Style

    NewMonster($level,$type,$style,$difficulty){
        $this.level = $level
        $this.SetType($type)
        $this.SetStyle($style)

        $this.hp = $this.level * 6
        $this.str = [int](3.34 + ($this.level * .34)) + $difficulty + $this.str 
        $this.dex = [int](2.67 + ($this.level * .34)) + $difficulty + $this.dex 
        $this.mind =[int](3.0 + ($this.level * .34)) + $difficulty + $this.mind 

        $this.MeleeFail =  [math]::floor((30 - $this.Str) + ($this.ArmorBonus) * 2)
        $this.RangedFail =  [math]::floor((30 - $this.Dex) + ($this.ArmorBonus) * 2)
        $this.SpellFail =  [math]::floor((30 - $this.Mind) + ($this.ArmorBonus) * 2)

        $this.MD = $this.str + $this.ArmorBonus
        $this.RD = $this.dex + $this.ArmorBonus
        $this.SD = $this.mind + $this.ArmorBonus

        $this.SideArmCMBase = ($this.str) + $this.MeleeCMBase - 4
        $this.MeleeCMBase = ($this.str) + $this.MeleeCMBase
        $this.RangedCMBase = ($this.dex) + $this.RangedBase
        $this.SpellCMBase = ($this.mind) + $this.SpellCMBase

        $SideArmDmg = Get-DiceRollPerInteger -Integer $(($this.str) - 4)
        $MeleeDmg = Get-DiceRollPerInteger -Integer $($this.str)
        $RangedDmg = Get-DiceRollPerInteger -Integer $($this.dex)
        $SpellDmg = Get-DiceRollPerInteger -Integer $($this.mind)

        $this.SideArmCM = "$SideArmDmg+$($this.SideArmCMBase)"
        $this.MeleeCM = "$MeleeDmg+$($this.MeleeCMBase)"
        $this.RangedCM = "$RangedDmg+$($this.RangedCMBase)"
        $this.SpellCM = "$SpellDmg+$($this.SpellCMBase)"

        $this.Name = "$type $style"
    }

    [void] SetType($type){
        $this.type = $type
        $this.level = $this.level + [int]$(
            switch ($type){
                "Minor" {$this.level * -.5}
                "Standard" {0}
                "Brutal" {$this.level * .25}
                "Elite" {$this.level * .5}
                "Superior" {$this.level * .75}
            }
        )
        if ($this.level -lt 0){$this.level = 1}
    }

    [void] SetStyle($style){
        $this.Style = $style
        switch ($style){
            "Sharpshooter" {
                $this.Str = $this.Str - 3
                $this.Dex = $this.Dex + 4
                $this.Mind = $this.Mind - 1
            }
            "Assasin" {
                $this.Str = $this.Str + 4
                $this.Dex = $this.Dex - 3
                $this.Mind = $this.Mind - 1
            }
            "Synergist" {
                $this.Str = $this.Str - 3
                $this.Dex = $this.Dex - 1
                $this.Mind = $this.Mind + 4
            }
            "Defender" {
                $this.ArmorBonus = [int]($this.level / 2)
            }
            "Generalist" {
                $difficulty += 1
            }
        }

        if ($this.MeleeFail -lt 0){$this.MeleeFail = 0}
        if ($this.RangedFail -lt 0){$this.RangedFail = 0}
        if ($this.SpellFail -lt 0){$this.SpellFail = 0}
    }
}

