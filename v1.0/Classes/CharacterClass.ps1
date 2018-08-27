class CharacterClass {
    [String]$ClassName
    [ValidatePattern('^\w+;\d+$')]$Bonuses
    [String]$DefiningTrait
    [String]$ClassHistory
    [String]$MaxArmor
    
    CharacterClass ($ClassName) {
        $GetClasses = Get-Content $PSScriptRoot\..\Data\EberronClasses.txt
        foreach ($eachClass in $GetClasses){
            if ($eachClass -match "^$ClassName,"){
                $GetParse = $eachClass.Split(',')
                $this.ClassName = $GetParse[0]
                $this.Bonuses = $GetParse[1]
                $this.MaxArmor = $GetParse[2]
                $this.DefiningTrait = $GetParse[3]
                $this.ClassHistory = $GetParse[4]
            }
        }
    }

    CharacterClass () {
        $GetClasses = Get-Content $PSScriptRoot\..\Data\EberronClasses.txt
        $Random = Get-Random -Min 0 -Max ($GetClasses.count)
        $eachClass = $GetClasses[$Random]

        $GetParse = $eachClass.Split(',')
        $this.ClassName = $GetParse[0]
        $this.Bonuses = $GetParse[1]
        $this.MaxArmor = $GetParse[2]
        $this.DefiningTrait = $GetParse[3]
        $this.ClassHistory = $GetParse[4]
    }
}