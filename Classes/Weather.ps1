
class Weather {
    $Weather
    $Effect

    Weather () {
        $Weathers = Get-Content $PSScriptRoot/data/weather.txt
        $Random = Get-Random -min 0 -max $Weathers.count
        $RandomWeather = ($Weathers[$Random]) -split(":")
        $this.weather = $RandomWeather[0]
        $this.Effect = $RandomWeather[1]
    }
}