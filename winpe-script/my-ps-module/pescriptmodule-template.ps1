$subdirectories = Get-ChildItem -Path $PSScriptRoot -Directory
$destinationPath = "$MountPath\Program Files\WindowsPowerShell\Modules"

foreach ($subdirectory in $subdirectories) {
    $destination = Join-Path -Path $destinationPath -ChildPath $subdirectory.Name
    Copy-Item -Path $subdirectory.FullName -Destination $destination -Recurse -Force
}