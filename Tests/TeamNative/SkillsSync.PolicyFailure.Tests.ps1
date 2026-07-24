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
