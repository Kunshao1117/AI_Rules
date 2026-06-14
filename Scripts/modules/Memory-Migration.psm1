#Requires -Version 5.1
<#
.SYNOPSIS
    Memory card main-file naming migration helper.
.DESCRIPTION
    Scans .agents/memory for active memory cards that still use SKILL.md,
    detects MEMORY.md conflicts, and can rename legacy active main files only
    when explicitly run with -Apply. Archive volumes are never renamed.
#>

function Get-MemoryMigrationRelativePath {
    param(
        [string]$Root,
        [string]$Path
    )

    $rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
    $pathFull = [System.IO.Path]::GetFullPath($Path)
    if ($pathFull.StartsWith($rootFull + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or
        $pathFull.StartsWith($rootFull + [System.IO.Path]::AltDirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $pathFull.Substring($rootFull.Length).TrimStart('\', '/').Replace('\', '/')
    }
    return $pathFull
}

function Get-MemoryMainFileReferenceCount {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return 0 }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $pattern = '(?i)(\.agents[\\/]+memory[^\r\n`]*[\\/]+SKILL\.md|memory[\\/][^\r\n`]*[\\/]+SKILL\.md)'
    return ([regex]::Matches($content, $pattern)).Count
}

function Get-MemoryMainFileMigrationPlan {
    <#
    .SYNOPSIS
        Builds a non-mutating inventory for memory card main-file migration.
    #>
    param(
        [string]$TargetRoot = "."
    )

    $resolvedTargetRoot = (Resolve-Path -LiteralPath $TargetRoot).Path
    $memoryRoot = Join-Path $resolvedTargetRoot ".agents\memory"
    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+08:00")

    if (-not (Test-Path -LiteralPath $memoryRoot -PathType Container)) {
        return [PSCustomObject]@{
            TargetRoot        = $resolvedTargetRoot
            MemoryRoot        = $memoryRoot
            Exists            = $false
            GeneratedAt       = $timestamp
            Items             = @()
            LegacyCards       = @()
            CurrentCards      = @()
            ConflictCards     = @()
            ArchiveVolumes    = @()
            ReferenceWarnings = @()
        }
    }

    $items = New-Object System.Collections.Generic.List[object]
    $dirs = New-Object System.Collections.Generic.List[object]
    $dirs.Add((Get-Item -LiteralPath $memoryRoot))
    Get-ChildItem -LiteralPath $memoryRoot -Directory -Recurse -ErrorAction SilentlyContinue |
        Sort-Object FullName |
        ForEach-Object { $dirs.Add($_) }

    foreach ($dir in $dirs) {
        $legacyPath = Join-Path $dir.FullName "SKILL.md"
        $currentPath = Join-Path $dir.FullName "MEMORY.md"
        $hasLegacy = Test-Path -LiteralPath $legacyPath -PathType Leaf
        $hasCurrent = Test-Path -LiteralPath $currentPath -PathType Leaf
        if (-not $hasLegacy -and -not $hasCurrent) { continue }

        $status = "Current"
        if ($hasLegacy -and $hasCurrent) {
            $status = "Conflict"
        } elseif ($hasLegacy) {
            $status = "Legacy"
        }

        $mainPath = if ($hasCurrent) { $currentPath } else { $legacyPath }
        $items.Add([PSCustomObject]@{
            Status              = $status
            Directory           = $dir.FullName
            RelativeDirectory  = Get-MemoryMigrationRelativePath -Root $resolvedTargetRoot -Path $dir.FullName
            LegacyPath          = if ($hasLegacy) { $legacyPath } else { "" }
            CurrentPath         = if ($hasCurrent) { $currentPath } else { "" }
            RelativeLegacyPath  = if ($hasLegacy) { Get-MemoryMigrationRelativePath -Root $resolvedTargetRoot -Path $legacyPath } else { "" }
            RelativeCurrentPath = if ($hasCurrent) { Get-MemoryMigrationRelativePath -Root $resolvedTargetRoot -Path $currentPath } else { "" }
            ReferenceCount      = Get-MemoryMainFileReferenceCount -Path $mainPath
        })
    }

    $archiveVolumes = @(Get-ChildItem -LiteralPath $memoryRoot -Filter "archive-*.md" -File -Recurse -ErrorAction SilentlyContinue |
        Sort-Object FullName |
        ForEach-Object {
            [PSCustomObject]@{
                Path         = $_.FullName
                RelativePath = Get-MemoryMigrationRelativePath -Root $resolvedTargetRoot -Path $_.FullName
            }
        })

    $allItems = @($items.ToArray())
    return [PSCustomObject]@{
        TargetRoot        = $resolvedTargetRoot
        MemoryRoot        = $memoryRoot
        Exists            = $true
        GeneratedAt       = $timestamp
        Items             = $allItems
        LegacyCards       = @($allItems | Where-Object { $_.Status -eq "Legacy" })
        CurrentCards      = @($allItems | Where-Object { $_.Status -eq "Current" })
        ConflictCards     = @($allItems | Where-Object { $_.Status -eq "Conflict" })
        ArchiveVolumes    = @($archiveVolumes)
        ReferenceWarnings = @($allItems | Where-Object { $_.ReferenceCount -gt 0 })
    }
}

function Write-MemoryMainFileMigrationReport {
    param(
        [object]$Plan,
        [bool]$Apply
    )

    Write-Host ""
    Write-Host "📊 記憶主檔命名遷移"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "目標專案：$($Plan.TargetRoot)"
    Write-Host "記憶庫：$($Plan.MemoryRoot)"
    Write-Host "模式：$(if ($Apply) { '套用更名' } else { '乾跑盤點' })"
    Write-Host "外部記憶引擎：未驗證，本工具不修改 cartridge-system"

    if (-not $Plan.Exists) {
        Write-Host "未找到 .agents/memory/，無需遷移。" -ForegroundColor Yellow
        return
    }

    Write-Host "舊主檔（SKILL.md）：$(@($Plan.LegacyCards).Count)"
    Write-Host "新主檔（MEMORY.md）：$(@($Plan.CurrentCards).Count)"
    Write-Host "雙主檔衝突：$(@($Plan.ConflictCards).Count)"
    Write-Host "歸檔卷略過：$(@($Plan.ArchiveVolumes).Count)"
    Write-Host "文內舊路徑引用：$(@($Plan.ReferenceWarnings).Count)"

    foreach ($item in @($Plan.ConflictCards)) {
        Write-Host ("  [衝突] {0} — SKILL.md 與 MEMORY.md 同時存在" -f $item.RelativeDirectory) -ForegroundColor Red
    }
    foreach ($item in @($Plan.LegacyCards) | Select-Object -First 80) {
        Write-Host ("  [舊主檔] {0} -> {1}" -f $item.RelativeLegacyPath, ($item.RelativeLegacyPath -replace 'SKILL\.md$', 'MEMORY.md')) -ForegroundColor Yellow
    }
    foreach ($item in @($Plan.ReferenceWarnings) | Select-Object -First 40) {
        Write-Host ("  [舊引用] {0} 含 {1} 個舊主檔路徑引用" -f $item.RelativeDirectory, $item.ReferenceCount) -ForegroundColor Yellow
    }

    if (-not $Apply) {
        Write-Host ""
        Write-Host "Dry-run：未指定 -Apply，不會更名任何記憶卡。" -ForegroundColor Yellow
        Write-Host "注意：本階段只回報舊路徑引用，不批次修正文內引用。"
    }
}

function Invoke-MemoryMainFileMigration {
    <#
    .SYNOPSIS
        Scans or applies memory card main-file rename from SKILL.md to MEMORY.md.
    .PARAMETER Apply
        Rename legacy active main files. Conflicts stop the run.
    .PARAMETER WhatIf
        Forces dry-run reporting even when Apply is passed.
    #>
    param(
        [string]$TargetRoot = ".",
        [switch]$Apply,
        [switch]$WhatIf
    )

    $effectiveApply = [bool]($Apply -and -not $WhatIf)
    $plan = Get-MemoryMainFileMigrationPlan -TargetRoot $TargetRoot
    Write-MemoryMainFileMigrationReport -Plan $plan -Apply:$effectiveApply

    if (-not $plan.Exists) { return $plan }
    if (-not $effectiveApply) { return $plan }

    if (@($plan.ConflictCards).Count -gt 0) {
        throw "記憶主檔遷移已停止：同一資料夾內存在 SKILL.md 與 MEMORY.md，需先人工決定保留來源。"
    }

    $renamed = New-Object System.Collections.Generic.List[object]
    foreach ($item in @($plan.LegacyCards)) {
        $destination = Join-Path $item.Directory "MEMORY.md"
        Move-Item -LiteralPath $item.LegacyPath -Destination $destination -ErrorAction Stop
        $renamed.Add([PSCustomObject]@{
            From = $item.RelativeLegacyPath
            To   = Get-MemoryMigrationRelativePath -Root $plan.TargetRoot -Path $destination
        })
        Write-Host ("  [已更名] {0} -> {1}" -f $item.RelativeLegacyPath, (Get-MemoryMigrationRelativePath -Root $plan.TargetRoot -Path $destination)) -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "更名完成：$($renamed.Count) 張作用中記憶卡主檔。"
    Write-Host "注意：歸檔卷未更名；文內舊路徑引用未自動修正。"

    $postPlan = Get-MemoryMainFileMigrationPlan -TargetRoot $TargetRoot
    Add-Member -InputObject $postPlan -NotePropertyName Renamed -NotePropertyValue @($renamed.ToArray()) -Force
    return $postPlan
}

Export-ModuleMember -Function Get-MemoryMainFileMigrationPlan, Invoke-MemoryMainFileMigration
