[CmdletBinding()]
param([switch] $Force)

Import-Module AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

$reVersion    = '(v)\d*.\d*.\d*(\/ssh-manager-windows-amd64)'
$reChecksum64 = '(?<=Checksum64:\s*)((?<Checksum>([^\s].+)))'
$reType64     = '(?<=Type64:\s*)((?<Type64>([^\s].+)))'

function global:au_BeforeUpdate {
  New-Item -ItemType Directory -Force -Path ".\bin\"
  Invoke-WebRequest -Uri $Latest.URL64 -OutFile ".\bin\ssh-manager.exe"
  $Latest.ChecksumType64 = 'sha256'
  $Latest.Checksum64 = Get-FileHash ".\bin\ssh-manager.exe" -Algorithm $Latest.ChecksumType64 | ForEach-Object Hash
}

function global:au_SearchReplace {
  @{
    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseURL)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "$($reVersion)"      = "`${1}$($Latest.Version)`${2}"
      "$($reType64)"      = "$($Latest.checksumType64)"
      "$($reChecksum64)"  = "$($Latest.Checksum64)"
    }
  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease omegion ssh-manager

  return @{
    Version     = $LatestRelease.tag_name.TrimStart("v")
    URL64       = $LatestRelease.assets | Where-Object {$_.name.EndsWith("windows-amd64")} | Select-Object -ExpandProperty browser_download_url
    ReleaseURL  = $LatestRelease.html_url
  }
}

update -ChecksumFor none -Force:$Force