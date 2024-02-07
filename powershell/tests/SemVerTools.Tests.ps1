# Import the SemVerTools module
& {
    $WarningPreference = 'SilentlyContinue'
    Import-Module .\src\SemVerTools\SemVerTools.psm1 -Force
}

Describe "SemVerTools Module Tests" {
    Context "Increment-SemVer Function" {
        # Test Cases
        $testCases = @(
            @{ Version = '1.0.0'; Message = 'fix: corrected a typo'; Expected = '1.0.1' },
            @{ Version = '1.0.0'; Message = 'feat: added new login feature'; Expected = '1.1.0' },
            @{ Version = '1.0.0'; Message = 'BREAKING CHANGE: redesigned database schema'; Expected = '2.0.0' },
            @{ Version = '1.0.0'; Message = 'breaking: redesigned database schema'; Expected = '2.0.0' },
            @{ Version = '1.2.3'; Message = 'chore: updated documentation'; Expected = '1.2.4' },
            @{ Version = '2.0.0'; Message = 'major: complete UI overhaul'; Expected = '3.0.0' },
            @{ Version = '2.1.1'; Message = 'bugfix: fixed issue with user authentication'; Expected = '2.1.2' },
            @{ Version = '1.0.0-alpha'; Message = 'fix: fix in alpha'; Expected = '1.0.1' },
            @{ Version = '1.0.0-alpha'; Message = 'minor change'; Expected = '1.1.0' },
            @{ Version = '1.0.0-alpha.1'; Message = 'feat: new feature in alpha'; Expected = '1.1.0' },
            @{ Version = '1.0.0-beta'; Message = 'BREAKING CHANGE: breaking change in beta'; Expected = '2.0.0' },
            @{ Version = '1.0.0-rc.1'; Message = 'rc fix'; Expected = '1.0.1' },
            @{ Version = '1.0.0'; Message = 'lorem ipsum'; Expected = '1.0.1' },
            @{ Version = '1.0.1'; Message = 'lorem ipsum'; Expected = '1.0.2' },
            @{ Version = '1.1.0'; Message = 'lorem ipsum'; Expected = '1.1.1' },
            @{ Version = '2.0.0'; Message = 'lorem ipsum'; Expected = '2.0.1' },
            @{ Version = '1.0.0-alpha'; Message = 'lorem ipsum'; Expected = '1.0.0-alpha.1' },
            @{ Version = '1.0.0-alpha.1'; Message = 'lorem ipsum'; Expected = '1.0.0-alpha.2' },
            @{ Version = '1.0.0-beta'; Message = 'lorem ipsum'; Expected = '1.0.0-beta.1' },
            @{ Version = '1.0.0-rc.1'; Message = 'lorem ipsum'; Expected = '1.0.0-rc.2' },
            @{ Version = '1.0.0+build.1'; Message = 'lorem ipsum'; Expected = '1.0.1+build.1' }	
        )

        It "increments version <Version> correctly with message <Message>" -TestCases $testCases {
            Param($Version, $Message, $Expected)

            $result = Increment-SemVer -semVerString $Version -commitMessage $Message
            $result | Should -Be $Expected
        }
    }

    Context "Valid Semantic Versions" {
        It "correctly parses <Version>" -TestCases @(
            @{ Version = '1.0.0' },
            @{ Version = '1.0.0-alpha' },
            @{ Version = '1.0.0-alpha.1' },
            @{ Version = '1.0.0-0.3.7' },
            @{ Version = '1.0.0-x.7.z.92' },
            @{ Version = '1.0.0+20130313144700' },
            @{ Version = '1.0.0-beta+exp.sha.5114f85' },
            @{ Version = '1.0.0+21AF26D3' },
            @{ Version = '1.0.0-alpha+001' },
            @{ Version = '1.0.0+20230313144700' },
            @{ Version = '1.0.0-alpha.beta' },
            @{ Version = '1.0.0-beta' },
            @{ Version = '1.2.3-4' },
            @{ Version = '2.0.0+build.1848' },
            @{ Version = '2.1.0-rc.1+build.123' }
        ) {
            Param($Version)
            { Parse-SemVer -semVerString $Version } | Should -Not -Throw
        }
    }
    
    Context "Invalid Semantic Versions" {
        It "throws an error for invalid version <Version>" -TestCases @(
            @{ Version = 'invalid.version' },
            @{ Version = '1.0' },
            @{ Version = '1' },
            @{ Version = '1.0.0-alpha_beta' },
            @{ Version = '-1.0.0' },
            @{ Version = '1.0.0-' },
            @{ Version = '1.0.0+' }
        ) {
            Param($Version)
            { Parse-SemVer -semVerString $Version } | Should -Throw
        }
    }
    
}
