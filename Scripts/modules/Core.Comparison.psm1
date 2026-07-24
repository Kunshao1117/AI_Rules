# Version and rule-equivalence functions.

function Get-VersionContent {
    param([string]$Path)
    if (Test-Path $Path) { return (Get-Content $Path -Raw).Trim() }
    return "unknown"
}

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

function Compare-FrameworkFile {
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

function Compare-GlobalRule {
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
