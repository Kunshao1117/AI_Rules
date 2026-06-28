#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 核心共用工具函式庫
.DESCRIPTION
    提供彩色輸出、SHA256 比對、差異報告、確認閘門、
    D06 記憶卡安全備份/還原、衍生技能命名空間連結 Backfill 等共用函式。
    供 Platform-*.psm1 模組匯入使用。
#>

# ══════════════════════════════════════════════════════════
# 輸出輔助函式
# ══════════════════════════════════════════════════════════

function Write-Step { param([string]$Msg) Write-Host "  → $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  ✓ $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  ⚠ $Msg" -ForegroundColor Yellow }
function Write-Fail { param([string]$Msg) Write-Host "  ✗ $Msg" -ForegroundColor Red }

function Write-Banner {
    param([string]$Text, [string]$Color = "Magenta")
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $Color
    Write-Host "  $Text" -ForegroundColor $Color
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $Color
    Write-Host ""
}

function Write-DeployStats {
    param(
        [int]$Commands = 0,
        [int]$Skills   = 0,
        [int]$Rules    = 0,
        [string]$Label = "部署完成"
    )
    Write-Host "  $Label | 指令: $Commands | 技能: $Skills | 規範: $Rules" -ForegroundColor Cyan
}

# ══════════════════════════════════════════════════════════
# 版本工具
# ══════════════════════════════════════════════════════════

function Get-VersionContent {
    param([string]$Path)
    if (Test-Path $Path) { return (Get-Content $Path -Raw).Trim() }
    return "unknown"
}

# ══════════════════════════════════════════════════════════
# 文字規則語意比對
# ══════════════════════════════════════════════════════════

function Test-TextRuleFile {
    param([string]$Path)

    if (-not $Path) { return $false }

    $leaf = [System.IO.Path]::GetFileName($Path).ToLowerInvariant()
    if ($leaf -in @(".editorconfig", ".gitattributes", ".gitignore")) {
        return $true
    }

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
    return $extension -in @(
        ".conf",
        ".config",
        ".ini",
        ".json",
        ".jsonc",
        ".markdown",
        ".md",
        ".toml",
        ".txt",
        ".xml",
        ".yaml",
        ".yml"
    )
}

function Get-ProjectIdentityPattern {
    return '(?ms)^## \[PROJECT IDENTITY[^\r\n]*(?:\r\n|\n|\r).*?^<!--\s*/PROJECT_IDENTITY_END\s*-->\s*'
}

function Get-ProjectIdentityBlock {
    param([string]$Text)

    if (-not $Text) { return $null }

    $match = [regex]::Match($Text, (Get-ProjectIdentityPattern))
    if ($match.Success) { return $match.Value }
    return $null
}

function Remove-ProjectIdentityBlockFromText {
    param([string]$Text)

    if (-not $Text) { return $Text }

    return [regex]::Replace($Text, (Get-ProjectIdentityPattern), '')
}

function Get-NormalizedRuleText {
    param(
        [string]$Path,
        [switch]$ExcludeProjectIdentity
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($ExcludeProjectIdentity) {
        $content = Remove-ProjectIdentityBlockFromText -Text $content
    }
    return (($content -replace "`r`n", "`n") -replace "`r", "`n")
}

function Test-RuleTextEquivalent {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [switch]$IgnoreProjectIdentity
    )

    if (-not (Test-Path -LiteralPath $SourcePath) -or -not (Test-Path -LiteralPath $TargetPath)) {
        return $false
    }

    $srcHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $tgtHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    if ($srcHash -eq $tgtHash) {
        return $true
    }

    if (-not (Test-TextRuleFile -Path $SourcePath) -or -not (Test-TextRuleFile -Path $TargetPath)) {
        return $false
    }

    try {
        $sourceText = Get-NormalizedRuleText -Path $SourcePath -ExcludeProjectIdentity:$IgnoreProjectIdentity
        $targetText = Get-NormalizedRuleText -Path $TargetPath -ExcludeProjectIdentity:$IgnoreProjectIdentity
        return $sourceText.TrimEnd() -eq $targetText.TrimEnd()
    } catch {
        return $false
    }
}

function Restore-ProjectIdentityBlock {
    param(
        [string]$Path,
        [string]$ProjectIdentityBlock
    )

    if (-not $ProjectIdentityBlock -or -not (Test-Path -LiteralPath $Path)) { return $false }

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $pattern = Get-ProjectIdentityPattern
    if ([regex]::IsMatch($content, $pattern)) {
        $newContent = [regex]::Replace($content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{
            param($m)
            return $ProjectIdentityBlock
        }, 1)
    } else {
        $newContent = $content.TrimEnd() + "`r`n`r`n" + $ProjectIdentityBlock.Trim() + "`r`n"
    }

    if ($newContent -eq $content) { return $false }

    [System.IO.File]::WriteAllText($Path, $newContent, (New-Object System.Text.UTF8Encoding $false))
    return $true
}

# ══════════════════════════════════════════════════════════
# 單檔規則比對
# ══════════════════════════════════════════════════════════

function Compare-FrameworkFile {
    <#
    .SYNOPSIS
        比對來源與目標同一檔案是否有差異。
        回傳：NEW / SAME / CHANGED
    .NOTES
        內容等價性必須優先於時間戳；部署副本可能保留來源時間但內容已漂移。
    #>
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$RelativePath,
        [switch]$IgnoreProjectIdentity,
        [switch]$RequireExactHash
    )
    if (-Not (Test-Path $TargetPath)) {
        return [PSCustomObject]@{ Status = "NEW"; Path = $RelativePath }
    }
    if ($RequireExactHash) {
        $srcHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
        $tgtHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
        if ($srcHash -eq $tgtHash) {
            return [PSCustomObject]@{ Status = "SAME"; Path = $RelativePath }
        }
        return [PSCustomObject]@{ Status = "CHANGED"; Path = $RelativePath }
    }
    if (Test-RuleTextEquivalent -SourcePath $SourcePath -TargetPath $TargetPath -IgnoreProjectIdentity:$IgnoreProjectIdentity) {
        return [PSCustomObject]@{ Status = "SAME"; Path = $RelativePath }
    }
    return [PSCustomObject]@{ Status = "CHANGED"; Path = $RelativePath }
}

# ══════════════════════════════════════════════════════════
# 全域規則安全比對 (User Profile vs Framework Repo)
# ══════════════════════════════════════════════════════════

function Compare-GlobalRule {
    <#
    .SYNOPSIS
        比對全域規則（如 ~/.gemini/GEMINI.md）。預設只報告差異，-Apply 才寫入。
    .PARAMETER SourcePath
        框架源碼中的全域規則路徑
    .PARAMETER TargetPath
        使用者環境中的全域規則路徑 (User Profile)
    .PARAMETER Apply
        實際寫入使用者層全域規則。未指定時只做 dry-run。
    .PARAMETER BackupRoot
        寫入前備份舊檔的目錄。
    #>
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$StageDir,
        [switch]$Apply,
        [string]$BackupRoot
    )

    $fileName = Split-Path $SourcePath -Leaf

    if (-not $BackupRoot) {
        $BackupRoot = Join-Path (Split-Path $TargetPath -Parent) "backups"
    }

    # 若目標不存在：dry-run 只報告，-Apply 才建立
    if (-Not (Test-Path $TargetPath)) {
        if (-not $Apply) {
            Write-Warn "全域規則不存在，待授權建立: $TargetPath"
            return "MISSING"
        }
        New-Item -ItemType Directory -Force -Path (Split-Path $TargetPath -Parent) | Out-Null
        Copy-Item $SourcePath $TargetPath -Force
        Write-Ok "已授權建立全域規則: $TargetPath"
        return "INSTALLED"
    }

    # 若內容相同（含 CRLF/LF 文字規則差異）：跳過
    if (Test-RuleTextEquivalent -SourcePath $SourcePath -TargetPath $TargetPath) {
        Write-Step "全域規則已是最新: $fileName"
        return "SAME"
    }

    if (-not $Apply) {
        Write-Warn "全域規則有差異，dry-run 不覆寫: $TargetPath"
        return "CHANGED"
    }

    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $backupFile = Join-Path $BackupRoot "$fileName.$timestamp.bak"
    Copy-Item $TargetPath $backupFile -Force
    Copy-Item $SourcePath $TargetPath -Force

    Write-Ok "已授權更新全域規則: $TargetPath"
    Write-Step "舊檔備份: $backupFile"
    return "UPDATED"
}

# ══════════════════════════════════════════════════════════
# 通用差異掃描（可設定掃描目錄與保護目錄）
# ══════════════════════════════════════════════════════════

function Get-UpgradeReport {
    <#
    .SYNOPSIS
        掃描所有框架檔案，產出差異報告（NEW/CHANGED/SAME/ORPHAN/KEEP）。
    .PARAMETER SourceRoot
        框架源碼目錄（.agents/ 或 .claude/ 等）
    .PARAMETER TargetRoot
        目標專案對應目錄
    .PARAMETER ScanDirs
        要掃描的子目錄名稱陣列（預設：rules、workflows）
    .PARAMETER ProtectedDirs
        升級時不觸碰的受保護子目錄（顯示 KEEP）
    .PARAMETER ExcludeFiles
        要排除的特定檔案名稱（不加入報告）
    .PARAMETER ScanFiles
        要掃描的根層單檔相對路徑，例如 CLAUDE.md。
    #>
    param(
        [string]$SourceRoot,
        [string]$TargetRoot,
        [string[]]$ScanDirs       = @("rules", "workflows"),
        [string[]]$ProtectedDirs  = @("memory", "project_skills", "context"),
        [string[]]$ExcludeFiles   = @(),
        [string[]]$ScanFiles      = @(),
        [switch]$PreserveProjectIdentity
    )

    $results = @()

    # 根層單檔掃描：來源 → 目標
    foreach ($file in $ScanFiles) {
        $srcFile = Join-Path $SourceRoot $file
        if (-Not (Test-Path -LiteralPath $srcFile)) { continue }
        if ((Split-Path $file -Leaf) -in $ExcludeFiles) { continue }
        $rel = $file.Replace("\", "/")
        $tgtFile = Join-Path $TargetRoot $file
        $results += Compare-FrameworkFile -SourcePath $srcFile -TargetPath $tgtFile -RelativePath $rel -IgnoreProjectIdentity:$PreserveProjectIdentity
    }

    # 正向掃描：來源 → 目標
    foreach ($dir in $ScanDirs) {
        $srcPath = Join-Path $SourceRoot $dir
        if (-Not (Test-Path $srcPath)) { continue }

        Get-ChildItem $srcPath -File -Recurse | ForEach-Object {
            if ($_.Name -in $ExcludeFiles) { return }
            $rel     = $_.FullName.Substring($SourceRoot.Length).TrimStart('\', '/').Replace("\", "/")
            $tgtFile = Join-Path $TargetRoot $rel
            $results += Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel -IgnoreProjectIdentity:$PreserveProjectIdentity
        }
    }

    # 根層單檔掃描：目標 → 來源（孤兒偵測）
    foreach ($file in $ScanFiles) {
        if ((Split-Path $file -Leaf) -in $ExcludeFiles) { continue }
        $tgtFile = Join-Path $TargetRoot $file
        if (-Not (Test-Path -LiteralPath $tgtFile)) { continue }
        $srcFile = Join-Path $SourceRoot $file
        if (-Not (Test-Path -LiteralPath $srcFile)) {
            $results += [PSCustomObject]@{ Status = "ORPHAN"; Path = $file.Replace("\", "/") }
        }
    }

    # 反向掃描：目標 → 來源（孤兒偵測）
    foreach ($dir in $ScanDirs) {
        $tgtPath = Join-Path $TargetRoot $dir
        if (-Not (Test-Path $tgtPath)) { continue }

        Get-ChildItem $tgtPath -File -Recurse | ForEach-Object {
            $rel     = $_.FullName.Substring($TargetRoot.Length).TrimStart('\', '/').Replace("\", "/")
            if ($_.Name -in $ExcludeFiles) { return }
            $srcFile = Join-Path $SourceRoot $rel
            if (-Not (Test-Path $srcFile)) {
                $results += [PSCustomObject]@{ Status = "ORPHAN"; Path = $rel }
            }
        }
    }

    # 保護目錄掃描（KEEP — 不會被修改）
    foreach ($protDir in $ProtectedDirs) {
        $tgtProt = Join-Path $TargetRoot $protDir
        if (-Not (Test-Path $tgtProt)) { continue }
        Get-ChildItem $tgtProt -Directory -Recurse | Where-Object {
            (Test-Path (Join-Path $_.FullName "SKILL.md")) -or
            (Test-Path (Join-Path $_.FullName "MEMORY.md")) -or
            (Test-Path (Join-Path $_.FullName "CONTEXT.md"))
        } | ForEach-Object {
            $rel = $_.FullName.Substring($tgtProt.Length).TrimStart('\', '/').Replace("\", "/")
            $results += [PSCustomObject]@{ Status = "KEEP"; Path = "$protDir/$rel/" }
        }
    }

    return $results
}

# ══════════════════════════════════════════════════════════
# 差異報告輸出（彩色）
# ══════════════════════════════════════════════════════════

function Write-UpgradeReport {
    param(
        [array]$Report,
        [System.Collections.IDictionary]$CategoryMap,   # 接受 [ordered]@{} 並保留插入順序
        [string]$Platform = ""
    )

    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+08:00")
    $label = if ($Platform) { " [$Platform]" } else { "" }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan
    Write-Host "  升級差異報告$label — $timestamp" -ForegroundColor DarkCyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    $statusColors = @{
        "NEW"     = "Green"
        "CHANGED" = "Yellow"
        "SAME"    = "DarkGray"
        "KEEP"    = "Cyan"
        "ORPHAN"  = "Magenta"
    }

    foreach ($catName in $CategoryMap.Keys) {
        $filter = $CategoryMap[$catName]
        $items  = $Report | Where-Object $filter
        if ($null -eq $items -or @($items).Count -eq 0) { continue }

        Write-Host ""
        Write-Host "  $catName" -ForegroundColor White
        Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkGray

        $sorted = @($items) | Sort-Object {
            switch ($_.Status) { "NEW" { 0 } "CHANGED" { 1 } "ORPHAN" { 2 } "SAME" { 3 } "KEEP" { 4 } }
        }
        foreach ($item in $sorted) {
            $color = $statusColors[$item.Status]
            $tag   = "[$($item.Status)]".PadRight(10)
            Write-Host "  $tag $($item.Path)" -ForegroundColor $color
        }
    }

    $newCount    = @($Report | Where-Object { $_.Status -eq "NEW" }).Count
    $changedCount= @($Report | Where-Object { $_.Status -eq "CHANGED" }).Count
    $sameCount   = @($Report | Where-Object { $_.Status -eq "SAME" }).Count
    $keepCount   = @($Report | Where-Object { $_.Status -eq "KEEP" }).Count
    $orphanCount = @($Report | Where-Object { $_.Status -eq "ORPHAN" }).Count

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan
    Write-Host "  新增: $newCount | 變更: $changedCount | 相同: $sameCount | 受保護: $keepCount | 孤兒: $orphanCount" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    return @{ New = $newCount; Changed = $changedCount; Same = $sameCount; Keep = $keepCount; Orphan = $orphanCount }
}

# ══════════════════════════════════════════════════════════
# 執行檔案更新（只寫 NEW/CHANGED）
# ══════════════════════════════════════════════════════════

function Install-Upgrade {
    param(
        [array]$Report,
        [string]$SourceRoot,
        [string]$TargetRoot,
        [switch]$PreserveProjectIdentity
    )
    $applied = 0
    foreach ($item in $Report) {
        if ($item.Status -notin @("NEW", "CHANGED")) { continue }
        $srcFile = Join-Path $SourceRoot $item.Path
        $tgtFile = Join-Path $TargetRoot $item.Path
        $tgtDir  = Split-Path $tgtFile -Parent
        $projectIdentity = $null
        if ($PreserveProjectIdentity -and (Test-Path -LiteralPath $tgtFile)) {
            $projectIdentity = Get-ProjectIdentityBlock -Text (Get-Content -LiteralPath $tgtFile -Raw -Encoding UTF8)
        }
        if (-Not (Test-Path $tgtDir)) { New-Item -ItemType Directory $tgtDir -Force | Out-Null }
        Copy-Item $srcFile $tgtFile -Force
        if ($projectIdentity) {
            $null = Restore-ProjectIdentityBlock -Path $tgtFile -ProjectIdentityBlock $projectIdentity
        }
        $verb = if ($item.Status -eq "NEW") { "已建立" } else { "已更新" }
        Write-Ok "${verb}: $($item.Path)"
        $applied++
    }
    return $applied
}

# ══════════════════════════════════════════════════════════
# 確認閘門（等待使用者輸入 Y/N）
# ══════════════════════════════════════════════════════════

function Invoke-ConfirmGate {
    param([string]$Message = "是否繼續？(Y/N)")
    $answer = Read-Host "  $Message"
    return ($answer -match "^[Yy]$")
}

# ══════════════════════════════════════════════════════════
# CHANGELOG/RELEASE_NOTES 提取
# ══════════════════════════════════════════════════════════

function Get-ReleaseNotes {
    param(
        [string]$ChangelogPath
    )
    if (-Not (Test-Path $ChangelogPath)) { return @() }
    $lines     = Get-Content $ChangelogPath
    $capturing = $false
    $notes     = @()
    foreach ($line in $lines) {
        if ($line -match "^## ") {
            if ($capturing) { break }
            $capturing = $true
            continue
        }
        if ($capturing) { $notes += $line }
    }
    return $notes
}

# ══════════════════════════════════════════════════════════
# D06 安全網：備份/還原受保護目錄
# ══════════════════════════════════════════════════════════

function Backup-ProtectedDirs {
    <#
    .SYNOPSIS
        將 memory/、project_skills/ 與 context/ 備份到 TEMP 目錄。
        回傳 hashtable: @{ Memory = $tmpPath; Project = $tmpPath; Context = $tmpPath }
    #>
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
    <#
    .SYNOPSIS
        從 TEMP 備份還原 memory/、project_skills/ 與 context/，並清除暫存。
    #>
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

# ══════════════════════════════════════════════════════════
# 基礎設施初始化（memory/ project_skills/ context/ _index.md）
# ══════════════════════════════════════════════════════════

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

# ══════════════════════════════════════════════════════════
# 衍生技能命名空間連結 Backfill（冪等）
# ══════════════════════════════════════════════════════════

function Invoke-ProjectSkillBackfill {
    param(
        [string]$AgentsRoot,
        [string]$SkillsDir = ""   # 若空則預設 $AgentsRoot/skills（AG/Codex 用）
    )
    if (-not $SkillsDir) { $SkillsDir = Join-Path $AgentsRoot "skills" }
    $projDir   = Join-Path $AgentsRoot "project_skills"
    if (-not (Test-Path $projDir)) { return }

    New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

    function Get-BackfillLinkTarget {
        param($Item)
        $target = $null
        if ($Item -and ($Item.PSObject.Properties.Name -contains "Target")) {
            $target = $Item.Target
        } elseif ($Item -and ($Item.PSObject.Properties.Name -contains "LinkTarget")) {
            $target = $Item.LinkTarget
        }
        if ($target -is [array]) { $target = $target[0] }
        if ($target) { return [string]$target }
        return ""
    }

    function Test-BackfillPathEquals {
        param(
            [string]$Left,
            [string]$Right
        )
        if (-not $Left -or -not $Right) { return $false }
        try {
            $leftFull = (Resolve-Path -LiteralPath $Left -ErrorAction Stop).Path
        } catch {
            $leftFull = [System.IO.Path]::GetFullPath($Left)
        }
        try {
            $rightFull = (Resolve-Path -LiteralPath $Right -ErrorAction Stop).Path
        } catch {
            $rightFull = [System.IO.Path]::GetFullPath($Right)
        }
        return [string]::Equals($leftFull.TrimEnd('\', '/'), $rightFull.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Get-BackfillFullPath {
        param([string]$Path)
        if (-not $Path) { return "" }
        try {
            return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path.TrimEnd('\', '/')
        } catch {
            return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        }
    }

    function Test-BackfillPathUnderRoot {
        param(
            [string]$Path,
            [string]$Root
        )
        if (-not $Path -or -not $Root) { return $false }
        $full = Get-BackfillFullPath -Path $Path
        $rootFull = Get-BackfillFullPath -Path $Root
        return $full.StartsWith($rootFull + '\', [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Get-BackfillDirectoryHashMap {
        param([string]$Path)
        $root = Get-BackfillFullPath -Path $Path
        $map = @{}
        Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $full = Get-BackfillFullPath -Path $_.FullName
            $relative = $full.Substring($root.Length).TrimStart('\', '/').ToLowerInvariant()
            $map[$relative] = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
        }
        return $map
    }

    function Test-BackfillDirectoryEquivalent {
        param(
            [string]$Left,
            [string]$Right
        )
        if (-not (Test-Path -LiteralPath $Left) -or -not (Test-Path -LiteralPath $Right)) { return $false }
        $leftMap = Get-BackfillDirectoryHashMap -Path $Left
        $rightMap = Get-BackfillDirectoryHashMap -Path $Right
        if ($leftMap.Count -ne $rightMap.Count) { return $false }
        foreach ($key in $leftMap.Keys) {
            if (-not $rightMap.ContainsKey($key)) { return $false }
            if ($leftMap[$key] -ne $rightMap[$key]) { return $false }
        }
        return $true
    }

    function Test-BackfillDiscoveryStubForTarget {
        param(
            [string]$DiscoveryPath,
            [string]$TargetPath
        )
        if (-not (Test-Path -LiteralPath $DiscoveryPath) -or -not (Test-Path -LiteralPath $TargetPath)) { return $false }

        $files = @(Get-ChildItem -LiteralPath $DiscoveryPath -Recurse -File -Force -ErrorAction SilentlyContinue)
        if ($files.Count -ne 1 -or $files[0].Name -ne "SKILL.md") { return $false }

        $stub = Get-Content -LiteralPath $files[0].FullName -Raw -Encoding UTF8
        $targetFull = (Join-Path (Get-BackfillFullPath -Path $TargetPath) "SKILL.md").Replace('\', '/')
        $agentsRootFull = (Get-BackfillFullPath -Path $AgentsRoot).Replace('\', '/')
        $relativeTarget = $targetFull
        if ($targetFull.StartsWith($agentsRootFull + '/', [System.StringComparison]::OrdinalIgnoreCase)) {
            $relativeTarget = ".agents/" + $targetFull.Substring($agentsRootFull.Length + 1)
        }

        return ($stub -match '(?m)^# Project Route\b') -and
            ($stub -match '(?m)Read and follow the project skill source:') -and
            ($stub -like "*$relativeTarget*")
    }

    function Remove-PhysicalProjectDiscoveryEntry {
        param([string]$Path)
        if (-not (Test-BackfillPathUnderRoot -Path $Path -Root $SkillsDir)) {
            Write-Warn "拒絕移除不在技能 discovery 根目錄內的項目: $Path"
            return $false
        }
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        return $true
    }

    function Repair-PhysicalProjectSkillDiscoveryEntries {
        $changed = 0
        $blockedLocal = 0
        if (-not (Test-Path -LiteralPath $SkillsDir)) {
            return [PSCustomObject]@{ Changed = $changed; Blocked = $blockedLocal }
        }

        $entries = @(Get-ChildItem -LiteralPath $SkillsDir -Force -ErrorAction SilentlyContinue |
            Where-Object { ($_.Name -match '^project-') -and ($_.Name -ne 'project-context-protocol') })

        foreach ($entry in $entries) {
            $isReparsePoint = [bool]($entry.Attributes -band [IO.FileAttributes]::ReparsePoint)
            if ($isReparsePoint) { continue }

            $skillName = $entry.Name.Substring('project-'.Length)
            $targetPath = Join-Path $projDir $skillName
            $entrySkill = Join-Path $entry.FullName "SKILL.md"

            if (-not $entry.PSIsContainer -or -not (Test-Path -LiteralPath $entrySkill)) {
                Write-Warn "衍生技能 discovery entry 不是有效技能目錄，已保留待手動處理: $($entry.Name)"
                $blockedLocal++
                continue
            }

            if (Test-Path -LiteralPath $targetPath) {
                if ((Test-BackfillDirectoryEquivalent -Left $entry.FullName -Right $targetPath) -or
                    (Test-BackfillDiscoveryStubForTarget -DiscoveryPath $entry.FullName -TargetPath $targetPath)) {
                    if (Remove-PhysicalProjectDiscoveryEntry -Path $entry.FullName) {
                        Write-Ok "重建前已移除重複的實體 discovery 目錄: $($entry.Name)"
                        $changed++
                    } else {
                        $blockedLocal++
                    }
                } else {
                    Write-Warn "衍生技能 discovery entry 與 project_skills 原檔內容不同，已保留避免覆寫: $($entry.Name)"
                    $blockedLocal++
                }
                continue
            }

            if (-not (Test-BackfillPathUnderRoot -Path $entry.FullName -Root $SkillsDir)) {
                Write-Warn "拒絕遷移不在技能 discovery 根目錄內的項目: $($entry.FullName)"
                $blockedLocal++
                continue
            }

            Move-Item -LiteralPath $entry.FullName -Destination $targetPath -ErrorAction Stop
            Write-Ok "已將實體 discovery 技能遷移到 project_skills: $skillName"
            $changed++
        }

        return [PSCustomObject]@{ Changed = $changed; Blocked = $blockedLocal }
    }

    function New-ProjectSkillNamespaceLink {
        param(
            [string]$LinkPath,
            [string]$TargetPath,
            [string]$SkillName
        )

        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -ErrorAction SilentlyContinue | Out-Null
        if (-not (Test-Path -LiteralPath (Join-Path $LinkPath "SKILL.md"))) {
            # 降級：Junction 不需要 Developer Mode 或管理員
            New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath -ErrorAction SilentlyContinue | Out-Null
        }

        if (Test-Path -LiteralPath (Join-Path $LinkPath "SKILL.md")) {
            Write-Ok "衍生技能連結已建立: project-$SkillName"
            return $true
        }

        Write-Warn "無法建立連結（需 Developer Mode 或管理員）: project-$SkillName"
        return $false
    }

    $repairResult = Repair-PhysicalProjectSkillDiscoveryEntries
    $count = [int]$repairResult.Changed
    $blocked = [int]$repairResult.Blocked
    $projectSkills = @(Get-ChildItem $projDir -Directory -ErrorAction SilentlyContinue | Where-Object {
        ($_.Name -notmatch '^_') -and (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md"))
    })

    foreach ($skill in $projectSkills) {
        $linkPath = Join-Path $SkillsDir "project-$($skill.Name)"
        $linkItem = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue

        if ($linkItem) {
            $isReparsePoint = [bool]($linkItem.Attributes -band [IO.FileAttributes]::ReparsePoint)
            if (-not $isReparsePoint) {
                Write-Warn "衍生技能 discovery entry 不是符號連結/Junction，已跳過避免覆寫: project-$($skill.Name)"
                $blocked++
                continue
            }

            $target = Get-BackfillLinkTarget -Item $linkItem
            $targetSkill = if ($target) { Join-Path $target "SKILL.md" } else { "" }
            $isValidTarget = (Test-BackfillPathEquals -Left $target -Right $skill.FullName) -and (Test-Path -LiteralPath $targetSkill)
            if ($isValidTarget) {
                continue
            }

            Remove-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
        }

        if (-not (Test-Path -LiteralPath $linkPath)) {
            if (New-ProjectSkillNamespaceLink -LinkPath $linkPath -TargetPath $skill.FullName -SkillName $skill.Name) {
                $count++
            }
        }
    }

    if (($count -eq 0) -and ($blocked -eq 0)) { Write-Step "衍生技能命名空間連結已是最新，無需補建。" }
    if ($blocked -gt 0) { Write-Warn "有 $blocked 個 project-* discovery entry 不是連結，需手動處理。" }
    return $count
}

# ══════════════════════════════════════════════════════════
# 孤兒清除
# ══════════════════════════════════════════════════════════

function Remove-OrphanFiles {
    param(
        [array]$Report,
        [string]$TargetRoot,
        [string[]]$ProtectedDirs = @()
    )
    $orphans = $Report | Where-Object { $_.Status -eq "ORPHAN" }
    if (-not $orphans -or @($orphans).Count -eq 0) { return }

    $resolvedTargetRoot = (Resolve-Path -LiteralPath $TargetRoot).Path
    $protectedRoots = @()
    foreach ($dir in $ProtectedDirs) {
        $candidate = Join-Path $resolvedTargetRoot $dir
        if (Test-Path -LiteralPath $candidate) {
            $protectedRoots += (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    function Test-IsUnderRoot {
        param(
            [string]$Path,
            [string]$Root
        )
        $fullPath = [System.IO.Path]::GetFullPath($Path)
        $fullRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
        return $fullPath.Equals($fullRoot, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith($fullRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith($fullRoot + [System.IO.Path]::AltDirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Test-IsProtectedPath {
        param([string]$Path)
        foreach ($root in $protectedRoots) {
            if (Test-IsUnderRoot -Path $Path -Root $root) { return $true }
        }
        return $false
    }

    Write-Step "正在清除 $(@($orphans).Count) 個孤兒檔案..."
    foreach ($item in $orphans) {
        $path = [System.IO.Path]::GetFullPath((Join-Path $resolvedTargetRoot $item.Path))
        if (-not (Test-IsUnderRoot -Path $path -Root $resolvedTargetRoot)) {
            Write-Warn "略過超出目標根目錄的孤兒路徑: $($item.Path)"
            continue
        }
        if (Test-IsProtectedPath -Path $path) {
            Write-Warn "略過受保護目錄內的孤兒路徑: $($item.Path)"
            continue
        }
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
            Write-Ok "已刪除孤兒: $($item.Path)"
        }
    }
    # 清理空資料夾
    Get-ChildItem -LiteralPath $resolvedTargetRoot -Directory -Recurse |
        Sort-Object { $_.FullName.Length } -Descending |
        ForEach-Object {
            if ((-not (Test-IsProtectedPath -Path $_.FullName)) -and
                (@(Get-ChildItem -LiteralPath $_.FullName -Force).Count -eq 0)) {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
            }
        }
    Write-Ok "孤兒清除完成。"
}

# ══════════════════════════════════════════════════════════
# .gitignore 條目設定
# ══════════════════════════════════════════════════════════

function Get-AiRulesTextFileContent {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return "" }

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -eq 0) { return "" }

    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        return (New-Object System.Text.UTF8Encoding -ArgumentList $false, $true).GetString($bytes, 3, ($bytes.Length - 3))
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        return [System.Text.Encoding]::Unicode.GetString($bytes, 2, ($bytes.Length - 2))
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
        return [System.Text.Encoding]::BigEndianUnicode.GetString($bytes, 2, ($bytes.Length - 2))
    }

    try {
        return (New-Object System.Text.UTF8Encoding -ArgumentList $false, $true).GetString($bytes)
    } catch {
        return (Get-AiRulesLegacyTextEncoding).GetString($bytes)
    }
}

function Get-AiRulesLegacyTextEncoding {
    try {
        Add-Type -AssemblyName System.Text.Encoding.CodePages -ErrorAction SilentlyContinue
        [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance)
        return [System.Text.Encoding]::GetEncoding(0)
    } catch {
        return [System.Text.Encoding]::Default
    }
}

function Set-AiRulesTextFileContent {
    param(
        [string]$Path,
        [AllowNull()][string]$Content
    )

    if ($null -eq $Content) { $Content = "" }
    $encoding = New-Object System.Text.UTF8Encoding -ArgumentList $true
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Get-AiRulesGitignoreStandardPatterns {
    return @(
        "/.codex/",
        "/.claude/",
        "/CLAUDE.md",
        "/antigravity_export/",
        "/.agents/*",
        "!/.agents/memory/",
        "!/.agents/memory/**",
        "!/.agents/context/",
        "!/.agents/context/**",
        "!/.agents/project_skills/",
        "!/.agents/project_skills/**",
        "/.agents/logs/",
        "/.cartridge/"
    )
}

function Get-AiRulesGitignoreStandardCommentLines {
    return @(
        "# [啟用][AI Rules 框架] 由框架初始化或升級產生，可重建，不進版控",
        "# [啟用][代理框架] 代理規則、工作流與共用技能多為部署產物，預設不進版控",
        "# [保留][專案記憶] 原始碼記憶是專案知識資產，必須允許進版控",
        "# [保留][專案脈絡] 設計 DNA、產品偏好與驗收偏好是專案知識資產，必須允許進版控",
        "# [保留][專案衍生技能] 專案專屬技能屬於專案能力，必須允許進版控",
        "# [啟用][執行狀態] 代理日誌與本地索引是執行期產物，不進版控"
    )
}

function Get-AiRulesGitignorePatternKey {
    param([string]$Pattern)

    if ([string]::IsNullOrWhiteSpace($Pattern)) { return "" }
    $normalized = $Pattern.Trim() -replace "\\", "/"
    $negated = $false
    if ($normalized.StartsWith("!")) {
        $negated = $true
        $normalized = $normalized.Substring(1)
    }
    $normalized = $normalized.TrimStart("/")
    while ($normalized.StartsWith("**/")) {
        $normalized = $normalized.Substring(3)
    }
    $normalized = $normalized -replace "/\*\*$", "/"
    if ($negated) { return "!$normalized" }
    return $normalized
}

function Get-AiRulesGitignoreManagedBlock {
    param([string[]]$AdditionalLines = @())

    $standardKeys = @(Get-AiRulesGitignoreStandardPatterns | ForEach-Object { Get-AiRulesGitignorePatternKey -Pattern $_ })
    $additional = @($AdditionalLines | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_) -and
        -not ($_.Trim().StartsWith("#")) -and
        -not ((Get-AiRulesGitignorePatternKey -Pattern $_) -in $standardKeys)
    } | Select-Object -Unique)

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# [啟用][AI Rules 框架] 由框架初始化或升級產生，可重建，不進版控")
    $lines.Add("/.codex/")
    $lines.Add("/.claude/")
    $lines.Add("/CLAUDE.md")
    $lines.Add("/antigravity_export/")
    $lines.Add("")
    $lines.Add("# [啟用][代理框架] 代理規則、工作流與共用技能多為部署產物，預設不進版控")
    $lines.Add("/.agents/*")
    $lines.Add("")
    $lines.Add("# [保留][專案記憶] 原始碼記憶是專案知識資產，必須允許進版控")
    $lines.Add("!/.agents/memory/")
    $lines.Add("!/.agents/memory/**")
    $lines.Add("")
    $lines.Add("# [保留][專案脈絡] 設計 DNA、產品偏好與驗收偏好是專案知識資產，必須允許進版控")
    $lines.Add("!/.agents/context/")
    $lines.Add("!/.agents/context/**")
    $lines.Add("")
    $lines.Add("# [保留][專案衍生技能] 專案專屬技能屬於專案能力，必須允許進版控")
    $lines.Add("!/.agents/project_skills/")
    $lines.Add("!/.agents/project_skills/**")
    $lines.Add("")
    $lines.Add("# [啟用][執行狀態] 代理日誌與本地索引是執行期產物，不進版控")
    $lines.Add("/.agents/logs/")
    $lines.Add("/.cartridge/")

    if ($additional.Count -gt 0) {
        $lines.Add("")
        $lines.Add("# [啟用][其他] 專案額外要求的 AI Rules 排除項目")
        foreach ($line in $additional) { $lines.Add($line.Trim()) }
    }

    return @($lines)
}

function Test-GitignoreExactPatternPresent {
    param(
        [string[]]$ExistingLines,
        [string]$Pattern
    )

    $target = ($Pattern -replace "\\", "/").Trim()
    foreach ($line in $ExistingLines) {
        $candidate = ($line -replace "\\", "/").Trim()
        if ($candidate -eq $target) { return $true }
    }
    return $false
}

function Test-AiRulesGitignoreRelatedPattern {
    param([string]$Line)

    return (Test-AiRulesGitignoreSimilarPattern -Line $Line)
}

function Test-AiRulesGitignoreSimilarPattern {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("#")) { return $false }
    if (Test-AiRulesGitignoreStandardPattern -Line $trimmed) { return $false }

    $key = Get-AiRulesGitignorePatternKey -Pattern $trimmed
    $similarKeys = @(
        ".codex",
        ".codex/",
        ".claude",
        ".claude/",
        "CLAUDE.md",
        "antigravity_export",
        "antigravity_export/",
        ".agents",
        ".agents/",
        ".agents/*",
        ".agents/logs",
        ".agents/logs/",
        ".cartridge",
        ".cartridge/",
        "!.agents/memory",
        "!.agents/memory/",
        "!.agents/context",
        "!.agents/context/",
        "!.agents/project_skills",
        "!.agents/project_skills/"
    )
    return $key -in $similarKeys
}

function Test-AiRulesGitignoreStandardPattern {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    $trimmed = ($Line -replace "\\", "/").Trim()
    if ($trimmed.StartsWith("#")) { return $false }
    foreach ($pattern in Get-AiRulesGitignoreStandardPatterns) {
        $standard = ($pattern -replace "\\", "/").Trim()
        if ($trimmed -eq $standard) { return $true }
    }
    return $false
}

function Test-AiRulesGitignoreCurrentStandardComment {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    $trimmed = $Line.Trim()
    foreach ($comment in Get-AiRulesGitignoreStandardCommentLines) {
        if ($trimmed -eq $comment) { return $true }
    }
    if ($trimmed -eq "# [啟用][其他] 專案額外要求的 AI Rules 排除項目") { return $true }
    return $false
}

function Remove-AiRulesGitignoreStandardLines {
    param([string]$Content)

    $lines = @($Content -split "\r?\n")
    $newLines = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if (Test-AiRulesGitignoreStandardPattern -Line $line) { continue }
        if (Test-AiRulesGitignoreCurrentStandardComment -Line $line) { continue }
        $newLines.Add($line)
    }

    return ($newLines -join [Environment]::NewLine).TrimEnd()
}

function Remove-AiRulesGitignoreSimilarLines {
    param([string]$Content)

    $lines = @($Content -split "\r?\n")
    $newLines = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if (Test-AiRulesGitignoreSimilarPattern -Line $line) { continue }
        $newLines.Add($line)
    }

    return ($newLines -join [Environment]::NewLine).TrimEnd()
}

function Remove-AiRulesGitignoreRelatedLines {
    param([string]$Content)

    return Remove-AiRulesGitignoreSimilarLines -Content $Content
}

function Get-AiRulesGitignoreReport {
    param([string]$ProjectRoot)

    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    $content = ""
    if (Test-Path -LiteralPath $gitignorePath) {
        $content = Get-AiRulesTextFileContent -Path $gitignorePath
    }
    if ($null -eq $content) { $content = "" }
    $lines = @($content -split "\r?\n")
    $missing = @(Get-AiRulesGitignoreStandardPatterns | Where-Object {
        -not (Test-GitignoreExactPatternPresent -ExistingLines $lines -Pattern $_)
    })
    $similar = @($lines | Where-Object { Test-AiRulesGitignoreSimilarPattern -Line $_ })
    $broad = @($similar | Where-Object {
        $trimmed = $_.Trim()
        $isRootAnchored = $trimmed.StartsWith("/") -or $trimmed.StartsWith("!/")
        -not $isRootAnchored
    })

    return [PSCustomObject]@{
        Path            = $gitignorePath
        Exists          = (Test-Path -LiteralPath $gitignorePath)
        HasManagedBlock = $false
        MissingPatterns = $missing
        RelatedPatterns = $similar
        SimilarPatterns = $similar
        BroadPatterns   = $broad
    }
}

function Write-AiRulesGitignoreReport {
    param([object]$Report)

    Write-Host ""
    Write-Host "📊 版控排除規則狀態"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "檔案：$($Report.Path)"
    Write-Host "AI Rules 標準規則：$(if (@($Report.MissingPatterns).Count -eq 0) { '已完整' } else { '待補齊' })"
    Write-Host "缺少標準根目錄規則：$(@($Report.MissingPatterns).Count)"
    foreach ($pattern in @($Report.MissingPatterns)) {
        Write-Host "  [MISSING] $pattern" -ForegroundColor Yellow
    }
    Write-Host "偵測到需人工確認的相似規則：$(@($Report.SimilarPatterns).Count)"
    foreach ($pattern in @($Report.SimilarPatterns)) {
        Write-Host "  [SIMILAR] $pattern" -ForegroundColor Yellow
    }
    if (@($Report.BroadPatterns).Count -gt 0) {
        Write-Host "寬鬆規則：$(@($Report.BroadPatterns).Count)" -ForegroundColor Yellow
        foreach ($pattern in @($Report.BroadPatterns)) {
            Write-Host "  [BROAD] $pattern" -ForegroundColor Yellow
        }
    }
}

function Set-GitignoreEntries {
    param(
        [string]$ProjectRoot,
        [string[]]$Lines = @()
    )
    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    $newline = [Environment]::NewLine
    $managedBlock = @(Get-AiRulesGitignoreManagedBlock -AdditionalLines $Lines)

    if (-not (Test-Path $gitignorePath)) {
        Set-AiRulesTextFileContent -Path $gitignorePath -Content ""
        Write-Ok ".gitignore 已建立"
    }

    $content = Get-AiRulesTextFileContent -Path $gitignorePath
    if ($null -eq $content) { $content = "" }
    $cleanContent = Remove-AiRulesGitignoreStandardLines -Content $content
    $newContent = ""
    if ($cleanContent.Length -gt 0) {
        $newContent = $cleanContent + $newline + $newline
    }
    $newContent += ($managedBlock -join $newline) + $newline

    if ($newContent -eq $content) {
        Write-Step ".gitignore AI Rules 標準規則已是最新"
        return
    }

    Set-AiRulesTextFileContent -Path $gitignorePath -Content $newContent
    Write-Ok ".gitignore 已補入 AI Rules 標準根目錄排除規則"
}

function Invoke-AiRulesGitignoreMaintenance {
    param(
        [string]$ProjectRoot,
        [ValidateSet("Append", "CleanSimilar", "Overwrite")]
        [string]$Mode = "Append",
        [switch]$Apply
    )

    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    $report = Get-AiRulesGitignoreReport -ProjectRoot $ProjectRoot
    Write-AiRulesGitignoreReport -Report $report

    if (-not $Apply) {
        Write-Host ""
        Write-Host "Dry-run：未指定套用，不會修改 .gitignore。" -ForegroundColor Yellow
        Write-Host "標準流程只會補入帶繁中註解的 AI Rules 精準規則；舊版註解不處理，相似規則只列出，需由操作者確認後才刪除。"
        return $report
    }

    if ($Mode -in @("CleanSimilar", "Overwrite")) {
        $content = ""
        if (Test-Path -LiteralPath $gitignorePath) {
            $content = Get-AiRulesTextFileContent -Path $gitignorePath
        }
        if ($null -eq $content) { $content = "" }
        $cleanContent = Remove-AiRulesGitignoreSimilarLines -Content $content
        if ($cleanContent.Length -gt 0) {
            Set-AiRulesTextFileContent -Path $gitignorePath -Content ($cleanContent + [Environment]::NewLine)
        } else {
            Set-AiRulesTextFileContent -Path $gitignorePath -Content ""
        }
        Write-Ok "已移除清單列出的相似規則，準備補入標準規則。"
    }

    Set-GitignoreEntries -ProjectRoot $ProjectRoot
    $updatedReport = Get-AiRulesGitignoreReport -ProjectRoot $ProjectRoot
    Write-AiRulesGitignoreReport -Report $updatedReport
    return $updatedReport
}

Export-ModuleMember -Function *
