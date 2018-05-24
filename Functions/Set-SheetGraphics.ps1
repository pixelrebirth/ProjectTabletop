function Set-SheetGraphics {
    [cmdletbinding()]
    param()

    begin {    
        $FilePath = "$($PSScriptRoot)\..\data\NanoLite20.psd"

        $photoshop = New-Object -ComObject Photoshop.Application
        $photoshop.Open($FilePath)
        $photoshop.visible = $true
        start-sleep 3
    }

    process {
        $photoshop.DoAction('Apply-Dataset', 'Default Actions')
        start-sleep 2

        $photoshop.DoAction('Save-To-Temp-PNG', 'Default Actions')
    }
}