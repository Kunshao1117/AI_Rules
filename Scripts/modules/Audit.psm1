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
    $RequiredMetadata    = @('author', 'version', 'origin', 'kind')
    $RequiredWorkflowMetadata = @(
        'platforms',
        'lifecycle_phase',
        'role',
        'memory_awareness',
        'tool_scope',
        'human_gate',
        'automation_safe'
    )
    $GatePattern         = '\[(\w+\s+)?GATE\]'

    function Get-FrontmatterFieldValue {
        param(
            [string]$Frontmatter,
            [string]$FieldName
        )

        if (-not $Frontmatter) { return '' }

        $lines = $Frontmatter -split "\r?\n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            $match = [regex]::Match($line, "^(?<field>$([regex]::Escape($FieldName))):\s*(?<value>.*)$")
            if (-not $match.Success) { continue }

            $value = $match.Groups['value'].Value.Trim()
            if ($value -match '^[>|]') {
                $parts = New-Object System.Collections.Generic.List[string]
                for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                    $next = $lines[$j]
                    if ($next -match '^[A-Za-z0-9_-]+:\s*') { break }
                    if ($next.Trim().Length -gt 0) { $parts.Add($next.Trim()) }
                }
                return (($parts.ToArray()) -join ' ').Trim()
            }

            return $value.Trim('"').Trim("'")
        }

        return ''
    }

    function Test-SkillTriggerQuality {
        param(
            [string]$SkillName,
            [string]$Kind,
            [string]$Description,
            [string]$Content
        )

        $issues = New-Object System.Collections.Generic.List[string]
        $desc = if ($Description) { $Description.Trim() } else { '' }

        if ([string]::IsNullOrWhiteSpace($desc)) {
            $issues.Add('description 空白或無法解析')
        } elseif ($desc.Length -lt 40) {
            $issues.Add('description 過短，可能不足以觸發自動載入')
        }

        if ($Kind -eq 'operational') {
            if ($desc -notmatch '[\u4e00-\u9fff]') {
                $issues.Add('operational skill description 缺少繁中觸發詞')
            }
            if ($desc -notmatch '[A-Za-z]') {
                $issues.Add('operational skill description 缺少英文觸發詞')
            }
            if ($desc -notmatch '(?i)DO NOT use when|不要|不適用|非') {
                $issues.Add('operational skill description 缺少負向邊界')
            }
        }

        $bodyHasUseWhen = $Content -match '(?mi)^\s*(Use when|When to load this skill|## .*Trigger|## .*觸發|觸發條件)'
        $descHasUseWhen = $desc -match '(?i)Use when|DO NOT use when|適用|需要|觸發|when'
        if ($bodyHasUseWhen -and (-not $descHasUseWhen)) {
            $issues.Add('觸發條件只出現在正文，未放入 frontmatter description')
        }

        $releaseSignal = ($SkillName -match '(?i)plugin|vsix') -or
            ($Content -match '(?i)VSIX|update reminder|插件發布|插件.*Release|extension.*VSIX|自動更新|更新提醒')
        if ($releaseSignal) {
            $requiredGroups = @(
                @('plugin', 'extension', '插件', '延伸模組'),
                @('VSIX'),
                @('Release', '發布'),
                @('version', '版本'),
                @('tag'),
                @('update reminder', '自動更新', '更新提醒')
            )
            foreach ($group in $requiredGroups) {
                $hasTerm = $false
                foreach ($term in $group) {
                    if ($desc -match [regex]::Escape($term)) { $hasTerm = $true; break }
                }
                if (-not $hasTerm) {
                    $issues.Add("插件發布技能 description 缺少觸發詞：$($group[0])")
                }
            }
        }

        $workflowMarkers = 'Director-Readable Output Contract|Command Template|#\s*\[WORKFLOW:|#\s*\[SKILL:\s*/|lifecycle_phase:\s*(build|fix|commit|blueprint|audit|skill-forge)'
        if (($Kind -eq 'operational') -and ($Content -match $workflowMarkers) -and ($SkillName -notmatch '^skill-factory$')) {
            $issues.Add('operational skill 內容疑似混入 workflow 入口職責')
        }

        return [PSCustomObject]@{
            Status = if ($issues.Count -eq 0) { '🟢' } else { '🟡' }
            Issues = @($issues.ToArray())
        }
    }

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
        $tokenContent = $content -replace "`r`n", "`n"
        $tokenEst     = [math]::Ceiling($tokenContent.Length / 3)
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

        $fmMatch = [regex]::Match($content, '(?ms)\A---\s*\n(.*?)\n---')
        $fmContent = if ($fmMatch.Success) { $fmMatch.Groups[1].Value } else { '' }
        $metadataKind = 'operational'
        $kindMatch = [regex]::Match($fmContent, '(?m)^\s+kind:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        if ($kindMatch.Success) { $metadataKind = $kindMatch.Groups[1].Value.Trim() }
        $isWorkflow = ($metadataKind -eq 'workflow') -or ($SkillDir -match '[\\/]workflow-skills[\\/]') -or ($SkillDir -match '[\\/]commands[\\/]')

        $frontmatterOk = $true; $missingFields = @()
        foreach ($f in $RequiredFrontmatter) {
            if ($content -notmatch "(?m)^${f}:") { $frontmatterOk = $false; $missingFields += $f }
        }
        foreach ($f in $RequiredMetadata) {
            if ($content -notmatch "(?m)^\s+${f}:") { $frontmatterOk = $false; $missingFields += "metadata.$f" }
        }
        if ($isWorkflow) {
            foreach ($f in $RequiredWorkflowMetadata) {
                if ($content -notmatch "(?m)^\s+${f}:") {
                    $frontmatterOk = $false
                    $missingFields += "metadata.$f"
                }
            }
        }
        $frontmatterStatus = if ($frontmatterOk) { '🟢' } else { '🔴' }

        $nameOk = if ($isWorkflow) {
            ($skillName.Length -le 96) -and ($skillName -notmatch '[\\/]') -and ($skillName.Trim().Length -gt 0)
        } else {
            ($skillName -match '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$') -and ($skillName.Length -le 64)
        }
        $description = ''
        $descLen = 0
        if ($fmMatch.Success) {
            $fm = $fmMatch.Groups[1].Value
            $description = Get-FrontmatterFieldValue -Frontmatter $fm -FieldName 'description'
            $descLen = $description.Length
        }
        $compatStatus = if ($nameOk -and $descLen -lt 1024) { '🟢' } else { '🔴' }
        $triggerQuality = Test-SkillTriggerQuality -SkillName $skillName -Kind $metadataKind -Description $description -Content $content

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
            TriggerStatus     = $triggerQuality.Status
            TriggerIssues     = $triggerQuality.Issues
            L3Status          = $l3Status
            StyleValue        = $styleValue
            StyleStatus       = $styleStatus
            Kind              = if ($isWorkflow) { 'workflow' } else { 'operational' }
            OverallStatus     = if (
                $lineStatus -eq '🟢' -and $tokenStatus -eq '🟢' -and $forbiddenStatus -eq '🟢' -and
                $frontmatterStatus -eq '🟢' -and $compatStatus -eq '🟢' -and
                $triggerQuality.Status -eq '🟢' -and $l3Status -ne '🟡' -and $styleStatus -ne '🔴'
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

    $fmt = "{0,-30} {1,6} {2,3} {3,7} {4,3} {5,4} {6,4} {7,4} {8,4} {9,3} {10,8} {11,3} {12,4}"
    Write-Host ($fmt -f '技能名稱', '行數', ' ', 'Token', ' ', '禁詞', 'FM', 'IO', '觸發', 'L3', '風格', ' ', '總評')
    Write-Host ('-' * 98)

    foreach ($r in $results | Sort-Object Name) {
        $styleDisplay = if ($r.StyleValue) { $r.StyleValue.Substring(0, [math]::Min(8, $r.StyleValue.Length)) } else { '—' }
        Write-Host ($fmt -f $r.Name, $r.Lines, $r.LineStatus, $r.Tokens, $r.TokenStatus,
            $r.ForbiddenStatus, $r.FrontmatterStatus, $r.CompatStatus, $r.TriggerStatus, $r.L3Status,
            $styleDisplay, $r.StyleStatus, $r.OverallStatus)
        if ($r.ForbiddenWords.Count -gt 0) {
            Write-Host "  ⚠ 禁用詞：$($r.ForbiddenWords -join ', ')" -ForegroundColor Yellow
        }
        if ($r.MissingFields.Count -gt 0) {
            Write-Host "  ⚠ 缺少欄位：$($r.MissingFields -join ', ')" -ForegroundColor Yellow
        }
        if ($r.TriggerIssues.Count -gt 0) {
            Write-Host "  ⚠ 觸發品質：$($r.TriggerIssues -join '；')" -ForegroundColor Yellow
        }
    }
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    return $results
}

# ══════════════════════════════════════════════════════════
# Invoke-PlatformGovernanceAudit — 平台代理治理層巡檢
# ══════════════════════════════════════════════════════════

function Get-FrontmatterBlock {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return '' }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $match = [regex]::Match($content, '(?ms)\A---\s*\r?\n(.*?)\r?\n---')
    if ($match.Success) { return $match.Groups[1].Value }
    return ''
}

function Get-AuditFrontmatterFieldValue {
    param(
        [string]$Frontmatter,
        [string]$Field
    )

    if (-not $Frontmatter) { return '' }

    $lines = $Frontmatter -split "\r?\n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $match = [regex]::Match($line, "^(?<field>\s*$([regex]::Escape($Field))):\s*(?<value>.*)$")
        if (-not $match.Success) { continue }

        $value = $match.Groups['value'].Value.Trim()
        if ($value -match '^[>|]') {
            $parts = New-Object System.Collections.Generic.List[string]
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                $next = $lines[$j]
                if ($next -match '^\S[^:]*:\s*') { break }
                if ($next.Trim().Length -gt 0) { $parts.Add($next.Trim()) }
            }
            return (($parts.ToArray()) -join ' ').Trim()
        }

        return $value.Trim('"').Trim("'")
    }

    return ''
}

function Test-FrontmatterField {
    param(
        [string]$Frontmatter,
        [string]$Field
    )
    return $Frontmatter -match "(?m)^\s+$([regex]::Escape($Field)):"
}

function Get-AuditRelativePath {
    param(
        [string]$RepoRoot,
        [string]$Path
    )

    $root = (Resolve-Path $RepoRoot).Path
    try {
        $full = (Resolve-Path -LiteralPath $Path).Path
    } catch {
        $full = [System.IO.Path]::GetFullPath($Path)
    }
    return $full.Substring($root.Length).TrimStart('\', '/')
}

function Get-AuditSharedGovernanceReferenceRelativePaths {
    param([string]$SharedRoot)

    $references = New-Object System.Collections.Generic.List[string]
    foreach ($rel in @(
        'platform-capability-matrix.md',
        'workflow-capability-evidence-matrix.md',
        'skill-governance.md',
        'policies\subagent-invocation.md'
    )) {
        $path = Join-Path $SharedRoot $rel
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $references.Add($rel)
        }
    }

    foreach ($dirRel in @('mcp-profiles', 'policies')) {
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

function Get-GovernanceScanFiles {
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $files = @()
    $explicit = @(
        'README.md',
        'CHANGELOG.md',
        'Antigravity\README.md',
        'Claude\README.md',
        'Codex\README.md',
        'Shared\platform-capability-matrix.md',
        'Shared\workflow-capability-evidence-matrix.md',
        'Shared\skill-governance.md',
        'Shared\policies\subagent-invocation.md',
        'Shared\mcp-profiles\README.md',
        'Codex\.codex\AGENTS.md',
        'Claude\.claude\CLAUDE.md',
        'Antigravity\.agents\rules\AGENTS.md'
    )

    foreach ($rel in $explicit) {
        $path = Join-Path $RepoRoot $rel
        if (Test-Path -LiteralPath $path) { $files += (Resolve-Path -LiteralPath $path).Path }
    }

    $scanRoots = @(
        'Codex\global',
        'Codex\.agents\workflow-skills',
        'Claude\global',
        'Claude\.claude\commands',
        'Claude\.claude\rules',
        'Antigravity\global',
        'Antigravity\.agents\workflows',
        'Antigravity\.agents\rules',
        '.agents\memory'
    )

    foreach ($relRoot in $scanRoots) {
        $root = Join-Path $RepoRoot $relRoot
        if (Test-Path -LiteralPath $root) {
            $files += (Get-ChildItem -LiteralPath $root -Filter '*.md' -Recurse -File -ErrorAction SilentlyContinue).FullName
        }
    }

    return $files | Sort-Object -Unique
}

function Get-WorkflowAuditTargets {
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $targets = @()
    $codexRoot = Join-Path $RepoRoot 'Codex\.agents\workflow-skills'
    if (Test-Path -LiteralPath $codexRoot) {
        Get-ChildItem -LiteralPath $codexRoot -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch '^_' } |
            ForEach-Object {
                $path = Join-Path $_.FullName 'SKILL.md'
                if (Test-Path -LiteralPath $path) {
                    $targets += [PSCustomObject]@{ Platform = 'Codex'; Name = $_.Name; Path = $path }
                }
            }
    }

    $claudeRoot = Join-Path $RepoRoot 'Claude\.claude\commands'
    if (Test-Path -LiteralPath $claudeRoot) {
        Get-ChildItem -LiteralPath $claudeRoot -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '[\\/]_' } |
            ForEach-Object {
                $name = $_.Directory.FullName.Substring($claudeRoot.Length).TrimStart('\', '/')
                $targets += [PSCustomObject]@{ Platform = 'Claude'; Name = $name; Path = $_.FullName }
            }
    }

    $agRoot = Join-Path $RepoRoot 'Antigravity\.agents\workflows'
    if (Test-Path -LiteralPath $agRoot) {
        Get-ChildItem -LiteralPath $agRoot -Filter '*.md' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch '^_' } |
            ForEach-Object {
                $targets += [PSCustomObject]@{ Platform = 'Antigravity'; Name = $_.Name; Path = $_.FullName }
            }
    }

    return $targets
}

function Get-DirectorOutputContractTargets {
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $targets = @()

    $coreTargets = @(
        [PSCustomObject]@{ Platform = 'Antigravity'; Scope = 'core-source'; Path = (Join-Path $RepoRoot 'Antigravity\.agents\rules\00_core_identity.md') },
        [PSCustomObject]@{ Platform = 'Claude'; Scope = 'core-source'; Path = (Join-Path $RepoRoot 'Claude\.claude\rules\core-identity.md') },
        [PSCustomObject]@{ Platform = 'Codex'; Scope = 'core-source'; Path = (Join-Path $RepoRoot 'Codex\.codex\AGENTS.md') },
        [PSCustomObject]@{ Platform = 'Antigravity'; Scope = 'core-target'; Path = (Join-Path $TargetRoot '.agents\rules\00_core_identity.md') },
        [PSCustomObject]@{ Platform = 'Claude'; Scope = 'core-target'; Path = (Join-Path $TargetRoot '.claude\rules\core-identity.md') },
        [PSCustomObject]@{ Platform = 'Codex'; Scope = 'core-target'; Path = (Join-Path $TargetRoot '.codex\AGENTS.md') }
    )
    foreach ($target in $coreTargets) {
        if (Test-Path -LiteralPath $target.Path) {
            $targets += $target
        }
    }

    $agRoot = Join-Path $RepoRoot 'Antigravity\.agents\workflows'
    if (Test-Path -LiteralPath $agRoot) {
        Get-ChildItem -LiteralPath $agRoot -Filter '*.md' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch '^_' } |
            ForEach-Object { $targets += [PSCustomObject]@{ Platform = 'Antigravity'; Scope = 'source'; Path = $_.FullName } }
    }

    $claudeRoot = Join-Path $RepoRoot 'Claude\.claude\commands'
    if (Test-Path -LiteralPath $claudeRoot) {
        Get-ChildItem -LiteralPath $claudeRoot -Filter 'SKILL.md' -Recurse -File -ErrorAction SilentlyContinue |
            ForEach-Object { $targets += [PSCustomObject]@{ Platform = 'Claude'; Scope = 'source'; Path = $_.FullName } }
    }

    $codexRoot = Join-Path $RepoRoot 'Codex\.agents\workflow-skills'
    if (Test-Path -LiteralPath $codexRoot) {
        Get-ChildItem -LiteralPath $codexRoot -Filter 'SKILL.md' -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '[\\/]_shared[\\/]' } |
            ForEach-Object { $targets += [PSCustomObject]@{ Platform = 'Codex'; Scope = 'source'; Path = $_.FullName } }
    }

    $liveSkillsRoot = Join-Path $TargetRoot '.agents\skills'
    if (Test-Path -LiteralPath $liveSkillsRoot) {
        Get-ChildItem -LiteralPath $liveSkillsRoot -Filter 'SKILL.md' -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Directory.Name -match '^(0[0-9]|1[0-2])[-_]' } |
            ForEach-Object { $targets += [PSCustomObject]@{ Platform = 'Codex'; Scope = 'target'; Path = $_.FullName } }
    }

    return $targets
}

function Get-AuditMetadataValue {
    param(
        [string]$Frontmatter,
        [string]$Field
    )

    $match = [regex]::Match($Frontmatter, "(?m)^\s+$([regex]::Escape($Field)):\s*(.+?)\s*$")
    if ($match.Success) { return $match.Groups[1].Value.Trim().Trim('"', "'") }
    return ''
}

function Test-AuditLineIsNegative {
    param([string]$Line)

    return $Line -match '(?i)\b(NO|NOT|DO NOT|DON''T|NEVER|FORBID|FORBIDDEN|PROHIBIT|MUST NOT|CANNOT|WITHOUT|INCOMPLETE|INVALID|FAIL)\b|禁止|不得|不可|不應|不允許|不代表|不會|不安裝|不修改|非自動|只輸出|僅輸出|建議|草稿|proposed|recommend'
}

function Measure-WorkflowMetadata {
    <#
    .SYNOPSIS
        檢查三平台 workflow / command metadata v2 完整度。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $required = @(
        'author',
        'version',
        'origin',
        'kind',
        'platforms',
        'lifecycle_phase',
        'role',
        'memory_awareness',
        'tool_scope',
        'human_gate',
        'automation_safe'
    )

    $targets = @(
        [PSCustomObject]@{
            Platform = 'Codex'
            Root     = Join-Path $RepoRoot 'Codex\.agents\workflow-skills'
            Kind     = 'DirectorySkill'
        },
        [PSCustomObject]@{
            Platform = 'Claude'
            Root     = Join-Path $RepoRoot 'Claude\.claude\commands'
            Kind     = 'RecursiveSkill'
        },
        [PSCustomObject]@{
            Platform = 'Antigravity'
            Root     = Join-Path $RepoRoot 'Antigravity\.agents\workflows'
            Kind     = 'WorkflowFile'
        }
    )

    $results = @()
    foreach ($target in $targets) {
        if (-not (Test-Path $target.Root)) { continue }
        $items = if ($target.Kind -eq 'WorkflowFile') {
            Get-ChildItem -LiteralPath $target.Root -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }
        } elseif ($target.Kind -eq 'RecursiveSkill') {
            Get-ChildItem -LiteralPath $target.Root -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch '[\\/]_' }
        } else {
            Get-ChildItem -LiteralPath $target.Root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }
        }

        foreach ($item in $items) {
            $file = if ($target.Kind -eq 'WorkflowFile' -or $target.Kind -eq 'RecursiveSkill') { $item.FullName } else { Join-Path $item.FullName 'SKILL.md' }
            $name = if ($target.Kind -eq 'RecursiveSkill') {
                $item.Directory.FullName.Substring($target.Root.Length).TrimStart('\', '/')
            } else {
                $item.Name
            }
            $fm = Get-FrontmatterBlock -Path $file
            $missing = @()
            foreach ($field in $required) {
                if (-not (Test-FrontmatterField -Frontmatter $fm -Field $field)) { $missing += "metadata.$field" }
            }
            $description = Get-AuditFrontmatterFieldValue -Frontmatter $fm -Field 'description'
            $triggerIssues = New-Object System.Collections.Generic.List[string]
            if ([string]::IsNullOrWhiteSpace($description)) {
                $triggerIssues.Add('description 空白或無法解析')
            } elseif ($description.Length -lt 40) {
                $triggerIssues.Add('description 過短，可能不足以觸發自動載入')
            }
            if ($description -notmatch '(?i)Use when|需要|適用|觸發|when') {
                $triggerIssues.Add('description 缺少 Use when 或等效觸發語句')
            }
            if ($description -notmatch '[\u4e00-\u9fff]') {
                $triggerIssues.Add('description 缺少繁中任務語句')
            }
            $automationSafe = $fm -match '(?m)^\s+automation_safe:\s*true\s*$'
            $status = if ($missing.Count -gt 0) {
                '🔴'
            } elseif ($triggerIssues.Count -gt 0) {
                '🟡'
            } else {
                '🟢'
            }
            $results += [PSCustomObject]@{
                Platform       = $target.Platform
                Name           = $name
                MissingFields  = $missing
                TriggerIssues  = @($triggerIssues.ToArray())
                AutomationSafe = $automationSafe
                Status         = $status
            }
        }
    }

    $passCount = ($results | Where-Object { $_.Status -eq '🟢' }).Count
    $warnCount = ($results | Where-Object { $_.Status -eq '🟡' }).Count
    $failCount = ($results | Where-Object { $_.Status -eq '🔴' }).Count
    $safeCount = ($results | Where-Object { $_.AutomationSafe }).Count

    Write-Host ""
    Write-Host "📊 Workflow Metadata v2"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "掃描 workflow/command：$($results.Count)"
    Write-Host "🟢 完整：$passCount  🟡 觸發警告：$warnCount  🔴 缺漏：$failCount  automation-safe：$safeCount"

    foreach ($r in $results | Sort-Object Platform, Name) {
        $safeText = if ($r.AutomationSafe) { 'safe' } else { 'manual' }
        Write-Host ("{0,-12} {1,-38} {2} {3}" -f $r.Platform, $r.Name, $r.Status, $safeText)
        if ($r.MissingFields.Count -gt 0) {
            Write-Host "  ⚠ 缺少欄位：$($r.MissingFields -join ', ')" -ForegroundColor Yellow
        }
        if ($r.TriggerIssues.Count -gt 0) {
            Write-Host "  ⚠ 觸發品質：$($r.TriggerIssues -join '；')" -ForegroundColor Yellow
        }
    }

    return $results
}

function Measure-DocsConsistency {
    <#
    .SYNOPSIS
        檢查文件與記憶卡中的平台數、技能數與舊詞殘留。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $counts = [PSCustomObject]@{
        SharedSkills          = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Shared\skills') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
        CodexWorkflowSkills   = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Codex\.agents\workflow-skills') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
        ClaudeCommands        = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Claude\.claude\commands') -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '[\\/]_' }).Count
        AntigravityWorkflows  = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Antigravity\.agents\workflows') -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
    }

    $patterns = @(
        ('14' + ' 套'),
        ('雙' + ' AI'),
        ('\.Codex' + '/agents'),
        ('\.Codex' + '/commands'),
        ('\.claude/agents' + '/skills'),
        ('v1' + '\.1\.0')
    )

    $scanFiles = Get-GovernanceScanFiles -RepoRoot $RepoRoot

    $hits = @()
    foreach ($file in $scanFiles) {
        foreach ($pattern in $patterns) {
            $found = Select-String -LiteralPath $file -Pattern $pattern -CaseSensitive -ErrorAction SilentlyContinue
            foreach ($f in $found) {
                $hits += [PSCustomObject]@{
                    File    = $f.Path.Substring($RepoRoot.Length).TrimStart('\', '/')
                    Line    = $f.LineNumber
                    Pattern = $pattern
                    Text    = $f.Line.Trim()
                }
            }
        }
    }

    Write-Host ""
    Write-Host "📊 文件與記憶卡一致性"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "Shared skills：$($counts.SharedSkills)"
    Write-Host "Codex workflow skills：$($counts.CodexWorkflowSkills)"
    Write-Host "Claude commands：$($counts.ClaudeCommands)"
    Write-Host "Antigravity workflow files：$($counts.AntigravityWorkflows)"
    Write-Host "舊詞殘留：$($hits.Count)"
    foreach ($hit in $hits) {
        Write-Host "  ⚠ $($hit.File):$($hit.Line) [$($hit.Pattern)] $($hit.Text)" -ForegroundColor Yellow
    }

    return [PSCustomObject]@{
        Counts = $counts
        StaleHits = $hits
    }
}

function Measure-PlatformCapability {
    <#
    .SYNOPSIS
        檢查能力矩陣與 MCP opt-in profile 是否存在。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $matrixPath = Join-Path $RepoRoot 'Shared\platform-capability-matrix.md'
    $workflowMatrixPath = Join-Path $RepoRoot 'Shared\workflow-capability-evidence-matrix.md'
    $mcpProfilePath = Join-Path $RepoRoot 'Shared\mcp-profiles\README.md'
    $sharedRoot = Join-Path $RepoRoot 'Shared'
    $projectToolsRoot = Join-Path $sharedRoot 'project-tools'
    $targetSharedRoot = Join-Path $TargetRoot '.agents\shared'
    $targetProjectToolsRoot = Join-Path $TargetRoot '.agents\tools'
    $targetCodexSupportFiles = @(
        (Join-Path $TargetRoot '.agents\skills\_shared\_security_footer.md'),
        (Join-Path $TargetRoot '.agents\skills\_shared\_completion_gate.md')
    )
    $targetProjectToolFiles = @(
        (Join-Path $targetProjectToolsRoot 'Memory-Migration.ps1'),
        (Join-Path $targetProjectToolsRoot 'modules\Memory-Migration.psm1')
    )
    $extensionPackagePath = Join-Path $RepoRoot 'Extensions\vscode-ai-rules-manager\package.json'
    $extensionCommandsPath = Join-Path $RepoRoot 'Extensions\vscode-ai-rules-manager\src\commands.ts'
    $managerPath = Join-Path $RepoRoot 'Scripts\AI-RulesManager.ps1'

    $matrixOk = (Test-Path $matrixPath) -and ((Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'native' -and (Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'adapter' -and (Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'manual')
    $workflowMatrixOk = (Test-Path $workflowMatrixPath) -and ((Get-Content -LiteralPath $workflowMatrixPath -Raw -Encoding UTF8) -match 'Workflow Matrix')
    $mcpProfileOk = (Test-Path $mcpProfilePath) -and ((Get-Content -LiteralPath $mcpProfilePath -Raw -Encoding UTF8) -match 'Opt-in')
    $projectToolSourceOk =
        (Test-Path -LiteralPath (Join-Path $projectToolsRoot 'Memory-Migration.ps1') -PathType Leaf) -and
        (Test-Path -LiteralPath (Join-Path $projectToolsRoot 'modules\Memory-Migration.psm1') -PathType Leaf)
    $memoryMigrationManagerOk = (Test-Path -LiteralPath $managerPath -PathType Leaf) -and ((Get-Content -LiteralPath $managerPath -Raw -Encoding UTF8) -match 'MemoryMigration')
    $memoryMigrationExtensionOk =
        (Test-Path -LiteralPath $extensionPackagePath -PathType Leaf) -and
        (Test-Path -LiteralPath $extensionCommandsPath -PathType Leaf) -and
        ((Get-Content -LiteralPath $extensionPackagePath -Raw -Encoding UTF8) -match 'aiRules\.memoryMigration') -and
        ((Get-Content -LiteralPath $extensionCommandsPath -Raw -Encoding UTF8) -match 'MemoryMigration')
    $targetSharedRequired =
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\skills') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\workflows') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\rules') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.codex') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.claude') -PathType Container)
    $referenceRels = @(Get-AuditSharedGovernanceReferenceRelativePaths -SharedRoot $sharedRoot)
    $missingTargetSharedRefs = @()
    if ($targetSharedRequired) {
        foreach ($rel in $referenceRels) {
            $targetPath = Join-Path $targetSharedRoot $rel
            if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
                $missingTargetSharedRefs += $rel
            }
        }
    }
    $targetSharedOk = (-not $targetSharedRequired) -or (@($missingTargetSharedRefs).Count -eq 0)
    $targetCodexSupportRequired = Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\skills') -PathType Container
    $missingCodexSupport = @()
    if ($targetCodexSupportRequired) {
        foreach ($file in $targetCodexSupportFiles) {
            if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
                $missingCodexSupport += $file
            }
        }
    }
    $targetCodexSupportOk = (-not $targetCodexSupportRequired) -or (@($missingCodexSupport).Count -eq 0)
    $targetProjectToolsRequired = $targetSharedRequired -and (-not [string]::Equals($TargetRoot, $RepoRoot, [System.StringComparison]::OrdinalIgnoreCase))
    $missingProjectTools = @()
    if ($targetProjectToolsRequired) {
        foreach ($file in $targetProjectToolFiles) {
            if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
                $missingProjectTools += $file
            }
        }
    }
    $targetProjectToolsOk = (-not $targetProjectToolsRequired) -or (@($missingProjectTools).Count -eq 0)

    Write-Host ""
    Write-Host "📊 平台能力與 MCP profile"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ("能力矩陣：{0}" -f ($(if ($matrixOk) { '🟢' } else { '🔴' })))
    Write-Host ("工作流證據矩陣：{0}" -f ($(if ($workflowMatrixOk) { '🟢' } else { '🔴' })))
    Write-Host ("共用治理參考部署：{0}" -f ($(if ($targetSharedOk) { '🟢' } else { '🔴' })))
    foreach ($rel in @($missingTargetSharedRefs | Select-Object -First 20)) {
        Write-Host ("  [缺少] .agents/shared/{0}" -f ($rel -replace '\\', '/')) -ForegroundColor Red
    }
    Write-Host ("Codex 工作流支援檔部署：{0}" -f ($(if ($targetCodexSupportOk) { '🟢' } else { '🔴' })))
    foreach ($file in @($missingCodexSupport | Select-Object -First 20)) {
        Write-Host ("  [缺少] {0}" -f (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file)) -ForegroundColor Red
    }
    Write-Host ("專案本地工具來源：{0}" -f ($(if ($projectToolSourceOk) { '🟢' } else { '🔴' })))
    Write-Host ("專案本地工具部署：{0}" -f ($(if ($targetProjectToolsOk) { '🟢' } else { '🔴' })))
    foreach ($file in @($missingProjectTools | Select-Object -First 20)) {
        Write-Host ("  [缺少] {0}" -f (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file)) -ForegroundColor Red
    }
    Write-Host ("MCP opt-in snippets：{0}" -f ($(if ($mcpProfileOk) { '🟢' } else { '🔴' })))
    Write-Host ("記憶遷移管理器入口：{0}" -f ($(if ($memoryMigrationManagerOk) { '🟢' } else { '🔴' })))
    Write-Host ("記憶遷移外掛入口：{0}" -f ($(if ($memoryMigrationExtensionOk) { '🟢' } else { '🔴' })))

    return [PSCustomObject]@{
        CapabilityMatrix        = $matrixOk
        WorkflowMatrix          = $workflowMatrixOk
        TargetSharedRefs        = $targetSharedOk
        TargetCodexSupport      = $targetCodexSupportOk
        ProjectToolSource       = $projectToolSourceOk
        TargetProjectTools      = $targetProjectToolsOk
        McpProfiles             = $mcpProfileOk
        MemoryMigrationManager  = $memoryMigrationManagerOk
        MemoryMigrationExtension = $memoryMigrationExtensionOk
    }
}

function Measure-RuntimeGlobalDrift {
    <#
    .SYNOPSIS
        檢查使用者層全域規則是否與 repo source 同步。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    .PARAMETER ProfileRoot
        使用者層設定根目錄。預設 $env:USERPROFILE，可用於 temp profile 測試。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$ProfileRoot = $env:USERPROFILE,
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    if (-not $ProfileRoot) { $ProfileRoot = $env:USERPROFILE }

    $targets = @(
        [PSCustomObject]@{
            Platform = 'Antigravity'
            Source   = Join-Path $RepoRoot 'Antigravity\global\GEMINI.md'
            Runtime  = Join-Path $ProfileRoot '.gemini\GEMINI.md'
        },
        [PSCustomObject]@{
            Platform = 'Claude'
            Source   = Join-Path $RepoRoot 'Claude\global\CLAUDE.md'
            Runtime  = Join-Path $ProfileRoot '.claude\CLAUDE.md'
        },
        [PSCustomObject]@{
            Platform = 'Codex'
            Source   = Join-Path $RepoRoot 'Codex\global\AGENTS.md'
            Runtime  = Join-Path $ProfileRoot '.codex\AGENTS.md'
        }
    )

    $dangerPattern = '(WITHOUT\s+halting|execute\s+WITHOUT|自動佈署|自動部署|\.Codex[\\/](agents|commands)[\\/]|\.claude[\\/]agents[\\/]skills[\\/]|git\s+add\s+\.|git\s+add\s+-A)'
    $results = @()

    foreach ($target in $targets) {
        if (-not (Test-Path -LiteralPath $target.Source)) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🔴'
                Severity = 'Red'
                Reason   = 'repo source 全域規則不存在'
                Runtime  = $target.Runtime
            }
            continue
        }

        if (-not (Test-Path -LiteralPath $target.Runtime)) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🟡'
                Severity = 'Yellow'
                Reason   = '使用者層全域規則尚未安裝'
                Runtime  = $target.Runtime
            }
            continue
        }

        if (Test-RuleTextEquivalent -SourcePath $target.Source -TargetPath $target.Runtime) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🟢'
                Severity = 'Green'
                Reason   = '已同步'
                Runtime  = $target.Runtime
            }
            continue
        }

        $runtimeContent = Get-Content -LiteralPath $target.Runtime -Raw -Encoding UTF8
        $hasDanger = $runtimeContent -match $dangerPattern
        $reason = if ($hasDanger) {
            '使用者層規則與 source 不同，且含舊版高風險語義'
        } else {
            '使用者層規則與 source 不同'
        }

        $results += [PSCustomObject]@{
            Platform = $target.Platform
            Status   = '🟡'
            Severity = 'Yellow'
            Reason   = $reason
            Runtime  = $target.Runtime
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count
    $greenCount = ($results | Where-Object { $_.Severity -eq 'Green' }).Count

    Write-Host ""
    Write-Host "📊 Runtime Global Drift"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🟢 Green：$greenCount  🟡 Yellow：$yellowCount  🔴 Red：$redCount"
    foreach ($result in $results | Sort-Object Platform) {
        $color = switch ($result.Severity) {
            'Red' { 'Red' }
            'Yellow' { 'Yellow' }
            default { 'Green' }
        }
        Write-Host ("{0,-12} {1} {2}" -f $result.Platform, $result.Status, $result.Reason) -ForegroundColor $color
        Write-Host ("  {0}" -f $result.Runtime) -ForegroundColor DarkGray
    }

    return [PSCustomObject]@{
        Results     = $results
        GreenCount  = $greenCount
        YellowCount = $yellowCount
        RedCount    = $redCount
        Passed      = ($redCount -eq 0)
    }
}

function Get-AuditSharedPolicyBlock {
    param(
        [string]$PolicyPath,
        [string]$Platform
    )

    if (-not (Test-Path -LiteralPath $PolicyPath)) { return '' }

    $content = Get-Content -LiteralPath $PolicyPath -Raw -Encoding UTF8
    $platformKey = $Platform.ToUpperInvariant()
    $pattern = "(?ms)<!--\s*SUBAGENT_POLICY:$platformKey`_START\s*-->\s*(.*?)\s*<!--\s*SUBAGENT_POLICY:$platformKey`_END\s*-->"
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ''
}

function Get-AuditGeneratedSubagentPolicyBlock {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return '' }

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    $pattern = "(?ms)$([regex]::Escape($startMarker))\s*(.*?)\s*$([regex]::Escape($endMarker))"
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ''
}

function Measure-SharedSubagentPolicyDrift {
    <#
    .SYNOPSIS
        檢查 Shared/policies/subagent-invocation.md 與三平台核心規則 marker block 是否一致。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄。
    .PARAMETER TargetRoot
        目前專案根目錄；若已安裝平台規則，列為 Yellow drift 警告。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $policyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'

    function Add-PolicyFinding {
        param(
            [string]$Severity,
            [string]$Platform,
            [string]$Scope,
            [string]$File,
            [string]$Reason
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            Platform = $Platform
            Scope    = $Scope
            File     = $File
            Reason   = $Reason
        })
    }

    if (-not (Test-Path -LiteralPath $policyPath)) {
        Add-PolicyFinding -Severity 'Red' -Platform 'Shared' -Scope 'source' -File 'Shared/policies/subagent-invocation.md' -Reason 'Shared 子代理政策來源不存在'
    }

    $sourceTargets = @(
        [PSCustomObject]@{ Platform = 'Codex'; Path = Join-Path $RepoRoot 'Codex\.codex\AGENTS.md' },
        [PSCustomObject]@{ Platform = 'Claude'; Path = Join-Path $RepoRoot 'Claude\.claude\rules\core-identity.md' },
        [PSCustomObject]@{ Platform = 'Antigravity'; Path = Join-Path $RepoRoot 'Antigravity\.agents\rules\00_core_identity.md' }
    )

    $targetTargets = @(
        [PSCustomObject]@{ Platform = 'Codex'; Path = Join-Path $TargetRoot '.codex\AGENTS.md' },
        [PSCustomObject]@{ Platform = 'Claude'; Path = Join-Path $TargetRoot '.claude\rules\core-identity.md' },
        [PSCustomObject]@{ Platform = 'Antigravity'; Path = Join-Path $TargetRoot '.agents\rules\00_core_identity.md' }
    )

    foreach ($target in $sourceTargets) {
        $expected = Get-AuditSharedPolicyBlock -PolicyPath $policyPath -Platform $target.Platform
        $rel = if (Test-Path -LiteralPath $target.Path) { Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path } else { $target.Path }
        if (-not $expected) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason 'Shared policy 缺少此平台轉譯區塊'
            continue
        }
        if (-not (Test-Path -LiteralPath $target.Path)) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則來源檔不存在'
            continue
        }
        $actual = Get-AuditGeneratedSubagentPolicyBlock -Path $target.Path
        if (-not $actual) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則缺少 shared subagent policy marker block'
        } elseif ($actual -ne $expected) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則 marker block 與 Shared policy 不一致'
        }
    }

    foreach ($target in $targetTargets) {
        if (-not (Test-Path -LiteralPath $target.Path)) { continue }
        $expected = Get-AuditSharedPolicyBlock -PolicyPath $policyPath -Platform $target.Platform
        if (-not $expected) { continue }
        $actual = Get-AuditGeneratedSubagentPolicyBlock -Path $target.Path
        $display = if ($target.Path.StartsWith($RepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path
        } else {
            "target:$($target.Path.Substring($TargetRoot.Length).TrimStart('\', '/'))"
        }
        if (-not $actual) {
            Add-PolicyFinding -Severity 'Yellow' -Platform $target.Platform -Scope 'target' -File $display -Reason '目前專案核心規則缺少 shared subagent policy marker block'
        } elseif ($actual -ne $expected) {
            Add-PolicyFinding -Severity 'Yellow' -Platform $target.Platform -Scope 'target' -File $display -Reason '目前專案核心規則 marker block 與 Shared policy 不一致'
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Shared Subagent Policy Drift"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, Platform, Scope, File) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}/{2} {3} — {4}" -f $finding.Severity, $finding.Platform, $finding.Scope, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-SubagentVocabularyDrift {
    <#
    .SYNOPSIS
        檢查三平台子代理語彙是否混用：Shared 技能不得硬寫平台專用工具名，Codex workflow 不得使用 Claude 舊式 Agent(subagent_type) 語法。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄。
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-SubagentVocabularyFinding {
        param(
            [string]$Severity,
            [string]$Scope,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            Scope    = $Scope
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    $sharedForbiddenPatterns = @(
        'Agent\s*\(',
        '\bsubagent_type\b',
        '\bbrowser_subagent\b',
        '\bbrowser_agent\b',
        '\bspawn_agent\b',
        '@agent\b',
        '\bnative subagents?\b',
        '\bGemini CLI subagents?\b',
        '\bbrowser-capable agents?\b'
    )
    $sharedScanFiles = @()
    $sharedSkillRoot = Join-Path $RepoRoot 'Shared\skills'
    if (Test-Path -LiteralPath $sharedSkillRoot) {
        $sharedScanFiles += @(Get-ChildItem -LiteralPath $sharedSkillRoot -Recurse -File -Include '*.md')
    }
    $sharedPolicyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'
    if (Test-Path -LiteralPath $sharedPolicyPath) {
        $sharedScanFiles += @(Get-Item -LiteralPath $sharedPolicyPath)
    }

    foreach ($file in $sharedScanFiles) {
        $relative = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $file.FullName
        $lines = Get-Content -LiteralPath $file.FullName -Encoding UTF8
        $insidePlatformTranslation = $false
        $adapterSectionLevel = 0
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($relative -eq 'Shared\policies\subagent-invocation.md' -and $lines[$i] -match '^##\s+(Platform Translation Blocks|平台轉譯區塊)') {
                $insidePlatformTranslation = $true
            }

            if ($lines[$i] -match '^(#+)\s+') {
                $headingLevel = $matches[1].Length
                if ($adapterSectionLevel -gt 0 -and $headingLevel -le $adapterSectionLevel) {
                    $adapterSectionLevel = 0
                }
                if ($lines[$i] -match '(Platform Adapter|Adapter Notes|平台轉譯)') {
                    $adapterSectionLevel = $headingLevel
                }
            }

            if ($insidePlatformTranslation -or $adapterSectionLevel -gt 0) { continue }

            foreach ($pattern in $sharedForbiddenPatterns) {
                if ($lines[$i] -match $pattern) {
                    Add-SubagentVocabularyFinding -Severity 'Red' `
                        -Scope 'Shared' `
                        -File $relative `
                        -Line ($i + 1) `
                        -Reason 'Shared 共用層不得硬寫未標註平台的子代理工具名，請改成 evidence branch / platform adapter 語彙' `
                        -Text $lines[$i].Trim()
                    break
                }
            }
        }
    }

    $codexRoots = @(
        (Join-Path -Path $RepoRoot -ChildPath 'Codex\.agents\workflow-skills')
        (Join-Path -Path $RepoRoot -ChildPath '.agents\skills')
    )
    foreach ($root in $codexRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -File -Include '*.md' | ForEach-Object {
            $lines = Get-Content -LiteralPath $_.FullName -Encoding UTF8
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match 'Agent\(subagent_type') {
                    Add-SubagentVocabularyFinding -Severity 'Red' `
                        -Scope 'Codex' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $_.FullName) `
                        -Line ($i + 1) `
                        -Reason 'Codex workflow 不得使用 Claude 舊式 Agent(subagent_type) 語法' `
                        -Text $lines[$i].Trim()
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Subagent Vocabulary Drift"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, Scope, File, Line) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} {2}:{3} — {4}" -f $finding.Severity, $finding.Scope, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-GovernanceSemantics {
    <#
    .SYNOPSIS
        檢查治理語義：GO gate、舊路徑、自動安裝、automation-safe mutation、MCP HITL 邊界。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-GovernanceFinding {
        param(
            [string]$Severity,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    $globalPatterns = @(
        [PSCustomObject]@{ Pattern = ('WITHOUT' + ' halting'); Reason = 'global bootstrap 不可未授權自動下載執行' },
        [PSCustomObject]@{ Pattern = '\.Codex/(agents|commands)'; Reason = 'Codex 舊路徑殘留' },
        [PSCustomObject]@{ Pattern = ('\.claude/agents' + '/skills'); Reason = 'Claude 舊技能路徑殘留' },
        [PSCustomObject]@{ Pattern = ('雙' + ' AI'); Reason = '舊雙平台概念殘留，需改為三平台或多平台代理' },
        [PSCustomObject]@{ Pattern = 'v1\.1\.0'; Reason = '舊版本描述殘留' },
        [PSCustomObject]@{ Pattern = 'git\s+add\s+\.|git\s+add\s+-A'; Reason = 'commit workflow 不可使用 blanket staging' }
    )

    foreach ($file in (Get-GovernanceScanFiles -RepoRoot $RepoRoot)) {
        $lines = Get-Content -LiteralPath $file -Encoding UTF8
        for ($i = 0; $i -lt $lines.Count; $i++) {
            foreach ($pattern in $globalPatterns) {
                if ($lines[$i] -cmatch $pattern.Pattern) {
                    Add-GovernanceFinding -Severity 'Red' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $file) `
                        -Line ($i + 1) `
                        -Reason $pattern.Reason `
                        -Text $lines[$i].Trim()
                }
            }
        }
    }

    $mutationPattern = '(?i)(\bwrite_to_file\b|\breplace_file_content\b|\bmemory_commit\b|\bgit\s+add\b|\bgit\s+commit\b|\bgit\s+push\b|\bdeploy\b|\binstall\b|\bdelete\b|\bremove-item\b|\bnew-item\b|\bset-content\b|\badd-content\b|\bout-file\b|\bcreate_[a-z0-9_]+\b|\bupdate_[a-z0-9_]+\b|\bpush_files\b|\bapply_migration\b|\bmerge_branch\b|\breset_branch\b|\bdelete_branch\b|\bresolve\b)'
    foreach ($target in (Get-WorkflowAuditTargets -RepoRoot $RepoRoot)) {
        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $lines = Get-Content -LiteralPath $target.Path -Encoding UTF8
        $fm = Get-FrontmatterBlock -Path $target.Path
        $lifecycle = Get-AuditMetadataValue -Frontmatter $fm -Field 'lifecycle_phase'
        $toolScope = Get-AuditMetadataValue -Frontmatter $fm -Field 'tool_scope'
        $humanGate = Get-AuditMetadataValue -Frontmatter $fm -Field 'human_gate'
        $automationSafe = $fm -match '(?m)^\s+automation_safe:\s*true\s*$'
        $isExperiment = $lifecycle -eq 'experiment'
        $hasWriteScope = $toolScope -match 'write|git:write'
        $logsOnlyScope = $toolScope -match 'filesystem:write:logs'
        $noHumanGate = $humanGate -match '^(none|false|no)$'

        if ($isExperiment) {
            if ($automationSafe) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path) `
                    -Line 1 `
                    -Reason 'experiment workflow 可保留沙盒可寫例外，但不可標為 automation_safe' `
                    -Text $target.Name
            }
            continue
        }

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -notmatch $mutationPattern) { continue }
            if (Test-AuditLineIsNegative -Line $line) { continue }

            $rel = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path
            if ($automationSafe) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'automation-safe workflow 不可包含可執行變異指令' `
                    -Text $line.Trim()
                continue
            }

            if ($logsOnlyScope -and ($line -match '(?i)(write_to_file|replace_file_content|set-content|add-content|out-file|write)') -and ($line -notmatch '\.agents/logs')) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'filesystem:write:logs 只能寫入 .agents/logs/ 中繼報告' `
                    -Text $line.Trim()
                continue
            }

            if ((-not $hasWriteScope) -and $noHumanGate) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'metadata 宣告 read-scope 且無 human gate，但正文包含變異操作' `
                    -Text $line.Trim()
            }
        }

        if (($content -match 'CHANGELOG\.md') -and ($content -match 'git\s+commit|git\s+push') -and ($humanGate -notmatch 'changelog write')) {
            Add-GovernanceFinding -Severity 'Yellow' `
                -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path) `
                -Line 1 `
                -Reason 'commit workflow 應明示 GO gate 同時涵蓋 changelog write、commit、push' `
                -Text $target.Name
        }
    }

    $sharedSkillsRoot = Join-Path $RepoRoot 'Shared\skills'
    if (Test-Path -LiteralPath $sharedSkillsRoot) {
        Get-ChildItem -LiteralPath $sharedSkillsRoot -Filter 'SKILL.md' -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match '[\\/]Shared[\\/]skills[\\/][^\\/]+[\\/]SKILL\.md$' } |
            ForEach-Object {
                $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
                $isMcpSkill = $content -match '(?m)^\s*mcp_servers:\s*|mcp:[a-zA-Z0-9_-]+'
                $hasMutationTool = $content -match '(?i)`[^`\r\n]*(create|update|write|delete|deploy|push|apply|reset|merge|memory_commit|resolve_issue|resolve-issue)[a-z0-9_-]*[^`\r\n]*`'
                $hasHitl = ($content -match '## HITL Boundary') -and ($content -match '\[MCP HITL GATE\]')
                if ($isMcpSkill -and $hasMutationTool -and (-not $hasHitl)) {
                    Add-GovernanceFinding -Severity 'Yellow' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $_.FullName) `
                        -Line 1 `
                        -Reason 'MCP 高風險操作技能缺少標準 HITL/GO 邊界' `
                        -Text $_.Directory.Name
                }
            }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Governance Semantics"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
        if ($finding.Text) {
            Write-Host ("      {0}" -f $finding.Text) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-ReviewGovernanceCoverage {
    <#
    .SYNOPSIS
        檢查工程審查治理是否覆蓋共用技能、矩陣、政策與三平台工作流入口。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    .PARAMETER TargetRoot
        目前專案根目錄，用於檢查部署後副本是否同步。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-ReviewGovernanceFinding {
        param(
            [string]$Severity,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    function Get-ReviewGovernanceContent {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path)) { return $null }
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8)
    }

    $coreChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\skills\quality-review-governance\SKILL.md'
            Severity = 'Red'
            Label = '審查治理共用技能缺少必要章節'
            Patterns = @(
                'Review Lifecycle States',
                'Minimum Sufficient Complexity',
                'Evidence Branch Boundary',
                'fixed-pending-validation',
                'accepted-risk'
            )
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\_index.md'
            Severity = 'Red'
            Label = '技能索引缺少審查治理路由'
            Patterns = @('quality-review-governance')
        },
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Severity = 'Red'
            Label = '工作流矩陣缺少審查生命週期'
            Patterns = @(
                'Review Lifecycle Governance Matrix',
                'fixed-pending-validation',
                'accepted-risk',
                'blocked'
            )
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\ai-dev-quality-gate\SKILL.md'
            Severity = 'Red'
            Label = 'AI 開發品質閘門未引用審查治理'
            Patterns = @('quality-review-governance', 'Review Lifecycle Gate', 'review state')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\intent-alignment-gate\SKILL.md'
            Severity = 'Red'
            Label = '需求對齊閘門未納入審查狀態'
            Patterns = @('quality-review-governance', 'Review state|審查目的與狀態')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\delegation-strategy\SKILL.md'
            Severity = 'Red'
            Label = '委派策略未分離證據分支與審查責任'
            Patterns = @('quality-review-governance', 'Evidence branches can support', 'review lifecycle|lifecycle state|審查生命週期')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\subagent-invocation.md'
            Severity = 'Red'
            Label = '子代理政策未聲明審查狀態邊界'
            Patterns = @('quality-review-governance', '審查生命週期狀態', 'Review-state boundary')
        }
    )

    foreach ($check in $coreChecks) {
        $fullPath = Join-Path $RepoRoot $check.Path
        $content = Get-ReviewGovernanceContent -Path $fullPath
        if ($null -eq $content) {
            Add-ReviewGovernanceFinding -Severity $check.Severity `
                -File $check.Path `
                -Line 1 `
                -Reason '必要檔案不存在' `
                -Text $check.Label
            continue
        }

        foreach ($pattern in $check.Patterns) {
            if ($content -notmatch $pattern) {
                Add-ReviewGovernanceFinding -Severity $check.Severity `
                    -File $check.Path `
                    -Line 1 `
                    -Reason $check.Label `
                    -Text "missing pattern: $pattern"
            }
        }
    }

    $workflowChecks = @(
        'Codex\.agents\workflow-skills\02-blueprint-架構\SKILL.md',
        'Codex\.agents\workflow-skills\03-build-建構\SKILL.md',
        'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md',
        'Codex\.agents\workflow-skills\08-audit-健檢\SKILL.md',
        'Codex\.agents\workflow-skills\08-2-logic-深度邏輯\SKILL.md',
        'Codex\.agents\workflow-skills\08-3-report-健檢總結\SKILL.md',
        'Codex\.agents\workflow-skills\09-commit-紀錄總結\SKILL.md',
        'Codex\.agents\workflow-skills\10-routine-巡檢\SKILL.md',
        'Claude\.claude\commands\02_blueprint(架構)\SKILL.md',
        'Claude\.claude\commands\03_build(建構)\SKILL.md',
        'Claude\.claude\commands\04_fix(修復)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-2_logic\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-3_report\SKILL.md',
        'Claude\.claude\commands\09_commit(紀錄)\SKILL.md',
        'Claude\.claude\commands\10_routine(巡檢)\SKILL.md',
        'Antigravity\.agents\workflows\02_blueprint(架構).md',
        'Antigravity\.agents\workflows\03_build(建構計畫).md',
        'Antigravity\.agents\workflows\04-1_fix_plan(修復計畫).md',
        'Antigravity\.agents\workflows\08_audit(健檢).md',
        'Antigravity\.agents\workflows\08-2_audit_logic(深度邏輯).md',
        'Antigravity\.agents\workflows\08-3_audit_report(健檢總結).md',
        'Antigravity\.agents\workflows\09-1_commit_scan(紀錄掃描).md',
        'Antigravity\.agents\workflows\10_routine(巡檢).md'
    )

    foreach ($relPath in $workflowChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ReviewGovernanceContent -Path $fullPath
        if ($null -eq $content) {
            Add-ReviewGovernanceFinding -Severity 'Red' `
                -File $relPath `
                -Line 1 `
                -Reason '三平台工作流入口不存在' `
                -Text $relPath
            continue
        }

        if ($content -notmatch 'quality-review-governance') {
            Add-ReviewGovernanceFinding -Severity 'Red' `
                -File $relPath `
                -Line 1 `
                -Reason '工作流入口未引用審查治理技能' `
                -Text $relPath
        }
        if ($content -notmatch 'review state|review lifecycle|review governance|審查狀態|審查治理|審查目的') {
            Add-ReviewGovernanceFinding -Severity 'Yellow' `
                -File $relPath `
                -Line 1 `
                -Reason '工作流入口缺少可讀審查狀態語義' `
                -Text $relPath
        }
    }

    $targetAgents = Join-Path $TargetRoot '.agents'
    if (Test-Path -LiteralPath $targetAgents) {
        $targetChecks = @(
            [PSCustomObject]@{
                Path = '.agents\skills\quality-review-governance\SKILL.md'
                Patterns = @('Review Lifecycle States', 'Minimum Sufficient Complexity')
            },
            [PSCustomObject]@{
                Path = '.agents\shared\workflow-capability-evidence-matrix.md'
                Patterns = @('Review Lifecycle Governance Matrix')
            },
            [PSCustomObject]@{
                Path = '.agents\shared\policies\subagent-invocation.md'
                Patterns = @('quality-review-governance', 'Review-state boundary')
            }
        )

        foreach ($check in $targetChecks) {
            $fullPath = Join-Path $TargetRoot $check.Path
            $content = Get-ReviewGovernanceContent -Path $fullPath
            if ($null -eq $content) {
                Add-ReviewGovernanceFinding -Severity 'Yellow' `
                    -File $check.Path `
                    -Line 1 `
                    -Reason '部署後副本缺少審查治理覆蓋，需同步專案規則' `
                    -Text $check.Path
                continue
            }

            foreach ($pattern in $check.Patterns) {
                if ($content -notmatch $pattern) {
                    Add-ReviewGovernanceFinding -Severity 'Yellow' `
                        -File $check.Path `
                        -Line 1 `
                        -Reason '部署後副本審查治理內容過期，需同步專案規則' `
                        -Text "missing pattern: $pattern"
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Review Governance Coverage"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
        if ($finding.Text) {
            Write-Host ("      {0}" -f $finding.Text) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Test-AuditSharedSkillRelativePathIncluded {
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

function Test-AuditFileHashEqual {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { return $false }
    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) { return $false }
    $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    return $sourceHash -eq $targetHash
}

function Measure-ProgrammingTeamGovernanceCoverage {
    <#
    .SYNOPSIS
        檢查隊長制編程團隊治理是否覆蓋共用技能、政策、矩陣、三平台入口與部署副本。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-ProgrammingTeamFinding {
        param(
            [string]$Severity,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    function Get-ProgrammingTeamContent {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8)
    }

    function Add-ProgrammingTeamRegexFindings {
        param(
            [string]$RelativePath,
            [string]$Pattern,
            [string]$Reason,
            [string]$Severity = 'Red'
        )

        $fullPath = Join-Path $RepoRoot $RelativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { return }
        $lineNumber = 0
        Get-Content -LiteralPath $fullPath -Encoding UTF8 | ForEach-Object {
            $lineNumber++
            if ($_ -match $Pattern) {
                if (Test-AuditLineIsNegative -Line $_) { return }
                Add-ProgrammingTeamFinding -Severity $Severity -File $RelativePath -Line $lineNumber -Reason $Reason -Text $_
            }
        }
    }

    function Test-ProgrammingTeamPacketTriadContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasPatchPacket = $Content -match 'patch packet|補丁包'
        $hasReviewPacket = $Content -match 'review packet|審查包'
        $hasValidationPacket = $Content -match 'validation packet|驗證包'
        $hasMissingPacketState = $Content -match 'blocked|unverified|accepted-risk|阻塞|未驗證|已接受風險'

        return ($hasPatchPacket -and $hasReviewPacket -and $hasValidationPacket -and $hasMissingPacketState)
    }

    function Test-ProgrammingTeamImplementationDirectBounded {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasImplementationDirect = $Content -match '(?is)implementation.{0,160}\bdirect\b|實作.{0,160}主線直做'
        if (-not $hasImplementationDirect) { return $true }

        $hasAcceptedRiskRoute = $Content -match 'Director.{0,120}accept.{0,80}risk|accepted-risk|隊長代工風險接受|已接受風險'
        $hasCaptainIntegrationRoute = $Content -match 'captain.{0,120}integrat.{0,120}(returned )?(patch )?packet|隊長.{0,80}(整合|集成).{0,80}(補丁包|patch packet)'

        return ($hasAcceptedRiskRoute -or $hasCaptainIntegrationRoute)
    }

    $coreChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\skills\programming-team-governance\SKILL.md'
            Severity = 'Red'
            Label = '隊長制編程團隊治理共用技能缺少必要章節'
            Patterns = @('Captain Trigger Gate', 'Task Type Gate', 'Dispatch Pre-Gate', 'Board Contract', 'Captain Minimum Execution Gate', 'Captain Routing Contract', 'Role Exclusivity Contract', 'Station Semantics', 'Permission Boundary', 'Delegation Decision', 'Direct Exception Register', 'Workflow Integration', 'Completion Rules', 'team-task-package', 'Captain Team Board', 'task type', 'workflow route', 'implementation authorization', 'allowed specialist roles', 'forbidden specialist roles', 'station applicability', 'execution mode', 'evidence owner', 'role boundary', 'direct exception', 'completion condition', 'isolated patch', 'text patch', 'captain substitution accepted-risk', 'two or more evidence-oriented stations', 'No specialist branch starts before the captain has a board', 'patch packets only|patch packet', 'review.*validation|validation.*review', 'Full team completion', '發現 / 證據 / 風險 / 建議 / 是否阻塞')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-task-package\SKILL.md'
            Severity = 'Red'
            Label = '團隊任務包技能缺少可執行模板'
            Patterns = @('Team Task Package', 'Template Selection', 'Lightweight board', 'Full board', 'Experiment board', 'Board Header', 'Full Board Table', 'Specialist Packet', 'Patch Packet Types', 'Direct Exception Rules', 'Workflow Entry Contract', 'Completion Rules', 'Task type:', 'Workflow route:', 'Implementation authorization:', 'Allowed specialist roles:', 'Forbidden specialist roles:', 'Board template:', 'Applicability', 'Execution mode', 'Evidence owner', 'Role boundary', 'Direct exception', 'Completion condition', '發現:', '變更:', 'Isolated workspace patch', 'Text patch packet', 'Captain substitution accepted-risk', 'direct only when no isolated/text patch can be produced', 'Director explicitly accepts', 'not full team completion', 'Patch, review, and validation packets')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\_index.md'
            Severity = 'Red'
            Label = '技能索引缺少編程團隊治理路由'
            Patterns = @('programming-team-governance', '編程團隊治理', 'team-task-package', '團隊任務包')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\subagent-invocation.md'
            Severity = 'Red'
            Label = '子代理政策未接入隊長制團隊治理'
            Patterns = @('Captain Trigger Gate', 'Task Type And Dispatch Pre-Gate', 'Captain Minimum Execution Gate', 'programming-team-governance', 'coding workflow station|workflow station|隊長團隊站點板', 'Fake-team guard|假團隊防線', 'Role-exclusivity guard|角色互斥', 'isolated patch|隔離補丁', 'text patch|文字補丁', 'role boundary|角色邊界', 'direct exception|主線直做例外', 'evidence owner|證據負責', 'forces board creation first|立即建板', '隊長代工風險接受|captain substitution accepted-risk', '補丁包.*審查包.*驗證包|patch, review, and validation packets')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\delegation-strategy\SKILL.md'
            Severity = 'Red'
            Label = '委派策略未使用隊長制角色分派決策'
            Patterns = @('Captain Trigger Gate', 'Task Type And Dispatch Pre-Gate', 'Captain Minimum Execution Gate', 'Role Dispatch Gate', 'programming-team-governance', 'team-task-package', 'Captain Team Board', 'station', 'No specialist branch starts before the board exists', 'Implementation station with governed isolated workspace', 'text patch packet', 'Browser/UI verification station', 'Large CLI-only analysis station', 'Real-time tool access', 'Independent read-only evidence station after special routes are excluded', 'Direct Exception Contract', 'Isolated Patch Boundary', 'Fake-Team Guard', 'Role-Exclusivity Guard')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\quality-review-governance\SKILL.md'
            Severity = 'Yellow'
            Label = '審查治理技能未接入角色分離與證據分支規則'
            Patterns = @('Independent Review', 'Role Separation Gate', 'Programming Team Board', 'direct exception', 'All-direct review boards', 'evidence branch', 'reviewer implemented the same deliverable')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\browser-testing\SKILL.md'
            Severity = 'Yellow'
            Label = '瀏覽器測試技能未保留站點要求與主線直做例外邊界'
            Patterns = @('workflow station requires', 'concrete direct exception', 'blocked` or `unverified', 'do not silently downgrade')
        },
        [PSCustomObject]@{
            Path = 'Shared\platform-capability-matrix.md'
            Severity = 'Red'
            Label = '平台能力矩陣缺少隊長制編程治理能力'
            Patterns = @('Captain-led programming governance', '任務類型閘門', '派工前置閘門', '隊長最小執行權|Captain Minimum Execution', 'Captain Trigger Gate', 'Captain Team Board', 'team-task-package', 'Role Exclusivity', 'isolated patch', 'text patch|文字補丁', 'evidence branch', '主線直做例外|direct exception', '不允許先開代理', '補丁包.*審查包.*驗證包', '完整團隊完成|full team completion')
        },
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Severity = 'Red'
            Label = '工作流矩陣缺少隊長制編程團隊治理矩陣'
            Patterns = @('Captain-Led Programming Team Governance Matrix', 'Task Type And Dispatch Pre-Gate Matrix', 'Captain Minimum Execution Contract', 'Team Task Package Contract', 'Patch Packet Type Matrix', 'team-task-package', 'team-station board|Captain Team Board', 'task type|任務類型', 'allowed specialist roles|可出現隊員', 'forbidden specialist roles|不可出現隊員', 'evidence owner|證據負責', 'role boundary|角色邊界', 'isolated patch', 'text patch|文字補丁', 'direct exception|主線直做例外', 'Patch packet', 'Review packet', 'Validation packet', 'All-direct evidence boards are invalid', 'full team completion|完整團隊完成')
        },
        [PSCustomObject]@{
            Path = 'Shared\skill-governance.md'
            Severity = 'Yellow'
            Label = '技能治理規格未說明編程團隊治理放置規則'
            Patterns = @('programming-team-governance', 'captain trigger', 'role boundary', 'isolated patch', 'direct exception', 'all-direct evidence boards are invalid', 'must manually name a workflow')
        }
    )

    foreach ($check in $coreChecks) {
        $fullPath = Join-Path $RepoRoot $check.Path
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason '必要檔案不存在' -Text $check.Label
            continue
        }

        foreach ($pattern in $check.Patterns) {
            if ($content -notmatch $pattern) {
                Add-ProgrammingTeamFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason $check.Label -Text "missing pattern: $pattern"
            }
        }

        if (($check.Path -in @('Shared\platform-capability-matrix.md', 'Shared\policies\subagent-invocation.md', 'Shared\workflow-capability-evidence-matrix.md')) -and (-not (Test-ProgrammingTeamPacketTriadContent -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '核心治理缺少補丁包、審查包、驗證包與缺失狀態語義' -Text 'missing patch/review/validation packet triad or missing blocked/unverified/accepted-risk state'
        }

        if (($content -match 'full team completion|完整團隊完成') -and (-not (Test-ProgrammingTeamPacketTriadContent -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '宣稱完整團隊完成時缺少補丁、審查、驗證證據要求' -Text 'full team completion requires patch/review/validation packet evidence'
        }

        if (($check.Path -in @('Shared\skills\programming-team-governance\SKILL.md', 'Shared\skills\team-task-package\SKILL.md', 'Shared\skills\delegation-strategy\SKILL.md', 'Shared\workflow-capability-evidence-matrix.md')) -and (-not (Test-ProgrammingTeamImplementationDirectBounded -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '實作站點 direct 必須限於隊長整合補丁包或總監接受風險' -Text 'implementation direct must not be unrestricted captain implementation'
        }
    }

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern '\|\s*active\s*\||\|\s*optional\s*\||\|\s*as-needed\s*\||\|\s*if-needed\s*\|' `
        -Reason '團隊站點不得把 active 當成最終狀態'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'same specialist both implements and reviews.*valid|implementation specialist.*may.*review|review specialist.*may.*implement' `
        -Reason '隊長制角色不得允許同一交付物自我審查'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'spawn.*before.*board|branch.*before.*board|delegate.*before.*board|先開.*(代理|隊員|分支).*再.*(板|站點)' `
        -Reason '隊長制不得允許先開隊員再補任務板'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'captain.*direct.*(counter-evidence|impact map|review|completion audit).*default|隊長.*包辦.*(反證|影響面|審查|收尾)' `
        -Reason '隊長制不得把反證、影響面、審查與收尾稽核預設交回隊長包辦'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'evaluate each active station|Independent read-only station\?\*\*\s*->\s*`evidence branch`' `
        -Reason '委派策略不得先用一般證據分支吞掉特殊分支'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'None of above\?\*\*.*->\s*`direct`|None of above.*->\s*direct' `
        -Reason '委派策略不得保留無匹配即主線直做 fallback'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost)|主線直做.*(小型|中型|大型|必要時)|direct.*(小型|中型|大型|必要時)' `
        -Reason '委派策略不得用大小型、必要時或成本口號作為主要決策理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\team-task-package\SKILL.md' `
        -Pattern 'Single-step direct|tiny read/write step|cost more to package|allowed only for small|tiny known file set' `
        -Reason '團隊任務包不得保留單步、微小讀寫或包裝成本作為 direct 例外'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\team-task-package\SKILL.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost|tiny|single-step)|allowed only for .*?\b(tiny|single-step|small)\b|主線直做.*(小型|微小|單步|成本)' `
        -Reason '團隊任務包不得用任務大小、速度或成本口號作為主線直做例外'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'implementation.*direct.*(unrestricted|normal fallback|routine captain)|captain.*implementation.*normal fallback|實作.*主線直做.*(不受限|正常|預設)' `
        -Reason '隊長制不得允許實作站點不受限制地回到隊長直做'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\workflow-capability-evidence-matrix.md' `
        -Pattern 'implementation.*direct.*(unrestricted|normal fallback|routine captain)|實作.*主線直做.*(不受限|正常|預設)' `
        -Reason '工作流矩陣不得允許實作站點不受限制地回到隊長直做'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'subagent.*before.*board|specialist.*before.*board|隊員.*早於.*任務板' `
        -Reason '委派策略不得允許前置任務板之前啟動隊員'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'active station|每個 active' `
        -Reason '子代理政策不得保留 active station 語義'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern '委派成本高於收益|delegation cost.*direct' `
        -Reason '子代理政策不得以委派成本作為泛用主線直做理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost)|主線直做.*(小型|中型|大型|必要時)|direct.*(小型|中型|大型|必要時)' `
        -Reason '子代理政策不得用大小型、必要時或成本口號作為主要決策理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'explicitly asks for subagents.*spawns|總監.*要求.*子代理.*(直接|立即).*(開|啟動)' `
        -Reason '子代理政策不得把總監要求子代理解讀成繞過任務板'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\quality-review-governance\SKILL.md' `
        -Pattern 'Evidence branches are optional|work benefits from parallel inspection|main thread is blocked on the same answer' `
        -Reason '審查治理不得把證據分支降成可選或因主線等待而禁止'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\browser-testing\SKILL.md' `
        -Pattern 'otherwise the main Codex agent uses available Browser tooling directly' `
        -Reason '瀏覽器分支不得靜默退回主線工具'

    $delegationPath = Join-Path $RepoRoot 'Shared\skills\delegation-strategy\SKILL.md'
    $delegationContent = Get-ProgrammingTeamContent -Path $delegationPath
    if ($null -ne $delegationContent) {
        $browserIndex = $delegationContent.IndexOf('Browser/UI verification station?')
        $cliIndex = $delegationContent.IndexOf('Large CLI-only analysis station?')
        $isolatedPatchIndex = $delegationContent.IndexOf('Implementation station with governed isolated workspace')
        $mcpIndex = $delegationContent.IndexOf('Real-time tool access?')
        $evidenceIndex = $delegationContent.IndexOf('Independent read-only evidence station after special routes are excluded?')
        if (($evidenceIndex -lt 0) -or ($browserIndex -lt 0) -or ($cliIndex -lt 0) -or ($isolatedPatchIndex -lt 0) -or ($mcpIndex -lt 0)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File 'Shared\skills\delegation-strategy\SKILL.md' -Line 1 -Reason '委派策略缺少特殊分支優先順序' -Text 'browser/CLI/MCP/evidence route markers missing'
        } elseif (($evidenceIndex -lt $browserIndex) -or ($evidenceIndex -lt $cliIndex) -or ($evidenceIndex -lt $isolatedPatchIndex) -or ($evidenceIndex -lt $mcpIndex)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File 'Shared\skills\delegation-strategy\SKILL.md' -Line 1 -Reason '一般證據分支不得早於瀏覽器、CLI 或 MCP 分支' -Text 'reorder Delegation Gate'
        }
    }

    $routingChecks = @(
        'Codex\.agents\workflow-skills\00-chat-聊天\SKILL.md',
        'Codex\.agents\workflow-skills\01-explore-探索\SKILL.md',
        'Claude\.claude\commands\00_chat(討論)\SKILL.md',
        'Claude\.claude\commands\01_explore(搜索)\SKILL.md',
        'Antigravity\.agents\workflows\00_chat(討論).md',
        'Antigravity\.agents\workflows\01_explore(搜索).md'
    )

    foreach ($relPath in $routingChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '聊天或探勘入口不存在' -Text $relPath
            continue
        }
        if ($content -notmatch 'captain-led programming mode|captain-led programming trigger path|隊長制|隊長') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '聊天或探勘入口缺少編程意圖自動轉入隊長制規則' -Text $relPath
        }
        if ($content -match 'Director must.*restate|must manually name|必須手動|手動指定') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '聊天或探勘入口不得要求總監手動重述工作流名稱才觸發治理' -Text $relPath
        }
    }

    $workflowChecks = @(
        'Codex\.agents\workflow-skills\02-blueprint-架構\SKILL.md',
        'Codex\.agents\workflow-skills\03-1-experiment-實驗\SKILL.md',
        'Codex\.agents\workflow-skills\03-build-建構\SKILL.md',
        'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md',
        'Codex\.agents\workflow-skills\05-condense-濃縮\SKILL.md',
        'Codex\.agents\workflow-skills\06-test-測試\SKILL.md',
        'Codex\.agents\workflow-skills\07-debug-除錯\SKILL.md',
        'Codex\.agents\workflow-skills\08-audit-健檢\SKILL.md',
        'Codex\.agents\workflow-skills\08-1-infra-基礎盤點\SKILL.md',
        'Codex\.agents\workflow-skills\08-2-logic-深度邏輯\SKILL.md',
        'Codex\.agents\workflow-skills\08-3-report-健檢總結\SKILL.md',
        'Codex\.agents\workflow-skills\09-commit-紀錄總結\SKILL.md',
        'Codex\.agents\workflow-skills\10-routine-巡檢\SKILL.md',
        'Codex\.agents\workflow-skills\11-handoff-交接\SKILL.md',
        'Codex\.agents\workflow-skills\12-skill-forge-技能鍛造\SKILL.md',
        'Claude\.claude\commands\02_blueprint(架構)\SKILL.md',
        'Claude\.claude\commands\03-1_experiment(實驗)\SKILL.md',
        'Claude\.claude\commands\03_build(建構)\SKILL.md',
        'Claude\.claude\commands\04_fix(修復)\SKILL.md',
        'Claude\.claude\commands\05_condense（濃縮）\SKILL.md',
        'Claude\.claude\commands\06_test(測試)\SKILL.md',
        'Claude\.claude\commands\07_debug(除錯)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-1_infra\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-2_logic\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-3_report\SKILL.md',
        'Claude\.claude\commands\09_commit(紀錄)\SKILL.md',
        'Claude\.claude\commands\10_routine(巡檢)\SKILL.md',
        'Claude\.claude\commands\11_handoff(交接)\SKILL.md',
        'Claude\.claude\commands\12_skill_forge(技能鍛造)\SKILL.md',
        'Antigravity\.agents\workflows\02_blueprint(架構).md',
        'Antigravity\.agents\workflows\03-1_experiment(實驗).md',
        'Antigravity\.agents\workflows\03_build(建構計畫).md',
        'Antigravity\.agents\workflows\03-2_build_execute(建構執行).md',
        'Antigravity\.agents\workflows\04-1_fix_plan(修復計畫).md',
        'Antigravity\.agents\workflows\04-2_fix_execute(修復執行).md',
        'Antigravity\.agents\workflows\05_condense(濃縮).md',
        'Antigravity\.agents\workflows\06_test(測試).md',
        'Antigravity\.agents\workflows\07_debug(除錯).md',
        'Antigravity\.agents\workflows\08_audit(健檢).md',
        'Antigravity\.agents\workflows\08-1_audit_infra(基礎盤點).md',
        'Antigravity\.agents\workflows\08-2_audit_logic(深度邏輯).md',
        'Antigravity\.agents\workflows\08-3_audit_report(健檢總結).md',
        'Antigravity\.agents\workflows\09-1_commit_scan(紀錄掃描).md',
        'Antigravity\.agents\workflows\09-2_commit_execute(授權備份).md',
        'Antigravity\.agents\workflows\10_routine(巡檢).md',
        'Antigravity\.agents\workflows\11_handoff(交接).md',
        'Antigravity\.agents\workflows\12_skill_forge(技能鍛造).md'
    )

    foreach ($relPath in $workflowChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '三平台工作流入口不存在' -Text $relPath
            continue
        }

        if ($content -notmatch 'programming-team-governance') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口未載入編程團隊治理技能' -Text $relPath
        }
        if ($content -notmatch 'team-task-package') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口未引用團隊任務包技能' -Text $relPath
        }
        if ($content -notmatch 'Programming Team Board|Team Station|團隊站點|team-station') {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口缺少團隊站點可讀語義' -Text $relPath
        }
        if ($content -notmatch 'evidence owner|證據負責') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少證據負責人欄位' -Text $relPath
        }
        if ($content -notmatch 'direct exception|主線直做例外') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少主線直做例外欄位' -Text $relPath
        }
        if ($content -notmatch 'role boundary|角色邊界') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少角色邊界欄位' -Text $relPath
        }
        if ($content -notmatch 'isolated patch|隔離補丁') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少隔離補丁分支語義' -Text $relPath
        }
        if ($content -notmatch 'self-review|review their own|review its own|審查.*自己|自我審查') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少實作者不得自我審查規則' -Text $relPath
        }
        if ($content -notmatch 'all-direct|All-direct|all direct|全主線|全部.*直做') {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口未明示全主線假團隊防線' -Text $relPath
        }
        if ($content -match 'active Team Station|each active station|每個 active') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留 active station 語義' -Text $relPath
        }
        if ($content -match 'direct,\s*delegated,\s*blocked|mark stations direct,\s*delegated|execution mode:\s*direct,\s*delegated') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留舊版 direct/delegated 模式集合' -Text $relPath
        }
        if ($content -match 'Begin writing source code using|Apply fixes using|Physical Write|Physical Fix Execution') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留 GO 後主線直接實作語句' -Text $relPath
        }
        if (($content -match 'full team completion|完整團隊完成') -and (-not (Test-ProgrammingTeamPacketTriadContent -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口宣稱完整團隊完成時缺少補丁、審查、驗證證據要求' -Text $relPath
        }
        if ($content -match 'enter captain-minimal team mode automatically\.\s*Classify task type|No specialist branch, subagent, browser branch, CLI branch, MCP evidence route') {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口不應複製舊版隊長制長段規則，應短引用 programming-team-governance 與 team-task-package' -Text $relPath
        }
        if ($relPath -match '03-1') {
            if ($content -notmatch 'minimum (Programming|Captain) Team Board|最小.*團隊站點|team-station governance') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口缺少最小團隊站點宣告' -Text $relPath
            }
            if ($content -notmatch 'sandbox boundary|allowed change scope|discard conditions|promotion criteria') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口缺少沙盒邊界、允許改動、丟棄條件或升級條件' -Text $relPath
            }
            if ($content -match 'All quality, security, test, and memory gates are DISABLED|ALL quality, security, testing, and memory gates are \*\*DISABLED\*\*|No review gate|所有.*閘門.*停用|所有安全閘門已停用') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口不得宣稱完全停用治理' -Text $relPath
            }
        }
    }

    $sharedSkillsRoot = Join-Path $RepoRoot 'Shared\skills'
    $targetSkillRoots = @(
        [PSCustomObject]@{ Label = 'agents skills'; Root = (Join-Path $TargetRoot '.agents\skills') },
        [PSCustomObject]@{ Label = 'claude skills'; Root = (Join-Path $TargetRoot '.claude\skills') }
    )
    foreach ($target in $targetSkillRoots) {
        if (-not (Test-Path -LiteralPath $target.Root -PathType Container)) { continue }
        Get-ChildItem -LiteralPath $sharedSkillsRoot -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $rel = $_.FullName.Substring($sharedSkillsRoot.Length).TrimStart('\', '/')
                Test-AuditSharedSkillRelativePathIncluded -RelativePath $rel
            } |
            ForEach-Object {
                $rel = $_.FullName.Substring($sharedSkillsRoot.Length).TrimStart('\', '/')
                $targetFile = Join-Path $target.Root $rel
                if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                    Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason "部署技能副本缺少來源檔 ($($target.Label))" -Text $rel
                } elseif (-not (Test-AuditFileHashEqual -SourcePath $_.FullName -TargetPath $targetFile)) {
                    Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason "部署技能副本內容漂移 ($($target.Label))" -Text $rel
                }
            }
    }

    $sharedRoot = Join-Path $RepoRoot 'Shared'
    $targetSharedRoot = Join-Path $TargetRoot '.agents\shared'
    if (Test-Path -LiteralPath $targetSharedRoot -PathType Container) {
        foreach ($rel in @(Get-AuditSharedGovernanceReferenceRelativePaths -SharedRoot $sharedRoot)) {
            $sourceFile = Join-Path $sharedRoot $rel
            $targetFile = Join-Path $targetSharedRoot $rel
            if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason '部署共用治理參照缺少來源檔' -Text $rel
            } elseif (-not (Test-AuditFileHashEqual -SourcePath $sourceFile -TargetPath $targetFile)) {
                Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason '部署共用治理參照內容漂移' -Text $rel
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Programming Team Governance"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
        if ($finding.Text) {
            Write-Host ("      {0}" -f $finding.Text) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-DirectorOutputContract {
    <#
    .SYNOPSIS
        檢查面向總監的輸出契約是否覆蓋三平台 workflow 與目前專案 Codex 規則。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $contextualOutputPattern = 'context-sensitive plain-language structure|情境式'
    $routineOutputPattern = 'Routine discussion, short status updates, and simple judgments|一般討論|狀態回報|簡短判斷'
    $formalOutputPattern = 'Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs|正式計畫|寫入前風險|多檔案變更|完成報告|健檢報告|交接'
    $compactTablePattern = '事項\s*\|\s*位置\s*\|\s*影響\s*\|\s*狀態'
    $preciseLocationPattern = 'The `位置` column MUST name the concrete location|位置欄.*具體|file path, section heading, tool/status scope, or directory scope|檔案.*區塊.*工具.*目錄'
    $locationIndexPattern = '位置索引|compact scope labels|abstract labels.*MUST be resolved|compact label.*concrete file'
    $technicalVocabularyPattern = 'Technical Vocabulary Translation Gate|技術詞彙翻譯閘門'
    $technicalVocabularyStrictPatterns = @(
        @{
            Pattern = 'technical identifier only inside parentheses|技術名稱.*括號'
            Label = '技術詞彙括號順序規則'
        },
        @{
            Pattern = 'standalone subjects|單獨.*主詞'
            Label = '技術詞彙不得單獨出現規則'
        }
    )
    $neutralHonestPattern = 'neutral, honest stance|中立誠實協作契約|中立誠實協作與知識新鮮度契約'
    $nonAppeasementPattern = 'pleasing, flattering, appeasing|討好.*附和.*迎合|不討好.*不附和'
    $nonContrarianPattern = 'Do not object merely to appear critical|刻意反對'
    $shortEvidencePattern = '我看到的事實.*可能問題.*建議做法'
    $knowledgeFreshnessPattern = 'memory and internal model knowledge as possibly stale|內建知識.*過時|記憶.*過時'
    $highChangeGroundingPattern = 'high-change information|外部框架.*API.*套件版本|official documentation or primary sources|官方.*最新'
    $verificationAnchorPattern = 'project version first|current date/year|版本.*目前日期|版本.*時間錨'

    function Get-DirectorDisplayPath {
        param([string]$Path)

        $full = $Path
        if (Test-Path -LiteralPath $Path) {
            $full = (Resolve-Path -LiteralPath $Path).Path
        }

        if ($full.StartsWith($RepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $full.Substring($RepoRoot.Length).TrimStart('\', '/')
        }
        if ($full.StartsWith($TargetRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            return ("target:{0}" -f $full.Substring($TargetRoot.Length).TrimStart('\', '/'))
        }
        return $full
    }

    function Add-DirectorFinding {
        param(
            [string]$Severity,
            [string]$File,
            [string]$Reason
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Reason   = $Reason
        })
    }

    foreach ($target in (Get-DirectorOutputContractTargets -RepoRoot $RepoRoot -TargetRoot $TargetRoot)) {
        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $missing = @()
        if ($content -notmatch $contextualOutputPattern) { $missing += '情境式輸出規則' }
        if ($content -notmatch $routineOutputPattern) { $missing += '日常情境免表格規則' }
        if ($content -notmatch $formalOutputPattern) { $missing += '正式情境結構化規則' }
        if ($content -notmatch $compactTablePattern) { $missing += '精簡表格欄位' }
        if ($content -notmatch $preciseLocationPattern) { $missing += '位置欄精準定位規則' }
        if ($content -notmatch $locationIndexPattern) { $missing += '位置索引規則' }
        if ($content -notmatch '補充技術細節') { $missing += '補充技術細節' }
        if ($content -notmatch $technicalVocabularyPattern) { $missing += '技術詞彙翻譯閘門' }
        foreach ($strictPattern in $technicalVocabularyStrictPatterns) {
            if ($content -notmatch $strictPattern.Pattern) { $missing += $strictPattern.Label }
        }
        if ($content -notmatch $neutralHonestPattern) { $missing += '中立誠實協作契約' }
        if ($content -notmatch $nonAppeasementPattern) { $missing += '不討好不附和規則' }
        if ($content -notmatch $nonContrarianPattern) { $missing += '不刻意反對規則' }
        if ($content -notmatch $shortEvidencePattern) { $missing += '短證據衝突格式' }
        if ($content -notmatch $knowledgeFreshnessPattern) { $missing += '知識新鮮度規則' }
        if ($content -notmatch $highChangeGroundingPattern) { $missing += '高變動資訊查證規則' }
        if ($content -notmatch $verificationAnchorPattern) { $missing += '版本與日期錨定規則' }
        if ($missing.Count -gt 0) {
            Add-DirectorFinding -Severity 'Red' `
                -File (Get-DirectorDisplayPath -Path $target.Path) `
                -Reason ("{0}/{1} 缺少總監可讀輸出契約：{2}" -f $target.Platform, $target.Scope, ($missing -join ', '))
        }
    }

    $sourceCodexAgents = Join-Path $RepoRoot 'Codex\.codex\AGENTS.md'
    $targetCodexAgents = Join-Path $TargetRoot '.codex\AGENTS.md'
    if (Test-Path -LiteralPath $sourceCodexAgents) {
        if (-not (Test-Path -LiteralPath $targetCodexAgents)) {
            Add-DirectorFinding -Severity 'Red' `
                -File (Get-DirectorDisplayPath -Path $targetCodexAgents) `
                -Reason '目前專案缺少 .codex/AGENTS.md，Codex 無法載入專案治理規則'
        } else {
            $sourceContent = Get-Content -LiteralPath $sourceCodexAgents -Raw -Encoding UTF8
            $targetContent = Get-Content -LiteralPath $targetCodexAgents -Raw -Encoding UTF8
            $requiredMarkers = @(
                'Director-Readable Output Contract',
                'context-sensitive plain-language structure',
                'Routine discussion, short status updates',
                'Implementation plans, pre-write risk reviews',
                '事項 | 位置 | 影響 | 狀態',
                'The `位置` column MUST name the concrete location',
                '位置索引',
                'compact scope labels',
                'abstract labels',
                '補充技術細節',
                '技術詞彙翻譯閘門',
                'technical identifier only inside parentheses',
                'standalone subjects',
                'neutral, honest stance',
                'pleasing, flattering, appeasing',
                'Support proposals when evidence and feasibility align',
                'Do not object merely to appear critical',
                '我看到的事實',
                'memory and internal model knowledge as possibly stale',
                'high-change information',
                'official documentation or primary sources',
                'current date/year'
            )
            foreach ($marker in $requiredMarkers) {
                if (($sourceContent -match [regex]::Escape($marker)) -and ($targetContent -notmatch [regex]::Escape($marker))) {
                    Add-DirectorFinding -Severity 'Red' `
                        -File (Get-DirectorDisplayPath -Path $targetCodexAgents) `
                        -Reason "目前專案 .codex/AGENTS.md 與 source 漂移，缺少：$marker"
                }
            }

            $isEquivalent = Test-RuleTextEquivalent `
                -SourcePath $sourceCodexAgents `
                -TargetPath $targetCodexAgents `
                -IgnoreProjectIdentity
            $hasStrictTechnicalVocabularyContract = $targetContent -match $technicalVocabularyPattern
            foreach ($strictPattern in $technicalVocabularyStrictPatterns) {
                if ($targetContent -notmatch $strictPattern.Pattern) {
                    $hasStrictTechnicalVocabularyContract = $false
                }
            }
            $hasContextualOutputContract = (
                $targetContent -match $contextualOutputPattern -and
                $targetContent -match $routineOutputPattern -and
                $targetContent -match $formalOutputPattern -and
                $targetContent -match $compactTablePattern -and
                $targetContent -match $preciseLocationPattern -and
                $targetContent -match $locationIndexPattern -and
                $targetContent -match '補充技術細節'
            )
            $hasNeutralHonestFreshnessContract = (
                $targetContent -match $neutralHonestPattern -and
                $targetContent -match $nonAppeasementPattern -and
                $targetContent -match $nonContrarianPattern -and
                $targetContent -match $shortEvidencePattern -and
                $targetContent -match $knowledgeFreshnessPattern -and
                $targetContent -match $highChangeGroundingPattern -and
                $targetContent -match $verificationAnchorPattern
            )
            if (-not $isEquivalent -and $hasContextualOutputContract -and $hasStrictTechnicalVocabularyContract -and $hasNeutralHonestFreshnessContract) {
                Add-DirectorFinding -Severity 'Yellow' `
                    -File (Get-DirectorDisplayPath -Path $targetCodexAgents) `
                    -Reason '目前專案 .codex/AGENTS.md 與 source 框架內容不同，請確認是否為本地客製'
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Director Output Contract"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} — {2}" -f $finding.Severity, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-ProjectSkillLinks {
    <#
    .SYNOPSIS
        檢查 project skill 原檔與 discovery 連結是否維持隔離設計。
    #>
    param([string]$TargetRoot = ".")

    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $projectSkillsRoot = Join-Path $TargetRoot '.agents\project_skills'
    $projectSkills = @()
    $allowedSharedProjectPrefixedSkills = @('project-context-protocol')

    if (Test-Path -LiteralPath $projectSkillsRoot) {
        $projectSkills = @(Get-ChildItem -LiteralPath $projectSkillsRoot -Directory -Force -ErrorAction SilentlyContinue |
            Where-Object { ($_.Name -notmatch '^_') -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')) } |
            ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Path = $_.FullName } })
    }

    $discoveryRoots = @(
        [PSCustomObject]@{ Name = '.agents/skills'; Path = (Join-Path $TargetRoot '.agents\skills') },
        [PSCustomObject]@{ Name = '.claude/skills'; Path = (Join-Path $TargetRoot '.claude\skills') }
    )

    function Get-ProjectLinkTarget {
        param($Item)
        $target = $null
        if ($Item -and ($Item.PSObject.Properties.Name -contains 'Target')) {
            $target = $Item.Target
        } elseif ($Item -and ($Item.PSObject.Properties.Name -contains 'LinkTarget')) {
            $target = $Item.LinkTarget
        }
        if ($target -is [array]) { $target = $target[0] }
        if ($target) { return [string]$target }
        return ''
    }

    function Get-ProjectLinkFullPath {
        param([string]$Path)
        if (-not $Path) { return '' }
        try {
            return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path.TrimEnd('\', '/')
        } catch {
            return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        }
    }

    function Test-ProjectLinkPathEquals {
        param(
            [string]$Left,
            [string]$Right
        )
        if (-not $Left -or -not $Right) { return $false }
        return [string]::Equals((Get-ProjectLinkFullPath -Path $Left), (Get-ProjectLinkFullPath -Path $Right), [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Test-ProjectLinkUnderRoot {
        param(
            [string]$Path,
            [string]$Root
        )
        if (-not $Path -or -not $Root) { return $false }
        $full = Get-ProjectLinkFullPath -Path $Path
        $rootFull = Get-ProjectLinkFullPath -Path $Root
        return $full.StartsWith($rootFull + '\', [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Add-ProjectLinkFinding {
        param(
            [string]$Severity,
            [string]$DiscoveryRoot,
            [string]$Link,
            [string]$ExpectedTarget,
            [string]$Target,
            [string]$Reason
        )

        $null = $results.Add([PSCustomObject]@{
            Severity       = $Severity
            DiscoveryRoot  = $DiscoveryRoot
            Link           = $Link
            ExpectedTarget = $ExpectedTarget
            Target         = $Target
            Reason         = $Reason
        })
    }

    function Test-ProjectSkillEntry {
        param(
            [string]$DiscoveryRoot,
            [string]$LinkPath,
            $Entry,
            [string]$ExpectedTarget = ''
        )

        if (-not $Entry) {
            Add-ProjectLinkFinding -Severity 'Yellow' -DiscoveryRoot $DiscoveryRoot -Link $LinkPath -ExpectedTarget $ExpectedTarget -Target '' -Reason '缺少 project skill discovery 連結'
            return
        }

        $isReparsePoint = [bool]($Entry.Attributes -band [IO.FileAttributes]::ReparsePoint)
        if (-not $isReparsePoint) {
            Add-ProjectLinkFinding -Severity 'Red' -DiscoveryRoot $DiscoveryRoot -Link $Entry.FullName -ExpectedTarget $ExpectedTarget -Target '' -Reason 'project-* 必須是 SymbolicLink 或 Junction，不可為實體目錄/檔案'
            return
        }

        $target = Get-ProjectLinkTarget -Item $Entry
        if (-not $target -or -not (Test-Path -LiteralPath $target)) {
            Add-ProjectLinkFinding -Severity 'Yellow' -DiscoveryRoot $DiscoveryRoot -Link $Entry.FullName -ExpectedTarget $ExpectedTarget -Target $target -Reason 'project skill 連結目標不存在'
            return
        }

        if (-not (Test-ProjectLinkUnderRoot -Path $target -Root $projectSkillsRoot)) {
            Add-ProjectLinkFinding -Severity 'Red' -DiscoveryRoot $DiscoveryRoot -Link $Entry.FullName -ExpectedTarget $ExpectedTarget -Target $target -Reason 'project skill 連結目標不在 .agents/project_skills/ 內'
            return
        }

        if ($ExpectedTarget -and -not (Test-ProjectLinkPathEquals -Left $target -Right $ExpectedTarget)) {
            Add-ProjectLinkFinding -Severity 'Red' -DiscoveryRoot $DiscoveryRoot -Link $Entry.FullName -ExpectedTarget $ExpectedTarget -Target $target -Reason 'project skill 連結指向非對應原檔目錄'
            return
        }

        if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md'))) {
            Add-ProjectLinkFinding -Severity 'Yellow' -DiscoveryRoot $DiscoveryRoot -Link $Entry.FullName -ExpectedTarget $ExpectedTarget -Target $target -Reason 'project skill 目標缺少 SKILL.md'
            return
        }
    }

    $checkedLinks = @()
    foreach ($root in $discoveryRoots) {
        foreach ($projectSkill in $projectSkills) {
            $linkPath = Join-Path $root.Path "project-$($projectSkill.Name)"
            $checkedLinks += (Get-ProjectLinkFullPath -Path $linkPath).ToLowerInvariant()
            $entry = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
            Test-ProjectSkillEntry -DiscoveryRoot $root.Name -LinkPath $linkPath -Entry $entry -ExpectedTarget $projectSkill.Path
        }

        if (Test-Path -LiteralPath $root.Path) {
            Get-ChildItem -LiteralPath $root.Path -Force -ErrorAction SilentlyContinue |
                Where-Object { ($_.Name -match '^project-') -and ($allowedSharedProjectPrefixedSkills -notcontains $_.Name) } |
                ForEach-Object {
                    $full = (Get-ProjectLinkFullPath -Path $_.FullName).ToLowerInvariant()
                    if ($checkedLinks -notcontains $full) {
                        $beforeCount = $results.Count
                        Test-ProjectSkillEntry -DiscoveryRoot $root.Name -LinkPath $_.FullName -Entry $_
                        if ($results.Count -eq $beforeCount) {
                            Add-ProjectLinkFinding -Severity 'Yellow' -DiscoveryRoot $root.Name -Link $_.FullName -ExpectedTarget '' -Target (Get-ProjectLinkTarget -Item $_) -Reason '多餘 project skill discovery 連結，未對應有效 project skill 原檔'
                        }
                    }
                }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Project Skill Links"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, DiscoveryRoot, Link) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} {2} — {3}" -f $finding.Severity, $finding.DiscoveryRoot, $finding.Link, $finding.Reason) -ForegroundColor $color
        if ($finding.ExpectedTarget) {
            Write-Host ("      expected: {0}" -f $finding.ExpectedTarget) -ForegroundColor DarkGray
        }
        if ($finding.Target) {
            Write-Host ("      target: {0}" -f $finding.Target) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-ProjectContextCards {
    <#
    .SYNOPSIS
        檢查專案脈絡卡格式、核准紀錄、衝突狀態與誤放位置。
    #>
    param(
        [string]$TargetRoot = ".",
        [int]$CandidateReviewDays = 90
    )

    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.Generic.List[object]
    $contextRoot = Join-Path $TargetRoot ".agents\context"
    $memoryRoot = Join-Path $TargetRoot ".agents\memory"
    $requiredFields = @(
        'name',
        'description',
        'context_type',
        'scope',
        'status',
        'confidence',
        'last_reviewed',
        'approval',
        'sources'
    )
    $allowedStatuses = @('candidate', 'approved', 'deprecated', 'conflict', 'review')
    $requiredSections = @(
        'Approved Context',
        'Candidate Context',
        'Deprecated Context',
        'Conflicts',
        'Evidence',
        'Relations',
        'Promotion Notes'
    )

    function Add-ProjectContextFinding {
        param(
            [string]$Severity,
            [string]$File,
            [string]$Reason
        )
        $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Reason   = $Reason
        })
    }

    if (Test-Path -LiteralPath $memoryRoot) {
        $misplaced = @(Get-ChildItem -LiteralPath $memoryRoot -Filter 'CONTEXT.md' -File -Recurse -ErrorAction SilentlyContinue)
        foreach ($file in $misplaced) {
            Add-ProjectContextFinding -Severity 'Red' `
                -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file.FullName) `
                -Reason '脈絡卡誤放在原始碼記憶目錄'
        }
    }

    if (-not (Test-Path -LiteralPath $contextRoot)) {
        Add-ProjectContextFinding -Severity 'Yellow' -File '.agents/context/' -Reason '尚未建立專案脈絡目錄'
    } else {
        $cards = @(Get-ChildItem -LiteralPath $contextRoot -Filter 'CONTEXT.md' -File -Recurse -ErrorAction SilentlyContinue)
        if ($cards.Count -eq 0) {
            Add-ProjectContextFinding -Severity 'Yellow' -File '.agents/context/' -Reason '尚未建立任何脈絡卡'
        }

        foreach ($card in $cards) {
            $relative = Get-AuditRelativePath -RepoRoot $TargetRoot -Path $card.FullName
            $content = Get-Content -LiteralPath $card.FullName -Raw -Encoding UTF8
            $fm = Get-FrontmatterBlock -Path $card.FullName
            if ([string]::IsNullOrWhiteSpace($fm)) {
                Add-ProjectContextFinding -Severity 'Red' -File $relative -Reason '缺少 frontmatter'
                continue
            }

            foreach ($field in $requiredFields) {
                if ($fm -notmatch "(?m)^\s*$([regex]::Escape($field))\s*:") {
                    Add-ProjectContextFinding -Severity 'Red' -File $relative -Reason "缺少必要欄位 $field"
                }
            }

            $status = (Get-AuditFrontmatterFieldValue -Frontmatter $fm -Field 'status').ToLowerInvariant()
            if ($status -and ($allowedStatuses -notcontains $status)) {
                Add-ProjectContextFinding -Severity 'Red' -File $relative -Reason "不支援的狀態 $status"
            }

            foreach ($section in $requiredSections) {
                if ($content -notmatch "(?m)^##\s+$([regex]::Escape($section))\s*$") {
                    Add-ProjectContextFinding -Severity 'Red' -File $relative -Reason "缺少必要章節 $section"
                }
            }

            $approval = Get-AuditFrontmatterFieldValue -Frontmatter $fm -Field 'approval'
            if ($status -eq 'approved' -and ($approval -match '^\s*(none|null|\[\]|pending)?\s*$')) {
                Add-ProjectContextFinding -Severity 'Yellow' -File $relative -Reason '已核准脈絡缺少核准紀錄'
            }

            if ($status -eq 'conflict') {
                Add-ProjectContextFinding -Severity 'Yellow' -File $relative -Reason '衝突脈絡仍待總監決策'
            }

            if ($status -eq 'review') {
                Add-ProjectContextFinding -Severity 'Yellow' -File $relative -Reason '脈絡卡處於 review 狀態，使用時需標註風險'
            }

            $lastReviewed = Get-AuditFrontmatterFieldValue -Frontmatter $fm -Field 'last_reviewed'
            if ($status -eq 'candidate' -and $lastReviewed) {
                $reviewDate = [datetime]::MinValue
                if ([datetime]::TryParse($lastReviewed, [ref]$reviewDate)) {
                    if (((Get-Date) - $reviewDate).TotalDays -gt $CandidateReviewDays) {
                        Add-ProjectContextFinding -Severity 'Yellow' -File $relative -Reason "候選脈絡超過 $CandidateReviewDays 天未處理"
                    }
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Project Context Cards"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} — {2}" -f $finding.Severity, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-MemoryCardNaming {
    <#
    .SYNOPSIS
        檢查 .agents/memory/ 內作用中記憶卡主檔命名、基本結構與內容品質欄位，僅掃描記憶庫，不掃描技能目錄。
    #>
    param([string]$TargetRoot = ".")

    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.Generic.List[object]
    $memoryRoot = Join-Path $TargetRoot ".agents\memory"
    $requiredFrontmatterFields = @('name', 'description', 'status', 'staleness', 'memory_schema_version')
    $qualityFrontmatterFields = @(
        'memory_quality_version',
        'memory_kind',
        'verification_status',
        'last_verified',
        'valid_scope'
    )
    $requiredSections = @(
        'Current Truth',
        'Active Constraints',
        'Cycle Events',
        'Archive Index',
        '中文摘要',
        'Tracked Files'
    )
    $qualitySections = @(
        'Evidence Base',
        'Read Contract',
        'Conflicts and Supersession'
    )

    function Add-MemoryNamingFinding {
        param(
            [string]$Severity,
            [string]$File,
            [string]$Reason
        )
        $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Reason   = $Reason
        })
    }

    if (-not (Test-Path -LiteralPath $memoryRoot -PathType Container)) {
        Add-MemoryNamingFinding -Severity 'Yellow' -File '.agents/memory/' -Reason '尚未建立專案記憶目錄'
    } else {
        $memoryDirs = New-Object System.Collections.Generic.List[object]
        $memoryDirs.Add((Get-Item -LiteralPath $memoryRoot))
        Get-ChildItem -LiteralPath $memoryRoot -Directory -Recurse -ErrorAction SilentlyContinue |
            Sort-Object FullName |
            ForEach-Object { $memoryDirs.Add($_) }

        foreach ($dir in $memoryDirs) {
            $legacyFile = Join-Path $dir.FullName 'SKILL.md'
            $currentFile = Join-Path $dir.FullName 'MEMORY.md'
            $hasLegacy = Test-Path -LiteralPath $legacyFile -PathType Leaf
            $hasCurrent = Test-Path -LiteralPath $currentFile -PathType Leaf
            if (-not $hasLegacy -and -not $hasCurrent) { continue }

            $mainFile = if ($hasCurrent) { $currentFile } else { $legacyFile }
            $relative = Get-AuditRelativePath -RepoRoot $TargetRoot -Path $mainFile

            if ($hasLegacy -and $hasCurrent) {
                Add-MemoryNamingFinding -Severity 'Red' -File $relative -Reason '同一記憶卡資料夾同時存在 SKILL.md 與 MEMORY.md'
            } elseif ($hasLegacy) {
                Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason '作用中記憶卡仍使用舊主檔名稱；請用記憶主檔遷移工具規劃更名'
            }

            $frontmatter = Get-FrontmatterBlock -Path $mainFile
            if (-not $frontmatter) {
                Add-MemoryNamingFinding -Severity 'Red' -File $relative -Reason '作用中記憶主檔缺少 frontmatter'
            } else {
                foreach ($field in $requiredFrontmatterFields) {
                    if ($frontmatter -notmatch "(?m)^$([regex]::Escape($field))\s*:") {
                        Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason "作用中記憶主檔缺少前置欄位：$field"
                    }
                }
                foreach ($field in $qualityFrontmatterFields) {
                    if ($frontmatter -notmatch "(?m)^$([regex]::Escape($field))\s*:") {
                        Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason "作用中記憶主檔缺少內容品質欄位：$field"
                    }
                }
            }

            $content = Get-Content -LiteralPath $mainFile -Raw -Encoding UTF8
            foreach ($section in $requiredSections) {
                if ($content -notmatch "(?m)^##\s+$([regex]::Escape($section))\s*$") {
                    Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason "作用中記憶主檔缺少必要段落：$section"
                }
            }
            foreach ($section in $qualitySections) {
                if ($content -notmatch "(?m)^##\s+$([regex]::Escape($section))\s*$") {
                    Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason "作用中記憶主檔缺少內容品質段落：$section"
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Memory Card Naming, Structure, and Quality"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} — {2}" -f $finding.Severity, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-SharedContextTemplates {
    <#
    .SYNOPSIS
        檢查 Shared/context/ 是否提供可部署的專案脈絡模板。
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $results = New-Object System.Collections.Generic.List[object]
    $templateFile = Join-Path $RepoRoot "Shared\context\_map\CONTEXT.md"
    $requiredFields = @(
        'name',
        'description',
        'context_type',
        'scope',
        'status',
        'confidence',
        'last_reviewed',
        'approval',
        'sources'
    )
    $requiredSections = @(
        'Approved Context',
        'Candidate Context',
        'Deprecated Context',
        'Conflicts',
        'Evidence',
        'Relations',
        'Promotion Notes'
    )

    function Add-SharedContextTemplateFinding {
        param(
            [string]$Severity,
            [string]$File,
            [string]$Reason
        )
        $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Reason   = $Reason
        })
    }

    if (-not (Test-Path -LiteralPath $templateFile)) {
        Add-SharedContextTemplateFinding -Severity 'Red' -File 'Shared/context/_map/CONTEXT.md' -Reason '缺少共用專案脈絡索引模板'
    } else {
        $relative = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $templateFile
        $content = Get-Content -LiteralPath $templateFile -Raw -Encoding UTF8
        $fm = Get-FrontmatterBlock -Path $templateFile

        if ([string]::IsNullOrWhiteSpace($fm)) {
            Add-SharedContextTemplateFinding -Severity 'Red' -File $relative -Reason '共用脈絡模板缺少 frontmatter'
        } else {
            foreach ($field in $requiredFields) {
                if ($fm -notmatch "(?m)^\s*$([regex]::Escape($field))\s*:") {
                    Add-SharedContextTemplateFinding -Severity 'Red' -File $relative -Reason "共用脈絡模板缺少必要欄位 $field"
                }
            }
        }

        foreach ($section in $requiredSections) {
            if ($content -notmatch "(?m)^##\s+$([regex]::Escape($section))\s*$") {
                Add-SharedContextTemplateFinding -Severity 'Red' -File $relative -Reason "共用脈絡模板缺少必要章節 $section"
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 Shared Context Templates"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} — {2}" -f $finding.Severity, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Invoke-PlatformGovernanceAudit {
    <#
    .SYNOPSIS
        執行三平台代理治理巡檢：能力矩陣、workflow metadata、MCP profile、文件數字與記憶漂移。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$ProfileRoot = $env:USERPROFILE,
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    Write-Host ""
    Write-Host "🧭 三平台代理治理巡檢"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "TargetRoot：$TargetRoot"

    $capability = Measure-PlatformCapability -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $metadata = Measure-WorkflowMetadata -RepoRoot $RepoRoot
    $skillQuality = Measure-SkillQuality -SkillsRoot (Join-Path $RepoRoot 'Shared\skills')
    $docs = Measure-DocsConsistency -RepoRoot $RepoRoot
    $runtime = Measure-RuntimeGlobalDrift -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
    $semantics = Measure-GovernanceSemantics -RepoRoot $RepoRoot
    $reviewGovernance = Measure-ReviewGovernanceCoverage -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $programmingTeamGovernance = Measure-ProgrammingTeamGovernanceCoverage -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $subagentPolicy = Measure-SharedSubagentPolicyDrift -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $subagentVocabulary = Measure-SubagentVocabularyDrift -RepoRoot $RepoRoot
    $directorOutput = Measure-DirectorOutputContract -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $projectLinks = Measure-ProjectSkillLinks -TargetRoot $TargetRoot
    $sharedContextTemplates = Measure-SharedContextTemplates -RepoRoot $RepoRoot
    $projectContext = Measure-ProjectContextCards -TargetRoot $TargetRoot
    $memoryNaming = Measure-MemoryCardNaming -TargetRoot $TargetRoot

    $metadataFail = ($metadata | Where-Object { $_.Status -eq '🔴' }).Count
    $metadataYellow = ($metadata | Where-Object { $_.Status -eq '🟡' }).Count
    $skillRed = ($skillQuality | Where-Object { $_.OverallStatus -eq '🔴' }).Count
    $skillYellow = ($skillQuality | Where-Object { $_.OverallStatus -eq '🟡' }).Count
    $docStale = $docs.StaleHits.Count
    $redTotal = $runtime.RedCount + $semantics.RedCount + $reviewGovernance.RedCount + $programmingTeamGovernance.RedCount + $subagentPolicy.RedCount + $subagentVocabulary.RedCount + $directorOutput.RedCount + $projectLinks.RedCount + $sharedContextTemplates.RedCount + $projectContext.RedCount + $memoryNaming.RedCount
    $redTotal += $skillRed
    $yellowTotal = $runtime.YellowCount + $semantics.YellowCount + $reviewGovernance.YellowCount + $programmingTeamGovernance.YellowCount + $subagentPolicy.YellowCount + $subagentVocabulary.YellowCount + $directorOutput.YellowCount + $projectLinks.YellowCount + $sharedContextTemplates.YellowCount + $projectContext.YellowCount + $memoryNaming.YellowCount
    $yellowTotal += $metadataYellow + $skillYellow
    $ok = $capability.CapabilityMatrix -and $capability.WorkflowMatrix -and $capability.TargetSharedRefs -and $capability.TargetCodexSupport -and $capability.ProjectToolSource -and $capability.TargetProjectTools -and $capability.McpProfiles -and $capability.MemoryMigrationManager -and $capability.MemoryMigrationExtension -and ($metadataFail -eq 0) -and ($skillRed -eq 0) -and ($docStale -eq 0) -and ($redTotal -eq 0)

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if ($ok -and ($yellowTotal -eq 0)) {
        Write-Host "✅ 平台代理治理巡檢通過"
    } else {
        Write-Host "⚠️ 平台代理治理巡檢有待處理項目" -ForegroundColor Yellow
    }

    return [PSCustomObject]@{
        Capability = $capability
        Metadata   = $metadata
        SkillQuality = $skillQuality
        Docs       = $docs
        Runtime    = $runtime
        Semantics  = $semantics
        ReviewGovernance = $reviewGovernance
        ProgrammingTeamGovernance = $programmingTeamGovernance
        SubagentPolicy = $subagentPolicy
        SubagentVocabulary = $subagentVocabulary
        DirectorOutput = $directorOutput
        ProjectLinks = $projectLinks
        SharedContextTemplates = $sharedContextTemplates
        ProjectContext = $projectContext
        MemoryNaming = $memoryNaming
        RedCount   = $redTotal
        YellowCount = $yellowTotal
        Passed     = $ok
    }
}

Export-ModuleMember -Function Invoke-DocScan, Invoke-HealthAudit, Measure-SkillQuality, Measure-WorkflowMetadata, Measure-DocsConsistency, Measure-PlatformCapability, Measure-RuntimeGlobalDrift, Measure-SharedSubagentPolicyDrift, Measure-SubagentVocabularyDrift, Measure-GovernanceSemantics, Measure-ReviewGovernanceCoverage, Measure-ProgrammingTeamGovernanceCoverage, Measure-DirectorOutputContract, Measure-ProjectSkillLinks, Measure-SharedContextTemplates, Measure-ProjectContextCards, Measure-MemoryCardNaming, Invoke-PlatformGovernanceAudit
