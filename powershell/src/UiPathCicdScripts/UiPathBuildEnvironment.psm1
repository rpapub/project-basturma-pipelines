function Test-BuildEnvironment {
    [CmdletBinding()]
    param ()

    Write-Host "Testing Build Environment..."

    $result = $true

    if (-not (Test-UiPathCliInPath)) {
        Write-Host "uipcli.exe not found in the system PATH. Please ensure it is installed and added to PATH."
        $result = $false
    }

    # Add more checks here if needed
    # Example:
    # if (-not (Test-SomeOtherCondition)) {
    #     Write-Host "Some other condition failed."
    #     $result = $false
    # }

    return $result
}



<#
.SYNOPSIS
Checks if uipcli.exe is available in the system PATH.

.DESCRIPTION
The Check-UiPathCliInPath function searches the system PATH for uipcli.exe, 
the command line interface for UiPath, and returns a boolean value indicating 
whether or not it is found.

.EXAMPLE
PS > Check-UiPathCliInPath
Returns $True if uipcli.exe is found in the system PATH, $False otherwise.

.OUTPUTS
Boolean
Returns $True if uipcli.exe is found, $False otherwise.

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>

function Test-UiPathCliInPath {
    [CmdletBinding()]
    param ()

    try {
        $null = Get-Command 'uipcli.exe' -ErrorAction Stop
        return $True
    }
    catch {
        return $False
    }
}
