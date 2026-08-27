[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$categories = @{
    Images = @(".jpg", ".jpeg", ".png", ".gif", ".webp")
    Documents = @(".pdf", ".doc", ".docx", ".txt", ".xlsx", ".csv")
    Videos = @(".mp4", ".mkv", ".avi", ".mov")
    Audio = @(".mp3", ".wav", ".flac", ".m4a")
    Archives = @(".zip", ".7z", ".rar", ".tar", ".gz")
    Installers = @(".exe", ".msi")
}

Write-Output "PowerShell Download Organizer"
Write-Output "============================="
Write-Output "Scanning: $Path"
Write-Output ""

$files = Get-ChildItem -Path $Path -File


foreach ($file in $files) {
    $extension = $file.Extension.ToLower()
    $categoryName = "Other"

    foreach ($category in $categories.Keys) {
        if ($categories[$category] -contains $extension) {

            $categoryName = $category
            break

        }
        
    }

    $fileInfo = [PSCustomObject]@{
        Name = $file.Name
        Extension = $file.Extension
        Category = $categoryName
        Size = $file.Length
        Modified = $file.LastWriteTime
    }

    $fileInfo

}

