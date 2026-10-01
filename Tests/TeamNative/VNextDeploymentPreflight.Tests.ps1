Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$preflightRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path

function Write-PreflightFixture([string]$Path, [string]$Content) {
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Get-PreflightFixtureFingerprint([string]$Root) {
    return (@(Get-ChildItem -LiteralPath $Root -Recurse -Force | ForEach-Object {
        if ($_.PSIsContainer) { 'D:' + [IO.Path]::GetRelativePath($Root, $_.FullName) }
        else { 'F:' + [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash }
    } | Sort-Object) -join "`n")
}

function Write-PreflightManagedOldSkill([string]$Target) {
    $shared = Join-Path $preflightRepo 'Shared'
    $artifact = @(Get-LegacySkillMigrationArtifacts -SharedRoot $shared | Where-Object { $_.old_relative_path -eq 'delegation-strategy/SKILL.md' })[0]
    $reference = Join-Path $shared $artifact.reference_relative_path
    $bytes = [IO.File]::ReadAllBytes($reference)
    $marker = '<!-- ARCHIVED_SKILL_BODY_START -->' + "`n"
    $content = [Text.Encoding]::UTF8.GetString($bytes)
    $offset = [Text.Encoding]::UTF8.GetByteCount($content.Substring(0, $content.IndexOf($marker) + $marker.Length))
    $null = New-Item -ItemType Directory -Path (Split-Path $Target -Parent) -Force
    [IO.File]::WriteAllBytes($Target, $bytes[$offset..($bytes.Length - 1)])
    (Get-FileHash -LiteralPath $Target -Algorithm SHA256).Hash.ToLowerInvariant() | Should Be $artifact.known_versions[0].sha256
}

Describe 'Deployment Gate 2 read-only full Upgrade preflight' {
    It 'reports four surfaces and preserves the isolated target byte-for-byte' {
        Import-Module (Join-Path $preflightRepo 'Scripts/modules/Deployment.Preflight.psm1') -Force
        Import-Module (Join-Path $preflightRepo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
        Write-PreflightManagedOldSkill (Join-Path $target '.agents/skills/delegation-strategy/SKILL.md')
        Write-PreflightFixture (Join-Path $target '.claude/skills/delegation-strategy/SKILL.md') 'user modified old skill'
        Write-PreflightFixture (Join-Path $target '.claude/skills/code-audit/SKILL.md') 'unknown old skill provenance'
        Write-PreflightFixture (Join-Path $target '.claude/skills/delegation-strategy/references/cli-capability-matrix.md') 'modified legacy reference'
        Write-PreflightFixture (Join-Path $target '.agents/skills/gitnexus-guide/SKILL.md') 'different unknown Guide copy'
        Write-PreflightFixture (Join-Path $target '.codex/hooks.json') 'modified legacy hook'
        Write-PreflightFixture (Join-Path $target '.agents/VERSION') ([IO.File]::ReadAllText((Join-Path $preflightRepo 'Antigravity/VERSION')).Trim())
        Write-PreflightFixture (Join-Path $target '.agents/skills/browser-testing/SKILL.md') ([IO.File]::ReadAllText((Join-Path $preflightRepo 'Shared/skills/browser-testing/SKILL.md')))
        Write-PreflightFixture (Join-Path $target '.agents/skills/00-chat-聊天/SKILL.md') ([IO.File]::ReadAllText((Join-Path $preflightRepo 'Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md')))
        Write-PreflightFixture (Join-Path $target '.agents/skills/security-sre/SKILL.md') 'stale managed target'
        Write-PreflightFixture (Join-Path $target '.agents/skills/user-owned/SKILL.md') 'unmanaged neighbor'
        Write-PreflightFixture (Join-Path $target '.agents/memory/card.md') 'frozen memory'
        Write-PreflightFixture (Join-Path $target '.agents/context/_map/CONTEXT.md') 'frozen context'
        Write-PreflightFixture (Join-Path $target '.agents/project_skills/_index.md') 'protected index'
        $before = Get-PreflightFixtureFingerprint $target
        $gateOneReceipt = [PSCustomObject]@{
            path = '.agents/skills/gitnexus-guide/SKILL.md'
            current_sha256 = 'd64259bed34c4f3aa6454e1e474c7b2264502b7bb11567e91f17e6f319bf5182'
            classification = 'PROBABLE_FRAMEWORK_OWNED'
        }
        $plan = @(Get-DeploymentUpgradePreflight -RepoRoot $preflightRepo -TargetRoot $target -ProvenanceReceipts @($gateOneReceipt))
        $after = Get-PreflightFixtureFingerprint $target
        $after | Should Be $before
        $plan.Count | Should BeGreaterThan 500
        @($plan | Group-Object target_path | Where-Object Count -ne 1).Count | Should Be 0
        @($plan | Where-Object { $_.platform -match '(?i)(^|\+)([^+]+)(\+\2)(\+|$)' }).Count | Should Be 0
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/delegation-strategy/SKILL.md' -and $_.planned_action -eq 'RETIRE' -and $_.known_framework_hash_match }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.claude/skills/delegation-strategy/SKILL.md' -and $_.planned_action -eq 'PRESERVE' -and $_.blocking }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.claude/skills/code-audit/SKILL.md' -and $_.planned_action -eq 'PRESERVE' -and $_.blocking }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.claude/skills/delegation-strategy/references/cli-capability-matrix.md' -and $_.planned_action -eq 'PRESERVE' -and -not $_.blocking }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/gitnexus-guide/SKILL.md' -and $_.planned_action -eq 'PRESERVE' -and $_.blocking -and $_.provenance_status -eq 'unknown_or_modified' }).Count | Should Be 1
        # M5C requires an unproven active hook group to preserve AND block.
        @($plan | Where-Object { $_.target_path -eq '.codex/hooks.json' -and $_.planned_action -eq 'PRESERVE' -and $_.blocking }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/gitnexus-cli/SKILL.md' -and $_.planned_action -eq 'ADD' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/browser-testing/SKILL.md' -and $_.planned_action -eq 'UNCHANGED' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/00-chat-聊天/SKILL.md' -and $_.planned_action -eq 'UPDATE' -and $_.reason -eq 'official_workflow_merge_force_copy' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/security-sre/SKILL.md' -and $_.planned_action -eq 'UPDATE' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/skills/user-owned/SKILL.md' -and $_.planned_action -eq 'PRESERVE' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.agents/VERSION' -and $_.planned_action -eq 'UPDATE' -and $_.reason -eq 'official_version_marker_forced_write' }).Count | Should Be 1
        @($plan | Where-Object { $_.target_path -eq '.cursor' -and $_.planned_action -eq 'SKIP' }).Count | Should Be 1
        @($plan | Where-Object { $_.platform -eq 'Claude' -and $_.content_type -eq 'Agent' -and $_.planned_action -eq 'ADD' -and -not $_.blocking }).Count | Should Be 6
        @($plan | Where-Object { $_.target_path -like '.agents/memory/*' -and $_.planned_action -ne 'PRESERVE' }).Count | Should Be 0
        foreach ($record in $plan) {
            $record.authorization_requirement | Should Be 'protected.deployment; not granted by preflight'
            (@('ADD','UPDATE','UNCHANGED','RETIRE','PRESERVE','BLOCK','SKIP') -contains $record.planned_action) | Should Be $true
        }
    }
}
