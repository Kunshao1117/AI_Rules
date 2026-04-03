---
trigger: always_on
---

# [CROSS-LINGUAL REASONING GUARD]

## PRE-RESPONSE GATE (中文輸入攔截閘門)

```
[PRE-RESPONSE GATE] Before generating ANY response to Chinese input:
├── Input is trivial (≤5 chars: 繼續/GO/好/對/確認)?
│   └── YES → Skip all phases
├── Is this the FIRST non-trivial Chinese input in this conversation?
│   ├── YES → [COLD START]
│   │         MUST call view_file on cross-lingual-guard SKILL.md
│   │         BEFORE any text output or other tool calls.
│   │         Then output template from loaded content.
│   │         Skipping this = [HALT]
│   │         「🔴 [COLD START HALT] 冷啟動協議未執行。立即補執行。」
│   │         DO NOT continue responding. Load SKILL.md NOW.
│   └── NO  → Warm Cache path (output template from memory, skip view_file)
└── Conversation ≥50 turns OR format drift suspected?
    └── YES → Drift Guard: re-read SKILL.md AFTER template output
```

## Execution Steps (Warm Cache Path)

1. **Defer to Native Thought**: Execute IDE-native internal thought block first.
2. **Output template from memory** (below). Do NOT call `view_file` before this — any tool before the template breaks the IDE thought token.
3. **Proceed directly** after outputting the template. The template IS the transparency mechanism — the Director reviews it and corrects if needed. Do NOT self-assess confidence or gate on echo-back.
4. For write-enabled workflows (/02, /03, /04, /05, /09, /10, /12): double-check your Phase 1 interpretation before executing any destructive action.

## Heuristic Safety Triggers (安全觸發器 — 強制降為 LOW)

Override self-assessed confidence to LOW when ANY condition matches:

- Write-Enabled workflow is active (e.g. /02, /03, /04, /05, /09, /10, /12)
- Negation + degree modifier: 不太/不是很/並非完全/也不算
- Abstract concept with no concrete referent in input
- Reference to prior context without specifics: 你剛說的/之前的/上次那個
- Input >80 chars with no explicit action verb
- Complex conditional: 如果...就.../除非...否則.../只要...但是...
- Multiple possible interpretations exist for a key phrase
- Director previously corrected a similar interpretation in this session

## Memory-Embedded Output Template (記憶模板)

Output this block verbatim after native thought. No tool call needed for warm cache.

```
> <details>
> <summary>🧠 跨語系思維解析 (點擊展開)</summary>
>
> **Phase 0: Workflow Context Awareness**
> - **Trigger**: [填寫觸發來源 (繁體中文)]
> - **Role**: [填寫目前的 Agent 角色 (繁體中文)]
> - **Scope Constraints**: [填寫當前的限制與守備範圍 (繁體中文)]
>
> **Phase 1: 4-Layer Intent Decode**
> - **Layer 1 (字面)**: [填寫字面意義]
> - **Layer 2 (意圖)**: [填寫總監意圖]
> - **Layer 3 (情緒)**: [填寫語氣與情緒]
> - **Layer 4 (隱含)**: [填寫隱含假設]
> </details>

<br>
```
