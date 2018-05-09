class Inn {
    $Name
    $Location
    $Description
    $Keeper
    $Menu
    $Patrons
    $Rumors

    Inn ($InnType,$PatronType) {
        $uri = 'https://donjon.bin.sh/fantasy/random/rpc.cgi?type='
        $pattern = '\[|\]|"'

        $this.name = (Invoke-WebRequest -Uri "$uri$InnType+Inn+Name&n=1") -replace($pattern,'') 
        $this.location = (Invoke-WebRequest -Uri "$uri$InnType+Inn+Location&n=1") -replace($pattern,'') 
        $this.description = (Invoke-WebRequest -Uri "$uri$InnType+Inn+Description&n=1") -replace($pattern,'') 
        $this.keeper = (Invoke-WebRequest -Uri "$uri$InnType+Innkeeper&n=1") -replace($pattern,'') 
        $this.menu = (Invoke-WebRequest -Uri "$uri$InnType+Inn+Fare&n=10") -split('","') -replace($pattern,'') 
        $this.patrons = (Invoke-WebRequest -Uri "$uri`Inn+NPC&n=5&order=$PatronType") -split('","') -replace($pattern,'') 
        $this.rumors = (Invoke-WebRequest -Uri "$uri$InnType+Inn+Rumor&n=3") -split('","') -replace($pattern,'') 
    }
}
