#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 技能注入模組
.DESCRIPTION
    負責將 Shared/skills/ 唯一真實來源，注入到各平台的技能目錄。
    支援全量覆蓋與增量 SHA256 差異注入兩種模式。
#>

using module ".\Core.psm1"

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
            # 排除符號連結目錄（_memory、_project、project-*）
            -not ($_.Name -match '^_') -and -not ($_.Name -match '^project-')
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
        -not ($relPath -match '^_memory[\\\/]') -and -not ($relPath -match '^_project[\\\/]') `
        -and -not ($relPath -match '^project-')
    } | ForEach-Object {
        $rel     = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
        $tgtFile = Join-Path $TargetSkillsPath $rel
        $result  = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel
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
    Get-ChildItem $WorkflowSkillsPath -Directory | ForEach-Object {
        $destDir = Join-Path $TargetSkillsPath $_.Name
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory $destDir -Force | Out-Null }
        Copy-Item (Join-Path $_.FullName "*") $destDir -Recurse -Force
        $count++
    }
    Write-Ok "工作流技能合併完成：$count 套工作流技能 → $TargetSkillsPath"
    return $count
}

Export-ModuleMember -Function Sync-SharedSkills, Merge-WorkflowSkills
