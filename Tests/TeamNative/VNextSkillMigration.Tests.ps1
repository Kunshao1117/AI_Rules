Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$a1Repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$a1Shared = Join-Path $a1Repo 'Shared'

function Write-A1Fixture([string]$Path, [string]$Text) {
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}
function Get-A1Fingerprint([string]$Root) {
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + (Get-FileHash -LiteralPath $_.FullName).Hash
    } | Sort-Object) -join "`n")
}
function Add-A1OfficialCopy([object]$Artifact, [string]$SkillsRoot) {
    # The archive keeps the exact pre-A1 source bytes after a UTF-8 preamble.
    $archiveRel = if ($Artifact.PSObject.Properties['archive_relative_path']) { $Artifact.archive_relative_path } else { $Artifact.reference_relative_path }
    $bytes = [IO.File]::ReadAllBytes((Join-Path $a1Shared $archiveRel))
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

function Get-A1ImmutableGitBytes([object]$Approval) {
    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = 'git'
    $start.Arguments = '-C "' + $a1Repo + '" show ' + $Approval.revision + ':' + $Approval.source
    $start.UseShellExecute = $false
    $start.CreateNoWindow = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $start
    $stream = [IO.MemoryStream]::new()
    try {
        $null = $process.Start()
        $process.StandardOutput.BaseStream.CopyTo($stream)
        $errorText = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) { throw "Immutable Git source unavailable: $errorText" }
        return ,([byte[]]$stream.ToArray())
    } finally { $stream.Dispose(); $process.Dispose() }
}

Describe 'Approved immutable Git checkout representations' {
    BeforeEach {
        Import-Module (Join-Path $a1Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a1Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $approval = @((Get-Content -LiteralPath (Join-Path $a1Shared 'policies/references/legacy-skill-migration.json') -Raw | ConvertFrom-Json).approved_checkout_representations |
            Where-Object old_relative_path -eq 'programming-team-governance/SKILL.md')[0]
        $blob = Get-A1ImmutableGitBytes $approval
        $entry = @(Get-RetiredSharedSkillManifest | Where-Object RelativePath -eq $approval.old_relative_path)[0]
        $caseRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $file = Join-Path $caseRoot $approval.old_relative_path
        $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
    }
    It 'accepts only the approved <Format> representation of the immutable historical source' -TestCases @(
        @{ Format='git_blob' }, @{ Format='LF' }, @{ Format='CRLF' }
    ) {
        param($Format)
        $bytes = if ($Format -eq 'CRLF') {
            [Text.Encoding]::UTF8.GetBytes([Text.Encoding]::UTF8.GetString($blob).Replace("`n", "`r`n"))
        } else { $blob }
        [IO.File]::WriteAllBytes($file, $bytes)
        (Get-FileHash $file).Hash.ToLowerInvariant() | Should Be $approval.representations.$Format
        $decision = Get-ManagedSkillRetirementDecision -TargetPath $file -KnownSha256 $entry.KnownSha256
        $decision.Action | Should Be 'RETIRE'
        $decision.KnownFrameworkHashMatch | Should Be $true
        Assert-LegacySkillMigrationReady -TargetSkillsPath $caseRoot
    }
    It 'preserves and blocks <Mutation> without normalizing arbitrary user bytes' -TestCases @(
        @{ Mutation='one-character' }, @{ Mutation='added-line' }, @{ Mutation='deleted-line' },
        @{ Mutation='unknown-version' }, @{ Mutation='unknown-encoding' }, @{ Mutation='unapproved-BOM' },
        @{ Mutation='unknown-raw-hash' }, @{ Mutation='unapproved-no-newline' }
    ) {
        param($Mutation)
        $text = [Text.Encoding]::UTF8.GetString($blob)
        $bytes = switch ($Mutation) {
            'one-character' { [Text.Encoding]::UTF8.GetBytes('X' + $text.Substring(1)) }
            'added-line' { [Text.Encoding]::UTF8.GetBytes($text + "user line`n") }
            'deleted-line' { [Text.Encoding]::UTF8.GetBytes($text.Substring($text.IndexOf("`n") + 1)) }
            'unknown-version' { [Text.Encoding]::UTF8.GetBytes($text.Replace('programming', 'programminG')) }
            'unknown-encoding' { [Text.Encoding]::Unicode.GetBytes($text) }
            'unapproved-BOM' { [byte[]](@(0xEF,0xBB,0xBF) + @($blob)) }
            'unknown-raw-hash' { [byte[]](@($blob) + @(0x00)) }
            'unapproved-no-newline' { [Text.Encoding]::UTF8.GetBytes($text.TrimEnd("`n")) }
        }
        [IO.File]::WriteAllBytes($file, [byte[]]$bytes)
        $before = Get-A1Fingerprint $caseRoot
        $decision = Get-ManagedSkillRetirementDecision -TargetPath $file -KnownSha256 $entry.KnownSha256
        $decision.Action | Should Be 'PRESERVE'
        { Assert-LegacySkillMigrationReady -TargetSkillsPath $caseRoot } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A1Fingerprint $caseRoot) | Should Be $before
    }
    It 'rejects a checkout digest without its original immutable path/version proof even after a cached read' {
        $shared = Join-Path $caseRoot 'Shared'
        $manifestPath = Join-Path $shared 'policies/references/legacy-skill-migration.json'
        $null = New-Item -ItemType Directory -Path (Split-Path $manifestPath -Parent) -Force
        Copy-Item -LiteralPath (Join-Path $a1Shared 'policies/references/legacy-skill-migration.json') -Destination $manifestPath
        @(Get-LegacySkillMigrationArtifacts -SharedRoot $shared).Count | Should Be 54
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        $manifest.approved_checkout_representations[0].revision = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        [IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 30), [Text.UTF8Encoding]::new($false))
        { Get-LegacySkillMigrationArtifacts -SharedRoot $shared } | Should Throw 'Unproved approved Skill checkout representation'
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*' -or
                $record.Exception.Message -like 'Unproved approved Skill checkout representation:*') { $Error.Remove($record) }
        }
    }
}

Describe 'A1 exact alias and active Skill projection' {
    BeforeEach {
        Import-Module (Join-Path $a1Repo 'Scripts/modules/Skills-Sync.psm1') -Force
        Import-Module (Join-Path $a1Repo 'Scripts/modules/Skill-Migration.psm1') -Force
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $target
    }
    AfterEach {
        foreach ($record in @($Error)) {
            if ($record.Exception.Message -like 'preserved_user_modified_retired_skill:*migration blocked*' -or
                $record.Exception.Message -like 'Missing legacy reference:*' -or
                $record.Exception.Message -like 'Deployment.LinkedPath:*') { $Error.Remove($record) }
        }
    }

    It 'excludes all sixteen IDs even if source leftovers are reintroduced' {
        $names = @(Get-LegacySkillMigrationArtifacts -Batch 4B2A1 | Select-Object -ExpandProperty skill -Unique)
        $names.Count | Should Be 16
        foreach ($name in $names) {
            (Test-SharedSkillRelativePathIncluded "$name/SKILL.md") | Should Be $false
            (Test-SharedSkillRelativePathIncluded $name) | Should Be $false
        }
        (Test-SharedSkillRelativePathIncluded 'gitnexus-cli/SKILL.md') | Should Be $true
        (Test-SharedSkillRelativePathIncluded 'browser-testing/SKILL.md') | Should Be $true
    }

    It 'resolves each exact source and platform alias plus anchor without Skill invocation' {
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) {
            foreach ($prefix in @('Shared/skills/', '.agents/skills/', '.claude/skills/', '.cursor/skills/')) {
                $result = Resolve-LegacySharedSkillReference -SharedRoot $a1Shared -Reference ($prefix + $artifact.old_relative_path + '#procedure')
                $result.Kind | Should Be 'legacy-compatibility-reference'
                $result.Anchor | Should Be 'procedure'
                $result.Path | Should Be ([IO.Path]::GetFullPath((Join-Path $a1Shared $artifact.reference_relative_path)))
            }
        }
        (Resolve-LegacySharedSkillReference -SharedRoot $a1Shared -Reference 'unknown') | Should Be $null
        (Resolve-LegacySharedSkillReference -SharedRoot $a1Shared -Reference '../team-role-boundaries/SKILL.md') | Should Be $null
    }

    It 'consumes unchanged Memory relation IDs as references retaining the required roles and anchors' {
        foreach ($name in @('team-specialist-memory-docs','team-specialist-memory-closure')) {
            $text = Get-Content -LiteralPath (Join-Path $a1Shared "policies/references/legacy-skills/$name/pre-m3-original.md") -Raw -Encoding UTF8
            $relations = @([regex]::Matches($text, '(?m)^\s+(?:parent_skill:\s*|-\s+)(team-role-boundaries|team-specialist-registry)\s*$'))
            $relations.Count | Should BeGreaterThan 0
            foreach ($relation in $relations) {
                $result = Resolve-LegacySharedSkillReference -SharedRoot $a1Shared -Reference $relation.Groups[1].Value
                $body = Get-Content -LiteralPath $result.Path -Raw -Encoding UTF8
                $body | Should Match 'memory-closure'
                $body | Should Match 'memory-docs'
                if ($relation.Groups[1].Value -eq 'team-role-boundaries') { $body | Should Match '## Specialist Role Exclusivity' }
                else { $body | Should Match '### Step 2: Select the specialist' }
            }
        }
    }

    It 'projects Fresh and Diff to every destination without old active copies and with frozen references' {
        foreach ($mode in @('Full','Diff')) {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a1Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode $mode
            foreach ($surface in @('.agents/skills','.claude/skills','.cursor/skills')) {
                $skills = Join-Path $target $surface
                $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath $skills -Mode $mode
                foreach ($name in @(Get-LegacySkillMigrationArtifacts | Select-Object -ExpandProperty skill -Unique)) {
                    (Test-Path -LiteralPath (Join-Path $skills "$name/SKILL.md")) | Should Be $false
                }
                foreach ($name in @('gitnexus-cli','browser-testing','test-patterns','supabase','sentry-ops','memory-ops','memory-arch')) {
                    $bytes = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $a1Shared 'skills') -SourcePath (Join-Path $a1Shared "skills/$name/SKILL.md") -TargetSkillsPath $skills
                    $expected = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-','')
                    (Get-FileHash -LiteralPath (Join-Path $skills "$name/SKILL.md")).Hash | Should Be $expected
                }
                $resolved = Resolve-LegacySharedSkillReference -SharedRoot (Join-Path $target '.agents/shared') -Reference "$surface/team-role-boundaries/SKILL.md#specialist-role-exclusivity"
                (Get-Content -LiteralPath $resolved.Path -Raw) | Should Match '## Specialist Role Exclusivity'
            }
        }
    }

    It 'retires all known old entry and asset bytes while preserving unrelated adjacent user files' {
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) { Add-A1OfficialCopy $artifact $target }
        Write-A1Fixture (Join-Path $target 'delegation-strategy/user-notes.txt') 'keep user notes'
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath $target -Mode Diff
        foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) {
            (Test-Path -LiteralPath (Join-Path $target $artifact.old_relative_path)) | Should Be $false
        }
        [IO.File]::ReadAllText((Join-Path $target 'delegation-strategy/user-notes.txt')) | Should Be 'keep user notes'
    }

    It 'preserves a modified official entry and blocks before a direct sync writes anything' {
        $artifact = @(Get-LegacySkillMigrationArtifacts | Where-Object { $_.old_relative_path -eq 'delegation-strategy/SKILL.md' })[0]
        Add-A1OfficialCopy $artifact $target
        [IO.File]::AppendAllText((Join-Path $target $artifact.old_relative_path), "`nuser modification")
        $before = Get-A1Fingerprint $target
        { Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath $target -Mode Full } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A1Fingerprint $target) | Should Be $before
    }

    It 'preserves an unknown same-path entry and fails without overwriting it' {
        Write-A1Fixture (Join-Path $target 'team-specialist-review/SKILL.md') 'unknown owner'
        $before = Get-A1Fingerprint $target
        { Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath $target -Mode Diff } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A1Fingerprint $target) | Should Be $before
    }

    It 'rolls back earlier platform and shared writes after a later platform has an unknown old entry' {
        Import-Module (Join-Path $a1Repo 'Scripts/modules/Deployment.Transaction.psm1') -Force
        Write-A1Fixture (Join-Path $target '.cursor/skills/team-completion-gate/SKILL.md') 'unknown old entry'
        Write-A1Fixture (Join-Path $target '.agents/shared/user.md') 'original shared'
        Write-A1Fixture (Join-Path $target '.codex/VERSION') 'original version'
        Write-A1Fixture (Join-Path $target '.agents/memory/card.md') 'frozen card'
        Write-A1Fixture (Join-Path $target '.cartridge/index.json') 'frozen index'
        $before = Get-A1Fingerprint $target
        { Invoke-DeploymentTransaction -TargetRoot $target -Action {
            $null = Sync-SharedGovernanceReferences -SharedRoot $a1Shared -TargetAgentsRoot (Join-Path $target '.agents') -Mode Full
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath (Join-Path $target '.agents/skills') -Mode Full
            Write-A1Fixture (Join-Path $target '.codex/VERSION') 'would be new'
            $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $a1Shared 'skills') -TargetSkillsPath (Join-Path $target '.cursor/skills') -Mode Diff
        } } | Should Throw 'preserved_user_modified_retired_skill'
        (Get-A1Fingerprint $target) | Should Be $before
    }
}
