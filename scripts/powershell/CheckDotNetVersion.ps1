<#
.SYNOPSIS
Checks for the installation of a specific version of .NET Core or .NET 5+.

.DESCRIPTION
This script checks if a specified version of .NET Core or .NET 5+ is installed on the system.
It uses the 'dotnet --list-runtimes' command to get a list of installed runtimes and then 
compares the installed versions with the required version.

.PARAMETER requiredVersion
Specifies the version of .NET to check for. If not provided, defaults to "6.0.7".

.EXAMPLE
.\CheckDotNetVersion.ps1 -requiredVersion "6.0.7"
Checks if .NET version 6.0.7 or higher is installed.

.EXAMPLE
.\CheckDotNetVersion.ps1
Checks if .NET version 6.0.7 or higher is installed by default.

.NOTES
Author: Christian Prior-Mamulyan
Date: 2023-12-10
#>

# Parameter declaration: allows the user to specify the required .NET version.
# If not provided, defaults to "6.0.7".
param (
    [string]$requiredVersion = "6.0.7"
)

# Function to parse and compare version numbers.
# Returns $true if the installed version is greater than or equal to the required version.
function CheckVersion($version, $minimumVersion) {
    $v = [Version]$version
    $m = [Version]$minimumVersion
    return $v -ge $m
}

# Main script execution block
try {
    # Retrieves the list of installed .NET runtimes.
    $runtimes = dotnet --list-runtimes
} catch {
    # Error handling: executed if the dotnet command fails (e.g., if .NET Core is not installed).
    Write-Host "Error: Unable to retrieve .NET runtimes. .NET Core or .NET 5+ may not be installed."
    exit
}

# Flag to indicate whether the required .NET version is installed.
$isRequiredVersionInstalled = $false

# Iterates through each runtime and checks the version.
foreach ($runtime in $runtimes) {
    if ($runtime -match "Microsoft\.NETCore\.App (\d+\.\d+\.\d+)") {
        # Extracts the version number using regex.
        $version = $matches[1]
        # Checks if the extracted version meets the requirement.
        if (CheckVersion $version $requiredVersion) {
            $isRequiredVersionInstalled = $true
            break
        }
    }
}

# Outputs the result to the user.
if ($isRequiredVersionInstalled) {
    Write-Host ".NET version $requiredVersion or higher is installed."
} else {
    Write-Host ".NET version $requiredVersion or higher is NOT installed."
}
