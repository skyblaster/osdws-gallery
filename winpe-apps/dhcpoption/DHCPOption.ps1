#############################################################################################
# Add DhcpOption.exe to the Boot Image for use with Microsoft Connected Cache (MCC) discovery
# 
# https://github.com/okieselbach/Helpers/blob/master/DhcpOption/x64/Release/DhcpOption.exe
# (C) 2012 Glueck & Kanja Consulting AG by Oliver Kieselbach
#############################################################################################

# Copy DHCPOption to the Boot Image
Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Copying [DhcpOption.exe] to BootImage [Windows\System32]"
Copy-Item -Path "$PSScriptRoot\DhcpOption.exe" -Destination "$MountPath\Windows\System32\DhcpOption.exe" -Force