function Test-PEScriptModule {
    <#
    .SYNOPSIS
    Test the PEScriptModule with a function.

    .NOTES
    David Segura
    #>
    param (
        [Parameter(Mandatory = $false)]
        # Parameter used to test the function.
        [string]$Name
    )
    
    if ($Name) {
        Write-Host "[$(Get-Date -format G)][$($MyInvocation.MyCommand)] Testing the function with the name $Name."
    } else {
        Write-Host "[$(Get-Date -format G)][$($MyInvocation.MyCommand)] Testing the function."
    }
}