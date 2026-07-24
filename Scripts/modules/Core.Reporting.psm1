# Console and operator-facing reporting functions.

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

function Write-UpgradeReport {
    param(
        [array]$Report,
        [System.Collections.IDictionary]$CategoryMap,
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
