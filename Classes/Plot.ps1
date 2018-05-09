class Plot {
    $Title
    $Summary
    $Twist
    $AdaptedTo
    $Tags
    
    Plot () {
        $Plots = Get-Content $PSScriptRoot\..\Data\PanicPlots.txt
        $Random = Get-Random -Min 0 -Maximum $Plots.count
        $Choice = $Plots[$Random].split(";")
        $this.Title = $Choice[0]
        $this.Summary = $Choice[1]
        $this.Twist = $Choice[2]
    }

    Plot ($PlotType,$TagsFilter,$AdaptedToFilter) {
        $FileContent = Get-Content -path $PSScriptRoot/../data/plots/$($PlotType).txt
        $ParsedContent = ($FileContent) -split('\=\=') | where {$_ -match "Tags:.*$TagsFilter.*$" -and $_ -match "Easily adapted to:.*$AdaptedToFilter.*\*Tags:"}
        $RandomNumber = Get-Random -min 0 -max ($ParsedContent.count)
        $SelectChoice = ($ParsedContent[$RandomNumber].split("*")) -split("\.|\!|\?")

        $this.Title = $SelectChoice[0] 
        $this.AdaptedTo = ($SelectChoice[-2]) -replace("Easily adapted to: ","")
        $this.Tags = ($SelectChoice[-1]) -replace("Tags: \(.*\) ","")
        $this.Summary = $SelectChoice[1..$($SelectChoice.count - 3)]
    }
}