Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$script:managerModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Manager.Deployment.psm1') -Force -PassThru
$managerSyncSuccessPrefix = [string]::Concat(@(
    [char]0x76EE, [char]0x524D, [char]0x5C08, [char]0x6848, [char]0x898F,
    [char]0x5247, [char]0x540C, [char]0x6B65, [char]0x5B8C, [char]0x6210,
    [char]0xFF1A
))

function Write-ManagerSyncFixtureFile {
    param(
        [string]$Path,
        [string]$Content
    )

    New-Item -ItemType Directory -Force -Path (Split-Path $Path -Parent) | Out-Null
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
}

function New-ManagerCodexSyncFixture {
    param(
        [string]$Root,
        [switch]$MissingPolicyMarker
    )

    $fixtureRepoRoot = Join-Path $Root 'source'
    $projectRoot = Join-Path $Root 'project'
    New-Item -ItemType Directory -Force -Path $fixtureRepoRoot, $projectRoot, (Join-Path $fixtureRepoRoot 'Shared\skills') | Out-Null

    $sourceTemplate = Get-Content -LiteralPath (Join-Path $repoRoot 'Codex\.codex\AGENTS.md') -Raw -Encoding UTF8
    Write-ManagerSyncFixtureFile -Path (Join-Path $fixtureRepoRoot 'Codex\.codex\AGENTS.md') -Content $sourceTemplate
    Write-ManagerSyncFixtureFile -Path (Join-Path $fixtureRepoRoot 'Codex\VERSION') -Content 'test-version'
    Write-ManagerSyncFixtureFile -Path (Join-Path $projectRoot '.codex\AGENTS.md') -Content "# Existing project Codex core`r`n"

    $policyContent = if ($MissingPolicyMarker) {
        "# Intentionally missing Codex policy marker`r`n"
    } else {
        "<!-- SUBAGENT_POLICY:CODEX_START -->`r`nfixture Codex adapter`r`n<!-- SUBAGENT_POLICY:CODEX_END -->`r`n"
    }
    Write-ManagerSyncFixtureFile -Path (Join-Path $fixtureRepoRoot 'Shared\policies\adapters\codex-subagent-invocation.md') -Content $policyContent

    return [PSCustomObject]@{
        RepoRoot = $fixtureRepoRoot
        ProjectRoot = $projectRoot
        PolicyPath = Join-Path $fixtureRepoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
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

function Invoke-ManagerSyncFixtureGit {
    param(
        [string]$RepositoryRoot,
        [string[]]$Arguments
    )

    $output = @(& git -C $RepositoryRoot @Arguments 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw "Fixture Git command failed: git -C $RepositoryRoot $($Arguments -join ' ')`n$($output | Out-String)"
    }
    return $output
}

function Initialize-ManagerSyncFixtureGitRepository {
    param([string]$RepositoryRoot)

    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('init')
    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('config', 'user.name', 'AI Rules Integration Fixture')
    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('config', 'user.email', 'ai-rules-fixture@example.test')
    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('add', '--all')
    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('commit', '--quiet', '-m', 'integration fixture')

    $branch = [string](@(Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('branch', '--show-current')) | Select-Object -First 1)
    if ([string]::IsNullOrWhiteSpace($branch)) { throw 'Fixture Git repository did not create a current branch.' }
    $null = Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('remote', 'add', 'origin', $RepositoryRoot)

    $head = [string](@(Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('rev-parse', 'HEAD')) | Select-Object -First 1)
    $remoteLine = [string](@(Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('ls-remote', 'origin', ("refs/heads/$branch"))) | Select-Object -First 1)
    $remoteHead = if ($remoteLine) { ($remoteLine -split '\s+')[0] } else { '' }
    if ($head -ne $remoteHead) { throw "Fixture Git origin is not synchronized: local=$head remote=$remoteHead." }

    $dirty = @(Invoke-ManagerSyncFixtureGit -RepositoryRoot $RepositoryRoot -Arguments @('status', '--porcelain'))
    if ($dirty.Count -ne 0) { throw "Fixture Git repository must be clean before manager sync: $($dirty -join '; ')" }
}

function Get-ManagerSyncFixtureTreeHash {
    param([string]$Root)

    $records = New-Object System.Collections.Generic.List[string]
    foreach ($item in @(Get-ChildItem -LiteralPath $Root -Force -Recurse | Sort-Object FullName)) {
        $relative = $item.FullName.Substring($Root.Length).TrimStart('\', '/') -replace '\\', '/'
        if ($item.PSIsContainer) {
            $records.Add("directory|$relative")
        } else {
            $fileHash = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash
            $records.Add("file|$relative|$fileHash")
        }
    }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($records | Sort-Object) -join "`n")
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($algorithm.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    } finally {
        $algorithm.Dispose()
    }
}

function New-ManagerSyncIntegrationFixture {
    param(
        [string]$Root,
        [ValidateSet('Valid', 'Missing', 'Invalid')]
        [string]$PolicyState = 'Valid'
    )

    $fixtureRepoRoot = Join-Path $Root 'source'
    $projectRoot = Join-Path $Root 'project'
    New-Item -ItemType Directory -Force -Path $fixtureRepoRoot, $projectRoot | Out-Null

    # The real manager facade only needs these source roots; copying them keeps the fixture
    # isolated while avoiding a full repository copy. .git is intentionally never copied.
    foreach ($sourceName in @('Scripts', 'Shared', 'Codex')) {
        $sourcePath = Join-Path $repoRoot $sourceName
        if (-not (Test-Path -LiteralPath $sourcePath)) { throw "Integration source fixture is missing: $sourcePath" }
        Copy-Item -LiteralPath $sourcePath -Destination $fixtureRepoRoot -Recurse -Force
    }
    if (Test-Path -LiteralPath (Join-Path $fixtureRepoRoot '.git')) {
        throw 'The isolated manager source fixture must not copy the real repository .git directory.'
    }

    $policyPath = Join-Path $fixtureRepoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
    switch ($PolicyState) {
        'Missing' { Remove-Item -LiteralPath $policyPath -Force }
        'Invalid' { Write-ManagerSyncFixtureFile -Path $policyPath -Content "# Invalid Codex policy fixture without the required marker`r`n" }
    }

    Write-ManagerSyncFixtureFile -Path (Join-Path $projectRoot '.codex\AGENTS.md') -Content "# Existing isolated target Codex core`r`n"
    Write-ManagerSyncFixtureFile -Path (Join-Path $projectRoot 'target-sentinel.txt') -Content "Target must remain unchanged when preflight fails.`r`n"
    Initialize-ManagerSyncFixtureGitRepository -RepositoryRoot $fixtureRepoRoot

    return [PSCustomObject]@{
        RepoRoot = $fixtureRepoRoot
        ProjectRoot = $projectRoot
        PolicyState = $PolicyState
    }
}

function Invoke-ManagerSyncIntegrationFixture {
    param([object]$Fixture)

    $runnerPath = Join-Path (Split-Path $Fixture.RepoRoot -Parent) 'run-manager-sync.ps1'
    $runnerContent = @'
param(
    [string]$ManagerScript,
    [string]$RepositoryRoot,
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'
try {
    $result = & $ManagerScript -Action SyncProjectRules -RepoRoot $RepositoryRoot -Target $ProjectRoot -ProjectPlatform Codex -Apply
    if ($null -eq $result) { throw 'AI-RulesManager did not return a SyncProjectRules result.' }
    [PSCustomObject]@{
        Succeeded = [bool]$result.Succeeded
        Applied = [bool]$result.Applied
        Platforms = @($result.Platforms)
        RequiredStageResults = @($result.RequiredStageResults | ForEach-Object {
            [PSCustomObject]@{ Stage = $_.Stage; Status = $_.Status; Succeeded = [bool]$_.Succeeded; Detail = $_.Detail }
        })
    } | ConvertTo-Json -Depth 6 -Compress
    exit 0
} catch {
    [PSCustomObject]@{
        Succeeded = $false
        FailClosed = $true
        ErrorId = $_.FullyQualifiedErrorId
        Message = $_.Exception.Message
    } | ConvertTo-Json -Compress
    exit 1
}
'@
    Write-ManagerSyncFixtureFile -Path $runnerPath -Content $runnerContent

    $powershellPath = (Get-Command -Name powershell.exe -ErrorAction Stop).Path
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $powershellPath -NoProfile -ExecutionPolicy Bypass -File $runnerPath `
            -ManagerScript (Join-Path $Fixture.RepoRoot 'Scripts\AI-RulesManager.ps1') `
            -RepositoryRoot $Fixture.RepoRoot `
            -ProjectRoot $Fixture.ProjectRoot 2>&1)
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    $json = [string](@($output | ForEach-Object { [string]$_ } | Where-Object { $_.TrimStart().StartsWith('{') } | Select-Object -Last 1))
    if ([string]::IsNullOrWhiteSpace($json)) {
        throw "Fixture manager process returned no JSON result (exit $exitCode): $($output | Out-String)"
    }

    try {
        $payload = $json | ConvertFrom-Json -ErrorAction Stop
    } catch {
        throw "Fixture manager process returned invalid JSON (exit $exitCode): $json"
    }

    return [PSCustomObject]@{
        ExitCode = $exitCode
        Payload = $payload
        Output = $output
    }
}

Describe 'Manager project rule sync preflight and outcome aggregation' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-manager-sync-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
        Mock -CommandName Assert-ManagerSourceSyncedForProjectSync -ModuleName $script:managerModule.Name -MockWith { }
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
    }

    It 'uses the Codex adapter source and returns a consistent successful stage result' {
        $fixture = New-ManagerCodexSyncFixture -Root $script:tempRoot

        $output = @(Invoke-ManagerSyncProjectRules -RepoRoot $fixture.RepoRoot -Target $fixture.ProjectRoot -ProjectPlatform Codex -Apply 6>&1)
        $result = Get-ManagerSyncResultFromOutput -Output $output

        if (-not $result.Succeeded) { throw 'The valid Codex adapter fixture must produce a successful manager result.' }
        if ($result.RequiredStageResults.Count -ne 4) { throw "Expected four required apply stages; received $($result.RequiredStageResults.Count)." }
        if (@($result.RequiredStageResults | Where-Object { $_.Status -ne 'Succeeded' }).Count -ne 0) {
            throw 'A successful manager result contained a failed or skipped required stage.'
        }
        $outputText = $output | Out-String
        if ($outputText -notmatch ($managerSyncSuccessPrefix + 'Codex')) {
            throw 'The successful manager result did not emit its final success message.'
        }

        $sourceContent = Get-Content -LiteralPath (Join-Path $fixture.RepoRoot 'Codex\.codex\AGENTS.md') -Raw -Encoding UTF8
        $targetContent = Get-Content -LiteralPath (Join-Path $fixture.ProjectRoot '.codex\AGENTS.md') -Raw -Encoding UTF8
        if ($targetContent -cne $sourceContent) { throw 'The synced Codex core did not retain the source generated pointer template.' }
    }

    It 'fails before target mutation when the required Codex adapter marker is missing' {
        $fixture = New-ManagerCodexSyncFixture -Root $script:tempRoot -MissingPolicyMarker
        $targetPath = Join-Path $fixture.ProjectRoot '.codex\AGENTS.md'
        $before = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        $caught = $null
        try {
            $null = Invoke-ManagerSyncProjectRules -RepoRoot $fixture.RepoRoot -Target $fixture.ProjectRoot -ProjectPlatform Codex -Apply
        } catch {
            $caught = $_
        }

        if ($null -eq $caught) { throw 'The manager must fail closed when its required adapter marker is missing.' }
        if ($caught.FullyQualifiedErrorId -notmatch '^SharedPolicy\.PolicyBlockMissing') {
            throw "Expected the adapter marker failure code; received $($caught.FullyQualifiedErrorId)."
        }
        $after = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($before -cne $after) { throw 'Manager preflight wrote the target before detecting its missing adapter marker.' }
        if (Test-Path -LiteralPath (Join-Path $fixture.ProjectRoot '.codex\VERSION')) { throw 'Manager preflight wrote a version file before failing.' }
        if (Test-Path -LiteralPath (Join-Path $fixture.ProjectRoot '.agents')) { throw 'Manager preflight created agent infrastructure before failing.' }
    }

    It 'returns a failed aggregate result and suppresses final success after a required stage fails' {
        $fixture = New-ManagerCodexSyncFixture -Root $script:tempRoot
        [System.IO.File]::WriteAllText((Join-Path $fixture.ProjectRoot '.agents'), 'block required skills sync', [System.Text.UTF8Encoding]::new($false))

        $output = @(Invoke-ManagerSyncProjectRules -RepoRoot $fixture.RepoRoot -Target $fixture.ProjectRoot -ProjectPlatform Codex -Apply 6>&1)
        $result = Get-ManagerSyncResultFromOutput -Output $output

        if ($result.Succeeded) { throw 'A failed required stage must not return a successful manager result.' }
        $failedRequiredStages = @($result.RequiredStageResults | Where-Object { $_.Status -eq 'Failed' })
        if ($failedRequiredStages.Count -eq 0) {
            throw 'The aggregate result did not retain the required stage failure.'
        }
        $skippedRequiredStages = @($result.RequiredStageResults | Where-Object { $_.Status -eq 'Skipped' })
        if ($skippedRequiredStages.Count -eq 0) {
            throw 'The aggregate result did not mark downstream required stages as skipped.'
        }
        $outputText = $output | Out-String
        if ($outputText -match $managerSyncSuccessPrefix) {
            throw 'Manager emitted its final success message after a required stage failed.'
        }
    }
}

Describe 'Manager project rule sync real-path integration' {
    BeforeEach {
        $script:realTempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-manager-sync-real-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:realTempRoot | Out-Null
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:realTempRoot) {
            Remove-Item -LiteralPath $script:realTempRoot -Recurse -Force
        }
        if (Test-Path -LiteralPath $script:realTempRoot) {
            throw "Integration fixture cleanup failed: $script:realTempRoot"
        }
    }

    It 'runs the real AI-RulesManager deployment and project-sync path for a clean valid Codex source' {
        $fixture = New-ManagerSyncIntegrationFixture -Root $script:realTempRoot -PolicyState Valid

        $process = Invoke-ManagerSyncIntegrationFixture -Fixture $fixture
        if ($process.ExitCode -ne 0) {
            throw "Valid real-path sync must exit zero; received $($process.ExitCode): $($process.Output | Out-String)"
        }
        if (-not $process.Payload.Succeeded -or -not $process.Payload.Applied) {
            throw 'Valid real-path sync must return a successful applied SyncProjectRules result.'
        }
        if (@($process.Payload.Platforms).Count -ne 1 -or @($process.Payload.Platforms)[0] -cne 'Codex') {
            throw 'Valid real-path sync must select exactly the installed Codex platform.'
        }
        $stages = @($process.Payload.RequiredStageResults)
        if ($stages.Count -ne 4) { throw "Valid real-path sync must return four required stages; received $($stages.Count)." }
        if (@($stages | Where-Object { $_.Status -ne 'Succeeded' }).Count -ne 0) {
            throw 'Valid real-path sync returned a failed or skipped required stage.'
        }

        $sourceCorePath = Join-Path $fixture.RepoRoot 'Codex\.codex\AGENTS.md'
        $targetCorePath = Join-Path $fixture.ProjectRoot '.codex\AGENTS.md'
        $sourceCore = Get-Content -LiteralPath $sourceCorePath -Raw -Encoding UTF8
        $targetCore = Get-Content -LiteralPath $targetCorePath -Raw -Encoding UTF8
        if ($targetCore -cne $sourceCore) { throw 'Real-path Codex sync did not deploy the validated source core exactly.' }

        $generatedPointer = @(
            '### Shared Subagent Invocation Policy (generated pointer)',
            '',
            'This marker is generated by `Sync-SharedPolicyBlock` from `Shared/policies/adapters/codex-subagent-invocation.md`.',
            'The full Codex adapter and its referenced Shared contracts remain canonical in that source and are deployed under `.agents/shared/`.',
            'Do not hand-edit this generated marker.'
        ) -join "`n"
        $normalizedTargetCore = $targetCore -replace "`r`n|`r", "`n"
        if ($normalizedTargetCore.IndexOf($generatedPointer, [System.StringComparison]::Ordinal) -lt 0) {
            throw 'Real-path Codex sync did not retain the generated policy pointer.'
        }
    }

    It 'fails closed without target writes when the Codex policy is <PolicyState>' -TestCases @(
        @{ PolicyState = 'Missing'; ExpectedErrorId = '^SharedPolicy\.PolicyFileMissing' },
        @{ PolicyState = 'Invalid'; ExpectedErrorId = '^SharedPolicy\.PolicyBlockMissing' }
    ) {
        param(
            [string]$PolicyState,
            [string]$ExpectedErrorId
        )

        $fixture = New-ManagerSyncIntegrationFixture -Root $script:realTempRoot -PolicyState $PolicyState
        $beforeHash = Get-ManagerSyncFixtureTreeHash -Root $fixture.ProjectRoot

        $process = Invoke-ManagerSyncIntegrationFixture -Fixture $fixture
        $afterHash = Get-ManagerSyncFixtureTreeHash -Root $fixture.ProjectRoot

        if ($process.ExitCode -eq 0) { throw "Missing or invalid policy '$PolicyState' must produce a non-zero fail-closed exit code." }
        if (-not $process.Payload.FailClosed -or $process.Payload.Succeeded) {
            throw "Missing or invalid policy '$PolicyState' did not return a recognizable fail-closed result."
        }
        if ([string]$process.Payload.ErrorId -notmatch $ExpectedErrorId) {
            throw "Missing or invalid policy '$PolicyState' returned unexpected failure identity: $($process.Payload.ErrorId)"
        }
        if ($beforeHash -cne $afterHash) {
            throw "Fail-closed target tree hash changed for '$PolicyState': before=$beforeHash after=$afterHash"
        }
    }
}
