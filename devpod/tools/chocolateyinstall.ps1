$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url              = 'https://github.com/loft-sh/devpod/releases/download/v0.4.2/DevPod_windows_x64_en-US.msi'
$checksum         = 'EEB28BFA6091570DDF7CAE1F0BEF1ECB6FE6803CDE3C3343A88B453291BAAC1F'
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
