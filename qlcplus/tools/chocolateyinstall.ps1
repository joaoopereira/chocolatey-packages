$ErrorActionPreference = 'Stop'
$toolsDir         = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url              = 'https://www.qlcplus.org/downloads/4.12.6/QLC+_4.12.6.exe'
$checksum         = ''
$checksumType     = 'sha256'

$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  unzipLocation   = $toolsDir
  fileType        = 'EXE'
  url             = $url
  url64bit        = $url

  softwareName    = 'qlcplus*'

  checksum        = $checksum
  checksumType    = $checksumType
  checksum64      = $checksum
  checksumType64  = $checksumType

  validExitCodes  = @(0)
  silentArgs      = '/S'
}

Install-ChocolateyPackage @packageArgs
