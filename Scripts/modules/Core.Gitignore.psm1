# .gitignore configuration maintenance.

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
    try { return (New-Object System.Text.UTF8Encoding -ArgumentList $false, $true).GetString($bytes) }
    catch { return (Get-AiRulesLegacyTextEncoding).GetString($bytes) }
}

function Get-AiRulesLegacyTextEncoding {
    try {
        Add-Type -AssemblyName System.Text.Encoding.CodePages -ErrorAction SilentlyContinue
        [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance)
        return [System.Text.Encoding]::GetEncoding(0)
    } catch { return [System.Text.Encoding]::Default }
}

function Set-AiRulesTextFileContent {
    param([string]$Path, [AllowNull()][string]$Content)
    if ($null -eq $Content) { $Content = "" }
    $encoding = New-Object System.Text.UTF8Encoding -ArgumentList $true
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Get-AiRulesGitignoreStandardPatterns {
    return @(
        "/.codex/", "/.claude/", "/CLAUDE.md", "/antigravity_export/", "/.agents/*",
        "!/.agents/memory/", "!/.agents/memory/**", "!/.agents/context/", "!/.agents/context/**",
        "!/.agents/project_skills/", "!/.agents/project_skills/**", "/.agents/logs/", "/.cartridge/"
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
    if ($normalized.StartsWith("!")) { $negated = $true; $normalized = $normalized.Substring(1) }
    $normalized = $normalized.TrimStart("/")
    while ($normalized.StartsWith("**/")) { $normalized = $normalized.Substring(3) }
    $normalized = $normalized -replace "/\*\*$", "/"
    if ($negated) { return "!$normalized" }
    return $normalized
}

function Get-AiRulesGitignoreManagedBlock {
    param([string[]]$AdditionalLines = @())
    $standardKeys = @(Get-AiRulesGitignoreStandardPatterns | ForEach-Object { Get-AiRulesGitignorePatternKey -Pattern $_ })
    $additional = @($AdditionalLines | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_) -and -not ($_.Trim().StartsWith("#")) -and
        -not ((Get-AiRulesGitignorePatternKey -Pattern $_) -in $standardKeys)
    } | Select-Object -Unique)
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# [啟用][AI Rules 框架] 由框架初始化或升級產生，可重建，不進版控")
    $lines.Add("/.codex/"); $lines.Add("/.claude/"); $lines.Add("/CLAUDE.md"); $lines.Add("/antigravity_export/"); $lines.Add("")
    $lines.Add("# [啟用][代理框架] 代理規則、工作流與共用技能多為部署產物，預設不進版控"); $lines.Add("/.agents/*"); $lines.Add("")
    $lines.Add("# [保留][專案記憶] 原始碼記憶是專案知識資產，必須允許進版控"); $lines.Add("!/.agents/memory/"); $lines.Add("!/.agents/memory/**"); $lines.Add("")
    $lines.Add("# [保留][專案脈絡] 設計 DNA、產品偏好與驗收偏好是專案知識資產，必須允許進版控"); $lines.Add("!/.agents/context/"); $lines.Add("!/.agents/context/**"); $lines.Add("")
    $lines.Add("# [保留][專案衍生技能] 專案專屬技能屬於專案能力，必須允許進版控"); $lines.Add("!/.agents/project_skills/"); $lines.Add("!/.agents/project_skills/**"); $lines.Add("")
    $lines.Add("# [啟用][執行狀態] 代理日誌與本地索引是執行期產物，不進版控"); $lines.Add("/.agents/logs/"); $lines.Add("/.cartridge/")
    if ($additional.Count -gt 0) {
        $lines.Add(""); $lines.Add("# [啟用][其他] 專案額外要求的 AI Rules 排除項目")
        foreach ($line in $additional) { $lines.Add($line.Trim()) }
    }
    return @($lines)
}

function Test-GitignoreExactPatternPresent {
    param([string[]]$ExistingLines, [string]$Pattern)
    $target = ($Pattern -replace "\\", "/").Trim()
    foreach ($line in $ExistingLines) {
        $candidate = ($line -replace "\\", "/").Trim()
        if ($candidate -eq $target) { return $true }
    }
    return $false
}

function Test-AiRulesGitignoreRelatedPattern { param([string]$Line) return (Test-AiRulesGitignoreSimilarPattern -Line $Line) }

function Test-AiRulesGitignoreSimilarPattern {
    param([string]$Line)
    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("#")) { return $false }
    if (Test-AiRulesGitignoreStandardPattern -Line $trimmed) { return $false }
    $key = Get-AiRulesGitignorePatternKey -Pattern $trimmed
    $similarKeys = @(
        ".codex", ".codex/", ".claude", ".claude/", "CLAUDE.md", "antigravity_export", "antigravity_export/",
        ".agents", ".agents/", ".agents/*", ".agents/logs", ".agents/logs/", ".cartridge", ".cartridge/",
        "!.agents/memory", "!.agents/memory/", "!.agents/context", "!.agents/context/",
        "!.agents/project_skills", "!.agents/project_skills/"
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

function Remove-AiRulesGitignoreRelatedLines { param([string]$Content) return Remove-AiRulesGitignoreSimilarLines -Content $Content }

function Get-AiRulesGitignoreReport {
    param([string]$ProjectRoot)
    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    $content = ""
    if (Test-Path -LiteralPath $gitignorePath) { $content = Get-AiRulesTextFileContent -Path $gitignorePath }
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
        Path = $gitignorePath; Exists = (Test-Path -LiteralPath $gitignorePath); HasManagedBlock = $false
        MissingPatterns = $missing; RelatedPatterns = $similar; SimilarPatterns = $similar; BroadPatterns = $broad
    }
}

function Set-GitignoreEntries {
    param([string]$ProjectRoot, [string[]]$Lines = @())
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
    $newContent = if ($cleanContent.Length -gt 0) { $cleanContent + $newline + $newline } else { "" }
    $newContent += ($managedBlock -join $newline) + $newline
    if ($newContent -eq $content) { Write-Step ".gitignore AI Rules 標準規則已是最新"; return }
    Set-AiRulesTextFileContent -Path $gitignorePath -Content $newContent
    Write-Ok ".gitignore 已補入 AI Rules 標準根目錄排除規則"
}

function Invoke-AiRulesGitignoreMaintenance {
    param(
        [string]$ProjectRoot,
        [ValidateSet("Append", "CleanSimilar", "Overwrite")][string]$Mode = "Append",
        [switch]$Apply
    )
    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    $report = Get-AiRulesGitignoreReport -ProjectRoot $ProjectRoot
    Write-AiRulesGitignoreReport -Report $report
    if (-not $Apply) {
        Write-Host ""; Write-Host "Dry-run：未指定套用，不會修改 .gitignore。" -ForegroundColor Yellow
        Write-Host "標準流程只會補入帶繁中註解的 AI Rules 精準規則；舊版註解不處理，相似規則只列出，需由操作者確認後才刪除。"
        return $report
    }
    if ($Mode -in @("CleanSimilar", "Overwrite")) {
        $content = ""
        if (Test-Path -LiteralPath $gitignorePath) { $content = Get-AiRulesTextFileContent -Path $gitignorePath }
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
