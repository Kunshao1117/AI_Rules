Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a13Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a13Names = @('maps-assist')
$a13Guides = @('maps-guide.md')

Describe 'A13 retained Maps isolated projection' {
    BeforeEach {
        Import-Module (Join-Path $a13Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        $a13Target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $a13Target
    }

    It 'projects the retained entry and the shared provider reference without new Skill identities' {
        $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $a13Repo 'Shared') -TargetAgentsRoot (Join-Path $a13Target '.agents') -Mode Full
        foreach ($guide in $a13Guides) {
            $copy = Join-Path $a13Target ".agents/shared/policies/references/$guide"
            (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a13Repo "Shared/policies/references/$guide")).Hash
        }
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a13Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a13Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            foreach ($name in $a13Names) {
                $copy = Join-Path $skills "$name/SKILL.md"
                (Get-FileHash -LiteralPath $copy).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a13Repo "Shared/skills/$name/SKILL.md")).Hash
                @((Get-ChildItem -LiteralPath (Join-Path $skills $name) -Recurse -File)).Count | Should Be 1
                $invocation = 'restricted'
                ([IO.File]::ReadAllText($copy)) | Should Match "Invocation classification: $invocation"
            }
            @(Get-ChildItem -LiteralPath $skills -Recurse -Filter SKILL.md).Count | Should Be @(Get-ChildItem -LiteralPath (Join-Path $a13Repo 'Shared/skills') -Recurse -Filter SKILL.md).Count
        }
    }

    It 'updates isolated pre-A13 entries while preserving other Skill bytes and adjacent persistent data' {
        $fixture = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'a13-originals-fixture.json') -Raw | ConvertFrom-Json
        foreach ($surface in @('.agents/skills', '.claude/skills', '.cursor/skills')) {
            $skills = Join-Path $a13Target $surface
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a13Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Full
            $otherHashes = @{}
            foreach ($file in Get-ChildItem -LiteralPath $skills -Recurse -File) {
                $relative = $file.FullName.Substring($skills.Length + 1).Replace('\', '/')
                if ($a13Names -notcontains $relative.Split('/')[0]) {
                    $otherHashes[$file.FullName] = (Get-FileHash -LiteralPath $file.FullName).Hash
                }
            }
            foreach ($name in $a13Names) {
                $old = $fixture.originals_base64.PSObject.Properties["Shared/skills/$name/SKILL.md"].Value
                [IO.File]::WriteAllBytes((Join-Path $skills "$name/SKILL.md"), [Convert]::FromBase64String($old))
            }
            foreach ($area in @('.agents/memory', '.agents/context', '.cartridge', 'project-data')) {
                $directory = Join-Path $a13Target $area
                $null = New-Item -ItemType Directory -Path $directory -Force
                $file = Join-Path $directory 'existing.txt'
                [IO.File]::WriteAllText($file, 'isolated protected fixture')
                $otherHashes[$file] = (Get-FileHash -LiteralPath $file).Hash
            }
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a13Repo 'Shared/skills') -TargetSkillsPath $skills -Mode Diff
            foreach ($name in $a13Names) {
                (Get-FileHash -LiteralPath (Join-Path $skills "$name/SKILL.md")).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $a13Repo "Shared/skills/$name/SKILL.md")).Hash
            }
            foreach ($path in $otherHashes.Keys) {
                (Get-FileHash -LiteralPath $path).Hash | Should Be $otherHashes[$path]
            }
        }
    }
}
