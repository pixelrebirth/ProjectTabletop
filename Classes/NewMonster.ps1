class NewMonster {
    $Name
    [int]$Level
    $HP
    $MR
    $RR
    $SR
    $MeleeCM
    $RangedCM
    $SideArmCM
    $SpellCM
    $Str
    $Dex
    $Mind
    $MeleeFail
    $RangedFail
    $SpellFail
    $ArmorBonus

    hidden $MeleeCMBase
    hidden $RangedCMBase
    hidden $SideArmCMBase
    hidden $SpellCMBase

    [ValidateSet("Minor","Standard","Brutal","Elite","Superior")]$Type
    [ValidateSet("Synergist","Defender","Support","Assasin","Sharpshooter","Multitalent")]$Style

    NewMonster($level,$type,$style){
        $this.level = $level
        $this.SetType($type)
        
        $this.ArmorBonus = Get-Random -min 0 -max 3

        $this.hp = $this.level * 3
        $this.str = [int](3.5 + ($this.level * .5))
        $this.dex = [int](2.5 + ($this.level * .5))
        $this.mind =[int](3.0 + ($this.level * .5))
        $this.MR = $this.Str + $this.ArmorBonus
        $this.RR = $this.Dex + $this.ArmorBonus
        $this.SR = $this.Mind * 2
        
        $this.SideArmCMBase = $this.str - 4
        $this.MeleeCMBase = $this.str
        $this.RangedCMBase = $this.dex
        
        $this.MeleeFail =  [math]::floor((25 - $this.Str) + $this.ArmorBonus)
        $this.RangedFail =  [math]::floor((25 - $this.Dex) + $this.ArmorBonus)
        $this.SpellFail =  [math]::floor((25 - $this.Mind) + $this.ArmorBonus)

        $this.SetStyle($style)

        $SideArmDmg = Get-DiceRollPerInteger -Integer $(($this.str) - 4)
        $MeleeDmg = Get-DiceRollPerInteger -Integer $($this.str)
        $RangedDmg = Get-DiceRollPerInteger -Integer $($this.dex)

        $this.SideArmCM = "$SideArmDmg+$($this.SideArmCMBase)"
        $this.MeleeCM = "$MeleeDmg+$($this.MeleeCMBase)"
        $this.RangedCM = "$RangedDmg+$($this.RangedCMBase)"
        $this.SpellCM = $this.Mind + $this.SpellCMBase

        $this.Name = "$type $style"
    }
    
    [void] SetType($type){
        $this.type = $type
        $this.level = $this.level + [int]$(
            switch ($type){
                "Minor" {-1}
                "Standard" {0}
                "Brutal" {1}
                "Elite" {2}
                "Superior" {3}
            }
        )
        if ($this.level -lt 0){$this.level = 1}
    }

    [void] SetStyle($style){
        $this.Style = $style
        switch ($style){
            "Synergist" {
                $this.Str = $this.Str -1
                $this.Dex = $this.Dex -2
                $this.Mind = $this.Mind +3
            }
            "Defender" {
                $this.MR = $this.MR +3
                $this.RR = $this.RR +3
                $this.SR = $this.SR +3
                $this.HP = $this.HP +3
                $this.MeleeCMBase = $this.MeleeCMBase -3
                $this.RangedCMBase = $this.RangedCMBase -3
                $this.SpellCMBase = $this.SpellCMBase -3
            }
            "Support" {
                $this.RangedCMBase = $this.RangedCMBase +3
                $this.SpellCMBase = $this.SpellCMBase +3
                $this.Dex = $this.Dex +2
                $this.Mind = $this.Mind +1
                $this.MeleeCMBase = $this.MeleeCMBase -10
                $this.Str = $this.Str -3
            }
            "Sharpshooter" {
                [int]$this.HP = $this.HP *.5
                $this.RangedCMBase = $this.RangedCMBase +3
                $this.RR = $this.RR -3
            }
            "Assasin" {
                [int]$this.HP = $this.HP *.5
                $this.MeleeCMBase = $this.MeleeCMBase +3
                $this.MR = $this.MR -3
            }
            "Multitalent" {
                $this.SpellFail = $this.SpellFail -5
                $this.MeleeFail = $this.MeleeFail -5
                $this.RangedFail = $this.RangedFail -5
            }
        }
    }
}

