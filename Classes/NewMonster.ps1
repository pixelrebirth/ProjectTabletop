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
    [int]$MeleeFail
    [int]$RangedFail
    [int]$SpellFail
    
    hidden [int]$Str
    hidden [int]$Dex
    hidden [int]$Mind
    hidden [int]$ArmorBonus

    hidden $MeleeCMBase
    hidden $RangedCMBase
    hidden $SideArmCMBase
    hidden $SpellCMBase

    hidden [ValidateSet("Minor","Standard","Brutal","Elite","Superior")]$Type
    hidden [ValidateSet("Synergist","Defender","Support","Assasin","Sharpshooter","Generalist")]$Style

    NewMonster($level,$type,$style){
        $this.level = $level
        $this.SetType($type)

        $this.ArmorBonus = Get-Random -min 0 -max $([int]$this.level / 3)

        $this.hp = $this.level * 5
        $this.str = [int](3.34 + ($this.level * .34))
        $this.dex = [int](2.67 + ($this.level * .34))
        $this.mind =[int](3.0 + ($this.level * .34))

        $this.MeleeFail =  [math]::floor((30 - $this.Str) + $this.ArmorBonus)
        $this.RangedFail =  [math]::floor((30 - $this.Dex) + $this.ArmorBonus)
        $this.SpellFail =  [math]::floor((30 - $this.Mind) + $this.ArmorBonus)

        $this.SetStyle($style)

        $this.MD = $this.MD + $this.str + $this.ArmorBonus
        $this.RD = $this.RD + $this.dex + $this.ArmorBonus
        $this.SD = $this.SD + $this.mind + $this.ArmorBonus

        $this.SideArmCMBase = ($this.str) + $this.SideArmCMBase - 4
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
            "Synergist" {
                $this.Str = $this.Str - 2
                $this.Dex = $this.Dex - 2
                $this.Mind = $this.Mind + 4
            }
            "Defender" {
                $this.MD = $this.MD +5
                $this.RD = $this.RD +5
                $this.SD = $this.SD +5
                $this.HP = $this.HP +5
                $this.MeleeCMBase = $this.MeleeCMBase -5
                $this.SideArmCMBase = $this.SideArmCMBase -5
                $this.RangedCMBase = $this.RangedCMBase -5
                $this.SpellCMBase = $this.SpellCMBase -5
            }
            "Support" {
                $this.Dex = $this.Dex + 2
                $this.Mind = $this.Mind + 2
                $this.Str = $this.Str - 4
            }
            "Sharpshooter" {
                [int]$this.HP = $this.HP *.5
                $this.RangedCMBase = $this.RangedCMBase + ([math]::floor($this.level))
                $this.RangedFail = $this.RangedFail - ([math]::floor($this.level))
            }
            "Assasin" {
                [int]$this.HP = $this.HP *.5
                $this.MeleeCMBase = $this.MeleeCMBase + ([math]::floor($this.level))
                $this.MeleeFail = $this.MeleeFail - ([math]::floor($this.level))
            }
            "Generalist" {}
        }

        if ($this.MeleeFail -lt 0){$this.MeleeFail = 0}
        if ($this.RangedFail -lt 0){$this.RangedFail = 0}
        if ($this.SpellFail -lt 0){$this.SpellFail = 0}
    }
}

