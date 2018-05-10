function Get-SimCityLoading {
    $SimCity = Get-Content $PSScriptRoot/../data/SimCityLoading.txt
    $Random = Get-Random -Min 0 -Max $SimCity.count
    $Colors = @(
        "Black",
        "DarkBlue",
        "DarkGreen",
        "DarkCyan",
        "DarkRed",
        "DarkMagenta",
        "DarkYellow",
        "Gray",
        "DarkGray",
        "Blue",
        "Green",
        "Cyan",
        "Red",
        "Magenta",
        "Yellow",
        "White"
    )
    $RandomColor = Get-Random -min 0 -max $Colors.Count
    $ColorChoice = $colors[$RandomColor]
    Write-Host -ForegroundColor $ColorChoice "$($SimCity[$Random])..."
}