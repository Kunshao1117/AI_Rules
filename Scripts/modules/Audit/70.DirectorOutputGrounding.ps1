# Internal partial for Audit.psm1. Loaded by the facade only.
# Director output quality and grounding

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
    $directorLanguageGateChecks = @{
        captain_translation = [PSCustomObject]@{
            Label = '隊長接收交付件後的繁中轉譯 gate'
            Pattern = '(?is)((隊長|主代理|captain|main agent).{0,260}(接收|receive|receipt|收到|收取|彙整|整合|synthesi[sz]e|integrat).{0,260}(交付件|artifacts?|隊員|specialist).{0,260}(繁中|中文|Traditional Chinese|zh-TW|meaning-first|意義先行|總監可讀|Director-facing))|((隊長|主代理|captain|main agent).{0,260}(總監|Director).{0,200}(輸出|回報|報告|output|report).{0,260}(轉成|轉譯|重寫|摘要|整合|彙整|synthesi[sz]e|rewrite|translate).{0,180}(繁中|中文|Traditional Chinese|zh-TW|meaning-first|意義先行))|((隊員|specialist|交付件|delivery artifact).{0,220}(不得|禁止|不可|must not|cannot|Do not).{0,220}(原文|raw|直接貼|paste|外貼).{0,180}(總監|Director))'
        }
        english_led = [PSCustomObject]@{
            Label = '禁止英文主導總監輸出'
            Pattern = '(?is)((英文主導|英文欄位主導|English-led|English dominant|English-only).{0,260}(總監|Director|輸出|output|complete|completion|gate|閘門|完成).{0,260}(禁止|不得|不可|不通過|fail|blocked|blocks?|gate|閘門|完成))|((總監|Director).{0,220}(輸出|output|report).{0,260}(英文主導|English-led|English-only|raw English))|((Director-facing output|總監輸出|總監可讀).{0,260}(English-led|英文主導|英文欄位主導|English-only).{0,260}(blocks?|blocked|fail|不通過|阻塞|不得|不可|不能))'
        }
        raw_internal_artifact = [PSCustomObject]@{
            Label = '禁止 raw internal artifact 或 raw field list 外貼'
            Pattern = '(?is)((不得|禁止|不可|must not|cannot|Do not).{0,260}(raw internal artifact|raw artifact|raw field list|raw English-only field list|原樣貼|原文貼上|直接貼|外貼|內部.*(交付件|欄位|schema|任務板|board)|internal artifacts?|English field tables?|specialist raw output).{0,260}(總監|Director|輸出|output|main body|主體))|((internal|內部|board-facing|delivery artifacts?|artifacts?|交付件|欄位|schema|field).{0,220}(不是|not|are not).{0,180}(總監|Director).{0,160}(報告|輸出|reports?|template|模板))|((Director-facing output|總監輸出|總監可讀).{0,240}(raw-artifact-led|raw-field-led|artifact-led|raw field|raw artifact|原樣貼|欄位主導).{0,240}(blocks?|fail|不通過|阻塞|不得|不可|不能))|((internal delivery artifacts?|內部交付件).{0,200}(synthesi[sz]ed rather than pasted|轉譯|整合|彙整|不得原樣|不得貼|不是原樣))'
        }
        evidence_integrity = [PSCustomObject]@{
            Label = '隊長摘要不得改寫證據來源與狀態結論'
            Pattern = '(?is)((隊長|captain).{0,220}(可|may).{0,120}(重寫|轉譯|摘要|synthesi[sz]e|rewrite|translate).{0,240}(不得|不可|不能|must not|cannot).{0,260}(證據來源|evidence source|角色歸屬|role attribution|驗證|validation|審查|review|風險|risk))|((證據來源|evidence source).{0,180}(角色歸屬|role attribution).{0,180}(驗證|validation).{0,180}(審查|review).{0,180}(風險|risk).{0,180}(不得|不可|不能|must not|cannot).{0,120}(改寫|alter|rewrite))'
        }
        completion_fail_gate = [PSCustomObject]@{
            Label = '總監輸出語言治理完成門檻'
            Pattern = '(?is)((completion gate|完成門檻|完成閘門|completion claim|完成宣稱).{0,260}(英文主導|English-led|English-only|raw artifact|raw field list|原樣貼|未整合|unsynthesized|隊員交付件).{0,260}(fail|blocked|blocks?|不通過|阻塞|Red|不得|不可|不能|must not|cannot))|((Director-facing output governance|總監輸出門檻|總監可讀輸出).{0,600}(English-led|英文主導|raw-artifact-led|raw-field-led|unsynthesized|未整合).{0,220}(blocks?\s+`?complete`?|阻塞|不通過|不得完整完成))|((English-led|英文主導|raw-artifact-led|raw-field-led|unsynthesized|未整合).{0,180}(blocks?\s+`?complete`?|阻塞|不通過|不得完整完成))'
        }
    }
    $directorLanguageGateTargets = @(
        [PSCustomObject]@{
            Scope = 'language-governance-source'
            Path = Join-Path $RepoRoot 'Shared\policies\language-governance.md'
            Checks = @('captain_translation', 'english_led', 'raw_internal_artifact', 'evidence_integrity')
        },
        [PSCustomObject]@{
            Scope = 'language-governance-target'
            Path = Join-Path $TargetRoot '.agents\shared\policies\language-governance.md'
            Checks = @('captain_translation', 'english_led', 'raw_internal_artifact', 'evidence_integrity')
        },
        [PSCustomObject]@{
            Scope = 'subagent-invocation-source'
            Path = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'
            Checks = @('captain_translation', 'raw_internal_artifact', 'evidence_integrity')
        },
        [PSCustomObject]@{
            Scope = 'subagent-invocation-target'
            Path = Join-Path $TargetRoot '.agents\shared\policies\subagent-invocation.md'
            Checks = @('captain_translation', 'raw_internal_artifact', 'evidence_integrity')
        },
        [PSCustomObject]@{
            Scope = 'completion-gate-source'
            Path = Join-Path $RepoRoot 'Shared\skills\team-completion-gate\SKILL.md'
            Checks = @('english_led', 'raw_internal_artifact', 'completion_fail_gate')
        },
        [PSCustomObject]@{
            Scope = 'completion-gate-target'
            Path = Join-Path $TargetRoot '.agents\skills\team-completion-gate\SKILL.md'
            Checks = @('english_led', 'raw_internal_artifact', 'completion_fail_gate')
        },
        [PSCustomObject]@{
            Scope = 'team-task-board-source'
            Path = Join-Path $RepoRoot 'Shared\skills\team-task-board\SKILL.md'
            Checks = @('raw_internal_artifact')
        },
        [PSCustomObject]@{
            Scope = 'team-task-board-target'
            Path = Join-Path $TargetRoot '.agents\skills\team-task-board\SKILL.md'
            Checks = @('raw_internal_artifact')
        },
        [PSCustomObject]@{
            Scope = 'team-specialist-registry-source'
            Path = Join-Path $RepoRoot 'Shared\skills\team-specialist-registry\SKILL.md'
            Checks = @('raw_internal_artifact')
        },
        [PSCustomObject]@{
            Scope = 'team-specialist-registry-target'
            Path = Join-Path $TargetRoot '.agents\skills\team-specialist-registry\SKILL.md'
            Checks = @('raw_internal_artifact')
        }
    )

    function Test-DirectorOutputMinimumContract {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasTraditionalChinese = $Content -match 'Traditional Chinese|繁體中文|zh-TW'
        $hasPlainLanguage = $Content -match 'plain-language|Director-facing text starts from plain-language|Director Output And Grounding Minimum'
        $hasStructuredFormalOutput = $Content -match 'structured summary|compact table|結構化|精簡表格'
        $hasConcreteLocation = $Content -match 'concrete files|concrete file|sections, tool/status scopes, or directory scopes|具體檔案|目錄範圍'
        $hasLanguageGovernanceDelegation = $Content -match 'language-governance\.md|Language governance source|Language-layer classification'
        $hasGrounding = $Content -match 'neutral, honest stance|Treat memory and model knowledge as possibly stale|official or primary sources|接地查證|Current local files and tool output override memory'

        return ($hasTraditionalChinese -and $hasPlainLanguage -and $hasStructuredFormalOutput -and $hasConcreteLocation -and $hasLanguageGovernanceDelegation -and $hasGrounding)
    }

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

    function Test-DirectorLanguageGateContent {
        param(
            [string]$Content,
            [string[]]$CheckNames
        )

        $missing = New-Object System.Collections.Generic.List[string]
        foreach ($checkName in @($CheckNames)) {
            if (-not $directorLanguageGateChecks.ContainsKey($checkName)) { continue }
            $check = $directorLanguageGateChecks[$checkName]
            if ($Content -notmatch $check.Pattern) {
                $missing.Add($check.Label)
            }
        }

        return @($missing.ToArray())
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
        if (($missing.Count -gt 0) -and (Test-DirectorOutputMinimumContract -Content $content)) {
            $missing = @()
        }
        if ($missing.Count -gt 0) {
            Add-DirectorFinding -Severity 'Red' `
                -File (Get-DirectorDisplayPath -Path $target.Path) `
                -Reason ("{0}/{1} 缺少總監可讀輸出契約：{2}" -f $target.Platform, $target.Scope, ($missing -join ', '))
        }
    }

    foreach ($gateTarget in $directorLanguageGateTargets) {
        if (-not (Test-Path -LiteralPath $gateTarget.Path)) {
            Add-DirectorFinding -Severity 'Red' `
                -File (Get-DirectorDisplayPath -Path $gateTarget.Path) `
                -Reason ("缺少總監輸出語言治理檢查目標：{0}" -f $gateTarget.Scope)
            continue
        }

        $content = Get-Content -LiteralPath $gateTarget.Path -Raw -Encoding UTF8
        $missing = Test-DirectorLanguageGateContent -Content $content -CheckNames $gateTarget.Checks
        if (@($missing).Count -gt 0) {
            Add-DirectorFinding -Severity 'Red' `
                -File (Get-DirectorDisplayPath -Path $gateTarget.Path) `
                -Reason ("{0} 缺少總監輸出語言治理硬閘門：{1}" -f $gateTarget.Scope, ($missing -join ', '))
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
    Write-Host "📊 總監可讀輸出契約（Director Output Contract）"
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

function Test-DirectorLanguageDominance {
    param([string]$Content)

    if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

    $hasExplicitMeaningFirstRule = $Content -match '(?is)(Traditional Chinese|繁體中文|zh-TW|中文|繁中).{0,180}(meaning[- ]first|plain-language|語義先行|意義先行|中文先行|含義先行)'

    $scan = [regex]::Replace($Content, '(?s)```.*?```', ' ')
    $scan = [regex]::Replace($scan, '`[^`]+`', ' ')
    $scan = [regex]::Replace($scan, 'https?://\S+', ' ')
    $scan = [regex]::Replace($scan, '(?m)^\s*\|.*\|\s*$', ' ')
    $scan = [regex]::Replace($scan, '(?m)^\s*[-*]\s*[A-Za-z0-9_.-]+\s*[:=]', ' ')

    $chineseCount = [regex]::Matches($scan, '[\u4e00-\u9fff]').Count
    $englishWordCount = [regex]::Matches($scan, '\b[A-Za-z][A-Za-z-]{2,}\b').Count
    return (($chineseCount -gt 0) -and ((($chineseCount * 2) -ge $englishWordCount) -or $hasExplicitMeaningFirstRule))
}

function Test-RawArtifactLedOutput {
    param([string]$Content)

    if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

    $inFence = $false
    $negativePattern = '(?i)(must not|cannot|do not|not |never|forbidden|fails?|blocks?|不得|不可|不能|禁止|不應|不是|不通過|阻塞|轉譯|整合|彙整|synthesi[sz]e|rewrite)'
    $rawLeadPattern = '(?i)^\s*(handoff_packet_id|board_state|station_mode|context_visibility|handoff_ownership|delivery_artifact(_id|_status)?|author_role|source_input|integrable_scope|review_state|validation_state|memory_docs_state)\s*[:|]'
    $rawOutputPattern = '(?i)(raw[- ]?artifact[- ]?led|raw[- ]?field[- ]?led|English-only field list|specialist raw output|隊員 raw artifact|原樣貼|原文貼上)'
    $directorPattern = '(?i)(Director-facing|Director|總監|總監可讀|completion report|完成報告|output|report|回報)'

    foreach ($line in ($Content -split "\r?\n")) {
        if ($line -match '^\s*```') {
            $inFence = -not $inFence
            continue
        }
        if ($inFence) { continue }

        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        if ($trimmed -match '^(https?://|[A-Za-z]:[\\/]|[./\\][^ ]+[\\/])') { continue }
        if ($trimmed -match '^\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?$') { continue }
        if ($trimmed -match '^`[^`]+`$') { continue }

        $isRawLed = (($trimmed -match $rawLeadPattern) -and ($trimmed -match $directorPattern)) -or ($trimmed -match $rawOutputPattern)
        if ($isRawLed -and ($trimmed -notmatch $negativePattern)) {
            return $true
        }
    }

    return $false
}

function Measure-DirectorFacingOutputQuality {
    <#
    .SYNOPSIS
        檢查政策與交付文件是否具備總監可讀輸出品質治理能力。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $qualityChecks = @{
        meaning_first = [PSCustomObject]@{
            Label = '繁中語義先行與英文 token 證據化'
            Pattern = '(?is)(Traditional Chinese|繁體中文|zh-TW|中文|繁中).{0,240}(meaning[- ]first|plain-language|語義先行|意義先行|中文先行|含義先行).{0,420}(technical identifiers?|technical tokens?|canonical|英文|English|token|field|path|command|exact field|identifiers?).{0,420}(supporting evidence|evidence|precision|identifier|parentheses|證據|精確|輔助|括號)|英文.{0,160}(canonical|identifier|token|field|path|command).{0,180}(證據|精確|保留)|技術.{0,160}(identifier|token|名稱|欄位).{0,220}(證據|精確|括號|輔助)|Director-facing display uses Traditional Chinese meaning first'
        }
        raw_artifact_synthesis = [PSCustomObject]@{
            Label = '隊員 raw artifact 不得原貼且需隊長轉譯'
            Pattern = '(?is)(Team-member delivery artifacts?|specialist raw output|internal delivery artifacts?|內部交付件|隊員|交付件).{0,260}(not Director-facing|not.*Director-facing|不得|不可|不能|禁止|must not|cannot|Do not|synthesi[sz]ed rather than pasted|轉譯|整合|彙整|不得原樣|不得貼).{0,260}(Director|總監|Director-facing|總監可讀|output|report)|((隊長|captain|主代理).{0,240}(synthesi[sz]e|轉譯|整合|彙整|rewrite|摘要).{0,220}(交付件|artifacts?|總監|Director))'
        }
        chinese_table_labels = [PSCustomObject]@{
            Label = '總監表格欄位中文主標籤'
            Pattern = '(?is)(Director-facing tables?|總監.{0,80}表格|總監可讀.{0,80}表格|欄位).{0,260}(Traditional Chinese|中文|繁中|Chinese).{0,220}(column labels?|欄位|primary labels?|主標籤|主 labels?)|任務板狀態（board_state）|完成狀態（completion_state）|讀取範圍（read_scope）'
        }
        completion_gate = [PSCustomObject]@{
            Label = '英文主導或 raw-field-led 輸出不得宣稱 complete'
            Pattern = '(?is)(English-led|English-only|英文主導|raw-artifact-led|raw-field-led|unsynthesized|未整合|raw field|raw artifact).{0,240}(blocks?\s+`?complete`?|complete|completion|完成|阻塞|不通過|fail|不得|不可|不能)|((completion gate|完成門檻|完成閘門).{0,260}(Director-facing output governance|總監輸出|總監可讀).{0,260}(English-led|raw-artifact-led|raw-field-led|unsynthesized|英文主導|未整合))'
        }
    }

    $targets = @(
        [PSCustomObject]@{ Scope = 'language-governance-source'; Path = Join-Path $RepoRoot 'Shared\policies\language-governance.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'chinese_table_labels', 'completion_gate') },
        [PSCustomObject]@{ Scope = 'language-governance-target'; Path = Join-Path $TargetRoot '.agents\shared\policies\language-governance.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'chinese_table_labels', 'completion_gate') },
        [PSCustomObject]@{ Scope = 'team-completion-gate-source'; Path = Join-Path $RepoRoot 'Shared\skills\team-completion-gate\SKILL.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'completion_gate') },
        [PSCustomObject]@{ Scope = 'team-completion-gate-target'; Path = Join-Path $TargetRoot '.agents\skills\team-completion-gate\SKILL.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'completion_gate') },
        [PSCustomObject]@{ Scope = 'team-task-board-source'; Path = Join-Path $RepoRoot 'Shared\skills\team-task-board\SKILL.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'chinese_table_labels') },
        [PSCustomObject]@{ Scope = 'team-task-board-target'; Path = Join-Path $TargetRoot '.agents\skills\team-task-board\SKILL.md'; Checks = @('meaning_first', 'raw_artifact_synthesis', 'chinese_table_labels') }
    )

    function Get-DirectorFacingOutputQualityPath {
        param([string]$Path)
        if (Test-Path -LiteralPath $Path) {
            return (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $Path)
        }
        return $Path
    }

    function Add-DirectorFacingOutputQualityFinding {
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

    foreach ($target in $targets) {
        $displayPath = Get-DirectorFacingOutputQualityPath -Path $target.Path
        if (-not (Test-Path -LiteralPath $target.Path)) {
            Add-DirectorFacingOutputQualityFinding -Severity 'Red' -File $displayPath -Line 1 -Reason ("缺少總監可讀輸出品質治理目標：{0}" -f $target.Scope) -Text $target.Path
            continue
        }

        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $missing = New-Object System.Collections.Generic.List[string]
        foreach ($checkName in @($target.Checks)) {
            if (-not $qualityChecks.ContainsKey($checkName)) { continue }
            $check = $qualityChecks[$checkName]
            if ($content -notmatch $check.Pattern) {
                $missing.Add($check.Label)
            }
        }

        if (@($missing).Count -gt 0) {
            Add-DirectorFacingOutputQualityFinding -Severity 'Red' -File $displayPath -Line 1 -Reason ("{0} 缺少總監可讀輸出品質治理能力：{1}" -f $target.Scope, (($missing.ToArray()) -join ', ')) -Text '政策主體缺失。'
        }

        if (-not (Test-DirectorLanguageDominance -Content $content)) {
            Add-DirectorFacingOutputQualityFinding -Severity 'Yellow' -File $displayPath -Line 1 -Reason ("{0} 疑似缺少繁中語義優先訊號" -f $target.Scope) -Text '此檢查只作樣式風險提示，程式碼、路徑、URL、schema 與 fenced code 已排除。'
        }
        if (Test-RawArtifactLedOutput -Content $content) {
            Add-DirectorFacingOutputQualityFinding -Severity 'Yellow' -File $displayPath -Line 1 -Reason ("{0} 疑似存在 raw artifact 或 raw field 主導的總監輸出樣式" -f $target.Scope) -Text '疑似樣式問題列黃燈，需人工判讀是否為反例、schema 或內部模板。'
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 總監可讀輸出品質（Director-Facing Output Quality）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line, Reason) {
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

function Measure-HighChangeGroundingGap {
    <#
    .SYNOPSIS
        檢查高變動與外部事實接地查證治理能力是否存在。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $groundingChecks = @{
        high_change_must_verify = [PSCustomObject]@{
            Label = '高變動或外部事實必須查證'
            Pattern = '(?is)(high-change|高變動|外部事實|external facts?|latest|current).{0,260}(verify|查證|search|browse|official|primary|轉研究|必查|must)|(高變動.{0,160}必查)|(外部.{0,120}事實.{0,160}查證)'
        }
        official_primary_priority = [PSCustomObject]@{
            Label = '來源分級與官方/primary source 優先'
            Pattern = '(?is)(official documentation|official docs|official or primary sources|primary sources?|官方文件|官方|一手來源|primary-source|來源分級|source tier|source credibility|官方優先)'
        }
        unverified_blocked_labels = [PSCustomObject]@{
            Label = '未查、查不到或阻塞需明確標示'
            Pattern = '(?is)(未驗證|阻塞|blocked|unverified|查不到|未查|missing evidence|missing tools|missing credentials|缺少資料|缺證).{0,260}(不得|不可|cannot|must not|report|標明|標示|回報|只能|not treated as success|不宣稱)'
        }
        model_memory_not_verified = [PSCustomObject]@{
            Label = '不得用模型記憶宣稱已驗證'
            Pattern = '(?is)(model knowledge|internal model knowledge|model memory|模型記憶|內建知識|memory and internal model knowledge).{0,260}(stale|possibly stale|過時|不得|不可|不能|not verified|not.*current|不能宣稱|不得宣稱)|(不得|不可|不能).{0,180}(模型|model|memory|記憶).{0,180}(已驗證|verified|current)|grounding-governance\.md'
        }
    }

    $targets = @(
        [PSCustomObject]@{ Scope = 'codex-core-source'; Path = Join-Path $RepoRoot 'Codex\.codex\AGENTS.md'; Checks = @('high_change_must_verify', 'official_primary_priority', 'unverified_blocked_labels', 'model_memory_not_verified') },
        [PSCustomObject]@{ Scope = 'codex-core-target'; Path = Join-Path $TargetRoot '.codex\AGENTS.md'; Checks = @('high_change_must_verify', 'official_primary_priority', 'unverified_blocked_labels', 'model_memory_not_verified') },
        [PSCustomObject]@{ Scope = 'grounding-governance-source'; Path = Join-Path $RepoRoot 'Shared\policies\grounding-governance.md'; Checks = @('official_primary_priority', 'unverified_blocked_labels', 'model_memory_not_verified') },
        [PSCustomObject]@{ Scope = 'grounding-governance-target'; Path = Join-Path $TargetRoot '.agents\shared\policies\grounding-governance.md'; Checks = @('official_primary_priority', 'unverified_blocked_labels', 'model_memory_not_verified') },
        [PSCustomObject]@{ Scope = 'workflow-evidence-matrix-source'; Path = Join-Path $RepoRoot 'Shared\workflow-capability-evidence-matrix.md'; Checks = @('high_change_must_verify', 'official_primary_priority', 'unverified_blocked_labels') },
        [PSCustomObject]@{ Scope = 'workflow-evidence-matrix-target'; Path = Join-Path $TargetRoot '.agents\shared\workflow-capability-evidence-matrix.md'; Checks = @('high_change_must_verify', 'official_primary_priority', 'unverified_blocked_labels') },
        [PSCustomObject]@{ Scope = 'platform-capability-matrix-source'; Path = Join-Path $RepoRoot 'Shared\platform-capability-matrix.md'; Checks = @('official_primary_priority', 'unverified_blocked_labels') },
        [PSCustomObject]@{ Scope = 'platform-capability-matrix-target'; Path = Join-Path $TargetRoot '.agents\shared\platform-capability-matrix.md'; Checks = @('official_primary_priority', 'unverified_blocked_labels') }
    )

    function Add-HighChangeGroundingFinding {
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

    function Get-HighChangeGroundingReferenceTokens {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return @() }

        $tokens = New-Object System.Collections.Generic.List[string]
        foreach ($match in [regex]::Matches($Content, '`([^`]+\.md)`')) {
            $token = $match.Groups[1].Value.Trim()
            if ($token) { $tokens.Add($token) }
        }

        return @($tokens.ToArray() | Select-Object -Unique)
    }

    function Get-HighChangeGroundingReferenceCandidatePaths {
        param([string]$Reference)
        if ([string]::IsNullOrWhiteSpace($Reference)) { return @() }

        $normalized = $Reference.Trim()
        $normalized = $normalized.Trim([char]0x60).Trim([char]34).Trim([char]39) -replace '/', '\'
        if (-not $normalized) { return @() }

        $candidates = New-Object System.Collections.Generic.List[string]
        if ([System.IO.Path]::IsPathRooted($normalized)) {
            $candidates.Add($normalized)
        } else {
            $candidates.Add((Join-Path $RepoRoot $normalized))
            $candidates.Add((Join-Path $TargetRoot $normalized))

            if ($normalized -match '^Shared\\(.+)$') {
                $candidates.Add((Join-Path $TargetRoot (Join-Path '.agents\shared' $Matches[1])))
            }
            if ($normalized -match '^\.agents\\shared\\(.+)$') {
                $candidates.Add((Join-Path $RepoRoot (Join-Path 'Shared' $Matches[1])))
            }
        }

        return @($candidates.ToArray() | Select-Object -Unique)
    }

    function Test-HighChangeGroundingReferencePolicyContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasHighChange = $Content -match $groundingChecks.high_change_must_verify.Pattern
        $hasOfficialPrimary = $Content -match $groundingChecks.official_primary_priority.Pattern
        $hasMissingEvidence = $Content -match $groundingChecks.unverified_blocked_labels.Pattern
        $hasModelMemoryBoundary = $Content -match $groundingChecks.model_memory_not_verified.Pattern
        $hasFreshness = $Content -match '(?is)freshness|current or fast-changing|latest documentation|stale|過時|Local Version Versus Latest Documentation|高變動'

        return ($hasHighChange -and $hasOfficialPrimary -and $hasMissingEvidence -and $hasModelMemoryBoundary -and $hasFreshness)
    }

    function Test-HighChangeGroundingReferencedPolicy {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }
        if ($Content -notmatch 'grounding-governance\.md') { return $false }

        foreach ($reference in (Get-HighChangeGroundingReferenceTokens -Content $Content)) {
            if ($reference -notmatch 'grounding-governance\.md') { continue }

            foreach ($candidatePath in (Get-HighChangeGroundingReferenceCandidatePaths -Reference $reference)) {
                if (-not (Test-Path -LiteralPath $candidatePath)) { continue }
                $referenceContent = Get-Content -LiteralPath $candidatePath -Raw -Encoding UTF8
                if (Test-HighChangeGroundingReferencePolicyContent -Content $referenceContent) {
                    return $true
                }
            }
        }

        return $false
    }

    foreach ($target in $targets) {
        $displayPath = if (Test-Path -LiteralPath $target.Path) { Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path } else { $target.Path }
        if (-not (Test-Path -LiteralPath $target.Path)) {
            Add-HighChangeGroundingFinding -Severity 'Red' -File $displayPath -Line 1 -Reason ("缺少外部接地查證治理目標：{0}" -f $target.Scope) -Text $target.Path
            continue
        }

        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $missing = New-Object System.Collections.Generic.List[string]
        foreach ($checkName in @($target.Checks)) {
            if (-not $groundingChecks.ContainsKey($checkName)) { continue }
            $check = $groundingChecks[$checkName]
            if ($content -notmatch $check.Pattern) {
                $missing.Add($check.Label)
            }
        }

        $hasReferenceBackedGrounding = (
            $target.Scope -like 'platform-capability-matrix-*' -and
            (Test-HighChangeGroundingReferencedPolicy -Content $content)
        )

        if ((@($missing).Count -gt 0) -and (-not $hasReferenceBackedGrounding)) {
            Add-HighChangeGroundingFinding -Severity 'Red' -File $displayPath -Line 1 -Reason ("{0} 缺少外部接地查證治理能力：{1}" -f $target.Scope, (($missing.ToArray()) -join ', ')) -Text '政策主體缺失。'
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 高變動外部接地查證（High-Change Grounding）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line, Reason) {
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
