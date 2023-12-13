<#
.SYNOPSIS
Reads and returns the content of a UiPath project.json file as a PowerShell object.

.DESCRIPTION
The Read-ProjectJson function reads a specified UiPath project.json file and converts 
its content to a PowerShell object. This includes details like project version, name, 
dependencies, and more, useful for further processing in automation scripts.

.PARAMETER ProjectPath
The file path of the UiPath project.json file to be read.

.EXAMPLE
PS > $projectInfo = Read-ProjectJson -ProjectPath 'path/to/project.json'
Reads the project.json at the specified path and returns its content.

.OUTPUTS
PSCustomObject
Returns a custom PowerShell object with properties corresponding to the project.json content.

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>

function Read-ProjectJson {
    param (
        [string]$ProjectJsonPath
    )

    $json = Get-Content $ProjectJsonPath -Raw | ConvertFrom-Json
    return $json
}

<#
.SYNOPSIS
Updates specified properties in a UiPath project.json file.

.DESCRIPTION
The Update-ProjectJsonProperties function allows for dynamically updating specific 
properties within a UiPath project.json file. It accepts a hashtable of property names 
and values and updates the project.json file accordingly, which is useful in 
automation scenarios like CI/CD pipelines.

.PARAMETER Path
The file path of the UiPath project.json file to be updated.

.PARAMETER PropertiesToUpdate
A hashtable of property names and their new values to be updated in the project.json file.

.EXAMPLE
PS > Update-ProjectJsonProperties -Path 'path/to/project.json' -PropertiesToUpdate @{ 'name' = 'NewProjectName' }
Updates the 'name' property of the project.json file at the specified path.

.OUTPUTS
None
Directly updates the project.json file.

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>

function Update-ProjectJsonProperties {
    [CmdletBinding()]
    param (
        [string]$Path,
        [hashtable]$PropertiesToUpdate
    )

    Write-Debug "Reading project.json from path: $Path"
    $projectJson = Get-Content $Path -Raw | ConvertFrom-Json

    foreach ($property in $PropertiesToUpdate.GetEnumerator()) {
        Write-Debug "Checking property: $($property.Key)"
        if ($projectJson.PSObject.Properties.Name -contains $property.Key) {
            Write-Debug "Updating property '$($property.Key)' to value '$($property.Value)'"
            $projectJson.$($property.Key) = $property.Value
        } else {
            Write-Debug "Property '$($property.Key)' not found in project.json"
        }
    }

    Write-Debug "Saving updated project.json back to path: $Path"
    $tempPath = [System.IO.Path]::GetTempFileName()
    $projectJson | ConvertTo-Json | Set-Content $tempPath -Encoding UTF8
    Move-Item -Path $tempPath -Destination $Path -Force
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

function Check-UiPathCliInPath {
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


