. ./loadclasses.ps1

$Get = Import-CliXml ./data/saves/level-3-636628455341009772.xml
Export-DungeonMasterSheet -BlobData $Get | Set-Clipboard