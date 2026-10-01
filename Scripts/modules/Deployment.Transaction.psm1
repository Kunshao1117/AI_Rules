#Requires -Version 5.1
# Exception recovery for current project deployment consumers.
# Owner: Shared/policies/references/source-runtime-surface-map.md

function Get-DeploymentManagedPaths {
    param([string]$TargetRoot)
    # Never snapshot or restore Memory, context, project-skill sources, Cartridge,
    # logs, global profiles, or the rest of the user's project.
    foreach ($relative in @(
        '.agents/shared', '.agents/skills', '.agents/tools', '.agents/rules',
        '.agents/workflows', '.agents/VERSION', '.codex', '.claude', '.cursor', '.gitignore'
    )) {
        [IO.Path]::GetFullPath((Join-Path $TargetRoot $relative))
    }
}

function Assert-DeploymentPathUnlinked {
    param([string]$Path)
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force -ErrorAction Stop
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Deployment.LinkedPath: preserved linked managed path; no safe transaction available: $cursor"
            }
        }
        $cursor = Split-Path -Path $cursor -Parent
    }
}

function Get-DeploymentTreeItems {
    param([string]$Path, [switch]$Recovery, [switch]$AncestorChecked)
    if (-not $AncestorChecked) { Assert-DeploymentPathUnlinked -Path (Split-Path $Path -Parent) }
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        if (-not $Recovery) { Assert-DeploymentPathUnlinked -Path $Path }
        $item
        return
    }
    $item
    if ($item.PSIsContainer) {
        # Explicit traversal checks each child before descending into it.
        foreach ($child in @(Get-ChildItem -LiteralPath $Path -Force -ErrorAction Stop)) {
            Get-DeploymentTreeItems -Path $child.FullName -Recovery:$Recovery -AncestorChecked
        }
    }
}

function New-DeploymentSnapshot {
    param([string]$TargetRoot, [string[]]$ManagedPaths = @())
    $root = [IO.Path]::GetFullPath($TargetRoot)
    $files = @{}
    $directories = @{}
    $paths = if ($ManagedPaths.Count) { @($ManagedPaths) } else { @(Get-DeploymentManagedPaths -TargetRoot $root) }
    foreach ($path in $paths) {
        foreach ($item in @(Get-DeploymentTreeItems -Path $path)) {
            if ($item.PSIsContainer) {
                $directories[$item.FullName] = $true
            } else {
                $files[$item.FullName] = [PSCustomObject]@{
                    Bytes = [IO.File]::ReadAllBytes($item.FullName)
                    Attributes = $item.Attributes
                    LastWriteTimeUtc = $item.LastWriteTimeUtc
                }
            }
        }
    }
    [PSCustomObject]@{ Root = $root; Paths = $paths; Files = $files; Directories = $directories }
}

function Restore-DeploymentSnapshot {
    param([object]$Snapshot)
    # Enumerate and validate the entire current scope before any recovery write.
    $current = @($Snapshot.Paths | ForEach-Object { Get-DeploymentTreeItems -Path $_ -Recovery })
    foreach ($item in @($current | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint })) {
        if ($Snapshot.Files.ContainsKey($item.FullName) -or $Snapshot.Directories.ContainsKey($item.FullName)) {
            throw "Deployment.ConcurrentLink: existing managed path was replaced by a link: $($item.FullName)"
        }
        # Newly backfilled links have no pre-transaction state. Delete the link
        # itself only; never enumerate or remove its target.
        if ($item.PSIsContainer) { [IO.Directory]::Delete($item.FullName) }
        else { [IO.File]::Delete($item.FullName) }
    }
    $current = @($current | Where-Object { -not ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) })
    foreach ($item in @($current | Where-Object { -not $_.PSIsContainer })) {
        if (-not $Snapshot.Files.ContainsKey($item.FullName)) {
            Remove-Item -LiteralPath $item.FullName -Force -ErrorAction Stop
        }
    }
    foreach ($directory in @($Snapshot.Directories.Keys | Sort-Object Length)) {
        if (-not (Test-Path -LiteralPath $directory)) {
            $null = New-Item -ItemType Directory -Path $directory -Force -ErrorAction Stop
        }
    }
    foreach ($path in $Snapshot.Files.Keys) {
        $saved = $Snapshot.Files[$path]
        $same = (Test-Path -LiteralPath $path -PathType Leaf) -and
            ([Convert]::ToBase64String([IO.File]::ReadAllBytes($path)) -ceq [Convert]::ToBase64String($saved.Bytes))
        if (-not $same) {
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force -ErrorAction Stop
            if (Test-Path -LiteralPath $path) { [IO.File]::SetAttributes($path, [IO.FileAttributes]::Normal) }
            [IO.File]::WriteAllBytes($path, $saved.Bytes)
            [IO.File]::SetLastWriteTimeUtc($path, $saved.LastWriteTimeUtc)
            [IO.File]::SetAttributes($path, $saved.Attributes)
        }
    }
    foreach ($item in @($current | Where-Object { $_.PSIsContainer } | Sort-Object { $_.FullName.Length } -Descending)) {
        if (-not $Snapshot.Directories.ContainsKey($item.FullName) -and
            @(Get-ChildItem -LiteralPath $item.FullName -Force -ErrorAction Stop).Count -eq 0) {
            # Exact enumerated child path only; never recursive deletion.
            Remove-Item -LiteralPath $item.FullName -Force -ErrorAction Stop
        }
    }
}

function Invoke-DeploymentTransaction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$TargetRoot,
        [Parameter(Mandatory = $true)][scriptblock]$Action,
        [string]$RollbackPointPath = ''
    )
    $ErrorActionPreference = 'Stop'
    $managedPaths = @()
    if ($RollbackPointPath) {
        $point = Read-DeploymentRollbackPoint -Path $RollbackPointPath -TargetRoot $TargetRoot
        if ($point.phase -ne 'prepared') { throw 'Deployment.RecoveryUnexpectedPhase' }
        foreach ($entry in $point.entries) {
            $path = Resolve-DeploymentRecoveryPath -TargetRoot $TargetRoot -RelativePath $entry.relative_path
            if ((Get-DeploymentRecoveryHash $path) -cne $entry.original_sha256) { throw 'Deployment.RecoveryPreimageChanged' }
            $managedPaths += $path
        }
    }
    $snapshot = New-DeploymentSnapshot -TargetRoot $TargetRoot -ManagedPaths $managedPaths
    $failure = $null
    $output = @()
    try {
        $output = @(& $Action)
    } catch {
        $failure = $_
    }
    $failedResults = @($output | Where-Object {
        $null -ne $_ -and $null -ne $_.PSObject.Properties['Succeeded'] -and -not $_.Succeeded
    })
    if ($failure -or $failedResults.Count -gt 0) {
        try {
            Restore-DeploymentSnapshot -Snapshot $snapshot
        } catch {
            throw "Deployment.RollbackIncomplete: do not activate; recovery failed: $($_.Exception.Message); original failure: $failure"
        }
        Write-Warning '同步失敗；本批次所有平台的受管檔案與版本已回復，未完成切換。'
        foreach ($result in $failedResults) {
            $result | Add-Member -NotePropertyName RolledBack -NotePropertyValue $true -Force
        }
        if ($failure) { throw $failure }
    }
    $output
}

# Persistent recovery supplements the same transaction; it is not a deployer
# or an activation flag. Callers supply an exact, provenance-checked file plan.
function Resolve-DeploymentRecoveryPath {
    param([string]$TargetRoot, [string]$RelativePath)
    if ($RelativePath -match '\\|:|(^|/)\.{1,2}(/|$)' -or
        $RelativePath -notmatch '^(\.agents/(shared|skills|tools|rules|workflows|agents)/.+|\.agents/VERSION|\.(codex|claude|cursor)/.+|\.gitignore)$' -or
        $RelativePath -match '(^|/)(memory|context|project_skills|logs|projects)(/|$)' -or
        $RelativePath -match '(^|/)(settings\.local\.json|credentials[^/]*|auth\.json)$') {
        throw "Deployment.RecoveryUnsafePath: $RelativePath"
    }
    $root = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\', '/')
    $path = [IO.Path]::GetFullPath((Join-Path $root $RelativePath))
    if (-not $path.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Deployment.RecoveryOutsideTarget'
    }
    Assert-DeploymentPathUnlinked -Path $path
    return $path
}

function Get-DeploymentRecoveryHash {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Deployment.RecoveryNotFile: $Path" }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
}

function Write-DeploymentRecoveryManifest {
    param([string]$Path, [object]$Manifest)
    # Sibling temp file avoids a truncated point if serialization/write fails.
    $temp = $Path + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
    [IO.File]::WriteAllText($temp, ($Manifest | ConvertTo-Json -Depth 12), [Text.UTF8Encoding]::new($false))
    Move-Item -LiteralPath $temp -Destination $Path -Force -ErrorAction Stop
}

function New-DeploymentRollbackPoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$TargetRoot,
        [Parameter(Mandatory=$true)][string]$StoreRoot,
        [Parameter(Mandatory=$true)][object[]]$Entries,
        [Parameter(Mandatory=$true)][string]$SourceRevision,
        [Parameter(Mandatory=$true)][string]$Platform,
        [Parameter(Mandatory=$true)][string]$RuntimeInstance
    )
    $ErrorActionPreference = 'Stop'
    $root = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    $store = [IO.Path]::GetFullPath($StoreRoot).TrimEnd('\','/')
    Assert-DeploymentPathUnlinked -Path $root
    Assert-DeploymentPathUnlinked -Path $store
    if ($store -eq $root -or $store.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Deployment.RecoveryStoreInsideTarget'
    }
    if ($Entries.Count -eq 0) { throw 'Deployment.RecoveryEmptyPlan' }
    $seen = @{}; $records = @(); $bytes = @{}
    foreach ($entry in $Entries) {
        $rel = [string]$entry.RelativePath
        if ($seen.ContainsKey($rel)) { throw 'Deployment.RecoveryDuplicatePath' }
        $seen[$rel] = $true
        $path = Resolve-DeploymentRecoveryPath -TargetRoot $root -RelativePath $rel
        $original = Get-DeploymentRecoveryHash -Path $path
        $known = @($entry.KnownSha256 | ForEach-Object { ([string]$_).ToLowerInvariant() })
        if ($original -and $original -notin $known) {
            throw "Deployment.RecoveryUnconfirmedCopy: preserve and block: $rel"
        }
        $intended = [string]$entry.IntendedSha256
        if ($intended -and $intended -notmatch '^[a-fA-F0-9]{64}$') { throw 'Deployment.RecoveryInvalidHash' }
        $ordinal = $records.Count.ToString('D6')
        if ($original) { $bytes[$ordinal] = [IO.File]::ReadAllBytes($path) }
        $records += [pscustomobject]@{
            relative_path=$rel; backup_id=$ordinal; original_sha256=$original
            intended_sha256=$(if($intended){$intended.ToLowerInvariant()}else{$null})
            provenance=$(if($original){'known_framework_exact'}else{'absent_new_projection'})
            user_modified_classification='not-managed-if-unconfirmed'
            original_attributes=$(if($original){[int](Get-Item -LiteralPath $path -Force).Attributes}else{$null})
            original_last_write_utc=$(if($original){(Get-Item -LiteralPath $path -Force).LastWriteTimeUtc.ToString('o')}else{$null})
        }
    }
    $id = [guid]::NewGuid().ToString('N')
    $point = Join-Path $store $id
    $null = New-Item -ItemType Directory -Path (Join-Path $point 'files') -ErrorAction Stop
    foreach ($ordinal in $bytes.Keys) { [IO.File]::WriteAllBytes((Join-Path $point "files/$ordinal.bin"), $bytes[$ordinal]) }
    $manifest = [pscustomobject]@{
        schema_version=1; evidence_id=$id; target_root=$root; platform=$Platform
        runtime_instance=$RuntimeInstance; canonical_source_revision=$SourceRevision
        created_at_utc=(Get-Date).ToUniversalTime().ToString('o'); phase='prepared'
        evidence_only=$true; entries=$records
    }
    $manifestPath = Join-Path $point 'rollback.json'
    Write-DeploymentRecoveryManifest -Path $manifestPath -Manifest $manifest
    return $manifestPath
}

function Read-DeploymentRollbackPoint {
    param([string]$Path, [string]$TargetRoot)
    Assert-DeploymentPathUnlinked -Path $Path
    $m = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json
    $root = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    if ($m.schema_version -ne 1 -or $m.target_root -cne $root -or -not $m.evidence_only -or
        $m.phase -notin @('prepared','projected','restored') -or @($m.entries).Count -eq 0) {
        throw 'Deployment.RecoveryIdentityMismatch'
    }
    $seen = @{}; $i = 0
    foreach ($entry in $m.entries) {
        if ($seen.ContainsKey($entry.relative_path) -or $entry.backup_id -cne $i.ToString('D6')) { throw 'Deployment.RecoveryInvalidInventory' }
        $seen[$entry.relative_path] = $true; $i++
        $null = Resolve-DeploymentRecoveryPath -TargetRoot $root -RelativePath $entry.relative_path
        foreach ($hash in @($entry.original_sha256,$entry.intended_sha256)) {
            if ($hash -and $hash -notmatch '^[a-f0-9]{64}$') { throw 'Deployment.RecoveryInvalidHash' }
        }
        if ($entry.original_sha256) {
            $backup = Join-Path (Split-Path $Path -Parent) "files/$($entry.backup_id).bin"
            Assert-DeploymentPathUnlinked -Path $backup
            if ((Get-DeploymentRecoveryHash $backup) -cne $entry.original_sha256) { throw 'Deployment.RecoveryBackupCorrupt' }
        }
    }
    return $m
}

function Complete-DeploymentRollbackPoint {
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)][string]$TargetRoot)
    $m = Read-DeploymentRollbackPoint -Path $Path -TargetRoot $TargetRoot
    if ($m.phase -ne 'prepared') { throw 'Deployment.RecoveryUnexpectedPhase' }
    foreach ($entry in $m.entries) {
        $target = Resolve-DeploymentRecoveryPath -TargetRoot $TargetRoot -RelativePath $entry.relative_path
        if ((Get-DeploymentRecoveryHash $target) -cne $entry.intended_sha256) { throw "Deployment.RecoveryProjectionMismatch: $($entry.relative_path)" }
    }
    $m.phase = 'projected'
    Write-DeploymentRecoveryManifest -Path $Path -Manifest $m
}

function Restore-DeploymentRollbackPoint {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][string]$Path, [Parameter(Mandatory=$true)][string]$TargetRoot)
    $ErrorActionPreference = 'Stop'
    $m = Read-DeploymentRollbackPoint -Path $Path -TargetRoot $TargetRoot
    # Validate ALL entries before the first restore; unknown adjacent paths are
    # not enumerated or deleted. A later user edit blocks the whole recovery.
    foreach ($entry in $m.entries) {
        $target = Resolve-DeploymentRecoveryPath -TargetRoot $TargetRoot -RelativePath $entry.relative_path
        $current = Get-DeploymentRecoveryHash $target
        if ($current -cne $entry.original_sha256 -and $current -cne $entry.intended_sha256) {
            throw "Deployment.RecoveryLocalOverride: preserve and block: $($entry.relative_path)"
        }
    }
    foreach ($entry in $m.entries) {
        $target = Resolve-DeploymentRecoveryPath -TargetRoot $TargetRoot -RelativePath $entry.relative_path
        if ($entry.original_sha256) {
            $backup = Join-Path (Split-Path $Path -Parent) "files/$($entry.backup_id).bin"
            $null = New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force -ErrorAction Stop
            if (Test-Path -LiteralPath $target) { [IO.File]::SetAttributes($target, [IO.FileAttributes]::Normal) }
            [IO.File]::WriteAllBytes($target, [IO.File]::ReadAllBytes($backup))
            [IO.File]::SetLastWriteTimeUtc($target, [datetime]$entry.original_last_write_utc)
            [IO.File]::SetAttributes($target, [IO.FileAttributes][int]$entry.original_attributes)
        } elseif (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Force -ErrorAction Stop
        }
    }
    $m.phase = 'restored'
    Write-DeploymentRecoveryManifest -Path $Path -Manifest $m
    [pscustomobject]@{ EvidenceId=$m.evidence_id; Restored=$true; ManagedPathCount=@($m.entries).Count; ActivationGranted=$false }
}

Export-ModuleMember -Function Invoke-DeploymentTransaction, Assert-DeploymentPathUnlinked, Resolve-DeploymentRecoveryPath, New-DeploymentRollbackPoint, Complete-DeploymentRollbackPoint, Restore-DeploymentRollbackPoint
