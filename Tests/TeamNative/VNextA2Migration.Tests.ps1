Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a2Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a2Shared = Join-Path $a2Repo 'Shared'

function Write-A2Fixture([string]$Path, [string]$Text) {
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}
function Get-A2Fingerprint([string]$Root, [string]$TargetSkillsPath = '') {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $digest = if ($TargetSkillsPath) {
            # Current active Markdown has an authorized policy-link projection;
            # legacy/reference raw evidence remains byte-identical.
            $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a2Shared 'skills') -SourcePath $_.FullName -TargetSkillsPath $TargetSkillsPath
            [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
        } else { (Get-FileHash -LiteralPath $_.FullName).Hash }
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + $digest
    } | Sort-Object) -join "`n")
}
function Add-A2OfficialCopy([object]$Artifact, [string]$SkillsRoot) {
    $archive = if ($Artifact.PSObject.Properties['archive_relative_path']) { $Artifact.archive_relative_path } else { $Artifact.reference_relative_path }
    $bytes = [IO.File]::ReadAllBytes((Join-Path $a2Shared $archive))
    if ($Artifact.old_relative_path -match '/SKILL.md$' -and -not $Artifact.PSObject.Properties['archive_relative_path']) {
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

Describe 'Windows relative-path representation regression' {
    It 'keeps fingerprints and deployment paths independent of root length and spelling' {
        Import-Module (Join-Path $a2Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        $shortRoot=Join-Path $TestDrive 'a'
        $longRoot=Join-Path $TestDrive 'GitHub-style-temp-root-with-a-different-length'
        foreach($root in @($shortRoot,$longRoot)) {
            Write-A2Fixture (Join-Path $root 'skill/references/name with space #.md') 'same bytes'
        }
        (Get-A2Fingerprint $shortRoot) | Should Be (Get-A2Fingerprint $longRoot)
        $alternate=Join-Path $longRoot '.\skill\..'
        (Get-A2Fingerprint $alternate) | Should Be (Get-A2Fingerprint $longRoot)
        (Get-DeploymentRelativePath -Root $alternate -Path (Join-Path $longRoot 'skill/references/name with space #.md')) | Should Be 'skill\references\name with space #.md'
    }

    It 'keeps a real Windows 8.3 alias and its long Pester directory equivalent when available' {
        Import-Module (Join-Path $a2Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        # The workflow already requires Pester. Inspect that public test tool,
        # without creating files in Program Files or requiring private runtime.
        $modulePath=(Get-Module Pester).Path
        $longRoot=[IO.Path]::GetFullPath((Split-Path $modulePath -Parent))
        $fso=New-Object -ComObject Scripting.FileSystemObject
        $alias=$fso.GetFolder($longRoot).ShortPath
        (Get-A2Fingerprint $alias) | Should Be (Get-A2Fingerprint $longRoot)
        (Get-DeploymentRelativePath -Root $alias -Path $modulePath) | Should Be (Split-Path $modulePath -Leaf)
    }
}

Describe 'A2 workflow policy reference migration' {
    BeforeEach {
        Import-Module (Join-Path $a2Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a2Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*migration blocked*') { $Error.Remove($record) }
        }
    }

    It 'excludes the exact A2 set and later mapped guide while including every nonmigrated Skill' {
        $names = @(Get-LegacySkillMigrationArtifacts -Batch 4B2A2 | Select-Object -ExpandProperty skill -Unique)
        $names.Count | Should Be 12
        foreach ($name in $names) {
            (Test-SharedSkillRelativePathIncluded "$name/SKILL.md") | Should Be $false
            (Test-SharedSkillRelativePathIncluded "$name/references/leftover.md") | Should Be $false
        }
        foreach ($entry in @(Get-ChildItem -LiteralPath (Join-Path $a2Shared 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
            (Test-SharedSkillRelativePathIncluded ($entry.Name + '/SKILL.md')) | Should Be $true
        }
        # Excluded from A2, then separately migrated using the A7 exact mapping.
        (Test-SharedSkillRelativePathIncluded 'gitnexus-guide/SKILL.md') | Should Be $false
        (@(Get-LegacySkillMigrationArtifacts -Batch 4B2A7).skill) | Should Be 'gitnexus-guide'
    }

    It 'projects new owners and archives in Full and Diff with exact source hashes across platform surfaces' {
        $owners = @('policies/code-quality.md','policies/ui-ux-standards.md','policies/project-context-protocol.md',
            'workflows/plugin-release.md','workflows/ui-design-exploration.md','workflows/git-checkpoint.md','workflows/release-readiness.md',
            'policies/references/code-quality-methods.md','policies/references/ui-ux-methods.md',
            'policies/references/project-context-format.md','policies/references/context-template.md',
            'policies/references/plugin-release-procedure.md','policies/references/git-checkpoint-procedure.md')
        foreach ($mode in @('Full', 'Diff')) {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a2Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode $mode
            foreach ($owner in $owners) {
                (Get-FileHash -LiteralPath (Join-Path $target ".agents/shared/$owner")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a2Shared $owner)).Hash
            }
            foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
                $skills = Join-Path $target $surface
                $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a2Shared 'skills') -TargetSkillsPath $skills -Mode $mode
                foreach ($a in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A2)) {
                    (Test-Path -LiteralPath (Join-Path $skills $a.old_relative_path)) | Should Be $false
                    $resolved = Resolve-LegacySharedSkillReference -SharedRoot (Join-Path $target '.agents/shared') -Reference ($surface + '/' + $a.old_relative_path + '#legacy-anchor')
                    $resolved.Anchor | Should Be 'legacy-anchor'
                    (Get-FileHash -LiteralPath $resolved.Path).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a2Shared $a.reference_relative_path)).Hash
                }
                foreach ($name in @('memory-ops','memory-arch')) {
                    (Get-A2Fingerprint (Join-Path $skills $name)) | Should Be (Get-A2Fingerprint (Join-Path $a2Shared "skills/$name") -TargetSkillsPath $skills)
                }
            }
        }
    }

    It 'resolves the unchanged Memory board handoff and Context bare IDs as reference documents' {
        $checks = @{
            'team-task-board' = 'board-field-catalog.md'
            'team-station-handoff-packet' = 'packet-schema-and-routing.md'
            'project-context-protocol' = 'GO CONTEXT'
        }
        $memoryText = @(
            Get-Content -LiteralPath (Join-Path $a2Shared 'skills/memory-ops/SKILL.md') -Raw -Encoding UTF8
            Get-Content -LiteralPath (Join-Path $a2Shared 'policies/references/legacy-skills/team-specialist-memory-closure/pre-m3-original.md') -Raw -Encoding UTF8
            Get-Content -LiteralPath (Join-Path $a2Shared 'policies/references/legacy-skills/team-specialist-memory-docs/pre-m3-original.md') -Raw -Encoding UTF8
        )
        foreach ($id in $checks.Keys) {
            ($memoryText -join "`n") | Should Match ([regex]::Escape($id))
            $resolved = Resolve-LegacySharedSkillReference -SharedRoot $a2Shared -Reference $id
            $resolved.Kind | Should Be 'legacy-compatibility-reference'
            (Get-Content -LiteralPath $resolved.Path -Raw -Encoding UTF8) | Should Match ([regex]::Escape($checks[$id]))
        }
        $catalog = Resolve-LegacySharedSkillReference -SharedRoot $a2Shared -Reference 'Shared/skills/team-task-board/references/board-field-catalog.md'
        (Get-Content -LiteralPath $catalog.Path -Raw -Encoding UTF8) | Should Match 'git_checkpoint_receipt'
    }

    It 'retires the mixed A1 and A2 framework bytes and preserves modified adjacent reference assets' {
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) { Add-A2OfficialCopy $artifact $target }
        $asset = 'project-context-protocol/references/context-template.md'
        [IO.File]::AppendAllText((Join-Path $target $asset), "`nuser template")
        $userHash = (Get-FileHash -LiteralPath (Join-Path $target $asset)).Hash
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a2Shared 'skills') -TargetSkillsPath $target -Mode Diff
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) {
            if ($artifact.old_relative_path -eq $asset) { continue }
            (Test-Path -LiteralPath (Join-Path $target $artifact.old_relative_path)) | Should Be $false
        }
        (Get-FileHash -LiteralPath (Join-Path $target $asset)).Hash | Should Be $userHash
    }

    It 'preserves and blocks modified and unknown entries for every A2 old ID before writes' {
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts -Batch 4B2A2 | Where-Object { $_.old_relative_path -match '/SKILL.md$' })) {
            foreach ($kind in @('modified', 'unknown')) {
                $case = Join-Path $target ($artifact.skill + '/' + $kind)
                if ($kind -eq 'modified') {
                    Add-A2OfficialCopy $artifact $case
                    [IO.File]::AppendAllText((Join-Path $case $artifact.old_relative_path), "`nuser change")
                } else { Write-A2Fixture (Join-Path $case $artifact.old_relative_path) 'unknown ownership' }
                $before = Get-A2Fingerprint $case
                { Sync-SharedSkills -SharedSkillsRoot (Join-Path $a2Shared 'skills') -TargetSkillsPath $case -Mode Diff } | Should Throw 'preserved_user_modified_retired_skill'
                (Get-A2Fingerprint $case) | Should Be $before
            }
        }
    }

    It 'restores all earlier projection and retirement after a later A2 Context mismatch' {
        Import-Module (Join-Path $a2Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        foreach ($a in @(Get-LegacySkillMigrationArtifacts)) { Add-A2OfficialCopy $a (Join-Path $target '.agents/skills') }
        Write-A2Fixture (Join-Path $target '.cursor/skills/project-context-protocol/SKILL.md') 'user context protocol'
        Write-A2Fixture (Join-Path $target '.agents/context/_map/CONTEXT.md') 'approved user context'
        Write-A2Fixture (Join-Path $target '.agents/memory/card.md') 'frozen memory'
        Write-A2Fixture (Join-Path $target '.cartridge/index.json') 'frozen cartridge'
        Write-A2Fixture (Join-Path $target '.codex/VERSION') 'old version'
        $before = Get-A2Fingerprint $target
        { Invoke-DeploymentTransaction -TargetRoot $target -Action {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a2Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a2Shared 'skills') -TargetSkillsPath (Join-Path $target '.agents/skills') -Mode Diff
            Write-A2Fixture (Join-Path $target '.codex/VERSION') 'would be new'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a2Shared 'skills') -TargetSkillsPath (Join-Path $target '.cursor/skills') -Mode Diff
        } } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A2Fingerprint $target) | Should Be $before
    }
}
