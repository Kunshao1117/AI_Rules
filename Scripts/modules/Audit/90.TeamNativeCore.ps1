# Internal partial for Audit.psm1. Loaded by the facade only.
# Team-Native core semantics

function Measure-TeamNativeCoreSemantics {
    <#
    .SYNOPSIS
        檢查 Team-Native Core 是否已成為共用治理、矩陣與團隊技能的核心語義。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-TeamNativeFinding {
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

    function Get-TeamNativeContent {
        param([string]$RelativePath)

        $path = Join-Path $RepoRoot $RelativePath
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
        return (Get-Content -LiteralPath $path -Raw -Encoding UTF8)
    }

    function Test-TeamNativeFrontmatterField {
        param(
            [string]$Frontmatter,
            [string]$Field
        )

        if ([string]::IsNullOrWhiteSpace($Frontmatter)) { return $false }
        $pattern = '(?m)^\s+' + [regex]::Escape($Field) + '\s*:'
        return ($Frontmatter -match $pattern)
    }

    function Test-TeamNativeFrontmatterFieldValue {
        param(
            [string]$Frontmatter,
            [string]$Field,
            [string]$ExpectedValue
        )

        if ([string]::IsNullOrWhiteSpace($Frontmatter)) { return $false }
        $pattern = '(?m)^\s+' + [regex]::Escape($Field) + '\s*:\s*' + [regex]::Escape($ExpectedValue) + '\s*$'
        return ($Frontmatter -match $pattern)
    }

    function Get-TeamNativeFrontmatterFieldValue {
        param(
            [string]$Frontmatter,
            [string]$Field
        )

        if ([string]::IsNullOrWhiteSpace($Frontmatter)) { return '' }
        $pattern = '(?m)^\s+' + [regex]::Escape($Field) + '\s*:\s*(?<value>[^\r\n#]+?)\s*$'
        $match = [regex]::Match($Frontmatter, $pattern)
        if (-not $match.Success) { return '' }
        return $match.Groups['value'].Value.Trim().Trim('"', "'")
    }

    $coreChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\policies\workflow-orchestration.md'
            Severity = 'Red'
            Label = '工作流編排契約缺少 Team-Native 站點編排正本語義'
            Patterns = @('Workflow Orchestration Contract', 'Source-Of-Truth Chain', 'workflow-orchestration-scenarios', 'non-authorizing examples', 'operation_mode', 'daily', 'full', 'draft board', 'formal-readonly', 'formal-write', 'dispatch wave', 'previous-wave input', 'next-wave start condition', 'formal evidence eligibility', 'handoff packet', 'channel capability', 'channel invocation status', 'station lifecycle|Station Handoff', 'pause.{0,80}report|pause-and-report|pause and report|暫停.{0,80}回報', 'status_probe_resume_state|awaiting-resume|等待恢復', 'cancellation_state|cancellation-pending|取消待決', 'late_result_policy|late-result-pending|晚到結果待決', 'receipt decision|receipt_decision|回執決策', 'closed-with-director-risk', 'not full team completion|not as `complete`')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\workflow-orchestration-scenarios.md'
            Severity = 'Red'
            Label = '工作流情境範例缺少 Team-Native 轉場樣本'
            Patterns = @('Workflow Orchestration Scenarios', 'not authorization', 'Scenario Format', 'Read-Only Evidence Station', 'Blueprint To Build', 'Build Or Fix To Validation', 'Failed Validation Route-Back', 'Audit Fan-Out', 'Commit-Preflight Blocker', 'Generated Or Deployed Copy Sync', 'workflow_route', 'operation_mode', 'board_state', 'dispatch wave', 'previous-wave input', 'next-wave start condition', 'handoff_packet_id', 'channel_capability', 'channel_invocation_status', 'pause-and-report|pause and report|暫停並回報', 'resume|恢復|繼續', 'wait timeout|timeout|逾時', 'replacement|替換', 'late result|late-result|晚到結果', 'delivery artifact', 'blocked', 'unverified', 'closed-with-director-risk', 'not full team completion', 'Anti-Examples')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\team-native-core.md'
            Severity = 'Red'
            Label = 'Team-Native Core 政策缺少核心狀態機'
            Patterns = @('Team-Native Core', 'Station-First Rule', 'Strict State Machine', 'Completion Rule', 'Platform Adapter Contract', 'Trace Requirement', 'operation_mode', 'operation_mode_reason', 'daily', 'full', 'role_id', 'role_instance_id', 'exclusive_task_scope', 'direct', 'text change delivery artifact', 'pause.{0,80}report|pause-and-report|pause and report|暫停.{0,80}回報', 'status_probe_resume_state|awaiting-resume|等待恢復', 'cancellation_state|cancellation-pending|取消待決', 'late_result_policy|late-result-pending|晚到結果待決', 'receipt decision|receipt_decision|回執決策', '(replacement|replacing).{0,140}(does not|doesn''t|not|不是|不會|不得).{0,80}(cancel|cancellation|取消)|(替換|換員).{0,140}(不是|不會|不得|不代表).{0,80}取消', '(timeout|逾時).{0,140}(does not|doesn''t|not|不是|不會|不得).{0,80}(failure|fail|失敗)', 'closed-with-director-risk', 'unverified', 'blocked', 'Tool Execution Envelope Rule', 'tool_execution_envelope', 'execution_receipt', 'trusted issuer', 'signature', 'nonce', 'model-filled', 'protected mutation', 'risk close evidence', 'post-block bypass hard block', 'invalid payload fail-closed')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\team-trace-evidence.md'
            Severity = 'Red'
            Label = 'Team trace 證據契約缺少最小欄位'
            Patterns = @('Team Trace Evidence Contract', 'Minimal Trace Fields', 'task_id', 'task_type', 'workflow_route', 'operation_mode', 'operation_mode_reason', 'board_state', 'implementation_authorization', 'authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed', 'role_id', 'role_instance_id', 'exclusive_task_scope', 'specialist_skill', 'loaded_skill_refs', 'handoff_packet_id', 'domain_label', 'requested_execution_channel', 'channel_capability', 'channel_invocation_status', 'startup_started_at', 'first_response_deadline', 'last_progress_at', 'timeout_action', 'status_probe_state', 'status_probe_sent_at', 'status_probe_response_at', 'status_probe_pause_report', 'status_probe_resume_state', 'status_probe_resume_sent_at', 'late_result_policy', 'late_result_window', 'cancellation_state', 'execution_route', 'execution_channel', 'station_state', 'evidence_state', 'station_lifecycle_state', 'receipt_decision', 'receipt_decision_reason', 'final_channel_closure_reason', 'tool_execution_envelope', 'tool_execution_envelope_trust', 'tool_envelope_issuer', 'tool_envelope_signature', 'tool_envelope_nonce', 'execution_receipt', 'execution_receipt_decision', 'delivery_artifact', 'delivery_artifact_id', 'delivery_artifact_status', 'risk_close_evidence', 'no_captain_authoring', 'stations', 'waves', 'delivery_artifacts', 'direct_exceptions', 'role_separation', 'completion_state', 'invalid payload fail-closed', 'post-block bypass hard block')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\authorization-resolution.md'
            Severity = 'Red'
            Label = '授權解析政策缺少必要語義'
            Patterns = @('Authorization Resolution', 'authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed', 'workflow.*not authorization|工作流.*不.*授權|工作流.*不是.*授權', 'platform.*not authorization|平台.*不.*授權|平台.*不是.*授權', 'button.*unscoped|按鈕.*無範圍', 'Tool Execution Envelope And Receipt', 'tool_execution_envelope', 'execution_receipt', 'trusted issuer', 'signature', 'nonce', 'model-filled', 'Invalid payload fail-closed', 'risk close evidence')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\subagent-invocation.md'
            Severity = 'Red'
            Label = '子代理政策未把 Team-Native Core 放入核心'
            Patterns = @('Team-Native Core', 'native.*adapter.*conditional.*unavailable', 'Antigravity / Gemini.*adapter.*conditional', 'routine direct', 'Team-Native 軌跡證據')
        },
        [PSCustomObject]@{
            Path = 'Shared\platform-capability-matrix.md'
            Severity = 'Red'
            Label = '平台能力矩陣缺少 Team-Native Core 能力路由'
            Patterns = @('Team-Native Core Capability', '`conditional`', '平台能力路由', 'Team-Native trace', 'unavailable', 'routine direct')
        },
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Severity = 'Red'
            Label = '工作流證據矩陣缺少 Team-Native trace 驗收'
            Patterns = @('Team-Native Core Evidence', 'Team-Native trace evidence', 'platform capability route', '`conditional`', '`unavailable`', 'no full-team completion claim')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\programming-team-governance\SKILL.md'
            Severity = 'Red'
            Label = '編程團隊治理技能缺少 Team-Native Core 路由'
            Patterns = @('team-native-core', 'workflow-orchestration', 'authorization-resolution', 'team-trace-evidence', 'team-task-board', 'Trigger And Route', 'Board And Station Use', 'Role And Delivery Boundaries', 'Dispatch And Integration Procedure', 'Direct Exceptions', 'Captain Team Board', 'closed-with-director-risk', 'full Team-Native completion')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-task-board\SKILL.md'
            Severity = 'Red'
            Label = '團隊任務板缺少平台能力或授權解析欄位'
            Patterns = @('team-native-core', 'authorization-resolution', 'team-trace-evidence', 'operation_mode', 'operation_mode_reason', 'role_id', 'role_instance_id', 'exclusive_task_scope', 'platform_capability_route', 'authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\delegation-strategy\SKILL.md'
            Severity = 'Red'
            Label = '委派策略缺少平台 adapter 路由狀態'
            Patterns = @('Team-Native Core intent', 'Platform Adapter Mapping', 'conditional', 'unavailable', 'routine direct')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-completion-gate\SKILL.md'
            Severity = 'Red'
            Label = '完成閘門缺少 Team-Native trace 檢查'
            Patterns = @('team-native-core', 'team-trace-evidence', 'team-task-board', 'Completion Checklist', 'Authorization', 'source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode', 'Trace', 'Route/state separation', 'completion_state', 'closeout_lane')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-change-delivery-artifact\SKILL.md'
            Severity = 'Red'
            Label = '變更交付件缺少授權欄位'
            Patterns = @('authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-memory-docs-delivery-artifact\SKILL.md'
            Severity = 'Red'
            Label = '記憶文件交付件缺少授權欄位'
            Patterns = @('authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-validation-delivery-artifact\SKILL.md'
            Severity = 'Red'
            Label = '驗證交付件缺少授權欄位'
            Patterns = @('authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-review-delivery-artifact\SKILL.md'
            Severity = 'Red'
            Label = '審查交付件缺少授權欄位'
            Patterns = @('authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state', 'platform_mode_observed')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-role-boundaries\SKILL.md'
            Severity = 'Red'
            Label = '角色邊界缺少授權欄位檢查'
            Patterns = @('team-native-core', 'workflow-orchestration', 'team-task-board', 'team-station-handoff-packet', 'team-trace-evidence', 'authorization-resolution', 'role_instance_id', 'role_id', 'blocked, unverified, or closed-with-director-risk', 'complete')
        }
    )

    foreach ($check in $coreChecks) {
        $content = Get-TeamNativeContent -RelativePath $check.Path
        if ($null -eq $content) {
            Add-TeamNativeFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason '必要檔案不存在' -Text $check.Label
            continue
        }

        foreach ($pattern in $check.Patterns) {
            if ($content -notmatch $pattern) {
                Add-TeamNativeFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason $check.Label -Text "missing pattern: $pattern"
            }
        }
    }

    $sharedSkillsRoot = Join-Path $RepoRoot 'Shared\skills'
    $skillIndexRelativePath = 'Shared\skills\_index.md'
    $skillIndexContent = Get-TeamNativeContent -RelativePath $skillIndexRelativePath
    $expectedSpecialistRoles = @(
        [PSCustomObject]@{ SkillName = 'team-specialist-intent-requirements'; RoleId = 'intent-requirements' },
        [PSCustomObject]@{ SkillName = 'team-specialist-scope-impact'; RoleId = 'scope-impact' },
        [PSCustomObject]@{ SkillName = 'team-specialist-external-research'; RoleId = 'external-research' },
        [PSCustomObject]@{ SkillName = 'team-specialist-architecture-contract'; RoleId = 'architecture-contract' },
        [PSCustomObject]@{ SkillName = 'team-specialist-change-delivery'; RoleId = 'change-delivery' },
        [PSCustomObject]@{ SkillName = 'team-specialist-validation'; RoleId = 'validation' },
        [PSCustomObject]@{ SkillName = 'team-specialist-review'; RoleId = 'review' },
        [PSCustomObject]@{ SkillName = 'team-specialist-security-reliability'; RoleId = 'security-reliability' },
        [PSCustomObject]@{ SkillName = 'team-specialist-memory-docs'; RoleId = 'memory-docs' },
        [PSCustomObject]@{ SkillName = 'team-specialist-release-completion'; RoleId = 'release-completion' }
    )
    $expectedSkillNames = @($expectedSpecialistRoles | ForEach-Object { $_.SkillName })
    $expectedRoleIds = @($expectedSpecialistRoles | ForEach-Object { $_.RoleId })
    $requiredRoleHandoffFields = @(
        'operation_mode',
        'operation_mode_reason',
        'role_id',
        'role_instance_id',
        'exclusive_task_scope'
    )
    $requiredRelationFields = @(
        'relations',
        'role_id',
        'role_layer',
        'parent_skill',
        'support_skills',
        'embedded_artifacts',
        'artifact_contracts',
        'trace_contracts'
    )
    $requiredTraceContractRefs = @(
        'team-trace-evidence',
        'team-station-handoff-packet'
    )

    $parentSkillName = 'team-specialist-registry'
    $parentSkillPath = Join-Path $sharedSkillsRoot (Join-Path $parentSkillName 'SKILL.md')
    if (-not (Test-Path -LiteralPath $parentSkillPath -PathType Leaf)) {
        Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能不存在' -Text $parentSkillName
    } else {
        $parentContent = Get-Content -LiteralPath $parentSkillPath -Raw -Encoding UTF8
        $parentFrontmatter = Get-FrontmatterBlock -Path $parentSkillPath
        if (-not (Test-TeamNativeFrontmatterFieldValue -Frontmatter $parentFrontmatter -Field 'role_layer' -ExpectedValue 'registry')) {
            Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少 registry 關係層級' -Text 'metadata.relations.role_layer must be registry'
        }
        foreach ($skillName in $expectedSkillNames) {
            if ($parentFrontmatter -notmatch [regex]::Escape($skillName)) {
                Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少十角色子技能支援清單' -Text "missing support skill: $skillName"
            }
        }
        foreach ($role in $expectedSpecialistRoles) {
            if ($parentContent -notmatch [regex]::Escape($role.RoleId)) {
                Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少十角色路由列' -Text "missing role_id: $($role.RoleId)"
            }
        }
        foreach ($field in $requiredRoleHandoffFields) {
            if ($parentContent -notmatch [regex]::Escape($field)) {
                Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少角色身份交接欄位' -Text "missing field: $field"
            }
        }
        foreach ($traceRef in $requiredTraceContractRefs) {
            if ($parentFrontmatter -notmatch [regex]::Escape($traceRef)) {
                Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少 trace/handoff 契約引用' -Text "missing contract ref: $traceRef"
            }
        }
        if ($parentContent -notmatch '(?m)^##\s+Trace And Handoff Contract\s*$') {
            Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能缺少主技能帶子技能交接契約章節' -Text 'missing Trace And Handoff Contract'
        }
        if ($parentContent -match '(?m)^##\s+Team-Native Trace Fields\s*$') {
            Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $parentSkillName) -Line 1 -Reason '專家角色母技能仍保留舊 trace 欄位重複章節' -Text 'remove duplicated Team-Native Trace Fields'
        }
    }

    if ($null -eq $skillIndexContent) {
        Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引不存在' -Text 'missing skill registry'
    } else {
        if ($skillIndexContent -notmatch [regex]::Escape($parentSkillName)) {
            Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引缺少專家角色母技能登記' -Text $parentSkillName
        }
    }

    $specialistSkillDirs = @()
    if (Test-Path -LiteralPath $sharedSkillsRoot -PathType Container) {
        $specialistSkillDirs = @(Get-ChildItem -LiteralPath $sharedSkillsRoot -Directory -ErrorAction SilentlyContinue | Where-Object { ($_.Name -match '^team-specialist-') -and ($_.Name -ne $parentSkillName) } | Sort-Object Name)
    }

    $actualSpecialistNames = @($specialistSkillDirs | ForEach-Object { $_.Name })
    foreach ($role in $expectedSpecialistRoles) {
        if ($actualSpecialistNames -notcontains $role.SkillName) {
            Add-TeamNativeFinding -Severity 'Red' -File 'Shared\skills' -Line 1 -Reason '團隊專家子技能缺少預期十角色之一' -Text ("missing skill: {0}" -f $role.SkillName)
        }
    }
    foreach ($actualName in $actualSpecialistNames) {
        if ($expectedSkillNames -notcontains $actualName) {
            Add-TeamNativeFinding -Severity 'Red' -File 'Shared\skills' -Line 1 -Reason '團隊專家子技能超出十角色契約' -Text ("unexpected skill: {0}" -f $actualName)
        }
    }

    $declaredRoleIds = New-Object System.Collections.Generic.List[string]
    foreach ($role in $expectedSpecialistRoles) {
        $skillName = $role.SkillName
        $skillPath = Join-Path $sharedSkillsRoot (Join-Path $skillName 'SKILL.md')
        $relativeSkillPath = "Shared\skills\$skillName\SKILL.md"
        if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少 SKILL.md' -Text $skillName
            continue
        }

        $skillContent = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8
        $skillFrontmatter = Get-FrontmatterBlock -Path $skillPath
        foreach ($field in $requiredRelationFields) {
            if (-not (Test-TeamNativeFrontmatterField -Frontmatter $skillFrontmatter -Field $field)) {
                Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少關係 metadata 欄位' -Text "missing metadata.relations field: $field"
            }
        }
        $declaredRoleId = Get-TeamNativeFrontmatterFieldValue -Frontmatter $skillFrontmatter -Field 'role_id'
        if ($declaredRoleId) {
            $declaredRoleIds.Add($declaredRoleId)
        }
        if ($declaredRoleId -ne $role.RoleId) {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能 role_id 與十角色表不一致' -Text ("expected {0}, actual {1}" -f $role.RoleId, $declaredRoleId)
        }
        if (-not (Test-TeamNativeFrontmatterFieldValue -Frontmatter $skillFrontmatter -Field 'role_layer' -ExpectedValue 'specialist')) {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少 specialist 關係層級' -Text 'metadata.relations.role_layer must be specialist'
        }
        if (-not (Test-TeamNativeFrontmatterFieldValue -Frontmatter $skillFrontmatter -Field 'parent_skill' -ExpectedValue $parentSkillName)) {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能未連回角色母技能' -Text "metadata.relations.parent_skill must be $parentSkillName"
        }
        foreach ($traceRef in $requiredTraceContractRefs) {
            if ($skillFrontmatter -notmatch [regex]::Escape($traceRef)) {
                Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少 trace/handoff 契約引用' -Text "missing contract ref: $traceRef"
            }
        }
        foreach ($field in $requiredRoleHandoffFields) {
            if ($skillContent -notmatch [regex]::Escape($field)) {
                Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少角色身份交接欄位' -Text "missing field: $field"
            }
        }
        if ($skillContent -notmatch '(?m)^##\s+Trace And Handoff Contract\s*$') {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能缺少主技能帶子技能交接契約章節' -Text 'missing Trace And Handoff Contract'
        }
        if ($skillContent -match '(?m)^##\s+Team-Native Trace Fields\s*$') {
            Add-TeamNativeFinding -Severity 'Red' -File $relativeSkillPath -Line 1 -Reason '團隊專家子技能仍保留舊 trace 欄位重複章節' -Text 'remove duplicated Team-Native Trace Fields'
        }

        if (($null -ne $skillIndexContent) -and ($skillIndexContent -notmatch [regex]::Escape($skillName))) {
            Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引缺少團隊專家子技能登記' -Text $skillName
        }
    }

    foreach ($roleId in $expectedRoleIds) {
        if (@($declaredRoleIds.ToArray()) -notcontains $roleId) {
            Add-TeamNativeFinding -Severity 'Red' -File 'Shared\skills' -Line 1 -Reason '十角色 role_id 集合不完整' -Text ("missing role_id: {0}" -f $roleId)
        }
    }
    foreach ($declaredRoleId in @($declaredRoleIds.ToArray() | Sort-Object -Unique)) {
        if ($expectedRoleIds -notcontains $declaredRoleId) {
            Add-TeamNativeFinding -Severity 'Red' -File 'Shared\skills' -Line 1 -Reason '十角色 role_id 集合出現未登記值' -Text ("unexpected role_id: {0}" -f $declaredRoleId)
        }
    }
    $duplicateRoleIds = @($declaredRoleIds.ToArray() | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name })
    foreach ($duplicateRoleId in $duplicateRoleIds) {
        Add-TeamNativeFinding -Severity 'Red' -File 'Shared\skills' -Line 1 -Reason '十角色 role_id 不得重複' -Text ("duplicate role_id: {0}" -f $duplicateRoleId)
    }

    if ($null -ne $skillIndexContent) {
        $indexedSpecialistNames = @()
        [regex]::Matches($skillIndexContent, 'team-specialist-[a-z0-9][a-z0-9-]*') | ForEach-Object {
            if ($_.Value -ne $parentSkillName) {
                $indexedSpecialistNames += $_.Value
            }
        }
        $indexedSpecialistNames = @($indexedSpecialistNames | Sort-Object -Unique)
        if (@($indexedSpecialistNames).Count -lt 10) {
            Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引登記的團隊專家子技能數量不足' -Text ("indexed {0}, required 10 team-specialist-* skills" -f @($indexedSpecialistNames).Count)
        }
        foreach ($expectedSkillName in $expectedSkillNames) {
            if ($indexedSpecialistNames -notcontains $expectedSkillName) {
                Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引缺少預期十角色子技能' -Text $expectedSkillName
            }
        }
        foreach ($indexedSkillName in $indexedSpecialistNames) {
            if ($expectedSkillNames -notcontains $indexedSkillName) {
                Add-TeamNativeFinding -Severity 'Red' -File $skillIndexRelativePath -Line 1 -Reason '技能索引出現十角色契約外的團隊專家子技能' -Text $indexedSkillName
            }
        }
        foreach ($skillName in $indexedSpecialistNames) {
            $skillPath = Join-Path $sharedSkillsRoot (Join-Path $skillName 'SKILL.md')
            if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
                Add-TeamNativeFinding -Severity 'Red' -File ("Shared\skills\{0}\SKILL.md" -f $skillName) -Line 1 -Reason '技能索引登記的團隊專家子技能不存在' -Text $skillName
            }
        }
    }

    $operationModeContractChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Label = '工作流證據矩陣缺少日常/完整模式路由鏈'
            Patterns = @('operation_mode', 'daily', 'full', 'board_template', 'board_state', 'closeout_lane', 'station set', 'operation_mode_reason', 'role_id', 'role_instance_id', 'exclusive_task_scope')
        },
        [PSCustomObject]@{
            Path = 'Shared\platform-capability-matrix.md'
            Label = '平台能力矩陣缺少日常/完整模式與角色身份欄位'
            Patterns = @('operation_mode', 'daily', 'full', 'operation_mode_reason', 'role_id', 'role_instance_id', 'exclusive_task_scope')
        },
        [PSCustomObject]@{
            Path = 'Shared\skill-governance.md'
            Label = '技能治理契約缺少角色關係 metadata 或日常/完整模式期望'
            Patterns = @('metadata.relations', 'role_id', 'role_layer', 'parent_skill', 'support_skills', 'embedded_artifacts', 'artifact_contracts', 'trace_contracts', 'operation_mode: daily', 'operation_mode: full')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-station-handoff-packet\SKILL.md'
            Label = '隊員交接包缺少操作模式或角色身份欄位'
            Patterns = @('operation mode', 'board state', 'authorization fields', 'phase', 'dispatch wave', 'platform mode', 'completion condition', 'role_id', 'role_instance_id', 'exclusive_task_scope', 'team-specialist-security-reliability')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-role-boundaries\SKILL.md'
            Label = '角色邊界缺少十角色完整定義'
            Patterns = @($expectedRoleIds + @('captain', 'role_instance_id', 'closed-with-director-risk'))
        }
    )

    foreach ($check in $operationModeContractChecks) {
        $content = Get-TeamNativeContent -RelativePath $check.Path
        if ($null -eq $content) {
            Add-TeamNativeFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '必要檔案不存在' -Text $check.Label
            continue
        }
        foreach ($pattern in $check.Patterns) {
            if ($content -notmatch [regex]::Escape($pattern)) {
                Add-TeamNativeFinding -Severity 'Red' -File $check.Path -Line 1 -Reason $check.Label -Text "missing pattern: $pattern"
            }
        }
    }

    $legacySemanticFiles = @(
        'Shared\skills\programming-team-governance\SKILL.md',
        'Shared\skills\team-task-board\SKILL.md',
        'Shared\skills\delegation-strategy\SKILL.md',
        'Shared\skills\team-change-delivery-artifact\SKILL.md',
        'Shared\skills\team-completion-gate\SKILL.md',
        'Shared\policies\subagent-invocation.md',
        'Shared\policies\team-native-core.md',
        'Shared\policies\team-trace-evidence.md',
        'Shared\platform-capability-matrix.md',
        'Shared\workflow-capability-evidence-matrix.md',
        $skillIndexRelativePath
    )
    $legacySemanticPatterns = @(
        [PSCustomObject]@{ Name = 'implementation patch'; Pattern = 'implementation patch|實作補丁|補丁包' },
        [PSCustomObject]@{ Name = 'text patch'; Pattern = 'text patch|文字補丁' },
        [PSCustomObject]@{ Name = 'patch packet'; Pattern = 'patch packet|delivery packet|補丁封包|舊封包' },
        [PSCustomObject]@{ Name = 'captain substitution accepted-risk'; Pattern = 'captain substitution accepted-risk|隊長代工風險接受|隊長代工' }
    )

    foreach ($relPath in $legacySemanticFiles) {
        $content = Get-TeamNativeContent -RelativePath $relPath
        if ($null -eq $content) { continue }
        foreach ($legacy in $legacySemanticPatterns) {
            if ($content -match $legacy.Pattern) {
                Add-TeamNativeFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '舊補丁、packet 或隊長代工語義只能作遺留偵測，不得作正向通過條件' -Text "legacy term: $($legacy.Name)"
                break
            }
        }
    }

    function Get-TeamNativeFirstRegexIndex {
        param(
            [string]$Content,
            [string[]]$Patterns
        )

        if ([string]::IsNullOrWhiteSpace($Content)) { return -1 }
        $first = -1
        foreach ($pattern in $Patterns) {
            $match = [regex]::Match($Content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if (-not $match.Success) { continue }
            if (($first -lt 0) -or ($match.Index -lt $first)) {
                $first = $match.Index
            }
        }

        return $first
    }

    $coreOrderTargets = @(
        [PSCustomObject]@{ Path = Join-Path $RepoRoot 'Codex\.codex\AGENTS.md'; Display = 'Codex\.codex\AGENTS.md'; Severity = 'Red' },
        [PSCustomObject]@{ Path = Join-Path $RepoRoot 'Claude\.claude\rules\core-identity.md'; Display = 'Claude\.claude\rules\core-identity.md'; Severity = 'Red' },
        [PSCustomObject]@{ Path = Join-Path $RepoRoot 'Antigravity\.agents\rules\00_core_identity.md'; Display = 'Antigravity\.agents\rules\00_core_identity.md'; Severity = 'Red' },
        [PSCustomObject]@{ Path = Join-Path $TargetRoot '.codex\AGENTS.md'; Display = '.codex\AGENTS.md'; Severity = 'Red' },
        [PSCustomObject]@{ Path = Join-Path $TargetRoot '.claude\rules\core-identity.md'; Display = '.claude\rules\core-identity.md'; Severity = 'Red' },
        [PSCustomObject]@{ Path = Join-Path $TargetRoot '.agents\rules\00_core_identity.md'; Display = '.agents\rules\00_core_identity.md'; Severity = 'Red' }
    )

    foreach ($target in $coreOrderTargets) {
        if (-not (Test-Path -LiteralPath $target.Path -PathType Leaf)) { continue }
        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $teamIndex = Get-TeamNativeFirstRegexIndex -Content $content -Patterns @('Team-Native Core', '團隊原生核心')
        $authorizationIndex = Get-TeamNativeFirstRegexIndex -Content $content -Patterns @('Authorization Resolution', 'authorization-resolution', '授權解析')
        $lifecycleIndex = Get-TeamNativeFirstRegexIndex -Content $content -Patterns @('Lifecycle Protocol', '##\s+Lifecycle', '生命週期')

        if ($teamIndex -lt 0) {
            Add-TeamNativeFinding -Severity $target.Severity -File $target.Display -Line 1 -Reason '核心規則缺少 Team-Native Core 最高優先章節' -Text 'missing Team-Native Core before lifecycle'
        } elseif (($lifecycleIndex -ge 0) -and ($teamIndex -gt $lifecycleIndex)) {
            Add-TeamNativeFinding -Severity $target.Severity -File $target.Display -Line 1 -Reason 'Team-Native Core 章節順序晚於生命週期' -Text 'Team-Native Core must appear before lifecycle'
        }

        if ($authorizationIndex -lt 0) {
            Add-TeamNativeFinding -Severity $target.Severity -File $target.Display -Line 1 -Reason '核心規則缺少授權解析章節' -Text 'missing authorization resolution before lifecycle'
        } elseif (($lifecycleIndex -ge 0) -and ($authorizationIndex -gt $lifecycleIndex)) {
            Add-TeamNativeFinding -Severity $target.Severity -File $target.Display -Line 1 -Reason '授權解析章節順序晚於生命週期' -Text 'authorization resolution must appear before lifecycle'
        }
    }

    $targetReferencePairs = @(
        [PSCustomObject]@{ Source = 'Shared\platform-capability-matrix.md'; Target = '.agents\shared\platform-capability-matrix.md'; Severity = 'Yellow' },
        [PSCustomObject]@{ Source = 'Shared\workflow-capability-evidence-matrix.md'; Target = '.agents\shared\workflow-capability-evidence-matrix.md'; Severity = 'Yellow' },
        [PSCustomObject]@{ Source = 'Shared\policies\authorization-resolution.md'; Target = '.agents\shared\policies\authorization-resolution.md'; Severity = 'Red' },
        [PSCustomObject]@{ Source = 'Shared\policies\workflow-orchestration.md'; Target = '.agents\shared\policies\workflow-orchestration.md'; Severity = 'Red' },
        [PSCustomObject]@{ Source = 'Shared\policies\workflow-orchestration-scenarios.md'; Target = '.agents\shared\policies\workflow-orchestration-scenarios.md'; Severity = 'Yellow' },
        [PSCustomObject]@{ Source = 'Shared\policies\language-governance.md'; Target = '.agents\shared\policies\language-governance.md'; Severity = 'Red' },
        [PSCustomObject]@{ Source = 'Shared\policies\subagent-invocation.md'; Target = '.agents\shared\policies\subagent-invocation.md'; Severity = 'Red' },
        [PSCustomObject]@{ Source = 'Shared\policies\team-native-core.md'; Target = '.agents\shared\policies\team-native-core.md'; Severity = 'Red' },
        [PSCustomObject]@{ Source = 'Shared\policies\team-trace-evidence.md'; Target = '.agents\shared\policies\team-trace-evidence.md'; Severity = 'Red' }
    )

    $codexWorkflowSourceRoot = Join-Path $RepoRoot 'Codex\.agents\workflow-skills'
    if (Test-Path -LiteralPath $codexWorkflowSourceRoot -PathType Container) {
        foreach ($sourceFile in (Get-ChildItem -LiteralPath $codexWorkflowSourceRoot -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue)) {
            $rel = $sourceFile.FullName.Substring($codexWorkflowSourceRoot.Length).TrimStart('\', '/')
            if ($rel -match '(^|[\\/])_') { continue }
            $targetReferencePairs += [PSCustomObject]@{
                Source = Join-Path 'Codex\.agents\workflow-skills' $rel
                Target = Join-Path '.agents\skills' $rel
            }
        }
    }

    $claudeCommandSourceRoot = Join-Path $RepoRoot 'Claude\.claude\commands'
    if (Test-Path -LiteralPath $claudeCommandSourceRoot -PathType Container) {
        foreach ($sourceFile in (Get-ChildItem -LiteralPath $claudeCommandSourceRoot -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue)) {
            $rel = $sourceFile.FullName.Substring($claudeCommandSourceRoot.Length).TrimStart('\', '/')
            if ($rel -match '(^|[\\/])_') { continue }
            $targetReferencePairs += [PSCustomObject]@{
                Source = Join-Path 'Claude\.claude\commands' $rel
                Target = Join-Path '.claude\commands' $rel
            }
        }
    }

    $antigravityWorkflowSourceRoot = Join-Path $RepoRoot 'Antigravity\.agents\workflows'
    if (Test-Path -LiteralPath $antigravityWorkflowSourceRoot -PathType Container) {
        foreach ($sourceFile in (Get-ChildItem -LiteralPath $antigravityWorkflowSourceRoot -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' })) {
            $targetReferencePairs += [PSCustomObject]@{
                Source = Join-Path 'Antigravity\.agents\workflows' $sourceFile.Name
                Target = Join-Path '.agents\workflows' $sourceFile.Name
            }
        }
    }

    foreach ($pair in $targetReferencePairs) {
        $sourcePath = Join-Path $RepoRoot $pair.Source
        $targetPath = Join-Path $TargetRoot $pair.Target
        $severity = 'Yellow'
        if ($null -ne $pair.PSObject.Properties['Severity']) {
            $severity = $pair.Severity
        }
        if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
            Add-TeamNativeFinding -Severity $severity -File $pair.Target -Line 1 -Reason '部署後 Team-Native 共用參考尚未同步' -Text $pair.Source
            continue
        }
        if (-not (Test-AuditFileHashEqual -SourcePath $sourcePath -TargetPath $targetPath)) {
            Add-TeamNativeFinding -Severity $severity -File $pair.Target -Line 1 -Reason '部署後 Team-Native 共用參考與來源不一致' -Text $pair.Source
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 團隊原生核心語義（Team-Native Core Semantics）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
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
    }
}
