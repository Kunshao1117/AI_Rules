Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a11Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a11Names = @('github-ops', 'pr-review-ops', 'cloudflare-ops')
$a11Guides = @('github-guide.md', 'cloudflare-guide.md')

Describe 'A11 retained GitHub Cloudflare isolated projection' {
    BeforeEach {
        Import-Module (Join-Path $a11Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        $a11Target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $a11Target
    }

    It 'projects three retained entries and the two shared provider references without new Skill identities' {
        $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $a11Repo 'Shared') -TargetAgentsRoot (Join-Path $a11Target '.agents') -Mode Full
        foreach ($guide in $a11Guides) {
            $copy = Join-Path $a11Target ".agents/shared/policies/references/$guide"
            (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a11Repo "Shared/policies/references/$guide")).Hash
        }
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a11Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a11Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            foreach ($name in $a11Names) {
                $copy = Join-Path $skills "$name/SKILL.md"
                (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a11Repo "Shared/skills/$name/SKILL.md")).Hash
                @((Get-ChildItem -LiteralPath (Join-Path $skills $name) -Recurse -File)).Count | Should Be 1
                ([IO.File]::ReadAllText($copy)) | Should Match 'Invocation classification: restricted'
            }
            @(Get-ChildItem -LiteralPath $skills -Recurse -Filter SKILL.md).Count | Should Be @(Get-ChildItem -LiteralPath (Join-Path $a11Repo 'Shared/skills') -Recurse -Filter SKILL.md).Count
        }
    }

    It 'updates isolated pre-A11 entries while preserving other Skill bytes and adjacent persistent data' {
        $fixture = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'a11-originals-fixture.json') -Raw | ConvertFrom-Json
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a11Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a11Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            $otherHashes = @{}
            foreach ($file in Get-ChildItem -LiteralPath $skills -Recurse -File) {
                $relative = [IO.Path]::GetRelativePath($skills, $file.FullName).Replace('\', '/')
                if ($a11Names -notcontains $relative.Split('/')[0]) {
                    $otherHashes[$file.FullName] = (Get-FileHash -LiteralPath $file.FullName).Hash
                }
            }
            foreach ($name in $a11Names) {
                $old = $fixture.originals_base64.PSObject.Properties["Shared/skills/$name/SKILL.md"].Value
                [IO.File]::WriteAllBytes((Join-Path $skills "$name/SKILL.md"), [Convert]::FromBase64String($old))
            }
            foreach ($area in @('.agents/memory', '.agents/context', '.cartridge', 'project-data')) {
                $directory = Join-Path $a11Target $area
                $null = New-Item -ItemType Directory -Path $directory -Force
                $file = Join-Path $directory 'existing.txt'
                [IO.File]::WriteAllText($file, 'isolated protected fixture')
                $otherHashes[$file] = (Get-FileHash -LiteralPath $file).Hash
            }
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a11Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($name in $a11Names) {
                (Get-FileHash -LiteralPath (Join-Path $skills "$name/SKILL.md")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a11Repo "Shared/skills/$name/SKILL.md")).Hash
            }
            foreach ($path in $otherHashes.Keys) {
                (Get-FileHash -LiteralPath $path).Hash | Should Be $otherHashes[$path]
            }
        }
    }
}
