Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a5Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a5Shared = Join-Path $a5Repo 'Shared'
$a5Names = @('security-sre', 'tech-stack-protocol', 'skill-factory')

function Get-A5TreeHash([string]$Root, [string]$TargetSkillsPath = '') {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $digest = if ($TargetSkillsPath) {
            # Current active Markdown has an authorized policy-link projection;
            # legacy/reference raw evidence remains byte-identical.
            $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a5Shared 'skills') -SourcePath $_.FullName -TargetSkillsPath $TargetSkillsPath
            [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
        } else { (Get-FileHash -LiteralPath $_.FullName).Hash }
        $_.FullName.Substring($Root.Length) + ':' + $digest
    } | Sort-Object) -join "`n")
}

Describe 'A5 core method discovery and isolated projection' {
    BeforeEach {
        Import-Module (Join-Path $a5Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a5Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }

    It 'keeps the three active identities and exact entry/reference bytes on each supported Skill surface' {
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a5Shared 'skills') -TargetSkillsPath $skills -Mode Full
            foreach ($name in $a5Names) {
                (Test-SharedSkillRelativePathIncluded "$name/SKILL.md") | Should Be $true
                (Test-Path -LiteralPath (Join-Path $skills "$name/SKILL.md")) | Should Be $true
                (Get-A5TreeHash (Join-Path $skills $name)) | Should Be (Get-A5TreeHash (Join-Path $a5Shared "skills/$name") -TargetSkillsPath $skills)
                @(Get-ChildItem -LiteralPath (Join-Path $skills "$name/references") -Recurse -Filter SKILL.md).Count | Should Be 0
            }
            foreach ($name in @('code-audit', 'structured-reasoning', 'code-diagnosis')) {
                (Test-Path -LiteralPath (Join-Path $skills "$name/SKILL.md")) | Should Be $false
            }
            foreach ($entry in @(Get-ChildItem -LiteralPath (Join-Path $a5Shared 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
                (Get-A5TreeHash (Join-Path $skills $entry.Name)) | Should Be (Get-A5TreeHash $entry.FullName -TargetSkillsPath $skills)
            }
        }
    }

    It 'does not activate a candidate stored outside discovery or alter project context while updating an existing Skill projection' {
        $skills = Join-Path $target '.agents/skills'
        $null = New-Item -ItemType Directory -Path (Join-Path $target 'review-proposals') -Force
        [IO.File]::WriteAllText((Join-Path $target 'review-proposals/candidate.md'), '# Proposed method, not approved')
        $null = New-Item -ItemType Directory -Path (Join-Path $target '.agents/context') -Force
        [IO.File]::WriteAllText((Join-Path $target '.agents/context/CONTEXT.md'), 'existing context')
        $contextBefore = Get-A5TreeHash (Join-Path $target '.agents/context')
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a5Shared 'skills') -TargetSkillsPath $skills -Mode Full
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a5Shared 'skills') -TargetSkillsPath $skills -Mode Diff
        (Test-Path -LiteralPath (Join-Path $skills 'candidate/SKILL.md')) | Should Be $false
        (Test-Path -LiteralPath (Join-Path $target '.agents/project_skills')) | Should Be $false
        (Get-A5TreeHash (Join-Path $target '.agents/context')) | Should Be $contextBefore
        [IO.File]::ReadAllText((Join-Path $target 'review-proposals/candidate.md')) | Should Be '# Proposed method, not approved'
        $index = [IO.File]::ReadAllText((Join-Path $a5Shared 'skills/_index.md'))
        foreach ($name in $a5Names) {
            ([regex]::Matches($index, "(?m)^- Skill: $name`r?$" )).Count | Should Be 1
        }
        $index | Should Match 'Invocation: restricted'
        $index | Should Match 'Invocation: manual_only method contract'
    }
}
