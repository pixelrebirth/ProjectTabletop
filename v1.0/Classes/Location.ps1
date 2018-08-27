class Location {
    $Name
    Location () {
       $Locations = Get-Content $PSScriptRoot/../data/EberronLocations.txt
       $Random = Get-Random -min 0 -max $Locations.count
       $this.name = $Locations[$Random]
    }
}