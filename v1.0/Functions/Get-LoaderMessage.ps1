function Get-LoaderMessage {
    if ($global:loadcount -eq 0){
        cls
        $Global:loadcount = 0
        $Global:SimCity = Get-Content $PSScriptRoot/../data/SimCityLoading.txt
    }

    if ($global:loadcount -lt 130){
        $string = "Testing RAM..........OK`nTesting CPU..........OK`nTesting Disk.........OK`nTesting Patience...FAIL`n`nERROR: OUT OF PATIENCE!`n`n"
        write-host "$($string[$global:loadcount])" -NoNewline
    }
    $global:loadcount++
    
    if ($global:loadcount -gt 122){
        $Random = Get-Random -Min 0 -Max $Global:SimCity.count
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
        Write-Host -ForegroundColor $ColorChoice "$($Global:SimCity[$Random])..."
    }
}