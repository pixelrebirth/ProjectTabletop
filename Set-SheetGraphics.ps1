$ps = New-Object -ComObject Photoshop.Application
$ps.Open('$PSScriptRoot\data\NanoLite20.psd')
$import = import-csv .\data\PhotoshopFormat.txt
$import.hp = 288
$import | export-csv e:\temp\PSImport.csv
$import | export-clixml "$PSScriptRoot\data\saves\PC-$($import.CharacterName).xml"
$ps.DoAction('Apply-Dataset', 'Default Actions')
$ps.DoAction('Save-Temp-PNG', 'Default Actions')
# Move item from temp folder to web server