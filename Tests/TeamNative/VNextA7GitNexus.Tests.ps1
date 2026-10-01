Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a7Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a7Shared = Join-Path $a7Repo 'Shared'

function Write-A7Fixture([string]$Path, [string]$Text) {
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}
function Get-A7Fingerprint([string]$Root, [string]$TargetSkillsPath = '') {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $digest = if ($TargetSkillsPath) {
            $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a7Shared 'skills') -SourcePath $_.FullName -TargetSkillsPath $TargetSkillsPath
            [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
        } else { (Get-FileHash -LiteralPath $_.FullName).Hash }
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + $digest
    } | Sort-Object) -join "`n")
}
function Add-A7OfficialCopy([object]$Artifact, [string]$SkillsRoot) {
    $bytes = [IO.File]::ReadAllBytes((Join-Path $a7Shared $Artifact.reference_relative_path))
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

Describe 'A7 GitNexus guide Reference migration' {
    BeforeEach {
        Import-Module (Join-Path $a7Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a7Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*migration blocked*') { $Error.Remove($record) }
        }
    }

    It 'resolves exact bare source and platform aliases while excluding every old entry and asset' {
        $artifacts = @(Get-LegacySkillMigrationArtifacts -Batch 4B2A7)
        $artifacts.Count | Should Be 1
        foreach ($a in $artifacts) {
            (Test-SharedSkillRelativePathIncluded $a.old_relative_path) | Should Be $false
            foreach ($prefix in @('Shared/skills/', '.agents/skills/', '.claude/skills/', '.cursor/skills/')) {
                $result = Resolve-LegacySharedSkillReference -SharedRoot $a7Shared -Reference ($prefix + $a.old_relative_path + '#original-anchor')
                $result.Kind | Should Be 'legacy-compatibility-reference'
                $result.Anchor | Should Be 'original-anchor'
                $result.Path | Should Be ([IO.Path]::GetFullPath((Join-Path $a7Shared $a.reference_relative_path)))
            }
        }
        foreach ($id in @('gitnexus-guide')) {
            $result = Resolve-LegacySharedSkillReference -SharedRoot $a7Shared -Reference $id
            [IO.Path]::GetFileName($result.Path) | Should Be 'REFERENCE.md'
            (Test-SharedSkillRelativePathIncluded "$id/unexpected-leftover.md") | Should Be $false
        }
    }

    It 'projects fresh methods and safely retires known old copies on all Skill surfaces without losing neighboring user files' {
        Write-A7Fixture (Join-Path $target 'package.json') '{"scripts":{"verify":"project-specific verification"}}'
        Write-A7Fixture (Join-Path $target 'scripts/verify.ps1') '# existing user verification'
        $projectManifestHash = (Get-FileHash -LiteralPath (Join-Path $target 'package.json')).Hash
        $projectScriptHash = (Get-FileHash -LiteralPath (Join-Path $target 'scripts/verify.ps1')).Hash
        $methods = @('policies/references/gitnexus-guide.md', 'policies/references/legacy-skill-migration.json',
                     'policies/references/legacy-skills/gitnexus-guide/REFERENCE.md')
        $null = Sync-SharedGovernanceReferences -SharedRoot $a7Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
        foreach ($method in $methods) {
            (Get-FileHash -LiteralPath (Join-Path $target ".agents/shared/$method")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a7Shared $method)).Hash
        }
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a7Shared 'skills') -TargetSkillsPath $skills -Mode Full
            foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A7)) {
                (Test-Path -LiteralPath (Join-Path $skills $a.old_relative_path)) | Should Be $false
                Add-A7OfficialCopy $a $skills
            }
            Write-A7Fixture (Join-Path $skills 'gitnexus-guide/user-notes.md') 'preserve neighboring notes'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a7Shared 'skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A7)) {
                (Test-Path -LiteralPath (Join-Path $skills $a.old_relative_path)) | Should Be $false
                $alias = Resolve-LegacySharedSkillReference -SharedRoot (Join-Path $target '.agents/shared') -Reference ($surface + '/' + $a.old_relative_path)
                (Get-FileHash -LiteralPath $alias.Path).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a7Shared $a.reference_relative_path)).Hash
            }
            [IO.File]::ReadAllText((Join-Path $skills 'gitnexus-guide/user-notes.md')) | Should Be 'preserve neighboring notes'
            foreach ($entry in @(Get-ChildItem -LiteralPath (Join-Path $a7Shared 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
                (Get-A7Fingerprint (Join-Path $skills $entry.Name)) | Should Be (Get-A7Fingerprint $entry.FullName -TargetSkillsPath $skills)
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
        foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A7 | Where-Object { $_.old_relative_path -match '/SKILL.md$' })) {
            foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
                foreach ($kind in @('modified', 'unknown')) {
                    $case = Join-Path $target ($a.skill + '/' + $kind + '/' + $surface)
                    if ($kind -eq 'modified') {
                        Add-A7OfficialCopy $a $case
                        [IO.File]::AppendAllText((Join-Path $case $a.old_relative_path), "`nuser change")
                    } else { Write-A7Fixture (Join-Path $case $a.old_relative_path) 'unknown ownership' }
                    $before = Get-A7Fingerprint $case
                    { Sync-SharedSkills -SharedSkillsRoot (Join-Path $a7Shared 'skills') -TargetSkillsPath $case -Mode Diff } | Should Throw 'preserved_user_modified_retired_skill'
                    (Get-A7Fingerprint $case) | Should Be $before
                }
            }
        }
    }

    It 'restores earlier retirement and projection after a later guide entry mismatch' {
        Import-Module (Join-Path $a7Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A7)) { Add-A7OfficialCopy $a (Join-Path $target '.agents/skills') }
        Write-A7Fixture (Join-Path $target '.cursor/skills/gitnexus-guide/SKILL.md') 'user guide'
        Write-A7Fixture (Join-Path $target '.agents/context/_map/CONTEXT.md') 'approved context'
        Write-A7Fixture (Join-Path $target '.agents/memory/card.md') 'frozen memory'
        Write-A7Fixture (Join-Path $target '.cartridge/index.json') 'frozen index'
        Write-A7Fixture (Join-Path $target '.codex/VERSION') 'old version'
        $before = Get-A7Fingerprint $target
        { Invoke-DeploymentTransaction -TargetRoot $target -Action {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a7Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a7Shared 'skills') -TargetSkillsPath (Join-Path $target '.agents/skills') -Mode Diff
            Write-A7Fixture (Join-Path $target '.codex/VERSION') 'would be new'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a7Shared 'skills') -TargetSkillsPath (Join-Path $target '.cursor/skills') -Mode Diff
        } } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A7Fingerprint $target) | Should Be $before
    }
}
