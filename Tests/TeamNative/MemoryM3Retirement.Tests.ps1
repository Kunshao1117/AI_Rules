Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$m3Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$m3Shared = Join-Path $m3Repo 'Shared'
$m3Ids = @('team-specialist-memory-docs', 'team-memory-docs-delivery-artifact',
    'team-specialist-memory-closure', 'team-memory-closure-delivery-artifact')

function Get-M3Fingerprint([string]$Root) {
    return (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    } | Sort-Object) -join "`n")
}
function Add-M3OldCopy([string]$Root, [string]$Id) {
    Import-Module (Join-Path $m3Repo 'Scripts/modules/Skill-Migration.psm1') -Force
    $artifact = @(Get-LegacySkillMigrationArtifacts -SharedRoot $m3Shared -Batch M3 | Where-Object skill -eq $Id)[0]
    $source = Join-Path $m3Shared $artifact.archive_relative_path
    $target = Join-Path $Root "$Id/SKILL.md"
    $null = New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force
    Copy-Item -LiteralPath $source -Destination $target -ErrorAction Stop
    $null = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant() | Should Be $artifact.known_versions[0].sha256
    return $target
}

Describe 'M3 exact Legacy Team Memory retirement' {
    BeforeEach {
        Import-Module (Join-Path $m3Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $m3Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*migration blocked*') {
                $Error.Remove($record)
            }
        }
    }

    It 'resolves four M3 aliases but excludes physical source leftovers from all Skill projections' {
        $artifacts = @(Get-LegacySkillMigrationArtifacts -SharedRoot $m3Shared -Batch M3)
        $artifacts.Count | Should Be 4
        foreach ($id in $m3Ids) {
            (Test-SharedSkillRelativePathIncluded "$id/SKILL.md") | Should Be $false
            (Test-SharedSkillRelativePathIncluded $id) | Should Be $false
            foreach ($prefix in @('Shared/skills/', '.agents/skills/', '.claude/skills/', '.cursor/skills/')) {
                $resolved = Resolve-LegacySharedSkillReference -Reference ($prefix + "$id/SKILL.md#legacy") -SharedRoot $m3Shared
                $resolved.Kind | Should Be 'legacy-compatibility-reference'
                $resolved.Anchor | Should Be 'legacy'
                (Get-Content -LiteralPath $resolved.Path -Raw) | Should Match 'M3'
            }
        }
        (Test-SharedSkillRelativePathIncluded 'memory-ops/SKILL.md') | Should Be $true
        (Test-SharedSkillRelativePathIncluded 'memory-arch/SKILL.md') | Should Be $true
    }

    It 'fresh-projects active Skills and References without four retired Skill entries' {
        $null = Sync-SharedGovernanceReferences -SharedRoot $m3Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $m3Shared 'skills') -TargetSkillsPath $skills -Mode Full
            foreach ($id in $m3Ids) { (Test-Path -LiteralPath (Join-Path $skills "$id/SKILL.md")) | Should Be $false }
            foreach ($id in @('memory-ops', 'memory-arch')) { (Test-Path -LiteralPath (Join-Path $skills "$id/SKILL.md")) | Should Be $true }
        }
        foreach ($file in @('memory-review-evidence.md', 'memory-update-sync-evidence.md', 'legacy-memory-team-transition.md')) {
            (Test-Path -LiteralPath (Join-Path $target ".agents/shared/policies/references/$file")) | Should Be $true
        }
    }

    It 'retires exact known framework old entries on three isolated upgrade surfaces' {
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            foreach ($id in $m3Ids) { $null = Add-M3OldCopy -Root $skills -Id $id }
            $null = New-Item -ItemType Directory -Path (Join-Path $skills 'memory-ops') -Force
            [IO.File]::WriteAllText((Join-Path $skills 'memory-ops/user-note.txt'), 'preserve')
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $m3Shared 'skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($id in $m3Ids) { (Test-Path -LiteralPath (Join-Path $skills "$id/SKILL.md")) | Should Be $false }
            [IO.File]::ReadAllText((Join-Path $skills 'memory-ops/user-note.txt')) | Should Be 'preserve'
        }
    }

    It 'preserves modified and unknown old entries and blocks before direct Skill writes' {
        foreach ($kind in @('modified', 'unknown')) {
            $skills = Join-Path $target $kind
            $old = if ($kind -eq 'modified') {
                $p = Add-M3OldCopy -Root $skills -Id $m3Ids[0]
                [IO.File]::AppendAllText($p, "`nuser modification")
                $p
            } else {
                $p = Join-Path $skills "$($m3Ids[1])/SKILL.md"
                $null = New-Item -ItemType Directory -Path (Split-Path $p -Parent) -Force
                [IO.File]::WriteAllText($p, 'unknown owner')
                $p
            }
            $before = Get-M3Fingerprint $skills
            { Sync-SharedSkills -SharedSkillsRoot (Join-Path $m3Shared 'skills') -TargetSkillsPath $skills -Mode Diff } | Should Throw 'preserved_user_modified_retired_skill'
            (Get-M3Fingerprint $skills) | Should Be $before
            (Test-Path -LiteralPath $old) | Should Be $true
        }
    }

    It 'preflights exact known copies for retirement and unknown copies as blocking' {
        Import-Module (Join-Path $m3Repo 'Scripts/modules/Deployment.Preflight.psm1') -Force
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            foreach ($id in $m3Ids) { $null = Add-M3OldCopy -Root $skills -Id $id }
        }
        $unknown = Join-Path $target '.claude/skills/team-specialist-memory-closure/SKILL.md'
        [IO.File]::AppendAllText($unknown, "`nuser edit")
        $before = Get-M3Fingerprint $target
        $plan = @(Get-DeploymentUpgradePreflight -RepoRoot $m3Repo -TargetRoot $target)
        (Get-M3Fingerprint $target) | Should Be $before
        foreach ($id in $m3Ids) {
            @($plan | Where-Object { $_.target_path -eq ".agents/skills/$id/SKILL.md" -and $_.planned_action -eq 'RETIRE' -and $_.known_framework_hash_match }).Count | Should Be 1
            @($plan | Where-Object { $_.target_path -eq ".cursor/skills/$id/SKILL.md" -and $_.planned_action -eq 'RETIRE' -and $_.known_framework_hash_match }).Count | Should Be 1
        }
        @($plan | Where-Object { $_.target_path -eq '.claude/skills/team-specialist-memory-closure/SKILL.md' -and $_.planned_action -eq 'PRESERVE' -and $_.blocking }).Count | Should Be 1
    }

    It 'rolls back earlier isolated writes when a later surface has an unconfirmed M3 entry' {
        Import-Module (Join-Path $m3Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        $unknown = Join-Path $target '.cursor/skills/team-specialist-memory-closure/SKILL.md'
        $null = New-Item -ItemType Directory -Path (Split-Path $unknown -Parent) -Force
        [IO.File]::WriteAllText($unknown, 'unknown owner')
        $old = Join-Path $target '.agents/shared/marker.txt'
        $null = New-Item -ItemType Directory -Path (Split-Path $old -Parent) -Force
        [IO.File]::WriteAllText($old, 'before')
        $before = Get-M3Fingerprint $target
        { Invoke-DeploymentTransaction -TargetRoot $target -Action {
            [IO.File]::WriteAllText($old, 'would change')
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $m3Shared 'skills') -TargetSkillsPath (Join-Path $target '.agents/skills') -Mode Full
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $m3Shared 'skills') -TargetSkillsPath (Join-Path $target '.cursor/skills') -Mode Diff
        } } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-M3Fingerprint $target) | Should Be $before
    }
}
