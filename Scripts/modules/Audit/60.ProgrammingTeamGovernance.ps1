# Internal partial for Audit.psm1. Loaded by the facade only.
# Programming team governance coverage

function Test-ProgrammingTeamActiveTeamContext {
    param([string]$Content)
    if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

    $activeTeamPattern = '(?im)^\s*[-*]?\s*["'']?(team_mode|Team mode|captain-led mode)["'']?\s*[:=]\s*["'']?(active|enabled)\b|(?im)^\s*[-*]?\s*["'']?operation_mode["'']?\s*[:=]\s*["'']?(daily|full)\b|(?im)^\s*[-*]?\s*["'']?(board_state|station_mode|handoff_ownership|channel_invocation_status)["'']?\s*[:=]|(?i)(after|when|in) (Team mode|captain-led mode).{0,80}active|(?i)active Team mode|Team mode 啟動後|Team mode 已啟動|受治理請求|governed (Director|user) request|隊長任務板|Captain Team Board'
    return ($Content -match $activeTeamPattern)
}

function Test-ProgrammingTeamInactiveTeamContext {
    param([string]$Content)
    if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

    $inactiveTeamPattern = '(?i)(Team mode|captain-led mode|Team-Native).{0,120}(not active|inactive|not activated|未啟動)|未啟動.{0,80}(Team mode|Team-Native|captain-led|隊長制)|no current governed Director request|without a current governed|pure conversation|small stable answer|no-impact|純對話|小型穩定|無 source/governance/evidence|不套用 captain/team-board|ordinary lifecycle|normal lifecycle|一般生命週期|普通工作流'
    return ($Content -match $inactiveTeamPattern)
}

function Measure-ProgrammingTeamGovernanceCoverage {
    <#
    .SYNOPSIS
        檢查隊長制編程團隊治理是否覆蓋共用技能、政策、矩陣、三平台入口與部署副本。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-ProgrammingTeamFinding {
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

    function Get-ProgrammingTeamContent {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8)
    }

    function Test-ProgrammingTeamThinWorkflowEntryContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasEntryShell = (
            $Content -match 'Workflow Entry Contract' -and
            $Content -match 'Required References' -and
            $Content -match 'Workflow Entry Slimming Guard|入口瘦身防線' -and
            $Content -match 'Phase Order'
        )
        $hasSharedGovernanceRoutes = (
            $Content -match 'workflow-orchestration' -and
            $Content -match 'language-governance' -and
            $Content -match 'workflow-capability-evidence-matrix' -and
            $Content -match 'platform-capability-matrix' -and
            $Content -match 'workflow-stage-procedures'
        )
        $hasExplicitTeamRoutes = (
            $Content -match 'programming-team-governance' -and
            $Content -match 'team-task-board' -and
            $Content -match 'team-station-handoff-packet' -and
            $Content -match 'team-role-boundaries' -and
            $Content -match 'team-completion-gate'
        )
        $hasThinTeamRoute = (
            $Content -match 'programming-team-governance' -and
            $Content -match 'Team-Native work' -and
            $Content -match 'load board, handoff, role-boundary, delivery, validation, review, memory/docs, and completion skills only for stations opened by the current board'
        )
        $hasTeamRoutes = $hasExplicitTeamRoutes -or $hasThinTeamRoute

        return ($hasEntryShell -and $hasSharedGovernanceRoutes -and $hasTeamRoutes)
    }

    function Test-ProgrammingTeamThinChatEntryContent {
        param([string]$Content)
        if (-not (Test-ProgrammingTeamThinWorkflowEntryContent -Content $Content)) { return $false }

        $hasEvidenceRoute = $Content -match 'evidence-bearing|證據型|evidence checks|source/tool output|governance evidence'
        $hasFormalReadonly = $Content -match 'formal-readonly|formal readonly'
        $hasProcedure = $Content -match '00 Chat'

        return ($hasEvidenceRoute -and $hasFormalReadonly -and $hasProcedure)
    }

    function Add-ProgrammingTeamRegexFindings {
        param(
            [string]$RelativePath,
            [string]$Pattern,
            [string]$Reason,
            [string]$Severity = 'Red'
        )

        $fullPath = Join-Path $RepoRoot $RelativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { return }
        $lineNumber = 0
        Get-Content -LiteralPath $fullPath -Encoding UTF8 | ForEach-Object {
            $lineNumber++
            if ($_ -match $Pattern) {
                if (Test-AuditLineIsNegative -Line $_) { return }
                Add-ProgrammingTeamFinding -Severity $Severity -File $RelativePath -Line $lineNumber -Reason $Reason -Text $_
            }
        }
    }

    function Add-ProgrammingTeamBadNoWriteNoTeamFindings {
        param(
            [string]$RelativePath,
            [string]$Reason
        )

        $fullPath = Join-Path $RepoRoot $RelativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { return }

        $pattern = '(?i)(no-write|read-only|無寫入|唯讀).{0,160}(no-team|no team|without team|skip team|不用(團隊|隊員)|不需要(團隊|隊員)|無團隊)'
        $allowedNegative = '(?i)(does not mean|must not mean|not equal|must not|do not|不是|不代表|不得|不可|不能|不應|禁止)'
        $lineNumber = 0
        Get-Content -LiteralPath $fullPath -Encoding UTF8 | ForEach-Object {
            $lineNumber++
            $activeTeamLine = Test-ProgrammingTeamActiveTeamContext -Content $_
            $inactiveTeamLine = Test-ProgrammingTeamInactiveTeamContext -Content $_
            if (($_ -match $pattern) -and ($_ -notmatch $allowedNegative) -and $activeTeamLine -and (-not $inactiveTeamLine)) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $RelativePath -Line $lineNumber -Reason $Reason -Text $_
            }
        }
    }

    function Add-ProgrammingTeamAmbiguousPositiveFindings {
        param(
            [string[]]$RelativePaths
        )

        $ambiguousPattern = '(?i)(需要時|必要時|視情況|若可行|如可行|可視情況|可自行|可選|可以不|可不|應考慮|應視|may optionally|as needed|if needed|when needed|where possible|if possible|\boptional(?:ly)?\b|\bcan\b|\bshould\b|\bmay\b)'
        $riskPattern = '(?i)(跳過|略過|主線直做|直做|不開|不啟動|完成|通過|啟動|派工|降級|驗收|skip|bypass|\bdirect\b|\bcomplete(?:d)?\b|completion claim|complete claim|full[- ]team completion|full completion|dispatch|spawn|delegate|degrade|launch)'
        $protectivePattern = '(?i)(不得|不可|不能|不代表|不是|不應|禁止|必須|仍需|仍須|需先|需記錄|must|must not|do not|not|blocked|unverified|non-complete|requires|required|allowed only when|only when|only after|only for|formal-readonly|formal-write|GO-backed|can shape|can influence|can safely|may appear|optionally prompting)'

        foreach ($relativePath in $RelativePaths) {
            $fullPath = Join-Path $RepoRoot $relativePath
            if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { continue }

            $lineNumber = 0
            Get-Content -LiteralPath $fullPath -Encoding UTF8 | ForEach-Object {
                $lineNumber++
                if (($_ -match $ambiguousPattern) -and ($_ -match $riskPattern) -and ($_ -notmatch $protectivePattern)) {
                    Add-ProgrammingTeamFinding -Severity 'Red' -File $relativePath -Line $lineNumber -Reason '模糊允許詞靠近高風險團隊動作' -Text $_
                }
            }
        }
    }

    function Test-ProgrammingTeamChatReadonlyContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasEvidenceChat = $Content -match '證據型對話|evidence-bearing chat|evidence verification|evidence checks|evidence chains|證據查核'
        $hasFormalReadonly = $Content -match 'formal-readonly|formal readonly|正式.{0,80}(唯讀|無寫入)'
        $hasEvidenceScope = $Content -match 'project files|screenshots|memory/context cards|rules/workflows/policies|agent/subagent behavior|source/tool output|檔案|截圖|記憶|脈絡|規則|工作流|政策|代理|子代理'
        $hasEvidenceStatus = $Content -match 'Evidence status|證據狀態|missing scope|unresolved scope|未讀範圍|阻塞'
        $hasCaptainCoordinationBoundary = $Content -match 'captain.{0,160}(receive|receives|receipt|board|status|blocker|conflict|authorization).{0,160}(validation|review|memory)|隊長.{0,160}(接收|任務板|彙整|阻塞|衝突|授權).{0,160}(驗證|審查|記憶)'
        $hasNonCompleteBoundary = $Content -match '不得宣稱完整完成|not complete|not full team completion|closed-with-director-risk|完整完成'

        return ($hasEvidenceChat -and $hasFormalReadonly -and $hasEvidenceScope -and $hasEvidenceStatus -and $hasCaptainCoordinationBoundary -and $hasNonCompleteBoundary)
    }

    function Test-ProgrammingTeamChannelMonitoringContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $requiredFields = @(
            'channel_capability',
            'channel_invocation_status',
            'startup_started_at',
            'first_response_deadline',
            'last_progress_at',
            'timeout_action',
            'standby_reason'
        )

        foreach ($field in $requiredFields) {
            if ($Content -notmatch [regex]::Escape($field)) { return $false }
        }
        return $true
    }

    function Test-ProgrammingTeamArtifactSetContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasChangeDeliveryArtifact = $Content -match 'implementation change delivery|change delivery artifact|change delivery|變更交付件|實作變更交付'
        $hasMemoryDeliveryArtifact = $Content -match 'memory/docs delivery artifact|memory delivery artifact|memory delivery|memory_delivery|記憶文件交付件|記憶交付件|記憶交付'
        $hasReviewArtifact = $Content -match 'review delivery artifact|審查交付件'
        $hasValidationArtifact = $Content -match 'validation delivery artifact|驗證交付件'
        $hasMissingArtifactState = $Content -match 'blocked|unverified|阻塞|未驗證'

        return ($hasChangeDeliveryArtifact -and $hasMemoryDeliveryArtifact -and $hasReviewArtifact -and $hasValidationArtifact -and $hasMissingArtifactState)
    }

    function Test-ProgrammingTeamMemoryDeliveryContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasMemoryImpact = $Content -match 'memory impact|memory_impact|memory-impact|memory attribution|memory evidence|記憶影響|記憶歸因|記憶證據'
        $hasMemoryDeliveryArtifact = $Content -match 'memory delivery|memory_delivery|memory/docs delivery artifact|memory delivery artifact|記憶文件交付件|記憶交付件|記憶交付'
        $hasMissingArtifactState = $Content -match 'blocked|unverified|阻塞|未驗證'

        return ($hasMemoryImpact -and $hasMemoryDeliveryArtifact -and $hasMissingArtifactState)
    }

    function Test-ProgrammingTeamFullCompletionClaimContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $claimPattern = '(?i)full team completion|完整團隊完成|\bcompletion_state\b\s*[:=]\s*["'']?(complete|completed|full-team-complete|full_team_complete)\b'
        $protectivePattern = '(?i)\bnot\b|\bnever\b|\bcannot\b|\bmust not\b|\bdo not\b|requires?|required|only when|non-complete|not complete|not full|missing|blocked|unverified|closed-with-director-risk|不得|不可|不能|不代表|不是|非完整|缺少|阻塞|未驗證|風險關閉'

        foreach ($line in ($Content -split "\r?\n")) {
            if (($line -match $claimPattern) -and ($line -notmatch $protectivePattern)) {
                return $true
            }
        }

        return $false
    }

    function Test-ProgrammingTeamDirectorRiskCloseContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasDirectorRiskClose = $Content -match 'closed-with-director-risk|director risk close|director-risk close|總監風險關閉|總監接受風險關閉'
        $hasNonCompleteBoundary = $Content -match '(?is)not.{0,80}(full team completion|completion status|complete)|cannot claim.{0,80}`?complete`?|not full completion|full Team-Native completion|non-complete|not complete|非完整|不可稱完整|不得稱完整|不是完整'

        return ($hasDirectorRiskClose -and $hasNonCompleteBoundary)
    }

    function Test-ProgrammingTeamFirstReadonlyContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasGovernedActivation = $Content -match '(?is)(governed (Director|user) request|governed work|受治理請求|受治理工作|使用者要求.{0,180}(source|governance|workflow|fix|build|debug|test|audit|skill|memory/docs|commit|handoff|public-contract|受治理)|Director requests governed work such as.{0,180}(source|workflow|fix|build|audit|memory/docs)|Team mode.{0,220}(governance|workflow|fix|build|debug|test|audit|skill|memory/docs|commit|handoff|source|public-contract|受治理)|不需要.{0,60}(固定口令|啟動團隊模式)|does not need.{0,100}(fixed phrase|fixed Team))'
        $hasInactiveFallback = $Content -match '(?is)(When captain-led mode is not active|When Team mode is\s+not active|Team mode 未啟動|do not create a Captain Team Board|不套用 captain/team-board|pure conversation|small stable answer|no-impact|純對話|小型穩定|無 source/governance/evidence|ordinary lifecycle|normal lifecycle|ordinary non-team work|一般生命週期|普通工作流)'
        $hasActiveFormalReadonly = $Content -match '(?is)(active Team mode|after captain-led mode is active|After Team mode is active|Team mode 已啟動|Team mode 啟動後|In active captain-led mode).{0,260}(formal-readonly|formal readonly|正式.{0,100}(唯讀|無寫入))|formal-readonly.{0,220}(Team mode (is )?active|Team mode active|Team mode 已啟動|active Team mode|no-write evidence)'

        return ($hasGovernedActivation -and $hasInactiveFallback -and $hasActiveFormalReadonly)
    }

    function Test-ProgrammingTeamStandbyContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasStandby = $Content -match '\bstandby\b|待命'
        $hasNonLaunchState = $Content -match 'not-started|not-authorized|unavailable|blocked|unverified|未啟動|未授權|不可用|阻塞|未驗證'

        return ($hasStandby -and $hasNonLaunchState)
    }

    function Test-ProgrammingTeamWorkflowModeContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasOperationMode = $Content -match 'operation_mode|Operation mode|操作模式'
        $hasDaily = $Content -match '\bdaily\b|日常模式'
        $hasFull = $Content -match '\bfull\b|完整模式'
        $hasFormalReadonly = $Content -match 'formal-readonly|formal readonly|正式.{0,80}(唯讀|無寫入)'
        $hasFormalWrite = $Content -match 'formal-write|formal write|正式.{0,80}(寫入|可寫)'
        $hasDirectBoundary = $Content -match '\bdirect_exception\b|\bdirect exception\b|closed-with-director-risk|owner[- ]station|station-owned|\bdirect\b|直答|直行|主線直做'

        return ($hasOperationMode -and $hasDaily -and $hasFull -and $hasFormalReadonly -and $hasFormalWrite -and $hasDirectBoundary)
    }

    function Test-ProgrammingTeamWorkflowRoleLifecycleContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasRegistry = $Content -match 'team-specialist-registry'
        $hasTaskBoard = $Content -match 'team-task-board'
        $hasHandoffPacket = $Content -match 'team-station-handoff-packet'
        $hasRoleIdentity = $Content -match 'role_id' -and $Content -match 'role_instance_id' -and $Content -match 'exclusive_task_scope'
        $hasLifecycle = $Content -match 'station lifecycle|specialist lifecycle|隊員生命週期|站點生命週期'
        $hasLifecycleStates = $Content -match 'assigned' -and $Content -match 'standby' -and $Content -match 'retained' -and $Content -match 'reused' -and $Content -match 'handoff-required' -and $Content -match 'replaced' -and $Content -match 'closed' -and $Content -match 'blocked'
        $hasStartupMonitoring = $Content -match 'startup_started_at' -and $Content -match 'first_response_deadline' -and $Content -match 'last_progress_at' -and $Content -match 'timeout_action' -and $Content -match 'standby_reason'
        $hasNonCompleteRisk = $Content -match 'closed-with-director-risk' -and $Content -match 'not complete|not full team completion|非完整|不是完整'

        return ($hasRegistry -and $hasTaskBoard -and $hasHandoffPacket -and $hasRoleIdentity -and $hasLifecycle -and $hasLifecycleStates -and $hasStartupMonitoring -and $hasNonCompleteRisk)
    }

    function Test-ProgrammingTeamDispatchPackageContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasDispatchPackage = $Content -match 'skill dispatch package|specialist dispatch package|Specialist Assignment Template|技能派工包|隊員派工包'
        $hasPackageFields = $Content -match 'Allowed inputs|Allowed tools|Forbidden actions|Output artifact format|Stop condition|允許輸入|允許工具|禁止動作|輸出交付格式|停止條件'

        return ($hasDispatchPackage -and $hasPackageFields)
    }

    function Test-ProgrammingTeamLargeReadBoundaryContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasLargeReadBoundary = $Content -match 'large[- ]file deep read|whole[- ]file deep read|large file.{0,120}specialist|deep read.{0,120}specialist|deep_read_scope|大檔.{0,120}深讀|大型檔案.{0,120}深讀|全檔.{0,120}深讀'
        $hasCaptainLimit = $Content -match 'captain.{0,160}(only|owns|responsible|must not|cannot|does not).{0,160}(receive|receipt|board|status|blocker|authorization|absorb|substitute|deep read)|隊長.{0,160}(只|不得|不能|不可).{0,160}(接收|任務板|彙整|阻塞|授權|吞|替代|包辦|深讀)'

        return ($hasLargeReadBoundary -and $hasCaptainLimit)
    }

    function Test-ProgrammingTeamImplementationDirectBounded {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasImplementationDirect = $Content -match '(?is)implementation.{0,160}\bdirect\b|實作.{0,160}主線直做'
        if (-not $hasImplementationDirect) { return $true }

        $hasDirectorRiskCloseRoute = $Content -match 'closed-with-director-risk|Director.{0,120}(close|accept).{0,80}risk.{0,120}(not full|non-complete|not complete)|總監.{0,80}(風險關閉|接受風險).{0,80}(非完整|不可稱完整|不得稱完整)'
        $hasAuthorizedChangeApplicationRoute = $Content -match 'authorized change-application|change-application gate|authorized gate.{0,120}(apply|application)|change delivery station.{0,120}(apply|application)|明確授權.{0,80}(gate|閘門).{0,80}(套用|應用)|變更站.{0,80}(套用|應用)|授權後.{0,80}(變更站|gate|閘門).{0,80}(套用|應用)'

        return ($hasDirectorRiskCloseRoute -or $hasAuthorizedChangeApplicationRoute)
    }

    function Test-ProgrammingTeamDeliveryRouteReferenceContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasTeamEvidenceSource = $Content -match 'workflow-team-evidence|Team-Native Evidence Reference|Team Governance Reference|team-task-board|team-completion-gate|team-change-delivery-artifact|workflow-capability-evidence-matrix'
        $hasDeliveryBoundary = $Content -match 'delivery artifact|delivery artifacts|implementation change delivery|change delivery|memory/docs|review|validation|completion|Workflow evidence|workflow evidence'
        $hasHonestMissingState = $Content -match 'blocked|unverified|closed-with-director-risk|not-applicable|non-complete'

        return ($hasTeamEvidenceSource -and $hasDeliveryBoundary -and $hasHonestMissingState)
    }

    function Test-ProgrammingTeamFormalDispatchReferenceContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasOrchestrationSource = $Content -match 'workflow-orchestration'
        $hasBoardOrTeamEvidenceSource = $Content -match 'team-task-board|workflow-team-evidence|Team-Native Evidence Reference|Team Governance Reference'
        $hasLifecycleAnchor = $Content -match 'operation_mode|board|dispatch|handoff|station|formal-readonly|formal evidence|channel capability'
        $hasHonestMissingState = $Content -match 'blocked|unverified|closed-with-director-risk|not-applicable|non-complete'

        return ($hasOrchestrationSource -and $hasBoardOrTeamEvidenceSource -and $hasLifecycleAnchor -and $hasHonestMissingState)
    }

    $coreChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\policies\workflow-orchestration.md'
            Severity = 'Red'
            Label = '工作流編排契約缺少狀態機與入口引用語義'
            Patterns = @('Workflow Orchestration Contract', 'Source-Of-Truth Chain', 'Entry Sequence', 'workflow-orchestration-scenarios', 'Scenario playbooks', 'non-authorizing examples', 'workflow route is not authorization|Workflow route is not authorization', 'draft board', 'formal-readonly', 'formal-write', 'dispatch wave', 'previous-wave input', 'next-wave start condition', 'formal evidence eligibility', 'handoff packet', 'channel capability', 'channel invocation status', 'station lifecycle|Station Handoff', 'direct exception', 'delivery artifact|implementation change delivery artifact', 'memory/docs', 'review', 'validation', 'closed-with-director-risk', 'not full team completion|not as complete|not as `complete`', 'When Team mode is not active|no-write does not mean no-team', 'post-board all-at-once dispatch', 'standby', 'small read-only probes|broad reads.*require|captain.*treats.*output as evidence')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\workflow-orchestration-scenarios.md'
            Severity = 'Red'
            Label = '工作流情境範例缺少可照跑的轉場劇本'
            Patterns = @('Workflow Orchestration Scenarios', 'not authorization', 'Scenario Format', 'Read-Only Evidence Station', 'Blueprint To Build', 'Build Or Fix To Validation', 'Failed Validation Route-Back', 'Audit Fan-Out', 'Commit-Preflight Blocker', 'Generated Or Deployed Copy Sync', 'workflow_route', 'operation_mode', 'board_state', 'dispatch wave', 'previous-wave input', 'next-wave start condition', 'handoff_packet_id', 'channel_capability', 'channel_invocation_status', 'delivery artifact', 'route-back', 'blocked', 'unverified', 'standby', 'closed-with-director-risk', 'not full team completion', 'Anti-Examples')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\programming-team-governance\SKILL.md'
            Severity = 'Red'
            Label = '隊長制編程團隊治理共用技能缺少必要章節'
            Patterns = @('Captain-Led Programming Team Governance', 'Source of truth', 'team-native-core', 'workflow-orchestration', 'authorization-resolution', 'team-trace-evidence', 'team-task-board', 'Trigger And Route', 'Board And Station Use', 'Role And Delivery Boundaries', 'Dispatch And Integration Procedure', 'Direct Exceptions', 'team-specialist-registry', 'team-station-handoff-packet', 'Captain Team Board', 'implementation change delivery|change delivery artifact|變更交付件', 'Memory/docs|memory/docs delivery', 'Validation', 'Review', 'Completion', 'isolated change delivery', 'text change delivery', 'closed-with-director-risk|總監風險關閉', 'full Team-Native completion', 'findings:|發現:')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\team-task-board\SKILL.md'
            Severity = 'Red'
            Label = '團隊任務板技能缺少可執行模板'
            Patterns = @('Team Task Board', 'Board Selection', 'Team Object Model', 'Canonical Board Fields', 'Board Header Template', 'Full Board Table', 'Specialist Assignment Template', 'Delivery Forms', 'Dispatch Rules', 'Direct Exception Register', 'Board Closeout Checklist', 'team-native-core', 'workflow-orchestration', 'authorization-resolution', 'team-trace-evidence', 'workflow_route', 'implementation_authorization', 'specialist_role_source', 'assigned_specialist_skill', 'domain_label', 'requested_execution_channel', 'channel_capability', 'channel_invocation_status', 'delivery_artifact_type', 'delivery_artifact_status', 'execution_route', 'evidence_owner', 'role_boundary', 'direct_exception', 'completion_condition', 'Allowed inputs:', 'Output artifact format:', 'findings:|發現:', 'changes:|變更:', 'isolated change delivery', 'text change delivery artifact', 'closed-with-director-risk|總監風險關閉', 'not change delivery and never full Team-Native completion', 'memory_impact')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\_index.md'
            Severity = 'Red'
            Label = '技能索引缺少編程團隊治理路由'
            Patterns = @('programming-team-governance', '編程團隊治理', 'team-task-board', '團隊任務板')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\subagent-invocation.md'
            Severity = 'Red'
            Label = '子代理政策未接入隊長制團隊治理'
            Patterns = @('Captain Trigger Gate', 'Task Type And Dispatch Pre-Gate', 'Team-Native Minimum Execution Gate|station-owned.*change-delivery|handoff_ownership:\s*station-owned', 'Specialist Assignment Gate', 'programming-team-governance', 'team-specialist-registry', 'team-specialist-\*', 'coding workflow station|workflow station|隊長團隊站點板', 'Fake-team guard|假團隊防線', 'Role-exclusivity guard|角色互斥', 'isolated change delivery|隔離變更交付', 'text change delivery|文字變更交付', 'role boundary|角色邊界', 'direct_exception|direct exception|owner station|station-owned|closed-with-director-risk', 'evidence owner|證據負責', 'execution channel|執行通道', 'forces board creation first|任務板 -> 站點|board creation first', 'assigned specialist skill|專家子技能', 'channel capability|通道能力', 'channel invocation status|通道啟動狀態', 'closed-with-director-risk|總監風險關閉', '變更交付件.*記憶文件交付件.*審查交付件.*驗證交付件|implementation change delivery, memory/docs delivery, review delivery, and validation delivery artifacts')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\delegation-strategy\SKILL.md'
            Severity = 'Red'
            Label = '委派策略未使用隊長制角色分派決策'
            Patterns = @('Captain Trigger Gate', 'Task Type And Dispatch Pre-Gate', 'Team-Native Core intent|station-owned main-worktree change delivery|handoff_ownership:\s*station-owned', 'Specialist Dispatch Gate', 'programming-team-governance', 'team-specialist-registry', 'team-task-board', 'Captain Team Board', 'station', 'No specialist branch starts before the board exists', 'Implementation station with governed isolated workspace', 'text change delivery artifact', 'Browser/UI verification station', 'Large CLI-only analysis station', 'Real-time tool access', 'Independent read-only evidence station after special routes are excluded', 'Direct Exception Contract', 'Change Delivery Boundary', 'Fake-Team Guard', 'Role-Exclusivity Guard')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\quality-review-governance\SKILL.md'
            Severity = 'Yellow'
            Label = '審查治理技能未接入角色分離與證據分支規則'
            Patterns = @('Independent Review', 'Role Separation Gate', 'Programming Team Board', 'direct exception', 'All-direct review boards', 'evidence branch', 'reviewer implemented the same deliverable')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\browser-testing\SKILL.md'
            Severity = 'Yellow'
            Label = '瀏覽器測試技能未保留站點要求與直行例外邊界'
            Patterns = @('workflow station requires', 'concrete direct exception', 'blocked` or `unverified', 'do not silently downgrade')
        },
        [PSCustomObject]@{
            Path = 'Shared\platform-capability-matrix.md'
            Severity = 'Red'
            Label = '平台能力矩陣缺少隊長制編程治理能力'
            Patterns = @('Three-Platform Capability Matrix', 'Capability Levels', 'Captain-led governance', 'Team-Native trace', '\bconditional\b', '\bunavailable\b', 'workflow-orchestration', 'authorization-resolution', 'team-task-board|team-change-delivery-artifact', 'protected-action authority', 'channel capability|channel state', 'not become an execution route|not authorize captain-direct')
        },
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Severity = 'Red'
            Label = '工作流矩陣缺少隊長制編程團隊治理矩陣'
            Patterns = @('Three-Platform Workflow Capability', 'Workflow Evidence Rows', 'Team-Native Evidence Reference', 'Team Governance Reference', 'programming-team governance', 'formal-readonly', 'closed-with-director-risk', 'not full team completion|cannot claim\s+`?complete`', 'operation_mode|board_template|board', 'station', 'memory/docs', 'review', 'validation', 'implementation change delivery|station-owned `change-delivery`', 'workflow-orchestration', 'team-completion-gate')
        },
        [PSCustomObject]@{
            Path = 'Shared\skill-governance.md'
            Severity = 'Yellow'
            Label = '技能治理規格未說明編程團隊治理放置規則'
            Patterns = @('programming-team-governance', 'captain trigger', 'role boundary', 'isolated change delivery', 'direct exception', 'all-direct evidence boards are invalid', 'must manually name a workflow')
        }
    )

    foreach ($check in $coreChecks) {
        $fullPath = Join-Path $RepoRoot $check.Path
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason '必要檔案不存在' -Text $check.Label
            continue
        }

        foreach ($pattern in $check.Patterns) {
            if ($content -notmatch $pattern) {
                Add-ProgrammingTeamFinding -Severity $check.Severity -File $check.Path -Line 1 -Reason $check.Label -Text "missing pattern: $pattern"
            }
        }

        if (($check.Path -in @('Shared\platform-capability-matrix.md', 'Shared\policies\subagent-invocation.md', 'Shared\workflow-capability-evidence-matrix.md')) -and (-not ((Test-ProgrammingTeamArtifactSetContent -Content $content) -or (Test-ProgrammingTeamDeliveryRouteReferenceContent -Content $content)))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '核心治理缺少變更交付件、記憶文件交付件、審查交付件、驗證交付件與缺失狀態語義' -Text 'missing implementation change delivery/memory-docs delivery/review delivery/validation delivery artifact evidence or missing blocked/unverified state'
        }

        $hasFullCompletionClaim = Test-ProgrammingTeamFullCompletionClaimContent -Content $content
        if ($hasFullCompletionClaim -and (-not ((Test-ProgrammingTeamArtifactSetContent -Content $content) -or (Test-ProgrammingTeamDeliveryRouteReferenceContent -Content $content)))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '宣稱完整團隊完成時缺少變更、記憶文件、審查、驗證交付件要求' -Text 'full team completion requires change/memory-docs/review/validation delivery artifact evidence'
        }

        if ($hasFullCompletionClaim -and (-not ((Test-ProgrammingTeamMemoryDeliveryContent -Content $content) -or (Test-ProgrammingTeamDeliveryRouteReferenceContent -Content $content)))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '宣稱完整團隊完成時缺少記憶影響、記憶文件交付件與缺失狀態語義' -Text 'full team completion requires memory impact plus memory delivery artifact evidence or blocked/unverified state'
        }

        if (($check.Path -in @('Shared\skills\programming-team-governance\SKILL.md', 'Shared\skills\team-task-board\SKILL.md', 'Shared\skills\delegation-strategy\SKILL.md', 'Shared\workflow-capability-evidence-matrix.md')) -and (-not (Test-ProgrammingTeamImplementationDirectBounded -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '實作站點 direct 必須限於明確授權 gate 套用變更交付件或總監風險關閉' -Text 'implementation direct must not be unrestricted captain implementation'
        }

        if (($check.Path -in @('Shared\skills\programming-team-governance\SKILL.md', 'Shared\skills\team-task-board\SKILL.md', 'Shared\policies\subagent-invocation.md', 'Shared\platform-capability-matrix.md', 'Shared\workflow-capability-evidence-matrix.md')) -and (-not (Test-ProgrammingTeamDirectorRiskCloseContent -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $check.Path -Line 1 -Reason '缺少 closed-with-director-risk 非完整流程關閉語義' -Text 'director risk closure must not be full team completion'
        }
    }

    $teamDeliverySkillNames = @(
        'team-change-delivery-artifact',
        'team-memory-docs-delivery-artifact',
        'team-role-boundaries',
        'team-validation-delivery-artifact',
        'team-review-delivery-artifact',
        'team-completion-gate'
    )

    $teamDeliveryRouteRequiredPaths = @(
        'Shared\policies\subagent-invocation.md'
    )

    $teamDeliveryRouteReferencePaths = @(
        'Shared\platform-capability-matrix.md',
        'Shared\workflow-capability-evidence-matrix.md'
    )

    foreach ($relPath in $teamDeliveryRouteRequiredPaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        foreach ($skillName in $teamDeliverySkillNames) {
            if ($content -notmatch [regex]::Escape($skillName)) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '共用政策或矩陣缺少新團隊交付子技能路由' -Text "missing skill route: $skillName"
            }
        }
    }

    foreach ($relPath in $teamDeliveryRouteReferencePaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        if (-not (Test-ProgrammingTeamDeliveryRouteReferenceContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '共用政策或矩陣缺少團隊交付路由參照' -Text 'expected workflow-team-evidence/team-task-board/team-completion-gate reference plus delivery boundary and blocked/unverified/closed-with-director-risk states'
        }
    }

    $formalDispatchRequiredPatterns = @(
        [PSCustomObject]@{ Name = 'formal board lifecycle'; Pattern = 'formal board lifecycle|board_state|draft board.{0,160}formal (dispatch )?board|草案(任務|派工)?板.{0,160}正式(派工|任務)?板|正式(派工|任務)?板.{0,160}生命週期' },
        [PSCustomObject]@{ Name = 'dispatch wave'; Pattern = 'dispatch wave|dispatch_wave|wave-by-wave dispatch|dispatch waves|逐波次派工|派工波次|分波派工' },
        [PSCustomObject]@{ Name = 'previous-wave input'; Pattern = 'previous-wave input|previous_wave_input|previous wave input|上一波.{0,80}(輸入|產出|證據|結果|回收)|前一波.{0,80}(輸入|產出|證據|結果|回收)' },
        [PSCustomObject]@{ Name = 'next-wave start condition'; Pattern = 'next-wave start condition|next_wave_start_condition|next wave start condition|下一波.{0,80}(啟動|開始).{0,80}(條件|門檻)|下一波.{0,80}(條件|門檻).{0,80}(啟動|開始)' },
        [PSCustomObject]@{ Name = 'formal evidence eligibility'; Pattern = 'formal evidence eligibility|formal_evidence_eligibility|formal evidence qualification|正式證據(資格|條件)|正式驗收證據(資格|條件)|formal acceptance evidence' },
        [PSCustomObject]@{ Name = 'specialist lifecycle'; Pattern = 'specialist lifecycle|station lifecycle|station_lifecycle_state|隊員生命週期|站點生命週期|保留理由|retention reason' },
        [PSCustomObject]@{ Name = 'fast closeout lane'; Pattern = 'fast closeout|closeout lane|closeout_lane|快速收尾|收尾線|light.{0,80}standard.{0,80}release-grade' },
        [PSCustomObject]@{ Name = 'yellow classification'; Pattern = 'yellow classification|yellow_classification|Yellow classification|黃燈分類|fix-this-cycle|residual-accepted|deferred-follow-up|local-customization|informational' },
        [PSCustomObject]@{ Name = 'repair loop limit'; Pattern = 'repair loop|repair_loop_limit|修復迴圈|two repair attempts|修兩次|兩次.{0,80}(修|嘗試)' },
        [PSCustomObject]@{ Name = 'director risk non-complete closure'; Pattern = 'closed-with-director-risk|director risk close|總監風險關閉' }
    )

    $formalDispatchRequiredPaths = @(
        'Shared\skills\team-task-board\SKILL.md',
        'Shared\skills\delegation-strategy\SKILL.md',
        'Shared\policies\subagent-invocation.md'
    )

    $formalDispatchReferencePaths = @(
        'Shared\platform-capability-matrix.md',
        'Shared\workflow-capability-evidence-matrix.md'
    )

    foreach ($relPath in $formalDispatchRequiredPaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        foreach ($required in $formalDispatchRequiredPatterns) {
            if ($content -notmatch $required.Pattern) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '缺少正式派工板生命週期與波次派工語義' -Text "missing pattern: $($required.Name)"
            }
        }
    }

    foreach ($relPath in $formalDispatchReferencePaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        if (-not (Test-ProgrammingTeamFormalDispatchReferenceContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '共用矩陣缺少正式派工生命週期參照' -Text 'expected workflow-orchestration plus team-task-board/workflow-team-evidence reference, lifecycle anchors, and honest missing-evidence states'
        }
    }

    foreach ($relPath in $formalDispatchRequiredPaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        if (-not (Test-ProgrammingTeamFirstReadonlyContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '缺少受治理請求觸發 formal-readonly 與未啟動一般生命週期語義' -Text '受治理請求會觸發 Team mode；formal-readonly 是 Team mode active 後的唯讀站點要求。未啟動 Team mode 時應走一般生命週期與範圍式授權。'
        }
        if (-not (Test-ProgrammingTeamStandbyContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '缺少隊員 standby 與未啟動狀態回報語義' -Text '未啟動的隊員路由必須記錄為 standby、blocked、unverified、unavailable 或 not-authorized。'
        }
        if (-not (Test-ProgrammingTeamDispatchPackageContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '缺少技能派工包欄位要求' -Text '隊員派工必須包含輸入、工具、禁止動作、交付件格式與停止條件（inputs / tools / forbidden actions / artifact format / stop condition）。'
        }
        if (-not (Test-ProgrammingTeamLargeReadBoundaryContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '缺少大檔深讀不得由隊長包辦的界線' -Text '大檔深讀必須交給有界隊員站點，或標記為 blocked / unverified。'
        }
    }

    $channelMonitoringRequiredPaths = @(
        'Shared\policies\team-trace-evidence.md',
        'Shared\skills\team-task-board\SKILL.md',
        'Shared\skills\team-station-handoff-packet\SKILL.md',
        '.agents\shared\policies\team-trace-evidence.md',
        '.agents\skills\team-task-board\SKILL.md',
        '.agents\skills\team-station-handoff-packet\SKILL.md'
    )

    foreach ($relPath in $channelMonitoringRequiredPaths) {
        $content = Get-ProgrammingTeamContent -Path (Join-Path $RepoRoot $relPath)
        if ($null -eq $content) { continue }
        if (-not (Test-ProgrammingTeamChannelMonitoringContent -Content $content)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '隊員通道監控欄位不完整' -Text ("缺少必要欄位：{0}" -f (Format-AuditFieldListDisplay -Fields @('channel_capability', 'channel_invocation_status', 'startup_started_at', 'first_response_deadline', 'last_progress_at', 'timeout_action', 'standby_reason')))
        }
    }

    $formalDispatchNegativeChecks = @(
        [PSCustomObject]@{ Pattern = '(?i)(draft board|草案(任務|派工)?板).{0,140}(may|can|allowed|允許|可以|可|直接|立即).{0,100}(dispatch|spawn|start|open|啟動|開啟|派工|開出).{0,80}(specialist|subagent|branch|隊員|分支|子代理)'; Reason = '草案板不得啟動正式隊員' },
        [PSCustomObject]@{ Pattern = '(?i)(draft evidence|草案證據|草案包證據).{0,140}(satisf(y|ies)|counts? as|eligible|pass(es)?|滿足|算作|可作為|通過|符合).{0,100}(formal acceptance|formal evidence|正式驗收|正式證據|正式接受)'; Reason = '草案證據不得滿足正式驗收' },
        [PSCustomObject]@{ Pattern = '(?i)(post-board|after board|任務板後|建板後|隊長任務板後).{0,180}(all-at-once|all at once|dispatch all|spawn all|一次(開|啟動|派出|派工).{0,30}(全部|所有)|全部(隊員|分支|子代理).{0,30}一次(開|啟動|派出|派工))'; Reason = '正式板後不得一次啟動全部隊員，必須逐波次派工' },
        [PSCustomObject]@{ Pattern = '(?i)(complete-with-accepted-risk|已接受風險完成|accepted-risk[^.\r\n]{0,100}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)|已接受風險[^。\r\n]{0,100}(完整完成|完整團隊完成|完成))'; Reason = '已接受風險不得宣稱完整完成，需改為 closed-with-director-risk 的非完整流程關閉' },
        [PSCustomObject]@{ Pattern = '(?i)(complete only when|may be reported complete|reported complete only when)[^.\r\n]{0,180}(blocked|unverified|closed-with-director-risk|risk-closed|honestly blocked)'; Reason = '完成條件不得混入阻塞、未驗證或風險關閉狀態' },
        [PSCustomObject]@{ Pattern = '(?i)(closed-with-director-risk|總監風險關閉)[^.\r\n。]{0,120}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)'; Reason = '總監風險關閉不得宣稱完整完成' },
        [PSCustomObject]@{ Pattern = '(?i)(standby|待命).{0,160}(\bcomplete\b|completed|full team completion|formal completion evidence|完整完成|完整團隊完成|已完成|已回收|已整合|正式完成證據|驗收通過)'; Reason = '待命狀態不得當成完成證據' },
        [PSCustomObject]@{ Pattern = '(?i)(review|validation|審查|驗證).{0,120}(before|prior to|earlier than|早於|先於).{0,100}(change delivery|implementation change delivery|變更交付件|實作變更交付)'; Reason = '審查或驗證不得早於變更交付件' },
        [PSCustomObject]@{ Pattern = '(?i)(same wave|同一波|同波).{0,180}(implementation|change delivery|實作|變更交付).{0,180}(review|審查).{0,120}(same deliverable|same artifact|同一交付物|同一交付件)'; Reason = '同一波不得同時啟動實作與同交付物審查' },
        [PSCustomObject]@{ Pattern = '(?i)(captain|隊長).{0,100}(author(s|ed|ing)?|create(s|d|ing)?|produce(s|d|ing)?|\bimplement(s|ed|ing)?\b|substitut(e|es|ed|ing|ion)?|創作|產出|實作|替代|代工).{0,140}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)'; Reason = '隊長創作或隊長替代不得宣稱 complete' },
        [PSCustomObject]@{ Pattern = '(?i)(captain reimplements|captain.{0,80}reimplement|隊長.{0,80}重新實作|隊長.{0,80}重寫)'; Reason = '不得把 Captain reimplements 當成正式變更交付' },
        [PSCustomObject]@{ Pattern = '(?i)(direct after \bGO\b|after \bGO\b.{0,80}direct|\bGO\b.{0,80}direct|GO 後.{0,80}(直做|直接)|授權後.{0,80}(直做|直接))'; Reason = 'GO 後不得直接跳過正式變更交付站點' },
        [PSCustomObject]@{ Pattern = '(?i)(main-worktree writes?|main worktree writes?|主工作樹寫入|主線寫入).{0,140}(instead of|without|skip|direct|代替|沒有|跳過|直做|直接).{0,120}(change delivery|delivery artifact|變更交付|交付件|station|站點)'; Reason = 'main-worktree writes 不得替代變更交付件' },
        [PSCustomObject]@{ Pattern = '(?i)(隊長代工|captain substitute authoring|captain-substitute authoring|captain substituted).{0,160}(implementation|change delivery|變更交付|實作|完成|complete)'; Reason = '隊長代工不得當成正式實作或完成證據' },
        [PSCustomObject]@{ Pattern = '(?i)(active Team mode|Team mode active|Team mode 啟動後|Team mode 因受治理請求|active captain-led mode|captain-led mode is active|after captain-led mode is active|formal-readonly|formal team stations|正式.{0,80}(唯讀|無寫入)).{0,220}(no-write|read-only|無寫入|唯讀).{0,160}(no-team|no team|without team|skip team|不用(團隊|隊員)|不需要(團隊|隊員)|無團隊)'; Reason = 'active Team mode 中不得把 no-write 或唯讀解讀成 no-team' },
        [PSCustomObject]@{ Pattern = '(?i)(captain|隊長).{0,120}(read|loaded|absorbed|deep read|完整讀|全量讀|吞|深讀).{0,120}(large file|whole file|full file|大檔|大型檔案|全檔|整份)'; Reason = '隊長不得用完整吞大檔替代隊員深讀' }
    )

    foreach ($relPath in $formalDispatchRequiredPaths) {
        foreach ($bad in $formalDispatchNegativeChecks) {
            Add-ProgrammingTeamRegexFindings -RelativePath $relPath -Pattern $bad.Pattern -Reason $bad.Reason
        }
        Add-ProgrammingTeamBadNoWriteNoTeamFindings -RelativePath $relPath -Reason 'active Team mode 中不得把 no-write 或唯讀解讀成 no-team'
    }

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern '\|\s*active\s*\||\|\s*optional\s*\||\|\s*as-needed\s*\||\|\s*if-needed\s*\|' `
        -Reason '團隊站點不得把 active 當成最終狀態'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'same specialist both implements and reviews.*valid|implementation specialist.*may.*review|review specialist.*may.*implement' `
        -Reason '隊長制角色不得允許同一交付物自我審查'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'spawn.*before.*board|branch.*before.*board|delegate.*before.*board|先開.*(代理|隊員|分支).*再.*(板|站點)' `
        -Reason '隊長制不得允許先開隊員再補任務板'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'captain.*direct.*(counter-evidence|impact map|review|completion audit).*default|隊長.*包辦.*(反證|影響面|審查|收尾)' `
        -Reason '隊長制不得把反證、影響面、審查與收尾稽核預設交回隊長包辦'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'evaluate each active station|Independent read-only station\?\*\*\s*->\s*`evidence branch`' `
        -Reason '委派策略不得先用一般證據分支吞掉特殊分支'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'None of above\?\*\*.*->\s*`direct`|None of above.*->\s*direct' `
        -Reason '委派策略不得保留無匹配即主線直做 fallback'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost)|主線直做.*(小型|中型|大型|必要時)|direct.*(小型|中型|大型|必要時)' `
        -Reason '委派策略不得用大小型、必要時或成本口號作為主要決策理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\team-task-board\SKILL.md' `
        -Pattern 'Single-step direct|tiny read/write step|cost more to package|allowed only for small|tiny known file set' `
        -Reason '團隊任務板不得保留單步、微小讀寫或包裝成本作為 direct 例外'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\team-task-board\SKILL.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost|tiny|single-step)|allowed only for .*?\b(tiny|single-step|small)\b|主線直做.*(小型|微小|單步|成本)' `
        -Reason '團隊任務板不得用任務大小、速度或成本口號作為 direct_exception 理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\programming-team-governance\SKILL.md' `
        -Pattern 'implementation.*direct.*(unrestricted|normal fallback|routine captain)|captain.*implementation.*normal fallback|實作.*主線直做.*(不受限|正常|預設)' `
        -Reason '隊長制不得允許實作站點不受限制地回到隊長直做'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\workflow-capability-evidence-matrix.md' `
        -Pattern 'implementation.*direct.*(unrestricted|normal fallback|routine captain)|實作.*主線直做.*(不受限|正常|預設)' `
        -Reason '工作流矩陣不得允許實作站點不受限制地回到隊長直做'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\delegation-strategy\SKILL.md' `
        -Pattern 'subagent.*before.*board|specialist.*before.*board|隊員.*早於.*任務板' `
        -Reason '委派策略不得允許前置任務板之前啟動隊員'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'active station|每個 active' `
        -Reason '子代理政策不得保留 active station 語義'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern '委派成本高於收益|delegation cost.*direct' `
        -Reason '子代理政策不得以委派成本作為泛用主線直做理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'direct.*(small task|faster|not necessary|delegation cost)|主線直做.*(小型|中型|大型|必要時)|direct.*(小型|中型|大型|必要時)' `
        -Reason '子代理政策不得用大小型、必要時或成本口號作為主要決策理由'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\policies\subagent-invocation.md' `
        -Pattern 'explicitly asks for subagents.*spawns|總監.*要求.*子代理.*(直接|立即).*(開|啟動)' `
        -Reason '子代理政策不得把總監要求子代理解讀成繞過任務板'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\quality-review-governance\SKILL.md' `
        -Pattern 'Evidence branches are optional|work benefits from parallel inspection|main thread is blocked on the same answer' `
        -Reason '審查治理不得把證據分支降成可選或因主線等待而禁止'

    Add-ProgrammingTeamRegexFindings -RelativePath 'Shared\skills\browser-testing\SKILL.md' `
        -Pattern 'otherwise the main Codex agent uses available Browser tooling directly' `
        -Reason '瀏覽器分支不得靜默退回主線工具'

    $delegationPath = Join-Path $RepoRoot 'Shared\skills\delegation-strategy\SKILL.md'
    $delegationContent = Get-ProgrammingTeamContent -Path $delegationPath
    if ($null -ne $delegationContent) {
        $browserIndex = $delegationContent.IndexOf('Browser/UI verification station?')
        $cliIndex = $delegationContent.IndexOf('Large CLI-only analysis station?')
        $isolatedPatchIndex = $delegationContent.IndexOf('Implementation station with governed isolated workspace')
        $mcpIndex = $delegationContent.IndexOf('Real-time tool access?')
        $evidenceIndex = $delegationContent.IndexOf('Independent read-only evidence station after special routes are excluded?')
        if (($evidenceIndex -lt 0) -or ($browserIndex -lt 0) -or ($cliIndex -lt 0) -or ($isolatedPatchIndex -lt 0) -or ($mcpIndex -lt 0)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File 'Shared\skills\delegation-strategy\SKILL.md' -Line 1 -Reason '委派策略缺少特殊分支優先順序' -Text 'browser/CLI/MCP/evidence route markers missing'
        } elseif (($evidenceIndex -lt $browserIndex) -or ($evidenceIndex -lt $cliIndex) -or ($evidenceIndex -lt $isolatedPatchIndex) -or ($evidenceIndex -lt $mcpIndex)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File 'Shared\skills\delegation-strategy\SKILL.md' -Line 1 -Reason '一般證據分支不得早於瀏覽器、CLI 或 MCP 分支' -Text 'reorder Delegation Gate'
        }
    }

    $routingChecks = @(
        'Codex\.agents\workflow-skills\00-chat-聊天\SKILL.md',
        'Codex\.agents\workflow-skills\01-explore-探索\SKILL.md',
        'Claude\.claude\commands\00_chat(討論)\SKILL.md',
        'Claude\.claude\commands\01_explore(搜索)\SKILL.md',
        'Antigravity\.agents\workflows\00_chat(討論).md',
        'Antigravity\.agents\workflows\01_explore(搜索).md'
    )

    foreach ($relPath in $routingChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '聊天或探勘入口不存在' -Text $relPath
            continue
        }
        $isThinRoutingEntry = Test-ProgrammingTeamThinWorkflowEntryContent -Content $content
        $declaresTeamOrDelegation = $content -match '(?i)Team[- ]?Native|Team mode|captain-led|subagent|delegation|隊長制|隊長|子代理|團隊'
        $hasGovernedTeamActivation = $content -match '(?i)(governed (Director|user) request|governed work|受治理請求|受治理工作|使用者要求.{0,120}(source|governance|workflow|fix|build|debug|test|audit|skill|memory/docs|commit|handoff|public-contract|受治理)|Team mode.{0,160}(governance|workflow|fix|build|debug|test|audit|skill|memory/docs|commit|handoff|source|public-contract|受治理)|不需要.{0,40}(固定口令|啟動團隊模式)|does not need.{0,80}(fixed phrase|fixed Team))'
        $hasInactiveNoTeamBoard = $content -match '(?i)(When Team mode is not active|Team mode 未啟動|not active.{0,100}captain/team-board|不套用 captain/team-board|不建立團隊站點板|do not create a Captain Team Board|ordinary lifecycle|normal lifecycle|一般生命週期|普通工作流)'
        if ($declaresTeamOrDelegation -and (-not $isThinRoutingEntry) -and (-not ($hasGovernedTeamActivation -and $hasInactiveNoTeamBoard))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason 'Team mode 或 subagent delegation 聲明缺少受治理請求觸發與未啟動不套用 team-board 語義' -Text '文件若聲明 Team mode 或 subagent delegation，必須說明受治理使用者請求會觸發 Team mode；未啟動時走一般生命週期，不要求純聊天/小問答自動轉隊長制。'
        }
        if ($content -match 'Director must.*restate|must manually name|必須手動|手動指定') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '聊天或探勘入口不得要求總監手動重述工作流名稱才觸發治理' -Text $relPath
        }
        if ($relPath -match '00') {
            if ((-not (Test-ProgrammingTeamChatReadonlyContent -Content $content)) -and (-not (Test-ProgrammingTeamThinChatEntryContent -Content $content))) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '00 入口缺少證據型對話升級為 formal-readonly 的硬閘門' -Text '00 evidence-bearing chat must require formal-readonly station, evidence status reporting, and station-delivery/captain coordination boundary'
            }
            if ($content -match '(?i)Answer directly\..{0,120}(Read|讀取|read relevant files)|直接回答.{0,120}(Read|讀取|讀檔)') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '00 入口不得保留先直接讀檔回答的舊語義' -Text $relPath
            }
            if ($content -notmatch 'memory_awareness:\s*read') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '00 證據型對話入口必須具備唯讀記憶意識' -Text 'missing memory_awareness: read'
            }
            if ($content -notmatch 'filesystem:read') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '00 證據型對話入口必須允許唯讀檔案採證範圍' -Text 'missing filesystem:read'
            }
        }
    }

    Add-ProgrammingTeamAmbiguousPositiveFindings -RelativePaths @(
        'Shared\policies\subagent-invocation.md',
        'Shared\policies\team-native-core.md',
        'Shared\policies\workflow-orchestration.md',
        'Shared\workflow-capability-evidence-matrix.md',
        'Shared\platform-capability-matrix.md',
        'Shared\skills\programming-team-governance\SKILL.md',
        'Shared\skills\team-task-board\SKILL.md',
        'Shared\skills\team-station-handoff-packet\SKILL.md',
        'Codex\.agents\workflow-skills\00-chat-聊天\SKILL.md',
        'Claude\.claude\commands\00_chat(討論)\SKILL.md',
        'Antigravity\.agents\workflows\00_chat(討論).md'
    )

    $workflowChecks = @(
        'Codex\.agents\workflow-skills\02-blueprint-架構\SKILL.md',
        'Codex\.agents\workflow-skills\03-1-experiment-實驗\SKILL.md',
        'Codex\.agents\workflow-skills\03-build-建構\SKILL.md',
        'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md',
        'Codex\.agents\workflow-skills\05-condense-濃縮\SKILL.md',
        'Codex\.agents\workflow-skills\06-test-測試\SKILL.md',
        'Codex\.agents\workflow-skills\07-debug-除錯\SKILL.md',
        'Codex\.agents\workflow-skills\08-audit-健檢\SKILL.md',
        'Codex\.agents\workflow-skills\08-1-infra-基礎盤點\SKILL.md',
        'Codex\.agents\workflow-skills\08-2-logic-深度邏輯\SKILL.md',
        'Codex\.agents\workflow-skills\08-3-report-健檢總結\SKILL.md',
        'Codex\.agents\workflow-skills\09-commit-紀錄總結\SKILL.md',
        'Codex\.agents\workflow-skills\10-routine-巡檢\SKILL.md',
        'Codex\.agents\workflow-skills\11-handoff-交接\SKILL.md',
        'Codex\.agents\workflow-skills\12-skill-forge-技能鍛造\SKILL.md',
        'Claude\.claude\commands\02_blueprint(架構)\SKILL.md',
        'Claude\.claude\commands\03-1_experiment(實驗)\SKILL.md',
        'Claude\.claude\commands\03_build(建構)\SKILL.md',
        'Claude\.claude\commands\04_fix(修復)\SKILL.md',
        'Claude\.claude\commands\05_condense（濃縮）\SKILL.md',
        'Claude\.claude\commands\06_test(測試)\SKILL.md',
        'Claude\.claude\commands\07_debug(除錯)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-1_infra\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-2_logic\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-3_report\SKILL.md',
        'Claude\.claude\commands\09_commit(紀錄)\SKILL.md',
        'Claude\.claude\commands\10_routine(巡檢)\SKILL.md',
        'Claude\.claude\commands\11_handoff(交接)\SKILL.md',
        'Claude\.claude\commands\12_skill_forge(技能鍛造)\SKILL.md',
        'Antigravity\.agents\workflows\02_blueprint(架構).md',
        'Antigravity\.agents\workflows\03-1_experiment(實驗).md',
        'Antigravity\.agents\workflows\03_build(建構計畫).md',
        'Antigravity\.agents\workflows\03-2_build_execute(建構執行).md',
        'Antigravity\.agents\workflows\04-1_fix_plan(修復計畫).md',
        'Antigravity\.agents\workflows\04-2_fix_execute(修復執行).md',
        'Antigravity\.agents\workflows\05_condense(濃縮).md',
        'Antigravity\.agents\workflows\06_test(測試).md',
        'Antigravity\.agents\workflows\07_debug(除錯).md',
        'Antigravity\.agents\workflows\08_audit(健檢).md',
        'Antigravity\.agents\workflows\08-1_audit_infra(基礎盤點).md',
        'Antigravity\.agents\workflows\08-2_audit_logic(深度邏輯).md',
        'Antigravity\.agents\workflows\08-3_audit_report(健檢總結).md',
        'Antigravity\.agents\workflows\09-1_commit_scan(紀錄掃描).md',
        'Antigravity\.agents\workflows\09-2_commit_execute(授權備份).md',
        'Antigravity\.agents\workflows\10_routine(巡檢).md',
        'Antigravity\.agents\workflows\11_handoff(交接).md',
        'Antigravity\.agents\workflows\12_skill_forge(技能鍛造).md'
    )

    $workflowEntryFormalDispatchRequiredPatterns = @(
        [PSCustomObject]@{ Name = 'draft board'; Pattern = 'draft board|草案(任務|派工)?板' },
        [PSCustomObject]@{ Name = 'formal dispatch board'; Pattern = 'formal dispatch board|formal board|正式派工板|正式任務板' },
        [PSCustomObject]@{ Name = 'dispatch wave'; Pattern = 'dispatch wave|wave-by-wave dispatch|dispatch waves|逐波次派工|派工波次|分波派工' },
        [PSCustomObject]@{ Name = 'previous-wave input'; Pattern = 'previous-wave input|previous wave input|上一波.{0,80}(輸入|產出|證據|結果|回收)|前一波.{0,80}(輸入|產出|證據|結果|回收)' },
        [PSCustomObject]@{ Name = 'next-wave start condition'; Pattern = 'next-wave start condition|next wave start condition|下一波.{0,80}(啟動|開始).{0,80}(條件|門檻)|下一波.{0,80}(條件|門檻).{0,80}(啟動|開始)' },
        [PSCustomObject]@{ Name = 'formal evidence eligibility'; Pattern = 'formal evidence eligibility|formal evidence qualification|正式證據(資格|條件)|正式驗收證據(資格|條件)|formal acceptance evidence' },
        [PSCustomObject]@{ Name = 'no post-board all-at-once dispatch'; Pattern = 'no post-board all-at-once (dispatch|launch)|post-board all-at-once (dispatch|launch) is invalid|不得.{0,80}(建板後|任務板後|隊長任務板後).{0,80}(一次全派|一次派工全部|全部一次派工|一次啟動全部)|建板後.{0,80}不得.{0,80}(一次全派|一次派工全部|全部一次派工|一次啟動全部)' },
        [PSCustomObject]@{ Name = 'director risk non-complete closure'; Pattern = 'closed-with-director-risk|director risk close|總監風險關閉' }
    )

    $workflowEntryFormalDispatchForbiddenPatterns = @(
        [PSCustomObject]@{ Pattern = '(?i)(draft board|草案(任務|派工)?板).{0,140}(may|can|allowed|允許|可以|可|直接|立即).{0,100}(dispatch|spawn|start|open|啟動|開啟|派工|開出).{0,80}(specialist|subagent|branch|隊員|分支|子代理)'; Reason = '工作流入口不得允許草案板啟動正式隊員' },
        [PSCustomObject]@{ Pattern = '(?i)(draft evidence|草案證據|草案包證據).{0,140}(satisf(y|ies)|counts? as|eligible|pass(es)?|滿足|算作|可作為|通過|符合).{0,100}(formal acceptance|formal evidence|正式驗收|正式證據|正式接受)'; Reason = '工作流入口不得允許草案證據滿足正式驗收' },
        [PSCustomObject]@{ Pattern = '(?i)(post-board|after board|任務板後|建板後|隊長任務板後).{0,180}(all-at-once|all at once|dispatch all|spawn all|一次(開|啟動|派出|派工).{0,30}(全部|所有)|全部(隊員|分支|子代理).{0,30}一次(開|啟動|派出|派工))'; Reason = '工作流入口不得允許建板後一次全派' },
        [PSCustomObject]@{ Pattern = '(?i)(complete-with-accepted-risk|已接受風險完成|accepted-risk[^.\r\n]{0,100}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)|已接受風險[^。\r\n]{0,100}(完整完成|完整團隊完成|完成))'; Reason = '工作流入口不得把已接受風險宣稱為完整完成' },
        [PSCustomObject]@{ Pattern = '(?i)(complete only when|may be reported complete|reported complete only when)[^.\r\n]{0,180}(blocked|unverified|closed-with-director-risk|risk-closed|honestly blocked)'; Reason = '工作流入口不得把阻塞、未驗證或風險關閉混入完成條件' },
        [PSCustomObject]@{ Pattern = '(?i)(closed-with-director-risk|總監風險關閉)[^.\r\n。]{0,120}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)'; Reason = '工作流入口不得把總監風險關閉宣稱為完整完成' },
        [PSCustomObject]@{ Pattern = '(?i)(standby|待命).{0,160}(\bcomplete\b|completed|full team completion|formal completion evidence|完整完成|完整團隊完成|已完成|已回收|已整合|正式完成證據|驗收通過)'; Reason = '工作流入口不得把待命狀態當成完成證據' },
        [PSCustomObject]@{ Pattern = '(?i)(review|validation|審查|驗證).{0,120}(before|prior to|earlier than|早於|先於).{0,100}(change delivery|implementation change delivery|變更交付件|實作變更交付)'; Reason = '工作流入口不得允許審查或驗證早於變更交付件' },
        [PSCustomObject]@{ Pattern = '(?i)(same wave|同一波|同波).{0,180}(implementation|change delivery|實作|變更交付).{0,180}(review|審查).{0,120}(same deliverable|same artifact|同一交付物|同一交付件)'; Reason = '工作流入口不得允許同波啟動實作與同交付物審查' },
        [PSCustomObject]@{ Pattern = '(?i)(captain|隊長).{0,100}(author(s|ed|ing)?|create(s|d|ing)?|produce(s|d|ing)?|\bimplement(s|ed|ing)?\b|substitut(e|es|ed|ing|ion)?|創作|產出|實作|替代|代工).{0,140}(complete|completed|completion|full team completion|完整完成|完整團隊完成|完成)'; Reason = '工作流入口不得允許隊長創作或替代後宣稱 complete' },
        [PSCustomObject]@{ Pattern = '(?i)(captain reimplements|captain.{0,80}reimplement|隊長.{0,80}重新實作|隊長.{0,80}重寫)'; Reason = '工作流入口不得把 Captain reimplements 當成正式變更交付' },
        [PSCustomObject]@{ Pattern = '(?i)(direct after \bGO\b|after \bGO\b.{0,80}direct|\bGO\b.{0,80}direct|GO 後.{0,80}(直做|直接)|授權後.{0,80}(直做|直接))'; Reason = '工作流入口不得允許 GO 後直接跳過正式變更交付站點' },
        [PSCustomObject]@{ Pattern = '(?i)(main-worktree writes?|main worktree writes?|主工作樹寫入|主線寫入).{0,140}(instead of|without|skip|direct|代替|沒有|跳過|直做|直接).{0,120}(change delivery|delivery artifact|變更交付|交付件|station|站點)'; Reason = '工作流入口不得以 main-worktree writes 替代變更交付件' },
        [PSCustomObject]@{ Pattern = '(?i)(隊長代工|captain substitute authoring|captain-substitute authoring|captain substituted).{0,160}(implementation|change delivery|變更交付|實作|完成|complete)'; Reason = '工作流入口不得把隊長代工當成正式實作或完成證據' },
        [PSCustomObject]@{ Pattern = '(?i)(active Team mode|Team mode active|Team mode 啟動後|Team mode 因受治理請求|active captain-led mode|captain-led mode is active|after captain-led mode is active|formal-readonly|formal team stations|正式.{0,80}(唯讀|無寫入)).{0,220}(no-write|read-only|無寫入|唯讀).{0,160}(no-team|no team|without team|skip team|不用(團隊|隊員)|不需要(團隊|隊員)|無團隊)'; Reason = '工作流入口在 active Team mode 中不得把 no-write 或唯讀解讀成 no-team' },
        [PSCustomObject]@{ Pattern = '(?i)(captain|隊長).{0,120}(read|loaded|absorbed|deep read|完整讀|全量讀|吞|深讀).{0,120}(large file|whole file|full file|大檔|大型檔案|全檔|整份)'; Reason = '工作流入口不得用隊長完整吞大檔替代隊員深讀' }
    )

    foreach ($relPath in $workflowChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ProgrammingTeamContent -Path $fullPath
        if ($null -eq $content) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '三平台工作流入口不存在' -Text $relPath
            continue
        }

        if ($content -notmatch 'programming-team-governance') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口未載入編程團隊治理技能' -Text $relPath
        }
        $hasBoardReference = $content -match 'team-task-board|current board|stations opened by the current board|load board, handoff|任務板|站點板'
        if (-not $hasBoardReference) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口未引用團隊任務板技能' -Text $relPath
        }
        if ($content -notmatch 'workflow-orchestration') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口未引用共享工作流編排契約' -Text 'missing .agents/shared/policies/workflow-orchestration.md'
        }
        $isThinWorkflowEntry = Test-ProgrammingTeamThinWorkflowEntryContent -Content $content
        if (($content -notmatch 'Programming Team Board|Team Station|團隊站點|team-station') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口缺少團隊站點可讀語義' -Text $relPath
        }
        if ((-not (Test-ProgrammingTeamWorkflowModeContent -Content $content)) -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少日常模式、完整模式與直行/唯讀/寫入邊界' -Text 'required: operation_mode, daily, full, direct, formal-readonly, formal-write'
        }
        if ((-not (Test-ProgrammingTeamWorkflowRoleLifecycleContent -Content $content)) -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少角色分工、任務板觸發或隊員生命週期規則' -Text 'required: team-specialist-registry, team-task-board, handoff packet, role identity, station lifecycle, startup monitoring, non-complete risk closure'
        }
        foreach ($required in $workflowEntryFormalDispatchRequiredPatterns) {
            if (($content -notmatch $required.Pattern) -and (-not $isThinWorkflowEntry)) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少新版正式派工語義' -Text "missing pattern: $($required.Name)"
            }
        }
        foreach ($bad in $workflowEntryFormalDispatchForbiddenPatterns) {
            Add-ProgrammingTeamRegexFindings -RelativePath $relPath -Pattern $bad.Pattern -Reason $bad.Reason
        }
        Add-ProgrammingTeamBadNoWriteNoTeamFindings -RelativePath $relPath -Reason '工作流入口在 active Team mode 中不得把 no-write 或唯讀解讀成 no-team'
        if (($content -notmatch 'evidence owner|證據負責') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少證據負責人欄位' -Text $relPath
        }
        if (($content -notmatch 'direct_exception|direct exception|closed-with-director-risk|owner[- ]station|station-owned|直行例外') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少 direct_exception 或 owner-station 邊界' -Text $relPath
        }
        if (($content -notmatch 'role boundary|角色邊界') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少角色邊界欄位' -Text $relPath
        }
        if (($content -notmatch 'isolated change delivery|隔離變更交付') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少隔離變更交付分支語義' -Text $relPath
        }
        if (($content -notmatch 'self-review|review their own|review its own|審查.*自己|自我審查') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少實作者不得自我審查規則' -Text $relPath
        }
        if (($content -notmatch 'all-direct|All-direct|all direct|全主線|全部.*直做') -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口未明示全主線假團隊防線' -Text $relPath
        }
        if ($content -match 'active Team Station|each active station|每個 active') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留 active station 語義' -Text $relPath
        }
        if ($content -match 'direct,\s*delegated,\s*blocked|mark stations direct,\s*delegated|execution mode:\s*direct,\s*delegated') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留舊版 direct/delegated 模式集合' -Text $relPath
        }
        if ($content -match 'Begin writing source code using|Apply fixes using|Physical Write|Physical Fix Execution') {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口不得保留 GO 後主線直接實作語句' -Text $relPath
        }
        $hasFullCompletionClaim = Test-ProgrammingTeamFullCompletionClaimContent -Content $content
        if ($hasFullCompletionClaim -and (-not (Test-ProgrammingTeamArtifactSetContent -Content $content))) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口宣稱完整團隊完成時缺少變更、記憶文件、審查、驗證交付件要求' -Text $relPath
        }
        if ($hasFullCompletionClaim -and (-not (Test-ProgrammingTeamMemoryDeliveryContent -Content $content))) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口宣稱完整團隊完成時缺少記憶影響、記憶文件交付件與缺失狀態語義' -Text $relPath
        }
        if ((-not (Test-ProgrammingTeamDirectorRiskCloseContent -Content $content)) -and (-not $isThinWorkflowEntry)) {
            Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少 closed-with-director-risk 非完整流程關閉語義' -Text $relPath
        }
        foreach ($skillName in $teamDeliverySkillNames) {
            if (($content -notmatch [regex]::Escape($skillName)) -and (-not $isThinWorkflowEntry)) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '工作流入口缺少新團隊交付子技能路由' -Text "missing skill route: $skillName"
            }
        }
        if ($content -match 'enter captain-minimal team mode automatically\.\s*Classify task type|No specialist branch, subagent, browser branch, CLI branch, MCP evidence route') {
            Add-ProgrammingTeamFinding -Severity 'Yellow' -File $relPath -Line 1 -Reason '工作流入口不應複製舊版隊長制長段規則，應短引用 programming-team-governance 與 team-task-board' -Text $relPath
        }
        if ($relPath -match '03-1') {
            $hasExperimentGovernedActivation = $content -match '(?i)(03-1|experiment|sandbox prototype|sandbox|spike|dirty-code|髒碼|原型).{0,180}(governed workflow|受治理 workflow|受治理工作|activates Team mode|觸發 Team mode|Team mode 由該請求觸發|啟動 Team mode)|使用者要求.{0,180}(03-1|experiment|sandbox|spike|prototype|原型).{0,180}(Team mode|隊長)'
            $hasExperimentBoard = $content -match '(?i)(reduced|minimal|縮減|最小).{0,100}(experiment station/board|Team station/board|station/board|experiment board|站點|任務板|實驗板)'
            if (-not ($hasExperimentGovernedActivation -and $hasExperimentBoard)) {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口缺少 03-1 受治理請求觸發 Team mode 與 reduced/minimal experiment station/board 語義' -Text $relPath
            }
            if ($content -match '(?i)(03-1|experiment|sandbox).{0,180}(does not activate Team|does not activate Team-Native|not activate Team|本身不自動啟動|不自動啟動)|(不要求|do not require).{0,80}Captain Team Board') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口仍保留 03-1 非團隊執行舊語義' -Text $relPath
            }
            if ($content -notmatch 'sandbox boundary|allowed change scope|discard conditions|promotion criteria') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口缺少沙盒邊界、允許改動、丟棄條件或升級條件' -Text $relPath
            }
            if ($content -notmatch '(?is)(sandbox writes?|沙盒寫入).{0,260}(production completion|production source completion|生產.*完成|不宣稱|不得宣稱)|production (completion|promotion|source/governance/public-contract write).{0,360}(scope-bound authorization|authorization resolution|formal-write|change-delivery|validation|review|memory/docs)') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口缺少 sandbox writes 不等於 production completion 與 promotion gate 語義' -Text $relPath
            }
            if ($content -match 'All quality, security, test, and memory gates are DISABLED|ALL quality, security, testing, and memory gates are \*\*DISABLED\*\*|No review gate|所有.*閘門.*停用|所有安全閘門已停用') {
                Add-ProgrammingTeamFinding -Severity 'Red' -File $relPath -Line 1 -Reason '實驗入口不得宣稱完全停用治理' -Text $relPath
            }
        }
    }

    $sharedSkillsRoot = Join-Path $RepoRoot 'Shared\skills'
    $targetSkillRoots = @(
        [PSCustomObject]@{ Label = 'agents skills'; Root = (Join-Path $TargetRoot '.agents\skills') },
        [PSCustomObject]@{ Label = 'claude skills'; Root = (Join-Path $TargetRoot '.claude\skills') }
    )
    foreach ($target in $targetSkillRoots) {
        if (-not (Test-Path -LiteralPath $target.Root -PathType Container)) { continue }
        Get-ChildItem -LiteralPath $sharedSkillsRoot -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $rel = $_.FullName.Substring($sharedSkillsRoot.Length).TrimStart('\', '/')
                Test-AuditSharedSkillRelativePathIncluded -RelativePath $rel
            } |
            ForEach-Object {
                $rel = $_.FullName.Substring($sharedSkillsRoot.Length).TrimStart('\', '/')
                $targetFile = Join-Path $target.Root $rel
                if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                    Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason "部署技能副本缺少來源檔 ($($target.Label))" -Text $rel
                } elseif (-not (Test-AuditFileHashEqual -SourcePath $_.FullName -TargetPath $targetFile)) {
                    Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason "部署技能副本內容漂移 ($($target.Label))" -Text $rel
                }
            }
    }

    $sharedRoot = Join-Path $RepoRoot 'Shared'
    $targetSharedRoot = Join-Path $TargetRoot '.agents\shared'
    if (Test-Path -LiteralPath $targetSharedRoot -PathType Container) {
        foreach ($rel in @(Get-AuditSharedGovernanceReferenceRelativePaths -SharedRoot $sharedRoot)) {
            $sourceFile = Join-Path $sharedRoot $rel
            $targetFile = Join-Path $targetSharedRoot $rel
            if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason '部署共用治理參照缺少來源檔' -Text $rel
            } elseif (-not (Test-AuditFileHashEqual -SourcePath $sourceFile -TargetPath $targetFile)) {
                Add-ProgrammingTeamFinding -Severity 'Yellow' -File (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $targetFile) -Line 1 -Reason '部署共用治理參照內容漂移' -Text $rel
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 編程團隊治理（Programming Team Governance）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line) {
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
