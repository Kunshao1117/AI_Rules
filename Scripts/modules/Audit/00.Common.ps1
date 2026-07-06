# Internal partial for Audit.psm1. Loaded by the facade only.
# Common display, frontmatter, path, target, hash helpers

function Format-AuditFieldDisplay {
    param([string]$Field)

    $fieldText = ([string]$Field).Trim()
    if (-not $fieldText) { return '' }
    if ($fieldText -match '[（(].+[）)]') { return $fieldText }

    if ($fieldText -match '\s+or\s+') {
        $parts = $fieldText -split '\s+or\s+'
        return ((@($parts) | ForEach-Object { Format-AuditFieldDisplay -Field $_ }) -join ' 或 ')
    }

    $fieldLabels = @{
        'task_id' = '任務代號'
        'task_type' = '任務類型'
        'workflow_route' = '工作流路由'
        'phase' = '階段'
        'dispatch_wave' = '派工波次'
        'previous_wave_input' = '前一波輸入'
        'next_wave_start_condition' = '下一波啟動條件'
        'formal_evidence_eligibility' = '正式證據資格'
        'go_evidence' = 'GO 授權證據'
        'operation_mode' = '操作模式'
        'operation_mode_reason' = '操作模式理由'
        'station_state' = '站點狀態'
        'evidence_state' = '證據狀態'
        'source_input' = '來源輸入'
        'integrable_scope' = '可整合範圍'
        'review_state' = '審查狀態'
        'validation_state' = '驗證狀態'
        'memory_docs_state' = '記憶文件狀態'
        'captain_authored' = '隊長代工狀態'
        'evidence_owner' = '證據負責人'
        'role_boundary' = '角色邊界'
        'direct_exception' = '直行例外'
        'completion_condition' = '完成條件'
        'delivery_artifact_type' = '交付件類型'
        'assigned_specialist_skill' = '指派專家技能'
        'specialist_role_source' = '專家角色來源'
        'allowed_inputs' = '允許輸入'
        'allowed_tools' = '允許工具'
        'forbidden_actions' = '禁止動作'
        'output_artifact_format' = '輸出交付件格式'
        'stop_condition' = '停止條件'
        'channel_capability' = '通道能力'
        'channel_invocation_status' = '通道啟動狀態'
        'startup_started_at' = '啟動開始時間'
        'first_response_deadline' = '首次回應期限'
        'last_progress_at' = '最後進度時間'
        'timeout_action' = '逾時處置'
        'status_probe_state' = '狀態探針狀態'
        'status_probe_sent_at' = '狀態探針送出時間'
        'status_probe_response_at' = '狀態探針回應時間'
        'status_probe_pause_report' = '狀態探針暫停回報'
        'status_probe_resume_state' = '狀態探針恢復狀態'
        'status_probe_resume_sent_at' = '狀態探針恢復送出時間'
        'late_result_policy' = '晚到結果政策'
        'late_result_window' = '晚到結果接收窗口'
        'receipt_decision' = '回執決策'
        'receipt_decision_reason' = '回執決策理由'
        'cancellation_state' = '取消狀態'
        'final_channel_closure_reason' = '最終通道關閉理由'
        'replacement_reason' = '替換理由'
        'standby_reason' = '待命原因'
        'tool_execution_envelope' = '工具執行信封'
        'tool_execution_envelope_trust' = '工具執行信封信任狀態'
        'tool_envelope_issuer' = '工具信封簽發者'
        'tool_envelope_signature' = '工具信封簽章'
        'tool_envelope_nonce' = '工具信封 nonce'
        'execution_receipt' = '執行回執'
        'execution_receipt_decision' = '執行回執決策'
        'source_deployed_pair' = '來源與部署副本配對'
        'sync_direction' = '同步方向'
        'sync_evidence' = '同步證據'
        'current_diff_evidence' = '目前差異證據'
        'target_section_evidence' = '目標段落證據'
        'integration_strategy' = '整合策略'
        'existing_change_classification' = '既有變更分類'
        'existing_change_owner' = '既有變更負責人'
        'scenarioCode' = '測試場景代碼'
        'expectedDecision' = '預期決策'
        'expectedReasonCodeRegex' = '預期原因碼規則'
        'expectedDiagnosticLabels' = '預期診斷標籤'
        'authorization_source' = '授權來源'
        'authorization_target' = '授權目標'
        'authorization_scope' = '授權範圍'
        'authorization_phase' = '授權階段'
        'authorization_evidence' = '授權證據'
        'authorization_expiry' = '授權期限'
        'authorization_resolution_state' = '授權解析狀態'
        'platform_mode_observed' = '平台模式觀察'
        'specialist_skill' = '專家技能'
        'loaded_skill_refs' = '已載入技能參照'
        'domain_label' = '領域標籤'
        'requested_execution_channel' = '請求執行通道'
        'execution_channel' = '執行通道'
        'execution_route' = '執行路由'
        'platform_route' = '平台路由'
        'execution mode' = '執行模式'
        'execution_mode' = '執行模式'
        'implementation_authorization' = '實作授權'
        'implementer' = '實作者'
        'reviewer' = '審查者'
        'board_state' = '任務板狀態'
        'role_id' = '角色代號'
        'role_instance_id' = '角色實例代號'
        'exclusive_task_scope' = '互斥任務範圍'
        'handoff_packet_id' = '交接包代號'
        'station_lifecycle_state' = '站點生命週期狀態'
        'station_mode' = '站點模式'
        'context_visibility' = '上下文可見度'
        'handoff_ownership' = '交接所有權'
        'return_timing' = '回傳時機'
        'retention_reason' = '保留理由'
        'conversation_health' = '對話健康狀態'
        'reuse_count' = '重用次數'
        'handoff_summary' = '交接摘要'
        'closure_reason' = '關閉理由'
        'closeout_lane' = '收尾路徑'
        'yellow_classification' = '黃燈分類'
        'yellow_resolution_state' = '黃燈處理狀態'
        'repair_loop_count' = '修復迴圈次數'
        'delivery_artifact' = '交付件'
        'delivery_artifact_id' = '交付件代號'
        'delivery_artifact_status' = '交付件狀態'
        'no_captain_authoring' = '無隊長代工證據'
        'stations' = '站點清單'
        'waves' = '波次清單'
        'delivery_artifacts' = '交付件清單'
        'direct_exceptions' = '直行例外'
        'role_separation' = '角色分離'
        'completion_state' = '完成狀態'
        'risk_close_evidence' = '風險關閉證據'
        'residual_risk' = '殘留風險'
        'dirty_target' = '目標既有變更'
        'existing_worktree_changes' = '現有工作樹變更'
        'existing_diff' = '既有 diff'
        'modified_target' = '已修改目標'
        'target_dirty' = '目標 dirty 狀態'
        'worktree_dirty' = '工作樹 dirty 狀態'
        'metadata.author' = '中繼資料作者'
        'metadata.version' = '中繼資料版本'
        'metadata.origin' = '中繼資料來源'
        'metadata.kind' = '中繼資料類型'
        'metadata.style' = '中繼資料風格'
        'metadata.memory_awareness' = '中繼資料記憶意識'
        'metadata.tool_scope' = '中繼資料工具範圍'
        'metadata.relations' = '中繼資料關係'
        'memory_impact' = '記憶影響'
        'review_need' = '審查需求'
        'blocker_status' = '阻塞狀態'
    }

    if ($fieldLabels.ContainsKey($fieldText)) {
        return ("{0}（{1}）" -f $fieldLabels[$fieldText], $fieldText)
    }

    return ("必要欄位（{0}）" -f $fieldText)
}

function Format-AuditFieldListDisplay {
    param([object[]]$Fields)

    return ((@($Fields) | ForEach-Object { Format-AuditFieldDisplay -Field ([string]$_) } | Where-Object { $_ }) -join ', ')
}

function Test-AuditCjkFirstReadableText {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $firstReadable = [regex]::Match($Text, '[A-Za-z0-9\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]')
    return $firstReadable.Success -and ($firstReadable.Value -match '[\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]')
}

function Get-AuditDescriptionScopeSegment {
    param(
        [string]$Description,
        [ValidateSet('UseWhen', 'DoNotUseWhen')]
        [string]$Scope
    )

    if ([string]::IsNullOrWhiteSpace($Description)) { return '' }

    $pattern = if ($Scope -eq 'UseWhen') {
        '(?is)(?:^|[.;。；]\s*)Use\s+when\s*:?\s*(?<value>.*?)(?=\bDO\s+NOT\s+use\s+when\s*:|$)'
    } else {
        '(?is)\bDO\s+NOT\s+use\s+when\s*:?\s*(?<value>.*)$'
    }
    $match = [regex]::Match($Description, $pattern)
    if (-not $match.Success) { return '' }
    return $match.Groups['value'].Value.Trim()
}

function Get-AuditScopeLabelRemainder {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return '' }
    $match = [regex]::Match($Line, '(?i)\b(DO\s+NOT\s+use\s+when|Use\s+when|When\s+to\s+load\s+this\s+skill)\b\s*:?\s*(?<value>.*)$')
    if (-not $match.Success) { return '' }
    return $match.Groups['value'].Value.Trim()
}

function Test-AuditScopeLabelCjkBridge {
    param(
        [string[]]$Lines,
        [int]$Index
    )

    if ($Index -lt 0 -or $Index -ge $Lines.Count) { return $false }

    $line = [string]$Lines[$Index]
    if (Test-AuditCjkFirstReadableText -Text $line) { return $true }

    $remainder = Get-AuditScopeLabelRemainder -Line $line
    if (-not [string]::IsNullOrWhiteSpace($remainder)) {
        return (Test-AuditCjkFirstReadableText -Text $remainder)
    }

    if ($Index -gt 0) {
        $previous = [string]$Lines[$Index - 1]
        if ($previous -match '[\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]' -and $previous -match '適用|使用|觸發|排除|不適用|負向|正向|場景|時機|邊界') {
            return $true
        }
    }

    $nearby = New-Object System.Collections.Generic.List[string]
    for ($i = $Index + 1; $i -lt [Math]::Min($Lines.Count, $Index + 3); $i++) {
        $next = ([string]$Lines[$i]).Trim()
        if ($next) { $nearby.Add($next) }
    }
    if ($nearby.Count -eq 0) { return $false }
    return (Test-AuditCjkFirstReadableText -Text (($nearby.ToArray()) -join ' '))
}

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

    $root = (Resolve-Path -LiteralPath $RepoRoot -ErrorAction Stop).Path
    try {
        $full = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
    } catch {
        $full = [System.IO.Path]::GetFullPath($Path)
    }
    if (-not $full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) { return $full }
    return $full.Substring($root.Length).TrimStart('\', '/')
}

function Get-AuditSharedGovernanceReferenceRelativePaths {
    param([string]$SharedRoot)

    $references = New-Object System.Collections.Generic.List[string]
    foreach ($rel in @(
        'platform-capability-matrix.md',
        'workflow-capability-evidence-matrix.md',
        'skill-governance.md',
        'policies\authorization-resolution.md',
        'policies\workflow-orchestration.md',
        'policies\workflow-orchestration-scenarios.md',
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
        'Shared\policies\workflow-orchestration.md',
        'Shared\policies\workflow-orchestration-scenarios.md',
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

    return $Line -match '(?i)\b(NO|NOT|DO NOT|DON''T|NEVER|FORBID|FORBIDDEN|PROHIBIT|MUST NOT|CANNOT|WITHOUT|INCOMPLETE|NON-COMPLETE|NONCOMPLETE|INVALID|FAIL|NOT A|NOT AN|NOT ALL)\b|不是|禁止|不得|不可|不能|不應|不允許|不代表|不會|不安裝|不修改|非自動|非完整|只輸出|僅輸出|建議|草稿|proposed|recommend'
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
