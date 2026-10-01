# Antigravity delivery of canonical Shared procedures as platform Skills.

function Assert-NativeProjectionHash {
    param([string]$SourcePath, [string]$TargetPath)
    $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    if ($sourceHash -ne $targetHash) { throw "Native projection copy hash mismatch: $TargetPath" }
}

function Get-AntigravityProcedureSkillDecisions {
    param(
        [Parameter(Mandatory = $true)][string]$ProcedureSkillsRoot,
        [Parameter(Mandatory = $true)][string]$CanonicalWorkflowsRoot,
        [Parameter(Mandatory = $true)][string]$SharedSkillsRoot,
        [Parameter(Mandatory = $true)][string]$TargetSkillsPath
    )

    if (-not (Test-Path -LiteralPath $ProcedureSkillsRoot -PathType Container) -or
        -not (Test-Path -LiteralPath $CanonicalWorkflowsRoot -PathType Container)) {
        throw 'Antigravity procedure source or canonical workflows are missing.'
    }
    $ids = @(Get-ChildItem -LiteralPath $CanonicalWorkflowsRoot -File -Filter '*.md' |
        ForEach-Object { $_.BaseName } | Sort-Object)
    # The retired Shared Skill used this platform path; keep its retirement
    # projection separate from the new canonical procedure delivery.
    $deliveryAliases = @{ 'ui-design-exploration' = 'ui-design-exploration-procedure' }
    $expectedWrapperIds = @($ids | ForEach-Object {
        if ($deliveryAliases.ContainsKey($_)) { $deliveryAliases[$_] } else { $_ }
    } | Sort-Object)
    $wrapperIds = @(Get-ChildItem -LiteralPath $ProcedureSkillsRoot -Directory |
        ForEach-Object { $_.Name } | Sort-Object)
    if (($expectedWrapperIds -join '|') -cne ($wrapperIds -join '|')) {
        throw 'Antigravity procedure wrappers must match canonical workflow delivery identities exactly.'
    }

    $decisions = @()
    foreach ($id in $ids) {
        $deliveryId = if ($deliveryAliases.ContainsKey($id)) { $deliveryAliases[$id] } else { $id }
        if (Test-Path -LiteralPath (Join-Path (Join-Path $SharedSkillsRoot $deliveryId) 'SKILL.md') -PathType Leaf) {
            throw "Antigravity procedure identity collides with an active Shared Skill: $deliveryId"
        }
        $source = Join-Path (Join-Path $ProcedureSkillsRoot $deliveryId) 'SKILL.md'
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            throw "Missing Antigravity procedure wrapper: $id"
        }
        $body = Get-Content -LiteralPath $source -Raw -Encoding UTF8
        if ($body -notmatch "(?m)^name: $([regex]::Escape($deliveryId))\s*$" -or
            -not $body.Contains(".agents/shared/workflows/$id.md")) {
            throw "Antigravity procedure wrapper identity or canonical pointer mismatch: $id"
        }
        $target = Join-Path (Join-Path $TargetSkillsPath $deliveryId) 'SKILL.md'
        $action = 'ADD'
        if (Test-Path -LiteralPath $target -PathType Container) {
            $action = 'BLOCK'
        } elseif (Test-Path -LiteralPath $target -PathType Leaf) {
            $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
            $action = if ($sourceHash -eq $targetHash) { 'UNCHANGED' } else { 'BLOCK' }
        }
        $decisions += [PSCustomObject]@{
            Id = $id
            DeliveryId = $deliveryId
            SourcePath = $source
            TargetPath = $target
            Action = $action
            Reason = if ($action -eq 'BLOCK') { 'existing_procedure_skill_copy_not_proven_framework_owned' } else { 'canonical_procedure_platform_delivery' }
        }
    }
    return $decisions
}

function Sync-AntigravityProcedureSkills {
    param(
        [Parameter(Mandatory = $true)][string]$ProcedureSkillsRoot,
        [Parameter(Mandatory = $true)][string]$CanonicalWorkflowsRoot,
        [Parameter(Mandatory = $true)][string]$SharedSkillsRoot,
        [Parameter(Mandatory = $true)][string]$TargetSkillsPath
    )
    $decisions = @(Get-AntigravityProcedureSkillDecisions -ProcedureSkillsRoot $ProcedureSkillsRoot `
        -CanonicalWorkflowsRoot $CanonicalWorkflowsRoot -SharedSkillsRoot $SharedSkillsRoot `
        -TargetSkillsPath $TargetSkillsPath)
    if (@($decisions | Where-Object Action -eq 'BLOCK').Count -gt 0) {
        throw 'Antigravity procedure Skill projection stopped at an existing unconfirmed target copy.'
    }
    foreach ($decision in $decisions | Where-Object Action -eq 'ADD') {
        $parent = Split-Path $decision.TargetPath -Parent
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Copy-Item -LiteralPath $decision.SourcePath -Destination $decision.TargetPath -ErrorAction Stop
        Assert-NativeProjectionHash -SourcePath $decision.SourcePath -TargetPath $decision.TargetPath
    }
    return $decisions
}

Export-ModuleMember -Function Get-AntigravityProcedureSkillDecisions, Sync-AntigravityProcedureSkills
