$packageName    = 'podman-cli'
$url            = 'https://github.com/containers/podman/releases/download/v4.8.0/podman-remote-release-windows_amd64.zip'
$checksum       = '7889cb2bd8d0d158f38fb7e149db5095b55d4d7ee21727b53c7da88211f72964'
$checksumType   = 'sha256'
$validExitCodes = @(0)

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage `
  -PackageName $packageName `
  -Url64bit "$url" `
  -UnzipLocation "$toolsDir" `
  -Checksum64 $checksum `
  -ChecksumType64 $checksumType
