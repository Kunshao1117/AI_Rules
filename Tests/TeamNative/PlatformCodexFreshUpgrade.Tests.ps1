Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$script:codexModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1') -Force -PassThru
$script:managerModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Manager.Deployment.psm1') -Force -PassThru

function Assert-CodexGeneratedPolicyPointer {
    param(
        [string]$Path,
        [string]$Stage
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($content -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') {
        throw "$Stage did not retain the generated Codex policy pointer."
    }
    if ($content -notmatch 'Shared/policies/adapters/codex-subagent-invocation\.md') {
        throw "$Stage did not identify the Codex adapter policy source."
    }
    if ($content -match 'The governed Codex candidate rungs are exactly') {
        throw "$Stage copied the full Codex adapter policy into AGENTS.md."
    }
}

function Get-ManagerSyncResultFromOutput {
    param([object[]]$Output)

    $results = @($Output | Where-Object {
        $null -ne $_ -and $null -ne $_.PSObject.Properties['RequiredStageResults']
    })
    if ($results.Count -ne 1) {
        throw "Expected one manager sync result object; received $($results.Count)."
    }
    return $results[0]
}

Describe 'Codex Fresh, Upgrade, and Manager adapter policy regression' {
    BeforeEach {
        $script:tempTarget = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-codex-platform-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempTarget | Out-Null
        Mock -CommandName Assert-ManagerSourceSyncedForProjectSync -ModuleName $script:managerModule.Name -MockWith { }
        Mock -CommandName Invoke-ConfirmGate -ModuleName $script:codexModule.Name -MockWith { return $true }
    }

    AfterEach {
        try {
            if (Test-Path -LiteralPath $script:tempTarget) {
                Remove-Item -LiteralPath $script:tempTarget -Recurse -Force
            }
        } finally {
            if (Test-Path -LiteralPath $script:tempTarget) {
                throw "Temporary Codex fixture was not removed: $script:tempTarget"
            }
        }
    }

    It 'uses the Codex adapter marker through Fresh, repeated Upgrade, and repeated Manager Sync' {
        if ($script:tempTarget -match '(?i)D:\\MXF_TOOL|globalStorage') {
            throw "Temporary Codex fixture must not use a managed cache path: $script:tempTarget"
        }

        foreach ($sourcePath in @(
            (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Manager.Deployment.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Manager.ProjectSync.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1')
        )) {
            $sourceContent = Get-Content -LiteralPath $sourcePath -Raw -Encoding UTF8
            if ($sourceContent -match '(?i)D:\\MXF_TOOL|globalStorage') {
                throw "Safe Codex path source must not use managed cache storage: $sourcePath"
            }
        }

        $frameworkRoot = Join-Path $repoRoot 'Codex'
        $sharedSkillsRoot = Join-Path $repoRoot 'Shared\skills'
        $adapterPolicyPath = Join-Path $repoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $agentsPath = Join-Path $script:tempTarget '.codex\AGENTS.md'
        $adapterContent = Get-Content -LiteralPath $adapterPolicyPath -Raw -Encoding UTF8
        if ($adapterContent -notmatch '<!-- SUBAGENT_POLICY:CODEX_START -->' -or
            $adapterContent -notmatch '<!-- SUBAGENT_POLICY:CODEX_END -->') {
            throw 'The Codex adapter source must expose its platform marker.'
        }

        $null = Invoke-CodexFresh -FrameworkRoot $frameworkRoot -Target $script:tempTarget -SharedSkillsRoot $sharedSkillsRoot
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Fresh'

        $null = Invoke-CodexUpgrade -FrameworkRoot $frameworkRoot -Target $script:tempTarget -SharedSkillsRoot $sharedSkillsRoot
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'First Upgrade'
        $firstUpgradeContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $firstUpgradeHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash

        $null = Invoke-CodexUpgrade -FrameworkRoot $frameworkRoot -Target $script:tempTarget -SharedSkillsRoot $sharedSkillsRoot
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Second Upgrade'
        $secondUpgradeContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $secondUpgradeHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash
        if ($firstUpgradeContent -cne $secondUpgradeContent -or $firstUpgradeHash -ne $secondUpgradeHash) {
            throw 'The second Codex Upgrade materially changed AGENTS.md.'
        }
        Assert-MockCalled -CommandName Invoke-ConfirmGate -ModuleName $script:codexModule.Name -Times 2 -Exactly

        $firstManagerOutput = @(Invoke-ManagerSyncProjectRules -RepoRoot $repoRoot -Target $script:tempTarget -ProjectPlatform Codex -Apply 6>&1)
        $firstManagerResult = Get-ManagerSyncResultFromOutput -Output $firstManagerOutput
        if (-not $firstManagerResult.Succeeded) { throw 'The first Manager SyncProjectRules run failed.' }
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'First Manager Sync'
        $firstManagerContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $firstManagerHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash

        $secondManagerOutput = @(Invoke-ManagerSyncProjectRules -RepoRoot $repoRoot -Target $script:tempTarget -ProjectPlatform Codex -Apply 6>&1)
        $secondManagerResult = Get-ManagerSyncResultFromOutput -Output $secondManagerOutput
        if (-not $secondManagerResult.Succeeded) { throw 'The second Manager SyncProjectRules run failed.' }
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Second Manager Sync'
        $secondManagerContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $secondManagerHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash
        if ($firstManagerContent -cne $secondManagerContent -or $firstManagerHash -ne $secondManagerHash) {
            throw 'The second Manager SyncProjectRules run materially changed AGENTS.md.'
        }
    }
}
