function Test-PEPrivateFunction {
    <#
    .SYNOPSIS
    Test the PEModule with a private function.

    .NOTES
    David Segura
    #>
    [CmdletBinding()]
    param ()
    Write-Host "[$(Get-Date -format G)][$($MyInvocation.MyCommand)] Testing the private function."
}