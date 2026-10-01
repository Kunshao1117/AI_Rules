Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$m5cRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$m5cRoot = if ($env:M5C_REPORT_ROOT) { [IO.Path]::GetFullPath($env:M5C_REPORT_ROOT) } else { Join-Path $env:TEMP ('AI_Rules_M5C_tests_' + [guid]::NewGuid().ToString('N')) }
$m5cRoot = [IO.Path]::GetFullPath($m5cRoot)
if ($m5cRoot -eq $m5cRepo -or $m5cRoot.StartsWith($m5cRepo + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'M5C fixture must be external' }
$null = New-Item -ItemType Directory -Path $m5cRoot -Force
Import-Module (Join-Path $m5cRepo 'Scripts/modules/Deployment.Cohort.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $m5cRepo 'Scripts/modules/Deployment.Transaction.psm1') -DisableNameChecking
Import-Module (Join-Path $m5cRepo 'Scripts/modules/Skills-Sync.psm1') -DisableNameChecking
Import-Module (Join-Path $m5cRepo 'Scripts/modules/Platform-Codex.psm1') -DisableNameChecking
$script:m5cHistorical = (Get-Content -LiteralPath (Join-Path $m5cRepo 'Tests/TeamNative/m5c-historical-provenance-fixture.json') -Raw -Encoding UTF8 | ConvertFrom-Json).approved_preimages

function New-M5CCase([string]$Name,[switch]$Old) {
    $root = Join-Path $m5cRoot ($Name + '-' + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $root -Force
    if ($Old) {
        # Seed only independently sealed historical bytes, never a source-root
        # runtime that exists on the developer's computer but not in Git.
        foreach ($entry in $script:m5cHistorical.PSObject.Properties) {
            $to = Join-Path $root $entry.Name
            $null = New-Item -ItemType Directory -Path (Split-Path $to -Parent) -Force
            $inputStream = [IO.MemoryStream]::new([Convert]::FromBase64String($entry.Value.gzip_base64))
            $gzip = [IO.Compression.GZipStream]::new($inputStream, [IO.Compression.CompressionMode]::Decompress)
            $outputStream = [IO.MemoryStream]::new()
            try {
                $gzip.CopyTo($outputStream)
                [IO.File]::WriteAllBytes($to, $outputStream.ToArray())
            } finally { $gzip.Dispose(); $inputStream.Dispose(); $outputStream.Dispose() }
            if ((Get-FileHash -LiteralPath $to).Hash.ToLowerInvariant() -cne $entry.Value.sha256) {
                throw "Historical M5C fixture integrity failure: $($entry.Name)"
            }
        }
    }
    foreach ($rel in @('.agents/memory/sentinel/MEMORY.md','.agents/context/_map/CONTEXT.md','.agents/project_skills/_index.md','.cartridge/index.json','.claude/sentinel.txt','.cursor/sentinel.txt','.agents/logs/sentinel.txt')) {
        $to=Join-Path $root $rel; $null=New-Item -ItemType Directory -Path (Split-Path $to -Parent) -Force
        [IO.File]::WriteAllText($to,'protected sentinel',[Text.UTF8Encoding]::new($false))
    }
    return $root
}
function Assert-M5CFrozenSentinels([string]$Root) {
    foreach ($rel in @('.agents/memory/sentinel/MEMORY.md','.agents/context/_map/CONTEXT.md','.agents/project_skills/_index.md','.cartridge/index.json','.claude/sentinel.txt','.cursor/sentinel.txt','.agents/logs/sentinel.txt')) {
        [IO.File]::ReadAllText((Join-Path $Root $rel)) | Should Be 'protected sentinel'
    }
}
function Invoke-M5CFixtureTransaction([string]$Root,[object]$Plan,[switch]$InjectFailure) {
    if (-not $Root.StartsWith($m5cRoot + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'M5C fixture target escape' }
    if (-not $Plan.Ready -or $Plan.TargetRoot -cne $Root -or $Plan.AuthorizationGranted) { throw 'M5C fixture plan not ready' }
    $point = New-DeploymentRollbackPoint -TargetRoot $Root -StoreRoot (Join-Path $m5cRoot 'rollback') -Entries $Plan.ExactEntries -SourceRevision $Plan.SourceFingerprint -Platform $Plan.MinimumSafeDeploymentUnit -RuntimeInstance 'isolated-M5C-fixture-not-installed-runtime'
    Invoke-DeploymentTransaction -TargetRoot $Root -RollbackPointPath $point -Action {
        $i=0
        foreach ($e in $Plan.ExactEntries) {
            $path = Resolve-DeploymentRecoveryPath -TargetRoot $Root -RelativePath $e.RelativePath
            if ($e.Action -eq 'RETIRE') { if(Test-Path -LiteralPath $path){Remove-Item -LiteralPath $path -Force} }
            else {
                $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
                [IO.File]::WriteAllBytes($path,[Convert]::FromBase64String($e.ProjectedBytesBase64))
            }
            $i++
            if($InjectFailure -and $i -eq 7){throw 'injected fixture failure'}
        }
    }
    Complete-DeploymentRollbackPoint -Path $point -TargetRoot $Root
    return $point
}

$script:m5cOfficial = Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot (New-M5CCase 'official-preimage' -Old)

Describe 'M5C independent provenance and honest shared cohort' {
    It 'has no unknown preimage and records exact final bytes for the official shared unit' {
        $script:m5cOfficial.Ready | Should Be $true
        @($script:m5cOfficial.ExactEntries | Where-Object { $_.CurrentSha256 -and $_.Classification -eq 'UNKNOWN_PROVENANCE' }).Count | Should Be 0
        foreach($e in $script:m5cOfficial.ExactEntries | Where-Object Action -ne 'RETIRE') {
            $sha=[Security.Cryptography.SHA256]::Create()
            try{$actual=[BitConverter]::ToString($sha.ComputeHash([Convert]::FromBase64String($e.ProjectedBytesBase64))).Replace('-','').ToLowerInvariant()}finally{$sha.Dispose()}
            $actual | Should Be $e.IntendedSha256
        }
    }
    It 'separates Claude private projection and activation from shared impact' {
        @($script:m5cOfficial.ExactEntries | Where-Object RelativePath -Match '^\.(claude|cursor)/').Count | Should Be 0
        ($script:m5cOfficial.AffectedPlatforms -join ',') | Should Be 'Codex,Antigravity'
        $script:m5cOfficial.ClaudePrivateActivation | Should Be $false
        $script:m5cOfficial.MemoryMutationActivation | Should Be $false
        @($script:m5cOfficial.ActivatedPlatforms).Count | Should Be 0
    }
    It 'rejects an unknown hash even if the old path is known' {
        $result=Get-CohortFrameworkProvenance -RepoRoot $m5cRepo -RelativePath '.agents/skills/delegation-strategy/SKILL.md' -CurrentSha256 ('a'*64)
        $result.Classification | Should Be 'UNKNOWN_PROVENANCE'
        @($result.KnownSha256).Count | Should Be 0
    }
    It 'retains the All+58 decision guard for unproven archive resolutions' {
        $text=Get-Content (Join-Path $m5cRepo 'Scripts/modules/Runtime-Copy-Resolution.psm1') -Raw
        $text | Should Match 'SelectedPlatform'
        $text | Should Match '58'
        $script:m5cOfficial.LegacyResolverConstraint | Should Match 'All\+58 remains'
    }
    It 'matches generated entry hashes to the actual isolated production writer' {
        $root=New-M5CCase 'generated-writer'
        foreach($platform in @('Codex','Antigravity')) {
            $relative=if($platform -eq 'Codex'){'.codex/AGENTS.md'}else{'.agents/rules/00_core_identity.md'}
            $template=Join-Path $m5cRepo ($platform+'/'+$relative)
            $path=Join-Path $root $relative; $null=New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            Copy-Item -LiteralPath $template -Destination $path
            $adapter=Join-Path $m5cRepo ('Shared/policies/adapters/'+$platform.ToLowerInvariant()+'-subagent-invocation.md')
            $before=if($platform -eq 'Antigravity'){'(?m)^## 2\. Agentic Swarm UI Visibility'}else{''}
            $after=if($platform -eq 'Codex'){'(?m)^Codex-specific governance:\s*$'}else{''}
            Sync-SharedPolicyBlock -PolicyPath $adapter -TargetPath $path -Platform $platform -InsertBeforePattern $before -InsertAfterPattern $after | Out-Null
            (Get-FileHash $path).Hash.ToLowerInvariant() | Should Be (@($script:m5cOfficial.ExactEntries | Where-Object RelativePath -eq $relative)[0].IntendedSha256)
        }
    }
    It 'rehearses fresh target, generated bytes, shared routes and post-success rollback' {
        $root=New-M5CCase 'fresh'
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot $root
        $plan.Ready | Should Be $true
        $point=Invoke-M5CFixtureTransaction -Root $root -Plan $plan
        (Get-FileHash (Join-Path $root '.codex/AGENTS.md')).Hash.ToLowerInvariant() | Should Be (@($plan.ExactEntries | Where-Object RelativePath -eq '.codex/AGENTS.md')[0].IntendedSha256)
        Assert-M5CFrozenSentinels $root
        $script:m5cFresh=$root; $script:m5cFreshPoint=$point
        $result=Restore-DeploymentRollbackPoint -Path $point -TargetRoot $root
        $result.Restored | Should Be $true
        Test-Path (Join-Path $root '.codex/AGENTS.md') | Should Be $false
        Assert-M5CFrozenSentinels $root
    }
    It 'rehearses known-old target and leaves Claude and protected data intact' {
        $root=New-M5CCase 'known-old' -Old
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot $root
        $plan.Ready | Should Be $true
        $point=Invoke-M5CFixtureTransaction -Root $root -Plan $plan
        foreach($e in $plan.ExactEntries | Where-Object Action -eq 'RETIRE'){Test-Path (Join-Path $root $e.RelativePath) | Should Be $false}
        $retired=@(Get-Content (Join-Path $m5cRepo 'Shared/policies/references/legacy-skill-migration.json') -Raw | ConvertFrom-Json).artifacts.skill | Select-Object -Unique
        foreach($f in @(Get-ChildItem (Join-Path $root '.agents/workflows') -File)) {
            $text=Get-Content $f.FullName -Raw
            foreach($match in [regex]::Matches($text,'(?m)^required_skills:\s*\[([^\]]*)\]')){
                foreach($id in @($match.Groups[1].Value.Split(',') | ForEach-Object {$_.Trim()} | Where-Object {$_})){$id -in $retired | Should Be $false}
            }
        }
        Assert-M5CFrozenSentinels $root
        Restore-DeploymentRollbackPoint -Path $point -TargetRoot $root | Out-Null
        foreach($e in $plan.ExactEntries | Where-Object CurrentSha256){(Get-FileHash (Join-Path $root $e.RelativePath)).Hash.ToLowerInvariant() | Should Be $e.CurrentSha256}
        Assert-M5CFrozenSentinels $root
    }
    It 'preserves and blocks a user modification before point creation or overwrite' {
        $root=New-M5CCase 'modified' -Old
        $path=Join-Path $root '.agents/skills/delegation-strategy/SKILL.md'
        [IO.File]::AppendAllText($path,"`nUSER MODIFICATION")
        $before=(Get-FileHash $path).Hash
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot $root
        $plan.Ready | Should Be $false
        { Invoke-M5CFixtureTransaction -Root $root -Plan $plan } | Should Throw 'M5C fixture plan not ready'
        (Get-FileHash $path).Hash | Should Be $before
        Assert-M5CFrozenSentinels $root
    }
    It 'preserves the entire hook set when a member has unknown bytes' {
        $root=New-M5CCase 'hooks' -Old
        $path=Join-Path $root '.codex/hooks/team-native-gate.ps1'
        [IO.File]::AppendAllText($path,"`nUNKNOWN HOOK")
        $preview=Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $root
        $preview.WouldRemoveCount | Should Be 0
        $preview.WouldPreserveCount | Should Be 3
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot $root
        $plan.Ready | Should Be $false
        Test-Path $path | Should Be $true
    }
    It 'recovers a failed transaction using the same exact managed point' {
        $root=New-M5CCase 'fault' -Old
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $m5cRepo -TargetRoot $root
        { Invoke-M5CFixtureTransaction -Root $root -Plan $plan -InjectFailure } | Should Throw 'injected fixture failure'
        foreach($e in $plan.ExactEntries | Where-Object CurrentSha256){(Get-FileHash (Join-Path $root $e.RelativePath)).Hash.ToLowerInvariant() | Should Be $e.CurrentSha256}
        Assert-M5CFrozenSentinels $root
    }
    It 'rejects protected paths and an internal backup destination' {
        $root=New-M5CCase 'unsafe'
        foreach($rel in @('.agents/memory/card/MEMORY.md','.agents/context/_map/CONTEXT.md','.cartridge/index.json','.git/config','.agents/logs/x','.codex/auth.json')){
            { Resolve-DeploymentRecoveryPath -TargetRoot $root -RelativePath $rel } | Should Throw 'Deployment.RecoveryUnsafePath'
        }
        {New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $root 'backup') -Entries @(@{RelativePath='.codex/AGENTS.md';KnownSha256=@();IntendedSha256=('a'*64)}) -SourceRevision 'fixture' -Platform 'fixture' -RuntimeInstance 'fixture'} | Should Throw 'Deployment.RecoveryStoreInsideTarget'
    }
    It 'config merge preserves user settings instead of treating the full file as framework owned' {
        $root=New-M5CCase 'config'
        $path=Join-Path $root '.codex/config.toml'; $null=New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
        [IO.File]::WriteAllText($path,"# user comment`nmodel = 'user-model'`n[features]`nmulti_agent = false`n[custom]`nkey = 'user-value'`n")
        $merge=Merge-CodexConfigDefaults -SourcePath (Join-Path $m5cRepo 'Codex/.codex/config.toml') -TargetPath $path
        $merge.ProjectedText | Should Match "model = 'user-model'"
        $merge.ProjectedText | Should Match "key = 'user-value'"
        $merge.ProjectedText | Should Match 'multi_agent = true'
        [IO.File]::ReadAllText($path) | Should Match 'multi_agent = false'
        # A mixed user preimage is not automatically approved for a whole-file
        # recovery point. It remains outside the current exact-owned cohort.
        (Get-CohortFrameworkProvenance -RepoRoot $m5cRepo -RelativePath '.codex/config.toml' -CurrentSha256 ((Get-FileHash $path).Hash.ToLowerInvariant())).Classification | Should Be 'UNKNOWN_PROVENANCE'
    }
}
