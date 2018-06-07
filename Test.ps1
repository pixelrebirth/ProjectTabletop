. ./loadclasses.ps1

$Get = Import-CliXml ./data/saves/level-3-636638270094392733.xml
Export-DungeonMasterSheet -BlobData $Get | Set-Clipboard