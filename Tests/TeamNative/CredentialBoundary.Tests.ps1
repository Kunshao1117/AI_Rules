Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Import-Module (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1') -Force

function Get-CredentialBoundaryContent {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Expected credential-boundary file is missing: $RelativePath"
    }

    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

$contract = Get-CredentialBoundaryContent 'Shared\policies\references\credential-boundary-contract.md'
$registry = Get-CredentialBoundaryContent 'Shared\policies\references\protected-action-registry.md'
$authorization = Get-CredentialBoundaryContent 'Shared\policies\authorization-resolution.md'
$teamCore = Get-CredentialBoundaryContent 'Shared\policies\team-native-core.md'
$matrix = Get-CredentialBoundaryContent 'Shared\platform-capability-matrix.md'
$phases = Get-CredentialBoundaryContent 'Shared\policies\references\authorization-phase-registry.md'
$routing = Get-CredentialBoundaryContent 'Shared\policies\execution-routing.md'

$positiveCases = @(
    @{ Id = 'P1'; Required = @('APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION', 'opaque, non-secret path or reference', 'existing product-owned, read-only', 'exact product project root') },
    @{ Id = 'P2'; Required = @('in-project default credential location', 'project_root/.env', 'same classification') },
    @{ Id = 'P3'; Required = @('ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE', 'approved observation/capture', 'exact ordinary local runtime outputs') },
    @{ Id = 'P4'; Required = @('without verified trusted-envelope capability', 'not an automatic block', 'ordinary execution receipt') }
)

$negativeCases = @(
    @{ Id = 'N1'; Required = 'Opening, reading, displaying, parsing, summarizing, searching, OCRing, or hashing secret content' },
    @{ Id = 'N2'; Required = 'Probing a credential file for content or metadata' },
    @{ Id = 'N3'; Required = 'Copying, moving, renaming, linking, deleting, or modifying a credential file' },
    @{ Id = 'N4'; Required = 'secret value in an argument, ordinary environment variable, log, artifact, prompt, memory, or output' },
    @{ Id = 'N5'; Required = 'Symlinks, multiple candidates, fallback discovery' },
    @{ Id = 'N6'; Required = 'Account, position, balance, P&L, payment, order, modify-order, delete-order, deployment, and all external mutation' },
    @{ Id = 'N7'; Required = 'Runtime target is outside allowlist, destructive, sealed, or a production database' },
    @{ Id = 'N8'; Required = 'Git, release, install, memory mutation, or destructive filesystem operation' }
)

Describe 'Credential boundary contract' {
    It 'classifies agent secret handling as protected and product-owned consumption as fail-closed non-protected' {
        $contract | Should Match '`AGENT_SECRET_HANDLING` \| yes'
        $contract | Should Match '`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION` \| no, when eligible'
        $contract | Should Match 'All conditions below are required'
        $contract | Should Match 'reclassifies the action to `AGENT_SECRET_HANDLING`'
        $registry | Should Match 'Agent secret read/reveal/create/modify, permission mutation, privilege escalation \| `protected.credential_privilege`'
        $registry | Should Match 'credential-boundary-contract\.md'
    }

    It 'contains machine-testable positive contract cases P1 through P4' {
        $normalizedContract = $contract -replace '\s+', ' '
        foreach ($case in $positiveCases) {
            foreach ($required in $case.Required) {
                if (-not $normalizedContract.Contains($required)) {
                    throw "$($case.Id) is missing required contract text: $required"
                }
            }
        }
    }

    It 'contains machine-testable negative and attack contract cases' {
        $normalizedContract = $contract -replace '\s+', ' '
        foreach ($case in $negativeCases) {
            if (-not $normalizedContract.Contains($case.Required)) {
                throw "$($case.Id) is missing required contract text: $($case.Required)"
            }
        }
    }

    It 'separates general native evidence from frozen Memory cryptographic compatibility' {
        $general = ($authorization -split '## Legacy Memory Compatibility')[0]
        $general | Should Match 'General observe/local_work/protected actions do not universally require'
        $general | Should Match 'Platform denial stops the affected action'
        $general | Should Not Match 'A protected mutation requires a trusted tool execution envelope'
        $authorization | Should Match 'LEGACY_MEMORY_AUTHORIZATION_START'
        $teamCore | Should Match 'Legacy Memory Compatibility . Frozen Envelope Consumer Only'
        $matrix | Should Match 'only an actually required native evidence contract can require cryptographic proof'
    }

    It 'preserves the legacy product runtime phase without requiring it for general local_work' {
        $phases | Should Match '`product-runtime-execution` \| external observation plus scoped local runtime write \| no'
        $phases | Should Match 'It does not authorize agent secret handling, source write, Git, account/order action, deployment, or external mutation'
        $contract | Should Match 'General local_work does not require that\s+phase'
        $routing | Should Match 'It can read relevant scope and perform authorized `local_work`'
        $authorization | Should Match 'Local commit, branch create/switch, staging and stash\s+require explicit inclusion'
    }

    It 'does not store a realistic secret-shaped value in the changed credential-boundary sources' {
        $changedPaths = @(
            'Shared\policies\references\credential-boundary-contract.md',
            'Shared\policies\references\protected-action-registry.md',
            'Shared\policies\authorization-resolution.md',
            'Shared\policies\team-native-core.md',
            'Shared\platform-capability-matrix.md',
            'Shared\policies\references\authorization-phase-registry.md',
            'Tests\TeamNative\CredentialBoundary.Tests.ps1'
        )
        $realisticSecretPattern = '(?i)(?:\bAKIA[0-9A-Z]{16}\b|\bsk-[A-Za-z0-9]{20,}\b|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----)'
        foreach ($relativePath in $changedPaths) {
            $content = Get-CredentialBoundaryContent $relativePath
            if ($content -match $realisticSecretPattern) {
                throw "Secret-shaped content is not allowed in $relativePath"
            }
        }
    }

}

# Explicitly opt in only when isolated sync/deployment is authorized.
Describe 'Credential boundary isolated deployment' -Tag 'Deployment' {
    It 'keeps all changed Shared governance files byte-identical with managed runtime copies' {
        $runtimeRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ai-rules-credential-boundary-' + [guid]::NewGuid())
        $agentsRoot = Join-Path $runtimeRoot '.agents'
        $pairs = @(
            @{ Source = 'Shared\policies\references\credential-boundary-contract.md'; Runtime = '.agents\shared\policies\references\credential-boundary-contract.md' },
            @{ Source = 'Shared\policies\references\protected-action-registry.md'; Runtime = '.agents\shared\policies\references\protected-action-registry.md' },
            @{ Source = 'Shared\policies\authorization-resolution.md'; Runtime = '.agents\shared\policies\authorization-resolution.md' },
            @{ Source = 'Shared\policies\team-native-core.md'; Runtime = '.agents\shared\policies\team-native-core.md' },
            @{ Source = 'Shared\platform-capability-matrix.md'; Runtime = '.agents\shared\platform-capability-matrix.md' },
            @{ Source = 'Shared\policies\references\authorization-phase-registry.md'; Runtime = '.agents\shared\policies\references\authorization-phase-registry.md' }
        )
        try {
            New-Item -ItemType Directory -Force -Path $runtimeRoot | Out-Null
            $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $repoRoot 'Shared') -TargetAgentsRoot $agentsRoot -Mode Full
            foreach ($pair in $pairs) {
                $sourcePath = Join-Path $repoRoot $pair.Source
                $runtimePath = Join-Path $runtimeRoot $pair.Runtime
                if (-not (Test-Path -LiteralPath $runtimePath -PathType Leaf)) {
                    throw "Managed runtime copy is missing after sync: $($pair.Runtime)"
                }
                if ((Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash) {
                    throw "Source/runtime parity failed: $($pair.Source)"
                }
            }
        } finally {
            if (Test-Path -LiteralPath $runtimeRoot) {
                Remove-Item -LiteralPath $runtimeRoot -Recurse -Force
            }
        }
    }
}
