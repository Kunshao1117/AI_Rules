#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 整合審計模組
.DESCRIPTION
    整合原本分散在 AG/Claude 兩個平台的 6 支審計腳本：
    - Invoke-DocScan × 2 → Invoke-DocScan
    - Invoke-HealthAudit × 2 → Invoke-HealthAudit
    - Measure-SkillQuality × 2 → Measure-SkillQuality
    支援指定平台（Antigravity / Claude / Codex / All）執行。
#>

using module ".\Core.psm1"

# ══════════════════════════════════════════════════════════
# Invoke-DocScan — 倉庫狀態掃描
# ══════════════════════════════════════════════════════════

function Invoke-DocScan {
    <#
    .SYNOPSIS
        掃描專案文件健康狀態：殘留追蹤偵測 + .md 文件列表。
    .PARAMETER ProjectRoot
        專案根目錄
    .PARAMETER AgentsDir
        .agents/ 目錄路徑
    #>
    param(
        [string]$ProjectRoot = ".",
        [string]$AgentsDir   = ".agents"
    )

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    $ProjectRoot = (Resolve-Path $ProjectRoot).Path
    $logsDir     = Join-Path $AgentsDir "logs"
    if (-not (Test-Path $logsDir)) { New-Item -ItemType Directory $logsDir | Out-Null }

    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
    $report = "# 倉庫狀態報告`nGenerated: $timestamp`nProjectRoot: $ProjectRoot`n`n"

    # 1. 殘留追蹤偵測
    $staleTracked = @()
    try {
        $gitResult = git -C $ProjectRoot ls-files -ic --exclude-standard 2>$null
        if ($gitResult) { $staleTracked = @($gitResult) }
    } catch { }

    if ($staleTracked.Count -gt 0) {
        $report += "## 殘留追蹤（已被 .gitignore 排除但仍在倉庫中）`n`n"
        foreach ($f in $staleTracked) { $report += "- ``$f```n" }
        $report += "`n> 建議執行 ``git rm --cached`` 移除追蹤。`n`n"
    } else {
        $report += "## ✅ 倉庫衛生`n`n無殘留追蹤檔案。`n`n"
    }

    # 2. 文件掃描
    $ExcludeDirs  = @('.agents', '.gemini', '.git', 'node_modules', 'dist', 'build', '.next',
                      '__pycache__', 'venv', '.venv', 'vendor', 'coverage', '.turbo', '.vercel',
                      '.codex', '.claude')
    $ExcludeFiles = @('CHANGELOG.md')

    $docs = Get-ChildItem $ProjectRoot -Filter '*.md' -Recurse -ErrorAction SilentlyContinue |
        Where-Object {
            $rel = $_.FullName.Substring($ProjectRoot.Length).TrimStart('\', '/')
            $excluded = $false
            foreach ($dir in $ExcludeDirs) {
                $eDir = [regex]::Escape($dir)
                if ($rel -match "(^|[\/\\])$eDir([\/\\]|$)") { $excluded = $true; break }
            }
            if ($_.Name -in $ExcludeFiles) { $excluded = $true }
            -not $excluded
        }

    if ($docs.Count -eq 0) {
        $report += "## 📄 專案文件`n`n無專案文件。`n"
    } else {
        $report += "## 📄 專案文件 (共 $($docs.Count) 個)`n`n"
        foreach ($doc in $docs) {
            $rel     = $doc.FullName.Substring($ProjectRoot.Length).TrimStart('\', '/')
            $lastMod = $doc.LastWriteTime.ToString("yyyy-MM-dd")
            $report += "- ``$rel`` (最後修改: $lastMod)`n"
        }
    }

    $outputFile = Join-Path $logsDir "doc_scan.md"
    Set-Content $outputFile $report -Encoding UTF8
    Write-Host "✅ 倉庫掃描完成：$($staleTracked.Count) 個殘留追蹤 / $($docs.Count) 個文件 → $outputFile"
}

# ══════════════════════════════════════════════════════════
# Invoke-HealthAudit — 工具層健檢掃描
# ══════════════════════════════════════════════════════════

function Invoke-HealthAudit {
    <#
    .SYNOPSIS
        執行安全憑證掃描與效能掃描健檢，輸出至 logs/ 目錄。
    .PARAMETER ProjectRoot
        專案根目錄
    .PARAMETER AgentsDir
        .agents/ 目錄路徑
    .PARAMETER Module
        要執行的模組：security / performance / all
    #>
    param(
        [string]$ProjectRoot = ".",
        [string]$AgentsDir   = ".agents",
        [ValidateSet("security", "performance", "all")]
        [string]$Module      = "all"
    )

    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
    $logsDir   = Join-Path $AgentsDir "logs"
    if (-not (Test-Path $logsDir)) { New-Item -ItemType Directory $logsDir | Out-Null }

    function Write-ReportHeader {
        param([string]$Title, [string]$OutputFile)
        Set-Content $OutputFile "# $Title`nGenerated: $timestamp`nProjectRoot: $ProjectRoot`n`n" -Encoding UTF8
    }

    function Add-ReportSection {
        param([string]$Content, [string]$OutputFile)
        Add-Content $OutputFile $Content -Encoding UTF8
    }

    function Invoke-SecurityModule {
        $outputFile = Join-Path $logsDir "audit_security_scan.md"
        Write-ReportHeader -Title "健檢報告：工具層安全掃描" -OutputFile $outputFile

        Push-Location $ProjectRoot
        try {
            Add-ReportSection "## 硬編碼憑證掃描" $outputFile
            $patterns = @(
                'sk-[a-zA-Z0-9]{20,}',
                'AIza[a-zA-Z0-9_-]{35}',
                'ghp_[a-zA-Z0-9]{36}',
                'mongodb\+srv://.+:.+@',
                'postgresql://.+:.+@',
                'secret.*=.*["\x27][a-zA-Z0-9+/]{20,}'
            )
            $hardcodeFound = $false
            foreach ($pattern in $patterns) {
                if (Test-Path "src") {
                    $found = Select-String -Path "src/**/*" -Pattern $pattern -Recurse 2>$null
                    if ($found) {
                        $hardcodeFound = $true
                        Add-ReportSection "疑似硬編碼憑證（請人工確認）：" $outputFile
                        $found | ForEach-Object { Add-ReportSection "  - $($_.Filename):$($_.LineNumber)" $outputFile }
                    }
                }
            }
            if (-not $hardcodeFound) { Add-ReportSection "✅ 未偵測到明顯硬編碼憑證模式" $outputFile }

            Add-ReportSection "`n## 環境變數一致性" $outputFile
            $envExample = Join-Path $ProjectRoot ".env.example"
            if (Test-Path $envExample) {
                $envKeys = (Get-Content $envExample) |
                    Where-Object { $_ -match "^[A-Z_]+=?" } |
                    ForEach-Object { ($_ -split "=")[0].Trim() }
                Add-ReportSection ".env.example 定義變數：$($envKeys.Count) 個" $outputFile
                foreach ($key in $envKeys) {
                    if (Test-Path "src") {
                        $usage = Select-String -Path "src/**/*" -Pattern "process\.env\.$key" -Recurse 2>$null
                        if (-not $usage) { Add-ReportSection "  🟡 $key — 已定義但未在 src/ 中使用" $outputFile }
                    }
                }
            } else { Add-ReportSection "未找到 .env.example 檔案" $outputFile }
        } finally { Pop-Location }
        Write-Host "✅ security 掃描完成 → $outputFile"
    }

    function Invoke-PerformanceModule {
        $outputFile = Join-Path $logsDir "audit_perf.md"
        Write-ReportHeader -Title "健檢報告：效能掃描" -OutputFile $outputFile

        Push-Location $ProjectRoot
        try {
            $hasFrontend = (Test-Path "src/app") -or (Test-Path "src/pages") -or
                           (Test-Path "app") -or (Test-Path "pages")
            if (-not $hasFrontend) {
                Add-ReportSection "本專案無前端頁面，效能掃描跳過。" $outputFile
                Write-Host "⏭️ 無前端頁面，效能掃描跳過"
                return
            }
            Add-ReportSection "## Lighthouse 效能掃描" $outputFile
            Add-ReportSection "確認開發伺服器已在 http://localhost:3000 啟動後執行：" $outputFile
            Add-ReportSection "``````powershell" $outputFile
            Add-ReportSection "npx lighthouse http://localhost:3000 --output=json --output-path=$logsDir/lighthouse-home.json --chrome-flags=`"--headless`"" $outputFile
            Add-ReportSection "``````" $outputFile
        } finally { Pop-Location }
        Write-Host "✅ performance 模組完成 → $outputFile"
    }

    switch ($Module) {
        "security"    { Invoke-SecurityModule }
        "performance" { Invoke-PerformanceModule }
        "all" {
            Invoke-SecurityModule
            Invoke-PerformanceModule
            Write-Host "`n✅ 所有健檢掃描模組完成，報告位於：$logsDir"
        }
    }
}

# ══════════════════════════════════════════════════════════
# Measure-SkillQuality — 技能品質掃描
# ══════════════════════════════════════════════════════════

function Measure-SkillQuality {
    <#
    .SYNOPSIS
        掃描所有 SKILL.md 並產出結構化品質報告。
    .PARAMETER SkillsRoot
        技能根目錄。若未指定，使用 Shared/skills/
    .PARAMETER Target
        指定單一技能目錄（含 SKILL.md）
    #>
    param(
        [string]$SkillsRoot,
        [string]$Target
    )

    if ($PSVersionTable.PSVersion.Major -lt 7) {
        $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
        if ($pwshCmd) {
            $moduleDir = $PSScriptRoot   # 在進入 scriptblock 前捕捉，避免子程序內 $PSScriptRoot 為空
            & pwsh -Command {
                param($sr, $tg, $md)
                Import-Module (Join-Path $md "Audit.psm1") -Force
                Measure-SkillQuality -SkillsRoot $sr -Target $tg
            } -Args $SkillsRoot, $Target, $moduleDir
            return
        }
    }

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    if (-not $SkillsRoot) {
        # 預設使用 Shared/skills/
        $SkillsRoot = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) "Shared\skills"
    }
    if (Test-Path $SkillsRoot) { $SkillsRoot = (Resolve-Path $SkillsRoot).Path }

    $ForbiddenPatterns = @(
        'This skill teaches', 'This skill enables', 'This skill provides',
        'This skill extends', 'this is because', 'the purpose is', 'the reason is'
    )
    $RequiredFrontmatter = @('name', 'description', 'metadata')
    $RequiredMetadata    = @('author', 'version', 'origin')
    $GatePattern         = '\[(\w+\s+)?GATE\]'

    function Measure-SingleSkill {
        param([string]$SkillDir)
        $skillFile = Join-Path $SkillDir 'SKILL.md'
        if (-not (Test-Path $skillFile)) { return $null }

        $content   = Get-Content $skillFile -Raw -Encoding UTF8
        $lines     = Get-Content $skillFile -Encoding UTF8
        $skillName = Split-Path $SkillDir -Leaf
        $refsDir   = Join-Path $SkillDir 'references'
        $hasRefs   = Test-Path $refsDir

        $lineCount    = $lines.Count
        $lineStatus   = if ($lineCount -lt 500) { '🟢' } else { '🔴' }
        $tokenEst     = [math]::Ceiling($content.Length / 3)
        $tokenStatus  = if ($tokenEst -lt 5000) { '🟢' } else { '🔴' }

        $foundForbidden = @()
        $contentLines = $content -split "`n"
        foreach ($pattern in $ForbiddenPatterns) {
            $esc = [regex]::Escape($pattern)
            foreach ($line in $contentLines) {
                if ($line -match 'FORBIDDEN:|禁用模式|❌') { continue }
                if ($line -match $esc) { $foundForbidden += $pattern; break }
            }
        }
        $forbiddenStatus = if ($foundForbidden.Count -eq 0) { '🟢' } else { '🔴' }

        $frontmatterOk = $true; $missingFields = @()
        foreach ($f in $RequiredFrontmatter) {
            if ($content -notmatch "(?m)^${f}:") { $frontmatterOk = $false; $missingFields += $f }
        }
        foreach ($f in $RequiredMetadata) {
            if ($content -notmatch "(?m)^\s+${f}:") { $frontmatterOk = $false; $missingFields += "metadata.$f" }
        }
        $frontmatterStatus = if ($frontmatterOk) { '🟢' } else { '🔴' }

        $nameOk  = ($skillName -match '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$') -and ($skillName.Length -le 64)
        $fmMatch = [regex]::Match($content, '(?ms)\A---\s*\n(.*?)\n---')
        $descLen = 0
        if ($fmMatch.Success) {
            $fm = $fmMatch.Groups[1].Value
            $singleMatch = [regex]::Match($fm, '(?m)^description:\s*(.+)$')
            if ($singleMatch.Success) { $descLen = $singleMatch.Groups[1].Value.Trim().Length }
        }
        $compatStatus = if ($nameOk -and $descLen -lt 1024) { '🟢' } else { '🔴' }

        $l3Status = '—'
        if ($hasRefs) {
            $hasInlineRef = $content -match 'Read references/' -or $content -match 'references/\S+\.md'
            $l3Status = if ($hasInlineRef) { '🟢' } else { '🟡' }
        }

        $styleStatus = '—'; $styleValue = ''
        if ($fmMatch.Success) {
            $fmContent = $fmMatch.Groups[1].Value
            $fmStyleMatch = [regex]::Match($fmContent, '(?m)^\s+style:\s*(\S+)')
            if ($fmStyleMatch.Success) { $styleValue = $fmStyleMatch.Groups[1].Value.Trim() }
        }
        $hasGate = $content -match $GatePattern
        if ($styleValue) {
            switch ($styleValue) {
                'imperative' { $styleStatus = if ($hasGate) { '🟢' } else { '🔴' } }
                'guided'     { $styleStatus = if (-not $hasGate) { '🟢' } else { '🔴' } }
                'hybrid'     { $styleStatus = if ($hasGate) { '🟢' } else { '🟡' } }
                default      { $styleStatus = '🔴' }
            }
        }

        return [PSCustomObject]@{
            Name              = $skillName
            Lines             = $lineCount
            LineStatus        = $lineStatus
            Tokens            = $tokenEst
            TokenStatus       = $tokenStatus
            ForbiddenWords    = $foundForbidden
            ForbiddenStatus   = $forbiddenStatus
            MissingFields     = $missingFields
            FrontmatterStatus = $frontmatterStatus
            CompatStatus      = $compatStatus
            L3Status          = $l3Status
            StyleValue        = $styleValue
            StyleStatus       = $styleStatus
            OverallStatus     = if (
                $lineStatus -eq '🟢' -and $tokenStatus -eq '🟢' -and $forbiddenStatus -eq '🟢' -and
                $frontmatterStatus -eq '🟢' -and $compatStatus -eq '🟢' -and
                $l3Status -ne '🟡' -and $styleStatus -ne '🔴'
            ) { '🟢' } elseif (
                $lineStatus -eq '🔴' -or $tokenStatus -eq '🔴' -or $forbiddenStatus -eq '🔴' -or
                $frontmatterStatus -eq '🔴' -or $compatStatus -eq '🔴' -or $styleStatus -eq '🔴'
            ) { '🔴' } else { '🟡' }
        }
    }

    $results = @()
    if ($Target) {
        if (-not (Test-Path $Target)) { Write-Fail "指定的技能目錄不存在：$Target"; return @() }
        $result = Measure-SingleSkill -SkillDir (Resolve-Path $Target).Path
        if ($result) { $results += $result }
    } else {
        $scanDirs = @($SkillsRoot)
        foreach ($scanRoot in $scanDirs) {
            Get-ChildItem $scanRoot -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -notmatch '^_' } |
                ForEach-Object {
                    $r = Measure-SingleSkill -SkillDir $_.FullName
                    if ($r) { $results += $r }
                }
        }
    }

    $ts        = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss+08:00'
    $passCount = ($results | Where-Object { $_.OverallStatus -eq '🟢' }).Count
    $warnCount = ($results | Where-Object { $_.OverallStatus -eq '🟡' }).Count
    $failCount = ($results | Where-Object { $_.OverallStatus -eq '🔴' }).Count

    Write-Host ""
    Write-Host "📊 技能品質掃描報告 — $ts"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "掃描技能數：$($results.Count)"
    Write-Host "🟢 合格：$passCount  🟡 警告：$warnCount  🔴 不合格：$failCount"
    Write-Host ""

    $fmt = "{0,-30} {1,6} {2,3} {3,7} {4,3} {5,4} {6,4} {7,4} {8,3} {9,8} {10,3} {11,4}"
    Write-Host ($fmt -f '技能名稱', '行數', ' ', 'Token', ' ', '禁詞', 'FM', 'IO', 'L3', '風格', ' ', '總評')
    Write-Host ('-' * 90)

    foreach ($r in $results | Sort-Object Name) {
        $styleDisplay = if ($r.StyleValue) { $r.StyleValue.Substring(0, [math]::Min(8, $r.StyleValue.Length)) } else { '—' }
        Write-Host ($fmt -f $r.Name, $r.Lines, $r.LineStatus, $r.Tokens, $r.TokenStatus,
            $r.ForbiddenStatus, $r.FrontmatterStatus, $r.CompatStatus, $r.L3Status,
            $styleDisplay, $r.StyleStatus, $r.OverallStatus)
        if ($r.ForbiddenWords.Count -gt 0) {
            Write-Host "  ⚠ 禁用詞：$($r.ForbiddenWords -join ', ')" -ForegroundColor Yellow
        }
        if ($r.MissingFields.Count -gt 0) {
            Write-Host "  ⚠ 缺少欄位：$($r.MissingFields -join ', ')" -ForegroundColor Yellow
        }
    }
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    return $results
}

Export-ModuleMember -Function Invoke-DocScan, Invoke-HealthAudit, Measure-SkillQuality
