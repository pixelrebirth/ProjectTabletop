param (
    [ValidateSet("all","fantasy","scifi","horror")]$PlotType = "all",
    $AdaptedToFilter,
    $TagsFilter
)

$content = get-content -path "$PSScriptRoot/plots/$($PlotType).txt"
$ParsedContent = ($content) -split('\=\=') | where {$_ -match "Tags:.*$TagsFilter.*$" -and $_ -match "Easily adapted to:.*$AdaptedToFilter.*\*Tags:"}
$RandomNumber = Get-Random -min 0 -max ($ParsedContent.count - 1)
$SelectChoice = ($ParsedContent[$RandomNumber].split("*")) -split("\.|\!|\?")
#logging, if not match name in the log file, continue else loop
$OutputObject = [PSCustomObject]@{
    Title = $SelectChoice[0] 
    AdaptedTo = $SelectChoice[-2]
    Tags = $SelectChoice[-1]
    ContentArray = $SelectChoice[1..$($SelectChoice.count - 3)]
}

Write-Host "$($OutputObject.Tags)`n-----:-----:-----" -foregroundcolor DarkCyan
Write-Host $($OutputObject.Title) -foregroundcolor Green
Write-Host $($OutputObject.AdaptedTo) -foregroundcolor DarkCyan
Write-Host "$($OutputObject.Tags)`n-----:-----:-----" -foregroundcolor DarkCyan
#Write would you like to continue prompt
foreach ($Sentence in $OutputObject.ContentArray){
    if ($Sentence -ne ""){
        Read-Host $Sentence
        #Write object logging and placement logging here
    }
}
return $OutputObject | Format-List