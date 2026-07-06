# Internal partial for Audit.psm1. Loaded by the facade only.
# Legacy scan entry points

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
