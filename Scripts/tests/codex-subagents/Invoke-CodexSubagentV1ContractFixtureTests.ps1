param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path,
    [string]$SuppliedSchemaJson
)

$ErrorActionPreference = 'Stop'

function Assert-Prerequisite {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Get-FileText {
    param([string]$Path)
    Assert-Prerequisite (Test-Path -LiteralPath $Path -PathType Leaf) "Missing contract file: $Path"
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Add-ByteParityIssue {
    param(
        [System.Collections.Generic.List[string]]$Issues,
        [string]$SourcePath,
        [string]$DeployedPath,
        [string]$Scope
    )

    Assert-Prerequisite (Test-Path -LiteralPath $SourcePath -PathType Leaf) "Missing source parity file: $SourcePath"
    Assert-Prerequisite (Test-Path -LiteralPath $DeployedPath -PathType Leaf) "Missing deployed parity file: $DeployedPath"
    $sourceBytes = [System.IO.File]::ReadAllBytes($SourcePath)
    $deployedBytes = [System.IO.File]::ReadAllBytes($DeployedPath)
    Add-ContractIssue -Issues $Issues -Condition ($sourceBytes.Length -eq $deployedBytes.Length -and [System.Linq.Enumerable]::SequenceEqual[byte]($sourceBytes, $deployedBytes)) -Message "$Scope source/deployed bytes must be identical"
}

function Get-MarkedBlock {
    param([string]$Text, [string]$StartMarker, [string]$EndMarker)
    $pattern = '(?s){0}(.*?){1}' -f [regex]::Escape($StartMarker), [regex]::Escape($EndMarker)
    $match = [regex]::Match($Text, $pattern)
    Assert-Prerequisite $match.Success "Missing marked block: $StartMarker"
    return $match.Value
}

function Add-ContractIssue {
    param([System.Collections.Generic.List[string]]$Issues, [bool]$Condition, [string]$Message)
    if (-not $Condition) { $Issues.Add($Message) }
}

function Add-ContainsIssue {
    param([System.Collections.Generic.List[string]]$Issues, [string]$Text, [string]$Needle, [string]$Scope)
    Add-ContractIssue -Issues $Issues -Condition $Text.Contains($Needle) -Message "$Scope must contain: $Needle"
}

function Get-GovernedRouteClauses {
    param([string]$Adapter)

    $sentenceMatch = [regex]::Match($Adapter, '(?m)^- The governed requested routes are exactly: (?<sentence>.+?`[^`]+`\.)')
    Assert-Prerequisite $sentenceMatch.Success 'Missing governed requested routes adapter sentence'

    $clauses = @($sentenceMatch.Groups['sentence'].Value -split ';' | ForEach-Object { $_.Trim() })
    $routes = foreach ($clause in $clauses) {
        $match = [regex]::Match($clause, '^(?:and\s+)?`(?<profile>[^`]+)`(?:\s+(?<qualifier>with .+?))?\s*→\s*`(?<model>[^`]+)`\s*/\s*`(?<effort>[^`]+)`\.?$')
        if ($match.Success) {
            [PSCustomObject]@{
                Profile = $match.Groups['profile'].Value
                Qualifier = $match.Groups['qualifier'].Value
                Model = $match.Groups['model'].Value
                Effort = $match.Groups['effort'].Value
            }
        }
        else {
            [PSCustomObject]@{ Profile = $null; Qualifier = $null; Model = $null; Effort = $null; ParseError = $clause }
        }
    }
    return @($routes)
}

function Test-SuppliedSchemaContract {
    param([string[]]$SuppliedSchemaKeys)

    $requiredKeys = @('agent_type', 'fork_context', 'items', 'model', 'reasoning_effort')
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($requiredKey in $requiredKeys) {
        if ($SuppliedSchemaKeys -notcontains $requiredKey) {
            $issues.Add("missing $requiredKey")
        }
    }
    if ($SuppliedSchemaKeys -contains 'prompt') {
        $issues.Add('prompt is not a V1 schema field')
    }

    [PSCustomObject]@{
        Valid = ($issues.Count -eq 0)
        Issues = @($issues)
    }
}

function Test-V1InvocationPayload {
    param([hashtable]$Payload)

    $hasItems = $Payload.ContainsKey('items')
    $hasMessage = $Payload.ContainsKey('message')
    [PSCustomObject]@{
        Valid = (($hasItems -xor $hasMessage) -and $Payload.ContainsKey('agent_type') -and
            $Payload.ContainsKey('model') -and $Payload.ContainsKey('reasoning_effort') -and
            $Payload.ContainsKey('fork_context') -and $Payload.fork_context -eq $false)
    }
}

function Resolve-GovernedRouteFixture {
    param(
        [object[]]$ParsedPolicyRoutes,
        [string]$RequestedProfile,
        [bool]$ReliableScopedAttemptFailure,
        [bool]$IrreversibleCriticalDecision,
        [string]$ResolvedEffort,
        [string]$RoleId,
        [bool]$RouteAvailable = $true
    )

    $excludedDefaults = @('low', 'high', 'luna-xhigh', 'terra-xhigh', 'max', 'ultra')
    if ([string]::IsNullOrWhiteSpace($RequestedProfile)) {
        return [PSCustomObject]@{ Status = 'draft/unverified'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'operator ambiguity' }
    }
    if ($excludedDefaults -contains $RequestedProfile.ToLowerInvariant()) {
        return [PSCustomObject]@{ Status = 'rejected'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'excluded governed default; this does not claim platform unsupported' }
    }
    if ($RequestedProfile -eq 'deep-xhigh') {
        return [PSCustomObject]@{ Status = 'rejected'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'deep-xhigh is not a governed profile' }
    }

    if ([string]::IsNullOrWhiteSpace($ResolvedEffort) -or $ResolvedEffort -notin @('medium', 'xhigh')) {
        return [PSCustomObject]@{ Status = 'draft/unverified'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'no substitution' }
    }
    $solXhighEligible = ($ReliableScopedAttemptFailure -or $IrreversibleCriticalDecision) -and $ResolvedEffort -eq 'xhigh'
    if ($ResolvedEffort -eq 'xhigh' -and ($RequestedProfile -ne 'deep' -or -not $solXhighEligible)) {
        return [PSCustomObject]@{ Status = 'draft/unverified'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'no substitution' }
    }

    $eligibleEffort = $ResolvedEffort
    $route = @($ParsedPolicyRoutes | Where-Object { $_.Profile -eq $RequestedProfile -and $_.Effort -eq $eligibleEffort })
    if ($route.Count -ne 1) {
        return [PSCustomObject]@{ Status = 'draft/unverified'; RequestedModel = $null; RequestedReasoningEffort = $null; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'unresolved profile' }
    }

    if (-not $RouteAvailable) {
        return [PSCustomObject]@{ Status = 'unavailable'; RequestedModel = $route[0].Model; RequestedReasoningEffort = $route[0].Effort; SelectedModel = $null; SelectedReasoningEffort = $null; Reason = 'preserve request and ask operator; no substitution' }
    }
    return [PSCustomObject]@{ Status = 'resolved'; RequestedModel = $route[0].Model; RequestedReasoningEffort = $route[0].Effort; SelectedModel = $route[0].Model; SelectedReasoningEffort = $route[0].Effort; Reason = 'profile resolution, not role identity' }
}

function Normalize-ParagraphWhitespace {
    param([string]$Text)

    return (($Text -replace "`r`n", "`n") -split "`n\s*`n" | ForEach-Object {
        (($_ -split "`n" | ForEach-Object { $_.Trim() }) -join ' ' -replace '[ \t]+', ' ').Trim()
    }) -join "`n`n"
}

function Get-MemberPrefixFromCodexMarker {
    param([string]$Adapter)

    $match = [regex]::Match($Adapter, '(?ms)^- The member prompt begins with exactly these three sentences, using the resolved role and station values:\s*^  ```text\r?\n(?<prefix>(?:  .*\r?\n){3})  ```')
    Assert-Prerequisite $match.Success 'Missing fenced member prompt prefix in Codex adapter'
    return (($match.Groups['prefix'].Value -replace "`r`n", "`n") -split "`n" | Where-Object { $_ -ne '' } | ForEach-Object {
        if ($_.StartsWith('  ')) { $_.Substring(2) } else { $_ }
    })
}

function Reconcile-V1ReceiptFixture {
    param([string]$RequestedModel, [string]$RequestedReasoningEffort, [hashtable]$Receipt)

    if ($null -eq $Receipt) {
        return [PSCustomObject]@{ RequestedModel = $RequestedModel; RequestedReasoningEffort = $RequestedReasoningEffort; AppliedModel = 'unreported'; AppliedReasoningEffort = 'unreported'; ApplicationState = 'unverified'; VarianceReason = 'platform receipt missing' }
    }
    return [PSCustomObject]@{ RequestedModel = $RequestedModel; RequestedReasoningEffort = $RequestedReasoningEffort; AppliedModel = $Receipt.applied_model; AppliedReasoningEffort = $Receipt.applied_reasoning_effort; ApplicationState = 'reported'; VarianceReason = 'receipt variance preserved' }
}

$sharedPolicyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'
$delegationSkillPath = Join-Path $RepoRoot 'Shared\skills\delegation-strategy\SKILL.md'
$watcherPath = Join-Path $RepoRoot 'Scripts\Watch-CodexModelV1.ps1'
$sharedPolicy = Get-FileText -Path $sharedPolicyPath
$delegationSkill = Get-FileText -Path $delegationSkillPath
$watcher = Get-FileText -Path $watcherPath
$adapter = Get-MarkedBlock -Text $sharedPolicy -StartMarker '<!-- SUBAGENT_POLICY:CODEX_START -->' -EndMarker '<!-- SUBAGENT_POLICY:CODEX_END -->'
$normalizedDelegationSkill = Normalize-ParagraphWhitespace -Text $delegationSkill
$issues = [System.Collections.Generic.List[string]]::new()

foreach ($required in @(
    'multi_agent_v1__spawn_agent', 'V1_NOT_AVAILABLE', 'do not substitute collaboration or V2',
    'role_id', 'Shared registry', 'agent_type', 'execution channel',
    'An unresolved role or station stops dispatch.', 'fork_context: false',
    'immutable `requested_execution_snapshot`', '`model` and `reasoning_effort`',
    'does not establish applied values', '`applied_model: unreported`',
    '`applied_reasoning_effort: unreported`', '`execution_profile_application_state: unverified`',
    '`platform receipt missing`'
)) {
    Add-ContainsIssue -Issues $issues -Text $adapter -Needle $required -Scope 'Codex V1 adapter'
}
Add-ContractIssue -Issues $issues -Condition (-not $adapter.Contains('Watch-CodexModelV1.ps1')) -Message 'Watch-CodexModelV1.ps1 must not appear in the Codex adapter capability declaration'

$expectedRoutes = @(
    'fast|gpt-5.6-luna|medium',
    'balanced|gpt-5.6-terra|medium',
    'deep|gpt-5.6-sol|medium',
    'deep|gpt-5.6-sol|xhigh'
)
$parsedRoutes = Get-GovernedRouteClauses -Adapter $adapter
$actualRoutes = @($parsedRoutes | ForEach-Object { '{0}|{1}|{2}' -f $_.Profile, $_.Model, $_.Effort })
Add-ContractIssue -Issues $issues -Condition (-not ($parsedRoutes | Where-Object { $_.PSObject.Properties.Name -contains 'ParseError' })) -Message 'Governed route adapter sentence contains an unparseable clause'
Add-ContractIssue -Issues $issues -Condition ($actualRoutes.Count -eq 4) -Message 'Actual Codex adapter must declare exactly four governed routes'
Add-ContractIssue -Issues $issues -Condition ((Compare-Object -ReferenceObject $expectedRoutes -DifferenceObject $actualRoutes).Count -eq 0) -Message 'Actual Codex adapter governed route map differs from the expected exact four routes'
$solXhighRoutes = @($parsedRoutes | Where-Object { $_.Profile -eq 'deep' -and $_.Model -eq 'gpt-5.6-sol' -and $_.Effort -eq 'xhigh' })
Add-ContractIssue -Issues $issues -Condition ($solXhighRoutes.Count -eq 1 -and -not [string]::IsNullOrWhiteSpace($solXhighRoutes[0].Qualifier) -and $solXhighRoutes[0].Qualifier -match 'both \(a\)' -and $solXhighRoutes[0].Qualifier -match 'reliable scoped attempt failure' -and $solXhighRoutes[0].Qualifier -match 'or an irreversible critical decision' -and $solXhighRoutes[0].Qualifier -match 'and \(b\)' -and $solXhighRoutes[0].Qualifier -match 'explicitly resolved requested effort `xhigh`') -Message 'Sol-xhigh must require (failure OR irreversible decision) AND explicitly resolved xhigh effort'
Add-ContractIssue -Issues $issues -Condition (@($parsedRoutes | Where-Object { $_.Effort -eq 'xhigh' -and $_.Profile -ne 'deep' }).Count -eq 0) -Message 'Only deep may declare an xhigh governed route'

foreach ($excludedDefault in @('`low`', '`high`', 'Luna-`xhigh`', 'Terra-`xhigh`', '`max`', '`ultra`')) {
    Add-ContainsIssue -Issues $issues -Text $adapter -Needle $excludedDefault -Scope 'Excluded governed defaults'
}
Add-ContainsIssue -Issues $issues -Text $adapter -Needle 'does not claim that the platform rejects them' -Scope 'Excluded governed defaults'
Add-ContainsIssue -Issues $issues -Text $adapter -Needle 'If a requested route is unavailable, preserve the request and ask the operator; do not silently substitute.' -Scope 'Unavailable requested route'
Add-ContainsIssue -Issues $issues -Text $normalizedDelegationSkill -Needle 'role or station may recommend a profile, but task evidence, explicit requirements, and operator answers may override that recommendation. A role or station never binds a model.' -Scope 'Delegation profile owner'
Add-ContainsIssue -Issues $issues -Text $normalizedDelegationSkill -Needle 'If the profile or requested effort remains ambiguous, ask at most two targeted operator questions. Until resolved, the execution spec is `draft` / `unverified`; do not invent a sentinel value.' -Scope 'Delegation profile owner'

# Static source inspection only: this fixture never invokes the watcher or a user models cache.
$watcherStaticCases = @(
    @{ Name = 'experimental non-platform boundary'; Condition = $watcher.Contains('# Local experimental workaround only; not a formal Codex adapter capability and not a platform guarantee.') },
    @{ Name = 'precise v2 pattern'; Condition = $watcher.Contains('$pattern = ''(?<prefix>"multi_agent_version"\s*:\s*)"v2"''') },
    @{ Name = 'regex matches and replace'; Condition = $watcher.Contains('$matches = [regex]::Matches($text, $pattern)') -and $watcher.Contains('$updated = [regex]::Replace($text, $pattern, ''${prefix}"v1"'')') },
    @{ Name = 'match count result without exact-one guard'; Condition = $watcher.Contains('return $matches.Count') -and -not $watcher.Contains('exactly one validated cache byte offset is required') -and -not $watcher.Contains('$actualChangedOffsets.Count -ne 1') }
)
foreach ($case in $watcherStaticCases) {
    Add-ContractIssue -Issues $issues -Condition $case.Condition -Message "Watcher static contract case failed: $($case.Name)"
}

$watcherPattern = '(?<prefix>"multi_agent_version"\s*:\s*)"v2"'
$watcherReplacement = '${prefix}"v1"'
$twoMatchSample = '{"multi_agent_version":"v2","nested":{"multi_agent_version" : "v2"}}'
$twoMatchUpdated = [regex]::Replace($twoMatchSample, $watcherPattern, $watcherReplacement)
Add-ContractIssue -Issues $issues -Condition (([regex]::Matches($twoMatchSample, $watcherPattern).Count -eq 2) -and ([regex]::Matches($twoMatchUpdated, $watcherPattern).Count -eq 0) -and ([regex]::Matches($twoMatchUpdated, '(?<prefix>"multi_agent_version"\s*:\s*)"v1"').Count -eq 2)) -Message 'Watcher in-memory multi-match fixture must replace two exact v2 values with v1 values'
$zeroMatchSample = '{"multi_agent_version":"v1"}'
Add-ContractIssue -Issues $issues -Condition ([string]::Equals([regex]::Replace($zeroMatchSample, $watcherPattern, $watcherReplacement), $zeroMatchSample, [System.StringComparison]::Ordinal)) -Message 'Watcher in-memory zero-match fixture must remain unchanged'
$watcherContractCaseCount = $watcherStaticCases.Count + 2

$schemaNegativeCases = @(
    @{ Name = 'missing agent_type'; Keys = @('fork_context', 'items', 'model', 'reasoning_effort') },
    @{ Name = 'missing fork_context'; Keys = @('agent_type', 'items', 'model', 'reasoning_effort') },
    @{ Name = 'missing items'; Keys = @('agent_type', 'fork_context', 'model', 'reasoning_effort') },
    @{ Name = 'missing model'; Keys = @('agent_type', 'fork_context', 'items', 'reasoning_effort') },
    @{ Name = 'missing reasoning_effort'; Keys = @('agent_type', 'fork_context', 'items', 'model') },
    @{ Name = 'prompt replacing items'; Keys = @('agent_type', 'fork_context', 'prompt', 'model', 'reasoning_effort') }
)
foreach ($case in $schemaNegativeCases) {
    Add-ContractIssue -Issues $issues -Condition (-not (Test-SuppliedSchemaContract -SuppliedSchemaKeys $case.Keys).Valid) -Message "Supplied schema negative case must be rejected: $($case.Name)"
}

$payloadBase = @{ agent_type = 'channel'; fork_context = $false; model = 'gpt-5.6-terra'; reasoning_effort = 'medium' }
$payloadCases = @(
    @{ Name = 'items only valid'; Payload = $payloadBase + @{ items = @('message') }; Valid = $true },
    @{ Name = 'message only valid'; Payload = $payloadBase + @{ message = 'message' }; Valid = $true },
    @{ Name = 'both invalid'; Payload = $payloadBase + @{ items = @('message'); message = 'message' }; Valid = $false },
    @{ Name = 'neither invalid'; Payload = $payloadBase; Valid = $false },
    @{ Name = 'fork_context true invalid'; Payload = @{ agent_type = 'channel'; fork_context = $true; model = 'gpt-5.6-terra'; reasoning_effort = 'medium'; items = @('message') }; Valid = $false }
)
foreach ($case in $payloadCases) {
    Add-ContractIssue -Issues $issues -Condition ((Test-V1InvocationPayload -Payload $case.Payload).Valid -eq $case.Valid) -Message "Invocation payload case failed: $($case.Name)"
}

$routeBase = @{ ParsedPolicyRoutes = $parsedRoutes; RoleId = 'change-delivery'; RouteAvailable = $true }
$routePositiveCases = @(
    @{ Name = 'fast'; Args = $routeBase + @{ RequestedProfile = 'fast'; ResolvedEffort = 'medium' }; Model = 'gpt-5.6-luna'; Effort = 'medium' },
    @{ Name = 'balanced'; Args = $routeBase + @{ RequestedProfile = 'balanced'; ResolvedEffort = 'medium' }; Model = 'gpt-5.6-terra'; Effort = 'medium' },
    @{ Name = 'deep medium'; Args = $routeBase + @{ RequestedProfile = 'deep'; ResolvedEffort = 'medium' }; Model = 'gpt-5.6-sol'; Effort = 'medium' },
    @{ Name = 'qualified deep xhigh by reliable failure'; Args = $routeBase + @{ RequestedProfile = 'deep'; ReliableScopedAttemptFailure = $true; ResolvedEffort = 'xhigh' }; Model = 'gpt-5.6-sol'; Effort = 'xhigh' },
    @{ Name = 'qualified deep xhigh by irreversible decision'; Args = $routeBase + @{ RequestedProfile = 'deep'; IrreversibleCriticalDecision = $true; ResolvedEffort = 'xhigh' }; Model = 'gpt-5.6-sol'; Effort = 'xhigh' }
)
foreach ($case in $routePositiveCases) {
    $routeArguments = $case.Args
    $result = Resolve-GovernedRouteFixture @routeArguments
    Add-ContractIssue -Issues $issues -Condition ($result.Status -eq 'resolved' -and $result.RequestedModel -eq $case.Model -and $result.RequestedReasoningEffort -eq $case.Effort -and $result.SelectedModel -eq $case.Model -and $result.SelectedReasoningEffort -eq $case.Effort) -Message "Route positive case failed: $($case.Name)"
}

$unavailableRouteBase = $routeBase.Clone()
$unavailableRouteBase['RouteAvailable'] = $false
$routeFailureCases = @(
    @{ Name = 'operator ambiguity'; Args = $routeBase + @{ RequestedProfile = ''; ResolvedEffort = '' }; Status = 'draft/unverified'; Model = $null; Effort = $null },
    @{ Name = 'excluded low default'; Args = $routeBase + @{ RequestedProfile = 'low'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'excluded high default'; Args = $routeBase + @{ RequestedProfile = 'high'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'excluded Luna-xhigh default'; Args = $routeBase + @{ RequestedProfile = 'luna-xhigh'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'excluded Terra-xhigh default'; Args = $routeBase + @{ RequestedProfile = 'terra-xhigh'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'excluded max default'; Args = $routeBase + @{ RequestedProfile = 'max'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'excluded ultra default'; Args = $routeBase + @{ RequestedProfile = 'ultra'; ResolvedEffort = 'medium' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'deep-xhigh pseudo-profile invalid'; Args = $routeBase + @{ RequestedProfile = 'deep-xhigh'; ReliableScopedAttemptFailure = $true; ResolvedEffort = 'xhigh' }; Status = 'rejected'; Model = $null; Effort = $null },
    @{ Name = 'fast xhigh is not substituted'; Args = $routeBase + @{ RequestedProfile = 'fast'; ReliableScopedAttemptFailure = $true; ResolvedEffort = 'xhigh' }; Status = 'draft/unverified'; Model = $null; Effort = $null; Reason = 'no substitution' },
    @{ Name = 'balanced xhigh is not substituted'; Args = $routeBase + @{ RequestedProfile = 'balanced'; IrreversibleCriticalDecision = $true; ResolvedEffort = 'xhigh' }; Status = 'draft/unverified'; Model = $null; Effort = $null; Reason = 'no substitution' },
    @{ Name = 'deep no condition xhigh is not substituted'; Args = $routeBase + @{ RequestedProfile = 'deep'; ResolvedEffort = 'xhigh' }; Status = 'draft/unverified'; Model = $null; Effort = $null; Reason = 'no substitution' },
    @{ Name = 'deep reliable failure blank effort is not substituted'; Args = $routeBase + @{ RequestedProfile = 'deep'; ReliableScopedAttemptFailure = $true; ResolvedEffort = '' }; Status = 'draft/unverified'; Model = $null; Effort = $null; Reason = 'no substitution' },
    @{ Name = 'deep irreversible decision unknown effort is not substituted'; Args = $routeBase + @{ RequestedProfile = 'deep'; IrreversibleCriticalDecision = $true; ResolvedEffort = 'unknown' }; Status = 'draft/unverified'; Model = $null; Effort = $null; Reason = 'no substitution' },
    @{ Name = 'unavailable route'; Args = $unavailableRouteBase + @{ RequestedProfile = 'balanced'; ResolvedEffort = 'medium' }; Status = 'unavailable'; Model = 'gpt-5.6-terra'; Effort = 'medium' }
)
foreach ($case in $routeFailureCases) {
    $routeArguments = $case.Args
    $result = Resolve-GovernedRouteFixture @routeArguments
    $reasonMatches = -not $case.ContainsKey('Reason') -or $result.Reason -eq $case.Reason
    Add-ContractIssue -Issues $issues -Condition ($result.Status -eq $case.Status -and $result.RequestedModel -eq $case.Model -and $result.RequestedReasoningEffort -eq $case.Effort -and $reasonMatches) -Message "Route failure case failed: $($case.Name)"
}

$noReceipt = Reconcile-V1ReceiptFixture -RequestedModel 'gpt-5.6-terra' -RequestedReasoningEffort 'medium' -Receipt $null
Add-ContractIssue -Issues $issues -Condition ($noReceipt.AppliedModel -eq 'unreported' -and $noReceipt.AppliedReasoningEffort -eq 'unreported' -and $noReceipt.ApplicationState -eq 'unverified' -and $noReceipt.VarianceReason -eq 'platform receipt missing') -Message 'Accepted request without receipt must remain unreported and unverified'
$varianceReceipt = Reconcile-V1ReceiptFixture -RequestedModel 'gpt-5.6-terra' -RequestedReasoningEffort 'medium' -Receipt @{ applied_model = 'gpt-5.6-sol'; applied_reasoning_effort = 'xhigh' }
Add-ContractIssue -Issues $issues -Condition ($varianceReceipt.RequestedModel -eq 'gpt-5.6-terra' -and $varianceReceipt.AppliedModel -eq 'gpt-5.6-sol' -and $varianceReceipt.RequestedReasoningEffort -eq 'medium' -and $varianceReceipt.AppliedReasoningEffort -eq 'xhigh') -Message 'Receipt variance must preserve requested and applied values'

$expectedPromptPrefix = @(
    '你是 {formal_station} 站點的 {role_id} 隊員，不是隊長。',
    '主線已完成派工；隊長專屬限制不會阻止你執行本次已授權的工作。',
    '只做指定任務，遵守範圍與禁令，交付指定成果後停止。'
)
$actualPromptPrefix = @(Get-MemberPrefixFromCodexMarker -Adapter $adapter)
Add-ContractIssue -Issues $issues -Condition ($actualPromptPrefix.Count -eq 3 -and [string]::Equals(($actualPromptPrefix -join "`n"), ($expectedPromptPrefix -join "`n"), [System.StringComparison]::Ordinal)) -Message 'Member prompt first three fenced lines must match the policy ordinally'
Add-ContainsIssue -Issues $issues -Text $adapter -Needle 'The prompt then states the allowlist, forbidden actions, and artifact stop condition.' -Scope 'Member prompt continuation'
Add-ContainsIssue -Issues $issues -Text $adapter -Needle 'An unresolved role or station stops dispatch.' -Scope 'Unresolved identity stop'

Add-ByteParityIssue -Issues $issues -SourcePath $sharedPolicyPath -DeployedPath (Join-Path $RepoRoot '.agents\shared\policies\subagent-invocation.md') -Scope 'Shared subagent policy'
Add-ByteParityIssue -Issues $issues -SourcePath (Join-Path $RepoRoot 'Codex\.codex\AGENTS.md') -DeployedPath (Join-Path $RepoRoot '.codex\AGENTS.md') -Scope 'Codex generated core'
Add-ByteParityIssue -Issues $issues -SourcePath $delegationSkillPath -DeployedPath (Join-Path $RepoRoot '.agents\skills\delegation-strategy\SKILL.md') -Scope 'Delegation strategy skill'

if ($PSBoundParameters.ContainsKey('SuppliedSchemaJson')) {
    try {
        $suppliedSchema = $SuppliedSchemaJson | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw "SuppliedSchemaJson must be a JSON object containing supplied schema keys: $($_.Exception.Message)"
    }
    Assert-Prerequisite ($suppliedSchema -is [PSCustomObject]) 'SuppliedSchemaJson must be a JSON object containing supplied schema keys'
    $suppliedResult = Test-SuppliedSchemaContract -SuppliedSchemaKeys @($suppliedSchema.PSObject.Properties.Name)
    Add-ContractIssue -Issues $issues -Condition $suppliedResult.Valid -Message ("Supplied schema failed V1 contract: {0}" -f ($suppliedResult.Issues -join '; '))
}

$executedCaseCount = $schemaNegativeCases.Count + $payloadCases.Count + $routePositiveCases.Count + $routeFailureCases.Count + $watcherContractCaseCount
if ($issues.Count -gt 0) {
    throw ("Codex V1 adapter contract fixture failures ({0} issues; {1} executed contract cases): {2}" -f $issues.Count, $executedCaseCount, ($issues -join '; '))
}

Write-Host ('Codex V1 adapter contract fixtures passed: {0} governed routes; {1} executed contract cases, including {2} watcher contract cases. Contract tests only validate adapter/source contracts, never execute the watcher or a user models cache, and do not prove runtime/model quality or applied values; no platform receipt means applied remains unverified.' -f $expectedRoutes.Count, $executedCaseCount, $watcherContractCaseCount)
