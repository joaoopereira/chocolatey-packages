$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'qlcplus*'
  fileType      = 'EXE'
  file = "${Env:SystemDrive}\QLC+\uninstall.exe"
  silentArgs   = '/S'
  validExitCodes= @(0)
}

Uninstall-ChocolateyPackage @packageArgs