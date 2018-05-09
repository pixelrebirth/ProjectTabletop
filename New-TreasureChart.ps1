param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(2,20)]
    [int] $Level
)

begin {
    . ./LoadClasses.ps1
}
process {
    if ($level -ge 5){1..14 | % {($output = [treasure]::new($level-3)).DiceNumber = $_ ; $output}}
    if ($level -ge 4){15..29 | % {($output = [treasure]::new($level-2)).DiceNumber = $_ ; $output}}
    if ($level -ge 3){30..44 | % {($output = [treasure]::new($level-1)).DiceNumber = $_ ; $output}}
    if ($level -ge 2){45..59 | % {($output = [treasure]::new($level)).DiceNumber = $_ ; $output}}
    60..74 | % {($output = [treasure]::new($level+1)).DiceNumber = $_ ; $output}
    75..89 | % {($output = [treasure]::new($level+2)).DiceNumber = $_ ; $output}
    90..100 | % {($output = [treasure]::new($level+3)).DiceNumber = $_ ; $output}
}
end {

}