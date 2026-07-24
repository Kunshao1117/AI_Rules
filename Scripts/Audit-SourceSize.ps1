#Requires -Version 5.1
<##
.SYNOPSIS
    盤點 AI_Rules canonical source 中超過文件大小治理門檻的檔案。

.DESCRIPTION
    此 facade 保留既有參數與輸出行為；掃描與產物建立由
    Scripts/modules/SourceSize-Audit.psm1 擁有。
#>
[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),

    [string]$OutputPath,

    [string]$ReadingIndexPath,

    [string[]]$KnownBaselineTarget = @(
        'Scripts/AI-RulesManager.ps1',
        'Scripts/modules/Core.psm1',
        'Shared/policies/team-trace-evidence.md',
        'Shared/skills/team-task-board/references/board-field-catalog.md'
    ),

    [switch]$PassThru
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module -Name (Join-Path $PSScriptRoot 'modules\SourceSize-Audit.psm1') -Force -ErrorAction Stop

$invokeParameters = @{
    RepoRoot            = $RepoRoot
    KnownBaselineTarget = $KnownBaselineTarget
    PassThru            = $PassThru
}
if ($PSBoundParameters.ContainsKey('OutputPath')) {
    $invokeParameters.OutputPath = $OutputPath
}
if ($PSBoundParameters.ContainsKey('ReadingIndexPath')) {
    $invokeParameters.ReadingIndexPath = $ReadingIndexPath
}

Invoke-SourceSizeAudit @invokeParameters
