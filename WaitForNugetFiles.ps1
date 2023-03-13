# Define the folder path and file extension to wait for
param (
    [string]$folderPath,
    [string]$destinationPath,
    [string[]]$fileExtensions,
    [double]$timeout = 5
)

$startTime = Get-Date;
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$filesToCopy = New-Object System.Collections.Generic.List[string]
$currentIndex = 0;

while ($currentIndex -lt $fileExtensions.Length)
{   
    $fileExtension = $fileExtensions[$currentIndex]
    
    Write-Host "Waiting for a file with the $fileExtension extension to be created in $folderPath..."

    # Wait for a file with the specified extension to be created in the folder
    $file = Get-ChildItem $folderPath -Filter "*$fileExtension" | Select-Object -First 1
    while (!$file) 
    {          
        if ($stopwatch.Elapsed.TotalSeconds -ge $timeout) 
        {
            # Stop the Stopwatch object
            $stopwatch.Stop()

            Write-Host "Timed out at $timeout secs."

            # Exit the while loop
            exit
        }

        Start-Sleep -Seconds 1
        $file = Get-ChildItem $folderPath -Filter "*$fileExtension" | Select-Object -First 1
    }
  
    $fullPath = Join-Path -Path $folderPath -ChildPath $file

    $item = Get-Item $fullPath;
    if($item.Exists)
    {
        $fileCreationDate = $item.CreationTime
        if($fileCreationDate -gt $startTime)
        {
            # copy new file to dest folder
            $filesToCopy.Add($fullPath)            
            $currentIndex++
        }
    }
}

if($filesToCopy.Count -gt 0)
{
    Write-Host "Copying $($filesToCopy.Count) files."
}

foreach ($filePath in $filesToCopy)
{
    $item = Get-Item $filePath;
    $destPath = Join-Path -Path $destinationPath -ChildPath $item.Name
    Write-Host "Copying: $($item.FullName) -> $destPath"
    Copy-Item -Path $item.FullName -Destination $destPath -Force
}
