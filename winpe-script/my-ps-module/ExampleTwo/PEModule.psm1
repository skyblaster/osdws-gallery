# Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue -Recurse )

#Dot source the files
foreach ($Import in @($Private + $Public)) {
    Try {
        . $Import.Fullname
    } Catch {
        Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
    }
}
Export-ModuleMember -Function $Public.BaseName