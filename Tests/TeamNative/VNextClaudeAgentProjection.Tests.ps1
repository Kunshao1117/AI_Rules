Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$agentRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $agentRepo 'Scripts/modules/Core.psm1') -Force
Import-Module (Join-Path $agentRepo 'Scripts/modules/Platform-Claude.psm1') -Force
Import-Module (Join-Path $agentRepo 'Scripts/modules/Deployment.Preflight.psm1') -Force
Import-Module (Join-Path $agentRepo 'Scripts/modules/Claude-Agent-Projection.psm1') -Force
Import-Module (Join-Path $agentRepo 'Scripts/modules/Core.Upgrade.psm1') -Force

function New-ClaudeAgentTarget {
    $path = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path (Join-Path $path '.claude') -Force
    [IO.File]::WriteAllText((Join-Path $path '.claude/VERSION'), 'old', [Text.UTF8Encoding]::new($false))
    return $path
}

function Set-ClaudeAgentFixtureFile([string]$Target, [string]$Name, [string]$Content) {
    $path = Join-Path $Target ".claude/agents/$Name"
    $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
    [IO.File]::WriteAllText($path, $Content, [Text.UTF8Encoding]::new($false))
    return $path
}

function Set-ClaudeAgentFixtureManifest([string]$Target, [string]$Name, [string]$Sha256) {
    $path = Join-Path $Target '.agents/ai-rules-manifest.claude.json'
    $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
    $manifest = [ordered]@{ platform='claude'; framework_version='old'; modules=@(
        [ordered]@{ path=".claude/agents/$Name"; sha256=$Sha256 }
    ) }
    [IO.File]::WriteAllText($path, ($manifest | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))
}

function Get-ClaudeAgentFixtureDecisions([string]$Target) {
    @(Get-ClaudeAgentProjectionDecisions -FrameworkRoot (Join-Path $agentRepo 'Claude') -SharedRoot (Join-Path $agentRepo 'Shared') -TargetRoot $Target)
}

function New-ClaudeHistoricalFramework([string]$AgentName) {
    $framework = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
    $agents = Join-Path $framework '.claude/agents'
    $history = Join-Path $framework 'agent-history/v0'
    $null = New-Item -ItemType Directory -Path $agents -Force
    $null = New-Item -ItemType Directory -Path $history -Force
    Get-ChildItem -LiteralPath (Join-Path $agentRepo 'Claude/.claude/agents') -File | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $agents $_.Name)
    }
    Copy-Item -LiteralPath (Join-Path $agents $AgentName) -Destination (Join-Path $history $AgentName)
    [IO.File]::AppendAllText((Join-Path $agents $AgentName), "`nNew framework version.`n", [Text.UTF8Encoding]::new($false))
    return $framework
}

Describe 'Gate 3B Claude Agent projection' {
    It 'derives exactly the canonical six and plans them for a fresh target' {
        $target = New-ClaudeAgentTarget
        $sources = @(Get-ClaudeAgentSourceFiles -FrameworkRoot (Join-Path $agentRepo 'Claude') -SharedRoot (Join-Path $agentRepo 'Shared'))
        $sources.Count | Should Be 6
        @($sources | Where-Object { $_.RelativePath -match '(explorer|memory|git-checkpoint|release)' }).Count | Should Be 0
        @($sources | Select-Object -ExpandProperty TargetRelativePath -Unique).Count | Should Be 6
        $decisions = @(Get-ClaudeAgentFixtureDecisions $target)
        @($decisions | Where-Object { $_.Action -eq 'ADD' -and -not $_.Blocking }).Count | Should Be 6
        $report = @(Get-ClaudeAgentUpgradeReport -Decisions $decisions)
        @($report | Where-Object Status -eq 'NEW').Count | Should Be 6
    }

    It 'rejects an unexpected nested Agent template before it can be projected' {
        $framework = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $dest = Join-Path $framework '.claude/agents'
        $null = New-Item -ItemType Directory -Path (Join-Path $dest 'extra') -Force
        Get-ChildItem -LiteralPath (Join-Path $agentRepo 'Claude/.claude/agents') -File | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dest $_.Name)
        }
        [IO.File]::WriteAllText((Join-Path $dest 'extra/explorer.md'), 'not a canonical role', [Text.UTF8Encoding]::new($false))
        (Test-Path -LiteralPath (Join-Path $dest 'extra/explorer.md') -PathType Leaf) | Should Be $true
        $blocked = $false
        try { $null = @(Get-ClaudeAgentSourceFiles -FrameworkRoot $framework -SharedRoot (Join-Path $agentRepo 'Shared')) }
        catch { $blocked = $_.Exception.Message -like '*non-canonical template*' }
        $blocked | Should Be $true
    }

    It 'plans all six as ADD for an existing Upgrade target with no Agents' {
        $target = New-ClaudeAgentTarget
        $decisions = @(Get-ClaudeAgentFixtureDecisions $target)
        @($decisions | Where-Object { $_.Action -eq 'ADD' -and -not $_.Blocking }).Count | Should Be 6
        @($decisions | Where-Object { $_.TargetRelativePath -notmatch '^\.claude/agents/ai-rules-[a-z-]+\.md$' }).Count | Should Be 0
    }

    It 'keeps the preflight and Claude Upgrade apply paths aligned on an isolated target' {
        $target = New-ClaudeAgentTarget
        $plan = @(Get-DeploymentUpgradePreflight -RepoRoot $agentRepo -TargetRoot $target)
        @($plan | Where-Object { $_.platform -eq 'Claude' -and $_.content_type -eq 'Agent' -and $_.planned_action -eq 'ADD' }).Count | Should Be 6
        Mock Invoke-ConfirmGate { return $true } -ModuleName Platform-Claude
        $null = Invoke-ClaudeUpgrade -FrameworkRoot (Join-Path $agentRepo 'Claude') -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        $sources = @(Get-ClaudeAgentSourceFiles -FrameworkRoot (Join-Path $agentRepo 'Claude') -SharedRoot (Join-Path $agentRepo 'Shared'))
        foreach ($source in $sources) {
            $dest = Join-Path $target $source.TargetRelativePath
            (Test-Path -LiteralPath $dest -PathType Leaf) | Should Be $true
            (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash | Should Be (Get-FileHash -LiteralPath $source.SourcePath -Algorithm SHA256).Hash
        }
    }

    It 'updates only an exact source-side historical Agent artifact through the normal apply report' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-reviewer.md'
        $framework = New-ClaudeHistoricalFramework $name
        $oldPath = Join-Path $target ".claude/agents/$name"
        $null = New-Item -ItemType Directory -Path (Split-Path $oldPath -Parent) -Force
        Copy-Item -LiteralPath (Join-Path $framework "agent-history/v0/$name") -Destination $oldPath
        $decision = @(Get-ClaudeAgentProjectionDecisions -FrameworkRoot $framework -SharedRoot (Join-Path $agentRepo 'Shared') -TargetRoot $target | Where-Object TargetRelativePath -eq ".claude/agents/$name")[0]
        $decision.Action | Should Be 'UPDATE'
        $decision.KnownFrameworkHashMatch | Should Be $true
        $report = @(Get-ClaudeAgentUpgradeReport -Decisions @($decision))
        $agentReport = @($report | Where-Object Path -eq "agents/$name")
        $agentReport.Count | Should Be 1
        $agentReport[0].Status | Should Be 'CHANGED'
        $null = Install-Upgrade -Report $agentReport -SourceRoot (Join-Path $framework '.claude') -TargetRoot (Join-Path $target '.claude')
        (Get-FileHash -LiteralPath $oldPath -Algorithm SHA256).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $framework ".claude/agents/$name") -Algorithm SHA256).Hash
    }

    It 'reports UPDATE in full preflight and applies it through Claude Upgrade for a known old Agent' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-reviewer.md'
        $framework = New-ClaudeHistoricalFramework $name
        Copy-Item -LiteralPath (Join-Path $agentRepo 'Claude/.claude/commands') -Destination (Join-Path $framework '.claude/commands') -Recurse
        Copy-Item -LiteralPath (Join-Path $agentRepo 'Claude/.claude/rules') -Destination (Join-Path $framework '.claude/rules') -Recurse
        Copy-Item -LiteralPath (Join-Path $agentRepo 'Claude/.claude/CLAUDE.md') -Destination (Join-Path $framework '.claude/CLAUDE.md')
        Copy-Item -LiteralPath (Join-Path $agentRepo 'Claude/VERSION') -Destination (Join-Path $framework 'VERSION')
        $oldPath = Join-Path $target ".claude/agents/$name"
        $null = New-Item -ItemType Directory -Path (Split-Path $oldPath -Parent) -Force
        Copy-Item -LiteralPath (Join-Path $framework "agent-history/v0/$name") -Destination $oldPath
        $plan = @(Get-DeploymentUpgradePreflight -RepoRoot $agentRepo -TargetRoot $target -ClaudeFrameworkRoot $framework)
        @($plan | Where-Object { $_.target_path -eq ".claude/agents/$name" -and $_.planned_action -eq 'UPDATE' -and $_.known_framework_hash_match }).Count | Should Be 1
        Mock Invoke-ConfirmGate { return $true } -ModuleName Platform-Claude
        $null = Invoke-ClaudeUpgrade -FrameworkRoot $framework -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        (Get-FileHash -LiteralPath $oldPath -Algorithm SHA256).Hash | Should Be (Get-FileHash -LiteralPath (Join-Path $framework ".claude/agents/$name") -Algorithm SHA256).Hash
    }

    It 'leaves an identical existing Agent unchanged' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-verifier.md'
        $source = Join-Path $agentRepo "Claude/.claude/agents/$name"
        $path = Set-ClaudeAgentFixtureFile $target $name ([IO.File]::ReadAllText($source))
        $decision = @(Get-ClaudeAgentFixtureDecisions $target | Where-Object TargetRelativePath -eq ".claude/agents/$name")[0]
        $decision.Action | Should Be 'UNCHANGED'
        $decision.Blocking | Should Be $false
        $report = @(Get-ClaudeAgentUpgradeReport -Decisions @(Get-ClaudeAgentFixtureDecisions $target))
        @($report | Where-Object { $_.Path -eq "agents/$name" -and $_.Status -eq 'SAME' }).Count | Should Be 1
    }

    It 'does not trust a self-declared manifest for a modified Agent' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-researcher.md'
        $path = Set-ClaudeAgentFixtureFile $target $name 'old framework researcher'
        $oldHash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
        Set-ClaudeAgentFixtureManifest $target $name $oldHash
        [IO.File]::WriteAllText($path, 'user modified researcher', [Text.UTF8Encoding]::new($false))
        $before = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        Set-ClaudeAgentFixtureManifest $target $name $before.ToLowerInvariant()
        $decision = @(Get-ClaudeAgentFixtureDecisions $target | Where-Object TargetRelativePath -eq ".claude/agents/$name")[0]
        $decision.Action | Should Be 'PRESERVE'
        $decision.Blocking | Should Be $true
        $result = Invoke-ClaudeUpgrade -FrameworkRoot (Join-Path $agentRepo 'Claude') -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        $result.Succeeded | Should Be $false
        (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash | Should Be $before
        (Get-Content -LiteralPath (Join-Path $target '.claude/VERSION') -Raw).Trim() | Should Be 'old'
    }

    It 'blocks a case-only Agent change rather than treating it as identical' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-reviewer.md'
        $source = Join-Path $agentRepo "Claude/.claude/agents/$name"
        $altered = ([IO.File]::ReadAllText($source)).Replace('name: "ai-rules-reviewer"', 'Name: "ai-rules-reviewer"')
        $null = Set-ClaudeAgentFixtureFile $target $name $altered
        $decision = @(Get-ClaudeAgentFixtureDecisions $target | Where-Object TargetRelativePath -eq ".claude/agents/$name")[0]
        $decision.Action | Should Be 'PRESERVE'
        $decision.Blocking | Should Be $true
    }

    It 'blocks an Agent target whose parent is a file' {
        $target = New-ClaudeAgentTarget
        [IO.File]::WriteAllText((Join-Path $target '.claude/agents'), 'file, not a directory', [Text.UTF8Encoding]::new($false))
        $decisions = @(Get-ClaudeAgentFixtureDecisions $target)
        @($decisions | Where-Object { $_.Action -eq 'BLOCK' -and $_.Reason -eq 'agent_target_ancestor_is_file' }).Count | Should Be 6
    }

    It 'rechecks Agent ownership after confirmation and before any Upgrade write' {
        $target = New-ClaudeAgentTarget
        $global:gate3bConfirmTarget = $target
        Mock Invoke-ConfirmGate {
            $path = Join-Path $global:gate3bConfirmTarget '.claude/agents/ai-rules-reviewer.md'
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            [IO.File]::WriteAllText($path, 'arrived during confirmation', [Text.UTF8Encoding]::new($false))
            return $true
        } -ModuleName Platform-Claude
        $result = Invoke-ClaudeUpgrade -FrameworkRoot (Join-Path $agentRepo 'Claude') -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        $result.Succeeded | Should Be $false
        $result.Reason | Should Be 'AgentProjectionChangedBeforeApply'
        (Get-Content -LiteralPath (Join-Path $target '.claude/VERSION') -Raw).Trim() | Should Be 'old'
        (Test-Path -LiteralPath (Join-Path $target '.claude/agents/ai-rules-verifier.md')) | Should Be $false
    }

    It 'preserves and blocks an unknown Agent without a manifest binding' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-architect.md'
        $path = Set-ClaudeAgentFixtureFile $target $name 'unknown user architect'
        $before = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        $decision = @(Get-ClaudeAgentFixtureDecisions $target | Where-Object TargetRelativePath -eq ".claude/agents/$name")[0]
        $decision.Action | Should Be 'PRESERVE'
        $decision.Blocking | Should Be $true
        $result = Invoke-ClaudeUpgrade -FrameworkRoot (Join-Path $agentRepo 'Claude') -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        $result.Succeeded | Should Be $false
        (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash | Should Be $before
    }

    It 'blocks Fresh before writes when a target contains an unknown Agent' {
        $target = New-ClaudeAgentTarget
        $name = 'ai-rules-reviewer.md'
        $path = Set-ClaudeAgentFixtureFile $target $name 'user reviewer'
        $before = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        $result = Invoke-ClaudeFresh -FrameworkRoot (Join-Path $agentRepo 'Claude') -Target $target -SharedSkillsRoot (Join-Path $agentRepo 'Shared/skills')
        $result.Succeeded | Should Be $false
        (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash | Should Be $before
        (Get-Content -LiteralPath (Join-Path $target '.claude/VERSION') -Raw).Trim() | Should Be 'old'
        (Test-Path -LiteralPath (Join-Path $target '.agents')) | Should Be $false
    }
}
