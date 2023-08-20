Import-Module au

$releases = 'https://www.qlcplus.org/download'
function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing #1
    $regex = '.exe$'
    $url = $download_page.Links | Where-Object href -match $regex | Select-Object -First 1 -expand href #2
    $version = $url -split '/' | Select-Object -Last 1 -Skip 1 #3
    return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.checksumType32)'"
        }
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 1
    Set-ReleaseNotes $Package
}

function Set-ReleaseNotes ($Package) {
    $xmlFile = [xml](Get-Content -Path $Package.NuspecPath)

    $xmlFile.package.metadata.releasenotes."#cdata-section" = Get-ChangeLogFromRepo $Package

    $xmlFile.Save($Package.NuspecPath)

}

function Get-ChangeLogFromRepo ($Package) {
    $changelogUrl = "https://raw.githubusercontent.com/mcallegari/qlcplus/master/debian/changelog"
    $changelog = Invoke-WebRequest -Uri $changelogUrl -UseBasicParsing

    $versionToFind = $Package.RemoteVersion

    # Split the content into individual version sections
    $versionSections = $changelog.Content -split "(?=\bqlcplus \(\d+\.\d+\.\d+\) stable; urgency=low)"

    # Initialize a flag to check if the version was found
    $versionFound = $false

    # Loop through the version sections and find the specified version
    foreach ($section in $versionSections) {
        if ($section -match "qlcplus \($versionToFind\) stable; urgency=low") {
            $changelogForVersion = $section.Trim()
            $versionFound = $true
            break
        }
    }

    if (-not $versionFound) {
        Write-Host "Version $versionToFind not found in the changelog."
    }

    return $changelogForVersion
}

Update-Package -NoReadme