Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Import-Module (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1') -Force

Describe 'Shared policy block sync failure semantics' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-policy-sync-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            $resolved = [IO.Path]::GetFullPath($script:tempRoot)
            $temp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\','/')
            if (-not $resolved.StartsWith($temp + '\',[StringComparison]::OrdinalIgnoreCase) -or
                (Split-Path $resolved -Leaf) -notmatch '^ai-rules-policy-sync-[a-f0-9-]+$') { throw 'Unsafe fixture cleanup' }
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
    }

    It 'syncs the valid Codex adapter pointer and leaves the second run unchanged' {
        $policyPath = Join-Path $repoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $targetPath = Join-Path $script:tempRoot '.codex\AGENTS.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($targetPath, "# Test core`r`n`r`nCodex-specific governance:`r`n", [System.Text.UTF8Encoding]::new($false))

        $firstUpdate = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Codex -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
        if ($firstUpdate -ne 1) { throw "Expected one valid adapter update; received $firstUpdate." }
        $firstContent = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        $secondUpdate = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Codex -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
        if ($secondUpdate -ne 0) { throw "Expected no update on the second run; received $secondUpdate." }
        $secondContent = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        if ($firstContent -cne $secondContent) { throw 'The second policy sync changed an already generated Codex pointer.' }
        if ($firstContent -match "(?<!`r)`n" -or $secondContent -match "(?<!`r)`n") {
            throw 'A CRLF target received a mixed-LF policy marker.'
        }
        if ($secondContent -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') { throw 'The generated Codex pointer is missing.' }
        if ($secondContent -match 'The governed Codex candidate rungs are exactly') { throw 'The generated pointer contains the full adapter policy.' }
    }

    It 'fails closed without changing the target when the required policy marker is missing' {
        $policyPath = Join-Path $script:tempRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $targetPath = Join-Path $script:tempRoot '.codex\AGENTS.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $policyPath -Parent), (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($policyPath, "# Adapter without a Codex marker`r`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText($targetPath, "# Existing target`r`n", [System.Text.UTF8Encoding]::new($false))
        $before = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        $caught = $null
        try {
            $null = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Codex
        } catch {
            $caught = $_
        }

        if ($null -eq $caught) { throw 'A missing policy marker must fail closed.' }
        if ($caught.FullyQualifiedErrorId -notmatch '^SharedPolicy\.PolicyBlockMissing') {
            throw "Expected the policy-block failure code; received $($caught.FullyQualifiedErrorId)."
        }
        $after = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($before -cne $after) { throw 'Policy sync changed the target after its policy preflight failed.' }
    }

    It 'distinguishes a missing policy file from a missing policy marker' {
        $missingPolicyPath = Join-Path $script:tempRoot 'Shared\policies\adapters\missing.md'
        $targetPath = Join-Path $script:tempRoot '.codex\AGENTS.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($targetPath, "# Existing target`r`n", [System.Text.UTF8Encoding]::new($false))

        $caught = $null
        try {
            $null = Get-SharedPolicyBlock -PolicyPath $missingPolicyPath -Platform Codex
        } catch {
            $caught = $_
        }

        if ($null -eq $caught) { throw 'A missing policy file must not return an empty success value.' }
        if ($caught.FullyQualifiedErrorId -notmatch '^SharedPolicy\.PolicyFileMissing') {
            throw "Expected the missing-file failure code; received $($caught.FullyQualifiedErrorId)."
        }
    }
}

Describe 'Shared Skill policy reference projection regression' {
    BeforeEach {
        $script:projectionRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:projectionSource = Join-Path $projectionRoot 'Shared/skills'
        $script:projectionTarget = Join-Path $projectionRoot '.agents/skills'
        $null = New-Item -ItemType Directory -Force -Path $projectionSource,$projectionTarget
        foreach ($name in @('memory-governance.md','authorization-resolution.md','project-context-protocol.md','completion-policy.md','review-governance.md','verification-strategy.md','references/workflow-memory-evidence.md','references/memory-closure-bundle-contract.md')) {
            foreach ($prefix in @('Shared/policies','.agents/shared/policies')) {
                $file=Join-Path (Join-Path $projectionRoot $prefix) $name
                $null=New-Item -ItemType Directory -Force -Path (Split-Path $file -Parent)
                [IO.File]::WriteAllText($file,'fixture canonical policy',[Text.UTF8Encoding]::new($false))
            }
        }
    }

    It 'resolves all real active Memory references on both sides and preserves source bytes' {
        $checked=0
        foreach ($id in @('memory-ops','memory-arch')) {
            foreach ($file in Get-ChildItem -LiteralPath (Join-Path $repoRoot ('Shared/skills/'+$id)) -Recurse -File -Filter '*.md') {
                if ($file.FullName -match '[\\/](legacy|archive)[\\/]') { continue }
                $rel=[IO.Path]::GetRelativePath((Join-Path $repoRoot 'Shared/skills'), $file.FullName).TrimStart('\','/')
                $source=Join-Path $projectionSource $rel
                $null=New-Item -ItemType Directory -Force -Path (Split-Path $source -Parent)
                Copy-Item -LiteralPath $file.FullName -Destination $source
                $before=(Get-FileHash -LiteralPath $source).Hash
                $bytes=Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget
                $repeat=Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget
                if ([Convert]::ToBase64String($bytes) -cne [Convert]::ToBase64String($repeat)) { throw 'Nondeterministic projection' }
                if ((Get-FileHash -LiteralPath $source).Hash -cne $before) { throw 'Canonical source changed' }
                foreach ($match in [regex]::Matches([Text.Encoding]::UTF8.GetString($bytes),'`(?<p>(?:\.\./)+shared/policies/[^`]+)`')) {
                    $path=$match.Groups['p'].Value
                    if (-not (Test-Path -LiteralPath (Join-Path (Split-Path (Join-Path $projectionTarget $rel) -Parent) $path))) { throw 'Runtime reference cannot resolve' }
                    $sourceReference=Join-Path (Split-Path $source -Parent) $path.Replace('/shared/policies/','/policies/')
                    if (-not (Test-Path -LiteralPath $sourceReference)) { throw 'Source reference cannot resolve' }
                    $checked++
                }
            }
        }
        if ($checked -ne 30) { throw "Expected all30 active occurrences; got $checked" }
    }

    It 'projects required policy links anchors and Markdown reference definitions' {
        $source=Join-Path $projectionSource 'sample/SKILL.md';$null=New-Item -ItemType Directory -Force -Path (Split-Path $source -Parent)
        $body=@'
`../../policies/memory-governance.md`
[evidence](../../policies/references/workflow-memory-evidence.md#seven "Title")
[authorization]: <../../policies/authorization-resolution.md>
'@
        [IO.File]::WriteAllText($source,$body,[Text.UTF8Encoding]::new($false))
        $text=[Text.Encoding]::UTF8.GetString((Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget))
        foreach($ref in @('../../shared/policies/memory-governance.md','../../shared/policies/references/workflow-memory-evidence.md#seven','../../shared/policies/authorization-resolution.md')) { if (-not $text.Contains($ref)) { throw 'Required policy link not projected' } }
    }

    It 'preserves prose examples legacy archives and already-correct references' {
        $source=Join-Path $projectionSource 'sample/SKILL.md';$null=New-Item -ItemType Directory -Force -Path (Split-Path $source -Parent)
        $body=@'
ordinary text ../../policies/memory-governance.md
`../../shared/policies/memory-governance.md`
```md
`../../policies/memory-governance.md`
```
## Legacy Compatibility
`../../policies/memory-governance.md`
## Active
`../../policies/authorization-resolution.md`
<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
`../../policies/completion-policy.md`
<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
'@
        [IO.File]::WriteAllText($source,$body,[Text.UTF8Encoding]::new($false))
        $text=[Text.Encoding]::UTF8.GetString((Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget))
        if ($text -cne $body.Replace('`../../policies/authorization-resolution.md`','`../../shared/policies/authorization-resolution.md`')) { throw 'Inactive content changed' }
        [IO.File]::WriteAllText($source,$text,[Text.UTF8Encoding]::new($false))
        if ([Text.Encoding]::UTF8.GetString((Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget)) -cne $text) { throw 'Double rewrite' }
        $archive=Join-Path $projectionSource 'sample/references/archive/old.md';$null=New-Item -ItemType Directory -Force -Path (Split-Path $archive -Parent)
        [IO.File]::WriteAllText($archive,'`../../../../policies/memory-governance.md`',[Text.UTF8Encoding]::new($false))
        if ([Convert]::ToBase64String((Get-SharedSkillProjectedBytes -SourcePath $archive -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget)) -cne [Convert]::ToBase64String([IO.File]::ReadAllBytes($archive))) { throw 'Archive changed' }
    }

    It 'preserves the frozen bundle citation inside the mixed completion paragraph' {
        $source=Join-Path $repoRoot 'Shared/skills/memory-ops/references/memory-lifecycle-procedures.md'
        $text=[Text.Encoding]::UTF8.GetString((Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot (Join-Path $repoRoot 'Shared/skills') -TargetSkillsPath $projectionTarget))
        if (-not $text.Contains('`../../../shared/policies/completion-policy.md`') -or -not $text.Contains('`../../../policies/references/memory-closure-bundle-contract.md`')) { throw 'Active/legacy boundary failed' }
    }

    It 'maps Claude Skills to the existing project .agents shared policy authority' {
        $source=Join-Path $projectionSource 'sample/SKILL.md';$null=New-Item -ItemType Directory -Force -Path (Split-Path $source -Parent)
        [IO.File]::WriteAllText($source,'`../../policies/memory-governance.md`',[Text.UTF8Encoding]::new($false))
        $claude=Join-Path $projectionRoot '.claude/skills'
        $text=[Text.Encoding]::UTF8.GetString((Get-SharedSkillProjectedBytes -SourcePath $source -SharedSkillsRoot $projectionSource -TargetSkillsPath $claude))
        if ($text -cne '`../../../.agents/shared/policies/memory-governance.md`') { throw 'Claude policy authority changed' }
        if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $claude 'sample') '../../../.agents/shared/policies/memory-governance.md'))) { throw 'Claude reference cannot resolve' }
    }

    It 'keeps Full Diff manager preflight and cohort generators on the same projected bytes' {
        $source=Join-Path $projectionSource 'sample/SKILL.md';$null=New-Item -ItemType Directory -Force -Path (Split-Path $source -Parent)
        [IO.File]::WriteAllText($source,'`../../policies/memory-governance.md`',[Text.UTF8Encoding]::new($false))
        $null=Sync-SharedSkills -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget -Mode Full
        $target=Join-Path $projectionTarget 'sample/SKILL.md';$before=(Get-FileHash -LiteralPath $target).Hash
        $count=Sync-SharedSkills -SharedSkillsRoot $projectionSource -TargetSkillsPath $projectionTarget -Mode Diff
        if ($count -ne 0 -or (Get-FileHash -LiteralPath $target).Hash -cne $before) { throw 'Diff reapplies raw source' }
        Import-Module (Join-Path $repoRoot 'Scripts/modules/Deployment.Cohort.psm1') -DisableNameChecking
        $record=[pscustomobject]@{planned_action='UPDATE';source_path=$source;target_path='.agents/skills/sample/SKILL.md';content_type='Skill'}
        $plan=& (Get-Module Deployment.Cohort) {param($r,$e) Get-CohortProjectedBytes -RepoRoot $r -TargetRoot $r -Record $e} $projectionRoot $record
        if ([Convert]::ToBase64String($plan.Bytes) -cne [Convert]::ToBase64String([IO.File]::ReadAllBytes($target))) { throw 'Cohort generator disagrees' }
        $records=@{}
        & (Get-Module -All Deployment.Preflight | Select-Object -First 1) {param($m,$r,$s,$t,$skills) Add-PreflightCopy -Records $m -Root $r -Platform Codex -SourcePath $s -TargetPath $t -ContentType Skill -SharedSkillsRoot $skills} $records $projectionRoot $source $target $projectionSource
        if (@($records.Values)[0].planned_action -ne 'UNCHANGED') { throw 'Preflight false raw-byte diff' }
        Import-Module (Join-Path $repoRoot 'Scripts/modules/Manager.ProjectSync.psm1') -DisableNameChecking
        $diffs=@(& (Get-Module Manager.ProjectSync) {param($s,$t) Get-ManagerSharedSkillDiffs -SharedSkillsRoot $s -TargetSkillsPath $t} $projectionSource $projectionTarget)
        if ($diffs.Count) { throw 'Manager false raw-byte diff' }
    }
}
