function Test-PEModule {
    <#
    .SYNOPSIS
    Test the PEModule with a function.

    .NOTES
    David Segura
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        # Parameter used to test the function.
        [string]$Name
    )
    
    if ($Name) {
        Write-Host "[$(Get-Date -format G)][$($MyInvocation.MyCommand)] Testing the public function with the name $Name."
    } else {
        Write-Host "[$(Get-Date -format G)][$($MyInvocation.MyCommand)] Testing the public function."
    }

    Test-PEPrivateFunction
}