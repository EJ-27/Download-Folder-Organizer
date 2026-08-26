[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

Write-Output "PowerShell Download Organizer"
Write-Output "============================="
Write-Output "Scanning: $Path"
Write-Output ""

$files = Get-ChildItem -Path $Path -File

foreach ($file in $files) {
    Write-Output "Name: $($file.Name)"
    Write-Output "Extension: $($file.Extension)"
    Write-Output "Size: $($file.Length) bytes"
    Write-Output "Modified: $($file.LastWriteTime)"
    Write-Output ""
}

