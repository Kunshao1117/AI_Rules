# Measure-SkillQuality.ps1 — 技能品質掃描腳本
# 掃描所有 SKILL.md 並產出結構化品質報告（行數/Token/禁詞/Frontmatter/風格）
param(
    [string]$Target,
    [string]$SkillsRoot
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshCmd) { & pwsh -File $MyInvocation.MyCommand.Path @PSBoundParameters; exit $LASTEXITCODE }
    Write-Error "[HALT] 此腳本需要 PowerShell 7+。"; exit 1
}

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $SkillsRoot) { $SkillsRoot = Join-Path $scriptDir '..\skills' }
$SkillsRoot = (Resolve-Path $SkillsRoot).Path

$ForbiddenPatterns = @('This skill teaches','This skill enables','This skill provides',
    'This skill extends','this is because','the purpose is','the reason is')
$RequiredFrontmatter = @('name', 'description', 'metadata')
$RequiredMetadata = @('author', 'version', 'origin')
$GatePattern = '\[(\w+\s+)?GATE\]'

function Measure-SingleSkill {
    param([string]$SkillDir)
    $skillFile = Join-Path $SkillDir 'SKILL.md'
    if (-not (Test-Path $skillFile)) { return $null }

    $content = Get-Content $skillFile -Raw -Encoding UTF8
    $lines = Get-Content $skillFile -Encoding UTF8
    $skillName = Split-Path $SkillDir -Leaf
    $lineCount = $lines.Count
    $lineStatus = if ($lineCount -lt 500) { '🟢' } else { '🔴' }
    $tokenEstimate = [math]::Ceiling($content.Length / 3)
    $tokenStatus = if ($tokenEstimate -lt 5000) { '🟢' } else { '🔴' }

    $foundForbidden = @()
    $contentLines = $content -split "`n"
    foreach ($pattern in $ForbiddenPatterns) {
        $ep = [regex]::Escape($pattern)
        foreach ($line in $contentLines) {
            if ($line -match 'FORBIDDEN:|禁用模式|❌') { continue }
            if ($line -match $ep) { $foundForbidden += $pattern; break }
        }
    }
    $forbiddenStatus = if ($foundForbidden.Count -eq 0) { '🟢' } else { '🔴' }

    $frontmatterOk = $true; $missingFields = @()
    foreach ($f in $RequiredFrontmatter) { if ($content -notmatch "(?m)^${f}:") { $frontmatterOk = $false; $missingFields += $f } }
    foreach ($f in $RequiredMetadata) { if ($content -notmatch "(?m)^\s+${f}:") { $frontmatterOk = $false; $missingFields += "metadata.$f" } }
    $frontmatterStatus = if ($frontmatterOk) { '🟢' } else { '🔴' }

    $nameOk = ($skillName -match '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$') -and ($skillName.Length -le 64)
    $fmMatch = [regex]::Match($content, '(?ms)\A---\s*\n(.*?)\n---')
    $descLength = 0
    if ($fmMatch.Success) {
        $fm = $fmMatch.Groups[1].Value
        $dl = [regex]::Match($fm, '(?ms)^description:\s*>\s*\n((?:\s{2,}.*\n)*)')
        if ($dl.Success) { $descLength = $dl.Groups[1].Value.Trim().Length }
        else { $sl = [regex]::Match($fm, '(?m)^description:\s*(.+)$'); if ($sl.Success) { $descLength = $sl.Groups[1].Value.Trim().Length } }
    }
    $compatStatus = if ($nameOk -and ($descLength -lt 1024)) { '🟢' } else { '🔴' }

    $hasRefs = Test-Path (Join-Path $SkillDir 'references')
    $l3Status = if ($hasRefs) { if ($content -match 'Read references/|references/\S+\.md') { '🟢' } else { '🟡' } } else { '—' }

    $styleValue = ''
    if ($fmMatch.Success) {
        $fmSM = [regex]::Match($fmMatch.Groups[1].Value, '(?m)^\s+style:\s*(\S+)')
        if ($fmSM.Success) { $styleValue = $fmSM.Groups[1].Value.Trim() }
    }
    $hasGate = $content -match $GatePattern
    $styleStatus = '—'
    if ($styleValue) {
        switch ($styleValue) {
            'imperative' { $styleStatus = if ($hasGate) { '🟢' } else { '🔴' } }
            'guided'     { $styleStatus = if (-not $hasGate) { '🟢' } else { '🔴' } }
            'hybrid'     { $styleStatus = if ($hasGate) { '🟢' } else { '🟡' } }
            default      { $styleStatus = '🔴' }
        }
    }

    $overall = if ($lineStatus -eq '🟢' -and $tokenStatus -eq '🟢' -and $forbiddenStatus -eq '🟢' -and
        $frontmatterStatus -eq '🟢' -and $compatStatus -eq '🟢' -and $l3Status -ne '🟡' -and $styleStatus -ne '🔴') { '🟢' }
        elseif ($lineStatus -eq '🔴' -or $tokenStatus -eq '🔴' -or $forbiddenStatus -eq '🔴' -or
            $frontmatterStatus -eq '🔴' -or $compatStatus -eq '🔴' -or $styleStatus -eq '🔴') { '🔴' } else { '🟡' }

    return [PSCustomObject]@{ Name=$skillName; Lines=$lineCount; LineStatus=$lineStatus
        Tokens=$tokenEstimate; TokenStatus=$tokenStatus; ForbiddenWords=$foundForbidden
        ForbiddenStatus=$forbiddenStatus; MissingFields=$missingFields; FrontmatterStatus=$frontmatterStatus
        CompatStatus=$compatStatus; L3Status=$l3Status; StyleValue=$styleValue; StyleStatus=$styleStatus; OverallStatus=$overall }
}

$results = @()
if ($Target) {
    $r = Measure-SingleSkill -SkillDir (Resolve-Path $Target).Path
    if ($r) { $results += $r }
} else {
    $agentsRoot = Split-Path $SkillsRoot -Parent
    $scanDirs = @($SkillsRoot)
    $memDir = Join-Path $agentsRoot 'memory'; if (Test-Path $memDir) { $scanDirs += $memDir }
    foreach ($sd in $scanDirs) {
        Get-ChildItem -Path $sd -Directory | Where-Object { $_.Name -notmatch '^_' } |
            ForEach-Object { $r = Measure-SingleSkill $_.FullName; if ($r) { $results += $r } }
    }
}

$ts = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss+08:00'
$pass = ($results | Where-Object { $_.OverallStatus -eq '🟢' }).Count
$warn = ($results | Where-Object { $_.OverallStatus -eq '🟡' }).Count
$fail = ($results | Where-Object { $_.OverallStatus -eq '🔴' }).Count

Write-Host "`n📊 技能品質掃描報告 — $ts"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "掃描技能數：$($results.Count)  🟢 合格：$pass  🟡 警告：$warn  🔴 不合格：$fail`n"

$fmt = "{0,-30} {1,6} {2,3} {3,7} {4,3} {5,4} {6,4} {7,4} {8,3} {9,8} {10,3} {11,4}"
Write-Host ($fmt -f '技能名稱','行數',' ','Token',' ','禁詞','FM','IO','L3','風格',' ','總評')
Write-Host ('-' * 90)

foreach ($r in $results | Sort-Object Name) {
    $sd = if ($r.StyleValue) { $r.StyleValue.Substring(0,[math]::Min(8,$r.StyleValue.Length)) } else { '—' }
    Write-Host ($fmt -f $r.Name,$r.Lines,$r.LineStatus,$r.Tokens,$r.TokenStatus,$r.ForbiddenStatus,$r.FrontmatterStatus,$r.CompatStatus,$r.L3Status,$sd,$r.StyleStatus,$r.OverallStatus)
    if ($r.ForbiddenWords.Count -gt 0) { Write-Host "  ⚠ 禁用詞：$($r.ForbiddenWords -join ', ')" -ForegroundColor Yellow }
    if ($r.MissingFields.Count -gt 0)  { Write-Host "  ⚠ 缺少欄位：$($r.MissingFields -join ', ')" -ForegroundColor Yellow }
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
return $results
