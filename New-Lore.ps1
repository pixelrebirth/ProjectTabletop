param(
    [parameter(Mandatory=$true)][string]$SearchTerm,
    [switch]$RandomLore
)

. ./LoadClasses.ps1
if ($RandomLore -eq $false){
    try {[Lore]::new($SearchTerm)}
    catch {Write-Error "Cannot find `'$SearchTerm`' in the EberronHistory.txt : $($error[0].exception.message)"}
}
else {
    [Lore]::new()
}