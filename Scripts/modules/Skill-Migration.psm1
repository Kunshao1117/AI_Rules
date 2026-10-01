# Exact compatibility aliases and retirement preflight. No orphan discovery.
Import-Module (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1') -Force -DisableNameChecking
$script:approvedCheckoutManifestText = $null
$script:approvedCheckoutHashes = @{}

function Get-LegacySkillMigrationArtifacts {
    param(
        [string]$SharedRoot = (Join-Path $PSScriptRoot '../../Shared'),
        [ValidateSet('4B2A1', '4B2A2', '4B2A3', '4B2A4', '4B2A7', 'M3')][string]$Batch
    )
    $path = Join-Path $SharedRoot 'policies/references/legacy-skill-migration.json'
    $manifestText = Get-Content -LiteralPath $path -Raw -Encoding UTF8 -ErrorAction Stop
    $manifest = $manifestText | ConvertFrom-Json
    if ($manifest.batch -ne '4B2A1') { throw 'Unexpected Skill migration manifest.' }
    # The original root batch and A1 records stay backward-compatible. New
    # records declare their batch; default enumeration is the combined mapping.
    $artifacts = @($manifest.artifacts | Where-Object {
        $artifactBatch = if ($_.PSObject.Properties['batch']) { $_.batch } else { '4B2A1' }
        -not $Batch -or $artifactBatch -eq $Batch
    })
    # Only precomputed representations of immutable, path-bound Git sources
    # are admitted. Never decode or normalize an unknown target file here.
    $approvals = @()
    if ($manifest.PSObject.Properties['approved_checkout_representations']) {
        $approvals = @($manifest.approved_checkout_representations)
    }
    # Cache only validation results for the exact manifest text, not mutable
    # returned artifacts. A byte/content change invalidates the cache even if
    # timestamps/length are unchanged; every caller gets freshly parsed records.
    if ($script:approvedCheckoutManifestText -cne $manifestText) {
        $validated = @{}
        foreach ($artifact in @($manifest.artifacts)) {
            $rows = @($approvals | Where-Object { $_.old_relative_path -ceq $artifact.old_relative_path })
            if ($rows.Count -gt 1) { throw 'Ambiguous approved Skill checkout representation.' }
            $hashes = @()
            foreach ($row in $rows) {
                $source = 'Shared/skills/' + $artifact.old_relative_path
                $identity = 'git ' + $row.revision + ':' + $source
                $proven = @($artifact.known_versions | Where-Object {
                    $_.PSObject.Properties['provenance'] -and
                    ($_.provenance -ceq $identity -or $_.provenance.StartsWith($identity + ';', [StringComparison]::Ordinal))
                })
                $names = @($row.representations.PSObject.Properties.Name | Sort-Object)
                if ($row.source -cne $source -or $row.revision -cnotmatch '^[0-9a-f]{40}$' -or
                    $row.git_blob_oid -cnotmatch '^[0-9a-f]{40}$' -or $proven.Count -eq 0 -or
                    $row.encoding -cne 'UTF-8' -or $row.bom -isnot [bool] -or
                    $row.terminal_newline -isnot [bool] -or ($names -join ',') -cne 'CRLF,git_blob,LF' -or
                    $row.git_blob_sha256 -cnotmatch '^[0-9a-f]{64}$' -or
                    $row.representations.git_blob -cne $row.git_blob_sha256 -or
                    $row.representations.LF -cne $row.git_blob_sha256) {
                    throw "Unproved approved Skill checkout representation: $source"
                }
                foreach ($name in $names) {
                    $digest = [string]$row.representations.$name
                    if ($digest -cnotmatch '^[0-9a-f]{64}$') { throw 'Invalid approved Skill checkout digest.' }
                    $hashes += $digest
                }
            }
            $validated[$artifact.old_relative_path] = @($hashes | Select-Object -Unique)
        }
        $script:approvedCheckoutHashes = $validated
        $script:approvedCheckoutManifestText = $manifestText
    }
    foreach ($artifact in $artifacts) {
        $hashes = @($script:approvedCheckoutHashes[$artifact.old_relative_path])
        $artifact.PSObject.Properties.Add([Management.Automation.PSNoteProperty]::new('ApprovedCheckoutSha256', $hashes))
    }
    return $artifacts
}

function Resolve-LegacySharedSkillReference {
    param(
        [Parameter(Mandatory = $true)][string]$Reference,
        [Parameter(Mandatory = $true)][string]$SharedRoot
    )
    $parts = $Reference.Replace('\', '/').Split('#', 2)
    $relative = $parts[0] -replace '^(Shared/skills/|\.(agents|claude|cursor)/skills/)', ''
    if ($relative -notmatch '/') { $relative += '/SKILL.md' }
    $match = @(Get-LegacySkillMigrationArtifacts -SharedRoot $SharedRoot | Where-Object {
        $_.old_relative_path -ceq $relative
    })
    if ($match.Count -eq 0) { return $null }
    if ($match.Count -ne 1) { throw "Ambiguous legacy Skill reference: $Reference" }
    $mapped = [string]$match[0].reference_relative_path
    if ($mapped -notmatch '^policies/references/legacy-skills/[^/]+/' -or
        $mapped -match '(^|/)\.{1,2}(/|$)|:|\\') { throw 'Unsafe legacy reference mapping.' }
    $path = Join-Path $SharedRoot $mapped
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing legacy reference: $path" }
    [PSCustomObject]@{
        OriginalReference = $Reference
        Path = [IO.Path]::GetFullPath($path)
        Anchor = $(if ($parts.Count -gt 1) { $parts[1] } else { '' })
        Kind = 'legacy-compatibility-reference'
    }
}

function Get-ManagedSkillRetirementDecision {
    param(
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [Parameter(Mandatory = $true)][string[]]$KnownSha256
    )
    Assert-DeploymentPathUnlinked -Path $TargetPath
    if (-not (Test-Path -LiteralPath $TargetPath)) {
        return [PSCustomObject]@{ Action = 'SKIP'; Reason = 'retired_entry_absent'; CurrentSha256 = $null; KnownFrameworkHashMatch = $false }
    }
    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) {
        return [PSCustomObject]@{ Action = 'BLOCK'; Reason = 'retired_entry_not_regular_file'; CurrentSha256 = $null; KnownFrameworkHashMatch = $false }
    }
    try { $hash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() }
    catch {
        return [PSCustomObject]@{ Action = 'BLOCK'; Reason = 'retired_entry_unreadable'; CurrentSha256 = $null; KnownFrameworkHashMatch = $false }
    }
    $known = @($KnownSha256 | ForEach-Object { ([string]$_).ToLowerInvariant() }) -contains $hash
    if ($known) {
        return [PSCustomObject]@{ Action = 'RETIRE'; Reason = 'exact_managed_path_and_known_hash'; CurrentSha256 = $hash; KnownFrameworkHashMatch = $true }
    }
    return [PSCustomObject]@{ Action = 'PRESERVE'; Reason = 'unconfirmed_retired_copy_blocks_migration'; CurrentSha256 = $hash; KnownFrameworkHashMatch = $false }
}

function Test-LegacySkillMigrationBlockingPath {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    if ($RelativePath -notmatch '^[a-z0-9-]+/SKILL\.md$') { return $false }
    return @((Get-LegacySkillMigrationArtifacts) | Where-Object { $_.old_relative_path -ceq $RelativePath }).Count -eq 1
}

function Assert-LegacySkillMigrationReady {
    param([Parameter(Mandatory = $true)][string]$TargetSkillsPath)
    foreach ($artifact in @(Get-LegacySkillMigrationArtifacts)) {
        # Only an old entry can leave an active Skill. Unknown adjacent assets
        # are preserved/reportable through the existing retirement mechanism.
        $relative = [string]$artifact.old_relative_path
        if (-not (Test-LegacySkillMigrationBlockingPath -RelativePath $relative)) { continue }
        $path = Join-Path $TargetSkillsPath $relative
        $decision = Get-ManagedSkillRetirementDecision -TargetPath $path -KnownSha256 @(@($artifact.known_versions.sha256) + @($artifact.ApprovedCheckoutSha256))
        if ($decision.Action -eq 'PRESERVE') {
            throw "preserved_user_modified_retired_skill: $relative; migration blocked before Skill writes."
        }
        if ($decision.Action -eq 'BLOCK') { throw "preserved_unconfirmed_retired_skill: $relative; migration blocked before Skill writes." }
    }
}

Export-ModuleMember -Function Get-LegacySkillMigrationArtifacts, Resolve-LegacySharedSkillReference, Get-ManagedSkillRetirementDecision, Test-LegacySkillMigrationBlockingPath, Assert-LegacySkillMigrationReady
