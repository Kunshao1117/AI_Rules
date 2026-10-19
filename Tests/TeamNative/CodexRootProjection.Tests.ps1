#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$rootRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $rootRepo 'Scripts/modules/Codex-Root-Projection.psm1') -Force
Import-Module (Join-Path $rootRepo 'Scripts/modules/Platform-Codex.psm1') -Force
Import-Module (Join-Path $rootRepo 'Scripts/modules/Manager.Config.psm1') -Force

Import-Module (Join-Path $rootRepo 'Scripts/modules/Deployment.Transaction.psm1') -Force

Describe 'Codex native root instruction projection' {
    BeforeEach {
        $project = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path (Join-Path $project '.codex') -Force
        $core = Join-Path $project '.codex/AGENTS.md'
        $rootEntry = Join-Path $project 'AGENTS.md'
        $receipt = Join-Path $project '.codex/ai-rules-root-agents.json'
        [IO.File]::WriteAllText($core, "# Core`n完整規則`n## [PROJECT IDENTITY]`nlocal identity`n<!-- /PROJECT_IDENTITY_END -->`n", [Text.UTF8Encoding]::new($false))
    }

    It 'projects the complete body without a model read bridge and is byte-idempotent' {
        Sync-CodexRootProjection -TargetRoot $project
        $body = Get-Content -LiteralPath $core -Raw -Encoding UTF8
        $text = Get-Content -LiteralPath $rootEntry -Raw -Encoding UTF8
        $text.EndsWith($body) | Should Be $true
        $text.Contains('local identity') | Should Be $true
        $state = Get-Content -LiteralPath $receipt -Raw | ConvertFrom-Json
        $state.sha256 | Should Be (Get-FileHash -LiteralPath $rootEntry).Hash.ToLowerInvariant()
        $before = (Get-FileHash -LiteralPath $rootEntry).Hash
        $stamp = (Get-Item -LiteralPath $rootEntry).LastWriteTimeUtc
        Sync-CodexRootProjection -TargetRoot $project
        (Get-FileHash -LiteralPath $rootEntry).Hash | Should Be $before
        (Get-Item -LiteralPath $rootEntry).LastWriteTimeUtc | Should Be $stamp
        [IO.File]::AppendAllText($core, "updated core`n")
        Sync-CodexRootProjection -TargetRoot $project
        (Get-Content -LiteralPath $rootEntry -Raw).Contains('updated core') | Should Be $true
    }

    It 'preserves an unowned root even when its content matches the canonical source' {
        Copy-Item -LiteralPath $core -Destination $rootEntry
        $before = (Get-FileHash -LiteralPath $rootEntry).Hash
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.UnownedOrIncomplete'
        (Get-FileHash -LiteralPath $rootEntry).Hash | Should Be $before
        (Test-Path -LiteralPath $receipt) | Should Be $false
    }

    It 'preserves a user-edited generated root' {
        Sync-CodexRootProjection -TargetRoot $project
        [IO.File]::AppendAllText($rootEntry, 'user edit')
        $before = (Get-FileHash -LiteralPath $rootEntry).Hash
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.ModifiedOrInvalidReceipt'
        (Get-FileHash -LiteralPath $rootEntry).Hash | Should Be $before
    }

    It 'rejects a missing member of an existing root receipt pair' {
        Sync-CodexRootProjection -TargetRoot $project
        Remove-Item -LiteralPath $rootEntry
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.UnownedOrIncomplete'
        (Test-Path -LiteralPath $rootEntry) | Should Be $false
    }

    It 'never follows a receipt-supplied target path' {
        Sync-CodexRootProjection -TargetRoot $project
        $text = (Get-Content -LiteralPath $receipt -Raw).Replace('"target":"AGENTS.md"', '"target":"../outside.md"')
        [IO.File]::WriteAllText($receipt, $text)
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.ModifiedOrInvalidReceipt'
        (Test-Path -LiteralPath (Join-Path $TestDrive 'outside.md')) | Should Be $false
    }

    It 'blocks a higher-priority override without writing the root' {
        [IO.File]::WriteAllText((Join-Path $project 'AGENTS.override.md'), 'user override')
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.OverridePresent'
        (Test-Path -LiteralPath $rootEntry) | Should Be $false
        (Get-Content -LiteralPath (Join-Path $project 'AGENTS.override.md') -Raw) | Should Be 'user override'
    }

    It 'rejects a directory at the root entry' {
        $null = New-Item -ItemType Directory -Path $rootEntry
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'CodexRoot.NotFile'
    }

    It 'rolls back both new projection files after a later batch failure' {
        { Invoke-DeploymentTransaction -TargetRoot $project -AdditionalManagedPaths @('AGENTS.md') -Action {
            Sync-CodexRootProjection -TargetRoot $project
            throw 'CodexRoot.TestLateFailure'
        } } | Should Throw 'CodexRoot.TestLateFailure'
        (Test-Path -LiteralPath $rootEntry) | Should Be $false
        (Test-Path -LiteralPath $receipt) | Should Be $false
        (Test-Path -LiteralPath $core) | Should Be $true
    }

    It 'rolls back an existing pair to its exact previous bytes' {
        Sync-CodexRootProjection -TargetRoot $project
        $before = (Get-FileHash -LiteralPath $rootEntry).Hash
        $receiptBefore = (Get-FileHash -LiteralPath $receipt).Hash
        { Invoke-DeploymentTransaction -TargetRoot $project -AdditionalManagedPaths @('AGENTS.md') -Action {
            [IO.File]::AppendAllText($core, 'new source body')
            Sync-CodexRootProjection -TargetRoot $project
            throw 'CodexRoot.TestExistingFailure'
        } } | Should Throw 'CodexRoot.TestExistingFailure'
        (Get-FileHash -LiteralPath $rootEntry).Hash | Should Be $before
        (Get-FileHash -LiteralPath $receipt).Hash | Should Be $receiptBefore
    }

    It 'supports exact persistent backup and restore of the fixed root path' {
        Sync-CodexRootProjection -TargetRoot $project
        $before = (Get-FileHash -LiteralPath $rootEntry).Hash
        $stateBefore = (Get-FileHash -LiteralPath $receipt).Hash
        $entries = @(
            [pscustomobject]@{ RelativePath='AGENTS.md'; KnownSha256=@($before); IntendedSha256=$before },
            [pscustomobject]@{ RelativePath='.codex/ai-rules-root-agents.json'; KnownSha256=@($stateBefore); IntendedSha256=$stateBefore }
        )
        $point = New-DeploymentRollbackPoint -TargetRoot $project -StoreRoot (Join-Path $TestDrive 'backups') -Entries $entries -SourceRevision 'test' -Platform 'Codex' -RuntimeInstance 'test'
        Complete-DeploymentRollbackPoint -Path $point -TargetRoot $project
        $result = Restore-DeploymentRollbackPoint -Path $point -TargetRoot $project
        $result.Restored | Should Be $true
        (Get-FileHash -LiteralPath $rootEntry).Hash | Should Be $before
    }

    It 'stops before Fresh writes when the project has user root rules' {
        [IO.File]::WriteAllText($rootEntry, 'my rules')
        $before = (Get-FileHash -LiteralPath $core).Hash
        { Invoke-CodexFresh -FrameworkRoot (Join-Path $rootRepo 'Codex') -Target $project -SharedSkillsRoot (Join-Path $rootRepo 'Shared/skills') } | Should Throw 'CodexRoot.UnownedOrIncomplete'
        (Get-FileHash -LiteralPath $core).Hash | Should Be $before
        (Test-Path -LiteralPath (Join-Path $project '.agents')) | Should Be $false
    }

    It 'does not add unrelated root instructions to a non-Codex transaction' {
        [IO.File]::WriteAllText($rootEntry, 'user-owned root')
        Invoke-DeploymentTransaction -TargetRoot $project -Action {
            [IO.File]::AppendAllText($core, 'normal managed change')
        }
        (Get-Content -LiteralPath $rootEntry -Raw) | Should Be 'user-owned root'
        $module = Get-Module 'Deployment.Transaction'
        $managed = @(& $module { param($p) Get-DeploymentManagedPaths -TargetRoot $p } $project)
        ($managed -contains $rootEntry) | Should Be $false
    }

    It 'preserves a linked root and does not block a non-Codex transaction' -Skip:([IO.Path]::DirectorySeparatorChar -eq '\') {
        $outside = Join-Path $TestDrive 'external-root.md'
        [IO.File]::WriteAllText($outside, 'external root')
        $null = New-Item -ItemType SymbolicLink -Path $rootEntry -Target $outside
        Invoke-DeploymentTransaction -TargetRoot $project -Action { }
        { Sync-CodexRootProjection -TargetRoot $project } | Should Throw 'Deployment.LinkedPath'
        (Get-Content -LiteralPath $outside -Raw) | Should Be 'external root'
    }

    It 'plans both native files and preserves identity in exact Upgrade projection bytes' {
        Import-Module (Join-Path $rootRepo 'Scripts/modules/Deployment.Cohort.psm1') -Force
        Import-Module (Join-Path $rootRepo 'Scripts/modules/Deployment.Preflight.psm1') -Force
        $plan = @(Get-DeploymentUpgradePreflight -RepoRoot $rootRepo -TargetRoot $project)
        $entries = @($plan | Where-Object { $_.content_type -eq 'CodexRootProjection' })
        $entries.Count | Should Be 2
        @($entries | Where-Object blocking).Count | Should Be 0
        $rootPlan = @($entries | Where-Object target_path -eq 'AGENTS.md')[0]
        $projection = Get-CohortProjectedBytes -RepoRoot $rootRepo -TargetRoot $project -Record $rootPlan
        ([Text.Encoding]::UTF8.GetString($projection.Bytes)).Contains('local identity') | Should Be $true
        $module = Import-Module (Join-Path $rootRepo 'Scripts/modules/Platform-Codex.psm1') -Force -PassThru
        & $module { Set-Item Function:Invoke-ConfirmGate { return $true } }
        $null = & $module { param($r,$p) Invoke-CodexUpgrade -FrameworkRoot (Join-Path $r 'Codex') -Target $p -SharedSkillsRoot (Join-Path $r 'Shared/skills') } $rootRepo $project
        foreach ($entry in $entries) {
            [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $project $entry.target_path))) | Should Be $entry.projected_bytes_base64
        }
        # Force-imports above can remove shared module exports in Windows PowerShell.
        Import-Module (Join-Path $rootRepo 'Scripts/modules/Deployment.Transaction.psm1') -Force
    }

    It 'does not inject a fallback and preserves existing root and project table values' {
        $source = Join-Path $rootRepo 'Codex/.codex/config.toml'
        foreach ($merge in @('Merge-CodexConfigDefaults', 'Merge-ManagerCodexProjectConfigDefaults')) {
            $target = Join-Path $project ($merge + '.toml')
            $null = & $merge -SourcePath $source -TargetPath $target -Apply
            (Get-Content -LiteralPath $target -Raw).Contains('project_doc_fallback_filenames') | Should Be $false
            $original = "project_doc_fallback_filenames = [`"USER.md`"]`n[projects.'D:\\project']`nproject_doc_fallback_filenames = [`".codex/AGENTS.md`"]`ntrust_level = `"trusted`"`n"
            [IO.File]::WriteAllText($target, $original)
            $null = & $merge -SourcePath $source -TargetPath $target -Apply
            (Get-Content -LiteralPath $target -Raw).StartsWith($original) | Should Be $true
        }
    }
}
