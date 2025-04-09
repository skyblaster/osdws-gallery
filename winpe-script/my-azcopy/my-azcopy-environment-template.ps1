function Step-SetAzCopyEnvironmentVariables {
    [CmdletBinding()]
    param (
        [System.String]
        $MountPath = $global:BuildMedia.MountPath
    )
    #=================================================
    $Error.Clear()
    Write-Verbose "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand)] Start"
    #=================================================
    Write-Verbose "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand)] Architecture: $Architecture"
    Write-Verbose "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand)] MountPath: $MountPath"
    Write-Verbose "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand)] WinPEAppsPath: $WinPEAppsPath"
    #=================================================
    $InfContent = @'
[Version]
Signature   = "$WINDOWS NT$"
Class       = System
ClassGuid   = {4D36E97d-E325-11CE-BFC1-08002BE10318}
Provider    = OSDeploy
DriverVer   = 03/14/2025,2025.03.14.0

[DefaultInstall] 
AddReg      = AddReg 

[AddReg]
;rootkey,[subkey],[value],[flags],[data]
;0x00000    REG_SZ
;0x00001    REG_BINARY
;0x10000    REG_MULTI_SZ
;0x20000    REG_EXPAND_SZ
;0x10001    REG_DWORD
;0x20001    REG_NONE
;
; https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-authorize-azure-active-directory
;
; AZCOPY_TENANT_ID
; The Microsoft Entra tenant (directory) ID.
HKLM,"SYSTEM\ControlSet001\Control\Session Manager\Environment",AZCOPY_TENANT_ID,0x00000,"00000000-0000-0000-0000-000000000000"
;
; AZCOPY_SPA_APPLICATION_ID
; The client (application) ID of an App Registration in the tenant.
HKLM,"SYSTEM\ControlSet001\Control\Session Manager\Environment",AZCOPY_SPA_APPLICATION_ID,0x00000,"00000000-0000-0000-0000-000000000000"
;
; AZCOPY_SPA_CLIENT_SECRET
; A client secret that was generated for the App Registration.
HKLM,"SYSTEM\ControlSet001\Control\Session Manager\Environment",AZCOPY_SPA_CLIENT_SECRET,0x00000,"YourClientSecretHere"
;
HKLM,"SYSTEM\ControlSet001\Control\Session Manager\Environment",AZCOPY_AUTO_LOGIN_TYPE,0x00000,"SPN"
HKLM,"SYSTEM\ControlSet001\Control\Session Manager\Environment",AZCOPY_CONTAINER,0x00000,"https://example.blob.core.windows.net/container"
'@
    #=================================================
    # https://learn.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme?view=azure-dotnet#environment-variables

    #   Build Driver
    #=================================================
    $InfFile = "$env:Temp\Set-AzCopyEnvironmentVariables.inf"
    New-Item -Path $InfFile -Force
    Set-Content -Path $InfFile -Value $InfContent -Encoding Unicode -Force
    #=================================================
    #   Add Driver
    #=================================================
    Add-WindowsDriver -Path $MountPath -Driver $InfFile -ForceUnsigned
    #=================================================
    Write-Verbose "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand)] End"
    #=================================================
}

Step-SetAzCopyEnvironmentVariables