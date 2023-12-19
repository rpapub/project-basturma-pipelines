
<#
.SYNOPSIS
Updates a specified attribute in a UiPath XAML file.

.DESCRIPTION
The Update-XamlAttribute function modifies a specific attribute of the 'Activity' element in a UiPath XAML file. This function is particularly useful for programmatically changing values of certain attributes within the XAML file, such as the 'ConfigFile' path. It allows users to specify the path to the XAML file, the name of the attribute to be updated (without the 'this:' namespace prefix), and the new value for that attribute. This function ensures that the original file is backed up before making changes, and it restores the original file in case of errors during the update process.

.EXAMPLE
Update-XamlAttribute -xamlPath 'Main.xaml' -attributeName 'ConfigFile' -newValue 'Data\Config_Production.xlsx'

This example updates the 'ConfigFile' attribute of the 'Activity' element in the 'Main.xaml' file, setting it to 'Data\Config_Production.xlsx'.

.OUTPUTS
None. This function does not return any output, but it outputs messages to the host regarding the status of the update operation.

.NOTES
Version:        0.5.0
Author:         Christian Prior-Mamulyan
Creation Date:  2023-12-01
License:        CC-BY
Sourcecode:     https://github.com/rpapub
#>

function Update-XamlAttribute {
    [CmdletBinding()]
    param (
        [string]$xamlPath = 'Main.xaml',
        [string]$targetAttribute = 'ConfigFile',
        [string]$newValue = 'Data\Config.xlsx'
    )

    # Define a backup path in the system's temp directory
    $backupPath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath ([System.IO.Path]::GetRandomFileName())

    try {
        if (-not (Test-Path $xamlPath)) {
            Write-Error "XAML file not found at path: $xamlPath"
            return
        }

        # Create a backup of the original XAML file
        Copy-Item -Path $xamlPath -Destination $backupPath -Force

        # Load the XAML file as XML
        [xml]$xamlContent = Get-Content -Path $xamlPath

        # Define the XAML namespaces as per the XAML file
        # Shold work without a namespace manager, but doesn't hurt to be explicit
        $xamlNamespace = New-Object System.Xml.XmlNamespaceManager($xamlContent.NameTable)
        $xamlNamespace.AddNamespace('mc', 'http://schemas.openxmlformats.org/markup-compatibility/2006')
        $xamlNamespace.AddNamespace('sap', 'http://schemas.microsoft.com/netfx/2009/xaml/activities/presentation')
        $xamlNamespace.AddNamespace('sap2010', 'http://schemas.microsoft.com/netfx/2010/xaml/activities/presentation')
        $xamlNamespace.AddNamespace('scg', 'clr-namespace:System.Collections.Generic;assembly=System.Private.CoreLib')
        $xamlNamespace.AddNamespace('sco', 'clr-namespace:System.Collections.ObjectModel;assembly=System.Private.CoreLib')
        $xamlNamespace.AddNamespace('this', 'clr-namespace:')
        $xamlNamespace.AddNamespace('ui', 'http://schemas.uipath.com/workflow/activities')
        $xamlNamespace.AddNamespace('x', 'http://schemas.microsoft.com/winfx/2006/xaml')

        # Check if the target attribute exists and modify it
        if ($xamlContent.Activity."Main.$targetAttribute") {
            $xamlContent.Activity."Main.$targetAttribute" = $newValue
            # Save the changes back to the XAML file
            $xamlContent.Save($xamlPath)
            # Write-Host "XAML file updated successfully. '$targetAttribute' set to: $newValue"
        }
        else {
            Write-Warning "'$targetAttribute' attribute not found in the XAML file."
        }
    }
    catch {
        Write-Error "An error occurred: $_. Restoring from backup."
        # Restore from the backup
        Copy-Item -Path $backupPath -Destination $xamlPath -Force
    }
    finally {
        # Clean up: Delete the backup file
        if (Test-Path $backupPath) {
            Remove-Item -Path $backupPath
        }
    }
}

