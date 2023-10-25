$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url              = 'https://github.com/loft-sh/devpod/releases/download/v0.3.6/DevPod_windows_x64_en-US.msi'
$checksum         = '73B398D6738E7480B34BF6D70B3FA77DAA6EE4C0A3D8D11F0741415107E263EA'
$checksumType     = 'sha256'
$file             = "$toolsDir\DevPod_windows_x64_en-US.msi"

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    unzipLocation   = $toolsDir
    fileType        = 'msi'
    url             = $url
    url64bit        = $url

    softwareName   = 'DevPod*'

    checksum        = $checksum
    checksumType    = $checksumType
    checksum64      = $checksum
    checksumType64  = $checksumType

    file            = $file
    file64          = $file

    validExitCodes = @(0, 1641, 3010)
    silentArgs     = '/qn /norestart'
}

Install-ChocolateyInstallPackage @packageArgs
