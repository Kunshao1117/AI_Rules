# Invocation-scoped legacy Skill resolution. This module does not grant authorization.
Import-Module (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1')

function Get-ResolutionSha256Text {
    param([Parameter(Mandatory=$true)][string]$Text)
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Get-RuntimeCopySourceFingerprint {
    param([Parameter(Mandatory=$true)][string]$RepoRoot)
    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($rootName in @('Shared','Scripts','Antigravity','Claude','Codex','Cursor')) {
        $root = Join-Path $RepoRoot $rootName
        Assert-DeploymentPathUnlinked -Path $root
        foreach ($file in @(Get-ChildItem -LiteralPath $root -Recurse -File -Force -ErrorAction Stop)) {
            Assert-DeploymentPathUnlinked -Path $file.FullName
            $relative = $file.FullName.Substring(([IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/')).Length).TrimStart('\','/').Replace('\','/')
            $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
            $lines.Add("$relative`t$hash")
        }
    }
    return Get-ResolutionSha256Text -Text ((@($lines | Sort-Object -CaseSensitive) -join "`n") + "`n")
}

function Get-RuntimeCopyBasePlanHash {
    param([Parameter(Mandatory=$true)][object[]]$BasePlan)
    $projection = @($BasePlan | Sort-Object target_path | ForEach-Object {
        [ordered]@{
            platform=$_.platform; target_path=$_.target_path; source_path=$_.source_path
            content_type=$_.content_type; planned_action=$_.planned_action; reason=$_.reason
            current_sha256=$_.current_sha256; source_sha256=$_.source_sha256
            ownership_class=$_.ownership_class; blocking=$_.blocking
            migration_id=$_.migration_id; known_framework_hash_match=$_.known_framework_hash_match
            provenance_status=$_.provenance_status
        }
    })
    return Get-ResolutionSha256Text -Text (ConvertTo-Json -InputObject $projection -Depth 12 -Compress)
}

function Get-RuntimeCopyResolutionCandidate {
    param(
        [Parameter(Mandatory=$true)][string]$RepoRoot,
        [Parameter(Mandatory=$true)][string]$TargetRoot,
        [Parameter(Mandatory=$true)][string]$Gate3AEvidencePath,
        [Parameter(Mandatory=$true)][object[]]$BasePlan
    )
    $repo = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/')
    $target = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    Assert-DeploymentPathUnlinked -Path $Gate3AEvidencePath
    $evidenceHash = (Get-FileHash -LiteralPath $Gate3AEvidencePath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
    $evidence = @(Get-Content -LiteralPath $Gate3AEvidencePath -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json)
    if ($evidence.Count -ne 58) { throw 'RuntimeCopyResolution.InvalidCohortCount' }
    $entries = @()
    foreach ($record in $evidence) {
        $path = [string]$record.path
        if ($path -cnotmatch '^(\.agents|\.claude)/skills/[a-z0-9-]+/SKILL\.md$') { throw "RuntimeCopyResolution.UnsafePath: $path" }
        if ($record.classification -cnotin @('PROVEN_FRAMEWORK_OWNED','PROBABLE_FRAMEWORK_OWNED')) { throw "RuntimeCopyResolution.InvalidProvenance: $path" }
        $file = Join-Path $target $path
        Assert-DeploymentPathUnlinked -Path $file
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "RuntimeCopyResolution.TargetTypeDrift: $path" }
        $hash = (Get-FileHash -LiteralPath $file -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        if ($hash -cne $record.current_sha256) { throw "RuntimeCopyResolution.TargetHashDrift: $path" }
        $planned = @($BasePlan | Where-Object { $_.target_path -ceq $path })
        if ($planned.Count -ne 1 -or $planned[0].content_type -cne 'LegacySkill' -or
            $planned[0].planned_action -cne 'PRESERVE' -or -not $planned[0].blocking -or
            $planned[0].current_sha256 -cne $hash) { throw "RuntimeCopyResolution.BasePlanMismatch: $path" }
        $entries += [pscustomobject]@{ path=$path; current_sha256=$hash; provenance_classification=[string]$record.classification; size=(Get-Item -LiteralPath $file -Force).Length }
    }
    $paths = @($entries | ForEach-Object path)
    if (@($paths | Sort-Object -Unique).Count -ne 58 -or
        @($paths | Where-Object { $_ -clike '.agents/skills/*' }).Count -ne 29 -or
        @($paths | Where-Object { $_ -clike '.claude/skills/*' }).Count -ne 29 -or
        @($entries | Where-Object provenance_classification -eq 'PROVEN_FRAMEWORK_OWNED').Count -ne 2) {
        throw 'RuntimeCopyResolution.IncompleteOrDuplicateCohort'
    }
    $sorted = @($entries | Sort-Object path)
    $digestLines = @($sorted | ForEach-Object { "$($_.path)`t$($_.current_sha256)`t$($_.provenance_classification)" })
    $digest = Get-ResolutionSha256Text -Text (($digestLines -join "`n") + "`n")
    return [pscustomobject]@{
        decision_state='PENDING_USER_DECISION'; target_root=$target
        source_fingerprint=(Get-RuntimeCopySourceFingerprint -RepoRoot $repo)
        base_preflight_plan_hash=(Get-RuntimeCopyBasePlanHash -BasePlan $BasePlan)
        gate3a_evidence_hash=$evidenceHash; target_set_digest=$digest
        targets=$sorted
    }
}

function Assert-RuntimeCopyResolution {
    param([Parameter(Mandatory=$true)][object]$Candidate,
          [Parameter(Mandatory=$true)][object]$Resolution,
          [Parameter(Mandatory=$true)][string]$SelectedPlatform)
    if ($SelectedPlatform -cne 'All') { throw 'RuntimeCopyResolution.WholeCohortRequiresAllPlatforms' }
    if ($Resolution.decision -cne 'ARCHIVE_AND_RESOLVE') { throw 'RuntimeCopyResolution.InvalidDecision' }
    $id = [guid]::Empty
    if (-not [guid]::TryParse([string]$Resolution.invocation_id, [ref]$id) -or $id -eq [guid]::Empty) { throw 'RuntimeCopyResolution.InvalidInvocationId' }
    foreach ($name in @('target_root','source_fingerprint','base_preflight_plan_hash','gate3a_evidence_hash','target_set_digest')) {
        if ([string]$Resolution.$name -cne [string]$Candidate.$name) { throw "RuntimeCopyResolution.IdentityMismatch: $name" }
    }
    $expected = @($Candidate.targets | Sort-Object path)
    $actual = @($Resolution.entries | Sort-Object path)
    if ($actual.Count -ne 58) { throw 'RuntimeCopyResolution.IncompleteResolution' }
    for ($i=0; $i -lt 58; $i++) {
        if ($actual[$i].path -cne $expected[$i].path -or
            $actual[$i].expected_sha256 -cne $expected[$i].current_sha256 -or
            $actual[$i].provenance_classification -cne $expected[$i].provenance_classification -or
            $actual[$i].resolution_action -cne 'ARCHIVE_AND_RESOLVE') {
            throw "RuntimeCopyResolution.EntryMismatch: $i"
        }
    }
}

function Assert-RuntimeCopyTargetsCurrent {
    param([Parameter(Mandatory=$true)][object]$Candidate)
    foreach ($entry in $Candidate.targets) {
        $file = Join-Path $Candidate.target_root $entry.path
        Assert-DeploymentPathUnlinked -Path $file
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "RuntimeCopyResolution.TargetTypeDrift: $($entry.path)" }
        $hash = (Get-FileHash -LiteralPath $file -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        if ($hash -cne $entry.current_sha256) { throw "RuntimeCopyResolution.TargetHashDrift: $($entry.path)" }
    }
}

function Assert-RuntimeCopyArchive {
    param([Parameter(Mandatory=$true)][object]$Candidate,
          [Parameter(Mandatory=$true)][object]$Resolution,
          [Parameter(Mandatory=$true)][string]$ArchivePath)
    Assert-DeploymentPathUnlinked -Path $ArchivePath
    $manifestPath = Join-Path $ArchivePath 'archive-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { throw 'RuntimeCopyResolution.ArchiveManifestMissing' }
    $manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json
    if ($manifest.schema_version -ne 1 -or $manifest.invocation_id -cne $Resolution.invocation_id -or
        $manifest.target_root -cne $Candidate.target_root -or
        $manifest.source_fingerprint -cne $Candidate.source_fingerprint -or
        $manifest.base_preflight_plan_hash -cne $Candidate.base_preflight_plan_hash -or
        $manifest.target_set_digest -cne $Candidate.target_set_digest -or
        $manifest.gate3a_evidence_hash -cne $Candidate.gate3a_evidence_hash -or
        @($manifest.entries).Count -ne 58) { throw 'RuntimeCopyResolution.ArchiveIdentityMismatch' }
    foreach ($entry in $Candidate.targets) {
        $match = @($manifest.entries | Where-Object { $_.original_path -ceq $entry.path })
        if ($match.Count -ne 1 -or $match[0].original_sha256 -cne $entry.current_sha256 -or
            $match[0].provenance_classification -cne $entry.provenance_classification -or
            $match[0].size -ne $entry.size -or $match[0].archive_path -cne ('files/' + $entry.path)) {
            throw "RuntimeCopyResolution.ArchiveEntryMismatch: $($entry.path)"
        }
        $file = Join-Path $ArchivePath ('files/' + $entry.path)
        Assert-DeploymentPathUnlinked -Path $file
        if (-not (Test-Path -LiteralPath $file -PathType Leaf) -or
            (Get-FileHash -LiteralPath $file -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() -cne $entry.current_sha256) {
            throw "RuntimeCopyResolution.ArchiveFileMismatch: $($entry.path)"
        }
    }
    return $true
}

function New-RuntimeCopyArchive {
    param([Parameter(Mandatory=$true)][object]$Candidate,
          [Parameter(Mandatory=$true)][object]$Resolution,
          [Parameter(Mandatory=$true)][string]$RepoRoot,
          [string]$ArchiveRoot = (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.ai_rules/deployment-archives'),
          [int]$TestFailAfterCopies = 0)
    Assert-RuntimeCopyResolution -Candidate $Candidate -Resolution $Resolution -SelectedPlatform All
    Assert-RuntimeCopyTargetsCurrent -Candidate $Candidate
    $root = [IO.Path]::GetFullPath($ArchiveRoot).TrimEnd('\','/')
    $repo = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/')
    $target = [IO.Path]::GetFullPath($Candidate.target_root).TrimEnd('\','/')
    foreach ($excluded in @($repo,$target)) {
        if ($root.Equals($excluded,[StringComparison]::OrdinalIgnoreCase) -or
            $root.StartsWith($excluded + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase) -or
            $excluded.StartsWith($root + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) {
            throw 'RuntimeCopyResolution.ArchiveRootOverlapsSourceOrTarget'
        }
    }
    if ($root -match '(?i)[\\/](\.agents|\.claude|\.cursor|\.codex)[\\/]skills([\\/]|$)') { throw 'RuntimeCopyResolution.ArchiveInSkillLoader' }
    Assert-DeploymentPathUnlinked -Path $root
    $targetId = (Get-ResolutionSha256Text -Text $target).Substring(0,16)
    $archive = Join-Path (Join-Path $root $targetId) ([string]$Resolution.invocation_id)
    Assert-DeploymentPathUnlinked -Path $archive
    if (Test-Path -LiteralPath $archive) { throw 'RuntimeCopyResolution.ArchiveAlreadyExists' }
    $null = New-Item -ItemType Directory -Path (Split-Path $archive -Parent) -Force -ErrorAction Stop
    $null = New-Item -ItemType Directory -Path $archive -ErrorAction Stop
    $manifestEntries = @()
    $copied = 0
    foreach ($entry in $Candidate.targets) {
        $source = Join-Path $target $entry.path
        Assert-DeploymentPathUnlinked -Path $source
        $hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        if ($hash -cne $entry.current_sha256) { throw "RuntimeCopyResolution.TargetHashDrift: $($entry.path)" }
        $destination = Join-Path $archive ('files/' + $entry.path)
        $null = New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force -ErrorAction Stop
        $bytes = [IO.File]::ReadAllBytes($source)
        $stream = [IO.File]::Open($destination,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
        try { $stream.Write($bytes,0,$bytes.Length); $stream.Flush() } finally { $stream.Dispose() }
        $savedHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        if ($savedHash -cne $entry.current_sha256) { throw "RuntimeCopyResolution.ArchiveFileMismatch: $($entry.path)" }
        $manifestEntries += [pscustomobject]@{ original_path=$entry.path; archive_path=('files/' + $entry.path); original_sha256=$savedHash; size=$bytes.Length; provenance_classification=$entry.provenance_classification }
        $copied++
        if ($TestFailAfterCopies -gt 0 -and $copied -ge $TestFailAfterCopies) { throw 'RuntimeCopyResolution.TestPartialArchiveFailure' }
    }
    $manifest = [pscustomobject]@{
        schema_version=1; invocation_id=[string]$Resolution.invocation_id; target_root=$target
        source_fingerprint=$Candidate.source_fingerprint; base_preflight_plan_hash=$Candidate.base_preflight_plan_hash
        target_set_digest=$Candidate.target_set_digest; gate3a_evidence_hash=$Candidate.gate3a_evidence_hash
        created_at=(Get-Date).ToUniversalTime().ToString('o'); entries=$manifestEntries
    }
    $body = ConvertTo-Json -InputObject $manifest -Depth 12
    $bytes = [Text.Encoding]::UTF8.GetBytes($body)
    $path = Join-Path $archive 'archive-manifest.json'
    $stream = [IO.File]::Open($path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    try { $stream.Write($bytes,0,$bytes.Length); $stream.Flush() } finally { $stream.Dispose() }
    $null = Assert-RuntimeCopyArchive -Candidate $Candidate -Resolution $Resolution -ArchivePath $archive
    return $archive
}

function Remove-ResolvedRuntimeCopies {
    param([Parameter(Mandatory=$true)][object]$Candidate,
          [Parameter(Mandatory=$true)][object]$Resolution,
          [Parameter(Mandatory=$true)][string]$ArchivePath)
    Assert-RuntimeCopyResolution -Candidate $Candidate -Resolution $Resolution -SelectedPlatform All
    $null = Assert-RuntimeCopyArchive -Candidate $Candidate -Resolution $Resolution -ArchivePath $ArchivePath
    Assert-RuntimeCopyTargetsCurrent -Candidate $Candidate
    foreach ($entry in $Candidate.targets) {
        $file = Join-Path $Candidate.target_root $entry.path
        Assert-DeploymentPathUnlinked -Path $file
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "RuntimeCopyResolution.TargetTypeDrift: $($entry.path)" }
        $hash = (Get-FileHash -LiteralPath $file -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        if ($hash -cne $entry.current_sha256) { throw "RuntimeCopyResolution.TargetHashDrift: $($entry.path)" }
        Remove-Item -LiteralPath $file -Force -ErrorAction Stop
    }
}

Export-ModuleMember -Function Get-RuntimeCopySourceFingerprint, Get-RuntimeCopyBasePlanHash, Get-RuntimeCopyResolutionCandidate, Assert-RuntimeCopyResolution, Assert-RuntimeCopyTargetsCurrent, New-RuntimeCopyArchive, Assert-RuntimeCopyArchive, Remove-ResolvedRuntimeCopies
