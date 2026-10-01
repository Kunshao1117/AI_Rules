# Claude's native Agent templates are projections of the Shared Agent registry.
# The same source enumeration and target decision are used by preflight and Upgrade.
Import-Module (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1') -Force

function Get-ClaudeAgentSourceFiles {
    param([Parameter(Mandatory=$true)][string]$FrameworkRoot,
          [Parameter(Mandatory=$true)][string]$SharedRoot)

    $registryPath = Join-Path $SharedRoot 'agents/_registry.md'
    $sourceRoot = Join-Path $FrameworkRoot '.claude/agents'
    Assert-DeploymentPathUnlinked -Path $registryPath
    Assert-DeploymentPathUnlinked -Path $sourceRoot
    if (-not (Test-Path -LiteralPath $registryPath -PathType Leaf)) { throw "Missing canonical Agent registry: $registryPath" }
    if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) { throw "Missing Claude Agent source: $sourceRoot" }
    $registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 -ErrorAction Stop
    $matches = [regex]::Matches($registry, '(?m)^\|\s*([^|]+?)\s*\|\s*`([a-z0-9-]+\.md)`\s*\|\s*$')
    if ($matches.Count -eq 0) { throw "Canonical Agent registry has no roles: $registryPath" }
    $items = @()
    foreach ($match in $matches) {
        $canonicalName = $match.Groups[2].Value
        $canonicalPath = Join-Path (Join-Path $SharedRoot 'agents') $canonicalName
        Assert-DeploymentPathUnlinked -Path $canonicalPath
        if (-not (Test-Path -LiteralPath $canonicalPath -PathType Leaf)) { throw "Missing canonical Agent: $canonicalPath" }
        $stem = [IO.Path]::GetFileNameWithoutExtension($canonicalName)
        $templateName = "ai-rules-$stem.md"
        $sourcePath = Join-Path $sourceRoot $templateName
        Assert-DeploymentPathUnlinked -Path $sourcePath
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { throw "Missing Claude Agent projection: $sourcePath" }
        $sourceText = Get-Content -LiteralPath $sourcePath -Raw -Encoding UTF8 -ErrorAction Stop
        if ($sourceText -cnotmatch ('(?ms)\A---\s*\r?\n.*?^name:\s*["'']?' + [regex]::Escape("ai-rules-$stem") + '["'']?\s*$.*?^---\s*$')) {
            throw "Claude Agent frontmatter name does not match projection path: $sourcePath"
        }
        $items += [PSCustomObject]@{ Role = $match.Groups[1].Value.Trim(); CanonicalPath = $canonicalPath;
            SourcePath = $sourcePath; RelativePath = "agents/$templateName"; TargetRelativePath = ".claude/agents/$templateName" }
    }
    $expected = @($items | ForEach-Object { $_.RelativePath })
    if (@($expected | Select-Object -Unique).Count -ne $items.Count) { throw 'Canonical Agent registry maps multiple roles to one Claude source.' }
    $allSourceItems = @(Get-ChildItem -LiteralPath $sourceRoot -Recurse -Force -ErrorAction Stop)
    foreach ($item in $allSourceItems) { Assert-DeploymentPathUnlinked -Path $item.FullName }
    $actual = @($allSourceItems | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
        'agents/' + $_.FullName.Substring($sourceRoot.Length).TrimStart('\','/').Replace('\','/')
    })
    if (@($actual | Where-Object { $_ -cnotin $expected }).Count -gt 0) { throw 'Claude Agent source contains a non-canonical template.' }
    return $items
}

function Get-ClaudeAgentProjectionDecisions {
    param([Parameter(Mandatory=$true)][string]$FrameworkRoot,
          [Parameter(Mandatory=$true)][string]$SharedRoot,
          [Parameter(Mandatory=$true)][string]$TargetRoot)

    $sources = @(Get-ClaudeAgentSourceFiles -FrameworkRoot $FrameworkRoot -SharedRoot $SharedRoot)
    # An optional source-side archive may carry actual earlier framework bytes.
    # Runtime manifests are not ownership proof and never authorize replacement.
    $historyRoot = Join-Path $FrameworkRoot 'agent-history'
    $history = @()
    if (Test-Path -LiteralPath $historyRoot) {
        Assert-DeploymentPathUnlinked -Path $historyRoot
        if (-not (Test-Path -LiteralPath $historyRoot -PathType Container)) { throw "Invalid Claude Agent history root: $historyRoot" }
        $historyItems = @(Get-ChildItem -LiteralPath $historyRoot -Recurse -Force -ErrorAction Stop)
        foreach ($item in $historyItems) { Assert-DeploymentPathUnlinked -Path $item.FullName }
        foreach ($item in @($historyItems | Where-Object { -not $_.PSIsContainer -and $_.Extension -eq '.md' })) {
            $stem = [IO.Path]::GetFileNameWithoutExtension($item.Name)
            $body = Get-Content -LiteralPath $item.FullName -Raw -Encoding UTF8 -ErrorAction Stop
            if ($item.Name -cnotmatch '^ai-rules-[a-z0-9-]+\.md$' -or
                $body -cnotmatch ('(?ms)\A---\s*\r?\n.*?^name:\s*["'']?' + [regex]::Escape($stem) + '["'']?\s*$.*?^---\s*$')) {
                throw "Invalid historical Claude Agent artifact: $($item.FullName)"
            }
            $history += [PSCustomObject]@{ Name = $item.Name; Sha256 = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() }
        }
    }
    foreach ($source in $sources) {
        $targetPath = Join-Path $TargetRoot $source.TargetRelativePath
        $action = 'PRESERVE'; $reason = 'unconfirmed_existing_agent_copy'; $known = $false
        $sourceHash = (Get-FileHash -LiteralPath $source.SourcePath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
        $currentHash = $null
        try {
            Assert-DeploymentPathUnlinked -Path $targetPath
            $parent = Split-Path $targetPath -Parent
            $ancestorFile = $false
            while ($parent -and $parent.Length -ge ([IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')).Length) {
                if (Test-Path -LiteralPath $parent -PathType Leaf) { $ancestorFile = $true; break }
                $parent = Split-Path $parent -Parent
            }
            if ($ancestorFile) {
                $action = 'BLOCK'; $reason = 'agent_target_ancestor_is_file'
            } elseif (Test-Path -LiteralPath $targetPath -PathType Container) {
                $action = 'BLOCK'; $reason = 'agent_target_is_directory'
            } elseif (-not (Test-Path -LiteralPath $targetPath)) {
                $action = 'ADD'; $reason = 'canonical_claude_agent_projection'
            } else {
                $currentHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
                if ($currentHash -eq $sourceHash) {
                    $action = 'UNCHANGED'; $reason = 'canonical_claude_agent_exact_content_same'
                } elseif (@($history | Where-Object {
                    $_.Name -ceq [IO.Path]::GetFileName($source.SourcePath) -and $_.Sha256 -eq $currentHash
                }).Count -gt 0) {
                    $known = $true
                    if ((Get-Item -LiteralPath $targetPath -Force -ErrorAction Stop).IsReadOnly) {
                        $action = 'BLOCK'; $reason = 'known_agent_target_readonly'
                    } else {
                        $action = 'UPDATE'; $reason = 'exact_historical_claude_agent_source_artifact'
                    }
                }
            }
        } catch {
            $action = 'BLOCK'; $reason = "agent_path_or_read_conflict: $($_.Exception.Message)"
        }
        [PSCustomObject]@{
            Role = $source.Role; CanonicalPath = $source.CanonicalPath; SourcePath = $source.SourcePath
            RelativePath = $source.RelativePath; TargetRelativePath = $source.TargetRelativePath; TargetPath = $targetPath
            Action = $action; Reason = $reason; Blocking = ($action -in @('PRESERVE','BLOCK'))
            KnownFrameworkHashMatch = $known; SourceSha256 = $sourceHash; CurrentSha256 = $currentHash
        }
    }
}

function Get-ClaudeAgentUpgradeReport {
    param([Parameter(Mandatory=$true)][object[]]$Decisions)
    foreach ($decision in $Decisions) {
        $status = switch ($decision.Action) {
            'ADD' { 'NEW' } 'UPDATE' { 'CHANGED' } 'UNCHANGED' { 'SAME' }
            default { 'KEEP' }
        }
        [PSCustomObject]@{ Status = $status; Path = $decision.RelativePath }
    }
}

Export-ModuleMember -Function Get-ClaudeAgentSourceFiles, Get-ClaudeAgentProjectionDecisions, Get-ClaudeAgentUpgradeReport
