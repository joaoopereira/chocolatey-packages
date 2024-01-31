$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url              = 'https://github.com/loft-sh/devpod/releases/download/v0.5.0/DevPod_windows_x64_en-US.msi'
$checksum         = '741EA422A0CE866A288363DA7C4777D26F20805AC938BDDBCF10F6116ADA5E12'
$checksumType     = 'sha256'
$file             = "$toolsDir\DevPod_windows_x64_en-US.msi"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    unzipLocation   = $toolsDir
    fileType        = 'msi'
    url             = $url

    softwareName   = 'DevPod*'

    checksum        = $checksum
    checksumType    = $checksumType

    file            = $file

    validExitCodes = @(0, 1641, 3010)
    silentArgs     = '/qn /norestart'
}

Install-ChocolateyInstallPackage @packageArgs
