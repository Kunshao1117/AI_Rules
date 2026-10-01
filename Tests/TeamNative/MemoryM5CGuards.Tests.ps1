Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$guardRepo=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $guardRepo 'Scripts/modules/Deployment.Cohort.psm1') -Force -DisableNameChecking

function Test-M5CRetiredRoute([string]$Text) {
    & (Get-Module Deployment.Cohort) { param($Body) Test-CohortRetiredConsumerRoute -Text $Body -SkillId 'delegation-strategy' } $Text
}
Describe 'M5C preserved consumer and prepared plan guards' {
    It 'recognizes flow, indented, indentless and multiline-flow lists' {
        foreach($text in @(
            'required_skills: [delegation-strategy]',
            "required_skills:`n  - delegation-strategy",
            "required_skills:`n- delegation-strategy",
            "required_skills:`n`n# comment`n  - delegation-strategy",
            "required_skills: [`n delegation-strategy,`n browser-testing`n]"
        )){Test-M5CRetiredRoute $text | Should Be $true}
    }
    It 'recognizes shared, source and relative sibling Skill routes' {
        foreach($text in @('.agents/skills/delegation-strategy/SKILL.md','Shared/skills/delegation-strategy/SKILL.md','../delegation-strategy/SKILL.md#anchor','[load](./delegation-strategy/SKILL.md)')){Test-M5CRetiredRoute $text | Should Be $true}
    }
    It 'keeps canonical compatibility references, comments and distinct IDs separate' {
        foreach($text in @(
            '.agents/shared/policies/references/legacy-skills/delegation-strategy/REFERENCE.md',
            'required_skills: [browser-testing] # delegation-strategy',
            'required_skills: [not-delegation-strategy]',
            "<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->`nrequired_skills: [delegation-strategy]`n<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->"
        )){Test-M5CRetiredRoute $text | Should Be $false}
    }
    It 'preserves and blocks an orphan Antigravity consumer through real preflight' {
        $root=Join-Path $TestDrive 'orphan-consumer'
        $null=New-Item -ItemType Directory -Path (Join-Path $root '.agents/workflows') -Force
        $file=Join-Path $root '.agents/workflows/user-route.md'
        [IO.File]::WriteAllText($file,"required_skills:`n- delegation-strategy")
        $before=(Get-FileHash $file).Hash
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $guardRepo -TargetRoot $root
        $plan.Ready | Should Be $false
        @($plan.Blockers | Where-Object reason -eq 'preserved_active_entry_has_retired_route').Count | Should BeGreaterThan 0
        (Get-FileHash $file).Hash | Should Be $before
    }
    It 'binds official target, source, scope and bytes without creating a rollback point' {
        $plan=Get-SharedCodexDeploymentCohortPreflight -RepoRoot $guardRepo -TargetRoot $guardRepo
        Assert-DeploymentCohortCurrent -RepoRoot $guardRepo -TargetRoot $guardRepo -Plan $plan | Should Be $true
        $original=$plan.ExactEntries[0].ProjectedBytesBase64
        $plan.ExactEntries[0].ProjectedBytesBase64='YWJj'
        {Assert-DeploymentCohortCurrent -RepoRoot $guardRepo -TargetRoot $guardRepo -Plan $plan} | Should Throw 'Cohort.PlanBytesOrScopeDrift'
        $plan.ExactEntries[0].ProjectedBytesBase64=$original
        $plan.SourceFingerprint='a'*64
        {Assert-DeploymentCohortCurrent -RepoRoot $guardRepo -TargetRoot $guardRepo -Plan $plan} | Should Throw 'Cohort.SourceDrift'
    }
}
