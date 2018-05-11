class Lore {
    $Source
    $Lore

    Lore () {
        $get = invoke-webrequest -uri "http://eberron.wikia.com/wiki/Special:Random"
        $this.Source = "Eberron Wikia"
        $this.Lore = ((($get.ParsedHtml.body.outertext) -split('\n')) | where {$_.length -gt 100})
    }

    Lore ($SearchTerm) {
        $get = Get-Content $PSScriptRoot\..\data\EberronHistory.txt
        $out = New-Object System.Collections.ArrayList
        $string = ""
        $count = 0
        $get | foreach {
            if (($count / 5) -is [int]){
                $string += $_
                $out.add($string)
                $string = ""
                $count = 0
            }
            else {
                $string += $_
            }
            $count++
        }
        $filtered = $out | where {$_ -match $SearchTerm} | select -unique
        $random = Get-Random -min 0 -max $filtered.count
    
        $this.Lore = $filtered[$random]
        $this.Source = "Eberron Histroy"
    }
}