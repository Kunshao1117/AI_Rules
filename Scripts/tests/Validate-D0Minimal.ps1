#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$SkipNpmAudit
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$script:RepoRootFull = [IO.Path]::GetFullPath($script:RepoRoot).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)
$script:Results = New-Object System.Collections.Generic.List[object]

function Get-RepoPath {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    return Join-Path $script:RepoRoot $RelativePath
}

function Get-RelativeDisplayPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $script:RepoRootFull + [IO.Path]::DirectorySeparatorChar
    if ($full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($prefix.Length).Replace('\', '/')
    }

    return $full
}

function Read-TextFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing file: $(Get-RelativeDisplayPath -Path $Path)"
    }

    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    $text = Read-TextFile -Path $Path
    try {
        return $text | ConvertFrom-Json -ErrorAction Stop
    } catch {
        throw "Invalid JSON in $(Get-RelativeDisplayPath -Path $Path): $($_.Exception.Message)"
    }
}

function Assert-ContainsLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $text = Read-TextFile -Path $Path
    if ($text.IndexOf($Needle, [StringComparison]::Ordinal) -lt 0) {
        throw "Missing sentinel '$Label' in $(Get-RelativeDisplayPath -Path $Path)"
    }
}

function Assert-NotContainsLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $text = Read-TextFile -Path $Path
    if ($text.IndexOf($Needle, [StringComparison]::Ordinal) -ge 0) {
        throw "Forbidden sentinel '$Label' found in $(Get-RelativeDisplayPath -Path $Path)"
    }
}

function Assert-ContainsRegex {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Pattern,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $text = Read-TextFile -Path $Path
    if (-not [regex]::IsMatch($text, $Pattern)) {
        throw "Missing sentinel '$Label' in $(Get-RelativeDisplayPath -Path $Path)"
    }
}

function Assert-TextContainsLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if ($Text.IndexOf($Needle, [StringComparison]::Ordinal) -lt 0) {
        throw "Missing sentinel '$Label' in $Scope"
    }
}

function Assert-TextContainsRegex {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Pattern,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not [regex]::IsMatch($Text, $Pattern)) {
        throw "Missing sentinel '$Label' in $Scope"
    }
}

function Assert-TextLiteralOrder {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$First,
        [Parameter(Mandatory = $true)][string]$Second,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $firstIndex = $Text.IndexOf($First, [StringComparison]::Ordinal)
    $secondIndex = $Text.IndexOf($Second, [StringComparison]::Ordinal)
    if ($firstIndex -lt 0 -or $secondIndex -lt 0 -or $firstIndex -ge $secondIndex) {
        throw "Sentinel order '$Label' failed in $Scope"
    }
}

function Get-TextAfterLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $index = $Text.IndexOf($Needle, [StringComparison]::Ordinal)
    if ($index -lt 0) {
        throw "Missing sentinel '$Label' in $Scope"
    }

    return $Text.Substring($index + $Needle.Length)
}

function Get-TextBetweenLiteral {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Start,
        [Parameter(Mandatory = $true)][string]$End,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $text = Read-TextFile -Path $Path
    $startIndex = $text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) {
        throw "Missing sentinel '$Label start' in $(Get-RelativeDisplayPath -Path $Path)"
    }

    $endIndex = $text.IndexOf($End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -lt 0) {
        throw "Missing sentinel '$Label end' in $(Get-RelativeDisplayPath -Path $Path)"
    }

    return $text.Substring($startIndex, $endIndex - $startIndex)
}

function Invoke-Check {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$ScriptBlock
    )

    Write-Host "[RUN ] $Name"
    try {
        & $ScriptBlock
        $script:Results.Add([PSCustomObject]@{
            Name = $Name
            Passed = $true
            Error = $null
        }) | Out-Null
        Write-Host "[PASS] $Name"
    } catch {
        $script:Results.Add([PSCustomObject]@{
            Name = $Name
            Passed = $false
            Error = $_.Exception.Message
        }) | Out-Null
        Write-Host "[FAIL] $Name"
        Write-Host "       $($_.Exception.Message)"
    }
}

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [Parameter(Mandatory = $true)][string]$Label
    )

    Push-Location $WorkingDirectory
    try {
        Write-Host "> $FilePath $($Arguments -join ' ')"
        & $FilePath @Arguments
        $exitCode = if ($null -ne $global:LASTEXITCODE) { [int]$global:LASTEXITCODE } else { 0 }
        if ($exitCode -ne 0) {
            throw "$Label failed with exit code $exitCode"
        }
    } finally {
        Pop-Location
    }
}

function Resolve-LocalTsc {
    $binDir = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\node_modules\.bin"
    $names = @("tsc.cmd", "tsc", "tsc.ps1")
    foreach ($name in $names) {
        $candidate = Join-Path $binDir $name
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }

    throw "Missing local TypeScript compiler. Expected an existing tool under $(Get-RelativeDisplayPath -Path $binDir). No install was attempted."
}

function Resolve-NpmCommand {
    $npmCmd = Get-Command npm.cmd -ErrorAction SilentlyContinue
    if ($npmCmd) { return $npmCmd.Source }

    $npm = Get-Command npm -ErrorAction SilentlyContinue
    if ($npm) { return $npm.Source }

    throw "npm was not found on PATH."
}

function Resolve-NodeCommand {
    $nodeExe = Get-Command node.exe -ErrorAction SilentlyContinue
    if ($nodeExe) { return $nodeExe.Source }

    $node = Get-Command node -ErrorAction SilentlyContinue
    if ($node) { return $node.Source }

    throw "node was not found on PATH."
}

function Resolve-PowerShellCommand {
    $powershellExe = Get-Command powershell.exe -ErrorAction SilentlyContinue
    if ($powershellExe) { return $powershellExe.Source }

    throw "powershell.exe was not found on PATH."
}

function Read-PackageLockSummary {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing file: $(Get-RelativeDisplayPath -Path $Path)"
    }

    $node = Resolve-NodeCommand
    $parseScript = @'
const fs = require("fs");
const file = process.argv[1];
const data = JSON.parse(fs.readFileSync(file, "utf8"));
const packages = data.packages && typeof data.packages === "object" ? Object.keys(data.packages).length : 0;
console.log(JSON.stringify({
  name: data.name || "",
  version: data.version || "",
  lockfileVersion: data.lockfileVersion || 0,
  packageCount: packages
}));
'@

    $output = & $node -e $parseScript $Path
    $exitCode = if ($null -ne $global:LASTEXITCODE) { [int]$global:LASTEXITCODE } else { 0 }
    if ($exitCode -ne 0) {
        throw "Invalid JSON in $(Get-RelativeDisplayPath -Path $Path)"
    }

    return ($output -join "`n") | ConvertFrom-Json -ErrorAction Stop
}

function Test-PowerShellAstParse {
    $files = @(
        "Antigravity\install.ps1",
        "Claude\install.ps1",
        "Codex\install.ps1",
        "Scripts\modules\Audit.psm1",
        "Scripts\tests\Validate-SourceSizeGovernance.ps1"
    )

    $auditPartialsRoot = Get-RepoPath -RelativePath "Scripts\modules\Audit"
    if (Test-Path -LiteralPath $auditPartialsRoot -PathType Container) {
        $files += @(
            Get-ChildItem -LiteralPath $auditPartialsRoot -Filter "*.ps1" -File -ErrorAction Stop |
                Sort-Object FullName |
                ForEach-Object { Get-RelativeDisplayPath -Path $_.FullName }
        )
    }

    if ($PSCommandPath) {
        $files += (Get-RelativeDisplayPath -Path $PSCommandPath)
    }

    foreach ($relative in $files) {
        $path = Get-RepoPath -RelativePath $relative
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $path,
            [ref]$tokens,
            [ref]$errors
        ) | Out-Null

        if ($errors -and $errors.Count -gt 0) {
            $first = $errors[0]
            throw "PowerShell parse failed for ${relative}: $($first.Message)"
        }
    }
}

function Test-AuditModuleSmoke {
    $modulePath = Get-RepoPath -RelativePath "Scripts\modules\Audit.psm1"
    $module = Import-Module $modulePath -Force -PassThru -ErrorAction Stop

    $expectedExports = @(
        "Invoke-DocScan",
        "Invoke-HealthAudit",
        "Measure-SkillQuality",
        "Measure-WorkflowMetadata",
        "Measure-DocsConsistency",
        "Measure-PlatformCapability",
        "Measure-RuntimeGlobalDrift",
        "Measure-SharedSubagentPolicyDrift",
        "Measure-SubagentVocabularyDrift",
        "Measure-GovernanceSemantics",
        "Measure-ReviewGovernanceCoverage",
        "Measure-ProgrammingTeamGovernanceCoverage",
        "Measure-TeamNativeCoreSemantics",
        "Measure-TeamTraceEvidence",
        "Measure-CodexHookGovernance",
        "Measure-DirectorOutputContract",
        "Measure-DirectorFacingOutputQuality",
        "Measure-HighChangeGroundingGap",
        "Test-DirectorLanguageDominance",
        "Test-RawArtifactLedOutput",
        "Measure-ProjectSkillLinks",
        "Measure-SharedContextTemplates",
        "Measure-ProjectContextCards",
        "Measure-MemoryCardNaming",
        "Invoke-PlatformGovernanceAudit"
    )

    $exports = @($module.ExportedFunctions.Keys)
    foreach ($name in $expectedExports) {
        if ($exports -notcontains $name) {
            throw "Audit.psm1 did not export expected function: $name"
        }
    }

    $unexpected = @($exports | Where-Object { $expectedExports -notcontains $_ } | Sort-Object)
    if ($unexpected.Count -gt 0) {
        throw "Audit.psm1 exported unexpected functions: $($unexpected -join ', ')"
    }
}

function Test-ExtensionJson {
    $packagePath = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\package.json"
    $tsconfigPath = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\tsconfig.json"
    $lockPath = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\package-lock.json"

    $package = Read-JsonFile -Path $packagePath
    $tsconfig = Read-JsonFile -Path $tsconfigPath
    $lock = Read-PackageLockSummary -Path $lockPath

    if ($package.name -ne "ai-rules-manager") {
        throw "Unexpected package name: $($package.name)"
    }
    if ($package.version -notmatch '^\d+\.\d+\.\d+$') {
        throw "Package version is not semver-like: $($package.version)"
    }
    if (-not $package.scripts.audit) {
        throw "package.json is missing scripts.audit"
    }
    if ($package.main -ne "./out/extension.js" -and $package.main -ne "out/extension.js") {
        throw "package.json main must point to out/extension.js"
    }
    if (-not $package.scripts.'verify:runtime') {
        throw "package.json is missing scripts.verify:runtime"
    }
    $verifyRuntime = [string]$package.scripts.'verify:runtime'
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "node -e" -Scope "package.json scripts.verify:runtime" -Label "node runtime verifier"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "out/extension.js" -Scope "package.json scripts.verify:runtime" -Label "extension main runtime"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "out/scriptRunner.js" -Scope "package.json scripts.verify:runtime" -Label "scriptRunner runtime"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "vscode.workspace.isTrusted" -Scope "package.json scripts.verify:runtime" -Label "runtime workspace trust sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "assertGitRepoIdentity" -Scope "package.json scripts.verify:runtime" -Label "runtime repo identity sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "assertManagedPath" -Scope "package.json scripts.verify:runtime" -Label "runtime managed path sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "assertTrackedCleanManagerScript" -Scope "package.json scripts.verify:runtime" -Label "runtime tracked clean script sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "+refs/heads/" -Scope "package.json scripts.verify:runtime" -Label "runtime explicit fetch source sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle ":refs/remotes/origin/" -Scope "package.json scripts.verify:runtime" -Label "runtime explicit fetch destination sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "assertReadyToRun(source, script, target)" -Scope "package.json scripts.verify:runtime" -Label "runtime readiness gate sentinel"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "cp.spawn(ps, args" -Scope "package.json scripts.verify:runtime" -Label "runtime spawn sentinel"
    Assert-TextLiteralOrder -Text $verifyRuntime -First "assertReadyToRun(source, script, target)" -Second "cp.spawn(ps, args" -Scope "package.json scripts.verify:runtime" -Label "runtime readiness before spawn"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "order('assertGitRepoIdentity(managedRoot, repoUrl)','--hard'" -Scope "package.json scripts.verify:runtime" -Label "runtime identity before destructive reset order gate"
    Assert-TextContainsLiteral -Text $verifyRuntime -Needle "order('assertManagedPath(storageRoot, managedRoot);','--hard'" -Scope "package.json scripts.verify:runtime" -Label "runtime managed path before destructive reset order gate"
    $prepublish = [string]$package.scripts.'vscode:prepublish'
    Assert-TextContainsLiteral -Text $prepublish -Needle "npm run compile" -Scope "package.json scripts.vscode:prepublish" -Label "prepublish compile gate"
    Assert-TextContainsLiteral -Text $prepublish -Needle "npm run verify:runtime" -Scope "package.json scripts.vscode:prepublish" -Label "prepublish runtime verify gate"
    Assert-TextLiteralOrder -Text $prepublish -First "npm run compile" -Second "npm run verify:runtime" -Scope "package.json scripts.vscode:prepublish" -Label "prepublish compile before runtime verify"
    if (-not $package.devDependencies.typescript) {
        throw "package.json is missing devDependencies.typescript"
    }
    if ($tsconfig.compilerOptions.strict -ne $true) {
        throw "tsconfig.json must keep compilerOptions.strict enabled"
    }
    if ($lock.name -ne $package.name) {
        throw "package-lock.json name does not match package.json"
    }
    if ($lock.version -ne $package.version) {
        throw "package-lock.json version does not match package.json"
    }
    if ([int]$lock.lockfileVersion -lt 3) {
        throw "package-lock.json lockfileVersion must be at least 3"
    }
    if ([int]$lock.packageCount -lt 1) {
        throw "package-lock.json does not contain package entries"
    }
}

function Test-LocalTscNoEmit {
    $extensionRoot = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager"
    $tsc = Resolve-LocalTsc
    Invoke-NativeCommand -FilePath $tsc -Arguments @("--noEmit", "-p", ".") -WorkingDirectory $extensionRoot -Label "tsc --noEmit"
}

function Test-NpmAudit {
    if ($SkipNpmAudit) {
        Write-Host "[SKIP] npm audit was explicitly skipped with -SkipNpmAudit"
        return
    }

    $extensionRoot = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager"
    $npm = Resolve-NpmCommand
    Invoke-NativeCommand -FilePath $npm -Arguments @("audit", "--package-lock-only", "--audit-level=high") -WorkingDirectory $extensionRoot -Label "npm audit"
}

function Test-SourceSizeGovernanceBaseline {
    $testPath = Get-RepoPath -RelativePath "Scripts\tests\Validate-SourceSizeGovernance.ps1"
    $powershell = Resolve-PowerShellCommand
    Invoke-NativeCommand -FilePath $powershell -Arguments @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $testPath, "-NoFail") -WorkingDirectory $script:RepoRoot -Label "source size governance no-fail baseline"
}

function Test-VscodeIgnoreRuntimePackaging {
    $ignorePath = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\.vscodeignore"
    $entries = @(
        (Read-TextFile -Path $ignorePath) -split "\r?\n" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -and -not $_.StartsWith("#") }
    )

    if ($entries -notcontains "src/") {
        throw ".vscodeignore must exclude src/"
    }

    if (($entries -notcontains "**/*.map") -and ($entries -notcontains "*.map")) {
        throw ".vscodeignore must exclude source maps"
    }

    $outExclusions = @(
        $entries |
            Where-Object { -not $_.StartsWith("!") } |
            ForEach-Object { $_.Replace('\', '/') } |
            Where-Object { $_ -match '(^|/)out($|/|\*\*)' }
    )

    if ($outExclusions.Count -gt 0) {
        throw ".vscodeignore must not exclude compiled out runtime. Found: $($outExclusions -join ', ')"
    }
}

function Test-ReleaseWorkflowSentinels {
    $workflow = Get-RepoPath -RelativePath ".github\workflows\release-vsix.yml"
    $workflowText = Read-TextFile -Path $workflow
    $releaseStep = Get-TextAfterLiteral -Text $workflowText -Needle "- name: Create or update GitHub release" -Scope "release workflow" -Label "release step"

    Assert-ContainsLiteral -Path $workflow -Needle '"v[0-9]*.[0-9]*.[0-9]*"' -Label "semver tag trigger"
    Assert-ContainsLiteral -Path $workflow -Needle '^v[0-9]+\.[0-9]+\.[0-9]+$' -Label "explicit semver tag validation"
    Assert-ContainsLiteral -Path $workflow -Needle "Verify tag matches extension version" -Label "tag version check step"
    Assert-ContainsLiteral -Path $workflow -Needle 'require(''./Extensions/vscode-ai-rules-manager/package.json'').version' -Label "extension package version read"
    Assert-ContainsLiteral -Path $workflow -Needle 'expected="v${version}"' -Label "expected version tag"
    Assert-ContainsLiteral -Path $workflow -Needle "actions/checkout@" -Label "checkout action"
    Assert-ContainsLiteral -Path $workflow -Needle 'ref: refs/tags/${{ steps.ref.outputs.tag }}' -Label "checkout explicit tag ref"
    Assert-ContainsLiteral -Path $workflow -Needle "persist-credentials: false" -Label "checkout credential persistence disabled"
    Assert-ContainsLiteral -Path $workflow -Needle "Audit dependencies" -Label "release dependency audit step"
    Assert-ContainsLiteral -Path $workflow -Needle "npm run audit" -Label "release npm audit command"
    Assert-ContainsLiteral -Path $workflow -Needle "Compile extension" -Label "release compile step"
    Assert-ContainsLiteral -Path $workflow -Needle "npm run compile" -Label "release compile command"
    Assert-ContainsLiteral -Path $workflow -Needle "Verify compiled runtime" -Label "release runtime verify step"
    Assert-ContainsLiteral -Path $workflow -Needle "npm run verify:runtime" -Label "release runtime verify command"
    Assert-ContainsLiteral -Path $workflow -Needle "Package VSIX" -Label "release package step"
    Assert-ContainsLiteral -Path $workflow -Needle "npm run package" -Label "release package command"
    Assert-ContainsLiteral -Path $workflow -Needle "Verify VSIX runtime sentinels" -Label "release VSIX runtime verify step"
    Assert-ContainsLiteral -Path $workflow -Needle "extension/out/scriptRunner.js" -Label "VSIX scriptRunner runtime path"
    Assert-ContainsLiteral -Path $workflow -Needle "vscode.workspace.isTrusted" -Label "VSIX workspace trust sentinel"
    Assert-ContainsLiteral -Path $workflow -Needle "assertGitRepoIdentity" -Label "VSIX repo identity sentinel"
    Assert-ContainsLiteral -Path $workflow -Needle "assertManagedPath" -Label "VSIX managed path sentinel"
    Assert-ContainsLiteral -Path $workflow -Needle "assertTrackedCleanManagerScript" -Label "VSIX tracked clean script sentinel"
    Assert-ContainsLiteral -Path $workflow -Needle "+refs/heads/" -Label "VSIX explicit fetch source sentinel"
    Assert-ContainsLiteral -Path $workflow -Needle ":refs/remotes/origin/" -Label "VSIX explicit fetch destination sentinel"
    Assert-TextLiteralOrder -Text $workflowText -First "npm run compile" -Second "npm run verify:runtime" -Scope "release workflow" -Label "release compile before runtime verify"
    Assert-TextLiteralOrder -Text $workflowText -First "npm run verify:runtime" -Second "npm run package" -Scope "release workflow" -Label "release runtime verify before package"
    Assert-TextLiteralOrder -Text $workflowText -First "npm run package" -Second "Verify VSIX runtime sentinels" -Scope "release workflow" -Label "release package before VSIX verify"
    Assert-TextLiteralOrder -Text $workflowText -First "Verify VSIX runtime sentinels" -Second "- name: Create or update GitHub release" -Scope "release workflow" -Label "release VSIX verify before release upload"
    Assert-ContainsLiteral -Path $workflow -Needle "Release asset already exists" -Label "asset existence check"
    Assert-ContainsLiteral -Path $workflow -Needle "Refusing to overwrite" -Label "asset no-clobber failure"
    Assert-NotContainsLiteral -Path $workflow -Needle "--clobber" -Label "release upload clobber flag"
    Assert-TextLiteralOrder -Text $releaseStep -First 'if [[ ! -f "${vsix}" ]]; then' -Second 'gh release upload "${TAG_NAME}" "${vsix}" --repo "${GITHUB_REPOSITORY}"' -Scope "release upload step" -Label "asset exists before existing release upload"
    Assert-TextLiteralOrder -Text $releaseStep -First 'if [[ ! -f "${vsix}" ]]; then' -Second 'gh release create "${TAG_NAME}" "${vsix}" \' -Scope "release upload step" -Label "asset exists before new release upload"
    Assert-TextLiteralOrder -Text $releaseStep -First 'if [[ "${existing_asset}" == "${asset_name}" ]]; then' -Second 'gh release upload "${TAG_NAME}" "${vsix}" --repo "${GITHUB_REPOSITORY}"' -Scope "release upload step" -Label "no-clobber branch before upload"
    Assert-TextLiteralOrder -Text $releaseStep -First "Refusing to overwrite." -Second 'gh release upload "${TAG_NAME}" "${vsix}" --repo "${GITHUB_REPOSITORY}"' -Scope "release upload step" -Label "no-clobber failure before upload"
}

function Test-InstallerSentinels {
    $installers = @(
        [PSCustomObject]@{ Path = "Antigravity\install.ps1"; Platform = "Antigravity" },
        [PSCustomObject]@{ Path = "Claude\install.ps1"; Platform = "Claude" },
        [PSCustomObject]@{ Path = "Codex\install.ps1"; Platform = "Codex" }
    )

    foreach ($installer in $installers) {
        $path = Get-RepoPath -RelativePath $installer.Path
        Assert-ContainsLiteral -Path $path -Needle "function Assert-SafeRef" -Label "safe ref helper"
        Assert-ContainsLiteral -Path $path -Needle 'Assert-SafeRef -Name "Branch" -Value $Branch' -Label "safe branch validation"
        Assert-ContainsLiteral -Path $path -Needle "function Assert-Sha256Value" -Label "sha256 value validation helper"
        Assert-ContainsLiteral -Path $path -Needle "function Get-Sha256Hex" -Label "sha256 hash helper"
        Assert-ContainsLiteral -Path $path -Needle "Downloaded ZIP SHA256 mismatch." -Label "download sha256 comparison"
        Assert-ContainsRegex -Path $path -Pattern '(?s)if\s*\(\$ExpectedZipSha256\s+-and\s+\$actualZipSha256\s+-ne\s+\$ExpectedZipSha256\.ToLowerInvariant\(\)\)\s*\{\s*throw\s+"Downloaded ZIP SHA256 mismatch\."\s*\}' -Label "download sha256 compare expression and throw"
        Assert-ContainsLiteral -Path $path -Needle "function Resolve-SafePath" -Label "safe path resolver"
        Assert-ContainsLiteral -Path $path -Needle "function Assert-ChildPath" -Label "child path guard"
        Assert-ContainsLiteral -Path $path -Needle '$zipUri.Scheme -ne "https"' -Label "https download guard"
        Assert-ContainsLiteral -Path $path -Needle '$zipUri.Host -ne "github.com"' -Label "download host guard"
        Assert-ContainsLiteral -Path $path -Needle '$zipUri.AbsolutePath -ne $zipPath' -Label "download path guard"
        Assert-ContainsLiteral -Path $path -Needle "function Write-DownloadReceipt" -Label "receipt writer"
        Assert-ContainsLiteral -Path $path -Needle 'status       = "downloaded"' -Label "download receipt status"
        Assert-ContainsLiteral -Path $path -Needle 'status = "failed"' -Label "failure receipt status"
        Assert-ContainsLiteral -Path $path -Needle "finally {" -Label "cleanup finally block"
        Assert-ContainsLiteral -Path $path -Needle "Remove-Item -LiteralPath `$tempZip" -Label "temp zip cleanup"
        Assert-ContainsLiteral -Path $path -Needle "Remove-Item -LiteralPath `$tempDir" -Label "temp dir cleanup"
        Assert-ContainsLiteral -Path $path -Needle "-Platform $($installer.Platform)" -Label "platform-specific deploy dispatch"
    }
}

function Test-ScriptRunnerSentinels {
    $runner = Get-RepoPath -RelativePath "Extensions\vscode-ai-rules-manager\src\scriptRunner.ts"
    $runBody = Get-TextBetweenLiteral -Path $runner -Start "async run(action: ManagerAction" -End "  private async resolveRepoRoot" -Label "script runner run method"
    $alignBody = Get-TextBetweenLiteral -Path $runner -Start "private async alignManagedRepoRoot" -End "  private runGit(args" -Label "managed repo alignment method"
    $postCheckoutAlignBody = Get-TextAfterLiteral -Text $alignBody -Needle 'await this.runGit(["checkout", "-B", MANAGED_BRANCH, `origin/${MANAGED_BRANCH}`], managedRoot);' -Scope "managed repo alignment method" -Label "managed repo checkout before origin reset"

    Assert-ContainsLiteral -Path $runner -Needle "private assertWorkspaceTrusted()" -Label "workspace trust helper"
    Assert-ContainsLiteral -Path $runner -Needle "vscode.workspace.isTrusted" -Label "workspace trust enforcement"
    Assert-ContainsLiteral -Path $runner -Needle "private async assertGitRepoIdentity" -Label "repo identity helper"
    Assert-ContainsLiteral -Path $runner -Needle '"rev-parse", "--show-toplevel"' -Label "git top-level check"
    Assert-ContainsLiteral -Path $runner -Needle '"remote", "get-url", "origin"' -Label "git origin identity check"
    Assert-ContainsLiteral -Path $runner -Needle "this.sameRepoUrl(normalizedRemoteUrl, expectedRepoUrl)" -Label "expected origin comparison"
    Assert-ContainsLiteral -Path $runner -Needle "private assertManagedPath" -Label "managed path guard"
    Assert-ContainsLiteral -Path $runner -Needle "this.context.globalStorageUri.fsPath" -Label "managed storage root"
    Assert-ContainsLiteral -Path $runner -Needle "this.isPathInside(storage, managed, false)" -Label "managed path containment"
    Assert-ContainsLiteral -Path $runner -Needle "private async assertTrackedCleanManagerScript" -Label "tracked clean script helper"
    Assert-ContainsLiteral -Path $runner -Needle '"ls-files", "--error-unmatch", "--", MANAGER_SCRIPT_GIT_PATH' -Label "manager script tracked check"
    Assert-ContainsLiteral -Path $runner -Needle '"status", "--porcelain", "--", MANAGER_SCRIPT_GIT_PATH' -Label "manager script clean check"
    Assert-ContainsLiteral -Path $runner -Needle "+refs/heads/`${MANAGED_BRANCH}:refs/remotes/origin/`${MANAGED_BRANCH}" -Label "explicit fetch refspec"
    Assert-TextLiteralOrder -Text $runBody -First "await this.assertReadyToRun(source, script, target);" -Second 'const child = cp.spawn(ps, args, { cwd: repoRoot, windowsHide: true });' -Scope "scriptRunner.ts run method" -Label "readiness gate before manager spawn"
    Assert-TextContainsLiteral -Text $alignBody -Needle 'if (!this.isUsableManagedRepo(managedRoot)) {' -Scope "managed repo alignment method" -Label "usable managed repo guard"
    Assert-TextContainsLiteral -Text $alignBody -Needle 'await this.runGit(["reset", "--hard"], managedRoot);' -Scope "managed repo alignment method" -Label "managed reset hard"
    Assert-TextContainsLiteral -Text $alignBody -Needle 'await this.runGit(["clean", "-fdx"], managedRoot);' -Scope "managed repo alignment method" -Label "managed clean fdx"
    Assert-TextContainsLiteral -Text $alignBody -Needle 'await this.runGit(["reset", "--hard", `origin/${MANAGED_BRANCH}`], managedRoot);' -Scope "managed repo alignment method" -Label "managed origin reset hard"
    Assert-TextLiteralOrder -Text $alignBody -First 'if (!this.isUsableManagedRepo(managedRoot)) {' -Second "await this.assertGitRepoIdentity(managedRoot, repoUrl);" -Scope "managed repo alignment method" -Label "repo usability before identity guard"
    Assert-TextLiteralOrder -Text $alignBody -First "await this.assertGitRepoIdentity(managedRoot, repoUrl);" -Second 'await this.runGit(["reset", "--hard"], managedRoot);' -Scope "managed repo alignment method" -Label "repo identity before destructive reset"
    Assert-TextLiteralOrder -Text $alignBody -First "await this.assertGitRepoIdentity(managedRoot, repoUrl);" -Second 'await this.runGit(["clean", "-fdx"], managedRoot);' -Scope "managed repo alignment method" -Label "repo identity before destructive clean"
    Assert-TextContainsRegex -Text $alignBody -Pattern '(?s)this\.assertManagedPath\(storageRoot, managedRoot\);\s+await this\.runGit\(\["reset", "--hard"\], managedRoot\);' -Scope "managed repo alignment method" -Label "managed path guard immediately before reset"
    Assert-TextContainsRegex -Text $alignBody -Pattern '(?s)this\.assertManagedPath\(storageRoot, managedRoot\);\s+await this\.runGit\(\["clean", "-fdx"\], managedRoot\);' -Scope "managed repo alignment method" -Label "managed path guard immediately before clean"
    Assert-TextContainsRegex -Text $postCheckoutAlignBody -Pattern '(?s)this\.assertManagedPath\(storageRoot, managedRoot\);\s+await this\.runGit\(\["reset", "--hard", `origin/\$\{MANAGED_BRANCH\}`\], managedRoot\);' -Scope "managed repo post-checkout alignment method" -Label "managed path guard before origin reset"
    Assert-TextContainsRegex -Text $postCheckoutAlignBody -Pattern '(?s)this\.assertManagedPath\(storageRoot, managedRoot\);\s+await this\.runGit\(\["clean", "-fdx"\], managedRoot\);' -Scope "managed repo post-checkout alignment method" -Label "managed path guard before post-checkout clean"
    Assert-TextLiteralOrder -Text $postCheckoutAlignBody -First 'await this.runGit(["clean", "-fdx"], managedRoot);' -Second "await this.assertGitRepoIdentity(managedRoot, repoUrl);" -Scope "managed repo post-checkout alignment method" -Label "repo identity after destructive alignment"
    Assert-TextLiteralOrder -Text $postCheckoutAlignBody -First "await this.assertGitRepoIdentity(managedRoot, repoUrl);" -Second "await this.assertManagedRepoHead(managedRoot);" -Scope "managed repo post-checkout alignment method" -Label "repo head alignment guard after identity"
}

Invoke-Check -Name "PowerShell AST parse" -ScriptBlock { Test-PowerShellAstParse }
Invoke-Check -Name "Audit.psm1 import/export smoke" -ScriptBlock { Test-AuditModuleSmoke }
Invoke-Check -Name "extension JSON parse" -ScriptBlock { Test-ExtensionJson }
Invoke-Check -Name "extension VSIX ignore runtime packaging" -ScriptBlock { Test-VscodeIgnoreRuntimePackaging }
Invoke-Check -Name "local tsc --noEmit" -ScriptBlock { Test-LocalTscNoEmit }
Invoke-Check -Name "npm audit package-lock high" -ScriptBlock { Test-NpmAudit }
Invoke-Check -Name "source size governance baseline smoke" -ScriptBlock { Test-SourceSizeGovernanceBaseline }
Invoke-Check -Name "1A release workflow sentinels" -ScriptBlock { Test-ReleaseWorkflowSentinels }
Invoke-Check -Name "1A installer sentinels" -ScriptBlock { Test-InstallerSentinels }
Invoke-Check -Name "1A scriptRunner sentinels" -ScriptBlock { Test-ScriptRunnerSentinels }

$failed = @($script:Results | Where-Object { -not $_.Passed })
Write-Host ""
Write-Host "D0 minimal validation summary"
Write-Host "Passed: $($script:Results.Count - $failed.Count)"
Write-Host "Failed: $($failed.Count)"

if ($failed.Count -gt 0) {
    foreach ($failure in $failed) {
        Write-Host "- $($failure.Name): $($failure.Error)"
    }
    exit 1
}

Write-Host "All D0 minimal validation checks passed."
