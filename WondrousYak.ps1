$level = 15
$get | foreach {
    $_ | where {$_ -match "CL: </b>(\d+).*<div><b>Description: </b>(.*)</div>"} | out-null
    if ([int]$matches[1] -le $level + 2 -AND [int]$matches[1] -ge $level - 2){
        $cr = $matches[1]
        $description = $matches[2]
        "CR: $cr"
        "DESC: $description"
    }
}