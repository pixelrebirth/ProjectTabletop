$allClasses = ls $PSScriptRoot/Classes
$allClasses | foreach {. $_.fullname}