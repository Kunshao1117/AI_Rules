# Internal partial for Audit.psm1. Loaded by the facade only.
# Skill quality audit

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
        [Alias("Root")]
        [string]$SkillsRoot,
        [string]$Target
    )

    if ($PSVersionTable.PSVersion.Major -lt 7) {
        $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
        if ($pwshCmd) {
            $facadeModulePath = Join-Path (Split-Path $PSScriptRoot -Parent) "Audit.psm1"
            if (-not (Test-Path -LiteralPath $facadeModulePath -PathType Leaf)) {
                throw "Audit facade module not found: $facadeModulePath"
            }
            & pwsh -NoProfile -Command {
                param($sr, $tg, $modulePath)
                Import-Module $modulePath -Force
                Measure-SkillQuality -SkillsRoot $sr -Target $tg
            } -Args $SkillsRoot, $Target, $facadeModulePath
            return
        }
    }

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    if (-not $SkillsRoot) {
        # 預設使用 Shared/skills/
        $repoRoot = Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent
        $SkillsRoot = Join-Path $repoRoot "Shared\skills"
        if (-not (Test-Path -LiteralPath $SkillsRoot -PathType Container)) {
            throw "Default skills root not found: $SkillsRoot"
        }
    }
    if (Test-Path -LiteralPath $SkillsRoot) { $SkillsRoot = (Resolve-Path -LiteralPath $SkillsRoot).Path }

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
        $blockingIssues = New-Object System.Collections.Generic.List[string]
        $desc = if ($Description) { $Description.Trim() } else { '' }

        if ([string]::IsNullOrWhiteSpace($desc)) {
            $issues.Add('description 空白或無法解析')
        } elseif ($desc.Length -lt 40) {
            $issues.Add('description 過短，可能不足以觸發自動載入')
        }

        if ($desc -and (-not (Test-AuditCjkFirstReadableText -Text $desc))) {
            $blockingIssues.Add('description 第一個可讀內容必須是繁中 meaning-first，不能以英文 label、when、Use when 或 domain token 開頭')
        }

        $useWhenSegment = Get-AuditDescriptionScopeSegment -Description $desc -Scope 'UseWhen'
        $doNotUseWhenSegment = Get-AuditDescriptionScopeSegment -Description $desc -Scope 'DoNotUseWhen'
        $descHasUseWhenLabel = $desc -match '(?is)(?:^|[.;。；]\s*)Use\s+when\s*:'
        $descHasDoNotUseWhenLabel = $desc -match '(?i)\bDO\s+NOT\s+use\s+when\s*:'

        if ($Kind -eq 'operational') {
            if ($desc -notmatch '[\u4e00-\u9fff]') {
                $blockingIssues.Add('operational skill description 缺少繁中觸發詞')
            }
            if ($desc -notmatch '[A-Za-z]') {
                $issues.Add('operational skill description 缺少英文觸發詞')
            }
            if (-not $descHasUseWhenLabel) {
                $issues.Add('operational skill description 缺少 Use when 正向邊界')
            } elseif (-not (Test-AuditCjkFirstReadableText -Text $useWhenSegment)) {
                $blockingIssues.Add('Use when 後方必須以繁中觸發語意開頭；英文 label 或 English-only trigger 不可作為主證據')
            }
            if (-not $descHasDoNotUseWhenLabel -and $desc -notmatch '不要|不適用|非') {
                $issues.Add('operational skill description 缺少負向邊界')
            } elseif ($descHasDoNotUseWhenLabel -and (-not (Test-AuditCjkFirstReadableText -Text $doNotUseWhenSegment))) {
                $blockingIssues.Add('DO NOT use when 後方必須以繁中排除語意開頭；English-only exclusion 不合格')
            }
        }

        $body = $Content -replace '(?ms)\A---\s*\r?\n.*?\r?\n---\s*', ''
        $bodyHasUseWhen = $body -match '(?mi)^\s*(Use when|DO NOT use when|When to load this skill|## .*Trigger|## .*觸發|觸發條件)'
        $descHasUseWhen = $descHasUseWhenLabel -and (Test-AuditCjkFirstReadableText -Text $useWhenSegment)
        if ($bodyHasUseWhen -and (-not $descHasUseWhen)) {
            $issues.Add('觸發條件只出現在正文，未放入 frontmatter description')
        }
        $bodyLines = @($body -split "\r?\n")
        for ($i = 0; $i -lt $bodyLines.Count; $i++) {
            if ($bodyLines[$i] -match '(?i)\b(DO\s+NOT\s+use\s+when|Use\s+when|When\s+to\s+load\s+this\s+skill)\b') {
                if (-not (Test-AuditScopeLabelCjkBridge -Lines $bodyLines -Index $i)) {
                    $blockingIssues.Add('正文 Use when/DO NOT use when 範圍檢查附近必須有繁中 meaning-first 或中文橋接，不接受 English-only')
                    break
                }
            }
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

        foreach ($blockingIssue in $blockingIssues) {
            $issues.Add($blockingIssue)
        }

        $workflowMarkers = 'Director-Readable Output Contract|Command Template|#\s*\[WORKFLOW:|#\s*\[SKILL:\s*/|lifecycle_phase:\s*(build|fix|commit|blueprint|audit|skill-forge)'
        if (($Kind -eq 'operational') -and ($Content -match $workflowMarkers) -and ($SkillName -notmatch '^skill-factory$')) {
            $issues.Add('operational skill 內容疑似混入 workflow 入口職責')
        }

        return [PSCustomObject]@{
            Status = if ($blockingIssues.Count -gt 0) { '🔴' } elseif ($issues.Count -eq 0) { '🟢' } else { '🟡' }
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
                $frontmatterStatus -eq '🔴' -or $compatStatus -eq '🔴' -or $triggerQuality.Status -eq '🔴' -or $styleStatus -eq '🔴'
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
            Write-Host "  ⚠ 缺少欄位：$(Format-AuditFieldListDisplay -Fields $r.MissingFields)" -ForegroundColor Yellow
        }
        if ($r.TriggerIssues.Count -gt 0) {
            Write-Host "  ⚠ 觸發品質：$($r.TriggerIssues -join '；')" -ForegroundColor Yellow
        }
    }
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    return $results
}
