return (Invoke-WebRequest -uri 'https://donjon.bin.sh/m20/random/rpc.cgi?type=Level+1+Room+Trap&n=10').content  -split('","') -replace('\[|\]|"','') 