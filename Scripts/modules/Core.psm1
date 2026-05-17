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
# 單檔 SHA256 比對
# ══════════════════════════════════════════════════════════

function Compare-FrameworkFile {
    <#
    .SYNOPSIS
        比對來源與目標同一檔案是否有差異。
        回傳：NEW / SAME / CHANGED
    .NOTES
        先比修改時間（快），時間不同才算 SHA256（慢），最大化效能。
    #>
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$RelativePath
    )
    if (-Not (Test-Path $TargetPath)) {
        return [PSCustomObject]@{ Status = "NEW"; Path = $RelativePath }
    }
    $srcTime = (Get-Item $SourcePath).LastWriteTime
    $tgtTime = (Get-Item $TargetPath).LastWriteTime
    if ($srcTime -eq $tgtTime) {
        return [PSCustomObject]@{ Status = "SAME"; Path = $RelativePath }
    }
    $srcHash = (Get-FileHash $SourcePath -Algorithm SHA256).Hash
    $tgtHash = (Get-FileHash $TargetPath -Algorithm SHA256).Hash
    if ($srcHash -eq $tgtHash) {
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

    # 計算雜湊
    $srcHash = (Get-FileHash $SourcePath -Algorithm SHA256).Hash
    $tgtHash = (Get-FileHash $TargetPath -Algorithm SHA256).Hash

    # 若完全相同：跳過
    if ($srcHash -eq $tgtHash) {
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
    #>
    param(
        [string]$SourceRoot,
        [string]$TargetRoot,
        [string[]]$ScanDirs       = @("rules", "workflows"),
        [string[]]$ProtectedDirs  = @("memory", "project_skills"),
        [string[]]$ExcludeFiles   = @()
    )

    $results = @()

    # 正向掃描：來源 → 目標
    foreach ($dir in $ScanDirs) {
        $srcPath = Join-Path $SourceRoot $dir
        if (-Not (Test-Path $srcPath)) { continue }

        Get-ChildItem $srcPath -File -Recurse | ForEach-Object {
            if ($_.Name -in $ExcludeFiles) { return }
            $rel     = $_.FullName.Substring($SourceRoot.Length).TrimStart('\', '/').Replace("\", "/")
            $tgtFile = Join-Path $TargetRoot $rel
            $results += Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel
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
            Test-Path (Join-Path $_.FullName "SKILL.md")
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
        [string]$TargetRoot
    )
    $applied = 0
    foreach ($item in $Report) {
        if ($item.Status -notin @("NEW", "CHANGED")) { continue }
        $srcFile = Join-Path $SourceRoot $item.Path
        $tgtFile = Join-Path $TargetRoot $item.Path
        $tgtDir  = Split-Path $tgtFile -Parent
        if (-Not (Test-Path $tgtDir)) { New-Item -ItemType Directory $tgtDir -Force | Out-Null }
        Copy-Item $srcFile $tgtFile -Force
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
        將 memory/ 與 project_skills/ 備份到 TEMP 目錄。
        回傳 hashtable: @{ Memory = $tmpPath; Project = $tmpPath }
    #>
    param([string]$AgentsRoot)
    $backup = @{ Memory = $null; Project = $null }
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
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
    return $backup
}

function Restore-ProtectedDirs {
    <#
    .SYNOPSIS
        從 TEMP 備份還原 memory/ 與 project_skills/，並清除暫存。
    #>
    param(
        [hashtable]$Backup,
        [string]$AgentsRoot
    )
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
    if ($Backup.Memory -and (Test-Path $Backup.Memory)) {
        Copy-Item "$($Backup.Memory)\*" $memDir -Recurse -Force
        Remove-Item $Backup.Memory -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "共用記憶卡已完整保留並還原。"
    }
    if ($Backup.Project -and (Test-Path $Backup.Project)) {
        Copy-Item "$($Backup.Project)\*" $projDir -Recurse -Force
        Remove-Item $Backup.Project -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "衍生技能已完整保留並還原。"
    }
}

# ══════════════════════════════════════════════════════════
# 基礎設施初始化（memory/ project_skills/ _index.md）
# ══════════════════════════════════════════════════════════

function Initialize-AgentInfrastructure {
    param([string]$AgentsRoot)
    $memDir  = Join-Path $AgentsRoot "memory"
    $projDir = Join-Path $AgentsRoot "project_skills"
    if (-not (Test-Path $memDir)) {
        New-Item -ItemType Directory $memDir -Force | Out-Null
        Write-Ok ".agents\memory\ 共用記憶庫目錄已建立（D01）"
    }
    if (-not (Test-Path $projDir)) {
        New-Item -ItemType Directory $projDir -Force | Out-Null
        Write-Ok ".agents\project_skills\ 衍生技能目錄已建立"
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

    $count = 0
    $blocked = 0
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

function Set-GitignoreEntries {
    param(
        [string]$ProjectRoot,
        [string[]]$Lines
    )
    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    if (-not (Test-Path $gitignorePath)) {
        Set-Content $gitignorePath "# Antigravity 框架自動排除項目" -Encoding UTF8
        Write-Ok ".gitignore 已建立"
    }
    $content = Get-Content $gitignorePath -Raw
    foreach ($line in $Lines) {
        if ($content -notmatch [regex]::Escape($line)) {
            Add-Content $gitignorePath "`n$line"
            Write-Ok ".gitignore 已追加排除: $line"
        }
    }
}

Export-ModuleMember -Function *
