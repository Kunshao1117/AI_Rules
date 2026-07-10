#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
    [string]$FixturesRoot = (Join-Path $PSScriptRoot "workflow-eight-stage\fixtures")
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$script:RepoRootFull = [IO.Path]::GetFullPath($RepoRoot).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)
$script:Results = New-Object System.Collections.Generic.List[object]

function Get-RepoPath {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    return Join-Path $script:RepoRootFull $RelativePath
}

function Get-RelativeDisplayPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $script:RepoRootFull + [IO.Path]::DirectorySeparatorChar
    if ($full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($prefix.Length).Replace('\', '/')
    }

    return $full.Replace('\', '/')
}

function Read-TextFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing file: $(Get-RelativeDisplayPath -Path $Path)"
    }

    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Get-NormalizedText {
    param([Parameter(Mandatory = $true)][string]$Text)

    $withoutBom = $Text.TrimStart([char]0xFEFF).Replace([string][char]13, '')
    $normalizedLines = @($withoutBom.Split([char]10) | ForEach-Object { $_.TrimEnd() })
    return (($normalizedLines -join [string][char]10).TrimEnd([char]10))
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    $text = Read-TextFile -Path $Path
    try {
        return $text | ConvertFrom-Json -ErrorAction Stop
    } catch {
        throw "Invalid JSON in $(Get-RelativeDisplayPath -Path $Path): $($_.Exception.Message)"
    }
}

function Test-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)][object]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    return $Object.PSObject.Properties.Match($Name).Count -gt 0
}

function Assert-True {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Assert-TextContainsLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ($Text.IndexOf($Needle, [StringComparison]::Ordinal) -lt 0) {
        throw "Missing sentinel '$Label' in $Scope"
    }
}

function Assert-TextNotContainsLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ($Text.IndexOf($Needle, [StringComparison]::Ordinal) -ge 0) {
        throw "Forbidden sentinel '$Label' found in $Scope"
    }
}

function Assert-TextNotContainsRegex {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Pattern,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ([regex]::IsMatch($Text, $Pattern)) {
        throw "Forbidden pattern '$Label' found in $Scope"
    }
}

function Assert-WorkflowEntryDoesNotCloneMainline {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Scope
    )

    Assert-TextNotContainsRegex -Text $Text -Pattern '(?im)^##\s+Entry Sequence\s*$' -Scope $Scope -Label "copied mainline section"
    $ownershipLines = [regex]::Matches($Text, '(?im)^[^\r\n]*(?:owns?|defines?)[^\r\n]*$')
    foreach ($ownershipLine in $ownershipLines) {
        $line = $ownershipLine.Value
        $isNegated = [regex]::IsMatch($line, '(?i)\b(?:does|do|must|shall|may|can)\s+not\s+(?:own|define)\b')
        $claimsOwnership = [regex]::IsMatch($line, '(?i)\b(?:owns?|defines?)\b.*\b(?:route|stage|lifecycle)\s+order\b.*\bresponsibility\s+handoff\b')
        if ($claimsOwnership -and -not $isNegated) {
            throw "Mainline responsibility ownership clone found in $Scope"
        }
    }

    $mainlineAnchors = @(
        'workflow route',
        'intent envelope',
        'overreach check',
        'external grounding trigger',
        'design reflection gate',
        'authorization resolution',
        'delivery artifact',
        'memory/docs attribution',
        'completion judgment'
    )
    $fullTextAnchorCount = 0
    foreach ($anchor in $mainlineAnchors) {
        if ($Text.IndexOf($anchor, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
            $fullTextAnchorCount++
        }
    }
    if ($fullTextAnchorCount -ge 7) {
        throw "Mainline anchor-density clone found in $Scope"
    }

    $arrowFlows = [regex]::Matches($Text, '(?m)^(?<Flow>[^\r\n]*\r?\n(?:[ \t]*->[^\r\n]*(?:\r?\n|$)){2,})')
    foreach ($arrowFlow in $arrowFlows) {
        $anchorCount = 0
        foreach ($anchor in $mainlineAnchors) {
            if ($arrowFlow.Groups['Flow'].Value.IndexOf($anchor, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
                $anchorCount++
            }
        }
        if ($anchorCount -ge 3) {
            throw "Structural mainline clone found in $Scope"
        }
    }
}

function Get-MarkdownSectionText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Heading
    )

    $escapedHeading = [regex]::Escape($Heading)
    $matches = [regex]::Matches($Text, "(?ms)^##\s+$escapedHeading\s*\r?\n(?<Body>.*?)(?=^##\s+|\z)")
    if ($matches.Count -ne 1) { return $null }
    return $matches[0].Groups['Body'].Value
}

function Invoke-Check {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$ScriptBlock
    )

    Write-Host "[RUN ] $Name"
    try {
        & $ScriptBlock
        $script:Results.Add([PSCustomObject]@{
            Name = $Name
            Passed = $true
            Error = $null
        }) | Out-Null
        Write-Host "[PASS] $Name"
    } catch {
        $script:Results.Add([PSCustomObject]@{
            Name = $Name
            Passed = $false
            Error = $_.Exception.Message
        }) | Out-Null
        Write-Host "[FAIL] $Name"
        Write-Host "       $($_.Exception.Message)"
    }
}

function Get-WorkflowEntryFiles {
    $entryFiles = New-Object System.Collections.Generic.List[string]
    foreach ($rootRelative in @("Shared\skills", ".agents\skills")) {
        $root = Get-RepoPath -RelativePath $rootRelative
        if (-not (Test-Path -LiteralPath $root -PathType Container)) {
            continue
        }

        foreach ($directory in Get-ChildItem -LiteralPath $root -Directory -ErrorAction Stop) {
            if ($directory.Name -notmatch '^\d{2}(?:-|$)') {
                continue
            }

            $skillPath = Join-Path $directory.FullName "SKILL.md"
            if (Test-Path -LiteralPath $skillPath -PathType Leaf) {
                $entryFiles.Add($skillPath) | Out-Null
            }
        }
    }

    return $entryFiles.ToArray() | Sort-Object
}

function Test-MainlineAnchorOwnership {
    $sourcePath = Get-RepoPath -RelativePath "Shared\policies\workflow-orchestration.md"
    $runtimePath = Get-RepoPath -RelativePath ".agents\shared\policies\workflow-orchestration.md"
    $sourceText = Read-TextFile -Path $sourcePath
    $runtimeText = Read-TextFile -Path $runtimePath

    foreach ($scope in @(
        [PSCustomObject]@{ Path = $sourcePath; Text = $sourceText },
        [PSCustomObject]@{ Path = $runtimePath; Text = $runtimeText }
    )) {
        $display = Get-RelativeDisplayPath -Path $scope.Path
        Assert-TextContainsLiteral -Text $scope.Text -Needle "## Team-Native Topology Map" -Scope $display -Label "topology map anchor"
        Assert-TextContainsLiteral -Text $scope.Text -Needle "Canonical stage order:" -Scope $display -Label "canonical stage order"
        Assert-TextContainsLiteral -Text $scope.Text -Needle "This sequence is the only mainline a workflow entry may invoke." -Scope $display -Label "only mainline"
        Assert-TextContainsLiteral -Text $scope.Text -Needle "Stage 1 unique mainline" -Scope $display -Label "stage 1 unique mainline"
    }

    $entryFiles = @(Get-WorkflowEntryFiles)
    Assert-True -Condition ($entryFiles.Count -gt 0) -Message "No workflow entry SKILL.md files were found."

    foreach ($path in $entryFiles) {
        $text = Read-TextFile -Path $path
        $display = Get-RelativeDisplayPath -Path $path
        Assert-TextNotContainsLiteral -Text $text -Needle "Canonical stage order:" -Scope $display -Label "copied canonical stage order"
        Assert-TextNotContainsLiteral -Text $text -Needle "This sequence is the only mainline a workflow entry may invoke." -Scope $display -Label "copied only-mainline rule"
        Assert-TextNotContainsLiteral -Text $text -Needle "Stage 1 unique mainline" -Scope $display -Label "copied unique-mainline anchor"
        Assert-WorkflowEntryDoesNotCloneMainline -Text $text -Scope $display
    }

    $negativeOwnership = 'This entry does not own route order and responsibility handoff.'
    Assert-WorkflowEntryDoesNotCloneMainline -Text $negativeOwnership -Scope "negative ownership counterexample"

    $bulletClone = @'
## Workflow Responsibilities
- workflow route
- intent envelope
- overreach check
- external grounding trigger
- design reflection gate
- authorization resolution
- delivery artifact
'@
    $bulletCloneRejected = $false
    try {
        Assert-WorkflowEntryDoesNotCloneMainline -Text $bulletClone -Scope "seven-anchor bullet counterexample"
    } catch {
        $bulletCloneRejected = $true
    }
    Assert-True -Condition $bulletCloneRejected -Message "Seven-anchor bullet-list mainline clone was not rejected."

    Write-Host ("Checked {0} workflow entry file(s)." -f $entryFiles.Count)
}

function Test-Stage2WorkflowEntryReferences {
    $orchestrationPath = Get-RepoPath -RelativePath "Shared\policies\workflow-orchestration.md"
    $procedurePath = Get-RepoPath -RelativePath "Shared\workflow-stage-procedures.md"
    $matrixPath = Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md"
    $executionSpecPath = Get-RepoPath -RelativePath "Shared\policies\references\workflow-execution-spec-contract.md"
    $orchestrationText = Read-TextFile -Path $orchestrationPath
    $procedureText = Read-TextFile -Path $procedurePath
    $matrixText = Read-TextFile -Path $matrixPath
    $executionSpecText = Read-TextFile -Path $executionSpecPath

    Assert-TextContainsLiteral -Text $orchestrationText -Needle "Workflow entries are thin route selectors." -Scope "workflow-orchestration.md" -Label "thin workflow entries"
    Assert-TextContainsLiteral -Text $orchestrationText -Needle "They name the workflow row, stage-procedure reference," -Scope "workflow-orchestration.md" -Label "workflow row and procedure references"
    Assert-TextContainsLiteral -Text $orchestrationText -Needle "evidence-matrix row, and executable input they require" -Scope "workflow-orchestration.md" -Label "matrix row and executable input references"
    Assert-TextContainsLiteral -Text $procedureText -Needle "Stage 2 workflow entry:" -Scope "workflow-stage-procedures.md" -Label "Stage 2 procedure anchor"
    Assert-TextContainsLiteral -Text $procedureText -Needle 'workflow evidence matrix row, and any required `execution_spec` or handoff input.' -Scope "workflow-stage-procedures.md" -Label "Stage 2 executable input"
    Assert-TextContainsLiteral -Text $matrixText -Needle "| 2. Workflow entry |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 2 matrix row"
    Assert-TextContainsLiteral -Text $matrixText -Needle "route text is not authorization" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 2 route boundary"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`workflow_entry_ref`' -Scope "workflow-execution-spec-contract.md" -Label "workflow entry field"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`stage_procedure_ref`' -Scope "workflow-execution-spec-contract.md" -Label "stage procedure field"

    $entryFiles = @(Get-WorkflowEntryFiles)
    Assert-True -Condition ($entryFiles.Count -eq 17) -Message ("Expected 17 workflow entries, found {0}." -f $entryFiles.Count)
    foreach ($path in $entryFiles) {
        $text = Read-TextFile -Path $path
        $display = Get-RelativeDisplayPath -Path $path
        Assert-TextContainsLiteral -Text $text -Needle '.agents/shared/workflow-stage-procedures.md' -Scope $display -Label "stage procedure reference"
        Assert-TextContainsLiteral -Text $text -Needle '.agents/shared/workflow-capability-evidence-matrix.md' -Scope $display -Label "evidence matrix reference"
        Assert-TextContainsLiteral -Text $text -Needle 'Procedure reference:' -Scope $display -Label "workflow procedure section"
        Assert-TextContainsLiteral -Text $text -Needle 'Workflow row:' -Scope $display -Label "workflow row"

        $hasExecutionSpec = $text.IndexOf('`execution_spec`', [StringComparison]::Ordinal) -ge 0
        $hasHandoffInput = [regex]::IsMatch($text, '(?is)Team-Native details:.{0,1000}opened stations.{0,500}\bhandoff\b')
        Assert-True -Condition ($hasExecutionSpec -or $hasHandoffInput) -Message "Missing execution_spec or opened-station handoff input in $display"
    }

    Write-Host ("Checked {0} workflow entry contract(s)." -f $entryFiles.Count)
}

function Test-Stage3ExecutionSpec {
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $executionSpecText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\policies\references\workflow-execution-spec-contract.md")

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 3. Execution spec |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 3 matrix row"
    Assert-TextContainsLiteral -Text $matrixText -Needle "or a blocked/unverified reason" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 3 unresolved state"
    foreach ($field in @(
        'execution_spec_state',
        'lane_id',
        'stage_disposition',
        'intent_envelope',
        'allowed_targets',
        'authorization_scope',
        'station_id',
        'stop_condition'
    )) {
        Assert-TextContainsLiteral -Text $executionSpecText -Needle ("``{0}``" -f $field) -Scope "workflow-execution-spec-contract.md" -Label ("Stage 3 field {0}" -f $field)
    }
}

function Test-Stage4StationHandoff {
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $executionSpecText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\policies\references\workflow-execution-spec-contract.md")
    $boardText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\skills\team-task-board\SKILL.md")

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 4. Station handoff |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 4 matrix row"
    foreach ($field in @(
        'role_id',
        'role_instance_id',
        'assigned_specialist_skill',
        'station_mode',
        'context_visibility',
        'handoff_ownership',
        'allowed_targets'
    )) {
        Assert-TextContainsLiteral -Text $executionSpecText -Needle ("``{0}``" -f $field) -Scope "workflow-execution-spec-contract.md" -Label ("Stage 4 field {0}" -f $field)
    }
    Assert-TextContainsLiteral -Text $boardText -Needle '`station_mode`, `context_visibility`, and `handoff_ownership` are mandatory' -Scope "team-task-board/SKILL.md" -Label "mandatory station handoff fields"
}

function Assert-HashPairEqual {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRelativePath,
        [Parameter(Mandatory = $true)][string]$RuntimeRelativePath
    )

    $sourcePath = Get-RepoPath -RelativePath $SourceRelativePath
    $runtimePath = Get-RepoPath -RelativePath $RuntimeRelativePath
    Assert-True -Condition (Test-Path -LiteralPath $sourcePath -PathType Leaf) -Message "Missing source file: $SourceRelativePath"
    Assert-True -Condition (Test-Path -LiteralPath $runtimePath -PathType Leaf) -Message "Missing runtime file: $RuntimeRelativePath"

    $sourceHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
    $runtimeHash = (Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash
    if ($sourceHash -ne $runtimeHash) {
        throw "Hash mismatch: $SourceRelativePath ($sourceHash) != $RuntimeRelativePath ($runtimeHash)"
    }
}

function Test-SourceRuntimeHashPairs {
    $pairs = @(
        @("Shared\policies\workflow-orchestration.md", ".agents\shared\policies\workflow-orchestration.md"),
        @("Shared\policies\language-governance.md", ".agents\shared\policies\language-governance.md"),
        @("Shared\skills\team-completion-gate\SKILL.md", ".agents\skills\team-completion-gate\SKILL.md"),
        @("Shared\skills\team-task-board\SKILL.md", ".agents\skills\team-task-board\SKILL.md"),
        @("Shared\skills\team-task-board\references\board-field-catalog.md", ".agents\skills\team-task-board\references\board-field-catalog.md"),
        @("Shared\skills\team-station-handoff-packet\SKILL.md", ".agents\skills\team-station-handoff-packet\SKILL.md"),
        @("Shared\skills\delegation-strategy\SKILL.md", ".agents\skills\delegation-strategy\SKILL.md"),
        @("Shared\policies\references\completion-state-machine.md", ".agents\shared\policies\references\completion-state-machine.md"),
        @("Shared\policies\references\workflow-execution-spec-contract.md", ".agents\shared\policies\references\workflow-execution-spec-contract.md"),
        @("Shared\policies\references\workflow-memory-evidence.md", ".agents\shared\policies\references\workflow-memory-evidence.md"),
        @("Shared\skill-governance.md", ".agents\shared\skill-governance.md"),
        @("Shared\workflow-capability-evidence-matrix.md", ".agents\shared\workflow-capability-evidence-matrix.md"),
        @("Shared\workflow-stage-procedures.md", ".agents\shared\workflow-stage-procedures.md")
    )

    foreach ($pair in $pairs) {
        Assert-HashPairEqual -SourceRelativePath $pair[0] -RuntimeRelativePath $pair[1]
    }

    Write-Host ("Verified {0} source/runtime hash pair(s)." -f $pairs.Count)
}

function Test-CodexCoreNormalizedParity {
    $sourceRelative = 'Codex\.codex\AGENTS.md'
    $runtimeRelative = '.codex\AGENTS.md'
    $sourcePath = Get-RepoPath -RelativePath $sourceRelative
    $runtimePath = Get-RepoPath -RelativePath $runtimeRelative
    $sourceText = Get-NormalizedText -Text (Read-TextFile -Path $sourcePath)
    $runtimeText = Get-NormalizedText -Text (Read-TextFile -Path $runtimePath)

    Assert-True -Condition ($sourceText -ceq $runtimeText) -Message "Normalized content mismatch: $sourceRelative != $runtimeRelative"
    Write-Host 'Verified normalized Codex core content parity.'
}

function Get-Fixture {
    param([Parameter(Mandatory = $true)][string]$FileName)

    return Read-JsonFile -Path (Join-Path $FixturesRoot $FileName)
}

function Get-NestedValue {
    param(
        [Parameter(Mandatory = $true)][object]$Object,
        [Parameter(Mandatory = $true)][string[]]$Path,
        [AllowNull()][object]$Default = $null
    )

    $current = $Object
    foreach ($segment in $Path) {
        if ($null -eq $current -or -not (Test-ObjectProperty -Object $current -Name $segment)) {
            return $Default
        }
        $current = $current.PSObject.Properties[$segment].Value
    }

    return $current
}

function Test-FixtureMemoryReadyForComplete {
    param([Parameter(Mandatory = $true)][object]$Fixture)

    $artifactChain = Get-NestedValue -Object $Fixture -Path @('artifact_chain') -Default $null
    if ($null -eq $artifactChain -or -not (Test-ObjectProperty -Object $artifactChain -Name 'memory_docs')) {
        return $false
    }

    $disposition = [string]$artifactChain.memory_docs
    # The canonical references do not define protected-result field names, so required memory stays fail-closed.
    return @('memory-not-required', 'memory-attributed-no-write') -contains $disposition
}

function Test-FixtureSourceDeployedPairReady {
    param(
        [Parameter(Mandatory = $true)][object]$Fixture,
        [bool]$RequirePair = $false
    )

    if (-not (Test-ObjectProperty -Object $Fixture -Name 'source_deployed_pair')) {
        return -not $RequirePair
    }

    $sourceDeployedPair = $Fixture.source_deployed_pair
    $artifactChain = Get-NestedValue -Object $Fixture -Path @('artifact_chain') -Default $null
    if ($null -eq $sourceDeployedPair -or $null -eq $artifactChain) {
        return $false
    }

    foreach ($requiredPairProperty in @('source', 'runtime', 'sync_direction', 'sync_evidence')) {
        if (
            -not (Test-ObjectProperty -Object $sourceDeployedPair -Name $requiredPairProperty) -or
            [string]::IsNullOrWhiteSpace([string]$sourceDeployedPair.PSObject.Properties[$requiredPairProperty].Value)
        ) {
            return $false
        }
    }

    if ([string]$sourceDeployedPair.sync_direction -eq 'runtime-only') {
        return $false
    }
    if (-not (Test-ObjectProperty -Object $artifactChain -Name 'source_runtime_hash_parity')) {
        return $false
    }

    return [string]$artifactChain.source_runtime_hash_parity -eq 'present'
}

function Test-FixtureCanComplete {
    param(
        [Parameter(Mandatory = $true)][object]$Fixture,
        [AllowNull()][object]$DirectorOutput = $null
    )

    foreach ($requiredRootProperty in @('reported_completion_state', 'captain_authored', 'closeout_target', 'artifact_chain')) {
        if (-not (Test-ObjectProperty -Object $Fixture -Name $requiredRootProperty)) {
            return $false
        }
    }

    if ([string]$Fixture.reported_completion_state -ne "complete") {
        return $false
    }

    if ([bool]$Fixture.captain_authored) {
        return $false
    }

    $target = [string]$Fixture.closeout_target
    if (@('source-level', 'process-complete', 'release-ready') -notcontains $target) {
        return $false
    }

    $artifactChain = $Fixture.artifact_chain
    if ($null -eq $artifactChain) {
        return $false
    }
    foreach ($requiredArtifactProperty in @('change_delivery', 'validation', 'review', 'memory_docs', 'director_output_gate')) {
        if (-not (Test-ObjectProperty -Object $artifactChain -Name $requiredArtifactProperty)) {
            return $false
        }
    }

    if (-not (Test-FixtureMemoryReadyForComplete -Fixture $Fixture)) {
        return $false
    }
    if (-not (Test-FixtureSourceDeployedPairReady -Fixture $Fixture -RequirePair $true)) {
        return $false
    }

    $delivery = [string]$artifactChain.change_delivery
    $validation = [string]$artifactChain.validation
    $review = [string]$artifactChain.review
    $directorOutputGate = [string]$artifactChain.director_output_gate

    return (
        $delivery -eq "present" -and
        $validation -eq "passed" -and
        $review -eq "accepted" -and
        $directorOutputGate -eq "passed" -and
        (Test-FixtureDirectorOutputSequenceReady -Fixture $Fixture -DirectorOutput $DirectorOutput)
    )
}

function Test-FixtureDirectorOutputSequenceReady {
    param(
        [Parameter(Mandatory = $true)][object]$Fixture,
        [AllowNull()][object]$DirectorOutput = $null
    )

    $gate = [string](Get-NestedValue -Object $Fixture -Path @("artifact_chain", "director_output_gate") -Default "")
    if ($gate -ne "passed") {
        return $false
    }

    if ($null -eq $DirectorOutput) {
        $DirectorOutput = Get-NestedValue -Object $Fixture -Path @("director_output") -Default $null
    }
    if ($null -eq $DirectorOutput) { return $false }

    $mainBody = [string](Get-NestedValue -Object $DirectorOutput -Path @("main_body") -Default "")
    if ([string]::IsNullOrWhiteSpace($mainBody)) { return $false }

    $markerPatterns = [ordered]@{
        conclusion = '(?im)^[ \t]*(?:#{1,6}[ \t]+)?(?:\u76EE\u524D\u7D50\u8AD6|\u76EE\u524D\u72C0\u614B|\u7D50\u8AD6|\u73FE\u6CC1)[ \t]*(?:[\uFF1A:]|(?=\r?$))'
        next_step = '(?im)^[ \t]*(?:#{1,6}[ \t]+)?(?:\u53EF\u7ACB\u5373\u63A8\u9032\u7684\u4E0B\u4E00\u6B65|\u4E0B\u4E00\u6B65)[ \t]*(?:[\uFF1A:]|(?=\r?$))'
        authorization_boundary = '(?im)^[ \t]*(?:#{1,6}[ \t]+)?(?:\u984D\u5916\u6388\u6B0A\u6216\u7BC4\u570D\u908A\u754C|\u6388\u6B0A\u908A\u754C|\u7BC4\u570D\u908A\u754C)[ \t]*(?:[\uFF1A:]|(?=\r?$))'
        evidence = '(?im)^[ \t]*(?:#{1,6}[ \t]+)?(?:\u8B49\u64DA|\u67E5\u8B49\u7D50\u679C)[ \t]*(?:[\uFF1A:]|(?=\r?$))'
    }
    $markerMatches = [ordered]@{}
    foreach ($entry in $markerPatterns.GetEnumerator()) {
        $matches = [regex]::Matches($mainBody, $entry.Value)
        if ($matches.Count -ne 1) { return $false }
        $markerMatches[$entry.Key] = $matches[0]
    }

    $orderedNames = @('conclusion', 'next_step', 'authorization_boundary', 'evidence')
    for ($index = 0; $index -lt ($orderedNames.Count - 1); $index++) {
        if ($markerMatches[$orderedNames[$index]].Index -ge $markerMatches[$orderedNames[$index + 1]].Index) {
            return $false
        }
    }

    for ($index = 0; $index -lt $orderedNames.Count; $index++) {
        $match = $markerMatches[$orderedNames[$index]]
        $contentStart = $match.Index + $match.Length
        $contentEnd = if ($index -lt ($orderedNames.Count - 1)) {
            $markerMatches[$orderedNames[$index + 1]].Index
        } else {
            $mainBody.Length
        }
        $sectionContent = $mainBody.Substring($contentStart, $contentEnd - $contentStart).Trim()
        if ([string]::IsNullOrWhiteSpace($sectionContent)) { return $false }
    }

    $rawInternalField = [regex]::Match(
        $mainBody,
        '(?im)^[ \t]*(?:[-*][ \t]+)?`?(?:board_state|station_mode|authorization_phase|artifact_chain|validation|review|memory_docs|source_runtime_hash_parity|handoff_ownership|context_visibility)`?[ \t]*(?:[:=|])'
    )
    if ($rawInternalField.Success -and $rawInternalField.Index -lt $markerMatches['conclusion'].Index) {
        return $false
    }

    return $true
}

function Test-FixtureSourceLevelProtectedFollowUpAllowed {
    param([Parameter(Mandatory = $true)][object]$Fixture)

    $target = [string]$Fixture.closeout_target
    $state = [string]$Fixture.reported_completion_state
    $delivery = [string](Get-NestedValue -Object $Fixture -Path @("artifact_chain", "change_delivery") -Default "")
    $validation = [string](Get-NestedValue -Object $Fixture -Path @("artifact_chain", "validation") -Default "")
    $review = [string](Get-NestedValue -Object $Fixture -Path @("artifact_chain", "review") -Default "")
    $memoryDocs = [string](Get-NestedValue -Object $Fixture -Path @("artifact_chain", "memory_docs") -Default "")
    $followUpState = [string](Get-NestedValue -Object $Fixture -Path @("protected_follow_up", "state") -Default "")
    $followUpPhase = [string](Get-NestedValue -Object $Fixture -Path @("protected_follow_up", "phase") -Default "")

    return (
        $target -eq "source-level" -and
        $state -eq "protected-follow-up-pending" -and
        -not [bool]$Fixture.captain_authored -and
        $delivery -eq "present" -and
        $validation -eq "passed" -and
        $review -eq "accepted" -and
        (Test-FixtureSourceDeployedPairReady -Fixture $Fixture -RequirePair $true) -and
        (@("memory-required", "memory-blocked-by-scope") -contains $memoryDocs) -and
        $followUpState -eq "pending" -and
        (@("protected-memory-write", "protected-memory-commit") -contains $followUpPhase)
    )
}

function Test-Stage5DeliveryArtifact {
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $completionText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\skills\team-completion-gate\SKILL.md")
    $stationDelivery = Get-Fixture -FileName "allow-source-level-protected-followup-pending.json"
    $captainSubstitute = Get-Fixture -FileName "block-captain-substitute-completion.json"

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 5. Delivery artifact |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 5 matrix row"
    Assert-TextContainsLiteral -Text $completionText -Needle "A returned implementation or authorized change-application artifact exists" -Scope "team-completion-gate/SKILL.md" -Label "station delivery artifact requirement"
    Assert-TextContainsLiteral -Text $completionText -Needle "captain-authored substitute is offered in place" -Scope "team-completion-gate/SKILL.md" -Label "captain substitute rejection"
    Assert-True -Condition ([string](Get-NestedValue -Object $stationDelivery -Path @("artifact_chain", "change_delivery") -Default "") -eq "present") -Message "Station-delivery fixture must contain a delivery artifact."
    Assert-True -Condition (-not [bool]$stationDelivery.captain_authored) -Message "Station-delivery fixture must not be captain-authored."
    Assert-True -Condition ([bool]$captainSubstitute.captain_authored) -Message "Captain-substitute fixture must encode captain_authored=true."
    Assert-True -Condition ([string](Get-NestedValue -Object $captainSubstitute -Path @("artifact_chain", "change_delivery") -Default "") -eq "captain-substitute") -Message "Captain-substitute fixture must not masquerade as a station artifact."
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $captainSubstitute)) -Message "Captain-substitute fixture was incorrectly classified as complete."
}

function Test-Stage6IndependentEvidence {
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $boardText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\skills\team-task-board\SKILL.md")
    $completionText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\skills\team-completion-gate\SKILL.md")
    $memoryReferenceText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\policies\references\workflow-memory-evidence.md")
    $missingMemory = Get-Fixture -FileName "block-missing-memory-docs-complete.json"
    $protectedFollowUp = Get-Fixture -FileName "allow-source-level-protected-followup-pending.json"

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 6. Independent evidence |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 6 matrix row"
    Assert-TextContainsLiteral -Text $matrixText -Needle "through separate owner states" -Scope "workflow-capability-evidence-matrix.md" -Label "separate evidence owners"
    Assert-TextContainsLiteral -Text $boardText -Needle "Review and validation start only after the implementation or change-application handoff bundle" -Scope "team-task-board/SKILL.md" -Label "validation and review handoff ordering"
    Assert-TextContainsLiteral -Text $boardText -Needle "Memory/docs starts only after validation and review reach terminal evidence states." -Scope "team-task-board/SKILL.md" -Label "memory docs ordering"
    Assert-TextContainsLiteral -Text $completionText -Needle "Implementation, validation, review, memory/docs, and completion boundaries remain separate." -Scope "team-completion-gate/SKILL.md" -Label "independent evidence boundaries"
    Assert-TextContainsLiteral -Text $memoryReferenceText -Needle '### `memory-not-required`' -Scope "workflow-memory-evidence.md" -Label "canonical memory-not-required disposition"
    Assert-TextContainsLiteral -Text $memoryReferenceText -Needle '### `memory-attributed-no-write`' -Scope "workflow-memory-evidence.md" -Label "canonical memory-attributed-no-write disposition"
    Assert-TextContainsLiteral -Text $memoryReferenceText -Needle '`memory_commit` is a separate protected phase.' -Scope "workflow-memory-evidence.md" -Label "separate protected memory commit"
    Assert-True -Condition (-not (Test-ObjectProperty -Object $missingMemory.artifact_chain -Name 'memory_docs')) -Message "Missing-memory fixture must omit the memory_docs field."
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $missingMemory)) -Message "Missing-memory fixture was incorrectly classified as complete."
    Assert-True -Condition (Test-FixtureSourceLevelProtectedFollowUpAllowed -Fixture $protectedFollowUp) -Message "Protected follow-up fixture should be allowed as source-level protected-follow-up-pending."
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $protectedFollowUp)) -Message "Protected follow-up fixture must remain non-complete."

    $pairCounterexamples = @(
        [PSCustomObject]@{ Name = 'missing source'; PairField = 'source'; ArtifactField = $null; RuntimeOnly = $false },
        [PSCustomObject]@{ Name = 'missing runtime'; PairField = 'runtime'; ArtifactField = $null; RuntimeOnly = $false },
        [PSCustomObject]@{ Name = 'missing sync_evidence'; PairField = 'sync_evidence'; ArtifactField = $null; RuntimeOnly = $false },
        [PSCustomObject]@{ Name = 'missing parity'; PairField = $null; ArtifactField = 'source_runtime_hash_parity'; RuntimeOnly = $false },
        [PSCustomObject]@{ Name = 'runtime-only'; PairField = $null; ArtifactField = $null; RuntimeOnly = $true }
    )
    foreach ($counterexample in $pairCounterexamples) {
        $caseFixture = Get-Fixture -FileName "allow-source-level-protected-followup-pending.json"
        if ($null -ne $counterexample.PairField) {
            $caseFixture.source_deployed_pair.PSObject.Properties.Remove([string]$counterexample.PairField)
        }
        if ($null -ne $counterexample.ArtifactField) {
            $caseFixture.artifact_chain.PSObject.Properties.Remove([string]$counterexample.ArtifactField)
        }
        if ($counterexample.RuntimeOnly) {
            $caseFixture.source_deployed_pair.sync_direction = 'runtime-only'
        }
        Assert-True -Condition (-not (Test-FixtureSourceLevelProtectedFollowUpAllowed -Fixture $caseFixture)) -Message ("Protected follow-up accepted pair counterexample: {0}" -f $counterexample.Name)
    }
}

function Test-Stage7BehaviorCounterEvidence {
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $procedureText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-stage-procedures.md")
    $executionSpecText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\policies\references\workflow-execution-spec-contract.md")

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 7. Behavior counter-evidence |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 7 matrix row"
    Assert-TextContainsLiteral -Text $matrixText -Needle "validation failure, review finding, or drift check is recorded with a status" -Scope "workflow-capability-evidence-matrix.md" -Label "finding status requirement"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`behavior_counterevidence`' -Scope "workflow-execution-spec-contract.md" -Label "behavior counter-evidence field"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle "validation failures, review findings, or drift checks" -Scope "workflow-execution-spec-contract.md" -Label "validation review drift findings"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle 'State values use the status ontology:' -Scope "workflow-execution-spec-contract.md" -Label "counter-evidence status"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`sufficient`, `partial`, `no-evidence`, `conflicted`' -Scope "workflow-execution-spec-contract.md" -Label "counter-evidence finding states"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`blocked`, `unverified`, or `not-applicable`' -Scope "workflow-execution-spec-contract.md" -Label "counter-evidence terminal states"
    Assert-TextContainsLiteral -Text $executionSpecText -Needle '`drift_check`' -Scope "workflow-execution-spec-contract.md" -Label "drift check field"
    Assert-TextContainsLiteral -Text $procedureText -Needle 'validation/review findings, and `drift_check`' -Scope "workflow-stage-procedures.md" -Label "Stage 7 procedure findings"
}

function Test-Stage8SourceDeployedSync {
    $orchestrationText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\policies\workflow-orchestration.md")
    $matrixText = Read-TextFile -Path (Get-RepoPath -RelativePath "Shared\workflow-capability-evidence-matrix.md")
    $runtimeOnly = Get-Fixture -FileName "block-runtime-only-sync-complete.json"

    Assert-TextContainsLiteral -Text $matrixText -Needle "| 8. Source/deployed sync |" -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 8 matrix row"
    Assert-TextContainsLiteral -Text $matrixText -Needle '`source_deployed_pair`, `sync_direction`, and hash/content parity evidence' -Scope "workflow-capability-evidence-matrix.md" -Label "Stage 8 sync evidence fields"
    Assert-TextContainsLiteral -Text $orchestrationText -Needle "remains blocked or unverified when hash or content parity is missing" -Scope "workflow-orchestration.md" -Label "missing parity state"
    Test-SourceRuntimeHashPairs
    Test-CodexCoreNormalizedParity

    $missingPairComplete = Get-Fixture -FileName "block-director-output-compliance-led-complete.json"
    $validDirectorOutput = @($missingPairComplete.director_output_cases | Where-Object { [string]$_.name -eq 'valid-action-forward-body' })[0]
    Assert-True -Condition (Test-FixtureCanComplete -Fixture $missingPairComplete -DirectorOutput $validDirectorOutput) -Message "Complete missing-pair counterexample requires a valid positive baseline."
    $missingPairComplete.PSObject.Properties.Remove('source_deployed_pair')
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $missingPairComplete -DirectorOutput $validDirectorOutput)) -Message "Complete fixture without source_deployed_pair was incorrectly accepted."

    Assert-True -Condition (-not (Test-ObjectProperty -Object $runtimeOnly.source_deployed_pair -Name 'sync_evidence')) -Message "Runtime-only fixture must omit sync_evidence."
    Assert-True -Condition (-not (Test-ObjectProperty -Object $runtimeOnly.artifact_chain -Name 'source_runtime_hash_parity')) -Message "Runtime-only fixture must omit source_runtime_hash_parity."

    $runtimeOnly.source_deployed_pair | Add-Member -NotePropertyName sync_evidence -NotePropertyValue "hash parity recorded"
    $runtimeOnly.artifact_chain | Add-Member -NotePropertyName source_runtime_hash_parity -NotePropertyValue "present"
    Assert-True -Condition ([string](Get-NestedValue -Object $runtimeOnly -Path @("source_deployed_pair", "sync_direction") -Default "") -eq "runtime-only") -Message "Runtime-only fixture must encode sync_direction=runtime-only."
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $runtimeOnly)) -Message "Runtime-only sync fixture was incorrectly classified as complete."

    $runtimeOnly.source_deployed_pair.sync_direction = "source-to-runtime"
    $runtimeOnly.source_deployed_pair.PSObject.Properties.Remove('sync_evidence')
    $runtimeOnly.artifact_chain.PSObject.Properties.Remove('source_runtime_hash_parity')
    Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $runtimeOnly)) -Message "Missing sync evidence/parity fields were incorrectly classified as complete."
}

function Test-DirectorOutputFixtureCases {
    $directorOutputFixture = Get-Fixture -FileName "block-director-output-compliance-led-complete.json"
    Assert-True -Condition ([string](Get-NestedValue -Object $directorOutputFixture -Path @("artifact_chain", "director_output_gate") -Default "") -eq "passed") -Message "Director-output fixture must keep the surrounding gate otherwise passed."
    Assert-True -Condition ([string](Get-NestedValue -Object $directorOutputFixture -Path @("artifact_chain", "director_output_sequence") -Default "") -eq "passed") -Message "Director-output fixture must keep the legacy sequence declaration misleadingly passed."
    Assert-True -Condition ([string]$directorOutputFixture.artifact_chain.memory_docs -eq 'memory-not-required') -Message "Director-output fixture must use canonical memory-not-required disposition."

    $cases = @((Get-NestedValue -Object $directorOutputFixture -Path @("director_output_cases") -Default @()))
    Assert-True -Condition ($cases.Count -ge 5) -Message "Director-output fixture must contain at least five actual-body cases."

    $expectedCaseNames = @(
        'valid-action-forward-body',
        'claimed-passed-missing-sections',
        'reverse-order',
        'raw-internal-field-bullets',
        'internal-state-led-disguised-report'
    )
    foreach ($caseName in $expectedCaseNames) {
        Assert-True -Condition (@($cases | Where-Object { [string]$_.name -eq $caseName }).Count -eq 1) -Message "Missing or duplicate Director-output fixture case: $caseName"
    }

    $allowedCount = 0
    $blockedCount = 0
    foreach ($case in $cases) {
        $expectedAllowed = [bool](Get-NestedValue -Object $case -Path @("expected_completion_allowed") -Default $false)
        $sequenceReady = Test-FixtureDirectorOutputSequenceReady -Fixture $directorOutputFixture -DirectorOutput $case
        $completionAllowed = Test-FixtureCanComplete -Fixture $directorOutputFixture -DirectorOutput $case
        Assert-True -Condition ($sequenceReady -eq $expectedAllowed) -Message ("Actual-body sequence result mismatch for case: {0}" -f $case.name)
        Assert-True -Condition ($completionAllowed -eq $expectedAllowed) -Message ("Completion result mismatch for case: {0}" -f $case.name)
        if ($completionAllowed) { $allowedCount++ } else { $blockedCount++ }
    }

    Assert-True -Condition ($allowedCount -eq 1) -Message "Exactly one compliant Director body must pass."
    Assert-True -Condition ($blockedCount -ge 4) -Message "At least four noncompliant Director bodies must fail."

    $validCase = @($cases | Where-Object { [string]$_.name -eq 'valid-action-forward-body' })[0]
    foreach ($allowedDisposition in @('memory-not-required', 'memory-attributed-no-write')) {
        $directorOutputFixture.artifact_chain.memory_docs = $allowedDisposition
        Assert-True -Condition (Test-FixtureCanComplete -Fixture $directorOutputFixture -DirectorOutput $validCase) -Message ("Canonical no-write memory disposition was rejected: {0}" -f $allowedDisposition)
    }
    foreach ($blockedDisposition in @('memory-written', 'memory-required')) {
        $directorOutputFixture.artifact_chain.memory_docs = $blockedDisposition
        Assert-True -Condition (-not (Test-FixtureCanComplete -Fixture $directorOutputFixture -DirectorOutput $validCase)) -Message ("Non-ready memory disposition was accepted: {0}" -f $blockedDisposition)
    }
    $directorOutputFixture.artifact_chain.memory_docs = 'memory-not-required'
}

function Test-DirectorOutputGateSemantics {
    $languagePath = Get-RepoPath -RelativePath "Shared\policies\language-governance.md"
    $completionPath = Get-RepoPath -RelativePath "Shared\skills\team-completion-gate\SKILL.md"
    $languageText = Read-TextFile -Path $languagePath
    $completionText = Read-TextFile -Path $completionPath
    $captainGateSection = Get-MarkdownSectionText -Text $languageText -Heading 'Captain Integration And Director Output Gate'
    $reportRulesSection = Get-MarkdownSectionText -Text $languageText -Heading 'Director-Facing Report Rules'
    $planningVocabularySection = Get-MarkdownSectionText -Text $languageText -Heading 'Director-Facing Planning Vocabulary'
    $actionForwardSequence = 'current conclusion/status -> next step -> authorization boundary -> evidence'

    Assert-TextContainsLiteral -Text $languageText -Needle "Traditional Chinese meaning-first" -Scope "Shared/policies/language-governance.md" -Label "Traditional Chinese meaning-first"
    Assert-TextContainsLiteral -Text $languageText -Needle "Raw board, handoff, channel, authorization, lifecycle, or station field lists must not be the Director-facing main body." -Scope "Shared/policies/language-governance.md" -Label "raw board is not director main body"
    Assert-True -Condition ($null -ne $captainGateSection) -Message "Captain Integration And Director Output Gate must exist exactly once."
    Assert-True -Condition ($null -ne $reportRulesSection) -Message "Director-Facing Report Rules must exist exactly once."
    Assert-True -Condition ($null -ne $planningVocabularySection) -Message "Director-Facing Planning Vocabulary must exist exactly once."
    Assert-True -Condition ([regex]::Matches($languageText, [regex]::Escape($actionForwardSequence)).Count -eq 1) -Message "Action-forward sequence must have exactly one complete policy owner."
    Assert-TextContainsLiteral -Text $captainGateSection -Needle $actionForwardSequence -Scope "Captain Integration And Director Output Gate" -Label "action-forward director output order"
    Assert-TextNotContainsLiteral -Text $reportRulesSection -Needle $actionForwardSequence -Scope "Director-Facing Report Rules" -Label "duplicated action-forward order"
    Assert-TextNotContainsLiteral -Text $planningVocabularySection -Needle $actionForwardSequence -Scope "Director-Facing Planning Vocabulary" -Label "duplicated action-forward order"
    Assert-TextContainsLiteral -Text $languageText -Needle "clearly labeled evidence appendix" -Scope "Shared/policies/language-governance.md" -Label "evidence appendix boundary"
    Assert-TextContainsLiteral -Text $languageText -Needle "non-complete until the captain provides a Traditional Chinese meaning-first synthesis" -Scope "Shared/policies/language-governance.md" -Label "non-complete output gate"
    Assert-TextContainsLiteral -Text $languageText -Needle "does not alter source truth, validation results, review results, memory/docs disposition, or protected-action authorization" -Scope "Shared/policies/language-governance.md" -Label "output gate does not replace evidence"
    Assert-TextContainsLiteral -Text $completionText -Needle "Director-facing report governance" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "completion report governance row"
    Assert-TextContainsLiteral -Text $completionText -Needle "Traditional Chinese meaning-first synthesis" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "completion language gate"
    Assert-TextContainsLiteral -Text $completionText -Needle "current conclusion/status -> next step -> authorization boundary -> evidence" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "completion action-forward order"
    Assert-TextContainsLiteral -Text $completionText -Needle "director_output_gate:" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "director output artifact field"
    Assert-TextContainsLiteral -Text $completionText -Needle 'blocks `complete`' -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "complete blocked by unsynthesized output"
    Assert-TextContainsLiteral -Text $completionText -Needle "next-step-missing" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "missing next step blocks complete"
    Assert-TextContainsLiteral -Text $completionText -Needle "memory/docs disposition, required sync/parity evidence" -Scope "Shared/skills/team-completion-gate/SKILL.md" -Label "director output gate consumes only output readiness"
    Test-DirectorOutputFixtureCases
}

Invoke-Check -Name "Stage 1 - unique workflow mainline" -ScriptBlock { Test-MainlineAnchorOwnership }
Invoke-Check -Name "Stage 2 - workflow entry references" -ScriptBlock { Test-Stage2WorkflowEntryReferences }
Invoke-Check -Name "Stage 3 - execution specification" -ScriptBlock { Test-Stage3ExecutionSpec }
Invoke-Check -Name "Stage 4 - station handoff" -ScriptBlock { Test-Stage4StationHandoff }
Invoke-Check -Name "Stage 5 - station delivery artifact" -ScriptBlock { Test-Stage5DeliveryArtifact }
Invoke-Check -Name "Stage 6 - independent evidence" -ScriptBlock { Test-Stage6IndependentEvidence }
Invoke-Check -Name "Stage 7 - behavior counter-evidence" -ScriptBlock { Test-Stage7BehaviorCounterEvidence }
Invoke-Check -Name "Stage 8 - source/deployed synchronization" -ScriptBlock { Test-Stage8SourceDeployedSync }
Invoke-Check -Name "Director output gate semantics (additional)" -ScriptBlock { Test-DirectorOutputGateSemantics }

$failed = @($script:Results | Where-Object { -not $_.Passed })
Write-Host ""
Write-Host "Workflow eight-stage plan validation summary"
Write-Host "Passed: $($script:Results.Count - $failed.Count)"
Write-Host "Failed: $($failed.Count)"

if ($failed.Count -gt 0) {
    foreach ($failure in $failed) {
        Write-Host "- $($failure.Name): $($failure.Error)"
    }
    exit 1
}

Write-Host "All workflow eight-stage plan checks passed."
exit 0
