function Get-DiceRollPerInteger {
    param ([int]$integer)
    if (($integer - 1) -lt 0){return '1d4'}
    return (Get-Content -Path ./data/DiceRollsBySize.txt)[$($integer - 1)]
}