

Describe "UiPathProjectTools Tests" {
Context "UiPathProjectTools" {
    BeforeAll {

        # Import the UiPathProjectTools module
        & {
            $WarningPreference = 'SilentlyContinue'
            Import-Module .\src\UiPathProjectTools\UiPathProjectTools.psd1 -Force
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
