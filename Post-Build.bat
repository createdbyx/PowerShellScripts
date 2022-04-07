rem setlocal
rem echo $(OutDir)
rem echo $(OutDir)
rem echo $(OutDir)
rem set OutDir=$(OutDir)
rem set ConfigurationName=$(ConfigurationName)
rem set ProjectName=$(ProjectName)
rem set TargetName=$(TargetName)
rem set TargetPath=$(TargetPath)
rem set ProjectPath=$(ProjectPath)
rem set ProjectFileName=$(ProjectFileName)
rem set TargetExt=$(TargetExt)
rem set TargetFileName=$(TargetFileName)
rem set DevEnvDir=$(DevEnvDir)
rem set TargetDir=$(TargetDir)
rem set ProjectDir=$(ProjectDir)
rem set SolutionFileName=$(SolutionFileName)
rem set SolutionPath=$(SolutionPath)
rem set SolutionDir=$(SolutionDir)
rem set SolutionName=$(SolutionName)
rem set PlatformName=$(PlatformName)
rem set ProjectExt=$(ProjectExt)
rem set SolutionExt=$(SolutionExt)
  
pushd $(ProjectDir)
if not exist "post-build.ps1" goto END

:POST_BUILD
rem powershell.exe -ExecutionPolicy Unrestricted -noprofile -nologo -noninteractive -file post-build.ps1 
powershell.exe -ExecutionPolicy Unrestricted -noprofile -nologo -noninteractive -Command .'$(ProjectDir)post-build.ps1' -OutDir:'$(OutDir)' -ConfigurationName:'$(ConfigurationName)' -ProjectName:'$(ProjectName)' -TargetName:'$(TargetName)' -TargetPath:'$(TargetPath)' -ProjectPath:'$(ProjectPath)' -ProjectFileName:'$(ProjectFileName)'	-TargetExt:'$(TargetExt)' -TargetFileName:'$(TargetFileName)' -DevEnvDir:'$(DevEnvDir)' -TargetDir:'$(TargetDir)' -ProjectDir:'$(ProjectDir)' -SolutionFileName:'$(SolutionFileName)' -SolutionPath:'$(SolutionPath)' -SolutionDir:'$(SolutionDir)' -SolutionName:'$(SolutionName)' -PlatformName:'$(PlatformName)' -ProjectExt:'$(ProjectExt)' -SolutionExt:'$(SolutionExt)'
goto END

:END
popd
rem endlocal