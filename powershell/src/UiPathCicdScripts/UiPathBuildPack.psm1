function Build-Project {
    [CmdletBinding()]
    param (
        [string]$projectJsonPath,
        [string]$packageOutputFolder,
        [string]$buildVersion
    )

    Write-Host "Build-Project - ProjectJsonPath: $projectJsonPath"
    Write-Host "Build-Project - packageOutputFolder: $packageOutputFolder"
    Write-Host "Build-Project - Version: $buildVersion"

    try {
        Write-Host "uipcli.exe package pack $projectJsonPath --output $packageOutputFolder --version $buildVersion --disableTelemetry"
        #uipcli.exe package pack "$projectJsonPath" --output "$outputPath" --version "$buildVersion" --disableTelemetry
    }
    catch {
        # Handle any errors that occurred in the try block
        Write-Error "An error occurred: $_"
        # The finally block will still run even if break is called to exit the loop.
        break
    }
    finally {

    }

    return $true  # Return true to indicate successful execution

}

function Get-EntryTargetPointsFromProjectJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$json,
        [bool]$buildAllEntryPoints
    )

    if ($buildAllEntryPoints) {
        $entryPointsToBuildArray = $json.entryPoints
    }
    else {
        $entryPointsToBuildArray = $json.entryPoints | Where-Object { $_.filePath -eq $json.main }
    }

    return $entryPointsToBuildArray
}