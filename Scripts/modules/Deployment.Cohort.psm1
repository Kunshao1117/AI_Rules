# Read-only exact planning for a shared surface; never an authorization or deployer.
Import-Module (Join-Path $PSScriptRoot 'Deployment.Preflight.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Runtime-Copy-Resolution.psm1') -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1') -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Skills-Sync.psm1') -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Skill-Migration.psm1') -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Platform-Codex.psm1') -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot 'Core.psm1') -DisableNameChecking

function Get-CohortBytesHash {
    param([byte[]]$Bytes)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($sha.ComputeHash($Bytes)).Replace('-','').ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Get-CohortPlanDigest {
    param([object]$Plan)
    $rows = @($Plan.ExactEntries | Sort-Object RelativePath | ForEach-Object {
        [ordered]@{
            path=$_.RelativePath; action=$_.Action; current=$_.CurrentSha256
            known=@($_.KnownSha256 | Sort-Object); intended=$_.IntendedSha256
            bytes=$(if($null -ne $_.ProjectedBytesBase64){Get-CohortBytesHash ([Convert]::FromBase64String($_.ProjectedBytesBase64))}else{$null})
            classification=$_.Classification
        }
    })
    $body = [ordered]@{ target=$Plan.TargetRoot; source=$Plan.SourceFingerprint; unit=$Plan.MinimumSafeDeploymentUnit; rows=$rows }
    Get-CohortBytesHash ([Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json -Depth 8 -Compress)))
}

function Get-CohortFrameworkProvenance {
    param([string]$RepoRoot, [string]$RelativePath, [AllowNull()][string]$CurrentSha256)
    if (-not $CurrentSha256) { return [pscustomobject]@{ Classification='MISSING'; KnownSha256=@(); Evidence=@() } }
    $manifest = Get-Content -LiteralPath (Join-Path $RepoRoot 'Shared/policies/references/m5c-runtime-provenance.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($manifest.schema_version -ne 1) { throw 'Cohort.InvalidProvenanceSchema' }
    $rows = @($manifest.records | Where-Object {
        $_.path -ceq $RelativePath -and $_.known_sha256 -ceq $CurrentSha256 -and
        $_.classification -in @('FRAMEWORK_PROVEN_EXACT','FRAMEWORK_PROVEN_COMPATIBLE') -and @($_.evidence).Count -gt 0
    })
    if ($rows.Count -gt 1) { throw 'Cohort.AmbiguousProvenance' }
    if ($rows.Count -eq 1) {
        return [pscustomobject]@{ Classification=$rows[0].classification; KnownSha256=@($rows[0].known_sha256); Evidence=@($rows[0].evidence) }
    }
    # No whitespace normalization and no approval based on today's target bytes.
    return [pscustomobject]@{ Classification='UNKNOWN_PROVENANCE'; KnownSha256=@(); Evidence=@() }
}

function Test-CohortRetiredConsumerRoute {
    param([string]$Text,[string]$SkillId)
    $active = [regex]::Replace($Text, '(?s)<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->.*?<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->', '')
    # Both YAML flow lists and indented block lists are platform route syntax.
    foreach ($match in [regex]::Matches($active, '(?m)^[ \t]*required_skills:[ \t]*(?<inline>\[[\s\S]*?\]|[^\r\n]*)(?<block>(?:\r?\n(?:[ \t]*-[^\r\n]*|[ \t]*#[^\r\n]*|[ \t]*(?=\r?$)))*)')) {
        $declaration = [regex]::Replace(($match.Groups['inline'].Value + $match.Groups['block'].Value), '(?m)#.*$', '')
        $ids = @([regex]::Matches($declaration, '[a-z0-9][a-z0-9-]*') | ForEach-Object { $_.Value })
        if ($SkillId -cin $ids) { return $true }
    }
    # Catch absolute framework and relative sibling Skill paths. A canonical
    # legacy REFERENCE.md link is intentionally not an active SKILL.md route.
    $route = '(?m)(^|[^A-Za-z0-9_-])' + [regex]::Escape($SkillId) + '/SKILL\.md(?=$|[^A-Za-z0-9_.-])'
    return [regex]::IsMatch($active, $route)
}

function Get-CohortProjectedBytes {
    param([string]$RepoRoot, [string]$TargetRoot, [object]$Record)
    if ($Record.planned_action -eq 'RETIRE') { return [pscustomobject]@{ Bytes=$null; Generator='exact known-path retirement'; Inputs=@(); OwnedRegion='whole framework artifact'; PreservedRegion='all adjacent files' } }
    $source = [string]$Record.source_path
    $target = Join-Path $TargetRoot $Record.target_path
    $encoding = [Text.UTF8Encoding]::new($false)
    $inputs = @($source)
    $generator = 'Copy-Item: exact canonical source bytes'
    $owned = 'whole proven framework artifact'; $preserved = 'all paths outside exact inventory'
    switch ($Record.content_type) {
        'Skill' {
            $skillsRoot = Join-Path $RepoRoot 'Shared/skills'
            $rel = [IO.Path]::GetFullPath($source).Substring([IO.Path]::GetFullPath($skillsRoot).TrimEnd('\','/').Length).TrimStart('\','/')
            $targetSkills = $target.Substring(0,$target.Length-$rel.Length).TrimEnd('\','/')
            $bytes = Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $skillsRoot -TargetSkillsPath $targetSkills
            $generator = 'Get-SharedSkillProjectedBytes: source-valid active policy references + exact bytes'
            $inputs += Join-Path $PSScriptRoot 'Skills-Sync.psm1'
        }
        'GeneratedEntry' {
            $platform = if ($Record.target_path -eq '.codex/AGENTS.md') { 'Codex' } elseif ($Record.target_path -eq '.agents/rules/00_core_identity.md') { 'Antigravity' } else { throw 'Cohort.UnsupportedGeneratedEntry' }
            $template = Join-Path $RepoRoot $(if ($platform -eq 'Codex') { 'Codex/.codex/AGENTS.md' } else { 'Antigravity/.agents/rules/00_core_identity.md' })
            $before = if ($platform -eq 'Antigravity') { '(?m)^## 2\. Agentic Swarm UI Visibility' } else { '' }
            $after = if ($platform -eq 'Codex') { '(?m)^Codex-specific governance:\s*$' } else { '' }
            $text = Get-SharedPolicyBlockProjectedText -PolicyPath $source -Content (Get-Content -LiteralPath $template -Raw -Encoding UTF8) -Platform $platform -InsertBeforePattern $before -InsertAfterPattern $after
            $bytes = $encoding.GetBytes($text)
            $generator = 'template copy + Get-SharedPolicyBlockProjectedText + UTF8 without BOM (Sync-SharedPolicyBlock writer)'
            $inputs += $template
        }
        'Version' {
            $bytes = $encoding.GetBytes((Get-Content -LiteralPath $source -Raw -Encoding UTF8).Trim())
            $generator = 'Get-VersionContent + UTF8 without BOM / NoNewline'
        }
        'Config' {
            $merge = Merge-CodexConfigDefaults -SourcePath $source -TargetPath $target
            if (-not $merge.PSObject.Properties['ProjectedText']) { throw 'Cohort.ConfigProjectedBytesUnavailable' }
            $bytes = $encoding.GetBytes([string]$merge.ProjectedText)
            $generator = 'Merge-CodexConfigDefaults: section-aware required key merge'
            $owned = 'missing fallback/max_threads defaults; features.multi_agent boolean'
            $preserved = 'all other user keys, sections and comments; never full-file source replace'
        }
        'ProjectMetadata' {
            # Use the existing writer's exact deterministic transform, without Apply.
            $text = Get-AiRulesTextFileContent -Path $target
            $clean = Remove-AiRulesGitignoreStandardLines -Content $text
            $nl = [Environment]::NewLine
            $future = if ($clean.Length) { $clean + $nl + $nl } else { '' }
            $future += (@(Get-AiRulesGitignoreManagedBlock -AdditionalLines @('.agents/logs/','.cartridge/')) -join $nl) + $nl
            $bytes = [Text.UTF8Encoding]::new($true).GetPreamble() + [Text.UTF8Encoding]::new($true).GetBytes($future)
            $generator = 'Core.Gitignore exact standard-line transform + UTF8 BOM writer'
            $owned = 'exact framework standard patterns/comments only (not similar user patterns)'
            $preserved = 'nonstandard user patterns/comments in original order; writer normalizes line endings'
        }
        default {
            if (-not $source -or -not (Test-Path -LiteralPath $source -PathType Leaf)) { throw 'Cohort.MissingProjectionOwner' }
            $bytes = [IO.File]::ReadAllBytes($source)
        }
    }
    return [pscustomobject]@{ Bytes=[byte[]]$bytes; Generator=$generator; Inputs=$inputs; OwnedRegion=$owned; PreservedRegion=$preserved }
}

function Get-SharedCodexDeploymentCohortPreflight {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][string]$RepoRoot, [Parameter(Mandatory=$true)][string]$TargetRoot)
    $ErrorActionPreference = 'Stop'
    $repo = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/')
    $root = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    Assert-DeploymentPathUnlinked -Path $root
    $sourceBefore = Get-RuntimeCopySourceFingerprint -RepoRoot $repo
    $base = @(Get-DeploymentUpgradePreflight -RepoRoot $repo -TargetRoot $root)
    $selected = @($base | Where-Object {
        $_.target_path -match '^(\.agents/(shared|skills|tools|rules|workflows|agents)/|\.agents/VERSION$|\.codex/|\.gitignore$)'
    })
    $entries = @(); $blockers = @(); $preserved = @()
    foreach ($record in $selected) {
        if ($record.blocking -or $record.planned_action -eq 'BLOCK') { $blockers += $record }
        if ($record.planned_action -notin @('ADD','UPDATE','RETIRE')) {
            $preserved += $record
            # An unowned active loader entry must not retain a retired route.
            if ($record.planned_action -eq 'PRESERVE' -and
                $record.target_path -match '(\.agents/(rules|workflows|agents)/.+\.md$|/SKILL\.md$)') {
                $consumerPath = Join-Path $root $record.target_path
                Assert-DeploymentPathUnlinked -Path $consumerPath
                $text = Get-Content -LiteralPath $consumerPath -Raw -Encoding UTF8
                foreach ($old in @(Get-LegacySkillMigrationArtifacts -SharedRoot (Join-Path $repo 'Shared') | Where-Object { $_.old_relative_path -match '/SKILL\.md$' })) {
                    if (Test-CohortRetiredConsumerRoute -Text $text -SkillId $old.skill) {
                        $blockers += [pscustomobject]@{ target_path=$record.target_path; reason='preserved_active_entry_has_retired_route'; blocking=$true }
                    }
                }
            }
            continue
        }
        $null = Resolve-DeploymentRecoveryPath -TargetRoot $root -RelativePath $record.target_path
        $projection = Get-CohortProjectedBytes -RepoRoot $repo -TargetRoot $root -Record $record
        $intended = if ($null -ne $projection.Bytes) { Get-CohortBytesHash -Bytes $projection.Bytes } else { $null }
        $provenance = Get-CohortFrameworkProvenance -RepoRoot $repo -RelativePath $record.target_path -CurrentSha256 $record.current_sha256
        $known = @($provenance.KnownSha256)
        if ($record.planned_action -eq 'RETIRE' -and $record.known_framework_hash_match -and
            $provenance.Classification -notin @('FRAMEWORK_PROVEN_EXACT','FRAMEWORK_PROVEN_COMPATIBLE')) {
            # Already owned by the independent A1-M3 retirement manifest.
            $provenance = [pscustomobject]@{ Classification='FRAMEWORK_PROVEN_EXACT'; KnownSha256=@($record.current_sha256); Evidence=@('existing exact retirement manifest') }
            $known = @($provenance.KnownSha256)
        }
        if ($record.current_sha256 -and $record.current_sha256 -ceq $intended) {
            $provenance = [pscustomobject]@{ Classification='FRAMEWORK_PROVEN_EXACT'; Evidence=@('exact deterministic canonical output'); KnownSha256=@($intended) }
            $known = @($intended)
        }
        if ($record.current_sha256 -and $provenance.Classification -eq 'UNKNOWN_PROVENANCE') {
            $blockers += [pscustomobject]@{ target_path=$record.target_path; reason='unapproved_existing_preimage_preserve_and_block'; blocking=$true }
        }
        $entries += [pscustomobject]@{
            RelativePath=$record.target_path; Action=$record.planned_action; CurrentSha256=$record.current_sha256
            KnownSha256=$known; IntendedSha256=$intended; Classification=$provenance.Classification
            Evidence=$provenance.Evidence; CanonicalOwner=$record.source_path; Generator=$projection.Generator
            GeneratorInputs=$projection.Inputs; OwnedRegion=$projection.OwnedRegion; PreservedRegion=$projection.PreservedRegion
            GeneratorInputFingerprints=@($projection.Inputs | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } | ForEach-Object {
                [pscustomobject]@{ Path=$_; Sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash.ToLowerInvariant() }
            })
            GeneratorSource=$(switch($record.content_type){
                'GeneratedEntry' {'Scripts/modules/Skills-Sync.psm1'}
                'Config' {'Scripts/modules/Platform-Codex.psm1'}
                'ProjectMetadata' {'Scripts/modules/Core.Gitignore.psm1'}
                'Version' {'Scripts/modules/Platform-Codex.psm1 (NoNewline scalar); Deployment.Cohort.psm1 (exact UTF8 bytes)'}
                default {'Scripts/modules/Deployment.Cohort.psm1 (exact copy or known-path retirement)'}
            })
            ProjectedBytesBase64=$(if($null -ne $projection.Bytes){[Convert]::ToBase64String($projection.Bytes)}else{$null})
        }
    }
    $sourceAfter = Get-RuntimeCopySourceFingerprint -RepoRoot $repo
    if ($sourceBefore -cne $sourceAfter) { throw 'Cohort.SourceChangedDuringInspection' }
    $plan = [pscustomobject]@{
        SchemaVersion=1; MinimumSafeDeploymentUnit='project/shared-canonical+Codex-adapter+affected-Antigravity-consumers'
        TargetRoot=$root; SourceFingerprint=$sourceAfter
        AffectedPlatforms=@('Codex','Antigravity'); IndirectSharedPolicyReaders=@('Claude','Cursor')
        ActivatedPlatforms=@(); ClaudePrivateActivation=$false; MemoryMutationActivation=$false
        CartridgeBlocker='CARTRIDGE_MEMORY_WARNING_SELF_WRITE_BLOCKER'; AuthorizationGranted=$false
        ExactEntries=$entries; Preserved=$preserved; Blockers=$blockers; Ready=($blockers.Count -eq 0)
        Exclusions=@('.claude/**','.cursor/**','.agents/memory/**','.agents/context/**','.agents/project_skills/**','.cartridge/**','.git/**','credentials','logs','global profiles')
        LegacyResolverConstraint='All+58 remains for unproven/user-decision archive resolution; proven exact manifest retirement is independently scoped by exact shared paths'
    }
    $plan | Add-Member -NotePropertyName PlanDigest -NotePropertyValue (Get-CohortPlanDigest $plan)
    return $plan
}

function Assert-DeploymentCohortCurrent {
    # Read-only boundary validation before the future, separately authorized
    # exact transaction. Replanning prevents caller-supplied known hashes,
    # bytes or scope from silently expanding a prepared plan.
    [CmdletBinding()]
    param([string]$RepoRoot,[string]$TargetRoot,[object]$Plan)
    $ErrorActionPreference = 'Stop'
    $root=[IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    if (-not $Plan.Ready -or $Plan.TargetRoot -cne $root -or
        $Plan.AuthorizationGranted -or $Plan.ClaudePrivateActivation -or
        $Plan.MemoryMutationActivation -or @($Plan.ActivatedPlatforms).Count) {
        throw 'Cohort.UnapprovedBoundary'
    }
    if ($Plan.SourceFingerprint -cne (Get-RuntimeCopySourceFingerprint -RepoRoot $RepoRoot)) { throw 'Cohort.SourceDrift' }
    if ($Plan.PlanDigest -cne (Get-CohortPlanDigest $Plan)) { throw 'Cohort.PlanBytesOrScopeDrift' }
    $fresh=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $RepoRoot -TargetRoot $root
    if (-not $fresh.Ready -or $fresh.PlanDigest -cne $Plan.PlanDigest) { throw 'Cohort.PreimageOrProjectionDrift' }
    return $true
}

Export-ModuleMember -Function Get-CohortFrameworkProvenance, Get-CohortProjectedBytes, Get-SharedCodexDeploymentCohortPreflight, Assert-DeploymentCohortCurrent
