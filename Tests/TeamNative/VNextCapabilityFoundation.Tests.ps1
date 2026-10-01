Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$capRepo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

# Source-conformance tests, not a runtime resolver or natural-language classifier.
# Facts are normalized acceptance fixtures. Read rules from canonical source;
# never launch providers, install, deploy, mutate Git, or access credentials.
function Read-CapSource([string]$Path) {
    $manifest = Get-Content -LiteralPath (Join-Path $capRepo 'Shared/policies/references/legacy-skill-migration.json') -Raw | ConvertFrom-Json
    $mapped = @($manifest.artifacts | Where-Object { "Shared/skills/$($_.old_relative_path)" -ceq $Path })
    if ($mapped.Count -eq 1) { $Path = "Shared/$($mapped[0].reference_relative_path)" }
    $text = (Get-Content -LiteralPath (Join-Path $capRepo $Path) -Raw -Encoding UTF8) -replace "`r`n", "`n"
    # Historical source contracts remain tested; active identity is tested by A1.
    if ($text.Contains('<!-- ARCHIVED_SKILL_BODY_START -->')) { $text = ($text -split '<!-- ARCHIVED_SKILL_BODY_START -->\n', 2)[1].TrimStart([char]0xFEFF) }
    return $text
}
function Read-CapRows([string]$Text, [string]$Header) {
    $start = $Text.IndexOf($Header)
    if ($start -lt 0) { throw "Missing table: $Header" }
    $table = ($Text.Substring($start) -split "`n`n")[0]
    $rows = @([regex]::Matches($table, '(?m)^\| ([a-z_]+(?: & [a-z_]+)*) \| ([a-z_]+) \|$') | ForEach-Object {
        @{ Predicate = $_.Groups[1].Value; Result = $_.Groups[2].Value }
    })
    if ($rows.Count -eq 0) { throw "Empty table: $Header" }
    return $rows
}
function Invoke-CapRows([object[]]$Rows, [hashtable]$Facts) {
    foreach ($row in $Rows) {
        $matches = $true
        foreach ($term in ($row.Predicate -split ' & ')) {
            if ($term -ne 'otherwise' -and (-not $Facts.ContainsKey($term) -or $Facts[$term] -ne $true)) { $matches = $false }
        }
        if ($matches) { return $row.Result }
    }
    return 'no_record' # Harness outcome only; not a fifth readiness status.
}
function Get-CapHash([string]$Text) {
    $hash = [Security.Cryptography.SHA256]::Create()
    try { ([BitConverter]::ToString($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)))).Replace('-', '').ToLowerInvariant() }
    finally { $hash.Dispose() }
}
$capPolicy = Read-CapSource 'Shared/policies/capability-resolution.md'
$capRouting = Read-CapSource 'Shared/policies/execution-routing.md'
$capReadiness = @(Read-CapRows $capPolicy '| Predicate (first matching row) | Status |')
$capSelection = @(Read-CapRows $capPolicy '| Disqualifying fact (first matching row) | Decision |')
$capModes = @(Read-CapRows $capRouting '| Fact (first true wins) | Result |')
$capAuthority = @(Read-CapRows (Read-CapSource 'Shared/policies/authorization-resolution.md') '| Fact (first true wins) | Result |')

$capModeCases = @(
    @{ Name = 'main agent runs a safe terminal command'; Facts = @{ terminal_used = $true }; Expected = 'direct' },
    @{ Name = 'main agent verifies UI using browser'; Facts = @{ browser_used = $true }; Expected = 'direct' },
    @{ Name = 'main agent calls a structured read-only MCP query'; Facts = @{ mcp_used = $true }; Expected = 'direct' },
    @{ Name = 'separate helper searches using terminal'; Facts = @{ bounded_helper_use = $true; terminal_used = $true }; Expected = 'assisted' },
    @{ Name = 'separate helper uses browser and MCP'; Facts = @{ bounded_helper_use = $true; browser_used = $true; mcp_used = $true }; Expected = 'assisted' },
    @{ Name = 'large file count does not create a worker'; Facts = @{ file_count = 200; module_count = 40; terminal_used = $true }; Expected = 'direct' },
    @{ Name = 'Team still requires actual ownership or separation'; Facts = @{ required_duty_separation = $true; mcp_used = $true }; Expected = 'team' }
)
$capReadinessCases = @(
    @{ Name = 'executable resolves but auth/version unverified'; Facts = @{ present = $true }; Expected = 'present_unverified' },
    @{ Name = 'MCP metadata visible only'; Facts = @{ present = $true; metadata_visible = $true }; Expected = 'present_unverified' },
    @{ Name = 'project declaration without executable evidence'; Facts = @{ declared = $true }; Expected = 'no_record' },
    @{ Name = 'needed optional GitNexus checked absent'; Facts = @{ checked_absent = $true }; Expected = 'unavailable' },
    @{ Name = 'unexamined unrelated provider'; Facts = @{}; Expected = 'no_record' },
    @{ Name = 'current readiness supports capability'; Facts = @{ present = $true; sufficient = $true }; Expected = 'ready' },
    @{ Name = 'known block defeats older successful evidence'; Facts = @{ present = $true; sufficient = $true; known_blocker = $true }; Expected = 'blocked' }
)
$capSelectionCases = @(
    @{ Name = 'missing GitNexus seeks existing alternatives'; Facts = @{ not_ready = $true }; Expected = 'inspect_or_alternative' },
    @{ Name = 'preferred ready fitting GitNexus can be eligible'; Facts = @{ preferred = $true }; Expected = 'eligible' },
    @{ Name = 'preference cannot supply authorization'; Facts = @{ preferred = $true; missing_authorization = $true }; Expected = 'reject_provider' },
    @{ Name = 'npx package absent locally cannot be discovery'; Facts = @{ implicit_install_download_init = $true }; Expected = 'reject_provider' },
    @{ Name = 'wrapper cache/environment creation remains an effect'; Facts = @{ implicit_install_download_init = $true; cached = $true }; Expected = 'reject_provider' },
    @{ Name = 'MCP visible cannot imply mutation authorization'; Facts = @{ missing_authorization = $true; metadata_visible = $true }; Expected = 'reject_provider' },
    @{ Name = 'action deny cannot be bypassed with provider B'; Facts = @{ action_denied = $true; alternate_provider = $true }; Expected = 'stop_action' },
    @{ Name = 'provider A unsupported function is rejected'; Facts = @{ capability_mismatch = $true }; Expected = 'reject_provider' },
    @{ Name = 'provider B fits when only A lacks capability'; Facts = @{ alternate_provider = $true }; Expected = 'eligible' },
    @{ Name = 'native helper absence cannot launch another AI CLI'; Facts = @{ external_ai_unrequested = $true; helper_missing = $true }; Expected = 'reject_provider' },
    @{ Name = 'explicit external AI comparison with all filters met'; Facts = @{ explicit_external_ai_comparison = $true }; Expected = 'eligible' },
    @{ Name = 'explicit external comparison cannot permit new login'; Facts = @{ explicit_external_ai_comparison = $true; not_ready = $true }; Expected = 'inspect_or_alternative' },
    @{ Name = 'explicit external comparison cannot exceed data scope'; Facts = @{ explicit_external_ai_comparison = $true; out_of_scope_effects = $true }; Expected = 'reject_provider' },
    @{ Name = 'incompatible installed project version'; Facts = @{ project_version_mismatch = $true }; Expected = 'reject_provider' },
    @{ Name = 'provider lacks required evidence'; Facts = @{ insufficient_evidence = $true }; Expected = 'reject_provider' },
    @{ Name = 'platform deny cannot be overridden by preference'; Facts = @{ platform_denied = $true; preferred = $true }; Expected = 'reject_provider' }
)
Describe 'Capability foundation normalized source scenarios' {
    It '<Name>' -TestCases $capModeCases { param($Name,$Facts,$Expected); Invoke-CapRows $capModes $Facts | Should Be $Expected }
    It '<Name>' -TestCases $capReadinessCases { param($Name,$Facts,$Expected); Invoke-CapRows $capReadiness $Facts | Should Be $Expected }
    It '<Name>' -TestCases $capSelectionCases { param($Name,$Facts,$Expected); Invoke-CapRows $capSelection $Facts | Should Be $Expected }
    It 'readiness never supplies semantic authority or changes mode' {
        foreach ($state in @('ready','present_unverified','blocked','unavailable')) {
            Invoke-CapRows $capAuthority @{ provider_status = $state } | Should Be 'not_authorized'
            Invoke-CapRows $capModes @{ provider_status = $state } | Should Be 'direct'
        }
    }
    It 'a missing preferred provider does not block an eligible alternative' {
        Invoke-CapRows $capSelection @{ preferred = $true; not_ready = $true } | Should Be 'inspect_or_alternative'
        Invoke-CapRows $capSelection @{ alternate_provider = $true } | Should Be 'eligible'
        $capPolicy | Should Match 'Preferred != required'
        $capPolicy | Should Match 'Do not automatically request CLI installation'
    }
}
Describe 'Capability owner and consumer regression boundaries' {
    It 'keeps only four readiness states and a thin non-persistent owner' {
        ($capReadiness.Result | Sort-Object) -join ',' | Should Be 'blocked,present_unverified,ready,unavailable'
        ($capPolicy -split "`n").Count -lt 160 | Should Be $true
        $capPolicy | Should Match 'not a runtime engine'
        $capPolicy | Should Match 'no mandatory object or\s+execution spec for every task'
        $capPolicy | Should Match 'no Memory/Project Context writes'
        $capPolicy | Should Match 'add `checked_at` only when freshness matters'
        $capRouting | Should Match 'Ordinary tool calls are not\s+Assisted'
        $capRouting | Should Not Match 'helper/subagent/tool channels'
        $matrix = Read-CapSource 'Shared/platform-capability-matrix.md'
        $matrix | Should Match 'stores no session readiness'
        $matrix | Should Not Match 'No route or evidence path is available for this task'
    }
    It 'requires safe lazy discovery before optional execution' {
        foreach ($wrapper in @('npx','npm exec','bunx','bun x','uvx','uv tool run','pipx run','pnpm dlx','yarn dlx')) {
            $capPolicy.Contains('`' + $wrapper + '`') | Should Be $true
        }
        foreach ($required in @('Never run a','wrapper to see whether','package/bin metadata','before a probe','Discovery never','login, init, configure, install','Do not inspect credentials','Do not scan unrelated vendor tools')) {
            $capPolicy.Contains($required) | Should Be $true
        }
    }
    It 'decouples all active general consumers from legacy CLI references' {
        foreach ($file in Get-ChildItem (Join-Path $capRepo 'Shared') -Recurse -Filter '*.md') {
            if ($file.Name -in @('cli-delegation-sop.md','cli-capability-matrix.md','cli-prompt-skeleton.md')) { continue }
            $text = Get-Content $file.FullName -Raw -Encoding UTF8
            if ($text -match 'cli-delegation-sop\.md|cli-prompt-skeleton\.md|cli-capability-matrix\.md') { throw "Active legacy dependency: $($file.FullName)" }
        }
    }
    It 'removes forced tool branches without removing Team role separation' {
        $team = Read-CapSource 'Shared/policies/team-native-core.md'
        $team | Should Match 'Members are responsibility-bearing workers/roles/contexts'
        $team | Should Not Match 'A member can be.*(?:browser branch|CLI branch|MCP read path)'
        $dispatch = Read-CapSource 'Shared/skills/delegation-strategy/SKILL.md'
        $dispatch | Should Not Match 'CLI-only|-> `CLI branch`|-> `browser branch`|-> `MCP'
        $dispatch | Should Match 'capability-resolution.md'
        $review = Read-CapSource 'Shared/skills/quality-review-governance/SKILL.md'
        $review | Should Match 'review is not independent when the reviewer implemented'
        $browser = Read-CapSource 'Shared/skills/browser-testing/SKILL.md'
        $browser | Should Match 'Main using a browser remains Direct'
        $browser | Should Not Match 'Direct Browser tooling is allowed only|must not perform direct repair'
        $browser | Should Match 'They do not, by themselves, prove real data'
    }
    It 'keeps five GitNexus methods conditional with a non-invocable common reference' {
        foreach ($name in @('gitnexus-cli','gitnexus-exploring','gitnexus-debugging','gitnexus-impact-analysis','gitnexus-refactoring')) {
            $text = Read-CapSource "Shared/skills/$name/SKILL.md"
            $text | Should Match 'GitNexus Optional Pack'
            $text | Should Match 'capability-resolution.md'
            $text | Should Not Match 'All commands work via `npx`|→ run `npx|stale, run `npx'
        }
        $cli = Read-CapSource 'Shared/skills/gitnexus-cli/SKILL.md'
        $cli | Should Match 'KEEP_BUT_REWRITE'
        $guide = Read-CapSource 'Shared/policies/references/gitnexus-guide.md'
        foreach ($command in @('analyze','status','clean','wiki','list')) { $guide | Should Match ('\| ' + $command) }
        $guide | Should Match 'If Memory or Project Context is frozen'
        $guide | Should Match 'optional public publication are separately scoped effects'
        $guide | Should Match 'non-invocable Reference'
    }
    It 'removes automatic generic tool prerequisites while retaining later dispositions' {
        $audit = Read-CapSource 'Shared/skills/code-audit/SKILL.md'
        $diagnosis = Read-CapSource 'Shared/skills/code-diagnosis/SKILL.md'
        $audit | Should Match 'PROJECT_DERIVED'
        $diagnosis | Should Match 'RETIRE'
        ($audit + $diagnosis) | Should Not Match '\*\*Prerequisite\*\*: Load `delegation-strategy`|Conditions for delegating to CLI|npx eslint|npx tsc'
        $stack = Read-CapSource 'Shared/skills/tech-stack-protocol/SKILL.md'
        $stack | Should Not Match 'Run `node -v`, `python --version`, `go version`'
        $stack | Should Match 'Session readiness is not part of the long-term project matrix'
    }
    It 'guards conditional verifier recipes and distinguishes opt-in MCP startup' {
        foreach ($path in @('Shared/skills/test-patterns/SKILL.md','Shared/skills/performance-audit/SKILL.md')) {
            $text = Read-CapSource $path
            $text | Should Match 'capability-resolution.md'
            $text | Should Not Match 'npx (jest|vitest|lighthouse)|NOT MCP tools'
        }
        $profile = Read-CapSource 'Shared/mcp-profiles/README.md'
        $profile | Should Match 'not\s+presence probes'
        $profile | Should Match 'may download packages when activated'
        $visual = Read-CapSource 'Shared/skills/test-automation-strategy/SKILL.md'
        $visual | Should Match 'CLI-driven browser automation can supply real DOM'
    }
}
$capLegacyCases = @(
    @{ Name = 'cli-delegation-sop.md'; Hash = 'ab387dc5926832d10cdb90165372afb5c87ac97d3cc066082906a185bb09144a' },
    @{ Name = 'cli-capability-matrix.md'; Hash = 'ac83bb234a92644342de17a717bace8d0eac2a0d5aca869f61a6a6334e580b25' },
    @{ Name = 'cli-prompt-skeleton.md'; Hash = '6646b1fc62d132a27225ea903c92247cfd18848081cde0045844bf4e790363fd' }
)
Describe 'Inactive CLI history preserves frozen consumer content' {
    It '<Name>' -TestCases $capLegacyCases {
        param($Name,$Hash)
        $text = Read-CapSource "Shared/skills/delegation-strategy/references/$Name"
        $text | Should Match 'legacy / non-canonical / inactive'
        $body = [regex]::Match($text, '(?s)<!-- LEGACY_CLI_HISTORY_START -->\n(.*?)\n<!-- LEGACY_CLI_HISTORY_END -->')
        $body.Success | Should Be $true
        Get-CapHash $body.Groups[1].Value | Should Be $Hash
    }
}
