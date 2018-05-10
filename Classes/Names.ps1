class Names {
    $NameType
    $Names

    Names ($NameType) {
        $this.NameType = $NameType
        $get = invoke-webrequest https://www.fantasynamegen.com/$NameType/medium
        
        $this.Names = (($get.ParsedHtml.body.outerText) -split("\n") | where {$_.length -gt 3 -and $_.length -lt 20 -and $_ -notmatch "tweet"})
    }
}