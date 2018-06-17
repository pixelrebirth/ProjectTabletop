$output = new-object system.collections.arraylist
1..10 | %{
    $number = $_
    @(4,6,8,10,12,20) | % {
        $here = "" | select dice,min,max
        $sides = $_
        "$number`d$sides = $number-$($number * $sides)"
        $here.dice = "$number`d$sides"
        $here.min = $number
        $here.max = $($number * $sides)
        $output.add($here)
    }
}
$output