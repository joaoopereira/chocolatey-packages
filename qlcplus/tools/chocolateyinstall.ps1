$ErrorActionPreference = 'Stop'
$toolsDir         = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url              = 'https://www.qlcplus.org/downloads/4.12.7/QLC+_4.12.7-1.exe'
$checksum         = 'a35630b869a72405b4f24871f79d664dfbad3a709ffaa57eb40b19eec7ed2ef9'
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
