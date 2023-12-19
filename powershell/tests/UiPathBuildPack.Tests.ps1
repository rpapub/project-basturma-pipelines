

Describe "UiPathBuildPack Tests" {
    Context "project.json from TestAssets" {
        BeforeAll {

            # Import the UiPathProjectTools module
            & {
                $WarningPreference = 'SilentlyContinue'
                Import-Module .\src\UiPathCicdScripts\UiPathCicdScripts.psd1 -Force
            }

            $testAssetPath = Join-Path -Path $PSScriptRoot -ChildPath "TestAssets/project.json"
            # Load the test asset or stub
            $projectJson = Get-Content $testAssetPath -Raw | ConvertFrom-Json
            # Other setup actions...
        }

        It "Should return all entry points" {
            $entryPoints = Get-EntryTargetPointsFromProjectJson -json $projectJson -buildAllEntryPoints $true
            $entryPoints.Count | Should -Be 3
        }


        It "Should return only the main entry point" {
            $entryPoints = Get-EntryTargetPointsFromProjectJson -json $projectJson -buildAllEntryPoints $false
            $entryPoints.Count | Should -Be 1
            $entryPoints[0].filePath | Should -Be "Main.xaml"
        }

    }
}
