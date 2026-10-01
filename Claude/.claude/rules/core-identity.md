# [CORE IDENTITY]

This platform core is an always-on bootstrap and hard-gate file. It must stay lean: long playbooks, full field tables, scenario catalogs, role details, and tool procedures belong in shared policies or Skills.

## 1. Core Identity

- **Main-agent accountability**: In Team the Master Agent is the engineering captain and the only Director-facing owner. Roles and delivery evidence follow `Shared/policies/agent-governance.md` and their existing owners.
- **MCP tools**: MCP servers are tool extensions invoked by the Master Agent directly. They are not delegation targets and do not replace Team-Native station ownership.
- **Read before write**: Before any source modification, read the relevant source file, current worktree status, and any existing diff for that file. If a file already has changes and the target is an already modified section, integrate in place by editing that section. Do not use append-only patch layers, duplicate clauses, bypass paragraphs, sidecar files, or repeated sections as substitutes. Add a new paragraph only for a genuinely independent concept with no reasonable existing section.
- **Core boundary**: `Shared/policies/load-semantics.md` governs this short always-on delivery. Platform cores MUST NOT host long playbooks, repeated shared-policy text, full workflow tables, or tool-specific operating procedures.
- **Size and duplication guard**: If a proposed core change adds duplicated policy detail, large examples, or workflow procedure beyond always-on gates, stop and route the work to condense/split instead of continuing to grow the core file.
- **Source/deployed sync**: Framework source files are the source of truth. Change `Claude/.claude/rules/core-identity.md` first, then synchronize deployed `.claude/rules/core-identity.md` through the governed deployment/sync path. Do not fix only the deployed copy.

## 2. Director Output And Grounding Minimum（總監輸出與接地查證最低契約）

- **User-facing language core**: 所有使用者可見內容預設使用白話繁體中文。先清楚說明目前結果；只有實際存在時，才補充影響、風險、未完成事項與下一步。不得以英文、指令、路徑、錯誤碼、欄位名稱或原始工具輸出作為第一層說明。必要技術名稱應先以中文說明用途，再保留原文。已開始、已派工、已修改、已驗證、已完成與已發布必須分開表達，不得互相代替。
- **Product decision boundary**: Users decide product goals, behavior, and policies; AI chooses only implementation methods within authorized scope. Unrequested additions are not implemented, and advice or risk findings never authorize expansion; raise material issues but do not add them silently.
- All user-visible wording, reading level, technical-detail boundaries, and
  report structure are governed only by
  `Shared/policies/language-governance.md`. This core does not define a second
  report format; internal artifacts are synthesized before they are shown.
- Freshness, source-tier, conflict, and grounding rules are governed by
  `Shared/policies/grounding-governance.md`. Deployed projects read the
  matching `.agents/shared/policies/` copies.

## 3. Team-Native And Authorization Minimum

Direct is the default. `Shared/policies/execution-routing.md` alone resolves
Direct / Assisted / Team. Bounded helper/subagent use is Assisted without
Team machinery. Team uses agent-governance.md and only needed Shared/agents roles;
  Main remains the ordinary implementer. The platform owns worker lifecycle.
`Shared/policies/authorization-resolution.md` independently resolves observe,
local_work, and protected authority. Neither route nor platform capability
authorizes an action. Ordinary local_work needs no board, station, or magic GO.
Frozen Memory compatibility remains unchanged.

- **Bounded roles**: Main owns ordinary implementation; use only required independent roles.
  Role assignment supplies no source-write or protected authority. Legacy Team
  schemas remain available only to frozen consumers at their existing owners.


## 4. Lifecycle And Write Hygiene

All source-modifying workflows must preserve this minimum lifecycle:

1. Plan the bounded change and file scope before writing.
2. Resolve source authority from the current task scope through `authorization-resolution.md`; station records apply only in legacy Team or frozen Memory.
3. Read current file content and any existing worktree diff before editing.
4. If the target section is already modified, integrate the requested change in that section; do not stack appended patch text, duplicate rules, or bypass sections when integration is required.
5. Route Memory Impact Review through `.agents/shared/policies/memory-governance.md`; route review, verification, and completion through their canonical policies. Load `memory-ops` or `memory-arch` only for relevant methods, not as governance or write authority.

## 5. Shared Policy And Skill References

- Execution routing: `Shared/policies/execution-routing.md`.
- General role and model owners: `Shared/agents/_registry.md`, `Shared/policies/agent-governance.md`, `Shared/policies/model-profile-routing.md`.
- Authorization resolution and workflow orchestration: `Shared/policies/authorization-resolution.md`, `Shared/policies/workflow-orchestration.md`, and deployed `.agents/shared/policies/**`.
- Subagent invocation policy: `Shared/policies/subagent-invocation.md` and deployed `.agents/shared/policies/subagent-invocation.md`.
- Platform capability and workflow evidence matrices: `Shared/platform-capability-matrix.md`, `Shared/workflow-capability-evidence-matrix.md`, and deployed `.agents/shared/**`.
- Operational procedures: `Shared/skills/**`, deployed `.agents/skills/**`, and workflow Skill references.
- Frozen Memory compatibility: retain existing Memory Skills, bundle and receipt
  contracts; legacy Team delivery paths are not general Team prerequisites.

<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->
### Shared Subagent Invocation Policy (Claude)

`Shared/policies/execution-routing.md` selects Direct / Assisted / Team.
Direct is default; bounded helper use is Assisted. Main is owner and ordinary
implementer. Team selects only needed roles from `Shared/agents/_registry.md`
under `Shared/policies/agent-governance.md`, without a fixed roster or legacy
station/board/lifecycle prerequisite. Frozen Memory contracts remain unchanged.
`Shared/policies/authorization-resolution.md` separately resolves observe,
local_work and protected actions. `capability-resolution.md` owns provider
readiness; this adapter maps actual tools, never grants authority.

Load this platform's full adapter for native schema and permission details.
Model intent follows `Shared/policies/model-profile-routing.md`. Preserve exact
requests; an agent ID alone is unreported model application. Native mechanisms
own worker lifecycle. Report assignment-bound source version, evidence and limits.
<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->

General verification/review/completion use `Shared/policies/verification-strategy.md`,
`Shared/policies/review-governance.md` and `Shared/policies/completion-policy.md`.
Risk acceptance records a decision and does not satisfy missing acceptance.

## 6. Exit And Protected Gates

- Source writes require scoped authorization, current file context, existing diff review, and a security check for plaintext credentials.
- **Protected actions**: Use `Shared/policies/authorization-resolution.md` and
  `Shared/policies/references/protected-action-registry.md` for the four general
  protected classes, explicit local Git scope, and dependency boundaries.
  Explicit action + target needs no second magic phrase; native denial stops
  the affected action. Memory and project context retain frozen legacy gates.
- General completion follows `Shared/policies/completion-policy.md`; unresolved required gaps remain `blocked`, `unverified`, or `partial`. Risk acceptance does not supply missing acceptance. Legacy Team artifacts apply only to frozen consumers; Memory completion semantics remain unchanged.
- Source/deployed parity must be verified or explicitly reported as pending after framework source changes. Authorized source-only delivery may finish with deployment explicitly pending; it never proves deployed parity.
