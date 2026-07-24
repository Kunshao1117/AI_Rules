Set-StrictMode -Version Latest

function ConvertTo-NormalizedRelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$FullPath,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $relativePath = $FullPath.Substring($RootPath.Length) -replace '^[\\/]+', ''
    return $relativePath -replace '\\', '/'
}

function Test-SourceBearingFile {
    param([Parameter(Mandatory = $true)][System.IO.FileInfo]$File)

    $extensions = @(
        '.cjs', '.css', '.html', '.js', '.json', '.jsonc', '.jsx', '.markdown',
        '.md', '.mjs', '.ps1', '.psd1', '.psm1', '.scss', '.toml', '.ts', '.tsx',
        '.xml', '.yaml', '.yml'
    )
    return $extensions -contains $File.Extension.ToLowerInvariant()
}

function Get-InventoryCategory {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    if ($RelativePath -match '(^|/)SKILL\.md$') {
        return 'skill'
    }
    if ($RelativePath -match '^Shared/policies/references/' -or $RelativePath -match '/references/') {
        return 'shared-reference'
    }
    if ($RelativePath -match '^Shared/(policies/|.+\.md$)') {
        return 'shared-policy'
    }
    if ($RelativePath -match '^(Antigravity/\.agents/rules/AGENTS\.md|Claude/\.claude/CLAUDE\.md|Codex/\.codex/AGENTS\.md)$') {
        return 'platform-core'
    }
    if ($RelativePath -match '^Scripts/modules/.+\.psm1$') {
        return 'powershell-module'
    }

    # The policy explicitly puts every hand-maintained non-module .ps1 here.
    return 'general-source'
}

function New-SizeBudget {
    param(
        [Nullable[int]]$ResponsibilityReviewLines,
        [Nullable[int]]$SplitPlanLines,
        [Nullable[int]]$NoNewFeatureLines,
        [Nullable[int]]$TokenEstimate
    )

    return [ordered]@{
        responsibilityReviewLines = $ResponsibilityReviewLines
        splitPlanLines            = $SplitPlanLines
        noNewFeatureLines         = $NoNewFeatureLines
        tokenEstimate             = $TokenEstimate
    }
}

function Get-SizeBudget {
    param([Parameter(Mandatory = $true)][string]$Category)

    switch ($Category) {
        'platform-core' { return New-SizeBudget -ResponsibilityReviewLines 250 -SplitPlanLines 500 -NoNewFeatureLines 800 }
        'shared-policy' { return New-SizeBudget -ResponsibilityReviewLines 350 -SplitPlanLines 600 -NoNewFeatureLines 900 }
        'shared-reference' { return New-SizeBudget -ResponsibilityReviewLines 500 -SplitPlanLines 900 -NoNewFeatureLines 1200 }
        'powershell-module' { return New-SizeBudget -ResponsibilityReviewLines 800 -SplitPlanLines 1500 -NoNewFeatureLines 2500 }
        'skill' { return New-SizeBudget -ResponsibilityReviewLines 500 -TokenEstimate 5000 }
        default { return New-SizeBudget -ResponsibilityReviewLines 401 -SplitPlanLines 601 -NoNewFeatureLines 801 }
    }
}

function Get-ThresholdReasons {
    param(
        [Parameter(Mandatory = $true)][int]$LineCount,
        [Parameter(Mandatory = $true)][int]$TokenEstimate,
        [Parameter(Mandatory = $true)][System.Collections.IDictionary]$Budget
    )

    $reasons = New-Object System.Collections.Generic.List[string]
    if ($null -ne $Budget.responsibilityReviewLines -and $LineCount -ge $Budget.responsibilityReviewLines) {
        $reasons.Add("line-count>=$($Budget.responsibilityReviewLines)")
    }
    if ($null -ne $Budget.tokenEstimate -and $TokenEstimate -ge $Budget.tokenEstimate) {
        $reasons.Add("token-estimate>=$($Budget.tokenEstimate)")
    }
    return $reasons.ToArray()
}

function Get-GitBaselineContext {
    param([Parameter(Mandatory = $true)][string]$RootPath)

    $commit = ((& git -C $RootPath rev-parse --verify HEAD 2>$null) -join '').Trim()
    if ($LASTEXITCODE -ne 0 -or -not $commit) {
        return $null
    }
    return [pscustomobject]@{ commit = $commit; rootPath = $RootPath }
}

function Get-GitBaselineLines {
    param(
        [Parameter(Mandatory = $true)][object]$BaselineContext,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $lines = @(& git -C $BaselineContext.rootPath show "$($BaselineContext.commit):$RelativePath" 2>$null)
    if ($LASTEXITCODE -ne 0) {
        return $null
    }
    return [string[]]$lines
}

function Get-GitDiffStat {
    param(
        [Parameter(Mandatory = $true)][object]$BaselineContext,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $lines = @(& git -C $BaselineContext.rootPath diff --numstat $BaselineContext.commit -- $RelativePath 2>$null)
    if ($LASTEXITCODE -ne 0) {
        throw "git diff --numstat failed for $RelativePath"
    }

    $line = if ($lines.Count -gt 0) { [string]$lines[0] } else { $null }
    if ([string]::IsNullOrWhiteSpace($line)) {
        return [pscustomobject]@{ additions = 0; deletions = 0 }
    }

    $match = [regex]::Match($line, '^(\d+)\s+(\d+)\s+')
    if (-not $match.Success) {
        throw "Unexpected git diff --numstat output for ${RelativePath}: $line"
    }
    return [pscustomobject]@{ additions = [int]$match.Groups[1].Value; deletions = [int]$match.Groups[2].Value }
}

function Get-PathReference {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    if ($fullPath.StartsWith($RootPath + [System.IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        return ConvertTo-NormalizedRelativePath -FullPath $fullPath -RootPath $RootPath
    }
    return $fullPath
}

function ConvertTo-ReadIndexAnchor {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    return 'candidate-' + (($RelativePath.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-'))
}

function New-ReadIndexEntry {
    param(
        [Parameter(Mandatory = $true)][string]$Kind,
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][int]$StartLine,
        [Parameter(Mandatory = $true)][int]$EndLine
    )

    return [pscustomobject][ordered]@{
        kind = $Kind; label = $Label; startLine = $StartLine; endLine = $EndLine
    }
}

function Get-ReadIndexEntries {
    param([Parameter(Mandatory = $true)][System.IO.FileInfo]$File)

    $lines = [System.IO.File]::ReadAllLines($File.FullName)
    $starts = New-Object System.Collections.Generic.List[object]
    $isMarkdown = $File.Extension.ToLowerInvariant() -in @('.md', '.markdown')
    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        if ($isMarkdown) {
            $heading = [regex]::Match($line, '^(#{1,2})\s+(.+?)\s*$')
            if ($heading.Success) {
                $starts.Add([pscustomobject]@{ kind = "heading-$($heading.Groups[1].Value.Length)"; label = $heading.Groups[2].Value.Trim(); startLine = $index + 1 })
            }
            continue
        }
        if ($line -match '^\s*param\(') {
            $starts.Add([pscustomobject]@{ kind = 'parameter-block'; label = 'Script parameter block'; startLine = $index + 1 })
            continue
        }
        $function = [regex]::Match($line, '^\s*function\s+([A-Za-z0-9_-]+)')
        if ($function.Success) {
            $starts.Add([pscustomobject]@{ kind = 'function'; label = $function.Groups[1].Value; startLine = $index + 1 })
        }
    }
    if ($starts.Count -eq 0) {
        return @(New-ReadIndexEntry -Kind 'whole-file' -Label 'No structural entry was detected; read the complete file.' -StartLine 1 -EndLine $lines.Count)
    }

    $entries = New-Object System.Collections.Generic.List[object]
    for ($index = 0; $index -lt $starts.Count; $index++) {
        $endLine = if (($index + 1) -lt $starts.Count) { $starts[$index + 1].startLine - 1 } else { $lines.Count }
        $entries.Add((New-ReadIndexEntry -Kind $starts[$index].kind -Label $starts[$index].label -StartLine $starts[$index].startLine -EndLine $endLine))
    }
    return $entries.ToArray()
}

function Compress-ReadIndexEntries {
    param([Parameter(Mandatory = $true)][object[]]$Entries)
    if ($Entries.Count -le 8) { return $Entries }

    $compressed = New-Object System.Collections.Generic.List[object]
    $chunkSize = [int][Math]::Ceiling($Entries.Count / 8.0)
    for ($offset = 0; $offset -lt $Entries.Count; $offset += $chunkSize) {
        $endOffset = [Math]::Min($offset + $chunkSize - 1, $Entries.Count - 1)
        $first = $Entries[$offset]; $last = $Entries[$endOffset]
        $compressed.Add((New-ReadIndexEntry -Kind ($first.kind + '-range') -Label ('{0} entries: {1} through {2}' -f $first.kind, $first.label, $last.label) -StartLine $first.startLine -EndLine $last.endLine))
    }
    return $compressed.ToArray()
}

function Get-ReadIndex {
    param(
        [Parameter(Mandatory = $true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$IndexPathReference
    )

    $entries = @(Get-ReadIndexEntries -File $File)
    $importantEntries = @()
    if ($entries.Count -gt 1) {
        $importantEntries = @(Compress-ReadIndexEntries -Entries @($entries | Select-Object -Skip 1))
    }
    return [ordered]@{
        path = $IndexPathReference; anchor = ConvertTo-ReadIndexAnchor -RelativePath $RelativePath
        responsibilityState = 'semantic-review-required'; entryCount = $entries.Count
        primaryEntry = $entries[0]; importantSections = @($importantEntries)
    }
}

function Write-ReadingIndex {
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Candidates,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $lines = New-Object System.Collections.Generic.List[string]
    @('# Oversize Reading Index', '', 'Read the listed entry first, then only the named line range. Section labels are extracted from the canonical source; responsibility count and split decisions remain semantic-review-required.', '') | ForEach-Object { $lines.Add($_) }
    foreach ($candidate in ($Candidates | Sort-Object path)) {
        $readIndex = $candidate.read_index; $primaryEntry = $readIndex.primaryEntry
        $lines.Add(('<a id="{0}"></a>' -f $readIndex.anchor)); $lines.Add(('## `{0}`' -f $candidate.path)); $lines.Add('')
        $lines.Add(('- Type: `{0}`; responsibility classification: `{1}`.' -f $candidate.type, $readIndex.responsibilityState))
        $baselineStatus = $candidate.PSObject.Properties['baseline_status']
        if ($baselineStatus -and $baselineStatus.Value) {
            $lines.Add(('- Baseline: `{0}` lines from `{1}`; current: `{2}` lines.' -f $candidate.baseline_line_count, $candidate.split_evidence.baseline_source, $candidate.current_line_count))
            $lines.Add(('- Tracking status: baseline `{0}`; resolution `{1}`.' -f $candidate.baseline_status, $candidate.resolved_status))
            $lines.Add(('- Split evidence: `{0}` (additions: {1}, deletions: {2}).' -f $candidate.split_evidence.comparison_command, $candidate.split_evidence.diff_stat.additions, $candidate.split_evidence.diff_stat.deletions))
        }
        $lines.Add(('- Primary entry: lines {0}-{1}, `{2}` — {3}.' -f $primaryEntry.startLine, $primaryEntry.endLine, $primaryEntry.kind, $primaryEntry.label))
        if ($readIndex.importantSections.Count -gt 0) {
            $lines.Add('- Important sections:')
            foreach ($section in $readIndex.importantSections) { $lines.Add(('  - Lines {0}-{1}, `{2}` — {3}.' -f $section.startLine, $section.endLine, $section.kind, $section.label)) }
        }
        $lines.Add('')
    }
    $directory = Split-Path -Parent $Path
    if ($directory -and -not (Test-Path -LiteralPath $directory -PathType Container)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    [System.IO.File]::WriteAllText($Path, (($lines -join [Environment]::NewLine) + [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
}

function Get-SourceDeployedPair {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $deployedPath = $null
    if ($RelativePath.StartsWith('Shared/skills/', [StringComparison]::OrdinalIgnoreCase)) { $deployedPath = '.agents/skills/' + $RelativePath.Substring('Shared/skills/'.Length) }
    elseif ($RelativePath.StartsWith('Shared/', [StringComparison]::OrdinalIgnoreCase)) { $deployedPath = '.agents/shared/' + $RelativePath.Substring('Shared/'.Length) }
    elseif ($RelativePath.StartsWith('Codex/.codex/', [StringComparison]::OrdinalIgnoreCase)) { $deployedPath = '.codex/' + $RelativePath.Substring('Codex/.codex/'.Length) }
    elseif ($RelativePath.StartsWith('Claude/.claude/', [StringComparison]::OrdinalIgnoreCase)) { $deployedPath = '.claude/' + $RelativePath.Substring('Claude/.claude/'.Length) }
    elseif ($RelativePath.StartsWith('Antigravity/.agents/rules/', [StringComparison]::OrdinalIgnoreCase)) { $deployedPath = '.agents/rules/' + $RelativePath.Substring('Antigravity/.agents/rules/'.Length) }
    if (-not $deployedPath) { return [ordered]@{ sourcePath = $RelativePath; deployedPath = $null; state = 'not-applicable' } }
    $deployedFullPath = Join-Path $RootPath ($deployedPath -replace '/', '\')
    return [ordered]@{ sourcePath = $RelativePath; deployedPath = $deployedPath; state = if (Test-Path -LiteralPath $deployedFullPath -PathType Leaf) { 'runtime-present' } else { 'runtime-missing' } }
}

function Get-SizeDisposition {
    param(
        [Parameter(Mandatory = $true)][System.Collections.IDictionary]$Budget,
        [Parameter(Mandatory = $true)][int]$LineCount,
        [Parameter(Mandatory = $true)][int]$TokenEstimate
    )

    if ($null -ne $Budget.noNewFeatureLines -and $LineCount -ge $Budget.noNewFeatureLines) { return 'no-new-feature-or-responsibility' }
    if ($null -ne $Budget.splitPlanLines -and $LineCount -ge $Budget.splitPlanLines) { return 'split-plan-decision-required' }
    if ($null -ne $Budget.tokenEstimate -and $TokenEstimate -ge $Budget.tokenEstimate) { return 'skill-limit-reached' }
    return 'size-impact-report-required'
}

function New-InventoryCandidate {
    param(
        [Parameter(Mandatory = $true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$Category,
        [Parameter(Mandatory = $true)][System.Collections.IDictionary]$Budget,
        [Parameter(Mandatory = $true)][string]$IndexPathReference,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $content = [System.IO.File]::ReadAllText($File.FullName)
    $lineCount = [System.IO.File]::ReadAllLines($File.FullName).Count
    $tokenEstimate = [int][Math]::Ceiling($content.Length / 4.0)
    return [pscustomobject][ordered]@{
        path = $RelativePath; type = $Category; lineCount = $lineCount; current_line_count = $lineCount
        characterCount = $content.Length; tokenEstimate = $tokenEstimate; threshold = $Budget
        thresholdReasons = @(Get-ThresholdReasons -LineCount $lineCount -TokenEstimate $tokenEstimate -Budget $Budget)
        responsibilityClassification = [ordered]@{ state = 'semantic-review-required'; automaticSplit = $false; policy = 'Shared/policies/source-document-size-governance.md#Source Responsibility Contract' }
        sourceDeployedPair = Get-SourceDeployedPair -RelativePath $RelativePath -RootPath $RootPath
        sizeDisposition = Get-SizeDisposition -Budget $Budget -LineCount $lineCount -TokenEstimate $tokenEstimate
        splitStatus = 'semantic-responsibility-review-required'
        read_index = Get-ReadIndex -File $File -RelativePath $RelativePath -IndexPathReference $IndexPathReference
    }
}

function Invoke-SourceSizeAudit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [string]$OutputPath,
        [string]$ReadingIndexPath,
        [string[]]$KnownBaselineTarget = @(
            'Scripts/AI-RulesManager.ps1', 'Scripts/modules/Core.psm1',
            'Shared/policies/team-trace-evidence.md',
            'Shared/skills/team-task-board/references/board-field-catalog.md'
        ),
        [switch]$PassThru
    )

    $resolvedRepoRoot = (Resolve-Path -LiteralPath $RepoRoot -ErrorAction Stop).Path.TrimEnd([char[]]@('\', '/'))
    if (-not $OutputPath) { $OutputPath = Join-Path $resolvedRepoRoot 'artifacts\team-native-v2\oversize-inventory.json' }
    if (-not [System.IO.Path]::IsPathRooted($OutputPath)) { $OutputPath = Join-Path $resolvedRepoRoot $OutputPath }
    $OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
    if (-not $ReadingIndexPath) { $ReadingIndexPath = Join-Path (Split-Path -Parent $OutputPath) 'oversize-reading-index.md' }
    if (-not [System.IO.Path]::IsPathRooted($ReadingIndexPath)) { $ReadingIndexPath = Join-Path $resolvedRepoRoot $ReadingIndexPath }
    $ReadingIndexPath = [System.IO.Path]::GetFullPath($ReadingIndexPath)
    $readingIndexReference = Get-PathReference -Path $ReadingIndexPath -RootPath $resolvedRepoRoot

    $canonicalRoots = @('Antigravity', 'Claude', 'Codex', 'Extensions', 'Scripts', 'Shared')
    $sourceFiles = @(
        foreach ($canonicalRoot in $canonicalRoots) {
            $canonicalPath = Join-Path $resolvedRepoRoot $canonicalRoot
            if (Test-Path -LiteralPath $canonicalPath -PathType Container) {
                Get-ChildItem -LiteralPath $canonicalPath -File -Recurse -Force | Where-Object { (Test-SourceBearingFile -File $_) -and $_.FullName -notmatch '[\\/](node_modules|out|dist|coverage)[\\/]' }
            }
        }
    )

    $candidateFiles = New-Object System.Collections.Generic.List[object]
    $currentFilesByPath = @{}
    $categoryCounts = [ordered]@{}
    foreach ($file in ($sourceFiles | Sort-Object FullName)) {
        $relativePath = ConvertTo-NormalizedRelativePath -FullPath $file.FullName -RootPath $resolvedRepoRoot
        $currentFilesByPath[$relativePath] = $file
        $category = Get-InventoryCategory -RelativePath $relativePath
        if (-not $categoryCounts.Contains($category)) { $categoryCounts[$category] = 0 }
        $categoryCounts[$category]++
        $budget = Get-SizeBudget -Category $category
        $candidate = New-InventoryCandidate -File $file -RelativePath $relativePath -Category $category -Budget $budget -IndexPathReference $readingIndexReference -RootPath $resolvedRepoRoot
        if (@($candidate.thresholdReasons).Count -gt 0) { $candidateFiles.Add($candidate) }
    }

    $baselineContext = Get-GitBaselineContext -RootPath $resolvedRepoRoot
    $baselineCandidateFiles = New-Object System.Collections.Generic.List[object]
    if ($baselineContext) {
        $trackingPaths = @((@($candidateFiles | ForEach-Object { $_.path }) + @($KnownBaselineTarget)) | Sort-Object -Unique)
        foreach ($relativePath in $trackingPaths) {
            $category = Get-InventoryCategory -RelativePath $relativePath; $budget = Get-SizeBudget -Category $category
            $baselineLines = Get-GitBaselineLines -BaselineContext $baselineContext -RelativePath $relativePath
            if ($null -eq $baselineLines) { continue }
            $baselineCharacterCount = ($baselineLines -join [Environment]::NewLine).Length
            $baselineTokenEstimate = [int][Math]::Ceiling($baselineCharacterCount / 4.0)
            $baselineReasons = @(Get-ThresholdReasons -LineCount $baselineLines.Count -TokenEstimate $baselineTokenEstimate -Budget $budget)
            if ($baselineReasons.Count -eq 0) { continue }
            $currentFile = $currentFilesByPath[$relativePath]
            $currentLineCount = if ($currentFile) { [System.IO.File]::ReadAllLines($currentFile.FullName).Count } else { $null }
            $currentCharacterCount = if ($currentFile) { [System.IO.File]::ReadAllText($currentFile.FullName).Length } else { $null }
            $currentTokenEstimate = if ($null -ne $currentCharacterCount) { [int][Math]::Ceiling($currentCharacterCount / 4.0) } else { $null }
            $currentReasons = @()
            if ($currentFile) {
                $currentReasons = @(Get-ThresholdReasons -LineCount $currentLineCount -TokenEstimate $currentTokenEstimate -Budget $budget)
            }
            $resolvedStatus = if ($null -eq $currentFile) { 'current-source-missing' } elseif ($currentReasons.Count -gt 0) { 'current-over-budget' } else { 'resolved-split' }
            $readIndex = if ($currentFile) { Get-ReadIndex -File $currentFile -RelativePath $relativePath -IndexPathReference $readingIndexReference } else { $null }
            $baselineCandidateFiles.Add([pscustomobject][ordered]@{
                path = $relativePath; type = $category; threshold = $budget; baseline_line_count = $baselineLines.Count
                baseline_character_count = $baselineCharacterCount; baseline_token_estimate = $baselineTokenEstimate; baseline_threshold_reasons = $baselineReasons
                current_line_count = $currentLineCount; current_character_count = $currentCharacterCount; current_token_estimate = $currentTokenEstimate; current_threshold_reasons = $currentReasons
                baseline_status = 'baseline_over_budget'; resolved_status = $resolvedStatus
                responsibilityClassification = [ordered]@{ state = 'semantic-review-required'; automaticSplit = $false; policy = 'Shared/policies/source-document-size-governance.md#Source Responsibility Contract' }
                sourceDeployedPair = Get-SourceDeployedPair -RelativePath $relativePath -RootPath $resolvedRepoRoot
                split_evidence = [ordered]@{ baseline_source = "git:$($baselineContext.commit):$relativePath"; current_source = $relativePath; comparison_command = "git diff --numstat $($baselineContext.commit) -- $relativePath"; diff_stat = Get-GitDiffStat -BaselineContext $baselineContext -RelativePath $relativePath }
                read_index = $readIndex
            })
        }
    }

    $baselinePaths = @($baselineCandidateFiles | ForEach-Object { $_.path })
    $untrackedKnownTargets = @($KnownBaselineTarget | Where-Object { $_ -notin $baselinePaths })
    $knownTargetTracking = @(
        foreach ($relativePath in $KnownBaselineTarget) {
            $baselineCandidate = $baselineCandidateFiles | Where-Object { $_.path -eq $relativePath } | Select-Object -First 1
            [pscustomobject][ordered]@{ path = $relativePath; tracked = ($null -ne $baselineCandidate); resolved_status = if ($baselineCandidate) { $baselineCandidate.resolved_status } else { 'untracked' }; baseline_source = if ($baselineCandidate) { $baselineCandidate.split_evidence.baseline_source } else { $null } }
        }
    )
    $indexCandidates = New-Object System.Collections.Generic.List[object]
    foreach ($candidate in $baselineCandidateFiles) { $indexCandidates.Add($candidate) }
    foreach ($candidate in $candidateFiles) { if ($candidate.path -notin $baselinePaths) { $indexCandidates.Add($candidate) } }

    $inventory = [pscustomobject][ordered]@{
        schemaVersion = '1.3'; scanMode = 'canonical-source-read-only'; policyReference = 'Shared/policies/source-document-size-governance.md'; canonicalRoots = $canonicalRoots
        baselineSource = if ($baselineContext) { "git:$($baselineContext.commit)" } else { 'unavailable' }
        readingIndex = [ordered]@{ path = $readingIndexReference; format = 'markdown-section-index-v1'; generatedBy = 'Scripts/Audit-SourceSize.ps1' }
        summary = [ordered]@{ scannedSourceFileCount = $sourceFiles.Count; candidateFileCount = $candidateFiles.Count; currentCandidateCount = $candidateFiles.Count; baselineCandidateCount = $baselineCandidateFiles.Count; resolvedBaselineCount = @($baselineCandidateFiles | Where-Object { $_.resolved_status -eq 'resolved-split' }).Count; untrackedKnownTargetCount = $untrackedKnownTargets.Count; categoryCounts = $categoryCounts }
        exclusions = @('.agents, .codex, and .claude runtime copies are not canonical scan inputs', 'artifacts and generated extension output are not canonical scan inputs', 'new/untracked paths remain current-only and are never Git baseline candidates')
        baselineCandidates = @($baselineCandidateFiles | Sort-Object path); currentCandidates = @($candidateFiles | Sort-Object path); knownTargetTracking = $knownTargetTracking; untrackedKnownTargets = $untrackedKnownTargets; files = @($candidateFiles | Sort-Object path)
    }
    $outputDirectory = Split-Path -Parent $OutputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory -PathType Container)) { New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null }
    Write-ReadingIndex -Candidates $indexCandidates.ToArray() -Path $ReadingIndexPath
    [System.IO.File]::WriteAllText($OutputPath, (($inventory | ConvertTo-Json -Depth 10) + [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
    if ($PassThru) { Write-Output $inventory }
}

Export-ModuleMember -Function Invoke-SourceSizeAudit
