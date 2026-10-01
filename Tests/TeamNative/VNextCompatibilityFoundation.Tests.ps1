Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$sourceRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path

function Write-FoundationFixture {
    param([string]$Path, [string]$Content)
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Get-FoundationFingerprint {
    param([string]$Root)
    (@(Get-ChildItem -LiteralPath $Root -File -Recurse -Force | ForEach-Object {
        $_.FullName.Substring($Root.Length) + ':' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    } | Sort-Object) -join "`n")
}

function Remove-FoundationExpectedErrorRecords {
    param([string]$TargetRoot)
    # Pester 3 retains caught exceptions. Remove only the negative cases this
    # file verifies; leave unrelated errors for the repository runner to reject.
    foreach ($record in @($Error)) {
        $message = $record.Exception.Message
        $expected = $message -in @('synthetic late platform failure', 'failure after backfill')
        $expected = $expected -or ($message -like 'Frozen Memory path is not a Shared Skill retirement candidate: */SKILL.md')
        $expected = $expected -or ($message -ceq 'Invalid retired Shared Skill declaration: ./memory-ops/SKILL.md')
        $expected = $expected -or ($message -like 'Deployment.LinkedPath:*' -and $message.Contains($TargetRoot))
        $expected = $expected -or ($record.FullyQualifiedErrorId -match '^SharedPolicy.TargetFileMissing' -and $message.Contains($TargetRoot))
        if ($expected) { $Error.Remove($record) }
    }
}

Describe 'vNext foundation ownership and exception recovery' {
    BeforeEach {
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
        Import-Module (Join-Path $sourceRepo 'Scripts/modules/Deployment.Transaction.psm1') -Force
    }
    AfterEach { Remove-FoundationExpectedErrorRecords -TargetRoot $target }

    It 'restores all selected platform entries, Shared files and versions after a late exception' {
        foreach ($relative in @('.agents/shared/policy.md', '.agents/skills/local/SKILL.md',
            '.agents/VERSION', '.codex/AGENTS.md', '.codex/VERSION', '.codex/config.toml',
            '.claude/CLAUDE.md', '.claude/VERSION', '.claude/settings.local.json',
            '.cursor/rules/00-core.mdc', '.cursor/VERSION', '.gitignore',
            '.agents/memory/card.md', '.agents/context/CONTEXT.md', '.cartridge/index.json')) {
            Write-FoundationFixture (Join-Path $target $relative) "original $relative"
        }
        $before = Get-FoundationFingerprint $target
        {
            Invoke-DeploymentTransaction -TargetRoot $target -Action {
                Write-FoundationFixture (Join-Path $target '.agents/shared/policy.md') 'changed Shared'
                Write-FoundationFixture (Join-Path $target '.agents/skills/new/SKILL.md') 'new skill'
                foreach ($platform in @('.agents', '.codex', '.claude', '.cursor')) {
                    Write-FoundationFixture (Join-Path $target "$platform/VERSION") 'false success'
                }
                Remove-Item -LiteralPath (Join-Path $target '.codex/AGENTS.md')
                throw 'synthetic late platform failure'
            }
        } | Should Throw 'synthetic late platform failure'
        (Get-FoundationFingerprint $target) | Should Be $before
        (Test-Path (Join-Path $target '.agents/skills/new')) | Should Be $false
    }

    It 'restores a structured failed Manager result while preserving the failure status' {
        Write-FoundationFixture (Join-Path $target '.codex/VERSION') 'old'
        $result = Invoke-DeploymentTransaction -TargetRoot $target -Action {
            Write-FoundationFixture (Join-Path $target '.codex/VERSION') 'new'
            [PSCustomObject]@{ Succeeded = $false; RequiredStageResults = @('failed') }
        }
        $result.Succeeded | Should Be $false
        $result.RolledBack | Should Be $true
        [IO.File]::ReadAllText((Join-Path $target '.codex/VERSION')) | Should Be 'old'
    }

    It 'keeps a successful batch and does not manufacture a version marker' {
        Invoke-DeploymentTransaction -TargetRoot $target -Action {
            Write-FoundationFixture (Join-Path $target '.agents/shared/policy.md') 'new'
        }
        [IO.File]::ReadAllText((Join-Path $target '.agents/shared/policy.md')) | Should Be 'new'
        (Test-Path (Join-Path $target '.codex/VERSION')) | Should Be $false
    }

    It 'rejects an existing managed junction before entering the write action' {
        $outside = Join-Path $TestDrive 'linked-owner'
        Write-FoundationFixture (Join-Path $outside 'user.md') 'user data'
        $null = New-Item -ItemType Junction -Path (Join-Path $target '.codex') -Target $outside
        try {
            { Invoke-DeploymentTransaction -TargetRoot $target -Action { throw 'must not run' } } | Should Throw 'Deployment.LinkedPath'
            [IO.File]::ReadAllText((Join-Path $outside 'user.md')) | Should Be 'user data'
        } finally { [IO.Directory]::Delete((Join-Path $target '.codex')) }
    }

    It 'removes only a newly backfilled junction during recovery, preserving its target' {
        $projectSkill = Join-Path $target '.agents/project_skills/project-demo'
        Write-FoundationFixture (Join-Path $projectSkill 'SKILL.md') 'project skill'
        {
            Invoke-DeploymentTransaction -TargetRoot $target -Action {
                $null = New-Item -ItemType Directory -Path (Join-Path $target '.agents/skills') -Force
                $null = New-Item -ItemType Junction -Path (Join-Path $target '.agents/skills/project-demo') -Target $projectSkill
                throw 'failure after backfill'
            }
        } | Should Throw 'failure after backfill'
        [IO.File]::ReadAllText((Join-Path $projectSkill 'SKILL.md')) | Should Be 'project skill'
        (Test-Path (Join-Path $target '.agents/skills/project-demo')) | Should Be $false
    }

    It 'rejects a dangling managed junction before any write can follow it' {
        $outside = Join-Path $TestDrive 'dangling-owner'
        $null = New-Item -ItemType Directory -Path $outside
        $linkPath = Join-Path $target '.codex'
        $null = New-Item -ItemType Junction -Path $linkPath -Target $outside
        [IO.Directory]::Delete($outside)
        try {
            { Invoke-DeploymentTransaction -TargetRoot $target -Action { throw 'must not run' } } | Should Throw 'Deployment.LinkedPath'
            (Test-Path -LiteralPath $outside) | Should Be $false
        } finally { [IO.Directory]::Delete($linkPath) }
    }

    It 'preserves unknown orphan files, protected files, and unrelated empty directories with a report' {
        Import-Module (Join-Path $sourceRepo 'Scripts/modules/Core.Cleanup.psm1') -Force
        Write-FoundationFixture (Join-Path $target 'unknown.md') 'user'
        Write-FoundationFixture (Join-Path $target 'memory/card.md') 'memory'
        $null = New-Item -ItemType Directory -Path (Join-Path $target 'empty')
        $before = Get-FoundationFingerprint $target
        $report = @([PSCustomObject]@{ Path = 'unknown.md'; Status = 'ORPHAN' },
            [PSCustomObject]@{ Path = 'memory/card.md'; Status = 'ORPHAN' })
        $messages = @(Remove-OrphanFiles -Report $report -TargetRoot $target -ProtectedDirs @('memory') 6>&1)
        ($messages | Out-String) | Should Match 'preserved_unknown_ownership'
        (Get-FoundationFingerprint $target) | Should Be $before
        (Test-Path (Join-Path $target 'empty')) | Should Be $true
    }

    It 'retires only exact synthetic historical bytes and reports same-path modifications' {
        $module = Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force -PassThru
        Write-FoundationFixture (Join-Path $target 'legacy/SKILL.md') 'official'
        Write-FoundationFixture (Join-Path $target 'unknown/SKILL.md') 'user'
        $hash = (Get-FileHash (Join-Path $target 'legacy/SKILL.md')).Hash
        & $module { param($hash)
            $script:fixtureHash = $hash
            function script:Get-RetiredSharedSkillManifest {
                [PSCustomObject]@{ RelativePath = 'legacy/SKILL.md'; KnownSha256 = @($script:fixtureHash) }
            }
        } $hash
        try {
            $result = & $module { param($path) Remove-RetiredSharedSkills -TargetSkillsPath $path } $target
            $result.Removed.Count | Should Be 1
            (Test-Path (Join-Path $target 'unknown/SKILL.md')) | Should Be $true
            Write-FoundationFixture (Join-Path $target 'legacy/SKILL.md') 'user modification'
            $result = & $module { param($path) Remove-RetiredSharedSkills -TargetSkillsPath $path } $target
            $result.Preserved.Count | Should Be 1
            [IO.File]::ReadAllText((Join-Path $target 'legacy/SKILL.md')) | Should Be 'user modification'
        } finally { Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force }
    }

    It 'rejects active frozen Memory Skills even if injected into a retirement allowlist' {
        $module = Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force -PassThru
        try {
            foreach ($name in @('memory-ops', 'memory-arch')) {
                Write-FoundationFixture (Join-Path $target "$name/SKILL.md") 'frozen'
                $hash = (Get-FileHash (Join-Path $target "$name/SKILL.md")).Hash
                & $module { param($name, $hash)
                    $script:fixtureArtifact = [PSCustomObject]@{ RelativePath = "$name/SKILL.md"; KnownSha256 = @($hash) }
                    function script:Get-RetiredSharedSkillManifest { $script:fixtureArtifact }
                } $name $hash
                { & $module { param($path) Remove-RetiredSharedSkills -TargetSkillsPath $path } $target } | Should Throw 'Frozen Memory'
                [IO.File]::ReadAllText((Join-Path $target "$name/SKILL.md")) | Should Be 'frozen'
            }
        } finally { Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force }
    }

    It 'rejects a noncanonical path that would bypass frozen Memory classification' {
        $module = Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force -PassThru
        Write-FoundationFixture (Join-Path $target 'memory-ops/SKILL.md') 'frozen'
        $hash = (Get-FileHash (Join-Path $target 'memory-ops/SKILL.md')).Hash
        & $module { param($hash)
            $script:fixtureHash = $hash
            function script:Get-RetiredSharedSkillManifest {
                [PSCustomObject]@{ RelativePath = './memory-ops/SKILL.md'; KnownSha256 = @($script:fixtureHash) }
            }
        } $hash
        try {
            { & $module { param($path) Remove-RetiredSharedSkills -TargetSkillsPath $path } $target } | Should Throw 'Invalid retired Shared Skill declaration'
            [IO.File]::ReadAllText((Join-Path $target 'memory-ops/SKILL.md')) | Should Be 'frozen'
        } finally { Import-Module (Join-Path $sourceRepo 'Scripts/modules/Skills-Sync.psm1') -Force }
    }
}

Describe 'vNext foundation official project deployment batch' {
    BeforeEach {
        $script:foundationBatchSource = Join-Path $TestDrive 'batch-source'
        $script:foundationBatchTarget = Join-Path $TestDrive 'batch-target'
    }
    AfterEach {
        Remove-FoundationExpectedErrorRecords -TargetRoot $script:foundationBatchTarget
        # Copied source modules must not leak into later repository test suites.
        Get-Module -All | Where-Object {
            $_.Path -and $_.Path.StartsWith($script:foundationBatchSource + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)
        } | Remove-Module -Force
    }
    It 'runs four-platform Fresh Upgrade Sync in isolation and recovers a late Cursor Sync failure' {
        $fixtureSource = $script:foundationBatchSource
        $fixtureTarget = $script:foundationBatchTarget
        $null = New-Item -ItemType Directory -Path $fixtureSource, $fixtureTarget
        foreach ($dir in @('Scripts', 'Shared', 'Antigravity', 'Claude', 'Codex', 'Cursor')) {
            Copy-Item -LiteralPath (Join-Path $sourceRepo $dir) -Destination $fixtureSource -Recurse -Force
        }
        foreach ($relative in @('.agents/memory/card.md', '.agents/context/user.md', '.cartridge/index.json',
            '.claude/settings.local.json', '.codex/hooks/user.ps1')) {
            Write-FoundationFixture (Join-Path $fixtureTarget $relative) "protected $relative"
        }
        $protected = @{}
        Get-ChildItem -LiteralPath $fixtureTarget -Recurse -File -Force | ForEach-Object {
            $protected[$_.FullName] = (Get-FileHash -LiteralPath $_.FullName).Hash
        }
        # Dot-source the actual dispatcher against copied canonical source only.
        . (Join-Path $fixtureSource 'Scripts/Deploy.ps1') -Platform All -Mode Fresh -Target $fixtureTarget
        foreach ($name in @('Antigravity', 'Claude', 'Codex', 'Cursor')) {
            $platformPath = [IO.Path]::GetFullPath((Join-Path $fixtureSource "Scripts/modules/Platform-$name.psm1"))
            $matches = @(Get-Module "Platform-$name" | Where-Object { $_.Path -eq $platformPath })
            $matches.Count | Should Be 1
            $platformModule = $matches[0]
            & $platformModule { function script:Invoke-ConfirmGate { return $true } }
        }
        Invoke-ProjectDeployBatch -SelectedPlatform All -SelectedMode Upgrade -SelectedTarget $fixtureTarget
        Invoke-ProjectDeployBatch -SelectedPlatform All -SelectedMode Sync -SelectedTarget $fixtureTarget
        foreach ($path in $protected.Keys) { (Get-FileHash -LiteralPath $path).Hash | Should Be $protected[$path] }
        foreach ($runtimeFolder in @('.agents', '.claude', '.codex', '.cursor')) {
            (Test-Path (Join-Path $fixtureTarget "$runtimeFolder/VERSION")) | Should Be $true
        }
        $generated = [IO.File]::ReadAllText((Join-Path $fixtureTarget '.codex/AGENTS.md'))
        $generated | Should Match 'AI_RULES_SHARED_SUBAGENT_POLICY_START'
        $generated | Should Match 'generated pointer'
        # Refusing the final platform must undo earlier platform writes too.
        Write-FoundationFixture (Join-Path $fixtureSource 'Shared/skills/synthetic/SKILL.md') 'future source'
        [IO.File]::AppendAllText((Join-Path $fixtureSource 'Cursor/.cursor/rules/00-core.mdc'), "`nnew source rule")
        $cursorPath = [IO.Path]::GetFullPath((Join-Path $fixtureSource 'Scripts/modules/Platform-Cursor.psm1'))
        $cursorMatches = @(Get-Module 'Platform-Cursor' | Where-Object { $_.Path -eq $cursorPath })
        $cursorMatches.Count | Should Be 1
        $cursorModule = $cursorMatches[0]
        & $cursorModule { function script:Invoke-ConfirmGate { return $false } }
        $beforeDecline = Get-FoundationFingerprint $fixtureTarget
        $declined = @(Invoke-ProjectDeployBatch -SelectedPlatform All -SelectedMode Upgrade -SelectedTarget $fixtureTarget |
            Where-Object { $null -ne $_ -and $null -ne $_.PSObject.Properties['Succeeded'] })
        $declined.Count | Should Be 1
        $declined[0].Succeeded | Should Be $false
        $declined[0].RolledBack | Should Be $true
        (Get-FoundationFingerprint $fixtureTarget) | Should Be $beforeDecline
        # Change Shared source so the first stages really write before Cursor fails.
        Remove-Item -LiteralPath (Join-Path $fixtureTarget '.cursor/rules/00-core.mdc')
        $before = Get-FoundationFingerprint $fixtureTarget
        { Invoke-ProjectDeployBatch -SelectedPlatform All -SelectedMode Sync -SelectedTarget $fixtureTarget } | Should Throw 'TargetFileMissing'
        (Get-FoundationFingerprint $fixtureTarget) | Should Be $before
        (Test-Path (Join-Path $fixtureTarget '.agents/skills/synthetic/SKILL.md')) | Should Be $false
    }
}

Describe 'vNext foundation declined platform upgrade' {
    It 'preserves every file and returns a failed result when <Name> upgrade is declined' -TestCases @(
        @{ Name = 'Antigravity' }, @{ Name = 'Claude' }, @{ Name = 'Codex' }, @{ Name = 'Cursor' }
    ) {
        param($Name)
        $declineTarget = Join-Path $TestDrive ('decline-' + $Name)
        foreach ($relative in @('.agents/rules/AGENTS.md', '.agents/VERSION', '.claude/CLAUDE.md',
            '.claude/VERSION', '.codex/AGENTS.md', '.codex/VERSION', '.cursor/rules/00-core.mdc', '.cursor/VERSION')) {
            Write-FoundationFixture (Join-Path $declineTarget $relative) 'old local content'
        }
        $platformModule = Import-Module (Join-Path $sourceRepo "Scripts/modules/Platform-$Name.psm1") -Force -PassThru
        & $platformModule { function script:Invoke-ConfirmGate { return $false } }
        $before = Get-FoundationFingerprint $declineTarget
        $result = & $platformModule {
            param($name, $root, $target)
            $command = if ($name -eq 'Antigravity') { 'Invoke-AgUpgrade' } else { "Invoke-${name}Upgrade" }
            & $command -FrameworkRoot (Join-Path $root $name) -Target $target -SharedSkillsRoot (Join-Path $root 'Shared/skills')
        } $Name $sourceRepo $declineTarget
        $result.Succeeded | Should Be $false
        $result.Reason | Should Be 'UpgradeDeclined'
        (Get-FoundationFingerprint $declineTarget) | Should Be $before
    }
}
