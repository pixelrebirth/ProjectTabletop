function Get-DiceRollPerInteger {
    param ([int]$integer)
    return (Get-Content -Path ./data/DiceRollsBySize.txt)[$($integer - 1)]
}