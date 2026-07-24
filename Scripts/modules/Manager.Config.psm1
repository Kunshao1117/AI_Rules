#Requires -Version 5.1

function Write-ManagerConfigStep { param([string]$Message) Write-Host "  → $Message" -ForegroundColor Cyan }
function Write-ManagerConfigOk { param([string]$Message) Write-Host "  ✓ $Message" -ForegroundColor Green }
function Write-ManagerConfigWarn { param([string]$Message) Write-Host "  ⚠ $Message" -ForegroundColor Yellow }

function Get-TomlSectionBounds {
    param(
        [string]$Text,
        [string]$Section
    )

    $headers = [regex]::Matches($Text, '(?m)^\s*\[([^\]]+)\]\s*(?:#.*)?(?:\r?\n|$)')
    for ($i = 0; $i -lt $headers.Count; $i++) {
        if ($headers[$i].Groups[1].Value.Trim() -eq $Section) {
            $end = $Text.Length
            if (($i + 1) -lt $headers.Count) { $end = $headers[$i + 1].Index }
            return [PSCustomObject]@{
                BodyStart = $headers[$i].Index + $headers[$i].Length
                End       = $end
            }
        }
    }

    return $null
}

function Get-TomlTopLevelKeyLine {
    param(
        [string]$Text,
        [string]$Key
    )

    $rootEnd = $Text.Length
    $firstSection = [regex]::Match($Text, '(?m)^\s*\[[^\]]+\]\s*(?:#.*)?(?:\r?\n|$)')
    if ($firstSection.Success) { $rootEnd = $firstSection.Index }
    $rootText = $Text.Substring(0, $rootEnd)
    $match = [regex]::Match($rootText, ("(?m)^\s*{0}\s*=.*$" -f [regex]::Escape($Key)))
    if ($match.Success) { return $match.Value.Trim() }
    return $null
}

function Get-TomlSectionKeyLine {
    param(
        [string]$Text,
        [string]$Section,
        [string]$Key
    )

    $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
    if (-not $bounds) { return $null }
    $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
    $match = [regex]::Match($sectionText, ("(?m)^\s*{0}\s*=.*$" -f [regex]::Escape($Key)))
    if ($match.Success) { return $match.Value.Trim() }
    return $null
}

function Add-TomlTopLevelKeyIfMissing {
    param(
        [string]$Text,
        [string]$Key,
        [string]$Line
    )

    if (Get-TomlTopLevelKeyLine -Text $Text -Key $Key) { return $Text }
    if (-not $Text) { return $Line + "`n" }
    return $Line + "`n`n" + $Text.TrimStart()
}

function Add-TomlSectionKeyIfMissing {
    param(
        [string]$Text,
        [string]$Section,
        [string]$Key,
        [string]$Line
    )

    $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
    if ($bounds) {
        $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
        if ($sectionText -match ("(?m)^\s*{0}\s*=" -f [regex]::Escape($Key))) { return $Text }
        return $Text.Insert($bounds.BodyStart, $Line + "`n")
    }

    if ($Text -and -not $Text.EndsWith("`n")) { $Text += "`n" }
    return $Text + "`n[$Section]`n$Line`n"
}

function Set-TomlSectionBooleanTrue {
    param(
        [string]$Text,
        [string]$Section,
        [string]$Key
    )

    $line = "$Key = true"
    $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
    if (-not $bounds) {
        if ($Text -and -not $Text.EndsWith("`n")) { $Text += "`n" }
        return $Text + "`n[$Section]`n$line`n"
    }

    $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
    $match = [regex]::Match($sectionText, ("(?m)^(\s*){0}\s*=\s*([^\r\n#]*)([^\r\n]*)(?:\r)?$" -f [regex]::Escape($Key)))
    if (-not $match.Success) { return $Text.Insert($bounds.BodyStart, $line + "`n") }

    if ($match.Groups[2].Value.Trim() -ceq "true") { return $Text }
    $tail = $match.Groups[3].Value
    $comment = ""
    if ($tail.TrimStart().StartsWith("#")) { $comment = " " + $tail.TrimStart() }
    $replacement = "$($match.Groups[1].Value)$Key = true$comment"
    $start = $bounds.BodyStart + $match.Index
    return $Text.Remove($start, $match.Length).Insert($start, $replacement)
}

function Merge-ManagerCodexProjectConfigDefaults {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [switch]$Apply
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { return }

    $sourceText = Get-Content -LiteralPath $SourcePath -Raw -Encoding UTF8
    $fallbackLine = Get-TomlTopLevelKeyLine -Text $sourceText -Key "project_doc_fallback_filenames"
    if (-not $fallbackLine) { $fallbackLine = 'project_doc_fallback_filenames = [".codex/AGENTS.md"]' }
    $maxThreadsLine = Get-TomlSectionKeyLine -Text $sourceText -Section "agents" -Key "max_threads"
    if (-not $maxThreadsLine) { $maxThreadsLine = "max_threads = 8" }

    $current = ''
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        $current = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8
    }

    $text = $current
    $actions = @()

    $before = $text
    $text = Add-TomlTopLevelKeyIfMissing -Text $text -Key "project_doc_fallback_filenames" -Line $fallbackLine
    if ($text -ne $before) { $actions += "add top-level project_doc_fallback_filenames" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "multi_agent"
    if ($text -ne $before) { $actions += "set [features].multi_agent = true" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "hooks"
    if ($text -ne $before) { $actions += "set [features].hooks = true" }

    $before = $text
    $text = Add-TomlSectionKeyIfMissing -Text $text -Section "agents" -Key "max_threads" -Line $maxThreadsLine
    if ($text -ne $before) { $actions += "add [agents].max_threads default" }

    $merged = $text.TrimEnd() + "`n"
    if ($current -eq $merged) {
        Write-ManagerConfigStep "Codex config.toml required keys already match section-aware defaults: $TargetPath"
        return [PSCustomObject]@{ Changed = $false; Actions = @(); TargetPath = $TargetPath }
    }

    if (-not $Apply) {
        Write-ManagerConfigWarn "Codex config.toml would be updated ($($actions -join '; ')): $TargetPath"
        return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
    }

    $targetDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path -LiteralPath $targetDir)) { New-Item -ItemType Directory -Force -Path $targetDir | Out-Null }
    [System.IO.File]::WriteAllText($TargetPath, $merged, [System.Text.UTF8Encoding]::new($false))
    Write-ManagerConfigOk "Codex config.toml defaults merged ($($actions -join '; ')): $TargetPath"
    return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
}

Export-ModuleMember -Function Merge-ManagerCodexProjectConfigDefaults
