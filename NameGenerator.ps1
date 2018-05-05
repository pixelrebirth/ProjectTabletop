$get = invoke-webrequest https://www.fantasynamegen.com/titles/medium
($get.ParsedHtml.body.outerText -split("\n") | where {$_ -match "\<name\> "}) -replace("\<name\>  ","")
(($get.ParsedHtml.body.outerText) -split("\n") | ? {$_.length -lt 20 -and $_ -notmatch "tweet"})