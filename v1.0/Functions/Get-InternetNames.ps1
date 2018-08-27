function Get-InternetNames {
    $Categories = Get-Content $PSScriptRoot/../data/NameGenCategories.txt
    try {
        foreach ($Category in $Categories){
            [Names]::new($Category)
        }
    }
    catch {"Error accessing servers..."}
}