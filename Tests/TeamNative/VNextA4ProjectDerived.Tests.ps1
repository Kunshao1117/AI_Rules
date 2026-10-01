Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a4Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a4Shared = Join-Path $a4Repo 'Shared'

function Write-A4Fixture([string]$Path, [string]$Text) {
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}
function Get-A4Fingerprint([string]$Root, [string]$TargetSkillsPath = '') {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $digest = if ($TargetSkillsPath) {
            $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a4Shared 'skills') -SourcePath $_.FullName -TargetSkillsPath $TargetSkillsPath
            [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
        } else { (Get-FileHash -LiteralPath $_.FullName).Hash }
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + $digest
    } | Sort-Object) -join "`n")
}
function Add-A4OfficialCopy([object]$Artifact, [string]$SkillsRoot) {
    $bytes = [IO.File]::ReadAllBytes((Join-Path $a4Shared $Artifact.reference_relative_path))
    if ($Artifact.old_relative_path -match '/SKILL.md$') {
        $marker = '<!-- ARCHIVED_SKILL_BODY_START -->' + "`n"
        $text = [Text.Encoding]::UTF8.GetString($bytes)
        $offset = [Text.Encoding]::UTF8.GetByteCount($text.Substring(0, $text.IndexOf($marker) + $marker.Length))
        $bytes = $bytes[$offset..($bytes.Length - 1)]
    }
    $path = Join-Path $SkillsRoot $Artifact.old_relative_path
    $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
    [IO.File]::WriteAllBytes($path, $bytes)
    (Get-FileHash -LiteralPath $path).Hash.ToLowerInvariant() | Should Be $Artifact.known_versions[0].sha256
}

Describe 'A4 project-derived code audit migration' {
    BeforeEach {
        Import-Module (Join-Path $a4Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a4Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*migration blocked*') { $Error.Remove($record) }
        }
    }

    It 'resolves exact bare source and platform aliases while excluding every old entry and asset' {
        $artifacts = @(Get-LegacySkillMigrationArtifacts -Batch 4B2A4)
        $artifacts.Count | Should Be 4
        foreach ($a in $artifacts) {
            (Test-SharedSkillRelativePathIncluded $a.old_relative_path) | Should Be $false
            foreach ($prefix in @('Shared/skills/', '.agents/skills/', '.claude/skills/', '.cursor/skills/')) {
                $result = Resolve-LegacySharedSkillReference -SharedRoot $a4Shared -Reference ($prefix + $a.old_relative_path + '#original-anchor')
                $result.Kind | Should Be 'legacy-compatibility-reference'
                $result.Anchor | Should Be 'original-anchor'
                $result.Path | Should Be ([IO.Path]::GetFullPath((Join-Path $a4Shared $a.reference_relative_path)))
            }
        }
        foreach ($id in @('code-audit')) {
            $result = Resolve-LegacySharedSkillReference -SharedRoot $a4Shared -Reference $id
            [IO.Path]::GetFileName($result.Path) | Should Be 'REFERENCE.md'
            (Test-SharedSkillRelativePathIncluded "$id/unexpected-leftover.md") | Should Be $false
        }
    }

    It 'projects fresh methods and safely retires known old copies on all Skill surfaces without losing neighboring user files' {
        Write-A4Fixture (Join-Path $target 'package.json') '{"scripts":{"verify":"project-specific verification"}}'
        Write-A4Fixture (Join-Path $target 'scripts/verify.ps1') '# existing user verification'
        $projectManifestHash = (Get-FileHash -LiteralPath (Join-Path $target 'package.json')).Hash
        $projectScriptHash = (Get-FileHash -LiteralPath (Join-Path $target 'scripts/verify.ps1')).Hash
        $methods = @('policies/references/project-derived-verification.md', 'policies/verification-strategy.md',
                     'agents/references/role-methods.md', 'workflow-stage-procedures.md')
        $null = Sync-SharedGovernanceReferences -SharedRoot $a4Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
        foreach ($method in $methods) {
            (Get-FileHash -LiteralPath (Join-Path $target ".agents/shared/$method")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a4Shared $method)).Hash
        }
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a4Shared 'skills') -TargetSkillsPath $skills -Mode Full
            foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A4)) {
                (Test-Path -LiteralPath (Join-Path $skills $a.old_relative_path)) | Should Be $false
                Add-A4OfficialCopy $a $skills
            }
            Write-A4Fixture (Join-Path $skills 'code-audit/user-notes.md') 'preserve neighboring notes'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a4Shared 'skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A4)) {
                (Test-Path -LiteralPath (Join-Path $skills $a.old_relative_path)) | Should Be $false
                $alias = Resolve-LegacySharedSkillReference -SharedRoot (Join-Path $target '.agents/shared') -Reference ($surface + '/' + $a.old_relative_path)
                (Get-FileHash -LiteralPath $alias.Path).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a4Shared $a.reference_relative_path)).Hash
            }
            [IO.File]::ReadAllText((Join-Path $skills 'code-audit/user-notes.md')) | Should Be 'preserve neighboring notes'
            foreach ($entry in @(Get-ChildItem -LiteralPath (Join-Path $a4Shared 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
                (Get-A4Fingerprint (Join-Path $skills $entry.Name)) | Should Be (Get-A4Fingerprint $entry.FullName -TargetSkillsPath $skills)
                if ($entry.Name -in @('memory-ops','memory-arch')) {
                    $owner = if ($surface -eq '.agents/skills') { '../../shared/policies/memory-governance.md' } else { '../../../.agents/shared/policies/memory-governance.md' }
                    [IO.File]::ReadAllText((Join-Path $skills "$($entry.Name)/SKILL.md")) | Should Match ([regex]::Escape($owner))
                }
            }
        }
        (Get-FileHash -LiteralPath (Join-Path $target 'package.json')).Hash | Should Be $projectManifestHash
        (Get-FileHash -LiteralPath (Join-Path $target 'scripts/verify.ps1')).Hash | Should Be $projectScriptHash
    }

    It 'preserves modified and unknown retired entries before any writes on every platform surface' {
        foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A4 | Where-Object { $_.old_relative_path -match '/SKILL.md$' })) {
            foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
                foreach ($kind in @('modified', 'unknown')) {
                    $case = Join-Path $target ($a.skill + '/' + $kind + '/' + $surface)
                    if ($kind -eq 'modified') {
                        Add-A4OfficialCopy $a $case
                        [IO.File]::AppendAllText((Join-Path $case $a.old_relative_path), "`nuser change")
                    } else { Write-A4Fixture (Join-Path $case $a.old_relative_path) 'unknown ownership' }
                    $before = Get-A4Fingerprint $case
                    { Sync-SharedSkills -SharedSkillsRoot (Join-Path $a4Shared 'skills') -TargetSkillsPath $case -Mode Diff } | Should Throw 'preserved_user_modified_retired_skill'
                    (Get-A4Fingerprint $case) | Should Be $before
                }
            }
        }
    }

    It 'restores earlier retirement and projection after a later audit entry mismatch' {
        Import-Module (Join-Path $a4Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A4)) { Add-A4OfficialCopy $a (Join-Path $target '.agents/skills') }
        Write-A4Fixture (Join-Path $target '.cursor/skills/code-audit/SKILL.md') 'user audit'
        Write-A4Fixture (Join-Path $target '.agents/context/_map/CONTEXT.md') 'approved context'
        Write-A4Fixture (Join-Path $target '.agents/memory/card.md') 'frozen memory'
        Write-A4Fixture (Join-Path $target '.cartridge/index.json') 'frozen index'
        Write-A4Fixture (Join-Path $target '.codex/VERSION') 'old version'
        $before = Get-A4Fingerprint $target
        { Invoke-DeploymentTransaction -TargetRoot $target -Action {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a4Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a4Shared 'skills') -TargetSkillsPath (Join-Path $target '.agents/skills') -Mode Diff
            Write-A4Fixture (Join-Path $target '.codex/VERSION') 'would be new'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a4Shared 'skills') -TargetSkillsPath (Join-Path $target '.cursor/skills') -Mode Diff
        } } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A4Fingerprint $target) | Should Be $before
    }
}
