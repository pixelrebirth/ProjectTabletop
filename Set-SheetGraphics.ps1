[cmdletbinding()]
param(
    [parameter(ValueFromPipeline=$true)]$Path
)
begin {    
    $photoshop = New-Object -ComObject Photoshop.Application
    $photoshop.Open("$PSScriptRoot\data\NanoLite20.psd")
    $photoshop.visible = $false
}

process {
    $import = Import-CliXml -Path $Path -ErrorAction SilentlyContinue
    if ($import -eq $null){
        $import = Import-Csv $PSScriptRoot\data\PhotoshopFormat.txt
    }

    

    $import | Export-Csv $env:temp\PSImport.csv -NoTypeInformation -Force
    $import | Export-CliXml "$PSScriptRoot\data\saves\PC-$($import.CharacterName).xml"

    $photoshop.DoAction('Apply-Dataset', 'Default Actions')
    $photoshop.DoAction('Save-Temp-PNG', 'Default Actions')

    Move-Item $env:temp\PSExport.png "E:\www\charaters\$($import.name)"
}