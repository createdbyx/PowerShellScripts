class GitData {
    [string]$Folder
    [string]$Branch
    [int]$Modifications
    [int]$Additions
    [int]$Deletions
    [int]$Untracked
    [int]$Renamed
}

$drive = Read-Host "Enter Path or leave blank for current path"
$gitFolders = (Get-ChildItem $drive -Attributes Directory+Hidden -ErrorAction SilentlyContinue -Filter ".git" -Recurse | select -Property FullName ) 

$results = New-Object System.Collections.ArrayList

foreach( $entry in $gitFolders )
 {
    $e = $entry.FullName -replace ".{4}$"
    cd $e     
    [array] $tmp = git remote
   [array] $status = git status -sb
   $c = New-Object -TypeName GitData 
   $c.Folder = $e
  
  foreach($x in $status)
   {
        $firstTwo= $x.Substring(0,2)
       switch ( $firstTwo ) 
        {
            '##' { $c.Branch = $x }
            ' M' { $c.Modifications += 1 }
            ' A' { $c.Additions += 1 }
            ' D' { $c.Deletions += 1 }
            ' R' { $c.Renamed += 1 } 
            'M ' { $c.Modifications += 1 }
            'A ' { $c.Additions += 1 }
            'D ' { $c.Deletions += 1 }
            'R ' { $c.Renamed += 1 } 
            '??' { $c.Untracked += 1 } 
        }
   } 
   
   $results.Add($c) | Out-Null
}  

$results | Sort-Object -Property @{Expression={$_.Modifications + $_.Additions + $_.Deletions + $_.Renamed}; Descending=$true} | ConvertTo-Html | Out-File -FilePath ($drive + "GitData.html")
