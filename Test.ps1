$get = Get-COntent .\data\EberronHistory.txt
$out = New-Object System.Collections.ArrayList
$string = ""
$count = 0
$get | foreach {
    if (($count / 4) -is [int]){
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
$filtered = $out | where {$_ -match 'Eberron'}
$random = Get-Random -min 0 -max $filtered.count
return $filtered[$random]
