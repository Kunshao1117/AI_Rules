# Protected directory lifecycle and agent infrastructure initialization.

function Backup-ProtectedDirs {
    param([string]$AgentsRoot)
    $backup = @{ Memory = $null; Project = $null; Context = $null }
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
    $ctxDir  = Join-Path $AgentsRoot "context"
    if (Test-Path $memDir) {
        $tmp = Join-Path $env:TEMP "ag_backup_memory_$(Get-Random)"
        Copy-Item $memDir $tmp -Recurse -Force
        $backup.Memory = $tmp
        Write-Step "已備份共用記憶卡（D06 安全防線）..."
    }
    if (Test-Path $projDir) {
        $tmp = Join-Path $env:TEMP "ag_backup_project_$(Get-Random)"
        Copy-Item $projDir $tmp -Recurse -Force
        $backup.Project = $tmp
        Write-Step "已備份衍生技能（D06 安全防線）..."
    }
    if (Test-Path $ctxDir) {
        $tmp = Join-Path $env:TEMP "ag_backup_context_$(Get-Random)"
        Copy-Item $ctxDir $tmp -Recurse -Force
        $backup.Context = $tmp
        Write-Step "已備份專案脈絡卡（D06 安全防線）..."
    }
    return $backup
}

function Restore-ProtectedDirs {
    param(
        [hashtable]$Backup,
        [string]$AgentsRoot
    )
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
    $ctxDir  = Join-Path $AgentsRoot "context"
    if ($Backup.Memory -and (Test-Path $Backup.Memory)) {
        New-Item -ItemType Directory -Force -Path $memDir | Out-Null
        Copy-Item "$($Backup.Memory)\*" $memDir -Recurse -Force
        Remove-Item $Backup.Memory -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "共用記憶卡已完整保留並還原。"
    }
    if ($Backup.Project -and (Test-Path $Backup.Project)) {
        New-Item -ItemType Directory -Force -Path $projDir | Out-Null
        Copy-Item "$($Backup.Project)\*" $projDir -Recurse -Force
        Remove-Item $Backup.Project -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "衍生技能已完整保留並還原。"
    }
    if ($Backup.Context -and (Test-Path $Backup.Context)) {
        New-Item -ItemType Directory -Force -Path $ctxDir | Out-Null
        Copy-Item "$($Backup.Context)\*" $ctxDir -Recurse -Force
        Remove-Item $Backup.Context -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "專案脈絡卡已完整保留並還原。"
    }
}

function Initialize-AgentInfrastructure {
    param(
        [string]$AgentsRoot,
        [string]$ContextTemplatesRoot = ""
    )
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
    $ctxDir  = Join-Path $AgentsRoot "context"
    if (-not (Test-Path $memDir)) {
        New-Item -ItemType Directory $memDir -Force | Out-Null
        Write-Ok ".agents\memory\ 共用記憶庫目錄已建立（D01）"
    }
    if (-not (Test-Path $projDir)) {
        New-Item -ItemType Directory $projDir -Force | Out-Null
        Write-Ok ".agents\project_skills\ 衍生技能目錄已建立"
    }
    if (-not (Test-Path $ctxDir)) {
        New-Item -ItemType Directory $ctxDir -Force | Out-Null
        Write-Ok ".agents\context\ 專案脈絡目錄已建立"
    }
    $indexFile = Join-Path $projDir "_index.md"
    if (-not (Test-Path $indexFile)) {
        @"
# Project Skill Registry (專案衍生技能路由表)

| Keywords (EN) | 關鍵字 (ZH) | Skill | MCP Server |
|--------------|------------|-------|------------|
"@ | Set-Content $indexFile -Encoding UTF8
        Write-Ok "衍生技能路由表模板已建立"
    }
    $ctxMapDir = Join-Path $ctxDir "_map"
    if (-not (Test-Path $ctxMapDir)) {
        New-Item -ItemType Directory $ctxMapDir -Force | Out-Null
    }
    $ctxMapFile = Join-Path $ctxMapDir "CONTEXT.md"
    if (-not (Test-Path $ctxMapFile)) {
        $ctxMapTemplate = ""
        if ($ContextTemplatesRoot) {
            $candidateTemplate = Join-Path $ContextTemplatesRoot "_map\CONTEXT.md"
            if (Test-Path -LiteralPath $candidateTemplate) {
                $ctxMapTemplate = $candidateTemplate
            }
        }

        if ($ctxMapTemplate) {
            Copy-Item -LiteralPath $ctxMapTemplate -Destination $ctxMapFile -Force
            Write-Ok "專案脈絡索引卡模板已從 Shared/context 建立"
        } else {
            $today = (Get-Date).ToString("yyyy-MM-dd")
            @"
---
name: context-map
description: Index of project context cards.
context_type: index
scope: project
status: approved
confidence: high
last_reviewed: $today
approval: framework-default
sources: []
---

# Project Context Map

## Approved Context

- `_map`: Project context card registry.

## Candidate Context

- None.

## Deprecated Context

- None.

## Conflicts

- None.

## Evidence

- Created by Antigravity project context infrastructure.

## Relations

- `.agents/context/`: project context root.

## Promotion Notes

- Map cards are infrastructure indexes and should not be promoted to project skills.
"@ | Set-Content $ctxMapFile -Encoding UTF8
            Write-Ok "專案脈絡索引卡 fallback 模板已建立"
        }
    }
}
