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
    [ValidateSet("Synergist","Defender","Support","Assasin","Sharpshooter","Generalist")]$Style

    NewMonster($level,$type,$style){
        $this.level = $level
        $this.SetType($type)
        
        $this.ArmorBonus = 0# Get-Random -min 0 -max $([int]$this.level / 2)

        $this.hp = $this.level * 4
        $this.str = [int](3.34 + ($this.level * .34))
        $this.dex = [int](2.67 + ($this.level * .34))
        $this.mind =[int](3.0 + ($this.level * .34))

        $this.MeleeFail =  [math]::floor((30 - $this.Str) + $this.ArmorBonus)
        $this.RangedFail =  [math]::floor((30 - $this.Dex) + $this.ArmorBonus)
        $this.SpellFail =  [math]::floor((30 - $this.Mind) + $this.ArmorBonus)
        
        $this.SetStyle($style)
        
        $this.MR = $this.MR + $this.Str + $this.ArmorBonus
        $this.RR = $this.RR + $this.Dex + $this.ArmorBonus
        $this.SR = $this.SR + $this.Mind * 2
        
        $this.SideArmCMBase = $this.SideArmCMBase + $this.str - 4
        $this.MeleeCMBase = $this.MeleeCMBase + $this.str
        $this.RangedCMBase = $this.RangedCMBase + $this.dex

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
                "Minor" {-2}
                "Standard" {0}
                "Brutal" {1}
                "Elite" {3}
                "Superior" {5}
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
                $this.MR = +5
                $this.RR = +5
                $this.SR = +5
                $this.HP = +5
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
    }
}

