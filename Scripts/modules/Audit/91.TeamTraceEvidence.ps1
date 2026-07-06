# Internal partial for Audit.psm1. Loaded by the facade only.
# Team trace evidence

function Measure-TeamTraceEvidence {
    <#
    .SYNOPSIS
        檢查 Team-Native task trace 是否存在並含有最小欄位。預設不要求 trace；只有 RequireTeamTrace 時缺 trace 才是紅燈。
    #>
    param(
        [string]$TargetRoot = ".",
        [string]$TeamTraceRoot,
        [switch]$RequireTeamTrace
    )

    $TargetRoot = (Resolve-Path $TargetRoot).Path
    if (-not $TeamTraceRoot) {
        $TeamTraceRoot = Join-Path $TargetRoot '.agents\logs\team-traces'
    } elseif (-not [System.IO.Path]::IsPathRooted($TeamTraceRoot)) {
        $TeamTraceRoot = Join-Path $TargetRoot $TeamTraceRoot
    }

    $results = New-Object System.Collections.ArrayList

    function Add-TeamTraceFinding {
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

    function Test-TeamTracePositiveLine {
        param(
            [string]$Content,
            [string]$Pattern
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }
        foreach ($line in ($Content -split "\r?\n")) {
            if (($line -match $Pattern) -and (-not (Test-AuditLineIsNegative -Line $line))) {
                return $true
            }
        }

        return $false
    }

    function Get-TeamTraceFirstPositiveIndex {
        param(
            [string]$Content,
            [string]$Pattern
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return -1 }
        $matches = [regex]::Matches($Content, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($match in $matches) {
            $lineStart = $Content.LastIndexOf("`n", $match.Index)
            if ($lineStart -lt 0) {
                $lineStart = 0
            } else {
                $lineStart++
            }

            $lineEnd = $Content.IndexOf("`n", $match.Index)
            if ($lineEnd -lt 0) { $lineEnd = $Content.Length }
            $line = $Content.Substring($lineStart, $lineEnd - $lineStart)
            if (-not (Test-AuditLineIsNegative -Line $line)) {
                return $match.Index
            }
        }

        return -1
    }

    function Get-TeamTraceFieldValue {
        param(
            [string]$Content,
            [string[]]$Fields
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return '' }
        foreach ($field in $Fields) {
            $escaped = [regex]::Escape($field)
            $patterns = @(
                "(?im)^\s*[""']?$escaped[""']?\s*[:=]\s*[""']?([^,""'\r\n\]\}]+)",
                "(?im)^\s*[-*]\s*$escaped\s*[:=]\s*[""']?([^,""'\r\n\]\}]+)"
            )
            foreach ($pattern in $patterns) {
                $match = [regex]::Match($Content, $pattern)
                if ($match.Success) {
                    $value = ($match.Groups[1].Value -replace '[,\]\}]\s*$', '').Trim()
                    $value = $value.Trim([char]34).Trim([char]39).Trim([char]96).Trim()
                    if ($value) { return $value }
                }
            }
        }

        return ''
    }

    function Get-TeamTraceFieldRawValue {
        param(
            [string]$Content,
            [string[]]$Fields
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return '' }
        foreach ($field in $Fields) {
            $escaped = [regex]::Escape($field)
            $patterns = @(
                "(?im)^\s*[""']?$escaped[""']?\s*[:=]\s*(?<value>[^\r\n]+)",
                "(?im)^\s*[-*]\s*$escaped\s*[:=]\s*(?<value>[^\r\n]+)"
            )
            foreach ($pattern in $patterns) {
                $match = [regex]::Match($Content, $pattern)
                if ($match.Success) {
                    $value = ($match.Groups['value'].Value -replace '[\]\}]\s*$', '').Trim()
                    $value = $value.Trim([char]34).Trim([char]39).Trim([char]96).Trim()
                    if ($value) { return $value }
                }
            }
        }

        return ''
    }

    function Get-TeamTraceNormalizedValue {
        param([string]$Value)

        if ([string]::IsNullOrWhiteSpace($Value)) { return '' }
        $normalized = $Value.Trim().Trim('"', "'").Trim([char]96).Trim()
        $normalized = ($normalized -replace '[,\]\}]\s*$', '').Trim()
        $normalized = (($normalized -split '\s+-\s+|[;,#]')[0]).Trim().Trim('"', "'").Trim([char]96).Trim()
        if (-not $normalized) { return '' }
        $normalized = $normalized.ToLowerInvariant()

        $commonAliases = @{
            'not applicable'        = 'not-applicable'
            'not_applicable'        = 'not-applicable'
            'formal readonly'       = 'formal-readonly'
            'formal_readonly'       = 'formal-readonly'
            'formal read only'      = 'formal-readonly'
            'formal write'          = 'formal-write'
            'formal_write'          = 'formal-write'
            'not authorized'        = 'not-authorized'
            'not_authorized'        = 'not-authorized'
            'direct exception'      = 'direct-exception'
            'direct_exception'      = 'direct-exception'
            'closed with director risk' = 'closed-with-director-risk'
            'closed_with_director_risk' = 'closed-with-director-risk'
        }
        if ($commonAliases.ContainsKey($normalized)) {
            return $commonAliases[$normalized]
        }

        return $normalized
    }

    function Resolve-TeamTraceCanonicalValue {
        param(
            [string]$Field,
            [string]$Value
        )

        $normalized = Get-TeamTraceNormalizedValue -Value $Value
        if (-not $normalized) { return '' }

        $aliases = @{
            station_mode = @{
                'readonly'          = 'read-only'
                'read only'         = 'read-only'
                'review-readonly'   = 'review'
                'station-deep-read' = 'read-only'
                'deep-read'         = 'read-only'
            }
            context_visibility = @{
                'station-deep-read'      = 'specialist-deep-read'
                'deep-read'              = 'specialist-deep-read'
                'specialist deep read'   = 'specialist-deep-read'
                'specialist-deepread'    = 'specialist-deep-read'
                'review-readonly'        = 'shared-visible'
            }
        }

        if ($aliases.ContainsKey($Field) -and $aliases[$Field].ContainsKey($normalized)) {
            return $aliases[$Field][$normalized]
        }

        return $normalized
    }

    function Test-TeamTraceEvidenceValue {
        param(
            [string]$Value,
            [switch]$AllowNonApplicable
        )

        if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
        $normalized = $Value.Trim().Trim('"', "'").Trim([char]96).Trim()
        $normalized = ($normalized -replace '[,\]\}]\s*$', '').Trim()
        if (-not $normalized) { return $false }
        if ($AllowNonApplicable -and ($normalized -match '(?i)^(none|n/a|not-applicable|not applicable|無|不適用)$')) {
            return $true
        }

        return ($normalized -notmatch '(?i)^(null|none|n/a|not-applicable|not applicable|missing|empty|blocked|unverified|\[\]|\{\}|無|未提供|不適用)$')
    }

    function Test-TeamTraceFieldHasValue {
        param(
            [string]$Content,
            [string]$Field,
            [switch]$AllowNonApplicable
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }
        $escaped = [regex]::Escape($Field)
        $patterns = @(
            "(?im)^\s*[""']?$escaped[""']?\s*[:=]\s*(?<value>[^\r\n]+)",
            "(?im)^\s*[-*]\s*$escaped\s*[:=]\s*(?<value>[^\r\n]+)"
        )
        foreach ($pattern in $patterns) {
            foreach ($match in [regex]::Matches($Content, $pattern)) {
                if (Test-AuditLineIsNegative -Line $match.Value) { continue }
                if (Test-TeamTraceEvidenceValue -Value $match.Groups['value'].Value -AllowNonApplicable:$AllowNonApplicable) {
                    return $true
                }
            }
        }

        $blockPattern = "(?ims)^\s*[""']?$escaped[""']?\s*[:=]\s*(?:\r?\n(?<block>(?:\s*[-*]\s+.+|\s+[-*{].+|\s{2,}.+)(?:\r?\n|$)){1,12})"
        $blockMatch = [regex]::Match($Content, $blockPattern)
        if ($blockMatch.Success) {
            return (Test-TeamTraceEvidenceValue -Value $blockMatch.Groups['block'].Value -AllowNonApplicable:$AllowNonApplicable)
        }

        return $false
    }

    function Get-TeamTracePositiveLineCount {
        param(
            [string]$Content,
            [string]$Pattern
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return 0 }
        $count = 0
        foreach ($line in ($Content -split "\r?\n")) {
            if (($line -match $Pattern) -and (-not (Test-AuditLineIsNegative -Line $line))) {
                $count++
            }
        }

        return $count
    }

    function Test-TeamTraceUnsafeCaptainAuthoring {
        param(
            [string]$Content
        )

        $captainAuthoringFields = @(
            'captain_substitute_authoring',
            'captain substitute authoring',
            'captain_authored',
            'captain authored'
        )
        $noCaptainAuthoringFields = @(
            'no_captain_authoring',
            'no captain authoring'
        )
        $safeValuePattern = '(?i)^(false|none|n/a|not-applicable|not applicable|blocked|unverified|closed-with-director-risk|no|無|不適用|阻塞|未驗證|總監風險關閉)$'
        $unsafeValuePattern = '(?i)^(true|yes|actual|confirmed|present|captain-authored|captain authored|captain-substituted|captain substituted|substitute-authoring|substitute authoring|substitution|substituted|代工|替代|替代創作|隊長代工|隊長替代)$'

        foreach ($field in $captainAuthoringFields) {
            $value = Get-TeamTraceFieldValue -Content $Content -Fields @($field)
            if (-not $value) { continue }

            $normalized = ($value -split '[;,]')[0].Trim().Trim('"', "'").Trim([char]96).Trim()
            if (-not $normalized) { continue }
            if ($normalized -match $safeValuePattern) { continue }
            if ($normalized -match $unsafeValuePattern) { return $true }
        }

        foreach ($field in $noCaptainAuthoringFields) {
            $value = Get-TeamTraceFieldValue -Content $Content -Fields @($field)
            if (-not $value) { continue }

            $normalized = ($value -split '[;,]')[0].Trim().Trim('"', "'").Trim([char]96).Trim()
            if (-not $normalized) { continue }
            if ($normalized -match $unsafeValuePattern) { continue }
            if ($normalized -match $safeValuePattern) { return $true }
        }

        return $false
    }

    function Test-TeamTraceHistoricalNonRequired {
        param(
            [string]$Content,
            [string]$RelativePath
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }
        $completionStateValue = Get-TeamTraceFieldValue -Content $Content -Fields @('completion_state', 'completion state', '完成狀態')
        if ((Get-TeamTraceNormalizedValue -Value $completionStateValue) -ne 'not-applicable') { return $false }

        $hasHistoricalMarker = $Content -match '(?i)(historical partial trace|non-required trace|historical incident|incident log|歷史|事件紀錄)'
        $hasNonRequiredMarker = $Content -match '(?i)(non-required trace|not required|not-applicable.{0,120}(historical|incident)|not.{0,120}(formal Team-Native completion evidence|completion evidence)|cannot prove formal Team-Native completion|不可作.{0,80}完成證據|不能.{0,80}完成證據|不是.{0,80}完成證據)'
        $hasHistoricalPath = $RelativePath -match '(?i)(team-traces[\\/].*(historical|incident|ignored|archive)|historical|incident|archive)'

        return ($hasHistoricalMarker -and $hasNonRequiredMarker -and $hasHistoricalPath)
    }

    function Test-TeamTraceFieldValueIsNonApplicable {
        param([string]$Value)

        $normalized = Get-TeamTraceNormalizedValue -Value $Value
        return (-not $normalized) -or ($normalized -match '^(none|n/a|not-applicable|not applicable|blocked|unverified|無|不適用|阻塞|未驗證)$')
    }

    function Resolve-TeamTracePairPath {
        param(
            [string]$Root,
            [string]$PathText
        )

        if ([string]::IsNullOrWhiteSpace($PathText)) { return '' }
        $clean = $PathText.Trim().Trim('"', "'").Trim([char]96).Trim()
        $clean = ($clean -replace '^(source|src|target|deployed|runtime|dst|dest)\s*[:=]\s*', '').Trim()
        $clean = (($clean -split '\s+-\s+')[0]).Trim()
        if (-not $clean) { return '' }
        if ([System.IO.Path]::IsPathRooted($clean)) { return $clean }
        return (Join-Path $Root $clean)
    }

    function Get-TeamTraceSourceDeployedPair {
        param(
            [string]$Value,
            [string]$Root
        )

        if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
        $text = $Value.Trim().Trim('"', "'").Trim([char]96).Trim()
        $sourceText = ''
        $targetText = ''

        $namedMatch = [regex]::Match($text, '(?i)(?:source|src)\s*[:=]\s*(?<source>[^;|,\r\n]+)\s*[;|,]\s*(?:target|deployed|runtime|dst|dest)\s*[:=]\s*(?<target>[^;|,\r\n]+)')
        if ($namedMatch.Success) {
            $sourceText = $namedMatch.Groups['source'].Value
            $targetText = $namedMatch.Groups['target'].Value
        } else {
            $arrowMatch = [regex]::Match($text, '(?<source>[^|;,\r\n]+?)\s*(?:<->|->|=>|\|)\s*(?<target>[^;,\r\n]+)')
            if ($arrowMatch.Success) {
                $sourceText = $arrowMatch.Groups['source'].Value
                $targetText = $arrowMatch.Groups['target'].Value
            }
        }

        if ([string]::IsNullOrWhiteSpace($sourceText) -or [string]::IsNullOrWhiteSpace($targetText)) {
            return $null
        }

        return [PSCustomObject]@{
            SourceText = $sourceText.Trim()
            TargetText = $targetText.Trim()
            SourcePath = Resolve-TeamTracePairPath -Root $Root -PathText $sourceText
            TargetPath = Resolve-TeamTracePairPath -Root $Root -PathText $targetText
        }
    }

    $registeredRoleIds = @(
        'intent-requirements',
        'scope-impact',
        'external-research',
        'architecture-contract',
        'change-delivery',
        'validation',
        'review',
        'security-reliability',
        'memory-docs',
        'release-completion'
    )

    $traceFiles = @()
    if (Test-Path -LiteralPath $TeamTraceRoot -PathType Container) {
        $traceFiles = @(Get-ChildItem -LiteralPath $TeamTraceRoot -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @('.md', '.json', '.txt') })
    }

    if (@($traceFiles).Count -eq 0) {
        if ($RequireTeamTrace) {
            Add-TeamTraceFinding -Severity 'Red' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $TeamTraceRoot) -Line 1 -Reason '要求 Team-Native trace，但找不到任務軌跡檔' -Text '缺少 Team-Native 任務軌跡證據（team trace evidence）。'
        }

        $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
        $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count
        Write-Host ""
        Write-Host "📊 團隊軌跡證據（Team Trace Evidence）"
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        if ($RequireTeamTrace) {
            Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
        } else {
            Write-Host "狀態：不適用（未要求 Team-Native trace）"
        }
        foreach ($finding in $results | Sort-Object Severity, File, Reason) {
            $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
            Write-Host ("  {0} {1}:{2} — {3} — {4}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason, $finding.Text) -ForegroundColor $color
        }
        return [PSCustomObject]@{
            Results     = @($results.ToArray())
            RedCount    = $redCount
            YellowCount = $yellowCount
            Passed      = ($redCount -eq 0)
            TraceRoot   = $TeamTraceRoot
            TraceFiles  = @()
            ValidCount  = 0
            Required    = [bool]$RequireTeamTrace
        }
    }

    $requiredFields = @(
        'task_id',
        'task_type',
        'workflow_route',
        'board_state',
        'operation_mode',
        'operation_mode_reason',
        'implementation_authorization',
        'go_evidence',
        'authorization_source',
        'authorization_target',
        'authorization_scope',
        'authorization_phase',
        'authorization_evidence',
        'authorization_expiry',
        'authorization_resolution_state',
        'platform_mode_observed',
        'specialist_role_source',
        'role_id',
        'role_instance_id',
        'exclusive_task_scope',
        'specialist_skill',
        'assigned_specialist_skill',
        'loaded_skill_refs',
        'handoff_packet_id',
        'domain_label',
        'requested_execution_channel',
        'channel_capability',
        'channel_invocation_status',
        'execution_route',
        'startup_started_at',
        'first_response_deadline',
        'last_progress_at',
        'timeout_action',
        'standby_reason',
        'execution_channel',
        'station_state',
        'evidence_state',
        'station_lifecycle_state',
        'station_mode',
        'context_visibility',
        'handoff_ownership',
        'retention_reason',
        'conversation_health',
        'reuse_count',
        'handoff_summary',
        'closure_reason',
        'closeout_lane',
        'yellow_classification',
        'yellow_resolution_state',
        'repair_loop_count',
        'delivery_artifact',
        'delivery_artifact_id',
        'delivery_artifact_status',
        'author_role',
        'source_input',
        'integrable_scope',
        'review_state',
        'validation_state',
        'memory_docs_state',
        'no_captain_authoring',
        'stations',
        'waves',
        'delivery_artifacts',
        'direct_exceptions',
        'role_separation',
        'completion_state',
        'risk_close_evidence',
        'residual_risk',
        'source_deployed_pair',
        'sync_direction',
        'sync_evidence'
    )

    $validCount = 0
    $ignoredHistoricalCount = 0
    foreach ($file in $traceFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
        $rel = Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file.FullName
        if (Test-TeamTraceHistoricalNonRequired -Content $content -RelativePath $rel) {
            $ignoredHistoricalCount++
            Add-TeamTraceFinding -Severity 'Yellow' -File $rel -Line 1 -Reason 'historical partial / non-required trace 不列入本次 live-required 完成證據' -Text '此紀錄明示 completion_state: not-applicable，且只作歷史事件或非必要 trace 分類；不以缺少正式站點欄位阻塞本次 live completion。'
            continue
        }

        $hardTracePattern = '(?i)\boperation_mode\b\s*[:=]\s*["'']?full\b|governance-impact|governance impact|Doctor/Audit|audit rules|routine audit|commit-release|commit/release|治理影響|巡檢規則|提交發布準備|提交發布'
        $requiresHardTrace = Test-TeamTracePositiveLine -Content $content -Pattern $hardTracePattern
        $completeClaimPattern = '(?i)\bcompletion_state\b\s*[:=]\s*["'']?(complete|completed|full-team-complete|full_team_complete)\b|full team completion|完整團隊完成|完整完成'
        $completeClaim = Test-TeamTracePositiveLine -Content $content -Pattern $completeClaimPattern
        $missing = @()
        foreach ($field in $requiredFields) {
            if ($content -notmatch [regex]::Escape($field)) {
                $missing += $field
            }
        }

        if ($completeClaim) {
            $statusLifecycleContextPattern = '(?i)(status probe|status_probe|生命探針|狀態探針|pause.{0,80}report|暫停.{0,80}回報|awaiting-resume|等待恢復|resume-sent|恢復送出)'
            $replacementLifecycleContextPattern = '(?i)(replacement|replaced|replaces_channel_run_id|replacement_reason|替換|換員)'
            $lateLifecycleContextPattern = '(?i)(late result|late-result|late_result|return_timing\s*[:=]\s*["'']?late\b|晚到結果|遲到結果)'
            $closureLifecycleContextPattern = '(?i)(channel_run_id|channel_generation|final channel closure|final_channel_closure_reason|通道關閉)'

            $conditionalLifecycleFields = @()
            if (Test-TeamTracePositiveLine -Content $content -Pattern $statusLifecycleContextPattern) {
                $conditionalLifecycleFields += @('status_probe_state', 'status_probe_sent_at')
                if (Test-TeamTracePositiveLine -Content $content -Pattern '(?i)(responded|response|paused|pause.{0,80}report|暫停.{0,80}回報|回應)') {
                    $conditionalLifecycleFields += @('status_probe_response_at', 'status_probe_pause_report')
                }
                if (Test-TeamTracePositiveLine -Content $content -Pattern '(?i)(resume|resumed|awaiting-resume|resume-sent|繼續|恢復|等待恢復)') {
                    $conditionalLifecycleFields += @('status_probe_resume_state')
                    if ($content -notmatch [regex]::Escape('status_probe_resume_sent_at')) {
                        $missing += 'status_probe_resume_sent_at'
                    }
                }
            }
            if (Test-TeamTracePositiveLine -Content $content -Pattern $replacementLifecycleContextPattern) {
                $conditionalLifecycleFields += @('channel_generation', 'replacement_reason', 'late_result_policy', 'cancellation_state')
            }
            if (Test-TeamTracePositiveLine -Content $content -Pattern $lateLifecycleContextPattern) {
                $conditionalLifecycleFields += @('late_result_policy', 'late_result_window', 'receipt_decision', 'receipt_decision_reason')
            }
            if (Test-TeamTracePositiveLine -Content $content -Pattern $closureLifecycleContextPattern) {
                $conditionalLifecycleFields += @('final_channel_closure_reason')
            }

            foreach ($field in ($conditionalLifecycleFields | Select-Object -Unique)) {
                if ($content -notmatch [regex]::Escape($field)) {
                    $missing += $field
                }
            }
        }

        if (@($missing).Count -eq 0) {
            $validCount++
        } else {
            $severity = if ($RequireTeamTrace -or $requiresHardTrace) { 'Red' } else { 'Yellow' }
            Add-TeamTraceFinding -Severity $severity -File $rel -Line 1 -Reason 'Team-Native trace 欄位不完整' -Text ("缺少：{0}" -f (Format-AuditFieldListDisplay -Fields $missing))
        }

        $legacyTracePattern = '補丁包|implementation patch|text patch|captain substitution accepted-risk|patch packet|delivery packet|補丁封包|舊封包'
        $newTracePattern = 'authorization_source|authorization_target|authorization_scope|authorization_phase|authorization_evidence|authorization_expiry|authorization_resolution_state|platform_mode_observed|specialist_skill|domain_label|requested_execution_channel|channel_capability|channel_invocation_status|execution_channel|delivery_artifact|delivery_artifact_status|no_captain_authoring'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $legacyTracePattern) {
            $legacyText = if ($content -match $newTracePattern) {
                '舊式 patch/packet 字眼與新版 trace 欄位同時出現；只能作遺留偵測，不能當完成證據。'
            } else {
                '請補新版 trace 欄位：專家技能（specialist_skill）、領域標籤（domain_label）、請求執行通道（requested_execution_channel）、通道能力（channel_capability）、通道啟動狀態（channel_invocation_status）、交付件（delivery_artifact）、無隊長代工證據（no_captain_authoring）。'
            }
            Add-TeamTraceFinding -Severity 'Yellow' -File $rel -Line 1 -Reason 'Team-Native trace 使用舊補丁、packet 或隊長代工語義，只能作遺留偵測' -Text $legacyText
        }

        $isActiveTeamTrace = (Test-ProgrammingTeamActiveTeamContext -Content $content) -and (-not (Test-ProgrammingTeamInactiveTeamContext -Content $content))
        $isNoWriteTrace = $content -match '(?i)\bimplementation_authorization\b\s*[:=]\s*["'']?(no-write|plan-only)\b|\bno-write\b|無寫入|唯讀'
        $isExplorationTrace = $content -match '(?i)\btask_type\b\s*[:=]\s*["'']?(exploration|discussion|validation-audit)\b|read-only exploration|no-write exploration|無寫入探索|唯讀探索|探索'
        $hasFormalReadonlyTrace = $content -match '(?i)formal-readonly|formal readonly|Team-First.{0,120}(read[- ]?only|readonly|唯讀)|正式.{0,80}(唯讀|無寫入)'
        if ($isActiveTeamTrace -and $isNoWriteTrace -and $isExplorationTrace -and (-not $hasFormalReadonlyTrace)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'active Team trace 無寫入探索缺少 formal-readonly' -Text 'Team mode active 的無寫入探索必須記錄正式唯讀團隊路由；未啟動 Team mode 的 no-write/readonly 走一般生命週期。'
        }

        $operationMode = Get-TeamTraceFieldValue -Content $content -Fields @('operation_mode', 'operation mode', '操作模式')
        $normalizedOperationMode = Resolve-TeamTraceCanonicalValue -Field 'operation_mode' -Value $operationMode
        if ($operationMode -and ($normalizedOperationMode -notmatch '^(daily|full)$')) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'Team-Native trace 的 operation_mode 不是 daily 或 full' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'operation_mode'), $operationMode)
        }
        $fullOnlyTracePattern = '(?i)(implementation|repair|bottom-layer refactor|cross-file governance|specialist skill rewrite|governance-impact|governance impact|Doctor/Audit|audit rules|routine audit|commit-release|commit/release|release|deploy|protected mutation|實作|修復|底層重構|跨檔治理|治理影響|專家技能改寫|巡檢規則|巡檢|提交發布準備|提交發布|發布|部署|保護狀態)'
        if (($normalizedOperationMode -eq 'daily') -and (Test-TeamTracePositiveLine -Content $content -Pattern $fullOnlyTracePattern)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'full-only 任務軌跡不得使用 daily 模式' -Text '此任務需使用完整模式：操作模式（operation_mode）: full；適用於 implementation、bottom-layer refactor、Doctor/Audit、release、deploy、protected mutation。'
        }

        $roleId = Get-TeamTraceFieldValue -Content $content -Fields @('role_id', 'role id', '角色代號')
        $normalizedRoleId = Resolve-TeamTraceCanonicalValue -Field 'role_id' -Value $roleId
        if ($roleId -and ($registeredRoleIds -notcontains $normalizedRoleId) -and ($normalizedRoleId -notmatch '^(blocked|unverified|not-applicable|closed-with-director-risk)$')) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'Team-Native trace 使用未登記的 role_id' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'role_id'), $roleId)
        }
        $exclusiveTaskScope = Get-TeamTraceFieldValue -Content $content -Fields @('exclusive_task_scope', 'exclusive task scope', '互斥任務範圍')
        $normalizedExclusiveTaskScope = Resolve-TeamTraceCanonicalValue -Field 'exclusive_task_scope' -Value $exclusiveTaskScope
        if ($exclusiveTaskScope -and ($normalizedExclusiveTaskScope -notmatch '^(task|blocked|unverified|not-applicable|closed-with-director-risk)$')) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'Team-Native trace 的 exclusive_task_scope 不是 task 或誠實阻塞狀態' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'exclusive_task_scope'), $exclusiveTaskScope)
        }

        $allowedTraceValueSets = @{
            board_state                 = @('draft', 'formal-readonly', 'formal-write')
            channel_capability          = @('available', 'conditional', 'unavailable', 'unverified')
            channel_invocation_status   = @('not-started', 'requested', 'running', 'returned', 'unavailable', 'blocked', 'not-authorized')
            station_state               = @('assigned', 'standby', 'running', 'returned', 'blocked', 'unverified', 'closed-with-director-risk', 'not-applicable')
            evidence_state              = @('pending', 'returned', 'logged', 'routed-to-owner-station', 'blocked', 'unverified', 'closed-with-director-risk', 'not-applicable')
            station_lifecycle_state     = @('assigned', 'standby', 'retained', 'reused', 'handoff-required', 'closed', 'replaced', 'blocked', 'not-applicable')
            station_mode                = @('read-only', 'change-delivery', 'change-application', 'validation', 'review', 'memory-docs', 'completion', 'protected-gate', 'not-applicable')
            context_visibility          = @('specialist-deep-read', 'captain-coordination-only', 'shared-visible', 'unread', 'not-applicable')
            handoff_ownership           = @('station-owned', 'platform-nondelegable-gate', 'returned-to-captain', 'reassigned', 'blocked', 'unverified', 'not-applicable')
            status_probe_state          = @('not-sent', 'sent', 'paused-reported', 'responded-paused', 'awaiting-resume', 'responded-extension-requested', 'responded-blocked', 'unresponsive', 'unavailable', 'not-applicable')
            status_probe_resume_state   = @('awaiting-resume', 'resume-sent', 'resumed', 'blocked', 'unavailable')
            timeout_action              = @('standby', 'replace', 'blocked', 'unverified', 'director-input', 'not-applicable')
            late_result_policy          = @('late-result-pending', 'receive-and-compare', 'accept-until-hard-timeout', 'ignore-after-cancelled', 'blocked', 'unverified', 'not-applicable')
            cancellation_state          = @('not-requested', 'cancellation-pending', 'requested', 'acknowledged', 'ignored', 'unavailable', 'not-applicable')
            return_timing               = @('on-time', 'late', 'not-returned', 'not-applicable')
            receipt_decision            = @('logged', 'included-in-synthesis-ledger', 'routed-to-owner-station', 'superseded-by-replacement', 'out-of-scope', 'duplicate', 'conflict-review', 'blocked', 'unverified', 'not-applicable')
            delivery_artifact_status    = @('pending', 'returned', 'logged', 'applied-by-owner-station', 'blocked', 'unverified', 'closed-with-director-risk', 'not-applicable')
            review_state                = @('not-started', 'pending', 'collecting-evidence', 'findings-open', 'accepted', 'fix-required', 'fixed-pending-validation', 'blocked', 'unverified', 'accepted-risk', 'not-applicable')
            validation_state            = @('not-started', 'pending', 'passed', 'failed', 'blocked', 'unverified', 'not-applicable')
            memory_docs_state           = @('not-started', 'memory_delivery', 'blocked', 'unverified', 'closed-with-director-risk', 'not-applicable')
            tool_execution_envelope_trust = @('trusted', 'untrusted', 'blocked', 'unverified', 'not-applicable')
        }
        foreach ($allowedEntry in $allowedTraceValueSets.GetEnumerator()) {
            $traceValue = Get-TeamTraceFieldValue -Content $content -Fields @($allowedEntry.Key)
            if (-not $traceValue) { continue }

            $normalizedTraceValue = Resolve-TeamTraceCanonicalValue -Field $allowedEntry.Key -Value $traceValue
            if ($allowedEntry.Value -notcontains $normalizedTraceValue) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'Team-Native trace 使用未登記的狀態值' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field $allowedEntry.Key), $traceValue)
            }
        }

        $noWriteNoTeamPattern = '(?i)(no-write|read-only|無寫入|唯讀).{0,160}(no-team|no team|without team|skip team|不用(團隊|隊員)|不需要(團隊|隊員)|無團隊)'
        $noWriteNoTeamAllowedNegative = '(?i)(does not mean|must not mean|not equal|must not|do not|不是|不代表|不得|不可|不能|不應|禁止)'
        $hasBadNoWriteNoTeamTrace = $false
        foreach ($line in ($content -split "\r?\n")) {
            $activeTeamLine = Test-ProgrammingTeamActiveTeamContext -Content $line
            $inactiveTeamLine = Test-ProgrammingTeamInactiveTeamContext -Content $line
            if (($line -match $noWriteNoTeamPattern) -and ($line -notmatch $noWriteNoTeamAllowedNegative) -and $activeTeamLine -and (-not $inactiveTeamLine)) {
                $hasBadNoWriteNoTeamTrace = $true
                break
            }
        }
        if ($hasBadNoWriteNoTeamTrace) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'active Team trace 把 no-write 或唯讀解讀成 no-team' -Text 'Team mode active 後，唯讀或無寫入狀態（no-write）只限制變更動作，不代表可以移除正式團隊站點。'
        }

        $hasNotStartedChannel = $content -match '(?im)^\s*[-*]?\s*["'']?channel_invocation_status["'']?\s*[:=]\s*["'']?not-started\b'
        $hasChannelAttemptOrClosure = $content -match '(?im)^\s*[-*]?\s*["'']?channel_invocation_status["'']?\s*[:=]\s*["'']?(requested|running|returned|unavailable|blocked|not-authorized)\b'
        $hasNotStartedExplanation = $content -match '(?i)(not-started|未啟動).{0,200}(reason|because|blocked|unverified|unavailable|not-authorized|standby|原因|阻塞|未驗證|不可用|未授權|待命)'
        if ($hasNotStartedChannel -and (-not $hasChannelAttemptOrClosure) -and (-not $hasNotStartedExplanation)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '隊員通道未嘗試啟動也未回報' -Text '通道狀態 not-started 必須附上 standby、blocked、unverified、unavailable、not-authorized 或具體原因。'
        }

        $hasUnavailableChannel = $content -match '(?im)^\s*[-*]?\s*["'']?channel_capability["'']?\s*[:=]\s*["'']?(unavailable|conditional)\b|^\s*[-*]?\s*["'']?channel_invocation_status["'']?\s*[:=]\s*["'']?(not-started|unavailable|blocked|not-authorized|standby)\b'
        if ($hasUnavailableChannel) {
            $monitoringFields = @(
                'startup_started_at',
                'first_response_deadline',
                'last_progress_at',
                'timeout_action',
                'standby_reason'
            )
            $missingMonitoringFields = @()
            foreach ($field in $monitoringFields) {
                if ($content -notmatch [regex]::Escape($field)) {
                    $missingMonitoringFields += $field
                }
            }
            if (@($missingMonitoringFields).Count -gt 0) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '隊員通道不可用或未啟動時缺少監控欄位' -Text ("缺少：{0}" -f (Format-AuditFieldListDisplay -Fields $missingMonitoringFields))
            }
        }

        $stateValuePattern = '(?i)^(blocked|unverified|standby|not-authorized|unavailable|closed-with-director-risk|direct|direct_exception|direct-exception)$'
        foreach ($routeField in @('execution_route', 'execution_channel', 'platform_route', 'execution mode', 'execution_mode')) {
            $routeValue = Get-TeamTraceFieldValue -Content $content -Fields @($routeField)
            $normalizedRouteValue = Resolve-TeamTraceCanonicalValue -Field $routeField -Value $routeValue
            if ($routeValue -and ($normalizedRouteValue -match $stateValuePattern)) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '路由欄位混入狀態或直行例外值' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field $routeField), $routeValue)
            }
        }

        $toolEnvelopePolicyPattern = '(?i)(tool envelope policy|tool execution envelope policy|trusted tool envelope|trusted_issuer|trusted issuer|tool_execution_envelope|tool_execution_envelope_trust|tool_envelope_issuer|tool_envelope_signature|tool_envelope_nonce|execution_receipt|execution_receipt_decision|新版工具信封|可信工具信封|工具執行信封)'
        $traceDateText = Get-TeamTraceFieldValue -Content $content -Fields @('created_at', 'created at', 'timestamp', 'updated_at', 'date', '日期')
        $isNewToolEnvelopeTraceByDate = $traceDateText -match '(?i)\b(2026-06-30|2026-0[7-9]|2026-1[0-2]|202[7-9]-)\b'
        $protectedToolTracePattern = '(?i)(protected mutation|authorized change-application|change-application|change application|memory-commit|memory commit|git|release|deployment|deploy|install|external-mutation|external mutation|write-capable|source write|apply_patch|Set-Content|Out-File|保護操作|保護狀態|寫入|提交|發布|部署|安裝)'
        $hasProtectedOrWriteCapableTrace = Test-TeamTracePositiveLine -Content $content -Pattern $protectedToolTracePattern
        $requiresToolEnvelopeEvidence = (Test-TeamTracePositiveLine -Content $content -Pattern $toolEnvelopePolicyPattern) -or $isNewToolEnvelopeTraceByDate -or $completeClaim -or $hasProtectedOrWriteCapableTrace

        $envelopeTrust = Get-TeamTraceFieldValue -Content $content -Fields @('tool_execution_envelope_trust', 'tool envelope trust')
        $normalizedEnvelopeTrust = Resolve-TeamTraceCanonicalValue -Field 'tool_execution_envelope_trust' -Value $envelopeTrust
        $receiptDecision = Get-TeamTraceFieldValue -Content $content -Fields @('execution_receipt_decision', 'execution receipt decision')
        $normalizedReceiptDecision = Resolve-TeamTraceCanonicalValue -Field 'execution_receipt_decision' -Value $receiptDecision
        $authorizationResolutionState = Get-TeamTraceFieldValue -Content $content -Fields @('authorization_resolution_state', 'authorization resolution state')
        $normalizedAuthorizationResolutionState = Resolve-TeamTraceCanonicalValue -Field 'authorization_resolution_state' -Value $authorizationResolutionState

        if ($hasProtectedOrWriteCapableTrace) {
            $toolEvidenceFields = @(
                'tool_execution_envelope',
                'tool_execution_envelope_trust',
                'tool_envelope_issuer',
                'tool_envelope_signature',
                'tool_envelope_nonce',
                'execution_receipt',
                'execution_receipt_decision'
            )
            $missingToolEvidenceFields = @()
            foreach ($toolField in $toolEvidenceFields) {
                if (-not (Test-TeamTraceFieldHasValue -Content $content -Field $toolField)) {
                    $missingToolEvidenceFields += $toolField
                }
            }
            if (@($missingToolEvidenceFields).Count -gt 0) {
                $toolEnvelopeSeverity = if ($requiresToolEnvelopeEvidence) { 'Red' } else { 'Yellow' }
                $toolEnvelopeReason = if ($requiresToolEnvelopeEvidence) {
                    '保護或寫入型任務缺少可信工具執行信封、trusted issuer/signature/nonce 或 matching receipt 證據'
                } else {
                    '舊版保護或寫入型任務缺少工具執行信封或回執證據，列為遺留非阻塞'
                }
                Add-TeamTraceFinding -Severity $toolEnvelopeSeverity -File $rel -Line 1 -Reason $toolEnvelopeReason -Text ("缺少：{0}；保護或寫入型正式 evidence 需要 trusted envelope、trusted issuer、signature、nonce 與 matching execution_receipt。" -f (Format-AuditFieldListDisplay -Fields $missingToolEvidenceFields))
            }

            $allowedEnvelopeTrustStates = @('trusted', 'untrusted', 'blocked', 'unverified', 'not-applicable')
            if ($requiresToolEnvelopeEvidence -and $envelopeTrust -and ($allowedEnvelopeTrustStates -notcontains $normalizedEnvelopeTrust)) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '工具執行信封信任狀態不可授權保護操作' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'tool_execution_envelope_trust'), $envelopeTrust)
            } elseif ($normalizedEnvelopeTrust -and ($normalizedEnvelopeTrust -ne 'trusted')) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '保護或寫入型任務必須使用 trusted 工具執行信封' -Text ("{0}: {1}；protected/write-capable trace 只有 canonical trusted 可支撐正式 evidence，且需 trusted issuer、signature、nonce 與 matching execution_receipt。" -f (Format-AuditFieldDisplay -Field 'tool_execution_envelope_trust'), $envelopeTrust)
            }
        }

        $hasFormalEnvelopeClaim = (-not $hasProtectedOrWriteCapableTrace) -and ($completeClaim -or ($normalizedReceiptDecision -eq 'allowed') -or ($normalizedAuthorizationResolutionState -eq 'authorized'))
        if ($normalizedEnvelopeTrust -and ($normalizedEnvelopeTrust -ne 'trusted') -and $hasFormalEnvelopeClaim) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '非 trusted 工具信封不得支撐 complete、授權或允許決策' -Text ("{0}: {1}；complete / authorized / allowed evidence 需要 canonical trusted envelope，並具備 trusted issuer、signature、nonce 與 matching execution_receipt。" -f (Format-AuditFieldDisplay -Field 'tool_execution_envelope_trust'), $envelopeTrust)
        }

        $dirtyTargetFields = @('dirty_target', 'existing_worktree_changes', 'existing_diff', 'modified_target', 'target_dirty', 'worktree_dirty')
        $dirtyTargetPositiveValuePattern = '(?i)^(true|yes|present|detected|dirty|modified|existing|required)$'
        $dirtyTargetClearValuePattern = '(?i)^(false|no|none|n/a|not-applicable|not applicable|absent|clean|clear|not detected|not present|no existing diff|checked clean)$'
        $dirtyTargetPattern = '(?i)\b(dirty target|existing worktree changes|existing diff|modified target|target dirty|worktree dirty)\b'
        $dirtyTargetClearLinePattern = '(?i)(\b(no existing diff|existing diff absent|without existing diff)\b|\b(no dirty target|no target dirty|no worktree dirty|no modified target|no existing worktree changes)\b|\b(dirty target|existing worktree changes|existing diff|modified target|target dirty|worktree dirty)\b\s*(?::|=)?\s*(is\s+|was\s+|checked\s+)?(false|no|none|not-applicable|not applicable|absent|clean|clear|not detected|not present|checked clean)\b)'
        $hasDirtyTargetTrace = $false
        foreach ($dirtyField in $dirtyTargetFields) {
            $dirtyValue = Get-TeamTraceFieldValue -Content $content -Fields @($dirtyField)
            if (-not $dirtyValue) { continue }
            if ($dirtyValue -match $dirtyTargetClearValuePattern) { continue }
            if ($dirtyValue -match $dirtyTargetPositiveValuePattern) {
                $hasDirtyTargetTrace = $true
                break
            }
        }
        if (-not $hasDirtyTargetTrace) {
            foreach ($line in ($content -split "\r?\n")) {
                if ($line -notmatch $dirtyTargetPattern) { continue }
                if (Test-AuditLineIsNegative -Line $line) { continue }
                if ($line -match $dirtyTargetClearLinePattern) { continue }
                $hasDirtyTargetTrace = $true
                break
            }
        }
        if ($hasDirtyTargetTrace) {
            $missingDirtyTargetFields = @()
            foreach ($dirtyEvidenceField in @('current_diff_evidence', 'target_section_evidence', 'integration_strategy')) {
                if (-not (Test-TeamTraceFieldHasValue -Content $content -Field $dirtyEvidenceField)) {
                    $missingDirtyTargetFields += $dirtyEvidenceField
                }
            }
            $hasExistingChangeIdentity = (
                (Test-TeamTraceFieldHasValue -Content $content -Field 'existing_change_classification') -or
                (Test-TeamTraceFieldHasValue -Content $content -Field 'existing_change_owner')
            )
            if (-not $hasExistingChangeIdentity) {
                $missingDirtyTargetFields += 'existing_change_classification or existing_change_owner'
            }
            if (@($missingDirtyTargetFields).Count -gt 0) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'dirty target trace 缺少既有變更整合證據' -Text ("缺少：{0}" -f (Format-AuditFieldListDisplay -Fields $missingDirtyTargetFields))
            }
        }

        $hasStationTrace = (
            (Test-TeamTraceFieldHasValue -Content $content -Field 'formal_station') -or
            (Test-TeamTraceFieldHasValue -Content $content -Field 'station_family') -or
            (Test-TeamTraceFieldHasValue -Content $content -Field 'role_id')
        )
        if ($hasStationTrace) {
            $hasExternalGroundingField = (
                (Test-TeamTraceFieldHasValue -Content $content -Field 'external_grounding') -or
                (Test-TeamTraceFieldHasValue -Content $content -Field 'external_grounding_state') -or
                (Test-TeamTraceFieldHasValue -Content $content -Field 'external_grounding_evidence')
            )
            if (-not $hasExternalGroundingField) {
                $externalGroundingSeverity = if ($completeClaim) { 'Red' } else { 'Yellow' }
                Add-TeamTraceFinding -Severity $externalGroundingSeverity -File $rel -Line 1 -Reason '逐站 trace 缺少 external grounding 欄位' -Text '每個 station trace 必須標示 external_grounding / external_grounding_state / external_grounding_evidence；不適用時也要明確寫 not-applicable。'
            }
        }

        $sourceDeployedPairValue = Get-TeamTraceFieldRawValue -Content $content -Fields @('source_deployed_pair', 'source deployed pair')
        $syncDirectionValue = Get-TeamTraceFieldValue -Content $content -Fields @('sync_direction', 'sync direction')
        $syncEvidenceValue = Get-TeamTraceFieldRawValue -Content $content -Fields @('sync_evidence', 'sync evidence')
        $normalizedSyncDirection = Resolve-TeamTraceCanonicalValue -Field 'sync_direction' -Value $syncDirectionValue
        $pairDeclaresApplicableSync = -not (Test-TeamTraceFieldValueIsNonApplicable -Value $sourceDeployedPairValue)
        $syncDirectionDeclaresApplicable = -not (Test-TeamTraceFieldValueIsNonApplicable -Value $syncDirectionValue)
        $syncEvidenceClaimsParity = (-not (Test-TeamTraceFieldValueIsNonApplicable -Value $syncEvidenceValue)) -and ($syncEvidenceValue -match '(?i)(hash|sha256|diff|parity|content parity|一致|同步|雜湊)')
        $parityRequired = $completeClaim -or ($normalizedSyncDirection -in @('source-to-deployed', 'deployed-to-source-backfill'))
        $paritySeverity = if ($parityRequired) { 'Red' } else { 'Yellow' }

        if ($pairDeclaresApplicableSync) {
            $pair = Get-TeamTraceSourceDeployedPair -Value $sourceDeployedPairValue -Root $TargetRoot
            if ($null -eq $pair) {
                Add-TeamTraceFinding -Severity $paritySeverity -File $rel -Line 1 -Reason 'source/deployed trace 宣告配對但無法解析實際路徑' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'source_deployed_pair'), $sourceDeployedPairValue)
            } elseif ((-not (Test-Path -LiteralPath $pair.SourcePath -PathType Leaf)) -or (-not (Test-Path -LiteralPath $pair.TargetPath -PathType Leaf))) {
                $missingPairPaths = @()
                if (-not (Test-Path -LiteralPath $pair.SourcePath -PathType Leaf)) { $missingPairPaths += $pair.SourceText }
                if (-not (Test-Path -LiteralPath $pair.TargetPath -PathType Leaf)) { $missingPairPaths += $pair.TargetText }
                Add-TeamTraceFinding -Severity $paritySeverity -File $rel -Line 1 -Reason 'source/deployed parity 無法驗證實際檔案' -Text ("缺少或不是檔案：{0}" -f ($missingPairPaths -join ', '))
            } else {
                $sourceHash = (Get-FileHash -LiteralPath $pair.SourcePath -Algorithm SHA256).Hash
                $targetHash = (Get-FileHash -LiteralPath $pair.TargetPath -Algorithm SHA256).Hash
                if ($sourceHash -ne $targetHash) {
                    Add-TeamTraceFinding -Severity $paritySeverity -File $rel -Line 1 -Reason 'source/deployed parity 實際 SHA256 不一致' -Text ("{0} -> {1}; source={2}; deployed={3}" -f $pair.SourceText, $pair.TargetText, $sourceHash.Substring(0, 12), $targetHash.Substring(0, 12))
                }
            }
        } elseif (($syncDirectionDeclaresApplicable -or $syncEvidenceClaimsParity) -and $completeClaim) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'trace 宣稱同步但缺少可實測 source/deployed 配對' -Text '完整完成或同步證據不能只信 sync_direction / sync_evidence 敘述；必須提供可解析的 source_deployed_pair 以進行 hash parity 檢查。'
        }

        $untrustedEnvelopeAuthPattern = '(?i)(tool_execution_envelope_trust|tool execution envelope trust).{0,80}(untrusted|model-filled|unsigned|missing nonce|unknown issuer).{0,180}(authorized|allowed|protected mutation|write|complete|授權|允許|保護操作|寫入|完成)'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $untrustedEnvelopeAuthPattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '不可信或模型自填信封不得授權保護操作' -Text '保護操作必須有可信簽發者（trusted issuer）、簽章（signature）與 nonce。'
        }

        $invalidPayloadPattern = '(?i)(invalid payload|malformed payload|parse error|__parse_error|無效 payload|無效酬載)'
        $failClosedPattern = '(?i)(fail-closed|fail closed|blocked|not-authorized|unverified|tool_payload_evidence_gap|硬阻擋|阻塞|未授權|未驗證)'
        if ((Test-TeamTracePositiveLine -Content $content -Pattern $invalidPayloadPattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $failClosedPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'invalid payload 未 fail-closed' -Text '無效 payload 必須有 fail-closed 證據（invalid payload fail-closed）。'
        }

        $postBlockBypassPattern = '(?i)(post-block|after block|after a block|被擋後|阻擋後).{0,180}(retry|try again|alternate tool|another tool|switch tool|switch channel|bypass|transcript|換工具|換通道|繞路|重試)'
        $postBlockHardBlockPattern = '(?i)(post-block bypass hard block|blocked|not-authorized|tool_payload_evidence_gap|硬阻擋|阻塞|未授權)'
        if ((Test-TeamTracePositiveLine -Content $content -Pattern $postBlockBypassPattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $postBlockHardBlockPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '被擋後繞路缺少硬阻擋狀態' -Text '被擋後繞路必須有硬阻擋證據（post-block bypass hard block）。'
        }

        $hasStandbyTrace = $content -match '(?i)\bstandby\b|待命'
        if ($isActiveTeamTrace -and $isNoWriteTrace -and $isExplorationTrace -and (-not $hasStandbyTrace)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'active Team trace 無寫入探索缺少隊員 standby 狀態' -Text 'Team mode active 的 formal-readonly 軌跡必須保留隊員待命（standby），或 blocked / unverified 等等價狀態。'
        }

        $standbyCompletionPattern = '(?i)(\bstandby\b|待命).{0,160}(\bcomplete\b|completed|full team completion|formal completion evidence|完整完成|完整團隊完成|已完成|已回收|已整合|正式完成證據|驗收通過)'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $standbyCompletionPattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '待命狀態不得當成完成證據' -Text '待命狀態（standby）是未執行的生命週期狀態，不能當 returned evidence 或 completion。'
        }

        $statusProbePattern = '(?i)(status probe|status_probe|生命探針|狀態探針)'
        $pauseAndReportPattern = '(?is)(status_probe_pause_report|pause.{0,160}(report|tell|state|wait)|report.{0,160}(current position|where|blocked|safe to continue)|暫停.{0,160}(回報|說明|等待)|回報.{0,160}(讀到哪裡|目前位置|是否卡住|安全繼續))'
        $resumeAuthorizationPattern = '(?i)(status_probe_resume_state|status_probe_resume_sent_at|captain resume|explicit resume|明確 resume|隊長.*(resume|恢復|繼續)|收到.*繼續)'
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $statusProbePattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $pauseAndReportPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '狀態探針缺少 pause-and-report 處置' -Text '狀態探針必須暫停目前動作並回報讀到哪裡、是否卡住、是否安全繼續。'
        }
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $statusProbePattern) -and (Test-TeamTracePositiveLine -Content $content -Pattern '(?i)(continued|proceeded|resumed|繼續|恢復)') -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $resumeAuthorizationPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '狀態探針後恢復缺少隊長明確 resume' -Text '狀態探針後只能在隊長明確 resume / 繼續後恢復工作。'
        }

        $timeoutAsTerminalFailurePattern = '(?i)(wait timeout|timeout_action|timeout|逾時).{0,160}(failure|failed|cancel(?:led|ed|lation)?|reject(?:ed)?|失敗|取消|拒絕)'
        $timeoutAsPausePattern = '(?i)(wait timeout|timeout_action|timeout|逾時).{0,180}(pause-and-report|pause and report|standby|awaiting-resume|blocked|unverified|暫停並回報|待命|等待恢復|阻塞|未驗證)'
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $timeoutAsTerminalFailurePattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $timeoutAsPausePattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'wait 逾時被誤判為 failure/cancel/reject' -Text 'wait timeout 只是生命週期待決訊號，必須回報並等待後續決策，不能等同 failure、cancel 或 reject。'
        }

        $replacementCancellationPattern = '(?i)(replacement|replaced|replacing|替換|換員).{0,140}(cancellation|cancelled|canceled|cancel|取消)'
        $replacementNotCancellationPattern = '(?is)(replacement|replaced|replacing|替換|換員).{0,180}(does not|doesn''t|not|without|不是|不會|不得|不代表|非).{0,120}(cancellation|cancel|cancelled|canceled|取消)|cancellation_state\s*[:=]\s*["'']?(not-requested|unavailable|not-applicable)'
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $replacementCancellationPattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $replacementNotCancellationPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'replacement 被誤記為 cancellation' -Text 'replacement 是隊員替換或通道路由調整，不是 cancellation；需要保留原站點狀態與替換理由。'
        }

        $lateResultPattern = '(?i)(late result|late-result|late_result|晚到結果|遲到結果)'
        $lateReceiptDecisionPattern = '(?i)(receipt_decision|receipt_decision_reason|receipt decision|logged|included-in-synthesis-ledger|routed-to-owner-station|superseded-by-replacement|out-of-scope|duplicate|conflict-review|blocked|unverified|回執決策|接收決策)'
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $lateResultPattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $lateReceiptDecisionPattern))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'late result 缺少 receipt decision' -Text '晚到結果必須記錄接收決策（receipt_decision），例如 logged、included-in-synthesis-ledger、routed-to-owner-station、superseded-by-replacement、out-of-scope、duplicate、conflict-review、blocked 或 unverified。'
        }

        $isFormalOrApplicableTrace = $content -match '(?i)\bboard_state\b\s*[:=]\s*["'']?formal\b|\bapplicability\b\s*[:=]\s*["'']?applicable\b|formal evidence eligibility|正式證據'
        if ($isFormalOrApplicableTrace -and ($content -notmatch [regex]::Escape('handoff_packet_id'))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '正式站點缺少 handoff_packet_id' -Text '正式站點必須帶有交接包代號（handoff_packet_id），或明確標記 blocked / unverified 原因。'
        }

        $hasSkillDispatchPackage = $content -match '(?i)skill dispatch package|specialist dispatch package|技能派工包|隊員派工包|Allowed inputs.{0,200}Allowed tools.{0,200}Forbidden actions.{0,200}Output artifact format.{0,200}Stop condition'
        if ($isFormalOrApplicableTrace -and (-not $hasSkillDispatchPackage)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '正式站點缺少技能派工包' -Text '正式站點派工必須包含允許輸入（allowed_inputs）、允許工具（allowed_tools）、禁止動作（forbidden_actions）、輸出交付件格式（output_artifact_format）與停止條件（stop_condition）。'
        }

        $captainOverreachPatterns = @(
            [PSCustomObject]@{
                Pattern = '(?i)(captain|隊長).{0,120}(read|loaded|absorbed|deep read|完整讀|全量讀|吞|深讀).{0,120}(large file|whole file|full file|大檔|大型檔案|全檔|整份)'
                Reason = '隊長完整吞大檔替代隊員深讀'
                Text = '隊長不能用完整讀取大檔替代隊員深讀；應改成有界隊員站點，或誠實標記 blocked / unverified。'
            },
            [PSCustomObject]@{
                Pattern = '(?i)(captain|隊長).{0,220}(broad[- ]?read|repository[- ]?scale search|repository[- ]?wide grep|repo[- ]?wide grep|broad grep|recursive scan|whole[- ]repository file list|whole[- ]repo|rg --files|git ls-files|Get-ChildItem\s+-Recurse|全專案|全倉庫|廣泛讀取|遞迴掃描|全庫搜尋|全域搜尋|全域 grep|倉庫級搜尋)'
                Reason = '隊長執行 repository-scale 讀取或搜尋越界'
                Text = '隊長不得把 broad-read、repository-wide grep、recursive scan 或全倉庫清單當作自己的完成證據；需由正式站點或直接例外殘餘狀態承接。'
            },
            [PSCustomObject]@{
                Pattern = '(?i)(captain|隊長).{0,220}(context-expanding parallel reads?|parallel reads?|duplicate scans?|duplicate search|re-check(?:ing)?|recheck|re-scan|重新檢查|重複掃描|重複搜尋|平行讀取|平行搜尋|再檢查)'
                Reason = '隊長進行平行讀取、重複掃描或再檢查越界'
                Text = '隊長在站點工作期間不得做 context-expanding parallel read、duplicate scan 或 re-check 來替代隊員證據。'
            },
            [PSCustomObject]@{
                Pattern = '(?i)(captain|隊長).{0,220}(substitute[- ]?(validation|review|memory)|substitute validation|substitute review|memory/docs attribution|memory attribution|rewrit(?:e|ing).{0,80}(member|specialist)|替代驗證|替代審查|替代記憶|替代歸因|記憶歸因|改寫.{0,80}(隊員|專家))'
                Reason = '隊長替代驗證、審查或記憶歸因越界'
                Text = '隊長不能把自己的驗證、審查、memory/docs attribution 或改寫隊員結論當作正式站點交付證據。'
            }
        )
        foreach ($captainOverreach in $captainOverreachPatterns) {
            if (Test-TeamTracePositiveLine -Content $content -Pattern $captainOverreach.Pattern) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason $captainOverreach.Reason -Text $captainOverreach.Text
            }
        }

        $ambiguousCaptainImplementationPatterns = @(
            [PSCustomObject]@{ Pattern = '(?i)(captain reimplements|captain.{0,80}reimplement|隊長.{0,80}重新實作|隊長.{0,80}重寫)'; Reason = '任務軌跡出現 Captain reimplements 模糊語義'; Text = '隊長重新實作不是合格變更交付件（change delivery artifact）。' },
            [PSCustomObject]@{ Pattern = '(?i)(\bdirect\b\s+after\s+\bGO\b|after\s+\bGO\b.{0,80}\bdirect\b|\bGO\b.{0,80}\bdirect\b|GO 後.{0,80}(直做|直接)|授權後.{0,80}(直做|直接))'; Reason = '任務軌跡出現 GO 後直做模糊語義'; Text = 'GO 必須綁定正式站點與有範圍的交付路由，不能直接實作（direct implementation）。' },
            [PSCustomObject]@{ Pattern = '(?i)(main-worktree writes?|main worktree writes?|主工作樹寫入|主線寫入).{0,140}(instead of|without|skip|direct|代替|沒有|跳過|直做|直接).{0,120}(change delivery|delivery artifact|變更交付|交付件|station|站點)'; Reason = '任務軌跡以 main-worktree writes 替代變更交付'; Text = '主工作樹整合只能整合已回傳交付件，或明確走非完整風險關閉（closed-with-director-risk）。' },
            [PSCustomObject]@{ Pattern = '(?i)(隊長代工|captain substitute authoring|captain-substitute authoring|captain substituted).{0,160}(implementation|change delivery|變更交付|實作|完成|complete)'; Reason = '任務軌跡把隊長代工混入正式實作'; Text = '隊長代工只能標記 blocked、unverified 或 closed-with-director-risk，不能當完整完成。' }
        )
        foreach ($ambiguousPattern in $ambiguousCaptainImplementationPatterns) {
            if (Test-TeamTracePositiveLine -Content $content -Pattern $ambiguousPattern.Pattern) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason $ambiguousPattern.Reason -Text $ambiguousPattern.Text
            }
        }

        $completeClaimPattern = '(?i)\bcompletion_state\b\s*[:=]\s*["'']?(complete|completed|full-team-complete|full_team_complete)\b|full team completion|完整團隊完成|完整完成'
        $acceptedRiskPattern = '(?i)\baccepted-risk\b|已接受風險'
        $acceptedRiskCompletionPattern = '(?i)\bcomplete-with-accepted-risk\b|已接受風險完成|accepted-risk.{0,100}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)|已接受風險.{0,100}(完整完成|完整團隊完成|完成)'
        $directorRiskClosePattern = '(?i)\bclosed-with-director-risk\b|director risk close|總監風險關閉'
        $completeClaim = Test-TeamTracePositiveLine -Content $content -Pattern $completeClaimPattern
        $hasAcceptedRisk = Test-TeamTracePositiveLine -Content $content -Pattern $acceptedRiskPattern
        $hasAcceptedRiskCompletion = Test-TeamTracePositiveLine -Content $content -Pattern $acceptedRiskCompletionPattern
        $hasDirectorRiskClose = Test-TeamTracePositiveLine -Content $content -Pattern $directorRiskClosePattern

        $completionState = Get-TeamTraceFieldValue -Content $content -Fields @('completion_state', 'completion state', '完成狀態')
        $normalizedCompletionState = Resolve-TeamTraceCanonicalValue -Field 'completion_state' -Value $completionState
        $allowedCompletionStates = @('complete', 'closed-with-director-risk', 'blocked', 'unverified', 'not-applicable')
        if ($normalizedCompletionState -and ($allowedCompletionStates -notcontains $normalizedCompletionState)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'Team-Native trace 使用未登記的 completion_state' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'completion_state'), $completionState)
        }
        if ($completeClaim -and $normalizedCompletionState -and ($normalizedCompletionState -ne 'complete')) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '非完成狀態不得伴隨完整完成宣稱' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'completion_state'), $completionState)
        }
        if ($hasAcceptedRiskCompletion -or ($completeClaim -and $hasAcceptedRisk)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '任務軌跡含已接受風險但宣稱 complete' -Text '已接受風險（accepted-risk）不是完整完成；只能用 closed-with-director-risk 作為非完整關閉狀態。'
        }
        if ($completeClaim -and $hasDirectorRiskClose) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '任務軌跡把總監風險關閉宣稱為完整完成' -Text '總監風險關閉（closed-with-director-risk）是非完整關閉狀態，不是 complete。'
        }
        $pendingLifecyclePattern = '(?i)\b(awaiting-resume|cancellation-pending|late-result-pending)\b|等待恢復|取消待決|晚到結果待決'
        if ($completeClaim -and (Test-TeamTracePositiveLine -Content $content -Pattern $pendingLifecyclePattern)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '待決生命週期狀態被 complete 隱藏' -Text 'awaiting-resume、cancellation-pending 與 late-result-pending 是未決狀態，不能被 completion_state: complete 覆蓋。'
        }
        if ($hasDirectorRiskClose -and (-not (Test-TeamTraceFieldHasValue -Content $content -Field 'risk_close_evidence'))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason 'closed-with-director-risk 缺少當前且範圍綁定的總監風險關閉證據' -Text '風險關閉證據（risk_close_evidence）必須交代本次 Director 決策、殘留風險（residual_risk）與接受範圍。'
        }

        $artifactChecks = @(
            [PSCustomObject]@{ Name = '變更交付件'; Pattern = '(?i)delivery_artifacts?.{0,100}(change|implementation)|\b(change|implementation)[-_ ]delivery( artifact)?\b|變更交付件|實作變更交付' },
            [PSCustomObject]@{ Name = '記憶文件交付件'; Pattern = '(?i)delivery_artifacts?.{0,100}(memory|docs)|\bmemory(/docs)?[-_ ]delivery( artifact)?\b|memory_delivery|記憶文件交付件|記憶交付件|記憶交付' },
            [PSCustomObject]@{ Name = '審查交付件'; Pattern = '(?i)delivery_artifacts?.{0,100}review|\breview[-_ ]delivery( artifact)?\b|審查交付件' },
            [PSCustomObject]@{ Name = '驗證交付件'; Pattern = '(?i)delivery_artifacts?.{0,100}validation|\bvalidation[-_ ]delivery( artifact)?\b|驗證交付件' }
        )
        if ($completeClaim) {
            $completeEvidenceFields = @(
                [PSCustomObject]@{ Field = 'handoff_packet_id'; Label = 'handoff_packet_id'; AllowNonApplicable = $false },
                [PSCustomObject]@{ Field = 'role_instance_id'; Label = 'role_instance_id'; AllowNonApplicable = $false },
                [PSCustomObject]@{ Field = 'delivery_artifact_id'; Label = 'delivery_artifact_id'; AllowNonApplicable = $false },
                [PSCustomObject]@{ Field = 'stations'; Label = 'stations'; AllowNonApplicable = $false },
                [PSCustomObject]@{ Field = 'delivery_artifacts'; Label = 'delivery_artifacts'; AllowNonApplicable = $false },
                [PSCustomObject]@{ Field = 'direct_exceptions'; Label = 'direct_exceptions'; AllowNonApplicable = $true }
            )
            $missingCompleteEvidence = @()
            foreach ($evidenceField in $completeEvidenceFields) {
                if (-not (Test-TeamTraceFieldHasValue -Content $content -Field $evidenceField.Field -AllowNonApplicable:([bool]$evidenceField.AllowNonApplicable))) {
                    $missingCompleteEvidence += $evidenceField.Label
                }
            }
            if (@($missingCompleteEvidence).Count -gt 0) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '任務軌跡宣稱完整完成但缺少可解析必要證據' -Text ("缺少：{0}" -f (Format-AuditFieldListDisplay -Fields $missingCompleteEvidence))
            }

            $missingArtifacts = @()
            foreach ($artifact in $artifactChecks) {
                if (-not (Test-TeamTracePositiveLine -Content $content -Pattern $artifact.Pattern)) {
                    $missingArtifacts += $artifact.Name
                }
            }
            if (@($missingArtifacts).Count -gt 0) {
                Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '任務軌跡宣稱完整完成但缺少必要交付件' -Text ("缺少交付件：{0}" -f ($missingArtifacts -join ', '))
            }
        }

        if ($completeClaim -and (Test-TeamTraceUnsafeCaptainAuthoring -Content $content)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '隊長創作或隊長替代卻宣稱 complete' -Text '已回傳交付件只能由變更站或明確授權 gate 套用；隊長不能自己創作或替代主要交付物後宣稱 completion。'
        }

        $implementer = Get-TeamTraceFieldValue -Content $content -Fields @('implementer', 'implementation_owner', 'implementation_specialist', 'change_delivery_owner', 'change_owner', '實作者')
        $reviewer = Get-TeamTraceFieldValue -Content $content -Fields @('reviewer', 'review_owner', 'review_specialist', 'review_delivery_owner', '審查者')
        if (($implementer) -and ($reviewer) -and ($implementer.Trim().ToLowerInvariant() -eq $reviewer.Trim().ToLowerInvariant())) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '審查者與實作者相同' -Text ("審查者/實作者（reviewer/implementer）: {0}" -f $reviewer)
        }

        $evidenceDirectPattern = '(?i)(validation|review|external-research|scope-impact|security-reliability|memory-docs|release-completion|evidence|驗證|審查|證據|外部研究|範圍|影響|安全|記憶|文件|收尾).{0,180}(\bdirect\b|主線直做)|(\bdirect\b|主線直做).{0,180}(validation|review|external-research|scope-impact|security-reliability|memory-docs|release-completion|evidence|驗證|審查|證據|外部研究|範圍|影響|安全|記憶|文件|收尾)'
        $evidenceDirectCount = Get-TeamTracePositiveLineCount -Content $content -Pattern $evidenceDirectPattern
        $hasConcreteDirectExceptions = Test-TeamTracePositiveLine -Content $content -Pattern '(?i)\bdirect_exceptions\b.{0,240}(exception|replacement evidence|residual state|closed-with-director-risk|blocked|unverified|例外|替代證據|殘留狀態|風險關閉|阻塞|未驗證)'
        if (($evidenceDirectCount -ge 2) -and (-not $hasConcreteDirectExceptions)) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '兩個以上證據站點 direct 但缺少 direct_exceptions' -Text '多個 direct 證據站點必須逐站記錄直行例外（direct_exceptions）、替代證據與殘留狀態。'
        }

        $selfReviewPattern = '(?i)\bself[-_ ]review\b\s*[:=]\s*["'']?(true|yes|same|failed|invalid)\b|\brole_separation\b\s*[:=]\s*["'']?(false|failed|invalid|same)\b|reviewer.{0,80}(same as|same).{0,80}implementer|審查者.{0,80}(同|相同).{0,80}實作者'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $selfReviewPattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '任務軌跡顯示自審或角色分離失敗' -Text '實作與審查必須是分離的交付件（implementation / review delivery artifacts）。'
        }

        $changeDeliveryPattern = '(?i)\b(change|implementation)[-_ ]delivery( artifact)?\b|變更交付件|實作變更交付'
        $reviewDeliveryPattern = '(?i)\breview[-_ ]delivery( artifact)?\b|review station|審查交付件|審查站點'
        $validationDeliveryPattern = '(?i)\bvalidation[-_ ]delivery( artifact)?\b|validation station|驗證交付件|驗證站點'
        $changeIndex = Get-TeamTraceFirstPositiveIndex -Content $content -Pattern $changeDeliveryPattern
        $reviewIndex = Get-TeamTraceFirstPositiveIndex -Content $content -Pattern $reviewDeliveryPattern
        $validationIndex = Get-TeamTraceFirstPositiveIndex -Content $content -Pattern $validationDeliveryPattern
        if (($reviewIndex -ge 0) -and (($changeIndex -lt 0) -or ($reviewIndex -lt $changeIndex))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '審查交付件早於或缺少變更交付件' -Text '審查必須在實作變更交付件存在後開始（review after implementation change delivery artifact）。'
        }
        if (($validationIndex -ge 0) -and (($changeIndex -lt 0) -or ($validationIndex -lt $changeIndex))) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '驗證交付件早於或缺少變更交付件' -Text '驗證必須在實作變更交付件存在後開始（validation after implementation change delivery artifact）。'
        }

        $postBoardAllAtOncePattern = '(?i)(post-board|after board|任務板後|建板後|隊長任務板後).{0,180}(all-at-once|all at once|dispatch all|spawn all|一次(開|啟動|派出|派工).{0,30}(全部|所有)|全部(隊員|分支|子代理).{0,30}一次(開|啟動|派出|派工))'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $postBoardAllAtOncePattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '建板後一次全開' -Text '正式任務板派工必須逐波進行（wave by wave），不能建板後一次全開。'
        }

        $sameWaveReviewPattern = '(?i)(same wave|同一波|同波|wave\s*\d+|第.{0,6}波).{0,180}(implementation|change delivery|實作|變更交付).{0,180}(review|審查).{0,120}(same deliverable|same artifact|同一交付物|同一交付件)'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $sameWaveReviewPattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '同一波同時開實作與同交付物審查' -Text '同一交付件的審查必須等變更交付件回傳後才能開始（review waits for returned change delivery artifact）。'
        }

        $invalidLifecycleRetentionPattern = '(?i)(station_lifecycle_state|隊員狀態).{0,80}(retained|reused|保留|重用).{0,200}(implementation.{0,80}review|review.{0,80}implementation|validation.{0,80}repair|memory.{0,80}(write|mutation)|completion.{0,80}final acceptance|實作.{0,80}審查|審查.{0,80}實作|驗證.{0,80}修復|記憶歸因.{0,80}記憶寫入|收尾.{0,80}最終裁決)'
        if (Test-TeamTracePositiveLine -Content $content -Pattern $invalidLifecycleRetentionPattern) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '隊員生命週期跨越角色互斥邊界' -Text '保留或重用隊員時，必須留在同一角色與同一交付件範圍內（same role / delivery artifact）。'
        }

        $yellowMentionPattern = '(?i)\byellow\b|黃燈'
        $yellowClassificationPattern = '(?i)\byellow_classification\b|fix-this-cycle|residual-accepted|deferred-follow-up|local-customization|informational|黃燈分類'
        if ((Test-TeamTracePositiveLine -Content $content -Pattern $yellowMentionPattern) -and (-not (Test-TeamTracePositiveLine -Content $content -Pattern $yellowClassificationPattern))) {
            Add-TeamTraceFinding -Severity 'Yellow' -File $rel -Line 1 -Reason '任務軌跡提到黃燈但缺少黃燈分類' -Text '收尾前必須分類黃燈（yellow_classification）。'
        }

        $repairLoopValue = Get-TeamTraceFieldValue -Content $content -Fields @('repair_loop_count', 'repair_attempts', '修復迴圈')
        $repairLoopNumber = 0
        if (($repairLoopValue) -and ([int]::TryParse(($repairLoopValue -replace '[^0-9]', ''), [ref]$repairLoopNumber)) -and ($repairLoopNumber -gt 2) -and $completeClaim) {
            Add-TeamTraceFinding -Severity 'Red' -File $rel -Line 1 -Reason '同一症狀修復迴圈超過兩次仍宣稱 complete' -Text '第三次同症狀修復必須轉入根因修復、結構重構、blocked、unverified 或 closed-with-director-risk。'
        }
    }

    if ($RequireTeamTrace -and $validCount -eq 0) {
        Add-TeamTraceFinding -Severity 'Red' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $TeamTraceRoot) -Line 1 -Reason '要求 Team-Native trace，但沒有完整軌跡檔' -Text '沒有找到完整 Team-Native 任務軌跡檔（complete team trace）。'
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 團隊軌跡證據（Team Trace Evidence）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "軌跡根目錄（Trace root）：$TeamTraceRoot"
    Write-Host "軌跡檔案數（Trace files）：$(@($traceFiles).Count)"
    Write-Host "完整軌跡數（Complete traces）：$validCount"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3} — {4}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason, $finding.Text) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
        TraceRoot   = $TeamTraceRoot
        TraceFiles  = @($traceFiles | ForEach-Object { $_.FullName })
        ValidCount  = $validCount
        Required    = [bool]$RequireTeamTrace
    }
}
