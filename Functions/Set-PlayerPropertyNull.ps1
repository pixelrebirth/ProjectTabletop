function Set-PlayerPropertyNull {
    param ($PropName)

    if (!$PlayerCharacter."$PropName"){
        $PlayerCharacter."$PropName" = (Get-Variable "$PropName").Value | foreach {
            if ($_ -eq $null -or $_ -eq ''){
                . (Get-Variable "Script$PropName").Value | Sort {Get-Random} | select -first 1
            } else {
                $_
            }
        }
    }
}