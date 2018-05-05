param (
    [parameter(Mandatory=$true)]$type,
    [parameter(Mandatory=$true)][ValidateSet("short","medium","long")]$length
)

$get = invoke-webrequest https://www.fantasynamegen.com/$type/$length
($get.ParsedHtml.body.outerText -split("\n") | where {$_ -match "\<name\> "}) -replace("\<name\>  ","")
(($get.ParsedHtml.body.outerText) -split("\n") | ? {$_.length -lt 20 -and $_ -notmatch "tweet"})