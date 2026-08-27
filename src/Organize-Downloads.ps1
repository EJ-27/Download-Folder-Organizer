[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [switch]$DryRun
)

if (-not (Test-Path -Path $Path -PathType Container)) {
    Write-Error "The specified path does not exist or is not a directory: $Path"
    exit 1
}

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

$filesScanned = 0
$filesMoved = 0
$filesConflicted = 0
$filesFailed = 0

foreach ($file in $files) {
    $filesScanned++

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
        Status    = ""
    }

    $destinationPath = Join-Path -Path $Path -ChildPath $categoryName

    if (-not (Test-Path -Path $destinationPath)) {
        if ($DryRun) {
            Write-Output "[DRY RUN] Would create directory: $destinationPath"
        }
        else {
            New-Item -ItemType Directory -Path $destinationPath | Out-Null
        }
    }

    $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name

    if (Test-Path -Path $destinationFile) {
        $fileInfo.Status = "Conflict"
        $filesConflicted++

        if ($DryRun) {
            Write-Output "[DRY RUN] CONFLICT: $($file.Name) already exists"
        }
        else {
            Write-Output "CONFLICT: $($file.Name) already exists"
            continue
        }
    }
    else {
        if ($DryRun) {
            $fileInfo.Status = "DryRun"
            Write-Output "[DRY RUN] File $($file.Name) would be moved"
        }
        else {
            Move-Item -Path $file.FullName -Destination $destinationFile
            $filesMoved++
            $fileInfo.Status = "Moved"
        }
    }

    $fileInfo

}

    Write-Output ""
    Write-Output "Organization Summary"
    Write-Output "===================="
    Write-Output "Files scanned:    $filesScanned"
    Write-Output "Files moved:      $filesMoved"
    Write-Output "Conflicts:        $filesConflicted"
    Write-Output "Failed:           $filesFailed"

