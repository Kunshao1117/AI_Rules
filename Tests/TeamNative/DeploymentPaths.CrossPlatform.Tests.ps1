#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$pathRepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $pathRepoRoot 'Scripts/modules/Deployment.Transaction.psm1') -Force
$script:pathIsWindows = [IO.Path]::DirectorySeparatorChar -eq '\'

Describe 'Deployment filesystem relative paths' {
    BeforeEach {
        $pathRoot = Join-Path ([IO.Path]::GetTempPath()) 'deployment root 中文 # %20'
    }

    It 'preserves literal Unicode spaces hashes and percent-encoded-looking names' {
        foreach ($name in @('中文 space.txt', '#fragment.txt', '100%.txt', '%20%2F%23.txt')) {
            (Get-DeploymentRelativePath -Root $pathRoot -Path (Join-Path $pathRoot $name)) | Should Be $name
        }
    }

    It 'normalizes dot segments and trailing separators before deriving a descendant' {
        $path = Join-Path $pathRoot 'first/../nested/child.txt'
        $expected = 'nested' + [IO.Path]::DirectorySeparatorChar + 'child.txt'
        (Get-DeploymentRelativePath -Root ($pathRoot + [IO.Path]::DirectorySeparatorChar) -Path $path) | Should Be $expected
    }

    It 'supports a filesystem root' {
        $root = [IO.Path]::GetPathRoot([IO.Path]::GetFullPath($pathRoot))
        (Get-DeploymentRelativePath -Root $root -Path (Join-Path $root 'child.txt')) | Should Be 'child.txt'
    }

    It 'rejects a sibling sharing only the root prefix' {
        { Get-DeploymentRelativePath -Root $pathRoot -Path ($pathRoot + '-outside/file.txt') } | Should Throw 'Deployment.PathOutsideRoot'
    }

    It 'rejects a parent traversal outside the root' {
        { Get-DeploymentRelativePath -Root $pathRoot -Path (Join-Path $pathRoot '../outside.txt') } | Should Throw 'Deployment.PathOutsideRoot'
    }

    It 'rejects the root itself instead of treating it as a descendant' {
        { Get-DeploymentRelativePath -Root $pathRoot -Path $pathRoot } | Should Throw 'Deployment.PathOutsideRoot'
    }

    It 'rejects a differently cased Unix root' -Skip:$script:pathIsWindows {
        { Get-DeploymentRelativePath -Root '/tmp/DeploymentRoot' -Path '/tmp/deploymentroot/child.txt' } | Should Throw 'Deployment.PathOutsideRoot'
    }

    It 'preserves a literal Unix backslash in the root and child name' -Skip:$script:pathIsWindows {
        (Get-DeploymentRelativePath -Root '/tmp/root\' -Path '/tmp/root\/child\name.txt') | Should Be 'child\name.txt'
    }

    It 'accepts Windows case differences and alternate separators' -Skip:(-not $script:pathIsWindows) {
        (Get-DeploymentRelativePath -Root 'C:\Root' -Path 'c:/root/Child.txt') | Should Be 'Child.txt'
    }

    It 'supports a Windows UNC share without contacting a server' -Skip:(-not $script:pathIsWindows) {
        (Get-DeploymentRelativePath -Root '\\server\share\root' -Path '\\server\share\root\中文 #%20.txt') | Should Be '中文 #%20.txt'
    }

    It 'rejects a different Windows UNC share' -Skip:(-not $script:pathIsWindows) {
        { Get-DeploymentRelativePath -Root '\\server\share\root' -Path '\\server\other\root\child.txt' } | Should Throw 'Deployment.PathOutsideRoot'
    }

    It 'normalizes an actual Windows short-path alias before slicing' -Skip:(-not $script:pathIsWindows) {
        $folder = Join-Path $TestDrive 'Long directory name'
        $null = New-Item -ItemType Directory -Path $folder
        $fso = New-Object -ComObject Scripting.FileSystemObject
        $short = $fso.GetFolder($folder).ShortPath
        ($short -cne $folder) | Should Be $true
        (Get-DeploymentRelativePath -Root $short -Path (Join-Path $folder 'child.txt')) | Should Be 'child.txt'
    }
}

Describe 'Shared skill policy projection cross-platform paths' {
    BeforeEach {
        Import-Module (Join-Path $pathRepoRoot 'Scripts/modules/Skills-Sync.psm1') -Force
        $projectionRoot = Join-Path $TestDrive ('source 中文 # %20 ' + [guid]::NewGuid().ToString('N'))
        $sharedSkills = Join-Path $projectionRoot 'Shared/skills'
        $skill = Join-Path $sharedSkills 'sample/SKILL.md'
        foreach ($relative in @('Shared/skills/sample', 'Shared/policies', 'Shared/policies-other', 'outside', 'project/.agents/skills')) {
            $null = New-Item -ItemType Directory -Path (Join-Path $projectionRoot $relative) -Force
        }
        [IO.File]::WriteAllText((Join-Path $projectionRoot 'Shared/policies/guard.md'), 'policy')
        [IO.File]::WriteAllText((Join-Path $projectionRoot 'Shared/policies-other/guard.md'), 'outside policy root')
        [IO.File]::WriteAllText($skill, '[Policy](../../policies/guard.md#anchor)' + "`n" + '[Other](../../policies-other/guard.md)')
        $targetSkills = Join-Path $projectionRoot 'project/.agents/skills'
    }

    It 'projects only policy-root links without changing the source bytes' {
        $before = (Get-FileHash -LiteralPath $skill).Hash
        $bytes = Get-SharedSkillProjectedBytes -SourcePath $skill -SharedSkillsRoot $sharedSkills -TargetSkillsPath $targetSkills
        $text = [Text.Encoding]::UTF8.GetString($bytes)
        $text | Should Match '\.\./\.\./shared/policies/guard\.md#anchor'
        $text | Should Match '\.\./\.\./policies-other/guard\.md'
        (Get-FileHash -LiteralPath $skill).Hash | Should Be $before
    }

    It 'rejects a differently cased Unix shared skills root' -Skip:$script:pathIsWindows {
        $differentRoot = $sharedSkills.Replace('/Shared/', '/shared/')
        { Get-SharedSkillProjectedBytes -SourcePath $skill -SharedSkillsRoot $differentRoot -TargetSkillsPath $targetSkills } | Should Throw 'SkillProjection.SourceOutsideRoot'
    }

    It 'does not project a differently cased Unix policy directory' -Skip:$script:pathIsWindows {
        $otherPolicy = Join-Path $projectionRoot 'Shared/Policies/guard.md'
        $null = New-Item -ItemType Directory -Path (Split-Path $otherPolicy -Parent) -Force
        [IO.File]::WriteAllText($otherPolicy, 'different directory')
        $original = '[Other](../../Policies/guard.md)'
        [IO.File]::WriteAllText($skill, $original)
        $bytes = Get-SharedSkillProjectedBytes -SourcePath $skill -SharedSkillsRoot $sharedSkills -TargetSkillsPath $targetSkills
        [Text.Encoding]::UTF8.GetString($bytes) | Should Be $original
    }

    It 'rejects an existing source file outside the shared skills root' {
        $outside = Join-Path $projectionRoot 'outside/SKILL.md'
        [IO.File]::WriteAllText($outside, 'outside')
        { Get-SharedSkillProjectedBytes -SourcePath $outside -SharedSkillsRoot $sharedSkills -TargetSkillsPath $targetSkills } | Should Throw 'SkillProjection.SourceOutsideRoot'
    }
}

$script:pathCodexModule = Import-Module (Join-Path $pathRepoRoot 'Scripts/modules/Platform-Codex.psm1') -Force -PassThru
Import-Module (Join-Path $pathRepoRoot 'Scripts/modules/Deployment.Transaction.psm1') -Force

Describe 'Codex Fresh deployment cross-platform safety' {
    BeforeEach {
        $script:pathTarget = Join-Path $TestDrive ('project 中文 # %20 ' + [guid]::NewGuid().ToString('N'))
        $script:pathPreserved = @{}
        foreach ($relative in @('.agents/memory/core/MEMORY.md', '.agents/context/_map/CONTEXT.md', '.agents/project_skills/_index.md', '.cartridge/index.json', 'src/user.txt')) {
            $file = Join-Path $script:pathTarget $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
            [IO.File]::WriteAllText($file, "user-owned: $relative", [Text.UTF8Encoding]::new($false))
            $script:pathPreserved[$file] = (Get-FileHash -LiteralPath $file).Hash
        }
    }

    It 'runs the official Fresh entry with skills and preserves existing user data' {
        $hostExe = (Get-Process -Id $PID).Path
        $output = @(& $hostExe -NoProfile -File (Join-Path $pathRepoRoot 'Scripts/Deploy.ps1') -Platform Codex -Mode Fresh -Target $script:pathTarget 2>&1)
        $LASTEXITCODE | Should Be 0
        (Test-Path -LiteralPath (Join-Path $script:pathTarget '.codex/VERSION')) | Should Be $true
        @(Get-ChildItem -LiteralPath (Join-Path $script:pathTarget '.agents/skills') -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }).Count | Should BeGreaterThan 0
        ($output -join "`n") | Should Match '框架已部署完成'
        foreach ($file in $script:pathPreserved.Keys) {
            (Get-FileHash -LiteralPath $file).Hash | Should Be $script:pathPreserved[$file]
        }
    }

    It 'runs Fresh with protected data when Unix TEMP and TMP are unset' -Skip:$script:pathIsWindows {
        $savedTemp = $env:TEMP; $savedTmp = $env:TMP
        try {
            if (Test-Path Env:TEMP) { Remove-Item Env:TEMP }
            if (Test-Path Env:TMP) { Remove-Item Env:TMP }
            $hostExe = (Get-Process -Id $PID).Path
            $output = @(& $hostExe -NoProfile -File (Join-Path $pathRepoRoot 'Scripts/Deploy.ps1') -Platform Codex -Mode Fresh -Target $script:pathTarget 2>&1)
            $LASTEXITCODE | Should Be 0
        } finally {
            $env:TEMP = $savedTemp; $env:TMP = $savedTmp
        }
        (Test-Path -LiteralPath (Join-Path $script:pathTarget '.codex/VERSION')) | Should Be $true
        ($output -join "`n") | Should Match '框架已部署完成'
        foreach ($file in $script:pathPreserved.Keys) {
            (Get-FileHash -LiteralPath $file).Hash | Should Be $script:pathPreserved[$file]
        }
    }

    It 'rolls back a partial Fresh failure without announcing success' {
        Mock -CommandName Sync-SharedSkills -ModuleName $script:pathCodexModule.Name -MockWith { throw 'synthetic shared skills failure' }
        $script:pathFailureOutput = @()
        {
            Invoke-DeploymentTransaction -TargetRoot $script:pathTarget -Action {
                & $script:pathCodexModule { param($repo, $target) Invoke-CodexFresh -FrameworkRoot (Join-Path $repo 'Codex') -Target $target -SharedSkillsRoot (Join-Path $repo 'Shared/skills') } $pathRepoRoot $script:pathTarget 6>&1 |
                    ForEach-Object { $script:pathFailureOutput += [string]$_ }
            } 3>&1 | ForEach-Object { $script:pathFailureOutput += [string]$_ }
        } | Should Throw 'synthetic shared skills failure'
        (Test-Path -LiteralPath (Join-Path $script:pathTarget '.codex')) | Should Be $false
        ($script:pathFailureOutput -join "`n") | Should Not Match '框架已部署完成'
        foreach ($file in $script:pathPreserved.Keys) {
            (Get-FileHash -LiteralPath $file).Hash | Should Be $script:pathPreserved[$file]
        }
    }

    It 'restores existing managed files after a partial Fresh failure' {
        $managed = Join-Path $script:pathTarget '.codex/AGENTS.md'
        $null = New-Item -ItemType Directory -Path (Split-Path $managed -Parent) -Force
        [IO.File]::WriteAllText($managed, 'existing managed content')
        $before = (Get-FileHash -LiteralPath $managed).Hash
        Mock -CommandName Sync-SharedSkills -ModuleName $script:pathCodexModule.Name -MockWith { throw 'synthetic shared skills failure' }
        {
            Invoke-DeploymentTransaction -TargetRoot $script:pathTarget -Action {
                & $script:pathCodexModule { param($repo, $target) Invoke-CodexFresh -FrameworkRoot (Join-Path $repo 'Codex') -Target $target -SharedSkillsRoot (Join-Path $repo 'Shared/skills') } $pathRepoRoot $script:pathTarget
            }
        } | Should Throw 'synthetic shared skills failure'
        (Get-FileHash -LiteralPath $managed).Hash | Should Be $before
        @(Get-ChildItem -LiteralPath (Split-Path $managed -Parent) -File -Recurse).Count | Should Be 1
        foreach ($file in $script:pathPreserved.Keys) {
            (Get-FileHash -LiteralPath $file).Hash | Should Be $script:pathPreserved[$file]
        }
    }
}

Describe 'Deployment snapshot filesystem case semantics' {
    It 'restores both case-distinct Unix managed files after failure' -Skip:$script:pathIsWindows {
        $target = Join-Path $TestDrive 'case-files'
        $managed = Join-Path $target '.codex'
        $null = New-Item -ItemType Directory -Path $managed -Force
        $upper = Join-Path $managed 'A.md'; $lower = Join-Path $managed 'a.md'
        [IO.File]::WriteAllText($upper, 'original UPPER')
        [IO.File]::WriteAllText($lower, 'original lower')
        {
            Invoke-DeploymentTransaction -TargetRoot $target -Action {
                [IO.File]::WriteAllText($upper, 'changed UPPER')
                [IO.File]::WriteAllText($lower, 'changed lower')
                throw 'synthetic case-files failure'
            }
        } | Should Throw 'synthetic case-files failure'
        [IO.File]::ReadAllText($upper) | Should Be 'original UPPER'
        [IO.File]::ReadAllText($lower) | Should Be 'original lower'
    }

    It 'restores both case-distinct Unix managed directories after failure' -Skip:$script:pathIsWindows {
        $target = Join-Path $TestDrive 'case-directories'
        $upper = Join-Path $target '.codex/Empty'; $lower = Join-Path $target '.codex/empty'
        $null = New-Item -ItemType Directory -Path $upper, $lower -Force
        {
            Invoke-DeploymentTransaction -TargetRoot $target -Action {
                [IO.Directory]::Delete($upper)
                [IO.Directory]::Delete($lower)
                throw 'synthetic case-directories failure'
            }
        } | Should Throw 'synthetic case-directories failure'
        (Test-Path -LiteralPath $upper -PathType Container) | Should Be $true
        (Test-Path -LiteralPath $lower -PathType Container) | Should Be $true
    }

    It 'keeps case-insensitive Windows managed-file lookup' -Skip:(-not $script:pathIsWindows) {
        $target = Join-Path $TestDrive 'case-windows'
        $file = Join-Path $target '.codex/A.md'
        $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
        [IO.File]::WriteAllText($file, 'existing')
        $found = & (Get-Module Deployment.Transaction) {
            param($root, $file)
            $snapshot = New-DeploymentSnapshot -TargetRoot $root
            $snapshot.Files.ContainsKey($file.ToLowerInvariant())
        } $target $file
        $found | Should Be $true
    }
}
