class GitData
{
    [string]$Folder
    [string]$Branch
    [int]$Modifications
    [int]$Additions
    [int]$Deletions
    [int]$Untracked
    [int]$Renamed
}

$drive = Get-Location 
$gitFolders = (Get-ChildItem $drive -Attributes Directory+Hidden -ErrorAction SilentlyContinue -Filter ".git" -Recurse | Select-Object -Property FullName)

$results = New-Object System.Collections.ArrayList

foreach ($entry in $gitFolders)
{
    $e = $entry.FullName -replace ".{4}$"
    Set-Location $e
    git remote | Out-Null
    [array]$status = git status -sb
    $c = New-Object -TypeName GitData
    $c.Folder = $e

    foreach ($x in $status)
    {
        $firstTwo = $x.Substring(0, 2)
        switch ($firstTwo)
        {
            '##' {
                $c.Branch = $x
            }
            ' M' {
                $c.Modifications += 1
            }
            ' A' {
                $c.Additions += 1
            }
            ' D' {
                $c.Deletions += 1
            }
            ' R' {
                $c.Renamed += 1
            }
            'M ' {
                $c.Modifications += 1
            }
            'A ' {
                $c.Additions += 1
            }
            'D ' {
                $c.Deletions += 1
            }
            'R ' {
                $c.Renamed += 1
            }
            '??' {
                $c.Untracked += 1
            }
        }
    }

    $results.Add($c) | Out-Null
}

$results | Sort-Object -Property @{ Expression = { $_.Modifications + $_.Additions + $_.Deletions + $_.Renamed }; Descending = $true }   
Set-Location $drive
