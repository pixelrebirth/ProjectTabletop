param(
    [parameter(Mandatory=$true)][string]$SearchTerm,
    [switch]$RandomLore
)

if ($RandomLore -eq $false){
    try {[Lore]::new($SearchTerm)}
    catch {Write-Error "Cannot find `'$SearchTerm`' in the EberronHistory.txt"}
}
else {
    [Lore]::new()
}