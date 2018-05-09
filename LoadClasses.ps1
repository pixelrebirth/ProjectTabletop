$allClasses = ls $PSScriptRoot/Classes
$allClasses | foreach {. $_.fullname}

$allFunctions = ls $PSScriptRoot/Functions
$allFunctions | foreach {. $_.fullname}