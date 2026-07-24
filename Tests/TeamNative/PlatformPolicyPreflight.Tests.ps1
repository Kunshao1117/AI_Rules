Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Get-TargetFingerprint {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return '<missing>' }

    $root = (Resolve-Path -LiteralPath $Path).Path.TrimEnd('\')
    return @(
        Get-ChildItem -LiteralPath $Path -Force -Recurse |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($root.Length).TrimStart('\')
                if ($_.PSIsContainer) { return "D|$relative" }
                return "F|$relative|$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)"
            }
    ) -join "`n"
}

function Invoke-PlatformRoute {
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [Parameter(Mandatory = $true)][string]$FrameworkRoot,
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][string]$SharedSkillsRoot
    )

    & $Command -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
}

$platforms = @(
    [PSCustomObject]@{
        Platform = 'Antigravity'
        ModuleName = (Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Antigravity.psm1') -Force -PassThru).Name
        FreshCommand = 'Invoke-AgFresh'
        UpgradeCommand = 'Invoke-AgUpgrade'
        FrameworkRoot = Join-Path $repoRoot 'Antigravity'
        PolicyRelativePath = 'policies\adapters\antigravity-subagent-invocation.md'
        PolicyTargetRelativePath = '.agents\rules\00_core_identity.md'
    },
    [PSCustomObject]@{
        Platform = 'Claude'
        ModuleName = (Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Claude.psm1') -Force -PassThru).Name
        FreshCommand = 'Invoke-ClaudeFresh'
        UpgradeCommand = 'Invoke-ClaudeUpgrade'
        FrameworkRoot = Join-Path $repoRoot 'Claude'
        PolicyRelativePath = 'policies\adapters\claude-subagent-invocation.md'
        PolicyTargetRelativePath = '.claude\rules\core-identity.md'
    },
    [PSCustomObject]@{
        Platform = 'Codex'
        ModuleName = (Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1') -Force -PassThru).Name
        FreshCommand = 'Invoke-CodexFresh'
        UpgradeCommand = 'Invoke-CodexUpgrade'
        FrameworkRoot = Join-Path $repoRoot 'Codex'
        PolicyRelativePath = 'policies\adapters\codex-subagent-invocation.md'
        PolicyTargetRelativePath = '.codex\AGENTS.md'
    }
)

$preflightCases = @()
foreach ($platform in $platforms) {
    foreach ($operation in @('Fresh', 'Upgrade')) {
        foreach ($policyState in @('missing', 'invalid')) {
            $preflightCases += @{
                Platform = $platform.Platform
                ModuleName = $platform.ModuleName
                Command = $platform.PSObject.Properties["${operation}Command"].Value
                FrameworkRoot = $platform.FrameworkRoot
                PolicyRelativePath = $platform.PolicyRelativePath
                Operation = $operation
                PolicyState = $policyState
            }
        }
    }
}

$validCases = @()
foreach ($platform in $platforms) {
    $validCases += @{
        Platform = $platform.Platform
        ModuleName = $platform.ModuleName
        FreshCommand = $platform.FreshCommand
        UpgradeCommand = $platform.UpgradeCommand
        FrameworkRoot = $platform.FrameworkRoot
        PolicyTargetRelativePath = $platform.PolicyTargetRelativePath
    }
}

Describe 'Platform policy preflight regression' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-platform-preflight-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
        if (Test-Path -LiteralPath $script:tempRoot) {
            throw "Temporary platform preflight fixture was not removed: $script:tempRoot"
        }
    }

    It '<Platform> <Operation> fails before target mutation when its policy is <PolicyState>' -TestCases $preflightCases {
        param($Platform, $ModuleName, $Command, $FrameworkRoot, $PolicyRelativePath, $Operation, $PolicyState)

        $sharedSkillsRoot = Join-Path $script:tempRoot 'Shared\skills'
        $target = Join-Path $script:tempRoot 'target'
        New-Item -ItemType Directory -Force -Path $sharedSkillsRoot, $target | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $target 'preflight-sentinel.txt'), 'unchanged', [System.Text.UTF8Encoding]::new($false))

        $policyPath = Join-Path (Split-Path $sharedSkillsRoot -Parent) $PolicyRelativePath
        if ($PolicyState -eq 'invalid') {
            New-Item -ItemType Directory -Force -Path (Split-Path $policyPath -Parent) | Out-Null
            [System.IO.File]::WriteAllText($policyPath, '# policy without a platform marker', [System.Text.UTF8Encoding]::new($false))
        }

        $before = Get-TargetFingerprint -Path $target
        $caught = $null
        try {
            Invoke-PlatformRoute -Command $Command -FrameworkRoot $FrameworkRoot -Target $target -SharedSkillsRoot $sharedSkillsRoot
        } catch {
            $caught = $_
        }

        if ($null -eq $caught) {
            throw "$Platform $Operation must reject a $PolicyState policy before target mutation."
        }
        $expectedError = if ($PolicyState -eq 'missing') { '^SharedPolicy\.PolicyFileMissing' } else { '^SharedPolicy\.PolicyBlockMissing' }
        if ($caught.FullyQualifiedErrorId -notmatch $expectedError) {
            throw "Expected $expectedError; received $($caught.FullyQualifiedErrorId)."
        }
        $after = Get-TargetFingerprint -Path $target
        if ($before -cne $after) {
            throw "$Platform $Operation changed the target after policy preflight failure."
        }
    }

    It '<Platform> keeps valid policy support through Fresh and Upgrade' -TestCases $validCases {
        param($Platform, $ModuleName, $FreshCommand, $UpgradeCommand, $FrameworkRoot, $PolicyTargetRelativePath)

        $target = Join-Path $script:tempRoot 'target'
        $sharedSkillsRoot = Join-Path $repoRoot 'Shared\skills'
        Mock -CommandName Invoke-ConfirmGate -ModuleName $ModuleName -MockWith { return $true }

        $null = Invoke-PlatformRoute -Command $FreshCommand -FrameworkRoot $FrameworkRoot -Target $target -SharedSkillsRoot $sharedSkillsRoot
        $policyTarget = Join-Path $target $PolicyTargetRelativePath
        if (-not (Test-Path -LiteralPath $policyTarget -PathType Leaf)) {
            throw "$Platform Fresh did not produce its policy target: $policyTarget"
        }
        if ((Get-Content -LiteralPath $policyTarget -Raw -Encoding UTF8) -notmatch '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->') {
            throw "$Platform Fresh did not retain the shared policy marker."
        }

        $null = Invoke-PlatformRoute -Command $UpgradeCommand -FrameworkRoot $FrameworkRoot -Target $target -SharedSkillsRoot $sharedSkillsRoot
        if ((Get-Content -LiteralPath $policyTarget -Raw -Encoding UTF8) -notmatch '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->') {
            throw "$Platform Upgrade did not retain the shared policy marker."
        }
    }
}
