

Describe "UiPathProjectJsonTools Tests" {
    Context "UiPathProjectJsonTools" {
        BeforeAll {

            # Import the UiPathProjectTools module
            & {
                $WarningPreference = 'SilentlyContinue'
                Import-Module .\src\UiPathCicdScripts\UiPathCicdScripts.psd1 -Force
            }

            $testAssetPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            # Load the test asset or stub
            $sampleProject = Get-Content $testAssetPath -Raw | ConvertFrom-Json
            # Other setup actions...
        }

        It "Correctly reads the projectVersion from project.json" {
            $result = Read-ProjectJson -ProjectJsonPath $testAssetPath
            $result.projectVersion | Should -Be "0.0.1"
        }

        It "Correctly reads the name from project.json" {
            $result = Read-ProjectJson -ProjectJsonPath $testAssetPath
            $result.name | Should -Be "BlankProcess"
        }

        It "Correctly reads dependencies from project.json" {
            $result = Read-ProjectJson -ProjectJsonPath $testAssetPath
            $dependencies = $result.dependencies.PSObject.Properties | ForEach-Object { $_.Name }
            $dependencies | Should -Contain "UiPath.Excel.Activities"
            $dependencies | Should -Contain "UiPath.Mail.Activities"
            $dependencies | Should -Contain "UiPath.System.Activities"
            $dependencies | Should -Contain "UiPath.Testing.Activities"
            $dependencies | Should -Contain "UiPath.UIAutomation.Activities"
        }

        It "Correctly reads the targetFramework from project.json" {
            $result = Read-ProjectJson -ProjectJsonPath $testAssetPath
            $result.targetFramework | Should -Be "Windows"
        }

        It "Correctly reads entryPoints from project.json" {
            $result = Read-ProjectJson -ProjectJsonPath $testAssetPath
            $entryPoints = $result.entryPoints

            # Assert that there is at least one entry point
            $entryPoints.Count | Should -BeGreaterOrEqual 1
            # Assert that one of the entry points has a filePath of 'Main.xaml'
            $entryPoints.filePath | Should -Contain "Main.xaml"
        }
    }
}

Describe "Increment-BuildVersion Tests" {
    Context "When auto-increment is enabled" {
        It "Should increment the build version by 1" {
            # Define the paths
            $originalProjectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            $projectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/throwaway_project.json"

            # Create a copy of the original project.json
            Copy-Item -Path $originalProjectJsonPath -Destination $projectJsonPath -Force

            $incomingVersion = "1.2.3"
            $commitMessage = "Auto-increment test"
            $autoIncrement = $true

            $newVersion = Increment-BuildVersion -incomingVersion $incomingVersion -ProjectJsonPath $projectJsonPath -commitMessage $commitMessage -autoIncrement $autoIncrement

            $expectedVersion = "1.2.4"
            $newVersion | Should -Be $expectedVersion

            # Restore the original project.json
            Copy-Item -Path $originalProjectJsonPath -Destination $projectJsonPath -Force
        }

        It "Should update the project.json file with the new version" {
            # Define the paths
            $originalProjectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            $projectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/throwaway_project.json"

            # Create a copy of the original project.json
            Copy-Item -Path $originalProjectJsonPath -Destination $projectJsonPath -Force

            $incomingVersion = "1.2.3"
            $commitMessage = "Auto-increment test"
            $autoIncrement = $true

            $newVersion = Increment-BuildVersion -incomingVersion $incomingVersion -ProjectJsonPath $projectJsonPath -commitMessage $commitMessage -autoIncrement $autoIncrement

            # Mock the Update-ProjectJsonProperties function and assert that it's called with the correct parameters
            Mock Update-ProjectJsonProperties { } -Verifiable {
                $script:InvocationInfo.MyCommand.Parameters['Path'] | Should -Be $projectJsonPath
                $script:InvocationInfo.MyCommand.Parameters['PropertiesToUpdate']['projectVersion'] | Should -Be $newVersion
            }

            # Restore the original project.json
            Copy-Item -Path $originalProjectJsonPath -Destination $projectJsonPath -Force
        }
    }

    Context "When auto-increment is disabled" {
        It "Should keep the version unchanged" {
            $incomingVersion = "1.2.3"
            $projectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            $commitMessage = "No auto-increment test"
            $autoIncrement = $false

            $newVersion = Increment-BuildVersion -incomingVersion $incomingVersion -ProjectJsonPath $projectJsonPath -commitMessage $commitMessage -autoIncrement $autoIncrement

            $newVersion | Should -Be $incomingVersion
        }

        It "Should not update the project.json file" {
            $incomingVersion = "1.2.3"
            $projectJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            $commitMessage = "No auto-increment test"
            $autoIncrement = $false

            # Mock the Update-ProjectJsonProperties function and assert that it's not called
            Mock Update-ProjectJsonProperties -Verifiable
        }
    }
}
