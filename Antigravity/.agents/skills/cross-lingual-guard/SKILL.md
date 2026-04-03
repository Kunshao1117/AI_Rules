---
name: cross-lingual-guard
description: >
  Chinese intent decoding protocol (Phase 0+1 template embedded in 00_core_identity).
  Call `view_file` on this SKILL.md ONLY IF format drift is suspected (50+ turn conversations).
  Use when: 處理繁體中文輸入的語意理解、意圖解碼、跨語系推理防護。
metadata:
  author: antigravity
  version: "2.1"
  origin: framework
  memory_awareness: none
  tool_scope: ["reasoning"]
---

# Cross-Lingual Guard — Chinese Intent Decoding Protocol

## 0. Cold Start Self-Check (冷啟動自檢)

```
If you are reading this file via Cold Start:
├── Have you already output any text to the Director?
│   ├── YES → Output 「🔴 [COLD START LATE] 冷啟動延遲執行。」 then proceed with template.
│   └── NO  → Correct. Proceed to output template below.
└── If you are reading this via Drift Guard (≥50 turns):
    └── Proceed normally, this self-check does not apply.
```

## 1. Activation Scope (面板啟動判定樹)

```
每次收到總監輸入時，嚴格依據以下條件決定「單框或雙框」的輸出模式：
├── Condition A (單框查核模式): 
│   符合以下任一條件，代表無須進行語意解碼：
│   1. 單句字元長度 ≤ 5 (例如 `GO`, `繼續`, `好的`)
│   2. 輸入為純工作流陣列，背後未附帶任何後續中文指示 (例如純粹的 `@[/03_build]`)
│   └── Action: 僅輸出單框 `🤖 系統作業準備清單`，直接展示前次足跡與預備動作。嚴禁輸出語意分析框，節省 Token。
│
└── Condition B (雙框完整模式):
    不符合 Condition A 的所有狀況。
    └── Action: 必須輸出雙框。先印出 `🧠 跨語系思維解析` 破解弦外之音，緊接著印出 `🤖 系統作業準備清單`。
```

## 2. Phase 0: Workflow Context Awareness

```
Workflow command present? (Matches `/[0-9]{2}_[a-zA-Z_]+` or `@[/.*]`)
├── Yes (e.g. /03_build, /04_fix) → Extract metadata:
│         ├── Role (Reader/Writer/Worker)
│         ├── Write permission (read-only vs write-enabled)
│         ├── Scope constraints (what actions are allowed)
│         └── Use these to NARROW interpretation of Chinese payload
│
│   Workflow classification:
│   ├── Read-Only workflows (/00, /01, /06, /07, /08, /11)
│   │   → Echo threshold: RELAXED
│   │   → Misinterpretation damage: recoverable
│   │
│   └── Write-Enabled workflows (/02, /03, /04, /05, /09, /10, /12)
│       → Echo threshold: STRICT
│       → Misinterpretation damage: high
│
└── No workflow → Treat as ad-hoc conversation
    → Echo threshold: MODERATE
    → No workflow context to narrow interpretation
```

## 3. Phase 1: 4-Layer Intent Decode (User-Facing)

**CRITICAL CONSTRAINTS (死亡鐵律):**
1. **Adaptive Output Ordering (自適應輸出順序)**: This `<details>` block MUST adaptively position itself immediately AFTER any IDE-native internal thought blocks, but strictly BEFORE invoking ANY external tools (e.g. `<call:...>`). Do NOT attempt to place it inside or before the native thought block. This ensures real-time UI visibility without colliding with base system prompts.
2. **Strict Verbatim Format (嚴格格式)**: You MUST replicate the exact Markdown syntax (`**Phase 0...**`, `**Phase 1...**`) below. Do NOT abstract or simplify the headers.
3. **Chinese-Only Content (純中文內容)**: Phase 0 and Phase 1 content MUST be 100% Traditional Chinese. English is STRICTLY FORBIDDEN inside the `<details>` block.
4. **English Reasoning Delegation (英文推理委託)**: ALL English logical analysis, planning, and step decomposition MUST occur exclusively inside the IDE's native hidden thought block (`> Thought for Xs`). Do NOT output ANY English reasoning in the `<details>` block or anywhere in the user-facing text layer.

To comply with the Dual-Audience Architecture (Bridge Layer), use the exact following hybrid formatting according to the Activation Scope:

**[Condition B Only] Semantic Decode Block:**
```html
> <details>
> <summary>🧠 跨語系思維解析 (點擊展開)</summary>
> 
> **Phase 0: Workflow Context Awareness**
> - **Trigger**: [填寫觸發來源 (繁體中文)]
> - **Role**: [填寫目前的 Agent 角色 (繁體中文)]
> - **Scope Constraints**: [填寫當前的限制與守備範圍 (繁體中文)]
> 
> **Phase 1: 4-Layer Intent Decode**
> - **Layer 1 (字面)**: [填寫字面意義的繁體中文描述]
> - **Layer 2 (意圖)**: [填寫總監意圖的繁體中文描述]
> - **Layer 3 (情緒)**: [填寫語氣與情緒的繁體中文描述]
> - **Layer 4 (隱含)**: [填寫隱含假設的繁體中文描述]
> </details>

<br>
```

**[Always Required] System Preparation Block:**
```html
> <details>
> <summary>🤖 系統作業準備清單 (點擊展開)</summary>
> 
> - **參考知識區**: [強制掃描清單，填入對應的 SKILL.md，或寫 不適用]
> - **實體操作工具**: [填入對應的 MCP 或原生工具名稱，或寫 None]
> - **歷史防偽查驗 (歷史 Turn 追溯)**: [強制作為：往前回顧對話歷史，找出上一回合 AI 回覆最底部的 Turn 數字。若上一回合為 Turn: 17，此處必須精準印出 (讀取到 Turn: 17，核對無誤)。若為新對話則填寫 None。嚴禁填寫 +1 等無意義字串！]
> - **決策與應變機制**: [具體宣告接下來的宣告或呼叫動作]
> </details>

<br>
```
Do not perform this analysis mentally.

For the Chinese payload (text AFTER workflow command), decode four layers:

### Layer 1 — Surface (字面)
Extract literal meaning of each clause.

### Layer 2 — Intent (意圖)
Determine what action the speaker expects:
```
Action type?
├── Request information → answer / explain
├── Request action → build / fix / search / test
├── Express disagreement → change approach / rethink
├── Redirect direction → pivot to different angle
├── Confirm/approve → proceed as planned
└── Uncertain → flag for echo-back
```

### Layer 3 — Tone (情緒)
Assess speaker's attitude:
```
Tone markers?
├── Positive: 很好/不錯/可以/同意 → satisfaction
├── Mild negative: 不太/好像不/感覺怪怪 → gentle correction
├── Strong negative: 不對/不合理/完全錯 → firm rejection
├── Exploratory: 如果/可能/或許/要不要 → brainstorming
├── Impatient: 直接/快/不用解釋 → wants speed
└── Neutral → no adjustment needed
```

### Layer 4 — Implicit (隱含)
Identify unstated assumptions:
```
Check for:
├── Omitted subject → who is performing the action?
├── Omitted object → what is being acted upon?
├── Assumed context → references to previous conversation?
├── Degree of statement → '不太' (slightly not) vs '不' (not) vs '完全不' (absolutely not)
└── Cultural implicature → politeness masking strong opinion?
```

## 4. Phase 2: Tool & Skill Routing (實體武裝檢核)

Bridge the semantic intent to actionable tool execution.
```text
Identify specific tooling hooks:
├── Semantic Concept matches available Skill? → List SKILL.md name.
├── Concept requires external capabilities? → List MCP tool name.
├── No tool/skill covers the scope? → 'None'. Prepare Capability Gap Alert (能力缺口警報) and fallback gracefully (Zero-Shot) while recommending `/12` or MCP integration.
└── Action Decision MUST explicitly promise to call `view_file` or tool. Do NOT blindly rely on LLM prior data when a tool exists.
```

## 5. English Reasoning — Native Thought Delegation

```
ALL English reasoning MUST occur inside the IDE's native thought block.
├── Do NOT output English text in the <details> block
├── Do NOT output English text anywhere in the user-facing response
├── The native thought block handles: logical analysis, planning, step decomposition
└── After native thought completes → Map conclusions to Traditional Chinese output per Core Mandate §5
```

## 6. Confidence-Gated Echo

```
Self-assess confidence in interpretation:
├── HIGH → Proceed silently
├── MEDIUM → Proceed, prefix response with one-line intent summary: 「執行方向：___」
└── LOW → Echo-back before acting:
          Output: 「我理解您的意思是：___。是否正確？」
```

### Heuristic Safety Triggers (force confidence to LOW)

Override self-assessed confidence to LOW when ANY condition matches:

```
├── Write-Enabled workflow is active (e.g. /02, /03, /04, /05, /09, /10, /12)
├── Negation + degree modifier: 不太/不是很/並非完全/也不算
├── Abstract concept with no concrete referent in input
├── Reference to prior context without specifics: 你剛說的/之前的/上次那個
├── Input > 80 chars with no explicit action verb
├── Complex conditional: 如果...就.../除非...否則.../只要...但是...
├── Multiple possible interpretations exist for a key phrase
└── Director previously corrected a similar interpretation in this session
```

## 7. Execution Receipt Mandate (實體足跡收據與時序鐵律)

```
Whenever you reply to the Director, you MUST unconditionally append a holographic execution receipt at the absolute END of your final text response.
├── Step 1 (Read Past): Scan the conversation history for your last outputted receipt. Extract its `Turn` number (e.g., `Turn: 17`). If none exists, start at 1.
├── Step 2 (Calculate): Add 1 to the past Turn number. (e.g., `17 + 1 = 18`). DO NOT output '+1' literally. You MUST output the calculated integer!
├── Format: Format as a multi-line markdown list for readability.
```markdown
**【實體足跡收據】**
- **對話次序 (Turn)**: {計算後的絕對數字}
- **實體ＩＤ (Step)**: {IDE回傳的ID清單}
- **呼叫工具 (Tool)**: {名稱}(次數)
```
├── Example:
```markdown
**【實體足跡收據】**
- **對話次序 (Turn)**: 18
- **實體ＩＤ (Step)**: 345, 346
- **呼叫工具 (Tool)**: multi_replace_file_content(x1)
```
└── Absolute Ban: Even if you used NO tools, you MUST still output the receipt with `實體ＩＤ: None` and `呼叫工具: 無`. The Turn sequence must NEVER be broken!
```

## Gotchas

- ⚠️ Phase 0 and Phase 1 go inside the `<details><summary>` HTML block. English reasoning does NOT — it stays in the native thought block.
- ⚠️ Do NOT generate the Chinese analysis outside of the collapsible details block.
- ⚠️ When echo-back triggers, keep it concise (1-3 bullet points). Do NOT echo the entire 4-layer analysis.
- ⚠️ `// turbo` annotated workflow steps: skip echo-back even if confidence is LOW.
- ⚠️ **Markdown Render Trap:** When outputting the blockquote boxed HTML template (`> <details>...`), the `> ` prefix MUST STOP precisely at the `> </details>` line. Do NOT prepend `> ` to the conversational text that follows, otherwise the rendered interface box will erroneously trap the Director-facing dialogue.

## Constraints

- SKILL.md is written in English (Instruction Layer) to avoid self-referential tokenization damage
- This skill does NOT change the underlying tokenizer — it mitigates drift at the reasoning level
- This skill does NOT replace workflow-specific constraints — it augments them
- Echo-back is a SAFETY NET, not a default behavior — most interactions should pass silently
