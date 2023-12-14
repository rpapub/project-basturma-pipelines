
Describe "Update-XamlAttribute Tests" {
    Context "Updating XAML Attributes" {
        BeforeAll {
            # Import the UiPathProjectTools module
            & {
                $WarningPreference = 'SilentlyContinue'
                Import-Module .\src\UiPathCicdScripts\UiPathCicdScripts.psd1 -Force
            }

            # Define paths for test assets
            $testAssetPath = "$PSScriptRoot\TestAssets\Main.xaml"
            
            # Create a temporary directory path
            # Seems on GitHub runners subdirectories cannot be created in the temp directory
            $tempDirPath = $([System.IO.Path]::GetTempPath())

            # Ensure the temporary directory exists, create if it doesn't
            if (-not (Test-Path -Path $tempDirPath -PathType Container)) {
                New-Item -Path $tempDirPath -ItemType Directory | Out-Null
            }

            # Define the temporary XAML file path
            $tempTestPath = Join-Path -Path $tempDirPath -ChildPath "Main_TempTest.xaml"

            # Copy the test asset to the temporary location
            Copy-Item -Path $testAssetPath -Destination $tempTestPath
        }

        It "Updates the 'ConfigFile' attribute in the XAML file" {
            # Arrange
            $attributeName = 'ConfigFile'
            $newValue = 'Data\NewConfigPath.xlsx'

            # Act
            Update-XamlAttribute -xamlPath $tempTestPath -targetAttribute $attributeName -newValue $newValue

            # Re-load the modified XAML to check changes
            [xml]$updatedContent = Get-Content -Path $tempTestPath

            # Assert
            $updatedContent.Activity."Main.$attributeName" | Should -Be $newValue
        }

        AfterAll {
            # Cleanup: Remove the temporary XAML file, temporary directory, and unload the module
            if (Test-Path $tempTestPath) {
                Remove-Item -Path $tempTestPath
            }
            Remove-Module UiPathCicdScripts
        }
    }
}
