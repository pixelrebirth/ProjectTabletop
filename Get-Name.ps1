param (
    $type = 'elf',
    [ValidateSet("short","medium","long")]$length = 'medium'
)

$get = invoke-webrequest https://www.fantasynamegen.com/$type/$length
($get.ParsedHtml.body.outerText -split("\n") | where {$_ -match "\<name\> "}) -replace("\<name\>  ","")
(($get.ParsedHtml.body.outerText) -split("\n") | where {$_.length -gt 3 -and $_.length -lt 20 -and $_ -notmatch "tweet"})