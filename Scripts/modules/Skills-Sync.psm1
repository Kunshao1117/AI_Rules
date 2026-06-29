#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 技能注入模組
.DESCRIPTION
    負責將 Shared/skills/ 唯一真實來源，注入到各平台的技能目錄。
    支援全量覆蓋與增量 SHA256 差異注入兩種模式。
#>

using module ".\Core.psm1"

function Test-SharedSkillRelativePathIncluded {
    param([string]$RelativePath)

    if (-not $RelativePath) { return $false }
    $normalized = $RelativePath.TrimStart('\', '/')
    $firstSegment = ($normalized -split '[\\/]')[0]
    $isProjectContextProtocol = $normalized -match '^project-context-protocol([\\\/]|$)'

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
        "policies\authorization-resolution.md",
        "policies\subagent-invocation.md"
    )) {
        $srcFile = Join-Path $SharedRoot $rel
        if (Test-Path -LiteralPath $srcFile -PathType Leaf) {
            $references.Add($rel)
        }
    }

    foreach ($dirRel in @("mcp-profiles", "policies")) {
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

    New-Item -ItemType Directory -Force -Path $TargetSkillsPath | Out-Null

    if ($Mode -eq "Full") {
        # 全量複製（Fresh 模式使用）
        Get-ChildItem $SharedSkillsRoot | Where-Object {
            # 排除符號連結目錄（_memory、_project、project-*），但保留正式索引與 project-context-protocol。
            Test-SharedSkillRelativePathIncluded -RelativePath $_.Name
        } | ForEach-Object {
            Copy-Item $_.FullName $TargetSkillsPath -Recurse -Force
        }
        $count = (Get-ChildItem $TargetSkillsPath -Directory | Where-Object {
            (Test-Path (Join-Path $_.FullName "SKILL.md"))
        }).Count
        Write-Ok "技能注入完成：$count 套技能 → $TargetSkillsPath"
        return $count
    }

    # Diff 模式（Upgrade 使用）
    $updated = 0
    Get-ChildItem $SharedSkillsRoot -Recurse -File | Where-Object {
        $relPath = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
        Test-SharedSkillRelativePathIncluded -RelativePath $relPath
    } | ForEach-Object {
        $rel     = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
        $tgtFile = Join-Path $TargetSkillsPath $rel
        $result  = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel -RequireExactHash
        if ($result.Status -in @("NEW", "CHANGED")) {
            $tgtDir = Split-Path $tgtFile -Parent
            if (-not (Test-Path $tgtDir)) { New-Item -ItemType Directory $tgtDir -Force | Out-Null }
            Copy-Item $_.FullName $tgtFile -Force
            $updated++
        }
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
            Copy-Item -LiteralPath $srcFile -Destination $tgtFile -Force
            $updated++
        }
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
        從 Shared/policies/ 讀取指定平台的政策轉譯區塊。
    .PARAMETER PolicyPath
        Shared/policies/subagent-invocation.md 的絕對路徑。
    .PARAMETER Platform
        目標平台：Codex / Claude / Antigravity。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Codex", "Claude", "Antigravity")]
        [string]$Platform
    )

    if (-not (Test-Path -LiteralPath $PolicyPath)) {
        Write-Fail "Shared policy 不存在：$PolicyPath"
        return ''
    }

    $content = Get-Content -LiteralPath $PolicyPath -Raw -Encoding UTF8
    $platformKey = $Platform.ToUpperInvariant()
    $pattern = "(?ms)<!--\s*SUBAGENT_POLICY:$platformKey`_START\s*-->\s*(.*?)\s*<!--\s*SUBAGENT_POLICY:$platformKey`_END\s*-->"
    $match = [regex]::Match($content, $pattern)
    if (-not $match.Success) {
        Write-Fail "Shared policy 缺少平台區塊：$Platform"
        return ''
    }

    return $match.Groups[1].Value.Trim()
}

function Sync-SharedPolicyBlock {
    <#
    .SYNOPSIS
        將 Shared policy 的平台轉譯區塊同步到核心規則 marker block。
    .PARAMETER PolicyPath
        Shared/policies/subagent-invocation.md 的絕對路徑。
    .PARAMETER TargetPath
        要注入的核心規則檔案。
    .PARAMETER Platform
        目標平台：Codex / Claude / Antigravity。
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
        [ValidateSet("Codex", "Claude", "Antigravity")]
        [string]$Platform,

        [string]$InsertBeforePattern = '',

        [string]$InsertAfterPattern = ''
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        Write-Warn "核心規則檔不存在，跳過 shared policy 注入：$TargetPath"
        return 0
    }

    $policyBlock = Get-SharedPolicyBlock -PolicyPath $PolicyPath -Platform $Platform
    if (-not $policyBlock) { return 0 }

    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    $generated = "$startMarker`r`n$policyBlock`r`n$endMarker"
    $content = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8
    $markerPattern = "(?ms)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"

    if ([regex]::IsMatch($content, $markerPattern)) {
        $newContent = [regex]::Replace($content, $markerPattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $generated }, 1)
    } elseif ($InsertBeforePattern -and [regex]::IsMatch($content, $InsertBeforePattern)) {
        $newContent = [regex]::Replace($content, $InsertBeforePattern, [System.Text.RegularExpressions.MatchEvaluator]{
            param($m)
            return "$generated`r`n`r`n$($m.Value)"
        }, 1)
    } elseif ($InsertAfterPattern -and [regex]::IsMatch($content, $InsertAfterPattern)) {
        $newContent = [regex]::Replace($content, $InsertAfterPattern, [System.Text.RegularExpressions.MatchEvaluator]{
            param($m)
            return "$($m.Value)`r`n`r`n$generated"
        }, 1)
    } else {
        $newContent = $content.TrimEnd() + "`r`n`r`n" + $generated + "`r`n"
    }

    if ($newContent -eq $content) {
        Write-Step "Shared subagent policy 已同步：$TargetPath"
        return 0
    }

    [System.IO.File]::WriteAllText($TargetPath, $newContent, (New-Object System.Text.UTF8Encoding $false))
    Write-Ok "Shared subagent policy 已注入：$TargetPath"
    return 1
}

Export-ModuleMember -Function Sync-SharedSkills, Sync-SharedGovernanceReferences, Sync-ProjectTools, Merge-WorkflowSkills, Get-SharedPolicyBlock, Sync-SharedPolicyBlock, Get-SharedGovernanceReferenceRelativePaths, Get-ProjectToolRelativePaths, Get-ProjectToolDiffs, Test-SharedSkillRelativePathIncluded, Test-CodexWorkflowRelativePathIncluded
