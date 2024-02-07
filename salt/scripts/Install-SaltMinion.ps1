<#
.SYNOPSIS
    This script automates the installation of Salt Minion on a Windows machine.

.DESCRIPTION
    The Install-SaltMinion.ps1 script is designed to simplify the process of installing Salt Minion on Windows. 
    It sets the required security protocol, downloads the latest Salt Minion installer, and installs it with 
    predefined settings. The script requires administrative privileges to run.

.PARAMETER saltMinionUrl
    The URL from where the Salt Minion installer is downloaded.

.PARAMETER installerFile
    The name of the installer file to be downloaded and executed.

.EXAMPLE
    .\Install-SaltMinion.ps1

    This command runs the script in the current directory, downloading and installing the Salt Minion.

.NOTES
    Version:        1.0
    Author:         Christian Prior-Mamulyan
    Creation Date:  2023-12-01
    Purpose/Change: Initial script development

#>

# Ensure the script is running with administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
    Write-Error "Please run this script as an Administrator!"
    Break
}

# Store the current directory
$originalDirectory = Get-Location

# Navigate to TEMP directory
cd $env:TEMP

# Set Security Protocol to TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define the URL for downloading the Salt Minion installer
$saltMinionUrl = "https://repo.saltproject.io/salt/py3/windows/latest/Salt-Minion-3006.4-Py3-AMD64-Setup.exe"

# Define the installer file name
$installerFile = "Salt-Minion-3006.4-Py3-AMD64-Setup.exe"

# Check and delete the installer file if it exists
if (Test-Path $installerFile) {
    try {
        del $installerFile -ErrorAction Stop
        Write-Host "Previous installer file deleted successfully."
    } catch {
        Write-Error "Failed to delete existing installer file: $_. Please delete the file manually and rerun the script."
        Exit
    }
}

# Download the installer
Invoke-WebRequest -Uri $saltMinionUrl -OutFile $installerFile -ErrorAction Stop

# Get the last six characters of the MAC address of the primary network adapter
$macAddress = Get-NetAdapter | Select-Object -First 1 | ForEach-Object { $_.MacAddress -replace ":", "" } | Select-Object -Last 6

# Get the MAC address of the primary network adapter and remove colons and hyphens
$macAddress = Get-NetAdapter | Select-Object -First 1 | ForEach-Object { $_.MacAddress -replace "[:\-]", "" }

# Extract the last six characters of the MAC address and convert to lowercase
$macAddressSuffix = $macAddress.Substring($macAddress.Length - 6).ToLower()

# Create a unique minion name (computer name in lowercase appended with '_' and the last six characters of the MAC address)
$minionName = $env:computername.ToLower() + "_" + $macAddressSuffix

# Install Salt Minion with specified master and unique minion name
Invoke-Expression ".\$installerFile /S /master=salt-master /minion-name=$minionName" -ErrorAction Stop

# Install Salt Minion with specified master and unique minion name
Invoke-Expression ".\$installerFile /S /master=salt-master /minion-name=$minionName" -ErrorAction Stop

# Attempt to delete the installer file with retries
$maxRetries = 5
$retryDelay = 5
$retryCount = 0

while ($retryCount -lt $maxRetries) {
    try {
        del .\$installerFile -ErrorAction Stop
        Write-Host "Installer file deleted successfully."
        break
    } catch {
        Write-Warning "Attempt $($retryCount + 1) failed to delete installer file: $_"
        Start-Sleep -Seconds $retryDelay
        $retryCount++
    }
}

if ($retryCount -eq $maxRetries) {
    Write-Warning "Could not delete installer file after multiple attempts. Please delete the file manually if it is still present."
}

# Return to the original directory
Set-Location $originalDirectory