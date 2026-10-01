Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a12Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a12Names = @('sentry-ops', 'stitch-design')
$a12Guides = @('sentry-guide.md', 'stitch-guide.md')

Describe 'A12 retained Sentry Stitch isolated projection' {
    BeforeEach {
        Import-Module (Join-Path $a12Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        $a12Target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $a12Target
    }

    It 'projects two retained entries and the two shared provider references without new Skill identities' {
        $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $a12Repo 'Shared') -TargetAgentsRoot (Join-Path $a12Target '.agents') -Mode Full
        foreach ($guide in $a12Guides) {
            $copy = Join-Path $a12Target ".agents/shared/policies/references/$guide"
            (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a12Repo "Shared/policies/references/$guide")).Hash
        }
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a12Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a12Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            foreach ($name in $a12Names) {
                $copy = Join-Path $skills "$name/SKILL.md"
                (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a12Repo "Shared/skills/$name/SKILL.md")).Hash
                @((Get-ChildItem -LiteralPath (Join-Path $skills $name) -Recurse -File)).Count | Should Be 1
                $invocation = if ($name -eq 'stitch-design') { 'manual_only' } else { 'restricted' }
                ([IO.File]::ReadAllText($copy)) | Should Match "Invocation classification: $invocation"
            }
            @(Get-ChildItem -LiteralPath $skills -Recurse -Filter SKILL.md).Count | Should Be @(Get-ChildItem -LiteralPath (Join-Path $a12Repo 'Shared/skills') -Recurse -Filter SKILL.md).Count
        }
    }

    It 'updates isolated pre-A12 entries while preserving other Skill bytes and adjacent persistent data' {
        $fixture = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'a12-originals-fixture.json') -Raw | ConvertFrom-Json
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a12Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a12Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            $otherHashes = @{}
            foreach ($file in Get-ChildItem -LiteralPath $skills -Recurse -File) {
                $relative = $file.FullName.Substring($skills.Length + 1).Replace('\', '/')
                if ($a12Names -notcontains $relative.Split('/')[0]) {
                    $otherHashes[$file.FullName] = (Get-FileHash -LiteralPath $file.FullName).Hash
                }
            }
            foreach ($name in $a12Names) {
                $old = $fixture.originals_base64.PSObject.Properties["Shared/skills/$name/SKILL.md"].Value
                [IO.File]::WriteAllBytes((Join-Path $skills "$name/SKILL.md"), [Convert]::FromBase64String($old))
            }
            foreach ($area in @('.agents/memory', '.agents/context', '.cartridge', 'project-data')) {
                $directory = Join-Path $a12Target $area
                $null = New-Item -ItemType Directory -Path $directory -Force
                $file = Join-Path $directory 'existing.txt'
                [IO.File]::WriteAllText($file, 'isolated protected fixture')
                $otherHashes[$file] = (Get-FileHash -LiteralPath $file).Hash
            }
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a12Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($name in $a12Names) {
                (Get-FileHash -LiteralPath (Join-Path $skills "$name/SKILL.md")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a12Repo "Shared/skills/$name/SKILL.md")).Hash
            }
            foreach ($path in $otherHashes.Keys) {
                (Get-FileHash -LiteralPath $path).Hash | Should Be $otherHashes[$path]
            }
        }
    }
}
