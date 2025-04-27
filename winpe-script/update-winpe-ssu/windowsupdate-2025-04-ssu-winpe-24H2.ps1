<#
Cumulative Update
Download the Cumulative Update(s) and extract the contents to the folder.
Copy any SSU*.cab files out of the folder and delete the folder.
#>
if ($Architecture -eq 'amd64') {
    $PackagePath = "$PSScriptRoot\$Architecture\SSU-26100.1738-x64.cab"
}
if ($Architecture -eq 'arm64') {
    $PackagePath = "$PSScriptRoot\$Architecture\SSU-26100.1738-arm64.cab"
}
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] $PackagePath"
Add-WindowsPackage -Path $MountPath -PackagePath $PackagePath -Verbose

if ($Architecture -eq 'amd64') {
    $PackagePath = "$PSScriptRoot\$Architecture\SSU-26100.3189-x64.cab"
}
if ($Architecture -eq 'arm64') {
    $PackagePath = "$PSScriptRoot\$Architecture\SSU-26100.3764-arm64.cab"
}
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] $PackagePath"
Add-WindowsPackage -Path $MountPath -PackagePath $PackagePath -Verbose

<#
Safe OS Dynamic Update
#>
if ($Architecture -eq 'amd64') {
    $PackagePath = "$PSScriptRoot\$Architecture\windows11.0-kb5053426-x64_c81b1c234490a57c701ded095d5e2955c1240bdc.cab"
}
if ($Architecture -eq 'arm64') {
    $PackagePath = "$PSScriptRoot\$Architecture\windows11.0-kb5055671-arm64.cab"
}

Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] $PackagePath"
Add-WindowsPackage -Path $MountPath -PackagePath $PackagePath -Verbose

<#
Setup Dynamic Update is not used for WinPE, but used for WinSE or Windows OS Media.
The following is left for reference.
This update is installed by the following command: expand.exe "$UpdateFullName" -F:*.* "$DestinationFullName"

Example Update for Reference:
96c19d3c-dd60-44c9-9538-a2ff94ba4d22
2025-01 Setup Dynamic Update for Windows 11 Version 24H2 for x64-based Systems (KB5050758)
https://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=96c19d3c-dd60-44c9-9538-a2ff94ba4d22
https://catalog.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/1b859623-4658-4a3a-934c-a001088ad261/public/windows11.0-kb5050758-x64_9c33ace3bfd87a4a086a147403fafde38291b89a.cab
#>