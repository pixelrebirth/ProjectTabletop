$Giants = @("Hill","Stone","Frost","Fire","Cloud","Storm")
$Random = Get-Random -Min 0 -Max $Giants.Count

$RandomGiant = $Giants[$Random]
return (Invoke-WebRequest "https://donjon.bin.sh/fantasy/random/rpc.cgi?type=Giant+Bag&giant_type=$RandomGiant+Giant&n=1").content  -split('","') -replace('\[|\]|"','')