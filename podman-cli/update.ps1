[CmdletBinding()]
param([switch] $Force)

Import-Module AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

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

  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease containers podman

  return @{
    Version     = $LatestRelease.tag_name.TrimStart("v")
    URL64       = $LatestRelease.assets | Where-Object {$_.name.EndsWith("podman-remote-release-windows_amd64.zip")} | Select-Object -ExpandProperty browser_download_url
    ReleaseURL  = $LatestRelease.html_url
  }
}

update -ChecksumFor none -Force:$Force