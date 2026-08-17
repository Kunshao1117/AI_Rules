Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$script:cursorModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Cursor.psm1') -Force -PassThru

function Assert-CursorGeneratedPolicyPointer {
    param(
        [string]$Path,
        [string]$Stage
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($content -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') {
        throw "$Stage did not retain the generated Cursor policy pointer."
    }
    if ($content -notmatch 'Shared/policies/adapters/cursor-subagent-invocation\.md') {
        throw "$Stage did not identify the Cursor adapter policy source."
    }
    if ($content -match 'Current Cursor channel names include') {
        throw "$Stage copied the full Cursor adapter policy into 00-core.mdc."
    }
}

function Invoke-CursorModuleCommand {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Command,
        [object[]]$ArgumentList
    )

    & $script:cursorModule $Command @ArgumentList
}

Describe 'Cursor Fresh and Upgrade adapter policy regression' {
    BeforeEach {
        $script:tempTarget = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-cursor-platform-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempTarget | Out-Null
        $global:aiRulesCursorConfirmGateCalls = 0
        & $script:cursorModule {
            Set-Item -Path Function:Invoke-ConfirmGate -Value {
                $global:aiRulesCursorConfirmGateCalls += 1
                return $true
            }
        }
    }

    AfterEach {
        try {
            if (Test-Path -LiteralPath $script:tempTarget) {
                Remove-Item -LiteralPath $script:tempTarget -Recurse -Force
            }
        } finally {
            Remove-Variable -Name aiRulesCursorConfirmGateCalls -Scope Global -ErrorAction SilentlyContinue
            if (Test-Path -LiteralPath $script:tempTarget) {
                throw "Temporary Cursor fixture was not removed: $script:tempTarget"
            }
        }
    }

    It 'uses the Cursor adapter marker through Fresh and repeated Upgrade' {
        $frameworkRoot = Join-Path $repoRoot 'Cursor'
        $sharedSkillsRoot = Join-Path $repoRoot 'Shared\skills'
        $adapterPolicyPath = Join-Path $repoRoot 'Shared\policies\adapters\cursor-subagent-invocation.md'
        $coreRulePath = Join-Path $script:tempTarget '.cursor\rules\00-core.mdc'
        $skillsPath = Join-Path $script:tempTarget '.cursor\skills'
        $sharedPath = Join-Path $script:tempTarget '.agents\shared'
        $memoryPath = Join-Path $script:tempTarget '.agents\memory'
        $adapterContent = Get-Content -LiteralPath $adapterPolicyPath -Raw -Encoding UTF8
        if ($adapterContent -notmatch '<!-- SUBAGENT_POLICY:CURSOR_START -->' -or
            $adapterContent -notmatch '<!-- SUBAGENT_POLICY:CURSOR_END -->') {
            throw 'The Cursor adapter source must expose its platform marker.'
        }

        $null = Invoke-CursorModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CursorFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)

        Assert-CursorGeneratedPolicyPointer -Path $coreRulePath -Stage 'Fresh'
        $identityRulePath = Join-Path $script:tempTarget '.cursor\rules\02-platform-identity.mdc'
        if (-not (Test-Path -LiteralPath $identityRulePath -PathType Leaf)) {
            throw 'Fresh did not deploy 02-platform-identity.mdc.'
        }
        $identityContent = Get-Content -LiteralPath $identityRulePath -Raw -Encoding UTF8
        if ($identityContent -notmatch 'You are the Cursor Edition agent') {
            throw 'Fresh identity rule is missing the Cursor session owner sentence.'
        }
        if ($identityContent -notmatch 'not your bootstrap, install prompt, or sub-agent jail') {
            throw 'Fresh identity rule is missing the foreign-template boundary.'
        }
        if (-not (Test-Path -LiteralPath (Join-Path $skillsPath '03-build-建構\SKILL.md'))) {
            throw 'Fresh did not merge a Cursor workflow skill into .cursor/skills.'
        }
        if (-not (Test-Path -LiteralPath (Join-Path $sharedPath 'policies\team-native-core.md'))) {
            throw 'Fresh did not deploy shared governance references.'
        }
        if (-not (Test-Path -LiteralPath $memoryPath)) {
            throw 'Fresh did not create the protected memory directory.'
        }
        if (Test-Path -LiteralPath (Join-Path $script:tempTarget '.cursor\hooks.json')) {
            throw 'Fresh installed a Cursor hooks.json Team-routing artifact.'
        }

        $memorySentinel = Join-Path $memoryPath 'cursor-fresh-sentinel.txt'
        [System.IO.File]::WriteAllText($memorySentinel, 'protected', [System.Text.UTF8Encoding]::new($false))

        $null = Invoke-CursorModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CursorUpgrade -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)
        Assert-CursorGeneratedPolicyPointer -Path $coreRulePath -Stage 'First Upgrade'
        if (-not (Test-Path -LiteralPath $identityRulePath -PathType Leaf)) {
            throw 'Upgrade removed 02-platform-identity.mdc.'
        }
        $firstUpgradeHash = (Get-FileHash -LiteralPath $coreRulePath -Algorithm SHA256).Hash

        $null = Invoke-CursorModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CursorUpgrade -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)
        Assert-CursorGeneratedPolicyPointer -Path $coreRulePath -Stage 'Second Upgrade'
        $secondUpgradeHash = (Get-FileHash -LiteralPath $coreRulePath -Algorithm SHA256).Hash
        if ($firstUpgradeHash -ne $secondUpgradeHash) {
            throw 'The second Cursor Upgrade materially changed 00-core.mdc.'
        }
        if (-not (Test-Path -LiteralPath $memorySentinel)) {
            throw 'Upgrade overwrote the protected memory sentinel.'
        }
        if (Test-Path -LiteralPath (Join-Path $script:tempTarget '.cursor\hooks.json')) {
            throw 'Upgrade installed a Cursor hooks.json Team-routing artifact.'
        }
    }
}
