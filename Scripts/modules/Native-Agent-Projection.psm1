# Native Cursor/Antigravity Agent projection.

function Assert-NativeProjectionHash {
    param([string]$SourcePath, [string]$TargetPath)
    $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    if ($sourceHash -ne $targetHash) { throw "Native projection copy hash mismatch: $TargetPath" }
}

function Get-NativeAgentProjectionDecisions {
    param(
        [Parameter(Mandatory = $true)][ValidateSet('Cursor','Antigravity')][string]$Platform,
        [Parameter(Mandatory = $true)][string]$SourceAgentsRoot,
        [Parameter(Mandatory = $true)][string]$CanonicalAgentsRoot,
        [Parameter(Mandatory = $true)][string]$TargetAgentsRoot
    )
    $registryPath = Join-Path $CanonicalAgentsRoot '_registry.md'
    if (-not (Test-Path -LiteralPath $registryPath -PathType Leaf) -or
        -not (Test-Path -LiteralPath $SourceAgentsRoot -PathType Container)) {
        throw 'Native Agent source or canonical registry is missing.'
    }
    $registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8
    $ids = @([regex]::Matches($registry, '(?m)^\| (?!Role )[^|]+ \| `([^`]+)\.md` \|\r?$') |
        ForEach-Object { $_.Groups[1].Value } | Sort-Object)
    if ($ids.Count -ne 6) { throw 'Native Agent projection requires the current six canonical roles.' }
    $prefix = if ($Platform -eq 'Cursor') { 'ai-rules-' } else { '' }
    $expected = @($ids | ForEach-Object { "$prefix$_.md" } | Sort-Object)
    $actual = @(Get-ChildItem -LiteralPath $SourceAgentsRoot -File -Filter '*.md' |
        ForEach-Object { $_.Name } | Sort-Object)
    if (($expected -join '|') -cne ($actual -join '|')) {
        throw "${Platform} native Agent source does not match the canonical role registry."
    }

    $decisions = @()
    foreach ($id in $ids) {
        $name = "$prefix$id"
        $source = Join-Path $SourceAgentsRoot "$name.md"
        $body = Get-Content -LiteralPath $source -Raw -Encoding UTF8
        if ($body -notmatch "(?m)^name: $([regex]::Escape($name))\r?$" -or
            -not $body.Contains(".agents/shared/agents/$id.md")) {
            throw "${Platform} native Agent identity or Shared pointer mismatch: $id"
        }
        $target = Join-Path $TargetAgentsRoot "$name.md"
        $action = 'ADD'
        if (Test-Path -LiteralPath $target -PathType Container) {
            $action = 'BLOCK'
        } elseif (Test-Path -LiteralPath $target -PathType Leaf) {
            $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
            $action = if ($sourceHash -eq $targetHash) { 'UNCHANGED' } else { 'BLOCK' }
        }
        $decisions += [PSCustomObject]@{
            Id = $id
            SourcePath = $source
            TargetPath = $target
            Action = $action
            Reason = if ($action -eq 'BLOCK') { 'existing_native_agent_copy_not_proven_framework_owned' } else { 'canonical_agent_native_projection' }
        }
    }
    return $decisions
}

function Sync-NativeAgentProjection {
    param(
        [Parameter(Mandatory = $true)][ValidateSet('Cursor','Antigravity')][string]$Platform,
        [Parameter(Mandatory = $true)][string]$SourceAgentsRoot,
        [Parameter(Mandatory = $true)][string]$CanonicalAgentsRoot,
        [Parameter(Mandatory = $true)][string]$TargetAgentsRoot
    )
    $decisions = @(Get-NativeAgentProjectionDecisions -Platform $Platform `
        -SourceAgentsRoot $SourceAgentsRoot -CanonicalAgentsRoot $CanonicalAgentsRoot `
        -TargetAgentsRoot $TargetAgentsRoot)
    if (@($decisions | Where-Object Action -eq 'BLOCK').Count -gt 0) {
        throw "${Platform} native Agent projection stopped at an existing unconfirmed target copy."
    }
    foreach ($decision in $decisions | Where-Object Action -eq 'ADD') {
        New-Item -ItemType Directory -Path $TargetAgentsRoot -Force | Out-Null
        Copy-Item -LiteralPath $decision.SourcePath -Destination $decision.TargetPath -ErrorAction Stop
        Assert-NativeProjectionHash -SourcePath $decision.SourcePath -TargetPath $decision.TargetPath
    }
    return $decisions
}

Export-ModuleMember -Function Get-NativeAgentProjectionDecisions, Sync-NativeAgentProjection
