function Get-CodexHookGovernanceCatalogPath {
    Join-Path (Split-Path -Parent $PSScriptRoot) 'CodexHookGovernance.catalog.json'
}

function Get-CodexHookGovernanceCatalog {
    $catalogPath = Get-CodexHookGovernanceCatalogPath
    if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) {
        throw ("Codex hook governance catalog not found: {0}" -f $catalogPath)
    }

    Get-Content -LiteralPath $catalogPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
}

function Get-CodexHookSupportedEventCatalog {
    $catalog = Get-CodexHookGovernanceCatalog
    @($catalog.supportedEvents | ForEach-Object {
        [PSCustomObject]@{
            EventName     = [string]$_.EventName
            StatusMessage = [string]$_.StatusMessage
        }
    })
}

function Get-CodexHookOptionalFutureEventCatalog {
    $catalog = Get-CodexHookGovernanceCatalog
    @($catalog.optionalFutureEvents | ForEach-Object {
        [PSCustomObject]@{
            EventName = [string]$_.EventName
            Status    = [string]$_.Status
        }
    })
}

function Get-CodexHookScriptRequirementCatalog {
    $catalog = Get-CodexHookGovernanceCatalog
    @($catalog.scriptRequirements | ForEach-Object {
        [PSCustomObject]@{
            Pattern  = [string]$_.Pattern
            Severity = [string]$_.Severity
            Reason   = [string]$_.Reason
        }
    })
}

function Get-CodexHookRequiredFixtureCatalog {
    $catalog = Get-CodexHookGovernanceCatalog
    @($catalog.requiredFixtures | ForEach-Object {
        [PSCustomObject]@{
            File              = [string]$_.File
            CanonicalDecision = [string]$_.CanonicalDecision
        }
    })
}

function Get-CodexHookCanonicalDecisionValues {
    $catalog = Get-CodexHookGovernanceCatalog
    @($catalog.canonicalDecisionValues | ForEach-Object { [string]$_ })
}

function Resolve-CodexHookFixtureCanonicalDecision {
    param([object]$Fixture)

    if ($null -eq $Fixture) { return '' }
    $canonicalProperty = $Fixture.PSObject.Properties['canonicalDecision']
    if ($null -ne $canonicalProperty -and -not [string]::IsNullOrWhiteSpace([string]$canonicalProperty.Value)) {
        return [string]$canonicalProperty.Value
    }

    $expectedDecision = ''
    if ($Fixture.PSObject.Properties['expectedDecision']) { $expectedDecision = [string]$Fixture.expectedDecision }
    $expectedOutcomeKind = ''
    if ($Fixture.PSObject.Properties['expectedOutcomeKind']) { $expectedOutcomeKind = [string]$Fixture.expectedOutcomeKind }

    if ($expectedDecision -eq 'block') { return 'block' }
    if ($expectedDecision -eq 'deny') { return 'deny' }
    if ($expectedOutcomeKind -eq 'allow') { return 'allow' }
    return 'advisory'
}
