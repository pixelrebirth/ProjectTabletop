
class Weather {
    $Weather
    $Effect
}

$Weathers = Get-Content $PSScriptRoot/data/weather.txt
$Random = Get-Random -min 0 -max $Weathers.count
$SelectedWeather = [weather]::new()
$RandomWeather = ($Weathers[$Random]) -split(":")
$SelectedWeather.weather = $RandomWeather[0]
$SelectedWeather.Effect = $RandomWeather[1]

return $SelectedWeather