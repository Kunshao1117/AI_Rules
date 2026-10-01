Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
function Read-Source([string]$relativePath) {
    return Get-Content -LiteralPath (Join-Path $repoRoot $relativePath) -Raw -Encoding UTF8
}

$policy = Read-Source 'Shared/policies/language-governance.md'
$examples = Read-Source 'Shared/policies/references/user-facing-output-examples.md'
$claude = Read-Source 'Claude/.claude/rules/cross-lingual-guard.md'
$antigravity = Read-Source 'Antigravity/.agents/rules/01_cross_lingual_guard.md'
$memoryPush = Read-Source 'Antigravity/.agents/rules/06_memory_push.md'

Describe 'Phase 5A2 human communication source semantics' {
    It 'keeps a single shared human communication owner' {
        $policy | Should Match 'source of truth for language selection'
        $claude | Should Match 'sole owner of Director-facing language'
        $antigravity | Should Match '唯一的對人語言與回報方式正式來源'
    }

    It 'removes universal Claude panels and receipts' {
        $claude | Should Not Match 'Dual-Panel Mode|Always Required.*System Preparation|Absolute Mandate.*Receipt'
        $claude | Should Match 'one natural sentence'
        $claude | Should Match 'receipt is not a universal response requirement'
    }

    It 'removes universal Antigravity panels and receipts' {
        $antigravity | Should Not Match '雙面板模式|每次文字輸出.*實體足跡收據|每次回覆總監時.*receipt'
        $antigravity | Should Match '小工作可以用一句話回答'
        $antigravity | Should Match '不強制面板、工具清單、回合計數或操作收據'
    }

    It 'keeps Claude project Memory on demand and separate from platform auto memory' {
        $claude | Should Match 'project-root `\.agents/memory/`'
        $claude | Should Match 'different platform feature, not an AI_Rules card store'
        $claude | Should Match 'does not trigger a project Memory read'
        $claude | Should Match 'use `memory-ops` on demand'
        $claude | Should Not Match 'On the first response.*Turn=1|讀取 MEMORY.md → 三路徑判斷'
    }

    It 'keeps Antigravity Memory on demand and checkpoint recovery independent' {
        $memoryPush | Should Match '(?m)^trigger: model_decision\r?$'
        $memoryPush | Should Match 'Do not call `memory_list` or read `_map`, `_system`'
        $memoryPush | Should Match 'merely because a conversation started'
        $memoryPush | Should Match 'load `memory-ops` on\s+demand'
        $memoryPush | Should Match 'memory-arch.*only for owner or topology ambiguity'
        $memoryPush | Should Match 'frozen_memory_action'
        $memoryPush | Should Match '02_session_checkpoint_recovery.md'
        $antigravity | Should Not Match '系統準備清單中的 `Turn=1` 承諾行|執行記憶啟動探測（memory_list'
        $memoryPush | Should Not Match '系統準備清單中的 `Turn=1` 承諾行'
    }

    It 'allows proportionate plain Taiwan Chinese and preserves exact identifiers' {
        $policy | Should Match 'natural Taiwan Traditional Chinese'
        $policy | Should Match 'Correct language and understandable language are separate requirements'
        $policy | Should Match 'A small completed task may take one natural sentence'
        $policy | Should Not Match 'normally needs three to six sentences|may answer in three to six'
        $policy | Should Match 'runtime.*實際運作環境'
        $policy | Should Match '(?s)preflight.{0,80}部署前檢查'
        $policy | Should Match 'Translate meaning, not merely terminology'
        $policy | Should Match 'PROBABLE_FRAMEWORK_OWNED'
    }

    It 'keeps examples as references and covers outcome, failures, and evidence' {
        $examples | Should Match 'manual-review aids'
        $examples | Should Match '極小工作可以一句話'
        $examples | Should Match '修改後做了局部驗證'
        $examples | Should Match '失敗發生在開始前'
        $examples | Should Match '中途失敗，但已回復'
        $examples | Should Match '中途失敗，回復狀態不確定'
        $examples | Should Match '大型工程先讓人看懂進度'
        $examples | Should Match '完整工程證據放在第二層'
    }

    It 'separates preference from execution authorization and avoids repeated approval for in-scope checks' {
        $examples | Should Match 'B 基本上同意，但還要再想一下'
        $examples | Should Match '不會開始需要正式授權的操作'
        $examples | Should Match '若指定檢查在這次授權範圍內，我會接著執行'
        $policy | Should Match 'does not change.*authorization fact'
    }

    It 'keeps human synthesis with the main reporting owner and prompt handoff on demand' {
        $policy | Should Match 'Main Agent or active captain synthesizes it'
        $policy | Should Not Match 'every reply.*Codex prompt|每次回覆.*Claude prompt'
    }
}
