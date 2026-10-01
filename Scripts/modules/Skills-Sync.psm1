#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 技能注入模組
.DESCRIPTION
    負責將 Shared/skills/ 唯一真實來源，注入到各平台的技能目錄。
    支援全量覆蓋與增量 SHA256 差異注入兩種模式。
#>

Import-Module -Name (Join-Path $PSScriptRoot 'Core.Reporting.psm1') -Force
Import-Module -Name (Join-Path $PSScriptRoot 'Core.Comparison.psm1') -Force
Import-Module -Name (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1') -Force

function Throw-SharedPolicySyncFailure {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('PolicyFileMissing', 'PolicyReadFailed', 'PolicyBlockMissing', 'PolicyBlockEmpty', 'TargetFileMissing', 'TargetReadFailed', 'TargetWriteFailed')]
        [string]$Code,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [string]$Detail = ''
    )

    $message = "Shared policy sync failed [$Code]: $Path"
    if ($Detail) { $message += " ($Detail)" }
    $exception = New-Object System.InvalidOperationException -ArgumentList $message
    $category = if ($Code -in @('PolicyFileMissing', 'TargetFileMissing')) {
        [System.Management.Automation.ErrorCategory]::ObjectNotFound
    } else {
        [System.Management.Automation.ErrorCategory]::InvalidData
    }
    $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "SharedPolicy.$Code", $category, $Path)
    throw $errorRecord
}

Import-Module (Join-Path $PSScriptRoot 'Skill-Migration.psm1') -Force -DisableNameChecking

function Test-SharedSkillRelativePathIncluded {
    param([string]$RelativePath)

    if (-not $RelativePath) { return $false }
    $normalized = $RelativePath.TrimStart('\', '/')
    $firstSegment = ($normalized -split '[\\/]')[0]
    $isProjectContextProtocol = $normalized -match '^project-context-protocol([\\\/]|$)'

    if ($firstSegment -in @(Get-LegacySkillMigrationArtifacts | Select-Object -ExpandProperty skill -Unique)) { return $false }

    if ($normalized -match '^_memory([\\\/]|$)') { return $false }
    if ($normalized -match '^_project([\\\/]|$)') { return $false }
    if ($firstSegment -match '^_' -and $normalized -ne '_index.md') { return $false }
    if ($normalized -match '^project-' -and -not $isProjectContextProtocol) { return $false }
    return $true
}

function Test-CodexWorkflowRelativePathIncluded {
    param([string]$RelativePath)

    if (-not $RelativePath) { return $false }
    $normalized = $RelativePath.TrimStart('\', '/')
    $firstSegment = ($normalized -split '[\\/]')[0]

    if ($firstSegment -eq '_shared') { return $true }
    return $firstSegment -notmatch '^_'
}

function Get-RetiredSharedSkillManifest {
    <#
    .SYNOPSIS
        Lists legacy Shared Skills that may be retired only after an exact
        historical official SHA256 match.
    .DESCRIPTION
        This is intentionally an allowlist, not an orphan scan. Unknown files
        and user Skills are outside this migration and are never candidates for
        removal.
    #>
    return @(
        [PSCustomObject]@{
            RelativePath = 'coding-reflection-gate/SKILL.md'
            KnownSha256 = @(
                '21BD3E11A914F01F623DA6ABF08F42F5397F09733307B5D112CE787211A6757C',
                '71BC2F789C33B9AB3062FA82AE4832F339748D2ED09EB27DC4B6D87A90664772'
            )
        }
        [PSCustomObject]@{
            RelativePath = 'design-reflection-gate/SKILL.md'
            KnownSha256 = @(
                '43879A1801CC0891EEFD675FB029E753F38970CDFAD65BBBFEBE2BBF23A1863D',
                '663D686BC85B2DC5F90171A420489692156090948F6015F530C095E998548D34'
            )
        }
    ) + @(Get-LegacySkillMigrationArtifacts | ForEach-Object {
        [PSCustomObject]@{
            RelativePath = $_.old_relative_path
            KnownSha256 = @(@($_.known_versions.sha256) + @($_.ApprovedCheckoutSha256))
        }
    })
}

function Remove-RetiredSharedSkills {
    <#
    .SYNOPSIS
        Safely retires hash-owned Shared Skills removed from the canonical tree.
    .DESCRIPTION
        Each candidate is an explicit historical path and SHA256 allowlist.
        A mismatch, unreadable file, or unknown path is preserved with a clear
        warning. No general skill-directory cleanup is performed.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$TargetSkillsPath
    )

    $removed = New-Object System.Collections.Generic.List[string]
    $preserved = New-Object System.Collections.Generic.List[string]
    foreach ($artifact in @(Get-RetiredSharedSkillManifest)) {
        $relativePath = [string]$artifact.RelativePath
        if ([string]::IsNullOrWhiteSpace($relativePath) -or
            $relativePath -match '(^|[\\/])\.{1,2}([\\/]|$)|:|[. ]([\\/]|$)' -or
            [System.IO.Path]::IsPathRooted($relativePath)) {
            throw "Invalid retired Shared Skill declaration: $relativePath"
        }

        $firstSegment = ($relativePath -split '[\\/]')[0]
        if ($firstSegment -in @('memory-ops', 'memory-arch', 'memory', 'context', '.cartridge')) {
            throw "Frozen Memory path is not a Shared Skill retirement candidate: $relativePath"
        }
        if ($firstSegment -in @('team-specialist-memory-closure',
            'team-memory-closure-delivery-artifact', 'team-specialist-memory-docs',
            'team-memory-docs-delivery-artifact') -and
            @((Get-LegacySkillMigrationArtifacts -Batch M3) | Where-Object {
                $_.old_relative_path -ceq $relativePath -and $_.skill -ceq $firstSegment
            }).Count -ne 1) {
            throw "Unmapped frozen Memory retirement path: $relativePath"
        }
        $targetPath = Join-Path $TargetSkillsPath ($relativePath -replace '/', '\\')
        $decision = Get-ManagedSkillRetirementDecision -TargetPath $targetPath -KnownSha256 @($artifact.KnownSha256)
        if ($decision.Action -eq 'SKIP') { continue }
        if ($decision.Action -ne 'RETIRE') {
            $preserved.Add($relativePath)
            $diagnostic = if ($decision.Action -eq 'PRESERVE') { 'preserved_user_modified_retired_skill' } else { 'preserved_unconfirmed_retired_skill' }
            Write-Warn "${diagnostic}: $relativePath; $($decision.Reason); manual action required."
            continue
        }

        Remove-Item -LiteralPath $targetPath -Force -ErrorAction Stop
        $removed.Add($relativePath)
        Write-Ok "removed_managed_retired_skill: $relativePath"

        $directory = Split-Path -Path $targetPath -Parent
        while ($directory -and (Test-Path -LiteralPath $directory -PathType Container) -and
               -not [string]::Equals($directory.TrimEnd('\\'), $TargetSkillsPath.TrimEnd('\\'), [System.StringComparison]::OrdinalIgnoreCase)) {
            if (@(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop).Count -ne 0) { break }
            Remove-Item -LiteralPath $directory -Force -ErrorAction Stop
            $directory = Split-Path -Path $directory -Parent
        }
    }

    # A source change/race after preflight must not become a successful mixed
    # active surface. Preserve the entry and let the existing transaction fail.
    Assert-LegacySkillMigrationReady -TargetSkillsPath $TargetSkillsPath
    return [PSCustomObject]@{
        Removed = @($removed.ToArray())
        Preserved = @($preserved.ToArray())
    }
}

function Assert-ExactDeploymentHash {
    <#
    .SYNOPSIS
        Verifies that a deployed file is an exact SHA256 copy of its source.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath
    )

    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) {
        throw "部署後缺少檔案，無法驗證 SHA256：$RelativePath"
    }

    $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    if ($sourceHash -ne $targetHash) {
        throw "部署後 SHA256 不一致：$RelativePath"
    }
}

function Get-SharedGovernanceReferenceRelativePaths {
    <#
    .SYNOPSIS
        Lists read-only Shared governance references deployed to .agents/shared/.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$SharedRoot
    )

    $references = New-Object System.Collections.Generic.List[string]
    foreach ($rel in @(
        "platform-capability-matrix.md",
        "workflow-capability-evidence-matrix.md",
        "skill-governance.md",
        "workflow-stage-procedures.md",
        "policies\authorization-resolution.md",
        "policies\workflow-orchestration.md",
        "policies\workflow-orchestration-scenarios.md",
        "policies\subagent-invocation.md"
    )) {
        $srcFile = Join-Path $SharedRoot $rel
        if (Test-Path -LiteralPath $srcFile -PathType Leaf) {
            $references.Add($rel)
        }
    }

    foreach ($dirRel in @("mcp-profiles", "policies", "agents", "workflows")) {
        $dir = Join-Path $SharedRoot $dirRel
        if (-not (Test-Path -LiteralPath $dir -PathType Container)) { continue }
        Get-ChildItem -LiteralPath $dir -Recurse -File -ErrorAction SilentlyContinue |
            Sort-Object FullName |
            ForEach-Object {
                $rel = $_.FullName.Substring($SharedRoot.Length).TrimStart('\', '/')
                if (-not $references.Contains($rel)) {
                    $references.Add($rel)
                }
            }
    }

    return @($references.ToArray())
}

function Get-ProjectToolRelativePaths {
    <#
    .SYNOPSIS
        Lists project-local tools deployed to .agents/tools/.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectToolsRoot
    )

    if (-not (Test-Path -LiteralPath $ProjectToolsRoot -PathType Container)) {
        return @()
    }

    return @(Get-ChildItem -LiteralPath $ProjectToolsRoot -Recurse -File -ErrorAction SilentlyContinue |
        Sort-Object FullName |
        ForEach-Object { $_.FullName.Substring($ProjectToolsRoot.Length).TrimStart('\', '/') })
}

function Get-ProjectToolDiffs {
    <#
    .SYNOPSIS
        Reports differences for deployable project-local tools.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectToolsRoot,

        [Parameter(Mandatory = $true)]
        [string]$TargetAgentsRoot
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $ProjectToolsRoot -PathType Container)) {
        return $diffs
    }

    $targetToolsRoot = Join-Path $TargetAgentsRoot "tools"
    foreach ($rel in @(Get-ProjectToolRelativePaths -ProjectToolsRoot $ProjectToolsRoot)) {
        $sourceFile = Join-Path $ProjectToolsRoot $rel
        $targetFile = Join-Path $targetToolsRoot $rel
        $diff = Compare-FrameworkFile -SourcePath $sourceFile -TargetPath $targetFile -RelativePath $rel
        if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
    }

    return $diffs
}

function Sync-ProjectTools {
    <#
    .SYNOPSIS
        Deploys restricted project-local tools into .agents/tools/.
    .PARAMETER ProjectToolsRoot
        Source Shared/project-tools/ directory.
    .PARAMETER TargetAgentsRoot
        Target project's .agents/ directory.
    .PARAMETER Mode
        Full copies every deployable tool. Diff copies only new or changed tools.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectToolsRoot,

        [Parameter(Mandatory = $true)]
        [string]$TargetAgentsRoot,

        [ValidateSet("Full", "Diff")]
        [string]$Mode = "Full"
    )

    if (-not (Test-Path -LiteralPath $ProjectToolsRoot -PathType Container)) {
        Write-Warn "專案本地工具來源不存在，跳過：$ProjectToolsRoot"
        return 0
    }

    $targetToolsRoot = Join-Path $TargetAgentsRoot "tools"
    New-Item -ItemType Directory -Force -Path $targetToolsRoot | Out-Null

    $updated = 0
    foreach ($rel in @(Get-ProjectToolRelativePaths -ProjectToolsRoot $ProjectToolsRoot)) {
        $sourceFile = Join-Path $ProjectToolsRoot $rel
        $targetFile = Join-Path $targetToolsRoot $rel
        $shouldCopy = $Mode -eq "Full"
        if (-not $shouldCopy) {
            $result = Compare-FrameworkFile -SourcePath $sourceFile -TargetPath $targetFile -RelativePath $rel
            $shouldCopy = $result.Status -in @("NEW", "CHANGED")
        }

        if ($shouldCopy) {
            $targetDir = Split-Path $targetFile -Parent
            if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
                New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
            }
            Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
            $updated++
        }
    }

    Write-Ok "專案本地工具同步完成：更新 $updated 個檔案 → $targetToolsRoot"
    return $updated
}

function Get-SharedSkillProjectedBytes {
    # Preserve raw bytes unless an active, explicit source-valid policy path
    # requires relocation. No mirror, universal string replacement, or Skill edit.
    param([string]$SourcePath, [string]$SharedSkillsRoot, [string]$TargetSkillsPath)
    $raw = [IO.File]::ReadAllBytes($SourcePath)
    $root = [IO.Path]::GetFullPath($SharedSkillsRoot).TrimEnd('\','/')
    $source = [IO.Path]::GetFullPath($SourcePath)
    if (-not $source.StartsWith($root + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'SkillProjection.SourceOutsideRoot' }
    $relative = $source.Substring($root.Length).TrimStart('\','/').Replace('\','/')
    $targetParent = Split-Path (Split-Path $TargetSkillsPath -Parent) -Leaf
    if ($source -notmatch '\.md$' -or $relative -match '(^|/)(legacy|archive|archives)(/|$)' -or
        $relative -eq '_index.md' -or $targetParent -notin @('.agents','.claude','.cursor')) { return ,$raw }
    $sharedRoot = Split-Path $root -Parent
    $policyRoot = [IO.Path]::GetFullPath((Join-Path $sharedRoot 'policies')).TrimEnd('\','/')
    $depth = @($relative.Split('/')).Count - 1
    $up = (@('..') * ($depth + $(if ($targetParent -eq '.agents') { 1 } else { 2 }))) -join '/'
    $runtimePrefix = if ($targetParent -eq '.agents') { 'shared/policies/' } else { '.agents/shared/policies/' }
    $text = [Text.Encoding]::UTF8.GetString($raw)
    $parts = [regex]::Split($text, '(\r\n|\n|\r)')
    $fence = ''; $legacyDepth = 0; $legacyBlock = $false; $compatParagraph = $false
    $pattern = '`(?<path>(?:\.\./)+[^`\s]+)`|\]\(<?(?<path>(?:\.\./)+[^\s)>]+)|^\s{0,3}\[[^\]\r\n]+\]:\s*<?(?<path>(?:\.\./)+[^\s>]+)'
    for ($i=0; $i -lt $parts.Length; $i+=2) {
        $line = $parts[$i]
        $fm = [regex]::Match($line, '^\s{0,3}(?<f>`{3,}|~{3,})')
        if ($fm.Success) {
            if (-not $fence) { $fence=$fm.Groups['f'].Value }
            elseif ($fm.Groups['f'].Value[0] -eq $fence[0] -and $fm.Groups['f'].Value.Length -ge $fence.Length) { $fence='' }
            continue
        }
        if ($fence) { continue }
        if ($line -match '<!--\s*\w*LEGACY\w*_START\s*-->') { $legacyBlock=$true }
        if ($line -match '<!--\s*\w*LEGACY\w*_END\s*-->') { $legacyBlock=$false; continue }
        $heading = [regex]::Match($line, '^(?<h>#{1,6})\s+(?<title>.+)$')
        if ($heading.Success) {
            $level=$heading.Groups['h'].Value.Length
            if ($legacyDepth -and $level -le $legacyDepth) { $legacyDepth=0 }
            if ($heading.Groups['title'].Value -match '(?i)\blegacy\b|\barchive\b|\bhistorical\b') { $legacyDepth=$level }
        }
        if ($legacyDepth -or $legacyBlock) { continue }
        if (-not $line.Trim()) { $compatParagraph=$false }
        $compat = [regex]::Match($line, '(?i)\b(?:an? unmigrated|compatibility-only|historical (?:reference|citation))\b')
        $limit = if ($compatParagraph) { 0 } elseif ($compat.Success) { $compat.Index } else { [int]::MaxValue }
        # Replace from the right so match offsets stay exact. Plain unquoted text
        # and inactive compatibility tails are not dependencies.
        $matches = @([regex]::Matches($line,$pattern))
        for ($j=$matches.Count-1; $j -ge 0; $j--) {
            $group=$matches[$j].Groups['path']
            if ($group.Index -ge $limit) { continue }
            $path=$group.Value; $base=($path -split '#',2)[0]
            $resolved=[IO.Path]::GetFullPath((Join-Path (Split-Path $source -Parent) $base))
            if (-not $resolved.StartsWith($policyRoot + '\',[StringComparison]::OrdinalIgnoreCase) -or
                -not (Test-Path -LiteralPath $resolved -PathType Leaf)) { continue }
            $suffix=$resolved.Substring($policyRoot.Length).TrimStart('\','/').Replace('\','/')
            $anchor=$path.Substring($base.Length)
            $replacement=$up+'/'+$runtimePrefix+$suffix+$anchor
            $line=$line.Remove($group.Index,$group.Length).Insert($group.Index,$replacement)
        }
        $parts[$i]=$line
        if ($compat.Success) { $compatParagraph=$true }
    }
    $projected=$parts -join ''
    if ($projected -ceq $text) { return ,$raw }
    return ,([Text.Encoding]::UTF8.GetBytes($projected))
}

function Compare-SharedSkillProjection {
    param([string]$SourcePath,[string]$TargetPath,[string]$SharedSkillsRoot,[string]$TargetSkillsPath,[string]$RelativePath)
    $bytes=Get-SharedSkillProjectedBytes -SourcePath $SourcePath -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $TargetSkillsPath
    $status='NEW'
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        $sha=[Security.Cryptography.SHA256]::Create()
        try {
            $expected=[BitConverter]::ToString($sha.ComputeHash($bytes))
            $actual=[BitConverter]::ToString($sha.ComputeHash([IO.File]::ReadAllBytes($TargetPath)))
            $status=if ($expected -ceq $actual) { 'SAME' } else { 'CHANGED' }
        } finally { $sha.Dispose() }
    }
    [pscustomobject]@{Status=$status;Path=$RelativePath}
}

function Sync-SharedSkills {
    <#
    .SYNOPSIS
        將 Shared/skills/ 全部技能注入到目標平台的技能目錄。
    .PARAMETER SharedSkillsRoot
        Shared/skills/ 的絕對路徑
    .PARAMETER TargetSkillsPath
        目標平台 skills/ 的絕對路徑（如 .agents/skills/ 或 .claude/skills/）
    .PARAMETER Mode
        Full（全量覆蓋）或 Diff（僅更新有差異的檔案）
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot,

        [Parameter(Mandatory = $true)]
        [string]$TargetSkillsPath,

        [ValidateSet("Full", "Diff")]
        [string]$Mode = "Full"
    )

    if (-not (Test-Path $SharedSkillsRoot)) {
        Write-Fail "Shared/skills/ 不存在：$SharedSkillsRoot"
        return 0
    }

    Assert-LegacySkillMigrationReady -TargetSkillsPath $TargetSkillsPath
    New-Item -ItemType Directory -Force -Path $TargetSkillsPath | Out-Null

    $updated = 0
    Get-ChildItem -LiteralPath $SharedSkillsRoot -Recurse -File | Where-Object {
        $relPath = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
        Test-SharedSkillRelativePathIncluded -RelativePath $relPath
    } | ForEach-Object {
        $rel = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
        $tgtFile = Join-Path $TargetSkillsPath $rel
        $bytes = Get-SharedSkillProjectedBytes -SourcePath $_.FullName -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $TargetSkillsPath
        $result = Compare-SharedSkillProjection -SourcePath $_.FullName -TargetPath $tgtFile -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $TargetSkillsPath -RelativePath $rel
        if ($Mode -eq 'Full' -or $result.Status -in @('NEW','CHANGED')) {
            $tgtDir = Split-Path $tgtFile -Parent
            if (-not (Test-Path -LiteralPath $tgtDir)) { New-Item -ItemType Directory -Path $tgtDir -Force | Out-Null }
            [IO.File]::WriteAllBytes($tgtFile,$bytes)
            $updated++
        }
        $verified = Compare-SharedSkillProjection -SourcePath $_.FullName -TargetPath $tgtFile -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $TargetSkillsPath -RelativePath $rel
        if ($verified.Status -ne 'SAME') { throw "SkillProjection.FinalBytesMismatch: $rel" }
    }
    $null = Remove-RetiredSharedSkills -TargetSkillsPath $TargetSkillsPath
    if ($Mode -eq 'Full') {
        $count = @(Get-ChildItem -LiteralPath $TargetSkillsPath -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }).Count
        Write-Ok "技能注入完成：$count 套技能 → $TargetSkillsPath"
        return $count
    }
    Write-Ok "技能差異注入完成：更新 $updated 個檔案"
    return $updated
}

function Sync-SharedGovernanceReferences {
    <#
    .SYNOPSIS
        將 Shared/ 根層共用治理參考檔同步到目標專案 .agents/shared/。
    .PARAMETER SharedRoot
        Shared/ 的絕對路徑。
    .PARAMETER TargetAgentsRoot
        目標專案 .agents/ 的絕對路徑。
    .PARAMETER Mode
        Full（全量覆蓋）或 Diff（僅更新有差異的檔案）。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$SharedRoot,

        [Parameter(Mandatory = $true)]
        [string]$TargetAgentsRoot,

        [ValidateSet("Full", "Diff")]
        [string]$Mode = "Full"
    )

    if (-not (Test-Path -LiteralPath $SharedRoot -PathType Container)) {
        Write-Fail "Shared/ 不存在：$SharedRoot"
        return 0
    }

    $targetSharedRoot = Join-Path $TargetAgentsRoot "shared"
    New-Item -ItemType Directory -Force -Path $targetSharedRoot | Out-Null

    $referenceFiles = @(Get-SharedGovernanceReferenceRelativePaths -SharedRoot $SharedRoot)

    $updated = 0
    foreach ($rel in $referenceFiles) {
        $srcFile = Join-Path $SharedRoot $rel
        if (-not (Test-Path -LiteralPath $srcFile -PathType Leaf)) {
            Write-Warn "共用治理參考檔不存在，跳過：$srcFile"
            continue
        }

        $tgtFile = Join-Path $targetSharedRoot $rel
        $shouldCopy = $Mode -eq "Full"
        if (-not $shouldCopy) {
            $result = Compare-FrameworkFile -SourcePath $srcFile -TargetPath $tgtFile -RelativePath $rel -RequireExactHash
            $shouldCopy = $result.Status -in @("NEW", "CHANGED")
        }

        if ($shouldCopy) {
            $tgtDir = Split-Path $tgtFile -Parent
            if (-not (Test-Path -LiteralPath $tgtDir -PathType Container)) {
                New-Item -ItemType Directory -Force -Path $tgtDir | Out-Null
            }
            Copy-Item -LiteralPath $srcFile -Destination $tgtFile -Force -ErrorAction Stop
            $updated++
        }
        Assert-ExactDeploymentHash -SourcePath $srcFile -TargetPath $tgtFile -RelativePath $rel
    }

    Write-Ok "共用治理參考同步完成：更新 $updated 個檔案 → $targetSharedRoot"
    return $updated
}

function Merge-WorkflowSkills {
    <#
    .SYNOPSIS
        將平台專屬的工作流技能合併到目標技能目錄。
        用於 Codex 平台：將 .agents/workflow-skills/ 合併至 .agents/skills/
    .PARAMETER WorkflowSkillsPath
        工作流技能目錄的絕對路徑（如 Codex/.agents/workflow-skills/）
    .PARAMETER TargetSkillsPath
        目標技能目錄的絕對路徑（如 .agents/skills/）
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkflowSkillsPath,

        [Parameter(Mandatory = $true)]
        [string]$TargetSkillsPath
    )

    if (-not (Test-Path $WorkflowSkillsPath)) {
        Write-Warn "工作流技能目錄不存在，跳過合併：$WorkflowSkillsPath"
        return 0
    }

    New-Item -ItemType Directory -Force -Path $TargetSkillsPath | Out-Null

    $count = 0
    Get-ChildItem $WorkflowSkillsPath -Directory |
        Where-Object { Test-CodexWorkflowRelativePathIncluded -RelativePath $_.Name } |
        ForEach-Object {
        $destDir = Join-Path $TargetSkillsPath $_.Name
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory $destDir -Force | Out-Null }
        Copy-Item (Join-Path $_.FullName "*") $destDir -Recurse -Force
        if ($_.Name -ne "_shared") { $count++ }
    }
    Write-Ok "工作流技能合併完成：$count 套工作流技能 → $TargetSkillsPath"
    return $count
}

function Get-SharedPolicyBlock {
    <#
    .SYNOPSIS
        從指定的 Shared 平台 Adapter 讀取政策轉譯區塊。
    .PARAMETER PolicyPath
        Shared/policies/adapters/ 下目標平台 Adapter 的絕對路徑。
    .PARAMETER Platform
        目標平台：Codex / Claude / Antigravity / Cursor。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Codex", "Claude", "Antigravity", "Cursor")]
        [string]$Platform
    )

    if (-not (Test-Path -LiteralPath $PolicyPath -PathType Leaf)) {
        Throw-SharedPolicySyncFailure -Code PolicyFileMissing -Path $PolicyPath
    }

    try {
        $content = Get-Content -LiteralPath $PolicyPath -Raw -Encoding UTF8 -ErrorAction Stop
    } catch {
        Throw-SharedPolicySyncFailure -Code PolicyReadFailed -Path $PolicyPath -Detail $_.Exception.Message
    }
    $platformKey = $Platform.ToUpperInvariant()
    $pattern = "(?ms)<!--\s*SUBAGENT_POLICY:$platformKey`_START\s*-->\s*(.*?)\s*<!--\s*SUBAGENT_POLICY:$platformKey`_END\s*-->"
    $match = [regex]::Match($content, $pattern)
    if (-not $match.Success) {
        Throw-SharedPolicySyncFailure -Code PolicyBlockMissing -Path $PolicyPath -Detail $Platform
    }

    $policyBlock = $match.Groups[1].Value.Trim()
    if (-not $policyBlock) {
        Throw-SharedPolicySyncFailure -Code PolicyBlockEmpty -Path $PolicyPath -Detail $Platform
    }

    return $policyBlock
}

function Get-GeneratedPolicyPointer {
    <#
    .SYNOPSIS
        Builds the intentionally short generated pointer kept in thin platform cores.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Codex", "Cursor")]
        [string]$Platform
    )

    $policyFileName = Split-Path -Path $PolicyPath -Leaf
    return @(
        '### Shared Subagent Invocation Policy (generated pointer)'
        ''
        "This marker is generated by ``Sync-SharedPolicyBlock`` from ``Shared/policies/adapters/$policyFileName``."
        "The full $Platform adapter and its referenced Shared contracts remain canonical in that source and are deployed under ``.agents/shared/``."
        'Do not hand-edit this generated marker.'
    ) -join "`r`n"
}

function Get-CodexGeneratedPolicyPointer {
    <#
    .SYNOPSIS
        Builds the intentionally short generated pointer kept in Codex core.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyPath
    )

    return Get-GeneratedPolicyPointer -PolicyPath $PolicyPath -Platform Codex
}

function Get-SharedPolicyBlockProjectedText {
    param(
        [Parameter(Mandatory = $true)][string]$PolicyPath,
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][ValidateSet('Codex', 'Claude', 'Antigravity', 'Cursor')][string]$Platform,
        [string]$InsertBeforePattern = '',
        [string]$InsertAfterPattern = ''
    )
    $policyBlock = Get-SharedPolicyBlock -PolicyPath $PolicyPath -Platform $Platform
    $generatedBlock = if ($Platform -in @('Codex', 'Cursor')) {
        Get-GeneratedPolicyPointer -PolicyPath $PolicyPath -Platform $Platform
    } else { $policyBlock }
    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    $markerPattern = "(?ms)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
    $existingMarker = [regex]::Match($Content, $markerPattern)
    $lineEnding = if ($existingMarker.Success) {
        if ($existingMarker.Value -match "`r`n") { "`r`n" } else { "`n" }
    } elseif ($Content -match "`r`n") { "`r`n" } else { "`n" }
    $normalizedGeneratedBlock = $generatedBlock -replace "`r`n|`r|`n", $lineEnding
    $generated = "$startMarker$lineEnding$normalizedGeneratedBlock$lineEnding$endMarker"
    if ($existingMarker.Success) {
        return [regex]::Replace($Content, $markerPattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $generated }, 1)
    }
    if ($InsertBeforePattern -and [regex]::IsMatch($Content, $InsertBeforePattern)) {
        return [regex]::Replace($Content, $InsertBeforePattern, [System.Text.RegularExpressions.MatchEvaluator]{
            param($m) "$generated$lineEnding$lineEnding$($m.Value)"
        }, 1)
    }
    if ($InsertAfterPattern -and [regex]::IsMatch($Content, $InsertAfterPattern)) {
        return [regex]::Replace($Content, $InsertAfterPattern, [System.Text.RegularExpressions.MatchEvaluator]{
            param($m) "$($m.Value)$lineEnding$lineEnding$generated"
        }, 1)
    }
    return $Content.TrimEnd() + $lineEnding + $lineEnding + $generated + $lineEnding
}

function Sync-SharedPolicyBlock {
    <#
    .SYNOPSIS
        將 Shared 平台 Adapter 的轉譯區塊同步到核心規則 marker block。
    .PARAMETER PolicyPath
        Shared/policies/adapters/ 下目標平台 Adapter 的絕對路徑。
    .PARAMETER TargetPath
        要注入的核心規則檔案。
    .PARAMETER Platform
        目標平台：Codex / Claude / Antigravity / Cursor。
    .PARAMETER InsertBeforePattern
        marker 不存在時，插入在第一個符合此 regex 的區塊前。
    .PARAMETER InsertAfterPattern
        marker 不存在且 InsertBeforePattern 未命中時，插入在第一個符合此 regex 的區塊後。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyPath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Codex", "Claude", "Antigravity", "Cursor")]
        [string]$Platform,

        [string]$InsertBeforePattern = '',

        [string]$InsertAfterPattern = ''
    )

    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) {
        Throw-SharedPolicySyncFailure -Code TargetFileMissing -Path $TargetPath
    }

    try {
        $content = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8 -ErrorAction Stop
    } catch {
        Throw-SharedPolicySyncFailure -Code TargetReadFailed -Path $TargetPath -Detail $_.Exception.Message
    }
    $newContent = Get-SharedPolicyBlockProjectedText -PolicyPath $PolicyPath -Content $content -Platform $Platform `
        -InsertBeforePattern $InsertBeforePattern -InsertAfterPattern $InsertAfterPattern

    if ($newContent -eq $content) {
        Write-Step "Shared subagent policy 已同步：$TargetPath"
        return 0
    }

    try {
        [System.IO.File]::WriteAllText($TargetPath, $newContent, (New-Object System.Text.UTF8Encoding $false))
    } catch {
        Throw-SharedPolicySyncFailure -Code TargetWriteFailed -Path $TargetPath -Detail $_.Exception.Message
    }
    Write-Ok "Shared subagent policy 已注入：$TargetPath"
    return 1
}

Export-ModuleMember -Function Get-SharedSkillProjectedBytes, Compare-SharedSkillProjection, Sync-SharedSkills, Sync-SharedGovernanceReferences, Sync-ProjectTools, Merge-WorkflowSkills, Get-SharedPolicyBlock, Get-GeneratedPolicyPointer, Get-CodexGeneratedPolicyPointer, Get-SharedPolicyBlockProjectedText, Sync-SharedPolicyBlock, Get-SharedGovernanceReferenceRelativePaths, Get-ProjectToolRelativePaths, Get-ProjectToolDiffs, Test-SharedSkillRelativePathIncluded, Test-CodexWorkflowRelativePathIncluded, Get-RetiredSharedSkillManifest
