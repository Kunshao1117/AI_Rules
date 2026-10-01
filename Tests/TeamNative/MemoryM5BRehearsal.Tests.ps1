Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$m5bRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$m5bShared = Join-Path $m5bRepo 'Shared'
$m5bRoot = if ($env:M5B_REPORT_ROOT) { [IO.Path]::GetFullPath($env:M5B_REPORT_ROOT) } else { Join-Path $env:TEMP ('AI_Rules_M5B_tests_' + [guid]::NewGuid().ToString('N')) }
if ($m5bRoot -eq $m5bRepo -or $m5bRoot.StartsWith($m5bRepo + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'M5B fixture must be outside the source repo' }
$null = New-Item -ItemType Directory -Path $m5bRoot -Force
function Reset-M5BProjectionModules {
    # Pester 3.4 restores mocks into the original module instance. Reimporting
    # a facade with -Force can leave a platform bound to that old instance.
    # Discard only this fixture source's modules before loading a fresh graph.
    $modulesRoot = [IO.Path]::GetFullPath((Join-Path $m5bRepo 'Scripts/modules')) + [IO.Path]::DirectorySeparatorChar
    @(Get-Module -All | Where-Object {
        $_.Path -and $_.Path.StartsWith($modulesRoot, [StringComparison]::OrdinalIgnoreCase)
    }) | Remove-Module -Force
    foreach ($module in @('Core','Skills-Sync','Skill-Migration','Platform-Codex','Platform-Claude','Platform-Cursor','Platform-Antigravity','Deployment.Transaction')) {
        Import-Module (Join-Path $m5bRepo "Scripts/modules/$module.psm1") -DisableNameChecking
    }
    # Supply only fixture-runner consent, without Pester's imported-command
    # mock teardown. Target validation remains in Invoke-M5BProjection.
    foreach ($module in @('Platform-Codex','Platform-Claude','Platform-Cursor','Platform-Antigravity')) {
        $modulePath = [IO.Path]::GetFullPath((Join-Path $m5bRepo "Scripts/modules/$module.psm1"))
        $owner = @(Get-Module -All | Where-Object { $_.Path -eq $modulePath })
        if ($owner.Count -ne 1) { throw "M5B expected one platform module at $modulePath" }
        & $owner[0] { function script:Invoke-ConfirmGate { param([string]$Message) return $true } }
    }
}
function Get-M5BModuleOwner([string]$Name) {
    $path = [IO.Path]::GetFullPath((Join-Path $m5bRepo "Scripts/modules/$Name.psm1"))
    $owners = @(Get-Module -All -Name $Name)
    if ($owners.Count -ne 1 -or $owners[0].Path -ne $path) {
        throw "M5B fault module identity is ambiguous: $path"
    }
    return $owners[0]
}
function Invoke-M5BWithFault([string]$ModuleName,[string]$CommandName,[scriptblock]$Fault,[scriptblock]$Action) {
    # Pester 3 mock restoration can retain an imported function's old mock in
    # another module. A scoped shadow with explicit restoration avoids that
    # shared mock table while still exercising the real transaction and writer.
    $owner = Get-M5BModuleOwner $ModuleName
    $saved = & $owner {
        param($name,$fault)
        $existing = Get-Command -Name $name -ErrorAction Stop
        $isFunction = $existing.CommandType -eq 'Function'
        $state = [pscustomobject]@{ Existed=$isFunction; Body=if($isFunction){$existing.ScriptBlock}else{$null} }
        $null = $ExecutionContext.InvokeProvider.Item.Set("Function:\script:$name", $fault, $true, $true)
        return $state
    } $CommandName $Fault
    try { & $Action }
    finally {
        & $owner {
            param($name,$state)
            if ($state.Existed) { $null = $ExecutionContext.InvokeProvider.Item.Set("Function:\script:$name", $state.Body, $true, $true) }
            else { $ExecutionContext.InvokeProvider.Item.Remove("Function:\$name", $false, $true, $true) }
        } $CommandName $saved
    }
}
Reset-M5BProjectionModules
$m5bOld = @('team-specialist-memory-docs','team-memory-docs-delivery-artifact','team-specialist-memory-closure','team-memory-closure-delivery-artifact')
$script:m5bFresh = @{}; $script:m5bGolden = ''; $script:m5bResults = @()

function New-M5BFixture([string]$Kind) {
    $root = Join-Path $m5bRoot ("fixtures/$Kind-" + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $root -Force
    Assert-DeploymentPathUnlinked -Path $root
    return $root
}
function Get-M5BHash([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}
function Get-M5BTextHash([string]$Text) {
    return [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($Text))).Replace('-','').ToLowerInvariant()
}
function Set-M5BText([string]$Root,[string]$Relative,[string]$Text) {
    $path = Join-Path $Root $Relative
    $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
    [IO.File]::WriteAllText($path,$Text,[Text.UTF8Encoding]::new($false))
    return $path
}
function Get-M5BInventory([string]$Root) {
    $map = @{}
    Get-ChildItem -LiteralPath $Root -Recurse -Force -File | ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length+1).Replace('\','/')
        if ($rel -match '^(\.agents/(shared|skills|tools|rules|workflows|agents)/|\.agents/VERSION|\.(codex|claude|cursor)/|\.gitignore$)') {
            $map[$rel] = Get-M5BHash $_.FullName
        }
    }
    return $map
}
function Get-M5BFingerprint([string]$Root) {
    $map = Get-M5BInventory $Root
    return (@($map.Keys | Sort-Object | ForEach-Object { $_ + ':' + $map[$_] }) -join "`n")
}
function Invoke-M5BProjection([string]$Root,[string]$Platform,[string]$Mode) {
    if (-not $Root.StartsWith($m5bRoot + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'M5B target escape' }
    Assert-DeploymentPathUnlinked -Path $Root
    $command = if ($Platform -eq 'Antigravity') { "Invoke-Ag$Mode" } else { "Invoke-$Platform$Mode" }
    # Production platform functions and real copy/sync/retirement logic. Only
    # the interactive confirmation is supplied by this authorized test runner.
    $output = @(& $command -FrameworkRoot (Join-Path $m5bRepo $Platform) -Target $Root -SharedSkillsRoot (Join-Path $m5bShared 'skills') *>&1)
    [IO.File]::AppendAllText((Join-Path $m5bRoot 'deployment.log'),(($output | Out-String) + "`n"))
    $failed = @($output | Where-Object { $_ -and $_.PSObject.Properties['Succeeded'] -and -not $_.Succeeded })
    if ($failed.Count) { throw 'M5B production platform reported unsuccessful projection' }
}
function Assert-M5BCurrent([string]$Root,[string]$Platform) {
    $surface = switch($Platform){'Claude'{'.claude/skills'} 'Cursor'{'.cursor/skills'} default{'.agents/skills'}}
    $skills = Join-Path $Root $surface
    foreach ($id in @('memory-ops','memory-arch')) {
        $source = Join-Path $m5bShared "skills/$id/SKILL.md"
        $projected = Get-SharedSkillProjectedBytes -SharedSkillsRoot (Join-Path $m5bShared 'skills') -SourcePath $source -TargetSkillsPath $skills
        $expected = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($projected)).Replace('-','').ToLowerInvariant()
        (Get-M5BHash (Join-Path $skills "$id/SKILL.md")) | Should Be $expected
        # This independent owner pointer assertion fails if deployment simply
        # copies the old source-relative link, even if a hash helper agrees.
        $runtime = [IO.File]::ReadAllText((Join-Path $skills "$id/SKILL.md"))
        $owner = if ($surface -eq '.agents/skills') { '../../shared/policies/memory-governance.md' } else { '../../../.agents/shared/policies/memory-governance.md' }
        $runtime | Should Match ([regex]::Escape($owner))
    }
    foreach ($id in $m5bOld) {
        Test-Path -LiteralPath (Join-Path $skills "$id/SKILL.md") | Should Be $false
        (Get-Content -LiteralPath (Join-Path $skills '_index.md') -Raw) | Should Not Match ([regex]::Escape($id))
    }
    $direct = @(Get-ChildItem -LiteralPath $skills -Recurse -File -Filter 'SKILL.md')
    @($direct | Where-Object { $_.FullName -match 'team-(specialist-memory|memory-(docs|closure))' }).Count | Should Be 0
    $policyRoot = Join-Path $Root '.agents/shared'
    foreach ($relative in @('policies/memory-governance.md','policies/authorization-resolution.md','policies/completion-policy.md','policies/grounding-governance.md','policies/load-semantics.md','policies/project-context-protocol.md','policies/references/workflow-memory-evidence.md','policies/references/memory-review-evidence.md','policies/references/memory-update-sync-evidence.md','policies/references/legacy-memory-team-transition.md','policies/references/session-checkpoint-recovery.md')) {
        (Get-M5BHash (Join-Path $policyRoot $relative)) | Should Be (Get-M5BHash (Join-Path $m5bShared $relative))
    }
    foreach($id in $m5bOld){
        $alias=Join-Path $policyRoot "policies/references/legacy-skills/$id/REFERENCE.md"
        Test-Path -LiteralPath $alias | Should Be $true
        (Get-Content -LiteralPath $alias -Raw) | Should Match 'M3'
    }
    $agentRoot = switch($Platform){'Codex'{'.codex/agents'} 'Claude'{'.claude/agents'} 'Cursor'{'.cursor/agents'} default{'.agents/agents'}}
    $agentNames=@(Get-ChildItem -LiteralPath (Join-Path $Root $agentRoot) -File)
    $agentNames.Count | Should Be 6
    @($agentNames | Where-Object Name -Match 'memory').Count | Should Be 0
    $core=switch($Platform){'Codex'{'.codex/AGENTS.md'} 'Claude'{'.claude/CLAUDE.md'} 'Cursor'{'.cursor/rules/00-core.mdc'} default{'.agents/rules/00_core_identity.md'}}
    $text=Get-Content -LiteralPath (Join-Path $Root $core) -Raw
    $text | Should Match 'frozen_memory_action'
    $text | Should Match '\.agents/memory/'
    $text | Should Match 'memory-ops'
    $text | Should Match 'memory-arch'
    # Runtime reference resolution, not only existence in a source tree.
    $text | Should Match '\.agents/shared/policies/memory-governance\.md'
    if($Platform -in @('Claude','Antigravity')){
        $checkpoint=if($Platform -eq 'Claude'){'.claude/rules/session-checkpoint-recovery.md'}else{'.agents/rules/02_session_checkpoint_recovery.md'}
        $cp=Get-Content -LiteralPath (Join-Path $Root $checkpoint) -Raw
        $cp | Should Match '\.agents/shared/policies/references/session-checkpoint-recovery.md'
        $cp | Should Match 'never calls `memory_list`'
    }
    foreach($file in @(Get-ChildItem -LiteralPath $Root -Recurse -File | Where-Object { $_.FullName -match '/never-match|\\(commands|workflows|skills)\\' -and $_.Extension -eq '.md' })){
        $body=Get-Content -LiteralPath $file.FullName -Raw
        if($body -match '(?s)^---\s*(.*?)---'){
            $front=$Matches[1]
            if($front -match '(?m)^required_skills:\s*(.*)$'){
                $Matches[1] | Should Not Match 'team-(specialist-memory|memory-(docs|closure))|memory-ops|memory-arch'
            }
        }
    }
    $script:m5bResults += [pscustomobject]@{platform=$Platform;fixture=$Root;static_checks='pass';legacy_absent=$true;new_session_smoke='REAL_SESSION_BEHAVIOR_REQUIRES_M5C';activation_granted=$false}
}
function Get-M5BGolden {
    if(-not $script:m5bGolden){
        $script:m5bGolden=New-M5BFixture 'golden'
        foreach($platform in @('Codex','Claude','Cursor','Antigravity')){
            Invoke-M5BProjection $script:m5bGolden $platform 'Fresh'
        }
    }
    return $script:m5bGolden
}
function New-M5BOld([string]$Kind='known-old') {
    $golden=Get-M5BGolden
    $root=New-M5BFixture $Kind
    Get-ChildItem -LiteralPath $golden -Force | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $root -Recurse -Force }
    foreach($surface in @('.agents/skills','.claude/skills')){
        foreach($artifact in @(Get-LegacySkillMigrationArtifacts -SharedRoot $m5bShared -Batch M3)){
            $dest=Join-Path $root "$surface/$($artifact.old_relative_path)"
            $null=New-Item -ItemType Directory -Path (Split-Path $dest -Parent) -Force
            Copy-Item -LiteralPath (Join-Path $m5bShared $artifact.archive_relative_path) -Destination $dest
            $null = (Get-M5BHash $dest) | Should Be $artifact.known_versions[0].sha256
        }
    }
    # Exact historical framework bytes; no historical oracle is changed.
    foreach($pair in @(@('Claude/.claude/rules/memory-contract.md','.claude/rules/memory-contract.md'),@('Claude/.claude/commands/05_condense（濃縮）/SKILL.md','.claude/commands/05_condense（濃縮）/SKILL.md'),@('Shared/skills/_index.md','.claude/skills/_index.md'),@('Shared/skills/_index.md','.agents/skills/_index.md'))){
        $encoded=& python -B -c "import base64,subprocess,sys; print(base64.b64encode(subprocess.check_output(['git','-C',sys.argv[2],'show','2914703211003ae8adad4f6e8522467b74908da6:'+sys.argv[1]])).decode())" $pair[0] $m5bRepo
        if($LASTEXITCODE -ne 0){throw 'historical fixture unavailable'}
        $path=Join-Path $root $pair[1]
        $null=New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
        [IO.File]::WriteAllBytes($path,[Convert]::FromBase64String($encoded))
    }
    return $root
}
function New-M5BPoint([string]$Root) {
    $old=Get-M5BInventory $Root; $new=Get-M5BInventory (Get-M5BGolden)
    $entries=@($old.Keys + $new.Keys | Sort-Object -Unique | ForEach-Object {
        [pscustomobject]@{RelativePath=$_;KnownSha256=@($old[$_]);IntendedSha256=$new[$_]}
    })
    # This test inventory knows its deliberately seeded pre-images. Production
    # M5C must independently establish ownership; a directory name is no proof.
    $projectionSha = Get-M5BTextHash (Get-M5BFingerprint (Get-M5BGolden))
    return New-DeploymentRollbackPoint -TargetRoot $Root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries $entries -SourceRevision ('HEAD:'+(git -C $m5bRepo rev-parse HEAD)+';dirty-projection-sha256:'+$projectionSha) -Platform 'four-platform-rehearsal' -RuntimeInstance 'isolated-static-only'
}
function Invoke-M5BUpgrade([string]$Root,[string]$Point='') {
    Invoke-DeploymentTransaction -TargetRoot $Root -RollbackPointPath $Point -Action {
        # All blocking legacy pre-images are resolved before any route writes.
        foreach($surface in @('.agents/skills','.claude/skills','.cursor/skills')){Assert-LegacySkillMigrationReady -TargetSkillsPath (Join-Path $Root $surface)}
        foreach($platform in @('Codex','Claude','Cursor','Antigravity')){Invoke-M5BProjection $Root $platform 'Upgrade'}
    } | Out-Null
}

Describe 'Memory M5B production projection and exact persistent recovery on isolated targets' {
    BeforeEach {
        Reset-M5BProjectionModules
    }
    It 'fresh deploys Codex with current policy paths and only two active Memory methods' {
        $root=New-M5BFixture 'fresh-codex'; Invoke-M5BProjection $root 'Codex' 'Fresh'; Assert-M5BCurrent $root 'Codex'
    }
    It 'fresh deploys Claude with correct card path and independent checkpoint recovery' {
        $root=New-M5BFixture 'fresh-claude'; Invoke-M5BProjection $root 'Claude' 'Fresh'; Assert-M5BCurrent $root 'Claude'
    }
    It 'fresh deploys Cursor and verifies its real fixture discovery surface' {
        $root=New-M5BFixture 'fresh-cursor'; Invoke-M5BProjection $root 'Cursor' 'Fresh'; Assert-M5BCurrent $root 'Cursor'
    }
    It 'fresh deploys Antigravity without a compulsory new-chat Memory route' {
        $root=New-M5BFixture 'fresh-antigravity'; Invoke-M5BProjection $root 'Antigravity' 'Fresh'; Assert-M5BCurrent $root 'Antigravity'
    }
    It 'upgrades routes indexes and eight exact old copies together and does not regenerate them' {
        $root=New-M5BOld; $point=New-M5BPoint $root
        Invoke-M5BUpgrade $root $point
        foreach($platform in @('Codex','Claude','Cursor','Antigravity')){Assert-M5BCurrent $root $platform}
        Complete-DeploymentRollbackPoint -Path $point -TargetRoot $root
        foreach($surface in @('.agents/skills','.claude/skills','.cursor/skills')){
            $null=Sync-SharedSkills -SharedSkillsRoot (Join-Path $m5bShared 'skills') -TargetSkillsPath (Join-Path $root $surface) -Mode Diff
        }
        foreach($surface in @('.agents/skills','.claude/skills','.cursor/skills')){foreach($id in $m5bOld){Test-Path -LiteralPath (Join-Path $root "$surface/$id/SKILL.md") | Should Be $false}}
    }
    It 'preserves a user-modified old copy and blocks the transaction before route writes' {
        $root=New-M5BOld 'modified'; $file=Join-Path $root '.claude/skills/team-specialist-memory-docs/SKILL.md'
        [IO.File]::AppendAllText($file,"`nuser content")
        $before=Get-M5BFingerprint $root
        {Invoke-M5BUpgrade $root} | Should Throw 'preserved_user_modified_retired_skill'
        Get-M5BFingerprint $root | Should Be $before
        $artifact=@(Get-LegacySkillMigrationArtifacts -Batch M3 | Where-Object skill -eq 'team-specialist-memory-docs')[0]
        {New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries @([pscustomobject]@{RelativePath='.claude/skills/team-specialist-memory-docs/SKILL.md';KnownSha256=@($artifact.known_versions.sha256);IntendedSha256=$null}) -SourceRevision 'test' -Platform 'Claude' -RuntimeInstance 'fixture'} | Should Throw 'RecoveryUnconfirmedCopy'
    }
    It 'preserves an unknown old copy and blocks activation without force retirement' {
        $root=New-M5BOld 'unknown'; $null=Set-M5BText $root '.agents/skills/team-specialist-memory-closure/SKILL.md' 'unknown owner'
        $before=Get-M5BFingerprint $root
        {Invoke-M5BUpgrade $root} | Should Throw 'preserved_user_modified_retired_skill'
        Get-M5BFingerprint $root | Should Be $before
    }
    It 'keeps partial platform projection evidence scoped and an old session frozen' {
        $root=New-M5BFixture 'partial'; Invoke-M5BProjection $root 'Codex' 'Fresh'
        $null=Set-M5BText $root '.claude/rules/memory-contract.md' 'old session route'
        $null=Set-M5BText $root '.agents/rules/06_memory_push.md' 'old Antigravity route'
        Test-Path -LiteralPath (Join-Path $root '.cursor') | Should Be $false
        $records=@([pscustomobject]@{project=$root;platform='Codex';runtime='new-fixture';static='pass';smoke='pending';activation=$false},[pscustomobject]@{project=$root;platform='Claude';runtime='old-session';static='old';smoke='REAL_SESSION_BEHAVIOR_REQUIRES_M5C';activation=$false})
        $records[0].activation | Should Be $false; $records[1].activation | Should Be $false
        (Get-Content -LiteralPath (Join-Path $root '.codex/AGENTS.md') -Raw) | Should Match 'M5C'
        [IO.File]::WriteAllText((Join-Path $m5bRoot 'partial-runtime-evidence.json'),($records|ConvertTo-Json))
    }
    It 'retains checkpoint in_progress and authorization-bound completed semantics without a Memory probe' {
        $owner=Get-Content -LiteralPath (Join-Path (Get-M5BGolden) '.agents/shared/policies/references/session-checkpoint-recovery.md') -Raw
        foreach($marker in @('in_progress','completed','GO','SKIP','authorization','never calls','does not call `memory_list`')){
            if($marker -ne 'never calls'){$owner | Should Match ([regex]::Escape($marker))}
        }
        $owner | Should Match 'not.*authorize|not grant|not.*authorization'
    }
}

Describe 'Memory M5B isolated platform copy failure recovery' {
    BeforeEach {
        Reset-M5BProjectionModules
    }
    It 'rolls back a real platform copy failure using the existing transaction' {
        $root=New-M5BOld 'copy-failure'; $before=Get-M5BFingerprint $root; $point=New-M5BPoint $root
        { Invoke-M5BWithFault 'Core.Upgrade' 'Copy-Item' {
            [CmdletBinding()]
            param([Parameter(Position=0)][string[]]$Path,[Parameter(Position=1)][string]$Destination,[string[]]$LiteralPath,[switch]$Force,[switch]$Recurse)
            if ($Destination -like '*memory-contract.md') { throw 'injected_copy_failure' }
            Microsoft.PowerShell.Management\Copy-Item @PSBoundParameters
        } { Invoke-M5BUpgrade $root $point } } | Should Throw 'injected_copy_failure'
        Get-M5BFingerprint $root | Should Be $before
    }
}

Describe 'Memory M5B isolated post retirement failure recovery' {
    BeforeEach {
        Reset-M5BProjectionModules
    }
    It 'rolls back after physical retirement when later projection fails' {
        $root=New-M5BOld 'retire-failure'; $before=Get-M5BFingerprint $root; $point=New-M5BPoint $root
        { Invoke-M5BWithFault 'Platform-Claude' 'Sync-SharedGovernanceReferences' {
            param([string]$SharedRoot,[string]$TargetAgentsRoot,[string]$Mode)
            throw 'injected_after_retirement'
        } { Invoke-M5BUpgrade $root $point } } | Should Throw 'injected_after_retirement'
        Get-M5BFingerprint $root | Should Be $before
    }
}

Describe 'Memory M5B isolated index failure recovery' {
    BeforeEach {
        Reset-M5BProjectionModules
    }
    It 'rolls back a runtime Skill index projection failure' {
        $root=New-M5BOld 'index-failure'; $before=Get-M5BFingerprint $root; $point=New-M5BPoint $root
        # The current writer obtains projected bytes and uses WriteAllBytes;
        # Copy-Item is no longer the Skill index failure boundary.
        $owner=Get-M5BModuleOwner 'Skills-Sync'
        $original=& $owner { (Get-Command Get-SharedSkillProjectedBytes).ScriptBlock }
        $indexSource=[IO.Path]::GetFullPath((Join-Path $m5bShared 'skills/_index.md'))
        $indexFault={
            param([string]$SourcePath,[string]$SharedSkillsRoot,[string]$TargetSkillsPath)
            if ([IO.Path]::GetFullPath($SourcePath) -eq $indexSource) { throw 'injected_index_failure' }
            return ,(& $original -SourcePath $SourcePath -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $TargetSkillsPath)
        }.GetNewClosure()
        { Invoke-M5BWithFault 'Skills-Sync' 'Get-SharedSkillProjectedBytes' $indexFault { Invoke-M5BUpgrade $root $point } } | Should Throw 'injected_index_failure'
        Get-M5BFingerprint $root | Should Be $before
    }
}

Describe 'Memory M5B post success persistent recovery' {
    BeforeEach {
        Reset-M5BProjectionModules
    }
    It 'restores a successful deployment after process exit and preserves adjacent user data' {
        $root=New-M5BOld 'smoke-failure'; $before=Get-M5BFingerprint $root; $point=New-M5BPoint $root
        Invoke-M5BUpgrade $root $point; Complete-DeploymentRollbackPoint -Path $point -TargetRoot $root
        $user=Set-M5BText $root '.claude/user-note.txt' 'after deployment unknown content'
        $memory=Set-M5BText $root '.agents/memory/synthetic/MEMORY.md' 'do not roll back'; $context=Set-M5BText $root '.agents/context/synthetic/CONTEXT.md' 'do not roll back'
        $restoreScript=Join-Path $m5bRoot 'restore-process.ps1'
        [IO.File]::WriteAllText($restoreScript,'param($Module,$Point,$Target)'+"`n"+'Import-Module -Name $Module -Force'+"`n"+'Restore-DeploymentRollbackPoint -Path $Point -TargetRoot $Target | ConvertTo-Json')
        $out=& pwsh -NoProfile -File $restoreScript -Module (Join-Path $m5bRepo 'Scripts/modules/Deployment.Transaction.psm1') -Point $point -Target $root
        $LASTEXITCODE | Should Be 0
        ($out|Out-String) | Should Match '"Restored": true'
        Get-Content -LiteralPath $user -Raw | Should Be 'after deployment unknown content'
        Get-Content -LiteralPath $memory -Raw | Should Be 'do not roll back'; Get-Content -LiteralPath $context -Raw | Should Be 'do not roll back'
        $after=Get-M5BInventory $root; $after.Remove('.claude/user-note.txt')
        (@($after.Keys|Sort-Object|ForEach-Object {$_+':'+$after[$_]}) -join "`n") | Should Be $before
        foreach($surface in @('.agents/skills','.claude/skills')){foreach($id in $m5bOld){Test-Path -LiteralPath (Join-Path $root "$surface/$id/SKILL.md") | Should Be $true}}
    }
    It 'blocks persistent restore after a user edits a projected path without restoring any other path' {
        $root=New-M5BOld 'rollback-override'; $point=New-M5BPoint $root; Invoke-M5BUpgrade $root $point; Complete-DeploymentRollbackPoint -Path $point -TargetRoot $root
        [IO.File]::AppendAllText((Join-Path $root '.claude/rules/memory-contract.md'),"`nuser edit after deployment")
        $before=Get-M5BFingerprint $root
        {Restore-DeploymentRollbackPoint -Path $point -TargetRoot $root} | Should Throw 'RecoveryLocalOverride'
        Get-M5BFingerprint $root | Should Be $before
    }
    It 'rejects unsafe protected paths corrupted backup and stale preimage before a write' {
        $root=New-M5BOld 'unsafe'; $point=New-M5BPoint $root
        foreach($rel in @('../outside','.agents/memory/x/MEMORY.md','.agents/context/x/CONTEXT.md','.cartridge/index.json')){
            {New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries @([pscustomobject]@{RelativePath=$rel;KnownSha256=@();IntendedSha256=$null}) -SourceRevision 'test' -Platform 'Codex' -RuntimeInstance 'fixture'} | Should Throw 'RecoveryUnsafePath'
        }
        $m=Get-Content -LiteralPath $point -Raw|ConvertFrom-Json
        $saved=@($m.entries|Where-Object original_sha256)[0]
        [IO.File]::AppendAllText((Join-Path (Split-Path $point -Parent) "files/$($saved.backup_id).bin"),'corrupt')
        $before=Get-M5BFingerprint $root
        {Restore-DeploymentRollbackPoint -Path $point -TargetRoot $root} | Should Throw 'RecoveryBackupCorrupt'
        Get-M5BFingerprint $root | Should Be $before
    }
}

Describe 'Memory M5B persistent recovery guards on isolated targets' {
    It 'blocks a stale preimage before starting the deployment action' {
        $root=New-M5BFixture 'stale-preimage'; $file=Set-M5BText $root '.codex/AGENTS.md' 'framework old'
        $entry=[pscustomobject]@{RelativePath='.codex/AGENTS.md';KnownSha256=@(Get-M5BHash $file);IntendedSha256=(Get-M5BTextHash 'framework new')}
        $point=New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries @($entry) -SourceRevision 'synthetic-framework' -Platform 'Codex' -RuntimeInstance 'fixture'
        [IO.File]::WriteAllText($file,'user edit after preflight')
        {Invoke-DeploymentTransaction -TargetRoot $root -RollbackPointPath $point -Action {throw 'action must not run'}} | Should Throw 'RecoveryPreimageChanged'
        Get-Content -LiteralPath $file -Raw | Should Be 'user edit after preflight'
    }
    It 'keeps a concurrent unknown file outside the exact during-transaction rollback inventory' {
        $root=New-M5BFixture 'concurrent-unknown'; $file=Set-M5BText $root '.codex/AGENTS.md' 'framework old'
        $entry=[pscustomobject]@{RelativePath='.codex/AGENTS.md';KnownSha256=@(Get-M5BHash $file);IntendedSha256=(Get-M5BTextHash 'framework new')}
        $point=New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries @($entry) -SourceRevision 'synthetic-framework' -Platform 'Codex' -RuntimeInstance 'fixture'
        {Invoke-DeploymentTransaction -TargetRoot $root -RollbackPointPath $point -Action {
            $null=Set-M5BText $root '.codex/AGENTS.md' 'framework new'
            $null=Set-M5BText $root '.claude/user-content.md' 'concurrent user content'
            throw 'synthetic_failure'
        }} | Should Throw 'synthetic_failure'
        Get-Content -LiteralPath $file -Raw | Should Be 'framework old'
        Get-Content -LiteralPath (Join-Path $root '.claude/user-content.md') -Raw | Should Be 'concurrent user content'
    }
    It 'removes only an exact freshly planned projection on persistent rollback' {
        $root=New-M5BFixture 'fresh-recovery'
        $entry=[pscustomobject]@{RelativePath='.codex/AGENTS.md';KnownSha256=@();IntendedSha256=(Get-M5BTextHash 'framework new')}
        $point=New-DeploymentRollbackPoint -TargetRoot $root -StoreRoot (Join-Path $m5bRoot 'rollback') -Entries @($entry) -SourceRevision 'synthetic-framework' -Platform 'Codex' -RuntimeInstance 'fixture'
        Invoke-DeploymentTransaction -TargetRoot $root -RollbackPointPath $point -Action {$null=Set-M5BText $root '.codex/AGENTS.md' 'framework new'} | Out-Null
        Complete-DeploymentRollbackPoint -Path $point -TargetRoot $root
        $null=Set-M5BText $root '.codex/user-content.md' 'unknown adjacent content'
        $null=Restore-DeploymentRollbackPoint -Path $point -TargetRoot $root
        Test-Path -LiteralPath (Join-Path $root '.codex/AGENTS.md') | Should Be $false
        Get-Content -LiteralPath (Join-Path $root '.codex/user-content.md') -Raw | Should Be 'unknown adjacent content'
    }
}

[IO.File]::WriteAllText((Join-Path $m5bRoot 'projection-evidence.json'),($script:m5bResults|ConvertTo-Json -Depth 6))
