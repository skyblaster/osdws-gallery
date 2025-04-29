#Requires -RunAsAdministrator
#Requires -Module OSD
#Requires -Module OSDCloud
<#
    .NOTES
    The initial PowerShell commands should always contain the -WindowStyle Hidden parameter to prevent the PowerShell window from appearing on the screen.
	powershell, -WindowStyle Hidden -Command ...

	This will prevent PowerShell from rebooting since the window will not be visible.
	powershell, -WindowStyle Hidden -NoExit

	The final PowerShell command should contain the -NoExit parameter to keep the PowerShell window open and to prevent the WinPE environment from restarting.
	powershell, -NoExit -WindowStyle Hidden -Command ...

	Launch the On Screen Keyboard
	powershell, -WindowStyle Hidden -Command Invoke-WpeinitPSCommand Show-WinpeStartOSK -Run Asynchronous -WindowStyle Hidden
	[-Run Asynchronous] This command will run and continue to the next Winpeshl.ini command, without waiting for this command to finish.
	[-WindowStyle Hidden] The -WindowStyle Hidden hides the PowerShell window that launches the On Screen Keyboard.

	Hardware Devices with OK Status
	powershell, -WindowStyle Hidden -Command Invoke-WpeinitPSCommand Show-WinpeStartWindowHardware -Run Asynchronous -WindowStyle Minimized -NoExit
	[-Run Asynchronous] This command will run and continue to the next Winpeshl.ini command, without waiting for this command to finish.
	[-WindowStyle Minimized] The PowerShell window will open minimized, allowing the user to view if necessary.
	[-NoExit] The PowerShell window will persist until closed by the user.

	Hardware Devices without OK Status
	powershell, -WindowStyle Hidden -Command Invoke-WpeinitPSCommand Show-WinpeStartWindowHardwareErrors -Run Asynchronous -WindowStyle Maximized -NoExit
	[-Run Asynchronous] This command will run and continue to the next Winpeshl.ini command, without waiting for this command to finish.
	[-WindowStyle Maximized] The PowerShell window will open maximized to ensure visiblity of the Hardware information.
	[-NoExit] The PowerShell window will persist until closed by the user.

	Wireless Connectivity
	powershell, -WindowStyle Hidden -Command Invoke-WpeinitPSCommand Show-WinpeStartWindowWiFi -Run Synchronous
	[-Run Synchronous] Default. This command will run and wait for this command to finish before continuing to the next Winpeshl.ini command.

	Update OSD PowerShell
	powershell, -WindowStyle Hidden -Command Invoke-WpeinitUpdateModule -Name OSD
	[-Name OSD] Name of the PowerShell Module to update
	[-Run Synchronous] Default. This command will run and wait for this command to finish before continuing to the next Winpeshl.ini command.
	[-WindowStyle Normal] Default.

	powershell, -WindowStyle Hidden -NoExit -Command Invoke-WpeinitPSCommand Show-WinpeStartWindowDeviceInfo -NoExit
	[-Run Synchronous] Default. This command will run and wait for this command to finish before continuing to the next Winpeshl.ini command.
	[-NoExit] The PowerShell window will persist until closed by the user.

	Using the Winpeshl.ini file to launch the PowerShell script that will initialize the OSDCloud environment.

	Startup-OSD.xml is RunSynchronous with two entries, which means they run in order and the first must complete before the second starts.
	If the first entry must exit successfully (Exit 0) for the second entry to run.
	This means if you close it before it is finished, the second entry will not start.
	This Unattend is complete when all entries have finished.

	Startup-OSD2.xml is RunAsynchronous with two entries, which means they run at the same time.
	Since they are asynchronous, they will run regardless of the exit code of the previous entry.
	These entries will not keep WinPE from restarting automatically, so it doesn't matter if there is a -NoExit or -Wait parameter.
	This Unattend is complete when all entries have started.

	Wpeinit and Startnet.cmd: Using WinPE Startup Scripts
	https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeinit-and-startnetcmd-using-winpe-startup-scripts?view=windows-11
#>
#=================================================
#region Copy PowerShell Modules
$ModuleNames = @('OSD', 'OSDCloud')
$ModuleNames | ForEach-Object {
	$ModuleName = $_
	Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand.Source)] Copy PowerShell Module to BootImage: $ModuleName"
	# Add a step to install the latest
	Copy-PSModuleToWindowsImage -Name $ModuleName -Path $MountPath | Out-Null
}
#endregion
#=================================================
#region Startnet.cmd
$Content = @'
@echo off
title OSDCloud Workflow WinPE Startup
wpeinit
wpeutil DisableFirewall
wpeutil UpdateBootInfo
powershell.exe -w h -c Invoke-OSDCloudPEStartup OSK
powershell.exe -w h -c Invoke-OSDCloudPEStartup DeviceHardware
powershell.exe -w h -c Invoke-OSDCloudPEStartup WiFi
powershell.exe -w h -c Invoke-OSDCloudPEStartup IPConfig
powershell.exe -w h -c Invoke-OSDCloudPEStartup UpdateModule -Value OSD
powershell.exe -w h -c Invoke-OSDCloudPEStartup UpdateModule -Value OSDCloud
powershell.exe -w h -c Invoke-OSDCloudPEStartup Info
wpeutil Reboot
pause
'@

Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))][$($MyInvocation.MyCommand.Source)] Adding $MountPath\Windows\System32\startnet.cmd"
$Content | Out-File -FilePath "$MountPath\Windows\System32\startnet.cmd" -Encoding ascii -Width 2000 -Force
#endregion
#=================================================
<#

#>