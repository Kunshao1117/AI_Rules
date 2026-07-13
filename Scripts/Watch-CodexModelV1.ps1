<#
.SYNOPSIS
    Local experimental workaround for a user-local Codex models cache.

.DESCRIPTION
    This is a local experimental workaround only. It is not a formal Codex adapter capability and not a platform guarantee. It may update only the
    current user's effective Codex home models_cache.json, and only changes
    exact multi_agent_version v2 values to v1 using byte-local writes.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Path,

    [Parameter()]
    [ValidateRange(100, 60000)]
    [int]$PollIntervalMilliseconds = 250,

    [Parameter()]
    [ValidateSet('Menu', 'Watch', 'WatchAndLaunch')]
    [string]$Mode = 'Menu'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$multiAgentVersionPattern = '(?<prefix>"multi_agent_version"\s*:\s*)"v(?<version>2)"'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false, $true)
$utf8WithBom = [System.Text.UTF8Encoding]::new($true, $true)
$lastMissingNotice = [datetime]::MinValue
$lastBusyNotice = [datetime]::MinValue

if ($null -eq ('CodexModelV1NativeMethods' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;

public static class CodexModelV1NativeMethods
{
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "GetFinalPathNameByHandleW")]
    public static extern uint GetFinalPathNameByHandleW(
        SafeFileHandle hFile,
        System.Text.StringBuilder lpszFilePath,
        uint cchFilePath,
        uint dwFlags);
}
'@
}

function Get-ExpectedCodexModelsCachePath {
    $codexHome = if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $env:CODEX_HOME
    }
    else {
        Join-Path $env:USERPROFILE '.codex'
    }

    if ([string]::IsNullOrWhiteSpace($codexHome) -or $codexHome.StartsWith('\\')) {
        throw 'The effective Codex home must be a local, non-UNC path.'
    }

    $expectedPath = [System.IO.Path]::GetFullPath((Join-Path $codexHome 'models_cache.json'))
    if ($expectedPath.StartsWith('\\')) {
        throw 'The effective Codex models cache must not be a UNC path.'
    }

    return $expectedPath
}

function Assert-PathHasNoReparsePoint {
    param(
        [Parameter(Mandatory)]
        [string]$FullPath
    )

    $root = [System.IO.Path]::GetPathRoot($FullPath)
    if ([string]::IsNullOrWhiteSpace($root)) {
        throw "Could not determine a path root: $FullPath"
    }

    $currentPath = $root
    $remainingSegments = $FullPath.Substring($root.Length).Split(
        [char[]]@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar),
        [System.StringSplitOptions]::RemoveEmptyEntries
    )

    foreach ($segment in $remainingSegments) {
        $currentPath = Join-Path $currentPath $segment
        if (-not (Test-Path -LiteralPath $currentPath)) {
            break
        }

        $item = Get-Item -LiteralPath $currentPath -Force
        if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "Reparse points are not allowed in the Codex models cache path: $currentPath"
        }
    }
}

function Resolve-ValidatedCodexModelsCachePath {
    param(
        [Parameter()]
        [string]$CandidatePath
    )

    $expectedPath = Get-ExpectedCodexModelsCachePath
    $candidate = if ([string]::IsNullOrWhiteSpace($CandidatePath)) { $expectedPath } else { $CandidatePath }
    if ($candidate.StartsWith('\\')) {
        throw 'UNC paths are not allowed for the Codex models cache.'
    }

    $candidatePath = [System.IO.Path]::GetFullPath($candidate)
    if ($candidatePath.StartsWith('\\') -or -not [string]::Equals($candidatePath, $expectedPath, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Only the effective Codex models cache path is allowed: $expectedPath"
    }

    Assert-PathHasNoReparsePoint -FullPath $expectedPath
    return $expectedPath
}

function ConvertFrom-ExtendedWindowsPath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if ($Path.StartsWith('\\?\UNC\', [System.StringComparison]::OrdinalIgnoreCase)) {
        return '\\' + $Path.Substring(8)
    }
    if ($Path.StartsWith('\\?\', [System.StringComparison]::Ordinal)) {
        return $Path.Substring(4)
    }
    return $Path
}

function Get-ValidatedFinalPathFromHandle {
    param(
        [Parameter(Mandatory)]
        [Microsoft.Win32.SafeHandles.SafeFileHandle]$SafeFileHandle
    )

    if ($SafeFileHandle.IsInvalid -or $SafeFileHandle.IsClosed) {
        throw 'Could not validate the final cache path from an invalid file handle.'
    }

    $bufferCapacity = 32768
    $buffer = [System.Text.StringBuilder]::new($bufferCapacity)
    $result = [CodexModelV1NativeMethods]::GetFinalPathNameByHandleW(
        $SafeFileHandle,
        $buffer,
        [uint32]$bufferCapacity,
        0
    )
    if ($result -eq 0 -or $result -ge $bufferCapacity) {
        $win32Error = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Could not validate the final cache path from the opened file handle (GetFinalPathNameByHandleW result=$result, Win32Error=$win32Error)."
    }

    return ConvertFrom-ExtendedWindowsPath -Path $buffer.ToString()
}

function Set-CodexModelVersionV1 {
    param(
        [Parameter(Mandatory)]
        [string]$TargetPath
    )

    $stream = $null
    $writeAttempted = $false
    $writeVerified = $false
    $operationException = $null
    $disposeException = $null
    $result = $null

    try {
        # Revalidate the canonical cache path and every existing path segment immediately before each open.
        $expectedPath = Resolve-ValidatedCodexModelsCachePath -CandidatePath $TargetPath

        # Hold an exclusive lock while validating the actual handle target, reading, and applying only exact byte offsets.
        $stream = [System.IO.File]::Open(
            $expectedPath,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::ReadWrite,
            [System.IO.FileShare]::None
        )

        $finalPath = Get-ValidatedFinalPathFromHandle -SafeFileHandle $stream.SafeFileHandle
        if (-not [string]::Equals($finalPath, $expectedPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Opened cache path differs from the expected effective Codex cache path. Expected: $expectedPath; actual: $finalPath"
        }

        if ($stream.Length -gt [int]::MaxValue) {
            throw 'The Codex models cache is too large for the guarded byte-local update.'
        }

        $bytes = [byte[]]::new([int]$stream.Length)
        $offset = 0
        while ($offset -lt $bytes.Length) {
            $read = $stream.Read($bytes, $offset, $bytes.Length - $offset)
            if ($read -eq 0) { break }
            $offset += $read
        }
        if ($offset -ne $bytes.Length) {
            throw "Could not read the complete model cache. Read $offset of $($bytes.Length) bytes."
        }

        $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
        $preambleLength = if ($hasBom) { 3 } else { 0 }
        $encoding = if ($hasBom) { $utf8WithBom } else { $utf8NoBom }
        try {
            $text = $encoding.GetString($bytes, $preambleLength, $bytes.Length - $preambleLength)
            $null = $text | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            throw "Models cache format is not strict UTF-8 JSON: $($_.Exception.Message)"
        }

        $matches = [regex]::Matches($text, $multiAgentVersionPattern)
        if ($matches.Count -eq 0) {
            $result = 0
        }
        else {
            $updatedText = [regex]::Replace($text, $multiAgentVersionPattern, '${prefix}"v1"')
            $updatedContentBytes = $encoding.GetBytes($updatedText)
            $updatedBytes = if ($hasBom) {
                $preamble = $encoding.GetPreamble()
                $combined = [byte[]]::new($preamble.Length + $updatedContentBytes.Length)
                [Array]::Copy($preamble, 0, $combined, 0, $preamble.Length)
                [Array]::Copy($updatedContentBytes, 0, $combined, $preamble.Length, $updatedContentBytes.Length)
                $combined
            }
            else {
                $updatedContentBytes
            }
            if ($updatedBytes.Length -ne $bytes.Length) {
                throw 'Safety check failed: conversion changed the cache byte length.'
            }

            $expectedChangedOffsets = [System.Collections.Generic.HashSet[int]]::new()
            foreach ($match in $matches) {
                $versionIndex = $match.Groups['version'].Index
                $writeOffset = $preambleLength + $encoding.GetByteCount($text.Substring(0, $versionIndex))
                if (-not $expectedChangedOffsets.Add($writeOffset)) {
                    throw "Safety check failed: duplicate byte offset $writeOffset."
                }
            }

            $actualChangedOffsets = [System.Collections.Generic.HashSet[int]]::new()
            for ($index = 0; $index -lt $bytes.Length; $index++) {
                if ($bytes[$index] -ne $updatedBytes[$index]) {
                    $null = $actualChangedOffsets.Add($index)
                }
            }
            if (-not $expectedChangedOffsets.SetEquals($actualChangedOffsets)) {
                throw 'Safety check failed: the conversion would change bytes outside exact multi_agent_version values.'
            }
            foreach ($writeOffset in $actualChangedOffsets) {
                if ($bytes[$writeOffset] -ne [byte][char]'2' -or $updatedBytes[$writeOffset] -ne [byte][char]'1') {
                    throw "Safety check failed: changed offset $writeOffset is not an exact v2-to-v1 byte change."
                }
            }
            if ($actualChangedOffsets.Count -ne 1) {
                throw "Safety check failed: exactly one validated cache byte offset is required for an update; found $($actualChangedOffsets.Count)."
            }

            $writeOffset = @($actualChangedOffsets)[0]
            $stream.Seek($writeOffset, [System.IO.SeekOrigin]::Begin) | Out-Null
            $writeAttempted = $true
            $stream.WriteByte($updatedBytes[$writeOffset])
            $stream.Flush($true)
            $stream.Seek($writeOffset, [System.IO.SeekOrigin]::Begin) | Out-Null
            $writtenByte = $stream.ReadByte()
            if ($writtenByte -ne $updatedBytes[$writeOffset]) {
                throw "Post-write verification failed at byte offset $writeOffset."
            }
            $writeVerified = $true
            $result = 1
        }
    }
    catch {
        $operationException = $_.Exception
    }
    finally {
        if ($null -ne $stream) {
            try {
                $stream.Dispose()
            }
            catch {
                $disposeException = $_.Exception
            }
        }
    }

    if ($null -ne $operationException -or $null -ne $disposeException) {
        $failureMessages = [System.Collections.Generic.List[string]]::new()
        if ($null -ne $operationException) {
            $failureMessages.Add("Operation failure: $($operationException.Message)")
        }
        if ($null -ne $disposeException) {
            $failureMessages.Add("Dispose failure: $($disposeException.Message)")
        }
        $failureMessage = $failureMessages -join ' '
        $innerException = if ($null -ne $operationException) { $operationException } else { $disposeException }

        if (-not $writeAttempted) {
            throw [System.InvalidOperationException]::new("CACHE_WRITE_NOT_ATTEMPTED: cache update failed before any write attempt; fail closed and retry only from a fresh guarded open. $failureMessage", $innerException)
        }
        if (-not $writeVerified) {
            throw [System.InvalidOperationException]::new("CACHE_WRITE_STATE_UNKNOWN: possibly-partial cache update after a write attempt; the watcher must stop without retrying. $failureMessage", $innerException)
        }
        throw [System.InvalidOperationException]::new("CACHE_WRITE_VERIFIED_CLEANUP_FAILED: cache update was verified before cleanup failed; the watcher must stop without retrying. $failureMessage", $innerException)
    }

    return $result
}

function Get-CodexDesktopAppId {
    $startApp = Get-StartApps |
        Where-Object { $_.AppID -like 'OpenAI.Codex_*!App' } |
        Select-Object -First 1
    if ($null -ne $startApp) { return $startApp.AppID }

    $package = Get-AppxPackage -Name 'OpenAI.Codex' |
        Sort-Object -Property Version -Descending |
        Select-Object -First 1
    if ($null -ne $package) { return "$($package.PackageFamilyName)!App" }

    throw '找不到 Codex Desktop。已檢查開始功能表與本機 AppX 套件。'
}

function Start-CodexDesktop {
    $appId = Get-CodexDesktopAppId
    Write-Host "正在啟動 Codex Desktop：$appId"
    Start-Process -FilePath 'explorer.exe' -ArgumentList "shell:AppsFolder\$appId" -WindowStyle Hidden
}

function Invoke-CodexModelWatcher {
    param(
        [Parameter()]
        [switch]$LaunchCodex
    )

    $resolvedPath = Resolve-ValidatedCodexModelsCachePath -CandidatePath $Path
    $createdNew = $false
    $mutex = [System.Threading.Mutex]::new($true, 'Local\AI_Rules_CodexModelV1Watcher', [ref]$createdNew)
    if (-not $createdNew) {
        $mutex.Dispose()
        Write-Host 'Codex V1 監看器已經在執行。'
        return
    }

    try {
        Write-Warning 'local experimental workaround; not a formal Codex adapter capability; not a platform guarantee. 本機實驗工具，非正式平台能力。'
        Write-Host "監看模型快取：$resolvedPath"
        Write-Host "檢查間隔：$PollIntervalMilliseconds ms；按 Ctrl+C 停止。"
        $codexStarted = -not $LaunchCodex

        while ($true) {
            if (-not [System.IO.File]::Exists($resolvedPath)) {
                if (-not $codexStarted -and $LaunchCodex) {
                    Write-Warning '模型快取尚不存在；依明確要求啟動 Codex Desktop。'
                    Start-CodexDesktop
                    $codexStarted = $true
                }
                if (((Get-Date) - $lastMissingNotice).TotalSeconds -ge 5) {
                    Write-Warning "找不到模型快取，持續等待：$resolvedPath"
                    $lastMissingNotice = Get-Date
                }
            }
            else {
                try {
                    $changed = Set-CodexModelVersionV1 -TargetPath $resolvedPath
                    if ($changed -gt 0) {
                        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
                        Write-Host "[$timestamp] 已以 byte-local 寫入將 $changed 個 multi_agent_version 從 v2 改為 v1。"
                    }
                    if (-not $codexStarted -and $LaunchCodex) {
                        Start-CodexDesktop
                        $codexStarted = $true
                    }
                }
                catch [System.InvalidOperationException] {
                    if ($_.Exception.Message.StartsWith('CACHE_WRITE_NOT_ATTEMPTED:', [System.StringComparison]::Ordinal)) {
                        if (((Get-Date) - $lastBusyNotice).TotalSeconds -ge 5) {
                            Write-Warning "模型快取在嘗試寫入前失敗；本次 fail closed、未嘗試寫入，將以新的路徑檢查與獨占鎖重試：$($_.Exception.Message)"
                            $lastBusyNotice = Get-Date
                        }
                        continue
                    }
                    throw
                }
            }
            Start-Sleep -Milliseconds $PollIntervalMilliseconds
        }
    }
    finally {
        if ($createdNew) { $mutex.ReleaseMutex() }
        $mutex.Dispose()
    }
}

function Show-CodexV1Menu {
    Write-Host ''
    Write-Warning 'local experimental workaround; not a formal Codex adapter capability; not a platform guarantee. 本機實驗工具，非正式平台能力。'
    Write-Host 'Codex V1 模型監看器'
    Write-Host '1. 啟動監看器並開啟 Codex Desktop'
    Write-Host '2. 只啟動監看器'
    Write-Host '3. 離開'
    Write-Host ''

    while ($true) {
        $selection = Read-Host '請選擇 [1-3]'
        switch ($selection) {
            '1' { Invoke-CodexModelWatcher -LaunchCodex; return }
            '2' { Invoke-CodexModelWatcher; return }
            '3' { return }
            default { Write-Warning '請輸入 1-3。' }
        }
    }
}

switch ($Mode) {
    'Watch' { Invoke-CodexModelWatcher }
    'WatchAndLaunch' { Invoke-CodexModelWatcher -LaunchCodex }
    default { Show-CodexV1Menu }
}
