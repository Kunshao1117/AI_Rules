# Internal partial for Audit.psm1. Loaded by the facade only.
# Project skill links, context, memory naming, shared context

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
    Write-Host "📊 專案技能連結（Project Skill Links）"
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
    Write-Host "📊 專案脈絡卡（Project Context Cards）"
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

    function Get-MarkdownSectionBody {
        param(
            [string]$Content,
            [string]$Heading
        )

        $pattern = "(?ms)^##\s+$([regex]::Escape($Heading))\s*\r?\n(?<body>.*?)(?=^##\s+|\z)"
        $match = [regex]::Match($Content, $pattern)
        if ($match.Success) { return $match.Groups['body'].Value }
        return $null
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

            $trackedBody = Get-MarkdownSectionBody -Content $content -Heading 'Tracked Files'
            if ($null -ne $trackedBody) {
                $trackedEntries = @(
                    $trackedBody -split '\r?\n' |
                        Where-Object {
                            ($_ -match '^\s*-\s+\S') -and
                            ($_ -notmatch '(?i)\b(none|n/a|navigation only|nav only)\b|無追蹤|導覽|索引')
                        }
                )

                if ($trackedEntries.Count -eq 0) {
                    $childCardDirs = @(
                        Get-ChildItem -LiteralPath $dir.FullName -Directory -ErrorAction SilentlyContinue |
                            Where-Object {
                                (Test-Path -LiteralPath (Join-Path $_.FullName 'MEMORY.md') -PathType Leaf) -or
                                (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf)
                            }
                    )
                    $relationsBody = Get-MarkdownSectionBody -Content $content -Heading 'Relations'
                    $hasChildRelations = ($relationsBody -and ($relationsBody -match '(?i)child|children|child card|子卡|parent|parent card|navigation|導覽|index|索引'))
                    $hasNavigationEvidence = ($content -match '(?i)navigation|navigation-only|index|map|parent card|child card|導覽|索引|父卡|子卡')

                    if (-not (($childCardDirs.Count -gt 0) -and $hasChildRelations -and $hasNavigationEvidence)) {
                        Add-MemoryNamingFinding -Severity 'Yellow' -File $relative -Reason 'Tracked Files 為空，但缺少父索引導覽與子卡承接證據'
                    }
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 記憶卡命名、結構與品質（Memory Card Naming, Structure, and Quality）"
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
    Write-Host "📊 共用脈絡模板（Shared Context Templates）"
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
