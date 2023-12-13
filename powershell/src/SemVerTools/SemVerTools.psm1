<#
.SYNOPSIS
Parses a Semantic Versioning (SemVer) string and returns its components.

.DESCRIPTION
This function takes a SemVer string as input and uses a case-insensitive regular expression 
to parse it into its major, minor, patch, pre-release, and build components as defined by 
the SemVer specification. It returns a hashtable with these components if the string is valid; 
otherwise, it throws an error for invalid SemVer strings.

.PARAMETER semVerString
The SemVer string to be parsed.

.EXAMPLE
PS > Parse-SemVer -semVerString '1.2.3-beta+build.456'
Returns a hashtable with major, minor, patch, pre-release, and build components.

.INPUTS
String

.OUTPUTS
Hashtable

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>


function Parse-SemVer {
    param (
        [string]$semVerString
    )

    # regex pattern with case-insensitive flag (?i)
    $pattern = '(?i)^' +
    '(0|[1-9]\d*)\.' + # Major
    '(0|[1-9]\d*)\.' + # Minor
    '(0|[1-9]\d*)' + # Patch
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][a-zA-Z0-9-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][a-zA-Z0-9-]*))*))?' + # Pre-release
    '(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'  # Build

    # match is case-insensitive
    if ($semVerString -match $pattern) {
        $result = @{
            Major      = $Matches[1]
            Minor      = $Matches[2]
            Patch      = $Matches[3]
            PreRelease = $Matches[4]
            Build      = $Matches[5]
        }

        return $result
    }
    else {
        throw 'Invalid SemVer string'
    }
}


<#
.SYNOPSIS
Increments a Semantic Versioning (SemVer) number based on a given commit message.

.DESCRIPTION
This function takes an existing SemVer string and a commit message, then increments 
the version according to the nature of the changes indicated in the commit message. 
It supports incrementing major, minor, and patch versions, as well as handling 
pre-release versions and build metadata.

.PARAMETER semVerString
The current SemVer string to be incremented.

.PARAMETER commitMessage
The commit message used to determine how to increment the version.

.EXAMPLE
PS > Increment-SemVer -semVerString '1.0.0' -commitMessage 'feat: added new feature'
Returns '1.1.0' as the new version.

.INPUTS
String

.OUTPUTS
String

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>


function Increment-SemVer {
    param (
        [string]$semVerString,
        [string]$commitMessage
    )

    # Parse the existing SemVer string
    $parsedVersion = Parse-SemVer -semVerString $semVerString

    if ($commitMessage -match 'BREAKING|BREAKING CHANGE|major') {
        # Major version increment
        $parsedVersion.Major = [int]$parsedVersion.Major + 1
        $parsedVersion.Minor = 0
        $parsedVersion.Patch = 0
        $parsedVersion.PreRelease = $null
    }
    elseif ($commitMessage -match 'feat|feature|minor') {
        # Minor version increment
        $parsedVersion.Minor = [int]$parsedVersion.Minor + 1
        $parsedVersion.Patch = 0
        $parsedVersion.PreRelease = $null
    }
    elseif ($parsedVersion.PreRelease -and $commitMessage -notmatch 'fix|bugfix|patch|feat|feature|minor|BREAKING|BREAKING CHANGE|major') {
        # Increment pre-release version for non-specific commit messages
        if ($parsedVersion.PreRelease -match '(\d+)$') {
            $numeral = [int]$matches[1] + 1
            $parsedVersion.PreRelease = $parsedVersion.PreRelease -replace '(\d+)$', $numeral
        }
        else {
            $parsedVersion.PreRelease += '.1'
        }
    }
    elseif ($commitMessage -match 'fix|bugfix|patch') {
        # Patch version increment
        $parsedVersion.Patch = [int]$parsedVersion.Patch + 1
        $parsedVersion.PreRelease = $null
    }
    else {
        # Default case: increment the Patch version
        $parsedVersion.Patch = [int]$parsedVersion.Patch + 1
    }

    # Build metadata is left unchanged

    # Construct updated version string
    $updatedVersion = "{0}.{1}.{2}" -f $parsedVersion.Major, $parsedVersion.Minor, $parsedVersion.Patch
    if ($parsedVersion.PreRelease) {
        $updatedVersion += "-$($parsedVersion.PreRelease)"
    }
    if ($parsedVersion.Build) {
        $updatedVersion += "+$($parsedVersion.Build)"
    }

    return $updatedVersion
}
