[CmdletBinding()]
param([switch] $Force)

Import-Module AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

$re64         = '(DevPod_(?=[^\s]+x64)[^\s]+\.msi)'
$reChecksum64 = '(?<=Checksum64:\s*)((?<Checksum>([^\s].+)))'
$reType64     = '(?<=Type64:\s*)((?<Type64>([^\s].+)))'

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    "tools\chocolateyInstall.ps1" = @{
        "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
        "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
        "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.checksumType64)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseURL)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "$($re64)"       = "$($Latest.Filename64)"
      "$($reType64)"  = "$($Latest.checksumType64)"
      "$($reChecksum64)" = "$($Latest.Checksum64)"
    }
  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease loft-sh devpod

  return @{
    Version     = $LatestRelease.tag_name.TrimStart("v")
    URL64       = $LatestRelease.assets | Where-Object {$_.name.EndsWith("_windows_x64_en-US.msi")} | Select-Object -ExpandProperty browser_download_url
    ReleaseURL  = $LatestRelease.html_url
  }
}

update -ChecksumFor none -Force:$Force