Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$resolutionRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $resolutionRepo 'Scripts/modules/Runtime-Copy-Resolution.psm1') -Force
Import-Module (Join-Path $resolutionRepo 'Scripts/modules/Deployment.Preflight.psm1') -Force
Import-Module (Join-Path $resolutionRepo 'Scripts/modules/Skill-Migration.psm1') -Force
Import-Module (Join-Path $resolutionRepo 'Scripts/modules/Deployment.Transaction.psm1') -Force
$fixtureSkills = @(Get-LegacySkillMigrationArtifacts | Where-Object {
    $_.old_relative_path -match '^[a-z0-9-]+/SKILL\.md$'
} | Select-Object -ExpandProperty old_relative_path -Unique | Sort-Object | Select-Object -First 29)
if ($fixtureSkills.Count -ne 29) { throw 'Synthetic cohort requires 29 retired Skill names.' }
$originalRecords = @(
    foreach ($surface in @('.agents/skills','.claude/skills')) {
        foreach ($skill in $fixtureSkills) {
            [pscustomobject]@{
                path="$surface/$skill"
                platform=$(if ($surface -eq '.claude/skills') { 'Claude' } else { 'Antigravity+Codex' })
                classification=$(if ($skill -eq $fixtureSkills[0]) { 'PROVEN_FRAMEWORK_OWNED' } else { 'PROBABLE_FRAMEWORK_OWNED' })
            }
        }
    }
)

function New-ResolutionFixture {
    $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    $target = Join-Path $root 'project'
    $null = New-Item -ItemType Directory -Path $target -Force
    $records = @(); $plan = @()
    foreach ($source in $originalRecords) {
        $file = Join-Path $target $source.path
        $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
        [IO.File]::WriteAllText($file, "synthetic old Skill: $($source.path)", [Text.UTF8Encoding]::new($false))
        $sha = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant()
        $records += [pscustomobject]@{ path=$source.path; classification=$source.classification; current_sha256=$sha; size=(Get-Item -LiteralPath $file).Length }
        $plan += [pscustomobject]@{ platform=$source.platform; target_path=$source.path; source_path=$null; content_type='LegacySkill'; planned_action='PRESERVE'; reason='unconfirmed_retired_copy_blocks_migration'; current_sha256=$sha; source_sha256=$null; ownership_class='unconfirmed'; blocking=$true; migration_id=$source.path; known_framework_hash_match=$false; provenance_status=$source.classification }
    }
    foreach ($relative in @('.agents/project_skills/_index.md','.agents/context/_map/CONTEXT.md')) {
        $file = Join-Path $target $relative
        $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
        [IO.File]::WriteAllText($file, 'synthetic protected content', [Text.UTF8Encoding]::new($false))
    }
    $evidence = Join-Path $root 'gate3a-synthetic.json'
    [IO.File]::WriteAllText($evidence, (ConvertTo-Json -InputObject $records -Depth 5), [Text.UTF8Encoding]::new($false))
    $candidate = Get-RuntimeCopyResolutionCandidate -RepoRoot $resolutionRepo -TargetRoot $target -Gate3AEvidencePath $evidence -BasePlan $plan
    return [pscustomobject]@{ root=$root; target=$target; evidence=$evidence; receipts=$records; plan=$plan; candidate=$candidate; archive_root=(Join-Path $root 'archive-store') }
}

function New-FixtureResolution([object]$Candidate) {
    return [pscustomobject]@{
        decision='ARCHIVE_AND_RESOLVE'; invocation_id=[guid]::NewGuid().ToString()
        target_root=$Candidate.target_root; source_fingerprint=$Candidate.source_fingerprint
        base_preflight_plan_hash=$Candidate.base_preflight_plan_hash
        gate3a_evidence_hash=$Candidate.gate3a_evidence_hash; target_set_digest=$Candidate.target_set_digest
        entries=@($Candidate.targets | ForEach-Object {
            [pscustomobject]@{ path=$_.path; expected_sha256=$_.current_sha256; provenance_classification=$_.provenance_classification; resolution_action='ARCHIVE_AND_RESOLVE' }
        })
    }
}

function Assert-ResolutionThrows([scriptblock]$Action, [string]$Pattern) {
    $caught = $false
    try { $null = & $Action } catch { $caught = $_.Exception.Message -like $Pattern }
    if (-not $caught) { throw "Expected failure: $Pattern" }
}

Describe 'Gate 4B invocation-scoped runtime copy resolution' {
    It 'rejects resolution inputs before a Global profile action can write' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $profile = Join-Path $root 'profile'
        $output = & pwsh -NoProfile -File (Join-Path $resolutionRepo 'Scripts/Deploy.ps1') -Action Global -Apply -ProfileRoot $profile -RuntimeCopyResolutionPath (Join-Path $root 'unused-resolution.json') 2>&1 | Out-String
        $LASTEXITCODE | Should Not Be 0
        $output | Should Match 'RuntimeCopyResolution.NotSupportedForGlobalAction'
        (Test-Path -LiteralPath $profile) | Should Be $false
    }

    It 'keeps all 58 entries blocked without a resolution and has a pending candidate' {
        $fixture = New-ResolutionFixture
        $fixture.candidate.decision_state | Should Be 'PENDING_USER_DECISION'
        $fixture.candidate.targets.Count | Should Be 58
        @($fixture.plan | Where-Object { $_.planned_action -eq 'PRESERVE' -and $_.blocking }).Count | Should Be 58
    }

    It 'turns exactly 58 fixture entries into archive-required RETIRE in real preflight logic' {
        $fixture = New-ResolutionFixture
        $approval = New-FixtureResolution $fixture.candidate
        $base = @(Get-DeploymentUpgradePreflight -RepoRoot $resolutionRepo -TargetRoot $fixture.target -ProvenanceReceipts $fixture.receipts)
        $candidate = Get-RuntimeCopyResolutionCandidate -RepoRoot $resolutionRepo -TargetRoot $fixture.target -Gate3AEvidencePath $fixture.evidence -BasePlan $base
        $approval = New-FixtureResolution $candidate
        $resolved = @(Get-DeploymentUpgradePreflight -RepoRoot $resolutionRepo -TargetRoot $fixture.target -ProvenanceReceipts $fixture.receipts -RuntimeCopyResolution $approval -Gate3AEvidencePath $fixture.evidence -SelectedPlatform All)
        @($resolved | Where-Object { $_.PSObject.Properties['resolution_basis'] -and $_.resolution_basis -eq 'invocation_scoped_user_decision' -and $_.planned_action -eq 'RETIRE' -and $_.archive_required -and -not $_.blocking }).Count | Should Be 58
        @($resolved | Where-Object { $_.PSObject.Properties['original_provenance_classification'] -and $_.original_provenance_classification -eq 'PROVEN_FRAMEWORK_OWNED' }).Count | Should Be 2
        @($resolved | Where-Object { $_.PSObject.Properties['original_provenance_classification'] -and $_.original_provenance_classification -eq 'PROBABLE_FRAMEWORK_OWNED' }).Count | Should Be 56
    }

    It 'rejects missing, extra, duplicate and single-platform cohorts' {
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $r -SelectedPlatform All
        Assert-ResolutionThrows { Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $r -SelectedPlatform Claude } '*WholeCohortRequiresAllPlatforms*'
        $r.entries = @($r.entries | Select-Object -Skip 1)
        Assert-ResolutionThrows { Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $r -SelectedPlatform All } '*IncompleteResolution*'
        $r = New-FixtureResolution $f.candidate
        $r.entries = @($r.entries) + $r.entries[0]
        Assert-ResolutionThrows { Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $r -SelectedPlatform All } '*IncompleteResolution*'
        $r = New-FixtureResolution $f.candidate
        $r.entries[1].path = $r.entries[0].path
        Assert-ResolutionThrows { Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $r -SelectedPlatform All } '*EntryMismatch*'
    }

    It 'rejects hash, source, plan, evidence, digest and target-root drift' {
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        foreach ($field in @('source_fingerprint','base_preflight_plan_hash','gate3a_evidence_hash','target_set_digest','target_root')) {
            $changed = New-FixtureResolution $f.candidate
            $changed.$field = 'drift'
            Assert-ResolutionThrows { Assert-RuntimeCopyResolution -Candidate $f.candidate -Resolution $changed -SelectedPlatform All } '*IdentityMismatch*'
        }
        [IO.File]::AppendAllText((Join-Path $f.target $f.candidate.targets[0].path), 'user edit')
        Assert-ResolutionThrows { Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate } '*TargetHashDrift*'
    }

    It 'rejects changed file type and linked target paths' {
        $f = New-ResolutionFixture
        $path = Join-Path $f.target $f.candidate.targets[0].path
        Remove-Item -LiteralPath $path -Force
        $null = New-Item -ItemType Directory -Path $path
        Assert-ResolutionThrows { Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate } '*TargetTypeDrift*'
        $f = New-ResolutionFixture
        $path = Join-Path $f.target $f.candidate.targets[0].path
        $other = Join-Path $f.root 'other.txt'
        [IO.File]::WriteAllText($other, 'outside fixture target')
        Remove-Item -LiteralPath $path -Force
        $null = New-Item -ItemType SymbolicLink -Path $path -Target $other -ErrorAction Stop
        Assert-ResolutionThrows { Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate } '*Deployment.LinkedPath*'

        $f = New-ResolutionFixture
        $path = Join-Path $f.target $f.candidate.targets[0].path
        $parent = Split-Path $path -Parent
        $otherParent = Join-Path $f.root 'linked-skill-parent'
        $null = New-Item -ItemType Directory -Path $otherParent
        Copy-Item -LiteralPath $path -Destination (Join-Path $otherParent 'SKILL.md')
        Remove-Item -LiteralPath $parent -Recurse -Force
        $null = New-Item -ItemType SymbolicLink -Path $parent -Target $otherParent -ErrorAction Stop
        Assert-ResolutionThrows { Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate } '*Deployment.LinkedPath*'
    }

    It 'captures all 58 outside the loader and rejects archive conflicts and partial failure' {
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        $archive = New-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -RepoRoot $resolutionRepo -ArchiveRoot $f.archive_root
        (Assert-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -ArchivePath $archive) | Should Be $true
        $archive.StartsWith($f.target,[StringComparison]::OrdinalIgnoreCase) | Should Be $false
        Assert-ResolutionThrows { New-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -RepoRoot $resolutionRepo -ArchiveRoot $f.archive_root } '*ArchiveAlreadyExists*'
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        Assert-ResolutionThrows { New-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -RepoRoot $resolutionRepo -ArchiveRoot $f.archive_root -TestFailAfterCopies 7 } '*TestPartialArchiveFailure*'
        Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate
        @((Get-ChildItem -LiteralPath $f.archive_root -Recurse -Filter 'archive-manifest.json' -File -ErrorAction SilentlyContinue)).Count | Should Be 0
    }

    It 'uses the existing transaction to roll back a later failure while retaining the archive' {
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        $archive = New-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -RepoRoot $resolutionRepo -ArchiveRoot $f.archive_root
        Assert-ResolutionThrows {
            Invoke-DeploymentTransaction -TargetRoot $f.target -Action {
                Remove-ResolvedRuntimeCopies -Candidate $f.candidate -Resolution $r -ArchivePath $archive
                $newPath = Join-Path $f.target '.agents/shared/vnext-fixture.md'
                $null = New-Item -ItemType Directory -Path (Split-Path $newPath -Parent) -Force
                [IO.File]::WriteAllText($newPath, 'new projection')
                throw 'synthetic later deployment failure'
            }
        } '*synthetic later deployment failure*'
        Assert-RuntimeCopyTargetsCurrent -Candidate $f.candidate
        (Test-Path -LiteralPath (Join-Path $f.target '.agents/shared/vnext-fixture.md')) | Should Be $false
        (Assert-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -ArchivePath $archive) | Should Be $true
    }

    It 'keeps recoverable original bytes after successful fixture deployment' {
        $f = New-ResolutionFixture
        $r = New-FixtureResolution $f.candidate
        $archive = New-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -RepoRoot $resolutionRepo -ArchiveRoot $f.archive_root
        Invoke-DeploymentTransaction -TargetRoot $f.target -Action {
            Remove-ResolvedRuntimeCopies -Candidate $f.candidate -Resolution $r -ArchivePath $archive
            $newPath = Join-Path $f.target '.agents/shared/vnext-fixture.md'
            $null = New-Item -ItemType Directory -Path (Split-Path $newPath -Parent) -Force
            [IO.File]::WriteAllText($newPath, 'new projection')
        }
        @($f.candidate.targets | Where-Object { Test-Path -LiteralPath (Join-Path $f.target $_.path) }).Count | Should Be 0
        (Test-Path -LiteralPath (Join-Path $f.target '.agents/shared/vnext-fixture.md')) | Should Be $true
        (Assert-RuntimeCopyArchive -Candidate $f.candidate -Resolution $r -ArchivePath $archive) | Should Be $true
    }
}
