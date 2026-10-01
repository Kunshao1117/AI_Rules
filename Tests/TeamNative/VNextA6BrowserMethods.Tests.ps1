Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a6Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a6Shared = Join-Path $a6Repo 'Shared'
$a6Names = @('browser-testing','test-automation-strategy','test-patterns','impact-test-strategy','a11y-testing','performance-audit')

function Get-A6TreeHash([string]$Root, [string]$TargetSkillsPath = '') {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $digest = if ($TargetSkillsPath) {
            # Current active Markdown has an authorized policy-link projection;
            # legacy/reference raw evidence remains byte-identical.
            $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a6Shared 'skills') -SourcePath $_.FullName -TargetSkillsPath $TargetSkillsPath
            [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
        } else { (Get-FileHash -LiteralPath $_.FullName).Hash }
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + $digest
    } | Sort-Object) -join "`n")
}

Describe 'A6 browser and testing method isolated projection' {
    BeforeEach {
        Import-Module (Join-Path $a6Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a6Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }

    It 'projects all six retained entries and exact references to each Skill surface without new invocation aliases' {
        $index = [IO.File]::ReadAllText((Join-Path $a6Shared 'skills/_index.md'))
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a6Shared 'skills') -TargetSkillsPath $skills -Mode Full
            foreach ($name in $a6Names) {
                (Test-SharedSkillRelativePathIncluded "$name/SKILL.md") | Should Be $true
                (Test-Path -LiteralPath (Join-Path $skills "$name/SKILL.md")) | Should Be $true
                (Get-A6TreeHash (Join-Path $skills $name)) | Should Be (Get-A6TreeHash (Join-Path $a6Shared "skills/$name") -TargetSkillsPath $skills)
                @(Get-ChildItem -LiteralPath (Join-Path $skills "$name/references") -Recurse -Filter SKILL.md).Count | Should Be 0
                ([regex]::Matches($index, "(?m)^- Skill: $name`r?$" )).Count | Should Be 1
                $text = [IO.File]::ReadAllText((Join-Path $skills "$name/SKILL.md"))
                $metadata = $text.Split(@('---'), [StringSplitOptions]::None)[1]
                $metadata | Should Not Match '(?m)^\s*(required_skills|relations|mcp_servers):'
            }
            foreach ($name in @('code-audit', 'structured-reasoning', 'code-diagnosis')) {
                (Test-Path -LiteralPath (Join-Path $skills "$name/SKILL.md")) | Should Be $false
            }
            foreach ($entry in @(Get-ChildItem -LiteralPath (Join-Path $a6Shared 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
                (Get-A6TreeHash (Join-Path $skills $entry.Name)) | Should Be (Get-A6TreeHash $entry.FullName -TargetSkillsPath $skills)
            }
        }
    }

    It 'updates an isolated pre-A6 projection and preserves neighboring Memory Context and user data' {
        $skills = Join-Path $target '.agents/skills'
        foreach ($name in $a6Names) {
            $null = New-Item -ItemType Directory -Path (Join-Path $skills $name) -Force
            $archive = [IO.File]::ReadAllText((Join-Path $a6Shared "skills/$name/references/legacy/pre-a6-entry.md"))
            $marker = '<!-- PRE_A6_ORIGINAL_START -->' + "`n"
            $original = $archive.Substring($archive.IndexOf($marker) + $marker.Length)
            [IO.File]::WriteAllText((Join-Path $skills "$name/SKILL.md"), $original, [Text.UTF8Encoding]::new($false))
        }
        foreach ($area in @('.agents/memory', '.agents/context', '.cartridge', 'project-data')) {
            $null = New-Item -ItemType Directory -Path (Join-Path $target $area) -Force
            [IO.File]::WriteAllText((Join-Path $target "$area/existing.txt"), 'existing protected data')
        }
        $protected = @{}
        foreach ($area in @('.agents/memory', '.agents/context', '.cartridge', 'project-data')) {
            $protected[$area] = Get-A6TreeHash (Join-Path $target $area)
        }
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a6Shared 'skills') -TargetSkillsPath $skills -Mode Diff
        foreach ($name in $a6Names) {
            (Get-A6TreeHash (Join-Path $skills $name)) | Should Be (Get-A6TreeHash (Join-Path $a6Shared "skills/$name") -TargetSkillsPath $skills)
        }
        foreach ($area in $protected.Keys) {
            (Get-A6TreeHash (Join-Path $target $area)) | Should Be $protected[$area]
        }
    }
}
