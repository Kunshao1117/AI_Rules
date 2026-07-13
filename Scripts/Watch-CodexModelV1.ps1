# Local experimental workaround only; not a formal Codex adapter capability and not a platform guarantee.
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Path = (Join-Path $env:USERPROFILE '.codex\models_cache.json'),

    [Parameter()]
    [ValidateRange(100, 60000)]
    [int]$PollIntervalMilliseconds = 250,

    [Parameter()]
    [ValidateSet('Menu', 'Watch', 'WatchAndLaunch')]
    [string]$Mode = 'Menu'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pattern = '(?<prefix>"multi_agent_version"\s*:\s*)"v2"'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$utf8WithBom = [System.Text.UTF8Encoding]::new($true)
$lastMissingNotice = [datetime]::MinValue
$lastBusyNotice = [datetime]::MinValue

function Set-CodexModelVersionV1 {
    param(
        [Parameter(Mandatory)]
        [string]$TargetPath
    )

    $stream = $null

    try {
        # Codex may keep reading while this process temporarily blocks writers.
        # The v2 -> v1 replacement has the same byte length.
        $stream = [System.IO.File]::Open(
            $TargetPath,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::ReadWrite,
            [System.IO.FileShare]::Read
        )

        $bytes = [byte[]]::new([int]$stream.Length)
        $offset = 0

        while ($offset -lt $bytes.Length) {
            $read = $stream.Read($bytes, $offset, $bytes.Length - $offset)
            if ($read -eq 0) {
                break
            }
            $offset += $read
        }

        if ($offset -ne $bytes.Length) {
            throw "Could not read the complete model cache. Read $offset of $($bytes.Length) bytes."
        }

        $hasBom = $bytes.Length -ge 3 -and
            $bytes[0] -eq 0xEF -and
            $bytes[1] -eq 0xBB -and
            $bytes[2] -eq 0xBF
        $encoding = if ($hasBom) { $utf8WithBom } else { $utf8NoBom }
        $preambleLength = if ($hasBom) { 3 } else { 0 }
        $text = $encoding.GetString($bytes, $preambleLength, $bytes.Length - $preambleLength)
        $matches = [regex]::Matches($text, $pattern)

        if ($matches.Count -eq 0) {
            return 0
        }

        $updated = [regex]::Replace($text, $pattern, '${prefix}"v1"')
        $contentBytes = $encoding.GetBytes($updated)
        $updatedBytes = if ($hasBom) {
            $preamble = $encoding.GetPreamble()
            $combined = [byte[]]::new($preamble.Length + $contentBytes.Length)
            [Array]::Copy($preamble, 0, $combined, 0, $preamble.Length)
            [Array]::Copy($contentBytes, 0, $combined, $preamble.Length, $contentBytes.Length)
            $combined
        }
        else {
            $contentBytes
        }

        if ($updatedBytes.Length -ne $bytes.Length) {
            throw 'Safety check failed: replacement changed the cache file length.'
        }

        $stream.Position = 0
        $stream.Write($updatedBytes, 0, $updatedBytes.Length)
        $stream.Flush($true)

        return $matches.Count
    }
    finally {
        if ($null -ne $stream) {
            $stream.Dispose()
        }
    }
}

function Get-CodexDesktopAppId {
    $startApp = Get-StartApps |
        Where-Object { $_.AppID -like 'OpenAI.Codex_*!App' } |
        Select-Object -First 1

    if ($null -ne $startApp) {
        return $startApp.AppID
    }

    $package = Get-AppxPackage -Name 'OpenAI.Codex' |
        Sort-Object -Property Version -Descending |
        Select-Object -First 1

    if ($null -ne $package) {
        return "$($package.PackageFamilyName)!App"
    }

    throw '找不到 Codex Desktop。已檢查開始功能表與本機 AppX 套件。'
}

function Start-CodexDesktop {
    $appId = Get-CodexDesktopAppId
    Write-Host "正在啟動 Codex Desktop：$appId"
    Start-Process -FilePath 'explorer.exe' -ArgumentList "shell:AppsFolder\$appId"
}

function Invoke-CodexModelWatcher {
    param(
        [Parameter()]
        [switch]$LaunchCodex
    )

    $resolvedPath = [System.IO.Path]::GetFullPath($Path)
    $createdNew = $false
    $mutex = [System.Threading.Mutex]::new(
        $true,
        'Local\AI_Rules_CodexModelV1Watcher',
        [ref]$createdNew
    )

    if (-not $createdNew) {
        $mutex.Dispose()
        Write-Host 'Codex V1 監看器已經在執行。'

        if ($LaunchCodex) {
            Start-Sleep -Milliseconds ([Math]::Max($PollIntervalMilliseconds * 2, 500))
            Start-CodexDesktop
        }

        return
    }

    try {
        Write-Host "監看模型快取：$resolvedPath"
        Write-Host "檢查間隔：$PollIntervalMilliseconds ms；按 Ctrl+C 停止。"

        $codexStarted = -not $LaunchCodex

        while ($true) {
            if (-not [System.IO.File]::Exists($resolvedPath)) {
                if (-not $codexStarted) {
                    Write-Warning '模型快取尚不存在，先啟動 Codex；第一個新對話可能來不及套用 V1。'
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
                        Write-Host "[$timestamp] 已將 $changed 個 multi_agent_version 從 v2 改回 v1。"
                    }

                    if (-not $codexStarted) {
                        Start-CodexDesktop
                        $codexStarted = $true
                    }
                }
                catch [System.IO.IOException] {
                    if (((Get-Date) - $lastBusyNotice).TotalSeconds -ge 5) {
                        Write-Warning "模型快取正在使用中，將自動重試：$($_.Exception.Message)"
                        $lastBusyNotice = Get-Date
                    }
                }
                catch [System.UnauthorizedAccessException] {
                    if (((Get-Date) - $lastBusyNotice).TotalSeconds -ge 5) {
                        Write-Warning "模型快取目前不可寫入，將自動重試：$($_.Exception.Message)"
                        $lastBusyNotice = Get-Date
                    }
                }
            }

            Start-Sleep -Milliseconds $PollIntervalMilliseconds
        }
    }
    finally {
        if ($createdNew) {
            $mutex.ReleaseMutex()
        }
        $mutex.Dispose()
    }
}

function Show-CodexV1Menu {
    Write-Host ''
    Write-Host 'Codex V1 模型監看器'
    Write-Host '1. 啟動監看器並開啟 Codex Desktop'
    Write-Host '2. 只啟動監看器'
    Write-Host '3. 離開'
    Write-Host ''

    while ($true) {
        $selection = Read-Host '請選擇 [1-3]'

        switch ($selection) {
            '1' {
                Invoke-CodexModelWatcher -LaunchCodex
                return
            }
            '2' {
                Invoke-CodexModelWatcher
                return
            }
            '3' {
                return
            }
            default {
                Write-Warning '請輸入 1、2 或 3。'
            }
        }
    }
}

switch ($Mode) {
    'Watch' {
        Invoke-CodexModelWatcher
    }
    'WatchAndLaunch' {
        Invoke-CodexModelWatcher -LaunchCodex
    }
    default {
        Show-CodexV1Menu
    }
}
