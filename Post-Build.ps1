param ($vs_OutDir,$vs_ConfigurationName,$vs_ProjectName,$vs_TargetName,$vs_TargetPath,$vs_ProjectPath,$vs_ProjectFileName,$vs_TargetExt,
$vs_TargetFileName,$vs_DevEnvDir,$vs_TargetDir,$vs_ProjectDir,$vs_SolutionFileName,$vs_SolutionPath,$vs_SolutionDir,$vs_SolutionName,
$vs_PlatformName,$vs_ProjectExt,$vs_SolutionExt,$vs_BuildEvent, $linqpad) 
  
$buildRulesFile =  (Join-Path -Path "$vs_ProjectDir" -ChildPath ($vs_ConfigurationName + "-" + $vs_BuildEvent + "Build.xml"))
Write-Output ( "build file: " + $buildRulesFile )
if (Test-Path -LiteralPath "$buildRulesFile" -PathType Leaf )
{
    [Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq") | Out-Null
    $xDoc = [System.Xml.Linq.XDocument]::Load("$buildRulesFile")   
    $rootElements = ( [Linq.Enumerable]::Select($xDoc.Root.Elements(), [Func[object,string]]{ param($x) $x.ToString() }) )
    $ruleContent = $rootElements | Select-Object   
}
else
{
   $ruleContent = ""
}
 
$tempFile = New-TemporaryFile                             
$newline = [environment]::NewLine
$content = ('<?xml version="1.0" encoding="utf-8" ?>'  + $newline +
"<build>" + $newline +
# "<buildvaribles>" + $newline +
'<variable name="BuildFile" value="' +          $tempFile.FullName      + '" />' + $newline +
'<variable name="BuildEvent" value="' +         $vs_BuildEvent          + '" />' + $newline +
'<variable name="OutDir" value="' +             $vs_OutDir              + '" />' + $newline +
'<variable name="ConfigurationName" value="' +  $vs_ConfigurationName   + '" />' + $newline +
'<variable name="ProjectName" value="' +        $vs_ProjectName         + '" />' + $newline +
'<variable name="TargetName" value="' +         $vs_TargetName          + '" />' + $newline +
'<variable name="TargetPath" value="' +         $vs_TargetPath          + '" />' + $newline +
'<variable name="ProjectPath" value="' +        $vs_ProjectPath         + '" />' + $newline +
'<variable name="ProjectFileName" value="' +    $vs_ProjectFileName     + '" />' + $newline +
'<variable name="TargetExt" value="' +          $vs_TargetExt           + '" />' + $newline +
'<variable name="TargetFileName" value="' +     $vs_TargetFileName      + '" />' + $newline +
'<variable name="DevEnvDir" value="' +          $vs_DevEnvDir           + '" />' + $newline +
'<variable name="TargetDir" value="' +          $vs_TargetDir           + '" />' + $newline +
'<variable name="ProjectDir" value="' +         $vs_ProjectDir          + '" />' + $newline +
'<variable name="SolutionFileName" value="' +   $vs_SolutionFileName    + '" />' + $newline +
'<variable name="SolutionPath" value="' +       $vs_SolutionPath        + '" />' + $newline +
'<variable name="SolutionDir" value="' +        $vs_SolutionDir         + '" />' + $newline +
'<variable name="SolutionName" value="' +       $vs_SolutionName        + '" />' + $newline +
'<variable name="PlatformName" value="' +       $vs_PlatformName        + '" />' + $newline +
'<variable name="ProjectExt" value="' +         $vs_ProjectExt          + '" />' + $newline +
'<variable name="SolutionExt" value="' +        $vs_SolutionExt         + '" />' + $newline +
'<variable name="MachineName" value="' +        $env:COMPUTERNAME       + '" />' + $newline +



# "<BuildFile>" +              $tempFile.FullName      +  "</BuildFile>" +           $newline +
# "<BuildEvent>" +             $vs_BuildEvent          +  "</BuildEvent>" +          $newline +
# "<OutDir>" +                 $vs_OutDir              +  "</OutDir>" +              $newline +
# "<ConfigurationName>" +      $vs_ConfigurationName   +  "</ConfigurationName>" +   $newline +
# "<ProjectName>" +            $vs_ProjectName         +  "</ProjectName>" +         $newline +
# "<TargetName>" +             $vs_TargetName          +  "</TargetName>" +          $newline +
# "<TargetPath>" +             $vs_TargetPath          +  "</TargetPath>" +          $newline +
# "<ProjectPath>" +            $vs_ProjectPath         +  "</ProjectPath>" +         $newline +
# "<ProjectFileName>" +        $vs_ProjectFileName     +  "</ProjectFileName>" +     $newline +
# "<TargetExt>" +              $vs_TargetExt           +  "</TargetExt>" +           $newline +
# "<TargetFileName>" +         $vs_TargetFileName      +  "</TargetFileName>" +      $newline +
# "<DevEnvDir>" +              $vs_DevEnvDir           +  "</DevEnvDir>" +           $newline +
# "<TargetDir>" +              $vs_TargetDir           +  "</TargetDir>" +           $newline +
# "<ProjectDir>" +             $vs_ProjectDir          +  "</ProjectDir>" +          $newline +
# "<SolutionFileName>" +       $vs_SolutionFileName    +  "</SolutionFileName>" +    $newline +
# "<SolutionPath>" +           $vs_SolutionPath        +  "</SolutionPath>" +        $newline +
# "<SolutionDir>" +            $vs_SolutionDir         +  "</SolutionDir>" +         $newline +
# "<SolutionName>" +           $vs_SolutionName        +  "</SolutionName>" +        $newline +
# "<PlatformName>" +           $vs_PlatformName        +  "</PlatformName>" +        $newline +
# "<ProjectExt>" +             $vs_ProjectExt          +  "</ProjectExt>" +          $newline +
# "<SolutionExt>" +            $vs_SolutionExt         +  "</SolutionExt>" +         $newline +
# "<MachineName>" +            $env:COMPUTERNAME       +  "</MachineName>" +         $newline +
# "</buildvaribles>" + $newline + 
$ruleContent + $newline + 
"</build>")
 
 #echo $content
 #exit

Set-Content -Path $tempFile.FullName -Value $content
if($linqpad)
{
    $postBuildPathScript="E:\OneDrive\LinqPad\LINQPad Queries\BuildScripts\Post-Build.linq"
    lprun6.exe "$postBuildPathScript" ( "-bf:" + $tempFile.FullName )
}
else
{
    BuildHelper ( "-b:" + $tempFile.FullName )           
}
$tempFile.Delete() 

<#	 
Place the lines below in the vs.net pre/post build event field

Pre

powershell.exe -ExecutionPolicy Unrestricted -noprofile -nologo -noninteractive -Command .'P:\PowerShell\post-build.ps1' -vs_BuildEvent:Pre -vs_OutDir:'$(OutDir)' -vs_ConfigurationName:'$(ConfigurationName)' -vs_ProjectName:'$(ProjectName)' -vs_TargetName:'$(TargetName)' -vs_TargetPath:'$(TargetPath)' -vs_ProjectPath:'$(ProjectPath)' -vs_ProjectFileName:'$(ProjectFileName)' -vs_TargetExt:'$(TargetExt)' -vs_TargetFileName:'$(TargetFileName)' -vs_DevEnvDir:'$(DevEnvDir)' -vs_TargetDir:'$(TargetDir)' -vs_ProjectDir:'$(ProjectDir)' -vs_SolutionFileName:'$(SolutionFileName)' -vs_SolutionPath:'$(SolutionPath)' -vs_SolutionDir:'$(SolutionDir)' -vs_SolutionName:'$(SolutionName)' -vs_PlatformName:'$(PlatformName)' -vs_ProjectExt:'$(ProjectExt)' -vs_SolutionExt:'$(SolutionExt)'

Post

powershell.exe -ExecutionPolicy Unrestricted -noprofile -nologo -noninteractive -Command .'P:\PowerShell\post-build.ps1' -vs_BuildEvent:Post -vs_OutDir:'$(OutDir)' -vs_ConfigurationName:'$(ConfigurationName)' -vs_ProjectName:'$(ProjectName)' -vs_TargetName:'$(TargetName)' -vs_TargetPath:'$(TargetPath)' -vs_ProjectPath:'$(ProjectPath)' -vs_ProjectFileName:'$(ProjectFileName)' -vs_TargetExt:'$(TargetExt)' -vs_TargetFileName:'$(TargetFileName)' -vs_DevEnvDir:'$(DevEnvDir)' -vs_TargetDir:'$(TargetDir)' -vs_ProjectDir:'$(ProjectDir)' -vs_SolutionFileName:'$(SolutionFileName)' -vs_SolutionPath:'$(SolutionPath)' -vs_SolutionDir:'$(SolutionDir)' -vs_SolutionName:'$(SolutionName)' -vs_PlatformName:'$(PlatformName)' -vs_ProjectExt:'$(ProjectExt)' -vs_SolutionExt:'$(SolutionExt)'
#>