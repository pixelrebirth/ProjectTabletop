$Plots = Get-Content $PSScriptRoot\Data\PanicPlots.txt
$Random = Get-Random -Min 0 -Maximum $Plots.count
$Choice = $Plots[$Random].split(";")
$PSObject = [PSCustomObject]@{
    Title = $Choice[0]
    Summary = $Choice[1]
    Twist = $Choice[2]
}

return $PSObject